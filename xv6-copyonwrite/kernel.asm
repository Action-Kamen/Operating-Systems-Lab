
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 d4 14 80       	mov    $0x8014d4d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 30 10 80       	mov    $0x801030d0,%eax
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
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 72 10 80       	push   $0x80107220
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 e5 43 00 00       	call   80104440 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 72 10 80       	push   $0x80107227
80100097:	50                   	push   %eax
80100098:	e8 73 42 00 00       	call   80104310 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
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
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 27 45 00 00       	call   80104610 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 49 44 00 00       	call   801045b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 41 00 00       	call   80104350 <acquiresleep>
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
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 72 10 80       	push   $0x8010722e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 2d 42 00 00       	call   801043f0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 72 10 80       	push   $0x8010723f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 41 00 00       	call   801043f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 41 00 00       	call   801043b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 f0 43 00 00       	call   80104610 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 3f 43 00 00       	jmp    801045b0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 72 10 80       	push   $0x80107246
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 6b 43 00 00       	call   80104610 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 de 3d 00 00       	call   801040b0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 f9 36 00 00       	call   801039e0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 b5 42 00 00       	call   801045b0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 5f 42 00 00       	call   801045b0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 c2 25 00 00       	call   80102960 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 72 10 80       	push   $0x8010724d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 81 7b 10 80 	movl   $0x80107b81,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 40 00 00       	call   80104460 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 72 10 80       	push   $0x80107261
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 59 00 00       	call   80105d30 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 26 58 00 00       	call   80105d30 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 58 00 00       	call   80105d30 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 58 00 00       	call   80105d30 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 1a 42 00 00       	call   80104770 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 41 00 00       	call   801046d0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 72 10 80       	push   $0x80107265
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 60 40 00 00       	call   80104610 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 c7 3f 00 00       	call   801045b0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 90 72 10 80 	movzbl -0x7fef8d70(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 23 3e 00 00       	call   80104610 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 78 72 10 80       	mov    $0x80107278,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 50 3d 00 00       	call   801045b0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 72 10 80       	push   $0x8010727f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 78 3d 00 00       	call   80104610 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 db 3b 00 00       	call   801045b0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 3d 38 00 00       	jmp    80104250 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 27 37 00 00       	call   80104170 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 88 72 10 80       	push   $0x80107288
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 cb 39 00 00       	call   80104440 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 1f 2f 00 00       	call   801039e0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 04 23 00 00       	call   80102dd0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 2c 23 00 00       	call   80102e40 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 97 63 00 00       	call   80106ed0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 38 61 00 00       	call   80106ce0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 12 60 00 00       	call   80106bf0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 30 62 00 00       	call   80106e50 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 ea 21 00 00       	call   80102e40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 79 60 00 00       	call   80106ce0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 e8 62 00 00       	call   80106f70 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 f8 3b 00 00       	call   801048d0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 e4 3b 00 00       	call   801048d0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 43 64 00 00       	call   80107140 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 3a 61 00 00       	call   80106e50 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 d8 63 00 00       	call   80107140 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ea 3a 00 00       	call   80104890 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 8e 5c 00 00       	call   80106a60 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 76 60 00 00       	call   80106e50 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 57 20 00 00       	call   80102e40 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 a1 72 10 80       	push   $0x801072a1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 ad 72 10 80       	push   $0x801072ad
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 1b 36 00 00       	call   80104440 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 ca 37 00 00       	call   80104610 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 3a 37 00 00       	call   801045b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 21 37 00 00       	call   801045b0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 5c 37 00 00       	call   80104610 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 df 36 00 00       	call   801045b0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 b4 72 10 80       	push   $0x801072b4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 0a 37 00 00       	call   80104610 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 6f 36 00 00       	call   801045b0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 3d 36 00 00       	jmp    801045b0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 53 1e 00 00       	call   80102dd0 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 a9 1e 00 00       	jmp    80102e40 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 f2 25 00 00       	call   801035a0 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 bc 72 10 80       	push   $0x801072bc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 ae 26 00 00       	jmp    80103740 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 c6 72 10 80       	push   $0x801072c6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 32 1d 00 00       	call   80102e40 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 9d 1c 00 00       	call   80102dd0 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 d6 1c 00 00       	call   80102e40 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 cf 72 10 80       	push   $0x801072cf
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 92 24 00 00       	jmp    80103640 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 d5 72 10 80       	push   $0x801072d5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 9e 1d 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 df 72 10 80       	push   $0x801072df
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f2 72 10 80       	push   $0x801072f2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 ae 1c 00 00       	call   80102fb0 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 a6 33 00 00       	call   801046d0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 7e 1c 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 f9 10 80       	push   $0x8010f960
8010136a:	e8 a1 32 00 00       	call   80104610 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 f9 10 80       	push   $0x8010f960
801013d7:	e8 d4 31 00 00       	call   801045b0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 a6 31 00 00       	call   801045b0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 08 73 10 80       	push   $0x80107308
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 e6 1a 00 00       	call   80102fb0 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 18 73 10 80       	push   $0x80107318
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 2a 32 00 00       	call   80104770 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 2b 73 10 80       	push   $0x8010732b
80101571:	68 60 f9 10 80       	push   $0x8010f960
80101576:	e8 c5 2e 00 00       	call   80104440 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 73 10 80       	push   $0x80107332
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 7c 2d 00 00       	call   80104310 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 15 11 80       	push   $0x801115b4
801015bc:	e8 af 31 00 00       	call   80104770 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 15 11 80    	push   0x801115cc
801015cf:	ff 35 c8 15 11 80    	push   0x801115c8
801015d5:	ff 35 c4 15 11 80    	push   0x801115c4
801015db:	ff 35 c0 15 11 80    	push   0x801115c0
801015e1:	ff 35 bc 15 11 80    	push   0x801115bc
801015e7:	ff 35 b8 15 11 80    	push   0x801115b8
801015ed:	ff 35 b4 15 11 80    	push   0x801115b4
801015f3:	68 98 73 10 80       	push   $0x80107398
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 3d 30 00 00       	call   801046d0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 0b 19 00 00       	call   80102fb0 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 38 73 10 80       	push   $0x80107338
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 3a 30 00 00       	call   80104770 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 72 18 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 f9 10 80       	push   $0x8010f960
8010175f:	e8 ac 2e 00 00       	call   80104610 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010176f:	e8 3c 2e 00 00       	call   801045b0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 a9 2b 00 00       	call   80104350 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 53 2f 00 00       	call   80104770 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 50 73 10 80       	push   $0x80107350
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 4a 73 10 80       	push   $0x8010734a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 78 2b 00 00       	call   801043f0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 1c 2b 00 00       	jmp    801043b0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 5f 73 10 80       	push   $0x8010735f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 8b 2a 00 00       	call   80104350 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 d1 2a 00 00       	call   801043b0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018e6:	e8 25 2d 00 00       	call   80104610 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 ab 2c 00 00       	jmp    801045b0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 f9 10 80       	push   $0x8010f960
80101910:	e8 fb 2c 00 00       	call   80104610 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010191f:	e8 8c 2c 00 00       	call   801045b0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 c8 29 00 00       	call   801043f0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 71 29 00 00       	call   801043b0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 5f 73 10 80       	push   $0x8010735f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 34 2c 00 00       	call   80104770 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 38 2b 00 00       	call   80104770 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 70 13 00 00       	call   80102fb0 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 0d 2b 00 00       	call   801047e0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 ae 2a 00 00       	call   801047e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 79 73 10 80       	push   $0x80107379
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 73 10 80       	push   $0x80107367
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 31 1c 00 00       	call   801039e0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 f9 10 80       	push   $0x8010f960
80101dba:	e8 51 28 00 00       	call   80104610 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dca:	e8 e1 27 00 00       	call   801045b0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 44 29 00 00       	call   80104770 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 5f 25 00 00       	call   801043f0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 fd 24 00 00       	call   801043b0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 90 28 00 00       	call   80104770 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 c0 24 00 00       	call   801043f0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 61 24 00 00       	call   801043b0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 7e 24 00 00       	call   801043f0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 5b 24 00 00       	call   801043f0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 04 24 00 00       	call   801043b0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 5f 73 10 80       	push   $0x8010735f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 ee 27 00 00       	call   80104830 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 88 73 10 80       	push   $0x80107388
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 62 79 10 80       	push   $0x80107962
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 f4 73 10 80       	push   $0x801073f4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 73 10 80       	push   $0x801073eb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 74 10 80       	push   $0x80107406
801021cb:	68 00 16 11 80       	push   $0x80111600
801021d0:	e8 6b 22 00 00       	call   80104440 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 97 14 80       	mov    0x80149784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 16 11 80       	push   $0x80111600
8010224e:	e8 bd 23 00 00       	call   80104610 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 be 1e 00 00       	call   80104170 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 16 11 80       	push   $0x80111600
801022cb:	e8 e0 22 00 00       	call   801045b0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 fd 20 00 00       	call   801043f0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 16 11 80       	push   $0x80111600
80102328:	e8 e3 22 00 00       	call   80104610 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	53                   	push   %ebx
80102369:	e8 42 1d 00 00       	call   801040b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 25 22 00 00       	jmp    801045b0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 35 74 10 80       	push   $0x80107435
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 20 74 10 80       	push   $0x80107420
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 0a 74 10 80       	push   $0x8010740a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 97 14 80 	movzbl 0x80149780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 54 74 10 80       	push   $0x80107454
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <getNumFreePages>:

int
getNumFreePages()
{
  int count=0;
  for (int i = 0; i < PHYSTOP/PGSIZE; i++)
801024c0:	31 c0                	xor    %eax,%eax
  int count=0;
801024c2:	31 d2                	xor    %edx,%edx
801024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(free_ref[i]==0)count++;
801024c8:	83 3c 85 40 16 11 80 	cmpl   $0x1,-0x7feee9c0(,%eax,4)
801024cf:	01 
801024d0:	83 d2 00             	adc    $0x0,%edx
  for (int i = 0; i < PHYSTOP/PGSIZE; i++)
801024d3:	83 c0 01             	add    $0x1,%eax
801024d6:	3d 00 e0 00 00       	cmp    $0xe000,%eax
801024db:	75 eb                	jne    801024c8 <getNumFreePages+0x8>
  }
  return count;
}
801024dd:	89 d0                	mov    %edx,%eax
801024df:	c3                   	ret    

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;
  // free_ref[(uint)(v)>>12]-=1;
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	75 76                	jne    80102568 <kfree+0x88>
801024f2:	81 fb d0 d4 14 80    	cmp    $0x8014d4d0,%ebx
801024f8:	72 6e                	jb     80102568 <kfree+0x88>
801024fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102500:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102505:	77 61                	ja     80102568 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102507:	83 ec 04             	sub    $0x4,%esp
8010250a:	68 00 10 00 00       	push   $0x1000
8010250f:	6a 01                	push   $0x1
80102511:	53                   	push   %ebx
80102512:	e8 b9 21 00 00       	call   801046d0 <memset>

  if(kmem.use_lock)
80102517:	8b 15 74 96 14 80    	mov    0x80149674,%edx
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	85 d2                	test   %edx,%edx
80102522:	75 1c                	jne    80102540 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102524:	a1 78 96 14 80       	mov    0x80149678,%eax
80102529:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010252b:	a1 74 96 14 80       	mov    0x80149674,%eax
  kmem.freelist = r;
80102530:	89 1d 78 96 14 80    	mov    %ebx,0x80149678
  if(kmem.use_lock)
80102536:	85 c0                	test   %eax,%eax
80102538:	75 1e                	jne    80102558 <kfree+0x78>
    release(&kmem.lock);
}
8010253a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253d:	c9                   	leave  
8010253e:	c3                   	ret    
8010253f:	90                   	nop
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 40 96 14 80       	push   $0x80149640
80102548:	e8 c3 20 00 00       	call   80104610 <acquire>
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	eb d2                	jmp    80102524 <kfree+0x44>
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102558:	c7 45 08 40 96 14 80 	movl   $0x80149640,0x8(%ebp)
}
8010255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102562:	c9                   	leave  
    release(&kmem.lock);
80102563:	e9 48 20 00 00       	jmp    801045b0 <release>
    panic("kfree");
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 86 74 10 80       	push   $0x80107486
80102570:	e8 0b de ff ff       	call   80100380 <panic>
80102575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <freerange>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102587:	8b 75 0c             	mov    0xc(%ebp),%esi
8010258a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <freerange+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 23 ff ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 f3                	cmp    %esi,%ebx
801025c2:	76 e4                	jbe    801025a8 <freerange+0x28>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ed:	39 de                	cmp    %ebx,%esi
801025ef:	72 23                	jb     80102614 <kinit2+0x44>
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 d3 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 96 14 80 01 	movl   $0x1,0x80149674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kinit1>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 8c 74 10 80       	push   $0x8010748c
80102640:	68 40 96 14 80       	push   $0x80149640
80102645:	e8 f6 1d 00 00       	call   80104440 <initlock>
  kmem.use_lock = 0;
8010264a:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < PHYSTOP/PGSIZE; i++)
8010264d:	31 c0                	xor    %eax,%eax
  kmem.use_lock = 0;
8010264f:	c7 05 74 96 14 80 00 	movl   $0x0,0x80149674
80102656:	00 00 00 
  for (int i = 0; i < PHYSTOP/PGSIZE; i++)
80102659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    free_ref[i]=0;
80102660:	c7 04 85 40 16 11 80 	movl   $0x0,-0x7feee9c0(,%eax,4)
80102667:	00 00 00 00 
  for (int i = 0; i < PHYSTOP/PGSIZE; i++)
8010266b:	83 c0 01             	add    $0x1,%eax
8010266e:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80102673:	75 eb                	jne    80102660 <kinit1+0x30>
  p = (char*)PGROUNDUP((uint)vstart);
80102675:	8b 45 08             	mov    0x8(%ebp),%eax
80102678:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010267e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102684:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010268a:	39 de                	cmp    %ebx,%esi
8010268c:	72 1e                	jb     801026ac <kinit1+0x7c>
8010268e:	66 90                	xchg   %ax,%ax
    kfree(p);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102699:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010269f:	50                   	push   %eax
801026a0:	e8 3b fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a5:	83 c4 10             	add    $0x10,%esp
801026a8:	39 de                	cmp    %ebx,%esi
801026aa:	73 e4                	jae    80102690 <kinit1+0x60>
}
801026ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026af:	5b                   	pop    %ebx
801026b0:	5e                   	pop    %esi
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret    
801026b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
801026c6:	8b 15 74 96 14 80    	mov    0x80149674,%edx
801026cc:	85 d2                	test   %edx,%edx
801026ce:	75 50                	jne    80102720 <kalloc+0x60>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026d0:	a1 78 96 14 80       	mov    0x80149678,%eax
  free_ref[(uint)(r)>>12]=1;
801026d5:	89 c1                	mov    %eax,%ecx
801026d7:	c1 e9 0c             	shr    $0xc,%ecx
801026da:	c7 04 8d 40 16 11 80 	movl   $0x1,-0x7feee9c0(,%ecx,4)
801026e1:	01 00 00 00 
  if(r)
801026e5:	85 c0                	test   %eax,%eax
801026e7:	74 0c                	je     801026f5 <kalloc+0x35>
    kmem.freelist = r->next;
801026e9:	8b 08                	mov    (%eax),%ecx
801026eb:	89 0d 78 96 14 80    	mov    %ecx,0x80149678
  if(kmem.use_lock)
801026f1:	85 d2                	test   %edx,%edx
801026f3:	75 0b                	jne    80102700 <kalloc+0x40>
    release(&kmem.lock);
  // free_ref[(uint)(r)>>12]=1;
  return (char*)r;
}
801026f5:	c9                   	leave  
801026f6:	c3                   	ret    
801026f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fe:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102706:	68 40 96 14 80       	push   $0x80149640
8010270b:	e8 a0 1e 00 00       	call   801045b0 <release>
  return (char*)r;
80102710:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102713:	83 c4 10             	add    $0x10,%esp
}
80102716:	c9                   	leave  
80102717:	c3                   	ret    
80102718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271f:	90                   	nop
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 40 96 14 80       	push   $0x80149640
80102728:	e8 e3 1e 00 00       	call   80104610 <acquire>
  r = kmem.freelist;
8010272d:	a1 78 96 14 80       	mov    0x80149678,%eax
  if(kmem.use_lock)
80102732:	8b 15 74 96 14 80    	mov    0x80149674,%edx
  if(r)
80102738:	83 c4 10             	add    $0x10,%esp
  free_ref[(uint)(r)>>12]=1;
8010273b:	89 c1                	mov    %eax,%ecx
8010273d:	c1 e9 0c             	shr    $0xc,%ecx
80102740:	c7 04 8d 40 16 11 80 	movl   $0x1,-0x7feee9c0(,%ecx,4)
80102747:	01 00 00 00 
  if(r)
8010274b:	85 c0                	test   %eax,%eax
8010274d:	75 9a                	jne    801026e9 <kalloc+0x29>
8010274f:	eb a0                	jmp    801026f1 <kalloc+0x31>
80102751:	66 90                	xchg   %ax,%ax
80102753:	66 90                	xchg   %ax,%ax
80102755:	66 90                	xchg   %ax,%ax
80102757:	66 90                	xchg   %ax,%ax
80102759:	66 90                	xchg   %ax,%ax
8010275b:	66 90                	xchg   %ax,%ax
8010275d:	66 90                	xchg   %ax,%ax
8010275f:	90                   	nop

80102760 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102760:	ba 64 00 00 00       	mov    $0x64,%edx
80102765:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102766:	a8 01                	test   $0x1,%al
80102768:	0f 84 c2 00 00 00    	je     80102830 <kbdgetc+0xd0>
{
8010276e:	55                   	push   %ebp
8010276f:	ba 60 00 00 00       	mov    $0x60,%edx
80102774:	89 e5                	mov    %esp,%ebp
80102776:	53                   	push   %ebx
80102777:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102778:	8b 1d 7c 96 14 80    	mov    0x8014967c,%ebx
  data = inb(KBDATAP);
8010277e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102781:	3c e0                	cmp    $0xe0,%al
80102783:	74 5b                	je     801027e0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102785:	89 da                	mov    %ebx,%edx
80102787:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010278a:	84 c0                	test   %al,%al
8010278c:	78 62                	js     801027f0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010278e:	85 d2                	test   %edx,%edx
80102790:	74 09                	je     8010279b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102792:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102795:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102798:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010279b:	0f b6 91 c0 75 10 80 	movzbl -0x7fef8a40(%ecx),%edx
  shift ^= togglecode[data];
801027a2:	0f b6 81 c0 74 10 80 	movzbl -0x7fef8b40(%ecx),%eax
  shift |= shiftcode[data];
801027a9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027ab:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ad:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027af:	89 15 7c 96 14 80    	mov    %edx,0x8014967c
  c = charcode[shift & (CTL | SHIFT)][data];
801027b5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027b8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027bb:	8b 04 85 a0 74 10 80 	mov    -0x7fef8b60(,%eax,4),%eax
801027c2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027c6:	74 0b                	je     801027d3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027c8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027cb:	83 fa 19             	cmp    $0x19,%edx
801027ce:	77 48                	ja     80102818 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027d0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d6:	c9                   	leave  
801027d7:	c3                   	ret    
801027d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop
    shift |= E0ESC;
801027e0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027e3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027e5:	89 1d 7c 96 14 80    	mov    %ebx,0x8014967c
}
801027eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ee:	c9                   	leave  
801027ef:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027f0:	83 e0 7f             	and    $0x7f,%eax
801027f3:	85 d2                	test   %edx,%edx
801027f5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027f8:	0f b6 81 c0 75 10 80 	movzbl -0x7fef8a40(%ecx),%eax
801027ff:	83 c8 40             	or     $0x40,%eax
80102802:	0f b6 c0             	movzbl %al,%eax
80102805:	f7 d0                	not    %eax
80102807:	21 d8                	and    %ebx,%eax
}
80102809:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010280c:	a3 7c 96 14 80       	mov    %eax,0x8014967c
    return 0;
80102811:	31 c0                	xor    %eax,%eax
}
80102813:	c9                   	leave  
80102814:	c3                   	ret    
80102815:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102818:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010281b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010281e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102821:	c9                   	leave  
      c += 'a' - 'A';
80102822:	83 f9 1a             	cmp    $0x1a,%ecx
80102825:	0f 42 c2             	cmovb  %edx,%eax
}
80102828:	c3                   	ret    
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102835:	c3                   	ret    
80102836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <kbdintr>:

void
kbdintr(void)
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102846:	68 60 27 10 80       	push   $0x80102760
8010284b:	e8 30 e0 ff ff       	call   80100880 <consoleintr>
}
80102850:	83 c4 10             	add    $0x10,%esp
80102853:	c9                   	leave  
80102854:	c3                   	ret    
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102860:	a1 80 96 14 80       	mov    0x80149680,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	0f 84 cb 00 00 00    	je     80102938 <lapicinit+0xd8>
  lapic[index] = value;
8010286d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102874:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010288e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102894:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010289b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ae:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028b5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028bb:	8b 50 30             	mov    0x30(%eax),%edx
801028be:	c1 ea 10             	shr    $0x10,%edx
801028c1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028c7:	75 77                	jne    80102940 <lapicinit+0xe0>
  lapic[index] = value;
801028c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102911:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 50 20             	mov    0x20(%eax),%edx
80102917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102920:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102926:	80 e6 10             	and    $0x10,%dh
80102929:	75 f5                	jne    80102920 <lapicinit+0xc0>
  lapic[index] = value;
8010292b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102932:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102935:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102938:	c3                   	ret    
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102940:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102947:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010294d:	e9 77 ff ff ff       	jmp    801028c9 <lapicinit+0x69>
80102952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102960 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102960:	a1 80 96 14 80       	mov    0x80149680,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 07                	je     80102970 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102969:	8b 40 20             	mov    0x20(%eax),%eax
8010296c:	c1 e8 18             	shr    $0x18,%eax
8010296f:	c3                   	ret    
    return 0;
80102970:	31 c0                	xor    %eax,%eax
}
80102972:	c3                   	ret    
80102973:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102980 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102980:	a1 80 96 14 80       	mov    0x80149680,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	74 0d                	je     80102996 <lapiceoi+0x16>
  lapic[index] = value;
80102989:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102990:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102996:	c3                   	ret    
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax

801029a0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop

801029b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	53                   	push   %ebx
801029be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029c4:	ee                   	out    %al,(%dx)
801029c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ca:	ba 71 00 00 00       	mov    $0x71,%edx
801029cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029d0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029dd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029e0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029e2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ee:	a1 80 96 14 80       	mov    0x80149680,%eax
801029f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3d:	c9                   	leave  
80102a3e:	c3                   	ret    
80102a3f:	90                   	nop

80102a40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a40:	55                   	push   %ebp
80102a41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a46:	ba 70 00 00 00       	mov    $0x70,%edx
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	57                   	push   %edi
80102a4e:	56                   	push   %esi
80102a4f:	53                   	push   %ebx
80102a50:	83 ec 4c             	sub    $0x4c,%esp
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	ba 71 00 00 00       	mov    $0x71,%edx
80102a59:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a65:	8d 76 00             	lea    0x0(%esi),%esi
80102a68:	31 c0                	xor    %eax,%eax
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a72:	89 ca                	mov    %ecx,%edx
80102a74:	ec                   	in     (%dx),%al
80102a75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a78:	89 da                	mov    %ebx,%edx
80102a7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a80:	89 ca                	mov    %ecx,%edx
80102a82:	ec                   	in     (%dx),%al
80102a83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a86:	89 da                	mov    %ebx,%edx
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 da                	mov    %ebx,%edx
80102a96:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aaa:	89 ca                	mov    %ecx,%edx
80102aac:	ec                   	in     (%dx),%al
80102aad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaf:	89 da                	mov    %ebx,%edx
80102ab1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab7:	89 ca                	mov    %ecx,%edx
80102ab9:	ec                   	in     (%dx),%al
80102aba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abc:	89 da                	mov    %ebx,%edx
80102abe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ac3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac4:	89 ca                	mov    %ecx,%edx
80102ac6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ac7:	84 c0                	test   %al,%al
80102ac9:	78 9d                	js     80102a68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102acb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102acf:	89 fa                	mov    %edi,%edx
80102ad1:	0f b6 fa             	movzbl %dl,%edi
80102ad4:	89 f2                	mov    %esi,%edx
80102ad6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ad9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102add:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae0:	89 da                	mov    %ebx,%edx
80102ae2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ae5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ae8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aec:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102aef:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102af2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102af6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102af9:	31 c0                	xor    %eax,%eax
80102afb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afc:	89 ca                	mov    %ecx,%edx
80102afe:	ec                   	in     (%dx),%al
80102aff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b02:	89 da                	mov    %ebx,%edx
80102b04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b07:	b8 02 00 00 00       	mov    $0x2,%eax
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	89 ca                	mov    %ecx,%edx
80102b0f:	ec                   	in     (%dx),%al
80102b10:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b13:	89 da                	mov    %ebx,%edx
80102b15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b18:	b8 04 00 00 00       	mov    $0x4,%eax
80102b1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1e:	89 ca                	mov    %ecx,%edx
80102b20:	ec                   	in     (%dx),%al
80102b21:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b24:	89 da                	mov    %ebx,%edx
80102b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b29:	b8 07 00 00 00       	mov    $0x7,%eax
80102b2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2f:	89 ca                	mov    %ecx,%edx
80102b31:	ec                   	in     (%dx),%al
80102b32:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b35:	89 da                	mov    %ebx,%edx
80102b37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b40:	89 ca                	mov    %ecx,%edx
80102b42:	ec                   	in     (%dx),%al
80102b43:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b46:	89 da                	mov    %ebx,%edx
80102b48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b51:	89 ca                	mov    %ecx,%edx
80102b53:	ec                   	in     (%dx),%al
80102b54:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b57:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b60:	6a 18                	push   $0x18
80102b62:	50                   	push   %eax
80102b63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b66:	50                   	push   %eax
80102b67:	e8 b4 1b 00 00       	call   80104720 <memcmp>
80102b6c:	83 c4 10             	add    $0x10,%esp
80102b6f:	85 c0                	test   %eax,%eax
80102b71:	0f 85 f1 fe ff ff    	jne    80102a68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b7b:	75 78                	jne    80102bf5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	83 e0 0f             	and    $0xf,%eax
80102b85:	c1 ea 04             	shr    $0x4,%edx
80102b88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	83 e0 0f             	and    $0xf,%eax
80102b99:	c1 ea 04             	shr    $0x4,%edx
80102b9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ba5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba8:	89 c2                	mov    %eax,%edx
80102baa:	83 e0 0f             	and    $0xf,%eax
80102bad:	c1 ea 04             	shr    $0x4,%edx
80102bb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbc:	89 c2                	mov    %eax,%edx
80102bbe:	83 e0 0f             	and    $0xf,%eax
80102bc1:	c1 ea 04             	shr    $0x4,%edx
80102bc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd0:	89 c2                	mov    %eax,%edx
80102bd2:	83 e0 0f             	and    $0xf,%eax
80102bd5:	c1 ea 04             	shr    $0x4,%edx
80102bd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102be1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102be4:	89 c2                	mov    %eax,%edx
80102be6:	83 e0 0f             	and    $0xf,%eax
80102be9:	c1 ea 04             	shr    $0x4,%edx
80102bec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bf5:	8b 75 08             	mov    0x8(%ebp),%esi
80102bf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bfb:	89 06                	mov    %eax,(%esi)
80102bfd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c00:	89 46 04             	mov    %eax,0x4(%esi)
80102c03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c06:	89 46 08             	mov    %eax,0x8(%esi)
80102c09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c12:	89 46 10             	mov    %eax,0x10(%esi)
80102c15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c25:	5b                   	pop    %ebx
80102c26:	5e                   	pop    %esi
80102c27:	5f                   	pop    %edi
80102c28:	5d                   	pop    %ebp
80102c29:	c3                   	ret    
80102c2a:	66 90                	xchg   %ax,%ax
80102c2c:	66 90                	xchg   %ax,%ax
80102c2e:	66 90                	xchg   %ax,%ax

80102c30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c30:	8b 0d e8 96 14 80    	mov    0x801496e8,%ecx
80102c36:	85 c9                	test   %ecx,%ecx
80102c38:	0f 8e 8a 00 00 00    	jle    80102cc8 <install_trans+0x98>
{
80102c3e:	55                   	push   %ebp
80102c3f:	89 e5                	mov    %esp,%ebp
80102c41:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	31 ff                	xor    %edi,%edi
{
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 0c             	sub    $0xc,%esp
80102c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c50:	a1 d4 96 14 80       	mov    0x801496d4,%eax
80102c55:	83 ec 08             	sub    $0x8,%esp
80102c58:	01 f8                	add    %edi,%eax
80102c5a:	83 c0 01             	add    $0x1,%eax
80102c5d:	50                   	push   %eax
80102c5e:	ff 35 e4 96 14 80    	push   0x801496e4
80102c64:	e8 67 d4 ff ff       	call   801000d0 <bread>
80102c69:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6b:	58                   	pop    %eax
80102c6c:	5a                   	pop    %edx
80102c6d:	ff 34 bd ec 96 14 80 	push   -0x7feb6914(,%edi,4)
80102c74:	ff 35 e4 96 14 80    	push   0x801496e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c7a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c7d:	e8 4e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c82:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c85:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c87:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c8a:	68 00 02 00 00       	push   $0x200
80102c8f:	50                   	push   %eax
80102c90:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c93:	50                   	push   %eax
80102c94:	e8 d7 1a 00 00       	call   80104770 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c99:	89 1c 24             	mov    %ebx,(%esp)
80102c9c:	e8 0f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ca1:	89 34 24             	mov    %esi,(%esp)
80102ca4:	e8 47 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ca9:	89 1c 24             	mov    %ebx,(%esp)
80102cac:	e8 3f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb1:	83 c4 10             	add    $0x10,%esp
80102cb4:	39 3d e8 96 14 80    	cmp    %edi,0x801496e8
80102cba:	7f 94                	jg     80102c50 <install_trans+0x20>
  }
}
80102cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cbf:	5b                   	pop    %ebx
80102cc0:	5e                   	pop    %esi
80102cc1:	5f                   	pop    %edi
80102cc2:	5d                   	pop    %ebp
80102cc3:	c3                   	ret    
80102cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cc8:	c3                   	ret    
80102cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cd7:	ff 35 d4 96 14 80    	push   0x801496d4
80102cdd:	ff 35 e4 96 14 80    	push   0x801496e4
80102ce3:	e8 e8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ceb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ced:	a1 e8 96 14 80       	mov    0x801496e8,%eax
80102cf2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	7e 19                	jle    80102d12 <write_head+0x42>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d00:	8b 0c 95 ec 96 14 80 	mov    -0x7feb6914(,%edx,4),%ecx
80102d07:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d0                	cmp    %edx,%eax
80102d10:	75 ee                	jne    80102d00 <write_head+0x30>
  }
  bwrite(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	53                   	push   %ebx
80102d16:	e8 95 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d1b:	89 1c 24             	mov    %ebx,(%esp)
80102d1e:	e8 cd d4 ff ff       	call   801001f0 <brelse>
}
80102d23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d26:	83 c4 10             	add    $0x10,%esp
80102d29:	c9                   	leave  
80102d2a:	c3                   	ret    
80102d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop

80102d30 <initlog>:
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 2c             	sub    $0x2c,%esp
80102d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d3a:	68 c0 76 10 80       	push   $0x801076c0
80102d3f:	68 a0 96 14 80       	push   $0x801496a0
80102d44:	e8 f7 16 00 00       	call   80104440 <initlock>
  readsb(dev, &sb);
80102d49:	58                   	pop    %eax
80102d4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 cb e7 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d58:	59                   	pop    %ecx
  log.dev = dev;
80102d59:	89 1d e4 96 14 80    	mov    %ebx,0x801496e4
  log.size = sb.nlog;
80102d5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d62:	a3 d4 96 14 80       	mov    %eax,0x801496d4
  log.size = sb.nlog;
80102d67:	89 15 d8 96 14 80    	mov    %edx,0x801496d8
  struct buf *buf = bread(log.dev, log.start);
80102d6d:	5a                   	pop    %edx
80102d6e:	50                   	push   %eax
80102d6f:	53                   	push   %ebx
80102d70:	e8 5b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d75:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d78:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d7b:	89 1d e8 96 14 80    	mov    %ebx,0x801496e8
  for (i = 0; i < log.lh.n; i++) {
80102d81:	85 db                	test   %ebx,%ebx
80102d83:	7e 1d                	jle    80102da2 <initlog+0x72>
80102d85:	31 d2                	xor    %edx,%edx
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d90:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d94:	89 0c 95 ec 96 14 80 	mov    %ecx,-0x7feb6914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d9b:	83 c2 01             	add    $0x1,%edx
80102d9e:	39 d3                	cmp    %edx,%ebx
80102da0:	75 ee                	jne    80102d90 <initlog+0x60>
  brelse(buf);
80102da2:	83 ec 0c             	sub    $0xc,%esp
80102da5:	50                   	push   %eax
80102da6:	e8 45 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dab:	e8 80 fe ff ff       	call   80102c30 <install_trans>
  log.lh.n = 0;
80102db0:	c7 05 e8 96 14 80 00 	movl   $0x0,0x801496e8
80102db7:	00 00 00 
  write_head(); // clear the log
80102dba:	e8 11 ff ff ff       	call   80102cd0 <write_head>
}
80102dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc2:	83 c4 10             	add    $0x10,%esp
80102dc5:	c9                   	leave  
80102dc6:	c3                   	ret    
80102dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dd6:	68 a0 96 14 80       	push   $0x801496a0
80102ddb:	e8 30 18 00 00       	call   80104610 <acquire>
80102de0:	83 c4 10             	add    $0x10,%esp
80102de3:	eb 18                	jmp    80102dfd <begin_op+0x2d>
80102de5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102de8:	83 ec 08             	sub    $0x8,%esp
80102deb:	68 a0 96 14 80       	push   $0x801496a0
80102df0:	68 a0 96 14 80       	push   $0x801496a0
80102df5:	e8 b6 12 00 00       	call   801040b0 <sleep>
80102dfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dfd:	a1 e0 96 14 80       	mov    0x801496e0,%eax
80102e02:	85 c0                	test   %eax,%eax
80102e04:	75 e2                	jne    80102de8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e06:	a1 dc 96 14 80       	mov    0x801496dc,%eax
80102e0b:	8b 15 e8 96 14 80    	mov    0x801496e8,%edx
80102e11:	83 c0 01             	add    $0x1,%eax
80102e14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e1a:	83 fa 1e             	cmp    $0x1e,%edx
80102e1d:	7f c9                	jg     80102de8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e22:	a3 dc 96 14 80       	mov    %eax,0x801496dc
      release(&log.lock);
