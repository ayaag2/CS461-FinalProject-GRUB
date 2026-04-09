
_alarmtest2:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char** argv) {
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 20          	sub    $0x20,%rsp
    1008:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

  signal(14,(void(*)(int))1); // ignore alarm signal this time
    100f:	be 01 00 00 00       	mov    $0x1,%esi
    1014:	bf 0e 00 00 00       	mov    $0xe,%edi
    1019:	48 b8 0f 15 00 00 00 	movabs $0x150f,%rax
    1020:	00 00 00 
    1023:	ff d0                	call   *%rax
  alarm(2);
    1025:	bf 02 00 00 00       	mov    $0x2,%edi
    102a:	48 b8 02 15 00 00 00 	movabs $0x1502,%rax
    1031:	00 00 00 
    1034:	ff d0                	call   *%rax
  int i=5;
    1036:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  while(i--) {
    103d:	eb 39                	jmp    1078 <main+0x78>
    printf(1,"Still looping... %d\n",i);
    103f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1042:	48 b9 30 1e 00 00 00 	movabs $0x1e30,%rcx
    1049:	00 00 00 
    104c:	89 c2                	mov    %eax,%edx
    104e:	48 89 ce             	mov    %rcx,%rsi
    1051:	bf 01 00 00 00       	mov    $0x1,%edi
    1056:	b8 00 00 00 00       	mov    $0x0,%eax
    105b:	48 b9 0c 17 00 00 00 	movabs $0x170c,%rcx
    1062:	00 00 00 
    1065:	ff d1                	call   *%rcx
    sleep(100);
    1067:	bf 64 00 00 00       	mov    $0x64,%edi
    106c:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    1073:	00 00 00 
    1076:	ff d0                	call   *%rax
  while(i--) {
    1078:	8b 45 fc             	mov    -0x4(%rbp),%eax
    107b:	8d 50 ff             	lea    -0x1(%rax),%edx
    107e:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1081:	85 c0                	test   %eax,%eax
    1083:	75 ba                	jne    103f <main+0x3f>
  }

  signal(14,0); // stop ignoring alarms
    1085:	be 00 00 00 00       	mov    $0x0,%esi
    108a:	bf 0e 00 00 00       	mov    $0xe,%edi
    108f:	48 b8 0f 15 00 00 00 	movabs $0x150f,%rax
    1096:	00 00 00 
    1099:	ff d0                	call   *%rax
  alarm(5); //
    109b:	bf 05 00 00 00       	mov    $0x5,%edi
    10a0:	48 b8 02 15 00 00 00 	movabs $0x1502,%rax
    10a7:	00 00 00 
    10aa:	ff d0                	call   *%rax

  while(1) {
    printf(1,"Still waiting for that alarm... \n");
    10ac:	48 b8 48 1e 00 00 00 	movabs $0x1e48,%rax
    10b3:	00 00 00 
    10b6:	48 89 c6             	mov    %rax,%rsi
    10b9:	bf 01 00 00 00       	mov    $0x1,%edi
    10be:	b8 00 00 00 00       	mov    $0x0,%eax
    10c3:	48 ba 0c 17 00 00 00 	movabs $0x170c,%rdx
    10ca:	00 00 00 
    10cd:	ff d2                	call   *%rdx
    sleep(100);
    10cf:	bf 64 00 00 00       	mov    $0x64,%edi
    10d4:	48 b8 e8 14 00 00 00 	movabs $0x14e8,%rax
    10db:	00 00 00 
    10de:	ff d0                	call   *%rax
    printf(1,"Still waiting for that alarm... \n");
    10e0:	90                   	nop
    10e1:	eb c9                	jmp    10ac <main+0xac>

00000000000010e3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10e3:	55                   	push   %rbp
    10e4:	48 89 e5             	mov    %rsp,%rbp
    10e7:	48 83 ec 10          	sub    $0x10,%rsp
    10eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10ef:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10f2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10f5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10f9:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10ff:	48 89 ce             	mov    %rcx,%rsi
    1102:	48 89 f7             	mov    %rsi,%rdi
    1105:	89 d1                	mov    %edx,%ecx
    1107:	fc                   	cld
    1108:	f3 aa                	rep stos %al,(%rdi)
    110a:	89 ca                	mov    %ecx,%edx
    110c:	48 89 fe             	mov    %rdi,%rsi
    110f:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1113:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1116:	90                   	nop
    1117:	c9                   	leave
    1118:	c3                   	ret

0000000000001119 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1119:	55                   	push   %rbp
    111a:	48 89 e5             	mov    %rsp,%rbp
    111d:	48 83 ec 20          	sub    $0x20,%rsp
    1121:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1125:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    112d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1131:	90                   	nop
    1132:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1136:	48 8d 42 01          	lea    0x1(%rdx),%rax
    113a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    113e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1142:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1146:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    114a:	0f b6 12             	movzbl (%rdx),%edx
    114d:	88 10                	mov    %dl,(%rax)
    114f:	0f b6 00             	movzbl (%rax),%eax
    1152:	84 c0                	test   %al,%al
    1154:	75 dc                	jne    1132 <strcpy+0x19>
    ;
  return os;
    1156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    115a:	c9                   	leave
    115b:	c3                   	ret

000000000000115c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    115c:	55                   	push   %rbp
    115d:	48 89 e5             	mov    %rsp,%rbp
    1160:	48 83 ec 10          	sub    $0x10,%rsp
    1164:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1168:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    116c:	eb 0a                	jmp    1178 <strcmp+0x1c>
    p++, q++;
    116e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1173:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    117c:	0f b6 00             	movzbl (%rax),%eax
    117f:	84 c0                	test   %al,%al
    1181:	74 12                	je     1195 <strcmp+0x39>
    1183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1187:	0f b6 10             	movzbl (%rax),%edx
    118a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    118e:	0f b6 00             	movzbl (%rax),%eax
    1191:	38 c2                	cmp    %al,%dl
    1193:	74 d9                	je     116e <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1199:	0f b6 00             	movzbl (%rax),%eax
    119c:	0f b6 d0             	movzbl %al,%edx
    119f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11a3:	0f b6 00             	movzbl (%rax),%eax
    11a6:	0f b6 c0             	movzbl %al,%eax
    11a9:	29 c2                	sub    %eax,%edx
    11ab:	89 d0                	mov    %edx,%eax
}
    11ad:	c9                   	leave
    11ae:	c3                   	ret

00000000000011af <strlen>:

uint
strlen(char *s)
{
    11af:	55                   	push   %rbp
    11b0:	48 89 e5             	mov    %rsp,%rbp
    11b3:	48 83 ec 18          	sub    $0x18,%rsp
    11b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    11bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11c2:	eb 04                	jmp    11c8 <strlen+0x19>
    11c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11cb:	48 63 d0             	movslq %eax,%rdx
    11ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    11d2:	48 01 d0             	add    %rdx,%rax
    11d5:	0f b6 00             	movzbl (%rax),%eax
    11d8:	84 c0                	test   %al,%al
    11da:	75 e8                	jne    11c4 <strlen+0x15>
    ;
  return n;
    11dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11df:	c9                   	leave
    11e0:	c3                   	ret

00000000000011e1 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11e1:	55                   	push   %rbp
    11e2:	48 89 e5             	mov    %rsp,%rbp
    11e5:	48 83 ec 10          	sub    $0x10,%rsp
    11e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ed:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11f0:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11f3:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11f6:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fd:	89 ce                	mov    %ecx,%esi
    11ff:	48 89 c7             	mov    %rax,%rdi
    1202:	48 b8 e3 10 00 00 00 	movabs $0x10e3,%rax
    1209:	00 00 00 
    120c:	ff d0                	call   *%rax
  return dst;
    120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1212:	c9                   	leave
    1213:	c3                   	ret

0000000000001214 <strchr>:

char*
strchr(const char *s, char c)
{
    1214:	55                   	push   %rbp
    1215:	48 89 e5             	mov    %rsp,%rbp
    1218:	48 83 ec 10          	sub    $0x10,%rsp
    121c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1220:	89 f0                	mov    %esi,%eax
    1222:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1225:	eb 17                	jmp    123e <strchr+0x2a>
    if(*s == c)
    1227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    122b:	0f b6 00             	movzbl (%rax),%eax
    122e:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1231:	75 06                	jne    1239 <strchr+0x25>
      return (char*)s;
    1233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1237:	eb 15                	jmp    124e <strchr+0x3a>
  for(; *s; s++)
    1239:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    123e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1242:	0f b6 00             	movzbl (%rax),%eax
    1245:	84 c0                	test   %al,%al
    1247:	75 de                	jne    1227 <strchr+0x13>
  return 0;
    1249:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124e:	c9                   	leave
    124f:	c3                   	ret

0000000000001250 <gets>:

char*
gets(char *buf, int max)
{
    1250:	55                   	push   %rbp
    1251:	48 89 e5             	mov    %rsp,%rbp
    1254:	48 83 ec 20          	sub    $0x20,%rsp
    1258:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    125c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    125f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1266:	eb 4f                	jmp    12b7 <gets+0x67>
    cc = read(0, &c, 1);
    1268:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    126c:	ba 01 00 00 00       	mov    $0x1,%edx
    1271:	48 89 c6             	mov    %rax,%rsi
    1274:	bf 00 00 00 00       	mov    $0x0,%edi
    1279:	48 b8 25 14 00 00 00 	movabs $0x1425,%rax
    1280:	00 00 00 
    1283:	ff d0                	call   *%rax
    1285:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1288:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    128c:	7e 36                	jle    12c4 <gets+0x74>
      break;
    buf[i++] = c;
    128e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1291:	8d 50 01             	lea    0x1(%rax),%edx
    1294:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1297:	48 63 d0             	movslq %eax,%rdx
    129a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    129e:	48 01 c2             	add    %rax,%rdx
    12a1:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12a5:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    12a7:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12ab:	3c 0a                	cmp    $0xa,%al
    12ad:	74 16                	je     12c5 <gets+0x75>
    12af:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    12b3:	3c 0d                	cmp    $0xd,%al
    12b5:	74 0e                	je     12c5 <gets+0x75>
  for(i=0; i+1 < max; ){
    12b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12ba:	83 c0 01             	add    $0x1,%eax
    12bd:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    12c0:	7f a6                	jg     1268 <gets+0x18>
    12c2:	eb 01                	jmp    12c5 <gets+0x75>
      break;
    12c4:	90                   	nop
      break;
  }
  buf[i] = '\0';
    12c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12c8:	48 63 d0             	movslq %eax,%rdx
    12cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12cf:	48 01 d0             	add    %rdx,%rax
    12d2:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12d9:	c9                   	leave
    12da:	c3                   	ret

00000000000012db <stat>:

int
stat(char *n, struct stat *st)
{
    12db:	55                   	push   %rbp
    12dc:	48 89 e5             	mov    %rsp,%rbp
    12df:	48 83 ec 20          	sub    $0x20,%rsp
    12e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12ef:	be 00 00 00 00       	mov    $0x0,%esi
    12f4:	48 89 c7             	mov    %rax,%rdi
    12f7:	48 b8 66 14 00 00 00 	movabs $0x1466,%rax
    12fe:	00 00 00 
    1301:	ff d0                	call   *%rax
    1303:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1306:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    130a:	79 07                	jns    1313 <stat+0x38>
    return -1;
    130c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1311:	eb 2f                	jmp    1342 <stat+0x67>
  r = fstat(fd, st);
    1313:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1317:	8b 45 fc             	mov    -0x4(%rbp),%eax
    131a:	48 89 d6             	mov    %rdx,%rsi
    131d:	89 c7                	mov    %eax,%edi
    131f:	48 b8 8d 14 00 00 00 	movabs $0x148d,%rax
    1326:	00 00 00 
    1329:	ff d0                	call   *%rax
    132b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    132e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1331:	89 c7                	mov    %eax,%edi
    1333:	48 b8 3f 14 00 00 00 	movabs $0x143f,%rax
    133a:	00 00 00 
    133d:	ff d0                	call   *%rax
  return r;
    133f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1342:	c9                   	leave
    1343:	c3                   	ret

0000000000001344 <atoi>:

int
atoi(const char *s)
{
    1344:	55                   	push   %rbp
    1345:	48 89 e5             	mov    %rsp,%rbp
    1348:	48 83 ec 18          	sub    $0x18,%rsp
    134c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1357:	eb 28                	jmp    1381 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    1359:	8b 55 fc             	mov    -0x4(%rbp),%edx
    135c:	89 d0                	mov    %edx,%eax
    135e:	c1 e0 02             	shl    $0x2,%eax
    1361:	01 d0                	add    %edx,%eax
    1363:	01 c0                	add    %eax,%eax
    1365:	89 c1                	mov    %eax,%ecx
    1367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    136f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1373:	0f b6 00             	movzbl (%rax),%eax
    1376:	0f be c0             	movsbl %al,%eax
    1379:	01 c8                	add    %ecx,%eax
    137b:	83 e8 30             	sub    $0x30,%eax
    137e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1385:	0f b6 00             	movzbl (%rax),%eax
    1388:	3c 2f                	cmp    $0x2f,%al
    138a:	7e 0b                	jle    1397 <atoi+0x53>
    138c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1390:	0f b6 00             	movzbl (%rax),%eax
    1393:	3c 39                	cmp    $0x39,%al
    1395:	7e c2                	jle    1359 <atoi+0x15>
  return n;
    1397:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    139a:	c9                   	leave
    139b:	c3                   	ret

000000000000139c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    139c:	55                   	push   %rbp
    139d:	48 89 e5             	mov    %rsp,%rbp
    13a0:	48 83 ec 28          	sub    $0x28,%rsp
    13a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    13ac:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    13af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    13b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    13bf:	eb 1d                	jmp    13de <memmove+0x42>
    *dst++ = *src++;
    13c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13c5:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13d1:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13d5:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13d9:	0f b6 12             	movzbl (%rdx),%edx
    13dc:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13de:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e1:	8d 50 ff             	lea    -0x1(%rax),%edx
    13e4:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13e7:	85 c0                	test   %eax,%eax
    13e9:	7f d6                	jg     13c1 <memmove+0x25>
  return vdst;
    13eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ef:	c9                   	leave
    13f0:	c3                   	ret

00000000000013f1 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13f1:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13f8:	49 89 ca             	mov    %rcx,%r10
    13fb:	0f 05                	syscall
    13fd:	c3                   	ret

00000000000013fe <exit>:
SYSCALL(exit)
    13fe:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1405:	49 89 ca             	mov    %rcx,%r10
    1408:	0f 05                	syscall
    140a:	c3                   	ret

000000000000140b <wait>:
SYSCALL(wait)
    140b:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1412:	49 89 ca             	mov    %rcx,%r10
    1415:	0f 05                	syscall
    1417:	c3                   	ret

0000000000001418 <pipe>:
SYSCALL(pipe)
    1418:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    141f:	49 89 ca             	mov    %rcx,%r10
    1422:	0f 05                	syscall
    1424:	c3                   	ret

0000000000001425 <read>:
SYSCALL(read)
    1425:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    142c:	49 89 ca             	mov    %rcx,%r10
    142f:	0f 05                	syscall
    1431:	c3                   	ret

0000000000001432 <write>:
SYSCALL(write)
    1432:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1439:	49 89 ca             	mov    %rcx,%r10
    143c:	0f 05                	syscall
    143e:	c3                   	ret

000000000000143f <close>:
SYSCALL(close)
    143f:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1446:	49 89 ca             	mov    %rcx,%r10
    1449:	0f 05                	syscall
    144b:	c3                   	ret

000000000000144c <kill>:
SYSCALL(kill)
    144c:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1453:	49 89 ca             	mov    %rcx,%r10
    1456:	0f 05                	syscall
    1458:	c3                   	ret

0000000000001459 <exec>:
SYSCALL(exec)
    1459:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1460:	49 89 ca             	mov    %rcx,%r10
    1463:	0f 05                	syscall
    1465:	c3                   	ret

0000000000001466 <open>:
SYSCALL(open)
    1466:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    146d:	49 89 ca             	mov    %rcx,%r10
    1470:	0f 05                	syscall
    1472:	c3                   	ret

0000000000001473 <mknod>:
SYSCALL(mknod)
    1473:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    147a:	49 89 ca             	mov    %rcx,%r10
    147d:	0f 05                	syscall
    147f:	c3                   	ret

0000000000001480 <unlink>:
SYSCALL(unlink)
    1480:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1487:	49 89 ca             	mov    %rcx,%r10
    148a:	0f 05                	syscall
    148c:	c3                   	ret

000000000000148d <fstat>:
SYSCALL(fstat)
    148d:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1494:	49 89 ca             	mov    %rcx,%r10
    1497:	0f 05                	syscall
    1499:	c3                   	ret

000000000000149a <link>:
SYSCALL(link)
    149a:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    14a1:	49 89 ca             	mov    %rcx,%r10
    14a4:	0f 05                	syscall
    14a6:	c3                   	ret

00000000000014a7 <mkdir>:
SYSCALL(mkdir)
    14a7:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    14ae:	49 89 ca             	mov    %rcx,%r10
    14b1:	0f 05                	syscall
    14b3:	c3                   	ret

00000000000014b4 <chdir>:
SYSCALL(chdir)
    14b4:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    14bb:	49 89 ca             	mov    %rcx,%r10
    14be:	0f 05                	syscall
    14c0:	c3                   	ret

00000000000014c1 <dup>:
SYSCALL(dup)
    14c1:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14c8:	49 89 ca             	mov    %rcx,%r10
    14cb:	0f 05                	syscall
    14cd:	c3                   	ret

00000000000014ce <getpid>:
SYSCALL(getpid)
    14ce:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14d5:	49 89 ca             	mov    %rcx,%r10
    14d8:	0f 05                	syscall
    14da:	c3                   	ret

00000000000014db <sbrk>:
SYSCALL(sbrk)
    14db:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14e2:	49 89 ca             	mov    %rcx,%r10
    14e5:	0f 05                	syscall
    14e7:	c3                   	ret

00000000000014e8 <sleep>:
SYSCALL(sleep)
    14e8:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14ef:	49 89 ca             	mov    %rcx,%r10
    14f2:	0f 05                	syscall
    14f4:	c3                   	ret

00000000000014f5 <uptime>:
SYSCALL(uptime)
    14f5:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14fc:	49 89 ca             	mov    %rcx,%r10
    14ff:	0f 05                	syscall
    1501:	c3                   	ret

0000000000001502 <alarm>:

SYSCALL(alarm)
    1502:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1509:	49 89 ca             	mov    %rcx,%r10
    150c:	0f 05                	syscall
    150e:	c3                   	ret

000000000000150f <signal>:
SYSCALL(signal)
    150f:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    1516:	49 89 ca             	mov    %rcx,%r10
    1519:	0f 05                	syscall
    151b:	c3                   	ret

000000000000151c <sigret>:
SYSCALL(sigret)
    151c:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    1523:	49 89 ca             	mov    %rcx,%r10
    1526:	0f 05                	syscall
    1528:	c3                   	ret

0000000000001529 <fgproc>:
SYSCALL(fgproc)
    1529:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    1530:	49 89 ca             	mov    %rcx,%r10
    1533:	0f 05                	syscall
    1535:	c3                   	ret

0000000000001536 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1536:	55                   	push   %rbp
    1537:	48 89 e5             	mov    %rsp,%rbp
    153a:	48 83 ec 10          	sub    $0x10,%rsp
    153e:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1541:	89 f0                	mov    %esi,%eax
    1543:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1546:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    154a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    154d:	ba 01 00 00 00       	mov    $0x1,%edx
    1552:	48 89 ce             	mov    %rcx,%rsi
    1555:	89 c7                	mov    %eax,%edi
    1557:	48 b8 32 14 00 00 00 	movabs $0x1432,%rax
    155e:	00 00 00 
    1561:	ff d0                	call   *%rax
}
    1563:	90                   	nop
    1564:	c9                   	leave
    1565:	c3                   	ret

0000000000001566 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1566:	55                   	push   %rbp
    1567:	48 89 e5             	mov    %rsp,%rbp
    156a:	48 83 ec 20          	sub    $0x20,%rsp
    156e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1571:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1575:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    157c:	eb 35                	jmp    15b3 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    157e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1582:	48 c1 e8 3c          	shr    $0x3c,%rax
    1586:	48 ba 80 1e 00 00 00 	movabs $0x1e80,%rdx
    158d:	00 00 00 
    1590:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1594:	0f be d0             	movsbl %al,%edx
    1597:	8b 45 ec             	mov    -0x14(%rbp),%eax
    159a:	89 d6                	mov    %edx,%esi
    159c:	89 c7                	mov    %eax,%edi
    159e:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    15a5:	00 00 00 
    15a8:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    15aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15ae:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    15b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15b6:	83 f8 0f             	cmp    $0xf,%eax
    15b9:	76 c3                	jbe    157e <print_x64+0x18>
}
    15bb:	90                   	nop
    15bc:	90                   	nop
    15bd:	c9                   	leave
    15be:	c3                   	ret

00000000000015bf <print_x32>:

  static void
print_x32(int fd, uint x)
{
    15bf:	55                   	push   %rbp
    15c0:	48 89 e5             	mov    %rsp,%rbp
    15c3:	48 83 ec 20          	sub    $0x20,%rsp
    15c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
    15ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15d4:	eb 36                	jmp    160c <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    15d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
    15d9:	c1 e8 1c             	shr    $0x1c,%eax
    15dc:	89 c2                	mov    %eax,%edx
    15de:	48 b8 80 1e 00 00 00 	movabs $0x1e80,%rax
    15e5:	00 00 00 
    15e8:	89 d2                	mov    %edx,%edx
    15ea:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15ee:	0f be d0             	movsbl %al,%edx
    15f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15f4:	89 d6                	mov    %edx,%esi
    15f6:	89 c7                	mov    %eax,%edi
    15f8:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    15ff:	00 00 00 
    1602:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1604:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1608:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    160c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    160f:	83 f8 07             	cmp    $0x7,%eax
    1612:	76 c2                	jbe    15d6 <print_x32+0x17>
}
    1614:	90                   	nop
    1615:	90                   	nop
    1616:	c9                   	leave
    1617:	c3                   	ret

0000000000001618 <print_d>:

  static void
print_d(int fd, int v)
{
    1618:	55                   	push   %rbp
    1619:	48 89 e5             	mov    %rsp,%rbp
    161c:	48 83 ec 30          	sub    $0x30,%rsp
    1620:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1623:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1626:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1629:	48 98                	cltq
    162b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    162f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1633:	79 04                	jns    1639 <print_d+0x21>
    x = -x;
    1635:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1640:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1644:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    164b:	66 66 66 
    164e:	48 89 c8             	mov    %rcx,%rax
    1651:	48 f7 ea             	imul   %rdx
    1654:	48 c1 fa 02          	sar    $0x2,%rdx
    1658:	48 89 c8             	mov    %rcx,%rax
    165b:	48 c1 f8 3f          	sar    $0x3f,%rax
    165f:	48 29 c2             	sub    %rax,%rdx
    1662:	48 89 d0             	mov    %rdx,%rax
    1665:	48 c1 e0 02          	shl    $0x2,%rax
    1669:	48 01 d0             	add    %rdx,%rax
    166c:	48 01 c0             	add    %rax,%rax
    166f:	48 29 c1             	sub    %rax,%rcx
    1672:	48 89 ca             	mov    %rcx,%rdx
    1675:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1678:	8d 48 01             	lea    0x1(%rax),%ecx
    167b:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    167e:	48 b9 80 1e 00 00 00 	movabs $0x1e80,%rcx
    1685:	00 00 00 
    1688:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    168c:	48 98                	cltq
    168e:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1692:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1696:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    169d:	66 66 66 
    16a0:	48 89 c8             	mov    %rcx,%rax
    16a3:	48 f7 ea             	imul   %rdx
    16a6:	48 89 d0             	mov    %rdx,%rax
    16a9:	48 c1 f8 02          	sar    $0x2,%rax
    16ad:	48 c1 f9 3f          	sar    $0x3f,%rcx
    16b1:	48 89 ca             	mov    %rcx,%rdx
    16b4:	48 29 d0             	sub    %rdx,%rax
    16b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    16bb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    16c0:	0f 85 7a ff ff ff    	jne    1640 <print_d+0x28>

  if (v < 0)
    16c6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    16ca:	79 32                	jns    16fe <print_d+0xe6>
    buf[i++] = '-';
    16cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16cf:	8d 50 01             	lea    0x1(%rax),%edx
    16d2:	89 55 f4             	mov    %edx,-0xc(%rbp)
    16d5:	48 98                	cltq
    16d7:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16dc:	eb 20                	jmp    16fe <print_d+0xe6>
    putc(fd, buf[i]);
    16de:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16e1:	48 98                	cltq
    16e3:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16e8:	0f be d0             	movsbl %al,%edx
    16eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16ee:	89 d6                	mov    %edx,%esi
    16f0:	89 c7                	mov    %eax,%edi
    16f2:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    16f9:	00 00 00 
    16fc:	ff d0                	call   *%rax
  while (--i >= 0)
    16fe:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1702:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1706:	79 d6                	jns    16de <print_d+0xc6>
}
    1708:	90                   	nop
    1709:	90                   	nop
    170a:	c9                   	leave
    170b:	c3                   	ret

000000000000170c <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    170c:	55                   	push   %rbp
    170d:	48 89 e5             	mov    %rsp,%rbp
    1710:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1717:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    171d:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1724:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    172b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1732:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1739:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1740:	84 c0                	test   %al,%al
    1742:	74 20                	je     1764 <printf+0x58>
    1744:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1748:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    174c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1750:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1754:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1758:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    175c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1760:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1764:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    176b:	00 00 00 
    176e:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1775:	00 00 00 
    1778:	48 8d 45 10          	lea    0x10(%rbp),%rax
    177c:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1783:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    178a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1791:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1798:	00 00 00 
    179b:	e9 60 03 00 00       	jmp    1b00 <printf+0x3f4>
    if (c != '%') {
    17a0:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17a7:	74 24                	je     17cd <printf+0xc1>
      putc(fd, c);
    17a9:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17af:	0f be d0             	movsbl %al,%edx
    17b2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    17b8:	89 d6                	mov    %edx,%esi
    17ba:	89 c7                	mov    %eax,%edi
    17bc:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    17c3:	00 00 00 
    17c6:	ff d0                	call   *%rax
      continue;
    17c8:	e9 2c 03 00 00       	jmp    1af9 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    17cd:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17d4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17da:	48 63 d0             	movslq %eax,%rdx
    17dd:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17e4:	48 01 d0             	add    %rdx,%rax
    17e7:	0f b6 00             	movzbl (%rax),%eax
    17ea:	0f be c0             	movsbl %al,%eax
    17ed:	25 ff 00 00 00       	and    $0xff,%eax
    17f2:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17f8:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17ff:	0f 84 2e 03 00 00    	je     1b33 <printf+0x427>
      break;
    switch(c) {
    1805:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    180c:	0f 84 32 01 00 00    	je     1944 <printf+0x238>
    1812:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1819:	0f 8f a1 02 00 00    	jg     1ac0 <printf+0x3b4>
    181f:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1826:	0f 84 d4 01 00 00    	je     1a00 <printf+0x2f4>
    182c:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1833:	0f 8f 87 02 00 00    	jg     1ac0 <printf+0x3b4>
    1839:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1840:	0f 84 5b 01 00 00    	je     19a1 <printf+0x295>
    1846:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    184d:	0f 8f 6d 02 00 00    	jg     1ac0 <printf+0x3b4>
    1853:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    185a:	0f 84 87 00 00 00    	je     18e7 <printf+0x1db>
    1860:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1867:	0f 8f 53 02 00 00    	jg     1ac0 <printf+0x3b4>
    186d:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1874:	0f 84 2b 02 00 00    	je     1aa5 <printf+0x399>
    187a:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1881:	0f 85 39 02 00 00    	jne    1ac0 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1887:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    188d:	83 f8 2f             	cmp    $0x2f,%eax
    1890:	77 23                	ja     18b5 <printf+0x1a9>
    1892:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1899:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    189f:	89 d2                	mov    %edx,%edx
    18a1:	48 01 d0             	add    %rdx,%rax
    18a4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18aa:	83 c2 08             	add    $0x8,%edx
    18ad:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18b3:	eb 12                	jmp    18c7 <printf+0x1bb>
    18b5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18bc:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18c0:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18c7:	8b 00                	mov    (%rax),%eax
    18c9:	0f be d0             	movsbl %al,%edx
    18cc:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18d2:	89 d6                	mov    %edx,%esi
    18d4:	89 c7                	mov    %eax,%edi
    18d6:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    18dd:	00 00 00 
    18e0:	ff d0                	call   *%rax
      break;
    18e2:	e9 12 02 00 00       	jmp    1af9 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    18e7:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18ed:	83 f8 2f             	cmp    $0x2f,%eax
    18f0:	77 23                	ja     1915 <printf+0x209>
    18f2:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18f9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18ff:	89 d2                	mov    %edx,%edx
    1901:	48 01 d0             	add    %rdx,%rax
    1904:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    190a:	83 c2 08             	add    $0x8,%edx
    190d:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1913:	eb 12                	jmp    1927 <printf+0x21b>
    1915:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    191c:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1920:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1927:	8b 10                	mov    (%rax),%edx
    1929:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    192f:	89 d6                	mov    %edx,%esi
    1931:	89 c7                	mov    %eax,%edi
    1933:	48 b8 18 16 00 00 00 	movabs $0x1618,%rax
    193a:	00 00 00 
    193d:	ff d0                	call   *%rax
      break;
    193f:	e9 b5 01 00 00       	jmp    1af9 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1944:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    194a:	83 f8 2f             	cmp    $0x2f,%eax
    194d:	77 23                	ja     1972 <printf+0x266>
    194f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1956:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    195c:	89 d2                	mov    %edx,%edx
    195e:	48 01 d0             	add    %rdx,%rax
    1961:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1967:	83 c2 08             	add    $0x8,%edx
    196a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1970:	eb 12                	jmp    1984 <printf+0x278>
    1972:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1979:	48 8d 50 08          	lea    0x8(%rax),%rdx
    197d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1984:	8b 10                	mov    (%rax),%edx
    1986:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    198c:	89 d6                	mov    %edx,%esi
    198e:	89 c7                	mov    %eax,%edi
    1990:	48 b8 bf 15 00 00 00 	movabs $0x15bf,%rax
    1997:	00 00 00 
    199a:	ff d0                	call   *%rax
      break;
    199c:	e9 58 01 00 00       	jmp    1af9 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    19a1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19a7:	83 f8 2f             	cmp    $0x2f,%eax
    19aa:	77 23                	ja     19cf <printf+0x2c3>
    19ac:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19b3:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19b9:	89 d2                	mov    %edx,%edx
    19bb:	48 01 d0             	add    %rdx,%rax
    19be:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c4:	83 c2 08             	add    $0x8,%edx
    19c7:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19cd:	eb 12                	jmp    19e1 <printf+0x2d5>
    19cf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19d6:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19da:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19e1:	48 8b 10             	mov    (%rax),%rdx
    19e4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19ea:	48 89 d6             	mov    %rdx,%rsi
    19ed:	89 c7                	mov    %eax,%edi
    19ef:	48 b8 66 15 00 00 00 	movabs $0x1566,%rax
    19f6:	00 00 00 
    19f9:	ff d0                	call   *%rax
      break;
    19fb:	e9 f9 00 00 00       	jmp    1af9 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1a00:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a06:	83 f8 2f             	cmp    $0x2f,%eax
    1a09:	77 23                	ja     1a2e <printf+0x322>
    1a0b:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a12:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a18:	89 d2                	mov    %edx,%edx
    1a1a:	48 01 d0             	add    %rdx,%rax
    1a1d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a23:	83 c2 08             	add    $0x8,%edx
    1a26:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a2c:	eb 12                	jmp    1a40 <printf+0x334>
    1a2e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a35:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a39:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a40:	48 8b 00             	mov    (%rax),%rax
    1a43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1a4a:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1a51:	00 
    1a52:	75 41                	jne    1a95 <printf+0x389>
        s = "(null)";
    1a54:	48 b8 6a 1e 00 00 00 	movabs $0x1e6a,%rax
    1a5b:	00 00 00 
    1a5e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a65:	eb 2e                	jmp    1a95 <printf+0x389>
        putc(fd, *(s++));
    1a67:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a6e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a72:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a79:	0f b6 00             	movzbl (%rax),%eax
    1a7c:	0f be d0             	movsbl %al,%edx
    1a7f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a85:	89 d6                	mov    %edx,%esi
    1a87:	89 c7                	mov    %eax,%edi
    1a89:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1a90:	00 00 00 
    1a93:	ff d0                	call   *%rax
      while (*s)
    1a95:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a9c:	0f b6 00             	movzbl (%rax),%eax
    1a9f:	84 c0                	test   %al,%al
    1aa1:	75 c4                	jne    1a67 <printf+0x35b>
      break;
    1aa3:	eb 54                	jmp    1af9 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1aa5:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1aab:	be 25 00 00 00       	mov    $0x25,%esi
    1ab0:	89 c7                	mov    %eax,%edi
    1ab2:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1ab9:	00 00 00 
    1abc:	ff d0                	call   *%rax
      break;
    1abe:	eb 39                	jmp    1af9 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1ac0:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ac6:	be 25 00 00 00       	mov    $0x25,%esi
    1acb:	89 c7                	mov    %eax,%edi
    1acd:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1ad4:	00 00 00 
    1ad7:	ff d0                	call   *%rax
      putc(fd, c);
    1ad9:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1adf:	0f be d0             	movsbl %al,%edx
    1ae2:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ae8:	89 d6                	mov    %edx,%esi
    1aea:	89 c7                	mov    %eax,%edi
    1aec:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1af3:	00 00 00 
    1af6:	ff d0                	call   *%rax
      break;
    1af8:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1af9:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b00:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b06:	48 63 d0             	movslq %eax,%rdx
    1b09:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1b10:	48 01 d0             	add    %rdx,%rax
    1b13:	0f b6 00             	movzbl (%rax),%eax
    1b16:	0f be c0             	movsbl %al,%eax
    1b19:	25 ff 00 00 00       	and    $0xff,%eax
    1b1e:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1b24:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1b2b:	0f 85 6f fc ff ff    	jne    17a0 <printf+0x94>
    }
  }
}
    1b31:	eb 01                	jmp    1b34 <printf+0x428>
      break;
    1b33:	90                   	nop
}
    1b34:	90                   	nop
    1b35:	c9                   	leave
    1b36:	c3                   	ret

0000000000001b37 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1b37:	55                   	push   %rbp
    1b38:	48 89 e5             	mov    %rsp,%rbp
    1b3b:	48 83 ec 18          	sub    $0x18,%rsp
    1b3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1b47:	48 83 e8 10          	sub    $0x10,%rax
    1b4b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b4f:	48 b8 b0 1e 00 00 00 	movabs $0x1eb0,%rax
    1b56:	00 00 00 
    1b59:	48 8b 00             	mov    (%rax),%rax
    1b5c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b60:	eb 2f                	jmp    1b91 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b66:	48 8b 00             	mov    (%rax),%rax
    1b69:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b6d:	72 17                	jb     1b86 <free+0x4f>
    1b6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b73:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b77:	72 2f                	jb     1ba8 <free+0x71>
    1b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b7d:	48 8b 00             	mov    (%rax),%rax
    1b80:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b84:	72 22                	jb     1ba8 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b8a:	48 8b 00             	mov    (%rax),%rax
    1b8d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b95:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b99:	73 c7                	jae    1b62 <free+0x2b>
    1b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9f:	48 8b 00             	mov    (%rax),%rax
    1ba2:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ba6:	73 ba                	jae    1b62 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1ba8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bac:	8b 40 08             	mov    0x8(%rax),%eax
    1baf:	89 c0                	mov    %eax,%eax
    1bb1:	48 c1 e0 04          	shl    $0x4,%rax
    1bb5:	48 89 c2             	mov    %rax,%rdx
    1bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bbc:	48 01 c2             	add    %rax,%rdx
    1bbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bc3:	48 8b 00             	mov    (%rax),%rax
    1bc6:	48 39 c2             	cmp    %rax,%rdx
    1bc9:	75 2d                	jne    1bf8 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bcf:	8b 50 08             	mov    0x8(%rax),%edx
    1bd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd6:	48 8b 00             	mov    (%rax),%rax
    1bd9:	8b 40 08             	mov    0x8(%rax),%eax
    1bdc:	01 c2                	add    %eax,%edx
    1bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1be2:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be9:	48 8b 00             	mov    (%rax),%rax
    1bec:	48 8b 10             	mov    (%rax),%rdx
    1bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bf3:	48 89 10             	mov    %rdx,(%rax)
    1bf6:	eb 0e                	jmp    1c06 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1bf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bfc:	48 8b 10             	mov    (%rax),%rdx
    1bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c03:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1c06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c0a:	8b 40 08             	mov    0x8(%rax),%eax
    1c0d:	89 c0                	mov    %eax,%eax
    1c0f:	48 c1 e0 04          	shl    $0x4,%rax
    1c13:	48 89 c2             	mov    %rax,%rdx
    1c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c1a:	48 01 d0             	add    %rdx,%rax
    1c1d:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c21:	75 27                	jne    1c4a <free+0x113>
    p->s.size += bp->s.size;
    1c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c27:	8b 50 08             	mov    0x8(%rax),%edx
    1c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c2e:	8b 40 08             	mov    0x8(%rax),%eax
    1c31:	01 c2                	add    %eax,%edx
    1c33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c37:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1c3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c3e:	48 8b 10             	mov    (%rax),%rdx
    1c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c45:	48 89 10             	mov    %rdx,(%rax)
    1c48:	eb 0b                	jmp    1c55 <free+0x11e>
  } else
    p->s.ptr = bp;
    1c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c52:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c55:	48 ba b0 1e 00 00 00 	movabs $0x1eb0,%rdx
    1c5c:	00 00 00 
    1c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c63:	48 89 02             	mov    %rax,(%rdx)
}
    1c66:	90                   	nop
    1c67:	c9                   	leave
    1c68:	c3                   	ret

0000000000001c69 <morecore>:

static Header*
morecore(uint nu)
{
    1c69:	55                   	push   %rbp
    1c6a:	48 89 e5             	mov    %rsp,%rbp
    1c6d:	48 83 ec 20          	sub    $0x20,%rsp
    1c71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c74:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c7b:	77 07                	ja     1c84 <morecore+0x1b>
    nu = 4096;
    1c7d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c84:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c87:	48 c1 e0 04          	shl    $0x4,%rax
    1c8b:	48 89 c7             	mov    %rax,%rdi
    1c8e:	48 b8 db 14 00 00 00 	movabs $0x14db,%rax
    1c95:	00 00 00 
    1c98:	ff d0                	call   *%rax
    1c9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c9e:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1ca3:	75 07                	jne    1cac <morecore+0x43>
    return 0;
    1ca5:	b8 00 00 00 00       	mov    $0x0,%eax
    1caa:	eb 36                	jmp    1ce2 <morecore+0x79>
  hp = (Header*)p;
    1cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb8:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1cbb:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc2:	48 83 c0 10          	add    $0x10,%rax
    1cc6:	48 89 c7             	mov    %rax,%rdi
    1cc9:	48 b8 37 1b 00 00 00 	movabs $0x1b37,%rax
    1cd0:	00 00 00 
    1cd3:	ff d0                	call   *%rax
  return freep;
    1cd5:	48 b8 b0 1e 00 00 00 	movabs $0x1eb0,%rax
    1cdc:	00 00 00 
    1cdf:	48 8b 00             	mov    (%rax),%rax
}
    1ce2:	c9                   	leave
    1ce3:	c3                   	ret

0000000000001ce4 <malloc>:

void*
malloc(uint nbytes)
{
    1ce4:	55                   	push   %rbp
    1ce5:	48 89 e5             	mov    %rsp,%rbp
    1ce8:	48 83 ec 30          	sub    $0x30,%rsp
    1cec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1cef:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cf2:	48 83 c0 0f          	add    $0xf,%rax
    1cf6:	48 c1 e8 04          	shr    $0x4,%rax
    1cfa:	83 c0 01             	add    $0x1,%eax
    1cfd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1d00:	48 b8 b0 1e 00 00 00 	movabs $0x1eb0,%rax
    1d07:	00 00 00 
    1d0a:	48 8b 00             	mov    (%rax),%rax
    1d0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d11:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1d16:	75 4a                	jne    1d62 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1d18:	48 b8 a0 1e 00 00 00 	movabs $0x1ea0,%rax
    1d1f:	00 00 00 
    1d22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d26:	48 ba b0 1e 00 00 00 	movabs $0x1eb0,%rdx
    1d2d:	00 00 00 
    1d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d34:	48 89 02             	mov    %rax,(%rdx)
    1d37:	48 b8 b0 1e 00 00 00 	movabs $0x1eb0,%rax
    1d3e:	00 00 00 
    1d41:	48 8b 00             	mov    (%rax),%rax
    1d44:	48 ba a0 1e 00 00 00 	movabs $0x1ea0,%rdx
    1d4b:	00 00 00 
    1d4e:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d51:	48 b8 a0 1e 00 00 00 	movabs $0x1ea0,%rax
    1d58:	00 00 00 
    1d5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d66:	48 8b 00             	mov    (%rax),%rax
    1d69:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d71:	8b 40 08             	mov    0x8(%rax),%eax
    1d74:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1d77:	72 65                	jb     1dde <malloc+0xfa>
      if(p->s.size == nunits)
    1d79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d7d:	8b 40 08             	mov    0x8(%rax),%eax
    1d80:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d83:	75 10                	jne    1d95 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d89:	48 8b 10             	mov    (%rax),%rdx
    1d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d90:	48 89 10             	mov    %rdx,(%rax)
    1d93:	eb 2e                	jmp    1dc3 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d99:	8b 40 08             	mov    0x8(%rax),%eax
    1d9c:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d9f:	89 c2                	mov    %eax,%edx
    1da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1da5:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1da8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dac:	8b 40 08             	mov    0x8(%rax),%eax
    1daf:	89 c0                	mov    %eax,%eax
    1db1:	48 c1 e0 04          	shl    $0x4,%rax
    1db5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1db9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dbd:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1dc0:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1dc3:	48 ba b0 1e 00 00 00 	movabs $0x1eb0,%rdx
    1dca:	00 00 00 
    1dcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dd1:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd8:	48 83 c0 10          	add    $0x10,%rax
    1ddc:	eb 4e                	jmp    1e2c <malloc+0x148>
    }
    if(p == freep)
    1dde:	48 b8 b0 1e 00 00 00 	movabs $0x1eb0,%rax
    1de5:	00 00 00 
    1de8:	48 8b 00             	mov    (%rax),%rax
    1deb:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1def:	75 23                	jne    1e14 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    1df1:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1df4:	89 c7                	mov    %eax,%edi
    1df6:	48 b8 69 1c 00 00 00 	movabs $0x1c69,%rax
    1dfd:	00 00 00 
    1e00:	ff d0                	call   *%rax
    1e02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1e06:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1e0b:	75 07                	jne    1e14 <malloc+0x130>
        return 0;
    1e0d:	b8 00 00 00 00       	mov    $0x0,%eax
    1e12:	eb 18                	jmp    1e2c <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e20:	48 8b 00             	mov    (%rax),%rax
    1e23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e27:	e9 41 ff ff ff       	jmp    1d6d <malloc+0x89>
  }
}
    1e2c:	c9                   	leave
    1e2d:	c3                   	ret
