
_prettyprint:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include"types.h"
#include "user.h"

char *hoarequote = "There are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult.\n\n- C.A.R. Hoare (British computer scientist, winner of the 1980 Turing Award)\n\n";

int main(int argc, char** argv) {
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
    100b:	89 bd 7c ff ff ff    	mov    %edi,-0x84(%rbp)
    1011:	48 89 b5 70 ff ff ff 	mov    %rsi,-0x90(%rbp)
  printf(1,"First off, printing in regular color.\n");
    1018:	48 b8 40 23 00 00 00 	movabs $0x2340,%rax
    101f:	00 00 00 
    1022:	48 89 c6             	mov    %rax,%rsi
    1025:	bf 01 00 00 00       	mov    $0x1,%edi
    102a:	b8 00 00 00 00       	mov    $0x0,%eax
    102f:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    1036:	00 00 00 
    1039:	ff d2                	call   *%rdx
  printf(1,"Now changing stdout color.\n");
    103b:	48 b8 67 23 00 00 00 	movabs $0x2367,%rax
    1042:	00 00 00 
    1045:	48 89 c6             	mov    %rax,%rsi
    1048:	bf 01 00 00 00       	mov    $0x1,%edi
    104d:	b8 00 00 00 00       	mov    $0x0,%eax
    1052:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    1059:	00 00 00 
    105c:	ff d2                	call   *%rdx
  if(ioctl(1,0,3)<0) // 1 for stdout
    105e:	ba 03 00 00 00       	mov    $0x3,%edx
    1063:	be 00 00 00 00       	mov    $0x0,%esi
    1068:	bf 01 00 00 00       	mov    $0x1,%edi
    106d:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    1074:	00 00 00 
    1077:	ff d0                	call   *%rax
    1079:	85 c0                	test   %eax,%eax
    107b:	79 2f                	jns    10ac <main+0xac>
  {
    printf(2,"ioctl failed changing color\n");
    107d:	48 b8 83 23 00 00 00 	movabs $0x2383,%rax
    1084:	00 00 00 
    1087:	48 89 c6             	mov    %rax,%rsi
    108a:	bf 02 00 00 00       	mov    $0x2,%edi
    108f:	b8 00 00 00 00       	mov    $0x0,%eax
    1094:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    109b:	00 00 00 
    109e:	ff d2                	call   *%rdx
    exit();
    10a0:	48 b8 e7 17 00 00 00 	movabs $0x17e7,%rax
    10a7:	00 00 00 
    10aa:	ff d0                	call   *%rax
  }
  printf(1,"Printing pretty on stdout.\n");
    10ac:	48 b8 a0 23 00 00 00 	movabs $0x23a0,%rax
    10b3:	00 00 00 
    10b6:	48 89 c6             	mov    %rax,%rsi
    10b9:	bf 01 00 00 00       	mov    $0x1,%edi
    10be:	b8 00 00 00 00       	mov    $0x0,%eax
    10c3:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    10ca:	00 00 00 
    10cd:	ff d2                	call   *%rdx
  printf(2,"This is stderr output - should still be gray.\nTrying something more interesting...\n\n");
    10cf:	48 b8 c0 23 00 00 00 	movabs $0x23c0,%rax
    10d6:	00 00 00 
    10d9:	48 89 c6             	mov    %rax,%rsi
    10dc:	bf 02 00 00 00       	mov    $0x2,%edi
    10e1:	b8 00 00 00 00       	mov    $0x0,%eax
    10e6:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    10ed:	00 00 00 
    10f0:	ff d2                	call   *%rdx
  unsigned int i=0;
    10f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  unsigned char color=0x01;  
    10f9:	c6 45 fb 01          	movb   $0x1,-0x5(%rbp)
  for(i=0;i<strlen(hoarequote);i++) {
    10fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1104:	e9 c4 00 00 00       	jmp    11cd <main+0x1cd>
    if(ioctl(2,0,(color%0xe)+1)<0) {
    1109:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
    110d:	89 d0                	mov    %edx,%eax
    110f:	d0 e8                	shr    $1,%al
    1111:	b9 93 ff ff ff       	mov    $0xffffff93,%ecx
    1116:	f6 e1                	mul    %cl
    1118:	66 c1 e8 08          	shr    $0x8,%ax
    111c:	c0 e8 02             	shr    $0x2,%al
    111f:	b9 0e 00 00 00       	mov    $0xe,%ecx
    1124:	0f af c1             	imul   %ecx,%eax
    1127:	89 c1                	mov    %eax,%ecx
    1129:	89 d0                	mov    %edx,%eax
    112b:	29 c8                	sub    %ecx,%eax
    112d:	0f b6 c0             	movzbl %al,%eax
    1130:	83 c0 01             	add    $0x1,%eax
    1133:	89 c2                	mov    %eax,%edx
    1135:	be 00 00 00 00       	mov    $0x0,%esi
    113a:	bf 02 00 00 00       	mov    $0x2,%edi
    113f:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    1146:	00 00 00 
    1149:	ff d0                	call   *%rax
    114b:	85 c0                	test   %eax,%eax
    114d:	79 2f                	jns    117e <main+0x17e>
      printf(2,"Failed setting color for stderr.\n");
    114f:	48 b8 18 24 00 00 00 	movabs $0x2418,%rax
    1156:	00 00 00 
    1159:	48 89 c6             	mov    %rax,%rsi
    115c:	bf 02 00 00 00       	mov    $0x2,%edi
    1161:	b8 00 00 00 00       	mov    $0x0,%eax
    1166:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    116d:	00 00 00 
    1170:	ff d2                	call   *%rdx
      exit();    
    1172:	48 b8 e7 17 00 00 00 	movabs $0x17e7,%rax
    1179:	00 00 00 
    117c:	ff d0                	call   *%rax
    }
    printf(2,"%c",hoarequote[i]&0xff);
    117e:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    1185:	00 00 00 
    1188:	48 8b 10             	mov    (%rax),%rdx
    118b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    118e:	48 01 d0             	add    %rdx,%rax
    1191:	0f b6 00             	movzbl (%rax),%eax
    1194:	0f be c0             	movsbl %al,%eax
    1197:	0f b6 c0             	movzbl %al,%eax
    119a:	48 b9 3a 24 00 00 00 	movabs $0x243a,%rcx
    11a1:	00 00 00 
    11a4:	89 c2                	mov    %eax,%edx
    11a6:	48 89 ce             	mov    %rcx,%rsi
    11a9:	bf 02 00 00 00       	mov    $0x2,%edi
    11ae:	b8 00 00 00 00       	mov    $0x0,%eax
    11b3:	48 b9 ce 1a 00 00 00 	movabs $0x1ace,%rcx
    11ba:	00 00 00 
    11bd:	ff d1                	call   *%rcx
    color++;
    11bf:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
    11c3:	83 c0 01             	add    $0x1,%eax
    11c6:	88 45 fb             	mov    %al,-0x5(%rbp)
  for(i=0;i<strlen(hoarequote);i++) {
    11c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    11cd:	48 b8 90 25 00 00 00 	movabs $0x2590,%rax
    11d4:	00 00 00 
    11d7:	48 8b 00             	mov    (%rax),%rax
    11da:	48 89 c7             	mov    %rax,%rdi
    11dd:	48 b8 98 15 00 00 00 	movabs $0x1598,%rax
    11e4:	00 00 00 
    11e7:	ff d0                	call   *%rax
    11e9:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    11ec:	0f 82 17 ff ff ff    	jb     1109 <main+0x109>
  }

  ioctl(2,0,0x7);
    11f2:	ba 07 00 00 00       	mov    $0x7,%edx
    11f7:	be 00 00 00 00       	mov    $0x0,%esi
    11fc:	bf 02 00 00 00       	mov    $0x2,%edi
    1201:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    1208:	00 00 00 
    120b:	ff d0                	call   *%rax
  ioctl(1,0,0x7);
    120d:	ba 07 00 00 00       	mov    $0x7,%edx
    1212:	be 00 00 00 00       	mov    $0x0,%esi
    1217:	bf 01 00 00 00       	mov    $0x1,%edi
    121c:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    1223:	00 00 00 
    1226:	ff d0                	call   *%rax
  printf(1,"stdout should now be gray again\n");
    1228:	48 b8 40 24 00 00 00 	movabs $0x2440,%rax
    122f:	00 00 00 
    1232:	48 89 c6             	mov    %rax,%rsi
    1235:	bf 01 00 00 00       	mov    $0x1,%edi
    123a:	b8 00 00 00 00       	mov    $0x0,%eax
    123f:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    1246:	00 00 00 
    1249:	ff d2                	call   *%rdx
  printf(2,"stderr should now be gray again\n");
    124b:	48 b8 68 24 00 00 00 	movabs $0x2468,%rax
    1252:	00 00 00 
    1255:	48 89 c6             	mov    %rax,%rsi
    1258:	bf 02 00 00 00       	mov    $0x2,%edi
    125d:	b8 00 00 00 00       	mov    $0x0,%eax
    1262:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    1269:	00 00 00 
    126c:	ff d2                	call   *%rdx

  printf(1,"Try typing something, it ought to come out colored: ");
    126e:	48 b8 90 24 00 00 00 	movabs $0x2490,%rax
    1275:	00 00 00 
    1278:	48 89 c6             	mov    %rax,%rsi
    127b:	bf 01 00 00 00       	mov    $0x1,%edi
    1280:	b8 00 00 00 00       	mov    $0x0,%eax
    1285:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    128c:	00 00 00 
    128f:	ff d2                	call   *%rdx
  if(ioctl(1,1,0x1)<0) {
    1291:	ba 01 00 00 00       	mov    $0x1,%edx
    1296:	be 01 00 00 00       	mov    $0x1,%esi
    129b:	bf 01 00 00 00       	mov    $0x1,%edi
    12a0:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    12a7:	00 00 00 
    12aa:	ff d0                	call   *%rax
    12ac:	85 c0                	test   %eax,%eax
    12ae:	79 2f                	jns    12df <main+0x2df>
    printf(1,"ioctl to set global console color failed\n");
    12b0:	48 b8 c8 24 00 00 00 	movabs $0x24c8,%rax
    12b7:	00 00 00 
    12ba:	48 89 c6             	mov    %rax,%rsi
    12bd:	bf 01 00 00 00       	mov    $0x1,%edi
    12c2:	b8 00 00 00 00       	mov    $0x0,%eax
    12c7:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    12ce:	00 00 00 
    12d1:	ff d2                	call   *%rdx
    exit();
    12d3:	48 b8 e7 17 00 00 00 	movabs $0x17e7,%rax
    12da:	00 00 00 
    12dd:	ff d0                	call   *%rax
  }
  char buf[100];
  gets(buf,100);
    12df:	48 8d 45 80          	lea    -0x80(%rbp),%rax
    12e3:	be 64 00 00 00       	mov    $0x64,%esi
    12e8:	48 89 c7             	mov    %rax,%rdi
    12eb:	48 b8 39 16 00 00 00 	movabs $0x1639,%rax
    12f2:	00 00 00 
    12f5:	ff d0                	call   *%rax

  if(ioctl(1,1,0x7)<0) {
    12f7:	ba 07 00 00 00       	mov    $0x7,%edx
    12fc:	be 01 00 00 00       	mov    $0x1,%esi
    1301:	bf 01 00 00 00       	mov    $0x1,%edi
    1306:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    130d:	00 00 00 
    1310:	ff d0                	call   *%rax
    1312:	85 c0                	test   %eax,%eax
    1314:	79 2f                	jns    1345 <main+0x345>
    printf(1,"ioctl to set global console color failed\n");
    1316:	48 b8 c8 24 00 00 00 	movabs $0x24c8,%rax
    131d:	00 00 00 
    1320:	48 89 c6             	mov    %rax,%rsi
    1323:	bf 01 00 00 00       	mov    $0x1,%edi
    1328:	b8 00 00 00 00       	mov    $0x0,%eax
    132d:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    1334:	00 00 00 
    1337:	ff d2                	call   *%rdx
    exit();
    1339:	48 b8 e7 17 00 00 00 	movabs $0x17e7,%rax
    1340:	00 00 00 
    1343:	ff d0                	call   *%rax
  }
  buf[strlen(buf)-1]=0;
    1345:	48 8d 45 80          	lea    -0x80(%rbp),%rax
    1349:	48 89 c7             	mov    %rax,%rdi
    134c:	48 b8 98 15 00 00 00 	movabs $0x1598,%rax
    1353:	00 00 00 
    1356:	ff d0                	call   *%rax
    1358:	83 e8 01             	sub    $0x1,%eax
    135b:	89 c0                	mov    %eax,%eax
    135d:	c6 44 05 80 00       	movb   $0x0,-0x80(%rbp,%rax,1)
  printf(1,"You typed '%s'. Try typing something gray: ",buf);
    1362:	48 8d 45 80          	lea    -0x80(%rbp),%rax
    1366:	48 b9 f8 24 00 00 00 	movabs $0x24f8,%rcx
    136d:	00 00 00 
    1370:	48 89 c2             	mov    %rax,%rdx
    1373:	48 89 ce             	mov    %rcx,%rsi
    1376:	bf 01 00 00 00       	mov    $0x1,%edi
    137b:	b8 00 00 00 00       	mov    $0x0,%eax
    1380:	48 b9 ce 1a 00 00 00 	movabs $0x1ace,%rcx
    1387:	00 00 00 
    138a:	ff d1                	call   *%rcx
  gets(buf,100);
    138c:	48 8d 45 80          	lea    -0x80(%rbp),%rax
    1390:	be 64 00 00 00       	mov    $0x64,%esi
    1395:	48 89 c7             	mov    %rax,%rdi
    1398:	48 b8 39 16 00 00 00 	movabs $0x1639,%rax
    139f:	00 00 00 
    13a2:	ff d0                	call   *%rax
  
  printf(1,"Ok, was that gray? In that case, we're done here. \n\nNow try your hand on the ");
    13a4:	48 b8 28 25 00 00 00 	movabs $0x2528,%rax
    13ab:	00 00 00 
    13ae:	48 89 c6             	mov    %rax,%rsi
    13b1:	bf 01 00 00 00       	mov    $0x1,%edi
    13b6:	b8 00 00 00 00       	mov    $0x0,%eax
    13bb:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    13c2:	00 00 00 
    13c5:	ff d2                	call   *%rdx
  char *graphics="graphics";
    13c7:	48 b8 76 25 00 00 00 	movabs $0x2576,%rax
    13ce:	00 00 00 
    13d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(i=0;i<strlen(graphics);i++) {
    13d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    13dc:	e9 85 00 00 00       	jmp    1466 <main+0x466>
    ioctl(1,0,(color%0xe)+1);
    13e1:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
    13e5:	89 d0                	mov    %edx,%eax
    13e7:	d0 e8                	shr    $1,%al
    13e9:	b9 93 ff ff ff       	mov    $0xffffff93,%ecx
    13ee:	f6 e1                	mul    %cl
    13f0:	66 c1 e8 08          	shr    $0x8,%ax
    13f4:	c0 e8 02             	shr    $0x2,%al
    13f7:	b9 0e 00 00 00       	mov    $0xe,%ecx
    13fc:	0f af c1             	imul   %ecx,%eax
    13ff:	89 c1                	mov    %eax,%ecx
    1401:	89 d0                	mov    %edx,%eax
    1403:	29 c8                	sub    %ecx,%eax
    1405:	0f b6 c0             	movzbl %al,%eax
    1408:	83 c0 01             	add    $0x1,%eax
    140b:	89 c2                	mov    %eax,%edx
    140d:	be 00 00 00 00       	mov    $0x0,%esi
    1412:	bf 01 00 00 00       	mov    $0x1,%edi
    1417:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    141e:	00 00 00 
    1421:	ff d0                	call   *%rax
    color++;
    1423:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
    1427:	83 c0 01             	add    $0x1,%eax
    142a:	88 45 fb             	mov    %al,-0x5(%rbp)
    printf(1,"%c",graphics[i]);
    142d:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1434:	48 01 d0             	add    %rdx,%rax
    1437:	0f b6 00             	movzbl (%rax),%eax
    143a:	0f be c0             	movsbl %al,%eax
    143d:	48 b9 3a 24 00 00 00 	movabs $0x243a,%rcx
    1444:	00 00 00 
    1447:	89 c2                	mov    %eax,%edx
    1449:	48 89 ce             	mov    %rcx,%rsi
    144c:	bf 01 00 00 00       	mov    $0x1,%edi
    1451:	b8 00 00 00 00       	mov    $0x0,%eax
    1456:	48 b9 ce 1a 00 00 00 	movabs $0x1ace,%rcx
    145d:	00 00 00 
    1460:	ff d1                	call   *%rcx
  for(i=0;i<strlen(graphics);i++) {
    1462:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1466:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    146a:	48 89 c7             	mov    %rax,%rdi
    146d:	48 b8 98 15 00 00 00 	movabs $0x1598,%rax
    1474:	00 00 00 
    1477:	ff d0                	call   *%rax
    1479:	39 45 fc             	cmp    %eax,-0x4(%rbp)
    147c:	0f 82 5f ff ff ff    	jb     13e1 <main+0x3e1>
  }
  ioctl(1,0,0x7);
    1482:	ba 07 00 00 00       	mov    $0x7,%edx
    1487:	be 00 00 00 00       	mov    $0x0,%esi
    148c:	bf 01 00 00 00       	mov    $0x1,%edi
    1491:	48 b8 eb 18 00 00 00 	movabs $0x18eb,%rax
    1498:	00 00 00 
    149b:	ff d0                	call   *%rax
  printf(1," driver.\n");
    149d:	48 b8 7f 25 00 00 00 	movabs $0x257f,%rax
    14a4:	00 00 00 
    14a7:	48 89 c6             	mov    %rax,%rsi
    14aa:	bf 01 00 00 00       	mov    $0x1,%edi
    14af:	b8 00 00 00 00       	mov    $0x0,%eax
    14b4:	48 ba ce 1a 00 00 00 	movabs $0x1ace,%rdx
    14bb:	00 00 00 
    14be:	ff d2                	call   *%rdx

  exit();
    14c0:	48 b8 e7 17 00 00 00 	movabs $0x17e7,%rax
    14c7:	00 00 00 
    14ca:	ff d0                	call   *%rax

00000000000014cc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    14cc:	55                   	push   %rbp
    14cd:	48 89 e5             	mov    %rsp,%rbp
    14d0:	48 83 ec 10          	sub    $0x10,%rsp
    14d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    14d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    14db:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    14de:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    14e2:	8b 55 f0             	mov    -0x10(%rbp),%edx
    14e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
    14e8:	48 89 ce             	mov    %rcx,%rsi
    14eb:	48 89 f7             	mov    %rsi,%rdi
    14ee:	89 d1                	mov    %edx,%ecx
    14f0:	fc                   	cld
    14f1:	f3 aa                	rep stos %al,(%rdi)
    14f3:	89 ca                	mov    %ecx,%edx
    14f5:	48 89 fe             	mov    %rdi,%rsi
    14f8:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    14fc:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14ff:	90                   	nop
    1500:	c9                   	leave
    1501:	c3                   	ret

0000000000001502 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1502:	55                   	push   %rbp
    1503:	48 89 e5             	mov    %rsp,%rbp
    1506:	48 83 ec 20          	sub    $0x20,%rsp
    150a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    150e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1516:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    151a:	90                   	nop
    151b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    151f:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1523:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    152b:	48 8d 48 01          	lea    0x1(%rax),%rcx
    152f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1533:	0f b6 12             	movzbl (%rdx),%edx
    1536:	88 10                	mov    %dl,(%rax)
    1538:	0f b6 00             	movzbl (%rax),%eax
    153b:	84 c0                	test   %al,%al
    153d:	75 dc                	jne    151b <strcpy+0x19>
    ;
  return os;
    153f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1543:	c9                   	leave
    1544:	c3                   	ret

0000000000001545 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1545:	55                   	push   %rbp
    1546:	48 89 e5             	mov    %rsp,%rbp
    1549:	48 83 ec 10          	sub    $0x10,%rsp
    154d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1551:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1555:	eb 0a                	jmp    1561 <strcmp+0x1c>
    p++, q++;
    1557:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    155c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1565:	0f b6 00             	movzbl (%rax),%eax
    1568:	84 c0                	test   %al,%al
    156a:	74 12                	je     157e <strcmp+0x39>
    156c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1570:	0f b6 10             	movzbl (%rax),%edx
    1573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1577:	0f b6 00             	movzbl (%rax),%eax
    157a:	38 c2                	cmp    %al,%dl
    157c:	74 d9                	je     1557 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    157e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1582:	0f b6 00             	movzbl (%rax),%eax
    1585:	0f b6 d0             	movzbl %al,%edx
    1588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    158c:	0f b6 00             	movzbl (%rax),%eax
    158f:	0f b6 c0             	movzbl %al,%eax
    1592:	29 c2                	sub    %eax,%edx
    1594:	89 d0                	mov    %edx,%eax
}
    1596:	c9                   	leave
    1597:	c3                   	ret

0000000000001598 <strlen>:

uint
strlen(char *s)
{
    1598:	55                   	push   %rbp
    1599:	48 89 e5             	mov    %rsp,%rbp
    159c:	48 83 ec 18          	sub    $0x18,%rsp
    15a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    15a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    15ab:	eb 04                	jmp    15b1 <strlen+0x19>
    15ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15b4:	48 63 d0             	movslq %eax,%rdx
    15b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15bb:	48 01 d0             	add    %rdx,%rax
    15be:	0f b6 00             	movzbl (%rax),%eax
    15c1:	84 c0                	test   %al,%al
    15c3:	75 e8                	jne    15ad <strlen+0x15>
    ;
  return n;
    15c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15c8:	c9                   	leave
    15c9:	c3                   	ret

00000000000015ca <memset>:

void*
memset(void *dst, int c, uint n)
{
    15ca:	55                   	push   %rbp
    15cb:	48 89 e5             	mov    %rsp,%rbp
    15ce:	48 83 ec 10          	sub    $0x10,%rsp
    15d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15d6:	89 75 f4             	mov    %esi,-0xc(%rbp)
    15d9:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    15dc:	8b 55 f0             	mov    -0x10(%rbp),%edx
    15df:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    15e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15e6:	89 ce                	mov    %ecx,%esi
    15e8:	48 89 c7             	mov    %rax,%rdi
    15eb:	48 b8 cc 14 00 00 00 	movabs $0x14cc,%rax
    15f2:	00 00 00 
    15f5:	ff d0                	call   *%rax
  return dst;
    15f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15fb:	c9                   	leave
    15fc:	c3                   	ret

00000000000015fd <strchr>:

char*
strchr(const char *s, char c)
{
    15fd:	55                   	push   %rbp
    15fe:	48 89 e5             	mov    %rsp,%rbp
    1601:	48 83 ec 10          	sub    $0x10,%rsp
    1605:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1609:	89 f0                	mov    %esi,%eax
    160b:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    160e:	eb 17                	jmp    1627 <strchr+0x2a>
    if(*s == c)
    1610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1614:	0f b6 00             	movzbl (%rax),%eax
    1617:	38 45 f4             	cmp    %al,-0xc(%rbp)
    161a:	75 06                	jne    1622 <strchr+0x25>
      return (char*)s;
    161c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1620:	eb 15                	jmp    1637 <strchr+0x3a>
  for(; *s; s++)
    1622:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    162b:	0f b6 00             	movzbl (%rax),%eax
    162e:	84 c0                	test   %al,%al
    1630:	75 de                	jne    1610 <strchr+0x13>
  return 0;
    1632:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1637:	c9                   	leave
    1638:	c3                   	ret

0000000000001639 <gets>:

char*
gets(char *buf, int max)
{
    1639:	55                   	push   %rbp
    163a:	48 89 e5             	mov    %rsp,%rbp
    163d:	48 83 ec 20          	sub    $0x20,%rsp
    1641:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1645:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1648:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    164f:	eb 4f                	jmp    16a0 <gets+0x67>
    cc = read(0, &c, 1);
    1651:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1655:	ba 01 00 00 00       	mov    $0x1,%edx
    165a:	48 89 c6             	mov    %rax,%rsi
    165d:	bf 00 00 00 00       	mov    $0x0,%edi
    1662:	48 b8 0e 18 00 00 00 	movabs $0x180e,%rax
    1669:	00 00 00 
    166c:	ff d0                	call   *%rax
    166e:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1671:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1675:	7e 36                	jle    16ad <gets+0x74>
      break;
    buf[i++] = c;
    1677:	8b 45 fc             	mov    -0x4(%rbp),%eax
    167a:	8d 50 01             	lea    0x1(%rax),%edx
    167d:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1680:	48 63 d0             	movslq %eax,%rdx
    1683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1687:	48 01 c2             	add    %rax,%rdx
    168a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    168e:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1690:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1694:	3c 0a                	cmp    $0xa,%al
    1696:	74 16                	je     16ae <gets+0x75>
    1698:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    169c:	3c 0d                	cmp    $0xd,%al
    169e:	74 0e                	je     16ae <gets+0x75>
  for(i=0; i+1 < max; ){
    16a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a3:	83 c0 01             	add    $0x1,%eax
    16a6:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    16a9:	7f a6                	jg     1651 <gets+0x18>
    16ab:	eb 01                	jmp    16ae <gets+0x75>
      break;
    16ad:	90                   	nop
      break;
  }
  buf[i] = '\0';
    16ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16b1:	48 63 d0             	movslq %eax,%rdx
    16b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16b8:	48 01 d0             	add    %rdx,%rax
    16bb:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    16be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    16c2:	c9                   	leave
    16c3:	c3                   	ret

00000000000016c4 <stat>:

int
stat(char *n, struct stat *st)
{
    16c4:	55                   	push   %rbp
    16c5:	48 89 e5             	mov    %rsp,%rbp
    16c8:	48 83 ec 20          	sub    $0x20,%rsp
    16cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    16d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    16d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16d8:	be 00 00 00 00       	mov    $0x0,%esi
    16dd:	48 89 c7             	mov    %rax,%rdi
    16e0:	48 b8 4f 18 00 00 00 	movabs $0x184f,%rax
    16e7:	00 00 00 
    16ea:	ff d0                	call   *%rax
    16ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    16ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    16f3:	79 07                	jns    16fc <stat+0x38>
    return -1;
    16f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16fa:	eb 2f                	jmp    172b <stat+0x67>
  r = fstat(fd, st);
    16fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1700:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1703:	48 89 d6             	mov    %rdx,%rsi
    1706:	89 c7                	mov    %eax,%edi
    1708:	48 b8 76 18 00 00 00 	movabs $0x1876,%rax
    170f:	00 00 00 
    1712:	ff d0                	call   *%rax
    1714:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1717:	8b 45 fc             	mov    -0x4(%rbp),%eax
    171a:	89 c7                	mov    %eax,%edi
    171c:	48 b8 28 18 00 00 00 	movabs $0x1828,%rax
    1723:	00 00 00 
    1726:	ff d0                	call   *%rax
  return r;
    1728:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    172b:	c9                   	leave
    172c:	c3                   	ret

000000000000172d <atoi>:

int
atoi(const char *s)
{
    172d:	55                   	push   %rbp
    172e:	48 89 e5             	mov    %rsp,%rbp
    1731:	48 83 ec 18          	sub    $0x18,%rsp
    1735:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1739:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1740:	eb 28                	jmp    176a <atoi+0x3d>
    n = n*10 + *s++ - '0';
    1742:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1745:	89 d0                	mov    %edx,%eax
    1747:	c1 e0 02             	shl    $0x2,%eax
    174a:	01 d0                	add    %edx,%eax
    174c:	01 c0                	add    %eax,%eax
    174e:	89 c1                	mov    %eax,%ecx
    1750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1754:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1758:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    175c:	0f b6 00             	movzbl (%rax),%eax
    175f:	0f be c0             	movsbl %al,%eax
    1762:	01 c8                	add    %ecx,%eax
    1764:	83 e8 30             	sub    $0x30,%eax
    1767:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    176a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    176e:	0f b6 00             	movzbl (%rax),%eax
    1771:	3c 2f                	cmp    $0x2f,%al
    1773:	7e 0b                	jle    1780 <atoi+0x53>
    1775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1779:	0f b6 00             	movzbl (%rax),%eax
    177c:	3c 39                	cmp    $0x39,%al
    177e:	7e c2                	jle    1742 <atoi+0x15>
  return n;
    1780:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1783:	c9                   	leave
    1784:	c3                   	ret

0000000000001785 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1785:	55                   	push   %rbp
    1786:	48 89 e5             	mov    %rsp,%rbp
    1789:	48 83 ec 28          	sub    $0x28,%rsp
    178d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1791:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1795:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    179c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    17a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    17a8:	eb 1d                	jmp    17c7 <memmove+0x42>
    *dst++ = *src++;
    17aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    17ae:	48 8d 42 01          	lea    0x1(%rdx),%rax
    17b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    17b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17ba:	48 8d 48 01          	lea    0x1(%rax),%rcx
    17be:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    17c2:	0f b6 12             	movzbl (%rdx),%edx
    17c5:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    17c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17ca:	8d 50 ff             	lea    -0x1(%rax),%edx
    17cd:	89 55 dc             	mov    %edx,-0x24(%rbp)
    17d0:	85 c0                	test   %eax,%eax
    17d2:	7f d6                	jg     17aa <memmove+0x25>
  return vdst;
    17d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    17d8:	c9                   	leave
    17d9:	c3                   	ret

00000000000017da <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    17da:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    17e1:	49 89 ca             	mov    %rcx,%r10
    17e4:	0f 05                	syscall
    17e6:	c3                   	ret

00000000000017e7 <exit>:
SYSCALL(exit)
    17e7:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    17ee:	49 89 ca             	mov    %rcx,%r10
    17f1:	0f 05                	syscall
    17f3:	c3                   	ret

00000000000017f4 <wait>:
SYSCALL(wait)
    17f4:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    17fb:	49 89 ca             	mov    %rcx,%r10
    17fe:	0f 05                	syscall
    1800:	c3                   	ret

0000000000001801 <pipe>:
SYSCALL(pipe)
    1801:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1808:	49 89 ca             	mov    %rcx,%r10
    180b:	0f 05                	syscall
    180d:	c3                   	ret

000000000000180e <read>:
SYSCALL(read)
    180e:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1815:	49 89 ca             	mov    %rcx,%r10
    1818:	0f 05                	syscall
    181a:	c3                   	ret

000000000000181b <write>:
SYSCALL(write)
    181b:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1822:	49 89 ca             	mov    %rcx,%r10
    1825:	0f 05                	syscall
    1827:	c3                   	ret

0000000000001828 <close>:
SYSCALL(close)
    1828:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    182f:	49 89 ca             	mov    %rcx,%r10
    1832:	0f 05                	syscall
    1834:	c3                   	ret

0000000000001835 <kill>:
SYSCALL(kill)
    1835:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    183c:	49 89 ca             	mov    %rcx,%r10
    183f:	0f 05                	syscall
    1841:	c3                   	ret

0000000000001842 <exec>:
SYSCALL(exec)
    1842:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1849:	49 89 ca             	mov    %rcx,%r10
    184c:	0f 05                	syscall
    184e:	c3                   	ret

000000000000184f <open>:
SYSCALL(open)
    184f:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1856:	49 89 ca             	mov    %rcx,%r10
    1859:	0f 05                	syscall
    185b:	c3                   	ret

000000000000185c <mknod>:
SYSCALL(mknod)
    185c:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1863:	49 89 ca             	mov    %rcx,%r10
    1866:	0f 05                	syscall
    1868:	c3                   	ret

0000000000001869 <unlink>:
SYSCALL(unlink)
    1869:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1870:	49 89 ca             	mov    %rcx,%r10
    1873:	0f 05                	syscall
    1875:	c3                   	ret

0000000000001876 <fstat>:
SYSCALL(fstat)
    1876:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    187d:	49 89 ca             	mov    %rcx,%r10
    1880:	0f 05                	syscall
    1882:	c3                   	ret

0000000000001883 <link>:
SYSCALL(link)
    1883:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    188a:	49 89 ca             	mov    %rcx,%r10
    188d:	0f 05                	syscall
    188f:	c3                   	ret

0000000000001890 <mkdir>:
SYSCALL(mkdir)
    1890:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1897:	49 89 ca             	mov    %rcx,%r10
    189a:	0f 05                	syscall
    189c:	c3                   	ret

000000000000189d <chdir>:
SYSCALL(chdir)
    189d:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    18a4:	49 89 ca             	mov    %rcx,%r10
    18a7:	0f 05                	syscall
    18a9:	c3                   	ret

00000000000018aa <dup>:
SYSCALL(dup)
    18aa:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    18b1:	49 89 ca             	mov    %rcx,%r10
    18b4:	0f 05                	syscall
    18b6:	c3                   	ret

00000000000018b7 <getpid>:
SYSCALL(getpid)
    18b7:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    18be:	49 89 ca             	mov    %rcx,%r10
    18c1:	0f 05                	syscall
    18c3:	c3                   	ret

00000000000018c4 <sbrk>:
SYSCALL(sbrk)
    18c4:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    18cb:	49 89 ca             	mov    %rcx,%r10
    18ce:	0f 05                	syscall
    18d0:	c3                   	ret

00000000000018d1 <sleep>:
SYSCALL(sleep)
    18d1:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    18d8:	49 89 ca             	mov    %rcx,%r10
    18db:	0f 05                	syscall
    18dd:	c3                   	ret

00000000000018de <uptime>:
SYSCALL(uptime)
    18de:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    18e5:	49 89 ca             	mov    %rcx,%r10
    18e8:	0f 05                	syscall
    18ea:	c3                   	ret

00000000000018eb <ioctl>:
SYSCALL(ioctl)
    18eb:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    18f2:	49 89 ca             	mov    %rcx,%r10
    18f5:	0f 05                	syscall
    18f7:	c3                   	ret

00000000000018f8 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    18f8:	55                   	push   %rbp
    18f9:	48 89 e5             	mov    %rsp,%rbp
    18fc:	48 83 ec 10          	sub    $0x10,%rsp
    1900:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1903:	89 f0                	mov    %esi,%eax
    1905:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1908:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    190c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    190f:	ba 01 00 00 00       	mov    $0x1,%edx
    1914:	48 89 ce             	mov    %rcx,%rsi
    1917:	89 c7                	mov    %eax,%edi
    1919:	48 b8 1b 18 00 00 00 	movabs $0x181b,%rax
    1920:	00 00 00 
    1923:	ff d0                	call   *%rax
}
    1925:	90                   	nop
    1926:	c9                   	leave
    1927:	c3                   	ret

0000000000001928 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1928:	55                   	push   %rbp
    1929:	48 89 e5             	mov    %rsp,%rbp
    192c:	48 83 ec 20          	sub    $0x20,%rsp
    1930:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1933:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1937:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    193e:	eb 35                	jmp    1975 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1940:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1944:	48 c1 e8 3c          	shr    $0x3c,%rax
    1948:	48 ba a0 25 00 00 00 	movabs $0x25a0,%rdx
    194f:	00 00 00 
    1952:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1956:	0f be d0             	movsbl %al,%edx
    1959:	8b 45 ec             	mov    -0x14(%rbp),%eax
    195c:	89 d6                	mov    %edx,%esi
    195e:	89 c7                	mov    %eax,%edi
    1960:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1967:	00 00 00 
    196a:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    196c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1970:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1975:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1978:	83 f8 0f             	cmp    $0xf,%eax
    197b:	76 c3                	jbe    1940 <print_x64+0x18>
}
    197d:	90                   	nop
    197e:	90                   	nop
    197f:	c9                   	leave
    1980:	c3                   	ret

0000000000001981 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1981:	55                   	push   %rbp
    1982:	48 89 e5             	mov    %rsp,%rbp
    1985:	48 83 ec 20          	sub    $0x20,%rsp
    1989:	89 7d ec             	mov    %edi,-0x14(%rbp)
    198c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    198f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1996:	eb 36                	jmp    19ce <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1998:	8b 45 e8             	mov    -0x18(%rbp),%eax
    199b:	c1 e8 1c             	shr    $0x1c,%eax
    199e:	89 c2                	mov    %eax,%edx
    19a0:	48 b8 a0 25 00 00 00 	movabs $0x25a0,%rax
    19a7:	00 00 00 
    19aa:	89 d2                	mov    %edx,%edx
    19ac:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    19b0:	0f be d0             	movsbl %al,%edx
    19b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    19b6:	89 d6                	mov    %edx,%esi
    19b8:	89 c7                	mov    %eax,%edi
    19ba:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    19c1:	00 00 00 
    19c4:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19ca:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    19ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19d1:	83 f8 07             	cmp    $0x7,%eax
    19d4:	76 c2                	jbe    1998 <print_x32+0x17>
}
    19d6:	90                   	nop
    19d7:	90                   	nop
    19d8:	c9                   	leave
    19d9:	c3                   	ret

00000000000019da <print_d>:

  static void
print_d(int fd, int v)
{
    19da:	55                   	push   %rbp
    19db:	48 89 e5             	mov    %rsp,%rbp
    19de:	48 83 ec 30          	sub    $0x30,%rsp
    19e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    19e5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    19e8:	8b 45 d8             	mov    -0x28(%rbp),%eax
    19eb:	48 98                	cltq
    19ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    19f1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    19f5:	79 04                	jns    19fb <print_d+0x21>
    x = -x;
    19f7:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    19fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1a02:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a06:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a0d:	66 66 66 
    1a10:	48 89 c8             	mov    %rcx,%rax
    1a13:	48 f7 ea             	imul   %rdx
    1a16:	48 c1 fa 02          	sar    $0x2,%rdx
    1a1a:	48 89 c8             	mov    %rcx,%rax
    1a1d:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a21:	48 29 c2             	sub    %rax,%rdx
    1a24:	48 89 d0             	mov    %rdx,%rax
    1a27:	48 c1 e0 02          	shl    $0x2,%rax
    1a2b:	48 01 d0             	add    %rdx,%rax
    1a2e:	48 01 c0             	add    %rax,%rax
    1a31:	48 29 c1             	sub    %rax,%rcx
    1a34:	48 89 ca             	mov    %rcx,%rdx
    1a37:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a3a:	8d 48 01             	lea    0x1(%rax),%ecx
    1a3d:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a40:	48 b9 a0 25 00 00 00 	movabs $0x25a0,%rcx
    1a47:	00 00 00 
    1a4a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a4e:	48 98                	cltq
    1a50:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a54:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a58:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a5f:	66 66 66 
    1a62:	48 89 c8             	mov    %rcx,%rax
    1a65:	48 f7 ea             	imul   %rdx
    1a68:	48 89 d0             	mov    %rdx,%rax
    1a6b:	48 c1 f8 02          	sar    $0x2,%rax
    1a6f:	48 c1 f9 3f          	sar    $0x3f,%rcx
    1a73:	48 89 ca             	mov    %rcx,%rdx
    1a76:	48 29 d0             	sub    %rdx,%rax
    1a79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a7d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a82:	0f 85 7a ff ff ff    	jne    1a02 <print_d+0x28>

  if (v < 0)
    1a88:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a8c:	79 32                	jns    1ac0 <print_d+0xe6>
    buf[i++] = '-';
    1a8e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a91:	8d 50 01             	lea    0x1(%rax),%edx
    1a94:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1a97:	48 98                	cltq
    1a99:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1a9e:	eb 20                	jmp    1ac0 <print_d+0xe6>
    putc(fd, buf[i]);
    1aa0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1aa3:	48 98                	cltq
    1aa5:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1aaa:	0f be d0             	movsbl %al,%edx
    1aad:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1ab0:	89 d6                	mov    %edx,%esi
    1ab2:	89 c7                	mov    %eax,%edi
    1ab4:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1abb:	00 00 00 
    1abe:	ff d0                	call   *%rax
  while (--i >= 0)
    1ac0:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1ac8:	79 d6                	jns    1aa0 <print_d+0xc6>
}
    1aca:	90                   	nop
    1acb:	90                   	nop
    1acc:	c9                   	leave
    1acd:	c3                   	ret

0000000000001ace <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1ace:	55                   	push   %rbp
    1acf:	48 89 e5             	mov    %rsp,%rbp
    1ad2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1ad9:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1adf:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1ae6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1aed:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1af4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1afb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1b02:	84 c0                	test   %al,%al
    1b04:	74 20                	je     1b26 <printf+0x58>
    1b06:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1b0a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1b0e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1b12:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1b16:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1b1a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1b1e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1b22:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1b26:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1b2d:	00 00 00 
    1b30:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b37:	00 00 00 
    1b3a:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b3e:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b45:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b4c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b53:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b5a:	00 00 00 
    1b5d:	e9 60 03 00 00       	jmp    1ec2 <printf+0x3f4>
    if (c != '%') {
    1b62:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b69:	74 24                	je     1b8f <printf+0xc1>
      putc(fd, c);
    1b6b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b71:	0f be d0             	movsbl %al,%edx
    1b74:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b7a:	89 d6                	mov    %edx,%esi
    1b7c:	89 c7                	mov    %eax,%edi
    1b7e:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1b85:	00 00 00 
    1b88:	ff d0                	call   *%rax
      continue;
    1b8a:	e9 2c 03 00 00       	jmp    1ebb <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    1b8f:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1b96:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1b9c:	48 63 d0             	movslq %eax,%rdx
    1b9f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ba6:	48 01 d0             	add    %rdx,%rax
    1ba9:	0f b6 00             	movzbl (%rax),%eax
    1bac:	0f be c0             	movsbl %al,%eax
    1baf:	25 ff 00 00 00       	and    $0xff,%eax
    1bb4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1bba:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bc1:	0f 84 2e 03 00 00    	je     1ef5 <printf+0x427>
      break;
    switch(c) {
    1bc7:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1bce:	0f 84 32 01 00 00    	je     1d06 <printf+0x238>
    1bd4:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1bdb:	0f 8f a1 02 00 00    	jg     1e82 <printf+0x3b4>
    1be1:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1be8:	0f 84 d4 01 00 00    	je     1dc2 <printf+0x2f4>
    1bee:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    1bf5:	0f 8f 87 02 00 00    	jg     1e82 <printf+0x3b4>
    1bfb:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1c02:	0f 84 5b 01 00 00    	je     1d63 <printf+0x295>
    1c08:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    1c0f:	0f 8f 6d 02 00 00    	jg     1e82 <printf+0x3b4>
    1c15:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1c1c:	0f 84 87 00 00 00    	je     1ca9 <printf+0x1db>
    1c22:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    1c29:	0f 8f 53 02 00 00    	jg     1e82 <printf+0x3b4>
    1c2f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1c36:	0f 84 2b 02 00 00    	je     1e67 <printf+0x399>
    1c3c:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1c43:	0f 85 39 02 00 00    	jne    1e82 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    1c49:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c4f:	83 f8 2f             	cmp    $0x2f,%eax
    1c52:	77 23                	ja     1c77 <printf+0x1a9>
    1c54:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c5b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c61:	89 d2                	mov    %edx,%edx
    1c63:	48 01 d0             	add    %rdx,%rax
    1c66:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c6c:	83 c2 08             	add    $0x8,%edx
    1c6f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c75:	eb 12                	jmp    1c89 <printf+0x1bb>
    1c77:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c7e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c82:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c89:	8b 00                	mov    (%rax),%eax
    1c8b:	0f be d0             	movsbl %al,%edx
    1c8e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c94:	89 d6                	mov    %edx,%esi
    1c96:	89 c7                	mov    %eax,%edi
    1c98:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1c9f:	00 00 00 
    1ca2:	ff d0                	call   *%rax
      break;
    1ca4:	e9 12 02 00 00       	jmp    1ebb <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1ca9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1caf:	83 f8 2f             	cmp    $0x2f,%eax
    1cb2:	77 23                	ja     1cd7 <printf+0x209>
    1cb4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1cbb:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cc1:	89 d2                	mov    %edx,%edx
    1cc3:	48 01 d0             	add    %rdx,%rax
    1cc6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1ccc:	83 c2 08             	add    $0x8,%edx
    1ccf:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cd5:	eb 12                	jmp    1ce9 <printf+0x21b>
    1cd7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1cde:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1ce2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ce9:	8b 10                	mov    (%rax),%edx
    1ceb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1cf1:	89 d6                	mov    %edx,%esi
    1cf3:	89 c7                	mov    %eax,%edi
    1cf5:	48 b8 da 19 00 00 00 	movabs $0x19da,%rax
    1cfc:	00 00 00 
    1cff:	ff d0                	call   *%rax
      break;
    1d01:	e9 b5 01 00 00       	jmp    1ebb <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1d06:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d0c:	83 f8 2f             	cmp    $0x2f,%eax
    1d0f:	77 23                	ja     1d34 <printf+0x266>
    1d11:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d18:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d1e:	89 d2                	mov    %edx,%edx
    1d20:	48 01 d0             	add    %rdx,%rax
    1d23:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d29:	83 c2 08             	add    $0x8,%edx
    1d2c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d32:	eb 12                	jmp    1d46 <printf+0x278>
    1d34:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d3b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d3f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d46:	8b 10                	mov    (%rax),%edx
    1d48:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d4e:	89 d6                	mov    %edx,%esi
    1d50:	89 c7                	mov    %eax,%edi
    1d52:	48 b8 81 19 00 00 00 	movabs $0x1981,%rax
    1d59:	00 00 00 
    1d5c:	ff d0                	call   *%rax
      break;
    1d5e:	e9 58 01 00 00       	jmp    1ebb <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d63:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d69:	83 f8 2f             	cmp    $0x2f,%eax
    1d6c:	77 23                	ja     1d91 <printf+0x2c3>
    1d6e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d75:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d7b:	89 d2                	mov    %edx,%edx
    1d7d:	48 01 d0             	add    %rdx,%rax
    1d80:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d86:	83 c2 08             	add    $0x8,%edx
    1d89:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d8f:	eb 12                	jmp    1da3 <printf+0x2d5>
    1d91:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d98:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d9c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1da3:	48 8b 10             	mov    (%rax),%rdx
    1da6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1dac:	48 89 d6             	mov    %rdx,%rsi
    1daf:	89 c7                	mov    %eax,%edi
    1db1:	48 b8 28 19 00 00 00 	movabs $0x1928,%rax
    1db8:	00 00 00 
    1dbb:	ff d0                	call   *%rax
      break;
    1dbd:	e9 f9 00 00 00       	jmp    1ebb <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1dc2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1dc8:	83 f8 2f             	cmp    $0x2f,%eax
    1dcb:	77 23                	ja     1df0 <printf+0x322>
    1dcd:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1dd4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dda:	89 d2                	mov    %edx,%edx
    1ddc:	48 01 d0             	add    %rdx,%rax
    1ddf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1de5:	83 c2 08             	add    $0x8,%edx
    1de8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1dee:	eb 12                	jmp    1e02 <printf+0x334>
    1df0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1df7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1dfb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1e02:	48 8b 00             	mov    (%rax),%rax
    1e05:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1e0c:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1e13:	00 
    1e14:	75 41                	jne    1e57 <printf+0x389>
        s = "(null)";
    1e16:	48 b8 89 25 00 00 00 	movabs $0x2589,%rax
    1e1d:	00 00 00 
    1e20:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1e27:	eb 2e                	jmp    1e57 <printf+0x389>
        putc(fd, *(s++));
    1e29:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e30:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1e34:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e3b:	0f b6 00             	movzbl (%rax),%eax
    1e3e:	0f be d0             	movsbl %al,%edx
    1e41:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e47:	89 d6                	mov    %edx,%esi
    1e49:	89 c7                	mov    %eax,%edi
    1e4b:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1e52:	00 00 00 
    1e55:	ff d0                	call   *%rax
      while (*s)
    1e57:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e5e:	0f b6 00             	movzbl (%rax),%eax
    1e61:	84 c0                	test   %al,%al
    1e63:	75 c4                	jne    1e29 <printf+0x35b>
      break;
    1e65:	eb 54                	jmp    1ebb <printf+0x3ed>
    case '%':
      putc(fd, '%');
    1e67:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e6d:	be 25 00 00 00       	mov    $0x25,%esi
    1e72:	89 c7                	mov    %eax,%edi
    1e74:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1e7b:	00 00 00 
    1e7e:	ff d0                	call   *%rax
      break;
    1e80:	eb 39                	jmp    1ebb <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e82:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e88:	be 25 00 00 00       	mov    $0x25,%esi
    1e8d:	89 c7                	mov    %eax,%edi
    1e8f:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1e96:	00 00 00 
    1e99:	ff d0                	call   *%rax
      putc(fd, c);
    1e9b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1ea1:	0f be d0             	movsbl %al,%edx
    1ea4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1eaa:	89 d6                	mov    %edx,%esi
    1eac:	89 c7                	mov    %eax,%edi
    1eae:	48 b8 f8 18 00 00 00 	movabs $0x18f8,%rax
    1eb5:	00 00 00 
    1eb8:	ff d0                	call   *%rax
      break;
    1eba:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1ebb:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ec2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ec8:	48 63 d0             	movslq %eax,%rdx
    1ecb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ed2:	48 01 d0             	add    %rdx,%rax
    1ed5:	0f b6 00             	movzbl (%rax),%eax
    1ed8:	0f be c0             	movsbl %al,%eax
    1edb:	25 ff 00 00 00       	and    $0xff,%eax
    1ee0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ee6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1eed:	0f 85 6f fc ff ff    	jne    1b62 <printf+0x94>
    }
  }
}
    1ef3:	eb 01                	jmp    1ef6 <printf+0x428>
      break;
    1ef5:	90                   	nop
}
    1ef6:	90                   	nop
    1ef7:	c9                   	leave
    1ef8:	c3                   	ret

0000000000001ef9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ef9:	55                   	push   %rbp
    1efa:	48 89 e5             	mov    %rsp,%rbp
    1efd:	48 83 ec 18          	sub    $0x18,%rsp
    1f01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1f05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f09:	48 83 e8 10          	sub    $0x10,%rax
    1f0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f11:	48 b8 d0 25 00 00 00 	movabs $0x25d0,%rax
    1f18:	00 00 00 
    1f1b:	48 8b 00             	mov    (%rax),%rax
    1f1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f22:	eb 2f                	jmp    1f53 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1f24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f28:	48 8b 00             	mov    (%rax),%rax
    1f2b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f2f:	72 17                	jb     1f48 <free+0x4f>
    1f31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f35:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f39:	72 2f                	jb     1f6a <free+0x71>
    1f3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f3f:	48 8b 00             	mov    (%rax),%rax
    1f42:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f46:	72 22                	jb     1f6a <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f4c:	48 8b 00             	mov    (%rax),%rax
    1f4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f57:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f5b:	73 c7                	jae    1f24 <free+0x2b>
    1f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f61:	48 8b 00             	mov    (%rax),%rax
    1f64:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f68:	73 ba                	jae    1f24 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f6e:	8b 40 08             	mov    0x8(%rax),%eax
    1f71:	89 c0                	mov    %eax,%eax
    1f73:	48 c1 e0 04          	shl    $0x4,%rax
    1f77:	48 89 c2             	mov    %rax,%rdx
    1f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f7e:	48 01 c2             	add    %rax,%rdx
    1f81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f85:	48 8b 00             	mov    (%rax),%rax
    1f88:	48 39 c2             	cmp    %rax,%rdx
    1f8b:	75 2d                	jne    1fba <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    1f8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f91:	8b 50 08             	mov    0x8(%rax),%edx
    1f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f98:	48 8b 00             	mov    (%rax),%rax
    1f9b:	8b 40 08             	mov    0x8(%rax),%eax
    1f9e:	01 c2                	add    %eax,%edx
    1fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fa4:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fab:	48 8b 00             	mov    (%rax),%rax
    1fae:	48 8b 10             	mov    (%rax),%rdx
    1fb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fb5:	48 89 10             	mov    %rdx,(%rax)
    1fb8:	eb 0e                	jmp    1fc8 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    1fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fbe:	48 8b 10             	mov    (%rax),%rdx
    1fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fc5:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fcc:	8b 40 08             	mov    0x8(%rax),%eax
    1fcf:	89 c0                	mov    %eax,%eax
    1fd1:	48 c1 e0 04          	shl    $0x4,%rax
    1fd5:	48 89 c2             	mov    %rax,%rdx
    1fd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fdc:	48 01 d0             	add    %rdx,%rax
    1fdf:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fe3:	75 27                	jne    200c <free+0x113>
    p->s.size += bp->s.size;
    1fe5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe9:	8b 50 08             	mov    0x8(%rax),%edx
    1fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ff0:	8b 40 08             	mov    0x8(%rax),%eax
    1ff3:	01 c2                	add    %eax,%edx
    1ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff9:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2000:	48 8b 10             	mov    (%rax),%rdx
    2003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2007:	48 89 10             	mov    %rdx,(%rax)
    200a:	eb 0b                	jmp    2017 <free+0x11e>
  } else
    p->s.ptr = bp;
    200c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2010:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2014:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    2017:	48 ba d0 25 00 00 00 	movabs $0x25d0,%rdx
    201e:	00 00 00 
    2021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2025:	48 89 02             	mov    %rax,(%rdx)
}
    2028:	90                   	nop
    2029:	c9                   	leave
    202a:	c3                   	ret

000000000000202b <morecore>:

static Header*
morecore(uint nu)
{
    202b:	55                   	push   %rbp
    202c:	48 89 e5             	mov    %rsp,%rbp
    202f:	48 83 ec 20          	sub    $0x20,%rsp
    2033:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2036:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    203d:	77 07                	ja     2046 <morecore+0x1b>
    nu = 4096;
    203f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2046:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2049:	48 c1 e0 04          	shl    $0x4,%rax
    204d:	48 89 c7             	mov    %rax,%rdi
    2050:	48 b8 c4 18 00 00 00 	movabs $0x18c4,%rax
    2057:	00 00 00 
    205a:	ff d0                	call   *%rax
    205c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    2060:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2065:	75 07                	jne    206e <morecore+0x43>
    return 0;
    2067:	b8 00 00 00 00       	mov    $0x0,%eax
    206c:	eb 36                	jmp    20a4 <morecore+0x79>
  hp = (Header*)p;
    206e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2072:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    207a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    207d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    2080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2084:	48 83 c0 10          	add    $0x10,%rax
    2088:	48 89 c7             	mov    %rax,%rdi
    208b:	48 b8 f9 1e 00 00 00 	movabs $0x1ef9,%rax
    2092:	00 00 00 
    2095:	ff d0                	call   *%rax
  return freep;
    2097:	48 b8 d0 25 00 00 00 	movabs $0x25d0,%rax
    209e:	00 00 00 
    20a1:	48 8b 00             	mov    (%rax),%rax
}
    20a4:	c9                   	leave
    20a5:	c3                   	ret

00000000000020a6 <malloc>:

void*
malloc(uint nbytes)
{
    20a6:	55                   	push   %rbp
    20a7:	48 89 e5             	mov    %rsp,%rbp
    20aa:	48 83 ec 30          	sub    $0x30,%rsp
    20ae:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    20b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    20b4:	48 83 c0 0f          	add    $0xf,%rax
    20b8:	48 c1 e8 04          	shr    $0x4,%rax
    20bc:	83 c0 01             	add    $0x1,%eax
    20bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    20c2:	48 b8 d0 25 00 00 00 	movabs $0x25d0,%rax
    20c9:	00 00 00 
    20cc:	48 8b 00             	mov    (%rax),%rax
    20cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20d3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20d8:	75 4a                	jne    2124 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    20da:	48 b8 c0 25 00 00 00 	movabs $0x25c0,%rax
    20e1:	00 00 00 
    20e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20e8:	48 ba d0 25 00 00 00 	movabs $0x25d0,%rdx
    20ef:	00 00 00 
    20f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20f6:	48 89 02             	mov    %rax,(%rdx)
    20f9:	48 b8 d0 25 00 00 00 	movabs $0x25d0,%rax
    2100:	00 00 00 
    2103:	48 8b 00             	mov    (%rax),%rax
    2106:	48 ba c0 25 00 00 00 	movabs $0x25c0,%rdx
    210d:	00 00 00 
    2110:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    2113:	48 b8 c0 25 00 00 00 	movabs $0x25c0,%rax
    211a:	00 00 00 
    211d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2128:	48 8b 00             	mov    (%rax),%rax
    212b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    212f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2133:	8b 40 08             	mov    0x8(%rax),%eax
    2136:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    2139:	72 65                	jb     21a0 <malloc+0xfa>
      if(p->s.size == nunits)
    213b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213f:	8b 40 08             	mov    0x8(%rax),%eax
    2142:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2145:	75 10                	jne    2157 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    2147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    214b:	48 8b 10             	mov    (%rax),%rdx
    214e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2152:	48 89 10             	mov    %rdx,(%rax)
    2155:	eb 2e                	jmp    2185 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    2157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    215b:	8b 40 08             	mov    0x8(%rax),%eax
    215e:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2161:	89 c2                	mov    %eax,%edx
    2163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2167:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    216a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    216e:	8b 40 08             	mov    0x8(%rax),%eax
    2171:	89 c0                	mov    %eax,%eax
    2173:	48 c1 e0 04          	shl    $0x4,%rax
    2177:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    217b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    217f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2182:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    2185:	48 ba d0 25 00 00 00 	movabs $0x25d0,%rdx
    218c:	00 00 00 
    218f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2193:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    2196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    219a:	48 83 c0 10          	add    $0x10,%rax
    219e:	eb 4e                	jmp    21ee <malloc+0x148>
    }
    if(p == freep)
    21a0:	48 b8 d0 25 00 00 00 	movabs $0x25d0,%rax
    21a7:	00 00 00 
    21aa:	48 8b 00             	mov    (%rax),%rax
    21ad:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    21b1:	75 23                	jne    21d6 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    21b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    21b6:	89 c7                	mov    %eax,%edi
    21b8:	48 b8 2b 20 00 00 00 	movabs $0x202b,%rax
    21bf:	00 00 00 
    21c2:	ff d0                	call   *%rax
    21c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    21c8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21cd:	75 07                	jne    21d6 <malloc+0x130>
        return 0;
    21cf:	b8 00 00 00 00       	mov    $0x0,%eax
    21d4:	eb 18                	jmp    21ee <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21e2:	48 8b 00             	mov    (%rax),%rax
    21e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21e9:	e9 41 ff ff ff       	jmp    212f <malloc+0x89>
  }
}
    21ee:	c9                   	leave
    21ef:	c3                   	ret