80102e27:	68 a0 96 14 80       	push   $0x801496a0
80102e2c:	e8 7f 17 00 00       	call   801045b0 <release>
      break;
    }
  }
}
80102e31:	83 c4 10             	add    $0x10,%esp
80102e34:	c9                   	leave  
80102e35:	c3                   	ret    
80102e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	57                   	push   %edi
80102e44:	56                   	push   %esi
80102e45:	53                   	push   %ebx
80102e46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e49:	68 a0 96 14 80       	push   $0x801496a0
80102e4e:	e8 bd 17 00 00       	call   80104610 <acquire>
  log.outstanding -= 1;
80102e53:	a1 dc 96 14 80       	mov    0x801496dc,%eax
  if(log.committing)
80102e58:	8b 35 e0 96 14 80    	mov    0x801496e0,%esi
80102e5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e61:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e64:	89 1d dc 96 14 80    	mov    %ebx,0x801496dc
  if(log.committing)
80102e6a:	85 f6                	test   %esi,%esi
80102e6c:	0f 85 22 01 00 00    	jne    80102f94 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e72:	85 db                	test   %ebx,%ebx
80102e74:	0f 85 f6 00 00 00    	jne    80102f70 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e7a:	c7 05 e0 96 14 80 01 	movl   $0x1,0x801496e0
80102e81:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e84:	83 ec 0c             	sub    $0xc,%esp
80102e87:	68 a0 96 14 80       	push   $0x801496a0
80102e8c:	e8 1f 17 00 00       	call   801045b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e91:	8b 0d e8 96 14 80    	mov    0x801496e8,%ecx
80102e97:	83 c4 10             	add    $0x10,%esp
80102e9a:	85 c9                	test   %ecx,%ecx
80102e9c:	7f 42                	jg     80102ee0 <end_op+0xa0>
    acquire(&log.lock);
80102e9e:	83 ec 0c             	sub    $0xc,%esp
80102ea1:	68 a0 96 14 80       	push   $0x801496a0
80102ea6:	e8 65 17 00 00       	call   80104610 <acquire>
    wakeup(&log);
80102eab:	c7 04 24 a0 96 14 80 	movl   $0x801496a0,(%esp)
    log.committing = 0;
80102eb2:	c7 05 e0 96 14 80 00 	movl   $0x0,0x801496e0
80102eb9:	00 00 00 
    wakeup(&log);
80102ebc:	e8 af 12 00 00       	call   80104170 <wakeup>
    release(&log.lock);
80102ec1:	c7 04 24 a0 96 14 80 	movl   $0x801496a0,(%esp)
80102ec8:	e8 e3 16 00 00       	call   801045b0 <release>
80102ecd:	83 c4 10             	add    $0x10,%esp
}
80102ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed3:	5b                   	pop    %ebx
80102ed4:	5e                   	pop    %esi
80102ed5:	5f                   	pop    %edi
80102ed6:	5d                   	pop    %ebp
80102ed7:	c3                   	ret    
80102ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ee0:	a1 d4 96 14 80       	mov    0x801496d4,%eax
80102ee5:	83 ec 08             	sub    $0x8,%esp
80102ee8:	01 d8                	add    %ebx,%eax
80102eea:	83 c0 01             	add    $0x1,%eax
80102eed:	50                   	push   %eax
80102eee:	ff 35 e4 96 14 80    	push   0x801496e4
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
80102ef9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efb:	58                   	pop    %eax
80102efc:	5a                   	pop    %edx
80102efd:	ff 34 9d ec 96 14 80 	push   -0x7feb6914(,%ebx,4)
80102f04:	ff 35 e4 96 14 80    	push   0x801496e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f0d:	e8 be d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f12:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f15:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f17:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f1a:	68 00 02 00 00       	push   $0x200
80102f1f:	50                   	push   %eax
80102f20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f23:	50                   	push   %eax
80102f24:	e8 47 18 00 00       	call   80104770 <memmove>
    bwrite(to);  // write the log
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 7f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f31:	89 3c 24             	mov    %edi,(%esp)
80102f34:	e8 b7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f39:	89 34 24             	mov    %esi,(%esp)
80102f3c:	e8 af d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	3b 1d e8 96 14 80    	cmp    0x801496e8,%ebx
80102f4a:	7c 94                	jl     80102ee0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f4c:	e8 7f fd ff ff       	call   80102cd0 <write_head>
    install_trans(); // Now install writes to home locations
80102f51:	e8 da fc ff ff       	call   80102c30 <install_trans>
    log.lh.n = 0;
80102f56:	c7 05 e8 96 14 80 00 	movl   $0x0,0x801496e8
80102f5d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f60:	e8 6b fd ff ff       	call   80102cd0 <write_head>
80102f65:	e9 34 ff ff ff       	jmp    80102e9e <end_op+0x5e>
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f70:	83 ec 0c             	sub    $0xc,%esp
80102f73:	68 a0 96 14 80       	push   $0x801496a0
80102f78:	e8 f3 11 00 00       	call   80104170 <wakeup>
  release(&log.lock);
80102f7d:	c7 04 24 a0 96 14 80 	movl   $0x801496a0,(%esp)
80102f84:	e8 27 16 00 00       	call   801045b0 <release>
80102f89:	83 c4 10             	add    $0x10,%esp
}
80102f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5f                   	pop    %edi
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret    
    panic("log.committing");
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 c4 76 10 80       	push   $0x801076c4
80102f9c:	e8 df d3 ff ff       	call   80100380 <panic>
80102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop

80102fb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb7:	8b 15 e8 96 14 80    	mov    0x801496e8,%edx
{
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc0:	83 fa 1d             	cmp    $0x1d,%edx
80102fc3:	0f 8f 85 00 00 00    	jg     8010304e <log_write+0x9e>
80102fc9:	a1 d8 96 14 80       	mov    0x801496d8,%eax
80102fce:	83 e8 01             	sub    $0x1,%eax
80102fd1:	39 c2                	cmp    %eax,%edx
80102fd3:	7d 79                	jge    8010304e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fd5:	a1 dc 96 14 80       	mov    0x801496dc,%eax
80102fda:	85 c0                	test   %eax,%eax
80102fdc:	7e 7d                	jle    8010305b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 a0 96 14 80       	push   $0x801496a0
80102fe6:	e8 25 16 00 00       	call   80104610 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102feb:	8b 15 e8 96 14 80    	mov    0x801496e8,%edx
80102ff1:	83 c4 10             	add    $0x10,%esp
80102ff4:	85 d2                	test   %edx,%edx
80102ff6:	7e 4a                	jle    80103042 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ffb:	31 c0                	xor    %eax,%eax
80102ffd:	eb 08                	jmp    80103007 <log_write+0x57>
80102fff:	90                   	nop
80103000:	83 c0 01             	add    $0x1,%eax
80103003:	39 c2                	cmp    %eax,%edx
80103005:	74 29                	je     80103030 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103007:	39 0c 85 ec 96 14 80 	cmp    %ecx,-0x7feb6914(,%eax,4)
8010300e:	75 f0                	jne    80103000 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103010:	89 0c 85 ec 96 14 80 	mov    %ecx,-0x7feb6914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103017:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010301a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010301d:	c7 45 08 a0 96 14 80 	movl   $0x801496a0,0x8(%ebp)
}
80103024:	c9                   	leave  
  release(&log.lock);
80103025:	e9 86 15 00 00       	jmp    801045b0 <release>
8010302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103030:	89 0c 95 ec 96 14 80 	mov    %ecx,-0x7feb6914(,%edx,4)
    log.lh.n++;
80103037:	83 c2 01             	add    $0x1,%edx
8010303a:	89 15 e8 96 14 80    	mov    %edx,0x801496e8
80103040:	eb d5                	jmp    80103017 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103042:	8b 43 08             	mov    0x8(%ebx),%eax
80103045:	a3 ec 96 14 80       	mov    %eax,0x801496ec
  if (i == log.lh.n)
8010304a:	75 cb                	jne    80103017 <log_write+0x67>
8010304c:	eb e9                	jmp    80103037 <log_write+0x87>
    panic("too big a transaction");
8010304e:	83 ec 0c             	sub    $0xc,%esp
80103051:	68 d3 76 10 80       	push   $0x801076d3
80103056:	e8 25 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010305b:	83 ec 0c             	sub    $0xc,%esp
8010305e:	68 e9 76 10 80       	push   $0x801076e9
80103063:	e8 18 d3 ff ff       	call   80100380 <panic>
80103068:	66 90                	xchg   %ax,%ax
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103077:	e8 44 09 00 00       	call   801039c0 <cpuid>
8010307c:	89 c3                	mov    %eax,%ebx
8010307e:	e8 3d 09 00 00       	call   801039c0 <cpuid>
80103083:	83 ec 04             	sub    $0x4,%esp
80103086:	53                   	push   %ebx
80103087:	50                   	push   %eax
80103088:	68 04 77 10 80       	push   $0x80107704
8010308d:	e8 0e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103092:	e8 c9 28 00 00       	call   80105960 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103097:	e8 c4 08 00 00       	call   80103960 <mycpu>
8010309c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010309e:	b8 01 00 00 00       	mov    $0x1,%eax
801030a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030aa:	e8 f1 0b 00 00       	call   80103ca0 <scheduler>
801030af:	90                   	nop

801030b0 <mpenter>:
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030b6:	e8 95 39 00 00       	call   80106a50 <switchkvm>
  seginit();
801030bb:	e8 00 39 00 00       	call   801069c0 <seginit>
  lapicinit();
801030c0:	e8 9b f7 ff ff       	call   80102860 <lapicinit>
  mpmain();
801030c5:	e8 a6 ff ff ff       	call   80103070 <mpmain>
801030ca:	66 90                	xchg   %ax,%ax
801030cc:	66 90                	xchg   %ax,%ax
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <main>:
{
801030d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030d4:	83 e4 f0             	and    $0xfffffff0,%esp
801030d7:	ff 71 fc             	push   -0x4(%ecx)
801030da:	55                   	push   %ebp
801030db:	89 e5                	mov    %esp,%ebp
801030dd:	53                   	push   %ebx
801030de:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030df:	83 ec 08             	sub    $0x8,%esp
801030e2:	68 00 00 40 80       	push   $0x80400000
801030e7:	68 d0 d4 14 80       	push   $0x8014d4d0
801030ec:	e8 3f f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
801030f1:	e8 5a 3e 00 00       	call   80106f50 <kvmalloc>
  mpinit();        // detect other processors
801030f6:	e8 85 01 00 00       	call   80103280 <mpinit>
  lapicinit();     // interrupt controller
801030fb:	e8 60 f7 ff ff       	call   80102860 <lapicinit>
  seginit();       // segment descriptors
80103100:	e8 bb 38 00 00       	call   801069c0 <seginit>
  picinit();       // disable pic
80103105:	e8 76 03 00 00       	call   80103480 <picinit>
  ioapicinit();    // another interrupt controller
8010310a:	e8 c1 f2 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010310f:	e8 4c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103114:	e8 37 2b 00 00       	call   80105c50 <uartinit>
  pinit();         // process table
80103119:	e8 22 08 00 00       	call   80103940 <pinit>
  tvinit();        // trap vectors
8010311e:	e8 bd 27 00 00       	call   801058e0 <tvinit>
  binit();         // buffer cache
80103123:	e8 18 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103128:	e8 e3 dc ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010312d:	e8 8e f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103132:	83 c4 0c             	add    $0xc,%esp
80103135:	68 8a 00 00 00       	push   $0x8a
8010313a:	68 8c a4 10 80       	push   $0x8010a48c
8010313f:	68 00 70 00 80       	push   $0x80007000
80103144:	e8 27 16 00 00       	call   80104770 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103149:	83 c4 10             	add    $0x10,%esp
8010314c:	69 05 84 97 14 80 b0 	imul   $0xb0,0x80149784,%eax
80103153:	00 00 00 
80103156:	05 a0 97 14 80       	add    $0x801497a0,%eax
8010315b:	3d a0 97 14 80       	cmp    $0x801497a0,%eax
80103160:	76 7e                	jbe    801031e0 <main+0x110>
80103162:	bb a0 97 14 80       	mov    $0x801497a0,%ebx
80103167:	eb 20                	jmp    80103189 <main+0xb9>
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	69 05 84 97 14 80 b0 	imul   $0xb0,0x80149784,%eax
80103177:	00 00 00 
8010317a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103180:	05 a0 97 14 80       	add    $0x801497a0,%eax
80103185:	39 c3                	cmp    %eax,%ebx
80103187:	73 57                	jae    801031e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103189:	e8 d2 07 00 00       	call   80103960 <mycpu>
8010318e:	39 c3                	cmp    %eax,%ebx
80103190:	74 de                	je     80103170 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103192:	e8 29 f5 ff ff       	call   801026c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103197:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010319a:	c7 05 f8 6f 00 80 b0 	movl   $0x801030b0,0x80006ff8
801031a1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031a4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801031ab:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ae:	05 00 10 00 00       	add    $0x1000,%eax
801031b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031b8:	0f b6 03             	movzbl (%ebx),%eax
801031bb:	68 00 70 00 00       	push   $0x7000
801031c0:	50                   	push   %eax
801031c1:	e8 ea f7 ff ff       	call   801029b0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031c6:	83 c4 10             	add    $0x10,%esp
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031d6:	85 c0                	test   %eax,%eax
801031d8:	74 f6                	je     801031d0 <main+0x100>
801031da:	eb 94                	jmp    80103170 <main+0xa0>
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031e0:	83 ec 08             	sub    $0x8,%esp
801031e3:	68 00 00 00 8e       	push   $0x8e000000
801031e8:	68 00 00 40 80       	push   $0x80400000
801031ed:	e8 de f3 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
801031f2:	e8 19 08 00 00       	call   80103a10 <userinit>
  mpmain();        // finish this processor's setup
801031f7:	e8 74 fe ff ff       	call   80103070 <mpmain>
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103205:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010320b:	53                   	push   %ebx
  e = addr+len;
8010320c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010320f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103212:	39 de                	cmp    %ebx,%esi
80103214:	72 10                	jb     80103226 <mpsearch1+0x26>
80103216:	eb 50                	jmp    80103268 <mpsearch1+0x68>
80103218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop
80103220:	89 fe                	mov    %edi,%esi
80103222:	39 fb                	cmp    %edi,%ebx
80103224:	76 42                	jbe    80103268 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103226:	83 ec 04             	sub    $0x4,%esp
80103229:	8d 7e 10             	lea    0x10(%esi),%edi
8010322c:	6a 04                	push   $0x4
8010322e:	68 18 77 10 80       	push   $0x80107718
80103233:	56                   	push   %esi
80103234:	e8 e7 14 00 00       	call   80104720 <memcmp>
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	85 c0                	test   %eax,%eax
8010323e:	75 e0                	jne    80103220 <mpsearch1+0x20>
80103240:	89 f2                	mov    %esi,%edx
80103242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103248:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010324b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010324e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103250:	39 fa                	cmp    %edi,%edx
80103252:	75 f4                	jne    80103248 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103254:	84 c0                	test   %al,%al
80103256:	75 c8                	jne    80103220 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325b:	89 f0                	mov    %esi,%eax
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret    
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010326b:	31 f6                	xor    %esi,%esi
}
8010326d:	5b                   	pop    %ebx
8010326e:	89 f0                	mov    %esi,%eax
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret    
80103274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010327f:	90                   	nop

80103280 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103289:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103290:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103297:	c1 e0 08             	shl    $0x8,%eax
8010329a:	09 d0                	or     %edx,%eax
8010329c:	c1 e0 04             	shl    $0x4,%eax
8010329f:	75 1b                	jne    801032bc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032a1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032a8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032af:	c1 e0 08             	shl    $0x8,%eax
801032b2:	09 d0                	or     %edx,%eax
801032b4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032b7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032bc:	ba 00 04 00 00       	mov    $0x400,%edx
801032c1:	e8 3a ff ff ff       	call   80103200 <mpsearch1>
801032c6:	89 c3                	mov    %eax,%ebx
801032c8:	85 c0                	test   %eax,%eax
801032ca:	0f 84 40 01 00 00    	je     80103410 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032d0:	8b 73 04             	mov    0x4(%ebx),%esi
801032d3:	85 f6                	test   %esi,%esi
801032d5:	0f 84 25 01 00 00    	je     80103400 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801032db:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032de:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032e4:	6a 04                	push   $0x4
801032e6:	68 1d 77 10 80       	push   $0x8010771d
801032eb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032ef:	e8 2c 14 00 00       	call   80104720 <memcmp>
801032f4:	83 c4 10             	add    $0x10,%esp
801032f7:	85 c0                	test   %eax,%eax
801032f9:	0f 85 01 01 00 00    	jne    80103400 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032ff:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103306:	3c 01                	cmp    $0x1,%al
80103308:	74 08                	je     80103312 <mpinit+0x92>
8010330a:	3c 04                	cmp    $0x4,%al
8010330c:	0f 85 ee 00 00 00    	jne    80103400 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103312:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103319:	66 85 d2             	test   %dx,%dx
8010331c:	74 22                	je     80103340 <mpinit+0xc0>
8010331e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103321:	89 f0                	mov    %esi,%eax
  sum = 0;
80103323:	31 d2                	xor    %edx,%edx
80103325:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103328:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010332f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103332:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103334:	39 c7                	cmp    %eax,%edi
80103336:	75 f0                	jne    80103328 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103338:	84 d2                	test   %dl,%dl
8010333a:	0f 85 c0 00 00 00    	jne    80103400 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103340:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103346:	a3 80 96 14 80       	mov    %eax,0x80149680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010334b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103352:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103358:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010335d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103360:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103367:	90                   	nop
80103368:	39 d0                	cmp    %edx,%eax
8010336a:	73 15                	jae    80103381 <mpinit+0x101>
    switch(*p){
8010336c:	0f b6 08             	movzbl (%eax),%ecx
8010336f:	80 f9 02             	cmp    $0x2,%cl
80103372:	74 4c                	je     801033c0 <mpinit+0x140>
80103374:	77 3a                	ja     801033b0 <mpinit+0x130>
80103376:	84 c9                	test   %cl,%cl
80103378:	74 56                	je     801033d0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010337a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010337d:	39 d0                	cmp    %edx,%eax
8010337f:	72 eb                	jb     8010336c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103381:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103384:	85 f6                	test   %esi,%esi
80103386:	0f 84 d9 00 00 00    	je     80103465 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010338c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103390:	74 15                	je     801033a7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103392:	b8 70 00 00 00       	mov    $0x70,%eax
80103397:	ba 22 00 00 00       	mov    $0x22,%edx
8010339c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010339d:	ba 23 00 00 00       	mov    $0x23,%edx
801033a2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033a3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a6:	ee                   	out    %al,(%dx)
  }
}
801033a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033aa:	5b                   	pop    %ebx
801033ab:	5e                   	pop    %esi
801033ac:	5f                   	pop    %edi
801033ad:	5d                   	pop    %ebp
801033ae:	c3                   	ret    
801033af:	90                   	nop
    switch(*p){
801033b0:	83 e9 03             	sub    $0x3,%ecx
801033b3:	80 f9 01             	cmp    $0x1,%cl
801033b6:	76 c2                	jbe    8010337a <mpinit+0xfa>
801033b8:	31 f6                	xor    %esi,%esi
801033ba:	eb ac                	jmp    80103368 <mpinit+0xe8>
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033c0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033c4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033c7:	88 0d 80 97 14 80    	mov    %cl,0x80149780
      continue;
801033cd:	eb 99                	jmp    80103368 <mpinit+0xe8>
801033cf:	90                   	nop
      if(ncpu < NCPU) {
801033d0:	8b 0d 84 97 14 80    	mov    0x80149784,%ecx
801033d6:	83 f9 07             	cmp    $0x7,%ecx
801033d9:	7f 19                	jg     801033f4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033db:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033e5:	83 c1 01             	add    $0x1,%ecx
801033e8:	89 0d 84 97 14 80    	mov    %ecx,0x80149784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ee:	88 9f a0 97 14 80    	mov    %bl,-0x7feb6860(%edi)
      p += sizeof(struct mpproc);
801033f4:	83 c0 14             	add    $0x14,%eax
      continue;
801033f7:	e9 6c ff ff ff       	jmp    80103368 <mpinit+0xe8>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 22 77 10 80       	push   $0x80107722
80103408:	e8 73 cf ff ff       	call   80100380 <panic>
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103410:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103415:	eb 13                	jmp    8010342a <mpinit+0x1aa>
80103417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103420:	89 f3                	mov    %esi,%ebx
80103422:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103428:	74 d6                	je     80103400 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010342a:	83 ec 04             	sub    $0x4,%esp
8010342d:	8d 73 10             	lea    0x10(%ebx),%esi
80103430:	6a 04                	push   $0x4
80103432:	68 18 77 10 80       	push   $0x80107718
80103437:	53                   	push   %ebx
80103438:	e8 e3 12 00 00       	call   80104720 <memcmp>
8010343d:	83 c4 10             	add    $0x10,%esp
80103440:	85 c0                	test   %eax,%eax
80103442:	75 dc                	jne    80103420 <mpinit+0x1a0>
80103444:	89 da                	mov    %ebx,%edx
80103446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103450:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103453:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103456:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103458:	39 d6                	cmp    %edx,%esi
8010345a:	75 f4                	jne    80103450 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010345c:	84 c0                	test   %al,%al
8010345e:	75 c0                	jne    80103420 <mpinit+0x1a0>
80103460:	e9 6b fe ff ff       	jmp    801032d0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103465:	83 ec 0c             	sub    $0xc,%esp
80103468:	68 3c 77 10 80       	push   $0x8010773c
8010346d:	e8 0e cf ff ff       	call   80100380 <panic>
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <picinit>:
80103480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103485:	ba 21 00 00 00       	mov    $0x21,%edx
8010348a:	ee                   	out    %al,(%dx)
8010348b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103490:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103491:	c3                   	ret    
80103492:	66 90                	xchg   %ax,%ax
80103494:	66 90                	xchg   %ax,%ax
80103496:	66 90                	xchg   %ax,%ax
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 0c             	sub    $0xc,%esp
801034a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034bb:	e8 70 d9 ff ff       	call   80100e30 <filealloc>
801034c0:	89 03                	mov    %eax,(%ebx)
801034c2:	85 c0                	test   %eax,%eax
801034c4:	0f 84 a8 00 00 00    	je     80103572 <pipealloc+0xd2>
801034ca:	e8 61 d9 ff ff       	call   80100e30 <filealloc>
801034cf:	89 06                	mov    %eax,(%esi)
801034d1:	85 c0                	test   %eax,%eax
801034d3:	0f 84 87 00 00 00    	je     80103560 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034d9:	e8 e2 f1 ff ff       	call   801026c0 <kalloc>
801034de:	89 c7                	mov    %eax,%edi
801034e0:	85 c0                	test   %eax,%eax
801034e2:	0f 84 b0 00 00 00    	je     80103598 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801034e8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034ef:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034f2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034f5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034fc:	00 00 00 
  p->nwrite = 0;
801034ff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103506:	00 00 00 
  p->nread = 0;
80103509:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103510:	00 00 00 
  initlock(&p->lock, "pipe");
80103513:	68 5b 77 10 80       	push   $0x8010775b
80103518:	50                   	push   %eax
80103519:	e8 22 0f 00 00       	call   80104440 <initlock>
  (*f0)->type = FD_PIPE;
8010351e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103520:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103523:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103529:	8b 03                	mov    (%ebx),%eax
8010352b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010352f:	8b 03                	mov    (%ebx),%eax
80103531:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103535:	8b 03                	mov    (%ebx),%eax
80103537:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010353a:	8b 06                	mov    (%esi),%eax
8010353c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103542:	8b 06                	mov    (%esi),%eax
80103544:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103548:	8b 06                	mov    (%esi),%eax
8010354a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010354e:	8b 06                	mov    (%esi),%eax
80103550:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103553:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103556:	31 c0                	xor    %eax,%eax
}
80103558:	5b                   	pop    %ebx
80103559:	5e                   	pop    %esi
8010355a:	5f                   	pop    %edi
8010355b:	5d                   	pop    %ebp
8010355c:	c3                   	ret    
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103560:	8b 03                	mov    (%ebx),%eax
80103562:	85 c0                	test   %eax,%eax
80103564:	74 1e                	je     80103584 <pipealloc+0xe4>
    fileclose(*f0);
80103566:	83 ec 0c             	sub    $0xc,%esp
80103569:	50                   	push   %eax
8010356a:	e8 81 d9 ff ff       	call   80100ef0 <fileclose>
8010356f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103572:	8b 06                	mov    (%esi),%eax
80103574:	85 c0                	test   %eax,%eax
80103576:	74 0c                	je     80103584 <pipealloc+0xe4>
    fileclose(*f1);
80103578:	83 ec 0c             	sub    $0xc,%esp
8010357b:	50                   	push   %eax
8010357c:	e8 6f d9 ff ff       	call   80100ef0 <fileclose>
80103581:	83 c4 10             	add    $0x10,%esp
}
80103584:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103587:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010358c:	5b                   	pop    %ebx
8010358d:	5e                   	pop    %esi
8010358e:	5f                   	pop    %edi
8010358f:	5d                   	pop    %ebp
80103590:	c3                   	ret    
80103591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103598:	8b 03                	mov    (%ebx),%eax
8010359a:	85 c0                	test   %eax,%eax
8010359c:	75 c8                	jne    80103566 <pipealloc+0xc6>
8010359e:	eb d2                	jmp    80103572 <pipealloc+0xd2>

801035a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	56                   	push   %esi
801035a4:	53                   	push   %ebx
801035a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035ab:	83 ec 0c             	sub    $0xc,%esp
801035ae:	53                   	push   %ebx
801035af:	e8 5c 10 00 00       	call   80104610 <acquire>
  if(writable){
801035b4:	83 c4 10             	add    $0x10,%esp
801035b7:	85 f6                	test   %esi,%esi
801035b9:	74 65                	je     80103620 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035bb:	83 ec 0c             	sub    $0xc,%esp
801035be:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035cb:	00 00 00 
    wakeup(&p->nread);
801035ce:	50                   	push   %eax
801035cf:	e8 9c 0b 00 00       	call   80104170 <wakeup>
801035d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035dd:	85 d2                	test   %edx,%edx
801035df:	75 0a                	jne    801035eb <pipeclose+0x4b>
801035e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035e7:	85 c0                	test   %eax,%eax
801035e9:	74 15                	je     80103600 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f1:	5b                   	pop    %ebx
801035f2:	5e                   	pop    %esi
801035f3:	5d                   	pop    %ebp
    release(&p->lock);
801035f4:	e9 b7 0f 00 00       	jmp    801045b0 <release>
801035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	53                   	push   %ebx
80103604:	e8 a7 0f 00 00       	call   801045b0 <release>
    kfree((char*)p);
80103609:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010360c:	83 c4 10             	add    $0x10,%esp
}
8010360f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103612:	5b                   	pop    %ebx
80103613:	5e                   	pop    %esi
80103614:	5d                   	pop    %ebp
    kfree((char*)p);
80103615:	e9 c6 ee ff ff       	jmp    801024e0 <kfree>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103620:	83 ec 0c             	sub    $0xc,%esp
80103623:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103629:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103630:	00 00 00 
    wakeup(&p->nwrite);
80103633:	50                   	push   %eax
80103634:	e8 37 0b 00 00       	call   80104170 <wakeup>
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	eb 99                	jmp    801035d7 <pipeclose+0x37>
8010363e:	66 90                	xchg   %ax,%ax

80103640 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 28             	sub    $0x28,%esp
80103649:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010364c:	53                   	push   %ebx
8010364d:	e8 be 0f 00 00       	call   80104610 <acquire>
  for(i = 0; i < n; i++){
80103652:	8b 45 10             	mov    0x10(%ebp),%eax
80103655:	83 c4 10             	add    $0x10,%esp
80103658:	85 c0                	test   %eax,%eax
8010365a:	0f 8e c0 00 00 00    	jle    80103720 <pipewrite+0xe0>
80103660:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103663:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103669:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010366f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103672:	03 45 10             	add    0x10(%ebp),%eax
80103675:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103678:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010367e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103684:	89 ca                	mov    %ecx,%edx
80103686:	05 00 02 00 00       	add    $0x200,%eax
8010368b:	39 c1                	cmp    %eax,%ecx
8010368d:	74 3f                	je     801036ce <pipewrite+0x8e>
8010368f:	eb 67                	jmp    801036f8 <pipewrite+0xb8>
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103698:	e8 43 03 00 00       	call   801039e0 <myproc>
8010369d:	8b 48 24             	mov    0x24(%eax),%ecx
801036a0:	85 c9                	test   %ecx,%ecx
801036a2:	75 34                	jne    801036d8 <pipewrite+0x98>
      wakeup(&p->nread);
801036a4:	83 ec 0c             	sub    $0xc,%esp
801036a7:	57                   	push   %edi
801036a8:	e8 c3 0a 00 00       	call   80104170 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036ad:	58                   	pop    %eax
801036ae:	5a                   	pop    %edx
801036af:	53                   	push   %ebx
801036b0:	56                   	push   %esi
801036b1:	e8 fa 09 00 00       	call   801040b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036bc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036c2:	83 c4 10             	add    $0x10,%esp
801036c5:	05 00 02 00 00       	add    $0x200,%eax
801036ca:	39 c2                	cmp    %eax,%edx
801036cc:	75 2a                	jne    801036f8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036ce:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036d4:	85 c0                	test   %eax,%eax
801036d6:	75 c0                	jne    80103698 <pipewrite+0x58>
        release(&p->lock);
801036d8:	83 ec 0c             	sub    $0xc,%esp
801036db:	53                   	push   %ebx
801036dc:	e8 cf 0e 00 00       	call   801045b0 <release>
        return -1;
801036e1:	83 c4 10             	add    $0x10,%esp
801036e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ec:	5b                   	pop    %ebx
801036ed:	5e                   	pop    %esi
801036ee:	5f                   	pop    %edi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036fb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036fe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103704:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010370a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010370d:	83 c6 01             	add    $0x1,%esi
80103710:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103713:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103717:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010371a:	0f 85 58 ff ff ff    	jne    80103678 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103729:	50                   	push   %eax
8010372a:	e8 41 0a 00 00       	call   80104170 <wakeup>
  release(&p->lock);
8010372f:	89 1c 24             	mov    %ebx,(%esp)
80103732:	e8 79 0e 00 00       	call   801045b0 <release>
  return n;
80103737:	8b 45 10             	mov    0x10(%ebp),%eax
8010373a:	83 c4 10             	add    $0x10,%esp
8010373d:	eb aa                	jmp    801036e9 <pipewrite+0xa9>
8010373f:	90                   	nop

80103740 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	57                   	push   %edi
80103744:	56                   	push   %esi
80103745:	53                   	push   %ebx
80103746:	83 ec 18             	sub    $0x18,%esp
80103749:	8b 75 08             	mov    0x8(%ebp),%esi
8010374c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010374f:	56                   	push   %esi
80103750:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103756:	e8 b5 0e 00 00       	call   80104610 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010375b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103761:	83 c4 10             	add    $0x10,%esp
80103764:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010376a:	74 2f                	je     8010379b <piperead+0x5b>
8010376c:	eb 37                	jmp    801037a5 <piperead+0x65>
8010376e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103770:	e8 6b 02 00 00       	call   801039e0 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	0f 85 80 00 00 00    	jne    80103800 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103780:	83 ec 08             	sub    $0x8,%esp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
80103785:	e8 26 09 00 00       	call   801040b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010378a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103790:	83 c4 10             	add    $0x10,%esp
80103793:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103799:	75 0a                	jne    801037a5 <piperead+0x65>
8010379b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	75 cb                	jne    80103770 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037a5:	8b 55 10             	mov    0x10(%ebp),%edx
801037a8:	31 db                	xor    %ebx,%ebx
801037aa:	85 d2                	test   %edx,%edx
801037ac:	7f 20                	jg     801037ce <piperead+0x8e>
801037ae:	eb 2c                	jmp    801037dc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037b0:	8d 48 01             	lea    0x1(%eax),%ecx
801037b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037c6:	83 c3 01             	add    $0x1,%ebx
801037c9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037cc:	74 0e                	je     801037dc <piperead+0x9c>
    if(p->nread == p->nwrite)
801037ce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037da:	75 d4                	jne    801037b0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037dc:	83 ec 0c             	sub    $0xc,%esp
801037df:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037e5:	50                   	push   %eax
801037e6:	e8 85 09 00 00       	call   80104170 <wakeup>
  release(&p->lock);
801037eb:	89 34 24             	mov    %esi,(%esp)
801037ee:	e8 bd 0d 00 00       	call   801045b0 <release>
  return i;
801037f3:	83 c4 10             	add    $0x10,%esp
}
801037f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f9:	89 d8                	mov    %ebx,%eax
801037fb:	5b                   	pop    %ebx
801037fc:	5e                   	pop    %esi
801037fd:	5f                   	pop    %edi
801037fe:	5d                   	pop    %ebp
801037ff:	c3                   	ret    
      release(&p->lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103803:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103808:	56                   	push   %esi
80103809:	e8 a2 0d 00 00       	call   801045b0 <release>
      return -1;
8010380e:	83 c4 10             	add    $0x10,%esp
}
80103811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103814:	89 d8                	mov    %ebx,%eax
80103816:	5b                   	pop    %ebx
80103817:	5e                   	pop    %esi
80103818:	5f                   	pop    %edi
80103819:	5d                   	pop    %ebp
8010381a:	c3                   	ret    
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 54 9d 14 80       	mov    $0x80149d54,%ebx
{
80103829:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010382c:	68 20 9d 14 80       	push   $0x80149d20
80103831:	e8 da 0d 00 00       	call   80104610 <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
80103839:	eb 10                	jmp    8010384b <allocproc+0x2b>
8010383b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010383f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103840:	83 c3 7c             	add    $0x7c,%ebx
80103843:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
80103849:	74 75                	je     801038c0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010384b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010384e:	85 c0                	test   %eax,%eax
80103850:	75 ee                	jne    80103840 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103852:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103857:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010385a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103861:	89 43 10             	mov    %eax,0x10(%ebx)
80103864:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103867:	68 20 9d 14 80       	push   $0x80149d20
  p->pid = nextpid++;
8010386c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103872:	e8 39 0d 00 00       	call   801045b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103877:	e8 44 ee ff ff       	call   801026c0 <kalloc>
8010387c:	83 c4 10             	add    $0x10,%esp
8010387f:	89 43 08             	mov    %eax,0x8(%ebx)
80103882:	85 c0                	test   %eax,%eax
80103884:	74 53                	je     801038d9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103886:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010388c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010388f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103894:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103897:	c7 40 14 d2 58 10 80 	movl   $0x801058d2,0x14(%eax)
  p->context = (struct context*)sp;
8010389e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038a1:	6a 14                	push   $0x14
801038a3:	6a 00                	push   $0x0
801038a5:	50                   	push   %eax
801038a6:	e8 25 0e 00 00       	call   801046d0 <memset>
  p->context->eip = (uint)forkret;
801038ab:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038ae:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038b1:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)
}
801038b8:	89 d8                	mov    %ebx,%eax
801038ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038bd:	c9                   	leave  
801038be:	c3                   	ret    
801038bf:	90                   	nop
  release(&ptable.lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038c5:	68 20 9d 14 80       	push   $0x80149d20
801038ca:	e8 e1 0c 00 00       	call   801045b0 <release>
}
801038cf:	89 d8                	mov    %ebx,%eax
  return 0;
