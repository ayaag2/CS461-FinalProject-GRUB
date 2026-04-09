
_alarmtest3:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <dummy>:
#include "types.h"
#include "user.h"

int snoozetime = 5;
void dummy() {
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "This function is only here so snooze doesn't end up at address 0!\n");
    1004:	48 b8 98 1e 00 00 00 	movabs $0x1e98,%rax
    100b:	00 00 00 
    100e:	48 89 c6             	mov    %rax,%rsi
    1011:	bf 01 00 00 00       	mov    $0x1,%edi
    1016:	b8 00 00 00 00       	mov    $0x0,%eax
    101b:	48 ba 72 17 00 00 00 	movabs $0x1772,%rdx
    1022:	00 00 00 
    1025:	ff d2                	call   *%rdx
}
    1027:	90                   	nop
    1028:	5d                   	pop    %rbp
    1029:	c3                   	ret

000000000000102a <snooze>:

void snooze(int signum) {
    102a:	55                   	push   %rbp
    102b:	48 89 e5             	mov    %rsp,%rbp
    102e:	48 83 ec 10          	sub    $0x10,%rsp
    1032:	89 7d fc             	mov    %edi,-0x4(%rbp)
  printf(1, "Yawn... another %d seconds?\n", snoozetime--);
    1035:	48 b8 10 1f 00 00 00 	movabs $0x1f10,%rax
    103c:	00 00 00 
    103f:	8b 00                	mov    (%rax),%eax
    1041:	8d 50 ff             	lea    -0x1(%rax),%edx
    1044:	48 b9 10 1f 00 00 00 	movabs $0x1f10,%rcx
    104b:	00 00 00 
    104e:	89 11                	mov    %edx,(%rcx)
    1050:	48 b9 db 1e 00 00 00 	movabs $0x1edb,%rcx
    1057:	00 00 00 
    105a:	89 c2                	mov    %eax,%edx
    105c:	48 89 ce             	mov    %rcx,%rsi
    105f:	bf 01 00 00 00       	mov    $0x1,%edi
    1064:	b8 00 00 00 00       	mov    $0x0,%eax
    1069:	48 b9 72 17 00 00 00 	movabs $0x1772,%rcx
    1070:	00 00 00 
    1073:	ff d1                	call   *%rcx
  if(snoozetime == 0)
    1075:	48 b8 10 1f 00 00 00 	movabs $0x1f10,%rax
    107c:	00 00 00 
    107f:	8b 00                	mov    (%rax),%eax
    1081:	85 c0                	test   %eax,%eax
    1083:	75 16                	jne    109b <snooze+0x71>
    signal(14, 0);
    1085:	be 00 00 00 00       	mov    $0x0,%esi
    108a:	bf 0e 00 00 00       	mov    $0xe,%edi
    108f:	48 b8 75 15 00 00 00 	movabs $0x1575,%rax
    1096:	00 00 00 
    1099:	ff d0                	call   *%rax
  alarm(1);
    109b:	bf 01 00 00 00       	mov    $0x1,%edi
    10a0:	48 b8 68 15 00 00 00 	movabs $0x1568,%rax
    10a7:	00 00 00 
    10aa:	ff d0                	call   *%rax
}
    10ac:	90                   	nop
    10ad:	c9                   	leave
    10ae:	c3                   	ret

00000000000010af <main>:

