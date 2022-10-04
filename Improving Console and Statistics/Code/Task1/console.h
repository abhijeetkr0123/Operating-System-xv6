#include "types.h"

#define UP_KEY 0xE2
#define DOWN_KEY 0xE3
#define LEFT_KEY 0xE4
#define RIGHT_KEY 0xE5

// Clears the current line on the console screen
void clearLineOnConsole(void);
// Copies currently displayed line to Buf0 and store length on structure created 
void copyLineToBuf0(void);
//  Erase all content of current command
void eraseCurrentCommand();
//  Prints the given buf on console
void printBufToConsole(char *bufToPrintOnScreen, uint length);
//  Copying the given buf to Input.buf
//  input.r, input.w, input.rightmost, input.e all at position 0
void copyBufferToInputBuf(char *bufToSaveInInput, uint length);
// Copying current command in input.buf to saved history table
void savingToHistoryTable();
// Function that gets called by the sys_history
int history(char *buffer, int historyId);