801038d1:	83 c4 10             	add    $0x10,%esp
}
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
    p->state = UNUSED;
801038d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038e0:	31 db                	xor    %ebx,%ebx
}
801038e2:	89 d8                	mov    %ebx,%eax
801038e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038e7:	c9                   	leave  
801038e8:	c3                   	ret    
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038f6:	68 20 9d 14 80       	push   $0x80149d20
801038fb:	e8 b0 0c 00 00       	call   801045b0 <release>

  if (first) {
80103900:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	75 04                	jne    80103910 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010390c:	c9                   	leave  
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax
    first = 0;
80103910:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103917:	00 00 00 
    iinit(ROOTDEV);
8010391a:	83 ec 0c             	sub    $0xc,%esp
8010391d:	6a 01                	push   $0x1
8010391f:	e8 3c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010392b:	e8 00 f4 ff ff       	call   80102d30 <initlog>
}
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	c9                   	leave  
80103934:	c3                   	ret    
80103935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103940 <pinit>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103946:	68 60 77 10 80       	push   $0x80107760
8010394b:	68 20 9d 14 80       	push   $0x80149d20
80103950:	e8 eb 0a 00 00       	call   80104440 <initlock>
}
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	c9                   	leave  
80103959:	c3                   	ret    
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103960 <mycpu>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	56                   	push   %esi
80103964:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103965:	9c                   	pushf  
80103966:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103967:	f6 c4 02             	test   $0x2,%ah
8010396a:	75 46                	jne    801039b2 <mycpu+0x52>
  apicid = lapicid();
8010396c:	e8 ef ef ff ff       	call   80102960 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103971:	8b 35 84 97 14 80    	mov    0x80149784,%esi
80103977:	85 f6                	test   %esi,%esi
80103979:	7e 2a                	jle    801039a5 <mycpu+0x45>
8010397b:	31 d2                	xor    %edx,%edx
8010397d:	eb 08                	jmp    80103987 <mycpu+0x27>
8010397f:	90                   	nop
80103980:	83 c2 01             	add    $0x1,%edx
80103983:	39 f2                	cmp    %esi,%edx
80103985:	74 1e                	je     801039a5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103987:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010398d:	0f b6 99 a0 97 14 80 	movzbl -0x7feb6860(%ecx),%ebx
80103994:	39 c3                	cmp    %eax,%ebx
80103996:	75 e8                	jne    80103980 <mycpu+0x20>
}
80103998:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010399b:	8d 81 a0 97 14 80    	lea    -0x7feb6860(%ecx),%eax
}
801039a1:	5b                   	pop    %ebx
801039a2:	5e                   	pop    %esi
801039a3:	5d                   	pop    %ebp
801039a4:	c3                   	ret    
  panic("unknown apicid\n");
801039a5:	83 ec 0c             	sub    $0xc,%esp
801039a8:	68 67 77 10 80       	push   $0x80107767
801039ad:	e8 ce c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039b2:	83 ec 0c             	sub    $0xc,%esp
801039b5:	68 44 78 10 80       	push   $0x80107844
801039ba:	e8 c1 c9 ff ff       	call   80100380 <panic>
801039bf:	90                   	nop

801039c0 <cpuid>:
cpuid() {
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039c6:	e8 95 ff ff ff       	call   80103960 <mycpu>
}
801039cb:	c9                   	leave  
  return mycpu()-cpus;
801039cc:	2d a0 97 14 80       	sub    $0x801497a0,%eax
801039d1:	c1 f8 04             	sar    $0x4,%eax
801039d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039da:	c3                   	ret    
801039db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <myproc>:
myproc(void) {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039e7:	e8 d4 0a 00 00       	call   801044c0 <pushcli>
  c = mycpu();
801039ec:	e8 6f ff ff ff       	call   80103960 <mycpu>
  p = c->proc;
801039f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039f7:	e8 14 0b 00 00       	call   80104510 <popcli>
}
801039fc:	89 d8                	mov    %ebx,%eax
801039fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a01:	c9                   	leave  
80103a02:	c3                   	ret    
80103a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a10 <userinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	53                   	push   %ebx
80103a14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a17:	e8 04 fe ff ff       	call   80103820 <allocproc>
80103a1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a1e:	a3 54 bc 14 80       	mov    %eax,0x8014bc54
  if((p->pgdir = setupkvm()) == 0)
80103a23:	e8 a8 34 00 00       	call   80106ed0 <setupkvm>
80103a28:	89 43 04             	mov    %eax,0x4(%ebx)
80103a2b:	85 c0                	test   %eax,%eax
80103a2d:	0f 84 bd 00 00 00    	je     80103af0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a33:	83 ec 04             	sub    $0x4,%esp
80103a36:	68 2c 00 00 00       	push   $0x2c
80103a3b:	68 60 a4 10 80       	push   $0x8010a460
80103a40:	50                   	push   %eax
80103a41:	e8 2a 31 00 00       	call   80106b70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a4f:	6a 4c                	push   $0x4c
80103a51:	6a 00                	push   $0x0
80103a53:	ff 73 18             	push   0x18(%ebx)
80103a56:	e8 75 0c 00 00       	call   801046d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a63:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a66:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a76:	8b 43 18             	mov    0x18(%ebx),%eax
80103a79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a81:	8b 43 18             	mov    0x18(%ebx),%eax
80103a84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a96:	8b 43 18             	mov    0x18(%ebx),%eax
80103a99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103aa0:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aaa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aad:	6a 10                	push   $0x10
80103aaf:	68 90 77 10 80       	push   $0x80107790
80103ab4:	50                   	push   %eax
80103ab5:	e8 d6 0d 00 00       	call   80104890 <safestrcpy>
  p->cwd = namei("/");
80103aba:	c7 04 24 99 77 10 80 	movl   $0x80107799,(%esp)
80103ac1:	e8 da e5 ff ff       	call   801020a0 <namei>
80103ac6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ac9:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103ad0:	e8 3b 0b 00 00       	call   80104610 <acquire>
  p->state = RUNNABLE;
80103ad5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103adc:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103ae3:	e8 c8 0a 00 00       	call   801045b0 <release>
}
80103ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aeb:	83 c4 10             	add    $0x10,%esp
80103aee:	c9                   	leave  
80103aef:	c3                   	ret    
    panic("userinit: out of memory?");
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	68 77 77 10 80       	push   $0x80107777
80103af8:	e8 83 c8 ff ff       	call   80100380 <panic>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi

80103b00 <growproc>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
80103b05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b08:	e8 b3 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103b0d:	e8 4e fe ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103b12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b18:	e8 f3 09 00 00       	call   80104510 <popcli>
  sz = curproc->sz;
80103b1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b1f:	85 f6                	test   %esi,%esi
80103b21:	7f 1d                	jg     80103b40 <growproc+0x40>
  } else if(n < 0){
80103b23:	75 3b                	jne    80103b60 <growproc+0x60>
  switchuvm(curproc);
80103b25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b2a:	53                   	push   %ebx
80103b2b:	e8 30 2f 00 00       	call   80106a60 <switchuvm>
  return 0;
80103b30:	83 c4 10             	add    $0x10,%esp
80103b33:	31 c0                	xor    %eax,%eax
}
80103b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b38:	5b                   	pop    %ebx
80103b39:	5e                   	pop    %esi
80103b3a:	5d                   	pop    %ebp
80103b3b:	c3                   	ret    
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	push   0x4(%ebx)
80103b4a:	e8 91 31 00 00       	call   80106ce0 <allocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 cf                	jne    80103b25 <growproc+0x25>
      return -1;
80103b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b5b:	eb d8                	jmp    80103b35 <growproc+0x35>
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b60:	83 ec 04             	sub    $0x4,%esp
80103b63:	01 c6                	add    %eax,%esi
80103b65:	56                   	push   %esi
80103b66:	50                   	push   %eax
80103b67:	ff 73 04             	push   0x4(%ebx)
80103b6a:	e8 b1 32 00 00       	call   80106e20 <deallocuvm>
80103b6f:	83 c4 10             	add    $0x10,%esp
80103b72:	85 c0                	test   %eax,%eax
80103b74:	75 af                	jne    80103b25 <growproc+0x25>
80103b76:	eb de                	jmp    80103b56 <growproc+0x56>
80103b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop

80103b80 <fork>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	57                   	push   %edi
80103b84:	56                   	push   %esi
80103b85:	53                   	push   %ebx
80103b86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b89:	e8 32 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103b8e:	e8 cd fd ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103b93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b99:	e8 72 09 00 00       	call   80104510 <popcli>
  if((np = allocproc()) == 0){
80103b9e:	e8 7d fc ff ff       	call   80103820 <allocproc>
80103ba3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ba6:	85 c0                	test   %eax,%eax
80103ba8:	0f 84 b7 00 00 00    	je     80103c65 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bae:	83 ec 08             	sub    $0x8,%esp
80103bb1:	ff 33                	push   (%ebx)
80103bb3:	89 c7                	mov    %eax,%edi
80103bb5:	ff 73 04             	push   0x4(%ebx)
80103bb8:	e8 03 34 00 00       	call   80106fc0 <copyuvm>
80103bbd:	83 c4 10             	add    $0x10,%esp
80103bc0:	89 47 04             	mov    %eax,0x4(%edi)
80103bc3:	85 c0                	test   %eax,%eax
80103bc5:	0f 84 a1 00 00 00    	je     80103c6c <fork+0xec>
  np->sz = curproc->sz;
80103bcb:	8b 03                	mov    (%ebx),%eax
80103bcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bd0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bd2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bd5:	89 c8                	mov    %ecx,%eax
80103bd7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bda:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bdf:	8b 73 18             	mov    0x18(%ebx),%esi
80103be2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103be4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103be6:	8b 40 18             	mov    0x18(%eax),%eax
80103be9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bf0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bf4:	85 c0                	test   %eax,%eax
80103bf6:	74 13                	je     80103c0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bf8:	83 ec 0c             	sub    $0xc,%esp
80103bfb:	50                   	push   %eax
80103bfc:	e8 9f d2 ff ff       	call   80100ea0 <filedup>
80103c01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c04:	83 c4 10             	add    $0x10,%esp
80103c07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c0b:	83 c6 01             	add    $0x1,%esi
80103c0e:	83 fe 10             	cmp    $0x10,%esi
80103c11:	75 dd                	jne    80103bf0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c13:	83 ec 0c             	sub    $0xc,%esp
80103c16:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c1c:	e8 2f db ff ff       	call   80101750 <idup>
80103c21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c2d:	6a 10                	push   $0x10
80103c2f:	53                   	push   %ebx
80103c30:	50                   	push   %eax
80103c31:	e8 5a 0c 00 00       	call   80104890 <safestrcpy>
  pid = np->pid;
80103c36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c39:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103c40:	e8 cb 09 00 00       	call   80104610 <acquire>
  np->state = RUNNABLE;
80103c45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c4c:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103c53:	e8 58 09 00 00       	call   801045b0 <release>
  return pid;
80103c58:	83 c4 10             	add    $0x10,%esp
}
80103c5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c5e:	89 d8                	mov    %ebx,%eax
80103c60:	5b                   	pop    %ebx
80103c61:	5e                   	pop    %esi
80103c62:	5f                   	pop    %edi
80103c63:	5d                   	pop    %ebp
80103c64:	c3                   	ret    
    return -1;
80103c65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c6a:	eb ef                	jmp    80103c5b <fork+0xdb>
    kfree(np->kstack);
80103c6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c6f:	83 ec 0c             	sub    $0xc,%esp
80103c72:	ff 73 08             	push   0x8(%ebx)
80103c75:	e8 66 e8 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
80103c7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c81:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c84:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c90:	eb c9                	jmp    80103c5b <fork+0xdb>
80103c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <scheduler>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
80103ca6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ca9:	e8 b2 fc ff ff       	call   80103960 <mycpu>
  c->proc = 0;
80103cae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cb5:	00 00 00 
  struct cpu *c = mycpu();
80103cb8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103cba:	8d 78 04             	lea    0x4(%eax),%edi
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103cc0:	fb                   	sti    
    acquire(&ptable.lock);
80103cc1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc4:	bb 54 9d 14 80       	mov    $0x80149d54,%ebx
    acquire(&ptable.lock);
80103cc9:	68 20 9d 14 80       	push   $0x80149d20
80103cce:	e8 3d 09 00 00       	call   80104610 <acquire>
80103cd3:	83 c4 10             	add    $0x10,%esp
80103cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ce0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ce4:	75 33                	jne    80103d19 <scheduler+0x79>
      switchuvm(p);
80103ce6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ce9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cef:	53                   	push   %ebx
80103cf0:	e8 6b 2d 00 00       	call   80106a60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cf5:	58                   	pop    %eax
80103cf6:	5a                   	pop    %edx
80103cf7:	ff 73 1c             	push   0x1c(%ebx)
80103cfa:	57                   	push   %edi
      p->state = RUNNING;
80103cfb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d02:	e8 e4 0b 00 00       	call   801048eb <swtch>
      switchkvm();
80103d07:	e8 44 2d 00 00       	call   80106a50 <switchkvm>
      c->proc = 0;
80103d0c:	83 c4 10             	add    $0x10,%esp
80103d0f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d16:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d19:	83 c3 7c             	add    $0x7c,%ebx
80103d1c:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
80103d22:	75 bc                	jne    80103ce0 <scheduler+0x40>
    release(&ptable.lock);
80103d24:	83 ec 0c             	sub    $0xc,%esp
80103d27:	68 20 9d 14 80       	push   $0x80149d20
80103d2c:	e8 7f 08 00 00       	call   801045b0 <release>
    sti();
80103d31:	83 c4 10             	add    $0x10,%esp
80103d34:	eb 8a                	jmp    80103cc0 <scheduler+0x20>
80103d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi

80103d40 <sched>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
  pushcli();
80103d45:	e8 76 07 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103d4a:	e8 11 fc ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103d4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d55:	e8 b6 07 00 00       	call   80104510 <popcli>
  if(!holding(&ptable.lock))
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 20 9d 14 80       	push   $0x80149d20
80103d62:	e8 09 08 00 00       	call   80104570 <holding>
80103d67:	83 c4 10             	add    $0x10,%esp
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	74 4f                	je     80103dbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d6e:	e8 ed fb ff ff       	call   80103960 <mycpu>
80103d73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d7a:	75 68                	jne    80103de4 <sched+0xa4>
  if(p->state == RUNNING)
80103d7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d80:	74 55                	je     80103dd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d82:	9c                   	pushf  
80103d83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d84:	f6 c4 02             	test   $0x2,%ah
80103d87:	75 41                	jne    80103dca <sched+0x8a>
  intena = mycpu()->intena;
80103d89:	e8 d2 fb ff ff       	call   80103960 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d97:	e8 c4 fb ff ff       	call   80103960 <mycpu>
80103d9c:	83 ec 08             	sub    $0x8,%esp
80103d9f:	ff 70 04             	push   0x4(%eax)
80103da2:	53                   	push   %ebx
80103da3:	e8 43 0b 00 00       	call   801048eb <swtch>
  mycpu()->intena = intena;
80103da8:	e8 b3 fb ff ff       	call   80103960 <mycpu>
}
80103dad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103db0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db9:	5b                   	pop    %ebx
80103dba:	5e                   	pop    %esi
80103dbb:	5d                   	pop    %ebp
80103dbc:	c3                   	ret    
    panic("sched ptable.lock");
80103dbd:	83 ec 0c             	sub    $0xc,%esp
80103dc0:	68 9b 77 10 80       	push   $0x8010779b
80103dc5:	e8 b6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 c7 77 10 80       	push   $0x801077c7
80103dd2:	e8 a9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103dd7:	83 ec 0c             	sub    $0xc,%esp
80103dda:	68 b9 77 10 80       	push   $0x801077b9
80103ddf:	e8 9c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	68 ad 77 10 80       	push   $0x801077ad
80103dec:	e8 8f c5 ff ff       	call   80100380 <panic>
80103df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop

80103e00 <exit>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e09:	e8 d2 fb ff ff       	call   801039e0 <myproc>
  if(curproc == initproc)
80103e0e:	39 05 54 bc 14 80    	cmp    %eax,0x8014bc54
80103e14:	0f 84 fd 00 00 00    	je     80103f17 <exit+0x117>
80103e1a:	89 c3                	mov    %eax,%ebx
80103e1c:	8d 70 28             	lea    0x28(%eax),%esi
80103e1f:	8d 78 68             	lea    0x68(%eax),%edi
80103e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e28:	8b 06                	mov    (%esi),%eax
80103e2a:	85 c0                	test   %eax,%eax
80103e2c:	74 12                	je     80103e40 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	50                   	push   %eax
80103e32:	e8 b9 d0 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103e37:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e3d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e40:	83 c6 04             	add    $0x4,%esi
80103e43:	39 f7                	cmp    %esi,%edi
80103e45:	75 e1                	jne    80103e28 <exit+0x28>
  begin_op();
80103e47:	e8 84 ef ff ff       	call   80102dd0 <begin_op>
  iput(curproc->cwd);
80103e4c:	83 ec 0c             	sub    $0xc,%esp
80103e4f:	ff 73 68             	push   0x68(%ebx)
80103e52:	e8 59 da ff ff       	call   801018b0 <iput>
  end_op();
80103e57:	e8 e4 ef ff ff       	call   80102e40 <end_op>
  curproc->cwd = 0;
80103e5c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e63:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103e6a:	e8 a1 07 00 00       	call   80104610 <acquire>
  wakeup1(curproc->parent);
80103e6f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e72:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e75:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
80103e7a:	eb 0e                	jmp    80103e8a <exit+0x8a>
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e80:	83 c0 7c             	add    $0x7c,%eax
80103e83:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80103e88:	74 1c                	je     80103ea6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0x80>
80103e90:	3b 50 20             	cmp    0x20(%eax),%edx
80103e93:	75 eb                	jne    80103e80 <exit+0x80>
      p->state = RUNNABLE;
80103e95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9c:	83 c0 7c             	add    $0x7c,%eax
80103e9f:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80103ea4:	75 e4                	jne    80103e8a <exit+0x8a>
      p->parent = initproc;
80103ea6:	8b 0d 54 bc 14 80    	mov    0x8014bc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eac:	ba 54 9d 14 80       	mov    $0x80149d54,%edx
80103eb1:	eb 10                	jmp    80103ec3 <exit+0xc3>
80103eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb7:	90                   	nop
80103eb8:	83 c2 7c             	add    $0x7c,%edx
80103ebb:	81 fa 54 bc 14 80    	cmp    $0x8014bc54,%edx
80103ec1:	74 3b                	je     80103efe <exit+0xfe>
    if(p->parent == curproc){
80103ec3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103ec6:	75 f0                	jne    80103eb8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103ec8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ecc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ecf:	75 e7                	jne    80103eb8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed1:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
80103ed6:	eb 12                	jmp    80103eea <exit+0xea>
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop
80103ee0:	83 c0 7c             	add    $0x7c,%eax
80103ee3:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80103ee8:	74 ce                	je     80103eb8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eee:	75 f0                	jne    80103ee0 <exit+0xe0>
80103ef0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ef3:	75 eb                	jne    80103ee0 <exit+0xe0>
      p->state = RUNNABLE;
80103ef5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103efc:	eb e2                	jmp    80103ee0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103efe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f05:	e8 36 fe ff ff       	call   80103d40 <sched>
  panic("zombie exit");
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 e8 77 10 80       	push   $0x801077e8
80103f12:	e8 69 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f17:	83 ec 0c             	sub    $0xc,%esp
80103f1a:	68 db 77 10 80       	push   $0x801077db
80103f1f:	e8 5c c4 ff ff       	call   80100380 <panic>
80103f24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f2f:	90                   	nop

80103f30 <wait>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
  pushcli();
80103f35:	e8 86 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f3a:	e8 21 fa ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103f3f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f45:	e8 c6 05 00 00       	call   80104510 <popcli>
  acquire(&ptable.lock);
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 20 9d 14 80       	push   $0x80149d20
80103f52:	e8 b9 06 00 00       	call   80104610 <acquire>
80103f57:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f5a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5c:	bb 54 9d 14 80       	mov    $0x80149d54,%ebx
80103f61:	eb 10                	jmp    80103f73 <wait+0x43>
80103f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f67:	90                   	nop
80103f68:	83 c3 7c             	add    $0x7c,%ebx
80103f6b:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
80103f71:	74 1b                	je     80103f8e <wait+0x5e>
      if(p->parent != curproc)
80103f73:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f76:	75 f0                	jne    80103f68 <wait+0x38>
      if(p->state == ZOMBIE){
80103f78:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f7c:	74 62                	je     80103fe0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f81:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f86:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
80103f8c:	75 e5                	jne    80103f73 <wait+0x43>
    if(!havekids || curproc->killed){
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	0f 84 a0 00 00 00    	je     80104036 <wait+0x106>
80103f96:	8b 46 24             	mov    0x24(%esi),%eax
80103f99:	85 c0                	test   %eax,%eax
80103f9b:	0f 85 95 00 00 00    	jne    80104036 <wait+0x106>
  pushcli();
80103fa1:	e8 1a 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103fa6:	e8 b5 f9 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103fab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb1:	e8 5a 05 00 00       	call   80104510 <popcli>
  if(p == 0)
80103fb6:	85 db                	test   %ebx,%ebx
80103fb8:	0f 84 8f 00 00 00    	je     8010404d <wait+0x11d>
  p->chan = chan;
80103fbe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fc1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fc8:	e8 73 fd ff ff       	call   80103d40 <sched>
  p->chan = 0;
80103fcd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fd4:	eb 84                	jmp    80103f5a <wait+0x2a>
80103fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103fe0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fe3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fe6:	ff 73 08             	push   0x8(%ebx)
80103fe9:	e8 f2 e4 ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
80103fee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ff5:	5a                   	pop    %edx
80103ff6:	ff 73 04             	push   0x4(%ebx)
80103ff9:	e8 52 2e 00 00       	call   80106e50 <freevm>
        p->pid = 0;
80103ffe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104005:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010400c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104010:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104017:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010401e:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80104025:	e8 86 05 00 00       	call   801045b0 <release>
        return pid;
8010402a:	83 c4 10             	add    $0x10,%esp
}
8010402d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104030:	89 f0                	mov    %esi,%eax
80104032:	5b                   	pop    %ebx
80104033:	5e                   	pop    %esi
80104034:	5d                   	pop    %ebp
80104035:	c3                   	ret    
      release(&ptable.lock);
80104036:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104039:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010403e:	68 20 9d 14 80       	push   $0x80149d20
80104043:	e8 68 05 00 00       	call   801045b0 <release>
      return -1;
80104048:	83 c4 10             	add    $0x10,%esp
8010404b:	eb e0                	jmp    8010402d <wait+0xfd>
    panic("sleep");
8010404d:	83 ec 0c             	sub    $0xc,%esp
80104050:	68 f4 77 10 80       	push   $0x801077f4
80104055:	e8 26 c3 ff ff       	call   80100380 <panic>
8010405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104060 <yield>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104067:	68 20 9d 14 80       	push   $0x80149d20
8010406c:	e8 9f 05 00 00       	call   80104610 <acquire>
  pushcli();
80104071:	e8 4a 04 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80104076:	e8 e5 f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010407b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104081:	e8 8a 04 00 00       	call   80104510 <popcli>
  myproc()->state = RUNNABLE;
80104086:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010408d:	e8 ae fc ff ff       	call   80103d40 <sched>
  release(&ptable.lock);
80104092:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80104099:	e8 12 05 00 00       	call   801045b0 <release>
}
8010409e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a1:	83 c4 10             	add    $0x10,%esp
801040a4:	c9                   	leave  
801040a5:	c3                   	ret    
801040a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ad:	8d 76 00             	lea    0x0(%esi),%esi

801040b0 <sleep>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 0c             	sub    $0xc,%esp
801040b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040bf:	e8 fc 03 00 00       	call   801044c0 <pushcli>
  c = mycpu();
801040c4:	e8 97 f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
801040c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040cf:	e8 3c 04 00 00       	call   80104510 <popcli>
  if(p == 0)
801040d4:	85 db                	test   %ebx,%ebx
801040d6:	0f 84 87 00 00 00    	je     80104163 <sleep+0xb3>
  if(lk == 0)
801040dc:	85 f6                	test   %esi,%esi
801040de:	74 76                	je     80104156 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040e0:	81 fe 20 9d 14 80    	cmp    $0x80149d20,%esi
801040e6:	74 50                	je     80104138 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	68 20 9d 14 80       	push   $0x80149d20
801040f0:	e8 1b 05 00 00       	call   80104610 <acquire>
    release(lk);
801040f5:	89 34 24             	mov    %esi,(%esp)
801040f8:	e8 b3 04 00 00       	call   801045b0 <release>
  p->chan = chan;
801040fd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104100:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104107:	e8 34 fc ff ff       	call   80103d40 <sched>
  p->chan = 0;
8010410c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104113:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
8010411a:	e8 91 04 00 00       	call   801045b0 <release>
    acquire(lk);
8010411f:	89 75 08             	mov    %esi,0x8(%ebp)
80104122:	83 c4 10             	add    $0x10,%esp
}
80104125:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104128:	5b                   	pop    %ebx
80104129:	5e                   	pop    %esi
8010412a:	5f                   	pop    %edi
8010412b:	5d                   	pop    %ebp
    acquire(lk);
8010412c:	e9 df 04 00 00       	jmp    80104610 <acquire>
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104138:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010413b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104142:	e8 f9 fb ff ff       	call   80103d40 <sched>
  p->chan = 0;
80104147:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010414e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104151:	5b                   	pop    %ebx
80104152:	5e                   	pop    %esi
80104153:	5f                   	pop    %edi
80104154:	5d                   	pop    %ebp
80104155:	c3                   	ret    
    panic("sleep without lk");
80104156:	83 ec 0c             	sub    $0xc,%esp
80104159:	68 fa 77 10 80       	push   $0x801077fa
8010415e:	e8 1d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104163:	83 ec 0c             	sub    $0xc,%esp
80104166:	68 f4 77 10 80       	push   $0x801077f4
8010416b:	e8 10 c2 ff ff       	call   80100380 <panic>

80104170 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 10             	sub    $0x10,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010417a:	68 20 9d 14 80       	push   $0x80149d20
8010417f:	e8 8c 04 00 00       	call   80104610 <acquire>
80104184:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104187:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
8010418c:	eb 0c                	jmp    8010419a <wakeup+0x2a>
8010418e:	66 90                	xchg   %ax,%ax
80104190:	83 c0 7c             	add    $0x7c,%eax
80104193:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80104198:	74 1c                	je     801041b6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010419a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010419e:	75 f0                	jne    80104190 <wakeup+0x20>
801041a0:	3b 58 20             	cmp    0x20(%eax),%ebx
801041a3:	75 eb                	jne    80104190 <wakeup+0x20>
      p->state = RUNNABLE;
801041a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ac:	83 c0 7c             	add    $0x7c,%eax
801041af:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
801041b4:	75 e4                	jne    8010419a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801041b6:	c7 45 08 20 9d 14 80 	movl   $0x80149d20,0x8(%ebp)
}
801041bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041c0:	c9                   	leave  
  release(&ptable.lock);
801041c1:	e9 ea 03 00 00       	jmp    801045b0 <release>
801041c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041cd:	8d 76 00             	lea    0x0(%esi),%esi

801041d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
801041d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041da:	68 20 9d 14 80       	push   $0x80149d20
801041df:	e8 2c 04 00 00       	call   80104610 <acquire>
801041e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e7:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
801041ec:	eb 0c                	jmp    801041fa <kill+0x2a>
801041ee:	66 90                	xchg   %ax,%ax
801041f0:	83 c0 7c             	add    $0x7c,%eax
801041f3:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
801041f8:	74 36                	je     80104230 <kill+0x60>
    if(p->pid == pid){
801041fa:	39 58 10             	cmp    %ebx,0x10(%eax)
801041fd:	75 f1                	jne    801041f0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041ff:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104203:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010420a:	75 07                	jne    80104213 <kill+0x43>
        p->state = RUNNABLE;
8010420c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104213:	83 ec 0c             	sub    $0xc,%esp
80104216:	68 20 9d 14 80       	push   $0x80149d20
8010421b:	e8 90 03 00 00       	call   801045b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104220:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104223:	83 c4 10             	add    $0x10,%esp
80104226:	31 c0                	xor    %eax,%eax
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	68 20 9d 14 80       	push   $0x80149d20
80104238:	e8 73 03 00 00       	call   801045b0 <release>
}
8010423d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104240:	83 c4 10             	add    $0x10,%esp
80104243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104248:	c9                   	leave  
80104249:	c3                   	ret    
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104258:	53                   	push   %ebx
80104259:	bb c0 9d 14 80       	mov    $0x80149dc0,%ebx
8010425e:	83 ec 3c             	sub    $0x3c,%esp
80104261:	eb 24                	jmp    80104287 <procdump+0x37>
80104263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104267:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 81 7b 10 80       	push   $0x80107b81
80104270:	e8 2b c4 ff ff       	call   801006a0 <cprintf>
80104275:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104278:	83 c3 7c             	add    $0x7c,%ebx
8010427b:	81 fb c0 bc 14 80    	cmp    $0x8014bcc0,%ebx
80104281:	0f 84 81 00 00 00    	je     80104308 <procdump+0xb8>
    if(p->state == UNUSED)
80104287:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010428a:	85 c0                	test   %eax,%eax
8010428c:	74 ea                	je     80104278 <procdump+0x28>
      state = "???";
8010428e:	ba 0b 78 10 80       	mov    $0x8010780b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104293:	83 f8 05             	cmp    $0x5,%eax
80104296:	77 11                	ja     801042a9 <procdump+0x59>
80104298:	8b 14 85 6c 78 10 80 	mov    -0x7fef8794(,%eax,4),%edx
      state = "???";
8010429f:	b8 0b 78 10 80       	mov    $0x8010780b,%eax
801042a4:	85 d2                	test   %edx,%edx
801042a6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042a9:	53                   	push   %ebx
801042aa:	52                   	push   %edx
801042ab:	ff 73 a4             	push   -0x5c(%ebx)
801042ae:	68 0f 78 10 80       	push   $0x8010780f
801042b3:	e8 e8 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801042b8:	83 c4 10             	add    $0x10,%esp
801042bb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042bf:	75 a7                	jne    80104268 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042c1:	83 ec 08             	sub    $0x8,%esp
801042c4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042c7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042ca:	50                   	push   %eax
801042cb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042ce:	8b 40 0c             	mov    0xc(%eax),%eax
801042d1:	83 c0 08             	add    $0x8,%eax
801042d4:	50                   	push   %eax
801042d5:	e8 86 01 00 00       	call   80104460 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042da:	83 c4 10             	add    $0x10,%esp
801042dd:	8d 76 00             	lea    0x0(%esi),%esi
801042e0:	8b 17                	mov    (%edi),%edx
801042e2:	85 d2                	test   %edx,%edx
801042e4:	74 82                	je     80104268 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042e6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042e9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042ec:	52                   	push   %edx
801042ed:	68 61 72 10 80       	push   $0x80107261
801042f2:	e8 a9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042f7:	83 c4 10             	add    $0x10,%esp
801042fa:	39 fe                	cmp    %edi,%esi
801042fc:	75 e2                	jne    801042e0 <procdump+0x90>
801042fe:	e9 65 ff ff ff       	jmp    80104268 <procdump+0x18>
80104303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104307:	90                   	nop
  }
}
80104308:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010430b:	5b                   	pop    %ebx
8010430c:	5e                   	pop    %esi
8010430d:	5f                   	pop    %edi
8010430e:	5d                   	pop    %ebp
8010430f:	c3                   	ret    