int main(int argc, char** argv) {
    10af:	55                   	push   %rbp
    10b0:	48 89 e5             	mov    %rsp,%rbp
    10b3:	48 83 ec 20          	sub    $0x20,%rsp
    10b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
    10ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  signal(14, snooze);
    10be:	48 b8 2a 10 00 00 00 	movabs $0x102a,%rax
    10c5:	00 00 00 
    10c8:	48 89 c6             	mov    %rax,%rsi
    10cb:	bf 0e 00 00 00       	mov    $0xe,%edi
    10d0:	48 b8 75 15 00 00 00 	movabs $0x1575,%rax
    10d7:	00 00 00 
    10da:	ff d0                	call   *%rax
  alarm(3);
    10dc:	bf 03 00 00 00       	mov    $0x3,%edi
    10e1:	48 b8 68 15 00 00 00 	movabs $0x1568,%rax
    10e8:	00 00 00 
    10eb:	ff d0                	call   *%rax

  int i = 0;
    10ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while(i++ < 100) {
    10f4:	eb 39                	jmp    112f <main+0x80>
    printf(1, "Looping... %d\n", i);
    10f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10f9:	48 b9 f8 1e 00 00 00 	movabs $0x1ef8,%rcx
    1100:	00 00 00 
    1103:	89 c2                	mov    %eax,%edx
    1105:	48 89 ce             	mov    %rcx,%rsi
    1108:	bf 01 00 00 00       	mov    $0x1,%edi
    110d:	b8 00 00 00 00       	mov    $0x0,%eax
    1112:	48 b9 72 17 00 00 00 	movabs $0x1772,%rcx
    1119:	00 00 00 
    111c:	ff d1                	call   *%rcx
    sleep(100);
    111e:	bf 64 00 00 00       	mov    $0x64,%edi
    1123:	48 b8 4e 15 00 00 00 	movabs $0x154e,%rax
    112a:	00 00 00 
    112d:	ff d0                	call   *%rax
  while(i++ < 100) {
    112f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1132:	8d 50 01             	lea    0x1(%rax),%edx
    1135:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1138:	83 f8 63             	cmp    $0x63,%eax
    113b:	7e b9                	jle    10f6 <main+0x47>
  }
  exit();
    113d:	48 b8 64 14 00 00 00 	movabs $0x1464,%rax
    1144:	00 00 00 
    1147:	ff d0                	call   *%rax

0000000000001149 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1149:	55                   	push   %rbp
    114a:	48 89 e5             	mov    %rsp,%rbp
    114d:	48 83 ec 10          	sub    $0x10,%rsp
    1151:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1155:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1158:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    115b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    115f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1162:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1165:	48 89 ce             	mov    %rcx,%rsi
    1168:	48 89 f7             	mov    %rsi,%rdi
    116b:	89 d1                	mov    %edx,%ecx
    116d:	fc                   	cld
    116e:	f3 aa                	rep stos %al,(%rdi)
    1170:	89 ca                	mov    %ecx,%edx
    1172:	48 89 fe             	mov    %rdi,%rsi
    1175:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1179:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    117c:	90                   	nop
    117d:	c9                   	leave
    117e:	c3                   	ret

000000000000117f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    117f:	55                   	push   %rbp
    1180:	48 89 e5             	mov    %rsp,%rbp
    1183:	48 83 ec 20          	sub    $0x20,%rsp
    1187:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    118b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1193:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1197:	90                   	nop
    1198:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    119c:	48 8d 42 01          	lea    0x1(%rdx),%rax
    11a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    11a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11a8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    11ac:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    11b0:	0f b6 12             	movzbl (%rdx),%edx
    11b3:	88 10                	mov    %dl,(%rax)
    11b5:	0f b6 00             	movzbl (%rax),%eax
    11b8:	84 c0                	test   %al,%al
    11ba:	75 dc                	jne    1198 <strcpy+0x19>
    ;
  return os;
    11bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11c0:	c9                   	leave
    11c1:	c3                   	ret

00000000000011c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11c2:	55                   	push   %rbp
    11c3:	48 89 e5             	mov    %rsp,%rbp
    11c6:	48 83 ec 10          	sub    $0x10,%rsp
    11ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    11d2:	eb 0a                	jmp    11de <strcmp+0x1c>
    p++, q++;
    11d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    11de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11e2:	0f b6 00             	movzbl (%rax),%eax
    11e5:	84 c0                	test   %al,%al
    11e7:	74 12                	je     11fb <strcmp+0x39>
    11e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11ed:	0f b6 10             	movzbl (%rax),%edx
    11f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11f4:	0f b6 00             	movzbl (%rax),%eax
    11f7:	38 c2                	cmp    %al,%dl
    11f9:	74 d9                	je     11d4 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    11fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11ff:	0f b6 00             	movzbl (%rax),%eax
    1202:	0f b6 d0             	movzbl %al,%edx
    1205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1209:	0f b6 00             	movzbl (%rax),%eax
    120c:	0f b6 c0             	movzbl %al,%eax
    120f:	29 c2                	sub    %eax,%edx
    1211:	89 d0                	mov    %edx,%eax
}
    1213:	c9                   	leave
    1214:	c3                   	ret

0000000000001215 <strlen>:

uint
strlen(char *s)
{
    1215:	55                   	push   %rbp
    1216:	48 89 e5             	mov    %rsp,%rbp
    1219:	48 83 ec 18          	sub    $0x18,%rsp
    121d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1228:	eb 04                	jmp    122e <strlen+0x19>
    122a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    122e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1231:	48 63 d0             	movslq %eax,%rdx
    1234:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1238:	48 01 d0             	add    %rdx,%rax
    123b:	0f b6 00             	movzbl (%rax),%eax
    123e:	84 c0                	test   %al,%al
    1240:	75 e8                	jne    122a <strlen+0x15>
    ;
  return n;
    1242:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1245:	c9                   	leave
    1246:	c3                   	ret

0000000000001247 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1247:	55                   	push   %rbp
    1248:	48 89 e5             	mov    %rsp,%rbp
    124b:	48 83 ec 10          	sub    $0x10,%rsp
    124f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1253:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1256:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1259:	8b 55 f0             	mov    -0x10(%rbp),%edx
    125c:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    125f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1263:	89 ce                	mov    %ecx,%esi
    1265:	48 89 c7             	mov    %rax,%rdi
    1268:	48 b8 49 11 00 00 00 	movabs $0x1149,%rax
    126f:	00 00 00 
    1272:	ff d0                	call   *%rax
  return dst;
    1274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1278:	c9                   	leave
    1279:	c3                   	ret

000000000000127a <strchr>:

char*
strchr(const char *s, char c)
{
    127a:	55                   	push   %rbp
    127b:	48 89 e5             	mov    %rsp,%rbp
    127e:	48 83 ec 10          	sub    $0x10,%rsp
    1282:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1286:	89 f0                	mov    %esi,%eax
    1288:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    128b:	eb 17                	jmp    12a4 <strchr+0x2a>
    if(*s == c)
    128d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1291:	0f b6 00             	movzbl (%rax),%eax
    1294:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1297:	75 06                	jne    129f <strchr+0x25>
      return (char*)s;
    1299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    129d:	eb 15                	jmp    12b4 <strchr+0x3a>
  for(; *s; s++)
    129f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    12a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12a8:	0f b6 00             	movzbl (%rax),%eax
    12ab:	84 c0                	test   %al,%al
    12ad:	75 de                	jne    128d <strchr+0x13>
  return 0;
    12af:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12b4:	c9                   	leave
    12b5:	c3                   	ret

00000000000012b6 <gets>:

char*
gets(char *buf, int max)
{
    12b6:	55                   	push   %rbp
    12b7:	48 89 e5             	mov    %rsp,%rbp
    12ba:	48 83 ec 20          	sub    $0x20,%rsp
    12be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12c2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12cc:	eb 4f                	jmp    131d <gets+0x67>
    cc = read(0, &c, 1);
    12ce:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    12d2:	ba 01 00 00 00       	mov    $0x1,%edx
    12d7:	48 89 c6             	mov    %rax,%rsi
    12da:	bf 00 00 00 00       	mov    $0x0,%edi
    12df:	48 b8 8b 14 00 00 00 	movabs $0x148b,%rax
    12e6:	00 00 00 
    12e9:	ff d0                	call   *%rax
    12eb:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    12ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    12f2:	7e 36                	jle    132a <gets+0x74>
      break;
    buf[i++] = c;
    12f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12f7:	8d 50 01             	lea    0x1(%rax),%edx
    12fa:	89 55 fc             	mov    %edx,-0x4(%rbp)
    12fd:	48 63 d0             	movslq %eax,%rdx
    1300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1304:	48 01 c2             	add    %rax,%rdx
    1307:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    130b:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    130d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1311:	3c 0a                	cmp    $0xa,%al
    1313:	74 16                	je     132b <gets+0x75>
    1315:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1319:	3c 0d                	cmp    $0xd,%al
    131b:	74 0e                	je     132b <gets+0x75>
  for(i=0; i+1 < max; ){
    131d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1320:	83 c0 01             	add    $0x1,%eax
    1323:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1326:	7f a6                	jg     12ce <gets+0x18>
    1328:	eb 01                	jmp    132b <gets+0x75>
      break;
    132a:	90                   	nop
      break;
  }
  buf[i] = '\0';
    132b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    132e:	48 63 d0             	movslq %eax,%rdx
    1331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1335:	48 01 d0             	add    %rdx,%rax
    1338:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    133f:	c9                   	leave
    1340:	c3                   	ret

0000000000001341 <stat>:

int
stat(char *n, struct stat *st)
{
    1341:	55                   	push   %rbp
    1342:	48 89 e5             	mov    %rsp,%rbp
    1345:	48 83 ec 20          	sub    $0x20,%rsp
    1349:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    134d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1355:	be 00 00 00 00       	mov    $0x0,%esi
    135a:	48 89 c7             	mov    %rax,%rdi
    135d:	48 b8 cc 14 00 00 00 	movabs $0x14cc,%rax
    1364:	00 00 00 
    1367:	ff d0                	call   *%rax
    1369:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    136c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1370:	79 07                	jns    1379 <stat+0x38>
    return -1;
    1372:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1377:	eb 2f                	jmp    13a8 <stat+0x67>
  r = fstat(fd, st);
    1379:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    137d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1380:	48 89 d6             	mov    %rdx,%rsi
    1383:	89 c7                	mov    %eax,%edi
    1385:	48 b8 f3 14 00 00 00 	movabs $0x14f3,%rax
    138c:	00 00 00 
    138f:	ff d0                	call   *%rax
    1391:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1394:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1397:	89 c7                	mov    %eax,%edi
    1399:	48 b8 a5 14 00 00 00 	movabs $0x14a5,%rax
    13a0:	00 00 00 
    13a3:	ff d0                	call   *%rax
  return r;
    13a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    13a8:	c9                   	leave
    13a9:	c3                   	ret

00000000000013aa <atoi>:

int
atoi(const char *s)
{
    13aa:	55                   	push   %rbp
    13ab:	48 89 e5             	mov    %rsp,%rbp
    13ae:	48 83 ec 18          	sub    $0x18,%rsp
    13b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    13b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    13bd:	eb 28                	jmp    13e7 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    13bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
    13c2:	89 d0                	mov    %edx,%eax
    13c4:	c1 e0 02             	shl    $0x2,%eax
    13c7:	01 d0                	add    %edx,%eax
    13c9:	01 c0                	add    %eax,%eax
    13cb:	89 c1                	mov    %eax,%ecx
    13cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
    13d5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    13d9:	0f b6 00             	movzbl (%rax),%eax
    13dc:	0f be c0             	movsbl %al,%eax
    13df:	01 c8                	add    %ecx,%eax
    13e1:	83 e8 30             	sub    $0x30,%eax
    13e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    13e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13eb:	0f b6 00             	movzbl (%rax),%eax
    13ee:	3c 2f                	cmp    $0x2f,%al
    13f0:	7e 0b                	jle    13fd <atoi+0x53>
    13f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13f6:	0f b6 00             	movzbl (%rax),%eax
    13f9:	3c 39                	cmp    $0x39,%al
    13fb:	7e c2                	jle    13bf <atoi+0x15>
  return n;
    13fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1400:	c9                   	leave
    1401:	c3                   	ret

0000000000001402 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1402:	55                   	push   %rbp
    1403:	48 89 e5             	mov    %rsp,%rbp
    1406:	48 83 ec 28          	sub    $0x28,%rsp
    140a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    140e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1412:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1419:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    141d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1421:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1425:	eb 1d                	jmp    1444 <memmove+0x42>
    *dst++ = *src++;
    1427:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    142b:	48 8d 42 01          	lea    0x1(%rdx),%rax
    142f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1437:	48 8d 48 01          	lea    0x1(%rax),%rcx
    143b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    143f:	0f b6 12             	movzbl (%rdx),%edx
    1442:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1444:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1447:	8d 50 ff             	lea    -0x1(%rax),%edx
    144a:	89 55 dc             	mov    %edx,-0x24(%rbp)
    144d:	85 c0                	test   %eax,%eax
    144f:	7f d6                	jg     1427 <memmove+0x25>
  return vdst;
    1451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1455:	c9                   	leave
    1456:	c3                   	ret

0000000000001457 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1457:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    145e:	49 89 ca             	mov    %rcx,%r10
    1461:	0f 05                	syscall
    1463:	c3                   	ret

0000000000001464 <exit>:
SYSCALL(exit)
    1464:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    146b:	49 89 ca             	mov    %rcx,%r10
    146e:	0f 05                	syscall
    1470:	c3                   	ret

0000000000001471 <wait>:
SYSCALL(wait)
    1471:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1478:	49 89 ca             	mov    %rcx,%r10
    147b:	0f 05                	syscall
    147d:	c3                   	ret

000000000000147e <pipe>:
SYSCALL(pipe)
    147e:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1485:	49 89 ca             	mov    %rcx,%r10
    1488:	0f 05                	syscall
    148a:	c3                   	ret

000000000000148b <read>:
SYSCALL(read)
    148b:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1492:	49 89 ca             	mov    %rcx,%r10
    1495:	0f 05                	syscall
    1497:	c3                   	ret

0000000000001498 <write>:
SYSCALL(write)
    1498:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    149f:	49 89 ca             	mov    %rcx,%r10
    14a2:	0f 05                	syscall
    14a4:	c3                   	ret

00000000000014a5 <close>:
SYSCALL(close)
    14a5:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    14ac:	49 89 ca             	mov    %rcx,%r10
    14af:	0f 05                	syscall
    14b1:	c3                   	ret

00000000000014b2 <kill>:
SYSCALL(kill)
    14b2:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    14b9:	49 89 ca             	mov    %rcx,%r10
    14bc:	0f 05                	syscall
    14be:	c3                   	ret

00000000000014bf <exec>:
SYSCALL(exec)
    14bf:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    14c6:	49 89 ca             	mov    %rcx,%r10
    14c9:	0f 05                	syscall
    14cb:	c3                   	ret

00000000000014cc <open>:
SYSCALL(open)
    14cc:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    14d3:	49 89 ca             	mov    %rcx,%r10
    14d6:	0f 05                	syscall
    14d8:	c3                   	ret

00000000000014d9 <mknod>:
SYSCALL(mknod)
    14d9:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    14e0:	49 89 ca             	mov    %rcx,%r10
    14e3:	0f 05                	syscall
    14e5:	c3                   	ret

00000000000014e6 <unlink>:
SYSCALL(unlink)
    14e6:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    14ed:	49 89 ca             	mov    %rcx,%r10
    14f0:	0f 05                	syscall
    14f2:	c3                   	ret

00000000000014f3 <fstat>:
SYSCALL(fstat)
    14f3:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    14fa:	49 89 ca             	mov    %rcx,%r10
    14fd:	0f 05                	syscall
    14ff:	c3                   	ret

0000000000001500 <link>:
SYSCALL(link)
    1500:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1507:	49 89 ca             	mov    %rcx,%r10
    150a:	0f 05                	syscall
    150c:	c3                   	ret

000000000000150d <mkdir>:
SYSCALL(mkdir)
    150d:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1514:	49 89 ca             	mov    %rcx,%r10
    1517:	0f 05                	syscall
    1519:	c3                   	ret

000000000000151a <chdir>:
SYSCALL(chdir)
    151a:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1521:	49 89 ca             	mov    %rcx,%r10
    1524:	0f 05                	syscall
    1526:	c3                   	ret

0000000000001527 <dup>:
SYSCALL(dup)
    1527:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    152e:	49 89 ca             	mov    %rcx,%r10
    1531:	0f 05                	syscall
    1533:	c3                   	ret

0000000000001534 <getpid>:
SYSCALL(getpid)
    1534:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    153b:	49 89 ca             	mov    %rcx,%r10
    153e:	0f 05                	syscall
    1540:	c3                   	ret

0000000000001541 <sbrk>:
SYSCALL(sbrk)
    1541:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1548:	49 89 ca             	mov    %rcx,%r10
    154b:	0f 05                	syscall
    154d:	c3                   	ret

000000000000154e <sleep>:
SYSCALL(sleep)
    154e:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1555:	49 89 ca             	mov    %rcx,%r10
    1558:	0f 05                	syscall
    155a:	c3                   	ret

000000000000155b <uptime>:
SYSCALL(uptime)
    155b:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1562:	49 89 ca             	mov    %rcx,%r10
    1565:	0f 05                	syscall
    1567:	c3                   	ret

0000000000001568 <alarm>:

SYSCALL(alarm)
    1568:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    156f:	49 89 ca             	mov    %rcx,%r10
    1572:	0f 05                	syscall
    1574:	c3                   	ret

0000000000001575 <signal>:
SYSCALL(signal)
    1575:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    157c:	49 89 ca             	mov    %rcx,%r10
    157f:	0f 05                	syscall
    1581:	c3                   	ret

0000000000001582 <sigret>:
SYSCALL(sigret)
    1582:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1589:	49 89 ca             	mov    %rcx,%r10
    158c:	0f 05                	syscall
    158e:	c3                   	ret

000000000000158f <fgproc>:
SYSCALL(fgproc)
    158f:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1596:	49 89 ca             	mov    %rcx,%r10
    1599:	0f 05                	syscall
    159b:	c3                   	ret

000000000000159c <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    159c:	55                   	push   %rbp
    159d:	48 89 e5             	mov    %rsp,%rbp
    15a0:	48 83 ec 10          	sub    $0x10,%rsp
    15a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
    15a7:	89 f0                	mov    %esi,%eax
    15a9:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    15ac:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    15b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15b3:	ba 01 00 00 00       	mov    $0x1,%edx
    15b8:	48 89 ce             	mov    %rcx,%rsi
    15bb:	89 c7                	mov    %eax,%edi
    15bd:	48 b8 98 14 00 00 00 	movabs $0x1498,%rax
    15c4:	00 00 00 
    15c7:	ff d0                	call   *%rax
}
    15c9:	90                   	nop
    15ca:	c9                   	leave
    15cb:	c3                   	ret

00000000000015cc <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    15cc:	55                   	push   %rbp
    15cd:	48 89 e5             	mov    %rsp,%rbp
    15d0:	48 83 ec 20          	sub    $0x20,%rsp
    15d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    15db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15e2:	eb 35                	jmp    1619 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    15e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    15e8:	48 c1 e8 3c          	shr    $0x3c,%rax
    15ec:	48 ba 20 1f 00 00 00 	movabs $0x1f20,%rdx
    15f3:	00 00 00 
    15f6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    15fa:	0f be d0             	movsbl %al,%edx
    15fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1600:	89 d6                	mov    %edx,%esi
    1602:	89 c7                	mov    %eax,%edi
    1604:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    160b:	00 00 00 
    160e:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1610:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1614:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1619:	8b 45 fc             	mov    -0x4(%rbp),%eax
    161c:	83 f8 0f             	cmp    $0xf,%eax
    161f:	76 c3                	jbe    15e4 <print_x64+0x18>
}
    1621:	90                   	nop
    1622:	90                   	nop
    1623:	c9                   	leave
    1624:	c3                   	ret

0000000000001625 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1625:	55                   	push   %rbp
    1626:	48 89 e5             	mov    %rsp,%rbp
    1629:	48 83 ec 20          	sub    $0x20,%rsp
    162d:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1630:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    163a:	eb 36                	jmp    1672 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    163c:	8b 45 e8             	mov    -0x18(%rbp),%eax
    163f:	c1 e8 1c             	shr    $0x1c,%eax
    1642:	89 c2                	mov    %eax,%edx
    1644:	48 b8 20 1f 00 00 00 	movabs $0x1f20,%rax
    164b:	00 00 00 
    164e:	89 d2                	mov    %edx,%edx
    1650:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1654:	0f be d0             	movsbl %al,%edx
    1657:	8b 45 ec             	mov    -0x14(%rbp),%eax
    165a:	89 d6                	mov    %edx,%esi
    165c:	89 c7                	mov    %eax,%edi
    165e:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    1665:	00 00 00 
    1668:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    166a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    166e:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1672:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1675:	83 f8 07             	cmp    $0x7,%eax
    1678:	76 c2                	jbe    163c <print_x32+0x17>
}
    167a:	90                   	nop
    167b:	90                   	nop
    167c:	c9                   	leave
    167d:	c3                   	ret

000000000000167e <print_d>:

  static void
print_d(int fd, int v)
{
    167e:	55                   	push   %rbp
    167f:	48 89 e5             	mov    %rsp,%rbp
    1682:	48 83 ec 30          	sub    $0x30,%rsp
    1686:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1689:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    168c:	8b 45 d8             	mov    -0x28(%rbp),%eax
    168f:	48 98                	cltq
    1691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1695:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1699:	79 04                	jns    169f <print_d+0x21>
    x = -x;
    169b:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    169f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    16a6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16aa:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    16b1:	66 66 66 
    16b4:	48 89 c8             	mov    %rcx,%rax
    16b7:	48 f7 ea             	imul   %rdx
    16ba:	48 c1 fa 02          	sar    $0x2,%rdx
    16be:	48 89 c8             	mov    %rcx,%rax
    16c1:	48 c1 f8 3f          	sar    $0x3f,%rax
    16c5:	48 29 c2             	sub    %rax,%rdx
    16c8:	48 89 d0             	mov    %rdx,%rax
    16cb:	48 c1 e0 02          	shl    $0x2,%rax
    16cf:	48 01 d0             	add    %rdx,%rax
    16d2:	48 01 c0             	add    %rax,%rax
    16d5:	48 29 c1             	sub    %rax,%rcx
    16d8:	48 89 ca             	mov    %rcx,%rdx
    16db:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16de:	8d 48 01             	lea    0x1(%rax),%ecx
    16e1:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    16e4:	48 b9 20 1f 00 00 00 	movabs $0x1f20,%rcx
    16eb:	00 00 00 
    16ee:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    16f2:	48 98                	cltq
    16f4:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    16f8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    16fc:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1703:	66 66 66 
    1706:	48 89 c8             	mov    %rcx,%rax
    1709:	48 f7 ea             	imul   %rdx
    170c:	48 89 d0             	mov    %rdx,%rax
    170f:	48 c1 f8 02          	sar    $0x2,%rax
    1713:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1717:	48 89 ca             	mov    %rcx,%rdx
    171a:	48 29 d0             	sub    %rdx,%rax
    171d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1721:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1726:	0f 85 7a ff ff ff    	jne    16a6 <print_d+0x28>

  if (v < 0)
    172c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1730:	79 32                	jns    1764 <print_d+0xe6>
    buf[i++] = '-';
    1732:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1735:	8d 50 01             	lea    0x1(%rax),%edx
    1738:	89 55 f4             	mov    %edx,-0xc(%rbp)
    173b:	48 98                	cltq
    173d:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1742:	eb 20                	jmp    1764 <print_d+0xe6>
    putc(fd, buf[i]);
    1744:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1747:	48 98                	cltq
    1749:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    174e:	0f be d0             	movsbl %al,%edx
    1751:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1754:	89 d6                	mov    %edx,%esi
    1756:	89 c7                	mov    %eax,%edi
    1758:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    175f:	00 00 00 
    1762:	ff d0                	call   *%rax
  while (--i >= 0)
    1764:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1768:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    176c:	79 d6                	jns    1744 <print_d+0xc6>
}
    176e:	90                   	nop
    176f:	90                   	nop
    1770:	c9                   	leave
    1771:	c3                   	ret

0000000000001772 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1772:	55                   	push   %rbp
    1773:	48 89 e5             	mov    %rsp,%rbp
    1776:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    177d:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1783:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    178a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1791:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1798:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    179f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    17a6:	84 c0                	test   %al,%al
    17a8:	74 20                	je     17ca <printf+0x58>
    17aa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    17ae:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    17b2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    17b6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    17ba:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    17be:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    17c2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    17c6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    17ca:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    17d1:	00 00 00 
    17d4:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    17db:	00 00 00 
    17de:	48 8d 45 10          	lea    0x10(%rbp),%rax
    17e2:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    17e9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    17f0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    17f7:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    17fe:	00 00 00 
    1801:	e9 60 03 00 00       	jmp    1b66 <printf+0x3f4>
    if (c != '%') {
    1806:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    180d:	74 24                	je     1833 <printf+0xc1>
      putc(fd, c);
    180f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1815:	0f be d0             	movsbl %al,%edx
    1818:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    181e:	89 d6                	mov    %edx,%esi
    1820:	89 c7                	mov    %eax,%edi
    1822:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    1829:	00 00 00 
    182c:	ff d0                	call   *%rax
      continue;
    182e:	e9 2c 03 00 00       	jmp    1b5f <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1833:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    183a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1840:	48 63 d0             	movslq %eax,%rdx
    1843:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    184a:	48 01 d0             	add    %rdx,%rax
    184d:	0f b6 00             	movzbl (%rax),%eax
    1850:	0f be c0             	movsbl %al,%eax
    1853:	25 ff 00 00 00       	and    $0xff,%eax
    1858:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    185e:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1865:	0f 84 2e 03 00 00    	je     1b99 <printf+0x427>
      break;
    switch(c) {
    186b:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1872:	0f 84 32 01 00 00    	je     19aa <printf+0x238>
    1878:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    187f:	0f 8f a1 02 00 00    	jg     1b26 <printf+0x3b4>
    1885:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    188c:	0f 84 d4 01 00 00    	je     1a66 <printf+0x2f4>
    1892:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1899:	0f 8f 87 02 00 00    	jg     1b26 <printf+0x3b4>
    189f:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    18a6:	0f 84 5b 01 00 00    	je     1a07 <printf+0x295>
    18ac:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    18b3:	0f 8f 6d 02 00 00    	jg     1b26 <printf+0x3b4>
    18b9:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    18c0:	0f 84 87 00 00 00    	je     194d <printf+0x1db>
    18c6:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    18cd:	0f 8f 53 02 00 00    	jg     1b26 <printf+0x3b4>
    18d3:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18da:	0f 84 2b 02 00 00    	je     1b0b <printf+0x399>
    18e0:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    18e7:	0f 85 39 02 00 00    	jne    1b26 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    18ed:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18f3:	83 f8 2f             	cmp    $0x2f,%eax
    18f6:	77 23                	ja     191b <printf+0x1a9>
    18f8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ff:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1905:	89 d2                	mov    %edx,%edx
    1907:	48 01 d0             	add    %rdx,%rax
    190a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1910:	83 c2 08             	add    $0x8,%edx
    1913:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1919:	eb 12                	jmp    192d <printf+0x1bb>
    191b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1922:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1926:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    192d:	8b 00                	mov    (%rax),%eax
    192f:	0f be d0             	movsbl %al,%edx
    1932:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1938:	89 d6                	mov    %edx,%esi
    193a:	89 c7                	mov    %eax,%edi
    193c:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    1943:	00 00 00 
    1946:	ff d0                	call   *%rax
      break;
    1948:	e9 12 02 00 00       	jmp    1b5f <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    194d:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1953:	83 f8 2f             	cmp    $0x2f,%eax
    1956:	77 23                	ja     197b <printf+0x209>
    1958:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    195f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1965:	89 d2                	mov    %edx,%edx
    1967:	48 01 d0             	add    %rdx,%rax
    196a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1970:	83 c2 08             	add    $0x8,%edx
    1973:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1979:	eb 12                	jmp    198d <printf+0x21b>
    197b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1982:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1986:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    198d:	8b 10                	mov    (%rax),%edx
    198f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1995:	89 d6                	mov    %edx,%esi
    1997:	89 c7                	mov    %eax,%edi
    1999:	48 b8 7e 16 00 00 00 	movabs $0x167e,%rax
    19a0:	00 00 00 
    19a3:	ff d0                	call   *%rax
      break;
    19a5:	e9 b5 01 00 00       	jmp    1b5f <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    19aa:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b0:	83 f8 2f             	cmp    $0x2f,%eax
    19b3:	77 23                	ja     19d8 <printf+0x266>
    19b5:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19bc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c2:	89 d2                	mov    %edx,%edx
    19c4:	48 01 d0             	add    %rdx,%rax
    19c7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19cd:	83 c2 08             	add    $0x8,%edx
    19d0:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19d6:	eb 12                	jmp    19ea <printf+0x278>
    19d8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19df:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19e3:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19ea:	8b 10                	mov    (%rax),%edx
    19ec:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19f2:	89 d6                	mov    %edx,%esi
    19f4:	89 c7                	mov    %eax,%edi
    19f6:	48 b8 25 16 00 00 00 	movabs $0x1625,%rax
    19fd:	00 00 00 
    1a00:	ff d0                	call   *%rax
      break;
    1a02:	e9 58 01 00 00       	jmp    1b5f <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a07:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a0d:	83 f8 2f             	cmp    $0x2f,%eax
    1a10:	77 23                	ja     1a35 <printf+0x2c3>
    1a12:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a19:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a1f:	89 d2                	mov    %edx,%edx
    1a21:	48 01 d0             	add    %rdx,%rax
    1a24:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a2a:	83 c2 08             	add    $0x8,%edx
    1a2d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a33:	eb 12                	jmp    1a47 <printf+0x2d5>
    1a35:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a3c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a40:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a47:	48 8b 10             	mov    (%rax),%rdx
    1a4a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a50:	48 89 d6             	mov    %rdx,%rsi
    1a53:	89 c7                	mov    %eax,%edi
    1a55:	48 b8 cc 15 00 00 00 	movabs $0x15cc,%rax
    1a5c:	00 00 00 
    1a5f:	ff d0                	call   *%rax
      break;
    1a61:	e9 f9 00 00 00       	jmp    1b5f <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a66:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a6c:	83 f8 2f             	cmp    $0x2f,%eax
    1a6f:	77 23                	ja     1a94 <printf+0x322>
    1a71:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a78:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a7e:	89 d2                	mov    %edx,%edx
    1a80:	48 01 d0             	add    %rdx,%rax
    1a83:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a89:	83 c2 08             	add    $0x8,%edx
    1a8c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a92:	eb 12                	jmp    1aa6 <printf+0x334>
    1a94:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a9b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a9f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1aa6:	48 8b 00             	mov    (%rax),%rax
    1aa9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1ab0:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1ab7:	00 
    1ab8:	75 41                	jne    1afb <printf+0x389>
        s = "(null)";
    1aba:	48 b8 07 1f 00 00 00 	movabs $0x1f07,%rax
    1ac1:	00 00 00 
    1ac4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1acb:	eb 2e                	jmp    1afb <printf+0x389>
        putc(fd, *(s++));
    1acd:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1ad4:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1ad8:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1adf:	0f b6 00             	movzbl (%rax),%eax
    1ae2:	0f be d0             	movsbl %al,%edx
    1ae5:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aeb:	89 d6                	mov    %edx,%esi
    1aed:	89 c7                	mov    %eax,%edi
    1aef:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    1af6:	00 00 00 
    1af9:	ff d0                	call   *%rax
      while (*s)
    1afb:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b02:	0f b6 00             	movzbl (%rax),%eax
    1b05:	84 c0                	test   %al,%al
    1b07:	75 c4                	jne    1acd <printf+0x35b>
      break;
    1b09:	eb 54                	jmp    1b5f <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1b0b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b11:	be 25 00 00 00       	mov    $0x25,%esi
    1b16:	89 c7                	mov    %eax,%edi
    1b18:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    1b1f:	00 00 00 
    1b22:	ff d0                	call   *%rax
      break;
    1b24:	eb 39                	jmp    1b5f <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b26:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b2c:	be 25 00 00 00       	mov    $0x25,%esi
    1b31:	89 c7                	mov    %eax,%edi
    1b33:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    1b3a:	00 00 00 
    1b3d:	ff d0                	call   *%rax
      putc(fd, c);
    1b3f:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b45:	0f be d0             	movsbl %al,%edx
    1b48:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b4e:	89 d6                	mov    %edx,%esi
    1b50:	89 c7                	mov    %eax,%edi
    1b52:	48 b8 9c 15 00 00 00 	movabs $0x159c,%rax
    1b59:	00 00 00 
    1b5c:	ff d0                	call   *%rax
      break;
    1b5e:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b5f:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b66:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b6c:	48 63 d0             	movslq %eax,%rdx
    1b6f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b76:	48 01 d0             	add    %rdx,%rax
    1b79:	0f b6 00             	movzbl (%rax),%eax
    1b7c:	0f be c0             	movsbl %al,%eax
    1b7f:	25 ff 00 00 00       	and    $0xff,%eax
    1b84:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b8a:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b91:	0f 85 6f fc ff ff    	jne    1806 <printf+0x94>
    }
  }
}
    1b97:	eb 01                	jmp    1b9a <printf+0x428>
      break;
    1b99:	90                   	nop
}
    1b9a:	90                   	nop
    1b9b:	c9                   	leave
    1b9c:	c3                   	ret

0000000000001b9d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b9d:	55                   	push   %rbp
    1b9e:	48 89 e5             	mov    %rsp,%rbp
    1ba1:	48 83 ec 18          	sub    $0x18,%rsp
    1ba5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1bad:	48 83 e8 10          	sub    $0x10,%rax
    1bb1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bb5:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    1bbc:	00 00 00 
    1bbf:	48 8b 00             	mov    (%rax),%rax
    1bc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1bc6:	eb 2f                	jmp    1bf7 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcc:	48 8b 00             	mov    (%rax),%rax
    1bcf:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1bd3:	72 17                	jb     1bec <free+0x4f>
    1bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bd9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1bdd:	72 2f                	jb     1c0e <free+0x71>
    1bdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be3:	48 8b 00             	mov    (%rax),%rax
    1be6:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bea:	72 22                	jb     1c0e <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf0:	48 8b 00             	mov    (%rax),%rax
    1bf3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1bf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bfb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1bff:	73 c7                	jae    1bc8 <free+0x2b>
    1c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c05:	48 8b 00             	mov    (%rax),%rax
    1c08:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c0c:	73 ba                	jae    1bc8 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c12:	8b 40 08             	mov    0x8(%rax),%eax
    1c15:	89 c0                	mov    %eax,%eax
    1c17:	48 c1 e0 04          	shl    $0x4,%rax
    1c1b:	48 89 c2             	mov    %rax,%rdx
    1c1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c22:	48 01 c2             	add    %rax,%rdx
    1c25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c29:	48 8b 00             	mov    (%rax),%rax
    1c2c:	48 39 c2             	cmp    %rax,%rdx
    1c2f:	75 2d                	jne    1c5e <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c35:	8b 50 08             	mov    0x8(%rax),%edx
    1c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c3c:	48 8b 00             	mov    (%rax),%rax
    1c3f:	8b 40 08             	mov    0x8(%rax),%eax
    1c42:	01 c2                	add    %eax,%edx
    1c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c48:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c4f:	48 8b 00             	mov    (%rax),%rax
    1c52:	48 8b 10             	mov    (%rax),%rdx
    1c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c59:	48 89 10             	mov    %rdx,(%rax)
    1c5c:	eb 0e                	jmp    1c6c <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c62:	48 8b 10             	mov    (%rax),%rdx
    1c65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c69:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c70:	8b 40 08             	mov    0x8(%rax),%eax
    1c73:	89 c0                	mov    %eax,%eax
    1c75:	48 c1 e0 04          	shl    $0x4,%rax
    1c79:	48 89 c2             	mov    %rax,%rdx
    1c7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c80:	48 01 d0             	add    %rdx,%rax
    1c83:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c87:	75 27                	jne    1cb0 <free+0x113>
    p->s.size += bp->s.size;
    1c89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c8d:	8b 50 08             	mov    0x8(%rax),%edx
    1c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c94:	8b 40 08             	mov    0x8(%rax),%eax
    1c97:	01 c2                	add    %eax,%edx
    1c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c9d:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1ca0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca4:	48 8b 10             	mov    (%rax),%rdx
    1ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cab:	48 89 10             	mov    %rdx,(%rax)
    1cae:	eb 0b                	jmp    1cbb <free+0x11e>
  } else
    p->s.ptr = bp;
    1cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1cb8:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1cbb:	48 ba 50 1f 00 00 00 	movabs $0x1f50,%rdx
    1cc2:	00 00 00 
    1cc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc9:	48 89 02             	mov    %rax,(%rdx)
}
    1ccc:	90                   	nop
    1ccd:	c9                   	leave
    1cce:	c3                   	ret

