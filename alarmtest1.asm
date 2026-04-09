
_alarmtest1:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char** argv) {
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 10          	sub    $0x10,%rsp
    1008:	89 7d fc             	mov    %edi,-0x4(%rbp)
    100b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  alarm(3);
    100f:	bf 03 00 00 00       	mov    $0x3,%edi
    1014:	48 b8 76 14 00 00 00 	movabs $0x1476,%rax
    101b:	00 00 00 
    101e:	ff d0                	call   *%rax
  while(1) {
    printf(1,"Still looping...\n");
    1020:	48 b8 a2 1d 00 00 00 	movabs $0x1da2,%rax
    1027:	00 00 00 
    102a:	48 89 c6             	mov    %rax,%rsi
    102d:	bf 01 00 00 00       	mov    $0x1,%edi
    1032:	b8 00 00 00 00       	mov    $0x0,%eax
    1037:	48 ba 80 16 00 00 00 	movabs $0x1680,%rdx
    103e:	00 00 00 
    1041:	ff d2                	call   *%rdx
    sleep(500);
    1043:	bf f4 01 00 00       	mov    $0x1f4,%edi
    1048:	48 b8 5c 14 00 00 00 	movabs $0x145c,%rax
    104f:	00 00 00 
    1052:	ff d0                	call   *%rax
    printf(1,"Still looping...\n");
    1054:	90                   	nop
    1055:	eb c9                	jmp    1020 <main+0x20>

0000000000001057 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1057:	55                   	push   %rbp
    1058:	48 89 e5             	mov    %rsp,%rbp
    105b:	48 83 ec 10          	sub    $0x10,%rsp
    105f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1063:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1066:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1069:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    106d:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1070:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1073:	48 89 ce             	mov    %rcx,%rsi
    1076:	48 89 f7             	mov    %rsi,%rdi
    1079:	89 d1                	mov    %edx,%ecx
    107b:	fc                   	cld
    107c:	f3 aa                	rep stos %al,(%rdi)
    107e:	89 ca                	mov    %ecx,%edx
    1080:	48 89 fe             	mov    %rdi,%rsi
    1083:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1087:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    108a:	90                   	nop
    108b:	c9                   	leave
    108c:	c3                   	ret

000000000000108d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    108d:	55                   	push   %rbp
    108e:	48 89 e5             	mov    %rsp,%rbp
    1091:	48 83 ec 20          	sub    $0x20,%rsp
    1095:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1099:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    109d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10a5:	90                   	nop
    10a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10aa:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10ae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10b6:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10ba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10be:	0f b6 12             	movzbl (%rdx),%edx
    10c1:	88 10                	mov    %dl,(%rax)
    10c3:	0f b6 00             	movzbl (%rax),%eax
    10c6:	84 c0                	test   %al,%al
    10c8:	75 dc                	jne    10a6 <strcpy+0x19>
    ;
  return os;
    10ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    10ce:	c9                   	leave
    10cf:	c3                   	ret

00000000000010d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10d0:	55                   	push   %rbp
    10d1:	48 89 e5             	mov    %rsp,%rbp
    10d4:	48 83 ec 10          	sub    $0x10,%rsp
    10d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    10e0:	eb 0a                	jmp    10ec <strcmp+0x1c>
    p++, q++;
    10e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    10e7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    10ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10f0:	0f b6 00             	movzbl (%rax),%eax
    10f3:	84 c0                	test   %al,%al
    10f5:	74 12                	je     1109 <strcmp+0x39>
    10f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10fb:	0f b6 10             	movzbl (%rax),%edx
    10fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1102:	0f b6 00             	movzbl (%rax),%eax
    1105:	38 c2                	cmp    %al,%dl
    1107:	74 d9                	je     10e2 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    110d:	0f b6 00             	movzbl (%rax),%eax
    1110:	0f b6 d0             	movzbl %al,%edx
    1113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1117:	0f b6 00             	movzbl (%rax),%eax
    111a:	0f b6 c0             	movzbl %al,%eax
    111d:	29 c2                	sub    %eax,%edx
    111f:	89 d0                	mov    %edx,%eax
}
    1121:	c9                   	leave
    1122:	c3                   	ret

0000000000001123 <strlen>:

uint
strlen(char *s)
{
    1123:	55                   	push   %rbp
    1124:	48 89 e5             	mov    %rsp,%rbp
    1127:	48 83 ec 18          	sub    $0x18,%rsp
    112b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    112f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1136:	eb 04                	jmp    113c <strlen+0x19>
    1138:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    113c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    113f:	48 63 d0             	movslq %eax,%rdx
    1142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1146:	48 01 d0             	add    %rdx,%rax
    1149:	0f b6 00             	movzbl (%rax),%eax
    114c:	84 c0                	test   %al,%al
    114e:	75 e8                	jne    1138 <strlen+0x15>
    ;
  return n;
    1150:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1153:	c9                   	leave
    1154:	c3                   	ret

0000000000001155 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1155:	55                   	push   %rbp
    1156:	48 89 e5             	mov    %rsp,%rbp
    1159:	48 83 ec 10          	sub    $0x10,%rsp
    115d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1161:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1164:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1167:	8b 55 f0             	mov    -0x10(%rbp),%edx
    116a:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    116d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1171:	89 ce                	mov    %ecx,%esi
    1173:	48 89 c7             	mov    %rax,%rdi
    1176:	48 b8 57 10 00 00 00 	movabs $0x1057,%rax
    117d:	00 00 00 
    1180:	ff d0                	call   *%rax
  return dst;
    1182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1186:	c9                   	leave
    1187:	c3                   	ret

0000000000001188 <strchr>:

char*
strchr(const char *s, char c)
{
    1188:	55                   	push   %rbp
    1189:	48 89 e5             	mov    %rsp,%rbp
    118c:	48 83 ec 10          	sub    $0x10,%rsp
    1190:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1194:	89 f0                	mov    %esi,%eax
    1196:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1199:	eb 17                	jmp    11b2 <strchr+0x2a>
    if(*s == c)
    119b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    119f:	0f b6 00             	movzbl (%rax),%eax
    11a2:	38 45 f4             	cmp    %al,-0xc(%rbp)
    11a5:	75 06                	jne    11ad <strchr+0x25>
      return (char*)s;
    11a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11ab:	eb 15                	jmp    11c2 <strchr+0x3a>
  for(; *s; s++)
    11ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11b6:	0f b6 00             	movzbl (%rax),%eax
    11b9:	84 c0                	test   %al,%al
    11bb:	75 de                	jne    119b <strchr+0x13>
  return 0;
    11bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11c2:	c9                   	leave
    11c3:	c3                   	ret

00000000000011c4 <gets>:

char*
gets(char *buf, int max)
{
    11c4:	55                   	push   %rbp
    11c5:	48 89 e5             	mov    %rsp,%rbp
    11c8:	48 83 ec 20          	sub    $0x20,%rsp
    11cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11da:	eb 4f                	jmp    122b <gets+0x67>
    cc = read(0, &c, 1);
    11dc:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    11e0:	ba 01 00 00 00       	mov    $0x1,%edx
    11e5:	48 89 c6             	mov    %rax,%rsi
    11e8:	bf 00 00 00 00       	mov    $0x0,%edi
    11ed:	48 b8 99 13 00 00 00 	movabs $0x1399,%rax
    11f4:	00 00 00 
    11f7:	ff d0                	call   *%rax
    11f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    11fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1200:	7e 36                	jle    1238 <gets+0x74>
      break;
    buf[i++] = c;
    1202:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1205:	8d 50 01             	lea    0x1(%rax),%edx
    1208:	89 55 fc             	mov    %edx,-0x4(%rbp)
    120b:	48 63 d0             	movslq %eax,%rdx
    120e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1212:	48 01 c2             	add    %rax,%rdx
    1215:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1219:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    121b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    121f:	3c 0a                	cmp    $0xa,%al
    1221:	74 16                	je     1239 <gets+0x75>
    1223:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1227:	3c 0d                	cmp    $0xd,%al
    1229:	74 0e                	je     1239 <gets+0x75>
  for(i=0; i+1 < max; ){
    122b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    122e:	83 c0 01             	add    $0x1,%eax
    1231:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1234:	7f a6                	jg     11dc <gets+0x18>
    1236:	eb 01                	jmp    1239 <gets+0x75>
      break;
    1238:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1239:	8b 45 fc             	mov    -0x4(%rbp),%eax
    123c:	48 63 d0             	movslq %eax,%rdx
    123f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1243:	48 01 d0             	add    %rdx,%rax
    1246:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    124d:	c9                   	leave
    124e:	c3                   	ret

000000000000124f <stat>:

int
stat(char *n, struct stat *st)
{
    124f:	55                   	push   %rbp
    1250:	48 89 e5             	mov    %rsp,%rbp
    1253:	48 83 ec 20          	sub    $0x20,%rsp
    1257:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    125b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    125f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1263:	be 00 00 00 00       	mov    $0x0,%esi
    1268:	48 89 c7             	mov    %rax,%rdi
    126b:	48 b8 da 13 00 00 00 	movabs $0x13da,%rax
    1272:	00 00 00 
    1275:	ff d0                	call   *%rax
    1277:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    127a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    127e:	79 07                	jns    1287 <stat+0x38>
    return -1;
    1280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1285:	eb 2f                	jmp    12b6 <stat+0x67>
  r = fstat(fd, st);
    1287:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    128b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    128e:	48 89 d6             	mov    %rdx,%rsi
    1291:	89 c7                	mov    %eax,%edi
    1293:	48 b8 01 14 00 00 00 	movabs $0x1401,%rax
    129a:	00 00 00 
    129d:	ff d0                	call   *%rax
    129f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12a5:	89 c7                	mov    %eax,%edi
    12a7:	48 b8 b3 13 00 00 00 	movabs $0x13b3,%rax
    12ae:	00 00 00 
    12b1:	ff d0                	call   *%rax
  return r;
    12b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12b6:	c9                   	leave
    12b7:	c3                   	ret

00000000000012b8 <atoi>:

int
atoi(const char *s)
{
    12b8:	55                   	push   %rbp
    12b9:	48 89 e5             	mov    %rsp,%rbp
    12bc:	48 83 ec 18          	sub    $0x18,%rsp
    12c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    12c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12cb:	eb 28                	jmp    12f5 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    12cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
    12d0:	89 d0                	mov    %edx,%eax
    12d2:	c1 e0 02             	shl    $0x2,%eax
    12d5:	01 d0                	add    %edx,%eax
    12d7:	01 c0                	add    %eax,%eax
    12d9:	89 c1                	mov    %eax,%ecx
    12db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12df:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    12e7:	0f b6 00             	movzbl (%rax),%eax
    12ea:	0f be c0             	movsbl %al,%eax
    12ed:	01 c8                	add    %ecx,%eax
    12ef:	83 e8 30             	sub    $0x30,%eax
    12f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12f9:	0f b6 00             	movzbl (%rax),%eax
    12fc:	3c 2f                	cmp    $0x2f,%al
    12fe:	7e 0b                	jle    130b <atoi+0x53>
    1300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1304:	0f b6 00             	movzbl (%rax),%eax
    1307:	3c 39                	cmp    $0x39,%al
    1309:	7e c2                	jle    12cd <atoi+0x15>
  return n;
    130b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    130e:	c9                   	leave
    130f:	c3                   	ret

0000000000001310 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1310:	55                   	push   %rbp
    1311:	48 89 e5             	mov    %rsp,%rbp
    1314:	48 83 ec 28          	sub    $0x28,%rsp
    1318:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    131c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1320:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1327:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    132b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    132f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1333:	eb 1d                	jmp    1352 <memmove+0x42>
    *dst++ = *src++;
    1335:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1339:	48 8d 42 01          	lea    0x1(%rdx),%rax
    133d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1345:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1349:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    134d:	0f b6 12             	movzbl (%rdx),%edx
    1350:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1352:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1355:	8d 50 ff             	lea    -0x1(%rax),%edx
    1358:	89 55 dc             	mov    %edx,-0x24(%rbp)
    135b:	85 c0                	test   %eax,%eax
    135d:	7f d6                	jg     1335 <memmove+0x25>
  return vdst;
    135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1363:	c9                   	leave
    1364:	c3                   	ret

0000000000001365 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1365:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    136c:	49 89 ca             	mov    %rcx,%r10
    136f:	0f 05                	syscall
    1371:	c3                   	ret

0000000000001372 <exit>:
SYSCALL(exit)
    1372:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1379:	49 89 ca             	mov    %rcx,%r10
    137c:	0f 05                	syscall
    137e:	c3                   	ret

000000000000137f <wait>:
SYSCALL(wait)
    137f:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1386:	49 89 ca             	mov    %rcx,%r10
    1389:	0f 05                	syscall
    138b:	c3                   	ret

000000000000138c <pipe>:
SYSCALL(pipe)
    138c:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1393:	49 89 ca             	mov    %rcx,%r10
    1396:	0f 05                	syscall
    1398:	c3                   	ret

0000000000001399 <read>:
SYSCALL(read)
    1399:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13a0:	49 89 ca             	mov    %rcx,%r10
    13a3:	0f 05                	syscall
    13a5:	c3                   	ret

00000000000013a6 <write>:
SYSCALL(write)
    13a6:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13ad:	49 89 ca             	mov    %rcx,%r10
    13b0:	0f 05                	syscall
    13b2:	c3                   	ret

00000000000013b3 <close>:
SYSCALL(close)
    13b3:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13ba:	49 89 ca             	mov    %rcx,%r10
    13bd:	0f 05                	syscall
    13bf:	c3                   	ret

00000000000013c0 <kill>:
SYSCALL(kill)
    13c0:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    13c7:	49 89 ca             	mov    %rcx,%r10
    13ca:	0f 05                	syscall
    13cc:	c3                   	ret

00000000000013cd <exec>:
SYSCALL(exec)
    13cd:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    13d4:	49 89 ca             	mov    %rcx,%r10
    13d7:	0f 05                	syscall
    13d9:	c3                   	ret

00000000000013da <open>:
SYSCALL(open)
    13da:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    13e1:	49 89 ca             	mov    %rcx,%r10
    13e4:	0f 05                	syscall
    13e6:	c3                   	ret

00000000000013e7 <mknod>:
SYSCALL(mknod)
    13e7:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    13ee:	49 89 ca             	mov    %rcx,%r10
    13f1:	0f 05                	syscall
    13f3:	c3                   	ret

00000000000013f4 <unlink>:
SYSCALL(unlink)
    13f4:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    13fb:	49 89 ca             	mov    %rcx,%r10
    13fe:	0f 05                	syscall
    1400:	c3                   	ret

0000000000001401 <fstat>:
SYSCALL(fstat)
    1401:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1408:	49 89 ca             	mov    %rcx,%r10
    140b:	0f 05                	syscall
    140d:	c3                   	ret

000000000000140e <link>:
SYSCALL(link)
    140e:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1415:	49 89 ca             	mov    %rcx,%r10
    1418:	0f 05                	syscall
    141a:	c3                   	ret

000000000000141b <mkdir>:
SYSCALL(mkdir)
    141b:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1422:	49 89 ca             	mov    %rcx,%r10
    1425:	0f 05                	syscall
    1427:	c3                   	ret

0000000000001428 <chdir>:
SYSCALL(chdir)
    1428:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    142f:	49 89 ca             	mov    %rcx,%r10
    1432:	0f 05                	syscall
    1434:	c3                   	ret

0000000000001435 <dup>:
SYSCALL(dup)
    1435:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    143c:	49 89 ca             	mov    %rcx,%r10
    143f:	0f 05                	syscall
    1441:	c3                   	ret

0000000000001442 <getpid>:
SYSCALL(getpid)
    1442:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1449:	49 89 ca             	mov    %rcx,%r10
    144c:	0f 05                	syscall
    144e:	c3                   	ret

000000000000144f <sbrk>:
SYSCALL(sbrk)
    144f:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1456:	49 89 ca             	mov    %rcx,%r10
    1459:	0f 05                	syscall
    145b:	c3                   	ret

000000000000145c <sleep>:
SYSCALL(sleep)
    145c:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1463:	49 89 ca             	mov    %rcx,%r10
    1466:	0f 05                	syscall
    1468:	c3                   	ret

0000000000001469 <uptime>:
SYSCALL(uptime)
    1469:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1470:	49 89 ca             	mov    %rcx,%r10
    1473:	0f 05                	syscall
    1475:	c3                   	ret

0000000000001476 <alarm>:

SYSCALL(alarm)
    1476:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    147d:	49 89 ca             	mov    %rcx,%r10
    1480:	0f 05                	syscall
    1482:	c3                   	ret

0000000000001483 <signal>:
SYSCALL(signal)
    1483:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    148a:	49 89 ca             	mov    %rcx,%r10
    148d:	0f 05                	syscall
    148f:	c3                   	ret

0000000000001490 <sigret>:
SYSCALL(sigret)
    1490:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1497:	49 89 ca             	mov    %rcx,%r10
    149a:	0f 05                	syscall
    149c:	c3                   	ret

000000000000149d <fgproc>:
SYSCALL(fgproc)
    149d:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    14a4:	49 89 ca             	mov    %rcx,%r10
    14a7:	0f 05                	syscall
    14a9:	c3                   	ret

00000000000014aa <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14aa:	55                   	push   %rbp
    14ab:	48 89 e5             	mov    %rsp,%rbp
    14ae:	48 83 ec 10          	sub    $0x10,%rsp
    14b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14b5:	89 f0                	mov    %esi,%eax
    14b7:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14ba:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14be:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14c1:	ba 01 00 00 00       	mov    $0x1,%edx
    14c6:	48 89 ce             	mov    %rcx,%rsi
    14c9:	89 c7                	mov    %eax,%edi
    14cb:	48 b8 a6 13 00 00 00 	movabs $0x13a6,%rax
    14d2:	00 00 00 
    14d5:	ff d0                	call   *%rax
}
    14d7:	90                   	nop
    14d8:	c9                   	leave
    14d9:	c3                   	ret

00000000000014da <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    14da:	55                   	push   %rbp
    14db:	48 89 e5             	mov    %rsp,%rbp
    14de:	48 83 ec 20          	sub    $0x20,%rsp
    14e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
    14e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    14e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    14f0:	eb 35                	jmp    1527 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    14f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14f6:	48 c1 e8 3c          	shr    $0x3c,%rax
    14fa:	48 ba c0 1d 00 00 00 	movabs $0x1dc0,%rdx
    1501:	00 00 00 
    1504:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1508:	0f be d0             	movsbl %al,%edx
    150b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    150e:	89 d6                	mov    %edx,%esi
    1510:	89 c7                	mov    %eax,%edi
    1512:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1519:	00 00 00 
    151c:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    151e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1522:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1527:	8b 45 fc             	mov    -0x4(%rbp),%eax
    152a:	83 f8 0f             	cmp    $0xf,%eax
    152d:	76 c3                	jbe    14f2 <print_x64+0x18>
}
    152f:	90                   	nop
    1530:	90                   	nop
    1531:	c9                   	leave
    1532:	c3                   	ret

0000000000001533 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1533:	55                   	push   %rbp
    1534:	48 89 e5             	mov    %rsp,%rbp
    1537:	48 83 ec 20          	sub    $0x20,%rsp
    153b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    153e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1541:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1548:	eb 36                	jmp    1580 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    154a:	8b 45 e8             	mov    -0x18(%rbp),%eax
    154d:	c1 e8 1c             	shr    $0x1c,%eax
    1550:	89 c2                	mov    %eax,%edx
    1552:	48 b8 c0 1d 00 00 00 	movabs $0x1dc0,%rax
    1559:	00 00 00 
    155c:	89 d2                	mov    %edx,%edx
    155e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1562:	0f be d0             	movsbl %al,%edx
    1565:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1568:	89 d6                	mov    %edx,%esi
    156a:	89 c7                	mov    %eax,%edi
    156c:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1573:	00 00 00 
    1576:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1578:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    157c:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1580:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1583:	83 f8 07             	cmp    $0x7,%eax
    1586:	76 c2                	jbe    154a <print_x32+0x17>
}
    1588:	90                   	nop
    1589:	90                   	nop
    158a:	c9                   	leave
    158b:	c3                   	ret

000000000000158c <print_d>:

  static void
print_d(int fd, int v)
{
    158c:	55                   	push   %rbp
    158d:	48 89 e5             	mov    %rsp,%rbp
    1590:	48 83 ec 30          	sub    $0x30,%rsp
    1594:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1597:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    159a:	8b 45 d8             	mov    -0x28(%rbp),%eax
    159d:	48 98                	cltq
    159f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15a7:	79 04                	jns    15ad <print_d+0x21>
    x = -x;
    15a9:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15b4:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15b8:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15bf:	66 66 66 
    15c2:	48 89 c8             	mov    %rcx,%rax
    15c5:	48 f7 ea             	imul   %rdx
    15c8:	48 c1 fa 02          	sar    $0x2,%rdx
    15cc:	48 89 c8             	mov    %rcx,%rax
    15cf:	48 c1 f8 3f          	sar    $0x3f,%rax
    15d3:	48 29 c2             	sub    %rax,%rdx
    15d6:	48 89 d0             	mov    %rdx,%rax
    15d9:	48 c1 e0 02          	shl    $0x2,%rax
    15dd:	48 01 d0             	add    %rdx,%rax
    15e0:	48 01 c0             	add    %rax,%rax
    15e3:	48 29 c1             	sub    %rax,%rcx
    15e6:	48 89 ca             	mov    %rcx,%rdx
    15e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    15ec:	8d 48 01             	lea    0x1(%rax),%ecx
    15ef:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    15f2:	48 b9 c0 1d 00 00 00 	movabs $0x1dc0,%rcx
    15f9:	00 00 00 
    15fc:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1600:	48 98                	cltq
    1602:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1606:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    160a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1611:	66 66 66 
    1614:	48 89 c8             	mov    %rcx,%rax
    1617:	48 f7 ea             	imul   %rdx
    161a:	48 89 d0             	mov    %rdx,%rax
    161d:	48 c1 f8 02          	sar    $0x2,%rax
    1621:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1625:	48 89 ca             	mov    %rcx,%rdx
    1628:	48 29 d0             	sub    %rdx,%rax
    162b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    162f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1634:	0f 85 7a ff ff ff    	jne    15b4 <print_d+0x28>

  if (v < 0)
    163a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    163e:	79 32                	jns    1672 <print_d+0xe6>
    buf[i++] = '-';
    1640:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1643:	8d 50 01             	lea    0x1(%rax),%edx
    1646:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1649:	48 98                	cltq
    164b:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1650:	eb 20                	jmp    1672 <print_d+0xe6>
    putc(fd, buf[i]);
    1652:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1655:	48 98                	cltq
    1657:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    165c:	0f be d0             	movsbl %al,%edx
    165f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1662:	89 d6                	mov    %edx,%esi
    1664:	89 c7                	mov    %eax,%edi
    1666:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    166d:	00 00 00 
    1670:	ff d0                	call   *%rax
  while (--i >= 0)
    1672:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1676:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    167a:	79 d6                	jns    1652 <print_d+0xc6>
}
    167c:	90                   	nop
    167d:	90                   	nop
    167e:	c9                   	leave
    167f:	c3                   	ret

0000000000001680 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1680:	55                   	push   %rbp
    1681:	48 89 e5             	mov    %rsp,%rbp
    1684:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    168b:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1691:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1698:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    169f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16a6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16ad:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16b4:	84 c0                	test   %al,%al
    16b6:	74 20                	je     16d8 <printf+0x58>
    16b8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16bc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    16c0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    16c4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    16c8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    16cc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    16d0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    16d4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    16d8:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    16df:	00 00 00 
    16e2:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    16e9:	00 00 00 
    16ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
    16f0:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    16f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    16fe:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1705:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    170c:	00 00 00 
    170f:	e9 60 03 00 00       	jmp    1a74 <printf+0x3f4>
    if (c != '%') {
    1714:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    171b:	74 24                	je     1741 <printf+0xc1>
      putc(fd, c);
    171d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1723:	0f be d0             	movsbl %al,%edx
    1726:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    172c:	89 d6                	mov    %edx,%esi
    172e:	89 c7                	mov    %eax,%edi
    1730:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1737:	00 00 00 
    173a:	ff d0                	call   *%rax
      continue;
    173c:	e9 2c 03 00 00       	jmp    1a6d <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1741:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1748:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    174e:	48 63 d0             	movslq %eax,%rdx
    1751:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1758:	48 01 d0             	add    %rdx,%rax
    175b:	0f b6 00             	movzbl (%rax),%eax
    175e:	0f be c0             	movsbl %al,%eax
    1761:	25 ff 00 00 00       	and    $0xff,%eax
    1766:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    176c:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1773:	0f 84 2e 03 00 00    	je     1aa7 <printf+0x427>
      break;
    switch(c) {
    1779:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1780:	0f 84 32 01 00 00    	je     18b8 <printf+0x238>
    1786:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    178d:	0f 8f a1 02 00 00    	jg     1a34 <printf+0x3b4>
    1793:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    179a:	0f 84 d4 01 00 00    	je     1974 <printf+0x2f4>
    17a0:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17a7:	0f 8f 87 02 00 00    	jg     1a34 <printf+0x3b4>
    17ad:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17b4:	0f 84 5b 01 00 00    	je     1915 <printf+0x295>
    17ba:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17c1:	0f 8f 6d 02 00 00    	jg     1a34 <printf+0x3b4>
    17c7:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    17ce:	0f 84 87 00 00 00    	je     185b <printf+0x1db>
    17d4:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    17db:	0f 8f 53 02 00 00    	jg     1a34 <printf+0x3b4>
    17e1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17e8:	0f 84 2b 02 00 00    	je     1a19 <printf+0x399>
    17ee:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    17f5:	0f 85 39 02 00 00    	jne    1a34 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    17fb:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1801:	83 f8 2f             	cmp    $0x2f,%eax
    1804:	77 23                	ja     1829 <printf+0x1a9>
    1806:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    180d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1813:	89 d2                	mov    %edx,%edx
    1815:	48 01 d0             	add    %rdx,%rax
    1818:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    181e:	83 c2 08             	add    $0x8,%edx
    1821:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1827:	eb 12                	jmp    183b <printf+0x1bb>
    1829:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1830:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1834:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    183b:	8b 00                	mov    (%rax),%eax
    183d:	0f be d0             	movsbl %al,%edx
    1840:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1846:	89 d6                	mov    %edx,%esi
    1848:	89 c7                	mov    %eax,%edi
    184a:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1851:	00 00 00 
    1854:	ff d0                	call   *%rax
      break;
    1856:	e9 12 02 00 00       	jmp    1a6d <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    185b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1861:	83 f8 2f             	cmp    $0x2f,%eax
    1864:	77 23                	ja     1889 <printf+0x209>
    1866:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    186d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1873:	89 d2                	mov    %edx,%edx
    1875:	48 01 d0             	add    %rdx,%rax
    1878:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    187e:	83 c2 08             	add    $0x8,%edx
    1881:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1887:	eb 12                	jmp    189b <printf+0x21b>
    1889:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1890:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1894:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    189b:	8b 10                	mov    (%rax),%edx
    189d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18a3:	89 d6                	mov    %edx,%esi
    18a5:	89 c7                	mov    %eax,%edi
    18a7:	48 b8 8c 15 00 00 00 	movabs $0x158c,%rax
    18ae:	00 00 00 
    18b1:	ff d0                	call   *%rax
      break;
    18b3:	e9 b5 01 00 00       	jmp    1a6d <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18b8:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18be:	83 f8 2f             	cmp    $0x2f,%eax
    18c1:	77 23                	ja     18e6 <printf+0x266>
    18c3:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ca:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18d0:	89 d2                	mov    %edx,%edx
    18d2:	48 01 d0             	add    %rdx,%rax
    18d5:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18db:	83 c2 08             	add    $0x8,%edx
    18de:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18e4:	eb 12                	jmp    18f8 <printf+0x278>
    18e6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18ed:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18f1:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18f8:	8b 10                	mov    (%rax),%edx
    18fa:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1900:	89 d6                	mov    %edx,%esi
    1902:	89 c7                	mov    %eax,%edi
    1904:	48 b8 33 15 00 00 00 	movabs $0x1533,%rax
    190b:	00 00 00 
    190e:	ff d0                	call   *%rax
      break;
    1910:	e9 58 01 00 00       	jmp    1a6d <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1915:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    191b:	83 f8 2f             	cmp    $0x2f,%eax
    191e:	77 23                	ja     1943 <printf+0x2c3>
    1920:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1927:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    192d:	89 d2                	mov    %edx,%edx
    192f:	48 01 d0             	add    %rdx,%rax
    1932:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1938:	83 c2 08             	add    $0x8,%edx
    193b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1941:	eb 12                	jmp    1955 <printf+0x2d5>
    1943:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    194a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    194e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1955:	48 8b 10             	mov    (%rax),%rdx
    1958:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    195e:	48 89 d6             	mov    %rdx,%rsi
    1961:	89 c7                	mov    %eax,%edi
    1963:	48 b8 da 14 00 00 00 	movabs $0x14da,%rax
    196a:	00 00 00 
    196d:	ff d0                	call   *%rax
      break;
    196f:	e9 f9 00 00 00       	jmp    1a6d <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1974:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    197a:	83 f8 2f             	cmp    $0x2f,%eax
    197d:	77 23                	ja     19a2 <printf+0x322>
    197f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1986:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    198c:	89 d2                	mov    %edx,%edx
    198e:	48 01 d0             	add    %rdx,%rax
    1991:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1997:	83 c2 08             	add    $0x8,%edx
    199a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19a0:	eb 12                	jmp    19b4 <printf+0x334>
    19a2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19a9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ad:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19b4:	48 8b 00             	mov    (%rax),%rax
    19b7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19be:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    19c5:	00 
    19c6:	75 41                	jne    1a09 <printf+0x389>
        s = "(null)";
    19c8:	48 b8 b4 1d 00 00 00 	movabs $0x1db4,%rax
    19cf:	00 00 00 
    19d2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    19d9:	eb 2e                	jmp    1a09 <printf+0x389>
        putc(fd, *(s++));
    19db:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    19e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
    19e6:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    19ed:	0f b6 00             	movzbl (%rax),%eax
    19f0:	0f be d0             	movsbl %al,%edx
    19f3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19f9:	89 d6                	mov    %edx,%esi
    19fb:	89 c7                	mov    %eax,%edi
    19fd:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1a04:	00 00 00 
    1a07:	ff d0                	call   *%rax
      while (*s)
    1a09:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a10:	0f b6 00             	movzbl (%rax),%eax
    1a13:	84 c0                	test   %al,%al
    1a15:	75 c4                	jne    19db <printf+0x35b>
      break;
    1a17:	eb 54                	jmp    1a6d <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1a19:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a1f:	be 25 00 00 00       	mov    $0x25,%esi
    1a24:	89 c7                	mov    %eax,%edi
    1a26:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1a2d:	00 00 00 
    1a30:	ff d0                	call   *%rax
      break;
    1a32:	eb 39                	jmp    1a6d <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a34:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a3a:	be 25 00 00 00       	mov    $0x25,%esi
    1a3f:	89 c7                	mov    %eax,%edi
    1a41:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1a48:	00 00 00 
    1a4b:	ff d0                	call   *%rax
      putc(fd, c);
    1a4d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a53:	0f be d0             	movsbl %al,%edx
    1a56:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5c:	89 d6                	mov    %edx,%esi
    1a5e:	89 c7                	mov    %eax,%edi
    1a60:	48 b8 aa 14 00 00 00 	movabs $0x14aa,%rax
    1a67:	00 00 00 
    1a6a:	ff d0                	call   *%rax
      break;
    1a6c:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1a6d:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a74:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a7a:	48 63 d0             	movslq %eax,%rdx
    1a7d:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1a84:	48 01 d0             	add    %rdx,%rax
    1a87:	0f b6 00             	movzbl (%rax),%eax
    1a8a:	0f be c0             	movsbl %al,%eax
    1a8d:	25 ff 00 00 00       	and    $0xff,%eax
    1a92:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1a98:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1a9f:	0f 85 6f fc ff ff    	jne    1714 <printf+0x94>
    }
  }
}
    1aa5:	eb 01                	jmp    1aa8 <printf+0x428>
      break;
    1aa7:	90                   	nop
}
    1aa8:	90                   	nop
    1aa9:	c9                   	leave
    1aaa:	c3                   	ret

0000000000001aab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1aab:	55                   	push   %rbp
    1aac:	48 89 e5             	mov    %rsp,%rbp
    1aaf:	48 83 ec 18          	sub    $0x18,%rsp
    1ab3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ab7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1abb:	48 83 e8 10          	sub    $0x10,%rax
    1abf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ac3:	48 b8 f0 1d 00 00 00 	movabs $0x1df0,%rax
    1aca:	00 00 00 
    1acd:	48 8b 00             	mov    (%rax),%rax
    1ad0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ad4:	eb 2f                	jmp    1b05 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ada:	48 8b 00             	mov    (%rax),%rax
    1add:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ae1:	72 17                	jb     1afa <free+0x4f>
    1ae3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ae7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1aeb:	72 2f                	jb     1b1c <free+0x71>
    1aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1af1:	48 8b 00             	mov    (%rax),%rax
    1af4:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1af8:	72 22                	jb     1b1c <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1afe:	48 8b 00             	mov    (%rax),%rax
    1b01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b09:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b0d:	73 c7                	jae    1ad6 <free+0x2b>
    1b0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b13:	48 8b 00             	mov    (%rax),%rax
    1b16:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b1a:	73 ba                	jae    1ad6 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b20:	8b 40 08             	mov    0x8(%rax),%eax
    1b23:	89 c0                	mov    %eax,%eax
    1b25:	48 c1 e0 04          	shl    $0x4,%rax
    1b29:	48 89 c2             	mov    %rax,%rdx
    1b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b30:	48 01 c2             	add    %rax,%rdx
    1b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b37:	48 8b 00             	mov    (%rax),%rax
    1b3a:	48 39 c2             	cmp    %rax,%rdx
    1b3d:	75 2d                	jne    1b6c <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b43:	8b 50 08             	mov    0x8(%rax),%edx
    1b46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b4a:	48 8b 00             	mov    (%rax),%rax
    1b4d:	8b 40 08             	mov    0x8(%rax),%eax
    1b50:	01 c2                	add    %eax,%edx
    1b52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b56:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b5d:	48 8b 00             	mov    (%rax),%rax
    1b60:	48 8b 10             	mov    (%rax),%rdx
    1b63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b67:	48 89 10             	mov    %rdx,(%rax)
    1b6a:	eb 0e                	jmp    1b7a <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b70:	48 8b 10             	mov    (%rax),%rdx
    1b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b77:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b7e:	8b 40 08             	mov    0x8(%rax),%eax
    1b81:	89 c0                	mov    %eax,%eax
    1b83:	48 c1 e0 04          	shl    $0x4,%rax
    1b87:	48 89 c2             	mov    %rax,%rdx
    1b8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8e:	48 01 d0             	add    %rdx,%rax
    1b91:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b95:	75 27                	jne    1bbe <free+0x113>
    p->s.size += bp->s.size;
    1b97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9b:	8b 50 08             	mov    0x8(%rax),%edx
    1b9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba2:	8b 40 08             	mov    0x8(%rax),%eax
    1ba5:	01 c2                	add    %eax,%edx
    1ba7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bab:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb2:	48 8b 10             	mov    (%rax),%rdx
    1bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb9:	48 89 10             	mov    %rdx,(%rax)
    1bbc:	eb 0b                	jmp    1bc9 <free+0x11e>
  } else
    p->s.ptr = bp;
    1bbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1bc6:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1bc9:	48 ba f0 1d 00 00 00 	movabs $0x1df0,%rdx
    1bd0:	00 00 00 
    1bd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd7:	48 89 02             	mov    %rax,(%rdx)
}
    1bda:	90                   	nop
    1bdb:	c9                   	leave
    1bdc:	c3                   	ret