80104310 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010431a:	68 84 78 10 80       	push   $0x80107884
8010431f:	8d 43 04             	lea    0x4(%ebx),%eax
80104322:	50                   	push   %eax
80104323:	e8 18 01 00 00       	call   80104440 <initlock>
  lk->name = name;
80104328:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010432b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104331:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104334:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010433b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010433e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104341:	c9                   	leave  
80104342:	c3                   	ret    
80104343:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104358:	8d 73 04             	lea    0x4(%ebx),%esi
8010435b:	83 ec 0c             	sub    $0xc,%esp
8010435e:	56                   	push   %esi
8010435f:	e8 ac 02 00 00       	call   80104610 <acquire>
  while (lk->locked) {
80104364:	8b 13                	mov    (%ebx),%edx
80104366:	83 c4 10             	add    $0x10,%esp
80104369:	85 d2                	test   %edx,%edx
8010436b:	74 16                	je     80104383 <acquiresleep+0x33>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104370:	83 ec 08             	sub    $0x8,%esp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	e8 36 fd ff ff       	call   801040b0 <sleep>
  while (lk->locked) {
8010437a:	8b 03                	mov    (%ebx),%eax
8010437c:	83 c4 10             	add    $0x10,%esp
8010437f:	85 c0                	test   %eax,%eax
80104381:	75 ed                	jne    80104370 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104383:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104389:	e8 52 f6 ff ff       	call   801039e0 <myproc>
8010438e:	8b 40 10             	mov    0x10(%eax),%eax
80104391:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104394:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104397:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010439a:	5b                   	pop    %ebx
8010439b:	5e                   	pop    %esi
8010439c:	5d                   	pop    %ebp
  release(&lk->lk);
8010439d:	e9 0e 02 00 00       	jmp    801045b0 <release>
801043a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
801043b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043b8:	8d 73 04             	lea    0x4(%ebx),%esi
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	56                   	push   %esi
801043bf:	e8 4c 02 00 00       	call   80104610 <acquire>
  lk->locked = 0;
801043c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043d1:	89 1c 24             	mov    %ebx,(%esp)
801043d4:	e8 97 fd ff ff       	call   80104170 <wakeup>
  release(&lk->lk);
801043d9:	89 75 08             	mov    %esi,0x8(%ebp)
801043dc:	83 c4 10             	add    $0x10,%esp
}
801043df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043e2:	5b                   	pop    %ebx
801043e3:	5e                   	pop    %esi
801043e4:	5d                   	pop    %ebp
  release(&lk->lk);
801043e5:	e9 c6 01 00 00       	jmp    801045b0 <release>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	31 ff                	xor    %edi,%edi
801043f6:	56                   	push   %esi
801043f7:	53                   	push   %ebx
801043f8:	83 ec 18             	sub    $0x18,%esp
801043fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104401:	56                   	push   %esi
80104402:	e8 09 02 00 00       	call   80104610 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104407:	8b 03                	mov    (%ebx),%eax
80104409:	83 c4 10             	add    $0x10,%esp
8010440c:	85 c0                	test   %eax,%eax
8010440e:	75 18                	jne    80104428 <holdingsleep+0x38>
  release(&lk->lk);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	56                   	push   %esi
80104414:	e8 97 01 00 00       	call   801045b0 <release>
  return r;
}
80104419:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010441c:	89 f8                	mov    %edi,%eax
8010441e:	5b                   	pop    %ebx
8010441f:	5e                   	pop    %esi
80104420:	5f                   	pop    %edi
80104421:	5d                   	pop    %ebp
80104422:	c3                   	ret    
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104428:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010442b:	e8 b0 f5 ff ff       	call   801039e0 <myproc>
80104430:	39 58 10             	cmp    %ebx,0x10(%eax)
80104433:	0f 94 c0             	sete   %al
80104436:	0f b6 c0             	movzbl %al,%eax
80104439:	89 c7                	mov    %eax,%edi
8010443b:	eb d3                	jmp    80104410 <holdingsleep+0x20>
8010443d:	66 90                	xchg   %ax,%ax
8010443f:	90                   	nop

80104440 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104446:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104449:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010444f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104452:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104459:	5d                   	pop    %ebp
8010445a:	c3                   	ret    
8010445b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop

80104460 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104460:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104461:	31 d2                	xor    %edx,%edx
{
80104463:	89 e5                	mov    %esp,%ebp
80104465:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104466:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104469:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010446c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010446f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104470:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104476:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010447c:	77 1a                	ja     80104498 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010447e:	8b 58 04             	mov    0x4(%eax),%ebx
80104481:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104484:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104487:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104489:	83 fa 0a             	cmp    $0xa,%edx
8010448c:	75 e2                	jne    80104470 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010448e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104491:	c9                   	leave  
80104492:	c3                   	ret    
80104493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104497:	90                   	nop
  for(; i < 10; i++)
80104498:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010449b:	8d 51 28             	lea    0x28(%ecx),%edx
8010449e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801044a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044a6:	83 c0 04             	add    $0x4,%eax
801044a9:	39 d0                	cmp    %edx,%eax
801044ab:	75 f3                	jne    801044a0 <getcallerpcs+0x40>
}
801044ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b0:	c9                   	leave  
801044b1:	c3                   	ret    
801044b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 04             	sub    $0x4,%esp
801044c7:	9c                   	pushf  
801044c8:	5b                   	pop    %ebx
  asm volatile("cli");
801044c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ca:	e8 91 f4 ff ff       	call   80103960 <mycpu>
801044cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044d5:	85 c0                	test   %eax,%eax
801044d7:	74 17                	je     801044f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044d9:	e8 82 f4 ff ff       	call   80103960 <mycpu>
801044de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e8:	c9                   	leave  
801044e9:	c3                   	ret    
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044f0:	e8 6b f4 ff ff       	call   80103960 <mycpu>
801044f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104501:	eb d6                	jmp    801044d9 <pushcli+0x19>
80104503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <popcli>:

void
popcli(void)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104516:	9c                   	pushf  
80104517:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104518:	f6 c4 02             	test   $0x2,%ah
8010451b:	75 35                	jne    80104552 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010451d:	e8 3e f4 ff ff       	call   80103960 <mycpu>
80104522:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104529:	78 34                	js     8010455f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010452b:	e8 30 f4 ff ff       	call   80103960 <mycpu>
80104530:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104536:	85 d2                	test   %edx,%edx
80104538:	74 06                	je     80104540 <popcli+0x30>
    sti();
}
8010453a:	c9                   	leave  
8010453b:	c3                   	ret    
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104540:	e8 1b f4 ff ff       	call   80103960 <mycpu>
80104545:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010454b:	85 c0                	test   %eax,%eax
8010454d:	74 eb                	je     8010453a <popcli+0x2a>
  asm volatile("sti");
8010454f:	fb                   	sti    
}
80104550:	c9                   	leave  
80104551:	c3                   	ret    
    panic("popcli - interruptible");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 8f 78 10 80       	push   $0x8010788f
8010455a:	e8 21 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 a6 78 10 80       	push   $0x801078a6
80104567:	e8 14 be ff ff       	call   80100380 <panic>
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <holding>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 75 08             	mov    0x8(%ebp),%esi
80104578:	31 db                	xor    %ebx,%ebx
  pushcli();
8010457a:	e8 41 ff ff ff       	call   801044c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010457f:	8b 06                	mov    (%esi),%eax
80104581:	85 c0                	test   %eax,%eax
80104583:	75 0b                	jne    80104590 <holding+0x20>
  popcli();
80104585:	e8 86 ff ff ff       	call   80104510 <popcli>
}
8010458a:	89 d8                	mov    %ebx,%eax
8010458c:	5b                   	pop    %ebx
8010458d:	5e                   	pop    %esi
8010458e:	5d                   	pop    %ebp
8010458f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104590:	8b 5e 08             	mov    0x8(%esi),%ebx
80104593:	e8 c8 f3 ff ff       	call   80103960 <mycpu>
80104598:	39 c3                	cmp    %eax,%ebx
8010459a:	0f 94 c3             	sete   %bl
  popcli();
8010459d:	e8 6e ff ff ff       	call   80104510 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801045a2:	0f b6 db             	movzbl %bl,%ebx
}
801045a5:	89 d8                	mov    %ebx,%eax
801045a7:	5b                   	pop    %ebx
801045a8:	5e                   	pop    %esi
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret    
801045ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045af:	90                   	nop

801045b0 <release>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045b8:	e8 03 ff ff ff       	call   801044c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045bd:	8b 03                	mov    (%ebx),%eax
801045bf:	85 c0                	test   %eax,%eax
801045c1:	75 15                	jne    801045d8 <release+0x28>
  popcli();
801045c3:	e8 48 ff ff ff       	call   80104510 <popcli>
    panic("release");
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	68 ad 78 10 80       	push   $0x801078ad
801045d0:	e8 ab bd ff ff       	call   80100380 <panic>
801045d5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801045d8:	8b 73 08             	mov    0x8(%ebx),%esi
801045db:	e8 80 f3 ff ff       	call   80103960 <mycpu>
801045e0:	39 c6                	cmp    %eax,%esi
801045e2:	75 df                	jne    801045c3 <release+0x13>
  popcli();
801045e4:	e8 27 ff ff ff       	call   80104510 <popcli>
  lk->pcs[0] = 0;
801045e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104602:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104605:	5b                   	pop    %ebx
80104606:	5e                   	pop    %esi
80104607:	5d                   	pop    %ebp
  popcli();
80104608:	e9 03 ff ff ff       	jmp    80104510 <popcli>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi

80104610 <acquire>:
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104617:	e8 a4 fe ff ff       	call   801044c0 <pushcli>
  if(holding(lk))
8010461c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010461f:	e8 9c fe ff ff       	call   801044c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104624:	8b 03                	mov    (%ebx),%eax
80104626:	85 c0                	test   %eax,%eax
80104628:	75 7e                	jne    801046a8 <acquire+0x98>
  popcli();
8010462a:	e8 e1 fe ff ff       	call   80104510 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010462f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104638:	8b 55 08             	mov    0x8(%ebp),%edx
8010463b:	89 c8                	mov    %ecx,%eax
8010463d:	f0 87 02             	lock xchg %eax,(%edx)
80104640:	85 c0                	test   %eax,%eax
80104642:	75 f4                	jne    80104638 <acquire+0x28>
  __sync_synchronize();
80104644:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104649:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010464c:	e8 0f f3 ff ff       	call   80103960 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104651:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104654:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104656:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104659:	31 c0                	xor    %eax,%eax
8010465b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010465f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104660:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104666:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010466c:	77 1a                	ja     80104688 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010466e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104671:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104675:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104678:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010467a:	83 f8 0a             	cmp    $0xa,%eax
8010467d:	75 e1                	jne    80104660 <acquire+0x50>
}
8010467f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104682:	c9                   	leave  
80104683:	c3                   	ret    
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104688:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010468c:	8d 51 34             	lea    0x34(%ecx),%edx
8010468f:	90                   	nop
    pcs[i] = 0;
80104690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104696:	83 c0 04             	add    $0x4,%eax
80104699:	39 c2                	cmp    %eax,%edx
8010469b:	75 f3                	jne    80104690 <acquire+0x80>
}
8010469d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a0:	c9                   	leave  
801046a1:	c3                   	ret    
801046a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046a8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046ab:	e8 b0 f2 ff ff       	call   80103960 <mycpu>
801046b0:	39 c3                	cmp    %eax,%ebx
801046b2:	0f 85 72 ff ff ff    	jne    8010462a <acquire+0x1a>
  popcli();
801046b8:	e8 53 fe ff ff       	call   80104510 <popcli>
    panic("acquire");
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	68 b5 78 10 80       	push   $0x801078b5
801046c5:	e8 b6 bc ff ff       	call   80100380 <panic>
801046ca:	66 90                	xchg   %ax,%ax
801046cc:	66 90                	xchg   %ax,%ax
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	8b 55 08             	mov    0x8(%ebp),%edx
801046d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046da:	53                   	push   %ebx
801046db:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046de:	89 d7                	mov    %edx,%edi
801046e0:	09 cf                	or     %ecx,%edi
801046e2:	83 e7 03             	and    $0x3,%edi
801046e5:	75 29                	jne    80104710 <memset+0x40>
    c &= 0xFF;
801046e7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ea:	c1 e0 18             	shl    $0x18,%eax
801046ed:	89 fb                	mov    %edi,%ebx
801046ef:	c1 e9 02             	shr    $0x2,%ecx
801046f2:	c1 e3 10             	shl    $0x10,%ebx
801046f5:	09 d8                	or     %ebx,%eax
801046f7:	09 f8                	or     %edi,%eax
801046f9:	c1 e7 08             	shl    $0x8,%edi
801046fc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046fe:	89 d7                	mov    %edx,%edi
80104700:	fc                   	cld    
80104701:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104703:	5b                   	pop    %ebx
80104704:	89 d0                	mov    %edx,%eax
80104706:	5f                   	pop    %edi
80104707:	5d                   	pop    %ebp
80104708:	c3                   	ret    
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104710:	89 d7                	mov    %edx,%edi
80104712:	fc                   	cld    
80104713:	f3 aa                	rep stos %al,%es:(%edi)
80104715:	5b                   	pop    %ebx
80104716:	89 d0                	mov    %edx,%eax
80104718:	5f                   	pop    %edi
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop

80104720 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	8b 75 10             	mov    0x10(%ebp),%esi
80104727:	8b 55 08             	mov    0x8(%ebp),%edx
8010472a:	53                   	push   %ebx
8010472b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010472e:	85 f6                	test   %esi,%esi
80104730:	74 2e                	je     80104760 <memcmp+0x40>
80104732:	01 c6                	add    %eax,%esi
80104734:	eb 14                	jmp    8010474a <memcmp+0x2a>
80104736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104740:	83 c0 01             	add    $0x1,%eax
80104743:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104746:	39 f0                	cmp    %esi,%eax
80104748:	74 16                	je     80104760 <memcmp+0x40>
    if(*s1 != *s2)
8010474a:	0f b6 0a             	movzbl (%edx),%ecx
8010474d:	0f b6 18             	movzbl (%eax),%ebx
80104750:	38 d9                	cmp    %bl,%cl
80104752:	74 ec                	je     80104740 <memcmp+0x20>
      return *s1 - *s2;
80104754:	0f b6 c1             	movzbl %cl,%eax
80104757:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104759:	5b                   	pop    %ebx
8010475a:	5e                   	pop    %esi
8010475b:	5d                   	pop    %ebp
8010475c:	c3                   	ret    
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
80104760:	5b                   	pop    %ebx
  return 0;
80104761:	31 c0                	xor    %eax,%eax
}
80104763:	5e                   	pop    %esi
80104764:	5d                   	pop    %ebp
80104765:	c3                   	ret    
80104766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	8b 55 08             	mov    0x8(%ebp),%edx
80104777:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010477a:	56                   	push   %esi
8010477b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010477e:	39 d6                	cmp    %edx,%esi
80104780:	73 26                	jae    801047a8 <memmove+0x38>
80104782:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104785:	39 fa                	cmp    %edi,%edx
80104787:	73 1f                	jae    801047a8 <memmove+0x38>
80104789:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010478c:	85 c9                	test   %ecx,%ecx
8010478e:	74 0c                	je     8010479c <memmove+0x2c>
      *--d = *--s;
80104790:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104794:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104797:	83 e8 01             	sub    $0x1,%eax
8010479a:	73 f4                	jae    80104790 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010479c:	5e                   	pop    %esi
8010479d:	89 d0                	mov    %edx,%eax
8010479f:	5f                   	pop    %edi
801047a0:	5d                   	pop    %ebp
801047a1:	c3                   	ret    
801047a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801047a8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801047ab:	89 d7                	mov    %edx,%edi
801047ad:	85 c9                	test   %ecx,%ecx
801047af:	74 eb                	je     8010479c <memmove+0x2c>
801047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047b8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047b9:	39 c6                	cmp    %eax,%esi
801047bb:	75 fb                	jne    801047b8 <memmove+0x48>
}
801047bd:	5e                   	pop    %esi
801047be:	89 d0                	mov    %edx,%eax
801047c0:	5f                   	pop    %edi
801047c1:	5d                   	pop    %ebp
801047c2:	c3                   	ret    
801047c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047d0:	eb 9e                	jmp    80104770 <memmove>
801047d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	8b 75 10             	mov    0x10(%ebp),%esi
801047e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ea:	53                   	push   %ebx
801047eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801047ee:	85 f6                	test   %esi,%esi
801047f0:	74 2e                	je     80104820 <strncmp+0x40>
801047f2:	01 d6                	add    %edx,%esi
801047f4:	eb 18                	jmp    8010480e <strncmp+0x2e>
801047f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
80104800:	38 d8                	cmp    %bl,%al
80104802:	75 14                	jne    80104818 <strncmp+0x38>
    n--, p++, q++;
80104804:	83 c2 01             	add    $0x1,%edx
80104807:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010480a:	39 f2                	cmp    %esi,%edx
8010480c:	74 12                	je     80104820 <strncmp+0x40>
8010480e:	0f b6 01             	movzbl (%ecx),%eax
80104811:	0f b6 1a             	movzbl (%edx),%ebx
80104814:	84 c0                	test   %al,%al
80104816:	75 e8                	jne    80104800 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104818:	29 d8                	sub    %ebx,%eax
}
8010481a:	5b                   	pop    %ebx
8010481b:	5e                   	pop    %esi
8010481c:	5d                   	pop    %ebp
8010481d:	c3                   	ret    
8010481e:	66 90                	xchg   %ax,%ax
80104820:	5b                   	pop    %ebx
    return 0;
80104821:	31 c0                	xor    %eax,%eax
}
80104823:	5e                   	pop    %esi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
80104826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	56                   	push   %esi
80104835:	8b 75 08             	mov    0x8(%ebp),%esi
80104838:	53                   	push   %ebx
80104839:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010483c:	89 f0                	mov    %esi,%eax
8010483e:	eb 15                	jmp    80104855 <strncpy+0x25>
80104840:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104844:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104847:	83 c0 01             	add    $0x1,%eax
8010484a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010484e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104851:	84 d2                	test   %dl,%dl
80104853:	74 09                	je     8010485e <strncpy+0x2e>
80104855:	89 cb                	mov    %ecx,%ebx
80104857:	83 e9 01             	sub    $0x1,%ecx
8010485a:	85 db                	test   %ebx,%ebx
8010485c:	7f e2                	jg     80104840 <strncpy+0x10>
    ;
  while(n-- > 0)
8010485e:	89 c2                	mov    %eax,%edx
80104860:	85 c9                	test   %ecx,%ecx
80104862:	7e 17                	jle    8010487b <strncpy+0x4b>
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104868:	83 c2 01             	add    $0x1,%edx
8010486b:	89 c1                	mov    %eax,%ecx
8010486d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104871:	29 d1                	sub    %edx,%ecx
80104873:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104877:	85 c9                	test   %ecx,%ecx
80104879:	7f ed                	jg     80104868 <strncpy+0x38>
  return os;
}
8010487b:	5b                   	pop    %ebx
8010487c:	89 f0                	mov    %esi,%eax
8010487e:	5e                   	pop    %esi
8010487f:	5f                   	pop    %edi
80104880:	5d                   	pop    %ebp
80104881:	c3                   	ret    
80104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104890 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	8b 55 10             	mov    0x10(%ebp),%edx
80104897:	8b 75 08             	mov    0x8(%ebp),%esi
8010489a:	53                   	push   %ebx
8010489b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010489e:	85 d2                	test   %edx,%edx
801048a0:	7e 25                	jle    801048c7 <safestrcpy+0x37>
801048a2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048a6:	89 f2                	mov    %esi,%edx
801048a8:	eb 16                	jmp    801048c0 <safestrcpy+0x30>
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048b0:	0f b6 08             	movzbl (%eax),%ecx
801048b3:	83 c0 01             	add    $0x1,%eax
801048b6:	83 c2 01             	add    $0x1,%edx
801048b9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048bc:	84 c9                	test   %cl,%cl
801048be:	74 04                	je     801048c4 <safestrcpy+0x34>
801048c0:	39 d8                	cmp    %ebx,%eax
801048c2:	75 ec                	jne    801048b0 <safestrcpy+0x20>
    ;
  *s = 0;
801048c4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048c7:	89 f0                	mov    %esi,%eax
801048c9:	5b                   	pop    %ebx
801048ca:	5e                   	pop    %esi
801048cb:	5d                   	pop    %ebp
801048cc:	c3                   	ret    
801048cd:	8d 76 00             	lea    0x0(%esi),%esi

801048d0 <strlen>:

int
strlen(const char *s)
{
801048d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048d1:	31 c0                	xor    %eax,%eax
{
801048d3:	89 e5                	mov    %esp,%ebp
801048d5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048d8:	80 3a 00             	cmpb   $0x0,(%edx)
801048db:	74 0c                	je     801048e9 <strlen+0x19>
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	83 c0 01             	add    $0x1,%eax
801048e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048e7:	75 f7                	jne    801048e0 <strlen+0x10>
    ;
  return n;
}
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    

801048eb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048f3:	55                   	push   %ebp
  pushl %ebx
801048f4:	53                   	push   %ebx
  pushl %esi
801048f5:	56                   	push   %esi
  pushl %edi
801048f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048f9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048fb:	5f                   	pop    %edi
  popl %esi
801048fc:	5e                   	pop    %esi
  popl %ebx
801048fd:	5b                   	pop    %ebx
  popl %ebp
801048fe:	5d                   	pop    %ebp
  ret
801048ff:	c3                   	ret    

80104900 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 04             	sub    $0x4,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010490a:	e8 d1 f0 ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010490f:	8b 00                	mov    (%eax),%eax
80104911:	39 d8                	cmp    %ebx,%eax
80104913:	76 1b                	jbe    80104930 <fetchint+0x30>
80104915:	8d 53 04             	lea    0x4(%ebx),%edx
80104918:	39 d0                	cmp    %edx,%eax
8010491a:	72 14                	jb     80104930 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010491c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010491f:	8b 13                	mov    (%ebx),%edx
80104921:	89 10                	mov    %edx,(%eax)
  return 0;
80104923:	31 c0                	xor    %eax,%eax
}
80104925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104928:	c9                   	leave  
80104929:	c3                   	ret    
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104935:	eb ee                	jmp    80104925 <fetchint+0x25>
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax

80104940 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 04             	sub    $0x4,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010494a:	e8 91 f0 ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz)
8010494f:	39 18                	cmp    %ebx,(%eax)
80104951:	76 2d                	jbe    80104980 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104953:	8b 55 0c             	mov    0xc(%ebp),%edx
80104956:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104958:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010495a:	39 d3                	cmp    %edx,%ebx
8010495c:	73 22                	jae    80104980 <fetchstr+0x40>
8010495e:	89 d8                	mov    %ebx,%eax
80104960:	eb 0d                	jmp    8010496f <fetchstr+0x2f>
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104968:	83 c0 01             	add    $0x1,%eax
8010496b:	39 c2                	cmp    %eax,%edx
8010496d:	76 11                	jbe    80104980 <fetchstr+0x40>
    if(*s == 0)
8010496f:	80 38 00             	cmpb   $0x0,(%eax)
80104972:	75 f4                	jne    80104968 <fetchstr+0x28>
      return s - *pp;
80104974:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104976:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104979:	c9                   	leave  
8010497a:	c3                   	ret    
8010497b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010497f:	90                   	nop
80104980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104988:	c9                   	leave  
80104989:	c3                   	ret    
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104995:	e8 46 f0 ff ff       	call   801039e0 <myproc>
8010499a:	8b 55 08             	mov    0x8(%ebp),%edx
8010499d:	8b 40 18             	mov    0x18(%eax),%eax
801049a0:	8b 40 44             	mov    0x44(%eax),%eax
801049a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049a6:	e8 35 f0 ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ae:	8b 00                	mov    (%eax),%eax
801049b0:	39 c6                	cmp    %eax,%esi
801049b2:	73 1c                	jae    801049d0 <argint+0x40>
801049b4:	8d 53 08             	lea    0x8(%ebx),%edx
801049b7:	39 d0                	cmp    %edx,%eax
801049b9:	72 15                	jb     801049d0 <argint+0x40>
  *ip = *(int*)(addr);
801049bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801049be:	8b 53 04             	mov    0x4(%ebx),%edx
801049c1:	89 10                	mov    %edx,(%eax)
  return 0;
801049c3:	31 c0                	xor    %eax,%eax
}
801049c5:	5b                   	pop    %ebx
801049c6:	5e                   	pop    %esi
801049c7:	5d                   	pop    %ebp
801049c8:	c3                   	ret    
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049d5:	eb ee                	jmp    801049c5 <argint+0x35>
801049d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049de:	66 90                	xchg   %ax,%ax

801049e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	56                   	push   %esi
801049e5:	53                   	push   %ebx
801049e6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049e9:	e8 f2 ef ff ff       	call   801039e0 <myproc>
801049ee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f0:	e8 eb ef ff ff       	call   801039e0 <myproc>
801049f5:	8b 55 08             	mov    0x8(%ebp),%edx
801049f8:	8b 40 18             	mov    0x18(%eax),%eax
801049fb:	8b 40 44             	mov    0x44(%eax),%eax
801049fe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a01:	e8 da ef ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a06:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a09:	8b 00                	mov    (%eax),%eax
80104a0b:	39 c7                	cmp    %eax,%edi
80104a0d:	73 31                	jae    80104a40 <argptr+0x60>
80104a0f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a12:	39 c8                	cmp    %ecx,%eax
80104a14:	72 2a                	jb     80104a40 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a16:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104a19:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a1c:	85 d2                	test   %edx,%edx
80104a1e:	78 20                	js     80104a40 <argptr+0x60>
80104a20:	8b 16                	mov    (%esi),%edx
80104a22:	39 c2                	cmp    %eax,%edx
80104a24:	76 1a                	jbe    80104a40 <argptr+0x60>
80104a26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a29:	01 c3                	add    %eax,%ebx
80104a2b:	39 da                	cmp    %ebx,%edx
80104a2d:	72 11                	jb     80104a40 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a32:	89 02                	mov    %eax,(%edx)
  return 0;
80104a34:	31 c0                	xor    %eax,%eax
}
80104a36:	83 c4 0c             	add    $0xc,%esp
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5f                   	pop    %edi
80104a3c:	5d                   	pop    %ebp
80104a3d:	c3                   	ret    
80104a3e:	66 90                	xchg   %ax,%ax
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a45:	eb ef                	jmp    80104a36 <argptr+0x56>
80104a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a55:	e8 86 ef ff ff       	call   801039e0 <myproc>
80104a5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5d:	8b 40 18             	mov    0x18(%eax),%eax
80104a60:	8b 40 44             	mov    0x44(%eax),%eax
80104a63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a66:	e8 75 ef ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6e:	8b 00                	mov    (%eax),%eax
80104a70:	39 c6                	cmp    %eax,%esi
80104a72:	73 44                	jae    80104ab8 <argstr+0x68>
80104a74:	8d 53 08             	lea    0x8(%ebx),%edx
80104a77:	39 d0                	cmp    %edx,%eax
80104a79:	72 3d                	jb     80104ab8 <argstr+0x68>
  *ip = *(int*)(addr);
80104a7b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a7e:	e8 5d ef ff ff       	call   801039e0 <myproc>
  if(addr >= curproc->sz)
80104a83:	3b 18                	cmp    (%eax),%ebx
80104a85:	73 31                	jae    80104ab8 <argstr+0x68>
  *pp = (char*)addr;
80104a87:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a8e:	39 d3                	cmp    %edx,%ebx
80104a90:	73 26                	jae    80104ab8 <argstr+0x68>
80104a92:	89 d8                	mov    %ebx,%eax
80104a94:	eb 11                	jmp    80104aa7 <argstr+0x57>
80104a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 01             	add    $0x1,%eax
80104aa3:	39 c2                	cmp    %eax,%edx
80104aa5:	76 11                	jbe    80104ab8 <argstr+0x68>
    if(*s == 0)
80104aa7:	80 38 00             	cmpb   $0x0,(%eax)
80104aaa:	75 f4                	jne    80104aa0 <argstr+0x50>
      return s - *pp;
80104aac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104aae:	5b                   	pop    %ebx
80104aaf:	5e                   	pop    %esi
80104ab0:	5d                   	pop    %ebp
80104ab1:	c3                   	ret    
80104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ab8:	5b                   	pop    %ebx
    return -1;
80104ab9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104abe:	5e                   	pop    %esi
80104abf:	5d                   	pop    %ebp
80104ac0:	c3                   	ret    
80104ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acf:	90                   	nop

80104ad0 <syscall>:
[SYS_getNumFreePages] sys_getNumFreePages
};

void
syscall(void)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ad7:	e8 04 ef ff ff       	call   801039e0 <myproc>
80104adc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ade:	8b 40 18             	mov    0x18(%eax),%eax
80104ae1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ae4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ae7:	83 fa 15             	cmp    $0x15,%edx
80104aea:	77 24                	ja     80104b10 <syscall+0x40>
80104aec:	8b 14 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%edx
80104af3:	85 d2                	test   %edx,%edx
80104af5:	74 19                	je     80104b10 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104af7:	ff d2                	call   *%edx
80104af9:	89 c2                	mov    %eax,%edx
80104afb:	8b 43 18             	mov    0x18(%ebx),%eax
80104afe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b04:	c9                   	leave  
80104b05:	c3                   	ret    
80104b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b10:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b11:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b14:	50                   	push   %eax
80104b15:	ff 73 10             	push   0x10(%ebx)
80104b18:	68 bd 78 10 80       	push   $0x801078bd
80104b1d:	e8 7e bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104b22:	8b 43 18             	mov    0x18(%ebx),%eax
80104b25:	83 c4 10             	add    $0x10,%esp
80104b28:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b32:	c9                   	leave  
80104b33:	c3                   	ret    
80104b34:	66 90                	xchg   %ax,%ax
80104b36:	66 90                	xchg   %ax,%ax
80104b38:	66 90                	xchg   %ax,%ax
80104b3a:	66 90                	xchg   %ax,%ax
80104b3c:	66 90                	xchg   %ax,%ax
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b45:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b48:	53                   	push   %ebx
80104b49:	83 ec 34             	sub    $0x34,%esp
80104b4c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b52:	57                   	push   %edi
80104b53:	50                   	push   %eax
{
80104b54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b57:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b5a:	e8 61 d5 ff ff       	call   801020c0 <nameiparent>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	85 c0                	test   %eax,%eax
80104b64:	0f 84 46 01 00 00    	je     80104cb0 <create+0x170>
    return 0;
  ilock(dp);
80104b6a:	83 ec 0c             	sub    $0xc,%esp
80104b6d:	89 c3                	mov    %eax,%ebx
80104b6f:	50                   	push   %eax
80104b70:	e8 0b cc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b75:	83 c4 0c             	add    $0xc,%esp
80104b78:	6a 00                	push   $0x0
80104b7a:	57                   	push   %edi
80104b7b:	53                   	push   %ebx
80104b7c:	e8 5f d1 ff ff       	call   80101ce0 <dirlookup>
80104b81:	83 c4 10             	add    $0x10,%esp
80104b84:	89 c6                	mov    %eax,%esi
80104b86:	85 c0                	test   %eax,%eax
80104b88:	74 56                	je     80104be0 <create+0xa0>
    iunlockput(dp);
80104b8a:	83 ec 0c             	sub    $0xc,%esp
80104b8d:	53                   	push   %ebx
80104b8e:	e8 7d ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104b93:	89 34 24             	mov    %esi,(%esp)
80104b96:	e8 e5 cb ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b9b:	83 c4 10             	add    $0x10,%esp
80104b9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ba3:	75 1b                	jne    80104bc0 <create+0x80>
80104ba5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104baa:	75 14                	jne    80104bc0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104baf:	89 f0                	mov    %esi,%eax
80104bb1:	5b                   	pop    %ebx
80104bb2:	5e                   	pop    %esi
80104bb3:	5f                   	pop    %edi
80104bb4:	5d                   	pop    %ebp
80104bb5:	c3                   	ret    
80104bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	56                   	push   %esi
    return 0;
80104bc4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104bc6:	e8 45 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104bcb:	83 c4 10             	add    $0x10,%esp
}
80104bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bd1:	89 f0                	mov    %esi,%eax
80104bd3:	5b                   	pop    %ebx
80104bd4:	5e                   	pop    %esi
80104bd5:	5f                   	pop    %edi
80104bd6:	5d                   	pop    %ebp
80104bd7:	c3                   	ret    
80104bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104be0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104be4:	83 ec 08             	sub    $0x8,%esp
80104be7:	50                   	push   %eax
80104be8:	ff 33                	push   (%ebx)
80104bea:	e8 21 ca ff ff       	call   80101610 <ialloc>
80104bef:	83 c4 10             	add    $0x10,%esp
80104bf2:	89 c6                	mov    %eax,%esi
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	0f 84 cd 00 00 00    	je     80104cc9 <create+0x189>
  ilock(ip);
