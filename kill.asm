
_kill:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	53                   	push   %rbx
    1005:	48 83 ec 18          	sub    $0x18,%rsp
    1009:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  if(argc < 3){
    1010:	83 7d ec 02          	cmpl   $0x2,-0x14(%rbp)
    1014:	7f 2f                	jg     1045 <main+0x45>
    printf(2, "usage: kill pid signal\n");
    1016:	48 b8 e2 1d 00 00 00 	movabs $0x1de2,%rax
    101d:	00 00 00 
    1020:	48 89 c6             	mov    %rax,%rsi
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba c0 16 00 00 00 	movabs $0x16c0,%rdx
    1034:	00 00 00 
    1037:	ff d2                	call   *%rdx
    exit();
    1039:	48 b8 b2 13 00 00 00 	movabs $0x13b2,%rax
    1040:	00 00 00 
    1043:	ff d0                	call   *%rax
  }
  kill(atoi(argv[1]),atoi(argv[2]));
    1045:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1049:	48 83 c0 10          	add    $0x10,%rax
    104d:	48 8b 00             	mov    (%rax),%rax
    1050:	48 89 c7             	mov    %rax,%rdi
    1053:	48 b8 f8 12 00 00 00 	movabs $0x12f8,%rax
    105a:	00 00 00 
    105d:	ff d0                	call   *%rax
    105f:	89 c3                	mov    %eax,%ebx
    1061:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1065:	48 83 c0 08          	add    $0x8,%rax
    1069:	48 8b 00             	mov    (%rax),%rax
    106c:	48 89 c7             	mov    %rax,%rdi
    106f:	48 b8 f8 12 00 00 00 	movabs $0x12f8,%rax
    1076:	00 00 00 
    1079:	ff d0                	call   *%rax
    107b:	89 de                	mov    %ebx,%esi
    107d:	89 c7                	mov    %eax,%edi
    107f:	48 b8 00 14 00 00 00 	movabs $0x1400,%rax
    1086:	00 00 00 
    1089:	ff d0                	call   *%rax
  exit();
    108b:	48 b8 b2 13 00 00 00 	movabs $0x13b2,%rax
    1092:	00 00 00 
    1095:	ff d0                	call   *%rax

0000000000001097 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1097:	55                   	push   %rbp
    1098:	48 89 e5             	mov    %rsp,%rbp
    109b:	48 83 ec 10          	sub    $0x10,%rsp
    109f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10a6:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10a9:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10ad:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10b3:	48 89 ce             	mov    %rcx,%rsi
    10b6:	48 89 f7             	mov    %rsi,%rdi
    10b9:	89 d1                	mov    %edx,%ecx
    10bb:	fc                   	cld
    10bc:	f3 aa                	rep stos %al,(%rdi)
    10be:	89 ca                	mov    %ecx,%edx
    10c0:	48 89 fe             	mov    %rdi,%rsi
    10c3:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10c7:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10ca:	90                   	nop
    10cb:	c9                   	leave
    10cc:	c3                   	ret

00000000000010cd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10cd:	55                   	push   %rbp
    10ce:	48 89 e5             	mov    %rsp,%rbp
    10d1:	48 83 ec 20          	sub    $0x20,%rsp
    10d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10e5:	90                   	nop
    10e6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10ea:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10f6:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10fa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10fe:	0f b6 12             	movzbl (%rdx),%edx
    1101:	88 10                	mov    %dl,(%rax)
    1103:	0f b6 00             	movzbl (%rax),%eax
    1106:	84 c0                	test   %al,%al
    1108:	75 dc                	jne    10e6 <strcpy+0x19>
    ;
  return os;
    110a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    110e:	c9                   	leave
    110f:	c3                   	ret

0000000000001110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1110:	55                   	push   %rbp
    1111:	48 89 e5             	mov    %rsp,%rbp
    1114:	48 83 ec 10          	sub    $0x10,%rsp
    1118:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    111c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1120:	eb 0a                	jmp    112c <strcmp+0x1c>
    p++, q++;
    1122:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1127:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    112c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1130:	0f b6 00             	movzbl (%rax),%eax
    1133:	84 c0                	test   %al,%al
    1135:	74 12                	je     1149 <strcmp+0x39>
    1137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    113b:	0f b6 10             	movzbl (%rax),%edx
    113e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1142:	0f b6 00             	movzbl (%rax),%eax
    1145:	38 c2                	cmp    %al,%dl
    1147:	74 d9                	je     1122 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    114d:	0f b6 00             	movzbl (%rax),%eax
    1150:	0f b6 d0             	movzbl %al,%edx
    1153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1157:	0f b6 00             	movzbl (%rax),%eax
    115a:	0f b6 c0             	movzbl %al,%eax
    115d:	29 c2                	sub    %eax,%edx
    115f:	89 d0                	mov    %edx,%eax
}
    1161:	c9                   	leave
    1162:	c3                   	ret

0000000000001163 <strlen>:

uint
strlen(char *s)
{
    1163:	55                   	push   %rbp
    1164:	48 89 e5             	mov    %rsp,%rbp
    1167:	48 83 ec 18          	sub    $0x18,%rsp
    116b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    116f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1176:	eb 04                	jmp    117c <strlen+0x19>
    1178:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    117c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    117f:	48 63 d0             	movslq %eax,%rdx
    1182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1186:	48 01 d0             	add    %rdx,%rax
    1189:	0f b6 00             	movzbl (%rax),%eax
    118c:	84 c0                	test   %al,%al
    118e:	75 e8                	jne    1178 <strlen+0x15>
    ;
  return n;
    1190:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1193:	c9                   	leave
    1194:	c3                   	ret

0000000000001195 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1195:	55                   	push   %rbp
    1196:	48 89 e5             	mov    %rsp,%rbp
    1199:	48 83 ec 10          	sub    $0x10,%rsp
    119d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11a4:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11a7:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11aa:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11b1:	89 ce                	mov    %ecx,%esi
    11b3:	48 89 c7             	mov    %rax,%rdi
    11b6:	48 b8 97 10 00 00 00 	movabs $0x1097,%rax
    11bd:	00 00 00 
    11c0:	ff d0                	call   *%rax
  return dst;
    11c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11c6:	c9                   	leave
    11c7:	c3                   	ret

00000000000011c8 <strchr>:

char*
strchr(const char *s, char c)
{
    11c8:	55                   	push   %rbp
    11c9:	48 89 e5             	mov    %rsp,%rbp
    11cc:	48 83 ec 10          	sub    $0x10,%rsp
    11d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d4:	89 f0                	mov    %esi,%eax
    11d6:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11d9:	eb 17                	jmp    11f2 <strchr+0x2a>
    if(*s == c)
    11db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11df:	0f b6 00             	movzbl (%rax),%eax
    11e2:	38 45 f4             	cmp    %al,-0xc(%rbp)
    11e5:	75 06                	jne    11ed <strchr+0x25>
      return (char*)s;
    11e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11eb:	eb 15                	jmp    1202 <strchr+0x3a>
  for(; *s; s++)
    11ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11f6:	0f b6 00             	movzbl (%rax),%eax
    11f9:	84 c0                	test   %al,%al
    11fb:	75 de                	jne    11db <strchr+0x13>
  return 0;
    11fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1202:	c9                   	leave
    1203:	c3                   	ret

0000000000001204 <gets>:

char*
gets(char *buf, int max)
{
    1204:	55                   	push   %rbp
    1205:	48 89 e5             	mov    %rsp,%rbp
    1208:	48 83 ec 20          	sub    $0x20,%rsp
    120c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1210:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    121a:	eb 4f                	jmp    126b <gets+0x67>
    cc = read(0, &c, 1);
    121c:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1220:	ba 01 00 00 00       	mov    $0x1,%edx
    1225:	48 89 c6             	mov    %rax,%rsi
    1228:	bf 00 00 00 00       	mov    $0x0,%edi
    122d:	48 b8 d9 13 00 00 00 	movabs $0x13d9,%rax
    1234:	00 00 00 
    1237:	ff d0                	call   *%rax
    1239:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    123c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1240:	7e 36                	jle    1278 <gets+0x74>
      break;
    buf[i++] = c;
    1242:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1245:	8d 50 01             	lea    0x1(%rax),%edx
    1248:	89 55 fc             	mov    %edx,-0x4(%rbp)
    124b:	48 63 d0             	movslq %eax,%rdx
    124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1252:	48 01 c2             	add    %rax,%rdx
    1255:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1259:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    125b:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    125f:	3c 0a                	cmp    $0xa,%al
    1261:	74 16                	je     1279 <gets+0x75>
    1263:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1267:	3c 0d                	cmp    $0xd,%al
    1269:	74 0e                	je     1279 <gets+0x75>
  for(i=0; i+1 < max; ){
    126b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    126e:	83 c0 01             	add    $0x1,%eax
    1271:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1274:	7f a6                	jg     121c <gets+0x18>
    1276:	eb 01                	jmp    1279 <gets+0x75>
      break;
    1278:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1279:	8b 45 fc             	mov    -0x4(%rbp),%eax
    127c:	48 63 d0             	movslq %eax,%rdx
    127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1283:	48 01 d0             	add    %rdx,%rax
    1286:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1289:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    128d:	c9                   	leave
    128e:	c3                   	ret

000000000000128f <stat>:

int
stat(char *n, struct stat *st)
{
    128f:	55                   	push   %rbp
    1290:	48 89 e5             	mov    %rsp,%rbp
    1293:	48 83 ec 20          	sub    $0x20,%rsp
    1297:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    129b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a3:	be 00 00 00 00       	mov    $0x0,%esi
    12a8:	48 89 c7             	mov    %rax,%rdi
    12ab:	48 b8 1a 14 00 00 00 	movabs $0x141a,%rax
    12b2:	00 00 00 
    12b5:	ff d0                	call   *%rax
    12b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12be:	79 07                	jns    12c7 <stat+0x38>
    return -1;
    12c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12c5:	eb 2f                	jmp    12f6 <stat+0x67>
  r = fstat(fd, st);
    12c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ce:	48 89 d6             	mov    %rdx,%rsi
    12d1:	89 c7                	mov    %eax,%edi
    12d3:	48 b8 41 14 00 00 00 	movabs $0x1441,%rax
    12da:	00 00 00 
    12dd:	ff d0                	call   *%rax
    12df:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12e5:	89 c7                	mov    %eax,%edi
    12e7:	48 b8 f3 13 00 00 00 	movabs $0x13f3,%rax
    12ee:	00 00 00 
    12f1:	ff d0                	call   *%rax
  return r;
    12f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12f6:	c9                   	leave
    12f7:	c3                   	ret

00000000000012f8 <atoi>:

int
atoi(const char *s)
{
    12f8:	55                   	push   %rbp
    12f9:	48 89 e5             	mov    %rsp,%rbp
    12fc:	48 83 ec 18          	sub    $0x18,%rsp
    1300:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    130b:	eb 28                	jmp    1335 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    130d:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1310:	89 d0                	mov    %edx,%eax
    1312:	c1 e0 02             	shl    $0x2,%eax
    1315:	01 d0                	add    %edx,%eax
    1317:	01 c0                	add    %eax,%eax
    1319:	89 c1                	mov    %eax,%ecx
    131b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    131f:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1323:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1327:	0f b6 00             	movzbl (%rax),%eax
    132a:	0f be c0             	movsbl %al,%eax
    132d:	01 c8                	add    %ecx,%eax
    132f:	83 e8 30             	sub    $0x30,%eax
    1332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1339:	0f b6 00             	movzbl (%rax),%eax
    133c:	3c 2f                	cmp    $0x2f,%al
    133e:	7e 0b                	jle    134b <atoi+0x53>
    1340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1344:	0f b6 00             	movzbl (%rax),%eax
    1347:	3c 39                	cmp    $0x39,%al
    1349:	7e c2                	jle    130d <atoi+0x15>
  return n;
    134b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    134e:	c9                   	leave
    134f:	c3                   	ret

0000000000001350 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1350:	55                   	push   %rbp
    1351:	48 89 e5             	mov    %rsp,%rbp
    1354:	48 83 ec 28          	sub    $0x28,%rsp
    1358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    135c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1360:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1367:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    136b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    136f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1373:	eb 1d                	jmp    1392 <memmove+0x42>
    *dst++ = *src++;
    1375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1379:	48 8d 42 01          	lea    0x1(%rdx),%rax
    137d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1385:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1389:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    138d:	0f b6 12             	movzbl (%rdx),%edx
    1390:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1392:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1395:	8d 50 ff             	lea    -0x1(%rax),%edx
    1398:	89 55 dc             	mov    %edx,-0x24(%rbp)
    139b:	85 c0                	test   %eax,%eax
    139d:	7f d6                	jg     1375 <memmove+0x25>
  return vdst;
    139f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13a3:	c9                   	leave
    13a4:	c3                   	ret

00000000000013a5 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13a5:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13ac:	49 89 ca             	mov    %rcx,%r10
    13af:	0f 05                	syscall
    13b1:	c3                   	ret

00000000000013b2 <exit>:
SYSCALL(exit)
    13b2:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13b9:	49 89 ca             	mov    %rcx,%r10
    13bc:	0f 05                	syscall
    13be:	c3                   	ret

00000000000013bf <wait>:
SYSCALL(wait)
    13bf:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13c6:	49 89 ca             	mov    %rcx,%r10
    13c9:	0f 05                	syscall
    13cb:	c3                   	ret

00000000000013cc <pipe>:
SYSCALL(pipe)
    13cc:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13d3:	49 89 ca             	mov    %rcx,%r10
    13d6:	0f 05                	syscall
    13d8:	c3                   	ret

00000000000013d9 <read>:
SYSCALL(read)
    13d9:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13e0:	49 89 ca             	mov    %rcx,%r10
    13e3:	0f 05                	syscall
    13e5:	c3                   	ret

00000000000013e6 <write>:
SYSCALL(write)
    13e6:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13ed:	49 89 ca             	mov    %rcx,%r10
    13f0:	0f 05                	syscall
    13f2:	c3                   	ret

00000000000013f3 <close>:
SYSCALL(close)
    13f3:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13fa:	49 89 ca             	mov    %rcx,%r10
    13fd:	0f 05                	syscall
    13ff:	c3                   	ret

0000000000001400 <kill>:
SYSCALL(kill)
    1400:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1407:	49 89 ca             	mov    %rcx,%r10
    140a:	0f 05                	syscall
    140c:	c3                   	ret

000000000000140d <exec>:
SYSCALL(exec)
    140d:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1414:	49 89 ca             	mov    %rcx,%r10
    1417:	0f 05                	syscall
    1419:	c3                   	ret

000000000000141a <open>:
SYSCALL(open)
    141a:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1421:	49 89 ca             	mov    %rcx,%r10
    1424:	0f 05                	syscall
    1426:	c3                   	ret

0000000000001427 <mknod>:
SYSCALL(mknod)
    1427:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    142e:	49 89 ca             	mov    %rcx,%r10
    1431:	0f 05                	syscall
    1433:	c3                   	ret

0000000000001434 <unlink>:
SYSCALL(unlink)
    1434:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    143b:	49 89 ca             	mov    %rcx,%r10
    143e:	0f 05                	syscall
    1440:	c3                   	ret

0000000000001441 <fstat>:
SYSCALL(fstat)
    1441:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1448:	49 89 ca             	mov    %rcx,%r10
    144b:	0f 05                	syscall
    144d:	c3                   	ret

000000000000144e <link>:
SYSCALL(link)
    144e:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1455:	49 89 ca             	mov    %rcx,%r10
    1458:	0f 05                	syscall
    145a:	c3                   	ret

000000000000145b <mkdir>:
SYSCALL(mkdir)
    145b:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1462:	49 89 ca             	mov    %rcx,%r10
    1465:	0f 05                	syscall
    1467:	c3                   	ret

0000000000001468 <chdir>:
SYSCALL(chdir)
    1468:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    146f:	49 89 ca             	mov    %rcx,%r10
    1472:	0f 05                	syscall
    1474:	c3                   	ret

0000000000001475 <dup>:
SYSCALL(dup)
    1475:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    147c:	49 89 ca             	mov    %rcx,%r10
    147f:	0f 05                	syscall
    1481:	c3                   	ret

0000000000001482 <getpid>:
SYSCALL(getpid)
    1482:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1489:	49 89 ca             	mov    %rcx,%r10
    148c:	0f 05                	syscall
    148e:	c3                   	ret

000000000000148f <sbrk>:
SYSCALL(sbrk)
    148f:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1496:	49 89 ca             	mov    %rcx,%r10
    1499:	0f 05                	syscall
    149b:	c3                   	ret

000000000000149c <sleep>:
SYSCALL(sleep)
    149c:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14a3:	49 89 ca             	mov    %rcx,%r10
    14a6:	0f 05                	syscall
    14a8:	c3                   	ret

00000000000014a9 <uptime>:
SYSCALL(uptime)
    14a9:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14b0:	49 89 ca             	mov    %rcx,%r10
    14b3:	0f 05                	syscall
    14b5:	c3                   	ret

00000000000014b6 <alarm>:

SYSCALL(alarm)
    14b6:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14bd:	49 89 ca             	mov    %rcx,%r10
    14c0:	0f 05                	syscall
    14c2:	c3                   	ret

00000000000014c3 <signal>:
SYSCALL(signal)
    14c3:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14ca:	49 89 ca             	mov    %rcx,%r10
    14cd:	0f 05                	syscall
    14cf:	c3                   	ret

00000000000014d0 <sigret>:
SYSCALL(sigret)
    14d0:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    14d7:	49 89 ca             	mov    %rcx,%r10
    14da:	0f 05                	syscall
    14dc:	c3                   	ret

00000000000014dd <fgproc>:
SYSCALL(fgproc)
    14dd:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    14e4:	49 89 ca             	mov    %rcx,%r10
    14e7:	0f 05                	syscall
    14e9:	c3                   	ret

00000000000014ea <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14ea:	55                   	push   %rbp
    14eb:	48 89 e5             	mov    %rsp,%rbp
    14ee:	48 83 ec 10          	sub    $0x10,%rsp
    14f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14f5:	89 f0                	mov    %esi,%eax
    14f7:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14fa:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1501:	ba 01 00 00 00       	mov    $0x1,%edx
    1506:	48 89 ce             	mov    %rcx,%rsi
    1509:	89 c7                	mov    %eax,%edi
    150b:	48 b8 e6 13 00 00 00 	movabs $0x13e6,%rax
    1512:	00 00 00 
    1515:	ff d0                	call   *%rax
}
    1517:	90                   	nop
    1518:	c9                   	leave
    1519:	c3                   	ret

000000000000151a <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    151a:	55                   	push   %rbp
    151b:	48 89 e5             	mov    %rsp,%rbp
    151e:	48 83 ec 20          	sub    $0x20,%rsp
    1522:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1525:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1529:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1530:	eb 35                	jmp    1567 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1536:	48 c1 e8 3c          	shr    $0x3c,%rax
    153a:	48 ba 10 1e 00 00 00 	movabs $0x1e10,%rdx
    1541:	00 00 00 
    1544:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1548:	0f be d0             	movsbl %al,%edx
    154b:	8b 45 ec             	mov    -0x14(%rbp),%eax
    154e:	89 d6                	mov    %edx,%esi
    1550:	89 c7                	mov    %eax,%edi
    1552:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    1559:	00 00 00 
    155c:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    155e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1562:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1567:	8b 45 fc             	mov    -0x4(%rbp),%eax
    156a:	83 f8 0f             	cmp    $0xf,%eax
    156d:	76 c3                	jbe    1532 <print_x64+0x18>
}
    156f:	90                   	nop
    1570:	90                   	nop
    1571:	c9                   	leave
    1572:	c3                   	ret

0000000000001573 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1573:	55                   	push   %rbp
    1574:	48 89 e5             	mov    %rsp,%rbp
    1577:	48 83 ec 20          	sub    $0x20,%rsp
    157b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    157e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1588:	eb 36                	jmp    15c0 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    158a:	8b 45 e8             	mov    -0x18(%rbp),%eax
    158d:	c1 e8 1c             	shr    $0x1c,%eax
    1590:	89 c2                	mov    %eax,%edx
    1592:	48 b8 10 1e 00 00 00 	movabs $0x1e10,%rax
    1599:	00 00 00 
    159c:	89 d2                	mov    %edx,%edx
    159e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15a2:	0f be d0             	movsbl %al,%edx
    15a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15a8:	89 d6                	mov    %edx,%esi
    15aa:	89 c7                	mov    %eax,%edi
    15ac:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    15b3:	00 00 00 
    15b6:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15bc:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15c3:	83 f8 07             	cmp    $0x7,%eax
    15c6:	76 c2                	jbe    158a <print_x32+0x17>
}
    15c8:	90                   	nop
    15c9:	90                   	nop
    15ca:	c9                   	leave
    15cb:	c3                   	ret

00000000000015cc <print_d>:

  static void
print_d(int fd, int v)
{
    15cc:	55                   	push   %rbp
    15cd:	48 89 e5             	mov    %rsp,%rbp
    15d0:	48 83 ec 30          	sub    $0x30,%rsp
    15d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15d7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15da:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15dd:	48 98                	cltq
    15df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15e7:	79 04                	jns    15ed <print_d+0x21>
    x = -x;
    15e9:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15f4:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15f8:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15ff:	66 66 66 
    1602:	48 89 c8             	mov    %rcx,%rax
    1605:	48 f7 ea             	imul   %rdx
    1608:	48 c1 fa 02          	sar    $0x2,%rdx
    160c:	48 89 c8             	mov    %rcx,%rax
    160f:	48 c1 f8 3f          	sar    $0x3f,%rax
    1613:	48 29 c2             	sub    %rax,%rdx
    1616:	48 89 d0             	mov    %rdx,%rax
    1619:	48 c1 e0 02          	shl    $0x2,%rax
    161d:	48 01 d0             	add    %rdx,%rax
    1620:	48 01 c0             	add    %rax,%rax
    1623:	48 29 c1             	sub    %rax,%rcx
    1626:	48 89 ca             	mov    %rcx,%rdx
    1629:	8b 45 f4             	mov    -0xc(%rbp),%eax
    162c:	8d 48 01             	lea    0x1(%rax),%ecx
    162f:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1632:	48 b9 10 1e 00 00 00 	movabs $0x1e10,%rcx
    1639:	00 00 00 
    163c:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1640:	48 98                	cltq
    1642:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1646:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    164a:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1651:	66 66 66 
    1654:	48 89 c8             	mov    %rcx,%rax
    1657:	48 f7 ea             	imul   %rdx
    165a:	48 89 d0             	mov    %rdx,%rax
    165d:	48 c1 f8 02          	sar    $0x2,%rax
    1661:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1665:	48 89 ca             	mov    %rcx,%rdx
    1668:	48 29 d0             	sub    %rdx,%rax
    166b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    166f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1674:	0f 85 7a ff ff ff    	jne    15f4 <print_d+0x28>

  if (v < 0)
    167a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    167e:	79 32                	jns    16b2 <print_d+0xe6>
    buf[i++] = '-';
    1680:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1683:	8d 50 01             	lea    0x1(%rax),%edx
    1686:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1689:	48 98                	cltq
    168b:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1690:	eb 20                	jmp    16b2 <print_d+0xe6>
    putc(fd, buf[i]);
    1692:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1695:	48 98                	cltq
    1697:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    169c:	0f be d0             	movsbl %al,%edx
    169f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16a2:	89 d6                	mov    %edx,%esi
    16a4:	89 c7                	mov    %eax,%edi
    16a6:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    16ad:	00 00 00 
    16b0:	ff d0                	call   *%rax
  while (--i >= 0)
    16b2:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16ba:	79 d6                	jns    1692 <print_d+0xc6>
}
    16bc:	90                   	nop
    16bd:	90                   	nop
    16be:	c9                   	leave
    16bf:	c3                   	ret

00000000000016c0 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16c0:	55                   	push   %rbp
    16c1:	48 89 e5             	mov    %rsp,%rbp
    16c4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16cb:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16d1:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16d8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16df:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16e6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16ed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16f4:	84 c0                	test   %al,%al
    16f6:	74 20                	je     1718 <printf+0x58>
    16f8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16fc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1700:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1704:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1708:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    170c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1710:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1714:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1718:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    171f:	00 00 00 
    1722:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1729:	00 00 00 
    172c:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1730:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1737:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    173e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1745:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    174c:	00 00 00 
    174f:	e9 60 03 00 00       	jmp    1ab4 <printf+0x3f4>
    if (c != '%') {
    1754:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    175b:	74 24                	je     1781 <printf+0xc1>
      putc(fd, c);
    175d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1763:	0f be d0             	movsbl %al,%edx
    1766:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    176c:	89 d6                	mov    %edx,%esi
    176e:	89 c7                	mov    %eax,%edi
    1770:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    1777:	00 00 00 
    177a:	ff d0                	call   *%rax
      continue;
    177c:	e9 2c 03 00 00       	jmp    1aad <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1781:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1788:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    178e:	48 63 d0             	movslq %eax,%rdx
    1791:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1798:	48 01 d0             	add    %rdx,%rax
    179b:	0f b6 00             	movzbl (%rax),%eax
    179e:	0f be c0             	movsbl %al,%eax
    17a1:	25 ff 00 00 00       	and    $0xff,%eax
    17a6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17ac:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17b3:	0f 84 2e 03 00 00    	je     1ae7 <printf+0x427>
      break;
    switch(c) {
    17b9:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17c0:	0f 84 32 01 00 00    	je     18f8 <printf+0x238>
    17c6:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17cd:	0f 8f a1 02 00 00    	jg     1a74 <printf+0x3b4>
    17d3:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17da:	0f 84 d4 01 00 00    	je     19b4 <printf+0x2f4>
    17e0:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17e7:	0f 8f 87 02 00 00    	jg     1a74 <printf+0x3b4>
    17ed:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17f4:	0f 84 5b 01 00 00    	je     1955 <printf+0x295>
    17fa:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1801:	0f 8f 6d 02 00 00    	jg     1a74 <printf+0x3b4>
    1807:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    180e:	0f 84 87 00 00 00    	je     189b <printf+0x1db>
    1814:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    181b:	0f 8f 53 02 00 00    	jg     1a74 <printf+0x3b4>
    1821:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1828:	0f 84 2b 02 00 00    	je     1a59 <printf+0x399>
    182e:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1835:	0f 85 39 02 00 00    	jne    1a74 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    183b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1841:	83 f8 2f             	cmp    $0x2f,%eax
    1844:	77 23                	ja     1869 <printf+0x1a9>
    1846:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    184d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1853:	89 d2                	mov    %edx,%edx
    1855:	48 01 d0             	add    %rdx,%rax
    1858:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    185e:	83 c2 08             	add    $0x8,%edx
    1861:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1867:	eb 12                	jmp    187b <printf+0x1bb>
    1869:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1870:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1874:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    187b:	8b 00                	mov    (%rax),%eax
    187d:	0f be d0             	movsbl %al,%edx
    1880:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1886:	89 d6                	mov    %edx,%esi
    1888:	89 c7                	mov    %eax,%edi
    188a:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    1891:	00 00 00 
    1894:	ff d0                	call   *%rax
      break;
    1896:	e9 12 02 00 00       	jmp    1aad <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    189b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18a1:	83 f8 2f             	cmp    $0x2f,%eax
    18a4:	77 23                	ja     18c9 <printf+0x209>
    18a6:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ad:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18b3:	89 d2                	mov    %edx,%edx
    18b5:	48 01 d0             	add    %rdx,%rax
    18b8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18be:	83 c2 08             	add    $0x8,%edx
    18c1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18c7:	eb 12                	jmp    18db <printf+0x21b>
    18c9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18d0:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18d4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18db:	8b 10                	mov    (%rax),%edx
    18dd:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18e3:	89 d6                	mov    %edx,%esi
    18e5:	89 c7                	mov    %eax,%edi
    18e7:	48 b8 cc 15 00 00 00 	movabs $0x15cc,%rax
    18ee:	00 00 00 
    18f1:	ff d0                	call   *%rax
      break;
    18f3:	e9 b5 01 00 00       	jmp    1aad <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18f8:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18fe:	83 f8 2f             	cmp    $0x2f,%eax
    1901:	77 23                	ja     1926 <printf+0x266>
    1903:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    190a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1910:	89 d2                	mov    %edx,%edx
    1912:	48 01 d0             	add    %rdx,%rax
    1915:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    191b:	83 c2 08             	add    $0x8,%edx
    191e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1924:	eb 12                	jmp    1938 <printf+0x278>
    1926:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    192d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1931:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1938:	8b 10                	mov    (%rax),%edx
    193a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1940:	89 d6                	mov    %edx,%esi
    1942:	89 c7                	mov    %eax,%edi
    1944:	48 b8 73 15 00 00 00 	movabs $0x1573,%rax
    194b:	00 00 00 
    194e:	ff d0                	call   *%rax
      break;
    1950:	e9 58 01 00 00       	jmp    1aad <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1955:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    195b:	83 f8 2f             	cmp    $0x2f,%eax
    195e:	77 23                	ja     1983 <printf+0x2c3>
    1960:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1967:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196d:	89 d2                	mov    %edx,%edx
    196f:	48 01 d0             	add    %rdx,%rax
    1972:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1978:	83 c2 08             	add    $0x8,%edx
    197b:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1981:	eb 12                	jmp    1995 <printf+0x2d5>
    1983:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    198a:	48 8d 50 08          	lea    0x8(%rax),%rdx
    198e:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1995:	48 8b 10             	mov    (%rax),%rdx
    1998:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    199e:	48 89 d6             	mov    %rdx,%rsi
    19a1:	89 c7                	mov    %eax,%edi
    19a3:	48 b8 1a 15 00 00 00 	movabs $0x151a,%rax
    19aa:	00 00 00 
    19ad:	ff d0                	call   *%rax
      break;
    19af:	e9 f9 00 00 00       	jmp    1aad <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19b4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19ba:	83 f8 2f             	cmp    $0x2f,%eax
    19bd:	77 23                	ja     19e2 <printf+0x322>
    19bf:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19c6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19cc:	89 d2                	mov    %edx,%edx
    19ce:	48 01 d0             	add    %rdx,%rax
    19d1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d7:	83 c2 08             	add    $0x8,%edx
    19da:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19e0:	eb 12                	jmp    19f4 <printf+0x334>
    19e2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19e9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19ed:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19f4:	48 8b 00             	mov    (%rax),%rax
    19f7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19fe:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a05:	00 
    1a06:	75 41                	jne    1a49 <printf+0x389>
        s = "(null)";
    1a08:	48 b8 fa 1d 00 00 00 	movabs $0x1dfa,%rax
    1a0f:	00 00 00 
    1a12:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a19:	eb 2e                	jmp    1a49 <printf+0x389>
        putc(fd, *(s++));
    1a1b:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a22:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a26:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a2d:	0f b6 00             	movzbl (%rax),%eax
    1a30:	0f be d0             	movsbl %al,%edx
    1a33:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a39:	89 d6                	mov    %edx,%esi
    1a3b:	89 c7                	mov    %eax,%edi
    1a3d:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    1a44:	00 00 00 
    1a47:	ff d0                	call   *%rax
      while (*s)
    1a49:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a50:	0f b6 00             	movzbl (%rax),%eax
    1a53:	84 c0                	test   %al,%al
    1a55:	75 c4                	jne    1a1b <printf+0x35b>
      break;
    1a57:	eb 54                	jmp    1aad <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1a59:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5f:	be 25 00 00 00       	mov    $0x25,%esi
    1a64:	89 c7                	mov    %eax,%edi
    1a66:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    1a6d:	00 00 00 
    1a70:	ff d0                	call   *%rax
      break;
    1a72:	eb 39                	jmp    1aad <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a74:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a7a:	be 25 00 00 00       	mov    $0x25,%esi
    1a7f:	89 c7                	mov    %eax,%edi
    1a81:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    1a88:	00 00 00 
    1a8b:	ff d0                	call   *%rax
      putc(fd, c);
    1a8d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a93:	0f be d0             	movsbl %al,%edx
    1a96:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a9c:	89 d6                	mov    %edx,%esi
    1a9e:	89 c7                	mov    %eax,%edi
    1aa0:	48 b8 ea 14 00 00 00 	movabs $0x14ea,%rax
    1aa7:	00 00 00 
    1aaa:	ff d0                	call   *%rax
      break;
    1aac:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1aad:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ab4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1aba:	48 63 d0             	movslq %eax,%rdx
    1abd:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ac4:	48 01 d0             	add    %rdx,%rax
    1ac7:	0f b6 00             	movzbl (%rax),%eax
    1aca:	0f be c0             	movsbl %al,%eax
    1acd:	25 ff 00 00 00       	and    $0xff,%eax
    1ad2:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ad8:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1adf:	0f 85 6f fc ff ff    	jne    1754 <printf+0x94>
    }
  }
}
    1ae5:	eb 01                	jmp    1ae8 <printf+0x428>
      break;
    1ae7:	90                   	nop
}
    1ae8:	90                   	nop
    1ae9:	c9                   	leave
    1aea:	c3                   	ret

0000000000001aeb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1aeb:	55                   	push   %rbp
    1aec:	48 89 e5             	mov    %rsp,%rbp
    1aef:	48 83 ec 18          	sub    $0x18,%rsp
    1af3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1afb:	48 83 e8 10          	sub    $0x10,%rax
    1aff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b03:	48 b8 40 1e 00 00 00 	movabs $0x1e40,%rax
    1b0a:	00 00 00 
    1b0d:	48 8b 00             	mov    (%rax),%rax
    1b10:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b14:	eb 2f                	jmp    1b45 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b1a:	48 8b 00             	mov    (%rax),%rax
    1b1d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b21:	72 17                	jb     1b3a <free+0x4f>
    1b23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b27:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b2b:	72 2f                	jb     1b5c <free+0x71>
    1b2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b31:	48 8b 00             	mov    (%rax),%rax
    1b34:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b38:	72 22                	jb     1b5c <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3e:	48 8b 00             	mov    (%rax),%rax
    1b41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b49:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b4d:	73 c7                	jae    1b16 <free+0x2b>
    1b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b53:	48 8b 00             	mov    (%rax),%rax
    1b56:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b5a:	73 ba                	jae    1b16 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b60:	8b 40 08             	mov    0x8(%rax),%eax
    1b63:	89 c0                	mov    %eax,%eax
    1b65:	48 c1 e0 04          	shl    $0x4,%rax
    1b69:	48 89 c2             	mov    %rax,%rdx
    1b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b70:	48 01 c2             	add    %rax,%rdx
    1b73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b77:	48 8b 00             	mov    (%rax),%rax
    1b7a:	48 39 c2             	cmp    %rax,%rdx
    1b7d:	75 2d                	jne    1bac <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1b7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b83:	8b 50 08             	mov    0x8(%rax),%edx
    1b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8a:	48 8b 00             	mov    (%rax),%rax
    1b8d:	8b 40 08             	mov    0x8(%rax),%eax
    1b90:	01 c2                	add    %eax,%edx
    1b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b96:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9d:	48 8b 00             	mov    (%rax),%rax
    1ba0:	48 8b 10             	mov    (%rax),%rdx
    1ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba7:	48 89 10             	mov    %rdx,(%rax)
    1baa:	eb 0e                	jmp    1bba <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bb0:	48 8b 10             	mov    (%rax),%rdx
    1bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb7:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbe:	8b 40 08             	mov    0x8(%rax),%eax
    1bc1:	89 c0                	mov    %eax,%eax
    1bc3:	48 c1 e0 04          	shl    $0x4,%rax
    1bc7:	48 89 c2             	mov    %rax,%rdx
    1bca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bce:	48 01 d0             	add    %rdx,%rax
    1bd1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bd5:	75 27                	jne    1bfe <free+0x113>
    p->s.size += bp->s.size;
    1bd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bdb:	8b 50 08             	mov    0x8(%rax),%edx
    1bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be2:	8b 40 08             	mov    0x8(%rax),%eax
    1be5:	01 c2                	add    %eax,%edx
    1be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1beb:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf2:	48 8b 10             	mov    (%rax),%rdx
    1bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf9:	48 89 10             	mov    %rdx,(%rax)
    1bfc:	eb 0b                	jmp    1c09 <free+0x11e>
  } else
    p->s.ptr = bp;
    1bfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c06:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c09:	48 ba 40 1e 00 00 00 	movabs $0x1e40,%rdx
    1c10:	00 00 00 
    1c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c17:	48 89 02             	mov    %rax,(%rdx)
}
    1c1a:	90                   	nop
    1c1b:	c9                   	leave
    1c1c:	c3                   	ret