0000000000001bdd <morecore>:

static Header*
morecore(uint nu)
{
    1bdd:	55                   	push   %rbp
    1bde:	48 89 e5             	mov    %rsp,%rbp
    1be1:	48 83 ec 20          	sub    $0x20,%rsp
    1be5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1be8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1bef:	77 07                	ja     1bf8 <morecore+0x1b>
    nu = 4096;
    1bf1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1bf8:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1bfb:	48 c1 e0 04          	shl    $0x4,%rax
    1bff:	48 89 c7             	mov    %rax,%rdi
    1c02:	48 b8 4f 14 00 00 00 	movabs $0x144f,%rax
    1c09:	00 00 00 
    1c0c:	ff d0                	call   *%rax
    1c0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c12:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c17:	75 07                	jne    1c20 <morecore+0x43>
    return 0;
    1c19:	b8 00 00 00 00       	mov    $0x0,%eax
    1c1e:	eb 36                	jmp    1c56 <morecore+0x79>
  hp = (Header*)p;
    1c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c24:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c2c:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c2f:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c36:	48 83 c0 10          	add    $0x10,%rax
    1c3a:	48 89 c7             	mov    %rax,%rdi
    1c3d:	48 b8 ab 1a 00 00 00 	movabs $0x1aab,%rax
    1c44:	00 00 00 
    1c47:	ff d0                	call   *%rax
  return freep;
    1c49:	48 b8 f0 1d 00 00 00 	movabs $0x1df0,%rax
    1c50:	00 00 00 
    1c53:	48 8b 00             	mov    (%rax),%rax
}
    1c56:	c9                   	leave
    1c57:	c3                   	ret