80104bfc:	83 ec 0c             	sub    $0xc,%esp
80104bff:	50                   	push   %eax
80104c00:	e8 7b cb ff ff       	call   80101780 <ilock>
  ip->major = major;
80104c05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c15:	b8 01 00 00 00       	mov    $0x1,%eax
80104c1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c1e:	89 34 24             	mov    %esi,(%esp)
80104c21:	e8 aa ca ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c26:	83 c4 10             	add    $0x10,%esp
80104c29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c2e:	74 30                	je     80104c60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c30:	83 ec 04             	sub    $0x4,%esp
80104c33:	ff 76 04             	push   0x4(%esi)
80104c36:	57                   	push   %edi
80104c37:	53                   	push   %ebx
80104c38:	e8 a3 d3 ff ff       	call   80101fe0 <dirlink>
80104c3d:	83 c4 10             	add    $0x10,%esp
80104c40:	85 c0                	test   %eax,%eax
80104c42:	78 78                	js     80104cbc <create+0x17c>
  iunlockput(dp);
80104c44:	83 ec 0c             	sub    $0xc,%esp
80104c47:	53                   	push   %ebx
80104c48:	e8 c3 cd ff ff       	call   80101a10 <iunlockput>
  return ip;
80104c4d:	83 c4 10             	add    $0x10,%esp
}
80104c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c53:	89 f0                	mov    %esi,%eax
80104c55:	5b                   	pop    %ebx
80104c56:	5e                   	pop    %esi
80104c57:	5f                   	pop    %edi
80104c58:	5d                   	pop    %ebp
80104c59:	c3                   	ret    
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c68:	53                   	push   %ebx
80104c69:	e8 62 ca ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c6e:	83 c4 0c             	add    $0xc,%esp
80104c71:	ff 76 04             	push   0x4(%esi)
80104c74:	68 58 79 10 80       	push   $0x80107958
80104c79:	56                   	push   %esi
80104c7a:	e8 61 d3 ff ff       	call   80101fe0 <dirlink>
80104c7f:	83 c4 10             	add    $0x10,%esp
80104c82:	85 c0                	test   %eax,%eax
80104c84:	78 18                	js     80104c9e <create+0x15e>
80104c86:	83 ec 04             	sub    $0x4,%esp
80104c89:	ff 73 04             	push   0x4(%ebx)
80104c8c:	68 57 79 10 80       	push   $0x80107957
80104c91:	56                   	push   %esi
80104c92:	e8 49 d3 ff ff       	call   80101fe0 <dirlink>
80104c97:	83 c4 10             	add    $0x10,%esp
80104c9a:	85 c0                	test   %eax,%eax
80104c9c:	79 92                	jns    80104c30 <create+0xf0>
      panic("create dots");
80104c9e:	83 ec 0c             	sub    $0xc,%esp
80104ca1:	68 4b 79 10 80       	push   $0x8010794b
80104ca6:	e8 d5 b6 ff ff       	call   80100380 <panic>
80104cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop
}
80104cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104cb3:	31 f6                	xor    %esi,%esi
}
80104cb5:	5b                   	pop    %ebx
80104cb6:	89 f0                	mov    %esi,%eax
80104cb8:	5e                   	pop    %esi
80104cb9:	5f                   	pop    %edi
80104cba:	5d                   	pop    %ebp
80104cbb:	c3                   	ret    
    panic("create: dirlink");
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	68 5a 79 10 80       	push   $0x8010795a
80104cc4:	e8 b7 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	68 3c 79 10 80       	push   $0x8010793c
80104cd1:	e8 aa b6 ff ff       	call   80100380 <panic>
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi

80104ce0 <sys_dup>:
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ce5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ce8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ceb:	50                   	push   %eax
80104cec:	6a 00                	push   $0x0
80104cee:	e8 9d fc ff ff       	call   80104990 <argint>
80104cf3:	83 c4 10             	add    $0x10,%esp
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	78 36                	js     80104d30 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cfe:	77 30                	ja     80104d30 <sys_dup+0x50>
80104d00:	e8 db ec ff ff       	call   801039e0 <myproc>
80104d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d0c:	85 f6                	test   %esi,%esi
80104d0e:	74 20                	je     80104d30 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d10:	e8 cb ec ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d15:	31 db                	xor    %ebx,%ebx
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104d20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d24:	85 d2                	test   %edx,%edx
80104d26:	74 18                	je     80104d40 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d28:	83 c3 01             	add    $0x1,%ebx
80104d2b:	83 fb 10             	cmp    $0x10,%ebx
80104d2e:	75 f0                	jne    80104d20 <sys_dup+0x40>
}
80104d30:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d38:	89 d8                	mov    %ebx,%eax
80104d3a:	5b                   	pop    %ebx
80104d3b:	5e                   	pop    %esi
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret    
80104d3e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d40:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d43:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d47:	56                   	push   %esi
80104d48:	e8 53 c1 ff ff       	call   80100ea0 <filedup>
  return fd;
80104d4d:	83 c4 10             	add    $0x10,%esp
}
80104d50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d53:	89 d8                	mov    %ebx,%eax
80104d55:	5b                   	pop    %ebx
80104d56:	5e                   	pop    %esi
80104d57:	5d                   	pop    %ebp
80104d58:	c3                   	ret    
80104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d60 <sys_read>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d6b:	53                   	push   %ebx
80104d6c:	6a 00                	push   $0x0
80104d6e:	e8 1d fc ff ff       	call   80104990 <argint>
80104d73:	83 c4 10             	add    $0x10,%esp
80104d76:	85 c0                	test   %eax,%eax
80104d78:	78 5e                	js     80104dd8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d7e:	77 58                	ja     80104dd8 <sys_read+0x78>
80104d80:	e8 5b ec ff ff       	call   801039e0 <myproc>
80104d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d8c:	85 f6                	test   %esi,%esi
80104d8e:	74 48                	je     80104dd8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d90:	83 ec 08             	sub    $0x8,%esp
80104d93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d96:	50                   	push   %eax
80104d97:	6a 02                	push   $0x2
80104d99:	e8 f2 fb ff ff       	call   80104990 <argint>
80104d9e:	83 c4 10             	add    $0x10,%esp
80104da1:	85 c0                	test   %eax,%eax
80104da3:	78 33                	js     80104dd8 <sys_read+0x78>
80104da5:	83 ec 04             	sub    $0x4,%esp
80104da8:	ff 75 f0             	push   -0x10(%ebp)
80104dab:	53                   	push   %ebx
80104dac:	6a 01                	push   $0x1
80104dae:	e8 2d fc ff ff       	call   801049e0 <argptr>
80104db3:	83 c4 10             	add    $0x10,%esp
80104db6:	85 c0                	test   %eax,%eax
80104db8:	78 1e                	js     80104dd8 <sys_read+0x78>
  return fileread(f, p, n);
80104dba:	83 ec 04             	sub    $0x4,%esp
80104dbd:	ff 75 f0             	push   -0x10(%ebp)
80104dc0:	ff 75 f4             	push   -0xc(%ebp)
80104dc3:	56                   	push   %esi
80104dc4:	e8 57 c2 ff ff       	call   80101020 <fileread>
80104dc9:	83 c4 10             	add    $0x10,%esp
}
80104dcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dcf:	5b                   	pop    %ebx
80104dd0:	5e                   	pop    %esi
80104dd1:	5d                   	pop    %ebp
80104dd2:	c3                   	ret    
80104dd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dd7:	90                   	nop
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddd:	eb ed                	jmp    80104dcc <sys_read+0x6c>
80104ddf:	90                   	nop

80104de0 <sys_write>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104de5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104de8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104deb:	53                   	push   %ebx
80104dec:	6a 00                	push   $0x0
80104dee:	e8 9d fb ff ff       	call   80104990 <argint>
80104df3:	83 c4 10             	add    $0x10,%esp
80104df6:	85 c0                	test   %eax,%eax
80104df8:	78 5e                	js     80104e58 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dfe:	77 58                	ja     80104e58 <sys_write+0x78>
80104e00:	e8 db eb ff ff       	call   801039e0 <myproc>
80104e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e0c:	85 f6                	test   %esi,%esi
80104e0e:	74 48                	je     80104e58 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e10:	83 ec 08             	sub    $0x8,%esp
80104e13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e16:	50                   	push   %eax
80104e17:	6a 02                	push   $0x2
80104e19:	e8 72 fb ff ff       	call   80104990 <argint>
80104e1e:	83 c4 10             	add    $0x10,%esp
80104e21:	85 c0                	test   %eax,%eax
80104e23:	78 33                	js     80104e58 <sys_write+0x78>
80104e25:	83 ec 04             	sub    $0x4,%esp
80104e28:	ff 75 f0             	push   -0x10(%ebp)
80104e2b:	53                   	push   %ebx
80104e2c:	6a 01                	push   $0x1
80104e2e:	e8 ad fb ff ff       	call   801049e0 <argptr>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	85 c0                	test   %eax,%eax
80104e38:	78 1e                	js     80104e58 <sys_write+0x78>
  return filewrite(f, p, n);
80104e3a:	83 ec 04             	sub    $0x4,%esp
80104e3d:	ff 75 f0             	push   -0x10(%ebp)
80104e40:	ff 75 f4             	push   -0xc(%ebp)
80104e43:	56                   	push   %esi
80104e44:	e8 67 c2 ff ff       	call   801010b0 <filewrite>
80104e49:	83 c4 10             	add    $0x10,%esp
}
80104e4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e4f:	5b                   	pop    %ebx
80104e50:	5e                   	pop    %esi
80104e51:	5d                   	pop    %ebp
80104e52:	c3                   	ret    
80104e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e57:	90                   	nop
    return -1;
80104e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e5d:	eb ed                	jmp    80104e4c <sys_write+0x6c>
80104e5f:	90                   	nop

80104e60 <sys_close>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6b:	50                   	push   %eax
80104e6c:	6a 00                	push   $0x0
80104e6e:	e8 1d fb ff ff       	call   80104990 <argint>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 3e                	js     80104eb8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e7e:	77 38                	ja     80104eb8 <sys_close+0x58>
80104e80:	e8 5b eb ff ff       	call   801039e0 <myproc>
80104e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e88:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e8b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e8f:	85 f6                	test   %esi,%esi
80104e91:	74 25                	je     80104eb8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e93:	e8 48 eb ff ff       	call   801039e0 <myproc>
  fileclose(f);
80104e98:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e9b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104ea2:	00 
  fileclose(f);
80104ea3:	56                   	push   %esi
80104ea4:	e8 47 c0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80104ea9:	83 c4 10             	add    $0x10,%esp
80104eac:	31 c0                	xor    %eax,%eax
}
80104eae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb1:	5b                   	pop    %ebx
80104eb2:	5e                   	pop    %esi
80104eb3:	5d                   	pop    %ebp
80104eb4:	c3                   	ret    
80104eb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb ef                	jmp    80104eae <sys_close+0x4e>
80104ebf:	90                   	nop

80104ec0 <sys_fstat>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ec5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ec8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ecb:	53                   	push   %ebx
80104ecc:	6a 00                	push   $0x0
80104ece:	e8 bd fa ff ff       	call   80104990 <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 46                	js     80104f20 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ede:	77 40                	ja     80104f20 <sys_fstat+0x60>
80104ee0:	e8 fb ea ff ff       	call   801039e0 <myproc>
80104ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eec:	85 f6                	test   %esi,%esi
80104eee:	74 30                	je     80104f20 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ef0:	83 ec 04             	sub    $0x4,%esp
80104ef3:	6a 14                	push   $0x14
80104ef5:	53                   	push   %ebx
80104ef6:	6a 01                	push   $0x1
80104ef8:	e8 e3 fa ff ff       	call   801049e0 <argptr>
80104efd:	83 c4 10             	add    $0x10,%esp
80104f00:	85 c0                	test   %eax,%eax
80104f02:	78 1c                	js     80104f20 <sys_fstat+0x60>
  return filestat(f, st);
80104f04:	83 ec 08             	sub    $0x8,%esp
80104f07:	ff 75 f4             	push   -0xc(%ebp)
80104f0a:	56                   	push   %esi
80104f0b:	e8 c0 c0 ff ff       	call   80100fd0 <filestat>
80104f10:	83 c4 10             	add    $0x10,%esp
}
80104f13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f16:	5b                   	pop    %ebx
80104f17:	5e                   	pop    %esi
80104f18:	5d                   	pop    %ebp
80104f19:	c3                   	ret    
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f25:	eb ec                	jmp    80104f13 <sys_fstat+0x53>
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <sys_link>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f35:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f38:	53                   	push   %ebx
80104f39:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f3c:	50                   	push   %eax
80104f3d:	6a 00                	push   $0x0
80104f3f:	e8 0c fb ff ff       	call   80104a50 <argstr>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	0f 88 fb 00 00 00    	js     8010504a <sys_link+0x11a>
80104f4f:	83 ec 08             	sub    $0x8,%esp
80104f52:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f55:	50                   	push   %eax
80104f56:	6a 01                	push   $0x1
80104f58:	e8 f3 fa ff ff       	call   80104a50 <argstr>
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	85 c0                	test   %eax,%eax
80104f62:	0f 88 e2 00 00 00    	js     8010504a <sys_link+0x11a>
  begin_op();
80104f68:	e8 63 de ff ff       	call   80102dd0 <begin_op>
  if((ip = namei(old)) == 0){
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	ff 75 d4             	push   -0x2c(%ebp)
80104f73:	e8 28 d1 ff ff       	call   801020a0 <namei>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	89 c3                	mov    %eax,%ebx
80104f7d:	85 c0                	test   %eax,%eax
80104f7f:	0f 84 e4 00 00 00    	je     80105069 <sys_link+0x139>
  ilock(ip);
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	50                   	push   %eax
80104f89:	e8 f2 c7 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f96:	0f 84 b5 00 00 00    	je     80105051 <sys_link+0x121>
  iupdate(ip);
80104f9c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f9f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104fa4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fa7:	53                   	push   %ebx
80104fa8:	e8 23 c7 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80104fad:	89 1c 24             	mov    %ebx,(%esp)
80104fb0:	e8 ab c8 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fb5:	58                   	pop    %eax
80104fb6:	5a                   	pop    %edx
80104fb7:	57                   	push   %edi
80104fb8:	ff 75 d0             	push   -0x30(%ebp)
80104fbb:	e8 00 d1 ff ff       	call   801020c0 <nameiparent>
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	89 c6                	mov    %eax,%esi
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	74 5b                	je     80105024 <sys_link+0xf4>
  ilock(dp);
80104fc9:	83 ec 0c             	sub    $0xc,%esp
80104fcc:	50                   	push   %eax
80104fcd:	e8 ae c7 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fd2:	8b 03                	mov    (%ebx),%eax
80104fd4:	83 c4 10             	add    $0x10,%esp
80104fd7:	39 06                	cmp    %eax,(%esi)
80104fd9:	75 3d                	jne    80105018 <sys_link+0xe8>
80104fdb:	83 ec 04             	sub    $0x4,%esp
80104fde:	ff 73 04             	push   0x4(%ebx)
80104fe1:	57                   	push   %edi
80104fe2:	56                   	push   %esi
80104fe3:	e8 f8 cf ff ff       	call   80101fe0 <dirlink>
80104fe8:	83 c4 10             	add    $0x10,%esp
80104feb:	85 c0                	test   %eax,%eax
80104fed:	78 29                	js     80105018 <sys_link+0xe8>
  iunlockput(dp);
80104fef:	83 ec 0c             	sub    $0xc,%esp
80104ff2:	56                   	push   %esi
80104ff3:	e8 18 ca ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80104ff8:	89 1c 24             	mov    %ebx,(%esp)
80104ffb:	e8 b0 c8 ff ff       	call   801018b0 <iput>
  end_op();
80105000:	e8 3b de ff ff       	call   80102e40 <end_op>
  return 0;
80105005:	83 c4 10             	add    $0x10,%esp
80105008:	31 c0                	xor    %eax,%eax
}
8010500a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010500d:	5b                   	pop    %ebx
8010500e:	5e                   	pop    %esi
8010500f:	5f                   	pop    %edi
80105010:	5d                   	pop    %ebp
80105011:	c3                   	ret    
80105012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105018:	83 ec 0c             	sub    $0xc,%esp
8010501b:	56                   	push   %esi
8010501c:	e8 ef c9 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105021:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	53                   	push   %ebx
80105028:	e8 53 c7 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010502d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105032:	89 1c 24             	mov    %ebx,(%esp)
80105035:	e8 96 c6 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010503a:	89 1c 24             	mov    %ebx,(%esp)
8010503d:	e8 ce c9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105042:	e8 f9 dd ff ff       	call   80102e40 <end_op>
  return -1;
80105047:	83 c4 10             	add    $0x10,%esp
8010504a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504f:	eb b9                	jmp    8010500a <sys_link+0xda>
    iunlockput(ip);
80105051:	83 ec 0c             	sub    $0xc,%esp
80105054:	53                   	push   %ebx
80105055:	e8 b6 c9 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010505a:	e8 e1 dd ff ff       	call   80102e40 <end_op>
    return -1;
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105067:	eb a1                	jmp    8010500a <sys_link+0xda>
    end_op();
80105069:	e8 d2 dd ff ff       	call   80102e40 <end_op>
    return -1;
8010506e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105073:	eb 95                	jmp    8010500a <sys_link+0xda>
80105075:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_unlink>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105085:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105088:	53                   	push   %ebx
80105089:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010508c:	50                   	push   %eax
8010508d:	6a 00                	push   $0x0
8010508f:	e8 bc f9 ff ff       	call   80104a50 <argstr>
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	85 c0                	test   %eax,%eax
80105099:	0f 88 7a 01 00 00    	js     80105219 <sys_unlink+0x199>
  begin_op();
8010509f:	e8 2c dd ff ff       	call   80102dd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	53                   	push   %ebx
801050ab:	ff 75 c0             	push   -0x40(%ebp)
801050ae:	e8 0d d0 ff ff       	call   801020c0 <nameiparent>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050b9:	85 c0                	test   %eax,%eax
801050bb:	0f 84 62 01 00 00    	je     80105223 <sys_unlink+0x1a3>
  ilock(dp);
801050c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	57                   	push   %edi
801050c8:	e8 b3 c6 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050cd:	58                   	pop    %eax
801050ce:	5a                   	pop    %edx
801050cf:	68 58 79 10 80       	push   $0x80107958
801050d4:	53                   	push   %ebx
801050d5:	e8 e6 cb ff ff       	call   80101cc0 <namecmp>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	0f 84 fb 00 00 00    	je     801051e0 <sys_unlink+0x160>
801050e5:	83 ec 08             	sub    $0x8,%esp
801050e8:	68 57 79 10 80       	push   $0x80107957
801050ed:	53                   	push   %ebx
801050ee:	e8 cd cb ff ff       	call   80101cc0 <namecmp>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	0f 84 e2 00 00 00    	je     801051e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050fe:	83 ec 04             	sub    $0x4,%esp
80105101:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105104:	50                   	push   %eax
80105105:	53                   	push   %ebx
80105106:	57                   	push   %edi
80105107:	e8 d4 cb ff ff       	call   80101ce0 <dirlookup>
8010510c:	83 c4 10             	add    $0x10,%esp
8010510f:	89 c3                	mov    %eax,%ebx
80105111:	85 c0                	test   %eax,%eax
80105113:	0f 84 c7 00 00 00    	je     801051e0 <sys_unlink+0x160>
  ilock(ip);
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	50                   	push   %eax
8010511d:	e8 5e c6 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010512a:	0f 8e 1c 01 00 00    	jle    8010524c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105130:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105135:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105138:	74 66                	je     801051a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010513a:	83 ec 04             	sub    $0x4,%esp
8010513d:	6a 10                	push   $0x10
8010513f:	6a 00                	push   $0x0
80105141:	57                   	push   %edi
80105142:	e8 89 f5 ff ff       	call   801046d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105147:	6a 10                	push   $0x10
80105149:	ff 75 c4             	push   -0x3c(%ebp)
8010514c:	57                   	push   %edi
8010514d:	ff 75 b4             	push   -0x4c(%ebp)
80105150:	e8 3b ca ff ff       	call   80101b90 <writei>
80105155:	83 c4 20             	add    $0x20,%esp
80105158:	83 f8 10             	cmp    $0x10,%eax
8010515b:	0f 85 de 00 00 00    	jne    8010523f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105161:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105166:	0f 84 94 00 00 00    	je     80105200 <sys_unlink+0x180>
  iunlockput(dp);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	ff 75 b4             	push   -0x4c(%ebp)
80105172:	e8 99 c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105177:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010517c:	89 1c 24             	mov    %ebx,(%esp)
8010517f:	e8 4c c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105184:	89 1c 24             	mov    %ebx,(%esp)
80105187:	e8 84 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010518c:	e8 af dc ff ff       	call   80102e40 <end_op>
  return 0;
80105191:	83 c4 10             	add    $0x10,%esp
80105194:	31 c0                	xor    %eax,%eax
}
80105196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105199:	5b                   	pop    %ebx
8010519a:	5e                   	pop    %esi
8010519b:	5f                   	pop    %edi
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051a4:	76 94                	jbe    8010513a <sys_unlink+0xba>
801051a6:	be 20 00 00 00       	mov    $0x20,%esi
801051ab:	eb 0b                	jmp    801051b8 <sys_unlink+0x138>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c6 10             	add    $0x10,%esi
801051b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801051b6:	73 82                	jae    8010513a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b8:	6a 10                	push   $0x10
801051ba:	56                   	push   %esi
801051bb:	57                   	push   %edi
801051bc:	53                   	push   %ebx
801051bd:	e8 ce c8 ff ff       	call   80101a90 <readi>
801051c2:	83 c4 10             	add    $0x10,%esp
801051c5:	83 f8 10             	cmp    $0x10,%eax
801051c8:	75 68                	jne    80105232 <sys_unlink+0x1b2>
    if(de.inum != 0)