0000000000001c1d <morecore>:

static Header*
morecore(uint nu)
{
    1c1d:	55                   	push   %rbp
    1c1e:	48 89 e5             	mov    %rsp,%rbp
    1c21:	48 83 ec 20          	sub    $0x20,%rsp
    1c25:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c28:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c2f:	77 07                	ja     1c38 <morecore+0x1b>
    nu = 4096;
    1c31:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c38:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c3b:	48 c1 e0 04          	shl    $0x4,%rax
    1c3f:	48 89 c7             	mov    %rax,%rdi
    1c42:	48 b8 8f 14 00 00 00 	movabs $0x148f,%rax
    1c49:	00 00 00 
    1c4c:	ff d0                	call   *%rax
    1c4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c52:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c57:	75 07                	jne    1c60 <morecore+0x43>
    return 0;
    1c59:	b8 00 00 00 00       	mov    $0x0,%eax
    1c5e:	eb 36                	jmp    1c96 <morecore+0x79>
  hp = (Header*)p;
    1c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6c:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c6f:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c76:	48 83 c0 10          	add    $0x10,%rax
    1c7a:	48 89 c7             	mov    %rax,%rdi
    1c7d:	48 b8 eb 1a 00 00 00 	movabs $0x1aeb,%rax
    1c84:	00 00 00 
    1c87:	ff d0                	call   *%rax
  return freep;
    1c89:	48 b8 40 1e 00 00 00 	movabs $0x1e40,%rax
    1c90:	00 00 00 
    1c93:	48 8b 00             	mov    (%rax),%rax
}
    1c96:	c9                   	leave
    1c97:	c3                   	ret

