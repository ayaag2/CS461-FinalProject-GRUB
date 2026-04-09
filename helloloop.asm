
_helloloop:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "types.h"
#include "user.h"

void hello(int);

int main(int argc, char** argv) {
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 10          	sub    $0x10,%rsp
    1008:	89 7d fc             	mov    %edi,-0x4(%rbp)
    100b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  signal(2,hello);
    100f:	48 b8 64 10 00 00 00 	movabs $0x1064,%rax
    1016:	00 00 00 
    1019:	48 89 c6             	mov    %rax,%rsi
    101c:	bf 02 00 00 00       	mov    $0x2,%edi
    1021:	48 b8 c1 14 00 00 00 	movabs $0x14c1,%rax
    1028:	00 00 00 
    102b:	ff d0                	call   *%rax
  while(1) {
    printf(1,"Hello, still looping!\n");
    102d:	48 b8 e0 1d 00 00 00 	movabs $0x1de0,%rax
    1034:	00 00 00 
    1037:	48 89 c6             	mov    %rax,%rsi
    103a:	bf 01 00 00 00       	mov    $0x1,%edi
    103f:	b8 00 00 00 00       	mov    $0x0,%eax
    1044:	48 ba be 16 00 00 00 	movabs $0x16be,%rdx
    104b:	00 00 00 
    104e:	ff d2                	call   *%rdx
    sleep(100);
    1050:	bf 64 00 00 00       	mov    $0x64,%edi
    1055:	48 b8 9a 14 00 00 00 	movabs $0x149a,%rax
    105c:	00 00 00 
    105f:	ff d0                	call   *%rax
    printf(1,"Hello, still looping!\n");
    1061:	90                   	nop
    1062:	eb c9                	jmp    102d <main+0x2d>

0000000000001064 <hello>:
  }
}

void hello(int signum) {
    1064:	55                   	push   %rbp
    1065:	48 89 e5             	mov    %rsp,%rbp
    1068:	48 83 ec 10          	sub    $0x10,%rsp
    106c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  printf(1,"Nuh-uh, I'm a non-preemptable hello loop!\n");
    106f:	48 b8 f8 1d 00 00 00 	movabs $0x1df8,%rax
    1076:	00 00 00 
    1079:	48 89 c6             	mov    %rax,%rsi
    107c:	bf 01 00 00 00       	mov    $0x1,%edi
    1081:	b8 00 00 00 00       	mov    $0x0,%eax
    1086:	48 ba be 16 00 00 00 	movabs $0x16be,%rdx
    108d:	00 00 00 
    1090:	ff d2                	call   *%rdx
}
    1092:	90                   	nop
    1093:	c9                   	leave
    1094:	c3                   	ret

0000000000001095 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1095:	55                   	push   %rbp
    1096:	48 89 e5             	mov    %rsp,%rbp
    1099:	48 83 ec 10          	sub    $0x10,%rsp
    109d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10a4:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10ab:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10b1:	48 89 ce             	mov    %rcx,%rsi
    10b4:	48 89 f7             	mov    %rsi,%rdi
    10b7:	89 d1                	mov    %edx,%ecx
    10b9:	fc                   	cld
    10ba:	f3 aa                	rep stos %al,(%rdi)
    10bc:	89 ca                	mov    %ecx,%edx
    10be:	48 89 fe             	mov    %rdi,%rsi
    10c1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10c5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10c8:	90                   	nop
    10c9:	c9                   	leave
    10ca:	c3                   	ret

00000000000010cb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10cb:	55                   	push   %rbp
    10cc:	48 89 e5             	mov    %rsp,%rbp
    10cf:	48 83 ec 20          	sub    $0x20,%rsp
    10d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10e3:	90                   	nop
    10e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10e8:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10f4:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10f8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10fc:	0f b6 12             	movzbl (%rdx),%edx
    10ff:	88 10                	mov    %dl,(%rax)
    1101:	0f b6 00             	movzbl (%rax),%eax
    1104:	84 c0                	test   %al,%al
    1106:	75 dc                	jne    10e4 <strcpy+0x19>
    ;
  return os;
    1108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    110c:	c9                   	leave
    110d:	c3                   	ret

000000000000110e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    110e:	55                   	push   %rbp
    110f:	48 89 e5             	mov    %rsp,%rbp
    1112:	48 83 ec 10          	sub    $0x10,%rsp
    1116:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    111a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    111e:	eb 0a                	jmp    112a <strcmp+0x1c>
    p++, q++;
    1120:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1125:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    112a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    112e:	0f b6 00             	movzbl (%rax),%eax
    1131:	84 c0                	test   %al,%al
    1133:	74 12                	je     1147 <strcmp+0x39>
    1135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1139:	0f b6 10             	movzbl (%rax),%edx
    113c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1140:	0f b6 00             	movzbl (%rax),%eax
    1143:	38 c2                	cmp    %al,%dl
    1145:	74 d9                	je     1120 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    114b:	0f b6 00             	movzbl (%rax),%eax
    114e:	0f b6 d0             	movzbl %al,%edx
    1151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1155:	0f b6 00             	movzbl (%rax),%eax
    1158:	0f b6 c0             	movzbl %al,%eax
    115b:	29 c2                	sub    %eax,%edx
    115d:	89 d0                	mov    %edx,%eax
}
    115f:	c9                   	leave
    1160:	c3                   	ret

0000000000001161 <strlen>:

uint
strlen(char *s)
{
    1161:	55                   	push   %rbp
    1162:	48 89 e5             	mov    %rsp,%rbp
    1165:	48 83 ec 18          	sub    $0x18,%rsp
    1169:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1174:	eb 04                	jmp    117a <strlen+0x19>
    1176:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    117a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    117d:	48 63 d0             	movslq %eax,%rdx
    1180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1184:	48 01 d0             	add    %rdx,%rax
    1187:	0f b6 00             	movzbl (%rax),%eax
    118a:	84 c0                	test   %al,%al
    118c:	75 e8                	jne    1176 <strlen+0x15>
    ;
  return n;
    118e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1191:	c9                   	leave
    1192:	c3                   	ret

0000000000001193 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1193:	55                   	push   %rbp
    1194:	48 89 e5             	mov    %rsp,%rbp
    1197:	48 83 ec 10          	sub    $0x10,%rsp
    119b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    119f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11a2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11a5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11a8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11af:	89 ce                	mov    %ecx,%esi
    11b1:	48 89 c7             	mov    %rax,%rdi
    11b4:	48 b8 95 10 00 00 00 	movabs $0x1095,%rax
    11bb:	00 00 00 
    11be:	ff d0                	call   *%rax
  return dst;
    11c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11c4:	c9                   	leave
    11c5:	c3                   	ret

00000000000011c6 <strchr>:

char*
strchr(const char *s, char c)
{
    11c6:	55                   	push   %rbp
    11c7:	48 89 e5             	mov    %rsp,%rbp
    11ca:	48 83 ec 10          	sub    $0x10,%rsp
    11ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11d2:	89 f0                	mov    %esi,%eax
    11d4:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11d7:	eb 17                	jmp    11f0 <strchr+0x2a>
    if(*s == c)
    11d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11dd:	0f b6 00             	movzbl (%rax),%eax
    11e0:	38 45 f4             	cmp    %al,-0xc(%rbp)
    11e3:	75 06                	jne    11eb <strchr+0x25>
      return (char*)s;
    11e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11e9:	eb 15                	jmp    1200 <strchr+0x3a>
  for(; *s; s++)
    11eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11f4:	0f b6 00             	movzbl (%rax),%eax
    11f7:	84 c0                	test   %al,%al
    11f9:	75 de                	jne    11d9 <strchr+0x13>
  return 0;
    11fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1200:	c9                   	leave
    1201:	c3                   	ret

0000000000001202 <gets>:

char*
gets(char *buf, int max)
{
    1202:	55                   	push   %rbp
    1203:	48 89 e5             	mov    %rsp,%rbp
    1206:	48 83 ec 20          	sub    $0x20,%rsp
    120a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    120e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1218:	eb 4f                	jmp    1269 <gets+0x67>
    cc = read(0, &c, 1);
    121a:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    121e:	ba 01 00 00 00       	mov    $0x1,%edx
    1223:	48 89 c6             	mov    %rax,%rsi
    1226:	bf 00 00 00 00       	mov    $0x0,%edi
    122b:	48 b8 d7 13 00 00 00 	movabs $0x13d7,%rax
    1232:	00 00 00 
    1235:	ff d0                	call   *%rax
    1237:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    123a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    123e:	7e 36                	jle    1276 <gets+0x74>
      break;
    buf[i++] = c;
    1240:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1243:	8d 50 01             	lea    0x1(%rax),%edx
    1246:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1249:	48 63 d0             	movslq %eax,%rdx
    124c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1250:	48 01 c2             	add    %rax,%rdx
    1253:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1257:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1259:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    125d:	3c 0a                	cmp    $0xa,%al
    125f:	74 16                	je     1277 <gets+0x75>
    1261:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1265:	3c 0d                	cmp    $0xd,%al
    1267:	74 0e                	je     1277 <gets+0x75>
  for(i=0; i+1 < max; ){
    1269:	8b 45 fc             	mov    -0x4(%rbp),%eax
    126c:	83 c0 01             	add    $0x1,%eax
    126f:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1272:	7f a6                	jg     121a <gets+0x18>
    1274:	eb 01                	jmp    1277 <gets+0x75>
      break;
    1276:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1277:	8b 45 fc             	mov    -0x4(%rbp),%eax
    127a:	48 63 d0             	movslq %eax,%rdx
    127d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1281:	48 01 d0             	add    %rdx,%rax
    1284:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    128b:	c9                   	leave
    128c:	c3                   	ret

000000000000128d <stat>:

int
stat(char *n, struct stat *st)
{
    128d:	55                   	push   %rbp
    128e:	48 89 e5             	mov    %rsp,%rbp
    1291:	48 83 ec 20          	sub    $0x20,%rsp
    1295:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1299:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    129d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a1:	be 00 00 00 00       	mov    $0x0,%esi
    12a6:	48 89 c7             	mov    %rax,%rdi
    12a9:	48 b8 18 14 00 00 00 	movabs $0x1418,%rax
    12b0:	00 00 00 
    12b3:	ff d0                	call   *%rax
    12b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12bc:	79 07                	jns    12c5 <stat+0x38>
    return -1;
    12be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12c3:	eb 2f                	jmp    12f4 <stat+0x67>
  r = fstat(fd, st);
    12c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12cc:	48 89 d6             	mov    %rdx,%rsi
    12cf:	89 c7                	mov    %eax,%edi
    12d1:	48 b8 3f 14 00 00 00 	movabs $0x143f,%rax
    12d8:	00 00 00 
    12db:	ff d0                	call   *%rax
    12dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12e3:	89 c7                	mov    %eax,%edi
    12e5:	48 b8 f1 13 00 00 00 	movabs $0x13f1,%rax
    12ec:	00 00 00 
    12ef:	ff d0                	call   *%rax
  return r;
    12f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12f4:	c9                   	leave
    12f5:	c3                   	ret

00000000000012f6 <atoi>:

int
atoi(const char *s)
{
    12f6:	55                   	push   %rbp
    12f7:	48 89 e5             	mov    %rsp,%rbp
    12fa:	48 83 ec 18          	sub    $0x18,%rsp
    12fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1302:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1309:	eb 28                	jmp    1333 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    130b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    130e:	89 d0                	mov    %edx,%eax
    1310:	c1 e0 02             	shl    $0x2,%eax
    1313:	01 d0                	add    %edx,%eax
    1315:	01 c0                	add    %eax,%eax
    1317:	89 c1                	mov    %eax,%ecx
    1319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    131d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1321:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1325:	0f b6 00             	movzbl (%rax),%eax
    1328:	0f be c0             	movsbl %al,%eax
    132b:	01 c8                	add    %ecx,%eax
    132d:	83 e8 30             	sub    $0x30,%eax
    1330:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1333:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1337:	0f b6 00             	movzbl (%rax),%eax
    133a:	3c 2f                	cmp    $0x2f,%al
    133c:	7e 0b                	jle    1349 <atoi+0x53>
    133e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1342:	0f b6 00             	movzbl (%rax),%eax
    1345:	3c 39                	cmp    $0x39,%al
    1347:	7e c2                	jle    130b <atoi+0x15>
  return n;
    1349:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    134c:	c9                   	leave
    134d:	c3                   	ret

000000000000134e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    134e:	55                   	push   %rbp
    134f:	48 89 e5             	mov    %rsp,%rbp
    1352:	48 83 ec 28          	sub    $0x28,%rsp
    1356:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    135a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    135e:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1365:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1369:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    136d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1371:	eb 1d                	jmp    1390 <memmove+0x42>
    *dst++ = *src++;
    1373:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1377:	48 8d 42 01          	lea    0x1(%rdx),%rax
    137b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    137f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1383:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1387:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    138b:	0f b6 12             	movzbl (%rdx),%edx
    138e:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1390:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1393:	8d 50 ff             	lea    -0x1(%rax),%edx
    1396:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1399:	85 c0                	test   %eax,%eax
    139b:	7f d6                	jg     1373 <memmove+0x25>
  return vdst;
    139d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13a1:	c9                   	leave
    13a2:	c3                   	ret

00000000000013a3 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13a3:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13aa:	49 89 ca             	mov    %rcx,%r10
    13ad:	0f 05                	syscall
    13af:	c3                   	ret

00000000000013b0 <exit>:
SYSCALL(exit)
    13b0:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13b7:	49 89 ca             	mov    %rcx,%r10
    13ba:	0f 05                	syscall
    13bc:	c3                   	ret

00000000000013bd <wait>:
SYSCALL(wait)
    13bd:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13c4:	49 89 ca             	mov    %rcx,%r10
    13c7:	0f 05                	syscall
    13c9:	c3                   	ret

00000000000013ca <pipe>:
SYSCALL(pipe)
    13ca:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13d1:	49 89 ca             	mov    %rcx,%r10
    13d4:	0f 05                	syscall
    13d6:	c3                   	ret

00000000000013d7 <read>:
SYSCALL(read)
    13d7:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13de:	49 89 ca             	mov    %rcx,%r10
    13e1:	0f 05                	syscall
    13e3:	c3                   	ret

00000000000013e4 <write>:
SYSCALL(write)
    13e4:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13eb:	49 89 ca             	mov    %rcx,%r10
    13ee:	0f 05                	syscall
    13f0:	c3                   	ret

00000000000013f1 <close>:
SYSCALL(close)
    13f1:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13f8:	49 89 ca             	mov    %rcx,%r10
    13fb:	0f 05                	syscall
    13fd:	c3                   	ret

00000000000013fe <kill>:
SYSCALL(kill)
    13fe:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1405:	49 89 ca             	mov    %rcx,%r10
    1408:	0f 05                	syscall
    140a:	c3                   	ret

000000000000140b <exec>:
SYSCALL(exec)
    140b:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1412:	49 89 ca             	mov    %rcx,%r10
    1415:	0f 05                	syscall
    1417:	c3                   	ret

0000000000001418 <open>:
SYSCALL(open)
    1418:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    141f:	49 89 ca             	mov    %rcx,%r10
    1422:	0f 05                	syscall
    1424:	c3                   	ret

0000000000001425 <mknod>:
SYSCALL(mknod)
    1425:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    142c:	49 89 ca             	mov    %rcx,%r10
    142f:	0f 05                	syscall
    1431:	c3                   	ret

0000000000001432 <unlink>:
SYSCALL(unlink)
    1432:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1439:	49 89 ca             	mov    %rcx,%r10
    143c:	0f 05                	syscall
    143e:	c3                   	ret

000000000000143f <fstat>:
SYSCALL(fstat)
    143f:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1446:	49 89 ca             	mov    %rcx,%r10
    1449:	0f 05                	syscall
    144b:	c3                   	ret

000000000000144c <link>:
SYSCALL(link)
    144c:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1453:	49 89 ca             	mov    %rcx,%r10
    1456:	0f 05                	syscall
    1458:	c3                   	ret

0000000000001459 <mkdir>:
SYSCALL(mkdir)
    1459:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1460:	49 89 ca             	mov    %rcx,%r10
    1463:	0f 05                	syscall
    1465:	c3                   	ret

0000000000001466 <chdir>:
SYSCALL(chdir)
    1466:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    146d:	49 89 ca             	mov    %rcx,%r10
    1470:	0f 05                	syscall
    1472:	c3                   	ret

0000000000001473 <dup>:
SYSCALL(dup)
    1473:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    147a:	49 89 ca             	mov    %rcx,%r10
    147d:	0f 05                	syscall
    147f:	c3                   	ret

0000000000001480 <getpid>:
SYSCALL(getpid)
    1480:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1487:	49 89 ca             	mov    %rcx,%r10
    148a:	0f 05                	syscall
    148c:	c3                   	ret

000000000000148d <sbrk>:
SYSCALL(sbrk)
    148d:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1494:	49 89 ca             	mov    %rcx,%r10
    1497:	0f 05                	syscall
    1499:	c3                   	ret

000000000000149a <sleep>:
SYSCALL(sleep)
    149a:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14a1:	49 89 ca             	mov    %rcx,%r10
    14a4:	0f 05                	syscall
    14a6:	c3                   	ret

00000000000014a7 <uptime>:
SYSCALL(uptime)
    14a7:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14ae:	49 89 ca             	mov    %rcx,%r10
    14b1:	0f 05                	syscall
    14b3:	c3                   	ret

00000000000014b4 <alarm>:

SYSCALL(alarm)
    14b4:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14bb:	49 89 ca             	mov    %rcx,%r10
    14be:	0f 05                	syscall
    14c0:	c3                   	ret

00000000000014c1 <signal>:
SYSCALL(signal)
    14c1:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    14c8:	49 89 ca             	mov    %rcx,%r10
    14cb:	0f 05                	syscall
    14cd:	c3                   	ret

00000000000014ce <sigret>:
SYSCALL(sigret)
    14ce:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    14d5:	49 89 ca             	mov    %rcx,%r10
    14d8:	0f 05                	syscall
    14da:	c3                   	ret

00000000000014db <fgproc>:
SYSCALL(fgproc)
    14db:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    14e2:	49 89 ca             	mov    %rcx,%r10
    14e5:	0f 05                	syscall
    14e7:	c3                   	ret

00000000000014e8 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14e8:	55                   	push   %rbp
    14e9:	48 89 e5             	mov    %rsp,%rbp
    14ec:	48 83 ec 10          	sub    $0x10,%rsp
    14f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14f3:	89 f0                	mov    %esi,%eax
    14f5:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    14f8:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14ff:	ba 01 00 00 00       	mov    $0x1,%edx
    1504:	48 89 ce             	mov    %rcx,%rsi
    1507:	89 c7                	mov    %eax,%edi
    1509:	48 b8 e4 13 00 00 00 	movabs $0x13e4,%rax
    1510:	00 00 00 
    1513:	ff d0                	call   *%rax
}
    1515:	90                   	nop
    1516:	c9                   	leave
    1517:	c3                   	ret

0000000000001518 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1518:	55                   	push   %rbp
    1519:	48 89 e5             	mov    %rsp,%rbp
    151c:	48 83 ec 20          	sub    $0x20,%rsp
    1520:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1523:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1527:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    152e:	eb 35                	jmp    1565 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1530:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1534:	48 c1 e8 3c          	shr    $0x3c,%rax
    1538:	48 ba 30 1e 00 00 00 	movabs $0x1e30,%rdx
    153f:	00 00 00 
    1542:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1546:	0f be d0             	movsbl %al,%edx
    1549:	8b 45 ec             	mov    -0x14(%rbp),%eax
    154c:	89 d6                	mov    %edx,%esi
    154e:	89 c7                	mov    %eax,%edi
    1550:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1557:	00 00 00 
    155a:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    155c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1560:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1565:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1568:	83 f8 0f             	cmp    $0xf,%eax
    156b:	76 c3                	jbe    1530 <print_x64+0x18>
}
    156d:	90                   	nop
    156e:	90                   	nop
    156f:	c9                   	leave
    1570:	c3                   	ret

0000000000001571 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1571:	55                   	push   %rbp
    1572:	48 89 e5             	mov    %rsp,%rbp
    1575:	48 83 ec 20          	sub    $0x20,%rsp
    1579:	89 7d ec             	mov    %edi,-0x14(%rbp)
    157c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    157f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1586:	eb 36                	jmp    15be <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1588:	8b 45 e8             	mov    -0x18(%rbp),%eax
    158b:	c1 e8 1c             	shr    $0x1c,%eax
    158e:	89 c2                	mov    %eax,%edx
    1590:	48 b8 30 1e 00 00 00 	movabs $0x1e30,%rax
    1597:	00 00 00 
    159a:	89 d2                	mov    %edx,%edx
    159c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15a0:	0f be d0             	movsbl %al,%edx
    15a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15a6:	89 d6                	mov    %edx,%esi
    15a8:	89 c7                	mov    %eax,%edi
    15aa:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    15b1:	00 00 00 
    15b4:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15ba:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15be:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15c1:	83 f8 07             	cmp    $0x7,%eax
    15c4:	76 c2                	jbe    1588 <print_x32+0x17>
}
    15c6:	90                   	nop
    15c7:	90                   	nop
    15c8:	c9                   	leave
    15c9:	c3                   	ret

00000000000015ca <print_d>:

  static void
print_d(int fd, int v)
{
    15ca:	55                   	push   %rbp
    15cb:	48 89 e5             	mov    %rsp,%rbp
    15ce:	48 83 ec 30          	sub    $0x30,%rsp
    15d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15d5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15d8:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15db:	48 98                	cltq
    15dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15e5:	79 04                	jns    15eb <print_d+0x21>
    x = -x;
    15e7:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    15eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15f2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15f6:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15fd:	66 66 66 
    1600:	48 89 c8             	mov    %rcx,%rax
    1603:	48 f7 ea             	imul   %rdx
    1606:	48 c1 fa 02          	sar    $0x2,%rdx
    160a:	48 89 c8             	mov    %rcx,%rax
    160d:	48 c1 f8 3f          	sar    $0x3f,%rax
    1611:	48 29 c2             	sub    %rax,%rdx
    1614:	48 89 d0             	mov    %rdx,%rax
    1617:	48 c1 e0 02          	shl    $0x2,%rax
    161b:	48 01 d0             	add    %rdx,%rax
    161e:	48 01 c0             	add    %rax,%rax
    1621:	48 29 c1             	sub    %rax,%rcx
    1624:	48 89 ca             	mov    %rcx,%rdx
    1627:	8b 45 f4             	mov    -0xc(%rbp),%eax
    162a:	8d 48 01             	lea    0x1(%rax),%ecx
    162d:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1630:	48 b9 30 1e 00 00 00 	movabs $0x1e30,%rcx
    1637:	00 00 00 
    163a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    163e:	48 98                	cltq
    1640:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1644:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1648:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    164f:	66 66 66 
    1652:	48 89 c8             	mov    %rcx,%rax
    1655:	48 f7 ea             	imul   %rdx
    1658:	48 89 d0             	mov    %rdx,%rax
    165b:	48 c1 f8 02          	sar    $0x2,%rax
    165f:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1663:	48 89 ca             	mov    %rcx,%rdx
    1666:	48 29 d0             	sub    %rdx,%rax
    1669:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    166d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1672:	0f 85 7a ff ff ff    	jne    15f2 <print_d+0x28>

  if (v < 0)
    1678:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    167c:	79 32                	jns    16b0 <print_d+0xe6>
    buf[i++] = '-';
    167e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1681:	8d 50 01             	lea    0x1(%rax),%edx
    1684:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1687:	48 98                	cltq
    1689:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    168e:	eb 20                	jmp    16b0 <print_d+0xe6>
    putc(fd, buf[i]);
    1690:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1693:	48 98                	cltq
    1695:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    169a:	0f be d0             	movsbl %al,%edx
    169d:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16a0:	89 d6                	mov    %edx,%esi
    16a2:	89 c7                	mov    %eax,%edi
    16a4:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    16ab:	00 00 00 
    16ae:	ff d0                	call   *%rax
  while (--i >= 0)
    16b0:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16b8:	79 d6                	jns    1690 <print_d+0xc6>
}
    16ba:	90                   	nop
    16bb:	90                   	nop
    16bc:	c9                   	leave
    16bd:	c3                   	ret

00000000000016be <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16be:	55                   	push   %rbp
    16bf:	48 89 e5             	mov    %rsp,%rbp
    16c2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16c9:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16cf:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16d6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16f2:	84 c0                	test   %al,%al
    16f4:	74 20                	je     1716 <printf+0x58>
    16f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    16fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1702:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1706:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    170a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    170e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1712:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1716:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    171d:	00 00 00 
    1720:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1727:	00 00 00 
    172a:	48 8d 45 10          	lea    0x10(%rbp),%rax
    172e:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1735:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    173c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1743:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    174a:	00 00 00 
    174d:	e9 60 03 00 00       	jmp    1ab2 <printf+0x3f4>
    if (c != '%') {
    1752:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1759:	74 24                	je     177f <printf+0xc1>
      putc(fd, c);
    175b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1761:	0f be d0             	movsbl %al,%edx
    1764:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    176a:	89 d6                	mov    %edx,%esi
    176c:	89 c7                	mov    %eax,%edi
    176e:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1775:	00 00 00 
    1778:	ff d0                	call   *%rax
      continue;
    177a:	e9 2c 03 00 00       	jmp    1aab <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    177f:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1786:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    178c:	48 63 d0             	movslq %eax,%rdx
    178f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1796:	48 01 d0             	add    %rdx,%rax
    1799:	0f b6 00             	movzbl (%rax),%eax
    179c:	0f be c0             	movsbl %al,%eax
    179f:	25 ff 00 00 00       	and    $0xff,%eax
    17a4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17aa:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17b1:	0f 84 2e 03 00 00    	je     1ae5 <printf+0x427>
      break;
    switch(c) {
    17b7:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17be:	0f 84 32 01 00 00    	je     18f6 <printf+0x238>
    17c4:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17cb:	0f 8f a1 02 00 00    	jg     1a72 <printf+0x3b4>
    17d1:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17d8:	0f 84 d4 01 00 00    	je     19b2 <printf+0x2f4>
    17de:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    17e5:	0f 8f 87 02 00 00    	jg     1a72 <printf+0x3b4>
    17eb:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17f2:	0f 84 5b 01 00 00    	je     1953 <printf+0x295>
    17f8:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    17ff:	0f 8f 6d 02 00 00    	jg     1a72 <printf+0x3b4>
    1805:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    180c:	0f 84 87 00 00 00    	je     1899 <printf+0x1db>
    1812:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1819:	0f 8f 53 02 00 00    	jg     1a72 <printf+0x3b4>
    181f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1826:	0f 84 2b 02 00 00    	je     1a57 <printf+0x399>
    182c:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1833:	0f 85 39 02 00 00    	jne    1a72 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1839:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    183f:	83 f8 2f             	cmp    $0x2f,%eax
    1842:	77 23                	ja     1867 <printf+0x1a9>
    1844:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    184b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1851:	89 d2                	mov    %edx,%edx
    1853:	48 01 d0             	add    %rdx,%rax
    1856:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    185c:	83 c2 08             	add    $0x8,%edx
    185f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1865:	eb 12                	jmp    1879 <printf+0x1bb>
    1867:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    186e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1872:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1879:	8b 00                	mov    (%rax),%eax
    187b:	0f be d0             	movsbl %al,%edx
    187e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1884:	89 d6                	mov    %edx,%esi
    1886:	89 c7                	mov    %eax,%edi
    1888:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    188f:	00 00 00 
    1892:	ff d0                	call   *%rax
      break;
    1894:	e9 12 02 00 00       	jmp    1aab <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1899:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    189f:	83 f8 2f             	cmp    $0x2f,%eax
    18a2:	77 23                	ja     18c7 <printf+0x209>
    18a4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18ab:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18b1:	89 d2                	mov    %edx,%edx
    18b3:	48 01 d0             	add    %rdx,%rax
    18b6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18bc:	83 c2 08             	add    $0x8,%edx
    18bf:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18c5:	eb 12                	jmp    18d9 <printf+0x21b>
    18c7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18ce:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18d2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18d9:	8b 10                	mov    (%rax),%edx
    18db:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18e1:	89 d6                	mov    %edx,%esi
    18e3:	89 c7                	mov    %eax,%edi
    18e5:	48 b8 ca 15 00 00 00 	movabs $0x15ca,%rax
    18ec:	00 00 00 
    18ef:	ff d0                	call   *%rax
      break;
    18f1:	e9 b5 01 00 00       	jmp    1aab <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18f6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18fc:	83 f8 2f             	cmp    $0x2f,%eax
    18ff:	77 23                	ja     1924 <printf+0x266>
    1901:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1908:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    190e:	89 d2                	mov    %edx,%edx
    1910:	48 01 d0             	add    %rdx,%rax
    1913:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1919:	83 c2 08             	add    $0x8,%edx
    191c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1922:	eb 12                	jmp    1936 <printf+0x278>
    1924:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    192b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    192f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1936:	8b 10                	mov    (%rax),%edx
    1938:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    193e:	89 d6                	mov    %edx,%esi
    1940:	89 c7                	mov    %eax,%edi
    1942:	48 b8 71 15 00 00 00 	movabs $0x1571,%rax
    1949:	00 00 00 
    194c:	ff d0                	call   *%rax
      break;
    194e:	e9 58 01 00 00       	jmp    1aab <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1953:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1959:	83 f8 2f             	cmp    $0x2f,%eax
    195c:	77 23                	ja     1981 <printf+0x2c3>
    195e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1965:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196b:	89 d2                	mov    %edx,%edx
    196d:	48 01 d0             	add    %rdx,%rax
    1970:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1976:	83 c2 08             	add    $0x8,%edx
    1979:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    197f:	eb 12                	jmp    1993 <printf+0x2d5>
    1981:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1988:	48 8d 50 08          	lea    0x8(%rax),%rdx
    198c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1993:	48 8b 10             	mov    (%rax),%rdx
    1996:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    199c:	48 89 d6             	mov    %rdx,%rsi
    199f:	89 c7                	mov    %eax,%edi
    19a1:	48 b8 18 15 00 00 00 	movabs $0x1518,%rax
    19a8:	00 00 00 
    19ab:	ff d0                	call   *%rax
      break;
    19ad:	e9 f9 00 00 00       	jmp    1aab <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19b2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b8:	83 f8 2f             	cmp    $0x2f,%eax
    19bb:	77 23                	ja     19e0 <printf+0x322>
    19bd:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19c4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19ca:	89 d2                	mov    %edx,%edx
    19cc:	48 01 d0             	add    %rdx,%rax
    19cf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d5:	83 c2 08             	add    $0x8,%edx
    19d8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19de:	eb 12                	jmp    19f2 <printf+0x334>
    19e0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19e7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19eb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19f2:	48 8b 00             	mov    (%rax),%rax
    19f5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19fc:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a03:	00 
    1a04:	75 41                	jne    1a47 <printf+0x389>
        s = "(null)";
    1a06:	48 b8 23 1e 00 00 00 	movabs $0x1e23,%rax
    1a0d:	00 00 00 
    1a10:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a17:	eb 2e                	jmp    1a47 <printf+0x389>
        putc(fd, *(s++));
    1a19:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a20:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a24:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a2b:	0f b6 00             	movzbl (%rax),%eax
    1a2e:	0f be d0             	movsbl %al,%edx
    1a31:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a37:	89 d6                	mov    %edx,%esi
    1a39:	89 c7                	mov    %eax,%edi
    1a3b:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1a42:	00 00 00 
    1a45:	ff d0                	call   *%rax
      while (*s)
    1a47:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a4e:	0f b6 00             	movzbl (%rax),%eax
    1a51:	84 c0                	test   %al,%al
    1a53:	75 c4                	jne    1a19 <printf+0x35b>
      break;
    1a55:	eb 54                	jmp    1aab <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1a57:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5d:	be 25 00 00 00       	mov    $0x25,%esi
    1a62:	89 c7                	mov    %eax,%edi
    1a64:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1a6b:	00 00 00 
    1a6e:	ff d0                	call   *%rax
      break;
    1a70:	eb 39                	jmp    1aab <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a72:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a78:	be 25 00 00 00       	mov    $0x25,%esi
    1a7d:	89 c7                	mov    %eax,%edi
    1a7f:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1a86:	00 00 00 
    1a89:	ff d0                	call   *%rax
      putc(fd, c);
    1a8b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a91:	0f be d0             	movsbl %al,%edx
    1a94:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a9a:	89 d6                	mov    %edx,%esi
    1a9c:	89 c7                	mov    %eax,%edi
    1a9e:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1aa5:	00 00 00 
    1aa8:	ff d0                	call   *%rax
      break;
    1aaa:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1aab:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ab2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ab8:	48 63 d0             	movslq %eax,%rdx
    1abb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ac2:	48 01 d0             	add    %rdx,%rax
    1ac5:	0f b6 00             	movzbl (%rax),%eax
    1ac8:	0f be c0             	movsbl %al,%eax
    1acb:	25 ff 00 00 00       	and    $0xff,%eax
    1ad0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ad6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1add:	0f 85 6f fc ff ff    	jne    1752 <printf+0x94>
    }
  }
}
    1ae3:	eb 01                	jmp    1ae6 <printf+0x428>
      break;
    1ae5:	90                   	nop
}
    1ae6:	90                   	nop
    1ae7:	c9                   	leave
    1ae8:	c3                   	ret

0000000000001ae9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ae9:	55                   	push   %rbp
    1aea:	48 89 e5             	mov    %rsp,%rbp
    1aed:	48 83 ec 18          	sub    $0x18,%rsp
    1af1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1af5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1af9:	48 83 e8 10          	sub    $0x10,%rax
    1afd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b01:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1b08:	00 00 00 
    1b0b:	48 8b 00             	mov    (%rax),%rax
    1b0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b12:	eb 2f                	jmp    1b43 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b18:	48 8b 00             	mov    (%rax),%rax
    1b1b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b1f:	72 17                	jb     1b38 <free+0x4f>
    1b21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b25:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b29:	72 2f                	jb     1b5a <free+0x71>
    1b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b2f:	48 8b 00             	mov    (%rax),%rax
    1b32:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b36:	72 22                	jb     1b5a <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3c:	48 8b 00             	mov    (%rax),%rax
    1b3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b47:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b4b:	73 c7                	jae    1b14 <free+0x2b>
    1b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b51:	48 8b 00             	mov    (%rax),%rax
    1b54:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b58:	73 ba                	jae    1b14 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b5e:	8b 40 08             	mov    0x8(%rax),%eax
    1b61:	89 c0                	mov    %eax,%eax
    1b63:	48 c1 e0 04          	shl    $0x4,%rax
    1b67:	48 89 c2             	mov    %rax,%rdx
    1b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b6e:	48 01 c2             	add    %rax,%rdx
    1b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b75:	48 8b 00             	mov    (%rax),%rax
    1b78:	48 39 c2             	cmp    %rax,%rdx
    1b7b:	75 2d                	jne    1baa <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1b7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b81:	8b 50 08             	mov    0x8(%rax),%edx
    1b84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b88:	48 8b 00             	mov    (%rax),%rax
    1b8b:	8b 40 08             	mov    0x8(%rax),%eax
    1b8e:	01 c2                	add    %eax,%edx
    1b90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b94:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9b:	48 8b 00             	mov    (%rax),%rax
    1b9e:	48 8b 10             	mov    (%rax),%rdx
    1ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba5:	48 89 10             	mov    %rdx,(%rax)
    1ba8:	eb 0e                	jmp    1bb8 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1baa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bae:	48 8b 10             	mov    (%rax),%rdx
    1bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb5:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbc:	8b 40 08             	mov    0x8(%rax),%eax
    1bbf:	89 c0                	mov    %eax,%eax
    1bc1:	48 c1 e0 04          	shl    $0x4,%rax
    1bc5:	48 89 c2             	mov    %rax,%rdx
    1bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcc:	48 01 d0             	add    %rdx,%rax
    1bcf:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bd3:	75 27                	jne    1bfc <free+0x113>
    p->s.size += bp->s.size;
    1bd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd9:	8b 50 08             	mov    0x8(%rax),%edx
    1bdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be0:	8b 40 08             	mov    0x8(%rax),%eax
    1be3:	01 c2                	add    %eax,%edx
    1be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be9:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf0:	48 8b 10             	mov    (%rax),%rdx
    1bf3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf7:	48 89 10             	mov    %rdx,(%rax)
    1bfa:	eb 0b                	jmp    1c07 <free+0x11e>
  } else
    p->s.ptr = bp;
    1bfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c04:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c07:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1c0e:	00 00 00 
    1c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c15:	48 89 02             	mov    %rax,(%rdx)
}
    1c18:	90                   	nop
    1c19:	c9                   	leave
    1c1a:	c3                   	ret