801051ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051cf:	74 df                	je     801051b0 <sys_unlink+0x130>
    iunlockput(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
801051d4:	53                   	push   %ebx
801051d5:	e8 36 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	ff 75 b4             	push   -0x4c(%ebp)
801051e6:	e8 25 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051eb:	e8 50 dc ff ff       	call   80102e40 <end_op>
  return -1;
801051f0:	83 c4 10             	add    $0x10,%esp
801051f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f8:	eb 9c                	jmp    80105196 <sys_unlink+0x116>
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105200:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105203:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105206:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010520b:	50                   	push   %eax
8010520c:	e8 bf c4 ff ff       	call   801016d0 <iupdate>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	e9 53 ff ff ff       	jmp    8010516c <sys_unlink+0xec>
    return -1;
80105219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521e:	e9 73 ff ff ff       	jmp    80105196 <sys_unlink+0x116>
    end_op();
80105223:	e8 18 dc ff ff       	call   80102e40 <end_op>
    return -1;
80105228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522d:	e9 64 ff ff ff       	jmp    80105196 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105232:	83 ec 0c             	sub    $0xc,%esp
80105235:	68 7c 79 10 80       	push   $0x8010797c
8010523a:	e8 41 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010523f:	83 ec 0c             	sub    $0xc,%esp
80105242:	68 8e 79 10 80       	push   $0x8010798e
80105247:	e8 34 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	68 6a 79 10 80       	push   $0x8010796a
80105254:	e8 27 b1 ff ff       	call   80100380 <panic>
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_open>:

int
sys_open(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105265:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105268:	53                   	push   %ebx
80105269:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010526c:	50                   	push   %eax
8010526d:	6a 00                	push   $0x0
8010526f:	e8 dc f7 ff ff       	call   80104a50 <argstr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	0f 88 8e 00 00 00    	js     8010530d <sys_open+0xad>
8010527f:	83 ec 08             	sub    $0x8,%esp
80105282:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105285:	50                   	push   %eax
80105286:	6a 01                	push   $0x1
80105288:	e8 03 f7 ff ff       	call   80104990 <argint>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	78 79                	js     8010530d <sys_open+0xad>
    return -1;

  begin_op();
80105294:	e8 37 db ff ff       	call   80102dd0 <begin_op>

  if(omode & O_CREATE){
80105299:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010529d:	75 79                	jne    80105318 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010529f:	83 ec 0c             	sub    $0xc,%esp
801052a2:	ff 75 e0             	push   -0x20(%ebp)
801052a5:	e8 f6 cd ff ff       	call   801020a0 <namei>
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	89 c6                	mov    %eax,%esi
801052af:	85 c0                	test   %eax,%eax
801052b1:	0f 84 7e 00 00 00    	je     80105335 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052b7:	83 ec 0c             	sub    $0xc,%esp
801052ba:	50                   	push   %eax
801052bb:	e8 c0 c4 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052c8:	0f 84 c2 00 00 00    	je     80105390 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052ce:	e8 5d bb ff ff       	call   80100e30 <filealloc>
801052d3:	89 c7                	mov    %eax,%edi
801052d5:	85 c0                	test   %eax,%eax
801052d7:	74 23                	je     801052fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801052d9:	e8 02 e7 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052e4:	85 d2                	test   %edx,%edx
801052e6:	74 60                	je     80105348 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052e8:	83 c3 01             	add    $0x1,%ebx
801052eb:	83 fb 10             	cmp    $0x10,%ebx
801052ee:	75 f0                	jne    801052e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	57                   	push   %edi
801052f4:	e8 f7 bb ff ff       	call   80100ef0 <fileclose>
801052f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	56                   	push   %esi
80105300:	e8 0b c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105305:	e8 36 db ff ff       	call   80102e40 <end_op>
    return -1;
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105312:	eb 6d                	jmp    80105381 <sys_open+0x121>
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010531e:	31 c9                	xor    %ecx,%ecx
80105320:	ba 02 00 00 00       	mov    $0x2,%edx
80105325:	6a 00                	push   $0x0
80105327:	e8 14 f8 ff ff       	call   80104b40 <create>
    if(ip == 0){
8010532c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010532f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105331:	85 c0                	test   %eax,%eax
80105333:	75 99                	jne    801052ce <sys_open+0x6e>
      end_op();
80105335:	e8 06 db ff ff       	call   80102e40 <end_op>
      return -1;
8010533a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010533f:	eb 40                	jmp    80105381 <sys_open+0x121>
80105341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105348:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010534b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010534f:	56                   	push   %esi
80105350:	e8 0b c5 ff ff       	call   80101860 <iunlock>
  end_op();
80105355:	e8 e6 da ff ff       	call   80102e40 <end_op>

  f->type = FD_INODE;
8010535a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105363:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105366:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105369:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010536b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105372:	f7 d0                	not    %eax
80105374:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105377:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010537a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010537d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105381:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105384:	89 d8                	mov    %ebx,%eax
80105386:	5b                   	pop    %ebx
80105387:	5e                   	pop    %esi
80105388:	5f                   	pop    %edi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105390:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105393:	85 c9                	test   %ecx,%ecx
80105395:	0f 84 33 ff ff ff    	je     801052ce <sys_open+0x6e>
8010539b:	e9 5c ff ff ff       	jmp    801052fc <sys_open+0x9c>

801053a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053a6:	e8 25 da ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053ab:	83 ec 08             	sub    $0x8,%esp
801053ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b1:	50                   	push   %eax
801053b2:	6a 00                	push   $0x0
801053b4:	e8 97 f6 ff ff       	call   80104a50 <argstr>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	85 c0                	test   %eax,%eax
801053be:	78 30                	js     801053f0 <sys_mkdir+0x50>
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c6:	31 c9                	xor    %ecx,%ecx
801053c8:	ba 01 00 00 00       	mov    $0x1,%edx
801053cd:	6a 00                	push   $0x0
801053cf:	e8 6c f7 ff ff       	call   80104b40 <create>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	74 15                	je     801053f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053db:	83 ec 0c             	sub    $0xc,%esp
801053de:	50                   	push   %eax
801053df:	e8 2c c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053e4:	e8 57 da ff ff       	call   80102e40 <end_op>
  return 0;
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	31 c0                	xor    %eax,%eax
}
801053ee:	c9                   	leave  
801053ef:	c3                   	ret    
    end_op();
801053f0:	e8 4b da ff ff       	call   80102e40 <end_op>
    return -1;
801053f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053fa:	c9                   	leave  
801053fb:	c3                   	ret    
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_mknod>:

int
sys_mknod(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105406:	e8 c5 d9 ff ff       	call   80102dd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010540b:	83 ec 08             	sub    $0x8,%esp
8010540e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105411:	50                   	push   %eax
80105412:	6a 00                	push   $0x0
80105414:	e8 37 f6 ff ff       	call   80104a50 <argstr>
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	85 c0                	test   %eax,%eax
8010541e:	78 60                	js     80105480 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105420:	83 ec 08             	sub    $0x8,%esp
80105423:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105426:	50                   	push   %eax
80105427:	6a 01                	push   $0x1
80105429:	e8 62 f5 ff ff       	call   80104990 <argint>
  if((argstr(0, &path)) < 0 ||
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	85 c0                	test   %eax,%eax
80105433:	78 4b                	js     80105480 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105435:	83 ec 08             	sub    $0x8,%esp
80105438:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010543b:	50                   	push   %eax
8010543c:	6a 02                	push   $0x2
8010543e:	e8 4d f5 ff ff       	call   80104990 <argint>
     argint(1, &major) < 0 ||
80105443:	83 c4 10             	add    $0x10,%esp
80105446:	85 c0                	test   %eax,%eax
80105448:	78 36                	js     80105480 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010544a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010544e:	83 ec 0c             	sub    $0xc,%esp
80105451:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105455:	ba 03 00 00 00       	mov    $0x3,%edx
8010545a:	50                   	push   %eax
8010545b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010545e:	e8 dd f6 ff ff       	call   80104b40 <create>
     argint(2, &minor) < 0 ||
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	74 16                	je     80105480 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010546a:	83 ec 0c             	sub    $0xc,%esp
8010546d:	50                   	push   %eax
8010546e:	e8 9d c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105473:	e8 c8 d9 ff ff       	call   80102e40 <end_op>
  return 0;
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	31 c0                	xor    %eax,%eax
}
8010547d:	c9                   	leave  
8010547e:	c3                   	ret    
8010547f:	90                   	nop
    end_op();
80105480:	e8 bb d9 ff ff       	call   80102e40 <end_op>
    return -1;
80105485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010548a:	c9                   	leave  
8010548b:	c3                   	ret    
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_chdir>:

int
sys_chdir(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
80105495:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105498:	e8 43 e5 ff ff       	call   801039e0 <myproc>
8010549d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010549f:	e8 2c d9 ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054aa:	50                   	push   %eax
801054ab:	6a 00                	push   $0x0
801054ad:	e8 9e f5 ff ff       	call   80104a50 <argstr>
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	85 c0                	test   %eax,%eax
801054b7:	78 77                	js     80105530 <sys_chdir+0xa0>
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	ff 75 f4             	push   -0xc(%ebp)
801054bf:	e8 dc cb ff ff       	call   801020a0 <namei>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	89 c3                	mov    %eax,%ebx
801054c9:	85 c0                	test   %eax,%eax
801054cb:	74 63                	je     80105530 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054cd:	83 ec 0c             	sub    $0xc,%esp
801054d0:	50                   	push   %eax
801054d1:	e8 aa c2 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054de:	75 30                	jne    80105510 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 77 c3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801054e9:	58                   	pop    %eax
801054ea:	ff 76 68             	push   0x68(%esi)
801054ed:	e8 be c3 ff ff       	call   801018b0 <iput>
  end_op();
801054f2:	e8 49 d9 ff ff       	call   80102e40 <end_op>
  curproc->cwd = ip;
801054f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	31 c0                	xor    %eax,%eax
}
801054ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105502:	5b                   	pop    %ebx
80105503:	5e                   	pop    %esi
80105504:	5d                   	pop    %ebp
80105505:	c3                   	ret    
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	53                   	push   %ebx
80105514:	e8 f7 c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105519:	e8 22 d9 ff ff       	call   80102e40 <end_op>
    return -1;
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105526:	eb d7                	jmp    801054ff <sys_chdir+0x6f>
80105528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop
    end_op();
80105530:	e8 0b d9 ff ff       	call   80102e40 <end_op>
    return -1;
80105535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553a:	eb c3                	jmp    801054ff <sys_chdir+0x6f>
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_exec>:

int
sys_exec(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105545:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010554b:	53                   	push   %ebx
8010554c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105552:	50                   	push   %eax
80105553:	6a 00                	push   $0x0
80105555:	e8 f6 f4 ff ff       	call   80104a50 <argstr>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	0f 88 87 00 00 00    	js     801055ec <sys_exec+0xac>
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 01                	push   $0x1
80105571:	e8 1a f4 ff ff       	call   80104990 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 6f                	js     801055ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105586:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105588:	68 80 00 00 00       	push   $0x80
8010558d:	6a 00                	push   $0x0
8010558f:	56                   	push   %esi
80105590:	e8 3b f1 ff ff       	call   801046d0 <memset>
80105595:	83 c4 10             	add    $0x10,%esp
80105598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055a0:	83 ec 08             	sub    $0x8,%esp
801055a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801055a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801055b0:	50                   	push   %eax
801055b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055b7:	01 f8                	add    %edi,%eax
801055b9:	50                   	push   %eax
801055ba:	e8 41 f3 ff ff       	call   80104900 <fetchint>
801055bf:	83 c4 10             	add    $0x10,%esp
801055c2:	85 c0                	test   %eax,%eax
801055c4:	78 26                	js     801055ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055cc:	85 c0                	test   %eax,%eax
801055ce:	74 30                	je     80105600 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055d0:	83 ec 08             	sub    $0x8,%esp
801055d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055d6:	52                   	push   %edx
801055d7:	50                   	push   %eax
801055d8:	e8 63 f3 ff ff       	call   80104940 <fetchstr>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	78 08                	js     801055ec <sys_exec+0xac>
  for(i=0;; i++){
801055e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055e7:	83 fb 20             	cmp    $0x20,%ebx
801055ea:	75 b4                	jne    801055a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f4:	5b                   	pop    %ebx
801055f5:	5e                   	pop    %esi
801055f6:	5f                   	pop    %edi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105600:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105607:	00 00 00 00 
  return exec(path, argv);
8010560b:	83 ec 08             	sub    $0x8,%esp
8010560e:	56                   	push   %esi
8010560f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105615:	e8 96 b4 ff ff       	call   80100ab0 <exec>
8010561a:	83 c4 10             	add    $0x10,%esp
}
8010561d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105620:	5b                   	pop    %ebx
80105621:	5e                   	pop    %esi
80105622:	5f                   	pop    %edi
80105623:	5d                   	pop    %ebp
80105624:	c3                   	ret    
80105625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_pipe>:

int
sys_pipe(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105635:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105638:	53                   	push   %ebx
80105639:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010563c:	6a 08                	push   $0x8
8010563e:	50                   	push   %eax
8010563f:	6a 00                	push   $0x0
80105641:	e8 9a f3 ff ff       	call   801049e0 <argptr>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	85 c0                	test   %eax,%eax
8010564b:	78 4a                	js     80105697 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010564d:	83 ec 08             	sub    $0x8,%esp
80105650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105653:	50                   	push   %eax
80105654:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105657:	50                   	push   %eax
80105658:	e8 43 de ff ff       	call   801034a0 <pipealloc>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	78 33                	js     80105697 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105664:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105667:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105669:	e8 72 e3 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010566e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105670:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105674:	85 f6                	test   %esi,%esi
80105676:	74 28                	je     801056a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105678:	83 c3 01             	add    $0x1,%ebx
8010567b:	83 fb 10             	cmp    $0x10,%ebx
8010567e:	75 f0                	jne    80105670 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	ff 75 e0             	push   -0x20(%ebp)
80105686:	e8 65 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010568b:	58                   	pop    %eax
8010568c:	ff 75 e4             	push   -0x1c(%ebp)
8010568f:	e8 5c b8 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569c:	eb 53                	jmp    801056f1 <sys_pipe+0xc1>
8010569e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056a0:	8d 73 08             	lea    0x8(%ebx),%esi
801056a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056aa:	e8 31 e3 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 d2                	xor    %edx,%edx
801056b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056bc:	85 c9                	test   %ecx,%ecx
801056be:	74 20                	je     801056e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c2 01             	add    $0x1,%edx
801056c3:	83 fa 10             	cmp    $0x10,%edx
801056c6:	75 f0                	jne    801056b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801056c8:	e8 13 e3 ff ff       	call   801039e0 <myproc>
801056cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056d4:	00 
801056d5:	eb a9                	jmp    80105680 <sys_pipe+0x50>
801056d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056ef:	31 c0                	xor    %eax,%eax
}
801056f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	66 90                	xchg   %ax,%ax
801056fb:	66 90                	xchg   %ax,%ax
801056fd:	66 90                	xchg   %ax,%ax
801056ff:	90                   	nop

80105700 <sys_getNumFreePages>:
#include "proc.h"

int 
sys_getNumFreePages(void)
{
  return getNumFreePages();
80105700:	e9 bb cd ff ff       	jmp    801024c0 <getNumFreePages>
80105705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_fork>:
}

int
sys_fork(void)
{
  return fork();
80105710:	e9 6b e4 ff ff       	jmp    80103b80 <fork>
80105715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_exit>:
}

int
sys_exit(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 08             	sub    $0x8,%esp
  exit();
80105726:	e8 d5 e6 ff ff       	call   80103e00 <exit>
  return 0;  // not reached
}
8010572b:	31 c0                	xor    %eax,%eax
8010572d:	c9                   	leave  
8010572e:	c3                   	ret    
8010572f:	90                   	nop

80105730 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105730:	e9 fb e7 ff ff       	jmp    80103f30 <wait>
80105735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_kill>:
}

int
sys_kill(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105749:	50                   	push   %eax
8010574a:	6a 00                	push   $0x0
8010574c:	e8 3f f2 ff ff       	call   80104990 <argint>
80105751:	83 c4 10             	add    $0x10,%esp
80105754:	85 c0                	test   %eax,%eax
80105756:	78 18                	js     80105770 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	ff 75 f4             	push   -0xc(%ebp)
8010575e:	e8 6d ea ff ff       	call   801041d0 <kill>
80105763:	83 c4 10             	add    $0x10,%esp
}
80105766:	c9                   	leave  
80105767:	c3                   	ret    
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
80105770:	c9                   	leave  
    return -1;
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105776:	c3                   	ret    
80105777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577e:	66 90                	xchg   %ax,%ax

80105780 <sys_getpid>:

int
sys_getpid(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105786:	e8 55 e2 ff ff       	call   801039e0 <myproc>
8010578b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010578e:	c9                   	leave  
8010578f:	c3                   	ret    

80105790 <sys_sbrk>:

int
sys_sbrk(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105797:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579a:	50                   	push   %eax
8010579b:	6a 00                	push   $0x0
8010579d:	e8 ee f1 ff ff       	call   80104990 <argint>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	78 27                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057a9:	e8 32 e2 ff ff       	call   801039e0 <myproc>
  if(growproc(n) < 0)
801057ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057b3:	ff 75 f4             	push   -0xc(%ebp)
801057b6:	e8 45 e3 ff ff       	call   80103b00 <growproc>
801057bb:	83 c4 10             	add    $0x10,%esp
801057be:	85 c0                	test   %eax,%eax
801057c0:	78 0e                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057c2:	89 d8                	mov    %ebx,%eax
801057c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057c7:	c9                   	leave  
801057c8:	c3                   	ret    
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057d5:	eb eb                	jmp    801057c2 <sys_sbrk+0x32>
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax

801057e0 <sys_sleep>:

int
sys_sleep(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ea:	50                   	push   %eax
801057eb:	6a 00                	push   $0x0
801057ed:	e8 9e f1 ff ff       	call   80104990 <argint>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	0f 88 8a 00 00 00    	js     80105887 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	68 80 bc 14 80       	push   $0x8014bc80
80105805:	e8 06 ee ff ff       	call   80104610 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010580a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010580d:	8b 1d 60 bc 14 80    	mov    0x8014bc60,%ebx
  while(ticks - ticks0 < n){
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 d2                	test   %edx,%edx
80105818:	75 27                	jne    80105841 <sys_sleep+0x61>
8010581a:	eb 54                	jmp    80105870 <sys_sleep+0x90>
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	68 80 bc 14 80       	push   $0x8014bc80
80105828:	68 60 bc 14 80       	push   $0x8014bc60
8010582d:	e8 7e e8 ff ff       	call   801040b0 <sleep>
  while(ticks - ticks0 < n){
80105832:	a1 60 bc 14 80       	mov    0x8014bc60,%eax
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	29 d8                	sub    %ebx,%eax
8010583c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010583f:	73 2f                	jae    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
80105841:	e8 9a e1 ff ff       	call   801039e0 <myproc>
80105846:	8b 40 24             	mov    0x24(%eax),%eax
80105849:	85 c0                	test   %eax,%eax
8010584b:	74 d3                	je     80105820 <sys_sleep+0x40>
      release(&tickslock);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 80 bc 14 80       	push   $0x8014bc80
80105855:	e8 56 ed ff ff       	call   801045b0 <release>
  }
  release(&tickslock);
  return 0;
}
8010585a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	68 80 bc 14 80       	push   $0x8014bc80
80105878:	e8 33 ed ff ff       	call   801045b0 <release>
  return 0;
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	31 c0                	xor    %eax,%eax
}
80105882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105885:	c9                   	leave  
80105886:	c3                   	ret    
    return -1;
80105887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588c:	eb f4                	jmp    80105882 <sys_sleep+0xa2>
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	53                   	push   %ebx
80105894:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105897:	68 80 bc 14 80       	push   $0x8014bc80
8010589c:	e8 6f ed ff ff       	call   80104610 <acquire>
  xticks = ticks;
801058a1:	8b 1d 60 bc 14 80    	mov    0x8014bc60,%ebx
  release(&tickslock);
801058a7:	c7 04 24 80 bc 14 80 	movl   $0x8014bc80,(%esp)
801058ae:	e8 fd ec ff ff       	call   801045b0 <release>
  return xticks;
}
801058b3:	89 d8                	mov    %ebx,%eax
801058b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058b8:	c9                   	leave  
801058b9:	c3                   	ret    

801058ba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ba:	1e                   	push   %ds
  pushl %es
801058bb:	06                   	push   %es
  pushl %fs
801058bc:	0f a0                	push   %fs
  pushl %gs
801058be:	0f a8                	push   %gs
  pushal
801058c0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058c1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058c5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058c7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058c9:	54                   	push   %esp
  call trap
801058ca:	e8 c1 00 00 00       	call   80105990 <trap>
  addl $4, %esp
801058cf:	83 c4 04             	add    $0x4,%esp

801058d2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058d2:	61                   	popa   
  popl %gs
801058d3:	0f a9                	pop    %gs
  popl %fs
801058d5:	0f a1                	pop    %fs
  popl %es
801058d7:	07                   	pop    %es
  popl %ds
801058d8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058d9:	83 c4 08             	add    $0x8,%esp
  iret
801058dc:	cf                   	iret   
801058dd:	66 90                	xchg   %ax,%ax
801058df:	90                   	nop

801058e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058e1:	31 c0                	xor    %eax,%eax
{
801058e3:	89 e5                	mov    %esp,%ebp
801058e5:	83 ec 08             	sub    $0x8,%esp
801058e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058f0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801058f7:	c7 04 c5 c2 bc 14 80 	movl   $0x8e000008,-0x7feb433e(,%eax,8)
801058fe:	08 00 00 8e 
80105902:	66 89 14 c5 c0 bc 14 	mov    %dx,-0x7feb4340(,%eax,8)
80105909:	80 
8010590a:	c1 ea 10             	shr    $0x10,%edx
8010590d:	66 89 14 c5 c6 bc 14 	mov    %dx,-0x7feb433a(,%eax,8)
80105914:	80 
  for(i = 0; i < 256; i++)
80105915:	83 c0 01             	add    $0x1,%eax
80105918:	3d 00 01 00 00       	cmp    $0x100,%eax
8010591d:	75 d1                	jne    801058f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010591f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105922:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105927:	c7 05 c2 be 14 80 08 	movl   $0xef000008,0x8014bec2
8010592e:	00 00 ef 
  initlock(&tickslock, "time");
80105931:	68 9d 79 10 80       	push   $0x8010799d
80105936:	68 80 bc 14 80       	push   $0x8014bc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010593b:	66 a3 c0 be 14 80    	mov    %ax,0x8014bec0
80105941:	c1 e8 10             	shr    $0x10,%eax
80105944:	66 a3 c6 be 14 80    	mov    %ax,0x8014bec6
  initlock(&tickslock, "time");
8010594a:	e8 f1 ea ff ff       	call   80104440 <initlock>
}
8010594f:	83 c4 10             	add    $0x10,%esp
80105952:	c9                   	leave  
80105953:	c3                   	ret    
80105954:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop

80105960 <idtinit>:

void
idtinit(void)
{
80105960:	55                   	push   %ebp
  pd[0] = size-1;
80105961:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105966:	89 e5                	mov    %esp,%ebp
80105968:	83 ec 10             	sub    $0x10,%esp
8010596b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010596f:	b8 c0 bc 14 80       	mov    $0x8014bcc0,%eax
80105974:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105978:	c1 e8 10             	shr    $0x10,%eax
8010597b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010597f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105982:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	57                   	push   %edi
80105994:	56                   	push   %esi
80105995:	53                   	push   %ebx
80105996:	83 ec 1c             	sub    $0x1c,%esp
80105999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010599c:	8b 43 30             	mov    0x30(%ebx),%eax
8010599f:	83 f8 40             	cmp    $0x40,%eax
801059a2:	0f 84 68 01 00 00    	je     80105b10 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059a8:	83 e8 20             	sub    $0x20,%eax
801059ab:	83 f8 1f             	cmp    $0x1f,%eax
801059ae:	0f 87 8c 00 00 00    	ja     80105a40 <trap+0xb0>
801059b4:	ff 24 85 44 7a 10 80 	jmp    *-0x7fef85bc(,%eax,4)
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059c0:	e8 7b c8 ff ff       	call   80102240 <ideintr>
    lapiceoi();
801059c5:	e8 b6 cf ff ff       	call   80102980 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059ca:	e8 11 e0 ff ff       	call   801039e0 <myproc>
801059cf:	85 c0                	test   %eax,%eax
801059d1:	74 1d                	je     801059f0 <trap+0x60>
801059d3:	e8 08 e0 ff ff       	call   801039e0 <myproc>
801059d8:	8b 50 24             	mov    0x24(%eax),%edx
801059db:	85 d2                	test   %edx,%edx
801059dd:	74 11                	je     801059f0 <trap+0x60>
801059df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059e3:	83 e0 03             	and    $0x3,%eax
801059e6:	66 83 f8 03          	cmp    $0x3,%ax
801059ea:	0f 84 e8 01 00 00    	je     80105bd8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059f0:	e8 eb df ff ff       	call   801039e0 <myproc>
801059f5:	85 c0                	test   %eax,%eax
801059f7:	74 0f                	je     80105a08 <trap+0x78>
801059f9:	e8 e2 df ff ff       	call   801039e0 <myproc>
801059fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a02:	0f 84 b8 00 00 00    	je     80105ac0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a08:	e8 d3 df ff ff       	call   801039e0 <myproc>
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	74 1d                	je     80105a2e <trap+0x9e>
80105a11:	e8 ca df ff ff       	call   801039e0 <myproc>
80105a16:	8b 40 24             	mov    0x24(%eax),%eax
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	74 11                	je     80105a2e <trap+0x9e>
80105a1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a21:	83 e0 03             	and    $0x3,%eax
80105a24:	66 83 f8 03          	cmp    $0x3,%ax
80105a28:	0f 84 0f 01 00 00    	je     80105b3d <trap+0x1ad>
    exit();
}
80105a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a31:	5b                   	pop    %ebx
80105a32:	5e                   	pop    %esi
80105a33:	5f                   	pop    %edi
80105a34:	5d                   	pop    %ebp
80105a35:	c3                   	ret    
80105a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a40:	e8 9b df ff ff       	call   801039e0 <myproc>
80105a45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a48:	85 c0                	test   %eax,%eax
80105a4a:	0f 84 a2 01 00 00    	je     80105bf2 <trap+0x262>
80105a50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a54:	0f 84 98 01 00 00    	je     80105bf2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a5a:	0f 20 d1             	mov    %cr2,%ecx
80105a5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a60:	e8 5b df ff ff       	call   801039c0 <cpuid>
80105a65:	8b 73 30             	mov    0x30(%ebx),%esi
80105a68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a71:	e8 6a df ff ff       	call   801039e0 <myproc>
80105a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a79:	e8 62 df ff ff       	call   801039e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a84:	51                   	push   %ecx
80105a85:	57                   	push   %edi
80105a86:	52                   	push   %edx
80105a87:	ff 75 e4             	push   -0x1c(%ebp)
80105a8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a91:	56                   	push   %esi
80105a92:	ff 70 10             	push   0x10(%eax)
80105a95:	68 00 7a 10 80       	push   $0x80107a00
80105a9a:	e8 01 ac ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105a9f:	83 c4 20             	add    $0x20,%esp
80105aa2:	e8 39 df ff ff       	call   801039e0 <myproc>
80105aa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aae:	e8 2d df ff ff       	call   801039e0 <myproc>
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	0f 85 18 ff ff ff    	jne    801059d3 <trap+0x43>
80105abb:	e9 30 ff ff ff       	jmp    801059f0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105ac0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ac4:	0f 85 3e ff ff ff    	jne    80105a08 <trap+0x78>
    yield();
80105aca:	e8 91 e5 ff ff       	call   80104060 <yield>
80105acf:	e9 34 ff ff ff       	jmp    80105a08 <trap+0x78>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ad8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105adb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105adf:	e8 dc de ff ff       	call   801039c0 <cpuid>
80105ae4:	57                   	push   %edi
80105ae5:	56                   	push   %esi
80105ae6:	50                   	push   %eax
80105ae7:	68 a8 79 10 80       	push   $0x801079a8
80105aec:	e8 af ab ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105af1:	e8 8a ce ff ff       	call   80102980 <lapiceoi>
    break;
80105af6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105af9:	e8 e2 de ff ff       	call   801039e0 <myproc>
80105afe:	85 c0                	test   %eax,%eax
80105b00:	0f 85 cd fe ff ff    	jne    801059d3 <trap+0x43>
80105b06:	e9 e5 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop
    if(myproc()->killed)
80105b10:	e8 cb de ff ff       	call   801039e0 <myproc>
80105b15:	8b 70 24             	mov    0x24(%eax),%esi
80105b18:	85 f6                	test   %esi,%esi
80105b1a:	0f 85 c8 00 00 00    	jne    80105be8 <trap+0x258>
    myproc()->tf = tf;
80105b20:	e8 bb de ff ff       	call   801039e0 <myproc>
80105b25:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b28:	e8 a3 ef ff ff       	call   80104ad0 <syscall>
    if(myproc()->killed)
80105b2d:	e8 ae de ff ff       	call   801039e0 <myproc>
80105b32:	8b 48 24             	mov    0x24(%eax),%ecx
80105b35:	85 c9                	test   %ecx,%ecx
80105b37:	0f 84 f1 fe ff ff    	je     80105a2e <trap+0x9e>
}
80105b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b40:	5b                   	pop    %ebx
80105b41:	5e                   	pop    %esi
80105b42:	5f                   	pop    %edi
80105b43:	5d                   	pop    %ebp
      exit();
80105b44:	e9 b7 e2 ff ff       	jmp    80103e00 <exit>
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b50:	e8 3b 02 00 00       	call   80105d90 <uartintr>
    lapiceoi();
80105b55:	e8 26 ce ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b5a:	e8 81 de ff ff       	call   801039e0 <myproc>
80105b5f:	85 c0                	test   %eax,%eax
80105b61:	0f 85 6c fe ff ff    	jne    801059d3 <trap+0x43>
80105b67:	e9 84 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b70:	e8 cb cc ff ff       	call   80102840 <kbdintr>
    lapiceoi();
80105b75:	e8 06 ce ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b7a:	e8 61 de ff ff       	call   801039e0 <myproc>
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	0f 85 4c fe ff ff    	jne    801059d3 <trap+0x43>
80105b87:	e9 64 fe ff ff       	jmp    801059f0 <trap+0x60>
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105b90:	e8 2b de ff ff       	call   801039c0 <cpuid>
80105b95:	85 c0                	test   %eax,%eax
80105b97:	0f 85 28 fe ff ff    	jne    801059c5 <trap+0x35>
      acquire(&tickslock);
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	68 80 bc 14 80       	push   $0x8014bc80
80105ba5:	e8 66 ea ff ff       	call   80104610 <acquire>
      wakeup(&ticks);
80105baa:	c7 04 24 60 bc 14 80 	movl   $0x8014bc60,(%esp)
      ticks++;
80105bb1:	83 05 60 bc 14 80 01 	addl   $0x1,0x8014bc60
      wakeup(&ticks);
80105bb8:	e8 b3 e5 ff ff       	call   80104170 <wakeup>
      release(&tickslock);
80105bbd:	c7 04 24 80 bc 14 80 	movl   $0x8014bc80,(%esp)
80105bc4:	e8 e7 e9 ff ff       	call   801045b0 <release>
80105bc9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105bcc:	e9 f4 fd ff ff       	jmp    801059c5 <trap+0x35>
80105bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105bd8:	e8 23 e2 ff ff       	call   80103e00 <exit>
80105bdd:	e9 0e fe ff ff       	jmp    801059f0 <trap+0x60>
80105be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105be8:	e8 13 e2 ff ff       	call   80103e00 <exit>
80105bed:	e9 2e ff ff ff       	jmp    80105b20 <trap+0x190>
80105bf2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bf5:	e8 c6 dd ff ff       	call   801039c0 <cpuid>
80105bfa:	83 ec 0c             	sub    $0xc,%esp
80105bfd:	56                   	push   %esi
80105bfe:	57                   	push   %edi
80105bff:	50                   	push   %eax
80105c00:	ff 73 30             	push   0x30(%ebx)
80105c03:	68 cc 79 10 80       	push   $0x801079cc
80105c08:	e8 93 aa ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105c0d:	83 c4 14             	add    $0x14,%esp
80105c10:	68 a2 79 10 80       	push   $0x801079a2
80105c15:	e8 66 a7 ff ff       	call   80100380 <panic>
80105c1a:	66 90                	xchg   %ax,%ax
80105c1c:	66 90                	xchg   %ax,%ax
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c20:	a1 c0 c4 14 80       	mov    0x8014c4c0,%eax
80105c25:	85 c0                	test   %eax,%eax
80105c27:	74 17                	je     80105c40 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c29:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c2e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c2f:	a8 01                	test   $0x1,%al
80105c31:	74 0d                	je     80105c40 <uartgetc+0x20>
80105c33:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c38:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c39:	0f b6 c0             	movzbl %al,%eax
80105c3c:	c3                   	ret    
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c45:	c3                   	ret    
80105c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi

80105c50 <uartinit>:
{
80105c50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c51:	31 c9                	xor    %ecx,%ecx
80105c53:	89 c8                	mov    %ecx,%eax
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	57                   	push   %edi
80105c58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c5d:	56                   	push   %esi
80105c5e:	89 fa                	mov    %edi,%edx
80105c60:	53                   	push   %ebx
80105c61:	83 ec 1c             	sub    $0x1c,%esp
80105c64:	ee                   	out    %al,(%dx)
80105c65:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c6f:	89 f2                	mov    %esi,%edx
80105c71:	ee                   	out    %al,(%dx)
80105c72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c7c:	ee                   	out    %al,(%dx)
80105c7d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c82:	89 c8                	mov    %ecx,%eax
80105c84:	89 da                	mov    %ebx,%edx
80105c86:	ee                   	out    %al,(%dx)
80105c87:	b8 03 00 00 00       	mov    $0x3,%eax
80105c8c:	89 f2                	mov    %esi,%edx
80105c8e:	ee                   	out    %al,(%dx)
80105c8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c94:	89 c8                	mov    %ecx,%eax
80105c96:	ee                   	out    %al,(%dx)
80105c97:	b8 01 00 00 00       	mov    $0x1,%eax
80105c9c:	89 da                	mov    %ebx,%edx
80105c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ca4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ca5:	3c ff                	cmp    $0xff,%al
80105ca7:	74 78                	je     80105d21 <uartinit+0xd1>
  uart = 1;
80105ca9:	c7 05 c0 c4 14 80 01 	movl   $0x1,0x8014c4c0
80105cb0:	00 00 00 
80105cb3:	89 fa                	mov    %edi,%edx
80105cb5:	ec                   	in     (%dx),%al
80105cb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cbb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105cbc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105cbf:	bf c4 7a 10 80       	mov    $0x80107ac4,%edi
80105cc4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105cc9:	6a 00                	push   $0x0
80105ccb:	6a 04                	push   $0x4
80105ccd:	e8 ae c7 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105cd2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105ce0:	a1 c0 c4 14 80       	mov    0x8014c4c0,%eax
80105ce5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cea:	85 c0                	test   %eax,%eax
80105cec:	75 14                	jne    80105d02 <uartinit+0xb2>
80105cee:	eb 23                	jmp    80105d13 <uartinit+0xc3>
    microdelay(10);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	6a 0a                	push   $0xa
80105cf5:	e8 a6 cc ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	83 eb 01             	sub    $0x1,%ebx
80105d00:	74 07                	je     80105d09 <uartinit+0xb9>
80105d02:	89 f2                	mov    %esi,%edx
80105d04:	ec                   	in     (%dx),%al
80105d05:	a8 20                	test   $0x20,%al
80105d07:	74 e7                	je     80105cf0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d09:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d0d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d12:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d13:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d17:	83 c7 01             	add    $0x1,%edi
80105d1a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d1d:	84 c0                	test   %al,%al
80105d1f:	75 bf                	jne    80105ce0 <uartinit+0x90>
}
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <uartputc>:
  if(!uart)
80105d30:	a1 c0 c4 14 80       	mov    0x8014c4c0,%eax
80105d35:	85 c0                	test   %eax,%eax
80105d37:	74 47                	je     80105d80 <uartputc+0x50>
{
80105d39:	55                   	push   %ebp
80105d3a:	89 e5                	mov    %esp,%ebp
80105d3c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d42:	53                   	push   %ebx
80105d43:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d48:	eb 18                	jmp    80105d62 <uartputc+0x32>
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	6a 0a                	push   $0xa
80105d55:	e8 46 cc ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	83 eb 01             	sub    $0x1,%ebx
80105d60:	74 07                	je     80105d69 <uartputc+0x39>
80105d62:	89 f2                	mov    %esi,%edx
80105d64:	ec                   	in     (%dx),%al
80105d65:	a8 20                	test   $0x20,%al
80105d67:	74 e7                	je     80105d50 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d69:	8b 45 08             	mov    0x8(%ebp),%eax
80105d6c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d71:	ee                   	out    %al,(%dx)
}
80105d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d75:	5b                   	pop    %ebx
80105d76:	5e                   	pop    %esi
80105d77:	5d                   	pop    %ebp
80105d78:	c3                   	ret    
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d80:	c3                   	ret    
80105d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8f:	90                   	nop

80105d90 <uartintr>:

void
uartintr(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d96:	68 20 5c 10 80       	push   $0x80105c20
80105d9b:	e8 e0 aa ff ff       	call   80100880 <consoleintr>
}
80105da0:	83 c4 10             	add    $0x10,%esp
80105da3:	c9                   	leave  
80105da4:	c3                   	ret    

80105da5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $0
80105da7:	6a 00                	push   $0x0
  jmp alltraps
80105da9:	e9 0c fb ff ff       	jmp    801058ba <alltraps>

80105dae <vector1>:
.globl vector1
vector1:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $1
80105db0:	6a 01                	push   $0x1
  jmp alltraps
80105db2:	e9 03 fb ff ff       	jmp    801058ba <alltraps>

80105db7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $2
80105db9:	6a 02                	push   $0x2
  jmp alltraps
80105dbb:	e9 fa fa ff ff       	jmp    801058ba <alltraps>

80105dc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $3
80105dc2:	6a 03                	push   $0x3
  jmp alltraps
80105dc4:	e9 f1 fa ff ff       	jmp    801058ba <alltraps>

80105dc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $4
80105dcb:	6a 04                	push   $0x4
  jmp alltraps
80105dcd:	e9 e8 fa ff ff       	jmp    801058ba <alltraps>

80105dd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $5
80105dd4:	6a 05                	push   $0x5
  jmp alltraps
80105dd6:	e9 df fa ff ff       	jmp    801058ba <alltraps>

80105ddb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $6
80105ddd:	6a 06                	push   $0x6
  jmp alltraps
80105ddf:	e9 d6 fa ff ff       	jmp    801058ba <alltraps>

80105de4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $7
80105de6:	6a 07                	push   $0x7
  jmp alltraps
80105de8:	e9 cd fa ff ff       	jmp    801058ba <alltraps>

80105ded <vector8>:
.globl vector8
vector8:
  pushl $8
80105ded:	6a 08                	push   $0x8
  jmp alltraps
80105def:	e9 c6 fa ff ff       	jmp    801058ba <alltraps>

80105df4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $9
80105df6:	6a 09                	push   $0x9
  jmp alltraps
80105df8:	e9 bd fa ff ff       	jmp    801058ba <alltraps>

80105dfd <vector10>:
.globl vector10
vector10:
  pushl $10
80105dfd:	6a 0a                	push   $0xa
  jmp alltraps
80105dff:	e9 b6 fa ff ff       	jmp    801058ba <alltraps>

80105e04 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e04:	6a 0b                	push   $0xb
  jmp alltraps
80105e06:	e9 af fa ff ff       	jmp    801058ba <alltraps>

80105e0b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e0b:	6a 0c                	push   $0xc
  jmp alltraps
80105e0d:	e9 a8 fa ff ff       	jmp    801058ba <alltraps>

80105e12 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e12:	6a 0d                	push   $0xd
  jmp alltraps
80105e14:	e9 a1 fa ff ff       	jmp    801058ba <alltraps>

80105e19 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e19:	6a 0e                	push   $0xe
  jmp alltraps
80105e1b:	e9 9a fa ff ff       	jmp    801058ba <alltraps>

80105e20 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $15
80105e22:	6a 0f                	push   $0xf
  jmp alltraps
80105e24:	e9 91 fa ff ff       	jmp    801058ba <alltraps>

80105e29 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $16
80105e2b:	6a 10                	push   $0x10
  jmp alltraps
80105e2d:	e9 88 fa ff ff       	jmp    801058ba <alltraps>

80105e32 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e32:	6a 11                	push   $0x11
  jmp alltraps
80105e34:	e9 81 fa ff ff       	jmp    801058ba <alltraps>

80105e39 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $18
80105e3b:	6a 12                	push   $0x12
  jmp alltraps
80105e3d:	e9 78 fa ff ff       	jmp    801058ba <alltraps>

80105e42 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $19
80105e44:	6a 13                	push   $0x13
  jmp alltraps
80105e46:	e9 6f fa ff ff       	jmp    801058ba <alltraps>

80105e4b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $20
80105e4d:	6a 14                	push   $0x14
  jmp alltraps
80105e4f:	e9 66 fa ff ff       	jmp    801058ba <alltraps>

80105e54 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $21
80105e56:	6a 15                	push   $0x15
  jmp alltraps
80105e58:	e9 5d fa ff ff       	jmp    801058ba <alltraps>

80105e5d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $22
80105e5f:	6a 16                	push   $0x16
  jmp alltraps
80105e61:	e9 54 fa ff ff       	jmp    801058ba <alltraps>

80105e66 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $23
80105e68:	6a 17                	push   $0x17
  jmp alltraps
80105e6a:	e9 4b fa ff ff       	jmp    801058ba <alltraps>

80105e6f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $24
80105e71:	6a 18                	push   $0x18
  jmp alltraps
80105e73:	e9 42 fa ff ff       	jmp    801058ba <alltraps>

80105e78 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $25
80105e7a:	6a 19                	push   $0x19
  jmp alltraps
80105e7c:	e9 39 fa ff ff       	jmp    801058ba <alltraps>

80105e81 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $26
80105e83:	6a 1a                	push   $0x1a
  jmp alltraps
80105e85:	e9 30 fa ff ff       	jmp    801058ba <alltraps>

80105e8a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $27
80105e8c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e8e:	e9 27 fa ff ff       	jmp    801058ba <alltraps>

80105e93 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $28
80105e95:	6a 1c                	push   $0x1c
  jmp alltraps
80105e97:	e9 1e fa ff ff       	jmp    801058ba <alltraps>

80105e9c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $29
80105e9e:	6a 1d                	push   $0x1d
  jmp alltraps
80105ea0:	e9 15 fa ff ff       	jmp    801058ba <alltraps>

80105ea5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $30
80105ea7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ea9:	e9 0c fa ff ff       	jmp    801058ba <alltraps>

80105eae <vector31>:
.globl vector31
vector31:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $31
80105eb0:	6a 1f                	push   $0x1f
  jmp alltraps
80105eb2:	e9 03 fa ff ff       	jmp    801058ba <alltraps>

80105eb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $32
80105eb9:	6a 20                	push   $0x20
  jmp alltraps
80105ebb:	e9 fa f9 ff ff       	jmp    801058ba <alltraps>

80105ec0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $33
80105ec2:	6a 21                	push   $0x21
  jmp alltraps
80105ec4:	e9 f1 f9 ff ff       	jmp    801058ba <alltraps>

80105ec9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $34
80105ecb:	6a 22                	push   $0x22
  jmp alltraps
80105ecd:	e9 e8 f9 ff ff       	jmp    801058ba <alltraps>

80105ed2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $35
80105ed4:	6a 23                	push   $0x23
  jmp alltraps
80105ed6:	e9 df f9 ff ff       	jmp    801058ba <alltraps>

80105edb <vector36>:
.globl vector36
vector36:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $36
80105edd:	6a 24                	push   $0x24
  jmp alltraps
80105edf:	e9 d6 f9 ff ff       	jmp    801058ba <alltraps>

80105ee4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $37
80105ee6:	6a 25                	push   $0x25
  jmp alltraps
80105ee8:	e9 cd f9 ff ff       	jmp    801058ba <alltraps>

80105eed <vector38>:
.globl vector38
vector38:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $38
80105eef:	6a 26                	push   $0x26
  jmp alltraps
80105ef1:	e9 c4 f9 ff ff       	jmp    801058ba <alltraps>

80105ef6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $39
80105ef8:	6a 27                	push   $0x27
  jmp alltraps
80105efa:	e9 bb f9 ff ff       	jmp    801058ba <alltraps>

80105eff <vector40>:
.globl vector40
vector40:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $40
80105f01:	6a 28                	push   $0x28
  jmp alltraps
80105f03:	e9 b2 f9 ff ff       	jmp    801058ba <alltraps>

80105f08 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $41
80105f0a:	6a 29                	push   $0x29
  jmp alltraps
80105f0c:	e9 a9 f9 ff ff       	jmp    801058ba <alltraps>

80105f11 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $42
80105f13:	6a 2a                	push   $0x2a
  jmp alltraps
80105f15:	e9 a0 f9 ff ff       	jmp    801058ba <alltraps>

80105f1a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $43
80105f1c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f1e:	e9 97 f9 ff ff       	jmp    801058ba <alltraps>

80105f23 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $44
80105f25:	6a 2c                	push   $0x2c
  jmp alltraps
80105f27:	e9 8e f9 ff ff       	jmp    801058ba <alltraps>

80105f2c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $45
80105f2e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f30:	e9 85 f9 ff ff       	jmp    801058ba <alltraps>

80105f35 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $46
80105f37:	6a 2e                	push   $0x2e
  jmp alltraps
80105f39:	e9 7c f9 ff ff       	jmp    801058ba <alltraps>

80105f3e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $47
80105f40:	6a 2f                	push   $0x2f
  jmp alltraps
80105f42:	e9 73 f9 ff ff       	jmp    801058ba <alltraps>

80105f47 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $48
80105f49:	6a 30                	push   $0x30
  jmp alltraps
80105f4b:	e9 6a f9 ff ff       	jmp    801058ba <alltraps>

80105f50 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $49
80105f52:	6a 31                	push   $0x31
  jmp alltraps
80105f54:	e9 61 f9 ff ff       	jmp    801058ba <alltraps>

80105f59 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $50
80105f5b:	6a 32                	push   $0x32
  jmp alltraps
80105f5d:	e9 58 f9 ff ff       	jmp    801058ba <alltraps>

80105f62 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $51
80105f64:	6a 33                	push   $0x33
  jmp alltraps
80105f66:	e9 4f f9 ff ff       	jmp    801058ba <alltraps>

80105f6b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $52
80105f6d:	6a 34                	push   $0x34
  jmp alltraps
80105f6f:	e9 46 f9 ff ff       	jmp    801058ba <alltraps>

80105f74 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $53
80105f76:	6a 35                	push   $0x35
  jmp alltraps
80105f78:	e9 3d f9 ff ff       	jmp    801058ba <alltraps>

80105f7d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $54
80105f7f:	6a 36                	push   $0x36
  jmp alltraps
80105f81:	e9 34 f9 ff ff       	jmp    801058ba <alltraps>

80105f86 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $55
80105f88:	6a 37                	push   $0x37
  jmp alltraps
80105f8a:	e9 2b f9 ff ff       	jmp    801058ba <alltraps>

80105f8f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $56
80105f91:	6a 38                	push   $0x38
  jmp alltraps
80105f93:	e9 22 f9 ff ff       	jmp    801058ba <alltraps>

80105f98 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $57
80105f9a:	6a 39                	push   $0x39
  jmp alltraps
80105f9c:	e9 19 f9 ff ff       	jmp    801058ba <alltraps>

80105fa1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $58
80105fa3:	6a 3a                	push   $0x3a
  jmp alltraps
80105fa5:	e9 10 f9 ff ff       	jmp    801058ba <alltraps>

80105faa <vector59>:
.globl vector59
vector59:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $59
80105fac:	6a 3b                	push   $0x3b
  jmp alltraps
80105fae:	e9 07 f9 ff ff       	jmp    801058ba <alltraps>

80105fb3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $60
80105fb5:	6a 3c                	push   $0x3c
  jmp alltraps
80105fb7:	e9 fe f8 ff ff       	jmp    801058ba <alltraps>

80105fbc <vector61>:
.globl vector61
vector61:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $61
80105fbe:	6a 3d                	push   $0x3d
  jmp alltraps
80105fc0:	e9 f5 f8 ff ff       	jmp    801058ba <alltraps>

80105fc5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $62
80105fc7:	6a 3e                	push   $0x3e
  jmp alltraps
80105fc9:	e9 ec f8 ff ff       	jmp    801058ba <alltraps>

80105fce <vector63>:
.globl vector63
vector63:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $63
80105fd0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fd2:	e9 e3 f8 ff ff       	jmp    801058ba <alltraps>

80105fd7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $64
80105fd9:	6a 40                	push   $0x40
  jmp alltraps
80105fdb:	e9 da f8 ff ff       	jmp    801058ba <alltraps>

80105fe0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $65
80105fe2:	6a 41                	push   $0x41
  jmp alltraps
80105fe4:	e9 d1 f8 ff ff       	jmp    801058ba <alltraps>

80105fe9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $66
80105feb:	6a 42                	push   $0x42
  jmp alltraps
80105fed:	e9 c8 f8 ff ff       	jmp    801058ba <alltraps>

80105ff2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $67
80105ff4:	6a 43                	push   $0x43
  jmp alltraps
80105ff6:	e9 bf f8 ff ff       	jmp    801058ba <alltraps>

80105ffb <vector68>:
.globl vector68
vector68:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $68
80105ffd:	6a 44                	push   $0x44
  jmp alltraps
80105fff:	e9 b6 f8 ff ff       	jmp    801058ba <alltraps>

80106004 <vector69>:
.globl vector69
vector69:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $69
80106006:	6a 45                	push   $0x45
  jmp alltraps
80106008:	e9 ad f8 ff ff       	jmp    801058ba <alltraps>

8010600d <vector70>:
.globl vector70
vector70:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $70
8010600f:	6a 46                	push   $0x46
  jmp alltraps
80106011:	e9 a4 f8 ff ff       	jmp    801058ba <alltraps>

80106016 <vector71>:
.globl vector71
vector71:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $71
80106018:	6a 47                	push   $0x47
  jmp alltraps
8010601a:	e9 9b f8 ff ff       	jmp    801058ba <alltraps>

8010601f <vector72>:
.globl vector72
vector72:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $72
80106021:	6a 48                	push   $0x48
  jmp alltraps
80106023:	e9 92 f8 ff ff       	jmp    801058ba <alltraps>

80106028 <vector73>:
.globl vector73
vector73:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $73
8010602a:	6a 49                	push   $0x49
  jmp alltraps
8010602c:	e9 89 f8 ff ff       	jmp    801058ba <alltraps>

80106031 <vector74>:
.globl vector74
vector74:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $74
80106033:	6a 4a                	push   $0x4a
  jmp alltraps
80106035:	e9 80 f8 ff ff       	jmp    801058ba <alltraps>

8010603a <vector75>:
.globl vector75
vector75:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $75
8010603c:	6a 4b                	push   $0x4b
  jmp alltraps
8010603e:	e9 77 f8 ff ff       	jmp    801058ba <alltraps>

80106043 <vector76>:
.globl vector76
vector76:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $76
80106045:	6a 4c                	push   $0x4c
  jmp alltraps
80106047:	e9 6e f8 ff ff       	jmp    801058ba <alltraps>

8010604c <vector77>:
.globl vector77
vector77:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $77
8010604e:	6a 4d                	push   $0x4d
  jmp alltraps
80106050:	e9 65 f8 ff ff       	jmp    801058ba <alltraps>

80106055 <vector78>:
.globl vector78
vector78:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $78
80106057:	6a 4e                	push   $0x4e
  jmp alltraps
80106059:	e9 5c f8 ff ff       	jmp    801058ba <alltraps>

8010605e <vector79>:
.globl vector79
vector79:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $79
80106060:	6a 4f                	push   $0x4f
  jmp alltraps
80106062:	e9 53 f8 ff ff       	jmp    801058ba <alltraps>

80106067 <vector80>:
.globl vector80
vector80:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $80
80106069:	6a 50                	push   $0x50
  jmp alltraps
8010606b:	e9 4a f8 ff ff       	jmp    801058ba <alltraps>

80106070 <vector81>:
.globl vector81
vector81:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $81
80106072:	6a 51                	push   $0x51
  jmp alltraps
80106074:	e9 41 f8 ff ff       	jmp    801058ba <alltraps>

80106079 <vector82>:
.globl vector82
vector82:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $82
8010607b:	6a 52                	push   $0x52
  jmp alltraps
8010607d:	e9 38 f8 ff ff       	jmp    801058ba <alltraps>

80106082 <vector83>:
.globl vector83
vector83:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $83
80106084:	6a 53                	push   $0x53
  jmp alltraps
80106086:	e9 2f f8 ff ff       	jmp    801058ba <alltraps>

8010608b <vector84>:
.globl vector84
vector84:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $84
8010608d:	6a 54                	push   $0x54
  jmp alltraps
8010608f:	e9 26 f8 ff ff       	jmp    801058ba <alltraps>

80106094 <vector85>:
.globl vector85
vector85:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $85
80106096:	6a 55                	push   $0x55
  jmp alltraps
80106098:	e9 1d f8 ff ff       	jmp    801058ba <alltraps>

8010609d <vector86>:
.globl vector86
vector86:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $86
8010609f:	6a 56                	push   $0x56
  jmp alltraps
801060a1:	e9 14 f8 ff ff       	jmp    801058ba <alltraps>

801060a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $87
801060a8:	6a 57                	push   $0x57
  jmp alltraps
801060aa:	e9 0b f8 ff ff       	jmp    801058ba <alltraps>

801060af <vector88>:
.globl vector88
vector88:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $88
801060b1:	6a 58                	push   $0x58
  jmp alltraps
801060b3:	e9 02 f8 ff ff       	jmp    801058ba <alltraps>

801060b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $89
801060ba:	6a 59                	push   $0x59
  jmp alltraps
801060bc:	e9 f9 f7 ff ff       	jmp    801058ba <alltraps>

801060c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $90
801060c3:	6a 5a                	push   $0x5a
  jmp alltraps
801060c5:	e9 f0 f7 ff ff       	jmp    801058ba <alltraps>

801060ca <vector91>:
.globl vector91
vector91:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $91
801060cc:	6a 5b                	push   $0x5b
  jmp alltraps
801060ce:	e9 e7 f7 ff ff       	jmp    801058ba <alltraps>

801060d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $92
801060d5:	6a 5c                	push   $0x5c
  jmp alltraps
801060d7:	e9 de f7 ff ff       	jmp    801058ba <alltraps>

801060dc <vector93>:
.globl vector93
vector93:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $93
801060de:	6a 5d                	push   $0x5d
  jmp alltraps
801060e0:	e9 d5 f7 ff ff       	jmp    801058ba <alltraps>

801060e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $94
801060e7:	6a 5e                	push   $0x5e
  jmp alltraps
801060e9:	e9 cc f7 ff ff       	jmp    801058ba <alltraps>

801060ee <vector95>:
.globl vector95
vector95:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $95
801060f0:	6a 5f                	push   $0x5f
  jmp alltraps
801060f2:	e9 c3 f7 ff ff       	jmp    801058ba <alltraps>

801060f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $96
801060f9:	6a 60                	push   $0x60
  jmp alltraps
801060fb:	e9 ba f7 ff ff       	jmp    801058ba <alltraps>

80106100 <vector97>:
.globl vector97
vector97:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $97
80106102:	6a 61                	push   $0x61
  jmp alltraps
80106104:	e9 b1 f7 ff ff       	jmp    801058ba <alltraps>

80106109 <vector98>:
.globl vector98
vector98:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $98
8010610b:	6a 62                	push   $0x62
  jmp alltraps
8010610d:	e9 a8 f7 ff ff       	jmp    801058ba <alltraps>

80106112 <vector99>:
.globl vector99
vector99:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $99
80106114:	6a 63                	push   $0x63
  jmp alltraps
80106116:	e9 9f f7 ff ff       	jmp    801058ba <alltraps>

8010611b <vector100>:
.globl vector100
vector100:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $100
8010611d:	6a 64                	push   $0x64
  jmp alltraps
8010611f:	e9 96 f7 ff ff       	jmp    801058ba <alltraps>

80106124 <vector101>:
.globl vector101
vector101:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $101
80106126:	6a 65                	push   $0x65
  jmp alltraps
80106128:	e9 8d f7 ff ff       	jmp    801058ba <alltraps>

8010612d <vector102>:
.globl vector102
vector102:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $102
8010612f:	6a 66                	push   $0x66
  jmp alltraps
80106131:	e9 84 f7 ff ff       	jmp    801058ba <alltraps>

80106136 <vector103>:
.globl vector103
vector103:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $103
80106138:	6a 67                	push   $0x67
  jmp alltraps
8010613a:	e9 7b f7 ff ff       	jmp    801058ba <alltraps>

8010613f <vector104>:
.globl vector104
vector104:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $104
80106141:	6a 68                	push   $0x68
  jmp alltraps
80106143:	e9 72 f7 ff ff       	jmp    801058ba <alltraps>

80106148 <vector105>:
.globl vector105
vector105:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $105
8010614a:	6a 69                	push   $0x69
  jmp alltraps
8010614c:	e9 69 f7 ff ff       	jmp    801058ba <alltraps>

80106151 <vector106>:
.globl vector106
vector106:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $106
80106153:	6a 6a                	push   $0x6a
  jmp alltraps
80106155:	e9 60 f7 ff ff       	jmp    801058ba <alltraps>

8010615a <vector107>:
.globl vector107
vector107:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $107
8010615c:	6a 6b                	push   $0x6b
  jmp alltraps
8010615e:	e9 57 f7 ff ff       	jmp    801058ba <alltraps>

80106163 <vector108>:
.globl vector108
vector108:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $108
80106165:	6a 6c                	push   $0x6c
  jmp alltraps
80106167:	e9 4e f7 ff ff       	jmp    801058ba <alltraps>

8010616c <vector109>:
.globl vector109
vector109:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $109
8010616e:	6a 6d                	push   $0x6d
  jmp alltraps
80106170:	e9 45 f7 ff ff       	jmp    801058ba <alltraps>

80106175 <vector110>:
.globl vector110
vector110:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $110
80106177:	6a 6e                	push   $0x6e
  jmp alltraps
80106179:	e9 3c f7 ff ff       	jmp    801058ba <alltraps>

8010617e <vector111>:
.globl vector111
vector111:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $111
80106180:	6a 6f                	push   $0x6f
  jmp alltraps
80106182:	e9 33 f7 ff ff       	jmp    801058ba <alltraps>

80106187 <vector112>:
.globl vector112
vector112:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $112
80106189:	6a 70                	push   $0x70
  jmp alltraps
8010618b:	e9 2a f7 ff ff       	jmp    801058ba <alltraps>

80106190 <vector113>:
.globl vector113
vector113:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $113
80106192:	6a 71                	push   $0x71
  jmp alltraps
80106194:	e9 21 f7 ff ff       	jmp    801058ba <alltraps>

80106199 <vector114>:
.globl vector114
vector114:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $114
8010619b:	6a 72                	push   $0x72
  jmp alltraps
8010619d:	e9 18 f7 ff ff       	jmp    801058ba <alltraps>

801061a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $115
801061a4:	6a 73                	push   $0x73
  jmp alltraps
801061a6:	e9 0f f7 ff ff       	jmp    801058ba <alltraps>

801061ab <vector116>:
.globl vector116
vector116:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $116
801061ad:	6a 74                	push   $0x74
  jmp alltraps
801061af:	e9 06 f7 ff ff       	jmp    801058ba <alltraps>

801061b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $117
801061b6:	6a 75                	push   $0x75
  jmp alltraps
801061b8:	e9 fd f6 ff ff       	jmp    801058ba <alltraps>

801061bd <vector118>:
.globl vector118
vector118:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $118
801061bf:	6a 76                	push   $0x76
  jmp alltraps
801061c1:	e9 f4 f6 ff ff       	jmp    801058ba <alltraps>

801061c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $119
801061c8:	6a 77                	push   $0x77
  jmp alltraps
801061ca:	e9 eb f6 ff ff       	jmp    801058ba <alltraps>

801061cf <vector120>:
.globl vector120
vector120:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $120
801061d1:	6a 78                	push   $0x78
  jmp alltraps
801061d3:	e9 e2 f6 ff ff       	jmp    801058ba <alltraps>

801061d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $121
801061da:	6a 79                	push   $0x79
  jmp alltraps
801061dc:	e9 d9 f6 ff ff       	jmp    801058ba <alltraps>

801061e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $122
801061e3:	6a 7a                	push   $0x7a
  jmp alltraps
801061e5:	e9 d0 f6 ff ff       	jmp    801058ba <alltraps>

801061ea <vector123>:
.globl vector123
vector123:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $123
801061ec:	6a 7b                	push   $0x7b
  jmp alltraps
801061ee:	e9 c7 f6 ff ff       	jmp    801058ba <alltraps>

801061f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $124
801061f5:	6a 7c                	push   $0x7c
  jmp alltraps
801061f7:	e9 be f6 ff ff       	jmp    801058ba <alltraps>

801061fc <vector125>:
.globl vector125
vector125:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $125
801061fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106200:	e9 b5 f6 ff ff       	jmp    801058ba <alltraps>

80106205 <vector126>:
.globl vector126
vector126:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $126
80106207:	6a 7e                	push   $0x7e
  jmp alltraps
80106209:	e9 ac f6 ff ff       	jmp    801058ba <alltraps>

8010620e <vector127>:
.globl vector127
vector127:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $127
80106210:	6a 7f                	push   $0x7f
  jmp alltraps
80106212:	e9 a3 f6 ff ff       	jmp    801058ba <alltraps>

80106217 <vector128>:
.globl vector128
vector128:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $128
80106219:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010621e:	e9 97 f6 ff ff       	jmp    801058ba <alltraps>

80106223 <vector129>:
.globl vector129
vector129:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $129
80106225:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010622a:	e9 8b f6 ff ff       	jmp    801058ba <alltraps>

8010622f <vector130>:
.globl vector130
vector130:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $130
80106231:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106236:	e9 7f f6 ff ff       	jmp    801058ba <alltraps>

8010623b <vector131>:
.globl vector131
vector131:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $131
8010623d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106242:	e9 73 f6 ff ff       	jmp    801058ba <alltraps>

80106247 <vector132>:
.globl vector132
vector132:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $132
80106249:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010624e:	e9 67 f6 ff ff       	jmp    801058ba <alltraps>

80106253 <vector133>:
.globl vector133
vector133:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $133
80106255:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010625a:	e9 5b f6 ff ff       	jmp    801058ba <alltraps>

8010625f <vector134>:
.globl vector134
vector134:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $134
80106261:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106266:	e9 4f f6 ff ff       	jmp    801058ba <alltraps>

8010626b <vector135>:
.globl vector135
vector135:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $135
8010626d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106272:	e9 43 f6 ff ff       	jmp    801058ba <alltraps>

80106277 <vector136>:
.globl vector136
vector136:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $136
80106279:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010627e:	e9 37 f6 ff ff       	jmp    801058ba <alltraps>

80106283 <vector137>:
.globl vector137
vector137:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $137
80106285:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010628a:	e9 2b f6 ff ff       	jmp    801058ba <alltraps>

8010628f <vector138>:
.globl vector138
vector138:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $138
80106291:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106296:	e9 1f f6 ff ff       	jmp    801058ba <alltraps>

8010629b <vector139>:
.globl vector139
vector139:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $139
8010629d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062a2:	e9 13 f6 ff ff       	jmp    801058ba <alltraps>

801062a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $140
801062a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062ae:	e9 07 f6 ff ff       	jmp    801058ba <alltraps>

801062b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $141
801062b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062ba:	e9 fb f5 ff ff       	jmp    801058ba <alltraps>

801062bf <vector142>:
.globl vector142
vector142:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $142
801062c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062c6:	e9 ef f5 ff ff       	jmp    801058ba <alltraps>

801062cb <vector143>:
.globl vector143
vector143:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $143
801062cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062d2:	e9 e3 f5 ff ff       	jmp    801058ba <alltraps>

801062d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $144
801062d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062de:	e9 d7 f5 ff ff       	jmp    801058ba <alltraps>

801062e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $145
801062e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062ea:	e9 cb f5 ff ff       	jmp    801058ba <alltraps>

801062ef <vector146>:
.globl vector146
vector146:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $146
801062f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062f6:	e9 bf f5 ff ff       	jmp    801058ba <alltraps>

801062fb <vector147>:
.globl vector147
vector147:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $147
801062fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106302:	e9 b3 f5 ff ff       	jmp    801058ba <alltraps>

80106307 <vector148>:
.globl vector148
vector148:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $148
80106309:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010630e:	e9 a7 f5 ff ff       	jmp    801058ba <alltraps>

80106313 <vector149>:
.globl vector149
vector149:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $149
80106315:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010631a:	e9 9b f5 ff ff       	jmp    801058ba <alltraps>

8010631f <vector150>:
.globl vector150
vector150:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $150
80106321:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106326:	e9 8f f5 ff ff       	jmp    801058ba <alltraps>

8010632b <vector151>:
.globl vector151
vector151:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $151
8010632d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106332:	e9 83 f5 ff ff       	jmp    801058ba <alltraps>

80106337 <vector152>:
.globl vector152
vector152:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $152
80106339:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010633e:	e9 77 f5 ff ff       	jmp    801058ba <alltraps>

80106343 <vector153>:
.globl vector153
vector153:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $153
80106345:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010634a:	e9 6b f5 ff ff       	jmp    801058ba <alltraps>

8010634f <vector154>:
.globl vector154
vector154:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $154
80106351:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106356:	e9 5f f5 ff ff       	jmp    801058ba <alltraps>

8010635b <vector155>:
.globl vector155
vector155:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $155
8010635d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106362:	e9 53 f5 ff ff       	jmp    801058ba <alltraps>

80106367 <vector156>:
.globl vector156
vector156:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $156
80106369:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010636e:	e9 47 f5 ff ff       	jmp    801058ba <alltraps>

80106373 <vector157>:
.globl vector157
vector157:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $157
80106375:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010637a:	e9 3b f5 ff ff       	jmp    801058ba <alltraps>

8010637f <vector158>:
.globl vector158
vector158:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $158
80106381:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106386:	e9 2f f5 ff ff       	jmp    801058ba <alltraps>

8010638b <vector159>:
.globl vector159
vector159:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $159
8010638d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106392:	e9 23 f5 ff ff       	jmp    801058ba <alltraps>

80106397 <vector160>:
.globl vector160
vector160:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $160
80106399:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010639e:	e9 17 f5 ff ff       	jmp    801058ba <alltraps>

801063a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $161
801063a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063aa:	e9 0b f5 ff ff       	jmp    801058ba <alltraps>

801063af <vector162>:
.globl vector162
vector162:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $162
801063b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063b6:	e9 ff f4 ff ff       	jmp    801058ba <alltraps>

801063bb <vector163>:
.globl vector163
vector163:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $163
801063bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063c2:	e9 f3 f4 ff ff       	jmp    801058ba <alltraps>

801063c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $164
801063c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063ce:	e9 e7 f4 ff ff       	jmp    801058ba <alltraps>

801063d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $165
801063d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063da:	e9 db f4 ff ff       	jmp    801058ba <alltraps>

801063df <vector166>:
.globl vector166
vector166:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $166
801063e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063e6:	e9 cf f4 ff ff       	jmp    801058ba <alltraps>

801063eb <vector167>:
.globl vector167
vector167:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $167
801063ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063f2:	e9 c3 f4 ff ff       	jmp    801058ba <alltraps>

801063f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $168
801063f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063fe:	e9 b7 f4 ff ff       	jmp    801058ba <alltraps>

80106403 <vector169>:
.globl vector169
vector169:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $169
80106405:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010640a:	e9 ab f4 ff ff       	jmp    801058ba <alltraps>

8010640f <vector170>:
.globl vector170
vector170:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $170
80106411:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106416:	e9 9f f4 ff ff       	jmp    801058ba <alltraps>

8010641b <vector171>:
.globl vector171
vector171:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $171
8010641d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106422:	e9 93 f4 ff ff       	jmp    801058ba <alltraps>

80106427 <vector172>:
.globl vector172
vector172:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $172
80106429:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010642e:	e9 87 f4 ff ff       	jmp    801058ba <alltraps>

80106433 <vector173>:
.globl vector173
vector173:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $173
80106435:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010643a:	e9 7b f4 ff ff       	jmp    801058ba <alltraps>

8010643f <vector174>:
.globl vector174
vector174:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $174
80106441:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106446:	e9 6f f4 ff ff       	jmp    801058ba <alltraps>

8010644b <vector175>:
.globl vector175
vector175:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $175
8010644d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106452:	e9 63 f4 ff ff       	jmp    801058ba <alltraps>

80106457 <vector176>:
.globl vector176
vector176:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $176
80106459:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010645e:	e9 57 f4 ff ff       	jmp    801058ba <alltraps>

80106463 <vector177>:
.globl vector177
vector177:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $177
80106465:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010646a:	e9 4b f4 ff ff       	jmp    801058ba <alltraps>

8010646f <vector178>:
.globl vector178
vector178:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $178
80106471:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106476:	e9 3f f4 ff ff       	jmp    801058ba <alltraps>

8010647b <vector179>:
.globl vector179
vector179:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $179
8010647d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106482:	e9 33 f4 ff ff       	jmp    801058ba <alltraps>

80106487 <vector180>:
.globl vector180
vector180:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $180
80106489:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010648e:	e9 27 f4 ff ff       	jmp    801058ba <alltraps>

80106493 <vector181>:
.globl vector181
vector181:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $181
80106495:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010649a:	e9 1b f4 ff ff       	jmp    801058ba <alltraps>

8010649f <vector182>:
.globl vector182
vector182:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $182
801064a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064a6:	e9 0f f4 ff ff       	jmp    801058ba <alltraps>

801064ab <vector183>:
.globl vector183
vector183:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $183
801064ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064b2:	e9 03 f4 ff ff       	jmp    801058ba <alltraps>

801064b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $184
801064b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064be:	e9 f7 f3 ff ff       	jmp    801058ba <alltraps>

801064c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $185
801064c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064ca:	e9 eb f3 ff ff       	jmp    801058ba <alltraps>

801064cf <vector186>:
.globl vector186
vector186:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $186
801064d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064d6:	e9 df f3 ff ff       	jmp    801058ba <alltraps>

801064db <vector187>:
.globl vector187
vector187:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $187
801064dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064e2:	e9 d3 f3 ff ff       	jmp    801058ba <alltraps>

801064e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $188
801064e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064ee:	e9 c7 f3 ff ff       	jmp    801058ba <alltraps>

801064f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $189
801064f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064fa:	e9 bb f3 ff ff       	jmp    801058ba <alltraps>

801064ff <vector190>:
.globl vector190
vector190:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $190
80106501:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106506:	e9 af f3 ff ff       	jmp    801058ba <alltraps>

8010650b <vector191>:
.globl vector191
vector191:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $191
8010650d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106512:	e9 a3 f3 ff ff       	jmp    801058ba <alltraps>

80106517 <vector192>:
.globl vector192
vector192:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $192
80106519:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010651e:	e9 97 f3 ff ff       	jmp    801058ba <alltraps>

80106523 <vector193>:
.globl vector193
vector193:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $193
80106525:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010652a:	e9 8b f3 ff ff       	jmp    801058ba <alltraps>

8010652f <vector194>:
.globl vector194
vector194:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $194
80106531:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106536:	e9 7f f3 ff ff       	jmp    801058ba <alltraps>

8010653b <vector195>:
.globl vector195
vector195:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $195
8010653d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106542:	e9 73 f3 ff ff       	jmp    801058ba <alltraps>

80106547 <vector196>:
.globl vector196
vector196:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $196
80106549:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010654e:	e9 67 f3 ff ff       	jmp    801058ba <alltraps>

80106553 <vector197>:
.globl vector197
vector197:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $197
80106555:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010655a:	e9 5b f3 ff ff       	jmp    801058ba <alltraps>

8010655f <vector198>:
.globl vector198
vector198:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $198
80106561:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106566:	e9 4f f3 ff ff       	jmp    801058ba <alltraps>

8010656b <vector199>:
.globl vector199
vector199:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $199
8010656d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106572:	e9 43 f3 ff ff       	jmp    801058ba <alltraps>

80106577 <vector200>:
.globl vector200
vector200:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $200
80106579:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010657e:	e9 37 f3 ff ff       	jmp    801058ba <alltraps>

80106583 <vector201>:
.globl vector201
vector201:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $201
80106585:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010658a:	e9 2b f3 ff ff       	jmp    801058ba <alltraps>

8010658f <vector202>:
.globl vector202
vector202:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $202
80106591:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106596:	e9 1f f3 ff ff       	jmp    801058ba <alltraps>

8010659b <vector203>:
.globl vector203
vector203:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $203
8010659d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065a2:	e9 13 f3 ff ff       	jmp    801058ba <alltraps>

801065a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $204
801065a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065ae:	e9 07 f3 ff ff       	jmp    801058ba <alltraps>

801065b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $205
801065b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065ba:	e9 fb f2 ff ff       	jmp    801058ba <alltraps>

801065bf <vector206>:
.globl vector206
vector206:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $206
801065c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065c6:	e9 ef f2 ff ff       	jmp    801058ba <alltraps>

801065cb <vector207>:
.globl vector207
vector207:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $207
801065cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065d2:	e9 e3 f2 ff ff       	jmp    801058ba <alltraps>

801065d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $208
801065d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065de:	e9 d7 f2 ff ff       	jmp    801058ba <alltraps>

801065e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $209
801065e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065ea:	e9 cb f2 ff ff       	jmp    801058ba <alltraps>

801065ef <vector210>:
.globl vector210
vector210:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $210
801065f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065f6:	e9 bf f2 ff ff       	jmp    801058ba <alltraps>

801065fb <vector211>:
.globl vector211
vector211:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $211
801065fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106602:	e9 b3 f2 ff ff       	jmp    801058ba <alltraps>

80106607 <vector212>:
.globl vector212
vector212:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $212
80106609:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010660e:	e9 a7 f2 ff ff       	jmp    801058ba <alltraps>

80106613 <vector213>:
.globl vector213
vector213:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $213
80106615:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010661a:	e9 9b f2 ff ff       	jmp    801058ba <alltraps>

8010661f <vector214>:
.globl vector214
vector214:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $214
80106621:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106626:	e9 8f f2 ff ff       	jmp    801058ba <alltraps>

8010662b <vector215>:
.globl vector215
vector215:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $215
8010662d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106632:	e9 83 f2 ff ff       	jmp    801058ba <alltraps>

80106637 <vector216>:
.globl vector216
vector216:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $216
80106639:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010663e:	e9 77 f2 ff ff       	jmp    801058ba <alltraps>

80106643 <vector217>:
.globl vector217
vector217:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $217
80106645:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010664a:	e9 6b f2 ff ff       	jmp    801058ba <alltraps>

8010664f <vector218>:
.globl vector218
vector218:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $218
80106651:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106656:	e9 5f f2 ff ff       	jmp    801058ba <alltraps>

8010665b <vector219>:
.globl vector219
vector219:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $219
8010665d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106662:	e9 53 f2 ff ff       	jmp    801058ba <alltraps>

80106667 <vector220>:
.globl vector220
vector220:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $220
80106669:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010666e:	e9 47 f2 ff ff       	jmp    801058ba <alltraps>

80106673 <vector221>:
.globl vector221
vector221:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $221
80106675:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010667a:	e9 3b f2 ff ff       	jmp    801058ba <alltraps>

8010667f <vector222>:
.globl vector222
vector222:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $222
80106681:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106686:	e9 2f f2 ff ff       	jmp    801058ba <alltraps>

8010668b <vector223>:
.globl vector223
vector223:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $223
8010668d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106692:	e9 23 f2 ff ff       	jmp    801058ba <alltraps>

80106697 <vector224>:
.globl vector224
vector224:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $224
80106699:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010669e:	e9 17 f2 ff ff       	jmp    801058ba <alltraps>

801066a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $225
801066a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066aa:	e9 0b f2 ff ff       	jmp    801058ba <alltraps>

801066af <vector226>:
.globl vector226
vector226:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $226
801066b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066b6:	e9 ff f1 ff ff       	jmp    801058ba <alltraps>

801066bb <vector227>:
.globl vector227
vector227:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $227
801066bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066c2:	e9 f3 f1 ff ff       	jmp    801058ba <alltraps>

801066c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $228
801066c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066ce:	e9 e7 f1 ff ff       	jmp    801058ba <alltraps>

801066d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $229
801066d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066da:	e9 db f1 ff ff       	jmp    801058ba <alltraps>

801066df <vector230>:
.globl vector230
vector230:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $230
801066e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066e6:	e9 cf f1 ff ff       	jmp    801058ba <alltraps>

801066eb <vector231>:
.globl vector231
vector231:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $231
801066ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066f2:	e9 c3 f1 ff ff       	jmp    801058ba <alltraps>

801066f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $232
801066f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066fe:	e9 b7 f1 ff ff       	jmp    801058ba <alltraps>

80106703 <vector233>:
.globl vector233
vector233:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $233
80106705:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010670a:	e9 ab f1 ff ff       	jmp    801058ba <alltraps>

8010670f <vector234>:
.globl vector234
vector234:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $234
80106711:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106716:	e9 9f f1 ff ff       	jmp    801058ba <alltraps>

8010671b <vector235>:
.globl vector235
vector235:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $235
8010671d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106722:	e9 93 f1 ff ff       	jmp    801058ba <alltraps>

80106727 <vector236>:
.globl vector236
vector236:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $236
80106729:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010672e:	e9 87 f1 ff ff       	jmp    801058ba <alltraps>

80106733 <vector237>:
.globl vector237
vector237:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $237
80106735:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010673a:	e9 7b f1 ff ff       	jmp    801058ba <alltraps>

8010673f <vector238>:
.globl vector238
vector238:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $238
80106741:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106746:	e9 6f f1 ff ff       	jmp    801058ba <alltraps>

8010674b <vector239>:
.globl vector239
vector239:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $239
8010674d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106752:	e9 63 f1 ff ff       	jmp    801058ba <alltraps>

80106757 <vector240>:
.globl vector240
vector240:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $240
80106759:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010675e:	e9 57 f1 ff ff       	jmp    801058ba <alltraps>

80106763 <vector241>:
.globl vector241
vector241:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $241
80106765:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010676a:	e9 4b f1 ff ff       	jmp    801058ba <alltraps>

8010676f <vector242>:
.globl vector242
vector242:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $242
80106771:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106776:	e9 3f f1 ff ff       	jmp    801058ba <alltraps>

8010677b <vector243>:
.globl vector243
vector243:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $243
8010677d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106782:	e9 33 f1 ff ff       	jmp    801058ba <alltraps>

80106787 <vector244>:
.globl vector244
vector244:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $244
80106789:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010678e:	e9 27 f1 ff ff       	jmp    801058ba <alltraps>

80106793 <vector245>:
.globl vector245
vector245:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $245
80106795:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010679a:	e9 1b f1 ff ff       	jmp    801058ba <alltraps>

8010679f <vector246>:
.globl vector246
vector246:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $246
801067a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067a6:	e9 0f f1 ff ff       	jmp    801058ba <alltraps>

801067ab <vector247>:
.globl vector247
vector247:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $247
801067ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067b2:	e9 03 f1 ff ff       	jmp    801058ba <alltraps>

801067b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $248
801067b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067be:	e9 f7 f0 ff ff       	jmp    801058ba <alltraps>

801067c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $249
801067c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067ca:	e9 eb f0 ff ff       	jmp    801058ba <alltraps>

801067cf <vector250>:
.globl vector250
vector250:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $250
801067d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067d6:	e9 df f0 ff ff       	jmp    801058ba <alltraps>

801067db <vector251>:
.globl vector251
vector251:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $251
801067dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067e2:	e9 d3 f0 ff ff       	jmp    801058ba <alltraps>

801067e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $252
801067e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067ee:	e9 c7 f0 ff ff       	jmp    801058ba <alltraps>

801067f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $253
801067f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067fa:	e9 bb f0 ff ff       	jmp    801058ba <alltraps>

801067ff <vector254>:
.globl vector254
vector254:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $254
80106801:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106806:	e9 af f0 ff ff       	jmp    801058ba <alltraps>

8010680b <vector255>:
.globl vector255
vector255:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $255
8010680d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106812:	e9 a3 f0 ff ff       	jmp    801058ba <alltraps>
80106817:	66 90                	xchg   %ax,%ax
80106819:	66 90                	xchg   %ax,%ax
8010681b:	66 90                	xchg   %ax,%ax
8010681d:	66 90                	xchg   %ax,%ax
8010681f:	90                   	nop

80106820 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	57                   	push   %edi
80106824:	56                   	push   %esi
80106825:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106826:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010682c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106832:	83 ec 1c             	sub    $0x1c,%esp
80106835:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106838:	39 d3                	cmp    %edx,%ebx
8010683a:	73 49                	jae    80106885 <deallocuvm.part.0+0x65>
8010683c:	89 c7                	mov    %eax,%edi
8010683e:	eb 0c                	jmp    8010684c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106840:	83 c0 01             	add    $0x1,%eax
80106843:	c1 e0 16             	shl    $0x16,%eax
80106846:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106848:	39 da                	cmp    %ebx,%edx
8010684a:	76 39                	jbe    80106885 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010684c:	89 d8                	mov    %ebx,%eax
8010684e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106851:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106854:	f6 c1 01             	test   $0x1,%cl
80106857:	74 e7                	je     80106840 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106859:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010685b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106861:	c1 ee 0a             	shr    $0xa,%esi
80106864:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010686a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106871:	85 f6                	test   %esi,%esi
80106873:	74 cb                	je     80106840 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106875:	8b 06                	mov    (%esi),%eax
80106877:	a8 01                	test   $0x1,%al
80106879:	75 15                	jne    80106890 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010687b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106881:	39 da                	cmp    %ebx,%edx
80106883:	77 c7                	ja     8010684c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106885:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106888:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010688b:	5b                   	pop    %ebx
8010688c:	5e                   	pop    %esi
8010688d:	5f                   	pop    %edi
8010688e:	5d                   	pop    %ebp
8010688f:	c3                   	ret    
      if(pa == 0)
80106890:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106895:	74 25                	je     801068bc <deallocuvm.part.0+0x9c>
      kfree(v);
80106897:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010689a:	05 00 00 00 80       	add    $0x80000000,%eax
8010689f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801068a8:	50                   	push   %eax
801068a9:	e8 32 bc ff ff       	call   801024e0 <kfree>
      *pte = 0;
801068ae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801068b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801068b7:	83 c4 10             	add    $0x10,%esp
801068ba:	eb 8c                	jmp    80106848 <deallocuvm.part.0+0x28>
        panic("kfree");
801068bc:	83 ec 0c             	sub    $0xc,%esp
801068bf:	68 86 74 10 80       	push   $0x80107486
801068c4:	e8 b7 9a ff ff       	call   80100380 <panic>
801068c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068d0 <mappages>:
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801068d6:	89 d3                	mov    %edx,%ebx
801068d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801068de:	83 ec 1c             	sub    $0x1c,%esp
801068e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068f0:	8b 45 08             	mov    0x8(%ebp),%eax
801068f3:	29 d8                	sub    %ebx,%eax
801068f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068f8:	eb 3d                	jmp    80106937 <mappages+0x67>
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106900:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106902:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106907:	c1 ea 0a             	shr    $0xa,%edx
8010690a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106910:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106917:	85 c0                	test   %eax,%eax
80106919:	74 75                	je     80106990 <mappages+0xc0>
    if(*pte & PTE_P)
8010691b:	f6 00 01             	testb  $0x1,(%eax)
8010691e:	0f 85 86 00 00 00    	jne    801069aa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106924:	0b 75 0c             	or     0xc(%ebp),%esi
80106927:	83 ce 01             	or     $0x1,%esi
8010692a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010692c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010692f:	74 6f                	je     801069a0 <mappages+0xd0>
    a += PGSIZE;
80106931:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010693a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010693d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106940:	89 d8                	mov    %ebx,%eax
80106942:	c1 e8 16             	shr    $0x16,%eax
80106945:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106948:	8b 07                	mov    (%edi),%eax
8010694a:	a8 01                	test   $0x1,%al
8010694c:	75 b2                	jne    80106900 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010694e:	e8 6d bd ff ff       	call   801026c0 <kalloc>
80106953:	85 c0                	test   %eax,%eax
80106955:	74 39                	je     80106990 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106957:	83 ec 04             	sub    $0x4,%esp
8010695a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010695d:	68 00 10 00 00       	push   $0x1000
80106962:	6a 00                	push   $0x0
80106964:	50                   	push   %eax
80106965:	e8 66 dd ff ff       	call   801046d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010696a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010696d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106970:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106976:	83 c8 07             	or     $0x7,%eax
80106979:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010697b:	89 d8                	mov    %ebx,%eax
8010697d:	c1 e8 0a             	shr    $0xa,%eax
80106980:	25 fc 0f 00 00       	and    $0xffc,%eax
80106985:	01 d0                	add    %edx,%eax
80106987:	eb 92                	jmp    8010691b <mappages+0x4b>
80106989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106990:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106998:	5b                   	pop    %ebx
80106999:	5e                   	pop    %esi
8010699a:	5f                   	pop    %edi
8010699b:	5d                   	pop    %ebp
8010699c:	c3                   	ret    
8010699d:	8d 76 00             	lea    0x0(%esi),%esi
801069a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801069a3:	31 c0                	xor    %eax,%eax
}
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    
      panic("remap");
801069aa:	83 ec 0c             	sub    $0xc,%esp
801069ad:	68 cc 7a 10 80       	push   $0x80107acc
801069b2:	e8 c9 99 ff ff       	call   80100380 <panic>
801069b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069be:	66 90                	xchg   %ax,%ax

801069c0 <seginit>:
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069c6:	e8 f5 cf ff ff       	call   801039c0 <cpuid>
  pd[0] = size-1;
801069cb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801069d0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069da:	c7 80 18 98 14 80 ff 	movl   $0xffff,-0x7feb67e8(%eax)
801069e1:	ff 00 00 
801069e4:	c7 80 1c 98 14 80 00 	movl   $0xcf9a00,-0x7feb67e4(%eax)
801069eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069ee:	c7 80 20 98 14 80 ff 	movl   $0xffff,-0x7feb67e0(%eax)
801069f5:	ff 00 00 
801069f8:	c7 80 24 98 14 80 00 	movl   $0xcf9200,-0x7feb67dc(%eax)
801069ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a02:	c7 80 28 98 14 80 ff 	movl   $0xffff,-0x7feb67d8(%eax)
80106a09:	ff 00 00 
80106a0c:	c7 80 2c 98 14 80 00 	movl   $0xcffa00,-0x7feb67d4(%eax)
80106a13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a16:	c7 80 30 98 14 80 ff 	movl   $0xffff,-0x7feb67d0(%eax)
80106a1d:	ff 00 00 
80106a20:	c7 80 34 98 14 80 00 	movl   $0xcff200,-0x7feb67cc(%eax)
80106a27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a2a:	05 10 98 14 80       	add    $0x80149810,%eax
  pd[1] = (uint)p;
80106a2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a33:	c1 e8 10             	shr    $0x10,%eax
80106a36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a3d:	0f 01 10             	lgdtl  (%eax)
}
80106a40:	c9                   	leave  
80106a41:	c3                   	ret    
80106a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a50:	a1 c4 c4 14 80       	mov    0x8014c4c4,%eax
80106a55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a5a:	0f 22 d8             	mov    %eax,%cr3
}
80106a5d:	c3                   	ret    
80106a5e:	66 90                	xchg   %ax,%ax

80106a60 <switchuvm>:
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	83 ec 1c             	sub    $0x1c,%esp
80106a69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a6c:	85 f6                	test   %esi,%esi
80106a6e:	0f 84 cb 00 00 00    	je     80106b3f <switchuvm+0xdf>
  if(p->kstack == 0)
80106a74:	8b 46 08             	mov    0x8(%esi),%eax
80106a77:	85 c0                	test   %eax,%eax
80106a79:	0f 84 da 00 00 00    	je     80106b59 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106a7f:	8b 46 04             	mov    0x4(%esi),%eax
80106a82:	85 c0                	test   %eax,%eax
80106a84:	0f 84 c2 00 00 00    	je     80106b4c <switchuvm+0xec>
  pushcli();
80106a8a:	e8 31 da ff ff       	call   801044c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a8f:	e8 cc ce ff ff       	call   80103960 <mycpu>
80106a94:	89 c3                	mov    %eax,%ebx
80106a96:	e8 c5 ce ff ff       	call   80103960 <mycpu>
80106a9b:	89 c7                	mov    %eax,%edi
80106a9d:	e8 be ce ff ff       	call   80103960 <mycpu>
80106aa2:	83 c7 08             	add    $0x8,%edi
80106aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106aa8:	e8 b3 ce ff ff       	call   80103960 <mycpu>
80106aad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ab0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ab5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106abc:	83 c0 08             	add    $0x8,%eax
80106abf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ac6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106acb:	83 c1 08             	add    $0x8,%ecx
80106ace:	c1 e8 18             	shr    $0x18,%eax
80106ad1:	c1 e9 10             	shr    $0x10,%ecx
80106ad4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ada:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ae0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ae5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106aec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106af1:	e8 6a ce ff ff       	call   80103960 <mycpu>
80106af6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106afd:	e8 5e ce ff ff       	call   80103960 <mycpu>
80106b02:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b06:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b0f:	e8 4c ce ff ff       	call   80103960 <mycpu>
80106b14:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b17:	e8 44 ce ff ff       	call   80103960 <mycpu>
80106b1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b20:	b8 28 00 00 00       	mov    $0x28,%eax
80106b25:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b28:	8b 46 04             	mov    0x4(%esi),%eax
80106b2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b30:	0f 22 d8             	mov    %eax,%cr3
}
80106b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b36:	5b                   	pop    %ebx
80106b37:	5e                   	pop    %esi
80106b38:	5f                   	pop    %edi
80106b39:	5d                   	pop    %ebp
  popcli();
