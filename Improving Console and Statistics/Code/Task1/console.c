// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
// Created a header file beacuse same macros/functions are used in different files also e.g. sysproc.c
#include "console.h"

static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

// prints an integer to console
static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

// Freezes CPU before printing message parameter 
void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

// Prints each character to the console
static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  } 
  else if(c==LEFT_KEY){
    if(pos > 0) --pos;
  }
  else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  if(c==BACKSPACE)
    crt[pos] = ' ' | 0x0700;
}
// cgaputc() used for printing on QEMU console
// uartputc() used for printing on Unix console
// This fuction also updates the Unix console when something on QEMU console is typed
void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  }
  else if(c==LEFT_KEY){
    uartputc('\b');
  } 
  else
    uartputc(c);
  cgaputc(c);
}

// Maximum possible size of the command that can be written into the buffer
#define INPUT_BUF 128
// Maximum permissible commands that can be stored in buffer for history command
#define MAX_HISTORY 16
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index: Start of the written command
  uint w;  // Write index: End of the written command
  uint e;  // Edit index: Caret position on the written command
  uint rightmost;  // Rightmost empty char in the currently written command
} input;

// Temp char array to store input.buf
char intermediateMovingBuffer[INPUT_BUF];

// User defined struct for storing the commands in the history buffer array
struct {
  // Stores all the commands once written into the console
  char bufferArr[MAX_HISTORY][INPUT_BUF];
  // Stores lengths of all the commands once written into the console
  uint lengthsArr[MAX_HISTORY]; 
  // Last command written into the console index
  uint lastCommandIndex;
  // Stores number of history commands in buffer
  int numOfCommmandsInMem;  
  // 0:Newest command ..... 15: Oldest command 
  // Stores the current history output values
  int currentHistoryView; 
} historyBufferArray;

// For holding the command that was written before accessing UP/DOWN keys
char Buf0[INPUT_BUF];  
uint lengthOfBuf0;

#define C(x)  ((x)-'@')  // Control-x

// Copying input.buf to intermediateMovingBuffer
// Why? Caret is not at input.rightmost and entering characters in between
void copyTointermediateMovingBuffer() {
  uint n = input.rightmost - input.r;
  for(uint i = 0; i < n; i++){
    intermediateMovingBuffer[i] = input.buf[(input.e + i) % INPUT_BUF];
  }
}

// Shifting input.buf one positon to right and printing back to console
void shiftbufright() {
  uint n = input.rightmost - input.e;
  for (uint i = 0; i < n; i++) {
    input.buf[(input.e + i) % INPUT_BUF] = intermediateMovingBuffer[i];
    consputc(intermediateMovingBuffer[i]);
  }
  // reset intermediateMovingBuffer for next time 
  memset(intermediateMovingBuffer, '\0', INPUT_BUF);
  // Taking caret to correct position
  for (uint i = 0; i < n; i++) {
    consputc(LEFT_KEY);
  }
}

// Shifting input.buf one positon to left and printing back to console
// Why? Using BACKSPACE in between
void shiftbufleft() {
  uint n = input.rightmost - input.e;
  consputc(LEFT_KEY);
  input.e--;
  for (uint i = 0; i < n; i++) {
    char c = input.buf[(input.e + i + 1) % INPUT_BUF];
    input.buf[(input.e + i) % INPUT_BUF] = c;
    consputc(c);
  }
  input.rightmost--;
  consputc(' ');  // delete the last char in line
  // Taking caret to correct position
  for (uint i = 0; i <= n; i++) {
    consputc(LEFT_KEY); 
  }
}