0000000000001ccf <morecore>:

static Header*
morecore(uint nu)
{
    1ccf:	55                   	push   %rbp
    1cd0:	48 89 e5             	mov    %rsp,%rbp
    1cd3:	48 83 ec 20          	sub    $0x20,%rsp
    1cd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1cda:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1ce1:	77 07                	ja     1cea <morecore+0x1b>
    nu = 4096;
    1ce3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1cea:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ced:	48 c1 e0 04          	shl    $0x4,%rax
    1cf1:	48 89 c7             	mov    %rax,%rdi
    1cf4:	48 b8 41 15 00 00 00 	movabs $0x1541,%rax
    1cfb:	00 00 00 
    1cfe:	ff d0                	call   *%rax
    1d00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d04:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d09:	75 07                	jne    1d12 <morecore+0x43>
    return 0;
    1d0b:	b8 00 00 00 00       	mov    $0x0,%eax
    1d10:	eb 36                	jmp    1d48 <morecore+0x79>
  hp = (Header*)p;
    1d12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1e:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d21:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d28:	48 83 c0 10          	add    $0x10,%rax
    1d2c:	48 89 c7             	mov    %rax,%rdi
    1d2f:	48 b8 9d 1b 00 00 00 	movabs $0x1b9d,%rax
    1d36:	00 00 00 
    1d39:	ff d0                	call   *%rax
  return freep;
    1d3b:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    1d42:	00 00 00 
    1d45:	48 8b 00             	mov    (%rax),%rax
}
    1d48:	c9                   	leave
    1d49:	c3                   	ret

