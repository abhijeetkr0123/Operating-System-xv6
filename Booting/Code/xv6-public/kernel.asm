
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 39 10 80       	mov    $0x801039d0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 00 7b 10 80       	push   $0x80107b00
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 11 4d 00 00       	call   80104d70 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 7b 10 80       	push   $0x80107b07
80100097:	50                   	push   %eax
80100098:	e8 93 4b 00 00       	call   80104c30 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 03 4e 00 00       	call   80104ef0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 49 4e 00 00       	call   80104fb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 4a 00 00       	call   80104c70 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 7f 2a 00 00       	call   80102c10 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 0e 7b 10 80       	push   $0x80107b0e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 49 4b 00 00       	call   80104d10 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 33 2a 00 00       	jmp    80102c10 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 1f 7b 10 80       	push   $0x80107b1f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 08 4b 00 00       	call   80104d10 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 4a 00 00       	call   80104cd0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 cc 4c 00 00       	call   80104ef0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 3b 4d 00 00       	jmp    80104fb0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 7b 10 80       	push   $0x80107b26
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  return 0;
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 26 1f 00 00       	call   801021d0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 3a 4c 00 00       	call   80104ef0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 20 10 11 80       	mov    0x80111020,%eax
801002cb:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 20 10 11 80       	push   $0x80111020
801002e5:	e8 c6 45 00 00       	call   801048b0 <sleep>
    while(input.r == input.w){
801002ea:	a1 20 10 11 80       	mov    0x80111020,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 3f 00 00       	call   801042f0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 9d 4c 00 00       	call   80104fb0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 d4 1d 00 00       	call   801020f0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a a0 0f 11 80 	movsbl -0x7feef060(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 46 4c 00 00       	call   80104fb0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 7d 1d 00 00       	call   801020f0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 20 10 11 80       	mov    %eax,0x80111020
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 7e 2e 00 00       	call   80103230 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 2d 7b 10 80       	push   $0x80107b2d
801003bb:	e8 30 03 00 00       	call   801006f0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 27 03 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 c7 8a 10 80 	movl   $0x80108ac7,(%esp)
801003d0:	e8 1b 03 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 49 00 00       	call   80104d90 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 7b 10 80       	push   $0x80107b41
801003f1:	e8 fa 02 00 00       	call   801006f0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	89 c6                	mov    %eax,%esi
80100417:	53                   	push   %ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 6a 01 00 00    	je     80100590 <consputc.part.0+0x180>
  else if(c == LEFT_ARROW){
80100426:	83 f8 4b             	cmp    $0x4b,%eax
80100429:	0f 84 49 01 00 00    	je     80100578 <consputc.part.0+0x168>
    uartputc(c);
8010042f:	83 ec 0c             	sub    $0xc,%esp
80100432:	50                   	push   %eax
80100433:	e8 b8 62 00 00       	call   801066f0 <uartputc>
80100438:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043b:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100440:	b8 0e 00 00 00       	mov    $0xe,%eax
80100445:	89 da                	mov    %ebx,%edx
80100447:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100448:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010044d:	89 ca                	mov    %ecx,%edx
8010044f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100450:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100453:	89 da                	mov    %ebx,%edx
80100455:	b8 0f 00 00 00       	mov    $0xf,%eax
8010045a:	c1 e7 08             	shl    $0x8,%edi
8010045d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010045e:	89 ca                	mov    %ecx,%edx
80100460:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100461:	0f b6 d8             	movzbl %al,%ebx
80100464:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100466:	83 fe 0a             	cmp    $0xa,%esi
80100469:	0f 84 a1 00 00 00    	je     80100510 <consputc.part.0+0x100>
  else if(c == BACKSPACE){
8010046f:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100475:	0f 84 85 00 00 00    	je     80100500 <consputc.part.0+0xf0>
  else if(c == LEFT_ARROW){
8010047b:	83 fe 4b             	cmp    $0x4b,%esi
8010047e:	0f 84 7c 00 00 00    	je     80100500 <consputc.part.0+0xf0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f 2a 01 00 00    	jg     801005cd <consputc.part.0+0x1bd>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	0f 8f 81 00 00 00    	jg     80100530 <consputc.part.0+0x120>
801004af:	0f b6 c7             	movzbl %bh,%eax
801004b2:	88 5d e7             	mov    %bl,-0x19(%ebp)
801004b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004b8:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004bd:	b8 0e 00 00 00       	mov    $0xe,%eax
801004c2:	89 fa                	mov    %edi,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ca:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
801004ce:	89 ca                	mov    %ecx,%edx
801004d0:	ee                   	out    %al,(%dx)
801004d1:	b8 0f 00 00 00       	mov    $0xf,%eax
801004d6:	89 fa                	mov    %edi,%edx
801004d8:	ee                   	out    %al,(%dx)
801004d9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004dd:	89 ca                	mov    %ecx,%edx
801004df:	ee                   	out    %al,(%dx)
  if(c == BACKSPACE)
801004e0:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801004e6:	75 0d                	jne    801004f5 <consputc.part.0+0xe5>
    crt[pos] = ' ' | 0x0700;
801004e8:	b8 20 07 00 00       	mov    $0x720,%eax
801004ed:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004f4:	80 
}
801004f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004f8:	5b                   	pop    %ebx
801004f9:	5e                   	pop    %esi
801004fa:	5f                   	pop    %edi
801004fb:	5d                   	pop    %ebp
801004fc:	c3                   	ret    
801004fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(pos>0) --pos;
80100500:	85 db                	test   %ebx,%ebx
80100502:	0f 84 b8 00 00 00    	je     801005c0 <consputc.part.0+0x1b0>
80100508:	83 eb 01             	sub    $0x1,%ebx
8010050b:	eb 8a                	jmp    80100497 <consputc.part.0+0x87>
8010050d:	8d 76 00             	lea    0x0(%esi),%esi
    pos += 80 - pos%80;
80100510:	89 d8                	mov    %ebx,%eax
80100512:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100517:	f7 e2                	mul    %edx
80100519:	c1 ea 06             	shr    $0x6,%edx
8010051c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010051f:	c1 e0 04             	shl    $0x4,%eax
80100522:	8d 58 50             	lea    0x50(%eax),%ebx
80100525:	e9 6d ff ff ff       	jmp    80100497 <consputc.part.0+0x87>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100536:	68 60 0e 00 00       	push   $0xe60
8010053b:	68 a0 80 0b 80       	push   $0x800b80a0
80100540:	68 00 80 0b 80       	push   $0x800b8000
80100545:	e8 56 4b 00 00       	call   801050a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010054a:	b8 80 07 00 00       	mov    $0x780,%eax
8010054f:	83 c4 0c             	add    $0xc,%esp
80100552:	29 d8                	sub    %ebx,%eax
80100554:	01 c0                	add    %eax,%eax
80100556:	50                   	push   %eax
80100557:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
8010055e:	6a 00                	push   $0x0
80100560:	50                   	push   %eax
80100561:	e8 9a 4a 00 00       	call   80105000 <memset>
80100566:	88 5d e7             	mov    %bl,-0x19(%ebp)
80100569:	83 c4 10             	add    $0x10,%esp
8010056c:	c6 45 e0 07          	movb   $0x7,-0x20(%ebp)
80100570:	e9 43 ff ff ff       	jmp    801004b8 <consputc.part.0+0xa8>
80100575:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b');
80100578:	83 ec 0c             	sub    $0xc,%esp
8010057b:	6a 08                	push   $0x8
8010057d:	e8 6e 61 00 00       	call   801066f0 <uartputc>
80100582:	83 c4 10             	add    $0x10,%esp
80100585:	e9 b1 fe ff ff       	jmp    8010043b <consputc.part.0+0x2b>
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100590:	83 ec 0c             	sub    $0xc,%esp
80100593:	6a 08                	push   $0x8
80100595:	e8 56 61 00 00       	call   801066f0 <uartputc>
8010059a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005a1:	e8 4a 61 00 00       	call   801066f0 <uartputc>
801005a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005ad:	e8 3e 61 00 00       	call   801066f0 <uartputc>
801005b2:	83 c4 10             	add    $0x10,%esp
801005b5:	e9 81 fe ff ff       	jmp    8010043b <consputc.part.0+0x2b>
801005ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005c0:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801005c4:	c6 45 e0 00          	movb   $0x0,-0x20(%ebp)
801005c8:	e9 eb fe ff ff       	jmp    801004b8 <consputc.part.0+0xa8>
    panic("pos under/overflow");
801005cd:	83 ec 0c             	sub    $0xc,%esp
801005d0:	68 45 7b 10 80       	push   $0x80107b45
801005d5:	e8 b6 fd ff ff       	call   80100390 <panic>
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005e0 <printint>:
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 2c             	sub    $0x2c,%esp
801005e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ec:	85 c9                	test   %ecx,%ecx
801005ee:	74 04                	je     801005f4 <printint+0x14>
801005f0:	85 c0                	test   %eax,%eax
801005f2:	78 6d                	js     80100661 <printint+0x81>
    x = xx;
801005f4:	89 c1                	mov    %eax,%ecx
801005f6:	31 f6                	xor    %esi,%esi
  i = 0;
801005f8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005fb:	31 db                	xor    %ebx,%ebx
801005fd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
80100600:	89 c8                	mov    %ecx,%eax
80100602:	31 d2                	xor    %edx,%edx
80100604:	89 ce                	mov    %ecx,%esi
80100606:	f7 75 d4             	divl   -0x2c(%ebp)
80100609:	0f b6 92 a8 7b 10 80 	movzbl -0x7fef8458(%edx),%edx
80100610:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100613:	89 d8                	mov    %ebx,%eax
80100615:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
80100618:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010061b:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
8010061e:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
80100621:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80100624:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80100627:	73 d7                	jae    80100600 <printint+0x20>
80100629:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
8010062c:	85 f6                	test   %esi,%esi
8010062e:	74 0c                	je     8010063c <printint+0x5c>
    buf[i++] = '-';
80100630:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100635:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
80100637:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010063c:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100640:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100643:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100649:	85 d2                	test   %edx,%edx
8010064b:	74 03                	je     80100650 <printint+0x70>
  asm volatile("cli");
8010064d:	fa                   	cli    
    for(;;)
8010064e:	eb fe                	jmp    8010064e <printint+0x6e>
80100650:	e8 bb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100655:	39 fb                	cmp    %edi,%ebx
80100657:	74 10                	je     80100669 <printint+0x89>
80100659:	0f be 03             	movsbl (%ebx),%eax
8010065c:	83 eb 01             	sub    $0x1,%ebx
8010065f:	eb e2                	jmp    80100643 <printint+0x63>
    x = -xx;
80100661:	f7 d8                	neg    %eax
80100663:	89 ce                	mov    %ecx,%esi
80100665:	89 c1                	mov    %eax,%ecx
80100667:	eb 8f                	jmp    801005f8 <printint+0x18>
}
80100669:	83 c4 2c             	add    $0x2c,%esp
8010066c:	5b                   	pop    %ebx
8010066d:	5e                   	pop    %esi
8010066e:	5f                   	pop    %edi
8010066f:	5d                   	pop    %ebp
80100670:	c3                   	ret    
80100671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067f:	90                   	nop

80100680 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100680:	f3 0f 1e fb          	endbr32 
80100684:	55                   	push   %ebp
80100685:	89 e5                	mov    %esp,%ebp
80100687:	57                   	push   %edi
80100688:	56                   	push   %esi
80100689:	53                   	push   %ebx
8010068a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010068d:	ff 75 08             	pushl  0x8(%ebp)
{
80100690:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100693:	e8 38 1b 00 00       	call   801021d0 <iunlock>
  acquire(&cons.lock);
80100698:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010069f:	e8 4c 48 00 00       	call   80104ef0 <acquire>
  for(i = 0; i < n; i++)
801006a4:	83 c4 10             	add    $0x10,%esp
801006a7:	85 db                	test   %ebx,%ebx
801006a9:	7e 24                	jle    801006cf <consolewrite+0x4f>
801006ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006ae:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
801006b1:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801006b7:	85 d2                	test   %edx,%edx
801006b9:	74 05                	je     801006c0 <consolewrite+0x40>
801006bb:	fa                   	cli    
    for(;;)
801006bc:	eb fe                	jmp    801006bc <consolewrite+0x3c>
801006be:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
801006c0:	0f b6 07             	movzbl (%edi),%eax
801006c3:	83 c7 01             	add    $0x1,%edi
801006c6:	e8 45 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
801006cb:	39 fe                	cmp    %edi,%esi
801006cd:	75 e2                	jne    801006b1 <consolewrite+0x31>
  release(&cons.lock);
801006cf:	83 ec 0c             	sub    $0xc,%esp
801006d2:	68 20 b5 10 80       	push   $0x8010b520
801006d7:	e8 d4 48 00 00       	call   80104fb0 <release>
  ilock(ip);
801006dc:	58                   	pop    %eax
801006dd:	ff 75 08             	pushl  0x8(%ebp)
801006e0:	e8 0b 1a 00 00       	call   801020f0 <ilock>

  return n;
}
801006e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006e8:	89 d8                	mov    %ebx,%eax
801006ea:	5b                   	pop    %ebx
801006eb:	5e                   	pop    %esi
801006ec:	5f                   	pop    %edi
801006ed:	5d                   	pop    %ebp
801006ee:	c3                   	ret    
801006ef:	90                   	nop

801006f0 <cprintf>:
{
801006f0:	f3 0f 1e fb          	endbr32 
801006f4:	55                   	push   %ebp
801006f5:	89 e5                	mov    %esp,%ebp
801006f7:	57                   	push   %edi
801006f8:	56                   	push   %esi
801006f9:	53                   	push   %ebx
801006fa:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006fd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
80100702:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100705:	85 c0                	test   %eax,%eax
80100707:	0f 85 e8 00 00 00    	jne    801007f5 <cprintf+0x105>
  if (fmt == 0)
8010070d:	8b 45 08             	mov    0x8(%ebp),%eax
80100710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100713:	85 c0                	test   %eax,%eax
80100715:	0f 84 5a 01 00 00    	je     80100875 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	0f b6 00             	movzbl (%eax),%eax
8010071e:	85 c0                	test   %eax,%eax
80100720:	74 36                	je     80100758 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
80100722:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100725:	31 f6                	xor    %esi,%esi
    if(c != '%'){
80100727:	83 f8 25             	cmp    $0x25,%eax
8010072a:	74 44                	je     80100770 <cprintf+0x80>
  if(panicked){
8010072c:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100732:	85 c9                	test   %ecx,%ecx
80100734:	74 0f                	je     80100745 <cprintf+0x55>
80100736:	fa                   	cli    
    for(;;)
80100737:	eb fe                	jmp    80100737 <cprintf+0x47>
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100740:	b8 25 00 00 00       	mov    $0x25,%eax
80100745:	e8 c6 fc ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010074a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010074d:	83 c6 01             	add    $0x1,%esi
80100750:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100754:	85 c0                	test   %eax,%eax
80100756:	75 cf                	jne    80100727 <cprintf+0x37>
  if(locking)
80100758:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	0f 85 fd 00 00 00    	jne    80100860 <cprintf+0x170>
}
80100763:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100766:	5b                   	pop    %ebx
80100767:	5e                   	pop    %esi
80100768:	5f                   	pop    %edi
80100769:	5d                   	pop    %ebp
8010076a:	c3                   	ret    
8010076b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010076f:	90                   	nop
    c = fmt[++i] & 0xff;
80100770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100773:	83 c6 01             	add    $0x1,%esi
80100776:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010077a:	85 ff                	test   %edi,%edi
8010077c:	74 da                	je     80100758 <cprintf+0x68>
    switch(c){
8010077e:	83 ff 70             	cmp    $0x70,%edi
80100781:	74 5a                	je     801007dd <cprintf+0xed>
80100783:	7f 2a                	jg     801007af <cprintf+0xbf>
80100785:	83 ff 25             	cmp    $0x25,%edi
80100788:	0f 84 92 00 00 00    	je     80100820 <cprintf+0x130>
8010078e:	83 ff 64             	cmp    $0x64,%edi
80100791:	0f 85 a1 00 00 00    	jne    80100838 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100797:	8b 03                	mov    (%ebx),%eax
80100799:	8d 7b 04             	lea    0x4(%ebx),%edi
8010079c:	b9 01 00 00 00       	mov    $0x1,%ecx
801007a1:	ba 0a 00 00 00       	mov    $0xa,%edx
801007a6:	89 fb                	mov    %edi,%ebx
801007a8:	e8 33 fe ff ff       	call   801005e0 <printint>
      break;
801007ad:	eb 9b                	jmp    8010074a <cprintf+0x5a>
    switch(c){
801007af:	83 ff 73             	cmp    $0x73,%edi
801007b2:	75 24                	jne    801007d8 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
801007b4:	8d 7b 04             	lea    0x4(%ebx),%edi
801007b7:	8b 1b                	mov    (%ebx),%ebx
801007b9:	85 db                	test   %ebx,%ebx
801007bb:	75 55                	jne    80100812 <cprintf+0x122>
        s = "(null)";
801007bd:	bb 58 7b 10 80       	mov    $0x80107b58,%ebx
      for(; *s; s++)
801007c2:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
801007c7:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801007cd:	85 d2                	test   %edx,%edx
801007cf:	74 39                	je     8010080a <cprintf+0x11a>
801007d1:	fa                   	cli    
    for(;;)
801007d2:	eb fe                	jmp    801007d2 <cprintf+0xe2>
801007d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007d8:	83 ff 78             	cmp    $0x78,%edi
801007db:	75 5b                	jne    80100838 <cprintf+0x148>
      printint(*argp++, 16, 0);
801007dd:	8b 03                	mov    (%ebx),%eax
801007df:	8d 7b 04             	lea    0x4(%ebx),%edi
801007e2:	31 c9                	xor    %ecx,%ecx
801007e4:	ba 10 00 00 00       	mov    $0x10,%edx
801007e9:	89 fb                	mov    %edi,%ebx
801007eb:	e8 f0 fd ff ff       	call   801005e0 <printint>
      break;
801007f0:	e9 55 ff ff ff       	jmp    8010074a <cprintf+0x5a>
    acquire(&cons.lock);
801007f5:	83 ec 0c             	sub    $0xc,%esp
801007f8:	68 20 b5 10 80       	push   $0x8010b520
801007fd:	e8 ee 46 00 00       	call   80104ef0 <acquire>
80100802:	83 c4 10             	add    $0x10,%esp
80100805:	e9 03 ff ff ff       	jmp    8010070d <cprintf+0x1d>
8010080a:	e8 01 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
8010080f:	83 c3 01             	add    $0x1,%ebx
80100812:	0f be 03             	movsbl (%ebx),%eax
80100815:	84 c0                	test   %al,%al
80100817:	75 ae                	jne    801007c7 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
80100819:	89 fb                	mov    %edi,%ebx
8010081b:	e9 2a ff ff ff       	jmp    8010074a <cprintf+0x5a>
  if(panicked){
80100820:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
80100826:	85 ff                	test   %edi,%edi
80100828:	0f 84 12 ff ff ff    	je     80100740 <cprintf+0x50>
8010082e:	fa                   	cli    
    for(;;)
8010082f:	eb fe                	jmp    8010082f <cprintf+0x13f>
80100831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100838:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
8010083e:	85 c9                	test   %ecx,%ecx
80100840:	74 06                	je     80100848 <cprintf+0x158>
80100842:	fa                   	cli    
    for(;;)
80100843:	eb fe                	jmp    80100843 <cprintf+0x153>
80100845:	8d 76 00             	lea    0x0(%esi),%esi
80100848:	b8 25 00 00 00       	mov    $0x25,%eax
8010084d:	e8 be fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100852:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100858:	85 d2                	test   %edx,%edx
8010085a:	74 2c                	je     80100888 <cprintf+0x198>
8010085c:	fa                   	cli    
    for(;;)
8010085d:	eb fe                	jmp    8010085d <cprintf+0x16d>
8010085f:	90                   	nop
    release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 43 47 00 00       	call   80104fb0 <release>
8010086d:	83 c4 10             	add    $0x10,%esp
}
80100870:	e9 ee fe ff ff       	jmp    80100763 <cprintf+0x73>
    panic("null fmt");
80100875:	83 ec 0c             	sub    $0xc,%esp
80100878:	68 5f 7b 10 80       	push   $0x80107b5f
8010087d:	e8 0e fb ff ff       	call   80100390 <panic>
80100882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100888:	89 f8                	mov    %edi,%eax
8010088a:	e8 81 fb ff ff       	call   80100410 <consputc.part.0>
8010088f:	e9 b6 fe ff ff       	jmp    8010074a <cprintf+0x5a>
80100894:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010089b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010089f:	90                   	nop

801008a0 <copyCharsToBeMoved>:
void copyCharsToBeMoved() {
801008a0:	f3 0f 1e fb          	endbr32 
  uint n = input.rightmost - input.r;
801008a4:	8b 0d 2c 10 11 80    	mov    0x8011102c,%ecx
  for (i = 0; i < n; i++)
801008aa:	2b 0d 20 10 11 80    	sub    0x80111020,%ecx
801008b0:	74 2e                	je     801008e0 <copyCharsToBeMoved+0x40>
void copyCharsToBeMoved() {
801008b2:	55                   	push   %ebp
  for (i = 0; i < n; i++)
801008b3:	31 c0                	xor    %eax,%eax
void copyCharsToBeMoved() {
801008b5:	89 e5                	mov    %esp,%ebp
801008b7:	53                   	push   %ebx
    charsToBeMoved[i] = input.buf[(input.e + i) % INPUT_BUF];
801008b8:	8b 1d 28 10 11 80    	mov    0x80111028,%ebx
801008be:	66 90                	xchg   %ax,%ax
801008c0:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  for (i = 0; i < n; i++)
801008c3:	83 c0 01             	add    $0x1,%eax
    charsToBeMoved[i] = input.buf[(input.e + i) % INPUT_BUF];
801008c6:	83 e2 7f             	and    $0x7f,%edx
801008c9:	0f b6 92 a0 0f 11 80 	movzbl -0x7feef060(%edx),%edx
801008d0:	88 90 df 10 11 80    	mov    %dl,-0x7feeef21(%eax)
  for (i = 0; i < n; i++)
801008d6:	39 c1                	cmp    %eax,%ecx
801008d8:	75 e6                	jne    801008c0 <copyCharsToBeMoved+0x20>
}
801008da:	5b                   	pop    %ebx
801008db:	5d                   	pop    %ebp
801008dc:	c3                   	ret    
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
801008e0:	c3                   	ret    
801008e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008ef:	90                   	nop

801008f0 <shiftbufright>:
void shiftbufright() {
801008f0:	f3 0f 1e fb          	endbr32 
801008f4:	55                   	push   %ebp
801008f5:	89 e5                	mov    %esp,%ebp
801008f7:	57                   	push   %edi
801008f8:	56                   	push   %esi
801008f9:	53                   	push   %ebx
801008fa:	83 ec 0c             	sub    $0xc,%esp
  uint n = input.rightmost - input.e;
801008fd:	a1 28 10 11 80       	mov    0x80111028,%eax
  for (i = 0; i < n; i++) {
80100902:	8b 3d 2c 10 11 80    	mov    0x8011102c,%edi
80100908:	29 c7                	sub    %eax,%edi
8010090a:	74 79                	je     80100985 <shiftbufright+0x95>
8010090c:	31 db                	xor    %ebx,%ebx
    char c = charsToBeMoved[i];
8010090e:	0f b6 93 e0 10 11 80 	movzbl -0x7feeef20(%ebx),%edx
    input.buf[(input.e + i) % INPUT_BUF] = c;
80100915:	01 d8                	add    %ebx,%eax
  if(panicked){
80100917:	8b 35 58 b5 10 80    	mov    0x8010b558,%esi
    input.buf[(input.e + i) % INPUT_BUF] = c;
8010091d:	83 e0 7f             	and    $0x7f,%eax
80100920:	88 90 a0 0f 11 80    	mov    %dl,-0x7feef060(%eax)
  if(panicked){
80100926:	85 f6                	test   %esi,%esi
80100928:	74 06                	je     80100930 <shiftbufright+0x40>
8010092a:	fa                   	cli    
    for(;;)
8010092b:	eb fe                	jmp    8010092b <shiftbufright+0x3b>
8010092d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(c);
80100930:	0f be c2             	movsbl %dl,%eax
80100933:	e8 d8 fa ff ff       	call   80100410 <consputc.part.0>
  for (i = 0; i < n; i++) {
80100938:	8d 53 01             	lea    0x1(%ebx),%edx
8010093b:	39 d7                	cmp    %edx,%edi
8010093d:	74 09                	je     80100948 <shiftbufright+0x58>
8010093f:	a1 28 10 11 80       	mov    0x80111028,%eax
80100944:	89 d3                	mov    %edx,%ebx
80100946:	eb c6                	jmp    8010090e <shiftbufright+0x1e>
  memset(charsToBeMoved, '\0', INPUT_BUF);
80100948:	83 ec 04             	sub    $0x4,%esp
8010094b:	68 80 00 00 00       	push   $0x80
80100950:	6a 00                	push   $0x0
80100952:	68 e0 10 11 80       	push   $0x801110e0
80100957:	e8 a4 46 00 00       	call   80105000 <memset>
8010095c:	83 c4 10             	add    $0x10,%esp
  if(panicked){
8010095f:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100964:	85 c0                	test   %eax,%eax
80100966:	74 08                	je     80100970 <shiftbufright+0x80>
80100968:	fa                   	cli    
    for(;;)
80100969:	eb fe                	jmp    80100969 <shiftbufright+0x79>
8010096b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010096f:	90                   	nop
80100970:	b8 4b 00 00 00       	mov    $0x4b,%eax
80100975:	e8 96 fa ff ff       	call   80100410 <consputc.part.0>
  for (i = 0; i < n; i++) {
8010097a:	8d 46 01             	lea    0x1(%esi),%eax
8010097d:	39 f3                	cmp    %esi,%ebx
8010097f:	74 1b                	je     8010099c <shiftbufright+0xac>
80100981:	89 c6                	mov    %eax,%esi
80100983:	eb da                	jmp    8010095f <shiftbufright+0x6f>
  memset(charsToBeMoved, '\0', INPUT_BUF);
80100985:	83 ec 04             	sub    $0x4,%esp
80100988:	68 80 00 00 00       	push   $0x80
8010098d:	6a 00                	push   $0x0
8010098f:	68 e0 10 11 80       	push   $0x801110e0
80100994:	e8 67 46 00 00       	call   80105000 <memset>
80100999:	83 c4 10             	add    $0x10,%esp
}
8010099c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010099f:	5b                   	pop    %ebx
801009a0:	5e                   	pop    %esi
801009a1:	5f                   	pop    %edi
801009a2:	5d                   	pop    %ebp
801009a3:	c3                   	ret    
801009a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009af:	90                   	nop

801009b0 <shiftbufleft>:
void shiftbufleft() {
801009b0:	f3 0f 1e fb          	endbr32 
  if(panicked){
801009b4:	a1 58 b5 10 80       	mov    0x8010b558,%eax
801009b9:	85 c0                	test   %eax,%eax
801009bb:	74 03                	je     801009c0 <shiftbufleft+0x10>
801009bd:	fa                   	cli    
    for(;;)
801009be:	eb fe                	jmp    801009be <shiftbufleft+0xe>
void shiftbufleft() {
801009c0:	55                   	push   %ebp
801009c1:	b8 4b 00 00 00       	mov    $0x4b,%eax
801009c6:	89 e5                	mov    %esp,%ebp
801009c8:	56                   	push   %esi
801009c9:	53                   	push   %ebx
  uint n = input.rightmost - input.e;
801009ca:	8b 1d 2c 10 11 80    	mov    0x8011102c,%ebx
801009d0:	2b 1d 28 10 11 80    	sub    0x80111028,%ebx
801009d6:	e8 35 fa ff ff       	call   80100410 <consputc.part.0>
  input.e--;
801009db:	a1 28 10 11 80       	mov    0x80111028,%eax
801009e0:	83 e8 01             	sub    $0x1,%eax
801009e3:	a3 28 10 11 80       	mov    %eax,0x80111028
  for (i = 0; i < n; i++) {
801009e8:	85 db                	test   %ebx,%ebx
801009ea:	74 42                	je     80100a2e <shiftbufleft+0x7e>
801009ec:	31 f6                	xor    %esi,%esi
    char c = input.buf[(input.e + i + 1) % INPUT_BUF];
801009ee:	01 f0                	add    %esi,%eax
  if(panicked){
801009f0:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
    char c = input.buf[(input.e + i + 1) % INPUT_BUF];
801009f6:	8d 50 01             	lea    0x1(%eax),%edx
    input.buf[(input.e + i) % INPUT_BUF] = c;
801009f9:	83 e0 7f             	and    $0x7f,%eax
    char c = input.buf[(input.e + i + 1) % INPUT_BUF];
801009fc:	83 e2 7f             	and    $0x7f,%edx
801009ff:	0f b6 92 a0 0f 11 80 	movzbl -0x7feef060(%edx),%edx
    input.buf[(input.e + i) % INPUT_BUF] = c;
80100a06:	88 90 a0 0f 11 80    	mov    %dl,-0x7feef060(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	74 08                	je     80100a18 <shiftbufleft+0x68>
80100a10:	fa                   	cli    
    for(;;)
80100a11:	eb fe                	jmp    80100a11 <shiftbufleft+0x61>
80100a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a17:	90                   	nop
    consputc(c);
80100a18:	0f be c2             	movsbl %dl,%eax
  for (i = 0; i < n; i++) {
80100a1b:	83 c6 01             	add    $0x1,%esi
80100a1e:	e8 ed f9 ff ff       	call   80100410 <consputc.part.0>
80100a23:	39 f3                	cmp    %esi,%ebx
80100a25:	74 07                	je     80100a2e <shiftbufleft+0x7e>
80100a27:	a1 28 10 11 80       	mov    0x80111028,%eax
80100a2c:	eb c0                	jmp    801009ee <shiftbufleft+0x3e>
  if(panicked){
80100a2e:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
  input.rightmost--;
80100a34:	83 2d 2c 10 11 80 01 	subl   $0x1,0x8011102c
  if(panicked){
80100a3b:	85 d2                	test   %edx,%edx
80100a3d:	75 21                	jne    80100a60 <shiftbufleft+0xb0>
80100a3f:	b8 20 00 00 00       	mov    $0x20,%eax
  for (i = 0; i <= n; i++) {
80100a44:	31 f6                	xor    %esi,%esi
80100a46:	e8 c5 f9 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100a4b:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100a50:	85 c0                	test   %eax,%eax
80100a52:	74 14                	je     80100a68 <shiftbufleft+0xb8>
80100a54:	fa                   	cli    
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <shiftbufleft+0xa5>
80100a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5e:	66 90                	xchg   %ax,%ax
80100a60:	fa                   	cli    
80100a61:	eb fe                	jmp    80100a61 <shiftbufleft+0xb1>
80100a63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a67:	90                   	nop
80100a68:	b8 4b 00 00 00       	mov    $0x4b,%eax
  for (i = 0; i <= n; i++) {
80100a6d:	83 c6 01             	add    $0x1,%esi
80100a70:	e8 9b f9 ff ff       	call   80100410 <consputc.part.0>
80100a75:	39 f3                	cmp    %esi,%ebx
80100a77:	73 d2                	jae    80100a4b <shiftbufleft+0x9b>
}
80100a79:	5b                   	pop    %ebx
80100a7a:	5e                   	pop    %esi
80100a7b:	5d                   	pop    %ebp
80100a7c:	c3                   	ret    
80100a7d:	8d 76 00             	lea    0x0(%esi),%esi

80100a80 <earaseCurrentLineOnScreen>:
earaseCurrentLineOnScreen(void){
80100a80:	f3 0f 1e fb          	endbr32 
  uint numToEarase = input.rightmost - input.r;
80100a84:	a1 2c 10 11 80       	mov    0x8011102c,%eax
  for (i = 0; i < numToEarase; i++) {
80100a89:	2b 05 20 10 11 80    	sub    0x80111020,%eax
80100a8f:	74 34                	je     80100ac5 <earaseCurrentLineOnScreen+0x45>
earaseCurrentLineOnScreen(void){
80100a91:	55                   	push   %ebp
80100a92:	89 e5                	mov    %esp,%ebp
80100a94:	56                   	push   %esi
  for (i = 0; i < numToEarase; i++) {
80100a95:	31 f6                	xor    %esi,%esi
earaseCurrentLineOnScreen(void){
80100a97:	53                   	push   %ebx
80100a98:	89 c3                	mov    %eax,%ebx
  if(panicked){
80100a9a:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100a9f:	85 c0                	test   %eax,%eax
80100aa1:	74 0d                	je     80100ab0 <earaseCurrentLineOnScreen+0x30>
80100aa3:	fa                   	cli    
    for(;;)
80100aa4:	eb fe                	jmp    80100aa4 <earaseCurrentLineOnScreen+0x24>
80100aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aad:	8d 76 00             	lea    0x0(%esi),%esi
80100ab0:	b8 00 01 00 00       	mov    $0x100,%eax
  for (i = 0; i < numToEarase; i++) {
80100ab5:	83 c6 01             	add    $0x1,%esi
80100ab8:	e8 53 f9 ff ff       	call   80100410 <consputc.part.0>
80100abd:	39 f3                	cmp    %esi,%ebx
80100abf:	75 d9                	jne    80100a9a <earaseCurrentLineOnScreen+0x1a>
}
80100ac1:	5b                   	pop    %ebx
80100ac2:	5e                   	pop    %esi
80100ac3:	5d                   	pop    %ebp
80100ac4:	c3                   	ret    
80100ac5:	c3                   	ret    
80100ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100acd:	8d 76 00             	lea    0x0(%esi),%esi

80100ad0 <copyCharsToBeMovedToOldBuf>:
copyCharsToBeMovedToOldBuf(void){
80100ad0:	f3 0f 1e fb          	endbr32 
80100ad4:	55                   	push   %ebp
    lengthOfOldBuf = input.rightmost - input.r;
80100ad5:	8b 0d 2c 10 11 80    	mov    0x8011102c,%ecx
copyCharsToBeMovedToOldBuf(void){
80100adb:	89 e5                	mov    %esp,%ebp
80100add:	53                   	push   %ebx
    lengthOfOldBuf = input.rightmost - input.r;
80100ade:	8b 1d 20 10 11 80    	mov    0x80111020,%ebx
80100ae4:	29 d9                	sub    %ebx,%ecx
80100ae6:	89 0d c0 10 11 80    	mov    %ecx,0x801110c0
    for (i = 0; i < lengthOfOldBuf; i++) {
80100aec:	74 1c                	je     80100b0a <copyCharsToBeMovedToOldBuf+0x3a>
80100aee:	31 c0                	xor    %eax,%eax
        oldBuf[i] = input.buf[(input.r+i)%INPUT_BUF];
80100af0:	8d 14 03             	lea    (%ebx,%eax,1),%edx
    for (i = 0; i < lengthOfOldBuf; i++) {
80100af3:	83 c0 01             	add    $0x1,%eax
        oldBuf[i] = input.buf[(input.r+i)%INPUT_BUF];
80100af6:	83 e2 7f             	and    $0x7f,%edx
80100af9:	0f b6 92 a0 0f 11 80 	movzbl -0x7feef060(%edx),%edx
80100b00:	88 90 1f 0f 11 80    	mov    %dl,-0x7feef0e1(%eax)
    for (i = 0; i < lengthOfOldBuf; i++) {
80100b06:	39 c1                	cmp    %eax,%ecx
80100b08:	75 e6                	jne    80100af0 <copyCharsToBeMovedToOldBuf+0x20>
}
80100b0a:	5b                   	pop    %ebx
80100b0b:	5d                   	pop    %ebp
80100b0c:	c3                   	ret    
80100b0d:	8d 76 00             	lea    0x0(%esi),%esi

80100b10 <earaseContentOnInputBuf>:
earaseContentOnInputBuf(){
80100b10:	f3 0f 1e fb          	endbr32 
  input.rightmost = input.r;
80100b14:	a1 20 10 11 80       	mov    0x80111020,%eax
80100b19:	a3 2c 10 11 80       	mov    %eax,0x8011102c
  input.e = input.r;
80100b1e:	a3 28 10 11 80       	mov    %eax,0x80111028
}
80100b23:	c3                   	ret    
80100b24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b2f:	90                   	nop

80100b30 <copyBufferToScreen>:
copyBufferToScreen(char * bufToPrintOnScreen, uint length){
80100b30:	f3 0f 1e fb          	endbr32 
80100b34:	55                   	push   %ebp
80100b35:	89 e5                	mov    %esp,%ebp
80100b37:	56                   	push   %esi
80100b38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b3b:	53                   	push   %ebx
  for (i = 0; i < length; i++) {
80100b3c:	85 c0                	test   %eax,%eax
80100b3e:	74 27                	je     80100b67 <copyBufferToScreen+0x37>
80100b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100b43:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  if(panicked){
80100b46:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100b4b:	85 c0                	test   %eax,%eax
80100b4d:	74 09                	je     80100b58 <copyBufferToScreen+0x28>
80100b4f:	fa                   	cli    
    for(;;)
80100b50:	eb fe                	jmp    80100b50 <copyBufferToScreen+0x20>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(bufToPrintOnScreen[i]);
80100b58:	0f be 03             	movsbl (%ebx),%eax
80100b5b:	83 c3 01             	add    $0x1,%ebx
80100b5e:	e8 ad f8 ff ff       	call   80100410 <consputc.part.0>
  for (i = 0; i < length; i++) {
80100b63:	39 f3                	cmp    %esi,%ebx
80100b65:	75 df                	jne    80100b46 <copyBufferToScreen+0x16>
}
80100b67:	5b                   	pop    %ebx
80100b68:	5e                   	pop    %esi
80100b69:	5d                   	pop    %ebp
80100b6a:	c3                   	ret    
80100b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop

80100b70 <copyBufferToInputBuf>:
copyBufferToInputBuf(char * bufToSaveInInput, uint length){
80100b70:	f3 0f 1e fb          	endbr32 
80100b74:	55                   	push   %ebp
80100b75:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100b7b:	89 d0                	mov    %edx,%eax
80100b7d:	89 e5                	mov    %esp,%ebp
80100b7f:	56                   	push   %esi
80100b80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80100b83:	8b 75 08             	mov    0x8(%ebp),%esi
copyBufferToInputBuf(char * bufToSaveInInput, uint length){
80100b86:	53                   	push   %ebx
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80100b87:	29 d6                	sub    %edx,%esi
80100b89:	8d 1c 11             	lea    (%ecx,%edx,1),%ebx
  for (i = 0; i < length; i++) {
80100b8c:	85 c9                	test   %ecx,%ecx
80100b8e:	74 30                	je     80100bc0 <copyBufferToInputBuf+0x50>
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80100b90:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80100b94:	89 c2                	mov    %eax,%edx
80100b96:	83 c0 01             	add    $0x1,%eax
80100b99:	83 e2 7f             	and    $0x7f,%edx
80100b9c:	88 8a a0 0f 11 80    	mov    %cl,-0x7feef060(%edx)
  for (i = 0; i < length; i++) {
80100ba2:	39 d8                	cmp    %ebx,%eax
80100ba4:	75 ea                	jne    80100b90 <copyBufferToInputBuf+0x20>
  input.e = input.r+length;
80100ba6:	89 1d 28 10 11 80    	mov    %ebx,0x80111028
  input.rightmost = input.e;
80100bac:	89 1d 2c 10 11 80    	mov    %ebx,0x8011102c
}
80100bb2:	5b                   	pop    %ebx
80100bb3:	5e                   	pop    %esi
80100bb4:	5d                   	pop    %ebp
80100bb5:	c3                   	ret    
80100bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bbd:	8d 76 00             	lea    0x0(%esi),%esi
80100bc0:	89 d3                	mov    %edx,%ebx
80100bc2:	eb e2                	jmp    80100ba6 <copyBufferToInputBuf+0x36>
80100bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100bcf:	90                   	nop

80100bd0 <saveCommandInHistory>:
saveCommandInHistory(){
80100bd0:	f3 0f 1e fb          	endbr32 
80100bd4:	55                   	push   %ebp
  if (historyBufferArray.numOfCommmandsInMem < MAX_HISTORY)
80100bd5:	a1 a4 19 11 80       	mov    0x801119a4,%eax
  historyBufferArray.currentHistory= -1;
80100bda:	c7 05 a8 19 11 80 ff 	movl   $0xffffffff,0x801119a8
80100be1:	ff ff ff 
saveCommandInHistory(){
80100be4:	89 e5                	mov    %esp,%ebp
80100be6:	53                   	push   %ebx
  if (historyBufferArray.numOfCommmandsInMem < MAX_HISTORY)
80100be7:	83 f8 0f             	cmp    $0xf,%eax
80100bea:	7f 08                	jg     80100bf4 <saveCommandInHistory+0x24>
    historyBufferArray.numOfCommmandsInMem++; 
80100bec:	83 c0 01             	add    $0x1,%eax
80100bef:	a3 a4 19 11 80       	mov    %eax,0x801119a4
  uint l = input.rightmost-input.r -1;
80100bf4:	8b 0d 2c 10 11 80    	mov    0x8011102c,%ecx
  historyBufferArray.lastCommandIndex = (historyBufferArray.lastCommandIndex - 1)%MAX_HISTORY;
80100bfa:	8b 15 a0 19 11 80    	mov    0x801119a0,%edx
  uint l = input.rightmost-input.r -1;
80100c00:	a1 20 10 11 80       	mov    0x80111020,%eax
80100c05:	83 e9 01             	sub    $0x1,%ecx
  historyBufferArray.lastCommandIndex = (historyBufferArray.lastCommandIndex - 1)%MAX_HISTORY;
80100c08:	83 ea 01             	sub    $0x1,%edx
  uint l = input.rightmost-input.r -1;
80100c0b:	89 cb                	mov    %ecx,%ebx
  historyBufferArray.lastCommandIndex = (historyBufferArray.lastCommandIndex - 1)%MAX_HISTORY;
80100c0d:	83 e2 0f             	and    $0xf,%edx
  uint l = input.rightmost-input.r -1;
80100c10:	29 c3                	sub    %eax,%ebx
  historyBufferArray.lastCommandIndex = (historyBufferArray.lastCommandIndex - 1)%MAX_HISTORY;
80100c12:	89 15 a0 19 11 80    	mov    %edx,0x801119a0
  historyBufferArray.lengthsArr[historyBufferArray.lastCommandIndex] = l;
80100c18:	89 1c 95 60 19 11 80 	mov    %ebx,-0x7feee6a0(,%edx,4)
  for (i = 0; i < l; i++) { 
80100c1f:	85 db                	test   %ebx,%ebx
80100c21:	74 27                	je     80100c4a <saveCommandInHistory+0x7a>
80100c23:	c1 e2 07             	shl    $0x7,%edx
80100c26:	29 c2                	sub    %eax,%edx
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
    historyBufferArray.bufferArr[historyBufferArray.lastCommandIndex][i] =  input.buf[(input.r+i)%INPUT_BUF];
80100c30:	89 c3                	mov    %eax,%ebx
80100c32:	83 e3 7f             	and    $0x7f,%ebx
80100c35:	0f b6 9b a0 0f 11 80 	movzbl -0x7feef060(%ebx),%ebx
80100c3c:	88 9c 02 60 11 11 80 	mov    %bl,-0x7feeeea0(%edx,%eax,1)
80100c43:	83 c0 01             	add    $0x1,%eax
  for (i = 0; i < l; i++) { 
80100c46:	39 c1                	cmp    %eax,%ecx
80100c48:	75 e6                	jne    80100c30 <saveCommandInHistory+0x60>
}
80100c4a:	5b                   	pop    %ebx
80100c4b:	5d                   	pop    %ebp
80100c4c:	c3                   	ret    
80100c4d:	8d 76 00             	lea    0x0(%esi),%esi

80100c50 <consoleintr>:
{
80100c50:	f3 0f 1e fb          	endbr32 
80100c54:	55                   	push   %ebp
80100c55:	89 e5                	mov    %esp,%ebp
80100c57:	57                   	push   %edi
80100c58:	56                   	push   %esi
80100c59:	53                   	push   %ebx
  int c, doprocdump = 0;
80100c5a:	31 db                	xor    %ebx,%ebx
{
80100c5c:	83 ec 38             	sub    $0x38,%esp
80100c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100c62:	68 20 b5 10 80       	push   $0x8010b520
{
80100c67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  acquire(&cons.lock);
80100c6a:	e8 81 42 00 00       	call   80104ef0 <acquire>
  while((c = getc()) >= 0){
80100c6f:	83 c4 10             	add    $0x10,%esp
80100c72:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c75:	ff d0                	call   *%eax
80100c77:	89 c6                	mov    %eax,%esi
80100c79:	85 c0                	test   %eax,%eax
80100c7b:	0f 88 dd 04 00 00    	js     8010115e <consoleintr+0x50e>
    switch(c){
80100c81:	83 fe 48             	cmp    $0x48,%esi
80100c84:	0f 84 ee 01 00 00    	je     80100e78 <consoleintr+0x228>
80100c8a:	7f 1b                	jg     80100ca7 <consoleintr+0x57>
80100c8c:	8d 46 f8             	lea    -0x8(%esi),%eax
80100c8f:	83 f8 0d             	cmp    $0xd,%eax
80100c92:	0f 87 02 01 00 00    	ja     80100d9a <consoleintr+0x14a>
80100c98:	3e ff 24 85 70 7b 10 	notrack jmp *-0x7fef8490(,%eax,4)
80100c9f:	80 
80100ca0:	bb 01 00 00 00       	mov    $0x1,%ebx
80100ca5:	eb cb                	jmp    80100c72 <consoleintr+0x22>
80100ca7:	83 fe 4d             	cmp    $0x4d,%esi
80100caa:	0f 84 7d 02 00 00    	je     80100f2d <consoleintr+0x2dd>
80100cb0:	7e 7e                	jle    80100d30 <consoleintr+0xe0>
80100cb2:	83 fe 50             	cmp    $0x50,%esi
80100cb5:	0f 85 a5 00 00 00    	jne    80100d60 <consoleintr+0x110>
      switch(historyBufferArray.currentHistory){
80100cbb:	a1 a8 19 11 80       	mov    0x801119a8,%eax
80100cc0:	83 f8 ff             	cmp    $0xffffffff,%eax
80100cc3:	74 ad                	je     80100c72 <consoleintr+0x22>
80100cc5:	85 c0                	test   %eax,%eax
80100cc7:	0f 85 0b 04 00 00    	jne    801010d8 <consoleintr+0x488>
          earaseCurrentLineOnScreen();
80100ccd:	e8 ae fd ff ff       	call   80100a80 <earaseCurrentLineOnScreen>
          copyBufferToInputBuf(oldBuf, lengthOfOldBuf);
80100cd2:	8b 35 c0 10 11 80    	mov    0x801110c0,%esi
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80100cd8:	a1 20 10 11 80       	mov    0x80111020,%eax
  for (i = 0; i < length; i++) {
80100cdd:	85 f6                	test   %esi,%esi
80100cdf:	74 20                	je     80100d01 <consoleintr+0xb1>
80100ce1:	31 d2                	xor    %edx,%edx
80100ce3:	89 df                	mov    %ebx,%edi
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80100ce5:	0f b6 9a 20 0f 11 80 	movzbl -0x7feef0e0(%edx),%ebx
80100cec:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  for (i = 0; i < length; i++) {
80100cef:	83 c2 01             	add    $0x1,%edx
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80100cf2:	83 e1 7f             	and    $0x7f,%ecx
80100cf5:	88 99 a0 0f 11 80    	mov    %bl,-0x7feef060(%ecx)
  for (i = 0; i < length; i++) {
80100cfb:	39 d6                	cmp    %edx,%esi
80100cfd:	75 e6                	jne    80100ce5 <consoleintr+0x95>
80100cff:	89 fb                	mov    %edi,%ebx
          copyBufferToScreen(oldBuf, lengthOfOldBuf);
80100d01:	83 ec 08             	sub    $0x8,%esp
  input.e = input.r+length;
80100d04:	01 f0                	add    %esi,%eax
          copyBufferToScreen(oldBuf, lengthOfOldBuf);
80100d06:	56                   	push   %esi
80100d07:	68 20 0f 11 80       	push   $0x80110f20
  input.e = input.r+length;
80100d0c:	a3 28 10 11 80       	mov    %eax,0x80111028
  input.rightmost = input.e;
80100d11:	a3 2c 10 11 80       	mov    %eax,0x8011102c
          copyBufferToScreen(oldBuf, lengthOfOldBuf);
80100d16:	e8 15 fe ff ff       	call   80100b30 <copyBufferToScreen>
          historyBufferArray.currentHistory--;
80100d1b:	83 2d a8 19 11 80 01 	subl   $0x1,0x801119a8
          break;
80100d22:	83 c4 10             	add    $0x10,%esp
80100d25:	e9 48 ff ff ff       	jmp    80100c72 <consoleintr+0x22>
80100d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100d30:	83 fe 4b             	cmp    $0x4b,%esi
80100d33:	75 6d                	jne    80100da2 <consoleintr+0x152>
      if (input.e != input.w) {
80100d35:	a1 28 10 11 80       	mov    0x80111028,%eax
80100d3a:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
80100d40:	0f 84 2c ff ff ff    	je     80100c72 <consoleintr+0x22>
        input.e--;
80100d46:	83 e8 01             	sub    $0x1,%eax
80100d49:	a3 28 10 11 80       	mov    %eax,0x80111028
  if(panicked){
80100d4e:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100d53:	85 c0                	test   %eax,%eax
80100d55:	0f 84 20 03 00 00    	je     8010107b <consoleintr+0x42b>
80100d5b:	fa                   	cli    
    for(;;)
80100d5c:	eb fe                	jmp    80100d5c <consoleintr+0x10c>
80100d5e:	66 90                	xchg   %ax,%ax
    switch(c){
80100d60:	83 fe 7f             	cmp    $0x7f,%esi
80100d63:	75 3d                	jne    80100da2 <consoleintr+0x152>
      if (input.rightmost != input.e && input.e != input.w) { 
80100d65:	a1 2c 10 11 80       	mov    0x8011102c,%eax
80100d6a:	8b 0d 28 10 11 80    	mov    0x80111028,%ecx
80100d70:	8b 15 24 10 11 80    	mov    0x80111024,%edx
80100d76:	39 c8                	cmp    %ecx,%eax
80100d78:	0f 84 0c 03 00 00    	je     8010108a <consoleintr+0x43a>
80100d7e:	39 d1                	cmp    %edx,%ecx
80100d80:	0f 84 ec fe ff ff    	je     80100c72 <consoleintr+0x22>
          shiftbufleft();
80100d86:	e8 25 fc ff ff       	call   801009b0 <shiftbufleft>
          break;
80100d8b:	e9 e2 fe ff ff       	jmp    80100c72 <consoleintr+0x22>
        input.e = input.rightmost;
80100d90:	a1 2c 10 11 80       	mov    0x8011102c,%eax
80100d95:	a3 28 10 11 80       	mov    %eax,0x80111028
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100d9a:	85 f6                	test   %esi,%esi
80100d9c:	0f 84 d0 fe ff ff    	je     80100c72 <consoleintr+0x22>
80100da2:	8b 0d 28 10 11 80    	mov    0x80111028,%ecx
80100da8:	8b 3d 20 10 11 80    	mov    0x80111020,%edi
80100dae:	89 c8                	mov    %ecx,%eax
80100db0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100db3:	29 f8                	sub    %edi,%eax
80100db5:	83 f8 7f             	cmp    $0x7f,%eax
80100db8:	0f 87 b4 fe ff ff    	ja     80100c72 <consoleintr+0x22>
        c = (c == '\r') ? '\n' : c;
80100dbe:	83 fe 0d             	cmp    $0xd,%esi
80100dc1:	0f 84 69 04 00 00    	je     80101230 <consoleintr+0x5e0>
80100dc7:	89 f0                	mov    %esi,%eax
80100dc9:	88 45 e0             	mov    %al,-0x20(%ebp)
        if (input.rightmost > input.e) { // caret isn't at the end of the line
80100dcc:	8b 15 2c 10 11 80    	mov    0x8011102c,%edx
80100dd2:	89 cf                	mov    %ecx,%edi
80100dd4:	8d 41 01             	lea    0x1(%ecx),%eax
80100dd7:	83 e7 7f             	and    $0x7f,%edi
80100dda:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100ddd:	89 7d dc             	mov    %edi,-0x24(%ebp)
80100de0:	39 d1                	cmp    %edx,%ecx
80100de2:	0f 82 ee 03 00 00    	jb     801011d6 <consoleintr+0x586>
          input.buf[input.e++ % INPUT_BUF] = c;
80100de8:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80100dec:	8b 7d dc             	mov    -0x24(%ebp),%edi
          input.rightmost = input.e - input.rightmost == 1 ? input.e : input.rightmost;
80100def:	89 c2                	mov    %eax,%edx
          input.buf[input.e++ % INPUT_BUF] = c;
80100df1:	a3 28 10 11 80       	mov    %eax,0x80111028
80100df6:	88 8f a0 0f 11 80    	mov    %cl,-0x7feef060(%edi)
          input.rightmost = input.e - input.rightmost == 1 ? input.e : input.rightmost;
80100dfc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80100dff:	29 ca                	sub    %ecx,%edx
80100e01:	83 fa 01             	cmp    $0x1,%edx
80100e04:	0f 45 c1             	cmovne %ecx,%eax
80100e07:	a3 2c 10 11 80       	mov    %eax,0x8011102c
  if(panicked){
80100e0c:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100e11:	85 c0                	test   %eax,%eax
80100e13:	0f 84 74 03 00 00    	je     8010118d <consoleintr+0x53d>
80100e19:	fa                   	cli    
    for(;;)
80100e1a:	eb fe                	jmp    80100e1a <consoleintr+0x1ca>
      if (input.rightmost > input.e) { 
80100e1c:	a1 2c 10 11 80       	mov    0x8011102c,%eax
80100e21:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100e27:	8b 35 24 10 11 80    	mov    0x80111024,%esi
80100e2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e30:	39 d0                	cmp    %edx,%eax
80100e32:	0f 87 18 01 00 00    	ja     80100f50 <consoleintr+0x300>
          while(input.e != input.w &&
80100e38:	39 f2                	cmp    %esi,%edx
80100e3a:	0f 84 32 fe ff ff    	je     80100c72 <consoleintr+0x22>
                input.buf[(input.e - 1) % INPUT_BUF] != '\n'){
80100e40:	83 ea 01             	sub    $0x1,%edx
80100e43:	89 d0                	mov    %edx,%eax
80100e45:	83 e0 7f             	and    $0x7f,%eax
          while(input.e != input.w &&
80100e48:	80 b8 a0 0f 11 80 0a 	cmpb   $0xa,-0x7feef060(%eax)
80100e4f:	0f 84 1d fe ff ff    	je     80100c72 <consoleintr+0x22>
  if(panicked){
80100e55:	a1 58 b5 10 80       	mov    0x8010b558,%eax
            input.rightmost--;
80100e5a:	83 2d 2c 10 11 80 01 	subl   $0x1,0x8011102c
            input.e--;
80100e61:	89 15 28 10 11 80    	mov    %edx,0x80111028
  if(panicked){
80100e67:	85 c0                	test   %eax,%eax
80100e69:	0f 84 41 02 00 00    	je     801010b0 <consoleintr+0x460>
80100e6f:	fa                   	cli    
    for(;;)
80100e70:	eb fe                	jmp    80100e70 <consoleintr+0x220>
80100e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (historyBufferArray.currentHistory < historyBufferArray.numOfCommmandsInMem-1 ){ // current history means the oldest possible will be MAX_HISTORY-1
80100e78:	a1 a4 19 11 80       	mov    0x801119a4,%eax
80100e7d:	83 e8 01             	sub    $0x1,%eax
80100e80:	39 05 a8 19 11 80    	cmp    %eax,0x801119a8
80100e86:	0f 8d e6 fd ff ff    	jge    80100c72 <consoleintr+0x22>
        earaseCurrentLineOnScreen();
80100e8c:	e8 ef fb ff ff       	call   80100a80 <earaseCurrentLineOnScreen>
        if (historyBufferArray.currentHistory == -1)
80100e91:	a1 a8 19 11 80       	mov    0x801119a8,%eax
80100e96:	8b 3d 20 10 11 80    	mov    0x80111020,%edi
80100e9c:	83 f8 ff             	cmp    $0xffffffff,%eax
80100e9f:	0f 84 d5 03 00 00    	je     8010127a <consoleintr+0x62a>
        historyBufferArray.currentHistory++;
80100ea5:	83 c0 01             	add    $0x1,%eax
        copyBufferToScreen(historyBufferArray.bufferArr[ tempIndex]  , historyBufferArray.lengthsArr[tempIndex]);
80100ea8:	83 ec 08             	sub    $0x8,%esp
  input.rightmost = input.r;
80100eab:	89 3d 2c 10 11 80    	mov    %edi,0x8011102c
        historyBufferArray.currentHistory++;
80100eb1:	a3 a8 19 11 80       	mov    %eax,0x801119a8
        tempIndex = (historyBufferArray.lastCommandIndex + historyBufferArray.currentHistory) %MAX_HISTORY;
80100eb6:	03 05 a0 19 11 80    	add    0x801119a0,%eax
80100ebc:	89 c6                	mov    %eax,%esi
  input.e = input.r;
80100ebe:	89 3d 28 10 11 80    	mov    %edi,0x80111028
        tempIndex = (historyBufferArray.lastCommandIndex + historyBufferArray.currentHistory) %MAX_HISTORY;
80100ec4:	83 e6 0f             	and    $0xf,%esi
        copyBufferToScreen(historyBufferArray.bufferArr[ tempIndex]  , historyBufferArray.lengthsArr[tempIndex]);
80100ec7:	89 f2                	mov    %esi,%edx
80100ec9:	81 c6 00 02 00 00    	add    $0x200,%esi
80100ecf:	c1 e2 07             	shl    $0x7,%edx
80100ed2:	ff 34 b5 60 11 11 80 	pushl  -0x7feeeea0(,%esi,4)
80100ed9:	8d ba 60 11 11 80    	lea    -0x7feeeea0(%edx),%edi
80100edf:	57                   	push   %edi
80100ee0:	e8 4b fc ff ff       	call   80100b30 <copyBufferToScreen>
        copyBufferToInputBuf(historyBufferArray.bufferArr[ tempIndex]  , historyBufferArray.lengthsArr[tempIndex]);
80100ee5:	8b 34 b5 60 11 11 80 	mov    -0x7feeeea0(,%esi,4),%esi
  for (i = 0; i < length; i++) {
80100eec:	83 c4 10             	add    $0x10,%esp
80100eef:	85 f6                	test   %esi,%esi
80100ef1:	0f 84 78 03 00 00    	je     8010126f <consoleintr+0x61f>
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80100ef7:	a1 20 10 11 80       	mov    0x80111020,%eax
80100efc:	29 c7                	sub    %eax,%edi
80100efe:	01 c6                	add    %eax,%esi
80100f00:	89 fa                	mov    %edi,%edx
80100f02:	89 df                	mov    %ebx,%edi
80100f04:	0f b6 1c 02          	movzbl (%edx,%eax,1),%ebx
80100f08:	89 c1                	mov    %eax,%ecx
80100f0a:	83 c0 01             	add    $0x1,%eax
80100f0d:	83 e1 7f             	and    $0x7f,%ecx
80100f10:	88 99 a0 0f 11 80    	mov    %bl,-0x7feef060(%ecx)
  for (i = 0; i < length; i++) {
80100f16:	39 c6                	cmp    %eax,%esi
80100f18:	75 ea                	jne    80100f04 <consoleintr+0x2b4>
80100f1a:	89 fb                	mov    %edi,%ebx
  input.e = input.r+length;
80100f1c:	89 35 28 10 11 80    	mov    %esi,0x80111028
  input.rightmost = input.e;
80100f22:	89 35 2c 10 11 80    	mov    %esi,0x8011102c
}
80100f28:	e9 45 fd ff ff       	jmp    80100c72 <consoleintr+0x22>
      if (input.e < input.rightmost) {
80100f2d:	a1 28 10 11 80       	mov    0x80111028,%eax
80100f32:	3b 05 2c 10 11 80    	cmp    0x8011102c,%eax
80100f38:	73 36                	jae    80100f70 <consoleintr+0x320>
  if(panicked){
80100f3a:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
80100f40:	85 ff                	test   %edi,%edi
80100f42:	0f 84 18 01 00 00    	je     80101060 <consoleintr+0x410>
80100f48:	fa                   	cli    
    for(;;)
80100f49:	eb fe                	jmp    80100f49 <consoleintr+0x2f9>
80100f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f4f:	90                   	nop
          for (i = 0; i < placestoshift; i++) {
80100f50:	89 d7                	mov    %edx,%edi
80100f52:	31 c9                	xor    %ecx,%ecx
80100f54:	29 f7                	sub    %esi,%edi
80100f56:	74 61                	je     80100fb9 <consoleintr+0x369>
80100f58:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100f5b:	89 cb                	mov    %ecx,%ebx
80100f5d:	89 75 dc             	mov    %esi,-0x24(%ebp)
80100f60:	89 d6                	mov    %edx,%esi
  if(panicked){
80100f62:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100f68:	85 c9                	test   %ecx,%ecx
80100f6a:	74 34                	je     80100fa0 <consoleintr+0x350>
80100f6c:	fa                   	cli    
    for(;;)
80100f6d:	eb fe                	jmp    80100f6d <consoleintr+0x31d>
80100f6f:	90                   	nop
      } else if (input.e == input.rightmost) {
80100f70:	0f 85 fc fc ff ff    	jne    80100c72 <consoleintr+0x22>
  if(panicked){
80100f76:	8b 35 58 b5 10 80    	mov    0x8010b558,%esi
80100f7c:	85 f6                	test   %esi,%esi
80100f7e:	0f 85 cb 02 00 00    	jne    8010124f <consoleintr+0x5ff>
80100f84:	b8 20 00 00 00       	mov    $0x20,%eax
80100f89:	e8 82 f4 ff ff       	call   80100410 <consputc.part.0>
80100f8e:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100f94:	85 c9                	test   %ecx,%ecx
80100f96:	0f 84 df 00 00 00    	je     8010107b <consoleintr+0x42b>
80100f9c:	fa                   	cli    
    for(;;)
80100f9d:	eb fe                	jmp    80100f9d <consoleintr+0x34d>
80100f9f:	90                   	nop
80100fa0:	b8 4b 00 00 00       	mov    $0x4b,%eax
          for (i = 0; i < placestoshift; i++) {
80100fa5:	83 c3 01             	add    $0x1,%ebx
80100fa8:	e8 63 f4 ff ff       	call   80100410 <consputc.part.0>
80100fad:	39 df                	cmp    %ebx,%edi
80100faf:	75 b1                	jne    80100f62 <consoleintr+0x312>
80100fb1:	89 f2                	mov    %esi,%edx
80100fb3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100fb6:	8b 75 dc             	mov    -0x24(%ebp),%esi
          memset(buf2, '\0', INPUT_BUF);
80100fb9:	83 ec 04             	sub    $0x4,%esp
          uint numtoshift = input.rightmost - input.e;
80100fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100fbf:	89 55 d0             	mov    %edx,-0x30(%ebp)
          memset(buf2, '\0', INPUT_BUF);
80100fc2:	68 80 00 00 00       	push   $0x80
80100fc7:	6a 00                	push   $0x0
          uint numtoshift = input.rightmost - input.e;
80100fc9:	29 d0                	sub    %edx,%eax
          memset(buf2, '\0', INPUT_BUF);
80100fcb:	68 40 10 11 80       	push   $0x80111040
          uint numtoshift = input.rightmost - input.e;
80100fd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          memset(buf2, '\0', INPUT_BUF);
80100fd3:	e8 28 40 00 00       	call   80105000 <memset>
            buf2[i] = input.buf[(input.w + i + placestoshift) % INPUT_BUF];
80100fd8:	a1 24 10 11 80       	mov    0x80111024,%eax
80100fdd:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100fe0:	83 c4 10             	add    $0x10,%esp
80100fe3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe6:	01 f8                	add    %edi,%eax
80100fe8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
          for (i = 0; i < numtoshift; i++) {
80100feb:	31 c0                	xor    %eax,%eax
            buf2[i] = input.buf[(input.w + i + placestoshift) % INPUT_BUF];
80100fed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100ff0:	01 c1                	add    %eax,%ecx
          for (i = 0; i < numtoshift; i++) {
80100ff2:	83 c0 01             	add    $0x1,%eax
            buf2[i] = input.buf[(input.w + i + placestoshift) % INPUT_BUF];
80100ff5:	83 e1 7f             	and    $0x7f,%ecx
80100ff8:	0f b6 89 a0 0f 11 80 	movzbl -0x7feef060(%ecx),%ecx
80100fff:	88 88 3f 10 11 80    	mov    %cl,-0x7feeefc1(%eax)
          for (i = 0; i < numtoshift; i++) {
80101005:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
80101008:	75 e3                	jne    80100fed <consoleintr+0x39d>
          for (i = 0; i < numtoshift; i++) {
8010100a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010100d:	31 c0                	xor    %eax,%eax
            input.buf[(input.w + i) % INPUT_BUF] = buf2[i];
8010100f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101012:	0f b6 90 40 10 11 80 	movzbl -0x7feeefc0(%eax),%edx
80101019:	01 c1                	add    %eax,%ecx
          for (i = 0; i < numtoshift; i++) {
8010101b:	83 c0 01             	add    $0x1,%eax
            input.buf[(input.w + i) % INPUT_BUF] = buf2[i];
8010101e:	83 e1 7f             	and    $0x7f,%ecx
80101021:	88 91 a0 0f 11 80    	mov    %dl,-0x7feef060(%ecx)
          for (i = 0; i < numtoshift; i++) {
80101027:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
8010102a:	75 e3                	jne    8010100f <consoleintr+0x3bf>
8010102c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          input.e -= placestoshift;
8010102f:	89 f0                	mov    %esi,%eax
          for (i = 0; i < numtoshift; i++) { 
80101031:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101034:	89 de                	mov    %ebx,%esi
80101036:	29 d0                	sub    %edx,%eax
80101038:	89 c2                	mov    %eax,%edx
          input.e -= placestoshift;
8010103a:	03 05 28 10 11 80    	add    0x80111028,%eax
          input.rightmost -= placestoshift;
80101040:	01 15 2c 10 11 80    	add    %edx,0x8011102c
          for (i = 0; i < numtoshift; i++) { 
80101046:	31 d2                	xor    %edx,%edx
          input.e -= placestoshift;
80101048:	a3 28 10 11 80       	mov    %eax,0x80111028
          for (i = 0; i < numtoshift; i++) { 
8010104d:	89 d3                	mov    %edx,%ebx
  if(panicked){
8010104f:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80101055:	85 d2                	test   %edx,%edx
80101057:	0f 84 52 02 00 00    	je     801012af <consoleintr+0x65f>
8010105d:	fa                   	cli    
    for(;;)
8010105e:	eb fe                	jmp    8010105e <consoleintr+0x40e>
        consputc(input.buf[input.e % INPUT_BUF]);
80101060:	83 e0 7f             	and    $0x7f,%eax
80101063:	0f be 80 a0 0f 11 80 	movsbl -0x7feef060(%eax),%eax
8010106a:	e8 a1 f3 ff ff       	call   80100410 <consputc.part.0>
        input.e++;
8010106f:	83 05 28 10 11 80 01 	addl   $0x1,0x80111028
80101076:	e9 f7 fb ff ff       	jmp    80100c72 <consoleintr+0x22>
8010107b:	b8 4b 00 00 00       	mov    $0x4b,%eax
80101080:	e8 8b f3 ff ff       	call   80100410 <consputc.part.0>
80101085:	e9 e8 fb ff ff       	jmp    80100c72 <consoleintr+0x22>
      if(input.e != input.w){ 
8010108a:	39 d0                	cmp    %edx,%eax
8010108c:	0f 84 e0 fb ff ff    	je     80100c72 <consoleintr+0x22>
        input.e--;
80101092:	83 e8 01             	sub    $0x1,%eax
80101095:	a3 28 10 11 80       	mov    %eax,0x80111028
        input.rightmost--;
8010109a:	a3 2c 10 11 80       	mov    %eax,0x8011102c
  if(panicked){
8010109f:	a1 58 b5 10 80       	mov    0x8010b558,%eax
801010a4:	85 c0                	test   %eax,%eax
801010a6:	0f 84 d2 00 00 00    	je     8010117e <consoleintr+0x52e>
801010ac:	fa                   	cli    
    for(;;)
801010ad:	eb fe                	jmp    801010ad <consoleintr+0x45d>
801010af:	90                   	nop
801010b0:	b8 00 01 00 00       	mov    $0x100,%eax
801010b5:	e8 56 f3 ff ff       	call   80100410 <consputc.part.0>
          while(input.e != input.w &&
801010ba:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801010c0:	3b 15 24 10 11 80    	cmp    0x80111024,%edx
801010c6:	0f 85 74 fd ff ff    	jne    80100e40 <consoleintr+0x1f0>
801010cc:	e9 a1 fb ff ff       	jmp    80100c72 <consoleintr+0x22>
801010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          earaseCurrentLineOnScreen();
801010d8:	e8 a3 f9 ff ff       	call   80100a80 <earaseCurrentLineOnScreen>
          historyBufferArray.currentHistory--;
801010dd:	a1 a8 19 11 80       	mov    0x801119a8,%eax
          copyBufferToScreen(historyBufferArray.bufferArr[ tempIndex]  , historyBufferArray.lengthsArr[tempIndex]);
801010e2:	83 ec 08             	sub    $0x8,%esp
          historyBufferArray.currentHistory--;
801010e5:	83 e8 01             	sub    $0x1,%eax
801010e8:	a3 a8 19 11 80       	mov    %eax,0x801119a8
          tempIndex = (historyBufferArray.lastCommandIndex + historyBufferArray.currentHistory)%MAX_HISTORY;
801010ed:	03 05 a0 19 11 80    	add    0x801119a0,%eax
801010f3:	89 c6                	mov    %eax,%esi
801010f5:	83 e6 0f             	and    $0xf,%esi
          copyBufferToScreen(historyBufferArray.bufferArr[ tempIndex]  , historyBufferArray.lengthsArr[tempIndex]);
801010f8:	89 f7                	mov    %esi,%edi
801010fa:	81 c6 00 02 00 00    	add    $0x200,%esi
80101100:	c1 e7 07             	shl    $0x7,%edi
80101103:	ff 34 b5 60 11 11 80 	pushl  -0x7feeeea0(,%esi,4)
8010110a:	81 c7 60 11 11 80    	add    $0x80111160,%edi
80101110:	57                   	push   %edi
80101111:	e8 1a fa ff ff       	call   80100b30 <copyBufferToScreen>
          copyBufferToInputBuf(historyBufferArray.bufferArr[ tempIndex]  , historyBufferArray.lengthsArr[tempIndex]);
80101116:	8b 14 b5 60 11 11 80 	mov    -0x7feeeea0(,%esi,4),%edx
  for (i = 0; i < length; i++) {
8010111d:	83 c4 10             	add    $0x10,%esp
80101120:	85 d2                	test   %edx,%edx
80101122:	0f 84 3c 01 00 00    	je     80101264 <consoleintr+0x614>
    input.buf[(input.r+i)%INPUT_BUF] = bufToSaveInInput[i];
80101128:	a1 20 10 11 80       	mov    0x80111020,%eax
8010112d:	29 c7                	sub    %eax,%edi
8010112f:	01 c2                	add    %eax,%edx
80101131:	89 fe                	mov    %edi,%esi
80101133:	89 df                	mov    %ebx,%edi
80101135:	0f b6 1c 06          	movzbl (%esi,%eax,1),%ebx
80101139:	89 c1                	mov    %eax,%ecx
8010113b:	83 c0 01             	add    $0x1,%eax
8010113e:	83 e1 7f             	and    $0x7f,%ecx
80101141:	88 99 a0 0f 11 80    	mov    %bl,-0x7feef060(%ecx)
  for (i = 0; i < length; i++) {
80101147:	39 c2                	cmp    %eax,%edx
80101149:	75 ea                	jne    80101135 <consoleintr+0x4e5>
8010114b:	89 fb                	mov    %edi,%ebx
  input.e = input.r+length;
8010114d:	89 15 28 10 11 80    	mov    %edx,0x80111028
  input.rightmost = input.e;
80101153:	89 15 2c 10 11 80    	mov    %edx,0x8011102c
}
80101159:	e9 14 fb ff ff       	jmp    80100c72 <consoleintr+0x22>
  release(&cons.lock);
8010115e:	83 ec 0c             	sub    $0xc,%esp
80101161:	68 20 b5 10 80       	push   $0x8010b520
80101166:	e8 45 3e 00 00       	call   80104fb0 <release>
  if(doprocdump) {
8010116b:	83 c4 10             	add    $0x10,%esp
8010116e:	85 db                	test   %ebx,%ebx
80101170:	0f 85 e2 00 00 00    	jne    80101258 <consoleintr+0x608>
}
80101176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101179:	5b                   	pop    %ebx
8010117a:	5e                   	pop    %esi
8010117b:	5f                   	pop    %edi
8010117c:	5d                   	pop    %ebp
8010117d:	c3                   	ret    
8010117e:	b8 00 01 00 00       	mov    $0x100,%eax
80101183:	e8 88 f2 ff ff       	call   80100410 <consputc.part.0>
80101188:	e9 e5 fa ff ff       	jmp    80100c72 <consoleintr+0x22>
8010118d:	89 f0                	mov    %esi,%eax
8010118f:	e8 7c f2 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.rightmost == input.r + INPUT_BUF){
80101194:	83 fe 0a             	cmp    $0xa,%esi
80101197:	74 19                	je     801011b2 <consoleintr+0x562>
80101199:	83 fe 04             	cmp    $0x4,%esi
8010119c:	74 14                	je     801011b2 <consoleintr+0x562>
8010119e:	a1 20 10 11 80       	mov    0x80111020,%eax
801011a3:	83 e8 80             	sub    $0xffffff80,%eax
801011a6:	39 05 2c 10 11 80    	cmp    %eax,0x8011102c
801011ac:	0f 85 c0 fa ff ff    	jne    80100c72 <consoleintr+0x22>
          saveCommandInHistory();
801011b2:	e8 19 fa ff ff       	call   80100bd0 <saveCommandInHistory>
          wakeup(&input.r);
801011b7:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.rightmost;
801011ba:	a1 2c 10 11 80       	mov    0x8011102c,%eax
          wakeup(&input.r);
801011bf:	68 20 10 11 80       	push   $0x80111020
          input.w = input.rightmost;
801011c4:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
801011c9:	e8 a2 38 00 00       	call   80104a70 <wakeup>
801011ce:	83 c4 10             	add    $0x10,%esp
801011d1:	e9 9c fa ff ff       	jmp    80100c72 <consoleintr+0x22>
  for (i = 0; i < n; i++)
801011d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801011d9:	31 d2                	xor    %edx,%edx
801011db:	2b 7d d4             	sub    -0x2c(%ebp),%edi
801011de:	89 7d d4             	mov    %edi,-0x2c(%ebp)
801011e1:	74 21                	je     80101204 <consoleintr+0x5b4>
801011e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    charsToBeMoved[i] = input.buf[(input.e + i) % INPUT_BUF];
801011e6:	8d 3c 11             	lea    (%ecx,%edx,1),%edi
  for (i = 0; i < n; i++)
801011e9:	83 c2 01             	add    $0x1,%edx
    charsToBeMoved[i] = input.buf[(input.e + i) % INPUT_BUF];
801011ec:	83 e7 7f             	and    $0x7f,%edi
801011ef:	0f b6 87 a0 0f 11 80 	movzbl -0x7feef060(%edi),%eax
801011f6:	88 82 df 10 11 80    	mov    %al,-0x7feeef21(%edx)
  for (i = 0; i < n; i++)
801011fc:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
801011ff:	75 e5                	jne    801011e6 <consoleintr+0x596>
80101201:	8b 45 d0             	mov    -0x30(%ebp),%eax
          input.buf[input.e++ % INPUT_BUF] = c;
80101204:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  if(panicked){
80101207:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
          input.buf[input.e++ % INPUT_BUF] = c;
8010120d:	a3 28 10 11 80       	mov    %eax,0x80111028
80101212:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80101216:	88 81 a0 0f 11 80    	mov    %al,-0x7feef060(%ecx)
          input.rightmost++;
8010121c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	a3 2c 10 11 80       	mov    %eax,0x8011102c
  if(panicked){
80101227:	85 d2                	test   %edx,%edx
80101229:	74 13                	je     8010123e <consoleintr+0x5ee>
8010122b:	fa                   	cli    
    for(;;)
8010122c:	eb fe                	jmp    8010122c <consoleintr+0x5dc>
8010122e:	66 90                	xchg   %ax,%ax
80101230:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
        c = (c == '\r') ? '\n' : c;
80101234:	be 0a 00 00 00       	mov    $0xa,%esi
80101239:	e9 8e fb ff ff       	jmp    80100dcc <consoleintr+0x17c>
8010123e:	89 f0                	mov    %esi,%eax
80101240:	e8 cb f1 ff ff       	call   80100410 <consputc.part.0>
          shiftbufright();
80101245:	e8 a6 f6 ff ff       	call   801008f0 <shiftbufright>
8010124a:	e9 45 ff ff ff       	jmp    80101194 <consoleintr+0x544>
8010124f:	fa                   	cli    
    for(;;)
80101250:	eb fe                	jmp    80101250 <consoleintr+0x600>
80101252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80101258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125b:	5b                   	pop    %ebx
8010125c:	5e                   	pop    %esi
8010125d:	5f                   	pop    %edi
8010125e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
8010125f:	e9 fc 38 00 00       	jmp    80104b60 <procdump>
80101264:	8b 15 20 10 11 80    	mov    0x80111020,%edx
8010126a:	e9 de fe ff ff       	jmp    8010114d <consoleintr+0x4fd>
8010126f:	8b 35 20 10 11 80    	mov    0x80111020,%esi
80101275:	e9 a2 fc ff ff       	jmp    80100f1c <consoleintr+0x2cc>
    lengthOfOldBuf = input.rightmost - input.r;
8010127a:	8b 35 2c 10 11 80    	mov    0x8011102c,%esi
80101280:	29 fe                	sub    %edi,%esi
80101282:	89 35 c0 10 11 80    	mov    %esi,0x801110c0
    for (i = 0; i < lengthOfOldBuf; i++) {
80101288:	0f 84 17 fc ff ff    	je     80100ea5 <consoleintr+0x255>
8010128e:	31 d2                	xor    %edx,%edx
        oldBuf[i] = input.buf[(input.r+i)%INPUT_BUF];
80101290:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
    for (i = 0; i < lengthOfOldBuf; i++) {
80101293:	83 c2 01             	add    $0x1,%edx
        oldBuf[i] = input.buf[(input.r+i)%INPUT_BUF];
80101296:	83 e1 7f             	and    $0x7f,%ecx
80101299:	0f b6 89 a0 0f 11 80 	movzbl -0x7feef060(%ecx),%ecx
801012a0:	88 8a 1f 0f 11 80    	mov    %cl,-0x7feef0e1(%edx)
    for (i = 0; i < lengthOfOldBuf; i++) {
801012a6:	39 d6                	cmp    %edx,%esi
801012a8:	75 e6                	jne    80101290 <consoleintr+0x640>
801012aa:	e9 f6 fb ff ff       	jmp    80100ea5 <consoleintr+0x255>
            consputc(input.buf[(input.e + i) % INPUT_BUF]);
801012af:	01 d8                	add    %ebx,%eax
          for (i = 0; i < numtoshift; i++) { 
801012b1:	83 c3 01             	add    $0x1,%ebx
            consputc(input.buf[(input.e + i) % INPUT_BUF]);
801012b4:	83 e0 7f             	and    $0x7f,%eax
801012b7:	0f be 80 a0 0f 11 80 	movsbl -0x7feef060(%eax),%eax
801012be:	e8 4d f1 ff ff       	call   80100410 <consputc.part.0>
          for (i = 0; i < numtoshift; i++) { 
801012c3:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801012c6:	74 0a                	je     801012d2 <consoleintr+0x682>
801012c8:	a1 28 10 11 80       	mov    0x80111028,%eax
801012cd:	e9 7d fd ff ff       	jmp    8010104f <consoleintr+0x3ff>
801012d2:	89 f3                	mov    %esi,%ebx
          for (i = 0; i < placestoshift; i++) { 
801012d4:	31 d2                	xor    %edx,%edx
801012d6:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012d9:	85 ff                	test   %edi,%edi
801012db:	74 29                	je     80101306 <consoleintr+0x6b6>
801012dd:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801012e0:	89 de                	mov    %ebx,%esi
801012e2:	89 d3                	mov    %edx,%ebx
  if(panicked){
801012e4:	a1 58 b5 10 80       	mov    0x8010b558,%eax
801012e9:	85 c0                	test   %eax,%eax
801012eb:	74 03                	je     801012f0 <consoleintr+0x6a0>
801012ed:	fa                   	cli    
    for(;;)
801012ee:	eb fe                	jmp    801012ee <consoleintr+0x69e>
801012f0:	b8 20 00 00 00       	mov    $0x20,%eax
          for (i = 0; i < placestoshift; i++) { 
801012f5:	83 c3 01             	add    $0x1,%ebx
801012f8:	e8 13 f1 ff ff       	call   80100410 <consputc.part.0>
801012fd:	39 df                	cmp    %ebx,%edi
801012ff:	75 e3                	jne    801012e4 <consoleintr+0x694>
80101301:	89 f3                	mov    %esi,%ebx
80101303:	8b 75 e4             	mov    -0x1c(%ebp),%esi
          for (i = 0; i < placestoshift + numtoshift; i++) { 
80101306:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101309:	31 ff                	xor    %edi,%edi
8010130b:	29 f0                	sub    %esi,%eax
8010130d:	89 c6                	mov    %eax,%esi
8010130f:	39 fe                	cmp    %edi,%esi
80101311:	0f 86 5b f9 ff ff    	jbe    80100c72 <consoleintr+0x22>
  if(panicked){
80101317:	83 3d 58 b5 10 80 00 	cmpl   $0x0,0x8010b558
8010131e:	74 03                	je     80101323 <consoleintr+0x6d3>
80101320:	fa                   	cli    
    for(;;)
80101321:	eb fe                	jmp    80101321 <consoleintr+0x6d1>
80101323:	b8 4b 00 00 00       	mov    $0x4b,%eax
          for (i = 0; i < placestoshift + numtoshift; i++) { 
80101328:	83 c7 01             	add    $0x1,%edi
8010132b:	e8 e0 f0 ff ff       	call   80100410 <consputc.part.0>
80101330:	eb dd                	jmp    8010130f <consoleintr+0x6bf>
80101332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101340 <history>:
int history(char *buffer, int historyId) {
80101340:	f3 0f 1e fb          	endbr32 
80101344:	55                   	push   %ebp
80101345:	89 e5                	mov    %esp,%ebp
80101347:	56                   	push   %esi
80101348:	53                   	push   %ebx
80101349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010134c:	8b 75 08             	mov    0x8(%ebp),%esi
  if (historyId < 0 || historyId > MAX_HISTORY - 1)
8010134f:	83 fb 0f             	cmp    $0xf,%ebx
80101352:	77 5c                	ja     801013b0 <history+0x70>
  if (historyId >= historyBufferArray.numOfCommmandsInMem )
80101354:	39 1d a4 19 11 80    	cmp    %ebx,0x801119a4
8010135a:	7e 44                	jle    801013a0 <history+0x60>
  memset(buffer, '\0', INPUT_BUF);
8010135c:	83 ec 04             	sub    $0x4,%esp
8010135f:	68 80 00 00 00       	push   $0x80
80101364:	6a 00                	push   $0x0
80101366:	56                   	push   %esi
80101367:	e8 94 3c 00 00       	call   80105000 <memset>
  int tempIndex = (historyBufferArray.lastCommandIndex + historyId) % MAX_HISTORY;
8010136c:	03 1d a0 19 11 80    	add    0x801119a0,%ebx
  memmove(buffer, historyBufferArray.bufferArr[tempIndex], historyBufferArray.lengthsArr[tempIndex]);
80101372:	83 c4 0c             	add    $0xc,%esp
  int tempIndex = (historyBufferArray.lastCommandIndex + historyId) % MAX_HISTORY;
80101375:	83 e3 0f             	and    $0xf,%ebx
  memmove(buffer, historyBufferArray.bufferArr[tempIndex], historyBufferArray.lengthsArr[tempIndex]);
80101378:	ff 34 9d 60 19 11 80 	pushl  -0x7feee6a0(,%ebx,4)
8010137f:	c1 e3 07             	shl    $0x7,%ebx
80101382:	81 c3 60 11 11 80    	add    $0x80111160,%ebx
80101388:	53                   	push   %ebx
80101389:	56                   	push   %esi
8010138a:	e8 11 3d 00 00       	call   801050a0 <memmove>
  return 0;
8010138f:	83 c4 10             	add    $0x10,%esp
80101392:	31 c0                	xor    %eax,%eax
}
80101394:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101397:	5b                   	pop    %ebx
80101398:	5e                   	pop    %esi
80101399:	5d                   	pop    %ebp
8010139a:	c3                   	ret    
8010139b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010139f:	90                   	nop
    return -1;
801013a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013a5:	eb ed                	jmp    80101394 <history+0x54>
801013a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ae:	66 90                	xchg   %ax,%ax
    return -2;
801013b0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801013b5:	eb dd                	jmp    80101394 <history+0x54>
801013b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013be:	66 90                	xchg   %ax,%ax

801013c0 <consoleinit>:

void
consoleinit(void)
{
801013c0:	f3 0f 1e fb          	endbr32 
801013c4:	55                   	push   %ebp
801013c5:	89 e5                	mov    %esp,%ebp
801013c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801013ca:	68 68 7b 10 80       	push   $0x80107b68
801013cf:	68 20 b5 10 80       	push   $0x8010b520
801013d4:	e8 97 39 00 00       	call   80104d70 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801013d9:	58                   	pop    %eax
801013da:	5a                   	pop    %edx
801013db:	6a 00                	push   $0x0
801013dd:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801013df:	c7 05 6c 23 11 80 80 	movl   $0x80100680,0x8011236c
801013e6:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801013e9:	c7 05 68 23 11 80 90 	movl   $0x80100290,0x80112368
801013f0:	02 10 80 
  cons.locking = 1;
801013f3:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801013fa:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801013fd:	e8 be 19 00 00       	call   80102dc0 <ioapicenable>
}
80101402:	83 c4 10             	add    $0x10,%esp
80101405:	c9                   	leave  
80101406:	c3                   	ret    
80101407:	66 90                	xchg   %ax,%ax
80101409:	66 90                	xchg   %ax,%ax
8010140b:	66 90                	xchg   %ax,%ax
8010140d:	66 90                	xchg   %ax,%ax
8010140f:	90                   	nop

80101410 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101410:	f3 0f 1e fb          	endbr32 
80101414:	55                   	push   %ebp
80101415:	89 e5                	mov    %esp,%ebp
80101417:	57                   	push   %edi
80101418:	56                   	push   %esi
80101419:	53                   	push   %ebx
8010141a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101420:	e8 cb 2e 00 00       	call   801042f0 <myproc>
80101425:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
8010142b:	e8 90 22 00 00       	call   801036c0 <begin_op>

  if((ip = namei(path)) == 0){
80101430:	83 ec 0c             	sub    $0xc,%esp
80101433:	ff 75 08             	pushl  0x8(%ebp)
80101436:	e8 85 15 00 00       	call   801029c0 <namei>
8010143b:	83 c4 10             	add    $0x10,%esp
8010143e:	85 c0                	test   %eax,%eax
80101440:	0f 84 fe 02 00 00    	je     80101744 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101446:	83 ec 0c             	sub    $0xc,%esp
80101449:	89 c3                	mov    %eax,%ebx
8010144b:	50                   	push   %eax
8010144c:	e8 9f 0c 00 00       	call   801020f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101451:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101457:	6a 34                	push   $0x34
80101459:	6a 00                	push   $0x0
8010145b:	50                   	push   %eax
8010145c:	53                   	push   %ebx
8010145d:	e8 8e 0f 00 00       	call   801023f0 <readi>
80101462:	83 c4 20             	add    $0x20,%esp
80101465:	83 f8 34             	cmp    $0x34,%eax
80101468:	74 26                	je     80101490 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010146a:	83 ec 0c             	sub    $0xc,%esp
8010146d:	53                   	push   %ebx
8010146e:	e8 1d 0f 00 00       	call   80102390 <iunlockput>
    end_op();
80101473:	e8 b8 22 00 00       	call   80103730 <end_op>
80101478:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010147b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101480:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101483:	5b                   	pop    %ebx
80101484:	5e                   	pop    %esi
80101485:	5f                   	pop    %edi
80101486:	5d                   	pop    %ebp
80101487:	c3                   	ret    
80101488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80101490:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101497:	45 4c 46 
8010149a:	75 ce                	jne    8010146a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
8010149c:	e8 bf 63 00 00       	call   80107860 <setupkvm>
801014a1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801014a7:	85 c0                	test   %eax,%eax
801014a9:	74 bf                	je     8010146a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801014ab:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801014b2:	00 
801014b3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801014b9:	0f 84 a4 02 00 00    	je     80101763 <exec+0x353>
  sz = 0;
801014bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801014c6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801014c9:	31 ff                	xor    %edi,%edi
801014cb:	e9 86 00 00 00       	jmp    80101556 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
801014d0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801014d7:	75 6c                	jne    80101545 <exec+0x135>
    if(ph.memsz < ph.filesz)
801014d9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801014df:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801014e5:	0f 82 87 00 00 00    	jb     80101572 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801014eb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801014f1:	72 7f                	jb     80101572 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801014f3:	83 ec 04             	sub    $0x4,%esp
801014f6:	50                   	push   %eax
801014f7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801014fd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101503:	e8 78 61 00 00       	call   80107680 <allocuvm>
80101508:	83 c4 10             	add    $0x10,%esp
8010150b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101511:	85 c0                	test   %eax,%eax
80101513:	74 5d                	je     80101572 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101515:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010151b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101520:	75 50                	jne    80101572 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010152b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101531:	53                   	push   %ebx
80101532:	50                   	push   %eax
80101533:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101539:	e8 72 60 00 00       	call   801075b0 <loaduvm>
8010153e:	83 c4 20             	add    $0x20,%esp
80101541:	85 c0                	test   %eax,%eax
80101543:	78 2d                	js     80101572 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101545:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010154c:	83 c7 01             	add    $0x1,%edi
8010154f:	83 c6 20             	add    $0x20,%esi
80101552:	39 f8                	cmp    %edi,%eax
80101554:	7e 3a                	jle    80101590 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101556:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010155c:	6a 20                	push   $0x20
8010155e:	56                   	push   %esi
8010155f:	50                   	push   %eax
80101560:	53                   	push   %ebx
80101561:	e8 8a 0e 00 00       	call   801023f0 <readi>
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	83 f8 20             	cmp    $0x20,%eax
8010156c:	0f 84 5e ff ff ff    	je     801014d0 <exec+0xc0>
    freevm(pgdir);
80101572:	83 ec 0c             	sub    $0xc,%esp
80101575:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010157b:	e8 60 62 00 00       	call   801077e0 <freevm>
  if(ip){
80101580:	83 c4 10             	add    $0x10,%esp
80101583:	e9 e2 fe ff ff       	jmp    8010146a <exec+0x5a>
80101588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010158f:	90                   	nop
80101590:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101596:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010159c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801015a2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801015a8:	83 ec 0c             	sub    $0xc,%esp
801015ab:	53                   	push   %ebx
801015ac:	e8 df 0d 00 00       	call   80102390 <iunlockput>
  end_op();
801015b1:	e8 7a 21 00 00       	call   80103730 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801015b6:	83 c4 0c             	add    $0xc,%esp
801015b9:	56                   	push   %esi
801015ba:	57                   	push   %edi
801015bb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801015c1:	57                   	push   %edi
801015c2:	e8 b9 60 00 00       	call   80107680 <allocuvm>
801015c7:	83 c4 10             	add    $0x10,%esp
801015ca:	89 c6                	mov    %eax,%esi
801015cc:	85 c0                	test   %eax,%eax
801015ce:	0f 84 94 00 00 00    	je     80101668 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801015d4:	83 ec 08             	sub    $0x8,%esp
801015d7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801015dd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801015df:	50                   	push   %eax
801015e0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801015e1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801015e3:	e8 18 63 00 00       	call   80107900 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801015f4:	8b 00                	mov    (%eax),%eax
801015f6:	85 c0                	test   %eax,%eax
801015f8:	0f 84 8b 00 00 00    	je     80101689 <exec+0x279>
801015fe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101604:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010160a:	eb 23                	jmp    8010162f <exec+0x21f>
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101610:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101613:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010161a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010161d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101623:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101626:	85 c0                	test   %eax,%eax
80101628:	74 59                	je     80101683 <exec+0x273>
    if(argc >= MAXARG)
8010162a:	83 ff 20             	cmp    $0x20,%edi
8010162d:	74 39                	je     80101668 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010162f:	83 ec 0c             	sub    $0xc,%esp
80101632:	50                   	push   %eax
80101633:	e8 c8 3b 00 00       	call   80105200 <strlen>
80101638:	f7 d0                	not    %eax
8010163a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010163c:	58                   	pop    %eax
8010163d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101640:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101643:	ff 34 b8             	pushl  (%eax,%edi,4)
80101646:	e8 b5 3b 00 00       	call   80105200 <strlen>
8010164b:	83 c0 01             	add    $0x1,%eax
8010164e:	50                   	push   %eax
8010164f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101652:	ff 34 b8             	pushl  (%eax,%edi,4)
80101655:	53                   	push   %ebx
80101656:	56                   	push   %esi
80101657:	e8 04 64 00 00       	call   80107a60 <copyout>
8010165c:	83 c4 20             	add    $0x20,%esp
8010165f:	85 c0                	test   %eax,%eax
80101661:	79 ad                	jns    80101610 <exec+0x200>
80101663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101667:	90                   	nop
    freevm(pgdir);
80101668:	83 ec 0c             	sub    $0xc,%esp
8010166b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101671:	e8 6a 61 00 00       	call   801077e0 <freevm>
80101676:	83 c4 10             	add    $0x10,%esp
  return -1;
80101679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010167e:	e9 fd fd ff ff       	jmp    80101480 <exec+0x70>
80101683:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101689:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101690:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101692:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101699:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010169d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010169f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801016a2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801016a8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801016aa:	50                   	push   %eax
801016ab:	52                   	push   %edx
801016ac:	53                   	push   %ebx
801016ad:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801016b3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801016ba:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801016bd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801016c3:	e8 98 63 00 00       	call   80107a60 <copyout>
801016c8:	83 c4 10             	add    $0x10,%esp
801016cb:	85 c0                	test   %eax,%eax
801016cd:	78 99                	js     80101668 <exec+0x258>
  for(last=s=path; *s; s++)
801016cf:	8b 45 08             	mov    0x8(%ebp),%eax
801016d2:	8b 55 08             	mov    0x8(%ebp),%edx
801016d5:	0f b6 00             	movzbl (%eax),%eax
801016d8:	84 c0                	test   %al,%al
801016da:	74 13                	je     801016ef <exec+0x2df>
801016dc:	89 d1                	mov    %edx,%ecx
801016de:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801016e0:	83 c1 01             	add    $0x1,%ecx
801016e3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801016e5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801016e8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801016eb:	84 c0                	test   %al,%al
801016ed:	75 f1                	jne    801016e0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801016ef:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801016f5:	83 ec 04             	sub    $0x4,%esp
801016f8:	6a 10                	push   $0x10
801016fa:	89 f8                	mov    %edi,%eax
801016fc:	52                   	push   %edx
801016fd:	83 c0 6c             	add    $0x6c,%eax
80101700:	50                   	push   %eax
80101701:	e8 ba 3a 00 00       	call   801051c0 <safestrcpy>
  curproc->pgdir = pgdir;
80101706:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010170c:	89 f8                	mov    %edi,%eax
8010170e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101711:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101713:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101716:	89 c1                	mov    %eax,%ecx
80101718:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010171e:	8b 40 18             	mov    0x18(%eax),%eax
80101721:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101724:	8b 41 18             	mov    0x18(%ecx),%eax
80101727:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010172a:	89 0c 24             	mov    %ecx,(%esp)
8010172d:	e8 ee 5c 00 00       	call   80107420 <switchuvm>
  freevm(oldpgdir);
80101732:	89 3c 24             	mov    %edi,(%esp)
80101735:	e8 a6 60 00 00       	call   801077e0 <freevm>
  return 0;
8010173a:	83 c4 10             	add    $0x10,%esp
8010173d:	31 c0                	xor    %eax,%eax
8010173f:	e9 3c fd ff ff       	jmp    80101480 <exec+0x70>
    end_op();
80101744:	e8 e7 1f 00 00       	call   80103730 <end_op>
    cprintf("exec: fail\n");
80101749:	83 ec 0c             	sub    $0xc,%esp
8010174c:	68 b9 7b 10 80       	push   $0x80107bb9
80101751:	e8 9a ef ff ff       	call   801006f0 <cprintf>
    return -1;
80101756:	83 c4 10             	add    $0x10,%esp
80101759:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010175e:	e9 1d fd ff ff       	jmp    80101480 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101763:	31 ff                	xor    %edi,%edi
80101765:	be 00 20 00 00       	mov    $0x2000,%esi
8010176a:	e9 39 fe ff ff       	jmp    801015a8 <exec+0x198>
8010176f:	90                   	nop

80101770 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010177a:	68 c5 7b 10 80       	push   $0x80107bc5
8010177f:	68 c0 19 11 80       	push   $0x801119c0
80101784:	e8 e7 35 00 00       	call   80104d70 <initlock>
}
80101789:	83 c4 10             	add    $0x10,%esp
8010178c:	c9                   	leave  
8010178d:	c3                   	ret    
8010178e:	66 90                	xchg   %ax,%ax

80101790 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101790:	f3 0f 1e fb          	endbr32 
80101794:	55                   	push   %ebp
80101795:	89 e5                	mov    %esp,%ebp
80101797:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101798:	bb f4 19 11 80       	mov    $0x801119f4,%ebx
{
8010179d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801017a0:	68 c0 19 11 80       	push   $0x801119c0
801017a5:	e8 46 37 00 00       	call   80104ef0 <acquire>
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	eb 0c                	jmp    801017bb <filealloc+0x2b>
801017af:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801017b0:	83 c3 18             	add    $0x18,%ebx
801017b3:	81 fb 54 23 11 80    	cmp    $0x80112354,%ebx
801017b9:	74 25                	je     801017e0 <filealloc+0x50>
    if(f->ref == 0){
801017bb:	8b 43 04             	mov    0x4(%ebx),%eax
801017be:	85 c0                	test   %eax,%eax
801017c0:	75 ee                	jne    801017b0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801017c2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801017c5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801017cc:	68 c0 19 11 80       	push   $0x801119c0
801017d1:	e8 da 37 00 00       	call   80104fb0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801017d6:	89 d8                	mov    %ebx,%eax
      return f;
801017d8:	83 c4 10             	add    $0x10,%esp
}
801017db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017de:	c9                   	leave  
801017df:	c3                   	ret    
  release(&ftable.lock);
801017e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801017e3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801017e5:	68 c0 19 11 80       	push   $0x801119c0
801017ea:	e8 c1 37 00 00       	call   80104fb0 <release>
}
801017ef:	89 d8                	mov    %ebx,%eax
  return 0;
801017f1:	83 c4 10             	add    $0x10,%esp
}
801017f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017f7:	c9                   	leave  
801017f8:	c3                   	ret    
801017f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101800 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101800:	f3 0f 1e fb          	endbr32 
80101804:	55                   	push   %ebp
80101805:	89 e5                	mov    %esp,%ebp
80101807:	53                   	push   %ebx
80101808:	83 ec 10             	sub    $0x10,%esp
8010180b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010180e:	68 c0 19 11 80       	push   $0x801119c0
80101813:	e8 d8 36 00 00       	call   80104ef0 <acquire>
  if(f->ref < 1)
80101818:	8b 43 04             	mov    0x4(%ebx),%eax
8010181b:	83 c4 10             	add    $0x10,%esp
8010181e:	85 c0                	test   %eax,%eax
80101820:	7e 1a                	jle    8010183c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101822:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101825:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101828:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010182b:	68 c0 19 11 80       	push   $0x801119c0
80101830:	e8 7b 37 00 00       	call   80104fb0 <release>
  return f;
}
80101835:	89 d8                	mov    %ebx,%eax
80101837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010183a:	c9                   	leave  
8010183b:	c3                   	ret    
    panic("filedup");
8010183c:	83 ec 0c             	sub    $0xc,%esp
8010183f:	68 cc 7b 10 80       	push   $0x80107bcc
80101844:	e8 47 eb ff ff       	call   80100390 <panic>
80101849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101850 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	57                   	push   %edi
80101858:	56                   	push   %esi
80101859:	53                   	push   %ebx
8010185a:	83 ec 28             	sub    $0x28,%esp
8010185d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101860:	68 c0 19 11 80       	push   $0x801119c0
80101865:	e8 86 36 00 00       	call   80104ef0 <acquire>
  if(f->ref < 1)
8010186a:	8b 53 04             	mov    0x4(%ebx),%edx
8010186d:	83 c4 10             	add    $0x10,%esp
80101870:	85 d2                	test   %edx,%edx
80101872:	0f 8e a1 00 00 00    	jle    80101919 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101878:	83 ea 01             	sub    $0x1,%edx
8010187b:	89 53 04             	mov    %edx,0x4(%ebx)
8010187e:	75 40                	jne    801018c0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101880:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101884:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101887:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101889:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010188f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101892:	88 45 e7             	mov    %al,-0x19(%ebp)
80101895:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101898:	68 c0 19 11 80       	push   $0x801119c0
  ff = *f;
8010189d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801018a0:	e8 0b 37 00 00       	call   80104fb0 <release>

  if(ff.type == FD_PIPE)
801018a5:	83 c4 10             	add    $0x10,%esp
801018a8:	83 ff 01             	cmp    $0x1,%edi
801018ab:	74 53                	je     80101900 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801018ad:	83 ff 02             	cmp    $0x2,%edi
801018b0:	74 26                	je     801018d8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801018b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b5:	5b                   	pop    %ebx
801018b6:	5e                   	pop    %esi
801018b7:	5f                   	pop    %edi
801018b8:	5d                   	pop    %ebp
801018b9:	c3                   	ret    
801018ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801018c0:	c7 45 08 c0 19 11 80 	movl   $0x801119c0,0x8(%ebp)
}
801018c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ca:	5b                   	pop    %ebx
801018cb:	5e                   	pop    %esi
801018cc:	5f                   	pop    %edi
801018cd:	5d                   	pop    %ebp
    release(&ftable.lock);
801018ce:	e9 dd 36 00 00       	jmp    80104fb0 <release>
801018d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018d7:	90                   	nop
    begin_op();
801018d8:	e8 e3 1d 00 00       	call   801036c0 <begin_op>
    iput(ff.ip);
801018dd:	83 ec 0c             	sub    $0xc,%esp
801018e0:	ff 75 e0             	pushl  -0x20(%ebp)
801018e3:	e8 38 09 00 00       	call   80102220 <iput>
    end_op();
801018e8:	83 c4 10             	add    $0x10,%esp
}
801018eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ee:	5b                   	pop    %ebx
801018ef:	5e                   	pop    %esi
801018f0:	5f                   	pop    %edi
801018f1:	5d                   	pop    %ebp
    end_op();
801018f2:	e9 39 1e 00 00       	jmp    80103730 <end_op>
801018f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018fe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101900:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101904:	83 ec 08             	sub    $0x8,%esp
80101907:	53                   	push   %ebx
80101908:	56                   	push   %esi
80101909:	e8 82 25 00 00       	call   80103e90 <pipeclose>
8010190e:	83 c4 10             	add    $0x10,%esp
}
80101911:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101914:	5b                   	pop    %ebx
80101915:	5e                   	pop    %esi
80101916:	5f                   	pop    %edi
80101917:	5d                   	pop    %ebp
80101918:	c3                   	ret    
    panic("fileclose");
80101919:	83 ec 0c             	sub    $0xc,%esp
8010191c:	68 d4 7b 10 80       	push   $0x80107bd4
80101921:	e8 6a ea ff ff       	call   80100390 <panic>
80101926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010192d:	8d 76 00             	lea    0x0(%esi),%esi

80101930 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101930:	f3 0f 1e fb          	endbr32 
80101934:	55                   	push   %ebp
80101935:	89 e5                	mov    %esp,%ebp
80101937:	53                   	push   %ebx
80101938:	83 ec 04             	sub    $0x4,%esp
8010193b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010193e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101941:	75 2d                	jne    80101970 <filestat+0x40>
    ilock(f->ip);
80101943:	83 ec 0c             	sub    $0xc,%esp
80101946:	ff 73 10             	pushl  0x10(%ebx)
80101949:	e8 a2 07 00 00       	call   801020f0 <ilock>
    stati(f->ip, st);
8010194e:	58                   	pop    %eax
8010194f:	5a                   	pop    %edx
80101950:	ff 75 0c             	pushl  0xc(%ebp)
80101953:	ff 73 10             	pushl  0x10(%ebx)
80101956:	e8 65 0a 00 00       	call   801023c0 <stati>
    iunlock(f->ip);
8010195b:	59                   	pop    %ecx
8010195c:	ff 73 10             	pushl  0x10(%ebx)
8010195f:	e8 6c 08 00 00       	call   801021d0 <iunlock>
    return 0;
  }
  return -1;
}
80101964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101967:	83 c4 10             	add    $0x10,%esp
8010196a:	31 c0                	xor    %eax,%eax
}
8010196c:	c9                   	leave  
8010196d:	c3                   	ret    
8010196e:	66 90                	xchg   %ax,%ax
80101970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101978:	c9                   	leave  
80101979:	c3                   	ret    
8010197a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101980 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101980:	f3 0f 1e fb          	endbr32 
80101984:	55                   	push   %ebp
80101985:	89 e5                	mov    %esp,%ebp
80101987:	57                   	push   %edi
80101988:	56                   	push   %esi
80101989:	53                   	push   %ebx
8010198a:	83 ec 0c             	sub    $0xc,%esp
8010198d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101990:	8b 75 0c             	mov    0xc(%ebp),%esi
80101993:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101996:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010199a:	74 64                	je     80101a00 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010199c:	8b 03                	mov    (%ebx),%eax
8010199e:	83 f8 01             	cmp    $0x1,%eax
801019a1:	74 45                	je     801019e8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801019a3:	83 f8 02             	cmp    $0x2,%eax
801019a6:	75 5f                	jne    80101a07 <fileread+0x87>
    ilock(f->ip);
801019a8:	83 ec 0c             	sub    $0xc,%esp
801019ab:	ff 73 10             	pushl  0x10(%ebx)
801019ae:	e8 3d 07 00 00       	call   801020f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801019b3:	57                   	push   %edi
801019b4:	ff 73 14             	pushl  0x14(%ebx)
801019b7:	56                   	push   %esi
801019b8:	ff 73 10             	pushl  0x10(%ebx)
801019bb:	e8 30 0a 00 00       	call   801023f0 <readi>
801019c0:	83 c4 20             	add    $0x20,%esp
801019c3:	89 c6                	mov    %eax,%esi
801019c5:	85 c0                	test   %eax,%eax
801019c7:	7e 03                	jle    801019cc <fileread+0x4c>
      f->off += r;
801019c9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801019cc:	83 ec 0c             	sub    $0xc,%esp
801019cf:	ff 73 10             	pushl  0x10(%ebx)
801019d2:	e8 f9 07 00 00       	call   801021d0 <iunlock>
    return r;
801019d7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801019da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019dd:	89 f0                	mov    %esi,%eax
801019df:	5b                   	pop    %ebx
801019e0:	5e                   	pop    %esi
801019e1:	5f                   	pop    %edi
801019e2:	5d                   	pop    %ebp
801019e3:	c3                   	ret    
801019e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801019e8:	8b 43 0c             	mov    0xc(%ebx),%eax
801019eb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801019ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019f1:	5b                   	pop    %ebx
801019f2:	5e                   	pop    %esi
801019f3:	5f                   	pop    %edi
801019f4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801019f5:	e9 36 26 00 00       	jmp    80104030 <piperead>
801019fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101a00:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101a05:	eb d3                	jmp    801019da <fileread+0x5a>
  panic("fileread");
80101a07:	83 ec 0c             	sub    $0xc,%esp
80101a0a:	68 de 7b 10 80       	push   $0x80107bde
80101a0f:	e8 7c e9 ff ff       	call   80100390 <panic>
80101a14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a1f:	90                   	nop

80101a20 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101a20:	f3 0f 1e fb          	endbr32 
80101a24:	55                   	push   %ebp
80101a25:	89 e5                	mov    %esp,%ebp
80101a27:	57                   	push   %edi
80101a28:	56                   	push   %esi
80101a29:	53                   	push   %ebx
80101a2a:	83 ec 1c             	sub    $0x1c,%esp
80101a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a30:	8b 75 08             	mov    0x8(%ebp),%esi
80101a33:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101a36:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101a39:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101a3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101a40:	0f 84 c1 00 00 00    	je     80101b07 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101a46:	8b 06                	mov    (%esi),%eax
80101a48:	83 f8 01             	cmp    $0x1,%eax
80101a4b:	0f 84 c3 00 00 00    	je     80101b14 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101a51:	83 f8 02             	cmp    $0x2,%eax
80101a54:	0f 85 cc 00 00 00    	jne    80101b26 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101a5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101a5d:	31 ff                	xor    %edi,%edi
    while(i < n){
80101a5f:	85 c0                	test   %eax,%eax
80101a61:	7f 34                	jg     80101a97 <filewrite+0x77>
80101a63:	e9 98 00 00 00       	jmp    80101b00 <filewrite+0xe0>
80101a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101a70:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101a73:	83 ec 0c             	sub    $0xc,%esp
80101a76:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101a79:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101a7c:	e8 4f 07 00 00       	call   801021d0 <iunlock>
      end_op();
80101a81:	e8 aa 1c 00 00       	call   80103730 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a89:	83 c4 10             	add    $0x10,%esp
80101a8c:	39 c3                	cmp    %eax,%ebx
80101a8e:	75 60                	jne    80101af0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101a90:	01 df                	add    %ebx,%edi
    while(i < n){
80101a92:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a95:	7e 69                	jle    80101b00 <filewrite+0xe0>
      int n1 = n - i;
80101a97:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9a:	b8 00 06 00 00       	mov    $0x600,%eax
80101a9f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101aa1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101aa7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101aaa:	e8 11 1c 00 00       	call   801036c0 <begin_op>
      ilock(f->ip);
80101aaf:	83 ec 0c             	sub    $0xc,%esp
80101ab2:	ff 76 10             	pushl  0x10(%esi)
80101ab5:	e8 36 06 00 00       	call   801020f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101aba:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101abd:	53                   	push   %ebx
80101abe:	ff 76 14             	pushl  0x14(%esi)
80101ac1:	01 f8                	add    %edi,%eax
80101ac3:	50                   	push   %eax
80101ac4:	ff 76 10             	pushl  0x10(%esi)
80101ac7:	e8 24 0a 00 00       	call   801024f0 <writei>
80101acc:	83 c4 20             	add    $0x20,%esp
80101acf:	85 c0                	test   %eax,%eax
80101ad1:	7f 9d                	jg     80101a70 <filewrite+0x50>
      iunlock(f->ip);
80101ad3:	83 ec 0c             	sub    $0xc,%esp
80101ad6:	ff 76 10             	pushl  0x10(%esi)
80101ad9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101adc:	e8 ef 06 00 00       	call   801021d0 <iunlock>
      end_op();
80101ae1:	e8 4a 1c 00 00       	call   80103730 <end_op>
      if(r < 0)
80101ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ae9:	83 c4 10             	add    $0x10,%esp
80101aec:	85 c0                	test   %eax,%eax
80101aee:	75 17                	jne    80101b07 <filewrite+0xe7>
        panic("short filewrite");
80101af0:	83 ec 0c             	sub    $0xc,%esp
80101af3:	68 e7 7b 10 80       	push   $0x80107be7
80101af8:	e8 93 e8 ff ff       	call   80100390 <panic>
80101afd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101b00:	89 f8                	mov    %edi,%eax
80101b02:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101b05:	74 05                	je     80101b0c <filewrite+0xec>
80101b07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0f:	5b                   	pop    %ebx
80101b10:	5e                   	pop    %esi
80101b11:	5f                   	pop    %edi
80101b12:	5d                   	pop    %ebp
80101b13:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101b14:	8b 46 0c             	mov    0xc(%esi),%eax
80101b17:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b1d:	5b                   	pop    %ebx
80101b1e:	5e                   	pop    %esi
80101b1f:	5f                   	pop    %edi
80101b20:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101b21:	e9 0a 24 00 00       	jmp    80103f30 <pipewrite>
  panic("filewrite");
80101b26:	83 ec 0c             	sub    $0xc,%esp
80101b29:	68 ed 7b 10 80       	push   $0x80107bed
80101b2e:	e8 5d e8 ff ff       	call   80100390 <panic>
80101b33:	66 90                	xchg   %ax,%ax
80101b35:	66 90                	xchg   %ax,%ax
80101b37:	66 90                	xchg   %ax,%ax
80101b39:	66 90                	xchg   %ax,%ax
80101b3b:	66 90                	xchg   %ax,%ax
80101b3d:	66 90                	xchg   %ax,%ax
80101b3f:	90                   	nop

80101b40 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101b40:	55                   	push   %ebp
80101b41:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101b43:	89 d0                	mov    %edx,%eax
80101b45:	c1 e8 0c             	shr    $0xc,%eax
80101b48:	03 05 d8 23 11 80    	add    0x801123d8,%eax
{
80101b4e:	89 e5                	mov    %esp,%ebp
80101b50:	56                   	push   %esi
80101b51:	53                   	push   %ebx
80101b52:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101b54:	83 ec 08             	sub    $0x8,%esp
80101b57:	50                   	push   %eax
80101b58:	51                   	push   %ecx
80101b59:	e8 72 e5 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101b5e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101b60:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101b63:	ba 01 00 00 00       	mov    $0x1,%edx
80101b68:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101b6b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101b71:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101b74:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101b76:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101b7b:	85 d1                	test   %edx,%ecx
80101b7d:	74 25                	je     80101ba4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101b7f:	f7 d2                	not    %edx
  log_write(bp);
80101b81:	83 ec 0c             	sub    $0xc,%esp
80101b84:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101b86:	21 ca                	and    %ecx,%edx
80101b88:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101b8c:	50                   	push   %eax
80101b8d:	e8 0e 1d 00 00       	call   801038a0 <log_write>
  brelse(bp);
80101b92:	89 34 24             	mov    %esi,(%esp)
80101b95:	e8 56 e6 ff ff       	call   801001f0 <brelse>
}
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ba0:	5b                   	pop    %ebx
80101ba1:	5e                   	pop    %esi
80101ba2:	5d                   	pop    %ebp
80101ba3:	c3                   	ret    
    panic("freeing free block");
80101ba4:	83 ec 0c             	sub    $0xc,%esp
80101ba7:	68 f7 7b 10 80       	push   $0x80107bf7
80101bac:	e8 df e7 ff ff       	call   80100390 <panic>
80101bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop

80101bc0 <balloc>:
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101bc9:	8b 0d c0 23 11 80    	mov    0x801123c0,%ecx
{
80101bcf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101bd2:	85 c9                	test   %ecx,%ecx
80101bd4:	0f 84 87 00 00 00    	je     80101c61 <balloc+0xa1>
80101bda:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101be1:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101be4:	83 ec 08             	sub    $0x8,%esp
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	c1 f8 0c             	sar    $0xc,%eax
80101bec:	03 05 d8 23 11 80    	add    0x801123d8,%eax
80101bf2:	50                   	push   %eax
80101bf3:	ff 75 d8             	pushl  -0x28(%ebp)
80101bf6:	e8 d5 e4 ff ff       	call   801000d0 <bread>
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101c01:	a1 c0 23 11 80       	mov    0x801123c0,%eax
80101c06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101c09:	31 c0                	xor    %eax,%eax
80101c0b:	eb 2f                	jmp    80101c3c <balloc+0x7c>
80101c0d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101c10:	89 c1                	mov    %eax,%ecx
80101c12:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101c17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101c1a:	83 e1 07             	and    $0x7,%ecx
80101c1d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101c1f:	89 c1                	mov    %eax,%ecx
80101c21:	c1 f9 03             	sar    $0x3,%ecx
80101c24:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101c29:	89 fa                	mov    %edi,%edx
80101c2b:	85 df                	test   %ebx,%edi
80101c2d:	74 41                	je     80101c70 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101c2f:	83 c0 01             	add    $0x1,%eax
80101c32:	83 c6 01             	add    $0x1,%esi
80101c35:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101c3a:	74 05                	je     80101c41 <balloc+0x81>
80101c3c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101c3f:	77 cf                	ja     80101c10 <balloc+0x50>
    brelse(bp);
80101c41:	83 ec 0c             	sub    $0xc,%esp
80101c44:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c47:	e8 a4 e5 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101c4c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101c53:	83 c4 10             	add    $0x10,%esp
80101c56:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101c59:	39 05 c0 23 11 80    	cmp    %eax,0x801123c0
80101c5f:	77 80                	ja     80101be1 <balloc+0x21>
  panic("balloc: out of blocks");
80101c61:	83 ec 0c             	sub    $0xc,%esp
80101c64:	68 0a 7c 10 80       	push   $0x80107c0a
80101c69:	e8 22 e7 ff ff       	call   80100390 <panic>
80101c6e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101c70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101c73:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101c76:	09 da                	or     %ebx,%edx
80101c78:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101c7c:	57                   	push   %edi
80101c7d:	e8 1e 1c 00 00       	call   801038a0 <log_write>
        brelse(bp);
80101c82:	89 3c 24             	mov    %edi,(%esp)
80101c85:	e8 66 e5 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101c8a:	58                   	pop    %eax
80101c8b:	5a                   	pop    %edx
80101c8c:	56                   	push   %esi
80101c8d:	ff 75 d8             	pushl  -0x28(%ebp)
80101c90:	e8 3b e4 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101c95:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101c98:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101c9a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101c9d:	68 00 02 00 00       	push   $0x200
80101ca2:	6a 00                	push   $0x0
80101ca4:	50                   	push   %eax
80101ca5:	e8 56 33 00 00       	call   80105000 <memset>
  log_write(bp);
80101caa:	89 1c 24             	mov    %ebx,(%esp)
80101cad:	e8 ee 1b 00 00       	call   801038a0 <log_write>
  brelse(bp);
80101cb2:	89 1c 24             	mov    %ebx,(%esp)
80101cb5:	e8 36 e5 ff ff       	call   801001f0 <brelse>
}
80101cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cbd:	89 f0                	mov    %esi,%eax
80101cbf:	5b                   	pop    %ebx
80101cc0:	5e                   	pop    %esi
80101cc1:	5f                   	pop    %edi
80101cc2:	5d                   	pop    %ebp
80101cc3:	c3                   	ret    
80101cc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ccf:	90                   	nop

80101cd0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	89 c7                	mov    %eax,%edi
80101cd6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101cd7:	31 f6                	xor    %esi,%esi
{
80101cd9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101cda:	bb 14 24 11 80       	mov    $0x80112414,%ebx
{
80101cdf:	83 ec 28             	sub    $0x28,%esp
80101ce2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101ce5:	68 e0 23 11 80       	push   $0x801123e0
80101cea:	e8 01 32 00 00       	call   80104ef0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101cef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101cf2:	83 c4 10             	add    $0x10,%esp
80101cf5:	eb 1b                	jmp    80101d12 <iget+0x42>
80101cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfe:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101d00:	39 3b                	cmp    %edi,(%ebx)
80101d02:	74 6c                	je     80101d70 <iget+0xa0>
80101d04:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101d0a:	81 fb 34 40 11 80    	cmp    $0x80114034,%ebx
80101d10:	73 26                	jae    80101d38 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101d12:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101d15:	85 c9                	test   %ecx,%ecx
80101d17:	7f e7                	jg     80101d00 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101d19:	85 f6                	test   %esi,%esi
80101d1b:	75 e7                	jne    80101d04 <iget+0x34>
80101d1d:	89 d8                	mov    %ebx,%eax
80101d1f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101d25:	85 c9                	test   %ecx,%ecx
80101d27:	75 6e                	jne    80101d97 <iget+0xc7>
80101d29:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101d2b:	81 fb 34 40 11 80    	cmp    $0x80114034,%ebx
80101d31:	72 df                	jb     80101d12 <iget+0x42>
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101d38:	85 f6                	test   %esi,%esi
80101d3a:	74 73                	je     80101daf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101d3c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101d3f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101d41:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101d44:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101d4b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101d52:	68 e0 23 11 80       	push   $0x801123e0
80101d57:	e8 54 32 00 00       	call   80104fb0 <release>

  return ip;
80101d5c:	83 c4 10             	add    $0x10,%esp
}
80101d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d62:	89 f0                	mov    %esi,%eax
80101d64:	5b                   	pop    %ebx
80101d65:	5e                   	pop    %esi
80101d66:	5f                   	pop    %edi
80101d67:	5d                   	pop    %ebp
80101d68:	c3                   	ret    
80101d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101d70:	39 53 04             	cmp    %edx,0x4(%ebx)
80101d73:	75 8f                	jne    80101d04 <iget+0x34>
      release(&icache.lock);
80101d75:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101d78:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101d7b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101d7d:	68 e0 23 11 80       	push   $0x801123e0
      ip->ref++;
80101d82:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101d85:	e8 26 32 00 00       	call   80104fb0 <release>
      return ip;
80101d8a:	83 c4 10             	add    $0x10,%esp
}
80101d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d90:	89 f0                	mov    %esi,%eax
80101d92:	5b                   	pop    %ebx
80101d93:	5e                   	pop    %esi
80101d94:	5f                   	pop    %edi
80101d95:	5d                   	pop    %ebp
80101d96:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101d97:	81 fb 34 40 11 80    	cmp    $0x80114034,%ebx
80101d9d:	73 10                	jae    80101daf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101d9f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101da2:	85 c9                	test   %ecx,%ecx
80101da4:	0f 8f 56 ff ff ff    	jg     80101d00 <iget+0x30>
80101daa:	e9 6e ff ff ff       	jmp    80101d1d <iget+0x4d>
    panic("iget: no inodes");
80101daf:	83 ec 0c             	sub    $0xc,%esp
80101db2:	68 20 7c 10 80       	push   $0x80107c20
80101db7:	e8 d4 e5 ff ff       	call   80100390 <panic>
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	89 c6                	mov    %eax,%esi
80101dc7:	53                   	push   %ebx
80101dc8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101dcb:	83 fa 0b             	cmp    $0xb,%edx
80101dce:	0f 86 84 00 00 00    	jbe    80101e58 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101dd4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101dd7:	83 fb 7f             	cmp    $0x7f,%ebx
80101dda:	0f 87 98 00 00 00    	ja     80101e78 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101de0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101de6:	8b 16                	mov    (%esi),%edx
80101de8:	85 c0                	test   %eax,%eax
80101dea:	74 54                	je     80101e40 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101dec:	83 ec 08             	sub    $0x8,%esp
80101def:	50                   	push   %eax
80101df0:	52                   	push   %edx
80101df1:	e8 da e2 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101df6:	83 c4 10             	add    $0x10,%esp
80101df9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101dfd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101dff:	8b 1a                	mov    (%edx),%ebx
80101e01:	85 db                	test   %ebx,%ebx
80101e03:	74 1b                	je     80101e20 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101e05:	83 ec 0c             	sub    $0xc,%esp
80101e08:	57                   	push   %edi
80101e09:	e8 e2 e3 ff ff       	call   801001f0 <brelse>
    return addr;
80101e0e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e14:	89 d8                	mov    %ebx,%eax
80101e16:	5b                   	pop    %ebx
80101e17:	5e                   	pop    %esi
80101e18:	5f                   	pop    %edi
80101e19:	5d                   	pop    %ebp
80101e1a:	c3                   	ret    
80101e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e1f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101e20:	8b 06                	mov    (%esi),%eax
80101e22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e25:	e8 96 fd ff ff       	call   80101bc0 <balloc>
80101e2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101e2d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101e30:	89 c3                	mov    %eax,%ebx
80101e32:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101e34:	57                   	push   %edi
80101e35:	e8 66 1a 00 00       	call   801038a0 <log_write>
80101e3a:	83 c4 10             	add    $0x10,%esp
80101e3d:	eb c6                	jmp    80101e05 <bmap+0x45>
80101e3f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e40:	89 d0                	mov    %edx,%eax
80101e42:	e8 79 fd ff ff       	call   80101bc0 <balloc>
80101e47:	8b 16                	mov    (%esi),%edx
80101e49:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101e4f:	eb 9b                	jmp    80101dec <bmap+0x2c>
80101e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101e58:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101e5b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101e5e:	85 db                	test   %ebx,%ebx
80101e60:	75 af                	jne    80101e11 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e62:	8b 00                	mov    (%eax),%eax
80101e64:	e8 57 fd ff ff       	call   80101bc0 <balloc>
80101e69:	89 47 5c             	mov    %eax,0x5c(%edi)
80101e6c:	89 c3                	mov    %eax,%ebx
}
80101e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e71:	89 d8                	mov    %ebx,%eax
80101e73:	5b                   	pop    %ebx
80101e74:	5e                   	pop    %esi
80101e75:	5f                   	pop    %edi
80101e76:	5d                   	pop    %ebp
80101e77:	c3                   	ret    
  panic("bmap: out of range");
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	68 30 7c 10 80       	push   $0x80107c30
80101e80:	e8 0b e5 ff ff       	call   80100390 <panic>
80101e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e90 <readsb>:
{
80101e90:	f3 0f 1e fb          	endbr32 
80101e94:	55                   	push   %ebp
80101e95:	89 e5                	mov    %esp,%ebp
80101e97:	56                   	push   %esi
80101e98:	53                   	push   %ebx
80101e99:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101e9c:	83 ec 08             	sub    $0x8,%esp
80101e9f:	6a 01                	push   $0x1
80101ea1:	ff 75 08             	pushl  0x8(%ebp)
80101ea4:	e8 27 e2 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101ea9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101eac:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101eae:	8d 40 5c             	lea    0x5c(%eax),%eax
80101eb1:	6a 1c                	push   $0x1c
80101eb3:	50                   	push   %eax
80101eb4:	56                   	push   %esi
80101eb5:	e8 e6 31 00 00       	call   801050a0 <memmove>
  brelse(bp);
80101eba:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ebd:	83 c4 10             	add    $0x10,%esp
}
80101ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ec3:	5b                   	pop    %ebx
80101ec4:	5e                   	pop    %esi
80101ec5:	5d                   	pop    %ebp
  brelse(bp);
80101ec6:	e9 25 e3 ff ff       	jmp    801001f0 <brelse>
80101ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ecf:	90                   	nop

80101ed0 <iinit>:
{
80101ed0:	f3 0f 1e fb          	endbr32 
80101ed4:	55                   	push   %ebp
80101ed5:	89 e5                	mov    %esp,%ebp
80101ed7:	53                   	push   %ebx
80101ed8:	bb 20 24 11 80       	mov    $0x80112420,%ebx
80101edd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101ee0:	68 43 7c 10 80       	push   $0x80107c43
80101ee5:	68 e0 23 11 80       	push   $0x801123e0
80101eea:	e8 81 2e 00 00       	call   80104d70 <initlock>
  for(i = 0; i < NINODE; i++) {
80101eef:	83 c4 10             	add    $0x10,%esp
80101ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101ef8:	83 ec 08             	sub    $0x8,%esp
80101efb:	68 4a 7c 10 80       	push   $0x80107c4a
80101f00:	53                   	push   %ebx
80101f01:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101f07:	e8 24 2d 00 00       	call   80104c30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101f0c:	83 c4 10             	add    $0x10,%esp
80101f0f:	81 fb 40 40 11 80    	cmp    $0x80114040,%ebx
80101f15:	75 e1                	jne    80101ef8 <iinit+0x28>
  readsb(dev, &sb);
80101f17:	83 ec 08             	sub    $0x8,%esp
80101f1a:	68 c0 23 11 80       	push   $0x801123c0
80101f1f:	ff 75 08             	pushl  0x8(%ebp)
80101f22:	e8 69 ff ff ff       	call   80101e90 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101f27:	ff 35 d8 23 11 80    	pushl  0x801123d8
80101f2d:	ff 35 d4 23 11 80    	pushl  0x801123d4
80101f33:	ff 35 d0 23 11 80    	pushl  0x801123d0
80101f39:	ff 35 cc 23 11 80    	pushl  0x801123cc
80101f3f:	ff 35 c8 23 11 80    	pushl  0x801123c8
80101f45:	ff 35 c4 23 11 80    	pushl  0x801123c4
80101f4b:	ff 35 c0 23 11 80    	pushl  0x801123c0
80101f51:	68 b0 7c 10 80       	push   $0x80107cb0
80101f56:	e8 95 e7 ff ff       	call   801006f0 <cprintf>
}
80101f5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f5e:	83 c4 30             	add    $0x30,%esp
80101f61:	c9                   	leave  
80101f62:	c3                   	ret    
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <ialloc>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 1c             	sub    $0x1c,%esp
80101f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101f80:	83 3d c8 23 11 80 01 	cmpl   $0x1,0x801123c8
{
80101f87:	8b 75 08             	mov    0x8(%ebp),%esi
80101f8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101f8d:	0f 86 8d 00 00 00    	jbe    80102020 <ialloc+0xb0>
80101f93:	bf 01 00 00 00       	mov    $0x1,%edi
80101f98:	eb 1d                	jmp    80101fb7 <ialloc+0x47>
80101f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101fa0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101fa3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101fa6:	53                   	push   %ebx
80101fa7:	e8 44 e2 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101fac:	83 c4 10             	add    $0x10,%esp
80101faf:	3b 3d c8 23 11 80    	cmp    0x801123c8,%edi
80101fb5:	73 69                	jae    80102020 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101fb7:	89 f8                	mov    %edi,%eax
80101fb9:	83 ec 08             	sub    $0x8,%esp
80101fbc:	c1 e8 03             	shr    $0x3,%eax
80101fbf:	03 05 d4 23 11 80    	add    0x801123d4,%eax
80101fc5:	50                   	push   %eax
80101fc6:	56                   	push   %esi
80101fc7:	e8 04 e1 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101fcc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101fcf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101fd1:	89 f8                	mov    %edi,%eax
80101fd3:	83 e0 07             	and    $0x7,%eax
80101fd6:	c1 e0 06             	shl    $0x6,%eax
80101fd9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101fdd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101fe1:	75 bd                	jne    80101fa0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101fe3:	83 ec 04             	sub    $0x4,%esp
80101fe6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fe9:	6a 40                	push   $0x40
80101feb:	6a 00                	push   $0x0
80101fed:	51                   	push   %ecx
80101fee:	e8 0d 30 00 00       	call   80105000 <memset>
      dip->type = type;
80101ff3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101ff7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ffa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101ffd:	89 1c 24             	mov    %ebx,(%esp)
80102000:	e8 9b 18 00 00       	call   801038a0 <log_write>
      brelse(bp);
80102005:	89 1c 24             	mov    %ebx,(%esp)
80102008:	e8 e3 e1 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010200d:	83 c4 10             	add    $0x10,%esp
}
80102010:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102013:	89 fa                	mov    %edi,%edx
}
80102015:	5b                   	pop    %ebx
      return iget(dev, inum);
80102016:	89 f0                	mov    %esi,%eax
}
80102018:	5e                   	pop    %esi
80102019:	5f                   	pop    %edi
8010201a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010201b:	e9 b0 fc ff ff       	jmp    80101cd0 <iget>
  panic("ialloc: no inodes");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 50 7c 10 80       	push   $0x80107c50
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
8010202d:	8d 76 00             	lea    0x0(%esi),%esi

80102030 <iupdate>:
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
80102035:	89 e5                	mov    %esp,%ebp
80102037:	56                   	push   %esi
80102038:	53                   	push   %ebx
80102039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010203c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010203f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102042:	83 ec 08             	sub    $0x8,%esp
80102045:	c1 e8 03             	shr    $0x3,%eax
80102048:	03 05 d4 23 11 80    	add    0x801123d4,%eax
8010204e:	50                   	push   %eax
8010204f:	ff 73 a4             	pushl  -0x5c(%ebx)
80102052:	e8 79 e0 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102057:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010205b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010205e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80102060:	8b 43 a8             	mov    -0x58(%ebx),%eax
80102063:	83 e0 07             	and    $0x7,%eax
80102066:	c1 e0 06             	shl    $0x6,%eax
80102069:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010206d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80102070:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102074:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102077:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010207b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010207f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80102083:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102087:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010208b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010208e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102091:	6a 34                	push   $0x34
80102093:	53                   	push   %ebx
80102094:	50                   	push   %eax
80102095:	e8 06 30 00 00       	call   801050a0 <memmove>
  log_write(bp);
8010209a:	89 34 24             	mov    %esi,(%esp)
8010209d:	e8 fe 17 00 00       	call   801038a0 <log_write>
  brelse(bp);
801020a2:	89 75 08             	mov    %esi,0x8(%ebp)
801020a5:	83 c4 10             	add    $0x10,%esp
}
801020a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020ab:	5b                   	pop    %ebx
801020ac:	5e                   	pop    %esi
801020ad:	5d                   	pop    %ebp
  brelse(bp);
801020ae:	e9 3d e1 ff ff       	jmp    801001f0 <brelse>
801020b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020c0 <idup>:
{
801020c0:	f3 0f 1e fb          	endbr32 
801020c4:	55                   	push   %ebp
801020c5:	89 e5                	mov    %esp,%ebp
801020c7:	53                   	push   %ebx
801020c8:	83 ec 10             	sub    $0x10,%esp
801020cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801020ce:	68 e0 23 11 80       	push   $0x801123e0
801020d3:	e8 18 2e 00 00       	call   80104ef0 <acquire>
  ip->ref++;
801020d8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801020dc:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
801020e3:	e8 c8 2e 00 00       	call   80104fb0 <release>
}
801020e8:	89 d8                	mov    %ebx,%eax
801020ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020ed:	c9                   	leave  
801020ee:	c3                   	ret    
801020ef:	90                   	nop

801020f0 <ilock>:
{
801020f0:	f3 0f 1e fb          	endbr32 
801020f4:	55                   	push   %ebp
801020f5:	89 e5                	mov    %esp,%ebp
801020f7:	56                   	push   %esi
801020f8:	53                   	push   %ebx
801020f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801020fc:	85 db                	test   %ebx,%ebx
801020fe:	0f 84 b3 00 00 00    	je     801021b7 <ilock+0xc7>
80102104:	8b 53 08             	mov    0x8(%ebx),%edx
80102107:	85 d2                	test   %edx,%edx
80102109:	0f 8e a8 00 00 00    	jle    801021b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010210f:	83 ec 0c             	sub    $0xc,%esp
80102112:	8d 43 0c             	lea    0xc(%ebx),%eax
80102115:	50                   	push   %eax
80102116:	e8 55 2b 00 00       	call   80104c70 <acquiresleep>
  if(ip->valid == 0){
8010211b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010211e:	83 c4 10             	add    $0x10,%esp
80102121:	85 c0                	test   %eax,%eax
80102123:	74 0b                	je     80102130 <ilock+0x40>
}
80102125:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102128:	5b                   	pop    %ebx
80102129:	5e                   	pop    %esi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102130:	8b 43 04             	mov    0x4(%ebx),%eax
80102133:	83 ec 08             	sub    $0x8,%esp
80102136:	c1 e8 03             	shr    $0x3,%eax
80102139:	03 05 d4 23 11 80    	add    0x801123d4,%eax
8010213f:	50                   	push   %eax
80102140:	ff 33                	pushl  (%ebx)
80102142:	e8 89 df ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102147:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010214a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010214c:	8b 43 04             	mov    0x4(%ebx),%eax
8010214f:	83 e0 07             	and    $0x7,%eax
80102152:	c1 e0 06             	shl    $0x6,%eax
80102155:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102159:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010215c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010215f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102163:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102167:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010216b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010216f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102173:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102177:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010217b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010217e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102181:	6a 34                	push   $0x34
80102183:	50                   	push   %eax
80102184:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102187:	50                   	push   %eax
80102188:	e8 13 2f 00 00       	call   801050a0 <memmove>
    brelse(bp);
8010218d:	89 34 24             	mov    %esi,(%esp)
80102190:	e8 5b e0 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102195:	83 c4 10             	add    $0x10,%esp
80102198:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010219d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801021a4:	0f 85 7b ff ff ff    	jne    80102125 <ilock+0x35>
      panic("ilock: no type");
801021aa:	83 ec 0c             	sub    $0xc,%esp
801021ad:	68 68 7c 10 80       	push   $0x80107c68
801021b2:	e8 d9 e1 ff ff       	call   80100390 <panic>
    panic("ilock");
801021b7:	83 ec 0c             	sub    $0xc,%esp
801021ba:	68 62 7c 10 80       	push   $0x80107c62
801021bf:	e8 cc e1 ff ff       	call   80100390 <panic>
801021c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021cf:	90                   	nop

801021d0 <iunlock>:
{
801021d0:	f3 0f 1e fb          	endbr32 
801021d4:	55                   	push   %ebp
801021d5:	89 e5                	mov    %esp,%ebp
801021d7:	56                   	push   %esi
801021d8:	53                   	push   %ebx
801021d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801021dc:	85 db                	test   %ebx,%ebx
801021de:	74 28                	je     80102208 <iunlock+0x38>
801021e0:	83 ec 0c             	sub    $0xc,%esp
801021e3:	8d 73 0c             	lea    0xc(%ebx),%esi
801021e6:	56                   	push   %esi
801021e7:	e8 24 2b 00 00       	call   80104d10 <holdingsleep>
801021ec:	83 c4 10             	add    $0x10,%esp
801021ef:	85 c0                	test   %eax,%eax
801021f1:	74 15                	je     80102208 <iunlock+0x38>
801021f3:	8b 43 08             	mov    0x8(%ebx),%eax
801021f6:	85 c0                	test   %eax,%eax
801021f8:	7e 0e                	jle    80102208 <iunlock+0x38>
  releasesleep(&ip->lock);
801021fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801021fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102200:	5b                   	pop    %ebx
80102201:	5e                   	pop    %esi
80102202:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102203:	e9 c8 2a 00 00       	jmp    80104cd0 <releasesleep>
    panic("iunlock");
80102208:	83 ec 0c             	sub    $0xc,%esp
8010220b:	68 77 7c 10 80       	push   $0x80107c77
80102210:	e8 7b e1 ff ff       	call   80100390 <panic>
80102215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102220 <iput>:
{
80102220:	f3 0f 1e fb          	endbr32 
80102224:	55                   	push   %ebp
80102225:	89 e5                	mov    %esp,%ebp
80102227:	57                   	push   %edi
80102228:	56                   	push   %esi
80102229:	53                   	push   %ebx
8010222a:	83 ec 28             	sub    $0x28,%esp
8010222d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102230:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102233:	57                   	push   %edi
80102234:	e8 37 2a 00 00       	call   80104c70 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102239:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010223c:	83 c4 10             	add    $0x10,%esp
8010223f:	85 d2                	test   %edx,%edx
80102241:	74 07                	je     8010224a <iput+0x2a>
80102243:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102248:	74 36                	je     80102280 <iput+0x60>
  releasesleep(&ip->lock);
8010224a:	83 ec 0c             	sub    $0xc,%esp
8010224d:	57                   	push   %edi
8010224e:	e8 7d 2a 00 00       	call   80104cd0 <releasesleep>
  acquire(&icache.lock);
80102253:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
8010225a:	e8 91 2c 00 00       	call   80104ef0 <acquire>
  ip->ref--;
8010225f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102263:	83 c4 10             	add    $0x10,%esp
80102266:	c7 45 08 e0 23 11 80 	movl   $0x801123e0,0x8(%ebp)
}
8010226d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102270:	5b                   	pop    %ebx
80102271:	5e                   	pop    %esi
80102272:	5f                   	pop    %edi
80102273:	5d                   	pop    %ebp
  release(&icache.lock);
80102274:	e9 37 2d 00 00       	jmp    80104fb0 <release>
80102279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	68 e0 23 11 80       	push   $0x801123e0
80102288:	e8 63 2c 00 00       	call   80104ef0 <acquire>
    int r = ip->ref;
8010228d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102290:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
80102297:	e8 14 2d 00 00       	call   80104fb0 <release>
    if(r == 1){
8010229c:	83 c4 10             	add    $0x10,%esp
8010229f:	83 fe 01             	cmp    $0x1,%esi
801022a2:	75 a6                	jne    8010224a <iput+0x2a>
801022a4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801022aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801022ad:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022b0:	89 cf                	mov    %ecx,%edi
801022b2:	eb 0b                	jmp    801022bf <iput+0x9f>
801022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801022b8:	83 c6 04             	add    $0x4,%esi
801022bb:	39 fe                	cmp    %edi,%esi
801022bd:	74 19                	je     801022d8 <iput+0xb8>
    if(ip->addrs[i]){
801022bf:	8b 16                	mov    (%esi),%edx
801022c1:	85 d2                	test   %edx,%edx
801022c3:	74 f3                	je     801022b8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
801022c5:	8b 03                	mov    (%ebx),%eax
801022c7:	e8 74 f8 ff ff       	call   80101b40 <bfree>
      ip->addrs[i] = 0;
801022cc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801022d2:	eb e4                	jmp    801022b8 <iput+0x98>
801022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801022d8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801022de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801022e1:	85 c0                	test   %eax,%eax
801022e3:	75 33                	jne    80102318 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801022e5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801022e8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801022ef:	53                   	push   %ebx
801022f0:	e8 3b fd ff ff       	call   80102030 <iupdate>
      ip->type = 0;
801022f5:	31 c0                	xor    %eax,%eax
801022f7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801022fb:	89 1c 24             	mov    %ebx,(%esp)
801022fe:	e8 2d fd ff ff       	call   80102030 <iupdate>
      ip->valid = 0;
80102303:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	e9 38 ff ff ff       	jmp    8010224a <iput+0x2a>
80102312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102318:	83 ec 08             	sub    $0x8,%esp
8010231b:	50                   	push   %eax
8010231c:	ff 33                	pushl  (%ebx)
8010231e:	e8 ad dd ff ff       	call   801000d0 <bread>
80102323:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102326:	83 c4 10             	add    $0x10,%esp
80102329:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010232f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102332:	8d 70 5c             	lea    0x5c(%eax),%esi
80102335:	89 cf                	mov    %ecx,%edi
80102337:	eb 0e                	jmp    80102347 <iput+0x127>
80102339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102340:	83 c6 04             	add    $0x4,%esi
80102343:	39 f7                	cmp    %esi,%edi
80102345:	74 19                	je     80102360 <iput+0x140>
      if(a[j])
80102347:	8b 16                	mov    (%esi),%edx
80102349:	85 d2                	test   %edx,%edx
8010234b:	74 f3                	je     80102340 <iput+0x120>
        bfree(ip->dev, a[j]);
8010234d:	8b 03                	mov    (%ebx),%eax
8010234f:	e8 ec f7 ff ff       	call   80101b40 <bfree>
80102354:	eb ea                	jmp    80102340 <iput+0x120>
80102356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010235d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	ff 75 e4             	pushl  -0x1c(%ebp)
80102366:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102369:	e8 82 de ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010236e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102374:	8b 03                	mov    (%ebx),%eax
80102376:	e8 c5 f7 ff ff       	call   80101b40 <bfree>
    ip->addrs[NDIRECT] = 0;
8010237b:	83 c4 10             	add    $0x10,%esp
8010237e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102385:	00 00 00 
80102388:	e9 58 ff ff ff       	jmp    801022e5 <iput+0xc5>
8010238d:	8d 76 00             	lea    0x0(%esi),%esi

80102390 <iunlockput>:
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
80102395:	89 e5                	mov    %esp,%ebp
80102397:	53                   	push   %ebx
80102398:	83 ec 10             	sub    $0x10,%esp
8010239b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010239e:	53                   	push   %ebx
8010239f:	e8 2c fe ff ff       	call   801021d0 <iunlock>
  iput(ip);
801023a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801023a7:	83 c4 10             	add    $0x10,%esp
}
801023aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ad:	c9                   	leave  
  iput(ip);
801023ae:	e9 6d fe ff ff       	jmp    80102220 <iput>
801023b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
801023c5:	89 e5                	mov    %esp,%ebp
801023c7:	8b 55 08             	mov    0x8(%ebp),%edx
801023ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801023cd:	8b 0a                	mov    (%edx),%ecx
801023cf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801023d2:	8b 4a 04             	mov    0x4(%edx),%ecx
801023d5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801023d8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801023dc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801023df:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801023e3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801023e7:	8b 52 58             	mov    0x58(%edx),%edx
801023ea:	89 50 10             	mov    %edx,0x10(%eax)
}
801023ed:	5d                   	pop    %ebp
801023ee:	c3                   	ret    
801023ef:	90                   	nop

801023f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801023f0:	f3 0f 1e fb          	endbr32 
801023f4:	55                   	push   %ebp
801023f5:	89 e5                	mov    %esp,%ebp
801023f7:	57                   	push   %edi
801023f8:	56                   	push   %esi
801023f9:	53                   	push   %ebx
801023fa:	83 ec 1c             	sub    $0x1c,%esp
801023fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102400:	8b 45 08             	mov    0x8(%ebp),%eax
80102403:	8b 75 10             	mov    0x10(%ebp),%esi
80102406:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102409:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010240c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102411:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102414:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102417:	0f 84 a3 00 00 00    	je     801024c0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010241d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102420:	8b 40 58             	mov    0x58(%eax),%eax
80102423:	39 c6                	cmp    %eax,%esi
80102425:	0f 87 b6 00 00 00    	ja     801024e1 <readi+0xf1>
8010242b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010242e:	31 c9                	xor    %ecx,%ecx
80102430:	89 da                	mov    %ebx,%edx
80102432:	01 f2                	add    %esi,%edx
80102434:	0f 92 c1             	setb   %cl
80102437:	89 cf                	mov    %ecx,%edi
80102439:	0f 82 a2 00 00 00    	jb     801024e1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010243f:	89 c1                	mov    %eax,%ecx
80102441:	29 f1                	sub    %esi,%ecx
80102443:	39 d0                	cmp    %edx,%eax
80102445:	0f 43 cb             	cmovae %ebx,%ecx
80102448:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010244b:	85 c9                	test   %ecx,%ecx
8010244d:	74 63                	je     801024b2 <readi+0xc2>
8010244f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102450:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102453:	89 f2                	mov    %esi,%edx
80102455:	c1 ea 09             	shr    $0x9,%edx
80102458:	89 d8                	mov    %ebx,%eax
8010245a:	e8 61 f9 ff ff       	call   80101dc0 <bmap>
8010245f:	83 ec 08             	sub    $0x8,%esp
80102462:	50                   	push   %eax
80102463:	ff 33                	pushl  (%ebx)
80102465:	e8 66 dc ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010246a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010246d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102472:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102475:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102477:	89 f0                	mov    %esi,%eax
80102479:	25 ff 01 00 00       	and    $0x1ff,%eax
8010247e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102480:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102483:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102485:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102489:	39 d9                	cmp    %ebx,%ecx
8010248b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010248e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010248f:	01 df                	add    %ebx,%edi
80102491:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102493:	50                   	push   %eax
80102494:	ff 75 e0             	pushl  -0x20(%ebp)
80102497:	e8 04 2c 00 00       	call   801050a0 <memmove>
    brelse(bp);
8010249c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010249f:	89 14 24             	mov    %edx,(%esp)
801024a2:	e8 49 dd ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801024a7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801024aa:	83 c4 10             	add    $0x10,%esp
801024ad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801024b0:	77 9e                	ja     80102450 <readi+0x60>
  }
  return n;
801024b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801024b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b8:	5b                   	pop    %ebx
801024b9:	5e                   	pop    %esi
801024ba:	5f                   	pop    %edi
801024bb:	5d                   	pop    %ebp
801024bc:	c3                   	ret    
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801024c0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801024c4:	66 83 f8 09          	cmp    $0x9,%ax
801024c8:	77 17                	ja     801024e1 <readi+0xf1>
801024ca:	8b 04 c5 60 23 11 80 	mov    -0x7feedca0(,%eax,8),%eax
801024d1:	85 c0                	test   %eax,%eax
801024d3:	74 0c                	je     801024e1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801024d5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801024d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024db:	5b                   	pop    %ebx
801024dc:	5e                   	pop    %esi
801024dd:	5f                   	pop    %edi
801024de:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801024df:	ff e0                	jmp    *%eax
      return -1;
801024e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024e6:	eb cd                	jmp    801024b5 <readi+0xc5>
801024e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ef:	90                   	nop

801024f0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801024f0:	f3 0f 1e fb          	endbr32 
801024f4:	55                   	push   %ebp
801024f5:	89 e5                	mov    %esp,%ebp
801024f7:	57                   	push   %edi
801024f8:	56                   	push   %esi
801024f9:	53                   	push   %ebx
801024fa:	83 ec 1c             	sub    $0x1c,%esp
801024fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102500:	8b 75 0c             	mov    0xc(%ebp),%esi
80102503:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102506:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010250b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010250e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102511:	8b 75 10             	mov    0x10(%ebp),%esi
80102514:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102517:	0f 84 b3 00 00 00    	je     801025d0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010251d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102520:	39 70 58             	cmp    %esi,0x58(%eax)
80102523:	0f 82 e3 00 00 00    	jb     8010260c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102529:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010252c:	89 f8                	mov    %edi,%eax
8010252e:	01 f0                	add    %esi,%eax
80102530:	0f 82 d6 00 00 00    	jb     8010260c <writei+0x11c>
80102536:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010253b:	0f 87 cb 00 00 00    	ja     8010260c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102541:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102548:	85 ff                	test   %edi,%edi
8010254a:	74 75                	je     801025c1 <writei+0xd1>
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102550:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102553:	89 f2                	mov    %esi,%edx
80102555:	c1 ea 09             	shr    $0x9,%edx
80102558:	89 f8                	mov    %edi,%eax
8010255a:	e8 61 f8 ff ff       	call   80101dc0 <bmap>
8010255f:	83 ec 08             	sub    $0x8,%esp
80102562:	50                   	push   %eax
80102563:	ff 37                	pushl  (%edi)
80102565:	e8 66 db ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010256a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010256f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102572:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102575:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102577:	89 f0                	mov    %esi,%eax
80102579:	83 c4 0c             	add    $0xc,%esp
8010257c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102581:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102583:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102587:	39 d9                	cmp    %ebx,%ecx
80102589:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010258c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010258d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010258f:	ff 75 dc             	pushl  -0x24(%ebp)
80102592:	50                   	push   %eax
80102593:	e8 08 2b 00 00       	call   801050a0 <memmove>
    log_write(bp);
80102598:	89 3c 24             	mov    %edi,(%esp)
8010259b:	e8 00 13 00 00       	call   801038a0 <log_write>
    brelse(bp);
801025a0:	89 3c 24             	mov    %edi,(%esp)
801025a3:	e8 48 dc ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801025a8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801025ab:	83 c4 10             	add    $0x10,%esp
801025ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025b1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801025b4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801025b7:	77 97                	ja     80102550 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801025b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025bc:	3b 70 58             	cmp    0x58(%eax),%esi
801025bf:	77 37                	ja     801025f8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801025c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5f                   	pop    %edi
801025ca:	5d                   	pop    %ebp
801025cb:	c3                   	ret    
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801025d0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801025d4:	66 83 f8 09          	cmp    $0x9,%ax
801025d8:	77 32                	ja     8010260c <writei+0x11c>
801025da:	8b 04 c5 64 23 11 80 	mov    -0x7feedc9c(,%eax,8),%eax
801025e1:	85 c0                	test   %eax,%eax
801025e3:	74 27                	je     8010260c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801025e5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801025e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025eb:	5b                   	pop    %ebx
801025ec:	5e                   	pop    %esi
801025ed:	5f                   	pop    %edi
801025ee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801025ef:	ff e0                	jmp    *%eax
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801025f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801025fb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801025fe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102601:	50                   	push   %eax
80102602:	e8 29 fa ff ff       	call   80102030 <iupdate>
80102607:	83 c4 10             	add    $0x10,%esp
8010260a:	eb b5                	jmp    801025c1 <writei+0xd1>
      return -1;
8010260c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102611:	eb b1                	jmp    801025c4 <writei+0xd4>
80102613:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102620 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102620:	f3 0f 1e fb          	endbr32 
80102624:	55                   	push   %ebp
80102625:	89 e5                	mov    %esp,%ebp
80102627:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010262a:	6a 0e                	push   $0xe
8010262c:	ff 75 0c             	pushl  0xc(%ebp)
8010262f:	ff 75 08             	pushl  0x8(%ebp)
80102632:	e8 d9 2a 00 00       	call   80105110 <strncmp>
}
80102637:	c9                   	leave  
80102638:	c3                   	ret    
80102639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102640 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102640:	f3 0f 1e fb          	endbr32 
80102644:	55                   	push   %ebp
80102645:	89 e5                	mov    %esp,%ebp
80102647:	57                   	push   %edi
80102648:	56                   	push   %esi
80102649:	53                   	push   %ebx
8010264a:	83 ec 1c             	sub    $0x1c,%esp
8010264d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102650:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102655:	0f 85 89 00 00 00    	jne    801026e4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010265b:	8b 53 58             	mov    0x58(%ebx),%edx
8010265e:	31 ff                	xor    %edi,%edi
80102660:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102663:	85 d2                	test   %edx,%edx
80102665:	74 42                	je     801026a9 <dirlookup+0x69>
80102667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102670:	6a 10                	push   $0x10
80102672:	57                   	push   %edi
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
80102675:	e8 76 fd ff ff       	call   801023f0 <readi>
8010267a:	83 c4 10             	add    $0x10,%esp
8010267d:	83 f8 10             	cmp    $0x10,%eax
80102680:	75 55                	jne    801026d7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102682:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102687:	74 18                	je     801026a1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102689:	83 ec 04             	sub    $0x4,%esp
8010268c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010268f:	6a 0e                	push   $0xe
80102691:	50                   	push   %eax
80102692:	ff 75 0c             	pushl  0xc(%ebp)
80102695:	e8 76 2a 00 00       	call   80105110 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010269a:	83 c4 10             	add    $0x10,%esp
8010269d:	85 c0                	test   %eax,%eax
8010269f:	74 17                	je     801026b8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801026a1:	83 c7 10             	add    $0x10,%edi
801026a4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801026a7:	72 c7                	jb     80102670 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801026a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801026ac:	31 c0                	xor    %eax,%eax
}
801026ae:	5b                   	pop    %ebx
801026af:	5e                   	pop    %esi
801026b0:	5f                   	pop    %edi
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret    
801026b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026b7:	90                   	nop
      if(poff)
801026b8:	8b 45 10             	mov    0x10(%ebp),%eax
801026bb:	85 c0                	test   %eax,%eax
801026bd:	74 05                	je     801026c4 <dirlookup+0x84>
        *poff = off;
801026bf:	8b 45 10             	mov    0x10(%ebp),%eax
801026c2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801026c4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801026c8:	8b 03                	mov    (%ebx),%eax
801026ca:	e8 01 f6 ff ff       	call   80101cd0 <iget>
}
801026cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026d2:	5b                   	pop    %ebx
801026d3:	5e                   	pop    %esi
801026d4:	5f                   	pop    %edi
801026d5:	5d                   	pop    %ebp
801026d6:	c3                   	ret    
      panic("dirlookup read");
801026d7:	83 ec 0c             	sub    $0xc,%esp
801026da:	68 91 7c 10 80       	push   $0x80107c91
801026df:	e8 ac dc ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801026e4:	83 ec 0c             	sub    $0xc,%esp
801026e7:	68 7f 7c 10 80       	push   $0x80107c7f
801026ec:	e8 9f dc ff ff       	call   80100390 <panic>
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop

80102700 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	57                   	push   %edi
80102704:	56                   	push   %esi
80102705:	53                   	push   %ebx
80102706:	89 c3                	mov    %eax,%ebx
80102708:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010270b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010270e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102711:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102714:	0f 84 86 01 00 00    	je     801028a0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010271a:	e8 d1 1b 00 00       	call   801042f0 <myproc>
  acquire(&icache.lock);
8010271f:	83 ec 0c             	sub    $0xc,%esp
80102722:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102724:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102727:	68 e0 23 11 80       	push   $0x801123e0
8010272c:	e8 bf 27 00 00       	call   80104ef0 <acquire>
  ip->ref++;
80102731:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102735:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
8010273c:	e8 6f 28 00 00       	call   80104fb0 <release>
80102741:	83 c4 10             	add    $0x10,%esp
80102744:	eb 0d                	jmp    80102753 <namex+0x53>
80102746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102750:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102753:	0f b6 07             	movzbl (%edi),%eax
80102756:	3c 2f                	cmp    $0x2f,%al
80102758:	74 f6                	je     80102750 <namex+0x50>
  if(*path == 0)
8010275a:	84 c0                	test   %al,%al
8010275c:	0f 84 ee 00 00 00    	je     80102850 <namex+0x150>
  while(*path != '/' && *path != 0)
80102762:	0f b6 07             	movzbl (%edi),%eax
80102765:	84 c0                	test   %al,%al
80102767:	0f 84 fb 00 00 00    	je     80102868 <namex+0x168>
8010276d:	89 fb                	mov    %edi,%ebx
8010276f:	3c 2f                	cmp    $0x2f,%al
80102771:	0f 84 f1 00 00 00    	je     80102868 <namex+0x168>
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
80102780:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102784:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102787:	3c 2f                	cmp    $0x2f,%al
80102789:	74 04                	je     8010278f <namex+0x8f>
8010278b:	84 c0                	test   %al,%al
8010278d:	75 f1                	jne    80102780 <namex+0x80>
  len = path - s;
8010278f:	89 d8                	mov    %ebx,%eax
80102791:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102793:	83 f8 0d             	cmp    $0xd,%eax
80102796:	0f 8e 84 00 00 00    	jle    80102820 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010279c:	83 ec 04             	sub    $0x4,%esp
8010279f:	6a 0e                	push   $0xe
801027a1:	57                   	push   %edi
    path++;
801027a2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801027a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801027a7:	e8 f4 28 00 00       	call   801050a0 <memmove>
801027ac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801027af:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801027b2:	75 0c                	jne    801027c0 <namex+0xc0>
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801027b8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801027bb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801027be:	74 f8                	je     801027b8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	56                   	push   %esi
801027c4:	e8 27 f9 ff ff       	call   801020f0 <ilock>
    if(ip->type != T_DIR){
801027c9:	83 c4 10             	add    $0x10,%esp
801027cc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801027d1:	0f 85 a1 00 00 00    	jne    80102878 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801027d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801027da:	85 d2                	test   %edx,%edx
801027dc:	74 09                	je     801027e7 <namex+0xe7>
801027de:	80 3f 00             	cmpb   $0x0,(%edi)
801027e1:	0f 84 d9 00 00 00    	je     801028c0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801027e7:	83 ec 04             	sub    $0x4,%esp
801027ea:	6a 00                	push   $0x0
801027ec:	ff 75 e4             	pushl  -0x1c(%ebp)
801027ef:	56                   	push   %esi
801027f0:	e8 4b fe ff ff       	call   80102640 <dirlookup>
801027f5:	83 c4 10             	add    $0x10,%esp
801027f8:	89 c3                	mov    %eax,%ebx
801027fa:	85 c0                	test   %eax,%eax
801027fc:	74 7a                	je     80102878 <namex+0x178>
  iunlock(ip);
801027fe:	83 ec 0c             	sub    $0xc,%esp
80102801:	56                   	push   %esi
80102802:	e8 c9 f9 ff ff       	call   801021d0 <iunlock>
  iput(ip);
80102807:	89 34 24             	mov    %esi,(%esp)
8010280a:	89 de                	mov    %ebx,%esi
8010280c:	e8 0f fa ff ff       	call   80102220 <iput>
80102811:	83 c4 10             	add    $0x10,%esp
80102814:	e9 3a ff ff ff       	jmp    80102753 <namex+0x53>
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102820:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102823:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102826:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102829:	83 ec 04             	sub    $0x4,%esp
8010282c:	50                   	push   %eax
8010282d:	57                   	push   %edi
    name[len] = 0;
8010282e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102830:	ff 75 e4             	pushl  -0x1c(%ebp)
80102833:	e8 68 28 00 00       	call   801050a0 <memmove>
    name[len] = 0;
80102838:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010283b:	83 c4 10             	add    $0x10,%esp
8010283e:	c6 00 00             	movb   $0x0,(%eax)
80102841:	e9 69 ff ff ff       	jmp    801027af <namex+0xaf>
80102846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102850:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102853:	85 c0                	test   %eax,%eax
80102855:	0f 85 85 00 00 00    	jne    801028e0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010285b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010285e:	89 f0                	mov    %esi,%eax
80102860:	5b                   	pop    %ebx
80102861:	5e                   	pop    %esi
80102862:	5f                   	pop    %edi
80102863:	5d                   	pop    %ebp
80102864:	c3                   	ret    
80102865:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010286b:	89 fb                	mov    %edi,%ebx
8010286d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102870:	31 c0                	xor    %eax,%eax
80102872:	eb b5                	jmp    80102829 <namex+0x129>
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102878:	83 ec 0c             	sub    $0xc,%esp
8010287b:	56                   	push   %esi
8010287c:	e8 4f f9 ff ff       	call   801021d0 <iunlock>
  iput(ip);
80102881:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102884:	31 f6                	xor    %esi,%esi
  iput(ip);
80102886:	e8 95 f9 ff ff       	call   80102220 <iput>
      return 0;
8010288b:	83 c4 10             	add    $0x10,%esp
}
8010288e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102891:	89 f0                	mov    %esi,%eax
80102893:	5b                   	pop    %ebx
80102894:	5e                   	pop    %esi
80102895:	5f                   	pop    %edi
80102896:	5d                   	pop    %ebp
80102897:	c3                   	ret    
80102898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801028a0:	ba 01 00 00 00       	mov    $0x1,%edx
801028a5:	b8 01 00 00 00       	mov    $0x1,%eax
801028aa:	89 df                	mov    %ebx,%edi
801028ac:	e8 1f f4 ff ff       	call   80101cd0 <iget>
801028b1:	89 c6                	mov    %eax,%esi
801028b3:	e9 9b fe ff ff       	jmp    80102753 <namex+0x53>
801028b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop
      iunlock(ip);
801028c0:	83 ec 0c             	sub    $0xc,%esp
801028c3:	56                   	push   %esi
801028c4:	e8 07 f9 ff ff       	call   801021d0 <iunlock>
      return ip;
801028c9:	83 c4 10             	add    $0x10,%esp
}
801028cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028cf:	89 f0                	mov    %esi,%eax
801028d1:	5b                   	pop    %ebx
801028d2:	5e                   	pop    %esi
801028d3:	5f                   	pop    %edi
801028d4:	5d                   	pop    %ebp
801028d5:	c3                   	ret    
801028d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028dd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801028e0:	83 ec 0c             	sub    $0xc,%esp
801028e3:	56                   	push   %esi
    return 0;
801028e4:	31 f6                	xor    %esi,%esi
    iput(ip);
801028e6:	e8 35 f9 ff ff       	call   80102220 <iput>
    return 0;
801028eb:	83 c4 10             	add    $0x10,%esp
801028ee:	e9 68 ff ff ff       	jmp    8010285b <namex+0x15b>
801028f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102900 <dirlink>:
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
80102905:	89 e5                	mov    %esp,%ebp
80102907:	57                   	push   %edi
80102908:	56                   	push   %esi
80102909:	53                   	push   %ebx
8010290a:	83 ec 20             	sub    $0x20,%esp
8010290d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102910:	6a 00                	push   $0x0
80102912:	ff 75 0c             	pushl  0xc(%ebp)
80102915:	53                   	push   %ebx
80102916:	e8 25 fd ff ff       	call   80102640 <dirlookup>
8010291b:	83 c4 10             	add    $0x10,%esp
8010291e:	85 c0                	test   %eax,%eax
80102920:	75 6b                	jne    8010298d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102922:	8b 7b 58             	mov    0x58(%ebx),%edi
80102925:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102928:	85 ff                	test   %edi,%edi
8010292a:	74 2d                	je     80102959 <dirlink+0x59>
8010292c:	31 ff                	xor    %edi,%edi
8010292e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102931:	eb 0d                	jmp    80102940 <dirlink+0x40>
80102933:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102937:	90                   	nop
80102938:	83 c7 10             	add    $0x10,%edi
8010293b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010293e:	73 19                	jae    80102959 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102940:	6a 10                	push   $0x10
80102942:	57                   	push   %edi
80102943:	56                   	push   %esi
80102944:	53                   	push   %ebx
80102945:	e8 a6 fa ff ff       	call   801023f0 <readi>
8010294a:	83 c4 10             	add    $0x10,%esp
8010294d:	83 f8 10             	cmp    $0x10,%eax
80102950:	75 4e                	jne    801029a0 <dirlink+0xa0>
    if(de.inum == 0)
80102952:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102957:	75 df                	jne    80102938 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102959:	83 ec 04             	sub    $0x4,%esp
8010295c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010295f:	6a 0e                	push   $0xe
80102961:	ff 75 0c             	pushl  0xc(%ebp)
80102964:	50                   	push   %eax
80102965:	e8 f6 27 00 00       	call   80105160 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010296a:	6a 10                	push   $0x10
  de.inum = inum;
8010296c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010296f:	57                   	push   %edi
80102970:	56                   	push   %esi
80102971:	53                   	push   %ebx
  de.inum = inum;
80102972:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102976:	e8 75 fb ff ff       	call   801024f0 <writei>
8010297b:	83 c4 20             	add    $0x20,%esp
8010297e:	83 f8 10             	cmp    $0x10,%eax
80102981:	75 2a                	jne    801029ad <dirlink+0xad>
  return 0;
80102983:	31 c0                	xor    %eax,%eax
}
80102985:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102988:	5b                   	pop    %ebx
80102989:	5e                   	pop    %esi
8010298a:	5f                   	pop    %edi
8010298b:	5d                   	pop    %ebp
8010298c:	c3                   	ret    
    iput(ip);
8010298d:	83 ec 0c             	sub    $0xc,%esp
80102990:	50                   	push   %eax
80102991:	e8 8a f8 ff ff       	call   80102220 <iput>
    return -1;
80102996:	83 c4 10             	add    $0x10,%esp
80102999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010299e:	eb e5                	jmp    80102985 <dirlink+0x85>
      panic("dirlink read");
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	68 a0 7c 10 80       	push   $0x80107ca0
801029a8:	e8 e3 d9 ff ff       	call   80100390 <panic>
    panic("dirlink");
801029ad:	83 ec 0c             	sub    $0xc,%esp
801029b0:	68 82 82 10 80       	push   $0x80108282
801029b5:	e8 d6 d9 ff ff       	call   80100390 <panic>
801029ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029c0 <namei>:

struct inode*
namei(char *path)
{
801029c0:	f3 0f 1e fb          	endbr32 
801029c4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801029c5:	31 d2                	xor    %edx,%edx
{
801029c7:	89 e5                	mov    %esp,%ebp
801029c9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801029cc:	8b 45 08             	mov    0x8(%ebp),%eax
801029cf:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801029d2:	e8 29 fd ff ff       	call   80102700 <namex>
}
801029d7:	c9                   	leave  
801029d8:	c3                   	ret    
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
  return namex(path, 1, name);
801029e5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801029ea:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801029ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
801029f2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801029f3:	e9 08 fd ff ff       	jmp    80102700 <namex>
801029f8:	66 90                	xchg   %ax,%ax
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	57                   	push   %edi
80102a04:	56                   	push   %esi
80102a05:	53                   	push   %ebx
80102a06:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102a09:	85 c0                	test   %eax,%eax
80102a0b:	0f 84 b4 00 00 00    	je     80102ac5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102a11:	8b 70 08             	mov    0x8(%eax),%esi
80102a14:	89 c3                	mov    %eax,%ebx
80102a16:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80102a1c:	0f 87 96 00 00 00    	ja     80102ab8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a22:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2e:	66 90                	xchg   %ax,%ax
80102a30:	89 ca                	mov    %ecx,%edx
80102a32:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102a33:	83 e0 c0             	and    $0xffffffc0,%eax
80102a36:	3c 40                	cmp    $0x40,%al
80102a38:	75 f6                	jne    80102a30 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3a:	31 ff                	xor    %edi,%edi
80102a3c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102a41:	89 f8                	mov    %edi,%eax
80102a43:	ee                   	out    %al,(%dx)
80102a44:	b8 01 00 00 00       	mov    $0x1,%eax
80102a49:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102a4e:	ee                   	out    %al,(%dx)
80102a4f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102a54:	89 f0                	mov    %esi,%eax
80102a56:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102a57:	89 f0                	mov    %esi,%eax
80102a59:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102a5e:	c1 f8 08             	sar    $0x8,%eax
80102a61:	ee                   	out    %al,(%dx)
80102a62:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102a67:	89 f8                	mov    %edi,%eax
80102a69:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102a6a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80102a6e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a73:	c1 e0 04             	shl    $0x4,%eax
80102a76:	83 e0 10             	and    $0x10,%eax
80102a79:	83 c8 e0             	or     $0xffffffe0,%eax
80102a7c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102a7d:	f6 03 04             	testb  $0x4,(%ebx)
80102a80:	75 16                	jne    80102a98 <idestart+0x98>
80102a82:	b8 20 00 00 00       	mov    $0x20,%eax
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102a8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8d:	5b                   	pop    %ebx
80102a8e:	5e                   	pop    %esi
80102a8f:	5f                   	pop    %edi
80102a90:	5d                   	pop    %ebp
80102a91:	c3                   	ret    
80102a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a98:	b8 30 00 00 00       	mov    $0x30,%eax
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102aa0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102aa5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102aa8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102aad:	fc                   	cld    
80102aae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ab3:	5b                   	pop    %ebx
80102ab4:	5e                   	pop    %esi
80102ab5:	5f                   	pop    %edi
80102ab6:	5d                   	pop    %ebp
80102ab7:	c3                   	ret    
    panic("incorrect blockno");
80102ab8:	83 ec 0c             	sub    $0xc,%esp
80102abb:	68 0c 7d 10 80       	push   $0x80107d0c
80102ac0:	e8 cb d8 ff ff       	call   80100390 <panic>
    panic("idestart");
80102ac5:	83 ec 0c             	sub    $0xc,%esp
80102ac8:	68 03 7d 10 80       	push   $0x80107d03
80102acd:	e8 be d8 ff ff       	call   80100390 <panic>
80102ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ae0 <ideinit>:
{
80102ae0:	f3 0f 1e fb          	endbr32 
80102ae4:	55                   	push   %ebp
80102ae5:	89 e5                	mov    %esp,%ebp
80102ae7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102aea:	68 1e 7d 10 80       	push   $0x80107d1e
80102aef:	68 80 b5 10 80       	push   $0x8010b580
80102af4:	e8 77 22 00 00       	call   80104d70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102af9:	58                   	pop    %eax
80102afa:	a1 00 47 11 80       	mov    0x80114700,%eax
80102aff:	5a                   	pop    %edx
80102b00:	83 e8 01             	sub    $0x1,%eax
80102b03:	50                   	push   %eax
80102b04:	6a 0e                	push   $0xe
80102b06:	e8 b5 02 00 00       	call   80102dc0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102b0b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b17:	90                   	nop
80102b18:	ec                   	in     (%dx),%al
80102b19:	83 e0 c0             	and    $0xffffffc0,%eax
80102b1c:	3c 40                	cmp    $0x40,%al
80102b1e:	75 f8                	jne    80102b18 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b20:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102b25:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102b2a:	ee                   	out    %al,(%dx)
80102b2b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102b35:	eb 0e                	jmp    80102b45 <ideinit+0x65>
80102b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102b40:	83 e9 01             	sub    $0x1,%ecx
80102b43:	74 0f                	je     80102b54 <ideinit+0x74>
80102b45:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102b46:	84 c0                	test   %al,%al
80102b48:	74 f6                	je     80102b40 <ideinit+0x60>
      havedisk1 = 1;
80102b4a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102b51:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b54:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102b59:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102b5e:	ee                   	out    %al,(%dx)
}
80102b5f:	c9                   	leave  
80102b60:	c3                   	ret    
80102b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6f:	90                   	nop

80102b70 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b70:	f3 0f 1e fb          	endbr32 
80102b74:	55                   	push   %ebp
80102b75:	89 e5                	mov    %esp,%ebp
80102b77:	57                   	push   %edi
80102b78:	56                   	push   %esi
80102b79:	53                   	push   %ebx
80102b7a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b7d:	68 80 b5 10 80       	push   $0x8010b580
80102b82:	e8 69 23 00 00       	call   80104ef0 <acquire>

  if((b = idequeue) == 0){
80102b87:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102b8d:	83 c4 10             	add    $0x10,%esp
80102b90:	85 db                	test   %ebx,%ebx
80102b92:	74 5f                	je     80102bf3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102b94:	8b 43 58             	mov    0x58(%ebx),%eax
80102b97:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102b9c:	8b 33                	mov    (%ebx),%esi
80102b9e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102ba4:	75 2b                	jne    80102bd1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102baf:	90                   	nop
80102bb0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102bb1:	89 c1                	mov    %eax,%ecx
80102bb3:	83 e1 c0             	and    $0xffffffc0,%ecx
80102bb6:	80 f9 40             	cmp    $0x40,%cl
80102bb9:	75 f5                	jne    80102bb0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102bbb:	a8 21                	test   $0x21,%al
80102bbd:	75 12                	jne    80102bd1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102bbf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102bc2:	b9 80 00 00 00       	mov    $0x80,%ecx
80102bc7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102bcc:	fc                   	cld    
80102bcd:	f3 6d                	rep insl (%dx),%es:(%edi)
80102bcf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102bd1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102bd4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102bd7:	83 ce 02             	or     $0x2,%esi
80102bda:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102bdc:	53                   	push   %ebx
80102bdd:	e8 8e 1e 00 00       	call   80104a70 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102be2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102be7:	83 c4 10             	add    $0x10,%esp
80102bea:	85 c0                	test   %eax,%eax
80102bec:	74 05                	je     80102bf3 <ideintr+0x83>
    idestart(idequeue);
80102bee:	e8 0d fe ff ff       	call   80102a00 <idestart>
    release(&idelock);
80102bf3:	83 ec 0c             	sub    $0xc,%esp
80102bf6:	68 80 b5 10 80       	push   $0x8010b580
80102bfb:	e8 b0 23 00 00       	call   80104fb0 <release>

  release(&idelock);
}
80102c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c03:	5b                   	pop    %ebx
80102c04:	5e                   	pop    %esi
80102c05:	5f                   	pop    %edi
80102c06:	5d                   	pop    %ebp
80102c07:	c3                   	ret    
80102c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c0f:	90                   	nop

80102c10 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102c10:	f3 0f 1e fb          	endbr32 
80102c14:	55                   	push   %ebp
80102c15:	89 e5                	mov    %esp,%ebp
80102c17:	53                   	push   %ebx
80102c18:	83 ec 10             	sub    $0x10,%esp
80102c1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102c1e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102c21:	50                   	push   %eax
80102c22:	e8 e9 20 00 00       	call   80104d10 <holdingsleep>
80102c27:	83 c4 10             	add    $0x10,%esp
80102c2a:	85 c0                	test   %eax,%eax
80102c2c:	0f 84 cf 00 00 00    	je     80102d01 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102c32:	8b 03                	mov    (%ebx),%eax
80102c34:	83 e0 06             	and    $0x6,%eax
80102c37:	83 f8 02             	cmp    $0x2,%eax
80102c3a:	0f 84 b4 00 00 00    	je     80102cf4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102c40:	8b 53 04             	mov    0x4(%ebx),%edx
80102c43:	85 d2                	test   %edx,%edx
80102c45:	74 0d                	je     80102c54 <iderw+0x44>
80102c47:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102c4c:	85 c0                	test   %eax,%eax
80102c4e:	0f 84 93 00 00 00    	je     80102ce7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102c54:	83 ec 0c             	sub    $0xc,%esp
80102c57:	68 80 b5 10 80       	push   $0x8010b580
80102c5c:	e8 8f 22 00 00       	call   80104ef0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c61:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102c66:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c6d:	83 c4 10             	add    $0x10,%esp
80102c70:	85 c0                	test   %eax,%eax
80102c72:	74 6c                	je     80102ce0 <iderw+0xd0>
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	89 c2                	mov    %eax,%edx
80102c7a:	8b 40 58             	mov    0x58(%eax),%eax
80102c7d:	85 c0                	test   %eax,%eax
80102c7f:	75 f7                	jne    80102c78 <iderw+0x68>
80102c81:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102c84:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102c86:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102c8c:	74 42                	je     80102cd0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c8e:	8b 03                	mov    (%ebx),%eax
80102c90:	83 e0 06             	and    $0x6,%eax
80102c93:	83 f8 02             	cmp    $0x2,%eax
80102c96:	74 23                	je     80102cbb <iderw+0xab>
80102c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
    sleep(b, &idelock);
80102ca0:	83 ec 08             	sub    $0x8,%esp
80102ca3:	68 80 b5 10 80       	push   $0x8010b580
80102ca8:	53                   	push   %ebx
80102ca9:	e8 02 1c 00 00       	call   801048b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102cae:	8b 03                	mov    (%ebx),%eax
80102cb0:	83 c4 10             	add    $0x10,%esp
80102cb3:	83 e0 06             	and    $0x6,%eax
80102cb6:	83 f8 02             	cmp    $0x2,%eax
80102cb9:	75 e5                	jne    80102ca0 <iderw+0x90>
  }


  release(&idelock);
80102cbb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc5:	c9                   	leave  
  release(&idelock);
80102cc6:	e9 e5 22 00 00       	jmp    80104fb0 <release>
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop
    idestart(b);
80102cd0:	89 d8                	mov    %ebx,%eax
80102cd2:	e8 29 fd ff ff       	call   80102a00 <idestart>
80102cd7:	eb b5                	jmp    80102c8e <iderw+0x7e>
80102cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102ce0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102ce5:	eb 9d                	jmp    80102c84 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102ce7:	83 ec 0c             	sub    $0xc,%esp
80102cea:	68 4d 7d 10 80       	push   $0x80107d4d
80102cef:	e8 9c d6 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102cf4:	83 ec 0c             	sub    $0xc,%esp
80102cf7:	68 38 7d 10 80       	push   $0x80107d38
80102cfc:	e8 8f d6 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102d01:	83 ec 0c             	sub    $0xc,%esp
80102d04:	68 22 7d 10 80       	push   $0x80107d22
80102d09:	e8 82 d6 ff ff       	call   80100390 <panic>
80102d0e:	66 90                	xchg   %ax,%ax

80102d10 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102d15:	c7 05 34 40 11 80 00 	movl   $0xfec00000,0x80114034
80102d1c:	00 c0 fe 
{
80102d1f:	89 e5                	mov    %esp,%ebp
80102d21:	56                   	push   %esi
80102d22:	53                   	push   %ebx
  ioapic->reg = reg;
80102d23:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102d2a:	00 00 00 
  return ioapic->data;
80102d2d:	8b 15 34 40 11 80    	mov    0x80114034,%edx
80102d33:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102d36:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102d3c:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102d42:	0f b6 15 60 41 11 80 	movzbl 0x80114160,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d49:	c1 ee 10             	shr    $0x10,%esi
80102d4c:	89 f0                	mov    %esi,%eax
80102d4e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102d51:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102d54:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102d57:	39 c2                	cmp    %eax,%edx
80102d59:	74 16                	je     80102d71 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102d5b:	83 ec 0c             	sub    $0xc,%esp
80102d5e:	68 6c 7d 10 80       	push   $0x80107d6c
80102d63:	e8 88 d9 ff ff       	call   801006f0 <cprintf>
80102d68:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
80102d6e:	83 c4 10             	add    $0x10,%esp
80102d71:	83 c6 21             	add    $0x21,%esi
{
80102d74:	ba 10 00 00 00       	mov    $0x10,%edx
80102d79:	b8 20 00 00 00       	mov    $0x20,%eax
80102d7e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102d80:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102d82:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102d84:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
80102d8a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102d8d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102d93:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102d96:	8d 5a 01             	lea    0x1(%edx),%ebx
80102d99:	83 c2 02             	add    $0x2,%edx
80102d9c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102d9e:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
80102da4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102dab:	39 f0                	cmp    %esi,%eax
80102dad:	75 d1                	jne    80102d80 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102daf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102db2:	5b                   	pop    %ebx
80102db3:	5e                   	pop    %esi
80102db4:	5d                   	pop    %ebp
80102db5:	c3                   	ret    
80102db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dbd:	8d 76 00             	lea    0x0(%esi),%esi

80102dc0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102dc0:	f3 0f 1e fb          	endbr32 
80102dc4:	55                   	push   %ebp
  ioapic->reg = reg;
80102dc5:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
{
80102dcb:	89 e5                	mov    %esp,%ebp
80102dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102dd0:	8d 50 20             	lea    0x20(%eax),%edx
80102dd3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102dd7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102dd9:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ddf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102de2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102de8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102dea:	a1 34 40 11 80       	mov    0x80114034,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102def:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102df2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102df5:	5d                   	pop    %ebp
80102df6:	c3                   	ret    
80102df7:	66 90                	xchg   %ax,%ax
80102df9:	66 90                	xchg   %ax,%ax
80102dfb:	66 90                	xchg   %ax,%ax
80102dfd:	66 90                	xchg   %ax,%ax
80102dff:	90                   	nop

80102e00 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102e00:	f3 0f 1e fb          	endbr32 
80102e04:	55                   	push   %ebp
80102e05:	89 e5                	mov    %esp,%ebp
80102e07:	53                   	push   %ebx
80102e08:	83 ec 04             	sub    $0x4,%esp
80102e0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102e0e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102e14:	75 7a                	jne    80102e90 <kfree+0x90>
80102e16:	81 fb a8 6e 11 80    	cmp    $0x80116ea8,%ebx
80102e1c:	72 72                	jb     80102e90 <kfree+0x90>
80102e1e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102e24:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102e29:	77 65                	ja     80102e90 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102e2b:	83 ec 04             	sub    $0x4,%esp
80102e2e:	68 00 10 00 00       	push   $0x1000
80102e33:	6a 01                	push   $0x1
80102e35:	53                   	push   %ebx
80102e36:	e8 c5 21 00 00       	call   80105000 <memset>

  if(kmem.use_lock)
80102e3b:	8b 15 74 40 11 80    	mov    0x80114074,%edx
80102e41:	83 c4 10             	add    $0x10,%esp
80102e44:	85 d2                	test   %edx,%edx
80102e46:	75 20                	jne    80102e68 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102e48:	a1 78 40 11 80       	mov    0x80114078,%eax
80102e4d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102e4f:	a1 74 40 11 80       	mov    0x80114074,%eax
  kmem.freelist = r;
80102e54:	89 1d 78 40 11 80    	mov    %ebx,0x80114078
  if(kmem.use_lock)
80102e5a:	85 c0                	test   %eax,%eax
80102e5c:	75 22                	jne    80102e80 <kfree+0x80>
    release(&kmem.lock);
}
80102e5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e61:	c9                   	leave  
80102e62:	c3                   	ret    
80102e63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e67:	90                   	nop
    acquire(&kmem.lock);
80102e68:	83 ec 0c             	sub    $0xc,%esp
80102e6b:	68 40 40 11 80       	push   $0x80114040
80102e70:	e8 7b 20 00 00       	call   80104ef0 <acquire>
80102e75:	83 c4 10             	add    $0x10,%esp
80102e78:	eb ce                	jmp    80102e48 <kfree+0x48>
80102e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102e80:	c7 45 08 40 40 11 80 	movl   $0x80114040,0x8(%ebp)
}
80102e87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e8a:	c9                   	leave  
    release(&kmem.lock);
80102e8b:	e9 20 21 00 00       	jmp    80104fb0 <release>
    panic("kfree");
80102e90:	83 ec 0c             	sub    $0xc,%esp
80102e93:	68 9e 7d 10 80       	push   $0x80107d9e
80102e98:	e8 f3 d4 ff ff       	call   80100390 <panic>
80102e9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ea0 <freerange>:
{
80102ea0:	f3 0f 1e fb          	endbr32 
80102ea4:	55                   	push   %ebp
80102ea5:	89 e5                	mov    %esp,%ebp
80102ea7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ea8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102eab:	8b 75 0c             	mov    0xc(%ebp),%esi
80102eae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102eaf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102eb5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ebb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ec1:	39 de                	cmp    %ebx,%esi
80102ec3:	72 1f                	jb     80102ee4 <freerange+0x44>
80102ec5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102ec8:	83 ec 0c             	sub    $0xc,%esp
80102ecb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ed1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ed7:	50                   	push   %eax
80102ed8:	e8 23 ff ff ff       	call   80102e00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102edd:	83 c4 10             	add    $0x10,%esp
80102ee0:	39 f3                	cmp    %esi,%ebx
80102ee2:	76 e4                	jbe    80102ec8 <freerange+0x28>
}
80102ee4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ee7:	5b                   	pop    %ebx
80102ee8:	5e                   	pop    %esi
80102ee9:	5d                   	pop    %ebp
80102eea:	c3                   	ret    
80102eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eef:	90                   	nop

80102ef0 <kinit1>:
{
80102ef0:	f3 0f 1e fb          	endbr32 
80102ef4:	55                   	push   %ebp
80102ef5:	89 e5                	mov    %esp,%ebp
80102ef7:	56                   	push   %esi
80102ef8:	53                   	push   %ebx
80102ef9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102efc:	83 ec 08             	sub    $0x8,%esp
80102eff:	68 a4 7d 10 80       	push   $0x80107da4
80102f04:	68 40 40 11 80       	push   $0x80114040
80102f09:	e8 62 1e 00 00       	call   80104d70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f11:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102f14:	c7 05 74 40 11 80 00 	movl   $0x0,0x80114074
80102f1b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102f1e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102f24:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f2a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102f30:	39 de                	cmp    %ebx,%esi
80102f32:	72 20                	jb     80102f54 <kinit1+0x64>
80102f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102f38:	83 ec 0c             	sub    $0xc,%esp
80102f3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102f47:	50                   	push   %eax
80102f48:	e8 b3 fe ff ff       	call   80102e00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f4d:	83 c4 10             	add    $0x10,%esp
80102f50:	39 de                	cmp    %ebx,%esi
80102f52:	73 e4                	jae    80102f38 <kinit1+0x48>
}
80102f54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f57:	5b                   	pop    %ebx
80102f58:	5e                   	pop    %esi
80102f59:	5d                   	pop    %ebp
80102f5a:	c3                   	ret    
80102f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <kinit2>:
{
80102f60:	f3 0f 1e fb          	endbr32 
80102f64:	55                   	push   %ebp
80102f65:	89 e5                	mov    %esp,%ebp
80102f67:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102f68:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102f6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102f6e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102f6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102f75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102f81:	39 de                	cmp    %ebx,%esi
80102f83:	72 1f                	jb     80102fa4 <kinit2+0x44>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102f88:	83 ec 0c             	sub    $0xc,%esp
80102f8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102f97:	50                   	push   %eax
80102f98:	e8 63 fe ff ff       	call   80102e00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f9d:	83 c4 10             	add    $0x10,%esp
80102fa0:	39 de                	cmp    %ebx,%esi
80102fa2:	73 e4                	jae    80102f88 <kinit2+0x28>
  kmem.use_lock = 1;
80102fa4:	c7 05 74 40 11 80 01 	movl   $0x1,0x80114074
80102fab:	00 00 00 
}
80102fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fb1:	5b                   	pop    %ebx
80102fb2:	5e                   	pop    %esi
80102fb3:	5d                   	pop    %ebp
80102fb4:	c3                   	ret    
80102fb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fc0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102fc0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102fc4:	a1 74 40 11 80       	mov    0x80114074,%eax
80102fc9:	85 c0                	test   %eax,%eax
80102fcb:	75 1b                	jne    80102fe8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102fcd:	a1 78 40 11 80       	mov    0x80114078,%eax
  if(r)
80102fd2:	85 c0                	test   %eax,%eax
80102fd4:	74 0a                	je     80102fe0 <kalloc+0x20>
    kmem.freelist = r->next;
80102fd6:	8b 10                	mov    (%eax),%edx
80102fd8:	89 15 78 40 11 80    	mov    %edx,0x80114078
  if(kmem.use_lock)
80102fde:	c3                   	ret    
80102fdf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102fe0:	c3                   	ret    
80102fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102fe8:	55                   	push   %ebp
80102fe9:	89 e5                	mov    %esp,%ebp
80102feb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102fee:	68 40 40 11 80       	push   $0x80114040
80102ff3:	e8 f8 1e 00 00       	call   80104ef0 <acquire>
  r = kmem.freelist;
80102ff8:	a1 78 40 11 80       	mov    0x80114078,%eax
  if(r)
80102ffd:	8b 15 74 40 11 80    	mov    0x80114074,%edx
80103003:	83 c4 10             	add    $0x10,%esp
80103006:	85 c0                	test   %eax,%eax
80103008:	74 08                	je     80103012 <kalloc+0x52>
    kmem.freelist = r->next;
8010300a:	8b 08                	mov    (%eax),%ecx
8010300c:	89 0d 78 40 11 80    	mov    %ecx,0x80114078
  if(kmem.use_lock)
80103012:	85 d2                	test   %edx,%edx
80103014:	74 16                	je     8010302c <kalloc+0x6c>
    release(&kmem.lock);
80103016:	83 ec 0c             	sub    $0xc,%esp
80103019:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010301c:	68 40 40 11 80       	push   $0x80114040
80103021:	e8 8a 1f 00 00       	call   80104fb0 <release>
  return (char*)r;
80103026:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80103029:	83 c4 10             	add    $0x10,%esp
}
8010302c:	c9                   	leave  
8010302d:	c3                   	ret    
8010302e:	66 90                	xchg   %ax,%ax

80103030 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103030:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103034:	ba 64 00 00 00       	mov    $0x64,%edx
80103039:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010303a:	a8 01                	test   $0x1,%al
8010303c:	0f 84 be 00 00 00    	je     80103100 <kbdgetc+0xd0>
{
80103042:	55                   	push   %ebp
80103043:	ba 60 00 00 00       	mov    $0x60,%edx
80103048:	89 e5                	mov    %esp,%ebp
8010304a:	53                   	push   %ebx
8010304b:	ec                   	in     (%dx),%al
  return data;
8010304c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80103052:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80103055:	3c e0                	cmp    $0xe0,%al
80103057:	74 57                	je     801030b0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80103059:	89 d9                	mov    %ebx,%ecx
8010305b:	83 e1 40             	and    $0x40,%ecx
8010305e:	84 c0                	test   %al,%al
80103060:	78 5e                	js     801030c0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103062:	85 c9                	test   %ecx,%ecx
80103064:	74 09                	je     8010306f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103066:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103069:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010306c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010306f:	0f b6 8a e0 7e 10 80 	movzbl -0x7fef8120(%edx),%ecx
  shift ^= togglecode[data];
80103076:	0f b6 82 e0 7d 10 80 	movzbl -0x7fef8220(%edx),%eax
  shift |= shiftcode[data];
8010307d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010307f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80103081:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80103083:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80103089:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010308c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010308f:	8b 04 85 c0 7d 10 80 	mov    -0x7fef8240(,%eax,4),%eax
80103096:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010309a:	74 0b                	je     801030a7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010309c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010309f:	83 fa 19             	cmp    $0x19,%edx
801030a2:	77 44                	ja     801030e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801030a4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801030a7:	5b                   	pop    %ebx
801030a8:	5d                   	pop    %ebp
801030a9:	c3                   	ret    
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801030b0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801030b3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801030b5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
801030bb:	5b                   	pop    %ebx
801030bc:	5d                   	pop    %ebp
801030bd:	c3                   	ret    
801030be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801030c0:	83 e0 7f             	and    $0x7f,%eax
801030c3:	85 c9                	test   %ecx,%ecx
801030c5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801030c8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801030ca:	0f b6 8a e0 7e 10 80 	movzbl -0x7fef8120(%edx),%ecx
801030d1:	83 c9 40             	or     $0x40,%ecx
801030d4:	0f b6 c9             	movzbl %cl,%ecx
801030d7:	f7 d1                	not    %ecx
801030d9:	21 d9                	and    %ebx,%ecx
}
801030db:	5b                   	pop    %ebx
801030dc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801030dd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801030e3:	c3                   	ret    
801030e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801030e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801030eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801030ee:	5b                   	pop    %ebx
801030ef:	5d                   	pop    %ebp
      c += 'a' - 'A';
801030f0:	83 f9 1a             	cmp    $0x1a,%ecx
801030f3:	0f 42 c2             	cmovb  %edx,%eax
}
801030f6:	c3                   	ret    
801030f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030fe:	66 90                	xchg   %ax,%ax
    return -1;
80103100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103105:	c3                   	ret    
80103106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010310d:	8d 76 00             	lea    0x0(%esi),%esi

80103110 <kbdintr>:

void
kbdintr(void)
{
80103110:	f3 0f 1e fb          	endbr32 
80103114:	55                   	push   %ebp
80103115:	89 e5                	mov    %esp,%ebp
80103117:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010311a:	68 30 30 10 80       	push   $0x80103030
8010311f:	e8 2c db ff ff       	call   80100c50 <consoleintr>
}
80103124:	83 c4 10             	add    $0x10,%esp
80103127:	c9                   	leave  
80103128:	c3                   	ret    
80103129:	66 90                	xchg   %ax,%ax
8010312b:	66 90                	xchg   %ax,%ax
8010312d:	66 90                	xchg   %ax,%ax
8010312f:	90                   	nop

80103130 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103130:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103134:	a1 7c 40 11 80       	mov    0x8011407c,%eax
80103139:	85 c0                	test   %eax,%eax
8010313b:	0f 84 c7 00 00 00    	je     80103208 <lapicinit+0xd8>
  lapic[index] = value;
80103141:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103148:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010314b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010314e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103155:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103158:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010315b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103162:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103165:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103168:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010316f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103172:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103175:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010317c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010317f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103182:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103189:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010318c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010318f:	8b 50 30             	mov    0x30(%eax),%edx
80103192:	c1 ea 10             	shr    $0x10,%edx
80103195:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010319b:	75 73                	jne    80103210 <lapicinit+0xe0>
  lapic[index] = value;
8010319d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801031a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031aa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801031b1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031b7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801031be:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031c4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801031cb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031d1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801031d8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031de:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801031e5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801031e8:	8b 50 20             	mov    0x20(%eax),%edx
801031eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801031f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801031f6:	80 e6 10             	and    $0x10,%dh
801031f9:	75 f5                	jne    801031f0 <lapicinit+0xc0>
  lapic[index] = value;
801031fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103202:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103205:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103208:	c3                   	ret    
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103210:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103217:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010321a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010321d:	e9 7b ff ff ff       	jmp    8010319d <lapicinit+0x6d>
80103222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103230 <lapicid>:

int
lapicid(void)
{
80103230:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103234:	a1 7c 40 11 80       	mov    0x8011407c,%eax
80103239:	85 c0                	test   %eax,%eax
8010323b:	74 0b                	je     80103248 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010323d:	8b 40 20             	mov    0x20(%eax),%eax
80103240:	c1 e8 18             	shr    $0x18,%eax
80103243:	c3                   	ret    
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103248:	31 c0                	xor    %eax,%eax
}
8010324a:	c3                   	ret    
8010324b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010324f:	90                   	nop

80103250 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103250:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103254:	a1 7c 40 11 80       	mov    0x8011407c,%eax
80103259:	85 c0                	test   %eax,%eax
8010325b:	74 0d                	je     8010326a <lapiceoi+0x1a>
  lapic[index] = value;
8010325d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103264:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103267:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010326a:	c3                   	ret    
8010326b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010326f:	90                   	nop

80103270 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103270:	f3 0f 1e fb          	endbr32 
}
80103274:	c3                   	ret    
80103275:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103280 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103280:	f3 0f 1e fb          	endbr32 
80103284:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103285:	b8 0f 00 00 00       	mov    $0xf,%eax
8010328a:	ba 70 00 00 00       	mov    $0x70,%edx
8010328f:	89 e5                	mov    %esp,%ebp
80103291:	53                   	push   %ebx
80103292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103295:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103298:	ee                   	out    %al,(%dx)
80103299:	b8 0a 00 00 00       	mov    $0xa,%eax
8010329e:	ba 71 00 00 00       	mov    $0x71,%edx
801032a3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801032a4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801032a6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801032a9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801032af:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801032b1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801032b4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801032b6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801032b9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801032bc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801032c2:	a1 7c 40 11 80       	mov    0x8011407c,%eax
801032c7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801032cd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801032d0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801032d7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032da:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801032dd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801032e4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032e7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801032ea:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801032f0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801032f3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801032f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801032fc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103302:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103305:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010330b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010330c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010330f:	5d                   	pop    %ebp
80103310:	c3                   	ret    
80103311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop

80103320 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103320:	f3 0f 1e fb          	endbr32 
80103324:	55                   	push   %ebp
80103325:	b8 0b 00 00 00       	mov    $0xb,%eax
8010332a:	ba 70 00 00 00       	mov    $0x70,%edx
8010332f:	89 e5                	mov    %esp,%ebp
80103331:	57                   	push   %edi
80103332:	56                   	push   %esi
80103333:	53                   	push   %ebx
80103334:	83 ec 4c             	sub    $0x4c,%esp
80103337:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103338:	ba 71 00 00 00       	mov    $0x71,%edx
8010333d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010333e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103341:	bb 70 00 00 00       	mov    $0x70,%ebx
80103346:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103350:	31 c0                	xor    %eax,%eax
80103352:	89 da                	mov    %ebx,%edx
80103354:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103355:	b9 71 00 00 00       	mov    $0x71,%ecx
8010335a:	89 ca                	mov    %ecx,%edx
8010335c:	ec                   	in     (%dx),%al
8010335d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103360:	89 da                	mov    %ebx,%edx
80103362:	b8 02 00 00 00       	mov    $0x2,%eax
80103367:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103368:	89 ca                	mov    %ecx,%edx
8010336a:	ec                   	in     (%dx),%al
8010336b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	89 da                	mov    %ebx,%edx
80103370:	b8 04 00 00 00       	mov    $0x4,%eax
80103375:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103376:	89 ca                	mov    %ecx,%edx
80103378:	ec                   	in     (%dx),%al
80103379:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337c:	89 da                	mov    %ebx,%edx
8010337e:	b8 07 00 00 00       	mov    $0x7,%eax
80103383:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103384:	89 ca                	mov    %ecx,%edx
80103386:	ec                   	in     (%dx),%al
80103387:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010338a:	89 da                	mov    %ebx,%edx
8010338c:	b8 08 00 00 00       	mov    $0x8,%eax
80103391:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103392:	89 ca                	mov    %ecx,%edx
80103394:	ec                   	in     (%dx),%al
80103395:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103397:	89 da                	mov    %ebx,%edx
80103399:	b8 09 00 00 00       	mov    $0x9,%eax
8010339e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010339f:	89 ca                	mov    %ecx,%edx
801033a1:	ec                   	in     (%dx),%al
801033a2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a4:	89 da                	mov    %ebx,%edx
801033a6:	b8 0a 00 00 00       	mov    $0xa,%eax
801033ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033ac:	89 ca                	mov    %ecx,%edx
801033ae:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801033af:	84 c0                	test   %al,%al
801033b1:	78 9d                	js     80103350 <cmostime+0x30>
  return inb(CMOS_RETURN);
801033b3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801033b7:	89 fa                	mov    %edi,%edx
801033b9:	0f b6 fa             	movzbl %dl,%edi
801033bc:	89 f2                	mov    %esi,%edx
801033be:	89 45 b8             	mov    %eax,-0x48(%ebp)
801033c1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801033c5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033c8:	89 da                	mov    %ebx,%edx
801033ca:	89 7d c8             	mov    %edi,-0x38(%ebp)
801033cd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801033d0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801033d4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801033d7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801033da:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801033de:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801033e1:	31 c0                	xor    %eax,%eax
801033e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033e4:	89 ca                	mov    %ecx,%edx
801033e6:	ec                   	in     (%dx),%al
801033e7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ea:	89 da                	mov    %ebx,%edx
801033ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
801033ef:	b8 02 00 00 00       	mov    $0x2,%eax
801033f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033f5:	89 ca                	mov    %ecx,%edx
801033f7:	ec                   	in     (%dx),%al
801033f8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033fb:	89 da                	mov    %ebx,%edx
801033fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103400:	b8 04 00 00 00       	mov    $0x4,%eax
80103405:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103406:	89 ca                	mov    %ecx,%edx
80103408:	ec                   	in     (%dx),%al
80103409:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010340c:	89 da                	mov    %ebx,%edx
8010340e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103411:	b8 07 00 00 00       	mov    $0x7,%eax
80103416:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103417:	89 ca                	mov    %ecx,%edx
80103419:	ec                   	in     (%dx),%al
8010341a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010341d:	89 da                	mov    %ebx,%edx
8010341f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103422:	b8 08 00 00 00       	mov    $0x8,%eax
80103427:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103428:	89 ca                	mov    %ecx,%edx
8010342a:	ec                   	in     (%dx),%al
8010342b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010342e:	89 da                	mov    %ebx,%edx
80103430:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103433:	b8 09 00 00 00       	mov    $0x9,%eax
80103438:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103439:	89 ca                	mov    %ecx,%edx
8010343b:	ec                   	in     (%dx),%al
8010343c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010343f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103445:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103448:	6a 18                	push   $0x18
8010344a:	50                   	push   %eax
8010344b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010344e:	50                   	push   %eax
8010344f:	e8 fc 1b 00 00       	call   80105050 <memcmp>
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	85 c0                	test   %eax,%eax
80103459:	0f 85 f1 fe ff ff    	jne    80103350 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010345f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103463:	75 78                	jne    801034dd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103465:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103468:	89 c2                	mov    %eax,%edx
8010346a:	83 e0 0f             	and    $0xf,%eax
8010346d:	c1 ea 04             	shr    $0x4,%edx
80103470:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103473:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103476:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103479:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010347c:	89 c2                	mov    %eax,%edx
8010347e:	83 e0 0f             	and    $0xf,%eax
80103481:	c1 ea 04             	shr    $0x4,%edx
80103484:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103487:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010348a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010348d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103490:	89 c2                	mov    %eax,%edx
80103492:	83 e0 0f             	and    $0xf,%eax
80103495:	c1 ea 04             	shr    $0x4,%edx
80103498:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010349b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010349e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801034a1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801034a4:	89 c2                	mov    %eax,%edx
801034a6:	83 e0 0f             	and    $0xf,%eax
801034a9:	c1 ea 04             	shr    $0x4,%edx
801034ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801034af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801034b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801034b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801034b8:	89 c2                	mov    %eax,%edx
801034ba:	83 e0 0f             	and    $0xf,%eax
801034bd:	c1 ea 04             	shr    $0x4,%edx
801034c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801034c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801034c6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801034c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801034cc:	89 c2                	mov    %eax,%edx
801034ce:	83 e0 0f             	and    $0xf,%eax
801034d1:	c1 ea 04             	shr    $0x4,%edx
801034d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801034d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801034da:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801034dd:	8b 75 08             	mov    0x8(%ebp),%esi
801034e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801034e3:	89 06                	mov    %eax,(%esi)
801034e5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801034e8:	89 46 04             	mov    %eax,0x4(%esi)
801034eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801034ee:	89 46 08             	mov    %eax,0x8(%esi)
801034f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801034f4:	89 46 0c             	mov    %eax,0xc(%esi)
801034f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801034fa:	89 46 10             	mov    %eax,0x10(%esi)
801034fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103500:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103503:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010350a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010350d:	5b                   	pop    %ebx
8010350e:	5e                   	pop    %esi
8010350f:	5f                   	pop    %edi
80103510:	5d                   	pop    %ebp
80103511:	c3                   	ret    
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103520:	8b 0d c8 40 11 80    	mov    0x801140c8,%ecx
80103526:	85 c9                	test   %ecx,%ecx
80103528:	0f 8e 8a 00 00 00    	jle    801035b8 <install_trans+0x98>
{
8010352e:	55                   	push   %ebp
8010352f:	89 e5                	mov    %esp,%ebp
80103531:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103532:	31 ff                	xor    %edi,%edi
{
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 0c             	sub    $0xc,%esp
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103540:	a1 b4 40 11 80       	mov    0x801140b4,%eax
80103545:	83 ec 08             	sub    $0x8,%esp
80103548:	01 f8                	add    %edi,%eax
8010354a:	83 c0 01             	add    $0x1,%eax
8010354d:	50                   	push   %eax
8010354e:	ff 35 c4 40 11 80    	pushl  0x801140c4
80103554:	e8 77 cb ff ff       	call   801000d0 <bread>
80103559:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010355b:	58                   	pop    %eax
8010355c:	5a                   	pop    %edx
8010355d:	ff 34 bd cc 40 11 80 	pushl  -0x7feebf34(,%edi,4)
80103564:	ff 35 c4 40 11 80    	pushl  0x801140c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010356a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010356d:	e8 5e cb ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103572:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103575:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103577:	8d 46 5c             	lea    0x5c(%esi),%eax
8010357a:	68 00 02 00 00       	push   $0x200
8010357f:	50                   	push   %eax
80103580:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103583:	50                   	push   %eax
80103584:	e8 17 1b 00 00       	call   801050a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103589:	89 1c 24             	mov    %ebx,(%esp)
8010358c:	e8 1f cc ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103591:	89 34 24             	mov    %esi,(%esp)
80103594:	e8 57 cc ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103599:	89 1c 24             	mov    %ebx,(%esp)
8010359c:	e8 4f cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801035a1:	83 c4 10             	add    $0x10,%esp
801035a4:	39 3d c8 40 11 80    	cmp    %edi,0x801140c8
801035aa:	7f 94                	jg     80103540 <install_trans+0x20>
  }
}
801035ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035af:	5b                   	pop    %ebx
801035b0:	5e                   	pop    %esi
801035b1:	5f                   	pop    %edi
801035b2:	5d                   	pop    %ebp
801035b3:	c3                   	ret    
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b8:	c3                   	ret    
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	53                   	push   %ebx
801035c4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801035c7:	ff 35 b4 40 11 80    	pushl  0x801140b4
801035cd:	ff 35 c4 40 11 80    	pushl  0x801140c4
801035d3:	e8 f8 ca ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801035d8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801035db:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801035dd:	a1 c8 40 11 80       	mov    0x801140c8,%eax
801035e2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801035e5:	85 c0                	test   %eax,%eax
801035e7:	7e 19                	jle    80103602 <write_head+0x42>
801035e9:	31 d2                	xor    %edx,%edx
801035eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035ef:	90                   	nop
    hb->block[i] = log.lh.block[i];
801035f0:	8b 0c 95 cc 40 11 80 	mov    -0x7feebf34(,%edx,4),%ecx
801035f7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801035fb:	83 c2 01             	add    $0x1,%edx
801035fe:	39 d0                	cmp    %edx,%eax
80103600:	75 ee                	jne    801035f0 <write_head+0x30>
  }
  bwrite(buf);
80103602:	83 ec 0c             	sub    $0xc,%esp
80103605:	53                   	push   %ebx
80103606:	e8 a5 cb ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010360b:	89 1c 24             	mov    %ebx,(%esp)
8010360e:	e8 dd cb ff ff       	call   801001f0 <brelse>
}
80103613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	c9                   	leave  
8010361a:	c3                   	ret    
8010361b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010361f:	90                   	nop

80103620 <initlog>:
{
80103620:	f3 0f 1e fb          	endbr32 
80103624:	55                   	push   %ebp
80103625:	89 e5                	mov    %esp,%ebp
80103627:	53                   	push   %ebx
80103628:	83 ec 2c             	sub    $0x2c,%esp
8010362b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010362e:	68 e0 7f 10 80       	push   $0x80107fe0
80103633:	68 80 40 11 80       	push   $0x80114080
80103638:	e8 33 17 00 00       	call   80104d70 <initlock>
  readsb(dev, &sb);
8010363d:	58                   	pop    %eax
8010363e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103641:	5a                   	pop    %edx
80103642:	50                   	push   %eax
80103643:	53                   	push   %ebx
80103644:	e8 47 e8 ff ff       	call   80101e90 <readsb>
  log.start = sb.logstart;
80103649:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010364c:	59                   	pop    %ecx
  log.dev = dev;
8010364d:	89 1d c4 40 11 80    	mov    %ebx,0x801140c4
  log.size = sb.nlog;
80103653:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103656:	a3 b4 40 11 80       	mov    %eax,0x801140b4
  log.size = sb.nlog;
8010365b:	89 15 b8 40 11 80    	mov    %edx,0x801140b8
  struct buf *buf = bread(log.dev, log.start);
80103661:	5a                   	pop    %edx
80103662:	50                   	push   %eax
80103663:	53                   	push   %ebx
80103664:	e8 67 ca ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103669:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010366c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010366f:	89 0d c8 40 11 80    	mov    %ecx,0x801140c8
  for (i = 0; i < log.lh.n; i++) {
80103675:	85 c9                	test   %ecx,%ecx
80103677:	7e 19                	jle    80103692 <initlog+0x72>
80103679:	31 d2                	xor    %edx,%edx
8010367b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010367f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103680:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103684:	89 1c 95 cc 40 11 80 	mov    %ebx,-0x7feebf34(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010368b:	83 c2 01             	add    $0x1,%edx
8010368e:	39 d1                	cmp    %edx,%ecx
80103690:	75 ee                	jne    80103680 <initlog+0x60>
  brelse(buf);
80103692:	83 ec 0c             	sub    $0xc,%esp
80103695:	50                   	push   %eax
80103696:	e8 55 cb ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010369b:	e8 80 fe ff ff       	call   80103520 <install_trans>
  log.lh.n = 0;
801036a0:	c7 05 c8 40 11 80 00 	movl   $0x0,0x801140c8
801036a7:	00 00 00 
  write_head(); // clear the log
801036aa:	e8 11 ff ff ff       	call   801035c0 <write_head>
}
801036af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036b2:	83 c4 10             	add    $0x10,%esp
801036b5:	c9                   	leave  
801036b6:	c3                   	ret    
801036b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036be:	66 90                	xchg   %ax,%ax

801036c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801036c0:	f3 0f 1e fb          	endbr32 
801036c4:	55                   	push   %ebp
801036c5:	89 e5                	mov    %esp,%ebp
801036c7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801036ca:	68 80 40 11 80       	push   $0x80114080
801036cf:	e8 1c 18 00 00       	call   80104ef0 <acquire>
801036d4:	83 c4 10             	add    $0x10,%esp
801036d7:	eb 1c                	jmp    801036f5 <begin_op+0x35>
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801036e0:	83 ec 08             	sub    $0x8,%esp
801036e3:	68 80 40 11 80       	push   $0x80114080
801036e8:	68 80 40 11 80       	push   $0x80114080
801036ed:	e8 be 11 00 00       	call   801048b0 <sleep>
801036f2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801036f5:	a1 c0 40 11 80       	mov    0x801140c0,%eax
801036fa:	85 c0                	test   %eax,%eax
801036fc:	75 e2                	jne    801036e0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801036fe:	a1 bc 40 11 80       	mov    0x801140bc,%eax
80103703:	8b 15 c8 40 11 80    	mov    0x801140c8,%edx
80103709:	83 c0 01             	add    $0x1,%eax
8010370c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010370f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103712:	83 fa 1e             	cmp    $0x1e,%edx
80103715:	7f c9                	jg     801036e0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103717:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010371a:	a3 bc 40 11 80       	mov    %eax,0x801140bc
      release(&log.lock);
8010371f:	68 80 40 11 80       	push   $0x80114080
80103724:	e8 87 18 00 00       	call   80104fb0 <release>
      break;
    }
  }
}
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	c9                   	leave  
8010372d:	c3                   	ret    
8010372e:	66 90                	xchg   %ax,%ax

80103730 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103730:	f3 0f 1e fb          	endbr32 
80103734:	55                   	push   %ebp
80103735:	89 e5                	mov    %esp,%ebp
80103737:	57                   	push   %edi
80103738:	56                   	push   %esi
80103739:	53                   	push   %ebx
8010373a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010373d:	68 80 40 11 80       	push   $0x80114080
80103742:	e8 a9 17 00 00       	call   80104ef0 <acquire>
  log.outstanding -= 1;
80103747:	a1 bc 40 11 80       	mov    0x801140bc,%eax
  if(log.committing)
8010374c:	8b 35 c0 40 11 80    	mov    0x801140c0,%esi
80103752:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103755:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103758:	89 1d bc 40 11 80    	mov    %ebx,0x801140bc
  if(log.committing)
8010375e:	85 f6                	test   %esi,%esi
80103760:	0f 85 1e 01 00 00    	jne    80103884 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103766:	85 db                	test   %ebx,%ebx
80103768:	0f 85 f2 00 00 00    	jne    80103860 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010376e:	c7 05 c0 40 11 80 01 	movl   $0x1,0x801140c0
80103775:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	68 80 40 11 80       	push   $0x80114080
80103780:	e8 2b 18 00 00       	call   80104fb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103785:	8b 0d c8 40 11 80    	mov    0x801140c8,%ecx
8010378b:	83 c4 10             	add    $0x10,%esp
8010378e:	85 c9                	test   %ecx,%ecx
80103790:	7f 3e                	jg     801037d0 <end_op+0xa0>
    acquire(&log.lock);
80103792:	83 ec 0c             	sub    $0xc,%esp
80103795:	68 80 40 11 80       	push   $0x80114080
8010379a:	e8 51 17 00 00       	call   80104ef0 <acquire>
    wakeup(&log);
8010379f:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
    log.committing = 0;
801037a6:	c7 05 c0 40 11 80 00 	movl   $0x0,0x801140c0
801037ad:	00 00 00 
    wakeup(&log);
801037b0:	e8 bb 12 00 00       	call   80104a70 <wakeup>
    release(&log.lock);
801037b5:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
801037bc:	e8 ef 17 00 00       	call   80104fb0 <release>
801037c1:	83 c4 10             	add    $0x10,%esp
}
801037c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c7:	5b                   	pop    %ebx
801037c8:	5e                   	pop    %esi
801037c9:	5f                   	pop    %edi
801037ca:	5d                   	pop    %ebp
801037cb:	c3                   	ret    
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801037d0:	a1 b4 40 11 80       	mov    0x801140b4,%eax
801037d5:	83 ec 08             	sub    $0x8,%esp
801037d8:	01 d8                	add    %ebx,%eax
801037da:	83 c0 01             	add    $0x1,%eax
801037dd:	50                   	push   %eax
801037de:	ff 35 c4 40 11 80    	pushl  0x801140c4
801037e4:	e8 e7 c8 ff ff       	call   801000d0 <bread>
801037e9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801037eb:	58                   	pop    %eax
801037ec:	5a                   	pop    %edx
801037ed:	ff 34 9d cc 40 11 80 	pushl  -0x7feebf34(,%ebx,4)
801037f4:	ff 35 c4 40 11 80    	pushl  0x801140c4
  for (tail = 0; tail < log.lh.n; tail++) {
801037fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801037fd:	e8 ce c8 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103802:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103805:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103807:	8d 40 5c             	lea    0x5c(%eax),%eax
8010380a:	68 00 02 00 00       	push   $0x200
8010380f:	50                   	push   %eax
80103810:	8d 46 5c             	lea    0x5c(%esi),%eax
80103813:	50                   	push   %eax
80103814:	e8 87 18 00 00       	call   801050a0 <memmove>
    bwrite(to);  // write the log
80103819:	89 34 24             	mov    %esi,(%esp)
8010381c:	e8 8f c9 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103821:	89 3c 24             	mov    %edi,(%esp)
80103824:	e8 c7 c9 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103829:	89 34 24             	mov    %esi,(%esp)
8010382c:	e8 bf c9 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103831:	83 c4 10             	add    $0x10,%esp
80103834:	3b 1d c8 40 11 80    	cmp    0x801140c8,%ebx
8010383a:	7c 94                	jl     801037d0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010383c:	e8 7f fd ff ff       	call   801035c0 <write_head>
    install_trans(); // Now install writes to home locations
80103841:	e8 da fc ff ff       	call   80103520 <install_trans>
    log.lh.n = 0;
80103846:	c7 05 c8 40 11 80 00 	movl   $0x0,0x801140c8
8010384d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103850:	e8 6b fd ff ff       	call   801035c0 <write_head>
80103855:	e9 38 ff ff ff       	jmp    80103792 <end_op+0x62>
8010385a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	68 80 40 11 80       	push   $0x80114080
80103868:	e8 03 12 00 00       	call   80104a70 <wakeup>
  release(&log.lock);
8010386d:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
80103874:	e8 37 17 00 00       	call   80104fb0 <release>
80103879:	83 c4 10             	add    $0x10,%esp
}
8010387c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010387f:	5b                   	pop    %ebx
80103880:	5e                   	pop    %esi
80103881:	5f                   	pop    %edi
80103882:	5d                   	pop    %ebp
80103883:	c3                   	ret    
    panic("log.committing");
80103884:	83 ec 0c             	sub    $0xc,%esp
80103887:	68 e4 7f 10 80       	push   $0x80107fe4
8010388c:	e8 ff ca ff ff       	call   80100390 <panic>
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010389f:	90                   	nop

801038a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	53                   	push   %ebx
801038a8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038ab:	8b 15 c8 40 11 80    	mov    0x801140c8,%edx
{
801038b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038b4:	83 fa 1d             	cmp    $0x1d,%edx
801038b7:	0f 8f 91 00 00 00    	jg     8010394e <log_write+0xae>
801038bd:	a1 b8 40 11 80       	mov    0x801140b8,%eax
801038c2:	83 e8 01             	sub    $0x1,%eax
801038c5:	39 c2                	cmp    %eax,%edx
801038c7:	0f 8d 81 00 00 00    	jge    8010394e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801038cd:	a1 bc 40 11 80       	mov    0x801140bc,%eax
801038d2:	85 c0                	test   %eax,%eax
801038d4:	0f 8e 81 00 00 00    	jle    8010395b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	68 80 40 11 80       	push   $0x80114080
801038e2:	e8 09 16 00 00       	call   80104ef0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801038e7:	8b 15 c8 40 11 80    	mov    0x801140c8,%edx
801038ed:	83 c4 10             	add    $0x10,%esp
801038f0:	85 d2                	test   %edx,%edx
801038f2:	7e 4e                	jle    80103942 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801038f4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801038f7:	31 c0                	xor    %eax,%eax
801038f9:	eb 0c                	jmp    80103907 <log_write+0x67>
801038fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038ff:	90                   	nop
80103900:	83 c0 01             	add    $0x1,%eax
80103903:	39 c2                	cmp    %eax,%edx
80103905:	74 29                	je     80103930 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103907:	39 0c 85 cc 40 11 80 	cmp    %ecx,-0x7feebf34(,%eax,4)
8010390e:	75 f0                	jne    80103900 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103910:	89 0c 85 cc 40 11 80 	mov    %ecx,-0x7feebf34(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103917:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010391a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010391d:	c7 45 08 80 40 11 80 	movl   $0x80114080,0x8(%ebp)
}
80103924:	c9                   	leave  
  release(&log.lock);
80103925:	e9 86 16 00 00       	jmp    80104fb0 <release>
8010392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103930:	89 0c 95 cc 40 11 80 	mov    %ecx,-0x7feebf34(,%edx,4)
    log.lh.n++;
80103937:	83 c2 01             	add    $0x1,%edx
8010393a:	89 15 c8 40 11 80    	mov    %edx,0x801140c8
80103940:	eb d5                	jmp    80103917 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103942:	8b 43 08             	mov    0x8(%ebx),%eax
80103945:	a3 cc 40 11 80       	mov    %eax,0x801140cc
  if (i == log.lh.n)
8010394a:	75 cb                	jne    80103917 <log_write+0x77>
8010394c:	eb e9                	jmp    80103937 <log_write+0x97>
    panic("too big a transaction");
8010394e:	83 ec 0c             	sub    $0xc,%esp
80103951:	68 f3 7f 10 80       	push   $0x80107ff3
80103956:	e8 35 ca ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010395b:	83 ec 0c             	sub    $0xc,%esp
8010395e:	68 09 80 10 80       	push   $0x80108009
80103963:	e8 28 ca ff ff       	call   80100390 <panic>
80103968:	66 90                	xchg   %ax,%ax
8010396a:	66 90                	xchg   %ax,%ax
8010396c:	66 90                	xchg   %ax,%ax
8010396e:	66 90                	xchg   %ax,%ax

80103970 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
80103974:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103977:	e8 54 09 00 00       	call   801042d0 <cpuid>
8010397c:	89 c3                	mov    %eax,%ebx
8010397e:	e8 4d 09 00 00       	call   801042d0 <cpuid>
80103983:	83 ec 04             	sub    $0x4,%esp
80103986:	53                   	push   %ebx
80103987:	50                   	push   %eax
80103988:	68 24 80 10 80       	push   $0x80108024
8010398d:	e8 5e cd ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
80103992:	e8 99 29 00 00       	call   80106330 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103997:	e8 c4 08 00 00       	call   80104260 <mycpu>
8010399c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010399e:	b8 01 00 00 00       	mov    $0x1,%eax
801039a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801039aa:	e8 11 0c 00 00       	call   801045c0 <scheduler>
801039af:	90                   	nop

801039b0 <mpenter>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801039ba:	e8 41 3a 00 00       	call   80107400 <switchkvm>
  seginit();
801039bf:	e8 ac 39 00 00       	call   80107370 <seginit>
  lapicinit();
801039c4:	e8 67 f7 ff ff       	call   80103130 <lapicinit>
  mpmain();
801039c9:	e8 a2 ff ff ff       	call   80103970 <mpmain>
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <main>:
{
801039d0:	f3 0f 1e fb          	endbr32 
801039d4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801039d8:	83 e4 f0             	and    $0xfffffff0,%esp
801039db:	ff 71 fc             	pushl  -0x4(%ecx)
801039de:	55                   	push   %ebp
801039df:	89 e5                	mov    %esp,%ebp
801039e1:	53                   	push   %ebx
801039e2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801039e3:	83 ec 08             	sub    $0x8,%esp
801039e6:	68 00 00 40 80       	push   $0x80400000
801039eb:	68 a8 6e 11 80       	push   $0x80116ea8
801039f0:	e8 fb f4 ff ff       	call   80102ef0 <kinit1>
  kvmalloc();      // kernel page table
801039f5:	e8 e6 3e 00 00       	call   801078e0 <kvmalloc>
  mpinit();        // detect other processors
801039fa:	e8 81 01 00 00       	call   80103b80 <mpinit>
  lapicinit();     // interrupt controller
801039ff:	e8 2c f7 ff ff       	call   80103130 <lapicinit>
  seginit();       // segment descriptors
80103a04:	e8 67 39 00 00       	call   80107370 <seginit>
  picinit();       // disable pic
80103a09:	e8 52 03 00 00       	call   80103d60 <picinit>
  ioapicinit();    // another interrupt controller
80103a0e:	e8 fd f2 ff ff       	call   80102d10 <ioapicinit>
  consoleinit();   // console hardware
80103a13:	e8 a8 d9 ff ff       	call   801013c0 <consoleinit>
  uartinit();      // serial port
80103a18:	e8 13 2c 00 00       	call   80106630 <uartinit>
  pinit();         // process table
80103a1d:	e8 1e 08 00 00       	call   80104240 <pinit>
  tvinit();        // trap vectors
80103a22:	e8 89 28 00 00       	call   801062b0 <tvinit>
  binit();         // buffer cache
80103a27:	e8 14 c6 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103a2c:	e8 3f dd ff ff       	call   80101770 <fileinit>
  ideinit();       // disk 
80103a31:	e8 aa f0 ff ff       	call   80102ae0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a36:	83 c4 0c             	add    $0xc,%esp
80103a39:	68 8a 00 00 00       	push   $0x8a
80103a3e:	68 8c b4 10 80       	push   $0x8010b48c
80103a43:	68 00 70 00 80       	push   $0x80007000
80103a48:	e8 53 16 00 00       	call   801050a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103a4d:	83 c4 10             	add    $0x10,%esp
80103a50:	69 05 00 47 11 80 b0 	imul   $0xb0,0x80114700,%eax
80103a57:	00 00 00 
80103a5a:	05 80 41 11 80       	add    $0x80114180,%eax
80103a5f:	3d 80 41 11 80       	cmp    $0x80114180,%eax
80103a64:	76 7a                	jbe    80103ae0 <main+0x110>
80103a66:	bb 80 41 11 80       	mov    $0x80114180,%ebx
80103a6b:	eb 1c                	jmp    80103a89 <main+0xb9>
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi
80103a70:	69 05 00 47 11 80 b0 	imul   $0xb0,0x80114700,%eax
80103a77:	00 00 00 
80103a7a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103a80:	05 80 41 11 80       	add    $0x80114180,%eax
80103a85:	39 c3                	cmp    %eax,%ebx
80103a87:	73 57                	jae    80103ae0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103a89:	e8 d2 07 00 00       	call   80104260 <mycpu>
80103a8e:	39 c3                	cmp    %eax,%ebx
80103a90:	74 de                	je     80103a70 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a92:	e8 29 f5 ff ff       	call   80102fc0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103a97:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103a9a:	c7 05 f8 6f 00 80 b0 	movl   $0x801039b0,0x80006ff8
80103aa1:	39 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103aa4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103aab:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103aae:	05 00 10 00 00       	add    $0x1000,%eax
80103ab3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103ab8:	0f b6 03             	movzbl (%ebx),%eax
80103abb:	68 00 70 00 00       	push   $0x7000
80103ac0:	50                   	push   %eax
80103ac1:	e8 ba f7 ff ff       	call   80103280 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103ac6:	83 c4 10             	add    $0x10,%esp
80103ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ad0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103ad6:	85 c0                	test   %eax,%eax
80103ad8:	74 f6                	je     80103ad0 <main+0x100>
80103ada:	eb 94                	jmp    80103a70 <main+0xa0>
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103ae0:	83 ec 08             	sub    $0x8,%esp
80103ae3:	68 00 00 00 8e       	push   $0x8e000000
80103ae8:	68 00 00 40 80       	push   $0x80400000
80103aed:	e8 6e f4 ff ff       	call   80102f60 <kinit2>
  userinit();      // first user process
80103af2:	e8 29 08 00 00       	call   80104320 <userinit>
  mpmain();        // finish this processor's setup
80103af7:	e8 74 fe ff ff       	call   80103970 <mpmain>
80103afc:	66 90                	xchg   %ax,%ax
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	57                   	push   %edi
80103b04:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103b05:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103b0b:	53                   	push   %ebx
  e = addr+len;
80103b0c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103b0f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103b12:	39 de                	cmp    %ebx,%esi
80103b14:	72 10                	jb     80103b26 <mpsearch1+0x26>
80103b16:	eb 50                	jmp    80103b68 <mpsearch1+0x68>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop
80103b20:	89 fe                	mov    %edi,%esi
80103b22:	39 fb                	cmp    %edi,%ebx
80103b24:	76 42                	jbe    80103b68 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b26:	83 ec 04             	sub    $0x4,%esp
80103b29:	8d 7e 10             	lea    0x10(%esi),%edi
80103b2c:	6a 04                	push   $0x4
80103b2e:	68 38 80 10 80       	push   $0x80108038
80103b33:	56                   	push   %esi
80103b34:	e8 17 15 00 00       	call   80105050 <memcmp>
80103b39:	83 c4 10             	add    $0x10,%esp
80103b3c:	85 c0                	test   %eax,%eax
80103b3e:	75 e0                	jne    80103b20 <mpsearch1+0x20>
80103b40:	89 f2                	mov    %esi,%edx
80103b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103b48:	0f b6 0a             	movzbl (%edx),%ecx
80103b4b:	83 c2 01             	add    $0x1,%edx
80103b4e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103b50:	39 fa                	cmp    %edi,%edx
80103b52:	75 f4                	jne    80103b48 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b54:	84 c0                	test   %al,%al
80103b56:	75 c8                	jne    80103b20 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b5b:	89 f0                	mov    %esi,%eax
80103b5d:	5b                   	pop    %ebx
80103b5e:	5e                   	pop    %esi
80103b5f:	5f                   	pop    %edi
80103b60:	5d                   	pop    %ebp
80103b61:	c3                   	ret    
80103b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b6b:	31 f6                	xor    %esi,%esi
}
80103b6d:	5b                   	pop    %ebx
80103b6e:	89 f0                	mov    %esi,%eax
80103b70:	5e                   	pop    %esi
80103b71:	5f                   	pop    %edi
80103b72:	5d                   	pop    %ebp
80103b73:	c3                   	ret    
80103b74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop

80103b80 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103b80:	f3 0f 1e fb          	endbr32 
80103b84:	55                   	push   %ebp
80103b85:	89 e5                	mov    %esp,%ebp
80103b87:	57                   	push   %edi
80103b88:	56                   	push   %esi
80103b89:	53                   	push   %ebx
80103b8a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b8d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103b94:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103b9b:	c1 e0 08             	shl    $0x8,%eax
80103b9e:	09 d0                	or     %edx,%eax
80103ba0:	c1 e0 04             	shl    $0x4,%eax
80103ba3:	75 1b                	jne    80103bc0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ba5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103bac:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103bb3:	c1 e0 08             	shl    $0x8,%eax
80103bb6:	09 d0                	or     %edx,%eax
80103bb8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103bbb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103bc0:	ba 00 04 00 00       	mov    $0x400,%edx
80103bc5:	e8 36 ff ff ff       	call   80103b00 <mpsearch1>
80103bca:	89 c6                	mov    %eax,%esi
80103bcc:	85 c0                	test   %eax,%eax
80103bce:	0f 84 4c 01 00 00    	je     80103d20 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bd4:	8b 5e 04             	mov    0x4(%esi),%ebx
80103bd7:	85 db                	test   %ebx,%ebx
80103bd9:	0f 84 61 01 00 00    	je     80103d40 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103bdf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103be2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103be8:	6a 04                	push   $0x4
80103bea:	68 3d 80 10 80       	push   $0x8010803d
80103bef:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103bf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bf3:	e8 58 14 00 00       	call   80105050 <memcmp>
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	85 c0                	test   %eax,%eax
80103bfd:	0f 85 3d 01 00 00    	jne    80103d40 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103c03:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103c0a:	3c 01                	cmp    $0x1,%al
80103c0c:	74 08                	je     80103c16 <mpinit+0x96>
80103c0e:	3c 04                	cmp    $0x4,%al
80103c10:	0f 85 2a 01 00 00    	jne    80103d40 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103c16:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103c1d:	66 85 d2             	test   %dx,%dx
80103c20:	74 26                	je     80103c48 <mpinit+0xc8>
80103c22:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103c25:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103c27:	31 d2                	xor    %edx,%edx
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103c30:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103c37:	83 c0 01             	add    $0x1,%eax
80103c3a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103c3c:	39 f8                	cmp    %edi,%eax
80103c3e:	75 f0                	jne    80103c30 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103c40:	84 d2                	test   %dl,%dl
80103c42:	0f 85 f8 00 00 00    	jne    80103d40 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103c48:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103c4e:	a3 7c 40 11 80       	mov    %eax,0x8011407c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c53:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103c59:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103c60:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c65:	03 55 e4             	add    -0x1c(%ebp),%edx
80103c68:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c6f:	90                   	nop
80103c70:	39 c2                	cmp    %eax,%edx
80103c72:	76 15                	jbe    80103c89 <mpinit+0x109>
    switch(*p){
80103c74:	0f b6 08             	movzbl (%eax),%ecx
80103c77:	80 f9 02             	cmp    $0x2,%cl
80103c7a:	74 5c                	je     80103cd8 <mpinit+0x158>
80103c7c:	77 42                	ja     80103cc0 <mpinit+0x140>
80103c7e:	84 c9                	test   %cl,%cl
80103c80:	74 6e                	je     80103cf0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103c82:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c85:	39 c2                	cmp    %eax,%edx
80103c87:	77 eb                	ja     80103c74 <mpinit+0xf4>
80103c89:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103c8c:	85 db                	test   %ebx,%ebx
80103c8e:	0f 84 b9 00 00 00    	je     80103d4d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103c94:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103c98:	74 15                	je     80103caf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c9a:	b8 70 00 00 00       	mov    $0x70,%eax
80103c9f:	ba 22 00 00 00       	mov    $0x22,%edx
80103ca4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ca5:	ba 23 00 00 00       	mov    $0x23,%edx
80103caa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103cab:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cae:	ee                   	out    %al,(%dx)
  }
}
80103caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cb2:	5b                   	pop    %ebx
80103cb3:	5e                   	pop    %esi
80103cb4:	5f                   	pop    %edi
80103cb5:	5d                   	pop    %ebp
80103cb6:	c3                   	ret    
80103cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbe:	66 90                	xchg   %ax,%ax
    switch(*p){
80103cc0:	83 e9 03             	sub    $0x3,%ecx
80103cc3:	80 f9 01             	cmp    $0x1,%cl
80103cc6:	76 ba                	jbe    80103c82 <mpinit+0x102>
80103cc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103ccf:	eb 9f                	jmp    80103c70 <mpinit+0xf0>
80103cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103cd8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103cdc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103cdf:	88 0d 60 41 11 80    	mov    %cl,0x80114160
      continue;
80103ce5:	eb 89                	jmp    80103c70 <mpinit+0xf0>
80103ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cee:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103cf0:	8b 0d 00 47 11 80    	mov    0x80114700,%ecx
80103cf6:	83 f9 07             	cmp    $0x7,%ecx
80103cf9:	7f 19                	jg     80103d14 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103cfb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103d01:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103d05:	83 c1 01             	add    $0x1,%ecx
80103d08:	89 0d 00 47 11 80    	mov    %ecx,0x80114700
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d0e:	88 9f 80 41 11 80    	mov    %bl,-0x7feebe80(%edi)
      p += sizeof(struct mpproc);
80103d14:	83 c0 14             	add    $0x14,%eax
      continue;
80103d17:	e9 54 ff ff ff       	jmp    80103c70 <mpinit+0xf0>
80103d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103d20:	ba 00 00 01 00       	mov    $0x10000,%edx
80103d25:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103d2a:	e8 d1 fd ff ff       	call   80103b00 <mpsearch1>
80103d2f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d31:	85 c0                	test   %eax,%eax
80103d33:	0f 85 9b fe ff ff    	jne    80103bd4 <mpinit+0x54>
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	68 42 80 10 80       	push   $0x80108042
80103d48:	e8 43 c6 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103d4d:	83 ec 0c             	sub    $0xc,%esp
80103d50:	68 5c 80 10 80       	push   $0x8010805c
80103d55:	e8 36 c6 ff ff       	call   80100390 <panic>
80103d5a:	66 90                	xchg   %ax,%ax
80103d5c:	66 90                	xchg   %ax,%ax
80103d5e:	66 90                	xchg   %ax,%ax

80103d60 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103d60:	f3 0f 1e fb          	endbr32 
80103d64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d69:	ba 21 00 00 00       	mov    $0x21,%edx
80103d6e:	ee                   	out    %al,(%dx)
80103d6f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103d74:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103d75:	c3                   	ret    
80103d76:	66 90                	xchg   %ax,%ax
80103d78:	66 90                	xchg   %ax,%ax
80103d7a:	66 90                	xchg   %ax,%ax
80103d7c:	66 90                	xchg   %ax,%ax
80103d7e:	66 90                	xchg   %ax,%ax

80103d80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103d80:	f3 0f 1e fb          	endbr32 
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	57                   	push   %edi
80103d88:	56                   	push   %esi
80103d89:	53                   	push   %ebx
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d90:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103d93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103d99:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d9f:	e8 ec d9 ff ff       	call   80101790 <filealloc>
80103da4:	89 03                	mov    %eax,(%ebx)
80103da6:	85 c0                	test   %eax,%eax
80103da8:	0f 84 ac 00 00 00    	je     80103e5a <pipealloc+0xda>
80103dae:	e8 dd d9 ff ff       	call   80101790 <filealloc>
80103db3:	89 06                	mov    %eax,(%esi)
80103db5:	85 c0                	test   %eax,%eax
80103db7:	0f 84 8b 00 00 00    	je     80103e48 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103dbd:	e8 fe f1 ff ff       	call   80102fc0 <kalloc>
80103dc2:	89 c7                	mov    %eax,%edi
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	0f 84 b4 00 00 00    	je     80103e80 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103dcc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103dd3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103dd6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103dd9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103de0:	00 00 00 
  p->nwrite = 0;
80103de3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103dea:	00 00 00 
  p->nread = 0;
80103ded:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103df4:	00 00 00 
  initlock(&p->lock, "pipe");
80103df7:	68 7b 80 10 80       	push   $0x8010807b
80103dfc:	50                   	push   %eax
80103dfd:	e8 6e 0f 00 00       	call   80104d70 <initlock>
  (*f0)->type = FD_PIPE;
80103e02:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103e04:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103e07:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e0d:	8b 03                	mov    (%ebx),%eax
80103e0f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e13:	8b 03                	mov    (%ebx),%eax
80103e15:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e19:	8b 03                	mov    (%ebx),%eax
80103e1b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e1e:	8b 06                	mov    (%esi),%eax
80103e20:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103e26:	8b 06                	mov    (%esi),%eax
80103e28:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103e2c:	8b 06                	mov    (%esi),%eax
80103e2e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103e32:	8b 06                	mov    (%esi),%eax
80103e34:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103e3a:	31 c0                	xor    %eax,%eax
}
80103e3c:	5b                   	pop    %ebx
80103e3d:	5e                   	pop    %esi
80103e3e:	5f                   	pop    %edi
80103e3f:	5d                   	pop    %ebp
80103e40:	c3                   	ret    
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103e48:	8b 03                	mov    (%ebx),%eax
80103e4a:	85 c0                	test   %eax,%eax
80103e4c:	74 1e                	je     80103e6c <pipealloc+0xec>
    fileclose(*f0);
80103e4e:	83 ec 0c             	sub    $0xc,%esp
80103e51:	50                   	push   %eax
80103e52:	e8 f9 d9 ff ff       	call   80101850 <fileclose>
80103e57:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103e5a:	8b 06                	mov    (%esi),%eax
80103e5c:	85 c0                	test   %eax,%eax
80103e5e:	74 0c                	je     80103e6c <pipealloc+0xec>
    fileclose(*f1);
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	50                   	push   %eax
80103e64:	e8 e7 d9 ff ff       	call   80101850 <fileclose>
80103e69:	83 c4 10             	add    $0x10,%esp
}
80103e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e74:	5b                   	pop    %ebx
80103e75:	5e                   	pop    %esi
80103e76:	5f                   	pop    %edi
80103e77:	5d                   	pop    %ebp
80103e78:	c3                   	ret    
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103e80:	8b 03                	mov    (%ebx),%eax
80103e82:	85 c0                	test   %eax,%eax
80103e84:	75 c8                	jne    80103e4e <pipealloc+0xce>
80103e86:	eb d2                	jmp    80103e5a <pipealloc+0xda>
80103e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8f:	90                   	nop

80103e90 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	56                   	push   %esi
80103e98:	53                   	push   %ebx
80103e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103e9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103e9f:	83 ec 0c             	sub    $0xc,%esp
80103ea2:	53                   	push   %ebx
80103ea3:	e8 48 10 00 00       	call   80104ef0 <acquire>
  if(writable){
80103ea8:	83 c4 10             	add    $0x10,%esp
80103eab:	85 f6                	test   %esi,%esi
80103ead:	74 41                	je     80103ef0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103eaf:	83 ec 0c             	sub    $0xc,%esp
80103eb2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103eb8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103ebf:	00 00 00 
    wakeup(&p->nread);
80103ec2:	50                   	push   %eax
80103ec3:	e8 a8 0b 00 00       	call   80104a70 <wakeup>
80103ec8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103ecb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103ed1:	85 d2                	test   %edx,%edx
80103ed3:	75 0a                	jne    80103edf <pipeclose+0x4f>
80103ed5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103edb:	85 c0                	test   %eax,%eax
80103edd:	74 31                	je     80103f10 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103edf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103ee2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ee5:	5b                   	pop    %ebx
80103ee6:	5e                   	pop    %esi
80103ee7:	5d                   	pop    %ebp
    release(&p->lock);
80103ee8:	e9 c3 10 00 00       	jmp    80104fb0 <release>
80103eed:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103ef9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103f00:	00 00 00 
    wakeup(&p->nwrite);
80103f03:	50                   	push   %eax
80103f04:	e8 67 0b 00 00       	call   80104a70 <wakeup>
80103f09:	83 c4 10             	add    $0x10,%esp
80103f0c:	eb bd                	jmp    80103ecb <pipeclose+0x3b>
80103f0e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103f10:	83 ec 0c             	sub    $0xc,%esp
80103f13:	53                   	push   %ebx
80103f14:	e8 97 10 00 00       	call   80104fb0 <release>
    kfree((char*)p);
80103f19:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103f1c:	83 c4 10             	add    $0x10,%esp
}
80103f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f22:	5b                   	pop    %ebx
80103f23:	5e                   	pop    %esi
80103f24:	5d                   	pop    %ebp
    kfree((char*)p);
80103f25:	e9 d6 ee ff ff       	jmp    80102e00 <kfree>
80103f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f30 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103f30:	f3 0f 1e fb          	endbr32 
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	57                   	push   %edi
80103f38:	56                   	push   %esi
80103f39:	53                   	push   %ebx
80103f3a:	83 ec 28             	sub    $0x28,%esp
80103f3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103f40:	53                   	push   %ebx
80103f41:	e8 aa 0f 00 00       	call   80104ef0 <acquire>
  for(i = 0; i < n; i++){
80103f46:	8b 45 10             	mov    0x10(%ebp),%eax
80103f49:	83 c4 10             	add    $0x10,%esp
80103f4c:	85 c0                	test   %eax,%eax
80103f4e:	0f 8e bc 00 00 00    	jle    80104010 <pipewrite+0xe0>
80103f54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f57:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103f5d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103f63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f66:	03 45 10             	add    0x10(%ebp),%eax
80103f69:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f6c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f72:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f78:	89 ca                	mov    %ecx,%edx
80103f7a:	05 00 02 00 00       	add    $0x200,%eax
80103f7f:	39 c1                	cmp    %eax,%ecx
80103f81:	74 3b                	je     80103fbe <pipewrite+0x8e>
80103f83:	eb 63                	jmp    80103fe8 <pipewrite+0xb8>
80103f85:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103f88:	e8 63 03 00 00       	call   801042f0 <myproc>
80103f8d:	8b 48 24             	mov    0x24(%eax),%ecx
80103f90:	85 c9                	test   %ecx,%ecx
80103f92:	75 34                	jne    80103fc8 <pipewrite+0x98>
      wakeup(&p->nread);
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	57                   	push   %edi
80103f98:	e8 d3 0a 00 00       	call   80104a70 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f9d:	58                   	pop    %eax
80103f9e:	5a                   	pop    %edx
80103f9f:	53                   	push   %ebx
80103fa0:	56                   	push   %esi
80103fa1:	e8 0a 09 00 00       	call   801048b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103fa6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103fac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103fb2:	83 c4 10             	add    $0x10,%esp
80103fb5:	05 00 02 00 00       	add    $0x200,%eax
80103fba:	39 c2                	cmp    %eax,%edx
80103fbc:	75 2a                	jne    80103fe8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103fbe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103fc4:	85 c0                	test   %eax,%eax
80103fc6:	75 c0                	jne    80103f88 <pipewrite+0x58>
        release(&p->lock);
80103fc8:	83 ec 0c             	sub    $0xc,%esp
80103fcb:	53                   	push   %ebx
80103fcc:	e8 df 0f 00 00       	call   80104fb0 <release>
        return -1;
80103fd1:	83 c4 10             	add    $0x10,%esp
80103fd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fdc:	5b                   	pop    %ebx
80103fdd:	5e                   	pop    %esi
80103fde:	5f                   	pop    %edi
80103fdf:	5d                   	pop    %ebp
80103fe0:	c3                   	ret    
80103fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103fe8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103feb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103fee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103ff4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103ffa:	0f b6 06             	movzbl (%esi),%eax
80103ffd:	83 c6 01             	add    $0x1,%esi
80104000:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80104003:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104007:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010400a:	0f 85 5c ff ff ff    	jne    80103f6c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104010:	83 ec 0c             	sub    $0xc,%esp
80104013:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104019:	50                   	push   %eax
8010401a:	e8 51 0a 00 00       	call   80104a70 <wakeup>
  release(&p->lock);
8010401f:	89 1c 24             	mov    %ebx,(%esp)
80104022:	e8 89 0f 00 00       	call   80104fb0 <release>
  return n;
80104027:	8b 45 10             	mov    0x10(%ebp),%eax
8010402a:	83 c4 10             	add    $0x10,%esp
8010402d:	eb aa                	jmp    80103fd9 <pipewrite+0xa9>
8010402f:	90                   	nop

80104030 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104030:	f3 0f 1e fb          	endbr32 
80104034:	55                   	push   %ebp
80104035:	89 e5                	mov    %esp,%ebp
80104037:	57                   	push   %edi
80104038:	56                   	push   %esi
80104039:	53                   	push   %ebx
8010403a:	83 ec 18             	sub    $0x18,%esp
8010403d:	8b 75 08             	mov    0x8(%ebp),%esi
80104040:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104043:	56                   	push   %esi
80104044:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010404a:	e8 a1 0e 00 00       	call   80104ef0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010404f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104055:	83 c4 10             	add    $0x10,%esp
80104058:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010405e:	74 33                	je     80104093 <piperead+0x63>
80104060:	eb 3b                	jmp    8010409d <piperead+0x6d>
80104062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80104068:	e8 83 02 00 00       	call   801042f0 <myproc>
8010406d:	8b 48 24             	mov    0x24(%eax),%ecx
80104070:	85 c9                	test   %ecx,%ecx
80104072:	0f 85 88 00 00 00    	jne    80104100 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104078:	83 ec 08             	sub    $0x8,%esp
8010407b:	56                   	push   %esi
8010407c:	53                   	push   %ebx
8010407d:	e8 2e 08 00 00       	call   801048b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104082:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104088:	83 c4 10             	add    $0x10,%esp
8010408b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104091:	75 0a                	jne    8010409d <piperead+0x6d>
80104093:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104099:	85 c0                	test   %eax,%eax
8010409b:	75 cb                	jne    80104068 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010409d:	8b 55 10             	mov    0x10(%ebp),%edx
801040a0:	31 db                	xor    %ebx,%ebx
801040a2:	85 d2                	test   %edx,%edx
801040a4:	7f 28                	jg     801040ce <piperead+0x9e>
801040a6:	eb 34                	jmp    801040dc <piperead+0xac>
801040a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801040b0:	8d 48 01             	lea    0x1(%eax),%ecx
801040b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801040b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801040be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801040c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801040c6:	83 c3 01             	add    $0x1,%ebx
801040c9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801040cc:	74 0e                	je     801040dc <piperead+0xac>
    if(p->nread == p->nwrite)
801040ce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801040d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801040da:	75 d4                	jne    801040b0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801040dc:	83 ec 0c             	sub    $0xc,%esp
801040df:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801040e5:	50                   	push   %eax
801040e6:	e8 85 09 00 00       	call   80104a70 <wakeup>
  release(&p->lock);
801040eb:	89 34 24             	mov    %esi,(%esp)
801040ee:	e8 bd 0e 00 00       	call   80104fb0 <release>
  return i;
801040f3:	83 c4 10             	add    $0x10,%esp
}
801040f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f9:	89 d8                	mov    %ebx,%eax
801040fb:	5b                   	pop    %ebx
801040fc:	5e                   	pop    %esi
801040fd:	5f                   	pop    %edi
801040fe:	5d                   	pop    %ebp
801040ff:	c3                   	ret    
      release(&p->lock);
80104100:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104103:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104108:	56                   	push   %esi
80104109:	e8 a2 0e 00 00       	call   80104fb0 <release>
      return -1;
8010410e:	83 c4 10             	add    $0x10,%esp
}
80104111:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104114:	89 d8                	mov    %ebx,%eax
80104116:	5b                   	pop    %ebx
80104117:	5e                   	pop    %esi
80104118:	5f                   	pop    %edi
80104119:	5d                   	pop    %ebp
8010411a:	c3                   	ret    
8010411b:	66 90                	xchg   %ax,%ax
8010411d:	66 90                	xchg   %ax,%ax
8010411f:	90                   	nop

80104120 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104124:	bb 54 47 11 80       	mov    $0x80114754,%ebx
{
80104129:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010412c:	68 20 47 11 80       	push   $0x80114720
80104131:	e8 ba 0d 00 00       	call   80104ef0 <acquire>
80104136:	83 c4 10             	add    $0x10,%esp
80104139:	eb 10                	jmp    8010414b <allocproc+0x2b>
8010413b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104140:	83 c3 7c             	add    $0x7c,%ebx
80104143:	81 fb 54 66 11 80    	cmp    $0x80116654,%ebx
80104149:	74 75                	je     801041c0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010414b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010414e:	85 c0                	test   %eax,%eax
80104150:	75 ee                	jne    80104140 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104152:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104157:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010415a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104161:	89 43 10             	mov    %eax,0x10(%ebx)
80104164:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104167:	68 20 47 11 80       	push   $0x80114720
  p->pid = nextpid++;
8010416c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104172:	e8 39 0e 00 00       	call   80104fb0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104177:	e8 44 ee ff ff       	call   80102fc0 <kalloc>
8010417c:	83 c4 10             	add    $0x10,%esp
8010417f:	89 43 08             	mov    %eax,0x8(%ebx)
80104182:	85 c0                	test   %eax,%eax
80104184:	74 53                	je     801041d9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104186:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010418c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010418f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104194:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104197:	c7 40 14 9c 62 10 80 	movl   $0x8010629c,0x14(%eax)
  p->context = (struct context*)sp;
8010419e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801041a1:	6a 14                	push   $0x14
801041a3:	6a 00                	push   $0x0
801041a5:	50                   	push   %eax
801041a6:	e8 55 0e 00 00       	call   80105000 <memset>
  p->context->eip = (uint)forkret;
801041ab:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801041ae:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801041b1:	c7 40 10 f0 41 10 80 	movl   $0x801041f0,0x10(%eax)
}
801041b8:	89 d8                	mov    %ebx,%eax
801041ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041bd:	c9                   	leave  
801041be:	c3                   	ret    
801041bf:	90                   	nop
  release(&ptable.lock);
801041c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801041c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801041c5:	68 20 47 11 80       	push   $0x80114720
801041ca:	e8 e1 0d 00 00       	call   80104fb0 <release>
}
801041cf:	89 d8                	mov    %ebx,%eax
  return 0;
801041d1:	83 c4 10             	add    $0x10,%esp
}
801041d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d7:	c9                   	leave  
801041d8:	c3                   	ret    
    p->state = UNUSED;
801041d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801041e0:	31 db                	xor    %ebx,%ebx
}
801041e2:	89 d8                	mov    %ebx,%eax
801041e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e7:	c9                   	leave  
801041e8:	c3                   	ret    
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801041fa:	68 20 47 11 80       	push   $0x80114720
801041ff:	e8 ac 0d 00 00       	call   80104fb0 <release>

  if (first) {
80104204:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104209:	83 c4 10             	add    $0x10,%esp
8010420c:	85 c0                	test   %eax,%eax
8010420e:	75 08                	jne    80104218 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104210:	c9                   	leave  
80104211:	c3                   	ret    
80104212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104218:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010421f:	00 00 00 
    iinit(ROOTDEV);
80104222:	83 ec 0c             	sub    $0xc,%esp
80104225:	6a 01                	push   $0x1
80104227:	e8 a4 dc ff ff       	call   80101ed0 <iinit>
    initlog(ROOTDEV);
8010422c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104233:	e8 e8 f3 ff ff       	call   80103620 <initlog>
}
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	c9                   	leave  
8010423c:	c3                   	ret    
8010423d:	8d 76 00             	lea    0x0(%esi),%esi

80104240 <pinit>:
{
80104240:	f3 0f 1e fb          	endbr32 
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010424a:	68 80 80 10 80       	push   $0x80108080
8010424f:	68 20 47 11 80       	push   $0x80114720
80104254:	e8 17 0b 00 00       	call   80104d70 <initlock>
}
80104259:	83 c4 10             	add    $0x10,%esp
8010425c:	c9                   	leave  
8010425d:	c3                   	ret    
8010425e:	66 90                	xchg   %ax,%ax

80104260 <mycpu>:
{
80104260:	f3 0f 1e fb          	endbr32 
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
80104267:	56                   	push   %esi
80104268:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104269:	9c                   	pushf  
8010426a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010426b:	f6 c4 02             	test   $0x2,%ah
8010426e:	75 4a                	jne    801042ba <mycpu+0x5a>
  apicid = lapicid();
80104270:	e8 bb ef ff ff       	call   80103230 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104275:	8b 35 00 47 11 80    	mov    0x80114700,%esi
  apicid = lapicid();
8010427b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010427d:	85 f6                	test   %esi,%esi
8010427f:	7e 2c                	jle    801042ad <mycpu+0x4d>
80104281:	31 d2                	xor    %edx,%edx
80104283:	eb 0a                	jmp    8010428f <mycpu+0x2f>
80104285:	8d 76 00             	lea    0x0(%esi),%esi
80104288:	83 c2 01             	add    $0x1,%edx
8010428b:	39 f2                	cmp    %esi,%edx
8010428d:	74 1e                	je     801042ad <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010428f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104295:	0f b6 81 80 41 11 80 	movzbl -0x7feebe80(%ecx),%eax
8010429c:	39 d8                	cmp    %ebx,%eax
8010429e:	75 e8                	jne    80104288 <mycpu+0x28>
}
801042a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801042a3:	8d 81 80 41 11 80    	lea    -0x7feebe80(%ecx),%eax
}
801042a9:	5b                   	pop    %ebx
801042aa:	5e                   	pop    %esi
801042ab:	5d                   	pop    %ebp
801042ac:	c3                   	ret    
  panic("unknown apicid\n");
801042ad:	83 ec 0c             	sub    $0xc,%esp
801042b0:	68 87 80 10 80       	push   $0x80108087
801042b5:	e8 d6 c0 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	68 64 81 10 80       	push   $0x80108164
801042c2:	e8 c9 c0 ff ff       	call   80100390 <panic>
801042c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ce:	66 90                	xchg   %ax,%ax

801042d0 <cpuid>:
cpuid() {
801042d0:	f3 0f 1e fb          	endbr32 
801042d4:	55                   	push   %ebp
801042d5:	89 e5                	mov    %esp,%ebp
801042d7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801042da:	e8 81 ff ff ff       	call   80104260 <mycpu>
}
801042df:	c9                   	leave  
  return mycpu()-cpus;
801042e0:	2d 80 41 11 80       	sub    $0x80114180,%eax
801042e5:	c1 f8 04             	sar    $0x4,%eax
801042e8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042ee:	c3                   	ret    
801042ef:	90                   	nop

801042f0 <myproc>:
myproc(void) {
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	53                   	push   %ebx
801042f8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042fb:	e8 f0 0a 00 00       	call   80104df0 <pushcli>
  c = mycpu();
80104300:	e8 5b ff ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104305:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010430b:	e8 30 0b 00 00       	call   80104e40 <popcli>
}
80104310:	83 c4 04             	add    $0x4,%esp
80104313:	89 d8                	mov    %ebx,%eax
80104315:	5b                   	pop    %ebx
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
80104318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop

80104320 <userinit>:
{
80104320:	f3 0f 1e fb          	endbr32 
80104324:	55                   	push   %ebp
80104325:	89 e5                	mov    %esp,%ebp
80104327:	53                   	push   %ebx
80104328:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010432b:	e8 f0 fd ff ff       	call   80104120 <allocproc>
80104330:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104332:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104337:	e8 24 35 00 00       	call   80107860 <setupkvm>
8010433c:	89 43 04             	mov    %eax,0x4(%ebx)
8010433f:	85 c0                	test   %eax,%eax
80104341:	0f 84 bd 00 00 00    	je     80104404 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104347:	83 ec 04             	sub    $0x4,%esp
8010434a:	68 2c 00 00 00       	push   $0x2c
8010434f:	68 60 b4 10 80       	push   $0x8010b460
80104354:	50                   	push   %eax
80104355:	e8 d6 31 00 00       	call   80107530 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010435a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010435d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104363:	6a 4c                	push   $0x4c
80104365:	6a 00                	push   $0x0
80104367:	ff 73 18             	pushl  0x18(%ebx)
8010436a:	e8 91 0c 00 00       	call   80105000 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010436f:	8b 43 18             	mov    0x18(%ebx),%eax
80104372:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104377:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010437a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010437f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104383:	8b 43 18             	mov    0x18(%ebx),%eax
80104386:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010438a:	8b 43 18             	mov    0x18(%ebx),%eax
8010438d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104391:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104395:	8b 43 18             	mov    0x18(%ebx),%eax
80104398:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010439c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801043a0:	8b 43 18             	mov    0x18(%ebx),%eax
801043a3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801043aa:	8b 43 18             	mov    0x18(%ebx),%eax
801043ad:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043b4:	8b 43 18             	mov    0x18(%ebx),%eax
801043b7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801043be:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043c1:	6a 10                	push   $0x10
801043c3:	68 b0 80 10 80       	push   $0x801080b0
801043c8:	50                   	push   %eax
801043c9:	e8 f2 0d 00 00       	call   801051c0 <safestrcpy>
  p->cwd = namei("/");
801043ce:	c7 04 24 b9 80 10 80 	movl   $0x801080b9,(%esp)
801043d5:	e8 e6 e5 ff ff       	call   801029c0 <namei>
801043da:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043dd:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
801043e4:	e8 07 0b 00 00       	call   80104ef0 <acquire>
  p->state = RUNNABLE;
801043e9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043f0:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
801043f7:	e8 b4 0b 00 00       	call   80104fb0 <release>
}
801043fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ff:	83 c4 10             	add    $0x10,%esp
80104402:	c9                   	leave  
80104403:	c3                   	ret    
    panic("userinit: out of memory?");
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	68 97 80 10 80       	push   $0x80108097
8010440c:	e8 7f bf ff ff       	call   80100390 <panic>
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441f:	90                   	nop

80104420 <growproc>:
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	56                   	push   %esi
80104428:	53                   	push   %ebx
80104429:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010442c:	e8 bf 09 00 00       	call   80104df0 <pushcli>
  c = mycpu();
80104431:	e8 2a fe ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104436:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010443c:	e8 ff 09 00 00       	call   80104e40 <popcli>
  sz = curproc->sz;
80104441:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104443:	85 f6                	test   %esi,%esi
80104445:	7f 19                	jg     80104460 <growproc+0x40>
  } else if(n < 0){
80104447:	75 37                	jne    80104480 <growproc+0x60>
  switchuvm(curproc);
80104449:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010444c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010444e:	53                   	push   %ebx
8010444f:	e8 cc 2f 00 00       	call   80107420 <switchuvm>
  return 0;
80104454:	83 c4 10             	add    $0x10,%esp
80104457:	31 c0                	xor    %eax,%eax
}
80104459:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445c:	5b                   	pop    %ebx
8010445d:	5e                   	pop    %esi
8010445e:	5d                   	pop    %ebp
8010445f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104460:	83 ec 04             	sub    $0x4,%esp
80104463:	01 c6                	add    %eax,%esi
80104465:	56                   	push   %esi
80104466:	50                   	push   %eax
80104467:	ff 73 04             	pushl  0x4(%ebx)
8010446a:	e8 11 32 00 00       	call   80107680 <allocuvm>
8010446f:	83 c4 10             	add    $0x10,%esp
80104472:	85 c0                	test   %eax,%eax
80104474:	75 d3                	jne    80104449 <growproc+0x29>
      return -1;
80104476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010447b:	eb dc                	jmp    80104459 <growproc+0x39>
8010447d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104480:	83 ec 04             	sub    $0x4,%esp
80104483:	01 c6                	add    %eax,%esi
80104485:	56                   	push   %esi
80104486:	50                   	push   %eax
80104487:	ff 73 04             	pushl  0x4(%ebx)
8010448a:	e8 21 33 00 00       	call   801077b0 <deallocuvm>
8010448f:	83 c4 10             	add    $0x10,%esp
80104492:	85 c0                	test   %eax,%eax
80104494:	75 b3                	jne    80104449 <growproc+0x29>
80104496:	eb de                	jmp    80104476 <growproc+0x56>
80104498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449f:	90                   	nop

801044a0 <fork>:
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	57                   	push   %edi
801044a8:	56                   	push   %esi
801044a9:	53                   	push   %ebx
801044aa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801044ad:	e8 3e 09 00 00       	call   80104df0 <pushcli>
  c = mycpu();
801044b2:	e8 a9 fd ff ff       	call   80104260 <mycpu>
  p = c->proc;
801044b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044bd:	e8 7e 09 00 00       	call   80104e40 <popcli>
  if((np = allocproc()) == 0){
801044c2:	e8 59 fc ff ff       	call   80104120 <allocproc>
801044c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801044ca:	85 c0                	test   %eax,%eax
801044cc:	0f 84 bb 00 00 00    	je     8010458d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801044d2:	83 ec 08             	sub    $0x8,%esp
801044d5:	ff 33                	pushl  (%ebx)
801044d7:	89 c7                	mov    %eax,%edi
801044d9:	ff 73 04             	pushl  0x4(%ebx)
801044dc:	e8 4f 34 00 00       	call   80107930 <copyuvm>
801044e1:	83 c4 10             	add    $0x10,%esp
801044e4:	89 47 04             	mov    %eax,0x4(%edi)
801044e7:	85 c0                	test   %eax,%eax
801044e9:	0f 84 a5 00 00 00    	je     80104594 <fork+0xf4>
  np->sz = curproc->sz;
801044ef:	8b 03                	mov    (%ebx),%eax
801044f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801044f4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801044f6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801044f9:	89 c8                	mov    %ecx,%eax
801044fb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801044fe:	b9 13 00 00 00       	mov    $0x13,%ecx
80104503:	8b 73 18             	mov    0x18(%ebx),%esi
80104506:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104508:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010450a:	8b 40 18             	mov    0x18(%eax),%eax
8010450d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104518:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010451c:	85 c0                	test   %eax,%eax
8010451e:	74 13                	je     80104533 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	50                   	push   %eax
80104524:	e8 d7 d2 ff ff       	call   80101800 <filedup>
80104529:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010452c:	83 c4 10             	add    $0x10,%esp
8010452f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104533:	83 c6 01             	add    $0x1,%esi
80104536:	83 fe 10             	cmp    $0x10,%esi
80104539:	75 dd                	jne    80104518 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104541:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104544:	e8 77 db ff ff       	call   801020c0 <idup>
80104549:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010454c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010454f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104552:	8d 47 6c             	lea    0x6c(%edi),%eax
80104555:	6a 10                	push   $0x10
80104557:	53                   	push   %ebx
80104558:	50                   	push   %eax
80104559:	e8 62 0c 00 00       	call   801051c0 <safestrcpy>
  pid = np->pid;
8010455e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104561:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80104568:	e8 83 09 00 00       	call   80104ef0 <acquire>
  np->state = RUNNABLE;
8010456d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104574:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
8010457b:	e8 30 0a 00 00       	call   80104fb0 <release>
  return pid;
80104580:	83 c4 10             	add    $0x10,%esp
}
80104583:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104586:	89 d8                	mov    %ebx,%eax
80104588:	5b                   	pop    %ebx
80104589:	5e                   	pop    %esi
8010458a:	5f                   	pop    %edi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret    
    return -1;
8010458d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104592:	eb ef                	jmp    80104583 <fork+0xe3>
    kfree(np->kstack);
80104594:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104597:	83 ec 0c             	sub    $0xc,%esp
8010459a:	ff 73 08             	pushl  0x8(%ebx)
8010459d:	e8 5e e8 ff ff       	call   80102e00 <kfree>
    np->kstack = 0;
801045a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801045a9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801045ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801045b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801045b8:	eb c9                	jmp    80104583 <fork+0xe3>
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <scheduler>:
{
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	57                   	push   %edi
801045c8:	56                   	push   %esi
801045c9:	53                   	push   %ebx
801045ca:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801045cd:	e8 8e fc ff ff       	call   80104260 <mycpu>
  c->proc = 0;
801045d2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801045d9:	00 00 00 
  struct cpu *c = mycpu();
801045dc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801045de:	8d 78 04             	lea    0x4(%eax),%edi
801045e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801045e8:	fb                   	sti    
    acquire(&ptable.lock);
801045e9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ec:	bb 54 47 11 80       	mov    $0x80114754,%ebx
    acquire(&ptable.lock);
801045f1:	68 20 47 11 80       	push   $0x80114720
801045f6:	e8 f5 08 00 00       	call   80104ef0 <acquire>
801045fb:	83 c4 10             	add    $0x10,%esp
801045fe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104600:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104604:	75 33                	jne    80104639 <scheduler+0x79>
      switchuvm(p);
80104606:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104609:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010460f:	53                   	push   %ebx
80104610:	e8 0b 2e 00 00       	call   80107420 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104615:	58                   	pop    %eax
80104616:	5a                   	pop    %edx
80104617:	ff 73 1c             	pushl  0x1c(%ebx)
8010461a:	57                   	push   %edi
      p->state = RUNNING;
8010461b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104622:	e8 fc 0b 00 00       	call   80105223 <swtch>
      switchkvm();
80104627:	e8 d4 2d 00 00       	call   80107400 <switchkvm>
      c->proc = 0;
8010462c:	83 c4 10             	add    $0x10,%esp
8010462f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104636:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104639:	83 c3 7c             	add    $0x7c,%ebx
8010463c:	81 fb 54 66 11 80    	cmp    $0x80116654,%ebx
80104642:	75 bc                	jne    80104600 <scheduler+0x40>
    release(&ptable.lock);
80104644:	83 ec 0c             	sub    $0xc,%esp
80104647:	68 20 47 11 80       	push   $0x80114720
8010464c:	e8 5f 09 00 00       	call   80104fb0 <release>
    sti();
80104651:	83 c4 10             	add    $0x10,%esp
80104654:	eb 92                	jmp    801045e8 <scheduler+0x28>
80104656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465d:	8d 76 00             	lea    0x0(%esi),%esi

80104660 <sched>:
{
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	56                   	push   %esi
80104668:	53                   	push   %ebx
  pushcli();
80104669:	e8 82 07 00 00       	call   80104df0 <pushcli>
  c = mycpu();
8010466e:	e8 ed fb ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104673:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104679:	e8 c2 07 00 00       	call   80104e40 <popcli>
  if(!holding(&ptable.lock))
8010467e:	83 ec 0c             	sub    $0xc,%esp
80104681:	68 20 47 11 80       	push   $0x80114720
80104686:	e8 15 08 00 00       	call   80104ea0 <holding>
8010468b:	83 c4 10             	add    $0x10,%esp
8010468e:	85 c0                	test   %eax,%eax
80104690:	74 4f                	je     801046e1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104692:	e8 c9 fb ff ff       	call   80104260 <mycpu>
80104697:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010469e:	75 68                	jne    80104708 <sched+0xa8>
  if(p->state == RUNNING)
801046a0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801046a4:	74 55                	je     801046fb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046a6:	9c                   	pushf  
801046a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046a8:	f6 c4 02             	test   $0x2,%ah
801046ab:	75 41                	jne    801046ee <sched+0x8e>
  intena = mycpu()->intena;
801046ad:	e8 ae fb ff ff       	call   80104260 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801046b2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801046b5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801046bb:	e8 a0 fb ff ff       	call   80104260 <mycpu>
801046c0:	83 ec 08             	sub    $0x8,%esp
801046c3:	ff 70 04             	pushl  0x4(%eax)
801046c6:	53                   	push   %ebx
801046c7:	e8 57 0b 00 00       	call   80105223 <swtch>
  mycpu()->intena = intena;
801046cc:	e8 8f fb ff ff       	call   80104260 <mycpu>
}
801046d1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801046d4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801046da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046dd:	5b                   	pop    %ebx
801046de:	5e                   	pop    %esi
801046df:	5d                   	pop    %ebp
801046e0:	c3                   	ret    
    panic("sched ptable.lock");
801046e1:	83 ec 0c             	sub    $0xc,%esp
801046e4:	68 bb 80 10 80       	push   $0x801080bb
801046e9:	e8 a2 bc ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801046ee:	83 ec 0c             	sub    $0xc,%esp
801046f1:	68 e7 80 10 80       	push   $0x801080e7
801046f6:	e8 95 bc ff ff       	call   80100390 <panic>
    panic("sched running");
801046fb:	83 ec 0c             	sub    $0xc,%esp
801046fe:	68 d9 80 10 80       	push   $0x801080d9
80104703:	e8 88 bc ff ff       	call   80100390 <panic>
    panic("sched locks");
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	68 cd 80 10 80       	push   $0x801080cd
80104710:	e8 7b bc ff ff       	call   80100390 <panic>
80104715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <exit>:
{
80104720:	f3 0f 1e fb          	endbr32 
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	57                   	push   %edi
80104728:	56                   	push   %esi
80104729:	53                   	push   %ebx
8010472a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010472d:	e8 be 06 00 00       	call   80104df0 <pushcli>
  c = mycpu();
80104732:	e8 29 fb ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104737:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010473d:	e8 fe 06 00 00       	call   80104e40 <popcli>
  if(curproc == initproc)
80104742:	8d 5e 28             	lea    0x28(%esi),%ebx
80104745:	8d 7e 68             	lea    0x68(%esi),%edi
80104748:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010474e:	0f 84 f3 00 00 00    	je     80104847 <exit+0x127>
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104758:	8b 03                	mov    (%ebx),%eax
8010475a:	85 c0                	test   %eax,%eax
8010475c:	74 12                	je     80104770 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010475e:	83 ec 0c             	sub    $0xc,%esp
80104761:	50                   	push   %eax
80104762:	e8 e9 d0 ff ff       	call   80101850 <fileclose>
      curproc->ofile[fd] = 0;
80104767:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010476d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104770:	83 c3 04             	add    $0x4,%ebx
80104773:	39 df                	cmp    %ebx,%edi
80104775:	75 e1                	jne    80104758 <exit+0x38>
  begin_op();
80104777:	e8 44 ef ff ff       	call   801036c0 <begin_op>
  iput(curproc->cwd);
8010477c:	83 ec 0c             	sub    $0xc,%esp
8010477f:	ff 76 68             	pushl  0x68(%esi)
80104782:	e8 99 da ff ff       	call   80102220 <iput>
  end_op();
80104787:	e8 a4 ef ff ff       	call   80103730 <end_op>
  curproc->cwd = 0;
8010478c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104793:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
8010479a:	e8 51 07 00 00       	call   80104ef0 <acquire>
  wakeup1(curproc->parent);
8010479f:	8b 56 14             	mov    0x14(%esi),%edx
801047a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047a5:	b8 54 47 11 80       	mov    $0x80114754,%eax
801047aa:	eb 0e                	jmp    801047ba <exit+0x9a>
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047b0:	83 c0 7c             	add    $0x7c,%eax
801047b3:	3d 54 66 11 80       	cmp    $0x80116654,%eax
801047b8:	74 1c                	je     801047d6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801047ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047be:	75 f0                	jne    801047b0 <exit+0x90>
801047c0:	3b 50 20             	cmp    0x20(%eax),%edx
801047c3:	75 eb                	jne    801047b0 <exit+0x90>
      p->state = RUNNABLE;
801047c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047cc:	83 c0 7c             	add    $0x7c,%eax
801047cf:	3d 54 66 11 80       	cmp    $0x80116654,%eax
801047d4:	75 e4                	jne    801047ba <exit+0x9a>
      p->parent = initproc;
801047d6:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047dc:	ba 54 47 11 80       	mov    $0x80114754,%edx
801047e1:	eb 10                	jmp    801047f3 <exit+0xd3>
801047e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e7:	90                   	nop
801047e8:	83 c2 7c             	add    $0x7c,%edx
801047eb:	81 fa 54 66 11 80    	cmp    $0x80116654,%edx
801047f1:	74 3b                	je     8010482e <exit+0x10e>
    if(p->parent == curproc){
801047f3:	39 72 14             	cmp    %esi,0x14(%edx)
801047f6:	75 f0                	jne    801047e8 <exit+0xc8>
      if(p->state == ZOMBIE)
801047f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801047fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801047ff:	75 e7                	jne    801047e8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104801:	b8 54 47 11 80       	mov    $0x80114754,%eax
80104806:	eb 12                	jmp    8010481a <exit+0xfa>
80104808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480f:	90                   	nop
80104810:	83 c0 7c             	add    $0x7c,%eax
80104813:	3d 54 66 11 80       	cmp    $0x80116654,%eax
80104818:	74 ce                	je     801047e8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010481a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010481e:	75 f0                	jne    80104810 <exit+0xf0>
80104820:	3b 48 20             	cmp    0x20(%eax),%ecx
80104823:	75 eb                	jne    80104810 <exit+0xf0>
      p->state = RUNNABLE;
80104825:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010482c:	eb e2                	jmp    80104810 <exit+0xf0>
  curproc->state = ZOMBIE;
8010482e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104835:	e8 26 fe ff ff       	call   80104660 <sched>
  panic("zombie exit");
8010483a:	83 ec 0c             	sub    $0xc,%esp
8010483d:	68 08 81 10 80       	push   $0x80108108
80104842:	e8 49 bb ff ff       	call   80100390 <panic>
    panic("init exiting");
80104847:	83 ec 0c             	sub    $0xc,%esp
8010484a:	68 fb 80 10 80       	push   $0x801080fb
8010484f:	e8 3c bb ff ff       	call   80100390 <panic>
80104854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010485f:	90                   	nop

80104860 <yield>:
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	53                   	push   %ebx
80104868:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010486b:	68 20 47 11 80       	push   $0x80114720
80104870:	e8 7b 06 00 00       	call   80104ef0 <acquire>
  pushcli();
80104875:	e8 76 05 00 00       	call   80104df0 <pushcli>
  c = mycpu();
8010487a:	e8 e1 f9 ff ff       	call   80104260 <mycpu>
  p = c->proc;
8010487f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104885:	e8 b6 05 00 00       	call   80104e40 <popcli>
  myproc()->state = RUNNABLE;
8010488a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104891:	e8 ca fd ff ff       	call   80104660 <sched>
  release(&ptable.lock);
80104896:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
8010489d:	e8 0e 07 00 00       	call   80104fb0 <release>
}
801048a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048a5:	83 c4 10             	add    $0x10,%esp
801048a8:	c9                   	leave  
801048a9:	c3                   	ret    
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <sleep>:
{
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	57                   	push   %edi
801048b8:	56                   	push   %esi
801048b9:	53                   	push   %ebx
801048ba:	83 ec 0c             	sub    $0xc,%esp
801048bd:	8b 7d 08             	mov    0x8(%ebp),%edi
801048c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801048c3:	e8 28 05 00 00       	call   80104df0 <pushcli>
  c = mycpu();
801048c8:	e8 93 f9 ff ff       	call   80104260 <mycpu>
  p = c->proc;
801048cd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048d3:	e8 68 05 00 00       	call   80104e40 <popcli>
  if(p == 0)
801048d8:	85 db                	test   %ebx,%ebx
801048da:	0f 84 83 00 00 00    	je     80104963 <sleep+0xb3>
  if(lk == 0)
801048e0:	85 f6                	test   %esi,%esi
801048e2:	74 72                	je     80104956 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801048e4:	81 fe 20 47 11 80    	cmp    $0x80114720,%esi
801048ea:	74 4c                	je     80104938 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801048ec:	83 ec 0c             	sub    $0xc,%esp
801048ef:	68 20 47 11 80       	push   $0x80114720
801048f4:	e8 f7 05 00 00       	call   80104ef0 <acquire>
    release(lk);
801048f9:	89 34 24             	mov    %esi,(%esp)
801048fc:	e8 af 06 00 00       	call   80104fb0 <release>
  p->chan = chan;
80104901:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104904:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010490b:	e8 50 fd ff ff       	call   80104660 <sched>
  p->chan = 0;
80104910:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104917:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
8010491e:	e8 8d 06 00 00       	call   80104fb0 <release>
    acquire(lk);
80104923:	89 75 08             	mov    %esi,0x8(%ebp)
80104926:	83 c4 10             	add    $0x10,%esp
}
80104929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010492c:	5b                   	pop    %ebx
8010492d:	5e                   	pop    %esi
8010492e:	5f                   	pop    %edi
8010492f:	5d                   	pop    %ebp
    acquire(lk);
80104930:	e9 bb 05 00 00       	jmp    80104ef0 <acquire>
80104935:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104938:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010493b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104942:	e8 19 fd ff ff       	call   80104660 <sched>
  p->chan = 0;
80104947:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010494e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104951:	5b                   	pop    %ebx
80104952:	5e                   	pop    %esi
80104953:	5f                   	pop    %edi
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
    panic("sleep without lk");
80104956:	83 ec 0c             	sub    $0xc,%esp
80104959:	68 1a 81 10 80       	push   $0x8010811a
8010495e:	e8 2d ba ff ff       	call   80100390 <panic>
    panic("sleep");
80104963:	83 ec 0c             	sub    $0xc,%esp
80104966:	68 14 81 10 80       	push   $0x80108114
8010496b:	e8 20 ba ff ff       	call   80100390 <panic>

80104970 <wait>:
{
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	56                   	push   %esi
80104978:	53                   	push   %ebx
  pushcli();
80104979:	e8 72 04 00 00       	call   80104df0 <pushcli>
  c = mycpu();
8010497e:	e8 dd f8 ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104983:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104989:	e8 b2 04 00 00       	call   80104e40 <popcli>
  acquire(&ptable.lock);
8010498e:	83 ec 0c             	sub    $0xc,%esp
80104991:	68 20 47 11 80       	push   $0x80114720
80104996:	e8 55 05 00 00       	call   80104ef0 <acquire>
8010499b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010499e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a0:	bb 54 47 11 80       	mov    $0x80114754,%ebx
801049a5:	eb 14                	jmp    801049bb <wait+0x4b>
801049a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ae:	66 90                	xchg   %ax,%ax
801049b0:	83 c3 7c             	add    $0x7c,%ebx
801049b3:	81 fb 54 66 11 80    	cmp    $0x80116654,%ebx
801049b9:	74 1b                	je     801049d6 <wait+0x66>
      if(p->parent != curproc)
801049bb:	39 73 14             	cmp    %esi,0x14(%ebx)
801049be:	75 f0                	jne    801049b0 <wait+0x40>
      if(p->state == ZOMBIE){
801049c0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801049c4:	74 32                	je     801049f8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049c6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801049c9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049ce:	81 fb 54 66 11 80    	cmp    $0x80116654,%ebx
801049d4:	75 e5                	jne    801049bb <wait+0x4b>
    if(!havekids || curproc->killed){
801049d6:	85 c0                	test   %eax,%eax
801049d8:	74 74                	je     80104a4e <wait+0xde>
801049da:	8b 46 24             	mov    0x24(%esi),%eax
801049dd:	85 c0                	test   %eax,%eax
801049df:	75 6d                	jne    80104a4e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801049e1:	83 ec 08             	sub    $0x8,%esp
801049e4:	68 20 47 11 80       	push   $0x80114720
801049e9:	56                   	push   %esi
801049ea:	e8 c1 fe ff ff       	call   801048b0 <sleep>
    havekids = 0;
801049ef:	83 c4 10             	add    $0x10,%esp
801049f2:	eb aa                	jmp    8010499e <wait+0x2e>
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801049f8:	83 ec 0c             	sub    $0xc,%esp
801049fb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801049fe:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a01:	e8 fa e3 ff ff       	call   80102e00 <kfree>
        freevm(p->pgdir);
80104a06:	5a                   	pop    %edx
80104a07:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a11:	e8 ca 2d 00 00       	call   801077e0 <freevm>
        release(&ptable.lock);
80104a16:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
        p->pid = 0;
80104a1d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a24:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a2b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a2f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a36:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a3d:	e8 6e 05 00 00       	call   80104fb0 <release>
        return pid;
80104a42:	83 c4 10             	add    $0x10,%esp
}
80104a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a48:	89 f0                	mov    %esi,%eax
80104a4a:	5b                   	pop    %ebx
80104a4b:	5e                   	pop    %esi
80104a4c:	5d                   	pop    %ebp
80104a4d:	c3                   	ret    
      release(&ptable.lock);
80104a4e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a51:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a56:	68 20 47 11 80       	push   $0x80114720
80104a5b:	e8 50 05 00 00       	call   80104fb0 <release>
      return -1;
80104a60:	83 c4 10             	add    $0x10,%esp
80104a63:	eb e0                	jmp    80104a45 <wait+0xd5>
80104a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	53                   	push   %ebx
80104a78:	83 ec 10             	sub    $0x10,%esp
80104a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104a7e:	68 20 47 11 80       	push   $0x80114720
80104a83:	e8 68 04 00 00       	call   80104ef0 <acquire>
80104a88:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a8b:	b8 54 47 11 80       	mov    $0x80114754,%eax
80104a90:	eb 10                	jmp    80104aa2 <wakeup+0x32>
80104a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a98:	83 c0 7c             	add    $0x7c,%eax
80104a9b:	3d 54 66 11 80       	cmp    $0x80116654,%eax
80104aa0:	74 1c                	je     80104abe <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104aa2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104aa6:	75 f0                	jne    80104a98 <wakeup+0x28>
80104aa8:	3b 58 20             	cmp    0x20(%eax),%ebx
80104aab:	75 eb                	jne    80104a98 <wakeup+0x28>
      p->state = RUNNABLE;
80104aad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ab4:	83 c0 7c             	add    $0x7c,%eax
80104ab7:	3d 54 66 11 80       	cmp    $0x80116654,%eax
80104abc:	75 e4                	jne    80104aa2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
80104abe:	c7 45 08 20 47 11 80 	movl   $0x80114720,0x8(%ebp)
}
80104ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac8:	c9                   	leave  
  release(&ptable.lock);
80104ac9:	e9 e2 04 00 00       	jmp    80104fb0 <release>
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	53                   	push   %ebx
80104ad8:	83 ec 10             	sub    $0x10,%esp
80104adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104ade:	68 20 47 11 80       	push   $0x80114720
80104ae3:	e8 08 04 00 00       	call   80104ef0 <acquire>
80104ae8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aeb:	b8 54 47 11 80       	mov    $0x80114754,%eax
80104af0:	eb 10                	jmp    80104b02 <kill+0x32>
80104af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af8:	83 c0 7c             	add    $0x7c,%eax
80104afb:	3d 54 66 11 80       	cmp    $0x80116654,%eax
80104b00:	74 36                	je     80104b38 <kill+0x68>
    if(p->pid == pid){
80104b02:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b05:	75 f1                	jne    80104af8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b07:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b0b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104b12:	75 07                	jne    80104b1b <kill+0x4b>
        p->state = RUNNABLE;
80104b14:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b1b:	83 ec 0c             	sub    $0xc,%esp
80104b1e:	68 20 47 11 80       	push   $0x80114720
80104b23:	e8 88 04 00 00       	call   80104fb0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104b2b:	83 c4 10             	add    $0x10,%esp
80104b2e:	31 c0                	xor    %eax,%eax
}
80104b30:	c9                   	leave  
80104b31:	c3                   	ret    
80104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	68 20 47 11 80       	push   $0x80114720
80104b40:	e8 6b 04 00 00       	call   80104fb0 <release>
}
80104b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104b48:	83 c4 10             	add    $0x10,%esp
80104b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b50:	c9                   	leave  
80104b51:	c3                   	ret    
80104b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b60 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	57                   	push   %edi
80104b68:	56                   	push   %esi
80104b69:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104b6c:	53                   	push   %ebx
80104b6d:	bb c0 47 11 80       	mov    $0x801147c0,%ebx
80104b72:	83 ec 3c             	sub    $0x3c,%esp
80104b75:	eb 28                	jmp    80104b9f <procdump+0x3f>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	68 c7 8a 10 80       	push   $0x80108ac7
80104b88:	e8 63 bb ff ff       	call   801006f0 <cprintf>
80104b8d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b90:	83 c3 7c             	add    $0x7c,%ebx
80104b93:	81 fb c0 66 11 80    	cmp    $0x801166c0,%ebx
80104b99:	0f 84 81 00 00 00    	je     80104c20 <procdump+0xc0>
    if(p->state == UNUSED)
80104b9f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	74 ea                	je     80104b90 <procdump+0x30>
      state = "???";
80104ba6:	ba 2b 81 10 80       	mov    $0x8010812b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bab:	83 f8 05             	cmp    $0x5,%eax
80104bae:	77 11                	ja     80104bc1 <procdump+0x61>
80104bb0:	8b 14 85 8c 81 10 80 	mov    -0x7fef7e74(,%eax,4),%edx
      state = "???";
80104bb7:	b8 2b 81 10 80       	mov    $0x8010812b,%eax
80104bbc:	85 d2                	test   %edx,%edx
80104bbe:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104bc1:	53                   	push   %ebx
80104bc2:	52                   	push   %edx
80104bc3:	ff 73 a4             	pushl  -0x5c(%ebx)
80104bc6:	68 2f 81 10 80       	push   $0x8010812f
80104bcb:	e8 20 bb ff ff       	call   801006f0 <cprintf>
    if(p->state == SLEEPING){
80104bd0:	83 c4 10             	add    $0x10,%esp
80104bd3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104bd7:	75 a7                	jne    80104b80 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104bd9:	83 ec 08             	sub    $0x8,%esp
80104bdc:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bdf:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104be2:	50                   	push   %eax
80104be3:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104be6:	8b 40 0c             	mov    0xc(%eax),%eax
80104be9:	83 c0 08             	add    $0x8,%eax
80104bec:	50                   	push   %eax
80104bed:	e8 9e 01 00 00       	call   80104d90 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104bf2:	83 c4 10             	add    $0x10,%esp
80104bf5:	8d 76 00             	lea    0x0(%esi),%esi
80104bf8:	8b 17                	mov    (%edi),%edx
80104bfa:	85 d2                	test   %edx,%edx
80104bfc:	74 82                	je     80104b80 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104bfe:	83 ec 08             	sub    $0x8,%esp
80104c01:	83 c7 04             	add    $0x4,%edi
80104c04:	52                   	push   %edx
80104c05:	68 41 7b 10 80       	push   $0x80107b41
80104c0a:	e8 e1 ba ff ff       	call   801006f0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	39 fe                	cmp    %edi,%esi
80104c14:	75 e2                	jne    80104bf8 <procdump+0x98>
80104c16:	e9 65 ff ff ff       	jmp    80104b80 <procdump+0x20>
80104c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c1f:	90                   	nop
  }
}
80104c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c23:	5b                   	pop    %ebx
80104c24:	5e                   	pop    %esi
80104c25:	5f                   	pop    %edi
80104c26:	5d                   	pop    %ebp
80104c27:	c3                   	ret    
80104c28:	66 90                	xchg   %ax,%ax
80104c2a:	66 90                	xchg   %ax,%ax
80104c2c:	66 90                	xchg   %ax,%ax
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	53                   	push   %ebx
80104c38:	83 ec 0c             	sub    $0xc,%esp
80104c3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c3e:	68 a4 81 10 80       	push   $0x801081a4
80104c43:	8d 43 04             	lea    0x4(%ebx),%eax
80104c46:	50                   	push   %eax
80104c47:	e8 24 01 00 00       	call   80104d70 <initlock>
  lk->name = name;
80104c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c55:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c58:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c5f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	56                   	push   %esi
80104c78:	53                   	push   %ebx
80104c79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104c7f:	83 ec 0c             	sub    $0xc,%esp
80104c82:	56                   	push   %esi
80104c83:	e8 68 02 00 00       	call   80104ef0 <acquire>
  while (lk->locked) {
80104c88:	8b 13                	mov    (%ebx),%edx
80104c8a:	83 c4 10             	add    $0x10,%esp
80104c8d:	85 d2                	test   %edx,%edx
80104c8f:	74 1a                	je     80104cab <acquiresleep+0x3b>
80104c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104c98:	83 ec 08             	sub    $0x8,%esp
80104c9b:	56                   	push   %esi
80104c9c:	53                   	push   %ebx
80104c9d:	e8 0e fc ff ff       	call   801048b0 <sleep>
  while (lk->locked) {
80104ca2:	8b 03                	mov    (%ebx),%eax
80104ca4:	83 c4 10             	add    $0x10,%esp
80104ca7:	85 c0                	test   %eax,%eax
80104ca9:	75 ed                	jne    80104c98 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104cab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104cb1:	e8 3a f6 ff ff       	call   801042f0 <myproc>
80104cb6:	8b 40 10             	mov    0x10(%eax),%eax
80104cb9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104cbc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104cbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc2:	5b                   	pop    %ebx
80104cc3:	5e                   	pop    %esi
80104cc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104cc5:	e9 e6 02 00 00       	jmp    80104fb0 <release>
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cd0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	56                   	push   %esi
80104cd8:	53                   	push   %ebx
80104cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cdc:	8d 73 04             	lea    0x4(%ebx),%esi
80104cdf:	83 ec 0c             	sub    $0xc,%esp
80104ce2:	56                   	push   %esi
80104ce3:	e8 08 02 00 00       	call   80104ef0 <acquire>
  lk->locked = 0;
80104ce8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104cee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104cf5:	89 1c 24             	mov    %ebx,(%esp)
80104cf8:	e8 73 fd ff ff       	call   80104a70 <wakeup>
  release(&lk->lk);
80104cfd:	89 75 08             	mov    %esi,0x8(%ebp)
80104d00:	83 c4 10             	add    $0x10,%esp
}
80104d03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d06:	5b                   	pop    %ebx
80104d07:	5e                   	pop    %esi
80104d08:	5d                   	pop    %ebp
  release(&lk->lk);
80104d09:	e9 a2 02 00 00       	jmp    80104fb0 <release>
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	57                   	push   %edi
80104d18:	31 ff                	xor    %edi,%edi
80104d1a:	56                   	push   %esi
80104d1b:	53                   	push   %ebx
80104d1c:	83 ec 18             	sub    $0x18,%esp
80104d1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d22:	8d 73 04             	lea    0x4(%ebx),%esi
80104d25:	56                   	push   %esi
80104d26:	e8 c5 01 00 00       	call   80104ef0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d2b:	8b 03                	mov    (%ebx),%eax
80104d2d:	83 c4 10             	add    $0x10,%esp
80104d30:	85 c0                	test   %eax,%eax
80104d32:	75 1c                	jne    80104d50 <holdingsleep+0x40>
  release(&lk->lk);
80104d34:	83 ec 0c             	sub    $0xc,%esp
80104d37:	56                   	push   %esi
80104d38:	e8 73 02 00 00       	call   80104fb0 <release>
  return r;
}
80104d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d40:	89 f8                	mov    %edi,%eax
80104d42:	5b                   	pop    %ebx
80104d43:	5e                   	pop    %esi
80104d44:	5f                   	pop    %edi
80104d45:	5d                   	pop    %ebp
80104d46:	c3                   	ret    
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104d50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d53:	e8 98 f5 ff ff       	call   801042f0 <myproc>
80104d58:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d5b:	0f 94 c0             	sete   %al
80104d5e:	0f b6 c0             	movzbl %al,%eax
80104d61:	89 c7                	mov    %eax,%edi
80104d63:	eb cf                	jmp    80104d34 <holdingsleep+0x24>
80104d65:	66 90                	xchg   %ax,%ax
80104d67:	66 90                	xchg   %ax,%ax
80104d69:	66 90                	xchg   %ax,%ax
80104d6b:	66 90                	xchg   %ax,%ax
80104d6d:	66 90                	xchg   %ax,%ax
80104d6f:	90                   	nop

80104d70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d83:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d8d:	5d                   	pop    %ebp
80104d8e:	c3                   	ret    
80104d8f:	90                   	nop

80104d90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d95:	31 d2                	xor    %edx,%edx
{
80104d97:	89 e5                	mov    %esp,%ebp
80104d99:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d9a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104da0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104da7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104da8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104dae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104db4:	77 1a                	ja     80104dd0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104db6:	8b 58 04             	mov    0x4(%eax),%ebx
80104db9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104dbc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104dbf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104dc1:	83 fa 0a             	cmp    $0xa,%edx
80104dc4:	75 e2                	jne    80104da8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104dc6:	5b                   	pop    %ebx
80104dc7:	5d                   	pop    %ebp
80104dc8:	c3                   	ret    
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104dd0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104dd3:	8d 51 28             	lea    0x28(%ecx),%edx
80104dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104de6:	83 c0 04             	add    $0x4,%eax
80104de9:	39 d0                	cmp    %edx,%eax
80104deb:	75 f3                	jne    80104de0 <getcallerpcs+0x50>
}
80104ded:	5b                   	pop    %ebx
80104dee:	5d                   	pop    %ebp
80104def:	c3                   	ret    

80104df0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	53                   	push   %ebx
80104df8:	83 ec 04             	sub    $0x4,%esp
80104dfb:	9c                   	pushf  
80104dfc:	5b                   	pop    %ebx
  asm volatile("cli");
80104dfd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104dfe:	e8 5d f4 ff ff       	call   80104260 <mycpu>
80104e03:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104e09:	85 c0                	test   %eax,%eax
80104e0b:	74 13                	je     80104e20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104e0d:	e8 4e f4 ff ff       	call   80104260 <mycpu>
80104e12:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104e19:	83 c4 04             	add    $0x4,%esp
80104e1c:	5b                   	pop    %ebx
80104e1d:	5d                   	pop    %ebp
80104e1e:	c3                   	ret    
80104e1f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104e20:	e8 3b f4 ff ff       	call   80104260 <mycpu>
80104e25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104e2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104e31:	eb da                	jmp    80104e0d <pushcli+0x1d>
80104e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e40 <popcli>:

void
popcli(void)
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e4a:	9c                   	pushf  
80104e4b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e4c:	f6 c4 02             	test   $0x2,%ah
80104e4f:	75 31                	jne    80104e82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e51:	e8 0a f4 ff ff       	call   80104260 <mycpu>
80104e56:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e5d:	78 30                	js     80104e8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e5f:	e8 fc f3 ff ff       	call   80104260 <mycpu>
80104e64:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e6a:	85 d2                	test   %edx,%edx
80104e6c:	74 02                	je     80104e70 <popcli+0x30>
    sti();
}
80104e6e:	c9                   	leave  
80104e6f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e70:	e8 eb f3 ff ff       	call   80104260 <mycpu>
80104e75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	74 ef                	je     80104e6e <popcli+0x2e>
  asm volatile("sti");
80104e7f:	fb                   	sti    
}
80104e80:	c9                   	leave  
80104e81:	c3                   	ret    
    panic("popcli - interruptible");
80104e82:	83 ec 0c             	sub    $0xc,%esp
80104e85:	68 af 81 10 80       	push   $0x801081af
80104e8a:	e8 01 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e8f:	83 ec 0c             	sub    $0xc,%esp
80104e92:	68 c6 81 10 80       	push   $0x801081c6
80104e97:	e8 f4 b4 ff ff       	call   80100390 <panic>
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <holding>:
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	56                   	push   %esi
80104ea8:	53                   	push   %ebx
80104ea9:	8b 75 08             	mov    0x8(%ebp),%esi
80104eac:	31 db                	xor    %ebx,%ebx
  pushcli();
80104eae:	e8 3d ff ff ff       	call   80104df0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104eb3:	8b 06                	mov    (%esi),%eax
80104eb5:	85 c0                	test   %eax,%eax
80104eb7:	75 0f                	jne    80104ec8 <holding+0x28>
  popcli();
80104eb9:	e8 82 ff ff ff       	call   80104e40 <popcli>
}
80104ebe:	89 d8                	mov    %ebx,%eax
80104ec0:	5b                   	pop    %ebx
80104ec1:	5e                   	pop    %esi
80104ec2:	5d                   	pop    %ebp
80104ec3:	c3                   	ret    
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ec8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ecb:	e8 90 f3 ff ff       	call   80104260 <mycpu>
80104ed0:	39 c3                	cmp    %eax,%ebx
80104ed2:	0f 94 c3             	sete   %bl
  popcli();
80104ed5:	e8 66 ff ff ff       	call   80104e40 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104eda:	0f b6 db             	movzbl %bl,%ebx
}
80104edd:	89 d8                	mov    %ebx,%eax
80104edf:	5b                   	pop    %ebx
80104ee0:	5e                   	pop    %esi
80104ee1:	5d                   	pop    %ebp
80104ee2:	c3                   	ret    
80104ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ef0 <acquire>:
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	56                   	push   %esi
80104ef8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ef9:	e8 f2 fe ff ff       	call   80104df0 <pushcli>
  if(holding(lk))
80104efe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f01:	83 ec 0c             	sub    $0xc,%esp
80104f04:	53                   	push   %ebx
80104f05:	e8 96 ff ff ff       	call   80104ea0 <holding>
80104f0a:	83 c4 10             	add    $0x10,%esp
80104f0d:	85 c0                	test   %eax,%eax
80104f0f:	0f 85 7f 00 00 00    	jne    80104f94 <acquire+0xa4>
80104f15:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f17:	ba 01 00 00 00       	mov    $0x1,%edx
80104f1c:	eb 05                	jmp    80104f23 <acquire+0x33>
80104f1e:	66 90                	xchg   %ax,%ax
80104f20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f23:	89 d0                	mov    %edx,%eax
80104f25:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104f28:	85 c0                	test   %eax,%eax
80104f2a:	75 f4                	jne    80104f20 <acquire+0x30>
  __sync_synchronize();
80104f2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f34:	e8 27 f3 ff ff       	call   80104260 <mycpu>
80104f39:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104f3c:	89 e8                	mov    %ebp,%eax
80104f3e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f40:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104f46:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104f4c:	77 22                	ja     80104f70 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104f4e:	8b 50 04             	mov    0x4(%eax),%edx
80104f51:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104f55:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104f58:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f5a:	83 fe 0a             	cmp    $0xa,%esi
80104f5d:	75 e1                	jne    80104f40 <acquire+0x50>
}
80104f5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f62:	5b                   	pop    %ebx
80104f63:	5e                   	pop    %esi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104f70:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104f74:	83 c3 34             	add    $0x34,%ebx
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f86:	83 c0 04             	add    $0x4,%eax
80104f89:	39 d8                	cmp    %ebx,%eax
80104f8b:	75 f3                	jne    80104f80 <acquire+0x90>
}
80104f8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f90:	5b                   	pop    %ebx
80104f91:	5e                   	pop    %esi
80104f92:	5d                   	pop    %ebp
80104f93:	c3                   	ret    
    panic("acquire");
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	68 cd 81 10 80       	push   $0x801081cd
80104f9c:	e8 ef b3 ff ff       	call   80100390 <panic>
80104fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop

80104fb0 <release>:
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	53                   	push   %ebx
80104fb8:	83 ec 10             	sub    $0x10,%esp
80104fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104fbe:	53                   	push   %ebx
80104fbf:	e8 dc fe ff ff       	call   80104ea0 <holding>
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	74 22                	je     80104fed <release+0x3d>
  lk->pcs[0] = 0;
80104fcb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104fd2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104fd9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104fde:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fe7:	c9                   	leave  
  popcli();
80104fe8:	e9 53 fe ff ff       	jmp    80104e40 <popcli>
    panic("release");
80104fed:	83 ec 0c             	sub    $0xc,%esp
80104ff0:	68 d5 81 10 80       	push   $0x801081d5
80104ff5:	e8 96 b3 ff ff       	call   80100390 <panic>
80104ffa:	66 90                	xchg   %ax,%ax
80104ffc:	66 90                	xchg   %ax,%ax
80104ffe:	66 90                	xchg   %ax,%ax

80105000 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	57                   	push   %edi
80105008:	8b 55 08             	mov    0x8(%ebp),%edx
8010500b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010500e:	53                   	push   %ebx
8010500f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105012:	89 d7                	mov    %edx,%edi
80105014:	09 cf                	or     %ecx,%edi
80105016:	83 e7 03             	and    $0x3,%edi
80105019:	75 25                	jne    80105040 <memset+0x40>
    c &= 0xFF;
8010501b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010501e:	c1 e0 18             	shl    $0x18,%eax
80105021:	89 fb                	mov    %edi,%ebx
80105023:	c1 e9 02             	shr    $0x2,%ecx
80105026:	c1 e3 10             	shl    $0x10,%ebx
80105029:	09 d8                	or     %ebx,%eax
8010502b:	09 f8                	or     %edi,%eax
8010502d:	c1 e7 08             	shl    $0x8,%edi
80105030:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105032:	89 d7                	mov    %edx,%edi
80105034:	fc                   	cld    
80105035:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105037:	5b                   	pop    %ebx
80105038:	89 d0                	mov    %edx,%eax
8010503a:	5f                   	pop    %edi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105040:	89 d7                	mov    %edx,%edi
80105042:	fc                   	cld    
80105043:	f3 aa                	rep stos %al,%es:(%edi)
80105045:	5b                   	pop    %ebx
80105046:	89 d0                	mov    %edx,%eax
80105048:	5f                   	pop    %edi
80105049:	5d                   	pop    %ebp
8010504a:	c3                   	ret    
8010504b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010504f:	90                   	nop

80105050 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105050:	f3 0f 1e fb          	endbr32 
80105054:	55                   	push   %ebp
80105055:	89 e5                	mov    %esp,%ebp
80105057:	56                   	push   %esi
80105058:	8b 75 10             	mov    0x10(%ebp),%esi
8010505b:	8b 55 08             	mov    0x8(%ebp),%edx
8010505e:	53                   	push   %ebx
8010505f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105062:	85 f6                	test   %esi,%esi
80105064:	74 2a                	je     80105090 <memcmp+0x40>
80105066:	01 c6                	add    %eax,%esi
80105068:	eb 10                	jmp    8010507a <memcmp+0x2a>
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105070:	83 c0 01             	add    $0x1,%eax
80105073:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105076:	39 f0                	cmp    %esi,%eax
80105078:	74 16                	je     80105090 <memcmp+0x40>
    if(*s1 != *s2)
8010507a:	0f b6 0a             	movzbl (%edx),%ecx
8010507d:	0f b6 18             	movzbl (%eax),%ebx
80105080:	38 d9                	cmp    %bl,%cl
80105082:	74 ec                	je     80105070 <memcmp+0x20>
      return *s1 - *s2;
80105084:	0f b6 c1             	movzbl %cl,%eax
80105087:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105089:	5b                   	pop    %ebx
8010508a:	5e                   	pop    %esi
8010508b:	5d                   	pop    %ebp
8010508c:	c3                   	ret    
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
80105090:	5b                   	pop    %ebx
  return 0;
80105091:	31 c0                	xor    %eax,%eax
}
80105093:	5e                   	pop    %esi
80105094:	5d                   	pop    %ebp
80105095:	c3                   	ret    
80105096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509d:	8d 76 00             	lea    0x0(%esi),%esi

801050a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	57                   	push   %edi
801050a8:	8b 55 08             	mov    0x8(%ebp),%edx
801050ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050ae:	56                   	push   %esi
801050af:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801050b2:	39 d6                	cmp    %edx,%esi
801050b4:	73 2a                	jae    801050e0 <memmove+0x40>
801050b6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801050b9:	39 fa                	cmp    %edi,%edx
801050bb:	73 23                	jae    801050e0 <memmove+0x40>
801050bd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801050c0:	85 c9                	test   %ecx,%ecx
801050c2:	74 13                	je     801050d7 <memmove+0x37>
801050c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801050c8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801050cc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801050cf:	83 e8 01             	sub    $0x1,%eax
801050d2:	83 f8 ff             	cmp    $0xffffffff,%eax
801050d5:	75 f1                	jne    801050c8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801050d7:	5e                   	pop    %esi
801050d8:	89 d0                	mov    %edx,%eax
801050da:	5f                   	pop    %edi
801050db:	5d                   	pop    %ebp
801050dc:	c3                   	ret    
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801050e0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801050e3:	89 d7                	mov    %edx,%edi
801050e5:	85 c9                	test   %ecx,%ecx
801050e7:	74 ee                	je     801050d7 <memmove+0x37>
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801050f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801050f1:	39 f0                	cmp    %esi,%eax
801050f3:	75 fb                	jne    801050f0 <memmove+0x50>
}
801050f5:	5e                   	pop    %esi
801050f6:	89 d0                	mov    %edx,%eax
801050f8:	5f                   	pop    %edi
801050f9:	5d                   	pop    %ebp
801050fa:	c3                   	ret    
801050fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop

80105100 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105100:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105104:	eb 9a                	jmp    801050a0 <memmove>
80105106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510d:	8d 76 00             	lea    0x0(%esi),%esi

80105110 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105110:	f3 0f 1e fb          	endbr32 
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
80105117:	56                   	push   %esi
80105118:	8b 75 10             	mov    0x10(%ebp),%esi
8010511b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010511e:	53                   	push   %ebx
8010511f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105122:	85 f6                	test   %esi,%esi
80105124:	74 32                	je     80105158 <strncmp+0x48>
80105126:	01 c6                	add    %eax,%esi
80105128:	eb 14                	jmp    8010513e <strncmp+0x2e>
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105130:	38 da                	cmp    %bl,%dl
80105132:	75 14                	jne    80105148 <strncmp+0x38>
    n--, p++, q++;
80105134:	83 c0 01             	add    $0x1,%eax
80105137:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010513a:	39 f0                	cmp    %esi,%eax
8010513c:	74 1a                	je     80105158 <strncmp+0x48>
8010513e:	0f b6 11             	movzbl (%ecx),%edx
80105141:	0f b6 18             	movzbl (%eax),%ebx
80105144:	84 d2                	test   %dl,%dl
80105146:	75 e8                	jne    80105130 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105148:	0f b6 c2             	movzbl %dl,%eax
8010514b:	29 d8                	sub    %ebx,%eax
}
8010514d:	5b                   	pop    %ebx
8010514e:	5e                   	pop    %esi
8010514f:	5d                   	pop    %ebp
80105150:	c3                   	ret    
80105151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105158:	5b                   	pop    %ebx
    return 0;
80105159:	31 c0                	xor    %eax,%eax
}
8010515b:	5e                   	pop    %esi
8010515c:	5d                   	pop    %ebp
8010515d:	c3                   	ret    
8010515e:	66 90                	xchg   %ax,%ax

80105160 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	57                   	push   %edi
80105168:	56                   	push   %esi
80105169:	8b 75 08             	mov    0x8(%ebp),%esi
8010516c:	53                   	push   %ebx
8010516d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105170:	89 f2                	mov    %esi,%edx
80105172:	eb 1b                	jmp    8010518f <strncpy+0x2f>
80105174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105178:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010517c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010517f:	83 c2 01             	add    $0x1,%edx
80105182:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105186:	89 f9                	mov    %edi,%ecx
80105188:	88 4a ff             	mov    %cl,-0x1(%edx)
8010518b:	84 c9                	test   %cl,%cl
8010518d:	74 09                	je     80105198 <strncpy+0x38>
8010518f:	89 c3                	mov    %eax,%ebx
80105191:	83 e8 01             	sub    $0x1,%eax
80105194:	85 db                	test   %ebx,%ebx
80105196:	7f e0                	jg     80105178 <strncpy+0x18>
    ;
  while(n-- > 0)
80105198:	89 d1                	mov    %edx,%ecx
8010519a:	85 c0                	test   %eax,%eax
8010519c:	7e 15                	jle    801051b3 <strncpy+0x53>
8010519e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801051a0:	83 c1 01             	add    $0x1,%ecx
801051a3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801051a7:	89 c8                	mov    %ecx,%eax
801051a9:	f7 d0                	not    %eax
801051ab:	01 d0                	add    %edx,%eax
801051ad:	01 d8                	add    %ebx,%eax
801051af:	85 c0                	test   %eax,%eax
801051b1:	7f ed                	jg     801051a0 <strncpy+0x40>
  return os;
}
801051b3:	5b                   	pop    %ebx
801051b4:	89 f0                	mov    %esi,%eax
801051b6:	5e                   	pop    %esi
801051b7:	5f                   	pop    %edi
801051b8:	5d                   	pop    %ebp
801051b9:	c3                   	ret    
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801051c0:	f3 0f 1e fb          	endbr32 
801051c4:	55                   	push   %ebp
801051c5:	89 e5                	mov    %esp,%ebp
801051c7:	56                   	push   %esi
801051c8:	8b 55 10             	mov    0x10(%ebp),%edx
801051cb:	8b 75 08             	mov    0x8(%ebp),%esi
801051ce:	53                   	push   %ebx
801051cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801051d2:	85 d2                	test   %edx,%edx
801051d4:	7e 21                	jle    801051f7 <safestrcpy+0x37>
801051d6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801051da:	89 f2                	mov    %esi,%edx
801051dc:	eb 12                	jmp    801051f0 <safestrcpy+0x30>
801051de:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801051e0:	0f b6 08             	movzbl (%eax),%ecx
801051e3:	83 c0 01             	add    $0x1,%eax
801051e6:	83 c2 01             	add    $0x1,%edx
801051e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801051ec:	84 c9                	test   %cl,%cl
801051ee:	74 04                	je     801051f4 <safestrcpy+0x34>
801051f0:	39 d8                	cmp    %ebx,%eax
801051f2:	75 ec                	jne    801051e0 <safestrcpy+0x20>
    ;
  *s = 0;
801051f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801051f7:	89 f0                	mov    %esi,%eax
801051f9:	5b                   	pop    %ebx
801051fa:	5e                   	pop    %esi
801051fb:	5d                   	pop    %ebp
801051fc:	c3                   	ret    
801051fd:	8d 76 00             	lea    0x0(%esi),%esi

80105200 <strlen>:

int
strlen(const char *s)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105205:	31 c0                	xor    %eax,%eax
{
80105207:	89 e5                	mov    %esp,%ebp
80105209:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010520c:	80 3a 00             	cmpb   $0x0,(%edx)
8010520f:	74 10                	je     80105221 <strlen+0x21>
80105211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105218:	83 c0 01             	add    $0x1,%eax
8010521b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010521f:	75 f7                	jne    80105218 <strlen+0x18>
    ;
  return n;
}
80105221:	5d                   	pop    %ebp
80105222:	c3                   	ret    

80105223 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105223:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105227:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010522b:	55                   	push   %ebp
  pushl %ebx
8010522c:	53                   	push   %ebx
  pushl %esi
8010522d:	56                   	push   %esi
  pushl %edi
8010522e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010522f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105231:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105233:	5f                   	pop    %edi
  popl %esi
80105234:	5e                   	pop    %esi
  popl %ebx
80105235:	5b                   	pop    %ebx
  popl %ebp
80105236:	5d                   	pop    %ebp
  ret
80105237:	c3                   	ret    
80105238:	66 90                	xchg   %ax,%ax
8010523a:	66 90                	xchg   %ax,%ax
8010523c:	66 90                	xchg   %ax,%ax
8010523e:	66 90                	xchg   %ax,%ax

80105240 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	53                   	push   %ebx
80105248:	83 ec 04             	sub    $0x4,%esp
8010524b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010524e:	e8 9d f0 ff ff       	call   801042f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105253:	8b 00                	mov    (%eax),%eax
80105255:	39 d8                	cmp    %ebx,%eax
80105257:	76 17                	jbe    80105270 <fetchint+0x30>
80105259:	8d 53 04             	lea    0x4(%ebx),%edx
8010525c:	39 d0                	cmp    %edx,%eax
8010525e:	72 10                	jb     80105270 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105260:	8b 45 0c             	mov    0xc(%ebp),%eax
80105263:	8b 13                	mov    (%ebx),%edx
80105265:	89 10                	mov    %edx,(%eax)
  return 0;
80105267:	31 c0                	xor    %eax,%eax
}
80105269:	83 c4 04             	add    $0x4,%esp
8010526c:	5b                   	pop    %ebx
8010526d:	5d                   	pop    %ebp
8010526e:	c3                   	ret    
8010526f:	90                   	nop
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105275:	eb f2                	jmp    80105269 <fetchint+0x29>
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax

80105280 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	53                   	push   %ebx
80105288:	83 ec 04             	sub    $0x4,%esp
8010528b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010528e:	e8 5d f0 ff ff       	call   801042f0 <myproc>

  if(addr >= curproc->sz)
80105293:	39 18                	cmp    %ebx,(%eax)
80105295:	76 31                	jbe    801052c8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105297:	8b 55 0c             	mov    0xc(%ebp),%edx
8010529a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010529c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010529e:	39 d3                	cmp    %edx,%ebx
801052a0:	73 26                	jae    801052c8 <fetchstr+0x48>
801052a2:	89 d8                	mov    %ebx,%eax
801052a4:	eb 11                	jmp    801052b7 <fetchstr+0x37>
801052a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
801052b0:	83 c0 01             	add    $0x1,%eax
801052b3:	39 c2                	cmp    %eax,%edx
801052b5:	76 11                	jbe    801052c8 <fetchstr+0x48>
    if(*s == 0)
801052b7:	80 38 00             	cmpb   $0x0,(%eax)
801052ba:	75 f4                	jne    801052b0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801052bc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801052bf:	29 d8                	sub    %ebx,%eax
}
801052c1:	5b                   	pop    %ebx
801052c2:	5d                   	pop    %ebp
801052c3:	c3                   	ret    
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052c8:	83 c4 04             	add    $0x4,%esp
    return -1;
801052cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d0:	5b                   	pop    %ebx
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    
801052d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801052e0:	f3 0f 1e fb          	endbr32 
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	56                   	push   %esi
801052e8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052e9:	e8 02 f0 ff ff       	call   801042f0 <myproc>
801052ee:	8b 55 08             	mov    0x8(%ebp),%edx
801052f1:	8b 40 18             	mov    0x18(%eax),%eax
801052f4:	8b 40 44             	mov    0x44(%eax),%eax
801052f7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801052fa:	e8 f1 ef ff ff       	call   801042f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052ff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105302:	8b 00                	mov    (%eax),%eax
80105304:	39 c6                	cmp    %eax,%esi
80105306:	73 18                	jae    80105320 <argint+0x40>
80105308:	8d 53 08             	lea    0x8(%ebx),%edx
8010530b:	39 d0                	cmp    %edx,%eax
8010530d:	72 11                	jb     80105320 <argint+0x40>
  *ip = *(int*)(addr);
8010530f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105312:	8b 53 04             	mov    0x4(%ebx),%edx
80105315:	89 10                	mov    %edx,(%eax)
  return 0;
80105317:	31 c0                	xor    %eax,%eax
}
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5d                   	pop    %ebp
8010531c:	c3                   	ret    
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105325:	eb f2                	jmp    80105319 <argint+0x39>
80105327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532e:	66 90                	xchg   %ax,%ax

80105330 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	56                   	push   %esi
80105338:	53                   	push   %ebx
80105339:	83 ec 10             	sub    $0x10,%esp
8010533c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010533f:	e8 ac ef ff ff       	call   801042f0 <myproc>
 
  if(argint(n, &i) < 0)
80105344:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105347:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105349:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010534c:	50                   	push   %eax
8010534d:	ff 75 08             	pushl  0x8(%ebp)
80105350:	e8 8b ff ff ff       	call   801052e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	85 c0                	test   %eax,%eax
8010535a:	78 24                	js     80105380 <argptr+0x50>
8010535c:	85 db                	test   %ebx,%ebx
8010535e:	78 20                	js     80105380 <argptr+0x50>
80105360:	8b 16                	mov    (%esi),%edx
80105362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105365:	39 c2                	cmp    %eax,%edx
80105367:	76 17                	jbe    80105380 <argptr+0x50>
80105369:	01 c3                	add    %eax,%ebx
8010536b:	39 da                	cmp    %ebx,%edx
8010536d:	72 11                	jb     80105380 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010536f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105372:	89 02                	mov    %eax,(%edx)
  return 0;
80105374:	31 c0                	xor    %eax,%eax
}
80105376:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105379:	5b                   	pop    %ebx
8010537a:	5e                   	pop    %esi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105385:	eb ef                	jmp    80105376 <argptr+0x46>
80105387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538e:	66 90                	xchg   %ax,%ax

80105390 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010539a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539d:	50                   	push   %eax
8010539e:	ff 75 08             	pushl  0x8(%ebp)
801053a1:	e8 3a ff ff ff       	call   801052e0 <argint>
801053a6:	83 c4 10             	add    $0x10,%esp
801053a9:	85 c0                	test   %eax,%eax
801053ab:	78 13                	js     801053c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801053ad:	83 ec 08             	sub    $0x8,%esp
801053b0:	ff 75 0c             	pushl  0xc(%ebp)
801053b3:	ff 75 f4             	pushl  -0xc(%ebp)
801053b6:	e8 c5 fe ff ff       	call   80105280 <fetchstr>
801053bb:	83 c4 10             	add    $0x10,%esp
}
801053be:	c9                   	leave  
801053bf:	c3                   	ret    
801053c0:	c9                   	leave  
    return -1;
801053c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c6:	c3                   	ret    
801053c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ce:	66 90                	xchg   %ax,%ax

801053d0 <syscall>:
[SYS_draw]    sys_draw,
};

void
syscall(void)
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	53                   	push   %ebx
801053d8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801053db:	e8 10 ef ff ff       	call   801042f0 <myproc>
801053e0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801053e2:	8b 40 18             	mov    0x18(%eax),%eax
801053e5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801053e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801053eb:	83 fa 15             	cmp    $0x15,%edx
801053ee:	77 20                	ja     80105410 <syscall+0x40>
801053f0:	8b 14 85 00 82 10 80 	mov    -0x7fef7e00(,%eax,4),%edx
801053f7:	85 d2                	test   %edx,%edx
801053f9:	74 15                	je     80105410 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801053fb:	ff d2                	call   *%edx
801053fd:	89 c2                	mov    %eax,%edx
801053ff:	8b 43 18             	mov    0x18(%ebx),%eax
80105402:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105408:	c9                   	leave  
80105409:	c3                   	ret    
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105410:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105411:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105414:	50                   	push   %eax
80105415:	ff 73 10             	pushl  0x10(%ebx)
80105418:	68 dd 81 10 80       	push   $0x801081dd
8010541d:	e8 ce b2 ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
80105422:	8b 43 18             	mov    0x18(%ebx),%eax
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010542f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105432:	c9                   	leave  
80105433:	c3                   	ret    
80105434:	66 90                	xchg   %ax,%ax
80105436:	66 90                	xchg   %ax,%ax
80105438:	66 90                	xchg   %ax,%ax
8010543a:	66 90                	xchg   %ax,%ax
8010543c:	66 90                	xchg   %ax,%ax
8010543e:	66 90                	xchg   %ax,%ax

80105440 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105445:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105448:	53                   	push   %ebx
80105449:	83 ec 34             	sub    $0x34,%esp
8010544c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010544f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105452:	57                   	push   %edi
80105453:	50                   	push   %eax
{
80105454:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105457:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010545a:	e8 81 d5 ff ff       	call   801029e0 <nameiparent>
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	85 c0                	test   %eax,%eax
80105464:	0f 84 46 01 00 00    	je     801055b0 <create+0x170>
    return 0;
  ilock(dp);
8010546a:	83 ec 0c             	sub    $0xc,%esp
8010546d:	89 c3                	mov    %eax,%ebx
8010546f:	50                   	push   %eax
80105470:	e8 7b cc ff ff       	call   801020f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105475:	83 c4 0c             	add    $0xc,%esp
80105478:	6a 00                	push   $0x0
8010547a:	57                   	push   %edi
8010547b:	53                   	push   %ebx
8010547c:	e8 bf d1 ff ff       	call   80102640 <dirlookup>
80105481:	83 c4 10             	add    $0x10,%esp
80105484:	89 c6                	mov    %eax,%esi
80105486:	85 c0                	test   %eax,%eax
80105488:	74 56                	je     801054e0 <create+0xa0>
    iunlockput(dp);
8010548a:	83 ec 0c             	sub    $0xc,%esp
8010548d:	53                   	push   %ebx
8010548e:	e8 fd ce ff ff       	call   80102390 <iunlockput>
    ilock(ip);
80105493:	89 34 24             	mov    %esi,(%esp)
80105496:	e8 55 cc ff ff       	call   801020f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010549b:	83 c4 10             	add    $0x10,%esp
8010549e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801054a3:	75 1b                	jne    801054c0 <create+0x80>
801054a5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801054aa:	75 14                	jne    801054c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801054ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054af:	89 f0                	mov    %esi,%eax
801054b1:	5b                   	pop    %ebx
801054b2:	5e                   	pop    %esi
801054b3:	5f                   	pop    %edi
801054b4:	5d                   	pop    %ebp
801054b5:	c3                   	ret    
801054b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	56                   	push   %esi
    return 0;
801054c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801054c6:	e8 c5 ce ff ff       	call   80102390 <iunlockput>
    return 0;
801054cb:	83 c4 10             	add    $0x10,%esp
}
801054ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d1:	89 f0                	mov    %esi,%eax
801054d3:	5b                   	pop    %ebx
801054d4:	5e                   	pop    %esi
801054d5:	5f                   	pop    %edi
801054d6:	5d                   	pop    %ebp
801054d7:	c3                   	ret    
801054d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801054e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801054e4:	83 ec 08             	sub    $0x8,%esp
801054e7:	50                   	push   %eax
801054e8:	ff 33                	pushl  (%ebx)
801054ea:	e8 81 ca ff ff       	call   80101f70 <ialloc>
801054ef:	83 c4 10             	add    $0x10,%esp
801054f2:	89 c6                	mov    %eax,%esi
801054f4:	85 c0                	test   %eax,%eax
801054f6:	0f 84 cd 00 00 00    	je     801055c9 <create+0x189>
  ilock(ip);
801054fc:	83 ec 0c             	sub    $0xc,%esp
801054ff:	50                   	push   %eax
80105500:	e8 eb cb ff ff       	call   801020f0 <ilock>
  ip->major = major;
80105505:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105509:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010550d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105511:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105515:	b8 01 00 00 00       	mov    $0x1,%eax
8010551a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010551e:	89 34 24             	mov    %esi,(%esp)
80105521:	e8 0a cb ff ff       	call   80102030 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010552e:	74 30                	je     80105560 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105530:	83 ec 04             	sub    $0x4,%esp
80105533:	ff 76 04             	pushl  0x4(%esi)
80105536:	57                   	push   %edi
80105537:	53                   	push   %ebx
80105538:	e8 c3 d3 ff ff       	call   80102900 <dirlink>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 78                	js     801055bc <create+0x17c>
  iunlockput(dp);
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	53                   	push   %ebx
80105548:	e8 43 ce ff ff       	call   80102390 <iunlockput>
  return ip;
8010554d:	83 c4 10             	add    $0x10,%esp
}
80105550:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105553:	89 f0                	mov    %esi,%eax
80105555:	5b                   	pop    %ebx
80105556:	5e                   	pop    %esi
80105557:	5f                   	pop    %edi
80105558:	5d                   	pop    %ebp
80105559:	c3                   	ret    
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105560:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105563:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105568:	53                   	push   %ebx
80105569:	e8 c2 ca ff ff       	call   80102030 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010556e:	83 c4 0c             	add    $0xc,%esp
80105571:	ff 76 04             	pushl  0x4(%esi)
80105574:	68 78 82 10 80       	push   $0x80108278
80105579:	56                   	push   %esi
8010557a:	e8 81 d3 ff ff       	call   80102900 <dirlink>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	85 c0                	test   %eax,%eax
80105584:	78 18                	js     8010559e <create+0x15e>
80105586:	83 ec 04             	sub    $0x4,%esp
80105589:	ff 73 04             	pushl  0x4(%ebx)
8010558c:	68 77 82 10 80       	push   $0x80108277
80105591:	56                   	push   %esi
80105592:	e8 69 d3 ff ff       	call   80102900 <dirlink>
80105597:	83 c4 10             	add    $0x10,%esp
8010559a:	85 c0                	test   %eax,%eax
8010559c:	79 92                	jns    80105530 <create+0xf0>
      panic("create dots");
8010559e:	83 ec 0c             	sub    $0xc,%esp
801055a1:	68 6b 82 10 80       	push   $0x8010826b
801055a6:	e8 e5 ad ff ff       	call   80100390 <panic>
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
}
801055b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801055b3:	31 f6                	xor    %esi,%esi
}
801055b5:	5b                   	pop    %ebx
801055b6:	89 f0                	mov    %esi,%eax
801055b8:	5e                   	pop    %esi
801055b9:	5f                   	pop    %edi
801055ba:	5d                   	pop    %ebp
801055bb:	c3                   	ret    
    panic("create: dirlink");
801055bc:	83 ec 0c             	sub    $0xc,%esp
801055bf:	68 7a 82 10 80       	push   $0x8010827a
801055c4:	e8 c7 ad ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	68 5c 82 10 80       	push   $0x8010825c
801055d1:	e8 ba ad ff ff       	call   80100390 <panic>
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi

801055e0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	89 d6                	mov    %edx,%esi
801055e6:	53                   	push   %ebx
801055e7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801055e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801055ec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055ef:	50                   	push   %eax
801055f0:	6a 00                	push   $0x0
801055f2:	e8 e9 fc ff ff       	call   801052e0 <argint>
801055f7:	83 c4 10             	add    $0x10,%esp
801055fa:	85 c0                	test   %eax,%eax
801055fc:	78 2a                	js     80105628 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105602:	77 24                	ja     80105628 <argfd.constprop.0+0x48>
80105604:	e8 e7 ec ff ff       	call   801042f0 <myproc>
80105609:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010560c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105610:	85 c0                	test   %eax,%eax
80105612:	74 14                	je     80105628 <argfd.constprop.0+0x48>
  if(pfd)
80105614:	85 db                	test   %ebx,%ebx
80105616:	74 02                	je     8010561a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105618:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010561a:	89 06                	mov    %eax,(%esi)
  return 0;
8010561c:	31 c0                	xor    %eax,%eax
}
8010561e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105621:	5b                   	pop    %ebx
80105622:	5e                   	pop    %esi
80105623:	5d                   	pop    %ebp
80105624:	c3                   	ret    
80105625:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562d:	eb ef                	jmp    8010561e <argfd.constprop.0+0x3e>
8010562f:	90                   	nop

80105630 <sys_dup>:
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105635:	31 c0                	xor    %eax,%eax
{
80105637:	89 e5                	mov    %esp,%ebp
80105639:	56                   	push   %esi
8010563a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010563b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010563e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105641:	e8 9a ff ff ff       	call   801055e0 <argfd.constprop.0>
80105646:	85 c0                	test   %eax,%eax
80105648:	78 1e                	js     80105668 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010564a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010564d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010564f:	e8 9c ec ff ff       	call   801042f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105658:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010565c:	85 d2                	test   %edx,%edx
8010565e:	74 20                	je     80105680 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105660:	83 c3 01             	add    $0x1,%ebx
80105663:	83 fb 10             	cmp    $0x10,%ebx
80105666:	75 f0                	jne    80105658 <sys_dup+0x28>
}
80105668:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010566b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105670:	89 d8                	mov    %ebx,%eax
80105672:	5b                   	pop    %ebx
80105673:	5e                   	pop    %esi
80105674:	5d                   	pop    %ebp
80105675:	c3                   	ret    
80105676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105680:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	ff 75 f4             	pushl  -0xc(%ebp)
8010568a:	e8 71 c1 ff ff       	call   80101800 <filedup>
  return fd;
8010568f:	83 c4 10             	add    $0x10,%esp
}
80105692:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105695:	89 d8                	mov    %ebx,%eax
80105697:	5b                   	pop    %ebx
80105698:	5e                   	pop    %esi
80105699:	5d                   	pop    %ebp
8010569a:	c3                   	ret    
8010569b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop

801056a0 <sys_read>:
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056a5:	31 c0                	xor    %eax,%eax
{
801056a7:	89 e5                	mov    %esp,%ebp
801056a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056ac:	8d 55 ec             	lea    -0x14(%ebp),%edx
801056af:	e8 2c ff ff ff       	call   801055e0 <argfd.constprop.0>
801056b4:	85 c0                	test   %eax,%eax
801056b6:	78 48                	js     80105700 <sys_read+0x60>
801056b8:	83 ec 08             	sub    $0x8,%esp
801056bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056be:	50                   	push   %eax
801056bf:	6a 02                	push   $0x2
801056c1:	e8 1a fc ff ff       	call   801052e0 <argint>
801056c6:	83 c4 10             	add    $0x10,%esp
801056c9:	85 c0                	test   %eax,%eax
801056cb:	78 33                	js     80105700 <sys_read+0x60>
801056cd:	83 ec 04             	sub    $0x4,%esp
801056d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d3:	ff 75 f0             	pushl  -0x10(%ebp)
801056d6:	50                   	push   %eax
801056d7:	6a 01                	push   $0x1
801056d9:	e8 52 fc ff ff       	call   80105330 <argptr>
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	85 c0                	test   %eax,%eax
801056e3:	78 1b                	js     80105700 <sys_read+0x60>
  return fileread(f, p, n);
801056e5:	83 ec 04             	sub    $0x4,%esp
801056e8:	ff 75 f0             	pushl  -0x10(%ebp)
801056eb:	ff 75 f4             	pushl  -0xc(%ebp)
801056ee:	ff 75 ec             	pushl  -0x14(%ebp)
801056f1:	e8 8a c2 ff ff       	call   80101980 <fileread>
801056f6:	83 c4 10             	add    $0x10,%esp
}
801056f9:	c9                   	leave  
801056fa:	c3                   	ret    
801056fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ff:	90                   	nop
80105700:	c9                   	leave  
    return -1;
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105706:	c3                   	ret    
80105707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570e:	66 90                	xchg   %ax,%ax

80105710 <sys_write>:
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105715:	31 c0                	xor    %eax,%eax
{
80105717:	89 e5                	mov    %esp,%ebp
80105719:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010571c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010571f:	e8 bc fe ff ff       	call   801055e0 <argfd.constprop.0>
80105724:	85 c0                	test   %eax,%eax
80105726:	78 48                	js     80105770 <sys_write+0x60>
80105728:	83 ec 08             	sub    $0x8,%esp
8010572b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010572e:	50                   	push   %eax
8010572f:	6a 02                	push   $0x2
80105731:	e8 aa fb ff ff       	call   801052e0 <argint>
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	85 c0                	test   %eax,%eax
8010573b:	78 33                	js     80105770 <sys_write+0x60>
8010573d:	83 ec 04             	sub    $0x4,%esp
80105740:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105743:	ff 75 f0             	pushl  -0x10(%ebp)
80105746:	50                   	push   %eax
80105747:	6a 01                	push   $0x1
80105749:	e8 e2 fb ff ff       	call   80105330 <argptr>
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	85 c0                	test   %eax,%eax
80105753:	78 1b                	js     80105770 <sys_write+0x60>
  return filewrite(f, p, n);
80105755:	83 ec 04             	sub    $0x4,%esp
80105758:	ff 75 f0             	pushl  -0x10(%ebp)
8010575b:	ff 75 f4             	pushl  -0xc(%ebp)
8010575e:	ff 75 ec             	pushl  -0x14(%ebp)
80105761:	e8 ba c2 ff ff       	call   80101a20 <filewrite>
80105766:	83 c4 10             	add    $0x10,%esp
}
80105769:	c9                   	leave  
8010576a:	c3                   	ret    
8010576b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
80105770:	c9                   	leave  
    return -1;
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105776:	c3                   	ret    
80105777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_close>:
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010578a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010578d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105790:	e8 4b fe ff ff       	call   801055e0 <argfd.constprop.0>
80105795:	85 c0                	test   %eax,%eax
80105797:	78 27                	js     801057c0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105799:	e8 52 eb ff ff       	call   801042f0 <myproc>
8010579e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801057a1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801057a4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801057ab:	00 
  fileclose(f);
801057ac:	ff 75 f4             	pushl  -0xc(%ebp)
801057af:	e8 9c c0 ff ff       	call   80101850 <fileclose>
  return 0;
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	31 c0                	xor    %eax,%eax
}
801057b9:	c9                   	leave  
801057ba:	c3                   	ret    
801057bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
801057c0:	c9                   	leave  
    return -1;
801057c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c6:	c3                   	ret    
801057c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ce:	66 90                	xchg   %ax,%ax

801057d0 <sys_fstat>:
{
801057d0:	f3 0f 1e fb          	endbr32 
801057d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057d5:	31 c0                	xor    %eax,%eax
{
801057d7:	89 e5                	mov    %esp,%ebp
801057d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057dc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801057df:	e8 fc fd ff ff       	call   801055e0 <argfd.constprop.0>
801057e4:	85 c0                	test   %eax,%eax
801057e6:	78 30                	js     80105818 <sys_fstat+0x48>
801057e8:	83 ec 04             	sub    $0x4,%esp
801057eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ee:	6a 14                	push   $0x14
801057f0:	50                   	push   %eax
801057f1:	6a 01                	push   $0x1
801057f3:	e8 38 fb ff ff       	call   80105330 <argptr>
801057f8:	83 c4 10             	add    $0x10,%esp
801057fb:	85 c0                	test   %eax,%eax
801057fd:	78 19                	js     80105818 <sys_fstat+0x48>
  return filestat(f, st);
801057ff:	83 ec 08             	sub    $0x8,%esp
80105802:	ff 75 f4             	pushl  -0xc(%ebp)
80105805:	ff 75 f0             	pushl  -0x10(%ebp)
80105808:	e8 23 c1 ff ff       	call   80101930 <filestat>
8010580d:	83 c4 10             	add    $0x10,%esp
}
80105810:	c9                   	leave  
80105811:	c3                   	ret    
80105812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105818:	c9                   	leave  
    return -1;
80105819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010581e:	c3                   	ret    
8010581f:	90                   	nop

80105820 <sys_link>:
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	57                   	push   %edi
80105828:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105829:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010582c:	53                   	push   %ebx
8010582d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105830:	50                   	push   %eax
80105831:	6a 00                	push   $0x0
80105833:	e8 58 fb ff ff       	call   80105390 <argstr>
80105838:	83 c4 10             	add    $0x10,%esp
8010583b:	85 c0                	test   %eax,%eax
8010583d:	0f 88 ff 00 00 00    	js     80105942 <sys_link+0x122>
80105843:	83 ec 08             	sub    $0x8,%esp
80105846:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105849:	50                   	push   %eax
8010584a:	6a 01                	push   $0x1
8010584c:	e8 3f fb ff ff       	call   80105390 <argstr>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	85 c0                	test   %eax,%eax
80105856:	0f 88 e6 00 00 00    	js     80105942 <sys_link+0x122>
  begin_op();
8010585c:	e8 5f de ff ff       	call   801036c0 <begin_op>
  if((ip = namei(old)) == 0){
80105861:	83 ec 0c             	sub    $0xc,%esp
80105864:	ff 75 d4             	pushl  -0x2c(%ebp)
80105867:	e8 54 d1 ff ff       	call   801029c0 <namei>
8010586c:	83 c4 10             	add    $0x10,%esp
8010586f:	89 c3                	mov    %eax,%ebx
80105871:	85 c0                	test   %eax,%eax
80105873:	0f 84 e8 00 00 00    	je     80105961 <sys_link+0x141>
  ilock(ip);
80105879:	83 ec 0c             	sub    $0xc,%esp
8010587c:	50                   	push   %eax
8010587d:	e8 6e c8 ff ff       	call   801020f0 <ilock>
  if(ip->type == T_DIR){
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010588a:	0f 84 b9 00 00 00    	je     80105949 <sys_link+0x129>
  iupdate(ip);
80105890:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105893:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105898:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010589b:	53                   	push   %ebx
8010589c:	e8 8f c7 ff ff       	call   80102030 <iupdate>
  iunlock(ip);
801058a1:	89 1c 24             	mov    %ebx,(%esp)
801058a4:	e8 27 c9 ff ff       	call   801021d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801058a9:	58                   	pop    %eax
801058aa:	5a                   	pop    %edx
801058ab:	57                   	push   %edi
801058ac:	ff 75 d0             	pushl  -0x30(%ebp)
801058af:	e8 2c d1 ff ff       	call   801029e0 <nameiparent>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	89 c6                	mov    %eax,%esi
801058b9:	85 c0                	test   %eax,%eax
801058bb:	74 5f                	je     8010591c <sys_link+0xfc>
  ilock(dp);
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	50                   	push   %eax
801058c1:	e8 2a c8 ff ff       	call   801020f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801058c6:	8b 03                	mov    (%ebx),%eax
801058c8:	83 c4 10             	add    $0x10,%esp
801058cb:	39 06                	cmp    %eax,(%esi)
801058cd:	75 41                	jne    80105910 <sys_link+0xf0>
801058cf:	83 ec 04             	sub    $0x4,%esp
801058d2:	ff 73 04             	pushl  0x4(%ebx)
801058d5:	57                   	push   %edi
801058d6:	56                   	push   %esi
801058d7:	e8 24 d0 ff ff       	call   80102900 <dirlink>
801058dc:	83 c4 10             	add    $0x10,%esp
801058df:	85 c0                	test   %eax,%eax
801058e1:	78 2d                	js     80105910 <sys_link+0xf0>
  iunlockput(dp);
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	56                   	push   %esi
801058e7:	e8 a4 ca ff ff       	call   80102390 <iunlockput>
  iput(ip);
801058ec:	89 1c 24             	mov    %ebx,(%esp)
801058ef:	e8 2c c9 ff ff       	call   80102220 <iput>
  end_op();
801058f4:	e8 37 de ff ff       	call   80103730 <end_op>
  return 0;
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	31 c0                	xor    %eax,%eax
}
801058fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105901:	5b                   	pop    %ebx
80105902:	5e                   	pop    %esi
80105903:	5f                   	pop    %edi
80105904:	5d                   	pop    %ebp
80105905:	c3                   	ret    
80105906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	56                   	push   %esi
80105914:	e8 77 ca ff ff       	call   80102390 <iunlockput>
    goto bad;
80105919:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010591c:	83 ec 0c             	sub    $0xc,%esp
8010591f:	53                   	push   %ebx
80105920:	e8 cb c7 ff ff       	call   801020f0 <ilock>
  ip->nlink--;
80105925:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010592a:	89 1c 24             	mov    %ebx,(%esp)
8010592d:	e8 fe c6 ff ff       	call   80102030 <iupdate>
  iunlockput(ip);
80105932:	89 1c 24             	mov    %ebx,(%esp)
80105935:	e8 56 ca ff ff       	call   80102390 <iunlockput>
  end_op();
8010593a:	e8 f1 dd ff ff       	call   80103730 <end_op>
  return -1;
8010593f:	83 c4 10             	add    $0x10,%esp
80105942:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105947:	eb b5                	jmp    801058fe <sys_link+0xde>
    iunlockput(ip);
80105949:	83 ec 0c             	sub    $0xc,%esp
8010594c:	53                   	push   %ebx
8010594d:	e8 3e ca ff ff       	call   80102390 <iunlockput>
    end_op();
80105952:	e8 d9 dd ff ff       	call   80103730 <end_op>
    return -1;
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595f:	eb 9d                	jmp    801058fe <sys_link+0xde>
    end_op();
80105961:	e8 ca dd ff ff       	call   80103730 <end_op>
    return -1;
80105966:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596b:	eb 91                	jmp    801058fe <sys_link+0xde>
8010596d:	8d 76 00             	lea    0x0(%esi),%esi

80105970 <sys_unlink>:
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	57                   	push   %edi
80105978:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105979:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010597c:	53                   	push   %ebx
8010597d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105980:	50                   	push   %eax
80105981:	6a 00                	push   $0x0
80105983:	e8 08 fa ff ff       	call   80105390 <argstr>
80105988:	83 c4 10             	add    $0x10,%esp
8010598b:	85 c0                	test   %eax,%eax
8010598d:	0f 88 7d 01 00 00    	js     80105b10 <sys_unlink+0x1a0>
  begin_op();
80105993:	e8 28 dd ff ff       	call   801036c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105998:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010599b:	83 ec 08             	sub    $0x8,%esp
8010599e:	53                   	push   %ebx
8010599f:	ff 75 c0             	pushl  -0x40(%ebp)
801059a2:	e8 39 d0 ff ff       	call   801029e0 <nameiparent>
801059a7:	83 c4 10             	add    $0x10,%esp
801059aa:	89 c6                	mov    %eax,%esi
801059ac:	85 c0                	test   %eax,%eax
801059ae:	0f 84 66 01 00 00    	je     80105b1a <sys_unlink+0x1aa>
  ilock(dp);
801059b4:	83 ec 0c             	sub    $0xc,%esp
801059b7:	50                   	push   %eax
801059b8:	e8 33 c7 ff ff       	call   801020f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801059bd:	58                   	pop    %eax
801059be:	5a                   	pop    %edx
801059bf:	68 78 82 10 80       	push   $0x80108278
801059c4:	53                   	push   %ebx
801059c5:	e8 56 cc ff ff       	call   80102620 <namecmp>
801059ca:	83 c4 10             	add    $0x10,%esp
801059cd:	85 c0                	test   %eax,%eax
801059cf:	0f 84 03 01 00 00    	je     80105ad8 <sys_unlink+0x168>
801059d5:	83 ec 08             	sub    $0x8,%esp
801059d8:	68 77 82 10 80       	push   $0x80108277
801059dd:	53                   	push   %ebx
801059de:	e8 3d cc ff ff       	call   80102620 <namecmp>
801059e3:	83 c4 10             	add    $0x10,%esp
801059e6:	85 c0                	test   %eax,%eax
801059e8:	0f 84 ea 00 00 00    	je     80105ad8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801059ee:	83 ec 04             	sub    $0x4,%esp
801059f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801059f4:	50                   	push   %eax
801059f5:	53                   	push   %ebx
801059f6:	56                   	push   %esi
801059f7:	e8 44 cc ff ff       	call   80102640 <dirlookup>
801059fc:	83 c4 10             	add    $0x10,%esp
801059ff:	89 c3                	mov    %eax,%ebx
80105a01:	85 c0                	test   %eax,%eax
80105a03:	0f 84 cf 00 00 00    	je     80105ad8 <sys_unlink+0x168>
  ilock(ip);
80105a09:	83 ec 0c             	sub    $0xc,%esp
80105a0c:	50                   	push   %eax
80105a0d:	e8 de c6 ff ff       	call   801020f0 <ilock>
  if(ip->nlink < 1)
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105a1a:	0f 8e 23 01 00 00    	jle    80105b43 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a20:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a25:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105a28:	74 66                	je     80105a90 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105a2a:	83 ec 04             	sub    $0x4,%esp
80105a2d:	6a 10                	push   $0x10
80105a2f:	6a 00                	push   $0x0
80105a31:	57                   	push   %edi
80105a32:	e8 c9 f5 ff ff       	call   80105000 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a37:	6a 10                	push   $0x10
80105a39:	ff 75 c4             	pushl  -0x3c(%ebp)
80105a3c:	57                   	push   %edi
80105a3d:	56                   	push   %esi
80105a3e:	e8 ad ca ff ff       	call   801024f0 <writei>
80105a43:	83 c4 20             	add    $0x20,%esp
80105a46:	83 f8 10             	cmp    $0x10,%eax
80105a49:	0f 85 e7 00 00 00    	jne    80105b36 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105a4f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a54:	0f 84 96 00 00 00    	je     80105af0 <sys_unlink+0x180>
  iunlockput(dp);
80105a5a:	83 ec 0c             	sub    $0xc,%esp
80105a5d:	56                   	push   %esi
80105a5e:	e8 2d c9 ff ff       	call   80102390 <iunlockput>
  ip->nlink--;
80105a63:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a68:	89 1c 24             	mov    %ebx,(%esp)
80105a6b:	e8 c0 c5 ff ff       	call   80102030 <iupdate>
  iunlockput(ip);
80105a70:	89 1c 24             	mov    %ebx,(%esp)
80105a73:	e8 18 c9 ff ff       	call   80102390 <iunlockput>
  end_op();
80105a78:	e8 b3 dc ff ff       	call   80103730 <end_op>
  return 0;
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	31 c0                	xor    %eax,%eax
}
80105a82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a85:	5b                   	pop    %ebx
80105a86:	5e                   	pop    %esi
80105a87:	5f                   	pop    %edi
80105a88:	5d                   	pop    %ebp
80105a89:	c3                   	ret    
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a90:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a94:	76 94                	jbe    80105a2a <sys_unlink+0xba>
80105a96:	ba 20 00 00 00       	mov    $0x20,%edx
80105a9b:	eb 0b                	jmp    80105aa8 <sys_unlink+0x138>
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi
80105aa0:	83 c2 10             	add    $0x10,%edx
80105aa3:	39 53 58             	cmp    %edx,0x58(%ebx)
80105aa6:	76 82                	jbe    80105a2a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105aa8:	6a 10                	push   $0x10
80105aaa:	52                   	push   %edx
80105aab:	57                   	push   %edi
80105aac:	53                   	push   %ebx
80105aad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105ab0:	e8 3b c9 ff ff       	call   801023f0 <readi>
80105ab5:	83 c4 10             	add    $0x10,%esp
80105ab8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105abb:	83 f8 10             	cmp    $0x10,%eax
80105abe:	75 69                	jne    80105b29 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105ac0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105ac5:	74 d9                	je     80105aa0 <sys_unlink+0x130>
    iunlockput(ip);
80105ac7:	83 ec 0c             	sub    $0xc,%esp
80105aca:	53                   	push   %ebx
80105acb:	e8 c0 c8 ff ff       	call   80102390 <iunlockput>
    goto bad;
80105ad0:	83 c4 10             	add    $0x10,%esp
80105ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ad7:	90                   	nop
  iunlockput(dp);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	56                   	push   %esi
80105adc:	e8 af c8 ff ff       	call   80102390 <iunlockput>
  end_op();
80105ae1:	e8 4a dc ff ff       	call   80103730 <end_op>
  return -1;
80105ae6:	83 c4 10             	add    $0x10,%esp
80105ae9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aee:	eb 92                	jmp    80105a82 <sys_unlink+0x112>
    iupdate(dp);
80105af0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105af3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105af8:	56                   	push   %esi
80105af9:	e8 32 c5 ff ff       	call   80102030 <iupdate>
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	e9 54 ff ff ff       	jmp    80105a5a <sys_unlink+0xea>
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b15:	e9 68 ff ff ff       	jmp    80105a82 <sys_unlink+0x112>
    end_op();
80105b1a:	e8 11 dc ff ff       	call   80103730 <end_op>
    return -1;
80105b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b24:	e9 59 ff ff ff       	jmp    80105a82 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105b29:	83 ec 0c             	sub    $0xc,%esp
80105b2c:	68 9c 82 10 80       	push   $0x8010829c
80105b31:	e8 5a a8 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105b36:	83 ec 0c             	sub    $0xc,%esp
80105b39:	68 ae 82 10 80       	push   $0x801082ae
80105b3e:	e8 4d a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105b43:	83 ec 0c             	sub    $0xc,%esp
80105b46:	68 8a 82 10 80       	push   $0x8010828a
80105b4b:	e8 40 a8 ff ff       	call   80100390 <panic>

80105b50 <sys_open>:

int
sys_open(void)
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	57                   	push   %edi
80105b58:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b59:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b5c:	53                   	push   %ebx
80105b5d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b60:	50                   	push   %eax
80105b61:	6a 00                	push   $0x0
80105b63:	e8 28 f8 ff ff       	call   80105390 <argstr>
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	85 c0                	test   %eax,%eax
80105b6d:	0f 88 8a 00 00 00    	js     80105bfd <sys_open+0xad>
80105b73:	83 ec 08             	sub    $0x8,%esp
80105b76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b79:	50                   	push   %eax
80105b7a:	6a 01                	push   $0x1
80105b7c:	e8 5f f7 ff ff       	call   801052e0 <argint>
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 75                	js     80105bfd <sys_open+0xad>
    return -1;

  begin_op();
80105b88:	e8 33 db ff ff       	call   801036c0 <begin_op>

  if(omode & O_CREATE){
80105b8d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b91:	75 75                	jne    80105c08 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b93:	83 ec 0c             	sub    $0xc,%esp
80105b96:	ff 75 e0             	pushl  -0x20(%ebp)
80105b99:	e8 22 ce ff ff       	call   801029c0 <namei>
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	89 c6                	mov    %eax,%esi
80105ba3:	85 c0                	test   %eax,%eax
80105ba5:	74 7e                	je     80105c25 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105ba7:	83 ec 0c             	sub    $0xc,%esp
80105baa:	50                   	push   %eax
80105bab:	e8 40 c5 ff ff       	call   801020f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105bb8:	0f 84 c2 00 00 00    	je     80105c80 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105bbe:	e8 cd bb ff ff       	call   80101790 <filealloc>
80105bc3:	89 c7                	mov    %eax,%edi
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	74 23                	je     80105bec <sys_open+0x9c>
  struct proc *curproc = myproc();
80105bc9:	e8 22 e7 ff ff       	call   801042f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105bd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105bd4:	85 d2                	test   %edx,%edx
80105bd6:	74 60                	je     80105c38 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105bd8:	83 c3 01             	add    $0x1,%ebx
80105bdb:	83 fb 10             	cmp    $0x10,%ebx
80105bde:	75 f0                	jne    80105bd0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105be0:	83 ec 0c             	sub    $0xc,%esp
80105be3:	57                   	push   %edi
80105be4:	e8 67 bc ff ff       	call   80101850 <fileclose>
80105be9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105bec:	83 ec 0c             	sub    $0xc,%esp
80105bef:	56                   	push   %esi
80105bf0:	e8 9b c7 ff ff       	call   80102390 <iunlockput>
    end_op();
80105bf5:	e8 36 db ff ff       	call   80103730 <end_op>
    return -1;
80105bfa:	83 c4 10             	add    $0x10,%esp
80105bfd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c02:	eb 6d                	jmp    80105c71 <sys_open+0x121>
80105c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105c08:	83 ec 0c             	sub    $0xc,%esp
80105c0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c0e:	31 c9                	xor    %ecx,%ecx
80105c10:	ba 02 00 00 00       	mov    $0x2,%edx
80105c15:	6a 00                	push   $0x0
80105c17:	e8 24 f8 ff ff       	call   80105440 <create>
    if(ip == 0){
80105c1c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105c1f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c21:	85 c0                	test   %eax,%eax
80105c23:	75 99                	jne    80105bbe <sys_open+0x6e>
      end_op();
80105c25:	e8 06 db ff ff       	call   80103730 <end_op>
      return -1;
80105c2a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c2f:	eb 40                	jmp    80105c71 <sys_open+0x121>
80105c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105c38:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105c3b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105c3f:	56                   	push   %esi
80105c40:	e8 8b c5 ff ff       	call   801021d0 <iunlock>
  end_op();
80105c45:	e8 e6 da ff ff       	call   80103730 <end_op>

  f->type = FD_INODE;
80105c4a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105c50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c53:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105c56:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105c59:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105c5b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105c62:	f7 d0                	not    %eax
80105c64:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c67:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105c6a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c6d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c74:	89 d8                	mov    %ebx,%eax
80105c76:	5b                   	pop    %ebx
80105c77:	5e                   	pop    %esi
80105c78:	5f                   	pop    %edi
80105c79:	5d                   	pop    %ebp
80105c7a:	c3                   	ret    
80105c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c80:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c83:	85 c9                	test   %ecx,%ecx
80105c85:	0f 84 33 ff ff ff    	je     80105bbe <sys_open+0x6e>
80105c8b:	e9 5c ff ff ff       	jmp    80105bec <sys_open+0x9c>

80105c90 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c9a:	e8 21 da ff ff       	call   801036c0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c9f:	83 ec 08             	sub    $0x8,%esp
80105ca2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ca5:	50                   	push   %eax
80105ca6:	6a 00                	push   $0x0
80105ca8:	e8 e3 f6 ff ff       	call   80105390 <argstr>
80105cad:	83 c4 10             	add    $0x10,%esp
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	78 34                	js     80105ce8 <sys_mkdir+0x58>
80105cb4:	83 ec 0c             	sub    $0xc,%esp
80105cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cba:	31 c9                	xor    %ecx,%ecx
80105cbc:	ba 01 00 00 00       	mov    $0x1,%edx
80105cc1:	6a 00                	push   $0x0
80105cc3:	e8 78 f7 ff ff       	call   80105440 <create>
80105cc8:	83 c4 10             	add    $0x10,%esp
80105ccb:	85 c0                	test   %eax,%eax
80105ccd:	74 19                	je     80105ce8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ccf:	83 ec 0c             	sub    $0xc,%esp
80105cd2:	50                   	push   %eax
80105cd3:	e8 b8 c6 ff ff       	call   80102390 <iunlockput>
  end_op();
80105cd8:	e8 53 da ff ff       	call   80103730 <end_op>
  return 0;
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	31 c0                	xor    %eax,%eax
}
80105ce2:	c9                   	leave  
80105ce3:	c3                   	ret    
80105ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ce8:	e8 43 da ff ff       	call   80103730 <end_op>
    return -1;
80105ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf2:	c9                   	leave  
80105cf3:	c3                   	ret    
80105cf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop

80105d00 <sys_mknod>:

int
sys_mknod(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105d0a:	e8 b1 d9 ff ff       	call   801036c0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105d0f:	83 ec 08             	sub    $0x8,%esp
80105d12:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d15:	50                   	push   %eax
80105d16:	6a 00                	push   $0x0
80105d18:	e8 73 f6 ff ff       	call   80105390 <argstr>
80105d1d:	83 c4 10             	add    $0x10,%esp
80105d20:	85 c0                	test   %eax,%eax
80105d22:	78 64                	js     80105d88 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105d24:	83 ec 08             	sub    $0x8,%esp
80105d27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d2a:	50                   	push   %eax
80105d2b:	6a 01                	push   $0x1
80105d2d:	e8 ae f5 ff ff       	call   801052e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 4f                	js     80105d88 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105d39:	83 ec 08             	sub    $0x8,%esp
80105d3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d3f:	50                   	push   %eax
80105d40:	6a 02                	push   $0x2
80105d42:	e8 99 f5 ff ff       	call   801052e0 <argint>
     argint(1, &major) < 0 ||
80105d47:	83 c4 10             	add    $0x10,%esp
80105d4a:	85 c0                	test   %eax,%eax
80105d4c:	78 3a                	js     80105d88 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d4e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105d52:	83 ec 0c             	sub    $0xc,%esp
80105d55:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105d59:	ba 03 00 00 00       	mov    $0x3,%edx
80105d5e:	50                   	push   %eax
80105d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d62:	e8 d9 f6 ff ff       	call   80105440 <create>
     argint(2, &minor) < 0 ||
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	85 c0                	test   %eax,%eax
80105d6c:	74 1a                	je     80105d88 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d6e:	83 ec 0c             	sub    $0xc,%esp
80105d71:	50                   	push   %eax
80105d72:	e8 19 c6 ff ff       	call   80102390 <iunlockput>
  end_op();
80105d77:	e8 b4 d9 ff ff       	call   80103730 <end_op>
  return 0;
80105d7c:	83 c4 10             	add    $0x10,%esp
80105d7f:	31 c0                	xor    %eax,%eax
}
80105d81:	c9                   	leave  
80105d82:	c3                   	ret    
80105d83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d87:	90                   	nop
    end_op();
80105d88:	e8 a3 d9 ff ff       	call   80103730 <end_op>
    return -1;
80105d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d92:	c9                   	leave  
80105d93:	c3                   	ret    
80105d94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop

80105da0 <sys_chdir>:

int
sys_chdir(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	56                   	push   %esi
80105da8:	53                   	push   %ebx
80105da9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105dac:	e8 3f e5 ff ff       	call   801042f0 <myproc>
80105db1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105db3:	e8 08 d9 ff ff       	call   801036c0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105db8:	83 ec 08             	sub    $0x8,%esp
80105dbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dbe:	50                   	push   %eax
80105dbf:	6a 00                	push   $0x0
80105dc1:	e8 ca f5 ff ff       	call   80105390 <argstr>
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	78 73                	js     80105e40 <sys_chdir+0xa0>
80105dcd:	83 ec 0c             	sub    $0xc,%esp
80105dd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd3:	e8 e8 cb ff ff       	call   801029c0 <namei>
80105dd8:	83 c4 10             	add    $0x10,%esp
80105ddb:	89 c3                	mov    %eax,%ebx
80105ddd:	85 c0                	test   %eax,%eax
80105ddf:	74 5f                	je     80105e40 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105de1:	83 ec 0c             	sub    $0xc,%esp
80105de4:	50                   	push   %eax
80105de5:	e8 06 c3 ff ff       	call   801020f0 <ilock>
  if(ip->type != T_DIR){
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105df2:	75 2c                	jne    80105e20 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105df4:	83 ec 0c             	sub    $0xc,%esp
80105df7:	53                   	push   %ebx
80105df8:	e8 d3 c3 ff ff       	call   801021d0 <iunlock>
  iput(curproc->cwd);
80105dfd:	58                   	pop    %eax
80105dfe:	ff 76 68             	pushl  0x68(%esi)
80105e01:	e8 1a c4 ff ff       	call   80102220 <iput>
  end_op();
80105e06:	e8 25 d9 ff ff       	call   80103730 <end_op>
  curproc->cwd = ip;
80105e0b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105e0e:	83 c4 10             	add    $0x10,%esp
80105e11:	31 c0                	xor    %eax,%eax
}
80105e13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e16:	5b                   	pop    %ebx
80105e17:	5e                   	pop    %esi
80105e18:	5d                   	pop    %ebp
80105e19:	c3                   	ret    
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e20:	83 ec 0c             	sub    $0xc,%esp
80105e23:	53                   	push   %ebx
80105e24:	e8 67 c5 ff ff       	call   80102390 <iunlockput>
    end_op();
80105e29:	e8 02 d9 ff ff       	call   80103730 <end_op>
    return -1;
80105e2e:	83 c4 10             	add    $0x10,%esp
80105e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e36:	eb db                	jmp    80105e13 <sys_chdir+0x73>
80105e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3f:	90                   	nop
    end_op();
80105e40:	e8 eb d8 ff ff       	call   80103730 <end_op>
    return -1;
80105e45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4a:	eb c7                	jmp    80105e13 <sys_chdir+0x73>
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e50 <sys_exec>:

int
sys_exec(void)
{
80105e50:	f3 0f 1e fb          	endbr32 
80105e54:	55                   	push   %ebp
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	57                   	push   %edi
80105e58:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e59:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105e5f:	53                   	push   %ebx
80105e60:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e66:	50                   	push   %eax
80105e67:	6a 00                	push   $0x0
80105e69:	e8 22 f5 ff ff       	call   80105390 <argstr>
80105e6e:	83 c4 10             	add    $0x10,%esp
80105e71:	85 c0                	test   %eax,%eax
80105e73:	0f 88 8b 00 00 00    	js     80105f04 <sys_exec+0xb4>
80105e79:	83 ec 08             	sub    $0x8,%esp
80105e7c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e82:	50                   	push   %eax
80105e83:	6a 01                	push   $0x1
80105e85:	e8 56 f4 ff ff       	call   801052e0 <argint>
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	85 c0                	test   %eax,%eax
80105e8f:	78 73                	js     80105f04 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e91:	83 ec 04             	sub    $0x4,%esp
80105e94:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105e9a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e9c:	68 80 00 00 00       	push   $0x80
80105ea1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ea7:	6a 00                	push   $0x0
80105ea9:	50                   	push   %eax
80105eaa:	e8 51 f1 ff ff       	call   80105000 <memset>
80105eaf:	83 c4 10             	add    $0x10,%esp
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105eb8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ebe:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ec5:	83 ec 08             	sub    $0x8,%esp
80105ec8:	57                   	push   %edi
80105ec9:	01 f0                	add    %esi,%eax
80105ecb:	50                   	push   %eax
80105ecc:	e8 6f f3 ff ff       	call   80105240 <fetchint>
80105ed1:	83 c4 10             	add    $0x10,%esp
80105ed4:	85 c0                	test   %eax,%eax
80105ed6:	78 2c                	js     80105f04 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105ed8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ede:	85 c0                	test   %eax,%eax
80105ee0:	74 36                	je     80105f18 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ee2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ee8:	83 ec 08             	sub    $0x8,%esp
80105eeb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105eee:	52                   	push   %edx
80105eef:	50                   	push   %eax
80105ef0:	e8 8b f3 ff ff       	call   80105280 <fetchstr>
80105ef5:	83 c4 10             	add    $0x10,%esp
80105ef8:	85 c0                	test   %eax,%eax
80105efa:	78 08                	js     80105f04 <sys_exec+0xb4>
  for(i=0;; i++){
80105efc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105eff:	83 fb 20             	cmp    $0x20,%ebx
80105f02:	75 b4                	jne    80105eb8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f0c:	5b                   	pop    %ebx
80105f0d:	5e                   	pop    %esi
80105f0e:	5f                   	pop    %edi
80105f0f:	5d                   	pop    %ebp
80105f10:	c3                   	ret    
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105f18:	83 ec 08             	sub    $0x8,%esp
80105f1b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105f21:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105f28:	00 00 00 00 
  return exec(path, argv);
80105f2c:	50                   	push   %eax
80105f2d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105f33:	e8 d8 b4 ff ff       	call   80101410 <exec>
80105f38:	83 c4 10             	add    $0x10,%esp
}
80105f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f3e:	5b                   	pop    %ebx
80105f3f:	5e                   	pop    %esi
80105f40:	5f                   	pop    %edi
80105f41:	5d                   	pop    %ebp
80105f42:	c3                   	ret    
80105f43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f50 <sys_pipe>:

int
sys_pipe(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
80105f54:	55                   	push   %ebp
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	57                   	push   %edi
80105f58:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f59:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105f5c:	53                   	push   %ebx
80105f5d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f60:	6a 08                	push   $0x8
80105f62:	50                   	push   %eax
80105f63:	6a 00                	push   $0x0
80105f65:	e8 c6 f3 ff ff       	call   80105330 <argptr>
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	78 4e                	js     80105fbf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f71:	83 ec 08             	sub    $0x8,%esp
80105f74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f77:	50                   	push   %eax
80105f78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f7b:	50                   	push   %eax
80105f7c:	e8 ff dd ff ff       	call   80103d80 <pipealloc>
80105f81:	83 c4 10             	add    $0x10,%esp
80105f84:	85 c0                	test   %eax,%eax
80105f86:	78 37                	js     80105fbf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f88:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f8b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f8d:	e8 5e e3 ff ff       	call   801042f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105f98:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f9c:	85 f6                	test   %esi,%esi
80105f9e:	74 30                	je     80105fd0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105fa0:	83 c3 01             	add    $0x1,%ebx
80105fa3:	83 fb 10             	cmp    $0x10,%ebx
80105fa6:	75 f0                	jne    80105f98 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	ff 75 e0             	pushl  -0x20(%ebp)
80105fae:	e8 9d b8 ff ff       	call   80101850 <fileclose>
    fileclose(wf);
80105fb3:	58                   	pop    %eax
80105fb4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fb7:	e8 94 b8 ff ff       	call   80101850 <fileclose>
    return -1;
80105fbc:	83 c4 10             	add    $0x10,%esp
80105fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc4:	eb 5b                	jmp    80106021 <sys_pipe+0xd1>
80105fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105fd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105fd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105fda:	e8 11 e3 ff ff       	call   801042f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105fdf:	31 d2                	xor    %edx,%edx
80105fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105fe8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105fec:	85 c9                	test   %ecx,%ecx
80105fee:	74 20                	je     80106010 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105ff0:	83 c2 01             	add    $0x1,%edx
80105ff3:	83 fa 10             	cmp    $0x10,%edx
80105ff6:	75 f0                	jne    80105fe8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ff8:	e8 f3 e2 ff ff       	call   801042f0 <myproc>
80105ffd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106004:	00 
80106005:	eb a1                	jmp    80105fa8 <sys_pipe+0x58>
80106007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106010:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106014:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106017:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106019:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010601c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010601f:	31 c0                	xor    %eax,%eax
}
80106021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106024:	5b                   	pop    %ebx
80106025:	5e                   	pop    %esi
80106026:	5f                   	pop    %edi
80106027:	5d                   	pop    %ebp
80106028:	c3                   	ret    
80106029:	66 90                	xchg   %ax,%ax
8010602b:	66 90                	xchg   %ax,%ax
8010602d:	66 90                	xchg   %ax,%ax
8010602f:	90                   	nop

80106030 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106030:	f3 0f 1e fb          	endbr32 
  return fork();
80106034:	e9 67 e4 ff ff       	jmp    801044a0 <fork>
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106040 <sys_exit>:
}

int
sys_exit(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	83 ec 08             	sub    $0x8,%esp
  exit();
8010604a:	e8 d1 e6 ff ff       	call   80104720 <exit>
  return 0;  // not reached
}
8010604f:	31 c0                	xor    %eax,%eax
80106051:	c9                   	leave  
80106052:	c3                   	ret    
80106053:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106060 <sys_wait>:

int
sys_wait(void)
{
80106060:	f3 0f 1e fb          	endbr32 
  return wait();
80106064:	e9 07 e9 ff ff       	jmp    80104970 <wait>
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_kill>:
}

int
sys_kill(void)
{
80106070:	f3 0f 1e fb          	endbr32 
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010607a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010607d:	50                   	push   %eax
8010607e:	6a 00                	push   $0x0
80106080:	e8 5b f2 ff ff       	call   801052e0 <argint>
80106085:	83 c4 10             	add    $0x10,%esp
80106088:	85 c0                	test   %eax,%eax
8010608a:	78 14                	js     801060a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010608c:	83 ec 0c             	sub    $0xc,%esp
8010608f:	ff 75 f4             	pushl  -0xc(%ebp)
80106092:	e8 39 ea ff ff       	call   80104ad0 <kill>
80106097:	83 c4 10             	add    $0x10,%esp
}
8010609a:	c9                   	leave  
8010609b:	c3                   	ret    
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060a0:	c9                   	leave  
    return -1;
801060a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060a6:	c3                   	ret    
801060a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <sys_getpid>:

int
sys_getpid(void)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801060ba:	e8 31 e2 ff ff       	call   801042f0 <myproc>
801060bf:	8b 40 10             	mov    0x10(%eax),%eax
}
801060c2:	c9                   	leave  
801060c3:	c3                   	ret    
801060c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop

801060d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060db:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060de:	50                   	push   %eax
801060df:	6a 00                	push   $0x0
801060e1:	e8 fa f1 ff ff       	call   801052e0 <argint>
801060e6:	83 c4 10             	add    $0x10,%esp
801060e9:	85 c0                	test   %eax,%eax
801060eb:	78 23                	js     80106110 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801060ed:	e8 fe e1 ff ff       	call   801042f0 <myproc>
  if(growproc(n) < 0)
801060f2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801060f5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801060f7:	ff 75 f4             	pushl  -0xc(%ebp)
801060fa:	e8 21 e3 ff ff       	call   80104420 <growproc>
801060ff:	83 c4 10             	add    $0x10,%esp
80106102:	85 c0                	test   %eax,%eax
80106104:	78 0a                	js     80106110 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106106:	89 d8                	mov    %ebx,%eax
80106108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010610b:	c9                   	leave  
8010610c:	c3                   	ret    
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106110:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106115:	eb ef                	jmp    80106106 <sys_sbrk+0x36>
80106117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611e:	66 90                	xchg   %ax,%ax

80106120 <sys_sleep>:

int
sys_sleep(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
80106125:	89 e5                	mov    %esp,%ebp
80106127:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106128:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010612b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010612e:	50                   	push   %eax
8010612f:	6a 00                	push   $0x0
80106131:	e8 aa f1 ff ff       	call   801052e0 <argint>
80106136:	83 c4 10             	add    $0x10,%esp
80106139:	85 c0                	test   %eax,%eax
8010613b:	0f 88 86 00 00 00    	js     801061c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106141:	83 ec 0c             	sub    $0xc,%esp
80106144:	68 60 66 11 80       	push   $0x80116660
80106149:	e8 a2 ed ff ff       	call   80104ef0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010614e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106151:	8b 1d a0 6e 11 80    	mov    0x80116ea0,%ebx
  while(ticks - ticks0 < n){
80106157:	83 c4 10             	add    $0x10,%esp
8010615a:	85 d2                	test   %edx,%edx
8010615c:	75 23                	jne    80106181 <sys_sleep+0x61>
8010615e:	eb 50                	jmp    801061b0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106160:	83 ec 08             	sub    $0x8,%esp
80106163:	68 60 66 11 80       	push   $0x80116660
80106168:	68 a0 6e 11 80       	push   $0x80116ea0
8010616d:	e8 3e e7 ff ff       	call   801048b0 <sleep>
  while(ticks - ticks0 < n){
80106172:	a1 a0 6e 11 80       	mov    0x80116ea0,%eax
80106177:	83 c4 10             	add    $0x10,%esp
8010617a:	29 d8                	sub    %ebx,%eax
8010617c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010617f:	73 2f                	jae    801061b0 <sys_sleep+0x90>
    if(myproc()->killed){
80106181:	e8 6a e1 ff ff       	call   801042f0 <myproc>
80106186:	8b 40 24             	mov    0x24(%eax),%eax
80106189:	85 c0                	test   %eax,%eax
8010618b:	74 d3                	je     80106160 <sys_sleep+0x40>
      release(&tickslock);
8010618d:	83 ec 0c             	sub    $0xc,%esp
80106190:	68 60 66 11 80       	push   $0x80116660
80106195:	e8 16 ee ff ff       	call   80104fb0 <release>
  }
  release(&tickslock);
  return 0;
}
8010619a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010619d:	83 c4 10             	add    $0x10,%esp
801061a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061a5:	c9                   	leave  
801061a6:	c3                   	ret    
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801061b0:	83 ec 0c             	sub    $0xc,%esp
801061b3:	68 60 66 11 80       	push   $0x80116660
801061b8:	e8 f3 ed ff ff       	call   80104fb0 <release>
  return 0;
801061bd:	83 c4 10             	add    $0x10,%esp
801061c0:	31 c0                	xor    %eax,%eax
}
801061c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061c5:	c9                   	leave  
801061c6:	c3                   	ret    
    return -1;
801061c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061cc:	eb f4                	jmp    801061c2 <sys_sleep+0xa2>
801061ce:	66 90                	xchg   %ax,%ax

801061d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061d0:	f3 0f 1e fb          	endbr32 
801061d4:	55                   	push   %ebp
801061d5:	89 e5                	mov    %esp,%ebp
801061d7:	53                   	push   %ebx
801061d8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801061db:	68 60 66 11 80       	push   $0x80116660
801061e0:	e8 0b ed ff ff       	call   80104ef0 <acquire>
  xticks = ticks;
801061e5:	8b 1d a0 6e 11 80    	mov    0x80116ea0,%ebx
  release(&tickslock);
801061eb:	c7 04 24 60 66 11 80 	movl   $0x80116660,(%esp)
801061f2:	e8 b9 ed ff ff       	call   80104fb0 <release>
  return xticks;
}
801061f7:	89 d8                	mov    %ebx,%eax
801061f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061fc:	c9                   	leave  
801061fd:	c3                   	ret    
801061fe:	66 90                	xchg   %ax,%ax

80106200 <sys_draw>:

int sys_draw(void) {
80106200:	f3 0f 1e fb          	endbr32 
80106204:	55                   	push   %ebp
80106205:	89 e5                	mov    %esp,%ebp
80106207:	56                   	push   %esi
80106208:	53                   	push   %ebx
                      $o$$P\"                 $$o$\n\n";

    // Will store the size of ASCII image
    int ascii_size = 0;

    if (argint(1, &size) == -1) {return -1;}
80106209:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_draw(void) {
8010620c:	83 ec 18             	sub    $0x18,%esp
    if (argint(1, &size) == -1) {return -1;}
8010620f:	50                   	push   %eax
80106210:	6a 01                	push   $0x1
80106212:	e8 c9 f0 ff ff       	call   801052e0 <argint>
80106217:	83 c4 10             	add    $0x10,%esp
8010621a:	83 f8 ff             	cmp    $0xffffffff,%eax
8010621d:	74 5e                	je     8010627d <sys_draw+0x7d>
    if (argptr(0, (char **)&buffer, size) == -1) {return -1;}
8010621f:	83 ec 04             	sub    $0x4,%esp
80106222:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106225:	ff 75 f4             	pushl  -0xc(%ebp)
80106228:	50                   	push   %eax
80106229:	6a 00                	push   $0x0
8010622b:	e8 00 f1 ff ff       	call   80105330 <argptr>
80106230:	83 c4 10             	add    $0x10,%esp
80106233:	83 f8 ff             	cmp    $0xffffffff,%eax
80106236:	74 45                	je     8010627d <sys_draw+0x7d>
    int ascii_size = 0;
80106238:	31 d2                	xor    %edx,%edx
8010623a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    // Finding the size of ASCII image
    while (ascii_img[ascii_size] != '\0') {
        ascii_size++;
80106240:	83 c2 01             	add    $0x1,%edx
    while (ascii_img[ascii_size] != '\0') {
80106243:	80 ba c0 82 10 80 00 	cmpb   $0x0,-0x7fef7d40(%edx)
8010624a:	75 f4                	jne    80106240 <sys_draw+0x40>
    }
    // If buffer size is small then its an ERROR
    if (size < ascii_size) {return -1;}
8010624c:	39 55 f4             	cmp    %edx,-0xc(%ebp)
8010624f:	7c 2c                	jl     8010627d <sys_draw+0x7d>
80106251:	89 d1                	mov    %edx,%ecx
80106253:	bb 20 00 00 00       	mov    $0x20,%ebx
    // Copying into buffer
    for(int i=0;i<ascii_size;i++){
80106258:	31 c0                	xor    %eax,%eax
8010625a:	eb 0b                	jmp    80106267 <sys_draw+0x67>
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106260:	0f b6 98 c0 82 10 80 	movzbl -0x7fef7d40(%eax),%ebx
      buffer[i]=ascii_img[i];
80106267:	8b 75 f0             	mov    -0x10(%ebp),%esi
8010626a:	88 1c 06             	mov    %bl,(%esi,%eax,1)
    for(int i=0;i<ascii_size;i++){
8010626d:	83 c0 01             	add    $0x1,%eax
80106270:	39 c8                	cmp    %ecx,%eax
80106272:	75 ec                	jne    80106260 <sys_draw+0x60>
    }
    // Returning the size of the ASCII image as asked in the exercise
    return ascii_size;
80106274:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106277:	89 d0                	mov    %edx,%eax
80106279:	5b                   	pop    %ebx
8010627a:	5e                   	pop    %esi
8010627b:	5d                   	pop    %ebp
8010627c:	c3                   	ret    
    if (argint(1, &size) == -1) {return -1;}
8010627d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106282:	eb f0                	jmp    80106274 <sys_draw+0x74>

80106284 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106284:	1e                   	push   %ds
  pushl %es
80106285:	06                   	push   %es
  pushl %fs
80106286:	0f a0                	push   %fs
  pushl %gs
80106288:	0f a8                	push   %gs
  pushal
8010628a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010628b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010628f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106291:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106293:	54                   	push   %esp
  call trap
80106294:	e8 c7 00 00 00       	call   80106360 <trap>
  addl $4, %esp
80106299:	83 c4 04             	add    $0x4,%esp

8010629c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010629c:	61                   	popa   
  popl %gs
8010629d:	0f a9                	pop    %gs
  popl %fs
8010629f:	0f a1                	pop    %fs
  popl %es
801062a1:	07                   	pop    %es
  popl %ds
801062a2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062a3:	83 c4 08             	add    $0x8,%esp
  iret
801062a6:	cf                   	iret   
801062a7:	66 90                	xchg   %ax,%ax
801062a9:	66 90                	xchg   %ax,%ax
801062ab:	66 90                	xchg   %ax,%ax
801062ad:	66 90                	xchg   %ax,%ax
801062af:	90                   	nop

801062b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801062b0:	f3 0f 1e fb          	endbr32 
801062b4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801062b5:	31 c0                	xor    %eax,%eax
{
801062b7:	89 e5                	mov    %esp,%ebp
801062b9:	83 ec 08             	sub    $0x8,%esp
801062bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062c0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801062c7:	c7 04 c5 a2 66 11 80 	movl   $0x8e000008,-0x7fee995e(,%eax,8)
801062ce:	08 00 00 8e 
801062d2:	66 89 14 c5 a0 66 11 	mov    %dx,-0x7fee9960(,%eax,8)
801062d9:	80 
801062da:	c1 ea 10             	shr    $0x10,%edx
801062dd:	66 89 14 c5 a6 66 11 	mov    %dx,-0x7fee995a(,%eax,8)
801062e4:	80 
  for(i = 0; i < 256; i++)
801062e5:	83 c0 01             	add    $0x1,%eax
801062e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062ed:	75 d1                	jne    801062c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801062ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062f2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801062f7:	c7 05 a2 68 11 80 08 	movl   $0xef000008,0x801168a2
801062fe:	00 00 ef 
  initlock(&tickslock, "time");
80106301:	68 e9 88 10 80       	push   $0x801088e9
80106306:	68 60 66 11 80       	push   $0x80116660
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010630b:	66 a3 a0 68 11 80    	mov    %ax,0x801168a0
80106311:	c1 e8 10             	shr    $0x10,%eax
80106314:	66 a3 a6 68 11 80    	mov    %ax,0x801168a6
  initlock(&tickslock, "time");
8010631a:	e8 51 ea ff ff       	call   80104d70 <initlock>
}
8010631f:	83 c4 10             	add    $0x10,%esp
80106322:	c9                   	leave  
80106323:	c3                   	ret    
80106324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010632b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010632f:	90                   	nop

80106330 <idtinit>:

void
idtinit(void)
{
80106330:	f3 0f 1e fb          	endbr32 
80106334:	55                   	push   %ebp
  pd[0] = size-1;
80106335:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010633a:	89 e5                	mov    %esp,%ebp
8010633c:	83 ec 10             	sub    $0x10,%esp
8010633f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106343:	b8 a0 66 11 80       	mov    $0x801166a0,%eax
80106348:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010634c:	c1 e8 10             	shr    $0x10,%eax
8010634f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106353:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106356:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106359:	c9                   	leave  
8010635a:	c3                   	ret    
8010635b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010635f:	90                   	nop

80106360 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106360:	f3 0f 1e fb          	endbr32 
80106364:	55                   	push   %ebp
80106365:	89 e5                	mov    %esp,%ebp
80106367:	57                   	push   %edi
80106368:	56                   	push   %esi
80106369:	53                   	push   %ebx
8010636a:	83 ec 1c             	sub    $0x1c,%esp
8010636d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106370:	8b 43 30             	mov    0x30(%ebx),%eax
80106373:	83 f8 40             	cmp    $0x40,%eax
80106376:	0f 84 bc 01 00 00    	je     80106538 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010637c:	83 e8 20             	sub    $0x20,%eax
8010637f:	83 f8 1f             	cmp    $0x1f,%eax
80106382:	77 08                	ja     8010638c <trap+0x2c>
80106384:	3e ff 24 85 90 89 10 	notrack jmp *-0x7fef7670(,%eax,4)
8010638b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010638c:	e8 5f df ff ff       	call   801042f0 <myproc>
80106391:	8b 7b 38             	mov    0x38(%ebx),%edi
80106394:	85 c0                	test   %eax,%eax
80106396:	0f 84 eb 01 00 00    	je     80106587 <trap+0x227>
8010639c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801063a0:	0f 84 e1 01 00 00    	je     80106587 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801063a6:	0f 20 d1             	mov    %cr2,%ecx
801063a9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ac:	e8 1f df ff ff       	call   801042d0 <cpuid>
801063b1:	8b 73 30             	mov    0x30(%ebx),%esi
801063b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063b7:	8b 43 34             	mov    0x34(%ebx),%eax
801063ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063bd:	e8 2e df ff ff       	call   801042f0 <myproc>
801063c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063c5:	e8 26 df ff ff       	call   801042f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ca:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063d0:	51                   	push   %ecx
801063d1:	57                   	push   %edi
801063d2:	52                   	push   %edx
801063d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801063d6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063d7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063da:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063dd:	56                   	push   %esi
801063de:	ff 70 10             	pushl  0x10(%eax)
801063e1:	68 4c 89 10 80       	push   $0x8010894c
801063e6:	e8 05 a3 ff ff       	call   801006f0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063eb:	83 c4 20             	add    $0x20,%esp
801063ee:	e8 fd de ff ff       	call   801042f0 <myproc>
801063f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063fa:	e8 f1 de ff ff       	call   801042f0 <myproc>
801063ff:	85 c0                	test   %eax,%eax
80106401:	74 1d                	je     80106420 <trap+0xc0>
80106403:	e8 e8 de ff ff       	call   801042f0 <myproc>
80106408:	8b 50 24             	mov    0x24(%eax),%edx
8010640b:	85 d2                	test   %edx,%edx
8010640d:	74 11                	je     80106420 <trap+0xc0>
8010640f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106413:	83 e0 03             	and    $0x3,%eax
80106416:	66 83 f8 03          	cmp    $0x3,%ax
8010641a:	0f 84 50 01 00 00    	je     80106570 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106420:	e8 cb de ff ff       	call   801042f0 <myproc>
80106425:	85 c0                	test   %eax,%eax
80106427:	74 0f                	je     80106438 <trap+0xd8>
80106429:	e8 c2 de ff ff       	call   801042f0 <myproc>
8010642e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106432:	0f 84 e8 00 00 00    	je     80106520 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106438:	e8 b3 de ff ff       	call   801042f0 <myproc>
8010643d:	85 c0                	test   %eax,%eax
8010643f:	74 1d                	je     8010645e <trap+0xfe>
80106441:	e8 aa de ff ff       	call   801042f0 <myproc>
80106446:	8b 40 24             	mov    0x24(%eax),%eax
80106449:	85 c0                	test   %eax,%eax
8010644b:	74 11                	je     8010645e <trap+0xfe>
8010644d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106451:	83 e0 03             	and    $0x3,%eax
80106454:	66 83 f8 03          	cmp    $0x3,%ax
80106458:	0f 84 03 01 00 00    	je     80106561 <trap+0x201>
    exit();
}
8010645e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106461:	5b                   	pop    %ebx
80106462:	5e                   	pop    %esi
80106463:	5f                   	pop    %edi
80106464:	5d                   	pop    %ebp
80106465:	c3                   	ret    
    ideintr();
80106466:	e8 05 c7 ff ff       	call   80102b70 <ideintr>
    lapiceoi();
8010646b:	e8 e0 cd ff ff       	call   80103250 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106470:	e8 7b de ff ff       	call   801042f0 <myproc>
80106475:	85 c0                	test   %eax,%eax
80106477:	75 8a                	jne    80106403 <trap+0xa3>
80106479:	eb a5                	jmp    80106420 <trap+0xc0>
    if(cpuid() == 0){
8010647b:	e8 50 de ff ff       	call   801042d0 <cpuid>
80106480:	85 c0                	test   %eax,%eax
80106482:	75 e7                	jne    8010646b <trap+0x10b>
      acquire(&tickslock);
80106484:	83 ec 0c             	sub    $0xc,%esp
80106487:	68 60 66 11 80       	push   $0x80116660
8010648c:	e8 5f ea ff ff       	call   80104ef0 <acquire>
      wakeup(&ticks);
80106491:	c7 04 24 a0 6e 11 80 	movl   $0x80116ea0,(%esp)
      ticks++;
80106498:	83 05 a0 6e 11 80 01 	addl   $0x1,0x80116ea0
      wakeup(&ticks);
8010649f:	e8 cc e5 ff ff       	call   80104a70 <wakeup>
      release(&tickslock);
801064a4:	c7 04 24 60 66 11 80 	movl   $0x80116660,(%esp)
801064ab:	e8 00 eb ff ff       	call   80104fb0 <release>
801064b0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801064b3:	eb b6                	jmp    8010646b <trap+0x10b>
    kbdintr();
801064b5:	e8 56 cc ff ff       	call   80103110 <kbdintr>
    lapiceoi();
801064ba:	e8 91 cd ff ff       	call   80103250 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064bf:	e8 2c de ff ff       	call   801042f0 <myproc>
801064c4:	85 c0                	test   %eax,%eax
801064c6:	0f 85 37 ff ff ff    	jne    80106403 <trap+0xa3>
801064cc:	e9 4f ff ff ff       	jmp    80106420 <trap+0xc0>
    uartintr();
801064d1:	e8 4a 02 00 00       	call   80106720 <uartintr>
    lapiceoi();
801064d6:	e8 75 cd ff ff       	call   80103250 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064db:	e8 10 de ff ff       	call   801042f0 <myproc>
801064e0:	85 c0                	test   %eax,%eax
801064e2:	0f 85 1b ff ff ff    	jne    80106403 <trap+0xa3>
801064e8:	e9 33 ff ff ff       	jmp    80106420 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064ed:	8b 7b 38             	mov    0x38(%ebx),%edi
801064f0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064f4:	e8 d7 dd ff ff       	call   801042d0 <cpuid>
801064f9:	57                   	push   %edi
801064fa:	56                   	push   %esi
801064fb:	50                   	push   %eax
801064fc:	68 f4 88 10 80       	push   $0x801088f4
80106501:	e8 ea a1 ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80106506:	e8 45 cd ff ff       	call   80103250 <lapiceoi>
    break;
8010650b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010650e:	e8 dd dd ff ff       	call   801042f0 <myproc>
80106513:	85 c0                	test   %eax,%eax
80106515:	0f 85 e8 fe ff ff    	jne    80106403 <trap+0xa3>
8010651b:	e9 00 ff ff ff       	jmp    80106420 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106520:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106524:	0f 85 0e ff ff ff    	jne    80106438 <trap+0xd8>
    yield();
8010652a:	e8 31 e3 ff ff       	call   80104860 <yield>
8010652f:	e9 04 ff ff ff       	jmp    80106438 <trap+0xd8>
80106534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106538:	e8 b3 dd ff ff       	call   801042f0 <myproc>
8010653d:	8b 70 24             	mov    0x24(%eax),%esi
80106540:	85 f6                	test   %esi,%esi
80106542:	75 3c                	jne    80106580 <trap+0x220>
    myproc()->tf = tf;
80106544:	e8 a7 dd ff ff       	call   801042f0 <myproc>
80106549:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010654c:	e8 7f ee ff ff       	call   801053d0 <syscall>
    if(myproc()->killed)
80106551:	e8 9a dd ff ff       	call   801042f0 <myproc>
80106556:	8b 48 24             	mov    0x24(%eax),%ecx
80106559:	85 c9                	test   %ecx,%ecx
8010655b:	0f 84 fd fe ff ff    	je     8010645e <trap+0xfe>
}
80106561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106564:	5b                   	pop    %ebx
80106565:	5e                   	pop    %esi
80106566:	5f                   	pop    %edi
80106567:	5d                   	pop    %ebp
      exit();
80106568:	e9 b3 e1 ff ff       	jmp    80104720 <exit>
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106570:	e8 ab e1 ff ff       	call   80104720 <exit>
80106575:	e9 a6 fe ff ff       	jmp    80106420 <trap+0xc0>
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106580:	e8 9b e1 ff ff       	call   80104720 <exit>
80106585:	eb bd                	jmp    80106544 <trap+0x1e4>
80106587:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010658a:	e8 41 dd ff ff       	call   801042d0 <cpuid>
8010658f:	83 ec 0c             	sub    $0xc,%esp
80106592:	56                   	push   %esi
80106593:	57                   	push   %edi
80106594:	50                   	push   %eax
80106595:	ff 73 30             	pushl  0x30(%ebx)
80106598:	68 18 89 10 80       	push   $0x80108918
8010659d:	e8 4e a1 ff ff       	call   801006f0 <cprintf>
      panic("trap");
801065a2:	83 c4 14             	add    $0x14,%esp
801065a5:	68 ee 88 10 80       	push   $0x801088ee
801065aa:	e8 e1 9d ff ff       	call   80100390 <panic>
801065af:	90                   	nop

801065b0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801065b0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801065b4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801065b9:	85 c0                	test   %eax,%eax
801065bb:	74 1b                	je     801065d8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065bd:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065c2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065c3:	a8 01                	test   $0x1,%al
801065c5:	74 11                	je     801065d8 <uartgetc+0x28>
801065c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065cc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801065cd:	0f b6 c0             	movzbl %al,%eax
801065d0:	c3                   	ret    
801065d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801065d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065dd:	c3                   	ret    
801065de:	66 90                	xchg   %ax,%ax

801065e0 <uartputc.part.0>:
uartputc(int c)
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	89 c7                	mov    %eax,%edi
801065e6:	56                   	push   %esi
801065e7:	be fd 03 00 00       	mov    $0x3fd,%esi
801065ec:	53                   	push   %ebx
801065ed:	bb 80 00 00 00       	mov    $0x80,%ebx
801065f2:	83 ec 0c             	sub    $0xc,%esp
801065f5:	eb 1b                	jmp    80106612 <uartputc.part.0+0x32>
801065f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065fe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106600:	83 ec 0c             	sub    $0xc,%esp
80106603:	6a 0a                	push   $0xa
80106605:	e8 66 cc ff ff       	call   80103270 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010660a:	83 c4 10             	add    $0x10,%esp
8010660d:	83 eb 01             	sub    $0x1,%ebx
80106610:	74 07                	je     80106619 <uartputc.part.0+0x39>
80106612:	89 f2                	mov    %esi,%edx
80106614:	ec                   	in     (%dx),%al
80106615:	a8 20                	test   $0x20,%al
80106617:	74 e7                	je     80106600 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106619:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010661e:	89 f8                	mov    %edi,%eax
80106620:	ee                   	out    %al,(%dx)
}
80106621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106624:	5b                   	pop    %ebx
80106625:	5e                   	pop    %esi
80106626:	5f                   	pop    %edi
80106627:	5d                   	pop    %ebp
80106628:	c3                   	ret    
80106629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106630 <uartinit>:
{
80106630:	f3 0f 1e fb          	endbr32 
80106634:	55                   	push   %ebp
80106635:	31 c9                	xor    %ecx,%ecx
80106637:	89 c8                	mov    %ecx,%eax
80106639:	89 e5                	mov    %esp,%ebp
8010663b:	57                   	push   %edi
8010663c:	56                   	push   %esi
8010663d:	53                   	push   %ebx
8010663e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106643:	89 da                	mov    %ebx,%edx
80106645:	83 ec 0c             	sub    $0xc,%esp
80106648:	ee                   	out    %al,(%dx)
80106649:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010664e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106653:	89 fa                	mov    %edi,%edx
80106655:	ee                   	out    %al,(%dx)
80106656:	b8 0c 00 00 00       	mov    $0xc,%eax
8010665b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106660:	ee                   	out    %al,(%dx)
80106661:	be f9 03 00 00       	mov    $0x3f9,%esi
80106666:	89 c8                	mov    %ecx,%eax
80106668:	89 f2                	mov    %esi,%edx
8010666a:	ee                   	out    %al,(%dx)
8010666b:	b8 03 00 00 00       	mov    $0x3,%eax
80106670:	89 fa                	mov    %edi,%edx
80106672:	ee                   	out    %al,(%dx)
80106673:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106678:	89 c8                	mov    %ecx,%eax
8010667a:	ee                   	out    %al,(%dx)
8010667b:	b8 01 00 00 00       	mov    $0x1,%eax
80106680:	89 f2                	mov    %esi,%edx
80106682:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106683:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106688:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106689:	3c ff                	cmp    $0xff,%al
8010668b:	74 52                	je     801066df <uartinit+0xaf>
  uart = 1;
8010668d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106694:	00 00 00 
80106697:	89 da                	mov    %ebx,%edx
80106699:	ec                   	in     (%dx),%al
8010669a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010669f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801066a0:	83 ec 08             	sub    $0x8,%esp
801066a3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801066a8:	bb 10 8a 10 80       	mov    $0x80108a10,%ebx
  ioapicenable(IRQ_COM1, 0);
801066ad:	6a 00                	push   $0x0
801066af:	6a 04                	push   $0x4
801066b1:	e8 0a c7 ff ff       	call   80102dc0 <ioapicenable>
801066b6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801066b9:	b8 78 00 00 00       	mov    $0x78,%eax
801066be:	eb 04                	jmp    801066c4 <uartinit+0x94>
801066c0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801066c4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801066ca:	85 d2                	test   %edx,%edx
801066cc:	74 08                	je     801066d6 <uartinit+0xa6>
    uartputc(*p);
801066ce:	0f be c0             	movsbl %al,%eax
801066d1:	e8 0a ff ff ff       	call   801065e0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801066d6:	89 f0                	mov    %esi,%eax
801066d8:	83 c3 01             	add    $0x1,%ebx
801066db:	84 c0                	test   %al,%al
801066dd:	75 e1                	jne    801066c0 <uartinit+0x90>
}
801066df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066e2:	5b                   	pop    %ebx
801066e3:	5e                   	pop    %esi
801066e4:	5f                   	pop    %edi
801066e5:	5d                   	pop    %ebp
801066e6:	c3                   	ret    
801066e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ee:	66 90                	xchg   %ax,%ax

801066f0 <uartputc>:
{
801066f0:	f3 0f 1e fb          	endbr32 
801066f4:	55                   	push   %ebp
  if(!uart)
801066f5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801066fb:	89 e5                	mov    %esp,%ebp
801066fd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106700:	85 d2                	test   %edx,%edx
80106702:	74 0c                	je     80106710 <uartputc+0x20>
}
80106704:	5d                   	pop    %ebp
80106705:	e9 d6 fe ff ff       	jmp    801065e0 <uartputc.part.0>
8010670a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106710:	5d                   	pop    %ebp
80106711:	c3                   	ret    
80106712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106720 <uartintr>:

void
uartintr(void)
{
80106720:	f3 0f 1e fb          	endbr32 
80106724:	55                   	push   %ebp
80106725:	89 e5                	mov    %esp,%ebp
80106727:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010672a:	68 b0 65 10 80       	push   $0x801065b0
8010672f:	e8 1c a5 ff ff       	call   80100c50 <consoleintr>
}
80106734:	83 c4 10             	add    $0x10,%esp
80106737:	c9                   	leave  
80106738:	c3                   	ret    

80106739 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $0
8010673b:	6a 00                	push   $0x0
  jmp alltraps
8010673d:	e9 42 fb ff ff       	jmp    80106284 <alltraps>

80106742 <vector1>:
.globl vector1
vector1:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $1
80106744:	6a 01                	push   $0x1
  jmp alltraps
80106746:	e9 39 fb ff ff       	jmp    80106284 <alltraps>

8010674b <vector2>:
.globl vector2
vector2:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $2
8010674d:	6a 02                	push   $0x2
  jmp alltraps
8010674f:	e9 30 fb ff ff       	jmp    80106284 <alltraps>

80106754 <vector3>:
.globl vector3
vector3:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $3
80106756:	6a 03                	push   $0x3
  jmp alltraps
80106758:	e9 27 fb ff ff       	jmp    80106284 <alltraps>

8010675d <vector4>:
.globl vector4
vector4:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $4
8010675f:	6a 04                	push   $0x4
  jmp alltraps
80106761:	e9 1e fb ff ff       	jmp    80106284 <alltraps>

80106766 <vector5>:
.globl vector5
vector5:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $5
80106768:	6a 05                	push   $0x5
  jmp alltraps
8010676a:	e9 15 fb ff ff       	jmp    80106284 <alltraps>

8010676f <vector6>:
.globl vector6
vector6:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $6
80106771:	6a 06                	push   $0x6
  jmp alltraps
80106773:	e9 0c fb ff ff       	jmp    80106284 <alltraps>

80106778 <vector7>:
.globl vector7
vector7:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $7
8010677a:	6a 07                	push   $0x7
  jmp alltraps
8010677c:	e9 03 fb ff ff       	jmp    80106284 <alltraps>

80106781 <vector8>:
.globl vector8
vector8:
  pushl $8
80106781:	6a 08                	push   $0x8
  jmp alltraps
80106783:	e9 fc fa ff ff       	jmp    80106284 <alltraps>

80106788 <vector9>:
.globl vector9
vector9:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $9
8010678a:	6a 09                	push   $0x9
  jmp alltraps
8010678c:	e9 f3 fa ff ff       	jmp    80106284 <alltraps>

80106791 <vector10>:
.globl vector10
vector10:
  pushl $10
80106791:	6a 0a                	push   $0xa
  jmp alltraps
80106793:	e9 ec fa ff ff       	jmp    80106284 <alltraps>

80106798 <vector11>:
.globl vector11
vector11:
  pushl $11
80106798:	6a 0b                	push   $0xb
  jmp alltraps
8010679a:	e9 e5 fa ff ff       	jmp    80106284 <alltraps>

8010679f <vector12>:
.globl vector12
vector12:
  pushl $12
8010679f:	6a 0c                	push   $0xc
  jmp alltraps
801067a1:	e9 de fa ff ff       	jmp    80106284 <alltraps>

801067a6 <vector13>:
.globl vector13
vector13:
  pushl $13
801067a6:	6a 0d                	push   $0xd
  jmp alltraps
801067a8:	e9 d7 fa ff ff       	jmp    80106284 <alltraps>

801067ad <vector14>:
.globl vector14
vector14:
  pushl $14
801067ad:	6a 0e                	push   $0xe
  jmp alltraps
801067af:	e9 d0 fa ff ff       	jmp    80106284 <alltraps>

801067b4 <vector15>:
.globl vector15
vector15:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $15
801067b6:	6a 0f                	push   $0xf
  jmp alltraps
801067b8:	e9 c7 fa ff ff       	jmp    80106284 <alltraps>

801067bd <vector16>:
.globl vector16
vector16:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $16
801067bf:	6a 10                	push   $0x10
  jmp alltraps
801067c1:	e9 be fa ff ff       	jmp    80106284 <alltraps>

801067c6 <vector17>:
.globl vector17
vector17:
  pushl $17
801067c6:	6a 11                	push   $0x11
  jmp alltraps
801067c8:	e9 b7 fa ff ff       	jmp    80106284 <alltraps>

801067cd <vector18>:
.globl vector18
vector18:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $18
801067cf:	6a 12                	push   $0x12
  jmp alltraps
801067d1:	e9 ae fa ff ff       	jmp    80106284 <alltraps>

801067d6 <vector19>:
.globl vector19
vector19:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $19
801067d8:	6a 13                	push   $0x13
  jmp alltraps
801067da:	e9 a5 fa ff ff       	jmp    80106284 <alltraps>

801067df <vector20>:
.globl vector20
vector20:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $20
801067e1:	6a 14                	push   $0x14
  jmp alltraps
801067e3:	e9 9c fa ff ff       	jmp    80106284 <alltraps>

801067e8 <vector21>:
.globl vector21
vector21:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $21
801067ea:	6a 15                	push   $0x15
  jmp alltraps
801067ec:	e9 93 fa ff ff       	jmp    80106284 <alltraps>

801067f1 <vector22>:
.globl vector22
vector22:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $22
801067f3:	6a 16                	push   $0x16
  jmp alltraps
801067f5:	e9 8a fa ff ff       	jmp    80106284 <alltraps>

801067fa <vector23>:
.globl vector23
vector23:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $23
801067fc:	6a 17                	push   $0x17
  jmp alltraps
801067fe:	e9 81 fa ff ff       	jmp    80106284 <alltraps>

80106803 <vector24>:
.globl vector24
vector24:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $24
80106805:	6a 18                	push   $0x18
  jmp alltraps
80106807:	e9 78 fa ff ff       	jmp    80106284 <alltraps>

8010680c <vector25>:
.globl vector25
vector25:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $25
8010680e:	6a 19                	push   $0x19
  jmp alltraps
80106810:	e9 6f fa ff ff       	jmp    80106284 <alltraps>

80106815 <vector26>:
.globl vector26
vector26:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $26
80106817:	6a 1a                	push   $0x1a
  jmp alltraps
80106819:	e9 66 fa ff ff       	jmp    80106284 <alltraps>

8010681e <vector27>:
.globl vector27
vector27:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $27
80106820:	6a 1b                	push   $0x1b
  jmp alltraps
80106822:	e9 5d fa ff ff       	jmp    80106284 <alltraps>

80106827 <vector28>:
.globl vector28
vector28:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $28
80106829:	6a 1c                	push   $0x1c
  jmp alltraps
8010682b:	e9 54 fa ff ff       	jmp    80106284 <alltraps>

80106830 <vector29>:
.globl vector29
vector29:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $29
80106832:	6a 1d                	push   $0x1d
  jmp alltraps
80106834:	e9 4b fa ff ff       	jmp    80106284 <alltraps>

80106839 <vector30>:
.globl vector30
vector30:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $30
8010683b:	6a 1e                	push   $0x1e
  jmp alltraps
8010683d:	e9 42 fa ff ff       	jmp    80106284 <alltraps>

80106842 <vector31>:
.globl vector31
vector31:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $31
80106844:	6a 1f                	push   $0x1f
  jmp alltraps
80106846:	e9 39 fa ff ff       	jmp    80106284 <alltraps>

8010684b <vector32>:
.globl vector32
vector32:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $32
8010684d:	6a 20                	push   $0x20
  jmp alltraps
8010684f:	e9 30 fa ff ff       	jmp    80106284 <alltraps>

80106854 <vector33>:
.globl vector33
vector33:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $33
80106856:	6a 21                	push   $0x21
  jmp alltraps
80106858:	e9 27 fa ff ff       	jmp    80106284 <alltraps>

8010685d <vector34>:
.globl vector34
vector34:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $34
8010685f:	6a 22                	push   $0x22
  jmp alltraps
80106861:	e9 1e fa ff ff       	jmp    80106284 <alltraps>

80106866 <vector35>:
.globl vector35
vector35:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $35
80106868:	6a 23                	push   $0x23
  jmp alltraps
8010686a:	e9 15 fa ff ff       	jmp    80106284 <alltraps>

8010686f <vector36>:
.globl vector36
vector36:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $36
80106871:	6a 24                	push   $0x24
  jmp alltraps
80106873:	e9 0c fa ff ff       	jmp    80106284 <alltraps>

80106878 <vector37>:
.globl vector37
vector37:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $37
8010687a:	6a 25                	push   $0x25
  jmp alltraps
8010687c:	e9 03 fa ff ff       	jmp    80106284 <alltraps>

80106881 <vector38>:
.globl vector38
vector38:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $38
80106883:	6a 26                	push   $0x26
  jmp alltraps
80106885:	e9 fa f9 ff ff       	jmp    80106284 <alltraps>

8010688a <vector39>:
.globl vector39
vector39:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $39
8010688c:	6a 27                	push   $0x27
  jmp alltraps
8010688e:	e9 f1 f9 ff ff       	jmp    80106284 <alltraps>

80106893 <vector40>:
.globl vector40
vector40:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $40
80106895:	6a 28                	push   $0x28
  jmp alltraps
80106897:	e9 e8 f9 ff ff       	jmp    80106284 <alltraps>

8010689c <vector41>:
.globl vector41
vector41:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $41
8010689e:	6a 29                	push   $0x29
  jmp alltraps
801068a0:	e9 df f9 ff ff       	jmp    80106284 <alltraps>

801068a5 <vector42>:
.globl vector42
vector42:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $42
801068a7:	6a 2a                	push   $0x2a
  jmp alltraps
801068a9:	e9 d6 f9 ff ff       	jmp    80106284 <alltraps>

801068ae <vector43>:
.globl vector43
vector43:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $43
801068b0:	6a 2b                	push   $0x2b
  jmp alltraps
801068b2:	e9 cd f9 ff ff       	jmp    80106284 <alltraps>

801068b7 <vector44>:
.globl vector44
vector44:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $44
801068b9:	6a 2c                	push   $0x2c
  jmp alltraps
801068bb:	e9 c4 f9 ff ff       	jmp    80106284 <alltraps>

801068c0 <vector45>:
.globl vector45
vector45:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $45
801068c2:	6a 2d                	push   $0x2d
  jmp alltraps
801068c4:	e9 bb f9 ff ff       	jmp    80106284 <alltraps>

801068c9 <vector46>:
.globl vector46
vector46:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $46
801068cb:	6a 2e                	push   $0x2e
  jmp alltraps
801068cd:	e9 b2 f9 ff ff       	jmp    80106284 <alltraps>

801068d2 <vector47>:
.globl vector47
vector47:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $47
801068d4:	6a 2f                	push   $0x2f
  jmp alltraps
801068d6:	e9 a9 f9 ff ff       	jmp    80106284 <alltraps>

801068db <vector48>:
.globl vector48
vector48:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $48
801068dd:	6a 30                	push   $0x30
  jmp alltraps
801068df:	e9 a0 f9 ff ff       	jmp    80106284 <alltraps>

801068e4 <vector49>:
.globl vector49
vector49:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $49
801068e6:	6a 31                	push   $0x31
  jmp alltraps
801068e8:	e9 97 f9 ff ff       	jmp    80106284 <alltraps>

801068ed <vector50>:
.globl vector50
vector50:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $50
801068ef:	6a 32                	push   $0x32
  jmp alltraps
801068f1:	e9 8e f9 ff ff       	jmp    80106284 <alltraps>

801068f6 <vector51>:
.globl vector51
vector51:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $51
801068f8:	6a 33                	push   $0x33
  jmp alltraps
801068fa:	e9 85 f9 ff ff       	jmp    80106284 <alltraps>

801068ff <vector52>:
.globl vector52
vector52:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $52
80106901:	6a 34                	push   $0x34
  jmp alltraps
80106903:	e9 7c f9 ff ff       	jmp    80106284 <alltraps>

80106908 <vector53>:
.globl vector53
vector53:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $53
8010690a:	6a 35                	push   $0x35
  jmp alltraps
8010690c:	e9 73 f9 ff ff       	jmp    80106284 <alltraps>

80106911 <vector54>:
.globl vector54
vector54:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $54
80106913:	6a 36                	push   $0x36
  jmp alltraps
80106915:	e9 6a f9 ff ff       	jmp    80106284 <alltraps>

8010691a <vector55>:
.globl vector55
vector55:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $55
8010691c:	6a 37                	push   $0x37
  jmp alltraps
8010691e:	e9 61 f9 ff ff       	jmp    80106284 <alltraps>

80106923 <vector56>:
.globl vector56
vector56:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $56
80106925:	6a 38                	push   $0x38
  jmp alltraps
80106927:	e9 58 f9 ff ff       	jmp    80106284 <alltraps>

8010692c <vector57>:
.globl vector57
vector57:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $57
8010692e:	6a 39                	push   $0x39
  jmp alltraps
80106930:	e9 4f f9 ff ff       	jmp    80106284 <alltraps>

80106935 <vector58>:
.globl vector58
vector58:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $58
80106937:	6a 3a                	push   $0x3a
  jmp alltraps
80106939:	e9 46 f9 ff ff       	jmp    80106284 <alltraps>

8010693e <vector59>:
.globl vector59
vector59:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $59
80106940:	6a 3b                	push   $0x3b
  jmp alltraps
80106942:	e9 3d f9 ff ff       	jmp    80106284 <alltraps>

80106947 <vector60>:
.globl vector60
vector60:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $60
80106949:	6a 3c                	push   $0x3c
  jmp alltraps
8010694b:	e9 34 f9 ff ff       	jmp    80106284 <alltraps>

80106950 <vector61>:
.globl vector61
vector61:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $61
80106952:	6a 3d                	push   $0x3d
  jmp alltraps
80106954:	e9 2b f9 ff ff       	jmp    80106284 <alltraps>

80106959 <vector62>:
.globl vector62
vector62:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $62
8010695b:	6a 3e                	push   $0x3e
  jmp alltraps
8010695d:	e9 22 f9 ff ff       	jmp    80106284 <alltraps>

80106962 <vector63>:
.globl vector63
vector63:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $63
80106964:	6a 3f                	push   $0x3f
  jmp alltraps
80106966:	e9 19 f9 ff ff       	jmp    80106284 <alltraps>

8010696b <vector64>:
.globl vector64
vector64:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $64
8010696d:	6a 40                	push   $0x40
  jmp alltraps
8010696f:	e9 10 f9 ff ff       	jmp    80106284 <alltraps>

80106974 <vector65>:
.globl vector65
vector65:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $65
80106976:	6a 41                	push   $0x41
  jmp alltraps
80106978:	e9 07 f9 ff ff       	jmp    80106284 <alltraps>

8010697d <vector66>:
.globl vector66
vector66:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $66
8010697f:	6a 42                	push   $0x42
  jmp alltraps
80106981:	e9 fe f8 ff ff       	jmp    80106284 <alltraps>

80106986 <vector67>:
.globl vector67
vector67:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $67
80106988:	6a 43                	push   $0x43
  jmp alltraps
8010698a:	e9 f5 f8 ff ff       	jmp    80106284 <alltraps>

8010698f <vector68>:
.globl vector68
vector68:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $68
80106991:	6a 44                	push   $0x44
  jmp alltraps
80106993:	e9 ec f8 ff ff       	jmp    80106284 <alltraps>

80106998 <vector69>:
.globl vector69
vector69:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $69
8010699a:	6a 45                	push   $0x45
  jmp alltraps
8010699c:	e9 e3 f8 ff ff       	jmp    80106284 <alltraps>

801069a1 <vector70>:
.globl vector70
vector70:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $70
801069a3:	6a 46                	push   $0x46
  jmp alltraps
801069a5:	e9 da f8 ff ff       	jmp    80106284 <alltraps>

801069aa <vector71>:
.globl vector71
vector71:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $71
801069ac:	6a 47                	push   $0x47
  jmp alltraps
801069ae:	e9 d1 f8 ff ff       	jmp    80106284 <alltraps>

801069b3 <vector72>:
.globl vector72
vector72:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $72
801069b5:	6a 48                	push   $0x48
  jmp alltraps
801069b7:	e9 c8 f8 ff ff       	jmp    80106284 <alltraps>

801069bc <vector73>:
.globl vector73
vector73:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $73
801069be:	6a 49                	push   $0x49
  jmp alltraps
801069c0:	e9 bf f8 ff ff       	jmp    80106284 <alltraps>

801069c5 <vector74>:
.globl vector74
vector74:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $74
801069c7:	6a 4a                	push   $0x4a
  jmp alltraps
801069c9:	e9 b6 f8 ff ff       	jmp    80106284 <alltraps>

801069ce <vector75>:
.globl vector75
vector75:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $75
801069d0:	6a 4b                	push   $0x4b
  jmp alltraps
801069d2:	e9 ad f8 ff ff       	jmp    80106284 <alltraps>

801069d7 <vector76>:
.globl vector76
vector76:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $76
801069d9:	6a 4c                	push   $0x4c
  jmp alltraps
801069db:	e9 a4 f8 ff ff       	jmp    80106284 <alltraps>

801069e0 <vector77>:
.globl vector77
vector77:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $77
801069e2:	6a 4d                	push   $0x4d
  jmp alltraps
801069e4:	e9 9b f8 ff ff       	jmp    80106284 <alltraps>

801069e9 <vector78>:
.globl vector78
vector78:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $78
801069eb:	6a 4e                	push   $0x4e
  jmp alltraps
801069ed:	e9 92 f8 ff ff       	jmp    80106284 <alltraps>

801069f2 <vector79>:
.globl vector79
vector79:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $79
801069f4:	6a 4f                	push   $0x4f
  jmp alltraps
801069f6:	e9 89 f8 ff ff       	jmp    80106284 <alltraps>

801069fb <vector80>:
.globl vector80
vector80:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $80
801069fd:	6a 50                	push   $0x50
  jmp alltraps
801069ff:	e9 80 f8 ff ff       	jmp    80106284 <alltraps>

80106a04 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $81
80106a06:	6a 51                	push   $0x51
  jmp alltraps
80106a08:	e9 77 f8 ff ff       	jmp    80106284 <alltraps>

80106a0d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $82
80106a0f:	6a 52                	push   $0x52
  jmp alltraps
80106a11:	e9 6e f8 ff ff       	jmp    80106284 <alltraps>

80106a16 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $83
80106a18:	6a 53                	push   $0x53
  jmp alltraps
80106a1a:	e9 65 f8 ff ff       	jmp    80106284 <alltraps>

80106a1f <vector84>:
.globl vector84
vector84:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $84
80106a21:	6a 54                	push   $0x54
  jmp alltraps
80106a23:	e9 5c f8 ff ff       	jmp    80106284 <alltraps>

80106a28 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $85
80106a2a:	6a 55                	push   $0x55
  jmp alltraps
80106a2c:	e9 53 f8 ff ff       	jmp    80106284 <alltraps>

80106a31 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $86
80106a33:	6a 56                	push   $0x56
  jmp alltraps
80106a35:	e9 4a f8 ff ff       	jmp    80106284 <alltraps>

80106a3a <vector87>:
.globl vector87
vector87:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $87
80106a3c:	6a 57                	push   $0x57
  jmp alltraps
80106a3e:	e9 41 f8 ff ff       	jmp    80106284 <alltraps>

80106a43 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $88
80106a45:	6a 58                	push   $0x58
  jmp alltraps
80106a47:	e9 38 f8 ff ff       	jmp    80106284 <alltraps>

80106a4c <vector89>:
.globl vector89
vector89:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $89
80106a4e:	6a 59                	push   $0x59
  jmp alltraps
80106a50:	e9 2f f8 ff ff       	jmp    80106284 <alltraps>

80106a55 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $90
80106a57:	6a 5a                	push   $0x5a
  jmp alltraps
80106a59:	e9 26 f8 ff ff       	jmp    80106284 <alltraps>

80106a5e <vector91>:
.globl vector91
vector91:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $91
80106a60:	6a 5b                	push   $0x5b
  jmp alltraps
80106a62:	e9 1d f8 ff ff       	jmp    80106284 <alltraps>

80106a67 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $92
80106a69:	6a 5c                	push   $0x5c
  jmp alltraps
80106a6b:	e9 14 f8 ff ff       	jmp    80106284 <alltraps>

80106a70 <vector93>:
.globl vector93
vector93:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $93
80106a72:	6a 5d                	push   $0x5d
  jmp alltraps
80106a74:	e9 0b f8 ff ff       	jmp    80106284 <alltraps>

80106a79 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $94
80106a7b:	6a 5e                	push   $0x5e
  jmp alltraps
80106a7d:	e9 02 f8 ff ff       	jmp    80106284 <alltraps>

80106a82 <vector95>:
.globl vector95
vector95:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $95
80106a84:	6a 5f                	push   $0x5f
  jmp alltraps
80106a86:	e9 f9 f7 ff ff       	jmp    80106284 <alltraps>

80106a8b <vector96>:
.globl vector96
vector96:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $96
80106a8d:	6a 60                	push   $0x60
  jmp alltraps
80106a8f:	e9 f0 f7 ff ff       	jmp    80106284 <alltraps>

80106a94 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $97
80106a96:	6a 61                	push   $0x61
  jmp alltraps
80106a98:	e9 e7 f7 ff ff       	jmp    80106284 <alltraps>

80106a9d <vector98>:
.globl vector98
vector98:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $98
80106a9f:	6a 62                	push   $0x62
  jmp alltraps
80106aa1:	e9 de f7 ff ff       	jmp    80106284 <alltraps>

80106aa6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $99
80106aa8:	6a 63                	push   $0x63
  jmp alltraps
80106aaa:	e9 d5 f7 ff ff       	jmp    80106284 <alltraps>

80106aaf <vector100>:
.globl vector100
vector100:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $100
80106ab1:	6a 64                	push   $0x64
  jmp alltraps
80106ab3:	e9 cc f7 ff ff       	jmp    80106284 <alltraps>

80106ab8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $101
80106aba:	6a 65                	push   $0x65
  jmp alltraps
80106abc:	e9 c3 f7 ff ff       	jmp    80106284 <alltraps>

80106ac1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $102
80106ac3:	6a 66                	push   $0x66
  jmp alltraps
80106ac5:	e9 ba f7 ff ff       	jmp    80106284 <alltraps>

80106aca <vector103>:
.globl vector103
vector103:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $103
80106acc:	6a 67                	push   $0x67
  jmp alltraps
80106ace:	e9 b1 f7 ff ff       	jmp    80106284 <alltraps>

80106ad3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $104
80106ad5:	6a 68                	push   $0x68
  jmp alltraps
80106ad7:	e9 a8 f7 ff ff       	jmp    80106284 <alltraps>

80106adc <vector105>:
.globl vector105
vector105:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $105
80106ade:	6a 69                	push   $0x69
  jmp alltraps
80106ae0:	e9 9f f7 ff ff       	jmp    80106284 <alltraps>

80106ae5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $106
80106ae7:	6a 6a                	push   $0x6a
  jmp alltraps
80106ae9:	e9 96 f7 ff ff       	jmp    80106284 <alltraps>

80106aee <vector107>:
.globl vector107
vector107:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $107
80106af0:	6a 6b                	push   $0x6b
  jmp alltraps
80106af2:	e9 8d f7 ff ff       	jmp    80106284 <alltraps>

80106af7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $108
80106af9:	6a 6c                	push   $0x6c
  jmp alltraps
80106afb:	e9 84 f7 ff ff       	jmp    80106284 <alltraps>

80106b00 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $109
80106b02:	6a 6d                	push   $0x6d
  jmp alltraps
80106b04:	e9 7b f7 ff ff       	jmp    80106284 <alltraps>

80106b09 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $110
80106b0b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b0d:	e9 72 f7 ff ff       	jmp    80106284 <alltraps>

80106b12 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $111
80106b14:	6a 6f                	push   $0x6f
  jmp alltraps
80106b16:	e9 69 f7 ff ff       	jmp    80106284 <alltraps>

80106b1b <vector112>:
.globl vector112
vector112:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $112
80106b1d:	6a 70                	push   $0x70
  jmp alltraps
80106b1f:	e9 60 f7 ff ff       	jmp    80106284 <alltraps>

80106b24 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $113
80106b26:	6a 71                	push   $0x71
  jmp alltraps
80106b28:	e9 57 f7 ff ff       	jmp    80106284 <alltraps>

80106b2d <vector114>:
.globl vector114
vector114:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $114
80106b2f:	6a 72                	push   $0x72
  jmp alltraps
80106b31:	e9 4e f7 ff ff       	jmp    80106284 <alltraps>

80106b36 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $115
80106b38:	6a 73                	push   $0x73
  jmp alltraps
80106b3a:	e9 45 f7 ff ff       	jmp    80106284 <alltraps>

80106b3f <vector116>:
.globl vector116
vector116:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $116
80106b41:	6a 74                	push   $0x74
  jmp alltraps
80106b43:	e9 3c f7 ff ff       	jmp    80106284 <alltraps>

80106b48 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $117
80106b4a:	6a 75                	push   $0x75
  jmp alltraps
80106b4c:	e9 33 f7 ff ff       	jmp    80106284 <alltraps>

80106b51 <vector118>:
.globl vector118
vector118:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $118
80106b53:	6a 76                	push   $0x76
  jmp alltraps
80106b55:	e9 2a f7 ff ff       	jmp    80106284 <alltraps>

80106b5a <vector119>:
.globl vector119
vector119:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $119
80106b5c:	6a 77                	push   $0x77
  jmp alltraps
80106b5e:	e9 21 f7 ff ff       	jmp    80106284 <alltraps>

80106b63 <vector120>:
.globl vector120
vector120:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $120
80106b65:	6a 78                	push   $0x78
  jmp alltraps
80106b67:	e9 18 f7 ff ff       	jmp    80106284 <alltraps>

80106b6c <vector121>:
.globl vector121
vector121:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $121
80106b6e:	6a 79                	push   $0x79
  jmp alltraps
80106b70:	e9 0f f7 ff ff       	jmp    80106284 <alltraps>

80106b75 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $122
80106b77:	6a 7a                	push   $0x7a
  jmp alltraps
80106b79:	e9 06 f7 ff ff       	jmp    80106284 <alltraps>

80106b7e <vector123>:
.globl vector123
vector123:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $123
80106b80:	6a 7b                	push   $0x7b
  jmp alltraps
80106b82:	e9 fd f6 ff ff       	jmp    80106284 <alltraps>

80106b87 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $124
80106b89:	6a 7c                	push   $0x7c
  jmp alltraps
80106b8b:	e9 f4 f6 ff ff       	jmp    80106284 <alltraps>

80106b90 <vector125>:
.globl vector125
vector125:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $125
80106b92:	6a 7d                	push   $0x7d
  jmp alltraps
80106b94:	e9 eb f6 ff ff       	jmp    80106284 <alltraps>

80106b99 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $126
80106b9b:	6a 7e                	push   $0x7e
  jmp alltraps
80106b9d:	e9 e2 f6 ff ff       	jmp    80106284 <alltraps>

80106ba2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $127
80106ba4:	6a 7f                	push   $0x7f
  jmp alltraps
80106ba6:	e9 d9 f6 ff ff       	jmp    80106284 <alltraps>

80106bab <vector128>:
.globl vector128
vector128:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $128
80106bad:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106bb2:	e9 cd f6 ff ff       	jmp    80106284 <alltraps>

80106bb7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $129
80106bb9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106bbe:	e9 c1 f6 ff ff       	jmp    80106284 <alltraps>

80106bc3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $130
80106bc5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106bca:	e9 b5 f6 ff ff       	jmp    80106284 <alltraps>

80106bcf <vector131>:
.globl vector131
vector131:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $131
80106bd1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106bd6:	e9 a9 f6 ff ff       	jmp    80106284 <alltraps>

80106bdb <vector132>:
.globl vector132
vector132:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $132
80106bdd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106be2:	e9 9d f6 ff ff       	jmp    80106284 <alltraps>

80106be7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $133
80106be9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106bee:	e9 91 f6 ff ff       	jmp    80106284 <alltraps>

80106bf3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $134
80106bf5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106bfa:	e9 85 f6 ff ff       	jmp    80106284 <alltraps>

80106bff <vector135>:
.globl vector135
vector135:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $135
80106c01:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c06:	e9 79 f6 ff ff       	jmp    80106284 <alltraps>

80106c0b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $136
80106c0d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c12:	e9 6d f6 ff ff       	jmp    80106284 <alltraps>

80106c17 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $137
80106c19:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c1e:	e9 61 f6 ff ff       	jmp    80106284 <alltraps>

80106c23 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $138
80106c25:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c2a:	e9 55 f6 ff ff       	jmp    80106284 <alltraps>

80106c2f <vector139>:
.globl vector139
vector139:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $139
80106c31:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c36:	e9 49 f6 ff ff       	jmp    80106284 <alltraps>

80106c3b <vector140>:
.globl vector140
vector140:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $140
80106c3d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c42:	e9 3d f6 ff ff       	jmp    80106284 <alltraps>

80106c47 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $141
80106c49:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c4e:	e9 31 f6 ff ff       	jmp    80106284 <alltraps>

80106c53 <vector142>:
.globl vector142
vector142:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $142
80106c55:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c5a:	e9 25 f6 ff ff       	jmp    80106284 <alltraps>

80106c5f <vector143>:
.globl vector143
vector143:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $143
80106c61:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c66:	e9 19 f6 ff ff       	jmp    80106284 <alltraps>

80106c6b <vector144>:
.globl vector144
vector144:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $144
80106c6d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c72:	e9 0d f6 ff ff       	jmp    80106284 <alltraps>

80106c77 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $145
80106c79:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c7e:	e9 01 f6 ff ff       	jmp    80106284 <alltraps>

80106c83 <vector146>:
.globl vector146
vector146:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $146
80106c85:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c8a:	e9 f5 f5 ff ff       	jmp    80106284 <alltraps>

80106c8f <vector147>:
.globl vector147
vector147:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $147
80106c91:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c96:	e9 e9 f5 ff ff       	jmp    80106284 <alltraps>

80106c9b <vector148>:
.globl vector148
vector148:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $148
80106c9d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ca2:	e9 dd f5 ff ff       	jmp    80106284 <alltraps>

80106ca7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $149
80106ca9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cae:	e9 d1 f5 ff ff       	jmp    80106284 <alltraps>

80106cb3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $150
80106cb5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cba:	e9 c5 f5 ff ff       	jmp    80106284 <alltraps>

80106cbf <vector151>:
.globl vector151
vector151:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $151
80106cc1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106cc6:	e9 b9 f5 ff ff       	jmp    80106284 <alltraps>

80106ccb <vector152>:
.globl vector152
vector152:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $152
80106ccd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106cd2:	e9 ad f5 ff ff       	jmp    80106284 <alltraps>

80106cd7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $153
80106cd9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106cde:	e9 a1 f5 ff ff       	jmp    80106284 <alltraps>

80106ce3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $154
80106ce5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106cea:	e9 95 f5 ff ff       	jmp    80106284 <alltraps>

80106cef <vector155>:
.globl vector155
vector155:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $155
80106cf1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106cf6:	e9 89 f5 ff ff       	jmp    80106284 <alltraps>

80106cfb <vector156>:
.globl vector156
vector156:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $156
80106cfd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d02:	e9 7d f5 ff ff       	jmp    80106284 <alltraps>

80106d07 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $157
80106d09:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d0e:	e9 71 f5 ff ff       	jmp    80106284 <alltraps>

80106d13 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $158
80106d15:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d1a:	e9 65 f5 ff ff       	jmp    80106284 <alltraps>

80106d1f <vector159>:
.globl vector159
vector159:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $159
80106d21:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d26:	e9 59 f5 ff ff       	jmp    80106284 <alltraps>

80106d2b <vector160>:
.globl vector160
vector160:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $160
80106d2d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d32:	e9 4d f5 ff ff       	jmp    80106284 <alltraps>

80106d37 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $161
80106d39:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d3e:	e9 41 f5 ff ff       	jmp    80106284 <alltraps>

80106d43 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $162
80106d45:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d4a:	e9 35 f5 ff ff       	jmp    80106284 <alltraps>

80106d4f <vector163>:
.globl vector163
vector163:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $163
80106d51:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d56:	e9 29 f5 ff ff       	jmp    80106284 <alltraps>

80106d5b <vector164>:
.globl vector164
vector164:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $164
80106d5d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d62:	e9 1d f5 ff ff       	jmp    80106284 <alltraps>

80106d67 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $165
80106d69:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d6e:	e9 11 f5 ff ff       	jmp    80106284 <alltraps>

80106d73 <vector166>:
.globl vector166
vector166:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $166
80106d75:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d7a:	e9 05 f5 ff ff       	jmp    80106284 <alltraps>

80106d7f <vector167>:
.globl vector167
vector167:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $167
80106d81:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d86:	e9 f9 f4 ff ff       	jmp    80106284 <alltraps>

80106d8b <vector168>:
.globl vector168
vector168:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $168
80106d8d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d92:	e9 ed f4 ff ff       	jmp    80106284 <alltraps>

80106d97 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $169
80106d99:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d9e:	e9 e1 f4 ff ff       	jmp    80106284 <alltraps>

80106da3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $170
80106da5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106daa:	e9 d5 f4 ff ff       	jmp    80106284 <alltraps>

80106daf <vector171>:
.globl vector171
vector171:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $171
80106db1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106db6:	e9 c9 f4 ff ff       	jmp    80106284 <alltraps>

80106dbb <vector172>:
.globl vector172
vector172:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $172
80106dbd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106dc2:	e9 bd f4 ff ff       	jmp    80106284 <alltraps>

80106dc7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $173
80106dc9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dce:	e9 b1 f4 ff ff       	jmp    80106284 <alltraps>

80106dd3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $174
80106dd5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106dda:	e9 a5 f4 ff ff       	jmp    80106284 <alltraps>

80106ddf <vector175>:
.globl vector175
vector175:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $175
80106de1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106de6:	e9 99 f4 ff ff       	jmp    80106284 <alltraps>

80106deb <vector176>:
.globl vector176
vector176:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $176
80106ded:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106df2:	e9 8d f4 ff ff       	jmp    80106284 <alltraps>

80106df7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $177
80106df9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106dfe:	e9 81 f4 ff ff       	jmp    80106284 <alltraps>

80106e03 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $178
80106e05:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e0a:	e9 75 f4 ff ff       	jmp    80106284 <alltraps>

80106e0f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $179
80106e11:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e16:	e9 69 f4 ff ff       	jmp    80106284 <alltraps>

80106e1b <vector180>:
.globl vector180
vector180:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $180
80106e1d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e22:	e9 5d f4 ff ff       	jmp    80106284 <alltraps>

80106e27 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $181
80106e29:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e2e:	e9 51 f4 ff ff       	jmp    80106284 <alltraps>

80106e33 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $182
80106e35:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e3a:	e9 45 f4 ff ff       	jmp    80106284 <alltraps>

80106e3f <vector183>:
.globl vector183
vector183:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $183
80106e41:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e46:	e9 39 f4 ff ff       	jmp    80106284 <alltraps>

80106e4b <vector184>:
.globl vector184
vector184:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $184
80106e4d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e52:	e9 2d f4 ff ff       	jmp    80106284 <alltraps>

80106e57 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $185
80106e59:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e5e:	e9 21 f4 ff ff       	jmp    80106284 <alltraps>

80106e63 <vector186>:
.globl vector186
vector186:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $186
80106e65:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e6a:	e9 15 f4 ff ff       	jmp    80106284 <alltraps>

80106e6f <vector187>:
.globl vector187
vector187:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $187
80106e71:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e76:	e9 09 f4 ff ff       	jmp    80106284 <alltraps>

80106e7b <vector188>:
.globl vector188
vector188:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $188
80106e7d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e82:	e9 fd f3 ff ff       	jmp    80106284 <alltraps>

80106e87 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $189
80106e89:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e8e:	e9 f1 f3 ff ff       	jmp    80106284 <alltraps>

80106e93 <vector190>:
.globl vector190
vector190:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $190
80106e95:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e9a:	e9 e5 f3 ff ff       	jmp    80106284 <alltraps>

80106e9f <vector191>:
.globl vector191
vector191:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $191
80106ea1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ea6:	e9 d9 f3 ff ff       	jmp    80106284 <alltraps>

80106eab <vector192>:
.globl vector192
vector192:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $192
80106ead:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106eb2:	e9 cd f3 ff ff       	jmp    80106284 <alltraps>

80106eb7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $193
80106eb9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106ebe:	e9 c1 f3 ff ff       	jmp    80106284 <alltraps>

80106ec3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $194
80106ec5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106eca:	e9 b5 f3 ff ff       	jmp    80106284 <alltraps>

80106ecf <vector195>:
.globl vector195
vector195:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $195
80106ed1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ed6:	e9 a9 f3 ff ff       	jmp    80106284 <alltraps>

80106edb <vector196>:
.globl vector196
vector196:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $196
80106edd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ee2:	e9 9d f3 ff ff       	jmp    80106284 <alltraps>

80106ee7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $197
80106ee9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106eee:	e9 91 f3 ff ff       	jmp    80106284 <alltraps>

80106ef3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $198
80106ef5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106efa:	e9 85 f3 ff ff       	jmp    80106284 <alltraps>

80106eff <vector199>:
.globl vector199
vector199:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $199
80106f01:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f06:	e9 79 f3 ff ff       	jmp    80106284 <alltraps>

80106f0b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $200
80106f0d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f12:	e9 6d f3 ff ff       	jmp    80106284 <alltraps>

80106f17 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $201
80106f19:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f1e:	e9 61 f3 ff ff       	jmp    80106284 <alltraps>

80106f23 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $202
80106f25:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f2a:	e9 55 f3 ff ff       	jmp    80106284 <alltraps>

80106f2f <vector203>:
.globl vector203
vector203:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $203
80106f31:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f36:	e9 49 f3 ff ff       	jmp    80106284 <alltraps>

80106f3b <vector204>:
.globl vector204
vector204:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $204
80106f3d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f42:	e9 3d f3 ff ff       	jmp    80106284 <alltraps>

80106f47 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $205
80106f49:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f4e:	e9 31 f3 ff ff       	jmp    80106284 <alltraps>

80106f53 <vector206>:
.globl vector206
vector206:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $206
80106f55:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f5a:	e9 25 f3 ff ff       	jmp    80106284 <alltraps>

80106f5f <vector207>:
.globl vector207
vector207:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $207
80106f61:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f66:	e9 19 f3 ff ff       	jmp    80106284 <alltraps>

80106f6b <vector208>:
.globl vector208
vector208:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $208
80106f6d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f72:	e9 0d f3 ff ff       	jmp    80106284 <alltraps>

80106f77 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $209
80106f79:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f7e:	e9 01 f3 ff ff       	jmp    80106284 <alltraps>

80106f83 <vector210>:
.globl vector210
vector210:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $210
80106f85:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f8a:	e9 f5 f2 ff ff       	jmp    80106284 <alltraps>

80106f8f <vector211>:
.globl vector211
vector211:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $211
80106f91:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f96:	e9 e9 f2 ff ff       	jmp    80106284 <alltraps>

80106f9b <vector212>:
.globl vector212
vector212:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $212
80106f9d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fa2:	e9 dd f2 ff ff       	jmp    80106284 <alltraps>

80106fa7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $213
80106fa9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106fae:	e9 d1 f2 ff ff       	jmp    80106284 <alltraps>

80106fb3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $214
80106fb5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106fba:	e9 c5 f2 ff ff       	jmp    80106284 <alltraps>

80106fbf <vector215>:
.globl vector215
vector215:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $215
80106fc1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106fc6:	e9 b9 f2 ff ff       	jmp    80106284 <alltraps>

80106fcb <vector216>:
.globl vector216
vector216:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $216
80106fcd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106fd2:	e9 ad f2 ff ff       	jmp    80106284 <alltraps>

80106fd7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $217
80106fd9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106fde:	e9 a1 f2 ff ff       	jmp    80106284 <alltraps>

80106fe3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $218
80106fe5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106fea:	e9 95 f2 ff ff       	jmp    80106284 <alltraps>

80106fef <vector219>:
.globl vector219
vector219:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $219
80106ff1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ff6:	e9 89 f2 ff ff       	jmp    80106284 <alltraps>

80106ffb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $220
80106ffd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107002:	e9 7d f2 ff ff       	jmp    80106284 <alltraps>

80107007 <vector221>:
.globl vector221
vector221:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $221
80107009:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010700e:	e9 71 f2 ff ff       	jmp    80106284 <alltraps>

80107013 <vector222>:
.globl vector222
vector222:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $222
80107015:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010701a:	e9 65 f2 ff ff       	jmp    80106284 <alltraps>

8010701f <vector223>:
.globl vector223
vector223:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $223
80107021:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107026:	e9 59 f2 ff ff       	jmp    80106284 <alltraps>

8010702b <vector224>:
.globl vector224
vector224:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $224
8010702d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107032:	e9 4d f2 ff ff       	jmp    80106284 <alltraps>

80107037 <vector225>:
.globl vector225
vector225:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $225
80107039:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010703e:	e9 41 f2 ff ff       	jmp    80106284 <alltraps>

80107043 <vector226>:
.globl vector226
vector226:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $226
80107045:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010704a:	e9 35 f2 ff ff       	jmp    80106284 <alltraps>

8010704f <vector227>:
.globl vector227
vector227:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $227
80107051:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107056:	e9 29 f2 ff ff       	jmp    80106284 <alltraps>

8010705b <vector228>:
.globl vector228
vector228:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $228
8010705d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107062:	e9 1d f2 ff ff       	jmp    80106284 <alltraps>

80107067 <vector229>:
.globl vector229
vector229:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $229
80107069:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010706e:	e9 11 f2 ff ff       	jmp    80106284 <alltraps>

80107073 <vector230>:
.globl vector230
vector230:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $230
80107075:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010707a:	e9 05 f2 ff ff       	jmp    80106284 <alltraps>

8010707f <vector231>:
.globl vector231
vector231:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $231
80107081:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107086:	e9 f9 f1 ff ff       	jmp    80106284 <alltraps>

8010708b <vector232>:
.globl vector232
vector232:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $232
8010708d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107092:	e9 ed f1 ff ff       	jmp    80106284 <alltraps>

80107097 <vector233>:
.globl vector233
vector233:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $233
80107099:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010709e:	e9 e1 f1 ff ff       	jmp    80106284 <alltraps>

801070a3 <vector234>:
.globl vector234
vector234:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $234
801070a5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070aa:	e9 d5 f1 ff ff       	jmp    80106284 <alltraps>

801070af <vector235>:
.globl vector235
vector235:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $235
801070b1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070b6:	e9 c9 f1 ff ff       	jmp    80106284 <alltraps>

801070bb <vector236>:
.globl vector236
vector236:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $236
801070bd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070c2:	e9 bd f1 ff ff       	jmp    80106284 <alltraps>

801070c7 <vector237>:
.globl vector237
vector237:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $237
801070c9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070ce:	e9 b1 f1 ff ff       	jmp    80106284 <alltraps>

801070d3 <vector238>:
.globl vector238
vector238:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $238
801070d5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801070da:	e9 a5 f1 ff ff       	jmp    80106284 <alltraps>

801070df <vector239>:
.globl vector239
vector239:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $239
801070e1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801070e6:	e9 99 f1 ff ff       	jmp    80106284 <alltraps>

801070eb <vector240>:
.globl vector240
vector240:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $240
801070ed:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801070f2:	e9 8d f1 ff ff       	jmp    80106284 <alltraps>

801070f7 <vector241>:
.globl vector241
vector241:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $241
801070f9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801070fe:	e9 81 f1 ff ff       	jmp    80106284 <alltraps>

80107103 <vector242>:
.globl vector242
vector242:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $242
80107105:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010710a:	e9 75 f1 ff ff       	jmp    80106284 <alltraps>

8010710f <vector243>:
.globl vector243
vector243:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $243
80107111:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107116:	e9 69 f1 ff ff       	jmp    80106284 <alltraps>

8010711b <vector244>:
.globl vector244
vector244:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $244
8010711d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107122:	e9 5d f1 ff ff       	jmp    80106284 <alltraps>

80107127 <vector245>:
.globl vector245
vector245:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $245
80107129:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010712e:	e9 51 f1 ff ff       	jmp    80106284 <alltraps>

80107133 <vector246>:
.globl vector246
vector246:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $246
80107135:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010713a:	e9 45 f1 ff ff       	jmp    80106284 <alltraps>

8010713f <vector247>:
.globl vector247
vector247:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $247
80107141:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107146:	e9 39 f1 ff ff       	jmp    80106284 <alltraps>

8010714b <vector248>:
.globl vector248
vector248:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $248
8010714d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107152:	e9 2d f1 ff ff       	jmp    80106284 <alltraps>

80107157 <vector249>:
.globl vector249
vector249:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $249
80107159:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010715e:	e9 21 f1 ff ff       	jmp    80106284 <alltraps>

80107163 <vector250>:
.globl vector250
vector250:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $250
80107165:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010716a:	e9 15 f1 ff ff       	jmp    80106284 <alltraps>

8010716f <vector251>:
.globl vector251
vector251:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $251
80107171:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107176:	e9 09 f1 ff ff       	jmp    80106284 <alltraps>

8010717b <vector252>:
.globl vector252
vector252:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $252
8010717d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107182:	e9 fd f0 ff ff       	jmp    80106284 <alltraps>

80107187 <vector253>:
.globl vector253
vector253:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $253
80107189:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010718e:	e9 f1 f0 ff ff       	jmp    80106284 <alltraps>

80107193 <vector254>:
.globl vector254
vector254:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $254
80107195:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010719a:	e9 e5 f0 ff ff       	jmp    80106284 <alltraps>

8010719f <vector255>:
.globl vector255
vector255:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $255
801071a1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071a6:	e9 d9 f0 ff ff       	jmp    80106284 <alltraps>
801071ab:	66 90                	xchg   %ax,%ax
801071ad:	66 90                	xchg   %ax,%ax
801071af:	90                   	nop

801071b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801071b7:	c1 ea 16             	shr    $0x16,%edx
{
801071ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801071bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801071be:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801071c1:	8b 1f                	mov    (%edi),%ebx
801071c3:	f6 c3 01             	test   $0x1,%bl
801071c6:	74 28                	je     801071f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801071ce:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801071d4:	89 f0                	mov    %esi,%eax
}
801071d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801071d9:	c1 e8 0a             	shr    $0xa,%eax
801071dc:	25 fc 0f 00 00       	and    $0xffc,%eax
801071e1:	01 d8                	add    %ebx,%eax
}
801071e3:	5b                   	pop    %ebx
801071e4:	5e                   	pop    %esi
801071e5:	5f                   	pop    %edi
801071e6:	5d                   	pop    %ebp
801071e7:	c3                   	ret    
801071e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ef:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071f0:	85 c9                	test   %ecx,%ecx
801071f2:	74 2c                	je     80107220 <walkpgdir+0x70>
801071f4:	e8 c7 bd ff ff       	call   80102fc0 <kalloc>
801071f9:	89 c3                	mov    %eax,%ebx
801071fb:	85 c0                	test   %eax,%eax
801071fd:	74 21                	je     80107220 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801071ff:	83 ec 04             	sub    $0x4,%esp
80107202:	68 00 10 00 00       	push   $0x1000
80107207:	6a 00                	push   $0x0
80107209:	50                   	push   %eax
8010720a:	e8 f1 dd ff ff       	call   80105000 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010720f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107215:	83 c4 10             	add    $0x10,%esp
80107218:	83 c8 07             	or     $0x7,%eax
8010721b:	89 07                	mov    %eax,(%edi)
8010721d:	eb b5                	jmp    801071d4 <walkpgdir+0x24>
8010721f:	90                   	nop
}
80107220:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107223:	31 c0                	xor    %eax,%eax
}
80107225:	5b                   	pop    %ebx
80107226:	5e                   	pop    %esi
80107227:	5f                   	pop    %edi
80107228:	5d                   	pop    %ebp
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107230 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107236:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010723a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010723b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107240:	89 d6                	mov    %edx,%esi
{
80107242:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107243:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107249:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010724c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010724f:	8b 45 08             	mov    0x8(%ebp),%eax
80107252:	29 f0                	sub    %esi,%eax
80107254:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107257:	eb 1f                	jmp    80107278 <mappages+0x48>
80107259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107260:	f6 00 01             	testb  $0x1,(%eax)
80107263:	75 45                	jne    801072aa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107265:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107268:	83 cb 01             	or     $0x1,%ebx
8010726b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010726d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107270:	74 2e                	je     801072a0 <mappages+0x70>
      break;
    a += PGSIZE;
80107272:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010727b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107280:	89 f2                	mov    %esi,%edx
80107282:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107285:	89 f8                	mov    %edi,%eax
80107287:	e8 24 ff ff ff       	call   801071b0 <walkpgdir>
8010728c:	85 c0                	test   %eax,%eax
8010728e:	75 d0                	jne    80107260 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107290:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107298:	5b                   	pop    %ebx
80107299:	5e                   	pop    %esi
8010729a:	5f                   	pop    %edi
8010729b:	5d                   	pop    %ebp
8010729c:	c3                   	ret    
8010729d:	8d 76 00             	lea    0x0(%esi),%esi
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072a3:	31 c0                	xor    %eax,%eax
}
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
      panic("remap");
801072aa:	83 ec 0c             	sub    $0xc,%esp
801072ad:	68 18 8a 10 80       	push   $0x80108a18
801072b2:	e8 d9 90 ff ff       	call   80100390 <panic>
801072b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072be:	66 90                	xchg   %ax,%ax

801072c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	89 c6                	mov    %eax,%esi
801072c7:	53                   	push   %ebx
801072c8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801072ca:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801072d0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801072d6:	83 ec 1c             	sub    $0x1c,%esp
801072d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801072dc:	39 da                	cmp    %ebx,%edx
801072de:	73 5b                	jae    8010733b <deallocuvm.part.0+0x7b>
801072e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801072e3:	89 d7                	mov    %edx,%edi
801072e5:	eb 14                	jmp    801072fb <deallocuvm.part.0+0x3b>
801072e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ee:	66 90                	xchg   %ax,%ax
801072f0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801072f6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801072f9:	76 40                	jbe    8010733b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801072fb:	31 c9                	xor    %ecx,%ecx
801072fd:	89 fa                	mov    %edi,%edx
801072ff:	89 f0                	mov    %esi,%eax
80107301:	e8 aa fe ff ff       	call   801071b0 <walkpgdir>
80107306:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107308:	85 c0                	test   %eax,%eax
8010730a:	74 44                	je     80107350 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010730c:	8b 00                	mov    (%eax),%eax
8010730e:	a8 01                	test   $0x1,%al
80107310:	74 de                	je     801072f0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107312:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107317:	74 47                	je     80107360 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107319:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010731c:	05 00 00 00 80       	add    $0x80000000,%eax
80107321:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107327:	50                   	push   %eax
80107328:	e8 d3 ba ff ff       	call   80102e00 <kfree>
      *pte = 0;
8010732d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107333:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107336:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107339:	77 c0                	ja     801072fb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010733b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010733e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107341:	5b                   	pop    %ebx
80107342:	5e                   	pop    %esi
80107343:	5f                   	pop    %edi
80107344:	5d                   	pop    %ebp
80107345:	c3                   	ret    
80107346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107350:	89 fa                	mov    %edi,%edx
80107352:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107358:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010735e:	eb 96                	jmp    801072f6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	68 9e 7d 10 80       	push   $0x80107d9e
80107368:	e8 23 90 ff ff       	call   80100390 <panic>
8010736d:	8d 76 00             	lea    0x0(%esi),%esi

80107370 <seginit>:
{
80107370:	f3 0f 1e fb          	endbr32 
80107374:	55                   	push   %ebp
80107375:	89 e5                	mov    %esp,%ebp
80107377:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010737a:	e8 51 cf ff ff       	call   801042d0 <cpuid>
  pd[0] = size-1;
8010737f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107384:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010738a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010738e:	c7 80 f8 41 11 80 ff 	movl   $0xffff,-0x7feebe08(%eax)
80107395:	ff 00 00 
80107398:	c7 80 fc 41 11 80 00 	movl   $0xcf9a00,-0x7feebe04(%eax)
8010739f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073a2:	c7 80 00 42 11 80 ff 	movl   $0xffff,-0x7feebe00(%eax)
801073a9:	ff 00 00 
801073ac:	c7 80 04 42 11 80 00 	movl   $0xcf9200,-0x7feebdfc(%eax)
801073b3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801073b6:	c7 80 08 42 11 80 ff 	movl   $0xffff,-0x7feebdf8(%eax)
801073bd:	ff 00 00 
801073c0:	c7 80 0c 42 11 80 00 	movl   $0xcffa00,-0x7feebdf4(%eax)
801073c7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801073ca:	c7 80 10 42 11 80 ff 	movl   $0xffff,-0x7feebdf0(%eax)
801073d1:	ff 00 00 
801073d4:	c7 80 14 42 11 80 00 	movl   $0xcff200,-0x7feebdec(%eax)
801073db:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801073de:	05 f0 41 11 80       	add    $0x801141f0,%eax
  pd[1] = (uint)p;
801073e3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801073e7:	c1 e8 10             	shr    $0x10,%eax
801073ea:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801073ee:	8d 45 f2             	lea    -0xe(%ebp),%eax
801073f1:	0f 01 10             	lgdtl  (%eax)
}
801073f4:	c9                   	leave  
801073f5:	c3                   	ret    
801073f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073fd:	8d 76 00             	lea    0x0(%esi),%esi

80107400 <switchkvm>:
{
80107400:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107404:	a1 a4 6e 11 80       	mov    0x80116ea4,%eax
80107409:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010740e:	0f 22 d8             	mov    %eax,%cr3
}
80107411:	c3                   	ret    
80107412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107420 <switchuvm>:
{
80107420:	f3 0f 1e fb          	endbr32 
80107424:	55                   	push   %ebp
80107425:	89 e5                	mov    %esp,%ebp
80107427:	57                   	push   %edi
80107428:	56                   	push   %esi
80107429:	53                   	push   %ebx
8010742a:	83 ec 1c             	sub    $0x1c,%esp
8010742d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107430:	85 f6                	test   %esi,%esi
80107432:	0f 84 cb 00 00 00    	je     80107503 <switchuvm+0xe3>
  if(p->kstack == 0)
80107438:	8b 46 08             	mov    0x8(%esi),%eax
8010743b:	85 c0                	test   %eax,%eax
8010743d:	0f 84 da 00 00 00    	je     8010751d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107443:	8b 46 04             	mov    0x4(%esi),%eax
80107446:	85 c0                	test   %eax,%eax
80107448:	0f 84 c2 00 00 00    	je     80107510 <switchuvm+0xf0>
  pushcli();
8010744e:	e8 9d d9 ff ff       	call   80104df0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107453:	e8 08 ce ff ff       	call   80104260 <mycpu>
80107458:	89 c3                	mov    %eax,%ebx
8010745a:	e8 01 ce ff ff       	call   80104260 <mycpu>
8010745f:	89 c7                	mov    %eax,%edi
80107461:	e8 fa cd ff ff       	call   80104260 <mycpu>
80107466:	83 c7 08             	add    $0x8,%edi
80107469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010746c:	e8 ef cd ff ff       	call   80104260 <mycpu>
80107471:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107474:	ba 67 00 00 00       	mov    $0x67,%edx
80107479:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107480:	83 c0 08             	add    $0x8,%eax
80107483:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010748a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010748f:	83 c1 08             	add    $0x8,%ecx
80107492:	c1 e8 18             	shr    $0x18,%eax
80107495:	c1 e9 10             	shr    $0x10,%ecx
80107498:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010749e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801074a4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801074a9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074b0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801074b5:	e8 a6 cd ff ff       	call   80104260 <mycpu>
801074ba:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074c1:	e8 9a cd ff ff       	call   80104260 <mycpu>
801074c6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801074ca:	8b 5e 08             	mov    0x8(%esi),%ebx
801074cd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074d3:	e8 88 cd ff ff       	call   80104260 <mycpu>
801074d8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074db:	e8 80 cd ff ff       	call   80104260 <mycpu>
801074e0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801074e4:	b8 28 00 00 00       	mov    $0x28,%eax
801074e9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801074ec:	8b 46 04             	mov    0x4(%esi),%eax
801074ef:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074f4:	0f 22 d8             	mov    %eax,%cr3
}
801074f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074fa:	5b                   	pop    %ebx
801074fb:	5e                   	pop    %esi
801074fc:	5f                   	pop    %edi
801074fd:	5d                   	pop    %ebp
  popcli();
801074fe:	e9 3d d9 ff ff       	jmp    80104e40 <popcli>
    panic("switchuvm: no process");
80107503:	83 ec 0c             	sub    $0xc,%esp
80107506:	68 1e 8a 10 80       	push   $0x80108a1e
8010750b:	e8 80 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107510:	83 ec 0c             	sub    $0xc,%esp
80107513:	68 49 8a 10 80       	push   $0x80108a49
80107518:	e8 73 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010751d:	83 ec 0c             	sub    $0xc,%esp
80107520:	68 34 8a 10 80       	push   $0x80108a34
80107525:	e8 66 8e ff ff       	call   80100390 <panic>
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107530 <inituvm>:
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	57                   	push   %edi
80107538:	56                   	push   %esi
80107539:	53                   	push   %ebx
8010753a:	83 ec 1c             	sub    $0x1c,%esp
8010753d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107540:	8b 75 10             	mov    0x10(%ebp),%esi
80107543:	8b 7d 08             	mov    0x8(%ebp),%edi
80107546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107549:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010754f:	77 4b                	ja     8010759c <inituvm+0x6c>
  mem = kalloc();
80107551:	e8 6a ba ff ff       	call   80102fc0 <kalloc>
  memset(mem, 0, PGSIZE);
80107556:	83 ec 04             	sub    $0x4,%esp
80107559:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010755e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107560:	6a 00                	push   $0x0
80107562:	50                   	push   %eax
80107563:	e8 98 da ff ff       	call   80105000 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107568:	58                   	pop    %eax
80107569:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010756f:	5a                   	pop    %edx
80107570:	6a 06                	push   $0x6
80107572:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107577:	31 d2                	xor    %edx,%edx
80107579:	50                   	push   %eax
8010757a:	89 f8                	mov    %edi,%eax
8010757c:	e8 af fc ff ff       	call   80107230 <mappages>
  memmove(mem, init, sz);
80107581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107584:	89 75 10             	mov    %esi,0x10(%ebp)
80107587:	83 c4 10             	add    $0x10,%esp
8010758a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010758d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107593:	5b                   	pop    %ebx
80107594:	5e                   	pop    %esi
80107595:	5f                   	pop    %edi
80107596:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107597:	e9 04 db ff ff       	jmp    801050a0 <memmove>
    panic("inituvm: more than a page");
8010759c:	83 ec 0c             	sub    $0xc,%esp
8010759f:	68 5d 8a 10 80       	push   $0x80108a5d
801075a4:	e8 e7 8d ff ff       	call   80100390 <panic>
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075b0 <loaduvm>:
{
801075b0:	f3 0f 1e fb          	endbr32 
801075b4:	55                   	push   %ebp
801075b5:	89 e5                	mov    %esp,%ebp
801075b7:	57                   	push   %edi
801075b8:	56                   	push   %esi
801075b9:	53                   	push   %ebx
801075ba:	83 ec 1c             	sub    $0x1c,%esp
801075bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801075c0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801075c3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801075c8:	0f 85 99 00 00 00    	jne    80107667 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801075ce:	01 f0                	add    %esi,%eax
801075d0:	89 f3                	mov    %esi,%ebx
801075d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075d5:	8b 45 14             	mov    0x14(%ebp),%eax
801075d8:	01 f0                	add    %esi,%eax
801075da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801075dd:	85 f6                	test   %esi,%esi
801075df:	75 15                	jne    801075f6 <loaduvm+0x46>
801075e1:	eb 6d                	jmp    80107650 <loaduvm+0xa0>
801075e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075e7:	90                   	nop
801075e8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801075ee:	89 f0                	mov    %esi,%eax
801075f0:	29 d8                	sub    %ebx,%eax
801075f2:	39 c6                	cmp    %eax,%esi
801075f4:	76 5a                	jbe    80107650 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801075f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075f9:	8b 45 08             	mov    0x8(%ebp),%eax
801075fc:	31 c9                	xor    %ecx,%ecx
801075fe:	29 da                	sub    %ebx,%edx
80107600:	e8 ab fb ff ff       	call   801071b0 <walkpgdir>
80107605:	85 c0                	test   %eax,%eax
80107607:	74 51                	je     8010765a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107609:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010760b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010760e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107613:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107618:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010761e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107621:	29 d9                	sub    %ebx,%ecx
80107623:	05 00 00 00 80       	add    $0x80000000,%eax
80107628:	57                   	push   %edi
80107629:	51                   	push   %ecx
8010762a:	50                   	push   %eax
8010762b:	ff 75 10             	pushl  0x10(%ebp)
8010762e:	e8 bd ad ff ff       	call   801023f0 <readi>
80107633:	83 c4 10             	add    $0x10,%esp
80107636:	39 f8                	cmp    %edi,%eax
80107638:	74 ae                	je     801075e8 <loaduvm+0x38>
}
8010763a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010763d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107642:	5b                   	pop    %ebx
80107643:	5e                   	pop    %esi
80107644:	5f                   	pop    %edi
80107645:	5d                   	pop    %ebp
80107646:	c3                   	ret    
80107647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764e:	66 90                	xchg   %ax,%ax
80107650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107653:	31 c0                	xor    %eax,%eax
}
80107655:	5b                   	pop    %ebx
80107656:	5e                   	pop    %esi
80107657:	5f                   	pop    %edi
80107658:	5d                   	pop    %ebp
80107659:	c3                   	ret    
      panic("loaduvm: address should exist");
8010765a:	83 ec 0c             	sub    $0xc,%esp
8010765d:	68 77 8a 10 80       	push   $0x80108a77
80107662:	e8 29 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107667:	83 ec 0c             	sub    $0xc,%esp
8010766a:	68 18 8b 10 80       	push   $0x80108b18
8010766f:	e8 1c 8d ff ff       	call   80100390 <panic>
80107674:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010767b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010767f:	90                   	nop

80107680 <allocuvm>:
{
80107680:	f3 0f 1e fb          	endbr32 
80107684:	55                   	push   %ebp
80107685:	89 e5                	mov    %esp,%ebp
80107687:	57                   	push   %edi
80107688:	56                   	push   %esi
80107689:	53                   	push   %ebx
8010768a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010768d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107690:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107696:	85 c0                	test   %eax,%eax
80107698:	0f 88 b2 00 00 00    	js     80107750 <allocuvm+0xd0>
  if(newsz < oldsz)
8010769e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801076a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801076a4:	0f 82 96 00 00 00    	jb     80107740 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801076aa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801076b0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801076b6:	39 75 10             	cmp    %esi,0x10(%ebp)
801076b9:	77 40                	ja     801076fb <allocuvm+0x7b>
801076bb:	e9 83 00 00 00       	jmp    80107743 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801076c0:	83 ec 04             	sub    $0x4,%esp
801076c3:	68 00 10 00 00       	push   $0x1000
801076c8:	6a 00                	push   $0x0
801076ca:	50                   	push   %eax
801076cb:	e8 30 d9 ff ff       	call   80105000 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801076d0:	58                   	pop    %eax
801076d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076d7:	5a                   	pop    %edx
801076d8:	6a 06                	push   $0x6
801076da:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076df:	89 f2                	mov    %esi,%edx
801076e1:	50                   	push   %eax
801076e2:	89 f8                	mov    %edi,%eax
801076e4:	e8 47 fb ff ff       	call   80107230 <mappages>
801076e9:	83 c4 10             	add    $0x10,%esp
801076ec:	85 c0                	test   %eax,%eax
801076ee:	78 78                	js     80107768 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801076f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801076f9:	76 48                	jbe    80107743 <allocuvm+0xc3>
    mem = kalloc();
801076fb:	e8 c0 b8 ff ff       	call   80102fc0 <kalloc>
80107700:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107702:	85 c0                	test   %eax,%eax
80107704:	75 ba                	jne    801076c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107706:	83 ec 0c             	sub    $0xc,%esp
80107709:	68 95 8a 10 80       	push   $0x80108a95
8010770e:	e8 dd 8f ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107713:	8b 45 0c             	mov    0xc(%ebp),%eax
80107716:	83 c4 10             	add    $0x10,%esp
80107719:	39 45 10             	cmp    %eax,0x10(%ebp)
8010771c:	74 32                	je     80107750 <allocuvm+0xd0>
8010771e:	8b 55 10             	mov    0x10(%ebp),%edx
80107721:	89 c1                	mov    %eax,%ecx
80107723:	89 f8                	mov    %edi,%eax
80107725:	e8 96 fb ff ff       	call   801072c0 <deallocuvm.part.0>
      return 0;
8010772a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107734:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107737:	5b                   	pop    %ebx
80107738:	5e                   	pop    %esi
80107739:	5f                   	pop    %edi
8010773a:	5d                   	pop    %ebp
8010773b:	c3                   	ret    
8010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107746:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107749:	5b                   	pop    %ebx
8010774a:	5e                   	pop    %esi
8010774b:	5f                   	pop    %edi
8010774c:	5d                   	pop    %ebp
8010774d:	c3                   	ret    
8010774e:	66 90                	xchg   %ax,%ax
    return 0;
80107750:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010775a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010775d:	5b                   	pop    %ebx
8010775e:	5e                   	pop    %esi
8010775f:	5f                   	pop    %edi
80107760:	5d                   	pop    %ebp
80107761:	c3                   	ret    
80107762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107768:	83 ec 0c             	sub    $0xc,%esp
8010776b:	68 ad 8a 10 80       	push   $0x80108aad
80107770:	e8 7b 8f ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107775:	8b 45 0c             	mov    0xc(%ebp),%eax
80107778:	83 c4 10             	add    $0x10,%esp
8010777b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010777e:	74 0c                	je     8010778c <allocuvm+0x10c>
80107780:	8b 55 10             	mov    0x10(%ebp),%edx
80107783:	89 c1                	mov    %eax,%ecx
80107785:	89 f8                	mov    %edi,%eax
80107787:	e8 34 fb ff ff       	call   801072c0 <deallocuvm.part.0>
      kfree(mem);
8010778c:	83 ec 0c             	sub    $0xc,%esp
8010778f:	53                   	push   %ebx
80107790:	e8 6b b6 ff ff       	call   80102e00 <kfree>
      return 0;
80107795:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010779c:	83 c4 10             	add    $0x10,%esp
}
8010779f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077a5:	5b                   	pop    %ebx
801077a6:	5e                   	pop    %esi
801077a7:	5f                   	pop    %edi
801077a8:	5d                   	pop    %ebp
801077a9:	c3                   	ret    
801077aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077b0 <deallocuvm>:
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
801077b5:	89 e5                	mov    %esp,%ebp
801077b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
801077bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801077c0:	39 d1                	cmp    %edx,%ecx
801077c2:	73 0c                	jae    801077d0 <deallocuvm+0x20>
}
801077c4:	5d                   	pop    %ebp
801077c5:	e9 f6 fa ff ff       	jmp    801072c0 <deallocuvm.part.0>
801077ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077d0:	89 d0                	mov    %edx,%eax
801077d2:	5d                   	pop    %ebp
801077d3:	c3                   	ret    
801077d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077df:	90                   	nop

801077e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801077e0:	f3 0f 1e fb          	endbr32 
801077e4:	55                   	push   %ebp
801077e5:	89 e5                	mov    %esp,%ebp
801077e7:	57                   	push   %edi
801077e8:	56                   	push   %esi
801077e9:	53                   	push   %ebx
801077ea:	83 ec 0c             	sub    $0xc,%esp
801077ed:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801077f0:	85 f6                	test   %esi,%esi
801077f2:	74 55                	je     80107849 <freevm+0x69>
  if(newsz >= oldsz)
801077f4:	31 c9                	xor    %ecx,%ecx
801077f6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801077fb:	89 f0                	mov    %esi,%eax
801077fd:	89 f3                	mov    %esi,%ebx
801077ff:	e8 bc fa ff ff       	call   801072c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107804:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010780a:	eb 0b                	jmp    80107817 <freevm+0x37>
8010780c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107810:	83 c3 04             	add    $0x4,%ebx
80107813:	39 df                	cmp    %ebx,%edi
80107815:	74 23                	je     8010783a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107817:	8b 03                	mov    (%ebx),%eax
80107819:	a8 01                	test   $0x1,%al
8010781b:	74 f3                	je     80107810 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010781d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107822:	83 ec 0c             	sub    $0xc,%esp
80107825:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107828:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010782d:	50                   	push   %eax
8010782e:	e8 cd b5 ff ff       	call   80102e00 <kfree>
80107833:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107836:	39 df                	cmp    %ebx,%edi
80107838:	75 dd                	jne    80107817 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010783a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010783d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107840:	5b                   	pop    %ebx
80107841:	5e                   	pop    %esi
80107842:	5f                   	pop    %edi
80107843:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107844:	e9 b7 b5 ff ff       	jmp    80102e00 <kfree>
    panic("freevm: no pgdir");
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	68 c9 8a 10 80       	push   $0x80108ac9
80107851:	e8 3a 8b ff ff       	call   80100390 <panic>
80107856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785d:	8d 76 00             	lea    0x0(%esi),%esi

80107860 <setupkvm>:
{
80107860:	f3 0f 1e fb          	endbr32 
80107864:	55                   	push   %ebp
80107865:	89 e5                	mov    %esp,%ebp
80107867:	56                   	push   %esi
80107868:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107869:	e8 52 b7 ff ff       	call   80102fc0 <kalloc>
8010786e:	89 c6                	mov    %eax,%esi
80107870:	85 c0                	test   %eax,%eax
80107872:	74 42                	je     801078b6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107874:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107877:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010787c:	68 00 10 00 00       	push   $0x1000
80107881:	6a 00                	push   $0x0
80107883:	50                   	push   %eax
80107884:	e8 77 d7 ff ff       	call   80105000 <memset>
80107889:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010788c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010788f:	83 ec 08             	sub    $0x8,%esp
80107892:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107895:	ff 73 0c             	pushl  0xc(%ebx)
80107898:	8b 13                	mov    (%ebx),%edx
8010789a:	50                   	push   %eax
8010789b:	29 c1                	sub    %eax,%ecx
8010789d:	89 f0                	mov    %esi,%eax
8010789f:	e8 8c f9 ff ff       	call   80107230 <mappages>
801078a4:	83 c4 10             	add    $0x10,%esp
801078a7:	85 c0                	test   %eax,%eax
801078a9:	78 15                	js     801078c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078ab:	83 c3 10             	add    $0x10,%ebx
801078ae:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801078b4:	75 d6                	jne    8010788c <setupkvm+0x2c>
}
801078b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078b9:	89 f0                	mov    %esi,%eax
801078bb:	5b                   	pop    %ebx
801078bc:	5e                   	pop    %esi
801078bd:	5d                   	pop    %ebp
801078be:	c3                   	ret    
801078bf:	90                   	nop
      freevm(pgdir);
801078c0:	83 ec 0c             	sub    $0xc,%esp
801078c3:	56                   	push   %esi
      return 0;
801078c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801078c6:	e8 15 ff ff ff       	call   801077e0 <freevm>
      return 0;
801078cb:	83 c4 10             	add    $0x10,%esp
}
801078ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078d1:	89 f0                	mov    %esi,%eax
801078d3:	5b                   	pop    %ebx
801078d4:	5e                   	pop    %esi
801078d5:	5d                   	pop    %ebp
801078d6:	c3                   	ret    
801078d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078de:	66 90                	xchg   %ax,%ax

801078e0 <kvmalloc>:
{
801078e0:	f3 0f 1e fb          	endbr32 
801078e4:	55                   	push   %ebp
801078e5:	89 e5                	mov    %esp,%ebp
801078e7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801078ea:	e8 71 ff ff ff       	call   80107860 <setupkvm>
801078ef:	a3 a4 6e 11 80       	mov    %eax,0x80116ea4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801078f4:	05 00 00 00 80       	add    $0x80000000,%eax
801078f9:	0f 22 d8             	mov    %eax,%cr3
}
801078fc:	c9                   	leave  
801078fd:	c3                   	ret    
801078fe:	66 90                	xchg   %ax,%ax

80107900 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107900:	f3 0f 1e fb          	endbr32 
80107904:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107905:	31 c9                	xor    %ecx,%ecx
{
80107907:	89 e5                	mov    %esp,%ebp
80107909:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010790c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010790f:	8b 45 08             	mov    0x8(%ebp),%eax
80107912:	e8 99 f8 ff ff       	call   801071b0 <walkpgdir>
  if(pte == 0)
80107917:	85 c0                	test   %eax,%eax
80107919:	74 05                	je     80107920 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010791b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010791e:	c9                   	leave  
8010791f:	c3                   	ret    
    panic("clearpteu");
80107920:	83 ec 0c             	sub    $0xc,%esp
80107923:	68 da 8a 10 80       	push   $0x80108ada
80107928:	e8 63 8a ff ff       	call   80100390 <panic>
8010792d:	8d 76 00             	lea    0x0(%esi),%esi

80107930 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107930:	f3 0f 1e fb          	endbr32 
80107934:	55                   	push   %ebp
80107935:	89 e5                	mov    %esp,%ebp
80107937:	57                   	push   %edi
80107938:	56                   	push   %esi
80107939:	53                   	push   %ebx
8010793a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010793d:	e8 1e ff ff ff       	call   80107860 <setupkvm>
80107942:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107945:	85 c0                	test   %eax,%eax
80107947:	0f 84 9b 00 00 00    	je     801079e8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010794d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107950:	85 c9                	test   %ecx,%ecx
80107952:	0f 84 90 00 00 00    	je     801079e8 <copyuvm+0xb8>
80107958:	31 f6                	xor    %esi,%esi
8010795a:	eb 46                	jmp    801079a2 <copyuvm+0x72>
8010795c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107960:	83 ec 04             	sub    $0x4,%esp
80107963:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107969:	68 00 10 00 00       	push   $0x1000
8010796e:	57                   	push   %edi
8010796f:	50                   	push   %eax
80107970:	e8 2b d7 ff ff       	call   801050a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107975:	58                   	pop    %eax
80107976:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010797c:	5a                   	pop    %edx
8010797d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107980:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107985:	89 f2                	mov    %esi,%edx
80107987:	50                   	push   %eax
80107988:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010798b:	e8 a0 f8 ff ff       	call   80107230 <mappages>
80107990:	83 c4 10             	add    $0x10,%esp
80107993:	85 c0                	test   %eax,%eax
80107995:	78 61                	js     801079f8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107997:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010799d:	39 75 0c             	cmp    %esi,0xc(%ebp)
801079a0:	76 46                	jbe    801079e8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801079a2:	8b 45 08             	mov    0x8(%ebp),%eax
801079a5:	31 c9                	xor    %ecx,%ecx
801079a7:	89 f2                	mov    %esi,%edx
801079a9:	e8 02 f8 ff ff       	call   801071b0 <walkpgdir>
801079ae:	85 c0                	test   %eax,%eax
801079b0:	74 61                	je     80107a13 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801079b2:	8b 00                	mov    (%eax),%eax
801079b4:	a8 01                	test   $0x1,%al
801079b6:	74 4e                	je     80107a06 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801079b8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801079ba:	25 ff 0f 00 00       	and    $0xfff,%eax
801079bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801079c2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801079c8:	e8 f3 b5 ff ff       	call   80102fc0 <kalloc>
801079cd:	89 c3                	mov    %eax,%ebx
801079cf:	85 c0                	test   %eax,%eax
801079d1:	75 8d                	jne    80107960 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801079d3:	83 ec 0c             	sub    $0xc,%esp
801079d6:	ff 75 e0             	pushl  -0x20(%ebp)
801079d9:	e8 02 fe ff ff       	call   801077e0 <freevm>
  return 0;
801079de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801079e5:	83 c4 10             	add    $0x10,%esp
}
801079e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079ee:	5b                   	pop    %ebx
801079ef:	5e                   	pop    %esi
801079f0:	5f                   	pop    %edi
801079f1:	5d                   	pop    %ebp
801079f2:	c3                   	ret    
801079f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079f7:	90                   	nop
      kfree(mem);
801079f8:	83 ec 0c             	sub    $0xc,%esp
801079fb:	53                   	push   %ebx
801079fc:	e8 ff b3 ff ff       	call   80102e00 <kfree>
      goto bad;
80107a01:	83 c4 10             	add    $0x10,%esp
80107a04:	eb cd                	jmp    801079d3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107a06:	83 ec 0c             	sub    $0xc,%esp
80107a09:	68 fe 8a 10 80       	push   $0x80108afe
80107a0e:	e8 7d 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107a13:	83 ec 0c             	sub    $0xc,%esp
80107a16:	68 e4 8a 10 80       	push   $0x80108ae4
80107a1b:	e8 70 89 ff ff       	call   80100390 <panic>

80107a20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a20:	f3 0f 1e fb          	endbr32 
80107a24:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a25:	31 c9                	xor    %ecx,%ecx
{
80107a27:	89 e5                	mov    %esp,%ebp
80107a29:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80107a32:	e8 79 f7 ff ff       	call   801071b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107a37:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a39:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107a3a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107a41:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a44:	05 00 00 00 80       	add    $0x80000000,%eax
80107a49:	83 fa 05             	cmp    $0x5,%edx
80107a4c:	ba 00 00 00 00       	mov    $0x0,%edx
80107a51:	0f 45 c2             	cmovne %edx,%eax
}
80107a54:	c3                   	ret    
80107a55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a60:	f3 0f 1e fb          	endbr32 
80107a64:	55                   	push   %ebp
80107a65:	89 e5                	mov    %esp,%ebp
80107a67:	57                   	push   %edi
80107a68:	56                   	push   %esi
80107a69:	53                   	push   %ebx
80107a6a:	83 ec 0c             	sub    $0xc,%esp
80107a6d:	8b 75 14             	mov    0x14(%ebp),%esi
80107a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a73:	85 f6                	test   %esi,%esi
80107a75:	75 3c                	jne    80107ab3 <copyout+0x53>
80107a77:	eb 67                	jmp    80107ae0 <copyout+0x80>
80107a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107a80:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a83:	89 fb                	mov    %edi,%ebx
80107a85:	29 d3                	sub    %edx,%ebx
80107a87:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107a8d:	39 f3                	cmp    %esi,%ebx
80107a8f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a92:	29 fa                	sub    %edi,%edx
80107a94:	83 ec 04             	sub    $0x4,%esp
80107a97:	01 c2                	add    %eax,%edx
80107a99:	53                   	push   %ebx
80107a9a:	ff 75 10             	pushl  0x10(%ebp)
80107a9d:	52                   	push   %edx
80107a9e:	e8 fd d5 ff ff       	call   801050a0 <memmove>
    len -= n;
    buf += n;
80107aa3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107aa6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107aac:	83 c4 10             	add    $0x10,%esp
80107aaf:	29 de                	sub    %ebx,%esi
80107ab1:	74 2d                	je     80107ae0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107ab3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ab5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107ab8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107abb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ac1:	57                   	push   %edi
80107ac2:	ff 75 08             	pushl  0x8(%ebp)
80107ac5:	e8 56 ff ff ff       	call   80107a20 <uva2ka>
    if(pa0 == 0)
80107aca:	83 c4 10             	add    $0x10,%esp
80107acd:	85 c0                	test   %eax,%eax
80107acf:	75 af                	jne    80107a80 <copyout+0x20>
  }
  return 0;
}
80107ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ad4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ad9:	5b                   	pop    %ebx
80107ada:	5e                   	pop    %esi
80107adb:	5f                   	pop    %edi
80107adc:	5d                   	pop    %ebp
80107add:	c3                   	ret    
80107ade:	66 90                	xchg   %ax,%ax
80107ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ae3:	31 c0                	xor    %eax,%eax
}
80107ae5:	5b                   	pop    %ebx
80107ae6:	5e                   	pop    %esi
80107ae7:	5f                   	pop    %edi
80107ae8:	5d                   	pop    %ebp
80107ae9:	c3                   	ret    
