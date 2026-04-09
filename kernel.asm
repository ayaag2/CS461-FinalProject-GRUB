
kernel:     file format elf64-x86-64


Disassembly of section .text:

ffff800000100000 <begin>:
ffff800000100000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
ffff800000100006:	01 00                	add    %eax,(%rax)
ffff800000100008:	fe 4f 51             	decb   0x51(%rdi)
ffff80000010000b:	e4 00                	in     $0x0,%al
ffff80000010000d:	00 10                	add    %dl,(%rax)
ffff80000010000f:	00 00                	add    %al,(%rax)
ffff800000100011:	00 10                	add    %dl,(%rax)
ffff800000100013:	00 00                	add    %al,(%rax)
ffff800000100015:	e0 10                	loopne ffff800000100027 <mboot_entry+0x7>
ffff800000100017:	00 00                	add    %al,(%rax)
ffff800000100019:	60                   	(bad)
ffff80000010001a:	12 00                	adc    (%rax),%al
ffff80000010001c:	20 00                	and    %al,(%rax)
ffff80000010001e:	10 00                	adc    %al,(%rax)

ffff800000100020 <mboot_entry>:
  .long mboot_entry_addr

.code32
mboot_entry:
# zero 2 pages for our bootstrap page tables
  xor     %eax, %eax    # value=0
ffff800000100020:	31 c0                	xor    %eax,%eax
  mov     $0x1000, %edi # starting at 4096
ffff800000100022:	bf 00 10 00 00       	mov    $0x1000,%edi
  mov     $0x2000, %ecx # size=8192
ffff800000100027:	b9 00 20 00 00       	mov    $0x2000,%ecx
  rep     stosb         # memset(4096, 0, 8192)
ffff80000010002c:	f3 aa                	rep stos %al,(%rdi)

# map both virtual address 0 and KERNBASE to the same PDPT
# note: 32-bit operations manipulating 64-bit page table
# PML4T[0] -> 0x2000 (PDPT)
# PML4T[256] -> 0x2000 (PDPT)
  mov     $(0x2000 | PTE_P | PTE_W), %eax
ffff80000010002e:	b8 03 20 00 00       	mov    $0x2003,%eax
  mov     %eax, 0x1000  # PML4T[0]
ffff800000100033:	a3 00 10 00 00 a3 00 	movabs %eax,0x1800a300001000
ffff80000010003a:	18 00 
  mov     %eax, 0x1800  # PML4T[256]
ffff80000010003c:	00 b8 83 00 00 00    	add    %bh,0x83(%rax)

# PDPT[0] -> 0x0 (1 GB flat map page)
  mov     $(0x0 | PTE_P | PTE_PS | PTE_W), %eax
  mov     %eax, 0x2000  # PDPT[0]
ffff800000100042:	a3                   	.byte 0xa3
ffff800000100043:	00 20                	add    %ah,(%rax)
ffff800000100045:	00 00                	add    %al,(%rax)

# Clear ebx for initial processor boot.
# When secondary processors boot, they'll call through
# entry32mp (from entryother), but with a nonzero ebx.
# We'll reuse these bootstrap pagetables and GDT.
  xor     %ebx, %ebx
ffff800000100047:	31 db                	xor    %ebx,%ebx

ffff800000100049 <entry32mp>:

.global entry32mp
entry32mp:
# CR3 -> 0x1000 (PML4T)
  mov     $0x1000, %eax
ffff800000100049:	b8 00 10 00 00       	mov    $0x1000,%eax
  mov     %eax, %cr3
ffff80000010004e:	0f 22 d8             	mov    %rax,%cr3

  lgdt    (gdtr64 - mboot_header + mboot_load_addr)
ffff800000100051:	0f 01 15 90 00 10 00 	lgdt   0x100090(%rip)        # ffff8000002000e8 <end+0xda0e8>

# PAE is required for 64-bit paging: CR4.PAE=1
  mov     %cr4, %eax
ffff800000100058:	0f 20 e0             	mov    %cr4,%rax
  bts     $5, %eax
ffff80000010005b:	0f ba e8 05          	bts    $0x5,%eax
  mov     %eax, %cr4
ffff80000010005f:	0f 22 e0             	mov    %rax,%cr4

# access EFER Model specific register
  mov     $MSR_EFER, %ecx
ffff800000100062:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
ffff800000100067:	0f 32                	rdmsr
  bts     $0, %eax #enable system call extensions
ffff800000100069:	0f ba e8 00          	bts    $0x0,%eax
  bts     $8, %eax #enable long mode
ffff80000010006d:	0f ba e8 08          	bts    $0x8,%eax
  wrmsr
ffff800000100071:	0f 30                	wrmsr

# enable paging
  mov     %cr0, %eax
ffff800000100073:	0f 20 c0             	mov    %cr0,%rax
  orl     $(CR0_PG | CR0_WP | CR0_MP), %eax
ffff800000100076:	0d 02 00 01 80       	or     $0x80010002,%eax
  mov     %eax, %cr0
ffff80000010007b:	0f 22 c0             	mov    %rax,%cr0

# shift to 64bit segment
  ljmp    $8, $(entry64low - mboot_header + mboot_load_addr)
ffff80000010007e:	ea                   	(bad)
ffff80000010007f:	c0 00 10             	rolb   $0x10,(%rax)
ffff800000100082:	00 08                	add    %cl,(%rax)
ffff800000100084:	00 66 66             	add    %ah,0x66(%rsi)
ffff800000100087:	2e 0f 1f 84 00 00 00 	cs nopl 0x0(%rax,%rax,1)
ffff80000010008e:	00 00 

ffff800000100090 <gdtr64>:
ffff800000100090:	17                   	(bad)
ffff800000100091:	00 a0 00 10 00 00    	add    %ah,0x1000(%rax)
ffff800000100097:	00 00                	add    %al,(%rax)
ffff800000100099:	00 90 0f 1f 44 00    	add    %dl,0x441f0f(%rax)
	...

ffff8000001000a0 <gdt64_begin>:
	...
ffff8000001000ac:	00 98 20 00 00 00    	add    %bl,0x20(%rax)
ffff8000001000b2:	00 00                	add    %al,(%rax)
ffff8000001000b4:	00                   	.byte 0
ffff8000001000b5:	90                   	nop
	...

ffff8000001000b8 <gdt64_end>:
ffff8000001000b8:	90                   	nop
ffff8000001000b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

ffff8000001000c0 <entry64low>:
gdt64_end:

.align 16
.code64
entry64low:
  movabs  $entry64high, %rax
ffff8000001000c0:	48 b8 cc 00 10 00 00 	movabs $0xffff8000001000cc,%rax
ffff8000001000c7:	80 ff ff 
  jmp     *%rax
ffff8000001000ca:	ff e0                	jmp    *%rax

ffff8000001000cc <_start>:
.global _start
_start:
entry64high:

# ensure data segment registers are sane
  xor     %rax, %rax
ffff8000001000cc:	48 31 c0             	xor    %rax,%rax
  mov     %ax, %ss
ffff8000001000cf:	8e d0                	mov    %eax,%ss
  mov     %ax, %ds
ffff8000001000d1:	8e d8                	mov    %eax,%ds
  mov     %ax, %es
ffff8000001000d3:	8e c0                	mov    %eax,%es
  mov     %ax, %fs
ffff8000001000d5:	8e e0                	mov    %eax,%fs
  mov     %ax, %gs
ffff8000001000d7:	8e e8                	mov    %eax,%gs
  # mov     %cr4, %rax
  # or      $(CR4_PAE | CR4_OSXFSR | CR4_OSXMMEXCPT) , %rax
  # mov     %rax, %cr4

# check to see if we're booting a secondary core
  test    %ebx, %ebx
ffff8000001000d9:	85 db                	test   %ebx,%ebx
  jnz     entry64mp  # jump if booting a secondary code
ffff8000001000db:	75 14                	jne    ffff8000001000f1 <entry64mp>
# setup initial stack
  movabs  $0xFFFF800000010000, %rax
ffff8000001000dd:	48 b8 00 00 01 00 00 	movabs $0xffff800000010000,%rax
ffff8000001000e4:	80 ff ff 
  mov     %rax, %rsp
ffff8000001000e7:	48 89 c4             	mov    %rax,%rsp

# enter main()
  jmp     main  # end of initial (the first) core ASM
ffff8000001000ea:	e9 fb 52 00 00       	jmp    ffff8000001053ea <main>

ffff8000001000ef <__deadloop>:

.global __deadloop
__deadloop:
# we should never return here...
  jmp     .
ffff8000001000ef:	eb fe                	jmp    ffff8000001000ef <__deadloop>

ffff8000001000f1 <entry64mp>:

entry64mp:
# obtain kstack from data block before entryother
  mov     $0x7000, %rax
ffff8000001000f1:	48 c7 c0 00 70 00 00 	mov    $0x7000,%rax
  mov     -16(%rax), %rsp
ffff8000001000f8:	48 8b 60 f0          	mov    -0x10(%rax),%rsp
  jmp     mpenter  # end of secondary code ASM
ffff8000001000fc:	e9 0d 54 00 00       	jmp    ffff80000010550e <mpenter>

ffff800000100101 <wrmsr>:

.global wrmsr
wrmsr:
  mov     %rdi, %rcx     # arg0 -> msrnum
ffff800000100101:	48 89 f9             	mov    %rdi,%rcx
  mov     %rsi, %rax     # val.low -> eax
ffff800000100104:	48 89 f0             	mov    %rsi,%rax
  shr     $32, %rsi
ffff800000100107:	48 c1 ee 20          	shr    $0x20,%rsi
  mov     %rsi, %rdx     # val.high -> edx
ffff80000010010b:	48 89 f2             	mov    %rsi,%rdx
  wrmsr
ffff80000010010e:	0f 30                	wrmsr
  retq
ffff800000100110:	c3                   	ret

ffff800000100111 <ignore_sysret>:

.global ignore_sysret
ignore_sysret: #return error code 38, meaning function unimplemented
  mov     $-38, %rax
ffff800000100111:	48 c7 c0 da ff ff ff 	mov    $0xffffffffffffffda,%rax
  sysretq
ffff800000100118:	48 0f 07             	sysretq

ffff80000010011b <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
ffff80000010011b:	55                   	push   %rbp
ffff80000010011c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010011f:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
ffff800000100123:	48 ba 48 c7 10 00 00 	movabs $0xffff80000010c748,%rdx
ffff80000010012a:	80 ff ff 
ffff80000010012d:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100134:	80 ff ff 
ffff800000100137:	48 89 d6             	mov    %rdx,%rsi
ffff80000010013a:	48 89 c7             	mov    %rax,%rdi
ffff80000010013d:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000100144:	80 ff ff 
ffff800000100147:	ff d0                	call   *%rax
//PAGEBREAK!

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
ffff800000100149:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100150:	80 ff ff 
ffff800000100153:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff80000010015a:	80 ff ff 
ffff80000010015d:	48 89 88 a0 51 00 00 	mov    %rcx,0x51a0(%rax)
  bcache.head.next = &bcache.head;
ffff800000100164:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010016b:	80 ff ff 
ffff80000010016e:	48 89 88 a8 51 00 00 	mov    %rcx,0x51a8(%rax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff800000100175:	48 b8 68 e0 10 00 00 	movabs $0xffff80000010e068,%rax
ffff80000010017c:	80 ff ff 
ffff80000010017f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000100183:	e9 8e 00 00 00       	jmp    ffff800000100216 <binit+0xfb>
    b->next = bcache.head.next;
ffff800000100188:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010018f:	80 ff ff 
ffff800000100192:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff800000100199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010019d:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff8000001001a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001a8:	48 be 08 31 11 00 00 	movabs $0xffff800000113108,%rsi
ffff8000001001af:	80 ff ff 
ffff8000001001b2:	48 89 b0 98 00 00 00 	mov    %rsi,0x98(%rax)
    initsleeplock(&b->lock, "buffer");
ffff8000001001b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001001bd:	48 83 c0 10          	add    $0x10,%rax
ffff8000001001c1:	48 ba 4f c7 10 00 00 	movabs $0xffff80000010c74f,%rdx
ffff8000001001c8:	80 ff ff 
ffff8000001001cb:	48 89 d6             	mov    %rdx,%rsi
ffff8000001001ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001001d1:	48 b8 f2 79 10 00 00 	movabs $0xffff8000001079f2,%rax
ffff8000001001d8:	80 ff ff 
ffff8000001001db:	ff d0                	call   *%rax
    bcache.head.next->prev = b;
ffff8000001001dd:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001001e4:	80 ff ff 
ffff8000001001e7:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff8000001001ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001001f2:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff8000001001f9:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff800000100200:	80 ff ff 
ffff800000100203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100207:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffff80000010020e:	48 81 45 f8 b0 02 00 	addq   $0x2b0,-0x8(%rbp)
ffff800000100215:	00 
ffff800000100216:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff80000010021d:	80 ff ff 
ffff800000100220:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000100224:	0f 82 5e ff ff ff    	jb     ffff800000100188 <binit+0x6d>
  }
}
ffff80000010022a:	90                   	nop
ffff80000010022b:	90                   	nop
ffff80000010022c:	c9                   	leave
ffff80000010022d:	c3                   	ret

ffff80000010022e <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
ffff80000010022e:	55                   	push   %rbp
ffff80000010022f:	48 89 e5             	mov    %rsp,%rbp
ffff800000100232:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100236:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000100239:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  acquire(&bcache.lock);
ffff80000010023c:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff800000100243:	80 ff ff 
ffff800000100246:	48 89 c7             	mov    %rax,%rdi
ffff800000100249:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000100250:	80 ff ff 
ffff800000100253:	ff d0                	call   *%rax

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff800000100255:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010025c:	80 ff ff 
ffff80000010025f:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff800000100266:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010026a:	eb 77                	jmp    ffff8000001002e3 <bget+0xb5>
    if(b->dev == dev && b->blockno == blockno){
ffff80000010026c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100270:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000100273:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000100276:	75 5c                	jne    ffff8000001002d4 <bget+0xa6>
ffff800000100278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010027c:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010027f:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff800000100282:	75 50                	jne    ffff8000001002d4 <bget+0xa6>
      b->refcnt++;
ffff800000100284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100288:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff80000010028e:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000100291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100295:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
      release(&bcache.lock);
ffff80000010029b:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001002a2:	80 ff ff 
ffff8000001002a5:	48 89 c7             	mov    %rax,%rdi
ffff8000001002a8:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001002af:	80 ff ff 
ffff8000001002b2:	ff d0                	call   *%rax
      acquiresleep(&b->lock);
ffff8000001002b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002b8:	48 83 c0 10          	add    $0x10,%rax
ffff8000001002bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001002bf:	48 b8 4a 7a 10 00 00 	movabs $0xffff800000107a4a,%rax
ffff8000001002c6:	80 ff ff 
ffff8000001002c9:	ff d0                	call   *%rax
      return b;
ffff8000001002cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002cf:	e9 f6 00 00 00       	jmp    ffff8000001003ca <bget+0x19c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffff8000001002d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001002d8:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff8000001002df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001002e3:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff8000001002ea:	80 ff ff 
ffff8000001002ed:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001002f1:	0f 85 75 ff ff ff    	jne    ffff80000010026c <bget+0x3e>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff8000001002f7:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001002fe:	80 ff ff 
ffff800000100301:	48 8b 80 a0 51 00 00 	mov    0x51a0(%rax),%rax
ffff800000100308:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010030c:	e9 8c 00 00 00       	jmp    ffff80000010039d <bget+0x16f>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
ffff800000100311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100315:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff80000010031b:	85 c0                	test   %eax,%eax
ffff80000010031d:	75 6f                	jne    ffff80000010038e <bget+0x160>
ffff80000010031f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100323:	8b 00                	mov    (%rax),%eax
ffff800000100325:	83 e0 04             	and    $0x4,%eax
ffff800000100328:	85 c0                	test   %eax,%eax
ffff80000010032a:	75 62                	jne    ffff80000010038e <bget+0x160>
      b->dev = dev;
ffff80000010032c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100330:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000100333:	89 50 04             	mov    %edx,0x4(%rax)
      b->blockno = blockno;
ffff800000100336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010033a:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff80000010033d:	89 50 08             	mov    %edx,0x8(%rax)
      b->flags = 0;
ffff800000100340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100344:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
      b->refcnt = 1;
ffff80000010034a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010034e:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%rax)
ffff800000100355:	00 00 00 
      release(&bcache.lock);
ffff800000100358:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010035f:	80 ff ff 
ffff800000100362:	48 89 c7             	mov    %rax,%rdi
ffff800000100365:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010036c:	80 ff ff 
ffff80000010036f:	ff d0                	call   *%rax
      acquiresleep(&b->lock);
ffff800000100371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100375:	48 83 c0 10          	add    $0x10,%rax
ffff800000100379:	48 89 c7             	mov    %rax,%rdi
ffff80000010037c:	48 b8 4a 7a 10 00 00 	movabs $0xffff800000107a4a,%rax
ffff800000100383:	80 ff ff 
ffff800000100386:	ff d0                	call   *%rax
      return b;
ffff800000100388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010038c:	eb 3c                	jmp    ffff8000001003ca <bget+0x19c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffff80000010038e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100392:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff800000100399:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010039d:	48 b8 08 31 11 00 00 	movabs $0xffff800000113108,%rax
ffff8000001003a4:	80 ff ff 
ffff8000001003a7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001003ab:	0f 85 60 ff ff ff    	jne    ffff800000100311 <bget+0xe3>
    }
  }
  panic("bget: no buffers");
ffff8000001003b1:	48 b8 56 c7 10 00 00 	movabs $0xffff80000010c756,%rax
ffff8000001003b8:	80 ff ff 
ffff8000001003bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001003be:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001003c5:	80 ff ff 
ffff8000001003c8:	ff d0                	call   *%rax
}
ffff8000001003ca:	c9                   	leave
ffff8000001003cb:	c3                   	ret

ffff8000001003cc <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
ffff8000001003cc:	55                   	push   %rbp
ffff8000001003cd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001003d0:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001003d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001003d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  b = bget(dev, blockno);
ffff8000001003da:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff8000001003dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001003e0:	89 d6                	mov    %edx,%esi
ffff8000001003e2:	89 c7                	mov    %eax,%edi
ffff8000001003e4:	48 b8 2e 02 10 00 00 	movabs $0xffff80000010022e,%rax
ffff8000001003eb:	80 ff ff 
ffff8000001003ee:	ff d0                	call   *%rax
ffff8000001003f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!(b->flags & B_VALID)) {
ffff8000001003f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001003f8:	8b 00                	mov    (%rax),%eax
ffff8000001003fa:	83 e0 02             	and    $0x2,%eax
ffff8000001003fd:	85 c0                	test   %eax,%eax
ffff8000001003ff:	75 13                	jne    ffff800000100414 <bread+0x48>
    iderw(b);
ffff800000100401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100405:	48 89 c7             	mov    %rax,%rdi
ffff800000100408:	48 b8 bb 3c 10 00 00 	movabs $0xffff800000103cbb,%rax
ffff80000010040f:	80 ff ff 
ffff800000100412:	ff d0                	call   *%rax
  }
  return b;
ffff800000100414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000100418:	c9                   	leave
ffff800000100419:	c3                   	ret

ffff80000010041a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
ffff80000010041a:	55                   	push   %rbp
ffff80000010041b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010041e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100422:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff800000100426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010042a:	48 83 c0 10          	add    $0x10,%rax
ffff80000010042e:	48 89 c7             	mov    %rax,%rdi
ffff800000100431:	48 b8 35 7b 10 00 00 	movabs $0xffff800000107b35,%rax
ffff800000100438:	80 ff ff 
ffff80000010043b:	ff d0                	call   *%rax
ffff80000010043d:	85 c0                	test   %eax,%eax
ffff80000010043f:	75 19                	jne    ffff80000010045a <bwrite+0x40>
    panic("bwrite");
ffff800000100441:	48 b8 67 c7 10 00 00 	movabs $0xffff80000010c767,%rax
ffff800000100448:	80 ff ff 
ffff80000010044b:	48 89 c7             	mov    %rax,%rdi
ffff80000010044e:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000100455:	80 ff ff 
ffff800000100458:	ff d0                	call   *%rax
  b->flags |= B_DIRTY;
ffff80000010045a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010045e:	8b 00                	mov    (%rax),%eax
ffff800000100460:	83 c8 04             	or     $0x4,%eax
ffff800000100463:	89 c2                	mov    %eax,%edx
ffff800000100465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100469:	89 10                	mov    %edx,(%rax)
  iderw(b);
ffff80000010046b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010046f:	48 89 c7             	mov    %rax,%rdi
ffff800000100472:	48 b8 bb 3c 10 00 00 	movabs $0xffff800000103cbb,%rax
ffff800000100479:	80 ff ff 
ffff80000010047c:	ff d0                	call   *%rax
}
ffff80000010047e:	90                   	nop
ffff80000010047f:	c9                   	leave
ffff800000100480:	c3                   	ret

ffff800000100481 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
ffff800000100481:	55                   	push   %rbp
ffff800000100482:	48 89 e5             	mov    %rsp,%rbp
ffff800000100485:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100489:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holdingsleep(&b->lock))
ffff80000010048d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100491:	48 83 c0 10          	add    $0x10,%rax
ffff800000100495:	48 89 c7             	mov    %rax,%rdi
ffff800000100498:	48 b8 35 7b 10 00 00 	movabs $0xffff800000107b35,%rax
ffff80000010049f:	80 ff ff 
ffff8000001004a2:	ff d0                	call   *%rax
ffff8000001004a4:	85 c0                	test   %eax,%eax
ffff8000001004a6:	75 19                	jne    ffff8000001004c1 <brelse+0x40>
    panic("brelse");
ffff8000001004a8:	48 b8 6e c7 10 00 00 	movabs $0xffff80000010c76e,%rax
ffff8000001004af:	80 ff ff 
ffff8000001004b2:	48 89 c7             	mov    %rax,%rdi
ffff8000001004b5:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001004bc:	80 ff ff 
ffff8000001004bf:	ff d0                	call   *%rax

  releasesleep(&b->lock);
ffff8000001004c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004c5:	48 83 c0 10          	add    $0x10,%rax
ffff8000001004c9:	48 89 c7             	mov    %rax,%rdi
ffff8000001004cc:	48 b8 d0 7a 10 00 00 	movabs $0xffff800000107ad0,%rax
ffff8000001004d3:	80 ff ff 
ffff8000001004d6:	ff d0                	call   *%rax

  acquire(&bcache.lock);
ffff8000001004d8:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001004df:	80 ff ff 
ffff8000001004e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001004e5:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff8000001004ec:	80 ff ff 
ffff8000001004ef:	ff d0                	call   *%rax
  b->refcnt--;
ffff8000001004f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001004f5:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff8000001004fb:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001004fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100502:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
  if (b->refcnt == 0) {
ffff800000100508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010050c:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000100512:	85 c0                	test   %eax,%eax
ffff800000100514:	0f 85 9c 00 00 00    	jne    ffff8000001005b6 <brelse+0x135>
    // no one is waiting for it.
    b->next->prev = b->prev;
ffff80000010051a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010051e:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff800000100525:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000100529:	48 8b 92 98 00 00 00 	mov    0x98(%rdx),%rdx
ffff800000100530:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    b->prev->next = b->next;
ffff800000100537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010053b:	48 8b 80 98 00 00 00 	mov    0x98(%rax),%rax
ffff800000100542:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000100546:	48 8b 92 a0 00 00 00 	mov    0xa0(%rdx),%rdx
ffff80000010054d:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->next = bcache.head.next;
ffff800000100554:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010055b:	80 ff ff 
ffff80000010055e:	48 8b 90 a8 51 00 00 	mov    0x51a8(%rax),%rdx
ffff800000100565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100569:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    b->prev = &bcache.head;
ffff800000100570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100574:	48 b9 08 31 11 00 00 	movabs $0xffff800000113108,%rcx
ffff80000010057b:	80 ff ff 
ffff80000010057e:	48 89 88 98 00 00 00 	mov    %rcx,0x98(%rax)
    bcache.head.next->prev = b;
ffff800000100585:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff80000010058c:	80 ff ff 
ffff80000010058f:	48 8b 80 a8 51 00 00 	mov    0x51a8(%rax),%rax
ffff800000100596:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010059a:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    bcache.head.next = b;
ffff8000001005a1:	48 ba 00 e0 10 00 00 	movabs $0xffff80000010e000,%rdx
ffff8000001005a8:	80 ff ff 
ffff8000001005ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001005af:	48 89 82 a8 51 00 00 	mov    %rax,0x51a8(%rdx)
  }

  release(&bcache.lock);
ffff8000001005b6:	48 b8 00 e0 10 00 00 	movabs $0xffff80000010e000,%rax
ffff8000001005bd:	80 ff ff 
ffff8000001005c0:	48 89 c7             	mov    %rax,%rdi
ffff8000001005c3:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001005ca:	80 ff ff 
ffff8000001005cd:	ff d0                	call   *%rax
}
ffff8000001005cf:	90                   	nop
ffff8000001005d0:	c9                   	leave
ffff8000001005d1:	c3                   	ret

ffff8000001005d2 <inb>:
#ifndef X86
#define X86

static inline uchar
inb(ushort port)
{
ffff8000001005d2:	55                   	push   %rbp
ffff8000001005d3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005d6:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001005da:	89 f8                	mov    %edi,%eax
ffff8000001005dc:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001005e0:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001005e4:	89 c2                	mov    %eax,%edx
ffff8000001005e6:	ec                   	in     (%dx),%al
ffff8000001005e7:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff8000001005ea:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff8000001005ee:	c9                   	leave
ffff8000001005ef:	c3                   	ret

ffff8000001005f0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffff8000001005f0:	55                   	push   %rbp
ffff8000001005f1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001005f4:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001005f8:	89 fa                	mov    %edi,%edx
ffff8000001005fa:	89 f0                	mov    %esi,%eax
ffff8000001005fc:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff800000100600:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000100603:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000100607:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010060b:	ee                   	out    %al,(%dx)
}
ffff80000010060c:	90                   	nop
ffff80000010060d:	c9                   	leave
ffff80000010060e:	c3                   	ret

ffff80000010060f <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
ffff80000010060f:	55                   	push   %rbp
ffff800000100610:	48 89 e5             	mov    %rsp,%rbp
ffff800000100613:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100617:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010061b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  volatile ushort pd[5];
  addr_t addr = (addr_t)p;
ffff80000010061e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000100622:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  pd[0] = size-1;
ffff800000100626:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000100629:	83 e8 01             	sub    $0x1,%eax
ffff80000010062c:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000100630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100634:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000100638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010063c:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000100640:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000100644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100648:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010064c:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000100650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000100654:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000100658:	66 89 45 f6          	mov    %ax,-0xa(%rbp)

  asm volatile("lidt (%0)" : : "r" (pd));
ffff80000010065c:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000100660:	0f 01 18             	lidt   (%rax)
}
ffff800000100663:	90                   	nop
ffff800000100664:	c9                   	leave
ffff800000100665:	c3                   	ret

ffff800000100666 <cli>:
  return eflags;
}

static inline void
cli(void)
{
ffff800000100666:	55                   	push   %rbp
ffff800000100667:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff80000010066a:	fa                   	cli
}
ffff80000010066b:	90                   	nop
ffff80000010066c:	5d                   	pop    %rbp
ffff80000010066d:	c3                   	ret

ffff80000010066e <hlt>:
  asm volatile("sti");
}

static inline void
hlt(void)
{
ffff80000010066e:	55                   	push   %rbp
ffff80000010066f:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff800000100672:	f4                   	hlt
}
ffff800000100673:	90                   	nop
ffff800000100674:	5d                   	pop    %rbp
ffff800000100675:	c3                   	ret

ffff800000100676 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(addr_t x)
{
ffff800000100676:	55                   	push   %rbp
ffff800000100677:	48 89 e5             	mov    %rsp,%rbp
ffff80000010067a:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010067e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff800000100682:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100689:	eb 30                	jmp    ffff8000001006bb <print_x64+0x45>
    consputc(digits[x >> (sizeof(addr_t) * 8 - 4)]);
ffff80000010068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010068f:	48 c1 e8 3c          	shr    $0x3c,%rax
ffff800000100693:	48 ba 00 d0 10 00 00 	movabs $0xffff80000010d000,%rdx
ffff80000010069a:	80 ff ff 
ffff80000010069d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001006a1:	0f be c0             	movsbl %al,%eax
ffff8000001006a4:	89 c7                	mov    %eax,%edi
ffff8000001006a6:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff8000001006ad:	80 ff ff 
ffff8000001006b0:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
ffff8000001006b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001006b6:	48 c1 65 e8 04       	shlq   $0x4,-0x18(%rbp)
ffff8000001006bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001006be:	83 f8 0f             	cmp    $0xf,%eax
ffff8000001006c1:	76 c8                	jbe    ffff80000010068b <print_x64+0x15>
}
ffff8000001006c3:	90                   	nop
ffff8000001006c4:	90                   	nop
ffff8000001006c5:	c9                   	leave
ffff8000001006c6:	c3                   	ret

ffff8000001006c7 <print_x32>:

  static void
print_x32(uint x)
{
ffff8000001006c7:	55                   	push   %rbp
ffff8000001006c8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001006cb:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001006cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff8000001006d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001006d9:	eb 31                	jmp    ffff80000010070c <print_x32+0x45>
    consputc(digits[x >> (sizeof(uint) * 8 - 4)]);
ffff8000001006db:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001006de:	c1 e8 1c             	shr    $0x1c,%eax
ffff8000001006e1:	89 c2                	mov    %eax,%edx
ffff8000001006e3:	48 b8 00 d0 10 00 00 	movabs $0xffff80000010d000,%rax
ffff8000001006ea:	80 ff ff 
ffff8000001006ed:	89 d2                	mov    %edx,%edx
ffff8000001006ef:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
ffff8000001006f3:	0f be c0             	movsbl %al,%eax
ffff8000001006f6:	89 c7                	mov    %eax,%edi
ffff8000001006f8:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff8000001006ff:	80 ff ff 
ffff800000100702:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
ffff800000100704:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100708:	c1 65 ec 04          	shll   $0x4,-0x14(%rbp)
ffff80000010070c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010070f:	83 f8 07             	cmp    $0x7,%eax
ffff800000100712:	76 c7                	jbe    ffff8000001006db <print_x32+0x14>
}
ffff800000100714:	90                   	nop
ffff800000100715:	90                   	nop
ffff800000100716:	c9                   	leave
ffff800000100717:	c3                   	ret

ffff800000100718 <print_d>:

  static void
print_d(int v)
{
ffff800000100718:	55                   	push   %rbp
ffff800000100719:	48 89 e5             	mov    %rsp,%rbp
ffff80000010071c:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000100720:	89 7d dc             	mov    %edi,-0x24(%rbp)
  char buf[16];
  int64 x = v;
ffff800000100723:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000100726:	48 98                	cltq
ffff800000100728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
ffff80000010072c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000100730:	79 04                	jns    ffff800000100736 <print_d+0x1e>
    x = -x;
ffff800000100732:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
ffff800000100736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
ffff80000010073d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000100741:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff800000100748:	66 66 66 
ffff80000010074b:	48 89 c8             	mov    %rcx,%rax
ffff80000010074e:	48 f7 ea             	imul   %rdx
ffff800000100751:	48 c1 fa 02          	sar    $0x2,%rdx
ffff800000100755:	48 89 c8             	mov    %rcx,%rax
ffff800000100758:	48 c1 f8 3f          	sar    $0x3f,%rax
ffff80000010075c:	48 29 c2             	sub    %rax,%rdx
ffff80000010075f:	48 89 d0             	mov    %rdx,%rax
ffff800000100762:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000100766:	48 01 d0             	add    %rdx,%rax
ffff800000100769:	48 01 c0             	add    %rax,%rax
ffff80000010076c:	48 29 c1             	sub    %rax,%rcx
ffff80000010076f:	48 89 ca             	mov    %rcx,%rdx
ffff800000100772:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000100775:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000100778:	89 4d f4             	mov    %ecx,-0xc(%rbp)
ffff80000010077b:	48 b9 00 d0 10 00 00 	movabs $0xffff80000010d000,%rcx
ffff800000100782:	80 ff ff 
ffff800000100785:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
ffff800000100789:	48 98                	cltq
ffff80000010078b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
ffff80000010078f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000100793:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
ffff80000010079a:	66 66 66 
ffff80000010079d:	48 89 c8             	mov    %rcx,%rax
ffff8000001007a0:	48 f7 ea             	imul   %rdx
ffff8000001007a3:	48 89 d0             	mov    %rdx,%rax
ffff8000001007a6:	48 c1 f8 02          	sar    $0x2,%rax
ffff8000001007aa:	48 c1 f9 3f          	sar    $0x3f,%rcx
ffff8000001007ae:	48 89 ca             	mov    %rcx,%rdx
ffff8000001007b1:	48 29 d0             	sub    %rdx,%rax
ffff8000001007b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
ffff8000001007b8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001007bd:	0f 85 7a ff ff ff    	jne    ffff80000010073d <print_d+0x25>

  if (v < 0)
ffff8000001007c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff8000001007c7:	79 2d                	jns    ffff8000001007f6 <print_d+0xde>
    buf[i++] = '-';
ffff8000001007c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007cc:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001007cf:	89 55 f4             	mov    %edx,-0xc(%rbp)
ffff8000001007d2:	48 98                	cltq
ffff8000001007d4:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
ffff8000001007d9:	eb 1b                	jmp    ffff8000001007f6 <print_d+0xde>
    consputc(buf[i]);
ffff8000001007db:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001007de:	48 98                	cltq
ffff8000001007e0:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
ffff8000001007e5:	0f be c0             	movsbl %al,%eax
ffff8000001007e8:	89 c7                	mov    %eax,%edi
ffff8000001007ea:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff8000001007f1:	80 ff ff 
ffff8000001007f4:	ff d0                	call   *%rax
  while (--i >= 0)
ffff8000001007f6:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
ffff8000001007fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff8000001007fe:	79 db                	jns    ffff8000001007db <print_d+0xc3>
}
ffff800000100800:	90                   	nop
ffff800000100801:	90                   	nop
ffff800000100802:	c9                   	leave
ffff800000100803:	c3                   	ret

ffff800000100804 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
  void
cprintf(char *fmt, ...)
{
ffff800000100804:	55                   	push   %rbp
ffff800000100805:	48 89 e5             	mov    %rsp,%rbp
ffff800000100808:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
ffff80000010080f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
ffff800000100816:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
ffff80000010081d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
ffff800000100824:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff80000010082b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff800000100832:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff800000100839:	84 c0                	test   %al,%al
ffff80000010083b:	74 20                	je     ffff80000010085d <cprintf+0x59>
ffff80000010083d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff800000100841:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff800000100845:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff800000100849:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff80000010084d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff800000100851:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff800000100855:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff800000100859:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c, locking;
  char *s;

  va_start(ap, fmt);
ffff80000010085d:	c7 85 20 ff ff ff 08 	movl   $0x8,-0xe0(%rbp)
ffff800000100864:	00 00 00 
ffff800000100867:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
ffff80000010086e:	00 00 00 
ffff800000100871:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff800000100875:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
ffff80000010087c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff800000100883:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)

  locking = cons.locking;
ffff80000010088a:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff800000100891:	80 ff ff 
ffff800000100894:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000100897:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
  if (locking)
ffff80000010089d:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff8000001008a4:	74 19                	je     ffff8000001008bf <cprintf+0xbb>
    acquire(&cons.lock);
ffff8000001008a6:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff8000001008ad:	80 ff ff 
ffff8000001008b0:	48 89 c7             	mov    %rax,%rdi
ffff8000001008b3:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff8000001008ba:	80 ff ff 
ffff8000001008bd:	ff d0                	call   *%rax

  if (fmt == 0)
ffff8000001008bf:	48 83 bd 18 ff ff ff 	cmpq   $0x0,-0xe8(%rbp)
ffff8000001008c6:	00 
ffff8000001008c7:	75 19                	jne    ffff8000001008e2 <cprintf+0xde>
    panic("null fmt");
ffff8000001008c9:	48 b8 75 c7 10 00 00 	movabs $0xffff80000010c775,%rax
ffff8000001008d0:	80 ff ff 
ffff8000001008d3:	48 89 c7             	mov    %rax,%rdi
ffff8000001008d6:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001008dd:	80 ff ff 
ffff8000001008e0:	ff d0                	call   *%rax

  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff8000001008e2:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff8000001008e9:	00 00 00 
ffff8000001008ec:	e9 a0 02 00 00       	jmp    ffff800000100b91 <cprintf+0x38d>
    if (c != '%') {
ffff8000001008f1:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff8000001008f8:	74 19                	je     ffff800000100913 <cprintf+0x10f>
      consputc(c);
ffff8000001008fa:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100900:	89 c7                	mov    %eax,%edi
ffff800000100902:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff800000100909:	80 ff ff 
ffff80000010090c:	ff d0                	call   *%rax
      continue;
ffff80000010090e:	e9 77 02 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    }
    c = fmt[++i] & 0xff;
ffff800000100913:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff80000010091a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100920:	48 63 d0             	movslq %eax,%rdx
ffff800000100923:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff80000010092a:	48 01 d0             	add    %rdx,%rax
ffff80000010092d:	0f b6 00             	movzbl (%rax),%eax
ffff800000100930:	0f be c0             	movsbl %al,%eax
ffff800000100933:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000100938:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
    if (c == 0)
ffff80000010093e:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100945:	0f 84 79 02 00 00    	je     ffff800000100bc4 <cprintf+0x3c0>
      break;
    switch(c) {
ffff80000010094b:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff800000100952:	0f 84 b0 00 00 00    	je     ffff800000100a08 <cprintf+0x204>
ffff800000100958:	83 bd 38 ff ff ff 78 	cmpl   $0x78,-0xc8(%rbp)
ffff80000010095f:	0f 8f ff 01 00 00    	jg     ffff800000100b64 <cprintf+0x360>
ffff800000100965:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff80000010096c:	0f 84 42 01 00 00    	je     ffff800000100ab4 <cprintf+0x2b0>
ffff800000100972:	83 bd 38 ff ff ff 73 	cmpl   $0x73,-0xc8(%rbp)
ffff800000100979:	0f 8f e5 01 00 00    	jg     ffff800000100b64 <cprintf+0x360>
ffff80000010097f:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff800000100986:	0f 84 d1 00 00 00    	je     ffff800000100a5d <cprintf+0x259>
ffff80000010098c:	83 bd 38 ff ff ff 70 	cmpl   $0x70,-0xc8(%rbp)
ffff800000100993:	0f 8f cb 01 00 00    	jg     ffff800000100b64 <cprintf+0x360>
ffff800000100999:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffff8000001009a0:	0f 84 ab 01 00 00    	je     ffff800000100b51 <cprintf+0x34d>
ffff8000001009a6:	83 bd 38 ff ff ff 64 	cmpl   $0x64,-0xc8(%rbp)
ffff8000001009ad:	0f 85 b1 01 00 00    	jne    ffff800000100b64 <cprintf+0x360>
    case 'd':
      print_d(va_arg(ap, int));
ffff8000001009b3:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff8000001009b9:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001009bc:	77 23                	ja     ffff8000001009e1 <cprintf+0x1dd>
ffff8000001009be:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff8000001009c5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009cb:	89 d2                	mov    %edx,%edx
ffff8000001009cd:	48 01 d0             	add    %rdx,%rax
ffff8000001009d0:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff8000001009d6:	83 c2 08             	add    $0x8,%edx
ffff8000001009d9:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff8000001009df:	eb 12                	jmp    ffff8000001009f3 <cprintf+0x1ef>
ffff8000001009e1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff8000001009e8:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001009ec:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff8000001009f3:	8b 00                	mov    (%rax),%eax
ffff8000001009f5:	89 c7                	mov    %eax,%edi
ffff8000001009f7:	48 b8 18 07 10 00 00 	movabs $0xffff800000100718,%rax
ffff8000001009fe:	80 ff ff 
ffff800000100a01:	ff d0                	call   *%rax
      break;
ffff800000100a03:	e9 82 01 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    case 'x':
      print_x32(va_arg(ap, uint));
ffff800000100a08:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a0e:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a11:	77 23                	ja     ffff800000100a36 <cprintf+0x232>
ffff800000100a13:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a1a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a20:	89 d2                	mov    %edx,%edx
ffff800000100a22:	48 01 d0             	add    %rdx,%rax
ffff800000100a25:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a2b:	83 c2 08             	add    $0x8,%edx
ffff800000100a2e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a34:	eb 12                	jmp    ffff800000100a48 <cprintf+0x244>
ffff800000100a36:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100a3d:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100a41:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a48:	8b 00                	mov    (%rax),%eax
ffff800000100a4a:	89 c7                	mov    %eax,%edi
ffff800000100a4c:	48 b8 c7 06 10 00 00 	movabs $0xffff8000001006c7,%rax
ffff800000100a53:	80 ff ff 
ffff800000100a56:	ff d0                	call   *%rax
      break;
ffff800000100a58:	e9 2d 01 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    case 'p':
      print_x64(va_arg(ap, addr_t));
ffff800000100a5d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100a63:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100a66:	77 23                	ja     ffff800000100a8b <cprintf+0x287>
ffff800000100a68:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100a6f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a75:	89 d2                	mov    %edx,%edx
ffff800000100a77:	48 01 d0             	add    %rdx,%rax
ffff800000100a7a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100a80:	83 c2 08             	add    $0x8,%edx
ffff800000100a83:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100a89:	eb 12                	jmp    ffff800000100a9d <cprintf+0x299>
ffff800000100a8b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100a92:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100a96:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100a9d:	48 8b 00             	mov    (%rax),%rax
ffff800000100aa0:	48 89 c7             	mov    %rax,%rdi
ffff800000100aa3:	48 b8 76 06 10 00 00 	movabs $0xffff800000100676,%rax
ffff800000100aaa:	80 ff ff 
ffff800000100aad:	ff d0                	call   *%rax
      break;
ffff800000100aaf:	e9 d6 00 00 00       	jmp    ffff800000100b8a <cprintf+0x386>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
ffff800000100ab4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffff800000100aba:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000100abd:	77 23                	ja     ffff800000100ae2 <cprintf+0x2de>
ffff800000100abf:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffff800000100ac6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100acc:	89 d2                	mov    %edx,%edx
ffff800000100ace:	48 01 d0             	add    %rdx,%rax
ffff800000100ad1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffff800000100ad7:	83 c2 08             	add    $0x8,%edx
ffff800000100ada:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffff800000100ae0:	eb 12                	jmp    ffff800000100af4 <cprintf+0x2f0>
ffff800000100ae2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff800000100ae9:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000100aed:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffff800000100af4:	48 8b 00             	mov    (%rax),%rax
ffff800000100af7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
ffff800000100afe:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
ffff800000100b05:	00 
ffff800000100b06:	75 39                	jne    ffff800000100b41 <cprintf+0x33d>
        s = "(null)";
ffff800000100b08:	48 b8 7e c7 10 00 00 	movabs $0xffff80000010c77e,%rax
ffff800000100b0f:	80 ff ff 
ffff800000100b12:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
ffff800000100b19:	eb 26                	jmp    ffff800000100b41 <cprintf+0x33d>
        consputc(*(s++));
ffff800000100b1b:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b22:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000100b26:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
ffff800000100b2d:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b30:	0f be c0             	movsbl %al,%eax
ffff800000100b33:	89 c7                	mov    %eax,%edi
ffff800000100b35:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff800000100b3c:	80 ff ff 
ffff800000100b3f:	ff d0                	call   *%rax
      while (*s)
ffff800000100b41:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffff800000100b48:	0f b6 00             	movzbl (%rax),%eax
ffff800000100b4b:	84 c0                	test   %al,%al
ffff800000100b4d:	75 cc                	jne    ffff800000100b1b <cprintf+0x317>
      break;
ffff800000100b4f:	eb 39                	jmp    ffff800000100b8a <cprintf+0x386>
    case '%':
      consputc('%');
ffff800000100b51:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b56:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff800000100b5d:	80 ff ff 
ffff800000100b60:	ff d0                	call   *%rax
      break;
ffff800000100b62:	eb 26                	jmp    ffff800000100b8a <cprintf+0x386>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
ffff800000100b64:	bf 25 00 00 00       	mov    $0x25,%edi
ffff800000100b69:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff800000100b70:	80 ff ff 
ffff800000100b73:	ff d0                	call   *%rax
      consputc(c);
ffff800000100b75:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffff800000100b7b:	89 c7                	mov    %eax,%edi
ffff800000100b7d:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff800000100b84:	80 ff ff 
ffff800000100b87:	ff d0                	call   *%rax
      break;
ffff800000100b89:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
ffff800000100b8a:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff800000100b91:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000100b97:	48 63 d0             	movslq %eax,%rdx
ffff800000100b9a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffff800000100ba1:	48 01 d0             	add    %rdx,%rax
ffff800000100ba4:	0f b6 00             	movzbl (%rax),%eax
ffff800000100ba7:	0f be c0             	movsbl %al,%eax
ffff800000100baa:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000100baf:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
ffff800000100bb5:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffff800000100bbc:	0f 85 2f fd ff ff    	jne    ffff8000001008f1 <cprintf+0xed>
ffff800000100bc2:	eb 01                	jmp    ffff800000100bc5 <cprintf+0x3c1>
      break;
ffff800000100bc4:	90                   	nop
    }
  }

  if (locking)
ffff800000100bc5:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffff800000100bcc:	74 19                	je     ffff800000100be7 <cprintf+0x3e3>
    release(&cons.lock);
ffff800000100bce:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff800000100bd5:	80 ff ff 
ffff800000100bd8:	48 89 c7             	mov    %rax,%rdi
ffff800000100bdb:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000100be2:	80 ff ff 
ffff800000100be5:	ff d0                	call   *%rax
}
ffff800000100be7:	90                   	nop
ffff800000100be8:	c9                   	leave
ffff800000100be9:	c3                   	ret

ffff800000100bea <panic>:

__attribute__((noreturn))
  void
panic(char *s)
{
ffff800000100bea:	55                   	push   %rbp
ffff800000100beb:	48 89 e5             	mov    %rsp,%rbp
ffff800000100bee:	48 83 ec 70          	sub    $0x70,%rsp
ffff800000100bf2:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  int i;
  addr_t pcs[10];

  cli();
ffff800000100bf6:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100bfd:	80 ff ff 
ffff800000100c00:	ff d0                	call   *%rax
  cons.locking = 0;
ffff800000100c02:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff800000100c09:	80 ff ff 
ffff800000100c0c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  cprintf("cpu%d: panic: ", cpu->id);
ffff800000100c13:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000100c1a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000100c1e:	0f b6 00             	movzbl (%rax),%eax
ffff800000100c21:	0f b6 c0             	movzbl %al,%eax
ffff800000100c24:	48 ba 85 c7 10 00 00 	movabs $0xffff80000010c785,%rdx
ffff800000100c2b:	80 ff ff 
ffff800000100c2e:	89 c6                	mov    %eax,%esi
ffff800000100c30:	48 89 d7             	mov    %rdx,%rdi
ffff800000100c33:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c38:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100c3f:	80 ff ff 
ffff800000100c42:	ff d2                	call   *%rdx
  cprintf(s);
ffff800000100c44:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffff800000100c48:	48 89 c7             	mov    %rax,%rdi
ffff800000100c4b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c50:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100c57:	80 ff ff 
ffff800000100c5a:	ff d2                	call   *%rdx
  cprintf("\n");
ffff800000100c5c:	48 b8 94 c7 10 00 00 	movabs $0xffff80000010c794,%rax
ffff800000100c63:	80 ff ff 
ffff800000100c66:	48 89 c7             	mov    %rax,%rdi
ffff800000100c69:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100c6e:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100c75:	80 ff ff 
ffff800000100c78:	ff d2                	call   *%rdx
  getcallerpcs(&s, pcs);
ffff800000100c7a:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
ffff800000100c7e:	48 8d 45 98          	lea    -0x68(%rbp),%rax
ffff800000100c82:	48 89 d6             	mov    %rdx,%rsi
ffff800000100c85:	48 89 c7             	mov    %rax,%rdi
ffff800000100c88:	48 b8 13 7d 10 00 00 	movabs $0xffff800000107d13,%rax
ffff800000100c8f:	80 ff ff 
ffff800000100c92:	ff d0                	call   *%rax
  for (i=0; i<10; i++)
ffff800000100c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000100c9b:	eb 2f                	jmp    ffff800000100ccc <panic+0xe2>
    cprintf(" %p\n", pcs[i]);
ffff800000100c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100ca0:	48 98                	cltq
ffff800000100ca2:	48 8b 44 c5 a0       	mov    -0x60(%rbp,%rax,8),%rax
ffff800000100ca7:	48 ba 96 c7 10 00 00 	movabs $0xffff80000010c796,%rdx
ffff800000100cae:	80 ff ff 
ffff800000100cb1:	48 89 c6             	mov    %rax,%rsi
ffff800000100cb4:	48 89 d7             	mov    %rdx,%rdi
ffff800000100cb7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000100cbc:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000100cc3:	80 ff ff 
ffff800000100cc6:	ff d2                	call   *%rdx
  for (i=0; i<10; i++)
ffff800000100cc8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000100ccc:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000100cd0:	7e cb                	jle    ffff800000100c9d <panic+0xb3>
  panicked = 1; // freeze other CPU
ffff800000100cd2:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100cd9:	80 ff ff 
ffff800000100cdc:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  for (;;)
    hlt();
ffff800000100ce2:	48 b8 6e 06 10 00 00 	movabs $0xffff80000010066e,%rax
ffff800000100ce9:	80 ff ff 
ffff800000100cec:	ff d0                	call   *%rax
ffff800000100cee:	eb f2                	jmp    ffff800000100ce2 <panic+0xf8>

ffff800000100cf0 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

  static void
cgaputc(int c)
{
ffff800000100cf0:	55                   	push   %rbp
ffff800000100cf1:	48 89 e5             	mov    %rsp,%rbp
ffff800000100cf4:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100cf8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
ffff800000100cfb:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100d00:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d05:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100d0c:	80 ff ff 
ffff800000100d0f:	ff d0                	call   *%rax
  pos = inb(CRTPORT+1) << 8;
ffff800000100d11:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d16:	48 b8 d2 05 10 00 00 	movabs $0xffff8000001005d2,%rax
ffff800000100d1d:	80 ff ff 
ffff800000100d20:	ff d0                	call   *%rax
ffff800000100d22:	0f b6 c0             	movzbl %al,%eax
ffff800000100d25:	c1 e0 08             	shl    $0x8,%eax
ffff800000100d28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  outb(CRTPORT, 15);
ffff800000100d2b:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100d30:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100d35:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100d3c:	80 ff ff 
ffff800000100d3f:	ff d0                	call   *%rax
  pos |= inb(CRTPORT+1);
ffff800000100d41:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100d46:	48 b8 d2 05 10 00 00 	movabs $0xffff8000001005d2,%rax
ffff800000100d4d:	80 ff ff 
ffff800000100d50:	ff d0                	call   *%rax
ffff800000100d52:	0f b6 c0             	movzbl %al,%eax
ffff800000100d55:	09 45 fc             	or     %eax,-0x4(%rbp)

  if (c == '\n')
ffff800000100d58:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
ffff800000100d5c:	75 37                	jne    ffff800000100d95 <cgaputc+0xa5>
    pos += 80 - pos%80;
ffff800000100d5e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100d61:	48 63 c1             	movslq %ecx,%rax
ffff800000100d64:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
ffff800000100d6b:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000100d6f:	89 c2                	mov    %eax,%edx
ffff800000100d71:	c1 fa 05             	sar    $0x5,%edx
ffff800000100d74:	89 c8                	mov    %ecx,%eax
ffff800000100d76:	c1 f8 1f             	sar    $0x1f,%eax
ffff800000100d79:	29 c2                	sub    %eax,%edx
ffff800000100d7b:	89 d0                	mov    %edx,%eax
ffff800000100d7d:	c1 e0 02             	shl    $0x2,%eax
ffff800000100d80:	01 d0                	add    %edx,%eax
ffff800000100d82:	c1 e0 04             	shl    $0x4,%eax
ffff800000100d85:	29 c1                	sub    %eax,%ecx
ffff800000100d87:	89 ca                	mov    %ecx,%edx
ffff800000100d89:	b8 50 00 00 00       	mov    $0x50,%eax
ffff800000100d8e:	29 d0                	sub    %edx,%eax
ffff800000100d90:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff800000100d93:	eb 43                	jmp    ffff800000100dd8 <cgaputc+0xe8>
  else if (c == BACKSPACE) {
ffff800000100d95:	81 7d ec 00 01 00 00 	cmpl   $0x100,-0x14(%rbp)
ffff800000100d9c:	75 0c                	jne    ffff800000100daa <cgaputc+0xba>
    if (pos > 0) --pos;
ffff800000100d9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000100da2:	7e 34                	jle    ffff800000100dd8 <cgaputc+0xe8>
ffff800000100da4:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
ffff800000100da8:	eb 2e                	jmp    ffff800000100dd8 <cgaputc+0xe8>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // gray on black
ffff800000100daa:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000100dad:	0f b6 c0             	movzbl %al,%eax
ffff800000100db0:	80 cc 07             	or     $0x7,%ah
ffff800000100db3:	89 c6                	mov    %eax,%esi
ffff800000100db5:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100dbc:	80 ff ff 
ffff800000100dbf:	48 8b 08             	mov    (%rax),%rcx
ffff800000100dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100dc5:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000100dc8:	89 55 fc             	mov    %edx,-0x4(%rbp)
ffff800000100dcb:	48 98                	cltq
ffff800000100dcd:	48 01 c0             	add    %rax,%rax
ffff800000100dd0:	48 01 c8             	add    %rcx,%rax
ffff800000100dd3:	89 f2                	mov    %esi,%edx
ffff800000100dd5:	66 89 10             	mov    %dx,(%rax)

  if ((pos/80) >= 24){  // Scroll up.
ffff800000100dd8:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%rbp)
ffff800000100ddf:	7e 74                	jle    ffff800000100e55 <cgaputc+0x165>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
ffff800000100de1:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100de8:	80 ff ff 
ffff800000100deb:	48 8b 00             	mov    (%rax),%rax
ffff800000100dee:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff800000100df5:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100dfc:	80 ff ff 
ffff800000100dff:	48 8b 00             	mov    (%rax),%rax
ffff800000100e02:	ba 60 0e 00 00       	mov    $0xe60,%edx
ffff800000100e07:	48 89 ce             	mov    %rcx,%rsi
ffff800000100e0a:	48 89 c7             	mov    %rax,%rdi
ffff800000100e0d:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff800000100e14:	80 ff ff 
ffff800000100e17:	ff d0                	call   *%rax
    pos -= 80;
ffff800000100e19:	83 6d fc 50          	subl   $0x50,-0x4(%rbp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
ffff800000100e1d:	b8 80 07 00 00       	mov    $0x780,%eax
ffff800000100e22:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000100e25:	8d 14 00             	lea    (%rax,%rax,1),%edx
ffff800000100e28:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100e2f:	80 ff ff 
ffff800000100e32:	48 8b 00             	mov    (%rax),%rax
ffff800000100e35:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000100e38:	48 63 c9             	movslq %ecx,%rcx
ffff800000100e3b:	48 01 c9             	add    %rcx,%rcx
ffff800000100e3e:	48 01 c8             	add    %rcx,%rax
ffff800000100e41:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100e46:	48 89 c7             	mov    %rax,%rdi
ffff800000100e49:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff800000100e50:	80 ff ff 
ffff800000100e53:	ff d0                	call   *%rax
  }

  outb(CRTPORT, 14);
ffff800000100e55:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000100e5a:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100e5f:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100e66:	80 ff ff 
ffff800000100e69:	ff d0                	call   *%rax
  outb(CRTPORT+1, pos>>8);
ffff800000100e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100e6e:	c1 f8 08             	sar    $0x8,%eax
ffff800000100e71:	0f b6 c0             	movzbl %al,%eax
ffff800000100e74:	89 c6                	mov    %eax,%esi
ffff800000100e76:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100e7b:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100e82:	80 ff ff 
ffff800000100e85:	ff d0                	call   *%rax
  outb(CRTPORT, 15);
ffff800000100e87:	be 0f 00 00 00       	mov    $0xf,%esi
ffff800000100e8c:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffff800000100e91:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100e98:	80 ff ff 
ffff800000100e9b:	ff d0                	call   *%rax
  outb(CRTPORT+1, pos);
ffff800000100e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100ea0:	0f b6 c0             	movzbl %al,%eax
ffff800000100ea3:	89 c6                	mov    %eax,%esi
ffff800000100ea5:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffff800000100eaa:	48 b8 f0 05 10 00 00 	movabs $0xffff8000001005f0,%rax
ffff800000100eb1:	80 ff ff 
ffff800000100eb4:	ff d0                	call   *%rax
  crt[pos] = ' ' | 0x0700;
ffff800000100eb6:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000100ebd:	80 ff ff 
ffff800000100ec0:	48 8b 00             	mov    (%rax),%rax
ffff800000100ec3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000100ec6:	48 63 d2             	movslq %edx,%rdx
ffff800000100ec9:	48 01 d2             	add    %rdx,%rdx
ffff800000100ecc:	48 01 d0             	add    %rdx,%rax
ffff800000100ecf:	66 c7 00 20 07       	movw   $0x720,(%rax)
}
ffff800000100ed4:	90                   	nop
ffff800000100ed5:	c9                   	leave
ffff800000100ed6:	c3                   	ret

ffff800000100ed7 <consputc>:

  void
consputc(int c)
{
ffff800000100ed7:	55                   	push   %rbp
ffff800000100ed8:	48 89 e5             	mov    %rsp,%rbp
ffff800000100edb:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000100edf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  if (panicked) {
ffff800000100ee2:	48 b8 b8 34 11 00 00 	movabs $0xffff8000001134b8,%rax
ffff800000100ee9:	80 ff ff 
ffff800000100eec:	8b 00                	mov    (%rax),%eax
ffff800000100eee:	85 c0                	test   %eax,%eax
ffff800000100ef0:	74 1a                	je     ffff800000100f0c <consputc+0x35>
    cli();
ffff800000100ef2:	48 b8 66 06 10 00 00 	movabs $0xffff800000100666,%rax
ffff800000100ef9:	80 ff ff 
ffff800000100efc:	ff d0                	call   *%rax
    for(;;)
      hlt();
ffff800000100efe:	48 b8 6e 06 10 00 00 	movabs $0xffff80000010066e,%rax
ffff800000100f05:	80 ff ff 
ffff800000100f08:	ff d0                	call   *%rax
ffff800000100f0a:	eb f2                	jmp    ffff800000100efe <consputc+0x27>
  }

  if (c == BACKSPACE) {
ffff800000100f0c:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
ffff800000100f13:	75 35                	jne    ffff800000100f4a <consputc+0x73>
    uartputc('\b'); uartputc(' '); uartputc('\b');
ffff800000100f15:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f1a:	48 b8 57 a7 10 00 00 	movabs $0xffff80000010a757,%rax
ffff800000100f21:	80 ff ff 
ffff800000100f24:	ff d0                	call   *%rax
ffff800000100f26:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000100f2b:	48 b8 57 a7 10 00 00 	movabs $0xffff80000010a757,%rax
ffff800000100f32:	80 ff ff 
ffff800000100f35:	ff d0                	call   *%rax
ffff800000100f37:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000100f3c:	48 b8 57 a7 10 00 00 	movabs $0xffff80000010a757,%rax
ffff800000100f43:	80 ff ff 
ffff800000100f46:	ff d0                	call   *%rax
ffff800000100f48:	eb 11                	jmp    ffff800000100f5b <consputc+0x84>
  } else
    uartputc(c);
ffff800000100f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f4d:	89 c7                	mov    %eax,%edi
ffff800000100f4f:	48 b8 57 a7 10 00 00 	movabs $0xffff80000010a757,%rax
ffff800000100f56:	80 ff ff 
ffff800000100f59:	ff d0                	call   *%rax
  cgaputc(c);
ffff800000100f5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000100f5e:	89 c7                	mov    %eax,%edi
ffff800000100f60:	48 b8 f0 0c 10 00 00 	movabs $0xffff800000100cf0,%rax
ffff800000100f67:	80 ff ff 
ffff800000100f6a:	ff d0                	call   *%rax
}
ffff800000100f6c:	90                   	nop
ffff800000100f6d:	c9                   	leave
ffff800000100f6e:	c3                   	ret

ffff800000100f6f <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

  void
consoleintr(int (*getc)(void))
{
ffff800000100f6f:	55                   	push   %rbp
ffff800000100f70:	48 89 e5             	mov    %rsp,%rbp
ffff800000100f73:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000100f77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int c;

  acquire(&input.lock);
ffff800000100f7b:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000100f82:	80 ff ff 
ffff800000100f85:	48 89 c7             	mov    %rax,%rdi
ffff800000100f88:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000100f8f:	80 ff ff 
ffff800000100f92:	ff d0                	call   *%rax
  while((c = getc()) >= 0){
ffff800000100f94:	e9 6d 02 00 00       	jmp    ffff800000101206 <consoleintr+0x297>
    switch(c){
ffff800000100f99:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100f9d:	0f 84 fd 00 00 00    	je     ffff8000001010a0 <consoleintr+0x131>
ffff800000100fa3:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff800000100fa7:	0f 8f 54 01 00 00    	jg     ffff800000101101 <consoleintr+0x192>
ffff800000100fad:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fb1:	74 2f                	je     ffff800000100fe2 <consoleintr+0x73>
ffff800000100fb3:	83 7d fc 1a          	cmpl   $0x1a,-0x4(%rbp)
ffff800000100fb7:	0f 8f 44 01 00 00    	jg     ffff800000101101 <consoleintr+0x192>
ffff800000100fbd:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fc1:	74 7f                	je     ffff800000101042 <consoleintr+0xd3>
ffff800000100fc3:	83 7d fc 15          	cmpl   $0x15,-0x4(%rbp)
ffff800000100fc7:	0f 8f 34 01 00 00    	jg     ffff800000101101 <consoleintr+0x192>
ffff800000100fcd:	83 7d fc 08          	cmpl   $0x8,-0x4(%rbp)
ffff800000100fd1:	0f 84 c9 00 00 00    	je     ffff8000001010a0 <consoleintr+0x131>
ffff800000100fd7:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
ffff800000100fdb:	74 20                	je     ffff800000100ffd <consoleintr+0x8e>
ffff800000100fdd:	e9 1f 01 00 00       	jmp    ffff800000101101 <consoleintr+0x192>
    case C('Z'): // reboot
      lidt(0,0);
ffff800000100fe2:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000100fe7:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000100fec:	48 b8 0f 06 10 00 00 	movabs $0xffff80000010060f,%rax
ffff800000100ff3:	80 ff ff 
ffff800000100ff6:	ff d0                	call   *%rax
      break;
ffff800000100ff8:	e9 09 02 00 00       	jmp    ffff800000101206 <consoleintr+0x297>
    case C('P'):  // Process listing.
      procdump();
ffff800000100ffd:	48 b8 7e 78 10 00 00 	movabs $0xffff80000010787e,%rax
ffff800000101004:	80 ff ff 
ffff800000101007:	ff d0                	call   *%rax
      break;
ffff800000101009:	e9 f8 01 00 00       	jmp    ffff800000101206 <consoleintr+0x297>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
ffff80000010100e:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101015:	80 ff ff 
ffff800000101018:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff80000010101e:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101021:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101028:	80 ff ff 
ffff80000010102b:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff800000101031:	bf 00 01 00 00       	mov    $0x100,%edi
ffff800000101036:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff80000010103d:	80 ff ff 
ffff800000101040:	ff d0                	call   *%rax
      while(input.e != input.w &&
ffff800000101042:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101049:	80 ff ff 
ffff80000010104c:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff800000101052:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101059:	80 ff ff 
ffff80000010105c:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101062:	39 c2                	cmp    %eax,%edx
ffff800000101064:	0f 84 95 01 00 00    	je     ffff8000001011ff <consoleintr+0x290>
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
ffff80000010106a:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101071:	80 ff ff 
ffff800000101074:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff80000010107a:	83 e8 01             	sub    $0x1,%eax
ffff80000010107d:	83 e0 7f             	and    $0x7f,%eax
ffff800000101080:	89 c2                	mov    %eax,%edx
ffff800000101082:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101089:	80 ff ff 
ffff80000010108c:	89 d2                	mov    %edx,%edx
ffff80000010108e:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
      while(input.e != input.w &&
ffff800000101093:	3c 0a                	cmp    $0xa,%al
ffff800000101095:	0f 85 73 ff ff ff    	jne    ffff80000010100e <consoleintr+0x9f>
      }
      break;
ffff80000010109b:	e9 5f 01 00 00       	jmp    ffff8000001011ff <consoleintr+0x290>
    case C('H'): case '\x7f':  // Backspace
      if (input.e != input.w) {
ffff8000001010a0:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010a7:	80 ff ff 
ffff8000001010aa:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff8000001010b0:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010b7:	80 ff ff 
ffff8000001010ba:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff8000001010c0:	39 c2                	cmp    %eax,%edx
ffff8000001010c2:	0f 84 3a 01 00 00    	je     ffff800000101202 <consoleintr+0x293>
        input.e--;
ffff8000001010c8:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010cf:	80 ff ff 
ffff8000001010d2:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001010d8:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001010db:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001010e2:	80 ff ff 
ffff8000001010e5:	89 90 f0 00 00 00    	mov    %edx,0xf0(%rax)
        consputc(BACKSPACE);
ffff8000001010eb:	bf 00 01 00 00       	mov    $0x100,%edi
ffff8000001010f0:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff8000001010f7:	80 ff ff 
ffff8000001010fa:	ff d0                	call   *%rax
      }
      break;
ffff8000001010fc:	e9 01 01 00 00       	jmp    ffff800000101202 <consoleintr+0x293>
    default:
      if (c != 0 && input.e-input.r < INPUT_BUF) {
ffff800000101101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101105:	0f 84 fa 00 00 00    	je     ffff800000101205 <consoleintr+0x296>
ffff80000010110b:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101112:	80 ff ff 
ffff800000101115:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff80000010111b:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101122:	80 ff ff 
ffff800000101125:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff80000010112b:	29 c2                	sub    %eax,%edx
ffff80000010112d:	83 fa 7f             	cmp    $0x7f,%edx
ffff800000101130:	0f 87 cf 00 00 00    	ja     ffff800000101205 <consoleintr+0x296>
        c = (c == '\r') ? '\n' : c;
ffff800000101136:	83 7d fc 0d          	cmpl   $0xd,-0x4(%rbp)
ffff80000010113a:	75 07                	jne    ffff800000101143 <consoleintr+0x1d4>
ffff80000010113c:	c7 45 fc 0a 00 00 00 	movl   $0xa,-0x4(%rbp)
        input.buf[input.e++ % INPUT_BUF] = c;
ffff800000101143:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010114a:	80 ff ff 
ffff80000010114d:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff800000101153:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101156:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff80000010115d:	80 ff ff 
ffff800000101160:	89 91 f0 00 00 00    	mov    %edx,0xf0(%rcx)
ffff800000101166:	83 e0 7f             	and    $0x7f,%eax
ffff800000101169:	89 c2                	mov    %eax,%edx
ffff80000010116b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010116e:	89 c1                	mov    %eax,%ecx
ffff800000101170:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101177:	80 ff ff 
ffff80000010117a:	89 d2                	mov    %edx,%edx
ffff80000010117c:	88 4c 10 68          	mov    %cl,0x68(%rax,%rdx,1)
        consputc(c);
ffff800000101180:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101183:	89 c7                	mov    %eax,%edi
ffff800000101185:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff80000010118c:	80 ff ff 
ffff80000010118f:	ff d0                	call   *%rax
        if (c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF) {
ffff800000101191:	83 7d fc 0a          	cmpl   $0xa,-0x4(%rbp)
ffff800000101195:	74 2d                	je     ffff8000001011c4 <consoleintr+0x255>
ffff800000101197:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff80000010119b:	74 27                	je     ffff8000001011c4 <consoleintr+0x255>
ffff80000010119d:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011a4:	80 ff ff 
ffff8000001011a7:	8b 90 f0 00 00 00    	mov    0xf0(%rax),%edx
ffff8000001011ad:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011b4:	80 ff ff 
ffff8000001011b7:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff8000001011bd:	83 e8 80             	sub    $0xffffff80,%eax
ffff8000001011c0:	39 c2                	cmp    %eax,%edx
ffff8000001011c2:	75 41                	jne    ffff800000101205 <consoleintr+0x296>
          input.w = input.e;
ffff8000001011c4:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001011cb:	80 ff ff 
ffff8000001011ce:	8b 80 f0 00 00 00    	mov    0xf0(%rax),%eax
ffff8000001011d4:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001011db:	80 ff ff 
ffff8000001011de:	89 82 ec 00 00 00    	mov    %eax,0xec(%rdx)
          wakeup(&input.r);
ffff8000001011e4:	48 b8 a8 34 11 00 00 	movabs $0xffff8000001134a8,%rax
ffff8000001011eb:	80 ff ff 
ffff8000001011ee:	48 89 c7             	mov    %rax,%rdi
ffff8000001011f1:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff8000001011f8:	80 ff ff 
ffff8000001011fb:	ff d0                	call   *%rax
        }
      }
      break;
ffff8000001011fd:	eb 06                	jmp    ffff800000101205 <consoleintr+0x296>
      break;
ffff8000001011ff:	90                   	nop
ffff800000101200:	eb 04                	jmp    ffff800000101206 <consoleintr+0x297>
      break;
ffff800000101202:	90                   	nop
ffff800000101203:	eb 01                	jmp    ffff800000101206 <consoleintr+0x297>
      break;
ffff800000101205:	90                   	nop
  while((c = getc()) >= 0){
ffff800000101206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010120a:	ff d0                	call   *%rax
ffff80000010120c:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010120f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101213:	0f 89 80 fd ff ff    	jns    ffff800000100f99 <consoleintr+0x2a>
    }
  }
  release(&input.lock);
ffff800000101219:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101220:	80 ff ff 
ffff800000101223:	48 89 c7             	mov    %rax,%rdi
ffff800000101226:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010122d:	80 ff ff 
ffff800000101230:	ff d0                	call   *%rax
}
ffff800000101232:	90                   	nop
ffff800000101233:	c9                   	leave
ffff800000101234:	c3                   	ret

ffff800000101235 <consoleread>:

  int
consoleread(struct inode *ip, uint off, char *dst, int n)
{
ffff800000101235:	55                   	push   %rbp
ffff800000101236:	48 89 e5             	mov    %rsp,%rbp
ffff800000101239:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010123d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101241:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000101244:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101248:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint target;
  int c;

  iunlock(ip);
ffff80000010124b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010124f:	48 89 c7             	mov    %rax,%rdi
ffff800000101252:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000101259:	80 ff ff 
ffff80000010125c:	ff d0                	call   *%rax
  target = n;
ffff80000010125e:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101261:	89 45 fc             	mov    %eax,-0x4(%rbp)
  acquire(&input.lock);
ffff800000101264:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010126b:	80 ff ff 
ffff80000010126e:	48 89 c7             	mov    %rax,%rdi
ffff800000101271:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000101278:	80 ff ff 
ffff80000010127b:	ff d0                	call   *%rax
  while(n > 0){
ffff80000010127d:	e9 23 01 00 00       	jmp    ffff8000001013a5 <consoleread+0x170>
    while(input.r == input.w){
      if (proc->killed) {
ffff800000101282:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101289:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010128d:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000101290:	85 c0                	test   %eax,%eax
ffff800000101292:	74 36                	je     ffff8000001012ca <consoleread+0x95>
        release(&input.lock);
ffff800000101294:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010129b:	80 ff ff 
ffff80000010129e:	48 89 c7             	mov    %rax,%rdi
ffff8000001012a1:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001012a8:	80 ff ff 
ffff8000001012ab:	ff d0                	call   *%rax
        ilock(ip);
ffff8000001012ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001012b1:	48 89 c7             	mov    %rax,%rdi
ffff8000001012b4:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff8000001012bb:	80 ff ff 
ffff8000001012be:	ff d0                	call   *%rax
        return -1;
ffff8000001012c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001012c5:	e9 21 01 00 00       	jmp    ffff8000001013eb <consoleread+0x1b6>
      }
      sleep(&input.r, &input.lock);
ffff8000001012ca:	48 ba c0 33 11 00 00 	movabs $0xffff8000001133c0,%rdx
ffff8000001012d1:	80 ff ff 
ffff8000001012d4:	48 b8 a8 34 11 00 00 	movabs $0xffff8000001134a8,%rax
ffff8000001012db:	80 ff ff 
ffff8000001012de:	48 89 d6             	mov    %rdx,%rsi
ffff8000001012e1:	48 89 c7             	mov    %rax,%rdi
ffff8000001012e4:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff8000001012eb:	80 ff ff 
ffff8000001012ee:	ff d0                	call   *%rax
    while(input.r == input.w){
ffff8000001012f0:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001012f7:	80 ff ff 
ffff8000001012fa:	8b 90 e8 00 00 00    	mov    0xe8(%rax),%edx
ffff800000101300:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101307:	80 ff ff 
ffff80000010130a:	8b 80 ec 00 00 00    	mov    0xec(%rax),%eax
ffff800000101310:	39 c2                	cmp    %eax,%edx
ffff800000101312:	0f 84 6a ff ff ff    	je     ffff800000101282 <consoleread+0x4d>
    }
    c = input.buf[input.r++ % INPUT_BUF];
ffff800000101318:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010131f:	80 ff ff 
ffff800000101322:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff800000101328:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010132b:	48 b9 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rcx
ffff800000101332:	80 ff ff 
ffff800000101335:	89 91 e8 00 00 00    	mov    %edx,0xe8(%rcx)
ffff80000010133b:	83 e0 7f             	and    $0x7f,%eax
ffff80000010133e:	89 c2                	mov    %eax,%edx
ffff800000101340:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff800000101347:	80 ff ff 
ffff80000010134a:	89 d2                	mov    %edx,%edx
ffff80000010134c:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
ffff800000101351:	0f be c0             	movsbl %al,%eax
ffff800000101354:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if (c == C('D')) {  // EOF
ffff800000101357:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
ffff80000010135b:	75 2d                	jne    ffff80000010138a <consoleread+0x155>
      if (n < target) {
ffff80000010135d:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000101360:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffff800000101363:	73 4c                	jae    ffff8000001013b1 <consoleread+0x17c>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
ffff800000101365:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010136c:	80 ff ff 
ffff80000010136f:	8b 80 e8 00 00 00    	mov    0xe8(%rax),%eax
ffff800000101375:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101378:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff80000010137f:	80 ff ff 
ffff800000101382:	89 90 e8 00 00 00    	mov    %edx,0xe8(%rax)
      }
      break;
ffff800000101388:	eb 27                	jmp    ffff8000001013b1 <consoleread+0x17c>
    }
    *dst++ = c;
ffff80000010138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010138e:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000101392:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101396:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000101399:	88 10                	mov    %dl,(%rax)
    --n;
ffff80000010139b:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
    if (c == '\n')
ffff80000010139f:	83 7d f8 0a          	cmpl   $0xa,-0x8(%rbp)
ffff8000001013a3:	74 0f                	je     ffff8000001013b4 <consoleread+0x17f>
  while(n > 0){
ffff8000001013a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
ffff8000001013a9:	0f 8f 41 ff ff ff    	jg     ffff8000001012f0 <consoleread+0xbb>
ffff8000001013af:	eb 04                	jmp    ffff8000001013b5 <consoleread+0x180>
      break;
ffff8000001013b1:	90                   	nop
ffff8000001013b2:	eb 01                	jmp    ffff8000001013b5 <consoleread+0x180>
      break;
ffff8000001013b4:	90                   	nop
  }
  release(&input.lock);
ffff8000001013b5:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001013bc:	80 ff ff 
ffff8000001013bf:	48 89 c7             	mov    %rax,%rdi
ffff8000001013c2:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001013c9:	80 ff ff 
ffff8000001013cc:	ff d0                	call   *%rax
  ilock(ip);
ffff8000001013ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001013d2:	48 89 c7             	mov    %rax,%rdi
ffff8000001013d5:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff8000001013dc:	80 ff ff 
ffff8000001013df:	ff d0                	call   *%rax

  return target - n;
ffff8000001013e1:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001013e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001013e7:	29 c2                	sub    %eax,%edx
ffff8000001013e9:	89 d0                	mov    %edx,%eax
}
ffff8000001013eb:	c9                   	leave
ffff8000001013ec:	c3                   	ret

ffff8000001013ed <consolewrite>:

  int
consolewrite(struct inode *ip, uint off, char *buf, int n)
{
ffff8000001013ed:	55                   	push   %rbp
ffff8000001013ee:	48 89 e5             	mov    %rsp,%rbp
ffff8000001013f1:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001013f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001013f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff8000001013fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000101400:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  int i;

  iunlock(ip);
ffff800000101403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101407:	48 89 c7             	mov    %rax,%rdi
ffff80000010140a:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000101411:	80 ff ff 
ffff800000101414:	ff d0                	call   *%rax
  acquire(&cons.lock);
ffff800000101416:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff80000010141d:	80 ff ff 
ffff800000101420:	48 89 c7             	mov    %rax,%rdi
ffff800000101423:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff80000010142a:	80 ff ff 
ffff80000010142d:	ff d0                	call   *%rax
  for(i = 0; i < n; i++)
ffff80000010142f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000101436:	eb 28                	jmp    ffff800000101460 <consolewrite+0x73>
    consputc(buf[i] & 0xff);
ffff800000101438:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010143b:	48 63 d0             	movslq %eax,%rdx
ffff80000010143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101442:	48 01 d0             	add    %rdx,%rax
ffff800000101445:	0f b6 00             	movzbl (%rax),%eax
ffff800000101448:	0f be c0             	movsbl %al,%eax
ffff80000010144b:	0f b6 c0             	movzbl %al,%eax
ffff80000010144e:	89 c7                	mov    %eax,%edi
ffff800000101450:	48 b8 d7 0e 10 00 00 	movabs $0xffff800000100ed7,%rax
ffff800000101457:	80 ff ff 
ffff80000010145a:	ff d0                	call   *%rax
  for(i = 0; i < n; i++)
ffff80000010145c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000101460:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101463:	3b 45 e0             	cmp    -0x20(%rbp),%eax
ffff800000101466:	7c d0                	jl     ffff800000101438 <consolewrite+0x4b>
  release(&cons.lock);
ffff800000101468:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff80000010146f:	80 ff ff 
ffff800000101472:	48 89 c7             	mov    %rax,%rdi
ffff800000101475:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010147c:	80 ff ff 
ffff80000010147f:	ff d0                	call   *%rax
  ilock(ip);
ffff800000101481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101485:	48 89 c7             	mov    %rax,%rdi
ffff800000101488:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff80000010148f:	80 ff ff 
ffff800000101492:	ff d0                	call   *%rax

  return n;
ffff800000101494:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
ffff800000101497:	c9                   	leave
ffff800000101498:	c3                   	ret

ffff800000101499 <consoleinit>:

  void
consoleinit(void)
{
ffff800000101499:	55                   	push   %rbp
ffff80000010149a:	48 89 e5             	mov    %rsp,%rbp
  initlock(&cons.lock, "console");
ffff80000010149d:	48 ba 9b c7 10 00 00 	movabs $0xffff80000010c79b,%rdx
ffff8000001014a4:	80 ff ff 
ffff8000001014a7:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff8000001014ae:	80 ff ff 
ffff8000001014b1:	48 89 d6             	mov    %rdx,%rsi
ffff8000001014b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001014b7:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff8000001014be:	80 ff ff 
ffff8000001014c1:	ff d0                	call   *%rax
  initlock(&input.lock, "input");
ffff8000001014c3:	48 ba a3 c7 10 00 00 	movabs $0xffff80000010c7a3,%rdx
ffff8000001014ca:	80 ff ff 
ffff8000001014cd:	48 b8 c0 33 11 00 00 	movabs $0xffff8000001133c0,%rax
ffff8000001014d4:	80 ff ff 
ffff8000001014d7:	48 89 d6             	mov    %rdx,%rsi
ffff8000001014da:	48 89 c7             	mov    %rax,%rdi
ffff8000001014dd:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff8000001014e4:	80 ff ff 
ffff8000001014e7:	ff d0                	call   *%rax

  devsw[CONSOLE].write = consolewrite;
ffff8000001014e9:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff8000001014f0:	80 ff ff 
ffff8000001014f3:	48 b9 ed 13 10 00 00 	movabs $0xffff8000001013ed,%rcx
ffff8000001014fa:	80 ff ff 
ffff8000001014fd:	48 89 48 18          	mov    %rcx,0x18(%rax)
  devsw[CONSOLE].read = consoleread;
ffff800000101501:	48 b8 40 35 11 00 00 	movabs $0xffff800000113540,%rax
ffff800000101508:	80 ff ff 
ffff80000010150b:	48 b9 35 12 10 00 00 	movabs $0xffff800000101235,%rcx
ffff800000101512:	80 ff ff 
ffff800000101515:	48 89 48 10          	mov    %rcx,0x10(%rax)
  cons.locking = 1;
ffff800000101519:	48 b8 c0 34 11 00 00 	movabs $0xffff8000001134c0,%rax
ffff800000101520:	80 ff ff 
ffff800000101523:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)

  ioapicenable(IRQ_KBD, 0);
ffff80000010152a:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010152f:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000101534:	48 b8 6e 3f 10 00 00 	movabs $0xffff800000103f6e,%rax
ffff80000010153b:	80 ff ff 
ffff80000010153e:	ff d0                	call   *%rax
}
ffff800000101540:	90                   	nop
ffff800000101541:	5d                   	pop    %rbp
ffff800000101542:	c3                   	ret

ffff800000101543 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
ffff800000101543:	55                   	push   %rbp
ffff800000101544:	48 89 e5             	mov    %rsp,%rbp
ffff800000101547:	48 81 ec 00 02 00 00 	sub    $0x200,%rsp
ffff80000010154e:	48 89 bd 08 fe ff ff 	mov    %rdi,-0x1f8(%rbp)
ffff800000101555:	48 89 b5 00 fe ff ff 	mov    %rsi,-0x200(%rbp)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  oldpgdir = proc->pgdir;
ffff80000010155c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101563:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101567:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010156b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

  begin_op();
ffff80000010156f:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff800000101576:	80 ff ff 
ffff800000101579:	ff d0                	call   *%rax

  if((ip = namei(path)) == 0){
ffff80000010157b:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff800000101582:	48 89 c7             	mov    %rax,%rdi
ffff800000101585:	48 b8 93 37 10 00 00 	movabs $0xffff800000103793,%rax
ffff80000010158c:	80 ff ff 
ffff80000010158f:	ff d0                	call   *%rax
ffff800000101591:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffff800000101595:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010159a:	75 16                	jne    ffff8000001015b2 <exec+0x6f>
    end_op();
ffff80000010159c:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff8000001015a3:	80 ff ff 
ffff8000001015a6:	ff d0                	call   *%rax
    return -1;
ffff8000001015a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001015ad:	e9 69 05 00 00       	jmp    ffff800000101b1b <exec+0x5d8>
  }
  ilock(ip);
ffff8000001015b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015b6:	48 89 c7             	mov    %rax,%rdi
ffff8000001015b9:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff8000001015c0:	80 ff ff 
ffff8000001015c3:	ff d0                	call   *%rax
  pgdir = 0;
ffff8000001015c5:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
ffff8000001015cc:	00 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
ffff8000001015cd:	48 8d b5 50 fe ff ff 	lea    -0x1b0(%rbp),%rsi
ffff8000001015d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001015d8:	b9 40 00 00 00       	mov    $0x40,%ecx
ffff8000001015dd:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001015e2:	48 89 c7             	mov    %rax,%rdi
ffff8000001015e5:	48 b8 f5 2e 10 00 00 	movabs $0xffff800000102ef5,%rax
ffff8000001015ec:	80 ff ff 
ffff8000001015ef:	ff d0                	call   *%rax
ffff8000001015f1:	83 f8 40             	cmp    $0x40,%eax
ffff8000001015f4:	0f 85 b7 04 00 00    	jne    ffff800000101ab1 <exec+0x56e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
ffff8000001015fa:	8b 85 50 fe ff ff    	mov    -0x1b0(%rbp),%eax
ffff800000101600:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
ffff800000101605:	0f 85 a9 04 00 00    	jne    ffff800000101ab4 <exec+0x571>
    goto bad;

  if((pgdir = setupkvm()) == 0)
ffff80000010160b:	48 b8 21 b8 10 00 00 	movabs $0xffff80000010b821,%rax
ffff800000101612:	80 ff ff 
ffff800000101615:	ff d0                	call   *%rax
ffff800000101617:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffff80000010161b:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101620:	0f 84 91 04 00 00    	je     ffff800000101ab7 <exec+0x574>
    goto bad;

  // Load program into memory.
  sz = PGSIZE; // skip the first page
ffff800000101626:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
ffff80000010162d:	00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff80000010162e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff800000101635:	48 8b 85 70 fe ff ff 	mov    -0x190(%rbp),%rax
ffff80000010163c:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff80000010163f:	e9 0f 01 00 00       	jmp    ffff800000101753 <exec+0x210>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
ffff800000101644:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000101647:	48 8d b5 10 fe ff ff 	lea    -0x1f0(%rbp),%rsi
ffff80000010164e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101652:	b9 38 00 00 00       	mov    $0x38,%ecx
ffff800000101657:	48 89 c7             	mov    %rax,%rdi
ffff80000010165a:	48 b8 f5 2e 10 00 00 	movabs $0xffff800000102ef5,%rax
ffff800000101661:	80 ff ff 
ffff800000101664:	ff d0                	call   *%rax
ffff800000101666:	83 f8 38             	cmp    $0x38,%eax
ffff800000101669:	0f 85 4b 04 00 00    	jne    ffff800000101aba <exec+0x577>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
ffff80000010166f:	8b 85 10 fe ff ff    	mov    -0x1f0(%rbp),%eax
ffff800000101675:	83 f8 01             	cmp    $0x1,%eax
ffff800000101678:	0f 85 c7 00 00 00    	jne    ffff800000101745 <exec+0x202>
      continue;
    if(ph.memsz < ph.filesz)
ffff80000010167e:	48 8b 95 38 fe ff ff 	mov    -0x1c8(%rbp),%rdx
ffff800000101685:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff80000010168c:	48 39 c2             	cmp    %rax,%rdx
ffff80000010168f:	0f 82 28 04 00 00    	jb     ffff800000101abd <exec+0x57a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
ffff800000101695:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff80000010169c:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016a3:	48 01 c2             	add    %rax,%rdx
ffff8000001016a6:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016ad:	48 39 c2             	cmp    %rax,%rdx
ffff8000001016b0:	0f 82 0a 04 00 00    	jb     ffff800000101ac0 <exec+0x57d>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
ffff8000001016b6:	48 8b 95 20 fe ff ff 	mov    -0x1e0(%rbp),%rdx
ffff8000001016bd:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffff8000001016c4:	48 01 c2             	add    %rax,%rdx
ffff8000001016c7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001016cb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001016cf:	48 89 ce             	mov    %rcx,%rsi
ffff8000001016d2:	48 89 c7             	mov    %rax,%rdi
ffff8000001016d5:	48 b8 78 bf 10 00 00 	movabs $0xffff80000010bf78,%rax
ffff8000001016dc:	80 ff ff 
ffff8000001016df:	ff d0                	call   *%rax
ffff8000001016e1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001016e5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001016ea:	0f 84 d3 03 00 00    	je     ffff800000101ac3 <exec+0x580>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
ffff8000001016f0:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff8000001016f7:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff8000001016fc:	48 85 c0             	test   %rax,%rax
ffff8000001016ff:	0f 85 c1 03 00 00    	jne    ffff800000101ac6 <exec+0x583>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
ffff800000101705:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffff80000010170c:	89 c7                	mov    %eax,%edi
ffff80000010170e:	48 8b 85 18 fe ff ff 	mov    -0x1e8(%rbp),%rax
ffff800000101715:	89 c1                	mov    %eax,%ecx
ffff800000101717:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffff80000010171e:	48 89 c6             	mov    %rax,%rsi
ffff800000101721:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffff800000101725:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101729:	41 89 f8             	mov    %edi,%r8d
ffff80000010172c:	48 89 c7             	mov    %rax,%rdi
ffff80000010172f:	48 b8 50 be 10 00 00 	movabs $0xffff80000010be50,%rax
ffff800000101736:	80 ff ff 
ffff800000101739:	ff d0                	call   *%rax
ffff80000010173b:	85 c0                	test   %eax,%eax
ffff80000010173d:	0f 88 86 03 00 00    	js     ffff800000101ac9 <exec+0x586>
ffff800000101743:	eb 01                	jmp    ffff800000101746 <exec+0x203>
      continue;
ffff800000101745:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffff800000101746:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff80000010174a:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff80000010174d:	83 c0 38             	add    $0x38,%eax
ffff800000101750:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff800000101753:	0f b7 85 88 fe ff ff 	movzwl -0x178(%rbp),%eax
ffff80000010175a:	0f b7 c0             	movzwl %ax,%eax
ffff80000010175d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000101760:	0f 8c de fe ff ff    	jl     ffff800000101644 <exec+0x101>
      goto bad;
  }
  iunlockput(ip);
ffff800000101766:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010176a:	48 89 c7             	mov    %rax,%rdi
ffff80000010176d:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000101774:	80 ff ff 
ffff800000101777:	ff d0                	call   *%rax
  end_op();
ffff800000101779:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000101780:	80 ff ff 
ffff800000101783:	ff d0                	call   *%rax
  ip = 0;
ffff800000101785:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
ffff80000010178c:	00 

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
ffff80000010178d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101791:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff800000101797:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010179d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
ffff8000001017a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017a5:	48 8d 90 00 20 00 00 	lea    0x2000(%rax),%rdx
ffff8000001017ac:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001017b0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017b4:	48 89 ce             	mov    %rcx,%rsi
ffff8000001017b7:	48 89 c7             	mov    %rax,%rdi
ffff8000001017ba:	48 b8 78 bf 10 00 00 	movabs $0xffff80000010bf78,%rax
ffff8000001017c1:	80 ff ff 
ffff8000001017c4:	ff d0                	call   *%rax
ffff8000001017c6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001017ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001017cf:	0f 84 f7 02 00 00    	je     ffff800000101acc <exec+0x589>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
ffff8000001017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017d9:	48 2d 00 20 00 00    	sub    $0x2000,%rax
ffff8000001017df:	48 89 c2             	mov    %rax,%rdx
ffff8000001017e2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001017e6:	48 89 d6             	mov    %rdx,%rsi
ffff8000001017e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001017ec:	48 b8 ec c3 10 00 00 	movabs $0xffff80000010c3ec,%rax
ffff8000001017f3:	80 ff ff 
ffff8000001017f6:	ff d0                	call   *%rax
  sp = sz;
ffff8000001017f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001017fc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
ffff800000101800:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
ffff800000101807:	00 
ffff800000101808:	e9 c9 00 00 00       	jmp    ffff8000001018d6 <exec+0x393>
    if(argc >= MAXARG)
ffff80000010180d:	48 83 7d e0 1f       	cmpq   $0x1f,-0x20(%rbp)
ffff800000101812:	0f 87 b7 02 00 00    	ja     ffff800000101acf <exec+0x58c>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(addr_t)-1);
ffff800000101818:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010181c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000101823:	00 
ffff800000101824:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff80000010182b:	48 01 d0             	add    %rdx,%rax
ffff80000010182e:	48 8b 00             	mov    (%rax),%rax
ffff800000101831:	48 89 c7             	mov    %rax,%rdi
ffff800000101834:	48 b8 ac 82 10 00 00 	movabs $0xffff8000001082ac,%rax
ffff80000010183b:	80 ff ff 
ffff80000010183e:	ff d0                	call   *%rax
ffff800000101840:	83 c0 01             	add    $0x1,%eax
ffff800000101843:	48 98                	cltq
ffff800000101845:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101849:	48 29 c2             	sub    %rax,%rdx
ffff80000010184c:	48 89 d0             	mov    %rdx,%rax
ffff80000010184f:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffff800000101853:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
ffff800000101857:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010185b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000101862:	00 
ffff800000101863:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff80000010186a:	48 01 d0             	add    %rdx,%rax
ffff80000010186d:	48 8b 00             	mov    (%rax),%rax
ffff800000101870:	48 89 c7             	mov    %rax,%rdi
ffff800000101873:	48 b8 ac 82 10 00 00 	movabs $0xffff8000001082ac,%rax
ffff80000010187a:	80 ff ff 
ffff80000010187d:	ff d0                	call   *%rax
ffff80000010187f:	83 c0 01             	add    $0x1,%eax
ffff800000101882:	48 63 c8             	movslq %eax,%rcx
ffff800000101885:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101889:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000101890:	00 
ffff800000101891:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff800000101898:	48 01 d0             	add    %rdx,%rax
ffff80000010189b:	48 8b 10             	mov    (%rax),%rdx
ffff80000010189e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff8000001018a2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff8000001018a6:	48 89 c7             	mov    %rax,%rdi
ffff8000001018a9:	48 b8 5e c6 10 00 00 	movabs $0xffff80000010c65e,%rax
ffff8000001018b0:	80 ff ff 
ffff8000001018b3:	ff d0                	call   *%rax
ffff8000001018b5:	85 c0                	test   %eax,%eax
ffff8000001018b7:	0f 88 15 02 00 00    	js     ffff800000101ad2 <exec+0x58f>
      goto bad;
    ustack[1+argc] = sp;
ffff8000001018bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018c1:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001018c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001018c9:	48 89 84 d5 90 fe ff 	mov    %rax,-0x170(%rbp,%rdx,8)
ffff8000001018d0:	ff 
  for(argc = 0; argv[argc]; argc++) {
ffff8000001018d1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
ffff8000001018d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018da:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001018e1:	00 
ffff8000001018e2:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffff8000001018e9:	48 01 d0             	add    %rdx,%rax
ffff8000001018ec:	48 8b 00             	mov    (%rax),%rax
ffff8000001018ef:	48 85 c0             	test   %rax,%rax
ffff8000001018f2:	0f 85 15 ff ff ff    	jne    ffff80000010180d <exec+0x2ca>
  }
  ustack[1+argc] = 0;
ffff8000001018f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001018fc:	48 83 c0 01          	add    $0x1,%rax
ffff800000101900:	48 c7 84 c5 90 fe ff 	movq   $0x0,-0x170(%rbp,%rax,8)
ffff800000101907:	ff 00 00 00 00 

  ustack[0] = 0xffffffffffffffff;  // fake return PC
ffff80000010190c:	48 c7 85 90 fe ff ff 	movq   $0xffffffffffffffff,-0x170(%rbp)
ffff800000101913:	ff ff ff ff 

	// argc and argv for main() entry point
  proc->tf->rdi = argc;
ffff800000101917:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010191e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101922:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101926:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010192a:	48 89 50 30          	mov    %rdx,0x30(%rax)
  proc->tf->rsi = sp - (argc+1)*sizeof(addr_t);
ffff80000010192e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101932:	48 83 c0 01          	add    $0x1,%rax
ffff800000101936:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff80000010193d:	00 
ffff80000010193e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101945:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101949:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010194d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101951:	48 29 ca             	sub    %rcx,%rdx
ffff800000101954:	48 89 50 28          	mov    %rdx,0x28(%rax)

  sp -= (1+argc+1) * sizeof(addr_t);
ffff800000101958:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010195c:	48 83 c0 02          	add    $0x2,%rax
ffff800000101960:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000101964:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
  if(copyout(pgdir, sp, ustack, (1+argc+1)*sizeof(addr_t)) < 0)
ffff800000101968:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010196c:	48 83 c0 02          	add    $0x2,%rax
ffff800000101970:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff800000101977:	00 
ffff800000101978:	48 8d 95 90 fe ff ff 	lea    -0x170(%rbp),%rdx
ffff80000010197f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffff800000101983:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101987:	48 89 c7             	mov    %rax,%rdi
ffff80000010198a:	48 b8 5e c6 10 00 00 	movabs $0xffff80000010c65e,%rax
ffff800000101991:	80 ff ff 
ffff800000101994:	ff d0                	call   *%rax
ffff800000101996:	85 c0                	test   %eax,%eax
ffff800000101998:	0f 88 37 01 00 00    	js     ffff800000101ad5 <exec+0x592>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
ffff80000010199e:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffff8000001019a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001019a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001019b1:	eb 1c                	jmp    ffff8000001019cf <exec+0x48c>
    if(*s == '/')
ffff8000001019b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019b7:	0f b6 00             	movzbl (%rax),%eax
ffff8000001019ba:	3c 2f                	cmp    $0x2f,%al
ffff8000001019bc:	75 0c                	jne    ffff8000001019ca <exec+0x487>
      last = s+1;
ffff8000001019be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019c2:	48 83 c0 01          	add    $0x1,%rax
ffff8000001019c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(last=s=path; *s; s++)
ffff8000001019ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff8000001019cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001019d3:	0f b6 00             	movzbl (%rax),%eax
ffff8000001019d6:	84 c0                	test   %al,%al
ffff8000001019d8:	75 d9                	jne    ffff8000001019b3 <exec+0x470>
  safestrcpy(proc->name, last, sizeof(proc->name));
ffff8000001019da:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001019e1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001019e5:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff8000001019ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001019f0:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001019f5:	48 89 c6             	mov    %rax,%rsi
ffff8000001019f8:	48 89 cf             	mov    %rcx,%rdi
ffff8000001019fb:	48 b8 49 82 10 00 00 	movabs $0xffff800000108249,%rax
ffff800000101a02:	80 ff ff 
ffff800000101a05:	ff d0                	call   *%rax

  // Commit to the user image.
  proc->pgdir = pgdir;
ffff800000101a07:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a0e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
ffff800000101a16:	48 89 50 08          	mov    %rdx,0x8(%rax)
  proc->sz = sz;
ffff800000101a1a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a21:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a25:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000101a29:	48 89 10             	mov    %rdx,(%rax)
  proc->tf->rip = elf.entry;  // main
ffff800000101a2c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a33:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a37:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a3b:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a42:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
  proc->tf->rcx = elf.entry;
ffff800000101a49:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a50:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a54:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a58:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffff800000101a5f:	48 89 50 10          	mov    %rdx,0x10(%rax)
  proc->tf->rsp = sp;
ffff800000101a63:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a6a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a6e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000101a72:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000101a76:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  switchuvm(proc);
ffff800000101a7d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000101a84:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000101a88:	48 89 c7             	mov    %rax,%rdi
ffff800000101a8b:	48 b8 7f b9 10 00 00 	movabs $0xffff80000010b97f,%rax
ffff800000101a92:	80 ff ff 
ffff800000101a95:	ff d0                	call   *%rax
  freevm(oldpgdir);
ffff800000101a97:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101a9b:	48 89 c7             	mov    %rax,%rdi
ffff800000101a9e:	48 b8 b5 c1 10 00 00 	movabs $0xffff80000010c1b5,%rax
ffff800000101aa5:	80 ff ff 
ffff800000101aa8:	ff d0                	call   *%rax
  return 0;
ffff800000101aaa:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101aaf:	eb 6a                	jmp    ffff800000101b1b <exec+0x5d8>
    goto bad;
ffff800000101ab1:	90                   	nop
ffff800000101ab2:	eb 22                	jmp    ffff800000101ad6 <exec+0x593>
    goto bad;
ffff800000101ab4:	90                   	nop
ffff800000101ab5:	eb 1f                	jmp    ffff800000101ad6 <exec+0x593>
    goto bad;
ffff800000101ab7:	90                   	nop
ffff800000101ab8:	eb 1c                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101aba:	90                   	nop
ffff800000101abb:	eb 19                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101abd:	90                   	nop
ffff800000101abe:	eb 16                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101ac0:	90                   	nop
ffff800000101ac1:	eb 13                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101ac3:	90                   	nop
ffff800000101ac4:	eb 10                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101ac6:	90                   	nop
ffff800000101ac7:	eb 0d                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101ac9:	90                   	nop
ffff800000101aca:	eb 0a                	jmp    ffff800000101ad6 <exec+0x593>
    goto bad;
ffff800000101acc:	90                   	nop
ffff800000101acd:	eb 07                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101acf:	90                   	nop
ffff800000101ad0:	eb 04                	jmp    ffff800000101ad6 <exec+0x593>
      goto bad;
ffff800000101ad2:	90                   	nop
ffff800000101ad3:	eb 01                	jmp    ffff800000101ad6 <exec+0x593>
    goto bad;
ffff800000101ad5:	90                   	nop

 bad:
  if(pgdir)
ffff800000101ad6:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff800000101adb:	74 13                	je     ffff800000101af0 <exec+0x5ad>
    freevm(pgdir);
ffff800000101add:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff800000101ae1:	48 89 c7             	mov    %rax,%rdi
ffff800000101ae4:	48 b8 b5 c1 10 00 00 	movabs $0xffff80000010c1b5,%rax
ffff800000101aeb:	80 ff ff 
ffff800000101aee:	ff d0                	call   *%rax
  if(ip){
ffff800000101af0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff800000101af5:	74 1f                	je     ffff800000101b16 <exec+0x5d3>
    iunlockput(ip);
ffff800000101af7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000101afb:	48 89 c7             	mov    %rax,%rdi
ffff800000101afe:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000101b05:	80 ff ff 
ffff800000101b08:	ff d0                	call   *%rax
    end_op();
ffff800000101b0a:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000101b11:	80 ff ff 
ffff800000101b14:	ff d0                	call   *%rax
  }
  return -1;
ffff800000101b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101b1b:	c9                   	leave
ffff800000101b1c:	c3                   	ret

ffff800000101b1d <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
ffff800000101b1d:	55                   	push   %rbp
ffff800000101b1e:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ftable.lock, "ftable");
ffff800000101b21:	48 ba a9 c7 10 00 00 	movabs $0xffff80000010c7a9,%rdx
ffff800000101b28:	80 ff ff 
ffff800000101b2b:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101b32:	80 ff ff 
ffff800000101b35:	48 89 d6             	mov    %rdx,%rsi
ffff800000101b38:	48 89 c7             	mov    %rax,%rdi
ffff800000101b3b:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000101b42:	80 ff ff 
ffff800000101b45:	ff d0                	call   *%rax
}
ffff800000101b47:	90                   	nop
ffff800000101b48:	5d                   	pop    %rbp
ffff800000101b49:	c3                   	ret

ffff800000101b4a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
ffff800000101b4a:	55                   	push   %rbp
ffff800000101b4b:	48 89 e5             	mov    %rsp,%rbp
ffff800000101b4e:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;

  acquire(&ftable.lock);
ffff800000101b52:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101b59:	80 ff ff 
ffff800000101b5c:	48 89 c7             	mov    %rax,%rdi
ffff800000101b5f:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000101b66:	80 ff ff 
ffff800000101b69:	ff d0                	call   *%rax
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101b6b:	48 b8 48 36 11 00 00 	movabs $0xffff800000113648,%rax
ffff800000101b72:	80 ff ff 
ffff800000101b75:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000101b79:	eb 3a                	jmp    ffff800000101bb5 <filealloc+0x6b>
    if(f->ref == 0){
ffff800000101b7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101b7f:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101b82:	85 c0                	test   %eax,%eax
ffff800000101b84:	75 2a                	jne    ffff800000101bb0 <filealloc+0x66>
      f->ref = 1;
ffff800000101b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101b8a:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%rax)
      release(&ftable.lock);
ffff800000101b91:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101b98:	80 ff ff 
ffff800000101b9b:	48 89 c7             	mov    %rax,%rdi
ffff800000101b9e:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000101ba5:	80 ff ff 
ffff800000101ba8:	ff d0                	call   *%rax
      return f;
ffff800000101baa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101bae:	eb 33                	jmp    ffff800000101be3 <filealloc+0x99>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffff800000101bb0:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff800000101bb5:	48 b8 e8 45 11 00 00 	movabs $0xffff8000001145e8,%rax
ffff800000101bbc:	80 ff ff 
ffff800000101bbf:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000101bc3:	72 b6                	jb     ffff800000101b7b <filealloc+0x31>
    }
  }
  release(&ftable.lock);
ffff800000101bc5:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101bcc:	80 ff ff 
ffff800000101bcf:	48 89 c7             	mov    %rax,%rdi
ffff800000101bd2:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000101bd9:	80 ff ff 
ffff800000101bdc:	ff d0                	call   *%rax
  return 0;
ffff800000101bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000101be3:	c9                   	leave
ffff800000101be4:	c3                   	ret

ffff800000101be5 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
ffff800000101be5:	55                   	push   %rbp
ffff800000101be6:	48 89 e5             	mov    %rsp,%rbp
ffff800000101be9:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101bed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ftable.lock);
ffff800000101bf1:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101bf8:	80 ff ff 
ffff800000101bfb:	48 89 c7             	mov    %rax,%rdi
ffff800000101bfe:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000101c05:	80 ff ff 
ffff800000101c08:	ff d0                	call   *%rax
  if(f->ref < 1)
ffff800000101c0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c0e:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c11:	85 c0                	test   %eax,%eax
ffff800000101c13:	7f 19                	jg     ffff800000101c2e <filedup+0x49>
    panic("filedup");
ffff800000101c15:	48 b8 b0 c7 10 00 00 	movabs $0xffff80000010c7b0,%rax
ffff800000101c1c:	80 ff ff 
ffff800000101c1f:	48 89 c7             	mov    %rax,%rdi
ffff800000101c22:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000101c29:	80 ff ff 
ffff800000101c2c:	ff d0                	call   *%rax
  f->ref++;
ffff800000101c2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c32:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c35:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000101c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101c3c:	89 50 04             	mov    %edx,0x4(%rax)
  release(&ftable.lock);
ffff800000101c3f:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101c46:	80 ff ff 
ffff800000101c49:	48 89 c7             	mov    %rax,%rdi
ffff800000101c4c:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000101c53:	80 ff ff 
ffff800000101c56:	ff d0                	call   *%rax
  return f;
ffff800000101c58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000101c5c:	c9                   	leave
ffff800000101c5d:	c3                   	ret

ffff800000101c5e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
ffff800000101c5e:	55                   	push   %rbp
ffff800000101c5f:	48 89 e5             	mov    %rsp,%rbp
ffff800000101c62:	53                   	push   %rbx
ffff800000101c63:	48 83 ec 48          	sub    $0x48,%rsp
ffff800000101c67:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct file ff;

  acquire(&ftable.lock);
ffff800000101c6b:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101c72:	80 ff ff 
ffff800000101c75:	48 89 c7             	mov    %rax,%rdi
ffff800000101c78:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000101c7f:	80 ff ff 
ffff800000101c82:	ff d0                	call   *%rax
  if(f->ref < 1)
ffff800000101c84:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101c88:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101c8b:	85 c0                	test   %eax,%eax
ffff800000101c8d:	7f 19                	jg     ffff800000101ca8 <fileclose+0x4a>
    panic("fileclose");
ffff800000101c8f:	48 b8 b8 c7 10 00 00 	movabs $0xffff80000010c7b8,%rax
ffff800000101c96:	80 ff ff 
ffff800000101c99:	48 89 c7             	mov    %rax,%rdi
ffff800000101c9c:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000101ca3:	80 ff ff 
ffff800000101ca6:	ff d0                	call   *%rax
  if(--f->ref > 0){
ffff800000101ca8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cac:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101caf:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000101cb2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cb6:	89 50 04             	mov    %edx,0x4(%rax)
ffff800000101cb9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101cbd:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000101cc0:	85 c0                	test   %eax,%eax
ffff800000101cc2:	7e 1e                	jle    ffff800000101ce2 <fileclose+0x84>
    release(&ftable.lock);
ffff800000101cc4:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101ccb:	80 ff ff 
ffff800000101cce:	48 89 c7             	mov    %rax,%rdi
ffff800000101cd1:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000101cd8:	80 ff ff 
ffff800000101cdb:	ff d0                	call   *%rax
ffff800000101cdd:	e9 b2 00 00 00       	jmp    ffff800000101d94 <fileclose+0x136>
    return;
  }
  ff = *f;
ffff800000101ce2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101ce6:	48 8b 08             	mov    (%rax),%rcx
ffff800000101ce9:	48 8b 58 08          	mov    0x8(%rax),%rbx
ffff800000101ced:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff800000101cf1:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
ffff800000101cf5:	48 8b 48 10          	mov    0x10(%rax),%rcx
ffff800000101cf9:	48 8b 58 18          	mov    0x18(%rax),%rbx
ffff800000101cfd:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
ffff800000101d01:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
ffff800000101d05:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000101d09:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  f->ref = 0;
ffff800000101d0d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
  f->type = FD_NONE;
ffff800000101d18:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000101d1c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  release(&ftable.lock);
ffff800000101d22:	48 b8 e0 35 11 00 00 	movabs $0xffff8000001135e0,%rax
ffff800000101d29:	80 ff ff 
ffff800000101d2c:	48 89 c7             	mov    %rax,%rdi
ffff800000101d2f:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000101d36:	80 ff ff 
ffff800000101d39:	ff d0                	call   *%rax

  if(ff.type == FD_PIPE)
ffff800000101d3b:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d3e:	83 f8 01             	cmp    $0x1,%eax
ffff800000101d41:	75 1e                	jne    ffff800000101d61 <fileclose+0x103>
    pipeclose(ff.pipe, ff.writable);
ffff800000101d43:	0f b6 45 c9          	movzbl -0x37(%rbp),%eax
ffff800000101d47:	0f be d0             	movsbl %al,%edx
ffff800000101d4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000101d4e:	89 d6                	mov    %edx,%esi
ffff800000101d50:	48 89 c7             	mov    %rax,%rdi
ffff800000101d53:	48 b8 c0 5d 10 00 00 	movabs $0xffff800000105dc0,%rax
ffff800000101d5a:	80 ff ff 
ffff800000101d5d:	ff d0                	call   *%rax
ffff800000101d5f:	eb 33                	jmp    ffff800000101d94 <fileclose+0x136>
  else if(ff.type == FD_INODE){
ffff800000101d61:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff800000101d64:	83 f8 02             	cmp    $0x2,%eax
ffff800000101d67:	75 2b                	jne    ffff800000101d94 <fileclose+0x136>
    begin_op();
ffff800000101d69:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff800000101d70:	80 ff ff 
ffff800000101d73:	ff d0                	call   *%rax
    iput(ff.ip);
ffff800000101d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000101d79:	48 89 c7             	mov    %rax,%rdi
ffff800000101d7c:	48 b8 8f 2a 10 00 00 	movabs $0xffff800000102a8f,%rax
ffff800000101d83:	80 ff ff 
ffff800000101d86:	ff d0                	call   *%rax
    end_op();
ffff800000101d88:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000101d8f:	80 ff ff 
ffff800000101d92:	ff d0                	call   *%rax
  }
}
ffff800000101d94:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff800000101d98:	c9                   	leave
ffff800000101d99:	c3                   	ret

ffff800000101d9a <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
ffff800000101d9a:	55                   	push   %rbp
ffff800000101d9b:	48 89 e5             	mov    %rsp,%rbp
ffff800000101d9e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000101da2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000101da6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(f->type == FD_INODE){
ffff800000101daa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101dae:	8b 00                	mov    (%rax),%eax
ffff800000101db0:	83 f8 02             	cmp    $0x2,%eax
ffff800000101db3:	75 53                	jne    ffff800000101e08 <filestat+0x6e>
    ilock(f->ip);
ffff800000101db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101db9:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101dbd:	48 89 c7             	mov    %rax,%rdi
ffff800000101dc0:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000101dc7:	80 ff ff 
ffff800000101dca:	ff d0                	call   *%rax
    stati(f->ip, st);
ffff800000101dcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101dd0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101dd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000101dd8:	48 89 d6             	mov    %rdx,%rsi
ffff800000101ddb:	48 89 c7             	mov    %rax,%rdi
ffff800000101dde:	48 b8 8f 2e 10 00 00 	movabs $0xffff800000102e8f,%rax
ffff800000101de5:	80 ff ff 
ffff800000101de8:	ff d0                	call   *%rax
    iunlock(f->ip);
ffff800000101dea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000101dee:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101df2:	48 89 c7             	mov    %rax,%rdi
ffff800000101df5:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000101dfc:	80 ff ff 
ffff800000101dff:	ff d0                	call   *%rax
    return 0;
ffff800000101e01:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000101e06:	eb 05                	jmp    ffff800000101e0d <filestat+0x73>
  }
  return -1;
ffff800000101e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000101e0d:	c9                   	leave
ffff800000101e0e:	c3                   	ret

ffff800000101e0f <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
ffff800000101e0f:	55                   	push   %rbp
ffff800000101e10:	48 89 e5             	mov    %rsp,%rbp
ffff800000101e13:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101e17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101e1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101e1f:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->readable == 0)
ffff800000101e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e26:	0f b6 40 08          	movzbl 0x8(%rax),%eax
ffff800000101e2a:	84 c0                	test   %al,%al
ffff800000101e2c:	75 0a                	jne    ffff800000101e38 <fileread+0x29>
    return -1;
ffff800000101e2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101e33:	e9 c9 00 00 00       	jmp    ffff800000101f01 <fileread+0xf2>
  if(f->type == FD_PIPE)
ffff800000101e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e3c:	8b 00                	mov    (%rax),%eax
ffff800000101e3e:	83 f8 01             	cmp    $0x1,%eax
ffff800000101e41:	75 26                	jne    ffff800000101e69 <fileread+0x5a>
    return piperead(f->pipe, addr, n);
ffff800000101e43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e47:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101e4b:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101e4e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101e52:	48 89 ce             	mov    %rcx,%rsi
ffff800000101e55:	48 89 c7             	mov    %rax,%rdi
ffff800000101e58:	48 b8 d3 5f 10 00 00 	movabs $0xffff800000105fd3,%rax
ffff800000101e5f:	80 ff ff 
ffff800000101e62:	ff d0                	call   *%rax
ffff800000101e64:	e9 98 00 00 00       	jmp    ffff800000101f01 <fileread+0xf2>
  if(f->type == FD_INODE){
ffff800000101e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e6d:	8b 00                	mov    (%rax),%eax
ffff800000101e6f:	83 f8 02             	cmp    $0x2,%eax
ffff800000101e72:	75 74                	jne    ffff800000101ee8 <fileread+0xd9>
    ilock(f->ip);
ffff800000101e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e78:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e7c:	48 89 c7             	mov    %rax,%rdi
ffff800000101e7f:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000101e86:	80 ff ff 
ffff800000101e89:	ff d0                	call   *%rax
    if((r = readi(f->ip, addr, f->off, n)) > 0)
ffff800000101e8b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
ffff800000101e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e92:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101e99:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101e9d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
ffff800000101ea1:	48 89 c7             	mov    %rax,%rdi
ffff800000101ea4:	48 b8 f5 2e 10 00 00 	movabs $0xffff800000102ef5,%rax
ffff800000101eab:	80 ff ff 
ffff800000101eae:	ff d0                	call   *%rax
ffff800000101eb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000101eb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000101eb7:	7e 13                	jle    ffff800000101ecc <fileread+0xbd>
      f->off += r;
ffff800000101eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ebd:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101ec3:	01 c2                	add    %eax,%edx
ffff800000101ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ec9:	89 50 20             	mov    %edx,0x20(%rax)
    iunlock(f->ip);
ffff800000101ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ed0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101ed4:	48 89 c7             	mov    %rax,%rdi
ffff800000101ed7:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000101ede:	80 ff ff 
ffff800000101ee1:	ff d0                	call   *%rax
    return r;
ffff800000101ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101ee6:	eb 19                	jmp    ffff800000101f01 <fileread+0xf2>
  }
  panic("fileread");
ffff800000101ee8:	48 b8 c2 c7 10 00 00 	movabs $0xffff80000010c7c2,%rax
ffff800000101eef:	80 ff ff 
ffff800000101ef2:	48 89 c7             	mov    %rax,%rdi
ffff800000101ef5:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000101efc:	80 ff ff 
ffff800000101eff:	ff d0                	call   *%rax
}
ffff800000101f01:	c9                   	leave
ffff800000101f02:	c3                   	ret

ffff800000101f03 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
ffff800000101f03:	55                   	push   %rbp
ffff800000101f04:	48 89 e5             	mov    %rsp,%rbp
ffff800000101f07:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000101f0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000101f0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000101f13:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->writable == 0)
ffff800000101f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f1a:	0f b6 40 09          	movzbl 0x9(%rax),%eax
ffff800000101f1e:	84 c0                	test   %al,%al
ffff800000101f20:	75 0a                	jne    ffff800000101f2c <filewrite+0x29>
    return -1;
ffff800000101f22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000101f27:	e9 63 01 00 00       	jmp    ffff80000010208f <filewrite+0x18c>
  if(f->type == FD_PIPE)
ffff800000101f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f30:	8b 00                	mov    (%rax),%eax
ffff800000101f32:	83 f8 01             	cmp    $0x1,%eax
ffff800000101f35:	75 26                	jne    ffff800000101f5d <filewrite+0x5a>
    return pipewrite(f->pipe, addr, n);
ffff800000101f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f3b:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000101f3f:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff800000101f42:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff800000101f46:	48 89 ce             	mov    %rcx,%rsi
ffff800000101f49:	48 89 c7             	mov    %rax,%rdi
ffff800000101f4c:	48 b8 93 5e 10 00 00 	movabs $0xffff800000105e93,%rax
ffff800000101f53:	80 ff ff 
ffff800000101f56:	ff d0                	call   *%rax
ffff800000101f58:	e9 32 01 00 00       	jmp    ffff80000010208f <filewrite+0x18c>
  if(f->type == FD_INODE){
ffff800000101f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101f61:	8b 00                	mov    (%rax),%eax
ffff800000101f63:	83 f8 02             	cmp    $0x2,%eax
ffff800000101f66:	0f 85 0a 01 00 00    	jne    ffff800000102076 <filewrite+0x173>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
ffff800000101f6c:	c7 45 f4 00 1a 00 00 	movl   $0x1a00,-0xc(%rbp)
    int i = 0;
ffff800000101f73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    while(i < n){
ffff800000101f7a:	e9 d4 00 00 00       	jmp    ffff800000102053 <filewrite+0x150>
      int n1 = n - i;
ffff800000101f7f:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000101f82:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000101f85:	89 45 f8             	mov    %eax,-0x8(%rbp)
      if(n1 > max)
ffff800000101f88:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000101f8b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
ffff800000101f8e:	7e 06                	jle    ffff800000101f96 <filewrite+0x93>
        n1 = max;
ffff800000101f90:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000101f93:	89 45 f8             	mov    %eax,-0x8(%rbp)

      begin_op();
ffff800000101f96:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff800000101f9d:	80 ff ff 
ffff800000101fa0:	ff d0                	call   *%rax
      ilock(f->ip);
ffff800000101fa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fa6:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101faa:	48 89 c7             	mov    %rax,%rdi
ffff800000101fad:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000101fb4:	80 ff ff 
ffff800000101fb7:	ff d0                	call   *%rax
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
ffff800000101fb9:	8b 4d f8             	mov    -0x8(%rbp),%ecx
ffff800000101fbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fc0:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000101fc6:	48 63 f0             	movslq %eax,%rsi
ffff800000101fc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000101fcd:	48 01 c6             	add    %rax,%rsi
ffff800000101fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101fd4:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000101fd8:	48 89 c7             	mov    %rax,%rdi
ffff800000101fdb:	48 b8 c2 30 10 00 00 	movabs $0xffff8000001030c2,%rax
ffff800000101fe2:	80 ff ff 
ffff800000101fe5:	ff d0                	call   *%rax
ffff800000101fe7:	89 45 f0             	mov    %eax,-0x10(%rbp)
ffff800000101fea:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff800000101fee:	7e 13                	jle    ffff800000102003 <filewrite+0x100>
        f->off += r;
ffff800000101ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000101ff4:	8b 50 20             	mov    0x20(%rax),%edx
ffff800000101ff7:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000101ffa:	01 c2                	add    %eax,%edx
ffff800000101ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102000:	89 50 20             	mov    %edx,0x20(%rax)
      iunlock(f->ip);
ffff800000102003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102007:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff80000010200b:	48 89 c7             	mov    %rax,%rdi
ffff80000010200e:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000102015:	80 ff ff 
ffff800000102018:	ff d0                	call   *%rax
      end_op();
ffff80000010201a:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000102021:	80 ff ff 
ffff800000102024:	ff d0                	call   *%rax

      if(r < 0)
ffff800000102026:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffff80000010202a:	78 35                	js     ffff800000102061 <filewrite+0x15e>
        break;
      if(r != n1)
ffff80000010202c:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010202f:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000102032:	74 19                	je     ffff80000010204d <filewrite+0x14a>
        panic("short filewrite");
ffff800000102034:	48 b8 cb c7 10 00 00 	movabs $0xffff80000010c7cb,%rax
ffff80000010203b:	80 ff ff 
ffff80000010203e:	48 89 c7             	mov    %rax,%rdi
ffff800000102041:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102048:	80 ff ff 
ffff80000010204b:	ff d0                	call   *%rax
      i += r;
ffff80000010204d:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000102050:	01 45 fc             	add    %eax,-0x4(%rbp)
    while(i < n){
ffff800000102053:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102056:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff800000102059:	0f 8c 20 ff ff ff    	jl     ffff800000101f7f <filewrite+0x7c>
ffff80000010205f:	eb 01                	jmp    ffff800000102062 <filewrite+0x15f>
        break;
ffff800000102061:	90                   	nop
    }
    return i == n ? n : -1;
ffff800000102062:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102065:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff800000102068:	75 05                	jne    ffff80000010206f <filewrite+0x16c>
ffff80000010206a:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010206d:	eb 20                	jmp    ffff80000010208f <filewrite+0x18c>
ffff80000010206f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000102074:	eb 19                	jmp    ffff80000010208f <filewrite+0x18c>
  }
  panic("filewrite");
ffff800000102076:	48 b8 db c7 10 00 00 	movabs $0xffff80000010c7db,%rax
ffff80000010207d:	80 ff ff 
ffff800000102080:	48 89 c7             	mov    %rax,%rdi
ffff800000102083:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010208a:	80 ff ff 
ffff80000010208d:	ff d0                	call   *%rax
}
ffff80000010208f:	c9                   	leave
ffff800000102090:	c3                   	ret

ffff800000102091 <readsb>:
struct superblock sb;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
ffff800000102091:	55                   	push   %rbp
ffff800000102092:	48 89 e5             	mov    %rsp,%rbp
ffff800000102095:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102099:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010209c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct buf *bp = bread(dev, 1);
ffff8000001020a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001020a3:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001020a8:	89 c7                	mov    %eax,%edi
ffff8000001020aa:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff8000001020b1:	80 ff ff 
ffff8000001020b4:	ff d0                	call   *%rax
ffff8000001020b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memmove(sb, bp->data, sizeof(*sb));
ffff8000001020ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001020be:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff8000001020c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001020c9:	ba 1c 00 00 00       	mov    $0x1c,%edx
ffff8000001020ce:	48 89 ce             	mov    %rcx,%rsi
ffff8000001020d1:	48 89 c7             	mov    %rax,%rdi
ffff8000001020d4:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff8000001020db:	80 ff ff 
ffff8000001020de:	ff d0                	call   *%rax
  brelse(bp);
ffff8000001020e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001020e4:	48 89 c7             	mov    %rax,%rdi
ffff8000001020e7:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001020ee:	80 ff ff 
ffff8000001020f1:	ff d0                	call   *%rax
}
ffff8000001020f3:	90                   	nop
ffff8000001020f4:	c9                   	leave
ffff8000001020f5:	c3                   	ret

ffff8000001020f6 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
ffff8000001020f6:	55                   	push   %rbp
ffff8000001020f7:	48 89 e5             	mov    %rsp,%rbp
ffff8000001020fa:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001020fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102101:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *bp = bread(dev, bno);
ffff800000102104:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000102107:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010210a:	89 d6                	mov    %edx,%esi
ffff80000010210c:	89 c7                	mov    %eax,%edi
ffff80000010210e:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102115:	80 ff ff 
ffff800000102118:	ff d0                	call   *%rax
ffff80000010211a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(bp->data, 0, BSIZE);
ffff80000010211e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102122:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102128:	ba 00 02 00 00       	mov    $0x200,%edx
ffff80000010212d:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000102132:	48 89 c7             	mov    %rax,%rdi
ffff800000102135:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010213c:	80 ff ff 
ffff80000010213f:	ff d0                	call   *%rax
  log_write(bp);
ffff800000102141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102145:	48 89 c7             	mov    %rax,%rdi
ffff800000102148:	48 b8 45 52 10 00 00 	movabs $0xffff800000105245,%rax
ffff80000010214f:	80 ff ff 
ffff800000102152:	ff d0                	call   *%rax
  brelse(bp);
ffff800000102154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102158:	48 89 c7             	mov    %rax,%rdi
ffff80000010215b:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102162:	80 ff ff 
ffff800000102165:	ff d0                	call   *%rax
}
ffff800000102167:	90                   	nop
ffff800000102168:	c9                   	leave
ffff800000102169:	c3                   	ret

ffff80000010216a <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
ffff80000010216a:	55                   	push   %rbp
ffff80000010216b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010216e:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102172:	89 7d dc             	mov    %edi,-0x24(%rbp)
  int b, bi, m;
  struct buf *bp;
  for(b = 0; b < sb.size; b += BPB){
ffff800000102175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010217c:	e9 4a 01 00 00       	jmp    ffff8000001022cb <balloc+0x161>
    bp = bread(dev, BBLOCK(b, sb));
ffff800000102181:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102184:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
ffff80000010218a:	85 c0                	test   %eax,%eax
ffff80000010218c:	0f 48 c2             	cmovs  %edx,%eax
ffff80000010218f:	c1 f8 0c             	sar    $0xc,%eax
ffff800000102192:	89 c2                	mov    %eax,%edx
ffff800000102194:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff80000010219b:	80 ff ff 
ffff80000010219e:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001021a1:	01 c2                	add    %eax,%edx
ffff8000001021a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001021a6:	89 d6                	mov    %edx,%esi
ffff8000001021a8:	89 c7                	mov    %eax,%edi
ffff8000001021aa:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff8000001021b1:	80 ff ff 
ffff8000001021b4:	ff d0                	call   *%rax
ffff8000001021b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff8000001021ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff8000001021c1:	e9 c4 00 00 00       	jmp    ffff80000010228a <balloc+0x120>
      m = 1 << (bi % 8);
ffff8000001021c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001021c9:	83 e0 07             	and    $0x7,%eax
ffff8000001021cc:	ba 01 00 00 00       	mov    $0x1,%edx
ffff8000001021d1:	89 c1                	mov    %eax,%ecx
ffff8000001021d3:	d3 e2                	shl    %cl,%edx
ffff8000001021d5:	89 d0                	mov    %edx,%eax
ffff8000001021d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
ffff8000001021da:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001021dd:	8d 50 07             	lea    0x7(%rax),%edx
ffff8000001021e0:	85 c0                	test   %eax,%eax
ffff8000001021e2:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001021e5:	c1 f8 03             	sar    $0x3,%eax
ffff8000001021e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001021ec:	48 98                	cltq
ffff8000001021ee:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff8000001021f5:	00 
ffff8000001021f6:	0f b6 c0             	movzbl %al,%eax
ffff8000001021f9:	23 45 ec             	and    -0x14(%rbp),%eax
ffff8000001021fc:	85 c0                	test   %eax,%eax
ffff8000001021fe:	0f 85 82 00 00 00    	jne    ffff800000102286 <balloc+0x11c>
        bp->data[bi/8] |= m;  // Mark block in use.
ffff800000102204:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102207:	8d 50 07             	lea    0x7(%rax),%edx
ffff80000010220a:	85 c0                	test   %eax,%eax
ffff80000010220c:	0f 48 c2             	cmovs  %edx,%eax
ffff80000010220f:	c1 f8 03             	sar    $0x3,%eax
ffff800000102212:	89 c1                	mov    %eax,%ecx
ffff800000102214:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102218:	48 63 c1             	movslq %ecx,%rax
ffff80000010221b:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102222:	00 
ffff800000102223:	89 c2                	mov    %eax,%edx
ffff800000102225:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102228:	09 d0                	or     %edx,%eax
ffff80000010222a:	89 c6                	mov    %eax,%esi
ffff80000010222c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000102230:	48 63 c1             	movslq %ecx,%rax
ffff800000102233:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff80000010223a:	00 
        log_write(bp);
ffff80000010223b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010223f:	48 89 c7             	mov    %rax,%rdi
ffff800000102242:	48 b8 45 52 10 00 00 	movabs $0xffff800000105245,%rax
ffff800000102249:	80 ff ff 
ffff80000010224c:	ff d0                	call   *%rax
        brelse(bp);
ffff80000010224e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102252:	48 89 c7             	mov    %rax,%rdi
ffff800000102255:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff80000010225c:	80 ff ff 
ffff80000010225f:	ff d0                	call   *%rax
        bzero(dev, b + bi);
ffff800000102261:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102264:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102267:	01 c2                	add    %eax,%edx
ffff800000102269:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010226c:	89 d6                	mov    %edx,%esi
ffff80000010226e:	89 c7                	mov    %eax,%edi
ffff800000102270:	48 b8 f6 20 10 00 00 	movabs $0xffff8000001020f6,%rax
ffff800000102277:	80 ff ff 
ffff80000010227a:	ff d0                	call   *%rax
        return b + bi;
ffff80000010227c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010227f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102282:	01 d0                	add    %edx,%eax
ffff800000102284:	eb 75                	jmp    ffff8000001022fb <balloc+0x191>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffff800000102286:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff80000010228a:	81 7d f8 ff 0f 00 00 	cmpl   $0xfff,-0x8(%rbp)
ffff800000102291:	7f 1e                	jg     ffff8000001022b1 <balloc+0x147>
ffff800000102293:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102296:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102299:	01 d0                	add    %edx,%eax
ffff80000010229b:	89 c2                	mov    %eax,%edx
ffff80000010229d:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001022a4:	80 ff ff 
ffff8000001022a7:	8b 00                	mov    (%rax),%eax
ffff8000001022a9:	39 c2                	cmp    %eax,%edx
ffff8000001022ab:	0f 82 15 ff ff ff    	jb     ffff8000001021c6 <balloc+0x5c>
      }
    }
    brelse(bp);
ffff8000001022b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001022b5:	48 89 c7             	mov    %rax,%rdi
ffff8000001022b8:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001022bf:	80 ff ff 
ffff8000001022c2:	ff d0                	call   *%rax
  for(b = 0; b < sb.size; b += BPB){
ffff8000001022c4:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff8000001022cb:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001022d2:	80 ff ff 
ffff8000001022d5:	8b 00                	mov    (%rax),%eax
ffff8000001022d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001022da:	39 c2                	cmp    %eax,%edx
ffff8000001022dc:	0f 82 9f fe ff ff    	jb     ffff800000102181 <balloc+0x17>
  }
  panic("balloc: out of blocks");
ffff8000001022e2:	48 b8 e5 c7 10 00 00 	movabs $0xffff80000010c7e5,%rax
ffff8000001022e9:	80 ff ff 
ffff8000001022ec:	48 89 c7             	mov    %rax,%rdi
ffff8000001022ef:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001022f6:	80 ff ff 
ffff8000001022f9:	ff d0                	call   *%rax
}
ffff8000001022fb:	c9                   	leave
ffff8000001022fc:	c3                   	ret

ffff8000001022fd <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
ffff8000001022fd:	55                   	push   %rbp
ffff8000001022fe:	48 89 e5             	mov    %rsp,%rbp
ffff800000102301:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102305:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102308:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int bi, m;

  readsb(dev, &sb);
ffff80000010230b:	48 ba 00 46 11 00 00 	movabs $0xffff800000114600,%rdx
ffff800000102312:	80 ff ff 
ffff800000102315:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102318:	48 89 d6             	mov    %rdx,%rsi
ffff80000010231b:	89 c7                	mov    %eax,%edi
ffff80000010231d:	48 b8 91 20 10 00 00 	movabs $0xffff800000102091,%rax
ffff800000102324:	80 ff ff 
ffff800000102327:	ff d0                	call   *%rax
  struct buf *bp = bread(dev, BBLOCK(b, sb));
ffff800000102329:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff80000010232c:	c1 e8 0c             	shr    $0xc,%eax
ffff80000010232f:	89 c2                	mov    %eax,%edx
ffff800000102331:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102338:	80 ff ff 
ffff80000010233b:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010233e:	01 c2                	add    %eax,%edx
ffff800000102340:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000102343:	89 d6                	mov    %edx,%esi
ffff800000102345:	89 c7                	mov    %eax,%edi
ffff800000102347:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff80000010234e:	80 ff ff 
ffff800000102351:	ff d0                	call   *%rax
ffff800000102353:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  bi = b % BPB;
ffff800000102357:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff80000010235a:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010235f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  m = 1 << (bi % 8);
ffff800000102362:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000102365:	83 e0 07             	and    $0x7,%eax
ffff800000102368:	ba 01 00 00 00       	mov    $0x1,%edx
ffff80000010236d:	89 c1                	mov    %eax,%ecx
ffff80000010236f:	d3 e2                	shl    %cl,%edx
ffff800000102371:	89 d0                	mov    %edx,%eax
ffff800000102373:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if((bp->data[bi/8] & m) == 0)
ffff800000102376:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000102379:	8d 50 07             	lea    0x7(%rax),%edx
ffff80000010237c:	85 c0                	test   %eax,%eax
ffff80000010237e:	0f 48 c2             	cmovs  %edx,%eax
ffff800000102381:	c1 f8 03             	sar    $0x3,%eax
ffff800000102384:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000102388:	48 98                	cltq
ffff80000010238a:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff800000102391:	00 
ffff800000102392:	0f b6 c0             	movzbl %al,%eax
ffff800000102395:	23 45 f0             	and    -0x10(%rbp),%eax
ffff800000102398:	85 c0                	test   %eax,%eax
ffff80000010239a:	75 19                	jne    ffff8000001023b5 <bfree+0xb8>
    panic("freeing free block");
ffff80000010239c:	48 b8 fb c7 10 00 00 	movabs $0xffff80000010c7fb,%rax
ffff8000001023a3:	80 ff ff 
ffff8000001023a6:	48 89 c7             	mov    %rax,%rdi
ffff8000001023a9:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001023b0:	80 ff ff 
ffff8000001023b3:	ff d0                	call   *%rax
  bp->data[bi/8] &= ~m;
ffff8000001023b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001023b8:	8d 50 07             	lea    0x7(%rax),%edx
ffff8000001023bb:	85 c0                	test   %eax,%eax
ffff8000001023bd:	0f 48 c2             	cmovs  %edx,%eax
ffff8000001023c0:	c1 f8 03             	sar    $0x3,%eax
ffff8000001023c3:	89 c1                	mov    %eax,%ecx
ffff8000001023c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001023c9:	48 63 c1             	movslq %ecx,%rax
ffff8000001023cc:	0f b6 84 02 b0 00 00 	movzbl 0xb0(%rdx,%rax,1),%eax
ffff8000001023d3:	00 
ffff8000001023d4:	89 c2                	mov    %eax,%edx
ffff8000001023d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff8000001023d9:	f7 d0                	not    %eax
ffff8000001023db:	21 d0                	and    %edx,%eax
ffff8000001023dd:	89 c6                	mov    %eax,%esi
ffff8000001023df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001023e3:	48 63 c1             	movslq %ecx,%rax
ffff8000001023e6:	40 88 b4 02 b0 00 00 	mov    %sil,0xb0(%rdx,%rax,1)
ffff8000001023ed:	00 
  log_write(bp);
ffff8000001023ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001023f2:	48 89 c7             	mov    %rax,%rdi
ffff8000001023f5:	48 b8 45 52 10 00 00 	movabs $0xffff800000105245,%rax
ffff8000001023fc:	80 ff ff 
ffff8000001023ff:	ff d0                	call   *%rax
  brelse(bp);
ffff800000102401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102405:	48 89 c7             	mov    %rax,%rdi
ffff800000102408:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff80000010240f:	80 ff ff 
ffff800000102412:	ff d0                	call   *%rax
}
ffff800000102414:	90                   	nop
ffff800000102415:	c9                   	leave
ffff800000102416:	c3                   	ret

ffff800000102417 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
ffff800000102417:	55                   	push   %rbp
ffff800000102418:	48 89 e5             	mov    %rsp,%rbp
ffff80000010241b:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010241f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i = 0;
ffff800000102422:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  initlock(&icache.lock, "icache");
ffff800000102429:	48 ba 0e c8 10 00 00 	movabs $0xffff80000010c80e,%rdx
ffff800000102430:	80 ff ff 
ffff800000102433:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff80000010243a:	80 ff ff 
ffff80000010243d:	48 89 d6             	mov    %rdx,%rsi
ffff800000102440:	48 89 c7             	mov    %rax,%rdi
ffff800000102443:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff80000010244a:	80 ff ff 
ffff80000010244d:	ff d0                	call   *%rax
  for(i = 0; i < NINODE; i++) {
ffff80000010244f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000102456:	eb 41                	jmp    ffff800000102499 <iinit+0x82>
    initsleeplock(&icache.inode[i].lock, "inode");
ffff800000102458:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010245b:	48 98                	cltq
ffff80000010245d:	48 69 c0 d8 00 00 00 	imul   $0xd8,%rax,%rax
ffff800000102464:	48 8d 50 70          	lea    0x70(%rax),%rdx
ffff800000102468:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff80000010246f:	80 ff ff 
ffff800000102472:	48 01 d0             	add    %rdx,%rax
ffff800000102475:	48 83 c0 08          	add    $0x8,%rax
ffff800000102479:	48 ba 15 c8 10 00 00 	movabs $0xffff80000010c815,%rdx
ffff800000102480:	80 ff ff 
ffff800000102483:	48 89 d6             	mov    %rdx,%rsi
ffff800000102486:	48 89 c7             	mov    %rax,%rdi
ffff800000102489:	48 b8 f2 79 10 00 00 	movabs $0xffff8000001079f2,%rax
ffff800000102490:	80 ff ff 
ffff800000102493:	ff d0                	call   *%rax
  for(i = 0; i < NINODE; i++) {
ffff800000102495:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000102499:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
ffff80000010249d:	7e b9                	jle    ffff800000102458 <iinit+0x41>
  }

  readsb(dev, &sb);
ffff80000010249f:	48 ba 00 46 11 00 00 	movabs $0xffff800000114600,%rdx
ffff8000001024a6:	80 ff ff 
ffff8000001024a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001024ac:	48 89 d6             	mov    %rdx,%rsi
ffff8000001024af:	89 c7                	mov    %eax,%edi
ffff8000001024b1:	48 b8 91 20 10 00 00 	movabs $0xffff800000102091,%rax
ffff8000001024b8:	80 ff ff 
ffff8000001024bb:	ff d0                	call   *%rax
  /*cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);*/
}
ffff8000001024bd:	90                   	nop
ffff8000001024be:	c9                   	leave
ffff8000001024bf:	c3                   	ret

ffff8000001024c0 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
ffff8000001024c0:	55                   	push   %rbp
ffff8000001024c1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001024c4:	48 83 ec 30          	sub    $0x30,%rsp
ffff8000001024c8:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffff8000001024cb:	89 f0                	mov    %esi,%eax
ffff8000001024cd:	66 89 45 d8          	mov    %ax,-0x28(%rbp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
ffff8000001024d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
ffff8000001024d8:	e9 d8 00 00 00       	jmp    ffff8000001025b5 <ialloc+0xf5>
    bp = bread(dev, IBLOCK(inum, sb));
ffff8000001024dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001024e0:	48 98                	cltq
ffff8000001024e2:	48 c1 e8 03          	shr    $0x3,%rax
ffff8000001024e6:	89 c2                	mov    %eax,%edx
ffff8000001024e8:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001024ef:	80 ff ff 
ffff8000001024f2:	8b 40 14             	mov    0x14(%rax),%eax
ffff8000001024f5:	01 c2                	add    %eax,%edx
ffff8000001024f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001024fa:	89 d6                	mov    %edx,%esi
ffff8000001024fc:	89 c7                	mov    %eax,%edi
ffff8000001024fe:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102505:	80 ff ff 
ffff800000102508:	ff d0                	call   *%rax
ffff80000010250a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    dip = (struct dinode*)bp->data + inum%IPB;
ffff80000010250e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102512:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000102519:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010251c:	48 98                	cltq
ffff80000010251e:	83 e0 07             	and    $0x7,%eax
ffff800000102521:	48 c1 e0 06          	shl    $0x6,%rax
ffff800000102525:	48 01 d0             	add    %rdx,%rax
ffff800000102528:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(dip->type == 0){  // a free inode
ffff80000010252c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102530:	0f b7 00             	movzwl (%rax),%eax
ffff800000102533:	66 85 c0             	test   %ax,%ax
ffff800000102536:	75 66                	jne    ffff80000010259e <ialloc+0xde>
      memset(dip, 0, sizeof(*dip));
ffff800000102538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010253c:	ba 40 00 00 00       	mov    $0x40,%edx
ffff800000102541:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000102546:	48 89 c7             	mov    %rax,%rdi
ffff800000102549:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff800000102550:	80 ff ff 
ffff800000102553:	ff d0                	call   *%rax
      dip->type = type;
ffff800000102555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102559:	0f b7 55 d8          	movzwl -0x28(%rbp),%edx
ffff80000010255d:	66 89 10             	mov    %dx,(%rax)
      log_write(bp);   // mark it allocated on the disk
ffff800000102560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102564:	48 89 c7             	mov    %rax,%rdi
ffff800000102567:	48 b8 45 52 10 00 00 	movabs $0xffff800000105245,%rax
ffff80000010256e:	80 ff ff 
ffff800000102571:	ff d0                	call   *%rax
      brelse(bp);
ffff800000102573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102577:	48 89 c7             	mov    %rax,%rdi
ffff80000010257a:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102581:	80 ff ff 
ffff800000102584:	ff d0                	call   *%rax
      return iget(dev, inum);
ffff800000102586:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102589:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010258c:	89 d6                	mov    %edx,%esi
ffff80000010258e:	89 c7                	mov    %eax,%edi
ffff800000102590:	48 b8 fa 26 10 00 00 	movabs $0xffff8000001026fa,%rax
ffff800000102597:	80 ff ff 
ffff80000010259a:	ff d0                	call   *%rax
ffff80000010259c:	eb 48                	jmp    ffff8000001025e6 <ialloc+0x126>
    }
    brelse(bp);
ffff80000010259e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001025a2:	48 89 c7             	mov    %rax,%rdi
ffff8000001025a5:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001025ac:	80 ff ff 
ffff8000001025af:	ff d0                	call   *%rax
  for(inum = 1; inum < sb.ninodes; inum++){
ffff8000001025b1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001025b5:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff8000001025bc:	80 ff ff 
ffff8000001025bf:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001025c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001025c5:	39 c2                	cmp    %eax,%edx
ffff8000001025c7:	0f 82 10 ff ff ff    	jb     ffff8000001024dd <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
ffff8000001025cd:	48 b8 1b c8 10 00 00 	movabs $0xffff80000010c81b,%rax
ffff8000001025d4:	80 ff ff 
ffff8000001025d7:	48 89 c7             	mov    %rax,%rdi
ffff8000001025da:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001025e1:	80 ff ff 
ffff8000001025e4:	ff d0                	call   *%rax
}
ffff8000001025e6:	c9                   	leave
ffff8000001025e7:	c3                   	ret

ffff8000001025e8 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
ffff8000001025e8:	55                   	push   %rbp
ffff8000001025e9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001025ec:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001025f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff8000001025f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001025f8:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001025fb:	c1 e8 03             	shr    $0x3,%eax
ffff8000001025fe:	89 c2                	mov    %eax,%edx
ffff800000102600:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102607:	80 ff ff 
ffff80000010260a:	8b 40 14             	mov    0x14(%rax),%eax
ffff80000010260d:	01 c2                	add    %eax,%edx
ffff80000010260f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102613:	8b 00                	mov    (%rax),%eax
ffff800000102615:	89 d6                	mov    %edx,%esi
ffff800000102617:	89 c7                	mov    %eax,%edi
ffff800000102619:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102620:	80 ff ff 
ffff800000102623:	ff d0                	call   *%rax
ffff800000102625:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff800000102629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010262d:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000102634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102638:	8b 40 04             	mov    0x4(%rax),%eax
ffff80000010263b:	89 c0                	mov    %eax,%eax
ffff80000010263d:	83 e0 07             	and    $0x7,%eax
ffff800000102640:	48 c1 e0 06          	shl    $0x6,%rax
ffff800000102644:	48 01 d0             	add    %rdx,%rax
ffff800000102647:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  dip->type = ip->type;
ffff80000010264b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010264f:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff800000102656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010265a:	66 89 10             	mov    %dx,(%rax)
  dip->major = ip->major;
ffff80000010265d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102661:	0f b7 90 96 00 00 00 	movzwl 0x96(%rax),%edx
ffff800000102668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010266c:	66 89 50 02          	mov    %dx,0x2(%rax)
  dip->minor = ip->minor;
ffff800000102670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102674:	0f b7 90 98 00 00 00 	movzwl 0x98(%rax),%edx
ffff80000010267b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010267f:	66 89 50 04          	mov    %dx,0x4(%rax)
  dip->nlink = ip->nlink;
ffff800000102683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102687:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff80000010268e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102692:	66 89 50 06          	mov    %dx,0x6(%rax)
  dip->size = ip->size;
ffff800000102696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010269a:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff8000001026a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026a4:	89 50 08             	mov    %edx,0x8(%rax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
ffff8000001026a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001026ab:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffff8000001026b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001026b6:	48 83 c0 0c          	add    $0xc,%rax
ffff8000001026ba:	ba 34 00 00 00       	mov    $0x34,%edx
ffff8000001026bf:	48 89 ce             	mov    %rcx,%rsi
ffff8000001026c2:	48 89 c7             	mov    %rax,%rdi
ffff8000001026c5:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff8000001026cc:	80 ff ff 
ffff8000001026cf:	ff d0                	call   *%rax
  log_write(bp);
ffff8000001026d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001026d5:	48 89 c7             	mov    %rax,%rdi
ffff8000001026d8:	48 b8 45 52 10 00 00 	movabs $0xffff800000105245,%rax
ffff8000001026df:	80 ff ff 
ffff8000001026e2:	ff d0                	call   *%rax
  brelse(bp);
ffff8000001026e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001026e8:	48 89 c7             	mov    %rax,%rdi
ffff8000001026eb:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001026f2:	80 ff ff 
ffff8000001026f5:	ff d0                	call   *%rax
}
ffff8000001026f7:	90                   	nop
ffff8000001026f8:	c9                   	leave
ffff8000001026f9:	c3                   	ret

ffff8000001026fa <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
ffff8000001026fa:	55                   	push   %rbp
ffff8000001026fb:	48 89 e5             	mov    %rsp,%rbp
ffff8000001026fe:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102702:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000102705:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
ffff800000102708:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff80000010270f:	80 ff ff 
ffff800000102712:	48 89 c7             	mov    %rax,%rdi
ffff800000102715:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff80000010271c:	80 ff ff 
ffff80000010271f:	ff d0                	call   *%rax

  // Is the inode already cached?
  empty = 0;
ffff800000102721:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff800000102728:	00 
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff800000102729:	48 b8 88 46 11 00 00 	movabs $0xffff800000114688,%rax
ffff800000102730:	80 ff ff 
ffff800000102733:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000102737:	eb 77                	jmp    ffff8000001027b0 <iget+0xb6>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
ffff800000102739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010273d:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102740:	85 c0                	test   %eax,%eax
ffff800000102742:	7e 4a                	jle    ffff80000010278e <iget+0x94>
ffff800000102744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102748:	8b 00                	mov    (%rax),%eax
ffff80000010274a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff80000010274d:	75 3f                	jne    ffff80000010278e <iget+0x94>
ffff80000010274f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102753:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102756:	39 45 e8             	cmp    %eax,-0x18(%rbp)
ffff800000102759:	75 33                	jne    ffff80000010278e <iget+0x94>
      ip->ref++;
ffff80000010275b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010275f:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102762:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000102765:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102769:	89 50 08             	mov    %edx,0x8(%rax)
      release(&icache.lock);
ffff80000010276c:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff800000102773:	80 ff ff 
ffff800000102776:	48 89 c7             	mov    %rax,%rdi
ffff800000102779:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000102780:	80 ff ff 
ffff800000102783:	ff d0                	call   *%rax
      return ip;
ffff800000102785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102789:	e9 a7 00 00 00       	jmp    ffff800000102835 <iget+0x13b>
    }
    if(empty == 0 && ip->ref == 0) // Remember empty slot.
ffff80000010278e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000102793:	75 13                	jne    ffff8000001027a8 <iget+0xae>
ffff800000102795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102799:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010279c:	85 c0                	test   %eax,%eax
ffff80000010279e:	75 08                	jne    ffff8000001027a8 <iget+0xae>
      empty = ip;
ffff8000001027a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffff8000001027a8:	48 81 45 f8 d8 00 00 	addq   $0xd8,-0x8(%rbp)
ffff8000001027af:	00 
ffff8000001027b0:	48 b8 b8 70 11 00 00 	movabs $0xffff8000001170b8,%rax
ffff8000001027b7:	80 ff ff 
ffff8000001027ba:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001027be:	0f 82 75 ff ff ff    	jb     ffff800000102739 <iget+0x3f>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
ffff8000001027c4:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001027c9:	75 19                	jne    ffff8000001027e4 <iget+0xea>
    panic("iget: no inodes");
ffff8000001027cb:	48 b8 2d c8 10 00 00 	movabs $0xffff80000010c82d,%rax
ffff8000001027d2:	80 ff ff 
ffff8000001027d5:	48 89 c7             	mov    %rax,%rdi
ffff8000001027d8:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001027df:	80 ff ff 
ffff8000001027e2:	ff d0                	call   *%rax

  ip = empty;
ffff8000001027e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001027e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ip->dev = dev;
ffff8000001027ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027f0:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff8000001027f3:	89 10                	mov    %edx,(%rax)
  ip->inum = inum;
ffff8000001027f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001027f9:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff8000001027fc:	89 50 04             	mov    %edx,0x4(%rax)
  ip->ref = 1;
ffff8000001027ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102803:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
  ip->flags = 0;
ffff80000010280a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010280e:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102815:	00 00 00 
  release(&icache.lock);
ffff800000102818:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff80000010281f:	80 ff ff 
ffff800000102822:	48 89 c7             	mov    %rax,%rdi
ffff800000102825:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010282c:	80 ff ff 
ffff80000010282f:	ff d0                	call   *%rax

  return ip;
ffff800000102831:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000102835:	c9                   	leave
ffff800000102836:	c3                   	ret

ffff800000102837 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
ffff800000102837:	55                   	push   %rbp
ffff800000102838:	48 89 e5             	mov    %rsp,%rbp
ffff80000010283b:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010283f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff800000102843:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff80000010284a:	80 ff ff 
ffff80000010284d:	48 89 c7             	mov    %rax,%rdi
ffff800000102850:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000102857:	80 ff ff 
ffff80000010285a:	ff d0                	call   *%rax
  ip->ref++;
ffff80000010285c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102860:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102863:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000102866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010286a:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff80000010286d:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff800000102874:	80 ff ff 
ffff800000102877:	48 89 c7             	mov    %rax,%rdi
ffff80000010287a:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000102881:	80 ff ff 
ffff800000102884:	ff d0                	call   *%rax
  return ip;
ffff800000102886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010288a:	c9                   	leave
ffff80000010288b:	c3                   	ret

ffff80000010288c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
ffff80000010288c:	55                   	push   %rbp
ffff80000010288d:	48 89 e5             	mov    %rsp,%rbp
ffff800000102890:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000102894:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
ffff800000102898:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010289d:	74 0b                	je     ffff8000001028aa <ilock+0x1e>
ffff80000010289f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001028a3:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001028a6:	85 c0                	test   %eax,%eax
ffff8000001028a8:	7f 19                	jg     ffff8000001028c3 <ilock+0x37>
    panic("ilock");
ffff8000001028aa:	48 b8 3d c8 10 00 00 	movabs $0xffff80000010c83d,%rax
ffff8000001028b1:	80 ff ff 
ffff8000001028b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001028b7:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001028be:	80 ff ff 
ffff8000001028c1:	ff d0                	call   *%rax

  acquiresleep(&ip->lock);
ffff8000001028c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001028c7:	48 83 c0 10          	add    $0x10,%rax
ffff8000001028cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001028ce:	48 b8 4a 7a 10 00 00 	movabs $0xffff800000107a4a,%rax
ffff8000001028d5:	80 ff ff 
ffff8000001028d8:	ff d0                	call   *%rax

  if(!(ip->flags & I_VALID)){
ffff8000001028da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001028de:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff8000001028e4:	83 e0 02             	and    $0x2,%eax
ffff8000001028e7:	85 c0                	test   %eax,%eax
ffff8000001028e9:	0f 85 31 01 00 00    	jne    ffff800000102a20 <ilock+0x194>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
ffff8000001028ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001028f3:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001028f6:	c1 e8 03             	shr    $0x3,%eax
ffff8000001028f9:	89 c2                	mov    %eax,%edx
ffff8000001028fb:	48 b8 00 46 11 00 00 	movabs $0xffff800000114600,%rax
ffff800000102902:	80 ff ff 
ffff800000102905:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000102908:	01 c2                	add    %eax,%edx
ffff80000010290a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010290e:	8b 00                	mov    (%rax),%eax
ffff800000102910:	89 d6                	mov    %edx,%esi
ffff800000102912:	89 c7                	mov    %eax,%edi
ffff800000102914:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff80000010291b:	80 ff ff 
ffff80000010291e:	ff d0                	call   *%rax
ffff800000102920:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
ffff800000102924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102928:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010292f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102933:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000102936:	89 c0                	mov    %eax,%eax
ffff800000102938:	83 e0 07             	and    $0x7,%eax
ffff80000010293b:	48 c1 e0 06          	shl    $0x6,%rax
ffff80000010293f:	48 01 d0             	add    %rdx,%rax
ffff800000102942:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    ip->type = dip->type;
ffff800000102946:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010294a:	0f b7 10             	movzwl (%rax),%edx
ffff80000010294d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102951:	66 89 90 94 00 00 00 	mov    %dx,0x94(%rax)
    ip->major = dip->major;
ffff800000102958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010295c:	0f b7 50 02          	movzwl 0x2(%rax),%edx
ffff800000102960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102964:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
    ip->minor = dip->minor;
ffff80000010296b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010296f:	0f b7 50 04          	movzwl 0x4(%rax),%edx
ffff800000102973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102977:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
    ip->nlink = dip->nlink;
ffff80000010297e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102982:	0f b7 50 06          	movzwl 0x6(%rax),%edx
ffff800000102986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010298a:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    ip->size = dip->size;
ffff800000102991:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102995:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000102998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010299c:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
ffff8000001029a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001029a6:	48 8d 48 0c          	lea    0xc(%rax),%rcx
ffff8000001029aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029ae:	48 05 a0 00 00 00    	add    $0xa0,%rax
ffff8000001029b4:	ba 34 00 00 00       	mov    $0x34,%edx
ffff8000001029b9:	48 89 ce             	mov    %rcx,%rsi
ffff8000001029bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001029bf:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff8000001029c6:	80 ff ff 
ffff8000001029c9:	ff d0                	call   *%rax
    brelse(bp);
ffff8000001029cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001029cf:	48 89 c7             	mov    %rax,%rdi
ffff8000001029d2:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001029d9:	80 ff ff 
ffff8000001029dc:	ff d0                	call   *%rax
    ip->flags |= I_VALID;
ffff8000001029de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029e2:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff8000001029e8:	83 c8 02             	or     $0x2,%eax
ffff8000001029eb:	89 c2                	mov    %eax,%edx
ffff8000001029ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029f1:	89 90 90 00 00 00    	mov    %edx,0x90(%rax)
    if(ip->type == 0)
ffff8000001029f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001029fb:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102a02:	66 85 c0             	test   %ax,%ax
ffff800000102a05:	75 19                	jne    ffff800000102a20 <ilock+0x194>
      panic("ilock: no type");
ffff800000102a07:	48 b8 43 c8 10 00 00 	movabs $0xffff80000010c843,%rax
ffff800000102a0e:	80 ff ff 
ffff800000102a11:	48 89 c7             	mov    %rax,%rdi
ffff800000102a14:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102a1b:	80 ff ff 
ffff800000102a1e:	ff d0                	call   *%rax
  }
}
ffff800000102a20:	90                   	nop
ffff800000102a21:	c9                   	leave
ffff800000102a22:	c3                   	ret

ffff800000102a23 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
ffff800000102a23:	55                   	push   %rbp
ffff800000102a24:	48 89 e5             	mov    %rsp,%rbp
ffff800000102a27:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102a2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
ffff800000102a2f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000102a34:	74 26                	je     ffff800000102a5c <iunlock+0x39>
ffff800000102a36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a3a:	48 83 c0 10          	add    $0x10,%rax
ffff800000102a3e:	48 89 c7             	mov    %rax,%rdi
ffff800000102a41:	48 b8 35 7b 10 00 00 	movabs $0xffff800000107b35,%rax
ffff800000102a48:	80 ff ff 
ffff800000102a4b:	ff d0                	call   *%rax
ffff800000102a4d:	85 c0                	test   %eax,%eax
ffff800000102a4f:	74 0b                	je     ffff800000102a5c <iunlock+0x39>
ffff800000102a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a55:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102a58:	85 c0                	test   %eax,%eax
ffff800000102a5a:	7f 19                	jg     ffff800000102a75 <iunlock+0x52>
    panic("iunlock");
ffff800000102a5c:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff800000102a63:	80 ff ff 
ffff800000102a66:	48 89 c7             	mov    %rax,%rdi
ffff800000102a69:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102a70:	80 ff ff 
ffff800000102a73:	ff d0                	call   *%rax

  releasesleep(&ip->lock);
ffff800000102a75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102a79:	48 83 c0 10          	add    $0x10,%rax
ffff800000102a7d:	48 89 c7             	mov    %rax,%rdi
ffff800000102a80:	48 b8 d0 7a 10 00 00 	movabs $0xffff800000107ad0,%rax
ffff800000102a87:	80 ff ff 
ffff800000102a8a:	ff d0                	call   *%rax
}
ffff800000102a8c:	90                   	nop
ffff800000102a8d:	c9                   	leave
ffff800000102a8e:	c3                   	ret

ffff800000102a8f <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
ffff800000102a8f:	55                   	push   %rbp
ffff800000102a90:	48 89 e5             	mov    %rsp,%rbp
ffff800000102a93:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102a97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffff800000102a9b:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff800000102aa2:	80 ff ff 
ffff800000102aa5:	48 89 c7             	mov    %rax,%rdi
ffff800000102aa8:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000102aaf:	80 ff ff 
ffff800000102ab2:	ff d0                	call   *%rax
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
ffff800000102ab4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ab8:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102abb:	83 f8 01             	cmp    $0x1,%eax
ffff800000102abe:	0f 85 98 00 00 00    	jne    ffff800000102b5c <iput+0xcd>
ffff800000102ac4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ac8:	8b 80 90 00 00 00    	mov    0x90(%rax),%eax
ffff800000102ace:	83 e0 02             	and    $0x2,%eax
ffff800000102ad1:	85 c0                	test   %eax,%eax
ffff800000102ad3:	0f 84 83 00 00 00    	je     ffff800000102b5c <iput+0xcd>
ffff800000102ad9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102add:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000102ae4:	66 85 c0             	test   %ax,%ax
ffff800000102ae7:	75 73                	jne    ffff800000102b5c <iput+0xcd>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
ffff800000102ae9:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff800000102af0:	80 ff ff 
ffff800000102af3:	48 89 c7             	mov    %rax,%rdi
ffff800000102af6:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000102afd:	80 ff ff 
ffff800000102b00:	ff d0                	call   *%rax
    itrunc(ip);
ffff800000102b02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b06:	48 89 c7             	mov    %rax,%rdi
ffff800000102b09:	48 b8 1b 2d 10 00 00 	movabs $0xffff800000102d1b,%rax
ffff800000102b10:	80 ff ff 
ffff800000102b13:	ff d0                	call   *%rax
    ip->type = 0;
ffff800000102b15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b19:	66 c7 80 94 00 00 00 	movw   $0x0,0x94(%rax)
ffff800000102b20:	00 00 
    iupdate(ip);
ffff800000102b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b26:	48 89 c7             	mov    %rax,%rdi
ffff800000102b29:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff800000102b30:	80 ff ff 
ffff800000102b33:	ff d0                	call   *%rax
    acquire(&icache.lock);
ffff800000102b35:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff800000102b3c:	80 ff ff 
ffff800000102b3f:	48 89 c7             	mov    %rax,%rdi
ffff800000102b42:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000102b49:	80 ff ff 
ffff800000102b4c:	ff d0                	call   *%rax
    ip->flags = 0;
ffff800000102b4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b52:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%rax)
ffff800000102b59:	00 00 00 
  }
  ip->ref--;
ffff800000102b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b60:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000102b63:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000102b66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b6a:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffff800000102b6d:	48 b8 20 46 11 00 00 	movabs $0xffff800000114620,%rax
ffff800000102b74:	80 ff ff 
ffff800000102b77:	48 89 c7             	mov    %rax,%rdi
ffff800000102b7a:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000102b81:	80 ff ff 
ffff800000102b84:	ff d0                	call   *%rax
}
ffff800000102b86:	90                   	nop
ffff800000102b87:	c9                   	leave
ffff800000102b88:	c3                   	ret

ffff800000102b89 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
ffff800000102b89:	55                   	push   %rbp
ffff800000102b8a:	48 89 e5             	mov    %rsp,%rbp
ffff800000102b8d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102b91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  iunlock(ip);
ffff800000102b95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102b99:	48 89 c7             	mov    %rax,%rdi
ffff800000102b9c:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000102ba3:	80 ff ff 
ffff800000102ba6:	ff d0                	call   *%rax
  iput(ip);
ffff800000102ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102bac:	48 89 c7             	mov    %rax,%rdi
ffff800000102baf:	48 b8 8f 2a 10 00 00 	movabs $0xffff800000102a8f,%rax
ffff800000102bb6:	80 ff ff 
ffff800000102bb9:	ff d0                	call   *%rax
}
ffff800000102bbb:	90                   	nop
ffff800000102bbc:	c9                   	leave
ffff800000102bbd:	c3                   	ret

ffff800000102bbe <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
ffff800000102bbe:	55                   	push   %rbp
ffff800000102bbf:	48 89 e5             	mov    %rsp,%rbp
ffff800000102bc2:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102bc6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102bca:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
ffff800000102bcd:	83 7d d4 0b          	cmpl   $0xb,-0x2c(%rbp)
ffff800000102bd1:	77 47                	ja     ffff800000102c1a <bmap+0x5c>
    if((addr = ip->addrs[bn]) == 0)
ffff800000102bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102bd7:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102bda:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102bde:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102be1:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102be4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102be8:	75 28                	jne    ffff800000102c12 <bmap+0x54>
      ip->addrs[bn] = addr = balloc(ip->dev);
ffff800000102bea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102bee:	8b 00                	mov    (%rax),%eax
ffff800000102bf0:	89 c7                	mov    %eax,%edi
ffff800000102bf2:	48 b8 6a 21 10 00 00 	movabs $0xffff80000010216a,%rax
ffff800000102bf9:	80 ff ff 
ffff800000102bfc:	ff d0                	call   *%rax
ffff800000102bfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c05:	8b 55 d4             	mov    -0x2c(%rbp),%edx
ffff800000102c08:	48 8d 4a 28          	lea    0x28(%rdx),%rcx
ffff800000102c0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102c0f:	89 14 88             	mov    %edx,(%rax,%rcx,4)
    return addr;
ffff800000102c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102c15:	e9 ff 00 00 00       	jmp    ffff800000102d19 <bmap+0x15b>
  }
  bn -= NDIRECT;
ffff800000102c1a:	83 6d d4 0c          	subl   $0xc,-0x2c(%rbp)

  if(bn < NINDIRECT){
ffff800000102c1e:	83 7d d4 7f          	cmpl   $0x7f,-0x2c(%rbp)
ffff800000102c22:	0f 87 d8 00 00 00    	ja     ffff800000102d00 <bmap+0x142>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
ffff800000102c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c2c:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102c32:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102c39:	75 24                	jne    ffff800000102c5f <bmap+0xa1>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
ffff800000102c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c3f:	8b 00                	mov    (%rax),%eax
ffff800000102c41:	89 c7                	mov    %eax,%edi
ffff800000102c43:	48 b8 6a 21 10 00 00 	movabs $0xffff80000010216a,%rax
ffff800000102c4a:	80 ff ff 
ffff800000102c4d:	ff d0                	call   *%rax
ffff800000102c4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102c52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c56:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102c59:	89 90 d0 00 00 00    	mov    %edx,0xd0(%rax)
    bp = bread(ip->dev, addr);
ffff800000102c5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102c63:	8b 00                	mov    (%rax),%eax
ffff800000102c65:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102c68:	89 d6                	mov    %edx,%esi
ffff800000102c6a:	89 c7                	mov    %eax,%edi
ffff800000102c6c:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102c73:	80 ff ff 
ffff800000102c76:	ff d0                	call   *%rax
ffff800000102c78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102c80:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102c86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if((addr = a[bn]) == 0){
ffff800000102c8a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102c8d:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102c94:	00 
ffff800000102c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102c99:	48 01 d0             	add    %rdx,%rax
ffff800000102c9c:	8b 00                	mov    (%rax),%eax
ffff800000102c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000102ca5:	75 41                	jne    ffff800000102ce8 <bmap+0x12a>
      a[bn] = addr = balloc(ip->dev);
ffff800000102ca7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102cab:	8b 00                	mov    (%rax),%eax
ffff800000102cad:	89 c7                	mov    %eax,%edi
ffff800000102caf:	48 b8 6a 21 10 00 00 	movabs $0xffff80000010216a,%rax
ffff800000102cb6:	80 ff ff 
ffff800000102cb9:	ff d0                	call   *%rax
ffff800000102cbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000102cbe:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000102cc1:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102cc8:	00 
ffff800000102cc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102ccd:	48 01 c2             	add    %rax,%rdx
ffff800000102cd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102cd3:	89 02                	mov    %eax,(%rdx)
      log_write(bp);
ffff800000102cd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102cd9:	48 89 c7             	mov    %rax,%rdi
ffff800000102cdc:	48 b8 45 52 10 00 00 	movabs $0xffff800000105245,%rax
ffff800000102ce3:	80 ff ff 
ffff800000102ce6:	ff d0                	call   *%rax
    }
    brelse(bp);
ffff800000102ce8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102cec:	48 89 c7             	mov    %rax,%rdi
ffff800000102cef:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102cf6:	80 ff ff 
ffff800000102cf9:	ff d0                	call   *%rax
    return addr;
ffff800000102cfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000102cfe:	eb 19                	jmp    ffff800000102d19 <bmap+0x15b>
  }

  panic("bmap: out of range");
ffff800000102d00:	48 b8 5a c8 10 00 00 	movabs $0xffff80000010c85a,%rax
ffff800000102d07:	80 ff ff 
ffff800000102d0a:	48 89 c7             	mov    %rax,%rdi
ffff800000102d0d:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000102d14:	80 ff ff 
ffff800000102d17:	ff d0                	call   *%rax
}
ffff800000102d19:	c9                   	leave
ffff800000102d1a:	c3                   	ret

ffff800000102d1b <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
ffff800000102d1b:	55                   	push   %rbp
ffff800000102d1c:	48 89 e5             	mov    %rsp,%rbp
ffff800000102d1f:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000102d23:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
ffff800000102d27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000102d2e:	eb 55                	jmp    ffff800000102d85 <itrunc+0x6a>
    if(ip->addrs[i]){
ffff800000102d30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d34:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d37:	48 63 d2             	movslq %edx,%rdx
ffff800000102d3a:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102d3e:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102d41:	85 c0                	test   %eax,%eax
ffff800000102d43:	74 3c                	je     ffff800000102d81 <itrunc+0x66>
      bfree(ip->dev, ip->addrs[i]);
ffff800000102d45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d49:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d4c:	48 63 d2             	movslq %edx,%rdx
ffff800000102d4f:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102d53:	8b 04 90             	mov    (%rax,%rdx,4),%eax
ffff800000102d56:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102d5a:	8b 12                	mov    (%rdx),%edx
ffff800000102d5c:	89 c6                	mov    %eax,%esi
ffff800000102d5e:	89 d7                	mov    %edx,%edi
ffff800000102d60:	48 b8 fd 22 10 00 00 	movabs $0xffff8000001022fd,%rax
ffff800000102d67:	80 ff ff 
ffff800000102d6a:	ff d0                	call   *%rax
      ip->addrs[i] = 0;
ffff800000102d6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d70:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000102d73:	48 63 d2             	movslq %edx,%rdx
ffff800000102d76:	48 83 c2 28          	add    $0x28,%rdx
ffff800000102d7a:	c7 04 90 00 00 00 00 	movl   $0x0,(%rax,%rdx,4)
  for(i = 0; i < NDIRECT; i++){
ffff800000102d81:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000102d85:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
ffff800000102d89:	7e a5                	jle    ffff800000102d30 <itrunc+0x15>
    }
  }

  if(ip->addrs[NDIRECT]){
ffff800000102d8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102d8f:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102d95:	85 c0                	test   %eax,%eax
ffff800000102d97:	0f 84 ce 00 00 00    	je     ffff800000102e6b <itrunc+0x150>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
ffff800000102d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102da1:	8b 90 d0 00 00 00    	mov    0xd0(%rax),%edx
ffff800000102da7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102dab:	8b 00                	mov    (%rax),%eax
ffff800000102dad:	89 d6                	mov    %edx,%esi
ffff800000102daf:	89 c7                	mov    %eax,%edi
ffff800000102db1:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000102db8:	80 ff ff 
ffff800000102dbb:	ff d0                	call   *%rax
ffff800000102dbd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffff800000102dc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102dc5:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000102dcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for(j = 0; j < NINDIRECT; j++){
ffff800000102dcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff800000102dd6:	eb 4a                	jmp    ffff800000102e22 <itrunc+0x107>
      if(a[j])
ffff800000102dd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102ddb:	48 98                	cltq
ffff800000102ddd:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102de4:	00 
ffff800000102de5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102de9:	48 01 d0             	add    %rdx,%rax
ffff800000102dec:	8b 00                	mov    (%rax),%eax
ffff800000102dee:	85 c0                	test   %eax,%eax
ffff800000102df0:	74 2c                	je     ffff800000102e1e <itrunc+0x103>
        bfree(ip->dev, a[j]);
ffff800000102df2:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102df5:	48 98                	cltq
ffff800000102df7:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000102dfe:	00 
ffff800000102dff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000102e03:	48 01 d0             	add    %rdx,%rax
ffff800000102e06:	8b 00                	mov    (%rax),%eax
ffff800000102e08:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102e0c:	8b 12                	mov    (%rdx),%edx
ffff800000102e0e:	89 c6                	mov    %eax,%esi
ffff800000102e10:	89 d7                	mov    %edx,%edi
ffff800000102e12:	48 b8 fd 22 10 00 00 	movabs $0xffff8000001022fd,%rax
ffff800000102e19:	80 ff ff 
ffff800000102e1c:	ff d0                	call   *%rax
    for(j = 0; j < NINDIRECT; j++){
ffff800000102e1e:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff800000102e22:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000102e25:	83 f8 7f             	cmp    $0x7f,%eax
ffff800000102e28:	76 ae                	jbe    ffff800000102dd8 <itrunc+0xbd>
    }
    brelse(bp);
ffff800000102e2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102e2e:	48 89 c7             	mov    %rax,%rdi
ffff800000102e31:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000102e38:	80 ff ff 
ffff800000102e3b:	ff d0                	call   *%rax
    bfree(ip->dev, ip->addrs[NDIRECT]);
ffff800000102e3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e41:	8b 80 d0 00 00 00    	mov    0xd0(%rax),%eax
ffff800000102e47:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000102e4b:	8b 12                	mov    (%rdx),%edx
ffff800000102e4d:	89 c6                	mov    %eax,%esi
ffff800000102e4f:	89 d7                	mov    %edx,%edi
ffff800000102e51:	48 b8 fd 22 10 00 00 	movabs $0xffff8000001022fd,%rax
ffff800000102e58:	80 ff ff 
ffff800000102e5b:	ff d0                	call   *%rax
    ip->addrs[NDIRECT] = 0;
ffff800000102e5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e61:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%rax)
ffff800000102e68:	00 00 00 
  }

  ip->size = 0;
ffff800000102e6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e6f:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%rax)
ffff800000102e76:	00 00 00 
  iupdate(ip);
ffff800000102e79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102e7d:	48 89 c7             	mov    %rax,%rdi
ffff800000102e80:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff800000102e87:	80 ff ff 
ffff800000102e8a:	ff d0                	call   *%rax
}
ffff800000102e8c:	90                   	nop
ffff800000102e8d:	c9                   	leave
ffff800000102e8e:	c3                   	ret

ffff800000102e8f <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
ffff800000102e8f:	55                   	push   %rbp
ffff800000102e90:	48 89 e5             	mov    %rsp,%rbp
ffff800000102e93:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000102e97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000102e9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  st->dev = ip->dev;
ffff800000102e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ea3:	8b 00                	mov    (%rax),%eax
ffff800000102ea5:	89 c2                	mov    %eax,%edx
ffff800000102ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102eab:	89 50 04             	mov    %edx,0x4(%rax)
  st->ino = ip->inum;
ffff800000102eae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102eb2:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000102eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102eb9:	89 50 08             	mov    %edx,0x8(%rax)
  st->type = ip->type;
ffff800000102ebc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ec0:	0f b7 90 94 00 00 00 	movzwl 0x94(%rax),%edx
ffff800000102ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102ecb:	66 89 10             	mov    %dx,(%rax)
  st->nlink = ip->nlink;
ffff800000102ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ed2:	0f b7 90 9a 00 00 00 	movzwl 0x9a(%rax),%edx
ffff800000102ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102edd:	66 89 50 0c          	mov    %dx,0xc(%rax)
  st->size = ip->size;
ffff800000102ee1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000102ee5:	8b 90 9c 00 00 00    	mov    0x9c(%rax),%edx
ffff800000102eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000102eef:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000102ef2:	90                   	nop
ffff800000102ef3:	c9                   	leave
ffff800000102ef4:	c3                   	ret

ffff800000102ef5 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
ffff800000102ef5:	55                   	push   %rbp
ffff800000102ef6:	48 89 e5             	mov    %rsp,%rbp
ffff800000102ef9:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000102efd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000102f01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000102f05:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff800000102f08:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff800000102f0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f0f:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000102f16:	66 83 f8 03          	cmp    $0x3,%ax
ffff800000102f1a:	0f 85 8d 00 00 00    	jne    ffff800000102fad <readi+0xb8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
ffff800000102f20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f24:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f2b:	66 85 c0             	test   %ax,%ax
ffff800000102f2e:	78 38                	js     ffff800000102f68 <readi+0x73>
ffff800000102f30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f34:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f3b:	66 83 f8 09          	cmp    $0x9,%ax
ffff800000102f3f:	7f 27                	jg     ffff800000102f68 <readi+0x73>
ffff800000102f41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f45:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f4c:	98                   	cwtl
ffff800000102f4d:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102f54:	80 ff ff 
ffff800000102f57:	48 98                	cltq
ffff800000102f59:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102f5d:	48 01 d0             	add    %rdx,%rax
ffff800000102f60:	48 8b 00             	mov    (%rax),%rax
ffff800000102f63:	48 85 c0             	test   %rax,%rax
ffff800000102f66:	75 0a                	jne    ffff800000102f72 <readi+0x7d>
      return -1;
ffff800000102f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000102f6d:	e9 4e 01 00 00       	jmp    ffff8000001030c0 <readi+0x1cb>
    return devsw[ip->major].read(ip, off, dst, n);
ffff800000102f72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102f76:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000102f7d:	98                   	cwtl
ffff800000102f7e:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000102f85:	80 ff ff 
ffff800000102f88:	48 98                	cltq
ffff800000102f8a:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000102f8e:	48 01 d0             	add    %rdx,%rax
ffff800000102f91:	4c 8b 00             	mov    (%rax),%r8
ffff800000102f94:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff800000102f97:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000102f9b:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff800000102f9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fa2:	48 89 c7             	mov    %rax,%rdi
ffff800000102fa5:	41 ff d0             	call   *%r8
ffff800000102fa8:	e9 13 01 00 00       	jmp    ffff8000001030c0 <readi+0x1cb>
  }

  if(off > ip->size || off + n < off)
ffff800000102fad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fb1:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000102fb7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff800000102fba:	72 0d                	jb     ffff800000102fc9 <readi+0xd4>
ffff800000102fbc:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000102fbf:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000102fc2:	01 d0                	add    %edx,%eax
ffff800000102fc4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff800000102fc7:	73 0a                	jae    ffff800000102fd3 <readi+0xde>
    return -1;
ffff800000102fc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000102fce:	e9 ed 00 00 00       	jmp    ffff8000001030c0 <readi+0x1cb>
  if(off + n > ip->size)
ffff800000102fd3:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000102fd6:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000102fd9:	01 c2                	add    %eax,%edx
ffff800000102fdb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fdf:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000102fe5:	39 d0                	cmp    %edx,%eax
ffff800000102fe7:	73 10                	jae    ffff800000102ff9 <readi+0x104>
    n = ip->size - off;
ffff800000102fe9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000102fed:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000102ff3:	2b 45 cc             	sub    -0x34(%rbp),%eax
ffff800000102ff6:	89 45 c8             	mov    %eax,-0x38(%rbp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff800000102ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103000:	e9 ac 00 00 00       	jmp    ffff8000001030b1 <readi+0x1bc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff800000103005:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103008:	c1 e8 09             	shr    $0x9,%eax
ffff80000010300b:	89 c2                	mov    %eax,%edx
ffff80000010300d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103011:	89 d6                	mov    %edx,%esi
ffff800000103013:	48 89 c7             	mov    %rax,%rdi
ffff800000103016:	48 b8 be 2b 10 00 00 	movabs $0xffff800000102bbe,%rax
ffff80000010301d:	80 ff ff 
ffff800000103020:	ff d0                	call   *%rax
ffff800000103022:	89 c2                	mov    %eax,%edx
ffff800000103024:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103028:	8b 00                	mov    (%rax),%eax
ffff80000010302a:	89 d6                	mov    %edx,%esi
ffff80000010302c:	89 c7                	mov    %eax,%edi
ffff80000010302e:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000103035:	80 ff ff 
ffff800000103038:	ff d0                	call   *%rax
ffff80000010303a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff80000010303e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103041:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000103046:	ba 00 02 00 00       	mov    $0x200,%edx
ffff80000010304b:	29 c2                	sub    %eax,%edx
ffff80000010304d:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103050:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000103053:	39 c2                	cmp    %eax,%edx
ffff800000103055:	0f 46 c2             	cmovbe %edx,%eax
ffff800000103058:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(dst, bp->data + off%BSIZE, m);
ffff80000010305b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010305f:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff800000103066:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103069:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010306e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff800000103072:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000103075:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000103079:	48 89 ce             	mov    %rcx,%rsi
ffff80000010307c:	48 89 c7             	mov    %rax,%rdi
ffff80000010307f:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff800000103086:	80 ff ff 
ffff800000103089:	ff d0                	call   *%rax
    brelse(bp);
ffff80000010308b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010308f:	48 89 c7             	mov    %rax,%rdi
ffff800000103092:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000103099:	80 ff ff 
ffff80000010309c:	ff d0                	call   *%rax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffff80000010309e:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001030a1:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff8000001030a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001030a7:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff8000001030aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001030ad:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff8000001030b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001030b4:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff8000001030b7:	0f 82 48 ff ff ff    	jb     ffff800000103005 <readi+0x110>
  }
  return n;
ffff8000001030bd:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff8000001030c0:	c9                   	leave
ffff8000001030c1:	c3                   	ret

ffff8000001030c2 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
ffff8000001030c2:	55                   	push   %rbp
ffff8000001030c3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001030c6:	48 83 ec 40          	sub    $0x40,%rsp
ffff8000001030ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff8000001030ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff8000001030d2:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffff8000001030d5:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffff8000001030d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001030dc:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001030e3:	66 83 f8 03          	cmp    $0x3,%ax
ffff8000001030e7:	0f 85 95 00 00 00    	jne    ffff800000103182 <writei+0xc0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
ffff8000001030ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001030f1:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff8000001030f8:	66 85 c0             	test   %ax,%ax
ffff8000001030fb:	78 3c                	js     ffff800000103139 <writei+0x77>
ffff8000001030fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103101:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103108:	66 83 f8 09          	cmp    $0x9,%ax
ffff80000010310c:	7f 2b                	jg     ffff800000103139 <writei+0x77>
ffff80000010310e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103112:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff800000103119:	98                   	cwtl
ffff80000010311a:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000103121:	80 ff ff 
ffff800000103124:	48 98                	cltq
ffff800000103126:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010312a:	48 01 d0             	add    %rdx,%rax
ffff80000010312d:	48 83 c0 08          	add    $0x8,%rax
ffff800000103131:	48 8b 00             	mov    (%rax),%rax
ffff800000103134:	48 85 c0             	test   %rax,%rax
ffff800000103137:	75 0a                	jne    ffff800000103143 <writei+0x81>
      return -1;
ffff800000103139:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010313e:	e9 8d 01 00 00       	jmp    ffff8000001032d0 <writei+0x20e>
    return devsw[ip->major].write(ip, off, src, n);
ffff800000103143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103147:	0f b7 80 96 00 00 00 	movzwl 0x96(%rax),%eax
ffff80000010314e:	98                   	cwtl
ffff80000010314f:	48 ba 40 35 11 00 00 	movabs $0xffff800000113540,%rdx
ffff800000103156:	80 ff ff 
ffff800000103159:	48 98                	cltq
ffff80000010315b:	48 c1 e0 04          	shl    $0x4,%rax
ffff80000010315f:	48 01 d0             	add    %rdx,%rax
ffff800000103162:	48 83 c0 08          	add    $0x8,%rax
ffff800000103166:	4c 8b 00             	mov    (%rax),%r8
ffff800000103169:	8b 4d c8             	mov    -0x38(%rbp),%ecx
ffff80000010316c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff800000103170:	8b 75 cc             	mov    -0x34(%rbp),%esi
ffff800000103173:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103177:	48 89 c7             	mov    %rax,%rdi
ffff80000010317a:	41 ff d0             	call   *%r8
ffff80000010317d:	e9 4e 01 00 00       	jmp    ffff8000001032d0 <writei+0x20e>
  }

  if(off > ip->size || off + n < off)
ffff800000103182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103186:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff80000010318c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff80000010318f:	72 0d                	jb     ffff80000010319e <writei+0xdc>
ffff800000103191:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff800000103194:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103197:	01 d0                	add    %edx,%eax
ffff800000103199:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff80000010319c:	73 0a                	jae    ffff8000001031a8 <writei+0xe6>
    return -1;
ffff80000010319e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001031a3:	e9 28 01 00 00       	jmp    ffff8000001032d0 <writei+0x20e>
  if(off + n > MAXFILE*BSIZE)
ffff8000001031a8:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001031ab:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff8000001031ae:	01 d0                	add    %edx,%eax
ffff8000001031b0:	3d 00 18 01 00       	cmp    $0x11800,%eax
ffff8000001031b5:	76 0a                	jbe    ffff8000001031c1 <writei+0xff>
    return -1;
ffff8000001031b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001031bc:	e9 0f 01 00 00       	jmp    ffff8000001032d0 <writei+0x20e>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff8000001031c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001031c8:	e9 bf 00 00 00       	jmp    ffff80000010328c <writei+0x1ca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffff8000001031cd:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001031d0:	c1 e8 09             	shr    $0x9,%eax
ffff8000001031d3:	89 c2                	mov    %eax,%edx
ffff8000001031d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031d9:	89 d6                	mov    %edx,%esi
ffff8000001031db:	48 89 c7             	mov    %rax,%rdi
ffff8000001031de:	48 b8 be 2b 10 00 00 	movabs $0xffff800000102bbe,%rax
ffff8000001031e5:	80 ff ff 
ffff8000001031e8:	ff d0                	call   *%rax
ffff8000001031ea:	89 c2                	mov    %eax,%edx
ffff8000001031ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001031f0:	8b 00                	mov    (%rax),%eax
ffff8000001031f2:	89 d6                	mov    %edx,%esi
ffff8000001031f4:	89 c7                	mov    %eax,%edi
ffff8000001031f6:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff8000001031fd:	80 ff ff 
ffff800000103200:	ff d0                	call   *%rax
ffff800000103202:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffff800000103206:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103209:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010320e:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000103213:	29 c2                	sub    %eax,%edx
ffff800000103215:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffff800000103218:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010321b:	39 c2                	cmp    %eax,%edx
ffff80000010321d:	0f 46 c2             	cmovbe %edx,%eax
ffff800000103220:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(bp->data + off%BSIZE, src, m);
ffff800000103223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103227:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
ffff80000010322e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff800000103231:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000103236:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010323a:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010323d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000103241:	48 89 c6             	mov    %rax,%rsi
ffff800000103244:	48 89 cf             	mov    %rcx,%rdi
ffff800000103247:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff80000010324e:	80 ff ff 
ffff800000103251:	ff d0                	call   *%rax
    log_write(bp);
ffff800000103253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103257:	48 89 c7             	mov    %rax,%rdi
ffff80000010325a:	48 b8 45 52 10 00 00 	movabs $0xffff800000105245,%rax
ffff800000103261:	80 ff ff 
ffff800000103264:	ff d0                	call   *%rax
    brelse(bp);
ffff800000103266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010326a:	48 89 c7             	mov    %rax,%rdi
ffff80000010326d:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000103274:	80 ff ff 
ffff800000103277:	ff d0                	call   *%rax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffff800000103279:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010327c:	01 45 fc             	add    %eax,-0x4(%rbp)
ffff80000010327f:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103282:	01 45 cc             	add    %eax,-0x34(%rbp)
ffff800000103285:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000103288:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffff80000010328c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010328f:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffff800000103292:	0f 82 35 ff ff ff    	jb     ffff8000001031cd <writei+0x10b>
  }

  if(n > 0 && off > ip->size){
ffff800000103298:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
ffff80000010329c:	74 2f                	je     ffff8000001032cd <writei+0x20b>
ffff80000010329e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001032a2:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001032a8:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffff8000001032ab:	73 20                	jae    ffff8000001032cd <writei+0x20b>
    ip->size = off;
ffff8000001032ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001032b1:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001032b4:	89 90 9c 00 00 00    	mov    %edx,0x9c(%rax)
    iupdate(ip);
ffff8000001032ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001032be:	48 89 c7             	mov    %rax,%rdi
ffff8000001032c1:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff8000001032c8:	80 ff ff 
ffff8000001032cb:	ff d0                	call   *%rax
  }
  return n;
ffff8000001032cd:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffff8000001032d0:	c9                   	leave
ffff8000001032d1:	c3                   	ret

ffff8000001032d2 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
ffff8000001032d2:	55                   	push   %rbp
ffff8000001032d3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001032d6:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001032da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001032de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return strncmp(s, t, DIRSIZ);
ffff8000001032e2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff8000001032e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001032ea:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff8000001032ef:	48 89 ce             	mov    %rcx,%rsi
ffff8000001032f2:	48 89 c7             	mov    %rax,%rdi
ffff8000001032f5:	48 b8 6b 81 10 00 00 	movabs $0xffff80000010816b,%rax
ffff8000001032fc:	80 ff ff 
ffff8000001032ff:	ff d0                	call   *%rax
}
ffff800000103301:	c9                   	leave
ffff800000103302:	c3                   	ret

ffff800000103303 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
ffff800000103303:	55                   	push   %rbp
ffff800000103304:	48 89 e5             	mov    %rsp,%rbp
ffff800000103307:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010330b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010330f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103313:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
ffff800000103317:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010331b:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103322:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103326:	74 19                	je     ffff800000103341 <dirlookup+0x3e>
    panic("dirlookup not DIR");
ffff800000103328:	48 b8 6d c8 10 00 00 	movabs $0xffff80000010c86d,%rax
ffff80000010332f:	80 ff ff 
ffff800000103332:	48 89 c7             	mov    %rax,%rdi
ffff800000103335:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010333c:	80 ff ff 
ffff80000010333f:	ff d0                	call   *%rax

  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103348:	e9 a2 00 00 00       	jmp    ffff8000001033ef <dirlookup+0xec>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff80000010334d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103350:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000103354:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103358:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff80000010335d:	48 89 c7             	mov    %rax,%rdi
ffff800000103360:	48 b8 f5 2e 10 00 00 	movabs $0xffff800000102ef5,%rax
ffff800000103367:	80 ff ff 
ffff80000010336a:	ff d0                	call   *%rax
ffff80000010336c:	83 f8 10             	cmp    $0x10,%eax
ffff80000010336f:	74 19                	je     ffff80000010338a <dirlookup+0x87>
      panic("dirlookup read");
ffff800000103371:	48 b8 7f c8 10 00 00 	movabs $0xffff80000010c87f,%rax
ffff800000103378:	80 ff ff 
ffff80000010337b:	48 89 c7             	mov    %rax,%rdi
ffff80000010337e:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103385:	80 ff ff 
ffff800000103388:	ff d0                	call   *%rax
    if(de.inum == 0)
ffff80000010338a:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff80000010338e:	66 85 c0             	test   %ax,%ax
ffff800000103391:	74 57                	je     ffff8000001033ea <dirlookup+0xe7>
      continue;
    if(namecmp(name, de.name) == 0){
ffff800000103393:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000103397:	48 8d 50 02          	lea    0x2(%rax),%rdx
ffff80000010339b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010339f:	48 89 d6             	mov    %rdx,%rsi
ffff8000001033a2:	48 89 c7             	mov    %rax,%rdi
ffff8000001033a5:	48 b8 d2 32 10 00 00 	movabs $0xffff8000001032d2,%rax
ffff8000001033ac:	80 ff ff 
ffff8000001033af:	ff d0                	call   *%rax
ffff8000001033b1:	85 c0                	test   %eax,%eax
ffff8000001033b3:	75 36                	jne    ffff8000001033eb <dirlookup+0xe8>
      // entry matches path element
      if(poff)
ffff8000001033b5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff8000001033ba:	74 09                	je     ffff8000001033c5 <dirlookup+0xc2>
        *poff = off;
ffff8000001033bc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001033c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001033c3:	89 10                	mov    %edx,(%rax)
      inum = de.inum;
ffff8000001033c5:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001033c9:	0f b7 c0             	movzwl %ax,%eax
ffff8000001033cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
      return iget(dp->dev, inum);
ffff8000001033cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033d3:	8b 00                	mov    (%rax),%eax
ffff8000001033d5:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff8000001033d8:	89 d6                	mov    %edx,%esi
ffff8000001033da:	89 c7                	mov    %eax,%edi
ffff8000001033dc:	48 b8 fa 26 10 00 00 	movabs $0xffff8000001026fa,%rax
ffff8000001033e3:	80 ff ff 
ffff8000001033e6:	ff d0                	call   *%rax
ffff8000001033e8:	eb 1d                	jmp    ffff800000103407 <dirlookup+0x104>
      continue;
ffff8000001033ea:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001033eb:	83 45 fc 10          	addl   $0x10,-0x4(%rbp)
ffff8000001033ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001033f3:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001033f9:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001033fc:	0f 82 4b ff ff ff    	jb     ffff80000010334d <dirlookup+0x4a>
    }
  }

  return 0;
ffff800000103402:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000103407:	c9                   	leave
ffff800000103408:	c3                   	ret

ffff800000103409 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
ffff800000103409:	55                   	push   %rbp
ffff80000010340a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010340d:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000103411:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000103415:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff800000103419:	89 55 cc             	mov    %edx,-0x34(%rbp)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
ffff80000010341c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
ffff800000103420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103424:	ba 00 00 00 00       	mov    $0x0,%edx
ffff800000103429:	48 89 ce             	mov    %rcx,%rsi
ffff80000010342c:	48 89 c7             	mov    %rax,%rdi
ffff80000010342f:	48 b8 03 33 10 00 00 	movabs $0xffff800000103303,%rax
ffff800000103436:	80 ff ff 
ffff800000103439:	ff d0                	call   *%rax
ffff80000010343b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010343f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000103444:	74 1d                	je     ffff800000103463 <dirlink+0x5a>
    iput(ip);
ffff800000103446:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010344a:	48 89 c7             	mov    %rax,%rdi
ffff80000010344d:	48 b8 8f 2a 10 00 00 	movabs $0xffff800000102a8f,%rax
ffff800000103454:	80 ff ff 
ffff800000103457:	ff d0                	call   *%rax
    return -1;
ffff800000103459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010345e:	e9 d8 00 00 00       	jmp    ffff80000010353b <dirlink+0x132>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff800000103463:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010346a:	eb 4f                	jmp    ffff8000001034bb <dirlink+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff80000010346c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010346f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000103473:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103477:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff80000010347c:	48 89 c7             	mov    %rax,%rdi
ffff80000010347f:	48 b8 f5 2e 10 00 00 	movabs $0xffff800000102ef5,%rax
ffff800000103486:	80 ff ff 
ffff800000103489:	ff d0                	call   *%rax
ffff80000010348b:	83 f8 10             	cmp    $0x10,%eax
ffff80000010348e:	74 19                	je     ffff8000001034a9 <dirlink+0xa0>
      panic("dirlink read");
ffff800000103490:	48 b8 8e c8 10 00 00 	movabs $0xffff80000010c88e,%rax
ffff800000103497:	80 ff ff 
ffff80000010349a:	48 89 c7             	mov    %rax,%rdi
ffff80000010349d:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001034a4:	80 ff ff 
ffff8000001034a7:	ff d0                	call   *%rax
    if(de.inum == 0)
ffff8000001034a9:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff8000001034ad:	66 85 c0             	test   %ax,%ax
ffff8000001034b0:	74 1c                	je     ffff8000001034ce <dirlink+0xc5>
  for(off = 0; off < dp->size; off += sizeof(de)){
ffff8000001034b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001034b5:	83 c0 10             	add    $0x10,%eax
ffff8000001034b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001034bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001034bf:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff8000001034c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001034c8:	39 c2                	cmp    %eax,%edx
ffff8000001034ca:	72 a0                	jb     ffff80000010346c <dirlink+0x63>
ffff8000001034cc:	eb 01                	jmp    ffff8000001034cf <dirlink+0xc6>
      break;
ffff8000001034ce:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
ffff8000001034cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001034d3:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff8000001034d7:	48 8d 4a 02          	lea    0x2(%rdx),%rcx
ffff8000001034db:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff8000001034e0:	48 89 c6             	mov    %rax,%rsi
ffff8000001034e3:	48 89 cf             	mov    %rcx,%rdi
ffff8000001034e6:	48 b8 d8 81 10 00 00 	movabs $0xffff8000001081d8,%rax
ffff8000001034ed:	80 ff ff 
ffff8000001034f0:	ff d0                	call   *%rax
  de.inum = inum;
ffff8000001034f2:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffff8000001034f5:	66 89 45 e0          	mov    %ax,-0x20(%rbp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff8000001034f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001034fc:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000103500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000103504:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000103509:	48 89 c7             	mov    %rax,%rdi
ffff80000010350c:	48 b8 c2 30 10 00 00 	movabs $0xffff8000001030c2,%rax
ffff800000103513:	80 ff ff 
ffff800000103516:	ff d0                	call   *%rax
ffff800000103518:	83 f8 10             	cmp    $0x10,%eax
ffff80000010351b:	74 19                	je     ffff800000103536 <dirlink+0x12d>
    panic("dirlink");
ffff80000010351d:	48 b8 9b c8 10 00 00 	movabs $0xffff80000010c89b,%rax
ffff800000103524:	80 ff ff 
ffff800000103527:	48 89 c7             	mov    %rax,%rdi
ffff80000010352a:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103531:	80 ff ff 
ffff800000103534:	ff d0                	call   *%rax

  return 0;
ffff800000103536:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010353b:	c9                   	leave
ffff80000010353c:	c3                   	ret

ffff80000010353d <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
ffff80000010353d:	55                   	push   %rbp
ffff80000010353e:	48 89 e5             	mov    %rsp,%rbp
ffff800000103541:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103545:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000103549:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s;
  int len;

  while(*path == '/')
ffff80000010354d:	eb 05                	jmp    ffff800000103554 <skipelem+0x17>
    path++;
ffff80000010354f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff800000103554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103558:	0f b6 00             	movzbl (%rax),%eax
ffff80000010355b:	3c 2f                	cmp    $0x2f,%al
ffff80000010355d:	74 f0                	je     ffff80000010354f <skipelem+0x12>
  if(*path == 0)
ffff80000010355f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103563:	0f b6 00             	movzbl (%rax),%eax
ffff800000103566:	84 c0                	test   %al,%al
ffff800000103568:	75 0a                	jne    ffff800000103574 <skipelem+0x37>
    return 0;
ffff80000010356a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010356f:	e9 9a 00 00 00       	jmp    ffff80000010360e <skipelem+0xd1>
  s = path;
ffff800000103574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103578:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(*path != '/' && *path != 0)
ffff80000010357c:	eb 05                	jmp    ffff800000103583 <skipelem+0x46>
    path++;
ffff80000010357e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path != '/' && *path != 0)
ffff800000103583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103587:	0f b6 00             	movzbl (%rax),%eax
ffff80000010358a:	3c 2f                	cmp    $0x2f,%al
ffff80000010358c:	74 0b                	je     ffff800000103599 <skipelem+0x5c>
ffff80000010358e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103592:	0f b6 00             	movzbl (%rax),%eax
ffff800000103595:	84 c0                	test   %al,%al
ffff800000103597:	75 e5                	jne    ffff80000010357e <skipelem+0x41>
  len = path - s;
ffff800000103599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010359d:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
ffff8000001035a1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(len >= DIRSIZ)
ffff8000001035a4:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
ffff8000001035a8:	7e 21                	jle    ffff8000001035cb <skipelem+0x8e>
    memmove(name, s, DIRSIZ);
ffff8000001035aa:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001035ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001035b2:	ba 0e 00 00 00       	mov    $0xe,%edx
ffff8000001035b7:	48 89 ce             	mov    %rcx,%rsi
ffff8000001035ba:	48 89 c7             	mov    %rax,%rdi
ffff8000001035bd:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff8000001035c4:	80 ff ff 
ffff8000001035c7:	ff d0                	call   *%rax
ffff8000001035c9:	eb 34                	jmp    ffff8000001035ff <skipelem+0xc2>
  else {
    memmove(name, s, len);
ffff8000001035cb:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001035ce:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001035d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001035d6:	48 89 ce             	mov    %rcx,%rsi
ffff8000001035d9:	48 89 c7             	mov    %rax,%rdi
ffff8000001035dc:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff8000001035e3:	80 ff ff 
ffff8000001035e6:	ff d0                	call   *%rax
    name[len] = 0;
ffff8000001035e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001035eb:	48 63 d0             	movslq %eax,%rdx
ffff8000001035ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001035f2:	48 01 d0             	add    %rdx,%rax
ffff8000001035f5:	c6 00 00             	movb   $0x0,(%rax)
  }
  while(*path == '/')
ffff8000001035f8:	eb 05                	jmp    ffff8000001035ff <skipelem+0xc2>
    path++;
ffff8000001035fa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
ffff8000001035ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103603:	0f b6 00             	movzbl (%rax),%eax
ffff800000103606:	3c 2f                	cmp    $0x2f,%al
ffff800000103608:	74 f0                	je     ffff8000001035fa <skipelem+0xbd>
  return path;
ffff80000010360a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff80000010360e:	c9                   	leave
ffff80000010360f:	c3                   	ret

ffff800000103610 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
ffff800000103610:	55                   	push   %rbp
ffff800000103611:	48 89 e5             	mov    %rsp,%rbp
ffff800000103614:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000103618:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010361c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff80000010361f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  struct inode *ip, *next;

  if(*path == '/')
ffff800000103623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103627:	0f b6 00             	movzbl (%rax),%eax
ffff80000010362a:	3c 2f                	cmp    $0x2f,%al
ffff80000010362c:	75 1f                	jne    ffff80000010364d <namex+0x3d>
    ip = iget(ROOTDEV, ROOTINO);
ffff80000010362e:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000103633:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103638:	48 b8 fa 26 10 00 00 	movabs $0xffff8000001026fa,%rax
ffff80000010363f:	80 ff ff 
ffff800000103642:	ff d0                	call   *%rax
ffff800000103644:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103648:	e9 f7 00 00 00       	jmp    ffff800000103744 <namex+0x134>
  else
    ip = idup(proc->cwd);
ffff80000010364d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000103654:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000103658:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff80000010365f:	48 89 c7             	mov    %rax,%rdi
ffff800000103662:	48 b8 37 28 10 00 00 	movabs $0xffff800000102837,%rax
ffff800000103669:	80 ff ff 
ffff80000010366c:	ff d0                	call   *%rax
ffff80000010366e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  while((path = skipelem(path, name)) != 0){
ffff800000103672:	e9 cd 00 00 00       	jmp    ffff800000103744 <namex+0x134>
    ilock(ip);
ffff800000103677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010367b:	48 89 c7             	mov    %rax,%rdi
ffff80000010367e:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000103685:	80 ff ff 
ffff800000103688:	ff d0                	call   *%rax
    if(ip->type != T_DIR){
ffff80000010368a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010368e:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000103695:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000103699:	74 1d                	je     ffff8000001036b8 <namex+0xa8>
      iunlockput(ip);
ffff80000010369b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010369f:	48 89 c7             	mov    %rax,%rdi
ffff8000001036a2:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff8000001036a9:	80 ff ff 
ffff8000001036ac:	ff d0                	call   *%rax
      return 0;
ffff8000001036ae:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001036b3:	e9 d9 00 00 00       	jmp    ffff800000103791 <namex+0x181>
    }
    if(nameiparent && *path == '\0'){
ffff8000001036b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff8000001036bc:	74 27                	je     ffff8000001036e5 <namex+0xd5>
ffff8000001036be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001036c2:	0f b6 00             	movzbl (%rax),%eax
ffff8000001036c5:	84 c0                	test   %al,%al
ffff8000001036c7:	75 1c                	jne    ffff8000001036e5 <namex+0xd5>
      iunlock(ip);  // Stop one level early.
ffff8000001036c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036cd:	48 89 c7             	mov    %rax,%rdi
ffff8000001036d0:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff8000001036d7:	80 ff ff 
ffff8000001036da:	ff d0                	call   *%rax
      return ip;
ffff8000001036dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036e0:	e9 ac 00 00 00       	jmp    ffff800000103791 <namex+0x181>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
ffff8000001036e5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff8000001036e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001036ed:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001036f2:	48 89 ce             	mov    %rcx,%rsi
ffff8000001036f5:	48 89 c7             	mov    %rax,%rdi
ffff8000001036f8:	48 b8 03 33 10 00 00 	movabs $0xffff800000103303,%rax
ffff8000001036ff:	80 ff ff 
ffff800000103702:	ff d0                	call   *%rax
ffff800000103704:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000103708:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010370d:	75 1a                	jne    ffff800000103729 <namex+0x119>
      iunlockput(ip);
ffff80000010370f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103713:	48 89 c7             	mov    %rax,%rdi
ffff800000103716:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff80000010371d:	80 ff ff 
ffff800000103720:	ff d0                	call   *%rax
      return 0;
ffff800000103722:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103727:	eb 68                	jmp    ffff800000103791 <namex+0x181>
    }
    iunlockput(ip);
ffff800000103729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010372d:	48 89 c7             	mov    %rax,%rdi
ffff800000103730:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000103737:	80 ff ff 
ffff80000010373a:	ff d0                	call   *%rax
    ip = next;
ffff80000010373c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000103740:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((path = skipelem(path, name)) != 0){
ffff800000103744:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff800000103748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010374c:	48 89 d6             	mov    %rdx,%rsi
ffff80000010374f:	48 89 c7             	mov    %rax,%rdi
ffff800000103752:	48 b8 3d 35 10 00 00 	movabs $0xffff80000010353d,%rax
ffff800000103759:	80 ff ff 
ffff80000010375c:	ff d0                	call   *%rax
ffff80000010375e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000103762:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000103767:	0f 85 0a ff ff ff    	jne    ffff800000103677 <namex+0x67>
  }
  if(nameiparent){
ffff80000010376d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff800000103771:	74 1a                	je     ffff80000010378d <namex+0x17d>
    iput(ip);
ffff800000103773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103777:	48 89 c7             	mov    %rax,%rdi
ffff80000010377a:	48 b8 8f 2a 10 00 00 	movabs $0xffff800000102a8f,%rax
ffff800000103781:	80 ff ff 
ffff800000103784:	ff d0                	call   *%rax
    return 0;
ffff800000103786:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010378b:	eb 04                	jmp    ffff800000103791 <namex+0x181>
  }
  return ip;
ffff80000010378d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000103791:	c9                   	leave
ffff800000103792:	c3                   	ret

ffff800000103793 <namei>:

struct inode*
namei(char *path)
{
ffff800000103793:	55                   	push   %rbp
ffff800000103794:	48 89 e5             	mov    %rsp,%rbp
ffff800000103797:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010379b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  char name[DIRSIZ];
  return namex(path, 0, name);
ffff80000010379f:	48 8d 55 f2          	lea    -0xe(%rbp),%rdx
ffff8000001037a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001037a7:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001037ac:	48 89 c7             	mov    %rax,%rdi
ffff8000001037af:	48 b8 10 36 10 00 00 	movabs $0xffff800000103610,%rax
ffff8000001037b6:	80 ff ff 
ffff8000001037b9:	ff d0                	call   *%rax
}
ffff8000001037bb:	c9                   	leave
ffff8000001037bc:	c3                   	ret

ffff8000001037bd <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
ffff8000001037bd:	55                   	push   %rbp
ffff8000001037be:	48 89 e5             	mov    %rsp,%rbp
ffff8000001037c1:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001037c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001037c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return namex(path, 1, name);
ffff8000001037cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001037d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001037d5:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001037da:	48 89 c7             	mov    %rax,%rdi
ffff8000001037dd:	48 b8 10 36 10 00 00 	movabs $0xffff800000103610,%rax
ffff8000001037e4:	80 ff ff 
ffff8000001037e7:	ff d0                	call   *%rax
}
ffff8000001037e9:	c9                   	leave
ffff8000001037ea:	c3                   	ret

ffff8000001037eb <inb>:
{
ffff8000001037eb:	55                   	push   %rbp
ffff8000001037ec:	48 89 e5             	mov    %rsp,%rbp
ffff8000001037ef:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001037f3:	89 f8                	mov    %edi,%eax
ffff8000001037f5:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff8000001037f9:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001037fd:	89 c2                	mov    %eax,%edx
ffff8000001037ff:	ec                   	in     (%dx),%al
ffff800000103800:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000103803:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000103807:	c9                   	leave
ffff800000103808:	c3                   	ret

ffff800000103809 <insl>:
{
ffff800000103809:	55                   	push   %rbp
ffff80000010380a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010380d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103811:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103814:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103818:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep insl" :
ffff80000010381b:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010381e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff800000103822:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103825:	48 89 ce             	mov    %rcx,%rsi
ffff800000103828:	48 89 f7             	mov    %rsi,%rdi
ffff80000010382b:	89 c1                	mov    %eax,%ecx
ffff80000010382d:	fc                   	cld
ffff80000010382e:	f3 6d                	rep insl (%dx),(%rdi)
ffff800000103830:	89 c8                	mov    %ecx,%eax
ffff800000103832:	48 89 fe             	mov    %rdi,%rsi
ffff800000103835:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103839:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff80000010383c:	90                   	nop
ffff80000010383d:	c9                   	leave
ffff80000010383e:	c3                   	ret

ffff80000010383f <outb>:
{
ffff80000010383f:	55                   	push   %rbp
ffff800000103840:	48 89 e5             	mov    %rsp,%rbp
ffff800000103843:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103847:	89 fa                	mov    %edi,%edx
ffff800000103849:	89 f0                	mov    %esi,%eax
ffff80000010384b:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff80000010384f:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000103852:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000103856:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010385a:	ee                   	out    %al,(%dx)
}
ffff80000010385b:	90                   	nop
ffff80000010385c:	c9                   	leave
ffff80000010385d:	c3                   	ret

ffff80000010385e <outsl>:
{
ffff80000010385e:	55                   	push   %rbp
ffff80000010385f:	48 89 e5             	mov    %rsp,%rbp
ffff800000103862:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103866:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103869:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff80000010386d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep outsl" :
ffff800000103870:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103873:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff800000103877:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010387a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010387d:	89 c1                	mov    %eax,%ecx
ffff80000010387f:	fc                   	cld
ffff800000103880:	f3 6f                	rep outsl (%rsi),(%dx)
ffff800000103882:	89 c8                	mov    %ecx,%eax
ffff800000103884:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000103888:	89 45 f8             	mov    %eax,-0x8(%rbp)
}
ffff80000010388b:	90                   	nop
ffff80000010388c:	c9                   	leave
ffff80000010388d:	c3                   	ret

ffff80000010388e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
ffff80000010388e:	55                   	push   %rbp
ffff80000010388f:	48 89 e5             	mov    %rsp,%rbp
ffff800000103892:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000103896:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
ffff800000103899:	90                   	nop
ffff80000010389a:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff80000010389f:	48 b8 eb 37 10 00 00 	movabs $0xffff8000001037eb,%rax
ffff8000001038a6:	80 ff ff 
ffff8000001038a9:	ff d0                	call   *%rax
ffff8000001038ab:	0f b6 c0             	movzbl %al,%eax
ffff8000001038ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001038b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001038b4:	25 c0 00 00 00       	and    $0xc0,%eax
ffff8000001038b9:	83 f8 40             	cmp    $0x40,%eax
ffff8000001038bc:	75 dc                	jne    ffff80000010389a <idewait+0xc>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
ffff8000001038be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001038c2:	74 11                	je     ffff8000001038d5 <idewait+0x47>
ffff8000001038c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001038c7:	83 e0 21             	and    $0x21,%eax
ffff8000001038ca:	85 c0                	test   %eax,%eax
ffff8000001038cc:	74 07                	je     ffff8000001038d5 <idewait+0x47>
    return -1;
ffff8000001038ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001038d3:	eb 05                	jmp    ffff8000001038da <idewait+0x4c>
  return 0;
ffff8000001038d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001038da:	c9                   	leave
ffff8000001038db:	c3                   	ret

ffff8000001038dc <ideinit>:

void
ideinit(void)
{
ffff8000001038dc:	55                   	push   %rbp
ffff8000001038dd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001038e0:	48 83 ec 10          	sub    $0x10,%rsp
  initlock(&idelock, "ide");
ffff8000001038e4:	48 ba a3 c8 10 00 00 	movabs $0xffff80000010c8a3,%rdx
ffff8000001038eb:	80 ff ff 
ffff8000001038ee:	48 b8 c0 70 11 00 00 	movabs $0xffff8000001170c0,%rax
ffff8000001038f5:	80 ff ff 
ffff8000001038f8:	48 89 d6             	mov    %rdx,%rsi
ffff8000001038fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001038fe:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000103905:	80 ff ff 
ffff800000103908:	ff d0                	call   *%rax
  ioapicenable(IRQ_IDE, ncpu - 1);
ffff80000010390a:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000103911:	80 ff ff 
ffff800000103914:	8b 00                	mov    (%rax),%eax
ffff800000103916:	83 e8 01             	sub    $0x1,%eax
ffff800000103919:	89 c6                	mov    %eax,%esi
ffff80000010391b:	bf 0e 00 00 00       	mov    $0xe,%edi
ffff800000103920:	48 b8 6e 3f 10 00 00 	movabs $0xffff800000103f6e,%rax
ffff800000103927:	80 ff ff 
ffff80000010392a:	ff d0                	call   *%rax
  idewait(0);
ffff80000010392c:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103931:	48 b8 8e 38 10 00 00 	movabs $0xffff80000010388e,%rax
ffff800000103938:	80 ff ff 
ffff80000010393b:	ff d0                	call   *%rax

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
ffff80000010393d:	be f0 00 00 00       	mov    $0xf0,%esi
ffff800000103942:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103947:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff80000010394e:	80 ff ff 
ffff800000103951:	ff d0                	call   *%rax
  for(int i=0; i<1000; i++){
ffff800000103953:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010395a:	eb 2b                	jmp    ffff800000103987 <ideinit+0xab>
    if(inb(0x1f7) != 0){
ffff80000010395c:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103961:	48 b8 eb 37 10 00 00 	movabs $0xffff8000001037eb,%rax
ffff800000103968:	80 ff ff 
ffff80000010396b:	ff d0                	call   *%rax
ffff80000010396d:	84 c0                	test   %al,%al
ffff80000010396f:	74 12                	je     ffff800000103983 <ideinit+0xa7>
      havedisk1 = 1;
ffff800000103971:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103978:	80 ff ff 
ffff80000010397b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
      break;
ffff800000103981:	eb 0d                	jmp    ffff800000103990 <ideinit+0xb4>
  for(int i=0; i<1000; i++){
ffff800000103983:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103987:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
ffff80000010398e:	7e cc                	jle    ffff80000010395c <ideinit+0x80>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
ffff800000103990:	be e0 00 00 00       	mov    $0xe0,%esi
ffff800000103995:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff80000010399a:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff8000001039a1:	80 ff ff 
ffff8000001039a4:	ff d0                	call   *%rax
}
ffff8000001039a6:	90                   	nop
ffff8000001039a7:	c9                   	leave
ffff8000001039a8:	c3                   	ret

ffff8000001039a9 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
ffff8000001039a9:	55                   	push   %rbp
ffff8000001039aa:	48 89 e5             	mov    %rsp,%rbp
ffff8000001039ad:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001039b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if(b == 0)
ffff8000001039b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001039ba:	75 19                	jne    ffff8000001039d5 <idestart+0x2c>
    panic("idestart");
ffff8000001039bc:	48 b8 a7 c8 10 00 00 	movabs $0xffff80000010c8a7,%rax
ffff8000001039c3:	80 ff ff 
ffff8000001039c6:	48 89 c7             	mov    %rax,%rdi
ffff8000001039c9:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001039d0:	80 ff ff 
ffff8000001039d3:	ff d0                	call   *%rax
  if(b->blockno >= FSSIZE)
ffff8000001039d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001039d9:	8b 40 08             	mov    0x8(%rax),%eax
ffff8000001039dc:	3d e7 03 00 00       	cmp    $0x3e7,%eax
ffff8000001039e1:	76 19                	jbe    ffff8000001039fc <idestart+0x53>
    panic("incorrect blockno");
ffff8000001039e3:	48 b8 b0 c8 10 00 00 	movabs $0xffff80000010c8b0,%rax
ffff8000001039ea:	80 ff ff 
ffff8000001039ed:	48 89 c7             	mov    %rax,%rdi
ffff8000001039f0:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001039f7:	80 ff ff 
ffff8000001039fa:	ff d0                	call   *%rax
  int sector_per_block =  BSIZE/SECTOR_SIZE;
ffff8000001039fc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
  int sector = b->blockno * sector_per_block;
ffff800000103a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103a07:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000103a0a:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103a0d:	0f af c2             	imul   %edx,%eax
ffff800000103a10:	89 45 f0             	mov    %eax,-0x10(%rbp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
ffff800000103a13:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
ffff800000103a17:	75 09                	jne    ffff800000103a22 <idestart+0x79>
ffff800000103a19:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffff800000103a20:	eb 07                	jmp    ffff800000103a29 <idestart+0x80>
ffff800000103a22:	c7 45 fc c4 00 00 00 	movl   $0xc4,-0x4(%rbp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
ffff800000103a29:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
ffff800000103a2d:	75 09                	jne    ffff800000103a38 <idestart+0x8f>
ffff800000103a2f:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
ffff800000103a36:	eb 07                	jmp    ffff800000103a3f <idestart+0x96>
ffff800000103a38:	c7 45 f8 c5 00 00 00 	movl   $0xc5,-0x8(%rbp)

  if (sector_per_block > 7) panic("idestart");
ffff800000103a3f:	83 7d f4 07          	cmpl   $0x7,-0xc(%rbp)
ffff800000103a43:	7e 19                	jle    ffff800000103a5e <idestart+0xb5>
ffff800000103a45:	48 b8 a7 c8 10 00 00 	movabs $0xffff80000010c8a7,%rax
ffff800000103a4c:	80 ff ff 
ffff800000103a4f:	48 89 c7             	mov    %rax,%rdi
ffff800000103a52:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103a59:	80 ff ff 
ffff800000103a5c:	ff d0                	call   *%rax

  idewait(0);
ffff800000103a5e:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103a63:	48 b8 8e 38 10 00 00 	movabs $0xffff80000010388e,%rax
ffff800000103a6a:	80 ff ff 
ffff800000103a6d:	ff d0                	call   *%rax
  outb(0x3f6, 0);  // generate interrupt
ffff800000103a6f:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103a74:	bf f6 03 00 00       	mov    $0x3f6,%edi
ffff800000103a79:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103a80:	80 ff ff 
ffff800000103a83:	ff d0                	call   *%rax
  outb(0x1f2, sector_per_block);  // number of sectors
ffff800000103a85:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000103a88:	0f b6 c0             	movzbl %al,%eax
ffff800000103a8b:	89 c6                	mov    %eax,%esi
ffff800000103a8d:	bf f2 01 00 00       	mov    $0x1f2,%edi
ffff800000103a92:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103a99:	80 ff ff 
ffff800000103a9c:	ff d0                	call   *%rax
  outb(0x1f3, sector & 0xff);
ffff800000103a9e:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103aa1:	0f b6 c0             	movzbl %al,%eax
ffff800000103aa4:	89 c6                	mov    %eax,%esi
ffff800000103aa6:	bf f3 01 00 00       	mov    $0x1f3,%edi
ffff800000103aab:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103ab2:	80 ff ff 
ffff800000103ab5:	ff d0                	call   *%rax
  outb(0x1f4, (sector >> 8) & 0xff);
ffff800000103ab7:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103aba:	c1 f8 08             	sar    $0x8,%eax
ffff800000103abd:	0f b6 c0             	movzbl %al,%eax
ffff800000103ac0:	89 c6                	mov    %eax,%esi
ffff800000103ac2:	bf f4 01 00 00       	mov    $0x1f4,%edi
ffff800000103ac7:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103ace:	80 ff ff 
ffff800000103ad1:	ff d0                	call   *%rax
  outb(0x1f5, (sector >> 16) & 0xff);
ffff800000103ad3:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103ad6:	c1 f8 10             	sar    $0x10,%eax
ffff800000103ad9:	0f b6 c0             	movzbl %al,%eax
ffff800000103adc:	89 c6                	mov    %eax,%esi
ffff800000103ade:	bf f5 01 00 00       	mov    $0x1f5,%edi
ffff800000103ae3:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103aea:	80 ff ff 
ffff800000103aed:	ff d0                	call   *%rax
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
ffff800000103aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103af3:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103af6:	c1 e0 04             	shl    $0x4,%eax
ffff800000103af9:	83 e0 10             	and    $0x10,%eax
ffff800000103afc:	89 c2                	mov    %eax,%edx
ffff800000103afe:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000103b01:	c1 f8 18             	sar    $0x18,%eax
ffff800000103b04:	83 e0 0f             	and    $0xf,%eax
ffff800000103b07:	09 d0                	or     %edx,%eax
ffff800000103b09:	83 c8 e0             	or     $0xffffffe0,%eax
ffff800000103b0c:	0f b6 c0             	movzbl %al,%eax
ffff800000103b0f:	89 c6                	mov    %eax,%esi
ffff800000103b11:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffff800000103b16:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103b1d:	80 ff ff 
ffff800000103b20:	ff d0                	call   *%rax
  if(b->flags & B_DIRTY){
ffff800000103b22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103b26:	8b 00                	mov    (%rax),%eax
ffff800000103b28:	83 e0 04             	and    $0x4,%eax
ffff800000103b2b:	85 c0                	test   %eax,%eax
ffff800000103b2d:	74 3e                	je     ffff800000103b6d <idestart+0x1c4>
    outb(0x1f7, write_cmd);
ffff800000103b2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103b32:	0f b6 c0             	movzbl %al,%eax
ffff800000103b35:	89 c6                	mov    %eax,%esi
ffff800000103b37:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103b3c:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103b43:	80 ff ff 
ffff800000103b46:	ff d0                	call   *%rax
    outsl(0x1f0, b->data, BSIZE/4);
ffff800000103b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103b4c:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103b52:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103b57:	48 89 c6             	mov    %rax,%rsi
ffff800000103b5a:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103b5f:	48 b8 5e 38 10 00 00 	movabs $0xffff80000010385e,%rax
ffff800000103b66:	80 ff ff 
ffff800000103b69:	ff d0                	call   *%rax
  } else {
    outb(0x1f7, read_cmd);
  }
}
ffff800000103b6b:	eb 19                	jmp    ffff800000103b86 <idestart+0x1dd>
    outb(0x1f7, read_cmd);
ffff800000103b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103b70:	0f b6 c0             	movzbl %al,%eax
ffff800000103b73:	89 c6                	mov    %eax,%esi
ffff800000103b75:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffff800000103b7a:	48 b8 3f 38 10 00 00 	movabs $0xffff80000010383f,%rax
ffff800000103b81:	80 ff ff 
ffff800000103b84:	ff d0                	call   *%rax
}
ffff800000103b86:	90                   	nop
ffff800000103b87:	c9                   	leave
ffff800000103b88:	c3                   	ret

ffff800000103b89 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
ffff800000103b89:	55                   	push   %rbp
ffff800000103b8a:	48 89 e5             	mov    %rsp,%rbp
ffff800000103b8d:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
ffff800000103b91:	48 b8 c0 70 11 00 00 	movabs $0xffff8000001170c0,%rax
ffff800000103b98:	80 ff ff 
ffff800000103b9b:	48 89 c7             	mov    %rax,%rdi
ffff800000103b9e:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000103ba5:	80 ff ff 
ffff800000103ba8:	ff d0                	call   *%rax
  if((b = idequeue) == 0){
ffff800000103baa:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103bb1:	80 ff ff 
ffff800000103bb4:	48 8b 00             	mov    (%rax),%rax
ffff800000103bb7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103bbb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000103bc0:	75 1e                	jne    ffff800000103be0 <ideintr+0x57>
    release(&idelock);
ffff800000103bc2:	48 b8 c0 70 11 00 00 	movabs $0xffff8000001170c0,%rax
ffff800000103bc9:	80 ff ff 
ffff800000103bcc:	48 89 c7             	mov    %rax,%rdi
ffff800000103bcf:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000103bd6:	80 ff ff 
ffff800000103bd9:	ff d0                	call   *%rax
    // cprintf("spurious IDE interrupt\n");
    return;
ffff800000103bdb:	e9 d9 00 00 00       	jmp    ffff800000103cb9 <ideintr+0x130>
  }
  idequeue = b->qnext;
ffff800000103be0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103be4:	48 8b 80 a8 00 00 00 	mov    0xa8(%rax),%rax
ffff800000103beb:	48 ba 28 71 11 00 00 	movabs $0xffff800000117128,%rdx
ffff800000103bf2:	80 ff ff 
ffff800000103bf5:	48 89 02             	mov    %rax,(%rdx)

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
ffff800000103bf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103bfc:	8b 00                	mov    (%rax),%eax
ffff800000103bfe:	83 e0 04             	and    $0x4,%eax
ffff800000103c01:	85 c0                	test   %eax,%eax
ffff800000103c03:	75 38                	jne    ffff800000103c3d <ideintr+0xb4>
ffff800000103c05:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103c0a:	48 b8 8e 38 10 00 00 	movabs $0xffff80000010388e,%rax
ffff800000103c11:	80 ff ff 
ffff800000103c14:	ff d0                	call   *%rax
ffff800000103c16:	85 c0                	test   %eax,%eax
ffff800000103c18:	78 23                	js     ffff800000103c3d <ideintr+0xb4>
    insl(0x1f0, b->data, BSIZE/4);
ffff800000103c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c1e:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000103c24:	ba 80 00 00 00       	mov    $0x80,%edx
ffff800000103c29:	48 89 c6             	mov    %rax,%rsi
ffff800000103c2c:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffff800000103c31:	48 b8 09 38 10 00 00 	movabs $0xffff800000103809,%rax
ffff800000103c38:	80 ff ff 
ffff800000103c3b:	ff d0                	call   *%rax

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
ffff800000103c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c41:	8b 00                	mov    (%rax),%eax
ffff800000103c43:	83 c8 02             	or     $0x2,%eax
ffff800000103c46:	89 c2                	mov    %eax,%edx
ffff800000103c48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c4c:	89 10                	mov    %edx,(%rax)
  b->flags &= ~B_DIRTY;
ffff800000103c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c52:	8b 00                	mov    (%rax),%eax
ffff800000103c54:	83 e0 fb             	and    $0xfffffffb,%eax
ffff800000103c57:	89 c2                	mov    %eax,%edx
ffff800000103c59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c5d:	89 10                	mov    %edx,(%rax)
  wakeup(b);
ffff800000103c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103c63:	48 89 c7             	mov    %rax,%rdi
ffff800000103c66:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff800000103c6d:	80 ff ff 
ffff800000103c70:	ff d0                	call   *%rax

  // Start disk on next buf in queue.
  if(idequeue != 0)
ffff800000103c72:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103c79:	80 ff ff 
ffff800000103c7c:	48 8b 00             	mov    (%rax),%rax
ffff800000103c7f:	48 85 c0             	test   %rax,%rax
ffff800000103c82:	74 1c                	je     ffff800000103ca0 <ideintr+0x117>
    idestart(idequeue);
ffff800000103c84:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103c8b:	80 ff ff 
ffff800000103c8e:	48 8b 00             	mov    (%rax),%rax
ffff800000103c91:	48 89 c7             	mov    %rax,%rdi
ffff800000103c94:	48 b8 a9 39 10 00 00 	movabs $0xffff8000001039a9,%rax
ffff800000103c9b:	80 ff ff 
ffff800000103c9e:	ff d0                	call   *%rax

  release(&idelock);
ffff800000103ca0:	48 b8 c0 70 11 00 00 	movabs $0xffff8000001170c0,%rax
ffff800000103ca7:	80 ff ff 
ffff800000103caa:	48 89 c7             	mov    %rax,%rdi
ffff800000103cad:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000103cb4:	80 ff ff 
ffff800000103cb7:	ff d0                	call   *%rax
}
ffff800000103cb9:	c9                   	leave
ffff800000103cba:	c3                   	ret

ffff800000103cbb <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
ffff800000103cbb:	55                   	push   %rbp
ffff800000103cbc:	48 89 e5             	mov    %rsp,%rbp
ffff800000103cbf:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000103cc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf **pp;

  if(!holdingsleep(&b->lock))
ffff800000103cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103ccb:	48 83 c0 10          	add    $0x10,%rax
ffff800000103ccf:	48 89 c7             	mov    %rax,%rdi
ffff800000103cd2:	48 b8 35 7b 10 00 00 	movabs $0xffff800000107b35,%rax
ffff800000103cd9:	80 ff ff 
ffff800000103cdc:	ff d0                	call   *%rax
ffff800000103cde:	85 c0                	test   %eax,%eax
ffff800000103ce0:	75 19                	jne    ffff800000103cfb <iderw+0x40>
    panic("iderw: buf not locked");
ffff800000103ce2:	48 b8 c2 c8 10 00 00 	movabs $0xffff80000010c8c2,%rax
ffff800000103ce9:	80 ff ff 
ffff800000103cec:	48 89 c7             	mov    %rax,%rdi
ffff800000103cef:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103cf6:	80 ff ff 
ffff800000103cf9:	ff d0                	call   *%rax
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
ffff800000103cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103cff:	8b 00                	mov    (%rax),%eax
ffff800000103d01:	83 e0 06             	and    $0x6,%eax
ffff800000103d04:	83 f8 02             	cmp    $0x2,%eax
ffff800000103d07:	75 19                	jne    ffff800000103d22 <iderw+0x67>
    panic("iderw: nothing to do");
ffff800000103d09:	48 b8 d8 c8 10 00 00 	movabs $0xffff80000010c8d8,%rax
ffff800000103d10:	80 ff ff 
ffff800000103d13:	48 89 c7             	mov    %rax,%rdi
ffff800000103d16:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103d1d:	80 ff ff 
ffff800000103d20:	ff d0                	call   *%rax
  if(b->dev != 0 && !havedisk1)
ffff800000103d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d26:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000103d29:	85 c0                	test   %eax,%eax
ffff800000103d2b:	74 29                	je     ffff800000103d56 <iderw+0x9b>
ffff800000103d2d:	48 b8 30 71 11 00 00 	movabs $0xffff800000117130,%rax
ffff800000103d34:	80 ff ff 
ffff800000103d37:	8b 00                	mov    (%rax),%eax
ffff800000103d39:	85 c0                	test   %eax,%eax
ffff800000103d3b:	75 19                	jne    ffff800000103d56 <iderw+0x9b>
    panic("iderw: ide disk 1 not present");
ffff800000103d3d:	48 b8 ed c8 10 00 00 	movabs $0xffff80000010c8ed,%rax
ffff800000103d44:	80 ff ff 
ffff800000103d47:	48 89 c7             	mov    %rax,%rdi
ffff800000103d4a:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000103d51:	80 ff ff 
ffff800000103d54:	ff d0                	call   *%rax

  acquire(&idelock);  //DOC:acquire-lock
ffff800000103d56:	48 b8 c0 70 11 00 00 	movabs $0xffff8000001170c0,%rax
ffff800000103d5d:	80 ff ff 
ffff800000103d60:	48 89 c7             	mov    %rax,%rdi
ffff800000103d63:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000103d6a:	80 ff ff 
ffff800000103d6d:	ff d0                	call   *%rax

  // Append b to idequeue.
  b->qnext = 0;
ffff800000103d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103d73:	48 c7 80 a8 00 00 00 	movq   $0x0,0xa8(%rax)
ffff800000103d7a:	00 00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
ffff800000103d7e:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103d85:	80 ff ff 
ffff800000103d88:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103d8c:	eb 11                	jmp    ffff800000103d9f <iderw+0xe4>
ffff800000103d8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103d92:	48 8b 00             	mov    (%rax),%rax
ffff800000103d95:	48 05 a8 00 00 00    	add    $0xa8,%rax
ffff800000103d9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000103d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103da3:	48 8b 00             	mov    (%rax),%rax
ffff800000103da6:	48 85 c0             	test   %rax,%rax
ffff800000103da9:	75 e3                	jne    ffff800000103d8e <iderw+0xd3>
    ;
  *pp = b;
ffff800000103dab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000103daf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000103db3:	48 89 10             	mov    %rdx,(%rax)

  // Start disk if necessary.
  if(idequeue == b)
ffff800000103db6:	48 b8 28 71 11 00 00 	movabs $0xffff800000117128,%rax
ffff800000103dbd:	80 ff ff 
ffff800000103dc0:	48 8b 00             	mov    (%rax),%rax
ffff800000103dc3:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000103dc7:	75 35                	jne    ffff800000103dfe <iderw+0x143>
    idestart(b);
ffff800000103dc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103dcd:	48 89 c7             	mov    %rax,%rdi
ffff800000103dd0:	48 b8 a9 39 10 00 00 	movabs $0xffff8000001039a9,%rax
ffff800000103dd7:	80 ff ff 
ffff800000103dda:	ff d0                	call   *%rax

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103ddc:	eb 20                	jmp    ffff800000103dfe <iderw+0x143>
    sleep(b, &idelock);
ffff800000103dde:	48 ba c0 70 11 00 00 	movabs $0xffff8000001170c0,%rdx
ffff800000103de5:	80 ff ff 
ffff800000103de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103dec:	48 89 d6             	mov    %rdx,%rsi
ffff800000103def:	48 89 c7             	mov    %rax,%rdi
ffff800000103df2:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000103df9:	80 ff ff 
ffff800000103dfc:	ff d0                	call   *%rax
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffff800000103dfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000103e02:	8b 00                	mov    (%rax),%eax
ffff800000103e04:	83 e0 06             	and    $0x6,%eax
ffff800000103e07:	83 f8 02             	cmp    $0x2,%eax
ffff800000103e0a:	75 d2                	jne    ffff800000103dde <iderw+0x123>
  }

  release(&idelock);
ffff800000103e0c:	48 b8 c0 70 11 00 00 	movabs $0xffff8000001170c0,%rax
ffff800000103e13:	80 ff ff 
ffff800000103e16:	48 89 c7             	mov    %rax,%rdi
ffff800000103e19:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000103e20:	80 ff ff 
ffff800000103e23:	ff d0                	call   *%rax
}
ffff800000103e25:	90                   	nop
ffff800000103e26:	c9                   	leave
ffff800000103e27:	c3                   	ret

ffff800000103e28 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
ffff800000103e28:	55                   	push   %rbp
ffff800000103e29:	48 89 e5             	mov    %rsp,%rbp
ffff800000103e2c:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103e30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  ioapic->reg = reg;
ffff800000103e33:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103e3a:	80 ff ff 
ffff800000103e3d:	48 8b 00             	mov    (%rax),%rax
ffff800000103e40:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103e43:	89 10                	mov    %edx,(%rax)
  return ioapic->data;
ffff800000103e45:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103e4c:	80 ff ff 
ffff800000103e4f:	48 8b 00             	mov    (%rax),%rax
ffff800000103e52:	8b 40 10             	mov    0x10(%rax),%eax
}
ffff800000103e55:	c9                   	leave
ffff800000103e56:	c3                   	ret

ffff800000103e57 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
ffff800000103e57:	55                   	push   %rbp
ffff800000103e58:	48 89 e5             	mov    %rsp,%rbp
ffff800000103e5b:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103e5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103e62:	89 75 f8             	mov    %esi,-0x8(%rbp)
  ioapic->reg = reg;
ffff800000103e65:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103e6c:	80 ff ff 
ffff800000103e6f:	48 8b 00             	mov    (%rax),%rax
ffff800000103e72:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000103e75:	89 10                	mov    %edx,(%rax)
  ioapic->data = data;
ffff800000103e77:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103e7e:	80 ff ff 
ffff800000103e81:	48 8b 00             	mov    (%rax),%rax
ffff800000103e84:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000103e87:	89 50 10             	mov    %edx,0x10(%rax)
}
ffff800000103e8a:	90                   	nop
ffff800000103e8b:	c9                   	leave
ffff800000103e8c:	c3                   	ret

ffff800000103e8d <ioapicinit>:

void
ioapicinit(void)
{
ffff800000103e8d:	55                   	push   %rbp
ffff800000103e8e:	48 89 e5             	mov    %rsp,%rbp
ffff800000103e91:	48 83 ec 10          	sub    $0x10,%rsp
  int i, id, maxintr;

  ioapic = P2V((volatile struct ioapic*)IOAPIC);
ffff800000103e95:	48 b8 38 71 11 00 00 	movabs $0xffff800000117138,%rax
ffff800000103e9c:	80 ff ff 
ffff800000103e9f:	48 b9 00 00 c0 fe 00 	movabs $0xffff8000fec00000,%rcx
ffff800000103ea6:	80 ff ff 
ffff800000103ea9:	48 89 08             	mov    %rcx,(%rax)
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
ffff800000103eac:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000103eb1:	48 b8 28 3e 10 00 00 	movabs $0xffff800000103e28,%rax
ffff800000103eb8:	80 ff ff 
ffff800000103ebb:	ff d0                	call   *%rax
ffff800000103ebd:	c1 e8 10             	shr    $0x10,%eax
ffff800000103ec0:	25 ff 00 00 00       	and    $0xff,%eax
ffff800000103ec5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  id = ioapicread(REG_ID) >> 24;
ffff800000103ec8:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000103ecd:	48 b8 28 3e 10 00 00 	movabs $0xffff800000103e28,%rax
ffff800000103ed4:	80 ff ff 
ffff800000103ed7:	ff d0                	call   *%rax
ffff800000103ed9:	c1 e8 18             	shr    $0x18,%eax
ffff800000103edc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(id != ioapicid)
ffff800000103edf:	48 b8 24 74 11 00 00 	movabs $0xffff800000117424,%rax
ffff800000103ee6:	80 ff ff 
ffff800000103ee9:	0f b6 00             	movzbl (%rax),%eax
ffff800000103eec:	0f b6 c0             	movzbl %al,%eax
ffff800000103eef:	39 45 f4             	cmp    %eax,-0xc(%rbp)
ffff800000103ef2:	74 1e                	je     ffff800000103f12 <ioapicinit+0x85>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
ffff800000103ef4:	48 b8 10 c9 10 00 00 	movabs $0xffff80000010c910,%rax
ffff800000103efb:	80 ff ff 
ffff800000103efe:	48 89 c7             	mov    %rax,%rdi
ffff800000103f01:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000103f06:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000103f0d:	80 ff ff 
ffff800000103f10:	ff d2                	call   *%rdx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
ffff800000103f12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000103f19:	eb 47                	jmp    ffff800000103f62 <ioapicinit+0xd5>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
ffff800000103f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f1e:	83 c0 20             	add    $0x20,%eax
ffff800000103f21:	0d 00 00 01 00       	or     $0x10000,%eax
ffff800000103f26:	89 c2                	mov    %eax,%edx
ffff800000103f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f2b:	83 c0 08             	add    $0x8,%eax
ffff800000103f2e:	01 c0                	add    %eax,%eax
ffff800000103f30:	89 d6                	mov    %edx,%esi
ffff800000103f32:	89 c7                	mov    %eax,%edi
ffff800000103f34:	48 b8 57 3e 10 00 00 	movabs $0xffff800000103e57,%rax
ffff800000103f3b:	80 ff ff 
ffff800000103f3e:	ff d0                	call   *%rax
    ioapicwrite(REG_TABLE+2*i+1, 0);
ffff800000103f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f43:	83 c0 08             	add    $0x8,%eax
ffff800000103f46:	01 c0                	add    %eax,%eax
ffff800000103f48:	83 c0 01             	add    $0x1,%eax
ffff800000103f4b:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000103f50:	89 c7                	mov    %eax,%edi
ffff800000103f52:	48 b8 57 3e 10 00 00 	movabs $0xffff800000103e57,%rax
ffff800000103f59:	80 ff ff 
ffff800000103f5c:	ff d0                	call   *%rax
  for(i = 0; i <= maxintr; i++){
ffff800000103f5e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000103f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f65:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffff800000103f68:	7e b1                	jle    ffff800000103f1b <ioapicinit+0x8e>
  }
}
ffff800000103f6a:	90                   	nop
ffff800000103f6b:	90                   	nop
ffff800000103f6c:	c9                   	leave
ffff800000103f6d:	c3                   	ret

ffff800000103f6e <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
ffff800000103f6e:	55                   	push   %rbp
ffff800000103f6f:	48 89 e5             	mov    %rsp,%rbp
ffff800000103f72:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000103f76:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000103f79:	89 75 f8             	mov    %esi,-0x8(%rbp)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
ffff800000103f7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f7f:	83 c0 20             	add    $0x20,%eax
ffff800000103f82:	89 c2                	mov    %eax,%edx
ffff800000103f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103f87:	83 c0 08             	add    $0x8,%eax
ffff800000103f8a:	01 c0                	add    %eax,%eax
ffff800000103f8c:	89 d6                	mov    %edx,%esi
ffff800000103f8e:	89 c7                	mov    %eax,%edi
ffff800000103f90:	48 b8 57 3e 10 00 00 	movabs $0xffff800000103e57,%rax
ffff800000103f97:	80 ff ff 
ffff800000103f9a:	ff d0                	call   *%rax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
ffff800000103f9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000103f9f:	c1 e0 18             	shl    $0x18,%eax
ffff800000103fa2:	89 c2                	mov    %eax,%edx
ffff800000103fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000103fa7:	83 c0 08             	add    $0x8,%eax
ffff800000103faa:	01 c0                	add    %eax,%eax
ffff800000103fac:	83 c0 01             	add    $0x1,%eax
ffff800000103faf:	89 d6                	mov    %edx,%esi
ffff800000103fb1:	89 c7                	mov    %eax,%edi
ffff800000103fb3:	48 b8 57 3e 10 00 00 	movabs $0xffff800000103e57,%rax
ffff800000103fba:	80 ff ff 
ffff800000103fbd:	ff d0                	call   *%rax
}
ffff800000103fbf:	90                   	nop
ffff800000103fc0:	c9                   	leave
ffff800000103fc1:	c3                   	ret

ffff800000103fc2 <kinit1>:
  struct run *freelist;
} kmem;

void
kinit1(void *vstart, void *vend)
{
ffff800000103fc2:	55                   	push   %rbp
ffff800000103fc3:	48 89 e5             	mov    %rsp,%rbp
ffff800000103fc6:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000103fca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000103fce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&kmem.lock, "kmem");
ffff800000103fd2:	48 ba 42 c9 10 00 00 	movabs $0xffff80000010c942,%rdx
ffff800000103fd9:	80 ff ff 
ffff800000103fdc:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000103fe3:	80 ff ff 
ffff800000103fe6:	48 89 d6             	mov    %rdx,%rsi
ffff800000103fe9:	48 89 c7             	mov    %rax,%rdi
ffff800000103fec:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000103ff3:	80 ff ff 
ffff800000103ff6:	ff d0                	call   *%rax
  kmem.use_lock = 0;
ffff800000103ff8:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000103fff:	80 ff ff 
ffff800000104002:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
  kmem.freelist = 0; // empty
ffff800000104009:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104010:	80 ff ff 
ffff800000104013:	48 c7 40 70 00 00 00 	movq   $0x0,0x70(%rax)
ffff80000010401a:	00 
  freerange(vstart, vend);
ffff80000010401b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010401f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104023:	48 89 d6             	mov    %rdx,%rsi
ffff800000104026:	48 89 c7             	mov    %rax,%rdi
ffff800000104029:	48 b8 50 40 10 00 00 	movabs $0xffff800000104050,%rax
ffff800000104030:	80 ff ff 
ffff800000104033:	ff d0                	call   *%rax
}
ffff800000104035:	90                   	nop
ffff800000104036:	c9                   	leave
ffff800000104037:	c3                   	ret

ffff800000104038 <kinit2>:

void
kinit2()
{
ffff800000104038:	55                   	push   %rbp
ffff800000104039:	48 89 e5             	mov    %rsp,%rbp
  kmem.use_lock = 1;
ffff80000010403c:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104043:	80 ff ff 
ffff800000104046:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%rax)
}
ffff80000010404d:	90                   	nop
ffff80000010404e:	5d                   	pop    %rbp
ffff80000010404f:	c3                   	ret

ffff800000104050 <freerange>:

void
freerange(void *vstart, void *vend)
{
ffff800000104050:	55                   	push   %rbp
ffff800000104051:	48 89 e5             	mov    %rsp,%rbp
ffff800000104054:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000104058:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010405c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *p;
  p = (char*)PGROUNDUP((addr_t)vstart);
ffff800000104060:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104064:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010406a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff800000104070:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff800000104074:	eb 1b                	jmp    ffff800000104091 <freerange+0x41>
    kfree(p);
ffff800000104076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010407a:	48 89 c7             	mov    %rax,%rdi
ffff80000010407d:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff800000104084:	80 ff ff 
ffff800000104087:	ff d0                	call   *%rax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffff800000104089:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff800000104090:	00 
ffff800000104091:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104095:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010409b:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
ffff80000010409f:	73 d5                	jae    ffff800000104076 <freerange+0x26>
}
ffff8000001040a1:	90                   	nop
ffff8000001040a2:	90                   	nop
ffff8000001040a3:	c9                   	leave
ffff8000001040a4:	c3                   	ret

ffff8000001040a5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
ffff8000001040a5:	55                   	push   %rbp
ffff8000001040a6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001040a9:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001040ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct run *r;

  if((addr_t)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
ffff8000001040b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001040b5:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff8000001040ba:	48 85 c0             	test   %rax,%rax
ffff8000001040bd:	75 29                	jne    ffff8000001040e8 <kfree+0x43>
ffff8000001040bf:	48 b8 00 60 12 00 00 	movabs $0xffff800000126000,%rax
ffff8000001040c6:	80 ff ff 
ffff8000001040c9:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff8000001040cd:	72 19                	jb     ffff8000001040e8 <kfree+0x43>
ffff8000001040cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001040d3:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff8000001040da:	80 00 00 
ffff8000001040dd:	48 01 d0             	add    %rdx,%rax
ffff8000001040e0:	48 3d ff ff ff 0d    	cmp    $0xdffffff,%rax
ffff8000001040e6:	76 19                	jbe    ffff800000104101 <kfree+0x5c>
    panic("kfree");
ffff8000001040e8:	48 b8 47 c9 10 00 00 	movabs $0xffff80000010c947,%rax
ffff8000001040ef:	80 ff ff 
ffff8000001040f2:	48 89 c7             	mov    %rax,%rdi
ffff8000001040f5:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001040fc:	80 ff ff 
ffff8000001040ff:	ff d0                	call   *%rax

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
ffff800000104101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104105:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010410a:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010410f:	48 89 c7             	mov    %rax,%rdi
ffff800000104112:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff800000104119:	80 ff ff 
ffff80000010411c:	ff d0                	call   *%rax

  if(kmem.use_lock)
ffff80000010411e:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104125:	80 ff ff 
ffff800000104128:	8b 40 68             	mov    0x68(%rax),%eax
ffff80000010412b:	85 c0                	test   %eax,%eax
ffff80000010412d:	74 19                	je     ffff800000104148 <kfree+0xa3>
    acquire(&kmem.lock);
ffff80000010412f:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104136:	80 ff ff 
ffff800000104139:	48 89 c7             	mov    %rax,%rdi
ffff80000010413c:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000104143:	80 ff ff 
ffff800000104146:	ff d0                	call   *%rax
  r = (struct run*)v;
ffff800000104148:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010414c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  r->next = kmem.freelist;
ffff800000104150:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104157:	80 ff ff 
ffff80000010415a:	48 8b 50 70          	mov    0x70(%rax),%rdx
ffff80000010415e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104162:	48 89 10             	mov    %rdx,(%rax)
  kmem.freelist = r;
ffff800000104165:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff80000010416c:	80 ff ff 
ffff80000010416f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104173:	48 89 42 70          	mov    %rax,0x70(%rdx)
  if(kmem.use_lock)
ffff800000104177:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff80000010417e:	80 ff ff 
ffff800000104181:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104184:	85 c0                	test   %eax,%eax
ffff800000104186:	74 19                	je     ffff8000001041a1 <kfree+0xfc>
    release(&kmem.lock);
ffff800000104188:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff80000010418f:	80 ff ff 
ffff800000104192:	48 89 c7             	mov    %rax,%rdi
ffff800000104195:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010419c:	80 ff ff 
ffff80000010419f:	ff d0                	call   *%rax
}
ffff8000001041a1:	90                   	nop
ffff8000001041a2:	c9                   	leave
ffff8000001041a3:	c3                   	ret

ffff8000001041a4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
ffff8000001041a4:	55                   	push   %rbp
ffff8000001041a5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001041a8:	48 83 ec 10          	sub    $0x10,%rsp
  struct run *r;

  if(kmem.use_lock)
ffff8000001041ac:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001041b3:	80 ff ff 
ffff8000001041b6:	8b 40 68             	mov    0x68(%rax),%eax
ffff8000001041b9:	85 c0                	test   %eax,%eax
ffff8000001041bb:	74 19                	je     ffff8000001041d6 <kalloc+0x32>
    acquire(&kmem.lock);
ffff8000001041bd:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001041c4:	80 ff ff 
ffff8000001041c7:	48 89 c7             	mov    %rax,%rdi
ffff8000001041ca:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff8000001041d1:	80 ff ff 
ffff8000001041d4:	ff d0                	call   *%rax
  r = kmem.freelist;
ffff8000001041d6:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff8000001041dd:	80 ff ff 
ffff8000001041e0:	48 8b 40 70          	mov    0x70(%rax),%rax
ffff8000001041e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(r)
ffff8000001041e8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001041ed:	74 28                	je     ffff800000104217 <kalloc+0x73>
    kmem.freelist = r->next;
ffff8000001041ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001041f3:	48 8b 00             	mov    (%rax),%rax
ffff8000001041f6:	48 ba 40 71 11 00 00 	movabs $0xffff800000117140,%rdx
ffff8000001041fd:	80 ff ff 
ffff800000104200:	48 89 42 70          	mov    %rax,0x70(%rdx)
  else {
    panic("Out of memory!");
  }
  
  if(kmem.use_lock)
ffff800000104204:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff80000010420b:	80 ff ff 
ffff80000010420e:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104211:	85 c0                	test   %eax,%eax
ffff800000104213:	74 34                	je     ffff800000104249 <kalloc+0xa5>
ffff800000104215:	eb 19                	jmp    ffff800000104230 <kalloc+0x8c>
    panic("Out of memory!");
ffff800000104217:	48 b8 4d c9 10 00 00 	movabs $0xffff80000010c94d,%rax
ffff80000010421e:	80 ff ff 
ffff800000104221:	48 89 c7             	mov    %rax,%rdi
ffff800000104224:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010422b:	80 ff ff 
ffff80000010422e:	ff d0                	call   *%rax
    release(&kmem.lock);
ffff800000104230:	48 b8 40 71 11 00 00 	movabs $0xffff800000117140,%rax
ffff800000104237:	80 ff ff 
ffff80000010423a:	48 89 c7             	mov    %rax,%rdi
ffff80000010423d:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000104244:	80 ff ff 
ffff800000104247:	ff d0                	call   *%rax
  return (char*)r;
ffff800000104249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010424d:	c9                   	leave
ffff80000010424e:	c3                   	ret

ffff80000010424f <inb>:
{
ffff80000010424f:	55                   	push   %rbp
ffff800000104250:	48 89 e5             	mov    %rsp,%rbp
ffff800000104253:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000104257:	89 f8                	mov    %edi,%eax
ffff800000104259:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff80000010425d:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104261:	89 c2                	mov    %eax,%edx
ffff800000104263:	ec                   	in     (%dx),%al
ffff800000104264:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000104267:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010426b:	c9                   	leave
ffff80000010426c:	c3                   	ret

ffff80000010426d <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
ffff80000010426d:	55                   	push   %rbp
ffff80000010426e:	48 89 e5             	mov    %rsp,%rbp
ffff800000104271:	48 83 ec 10          	sub    $0x10,%rsp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
ffff800000104275:	bf 64 00 00 00       	mov    $0x64,%edi
ffff80000010427a:	48 b8 4f 42 10 00 00 	movabs $0xffff80000010424f,%rax
ffff800000104281:	80 ff ff 
ffff800000104284:	ff d0                	call   *%rax
ffff800000104286:	0f b6 c0             	movzbl %al,%eax
ffff800000104289:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((st & KBS_DIB) == 0)
ffff80000010428c:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010428f:	83 e0 01             	and    $0x1,%eax
ffff800000104292:	85 c0                	test   %eax,%eax
ffff800000104294:	75 0a                	jne    ffff8000001042a0 <kbdgetc+0x33>
    return -1;
ffff800000104296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010429b:	e9 a4 01 00 00       	jmp    ffff800000104444 <kbdgetc+0x1d7>
  data = inb(KBDATAP);
ffff8000001042a0:	bf 60 00 00 00       	mov    $0x60,%edi
ffff8000001042a5:	48 b8 4f 42 10 00 00 	movabs $0xffff80000010424f,%rax
ffff8000001042ac:	80 ff ff 
ffff8000001042af:	ff d0                	call   *%rax
ffff8000001042b1:	0f b6 c0             	movzbl %al,%eax
ffff8000001042b4:	89 45 fc             	mov    %eax,-0x4(%rbp)

  if(data == 0xE0){
ffff8000001042b7:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%rbp)
ffff8000001042be:	75 27                	jne    ffff8000001042e7 <kbdgetc+0x7a>
    shift |= E0ESC;
ffff8000001042c0:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001042c7:	80 ff ff 
ffff8000001042ca:	8b 00                	mov    (%rax),%eax
ffff8000001042cc:	83 c8 40             	or     $0x40,%eax
ffff8000001042cf:	89 c2                	mov    %eax,%edx
ffff8000001042d1:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001042d8:	80 ff ff 
ffff8000001042db:	89 10                	mov    %edx,(%rax)
    return 0;
ffff8000001042dd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001042e2:	e9 5d 01 00 00       	jmp    ffff800000104444 <kbdgetc+0x1d7>
  } else if(data & 0x80){
ffff8000001042e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001042ea:	25 80 00 00 00       	and    $0x80,%eax
ffff8000001042ef:	85 c0                	test   %eax,%eax
ffff8000001042f1:	74 56                	je     ffff800000104349 <kbdgetc+0xdc>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
ffff8000001042f3:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001042fa:	80 ff ff 
ffff8000001042fd:	8b 00                	mov    (%rax),%eax
ffff8000001042ff:	83 e0 40             	and    $0x40,%eax
ffff800000104302:	85 c0                	test   %eax,%eax
ffff800000104304:	75 04                	jne    ffff80000010430a <kbdgetc+0x9d>
ffff800000104306:	83 65 fc 7f          	andl   $0x7f,-0x4(%rbp)
    shift &= ~(shiftcode[data] | E0ESC);
ffff80000010430a:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff800000104311:	80 ff ff 
ffff800000104314:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104317:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff80000010431b:	83 c8 40             	or     $0x40,%eax
ffff80000010431e:	0f b6 c0             	movzbl %al,%eax
ffff800000104321:	f7 d0                	not    %eax
ffff800000104323:	89 c2                	mov    %eax,%edx
ffff800000104325:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010432c:	80 ff ff 
ffff80000010432f:	8b 00                	mov    (%rax),%eax
ffff800000104331:	21 c2                	and    %eax,%edx
ffff800000104333:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010433a:	80 ff ff 
ffff80000010433d:	89 10                	mov    %edx,(%rax)
    return 0;
ffff80000010433f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104344:	e9 fb 00 00 00       	jmp    ffff800000104444 <kbdgetc+0x1d7>
  } else if(shift & E0ESC){
ffff800000104349:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104350:	80 ff ff 
ffff800000104353:	8b 00                	mov    (%rax),%eax
ffff800000104355:	83 e0 40             	and    $0x40,%eax
ffff800000104358:	85 c0                	test   %eax,%eax
ffff80000010435a:	74 24                	je     ffff800000104380 <kbdgetc+0x113>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
ffff80000010435c:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%rbp)
    shift &= ~E0ESC;
ffff800000104363:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010436a:	80 ff ff 
ffff80000010436d:	8b 00                	mov    (%rax),%eax
ffff80000010436f:	83 e0 bf             	and    $0xffffffbf,%eax
ffff800000104372:	89 c2                	mov    %eax,%edx
ffff800000104374:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010437b:	80 ff ff 
ffff80000010437e:	89 10                	mov    %edx,(%rax)
  }

  shift |= shiftcode[data];
ffff800000104380:	48 ba 20 d0 10 00 00 	movabs $0xffff80000010d020,%rdx
ffff800000104387:	80 ff ff 
ffff80000010438a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010438d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff800000104391:	0f b6 d0             	movzbl %al,%edx
ffff800000104394:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff80000010439b:	80 ff ff 
ffff80000010439e:	8b 00                	mov    (%rax),%eax
ffff8000001043a0:	09 c2                	or     %eax,%edx
ffff8000001043a2:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043a9:	80 ff ff 
ffff8000001043ac:	89 10                	mov    %edx,(%rax)
  shift ^= togglecode[data];
ffff8000001043ae:	48 ba 20 d1 10 00 00 	movabs $0xffff80000010d120,%rdx
ffff8000001043b5:	80 ff ff 
ffff8000001043b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001043bb:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
ffff8000001043bf:	0f b6 d0             	movzbl %al,%edx
ffff8000001043c2:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043c9:	80 ff ff 
ffff8000001043cc:	8b 00                	mov    (%rax),%eax
ffff8000001043ce:	31 c2                	xor    %eax,%edx
ffff8000001043d0:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043d7:	80 ff ff 
ffff8000001043da:	89 10                	mov    %edx,(%rax)
  c = charcode[shift & (CTL | SHIFT)][data];
ffff8000001043dc:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff8000001043e3:	80 ff ff 
ffff8000001043e6:	8b 00                	mov    (%rax),%eax
ffff8000001043e8:	83 e0 03             	and    $0x3,%eax
ffff8000001043eb:	89 c2                	mov    %eax,%edx
ffff8000001043ed:	48 b8 20 d5 10 00 00 	movabs $0xffff80000010d520,%rax
ffff8000001043f4:	80 ff ff 
ffff8000001043f7:	89 d2                	mov    %edx,%edx
ffff8000001043f9:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
ffff8000001043fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104400:	48 01 d0             	add    %rdx,%rax
ffff800000104403:	0f b6 00             	movzbl (%rax),%eax
ffff800000104406:	0f b6 c0             	movzbl %al,%eax
ffff800000104409:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(shift & CAPSLOCK){
ffff80000010440c:	48 b8 b8 71 11 00 00 	movabs $0xffff8000001171b8,%rax
ffff800000104413:	80 ff ff 
ffff800000104416:	8b 00                	mov    (%rax),%eax
ffff800000104418:	83 e0 08             	and    $0x8,%eax
ffff80000010441b:	85 c0                	test   %eax,%eax
ffff80000010441d:	74 22                	je     ffff800000104441 <kbdgetc+0x1d4>
    if('a' <= c && c <= 'z')
ffff80000010441f:	83 7d f8 60          	cmpl   $0x60,-0x8(%rbp)
ffff800000104423:	76 0c                	jbe    ffff800000104431 <kbdgetc+0x1c4>
ffff800000104425:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%rbp)
ffff800000104429:	77 06                	ja     ffff800000104431 <kbdgetc+0x1c4>
      c += 'A' - 'a';
ffff80000010442b:	83 6d f8 20          	subl   $0x20,-0x8(%rbp)
ffff80000010442f:	eb 10                	jmp    ffff800000104441 <kbdgetc+0x1d4>
    else if('A' <= c && c <= 'Z')
ffff800000104431:	83 7d f8 40          	cmpl   $0x40,-0x8(%rbp)
ffff800000104435:	76 0a                	jbe    ffff800000104441 <kbdgetc+0x1d4>
ffff800000104437:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%rbp)
ffff80000010443b:	77 04                	ja     ffff800000104441 <kbdgetc+0x1d4>
      c += 'a' - 'A';
ffff80000010443d:	83 45 f8 20          	addl   $0x20,-0x8(%rbp)
  }
  return c;
ffff800000104441:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff800000104444:	c9                   	leave
ffff800000104445:	c3                   	ret

ffff800000104446 <kbdintr>:

void
kbdintr(void)
{
ffff800000104446:	55                   	push   %rbp
ffff800000104447:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(kbdgetc);
ffff80000010444a:	48 b8 6d 42 10 00 00 	movabs $0xffff80000010426d,%rax
ffff800000104451:	80 ff ff 
ffff800000104454:	48 89 c7             	mov    %rax,%rdi
ffff800000104457:	48 b8 6f 0f 10 00 00 	movabs $0xffff800000100f6f,%rax
ffff80000010445e:	80 ff ff 
ffff800000104461:	ff d0                	call   *%rax
}
ffff800000104463:	90                   	nop
ffff800000104464:	5d                   	pop    %rbp
ffff800000104465:	c3                   	ret

ffff800000104466 <inb>:
{
ffff800000104466:	55                   	push   %rbp
ffff800000104467:	48 89 e5             	mov    %rsp,%rbp
ffff80000010446a:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010446e:	89 f8                	mov    %edi,%eax
ffff800000104470:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000104474:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104478:	89 c2                	mov    %eax,%edx
ffff80000010447a:	ec                   	in     (%dx),%al
ffff80000010447b:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010447e:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000104482:	c9                   	leave
ffff800000104483:	c3                   	ret

ffff800000104484 <outb>:
{
ffff800000104484:	55                   	push   %rbp
ffff800000104485:	48 89 e5             	mov    %rsp,%rbp
ffff800000104488:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010448c:	89 fa                	mov    %edi,%edx
ffff80000010448e:	89 f0                	mov    %esi,%eax
ffff800000104490:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff800000104494:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000104497:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010449b:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010449f:	ee                   	out    %al,(%dx)
}
ffff8000001044a0:	90                   	nop
ffff8000001044a1:	c9                   	leave
ffff8000001044a2:	c3                   	ret

ffff8000001044a3 <readeflags>:
{
ffff8000001044a3:	55                   	push   %rbp
ffff8000001044a4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001044a7:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff8000001044ab:	9c                   	pushf
ffff8000001044ac:	58                   	pop    %rax
ffff8000001044ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff8000001044b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001044b5:	c9                   	leave
ffff8000001044b6:	c3                   	ret

ffff8000001044b7 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
ffff8000001044b7:	55                   	push   %rbp
ffff8000001044b8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001044bb:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001044bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001044c2:	89 75 f8             	mov    %esi,-0x8(%rbp)
  lapic[index] = value;
ffff8000001044c5:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001044cc:	80 ff ff 
ffff8000001044cf:	48 8b 00             	mov    (%rax),%rax
ffff8000001044d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001044d5:	48 63 d2             	movslq %edx,%rdx
ffff8000001044d8:	48 c1 e2 02          	shl    $0x2,%rdx
ffff8000001044dc:	48 01 c2             	add    %rax,%rdx
ffff8000001044df:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001044e2:	89 02                	mov    %eax,(%rdx)
  lapic[ID];  // wait for write to finish, by reading
ffff8000001044e4:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001044eb:	80 ff ff 
ffff8000001044ee:	48 8b 00             	mov    (%rax),%rax
ffff8000001044f1:	48 83 c0 20          	add    $0x20,%rax
ffff8000001044f5:	8b 00                	mov    (%rax),%eax
}
ffff8000001044f7:	90                   	nop
ffff8000001044f8:	c9                   	leave
ffff8000001044f9:	c3                   	ret

ffff8000001044fa <lapicinit>:

void
lapicinit(void)
{
ffff8000001044fa:	55                   	push   %rbp
ffff8000001044fb:	48 89 e5             	mov    %rsp,%rbp
  if(!lapic)
ffff8000001044fe:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104505:	80 ff ff 
ffff800000104508:	48 8b 00             	mov    (%rax),%rax
ffff80000010450b:	48 85 c0             	test   %rax,%rax
ffff80000010450e:	0f 84 71 01 00 00    	je     ffff800000104685 <lapicinit+0x18b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
ffff800000104514:	be 3f 01 00 00       	mov    $0x13f,%esi
ffff800000104519:	bf 3c 00 00 00       	mov    $0x3c,%edi
ffff80000010451e:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104525:	80 ff ff 
ffff800000104528:	ff d0                	call   *%rax

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
ffff80000010452a:	be 0b 00 00 00       	mov    $0xb,%esi
ffff80000010452f:	bf f8 00 00 00       	mov    $0xf8,%edi
ffff800000104534:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff80000010453b:	80 ff ff 
ffff80000010453e:	ff d0                	call   *%rax
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
ffff800000104540:	be 20 00 02 00       	mov    $0x20020,%esi
ffff800000104545:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff80000010454a:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104551:	80 ff ff 
ffff800000104554:	ff d0                	call   *%rax
  lapicw(TICR, 10000000);
ffff800000104556:	be 80 96 98 00       	mov    $0x989680,%esi
ffff80000010455b:	bf e0 00 00 00       	mov    $0xe0,%edi
ffff800000104560:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104567:	80 ff ff 
ffff80000010456a:	ff d0                	call   *%rax

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
ffff80000010456c:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104571:	bf d4 00 00 00       	mov    $0xd4,%edi
ffff800000104576:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff80000010457d:	80 ff ff 
ffff800000104580:	ff d0                	call   *%rax
  lapicw(LINT1, MASKED);
ffff800000104582:	be 00 00 01 00       	mov    $0x10000,%esi
ffff800000104587:	bf d8 00 00 00       	mov    $0xd8,%edi
ffff80000010458c:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104593:	80 ff ff 
ffff800000104596:	ff d0                	call   *%rax

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
ffff800000104598:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff80000010459f:	80 ff ff 
ffff8000001045a2:	48 8b 00             	mov    (%rax),%rax
ffff8000001045a5:	48 83 c0 30          	add    $0x30,%rax
ffff8000001045a9:	8b 00                	mov    (%rax),%eax
ffff8000001045ab:	25 00 00 fc 00       	and    $0xfc0000,%eax
ffff8000001045b0:	85 c0                	test   %eax,%eax
ffff8000001045b2:	74 16                	je     ffff8000001045ca <lapicinit+0xd0>
    lapicw(PCINT, MASKED);
ffff8000001045b4:	be 00 00 01 00       	mov    $0x10000,%esi
ffff8000001045b9:	bf d0 00 00 00       	mov    $0xd0,%edi
ffff8000001045be:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff8000001045c5:	80 ff ff 
ffff8000001045c8:	ff d0                	call   *%rax

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
ffff8000001045ca:	be 33 00 00 00       	mov    $0x33,%esi
ffff8000001045cf:	bf dc 00 00 00       	mov    $0xdc,%edi
ffff8000001045d4:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff8000001045db:	80 ff ff 
ffff8000001045de:	ff d0                	call   *%rax

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
ffff8000001045e0:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001045e5:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff8000001045ea:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff8000001045f1:	80 ff ff 
ffff8000001045f4:	ff d0                	call   *%rax
  lapicw(ESR, 0);
ffff8000001045f6:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001045fb:	bf a0 00 00 00       	mov    $0xa0,%edi
ffff800000104600:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104607:	80 ff ff 
ffff80000010460a:	ff d0                	call   *%rax

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
ffff80000010460c:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104611:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff800000104616:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff80000010461d:	80 ff ff 
ffff800000104620:	ff d0                	call   *%rax

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
ffff800000104622:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104627:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff80000010462c:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104633:	80 ff ff 
ffff800000104636:	ff d0                	call   *%rax
  lapicw(ICRLO, BCAST | INIT | LEVEL);
ffff800000104638:	be 00 85 08 00       	mov    $0x88500,%esi
ffff80000010463d:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104642:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104649:	80 ff ff 
ffff80000010464c:	ff d0                	call   *%rax
  while(lapic[ICRLO] & DELIVS)
ffff80000010464e:	90                   	nop
ffff80000010464f:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104656:	80 ff ff 
ffff800000104659:	48 8b 00             	mov    (%rax),%rax
ffff80000010465c:	48 05 00 03 00 00    	add    $0x300,%rax
ffff800000104662:	8b 00                	mov    (%rax),%eax
ffff800000104664:	25 00 10 00 00       	and    $0x1000,%eax
ffff800000104669:	85 c0                	test   %eax,%eax
ffff80000010466b:	75 e2                	jne    ffff80000010464f <lapicinit+0x155>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
ffff80000010466d:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000104672:	bf 20 00 00 00       	mov    $0x20,%edi
ffff800000104677:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff80000010467e:	80 ff ff 
ffff800000104681:	ff d0                	call   *%rax
ffff800000104683:	eb 01                	jmp    ffff800000104686 <lapicinit+0x18c>
    return;
ffff800000104685:	90                   	nop
}
ffff800000104686:	5d                   	pop    %rbp
ffff800000104687:	c3                   	ret

ffff800000104688 <cpunum>:

int
cpunum(void)
{
ffff800000104688:	55                   	push   %rbp
ffff800000104689:	48 89 e5             	mov    %rsp,%rbp
ffff80000010468c:	48 83 ec 10          	sub    $0x10,%rsp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
ffff800000104690:	48 b8 a3 44 10 00 00 	movabs $0xffff8000001044a3,%rax
ffff800000104697:	80 ff ff 
ffff80000010469a:	ff d0                	call   *%rax
ffff80000010469c:	25 00 02 00 00       	and    $0x200,%eax
ffff8000001046a1:	48 85 c0             	test   %rax,%rax
ffff8000001046a4:	74 47                	je     ffff8000001046ed <cpunum+0x65>
    static int n;
    if(n++ == 0)
ffff8000001046a6:	48 b8 c8 71 11 00 00 	movabs $0xffff8000001171c8,%rax
ffff8000001046ad:	80 ff ff 
ffff8000001046b0:	8b 00                	mov    (%rax),%eax
ffff8000001046b2:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001046b5:	48 b9 c8 71 11 00 00 	movabs $0xffff8000001171c8,%rcx
ffff8000001046bc:	80 ff ff 
ffff8000001046bf:	89 11                	mov    %edx,(%rcx)
ffff8000001046c1:	85 c0                	test   %eax,%eax
ffff8000001046c3:	75 28                	jne    ffff8000001046ed <cpunum+0x65>
      cprintf("cpu called from %x with interrupts enabled\n",
ffff8000001046c5:	48 8b 45 08          	mov    0x8(%rbp),%rax
ffff8000001046c9:	48 89 c2             	mov    %rax,%rdx
ffff8000001046cc:	48 b8 60 c9 10 00 00 	movabs $0xffff80000010c960,%rax
ffff8000001046d3:	80 ff ff 
ffff8000001046d6:	48 89 d6             	mov    %rdx,%rsi
ffff8000001046d9:	48 89 c7             	mov    %rax,%rdi
ffff8000001046dc:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001046e1:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff8000001046e8:	80 ff ff 
ffff8000001046eb:	ff d2                	call   *%rdx
        __builtin_return_address(0));
  }

  if (!lapic)
ffff8000001046ed:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff8000001046f4:	80 ff ff 
ffff8000001046f7:	48 8b 00             	mov    (%rax),%rax
ffff8000001046fa:	48 85 c0             	test   %rax,%rax
ffff8000001046fd:	75 0a                	jne    ffff800000104709 <cpunum+0x81>
    return 0;
ffff8000001046ff:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104704:	e9 85 00 00 00       	jmp    ffff80000010478e <cpunum+0x106>

  apicid = lapic[ID] >> 24;
ffff800000104709:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000104710:	80 ff ff 
ffff800000104713:	48 8b 00             	mov    (%rax),%rax
ffff800000104716:	48 83 c0 20          	add    $0x20,%rax
ffff80000010471a:	8b 00                	mov    (%rax),%eax
ffff80000010471c:	c1 e8 18             	shr    $0x18,%eax
ffff80000010471f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < ncpu; ++i) {
ffff800000104722:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104729:	eb 39                	jmp    ffff800000104764 <cpunum+0xdc>
    if (cpus[i].apicid == apicid)
ffff80000010472b:	48 b9 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rcx
ffff800000104732:	80 ff ff 
ffff800000104735:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104738:	48 63 d0             	movslq %eax,%rdx
ffff80000010473b:	48 89 d0             	mov    %rdx,%rax
ffff80000010473e:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000104742:	48 01 d0             	add    %rdx,%rax
ffff800000104745:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000104749:	48 01 c8             	add    %rcx,%rax
ffff80000010474c:	48 83 c0 01          	add    $0x1,%rax
ffff800000104750:	0f b6 00             	movzbl (%rax),%eax
ffff800000104753:	0f b6 c0             	movzbl %al,%eax
ffff800000104756:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff800000104759:	75 05                	jne    ffff800000104760 <cpunum+0xd8>
      return i;
ffff80000010475b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010475e:	eb 2e                	jmp    ffff80000010478e <cpunum+0x106>
  for (i = 0; i < ncpu; ++i) {
ffff800000104760:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104764:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff80000010476b:	80 ff ff 
ffff80000010476e:	8b 00                	mov    (%rax),%eax
ffff800000104770:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104773:	7c b6                	jl     ffff80000010472b <cpunum+0xa3>
  }
  panic("unknown apicid\n");
ffff800000104775:	48 b8 8c c9 10 00 00 	movabs $0xffff80000010c98c,%rax
ffff80000010477c:	80 ff ff 
ffff80000010477f:	48 89 c7             	mov    %rax,%rdi
ffff800000104782:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000104789:	80 ff ff 
ffff80000010478c:	ff d0                	call   *%rax
}
ffff80000010478e:	c9                   	leave
ffff80000010478f:	c3                   	ret

ffff800000104790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
ffff800000104790:	55                   	push   %rbp
ffff800000104791:	48 89 e5             	mov    %rsp,%rbp
  if(lapic)
ffff800000104794:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff80000010479b:	80 ff ff 
ffff80000010479e:	48 8b 00             	mov    (%rax),%rax
ffff8000001047a1:	48 85 c0             	test   %rax,%rax
ffff8000001047a4:	74 16                	je     ffff8000001047bc <lapiceoi+0x2c>
    lapicw(EOI, 0);
ffff8000001047a6:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001047ab:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffff8000001047b0:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff8000001047b7:	80 ff ff 
ffff8000001047ba:	ff d0                	call   *%rax
}
ffff8000001047bc:	90                   	nop
ffff8000001047bd:	5d                   	pop    %rbp
ffff8000001047be:	c3                   	ret

ffff8000001047bf <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
ffff8000001047bf:	55                   	push   %rbp
ffff8000001047c0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001047c3:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001047c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
}
ffff8000001047ca:	90                   	nop
ffff8000001047cb:	c9                   	leave
ffff8000001047cc:	c3                   	ret

ffff8000001047cd <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
ffff8000001047cd:	55                   	push   %rbp
ffff8000001047ce:	48 89 e5             	mov    %rsp,%rbp
ffff8000001047d1:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001047d5:	89 f8                	mov    %edi,%eax
ffff8000001047d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffff8000001047da:	88 45 ec             	mov    %al,-0x14(%rbp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
ffff8000001047dd:	be 0f 00 00 00       	mov    $0xf,%esi
ffff8000001047e2:	bf 70 00 00 00       	mov    $0x70,%edi
ffff8000001047e7:	48 b8 84 44 10 00 00 	movabs $0xffff800000104484,%rax
ffff8000001047ee:	80 ff ff 
ffff8000001047f1:	ff d0                	call   *%rax
  outb(CMOS_PORT+1, 0x0A);
ffff8000001047f3:	be 0a 00 00 00       	mov    $0xa,%esi
ffff8000001047f8:	bf 71 00 00 00       	mov    $0x71,%edi
ffff8000001047fd:	48 b8 84 44 10 00 00 	movabs $0xffff800000104484,%rax
ffff800000104804:	80 ff ff 
ffff800000104807:	ff d0                	call   *%rax
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
ffff800000104809:	48 b8 67 04 00 00 00 	movabs $0xffff800000000467,%rax
ffff800000104810:	80 ff ff 
ffff800000104813:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  wrv[0] = 0;
ffff800000104817:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010481b:	66 c7 00 00 00       	movw   $0x0,(%rax)
  wrv[1] = addr >> 4;
ffff800000104820:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104823:	c1 e8 04             	shr    $0x4,%eax
ffff800000104826:	89 c2                	mov    %eax,%edx
ffff800000104828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010482c:	48 83 c0 02          	add    $0x2,%rax
ffff800000104830:	66 89 10             	mov    %dx,(%rax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
ffff800000104833:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff800000104837:	c1 e0 18             	shl    $0x18,%eax
ffff80000010483a:	89 c6                	mov    %eax,%esi
ffff80000010483c:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff800000104841:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104848:	80 ff ff 
ffff80000010484b:	ff d0                	call   *%rax
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
ffff80000010484d:	be 00 c5 00 00       	mov    $0xc500,%esi
ffff800000104852:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff800000104857:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff80000010485e:	80 ff ff 
ffff800000104861:	ff d0                	call   *%rax
  microdelay(200);
ffff800000104863:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104868:	48 b8 bf 47 10 00 00 	movabs $0xffff8000001047bf,%rax
ffff80000010486f:	80 ff ff 
ffff800000104872:	ff d0                	call   *%rax
  lapicw(ICRLO, INIT | LEVEL);
ffff800000104874:	be 00 85 00 00       	mov    $0x8500,%esi
ffff800000104879:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff80000010487e:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff800000104885:	80 ff ff 
ffff800000104888:	ff d0                	call   *%rax
  microdelay(100);    // should be 10ms, but too slow in Bochs!
ffff80000010488a:	bf 64 00 00 00       	mov    $0x64,%edi
ffff80000010488f:	48 b8 bf 47 10 00 00 	movabs $0xffff8000001047bf,%rax
ffff800000104896:	80 ff ff 
ffff800000104899:	ff d0                	call   *%rax
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
ffff80000010489b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001048a2:	eb 4b                	jmp    ffff8000001048ef <lapicstartap+0x122>
    lapicw(ICRHI, apicid<<24);
ffff8000001048a4:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffff8000001048a8:	c1 e0 18             	shl    $0x18,%eax
ffff8000001048ab:	89 c6                	mov    %eax,%esi
ffff8000001048ad:	bf c4 00 00 00       	mov    $0xc4,%edi
ffff8000001048b2:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff8000001048b9:	80 ff ff 
ffff8000001048bc:	ff d0                	call   *%rax
    lapicw(ICRLO, STARTUP | (addr>>12));
ffff8000001048be:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001048c1:	c1 e8 0c             	shr    $0xc,%eax
ffff8000001048c4:	80 cc 06             	or     $0x6,%ah
ffff8000001048c7:	89 c6                	mov    %eax,%esi
ffff8000001048c9:	bf c0 00 00 00       	mov    $0xc0,%edi
ffff8000001048ce:	48 b8 b7 44 10 00 00 	movabs $0xffff8000001044b7,%rax
ffff8000001048d5:	80 ff ff 
ffff8000001048d8:	ff d0                	call   *%rax
    microdelay(200);
ffff8000001048da:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff8000001048df:	48 b8 bf 47 10 00 00 	movabs $0xffff8000001047bf,%rax
ffff8000001048e6:	80 ff ff 
ffff8000001048e9:	ff d0                	call   *%rax
  for(i = 0; i < 2; i++){
ffff8000001048eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001048ef:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff8000001048f3:	7e af                	jle    ffff8000001048a4 <lapicstartap+0xd7>
  }
}
ffff8000001048f5:	90                   	nop
ffff8000001048f6:	90                   	nop
ffff8000001048f7:	c9                   	leave
ffff8000001048f8:	c3                   	ret

ffff8000001048f9 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
ffff8000001048f9:	55                   	push   %rbp
ffff8000001048fa:	48 89 e5             	mov    %rsp,%rbp
ffff8000001048fd:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000104901:	89 7d fc             	mov    %edi,-0x4(%rbp)
  outb(CMOS_PORT,  reg);
ffff800000104904:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104907:	0f b6 c0             	movzbl %al,%eax
ffff80000010490a:	89 c6                	mov    %eax,%esi
ffff80000010490c:	bf 70 00 00 00       	mov    $0x70,%edi
ffff800000104911:	48 b8 84 44 10 00 00 	movabs $0xffff800000104484,%rax
ffff800000104918:	80 ff ff 
ffff80000010491b:	ff d0                	call   *%rax
  microdelay(200);
ffff80000010491d:	bf c8 00 00 00       	mov    $0xc8,%edi
ffff800000104922:	48 b8 bf 47 10 00 00 	movabs $0xffff8000001047bf,%rax
ffff800000104929:	80 ff ff 
ffff80000010492c:	ff d0                	call   *%rax

  return inb(CMOS_RETURN);
ffff80000010492e:	bf 71 00 00 00       	mov    $0x71,%edi
ffff800000104933:	48 b8 66 44 10 00 00 	movabs $0xffff800000104466,%rax
ffff80000010493a:	80 ff ff 
ffff80000010493d:	ff d0                	call   *%rax
ffff80000010493f:	0f b6 c0             	movzbl %al,%eax
}
ffff800000104942:	c9                   	leave
ffff800000104943:	c3                   	ret

ffff800000104944 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
ffff800000104944:	55                   	push   %rbp
ffff800000104945:	48 89 e5             	mov    %rsp,%rbp
ffff800000104948:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010494c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  r->second = cmos_read(SECS);
ffff800000104950:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000104955:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff80000010495c:	80 ff ff 
ffff80000010495f:	ff d0                	call   *%rax
ffff800000104961:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104965:	89 02                	mov    %eax,(%rdx)
  r->minute = cmos_read(MINS);
ffff800000104967:	bf 02 00 00 00       	mov    $0x2,%edi
ffff80000010496c:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff800000104973:	80 ff ff 
ffff800000104976:	ff d0                	call   *%rax
ffff800000104978:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010497c:	89 42 04             	mov    %eax,0x4(%rdx)
  r->hour   = cmos_read(HOURS);
ffff80000010497f:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000104984:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff80000010498b:	80 ff ff 
ffff80000010498e:	ff d0                	call   *%rax
ffff800000104990:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104994:	89 42 08             	mov    %eax,0x8(%rdx)
  r->day    = cmos_read(DAY);
ffff800000104997:	bf 07 00 00 00       	mov    $0x7,%edi
ffff80000010499c:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff8000001049a3:	80 ff ff 
ffff8000001049a6:	ff d0                	call   *%rax
ffff8000001049a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001049ac:	89 42 0c             	mov    %eax,0xc(%rdx)
  r->month  = cmos_read(MONTH);
ffff8000001049af:	bf 08 00 00 00       	mov    $0x8,%edi
ffff8000001049b4:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff8000001049bb:	80 ff ff 
ffff8000001049be:	ff d0                	call   *%rax
ffff8000001049c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001049c4:	89 42 10             	mov    %eax,0x10(%rdx)
  r->year   = cmos_read(YEAR);
ffff8000001049c7:	bf 09 00 00 00       	mov    $0x9,%edi
ffff8000001049cc:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff8000001049d3:	80 ff ff 
ffff8000001049d6:	ff d0                	call   *%rax
ffff8000001049d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001049dc:	89 42 14             	mov    %eax,0x14(%rdx)
}
ffff8000001049df:	90                   	nop
ffff8000001049e0:	c9                   	leave
ffff8000001049e1:	c3                   	ret

ffff8000001049e2 <cmostime>:
//PAGEBREAK!

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
ffff8000001049e2:	55                   	push   %rbp
ffff8000001049e3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001049e6:	48 83 ec 50          	sub    $0x50,%rsp
ffff8000001049ea:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
ffff8000001049ee:	bf 0b 00 00 00       	mov    $0xb,%edi
ffff8000001049f3:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff8000001049fa:	80 ff ff 
ffff8000001049fd:	ff d0                	call   *%rax
ffff8000001049ff:	89 45 fc             	mov    %eax,-0x4(%rbp)

  bcd = (sb & (1 << 2)) == 0;
ffff800000104a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104a05:	83 e0 04             	and    $0x4,%eax
ffff800000104a08:	c1 e8 02             	shr    $0x2,%eax
ffff800000104a0b:	83 e0 01             	and    $0x1,%eax
ffff800000104a0e:	83 f0 01             	xor    $0x1,%eax
ffff800000104a11:	0f b6 c0             	movzbl %al,%eax
ffff800000104a14:	89 45 f8             	mov    %eax,-0x8(%rbp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
ffff800000104a17:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104a1b:	48 89 c7             	mov    %rax,%rdi
ffff800000104a1e:	48 b8 44 49 10 00 00 	movabs $0xffff800000104944,%rax
ffff800000104a25:	80 ff ff 
ffff800000104a28:	ff d0                	call   *%rax
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
ffff800000104a2a:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff800000104a2f:	48 b8 f9 48 10 00 00 	movabs $0xffff8000001048f9,%rax
ffff800000104a36:	80 ff ff 
ffff800000104a39:	ff d0                	call   *%rax
ffff800000104a3b:	25 80 00 00 00       	and    $0x80,%eax
ffff800000104a40:	85 c0                	test   %eax,%eax
ffff800000104a42:	75 38                	jne    ffff800000104a7c <cmostime+0x9a>
        continue;
    fill_rtcdate(&t2);
ffff800000104a44:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000104a48:	48 89 c7             	mov    %rax,%rdi
ffff800000104a4b:	48 b8 44 49 10 00 00 	movabs $0xffff800000104944,%rax
ffff800000104a52:	80 ff ff 
ffff800000104a55:	ff d0                	call   *%rax
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
ffff800000104a57:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
ffff800000104a5b:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000104a5f:	ba 18 00 00 00       	mov    $0x18,%edx
ffff800000104a64:	48 89 ce             	mov    %rcx,%rsi
ffff800000104a67:	48 89 c7             	mov    %rax,%rdi
ffff800000104a6a:	48 b8 27 80 10 00 00 	movabs $0xffff800000108027,%rax
ffff800000104a71:	80 ff ff 
ffff800000104a74:	ff d0                	call   *%rax
ffff800000104a76:	85 c0                	test   %eax,%eax
ffff800000104a78:	74 05                	je     ffff800000104a7f <cmostime+0x9d>
ffff800000104a7a:	eb 9b                	jmp    ffff800000104a17 <cmostime+0x35>
        continue;
ffff800000104a7c:	90                   	nop
    fill_rtcdate(&t1);
ffff800000104a7d:	eb 98                	jmp    ffff800000104a17 <cmostime+0x35>
      break;
ffff800000104a7f:	90                   	nop
  }

  // convert
  if(bcd) {
ffff800000104a80:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff800000104a84:	0f 84 b4 00 00 00    	je     ffff800000104b3e <cmostime+0x15c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
ffff800000104a8a:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104a8d:	c1 e8 04             	shr    $0x4,%eax
ffff800000104a90:	89 c2                	mov    %eax,%edx
ffff800000104a92:	89 d0                	mov    %edx,%eax
ffff800000104a94:	c1 e0 02             	shl    $0x2,%eax
ffff800000104a97:	01 d0                	add    %edx,%eax
ffff800000104a99:	01 c0                	add    %eax,%eax
ffff800000104a9b:	89 c2                	mov    %eax,%edx
ffff800000104a9d:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104aa0:	83 e0 0f             	and    $0xf,%eax
ffff800000104aa3:	01 d0                	add    %edx,%eax
ffff800000104aa5:	89 45 e0             	mov    %eax,-0x20(%rbp)
    CONV(minute);
ffff800000104aa8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104aab:	c1 e8 04             	shr    $0x4,%eax
ffff800000104aae:	89 c2                	mov    %eax,%edx
ffff800000104ab0:	89 d0                	mov    %edx,%eax
ffff800000104ab2:	c1 e0 02             	shl    $0x2,%eax
ffff800000104ab5:	01 d0                	add    %edx,%eax
ffff800000104ab7:	01 c0                	add    %eax,%eax
ffff800000104ab9:	89 c2                	mov    %eax,%edx
ffff800000104abb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104abe:	83 e0 0f             	and    $0xf,%eax
ffff800000104ac1:	01 d0                	add    %edx,%eax
ffff800000104ac3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    CONV(hour  );
ffff800000104ac6:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104ac9:	c1 e8 04             	shr    $0x4,%eax
ffff800000104acc:	89 c2                	mov    %eax,%edx
ffff800000104ace:	89 d0                	mov    %edx,%eax
ffff800000104ad0:	c1 e0 02             	shl    $0x2,%eax
ffff800000104ad3:	01 d0                	add    %edx,%eax
ffff800000104ad5:	01 c0                	add    %eax,%eax
ffff800000104ad7:	89 c2                	mov    %eax,%edx
ffff800000104ad9:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104adc:	83 e0 0f             	and    $0xf,%eax
ffff800000104adf:	01 d0                	add    %edx,%eax
ffff800000104ae1:	89 45 e8             	mov    %eax,-0x18(%rbp)
    CONV(day   );
ffff800000104ae4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104ae7:	c1 e8 04             	shr    $0x4,%eax
ffff800000104aea:	89 c2                	mov    %eax,%edx
ffff800000104aec:	89 d0                	mov    %edx,%eax
ffff800000104aee:	c1 e0 02             	shl    $0x2,%eax
ffff800000104af1:	01 d0                	add    %edx,%eax
ffff800000104af3:	01 c0                	add    %eax,%eax
ffff800000104af5:	89 c2                	mov    %eax,%edx
ffff800000104af7:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104afa:	83 e0 0f             	and    $0xf,%eax
ffff800000104afd:	01 d0                	add    %edx,%eax
ffff800000104aff:	89 45 ec             	mov    %eax,-0x14(%rbp)
    CONV(month );
ffff800000104b02:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104b05:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b08:	89 c2                	mov    %eax,%edx
ffff800000104b0a:	89 d0                	mov    %edx,%eax
ffff800000104b0c:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b0f:	01 d0                	add    %edx,%eax
ffff800000104b11:	01 c0                	add    %eax,%eax
ffff800000104b13:	89 c2                	mov    %eax,%edx
ffff800000104b15:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104b18:	83 e0 0f             	and    $0xf,%eax
ffff800000104b1b:	01 d0                	add    %edx,%eax
ffff800000104b1d:	89 45 f0             	mov    %eax,-0x10(%rbp)
    CONV(year  );
ffff800000104b20:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104b23:	c1 e8 04             	shr    $0x4,%eax
ffff800000104b26:	89 c2                	mov    %eax,%edx
ffff800000104b28:	89 d0                	mov    %edx,%eax
ffff800000104b2a:	c1 e0 02             	shl    $0x2,%eax
ffff800000104b2d:	01 d0                	add    %edx,%eax
ffff800000104b2f:	01 c0                	add    %eax,%eax
ffff800000104b31:	89 c2                	mov    %eax,%edx
ffff800000104b33:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000104b36:	83 e0 0f             	and    $0xf,%eax
ffff800000104b39:	01 d0                	add    %edx,%eax
ffff800000104b3b:	89 45 f4             	mov    %eax,-0xc(%rbp)
#undef     CONV
  }

  *r = t1;
ffff800000104b3e:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
ffff800000104b42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000104b46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000104b4a:	48 89 01             	mov    %rax,(%rcx)
ffff800000104b4d:	48 89 51 08          	mov    %rdx,0x8(%rcx)
ffff800000104b51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104b55:	48 89 41 10          	mov    %rax,0x10(%rcx)
  r->year += 2000;
ffff800000104b59:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104b5d:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000104b60:	8d 90 d0 07 00 00    	lea    0x7d0(%rax),%edx
ffff800000104b66:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000104b6a:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000104b6d:	90                   	nop
ffff800000104b6e:	c9                   	leave
ffff800000104b6f:	c3                   	ret

ffff800000104b70 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
ffff800000104b70:	55                   	push   %rbp
ffff800000104b71:	48 89 e5             	mov    %rsp,%rbp
ffff800000104b74:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000104b78:	89 7d dc             	mov    %edi,-0x24(%rbp)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
ffff800000104b7b:	48 ba 9c c9 10 00 00 	movabs $0xffff80000010c99c,%rdx
ffff800000104b82:	80 ff ff 
ffff800000104b85:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104b8c:	80 ff ff 
ffff800000104b8f:	48 89 d6             	mov    %rdx,%rsi
ffff800000104b92:	48 89 c7             	mov    %rax,%rdi
ffff800000104b95:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000104b9c:	80 ff ff 
ffff800000104b9f:	ff d0                	call   *%rax
  readsb(dev, &sb);
ffff800000104ba1:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000104ba5:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104ba8:	48 89 d6             	mov    %rdx,%rsi
ffff800000104bab:	89 c7                	mov    %eax,%edi
ffff800000104bad:	48 b8 91 20 10 00 00 	movabs $0xffff800000102091,%rax
ffff800000104bb4:	80 ff ff 
ffff800000104bb7:	ff d0                	call   *%rax
  log.start = sb.logstart;
ffff800000104bb9:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000104bbc:	89 c2                	mov    %eax,%edx
ffff800000104bbe:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104bc5:	80 ff ff 
ffff800000104bc8:	89 50 68             	mov    %edx,0x68(%rax)
  log.size = sb.nlog;
ffff800000104bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104bce:	89 c2                	mov    %eax,%edx
ffff800000104bd0:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104bd7:	80 ff ff 
ffff800000104bda:	89 50 6c             	mov    %edx,0x6c(%rax)
  log.dev = dev;
ffff800000104bdd:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104be4:	80 ff ff 
ffff800000104be7:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104bea:	89 42 78             	mov    %eax,0x78(%rdx)
  recover_from_log();
ffff800000104bed:	48 b8 81 4e 10 00 00 	movabs $0xffff800000104e81,%rax
ffff800000104bf4:	80 ff ff 
ffff800000104bf7:	ff d0                	call   *%rax
}
ffff800000104bf9:	90                   	nop
ffff800000104bfa:	c9                   	leave
ffff800000104bfb:	c3                   	ret

ffff800000104bfc <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
ffff800000104bfc:	55                   	push   %rbp
ffff800000104bfd:	48 89 e5             	mov    %rsp,%rbp
ffff800000104c00:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104c0b:	e9 dc 00 00 00       	jmp    ffff800000104cec <install_trans+0xf0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
ffff800000104c10:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c17:	80 ff ff 
ffff800000104c1a:	8b 50 68             	mov    0x68(%rax),%edx
ffff800000104c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000104c20:	01 d0                	add    %edx,%eax
ffff800000104c22:	83 c0 01             	add    $0x1,%eax
ffff800000104c25:	89 c2                	mov    %eax,%edx
ffff800000104c27:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c2e:	80 ff ff 
ffff800000104c31:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104c34:	89 d6                	mov    %edx,%esi
ffff800000104c36:	89 c7                	mov    %eax,%edi
ffff800000104c38:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104c3f:	80 ff ff 
ffff800000104c42:	ff d0                	call   *%rax
ffff800000104c44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
ffff800000104c48:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c4f:	80 ff ff 
ffff800000104c52:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104c55:	48 63 d2             	movslq %edx,%rdx
ffff800000104c58:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000104c5c:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000104c60:	89 c2                	mov    %eax,%edx
ffff800000104c62:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104c69:	80 ff ff 
ffff800000104c6c:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104c6f:	89 d6                	mov    %edx,%esi
ffff800000104c71:	89 c7                	mov    %eax,%edi
ffff800000104c73:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104c7a:	80 ff ff 
ffff800000104c7d:	ff d0                	call   *%rax
ffff800000104c7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
ffff800000104c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104c87:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000104c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104c92:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104c98:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000104c9d:	48 89 ce             	mov    %rcx,%rsi
ffff800000104ca0:	48 89 c7             	mov    %rax,%rdi
ffff800000104ca3:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff800000104caa:	80 ff ff 
ffff800000104cad:	ff d0                	call   *%rax
    bwrite(dbuf);  // write dst to disk
ffff800000104caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104cb3:	48 89 c7             	mov    %rax,%rdi
ffff800000104cb6:	48 b8 1a 04 10 00 00 	movabs $0xffff80000010041a,%rax
ffff800000104cbd:	80 ff ff 
ffff800000104cc0:	ff d0                	call   *%rax
    brelse(lbuf);
ffff800000104cc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104cc6:	48 89 c7             	mov    %rax,%rdi
ffff800000104cc9:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000104cd0:	80 ff ff 
ffff800000104cd3:	ff d0                	call   *%rax
    brelse(dbuf);
ffff800000104cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104cd9:	48 89 c7             	mov    %rax,%rdi
ffff800000104cdc:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000104ce3:	80 ff ff 
ffff800000104ce6:	ff d0                	call   *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff800000104ce8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104cec:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104cf3:	80 ff ff 
ffff800000104cf6:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104cf9:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104cfc:	0f 8c 0e ff ff ff    	jl     ffff800000104c10 <install_trans+0x14>
  }
}
ffff800000104d02:	90                   	nop
ffff800000104d03:	90                   	nop
ffff800000104d04:	c9                   	leave
ffff800000104d05:	c3                   	ret

ffff800000104d06 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
ffff800000104d06:	55                   	push   %rbp
ffff800000104d07:	48 89 e5             	mov    %rsp,%rbp
ffff800000104d0a:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104d0e:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104d15:	80 ff ff 
ffff800000104d18:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104d1b:	89 c2                	mov    %eax,%edx
ffff800000104d1d:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104d24:	80 ff ff 
ffff800000104d27:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104d2a:	89 d6                	mov    %edx,%esi
ffff800000104d2c:	89 c7                	mov    %eax,%edi
ffff800000104d2e:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104d35:	80 ff ff 
ffff800000104d38:	ff d0                	call   *%rax
ffff800000104d3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *lh = (struct logheader *) (buf->data);
ffff800000104d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104d42:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104d48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  log.lh.n = lh->n;
ffff800000104d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d50:	8b 00                	mov    (%rax),%eax
ffff800000104d52:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104d59:	80 ff ff 
ffff800000104d5c:	89 42 7c             	mov    %eax,0x7c(%rdx)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104d5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104d66:	eb 2a                	jmp    ffff800000104d92 <read_head+0x8c>
    log.lh.block[i] = lh->block[i];
ffff800000104d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104d6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104d6f:	48 63 d2             	movslq %edx,%rdx
ffff800000104d72:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffff800000104d76:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104d7d:	80 ff ff 
ffff800000104d80:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff800000104d83:	48 63 c9             	movslq %ecx,%rcx
ffff800000104d86:	48 83 c1 1c          	add    $0x1c,%rcx
ffff800000104d8a:	89 44 8a 10          	mov    %eax,0x10(%rdx,%rcx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104d8e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104d92:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104d99:	80 ff ff 
ffff800000104d9c:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104d9f:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104da2:	7c c4                	jl     ffff800000104d68 <read_head+0x62>
  }
  brelse(buf);
ffff800000104da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104da8:	48 89 c7             	mov    %rax,%rdi
ffff800000104dab:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000104db2:	80 ff ff 
ffff800000104db5:	ff d0                	call   *%rax
}
ffff800000104db7:	90                   	nop
ffff800000104db8:	c9                   	leave
ffff800000104db9:	c3                   	ret

ffff800000104dba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
ffff800000104dba:	55                   	push   %rbp
ffff800000104dbb:	48 89 e5             	mov    %rsp,%rbp
ffff800000104dbe:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffff800000104dc2:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104dc9:	80 ff ff 
ffff800000104dcc:	8b 40 68             	mov    0x68(%rax),%eax
ffff800000104dcf:	89 c2                	mov    %eax,%edx
ffff800000104dd1:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104dd8:	80 ff ff 
ffff800000104ddb:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000104dde:	89 d6                	mov    %edx,%esi
ffff800000104de0:	89 c7                	mov    %eax,%edi
ffff800000104de2:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000104de9:	80 ff ff 
ffff800000104dec:	ff d0                	call   *%rax
ffff800000104dee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *hb = (struct logheader *) (buf->data);
ffff800000104df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104df6:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff800000104dfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  hb->n = log.lh.n;
ffff800000104e00:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e07:	80 ff ff 
ffff800000104e0a:	8b 50 7c             	mov    0x7c(%rax),%edx
ffff800000104e0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104e11:	89 10                	mov    %edx,(%rax)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104e13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000104e1a:	eb 2a                	jmp    ffff800000104e46 <write_head+0x8c>
    hb->block[i] = log.lh.block[i];
ffff800000104e1c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e23:	80 ff ff 
ffff800000104e26:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104e29:	48 63 d2             	movslq %edx,%rdx
ffff800000104e2c:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000104e30:	8b 4c 90 10          	mov    0x10(%rax,%rdx,4),%ecx
ffff800000104e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000104e38:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000104e3b:	48 63 d2             	movslq %edx,%rdx
ffff800000104e3e:	89 4c 90 04          	mov    %ecx,0x4(%rax,%rdx,4)
  for (i = 0; i < log.lh.n; i++) {
ffff800000104e42:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000104e46:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104e4d:	80 ff ff 
ffff800000104e50:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000104e53:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000104e56:	7c c4                	jl     ffff800000104e1c <write_head+0x62>
  }
  bwrite(buf);
ffff800000104e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104e5c:	48 89 c7             	mov    %rax,%rdi
ffff800000104e5f:	48 b8 1a 04 10 00 00 	movabs $0xffff80000010041a,%rax
ffff800000104e66:	80 ff ff 
ffff800000104e69:	ff d0                	call   *%rax
  brelse(buf);
ffff800000104e6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104e6f:	48 89 c7             	mov    %rax,%rdi
ffff800000104e72:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff800000104e79:	80 ff ff 
ffff800000104e7c:	ff d0                	call   *%rax
}
ffff800000104e7e:	90                   	nop
ffff800000104e7f:	c9                   	leave
ffff800000104e80:	c3                   	ret

ffff800000104e81 <recover_from_log>:

static void
recover_from_log(void)
{
ffff800000104e81:	55                   	push   %rbp
ffff800000104e82:	48 89 e5             	mov    %rsp,%rbp
  read_head();
ffff800000104e85:	48 b8 06 4d 10 00 00 	movabs $0xffff800000104d06,%rax
ffff800000104e8c:	80 ff ff 
ffff800000104e8f:	ff d0                	call   *%rax
  install_trans(); // if committed, copy from log to disk
ffff800000104e91:	48 b8 fc 4b 10 00 00 	movabs $0xffff800000104bfc,%rax
ffff800000104e98:	80 ff ff 
ffff800000104e9b:	ff d0                	call   *%rax
  log.lh.n = 0;
ffff800000104e9d:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104ea4:	80 ff ff 
ffff800000104ea7:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
  write_head(); // clear the log
ffff800000104eae:	48 b8 ba 4d 10 00 00 	movabs $0xffff800000104dba,%rax
ffff800000104eb5:	80 ff ff 
ffff800000104eb8:	ff d0                	call   *%rax
}
ffff800000104eba:	90                   	nop
ffff800000104ebb:	5d                   	pop    %rbp
ffff800000104ebc:	c3                   	ret

ffff800000104ebd <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
ffff800000104ebd:	55                   	push   %rbp
ffff800000104ebe:	48 89 e5             	mov    %rsp,%rbp
  acquire(&log.lock);
ffff800000104ec1:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104ec8:	80 ff ff 
ffff800000104ecb:	48 89 c7             	mov    %rax,%rdi
ffff800000104ece:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000104ed5:	80 ff ff 
ffff800000104ed8:	ff d0                	call   *%rax
  while(1){
    if(log.committing){
ffff800000104eda:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104ee1:	80 ff ff 
ffff800000104ee4:	8b 40 74             	mov    0x74(%rax),%eax
ffff800000104ee7:	85 c0                	test   %eax,%eax
ffff800000104ee9:	74 28                	je     ffff800000104f13 <begin_op+0x56>
      sleep(&log, &log.lock);
ffff800000104eeb:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104ef2:	80 ff ff 
ffff800000104ef5:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104efc:	80 ff ff 
ffff800000104eff:	48 89 d6             	mov    %rdx,%rsi
ffff800000104f02:	48 89 c7             	mov    %rax,%rdi
ffff800000104f05:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000104f0c:	80 ff ff 
ffff800000104f0f:	ff d0                	call   *%rax
ffff800000104f11:	eb c7                	jmp    ffff800000104eda <begin_op+0x1d>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
ffff800000104f13:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f1a:	80 ff ff 
ffff800000104f1d:	8b 48 7c             	mov    0x7c(%rax),%ecx
ffff800000104f20:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f27:	80 ff ff 
ffff800000104f2a:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000104f2d:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104f30:	89 d0                	mov    %edx,%eax
ffff800000104f32:	c1 e0 02             	shl    $0x2,%eax
ffff800000104f35:	01 d0                	add    %edx,%eax
ffff800000104f37:	01 c0                	add    %eax,%eax
ffff800000104f39:	01 c8                	add    %ecx,%eax
ffff800000104f3b:	83 f8 1e             	cmp    $0x1e,%eax
ffff800000104f3e:	7e 2b                	jle    ffff800000104f6b <begin_op+0xae>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
ffff800000104f40:	48 ba e0 71 11 00 00 	movabs $0xffff8000001171e0,%rdx
ffff800000104f47:	80 ff ff 
ffff800000104f4a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f51:	80 ff ff 
ffff800000104f54:	48 89 d6             	mov    %rdx,%rsi
ffff800000104f57:	48 89 c7             	mov    %rax,%rdi
ffff800000104f5a:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000104f61:	80 ff ff 
ffff800000104f64:	ff d0                	call   *%rax
ffff800000104f66:	e9 6f ff ff ff       	jmp    ffff800000104eda <begin_op+0x1d>
    } else {
      log.outstanding += 1;
ffff800000104f6b:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f72:	80 ff ff 
ffff800000104f75:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000104f78:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104f7b:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f82:	80 ff ff 
ffff800000104f85:	89 50 70             	mov    %edx,0x70(%rax)
      release(&log.lock);
ffff800000104f88:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104f8f:	80 ff ff 
ffff800000104f92:	48 89 c7             	mov    %rax,%rdi
ffff800000104f95:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000104f9c:	80 ff ff 
ffff800000104f9f:	ff d0                	call   *%rax
      break;
ffff800000104fa1:	90                   	nop
    }
  }
}
ffff800000104fa2:	90                   	nop
ffff800000104fa3:	5d                   	pop    %rbp
ffff800000104fa4:	c3                   	ret

ffff800000104fa5 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
ffff800000104fa5:	55                   	push   %rbp
ffff800000104fa6:	48 89 e5             	mov    %rsp,%rbp
ffff800000104fa9:	48 83 ec 10          	sub    $0x10,%rsp
  int do_commit = 0;
ffff800000104fad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  acquire(&log.lock);
ffff800000104fb4:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104fbb:	80 ff ff 
ffff800000104fbe:	48 89 c7             	mov    %rax,%rdi
ffff800000104fc1:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000104fc8:	80 ff ff 
ffff800000104fcb:	ff d0                	call   *%rax
  log.outstanding -= 1;
ffff800000104fcd:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104fd4:	80 ff ff 
ffff800000104fd7:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000104fda:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000104fdd:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104fe4:	80 ff ff 
ffff800000104fe7:	89 50 70             	mov    %edx,0x70(%rax)
  if(log.committing)
ffff800000104fea:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000104ff1:	80 ff ff 
ffff800000104ff4:	8b 40 74             	mov    0x74(%rax),%eax
ffff800000104ff7:	85 c0                	test   %eax,%eax
ffff800000104ff9:	74 19                	je     ffff800000105014 <end_op+0x6f>
    panic("log.committing");
ffff800000104ffb:	48 b8 a0 c9 10 00 00 	movabs $0xffff80000010c9a0,%rax
ffff800000105002:	80 ff ff 
ffff800000105005:	48 89 c7             	mov    %rax,%rdi
ffff800000105008:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010500f:	80 ff ff 
ffff800000105012:	ff d0                	call   *%rax
  if(log.outstanding == 0){
ffff800000105014:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010501b:	80 ff ff 
ffff80000010501e:	8b 40 70             	mov    0x70(%rax),%eax
ffff800000105021:	85 c0                	test   %eax,%eax
ffff800000105023:	75 1a                	jne    ffff80000010503f <end_op+0x9a>
    do_commit = 1;
ffff800000105025:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    log.committing = 1;
ffff80000010502c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105033:	80 ff ff 
ffff800000105036:	c7 40 74 01 00 00 00 	movl   $0x1,0x74(%rax)
ffff80000010503d:	eb 19                	jmp    ffff800000105058 <end_op+0xb3>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
ffff80000010503f:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105046:	80 ff ff 
ffff800000105049:	48 89 c7             	mov    %rax,%rdi
ffff80000010504c:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff800000105053:	80 ff ff 
ffff800000105056:	ff d0                	call   *%rax
  }
  release(&log.lock);
ffff800000105058:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010505f:	80 ff ff 
ffff800000105062:	48 89 c7             	mov    %rax,%rdi
ffff800000105065:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010506c:	80 ff ff 
ffff80000010506f:	ff d0                	call   *%rax

  if(do_commit){
ffff800000105071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000105075:	74 68                	je     ffff8000001050df <end_op+0x13a>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
ffff800000105077:	48 b8 ec 51 10 00 00 	movabs $0xffff8000001051ec,%rax
ffff80000010507e:	80 ff ff 
ffff800000105081:	ff d0                	call   *%rax
    acquire(&log.lock);
ffff800000105083:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010508a:	80 ff ff 
ffff80000010508d:	48 89 c7             	mov    %rax,%rdi
ffff800000105090:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000105097:	80 ff ff 
ffff80000010509a:	ff d0                	call   *%rax
    log.committing = 0;
ffff80000010509c:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050a3:	80 ff ff 
ffff8000001050a6:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%rax)
    wakeup(&log);
ffff8000001050ad:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050b4:	80 ff ff 
ffff8000001050b7:	48 89 c7             	mov    %rax,%rdi
ffff8000001050ba:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff8000001050c1:	80 ff ff 
ffff8000001050c4:	ff d0                	call   *%rax
    release(&log.lock);
ffff8000001050c6:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050cd:	80 ff ff 
ffff8000001050d0:	48 89 c7             	mov    %rax,%rdi
ffff8000001050d3:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001050da:	80 ff ff 
ffff8000001050dd:	ff d0                	call   *%rax
  }
}
ffff8000001050df:	90                   	nop
ffff8000001050e0:	c9                   	leave
ffff8000001050e1:	c3                   	ret

ffff8000001050e2 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
ffff8000001050e2:	55                   	push   %rbp
ffff8000001050e3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001050e6:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffff8000001050ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001050f1:	e9 dc 00 00 00       	jmp    ffff8000001051d2 <write_log+0xf0>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
ffff8000001050f6:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001050fd:	80 ff ff 
ffff800000105100:	8b 50 68             	mov    0x68(%rax),%edx
ffff800000105103:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105106:	01 d0                	add    %edx,%eax
ffff800000105108:	83 c0 01             	add    $0x1,%eax
ffff80000010510b:	89 c2                	mov    %eax,%edx
ffff80000010510d:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105114:	80 ff ff 
ffff800000105117:	8b 40 78             	mov    0x78(%rax),%eax
ffff80000010511a:	89 d6                	mov    %edx,%esi
ffff80000010511c:	89 c7                	mov    %eax,%edi
ffff80000010511e:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000105125:	80 ff ff 
ffff800000105128:	ff d0                	call   *%rax
ffff80000010512a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
ffff80000010512e:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105135:	80 ff ff 
ffff800000105138:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010513b:	48 63 d2             	movslq %edx,%rdx
ffff80000010513e:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000105142:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000105146:	89 c2                	mov    %eax,%edx
ffff800000105148:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010514f:	80 ff ff 
ffff800000105152:	8b 40 78             	mov    0x78(%rax),%eax
ffff800000105155:	89 d6                	mov    %edx,%esi
ffff800000105157:	89 c7                	mov    %eax,%edi
ffff800000105159:	48 b8 cc 03 10 00 00 	movabs $0xffff8000001003cc,%rax
ffff800000105160:	80 ff ff 
ffff800000105163:	ff d0                	call   *%rax
ffff800000105165:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(to->data, from->data, BSIZE);
ffff800000105169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010516d:	48 8d 88 b0 00 00 00 	lea    0xb0(%rax),%rcx
ffff800000105174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105178:	48 05 b0 00 00 00    	add    $0xb0,%rax
ffff80000010517e:	ba 00 02 00 00       	mov    $0x200,%edx
ffff800000105183:	48 89 ce             	mov    %rcx,%rsi
ffff800000105186:	48 89 c7             	mov    %rax,%rdi
ffff800000105189:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff800000105190:	80 ff ff 
ffff800000105193:	ff d0                	call   *%rax
    bwrite(to);  // write the log
ffff800000105195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105199:	48 89 c7             	mov    %rax,%rdi
ffff80000010519c:	48 b8 1a 04 10 00 00 	movabs $0xffff80000010041a,%rax
ffff8000001051a3:	80 ff ff 
ffff8000001051a6:	ff d0                	call   *%rax
    brelse(from);
ffff8000001051a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001051ac:	48 89 c7             	mov    %rax,%rdi
ffff8000001051af:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001051b6:	80 ff ff 
ffff8000001051b9:	ff d0                	call   *%rax
    brelse(to);
ffff8000001051bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001051bf:	48 89 c7             	mov    %rax,%rdi
ffff8000001051c2:	48 b8 81 04 10 00 00 	movabs $0xffff800000100481,%rax
ffff8000001051c9:	80 ff ff 
ffff8000001051cc:	ff d0                	call   *%rax
  for (tail = 0; tail < log.lh.n; tail++) {
ffff8000001051ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001051d2:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051d9:	80 ff ff 
ffff8000001051dc:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001051df:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff8000001051e2:	0f 8c 0e ff ff ff    	jl     ffff8000001050f6 <write_log+0x14>
  }
}
ffff8000001051e8:	90                   	nop
ffff8000001051e9:	90                   	nop
ffff8000001051ea:	c9                   	leave
ffff8000001051eb:	c3                   	ret

ffff8000001051ec <commit>:

static void
commit()
{
ffff8000001051ec:	55                   	push   %rbp
ffff8000001051ed:	48 89 e5             	mov    %rsp,%rbp
  if (log.lh.n > 0) {
ffff8000001051f0:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001051f7:	80 ff ff 
ffff8000001051fa:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff8000001051fd:	85 c0                	test   %eax,%eax
ffff8000001051ff:	7e 41                	jle    ffff800000105242 <commit+0x56>
    write_log();     // Write modified blocks from cache to log
ffff800000105201:	48 b8 e2 50 10 00 00 	movabs $0xffff8000001050e2,%rax
ffff800000105208:	80 ff ff 
ffff80000010520b:	ff d0                	call   *%rax
    write_head();    // Write header to disk -- the real commit
ffff80000010520d:	48 b8 ba 4d 10 00 00 	movabs $0xffff800000104dba,%rax
ffff800000105214:	80 ff ff 
ffff800000105217:	ff d0                	call   *%rax
    install_trans(); // Now install writes to home locations
ffff800000105219:	48 b8 fc 4b 10 00 00 	movabs $0xffff800000104bfc,%rax
ffff800000105220:	80 ff ff 
ffff800000105223:	ff d0                	call   *%rax
    log.lh.n = 0;
ffff800000105225:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010522c:	80 ff ff 
ffff80000010522f:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%rax)
    write_head();    // Erase the transaction from the log
ffff800000105236:	48 b8 ba 4d 10 00 00 	movabs $0xffff800000104dba,%rax
ffff80000010523d:	80 ff ff 
ffff800000105240:	ff d0                	call   *%rax
  }
}
ffff800000105242:	90                   	nop
ffff800000105243:	5d                   	pop    %rbp
ffff800000105244:	c3                   	ret

ffff800000105245 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
ffff800000105245:	55                   	push   %rbp
ffff800000105246:	48 89 e5             	mov    %rsp,%rbp
ffff800000105249:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010524d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
ffff800000105251:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105258:	80 ff ff 
ffff80000010525b:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010525e:	83 f8 1d             	cmp    $0x1d,%eax
ffff800000105261:	7f 21                	jg     ffff800000105284 <log_write+0x3f>
ffff800000105263:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010526a:	80 ff ff 
ffff80000010526d:	8b 50 7c             	mov    0x7c(%rax),%edx
ffff800000105270:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105277:	80 ff ff 
ffff80000010527a:	8b 40 6c             	mov    0x6c(%rax),%eax
ffff80000010527d:	83 e8 01             	sub    $0x1,%eax
ffff800000105280:	39 c2                	cmp    %eax,%edx
ffff800000105282:	7c 19                	jl     ffff80000010529d <log_write+0x58>
    panic("too big a transaction");
ffff800000105284:	48 b8 af c9 10 00 00 	movabs $0xffff80000010c9af,%rax
ffff80000010528b:	80 ff ff 
ffff80000010528e:	48 89 c7             	mov    %rax,%rdi
ffff800000105291:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000105298:	80 ff ff 
ffff80000010529b:	ff d0                	call   *%rax
  if (log.outstanding < 1)
ffff80000010529d:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001052a4:	80 ff ff 
ffff8000001052a7:	8b 40 70             	mov    0x70(%rax),%eax
ffff8000001052aa:	85 c0                	test   %eax,%eax
ffff8000001052ac:	7f 19                	jg     ffff8000001052c7 <log_write+0x82>
    panic("log_write outside of trans");
ffff8000001052ae:	48 b8 c5 c9 10 00 00 	movabs $0xffff80000010c9c5,%rax
ffff8000001052b5:	80 ff ff 
ffff8000001052b8:	48 89 c7             	mov    %rax,%rdi
ffff8000001052bb:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001052c2:	80 ff ff 
ffff8000001052c5:	ff d0                	call   *%rax

  acquire(&log.lock);
ffff8000001052c7:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001052ce:	80 ff ff 
ffff8000001052d1:	48 89 c7             	mov    %rax,%rdi
ffff8000001052d4:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff8000001052db:	80 ff ff 
ffff8000001052de:	ff d0                	call   *%rax
  for (i = 0; i < log.lh.n; i++) {
ffff8000001052e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001052e7:	eb 29                	jmp    ffff800000105312 <log_write+0xcd>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
ffff8000001052e9:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff8000001052f0:	80 ff ff 
ffff8000001052f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001052f6:	48 63 d2             	movslq %edx,%rdx
ffff8000001052f9:	48 83 c2 1c          	add    $0x1c,%rdx
ffff8000001052fd:	8b 44 90 10          	mov    0x10(%rax,%rdx,4),%eax
ffff800000105301:	89 c2                	mov    %eax,%edx
ffff800000105303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105307:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010530a:	39 c2                	cmp    %eax,%edx
ffff80000010530c:	74 18                	je     ffff800000105326 <log_write+0xe1>
  for (i = 0; i < log.lh.n; i++) {
ffff80000010530e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105312:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105319:	80 ff ff 
ffff80000010531c:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff80000010531f:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105322:	7c c5                	jl     ffff8000001052e9 <log_write+0xa4>
ffff800000105324:	eb 01                	jmp    ffff800000105327 <log_write+0xe2>
      break;
ffff800000105326:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
ffff800000105327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010532b:	8b 40 08             	mov    0x8(%rax),%eax
ffff80000010532e:	89 c1                	mov    %eax,%ecx
ffff800000105330:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105337:	80 ff ff 
ffff80000010533a:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010533d:	48 63 d2             	movslq %edx,%rdx
ffff800000105340:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000105344:	89 4c 90 10          	mov    %ecx,0x10(%rax,%rdx,4)
  if (i == log.lh.n)
ffff800000105348:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010534f:	80 ff ff 
ffff800000105352:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105355:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffff800000105358:	75 1d                	jne    ffff800000105377 <log_write+0x132>
    log.lh.n++;
ffff80000010535a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105361:	80 ff ff 
ffff800000105364:	8b 40 7c             	mov    0x7c(%rax),%eax
ffff800000105367:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010536a:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff800000105371:	80 ff ff 
ffff800000105374:	89 50 7c             	mov    %edx,0x7c(%rax)
  b->flags |= B_DIRTY; // prevent eviction
ffff800000105377:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010537b:	8b 00                	mov    (%rax),%eax
ffff80000010537d:	83 c8 04             	or     $0x4,%eax
ffff800000105380:	89 c2                	mov    %eax,%edx
ffff800000105382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105386:	89 10                	mov    %edx,(%rax)
  release(&log.lock);
ffff800000105388:	48 b8 e0 71 11 00 00 	movabs $0xffff8000001171e0,%rax
ffff80000010538f:	80 ff ff 
ffff800000105392:	48 89 c7             	mov    %rax,%rdi
ffff800000105395:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010539c:	80 ff ff 
ffff80000010539f:	ff d0                	call   *%rax
}
ffff8000001053a1:	90                   	nop
ffff8000001053a2:	c9                   	leave
ffff8000001053a3:	c3                   	ret

ffff8000001053a4 <v2p>:
#define KERNBASE 0xFFFF800000000000 // First kernel virtual address

#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__
static inline addr_t v2p(void *a) {
ffff8000001053a4:	55                   	push   %rbp
ffff8000001053a5:	48 89 e5             	mov    %rsp,%rbp
ffff8000001053a8:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001053ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff8000001053b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001053b4:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff8000001053bb:	80 00 00 
ffff8000001053be:	48 01 d0             	add    %rdx,%rax
}
ffff8000001053c1:	c9                   	leave
ffff8000001053c2:	c3                   	ret

ffff8000001053c3 <xchg>:

static inline uint
xchg(volatile uint *addr, addr_t newval)
{
ffff8000001053c3:	55                   	push   %rbp
ffff8000001053c4:	48 89 e5             	mov    %rsp,%rbp
ffff8000001053c7:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001053cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001053cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
ffff8000001053d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001053d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001053db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001053df:	f0 87 02             	lock xchg %eax,(%rdx)
ffff8000001053e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
ffff8000001053e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001053e8:	c9                   	leave
ffff8000001053e9:	c3                   	ret

ffff8000001053ea <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
ffff8000001053ea:	55                   	push   %rbp
ffff8000001053eb:	48 89 e5             	mov    %rsp,%rbp
  uartearlyinit();
ffff8000001053ee:	48 b8 02 a6 10 00 00 	movabs $0xffff80000010a602,%rax
ffff8000001053f5:	80 ff ff 
ffff8000001053f8:	ff d0                	call   *%rax
  kinit1(end, P2V(PHYSTOP)); // phys page allocator
ffff8000001053fa:	48 ba 00 00 00 0e 00 	movabs $0xffff80000e000000,%rdx
ffff800000105401:	80 ff ff 
ffff800000105404:	48 b8 00 60 12 00 00 	movabs $0xffff800000126000,%rax
ffff80000010540b:	80 ff ff 
ffff80000010540e:	48 89 d6             	mov    %rdx,%rsi
ffff800000105411:	48 89 c7             	mov    %rax,%rdi
ffff800000105414:	48 b8 c2 3f 10 00 00 	movabs $0xffff800000103fc2,%rax
ffff80000010541b:	80 ff ff 
ffff80000010541e:	ff d0                	call   *%rax
  kvmalloc();      // kernel page table
ffff800000105420:	48 b8 8a b8 10 00 00 	movabs $0xffff80000010b88a,%rax
ffff800000105427:	80 ff ff 
ffff80000010542a:	ff d0                	call   *%rax
  mpinit();        // detect other processors
ffff80000010542c:	48 b8 ee 59 10 00 00 	movabs $0xffff8000001059ee,%rax
ffff800000105433:	80 ff ff 
ffff800000105436:	ff d0                	call   *%rax
  lapicinit();     // interrupt controller
ffff800000105438:	48 b8 fa 44 10 00 00 	movabs $0xffff8000001044fa,%rax
ffff80000010543f:	80 ff ff 
ffff800000105442:	ff d0                	call   *%rax
  tvinit();        // trap vectors
ffff800000105444:	48 b8 12 a0 10 00 00 	movabs $0xffff80000010a012,%rax
ffff80000010544b:	80 ff ff 
ffff80000010544e:	ff d0                	call   *%rax
  seginit();       // segment descriptors
ffff800000105450:	48 b8 cf b3 10 00 00 	movabs $0xffff80000010b3cf,%rax
ffff800000105457:	80 ff ff 
ffff80000010545a:	ff d0                	call   *%rax
  cprintf("\ncpu%d: starting Fall 2025 xv6\n\n", cpunum());
ffff80000010545c:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff800000105463:	80 ff ff 
ffff800000105466:	ff d0                	call   *%rax
ffff800000105468:	89 c2                	mov    %eax,%edx
ffff80000010546a:	48 b8 e0 c9 10 00 00 	movabs $0xffff80000010c9e0,%rax
ffff800000105471:	80 ff ff 
ffff800000105474:	89 d6                	mov    %edx,%esi
ffff800000105476:	48 89 c7             	mov    %rax,%rdi
ffff800000105479:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010547e:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000105485:	80 ff ff 
ffff800000105488:	ff d2                	call   *%rdx
  ioapicinit();    // another interrupt controller
ffff80000010548a:	48 b8 8d 3e 10 00 00 	movabs $0xffff800000103e8d,%rax
ffff800000105491:	80 ff ff 
ffff800000105494:	ff d0                	call   *%rax
  consoleinit();   // console hardware
ffff800000105496:	48 b8 99 14 10 00 00 	movabs $0xffff800000101499,%rax
ffff80000010549d:	80 ff ff 
ffff8000001054a0:	ff d0                	call   *%rax
  uartinit();      // serial port
ffff8000001054a2:	48 b8 06 a7 10 00 00 	movabs $0xffff80000010a706,%rax
ffff8000001054a9:	80 ff ff 
ffff8000001054ac:	ff d0                	call   *%rax
  pinit();         // process table
ffff8000001054ae:	48 b8 2e 61 10 00 00 	movabs $0xffff80000010612e,%rax
ffff8000001054b5:	80 ff ff 
ffff8000001054b8:	ff d0                	call   *%rax
  binit();         // buffer cache
ffff8000001054ba:	48 b8 1b 01 10 00 00 	movabs $0xffff80000010011b,%rax
ffff8000001054c1:	80 ff ff 
ffff8000001054c4:	ff d0                	call   *%rax
  fileinit();      // file table
ffff8000001054c6:	48 b8 1d 1b 10 00 00 	movabs $0xffff800000101b1d,%rax
ffff8000001054cd:	80 ff ff 
ffff8000001054d0:	ff d0                	call   *%rax
  ideinit();       // disk
ffff8000001054d2:	48 b8 dc 38 10 00 00 	movabs $0xffff8000001038dc,%rax
ffff8000001054d9:	80 ff ff 
ffff8000001054dc:	ff d0                	call   *%rax
  startothers();   // start other processors
ffff8000001054de:	48 b8 bb 55 10 00 00 	movabs $0xffff8000001055bb,%rax
ffff8000001054e5:	80 ff ff 
ffff8000001054e8:	ff d0                	call   *%rax
  kinit2();
ffff8000001054ea:	48 b8 38 40 10 00 00 	movabs $0xffff800000104038,%rax
ffff8000001054f1:	80 ff ff 
ffff8000001054f4:	ff d0                	call   *%rax
  userinit();      // first user process
ffff8000001054f6:	48 b8 e7 62 10 00 00 	movabs $0xffff8000001062e7,%rax
ffff8000001054fd:	80 ff ff 
ffff800000105500:	ff d0                	call   *%rax
  mpmain();        // finish this processor's setup
ffff800000105502:	48 b8 42 55 10 00 00 	movabs $0xffff800000105542,%rax
ffff800000105509:	80 ff ff 
ffff80000010550c:	ff d0                	call   *%rax

ffff80000010550e <mpenter>:
}

// Other CPUs jump here from entryother.S.
void
mpenter(void)
{
ffff80000010550e:	55                   	push   %rbp
ffff80000010550f:	48 89 e5             	mov    %rsp,%rbp
  switchkvm();
ffff800000105512:	48 b8 8b bc 10 00 00 	movabs $0xffff80000010bc8b,%rax
ffff800000105519:	80 ff ff 
ffff80000010551c:	ff d0                	call   *%rax
  seginit();
ffff80000010551e:	48 b8 cf b3 10 00 00 	movabs $0xffff80000010b3cf,%rax
ffff800000105525:	80 ff ff 
ffff800000105528:	ff d0                	call   *%rax
  lapicinit();
ffff80000010552a:	48 b8 fa 44 10 00 00 	movabs $0xffff8000001044fa,%rax
ffff800000105531:	80 ff ff 
ffff800000105534:	ff d0                	call   *%rax
  mpmain();
ffff800000105536:	48 b8 42 55 10 00 00 	movabs $0xffff800000105542,%rax
ffff80000010553d:	80 ff ff 
ffff800000105540:	ff d0                	call   *%rax

ffff800000105542 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
ffff800000105542:	55                   	push   %rbp
ffff800000105543:	48 89 e5             	mov    %rsp,%rbp
  cprintf("cpu%d: starting\n", cpunum());
ffff800000105546:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff80000010554d:	80 ff ff 
ffff800000105550:	ff d0                	call   *%rax
ffff800000105552:	89 c2                	mov    %eax,%edx
ffff800000105554:	48 b8 01 ca 10 00 00 	movabs $0xffff80000010ca01,%rax
ffff80000010555b:	80 ff ff 
ffff80000010555e:	89 d6                	mov    %edx,%esi
ffff800000105560:	48 89 c7             	mov    %rax,%rdi
ffff800000105563:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105568:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff80000010556f:	80 ff ff 
ffff800000105572:	ff d2                	call   *%rdx
  idtinit();       // load idt register
ffff800000105574:	48 b8 ea 9f 10 00 00 	movabs $0xffff800000109fea,%rax
ffff80000010557b:	80 ff ff 
ffff80000010557e:	ff d0                	call   *%rax
  syscallinit();   // syscall set up
ffff800000105580:	48 b8 58 b3 10 00 00 	movabs $0xffff80000010b358,%rax
ffff800000105587:	80 ff ff 
ffff80000010558a:	ff d0                	call   *%rax
  xchg(&cpu->started, 1); // tell startothers() we're up
ffff80000010558c:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000105593:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000105597:	48 83 c0 10          	add    $0x10,%rax
ffff80000010559b:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001055a0:	48 89 c7             	mov    %rax,%rdi
ffff8000001055a3:	48 b8 c3 53 10 00 00 	movabs $0xffff8000001053c3,%rax
ffff8000001055aa:	80 ff ff 
ffff8000001055ad:	ff d0                	call   *%rax
  scheduler();     // start running processes
ffff8000001055af:	48 b8 59 6b 10 00 00 	movabs $0xffff800000106b59,%rax
ffff8000001055b6:	80 ff ff 
ffff8000001055b9:	ff d0                	call   *%rax

ffff8000001055bb <startothers>:
void entry32mp(void);

// Start the non-boot (AP) processors.
static void
startothers(void)
{
ffff8000001055bb:	55                   	push   %rbp
ffff8000001055bc:	48 89 e5             	mov    %rsp,%rbp
ffff8000001055bf:	48 83 ec 20          	sub    $0x20,%rsp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
ffff8000001055c3:	48 b8 00 70 00 00 00 	movabs $0xffff800000007000,%rax
ffff8000001055ca:	80 ff ff 
ffff8000001055cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  memmove(code, _binary_entryother_start,
ffff8000001055d1:	48 b8 72 00 00 00 00 	movabs $0x72,%rax
ffff8000001055d8:	00 00 00 
ffff8000001055db:	89 c2                	mov    %eax,%edx
ffff8000001055dd:	48 b9 b0 de 10 00 00 	movabs $0xffff80000010deb0,%rcx
ffff8000001055e4:	80 ff ff 
ffff8000001055e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001055eb:	48 89 ce             	mov    %rcx,%rsi
ffff8000001055ee:	48 89 c7             	mov    %rax,%rdi
ffff8000001055f1:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff8000001055f8:	80 ff ff 
ffff8000001055fb:	ff d0                	call   *%rax
          (addr_t)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
ffff8000001055fd:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff800000105604:	80 ff ff 
ffff800000105607:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010560b:	e9 c6 00 00 00       	jmp    ffff8000001056d6 <startothers+0x11b>
    if(c == cpus+cpunum())  // We've started already.
ffff800000105610:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff800000105617:	80 ff ff 
ffff80000010561a:	ff d0                	call   *%rax
ffff80000010561c:	48 63 d0             	movslq %eax,%rdx
ffff80000010561f:	48 89 d0             	mov    %rdx,%rax
ffff800000105622:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105626:	48 01 d0             	add    %rdx,%rax
ffff800000105629:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010562d:	48 89 c2             	mov    %rax,%rdx
ffff800000105630:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff800000105637:	80 ff ff 
ffff80000010563a:	48 01 d0             	add    %rdx,%rax
ffff80000010563d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000105641:	0f 84 89 00 00 00    	je     ffff8000001056d0 <startothers+0x115>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
ffff800000105647:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010564e:	80 ff ff 
ffff800000105651:	ff d0                	call   *%rax
ffff800000105653:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    *(uint32*)(code-4) = 0x8000; // enough stack to get us to entry64mp
ffff800000105657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010565b:	48 83 e8 04          	sub    $0x4,%rax
ffff80000010565f:	c7 00 00 80 00 00    	movl   $0x8000,(%rax)
    *(uint32*)(code-8) = v2p(entry32mp);
ffff800000105665:	48 b8 49 00 10 00 00 	movabs $0xffff800000100049,%rax
ffff80000010566c:	80 ff ff 
ffff80000010566f:	48 89 c7             	mov    %rax,%rdi
ffff800000105672:	48 b8 a4 53 10 00 00 	movabs $0xffff8000001053a4,%rax
ffff800000105679:	80 ff ff 
ffff80000010567c:	ff d0                	call   *%rax
ffff80000010567e:	48 89 c2             	mov    %rax,%rdx
ffff800000105681:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105685:	48 83 e8 08          	sub    $0x8,%rax
ffff800000105689:	89 10                	mov    %edx,(%rax)
    *(uint64*)(code-16) = (uint64) (stack + KSTACKSIZE);
ffff80000010568b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010568f:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
ffff800000105696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010569a:	48 83 e8 10          	sub    $0x10,%rax
ffff80000010569e:	48 89 10             	mov    %rdx,(%rax)

    lapicstartap(c->apicid, V2P(code));
ffff8000001056a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001056a5:	89 c2                	mov    %eax,%edx
ffff8000001056a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001056ab:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff8000001056af:	0f b6 c0             	movzbl %al,%eax
ffff8000001056b2:	89 d6                	mov    %edx,%esi
ffff8000001056b4:	89 c7                	mov    %eax,%edi
ffff8000001056b6:	48 b8 cd 47 10 00 00 	movabs $0xffff8000001047cd,%rax
ffff8000001056bd:	80 ff ff 
ffff8000001056c0:	ff d0                	call   *%rax

    // wait for cpu to finish mpmain()
    while(c->started == 0)
ffff8000001056c2:	90                   	nop
ffff8000001056c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001056c7:	8b 40 10             	mov    0x10(%rax),%eax
ffff8000001056ca:	85 c0                	test   %eax,%eax
ffff8000001056cc:	74 f5                	je     ffff8000001056c3 <startothers+0x108>
ffff8000001056ce:	eb 01                	jmp    ffff8000001056d1 <startothers+0x116>
      continue;
ffff8000001056d0:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
ffff8000001056d1:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffff8000001056d6:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff8000001056dd:	80 ff ff 
ffff8000001056e0:	8b 00                	mov    (%rax),%eax
ffff8000001056e2:	48 63 d0             	movslq %eax,%rdx
ffff8000001056e5:	48 89 d0             	mov    %rdx,%rax
ffff8000001056e8:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001056ec:	48 01 d0             	add    %rdx,%rax
ffff8000001056ef:	48 c1 e0 03          	shl    $0x3,%rax
ffff8000001056f3:	48 89 c2             	mov    %rax,%rdx
ffff8000001056f6:	48 b8 e0 72 11 00 00 	movabs $0xffff8000001172e0,%rax
ffff8000001056fd:	80 ff ff 
ffff800000105700:	48 01 d0             	add    %rdx,%rax
ffff800000105703:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000105707:	0f 82 03 ff ff ff    	jb     ffff800000105610 <startothers+0x55>
      ;
  }
}
ffff80000010570d:	90                   	nop
ffff80000010570e:	90                   	nop
ffff80000010570f:	c9                   	leave
ffff800000105710:	c3                   	ret

ffff800000105711 <inb>:
{
ffff800000105711:	55                   	push   %rbp
ffff800000105712:	48 89 e5             	mov    %rsp,%rbp
ffff800000105715:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000105719:	89 f8                	mov    %edi,%eax
ffff80000010571b:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff80000010571f:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000105723:	89 c2                	mov    %eax,%edx
ffff800000105725:	ec                   	in     (%dx),%al
ffff800000105726:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000105729:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010572d:	c9                   	leave
ffff80000010572e:	c3                   	ret

ffff80000010572f <outb>:
{
ffff80000010572f:	55                   	push   %rbp
ffff800000105730:	48 89 e5             	mov    %rsp,%rbp
ffff800000105733:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105737:	89 fa                	mov    %edi,%edx
ffff800000105739:	89 f0                	mov    %esi,%eax
ffff80000010573b:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff80000010573f:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000105742:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000105746:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010574a:	ee                   	out    %al,(%dx)
}
ffff80000010574b:	90                   	nop
ffff80000010574c:	c9                   	leave
ffff80000010574d:	c3                   	ret

ffff80000010574e <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
ffff80000010574e:	55                   	push   %rbp
ffff80000010574f:	48 89 e5             	mov    %rsp,%rbp
ffff800000105752:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105756:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010575a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, sum;

  sum = 0;
ffff80000010575d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105764:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010576b:	eb 1a                	jmp    ffff800000105787 <sum+0x39>
    sum += addr[i];
ffff80000010576d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105770:	48 63 d0             	movslq %eax,%rdx
ffff800000105773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105777:	48 01 d0             	add    %rdx,%rax
ffff80000010577a:	0f b6 00             	movzbl (%rax),%eax
ffff80000010577d:	0f b6 c0             	movzbl %al,%eax
ffff800000105780:	01 45 f8             	add    %eax,-0x8(%rbp)
  for(i=0; i<len; i++)
ffff800000105783:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105787:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010578a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffff80000010578d:	7c de                	jl     ffff80000010576d <sum+0x1f>
  return sum;
ffff80000010578f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffff800000105792:	c9                   	leave
ffff800000105793:	c3                   	ret

ffff800000105794 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(addr_t a, int len)
{
ffff800000105794:	55                   	push   %rbp
ffff800000105795:	48 89 e5             	mov    %rsp,%rbp
ffff800000105798:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010579c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff8000001057a0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  uchar *e, *p, *addr;
  addr = P2V(a);
ffff8000001057a3:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff8000001057aa:	80 ff ff 
ffff8000001057ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001057b1:	48 01 d0             	add    %rdx,%rax
ffff8000001057b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  e = addr+len;
ffff8000001057b8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff8000001057bb:	48 63 d0             	movslq %eax,%rdx
ffff8000001057be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001057c2:	48 01 d0             	add    %rdx,%rax
ffff8000001057c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(p = addr; p < e; p += sizeof(struct mp))
ffff8000001057c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001057cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001057d1:	eb 50                	jmp    ffff800000105823 <mpsearch1+0x8f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
ffff8000001057d3:	48 b9 18 ca 10 00 00 	movabs $0xffff80000010ca18,%rcx
ffff8000001057da:	80 ff ff 
ffff8000001057dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001057e1:	ba 04 00 00 00       	mov    $0x4,%edx
ffff8000001057e6:	48 89 ce             	mov    %rcx,%rsi
ffff8000001057e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001057ec:	48 b8 27 80 10 00 00 	movabs $0xffff800000108027,%rax
ffff8000001057f3:	80 ff ff 
ffff8000001057f6:	ff d0                	call   *%rax
ffff8000001057f8:	85 c0                	test   %eax,%eax
ffff8000001057fa:	75 22                	jne    ffff80000010581e <mpsearch1+0x8a>
ffff8000001057fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105800:	be 10 00 00 00       	mov    $0x10,%esi
ffff800000105805:	48 89 c7             	mov    %rax,%rdi
ffff800000105808:	48 b8 4e 57 10 00 00 	movabs $0xffff80000010574e,%rax
ffff80000010580f:	80 ff ff 
ffff800000105812:	ff d0                	call   *%rax
ffff800000105814:	84 c0                	test   %al,%al
ffff800000105816:	75 06                	jne    ffff80000010581e <mpsearch1+0x8a>
      return (struct mp*)p;
ffff800000105818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010581c:	eb 14                	jmp    ffff800000105832 <mpsearch1+0x9e>
  for(p = addr; p < e; p += sizeof(struct mp))
ffff80000010581e:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
ffff800000105823:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105827:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff80000010582b:	72 a6                	jb     ffff8000001057d3 <mpsearch1+0x3f>
  return 0;
ffff80000010582d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000105832:	c9                   	leave
ffff800000105833:	c3                   	ret

ffff800000105834 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
ffff800000105834:	55                   	push   %rbp
ffff800000105835:	48 89 e5             	mov    %rsp,%rbp
ffff800000105838:	48 83 ec 20          	sub    $0x20,%rsp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
ffff80000010583c:	48 b8 00 04 00 00 00 	movabs $0xffff800000000400,%rax
ffff800000105843:	80 ff ff 
ffff800000105846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
ffff80000010584a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010584e:	48 83 c0 0f          	add    $0xf,%rax
ffff800000105852:	0f b6 00             	movzbl (%rax),%eax
ffff800000105855:	0f b6 c0             	movzbl %al,%eax
ffff800000105858:	c1 e0 08             	shl    $0x8,%eax
ffff80000010585b:	89 c2                	mov    %eax,%edx
ffff80000010585d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105861:	48 83 c0 0e          	add    $0xe,%rax
ffff800000105865:	0f b6 00             	movzbl (%rax),%eax
ffff800000105868:	0f b6 c0             	movzbl %al,%eax
ffff80000010586b:	09 d0                	or     %edx,%eax
ffff80000010586d:	c1 e0 04             	shl    $0x4,%eax
ffff800000105870:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffff800000105873:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000105877:	74 28                	je     ffff8000001058a1 <mpsearch+0x6d>
    if((mp = mpsearch1(p, 1024)))
ffff800000105879:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010587c:	be 00 04 00 00       	mov    $0x400,%esi
ffff800000105881:	48 89 c7             	mov    %rax,%rdi
ffff800000105884:	48 b8 94 57 10 00 00 	movabs $0xffff800000105794,%rax
ffff80000010588b:	80 ff ff 
ffff80000010588e:	ff d0                	call   *%rax
ffff800000105890:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105894:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000105899:	74 5e                	je     ffff8000001058f9 <mpsearch+0xc5>
      return mp;
ffff80000010589b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010589f:	eb 6e                	jmp    ffff80000010590f <mpsearch+0xdb>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
ffff8000001058a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058a5:	48 83 c0 14          	add    $0x14,%rax
ffff8000001058a9:	0f b6 00             	movzbl (%rax),%eax
ffff8000001058ac:	0f b6 c0             	movzbl %al,%eax
ffff8000001058af:	c1 e0 08             	shl    $0x8,%eax
ffff8000001058b2:	89 c2                	mov    %eax,%edx
ffff8000001058b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001058b8:	48 83 c0 13          	add    $0x13,%rax
ffff8000001058bc:	0f b6 00             	movzbl (%rax),%eax
ffff8000001058bf:	0f b6 c0             	movzbl %al,%eax
ffff8000001058c2:	09 d0                	or     %edx,%eax
ffff8000001058c4:	c1 e0 0a             	shl    $0xa,%eax
ffff8000001058c7:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if((mp = mpsearch1(p-1024, 1024)))
ffff8000001058ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001058cd:	2d 00 04 00 00       	sub    $0x400,%eax
ffff8000001058d2:	89 c0                	mov    %eax,%eax
ffff8000001058d4:	be 00 04 00 00       	mov    $0x400,%esi
ffff8000001058d9:	48 89 c7             	mov    %rax,%rdi
ffff8000001058dc:	48 b8 94 57 10 00 00 	movabs $0xffff800000105794,%rax
ffff8000001058e3:	80 ff ff 
ffff8000001058e6:	ff d0                	call   *%rax
ffff8000001058e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001058ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001058f1:	74 06                	je     ffff8000001058f9 <mpsearch+0xc5>
      return mp;
ffff8000001058f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001058f7:	eb 16                	jmp    ffff80000010590f <mpsearch+0xdb>
  }
  return mpsearch1(0xF0000, 0x10000);
ffff8000001058f9:	be 00 00 01 00       	mov    $0x10000,%esi
ffff8000001058fe:	bf 00 00 0f 00       	mov    $0xf0000,%edi
ffff800000105903:	48 b8 94 57 10 00 00 	movabs $0xffff800000105794,%rax
ffff80000010590a:	80 ff ff 
ffff80000010590d:	ff d0                	call   *%rax
}
ffff80000010590f:	c9                   	leave
ffff800000105910:	c3                   	ret

ffff800000105911 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
ffff800000105911:	55                   	push   %rbp
ffff800000105912:	48 89 e5             	mov    %rsp,%rbp
ffff800000105915:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105919:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
ffff80000010591d:	48 b8 34 58 10 00 00 	movabs $0xffff800000105834,%rax
ffff800000105924:	80 ff ff 
ffff800000105927:	ff d0                	call   *%rax
ffff800000105929:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010592d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105932:	74 0b                	je     ffff80000010593f <mpconfig+0x2e>
ffff800000105934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105938:	8b 40 04             	mov    0x4(%rax),%eax
ffff80000010593b:	85 c0                	test   %eax,%eax
ffff80000010593d:	75 0a                	jne    ffff800000105949 <mpconfig+0x38>
    return 0;
ffff80000010593f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105944:	e9 a3 00 00 00       	jmp    ffff8000001059ec <mpconfig+0xdb>
  conf = (struct mpconf*) P2V((addr_t) mp->physaddr);
ffff800000105949:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010594d:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105950:	89 c2                	mov    %eax,%edx
ffff800000105952:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105959:	80 ff ff 
ffff80000010595c:	48 01 d0             	add    %rdx,%rax
ffff80000010595f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(memcmp(conf, "PCMP", 4) != 0)
ffff800000105963:	48 b9 1d ca 10 00 00 	movabs $0xffff80000010ca1d,%rcx
ffff80000010596a:	80 ff ff 
ffff80000010596d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105971:	ba 04 00 00 00       	mov    $0x4,%edx
ffff800000105976:	48 89 ce             	mov    %rcx,%rsi
ffff800000105979:	48 89 c7             	mov    %rax,%rdi
ffff80000010597c:	48 b8 27 80 10 00 00 	movabs $0xffff800000108027,%rax
ffff800000105983:	80 ff ff 
ffff800000105986:	ff d0                	call   *%rax
ffff800000105988:	85 c0                	test   %eax,%eax
ffff80000010598a:	74 07                	je     ffff800000105993 <mpconfig+0x82>
    return 0;
ffff80000010598c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105991:	eb 59                	jmp    ffff8000001059ec <mpconfig+0xdb>
  if(conf->version != 1 && conf->version != 4)
ffff800000105993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105997:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff80000010599b:	3c 01                	cmp    $0x1,%al
ffff80000010599d:	74 13                	je     ffff8000001059b2 <mpconfig+0xa1>
ffff80000010599f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001059a3:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffff8000001059a7:	3c 04                	cmp    $0x4,%al
ffff8000001059a9:	74 07                	je     ffff8000001059b2 <mpconfig+0xa1>
    return 0;
ffff8000001059ab:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001059b0:	eb 3a                	jmp    ffff8000001059ec <mpconfig+0xdb>
  if(sum((uchar*)conf, conf->length) != 0)
ffff8000001059b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001059b6:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff8000001059ba:	0f b7 d0             	movzwl %ax,%edx
ffff8000001059bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001059c1:	89 d6                	mov    %edx,%esi
ffff8000001059c3:	48 89 c7             	mov    %rax,%rdi
ffff8000001059c6:	48 b8 4e 57 10 00 00 	movabs $0xffff80000010574e,%rax
ffff8000001059cd:	80 ff ff 
ffff8000001059d0:	ff d0                	call   *%rax
ffff8000001059d2:	84 c0                	test   %al,%al
ffff8000001059d4:	74 07                	je     ffff8000001059dd <mpconfig+0xcc>
    return 0;
ffff8000001059d6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001059db:	eb 0f                	jmp    ffff8000001059ec <mpconfig+0xdb>
  *pmp = mp;
ffff8000001059dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001059e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001059e5:	48 89 10             	mov    %rdx,(%rax)
  return conf;
ffff8000001059e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff8000001059ec:	c9                   	leave
ffff8000001059ed:	c3                   	ret

ffff8000001059ee <mpinit>:

void
mpinit(void)
{
ffff8000001059ee:	55                   	push   %rbp
ffff8000001059ef:	48 89 e5             	mov    %rsp,%rbp
ffff8000001059f2:	48 83 ec 30          	sub    $0x30,%rsp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0) {
ffff8000001059f6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff8000001059fa:	48 89 c7             	mov    %rax,%rdi
ffff8000001059fd:	48 b8 11 59 10 00 00 	movabs $0xffff800000105911,%rax
ffff800000105a04:	80 ff ff 
ffff800000105a07:	ff d0                	call   *%rax
ffff800000105a09:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000105a0d:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000105a12:	75 23                	jne    ffff800000105a37 <mpinit+0x49>
    cprintf("No other CPUs found.\n");
ffff800000105a14:	48 b8 22 ca 10 00 00 	movabs $0xffff80000010ca22,%rax
ffff800000105a1b:	80 ff ff 
ffff800000105a1e:	48 89 c7             	mov    %rax,%rdi
ffff800000105a21:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105a26:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000105a2d:	80 ff ff 
ffff800000105a30:	ff d2                	call   *%rdx
ffff800000105a32:	e9 c9 01 00 00       	jmp    ffff800000105c00 <mpinit+0x212>
    return;
  }
  lapic = P2V((addr_t)conf->lapicaddr_p);
ffff800000105a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a3b:	8b 40 24             	mov    0x24(%rax),%eax
ffff800000105a3e:	89 c2                	mov    %eax,%edx
ffff800000105a40:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff800000105a47:	80 ff ff 
ffff800000105a4a:	48 01 d0             	add    %rdx,%rax
ffff800000105a4d:	48 89 c2             	mov    %rax,%rdx
ffff800000105a50:	48 b8 c0 71 11 00 00 	movabs $0xffff8000001171c0,%rax
ffff800000105a57:	80 ff ff 
ffff800000105a5a:	48 89 10             	mov    %rdx,(%rax)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105a5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a61:	48 83 c0 2c          	add    $0x2c,%rax
ffff800000105a65:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a6d:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffff800000105a71:	0f b7 d0             	movzwl %ax,%edx
ffff800000105a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105a78:	48 01 d0             	add    %rdx,%rax
ffff800000105a7b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105a7f:	e9 f6 00 00 00       	jmp    ffff800000105b7a <mpinit+0x18c>
    switch(*p){
ffff800000105a84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a88:	0f b6 00             	movzbl (%rax),%eax
ffff800000105a8b:	0f b6 c0             	movzbl %al,%eax
ffff800000105a8e:	83 f8 04             	cmp    $0x4,%eax
ffff800000105a91:	0f 8f ca 00 00 00    	jg     ffff800000105b61 <mpinit+0x173>
ffff800000105a97:	83 f8 03             	cmp    $0x3,%eax
ffff800000105a9a:	0f 8d ba 00 00 00    	jge    ffff800000105b5a <mpinit+0x16c>
ffff800000105aa0:	83 f8 02             	cmp    $0x2,%eax
ffff800000105aa3:	0f 84 8e 00 00 00    	je     ffff800000105b37 <mpinit+0x149>
ffff800000105aa9:	83 f8 02             	cmp    $0x2,%eax
ffff800000105aac:	0f 8f af 00 00 00    	jg     ffff800000105b61 <mpinit+0x173>
ffff800000105ab2:	85 c0                	test   %eax,%eax
ffff800000105ab4:	74 0e                	je     ffff800000105ac4 <mpinit+0xd6>
ffff800000105ab6:	83 f8 01             	cmp    $0x1,%eax
ffff800000105ab9:	0f 84 9b 00 00 00    	je     ffff800000105b5a <mpinit+0x16c>
ffff800000105abf:	e9 9d 00 00 00       	jmp    ffff800000105b61 <mpinit+0x173>
    case MPPROC:
      proc = (struct mpproc*)p;
ffff800000105ac4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ac8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      if(ncpu < NCPU) {
ffff800000105acc:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105ad3:	80 ff ff 
ffff800000105ad6:	8b 00                	mov    (%rax),%eax
ffff800000105ad8:	83 f8 07             	cmp    $0x7,%eax
ffff800000105adb:	7f 53                	jg     ffff800000105b30 <mpinit+0x142>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
ffff800000105add:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105ae4:	80 ff ff 
ffff800000105ae7:	8b 10                	mov    (%rax),%edx
ffff800000105ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105aed:	0f b6 48 01          	movzbl 0x1(%rax),%ecx
ffff800000105af1:	48 be e0 72 11 00 00 	movabs $0xffff8000001172e0,%rsi
ffff800000105af8:	80 ff ff 
ffff800000105afb:	48 63 d2             	movslq %edx,%rdx
ffff800000105afe:	48 89 d0             	mov    %rdx,%rax
ffff800000105b01:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000105b05:	48 01 d0             	add    %rdx,%rax
ffff800000105b08:	48 c1 e0 03          	shl    $0x3,%rax
ffff800000105b0c:	48 01 f0             	add    %rsi,%rax
ffff800000105b0f:	48 83 c0 01          	add    $0x1,%rax
ffff800000105b13:	88 08                	mov    %cl,(%rax)
        ncpu++;
ffff800000105b15:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105b1c:	80 ff ff 
ffff800000105b1f:	8b 00                	mov    (%rax),%eax
ffff800000105b21:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105b24:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105b2b:	80 ff ff 
ffff800000105b2e:	89 10                	mov    %edx,(%rax)
      }
      p += sizeof(struct mpproc);
ffff800000105b30:	48 83 45 f8 14       	addq   $0x14,-0x8(%rbp)
      continue;
ffff800000105b35:	eb 43                	jmp    ffff800000105b7a <mpinit+0x18c>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
ffff800000105b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b3b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      ioapicid = ioapic->apicno;
ffff800000105b3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105b43:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffff800000105b47:	48 ba 24 74 11 00 00 	movabs $0xffff800000117424,%rdx
ffff800000105b4e:	80 ff ff 
ffff800000105b51:	88 02                	mov    %al,(%rdx)
      p += sizeof(struct mpioapic);
ffff800000105b53:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105b58:	eb 20                	jmp    ffff800000105b7a <mpinit+0x18c>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
ffff800000105b5a:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffff800000105b5f:	eb 19                	jmp    ffff800000105b7a <mpinit+0x18c>
    default:
      panic("Major problem parsing mp config.");
ffff800000105b61:	48 b8 38 ca 10 00 00 	movabs $0xffff80000010ca38,%rax
ffff800000105b68:	80 ff ff 
ffff800000105b6b:	48 89 c7             	mov    %rax,%rdi
ffff800000105b6e:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000105b75:	80 ff ff 
ffff800000105b78:	ff d0                	call   *%rax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffff800000105b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b7e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000105b82:	0f 82 fc fe ff ff    	jb     ffff800000105a84 <mpinit+0x96>
      break;
    }
  }
  cprintf("Seems we are SMP, ncpu = %d\n",ncpu);
ffff800000105b88:	48 b8 20 74 11 00 00 	movabs $0xffff800000117420,%rax
ffff800000105b8f:	80 ff ff 
ffff800000105b92:	8b 00                	mov    (%rax),%eax
ffff800000105b94:	48 ba 59 ca 10 00 00 	movabs $0xffff80000010ca59,%rdx
ffff800000105b9b:	80 ff ff 
ffff800000105b9e:	89 c6                	mov    %eax,%esi
ffff800000105ba0:	48 89 d7             	mov    %rdx,%rdi
ffff800000105ba3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105ba8:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000105baf:	80 ff ff 
ffff800000105bb2:	ff d2                	call   *%rdx
  if(mp->imcrp){
ffff800000105bb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000105bb8:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
ffff800000105bbc:	84 c0                	test   %al,%al
ffff800000105bbe:	74 40                	je     ffff800000105c00 <mpinit+0x212>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
ffff800000105bc0:	be 70 00 00 00       	mov    $0x70,%esi
ffff800000105bc5:	bf 22 00 00 00       	mov    $0x22,%edi
ffff800000105bca:	48 b8 2f 57 10 00 00 	movabs $0xffff80000010572f,%rax
ffff800000105bd1:	80 ff ff 
ffff800000105bd4:	ff d0                	call   *%rax
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
ffff800000105bd6:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105bdb:	48 b8 11 57 10 00 00 	movabs $0xffff800000105711,%rax
ffff800000105be2:	80 ff ff 
ffff800000105be5:	ff d0                	call   *%rax
ffff800000105be7:	83 c8 01             	or     $0x1,%eax
ffff800000105bea:	0f b6 c0             	movzbl %al,%eax
ffff800000105bed:	89 c6                	mov    %eax,%esi
ffff800000105bef:	bf 23 00 00 00       	mov    $0x23,%edi
ffff800000105bf4:	48 b8 2f 57 10 00 00 	movabs $0xffff80000010572f,%rax
ffff800000105bfb:	80 ff ff 
ffff800000105bfe:	ff d0                	call   *%rax
  }
}
ffff800000105c00:	c9                   	leave
ffff800000105c01:	c3                   	ret

ffff800000105c02 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
ffff800000105c02:	55                   	push   %rbp
ffff800000105c03:	48 89 e5             	mov    %rsp,%rbp
ffff800000105c06:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000105c0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105c0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipe *p;

  p = 0;
ffff800000105c12:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff800000105c19:	00 
  *f0 = *f1 = 0;
ffff800000105c1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105c1e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
ffff800000105c25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105c29:	48 8b 10             	mov    (%rax),%rdx
ffff800000105c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105c30:	48 89 10             	mov    %rdx,(%rax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
ffff800000105c33:	48 b8 4a 1b 10 00 00 	movabs $0xffff800000101b4a,%rax
ffff800000105c3a:	80 ff ff 
ffff800000105c3d:	ff d0                	call   *%rax
ffff800000105c3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105c43:	48 89 02             	mov    %rax,(%rdx)
ffff800000105c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105c4a:	48 8b 00             	mov    (%rax),%rax
ffff800000105c4d:	48 85 c0             	test   %rax,%rax
ffff800000105c50:	0f 84 01 01 00 00    	je     ffff800000105d57 <pipealloc+0x155>
ffff800000105c56:	48 b8 4a 1b 10 00 00 	movabs $0xffff800000101b4a,%rax
ffff800000105c5d:	80 ff ff 
ffff800000105c60:	ff d0                	call   *%rax
ffff800000105c62:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000105c66:	48 89 02             	mov    %rax,(%rdx)
ffff800000105c69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105c6d:	48 8b 00             	mov    (%rax),%rax
ffff800000105c70:	48 85 c0             	test   %rax,%rax
ffff800000105c73:	0f 84 de 00 00 00    	je     ffff800000105d57 <pipealloc+0x155>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
ffff800000105c79:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff800000105c80:	80 ff ff 
ffff800000105c83:	ff d0                	call   *%rax
ffff800000105c85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105c89:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105c8e:	0f 84 c6 00 00 00    	je     ffff800000105d5a <pipealloc+0x158>
    goto bad;
  p->readopen = 1;
ffff800000105c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105c98:	c7 80 70 02 00 00 01 	movl   $0x1,0x270(%rax)
ffff800000105c9f:	00 00 00 
  p->writeopen = 1;
ffff800000105ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105ca6:	c7 80 74 02 00 00 01 	movl   $0x1,0x274(%rax)
ffff800000105cad:	00 00 00 
  p->nwrite = 0;
ffff800000105cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105cb4:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%rax)
ffff800000105cbb:	00 00 00 
  p->nread = 0;
ffff800000105cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105cc2:	c7 80 68 02 00 00 00 	movl   $0x0,0x268(%rax)
ffff800000105cc9:	00 00 00 
  initlock(&p->lock, "pipe");
ffff800000105ccc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105cd0:	48 ba 76 ca 10 00 00 	movabs $0xffff80000010ca76,%rdx
ffff800000105cd7:	80 ff ff 
ffff800000105cda:	48 89 d6             	mov    %rdx,%rsi
ffff800000105cdd:	48 89 c7             	mov    %rax,%rdi
ffff800000105ce0:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000105ce7:	80 ff ff 
ffff800000105cea:	ff d0                	call   *%rax
  (*f0)->type = FD_PIPE;
ffff800000105cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105cf0:	48 8b 00             	mov    (%rax),%rax
ffff800000105cf3:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f0)->readable = 1;
ffff800000105cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105cfd:	48 8b 00             	mov    (%rax),%rax
ffff800000105d00:	c6 40 08 01          	movb   $0x1,0x8(%rax)
  (*f0)->writable = 0;
ffff800000105d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105d08:	48 8b 00             	mov    (%rax),%rax
ffff800000105d0b:	c6 40 09 00          	movb   $0x0,0x9(%rax)
  (*f0)->pipe = p;
ffff800000105d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105d13:	48 8b 00             	mov    (%rax),%rax
ffff800000105d16:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105d1a:	48 89 50 10          	mov    %rdx,0x10(%rax)
  (*f1)->type = FD_PIPE;
ffff800000105d1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d22:	48 8b 00             	mov    (%rax),%rax
ffff800000105d25:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f1)->readable = 0;
ffff800000105d2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d2f:	48 8b 00             	mov    (%rax),%rax
ffff800000105d32:	c6 40 08 00          	movb   $0x0,0x8(%rax)
  (*f1)->writable = 1;
ffff800000105d36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d3a:	48 8b 00             	mov    (%rax),%rax
ffff800000105d3d:	c6 40 09 01          	movb   $0x1,0x9(%rax)
  (*f1)->pipe = p;
ffff800000105d41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d45:	48 8b 00             	mov    (%rax),%rax
ffff800000105d48:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105d4c:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return 0;
ffff800000105d50:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000105d55:	eb 67                	jmp    ffff800000105dbe <pipealloc+0x1bc>
    goto bad;
ffff800000105d57:	90                   	nop
ffff800000105d58:	eb 01                	jmp    ffff800000105d5b <pipealloc+0x159>
    goto bad;
ffff800000105d5a:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
ffff800000105d5b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000105d60:	74 13                	je     ffff800000105d75 <pipealloc+0x173>
    kfree((char*)p);
ffff800000105d62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105d66:	48 89 c7             	mov    %rax,%rdi
ffff800000105d69:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff800000105d70:	80 ff ff 
ffff800000105d73:	ff d0                	call   *%rax
  if(*f0)
ffff800000105d75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105d79:	48 8b 00             	mov    (%rax),%rax
ffff800000105d7c:	48 85 c0             	test   %rax,%rax
ffff800000105d7f:	74 16                	je     ffff800000105d97 <pipealloc+0x195>
    fileclose(*f0);
ffff800000105d81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105d85:	48 8b 00             	mov    (%rax),%rax
ffff800000105d88:	48 89 c7             	mov    %rax,%rdi
ffff800000105d8b:	48 b8 5e 1c 10 00 00 	movabs $0xffff800000101c5e,%rax
ffff800000105d92:	80 ff ff 
ffff800000105d95:	ff d0                	call   *%rax
  if(*f1)
ffff800000105d97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105d9b:	48 8b 00             	mov    (%rax),%rax
ffff800000105d9e:	48 85 c0             	test   %rax,%rax
ffff800000105da1:	74 16                	je     ffff800000105db9 <pipealloc+0x1b7>
    fileclose(*f1);
ffff800000105da3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105da7:	48 8b 00             	mov    (%rax),%rax
ffff800000105daa:	48 89 c7             	mov    %rax,%rdi
ffff800000105dad:	48 b8 5e 1c 10 00 00 	movabs $0xffff800000101c5e,%rax
ffff800000105db4:	80 ff ff 
ffff800000105db7:	ff d0                	call   *%rax
  return -1;
ffff800000105db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000105dbe:	c9                   	leave
ffff800000105dbf:	c3                   	ret

ffff800000105dc0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
ffff800000105dc0:	55                   	push   %rbp
ffff800000105dc1:	48 89 e5             	mov    %rsp,%rbp
ffff800000105dc4:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000105dc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000105dcc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  acquire(&p->lock);
ffff800000105dcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105dd3:	48 89 c7             	mov    %rax,%rdi
ffff800000105dd6:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000105ddd:	80 ff ff 
ffff800000105de0:	ff d0                	call   *%rax
  if(writable){
ffff800000105de2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000105de6:	74 29                	je     ffff800000105e11 <pipeclose+0x51>
    p->writeopen = 0;
ffff800000105de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105dec:	c7 80 74 02 00 00 00 	movl   $0x0,0x274(%rax)
ffff800000105df3:	00 00 00 
    wakeup(&p->nread);
ffff800000105df6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105dfa:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000105e00:	48 89 c7             	mov    %rax,%rdi
ffff800000105e03:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff800000105e0a:	80 ff ff 
ffff800000105e0d:	ff d0                	call   *%rax
ffff800000105e0f:	eb 27                	jmp    ffff800000105e38 <pipeclose+0x78>
  } else {
    p->readopen = 0;
ffff800000105e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e15:	c7 80 70 02 00 00 00 	movl   $0x0,0x270(%rax)
ffff800000105e1c:	00 00 00 
    wakeup(&p->nwrite);
ffff800000105e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e23:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff800000105e29:	48 89 c7             	mov    %rax,%rdi
ffff800000105e2c:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff800000105e33:	80 ff ff 
ffff800000105e36:	ff d0                	call   *%rax
  }
  if(p->readopen == 0 && p->writeopen == 0){
ffff800000105e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e3c:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff800000105e42:	85 c0                	test   %eax,%eax
ffff800000105e44:	75 36                	jne    ffff800000105e7c <pipeclose+0xbc>
ffff800000105e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e4a:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff800000105e50:	85 c0                	test   %eax,%eax
ffff800000105e52:	75 28                	jne    ffff800000105e7c <pipeclose+0xbc>
    release(&p->lock);
ffff800000105e54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e58:	48 89 c7             	mov    %rax,%rdi
ffff800000105e5b:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000105e62:	80 ff ff 
ffff800000105e65:	ff d0                	call   *%rax
    kfree((char*)p);
ffff800000105e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e6b:	48 89 c7             	mov    %rax,%rdi
ffff800000105e6e:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff800000105e75:	80 ff ff 
ffff800000105e78:	ff d0                	call   *%rax
ffff800000105e7a:	eb 14                	jmp    ffff800000105e90 <pipeclose+0xd0>
  } else
    release(&p->lock);
ffff800000105e7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105e80:	48 89 c7             	mov    %rax,%rdi
ffff800000105e83:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000105e8a:	80 ff ff 
ffff800000105e8d:	ff d0                	call   *%rax
}
ffff800000105e8f:	90                   	nop
ffff800000105e90:	90                   	nop
ffff800000105e91:	c9                   	leave
ffff800000105e92:	c3                   	ret

ffff800000105e93 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
ffff800000105e93:	55                   	push   %rbp
ffff800000105e94:	48 89 e5             	mov    %rsp,%rbp
ffff800000105e97:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000105e9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105e9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000105ea3:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff800000105ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105eaa:	48 89 c7             	mov    %rax,%rdi
ffff800000105ead:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000105eb4:	80 ff ff 
ffff800000105eb7:	ff d0                	call   *%rax
  for(i = 0; i < n; i++){
ffff800000105eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105ec0:	e9 d5 00 00 00       	jmp    ffff800000105f9a <pipewrite+0x107>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
ffff800000105ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105ec9:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffff800000105ecf:	85 c0                	test   %eax,%eax
ffff800000105ed1:	74 12                	je     ffff800000105ee5 <pipewrite+0x52>
ffff800000105ed3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000105eda:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000105ede:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000105ee1:	85 c0                	test   %eax,%eax
ffff800000105ee3:	74 1d                	je     ffff800000105f02 <pipewrite+0x6f>
        release(&p->lock);
ffff800000105ee5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105ee9:	48 89 c7             	mov    %rax,%rdi
ffff800000105eec:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000105ef3:	80 ff ff 
ffff800000105ef6:	ff d0                	call   *%rax
        return -1;
ffff800000105ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000105efd:	e9 cf 00 00 00       	jmp    ffff800000105fd1 <pipewrite+0x13e>
      }
      wakeup(&p->nread);
ffff800000105f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f06:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000105f0c:	48 89 c7             	mov    %rax,%rdi
ffff800000105f0f:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff800000105f16:	80 ff ff 
ffff800000105f19:	ff d0                	call   *%rax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
ffff800000105f1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105f23:	48 81 c2 6c 02 00 00 	add    $0x26c,%rdx
ffff800000105f2a:	48 89 c6             	mov    %rax,%rsi
ffff800000105f2d:	48 89 d7             	mov    %rdx,%rdi
ffff800000105f30:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000105f37:	80 ff ff 
ffff800000105f3a:	ff d0                	call   *%rax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
ffff800000105f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f40:	8b 90 6c 02 00 00    	mov    0x26c(%rax),%edx
ffff800000105f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f4a:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff800000105f50:	05 00 02 00 00       	add    $0x200,%eax
ffff800000105f55:	39 c2                	cmp    %eax,%edx
ffff800000105f57:	0f 84 68 ff ff ff    	je     ffff800000105ec5 <pipewrite+0x32>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
ffff800000105f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105f60:	48 63 d0             	movslq %eax,%rdx
ffff800000105f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000105f67:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
ffff800000105f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f6f:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff800000105f75:	8d 48 01             	lea    0x1(%rax),%ecx
ffff800000105f78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000105f7c:	89 8a 6c 02 00 00    	mov    %ecx,0x26c(%rdx)
ffff800000105f82:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff800000105f87:	89 c1                	mov    %eax,%ecx
ffff800000105f89:	0f b6 16             	movzbl (%rsi),%edx
ffff800000105f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105f90:	89 c9                	mov    %ecx,%ecx
ffff800000105f92:	88 54 08 68          	mov    %dl,0x68(%rax,%rcx,1)
  for(i = 0; i < n; i++){
ffff800000105f96:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105f9d:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff800000105fa0:	7c 9a                	jl     ffff800000105f3c <pipewrite+0xa9>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
ffff800000105fa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fa6:	48 05 68 02 00 00    	add    $0x268,%rax
ffff800000105fac:	48 89 c7             	mov    %rax,%rdi
ffff800000105faf:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff800000105fb6:	80 ff ff 
ffff800000105fb9:	ff d0                	call   *%rax
  release(&p->lock);
ffff800000105fbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fbf:	48 89 c7             	mov    %rax,%rdi
ffff800000105fc2:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000105fc9:	80 ff ff 
ffff800000105fcc:	ff d0                	call   *%rax
  return n;
ffff800000105fce:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff800000105fd1:	c9                   	leave
ffff800000105fd2:	c3                   	ret

ffff800000105fd3 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
ffff800000105fd3:	55                   	push   %rbp
ffff800000105fd4:	48 89 e5             	mov    %rsp,%rbp
ffff800000105fd7:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000105fdb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105fdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000105fe3:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffff800000105fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105fea:	48 89 c7             	mov    %rax,%rdi
ffff800000105fed:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000105ff4:	80 ff ff 
ffff800000105ff7:	ff d0                	call   *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff800000105ff9:	eb 50                	jmp    ffff80000010604b <piperead+0x78>
    if(proc->killed){
ffff800000105ffb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106002:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106006:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000106009:	85 c0                	test   %eax,%eax
ffff80000010600b:	74 1d                	je     ffff80000010602a <piperead+0x57>
      release(&p->lock);
ffff80000010600d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106011:	48 89 c7             	mov    %rax,%rdi
ffff800000106014:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010601b:	80 ff ff 
ffff80000010601e:	ff d0                	call   *%rax
      return -1;
ffff800000106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106025:	e9 de 00 00 00       	jmp    ffff800000106108 <piperead+0x135>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
ffff80000010602a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010602e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106032:	48 81 c2 68 02 00 00 	add    $0x268,%rdx
ffff800000106039:	48 89 c6             	mov    %rax,%rsi
ffff80000010603c:	48 89 d7             	mov    %rdx,%rdi
ffff80000010603f:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000106046:	80 ff ff 
ffff800000106049:	ff d0                	call   *%rax
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffff80000010604b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010604f:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106059:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010605f:	39 c2                	cmp    %eax,%edx
ffff800000106061:	75 0e                	jne    ffff800000106071 <piperead+0x9e>
ffff800000106063:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106067:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffff80000010606d:	85 c0                	test   %eax,%eax
ffff80000010606f:	75 8a                	jne    ffff800000105ffb <piperead+0x28>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff800000106071:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000106078:	eb 54                	jmp    ffff8000001060ce <piperead+0xfb>
    if(p->nread == p->nwrite)
ffff80000010607a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010607e:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffff800000106084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106088:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffff80000010608e:	39 c2                	cmp    %eax,%edx
ffff800000106090:	74 46                	je     ffff8000001060d8 <piperead+0x105>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
ffff800000106092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106096:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffff80000010609c:	8d 48 01             	lea    0x1(%rax),%ecx
ffff80000010609f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001060a3:	89 8a 68 02 00 00    	mov    %ecx,0x268(%rdx)
ffff8000001060a9:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff8000001060ae:	89 c1                	mov    %eax,%ecx
ffff8000001060b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001060b3:	48 63 d0             	movslq %eax,%rdx
ffff8000001060b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001060ba:	48 01 c2             	add    %rax,%rdx
ffff8000001060bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060c1:	89 c9                	mov    %ecx,%ecx
ffff8000001060c3:	0f b6 44 08 68       	movzbl 0x68(%rax,%rcx,1),%eax
ffff8000001060c8:	88 02                	mov    %al,(%rdx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffff8000001060ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001060ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001060d1:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffff8000001060d4:	7c a4                	jl     ffff80000010607a <piperead+0xa7>
ffff8000001060d6:	eb 01                	jmp    ffff8000001060d9 <piperead+0x106>
      break;
ffff8000001060d8:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
ffff8000001060d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060dd:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffff8000001060e3:	48 89 c7             	mov    %rax,%rdi
ffff8000001060e6:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff8000001060ed:	80 ff ff 
ffff8000001060f0:	ff d0                	call   *%rax
  release(&p->lock);
ffff8000001060f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001060f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001060f9:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106100:	80 ff ff 
ffff800000106103:	ff d0                	call   *%rax
  return i;
ffff800000106105:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000106108:	c9                   	leave
ffff800000106109:	c3                   	ret

ffff80000010610a <readeflags>:
{
ffff80000010610a:	55                   	push   %rbp
ffff80000010610b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010610e:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff800000106112:	9c                   	pushf
ffff800000106113:	58                   	pop    %rax
ffff800000106114:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000106118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff80000010611c:	c9                   	leave
ffff80000010611d:	c3                   	ret

ffff80000010611e <sti>:
{
ffff80000010611e:	55                   	push   %rbp
ffff80000010611f:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff800000106122:	fb                   	sti
}
ffff800000106123:	90                   	nop
ffff800000106124:	5d                   	pop    %rbp
ffff800000106125:	c3                   	ret

ffff800000106126 <hlt>:
{
ffff800000106126:	55                   	push   %rbp
ffff800000106127:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffff80000010612a:	f4                   	hlt
}
ffff80000010612b:	90                   	nop
ffff80000010612c:	5d                   	pop    %rbp
ffff80000010612d:	c3                   	ret

ffff80000010612e <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
ffff80000010612e:	55                   	push   %rbp
ffff80000010612f:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ptable.lock, "ptable");
ffff800000106132:	48 ba 80 ca 10 00 00 	movabs $0xffff80000010ca80,%rdx
ffff800000106139:	80 ff ff 
ffff80000010613c:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106143:	80 ff ff 
ffff800000106146:	48 89 d6             	mov    %rdx,%rsi
ffff800000106149:	48 89 c7             	mov    %rax,%rdi
ffff80000010614c:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000106153:	80 ff ff 
ffff800000106156:	ff d0                	call   *%rax
}
ffff800000106158:	90                   	nop
ffff800000106159:	5d                   	pop    %rbp
ffff80000010615a:	c3                   	ret

ffff80000010615b <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
ffff80000010615b:	55                   	push   %rbp
ffff80000010615c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010615f:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
ffff800000106163:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff80000010616a:	80 ff ff 
ffff80000010616d:	48 89 c7             	mov    %rax,%rdi
ffff800000106170:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000106177:	80 ff ff 
ffff80000010617a:	ff d0                	call   *%rax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff80000010617c:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106183:	80 ff ff 
ffff800000106186:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010618a:	eb 13                	jmp    ffff80000010619f <allocproc+0x44>
    if(p->state == UNUSED)
ffff80000010618c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106190:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106193:	85 c0                	test   %eax,%eax
ffff800000106195:	74 3b                	je     ffff8000001061d2 <allocproc+0x77>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000106197:	48 81 45 f8 a0 03 00 	addq   $0x3a0,-0x8(%rbp)
ffff80000010619e:	00 
ffff80000010619f:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff8000001061a6:	80 ff ff 
ffff8000001061a9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001061ad:	72 dd                	jb     ffff80000010618c <allocproc+0x31>
      goto found;

  release(&ptable.lock);
ffff8000001061af:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001061b6:	80 ff ff 
ffff8000001061b9:	48 89 c7             	mov    %rax,%rdi
ffff8000001061bc:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001061c3:	80 ff ff 
ffff8000001061c6:	ff d0                	call   *%rax
  return 0;
ffff8000001061c8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001061cd:	e9 13 01 00 00       	jmp    ffff8000001062e5 <allocproc+0x18a>
      goto found;
ffff8000001061d2:	90                   	nop

found:
  p->state = EMBRYO;
ffff8000001061d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001061d7:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%rax)
  p->signal_pending = 0;
ffff8000001061de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001061e2:	c7 80 98 03 00 00 00 	movl   $0x0,0x398(%rax)
ffff8000001061e9:	00 00 00 
  p->pid = nextpid++;
ffff8000001061ec:	48 b8 40 d5 10 00 00 	movabs $0xffff80000010d540,%rax
ffff8000001061f3:	80 ff ff 
ffff8000001061f6:	8b 00                	mov    (%rax),%eax
ffff8000001061f8:	8d 50 01             	lea    0x1(%rax),%edx
ffff8000001061fb:	48 b9 40 d5 10 00 00 	movabs $0xffff80000010d540,%rcx
ffff800000106202:	80 ff ff 
ffff800000106205:	89 11                	mov    %edx,(%rcx)
ffff800000106207:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010620b:	89 42 1c             	mov    %eax,0x1c(%rdx)

  release(&ptable.lock);
ffff80000010620e:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106215:	80 ff ff 
ffff800000106218:	48 89 c7             	mov    %rax,%rdi
ffff80000010621b:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106222:	80 ff ff 
ffff800000106225:	ff d0                	call   *%rax

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
ffff800000106227:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010622e:	80 ff ff 
ffff800000106231:	ff d0                	call   *%rax
ffff800000106233:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106237:	48 89 42 10          	mov    %rax,0x10(%rdx)
ffff80000010623b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010623f:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106243:	48 85 c0             	test   %rax,%rax
ffff800000106246:	75 15                	jne    ffff80000010625d <allocproc+0x102>
    p->state = UNUSED;
ffff800000106248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010624c:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return 0;
ffff800000106253:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106258:	e9 88 00 00 00       	jmp    ffff8000001062e5 <allocproc+0x18a>
  }
  sp = p->kstack + KSTACKSIZE;
ffff80000010625d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106261:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106265:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010626b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
ffff80000010626f:	48 81 6d f0 b0 00 00 	subq   $0xb0,-0x10(%rbp)
ffff800000106276:	00 
  p->tf = (struct trapframe*)sp;
ffff800000106277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010627b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010627f:	48 89 50 28          	mov    %rdx,0x28(%rax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= sizeof(addr_t);
ffff800000106283:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(addr_t*)sp = (addr_t)syscall_trapret;
ffff800000106288:	48 ba 62 9e 10 00 00 	movabs $0xffff800000109e62,%rdx
ffff80000010628f:	80 ff ff 
ffff800000106292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106296:	48 89 10             	mov    %rdx,(%rax)

  sp -= sizeof *p->context;
ffff800000106299:	48 83 6d f0 38       	subq   $0x38,-0x10(%rbp)
  p->context = (struct context*)sp;
ffff80000010629e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001062a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001062a6:	48 89 50 30          	mov    %rdx,0x30(%rax)
  memset(p->context, 0, sizeof *p->context);
ffff8000001062aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001062ae:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001062b2:	ba 38 00 00 00       	mov    $0x38,%edx
ffff8000001062b7:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001062bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001062bf:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff8000001062c6:	80 ff ff 
ffff8000001062c9:	ff d0                	call   *%rax
  p->context->rip = (addr_t)forkret;
ffff8000001062cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001062cf:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001062d3:	48 ba fd 6d 10 00 00 	movabs $0xffff800000106dfd,%rdx
ffff8000001062da:	80 ff ff 
ffff8000001062dd:	48 89 50 30          	mov    %rdx,0x30(%rax)

  return p;
ffff8000001062e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001062e5:	c9                   	leave
ffff8000001062e6:	c3                   	ret

ffff8000001062e7 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
ffff8000001062e7:	55                   	push   %rbp
ffff8000001062e8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001062eb:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
ffff8000001062ef:	48 b8 5b 61 10 00 00 	movabs $0xffff80000010615b,%rax
ffff8000001062f6:	80 ff ff 
ffff8000001062f9:	ff d0                	call   *%rax
ffff8000001062fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  initproc = p;
ffff8000001062ff:	48 ba a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rdx
ffff800000106306:	80 ff ff 
ffff800000106309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010630d:	48 89 02             	mov    %rax,(%rdx)
  if((p->pgdir = setupkvm()) == 0)
ffff800000106310:	48 b8 21 b8 10 00 00 	movabs $0xffff80000010b821,%rax
ffff800000106317:	80 ff ff 
ffff80000010631a:	ff d0                	call   *%rax
ffff80000010631c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106320:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff800000106324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106328:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010632c:	48 85 c0             	test   %rax,%rax
ffff80000010632f:	75 19                	jne    ffff80000010634a <userinit+0x63>
    panic("userinit: out of memory?");
ffff800000106331:	48 b8 87 ca 10 00 00 	movabs $0xffff80000010ca87,%rax
ffff800000106338:	80 ff ff 
ffff80000010633b:	48 89 c7             	mov    %rax,%rdi
ffff80000010633e:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106345:	80 ff ff 
ffff800000106348:	ff d0                	call   *%rax

  inituvm(p->pgdir, _binary_initcode_start,
ffff80000010634a:	48 b8 40 00 00 00 00 	movabs $0x40,%rax
ffff800000106351:	00 00 00 
ffff800000106354:	89 c2                	mov    %eax,%edx
ffff800000106356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010635a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010635e:	48 b9 70 de 10 00 00 	movabs $0xffff80000010de70,%rcx
ffff800000106365:	80 ff ff 
ffff800000106368:	48 89 ce             	mov    %rcx,%rsi
ffff80000010636b:	48 89 c7             	mov    %rax,%rdi
ffff80000010636e:	48 b8 97 bd 10 00 00 	movabs $0xffff80000010bd97,%rax
ffff800000106375:	80 ff ff 
ffff800000106378:	ff d0                	call   *%rax
          (addr_t)_binary_initcode_size);
  p->sz = PGSIZE * 2;
ffff80000010637a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010637e:	48 c7 00 00 20 00 00 	movq   $0x2000,(%rax)
  memset(p->tf, 0, sizeof(*p->tf));
ffff800000106385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106389:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010638d:	ba b0 00 00 00       	mov    $0xb0,%edx
ffff800000106392:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000106397:	48 89 c7             	mov    %rax,%rdi
ffff80000010639a:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff8000001063a1:	80 ff ff 
ffff8000001063a4:	ff d0                	call   *%rax

  p->tf->r11 = FL_IF;  // with SYSRET, EFLAGS is in R11
ffff8000001063a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063aa:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001063ae:	48 c7 40 50 00 02 00 	movq   $0x200,0x50(%rax)
ffff8000001063b5:	00 
  p->tf->rsp = p->sz;
ffff8000001063b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063ba:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001063be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001063c2:	48 8b 12             	mov    (%rdx),%rdx
ffff8000001063c5:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  p->tf->rcx = PGSIZE;  // with SYSRET, RIP is in RCX
ffff8000001063cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063d0:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001063d4:	48 c7 40 10 00 10 00 	movq   $0x1000,0x10(%rax)
ffff8000001063db:	00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
ffff8000001063dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001063e0:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff8000001063e6:	48 b9 a0 ca 10 00 00 	movabs $0xffff80000010caa0,%rcx
ffff8000001063ed:	80 ff ff 
ffff8000001063f0:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001063f5:	48 89 ce             	mov    %rcx,%rsi
ffff8000001063f8:	48 89 c7             	mov    %rax,%rdi
ffff8000001063fb:	48 b8 49 82 10 00 00 	movabs $0xffff800000108249,%rax
ffff800000106402:	80 ff ff 
ffff800000106405:	ff d0                	call   *%rax
  p->cwd = namei("/");
ffff800000106407:	48 b8 a9 ca 10 00 00 	movabs $0xffff80000010caa9,%rax
ffff80000010640e:	80 ff ff 
ffff800000106411:	48 89 c7             	mov    %rax,%rdi
ffff800000106414:	48 b8 93 37 10 00 00 	movabs $0xffff800000103793,%rax
ffff80000010641b:	80 ff ff 
ffff80000010641e:	ff d0                	call   *%rax
ffff800000106420:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106424:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  __sync_synchronize();
ffff80000010642b:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)
  p->state = RUNNABLE;
ffff800000106431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106435:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
}
ffff80000010643c:	90                   	nop
ffff80000010643d:	c9                   	leave
ffff80000010643e:	c3                   	ret

ffff80000010643f <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int64 n)
{
ffff80000010643f:	55                   	push   %rbp
ffff800000106440:	48 89 e5             	mov    %rsp,%rbp
ffff800000106443:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000106447:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  addr_t sz;

  sz = proc->sz;
ffff80000010644b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106452:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106456:	48 8b 00             	mov    (%rax),%rax
ffff800000106459:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n > 0){
ffff80000010645d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000106462:	7e 42                	jle    ffff8000001064a6 <growproc+0x67>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff800000106464:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000106468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010646c:	48 01 c2             	add    %rax,%rdx
ffff80000010646f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106476:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010647a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010647e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000106482:	48 89 ce             	mov    %rcx,%rsi
ffff800000106485:	48 89 c7             	mov    %rax,%rdi
ffff800000106488:	48 b8 78 bf 10 00 00 	movabs $0xffff80000010bf78,%rax
ffff80000010648f:	80 ff ff 
ffff800000106492:	ff d0                	call   *%rax
ffff800000106494:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106498:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010649d:	75 50                	jne    ffff8000001064ef <growproc+0xb0>
      return -1;
ffff80000010649f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001064a4:	eb 7a                	jmp    ffff800000106520 <growproc+0xe1>
  } else if(n < 0){
ffff8000001064a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff8000001064ab:	79 42                	jns    ffff8000001064ef <growproc+0xb0>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
ffff8000001064ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001064b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001064b5:	48 01 c2             	add    %rax,%rdx
ffff8000001064b8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001064bf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001064c3:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001064c7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff8000001064cb:	48 89 ce             	mov    %rcx,%rsi
ffff8000001064ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001064d1:	48 b8 bc c0 10 00 00 	movabs $0xffff80000010c0bc,%rax
ffff8000001064d8:	80 ff ff 
ffff8000001064db:	ff d0                	call   *%rax
ffff8000001064dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001064e1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001064e6:	75 07                	jne    ffff8000001064ef <growproc+0xb0>
      return -1;
ffff8000001064e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001064ed:	eb 31                	jmp    ffff800000106520 <growproc+0xe1>
  }
  proc->sz = sz;
ffff8000001064ef:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001064f6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001064fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001064fe:	48 89 10             	mov    %rdx,(%rax)
  switchuvm(proc);
ffff800000106501:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106508:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010650c:	48 89 c7             	mov    %rax,%rdi
ffff80000010650f:	48 b8 7f b9 10 00 00 	movabs $0xffff80000010b97f,%rax
ffff800000106516:	80 ff ff 
ffff800000106519:	ff d0                	call   *%rax
  return 0;
ffff80000010651b:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000106520:	c9                   	leave
ffff800000106521:	c3                   	ret

ffff800000106522 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
ffff800000106522:	55                   	push   %rbp
ffff800000106523:	48 89 e5             	mov    %rsp,%rbp
ffff800000106526:	53                   	push   %rbx
ffff800000106527:	48 83 ec 28          	sub    $0x28,%rsp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
ffff80000010652b:	48 b8 5b 61 10 00 00 	movabs $0xffff80000010615b,%rax
ffff800000106532:	80 ff ff 
ffff800000106535:	ff d0                	call   *%rax
ffff800000106537:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff80000010653b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff800000106540:	75 0a                	jne    ffff80000010654c <fork+0x2a>
    return -1;
ffff800000106542:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106547:	e9 88 02 00 00       	jmp    ffff8000001067d4 <fork+0x2b2>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
ffff80000010654c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106553:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106557:	48 8b 00             	mov    (%rax),%rax
ffff80000010655a:	89 c2                	mov    %eax,%edx
ffff80000010655c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106563:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106567:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010656b:	89 d6                	mov    %edx,%esi
ffff80000010656d:	48 89 c7             	mov    %rax,%rdi
ffff800000106570:	48 b8 57 c4 10 00 00 	movabs $0xffff80000010c457,%rax
ffff800000106577:	80 ff ff 
ffff80000010657a:	ff d0                	call   *%rax
ffff80000010657c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106580:	48 89 42 08          	mov    %rax,0x8(%rdx)
ffff800000106584:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106588:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010658c:	48 85 c0             	test   %rax,%rax
ffff80000010658f:	75 38                	jne    ffff8000001065c9 <fork+0xa7>
    kfree(np->kstack);
ffff800000106591:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106595:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106599:	48 89 c7             	mov    %rax,%rdi
ffff80000010659c:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff8000001065a3:	80 ff ff 
ffff8000001065a6:	ff d0                	call   *%rax
    np->kstack = 0;
ffff8000001065a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001065ac:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff8000001065b3:	00 
    np->state = UNUSED;
ffff8000001065b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001065b8:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return -1;
ffff8000001065bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001065c4:	e9 0b 02 00 00       	jmp    ffff8000001067d4 <fork+0x2b2>
  }
  np->sz = proc->sz;
ffff8000001065c9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001065d0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001065d4:	48 8b 10             	mov    (%rax),%rdx
ffff8000001065d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001065db:	48 89 10             	mov    %rdx,(%rax)
  np->parent = proc;
ffff8000001065de:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001065e5:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001065e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001065ed:	48 89 50 20          	mov    %rdx,0x20(%rax)
  *np->tf = *proc->tf;
ffff8000001065f1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001065f8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001065fc:	48 8b 50 28          	mov    0x28(%rax),%rdx
ffff800000106600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106604:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000106608:	48 8b 0a             	mov    (%rdx),%rcx
ffff80000010660b:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
ffff80000010660f:	48 89 08             	mov    %rcx,(%rax)
ffff800000106612:	48 89 58 08          	mov    %rbx,0x8(%rax)
ffff800000106616:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
ffff80000010661a:	48 8b 5a 18          	mov    0x18(%rdx),%rbx
ffff80000010661e:	48 89 48 10          	mov    %rcx,0x10(%rax)
ffff800000106622:	48 89 58 18          	mov    %rbx,0x18(%rax)
ffff800000106626:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
ffff80000010662a:	48 8b 5a 28          	mov    0x28(%rdx),%rbx
ffff80000010662e:	48 89 48 20          	mov    %rcx,0x20(%rax)
ffff800000106632:	48 89 58 28          	mov    %rbx,0x28(%rax)
ffff800000106636:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
ffff80000010663a:	48 8b 5a 38          	mov    0x38(%rdx),%rbx
ffff80000010663e:	48 89 48 30          	mov    %rcx,0x30(%rax)
ffff800000106642:	48 89 58 38          	mov    %rbx,0x38(%rax)
ffff800000106646:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
ffff80000010664a:	48 8b 5a 48          	mov    0x48(%rdx),%rbx
ffff80000010664e:	48 89 48 40          	mov    %rcx,0x40(%rax)
ffff800000106652:	48 89 58 48          	mov    %rbx,0x48(%rax)
ffff800000106656:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
ffff80000010665a:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
ffff80000010665e:	48 89 48 50          	mov    %rcx,0x50(%rax)
ffff800000106662:	48 89 58 58          	mov    %rbx,0x58(%rax)
ffff800000106666:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
ffff80000010666a:	48 8b 5a 68          	mov    0x68(%rdx),%rbx
ffff80000010666e:	48 89 48 60          	mov    %rcx,0x60(%rax)
ffff800000106672:	48 89 58 68          	mov    %rbx,0x68(%rax)
ffff800000106676:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
ffff80000010667a:	48 8b 5a 78          	mov    0x78(%rdx),%rbx
ffff80000010667e:	48 89 48 70          	mov    %rcx,0x70(%rax)
ffff800000106682:	48 89 58 78          	mov    %rbx,0x78(%rax)
ffff800000106686:	48 8b 8a 80 00 00 00 	mov    0x80(%rdx),%rcx
ffff80000010668d:	48 8b 9a 88 00 00 00 	mov    0x88(%rdx),%rbx
ffff800000106694:	48 89 88 80 00 00 00 	mov    %rcx,0x80(%rax)
ffff80000010669b:	48 89 98 88 00 00 00 	mov    %rbx,0x88(%rax)
ffff8000001066a2:	48 8b 8a 90 00 00 00 	mov    0x90(%rdx),%rcx
ffff8000001066a9:	48 8b 9a 98 00 00 00 	mov    0x98(%rdx),%rbx
ffff8000001066b0:	48 89 88 90 00 00 00 	mov    %rcx,0x90(%rax)
ffff8000001066b7:	48 89 98 98 00 00 00 	mov    %rbx,0x98(%rax)
ffff8000001066be:	48 8b 8a a0 00 00 00 	mov    0xa0(%rdx),%rcx
ffff8000001066c5:	48 8b 9a a8 00 00 00 	mov    0xa8(%rdx),%rbx
ffff8000001066cc:	48 89 88 a0 00 00 00 	mov    %rcx,0xa0(%rax)
ffff8000001066d3:	48 89 98 a8 00 00 00 	mov    %rbx,0xa8(%rax)

  // Clear %rax so that fork returns 0 in the child.
  np->tf->rax = 0;
ffff8000001066da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001066de:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001066e2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  for(i = 0; i < NOFILE; i++)
ffff8000001066e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff8000001066f0:	eb 5f                	jmp    ffff800000106751 <fork+0x22f>
    if(proc->ofile[i])
ffff8000001066f2:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001066f9:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001066fd:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000106700:	48 63 d2             	movslq %edx,%rdx
ffff800000106703:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106707:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010670c:	48 85 c0             	test   %rax,%rax
ffff80000010670f:	74 3c                	je     ffff80000010674d <fork+0x22b>
      np->ofile[i] = filedup(proc->ofile[i]);
ffff800000106711:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106718:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010671c:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010671f:	48 63 d2             	movslq %edx,%rdx
ffff800000106722:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106726:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010672b:	48 89 c7             	mov    %rax,%rdi
ffff80000010672e:	48 b8 e5 1b 10 00 00 	movabs $0xffff800000101be5,%rax
ffff800000106735:	80 ff ff 
ffff800000106738:	ff d0                	call   *%rax
ffff80000010673a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010673e:	8b 4d ec             	mov    -0x14(%rbp),%ecx
ffff800000106741:	48 63 c9             	movslq %ecx,%rcx
ffff800000106744:	48 83 c1 08          	add    $0x8,%rcx
ffff800000106748:	48 89 44 ca 08       	mov    %rax,0x8(%rdx,%rcx,8)
  for(i = 0; i < NOFILE; i++)
ffff80000010674d:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffff800000106751:	83 7d ec 0f          	cmpl   $0xf,-0x14(%rbp)
ffff800000106755:	7e 9b                	jle    ffff8000001066f2 <fork+0x1d0>
  np->cwd = idup(proc->cwd);
ffff800000106757:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010675e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106762:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff800000106769:	48 89 c7             	mov    %rax,%rdi
ffff80000010676c:	48 b8 37 28 10 00 00 	movabs $0xffff800000102837,%rax
ffff800000106773:	80 ff ff 
ffff800000106776:	ff d0                	call   *%rax
ffff800000106778:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010677c:	48 89 82 c8 00 00 00 	mov    %rax,0xc8(%rdx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
ffff800000106783:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010678a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010678e:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000106795:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106799:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffff80000010679f:	ba 10 00 00 00       	mov    $0x10,%edx
ffff8000001067a4:	48 89 ce             	mov    %rcx,%rsi
ffff8000001067a7:	48 89 c7             	mov    %rax,%rdi
ffff8000001067aa:	48 b8 49 82 10 00 00 	movabs $0xffff800000108249,%rax
ffff8000001067b1:	80 ff ff 
ffff8000001067b4:	ff d0                	call   *%rax

  pid = np->pid;
ffff8000001067b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067ba:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001067bd:	89 45 dc             	mov    %eax,-0x24(%rbp)

  __sync_synchronize();
ffff8000001067c0:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)
  np->state = RUNNABLE;
ffff8000001067c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001067ca:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)

  return pid;
ffff8000001067d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffff8000001067d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff8000001067d8:	c9                   	leave
ffff8000001067d9:	c3                   	ret

ffff8000001067da <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
ffff8000001067da:	55                   	push   %rbp
ffff8000001067db:	48 89 e5             	mov    %rsp,%rbp
ffff8000001067de:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int fd;

  if(proc == initproc)
ffff8000001067e2:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001067e9:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffff8000001067ed:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff8000001067f4:	80 ff ff 
ffff8000001067f7:	48 8b 00             	mov    (%rax),%rax
ffff8000001067fa:	48 39 c2             	cmp    %rax,%rdx
ffff8000001067fd:	75 19                	jne    ffff800000106818 <exit+0x3e>
    panic("init exiting");
ffff8000001067ff:	48 b8 ab ca 10 00 00 	movabs $0xffff80000010caab,%rax
ffff800000106806:	80 ff ff 
ffff800000106809:	48 89 c7             	mov    %rax,%rdi
ffff80000010680c:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106813:	80 ff ff 
ffff800000106816:	ff d0                	call   *%rax

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
ffff800000106818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff80000010681f:	eb 6a                	jmp    ffff80000010688b <exit+0xb1>
    if(proc->ofile[fd]){
ffff800000106821:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106828:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010682c:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010682f:	48 63 d2             	movslq %edx,%rdx
ffff800000106832:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106836:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010683b:	48 85 c0             	test   %rax,%rax
ffff80000010683e:	74 47                	je     ffff800000106887 <exit+0xad>
      fileclose(proc->ofile[fd]);
ffff800000106840:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106847:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010684b:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010684e:	48 63 d2             	movslq %edx,%rdx
ffff800000106851:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106855:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010685a:	48 89 c7             	mov    %rax,%rdi
ffff80000010685d:	48 b8 5e 1c 10 00 00 	movabs $0xffff800000101c5e,%rax
ffff800000106864:	80 ff ff 
ffff800000106867:	ff d0                	call   *%rax
      proc->ofile[fd] = 0;
ffff800000106869:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106870:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106874:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000106877:	48 63 d2             	movslq %edx,%rdx
ffff80000010687a:	48 83 c2 08          	add    $0x8,%rdx
ffff80000010687e:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000106885:	00 00 
  for(fd = 0; fd < NOFILE; fd++){
ffff800000106887:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010688b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
ffff80000010688f:	7e 90                	jle    ffff800000106821 <exit+0x47>
    }
  }

  begin_op();
ffff800000106891:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff800000106898:	80 ff ff 
ffff80000010689b:	ff d0                	call   *%rax
  iput(proc->cwd);
ffff80000010689d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068a4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001068a8:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff8000001068af:	48 89 c7             	mov    %rax,%rdi
ffff8000001068b2:	48 b8 8f 2a 10 00 00 	movabs $0xffff800000102a8f,%rax
ffff8000001068b9:	80 ff ff 
ffff8000001068bc:	ff d0                	call   *%rax
  end_op();
ffff8000001068be:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff8000001068c5:	80 ff ff 
ffff8000001068c8:	ff d0                	call   *%rax
  proc->cwd = 0;
ffff8000001068ca:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001068d1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001068d5:	48 c7 80 c8 00 00 00 	movq   $0x0,0xc8(%rax)
ffff8000001068dc:	00 00 00 00 

  acquire(&ptable.lock);
ffff8000001068e0:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001068e7:	80 ff ff 
ffff8000001068ea:	48 89 c7             	mov    %rax,%rdi
ffff8000001068ed:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff8000001068f4:	80 ff ff 
ffff8000001068f7:	ff d0                	call   *%rax

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
ffff8000001068f9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106900:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106904:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000106908:	48 89 c7             	mov    %rax,%rdi
ffff80000010690b:	48 b8 77 6f 10 00 00 	movabs $0xffff800000106f77,%rax
ffff800000106912:	80 ff ff 
ffff800000106915:	ff d0                	call   *%rax

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106917:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff80000010691e:	80 ff ff 
ffff800000106921:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106925:	eb 5d                	jmp    ffff800000106984 <exit+0x1aa>
    if(p->parent == proc){
ffff800000106927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010692b:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff80000010692f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106936:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010693a:	48 39 c2             	cmp    %rax,%rdx
ffff80000010693d:	75 3d                	jne    ffff80000010697c <exit+0x1a2>
      p->parent = initproc;
ffff80000010693f:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff800000106946:	80 ff ff 
ffff800000106949:	48 8b 10             	mov    (%rax),%rdx
ffff80000010694c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106950:	48 89 50 20          	mov    %rdx,0x20(%rax)
      if(p->state == ZOMBIE)
ffff800000106954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106958:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010695b:	83 f8 05             	cmp    $0x5,%eax
ffff80000010695e:	75 1c                	jne    ffff80000010697c <exit+0x1a2>
        wakeup1(initproc);
ffff800000106960:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff800000106967:	80 ff ff 
ffff80000010696a:	48 8b 00             	mov    (%rax),%rax
ffff80000010696d:	48 89 c7             	mov    %rax,%rdi
ffff800000106970:	48 b8 77 6f 10 00 00 	movabs $0xffff800000106f77,%rax
ffff800000106977:	80 ff ff 
ffff80000010697a:	ff d0                	call   *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff80000010697c:	48 81 45 f8 a0 03 00 	addq   $0x3a0,-0x8(%rbp)
ffff800000106983:	00 
ffff800000106984:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff80000010698b:	80 ff ff 
ffff80000010698e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106992:	72 93                	jb     ffff800000106927 <exit+0x14d>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
ffff800000106994:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010699b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010699f:	c7 40 18 05 00 00 00 	movl   $0x5,0x18(%rax)
  sched();
ffff8000001069a6:	48 b8 8c 6c 10 00 00 	movabs $0xffff800000106c8c,%rax
ffff8000001069ad:	80 ff ff 
ffff8000001069b0:	ff d0                	call   *%rax
  panic("zombie exit");
ffff8000001069b2:	48 b8 b8 ca 10 00 00 	movabs $0xffff80000010cab8,%rax
ffff8000001069b9:	80 ff ff 
ffff8000001069bc:	48 89 c7             	mov    %rax,%rdi
ffff8000001069bf:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff8000001069c6:	80 ff ff 
ffff8000001069c9:	ff d0                	call   *%rax

ffff8000001069cb <wait>:
//PAGEBREAK!
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
ffff8000001069cb:	55                   	push   %rbp
ffff8000001069cc:	48 89 e5             	mov    %rsp,%rbp
ffff8000001069cf:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
ffff8000001069d3:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001069da:	80 ff ff 
ffff8000001069dd:	48 89 c7             	mov    %rax,%rdi
ffff8000001069e0:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff8000001069e7:	80 ff ff 
ffff8000001069ea:	ff d0                	call   *%rax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
ffff8000001069ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001069f3:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff8000001069fa:	80 ff ff 
ffff8000001069fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106a01:	e9 d9 00 00 00       	jmp    ffff800000106adf <wait+0x114>
      if(p->parent != proc)
ffff800000106a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a0a:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106a0e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106a15:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106a19:	48 39 c2             	cmp    %rax,%rdx
ffff800000106a1c:	0f 85 b4 00 00 00    	jne    ffff800000106ad6 <wait+0x10b>
        continue;
      havekids = 1;
ffff800000106a22:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
      if(p->state == ZOMBIE){
ffff800000106a29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a2d:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106a30:	83 f8 05             	cmp    $0x5,%eax
ffff800000106a33:	0f 85 9e 00 00 00    	jne    ffff800000106ad7 <wait+0x10c>
        // Found one.
        pid = p->pid;
ffff800000106a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a3d:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000106a40:	89 45 f0             	mov    %eax,-0x10(%rbp)
        kfree(p->kstack);
ffff800000106a43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a47:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff800000106a4b:	48 89 c7             	mov    %rax,%rdi
ffff800000106a4e:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff800000106a55:	80 ff ff 
ffff800000106a58:	ff d0                	call   *%rax
        p->kstack = 0;
ffff800000106a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a5e:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000106a65:	00 
        freevm(p->pgdir);
ffff800000106a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a6a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106a6e:	48 89 c7             	mov    %rax,%rdi
ffff800000106a71:	48 b8 b5 c1 10 00 00 	movabs $0xffff80000010c1b5,%rax
ffff800000106a78:	80 ff ff 
ffff800000106a7b:	ff d0                	call   *%rax
        p->pid = 0;
ffff800000106a7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a81:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
        p->parent = 0;
ffff800000106a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a8c:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
ffff800000106a93:	00 
        p->name[0] = 0;
ffff800000106a94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a98:	c6 80 d0 00 00 00 00 	movb   $0x0,0xd0(%rax)
        p->killed = 0;
ffff800000106a9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106aa3:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%rax)
        p->state = UNUSED;
ffff800000106aaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106aae:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
        release(&ptable.lock);
ffff800000106ab5:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106abc:	80 ff ff 
ffff800000106abf:	48 89 c7             	mov    %rax,%rdi
ffff800000106ac2:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106ac9:	80 ff ff 
ffff800000106acc:	ff d0                	call   *%rax
        return pid;
ffff800000106ace:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000106ad1:	e9 81 00 00 00       	jmp    ffff800000106b57 <wait+0x18c>
        continue;
ffff800000106ad6:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106ad7:	48 81 45 f8 a0 03 00 	addq   $0x3a0,-0x8(%rbp)
ffff800000106ade:	00 
ffff800000106adf:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff800000106ae6:	80 ff ff 
ffff800000106ae9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106aed:	0f 82 13 ff ff ff    	jb     ffff800000106a06 <wait+0x3b>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
ffff800000106af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000106af7:	74 12                	je     ffff800000106b0b <wait+0x140>
ffff800000106af9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b00:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b04:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000106b07:	85 c0                	test   %eax,%eax
ffff800000106b09:	74 20                	je     ffff800000106b2b <wait+0x160>
      release(&ptable.lock);
ffff800000106b0b:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106b12:	80 ff ff 
ffff800000106b15:	48 89 c7             	mov    %rax,%rdi
ffff800000106b18:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106b1f:	80 ff ff 
ffff800000106b22:	ff d0                	call   *%rax
      return -1;
ffff800000106b24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000106b29:	eb 2c                	jmp    ffff800000106b57 <wait+0x18c>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
ffff800000106b2b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106b32:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106b36:	48 ba 40 74 11 00 00 	movabs $0xffff800000117440,%rdx
ffff800000106b3d:	80 ff ff 
ffff800000106b40:	48 89 d6             	mov    %rdx,%rsi
ffff800000106b43:	48 89 c7             	mov    %rax,%rdi
ffff800000106b46:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000106b4d:	80 ff ff 
ffff800000106b50:	ff d0                	call   *%rax
    havekids = 0;
ffff800000106b52:	e9 95 fe ff ff       	jmp    ffff8000001069ec <wait+0x21>
  }
}
ffff800000106b57:	c9                   	leave
ffff800000106b58:	c3                   	ret

ffff800000106b59 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
ffff800000106b59:	55                   	push   %rbp
ffff800000106b5a:	48 89 e5             	mov    %rsp,%rbp
ffff800000106b5d:	48 83 ec 20          	sub    $0x20,%rsp
  int i = 0;
ffff800000106b61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  struct proc *p;
  int skipped = 0;
ffff800000106b68:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  for(;;){
    ++i;
ffff800000106b6f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    // Enable interrupts on this processor.
    sti();
ffff800000106b73:	48 b8 1e 61 10 00 00 	movabs $0xffff80000010611e,%rax
ffff800000106b7a:	80 ff ff 
ffff800000106b7d:	ff d0                	call   *%rax
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
ffff800000106b7f:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106b86:	80 ff ff 
ffff800000106b89:	48 89 c7             	mov    %rax,%rdi
ffff800000106b8c:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000106b93:	80 ff ff 
ffff800000106b96:	ff d0                	call   *%rax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106b98:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106b9f:	80 ff ff 
ffff800000106ba2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000106ba6:	e9 92 00 00 00       	jmp    ffff800000106c3d <scheduler+0xe4>
      if(p->state != RUNNABLE) {
ffff800000106bab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106baf:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106bb2:	83 f8 03             	cmp    $0x3,%eax
ffff800000106bb5:	74 06                	je     ffff800000106bbd <scheduler+0x64>
        skipped++;
ffff800000106bb7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
        continue;
ffff800000106bbb:	eb 78                	jmp    ffff800000106c35 <scheduler+0xdc>
      }
      skipped = 0;
ffff800000106bbd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
ffff800000106bc4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106bcb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106bcf:	64 48 89 10          	mov    %rdx,%fs:(%rax)
      switchuvm(p);
ffff800000106bd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106bd7:	48 89 c7             	mov    %rax,%rdi
ffff800000106bda:	48 b8 7f b9 10 00 00 	movabs $0xffff80000010b97f,%rax
ffff800000106be1:	80 ff ff 
ffff800000106be4:	ff d0                	call   *%rax
      p->state = RUNNING;
ffff800000106be6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106bea:	c7 40 18 04 00 00 00 	movl   $0x4,0x18(%rax)
      swtch(&cpu->scheduler, p->context);
ffff800000106bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106bf5:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000106bf9:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000106c00:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106c04:	48 83 c2 08          	add    $0x8,%rdx
ffff800000106c08:	48 89 c6             	mov    %rax,%rsi
ffff800000106c0b:	48 89 d7             	mov    %rdx,%rdi
ffff800000106c0e:	48 b8 de 82 10 00 00 	movabs $0xffff8000001082de,%rax
ffff800000106c15:	80 ff ff 
ffff800000106c18:	ff d0                	call   *%rax
      switchkvm();
ffff800000106c1a:	48 b8 8b bc 10 00 00 	movabs $0xffff80000010bc8b,%rax
ffff800000106c21:	80 ff ff 
ffff800000106c24:	ff d0                	call   *%rax

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
ffff800000106c26:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106c2d:	64 48 c7 00 00 00 00 	movq   $0x0,%fs:(%rax)
ffff800000106c34:	00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000106c35:	48 81 45 f0 a0 03 00 	addq   $0x3a0,-0x10(%rbp)
ffff800000106c3c:	00 
ffff800000106c3d:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff800000106c44:	80 ff ff 
ffff800000106c47:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106c4b:	0f 82 5a ff ff ff    	jb     ffff800000106bab <scheduler+0x52>
    }
    release(&ptable.lock);
ffff800000106c51:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106c58:	80 ff ff 
ffff800000106c5b:	48 89 c7             	mov    %rax,%rdi
ffff800000106c5e:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106c65:	80 ff ff 
ffff800000106c68:	ff d0                	call   *%rax
    if (skipped > NPROC) {
ffff800000106c6a:	83 7d ec 40          	cmpl   $0x40,-0x14(%rbp)
ffff800000106c6e:	0f 8e fb fe ff ff    	jle    ffff800000106b6f <scheduler+0x16>
      hlt();
ffff800000106c74:	48 b8 26 61 10 00 00 	movabs $0xffff800000106126,%rax
ffff800000106c7b:	80 ff ff 
ffff800000106c7e:	ff d0                	call   *%rax
      skipped = 0;
ffff800000106c80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    ++i;
ffff800000106c87:	e9 e3 fe ff ff       	jmp    ffff800000106b6f <scheduler+0x16>

ffff800000106c8c <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
ffff800000106c8c:	55                   	push   %rbp
ffff800000106c8d:	48 89 e5             	mov    %rsp,%rbp
ffff800000106c90:	48 83 ec 10          	sub    $0x10,%rsp
  int intena;


  if(!holding(&ptable.lock))
ffff800000106c94:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106c9b:	80 ff ff 
ffff800000106c9e:	48 89 c7             	mov    %rax,%rdi
ffff800000106ca1:	48 b8 e1 7d 10 00 00 	movabs $0xffff800000107de1,%rax
ffff800000106ca8:	80 ff ff 
ffff800000106cab:	ff d0                	call   *%rax
ffff800000106cad:	85 c0                	test   %eax,%eax
ffff800000106caf:	75 19                	jne    ffff800000106cca <sched+0x3e>
    panic("sched ptable.lock");
ffff800000106cb1:	48 b8 c4 ca 10 00 00 	movabs $0xffff80000010cac4,%rax
ffff800000106cb8:	80 ff ff 
ffff800000106cbb:	48 89 c7             	mov    %rax,%rdi
ffff800000106cbe:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106cc5:	80 ff ff 
ffff800000106cc8:	ff d0                	call   *%rax
  if(cpu->ncli != 1)
ffff800000106cca:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106cd1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106cd5:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000106cd8:	83 f8 01             	cmp    $0x1,%eax
ffff800000106cdb:	74 19                	je     ffff800000106cf6 <sched+0x6a>
    panic("sched locks");
ffff800000106cdd:	48 b8 d6 ca 10 00 00 	movabs $0xffff80000010cad6,%rax
ffff800000106ce4:	80 ff ff 
ffff800000106ce7:	48 89 c7             	mov    %rax,%rdi
ffff800000106cea:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106cf1:	80 ff ff 
ffff800000106cf4:	ff d0                	call   *%rax
  if(proc->state == RUNNING)
ffff800000106cf6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106cfd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d01:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106d04:	83 f8 04             	cmp    $0x4,%eax
ffff800000106d07:	75 19                	jne    ffff800000106d22 <sched+0x96>
    panic("sched running");
ffff800000106d09:	48 b8 e2 ca 10 00 00 	movabs $0xffff80000010cae2,%rax
ffff800000106d10:	80 ff ff 
ffff800000106d13:	48 89 c7             	mov    %rax,%rdi
ffff800000106d16:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106d1d:	80 ff ff 
ffff800000106d20:	ff d0                	call   *%rax
  if(readeflags()&FL_IF)
ffff800000106d22:	48 b8 0a 61 10 00 00 	movabs $0xffff80000010610a,%rax
ffff800000106d29:	80 ff ff 
ffff800000106d2c:	ff d0                	call   *%rax
ffff800000106d2e:	25 00 02 00 00       	and    $0x200,%eax
ffff800000106d33:	48 85 c0             	test   %rax,%rax
ffff800000106d36:	74 19                	je     ffff800000106d51 <sched+0xc5>
    panic("sched interruptible");
ffff800000106d38:	48 b8 f0 ca 10 00 00 	movabs $0xffff80000010caf0,%rax
ffff800000106d3f:	80 ff ff 
ffff800000106d42:	48 89 c7             	mov    %rax,%rdi
ffff800000106d45:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106d4c:	80 ff ff 
ffff800000106d4f:	ff d0                	call   *%rax
  intena = cpu->intena;
ffff800000106d51:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106d58:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d5c:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106d5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  swtch(&proc->context, cpu->scheduler);
ffff800000106d62:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106d69:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d6d:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000106d71:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff800000106d78:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000106d7c:	48 83 c2 30          	add    $0x30,%rdx
ffff800000106d80:	48 89 c6             	mov    %rax,%rsi
ffff800000106d83:	48 89 d7             	mov    %rdx,%rdi
ffff800000106d86:	48 b8 de 82 10 00 00 	movabs $0xffff8000001082de,%rax
ffff800000106d8d:	80 ff ff 
ffff800000106d90:	ff d0                	call   *%rax
  cpu->intena = intena;
ffff800000106d92:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000106d99:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106d9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000106da0:	89 50 18             	mov    %edx,0x18(%rax)
}
ffff800000106da3:	90                   	nop
ffff800000106da4:	c9                   	leave
ffff800000106da5:	c3                   	ret

ffff800000106da6 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
ffff800000106da6:	55                   	push   %rbp
ffff800000106da7:	48 89 e5             	mov    %rsp,%rbp
  acquire(&ptable.lock);  //DOC: yieldlock
ffff800000106daa:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106db1:	80 ff ff 
ffff800000106db4:	48 89 c7             	mov    %rax,%rdi
ffff800000106db7:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000106dbe:	80 ff ff 
ffff800000106dc1:	ff d0                	call   *%rax
  proc->state = RUNNABLE;
ffff800000106dc3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106dca:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106dce:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  sched();
ffff800000106dd5:	48 b8 8c 6c 10 00 00 	movabs $0xffff800000106c8c,%rax
ffff800000106ddc:	80 ff ff 
ffff800000106ddf:	ff d0                	call   *%rax
  release(&ptable.lock);
ffff800000106de1:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106de8:	80 ff ff 
ffff800000106deb:	48 89 c7             	mov    %rax,%rdi
ffff800000106dee:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106df5:	80 ff ff 
ffff800000106df8:	ff d0                	call   *%rax
}
ffff800000106dfa:	90                   	nop
ffff800000106dfb:	5d                   	pop    %rbp
ffff800000106dfc:	c3                   	ret

ffff800000106dfd <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
ffff800000106dfd:	55                   	push   %rbp
ffff800000106dfe:	48 89 e5             	mov    %rsp,%rbp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
ffff800000106e01:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106e08:	80 ff ff 
ffff800000106e0b:	48 89 c7             	mov    %rax,%rdi
ffff800000106e0e:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106e15:	80 ff ff 
ffff800000106e18:	ff d0                	call   *%rax

  if (first) {
ffff800000106e1a:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000106e21:	80 ff ff 
ffff800000106e24:	8b 00                	mov    (%rax),%eax
ffff800000106e26:	85 c0                	test   %eax,%eax
ffff800000106e28:	74 32                	je     ffff800000106e5c <forkret+0x5f>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
ffff800000106e2a:	48 b8 44 d5 10 00 00 	movabs $0xffff80000010d544,%rax
ffff800000106e31:	80 ff ff 
ffff800000106e34:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    iinit(ROOTDEV);
ffff800000106e3a:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000106e3f:	48 b8 17 24 10 00 00 	movabs $0xffff800000102417,%rax
ffff800000106e46:	80 ff ff 
ffff800000106e49:	ff d0                	call   *%rax
    initlog(ROOTDEV);
ffff800000106e4b:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000106e50:	48 b8 70 4b 10 00 00 	movabs $0xffff800000104b70,%rax
ffff800000106e57:	80 ff ff 
ffff800000106e5a:	ff d0                	call   *%rax
  }

  // Return to "caller", actually trapret (see allocproc).
}
ffff800000106e5c:	90                   	nop
ffff800000106e5d:	5d                   	pop    %rbp
ffff800000106e5e:	c3                   	ret

ffff800000106e5f <sleep>:
//PAGEBREAK!
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
ffff800000106e5f:	55                   	push   %rbp
ffff800000106e60:	48 89 e5             	mov    %rsp,%rbp
ffff800000106e63:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106e67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106e6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(proc == 0)
ffff800000106e6f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106e76:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106e7a:	48 85 c0             	test   %rax,%rax
ffff800000106e7d:	75 19                	jne    ffff800000106e98 <sleep+0x39>
    panic("sleep");
ffff800000106e7f:	48 b8 04 cb 10 00 00 	movabs $0xffff80000010cb04,%rax
ffff800000106e86:	80 ff ff 
ffff800000106e89:	48 89 c7             	mov    %rax,%rdi
ffff800000106e8c:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106e93:	80 ff ff 
ffff800000106e96:	ff d0                	call   *%rax

  if(lk == 0)
ffff800000106e98:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000106e9d:	75 19                	jne    ffff800000106eb8 <sleep+0x59>
    panic("sleep without lk");
ffff800000106e9f:	48 b8 0a cb 10 00 00 	movabs $0xffff80000010cb0a,%rax
ffff800000106ea6:	80 ff ff 
ffff800000106ea9:	48 89 c7             	mov    %rax,%rdi
ffff800000106eac:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000106eb3:	80 ff ff 
ffff800000106eb6:	ff d0                	call   *%rax
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
ffff800000106eb8:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106ebf:	80 ff ff 
ffff800000106ec2:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106ec6:	74 2c                	je     ffff800000106ef4 <sleep+0x95>
    acquire(&ptable.lock);  //DOC: sleeplock1
ffff800000106ec8:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106ecf:	80 ff ff 
ffff800000106ed2:	48 89 c7             	mov    %rax,%rdi
ffff800000106ed5:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000106edc:	80 ff ff 
ffff800000106edf:	ff d0                	call   *%rax
    release(lk);
ffff800000106ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106ee5:	48 89 c7             	mov    %rax,%rdi
ffff800000106ee8:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106eef:	80 ff ff 
ffff800000106ef2:	ff d0                	call   *%rax
  }

  // Go to sleep.
  proc->chan = chan;
ffff800000106ef4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106efb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106eff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000106f03:	48 89 50 38          	mov    %rdx,0x38(%rax)
  proc->state = SLEEPING;
ffff800000106f07:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106f0e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f12:	c7 40 18 02 00 00 00 	movl   $0x2,0x18(%rax)
  sched();
ffff800000106f19:	48 b8 8c 6c 10 00 00 	movabs $0xffff800000106c8c,%rax
ffff800000106f20:	80 ff ff 
ffff800000106f23:	ff d0                	call   *%rax

  // Tidy up.
  proc->chan = 0;
ffff800000106f25:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000106f2c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000106f30:	48 c7 40 38 00 00 00 	movq   $0x0,0x38(%rax)
ffff800000106f37:	00 

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
ffff800000106f38:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106f3f:	80 ff ff 
ffff800000106f42:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff800000106f46:	74 2c                	je     ffff800000106f74 <sleep+0x115>
    release(&ptable.lock);
ffff800000106f48:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106f4f:	80 ff ff 
ffff800000106f52:	48 89 c7             	mov    %rax,%rdi
ffff800000106f55:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000106f5c:	80 ff ff 
ffff800000106f5f:	ff d0                	call   *%rax
    acquire(lk);
ffff800000106f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106f65:	48 89 c7             	mov    %rax,%rdi
ffff800000106f68:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000106f6f:	80 ff ff 
ffff800000106f72:	ff d0                	call   *%rax
  }
}
ffff800000106f74:	90                   	nop
ffff800000106f75:	c9                   	leave
ffff800000106f76:	c3                   	ret

ffff800000106f77 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
ffff800000106f77:	55                   	push   %rbp
ffff800000106f78:	48 89 e5             	mov    %rsp,%rbp
ffff800000106f7b:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000106f7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000106f83:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000106f8a:	80 ff ff 
ffff800000106f8d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000106f91:	eb 2d                	jmp    ffff800000106fc0 <wakeup1+0x49>
    if(p->state == SLEEPING && p->chan == chan)
ffff800000106f93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106f97:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000106f9a:	83 f8 02             	cmp    $0x2,%eax
ffff800000106f9d:	75 19                	jne    ffff800000106fb8 <wakeup1+0x41>
ffff800000106f9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106fa3:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000106fa7:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000106fab:	75 0b                	jne    ffff800000106fb8 <wakeup1+0x41>
      p->state = RUNNABLE;
ffff800000106fad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106fb1:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffff800000106fb8:	48 81 45 f8 a0 03 00 	addq   $0x3a0,-0x8(%rbp)
ffff800000106fbf:	00 
ffff800000106fc0:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff800000106fc7:	80 ff ff 
ffff800000106fca:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000106fce:	72 c3                	jb     ffff800000106f93 <wakeup1+0x1c>
}
ffff800000106fd0:	90                   	nop
ffff800000106fd1:	90                   	nop
ffff800000106fd2:	c9                   	leave
ffff800000106fd3:	c3                   	ret

ffff800000106fd4 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
ffff800000106fd4:	55                   	push   %rbp
ffff800000106fd5:	48 89 e5             	mov    %rsp,%rbp
ffff800000106fd8:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106fdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ptable.lock);
ffff800000106fe0:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000106fe7:	80 ff ff 
ffff800000106fea:	48 89 c7             	mov    %rax,%rdi
ffff800000106fed:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000106ff4:	80 ff ff 
ffff800000106ff7:	ff d0                	call   *%rax
  wakeup1(chan);
ffff800000106ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ffd:	48 89 c7             	mov    %rax,%rdi
ffff800000107000:	48 b8 77 6f 10 00 00 	movabs $0xffff800000106f77,%rax
ffff800000107007:	80 ff ff 
ffff80000010700a:	ff d0                	call   *%rax
  release(&ptable.lock);
ffff80000010700c:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000107013:	80 ff ff 
ffff800000107016:	48 89 c7             	mov    %rax,%rdi
ffff800000107019:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107020:	80 ff ff 
ffff800000107023:	ff d0                	call   *%rax
}
ffff800000107025:	90                   	nop
ffff800000107026:	c9                   	leave
ffff800000107027:	c3                   	ret

ffff800000107028 <alarm>:


void
alarm(int secs) {
ffff800000107028:	55                   	push   %rbp
ffff800000107029:	48 89 e5             	mov    %rsp,%rbp
ffff80000010702c:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107030:	89 7d fc             	mov    %edi,-0x4(%rbp)
  //cprintf("alarm did nothing\n");
  cprintf("Set an alarm fo %d seconds\n", secs);
ffff800000107033:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107036:	48 ba 1b cb 10 00 00 	movabs $0xffff80000010cb1b,%rdx
ffff80000010703d:	80 ff ff 
ffff800000107040:	89 c6                	mov    %eax,%esi
ffff800000107042:	48 89 d7             	mov    %rdx,%rdi
ffff800000107045:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010704a:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000107051:	80 ff ff 
ffff800000107054:	ff d2                	call   *%rdx
  proc->alarm_ticks = ticks + (secs * 100);
ffff800000107056:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107059:	6b c0 64             	imul   $0x64,%eax,%eax
ffff80000010705c:	89 c2                	mov    %eax,%edx
ffff80000010705e:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff800000107065:	80 ff ff 
ffff800000107068:	8b 00                	mov    (%rax),%eax
ffff80000010706a:	01 c2                	add    %eax,%edx
ffff80000010706c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107073:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107077:	89 90 e0 00 00 00    	mov    %edx,0xe0(%rax)
}
ffff80000010707d:	90                   	nop
ffff80000010707e:	c9                   	leave
ffff80000010707f:	c3                   	ret

ffff800000107080 <signal>:

void
signal(int signum, void (*handler)(int)) {
ffff800000107080:	55                   	push   %rbp
ffff800000107081:	48 89 e5             	mov    %rsp,%rbp
ffff800000107084:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107088:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010708b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(signum <= 0 || signum >= NSIG)
ffff80000010708f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff800000107093:	7e 4d                	jle    ffff8000001070e2 <signal+0x62>
ffff800000107095:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
ffff800000107099:	7f 47                	jg     ffff8000001070e2 <signal+0x62>
    return;
  proc->signal_disposition[signum] = (addr_t)handler;
ffff80000010709b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001070a2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001070a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001070aa:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff8000001070ad:	48 63 c9             	movslq %ecx,%rcx
ffff8000001070b0:	48 83 c1 52          	add    $0x52,%rcx
ffff8000001070b4:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
  cprintf("In signal(), with number %d and handler %p\n",
ffff8000001070b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001070bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001070c0:	48 b9 38 cb 10 00 00 	movabs $0xffff80000010cb38,%rcx
ffff8000001070c7:	80 ff ff 
ffff8000001070ca:	89 c6                	mov    %eax,%esi
ffff8000001070cc:	48 89 cf             	mov    %rcx,%rdi
ffff8000001070cf:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001070d4:	48 b9 04 08 10 00 00 	movabs $0xffff800000100804,%rcx
ffff8000001070db:	80 ff ff 
ffff8000001070de:	ff d1                	call   *%rcx
ffff8000001070e0:	eb 01                	jmp    ffff8000001070e3 <signal+0x63>
    return;
ffff8000001070e2:	90                   	nop
	  signum, (addr_t)handler);
}
ffff8000001070e3:	c9                   	leave
ffff8000001070e4:	c3                   	ret

ffff8000001070e5 <check_signals>:

void check_signals(){
ffff8000001070e5:	55                   	push   %rbp
ffff8000001070e6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001070e9:	48 83 ec 10          	sub    $0x10,%rsp
  int signum;
  addr_t disposition;

  if(proc == 0)
ffff8000001070ed:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001070f4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001070f8:	48 85 c0             	test   %rax,%rax
ffff8000001070fb:	0f 84 90 00 00 00    	je     ffff800000107191 <check_signals+0xac>
    return;

  if(proc->killed)
ffff800000107101:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107108:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010710c:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010710f:	85 c0                	test   %eax,%eax
ffff800000107111:	74 0c                	je     ffff80000010711f <check_signals+0x3a>
    exit();
ffff800000107113:	48 b8 da 67 10 00 00 	movabs $0xffff8000001067da,%rax
ffff80000010711a:	80 ff ff 
ffff80000010711d:	ff d0                	call   *%rax

  signum = proc->signal_pending;
ffff80000010711f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107126:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010712a:	8b 80 98 03 00 00    	mov    0x398(%rax),%eax
ffff800000107130:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(signum <= 0)
ffff800000107133:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffff800000107137:	7e 5b                	jle    ffff800000107194 <check_signals+0xaf>
    return;

  disposition = SIG_DFL;
ffff800000107139:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff800000107140:	00 
  if(signum < NSIG)
ffff800000107141:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
ffff800000107145:	7f 1e                	jg     ffff800000107165 <check_signals+0x80>
    disposition = proc->signal_disposition[signum];
ffff800000107147:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010714e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107152:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000107155:	48 63 d2             	movslq %edx,%rdx
ffff800000107158:	48 83 c2 52          	add    $0x52,%rdx
ffff80000010715c:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000107161:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if(disposition == SIG_IGN){
ffff800000107165:	48 83 7d f8 01       	cmpq   $0x1,-0x8(%rbp)
ffff80000010716a:	75 17                	jne    ffff800000107183 <check_signals+0x9e>
    proc->signal_pending = 0;
ffff80000010716c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107173:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107177:	c7 80 98 03 00 00 00 	movl   $0x0,0x398(%rax)
ffff80000010717e:	00 00 00 
    return;
ffff800000107181:	eb 12                	jmp    ffff800000107195 <check_signals+0xb0>
  }
  exit();
ffff800000107183:	48 b8 da 67 10 00 00 	movabs $0xffff8000001067da,%rax
ffff80000010718a:	80 ff ff 
ffff80000010718d:	ff d0                	call   *%rax
ffff80000010718f:	eb 04                	jmp    ffff800000107195 <check_signals+0xb0>
    return;
ffff800000107191:	90                   	nop
ffff800000107192:	eb 01                	jmp    ffff800000107195 <check_signals+0xb0>
    return;
ffff800000107194:	90                   	nop
}
ffff800000107195:	c9                   	leave
ffff800000107196:	c3                   	ret

ffff800000107197 <check_signalss>:

void
check_signalss() {
ffff800000107197:	55                   	push   %rbp
ffff800000107198:	48 89 e5             	mov    %rsp,%rbp
ffff80000010719b:	53                   	push   %rbx
ffff80000010719c:	48 83 ec 18          	sub    $0x18,%rsp
  acquire(&ptable.lock);
ffff8000001071a0:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001071a7:	80 ff ff 
ffff8000001071aa:	48 89 c7             	mov    %rax,%rdi
ffff8000001071ad:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff8000001071b4:	80 ff ff 
ffff8000001071b7:	ff d0                	call   *%rax

  if(proc && proc->signal_pending) {
ffff8000001071b9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001071c0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001071c4:	48 85 c0             	test   %rax,%rax
ffff8000001071c7:	0f 84 91 03 00 00    	je     ffff80000010755e <check_signalss+0x3c7>
ffff8000001071cd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001071d4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001071d8:	8b 80 98 03 00 00    	mov    0x398(%rax),%eax
ffff8000001071de:	85 c0                	test   %eax,%eax
ffff8000001071e0:	0f 84 78 03 00 00    	je     ffff80000010755e <check_signalss+0x3c7>
    cprintf("Checking signals, pending is %d\n", proc->signal_pending);
ffff8000001071e6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001071ed:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001071f1:	8b 80 98 03 00 00    	mov    0x398(%rax),%eax
ffff8000001071f7:	48 ba 68 cb 10 00 00 	movabs $0xffff80000010cb68,%rdx
ffff8000001071fe:	80 ff ff 
ffff800000107201:	89 c6                	mov    %eax,%esi
ffff800000107203:	48 89 d7             	mov    %rdx,%rdi
ffff800000107206:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010720b:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000107212:	80 ff ff 
ffff800000107215:	ff d2                	call   *%rdx

    if(proc->signal_pending == SIGKILL) {
ffff800000107217:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010721e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107222:	8b 80 98 03 00 00    	mov    0x398(%rax),%eax
ffff800000107228:	83 f8 09             	cmp    $0x9,%eax
ffff80000010722b:	75 2a                	jne    ffff800000107257 <check_signalss+0xc0>
      release(&ptable.lock);
ffff80000010722d:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000107234:	80 ff ff 
ffff800000107237:	48 89 c7             	mov    %rax,%rdi
ffff80000010723a:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107241:	80 ff ff 
ffff800000107244:	ff d0                	call   *%rax
      exit();
ffff800000107246:	48 b8 da 67 10 00 00 	movabs $0xffff8000001067da,%rax
ffff80000010724d:	80 ff ff 
ffff800000107250:	ff d0                	call   *%rax
ffff800000107252:	e9 f2 02 00 00       	jmp    ffff800000107549 <check_signalss+0x3b2>
    }

    else if(proc->sig_disp[proc->signal_pending]==0) {
ffff800000107257:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010725e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107262:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff800000107269:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff80000010726d:	8b 92 98 03 00 00    	mov    0x398(%rdx),%edx
ffff800000107273:	89 d2                	mov    %edx,%edx
ffff800000107275:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000107279:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff80000010727e:	48 85 c0             	test   %rax,%rax
ffff800000107281:	75 5b                	jne    ffff8000001072de <check_signalss+0x147>
      cprintf("got a signal %d, exiting\n", proc->signal_pending);
ffff800000107283:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010728a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010728e:	8b 80 98 03 00 00    	mov    0x398(%rax),%eax
ffff800000107294:	48 ba 89 cb 10 00 00 	movabs $0xffff80000010cb89,%rdx
ffff80000010729b:	80 ff ff 
ffff80000010729e:	89 c6                	mov    %eax,%esi
ffff8000001072a0:	48 89 d7             	mov    %rdx,%rdi
ffff8000001072a3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001072a8:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff8000001072af:	80 ff ff 
ffff8000001072b2:	ff d2                	call   *%rdx
      release(&ptable.lock);
ffff8000001072b4:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001072bb:	80 ff ff 
ffff8000001072be:	48 89 c7             	mov    %rax,%rdi
ffff8000001072c1:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001072c8:	80 ff ff 
ffff8000001072cb:	ff d0                	call   *%rax
      exit();
ffff8000001072cd:	48 b8 da 67 10 00 00 	movabs $0xffff8000001067da,%rax
ffff8000001072d4:	80 ff ff 
ffff8000001072d7:	ff d0                	call   *%rax
ffff8000001072d9:	e9 6b 02 00 00       	jmp    ffff800000107549 <check_signalss+0x3b2>
    }

    else if(((int)proc->sig_disp[proc->signal_pending])!=1) {
ffff8000001072de:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001072e5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001072e9:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff8000001072f0:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff8000001072f4:	8b 92 98 03 00 00    	mov    0x398(%rdx),%edx
ffff8000001072fa:	89 d2                	mov    %edx,%edx
ffff8000001072fc:	48 83 c2 1c          	add    $0x1c,%rdx
ffff800000107300:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000107305:	83 f8 01             	cmp    $0x1,%eax
ffff800000107308:	0f 84 3b 02 00 00    	je     ffff800000107549 <check_signalss+0x3b2>
            proc->signal_trapframe_backup=*proc->tf;
ffff80000010730e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107315:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107319:	48 8b 50 28          	mov    0x28(%rax),%rdx
ffff80000010731d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107324:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107328:	48 8b 0a             	mov    (%rdx),%rcx
ffff80000010732b:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
ffff80000010732f:	48 89 88 e8 01 00 00 	mov    %rcx,0x1e8(%rax)
ffff800000107336:	48 89 98 f0 01 00 00 	mov    %rbx,0x1f0(%rax)
ffff80000010733d:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
ffff800000107341:	48 8b 5a 18          	mov    0x18(%rdx),%rbx
ffff800000107345:	48 89 88 f8 01 00 00 	mov    %rcx,0x1f8(%rax)
ffff80000010734c:	48 89 98 00 02 00 00 	mov    %rbx,0x200(%rax)
ffff800000107353:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
ffff800000107357:	48 8b 5a 28          	mov    0x28(%rdx),%rbx
ffff80000010735b:	48 89 88 08 02 00 00 	mov    %rcx,0x208(%rax)
ffff800000107362:	48 89 98 10 02 00 00 	mov    %rbx,0x210(%rax)
ffff800000107369:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
ffff80000010736d:	48 8b 5a 38          	mov    0x38(%rdx),%rbx
ffff800000107371:	48 89 88 18 02 00 00 	mov    %rcx,0x218(%rax)
ffff800000107378:	48 89 98 20 02 00 00 	mov    %rbx,0x220(%rax)
ffff80000010737f:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
ffff800000107383:	48 8b 5a 48          	mov    0x48(%rdx),%rbx
ffff800000107387:	48 89 88 28 02 00 00 	mov    %rcx,0x228(%rax)
ffff80000010738e:	48 89 98 30 02 00 00 	mov    %rbx,0x230(%rax)
ffff800000107395:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
ffff800000107399:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
ffff80000010739d:	48 89 88 38 02 00 00 	mov    %rcx,0x238(%rax)
ffff8000001073a4:	48 89 98 40 02 00 00 	mov    %rbx,0x240(%rax)
ffff8000001073ab:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
ffff8000001073af:	48 8b 5a 68          	mov    0x68(%rdx),%rbx
ffff8000001073b3:	48 89 88 48 02 00 00 	mov    %rcx,0x248(%rax)
ffff8000001073ba:	48 89 98 50 02 00 00 	mov    %rbx,0x250(%rax)
ffff8000001073c1:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
ffff8000001073c5:	48 8b 5a 78          	mov    0x78(%rdx),%rbx
ffff8000001073c9:	48 89 88 58 02 00 00 	mov    %rcx,0x258(%rax)
ffff8000001073d0:	48 89 98 60 02 00 00 	mov    %rbx,0x260(%rax)
ffff8000001073d7:	48 8b 8a 80 00 00 00 	mov    0x80(%rdx),%rcx
ffff8000001073de:	48 8b 9a 88 00 00 00 	mov    0x88(%rdx),%rbx
ffff8000001073e5:	48 89 88 68 02 00 00 	mov    %rcx,0x268(%rax)
ffff8000001073ec:	48 89 98 70 02 00 00 	mov    %rbx,0x270(%rax)
ffff8000001073f3:	48 8b 8a 90 00 00 00 	mov    0x90(%rdx),%rcx
ffff8000001073fa:	48 8b 9a 98 00 00 00 	mov    0x98(%rdx),%rbx
ffff800000107401:	48 89 88 78 02 00 00 	mov    %rcx,0x278(%rax)
ffff800000107408:	48 89 98 80 02 00 00 	mov    %rbx,0x280(%rax)
ffff80000010740f:	48 8b 8a a0 00 00 00 	mov    0xa0(%rdx),%rcx
ffff800000107416:	48 8b 9a a8 00 00 00 	mov    0xa8(%rdx),%rbx
ffff80000010741d:	48 89 88 88 02 00 00 	mov    %rcx,0x288(%rax)
ffff800000107424:	48 89 98 90 02 00 00 	mov    %rbx,0x290(%rax)

            proc->tf->rcx = (addr_t)proc->sig_disp[proc->signal_pending];
ffff80000010742b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107432:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107436:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffff80000010743d:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000107441:	8b 92 98 03 00 00    	mov    0x398(%rdx),%edx
ffff800000107447:	89 d2                	mov    %edx,%edx
ffff800000107449:	48 83 c2 1c          	add    $0x1c,%rdx
ffff80000010744d:	48 8b 54 d0 08       	mov    0x8(%rax,%rdx,8),%rdx
ffff800000107452:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107459:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010745d:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107461:	48 89 50 10          	mov    %rdx,0x10(%rax)

            unsigned char sigretcode[13] = {0x48, 0xc7, 0xc0, 0x18, 0x00, 0x00, 0x00, 0x49, 0x89, 0xca, 0x0f, 0x05, 0xc3};
ffff800000107465:	48 b8 48 c7 c0 18 00 	movabs $0x4900000018c0c748,%rax
ffff80000010746c:	00 00 49 
ffff80000010746f:	48 89 45 e3          	mov    %rax,-0x1d(%rbp)
ffff800000107473:	48 b8 00 00 49 89 ca 	movabs $0xc3050fca89490000,%rax
ffff80000010747a:	0f 05 c3 
ffff80000010747d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
            memmove((void*)(proc->tf->rsp-13), sigretcode, 13);
ffff800000107481:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107488:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010748c:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107490:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff800000107497:	48 83 e8 0d          	sub    $0xd,%rax
ffff80000010749b:	48 89 c1             	mov    %rax,%rcx
ffff80000010749e:	48 8d 45 e3          	lea    -0x1d(%rbp),%rax
ffff8000001074a2:	ba 0d 00 00 00       	mov    $0xd,%edx
ffff8000001074a7:	48 89 c6             	mov    %rax,%rsi
ffff8000001074aa:	48 89 cf             	mov    %rcx,%rdi
ffff8000001074ad:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff8000001074b4:	80 ff ff 
ffff8000001074b7:	ff d0                	call   *%rax
            proc->tf->rdi = proc->signal_pending;
ffff8000001074b9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001074c0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001074c4:	8b 90 98 03 00 00    	mov    0x398(%rax),%edx
ffff8000001074ca:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001074d1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001074d5:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001074d9:	89 d2                	mov    %edx,%edx
ffff8000001074db:	48 89 50 30          	mov    %rdx,0x30(%rax)

            *((addr_t*)(proc->tf->rsp-13-8)) = proc->tf->rsp-13;
ffff8000001074df:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001074e6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001074ea:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001074ee:	48 8b 90 a0 00 00 00 	mov    0xa0(%rax),%rdx
ffff8000001074f5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001074fc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107500:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107504:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff80000010750b:	48 83 e8 15          	sub    $0x15,%rax
ffff80000010750f:	48 89 c1             	mov    %rax,%rcx
ffff800000107512:	48 8d 42 f3          	lea    -0xd(%rdx),%rax
ffff800000107516:	48 89 01             	mov    %rax,(%rcx)

            proc->tf->rsp -= 21;
ffff800000107519:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107520:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107524:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107528:	48 8b 90 a0 00 00 00 	mov    0xa0(%rax),%rdx
ffff80000010752f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107536:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010753a:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010753e:	48 83 ea 15          	sub    $0x15,%rdx
ffff800000107542:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    }
    proc->signal_pending = 0;
ffff800000107549:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107550:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107554:	c7 80 98 03 00 00 00 	movl   $0x0,0x398(%rax)
ffff80000010755b:	00 00 00 
  }
  release(&ptable.lock);
ffff80000010755e:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000107565:	80 ff ff 
ffff800000107568:	48 89 c7             	mov    %rax,%rdi
ffff80000010756b:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107572:	80 ff ff 
ffff800000107575:	ff d0                	call   *%rax
}
ffff800000107577:	90                   	nop
ffff800000107578:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff80000010757c:	c9                   	leave
ffff80000010757d:	c3                   	ret

ffff80000010757e <check_alarms>:

int kill1(int pid, int signal);

void check_alarms(void){
ffff80000010757e:	55                   	push   %rbp
ffff80000010757f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107582:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int i;
  for(i=0;i<NPROC;i++){
ffff800000107586:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010758d:	e9 96 00 00 00       	jmp    ffff800000107628 <check_alarms+0xaa>
    p = &ptable.proc[i];
ffff800000107592:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107595:	48 98                	cltq
ffff800000107597:	48 69 c0 a0 03 00 00 	imul   $0x3a0,%rax,%rax
ffff80000010759e:	48 8d 50 60          	lea    0x60(%rax),%rdx
ffff8000001075a2:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001075a9:	80 ff ff 
ffff8000001075ac:	48 01 d0             	add    %rdx,%rax
ffff8000001075af:	48 83 c0 08          	add    $0x8,%rax
ffff8000001075b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(p->alarm_ticks > 0 && ticks >= p->alarm_ticks) {
ffff8000001075b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001075bb:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
ffff8000001075c1:	85 c0                	test   %eax,%eax
ffff8000001075c3:	7e 5f                	jle    ffff800000107624 <check_alarms+0xa6>
ffff8000001075c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001075c9:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
ffff8000001075cf:	89 c2                	mov    %eax,%edx
ffff8000001075d1:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff8000001075d8:	80 ff ff 
ffff8000001075db:	8b 00                	mov    (%rax),%eax
ffff8000001075dd:	39 d0                	cmp    %edx,%eax
ffff8000001075df:	72 43                	jb     ffff800000107624 <check_alarms+0xa6>
      cprintf("Alarm triggered for process %d\n", p->pid);
ffff8000001075e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001075e5:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001075e8:	48 ba a8 cb 10 00 00 	movabs $0xffff80000010cba8,%rdx
ffff8000001075ef:	80 ff ff 
ffff8000001075f2:	89 c6                	mov    %eax,%esi
ffff8000001075f4:	48 89 d7             	mov    %rdx,%rdi
ffff8000001075f7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001075fc:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000107603:	80 ff ff 
ffff800000107606:	ff d2                	call   *%rdx
      p->signal_pending = SIGALRM;
ffff800000107608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010760c:	c7 80 98 03 00 00 0e 	movl   $0xe,0x398(%rax)
ffff800000107613:	00 00 00 
      p->alarm_ticks = 0;
ffff800000107616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010761a:	c7 80 e0 00 00 00 00 	movl   $0x0,0xe0(%rax)
ffff800000107621:	00 00 00 
  for(i=0;i<NPROC;i++){
ffff800000107624:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107628:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
ffff80000010762c:	0f 8e 60 ff ff ff    	jle    ffff800000107592 <check_alarms+0x14>
    cprintf("Alarm triggered for process %d\n", p->pid);
    p->signal_pending = SIGALRM;
    p->alarm_ticks = 0;
  }
  #endif
}
ffff800000107632:	90                   	nop
ffff800000107633:	90                   	nop
ffff800000107634:	c9                   	leave
ffff800000107635:	c3                   	ret

ffff800000107636 <check_alarmss>:

void check_alarmss() {
ffff800000107636:	55                   	push   %rbp
ffff800000107637:	48 89 e5             	mov    %rsp,%rbp
ffff80000010763a:	48 83 ec 10          	sub    $0x10,%rsp
  acquire(&ptable.lock);
ffff80000010763e:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000107645:	80 ff ff 
ffff800000107648:	48 89 c7             	mov    %rax,%rdi
ffff80000010764b:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000107652:	80 ff ff 
ffff800000107655:	ff d0                	call   *%rax
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
ffff800000107657:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff80000010765e:	80 ff ff 
ffff800000107661:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107665:	e9 b5 00 00 00       	jmp    ffff80000010771f <check_alarmss+0xe9>
    if(p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
ffff80000010766a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010766e:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107671:	83 f8 04             	cmp    $0x4,%eax
ffff800000107674:	74 1c                	je     ffff800000107692 <check_alarmss+0x5c>
ffff800000107676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010767a:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010767d:	83 f8 03             	cmp    $0x3,%eax
ffff800000107680:	74 10                	je     ffff800000107692 <check_alarmss+0x5c>
ffff800000107682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107686:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107689:	83 f8 02             	cmp    $0x2,%eax
ffff80000010768c:	0f 85 85 00 00 00    	jne    ffff800000107717 <check_alarmss+0xe1>
      if (p->alarm_ticks && ticks >= p->alarm_ticks) {
ffff800000107692:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107696:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
ffff80000010769c:	85 c0                	test   %eax,%eax
ffff80000010769e:	74 77                	je     ffff800000107717 <check_alarmss+0xe1>
ffff8000001076a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076a4:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
ffff8000001076aa:	89 c2                	mov    %eax,%edx
ffff8000001076ac:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff8000001076b3:	80 ff ff 
ffff8000001076b6:	8b 00                	mov    (%rax),%eax
ffff8000001076b8:	39 d0                	cmp    %edx,%eax
ffff8000001076ba:	72 5b                	jb     ffff800000107717 <check_alarmss+0xe1>
        cprintf("Process %d alarm triggered at tick %d\n", p->pid, ticks);
ffff8000001076bc:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff8000001076c3:	80 ff ff 
ffff8000001076c6:	8b 10                	mov    (%rax),%edx
ffff8000001076c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076cc:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff8000001076cf:	48 b9 c8 cb 10 00 00 	movabs $0xffff80000010cbc8,%rcx
ffff8000001076d6:	80 ff ff 
ffff8000001076d9:	89 c6                	mov    %eax,%esi
ffff8000001076db:	48 89 cf             	mov    %rcx,%rdi
ffff8000001076de:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001076e3:	48 b9 04 08 10 00 00 	movabs $0xffff800000100804,%rcx
ffff8000001076ea:	80 ff ff 
ffff8000001076ed:	ff d1                	call   *%rcx

        p->alarm_ticks = 0;
ffff8000001076ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076f3:	c7 80 e0 00 00 00 00 	movl   $0x0,0xe0(%rax)
ffff8000001076fa:	00 00 00 
        kill1(p->pid, SIGALRM);
ffff8000001076fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107701:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000107704:	be 0e 00 00 00       	mov    $0xe,%esi
ffff800000107709:	89 c7                	mov    %eax,%edi
ffff80000010770b:	48 b8 0c 78 10 00 00 	movabs $0xffff80000010780c,%rax
ffff800000107712:	80 ff ff 
ffff800000107715:	ff d0                	call   *%rax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
ffff800000107717:	48 81 45 f8 a0 03 00 	addq   $0x3a0,-0x8(%rbp)
ffff80000010771e:	00 
ffff80000010771f:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff800000107726:	80 ff ff 
ffff800000107729:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010772d:	0f 82 37 ff ff ff    	jb     ffff80000010766a <check_alarmss+0x34>
      }
    }
  }
  release(&ptable.lock);
ffff800000107733:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff80000010773a:	80 ff ff 
ffff80000010773d:	48 89 c7             	mov    %rax,%rdi
ffff800000107740:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107747:	80 ff ff 
ffff80000010774a:	ff d0                	call   *%rax
}
ffff80000010774c:	90                   	nop
ffff80000010774d:	c9                   	leave
ffff80000010774e:	c3                   	ret

ffff80000010774f <kill>:

// Signal the process with the given pid and signal
int
kill(int pid, int signal)
{
ffff80000010774f:	55                   	push   %rbp
ffff800000107750:	48 89 e5             	mov    %rsp,%rbp
ffff800000107753:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107757:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010775a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct proc *p;

  acquire(&ptable.lock);
ffff80000010775d:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff800000107764:	80 ff ff 
ffff800000107767:	48 89 c7             	mov    %rax,%rdi
ffff80000010776a:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000107771:	80 ff ff 
ffff800000107774:	ff d0                	call   *%rax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
ffff800000107776:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff80000010777d:	80 ff ff 
ffff800000107780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107784:	eb 56                	jmp    ffff8000001077dc <kill+0x8d>
    if(p->pid == pid){
ffff800000107786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010778a:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010778d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000107790:	75 42                	jne    ffff8000001077d4 <kill+0x85>
      p->killed = 1;
ffff800000107792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107796:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)

      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
ffff80000010779d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001077a1:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001077a4:	83 f8 02             	cmp    $0x2,%eax
ffff8000001077a7:	75 0b                	jne    ffff8000001077b4 <kill+0x65>
        p->state = RUNNABLE;
ffff8000001077a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001077ad:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
      release(&ptable.lock);
ffff8000001077b4:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001077bb:	80 ff ff 
ffff8000001077be:	48 89 c7             	mov    %rax,%rdi
ffff8000001077c1:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff8000001077c8:	80 ff ff 
ffff8000001077cb:	ff d0                	call   *%rax

      return 0;
ffff8000001077cd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001077d2:	eb 36                	jmp    ffff80000010780a <kill+0xbb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
ffff8000001077d4:	48 81 45 f8 a0 03 00 	addq   $0x3a0,-0x8(%rbp)
ffff8000001077db:	00 
ffff8000001077dc:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff8000001077e3:	80 ff ff 
ffff8000001077e6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001077ea:	72 9a                	jb     ffff800000107786 <kill+0x37>
    }
  }
  release(&ptable.lock);
ffff8000001077ec:	48 b8 40 74 11 00 00 	movabs $0xffff800000117440,%rax
ffff8000001077f3:	80 ff ff 
ffff8000001077f6:	48 89 c7             	mov    %rax,%rdi
ffff8000001077f9:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107800:	80 ff ff 
ffff800000107803:	ff d0                	call   *%rax

  return -1;
ffff800000107805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff80000010780a:	c9                   	leave
ffff80000010780b:	c3                   	ret

ffff80000010780c <kill1>:

int kill1(int pid, int signal) {
ffff80000010780c:	55                   	push   %rbp
ffff80000010780d:	48 89 e5             	mov    %rsp,%rbp
ffff800000107810:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107814:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000107817:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct proc *p;
  for( p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
ffff80000010781a:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff800000107821:	80 ff ff 
ffff800000107824:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000107828:	eb 3d                	jmp    ffff800000107867 <kill1+0x5b>
    if(p->pid == pid) {
ffff80000010782a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010782e:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff800000107831:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff800000107834:	75 29                	jne    ffff80000010785f <kill1+0x53>
      p->killed = 1;
ffff800000107836:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010783a:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)

      if(p->state == SLEEPING)
ffff800000107841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107845:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107848:	83 f8 02             	cmp    $0x2,%eax
ffff80000010784b:	75 0b                	jne    ffff800000107858 <kill1+0x4c>
        p->state = RUNNABLE;
ffff80000010784d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107851:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
      return 0;
ffff800000107858:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010785d:	eb 1d                	jmp    ffff80000010787c <kill1+0x70>
  for( p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
ffff80000010785f:	48 81 45 f8 a0 03 00 	addq   $0x3a0,-0x8(%rbp)
ffff800000107866:	00 
ffff800000107867:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff80000010786e:	80 ff ff 
ffff800000107871:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000107875:	72 b3                	jb     ffff80000010782a <kill1+0x1e>
    }
  }
  return 0;
ffff800000107877:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010787c:	c9                   	leave
ffff80000010787d:	c3                   	ret

ffff80000010787e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
ffff80000010787e:	55                   	push   %rbp
ffff80000010787f:	48 89 e5             	mov    %rsp,%rbp
ffff800000107882:	48 83 ec 70          	sub    $0x70,%rsp
  int i;
  struct proc *p;
  char *state;
  addr_t pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff800000107886:	48 b8 a8 74 11 00 00 	movabs $0xffff8000001174a8,%rax
ffff80000010788d:	80 ff ff 
ffff800000107890:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000107894:	e9 41 01 00 00       	jmp    ffff8000001079da <procdump+0x15c>
    if(p->state == UNUSED)
ffff800000107899:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010789d:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001078a0:	85 c0                	test   %eax,%eax
ffff8000001078a2:	0f 84 29 01 00 00    	je     ffff8000001079d1 <procdump+0x153>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
ffff8000001078a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001078ac:	8b 40 18             	mov    0x18(%rax),%eax
ffff8000001078af:	83 f8 05             	cmp    $0x5,%eax
ffff8000001078b2:	77 39                	ja     ffff8000001078ed <procdump+0x6f>
ffff8000001078b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001078b8:	8b 50 18             	mov    0x18(%rax),%edx
ffff8000001078bb:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff8000001078c2:	80 ff ff 
ffff8000001078c5:	89 d2                	mov    %edx,%edx
ffff8000001078c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff8000001078cb:	48 85 c0             	test   %rax,%rax
ffff8000001078ce:	74 1d                	je     ffff8000001078ed <procdump+0x6f>
      state = states[p->state];
ffff8000001078d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001078d4:	8b 50 18             	mov    0x18(%rax),%edx
ffff8000001078d7:	48 b8 60 d5 10 00 00 	movabs $0xffff80000010d560,%rax
ffff8000001078de:	80 ff ff 
ffff8000001078e1:	89 d2                	mov    %edx,%edx
ffff8000001078e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffff8000001078e7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001078eb:	eb 0e                	jmp    ffff8000001078fb <procdump+0x7d>
    else
      state = "???";
ffff8000001078ed:	48 b8 ef cb 10 00 00 	movabs $0xffff80000010cbef,%rax
ffff8000001078f4:	80 ff ff 
ffff8000001078f7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    cprintf("%d %s %s", p->pid, state, p->name);
ffff8000001078fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001078ff:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffff800000107906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010790a:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010790d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107911:	48 bf f3 cb 10 00 00 	movabs $0xffff80000010cbf3,%rdi
ffff800000107918:	80 ff ff 
ffff80000010791b:	89 c6                	mov    %eax,%esi
ffff80000010791d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107922:	49 b8 04 08 10 00 00 	movabs $0xffff800000100804,%r8
ffff800000107929:	80 ff ff 
ffff80000010792c:	41 ff d0             	call   *%r8
    if(p->state == SLEEPING){
ffff80000010792f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107933:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107936:	83 f8 02             	cmp    $0x2,%eax
ffff800000107939:	75 76                	jne    ffff8000001079b1 <procdump+0x133>
      getstackpcs((addr_t*)p->context->rbp+2, pc);
ffff80000010793b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010793f:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff800000107943:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000107947:	48 83 c0 10          	add    $0x10,%rax
ffff80000010794b:	48 89 c2             	mov    %rax,%rdx
ffff80000010794e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffff800000107952:	48 89 c6             	mov    %rax,%rsi
ffff800000107955:	48 89 d7             	mov    %rdx,%rdi
ffff800000107958:	48 b8 47 7d 10 00 00 	movabs $0xffff800000107d47,%rax
ffff80000010795f:	80 ff ff 
ffff800000107962:	ff d0                	call   *%rax
      for(i=0; i<10 && pc[i] != 0; i++)
ffff800000107964:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010796b:	eb 2f                	jmp    ffff80000010799c <procdump+0x11e>
        cprintf(" %p", pc[i]);
ffff80000010796d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107970:	48 98                	cltq
ffff800000107972:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff800000107977:	48 ba fc cb 10 00 00 	movabs $0xffff80000010cbfc,%rdx
ffff80000010797e:	80 ff ff 
ffff800000107981:	48 89 c6             	mov    %rax,%rsi
ffff800000107984:	48 89 d7             	mov    %rdx,%rdi
ffff800000107987:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010798c:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000107993:	80 ff ff 
ffff800000107996:	ff d2                	call   *%rdx
      for(i=0; i<10 && pc[i] != 0; i++)
ffff800000107998:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010799c:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff8000001079a0:	7f 0f                	jg     ffff8000001079b1 <procdump+0x133>
ffff8000001079a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001079a5:	48 98                	cltq
ffff8000001079a7:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffff8000001079ac:	48 85 c0             	test   %rax,%rax
ffff8000001079af:	75 bc                	jne    ffff80000010796d <procdump+0xef>
    }
    cprintf("\n");
ffff8000001079b1:	48 b8 00 cc 10 00 00 	movabs $0xffff80000010cc00,%rax
ffff8000001079b8:	80 ff ff 
ffff8000001079bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001079be:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001079c3:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff8000001079ca:	80 ff ff 
ffff8000001079cd:	ff d2                	call   *%rdx
ffff8000001079cf:	eb 01                	jmp    ffff8000001079d2 <procdump+0x154>
      continue;
ffff8000001079d1:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffff8000001079d2:	48 81 45 f0 a0 03 00 	addq   $0x3a0,-0x10(%rbp)
ffff8000001079d9:	00 
ffff8000001079da:	48 b8 a8 5c 12 00 00 	movabs $0xffff800000125ca8,%rax
ffff8000001079e1:	80 ff ff 
ffff8000001079e4:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff8000001079e8:	0f 82 ab fe ff ff    	jb     ffff800000107899 <procdump+0x1b>
  }
}
ffff8000001079ee:	90                   	nop
ffff8000001079ef:	90                   	nop
ffff8000001079f0:	c9                   	leave
ffff8000001079f1:	c3                   	ret

ffff8000001079f2 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
ffff8000001079f2:	55                   	push   %rbp
ffff8000001079f3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001079f6:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001079fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001079fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&lk->lk, "sleep lock");
ffff800000107a02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a06:	48 83 c0 08          	add    $0x8,%rax
ffff800000107a0a:	48 ba 2c cc 10 00 00 	movabs $0xffff80000010cc2c,%rdx
ffff800000107a11:	80 ff ff 
ffff800000107a14:	48 89 d6             	mov    %rdx,%rsi
ffff800000107a17:	48 89 c7             	mov    %rax,%rdi
ffff800000107a1a:	48 b8 c8 7b 10 00 00 	movabs $0xffff800000107bc8,%rax
ffff800000107a21:	80 ff ff 
ffff800000107a24:	ff d0                	call   *%rax
  lk->name = name;
ffff800000107a26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000107a2e:	48 89 50 70          	mov    %rdx,0x70(%rax)
  lk->locked = 0;
ffff800000107a32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a36:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff800000107a3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a40:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
}
ffff800000107a47:	90                   	nop
ffff800000107a48:	c9                   	leave
ffff800000107a49:	c3                   	ret

ffff800000107a4a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
ffff800000107a4a:	55                   	push   %rbp
ffff800000107a4b:	48 89 e5             	mov    %rsp,%rbp
ffff800000107a4e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107a52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff800000107a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a5a:	48 83 c0 08          	add    $0x8,%rax
ffff800000107a5e:	48 89 c7             	mov    %rax,%rdi
ffff800000107a61:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000107a68:	80 ff ff 
ffff800000107a6b:	ff d0                	call   *%rax
  while (lk->locked)
ffff800000107a6d:	eb 1e                	jmp    ffff800000107a8d <acquiresleep+0x43>
    sleep(lk, &lk->lk);
ffff800000107a6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a73:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000107a77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a7b:	48 89 d6             	mov    %rdx,%rsi
ffff800000107a7e:	48 89 c7             	mov    %rax,%rdi
ffff800000107a81:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000107a88:	80 ff ff 
ffff800000107a8b:	ff d0                	call   *%rax
  while (lk->locked)
ffff800000107a8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a91:	8b 00                	mov    (%rax),%eax
ffff800000107a93:	85 c0                	test   %eax,%eax
ffff800000107a95:	75 d8                	jne    ffff800000107a6f <acquiresleep+0x25>
  lk->locked = 1;
ffff800000107a97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107a9b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  lk->pid = proc->pid;
ffff800000107aa1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000107aa8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107aac:	8b 50 1c             	mov    0x1c(%rax),%edx
ffff800000107aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ab3:	89 50 78             	mov    %edx,0x78(%rax)
  release(&lk->lk);
ffff800000107ab6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107aba:	48 83 c0 08          	add    $0x8,%rax
ffff800000107abe:	48 89 c7             	mov    %rax,%rdi
ffff800000107ac1:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107ac8:	80 ff ff 
ffff800000107acb:	ff d0                	call   *%rax
}
ffff800000107acd:	90                   	nop
ffff800000107ace:	c9                   	leave
ffff800000107acf:	c3                   	ret

ffff800000107ad0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
ffff800000107ad0:	55                   	push   %rbp
ffff800000107ad1:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ad4:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107ad8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&lk->lk);
ffff800000107adc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ae0:	48 83 c0 08          	add    $0x8,%rax
ffff800000107ae4:	48 89 c7             	mov    %rax,%rdi
ffff800000107ae7:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000107aee:	80 ff ff 
ffff800000107af1:	ff d0                	call   *%rax
  lk->locked = 0;
ffff800000107af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107af7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->pid = 0;
ffff800000107afd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b01:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%rax)
  wakeup(lk);
ffff800000107b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b0c:	48 89 c7             	mov    %rax,%rdi
ffff800000107b0f:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff800000107b16:	80 ff ff 
ffff800000107b19:	ff d0                	call   *%rax
  release(&lk->lk);
ffff800000107b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107b1f:	48 83 c0 08          	add    $0x8,%rax
ffff800000107b23:	48 89 c7             	mov    %rax,%rdi
ffff800000107b26:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107b2d:	80 ff ff 
ffff800000107b30:	ff d0                	call   *%rax
}
ffff800000107b32:	90                   	nop
ffff800000107b33:	c9                   	leave
ffff800000107b34:	c3                   	ret

ffff800000107b35 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
ffff800000107b35:	55                   	push   %rbp
ffff800000107b36:	48 89 e5             	mov    %rsp,%rbp
ffff800000107b39:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107b3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  acquire(&lk->lk);
ffff800000107b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b45:	48 83 c0 08          	add    $0x8,%rax
ffff800000107b49:	48 89 c7             	mov    %rax,%rdi
ffff800000107b4c:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000107b53:	80 ff ff 
ffff800000107b56:	ff d0                	call   *%rax
  int r = lk->locked;
ffff800000107b58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b5c:	8b 00                	mov    (%rax),%eax
ffff800000107b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&lk->lk);
ffff800000107b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b65:	48 83 c0 08          	add    $0x8,%rax
ffff800000107b69:	48 89 c7             	mov    %rax,%rdi
ffff800000107b6c:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000107b73:	80 ff ff 
ffff800000107b76:	ff d0                	call   *%rax
  return r;
ffff800000107b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107b7b:	c9                   	leave
ffff800000107b7c:	c3                   	ret

ffff800000107b7d <readeflags>:
{
ffff800000107b7d:	55                   	push   %rbp
ffff800000107b7e:	48 89 e5             	mov    %rsp,%rbp
ffff800000107b81:	48 83 ec 10          	sub    $0x10,%rsp
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffff800000107b85:	9c                   	pushf
ffff800000107b86:	58                   	pop    %rax
ffff800000107b87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffff800000107b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000107b8f:	c9                   	leave
ffff800000107b90:	c3                   	ret

ffff800000107b91 <cli>:
{
ffff800000107b91:	55                   	push   %rbp
ffff800000107b92:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffff800000107b95:	fa                   	cli
}
ffff800000107b96:	90                   	nop
ffff800000107b97:	5d                   	pop    %rbp
ffff800000107b98:	c3                   	ret

ffff800000107b99 <sti>:
{
ffff800000107b99:	55                   	push   %rbp
ffff800000107b9a:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffff800000107b9d:	fb                   	sti
}
ffff800000107b9e:	90                   	nop
ffff800000107b9f:	5d                   	pop    %rbp
ffff800000107ba0:	c3                   	ret

ffff800000107ba1 <xchg>:
{
ffff800000107ba1:	55                   	push   %rbp
ffff800000107ba2:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ba5:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107ba9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107bad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  asm volatile("lock; xchgl %0, %1" :
ffff800000107bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000107bb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107bb9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000107bbd:	f0 87 02             	lock xchg %eax,(%rdx)
ffff800000107bc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  return result;
ffff800000107bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000107bc6:	c9                   	leave
ffff800000107bc7:	c3                   	ret

ffff800000107bc8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
ffff800000107bc8:	55                   	push   %rbp
ffff800000107bc9:	48 89 e5             	mov    %rsp,%rbp
ffff800000107bcc:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107bd0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107bd4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  lk->name = name;
ffff800000107bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107bdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000107be0:	48 89 50 08          	mov    %rdx,0x8(%rax)
  lk->locked = 0;
ffff800000107be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107be8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->cpu = 0;
ffff800000107bee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107bf2:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000107bf9:	00 
}
ffff800000107bfa:	90                   	nop
ffff800000107bfb:	c9                   	leave
ffff800000107bfc:	c3                   	ret

ffff800000107bfd <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
ffff800000107bfd:	55                   	push   %rbp
ffff800000107bfe:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c01:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107c05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  pushcli(); // disable interrupts to avoid deadlock.
ffff800000107c09:	48 b8 1d 7e 10 00 00 	movabs $0xffff800000107e1d,%rax
ffff800000107c10:	80 ff ff 
ffff800000107c13:	ff d0                	call   *%rax
  if(holding(lk))
ffff800000107c15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c19:	48 89 c7             	mov    %rax,%rdi
ffff800000107c1c:	48 b8 e1 7d 10 00 00 	movabs $0xffff800000107de1,%rax
ffff800000107c23:	80 ff ff 
ffff800000107c26:	ff d0                	call   *%rax
ffff800000107c28:	85 c0                	test   %eax,%eax
ffff800000107c2a:	74 19                	je     ffff800000107c45 <acquire+0x48>
    panic("acquire");
ffff800000107c2c:	48 b8 37 cc 10 00 00 	movabs $0xffff80000010cc37,%rax
ffff800000107c33:	80 ff ff 
ffff800000107c36:	48 89 c7             	mov    %rax,%rdi
ffff800000107c39:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000107c40:	80 ff ff 
ffff800000107c43:	ff d0                	call   *%rax

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
ffff800000107c45:	90                   	nop
ffff800000107c46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c4a:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107c4f:	48 89 c7             	mov    %rax,%rdi
ffff800000107c52:	48 b8 a1 7b 10 00 00 	movabs $0xffff800000107ba1,%rax
ffff800000107c59:	80 ff ff 
ffff800000107c5c:	ff d0                	call   *%rax
ffff800000107c5e:	85 c0                	test   %eax,%eax
ffff800000107c60:	75 e4                	jne    ffff800000107c46 <acquire+0x49>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
ffff800000107c62:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
ffff800000107c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c6c:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffff800000107c73:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffff800000107c77:	48 89 50 10          	mov    %rdx,0x10(%rax)
  getcallerpcs(&lk, lk->pcs);
ffff800000107c7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c7f:	48 8d 50 18          	lea    0x18(%rax),%rdx
ffff800000107c83:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000107c87:	48 89 d6             	mov    %rdx,%rsi
ffff800000107c8a:	48 89 c7             	mov    %rax,%rdi
ffff800000107c8d:	48 b8 13 7d 10 00 00 	movabs $0xffff800000107d13,%rax
ffff800000107c94:	80 ff ff 
ffff800000107c97:	ff d0                	call   *%rax
}
ffff800000107c99:	90                   	nop
ffff800000107c9a:	c9                   	leave
ffff800000107c9b:	c3                   	ret

ffff800000107c9c <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
ffff800000107c9c:	55                   	push   %rbp
ffff800000107c9d:	48 89 e5             	mov    %rsp,%rbp
ffff800000107ca0:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107ca4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holding(lk))
ffff800000107ca8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107cac:	48 89 c7             	mov    %rax,%rdi
ffff800000107caf:	48 b8 e1 7d 10 00 00 	movabs $0xffff800000107de1,%rax
ffff800000107cb6:	80 ff ff 
ffff800000107cb9:	ff d0                	call   *%rax
ffff800000107cbb:	85 c0                	test   %eax,%eax
ffff800000107cbd:	75 19                	jne    ffff800000107cd8 <release+0x3c>
    panic("release");
ffff800000107cbf:	48 b8 3f cc 10 00 00 	movabs $0xffff80000010cc3f,%rax
ffff800000107cc6:	80 ff ff 
ffff800000107cc9:	48 89 c7             	mov    %rax,%rdi
ffff800000107ccc:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000107cd3:	80 ff ff 
ffff800000107cd6:	ff d0                	call   *%rax

  lk->pcs[0] = 0;
ffff800000107cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107cdc:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
ffff800000107ce3:	00 
  lk->cpu = 0;
ffff800000107ce4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ce8:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffff800000107cef:	00 
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
ffff800000107cf0:	f0 48 83 0c 24 00    	lock orq $0x0,(%rsp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
ffff800000107cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107cfa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000107cfe:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

  popcli();
ffff800000107d04:	48 b8 8b 7e 10 00 00 	movabs $0xffff800000107e8b,%rax
ffff800000107d0b:	80 ff ff 
ffff800000107d0e:	ff d0                	call   *%rax
}
ffff800000107d10:	90                   	nop
ffff800000107d11:	c9                   	leave
ffff800000107d12:	c3                   	ret

ffff800000107d13 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %rbp chain.
void
getcallerpcs(void *v, addr_t pcs[])
{
ffff800000107d13:	55                   	push   %rbp
ffff800000107d14:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d17:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107d1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107d1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  addr_t *rbp;

  asm volatile("mov %%rbp, %0" : "=r" (rbp));
ffff800000107d23:	48 89 e8             	mov    %rbp,%rax
ffff800000107d26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  getstackpcs(rbp, pcs);
ffff800000107d2a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000107d2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d32:	48 89 d6             	mov    %rdx,%rsi
ffff800000107d35:	48 89 c7             	mov    %rax,%rdi
ffff800000107d38:	48 b8 47 7d 10 00 00 	movabs $0xffff800000107d47,%rax
ffff800000107d3f:	80 ff ff 
ffff800000107d42:	ff d0                	call   *%rax
}
ffff800000107d44:	90                   	nop
ffff800000107d45:	c9                   	leave
ffff800000107d46:	c3                   	ret

ffff800000107d47 <getstackpcs>:

void
getstackpcs(addr_t *rbp, addr_t pcs[])
{
ffff800000107d47:	55                   	push   %rbp
ffff800000107d48:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d4b:	48 83 ec 20          	sub    $0x20,%rsp
ffff800000107d4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000107d53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  for(i = 0; i < 10; i++){
ffff800000107d57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000107d5e:	eb 50                	jmp    ffff800000107db0 <getstackpcs+0x69>
    if(rbp == 0 || rbp < (addr_t*)KERNBASE || rbp == (addr_t*)0xffffffff)
ffff800000107d60:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff800000107d65:	74 70                	je     ffff800000107dd7 <getstackpcs+0x90>
ffff800000107d67:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff800000107d6e:	7f ff ff 
ffff800000107d71:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000107d75:	73 60                	jae    ffff800000107dd7 <getstackpcs+0x90>
ffff800000107d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000107d7c:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff800000107d80:	74 55                	je     ffff800000107dd7 <getstackpcs+0x90>
      break;
    pcs[i] = rbp[1];     // saved %rip
ffff800000107d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107d85:	48 98                	cltq
ffff800000107d87:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000107d8e:	00 
ffff800000107d8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107d93:	48 01 c2             	add    %rax,%rdx
ffff800000107d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107d9a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000107d9e:	48 89 02             	mov    %rax,(%rdx)
    rbp = (addr_t*)rbp[0]; // saved %rbp
ffff800000107da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107da5:	48 8b 00             	mov    (%rax),%rax
ffff800000107da8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(i = 0; i < 10; i++){
ffff800000107dac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107db0:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000107db4:	7e aa                	jle    ffff800000107d60 <getstackpcs+0x19>
  }
  for(; i < 10; i++)
ffff800000107db6:	eb 1f                	jmp    ffff800000107dd7 <getstackpcs+0x90>
    pcs[i] = 0;
ffff800000107db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000107dbb:	48 98                	cltq
ffff800000107dbd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000107dc4:	00 
ffff800000107dc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107dc9:	48 01 d0             	add    %rdx,%rax
ffff800000107dcc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; i < 10; i++)
ffff800000107dd3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000107dd7:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffff800000107ddb:	7e db                	jle    ffff800000107db8 <getstackpcs+0x71>
}
ffff800000107ddd:	90                   	nop
ffff800000107dde:	90                   	nop
ffff800000107ddf:	c9                   	leave
ffff800000107de0:	c3                   	ret

ffff800000107de1 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
ffff800000107de1:	55                   	push   %rbp
ffff800000107de2:	48 89 e5             	mov    %rsp,%rbp
ffff800000107de5:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000107de9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return lock->locked && lock->cpu == cpu;
ffff800000107ded:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107df1:	8b 00                	mov    (%rax),%eax
ffff800000107df3:	85 c0                	test   %eax,%eax
ffff800000107df5:	74 1f                	je     ffff800000107e16 <holding+0x35>
ffff800000107df7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107dfb:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000107dff:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107e06:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e0a:	48 39 c2             	cmp    %rax,%rdx
ffff800000107e0d:	75 07                	jne    ffff800000107e16 <holding+0x35>
ffff800000107e0f:	b8 01 00 00 00       	mov    $0x1,%eax
ffff800000107e14:	eb 05                	jmp    ffff800000107e1b <holding+0x3a>
ffff800000107e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000107e1b:	c9                   	leave
ffff800000107e1c:	c3                   	ret

ffff800000107e1d <pushcli>:
// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.
void
pushcli(void)
{
ffff800000107e1d:	55                   	push   %rbp
ffff800000107e1e:	48 89 e5             	mov    %rsp,%rbp
ffff800000107e21:	48 83 ec 10          	sub    $0x10,%rsp
  int eflags;

  eflags = readeflags();
ffff800000107e25:	48 b8 7d 7b 10 00 00 	movabs $0xffff800000107b7d,%rax
ffff800000107e2c:	80 ff ff 
ffff800000107e2f:	ff d0                	call   *%rax
ffff800000107e31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  cli();
ffff800000107e34:	48 b8 91 7b 10 00 00 	movabs $0xffff800000107b91,%rax
ffff800000107e3b:	80 ff ff 
ffff800000107e3e:	ff d0                	call   *%rax
  if(cpu->ncli == 0)
ffff800000107e40:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107e47:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e4b:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107e4e:	85 c0                	test   %eax,%eax
ffff800000107e50:	75 17                	jne    ffff800000107e69 <pushcli+0x4c>
    cpu->intena = eflags & FL_IF;
ffff800000107e52:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107e59:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000107e60:	81 e2 00 02 00 00    	and    $0x200,%edx
ffff800000107e66:	89 50 18             	mov    %edx,0x18(%rax)
  cpu->ncli += 1;
ffff800000107e69:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107e70:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e74:	8b 50 14             	mov    0x14(%rax),%edx
ffff800000107e77:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107e7e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107e82:	83 c2 01             	add    $0x1,%edx
ffff800000107e85:	89 50 14             	mov    %edx,0x14(%rax)
}
ffff800000107e88:	90                   	nop
ffff800000107e89:	c9                   	leave
ffff800000107e8a:	c3                   	ret

ffff800000107e8b <popcli>:

void
popcli(void)
{
ffff800000107e8b:	55                   	push   %rbp
ffff800000107e8c:	48 89 e5             	mov    %rsp,%rbp
  if(readeflags()&FL_IF)
ffff800000107e8f:	48 b8 7d 7b 10 00 00 	movabs $0xffff800000107b7d,%rax
ffff800000107e96:	80 ff ff 
ffff800000107e99:	ff d0                	call   *%rax
ffff800000107e9b:	25 00 02 00 00       	and    $0x200,%eax
ffff800000107ea0:	48 85 c0             	test   %rax,%rax
ffff800000107ea3:	74 19                	je     ffff800000107ebe <popcli+0x33>
    panic("popcli - interruptible");
ffff800000107ea5:	48 b8 47 cc 10 00 00 	movabs $0xffff80000010cc47,%rax
ffff800000107eac:	80 ff ff 
ffff800000107eaf:	48 89 c7             	mov    %rax,%rdi
ffff800000107eb2:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000107eb9:	80 ff ff 
ffff800000107ebc:	ff d0                	call   *%rax
  if(--cpu->ncli < 0)
ffff800000107ebe:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107ec5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107ec9:	8b 50 14             	mov    0x14(%rax),%edx
ffff800000107ecc:	83 ea 01             	sub    $0x1,%edx
ffff800000107ecf:	89 50 14             	mov    %edx,0x14(%rax)
ffff800000107ed2:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107ed5:	85 c0                	test   %eax,%eax
ffff800000107ed7:	79 19                	jns    ffff800000107ef2 <popcli+0x67>
    panic("popcli");
ffff800000107ed9:	48 b8 5e cc 10 00 00 	movabs $0xffff80000010cc5e,%rax
ffff800000107ee0:	80 ff ff 
ffff800000107ee3:	48 89 c7             	mov    %rax,%rdi
ffff800000107ee6:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000107eed:	80 ff ff 
ffff800000107ef0:	ff d0                	call   *%rax
  if(cpu->ncli == 0 && cpu->intena)
ffff800000107ef2:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107ef9:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107efd:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000107f00:	85 c0                	test   %eax,%eax
ffff800000107f02:	75 1e                	jne    ffff800000107f22 <popcli+0x97>
ffff800000107f04:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffff800000107f0b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000107f0f:	8b 40 18             	mov    0x18(%rax),%eax
ffff800000107f12:	85 c0                	test   %eax,%eax
ffff800000107f14:	74 0c                	je     ffff800000107f22 <popcli+0x97>
    sti();
ffff800000107f16:	48 b8 99 7b 10 00 00 	movabs $0xffff800000107b99,%rax
ffff800000107f1d:	80 ff ff 
ffff800000107f20:	ff d0                	call   *%rax
}
ffff800000107f22:	90                   	nop
ffff800000107f23:	5d                   	pop    %rbp
ffff800000107f24:	c3                   	ret

ffff800000107f25 <stosb>:
{
ffff800000107f25:	55                   	push   %rbp
ffff800000107f26:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f29:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107f2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107f31:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107f34:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
ffff800000107f37:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000107f3b:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000107f3e:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107f41:	48 89 ce             	mov    %rcx,%rsi
ffff800000107f44:	48 89 f7             	mov    %rsi,%rdi
ffff800000107f47:	89 d1                	mov    %edx,%ecx
ffff800000107f49:	fc                   	cld
ffff800000107f4a:	f3 aa                	rep stos %al,(%rdi)
ffff800000107f4c:	89 ca                	mov    %ecx,%edx
ffff800000107f4e:	48 89 fe             	mov    %rdi,%rsi
ffff800000107f51:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff800000107f55:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000107f58:	90                   	nop
ffff800000107f59:	c9                   	leave
ffff800000107f5a:	c3                   	ret

ffff800000107f5b <stosl>:
{
ffff800000107f5b:	55                   	push   %rbp
ffff800000107f5c:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f5f:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107f63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107f67:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107f6a:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosl" :
ffff800000107f6d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff800000107f71:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000107f74:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107f77:	48 89 ce             	mov    %rcx,%rsi
ffff800000107f7a:	48 89 f7             	mov    %rsi,%rdi
ffff800000107f7d:	89 d1                	mov    %edx,%ecx
ffff800000107f7f:	fc                   	cld
ffff800000107f80:	f3 ab                	rep stos %eax,(%rdi)
ffff800000107f82:	89 ca                	mov    %ecx,%edx
ffff800000107f84:	48 89 fe             	mov    %rdi,%rsi
ffff800000107f87:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffff800000107f8b:	89 55 f0             	mov    %edx,-0x10(%rbp)
}
ffff800000107f8e:	90                   	nop
ffff800000107f8f:	c9                   	leave
ffff800000107f90:	c3                   	ret

ffff800000107f91 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint64 n)
{
ffff800000107f91:	55                   	push   %rbp
ffff800000107f92:	48 89 e5             	mov    %rsp,%rbp
ffff800000107f95:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000107f99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107f9d:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff800000107fa0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  if ((addr_t)dst%4 == 0 && n%4 == 0){
ffff800000107fa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107fa8:	83 e0 03             	and    $0x3,%eax
ffff800000107fab:	48 85 c0             	test   %rax,%rax
ffff800000107fae:	75 53                	jne    ffff800000108003 <memset+0x72>
ffff800000107fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107fb4:	83 e0 03             	and    $0x3,%eax
ffff800000107fb7:	48 85 c0             	test   %rax,%rax
ffff800000107fba:	75 47                	jne    ffff800000108003 <memset+0x72>
    c &= 0xFF;
ffff800000107fbc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
ffff800000107fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107fc7:	48 c1 e8 02          	shr    $0x2,%rax
ffff800000107fcb:	89 c6                	mov    %eax,%esi
ffff800000107fcd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107fd0:	c1 e0 18             	shl    $0x18,%eax
ffff800000107fd3:	89 c2                	mov    %eax,%edx
ffff800000107fd5:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107fd8:	c1 e0 10             	shl    $0x10,%eax
ffff800000107fdb:	09 c2                	or     %eax,%edx
ffff800000107fdd:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000107fe0:	c1 e0 08             	shl    $0x8,%eax
ffff800000107fe3:	09 d0                	or     %edx,%eax
ffff800000107fe5:	0b 45 f4             	or     -0xc(%rbp),%eax
ffff800000107fe8:	89 c1                	mov    %eax,%ecx
ffff800000107fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107fee:	89 f2                	mov    %esi,%edx
ffff800000107ff0:	89 ce                	mov    %ecx,%esi
ffff800000107ff2:	48 89 c7             	mov    %rax,%rdi
ffff800000107ff5:	48 b8 5b 7f 10 00 00 	movabs $0xffff800000107f5b,%rax
ffff800000107ffc:	80 ff ff 
ffff800000107fff:	ff d0                	call   *%rax
ffff800000108001:	eb 1e                	jmp    ffff800000108021 <memset+0x90>
  } else
    stosb(dst, c, n);
ffff800000108003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108007:	89 c2                	mov    %eax,%edx
ffff800000108009:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffff80000010800c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108010:	89 ce                	mov    %ecx,%esi
ffff800000108012:	48 89 c7             	mov    %rax,%rdi
ffff800000108015:	48 b8 25 7f 10 00 00 	movabs $0xffff800000107f25,%rax
ffff80000010801c:	80 ff ff 
ffff80000010801f:	ff d0                	call   *%rax
  return dst;
ffff800000108021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000108025:	c9                   	leave
ffff800000108026:	c3                   	ret

ffff800000108027 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
ffff800000108027:	55                   	push   %rbp
ffff800000108028:	48 89 e5             	mov    %rsp,%rbp
ffff80000010802b:	48 83 ec 28          	sub    $0x28,%rsp
ffff80000010802f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108033:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000108037:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const uchar *s1, *s2;

  s1 = v1;
ffff80000010803a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010803e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  s2 = v2;
ffff800000108042:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108046:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0){
ffff80000010804a:	eb 34                	jmp    ffff800000108080 <memcmp+0x59>
    if(*s1 != *s2)
ffff80000010804c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108050:	0f b6 10             	movzbl (%rax),%edx
ffff800000108053:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108057:	0f b6 00             	movzbl (%rax),%eax
ffff80000010805a:	38 c2                	cmp    %al,%dl
ffff80000010805c:	74 18                	je     ffff800000108076 <memcmp+0x4f>
      return *s1 - *s2;
ffff80000010805e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108062:	0f b6 00             	movzbl (%rax),%eax
ffff800000108065:	0f b6 d0             	movzbl %al,%edx
ffff800000108068:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010806c:	0f b6 00             	movzbl (%rax),%eax
ffff80000010806f:	0f b6 c0             	movzbl %al,%eax
ffff800000108072:	29 c2                	sub    %eax,%edx
ffff800000108074:	eb 1c                	jmp    ffff800000108092 <memcmp+0x6b>
    s1++, s2++;
ffff800000108076:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff80000010807b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n-- > 0){
ffff800000108080:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108083:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000108086:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000108089:	85 c0                	test   %eax,%eax
ffff80000010808b:	75 bf                	jne    ffff80000010804c <memcmp+0x25>
  }

  return 0;
ffff80000010808d:	ba 00 00 00 00       	mov    $0x0,%edx
}
ffff800000108092:	89 d0                	mov    %edx,%eax
ffff800000108094:	c9                   	leave
ffff800000108095:	c3                   	ret

ffff800000108096 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
ffff800000108096:	55                   	push   %rbp
ffff800000108097:	48 89 e5             	mov    %rsp,%rbp
ffff80000010809a:	48 83 ec 28          	sub    $0x28,%rsp
ffff80000010809e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001080a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001080a6:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const char *s;
  char *d;

  s = src;
ffff8000001080a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001080ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  d = dst;
ffff8000001080b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001080b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(s < d && s + n > d){
ffff8000001080b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001080bd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff8000001080c1:	73 63                	jae    ffff800000108126 <memmove+0x90>
ffff8000001080c3:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff8000001080c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001080ca:	48 01 d0             	add    %rdx,%rax
ffff8000001080cd:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
ffff8000001080d1:	73 53                	jae    ffff800000108126 <memmove+0x90>
    s += n;
ffff8000001080d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001080d6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    d += n;
ffff8000001080da:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001080dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
    while(n-- > 0)
ffff8000001080e1:	eb 17                	jmp    ffff8000001080fa <memmove+0x64>
      *--d = *--s;
ffff8000001080e3:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffff8000001080e8:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
ffff8000001080ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001080f1:	0f b6 10             	movzbl (%rax),%edx
ffff8000001080f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001080f8:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff8000001080fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001080fd:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000108100:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff800000108103:	85 c0                	test   %eax,%eax
ffff800000108105:	75 dc                	jne    ffff8000001080e3 <memmove+0x4d>
  if(s < d && s + n > d){
ffff800000108107:	eb 2a                	jmp    ffff800000108133 <memmove+0x9d>
  } else
    while(n-- > 0)
      *d++ = *s++;
ffff800000108109:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010810d:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000108111:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108119:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff80000010811d:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
ffff800000108121:	0f b6 12             	movzbl (%rdx),%edx
ffff800000108124:	88 10                	mov    %dl,(%rax)
    while(n-- > 0)
ffff800000108126:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108129:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010812c:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff80000010812f:	85 c0                	test   %eax,%eax
ffff800000108131:	75 d6                	jne    ffff800000108109 <memmove+0x73>

  return dst;
ffff800000108133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffff800000108137:	c9                   	leave
ffff800000108138:	c3                   	ret

ffff800000108139 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
ffff800000108139:	55                   	push   %rbp
ffff80000010813a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010813d:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000108141:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108145:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000108149:	89 55 ec             	mov    %edx,-0x14(%rbp)
  return memmove(dst, src, n);
ffff80000010814c:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff80000010814f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff800000108153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108157:	48 89 ce             	mov    %rcx,%rsi
ffff80000010815a:	48 89 c7             	mov    %rax,%rdi
ffff80000010815d:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff800000108164:	80 ff ff 
ffff800000108167:	ff d0                	call   *%rax
}
ffff800000108169:	c9                   	leave
ffff80000010816a:	c3                   	ret

ffff80000010816b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
ffff80000010816b:	55                   	push   %rbp
ffff80000010816c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010816f:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000108173:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108177:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff80000010817b:	89 55 ec             	mov    %edx,-0x14(%rbp)
  while(n > 0 && *p && *p == *q)
ffff80000010817e:	eb 0e                	jmp    ffff80000010818e <strncmp+0x23>
    n--, p++, q++;
ffff800000108180:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
ffff800000108184:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000108189:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(n > 0 && *p && *p == *q)
ffff80000010818e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff800000108192:	74 1d                	je     ffff8000001081b1 <strncmp+0x46>
ffff800000108194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108198:	0f b6 00             	movzbl (%rax),%eax
ffff80000010819b:	84 c0                	test   %al,%al
ffff80000010819d:	74 12                	je     ffff8000001081b1 <strncmp+0x46>
ffff80000010819f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001081a3:	0f b6 10             	movzbl (%rax),%edx
ffff8000001081a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001081aa:	0f b6 00             	movzbl (%rax),%eax
ffff8000001081ad:	38 c2                	cmp    %al,%dl
ffff8000001081af:	74 cf                	je     ffff800000108180 <strncmp+0x15>
  if(n == 0)
ffff8000001081b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001081b5:	75 07                	jne    ffff8000001081be <strncmp+0x53>
    return 0;
ffff8000001081b7:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001081bc:	eb 16                	jmp    ffff8000001081d4 <strncmp+0x69>
  return (uchar)*p - (uchar)*q;
ffff8000001081be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001081c2:	0f b6 00             	movzbl (%rax),%eax
ffff8000001081c5:	0f b6 d0             	movzbl %al,%edx
ffff8000001081c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001081cc:	0f b6 00             	movzbl (%rax),%eax
ffff8000001081cf:	0f b6 c0             	movzbl %al,%eax
ffff8000001081d2:	29 c2                	sub    %eax,%edx
}
ffff8000001081d4:	89 d0                	mov    %edx,%eax
ffff8000001081d6:	c9                   	leave
ffff8000001081d7:	c3                   	ret

ffff8000001081d8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
ffff8000001081d8:	55                   	push   %rbp
ffff8000001081d9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001081dc:	48 83 ec 28          	sub    $0x28,%rsp
ffff8000001081e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001081e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001081e8:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff8000001081eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001081ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(n-- > 0 && (*s++ = *t++) != 0)
ffff8000001081f3:	90                   	nop
ffff8000001081f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001081f7:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001081fa:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff8000001081fd:	85 c0                	test   %eax,%eax
ffff8000001081ff:	7e 35                	jle    ffff800000108236 <strncpy+0x5e>
ffff800000108201:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000108205:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000108209:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff80000010820d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108211:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000108215:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000108219:	0f b6 12             	movzbl (%rdx),%edx
ffff80000010821c:	88 10                	mov    %dl,(%rax)
ffff80000010821e:	0f b6 00             	movzbl (%rax),%eax
ffff800000108221:	84 c0                	test   %al,%al
ffff800000108223:	75 cf                	jne    ffff8000001081f4 <strncpy+0x1c>
    ;
  while(n-- > 0)
ffff800000108225:	eb 0f                	jmp    ffff800000108236 <strncpy+0x5e>
    *s++ = 0;
ffff800000108227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010822b:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff80000010822f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff800000108233:	c6 00 00             	movb   $0x0,(%rax)
  while(n-- > 0)
ffff800000108236:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000108239:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010823c:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffff80000010823f:	85 c0                	test   %eax,%eax
ffff800000108241:	7f e4                	jg     ffff800000108227 <strncpy+0x4f>
  return os;
ffff800000108243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000108247:	c9                   	leave
ffff800000108248:	c3                   	ret

ffff800000108249 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
ffff800000108249:	55                   	push   %rbp
ffff80000010824a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010824d:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000108251:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000108255:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff800000108259:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os = s;
ffff80000010825c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108260:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n <= 0)
ffff800000108264:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000108268:	7f 06                	jg     ffff800000108270 <safestrcpy+0x27>
    return os;
ffff80000010826a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010826e:	eb 3a                	jmp    ffff8000001082aa <safestrcpy+0x61>
  while(--n > 0 && (*s++ = *t++) != 0)
ffff800000108270:	90                   	nop
ffff800000108271:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
ffff800000108275:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffff800000108279:	7e 24                	jle    ffff80000010829f <safestrcpy+0x56>
ffff80000010827b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010827f:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000108283:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000108287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010828b:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff80000010828f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
ffff800000108293:	0f b6 12             	movzbl (%rdx),%edx
ffff800000108296:	88 10                	mov    %dl,(%rax)
ffff800000108298:	0f b6 00             	movzbl (%rax),%eax
ffff80000010829b:	84 c0                	test   %al,%al
ffff80000010829d:	75 d2                	jne    ffff800000108271 <safestrcpy+0x28>
    ;
  *s = 0;
ffff80000010829f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001082a3:	c6 00 00             	movb   $0x0,(%rax)
  return os;
ffff8000001082a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff8000001082aa:	c9                   	leave
ffff8000001082ab:	c3                   	ret

ffff8000001082ac <strlen>:

int
strlen(const char *s)
{
ffff8000001082ac:	55                   	push   %rbp
ffff8000001082ad:	48 89 e5             	mov    %rsp,%rbp
ffff8000001082b0:	48 83 ec 18          	sub    $0x18,%rsp
ffff8000001082b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
ffff8000001082b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001082bf:	eb 04                	jmp    ffff8000001082c5 <strlen+0x19>
ffff8000001082c1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001082c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001082c8:	48 63 d0             	movslq %eax,%rdx
ffff8000001082cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001082cf:	48 01 d0             	add    %rdx,%rax
ffff8000001082d2:	0f b6 00             	movzbl (%rax),%eax
ffff8000001082d5:	84 c0                	test   %al,%al
ffff8000001082d7:	75 e8                	jne    ffff8000001082c1 <strlen+0x15>
    ;
  return n;
ffff8000001082d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001082dc:	c9                   	leave
ffff8000001082dd:	c3                   	ret

ffff8000001082de <swtch>:
# and then load register context from new.

.global swtch
swtch:
  # Save old callee-save registers
  pushq   %rbp
ffff8000001082de:	55                   	push   %rbp
  pushq   %rbx
ffff8000001082df:	53                   	push   %rbx
  pushq   %r12
ffff8000001082e0:	41 54                	push   %r12
  pushq   %r13
ffff8000001082e2:	41 55                	push   %r13
  pushq   %r14
ffff8000001082e4:	41 56                	push   %r14
  pushq   %r15
ffff8000001082e6:	41 57                	push   %r15

  # Switch stacks
  movq    %rsp, (%rdi)
ffff8000001082e8:	48 89 27             	mov    %rsp,(%rdi)
  movq    %rsi, %rsp
ffff8000001082eb:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  popq    %r15
ffff8000001082ee:	41 5f                	pop    %r15
  popq    %r14
ffff8000001082f0:	41 5e                	pop    %r14
  popq    %r13
ffff8000001082f2:	41 5d                	pop    %r13
  popq    %r12
ffff8000001082f4:	41 5c                	pop    %r12
  popq    %rbx
ffff8000001082f6:	5b                   	pop    %rbx
  popq    %rbp
ffff8000001082f7:	5d                   	pop    %rbp

  retq #??
ffff8000001082f8:	c3                   	ret

ffff8000001082f9 <fetchint>:
#include "syscall.h"

// Fetch the int at addr from the current process.
int
fetchint(addr_t addr, int *ip)
{
ffff8000001082f9:	55                   	push   %rbp
ffff8000001082fa:	48 89 e5             	mov    %rsp,%rbp
ffff8000001082fd:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108301:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108305:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr < PGSIZE || addr >= proc->sz || addr+sizeof(int) > proc->sz)
ffff800000108309:	48 81 7d f8 ff 0f 00 	cmpq   $0xfff,-0x8(%rbp)
ffff800000108310:	00 
ffff800000108311:	76 2f                	jbe    ffff800000108342 <fetchint+0x49>
ffff800000108313:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010831a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010831e:	48 8b 00             	mov    (%rax),%rax
ffff800000108321:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000108325:	73 1b                	jae    ffff800000108342 <fetchint+0x49>
ffff800000108327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010832b:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff80000010832f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108336:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010833a:	48 8b 00             	mov    (%rax),%rax
ffff80000010833d:	48 39 d0             	cmp    %rdx,%rax
ffff800000108340:	73 07                	jae    ffff800000108349 <fetchint+0x50>
    return -1;
ffff800000108342:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108347:	eb 11                	jmp    ffff80000010835a <fetchint+0x61>
  *ip = *(int*)(addr);
ffff800000108349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010834d:	8b 10                	mov    (%rax),%edx
ffff80000010834f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108353:	89 10                	mov    %edx,(%rax)
  return 0;
ffff800000108355:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010835a:	c9                   	leave
ffff80000010835b:	c3                   	ret

ffff80000010835c <fetchaddr>:

int
fetchaddr(addr_t addr, addr_t *ip)
{
ffff80000010835c:	55                   	push   %rbp
ffff80000010835d:	48 89 e5             	mov    %rsp,%rbp
ffff800000108360:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000108364:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000108368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr < PGSIZE || addr >= proc->sz || addr+sizeof(addr_t) > proc->sz)
ffff80000010836c:	48 81 7d f8 ff 0f 00 	cmpq   $0xfff,-0x8(%rbp)
ffff800000108373:	00 
ffff800000108374:	76 2f                	jbe    ffff8000001083a5 <fetchaddr+0x49>
ffff800000108376:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010837d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108381:	48 8b 00             	mov    (%rax),%rax
ffff800000108384:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000108388:	73 1b                	jae    ffff8000001083a5 <fetchaddr+0x49>
ffff80000010838a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010838e:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff800000108392:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108399:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010839d:	48 8b 00             	mov    (%rax),%rax
ffff8000001083a0:	48 39 d0             	cmp    %rdx,%rax
ffff8000001083a3:	73 07                	jae    ffff8000001083ac <fetchaddr+0x50>
    return -1;
ffff8000001083a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001083aa:	eb 13                	jmp    ffff8000001083bf <fetchaddr+0x63>
  *ip = *(addr_t*)(addr);
ffff8000001083ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001083b0:	48 8b 10             	mov    (%rax),%rdx
ffff8000001083b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001083b7:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff8000001083ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001083bf:	c9                   	leave
ffff8000001083c0:	c3                   	ret

ffff8000001083c1 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(addr_t addr, char **pp)
{
ffff8000001083c1:	55                   	push   %rbp
ffff8000001083c2:	48 89 e5             	mov    %rsp,%rbp
ffff8000001083c5:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001083c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001083cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s, *ep;

  if(addr < PGSIZE || addr >= proc->sz)
ffff8000001083d1:	48 81 7d e8 ff 0f 00 	cmpq   $0xfff,-0x18(%rbp)
ffff8000001083d8:	00 
ffff8000001083d9:	76 14                	jbe    ffff8000001083ef <fetchstr+0x2e>
ffff8000001083db:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001083e2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001083e6:	48 8b 00             	mov    (%rax),%rax
ffff8000001083e9:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffff8000001083ed:	72 07                	jb     ffff8000001083f6 <fetchstr+0x35>
    return -1;
ffff8000001083ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001083f4:	eb 5b                	jmp    ffff800000108451 <fetchstr+0x90>
  *pp = (char*)addr;
ffff8000001083f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001083fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001083fe:	48 89 10             	mov    %rdx,(%rax)
  ep = (char*)proc->sz;
ffff800000108401:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108408:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010840c:	48 8b 00             	mov    (%rax),%rax
ffff80000010840f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(s = *pp; s < ep; s++)
ffff800000108413:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000108417:	48 8b 00             	mov    (%rax),%rax
ffff80000010841a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010841e:	eb 22                	jmp    ffff800000108442 <fetchstr+0x81>
    if(*s == 0)
ffff800000108420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108424:	0f b6 00             	movzbl (%rax),%eax
ffff800000108427:	84 c0                	test   %al,%al
ffff800000108429:	75 12                	jne    ffff80000010843d <fetchstr+0x7c>
      return s - *pp;
ffff80000010842b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010842f:	48 8b 00             	mov    (%rax),%rax
ffff800000108432:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108436:	48 29 c2             	sub    %rax,%rdx
ffff800000108439:	89 d0                	mov    %edx,%eax
ffff80000010843b:	eb 14                	jmp    ffff800000108451 <fetchstr+0x90>
  for(s = *pp; s < ep; s++)
ffff80000010843d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000108442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108446:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff80000010844a:	72 d4                	jb     ffff800000108420 <fetchstr+0x5f>
  return -1;
ffff80000010844c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108451:	c9                   	leave
ffff800000108452:	c3                   	ret

ffff800000108453 <fetcharg>:

static addr_t
fetcharg(int n)
{
ffff800000108453:	55                   	push   %rbp
ffff800000108454:	48 89 e5             	mov    %rsp,%rbp
ffff800000108457:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010845b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  switch (n) {
ffff80000010845e:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffff800000108462:	0f 84 bb 00 00 00    	je     ffff800000108523 <fetcharg+0xd0>
ffff800000108468:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffff80000010846c:	0f 8f c6 00 00 00    	jg     ffff800000108538 <fetcharg+0xe5>
ffff800000108472:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff800000108476:	0f 84 92 00 00 00    	je     ffff80000010850e <fetcharg+0xbb>
ffff80000010847c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffff800000108480:	0f 8f b2 00 00 00    	jg     ffff800000108538 <fetcharg+0xe5>
ffff800000108486:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
ffff80000010848a:	74 6d                	je     ffff8000001084f9 <fetcharg+0xa6>
ffff80000010848c:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
ffff800000108490:	0f 8f a2 00 00 00    	jg     ffff800000108538 <fetcharg+0xe5>
ffff800000108496:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
ffff80000010849a:	74 48                	je     ffff8000001084e4 <fetcharg+0x91>
ffff80000010849c:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
ffff8000001084a0:	0f 8f 92 00 00 00    	jg     ffff800000108538 <fetcharg+0xe5>
ffff8000001084a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff8000001084aa:	74 0b                	je     ffff8000001084b7 <fetcharg+0x64>
ffff8000001084ac:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffff8000001084b0:	74 1d                	je     ffff8000001084cf <fetcharg+0x7c>
ffff8000001084b2:	e9 81 00 00 00       	jmp    ffff800000108538 <fetcharg+0xe5>
  case 0: return proc->tf->rdi;
ffff8000001084b7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001084be:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001084c2:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001084c6:	48 8b 40 30          	mov    0x30(%rax),%rax
ffff8000001084ca:	e9 82 00 00 00       	jmp    ffff800000108551 <fetcharg+0xfe>
  case 1: return proc->tf->rsi;
ffff8000001084cf:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001084d6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001084da:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001084de:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001084e2:	eb 6d                	jmp    ffff800000108551 <fetcharg+0xfe>
  case 2: return proc->tf->rdx;
ffff8000001084e4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001084eb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001084ef:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001084f3:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff8000001084f7:	eb 58                	jmp    ffff800000108551 <fetcharg+0xfe>
  case 3: return proc->tf->r10;
ffff8000001084f9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108500:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108504:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108508:	48 8b 40 48          	mov    0x48(%rax),%rax
ffff80000010850c:	eb 43                	jmp    ffff800000108551 <fetcharg+0xfe>
  case 4: return proc->tf->r8;
ffff80000010850e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108515:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108519:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff80000010851d:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000108521:	eb 2e                	jmp    ffff800000108551 <fetcharg+0xfe>
  case 5: return proc->tf->r9;
ffff800000108523:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010852a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010852e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000108532:	48 8b 40 40          	mov    0x40(%rax),%rax
ffff800000108536:	eb 19                	jmp    ffff800000108551 <fetcharg+0xfe>
  }
  panic("failed fetch");
ffff800000108538:	48 b8 65 cc 10 00 00 	movabs $0xffff80000010cc65,%rax
ffff80000010853f:	80 ff ff 
ffff800000108542:	48 89 c7             	mov    %rax,%rdi
ffff800000108545:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010854c:	80 ff ff 
ffff80000010854f:	ff d0                	call   *%rax
}
ffff800000108551:	c9                   	leave
ffff800000108552:	c3                   	ret

ffff800000108553 <argint>:

int
argint(int n, int *ip)
{
ffff800000108553:	55                   	push   %rbp
ffff800000108554:	48 89 e5             	mov    %rsp,%rbp
ffff800000108557:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010855b:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010855e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff800000108562:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108565:	89 c7                	mov    %eax,%edi
ffff800000108567:	48 b8 53 84 10 00 00 	movabs $0xffff800000108453,%rax
ffff80000010856e:	80 ff ff 
ffff800000108571:	ff d0                	call   *%rax
ffff800000108573:	89 c2                	mov    %eax,%edx
ffff800000108575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108579:	89 10                	mov    %edx,(%rax)
  return 0;
ffff80000010857b:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108580:	c9                   	leave
ffff800000108581:	c3                   	ret

ffff800000108582 <argaddr>:

addr_t
argaddr(int n, addr_t *ip)
{
ffff800000108582:	55                   	push   %rbp
ffff800000108583:	48 89 e5             	mov    %rsp,%rbp
ffff800000108586:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010858a:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010858d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffff800000108591:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108594:	89 c7                	mov    %eax,%edi
ffff800000108596:	48 b8 53 84 10 00 00 	movabs $0xffff800000108453,%rax
ffff80000010859d:	80 ff ff 
ffff8000001085a0:	ff d0                	call   *%rax
ffff8000001085a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001085a6:	48 89 02             	mov    %rax,(%rdx)
  return 0;
ffff8000001085a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001085ae:	c9                   	leave
ffff8000001085af:	c3                   	ret

ffff8000001085b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
addr_t
argptr(int n, char **pp, int size)
{
ffff8000001085b0:	55                   	push   %rbp
ffff8000001085b1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001085b4:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001085b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff8000001085bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001085bf:	89 55 e8             	mov    %edx,-0x18(%rbp)
  addr_t i;

  if(argaddr(n, &i) < 0)
ffff8000001085c2:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
ffff8000001085c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001085c9:	48 89 d6             	mov    %rdx,%rsi
ffff8000001085cc:	89 c7                	mov    %eax,%edi
ffff8000001085ce:	48 b8 82 85 10 00 00 	movabs $0xffff800000108582,%rax
ffff8000001085d5:	80 ff ff 
ffff8000001085d8:	ff d0                	call   *%rax
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
ffff8000001085da:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff8000001085de:	78 39                	js     ffff800000108619 <argptr+0x69>
ffff8000001085e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085e4:	89 c2                	mov    %eax,%edx
ffff8000001085e6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001085ed:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001085f1:	48 8b 00             	mov    (%rax),%rax
ffff8000001085f4:	48 39 c2             	cmp    %rax,%rdx
ffff8000001085f7:	73 20                	jae    ffff800000108619 <argptr+0x69>
ffff8000001085f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001085fd:	89 c2                	mov    %eax,%edx
ffff8000001085ff:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000108602:	01 d0                	add    %edx,%eax
ffff800000108604:	89 c2                	mov    %eax,%edx
ffff800000108606:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010860d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108611:	48 8b 00             	mov    (%rax),%rax
ffff800000108614:	48 39 d0             	cmp    %rdx,%rax
ffff800000108617:	73 09                	jae    ffff800000108622 <argptr+0x72>
    return -1;
ffff800000108619:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffff800000108620:	eb 13                	jmp    ffff800000108635 <argptr+0x85>
  *pp = (char*)i;
ffff800000108622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108626:	48 89 c2             	mov    %rax,%rdx
ffff800000108629:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010862d:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff800000108630:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108635:	c9                   	leave
ffff800000108636:	c3                   	ret

ffff800000108637 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
ffff800000108637:	55                   	push   %rbp
ffff800000108638:	48 89 e5             	mov    %rsp,%rbp
ffff80000010863b:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010863f:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000108642:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int addr;
  if(argint(n, &addr) < 0)
ffff800000108646:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
ffff80000010864a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010864d:	48 89 d6             	mov    %rdx,%rsi
ffff800000108650:	89 c7                	mov    %eax,%edi
ffff800000108652:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff800000108659:	80 ff ff 
ffff80000010865c:	ff d0                	call   *%rax
ffff80000010865e:	85 c0                	test   %eax,%eax
ffff800000108660:	79 07                	jns    ffff800000108669 <argstr+0x32>
    return -1;
ffff800000108662:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108667:	eb 1b                	jmp    ffff800000108684 <argstr+0x4d>
  return fetchstr(addr, pp);
ffff800000108669:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010866c:	48 98                	cltq
ffff80000010866e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000108672:	48 89 d6             	mov    %rdx,%rsi
ffff800000108675:	48 89 c7             	mov    %rax,%rdi
ffff800000108678:	48 b8 c1 83 10 00 00 	movabs $0xffff8000001083c1,%rax
ffff80000010867f:	80 ff ff 
ffff800000108682:	ff d0                	call   *%rax
}
ffff800000108684:	c9                   	leave
ffff800000108685:	c3                   	ret

ffff800000108686 <syscall>:
[SYS_fgproc]  sys_fgproc,
};

void
syscall(struct trapframe *tf)
{
ffff800000108686:	55                   	push   %rbp
ffff800000108687:	48 89 e5             	mov    %rsp,%rbp
ffff80000010868a:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010868e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  proc->tf = tf;
ffff800000108692:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108699:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010869d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001086a1:	48 89 50 28          	mov    %rdx,0x28(%rax)
  uint64 num = proc->tf->rax;
ffff8000001086a5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001086ac:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001086b0:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff8000001086b4:	48 8b 00             	mov    (%rax),%rax
ffff8000001086b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
ffff8000001086bb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001086c0:	74 3b                	je     ffff8000001086fd <syscall+0x77>
ffff8000001086c2:	48 83 7d f8 19       	cmpq   $0x19,-0x8(%rbp)
ffff8000001086c7:	77 34                	ja     ffff8000001086fd <syscall+0x77>
ffff8000001086c9:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff8000001086d0:	80 ff ff 
ffff8000001086d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086d7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff8000001086db:	48 85 c0             	test   %rax,%rax
ffff8000001086de:	74 1d                	je     ffff8000001086fd <syscall+0x77>
    tf->rax = syscalls[num]();
ffff8000001086e0:	48 ba a0 d5 10 00 00 	movabs $0xffff80000010d5a0,%rdx
ffff8000001086e7:	80 ff ff 
ffff8000001086ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001086ee:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffff8000001086f2:	ff d0                	call   *%rax
ffff8000001086f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001086f8:	48 89 02             	mov    %rax,(%rdx)
ffff8000001086fb:	eb 53                	jmp    ffff800000108750 <syscall+0xca>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
ffff8000001086fd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108704:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108708:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff80000010870f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108716:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("%d %s: unknown sys call %d\n",
ffff80000010871a:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010871d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000108721:	48 bf 72 cc 10 00 00 	movabs $0xffff80000010cc72,%rdi
ffff800000108728:	80 ff ff 
ffff80000010872b:	48 89 d1             	mov    %rdx,%rcx
ffff80000010872e:	48 89 f2             	mov    %rsi,%rdx
ffff800000108731:	89 c6                	mov    %eax,%esi
ffff800000108733:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108738:	49 b8 04 08 10 00 00 	movabs $0xffff800000100804,%r8
ffff80000010873f:	80 ff ff 
ffff800000108742:	41 ff d0             	call   *%r8
    tf->rax = -1;
ffff800000108745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108749:	48 c7 00 ff ff ff ff 	movq   $0xffffffffffffffff,(%rax)
  }
  check_signals();
ffff800000108750:	48 b8 e5 70 10 00 00 	movabs $0xffff8000001070e5,%rax
ffff800000108757:	80 ff ff 
ffff80000010875a:	ff d0                	call   *%rax
}
ffff80000010875c:	90                   	nop
ffff80000010875d:	c9                   	leave
ffff80000010875e:	c3                   	ret

ffff80000010875f <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
ffff80000010875f:	55                   	push   %rbp
ffff800000108760:	48 89 e5             	mov    %rsp,%rbp
ffff800000108763:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108767:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff80000010876a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010876e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
ffff800000108772:	48 8d 55 f4          	lea    -0xc(%rbp),%rdx
ffff800000108776:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000108779:	48 89 d6             	mov    %rdx,%rsi
ffff80000010877c:	89 c7                	mov    %eax,%edi
ffff80000010877e:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff800000108785:	80 ff ff 
ffff800000108788:	ff d0                	call   *%rax
ffff80000010878a:	85 c0                	test   %eax,%eax
ffff80000010878c:	79 07                	jns    ffff800000108795 <argfd+0x36>
    return -1;
ffff80000010878e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108793:	eb 62                	jmp    ffff8000001087f7 <argfd+0x98>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
ffff800000108795:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000108798:	85 c0                	test   %eax,%eax
ffff80000010879a:	78 2d                	js     ffff8000001087c9 <argfd+0x6a>
ffff80000010879c:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010879f:	83 f8 0f             	cmp    $0xf,%eax
ffff8000001087a2:	7f 25                	jg     ffff8000001087c9 <argfd+0x6a>
ffff8000001087a4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001087ab:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001087af:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001087b2:	48 63 d2             	movslq %edx,%rdx
ffff8000001087b5:	48 83 c2 08          	add    $0x8,%rdx
ffff8000001087b9:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff8000001087be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001087c2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001087c7:	75 07                	jne    ffff8000001087d0 <argfd+0x71>
    return -1;
ffff8000001087c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001087ce:	eb 27                	jmp    ffff8000001087f7 <argfd+0x98>
  if(pfd)
ffff8000001087d0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff8000001087d5:	74 09                	je     ffff8000001087e0 <argfd+0x81>
    *pfd = fd;
ffff8000001087d7:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001087da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001087de:	89 10                	mov    %edx,(%rax)
  if(pf)
ffff8000001087e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffff8000001087e5:	74 0b                	je     ffff8000001087f2 <argfd+0x93>
    *pf = f;
ffff8000001087e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001087eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001087ef:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffff8000001087f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff8000001087f7:	c9                   	leave
ffff8000001087f8:	c3                   	ret

ffff8000001087f9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
ffff8000001087f9:	55                   	push   %rbp
ffff8000001087fa:	48 89 e5             	mov    %rsp,%rbp
ffff8000001087fd:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000108801:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
ffff800000108805:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010880c:	eb 46                	jmp    ffff800000108854 <fdalloc+0x5b>
    if(proc->ofile[fd] == 0){
ffff80000010880e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108815:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108819:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010881c:	48 63 d2             	movslq %edx,%rdx
ffff80000010881f:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108823:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffff800000108828:	48 85 c0             	test   %rax,%rax
ffff80000010882b:	75 23                	jne    ffff800000108850 <fdalloc+0x57>
      proc->ofile[fd] = f;
ffff80000010882d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108834:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108838:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010883b:	48 63 d2             	movslq %edx,%rdx
ffff80000010883e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
ffff800000108842:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000108846:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
      return fd;
ffff80000010884b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010884e:	eb 0f                	jmp    ffff80000010885f <fdalloc+0x66>
  for(fd = 0; fd < NOFILE; fd++){
ffff800000108850:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000108854:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
ffff800000108858:	7e b4                	jle    ffff80000010880e <fdalloc+0x15>
    }
  }
  return -1;
ffff80000010885a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff80000010885f:	c9                   	leave
ffff800000108860:	c3                   	ret

ffff800000108861 <sys_dup>:

int
sys_dup(void)
{
ffff800000108861:	55                   	push   %rbp
ffff800000108862:	48 89 e5             	mov    %rsp,%rbp
ffff800000108865:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
ffff800000108869:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff80000010886d:	48 89 c2             	mov    %rax,%rdx
ffff800000108870:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108875:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010887a:	48 b8 5f 87 10 00 00 	movabs $0xffff80000010875f,%rax
ffff800000108881:	80 ff ff 
ffff800000108884:	ff d0                	call   *%rax
ffff800000108886:	85 c0                	test   %eax,%eax
ffff800000108888:	79 07                	jns    ffff800000108891 <sys_dup+0x30>
    return -1;
ffff80000010888a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010888f:	eb 39                	jmp    ffff8000001088ca <sys_dup+0x69>
  if((fd=fdalloc(f)) < 0)
ffff800000108891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108895:	48 89 c7             	mov    %rax,%rdi
ffff800000108898:	48 b8 f9 87 10 00 00 	movabs $0xffff8000001087f9,%rax
ffff80000010889f:	80 ff ff 
ffff8000001088a2:	ff d0                	call   *%rax
ffff8000001088a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001088a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff8000001088ab:	79 07                	jns    ffff8000001088b4 <sys_dup+0x53>
    return -1;
ffff8000001088ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001088b2:	eb 16                	jmp    ffff8000001088ca <sys_dup+0x69>
  filedup(f);
ffff8000001088b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001088b8:	48 89 c7             	mov    %rax,%rdi
ffff8000001088bb:	48 b8 e5 1b 10 00 00 	movabs $0xffff800000101be5,%rax
ffff8000001088c2:	80 ff ff 
ffff8000001088c5:	ff d0                	call   *%rax
  return fd;
ffff8000001088c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff8000001088ca:	c9                   	leave
ffff8000001088cb:	c3                   	ret

ffff8000001088cc <sys_read>:

int
sys_read(void)
{
ffff8000001088cc:	55                   	push   %rbp
ffff8000001088cd:	48 89 e5             	mov    %rsp,%rbp
ffff8000001088d0:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff8000001088d4:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001088d8:	48 89 c2             	mov    %rax,%rdx
ffff8000001088db:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001088e0:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001088e5:	48 b8 5f 87 10 00 00 	movabs $0xffff80000010875f,%rax
ffff8000001088ec:	80 ff ff 
ffff8000001088ef:	ff d0                	call   *%rax
ffff8000001088f1:	85 c0                	test   %eax,%eax
ffff8000001088f3:	78 56                	js     ffff80000010894b <sys_read+0x7f>
ffff8000001088f5:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff8000001088f9:	48 89 c6             	mov    %rax,%rsi
ffff8000001088fc:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108901:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff800000108908:	80 ff ff 
ffff80000010890b:	ff d0                	call   *%rax
ffff80000010890d:	85 c0                	test   %eax,%eax
ffff80000010890f:	78 3a                	js     ffff80000010894b <sys_read+0x7f>
ffff800000108911:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff800000108914:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000108918:	48 89 c6             	mov    %rax,%rsi
ffff80000010891b:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108920:	48 b8 b0 85 10 00 00 	movabs $0xffff8000001085b0,%rax
ffff800000108927:	80 ff ff 
ffff80000010892a:	ff d0                	call   *%rax
    return -1;
  return fileread(f, p, n);
ffff80000010892c:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010892f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff800000108933:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108937:	48 89 ce             	mov    %rcx,%rsi
ffff80000010893a:	48 89 c7             	mov    %rax,%rdi
ffff80000010893d:	48 b8 0f 1e 10 00 00 	movabs $0xffff800000101e0f,%rax
ffff800000108944:	80 ff ff 
ffff800000108947:	ff d0                	call   *%rax
ffff800000108949:	eb 05                	jmp    ffff800000108950 <sys_read+0x84>
    return -1;
ffff80000010894b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108950:	c9                   	leave
ffff800000108951:	c3                   	ret

ffff800000108952 <sys_write>:

int
sys_write(void)
{
ffff800000108952:	55                   	push   %rbp
ffff800000108953:	48 89 e5             	mov    %rsp,%rbp
ffff800000108956:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffff80000010895a:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff80000010895e:	48 89 c2             	mov    %rax,%rdx
ffff800000108961:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108966:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010896b:	48 b8 5f 87 10 00 00 	movabs $0xffff80000010875f,%rax
ffff800000108972:	80 ff ff 
ffff800000108975:	ff d0                	call   *%rax
ffff800000108977:	85 c0                	test   %eax,%eax
ffff800000108979:	78 56                	js     ffff8000001089d1 <sys_write+0x7f>
ffff80000010897b:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffff80000010897f:	48 89 c6             	mov    %rax,%rsi
ffff800000108982:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000108987:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff80000010898e:	80 ff ff 
ffff800000108991:	ff d0                	call   *%rax
ffff800000108993:	85 c0                	test   %eax,%eax
ffff800000108995:	78 3a                	js     ffff8000001089d1 <sys_write+0x7f>
ffff800000108997:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff80000010899a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff80000010899e:	48 89 c6             	mov    %rax,%rsi
ffff8000001089a1:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001089a6:	48 b8 b0 85 10 00 00 	movabs $0xffff8000001085b0,%rax
ffff8000001089ad:	80 ff ff 
ffff8000001089b0:	ff d0                	call   *%rax
    return -1;
  return filewrite(f, p, n);
ffff8000001089b2:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001089b5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffff8000001089b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001089bd:	48 89 ce             	mov    %rcx,%rsi
ffff8000001089c0:	48 89 c7             	mov    %rax,%rdi
ffff8000001089c3:	48 b8 03 1f 10 00 00 	movabs $0xffff800000101f03,%rax
ffff8000001089ca:	80 ff ff 
ffff8000001089cd:	ff d0                	call   *%rax
ffff8000001089cf:	eb 05                	jmp    ffff8000001089d6 <sys_write+0x84>
    return -1;
ffff8000001089d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff8000001089d6:	c9                   	leave
ffff8000001089d7:	c3                   	ret

ffff8000001089d8 <sys_close>:

int
sys_close(void)
{
ffff8000001089d8:	55                   	push   %rbp
ffff8000001089d9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001089dc:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
ffff8000001089e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
ffff8000001089e4:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff8000001089e8:	48 89 c6             	mov    %rax,%rsi
ffff8000001089eb:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001089f0:	48 b8 5f 87 10 00 00 	movabs $0xffff80000010875f,%rax
ffff8000001089f7:	80 ff ff 
ffff8000001089fa:	ff d0                	call   *%rax
ffff8000001089fc:	85 c0                	test   %eax,%eax
ffff8000001089fe:	79 07                	jns    ffff800000108a07 <sys_close+0x2f>
    return -1;
ffff800000108a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108a05:	eb 36                	jmp    ffff800000108a3d <sys_close+0x65>
  proc->ofile[fd] = 0;
ffff800000108a07:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000108a0e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000108a12:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108a15:	48 63 d2             	movslq %edx,%rdx
ffff800000108a18:	48 83 c2 08          	add    $0x8,%rdx
ffff800000108a1c:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000108a23:	00 00 
  fileclose(f);
ffff800000108a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108a29:	48 89 c7             	mov    %rax,%rdi
ffff800000108a2c:	48 b8 5e 1c 10 00 00 	movabs $0xffff800000101c5e,%rax
ffff800000108a33:	80 ff ff 
ffff800000108a36:	ff d0                	call   *%rax
  return 0;
ffff800000108a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000108a3d:	c9                   	leave
ffff800000108a3e:	c3                   	ret

ffff800000108a3f <sys_fstat>:

int
sys_fstat(void)
{
ffff800000108a3f:	55                   	push   %rbp
ffff800000108a40:	48 89 e5             	mov    %rsp,%rbp
ffff800000108a43:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
ffff800000108a47:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000108a4b:	48 89 c2             	mov    %rax,%rdx
ffff800000108a4e:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108a53:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108a58:	48 b8 5f 87 10 00 00 	movabs $0xffff80000010875f,%rax
ffff800000108a5f:	80 ff ff 
ffff800000108a62:	ff d0                	call   *%rax
ffff800000108a64:	85 c0                	test   %eax,%eax
ffff800000108a66:	78 39                	js     ffff800000108aa1 <sys_fstat+0x62>
ffff800000108a68:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000108a6c:	ba 14 00 00 00       	mov    $0x14,%edx
ffff800000108a71:	48 89 c6             	mov    %rax,%rsi
ffff800000108a74:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108a79:	48 b8 b0 85 10 00 00 	movabs $0xffff8000001085b0,%rax
ffff800000108a80:	80 ff ff 
ffff800000108a83:	ff d0                	call   *%rax
    return -1;
  return filestat(f, st);
ffff800000108a85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000108a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108a8d:	48 89 d6             	mov    %rdx,%rsi
ffff800000108a90:	48 89 c7             	mov    %rax,%rdi
ffff800000108a93:	48 b8 9a 1d 10 00 00 	movabs $0xffff800000101d9a,%rax
ffff800000108a9a:	80 ff ff 
ffff800000108a9d:	ff d0                	call   *%rax
ffff800000108a9f:	eb 05                	jmp    ffff800000108aa6 <sys_fstat+0x67>
    return -1;
ffff800000108aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108aa6:	c9                   	leave
ffff800000108aa7:	c3                   	ret

ffff800000108aa8 <isdirempty>:

static int
isdirempty(struct inode *dp)
{
ffff800000108aa8:	55                   	push   %rbp
ffff800000108aa9:	48 89 e5             	mov    %rsp,%rbp
ffff800000108aac:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000108ab0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int off;
  struct dirent de;
  // Is the directory dp empty except for "." and ".." ?
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff800000108ab4:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffff800000108abb:	eb 56                	jmp    ffff800000108b13 <isdirempty+0x6b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000108abd:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108ac0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000108ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108ac8:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000108acd:	48 89 c7             	mov    %rax,%rdi
ffff800000108ad0:	48 b8 f5 2e 10 00 00 	movabs $0xffff800000102ef5,%rax
ffff800000108ad7:	80 ff ff 
ffff800000108ada:	ff d0                	call   *%rax
ffff800000108adc:	83 f8 10             	cmp    $0x10,%eax
ffff800000108adf:	74 19                	je     ffff800000108afa <isdirempty+0x52>
      panic("isdirempty: readi");
ffff800000108ae1:	48 b8 8e cc 10 00 00 	movabs $0xffff80000010cc8e,%rax
ffff800000108ae8:	80 ff ff 
ffff800000108aeb:	48 89 c7             	mov    %rax,%rdi
ffff800000108aee:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108af5:	80 ff ff 
ffff800000108af8:	ff d0                	call   *%rax
    if(de.inum != 0)
ffff800000108afa:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffff800000108afe:	66 85 c0             	test   %ax,%ax
ffff800000108b01:	74 07                	je     ffff800000108b0a <isdirempty+0x62>
      return 0;
ffff800000108b03:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108b08:	eb 1f                	jmp    ffff800000108b29 <isdirempty+0x81>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffff800000108b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108b0d:	83 c0 10             	add    $0x10,%eax
ffff800000108b10:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff800000108b13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108b17:	8b 80 9c 00 00 00    	mov    0x9c(%rax),%eax
ffff800000108b1d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000108b20:	39 c2                	cmp    %eax,%edx
ffff800000108b22:	72 99                	jb     ffff800000108abd <isdirempty+0x15>
  }
  return 1;
ffff800000108b24:	b8 01 00 00 00       	mov    $0x1,%eax
}
ffff800000108b29:	c9                   	leave
ffff800000108b2a:	c3                   	ret

ffff800000108b2b <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
ffff800000108b2b:	55                   	push   %rbp
ffff800000108b2c:	48 89 e5             	mov    %rsp,%rbp
ffff800000108b2f:	48 83 ec 30          	sub    $0x30,%rsp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
ffff800000108b33:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffff800000108b37:	48 89 c6             	mov    %rax,%rsi
ffff800000108b3a:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108b3f:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff800000108b46:	80 ff ff 
ffff800000108b49:	ff d0                	call   *%rax
ffff800000108b4b:	85 c0                	test   %eax,%eax
ffff800000108b4d:	78 1c                	js     ffff800000108b6b <sys_link+0x40>
ffff800000108b4f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
ffff800000108b53:	48 89 c6             	mov    %rax,%rsi
ffff800000108b56:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000108b5b:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff800000108b62:	80 ff ff 
ffff800000108b65:	ff d0                	call   *%rax
ffff800000108b67:	85 c0                	test   %eax,%eax
ffff800000108b69:	79 0a                	jns    ffff800000108b75 <sys_link+0x4a>
    return -1;
ffff800000108b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108b70:	e9 f3 01 00 00       	jmp    ffff800000108d68 <sys_link+0x23d>

  begin_op();
ffff800000108b75:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff800000108b7c:	80 ff ff 
ffff800000108b7f:	ff d0                	call   *%rax
  if((ip = namei(old)) == 0){
ffff800000108b81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000108b85:	48 89 c7             	mov    %rax,%rdi
ffff800000108b88:	48 b8 93 37 10 00 00 	movabs $0xffff800000103793,%rax
ffff800000108b8f:	80 ff ff 
ffff800000108b92:	ff d0                	call   *%rax
ffff800000108b94:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108b98:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108b9d:	75 16                	jne    ffff800000108bb5 <sys_link+0x8a>
    end_op();
ffff800000108b9f:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000108ba6:	80 ff ff 
ffff800000108ba9:	ff d0                	call   *%rax
    return -1;
ffff800000108bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108bb0:	e9 b3 01 00 00       	jmp    ffff800000108d68 <sys_link+0x23d>
  }

  ilock(ip);
ffff800000108bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108bb9:	48 89 c7             	mov    %rax,%rdi
ffff800000108bbc:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000108bc3:	80 ff ff 
ffff800000108bc6:	ff d0                	call   *%rax
  if(ip->type == T_DIR){
ffff800000108bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108bcc:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108bd3:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108bd7:	75 29                	jne    ffff800000108c02 <sys_link+0xd7>
    iunlockput(ip);
ffff800000108bd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108bdd:	48 89 c7             	mov    %rax,%rdi
ffff800000108be0:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108be7:	80 ff ff 
ffff800000108bea:	ff d0                	call   *%rax
    end_op();
ffff800000108bec:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000108bf3:	80 ff ff 
ffff800000108bf6:	ff d0                	call   *%rax
    return -1;
ffff800000108bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108bfd:	e9 66 01 00 00       	jmp    ffff800000108d68 <sys_link+0x23d>
  }

  ip->nlink++;
ffff800000108c02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c06:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108c0d:	83 c0 01             	add    $0x1,%eax
ffff800000108c10:	89 c2                	mov    %eax,%edx
ffff800000108c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c16:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c21:	48 89 c7             	mov    %rax,%rdi
ffff800000108c24:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff800000108c2b:	80 ff ff 
ffff800000108c2e:	ff d0                	call   *%rax
  iunlock(ip);
ffff800000108c30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c34:	48 89 c7             	mov    %rax,%rdi
ffff800000108c37:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000108c3e:	80 ff ff 
ffff800000108c41:	ff d0                	call   *%rax

  if((dp = nameiparent(new, name)) == 0)
ffff800000108c43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108c47:	48 8d 55 e2          	lea    -0x1e(%rbp),%rdx
ffff800000108c4b:	48 89 d6             	mov    %rdx,%rsi
ffff800000108c4e:	48 89 c7             	mov    %rax,%rdi
ffff800000108c51:	48 b8 bd 37 10 00 00 	movabs $0xffff8000001037bd,%rax
ffff800000108c58:	80 ff ff 
ffff800000108c5b:	ff d0                	call   *%rax
ffff800000108c5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108c61:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108c66:	0f 84 96 00 00 00    	je     ffff800000108d02 <sys_link+0x1d7>
    goto bad;
  ilock(dp);
ffff800000108c6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c70:	48 89 c7             	mov    %rax,%rdi
ffff800000108c73:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000108c7a:	80 ff ff 
ffff800000108c7d:	ff d0                	call   *%rax
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
ffff800000108c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c83:	8b 10                	mov    (%rax),%edx
ffff800000108c85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c89:	8b 00                	mov    (%rax),%eax
ffff800000108c8b:	39 c2                	cmp    %eax,%edx
ffff800000108c8d:	75 25                	jne    ffff800000108cb4 <sys_link+0x189>
ffff800000108c8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108c93:	8b 50 04             	mov    0x4(%rax),%edx
ffff800000108c96:	48 8d 4d e2          	lea    -0x1e(%rbp),%rcx
ffff800000108c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108c9e:	48 89 ce             	mov    %rcx,%rsi
ffff800000108ca1:	48 89 c7             	mov    %rax,%rdi
ffff800000108ca4:	48 b8 09 34 10 00 00 	movabs $0xffff800000103409,%rax
ffff800000108cab:	80 ff ff 
ffff800000108cae:	ff d0                	call   *%rax
ffff800000108cb0:	85 c0                	test   %eax,%eax
ffff800000108cb2:	79 15                	jns    ffff800000108cc9 <sys_link+0x19e>
    iunlockput(dp);
ffff800000108cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108cb8:	48 89 c7             	mov    %rax,%rdi
ffff800000108cbb:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108cc2:	80 ff ff 
ffff800000108cc5:	ff d0                	call   *%rax
    goto bad;
ffff800000108cc7:	eb 3a                	jmp    ffff800000108d03 <sys_link+0x1d8>
  }
  iunlockput(dp);
ffff800000108cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ccd:	48 89 c7             	mov    %rax,%rdi
ffff800000108cd0:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108cd7:	80 ff ff 
ffff800000108cda:	ff d0                	call   *%rax
  iput(ip);
ffff800000108cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ce0:	48 89 c7             	mov    %rax,%rdi
ffff800000108ce3:	48 b8 8f 2a 10 00 00 	movabs $0xffff800000102a8f,%rax
ffff800000108cea:	80 ff ff 
ffff800000108ced:	ff d0                	call   *%rax

  end_op();
ffff800000108cef:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000108cf6:	80 ff ff 
ffff800000108cf9:	ff d0                	call   *%rax

  return 0;
ffff800000108cfb:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108d00:	eb 66                	jmp    ffff800000108d68 <sys_link+0x23d>
    goto bad;
ffff800000108d02:	90                   	nop

bad:
  ilock(ip);
ffff800000108d03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d07:	48 89 c7             	mov    %rax,%rdi
ffff800000108d0a:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000108d11:	80 ff ff 
ffff800000108d14:	ff d0                	call   *%rax
  ip->nlink--;
ffff800000108d16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d1a:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108d21:	83 e8 01             	sub    $0x1,%eax
ffff800000108d24:	89 c2                	mov    %eax,%edx
ffff800000108d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d2a:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108d31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d35:	48 89 c7             	mov    %rax,%rdi
ffff800000108d38:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff800000108d3f:	80 ff ff 
ffff800000108d42:	ff d0                	call   *%rax
  iunlockput(ip);
ffff800000108d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108d48:	48 89 c7             	mov    %rax,%rdi
ffff800000108d4b:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108d52:	80 ff ff 
ffff800000108d55:	ff d0                	call   *%rax
  end_op();
ffff800000108d57:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000108d5e:	80 ff ff 
ffff800000108d61:	ff d0                	call   *%rax
  return -1;
ffff800000108d63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000108d68:	c9                   	leave
ffff800000108d69:	c3                   	ret

ffff800000108d6a <sys_unlink>:
//PAGEBREAK!

int
sys_unlink(void)
{
ffff800000108d6a:	55                   	push   %rbp
ffff800000108d6b:	48 89 e5             	mov    %rsp,%rbp
ffff800000108d6e:	48 83 ec 40          	sub    $0x40,%rsp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
ffff800000108d72:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
ffff800000108d76:	48 89 c6             	mov    %rax,%rsi
ffff800000108d79:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000108d7e:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff800000108d85:	80 ff ff 
ffff800000108d88:	ff d0                	call   *%rax
ffff800000108d8a:	85 c0                	test   %eax,%eax
ffff800000108d8c:	79 0a                	jns    ffff800000108d98 <sys_unlink+0x2e>
    return -1;
ffff800000108d8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108d93:	e9 7b 02 00 00       	jmp    ffff800000109013 <sys_unlink+0x2a9>

  begin_op();
ffff800000108d98:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff800000108d9f:	80 ff ff 
ffff800000108da2:	ff d0                	call   *%rax
  if((dp = nameiparent(path, name)) == 0){
ffff800000108da4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108da8:	48 8d 55 d2          	lea    -0x2e(%rbp),%rdx
ffff800000108dac:	48 89 d6             	mov    %rdx,%rsi
ffff800000108daf:	48 89 c7             	mov    %rax,%rdi
ffff800000108db2:	48 b8 bd 37 10 00 00 	movabs $0xffff8000001037bd,%rax
ffff800000108db9:	80 ff ff 
ffff800000108dbc:	ff d0                	call   *%rax
ffff800000108dbe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000108dc2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000108dc7:	75 16                	jne    ffff800000108ddf <sys_unlink+0x75>
    end_op();
ffff800000108dc9:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000108dd0:	80 ff ff 
ffff800000108dd3:	ff d0                	call   *%rax
    return -1;
ffff800000108dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000108dda:	e9 34 02 00 00       	jmp    ffff800000109013 <sys_unlink+0x2a9>
  }

  ilock(dp);
ffff800000108ddf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108de3:	48 89 c7             	mov    %rax,%rdi
ffff800000108de6:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000108ded:	80 ff ff 
ffff800000108df0:	ff d0                	call   *%rax

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
ffff800000108df2:	48 ba a0 cc 10 00 00 	movabs $0xffff80000010cca0,%rdx
ffff800000108df9:	80 ff ff 
ffff800000108dfc:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff800000108e00:	48 89 d6             	mov    %rdx,%rsi
ffff800000108e03:	48 89 c7             	mov    %rax,%rdi
ffff800000108e06:	48 b8 d2 32 10 00 00 	movabs $0xffff8000001032d2,%rax
ffff800000108e0d:	80 ff ff 
ffff800000108e10:	ff d0                	call   *%rax
ffff800000108e12:	85 c0                	test   %eax,%eax
ffff800000108e14:	0f 84 d1 01 00 00    	je     ffff800000108feb <sys_unlink+0x281>
ffff800000108e1a:	48 ba a2 cc 10 00 00 	movabs $0xffff80000010cca2,%rdx
ffff800000108e21:	80 ff ff 
ffff800000108e24:	48 8d 45 d2          	lea    -0x2e(%rbp),%rax
ffff800000108e28:	48 89 d6             	mov    %rdx,%rsi
ffff800000108e2b:	48 89 c7             	mov    %rax,%rdi
ffff800000108e2e:	48 b8 d2 32 10 00 00 	movabs $0xffff8000001032d2,%rax
ffff800000108e35:	80 ff ff 
ffff800000108e38:	ff d0                	call   *%rax
ffff800000108e3a:	85 c0                	test   %eax,%eax
ffff800000108e3c:	0f 84 a9 01 00 00    	je     ffff800000108feb <sys_unlink+0x281>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
ffff800000108e42:	48 8d 55 c4          	lea    -0x3c(%rbp),%rdx
ffff800000108e46:	48 8d 4d d2          	lea    -0x2e(%rbp),%rcx
ffff800000108e4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108e4e:	48 89 ce             	mov    %rcx,%rsi
ffff800000108e51:	48 89 c7             	mov    %rax,%rdi
ffff800000108e54:	48 b8 03 33 10 00 00 	movabs $0xffff800000103303,%rax
ffff800000108e5b:	80 ff ff 
ffff800000108e5e:	ff d0                	call   *%rax
ffff800000108e60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000108e64:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000108e69:	0f 84 7f 01 00 00    	je     ffff800000108fee <sys_unlink+0x284>
    goto bad;
  ilock(ip);
ffff800000108e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e73:	48 89 c7             	mov    %rax,%rdi
ffff800000108e76:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000108e7d:	80 ff ff 
ffff800000108e80:	ff d0                	call   *%rax

  if(ip->nlink < 1)
ffff800000108e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108e86:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108e8d:	66 85 c0             	test   %ax,%ax
ffff800000108e90:	7f 19                	jg     ffff800000108eab <sys_unlink+0x141>
    panic("unlink: nlink < 1");
ffff800000108e92:	48 b8 a5 cc 10 00 00 	movabs $0xffff80000010cca5,%rax
ffff800000108e99:	80 ff ff 
ffff800000108e9c:	48 89 c7             	mov    %rax,%rdi
ffff800000108e9f:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108ea6:	80 ff ff 
ffff800000108ea9:	ff d0                	call   *%rax
  if(ip->type == T_DIR && !isdirempty(ip)){
ffff800000108eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108eaf:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108eb6:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108eba:	75 2f                	jne    ffff800000108eeb <sys_unlink+0x181>
ffff800000108ebc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ec0:	48 89 c7             	mov    %rax,%rdi
ffff800000108ec3:	48 b8 a8 8a 10 00 00 	movabs $0xffff800000108aa8,%rax
ffff800000108eca:	80 ff ff 
ffff800000108ecd:	ff d0                	call   *%rax
ffff800000108ecf:	85 c0                	test   %eax,%eax
ffff800000108ed1:	75 18                	jne    ffff800000108eeb <sys_unlink+0x181>
    iunlockput(ip);
ffff800000108ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108ed7:	48 89 c7             	mov    %rax,%rdi
ffff800000108eda:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108ee1:	80 ff ff 
ffff800000108ee4:	ff d0                	call   *%rax
    goto bad;
ffff800000108ee6:	e9 04 01 00 00       	jmp    ffff800000108fef <sys_unlink+0x285>
  }

  memset(&de, 0, sizeof(de));
ffff800000108eeb:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000108eef:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000108ef4:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000108ef9:	48 89 c7             	mov    %rax,%rdi
ffff800000108efc:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff800000108f03:	80 ff ff 
ffff800000108f06:	ff d0                	call   *%rax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffff800000108f08:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff800000108f0b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffff800000108f0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f13:	b9 10 00 00 00       	mov    $0x10,%ecx
ffff800000108f18:	48 89 c7             	mov    %rax,%rdi
ffff800000108f1b:	48 b8 c2 30 10 00 00 	movabs $0xffff8000001030c2,%rax
ffff800000108f22:	80 ff ff 
ffff800000108f25:	ff d0                	call   *%rax
ffff800000108f27:	83 f8 10             	cmp    $0x10,%eax
ffff800000108f2a:	74 19                	je     ffff800000108f45 <sys_unlink+0x1db>
    panic("unlink: writei");
ffff800000108f2c:	48 b8 b7 cc 10 00 00 	movabs $0xffff80000010ccb7,%rax
ffff800000108f33:	80 ff ff 
ffff800000108f36:	48 89 c7             	mov    %rax,%rdi
ffff800000108f39:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000108f40:	80 ff ff 
ffff800000108f43:	ff d0                	call   *%rax
  if(ip->type == T_DIR){
ffff800000108f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108f49:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000108f50:	66 83 f8 01          	cmp    $0x1,%ax
ffff800000108f54:	75 2e                	jne    ffff800000108f84 <sys_unlink+0x21a>
    dp->nlink--;
ffff800000108f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f5a:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108f61:	83 e8 01             	sub    $0x1,%eax
ffff800000108f64:	89 c2                	mov    %eax,%edx
ffff800000108f66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f6a:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff800000108f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f75:	48 89 c7             	mov    %rax,%rdi
ffff800000108f78:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff800000108f7f:	80 ff ff 
ffff800000108f82:	ff d0                	call   *%rax
  }
  iunlockput(dp);
ffff800000108f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108f88:	48 89 c7             	mov    %rax,%rdi
ffff800000108f8b:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108f92:	80 ff ff 
ffff800000108f95:	ff d0                	call   *%rax

  ip->nlink--;
ffff800000108f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108f9b:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff800000108fa2:	83 e8 01             	sub    $0x1,%eax
ffff800000108fa5:	89 c2                	mov    %eax,%edx
ffff800000108fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108fab:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
  iupdate(ip);
ffff800000108fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108fb6:	48 89 c7             	mov    %rax,%rdi
ffff800000108fb9:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff800000108fc0:	80 ff ff 
ffff800000108fc3:	ff d0                	call   *%rax
  iunlockput(ip);
ffff800000108fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108fc9:	48 89 c7             	mov    %rax,%rdi
ffff800000108fcc:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108fd3:	80 ff ff 
ffff800000108fd6:	ff d0                	call   *%rax

  end_op();
ffff800000108fd8:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000108fdf:	80 ff ff 
ffff800000108fe2:	ff d0                	call   *%rax

  return 0;
ffff800000108fe4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108fe9:	eb 28                	jmp    ffff800000109013 <sys_unlink+0x2a9>
    goto bad;
ffff800000108feb:	90                   	nop
ffff800000108fec:	eb 01                	jmp    ffff800000108fef <sys_unlink+0x285>
    goto bad;
ffff800000108fee:	90                   	nop

bad:
  iunlockput(dp);
ffff800000108fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000108ff3:	48 89 c7             	mov    %rax,%rdi
ffff800000108ff6:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000108ffd:	80 ff ff 
ffff800000109000:	ff d0                	call   *%rax
  end_op();
ffff800000109002:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000109009:	80 ff ff 
ffff80000010900c:	ff d0                	call   *%rax
  return -1;
ffff80000010900e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffff800000109013:	c9                   	leave
ffff800000109014:	c3                   	ret

ffff800000109015 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
ffff800000109015:	55                   	push   %rbp
ffff800000109016:	48 89 e5             	mov    %rsp,%rbp
ffff800000109019:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010901d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff800000109021:	89 c8                	mov    %ecx,%eax
ffff800000109023:	89 f1                	mov    %esi,%ecx
ffff800000109025:	66 89 4d c4          	mov    %cx,-0x3c(%rbp)
ffff800000109029:	66 89 55 c0          	mov    %dx,-0x40(%rbp)
ffff80000010902d:	66 89 45 bc          	mov    %ax,-0x44(%rbp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
ffff800000109031:	48 8d 55 de          	lea    -0x22(%rbp),%rdx
ffff800000109035:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000109039:	48 89 d6             	mov    %rdx,%rsi
ffff80000010903c:	48 89 c7             	mov    %rax,%rdi
ffff80000010903f:	48 b8 bd 37 10 00 00 	movabs $0xffff8000001037bd,%rax
ffff800000109046:	80 ff ff 
ffff800000109049:	ff d0                	call   *%rax
ffff80000010904b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010904f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109054:	75 0a                	jne    ffff800000109060 <create+0x4b>
    return 0;
ffff800000109056:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010905b:	e9 2c 02 00 00       	jmp    ffff80000010928c <create+0x277>
  ilock(dp);
ffff800000109060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109064:	48 89 c7             	mov    %rax,%rdi
ffff800000109067:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff80000010906e:	80 ff ff 
ffff800000109071:	ff d0                	call   *%rax

  if((ip = dirlookup(dp, name, &off)) != 0){
ffff800000109073:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
ffff800000109077:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff80000010907b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010907f:	48 89 ce             	mov    %rcx,%rsi
ffff800000109082:	48 89 c7             	mov    %rax,%rdi
ffff800000109085:	48 b8 03 33 10 00 00 	movabs $0xffff800000103303,%rax
ffff80000010908c:	80 ff ff 
ffff80000010908f:	ff d0                	call   *%rax
ffff800000109091:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000109095:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010909a:	74 64                	je     ffff800000109100 <create+0xeb>
    iunlockput(dp);
ffff80000010909c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001090a0:	48 89 c7             	mov    %rax,%rdi
ffff8000001090a3:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff8000001090aa:	80 ff ff 
ffff8000001090ad:	ff d0                	call   *%rax
    ilock(ip);
ffff8000001090af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001090b3:	48 89 c7             	mov    %rax,%rdi
ffff8000001090b6:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff8000001090bd:	80 ff ff 
ffff8000001090c0:	ff d0                	call   *%rax
    if(type == T_FILE && ip->type == T_FILE)
ffff8000001090c2:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%rbp)
ffff8000001090c7:	75 1a                	jne    ffff8000001090e3 <create+0xce>
ffff8000001090c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001090cd:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001090d4:	66 83 f8 02          	cmp    $0x2,%ax
ffff8000001090d8:	75 09                	jne    ffff8000001090e3 <create+0xce>
      return ip;
ffff8000001090da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001090de:	e9 a9 01 00 00       	jmp    ffff80000010928c <create+0x277>
    iunlockput(ip);
ffff8000001090e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001090e7:	48 89 c7             	mov    %rax,%rdi
ffff8000001090ea:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff8000001090f1:	80 ff ff 
ffff8000001090f4:	ff d0                	call   *%rax
    return 0;
ffff8000001090f6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001090fb:	e9 8c 01 00 00       	jmp    ffff80000010928c <create+0x277>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
ffff800000109100:	0f bf 55 c4          	movswl -0x3c(%rbp),%edx
ffff800000109104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109108:	8b 00                	mov    (%rax),%eax
ffff80000010910a:	89 d6                	mov    %edx,%esi
ffff80000010910c:	89 c7                	mov    %eax,%edi
ffff80000010910e:	48 b8 c0 24 10 00 00 	movabs $0xffff8000001024c0,%rax
ffff800000109115:	80 ff ff 
ffff800000109118:	ff d0                	call   *%rax
ffff80000010911a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010911e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000109123:	75 19                	jne    ffff80000010913e <create+0x129>
    panic("create: ialloc");
ffff800000109125:	48 b8 c6 cc 10 00 00 	movabs $0xffff80000010ccc6,%rax
ffff80000010912c:	80 ff ff 
ffff80000010912f:	48 89 c7             	mov    %rax,%rdi
ffff800000109132:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000109139:	80 ff ff 
ffff80000010913c:	ff d0                	call   *%rax

  ilock(ip);
ffff80000010913e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109142:	48 89 c7             	mov    %rax,%rdi
ffff800000109145:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff80000010914c:	80 ff ff 
ffff80000010914f:	ff d0                	call   *%rax
  ip->major = major;
ffff800000109151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109155:	0f b7 55 c0          	movzwl -0x40(%rbp),%edx
ffff800000109159:	66 89 90 96 00 00 00 	mov    %dx,0x96(%rax)
  ip->minor = minor;
ffff800000109160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109164:	0f b7 55 bc          	movzwl -0x44(%rbp),%edx
ffff800000109168:	66 89 90 98 00 00 00 	mov    %dx,0x98(%rax)
  ip->nlink = 1;
ffff80000010916f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109173:	66 c7 80 9a 00 00 00 	movw   $0x1,0x9a(%rax)
ffff80000010917a:	01 00 
  iupdate(ip);
ffff80000010917c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109180:	48 89 c7             	mov    %rax,%rdi
ffff800000109183:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff80000010918a:	80 ff ff 
ffff80000010918d:	ff d0                	call   *%rax

  if(type == T_DIR){  // Create . and .. entries.
ffff80000010918f:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%rbp)
ffff800000109194:	0f 85 9d 00 00 00    	jne    ffff800000109237 <create+0x222>
    dp->nlink++;  // for ".."
ffff80000010919a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010919e:	0f b7 80 9a 00 00 00 	movzwl 0x9a(%rax),%eax
ffff8000001091a5:	83 c0 01             	add    $0x1,%eax
ffff8000001091a8:	89 c2                	mov    %eax,%edx
ffff8000001091aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001091ae:	66 89 90 9a 00 00 00 	mov    %dx,0x9a(%rax)
    iupdate(dp);
ffff8000001091b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001091b9:	48 89 c7             	mov    %rax,%rdi
ffff8000001091bc:	48 b8 e8 25 10 00 00 	movabs $0xffff8000001025e8,%rax
ffff8000001091c3:	80 ff ff 
ffff8000001091c6:	ff d0                	call   *%rax
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
ffff8000001091c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001091cc:	8b 50 04             	mov    0x4(%rax),%edx
ffff8000001091cf:	48 b9 a0 cc 10 00 00 	movabs $0xffff80000010cca0,%rcx
ffff8000001091d6:	80 ff ff 
ffff8000001091d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001091dd:	48 89 ce             	mov    %rcx,%rsi
ffff8000001091e0:	48 89 c7             	mov    %rax,%rdi
ffff8000001091e3:	48 b8 09 34 10 00 00 	movabs $0xffff800000103409,%rax
ffff8000001091ea:	80 ff ff 
ffff8000001091ed:	ff d0                	call   *%rax
ffff8000001091ef:	85 c0                	test   %eax,%eax
ffff8000001091f1:	78 2b                	js     ffff80000010921e <create+0x209>
ffff8000001091f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001091f7:	8b 50 04             	mov    0x4(%rax),%edx
ffff8000001091fa:	48 b9 a2 cc 10 00 00 	movabs $0xffff80000010cca2,%rcx
ffff800000109201:	80 ff ff 
ffff800000109204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109208:	48 89 ce             	mov    %rcx,%rsi
ffff80000010920b:	48 89 c7             	mov    %rax,%rdi
ffff80000010920e:	48 b8 09 34 10 00 00 	movabs $0xffff800000103409,%rax
ffff800000109215:	80 ff ff 
ffff800000109218:	ff d0                	call   *%rax
ffff80000010921a:	85 c0                	test   %eax,%eax
ffff80000010921c:	79 19                	jns    ffff800000109237 <create+0x222>
      panic("create dots");
ffff80000010921e:	48 b8 d5 cc 10 00 00 	movabs $0xffff80000010ccd5,%rax
ffff800000109225:	80 ff ff 
ffff800000109228:	48 89 c7             	mov    %rax,%rdi
ffff80000010922b:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000109232:	80 ff ff 
ffff800000109235:	ff d0                	call   *%rax
  }

  if(dirlink(dp, name, ip->inum) < 0)
ffff800000109237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010923b:	8b 50 04             	mov    0x4(%rax),%edx
ffff80000010923e:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
ffff800000109242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109246:	48 89 ce             	mov    %rcx,%rsi
ffff800000109249:	48 89 c7             	mov    %rax,%rdi
ffff80000010924c:	48 b8 09 34 10 00 00 	movabs $0xffff800000103409,%rax
ffff800000109253:	80 ff ff 
ffff800000109256:	ff d0                	call   *%rax
ffff800000109258:	85 c0                	test   %eax,%eax
ffff80000010925a:	79 19                	jns    ffff800000109275 <create+0x260>
    panic("create: dirlink");
ffff80000010925c:	48 b8 e1 cc 10 00 00 	movabs $0xffff80000010cce1,%rax
ffff800000109263:	80 ff ff 
ffff800000109266:	48 89 c7             	mov    %rax,%rdi
ffff800000109269:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff800000109270:	80 ff ff 
ffff800000109273:	ff d0                	call   *%rax

  iunlockput(dp);
ffff800000109275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109279:	48 89 c7             	mov    %rax,%rdi
ffff80000010927c:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000109283:	80 ff ff 
ffff800000109286:	ff d0                	call   *%rax

  return ip;
ffff800000109288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffff80000010928c:	c9                   	leave
ffff80000010928d:	c3                   	ret

ffff80000010928e <sys_open>:

int
sys_open(void)
{
ffff80000010928e:	55                   	push   %rbp
ffff80000010928f:	48 89 e5             	mov    %rsp,%rbp
ffff800000109292:	48 83 ec 30          	sub    $0x30,%rsp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
ffff800000109296:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff80000010929a:	48 89 c6             	mov    %rax,%rsi
ffff80000010929d:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001092a2:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff8000001092a9:	80 ff ff 
ffff8000001092ac:	ff d0                	call   *%rax
ffff8000001092ae:	85 c0                	test   %eax,%eax
ffff8000001092b0:	78 1c                	js     ffff8000001092ce <sys_open+0x40>
ffff8000001092b2:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
ffff8000001092b6:	48 89 c6             	mov    %rax,%rsi
ffff8000001092b9:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001092be:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff8000001092c5:	80 ff ff 
ffff8000001092c8:	ff d0                	call   *%rax
ffff8000001092ca:	85 c0                	test   %eax,%eax
ffff8000001092cc:	79 0a                	jns    ffff8000001092d8 <sys_open+0x4a>
    return -1;
ffff8000001092ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001092d3:	e9 de 01 00 00       	jmp    ffff8000001094b6 <sys_open+0x228>

  begin_op();
ffff8000001092d8:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff8000001092df:	80 ff ff 
ffff8000001092e2:	ff d0                	call   *%rax

  if(omode & O_CREATE){
ffff8000001092e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff8000001092e7:	25 00 02 00 00       	and    $0x200,%eax
ffff8000001092ec:	85 c0                	test   %eax,%eax
ffff8000001092ee:	74 47                	je     ffff800000109337 <sys_open+0xa9>
    ip = create(path, T_FILE, 0, 0);
ffff8000001092f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001092f4:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff8000001092f9:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001092fe:	be 02 00 00 00       	mov    $0x2,%esi
ffff800000109303:	48 89 c7             	mov    %rax,%rdi
ffff800000109306:	48 b8 15 90 10 00 00 	movabs $0xffff800000109015,%rax
ffff80000010930d:	80 ff ff 
ffff800000109310:	ff d0                	call   *%rax
ffff800000109312:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(ip == 0){
ffff800000109316:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010931b:	0f 85 9e 00 00 00    	jne    ffff8000001093bf <sys_open+0x131>
      end_op();
ffff800000109321:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000109328:	80 ff ff 
ffff80000010932b:	ff d0                	call   *%rax
      return -1;
ffff80000010932d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109332:	e9 7f 01 00 00       	jmp    ffff8000001094b6 <sys_open+0x228>
    }
  } else {
    if((ip = namei(path)) == 0){
ffff800000109337:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010933b:	48 89 c7             	mov    %rax,%rdi
ffff80000010933e:	48 b8 93 37 10 00 00 	movabs $0xffff800000103793,%rax
ffff800000109345:	80 ff ff 
ffff800000109348:	ff d0                	call   *%rax
ffff80000010934a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010934e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109353:	75 16                	jne    ffff80000010936b <sys_open+0xdd>
      end_op();
ffff800000109355:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff80000010935c:	80 ff ff 
ffff80000010935f:	ff d0                	call   *%rax
      return -1;
ffff800000109361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109366:	e9 4b 01 00 00       	jmp    ffff8000001094b6 <sys_open+0x228>
    }
    ilock(ip);
ffff80000010936b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010936f:	48 89 c7             	mov    %rax,%rdi
ffff800000109372:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000109379:	80 ff ff 
ffff80000010937c:	ff d0                	call   *%rax
    if(ip->type == T_DIR && omode != O_RDONLY){
ffff80000010937e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109382:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff800000109389:	66 83 f8 01          	cmp    $0x1,%ax
ffff80000010938d:	75 30                	jne    ffff8000001093bf <sys_open+0x131>
ffff80000010938f:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109392:	85 c0                	test   %eax,%eax
ffff800000109394:	74 29                	je     ffff8000001093bf <sys_open+0x131>
      iunlockput(ip);
ffff800000109396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010939a:	48 89 c7             	mov    %rax,%rdi
ffff80000010939d:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff8000001093a4:	80 ff ff 
ffff8000001093a7:	ff d0                	call   *%rax
      end_op();
ffff8000001093a9:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff8000001093b0:	80 ff ff 
ffff8000001093b3:	ff d0                	call   *%rax
      return -1;
ffff8000001093b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001093ba:	e9 f7 00 00 00       	jmp    ffff8000001094b6 <sys_open+0x228>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
ffff8000001093bf:	48 b8 4a 1b 10 00 00 	movabs $0xffff800000101b4a,%rax
ffff8000001093c6:	80 ff ff 
ffff8000001093c9:	ff d0                	call   *%rax
ffff8000001093cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001093cf:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001093d4:	74 1c                	je     ffff8000001093f2 <sys_open+0x164>
ffff8000001093d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001093da:	48 89 c7             	mov    %rax,%rdi
ffff8000001093dd:	48 b8 f9 87 10 00 00 	movabs $0xffff8000001087f9,%rax
ffff8000001093e4:	80 ff ff 
ffff8000001093e7:	ff d0                	call   *%rax
ffff8000001093e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffff8000001093ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffff8000001093f0:	79 43                	jns    ffff800000109435 <sys_open+0x1a7>
    if(f)
ffff8000001093f2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff8000001093f7:	74 13                	je     ffff80000010940c <sys_open+0x17e>
      fileclose(f);
ffff8000001093f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001093fd:	48 89 c7             	mov    %rax,%rdi
ffff800000109400:	48 b8 5e 1c 10 00 00 	movabs $0xffff800000101c5e,%rax
ffff800000109407:	80 ff ff 
ffff80000010940a:	ff d0                	call   *%rax
    iunlockput(ip);
ffff80000010940c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109410:	48 89 c7             	mov    %rax,%rdi
ffff800000109413:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff80000010941a:	80 ff ff 
ffff80000010941d:	ff d0                	call   *%rax
    end_op();
ffff80000010941f:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000109426:	80 ff ff 
ffff800000109429:	ff d0                	call   *%rax
    return -1;
ffff80000010942b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109430:	e9 81 00 00 00       	jmp    ffff8000001094b6 <sys_open+0x228>
  }
  iunlock(ip);
ffff800000109435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109439:	48 89 c7             	mov    %rax,%rdi
ffff80000010943c:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff800000109443:	80 ff ff 
ffff800000109446:	ff d0                	call   *%rax
  end_op();
ffff800000109448:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff80000010944f:	80 ff ff 
ffff800000109452:	ff d0                	call   *%rax

  f->type = FD_INODE;
ffff800000109454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109458:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  f->ip = ip;
ffff80000010945e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109462:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000109466:	48 89 50 18          	mov    %rdx,0x18(%rax)
  f->off = 0;
ffff80000010946a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010946e:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%rax)
  f->readable = !(omode & O_WRONLY);
ffff800000109475:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109478:	83 e0 01             	and    $0x1,%eax
ffff80000010947b:	83 e0 01             	and    $0x1,%eax
ffff80000010947e:	83 f0 01             	xor    $0x1,%eax
ffff800000109481:	89 c2                	mov    %eax,%edx
ffff800000109483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109487:	88 50 08             	mov    %dl,0x8(%rax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
ffff80000010948a:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff80000010948d:	83 e0 01             	and    $0x1,%eax
ffff800000109490:	85 c0                	test   %eax,%eax
ffff800000109492:	75 0a                	jne    ffff80000010949e <sys_open+0x210>
ffff800000109494:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000109497:	83 e0 02             	and    $0x2,%eax
ffff80000010949a:	85 c0                	test   %eax,%eax
ffff80000010949c:	74 07                	je     ffff8000001094a5 <sys_open+0x217>
ffff80000010949e:	b8 01 00 00 00       	mov    $0x1,%eax
ffff8000001094a3:	eb 05                	jmp    ffff8000001094aa <sys_open+0x21c>
ffff8000001094a5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001094aa:	89 c2                	mov    %eax,%edx
ffff8000001094ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001094b0:	88 50 09             	mov    %dl,0x9(%rax)
  return fd;
ffff8000001094b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
ffff8000001094b6:	c9                   	leave
ffff8000001094b7:	c3                   	ret

ffff8000001094b8 <sys_mkdir>:

int
sys_mkdir(void)
{
ffff8000001094b8:	55                   	push   %rbp
ffff8000001094b9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001094bc:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff8000001094c0:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff8000001094c7:	80 ff ff 
ffff8000001094ca:	ff d0                	call   *%rax
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
ffff8000001094cc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff8000001094d0:	48 89 c6             	mov    %rax,%rsi
ffff8000001094d3:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001094d8:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff8000001094df:	80 ff ff 
ffff8000001094e2:	ff d0                	call   *%rax
ffff8000001094e4:	85 c0                	test   %eax,%eax
ffff8000001094e6:	78 2d                	js     ffff800000109515 <sys_mkdir+0x5d>
ffff8000001094e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001094ec:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff8000001094f1:	ba 00 00 00 00       	mov    $0x0,%edx
ffff8000001094f6:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001094fb:	48 89 c7             	mov    %rax,%rdi
ffff8000001094fe:	48 b8 15 90 10 00 00 	movabs $0xffff800000109015,%rax
ffff800000109505:	80 ff ff 
ffff800000109508:	ff d0                	call   *%rax
ffff80000010950a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010950e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff800000109513:	75 13                	jne    ffff800000109528 <sys_mkdir+0x70>
    end_op();
ffff800000109515:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff80000010951c:	80 ff ff 
ffff80000010951f:	ff d0                	call   *%rax
    return -1;
ffff800000109521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109526:	eb 24                	jmp    ffff80000010954c <sys_mkdir+0x94>
  }
  iunlockput(ip);
ffff800000109528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010952c:	48 89 c7             	mov    %rax,%rdi
ffff80000010952f:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000109536:	80 ff ff 
ffff800000109539:	ff d0                	call   *%rax
  end_op();
ffff80000010953b:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000109542:	80 ff ff 
ffff800000109545:	ff d0                	call   *%rax
  return 0;
ffff800000109547:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010954c:	c9                   	leave
ffff80000010954d:	c3                   	ret

ffff80000010954e <sys_mknod>:

int
sys_mknod(void)
{
ffff80000010954e:	55                   	push   %rbp
ffff80000010954f:	48 89 e5             	mov    %rsp,%rbp
ffff800000109552:	48 83 ec 20          	sub    $0x20,%rsp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
ffff800000109556:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff80000010955d:	80 ff ff 
ffff800000109560:	ff d0                	call   *%rax
  if((argstr(0, &path)) < 0 ||
ffff800000109562:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109566:	48 89 c6             	mov    %rax,%rsi
ffff800000109569:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010956e:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff800000109575:	80 ff ff 
ffff800000109578:	ff d0                	call   *%rax
ffff80000010957a:	85 c0                	test   %eax,%eax
ffff80000010957c:	78 67                	js     ffff8000001095e5 <sys_mknod+0x97>
     argint(1, &major) < 0 ||
ffff80000010957e:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
ffff800000109582:	48 89 c6             	mov    %rax,%rsi
ffff800000109585:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010958a:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff800000109591:	80 ff ff 
ffff800000109594:	ff d0                	call   *%rax
  if((argstr(0, &path)) < 0 ||
ffff800000109596:	85 c0                	test   %eax,%eax
ffff800000109598:	78 4b                	js     ffff8000001095e5 <sys_mknod+0x97>
     argint(2, &minor) < 0 ||
ffff80000010959a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff80000010959e:	48 89 c6             	mov    %rax,%rsi
ffff8000001095a1:	bf 02 00 00 00       	mov    $0x2,%edi
ffff8000001095a6:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff8000001095ad:	80 ff ff 
ffff8000001095b0:	ff d0                	call   *%rax
     argint(1, &major) < 0 ||
ffff8000001095b2:	85 c0                	test   %eax,%eax
ffff8000001095b4:	78 2f                	js     ffff8000001095e5 <sys_mknod+0x97>
     (ip = create(path, T_DEV, major, minor)) == 0){
ffff8000001095b6:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001095b9:	0f bf c8             	movswl %ax,%ecx
ffff8000001095bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001095bf:	0f bf d0             	movswl %ax,%edx
ffff8000001095c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001095c6:	be 03 00 00 00       	mov    $0x3,%esi
ffff8000001095cb:	48 89 c7             	mov    %rax,%rdi
ffff8000001095ce:	48 b8 15 90 10 00 00 	movabs $0xffff800000109015,%rax
ffff8000001095d5:	80 ff ff 
ffff8000001095d8:	ff d0                	call   *%rax
ffff8000001095da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
     argint(2, &minor) < 0 ||
ffff8000001095de:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff8000001095e3:	75 13                	jne    ffff8000001095f8 <sys_mknod+0xaa>
    end_op();
ffff8000001095e5:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff8000001095ec:	80 ff ff 
ffff8000001095ef:	ff d0                	call   *%rax
    return -1;
ffff8000001095f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001095f6:	eb 24                	jmp    ffff80000010961c <sys_mknod+0xce>
  }
  iunlockput(ip);
ffff8000001095f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001095fc:	48 89 c7             	mov    %rax,%rdi
ffff8000001095ff:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff800000109606:	80 ff ff 
ffff800000109609:	ff d0                	call   *%rax
  end_op();
ffff80000010960b:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000109612:	80 ff ff 
ffff800000109615:	ff d0                	call   *%rax
  return 0;
ffff800000109617:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010961c:	c9                   	leave
ffff80000010961d:	c3                   	ret

ffff80000010961e <sys_chdir>:

int
sys_chdir(void)
{
ffff80000010961e:	55                   	push   %rbp
ffff80000010961f:	48 89 e5             	mov    %rsp,%rbp
ffff800000109622:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffff800000109626:	48 b8 bd 4e 10 00 00 	movabs $0xffff800000104ebd,%rax
ffff80000010962d:	80 ff ff 
ffff800000109630:	ff d0                	call   *%rax
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
ffff800000109632:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109636:	48 89 c6             	mov    %rax,%rsi
ffff800000109639:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010963e:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff800000109645:	80 ff ff 
ffff800000109648:	ff d0                	call   *%rax
ffff80000010964a:	85 c0                	test   %eax,%eax
ffff80000010964c:	78 1e                	js     ffff80000010966c <sys_chdir+0x4e>
ffff80000010964e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109652:	48 89 c7             	mov    %rax,%rdi
ffff800000109655:	48 b8 93 37 10 00 00 	movabs $0xffff800000103793,%rax
ffff80000010965c:	80 ff ff 
ffff80000010965f:	ff d0                	call   *%rax
ffff800000109661:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000109665:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010966a:	75 16                	jne    ffff800000109682 <sys_chdir+0x64>
    end_op();
ffff80000010966c:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000109673:	80 ff ff 
ffff800000109676:	ff d0                	call   *%rax
    return -1;
ffff800000109678:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010967d:	e9 a5 00 00 00       	jmp    ffff800000109727 <sys_chdir+0x109>
  }
  ilock(ip);
ffff800000109682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109686:	48 89 c7             	mov    %rax,%rdi
ffff800000109689:	48 b8 8c 28 10 00 00 	movabs $0xffff80000010288c,%rax
ffff800000109690:	80 ff ff 
ffff800000109693:	ff d0                	call   *%rax
  if(ip->type != T_DIR){
ffff800000109695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109699:	0f b7 80 94 00 00 00 	movzwl 0x94(%rax),%eax
ffff8000001096a0:	66 83 f8 01          	cmp    $0x1,%ax
ffff8000001096a4:	74 26                	je     ffff8000001096cc <sys_chdir+0xae>
    iunlockput(ip);
ffff8000001096a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001096aa:	48 89 c7             	mov    %rax,%rdi
ffff8000001096ad:	48 b8 89 2b 10 00 00 	movabs $0xffff800000102b89,%rax
ffff8000001096b4:	80 ff ff 
ffff8000001096b7:	ff d0                	call   *%rax
    end_op();
ffff8000001096b9:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff8000001096c0:	80 ff ff 
ffff8000001096c3:	ff d0                	call   *%rax
    return -1;
ffff8000001096c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001096ca:	eb 5b                	jmp    ffff800000109727 <sys_chdir+0x109>
  }
  iunlock(ip);
ffff8000001096cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001096d0:	48 89 c7             	mov    %rax,%rdi
ffff8000001096d3:	48 b8 23 2a 10 00 00 	movabs $0xffff800000102a23,%rax
ffff8000001096da:	80 ff ff 
ffff8000001096dd:	ff d0                	call   *%rax
  iput(proc->cwd);
ffff8000001096df:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff8000001096e6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff8000001096ea:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffff8000001096f1:	48 89 c7             	mov    %rax,%rdi
ffff8000001096f4:	48 b8 8f 2a 10 00 00 	movabs $0xffff800000102a8f,%rax
ffff8000001096fb:	80 ff ff 
ffff8000001096fe:	ff d0                	call   *%rax
  end_op();
ffff800000109700:	48 b8 a5 4f 10 00 00 	movabs $0xffff800000104fa5,%rax
ffff800000109707:	80 ff ff 
ffff80000010970a:	ff d0                	call   *%rax
  proc->cwd = ip;
ffff80000010970c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109713:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109717:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010971b:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)
  return 0;
ffff800000109722:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109727:	c9                   	leave
ffff800000109728:	c3                   	ret

ffff800000109729 <sys_exec>:

int
sys_exec(void)
{
ffff800000109729:	55                   	push   %rbp
ffff80000010972a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010972d:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  char *path, *argv[MAXARG];
  int i;
  addr_t uargv, uarg;

  if(argstr(0, &path) < 0 || argaddr(1, &uargv) < 0){
ffff800000109734:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109738:	48 89 c6             	mov    %rax,%rsi
ffff80000010973b:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109740:	48 b8 37 86 10 00 00 	movabs $0xffff800000108637,%rax
ffff800000109747:	80 ff ff 
ffff80000010974a:	ff d0                	call   *%rax
ffff80000010974c:	85 c0                	test   %eax,%eax
ffff80000010974e:	78 44                	js     ffff800000109794 <sys_exec+0x6b>
ffff800000109750:	48 8d 85 e8 fe ff ff 	lea    -0x118(%rbp),%rax
ffff800000109757:	48 89 c6             	mov    %rax,%rsi
ffff80000010975a:	bf 01 00 00 00       	mov    $0x1,%edi
ffff80000010975f:	48 b8 82 85 10 00 00 	movabs $0xffff800000108582,%rax
ffff800000109766:	80 ff ff 
ffff800000109769:	ff d0                	call   *%rax
    return -1;
  }
  memset(argv, 0, sizeof(argv));
ffff80000010976b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff800000109772:	ba 00 01 00 00       	mov    $0x100,%edx
ffff800000109777:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010977c:	48 89 c7             	mov    %rax,%rdi
ffff80000010977f:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff800000109786:	80 ff ff 
ffff800000109789:	ff d0                	call   *%rax
  for(i=0;; i++){
ffff80000010978b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000109792:	eb 0a                	jmp    ffff80000010979e <sys_exec+0x75>
    return -1;
ffff800000109794:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109799:	e9 cb 00 00 00       	jmp    ffff800000109869 <sys_exec+0x140>
    if(i >= NELEM(argv))
ffff80000010979e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001097a1:	83 f8 1f             	cmp    $0x1f,%eax
ffff8000001097a4:	76 0a                	jbe    ffff8000001097b0 <sys_exec+0x87>
      return -1;
ffff8000001097a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001097ab:	e9 b9 00 00 00       	jmp    ffff800000109869 <sys_exec+0x140>
    if(fetchaddr(uargv+(sizeof(addr_t))*i, (addr_t*)&uarg) < 0)
ffff8000001097b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001097b3:	48 98                	cltq
ffff8000001097b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff8000001097bc:	00 
ffff8000001097bd:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
ffff8000001097c4:	48 01 c2             	add    %rax,%rdx
ffff8000001097c7:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
ffff8000001097ce:	48 89 c6             	mov    %rax,%rsi
ffff8000001097d1:	48 89 d7             	mov    %rdx,%rdi
ffff8000001097d4:	48 b8 5c 83 10 00 00 	movabs $0xffff80000010835c,%rax
ffff8000001097db:	80 ff ff 
ffff8000001097de:	ff d0                	call   *%rax
ffff8000001097e0:	85 c0                	test   %eax,%eax
ffff8000001097e2:	79 07                	jns    ffff8000001097eb <sys_exec+0xc2>
      return -1;
ffff8000001097e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001097e9:	eb 7e                	jmp    ffff800000109869 <sys_exec+0x140>
    if(uarg == 0){
ffff8000001097eb:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff8000001097f2:	48 85 c0             	test   %rax,%rax
ffff8000001097f5:	75 31                	jne    ffff800000109828 <sys_exec+0xff>
      argv[i] = 0;
ffff8000001097f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001097fa:	48 98                	cltq
ffff8000001097fc:	48 c7 84 c5 f0 fe ff 	movq   $0x0,-0x110(%rbp,%rax,8)
ffff800000109803:	ff 00 00 00 00 
      break;
ffff800000109808:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
ffff800000109809:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010980d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
ffff800000109814:	48 89 d6             	mov    %rdx,%rsi
ffff800000109817:	48 89 c7             	mov    %rax,%rdi
ffff80000010981a:	48 b8 43 15 10 00 00 	movabs $0xffff800000101543,%rax
ffff800000109821:	80 ff ff 
ffff800000109824:	ff d0                	call   *%rax
ffff800000109826:	eb 41                	jmp    ffff800000109869 <sys_exec+0x140>
    if(fetchstr(uarg, &argv[i]) < 0)
ffff800000109828:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffff80000010982f:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000109832:	48 63 d2             	movslq %edx,%rdx
ffff800000109835:	48 c1 e2 03          	shl    $0x3,%rdx
ffff800000109839:	48 01 c2             	add    %rax,%rdx
ffff80000010983c:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffff800000109843:	48 89 d6             	mov    %rdx,%rsi
ffff800000109846:	48 89 c7             	mov    %rax,%rdi
ffff800000109849:	48 b8 c1 83 10 00 00 	movabs $0xffff8000001083c1,%rax
ffff800000109850:	80 ff ff 
ffff800000109853:	ff d0                	call   *%rax
ffff800000109855:	85 c0                	test   %eax,%eax
ffff800000109857:	79 07                	jns    ffff800000109860 <sys_exec+0x137>
      return -1;
ffff800000109859:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010985e:	eb 09                	jmp    ffff800000109869 <sys_exec+0x140>
  for(i=0;; i++){
ffff800000109860:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    if(i >= NELEM(argv))
ffff800000109864:	e9 35 ff ff ff       	jmp    ffff80000010979e <sys_exec+0x75>
}
ffff800000109869:	c9                   	leave
ffff80000010986a:	c3                   	ret

ffff80000010986b <sys_pipe>:

int
sys_pipe(void)
{
ffff80000010986b:	55                   	push   %rbp
ffff80000010986c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010986f:	48 83 ec 20          	sub    $0x20,%rsp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
ffff800000109873:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109877:	ba 08 00 00 00       	mov    $0x8,%edx
ffff80000010987c:	48 89 c6             	mov    %rax,%rsi
ffff80000010987f:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109884:	48 b8 b0 85 10 00 00 	movabs $0xffff8000001085b0,%rax
ffff80000010988b:	80 ff ff 
ffff80000010988e:	ff d0                	call   *%rax
    return -1;
  if(pipealloc(&rf, &wf) < 0)
ffff800000109890:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffff800000109894:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffff800000109898:	48 89 d6             	mov    %rdx,%rsi
ffff80000010989b:	48 89 c7             	mov    %rax,%rdi
ffff80000010989e:	48 b8 02 5c 10 00 00 	movabs $0xffff800000105c02,%rax
ffff8000001098a5:	80 ff ff 
ffff8000001098a8:	ff d0                	call   *%rax
ffff8000001098aa:	85 c0                	test   %eax,%eax
ffff8000001098ac:	79 0a                	jns    ffff8000001098b8 <sys_pipe+0x4d>
    return -1;
ffff8000001098ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001098b3:	e9 ab 00 00 00       	jmp    ffff800000109963 <sys_pipe+0xf8>
  fd0 = -1;
ffff8000001098b8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
ffff8000001098bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001098c3:	48 89 c7             	mov    %rax,%rdi
ffff8000001098c6:	48 b8 f9 87 10 00 00 	movabs $0xffff8000001087f9,%rax
ffff8000001098cd:	80 ff ff 
ffff8000001098d0:	ff d0                	call   *%rax
ffff8000001098d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001098d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff8000001098d9:	78 1c                	js     ffff8000001098f7 <sys_pipe+0x8c>
ffff8000001098db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001098df:	48 89 c7             	mov    %rax,%rdi
ffff8000001098e2:	48 b8 f9 87 10 00 00 	movabs $0xffff8000001087f9,%rax
ffff8000001098e9:	80 ff ff 
ffff8000001098ec:	ff d0                	call   *%rax
ffff8000001098ee:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff8000001098f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffff8000001098f5:	79 51                	jns    ffff800000109948 <sys_pipe+0xdd>
    if(fd0 >= 0)
ffff8000001098f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffff8000001098fb:	78 1e                	js     ffff80000010991b <sys_pipe+0xb0>
      proc->ofile[fd0] = 0;
ffff8000001098fd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109904:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109908:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010990b:	48 63 d2             	movslq %edx,%rdx
ffff80000010990e:	48 83 c2 08          	add    $0x8,%rdx
ffff800000109912:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffff800000109919:	00 00 
    fileclose(rf);
ffff80000010991b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010991f:	48 89 c7             	mov    %rax,%rdi
ffff800000109922:	48 b8 5e 1c 10 00 00 	movabs $0xffff800000101c5e,%rax
ffff800000109929:	80 ff ff 
ffff80000010992c:	ff d0                	call   *%rax
    fileclose(wf);
ffff80000010992e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000109932:	48 89 c7             	mov    %rax,%rdi
ffff800000109935:	48 b8 5e 1c 10 00 00 	movabs $0xffff800000101c5e,%rax
ffff80000010993c:	80 ff ff 
ffff80000010993f:	ff d0                	call   *%rax
    return -1;
ffff800000109941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109946:	eb 1b                	jmp    ffff800000109963 <sys_pipe+0xf8>
  }
  fd[0] = fd0;
ffff800000109948:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010994c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010994f:	89 10                	mov    %edx,(%rax)
  fd[1] = fd1;
ffff800000109951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109955:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000109959:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010995c:	89 02                	mov    %eax,(%rdx)
  return 0;
ffff80000010995e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109963:	c9                   	leave
ffff800000109964:	c3                   	ret

ffff800000109965 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
ffff800000109965:	55                   	push   %rbp
ffff800000109966:	48 89 e5             	mov    %rsp,%rbp
  return fork();
ffff800000109969:	48 b8 22 65 10 00 00 	movabs $0xffff800000106522,%rax
ffff800000109970:	80 ff ff 
ffff800000109973:	ff d0                	call   *%rax
}
ffff800000109975:	5d                   	pop    %rbp
ffff800000109976:	c3                   	ret

ffff800000109977 <sys_exit>:

int
sys_exit(void)
{
ffff800000109977:	55                   	push   %rbp
ffff800000109978:	48 89 e5             	mov    %rsp,%rbp
  exit();
ffff80000010997b:	48 b8 da 67 10 00 00 	movabs $0xffff8000001067da,%rax
ffff800000109982:	80 ff ff 
ffff800000109985:	ff d0                	call   *%rax
  return 0;  // not reached
ffff800000109987:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010998c:	5d                   	pop    %rbp
ffff80000010998d:	c3                   	ret

ffff80000010998e <sys_wait>:

int
sys_wait(void)
{
ffff80000010998e:	55                   	push   %rbp
ffff80000010998f:	48 89 e5             	mov    %rsp,%rbp
  return wait();
ffff800000109992:	48 b8 cb 69 10 00 00 	movabs $0xffff8000001069cb,%rax
ffff800000109999:	80 ff ff 
ffff80000010999c:	ff d0                	call   *%rax
}
ffff80000010999e:	5d                   	pop    %rbp
ffff80000010999f:	c3                   	ret

ffff8000001099a0 <sys_kill>:

int
sys_kill(void)
{
ffff8000001099a0:	55                   	push   %rbp
ffff8000001099a1:	48 89 e5             	mov    %rsp,%rbp
ffff8000001099a4:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
ffff8000001099a8:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff8000001099ac:	48 89 c6             	mov    %rax,%rsi
ffff8000001099af:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001099b4:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff8000001099bb:	80 ff ff 
ffff8000001099be:	ff d0                	call   *%rax
ffff8000001099c0:	85 c0                	test   %eax,%eax
ffff8000001099c2:	79 07                	jns    ffff8000001099cb <sys_kill+0x2b>
    return -1;
ffff8000001099c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001099c9:	eb 39                	jmp    ffff800000109a04 <sys_kill+0x64>
  if(argint(1, &signum) < 0)
ffff8000001099cb:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff8000001099cf:	48 89 c6             	mov    %rax,%rsi
ffff8000001099d2:	bf 01 00 00 00       	mov    $0x1,%edi
ffff8000001099d7:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff8000001099de:	80 ff ff 
ffff8000001099e1:	ff d0                	call   *%rax
ffff8000001099e3:	85 c0                	test   %eax,%eax
ffff8000001099e5:	79 07                	jns    ffff8000001099ee <sys_kill+0x4e>
    return -1;
ffff8000001099e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff8000001099ec:	eb 16                	jmp    ffff800000109a04 <sys_kill+0x64>
  return kill(pid, signum);
ffff8000001099ee:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff8000001099f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001099f4:	89 d6                	mov    %edx,%esi
ffff8000001099f6:	89 c7                	mov    %eax,%edi
ffff8000001099f8:	48 b8 4f 77 10 00 00 	movabs $0xffff80000010774f,%rax
ffff8000001099ff:	80 ff ff 
ffff800000109a02:	ff d0                	call   *%rax
}
ffff800000109a04:	c9                   	leave
ffff800000109a05:	c3                   	ret

ffff800000109a06 <sys_alarm>:

int
sys_alarm(void) {
ffff800000109a06:	55                   	push   %rbp
ffff800000109a07:	48 89 e5             	mov    %rsp,%rbp
ffff800000109a0a:	48 83 ec 10          	sub    $0x10,%rsp
  int secs;
  if(argint(0, &secs) < 0)
ffff800000109a0e:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff800000109a12:	48 89 c6             	mov    %rax,%rsi
ffff800000109a15:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109a1a:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff800000109a21:	80 ff ff 
ffff800000109a24:	ff d0                	call   *%rax
ffff800000109a26:	85 c0                	test   %eax,%eax
ffff800000109a28:	79 07                	jns    ffff800000109a31 <sys_alarm+0x2b>
    return -1;
ffff800000109a2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109a2f:	eb 16                	jmp    ffff800000109a47 <sys_alarm+0x41>
  alarm(secs);
ffff800000109a31:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109a34:	89 c7                	mov    %eax,%edi
ffff800000109a36:	48 b8 28 70 10 00 00 	movabs $0xffff800000107028,%rax
ffff800000109a3d:	80 ff ff 
ffff800000109a40:	ff d0                	call   *%rax
  return 0;
ffff800000109a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109a47:	c9                   	leave
ffff800000109a48:	c3                   	ret

ffff800000109a49 <sys_signal>:

int sys_signal(void) {
ffff800000109a49:	55                   	push   %rbp
ffff800000109a4a:	48 89 e5             	mov    %rsp,%rbp
ffff800000109a4d:	48 83 ec 10          	sub    $0x10,%rsp
  int signum;
  void (*handler)(int)=0;
ffff800000109a51:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff800000109a58:	00 

  if(argint(0, &signum) < 0)
ffff800000109a59:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffff800000109a5d:	48 89 c6             	mov    %rax,%rsi
ffff800000109a60:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109a65:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff800000109a6c:	80 ff ff 
ffff800000109a6f:	ff d0                	call   *%rax
ffff800000109a71:	85 c0                	test   %eax,%eax
ffff800000109a73:	79 07                	jns    ffff800000109a7c <sys_signal+0x33>
    return -1;
ffff800000109a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109a7a:	eb 35                	jmp    ffff800000109ab1 <sys_signal+0x68>
  if(argaddr(1, (addr_t *)&handler) < 0)
ffff800000109a7c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109a80:	48 89 c6             	mov    %rax,%rsi
ffff800000109a83:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000109a88:	48 b8 82 85 10 00 00 	movabs $0xffff800000108582,%rax
ffff800000109a8f:	80 ff ff 
ffff800000109a92:	ff d0                	call   *%rax
    return -1;

  signal(signum,handler);
ffff800000109a94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000109a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000109a9b:	48 89 d6             	mov    %rdx,%rsi
ffff800000109a9e:	89 c7                	mov    %eax,%edi
ffff800000109aa0:	48 b8 80 70 10 00 00 	movabs $0xffff800000107080,%rax
ffff800000109aa7:	80 ff ff 
ffff800000109aaa:	ff d0                	call   *%rax
  return 0;
ffff800000109aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109ab1:	c9                   	leave
ffff800000109ab2:	c3                   	ret

ffff800000109ab3 <sys_sigret>:

int
sys_sigret(void) {
ffff800000109ab3:	55                   	push   %rbp
ffff800000109ab4:	48 89 e5             	mov    %rsp,%rbp
ffff800000109ab7:	53                   	push   %rbx
ffff800000109ab8:	48 83 ec 18          	sub    $0x18,%rsp
  cprintf("In sys_sigret\n");
ffff800000109abc:	48 b8 f1 cc 10 00 00 	movabs $0xffff80000010ccf1,%rax
ffff800000109ac3:	80 ff ff 
ffff800000109ac6:	48 89 c7             	mov    %rax,%rdi
ffff800000109ac9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109ace:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000109ad5:	80 ff ff 
ffff800000109ad8:	ff d2                	call   *%rdx
  struct trapframe * temp = proc->tf;
ffff800000109ada:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109ae1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109ae5:	48 8b 40 28          	mov    0x28(%rax),%rax
ffff800000109ae9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  proc->signal_trapframe_backup = *temp;
ffff800000109aed:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109af4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109af8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff800000109afc:	48 8b 0a             	mov    (%rdx),%rcx
ffff800000109aff:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
ffff800000109b03:	48 89 88 e8 01 00 00 	mov    %rcx,0x1e8(%rax)
ffff800000109b0a:	48 89 98 f0 01 00 00 	mov    %rbx,0x1f0(%rax)
ffff800000109b11:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
ffff800000109b15:	48 8b 5a 18          	mov    0x18(%rdx),%rbx
ffff800000109b19:	48 89 88 f8 01 00 00 	mov    %rcx,0x1f8(%rax)
ffff800000109b20:	48 89 98 00 02 00 00 	mov    %rbx,0x200(%rax)
ffff800000109b27:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
ffff800000109b2b:	48 8b 5a 28          	mov    0x28(%rdx),%rbx
ffff800000109b2f:	48 89 88 08 02 00 00 	mov    %rcx,0x208(%rax)
ffff800000109b36:	48 89 98 10 02 00 00 	mov    %rbx,0x210(%rax)
ffff800000109b3d:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
ffff800000109b41:	48 8b 5a 38          	mov    0x38(%rdx),%rbx
ffff800000109b45:	48 89 88 18 02 00 00 	mov    %rcx,0x218(%rax)
ffff800000109b4c:	48 89 98 20 02 00 00 	mov    %rbx,0x220(%rax)
ffff800000109b53:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
ffff800000109b57:	48 8b 5a 48          	mov    0x48(%rdx),%rbx
ffff800000109b5b:	48 89 88 28 02 00 00 	mov    %rcx,0x228(%rax)
ffff800000109b62:	48 89 98 30 02 00 00 	mov    %rbx,0x230(%rax)
ffff800000109b69:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
ffff800000109b6d:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
ffff800000109b71:	48 89 88 38 02 00 00 	mov    %rcx,0x238(%rax)
ffff800000109b78:	48 89 98 40 02 00 00 	mov    %rbx,0x240(%rax)
ffff800000109b7f:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
ffff800000109b83:	48 8b 5a 68          	mov    0x68(%rdx),%rbx
ffff800000109b87:	48 89 88 48 02 00 00 	mov    %rcx,0x248(%rax)
ffff800000109b8e:	48 89 98 50 02 00 00 	mov    %rbx,0x250(%rax)
ffff800000109b95:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
ffff800000109b99:	48 8b 5a 78          	mov    0x78(%rdx),%rbx
ffff800000109b9d:	48 89 88 58 02 00 00 	mov    %rcx,0x258(%rax)
ffff800000109ba4:	48 89 98 60 02 00 00 	mov    %rbx,0x260(%rax)
ffff800000109bab:	48 8b 8a 80 00 00 00 	mov    0x80(%rdx),%rcx
ffff800000109bb2:	48 8b 9a 88 00 00 00 	mov    0x88(%rdx),%rbx
ffff800000109bb9:	48 89 88 68 02 00 00 	mov    %rcx,0x268(%rax)
ffff800000109bc0:	48 89 98 70 02 00 00 	mov    %rbx,0x270(%rax)
ffff800000109bc7:	48 8b 8a 90 00 00 00 	mov    0x90(%rdx),%rcx
ffff800000109bce:	48 8b 9a 98 00 00 00 	mov    0x98(%rdx),%rbx
ffff800000109bd5:	48 89 88 78 02 00 00 	mov    %rcx,0x278(%rax)
ffff800000109bdc:	48 89 98 80 02 00 00 	mov    %rbx,0x280(%rax)
ffff800000109be3:	48 8b 8a a0 00 00 00 	mov    0xa0(%rdx),%rcx
ffff800000109bea:	48 8b 9a a8 00 00 00 	mov    0xa8(%rdx),%rbx
ffff800000109bf1:	48 89 88 88 02 00 00 	mov    %rcx,0x288(%rax)
ffff800000109bf8:	48 89 98 90 02 00 00 	mov    %rbx,0x290(%rax)
  return 0;
ffff800000109bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109c04:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff800000109c08:	c9                   	leave
ffff800000109c09:	c3                   	ret

ffff800000109c0a <sys_fgproc>:

int
sys_fgproc(void) {
ffff800000109c0a:	55                   	push   %rbp
ffff800000109c0b:	48 89 e5             	mov    %rsp,%rbp
  cprintf("In sys_fgproc\n");
ffff800000109c0e:	48 b8 00 cd 10 00 00 	movabs $0xffff80000010cd00,%rax
ffff800000109c15:	80 ff ff 
ffff800000109c18:	48 89 c7             	mov    %rax,%rdi
ffff800000109c1b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000109c20:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff800000109c27:	80 ff ff 
ffff800000109c2a:	ff d2                	call   *%rdx
  return 0;
ffff800000109c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109c31:	5d                   	pop    %rbp
ffff800000109c32:	c3                   	ret

ffff800000109c33 <sys_getpid>:

int
sys_getpid(void)
{
ffff800000109c33:	55                   	push   %rbp
ffff800000109c34:	48 89 e5             	mov    %rsp,%rbp
  return proc->pid;
ffff800000109c37:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109c3e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109c42:	8b 40 1c             	mov    0x1c(%rax),%eax
}
ffff800000109c45:	5d                   	pop    %rbp
ffff800000109c46:	c3                   	ret

ffff800000109c47 <sys_sbrk>:

addr_t
sys_sbrk(void)
{
ffff800000109c47:	55                   	push   %rbp
ffff800000109c48:	48 89 e5             	mov    %rsp,%rbp
ffff800000109c4b:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t addr;
  addr_t n;

  argaddr(0, &n);
ffff800000109c4f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffff800000109c53:	48 89 c6             	mov    %rax,%rsi
ffff800000109c56:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109c5b:	48 b8 82 85 10 00 00 	movabs $0xffff800000108582,%rax
ffff800000109c62:	80 ff ff 
ffff800000109c65:	ff d0                	call   *%rax
  addr = proc->sz;
ffff800000109c67:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109c6e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109c72:	48 8b 00             	mov    (%rax),%rax
ffff800000109c75:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(growproc(n) < 0)
ffff800000109c79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000109c7d:	48 89 c7             	mov    %rax,%rdi
ffff800000109c80:	48 b8 3f 64 10 00 00 	movabs $0xffff80000010643f,%rax
ffff800000109c87:	80 ff ff 
ffff800000109c8a:	ff d0                	call   *%rax
ffff800000109c8c:	85 c0                	test   %eax,%eax
ffff800000109c8e:	79 09                	jns    ffff800000109c99 <sys_sbrk+0x52>
    return -1;
ffff800000109c90:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffff800000109c97:	eb 04                	jmp    ffff800000109c9d <sys_sbrk+0x56>
  return addr;
ffff800000109c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000109c9d:	c9                   	leave
ffff800000109c9e:	c3                   	ret

ffff800000109c9f <sys_sleep>:

int
sys_sleep(void)
{
ffff800000109c9f:	55                   	push   %rbp
ffff800000109ca0:	48 89 e5             	mov    %rsp,%rbp
ffff800000109ca3:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
ffff800000109ca7:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffff800000109cab:	48 89 c6             	mov    %rax,%rsi
ffff800000109cae:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000109cb3:	48 b8 53 85 10 00 00 	movabs $0xffff800000108553,%rax
ffff800000109cba:	80 ff ff 
ffff800000109cbd:	ff d0                	call   *%rax
ffff800000109cbf:	85 c0                	test   %eax,%eax
ffff800000109cc1:	79 0a                	jns    ffff800000109ccd <sys_sleep+0x2e>
    return -1;
ffff800000109cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109cc8:	e9 b6 00 00 00       	jmp    ffff800000109d83 <sys_sleep+0xe4>
  acquire(&tickslock);
ffff800000109ccd:	48 b8 e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rax
ffff800000109cd4:	80 ff ff 
ffff800000109cd7:	48 89 c7             	mov    %rax,%rdi
ffff800000109cda:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000109ce1:	80 ff ff 
ffff800000109ce4:	ff d0                	call   *%rax
  ticks0 = ticks;
ffff800000109ce6:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff800000109ced:	80 ff ff 
ffff800000109cf0:	8b 00                	mov    (%rax),%eax
ffff800000109cf2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while(ticks - ticks0 < n){
ffff800000109cf5:	eb 58                	jmp    ffff800000109d4f <sys_sleep+0xb0>
    if(proc->killed){
ffff800000109cf7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff800000109cfe:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff800000109d02:	8b 40 40             	mov    0x40(%rax),%eax
ffff800000109d05:	85 c0                	test   %eax,%eax
ffff800000109d07:	74 20                	je     ffff800000109d29 <sys_sleep+0x8a>
      release(&tickslock);
ffff800000109d09:	48 b8 e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rax
ffff800000109d10:	80 ff ff 
ffff800000109d13:	48 89 c7             	mov    %rax,%rdi
ffff800000109d16:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000109d1d:	80 ff ff 
ffff800000109d20:	ff d0                	call   *%rax
      return -1;
ffff800000109d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff800000109d27:	eb 5a                	jmp    ffff800000109d83 <sys_sleep+0xe4>
    }
    sleep(&ticks, &tickslock);
ffff800000109d29:	48 ba e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rdx
ffff800000109d30:	80 ff ff 
ffff800000109d33:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff800000109d3a:	80 ff ff 
ffff800000109d3d:	48 89 d6             	mov    %rdx,%rsi
ffff800000109d40:	48 89 c7             	mov    %rax,%rdi
ffff800000109d43:	48 b8 5f 6e 10 00 00 	movabs $0xffff800000106e5f,%rax
ffff800000109d4a:	80 ff ff 
ffff800000109d4d:	ff d0                	call   *%rax
  while(ticks - ticks0 < n){
ffff800000109d4f:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff800000109d56:	80 ff ff 
ffff800000109d59:	8b 00                	mov    (%rax),%eax
ffff800000109d5b:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff800000109d5e:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff800000109d61:	39 d0                	cmp    %edx,%eax
ffff800000109d63:	72 92                	jb     ffff800000109cf7 <sys_sleep+0x58>
  }
  release(&tickslock);
ffff800000109d65:	48 b8 e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rax
ffff800000109d6c:	80 ff ff 
ffff800000109d6f:	48 89 c7             	mov    %rax,%rdi
ffff800000109d72:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000109d79:	80 ff ff 
ffff800000109d7c:	ff d0                	call   *%rax
  return 0;
ffff800000109d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff800000109d83:	c9                   	leave
ffff800000109d84:	c3                   	ret

ffff800000109d85 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
ffff800000109d85:	55                   	push   %rbp
ffff800000109d86:	48 89 e5             	mov    %rsp,%rbp
ffff800000109d89:	48 83 ec 10          	sub    $0x10,%rsp
  uint xticks;

  acquire(&tickslock);
ffff800000109d8d:	48 b8 e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rax
ffff800000109d94:	80 ff ff 
ffff800000109d97:	48 89 c7             	mov    %rax,%rdi
ffff800000109d9a:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff800000109da1:	80 ff ff 
ffff800000109da4:	ff d0                	call   *%rax
  xticks = ticks;
ffff800000109da6:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff800000109dad:	80 ff ff 
ffff800000109db0:	8b 00                	mov    (%rax),%eax
ffff800000109db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&tickslock);
ffff800000109db5:	48 b8 e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rax
ffff800000109dbc:	80 ff ff 
ffff800000109dbf:	48 89 c7             	mov    %rax,%rdi
ffff800000109dc2:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff800000109dc9:	80 ff ff 
ffff800000109dcc:	ff d0                	call   *%rax
  return xticks;
ffff800000109dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffff800000109dd1:	c9                   	leave
ffff800000109dd2:	c3                   	ret

ffff800000109dd3 <alltraps>:
# vectors.S sends all traps here.
.global alltraps
alltraps:
  # Build trap frame.
  pushq   %r15
ffff800000109dd3:	41 57                	push   %r15
  pushq   %r14
ffff800000109dd5:	41 56                	push   %r14
  pushq   %r13
ffff800000109dd7:	41 55                	push   %r13
  pushq   %r12
ffff800000109dd9:	41 54                	push   %r12
  pushq   %r11
ffff800000109ddb:	41 53                	push   %r11
  pushq   %r10
ffff800000109ddd:	41 52                	push   %r10
  pushq   %r9
ffff800000109ddf:	41 51                	push   %r9
  pushq   %r8
ffff800000109de1:	41 50                	push   %r8
  pushq   %rdi
ffff800000109de3:	57                   	push   %rdi
  pushq   %rsi
ffff800000109de4:	56                   	push   %rsi
  pushq   %rbp
ffff800000109de5:	55                   	push   %rbp
  pushq   %rdx
ffff800000109de6:	52                   	push   %rdx
  pushq   %rcx
ffff800000109de7:	51                   	push   %rcx
  pushq   %rbx
ffff800000109de8:	53                   	push   %rbx
  pushq   %rax
ffff800000109de9:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff800000109dea:	48 89 e7             	mov    %rsp,%rdi
  callq   trap
ffff800000109ded:	e8 c3 03 00 00       	call   ffff80000010a1b5 <trap>

ffff800000109df2 <trapret>:
# Return falls through to trapret...

.global trapret
trapret:
  popq    %rax
ffff800000109df2:	58                   	pop    %rax
  popq    %rbx
ffff800000109df3:	5b                   	pop    %rbx
  popq    %rcx
ffff800000109df4:	59                   	pop    %rcx
  popq    %rdx
ffff800000109df5:	5a                   	pop    %rdx
  popq    %rbp
ffff800000109df6:	5d                   	pop    %rbp
  popq    %rsi
ffff800000109df7:	5e                   	pop    %rsi
  popq    %rdi
ffff800000109df8:	5f                   	pop    %rdi
  popq    %r8
ffff800000109df9:	41 58                	pop    %r8
  popq    %r9
ffff800000109dfb:	41 59                	pop    %r9
  popq    %r10
ffff800000109dfd:	41 5a                	pop    %r10
  popq    %r11
ffff800000109dff:	41 5b                	pop    %r11
  popq    %r12
ffff800000109e01:	41 5c                	pop    %r12
  popq    %r13
ffff800000109e03:	41 5d                	pop    %r13
  popq    %r14
ffff800000109e05:	41 5e                	pop    %r14
  popq    %r15
ffff800000109e07:	41 5f                	pop    %r15

  addq    $16, %rsp  # discard trapnum and errorcode
ffff800000109e09:	48 83 c4 10          	add    $0x10,%rsp
  iretq
ffff800000109e0d:	48 cf                	iretq

ffff800000109e0f <syscall_entry>:
.global syscall_entry
syscall_entry:
  # switch to kernel stack. With the syscall instruction,
  # this is a kernel resposibility
  # store %rsp on the top of proc->kstack,
  movq    %rax, %fs:(0)      # save %rax above __thread vars
ffff800000109e0f:	64 48 89 04 25 00 00 	mov    %rax,%fs:0x0
ffff800000109e16:	00 00 
  movq    %fs:(-8), %rax     # %fs:(-8) is proc (the last __thread)
ffff800000109e18:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffff800000109e1f:	ff ff 
  movq    0x10(%rax), %rax   # get proc->kstack (see struct proc)
ffff800000109e21:	48 8b 40 10          	mov    0x10(%rax),%rax
  addq    $(4096-16), %rax   # %rax points to tf->rsp
ffff800000109e25:	48 05 f0 0f 00 00    	add    $0xff0,%rax
  movq    %rsp, (%rax)       # save user rsp to tf->rsp
ffff800000109e2b:	48 89 20             	mov    %rsp,(%rax)
  movq    %rax, %rsp         # switch to the kstack
ffff800000109e2e:	48 89 c4             	mov    %rax,%rsp
  movq    %fs:(0), %rax      # restore %rax
ffff800000109e31:	64 48 8b 04 25 00 00 	mov    %fs:0x0,%rax
ffff800000109e38:	00 00 

  pushq   %r11         # rflags
ffff800000109e3a:	41 53                	push   %r11
  pushq   $0           # cs is ignored
ffff800000109e3c:	6a 00                	push   $0x0
  pushq   %rcx         # rip (next user insn)
ffff800000109e3e:	51                   	push   %rcx

  pushq   $0           # err
ffff800000109e3f:	6a 00                	push   $0x0
  pushq   $0           # trapno ignored
ffff800000109e41:	6a 00                	push   $0x0

  pushq   %r15
ffff800000109e43:	41 57                	push   %r15
  pushq   %r14
ffff800000109e45:	41 56                	push   %r14
  pushq   %r13
ffff800000109e47:	41 55                	push   %r13
  pushq   %r12
ffff800000109e49:	41 54                	push   %r12
  pushq   %r11
ffff800000109e4b:	41 53                	push   %r11
  pushq   %r10
ffff800000109e4d:	41 52                	push   %r10
  pushq   %r9
ffff800000109e4f:	41 51                	push   %r9
  pushq   %r8
ffff800000109e51:	41 50                	push   %r8
  pushq   %rdi
ffff800000109e53:	57                   	push   %rdi
  pushq   %rsi
ffff800000109e54:	56                   	push   %rsi
  pushq   %rbp
ffff800000109e55:	55                   	push   %rbp
  pushq   %rdx
ffff800000109e56:	52                   	push   %rdx
  pushq   %rcx
ffff800000109e57:	51                   	push   %rcx
  pushq   %rbx
ffff800000109e58:	53                   	push   %rbx
  pushq   %rax
ffff800000109e59:	50                   	push   %rax

  movq    %rsp, %rdi  # frame in arg1
ffff800000109e5a:	48 89 e7             	mov    %rsp,%rdi
  callq   syscall
ffff800000109e5d:	e8 24 e8 ff ff       	call   ffff800000108686 <syscall>

ffff800000109e62 <syscall_trapret>:

.global syscall_trapret
syscall_trapret:
syscall_sigtrapret:

  popq    %rax
ffff800000109e62:	58                   	pop    %rax
  popq    %rbx
ffff800000109e63:	5b                   	pop    %rbx
  popq    %rcx
ffff800000109e64:	59                   	pop    %rcx
  popq    %rdx
ffff800000109e65:	5a                   	pop    %rdx
  popq    %rbp
ffff800000109e66:	5d                   	pop    %rbp
  popq    %rsi
ffff800000109e67:	5e                   	pop    %rsi
  popq    %rdi
ffff800000109e68:	5f                   	pop    %rdi
  popq    %r8
ffff800000109e69:	41 58                	pop    %r8
  popq    %r9
ffff800000109e6b:	41 59                	pop    %r9
  popq    %r10
ffff800000109e6d:	41 5a                	pop    %r10
  popq    %r11
ffff800000109e6f:	41 5b                	pop    %r11
  popq    %r12
ffff800000109e71:	41 5c                	pop    %r12
  popq    %r13
ffff800000109e73:	41 5d                	pop    %r13
  popq    %r14
ffff800000109e75:	41 5e                	pop    %r14
  popq    %r15
ffff800000109e77:	41 5f                	pop    %r15

  addq    $40, %rsp  # discard trapnum, errorcode, rip, cs and rflags
ffff800000109e79:	48 83 c4 28          	add    $0x28,%rsp

  # to make sure we don't get any interrupts on the user stack while in
  # supervisor mode. this is actually slightly unsafe still,
  # since some interrupts are nonmaskable.
  # See https://www.felixcloutier.com/x86/sysret
  cli
ffff800000109e7d:	fa                   	cli
  movq    (%rsp), %rsp  # restore the user stack
ffff800000109e7e:	48 8b 24 24          	mov    (%rsp),%rsp
  sysretq
ffff800000109e82:	48 0f 07             	sysretq

ffff800000109e85 <inb>:
{
ffff800000109e85:	55                   	push   %rbp
ffff800000109e86:	48 89 e5             	mov    %rsp,%rbp
ffff800000109e89:	48 83 ec 18          	sub    $0x18,%rsp
ffff800000109e8d:	89 f8                	mov    %edi,%eax
ffff800000109e8f:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff800000109e93:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000109e97:	89 c2                	mov    %eax,%edx
ffff800000109e99:	ec                   	in     (%dx),%al
ffff800000109e9a:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff800000109e9d:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff800000109ea1:	c9                   	leave
ffff800000109ea2:	c3                   	ret

ffff800000109ea3 <outb>:
{
ffff800000109ea3:	55                   	push   %rbp
ffff800000109ea4:	48 89 e5             	mov    %rsp,%rbp
ffff800000109ea7:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000109eab:	89 fa                	mov    %edi,%edx
ffff800000109ead:	89 f0                	mov    %esi,%eax
ffff800000109eaf:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff800000109eb3:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff800000109eb6:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000109eba:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff800000109ebe:	ee                   	out    %al,(%dx)
}
ffff800000109ebf:	90                   	nop
ffff800000109ec0:	c9                   	leave
ffff800000109ec1:	c3                   	ret

ffff800000109ec2 <lidt>:
{
ffff800000109ec2:	55                   	push   %rbp
ffff800000109ec3:	48 89 e5             	mov    %rsp,%rbp
ffff800000109ec6:	48 83 ec 30          	sub    $0x30,%rsp
ffff800000109eca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000109ece:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff800000109ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000109ed5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff800000109ed9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff800000109edc:	83 e8 01             	sub    $0x1,%eax
ffff800000109edf:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff800000109ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109ee7:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff800000109eeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109eef:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000109ef3:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff800000109ef7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109efb:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000109eff:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff800000109f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109f07:	48 c1 e8 30          	shr    $0x30,%rax
ffff800000109f0b:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lidt (%0)" : : "r" (pd));
ffff800000109f0f:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff800000109f13:	0f 01 18             	lidt   (%rax)
}
ffff800000109f16:	90                   	nop
ffff800000109f17:	c9                   	leave
ffff800000109f18:	c3                   	ret

ffff800000109f19 <rcr2>:

static inline addr_t
rcr2(void)
{
ffff800000109f19:	55                   	push   %rbp
ffff800000109f1a:	48 89 e5             	mov    %rsp,%rbp
ffff800000109f1d:	48 83 ec 10          	sub    $0x10,%rsp
  addr_t val;
  asm volatile("mov %%cr2,%0" : "=r" (val));
ffff800000109f21:	0f 20 d0             	mov    %cr2,%rax
ffff800000109f24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return val;
ffff800000109f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffff800000109f2c:	c9                   	leave
ffff800000109f2d:	c3                   	ret

ffff800000109f2e <mkgate>:
struct spinlock tickslock;
uint ticks;

static void
mkgate(uint *idt, uint n, addr_t kva, uint pl)
{
ffff800000109f2e:	55                   	push   %rbp
ffff800000109f2f:	48 89 e5             	mov    %rsp,%rbp
ffff800000109f32:	48 83 ec 28          	sub    $0x28,%rsp
ffff800000109f36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000109f3a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffff800000109f3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000109f41:	89 4d e0             	mov    %ecx,-0x20(%rbp)
  uint64 addr = (uint64) kva;
ffff800000109f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000109f48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  n *= 4;
ffff800000109f4c:	c1 65 e4 02          	shll   $0x2,-0x1c(%rbp)
  idt[n+0] = (addr & 0xFFFF) | (KERNEL_CS << 16);
ffff800000109f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109f54:	0f b7 d0             	movzwl %ax,%edx
ffff800000109f57:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109f5a:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109f61:	00 
ffff800000109f62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f66:	48 01 c8             	add    %rcx,%rax
ffff800000109f69:	81 ca 00 00 08 00    	or     $0x80000,%edx
ffff800000109f6f:	89 10                	mov    %edx,(%rax)
  idt[n+1] = (addr & 0xFFFF0000) | 0x8E00 | ((pl & 3) << 13);
ffff800000109f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109f75:	66 b8 00 00          	mov    $0x0,%ax
ffff800000109f79:	89 c2                	mov    %eax,%edx
ffff800000109f7b:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000109f7e:	c1 e0 0d             	shl    $0xd,%eax
ffff800000109f81:	25 00 60 00 00       	and    $0x6000,%eax
ffff800000109f86:	09 c2                	or     %eax,%edx
ffff800000109f88:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109f8b:	83 c0 01             	add    $0x1,%eax
ffff800000109f8e:	89 c0                	mov    %eax,%eax
ffff800000109f90:	48 8d 0c 85 00 00 00 	lea    0x0(,%rax,4),%rcx
ffff800000109f97:	00 
ffff800000109f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109f9c:	48 01 c8             	add    %rcx,%rax
ffff800000109f9f:	80 ce 8e             	or     $0x8e,%dh
ffff800000109fa2:	89 10                	mov    %edx,(%rax)
  idt[n+2] = addr >> 32;
ffff800000109fa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000109fa8:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000109fac:	48 89 c1             	mov    %rax,%rcx
ffff800000109faf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109fb2:	83 c0 02             	add    $0x2,%eax
ffff800000109fb5:	89 c0                	mov    %eax,%eax
ffff800000109fb7:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000109fbe:	00 
ffff800000109fbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109fc3:	48 01 d0             	add    %rdx,%rax
ffff800000109fc6:	89 ca                	mov    %ecx,%edx
ffff800000109fc8:	89 10                	mov    %edx,(%rax)
  idt[n+3] = 0;
ffff800000109fca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000109fcd:	83 c0 03             	add    $0x3,%eax
ffff800000109fd0:	89 c0                	mov    %eax,%eax
ffff800000109fd2:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000109fd9:	00 
ffff800000109fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000109fde:	48 01 d0             	add    %rdx,%rax
ffff800000109fe1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
ffff800000109fe7:	90                   	nop
ffff800000109fe8:	c9                   	leave
ffff800000109fe9:	c3                   	ret

ffff800000109fea <idtinit>:

void idtinit(void)
{
ffff800000109fea:	55                   	push   %rbp
ffff800000109feb:	48 89 e5             	mov    %rsp,%rbp
  lidt((void*) idt, PGSIZE);
ffff800000109fee:	48 b8 c0 5c 12 00 00 	movabs $0xffff800000125cc0,%rax
ffff800000109ff5:	80 ff ff 
ffff800000109ff8:	48 8b 00             	mov    (%rax),%rax
ffff800000109ffb:	be 00 10 00 00       	mov    $0x1000,%esi
ffff80000010a000:	48 89 c7             	mov    %rax,%rdi
ffff80000010a003:	48 b8 c2 9e 10 00 00 	movabs $0xffff800000109ec2,%rax
ffff80000010a00a:	80 ff ff 
ffff80000010a00d:	ff d0                	call   *%rax
}
ffff80000010a00f:	90                   	nop
ffff80000010a010:	5d                   	pop    %rbp
ffff80000010a011:	c3                   	ret

ffff80000010a012 <tvinit>:


void tvinit(void)
{
ffff80000010a012:	55                   	push   %rbp
ffff80000010a013:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a016:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  idt = (uint*) kalloc();
ffff80000010a01a:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010a021:	80 ff ff 
ffff80000010a024:	ff d0                	call   *%rax
ffff80000010a026:	48 ba c0 5c 12 00 00 	movabs $0xffff800000125cc0,%rdx
ffff80000010a02d:	80 ff ff 
ffff80000010a030:	48 89 02             	mov    %rax,(%rdx)
  memset(idt, 0, PGSIZE);
ffff80000010a033:	48 b8 c0 5c 12 00 00 	movabs $0xffff800000125cc0,%rax
ffff80000010a03a:	80 ff ff 
ffff80000010a03d:	48 8b 00             	mov    (%rax),%rax
ffff80000010a040:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010a045:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a04a:	48 89 c7             	mov    %rax,%rdi
ffff80000010a04d:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010a054:	80 ff ff 
ffff80000010a057:	ff d0                	call   *%rax

  for (n = 0; n < 256; n++)
ffff80000010a059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010a060:	eb 3b                	jmp    ffff80000010a09d <tvinit+0x8b>
    mkgate(idt, n, vectors[n], 0);
ffff80000010a062:	48 ba 70 d6 10 00 00 	movabs $0xffff80000010d670,%rdx
ffff80000010a069:	80 ff ff 
ffff80000010a06c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010a06f:	48 98                	cltq
ffff80000010a071:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
ffff80000010a075:	8b 75 fc             	mov    -0x4(%rbp),%esi
ffff80000010a078:	48 b8 c0 5c 12 00 00 	movabs $0xffff800000125cc0,%rax
ffff80000010a07f:	80 ff ff 
ffff80000010a082:	48 8b 00             	mov    (%rax),%rax
ffff80000010a085:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff80000010a08a:	48 89 c7             	mov    %rax,%rdi
ffff80000010a08d:	48 b8 2e 9f 10 00 00 	movabs $0xffff800000109f2e,%rax
ffff80000010a094:	80 ff ff 
ffff80000010a097:	ff d0                	call   *%rax
  for (n = 0; n < 256; n++)
ffff80000010a099:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010a09d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff80000010a0a4:	7e bc                	jle    ffff80000010a062 <tvinit+0x50>
}
ffff80000010a0a6:	90                   	nop
ffff80000010a0a7:	90                   	nop
ffff80000010a0a8:	c9                   	leave
ffff80000010a0a9:	c3                   	ret

ffff80000010a0aa <from_bcd>:

int from_bcd(int code) {
ffff80000010a0aa:	55                   	push   %rbp
ffff80000010a0ab:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a0ae:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010a0b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return (code>>4)*10+(code&0xf);
ffff80000010a0b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010a0b8:	c1 f8 04             	sar    $0x4,%eax
ffff80000010a0bb:	89 c2                	mov    %eax,%edx
ffff80000010a0bd:	89 d0                	mov    %edx,%eax
ffff80000010a0bf:	c1 e0 02             	shl    $0x2,%eax
ffff80000010a0c2:	01 d0                	add    %edx,%eax
ffff80000010a0c4:	01 c0                	add    %eax,%eax
ffff80000010a0c6:	89 c2                	mov    %eax,%edx
ffff80000010a0c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010a0cb:	83 e0 0f             	and    $0xf,%eax
ffff80000010a0ce:	01 d0                	add    %edx,%eax
}
ffff80000010a0d0:	c9                   	leave
ffff80000010a0d1:	c3                   	ret

ffff80000010a0d2 <print_rtc_time>:

void print_rtc_time() {
ffff80000010a0d2:	55                   	push   %rbp
ffff80000010a0d3:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a0d6:	48 83 ec 10          	sub    $0x10,%rsp
      outb(0x70, 0x00);  // Request the seconds
ffff80000010a0da:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a0df:	bf 70 00 00 00       	mov    $0x70,%edi
ffff80000010a0e4:	48 b8 a3 9e 10 00 00 	movabs $0xffff800000109ea3,%rax
ffff80000010a0eb:	80 ff ff 
ffff80000010a0ee:	ff d0                	call   *%rax
      int secs = from_bcd(inb(0x71));
ffff80000010a0f0:	bf 71 00 00 00       	mov    $0x71,%edi
ffff80000010a0f5:	48 b8 85 9e 10 00 00 	movabs $0xffff800000109e85,%rax
ffff80000010a0fc:	80 ff ff 
ffff80000010a0ff:	ff d0                	call   *%rax
ffff80000010a101:	0f b6 c0             	movzbl %al,%eax
ffff80000010a104:	89 c7                	mov    %eax,%edi
ffff80000010a106:	48 b8 aa a0 10 00 00 	movabs $0xffff80000010a0aa,%rax
ffff80000010a10d:	80 ff ff 
ffff80000010a110:	ff d0                	call   *%rax
ffff80000010a112:	89 45 fc             	mov    %eax,-0x4(%rbp)
      outb(0x70, 0x02);  // Request the mins
ffff80000010a115:	be 02 00 00 00       	mov    $0x2,%esi
ffff80000010a11a:	bf 70 00 00 00       	mov    $0x70,%edi
ffff80000010a11f:	48 b8 a3 9e 10 00 00 	movabs $0xffff800000109ea3,%rax
ffff80000010a126:	80 ff ff 
ffff80000010a129:	ff d0                	call   *%rax
      int mins = from_bcd(inb(0x71));
ffff80000010a12b:	bf 71 00 00 00       	mov    $0x71,%edi
ffff80000010a130:	48 b8 85 9e 10 00 00 	movabs $0xffff800000109e85,%rax
ffff80000010a137:	80 ff ff 
ffff80000010a13a:	ff d0                	call   *%rax
ffff80000010a13c:	0f b6 c0             	movzbl %al,%eax
ffff80000010a13f:	89 c7                	mov    %eax,%edi
ffff80000010a141:	48 b8 aa a0 10 00 00 	movabs $0xffff80000010a0aa,%rax
ffff80000010a148:	80 ff ff 
ffff80000010a14b:	ff d0                	call   *%rax
ffff80000010a14d:	89 45 f8             	mov    %eax,-0x8(%rbp)
      outb(0x70, 0x04);  // Request the hours
ffff80000010a150:	be 04 00 00 00       	mov    $0x4,%esi
ffff80000010a155:	bf 70 00 00 00       	mov    $0x70,%edi
ffff80000010a15a:	48 b8 a3 9e 10 00 00 	movabs $0xffff800000109ea3,%rax
ffff80000010a161:	80 ff ff 
ffff80000010a164:	ff d0                	call   *%rax
      int hours = from_bcd(inb(0x71));
ffff80000010a166:	bf 71 00 00 00       	mov    $0x71,%edi
ffff80000010a16b:	48 b8 85 9e 10 00 00 	movabs $0xffff800000109e85,%rax
ffff80000010a172:	80 ff ff 
ffff80000010a175:	ff d0                	call   *%rax
ffff80000010a177:	0f b6 c0             	movzbl %al,%eax
ffff80000010a17a:	89 c7                	mov    %eax,%edi
ffff80000010a17c:	48 b8 aa a0 10 00 00 	movabs $0xffff80000010a0aa,%rax
ffff80000010a183:	80 ff ff 
ffff80000010a186:	ff d0                	call   *%rax
ffff80000010a188:	89 45 f4             	mov    %eax,-0xc(%rbp)

      cprintf("%d:%d:%d\n",hours,mins,secs);
ffff80000010a18b:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffff80000010a18e:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010a191:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010a194:	48 bf 10 cd 10 00 00 	movabs $0xffff80000010cd10,%rdi
ffff80000010a19b:	80 ff ff 
ffff80000010a19e:	89 c6                	mov    %eax,%esi
ffff80000010a1a0:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a1a5:	49 b8 04 08 10 00 00 	movabs $0xffff800000100804,%r8
ffff80000010a1ac:	80 ff ff 
ffff80000010a1af:	41 ff d0             	call   *%r8
}
ffff80000010a1b2:	90                   	nop
ffff80000010a1b3:	c9                   	leave
ffff80000010a1b4:	c3                   	ret

ffff80000010a1b5 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
ffff80000010a1b5:	55                   	push   %rbp
ffff80000010a1b6:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a1b9:	41 54                	push   %r12
ffff80000010a1bb:	53                   	push   %rbx
ffff80000010a1bc:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010a1c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  switch(tf->trapno){
ffff80000010a1c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a1c8:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff80000010a1cc:	48 83 f8 3f          	cmp    $0x3f,%rax
ffff80000010a1d0:	0f 84 59 01 00 00    	je     ffff80000010a32f <trap+0x17a>
ffff80000010a1d6:	48 83 f8 3f          	cmp    $0x3f,%rax
ffff80000010a1da:	0f 87 a9 01 00 00    	ja     ffff80000010a389 <trap+0x1d4>
ffff80000010a1e0:	48 83 f8 2f          	cmp    $0x2f,%rax
ffff80000010a1e4:	0f 84 0f 03 00 00    	je     ffff80000010a4f9 <trap+0x344>
ffff80000010a1ea:	48 83 f8 2f          	cmp    $0x2f,%rax
ffff80000010a1ee:	0f 87 95 01 00 00    	ja     ffff80000010a389 <trap+0x1d4>
ffff80000010a1f4:	48 83 f8 2e          	cmp    $0x2e,%rax
ffff80000010a1f8:	0f 84 da 00 00 00    	je     ffff80000010a2d8 <trap+0x123>
ffff80000010a1fe:	48 83 f8 2e          	cmp    $0x2e,%rax
ffff80000010a202:	0f 87 81 01 00 00    	ja     ffff80000010a389 <trap+0x1d4>
ffff80000010a208:	48 83 f8 27          	cmp    $0x27,%rax
ffff80000010a20c:	0f 84 1d 01 00 00    	je     ffff80000010a32f <trap+0x17a>
ffff80000010a212:	48 83 f8 27          	cmp    $0x27,%rax
ffff80000010a216:	0f 87 6d 01 00 00    	ja     ffff80000010a389 <trap+0x1d4>
ffff80000010a21c:	48 83 f8 24          	cmp    $0x24,%rax
ffff80000010a220:	0f 84 ec 00 00 00    	je     ffff80000010a312 <trap+0x15d>
ffff80000010a226:	48 83 f8 24          	cmp    $0x24,%rax
ffff80000010a22a:	0f 87 59 01 00 00    	ja     ffff80000010a389 <trap+0x1d4>
ffff80000010a230:	48 83 f8 20          	cmp    $0x20,%rax
ffff80000010a234:	74 0f                	je     ffff80000010a245 <trap+0x90>
ffff80000010a236:	48 83 f8 21          	cmp    $0x21,%rax
ffff80000010a23a:	0f 84 b5 00 00 00    	je     ffff80000010a2f5 <trap+0x140>
ffff80000010a240:	e9 44 01 00 00       	jmp    ffff80000010a389 <trap+0x1d4>
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
ffff80000010a245:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff80000010a24c:	80 ff ff 
ffff80000010a24f:	ff d0                	call   *%rax
ffff80000010a251:	85 c0                	test   %eax,%eax
ffff80000010a253:	75 72                	jne    ffff80000010a2c7 <trap+0x112>
      acquire(&tickslock);
ffff80000010a255:	48 b8 e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rax
ffff80000010a25c:	80 ff ff 
ffff80000010a25f:	48 89 c7             	mov    %rax,%rdi
ffff80000010a262:	48 b8 fd 7b 10 00 00 	movabs $0xffff800000107bfd,%rax
ffff80000010a269:	80 ff ff 
ffff80000010a26c:	ff d0                	call   *%rax
      ticks++;
ffff80000010a26e:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff80000010a275:	80 ff ff 
ffff80000010a278:	8b 00                	mov    (%rax),%eax
ffff80000010a27a:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010a27d:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff80000010a284:	80 ff ff 
ffff80000010a287:	89 10                	mov    %edx,(%rax)
      wakeup(&ticks);
ffff80000010a289:	48 b8 48 5d 12 00 00 	movabs $0xffff800000125d48,%rax
ffff80000010a290:	80 ff ff 
ffff80000010a293:	48 89 c7             	mov    %rax,%rdi
ffff80000010a296:	48 b8 d4 6f 10 00 00 	movabs $0xffff800000106fd4,%rax
ffff80000010a29d:	80 ff ff 
ffff80000010a2a0:	ff d0                	call   *%rax
      release(&tickslock);
ffff80000010a2a2:	48 b8 e0 5c 12 00 00 	movabs $0xffff800000125ce0,%rax
ffff80000010a2a9:	80 ff ff 
ffff80000010a2ac:	48 89 c7             	mov    %rax,%rdi
ffff80000010a2af:	48 b8 9c 7c 10 00 00 	movabs $0xffff800000107c9c,%rax
ffff80000010a2b6:	80 ff ff 
ffff80000010a2b9:	ff d0                	call   *%rax
      check_alarms();
ffff80000010a2bb:	48 b8 7e 75 10 00 00 	movabs $0xffff80000010757e,%rax
ffff80000010a2c2:	80 ff ff 
ffff80000010a2c5:	ff d0                	call   *%rax
    }
    lapiceoi();
ffff80000010a2c7:	48 b8 90 47 10 00 00 	movabs $0xffff800000104790,%rax
ffff80000010a2ce:	80 ff ff 
ffff80000010a2d1:	ff d0                	call   *%rax
    break;
ffff80000010a2d3:	e9 22 02 00 00       	jmp    ffff80000010a4fa <trap+0x345>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
ffff80000010a2d8:	48 b8 89 3b 10 00 00 	movabs $0xffff800000103b89,%rax
ffff80000010a2df:	80 ff ff 
ffff80000010a2e2:	ff d0                	call   *%rax
    lapiceoi();
ffff80000010a2e4:	48 b8 90 47 10 00 00 	movabs $0xffff800000104790,%rax
ffff80000010a2eb:	80 ff ff 
ffff80000010a2ee:	ff d0                	call   *%rax
    break;
ffff80000010a2f0:	e9 05 02 00 00       	jmp    ffff80000010a4fa <trap+0x345>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
ffff80000010a2f5:	48 b8 46 44 10 00 00 	movabs $0xffff800000104446,%rax
ffff80000010a2fc:	80 ff ff 
ffff80000010a2ff:	ff d0                	call   *%rax
    lapiceoi();
ffff80000010a301:	48 b8 90 47 10 00 00 	movabs $0xffff800000104790,%rax
ffff80000010a308:	80 ff ff 
ffff80000010a30b:	ff d0                	call   *%rax
    break;
ffff80000010a30d:	e9 e8 01 00 00       	jmp    ffff80000010a4fa <trap+0x345>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
ffff80000010a312:	48 b8 22 a8 10 00 00 	movabs $0xffff80000010a822,%rax
ffff80000010a319:	80 ff ff 
ffff80000010a31c:	ff d0                	call   *%rax
    lapiceoi();
ffff80000010a31e:	48 b8 90 47 10 00 00 	movabs $0xffff800000104790,%rax
ffff80000010a325:	80 ff ff 
ffff80000010a328:	ff d0                	call   *%rax
    break;
ffff80000010a32a:	e9 cb 01 00 00       	jmp    ffff80000010a4fa <trap+0x345>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %p:%p\n",
ffff80000010a32f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a333:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff80000010a33a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a33e:	48 8b 98 90 00 00 00 	mov    0x90(%rax),%rbx
ffff80000010a345:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff80000010a34c:	80 ff ff 
ffff80000010a34f:	ff d0                	call   *%rax
ffff80000010a351:	89 c6                	mov    %eax,%esi
ffff80000010a353:	48 b8 20 cd 10 00 00 	movabs $0xffff80000010cd20,%rax
ffff80000010a35a:	80 ff ff 
ffff80000010a35d:	4c 89 e1             	mov    %r12,%rcx
ffff80000010a360:	48 89 da             	mov    %rbx,%rdx
ffff80000010a363:	48 89 c7             	mov    %rax,%rdi
ffff80000010a366:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a36b:	49 b8 04 08 10 00 00 	movabs $0xffff800000100804,%r8
ffff80000010a372:	80 ff ff 
ffff80000010a375:	41 ff d0             	call   *%r8
            cpunum(), tf->cs, tf->rip);
    lapiceoi();
ffff80000010a378:	48 b8 90 47 10 00 00 	movabs $0xffff800000104790,%rax
ffff80000010a37f:	80 ff ff 
ffff80000010a382:	ff d0                	call   *%rax
    break;
ffff80000010a384:	e9 71 01 00 00       	jmp    ffff80000010a4fa <trap+0x345>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
ffff80000010a389:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a390:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a394:	48 85 c0             	test   %rax,%rax
ffff80000010a397:	74 17                	je     ffff80000010a3b0 <trap+0x1fb>
ffff80000010a399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a39d:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a3a4:	83 e0 03             	and    $0x3,%eax
ffff80000010a3a7:	48 85 c0             	test   %rax,%rax
ffff80000010a3aa:	0f 85 ac 00 00 00    	jne    ffff80000010a45c <trap+0x2a7>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d rip %p (cr2=0x%p)\n",
ffff80000010a3b0:	48 b8 19 9f 10 00 00 	movabs $0xffff800000109f19,%rax
ffff80000010a3b7:	80 ff ff 
ffff80000010a3ba:	ff d0                	call   *%rax
ffff80000010a3bc:	49 89 c4             	mov    %rax,%r12
ffff80000010a3bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a3c3:	48 8b 98 88 00 00 00 	mov    0x88(%rax),%rbx
ffff80000010a3ca:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff80000010a3d1:	80 ff ff 
ffff80000010a3d4:	ff d0                	call   *%rax
ffff80000010a3d6:	89 c2                	mov    %eax,%edx
ffff80000010a3d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a3dc:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff80000010a3e0:	48 bf 48 cd 10 00 00 	movabs $0xffff80000010cd48,%rdi
ffff80000010a3e7:	80 ff ff 
ffff80000010a3ea:	4d 89 e0             	mov    %r12,%r8
ffff80000010a3ed:	48 89 d9             	mov    %rbx,%rcx
ffff80000010a3f0:	48 89 c6             	mov    %rax,%rsi
ffff80000010a3f3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a3f8:	49 b9 04 08 10 00 00 	movabs $0xffff800000100804,%r9
ffff80000010a3ff:	80 ff ff 
ffff80000010a402:	41 ff d1             	call   *%r9
              tf->trapno, cpunum(), tf->rip, rcr2());
      if (proc)
ffff80000010a405:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a40c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a410:	48 85 c0             	test   %rax,%rax
ffff80000010a413:	74 2e                	je     ffff80000010a443 <trap+0x28e>
        cprintf("proc id: %d\n", proc->pid);
ffff80000010a415:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a41c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a420:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010a423:	48 ba 7a cd 10 00 00 	movabs $0xffff80000010cd7a,%rdx
ffff80000010a42a:	80 ff ff 
ffff80000010a42d:	89 c6                	mov    %eax,%esi
ffff80000010a42f:	48 89 d7             	mov    %rdx,%rdi
ffff80000010a432:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a437:	48 ba 04 08 10 00 00 	movabs $0xffff800000100804,%rdx
ffff80000010a43e:	80 ff ff 
ffff80000010a441:	ff d2                	call   *%rdx
      panic("trap");
ffff80000010a443:	48 b8 87 cd 10 00 00 	movabs $0xffff80000010cd87,%rax
ffff80000010a44a:	80 ff ff 
ffff80000010a44d:	48 89 c7             	mov    %rax,%rdi
ffff80000010a450:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010a457:	80 ff ff 
ffff80000010a45a:	ff d0                	call   *%rax
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff80000010a45c:	48 b8 19 9f 10 00 00 	movabs $0xffff800000109f19,%rax
ffff80000010a463:	80 ff ff 
ffff80000010a466:	ff d0                	call   *%rax
ffff80000010a468:	48 89 c3             	mov    %rax,%rbx
ffff80000010a46b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a46f:	4c 8b a0 88 00 00 00 	mov    0x88(%rax),%r12
ffff80000010a476:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff80000010a47d:	80 ff ff 
ffff80000010a480:	ff d0                	call   *%rax
ffff80000010a482:	89 c1                	mov    %eax,%ecx
ffff80000010a484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a488:	4c 8b 80 80 00 00 00 	mov    0x80(%rax),%r8
ffff80000010a48f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a493:	48 8b 50 78          	mov    0x78(%rax),%rdx
            "rip 0x%p addr 0x%p--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->rip,
ffff80000010a497:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a49e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a4a2:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffff80000010a4a9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a4b0:	64 48 8b 00          	mov    %fs:(%rax),%rax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffff80000010a4b4:	8b 40 1c             	mov    0x1c(%rax),%eax
ffff80000010a4b7:	48 bf 90 cd 10 00 00 	movabs $0xffff80000010cd90,%rdi
ffff80000010a4be:	80 ff ff 
ffff80000010a4c1:	53                   	push   %rbx
ffff80000010a4c2:	41 54                	push   %r12
ffff80000010a4c4:	41 89 c9             	mov    %ecx,%r9d
ffff80000010a4c7:	48 89 d1             	mov    %rdx,%rcx
ffff80000010a4ca:	48 89 f2             	mov    %rsi,%rdx
ffff80000010a4cd:	89 c6                	mov    %eax,%esi
ffff80000010a4cf:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010a4d4:	49 ba 04 08 10 00 00 	movabs $0xffff800000100804,%r10
ffff80000010a4db:	80 ff ff 
ffff80000010a4de:	41 ff d2             	call   *%r10
ffff80000010a4e1:	48 83 c4 10          	add    $0x10,%rsp
            rcr2());
    proc->killed = 1;
ffff80000010a4e5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a4ec:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a4f0:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
ffff80000010a4f7:	eb 01                	jmp    ffff80000010a4fa <trap+0x345>
    break;
ffff80000010a4f9:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff80000010a4fa:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a501:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a505:	48 85 c0             	test   %rax,%rax
ffff80000010a508:	74 32                	je     ffff80000010a53c <trap+0x387>
ffff80000010a50a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a511:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a515:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010a518:	85 c0                	test   %eax,%eax
ffff80000010a51a:	74 20                	je     ffff80000010a53c <trap+0x387>
ffff80000010a51c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a520:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a527:	83 e0 03             	and    $0x3,%eax
ffff80000010a52a:	48 83 f8 03          	cmp    $0x3,%rax
ffff80000010a52e:	75 0c                	jne    ffff80000010a53c <trap+0x387>
    exit();
ffff80000010a530:	48 b8 da 67 10 00 00 	movabs $0xffff8000001067da,%rax
ffff80000010a537:	80 ff ff 
ffff80000010a53a:	ff d0                	call   *%rax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
ffff80000010a53c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a543:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a547:	48 85 c0             	test   %rax,%rax
ffff80000010a54a:	74 2d                	je     ffff80000010a579 <trap+0x3c4>
ffff80000010a54c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a553:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a557:	8b 40 18             	mov    0x18(%rax),%eax
ffff80000010a55a:	83 f8 04             	cmp    $0x4,%eax
ffff80000010a55d:	75 1a                	jne    ffff80000010a579 <trap+0x3c4>
ffff80000010a55f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a563:	48 8b 40 78          	mov    0x78(%rax),%rax
ffff80000010a567:	48 83 f8 20          	cmp    $0x20,%rax
ffff80000010a56b:	75 0c                	jne    ffff80000010a579 <trap+0x3c4>
    yield();
ffff80000010a56d:	48 b8 a6 6d 10 00 00 	movabs $0xffff800000106da6,%rax
ffff80000010a574:	80 ff ff 
ffff80000010a577:	ff d0                	call   *%rax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffff80000010a579:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a580:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a584:	48 85 c0             	test   %rax,%rax
ffff80000010a587:	74 32                	je     ffff80000010a5bb <trap+0x406>
ffff80000010a589:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffff80000010a590:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffff80000010a594:	8b 40 40             	mov    0x40(%rax),%eax
ffff80000010a597:	85 c0                	test   %eax,%eax
ffff80000010a599:	74 20                	je     ffff80000010a5bb <trap+0x406>
ffff80000010a59b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010a59f:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffff80000010a5a6:	83 e0 03             	and    $0x3,%eax
ffff80000010a5a9:	48 83 f8 03          	cmp    $0x3,%rax
ffff80000010a5ad:	75 0c                	jne    ffff80000010a5bb <trap+0x406>
    exit();
ffff80000010a5af:	48 b8 da 67 10 00 00 	movabs $0xffff8000001067da,%rax
ffff80000010a5b6:	80 ff ff 
ffff80000010a5b9:	ff d0                	call   *%rax

  //check_alarms();
}
ffff80000010a5bb:	90                   	nop
ffff80000010a5bc:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
ffff80000010a5c0:	5b                   	pop    %rbx
ffff80000010a5c1:	41 5c                	pop    %r12
ffff80000010a5c3:	5d                   	pop    %rbp
ffff80000010a5c4:	c3                   	ret

ffff80000010a5c5 <inb>:
{
ffff80000010a5c5:	55                   	push   %rbp
ffff80000010a5c6:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a5c9:	48 83 ec 18          	sub    $0x18,%rsp
ffff80000010a5cd:	89 f8                	mov    %edi,%eax
ffff80000010a5cf:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffff80000010a5d3:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff80000010a5d7:	89 c2                	mov    %eax,%edx
ffff80000010a5d9:	ec                   	in     (%dx),%al
ffff80000010a5da:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffff80000010a5dd:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffff80000010a5e1:	c9                   	leave
ffff80000010a5e2:	c3                   	ret

ffff80000010a5e3 <outb>:
{
ffff80000010a5e3:	55                   	push   %rbp
ffff80000010a5e4:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a5e7:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010a5eb:	89 fa                	mov    %edi,%edx
ffff80000010a5ed:	89 f0                	mov    %esi,%eax
ffff80000010a5ef:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffff80000010a5f3:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffff80000010a5f6:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010a5fa:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010a5fe:	ee                   	out    %al,(%dx)
}
ffff80000010a5ff:	90                   	nop
ffff80000010a600:	c9                   	leave
ffff80000010a601:	c3                   	ret

ffff80000010a602 <uartearlyinit>:

static int uart;    // is there a uart?

void
uartearlyinit(void)
{
ffff80000010a602:	55                   	push   %rbp
ffff80000010a603:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a606:	48 83 ec 10          	sub    $0x10,%rsp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
ffff80000010a60a:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a60f:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a614:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a61b:	80 ff ff 
ffff80000010a61e:	ff d0                	call   *%rax

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
ffff80000010a620:	be 80 00 00 00       	mov    $0x80,%esi
ffff80000010a625:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a62a:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a631:	80 ff ff 
ffff80000010a634:	ff d0                	call   *%rax
  outb(COM1+0, 115200/9600);
ffff80000010a636:	be 0c 00 00 00       	mov    $0xc,%esi
ffff80000010a63b:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a640:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a647:	80 ff ff 
ffff80000010a64a:	ff d0                	call   *%rax
  outb(COM1+1, 0);
ffff80000010a64c:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a651:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a656:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a65d:	80 ff ff 
ffff80000010a660:	ff d0                	call   *%rax
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
ffff80000010a662:	be 03 00 00 00       	mov    $0x3,%esi
ffff80000010a667:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff80000010a66c:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a673:	80 ff ff 
ffff80000010a676:	ff d0                	call   *%rax
  outb(COM1+4, 0);
ffff80000010a678:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a67d:	bf fc 03 00 00       	mov    $0x3fc,%edi
ffff80000010a682:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a689:	80 ff ff 
ffff80000010a68c:	ff d0                	call   *%rax
  outb(COM1+1, 0x01);    // Enable receive interrupts.
ffff80000010a68e:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010a693:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010a698:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a69f:	80 ff ff 
ffff80000010a6a2:	ff d0                	call   *%rax

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
ffff80000010a6a4:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a6a9:	48 b8 c5 a5 10 00 00 	movabs $0xffff80000010a5c5,%rax
ffff80000010a6b0:	80 ff ff 
ffff80000010a6b3:	ff d0                	call   *%rax
ffff80000010a6b5:	3c ff                	cmp    $0xff,%al
ffff80000010a6b7:	74 4a                	je     ffff80000010a703 <uartearlyinit+0x101>
    return;
  uart = 1;
ffff80000010a6b9:	48 b8 4c 5d 12 00 00 	movabs $0xffff800000125d4c,%rax
ffff80000010a6c0:	80 ff ff 
ffff80000010a6c3:	c7 00 01 00 00 00    	movl   $0x1,(%rax)



  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
ffff80000010a6c9:	48 b8 d3 cd 10 00 00 	movabs $0xffff80000010cdd3,%rax
ffff80000010a6d0:	80 ff ff 
ffff80000010a6d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010a6d7:	eb 1d                	jmp    ffff80000010a6f6 <uartearlyinit+0xf4>
    uartputc(*p);
ffff80000010a6d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a6dd:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a6e0:	0f be c0             	movsbl %al,%eax
ffff80000010a6e3:	89 c7                	mov    %eax,%edi
ffff80000010a6e5:	48 b8 57 a7 10 00 00 	movabs $0xffff80000010a757,%rax
ffff80000010a6ec:	80 ff ff 
ffff80000010a6ef:	ff d0                	call   *%rax
  for(p="xv6...\n"; *p; p++)
ffff80000010a6f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff80000010a6f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010a6fa:	0f b6 00             	movzbl (%rax),%eax
ffff80000010a6fd:	84 c0                	test   %al,%al
ffff80000010a6ff:	75 d8                	jne    ffff80000010a6d9 <uartearlyinit+0xd7>
ffff80000010a701:	eb 01                	jmp    ffff80000010a704 <uartearlyinit+0x102>
    return;
ffff80000010a703:	90                   	nop
}
ffff80000010a704:	c9                   	leave
ffff80000010a705:	c3                   	ret

ffff80000010a706 <uartinit>:

void
uartinit(void)
{
ffff80000010a706:	55                   	push   %rbp
ffff80000010a707:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a70a:	48 b8 4c 5d 12 00 00 	movabs $0xffff800000125d4c,%rax
ffff80000010a711:	80 ff ff 
ffff80000010a714:	8b 00                	mov    (%rax),%eax
ffff80000010a716:	85 c0                	test   %eax,%eax
ffff80000010a718:	74 3a                	je     ffff80000010a754 <uartinit+0x4e>
    return;

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
ffff80000010a71a:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010a71f:	48 b8 c5 a5 10 00 00 	movabs $0xffff80000010a5c5,%rax
ffff80000010a726:	80 ff ff 
ffff80000010a729:	ff d0                	call   *%rax
  inb(COM1+0);
ffff80000010a72b:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a730:	48 b8 c5 a5 10 00 00 	movabs $0xffff80000010a5c5,%rax
ffff80000010a737:	80 ff ff 
ffff80000010a73a:	ff d0                	call   *%rax
  ioapicenable(IRQ_COM1, 0);
ffff80000010a73c:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010a741:	bf 04 00 00 00       	mov    $0x4,%edi
ffff80000010a746:	48 b8 6e 3f 10 00 00 	movabs $0xffff800000103f6e,%rax
ffff80000010a74d:	80 ff ff 
ffff80000010a750:	ff d0                	call   *%rax
ffff80000010a752:	eb 01                	jmp    ffff80000010a755 <uartinit+0x4f>
    return;
ffff80000010a754:	90                   	nop

}
ffff80000010a755:	5d                   	pop    %rbp
ffff80000010a756:	c3                   	ret

ffff80000010a757 <uartputc>:
void
uartputc(int c)
{
ffff80000010a757:	55                   	push   %rbp
ffff80000010a758:	48 89 e5             	mov    %rsp,%rbp
ffff80000010a75b:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010a75f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;

  if(!uart)
ffff80000010a762:	48 b8 4c 5d 12 00 00 	movabs $0xffff800000125d4c,%rax
ffff80000010a769:	80 ff ff 
ffff80000010a76c:	8b 00                	mov    (%rax),%eax
ffff80000010a76e:	85 c0                	test   %eax,%eax
ffff80000010a770:	74 5a                	je     ffff80000010a7cc <uartputc+0x75>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a772:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010a779:	eb 15                	jmp    ffff80000010a790 <uartputc+0x39>
    microdelay(10);
ffff80000010a77b:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff80000010a780:	48 b8 bf 47 10 00 00 	movabs $0xffff8000001047bf,%rax
ffff80000010a787:	80 ff ff 
ffff80000010a78a:	ff d0                	call   *%rax
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffff80000010a78c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010a790:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffff80000010a794:	7f 1b                	jg     ffff80000010a7b1 <uartputc+0x5a>
ffff80000010a796:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a79b:	48 b8 c5 a5 10 00 00 	movabs $0xffff80000010a5c5,%rax
ffff80000010a7a2:	80 ff ff 
ffff80000010a7a5:	ff d0                	call   *%rax
ffff80000010a7a7:	0f b6 c0             	movzbl %al,%eax
ffff80000010a7aa:	83 e0 20             	and    $0x20,%eax
ffff80000010a7ad:	85 c0                	test   %eax,%eax
ffff80000010a7af:	74 ca                	je     ffff80000010a77b <uartputc+0x24>
  outb(COM1+0, c);
ffff80000010a7b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010a7b4:	0f b6 c0             	movzbl %al,%eax
ffff80000010a7b7:	89 c6                	mov    %eax,%esi
ffff80000010a7b9:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a7be:	48 b8 e3 a5 10 00 00 	movabs $0xffff80000010a5e3,%rax
ffff80000010a7c5:	80 ff ff 
ffff80000010a7c8:	ff d0                	call   *%rax
ffff80000010a7ca:	eb 01                	jmp    ffff80000010a7cd <uartputc+0x76>
    return;
ffff80000010a7cc:	90                   	nop
}
ffff80000010a7cd:	c9                   	leave
ffff80000010a7ce:	c3                   	ret

ffff80000010a7cf <uartgetc>:

static int
uartgetc(void)
{
ffff80000010a7cf:	55                   	push   %rbp
ffff80000010a7d0:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffff80000010a7d3:	48 b8 4c 5d 12 00 00 	movabs $0xffff800000125d4c,%rax
ffff80000010a7da:	80 ff ff 
ffff80000010a7dd:	8b 00                	mov    (%rax),%eax
ffff80000010a7df:	85 c0                	test   %eax,%eax
ffff80000010a7e1:	75 07                	jne    ffff80000010a7ea <uartgetc+0x1b>
    return -1;
ffff80000010a7e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a7e8:	eb 36                	jmp    ffff80000010a820 <uartgetc+0x51>
  if(!(inb(COM1+5) & 0x01))
ffff80000010a7ea:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff80000010a7ef:	48 b8 c5 a5 10 00 00 	movabs $0xffff80000010a5c5,%rax
ffff80000010a7f6:	80 ff ff 
ffff80000010a7f9:	ff d0                	call   *%rax
ffff80000010a7fb:	0f b6 c0             	movzbl %al,%eax
ffff80000010a7fe:	83 e0 01             	and    $0x1,%eax
ffff80000010a801:	85 c0                	test   %eax,%eax
ffff80000010a803:	75 07                	jne    ffff80000010a80c <uartgetc+0x3d>
    return -1;
ffff80000010a805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010a80a:	eb 14                	jmp    ffff80000010a820 <uartgetc+0x51>
  return inb(COM1+0);
ffff80000010a80c:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010a811:	48 b8 c5 a5 10 00 00 	movabs $0xffff80000010a5c5,%rax
ffff80000010a818:	80 ff ff 
ffff80000010a81b:	ff d0                	call   *%rax
ffff80000010a81d:	0f b6 c0             	movzbl %al,%eax
}
ffff80000010a820:	5d                   	pop    %rbp
ffff80000010a821:	c3                   	ret

ffff80000010a822 <uartintr>:

void
uartintr(void)
{
ffff80000010a822:	55                   	push   %rbp
ffff80000010a823:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(uartgetc);
ffff80000010a826:	48 b8 cf a7 10 00 00 	movabs $0xffff80000010a7cf,%rax
ffff80000010a82d:	80 ff ff 
ffff80000010a830:	48 89 c7             	mov    %rax,%rdi
ffff80000010a833:	48 b8 6f 0f 10 00 00 	movabs $0xffff800000100f6f,%rax
ffff80000010a83a:	80 ff ff 
ffff80000010a83d:	ff d0                	call   *%rax
}
ffff80000010a83f:	90                   	nop
ffff80000010a840:	5d                   	pop    %rbp
ffff80000010a841:	c3                   	ret

ffff80000010a842 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.global alltraps
vector0:
  push $0
ffff80000010a842:	6a 00                	push   $0x0
  push $0
ffff80000010a844:	6a 00                	push   $0x0
  jmp alltraps
ffff80000010a846:	e9 88 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a84b <vector1>:
vector1:
  push $0
ffff80000010a84b:	6a 00                	push   $0x0
  push $1
ffff80000010a84d:	6a 01                	push   $0x1
  jmp alltraps
ffff80000010a84f:	e9 7f f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a854 <vector2>:
vector2:
  push $0
ffff80000010a854:	6a 00                	push   $0x0
  push $2
ffff80000010a856:	6a 02                	push   $0x2
  jmp alltraps
ffff80000010a858:	e9 76 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a85d <vector3>:
vector3:
  push $0
ffff80000010a85d:	6a 00                	push   $0x0
  push $3
ffff80000010a85f:	6a 03                	push   $0x3
  jmp alltraps
ffff80000010a861:	e9 6d f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a866 <vector4>:
vector4:
  push $0
ffff80000010a866:	6a 00                	push   $0x0
  push $4
ffff80000010a868:	6a 04                	push   $0x4
  jmp alltraps
ffff80000010a86a:	e9 64 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a86f <vector5>:
vector5:
  push $0
ffff80000010a86f:	6a 00                	push   $0x0
  push $5
ffff80000010a871:	6a 05                	push   $0x5
  jmp alltraps
ffff80000010a873:	e9 5b f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a878 <vector6>:
vector6:
  push $0
ffff80000010a878:	6a 00                	push   $0x0
  push $6
ffff80000010a87a:	6a 06                	push   $0x6
  jmp alltraps
ffff80000010a87c:	e9 52 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a881 <vector7>:
vector7:
  push $0
ffff80000010a881:	6a 00                	push   $0x0
  push $7
ffff80000010a883:	6a 07                	push   $0x7
  jmp alltraps
ffff80000010a885:	e9 49 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a88a <vector8>:
vector8:
  push $8
ffff80000010a88a:	6a 08                	push   $0x8
  jmp alltraps
ffff80000010a88c:	e9 42 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a891 <vector9>:
vector9:
  push $0
ffff80000010a891:	6a 00                	push   $0x0
  push $9
ffff80000010a893:	6a 09                	push   $0x9
  jmp alltraps
ffff80000010a895:	e9 39 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a89a <vector10>:
vector10:
  push $10
ffff80000010a89a:	6a 0a                	push   $0xa
  jmp alltraps
ffff80000010a89c:	e9 32 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8a1 <vector11>:
vector11:
  push $11
ffff80000010a8a1:	6a 0b                	push   $0xb
  jmp alltraps
ffff80000010a8a3:	e9 2b f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8a8 <vector12>:
vector12:
  push $12
ffff80000010a8a8:	6a 0c                	push   $0xc
  jmp alltraps
ffff80000010a8aa:	e9 24 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8af <vector13>:
vector13:
  push $13
ffff80000010a8af:	6a 0d                	push   $0xd
  jmp alltraps
ffff80000010a8b1:	e9 1d f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8b6 <vector14>:
vector14:
  push $14
ffff80000010a8b6:	6a 0e                	push   $0xe
  jmp alltraps
ffff80000010a8b8:	e9 16 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8bd <vector15>:
vector15:
  push $0
ffff80000010a8bd:	6a 00                	push   $0x0
  push $15
ffff80000010a8bf:	6a 0f                	push   $0xf
  jmp alltraps
ffff80000010a8c1:	e9 0d f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8c6 <vector16>:
vector16:
  push $0
ffff80000010a8c6:	6a 00                	push   $0x0
  push $16
ffff80000010a8c8:	6a 10                	push   $0x10
  jmp alltraps
ffff80000010a8ca:	e9 04 f5 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8cf <vector17>:
vector17:
  push $17
ffff80000010a8cf:	6a 11                	push   $0x11
  jmp alltraps
ffff80000010a8d1:	e9 fd f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8d6 <vector18>:
vector18:
  push $0
ffff80000010a8d6:	6a 00                	push   $0x0
  push $18
ffff80000010a8d8:	6a 12                	push   $0x12
  jmp alltraps
ffff80000010a8da:	e9 f4 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8df <vector19>:
vector19:
  push $0
ffff80000010a8df:	6a 00                	push   $0x0
  push $19
ffff80000010a8e1:	6a 13                	push   $0x13
  jmp alltraps
ffff80000010a8e3:	e9 eb f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8e8 <vector20>:
vector20:
  push $0
ffff80000010a8e8:	6a 00                	push   $0x0
  push $20
ffff80000010a8ea:	6a 14                	push   $0x14
  jmp alltraps
ffff80000010a8ec:	e9 e2 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8f1 <vector21>:
vector21:
  push $0
ffff80000010a8f1:	6a 00                	push   $0x0
  push $21
ffff80000010a8f3:	6a 15                	push   $0x15
  jmp alltraps
ffff80000010a8f5:	e9 d9 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a8fa <vector22>:
vector22:
  push $0
ffff80000010a8fa:	6a 00                	push   $0x0
  push $22
ffff80000010a8fc:	6a 16                	push   $0x16
  jmp alltraps
ffff80000010a8fe:	e9 d0 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a903 <vector23>:
vector23:
  push $0
ffff80000010a903:	6a 00                	push   $0x0
  push $23
ffff80000010a905:	6a 17                	push   $0x17
  jmp alltraps
ffff80000010a907:	e9 c7 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a90c <vector24>:
vector24:
  push $0
ffff80000010a90c:	6a 00                	push   $0x0
  push $24
ffff80000010a90e:	6a 18                	push   $0x18
  jmp alltraps
ffff80000010a910:	e9 be f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a915 <vector25>:
vector25:
  push $0
ffff80000010a915:	6a 00                	push   $0x0
  push $25
ffff80000010a917:	6a 19                	push   $0x19
  jmp alltraps
ffff80000010a919:	e9 b5 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a91e <vector26>:
vector26:
  push $0
ffff80000010a91e:	6a 00                	push   $0x0
  push $26
ffff80000010a920:	6a 1a                	push   $0x1a
  jmp alltraps
ffff80000010a922:	e9 ac f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a927 <vector27>:
vector27:
  push $0
ffff80000010a927:	6a 00                	push   $0x0
  push $27
ffff80000010a929:	6a 1b                	push   $0x1b
  jmp alltraps
ffff80000010a92b:	e9 a3 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a930 <vector28>:
vector28:
  push $0
ffff80000010a930:	6a 00                	push   $0x0
  push $28
ffff80000010a932:	6a 1c                	push   $0x1c
  jmp alltraps
ffff80000010a934:	e9 9a f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a939 <vector29>:
vector29:
  push $0
ffff80000010a939:	6a 00                	push   $0x0
  push $29
ffff80000010a93b:	6a 1d                	push   $0x1d
  jmp alltraps
ffff80000010a93d:	e9 91 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a942 <vector30>:
vector30:
  push $0
ffff80000010a942:	6a 00                	push   $0x0
  push $30
ffff80000010a944:	6a 1e                	push   $0x1e
  jmp alltraps
ffff80000010a946:	e9 88 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a94b <vector31>:
vector31:
  push $0
ffff80000010a94b:	6a 00                	push   $0x0
  push $31
ffff80000010a94d:	6a 1f                	push   $0x1f
  jmp alltraps
ffff80000010a94f:	e9 7f f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a954 <vector32>:
vector32:
  push $0
ffff80000010a954:	6a 00                	push   $0x0
  push $32
ffff80000010a956:	6a 20                	push   $0x20
  jmp alltraps
ffff80000010a958:	e9 76 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a95d <vector33>:
vector33:
  push $0
ffff80000010a95d:	6a 00                	push   $0x0
  push $33
ffff80000010a95f:	6a 21                	push   $0x21
  jmp alltraps
ffff80000010a961:	e9 6d f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a966 <vector34>:
vector34:
  push $0
ffff80000010a966:	6a 00                	push   $0x0
  push $34
ffff80000010a968:	6a 22                	push   $0x22
  jmp alltraps
ffff80000010a96a:	e9 64 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a96f <vector35>:
vector35:
  push $0
ffff80000010a96f:	6a 00                	push   $0x0
  push $35
ffff80000010a971:	6a 23                	push   $0x23
  jmp alltraps
ffff80000010a973:	e9 5b f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a978 <vector36>:
vector36:
  push $0
ffff80000010a978:	6a 00                	push   $0x0
  push $36
ffff80000010a97a:	6a 24                	push   $0x24
  jmp alltraps
ffff80000010a97c:	e9 52 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a981 <vector37>:
vector37:
  push $0
ffff80000010a981:	6a 00                	push   $0x0
  push $37
ffff80000010a983:	6a 25                	push   $0x25
  jmp alltraps
ffff80000010a985:	e9 49 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a98a <vector38>:
vector38:
  push $0
ffff80000010a98a:	6a 00                	push   $0x0
  push $38
ffff80000010a98c:	6a 26                	push   $0x26
  jmp alltraps
ffff80000010a98e:	e9 40 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a993 <vector39>:
vector39:
  push $0
ffff80000010a993:	6a 00                	push   $0x0
  push $39
ffff80000010a995:	6a 27                	push   $0x27
  jmp alltraps
ffff80000010a997:	e9 37 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a99c <vector40>:
vector40:
  push $0
ffff80000010a99c:	6a 00                	push   $0x0
  push $40
ffff80000010a99e:	6a 28                	push   $0x28
  jmp alltraps
ffff80000010a9a0:	e9 2e f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9a5 <vector41>:
vector41:
  push $0
ffff80000010a9a5:	6a 00                	push   $0x0
  push $41
ffff80000010a9a7:	6a 29                	push   $0x29
  jmp alltraps
ffff80000010a9a9:	e9 25 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9ae <vector42>:
vector42:
  push $0
ffff80000010a9ae:	6a 00                	push   $0x0
  push $42
ffff80000010a9b0:	6a 2a                	push   $0x2a
  jmp alltraps
ffff80000010a9b2:	e9 1c f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9b7 <vector43>:
vector43:
  push $0
ffff80000010a9b7:	6a 00                	push   $0x0
  push $43
ffff80000010a9b9:	6a 2b                	push   $0x2b
  jmp alltraps
ffff80000010a9bb:	e9 13 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9c0 <vector44>:
vector44:
  push $0
ffff80000010a9c0:	6a 00                	push   $0x0
  push $44
ffff80000010a9c2:	6a 2c                	push   $0x2c
  jmp alltraps
ffff80000010a9c4:	e9 0a f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9c9 <vector45>:
vector45:
  push $0
ffff80000010a9c9:	6a 00                	push   $0x0
  push $45
ffff80000010a9cb:	6a 2d                	push   $0x2d
  jmp alltraps
ffff80000010a9cd:	e9 01 f4 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9d2 <vector46>:
vector46:
  push $0
ffff80000010a9d2:	6a 00                	push   $0x0
  push $46
ffff80000010a9d4:	6a 2e                	push   $0x2e
  jmp alltraps
ffff80000010a9d6:	e9 f8 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9db <vector47>:
vector47:
  push $0
ffff80000010a9db:	6a 00                	push   $0x0
  push $47
ffff80000010a9dd:	6a 2f                	push   $0x2f
  jmp alltraps
ffff80000010a9df:	e9 ef f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9e4 <vector48>:
vector48:
  push $0
ffff80000010a9e4:	6a 00                	push   $0x0
  push $48
ffff80000010a9e6:	6a 30                	push   $0x30
  jmp alltraps
ffff80000010a9e8:	e9 e6 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9ed <vector49>:
vector49:
  push $0
ffff80000010a9ed:	6a 00                	push   $0x0
  push $49
ffff80000010a9ef:	6a 31                	push   $0x31
  jmp alltraps
ffff80000010a9f1:	e9 dd f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9f6 <vector50>:
vector50:
  push $0
ffff80000010a9f6:	6a 00                	push   $0x0
  push $50
ffff80000010a9f8:	6a 32                	push   $0x32
  jmp alltraps
ffff80000010a9fa:	e9 d4 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010a9ff <vector51>:
vector51:
  push $0
ffff80000010a9ff:	6a 00                	push   $0x0
  push $51
ffff80000010aa01:	6a 33                	push   $0x33
  jmp alltraps
ffff80000010aa03:	e9 cb f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa08 <vector52>:
vector52:
  push $0
ffff80000010aa08:	6a 00                	push   $0x0
  push $52
ffff80000010aa0a:	6a 34                	push   $0x34
  jmp alltraps
ffff80000010aa0c:	e9 c2 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa11 <vector53>:
vector53:
  push $0
ffff80000010aa11:	6a 00                	push   $0x0
  push $53
ffff80000010aa13:	6a 35                	push   $0x35
  jmp alltraps
ffff80000010aa15:	e9 b9 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa1a <vector54>:
vector54:
  push $0
ffff80000010aa1a:	6a 00                	push   $0x0
  push $54
ffff80000010aa1c:	6a 36                	push   $0x36
  jmp alltraps
ffff80000010aa1e:	e9 b0 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa23 <vector55>:
vector55:
  push $0
ffff80000010aa23:	6a 00                	push   $0x0
  push $55
ffff80000010aa25:	6a 37                	push   $0x37
  jmp alltraps
ffff80000010aa27:	e9 a7 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa2c <vector56>:
vector56:
  push $0
ffff80000010aa2c:	6a 00                	push   $0x0
  push $56
ffff80000010aa2e:	6a 38                	push   $0x38
  jmp alltraps
ffff80000010aa30:	e9 9e f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa35 <vector57>:
vector57:
  push $0
ffff80000010aa35:	6a 00                	push   $0x0
  push $57
ffff80000010aa37:	6a 39                	push   $0x39
  jmp alltraps
ffff80000010aa39:	e9 95 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa3e <vector58>:
vector58:
  push $0
ffff80000010aa3e:	6a 00                	push   $0x0
  push $58
ffff80000010aa40:	6a 3a                	push   $0x3a
  jmp alltraps
ffff80000010aa42:	e9 8c f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa47 <vector59>:
vector59:
  push $0
ffff80000010aa47:	6a 00                	push   $0x0
  push $59
ffff80000010aa49:	6a 3b                	push   $0x3b
  jmp alltraps
ffff80000010aa4b:	e9 83 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa50 <vector60>:
vector60:
  push $0
ffff80000010aa50:	6a 00                	push   $0x0
  push $60
ffff80000010aa52:	6a 3c                	push   $0x3c
  jmp alltraps
ffff80000010aa54:	e9 7a f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa59 <vector61>:
vector61:
  push $0
ffff80000010aa59:	6a 00                	push   $0x0
  push $61
ffff80000010aa5b:	6a 3d                	push   $0x3d
  jmp alltraps
ffff80000010aa5d:	e9 71 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa62 <vector62>:
vector62:
  push $0
ffff80000010aa62:	6a 00                	push   $0x0
  push $62
ffff80000010aa64:	6a 3e                	push   $0x3e
  jmp alltraps
ffff80000010aa66:	e9 68 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa6b <vector63>:
vector63:
  push $0
ffff80000010aa6b:	6a 00                	push   $0x0
  push $63
ffff80000010aa6d:	6a 3f                	push   $0x3f
  jmp alltraps
ffff80000010aa6f:	e9 5f f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa74 <vector64>:
vector64:
  push $0
ffff80000010aa74:	6a 00                	push   $0x0
  push $64
ffff80000010aa76:	6a 40                	push   $0x40
  jmp alltraps
ffff80000010aa78:	e9 56 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa7d <vector65>:
vector65:
  push $0
ffff80000010aa7d:	6a 00                	push   $0x0
  push $65
ffff80000010aa7f:	6a 41                	push   $0x41
  jmp alltraps
ffff80000010aa81:	e9 4d f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa86 <vector66>:
vector66:
  push $0
ffff80000010aa86:	6a 00                	push   $0x0
  push $66
ffff80000010aa88:	6a 42                	push   $0x42
  jmp alltraps
ffff80000010aa8a:	e9 44 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa8f <vector67>:
vector67:
  push $0
ffff80000010aa8f:	6a 00                	push   $0x0
  push $67
ffff80000010aa91:	6a 43                	push   $0x43
  jmp alltraps
ffff80000010aa93:	e9 3b f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aa98 <vector68>:
vector68:
  push $0
ffff80000010aa98:	6a 00                	push   $0x0
  push $68
ffff80000010aa9a:	6a 44                	push   $0x44
  jmp alltraps
ffff80000010aa9c:	e9 32 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aaa1 <vector69>:
vector69:
  push $0
ffff80000010aaa1:	6a 00                	push   $0x0
  push $69
ffff80000010aaa3:	6a 45                	push   $0x45
  jmp alltraps
ffff80000010aaa5:	e9 29 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aaaa <vector70>:
vector70:
  push $0
ffff80000010aaaa:	6a 00                	push   $0x0
  push $70
ffff80000010aaac:	6a 46                	push   $0x46
  jmp alltraps
ffff80000010aaae:	e9 20 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aab3 <vector71>:
vector71:
  push $0
ffff80000010aab3:	6a 00                	push   $0x0
  push $71
ffff80000010aab5:	6a 47                	push   $0x47
  jmp alltraps
ffff80000010aab7:	e9 17 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aabc <vector72>:
vector72:
  push $0
ffff80000010aabc:	6a 00                	push   $0x0
  push $72
ffff80000010aabe:	6a 48                	push   $0x48
  jmp alltraps
ffff80000010aac0:	e9 0e f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aac5 <vector73>:
vector73:
  push $0
ffff80000010aac5:	6a 00                	push   $0x0
  push $73
ffff80000010aac7:	6a 49                	push   $0x49
  jmp alltraps
ffff80000010aac9:	e9 05 f3 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aace <vector74>:
vector74:
  push $0
ffff80000010aace:	6a 00                	push   $0x0
  push $74
ffff80000010aad0:	6a 4a                	push   $0x4a
  jmp alltraps
ffff80000010aad2:	e9 fc f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aad7 <vector75>:
vector75:
  push $0
ffff80000010aad7:	6a 00                	push   $0x0
  push $75
ffff80000010aad9:	6a 4b                	push   $0x4b
  jmp alltraps
ffff80000010aadb:	e9 f3 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aae0 <vector76>:
vector76:
  push $0
ffff80000010aae0:	6a 00                	push   $0x0
  push $76
ffff80000010aae2:	6a 4c                	push   $0x4c
  jmp alltraps
ffff80000010aae4:	e9 ea f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aae9 <vector77>:
vector77:
  push $0
ffff80000010aae9:	6a 00                	push   $0x0
  push $77
ffff80000010aaeb:	6a 4d                	push   $0x4d
  jmp alltraps
ffff80000010aaed:	e9 e1 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aaf2 <vector78>:
vector78:
  push $0
ffff80000010aaf2:	6a 00                	push   $0x0
  push $78
ffff80000010aaf4:	6a 4e                	push   $0x4e
  jmp alltraps
ffff80000010aaf6:	e9 d8 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aafb <vector79>:
vector79:
  push $0
ffff80000010aafb:	6a 00                	push   $0x0
  push $79
ffff80000010aafd:	6a 4f                	push   $0x4f
  jmp alltraps
ffff80000010aaff:	e9 cf f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab04 <vector80>:
vector80:
  push $0
ffff80000010ab04:	6a 00                	push   $0x0
  push $80
ffff80000010ab06:	6a 50                	push   $0x50
  jmp alltraps
ffff80000010ab08:	e9 c6 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab0d <vector81>:
vector81:
  push $0
ffff80000010ab0d:	6a 00                	push   $0x0
  push $81
ffff80000010ab0f:	6a 51                	push   $0x51
  jmp alltraps
ffff80000010ab11:	e9 bd f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab16 <vector82>:
vector82:
  push $0
ffff80000010ab16:	6a 00                	push   $0x0
  push $82
ffff80000010ab18:	6a 52                	push   $0x52
  jmp alltraps
ffff80000010ab1a:	e9 b4 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab1f <vector83>:
vector83:
  push $0
ffff80000010ab1f:	6a 00                	push   $0x0
  push $83
ffff80000010ab21:	6a 53                	push   $0x53
  jmp alltraps
ffff80000010ab23:	e9 ab f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab28 <vector84>:
vector84:
  push $0
ffff80000010ab28:	6a 00                	push   $0x0
  push $84
ffff80000010ab2a:	6a 54                	push   $0x54
  jmp alltraps
ffff80000010ab2c:	e9 a2 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab31 <vector85>:
vector85:
  push $0
ffff80000010ab31:	6a 00                	push   $0x0
  push $85
ffff80000010ab33:	6a 55                	push   $0x55
  jmp alltraps
ffff80000010ab35:	e9 99 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab3a <vector86>:
vector86:
  push $0
ffff80000010ab3a:	6a 00                	push   $0x0
  push $86
ffff80000010ab3c:	6a 56                	push   $0x56
  jmp alltraps
ffff80000010ab3e:	e9 90 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab43 <vector87>:
vector87:
  push $0
ffff80000010ab43:	6a 00                	push   $0x0
  push $87
ffff80000010ab45:	6a 57                	push   $0x57
  jmp alltraps
ffff80000010ab47:	e9 87 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab4c <vector88>:
vector88:
  push $0
ffff80000010ab4c:	6a 00                	push   $0x0
  push $88
ffff80000010ab4e:	6a 58                	push   $0x58
  jmp alltraps
ffff80000010ab50:	e9 7e f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab55 <vector89>:
vector89:
  push $0
ffff80000010ab55:	6a 00                	push   $0x0
  push $89
ffff80000010ab57:	6a 59                	push   $0x59
  jmp alltraps
ffff80000010ab59:	e9 75 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab5e <vector90>:
vector90:
  push $0
ffff80000010ab5e:	6a 00                	push   $0x0
  push $90
ffff80000010ab60:	6a 5a                	push   $0x5a
  jmp alltraps
ffff80000010ab62:	e9 6c f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab67 <vector91>:
vector91:
  push $0
ffff80000010ab67:	6a 00                	push   $0x0
  push $91
ffff80000010ab69:	6a 5b                	push   $0x5b
  jmp alltraps
ffff80000010ab6b:	e9 63 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab70 <vector92>:
vector92:
  push $0
ffff80000010ab70:	6a 00                	push   $0x0
  push $92
ffff80000010ab72:	6a 5c                	push   $0x5c
  jmp alltraps
ffff80000010ab74:	e9 5a f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab79 <vector93>:
vector93:
  push $0
ffff80000010ab79:	6a 00                	push   $0x0
  push $93
ffff80000010ab7b:	6a 5d                	push   $0x5d
  jmp alltraps
ffff80000010ab7d:	e9 51 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab82 <vector94>:
vector94:
  push $0
ffff80000010ab82:	6a 00                	push   $0x0
  push $94
ffff80000010ab84:	6a 5e                	push   $0x5e
  jmp alltraps
ffff80000010ab86:	e9 48 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab8b <vector95>:
vector95:
  push $0
ffff80000010ab8b:	6a 00                	push   $0x0
  push $95
ffff80000010ab8d:	6a 5f                	push   $0x5f
  jmp alltraps
ffff80000010ab8f:	e9 3f f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab94 <vector96>:
vector96:
  push $0
ffff80000010ab94:	6a 00                	push   $0x0
  push $96
ffff80000010ab96:	6a 60                	push   $0x60
  jmp alltraps
ffff80000010ab98:	e9 36 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ab9d <vector97>:
vector97:
  push $0
ffff80000010ab9d:	6a 00                	push   $0x0
  push $97
ffff80000010ab9f:	6a 61                	push   $0x61
  jmp alltraps
ffff80000010aba1:	e9 2d f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aba6 <vector98>:
vector98:
  push $0
ffff80000010aba6:	6a 00                	push   $0x0
  push $98
ffff80000010aba8:	6a 62                	push   $0x62
  jmp alltraps
ffff80000010abaa:	e9 24 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abaf <vector99>:
vector99:
  push $0
ffff80000010abaf:	6a 00                	push   $0x0
  push $99
ffff80000010abb1:	6a 63                	push   $0x63
  jmp alltraps
ffff80000010abb3:	e9 1b f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abb8 <vector100>:
vector100:
  push $0
ffff80000010abb8:	6a 00                	push   $0x0
  push $100
ffff80000010abba:	6a 64                	push   $0x64
  jmp alltraps
ffff80000010abbc:	e9 12 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abc1 <vector101>:
vector101:
  push $0
ffff80000010abc1:	6a 00                	push   $0x0
  push $101
ffff80000010abc3:	6a 65                	push   $0x65
  jmp alltraps
ffff80000010abc5:	e9 09 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abca <vector102>:
vector102:
  push $0
ffff80000010abca:	6a 00                	push   $0x0
  push $102
ffff80000010abcc:	6a 66                	push   $0x66
  jmp alltraps
ffff80000010abce:	e9 00 f2 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abd3 <vector103>:
vector103:
  push $0
ffff80000010abd3:	6a 00                	push   $0x0
  push $103
ffff80000010abd5:	6a 67                	push   $0x67
  jmp alltraps
ffff80000010abd7:	e9 f7 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abdc <vector104>:
vector104:
  push $0
ffff80000010abdc:	6a 00                	push   $0x0
  push $104
ffff80000010abde:	6a 68                	push   $0x68
  jmp alltraps
ffff80000010abe0:	e9 ee f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abe5 <vector105>:
vector105:
  push $0
ffff80000010abe5:	6a 00                	push   $0x0
  push $105
ffff80000010abe7:	6a 69                	push   $0x69
  jmp alltraps
ffff80000010abe9:	e9 e5 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abee <vector106>:
vector106:
  push $0
ffff80000010abee:	6a 00                	push   $0x0
  push $106
ffff80000010abf0:	6a 6a                	push   $0x6a
  jmp alltraps
ffff80000010abf2:	e9 dc f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010abf7 <vector107>:
vector107:
  push $0
ffff80000010abf7:	6a 00                	push   $0x0
  push $107
ffff80000010abf9:	6a 6b                	push   $0x6b
  jmp alltraps
ffff80000010abfb:	e9 d3 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac00 <vector108>:
vector108:
  push $0
ffff80000010ac00:	6a 00                	push   $0x0
  push $108
ffff80000010ac02:	6a 6c                	push   $0x6c
  jmp alltraps
ffff80000010ac04:	e9 ca f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac09 <vector109>:
vector109:
  push $0
ffff80000010ac09:	6a 00                	push   $0x0
  push $109
ffff80000010ac0b:	6a 6d                	push   $0x6d
  jmp alltraps
ffff80000010ac0d:	e9 c1 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac12 <vector110>:
vector110:
  push $0
ffff80000010ac12:	6a 00                	push   $0x0
  push $110
ffff80000010ac14:	6a 6e                	push   $0x6e
  jmp alltraps
ffff80000010ac16:	e9 b8 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac1b <vector111>:
vector111:
  push $0
ffff80000010ac1b:	6a 00                	push   $0x0
  push $111
ffff80000010ac1d:	6a 6f                	push   $0x6f
  jmp alltraps
ffff80000010ac1f:	e9 af f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac24 <vector112>:
vector112:
  push $0
ffff80000010ac24:	6a 00                	push   $0x0
  push $112
ffff80000010ac26:	6a 70                	push   $0x70
  jmp alltraps
ffff80000010ac28:	e9 a6 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac2d <vector113>:
vector113:
  push $0
ffff80000010ac2d:	6a 00                	push   $0x0
  push $113
ffff80000010ac2f:	6a 71                	push   $0x71
  jmp alltraps
ffff80000010ac31:	e9 9d f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac36 <vector114>:
vector114:
  push $0
ffff80000010ac36:	6a 00                	push   $0x0
  push $114
ffff80000010ac38:	6a 72                	push   $0x72
  jmp alltraps
ffff80000010ac3a:	e9 94 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac3f <vector115>:
vector115:
  push $0
ffff80000010ac3f:	6a 00                	push   $0x0
  push $115
ffff80000010ac41:	6a 73                	push   $0x73
  jmp alltraps
ffff80000010ac43:	e9 8b f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac48 <vector116>:
vector116:
  push $0
ffff80000010ac48:	6a 00                	push   $0x0
  push $116
ffff80000010ac4a:	6a 74                	push   $0x74
  jmp alltraps
ffff80000010ac4c:	e9 82 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac51 <vector117>:
vector117:
  push $0
ffff80000010ac51:	6a 00                	push   $0x0
  push $117
ffff80000010ac53:	6a 75                	push   $0x75
  jmp alltraps
ffff80000010ac55:	e9 79 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac5a <vector118>:
vector118:
  push $0
ffff80000010ac5a:	6a 00                	push   $0x0
  push $118
ffff80000010ac5c:	6a 76                	push   $0x76
  jmp alltraps
ffff80000010ac5e:	e9 70 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac63 <vector119>:
vector119:
  push $0
ffff80000010ac63:	6a 00                	push   $0x0
  push $119
ffff80000010ac65:	6a 77                	push   $0x77
  jmp alltraps
ffff80000010ac67:	e9 67 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac6c <vector120>:
vector120:
  push $0
ffff80000010ac6c:	6a 00                	push   $0x0
  push $120
ffff80000010ac6e:	6a 78                	push   $0x78
  jmp alltraps
ffff80000010ac70:	e9 5e f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac75 <vector121>:
vector121:
  push $0
ffff80000010ac75:	6a 00                	push   $0x0
  push $121
ffff80000010ac77:	6a 79                	push   $0x79
  jmp alltraps
ffff80000010ac79:	e9 55 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac7e <vector122>:
vector122:
  push $0
ffff80000010ac7e:	6a 00                	push   $0x0
  push $122
ffff80000010ac80:	6a 7a                	push   $0x7a
  jmp alltraps
ffff80000010ac82:	e9 4c f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac87 <vector123>:
vector123:
  push $0
ffff80000010ac87:	6a 00                	push   $0x0
  push $123
ffff80000010ac89:	6a 7b                	push   $0x7b
  jmp alltraps
ffff80000010ac8b:	e9 43 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac90 <vector124>:
vector124:
  push $0
ffff80000010ac90:	6a 00                	push   $0x0
  push $124
ffff80000010ac92:	6a 7c                	push   $0x7c
  jmp alltraps
ffff80000010ac94:	e9 3a f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ac99 <vector125>:
vector125:
  push $0
ffff80000010ac99:	6a 00                	push   $0x0
  push $125
ffff80000010ac9b:	6a 7d                	push   $0x7d
  jmp alltraps
ffff80000010ac9d:	e9 31 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aca2 <vector126>:
vector126:
  push $0
ffff80000010aca2:	6a 00                	push   $0x0
  push $126
ffff80000010aca4:	6a 7e                	push   $0x7e
  jmp alltraps
ffff80000010aca6:	e9 28 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010acab <vector127>:
vector127:
  push $0
ffff80000010acab:	6a 00                	push   $0x0
  push $127
ffff80000010acad:	6a 7f                	push   $0x7f
  jmp alltraps
ffff80000010acaf:	e9 1f f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010acb4 <vector128>:
vector128:
  push $0
ffff80000010acb4:	6a 00                	push   $0x0
  push $128
ffff80000010acb6:	68 80 00 00 00       	push   $0x80
  jmp alltraps
ffff80000010acbb:	e9 13 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010acc0 <vector129>:
vector129:
  push $0
ffff80000010acc0:	6a 00                	push   $0x0
  push $129
ffff80000010acc2:	68 81 00 00 00       	push   $0x81
  jmp alltraps
ffff80000010acc7:	e9 07 f1 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010accc <vector130>:
vector130:
  push $0
ffff80000010accc:	6a 00                	push   $0x0
  push $130
ffff80000010acce:	68 82 00 00 00       	push   $0x82
  jmp alltraps
ffff80000010acd3:	e9 fb f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010acd8 <vector131>:
vector131:
  push $0
ffff80000010acd8:	6a 00                	push   $0x0
  push $131
ffff80000010acda:	68 83 00 00 00       	push   $0x83
  jmp alltraps
ffff80000010acdf:	e9 ef f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ace4 <vector132>:
vector132:
  push $0
ffff80000010ace4:	6a 00                	push   $0x0
  push $132
ffff80000010ace6:	68 84 00 00 00       	push   $0x84
  jmp alltraps
ffff80000010aceb:	e9 e3 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010acf0 <vector133>:
vector133:
  push $0
ffff80000010acf0:	6a 00                	push   $0x0
  push $133
ffff80000010acf2:	68 85 00 00 00       	push   $0x85
  jmp alltraps
ffff80000010acf7:	e9 d7 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010acfc <vector134>:
vector134:
  push $0
ffff80000010acfc:	6a 00                	push   $0x0
  push $134
ffff80000010acfe:	68 86 00 00 00       	push   $0x86
  jmp alltraps
ffff80000010ad03:	e9 cb f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad08 <vector135>:
vector135:
  push $0
ffff80000010ad08:	6a 00                	push   $0x0
  push $135
ffff80000010ad0a:	68 87 00 00 00       	push   $0x87
  jmp alltraps
ffff80000010ad0f:	e9 bf f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad14 <vector136>:
vector136:
  push $0
ffff80000010ad14:	6a 00                	push   $0x0
  push $136
ffff80000010ad16:	68 88 00 00 00       	push   $0x88
  jmp alltraps
ffff80000010ad1b:	e9 b3 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad20 <vector137>:
vector137:
  push $0
ffff80000010ad20:	6a 00                	push   $0x0
  push $137
ffff80000010ad22:	68 89 00 00 00       	push   $0x89
  jmp alltraps
ffff80000010ad27:	e9 a7 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad2c <vector138>:
vector138:
  push $0
ffff80000010ad2c:	6a 00                	push   $0x0
  push $138
ffff80000010ad2e:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
ffff80000010ad33:	e9 9b f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad38 <vector139>:
vector139:
  push $0
ffff80000010ad38:	6a 00                	push   $0x0
  push $139
ffff80000010ad3a:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
ffff80000010ad3f:	e9 8f f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad44 <vector140>:
vector140:
  push $0
ffff80000010ad44:	6a 00                	push   $0x0
  push $140
ffff80000010ad46:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
ffff80000010ad4b:	e9 83 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad50 <vector141>:
vector141:
  push $0
ffff80000010ad50:	6a 00                	push   $0x0
  push $141
ffff80000010ad52:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
ffff80000010ad57:	e9 77 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad5c <vector142>:
vector142:
  push $0
ffff80000010ad5c:	6a 00                	push   $0x0
  push $142
ffff80000010ad5e:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
ffff80000010ad63:	e9 6b f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad68 <vector143>:
vector143:
  push $0
ffff80000010ad68:	6a 00                	push   $0x0
  push $143
ffff80000010ad6a:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
ffff80000010ad6f:	e9 5f f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad74 <vector144>:
vector144:
  push $0
ffff80000010ad74:	6a 00                	push   $0x0
  push $144
ffff80000010ad76:	68 90 00 00 00       	push   $0x90
  jmp alltraps
ffff80000010ad7b:	e9 53 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad80 <vector145>:
vector145:
  push $0
ffff80000010ad80:	6a 00                	push   $0x0
  push $145
ffff80000010ad82:	68 91 00 00 00       	push   $0x91
  jmp alltraps
ffff80000010ad87:	e9 47 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad8c <vector146>:
vector146:
  push $0
ffff80000010ad8c:	6a 00                	push   $0x0
  push $146
ffff80000010ad8e:	68 92 00 00 00       	push   $0x92
  jmp alltraps
ffff80000010ad93:	e9 3b f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ad98 <vector147>:
vector147:
  push $0
ffff80000010ad98:	6a 00                	push   $0x0
  push $147
ffff80000010ad9a:	68 93 00 00 00       	push   $0x93
  jmp alltraps
ffff80000010ad9f:	e9 2f f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ada4 <vector148>:
vector148:
  push $0
ffff80000010ada4:	6a 00                	push   $0x0
  push $148
ffff80000010ada6:	68 94 00 00 00       	push   $0x94
  jmp alltraps
ffff80000010adab:	e9 23 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010adb0 <vector149>:
vector149:
  push $0
ffff80000010adb0:	6a 00                	push   $0x0
  push $149
ffff80000010adb2:	68 95 00 00 00       	push   $0x95
  jmp alltraps
ffff80000010adb7:	e9 17 f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010adbc <vector150>:
vector150:
  push $0
ffff80000010adbc:	6a 00                	push   $0x0
  push $150
ffff80000010adbe:	68 96 00 00 00       	push   $0x96
  jmp alltraps
ffff80000010adc3:	e9 0b f0 ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010adc8 <vector151>:
vector151:
  push $0
ffff80000010adc8:	6a 00                	push   $0x0
  push $151
ffff80000010adca:	68 97 00 00 00       	push   $0x97
  jmp alltraps
ffff80000010adcf:	e9 ff ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010add4 <vector152>:
vector152:
  push $0
ffff80000010add4:	6a 00                	push   $0x0
  push $152
ffff80000010add6:	68 98 00 00 00       	push   $0x98
  jmp alltraps
ffff80000010addb:	e9 f3 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ade0 <vector153>:
vector153:
  push $0
ffff80000010ade0:	6a 00                	push   $0x0
  push $153
ffff80000010ade2:	68 99 00 00 00       	push   $0x99
  jmp alltraps
ffff80000010ade7:	e9 e7 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010adec <vector154>:
vector154:
  push $0
ffff80000010adec:	6a 00                	push   $0x0
  push $154
ffff80000010adee:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
ffff80000010adf3:	e9 db ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010adf8 <vector155>:
vector155:
  push $0
ffff80000010adf8:	6a 00                	push   $0x0
  push $155
ffff80000010adfa:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
ffff80000010adff:	e9 cf ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae04 <vector156>:
vector156:
  push $0
ffff80000010ae04:	6a 00                	push   $0x0
  push $156
ffff80000010ae06:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
ffff80000010ae0b:	e9 c3 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae10 <vector157>:
vector157:
  push $0
ffff80000010ae10:	6a 00                	push   $0x0
  push $157
ffff80000010ae12:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
ffff80000010ae17:	e9 b7 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae1c <vector158>:
vector158:
  push $0
ffff80000010ae1c:	6a 00                	push   $0x0
  push $158
ffff80000010ae1e:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
ffff80000010ae23:	e9 ab ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae28 <vector159>:
vector159:
  push $0
ffff80000010ae28:	6a 00                	push   $0x0
  push $159
ffff80000010ae2a:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
ffff80000010ae2f:	e9 9f ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae34 <vector160>:
vector160:
  push $0
ffff80000010ae34:	6a 00                	push   $0x0
  push $160
ffff80000010ae36:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
ffff80000010ae3b:	e9 93 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae40 <vector161>:
vector161:
  push $0
ffff80000010ae40:	6a 00                	push   $0x0
  push $161
ffff80000010ae42:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
ffff80000010ae47:	e9 87 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae4c <vector162>:
vector162:
  push $0
ffff80000010ae4c:	6a 00                	push   $0x0
  push $162
ffff80000010ae4e:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
ffff80000010ae53:	e9 7b ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae58 <vector163>:
vector163:
  push $0
ffff80000010ae58:	6a 00                	push   $0x0
  push $163
ffff80000010ae5a:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
ffff80000010ae5f:	e9 6f ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae64 <vector164>:
vector164:
  push $0
ffff80000010ae64:	6a 00                	push   $0x0
  push $164
ffff80000010ae66:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
ffff80000010ae6b:	e9 63 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae70 <vector165>:
vector165:
  push $0
ffff80000010ae70:	6a 00                	push   $0x0
  push $165
ffff80000010ae72:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
ffff80000010ae77:	e9 57 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae7c <vector166>:
vector166:
  push $0
ffff80000010ae7c:	6a 00                	push   $0x0
  push $166
ffff80000010ae7e:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
ffff80000010ae83:	e9 4b ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae88 <vector167>:
vector167:
  push $0
ffff80000010ae88:	6a 00                	push   $0x0
  push $167
ffff80000010ae8a:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
ffff80000010ae8f:	e9 3f ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010ae94 <vector168>:
vector168:
  push $0
ffff80000010ae94:	6a 00                	push   $0x0
  push $168
ffff80000010ae96:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
ffff80000010ae9b:	e9 33 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aea0 <vector169>:
vector169:
  push $0
ffff80000010aea0:	6a 00                	push   $0x0
  push $169
ffff80000010aea2:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
ffff80000010aea7:	e9 27 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aeac <vector170>:
vector170:
  push $0
ffff80000010aeac:	6a 00                	push   $0x0
  push $170
ffff80000010aeae:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
ffff80000010aeb3:	e9 1b ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aeb8 <vector171>:
vector171:
  push $0
ffff80000010aeb8:	6a 00                	push   $0x0
  push $171
ffff80000010aeba:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
ffff80000010aebf:	e9 0f ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aec4 <vector172>:
vector172:
  push $0
ffff80000010aec4:	6a 00                	push   $0x0
  push $172
ffff80000010aec6:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
ffff80000010aecb:	e9 03 ef ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aed0 <vector173>:
vector173:
  push $0
ffff80000010aed0:	6a 00                	push   $0x0
  push $173
ffff80000010aed2:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
ffff80000010aed7:	e9 f7 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aedc <vector174>:
vector174:
  push $0
ffff80000010aedc:	6a 00                	push   $0x0
  push $174
ffff80000010aede:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
ffff80000010aee3:	e9 eb ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aee8 <vector175>:
vector175:
  push $0
ffff80000010aee8:	6a 00                	push   $0x0
  push $175
ffff80000010aeea:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
ffff80000010aeef:	e9 df ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aef4 <vector176>:
vector176:
  push $0
ffff80000010aef4:	6a 00                	push   $0x0
  push $176
ffff80000010aef6:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
ffff80000010aefb:	e9 d3 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af00 <vector177>:
vector177:
  push $0
ffff80000010af00:	6a 00                	push   $0x0
  push $177
ffff80000010af02:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
ffff80000010af07:	e9 c7 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af0c <vector178>:
vector178:
  push $0
ffff80000010af0c:	6a 00                	push   $0x0
  push $178
ffff80000010af0e:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
ffff80000010af13:	e9 bb ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af18 <vector179>:
vector179:
  push $0
ffff80000010af18:	6a 00                	push   $0x0
  push $179
ffff80000010af1a:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
ffff80000010af1f:	e9 af ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af24 <vector180>:
vector180:
  push $0
ffff80000010af24:	6a 00                	push   $0x0
  push $180
ffff80000010af26:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
ffff80000010af2b:	e9 a3 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af30 <vector181>:
vector181:
  push $0
ffff80000010af30:	6a 00                	push   $0x0
  push $181
ffff80000010af32:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
ffff80000010af37:	e9 97 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af3c <vector182>:
vector182:
  push $0
ffff80000010af3c:	6a 00                	push   $0x0
  push $182
ffff80000010af3e:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
ffff80000010af43:	e9 8b ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af48 <vector183>:
vector183:
  push $0
ffff80000010af48:	6a 00                	push   $0x0
  push $183
ffff80000010af4a:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
ffff80000010af4f:	e9 7f ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af54 <vector184>:
vector184:
  push $0
ffff80000010af54:	6a 00                	push   $0x0
  push $184
ffff80000010af56:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
ffff80000010af5b:	e9 73 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af60 <vector185>:
vector185:
  push $0
ffff80000010af60:	6a 00                	push   $0x0
  push $185
ffff80000010af62:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
ffff80000010af67:	e9 67 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af6c <vector186>:
vector186:
  push $0
ffff80000010af6c:	6a 00                	push   $0x0
  push $186
ffff80000010af6e:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
ffff80000010af73:	e9 5b ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af78 <vector187>:
vector187:
  push $0
ffff80000010af78:	6a 00                	push   $0x0
  push $187
ffff80000010af7a:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
ffff80000010af7f:	e9 4f ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af84 <vector188>:
vector188:
  push $0
ffff80000010af84:	6a 00                	push   $0x0
  push $188
ffff80000010af86:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
ffff80000010af8b:	e9 43 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af90 <vector189>:
vector189:
  push $0
ffff80000010af90:	6a 00                	push   $0x0
  push $189
ffff80000010af92:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
ffff80000010af97:	e9 37 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010af9c <vector190>:
vector190:
  push $0
ffff80000010af9c:	6a 00                	push   $0x0
  push $190
ffff80000010af9e:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
ffff80000010afa3:	e9 2b ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010afa8 <vector191>:
vector191:
  push $0
ffff80000010afa8:	6a 00                	push   $0x0
  push $191
ffff80000010afaa:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
ffff80000010afaf:	e9 1f ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010afb4 <vector192>:
vector192:
  push $0
ffff80000010afb4:	6a 00                	push   $0x0
  push $192
ffff80000010afb6:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
ffff80000010afbb:	e9 13 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010afc0 <vector193>:
vector193:
  push $0
ffff80000010afc0:	6a 00                	push   $0x0
  push $193
ffff80000010afc2:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
ffff80000010afc7:	e9 07 ee ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010afcc <vector194>:
vector194:
  push $0
ffff80000010afcc:	6a 00                	push   $0x0
  push $194
ffff80000010afce:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
ffff80000010afd3:	e9 fb ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010afd8 <vector195>:
vector195:
  push $0
ffff80000010afd8:	6a 00                	push   $0x0
  push $195
ffff80000010afda:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
ffff80000010afdf:	e9 ef ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010afe4 <vector196>:
vector196:
  push $0
ffff80000010afe4:	6a 00                	push   $0x0
  push $196
ffff80000010afe6:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
ffff80000010afeb:	e9 e3 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010aff0 <vector197>:
vector197:
  push $0
ffff80000010aff0:	6a 00                	push   $0x0
  push $197
ffff80000010aff2:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
ffff80000010aff7:	e9 d7 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010affc <vector198>:
vector198:
  push $0
ffff80000010affc:	6a 00                	push   $0x0
  push $198
ffff80000010affe:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
ffff80000010b003:	e9 cb ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b008 <vector199>:
vector199:
  push $0
ffff80000010b008:	6a 00                	push   $0x0
  push $199
ffff80000010b00a:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
ffff80000010b00f:	e9 bf ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b014 <vector200>:
vector200:
  push $0
ffff80000010b014:	6a 00                	push   $0x0
  push $200
ffff80000010b016:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
ffff80000010b01b:	e9 b3 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b020 <vector201>:
vector201:
  push $0
ffff80000010b020:	6a 00                	push   $0x0
  push $201
ffff80000010b022:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
ffff80000010b027:	e9 a7 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b02c <vector202>:
vector202:
  push $0
ffff80000010b02c:	6a 00                	push   $0x0
  push $202
ffff80000010b02e:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
ffff80000010b033:	e9 9b ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b038 <vector203>:
vector203:
  push $0
ffff80000010b038:	6a 00                	push   $0x0
  push $203
ffff80000010b03a:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
ffff80000010b03f:	e9 8f ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b044 <vector204>:
vector204:
  push $0
ffff80000010b044:	6a 00                	push   $0x0
  push $204
ffff80000010b046:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
ffff80000010b04b:	e9 83 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b050 <vector205>:
vector205:
  push $0
ffff80000010b050:	6a 00                	push   $0x0
  push $205
ffff80000010b052:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
ffff80000010b057:	e9 77 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b05c <vector206>:
vector206:
  push $0
ffff80000010b05c:	6a 00                	push   $0x0
  push $206
ffff80000010b05e:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
ffff80000010b063:	e9 6b ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b068 <vector207>:
vector207:
  push $0
ffff80000010b068:	6a 00                	push   $0x0
  push $207
ffff80000010b06a:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
ffff80000010b06f:	e9 5f ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b074 <vector208>:
vector208:
  push $0
ffff80000010b074:	6a 00                	push   $0x0
  push $208
ffff80000010b076:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
ffff80000010b07b:	e9 53 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b080 <vector209>:
vector209:
  push $0
ffff80000010b080:	6a 00                	push   $0x0
  push $209
ffff80000010b082:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
ffff80000010b087:	e9 47 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b08c <vector210>:
vector210:
  push $0
ffff80000010b08c:	6a 00                	push   $0x0
  push $210
ffff80000010b08e:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
ffff80000010b093:	e9 3b ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b098 <vector211>:
vector211:
  push $0
ffff80000010b098:	6a 00                	push   $0x0
  push $211
ffff80000010b09a:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
ffff80000010b09f:	e9 2f ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0a4 <vector212>:
vector212:
  push $0
ffff80000010b0a4:	6a 00                	push   $0x0
  push $212
ffff80000010b0a6:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
ffff80000010b0ab:	e9 23 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0b0 <vector213>:
vector213:
  push $0
ffff80000010b0b0:	6a 00                	push   $0x0
  push $213
ffff80000010b0b2:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
ffff80000010b0b7:	e9 17 ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0bc <vector214>:
vector214:
  push $0
ffff80000010b0bc:	6a 00                	push   $0x0
  push $214
ffff80000010b0be:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
ffff80000010b0c3:	e9 0b ed ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0c8 <vector215>:
vector215:
  push $0
ffff80000010b0c8:	6a 00                	push   $0x0
  push $215
ffff80000010b0ca:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
ffff80000010b0cf:	e9 ff ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0d4 <vector216>:
vector216:
  push $0
ffff80000010b0d4:	6a 00                	push   $0x0
  push $216
ffff80000010b0d6:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
ffff80000010b0db:	e9 f3 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0e0 <vector217>:
vector217:
  push $0
ffff80000010b0e0:	6a 00                	push   $0x0
  push $217
ffff80000010b0e2:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
ffff80000010b0e7:	e9 e7 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0ec <vector218>:
vector218:
  push $0
ffff80000010b0ec:	6a 00                	push   $0x0
  push $218
ffff80000010b0ee:	68 da 00 00 00       	push   $0xda
  jmp alltraps
ffff80000010b0f3:	e9 db ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b0f8 <vector219>:
vector219:
  push $0
ffff80000010b0f8:	6a 00                	push   $0x0
  push $219
ffff80000010b0fa:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
ffff80000010b0ff:	e9 cf ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b104 <vector220>:
vector220:
  push $0
ffff80000010b104:	6a 00                	push   $0x0
  push $220
ffff80000010b106:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
ffff80000010b10b:	e9 c3 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b110 <vector221>:
vector221:
  push $0
ffff80000010b110:	6a 00                	push   $0x0
  push $221
ffff80000010b112:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
ffff80000010b117:	e9 b7 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b11c <vector222>:
vector222:
  push $0
ffff80000010b11c:	6a 00                	push   $0x0
  push $222
ffff80000010b11e:	68 de 00 00 00       	push   $0xde
  jmp alltraps
ffff80000010b123:	e9 ab ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b128 <vector223>:
vector223:
  push $0
ffff80000010b128:	6a 00                	push   $0x0
  push $223
ffff80000010b12a:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
ffff80000010b12f:	e9 9f ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b134 <vector224>:
vector224:
  push $0
ffff80000010b134:	6a 00                	push   $0x0
  push $224
ffff80000010b136:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
ffff80000010b13b:	e9 93 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b140 <vector225>:
vector225:
  push $0
ffff80000010b140:	6a 00                	push   $0x0
  push $225
ffff80000010b142:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
ffff80000010b147:	e9 87 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b14c <vector226>:
vector226:
  push $0
ffff80000010b14c:	6a 00                	push   $0x0
  push $226
ffff80000010b14e:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
ffff80000010b153:	e9 7b ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b158 <vector227>:
vector227:
  push $0
ffff80000010b158:	6a 00                	push   $0x0
  push $227
ffff80000010b15a:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
ffff80000010b15f:	e9 6f ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b164 <vector228>:
vector228:
  push $0
ffff80000010b164:	6a 00                	push   $0x0
  push $228
ffff80000010b166:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
ffff80000010b16b:	e9 63 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b170 <vector229>:
vector229:
  push $0
ffff80000010b170:	6a 00                	push   $0x0
  push $229
ffff80000010b172:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
ffff80000010b177:	e9 57 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b17c <vector230>:
vector230:
  push $0
ffff80000010b17c:	6a 00                	push   $0x0
  push $230
ffff80000010b17e:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
ffff80000010b183:	e9 4b ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b188 <vector231>:
vector231:
  push $0
ffff80000010b188:	6a 00                	push   $0x0
  push $231
ffff80000010b18a:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
ffff80000010b18f:	e9 3f ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b194 <vector232>:
vector232:
  push $0
ffff80000010b194:	6a 00                	push   $0x0
  push $232
ffff80000010b196:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
ffff80000010b19b:	e9 33 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1a0 <vector233>:
vector233:
  push $0
ffff80000010b1a0:	6a 00                	push   $0x0
  push $233
ffff80000010b1a2:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
ffff80000010b1a7:	e9 27 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1ac <vector234>:
vector234:
  push $0
ffff80000010b1ac:	6a 00                	push   $0x0
  push $234
ffff80000010b1ae:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
ffff80000010b1b3:	e9 1b ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1b8 <vector235>:
vector235:
  push $0
ffff80000010b1b8:	6a 00                	push   $0x0
  push $235
ffff80000010b1ba:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
ffff80000010b1bf:	e9 0f ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1c4 <vector236>:
vector236:
  push $0
ffff80000010b1c4:	6a 00                	push   $0x0
  push $236
ffff80000010b1c6:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
ffff80000010b1cb:	e9 03 ec ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1d0 <vector237>:
vector237:
  push $0
ffff80000010b1d0:	6a 00                	push   $0x0
  push $237
ffff80000010b1d2:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
ffff80000010b1d7:	e9 f7 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1dc <vector238>:
vector238:
  push $0
ffff80000010b1dc:	6a 00                	push   $0x0
  push $238
ffff80000010b1de:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
ffff80000010b1e3:	e9 eb eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1e8 <vector239>:
vector239:
  push $0
ffff80000010b1e8:	6a 00                	push   $0x0
  push $239
ffff80000010b1ea:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
ffff80000010b1ef:	e9 df eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b1f4 <vector240>:
vector240:
  push $0
ffff80000010b1f4:	6a 00                	push   $0x0
  push $240
ffff80000010b1f6:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
ffff80000010b1fb:	e9 d3 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b200 <vector241>:
vector241:
  push $0
ffff80000010b200:	6a 00                	push   $0x0
  push $241
ffff80000010b202:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
ffff80000010b207:	e9 c7 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b20c <vector242>:
vector242:
  push $0
ffff80000010b20c:	6a 00                	push   $0x0
  push $242
ffff80000010b20e:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
ffff80000010b213:	e9 bb eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b218 <vector243>:
vector243:
  push $0
ffff80000010b218:	6a 00                	push   $0x0
  push $243
ffff80000010b21a:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
ffff80000010b21f:	e9 af eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b224 <vector244>:
vector244:
  push $0
ffff80000010b224:	6a 00                	push   $0x0
  push $244
ffff80000010b226:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
ffff80000010b22b:	e9 a3 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b230 <vector245>:
vector245:
  push $0
ffff80000010b230:	6a 00                	push   $0x0
  push $245
ffff80000010b232:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
ffff80000010b237:	e9 97 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b23c <vector246>:
vector246:
  push $0
ffff80000010b23c:	6a 00                	push   $0x0
  push $246
ffff80000010b23e:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
ffff80000010b243:	e9 8b eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b248 <vector247>:
vector247:
  push $0
ffff80000010b248:	6a 00                	push   $0x0
  push $247
ffff80000010b24a:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
ffff80000010b24f:	e9 7f eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b254 <vector248>:
vector248:
  push $0
ffff80000010b254:	6a 00                	push   $0x0
  push $248
ffff80000010b256:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
ffff80000010b25b:	e9 73 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b260 <vector249>:
vector249:
  push $0
ffff80000010b260:	6a 00                	push   $0x0
  push $249
ffff80000010b262:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
ffff80000010b267:	e9 67 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b26c <vector250>:
vector250:
  push $0
ffff80000010b26c:	6a 00                	push   $0x0
  push $250
ffff80000010b26e:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
ffff80000010b273:	e9 5b eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b278 <vector251>:
vector251:
  push $0
ffff80000010b278:	6a 00                	push   $0x0
  push $251
ffff80000010b27a:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
ffff80000010b27f:	e9 4f eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b284 <vector252>:
vector252:
  push $0
ffff80000010b284:	6a 00                	push   $0x0
  push $252
ffff80000010b286:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
ffff80000010b28b:	e9 43 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b290 <vector253>:
vector253:
  push $0
ffff80000010b290:	6a 00                	push   $0x0
  push $253
ffff80000010b292:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
ffff80000010b297:	e9 37 eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b29c <vector254>:
vector254:
  push $0
ffff80000010b29c:	6a 00                	push   $0x0
  push $254
ffff80000010b29e:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
ffff80000010b2a3:	e9 2b eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b2a8 <vector255>:
vector255:
  push $0
ffff80000010b2a8:	6a 00                	push   $0x0
  push $255
ffff80000010b2aa:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
ffff80000010b2af:	e9 1f eb ff ff       	jmp    ffff800000109dd3 <alltraps>

ffff80000010b2b4 <lgdt>:
{
ffff80000010b2b4:	55                   	push   %rbp
ffff80000010b2b5:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b2b8:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010b2bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010b2c0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  addr_t addr = (addr_t)p;
ffff80000010b2c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010b2c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  pd[0] = size-1;
ffff80000010b2cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffff80000010b2ce:	83 e8 01             	sub    $0x1,%eax
ffff80000010b2d1:	66 89 45 ee          	mov    %ax,-0x12(%rbp)
  pd[1] = addr;
ffff80000010b2d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b2d9:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[2] = addr >> 16;
ffff80000010b2dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b2e1:	48 c1 e8 10          	shr    $0x10,%rax
ffff80000010b2e5:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[3] = addr >> 32;
ffff80000010b2e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b2ed:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010b2f1:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
  pd[4] = addr >> 48;
ffff80000010b2f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b2f9:	48 c1 e8 30          	shr    $0x30,%rax
ffff80000010b2fd:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  asm volatile("lgdt (%0)" : : "r" (pd));
ffff80000010b301:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
ffff80000010b305:	0f 01 10             	lgdt   (%rax)
}
ffff80000010b308:	90                   	nop
ffff80000010b309:	c9                   	leave
ffff80000010b30a:	c3                   	ret

ffff80000010b30b <ltr>:
{
ffff80000010b30b:	55                   	push   %rbp
ffff80000010b30c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b30f:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010b313:	89 f8                	mov    %edi,%eax
ffff80000010b315:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  asm volatile("ltr %0" : : "r" (sel));
ffff80000010b319:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffff80000010b31d:	0f 00 d8             	ltr    %eax
}
ffff80000010b320:	90                   	nop
ffff80000010b321:	c9                   	leave
ffff80000010b322:	c3                   	ret

ffff80000010b323 <lcr3>:

static inline void
lcr3(addr_t val)
{
ffff80000010b323:	55                   	push   %rbp
ffff80000010b324:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b327:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010b32b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  asm volatile("mov %0,%%cr3" : : "r" (val));
ffff80000010b32f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b333:	0f 22 d8             	mov    %rax,%cr3
}
ffff80000010b336:	90                   	nop
ffff80000010b337:	c9                   	leave
ffff80000010b338:	c3                   	ret

ffff80000010b339 <v2p>:
static inline addr_t v2p(void *a) {
ffff80000010b339:	55                   	push   %rbp
ffff80000010b33a:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b33d:	48 83 ec 08          	sub    $0x8,%rsp
ffff80000010b341:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return ((addr_t) (a)) - ((addr_t)KERNBASE);
ffff80000010b345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b349:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010b350:	80 00 00 
ffff80000010b353:	48 01 d0             	add    %rdx,%rax
}
ffff80000010b356:	c9                   	leave
ffff80000010b357:	c3                   	ret

ffff80000010b358 <syscallinit>:
static pml4e_t *kpml4;
static pdpe_t *kpdpt;

void
syscallinit(void)
{
ffff80000010b358:	55                   	push   %rbp
ffff80000010b359:	48 89 e5             	mov    %rsp,%rbp
  // the MSR/SYSRET wants the segment for 32-bit user data
  // next up is 64-bit user data, then code
  // This is simply the way the sysret instruction
  // is designed to work (it assumes they follow).
  wrmsr(MSR_STAR,
ffff80000010b35c:	48 b8 00 00 00 00 08 	movabs $0x1b000800000000,%rax
ffff80000010b363:	00 1b 00 
ffff80000010b366:	48 89 c6             	mov    %rax,%rsi
ffff80000010b369:	bf 81 00 00 c0       	mov    $0xc0000081,%edi
ffff80000010b36e:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b375:	80 ff ff 
ffff80000010b378:	ff d0                	call   *%rax
    ((((uint64)USER32_CS) << 48) | ((uint64)KERNEL_CS << 32)));
  wrmsr(MSR_LSTAR, (addr_t)syscall_entry);
ffff80000010b37a:	48 b8 0f 9e 10 00 00 	movabs $0xffff800000109e0f,%rax
ffff80000010b381:	80 ff ff 
ffff80000010b384:	48 89 c6             	mov    %rax,%rsi
ffff80000010b387:	bf 82 00 00 c0       	mov    $0xc0000082,%edi
ffff80000010b38c:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b393:	80 ff ff 
ffff80000010b396:	ff d0                	call   *%rax
  wrmsr(MSR_CSTAR, (addr_t)ignore_sysret);
ffff80000010b398:	48 b8 11 01 10 00 00 	movabs $0xffff800000100111,%rax
ffff80000010b39f:	80 ff ff 
ffff80000010b3a2:	48 89 c6             	mov    %rax,%rsi
ffff80000010b3a5:	bf 83 00 00 c0       	mov    $0xc0000083,%edi
ffff80000010b3aa:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b3b1:	80 ff ff 
ffff80000010b3b4:	ff d0                	call   *%rax

  wrmsr(MSR_SFMASK, FL_TF|FL_DF|FL_IF|FL_IOPL_3|FL_AC|FL_NT);
ffff80000010b3b6:	be 00 77 04 00       	mov    $0x47700,%esi
ffff80000010b3bb:	bf 84 00 00 c0       	mov    $0xc0000084,%edi
ffff80000010b3c0:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b3c7:	80 ff ff 
ffff80000010b3ca:	ff d0                	call   *%rax
}
ffff80000010b3cc:	90                   	nop
ffff80000010b3cd:	5d                   	pop    %rbp
ffff80000010b3ce:	c3                   	ret

ffff80000010b3cf <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
ffff80000010b3cf:	55                   	push   %rbp
ffff80000010b3d0:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b3d3:	48 83 ec 30          	sub    $0x30,%rsp
  uint64 addr;
  void *local;
  struct cpu *c;

  // create a page for cpu local storage
  local = kalloc();
ffff80000010b3d7:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010b3de:	80 ff ff 
ffff80000010b3e1:	ff d0                	call   *%rax
ffff80000010b3e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(local, 0, PGSIZE);
ffff80000010b3e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b3eb:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b3f0:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b3f5:	48 89 c7             	mov    %rax,%rdi
ffff80000010b3f8:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010b3ff:	80 ff ff 
ffff80000010b402:	ff d0                	call   *%rax

  gdt = (struct segdesc*) local;
ffff80000010b404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b408:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss = (uint*) (((char*) local) + 1024);
ffff80000010b40c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b410:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010b416:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  tss[16] = 0x00680000; // IO Map Base = End of TSS
ffff80000010b41a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b41e:	48 83 c0 40          	add    $0x40,%rax
ffff80000010b422:	c7 00 00 00 68 00    	movl   $0x680000,(%rax)

  // point FS smack in the middle of our local storage page
  wrmsr(0xC0000100, ((uint64) local) + 2048);
ffff80000010b428:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b42c:	48 05 00 08 00 00    	add    $0x800,%rax
ffff80000010b432:	48 89 c6             	mov    %rax,%rsi
ffff80000010b435:	bf 00 01 00 c0       	mov    $0xc0000100,%edi
ffff80000010b43a:	48 b8 01 01 10 00 00 	movabs $0xffff800000100101,%rax
ffff80000010b441:	80 ff ff 
ffff80000010b444:	ff d0                	call   *%rax

  c = &cpus[cpunum()];
ffff80000010b446:	48 b8 88 46 10 00 00 	movabs $0xffff800000104688,%rax
ffff80000010b44d:	80 ff ff 
ffff80000010b450:	ff d0                	call   *%rax
ffff80000010b452:	48 63 d0             	movslq %eax,%rdx
ffff80000010b455:	48 89 d0             	mov    %rdx,%rax
ffff80000010b458:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010b45c:	48 01 d0             	add    %rdx,%rax
ffff80000010b45f:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010b463:	48 ba e0 72 11 00 00 	movabs $0xffff8000001172e0,%rdx
ffff80000010b46a:	80 ff ff 
ffff80000010b46d:	48 01 d0             	add    %rdx,%rax
ffff80000010b470:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  c->local = local;
ffff80000010b474:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b478:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010b47c:	48 89 50 20          	mov    %rdx,0x20(%rax)

  cpu = c;
ffff80000010b480:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010b484:	64 48 89 04 25 f0 ff 	mov    %rax,%fs:0xfffffffffffffff0
ffff80000010b48b:	ff ff 
  proc = 0;
ffff80000010b48d:	64 48 c7 04 25 f8 ff 	movq   $0x0,%fs:0xfffffffffffffff8
ffff80000010b494:	ff ff 00 00 00 00 

  addr = (uint64) tss;
ffff80000010b49a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b49e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  gdt[0] =  (struct segdesc) {};
ffff80000010b4a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b4a6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  gdt[SEG_KCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, !DPL_USER, 1);
ffff80000010b4ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b4b1:	48 83 c0 08          	add    $0x8,%rax
ffff80000010b4b5:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b4ba:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b4c0:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b4c4:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b4c8:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b4cb:	83 ca 0a             	or     $0xa,%edx
ffff80000010b4ce:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b4d1:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b4d5:	83 ca 10             	or     $0x10,%edx
ffff80000010b4d8:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b4db:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b4df:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010b4e2:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b4e5:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b4e9:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b4ec:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b4ef:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b4f3:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b4f6:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b4f9:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b4fd:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b500:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b503:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b507:	83 ca 20             	or     $0x20,%edx
ffff80000010b50a:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b50d:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b511:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b514:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b517:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b51b:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b51e:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b521:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KDATA] = SEG(STA_W, 0, 0, APP_SEG, !DPL_USER, 0);
ffff80000010b525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b529:	48 83 c0 10          	add    $0x10,%rax
ffff80000010b52d:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b532:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b538:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b53c:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b540:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b543:	83 ca 02             	or     $0x2,%edx
ffff80000010b546:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b549:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b54d:	83 ca 10             	or     $0x10,%edx
ffff80000010b550:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b553:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b557:	83 e2 9f             	and    $0xffffff9f,%edx
ffff80000010b55a:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b55d:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b561:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b564:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b567:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b56b:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b56e:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b571:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b575:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b578:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b57b:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b57f:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b582:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b585:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b589:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b58c:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b58f:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b593:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b596:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b599:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE32] = (struct segdesc) {}; // required by syscall/sysret
ffff80000010b59d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b5a1:	48 83 c0 18          	add    $0x18,%rax
ffff80000010b5a5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  gdt[SEG_UDATA] = SEG(STA_W, 0, 0, APP_SEG, DPL_USER, 0);
ffff80000010b5ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b5b0:	48 83 c0 20          	add    $0x20,%rax
ffff80000010b5b4:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b5b9:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b5bf:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b5c3:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b5c7:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b5ca:	83 ca 02             	or     $0x2,%edx
ffff80000010b5cd:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5d0:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b5d4:	83 ca 10             	or     $0x10,%edx
ffff80000010b5d7:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5da:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b5de:	83 ca 60             	or     $0x60,%edx
ffff80000010b5e1:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5e4:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b5e8:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b5eb:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b5ee:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b5f2:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b5f5:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b5f8:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b5fc:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b5ff:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b602:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b606:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b609:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b60c:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b610:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b613:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b616:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b61a:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b61d:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b620:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_UCODE] = SEG((STA_X|STA_R), 0, 0, APP_SEG, DPL_USER, 1);
ffff80000010b624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b628:	48 83 c0 28          	add    $0x28,%rax
ffff80000010b62c:	66 c7 00 00 00       	movw   $0x0,(%rax)
ffff80000010b631:	66 c7 40 02 00 00    	movw   $0x0,0x2(%rax)
ffff80000010b637:	c6 40 04 00          	movb   $0x0,0x4(%rax)
ffff80000010b63b:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b63f:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b642:	83 ca 0a             	or     $0xa,%edx
ffff80000010b645:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b648:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b64c:	83 ca 10             	or     $0x10,%edx
ffff80000010b64f:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b652:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b656:	83 ca 60             	or     $0x60,%edx
ffff80000010b659:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b65c:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b660:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b663:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b666:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b66a:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b66d:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b670:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b674:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b677:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b67a:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b67e:	83 ca 20             	or     $0x20,%edx
ffff80000010b681:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b684:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b688:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b68b:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b68e:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b692:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b695:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b698:	c6 40 07 00          	movb   $0x0,0x7(%rax)
  gdt[SEG_KCPU]  = (struct segdesc) {};
ffff80000010b69c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b6a0:	48 83 c0 30          	add    $0x30,%rax
ffff80000010b6a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  // TSS: See IA32 SDM Figure 7-4
  gdt[SEG_TSS]   = SEG(STS_T64A, 0xb, addr, !APP_SEG, DPL_USER, 0);
ffff80000010b6ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b6af:	48 83 c0 38          	add    $0x38,%rax
ffff80000010b6b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b6b7:	89 d7                	mov    %edx,%edi
ffff80000010b6b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b6bd:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b6c1:	89 d6                	mov    %edx,%esi
ffff80000010b6c3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b6c7:	48 c1 ea 18          	shr    $0x18,%rdx
ffff80000010b6cb:	89 d1                	mov    %edx,%ecx
ffff80000010b6cd:	66 c7 00 0b 00       	movw   $0xb,(%rax)
ffff80000010b6d2:	66 89 78 02          	mov    %di,0x2(%rax)
ffff80000010b6d6:	40 88 70 04          	mov    %sil,0x4(%rax)
ffff80000010b6da:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b6de:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b6e1:	83 ca 09             	or     $0x9,%edx
ffff80000010b6e4:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b6e7:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b6eb:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b6ee:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b6f1:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b6f5:	83 ca 60             	or     $0x60,%edx
ffff80000010b6f8:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b6fb:	0f b6 50 05          	movzbl 0x5(%rax),%edx
ffff80000010b6ff:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b702:	88 50 05             	mov    %dl,0x5(%rax)
ffff80000010b705:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b709:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b70c:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b70f:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b713:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b716:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b719:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b71d:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b720:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b723:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b727:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b72a:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b72d:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b731:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b734:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b737:	88 48 07             	mov    %cl,0x7(%rax)
  gdt[SEG_TSS+1] = SEG(0, addr >> 32, addr >> 48, 0, 0, 0);
ffff80000010b73a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b73e:	48 83 c0 40          	add    $0x40,%rax
ffff80000010b742:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b746:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b74a:	41 89 d1             	mov    %edx,%r9d
ffff80000010b74d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b751:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b755:	41 89 d0             	mov    %edx,%r8d
ffff80000010b758:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b75c:	48 c1 ea 30          	shr    $0x30,%rdx
ffff80000010b760:	48 c1 ea 10          	shr    $0x10,%rdx
ffff80000010b764:	89 d7                	mov    %edx,%edi
ffff80000010b766:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff80000010b76a:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010b76e:	48 c1 ea 3c          	shr    $0x3c,%rdx
ffff80000010b772:	83 e2 0f             	and    $0xf,%edx
ffff80000010b775:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010b779:	48 c1 e9 30          	shr    $0x30,%rcx
ffff80000010b77d:	48 c1 e9 18          	shr    $0x18,%rcx
ffff80000010b781:	89 ce                	mov    %ecx,%esi
ffff80000010b783:	66 44 89 08          	mov    %r9w,(%rax)
ffff80000010b787:	66 44 89 40 02       	mov    %r8w,0x2(%rax)
ffff80000010b78c:	40 88 78 04          	mov    %dil,0x4(%rax)
ffff80000010b790:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b794:	83 e1 f0             	and    $0xfffffff0,%ecx
ffff80000010b797:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b79a:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b79e:	83 e1 ef             	and    $0xffffffef,%ecx
ffff80000010b7a1:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b7a4:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b7a8:	83 e1 9f             	and    $0xffffff9f,%ecx
ffff80000010b7ab:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b7ae:	0f b6 48 05          	movzbl 0x5(%rax),%ecx
ffff80000010b7b2:	83 c9 80             	or     $0xffffff80,%ecx
ffff80000010b7b5:	88 48 05             	mov    %cl,0x5(%rax)
ffff80000010b7b8:	89 d1                	mov    %edx,%ecx
ffff80000010b7ba:	83 e1 0f             	and    $0xf,%ecx
ffff80000010b7bd:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b7c1:	83 e2 f0             	and    $0xfffffff0,%edx
ffff80000010b7c4:	09 ca                	or     %ecx,%edx
ffff80000010b7c6:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b7c9:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b7cd:	83 e2 ef             	and    $0xffffffef,%edx
ffff80000010b7d0:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b7d3:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b7d7:	83 e2 df             	and    $0xffffffdf,%edx
ffff80000010b7da:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b7dd:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b7e1:	83 e2 bf             	and    $0xffffffbf,%edx
ffff80000010b7e4:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b7e7:	0f b6 50 06          	movzbl 0x6(%rax),%edx
ffff80000010b7eb:	83 ca 80             	or     $0xffffff80,%edx
ffff80000010b7ee:	88 50 06             	mov    %dl,0x6(%rax)
ffff80000010b7f1:	40 88 70 07          	mov    %sil,0x7(%rax)

  lgdt((void*) gdt, (NSEGS+1) * sizeof(struct segdesc));
ffff80000010b7f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b7f9:	be 48 00 00 00       	mov    $0x48,%esi
ffff80000010b7fe:	48 89 c7             	mov    %rax,%rdi
ffff80000010b801:	48 b8 b4 b2 10 00 00 	movabs $0xffff80000010b2b4,%rax
ffff80000010b808:	80 ff ff 
ffff80000010b80b:	ff d0                	call   *%rax

  ltr(SEG_TSS << 3);
ffff80000010b80d:	bf 38 00 00 00       	mov    $0x38,%edi
ffff80000010b812:	48 b8 0b b3 10 00 00 	movabs $0xffff80000010b30b,%rax
ffff80000010b819:	80 ff ff 
ffff80000010b81c:	ff d0                	call   *%rax
};
ffff80000010b81e:	90                   	nop
ffff80000010b81f:	c9                   	leave
ffff80000010b820:	c3                   	ret

ffff80000010b821 <setupkvm>:
// (directly addressable from end..P2V(PHYSTOP)).


pml4e_t*
setupkvm(void)
{
ffff80000010b821:	55                   	push   %rbp
ffff80000010b822:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b825:	48 83 ec 10          	sub    $0x10,%rsp
  pml4e_t *pml4 = (pml4e_t*) kalloc();
ffff80000010b829:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010b830:	80 ff ff 
ffff80000010b833:	ff d0                	call   *%rax
ffff80000010b835:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(pml4, 0, PGSIZE);
ffff80000010b839:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b83d:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b842:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b847:	48 89 c7             	mov    %rax,%rdi
ffff80000010b84a:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010b851:	80 ff ff 
ffff80000010b854:	ff d0                	call   *%rax
  pml4[256] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b856:	48 b8 60 5d 12 00 00 	movabs $0xffff800000125d60,%rax
ffff80000010b85d:	80 ff ff 
ffff80000010b860:	48 8b 00             	mov    (%rax),%rax
ffff80000010b863:	48 89 c7             	mov    %rax,%rdi
ffff80000010b866:	48 b8 39 b3 10 00 00 	movabs $0xffff80000010b339,%rax
ffff80000010b86d:	80 ff ff 
ffff80000010b870:	ff d0                	call   *%rax
ffff80000010b872:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010b876:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b87d:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b881:	48 89 02             	mov    %rax,(%rdx)
  return pml4;
ffff80000010b884:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
};
ffff80000010b888:	c9                   	leave
ffff80000010b889:	c3                   	ret

ffff80000010b88a <kvmalloc>:
//
// linear map the first 4GB of physical memory starting
// at 0xFFFF800000000000
void
kvmalloc(void)
{
ffff80000010b88a:	55                   	push   %rbp
ffff80000010b88b:	48 89 e5             	mov    %rsp,%rbp
  kpml4 = (pml4e_t*) kalloc();
ffff80000010b88e:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010b895:	80 ff ff 
ffff80000010b898:	ff d0                	call   *%rax
ffff80000010b89a:	48 ba 58 5d 12 00 00 	movabs $0xffff800000125d58,%rdx
ffff80000010b8a1:	80 ff ff 
ffff80000010b8a4:	48 89 02             	mov    %rax,(%rdx)
  memset(kpml4, 0, PGSIZE);
ffff80000010b8a7:	48 b8 58 5d 12 00 00 	movabs $0xffff800000125d58,%rax
ffff80000010b8ae:	80 ff ff 
ffff80000010b8b1:	48 8b 00             	mov    (%rax),%rax
ffff80000010b8b4:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b8b9:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b8be:	48 89 c7             	mov    %rax,%rdi
ffff80000010b8c1:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010b8c8:	80 ff ff 
ffff80000010b8cb:	ff d0                	call   *%rax

  // the kernel memory region starts at KERNBASE and up
  // allocate one PDPT at the bottom of that range.
  kpdpt = (pde_t*) kalloc();
ffff80000010b8cd:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010b8d4:	80 ff ff 
ffff80000010b8d7:	ff d0                	call   *%rax
ffff80000010b8d9:	48 ba 60 5d 12 00 00 	movabs $0xffff800000125d60,%rdx
ffff80000010b8e0:	80 ff ff 
ffff80000010b8e3:	48 89 02             	mov    %rax,(%rdx)
  memset(kpdpt, 0, PGSIZE);
ffff80000010b8e6:	48 b8 60 5d 12 00 00 	movabs $0xffff800000125d60,%rax
ffff80000010b8ed:	80 ff ff 
ffff80000010b8f0:	48 8b 00             	mov    (%rax),%rax
ffff80000010b8f3:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010b8f8:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010b8fd:	48 89 c7             	mov    %rax,%rdi
ffff80000010b900:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010b907:	80 ff ff 
ffff80000010b90a:	ff d0                	call   *%rax
  kpml4[PMX(KERNBASE)] = v2p(kpdpt) | PTE_P | PTE_W;
ffff80000010b90c:	48 b8 60 5d 12 00 00 	movabs $0xffff800000125d60,%rax
ffff80000010b913:	80 ff ff 
ffff80000010b916:	48 8b 00             	mov    (%rax),%rax
ffff80000010b919:	48 89 c7             	mov    %rax,%rdi
ffff80000010b91c:	48 b8 39 b3 10 00 00 	movabs $0xffff80000010b339,%rax
ffff80000010b923:	80 ff ff 
ffff80000010b926:	ff d0                	call   *%rax
ffff80000010b928:	48 ba 58 5d 12 00 00 	movabs $0xffff800000125d58,%rdx
ffff80000010b92f:	80 ff ff 
ffff80000010b932:	48 8b 12             	mov    (%rdx),%rdx
ffff80000010b935:	48 81 c2 00 08 00 00 	add    $0x800,%rdx
ffff80000010b93c:	48 83 c8 03          	or     $0x3,%rax
ffff80000010b940:	48 89 02             	mov    %rax,(%rdx)

  // direct map first GB of physical addresses to KERNBASE
  kpdpt[0] = 0 | PTE_PS | PTE_P | PTE_W;
ffff80000010b943:	48 b8 60 5d 12 00 00 	movabs $0xffff800000125d60,%rax
ffff80000010b94a:	80 ff ff 
ffff80000010b94d:	48 8b 00             	mov    (%rax),%rax
ffff80000010b950:	48 c7 00 83 00 00 00 	movq   $0x83,(%rax)

  // direct map 4th GB of physical addresses to KERNBASE+3GB
  // this is a very lazy way to map IO memory (for lapic and ioapic)
  // PTE_PWT and PTE_PCD for memory mapped I/O correctness.
  kpdpt[3] = 0xC0000000 | PTE_PS | PTE_P | PTE_W | PTE_PWT | PTE_PCD;
ffff80000010b957:	48 b8 60 5d 12 00 00 	movabs $0xffff800000125d60,%rax
ffff80000010b95e:	80 ff ff 
ffff80000010b961:	48 8b 00             	mov    (%rax),%rax
ffff80000010b964:	48 83 c0 18          	add    $0x18,%rax
ffff80000010b968:	b9 9b 00 00 c0       	mov    $0xc000009b,%ecx
ffff80000010b96d:	48 89 08             	mov    %rcx,(%rax)

  switchkvm();
ffff80000010b970:	48 b8 8b bc 10 00 00 	movabs $0xffff80000010bc8b,%rax
ffff80000010b977:	80 ff ff 
ffff80000010b97a:	ff d0                	call   *%rax
}
ffff80000010b97c:	90                   	nop
ffff80000010b97d:	5d                   	pop    %rbp
ffff80000010b97e:	c3                   	ret

ffff80000010b97f <switchuvm>:

void
switchuvm(struct proc *p)
{
ffff80000010b97f:	55                   	push   %rbp
ffff80000010b980:	48 89 e5             	mov    %rsp,%rbp
ffff80000010b983:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010b987:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  pushcli();
ffff80000010b98b:	48 b8 1d 7e 10 00 00 	movabs $0xffff800000107e1d,%rax
ffff80000010b992:	80 ff ff 
ffff80000010b995:	ff d0                	call   *%rax
  if(p->pgdir == 0)
ffff80000010b997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b99b:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010b99f:	48 85 c0             	test   %rax,%rax
ffff80000010b9a2:	75 19                	jne    ffff80000010b9bd <switchuvm+0x3e>
    panic("switchuvm: no pgdir");
ffff80000010b9a4:	48 b8 e0 cd 10 00 00 	movabs $0xffff80000010cde0,%rax
ffff80000010b9ab:	80 ff ff 
ffff80000010b9ae:	48 89 c7             	mov    %rax,%rdi
ffff80000010b9b1:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010b9b8:	80 ff ff 
ffff80000010b9bb:	ff d0                	call   *%rax
  uint *tss = (uint*) (((char*) cpu->local) + 1024);
ffff80000010b9bd:	64 48 8b 04 25 f0 ff 	mov    %fs:0xfffffffffffffff0,%rax
ffff80000010b9c4:	ff ff 
ffff80000010b9c6:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff80000010b9ca:	48 05 00 04 00 00    	add    $0x400,%rax
ffff80000010b9d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  const addr_t stktop = (addr_t)p->kstack + KSTACKSIZE;
ffff80000010b9d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010b9d8:	48 8b 40 10          	mov    0x10(%rax),%rax
ffff80000010b9dc:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010b9e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  tss[1] = (uint)stktop; // https://wiki.osdev.org/Task_State_Segment
ffff80000010b9e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010b9ea:	48 83 c0 04          	add    $0x4,%rax
ffff80000010b9ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010b9f2:	89 10                	mov    %edx,(%rax)
  tss[2] = (uint)(stktop >> 32);
ffff80000010b9f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010b9f8:	48 c1 e8 20          	shr    $0x20,%rax
ffff80000010b9fc:	48 89 c2             	mov    %rax,%rdx
ffff80000010b9ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010ba03:	48 83 c0 08          	add    $0x8,%rax
ffff80000010ba07:	89 10                	mov    %edx,(%rax)
  lcr3(v2p(p->pgdir));
ffff80000010ba09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010ba0d:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010ba11:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba14:	48 b8 39 b3 10 00 00 	movabs $0xffff80000010b339,%rax
ffff80000010ba1b:	80 ff ff 
ffff80000010ba1e:	ff d0                	call   *%rax
ffff80000010ba20:	48 89 c7             	mov    %rax,%rdi
ffff80000010ba23:	48 b8 23 b3 10 00 00 	movabs $0xffff80000010b323,%rax
ffff80000010ba2a:	80 ff ff 
ffff80000010ba2d:	ff d0                	call   *%rax
  popcli();
ffff80000010ba2f:	48 b8 8b 7e 10 00 00 	movabs $0xffff800000107e8b,%rax
ffff80000010ba36:	80 ff ff 
ffff80000010ba39:	ff d0                	call   *%rax
}
ffff80000010ba3b:	90                   	nop
ffff80000010ba3c:	c9                   	leave
ffff80000010ba3d:	c3                   	ret

ffff80000010ba3e <walkpgdir>:
// In 64-bit mode, the page table has four levels: PML4, PDPT, PD and PT
// For each level, we dereference the correct entry, or allocate and
// initialize entry if the PTE_P bit is not set
static pte_t *
walkpgdir(pde_t *pml4, const void *va, int alloc)
{
ffff80000010ba3e:	55                   	push   %rbp
ffff80000010ba3f:	48 89 e5             	mov    %rsp,%rbp
ffff80000010ba42:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010ba46:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010ba4a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
ffff80000010ba4e:	89 55 bc             	mov    %edx,-0x44(%rbp)
  pml4e_t *pml4e;
  pdpe_t *pdp, *pdpe;
  pde_t *pde, *pd, *pgtab;

  // from the PML4, find or allocate the appropriate PDP table
  pml4e = &pml4[PMX(va)];
ffff80000010ba51:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010ba55:	48 c1 e8 27          	shr    $0x27,%rax
ffff80000010ba59:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010ba5e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010ba65:	00 
ffff80000010ba66:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010ba6a:	48 01 d0             	add    %rdx,%rax
ffff80000010ba6d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  if(*pml4e & PTE_P)
ffff80000010ba71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010ba75:	48 8b 00             	mov    (%rax),%rax
ffff80000010ba78:	83 e0 01             	and    $0x1,%eax
ffff80000010ba7b:	48 85 c0             	test   %rax,%rax
ffff80000010ba7e:	74 23                	je     ffff80000010baa3 <walkpgdir+0x65>
    pdp = (pdpe_t*)P2V(PTE_ADDR(*pml4e));
ffff80000010ba80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010ba84:	48 8b 00             	mov    (%rax),%rax
ffff80000010ba87:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010ba8d:	48 89 c2             	mov    %rax,%rdx
ffff80000010ba90:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010ba97:	80 ff ff 
ffff80000010ba9a:	48 01 d0             	add    %rdx,%rax
ffff80000010ba9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010baa1:	eb 63                	jmp    ffff80000010bb06 <walkpgdir+0xc8>
  else {
    if(!alloc || (pdp = (pdpe_t*)kalloc()) == 0)
ffff80000010baa3:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010baa7:	74 17                	je     ffff80000010bac0 <walkpgdir+0x82>
ffff80000010baa9:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010bab0:	80 ff ff 
ffff80000010bab3:	ff d0                	call   *%rax
ffff80000010bab5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010bab9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010babe:	75 0a                	jne    ffff80000010baca <walkpgdir+0x8c>
      return 0;
ffff80000010bac0:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bac5:	e9 bf 01 00 00       	jmp    ffff80000010bc89 <walkpgdir+0x24b>
    memset(pdp, 0, PGSIZE);
ffff80000010baca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bace:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bad3:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bad8:	48 89 c7             	mov    %rax,%rdi
ffff80000010badb:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010bae2:	80 ff ff 
ffff80000010bae5:	ff d0                	call   *%rax
    *pml4e = V2P(pdp) | PTE_P | PTE_W | PTE_U;
ffff80000010bae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010baeb:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010baf2:	80 00 00 
ffff80000010baf5:	48 01 d0             	add    %rdx,%rax
ffff80000010baf8:	48 83 c8 07          	or     $0x7,%rax
ffff80000010bafc:	48 89 c2             	mov    %rax,%rdx
ffff80000010baff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bb03:	48 89 10             	mov    %rdx,(%rax)
  }

  //from the PDP, find or allocate the appropriate PD (page directory)
  pdpe = &pdp[PDPX(va)];
ffff80000010bb06:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010bb0a:	48 c1 e8 1e          	shr    $0x1e,%rax
ffff80000010bb0e:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010bb13:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bb1a:	00 
ffff80000010bb1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bb1f:	48 01 d0             	add    %rdx,%rax
ffff80000010bb22:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(*pdpe & PTE_P)
ffff80000010bb26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bb2a:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb2d:	83 e0 01             	and    $0x1,%eax
ffff80000010bb30:	48 85 c0             	test   %rax,%rax
ffff80000010bb33:	74 23                	je     ffff80000010bb58 <walkpgdir+0x11a>
    pd = (pde_t*)P2V(PTE_ADDR(*pdpe));
ffff80000010bb35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bb39:	48 8b 00             	mov    (%rax),%rax
ffff80000010bb3c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bb42:	48 89 c2             	mov    %rax,%rdx
ffff80000010bb45:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bb4c:	80 ff ff 
ffff80000010bb4f:	48 01 d0             	add    %rdx,%rax
ffff80000010bb52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bb56:	eb 63                	jmp    ffff80000010bbbb <walkpgdir+0x17d>
  else {
    if(!alloc || (pd = (pde_t*)kalloc()) == 0)//allocate page table
ffff80000010bb58:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010bb5c:	74 17                	je     ffff80000010bb75 <walkpgdir+0x137>
ffff80000010bb5e:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010bb65:	80 ff ff 
ffff80000010bb68:	ff d0                	call   *%rax
ffff80000010bb6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bb6e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bb73:	75 0a                	jne    ffff80000010bb7f <walkpgdir+0x141>
      return 0;
ffff80000010bb75:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bb7a:	e9 0a 01 00 00       	jmp    ffff80000010bc89 <walkpgdir+0x24b>
    memset(pd, 0, PGSIZE);
ffff80000010bb7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bb83:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bb88:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bb8d:	48 89 c7             	mov    %rax,%rdi
ffff80000010bb90:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010bb97:	80 ff ff 
ffff80000010bb9a:	ff d0                	call   *%rax
    *pdpe = V2P(pd) | PTE_P | PTE_W | PTE_U;
ffff80000010bb9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bba0:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bba7:	80 00 00 
ffff80000010bbaa:	48 01 d0             	add    %rdx,%rax
ffff80000010bbad:	48 83 c8 07          	or     $0x7,%rax
ffff80000010bbb1:	48 89 c2             	mov    %rax,%rdx
ffff80000010bbb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bbb8:	48 89 10             	mov    %rdx,(%rax)
  }

  // from the PD, find or allocate the appropriate page table
  pde = &pd[PDX(va)];
ffff80000010bbbb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010bbbf:	48 c1 e8 15          	shr    $0x15,%rax
ffff80000010bbc3:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010bbc8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bbcf:	00 
ffff80000010bbd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010bbd4:	48 01 d0             	add    %rdx,%rax
ffff80000010bbd7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  if(*pde & PTE_P)
ffff80000010bbdb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bbdf:	48 8b 00             	mov    (%rax),%rax
ffff80000010bbe2:	83 e0 01             	and    $0x1,%eax
ffff80000010bbe5:	48 85 c0             	test   %rax,%rax
ffff80000010bbe8:	74 23                	je     ffff80000010bc0d <walkpgdir+0x1cf>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
ffff80000010bbea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bbee:	48 8b 00             	mov    (%rax),%rax
ffff80000010bbf1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bbf7:	48 89 c2             	mov    %rax,%rdx
ffff80000010bbfa:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010bc01:	80 ff ff 
ffff80000010bc04:	48 01 d0             	add    %rdx,%rax
ffff80000010bc07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bc0b:	eb 60                	jmp    ffff80000010bc6d <walkpgdir+0x22f>
  else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)//allocate page table
ffff80000010bc0d:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
ffff80000010bc11:	74 17                	je     ffff80000010bc2a <walkpgdir+0x1ec>
ffff80000010bc13:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010bc1a:	80 ff ff 
ffff80000010bc1d:	ff d0                	call   *%rax
ffff80000010bc1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bc23:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bc28:	75 07                	jne    ffff80000010bc31 <walkpgdir+0x1f3>
      return 0;
ffff80000010bc2a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bc2f:	eb 58                	jmp    ffff80000010bc89 <walkpgdir+0x24b>
    memset(pgtab, 0, PGSIZE);
ffff80000010bc31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bc35:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bc3a:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bc3f:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc42:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010bc49:	80 ff ff 
ffff80000010bc4c:	ff d0                	call   *%rax
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
ffff80000010bc4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bc52:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010bc59:	80 00 00 
ffff80000010bc5c:	48 01 d0             	add    %rdx,%rax
ffff80000010bc5f:	48 83 c8 07          	or     $0x7,%rax
ffff80000010bc63:	48 89 c2             	mov    %rax,%rdx
ffff80000010bc66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bc6a:	48 89 10             	mov    %rdx,(%rax)
  }

  return &pgtab[PTX(va)];
ffff80000010bc6d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010bc71:	48 c1 e8 0c          	shr    $0xc,%rax
ffff80000010bc75:	25 ff 01 00 00       	and    $0x1ff,%eax
ffff80000010bc7a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010bc81:	00 
ffff80000010bc82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bc86:	48 01 d0             	add    %rdx,%rax
}
ffff80000010bc89:	c9                   	leave
ffff80000010bc8a:	c3                   	ret

ffff80000010bc8b <switchkvm>:

void
switchkvm(void)
{
ffff80000010bc8b:	55                   	push   %rbp
ffff80000010bc8c:	48 89 e5             	mov    %rsp,%rbp
  lcr3(v2p(kpml4));
ffff80000010bc8f:	48 b8 58 5d 12 00 00 	movabs $0xffff800000125d58,%rax
ffff80000010bc96:	80 ff ff 
ffff80000010bc99:	48 8b 00             	mov    (%rax),%rax
ffff80000010bc9c:	48 89 c7             	mov    %rax,%rdi
ffff80000010bc9f:	48 b8 39 b3 10 00 00 	movabs $0xffff80000010b339,%rax
ffff80000010bca6:	80 ff ff 
ffff80000010bca9:	ff d0                	call   *%rax
ffff80000010bcab:	48 89 c7             	mov    %rax,%rdi
ffff80000010bcae:	48 b8 23 b3 10 00 00 	movabs $0xffff80000010b323,%rax
ffff80000010bcb5:	80 ff ff 
ffff80000010bcb8:	ff d0                	call   *%rax
}
ffff80000010bcba:	90                   	nop
ffff80000010bcbb:	5d                   	pop    %rbp
ffff80000010bcbc:	c3                   	ret

ffff80000010bcbd <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, addr_t size, addr_t pa, int perm)
{
ffff80000010bcbd:	55                   	push   %rbp
ffff80000010bcbe:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bcc1:	48 83 ec 50          	sub    $0x50,%rsp
ffff80000010bcc5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010bcc9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010bccd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010bcd1:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffff80000010bcd5:	44 89 45 bc          	mov    %r8d,-0x44(%rbp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((addr_t)va);
ffff80000010bcd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bcdd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bce3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  last = (char*)PGROUNDDOWN(((addr_t)va) + size - 1);
ffff80000010bce7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff80000010bceb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bcef:	48 01 d0             	add    %rdx,%rax
ffff80000010bcf2:	48 83 e8 01          	sub    $0x1,%rax
ffff80000010bcf6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bcfc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010bd00:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010bd04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bd08:	ba 01 00 00 00       	mov    $0x1,%edx
ffff80000010bd0d:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bd10:	48 89 c7             	mov    %rax,%rdi
ffff80000010bd13:	48 b8 3e ba 10 00 00 	movabs $0xffff80000010ba3e,%rax
ffff80000010bd1a:	80 ff ff 
ffff80000010bd1d:	ff d0                	call   *%rax
ffff80000010bd1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010bd23:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010bd28:	75 07                	jne    ffff80000010bd31 <mappages+0x74>
      return -1;
ffff80000010bd2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010bd2f:	eb 64                	jmp    ffff80000010bd95 <mappages+0xd8>
    if(*pte & PTE_P)
ffff80000010bd31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bd35:	48 8b 00             	mov    (%rax),%rax
ffff80000010bd38:	83 e0 01             	and    $0x1,%eax
ffff80000010bd3b:	48 85 c0             	test   %rax,%rax
ffff80000010bd3e:	74 19                	je     ffff80000010bd59 <mappages+0x9c>
      panic("remap");
ffff80000010bd40:	48 b8 f4 cd 10 00 00 	movabs $0xffff80000010cdf4,%rax
ffff80000010bd47:	80 ff ff 
ffff80000010bd4a:	48 89 c7             	mov    %rax,%rdi
ffff80000010bd4d:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010bd54:	80 ff ff 
ffff80000010bd57:	ff d0                	call   *%rax
    *pte = pa | perm | PTE_P;
ffff80000010bd59:	8b 45 bc             	mov    -0x44(%rbp),%eax
ffff80000010bd5c:	48 98                	cltq
ffff80000010bd5e:	48 0b 45 c0          	or     -0x40(%rbp),%rax
ffff80000010bd62:	48 83 c8 01          	or     $0x1,%rax
ffff80000010bd66:	48 89 c2             	mov    %rax,%rdx
ffff80000010bd69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bd6d:	48 89 10             	mov    %rdx,(%rax)
    if(a == last)
ffff80000010bd70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bd74:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffff80000010bd78:	74 15                	je     ffff80000010bd8f <mappages+0xd2>
      break;
    a += PGSIZE;
ffff80000010bd7a:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010bd81:	00 
    pa += PGSIZE;
ffff80000010bd82:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
ffff80000010bd89:	00 
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffff80000010bd8a:	e9 71 ff ff ff       	jmp    ffff80000010bd00 <mappages+0x43>
      break;
ffff80000010bd8f:	90                   	nop
  }
  return 0;
ffff80000010bd90:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010bd95:	c9                   	leave
ffff80000010bd96:	c3                   	ret

ffff80000010bd97 <inituvm>:

// Load the initcode into address 0x1000 (4KB) of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
ffff80000010bd97:	55                   	push   %rbp
ffff80000010bd98:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bd9b:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010bd9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010bda3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010bda7:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *mem;

  if(sz >= PGSIZE)
ffff80000010bdaa:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%rbp)
ffff80000010bdb1:	76 19                	jbe    ffff80000010bdcc <inituvm+0x35>
    panic("inituvm: more than a page");
ffff80000010bdb3:	48 b8 fa cd 10 00 00 	movabs $0xffff80000010cdfa,%rax
ffff80000010bdba:	80 ff ff 
ffff80000010bdbd:	48 89 c7             	mov    %rax,%rdi
ffff80000010bdc0:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010bdc7:	80 ff ff 
ffff80000010bdca:	ff d0                	call   *%rax

  mem = kalloc();
ffff80000010bdcc:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010bdd3:	80 ff ff 
ffff80000010bdd6:	ff d0                	call   *%rax
ffff80000010bdd8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(mem, 0, PGSIZE);
ffff80000010bddc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bde0:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010bde5:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010bdea:	48 89 c7             	mov    %rax,%rdi
ffff80000010bded:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010bdf4:	80 ff ff 
ffff80000010bdf7:	ff d0                	call   *%rax
  mappages(pgdir, (void *)PGSIZE, PGSIZE, V2P(mem), PTE_W|PTE_U);
ffff80000010bdf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010bdfd:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010be04:	80 00 00 
ffff80000010be07:	48 01 c2             	add    %rax,%rdx
ffff80000010be0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010be0e:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010be14:	48 89 d1             	mov    %rdx,%rcx
ffff80000010be17:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010be1c:	be 00 10 00 00       	mov    $0x1000,%esi
ffff80000010be21:	48 89 c7             	mov    %rax,%rdi
ffff80000010be24:	48 b8 bd bc 10 00 00 	movabs $0xffff80000010bcbd,%rax
ffff80000010be2b:	80 ff ff 
ffff80000010be2e:	ff d0                	call   *%rax

  memmove(mem, init, sz);
ffff80000010be30:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff80000010be33:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010be37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010be3b:	48 89 ce             	mov    %rcx,%rsi
ffff80000010be3e:	48 89 c7             	mov    %rax,%rdi
ffff80000010be41:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff80000010be48:	80 ff ff 
ffff80000010be4b:	ff d0                	call   *%rax
}
ffff80000010be4d:	90                   	nop
ffff80000010be4e:	c9                   	leave
ffff80000010be4f:	c3                   	ret

ffff80000010be50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
ffff80000010be50:	55                   	push   %rbp
ffff80000010be51:	48 89 e5             	mov    %rsp,%rbp
ffff80000010be54:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010be58:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010be5c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010be60:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010be64:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
ffff80000010be67:	44 89 45 c0          	mov    %r8d,-0x40(%rbp)
  uint i, n;
  addr_t pa;
  pte_t *pte;

  if((addr_t) addr % PGSIZE != 0)
ffff80000010be6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010be6f:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010be74:	48 85 c0             	test   %rax,%rax
ffff80000010be77:	74 19                	je     ffff80000010be92 <loaduvm+0x42>
    panic("loaduvm: addr must be page aligned");
ffff80000010be79:	48 b8 18 ce 10 00 00 	movabs $0xffff80000010ce18,%rax
ffff80000010be80:	80 ff ff 
ffff80000010be83:	48 89 c7             	mov    %rax,%rdi
ffff80000010be86:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010be8d:	80 ff ff 
ffff80000010be90:	ff d0                	call   *%rax
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010be92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010be99:	e9 c7 00 00 00       	jmp    ffff80000010bf65 <loaduvm+0x115>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
ffff80000010be9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff80000010bea1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010bea5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010bea9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bead:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010beb2:	48 89 ce             	mov    %rcx,%rsi
ffff80000010beb5:	48 89 c7             	mov    %rax,%rdi
ffff80000010beb8:	48 b8 3e ba 10 00 00 	movabs $0xffff80000010ba3e,%rax
ffff80000010bebf:	80 ff ff 
ffff80000010bec2:	ff d0                	call   *%rax
ffff80000010bec4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010bec8:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010becd:	75 19                	jne    ffff80000010bee8 <loaduvm+0x98>
      panic("loaduvm: address should exist");
ffff80000010becf:	48 b8 3b ce 10 00 00 	movabs $0xffff80000010ce3b,%rax
ffff80000010bed6:	80 ff ff 
ffff80000010bed9:	48 89 c7             	mov    %rax,%rdi
ffff80000010bedc:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010bee3:	80 ff ff 
ffff80000010bee6:	ff d0                	call   *%rax
    pa = PTE_ADDR(*pte);
ffff80000010bee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010beec:	48 8b 00             	mov    (%rax),%rax
ffff80000010beef:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bef5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(sz - i < PGSIZE)
ffff80000010bef9:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010befc:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010beff:	3d ff 0f 00 00       	cmp    $0xfff,%eax
ffff80000010bf04:	77 0b                	ja     ffff80000010bf11 <loaduvm+0xc1>
      n = sz - i;
ffff80000010bf06:	8b 45 c0             	mov    -0x40(%rbp),%eax
ffff80000010bf09:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffff80000010bf0c:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffff80000010bf0f:	eb 07                	jmp    ffff80000010bf18 <loaduvm+0xc8>
    else
      n = PGSIZE;
ffff80000010bf11:	c7 45 f8 00 10 00 00 	movl   $0x1000,-0x8(%rbp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
ffff80000010bf18:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff80000010bf1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bf1e:	8d 34 02             	lea    (%rdx,%rax,1),%esi
ffff80000010bf21:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010bf28:	80 ff ff 
ffff80000010bf2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bf2f:	48 01 d0             	add    %rdx,%rax
ffff80000010bf32:	48 89 c7             	mov    %rax,%rdi
ffff80000010bf35:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffff80000010bf38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010bf3c:	89 d1                	mov    %edx,%ecx
ffff80000010bf3e:	89 f2                	mov    %esi,%edx
ffff80000010bf40:	48 89 fe             	mov    %rdi,%rsi
ffff80000010bf43:	48 89 c7             	mov    %rax,%rdi
ffff80000010bf46:	48 b8 f5 2e 10 00 00 	movabs $0xffff800000102ef5,%rax
ffff80000010bf4d:	80 ff ff 
ffff80000010bf50:	ff d0                	call   *%rax
ffff80000010bf52:	39 45 f8             	cmp    %eax,-0x8(%rbp)
ffff80000010bf55:	74 07                	je     ffff80000010bf5e <loaduvm+0x10e>
      return -1;
ffff80000010bf57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010bf5c:	eb 18                	jmp    ffff80000010bf76 <loaduvm+0x126>
  for(i = 0; i < sz; i += PGSIZE){
ffff80000010bf5e:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffff80000010bf65:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010bf68:	3b 45 c0             	cmp    -0x40(%rbp),%eax
ffff80000010bf6b:	0f 82 2d ff ff ff    	jb     ffff80000010be9e <loaduvm+0x4e>
  }
  return 0;
ffff80000010bf71:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010bf76:	c9                   	leave
ffff80000010bf77:	c3                   	ret

ffff80000010bf78 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
allocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010bf78:	55                   	push   %rbp
ffff80000010bf79:	48 89 e5             	mov    %rsp,%rbp
ffff80000010bf7c:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010bf80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010bf84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010bf88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  char *mem;
  addr_t a;

  if(newsz >= KERNBASE)
ffff80000010bf8c:	48 b8 ff ff ff ff ff 	movabs $0xffff7fffffffffff,%rax
ffff80000010bf93:	7f ff ff 
ffff80000010bf96:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010bf9a:	73 0a                	jae    ffff80000010bfa6 <allocuvm+0x2e>
    return 0;
ffff80000010bf9c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010bfa1:	e9 14 01 00 00       	jmp    ffff80000010c0ba <allocuvm+0x142>
  if(newsz < oldsz)
ffff80000010bfa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010bfaa:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
ffff80000010bfae:	73 09                	jae    ffff80000010bfb9 <allocuvm+0x41>
    return oldsz;
ffff80000010bfb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bfb4:	e9 01 01 00 00       	jmp    ffff80000010c0ba <allocuvm+0x142>

  a = PGROUNDUP(oldsz);
ffff80000010bfb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010bfbd:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010bfc3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010bfc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a < newsz; a += PGSIZE){
ffff80000010bfcd:	e9 d6 00 00 00       	jmp    ffff80000010c0a8 <allocuvm+0x130>
    mem = kalloc();
ffff80000010bfd2:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010bfd9:	80 ff ff 
ffff80000010bfdc:	ff d0                	call   *%rax
ffff80000010bfde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(mem == 0){
ffff80000010bfe2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010bfe7:	75 28                	jne    ffff80000010c011 <allocuvm+0x99>
      //cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010bfe9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010bfed:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010bff1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010bff5:	48 89 ce             	mov    %rcx,%rsi
ffff80000010bff8:	48 89 c7             	mov    %rax,%rdi
ffff80000010bffb:	48 b8 bc c0 10 00 00 	movabs $0xffff80000010c0bc,%rax
ffff80000010c002:	80 ff ff 
ffff80000010c005:	ff d0                	call   *%rax
      return 0;
ffff80000010c007:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c00c:	e9 a9 00 00 00       	jmp    ffff80000010c0ba <allocuvm+0x142>
    }
    memset(mem, 0, PGSIZE);
ffff80000010c011:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c015:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c01a:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010c01f:	48 89 c7             	mov    %rax,%rdi
ffff80000010c022:	48 b8 91 7f 10 00 00 	movabs $0xffff800000107f91,%rax
ffff80000010c029:	80 ff ff 
ffff80000010c02c:	ff d0                	call   *%rax
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
ffff80000010c02e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c032:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c039:	80 00 00 
ffff80000010c03c:	48 01 c2             	add    %rax,%rdx
ffff80000010c03f:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010c043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c047:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffff80000010c04d:	48 89 d1             	mov    %rdx,%rcx
ffff80000010c050:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c055:	48 89 c7             	mov    %rax,%rdi
ffff80000010c058:	48 b8 bd bc 10 00 00 	movabs $0xffff80000010bcbd,%rax
ffff80000010c05f:	80 ff ff 
ffff80000010c062:	ff d0                	call   *%rax
ffff80000010c064:	85 c0                	test   %eax,%eax
ffff80000010c066:	79 38                	jns    ffff80000010c0a0 <allocuvm+0x128>
      //cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
ffff80000010c068:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff80000010c06c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffff80000010c070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c074:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c077:	48 89 c7             	mov    %rax,%rdi
ffff80000010c07a:	48 b8 bc c0 10 00 00 	movabs $0xffff80000010c0bc,%rax
ffff80000010c081:	80 ff ff 
ffff80000010c084:	ff d0                	call   *%rax
      kfree(mem);
ffff80000010c086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c08a:	48 89 c7             	mov    %rax,%rdi
ffff80000010c08d:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff80000010c094:	80 ff ff 
ffff80000010c097:	ff d0                	call   *%rax
      return 0;
ffff80000010c099:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c09e:	eb 1a                	jmp    ffff80000010c0ba <allocuvm+0x142>
  for(; a < newsz; a += PGSIZE){
ffff80000010c0a0:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c0a7:	00 
ffff80000010c0a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c0ac:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010c0b0:	0f 82 1c ff ff ff    	jb     ffff80000010bfd2 <allocuvm+0x5a>
    }
  }
  return newsz;
ffff80000010c0b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
}
ffff80000010c0ba:	c9                   	leave
ffff80000010c0bb:	c3                   	ret

ffff80000010c0bc <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
deallocuvm(pde_t *pgdir, uint64 oldsz, uint64 newsz)
{
ffff80000010c0bc:	55                   	push   %rbp
ffff80000010c0bd:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c0c0:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c0c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010c0c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010c0cc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  pte_t *pte;
  addr_t a, pa;

  if(newsz >= oldsz)
ffff80000010c0d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c0d4:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010c0d8:	72 09                	jb     ffff80000010c0e3 <deallocuvm+0x27>
    return oldsz;
ffff80000010c0da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c0de:	e9 d0 00 00 00       	jmp    ffff80000010c1b3 <deallocuvm+0xf7>

  a = PGROUNDUP(newsz);
ffff80000010c0e3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c0e7:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff80000010c0ed:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c0f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010c0f7:	e9 a5 00 00 00       	jmp    ffff80000010c1a1 <deallocuvm+0xe5>
    pte = walkpgdir(pgdir, (char*)a, 0);
ffff80000010c0fc:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010c100:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c104:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c109:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c10c:	48 89 c7             	mov    %rax,%rdi
ffff80000010c10f:	48 b8 3e ba 10 00 00 	movabs $0xffff80000010ba3e,%rax
ffff80000010c116:	80 ff ff 
ffff80000010c119:	ff d0                	call   *%rax
ffff80000010c11b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(pte && (*pte & PTE_P) != 0){
ffff80000010c11f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010c124:	74 73                	je     ffff80000010c199 <deallocuvm+0xdd>
ffff80000010c126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c12a:	48 8b 00             	mov    (%rax),%rax
ffff80000010c12d:	83 e0 01             	and    $0x1,%eax
ffff80000010c130:	48 85 c0             	test   %rax,%rax
ffff80000010c133:	74 64                	je     ffff80000010c199 <deallocuvm+0xdd>
      pa = PTE_ADDR(*pte);
ffff80000010c135:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c139:	48 8b 00             	mov    (%rax),%rax
ffff80000010c13c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c142:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      if(pa == 0)
ffff80000010c146:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010c14b:	75 19                	jne    ffff80000010c166 <deallocuvm+0xaa>
        panic("kfree");
ffff80000010c14d:	48 b8 59 ce 10 00 00 	movabs $0xffff80000010ce59,%rax
ffff80000010c154:	80 ff ff 
ffff80000010c157:	48 89 c7             	mov    %rax,%rdi
ffff80000010c15a:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010c161:	80 ff ff 
ffff80000010c164:	ff d0                	call   *%rax
      char *v = P2V(pa);
ffff80000010c166:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010c16d:	80 ff ff 
ffff80000010c170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c174:	48 01 d0             	add    %rdx,%rax
ffff80000010c177:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      kfree(v);
ffff80000010c17b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c17f:	48 89 c7             	mov    %rax,%rdi
ffff80000010c182:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff80000010c189:	80 ff ff 
ffff80000010c18c:	ff d0                	call   *%rax
      *pte = 0;
ffff80000010c18e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c192:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  for(; a  < oldsz; a += PGSIZE){
ffff80000010c199:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c1a0:	00 
ffff80000010c1a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c1a5:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffff80000010c1a9:	0f 82 4d ff ff ff    	jb     ffff80000010c0fc <deallocuvm+0x40>
    }
  }
  return newsz;
ffff80000010c1af:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
ffff80000010c1b3:	c9                   	leave
ffff80000010c1b4:	c3                   	ret

ffff80000010c1b5 <freevm>:

// Free all the pages mapped by, and all the memory used for,
// this page table
void
freevm(pml4e_t *pml4)
{
ffff80000010c1b5:	55                   	push   %rbp
ffff80000010c1b6:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c1b9:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c1bd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  uint i, j, k, l;
  pde_t *pdp, *pd, *pt;

  if(pml4 == 0)
ffff80000010c1c1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffff80000010c1c6:	75 19                	jne    ffff80000010c1e1 <freevm+0x2c>
    panic("freevm: no pgdir");
ffff80000010c1c8:	48 b8 5f ce 10 00 00 	movabs $0xffff80000010ce5f,%rax
ffff80000010c1cf:	80 ff ff 
ffff80000010c1d2:	48 89 c7             	mov    %rax,%rdi
ffff80000010c1d5:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010c1dc:	80 ff ff 
ffff80000010c1df:	ff d0                	call   *%rax

  // then need to loop through pml4 entry
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010c1e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010c1e8:	e9 dc 01 00 00       	jmp    ffff80000010c3c9 <freevm+0x214>
    if(pml4[i] & PTE_P){
ffff80000010c1ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010c1f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c1f7:	00 
ffff80000010c1f8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c1fc:	48 01 d0             	add    %rdx,%rax
ffff80000010c1ff:	48 8b 00             	mov    (%rax),%rax
ffff80000010c202:	83 e0 01             	and    $0x1,%eax
ffff80000010c205:	48 85 c0             	test   %rax,%rax
ffff80000010c208:	0f 84 b7 01 00 00    	je     ffff80000010c3c5 <freevm+0x210>
      pdp = (pdpe_t*)P2V(PTE_ADDR(pml4[i]));
ffff80000010c20e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010c211:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c218:	00 
ffff80000010c219:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c21d:	48 01 d0             	add    %rdx,%rax
ffff80000010c220:	48 8b 00             	mov    (%rax),%rax
ffff80000010c223:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c229:	48 89 c2             	mov    %rax,%rdx
ffff80000010c22c:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c233:	80 ff ff 
ffff80000010c236:	48 01 d0             	add    %rdx,%rax
ffff80000010c239:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

      // and every entry in the corresponding pdpt
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010c23d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff80000010c244:	e9 5c 01 00 00       	jmp    ffff80000010c3a5 <freevm+0x1f0>
        if(pdp[j] & PTE_P){
ffff80000010c249:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010c24c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c253:	00 
ffff80000010c254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c258:	48 01 d0             	add    %rdx,%rax
ffff80000010c25b:	48 8b 00             	mov    (%rax),%rax
ffff80000010c25e:	83 e0 01             	and    $0x1,%eax
ffff80000010c261:	48 85 c0             	test   %rax,%rax
ffff80000010c264:	0f 84 37 01 00 00    	je     ffff80000010c3a1 <freevm+0x1ec>
          pd = (pde_t*)P2V(PTE_ADDR(pdp[j]));
ffff80000010c26a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff80000010c26d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c274:	00 
ffff80000010c275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c279:	48 01 d0             	add    %rdx,%rax
ffff80000010c27c:	48 8b 00             	mov    (%rax),%rax
ffff80000010c27f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c285:	48 89 c2             	mov    %rax,%rdx
ffff80000010c288:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c28f:	80 ff ff 
ffff80000010c292:	48 01 d0             	add    %rdx,%rax
ffff80000010c295:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

          // and every entry in the corresponding page directory
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010c299:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff80000010c2a0:	e9 dc 00 00 00       	jmp    ffff80000010c381 <freevm+0x1cc>
            if(pd[k] & PTE_P) {
ffff80000010c2a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010c2a8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c2af:	00 
ffff80000010c2b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c2b4:	48 01 d0             	add    %rdx,%rax
ffff80000010c2b7:	48 8b 00             	mov    (%rax),%rax
ffff80000010c2ba:	83 e0 01             	and    $0x1,%eax
ffff80000010c2bd:	48 85 c0             	test   %rax,%rax
ffff80000010c2c0:	0f 84 b7 00 00 00    	je     ffff80000010c37d <freevm+0x1c8>
              pt = (pde_t*)P2V(PTE_ADDR(pd[k]));
ffff80000010c2c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff80000010c2c9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c2d0:	00 
ffff80000010c2d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c2d5:	48 01 d0             	add    %rdx,%rax
ffff80000010c2d8:	48 8b 00             	mov    (%rax),%rax
ffff80000010c2db:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c2e1:	48 89 c2             	mov    %rax,%rdx
ffff80000010c2e4:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c2eb:	80 ff ff 
ffff80000010c2ee:	48 01 d0             	add    %rdx,%rax
ffff80000010c2f1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

              // and every entry in the corresponding page table
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010c2f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffff80000010c2fc:	eb 63                	jmp    ffff80000010c361 <freevm+0x1ac>
                if(pt[l] & PTE_P) {
ffff80000010c2fe:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010c301:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c308:	00 
ffff80000010c309:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c30d:	48 01 d0             	add    %rdx,%rax
ffff80000010c310:	48 8b 00             	mov    (%rax),%rax
ffff80000010c313:	83 e0 01             	and    $0x1,%eax
ffff80000010c316:	48 85 c0             	test   %rax,%rax
ffff80000010c319:	74 42                	je     ffff80000010c35d <freevm+0x1a8>
                  char * v = P2V(PTE_ADDR(pt[l]));
ffff80000010c31b:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff80000010c31e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff80000010c325:	00 
ffff80000010c326:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c32a:	48 01 d0             	add    %rdx,%rax
ffff80000010c32d:	48 8b 00             	mov    (%rax),%rax
ffff80000010c330:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c336:	48 89 c2             	mov    %rax,%rdx
ffff80000010c339:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c340:	80 ff ff 
ffff80000010c343:	48 01 d0             	add    %rdx,%rax
ffff80000010c346:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

                  kfree((char*)v);
ffff80000010c34a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c34e:	48 89 c7             	mov    %rax,%rdi
ffff80000010c351:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff80000010c358:	80 ff ff 
ffff80000010c35b:	ff d0                	call   *%rax
              for(l = 0; l < (NPDENTRIES); l++){
ffff80000010c35d:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
ffff80000010c361:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
ffff80000010c368:	76 94                	jbe    ffff80000010c2fe <freevm+0x149>
                }
              }
              //freeing every page table
              kfree((char*)pt);
ffff80000010c36a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c36e:	48 89 c7             	mov    %rax,%rdi
ffff80000010c371:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff80000010c378:	80 ff ff 
ffff80000010c37b:	ff d0                	call   *%rax
          for(k = 0; k < (NPDENTRIES); k++){
ffff80000010c37d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010c381:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
ffff80000010c388:	0f 86 17 ff ff ff    	jbe    ffff80000010c2a5 <freevm+0xf0>
            }
          }
          // freeing every page directory
          kfree((char*)pd);
ffff80000010c38e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c392:	48 89 c7             	mov    %rax,%rdi
ffff80000010c395:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff80000010c39c:	80 ff ff 
ffff80000010c39f:	ff d0                	call   *%rax
      for(j = 0; j < NPDENTRIES; j++){
ffff80000010c3a1:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff80000010c3a5:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
ffff80000010c3ac:	0f 86 97 fe ff ff    	jbe    ffff80000010c249 <freevm+0x94>
        }
      }
      // freeing every page directory pointer table
      kfree((char*)pdp);
ffff80000010c3b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c3b6:	48 89 c7             	mov    %rax,%rdi
ffff80000010c3b9:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff80000010c3c0:	80 ff ff 
ffff80000010c3c3:	ff d0                	call   *%rax
  for(i = 0; i < (NPDENTRIES/2); i++){
ffff80000010c3c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010c3c9:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffff80000010c3d0:	0f 86 17 fe ff ff    	jbe    ffff80000010c1ed <freevm+0x38>
    }
  }
  // freeing the pml4
  kfree((char*)pml4);
ffff80000010c3d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c3da:	48 89 c7             	mov    %rax,%rdi
ffff80000010c3dd:	48 b8 a5 40 10 00 00 	movabs $0xffff8000001040a5,%rax
ffff80000010c3e4:	80 ff ff 
ffff80000010c3e7:	ff d0                	call   *%rax
}
ffff80000010c3e9:	90                   	nop
ffff80000010c3ea:	c9                   	leave
ffff80000010c3eb:	c3                   	ret

ffff80000010c3ec <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pml4e_t *pgdir, char *uva)
{
ffff80000010c3ec:	55                   	push   %rbp
ffff80000010c3ed:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c3f0:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010c3f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010c3f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010c3fc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010c400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c404:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c409:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c40c:	48 89 c7             	mov    %rax,%rdi
ffff80000010c40f:	48 b8 3e ba 10 00 00 	movabs $0xffff80000010ba3e,%rax
ffff80000010c416:	80 ff ff 
ffff80000010c419:	ff d0                	call   *%rax
ffff80000010c41b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(pte == 0)
ffff80000010c41f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffff80000010c424:	75 19                	jne    ffff80000010c43f <clearpteu+0x53>
    panic("clearpteu");
ffff80000010c426:	48 b8 70 ce 10 00 00 	movabs $0xffff80000010ce70,%rax
ffff80000010c42d:	80 ff ff 
ffff80000010c430:	48 89 c7             	mov    %rax,%rdi
ffff80000010c433:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010c43a:	80 ff ff 
ffff80000010c43d:	ff d0                	call   *%rax
  *pte &= ~PTE_U;
ffff80000010c43f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c443:	48 8b 00             	mov    (%rax),%rax
ffff80000010c446:	48 83 e0 fb          	and    $0xfffffffffffffffb,%rax
ffff80000010c44a:	48 89 c2             	mov    %rax,%rdx
ffff80000010c44d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c451:	48 89 10             	mov    %rdx,(%rax)
}
ffff80000010c454:	90                   	nop
ffff80000010c455:	c9                   	leave
ffff80000010c456:	c3                   	ret

ffff80000010c457 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pml4e_t *pgdir, uint sz)
{
ffff80000010c457:	55                   	push   %rbp
ffff80000010c458:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c45b:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c45f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffff80000010c463:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  pde_t *d;
  pte_t *pte;
  addr_t pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
ffff80000010c466:	48 b8 21 b8 10 00 00 	movabs $0xffff80000010b821,%rax
ffff80000010c46d:	80 ff ff 
ffff80000010c470:	ff d0                	call   *%rax
ffff80000010c472:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010c476:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff80000010c47b:	75 0a                	jne    ffff80000010c487 <copyuvm+0x30>
    return 0;
ffff80000010c47d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c482:	e9 57 01 00 00       	jmp    ffff80000010c5de <copyuvm+0x187>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010c487:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
ffff80000010c48e:	00 
ffff80000010c48f:	e9 1b 01 00 00       	jmp    ffff80000010c5af <copyuvm+0x158>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
ffff80000010c494:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffff80000010c498:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c49c:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c4a1:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c4a4:	48 89 c7             	mov    %rax,%rdi
ffff80000010c4a7:	48 b8 3e ba 10 00 00 	movabs $0xffff80000010ba3e,%rax
ffff80000010c4ae:	80 ff ff 
ffff80000010c4b1:	ff d0                	call   *%rax
ffff80000010c4b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010c4b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010c4bc:	75 19                	jne    ffff80000010c4d7 <copyuvm+0x80>
      panic("copyuvm: pte should exist");
ffff80000010c4be:	48 b8 7a ce 10 00 00 	movabs $0xffff80000010ce7a,%rax
ffff80000010c4c5:	80 ff ff 
ffff80000010c4c8:	48 89 c7             	mov    %rax,%rdi
ffff80000010c4cb:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010c4d2:	80 ff ff 
ffff80000010c4d5:	ff d0                	call   *%rax
    if(!(*pte & PTE_P))
ffff80000010c4d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c4db:	48 8b 00             	mov    (%rax),%rax
ffff80000010c4de:	83 e0 01             	and    $0x1,%eax
ffff80000010c4e1:	48 85 c0             	test   %rax,%rax
ffff80000010c4e4:	75 19                	jne    ffff80000010c4ff <copyuvm+0xa8>
      panic("copyuvm: page not present");
ffff80000010c4e6:	48 b8 94 ce 10 00 00 	movabs $0xffff80000010ce94,%rax
ffff80000010c4ed:	80 ff ff 
ffff80000010c4f0:	48 89 c7             	mov    %rax,%rdi
ffff80000010c4f3:	48 b8 ea 0b 10 00 00 	movabs $0xffff800000100bea,%rax
ffff80000010c4fa:	80 ff ff 
ffff80000010c4fd:	ff d0                	call   *%rax
    pa = PTE_ADDR(*pte);
ffff80000010c4ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c503:	48 8b 00             	mov    (%rax),%rax
ffff80000010c506:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c50c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    flags = PTE_FLAGS(*pte);
ffff80000010c510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c514:	48 8b 00             	mov    (%rax),%rax
ffff80000010c517:	25 ff 0f 00 00       	and    $0xfff,%eax
ffff80000010c51c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if((mem = kalloc()) == 0)
ffff80000010c520:	48 b8 a4 41 10 00 00 	movabs $0xffff8000001041a4,%rax
ffff80000010c527:	80 ff ff 
ffff80000010c52a:	ff d0                	call   *%rax
ffff80000010c52c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff80000010c530:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
ffff80000010c535:	0f 84 87 00 00 00    	je     ffff80000010c5c2 <copyuvm+0x16b>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
ffff80000010c53b:	48 ba 00 00 00 00 00 	movabs $0xffff800000000000,%rdx
ffff80000010c542:	80 ff ff 
ffff80000010c545:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c549:	48 01 d0             	add    %rdx,%rax
ffff80000010c54c:	48 89 c1             	mov    %rax,%rcx
ffff80000010c54f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c553:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c558:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c55b:	48 89 c7             	mov    %rax,%rdi
ffff80000010c55e:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff80000010c565:	80 ff ff 
ffff80000010c568:	ff d0                	call   *%rax
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
ffff80000010c56a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c56e:	89 c1                	mov    %eax,%ecx
ffff80000010c570:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c574:	48 ba 00 00 00 00 00 	movabs $0x800000000000,%rdx
ffff80000010c57b:	80 00 00 
ffff80000010c57e:	48 01 c2             	add    %rax,%rdx
ffff80000010c581:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffff80000010c585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c589:	41 89 c8             	mov    %ecx,%r8d
ffff80000010c58c:	48 89 d1             	mov    %rdx,%rcx
ffff80000010c58f:	ba 00 10 00 00       	mov    $0x1000,%edx
ffff80000010c594:	48 89 c7             	mov    %rax,%rdi
ffff80000010c597:	48 b8 bd bc 10 00 00 	movabs $0xffff80000010bcbd,%rax
ffff80000010c59e:	80 ff ff 
ffff80000010c5a1:	ff d0                	call   *%rax
ffff80000010c5a3:	85 c0                	test   %eax,%eax
ffff80000010c5a5:	78 1e                	js     ffff80000010c5c5 <copyuvm+0x16e>
  for(i = PGSIZE; i < sz; i += PGSIZE){
ffff80000010c5a7:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffff80000010c5ae:	00 
ffff80000010c5af:	8b 45 c4             	mov    -0x3c(%rbp),%eax
ffff80000010c5b2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff80000010c5b6:	0f 82 d8 fe ff ff    	jb     ffff80000010c494 <copyuvm+0x3d>
      goto bad;
  }
  return d;
ffff80000010c5bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c5c0:	eb 1c                	jmp    ffff80000010c5de <copyuvm+0x187>
      goto bad;
ffff80000010c5c2:	90                   	nop
ffff80000010c5c3:	eb 01                	jmp    ffff80000010c5c6 <copyuvm+0x16f>
      goto bad;
ffff80000010c5c5:	90                   	nop

bad:
  freevm(d);
ffff80000010c5c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c5ca:	48 89 c7             	mov    %rax,%rdi
ffff80000010c5cd:	48 b8 b5 c1 10 00 00 	movabs $0xffff80000010c1b5,%rax
ffff80000010c5d4:	80 ff ff 
ffff80000010c5d7:	ff d0                	call   *%rax
  return 0;
ffff80000010c5d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c5de:	c9                   	leave
ffff80000010c5df:	c3                   	ret

ffff80000010c5e0 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pml4e_t *pgdir, char *uva)
{
ffff80000010c5e0:	55                   	push   %rbp
ffff80000010c5e1:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c5e4:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010c5e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff80000010c5ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffff80000010c5f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffff80000010c5f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c5f8:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010c5fd:	48 89 ce             	mov    %rcx,%rsi
ffff80000010c600:	48 89 c7             	mov    %rax,%rdi
ffff80000010c603:	48 b8 3e ba 10 00 00 	movabs $0xffff80000010ba3e,%rax
ffff80000010c60a:	80 ff ff 
ffff80000010c60d:	ff d0                	call   *%rax
ffff80000010c60f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((*pte & PTE_P) == 0)
ffff80000010c613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c617:	48 8b 00             	mov    (%rax),%rax
ffff80000010c61a:	83 e0 01             	and    $0x1,%eax
ffff80000010c61d:	48 85 c0             	test   %rax,%rax
ffff80000010c620:	75 07                	jne    ffff80000010c629 <uva2ka+0x49>
    return 0;
ffff80000010c622:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c627:	eb 33                	jmp    ffff80000010c65c <uva2ka+0x7c>
  if((*pte & PTE_U) == 0)
ffff80000010c629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c62d:	48 8b 00             	mov    (%rax),%rax
ffff80000010c630:	83 e0 04             	and    $0x4,%eax
ffff80000010c633:	48 85 c0             	test   %rax,%rax
ffff80000010c636:	75 07                	jne    ffff80000010c63f <uva2ka+0x5f>
    return 0;
ffff80000010c638:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010c63d:	eb 1d                	jmp    ffff80000010c65c <uva2ka+0x7c>
  return (char*)P2V(PTE_ADDR(*pte));
ffff80000010c63f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c643:	48 8b 00             	mov    (%rax),%rax
ffff80000010c646:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c64c:	48 89 c2             	mov    %rax,%rdx
ffff80000010c64f:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
ffff80000010c656:	80 ff ff 
ffff80000010c659:	48 01 d0             	add    %rdx,%rax
}
ffff80000010c65c:	c9                   	leave
ffff80000010c65d:	c3                   	ret

ffff80000010c65e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pml4e_t *pgdir, addr_t va, void *p, uint64 len)
{
ffff80000010c65e:	55                   	push   %rbp
ffff80000010c65f:	48 89 e5             	mov    %rsp,%rbp
ffff80000010c662:	48 83 ec 40          	sub    $0x40,%rsp
ffff80000010c666:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff80000010c66a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffff80000010c66e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffff80000010c672:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  char *buf, *pa0;
  addr_t n, va0;

  buf = (char*)p;
ffff80000010c676:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010c67a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(len > 0){
ffff80000010c67e:	e9 b0 00 00 00       	jmp    ffff80000010c733 <copyout+0xd5>
    va0 = PGROUNDDOWN(va);
ffff80000010c683:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c687:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010c68d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    pa0 = uva2ka(pgdir, (char*)va0);
ffff80000010c691:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff80000010c695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010c699:	48 89 d6             	mov    %rdx,%rsi
ffff80000010c69c:	48 89 c7             	mov    %rax,%rdi
ffff80000010c69f:	48 b8 e0 c5 10 00 00 	movabs $0xffff80000010c5e0,%rax
ffff80000010c6a6:	80 ff ff 
ffff80000010c6a9:	ff d0                	call   *%rax
ffff80000010c6ab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    if(pa0 == 0)
ffff80000010c6af:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffff80000010c6b4:	75 0a                	jne    ffff80000010c6c0 <copyout+0x62>
      return -1;
ffff80000010c6b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffff80000010c6bb:	e9 83 00 00 00       	jmp    ffff80000010c743 <copyout+0xe5>
    n = PGSIZE - (va - va0);
ffff80000010c6c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c6c4:	48 2b 45 d0          	sub    -0x30(%rbp),%rax
ffff80000010c6c8:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c6ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(n > len)
ffff80000010c6d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c6d6:	48 39 45 c0          	cmp    %rax,-0x40(%rbp)
ffff80000010c6da:	73 08                	jae    ffff80000010c6e4 <copyout+0x86>
      n = len;
ffff80000010c6dc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffff80000010c6e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    memmove(pa0 + (va - va0), buf, n);
ffff80000010c6e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c6e8:	89 c6                	mov    %eax,%esi
ffff80000010c6ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010c6ee:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
ffff80000010c6f2:	48 89 c2             	mov    %rax,%rdx
ffff80000010c6f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010c6f9:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff80000010c6fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010c701:	89 f2                	mov    %esi,%edx
ffff80000010c703:	48 89 c6             	mov    %rax,%rsi
ffff80000010c706:	48 89 cf             	mov    %rcx,%rdi
ffff80000010c709:	48 b8 96 80 10 00 00 	movabs $0xffff800000108096,%rax
ffff80000010c710:	80 ff ff 
ffff80000010c713:	ff d0                	call   *%rax
    len -= n;
ffff80000010c715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c719:	48 29 45 c0          	sub    %rax,-0x40(%rbp)
    buf += n;
ffff80000010c71d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010c721:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    va = va0 + PGSIZE;
ffff80000010c725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010c729:	48 05 00 10 00 00    	add    $0x1000,%rax
ffff80000010c72f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  while(len > 0){
ffff80000010c733:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffff80000010c738:	0f 85 45 ff ff ff    	jne    ffff80000010c683 <copyout+0x25>
  }
  return 0;
ffff80000010c73e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffff80000010c743:	c9                   	leave
ffff80000010c744:	c3                   	ret