0000000000001d4a <malloc>:

void*
malloc(uint nbytes)
{
    1d4a:	55                   	push   %rbp
    1d4b:	48 89 e5             	mov    %rsp,%rbp
    1d4e:	48 83 ec 30          	sub    $0x30,%rsp
    1d52:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1d55:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1d58:	48 83 c0 0f          	add    $0xf,%rax
    1d5c:	48 c1 e8 04          	shr    $0x4,%rax
    1d60:	83 c0 01             	add    $0x1,%eax
    1d63:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1d66:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    1d6d:	00 00 00 
    1d70:	48 8b 00             	mov    (%rax),%rax
    1d73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d77:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d7c:	75 4a                	jne    1dc8 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1d7e:	48 b8 40 1f 00 00 00 	movabs $0x1f40,%rax
    1d85:	00 00 00 
    1d88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d8c:	48 ba 50 1f 00 00 00 	movabs $0x1f50,%rdx
    1d93:	00 00 00 
    1d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d9a:	48 89 02             	mov    %rax,(%rdx)
    1d9d:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    1da4:	00 00 00 
    1da7:	48 8b 00             	mov    (%rax),%rax
    1daa:	48 ba 40 1f 00 00 00 	movabs $0x1f40,%rdx
    1db1:	00 00 00 
    1db4:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1db7:	48 b8 40 1f 00 00 00 	movabs $0x1f40,%rax
    1dbe:	00 00 00 
    1dc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dcc:	48 8b 00             	mov    (%rax),%rax
    1dcf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1dd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd7:	8b 40 08             	mov    0x8(%rax),%eax
    1dda:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1ddd:	72 65                	jb     1e44 <malloc+0xfa>
      if(p->s.size == nunits)
    1ddf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de3:	8b 40 08             	mov    0x8(%rax),%eax
    1de6:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1de9:	75 10                	jne    1dfb <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1def:	48 8b 10             	mov    (%rax),%rdx
    1df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1df6:	48 89 10             	mov    %rdx,(%rax)
    1df9:	eb 2e                	jmp    1e29 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dff:	8b 40 08             	mov    0x8(%rax),%eax
    1e02:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e05:	89 c2                	mov    %eax,%edx
    1e07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e0b:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e12:	8b 40 08             	mov    0x8(%rax),%eax
    1e15:	89 c0                	mov    %eax,%eax
    1e17:	48 c1 e0 04          	shl    $0x4,%rax
    1e1b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e23:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e26:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1e29:	48 ba 50 1f 00 00 00 	movabs $0x1f50,%rdx
    1e30:	00 00 00 
    1e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e37:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1e3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e3e:	48 83 c0 10          	add    $0x10,%rax
    1e42:	eb 4e                	jmp    1e92 <malloc+0x148>
    }
    if(p == freep)
    1e44:	48 b8 50 1f 00 00 00 	movabs $0x1f50,%rax
    1e4b:	00 00 00 
    1e4e:	48 8b 00             	mov    (%rax),%rax
    1e51:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1e55:	75 23                	jne    1e7a <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1e57:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1e5a:	89 c7                	mov    %eax,%edi
    1e5c:	48 b8 cf 1c 00 00 00 	movabs $0x1ccf,%rax
    1e63:	00 00 00 
    1e66:	ff d0                	call   *%rax
    1e68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1e6c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e71:	75 07                	jne    1e7a <malloc+0x130>
        return 0;
    1e73:	b8 00 00 00 00       	mov    $0x0,%eax
    1e78:	eb 18                	jmp    1e92 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e86:	48 8b 00             	mov    (%rax),%rax
    1e89:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e8d:	e9 41 ff ff ff       	jmp    1dd3 <malloc+0x89>
  }
}
    1e92:	c9                   	leave
    1e93:	c3                   	ret