// Handles interrupts in consoles
void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;
  uint tempIndex;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.rightmost != input.e && input.e != input.w)
      { // caret isn't at the end 
        shiftbufleft();
        break;
      }
      if (input.e != input.w)
      { // caret is at the end 
        input.e--;
        input.rightmost--;
        consputc(BACKSPACE);
      }
      break;
    case LEFT_KEY:
      if (input.e != input.w) {
        input.e--;
        consputc(c);
      }
      break;
    case RIGHT_KEY:
      if (input.e < input.rightmost) {
        consputc(input.buf[input.e % INPUT_BUF]);
        input.e++;
      } else if (input.e == input.rightmost) {
        consputc(' ');
        consputc(LEFT_KEY);
      }
      break;
    case UP_KEY:
      if (historyBufferArray.currentHistoryView < historyBufferArray.numOfCommmandsInMem -1) 
      {  
        clearLineOnConsole();
        if (historyBufferArray.currentHistoryView == -1)
          copyLineToBuf0();
        eraseCurrentCommand();
        historyBufferArray.currentHistoryView++;
        tempIndex = (historyBufferArray.lastCommandIndex + historyBufferArray.currentHistoryView) % MAX_HISTORY;
        printBufToConsole(historyBufferArray.bufferArr[tempIndex], historyBufferArray.lengthsArr[tempIndex]);
        copyBufferToInputBuf(historyBufferArray.bufferArr[tempIndex], historyBufferArray.lengthsArr[tempIndex]);
      }
      break;
    case DOWN_KEY:
      switch (historyBufferArray.currentHistoryView) {
        case -1:
          break;
        case 0:  // get string from Buf0
          clearLineOnConsole();
          copyBufferToInputBuf(Buf0, lengthOfBuf0);
          printBufToConsole(Buf0, lengthOfBuf0);
          historyBufferArray.currentHistoryView--;
          break;
        default:
          clearLineOnConsole();
          historyBufferArray.currentHistoryView--;
          tempIndex = (historyBufferArray.lastCommandIndex + historyBufferArray.currentHistoryView) % MAX_HISTORY;
          printBufToConsole(historyBufferArray.bufferArr[tempIndex], historyBufferArray.lengthsArr[tempIndex]);
          copyBufferToInputBuf(historyBufferArray.bufferArr[tempIndex], historyBufferArray.lengthsArr[tempIndex]);
          break;
      }
      break;
    case '\n': case '\r':
      input.e = input.rightmost;
    default:
      if (c != 0 && input.e - input.r < INPUT_BUF) {
        c = (c == '\r') ? '\n' : c;
        if (input.rightmost > input.e) {  // caret isn't at the end 
          copyTointermediateMovingBuffer();
          input.buf[input.e++ % INPUT_BUF] = c;
          input.rightmost++;
          consputc(c);
          shiftbufright();
        } else {
          input.buf[input.e++ % INPUT_BUF] = c;
          input.rightmost = input.e - input.rightmost == 1 ? input.e : input.rightmost;
          consputc(c);
        }
        if (c == '\n' || c == C('D') || input.rightmost == input.r + INPUT_BUF) {
          savingToHistoryTable();
          input.w = input.rightmost;
          wakeup(&input.r);
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

// Clear the current line from screen
void clearLineOnConsole(void) {
  uint numToEarase = input.rightmost - input.r;
  for (uint i = 0; i < numToEarase; i++) {
    consputc(BACKSPACE);
  }
}

// Copies currently displayed line to Buf0 and store length on structure created
void copyLineToBuf0(void) {
  lengthOfBuf0 = input.rightmost - input.r;
  for (uint i = 0; i < lengthOfBuf0; i++) {
    Buf0[i] = input.buf[(input.r + i) % INPUT_BUF];
  }
}

//  Erase all content of current command 
void eraseCurrentCommand() {
  input.rightmost = input.r;
  input.e = input.r;
}

//  Prints the given buf on console
void printBufToConsole(char *bufToPrintOnScreen, uint length) {
  for (uint i = 0; i < length; i++) {
    consputc(bufToPrintOnScreen[i]);
  }
}

//  Copying the given buf to Input.buf
//  input.r, input.w, input.rightmost, input.e all at position 0
void copyBufferToInputBuf(char *bufToSaveInInput, uint length) {
  for (uint i = 0; i < length; i++) {
    input.buf[(input.r + i) % INPUT_BUF] = bufToSaveInInput[i];
  }
  input.e = input.r + length;
  input.rightmost = input.e;
}

// Copying current command in input.buf to saved history table
void savingToHistoryTable() {
  historyBufferArray.currentHistoryView = -1;  
  if (historyBufferArray.numOfCommmandsInMem < MAX_HISTORY)
    historyBufferArray.numOfCommmandsInMem++; 
  uint l = input.rightmost - input.r - 1;
  historyBufferArray.lastCommandIndex = (historyBufferArray.lastCommandIndex - 1) % MAX_HISTORY;
  historyBufferArray.lengthsArr[historyBufferArray.lastCommandIndex] = l;
  for (uint i = 0; i < l; i++) {
    historyBufferArray.bufferArr[historyBufferArray.lastCommandIndex][i] = input.buf[(input.r + i) % INPUT_BUF];
  }
}

// Function that gets called by the sys_history 
int history(char *buffer, int historyId) {
  if (historyId < 0 || historyId > MAX_HISTORY - 1) return 2;
  if (historyId >= historyBufferArray.numOfCommmandsInMem) return 1;
  memset(buffer, '\0', INPUT_BUF);
  int tempIndex = (historyBufferArray.lastCommandIndex + historyId) % MAX_HISTORY;
  memmove(buffer, historyBufferArray.bufferArr[tempIndex], historyBufferArray.lengthsArr[tempIndex]);
  return 0;
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);

  historyBufferArray.numOfCommmandsInMem = 0;
  historyBufferArray.lastCommandIndex = 0;
}