80106b3a:	e9 d1 d9 ff ff       	jmp    80104510 <popcli>
    panic("switchuvm: no process");
80106b3f:	83 ec 0c             	sub    $0xc,%esp
80106b42:	68 d2 7a 10 80       	push   $0x80107ad2
80106b47:	e8 34 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106b4c:	83 ec 0c             	sub    $0xc,%esp
80106b4f:	68 fd 7a 10 80       	push   $0x80107afd
80106b54:	e8 27 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106b59:	83 ec 0c             	sub    $0xc,%esp
80106b5c:	68 e8 7a 10 80       	push   $0x80107ae8
80106b61:	e8 1a 98 ff ff       	call   80100380 <panic>
80106b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6d:	8d 76 00             	lea    0x0(%esi),%esi

80106b70 <inituvm>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 1c             	sub    $0x1c,%esp
80106b79:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b7c:	8b 75 10             	mov    0x10(%ebp),%esi
80106b7f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b85:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b8b:	77 4b                	ja     80106bd8 <inituvm+0x68>
  mem = kalloc();
80106b8d:	e8 2e bb ff ff       	call   801026c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106b92:	83 ec 04             	sub    $0x4,%esp
80106b95:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106b9a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b9c:	6a 00                	push   $0x0
80106b9e:	50                   	push   %eax
80106b9f:	e8 2c db ff ff       	call   801046d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ba4:	58                   	pop    %eax
80106ba5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bab:	5a                   	pop    %edx
80106bac:	6a 06                	push   $0x6
80106bae:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bb3:	31 d2                	xor    %edx,%edx
80106bb5:	50                   	push   %eax
80106bb6:	89 f8                	mov    %edi,%eax
80106bb8:	e8 13 fd ff ff       	call   801068d0 <mappages>
  memmove(mem, init, sz);
