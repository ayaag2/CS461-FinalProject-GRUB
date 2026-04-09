
_imshow:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include"types.h"
#include "user.h"
#include "fcntl.h"


int main(int argc, char** argv) {
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 81 ec 20 04 00 00 	sub    $0x420,%rsp
    100b:	89 bd ec fb ff ff    	mov    %edi,-0x414(%rbp)
    1011:	48 89 b5 e0 fb ff ff 	mov    %rsi,-0x420(%rbp)
  int fd;
  if( (fd = open("display",O_WRONLY)) == 0) {
    1018:	48 b8 90 20 00 00 00 	movabs $0x2090,%rax
    101f:	00 00 00 
    1022:	be 01 00 00 00       	mov    $0x1,%esi
    1027:	48 89 c7             	mov    %rax,%rdi
    102a:	48 b8 e8 16 00 00 00 	movabs $0x16e8,%rax
    1031:	00 00 00 
    1034:	ff d0                	call   *%rax
    1036:	89 45 f0             	mov    %eax,-0x10(%rbp)
    1039:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    103d:	75 0c                	jne    104b <main+0x4b>
    exit();
    103f:	48 b8 80 16 00 00 00 	movabs $0x1680,%rax
    1046:	00 00 00 
    1049:	ff d0                	call   *%rax
  }

  int img;
  if( (img = open("cover.raw",0)) == 0) {
    104b:	48 b8 98 20 00 00 00 	movabs $0x2098,%rax
    1052:	00 00 00 
    1055:	be 00 00 00 00       	mov    $0x0,%esi
    105a:	48 89 c7             	mov    %rax,%rdi
    105d:	48 b8 e8 16 00 00 00 	movabs $0x16e8,%rax
    1064:	00 00 00 
    1067:	ff d0                	call   *%rax
    1069:	89 45 ec             	mov    %eax,-0x14(%rbp)
    106c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    1070:	75 0c                	jne    107e <main+0x7e>
    exit();
    1072:	48 b8 80 16 00 00 00 	movabs $0x1680,%rax
    1079:	00 00 00 
    107c:	ff d0                	call   *%rax
  }

  // switch modes to VGA 0x13
  if(ioctl(fd,1,0x13) < 0) {
    107e:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1081:	ba 13 00 00 00       	mov    $0x13,%edx
    1086:	be 01 00 00 00       	mov    $0x1,%esi
    108b:	89 c7                	mov    %eax,%edi
    108d:	48 b8 84 17 00 00 00 	movabs $0x1784,%rax
    1094:	00 00 00 
    1097:	ff d0                	call   *%rax
    1099:	85 c0                	test   %eax,%eax
    109b:	79 2f                	jns    10cc <main+0xcc>
    printf(2,"error: ioctl to switch to VGA mode failed.\n");
    109d:	48 b8 a8 20 00 00 00 	movabs $0x20a8,%rax
    10a4:	00 00 00 
    10a7:	48 89 c6             	mov    %rax,%rsi
    10aa:	bf 02 00 00 00       	mov    $0x2,%edi
    10af:	b8 00 00 00 00       	mov    $0x0,%eax
    10b4:	48 ba 67 19 00 00 00 	movabs $0x1967,%rdx
    10bb:	00 00 00 
    10be:	ff d2                	call   *%rdx
    exit();
    10c0:	48 b8 80 16 00 00 00 	movabs $0x1680,%rax
    10c7:	00 00 00 
    10ca:	ff d0                	call   *%rax
  }

  int k;
  char buf[1000];
  for(k=0;k<64;k++) {
    10cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10d3:	e9 ac 00 00 00       	jmp    1184 <main+0x184>
    int readbytes = read(img,buf,1000);
    10d8:	48 8d 8d f0 fb ff ff 	lea    -0x410(%rbp),%rcx
    10df:	8b 45 ec             	mov    -0x14(%rbp),%eax
    10e2:	ba e8 03 00 00       	mov    $0x3e8,%edx
    10e7:	48 89 ce             	mov    %rcx,%rsi
    10ea:	89 c7                	mov    %eax,%edi
    10ec:	48 b8 a7 16 00 00 00 	movabs $0x16a7,%rax
    10f3:	00 00 00 
    10f6:	ff d0                	call   *%rax
    10f8:	89 45 e8             	mov    %eax,-0x18(%rbp)
    if(readbytes!=1000) {
    10fb:	81 7d e8 e8 03 00 00 	cmpl   $0x3e8,-0x18(%rbp)
    1102:	74 28                	je     112c <main+0x12c>
      printf(1,"Huh, only read %d bytes from file\n",readbytes);
    1104:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1107:	48 b9 d8 20 00 00 00 	movabs $0x20d8,%rcx
    110e:	00 00 00 
    1111:	89 c2                	mov    %eax,%edx
    1113:	48 89 ce             	mov    %rcx,%rsi
    1116:	bf 01 00 00 00       	mov    $0x1,%edi
    111b:	b8 00 00 00 00       	mov    $0x0,%eax
    1120:	48 b9 67 19 00 00 00 	movabs $0x1967,%rcx
    1127:	00 00 00 
    112a:	ff d1                	call   *%rcx
    }

    int wrotebytes = write(fd,buf,1000);
    112c:	48 8d 8d f0 fb ff ff 	lea    -0x410(%rbp),%rcx
    1133:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1136:	ba e8 03 00 00       	mov    $0x3e8,%edx
    113b:	48 89 ce             	mov    %rcx,%rsi
    113e:	89 c7                	mov    %eax,%edi
    1140:	48 b8 b4 16 00 00 00 	movabs $0x16b4,%rax
    1147:	00 00 00 
    114a:	ff d0                	call   *%rax
    114c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if(wrotebytes!=1000) {
    114f:	81 7d e4 e8 03 00 00 	cmpl   $0x3e8,-0x1c(%rbp)
    1156:	74 28                	je     1180 <main+0x180>
      printf(1,"Huh, only wrote %d bytes to display\n",wrotebytes);
    1158:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    115b:	48 b9 00 21 00 00 00 	movabs $0x2100,%rcx
    1162:	00 00 00 
    1165:	89 c2                	mov    %eax,%edx
    1167:	48 89 ce             	mov    %rcx,%rsi
    116a:	bf 01 00 00 00       	mov    $0x1,%edi
    116f:	b8 00 00 00 00       	mov    $0x0,%eax
    1174:	48 b9 67 19 00 00 00 	movabs $0x1967,%rcx
    117b:	00 00 00 
    117e:	ff d1                	call   *%rcx
  for(k=0;k<64;k++) {
    1180:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1184:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
    1188:	0f 8e 4a ff ff ff    	jle    10d8 <main+0xd8>
    }
  }

  sleep(100);
    118e:	bf 64 00 00 00       	mov    $0x64,%edi
    1193:	48 b8 6a 17 00 00 00 	movabs $0x176a,%rax
    119a:	00 00 00 
    119d:	ff d0                	call   *%rax

  int beats;
  for(beats=0;beats<4;beats++) {
    119f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    11a6:	e9 56 01 00 00       	jmp    1301 <main+0x301>

    int fade;
    for(fade=63;fade>0;fade-=3) {
    11ab:	c7 45 f4 3f 00 00 00 	movl   $0x3f,-0xc(%rbp)
    11b2:	eb 62                	jmp    1216 <main+0x216>

      // the value is a 32-bit struct containing (palette#, R, G, B)
      if(ioctl(fd,2,0x0f<<24 | 63 << 16 | fade << 8 | fade ) < 0) {
    11b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11b7:	c1 e0 08             	shl    $0x8,%eax
    11ba:	0d 00 00 3f 0f       	or     $0xf3f0000,%eax
    11bf:	0b 45 f4             	or     -0xc(%rbp),%eax
    11c2:	89 c2                	mov    %eax,%edx
    11c4:	8b 45 f0             	mov    -0x10(%rbp),%eax
    11c7:	be 02 00 00 00       	mov    $0x2,%esi
    11cc:	89 c7                	mov    %eax,%edi
    11ce:	48 b8 84 17 00 00 00 	movabs $0x1784,%rax
    11d5:	00 00 00 
    11d8:	ff d0                	call   *%rax
    11da:	85 c0                	test   %eax,%eax
    11dc:	79 23                	jns    1201 <main+0x201>
        printf(2,"Error setting palette color.\n");
    11de:	48 b8 25 21 00 00 00 	movabs $0x2125,%rax
    11e5:	00 00 00 
    11e8:	48 89 c6             	mov    %rax,%rsi
    11eb:	bf 02 00 00 00       	mov    $0x2,%edi
    11f0:	b8 00 00 00 00       	mov    $0x0,%eax
    11f5:	48 ba 67 19 00 00 00 	movabs $0x1967,%rdx
    11fc:	00 00 00 
    11ff:	ff d2                	call   *%rdx
      }
      sleep(1);
    1201:	bf 01 00 00 00       	mov    $0x1,%edi
    1206:	48 b8 6a 17 00 00 00 	movabs $0x176a,%rax
    120d:	00 00 00 
    1210:	ff d0                	call   *%rax
    for(fade=63;fade>0;fade-=3) {
    1212:	83 6d f4 03          	subl   $0x3,-0xc(%rbp)
    1216:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    121a:	7f 98                	jg     11b4 <main+0x1b4>
    }
    for(fade=0;fade<63;fade+=3) {
    121c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    1223:	eb 62                	jmp    1287 <main+0x287>
      if(ioctl(fd,2,0x0f<<24 | 63 << 16 | fade << 8 | fade ) < 0) {
    1225:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1228:	c1 e0 08             	shl    $0x8,%eax
    122b:	0d 00 00 3f 0f       	or     $0xf3f0000,%eax
    1230:	0b 45 f4             	or     -0xc(%rbp),%eax
    1233:	89 c2                	mov    %eax,%edx
    1235:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1238:	be 02 00 00 00       	mov    $0x2,%esi
    123d:	89 c7                	mov    %eax,%edi
    123f:	48 b8 84 17 00 00 00 	movabs $0x1784,%rax
    1246:	00 00 00 
    1249:	ff d0                	call   *%rax
    124b:	85 c0                	test   %eax,%eax
    124d:	79 23                	jns    1272 <main+0x272>
        printf(2,"Error setting palette color.\n");
    124f:	48 b8 25 21 00 00 00 	movabs $0x2125,%rax
    1256:	00 00 00 
    1259:	48 89 c6             	mov    %rax,%rsi
    125c:	bf 02 00 00 00       	mov    $0x2,%edi
    1261:	b8 00 00 00 00       	mov    $0x0,%eax
    1266:	48 ba 67 19 00 00 00 	movabs $0x1967,%rdx
    126d:	00 00 00 
    1270:	ff d2                	call   *%rdx
      }
      sleep(1);
    1272:	bf 01 00 00 00       	mov    $0x1,%edi
    1277:	48 b8 6a 17 00 00 00 	movabs $0x176a,%rax
    127e:	00 00 00 
    1281:	ff d0                	call   *%rax
    for(fade=0;fade<63;fade+=3) {
    1283:	83 45 f4 03          	addl   $0x3,-0xc(%rbp)
    1287:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%rbp)
    128b:	7e 98                	jle    1225 <main+0x225>
    }

    if(ioctl(fd,2,0x0f<<24 | 63 << 16 | 63 << 8 | 63 ) < 0) {
    128d:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1290:	ba 3f 3f 3f 0f       	mov    $0xf3f3f3f,%edx
    1295:	be 02 00 00 00       	mov    $0x2,%esi
    129a:	89 c7                	mov    %eax,%edi
    129c:	48 b8 84 17 00 00 00 	movabs $0x1784,%rax
    12a3:	00 00 00 
    12a6:	ff d0                	call   *%rax
    12a8:	85 c0                	test   %eax,%eax
    12aa:	79 23                	jns    12cf <main+0x2cf>
      printf(2,"Error setting palette color.\n");
    12ac:	48 b8 25 21 00 00 00 	movabs $0x2125,%rax
    12b3:	00 00 00 
    12b6:	48 89 c6             	mov    %rax,%rsi
    12b9:	bf 02 00 00 00       	mov    $0x2,%edi
    12be:	b8 00 00 00 00       	mov    $0x0,%eax
    12c3:	48 ba 67 19 00 00 00 	movabs $0x1967,%rdx
    12ca:	00 00 00 
    12cd:	ff d2                	call   *%rdx
    }

    if(beats%2)
    12cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
    12d2:	83 e0 01             	and    $0x1,%eax
    12d5:	85 c0                	test   %eax,%eax
    12d7:	74 13                	je     12ec <main+0x2ec>
      sleep(100);
    12d9:	bf 64 00 00 00       	mov    $0x64,%edi
    12de:	48 b8 6a 17 00 00 00 	movabs $0x176a,%rax
    12e5:	00 00 00 
    12e8:	ff d0                	call   *%rax
    12ea:	eb 11                	jmp    12fd <main+0x2fd>
    else
      sleep(10);
    12ec:	bf 0a 00 00 00       	mov    $0xa,%edi
    12f1:	48 b8 6a 17 00 00 00 	movabs $0x176a,%rax
    12f8:	00 00 00 
    12fb:	ff d0                	call   *%rax
  for(beats=0;beats<4;beats++) {
    12fd:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1301:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    1305:	0f 8e a0 fe ff ff    	jle    11ab <main+0x1ab>
  }

  // switch back to text
  if(ioctl(fd,1,0x3) < 0) {
    130b:	8b 45 f0             	mov    -0x10(%rbp),%eax
    130e:	ba 03 00 00 00       	mov    $0x3,%edx
    1313:	be 01 00 00 00       	mov    $0x1,%esi
    1318:	89 c7                	mov    %eax,%edi
    131a:	48 b8 84 17 00 00 00 	movabs $0x1784,%rax
    1321:	00 00 00 
    1324:	ff d0                	call   *%rax
    1326:	85 c0                	test   %eax,%eax
    1328:	79 2f                	jns    1359 <main+0x359>
    printf(2,"error: ioctl to restore screen to text failed.\n");
    132a:	48 b8 48 21 00 00 00 	movabs $0x2148,%rax
    1331:	00 00 00 
    1334:	48 89 c6             	mov    %rax,%rsi
    1337:	bf 02 00 00 00       	mov    $0x2,%edi
    133c:	b8 00 00 00 00       	mov    $0x0,%eax
    1341:	48 ba 67 19 00 00 00 	movabs $0x1967,%rdx
    1348:	00 00 00 
    134b:	ff d2                	call   *%rdx
    exit();
    134d:	48 b8 80 16 00 00 00 	movabs $0x1680,%rax
    1354:	00 00 00 
    1357:	ff d0                	call   *%rax
  }

  exit();
    1359:	48 b8 80 16 00 00 00 	movabs $0x1680,%rax
    1360:	00 00 00 
    1363:	ff d0                	call   *%rax

0000000000001365 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1365:	55                   	push   %rbp
    1366:	48 89 e5             	mov    %rsp,%rbp
    1369:	48 83 ec 10          	sub    $0x10,%rsp
    136d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1371:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1374:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    1377:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    137b:	8b 55 f0             	mov    -0x10(%rbp),%edx
    137e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1381:	48 89 ce             	mov    %rcx,%rsi
    1384:	48 89 f7             	mov    %rsi,%rdi
    1387:	89 d1                	mov    %edx,%ecx
    1389:	fc                   	cld
    138a:	f3 aa                	rep stos %al,(%rdi)
    138c:	89 ca                	mov    %ecx,%edx
    138e:	48 89 fe             	mov    %rdi,%rsi
    1391:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1395:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1398:	90                   	nop
    1399:	c9                   	leave
    139a:	c3                   	ret

000000000000139b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    139b:	55                   	push   %rbp
    139c:	48 89 e5             	mov    %rsp,%rbp
    139f:	48 83 ec 20          	sub    $0x20,%rsp
    13a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    13ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    13b3:	90                   	nop
    13b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    13b8:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13bc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    13c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c4:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13c8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    13cc:	0f b6 12             	movzbl (%rdx),%edx
    13cf:	88 10                	mov    %dl,(%rax)
    13d1:	0f b6 00             	movzbl (%rax),%eax
    13d4:	84 c0                	test   %al,%al
    13d6:	75 dc                	jne    13b4 <strcpy+0x19>
    ;
  return os;
    13d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    13dc:	c9                   	leave
    13dd:	c3                   	ret

00000000000013de <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13de:	55                   	push   %rbp
    13df:	48 89 e5             	mov    %rsp,%rbp
    13e2:	48 83 ec 10          	sub    $0x10,%rsp
    13e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    13ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    13ee:	eb 0a                	jmp    13fa <strcmp+0x1c>
    p++, q++;
    13f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    13f5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    13fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13fe:	0f b6 00             	movzbl (%rax),%eax
    1401:	84 c0                	test   %al,%al
    1403:	74 12                	je     1417 <strcmp+0x39>
    1405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1409:	0f b6 10             	movzbl (%rax),%edx
    140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1410:	0f b6 00             	movzbl (%rax),%eax
    1413:	38 c2                	cmp    %al,%dl
    1415:	74 d9                	je     13f0 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    1417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    141b:	0f b6 00             	movzbl (%rax),%eax
    141e:	0f b6 d0             	movzbl %al,%edx
    1421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1425:	0f b6 00             	movzbl (%rax),%eax
    1428:	0f b6 c0             	movzbl %al,%eax
    142b:	29 c2                	sub    %eax,%edx
    142d:	89 d0                	mov    %edx,%eax
}
    142f:	c9                   	leave
    1430:	c3                   	ret

0000000000001431 <strlen>:

uint
strlen(char *s)
{
    1431:	55                   	push   %rbp
    1432:	48 89 e5             	mov    %rsp,%rbp
    1435:	48 83 ec 18          	sub    $0x18,%rsp
    1439:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    143d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1444:	eb 04                	jmp    144a <strlen+0x19>
    1446:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    144a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    144d:	48 63 d0             	movslq %eax,%rdx
    1450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1454:	48 01 d0             	add    %rdx,%rax
    1457:	0f b6 00             	movzbl (%rax),%eax
    145a:	84 c0                	test   %al,%al
    145c:	75 e8                	jne    1446 <strlen+0x15>
    ;
  return n;
    145e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1461:	c9                   	leave
    1462:	c3                   	ret

0000000000001463 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1463:	55                   	push   %rbp
    1464:	48 89 e5             	mov    %rsp,%rbp
    1467:	48 83 ec 10          	sub    $0x10,%rsp
    146b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    146f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1472:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1475:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1478:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    147b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    147f:	89 ce                	mov    %ecx,%esi
    1481:	48 89 c7             	mov    %rax,%rdi
    1484:	48 b8 65 13 00 00 00 	movabs $0x1365,%rax
    148b:	00 00 00 
    148e:	ff d0                	call   *%rax
  return dst;
    1490:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1494:	c9                   	leave
    1495:	c3                   	ret

0000000000001496 <strchr>:

char*
strchr(const char *s, char c)
{
    1496:	55                   	push   %rbp
    1497:	48 89 e5             	mov    %rsp,%rbp
    149a:	48 83 ec 10          	sub    $0x10,%rsp
    149e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    14a2:	89 f0                	mov    %esi,%eax
    14a4:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    14a7:	eb 17                	jmp    14c0 <strchr+0x2a>
    if(*s == c)
    14a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14ad:	0f b6 00             	movzbl (%rax),%eax
    14b0:	38 45 f4             	cmp    %al,-0xc(%rbp)
    14b3:	75 06                	jne    14bb <strchr+0x25>
      return (char*)s;
    14b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14b9:	eb 15                	jmp    14d0 <strchr+0x3a>
  for(; *s; s++)
    14bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    14c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14c4:	0f b6 00             	movzbl (%rax),%eax
    14c7:	84 c0                	test   %al,%al
    14c9:	75 de                	jne    14a9 <strchr+0x13>
  return 0;
    14cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    14d0:	c9                   	leave
    14d1:	c3                   	ret

00000000000014d2 <gets>:

char*
gets(char *buf, int max)
{
    14d2:	55                   	push   %rbp
    14d3:	48 89 e5             	mov    %rsp,%rbp
    14d6:	48 83 ec 20          	sub    $0x20,%rsp
    14da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14de:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    14e8:	eb 4f                	jmp    1539 <gets+0x67>
    cc = read(0, &c, 1);
    14ea:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    14ee:	ba 01 00 00 00       	mov    $0x1,%edx
    14f3:	48 89 c6             	mov    %rax,%rsi
    14f6:	bf 00 00 00 00       	mov    $0x0,%edi
    14fb:	48 b8 a7 16 00 00 00 	movabs $0x16a7,%rax
    1502:	00 00 00 
    1505:	ff d0                	call   *%rax
    1507:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    150a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    150e:	7e 36                	jle    1546 <gets+0x74>
      break;
    buf[i++] = c;
    1510:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1513:	8d 50 01             	lea    0x1(%rax),%edx
    1516:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1519:	48 63 d0             	movslq %eax,%rdx
    151c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1520:	48 01 c2             	add    %rax,%rdx
    1523:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1527:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1529:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    152d:	3c 0a                	cmp    $0xa,%al
    152f:	74 16                	je     1547 <gets+0x75>
    1531:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1535:	3c 0d                	cmp    $0xd,%al
    1537:	74 0e                	je     1547 <gets+0x75>
  for(i=0; i+1 < max; ){
    1539:	8b 45 fc             	mov    -0x4(%rbp),%eax
    153c:	83 c0 01             	add    $0x1,%eax
    153f:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1542:	7f a6                	jg     14ea <gets+0x18>
    1544:	eb 01                	jmp    1547 <gets+0x75>
      break;
    1546:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1547:	8b 45 fc             	mov    -0x4(%rbp),%eax
    154a:	48 63 d0             	movslq %eax,%rdx
    154d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1551:	48 01 d0             	add    %rdx,%rax
    1554:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    155b:	c9                   	leave
    155c:	c3                   	ret

000000000000155d <stat>:

int
stat(char *n, struct stat *st)
{
    155d:	55                   	push   %rbp
    155e:	48 89 e5             	mov    %rsp,%rbp
    1561:	48 83 ec 20          	sub    $0x20,%rsp
    1565:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1569:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1571:	be 00 00 00 00       	mov    $0x0,%esi
    1576:	48 89 c7             	mov    %rax,%rdi
    1579:	48 b8 e8 16 00 00 00 	movabs $0x16e8,%rax
    1580:	00 00 00 
    1583:	ff d0                	call   *%rax
    1585:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1588:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    158c:	79 07                	jns    1595 <stat+0x38>
    return -1;
    158e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1593:	eb 2f                	jmp    15c4 <stat+0x67>
  r = fstat(fd, st);
    1595:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1599:	8b 45 fc             	mov    -0x4(%rbp),%eax
    159c:	48 89 d6             	mov    %rdx,%rsi
    159f:	89 c7                	mov    %eax,%edi
    15a1:	48 b8 0f 17 00 00 00 	movabs $0x170f,%rax
    15a8:	00 00 00 
    15ab:	ff d0                	call   *%rax
    15ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    15b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15b3:	89 c7                	mov    %eax,%edi
    15b5:	48 b8 c1 16 00 00 00 	movabs $0x16c1,%rax
    15bc:	00 00 00 
    15bf:	ff d0                	call   *%rax
  return r;
    15c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    15c4:	c9                   	leave
    15c5:	c3                   	ret

00000000000015c6 <atoi>:

int
atoi(const char *s)
{
    15c6:	55                   	push   %rbp
    15c7:	48 89 e5             	mov    %rsp,%rbp
    15ca:	48 83 ec 18          	sub    $0x18,%rsp
    15ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    15d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    15d9:	eb 28                	jmp    1603 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    15db:	8b 55 fc             	mov    -0x4(%rbp),%edx
    15de:	89 d0                	mov    %edx,%eax
    15e0:	c1 e0 02             	shl    $0x2,%eax
    15e3:	01 d0                	add    %edx,%eax
    15e5:	01 c0                	add    %eax,%eax
    15e7:	89 c1                	mov    %eax,%ecx
    15e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
    15f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    15f5:	0f b6 00             	movzbl (%rax),%eax
    15f8:	0f be c0             	movsbl %al,%eax
    15fb:	01 c8                	add    %ecx,%eax
    15fd:	83 e8 30             	sub    $0x30,%eax
    1600:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1607:	0f b6 00             	movzbl (%rax),%eax
    160a:	3c 2f                	cmp    $0x2f,%al
    160c:	7e 0b                	jle    1619 <atoi+0x53>
    160e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1612:	0f b6 00             	movzbl (%rax),%eax
    1615:	3c 39                	cmp    $0x39,%al
    1617:	7e c2                	jle    15db <atoi+0x15>
  return n;
    1619:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    161c:	c9                   	leave
    161d:	c3                   	ret

000000000000161e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    161e:	55                   	push   %rbp
    161f:	48 89 e5             	mov    %rsp,%rbp
    1622:	48 83 ec 28          	sub    $0x28,%rsp
    1626:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    162a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    162e:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1635:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1639:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    163d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1641:	eb 1d                	jmp    1660 <memmove+0x42>
    *dst++ = *src++;
    1643:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1647:	48 8d 42 01          	lea    0x1(%rdx),%rax
    164b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    164f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1653:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1657:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    165b:	0f b6 12             	movzbl (%rdx),%edx
    165e:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1660:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1663:	8d 50 ff             	lea    -0x1(%rax),%edx
    1666:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1669:	85 c0                	test   %eax,%eax
    166b:	7f d6                	jg     1643 <memmove+0x25>
  return vdst;
    166d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1671:	c9                   	leave
    1672:	c3                   	ret

0000000000001673 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1673:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    167a:	49 89 ca             	mov    %rcx,%r10
    167d:	0f 05                	syscall
    167f:	c3                   	ret

0000000000001680 <exit>:
SYSCALL(exit)
    1680:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1687:	49 89 ca             	mov    %rcx,%r10
    168a:	0f 05                	syscall
    168c:	c3                   	ret

000000000000168d <wait>:
SYSCALL(wait)
    168d:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1694:	49 89 ca             	mov    %rcx,%r10
    1697:	0f 05                	syscall
    1699:	c3                   	ret

000000000000169a <pipe>:
SYSCALL(pipe)
    169a:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    16a1:	49 89 ca             	mov    %rcx,%r10
    16a4:	0f 05                	syscall
    16a6:	c3                   	ret

00000000000016a7 <read>:
SYSCALL(read)
    16a7:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    16ae:	49 89 ca             	mov    %rcx,%r10
    16b1:	0f 05                	syscall
    16b3:	c3                   	ret

00000000000016b4 <write>:
SYSCALL(write)
    16b4:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    16bb:	49 89 ca             	mov    %rcx,%r10
    16be:	0f 05                	syscall
    16c0:	c3                   	ret

00000000000016c1 <close>:
SYSCALL(close)
    16c1:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    16c8:	49 89 ca             	mov    %rcx,%r10
    16cb:	0f 05                	syscall
    16cd:	c3                   	ret

00000000000016ce <kill>:
SYSCALL(kill)
    16ce:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    16d5:	49 89 ca             	mov    %rcx,%r10
    16d8:	0f 05                	syscall
    16da:	c3                   	ret

00000000000016db <exec>:
SYSCALL(exec)
    16db:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    16e2:	49 89 ca             	mov    %rcx,%r10
    16e5:	0f 05                	syscall
    16e7:	c3                   	ret

00000000000016e8 <open>:
SYSCALL(open)
    16e8:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    16ef:	49 89 ca             	mov    %rcx,%r10
    16f2:	0f 05                	syscall
    16f4:	c3                   	ret

00000000000016f5 <mknod>:
SYSCALL(mknod)
    16f5:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    16fc:	49 89 ca             	mov    %rcx,%r10
    16ff:	0f 05                	syscall
    1701:	c3                   	ret

0000000000001702 <unlink>:
SYSCALL(unlink)
    1702:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1709:	49 89 ca             	mov    %rcx,%r10
    170c:	0f 05                	syscall
    170e:	c3                   	ret

000000000000170f <fstat>:
SYSCALL(fstat)
    170f:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1716:	49 89 ca             	mov    %rcx,%r10
    1719:	0f 05                	syscall
    171b:	c3                   	ret

000000000000171c <link>:
SYSCALL(link)
    171c:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1723:	49 89 ca             	mov    %rcx,%r10
    1726:	0f 05                	syscall
    1728:	c3                   	ret

0000000000001729 <mkdir>:
SYSCALL(mkdir)
    1729:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1730:	49 89 ca             	mov    %rcx,%r10
    1733:	0f 05                	syscall
    1735:	c3                   	ret

0000000000001736 <chdir>:
SYSCALL(chdir)
    1736:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    173d:	49 89 ca             	mov    %rcx,%r10
    1740:	0f 05                	syscall
    1742:	c3                   	ret

0000000000001743 <dup>:
SYSCALL(dup)
    1743:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    174a:	49 89 ca             	mov    %rcx,%r10
    174d:	0f 05                	syscall
    174f:	c3                   	ret

0000000000001750 <getpid>:
SYSCALL(getpid)
    1750:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1757:	49 89 ca             	mov    %rcx,%r10
    175a:	0f 05                	syscall
    175c:	c3                   	ret

000000000000175d <sbrk>:
SYSCALL(sbrk)
    175d:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1764:	49 89 ca             	mov    %rcx,%r10
    1767:	0f 05                	syscall
    1769:	c3                   	ret

000000000000176a <sleep>:
SYSCALL(sleep)
    176a:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1771:	49 89 ca             	mov    %rcx,%r10
    1774:	0f 05                	syscall
    1776:	c3                   	ret

0000000000001777 <uptime>:
SYSCALL(uptime)
    1777:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    177e:	49 89 ca             	mov    %rcx,%r10
    1781:	0f 05                	syscall
    1783:	c3                   	ret

0000000000001784 <ioctl>:
SYSCALL(ioctl)
    1784:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    178b:	49 89 ca             	mov    %rcx,%r10
    178e:	0f 05                	syscall
    1790:	c3                   	ret

0000000000001791 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1791:	55                   	push   %rbp
    1792:	48 89 e5             	mov    %rsp,%rbp
    1795:	48 83 ec 10          	sub    $0x10,%rsp
    1799:	89 7d fc             	mov    %edi,-0x4(%rbp)
    179c:	89 f0                	mov    %esi,%eax
    179e:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    17a1:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    17a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    17a8:	ba 01 00 00 00       	mov    $0x1,%edx
    17ad:	48 89 ce             	mov    %rcx,%rsi
    17b0:	89 c7                	mov    %eax,%edi
    17b2:	48 b8 b4 16 00 00 00 	movabs $0x16b4,%rax
    17b9:	00 00 00 
    17bc:	ff d0                	call   *%rax
}
    17be:	90                   	nop
    17bf:	c9                   	leave
    17c0:	c3                   	ret

00000000000017c1 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    17c1:	55                   	push   %rbp
    17c2:	48 89 e5             	mov    %rsp,%rbp
    17c5:	48 83 ec 20          	sub    $0x20,%rsp
    17c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
    17cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    17d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    17d7:	eb 35                	jmp    180e <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    17d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17dd:	48 c1 e8 3c          	shr    $0x3c,%rax
    17e1:	48 ba 80 21 00 00 00 	movabs $0x2180,%rdx
    17e8:	00 00 00 
    17eb:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    17ef:	0f be d0             	movsbl %al,%edx
    17f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    17f5:	89 d6                	mov    %edx,%esi
    17f7:	89 c7                	mov    %eax,%edi
    17f9:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1800:	00 00 00 
    1803:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1805:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1809:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    180e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1811:	83 f8 0f             	cmp    $0xf,%eax
    1814:	76 c3                	jbe    17d9 <print_x64+0x18>
}
    1816:	90                   	nop
    1817:	90                   	nop
    1818:	c9                   	leave
    1819:	c3                   	ret

000000000000181a <print_x32>:

  static void
print_x32(int fd, uint x)
{
    181a:	55                   	push   %rbp
    181b:	48 89 e5             	mov    %rsp,%rbp
    181e:	48 83 ec 20          	sub    $0x20,%rsp
    1822:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1825:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1828:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    182f:	eb 36                	jmp    1867 <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1831:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1834:	c1 e8 1c             	shr    $0x1c,%eax
    1837:	89 c2                	mov    %eax,%edx
    1839:	48 b8 80 21 00 00 00 	movabs $0x2180,%rax
    1840:	00 00 00 
    1843:	89 d2                	mov    %edx,%edx
    1845:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1849:	0f be d0             	movsbl %al,%edx
    184c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    184f:	89 d6                	mov    %edx,%esi
    1851:	89 c7                	mov    %eax,%edi
    1853:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    185a:	00 00 00 
    185d:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    185f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1863:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1867:	8b 45 fc             	mov    -0x4(%rbp),%eax
    186a:	83 f8 07             	cmp    $0x7,%eax
    186d:	76 c2                	jbe    1831 <print_x32+0x17>
}
    186f:	90                   	nop
    1870:	90                   	nop
    1871:	c9                   	leave
    1872:	c3                   	ret

0000000000001873 <print_d>:

  static void
print_d(int fd, int v)
{
    1873:	55                   	push   %rbp
    1874:	48 89 e5             	mov    %rsp,%rbp
    1877:	48 83 ec 30          	sub    $0x30,%rsp
    187b:	89 7d dc             	mov    %edi,-0x24(%rbp)
    187e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1881:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1884:	48 98                	cltq
    1886:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    188a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    188e:	79 04                	jns    1894 <print_d+0x21>
    x = -x;
    1890:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    189b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    189f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    18a6:	66 66 66 
    18a9:	48 89 c8             	mov    %rcx,%rax
    18ac:	48 f7 ea             	imul   %rdx
    18af:	48 c1 fa 02          	sar    $0x2,%rdx
    18b3:	48 89 c8             	mov    %rcx,%rax
    18b6:	48 c1 f8 3f          	sar    $0x3f,%rax
    18ba:	48 29 c2             	sub    %rax,%rdx
    18bd:	48 89 d0             	mov    %rdx,%rax
    18c0:	48 c1 e0 02          	shl    $0x2,%rax
    18c4:	48 01 d0             	add    %rdx,%rax
    18c7:	48 01 c0             	add    %rax,%rax
    18ca:	48 29 c1             	sub    %rax,%rcx
    18cd:	48 89 ca             	mov    %rcx,%rdx
    18d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    18d3:	8d 48 01             	lea    0x1(%rax),%ecx
    18d6:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    18d9:	48 b9 80 21 00 00 00 	movabs $0x2180,%rcx
    18e0:	00 00 00 
    18e3:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    18e7:	48 98                	cltq
    18e9:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    18ed:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    18f1:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    18f8:	66 66 66 
    18fb:	48 89 c8             	mov    %rcx,%rax
    18fe:	48 f7 ea             	imul   %rdx
    1901:	48 89 d0             	mov    %rdx,%rax
    1904:	48 c1 f8 02          	sar    $0x2,%rax
    1908:	48 c1 f9 3f          	sar    $0x3f,%rcx
    190c:	48 89 ca             	mov    %rcx,%rdx
    190f:	48 29 d0             	sub    %rdx,%rax
    1912:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1916:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    191b:	0f 85 7a ff ff ff    	jne    189b <print_d+0x28>

  if (v < 0)
    1921:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1925:	79 32                	jns    1959 <print_d+0xe6>
    buf[i++] = '-';
    1927:	8b 45 f4             	mov    -0xc(%rbp),%eax
    192a:	8d 50 01             	lea    0x1(%rax),%edx
    192d:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1930:	48 98                	cltq
    1932:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1937:	eb 20                	jmp    1959 <print_d+0xe6>
    putc(fd, buf[i]);
    1939:	8b 45 f4             	mov    -0xc(%rbp),%eax
    193c:	48 98                	cltq
    193e:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1943:	0f be d0             	movsbl %al,%edx
    1946:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1949:	89 d6                	mov    %edx,%esi
    194b:	89 c7                	mov    %eax,%edi
    194d:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1954:	00 00 00 
    1957:	ff d0                	call   *%rax
  while (--i >= 0)
    1959:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    195d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1961:	79 d6                	jns    1939 <print_d+0xc6>
}
    1963:	90                   	nop
    1964:	90                   	nop
    1965:	c9                   	leave
    1966:	c3                   	ret

0000000000001967 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1967:	55                   	push   %rbp
    1968:	48 89 e5             	mov    %rsp,%rbp
    196b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1972:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1978:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    197f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1986:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    198d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1994:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    199b:	84 c0                	test   %al,%al
    199d:	74 20                	je     19bf <printf+0x58>
    199f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    19a3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    19a7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    19ab:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    19af:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    19b3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    19b7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    19bb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    19bf:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    19c6:	00 00 00 
    19c9:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    19d0:	00 00 00 
    19d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
    19d7:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    19de:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    19e5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    19ec:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    19f3:	00 00 00 
    19f6:	e9 60 03 00 00       	jmp    1d5b <printf+0x3f4>
    if (c != '%') {
    19fb:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1a02:	74 24                	je     1a28 <printf+0xc1>
      putc(fd, c);
    1a04:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a0a:	0f be d0             	movsbl %al,%edx
    1a0d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a13:	89 d6                	mov    %edx,%esi
    1a15:	89 c7                	mov    %eax,%edi
    1a17:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1a1e:	00 00 00 
    1a21:	ff d0                	call   *%rax
      continue;
    1a23:	e9 2c 03 00 00       	jmp    1d54 <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1a28:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a2f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a35:	48 63 d0             	movslq %eax,%rdx
    1a38:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1a3f:	48 01 d0             	add    %rdx,%rax
    1a42:	0f b6 00             	movzbl (%rax),%eax
    1a45:	0f be c0             	movsbl %al,%eax
    1a48:	25 ff 00 00 00       	and    $0xff,%eax
    1a4d:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1a53:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1a5a:	0f 84 2e 03 00 00    	je     1d8e <printf+0x427>
      break;
    switch(c) {
    1a60:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1a67:	0f 84 32 01 00 00    	je     1b9f <printf+0x238>
    1a6d:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1a74:	0f 8f a1 02 00 00    	jg     1d1b <printf+0x3b4>
    1a7a:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1a81:	0f 84 d4 01 00 00    	je     1c5b <printf+0x2f4>
    1a87:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1a8e:	0f 8f 87 02 00 00    	jg     1d1b <printf+0x3b4>
    1a94:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1a9b:	0f 84 5b 01 00 00    	je     1bfc <printf+0x295>
    1aa1:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1aa8:	0f 8f 6d 02 00 00    	jg     1d1b <printf+0x3b4>
    1aae:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1ab5:	0f 84 87 00 00 00    	je     1b42 <printf+0x1db>
    1abb:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1ac2:	0f 8f 53 02 00 00    	jg     1d1b <printf+0x3b4>
    1ac8:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1acf:	0f 84 2b 02 00 00    	je     1d00 <printf+0x399>
    1ad5:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1adc:	0f 85 39 02 00 00    	jne    1d1b <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1ae2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ae8:	83 f8 2f             	cmp    $0x2f,%eax
    1aeb:	77 23                	ja     1b10 <printf+0x1a9>
    1aed:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1af4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1afa:	89 d2                	mov    %edx,%edx
    1afc:	48 01 d0             	add    %rdx,%rax
    1aff:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b05:	83 c2 08             	add    $0x8,%edx
    1b08:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b0e:	eb 12                	jmp    1b22 <printf+0x1bb>
    1b10:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b17:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b1b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b22:	8b 00                	mov    (%rax),%eax
    1b24:	0f be d0             	movsbl %al,%edx
    1b27:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b2d:	89 d6                	mov    %edx,%esi
    1b2f:	89 c7                	mov    %eax,%edi
    1b31:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1b38:	00 00 00 
    1b3b:	ff d0                	call   *%rax
      break;
    1b3d:	e9 12 02 00 00       	jmp    1d54 <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1b42:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1b48:	83 f8 2f             	cmp    $0x2f,%eax
    1b4b:	77 23                	ja     1b70 <printf+0x209>
    1b4d:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1b54:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b5a:	89 d2                	mov    %edx,%edx
    1b5c:	48 01 d0             	add    %rdx,%rax
    1b5f:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1b65:	83 c2 08             	add    $0x8,%edx
    1b68:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1b6e:	eb 12                	jmp    1b82 <printf+0x21b>
    1b70:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b77:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b7b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b82:	8b 10                	mov    (%rax),%edx
    1b84:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b8a:	89 d6                	mov    %edx,%esi
    1b8c:	89 c7                	mov    %eax,%edi
    1b8e:	48 b8 73 18 00 00 00 	movabs $0x1873,%rax
    1b95:	00 00 00 
    1b98:	ff d0                	call   *%rax
      break;
    1b9a:	e9 b5 01 00 00       	jmp    1d54 <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1b9f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ba5:	83 f8 2f             	cmp    $0x2f,%eax
    1ba8:	77 23                	ja     1bcd <printf+0x266>
    1baa:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1bb1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1bb7:	89 d2                	mov    %edx,%edx
    1bb9:	48 01 d0             	add    %rdx,%rax
    1bbc:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1bc2:	83 c2 08             	add    $0x8,%edx
    1bc5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1bcb:	eb 12                	jmp    1bdf <printf+0x278>
    1bcd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1bd4:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1bd8:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1bdf:	8b 10                	mov    (%rax),%edx
    1be1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1be7:	89 d6                	mov    %edx,%esi
    1be9:	89 c7                	mov    %eax,%edi
    1beb:	48 b8 1a 18 00 00 00 	movabs $0x181a,%rax
    1bf2:	00 00 00 
    1bf5:	ff d0                	call   *%rax
      break;
    1bf7:	e9 58 01 00 00       	jmp    1d54 <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1bfc:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c02:	83 f8 2f             	cmp    $0x2f,%eax
    1c05:	77 23                	ja     1c2a <printf+0x2c3>
    1c07:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c0e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c14:	89 d2                	mov    %edx,%edx
    1c16:	48 01 d0             	add    %rdx,%rax
    1c19:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c1f:	83 c2 08             	add    $0x8,%edx
    1c22:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c28:	eb 12                	jmp    1c3c <printf+0x2d5>
    1c2a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c31:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c35:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c3c:	48 8b 10             	mov    (%rax),%rdx
    1c3f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c45:	48 89 d6             	mov    %rdx,%rsi
    1c48:	89 c7                	mov    %eax,%edi
    1c4a:	48 b8 c1 17 00 00 00 	movabs $0x17c1,%rax
    1c51:	00 00 00 
    1c54:	ff d0                	call   *%rax
      break;
    1c56:	e9 f9 00 00 00       	jmp    1d54 <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1c5b:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c61:	83 f8 2f             	cmp    $0x2f,%eax
    1c64:	77 23                	ja     1c89 <printf+0x322>
    1c66:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c6d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c73:	89 d2                	mov    %edx,%edx
    1c75:	48 01 d0             	add    %rdx,%rax
    1c78:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c7e:	83 c2 08             	add    $0x8,%edx
    1c81:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c87:	eb 12                	jmp    1c9b <printf+0x334>
    1c89:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c90:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c94:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c9b:	48 8b 00             	mov    (%rax),%rax
    1c9e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1ca5:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1cac:	00 
    1cad:	75 41                	jne    1cf0 <printf+0x389>
        s = "(null)";
    1caf:	48 b8 78 21 00 00 00 	movabs $0x2178,%rax
    1cb6:	00 00 00 
    1cb9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1cc0:	eb 2e                	jmp    1cf0 <printf+0x389>
        putc(fd, *(s++));
    1cc2:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1cc9:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1ccd:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1cd4:	0f b6 00             	movzbl (%rax),%eax
    1cd7:	0f be d0             	movsbl %al,%edx
    1cda:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ce0:	89 d6                	mov    %edx,%esi
    1ce2:	89 c7                	mov    %eax,%edi
    1ce4:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1ceb:	00 00 00 
    1cee:	ff d0                	call   *%rax
      while (*s)
    1cf0:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1cf7:	0f b6 00             	movzbl (%rax),%eax
    1cfa:	84 c0                	test   %al,%al
    1cfc:	75 c4                	jne    1cc2 <printf+0x35b>
      break;
    1cfe:	eb 54                	jmp    1d54 <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1d00:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d06:	be 25 00 00 00       	mov    $0x25,%esi
    1d0b:	89 c7                	mov    %eax,%edi
    1d0d:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1d14:	00 00 00 
    1d17:	ff d0                	call   *%rax
      break;
    1d19:	eb 39                	jmp    1d54 <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1d1b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d21:	be 25 00 00 00       	mov    $0x25,%esi
    1d26:	89 c7                	mov    %eax,%edi
    1d28:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1d2f:	00 00 00 
    1d32:	ff d0                	call   *%rax
      putc(fd, c);
    1d34:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1d3a:	0f be d0             	movsbl %al,%edx
    1d3d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d43:	89 d6                	mov    %edx,%esi
    1d45:	89 c7                	mov    %eax,%edi
    1d47:	48 b8 91 17 00 00 00 	movabs $0x1791,%rax
    1d4e:	00 00 00 
    1d51:	ff d0                	call   *%rax
      break;
    1d53:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1d54:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1d5b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1d61:	48 63 d0             	movslq %eax,%rdx
    1d64:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1d6b:	48 01 d0             	add    %rdx,%rax
    1d6e:	0f b6 00             	movzbl (%rax),%eax
    1d71:	0f be c0             	movsbl %al,%eax
    1d74:	25 ff 00 00 00       	and    $0xff,%eax
    1d79:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1d7f:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1d86:	0f 85 6f fc ff ff    	jne    19fb <printf+0x94>
    }
  }
}
    1d8c:	eb 01                	jmp    1d8f <printf+0x428>
      break;
    1d8e:	90                   	nop
}
    1d8f:	90                   	nop
    1d90:	c9                   	leave
    1d91:	c3                   	ret

0000000000001d92 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1d92:	55                   	push   %rbp
    1d93:	48 89 e5             	mov    %rsp,%rbp
    1d96:	48 83 ec 18          	sub    $0x18,%rsp
    1d9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1da2:	48 83 e8 10          	sub    $0x10,%rax
    1da6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1daa:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1db1:	00 00 00 
    1db4:	48 8b 00             	mov    (%rax),%rax
    1db7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dbb:	eb 2f                	jmp    1dec <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dc1:	48 8b 00             	mov    (%rax),%rax
    1dc4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dc8:	72 17                	jb     1de1 <free+0x4f>
    1dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1dce:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1dd2:	72 2f                	jb     1e03 <free+0x71>
    1dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd8:	48 8b 00             	mov    (%rax),%rax
    1ddb:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ddf:	72 22                	jb     1e03 <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1de5:	48 8b 00             	mov    (%rax),%rax
    1de8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1df0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1df4:	73 c7                	jae    1dbd <free+0x2b>
    1df6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dfa:	48 8b 00             	mov    (%rax),%rax
    1dfd:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1e01:	73 ba                	jae    1dbd <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e07:	8b 40 08             	mov    0x8(%rax),%eax
    1e0a:	89 c0                	mov    %eax,%eax
    1e0c:	48 c1 e0 04          	shl    $0x4,%rax
    1e10:	48 89 c2             	mov    %rax,%rdx
    1e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e17:	48 01 c2             	add    %rax,%rdx
    1e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e1e:	48 8b 00             	mov    (%rax),%rax
    1e21:	48 39 c2             	cmp    %rax,%rdx
    1e24:	75 2d                	jne    1e53 <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e2a:	8b 50 08             	mov    0x8(%rax),%edx
    1e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e31:	48 8b 00             	mov    (%rax),%rax
    1e34:	8b 40 08             	mov    0x8(%rax),%eax
    1e37:	01 c2                	add    %eax,%edx
    1e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e3d:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e44:	48 8b 00             	mov    (%rax),%rax
    1e47:	48 8b 10             	mov    (%rax),%rdx
    1e4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e4e:	48 89 10             	mov    %rdx,(%rax)
    1e51:	eb 0e                	jmp    1e61 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e57:	48 8b 10             	mov    (%rax),%rdx
    1e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e5e:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e65:	8b 40 08             	mov    0x8(%rax),%eax
    1e68:	89 c0                	mov    %eax,%eax
    1e6a:	48 c1 e0 04          	shl    $0x4,%rax
    1e6e:	48 89 c2             	mov    %rax,%rdx
    1e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e75:	48 01 d0             	add    %rdx,%rax
    1e78:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1e7c:	75 27                	jne    1ea5 <free+0x113>
    p->s.size += bp->s.size;
    1e7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e82:	8b 50 08             	mov    0x8(%rax),%edx
    1e85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e89:	8b 40 08             	mov    0x8(%rax),%eax
    1e8c:	01 c2                	add    %eax,%edx
    1e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e92:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1e95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e99:	48 8b 10             	mov    (%rax),%rdx
    1e9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea0:	48 89 10             	mov    %rdx,(%rax)
    1ea3:	eb 0b                	jmp    1eb0 <free+0x11e>
  } else
    p->s.ptr = bp;
    1ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1ead:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1eb0:	48 ba b0 21 00 00 00 	movabs $0x21b0,%rdx
    1eb7:	00 00 00 
    1eba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ebe:	48 89 02             	mov    %rax,(%rdx)
}
    1ec1:	90                   	nop
    1ec2:	c9                   	leave
    1ec3:	c3                   	ret

0000000000001ec4 <morecore>:

static Header*
morecore(uint nu)
{
    1ec4:	55                   	push   %rbp
    1ec5:	48 89 e5             	mov    %rsp,%rbp
    1ec8:	48 83 ec 20          	sub    $0x20,%rsp
    1ecc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1ecf:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1ed6:	77 07                	ja     1edf <morecore+0x1b>
    nu = 4096;
    1ed8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1edf:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ee2:	48 c1 e0 04          	shl    $0x4,%rax
    1ee6:	48 89 c7             	mov    %rax,%rdi
    1ee9:	48 b8 5d 17 00 00 00 	movabs $0x175d,%rax
    1ef0:	00 00 00 
    1ef3:	ff d0                	call   *%rax
    1ef5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1ef9:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1efe:	75 07                	jne    1f07 <morecore+0x43>
    return 0;
    1f00:	b8 00 00 00 00       	mov    $0x0,%eax
    1f05:	eb 36                	jmp    1f3d <morecore+0x79>
  hp = (Header*)p;
    1f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f0b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f13:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1f16:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f1d:	48 83 c0 10          	add    $0x10,%rax
    1f21:	48 89 c7             	mov    %rax,%rdi
    1f24:	48 b8 92 1d 00 00 00 	movabs $0x1d92,%rax
    1f2b:	00 00 00 
    1f2e:	ff d0                	call   *%rax
  return freep;
    1f30:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1f37:	00 00 00 
    1f3a:	48 8b 00             	mov    (%rax),%rax
}
    1f3d:	c9                   	leave
    1f3e:	c3                   	ret

0000000000001f3f <malloc>:

void*
malloc(uint nbytes)
{
    1f3f:	55                   	push   %rbp
    1f40:	48 89 e5             	mov    %rsp,%rbp
    1f43:	48 83 ec 30          	sub    $0x30,%rsp
    1f47:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1f4a:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1f4d:	48 83 c0 0f          	add    $0xf,%rax
    1f51:	48 c1 e8 04          	shr    $0x4,%rax
    1f55:	83 c0 01             	add    $0x1,%eax
    1f58:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1f5b:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1f62:	00 00 00 
    1f65:	48 8b 00             	mov    (%rax),%rax
    1f68:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f6c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1f71:	75 4a                	jne    1fbd <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    1f73:	48 b8 a0 21 00 00 00 	movabs $0x21a0,%rax
    1f7a:	00 00 00 
    1f7d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1f81:	48 ba b0 21 00 00 00 	movabs $0x21b0,%rdx
    1f88:	00 00 00 
    1f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f8f:	48 89 02             	mov    %rax,(%rdx)
    1f92:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    1f99:	00 00 00 
    1f9c:	48 8b 00             	mov    (%rax),%rax
    1f9f:	48 ba a0 21 00 00 00 	movabs $0x21a0,%rdx
    1fa6:	00 00 00 
    1fa9:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1fac:	48 b8 a0 21 00 00 00 	movabs $0x21a0,%rax
    1fb3:	00 00 00 
    1fb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fc1:	48 8b 00             	mov    (%rax),%rax
    1fc4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fcc:	8b 40 08             	mov    0x8(%rax),%eax
    1fcf:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1fd2:	72 65                	jb     2039 <malloc+0xfa>
      if(p->s.size == nunits)
    1fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd8:	8b 40 08             	mov    0x8(%rax),%eax
    1fdb:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1fde:	75 10                	jne    1ff0 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    1fe0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe4:	48 8b 10             	mov    (%rax),%rdx
    1fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1feb:	48 89 10             	mov    %rdx,(%rax)
    1fee:	eb 2e                	jmp    201e <malloc+0xdf>
      else {
        p->s.size -= nunits;
    1ff0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff4:	8b 40 08             	mov    0x8(%rax),%eax
    1ff7:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1ffa:	89 c2                	mov    %eax,%edx
    1ffc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2000:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2007:	8b 40 08             	mov    0x8(%rax),%eax
    200a:	89 c0                	mov    %eax,%eax
    200c:	48 c1 e0 04          	shl    $0x4,%rax
    2010:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2018:	8b 55 ec             	mov    -0x14(%rbp),%edx
    201b:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    201e:	48 ba b0 21 00 00 00 	movabs $0x21b0,%rdx
    2025:	00 00 00 
    2028:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    202c:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    202f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2033:	48 83 c0 10          	add    $0x10,%rax
    2037:	eb 4e                	jmp    2087 <malloc+0x148>
    }
    if(p == freep)
    2039:	48 b8 b0 21 00 00 00 	movabs $0x21b0,%rax
    2040:	00 00 00 
    2043:	48 8b 00             	mov    (%rax),%rax
    2046:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    204a:	75 23                	jne    206f <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    204c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    204f:	89 c7                	mov    %eax,%edi
    2051:	48 b8 c4 1e 00 00 00 	movabs $0x1ec4,%rax
    2058:	00 00 00 
    205b:	ff d0                	call   *%rax
    205d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2061:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2066:	75 07                	jne    206f <malloc+0x130>
        return 0;
    2068:	b8 00 00 00 00       	mov    $0x0,%eax
    206d:	eb 18                	jmp    2087 <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    206f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2073:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    2077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    207b:	48 8b 00             	mov    (%rax),%rax
    207e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2082:	e9 41 ff ff ff       	jmp    1fc8 <malloc+0x89>
  }
}
    2087:	c9                   	leave
    2088:	c3                   	ret