0000000000001c98 <malloc>:

void*
malloc(uint nbytes)
{
    1c98:	55                   	push   %rbp
    1c99:	48 89 e5             	mov    %rsp,%rbp
    1c9c:	48 83 ec 30          	sub    $0x30,%rsp
    1ca0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ca3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1ca6:	48 83 c0 0f          	add    $0xf,%rax
    1caa:	48 c1 e8 04          	shr    $0x4,%rax
    1cae:	83 c0 01             	add    $0x1,%eax
    1cb1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cb4:	48 b8 40 1e 00 00 00 	movabs $0x1e40,%rax
    1cbb:	00 00 00 
    1cbe:	48 8b 00             	mov    (%rax),%rax
    1cc1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cc5:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cca:	75 4a                	jne    1d16 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1ccc:	48 b8 30 1e 00 00 00 	movabs $0x1e30,%rax
    1cd3:	00 00 00 
    1cd6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cda:	48 ba 40 1e 00 00 00 	movabs $0x1e40,%rdx
    1ce1:	00 00 00 
    1ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce8:	48 89 02             	mov    %rax,(%rdx)
    1ceb:	48 b8 40 1e 00 00 00 	movabs $0x1e40,%rax
    1cf2:	00 00 00 
    1cf5:	48 8b 00             	mov    (%rax),%rax
    1cf8:	48 ba 30 1e 00 00 00 	movabs $0x1e30,%rdx
    1cff:	00 00 00 
    1d02:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d05:	48 b8 30 1e 00 00 00 	movabs $0x1e30,%rax
    1d0c:	00 00 00 
    1d0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1a:	48 8b 00             	mov    (%rax),%rax
    1d1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d25:	8b 40 08             	mov    0x8(%rax),%eax
    1d28:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d2b:	72 65                	jb     1d92 <malloc+0xfa>
      if(p->s.size == nunits)
    1d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d31:	8b 40 08             	mov    0x8(%rax),%eax
    1d34:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d37:	75 10                	jne    1d49 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d3d:	48 8b 10             	mov    (%rax),%rdx
    1d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d44:	48 89 10             	mov    %rdx,(%rax)
    1d47:	eb 2e                	jmp    1d77 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4d:	8b 40 08             	mov    0x8(%rax),%eax
    1d50:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d53:	89 c2                	mov    %eax,%edx
    1d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d59:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d60:	8b 40 08             	mov    0x8(%rax),%eax
    1d63:	89 c0                	mov    %eax,%eax
    1d65:	48 c1 e0 04          	shl    $0x4,%rax
    1d69:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d71:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d74:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d77:	48 ba 40 1e 00 00 00 	movabs $0x1e40,%rdx
    1d7e:	00 00 00 
    1d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d85:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8c:	48 83 c0 10          	add    $0x10,%rax
    1d90:	eb 4e                	jmp    1de0 <malloc+0x148>
    }
    if(p == freep)
    1d92:	48 b8 40 1e 00 00 00 	movabs $0x1e40,%rax
    1d99:	00 00 00 
    1d9c:	48 8b 00             	mov    (%rax),%rax
    1d9f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1da3:	75 23                	jne    1dc8 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1da5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1da8:	89 c7                	mov    %eax,%edi
    1daa:	48 b8 1d 1c 00 00 00 	movabs $0x1c1d,%rax
    1db1:	00 00 00 
    1db4:	ff d0                	call   *%rax
    1db6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dba:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1dbf:	75 07                	jne    1dc8 <malloc+0x130>
        return 0;
    1dc1:	b8 00 00 00 00       	mov    $0x0,%eax
    1dc6:	eb 18                	jmp    1de0 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dcc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd4:	48 8b 00             	mov    (%rax),%rax
    1dd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1ddb:	e9 41 ff ff ff       	jmp    1d21 <malloc+0x89>
  }
}
    1de0:	c9                   	leave
    1de1:	c3                   	ret