80106bbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bc0:	89 75 10             	mov    %esi,0x10(%ebp)
80106bc3:	83 c4 10             	add    $0x10,%esp
80106bc6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106bc9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bcf:	5b                   	pop    %ebx
80106bd0:	5e                   	pop    %esi
80106bd1:	5f                   	pop    %edi
80106bd2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106bd3:	e9 98 db ff ff       	jmp    80104770 <memmove>
    panic("inituvm: more than a page");
80106bd8:	83 ec 0c             	sub    $0xc,%esp
80106bdb:	68 11 7b 10 80       	push   $0x80107b11
80106be0:	e8 9b 97 ff ff       	call   80100380 <panic>
80106be5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <loaduvm>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bfc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106bff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c04:	0f 85 bb 00 00 00    	jne    80106cc5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106c0a:	01 f0                	add    %esi,%eax
80106c0c:	89 f3                	mov    %esi,%ebx
80106c0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c11:	8b 45 14             	mov    0x14(%ebp),%eax
80106c14:	01 f0                	add    %esi,%eax
80106c16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106c19:	85 f6                	test   %esi,%esi
80106c1b:	0f 84 87 00 00 00    	je     80106ca8 <loaduvm+0xb8>
80106c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106c2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106c2e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106c30:	89 c2                	mov    %eax,%edx
80106c32:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c35:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106c38:	f6 c2 01             	test   $0x1,%dl
80106c3b:	75 13                	jne    80106c50 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106c3d:	83 ec 0c             	sub    $0xc,%esp
80106c40:	68 2b 7b 10 80       	push   $0x80107b2b
80106c45:	e8 36 97 ff ff       	call   80100380 <panic>
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c50:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c53:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106c59:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c5e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c65:	85 c0                	test   %eax,%eax
80106c67:	74 d4                	je     80106c3d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106c69:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c6b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106c6e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106c73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c78:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106c7e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c81:	29 d9                	sub    %ebx,%ecx
80106c83:	05 00 00 00 80       	add    $0x80000000,%eax
80106c88:	57                   	push   %edi
80106c89:	51                   	push   %ecx
80106c8a:	50                   	push   %eax
80106c8b:	ff 75 10             	push   0x10(%ebp)
80106c8e:	e8 fd ad ff ff       	call   80101a90 <readi>
80106c93:	83 c4 10             	add    $0x10,%esp
80106c96:	39 f8                	cmp    %edi,%eax
80106c98:	75 1e                	jne    80106cb8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106c9a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ca0:	89 f0                	mov    %esi,%eax
80106ca2:	29 d8                	sub    %ebx,%eax
80106ca4:	39 c6                	cmp    %eax,%esi
80106ca6:	77 80                	ja     80106c28 <loaduvm+0x38>
}
80106ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cab:	31 c0                	xor    %eax,%eax
}
80106cad:	5b                   	pop    %ebx
80106cae:	5e                   	pop    %esi
80106caf:	5f                   	pop    %edi
80106cb0:	5d                   	pop    %ebp
80106cb1:	c3                   	ret    
80106cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc0:	5b                   	pop    %ebx
80106cc1:	5e                   	pop    %esi
80106cc2:	5f                   	pop    %edi
80106cc3:	5d                   	pop    %ebp
80106cc4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106cc5:	83 ec 0c             	sub    $0xc,%esp
80106cc8:	68 d4 7b 10 80       	push   $0x80107bd4
80106ccd:	e8 ae 96 ff ff       	call   80100380 <panic>
80106cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ce0 <allocuvm>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 28             	sub    $0x28,%esp
80106ce9:	8b 7d 08             	mov    0x8(%ebp),%edi
  cprintf("here\n");
80106cec:	68 49 7b 10 80       	push   $0x80107b49
80106cf1:	e8 aa 99 ff ff       	call   801006a0 <cprintf>
  if(newsz >= KERNBASE)
80106cf6:	8b 45 10             	mov    0x10(%ebp),%eax
80106cf9:	83 c4 10             	add    $0x10,%esp
80106cfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cff:	85 c0                	test   %eax,%eax
80106d01:	0f 88 b9 00 00 00    	js     80106dc0 <allocuvm+0xe0>
  if(newsz < oldsz)
80106d07:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106d0d:	0f 82 9d 00 00 00    	jb     80106db0 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
80106d13:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d19:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d1f:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d22:	77 47                	ja     80106d6b <allocuvm+0x8b>
80106d24:	e9 8a 00 00 00       	jmp    80106db3 <allocuvm+0xd3>
80106d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106d30:	83 ec 04             	sub    $0x4,%esp
80106d33:	68 00 10 00 00       	push   $0x1000
80106d38:	6a 00                	push   $0x0
80106d3a:	50                   	push   %eax
80106d3b:	e8 90 d9 ff ff       	call   801046d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d40:	58                   	pop    %eax
80106d41:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d47:	5a                   	pop    %edx
80106d48:	6a 06                	push   $0x6
80106d4a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d4f:	89 f2                	mov    %esi,%edx
80106d51:	50                   	push   %eax
80106d52:	89 f8                	mov    %edi,%eax
80106d54:	e8 77 fb ff ff       	call   801068d0 <mappages>
80106d59:	83 c4 10             	add    $0x10,%esp
80106d5c:	85 c0                	test   %eax,%eax
80106d5e:	78 78                	js     80106dd8 <allocuvm+0xf8>
  for(; a < newsz; a += PGSIZE){
80106d60:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d66:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d69:	76 48                	jbe    80106db3 <allocuvm+0xd3>
    mem = kalloc();
80106d6b:	e8 50 b9 ff ff       	call   801026c0 <kalloc>
80106d70:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d72:	85 c0                	test   %eax,%eax
80106d74:	75 ba                	jne    80106d30 <allocuvm+0x50>
      cprintf("allocuvm out of memory\n");
80106d76:	83 ec 0c             	sub    $0xc,%esp
80106d79:	68 4f 7b 10 80       	push   $0x80107b4f
80106d7e:	e8 1d 99 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106d83:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d86:	83 c4 10             	add    $0x10,%esp
80106d89:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d8c:	74 32                	je     80106dc0 <allocuvm+0xe0>
80106d8e:	8b 55 10             	mov    0x10(%ebp),%edx
80106d91:	89 c1                	mov    %eax,%ecx
80106d93:	89 f8                	mov    %edi,%eax
80106d95:	e8 86 fa ff ff       	call   80106820 <deallocuvm.part.0>
      return 0;
80106d9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da7:	5b                   	pop    %ebx
80106da8:	5e                   	pop    %esi
80106da9:	5f                   	pop    %edi
80106daa:	5d                   	pop    %ebp
80106dab:	c3                   	ret    
80106dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db9:	5b                   	pop    %ebx
80106dba:	5e                   	pop    %esi
80106dbb:	5f                   	pop    %edi
80106dbc:	5d                   	pop    %ebp
80106dbd:	c3                   	ret    
80106dbe:	66 90                	xchg   %ax,%ax
    return 0;
80106dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dcd:	5b                   	pop    %ebx
80106dce:	5e                   	pop    %esi
80106dcf:	5f                   	pop    %edi
80106dd0:	5d                   	pop    %ebp
80106dd1:	c3                   	ret    
80106dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106dd8:	83 ec 0c             	sub    $0xc,%esp
80106ddb:	68 67 7b 10 80       	push   $0x80107b67
80106de0:	e8 bb 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106de5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de8:	83 c4 10             	add    $0x10,%esp
80106deb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106dee:	74 0c                	je     80106dfc <allocuvm+0x11c>
80106df0:	8b 55 10             	mov    0x10(%ebp),%edx
80106df3:	89 c1                	mov    %eax,%ecx
80106df5:	89 f8                	mov    %edi,%eax
80106df7:	e8 24 fa ff ff       	call   80106820 <deallocuvm.part.0>
      kfree(mem);
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	53                   	push   %ebx
80106e00:	e8 db b6 ff ff       	call   801024e0 <kfree>
      return 0;
80106e05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106e0c:	83 c4 10             	add    $0x10,%esp
}
80106e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret    
80106e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e20 <deallocuvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e26:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e29:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e2c:	39 d1                	cmp    %edx,%ecx
80106e2e:	73 10                	jae    80106e40 <deallocuvm+0x20>
}
80106e30:	5d                   	pop    %ebp
80106e31:	e9 ea f9 ff ff       	jmp    80106820 <deallocuvm.part.0>
80106e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi
80106e40:	89 d0                	mov    %edx,%eax
80106e42:	5d                   	pop    %ebp
80106e43:	c3                   	ret    
80106e44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e4f:	90                   	nop

80106e50 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 0c             	sub    $0xc,%esp
80106e59:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e5c:	85 f6                	test   %esi,%esi
80106e5e:	74 59                	je     80106eb9 <freevm+0x69>
  if(newsz >= oldsz)
80106e60:	31 c9                	xor    %ecx,%ecx
80106e62:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e67:	89 f0                	mov    %esi,%eax
80106e69:	89 f3                	mov    %esi,%ebx
80106e6b:	e8 b0 f9 ff ff       	call   80106820 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e70:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e76:	eb 0f                	jmp    80106e87 <freevm+0x37>
80106e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7f:	90                   	nop
80106e80:	83 c3 04             	add    $0x4,%ebx
80106e83:	39 df                	cmp    %ebx,%edi
80106e85:	74 23                	je     80106eaa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e87:	8b 03                	mov    (%ebx),%eax
80106e89:	a8 01                	test   $0x1,%al
80106e8b:	74 f3                	je     80106e80 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e92:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e95:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e98:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e9d:	50                   	push   %eax
80106e9e:	e8 3d b6 ff ff       	call   801024e0 <kfree>
80106ea3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ea6:	39 df                	cmp    %ebx,%edi
80106ea8:	75 dd                	jne    80106e87 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106eaa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eb0:	5b                   	pop    %ebx
80106eb1:	5e                   	pop    %esi
80106eb2:	5f                   	pop    %edi
80106eb3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106eb4:	e9 27 b6 ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80106eb9:	83 ec 0c             	sub    $0xc,%esp
80106ebc:	68 83 7b 10 80       	push   $0x80107b83
80106ec1:	e8 ba 94 ff ff       	call   80100380 <panic>
80106ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi

80106ed0 <setupkvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	56                   	push   %esi
80106ed4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ed5:	e8 e6 b7 ff ff       	call   801026c0 <kalloc>
80106eda:	89 c6                	mov    %eax,%esi
80106edc:	85 c0                	test   %eax,%eax
80106ede:	74 42                	je     80106f22 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106ee0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ee3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ee8:	68 00 10 00 00       	push   $0x1000
80106eed:	6a 00                	push   $0x0
80106eef:	50                   	push   %eax
80106ef0:	e8 db d7 ff ff       	call   801046d0 <memset>
80106ef5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ef8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106efb:	83 ec 08             	sub    $0x8,%esp
80106efe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f01:	ff 73 0c             	push   0xc(%ebx)
80106f04:	8b 13                	mov    (%ebx),%edx
80106f06:	50                   	push   %eax
80106f07:	29 c1                	sub    %eax,%ecx
80106f09:	89 f0                	mov    %esi,%eax
80106f0b:	e8 c0 f9 ff ff       	call   801068d0 <mappages>
80106f10:	83 c4 10             	add    $0x10,%esp
80106f13:	85 c0                	test   %eax,%eax
80106f15:	78 19                	js     80106f30 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f17:	83 c3 10             	add    $0x10,%ebx
80106f1a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f20:	75 d6                	jne    80106ef8 <setupkvm+0x28>
}
80106f22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f25:	89 f0                	mov    %esi,%eax
80106f27:	5b                   	pop    %ebx
80106f28:	5e                   	pop    %esi
80106f29:	5d                   	pop    %ebp
80106f2a:	c3                   	ret    
80106f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop
      freevm(pgdir);
80106f30:	83 ec 0c             	sub    $0xc,%esp
80106f33:	56                   	push   %esi
      return 0;
80106f34:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f36:	e8 15 ff ff ff       	call   80106e50 <freevm>
      return 0;
80106f3b:	83 c4 10             	add    $0x10,%esp
}
80106f3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f41:	89 f0                	mov    %esi,%eax
80106f43:	5b                   	pop    %ebx
80106f44:	5e                   	pop    %esi
80106f45:	5d                   	pop    %ebp
80106f46:	c3                   	ret    
80106f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4e:	66 90                	xchg   %ax,%ax

80106f50 <kvmalloc>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f56:	e8 75 ff ff ff       	call   80106ed0 <setupkvm>
80106f5b:	a3 c4 c4 14 80       	mov    %eax,0x8014c4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f60:	05 00 00 00 80       	add    $0x80000000,%eax
80106f65:	0f 22 d8             	mov    %eax,%cr3
}
80106f68:	c9                   	leave  
80106f69:	c3                   	ret    
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	83 ec 08             	sub    $0x8,%esp
80106f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106f79:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106f7c:	89 c1                	mov    %eax,%ecx
80106f7e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f81:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106f84:	f6 c2 01             	test   $0x1,%dl
80106f87:	75 17                	jne    80106fa0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f89:	83 ec 0c             	sub    $0xc,%esp
80106f8c:	68 94 7b 10 80       	push   $0x80107b94
80106f91:	e8 ea 93 ff ff       	call   80100380 <panic>
80106f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fa0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fa3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106fa9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106fae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106fb5:	85 c0                	test   %eax,%eax
80106fb7:	74 d0                	je     80106f89 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106fb9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106fbc:	c9                   	leave  
80106fbd:	c3                   	ret    
80106fbe:	66 90                	xchg   %ax,%ax

80106fc0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106fc9:	e8 02 ff ff ff       	call   80106ed0 <setupkvm>
80106fce:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fd1:	85 c0                	test   %eax,%eax
80106fd3:	0f 84 bd 00 00 00    	je     80107096 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fdc:	85 c9                	test   %ecx,%ecx
80106fde:	0f 84 b2 00 00 00    	je     80107096 <copyuvm+0xd6>
80106fe4:	31 f6                	xor    %esi,%esi
80106fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80106ff0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80106ff3:	89 f0                	mov    %esi,%eax
80106ff5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106ff8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106ffb:	a8 01                	test   $0x1,%al
80106ffd:	75 11                	jne    80107010 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106fff:	83 ec 0c             	sub    $0xc,%esp
80107002:	68 9e 7b 10 80       	push   $0x80107b9e
80107007:	e8 74 93 ff ff       	call   80100380 <panic>
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107010:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107012:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107017:	c1 ea 0a             	shr    $0xa,%edx
8010701a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107020:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107027:	85 c0                	test   %eax,%eax
80107029:	74 d4                	je     80106fff <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010702b:	8b 00                	mov    (%eax),%eax
8010702d:	a8 01                	test   $0x1,%al
8010702f:	0f 84 9f 00 00 00    	je     801070d4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107035:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107037:	25 ff 0f 00 00       	and    $0xfff,%eax
8010703c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010703f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107045:	e8 76 b6 ff ff       	call   801026c0 <kalloc>
8010704a:	89 c3                	mov    %eax,%ebx
8010704c:	85 c0                	test   %eax,%eax
8010704e:	74 64                	je     801070b4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107050:	83 ec 04             	sub    $0x4,%esp
80107053:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107059:	68 00 10 00 00       	push   $0x1000
8010705e:	57                   	push   %edi
8010705f:	50                   	push   %eax
80107060:	e8 0b d7 ff ff       	call   80104770 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107065:	58                   	pop    %eax
80107066:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010706c:	5a                   	pop    %edx
8010706d:	ff 75 e4             	push   -0x1c(%ebp)
80107070:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107075:	89 f2                	mov    %esi,%edx
80107077:	50                   	push   %eax
80107078:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010707b:	e8 50 f8 ff ff       	call   801068d0 <mappages>
80107080:	83 c4 10             	add    $0x10,%esp
80107083:	85 c0                	test   %eax,%eax
80107085:	78 21                	js     801070a8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107087:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010708d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107090:	0f 87 5a ff ff ff    	ja     80106ff0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107096:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709c:	5b                   	pop    %ebx
8010709d:	5e                   	pop    %esi
8010709e:	5f                   	pop    %edi
8010709f:	5d                   	pop    %ebp
801070a0:	c3                   	ret    
801070a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801070a8:	83 ec 0c             	sub    $0xc,%esp
801070ab:	53                   	push   %ebx
801070ac:	e8 2f b4 ff ff       	call   801024e0 <kfree>
      goto bad;
801070b1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801070b4:	83 ec 0c             	sub    $0xc,%esp
801070b7:	ff 75 e0             	push   -0x20(%ebp)
801070ba:	e8 91 fd ff ff       	call   80106e50 <freevm>
  return 0;
801070bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070c6:	83 c4 10             	add    $0x10,%esp
}
801070c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070cf:	5b                   	pop    %ebx
801070d0:	5e                   	pop    %esi
801070d1:	5f                   	pop    %edi
801070d2:	5d                   	pop    %ebp
801070d3:	c3                   	ret    
      panic("copyuvm: page not present");
801070d4:	83 ec 0c             	sub    $0xc,%esp
801070d7:	68 b8 7b 10 80       	push   $0x80107bb8
801070dc:	e8 9f 92 ff ff       	call   80100380 <panic>
801070e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop

801070f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070f6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801070f9:	89 c1                	mov    %eax,%ecx
801070fb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801070fe:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107101:	f6 c2 01             	test   $0x1,%dl
80107104:	0f 84 00 01 00 00    	je     8010720a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010710a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010710d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107113:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107114:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107119:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107120:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107122:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107127:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010712a:	05 00 00 00 80       	add    $0x80000000,%eax
8010712f:	83 fa 05             	cmp    $0x5,%edx
80107132:	ba 00 00 00 00       	mov    $0x0,%edx
80107137:	0f 45 c2             	cmovne %edx,%eax
}
8010713a:	c3                   	ret    
8010713b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop

80107140 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 0c             	sub    $0xc,%esp
80107149:	8b 75 14             	mov    0x14(%ebp),%esi
8010714c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010714f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107152:	85 f6                	test   %esi,%esi
80107154:	75 51                	jne    801071a7 <copyout+0x67>
80107156:	e9 a5 00 00 00       	jmp    80107200 <copyout+0xc0>
8010715b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010715f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107160:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107166:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010716c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107172:	74 75                	je     801071e9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107174:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107176:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107179:	29 c3                	sub    %eax,%ebx
8010717b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107181:	39 f3                	cmp    %esi,%ebx
80107183:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107186:	29 f8                	sub    %edi,%eax
80107188:	83 ec 04             	sub    $0x4,%esp
8010718b:	01 c1                	add    %eax,%ecx
8010718d:	53                   	push   %ebx
8010718e:	52                   	push   %edx
8010718f:	51                   	push   %ecx
80107190:	e8 db d5 ff ff       	call   80104770 <memmove>
    len -= n;
    buf += n;
80107195:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107198:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010719e:	83 c4 10             	add    $0x10,%esp
    buf += n;
801071a1:	01 da                	add    %ebx,%edx
  while(len > 0){
801071a3:	29 de                	sub    %ebx,%esi
801071a5:	74 59                	je     80107200 <copyout+0xc0>
  if(*pde & PTE_P){
801071a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801071aa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801071ac:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801071ae:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801071b1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801071b7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801071ba:	f6 c1 01             	test   $0x1,%cl
801071bd:	0f 84 4e 00 00 00    	je     80107211 <copyout.cold>
  return &pgtab[PTX(va)];
801071c3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071c5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801071cb:	c1 eb 0c             	shr    $0xc,%ebx
801071ce:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801071d4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801071db:	89 d9                	mov    %ebx,%ecx
801071dd:	83 e1 05             	and    $0x5,%ecx
801071e0:	83 f9 05             	cmp    $0x5,%ecx
801071e3:	0f 84 77 ff ff ff    	je     80107160 <copyout+0x20>
  }
  return 0;
}
801071e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071f1:	5b                   	pop    %ebx
801071f2:	5e                   	pop    %esi
801071f3:	5f                   	pop    %edi
801071f4:	5d                   	pop    %ebp
801071f5:	c3                   	ret    
801071f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071fd:	8d 76 00             	lea    0x0(%esi),%esi
80107200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107203:	31 c0                	xor    %eax,%eax
}
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    

8010720a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010720a:	a1 00 00 00 00       	mov    0x0,%eax
8010720f:	0f 0b                	ud2    

80107211 <copyout.cold>:
80107211:	a1 00 00 00 00       	mov    0x0,%eax
80107216:	0f 0b                	ud2    