0000000000001c58 <malloc>:

void*
malloc(uint nbytes)
{
    1c58:	55                   	push   %rbp
    1c59:	48 89 e5             	mov    %rsp,%rbp
    1c5c:	48 83 ec 30          	sub    $0x30,%rsp
    1c60:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c63:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c66:	48 83 c0 0f          	add    $0xf,%rax
    1c6a:	48 c1 e8 04          	shr    $0x4,%rax
    1c6e:	83 c0 01             	add    $0x1,%eax
    1c71:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1c74:	48 b8 f0 1d 00 00 00 	movabs $0x1df0,%rax
    1c7b:	00 00 00 
    1c7e:	48 8b 00             	mov    (%rax),%rax
    1c81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c85:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1c8a:	75 4a                	jne    1cd6 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1c8c:	48 b8 e0 1d 00 00 00 	movabs $0x1de0,%rax
    1c93:	00 00 00 
    1c96:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c9a:	48 ba f0 1d 00 00 00 	movabs $0x1df0,%rdx
    1ca1:	00 00 00 
    1ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca8:	48 89 02             	mov    %rax,(%rdx)
    1cab:	48 b8 f0 1d 00 00 00 	movabs $0x1df0,%rax
    1cb2:	00 00 00 
    1cb5:	48 8b 00             	mov    (%rax),%rax
    1cb8:	48 ba e0 1d 00 00 00 	movabs $0x1de0,%rdx
    1cbf:	00 00 00 
    1cc2:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1cc5:	48 b8 e0 1d 00 00 00 	movabs $0x1de0,%rax
    1ccc:	00 00 00 
    1ccf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cda:	48 8b 00             	mov    (%rax),%rax
    1cdd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce5:	8b 40 08             	mov    0x8(%rax),%eax
    1ce8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1ceb:	72 65                	jb     1d52 <malloc+0xfa>
      if(p->s.size == nunits)
    1ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf1:	8b 40 08             	mov    0x8(%rax),%eax
    1cf4:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1cf7:	75 10                	jne    1d09 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1cf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfd:	48 8b 10             	mov    (%rax),%rdx
    1d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d04:	48 89 10             	mov    %rdx,(%rax)
    1d07:	eb 2e                	jmp    1d37 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0d:	8b 40 08             	mov    0x8(%rax),%eax
    1d10:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d13:	89 c2                	mov    %eax,%edx
    1d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d19:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d20:	8b 40 08             	mov    0x8(%rax),%eax
    1d23:	89 c0                	mov    %eax,%eax
    1d25:	48 c1 e0 04          	shl    $0x4,%rax
    1d29:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d31:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d34:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d37:	48 ba f0 1d 00 00 00 	movabs $0x1df0,%rdx
    1d3e:	00 00 00 
    1d41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d45:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4c:	48 83 c0 10          	add    $0x10,%rax
    1d50:	eb 4e                	jmp    1da0 <malloc+0x148>
    }
    if(p == freep)
    1d52:	48 b8 f0 1d 00 00 00 	movabs $0x1df0,%rax
    1d59:	00 00 00 
    1d5c:	48 8b 00             	mov    (%rax),%rax
    1d5f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d63:	75 23                	jne    1d88 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1d65:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d68:	89 c7                	mov    %eax,%edi
    1d6a:	48 b8 dd 1b 00 00 00 	movabs $0x1bdd,%rax
    1d71:	00 00 00 
    1d74:	ff d0                	call   *%rax
    1d76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d7a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1d7f:	75 07                	jne    1d88 <malloc+0x130>
        return 0;
    1d81:	b8 00 00 00 00       	mov    $0x0,%eax
    1d86:	eb 18                	jmp    1da0 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d94:	48 8b 00             	mov    (%rax),%rax
    1d97:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d9b:	e9 41 ff ff ff       	jmp    1ce1 <malloc+0x89>
  }
}
    1da0:	c9                   	leave
    1da1:	c3                   	ret