0000000000001c1b <morecore>:

static Header*
morecore(uint nu)
{
    1c1b:	55                   	push   %rbp
    1c1c:	48 89 e5             	mov    %rsp,%rbp
    1c1f:	48 83 ec 20          	sub    $0x20,%rsp
    1c23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c26:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c2d:	77 07                	ja     1c36 <morecore+0x1b>
    nu = 4096;
    1c2f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c36:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c39:	48 c1 e0 04          	shl    $0x4,%rax
    1c3d:	48 89 c7             	mov    %rax,%rdi
    1c40:	48 b8 8d 14 00 00 00 	movabs $0x148d,%rax
    1c47:	00 00 00 
    1c4a:	ff d0                	call   *%rax
    1c4c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c50:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c55:	75 07                	jne    1c5e <morecore+0x43>
    return 0;
    1c57:	b8 00 00 00 00       	mov    $0x0,%eax
    1c5c:	eb 36                	jmp    1c94 <morecore+0x79>
  hp = (Header*)p;
    1c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c6d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c74:	48 83 c0 10          	add    $0x10,%rax
    1c78:	48 89 c7             	mov    %rax,%rdi
    1c7b:	48 b8 e9 1a 00 00 00 	movabs $0x1ae9,%rax
    1c82:	00 00 00 
    1c85:	ff d0                	call   *%rax
  return freep;
    1c87:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1c8e:	00 00 00 
    1c91:	48 8b 00             	mov    (%rax),%rax
}
    1c94:	c9                   	leave
    1c95:	c3                   	ret

0000000000001c96 <malloc>:

void*
malloc(uint nbytes)
{
    1c96:	55                   	push   %rbp
    1c97:	48 89 e5             	mov    %rsp,%rbp
    1c9a:	48 83 ec 30          	sub    $0x30,%rsp
    1c9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ca1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1ca4:	48 83 c0 0f          	add    $0xf,%rax
    1ca8:	48 c1 e8 04          	shr    $0x4,%rax
    1cac:	83 c0 01             	add    $0x1,%eax
    1caf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cb2:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1cb9:	00 00 00 
    1cbc:	48 8b 00             	mov    (%rax),%rax
    1cbf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cc3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1cc8:	75 4a                	jne    1d14 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1cca:	48 b8 50 1e 00 00 00 	movabs $0x1e50,%rax
    1cd1:	00 00 00 
    1cd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cd8:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1cdf:	00 00 00 
    1ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce6:	48 89 02             	mov    %rax,(%rdx)
    1ce9:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1cf0:	00 00 00 
    1cf3:	48 8b 00             	mov    (%rax),%rax
    1cf6:	48 ba 50 1e 00 00 00 	movabs $0x1e50,%rdx
    1cfd:	00 00 00 
    1d00:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d03:	48 b8 50 1e 00 00 00 	movabs $0x1e50,%rax
    1d0a:	00 00 00 
    1d0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d18:	48 8b 00             	mov    (%rax),%rax
    1d1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d23:	8b 40 08             	mov    0x8(%rax),%eax
    1d26:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d29:	72 65                	jb     1d90 <malloc+0xfa>
      if(p->s.size == nunits)
    1d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2f:	8b 40 08             	mov    0x8(%rax),%eax
    1d32:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d35:	75 10                	jne    1d47 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d3b:	48 8b 10             	mov    (%rax),%rdx
    1d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d42:	48 89 10             	mov    %rdx,(%rax)
    1d45:	eb 2e                	jmp    1d75 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d4b:	8b 40 08             	mov    0x8(%rax),%eax
    1d4e:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d51:	89 c2                	mov    %eax,%edx
    1d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d57:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5e:	8b 40 08             	mov    0x8(%rax),%eax
    1d61:	89 c0                	mov    %eax,%eax
    1d63:	48 c1 e0 04          	shl    $0x4,%rax
    1d67:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d72:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d75:	48 ba 60 1e 00 00 00 	movabs $0x1e60,%rdx
    1d7c:	00 00 00 
    1d7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d83:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8a:	48 83 c0 10          	add    $0x10,%rax
    1d8e:	eb 4e                	jmp    1dde <malloc+0x148>
    }
    if(p == freep)
    1d90:	48 b8 60 1e 00 00 00 	movabs $0x1e60,%rax
    1d97:	00 00 00 
    1d9a:	48 8b 00             	mov    (%rax),%rax
    1d9d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1da1:	75 23                	jne    1dc6 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1da3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1da6:	89 c7                	mov    %eax,%edi
    1da8:	48 b8 1b 1c 00 00 00 	movabs $0x1c1b,%rax
    1daf:	00 00 00 
    1db2:	ff d0                	call   *%rax
    1db4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1db8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1dbd:	75 07                	jne    1dc6 <malloc+0x130>
        return 0;
    1dbf:	b8 00 00 00 00       	mov    $0x0,%eax
    1dc4:	eb 18                	jmp    1dde <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd2:	48 8b 00             	mov    (%rax),%rax
    1dd5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1dd9:	e9 41 ff ff ff       	jmp    1d1f <malloc+0x89>
  }
}
    1dde:	c9                   	leave
    1ddf:	c3                   	ret
