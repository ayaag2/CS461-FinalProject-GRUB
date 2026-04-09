
_usertests:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <failexit>:
char name[3];
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };

void
failexit(const char * const msg)
{
    1000:	55                   	push   %rbp
    1001:	48 89 e5             	mov    %rsp,%rbp
    1004:	48 83 ec 10          	sub    $0x10,%rsp
    1008:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  printf(1, "!! FAILED %s\n", msg);
    100c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1010:	48 b9 f6 70 00 00 00 	movabs $0x70f6,%rcx
    1017:	00 00 00 
    101a:	48 89 c2             	mov    %rax,%rdx
    101d:	48 89 ce             	mov    %rcx,%rsi
    1020:	bf 01 00 00 00       	mov    $0x1,%edi
    1025:	b8 00 00 00 00       	mov    $0x0,%eax
    102a:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    1031:	00 00 00 
    1034:	ff d1                	call   *%rcx
  exit();
    1036:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    103d:	00 00 00 
    1040:	ff d0                	call   *%rax

0000000000001042 <iputtest>:
}

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
    1042:	55                   	push   %rbp
    1043:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "iput test\n");
    1046:	48 b8 04 71 00 00 00 	movabs $0x7104,%rax
    104d:	00 00 00 
    1050:	48 89 c6             	mov    %rax,%rsi
    1053:	bf 01 00 00 00       	mov    $0x1,%edi
    1058:	b8 00 00 00 00       	mov    $0x0,%eax
    105d:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1064:	00 00 00 
    1067:	ff d2                	call   *%rdx

  if(mkdir("iputdir") < 0){
    1069:	48 b8 0f 71 00 00 00 	movabs $0x710f,%rax
    1070:	00 00 00 
    1073:	48 89 c7             	mov    %rax,%rdi
    1076:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    107d:	00 00 00 
    1080:	ff d0                	call   *%rax
    1082:	85 c0                	test   %eax,%eax
    1084:	79 19                	jns    109f <iputtest+0x5d>
    failexit("mkdir");
    1086:	48 b8 17 71 00 00 00 	movabs $0x7117,%rax
    108d:	00 00 00 
    1090:	48 89 c7             	mov    %rax,%rdi
    1093:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    109a:	00 00 00 
    109d:	ff d0                	call   *%rax
  }
  if(chdir("iputdir") < 0){
    109f:	48 b8 0f 71 00 00 00 	movabs $0x710f,%rax
    10a6:	00 00 00 
    10a9:	48 89 c7             	mov    %rax,%rdi
    10ac:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    10b3:	00 00 00 
    10b6:	ff d0                	call   *%rax
    10b8:	85 c0                	test   %eax,%eax
    10ba:	79 19                	jns    10d5 <iputtest+0x93>
    failexit("chdir iputdir");
    10bc:	48 b8 1d 71 00 00 00 	movabs $0x711d,%rax
    10c3:	00 00 00 
    10c6:	48 89 c7             	mov    %rax,%rdi
    10c9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    10d0:	00 00 00 
    10d3:	ff d0                	call   *%rax
  }
  if(unlink("../iputdir") < 0){
    10d5:	48 b8 2b 71 00 00 00 	movabs $0x712b,%rax
    10dc:	00 00 00 
    10df:	48 89 c7             	mov    %rax,%rdi
    10e2:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    10e9:	00 00 00 
    10ec:	ff d0                	call   *%rax
    10ee:	85 c0                	test   %eax,%eax
    10f0:	79 19                	jns    110b <iputtest+0xc9>
    failexit("unlink ../iputdir");
    10f2:	48 b8 36 71 00 00 00 	movabs $0x7136,%rax
    10f9:	00 00 00 
    10fc:	48 89 c7             	mov    %rax,%rdi
    10ff:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1106:	00 00 00 
    1109:	ff d0                	call   *%rax
  }
  if(chdir("/") < 0){
    110b:	48 b8 48 71 00 00 00 	movabs $0x7148,%rax
    1112:	00 00 00 
    1115:	48 89 c7             	mov    %rax,%rdi
    1118:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    111f:	00 00 00 
    1122:	ff d0                	call   *%rax
    1124:	85 c0                	test   %eax,%eax
    1126:	79 19                	jns    1141 <iputtest+0xff>
    failexit("chdir /");
    1128:	48 b8 4a 71 00 00 00 	movabs $0x714a,%rax
    112f:	00 00 00 
    1132:	48 89 c7             	mov    %rax,%rdi
    1135:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    113c:	00 00 00 
    113f:	ff d0                	call   *%rax
  }
  printf(1, "iput test ok\n");
    1141:	48 b8 52 71 00 00 00 	movabs $0x7152,%rax
    1148:	00 00 00 
    114b:	48 89 c6             	mov    %rax,%rsi
    114e:	bf 01 00 00 00       	mov    $0x1,%edi
    1153:	b8 00 00 00 00       	mov    $0x0,%eax
    1158:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    115f:	00 00 00 
    1162:	ff d2                	call   *%rdx
}
    1164:	90                   	nop
    1165:	5d                   	pop    %rbp
    1166:	c3                   	ret

0000000000001167 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
    1167:	55                   	push   %rbp
    1168:	48 89 e5             	mov    %rsp,%rbp
    116b:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  printf(1, "exitiput test\n");
    116f:	48 b8 60 71 00 00 00 	movabs $0x7160,%rax
    1176:	00 00 00 
    1179:	48 89 c6             	mov    %rax,%rsi
    117c:	bf 01 00 00 00       	mov    $0x1,%edi
    1181:	b8 00 00 00 00       	mov    $0x0,%eax
    1186:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    118d:	00 00 00 
    1190:	ff d2                	call   *%rdx

  pid = fork();
    1192:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    1199:	00 00 00 
    119c:	ff d0                	call   *%rax
    119e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid < 0){
    11a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    11a5:	79 19                	jns    11c0 <exitiputtest+0x59>
    failexit("fork");
    11a7:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    11ae:	00 00 00 
    11b1:	48 89 c7             	mov    %rax,%rdi
    11b4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11bb:	00 00 00 
    11be:	ff d0                	call   *%rax
  }
  if(pid == 0){
    11c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    11c4:	0f 85 ae 00 00 00    	jne    1278 <exitiputtest+0x111>
    if(mkdir("iputdir") < 0){
    11ca:	48 b8 0f 71 00 00 00 	movabs $0x710f,%rax
    11d1:	00 00 00 
    11d4:	48 89 c7             	mov    %rax,%rdi
    11d7:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    11de:	00 00 00 
    11e1:	ff d0                	call   *%rax
    11e3:	85 c0                	test   %eax,%eax
    11e5:	79 19                	jns    1200 <exitiputtest+0x99>
      failexit("mkdir");
    11e7:	48 b8 17 71 00 00 00 	movabs $0x7117,%rax
    11ee:	00 00 00 
    11f1:	48 89 c7             	mov    %rax,%rdi
    11f4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    11fb:	00 00 00 
    11fe:	ff d0                	call   *%rax
    }
    if(chdir("iputdir") < 0){
    1200:	48 b8 0f 71 00 00 00 	movabs $0x710f,%rax
    1207:	00 00 00 
    120a:	48 89 c7             	mov    %rax,%rdi
    120d:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    1214:	00 00 00 
    1217:	ff d0                	call   *%rax
    1219:	85 c0                	test   %eax,%eax
    121b:	79 19                	jns    1236 <exitiputtest+0xcf>
      failexit("child chdir");
    121d:	48 b8 74 71 00 00 00 	movabs $0x7174,%rax
    1224:	00 00 00 
    1227:	48 89 c7             	mov    %rax,%rdi
    122a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1231:	00 00 00 
    1234:	ff d0                	call   *%rax
    }
    if(unlink("../iputdir") < 0){
    1236:	48 b8 2b 71 00 00 00 	movabs $0x712b,%rax
    123d:	00 00 00 
    1240:	48 89 c7             	mov    %rax,%rdi
    1243:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    124a:	00 00 00 
    124d:	ff d0                	call   *%rax
    124f:	85 c0                	test   %eax,%eax
    1251:	79 19                	jns    126c <exitiputtest+0x105>
      failexit("unlink ../iputdir");
    1253:	48 b8 36 71 00 00 00 	movabs $0x7136,%rax
    125a:	00 00 00 
    125d:	48 89 c7             	mov    %rax,%rdi
    1260:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1267:	00 00 00 
    126a:	ff d0                	call   *%rax
    }
    exit();
    126c:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1273:	00 00 00 
    1276:	ff d0                	call   *%rax
  }
  wait();
    1278:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    127f:	00 00 00 
    1282:	ff d0                	call   *%rax
  printf(1, "exitiput test ok\n");
    1284:	48 b8 80 71 00 00 00 	movabs $0x7180,%rax
    128b:	00 00 00 
    128e:	48 89 c6             	mov    %rax,%rsi
    1291:	bf 01 00 00 00       	mov    $0x1,%edi
    1296:	b8 00 00 00 00       	mov    $0x0,%eax
    129b:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    12a2:	00 00 00 
    12a5:	ff d2                	call   *%rdx
}
    12a7:	90                   	nop
    12a8:	c9                   	leave
    12a9:	c3                   	ret

00000000000012aa <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
    12aa:	55                   	push   %rbp
    12ab:	48 89 e5             	mov    %rsp,%rbp
    12ae:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  printf(1, "openiput test\n");
    12b2:	48 b8 92 71 00 00 00 	movabs $0x7192,%rax
    12b9:	00 00 00 
    12bc:	48 89 c6             	mov    %rax,%rsi
    12bf:	bf 01 00 00 00       	mov    $0x1,%edi
    12c4:	b8 00 00 00 00       	mov    $0x0,%eax
    12c9:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    12d0:	00 00 00 
    12d3:	ff d2                	call   *%rdx
  if(mkdir("oidir") < 0){
    12d5:	48 b8 a1 71 00 00 00 	movabs $0x71a1,%rax
    12dc:	00 00 00 
    12df:	48 89 c7             	mov    %rax,%rdi
    12e2:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    12e9:	00 00 00 
    12ec:	ff d0                	call   *%rax
    12ee:	85 c0                	test   %eax,%eax
    12f0:	79 19                	jns    130b <openiputtest+0x61>
    failexit("mkdir oidir");
    12f2:	48 b8 a7 71 00 00 00 	movabs $0x71a7,%rax
    12f9:	00 00 00 
    12fc:	48 89 c7             	mov    %rax,%rdi
    12ff:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1306:	00 00 00 
    1309:	ff d0                	call   *%rax
  }
  pid = fork();
    130b:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    1312:	00 00 00 
    1315:	ff d0                	call   *%rax
    1317:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid < 0){
    131a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    131e:	79 19                	jns    1339 <openiputtest+0x8f>
    failexit("fork");
    1320:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    1327:	00 00 00 
    132a:	48 89 c7             	mov    %rax,%rdi
    132d:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1334:	00 00 00 
    1337:	ff d0                	call   *%rax
  }
  if(pid == 0){
    1339:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    133d:	75 4c                	jne    138b <openiputtest+0xe1>
    int fd = open("oidir", O_RDWR);
    133f:	48 b8 a1 71 00 00 00 	movabs $0x71a1,%rax
    1346:	00 00 00 
    1349:	be 02 00 00 00       	mov    $0x2,%esi
    134e:	48 89 c7             	mov    %rax,%rdi
    1351:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    1358:	00 00 00 
    135b:	ff d0                	call   *%rax
    135d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0){
    1360:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1364:	78 19                	js     137f <openiputtest+0xd5>
      failexit("open directory for write succeeded");
    1366:	48 b8 b8 71 00 00 00 	movabs $0x71b8,%rax
    136d:	00 00 00 
    1370:	48 89 c7             	mov    %rax,%rdi
    1373:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    137a:	00 00 00 
    137d:	ff d0                	call   *%rax
    }
    exit();
    137f:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1386:	00 00 00 
    1389:	ff d0                	call   *%rax
  }
  sleep(1);
    138b:	bf 01 00 00 00       	mov    $0x1,%edi
    1390:	48 b8 9a 67 00 00 00 	movabs $0x679a,%rax
    1397:	00 00 00 
    139a:	ff d0                	call   *%rax
  if(unlink("oidir") != 0){
    139c:	48 b8 a1 71 00 00 00 	movabs $0x71a1,%rax
    13a3:	00 00 00 
    13a6:	48 89 c7             	mov    %rax,%rdi
    13a9:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    13b0:	00 00 00 
    13b3:	ff d0                	call   *%rax
    13b5:	85 c0                	test   %eax,%eax
    13b7:	74 19                	je     13d2 <openiputtest+0x128>
    failexit("unlink");
    13b9:	48 b8 db 71 00 00 00 	movabs $0x71db,%rax
    13c0:	00 00 00 
    13c3:	48 89 c7             	mov    %rax,%rdi
    13c6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    13cd:	00 00 00 
    13d0:	ff d0                	call   *%rax
  }
  wait();
    13d2:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    13d9:	00 00 00 
    13dc:	ff d0                	call   *%rax
  printf(1, "openiput test ok\n");
    13de:	48 b8 e2 71 00 00 00 	movabs $0x71e2,%rax
    13e5:	00 00 00 
    13e8:	48 89 c6             	mov    %rax,%rsi
    13eb:	bf 01 00 00 00       	mov    $0x1,%edi
    13f0:	b8 00 00 00 00       	mov    $0x0,%eax
    13f5:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    13fc:	00 00 00 
    13ff:	ff d2                	call   *%rdx
}
    1401:	90                   	nop
    1402:	c9                   	leave
    1403:	c3                   	ret

0000000000001404 <opentest>:

// simple file system tests

void
opentest(void)
{
    1404:	55                   	push   %rbp
    1405:	48 89 e5             	mov    %rsp,%rbp
    1408:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  printf(1, "open test\n");
    140c:	48 b8 f4 71 00 00 00 	movabs $0x71f4,%rax
    1413:	00 00 00 
    1416:	48 89 c6             	mov    %rax,%rsi
    1419:	bf 01 00 00 00       	mov    $0x1,%edi
    141e:	b8 00 00 00 00       	mov    $0x0,%eax
    1423:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    142a:	00 00 00 
    142d:	ff d2                	call   *%rdx
  fd = open("echo", 0);
    142f:	48 b8 e0 70 00 00 00 	movabs $0x70e0,%rax
    1436:	00 00 00 
    1439:	be 00 00 00 00       	mov    $0x0,%esi
    143e:	48 89 c7             	mov    %rax,%rdi
    1441:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    1448:	00 00 00 
    144b:	ff d0                	call   *%rax
    144d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    1450:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1454:	79 19                	jns    146f <opentest+0x6b>
    failexit("open echo");
    1456:	48 b8 ff 71 00 00 00 	movabs $0x71ff,%rax
    145d:	00 00 00 
    1460:	48 89 c7             	mov    %rax,%rdi
    1463:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    146a:	00 00 00 
    146d:	ff d0                	call   *%rax
  }
  close(fd);
    146f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1472:	89 c7                	mov    %eax,%edi
    1474:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    147b:	00 00 00 
    147e:	ff d0                	call   *%rax
  fd = open("doesnotexist", 0);
    1480:	48 b8 09 72 00 00 00 	movabs $0x7209,%rax
    1487:	00 00 00 
    148a:	be 00 00 00 00       	mov    $0x0,%esi
    148f:	48 89 c7             	mov    %rax,%rdi
    1492:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    1499:	00 00 00 
    149c:	ff d0                	call   *%rax
    149e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    14a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    14a5:	78 19                	js     14c0 <opentest+0xbc>
    failexit("open doesnotexist succeeded!");
    14a7:	48 b8 16 72 00 00 00 	movabs $0x7216,%rax
    14ae:	00 00 00 
    14b1:	48 89 c7             	mov    %rax,%rdi
    14b4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    14bb:	00 00 00 
    14be:	ff d0                	call   *%rax
  }
  printf(1, "open test ok\n");
    14c0:	48 b8 33 72 00 00 00 	movabs $0x7233,%rax
    14c7:	00 00 00 
    14ca:	48 89 c6             	mov    %rax,%rsi
    14cd:	bf 01 00 00 00       	mov    $0x1,%edi
    14d2:	b8 00 00 00 00       	mov    $0x0,%eax
    14d7:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    14de:	00 00 00 
    14e1:	ff d2                	call   *%rdx
}
    14e3:	90                   	nop
    14e4:	c9                   	leave
    14e5:	c3                   	ret

00000000000014e6 <writetest>:

void
writetest(void)
{
    14e6:	55                   	push   %rbp
    14e7:	48 89 e5             	mov    %rsp,%rbp
    14ea:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  int i;

  printf(1, "small file test\n");
    14ee:	48 b8 41 72 00 00 00 	movabs $0x7241,%rax
    14f5:	00 00 00 
    14f8:	48 89 c6             	mov    %rax,%rsi
    14fb:	bf 01 00 00 00       	mov    $0x1,%edi
    1500:	b8 00 00 00 00       	mov    $0x0,%eax
    1505:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    150c:	00 00 00 
    150f:	ff d2                	call   *%rdx
  fd = open("small", O_CREATE|O_RDWR);
    1511:	48 b8 52 72 00 00 00 	movabs $0x7252,%rax
    1518:	00 00 00 
    151b:	be 02 02 00 00       	mov    $0x202,%esi
    1520:	48 89 c7             	mov    %rax,%rdi
    1523:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    152a:	00 00 00 
    152d:	ff d0                	call   *%rax
    152f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(fd < 0){
    1532:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1536:	79 19                	jns    1551 <writetest+0x6b>
    failexit("error: creat small");
    1538:	48 b8 58 72 00 00 00 	movabs $0x7258,%rax
    153f:	00 00 00 
    1542:	48 89 c7             	mov    %rax,%rdi
    1545:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    154c:	00 00 00 
    154f:	ff d0                	call   *%rax
  }
  for(i = 0; i < 100; i++){
    1551:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1558:	e9 bc 00 00 00       	jmp    1619 <writetest+0x133>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
    155d:	48 b9 6b 72 00 00 00 	movabs $0x726b,%rcx
    1564:	00 00 00 
    1567:	8b 45 f8             	mov    -0x8(%rbp),%eax
    156a:	ba 0a 00 00 00       	mov    $0xa,%edx
    156f:	48 89 ce             	mov    %rcx,%rsi
    1572:	89 c7                	mov    %eax,%edi
    1574:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    157b:	00 00 00 
    157e:	ff d0                	call   *%rax
    1580:	83 f8 0a             	cmp    $0xa,%eax
    1583:	74 34                	je     15b9 <writetest+0xd3>
      printf(1, "error: write aa %d new file failed\n", i);
    1585:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1588:	48 b9 78 72 00 00 00 	movabs $0x7278,%rcx
    158f:	00 00 00 
    1592:	89 c2                	mov    %eax,%edx
    1594:	48 89 ce             	mov    %rcx,%rsi
    1597:	bf 01 00 00 00       	mov    $0x1,%edi
    159c:	b8 00 00 00 00       	mov    $0x0,%eax
    15a1:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    15a8:	00 00 00 
    15ab:	ff d1                	call   *%rcx
      exit();
    15ad:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    15b4:	00 00 00 
    15b7:	ff d0                	call   *%rax
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
    15b9:	48 b9 9c 72 00 00 00 	movabs $0x729c,%rcx
    15c0:	00 00 00 
    15c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
    15c6:	ba 0a 00 00 00       	mov    $0xa,%edx
    15cb:	48 89 ce             	mov    %rcx,%rsi
    15ce:	89 c7                	mov    %eax,%edi
    15d0:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    15d7:	00 00 00 
    15da:	ff d0                	call   *%rax
    15dc:	83 f8 0a             	cmp    $0xa,%eax
    15df:	74 34                	je     1615 <writetest+0x12f>
      printf(1, "error: write bb %d new file failed\n", i);
    15e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15e4:	48 b9 a8 72 00 00 00 	movabs $0x72a8,%rcx
    15eb:	00 00 00 
    15ee:	89 c2                	mov    %eax,%edx
    15f0:	48 89 ce             	mov    %rcx,%rsi
    15f3:	bf 01 00 00 00       	mov    $0x1,%edi
    15f8:	b8 00 00 00 00       	mov    $0x0,%eax
    15fd:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    1604:	00 00 00 
    1607:	ff d1                	call   *%rcx
      exit();
    1609:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1610:	00 00 00 
    1613:	ff d0                	call   *%rax
  for(i = 0; i < 100; i++){
    1615:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1619:	83 7d fc 63          	cmpl   $0x63,-0x4(%rbp)
    161d:	0f 8e 3a ff ff ff    	jle    155d <writetest+0x77>
    }
  }
  close(fd);
    1623:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1626:	89 c7                	mov    %eax,%edi
    1628:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    162f:	00 00 00 
    1632:	ff d0                	call   *%rax
  fd = open("small", O_RDONLY);
    1634:	48 b8 52 72 00 00 00 	movabs $0x7252,%rax
    163b:	00 00 00 
    163e:	be 00 00 00 00       	mov    $0x0,%esi
    1643:	48 89 c7             	mov    %rax,%rdi
    1646:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    164d:	00 00 00 
    1650:	ff d0                	call   *%rax
    1652:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(fd < 0){
    1655:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1659:	79 19                	jns    1674 <writetest+0x18e>
    failexit("error: open small");
    165b:	48 b8 cc 72 00 00 00 	movabs $0x72cc,%rax
    1662:	00 00 00 
    1665:	48 89 c7             	mov    %rax,%rdi
    1668:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    166f:	00 00 00 
    1672:	ff d0                	call   *%rax
  }
  i = read(fd, buf, 2000);
    1674:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    167b:	00 00 00 
    167e:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1681:	ba d0 07 00 00       	mov    $0x7d0,%edx
    1686:	48 89 ce             	mov    %rcx,%rsi
    1689:	89 c7                	mov    %eax,%edi
    168b:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    1692:	00 00 00 
    1695:	ff d0                	call   *%rax
    1697:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(i != 2000){
    169a:	81 7d fc d0 07 00 00 	cmpl   $0x7d0,-0x4(%rbp)
    16a1:	74 19                	je     16bc <writetest+0x1d6>
    failexit("read");
    16a3:	48 b8 de 72 00 00 00 	movabs $0x72de,%rax
    16aa:	00 00 00 
    16ad:	48 89 c7             	mov    %rax,%rdi
    16b0:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    16b7:	00 00 00 
    16ba:	ff d0                	call   *%rax
  }
  close(fd);
    16bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
    16bf:	89 c7                	mov    %eax,%edi
    16c1:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    16c8:	00 00 00 
    16cb:	ff d0                	call   *%rax

  if(unlink("small") < 0){
    16cd:	48 b8 52 72 00 00 00 	movabs $0x7252,%rax
    16d4:	00 00 00 
    16d7:	48 89 c7             	mov    %rax,%rdi
    16da:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    16e1:	00 00 00 
    16e4:	ff d0                	call   *%rax
    16e6:	85 c0                	test   %eax,%eax
    16e8:	79 25                	jns    170f <writetest+0x229>
    failexit("unlink small");
    16ea:	48 b8 e3 72 00 00 00 	movabs $0x72e3,%rax
    16f1:	00 00 00 
    16f4:	48 89 c7             	mov    %rax,%rdi
    16f7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    16fe:	00 00 00 
    1701:	ff d0                	call   *%rax
    exit();
    1703:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    170a:	00 00 00 
    170d:	ff d0                	call   *%rax
  }
  printf(1, "small file test ok\n");
    170f:	48 b8 f0 72 00 00 00 	movabs $0x72f0,%rax
    1716:	00 00 00 
    1719:	48 89 c6             	mov    %rax,%rsi
    171c:	bf 01 00 00 00       	mov    $0x1,%edi
    1721:	b8 00 00 00 00       	mov    $0x0,%eax
    1726:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    172d:	00 00 00 
    1730:	ff d2                	call   *%rdx
}
    1732:	90                   	nop
    1733:	c9                   	leave
    1734:	c3                   	ret

0000000000001735 <writetest1>:

void
writetest1(void)
{
    1735:	55                   	push   %rbp
    1736:	48 89 e5             	mov    %rsp,%rbp
    1739:	48 83 ec 10          	sub    $0x10,%rsp
  int i, fd, n;

  printf(1, "big files test\n");
    173d:	48 b8 04 73 00 00 00 	movabs $0x7304,%rax
    1744:	00 00 00 
    1747:	48 89 c6             	mov    %rax,%rsi
    174a:	bf 01 00 00 00       	mov    $0x1,%edi
    174f:	b8 00 00 00 00       	mov    $0x0,%eax
    1754:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    175b:	00 00 00 
    175e:	ff d2                	call   *%rdx

  fd = open("big", O_CREATE|O_RDWR);
    1760:	48 b8 14 73 00 00 00 	movabs $0x7314,%rax
    1767:	00 00 00 
    176a:	be 02 02 00 00       	mov    $0x202,%esi
    176f:	48 89 c7             	mov    %rax,%rdi
    1772:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    1779:	00 00 00 
    177c:	ff d0                	call   *%rax
    177e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    1781:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1785:	79 19                	jns    17a0 <writetest1+0x6b>
    failexit("error: creat big");
    1787:	48 b8 18 73 00 00 00 	movabs $0x7318,%rax
    178e:	00 00 00 
    1791:	48 89 c7             	mov    %rax,%rdi
    1794:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    179b:	00 00 00 
    179e:	ff d0                	call   *%rax
  }

  for(i = 0; i < MAXFILE; i++){
    17a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    17a7:	eb 56                	jmp    17ff <writetest1+0xca>
    ((int*)buf)[0] = i;
    17a9:	48 ba 80 87 00 00 00 	movabs $0x8780,%rdx
    17b0:	00 00 00 
    17b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
    17b6:	89 02                	mov    %eax,(%rdx)
    if(write(fd, buf, 512) != 512){
    17b8:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    17bf:	00 00 00 
    17c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17c5:	ba 00 02 00 00       	mov    $0x200,%edx
    17ca:	48 89 ce             	mov    %rcx,%rsi
    17cd:	89 c7                	mov    %eax,%edi
    17cf:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    17d6:	00 00 00 
    17d9:	ff d0                	call   *%rax
    17db:	3d 00 02 00 00       	cmp    $0x200,%eax
    17e0:	74 19                	je     17fb <writetest1+0xc6>
      failexit("error: write big file");
    17e2:	48 b8 29 73 00 00 00 	movabs $0x7329,%rax
    17e9:	00 00 00 
    17ec:	48 89 c7             	mov    %rax,%rdi
    17ef:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    17f6:	00 00 00 
    17f9:	ff d0                	call   *%rax
  for(i = 0; i < MAXFILE; i++){
    17fb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    17ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1802:	3d 8b 00 00 00       	cmp    $0x8b,%eax
    1807:	76 a0                	jbe    17a9 <writetest1+0x74>
    }
  }

  close(fd);
    1809:	8b 45 f4             	mov    -0xc(%rbp),%eax
    180c:	89 c7                	mov    %eax,%edi
    180e:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    1815:	00 00 00 
    1818:	ff d0                	call   *%rax

  fd = open("big", O_RDONLY);
    181a:	48 b8 14 73 00 00 00 	movabs $0x7314,%rax
    1821:	00 00 00 
    1824:	be 00 00 00 00       	mov    $0x0,%esi
    1829:	48 89 c7             	mov    %rax,%rdi
    182c:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    1833:	00 00 00 
    1836:	ff d0                	call   *%rax
    1838:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    183b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    183f:	79 19                	jns    185a <writetest1+0x125>
    failexit("error: open big");
    1841:	48 b8 3f 73 00 00 00 	movabs $0x733f,%rax
    1848:	00 00 00 
    184b:	48 89 c7             	mov    %rax,%rdi
    184e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1855:	00 00 00 
    1858:	ff d0                	call   *%rax
  }

  n = 0;
    185a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(;;){
    i = read(fd, buf, 512);
    1861:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    1868:	00 00 00 
    186b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    186e:	ba 00 02 00 00       	mov    $0x200,%edx
    1873:	48 89 ce             	mov    %rcx,%rsi
    1876:	89 c7                	mov    %eax,%edi
    1878:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    187f:	00 00 00 
    1882:	ff d0                	call   *%rax
    1884:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(i == 0){
    1887:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    188b:	75 41                	jne    18ce <writetest1+0x199>
      if(n == MAXFILE - 1){
    188d:	81 7d f8 8b 00 00 00 	cmpl   $0x8b,-0x8(%rbp)
    1894:	0f 85 cb 00 00 00    	jne    1965 <writetest1+0x230>
        printf(1, "read only %d blocks from big. failed", n);
    189a:	8b 45 f8             	mov    -0x8(%rbp),%eax
    189d:	48 b9 50 73 00 00 00 	movabs $0x7350,%rcx
    18a4:	00 00 00 
    18a7:	89 c2                	mov    %eax,%edx
    18a9:	48 89 ce             	mov    %rcx,%rsi
    18ac:	bf 01 00 00 00       	mov    $0x1,%edi
    18b1:	b8 00 00 00 00       	mov    $0x0,%eax
    18b6:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    18bd:	00 00 00 
    18c0:	ff d1                	call   *%rcx
        exit();
    18c2:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    18c9:	00 00 00 
    18cc:	ff d0                	call   *%rax
      }
      break;
    } else if(i != 512){
    18ce:	81 7d fc 00 02 00 00 	cmpl   $0x200,-0x4(%rbp)
    18d5:	74 34                	je     190b <writetest1+0x1d6>
      printf(1, "read failed %d\n", i);
    18d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    18da:	48 b9 75 73 00 00 00 	movabs $0x7375,%rcx
    18e1:	00 00 00 
    18e4:	89 c2                	mov    %eax,%edx
    18e6:	48 89 ce             	mov    %rcx,%rsi
    18e9:	bf 01 00 00 00       	mov    $0x1,%edi
    18ee:	b8 00 00 00 00       	mov    $0x0,%eax
    18f3:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    18fa:	00 00 00 
    18fd:	ff d1                	call   *%rcx
      exit();
    18ff:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1906:	00 00 00 
    1909:	ff d0                	call   *%rax
    }
    if(((int*)buf)[0] != n){
    190b:	48 b8 80 87 00 00 00 	movabs $0x8780,%rax
    1912:	00 00 00 
    1915:	8b 00                	mov    (%rax),%eax
    1917:	39 45 f8             	cmp    %eax,-0x8(%rbp)
    191a:	74 40                	je     195c <writetest1+0x227>
      printf(1, "read content of block %d is %d. failed\n",
             n, ((int*)buf)[0]);
    191c:	48 b8 80 87 00 00 00 	movabs $0x8780,%rax
    1923:	00 00 00 
      printf(1, "read content of block %d is %d. failed\n",
    1926:	8b 10                	mov    (%rax),%edx
    1928:	8b 45 f8             	mov    -0x8(%rbp),%eax
    192b:	48 be 88 73 00 00 00 	movabs $0x7388,%rsi
    1932:	00 00 00 
    1935:	89 d1                	mov    %edx,%ecx
    1937:	89 c2                	mov    %eax,%edx
    1939:	bf 01 00 00 00       	mov    $0x1,%edi
    193e:	b8 00 00 00 00       	mov    $0x0,%eax
    1943:	49 b8 be 69 00 00 00 	movabs $0x69be,%r8
    194a:	00 00 00 
    194d:	41 ff d0             	call   *%r8
      exit();
    1950:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1957:	00 00 00 
    195a:	ff d0                	call   *%rax
    }
    n++;
    195c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    i = read(fd, buf, 512);
    1960:	e9 fc fe ff ff       	jmp    1861 <writetest1+0x12c>
      break;
    1965:	90                   	nop
  }
  close(fd);
    1966:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1969:	89 c7                	mov    %eax,%edi
    196b:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    1972:	00 00 00 
    1975:	ff d0                	call   *%rax
  if(unlink("big") < 0){
    1977:	48 b8 14 73 00 00 00 	movabs $0x7314,%rax
    197e:	00 00 00 
    1981:	48 89 c7             	mov    %rax,%rdi
    1984:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    198b:	00 00 00 
    198e:	ff d0                	call   *%rax
    1990:	85 c0                	test   %eax,%eax
    1992:	79 25                	jns    19b9 <writetest1+0x284>
    failexit("unlink big");
    1994:	48 b8 b0 73 00 00 00 	movabs $0x73b0,%rax
    199b:	00 00 00 
    199e:	48 89 c7             	mov    %rax,%rdi
    19a1:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    19a8:	00 00 00 
    19ab:	ff d0                	call   *%rax
    exit();
    19ad:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    19b4:	00 00 00 
    19b7:	ff d0                	call   *%rax
  }
  printf(1, "big files ok\n");
    19b9:	48 b8 bb 73 00 00 00 	movabs $0x73bb,%rax
    19c0:	00 00 00 
    19c3:	48 89 c6             	mov    %rax,%rsi
    19c6:	bf 01 00 00 00       	mov    $0x1,%edi
    19cb:	b8 00 00 00 00       	mov    $0x0,%eax
    19d0:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    19d7:	00 00 00 
    19da:	ff d2                	call   *%rdx
}
    19dc:	90                   	nop
    19dd:	c9                   	leave
    19de:	c3                   	ret

00000000000019df <createtest>:

void
createtest(void)
{
    19df:	55                   	push   %rbp
    19e0:	48 89 e5             	mov    %rsp,%rbp
    19e3:	48 83 ec 10          	sub    $0x10,%rsp
  int i, fd;

  printf(1, "many creates, followed by unlink test\n");
    19e7:	48 b8 d0 73 00 00 00 	movabs $0x73d0,%rax
    19ee:	00 00 00 
    19f1:	48 89 c6             	mov    %rax,%rsi
    19f4:	bf 01 00 00 00       	mov    $0x1,%edi
    19f9:	b8 00 00 00 00       	mov    $0x0,%eax
    19fe:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1a05:	00 00 00 
    1a08:	ff d2                	call   *%rdx

  name[0] = 'a';
    1a0a:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1a11:	00 00 00 
    1a14:	c6 00 61             	movb   $0x61,(%rax)
  name[2] = '\0';
    1a17:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1a1e:	00 00 00 
    1a21:	c6 40 02 00          	movb   $0x0,0x2(%rax)
  for(i = 0; i < 52; i++){
    1a25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1a2c:	eb 4b                	jmp    1a79 <createtest+0x9a>
    name[1] = '0' + i;
    1a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1a31:	83 c0 30             	add    $0x30,%eax
    1a34:	89 c2                	mov    %eax,%edx
    1a36:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1a3d:	00 00 00 
    1a40:	88 50 01             	mov    %dl,0x1(%rax)
    fd = open(name, O_CREATE|O_RDWR);
    1a43:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1a4a:	00 00 00 
    1a4d:	be 02 02 00 00       	mov    $0x202,%esi
    1a52:	48 89 c7             	mov    %rax,%rdi
    1a55:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    1a5c:	00 00 00 
    1a5f:	ff d0                	call   *%rax
    1a61:	89 45 f8             	mov    %eax,-0x8(%rbp)
    close(fd);
    1a64:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1a67:	89 c7                	mov    %eax,%edi
    1a69:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    1a70:	00 00 00 
    1a73:	ff d0                	call   *%rax
  for(i = 0; i < 52; i++){
    1a75:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1a79:	83 7d fc 33          	cmpl   $0x33,-0x4(%rbp)
    1a7d:	7e af                	jle    1a2e <createtest+0x4f>
  }
  for(i = 0; i < 52; i++){
    1a7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1a86:	eb 32                	jmp    1aba <createtest+0xdb>
    name[1] = '0' + i;
    1a88:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1a8b:	83 c0 30             	add    $0x30,%eax
    1a8e:	89 c2                	mov    %eax,%edx
    1a90:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1a97:	00 00 00 
    1a9a:	88 50 01             	mov    %dl,0x1(%rax)
    unlink(name);
    1a9d:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1aa4:	00 00 00 
    1aa7:	48 89 c7             	mov    %rax,%rdi
    1aaa:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    1ab1:	00 00 00 
    1ab4:	ff d0                	call   *%rax
  for(i = 0; i < 52; i++){
    1ab6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1aba:	83 7d fc 33          	cmpl   $0x33,-0x4(%rbp)
    1abe:	7e c8                	jle    1a88 <createtest+0xa9>
  }
  for(i = 0; i < 52; i++){
    1ac0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1ac7:	eb 59                	jmp    1b22 <createtest+0x143>
    name[1] = '0' + i;
    1ac9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1acc:	83 c0 30             	add    $0x30,%eax
    1acf:	89 c2                	mov    %eax,%edx
    1ad1:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1ad8:	00 00 00 
    1adb:	88 50 01             	mov    %dl,0x1(%rax)
    fd = open(name, O_RDWR);
    1ade:	48 b8 80 a7 00 00 00 	movabs $0xa780,%rax
    1ae5:	00 00 00 
    1ae8:	be 02 00 00 00       	mov    $0x2,%esi
    1aed:	48 89 c7             	mov    %rax,%rdi
    1af0:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    1af7:	00 00 00 
    1afa:	ff d0                	call   *%rax
    1afc:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0) {
    1aff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1b03:	78 19                	js     1b1e <createtest+0x13f>
      failexit("open should fail.");
    1b05:	48 b8 f7 73 00 00 00 	movabs $0x73f7,%rax
    1b0c:	00 00 00 
    1b0f:	48 89 c7             	mov    %rax,%rdi
    1b12:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1b19:	00 00 00 
    1b1c:	ff d0                	call   *%rax
  for(i = 0; i < 52; i++){
    1b1e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1b22:	83 7d fc 33          	cmpl   $0x33,-0x4(%rbp)
    1b26:	7e a1                	jle    1ac9 <createtest+0xea>
    }
  }

  printf(1, "many creates, followed by unlink; ok\n");
    1b28:	48 b8 10 74 00 00 00 	movabs $0x7410,%rax
    1b2f:	00 00 00 
    1b32:	48 89 c6             	mov    %rax,%rsi
    1b35:	bf 01 00 00 00       	mov    $0x1,%edi
    1b3a:	b8 00 00 00 00       	mov    $0x0,%eax
    1b3f:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1b46:	00 00 00 
    1b49:	ff d2                	call   *%rdx
}
    1b4b:	90                   	nop
    1b4c:	c9                   	leave
    1b4d:	c3                   	ret

0000000000001b4e <dirtest>:

void dirtest(void)
{
    1b4e:	55                   	push   %rbp
    1b4f:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "mkdir test\n");
    1b52:	48 b8 36 74 00 00 00 	movabs $0x7436,%rax
    1b59:	00 00 00 
    1b5c:	48 89 c6             	mov    %rax,%rsi
    1b5f:	bf 01 00 00 00       	mov    $0x1,%edi
    1b64:	b8 00 00 00 00       	mov    $0x0,%eax
    1b69:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1b70:	00 00 00 
    1b73:	ff d2                	call   *%rdx

  if(mkdir("dir0") < 0){
    1b75:	48 b8 42 74 00 00 00 	movabs $0x7442,%rax
    1b7c:	00 00 00 
    1b7f:	48 89 c7             	mov    %rax,%rdi
    1b82:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    1b89:	00 00 00 
    1b8c:	ff d0                	call   *%rax
    1b8e:	85 c0                	test   %eax,%eax
    1b90:	79 19                	jns    1bab <dirtest+0x5d>
    failexit("mkdir");
    1b92:	48 b8 17 71 00 00 00 	movabs $0x7117,%rax
    1b99:	00 00 00 
    1b9c:	48 89 c7             	mov    %rax,%rdi
    1b9f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1ba6:	00 00 00 
    1ba9:	ff d0                	call   *%rax
  }

  if(chdir("dir0") < 0){
    1bab:	48 b8 42 74 00 00 00 	movabs $0x7442,%rax
    1bb2:	00 00 00 
    1bb5:	48 89 c7             	mov    %rax,%rdi
    1bb8:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    1bbf:	00 00 00 
    1bc2:	ff d0                	call   *%rax
    1bc4:	85 c0                	test   %eax,%eax
    1bc6:	79 19                	jns    1be1 <dirtest+0x93>
    failexit("chdir dir0");
    1bc8:	48 b8 47 74 00 00 00 	movabs $0x7447,%rax
    1bcf:	00 00 00 
    1bd2:	48 89 c7             	mov    %rax,%rdi
    1bd5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1bdc:	00 00 00 
    1bdf:	ff d0                	call   *%rax
  }

  if(chdir("..") < 0){
    1be1:	48 b8 52 74 00 00 00 	movabs $0x7452,%rax
    1be8:	00 00 00 
    1beb:	48 89 c7             	mov    %rax,%rdi
    1bee:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    1bf5:	00 00 00 
    1bf8:	ff d0                	call   *%rax
    1bfa:	85 c0                	test   %eax,%eax
    1bfc:	79 19                	jns    1c17 <dirtest+0xc9>
    failexit("chdir ..");
    1bfe:	48 b8 55 74 00 00 00 	movabs $0x7455,%rax
    1c05:	00 00 00 
    1c08:	48 89 c7             	mov    %rax,%rdi
    1c0b:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1c12:	00 00 00 
    1c15:	ff d0                	call   *%rax
  }

  if(unlink("dir0") < 0){
    1c17:	48 b8 42 74 00 00 00 	movabs $0x7442,%rax
    1c1e:	00 00 00 
    1c21:	48 89 c7             	mov    %rax,%rdi
    1c24:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    1c2b:	00 00 00 
    1c2e:	ff d0                	call   *%rax
    1c30:	85 c0                	test   %eax,%eax
    1c32:	79 19                	jns    1c4d <dirtest+0xff>
    failexit("unlink dir0");
    1c34:	48 b8 5e 74 00 00 00 	movabs $0x745e,%rax
    1c3b:	00 00 00 
    1c3e:	48 89 c7             	mov    %rax,%rdi
    1c41:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1c48:	00 00 00 
    1c4b:	ff d0                	call   *%rax
  }
  printf(1, "mkdir test ok\n");
    1c4d:	48 b8 6a 74 00 00 00 	movabs $0x746a,%rax
    1c54:	00 00 00 
    1c57:	48 89 c6             	mov    %rax,%rsi
    1c5a:	bf 01 00 00 00       	mov    $0x1,%edi
    1c5f:	b8 00 00 00 00       	mov    $0x0,%eax
    1c64:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1c6b:	00 00 00 
    1c6e:	ff d2                	call   *%rdx
}
    1c70:	90                   	nop
    1c71:	5d                   	pop    %rbp
    1c72:	c3                   	ret

0000000000001c73 <exectest>:

void
exectest(void)
{
    1c73:	55                   	push   %rbp
    1c74:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "exec test\n");
    1c77:	48 b8 79 74 00 00 00 	movabs $0x7479,%rax
    1c7e:	00 00 00 
    1c81:	48 89 c6             	mov    %rax,%rsi
    1c84:	bf 01 00 00 00       	mov    $0x1,%edi
    1c89:	b8 00 00 00 00       	mov    $0x0,%eax
    1c8e:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1c95:	00 00 00 
    1c98:	ff d2                	call   *%rdx
  if(exec("echo", echoargv) < 0){
    1c9a:	48 ba 20 87 00 00 00 	movabs $0x8720,%rdx
    1ca1:	00 00 00 
    1ca4:	48 b8 e0 70 00 00 00 	movabs $0x70e0,%rax
    1cab:	00 00 00 
    1cae:	48 89 d6             	mov    %rdx,%rsi
    1cb1:	48 89 c7             	mov    %rax,%rdi
    1cb4:	48 b8 0b 67 00 00 00 	movabs $0x670b,%rax
    1cbb:	00 00 00 
    1cbe:	ff d0                	call   *%rax
    1cc0:	85 c0                	test   %eax,%eax
    1cc2:	79 19                	jns    1cdd <exectest+0x6a>
    failexit("exec echo");
    1cc4:	48 b8 84 74 00 00 00 	movabs $0x7484,%rax
    1ccb:	00 00 00 
    1cce:	48 89 c7             	mov    %rax,%rdi
    1cd1:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1cd8:	00 00 00 
    1cdb:	ff d0                	call   *%rax
  }
  printf(1, "exec test ok\n");
    1cdd:	48 b8 8e 74 00 00 00 	movabs $0x748e,%rax
    1ce4:	00 00 00 
    1ce7:	48 89 c6             	mov    %rax,%rsi
    1cea:	bf 01 00 00 00       	mov    $0x1,%edi
    1cef:	b8 00 00 00 00       	mov    $0x0,%eax
    1cf4:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1cfb:	00 00 00 
    1cfe:	ff d2                	call   *%rdx
}
    1d00:	90                   	nop
    1d01:	5d                   	pop    %rbp
    1d02:	c3                   	ret

0000000000001d03 <nullptrtest>:

void
nullptrtest(void)
{
    1d03:	55                   	push   %rbp
    1d04:	48 89 e5             	mov    %rsp,%rbp
    1d07:	48 83 ec 10          	sub    $0x10,%rsp
  printf(1, "null pointer test\n");
    1d0b:	48 b8 9c 74 00 00 00 	movabs $0x749c,%rax
    1d12:	00 00 00 
    1d15:	48 89 c6             	mov    %rax,%rsi
    1d18:	bf 01 00 00 00       	mov    $0x1,%edi
    1d1d:	b8 00 00 00 00       	mov    $0x0,%eax
    1d22:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1d29:	00 00 00 
    1d2c:	ff d2                	call   *%rdx
  printf(1, "expect one killed process\n");
    1d2e:	48 b8 af 74 00 00 00 	movabs $0x74af,%rax
    1d35:	00 00 00 
    1d38:	48 89 c6             	mov    %rax,%rsi
    1d3b:	bf 01 00 00 00       	mov    $0x1,%edi
    1d40:	b8 00 00 00 00       	mov    $0x0,%eax
    1d45:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1d4c:	00 00 00 
    1d4f:	ff d2                	call   *%rdx
  int ppid = getpid();
    1d51:	48 b8 80 67 00 00 00 	movabs $0x6780,%rax
    1d58:	00 00 00 
    1d5b:	ff d0                	call   *%rax
    1d5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if (fork() == 0) {
    1d60:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    1d67:	00 00 00 
    1d6a:	ff d0                	call   *%rax
    1d6c:	85 c0                	test   %eax,%eax
    1d6e:	75 51                	jne    1dc1 <nullptrtest+0xbe>
    *(addr_t *)(0) = 10;
    1d70:	b8 00 00 00 00       	mov    $0x0,%eax
    1d75:	48 c7 00 0a 00 00 00 	movq   $0xa,(%rax)
    printf(1, "can write to unmapped page 0, failed");
    1d7c:	48 b8 d0 74 00 00 00 	movabs $0x74d0,%rax
    1d83:	00 00 00 
    1d86:	48 89 c6             	mov    %rax,%rsi
    1d89:	bf 01 00 00 00       	mov    $0x1,%edi
    1d8e:	b8 00 00 00 00       	mov    $0x0,%eax
    1d93:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1d9a:	00 00 00 
    1d9d:	ff d2                	call   *%rdx
    kill(ppid,9);
    1d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1da2:	be 09 00 00 00       	mov    $0x9,%esi
    1da7:	89 c7                	mov    %eax,%edi
    1da9:	48 b8 fe 66 00 00 00 	movabs $0x66fe,%rax
    1db0:	00 00 00 
    1db3:	ff d0                	call   *%rax
    exit();
    1db5:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1dbc:	00 00 00 
    1dbf:	ff d0                	call   *%rax
  } else {
    wait();
    1dc1:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    1dc8:	00 00 00 
    1dcb:	ff d0                	call   *%rax
  }
  printf(1, "null pointer test ok\n");
    1dcd:	48 b8 f5 74 00 00 00 	movabs $0x74f5,%rax
    1dd4:	00 00 00 
    1dd7:	48 89 c6             	mov    %rax,%rsi
    1dda:	bf 01 00 00 00       	mov    $0x1,%edi
    1ddf:	b8 00 00 00 00       	mov    $0x0,%eax
    1de4:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    1deb:	00 00 00 
    1dee:	ff d2                	call   *%rdx
}
    1df0:	90                   	nop
    1df1:	c9                   	leave
    1df2:	c3                   	ret

0000000000001df3 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    1df3:	55                   	push   %rbp
    1df4:	48 89 e5             	mov    %rsp,%rbp
    1df7:	48 83 ec 20          	sub    $0x20,%rsp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    1dfb:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
    1dff:	48 89 c7             	mov    %rax,%rdi
    1e02:	48 b8 ca 66 00 00 00 	movabs $0x66ca,%rax
    1e09:	00 00 00 
    1e0c:	ff d0                	call   *%rax
    1e0e:	85 c0                	test   %eax,%eax
    1e10:	74 19                	je     1e2b <pipe1+0x38>
    failexit("pipe()");
    1e12:	48 b8 0b 75 00 00 00 	movabs $0x750b,%rax
    1e19:	00 00 00 
    1e1c:	48 89 c7             	mov    %rax,%rdi
    1e1f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1e26:	00 00 00 
    1e29:	ff d0                	call   *%rax
  }
  pid = fork();
    1e2b:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    1e32:	00 00 00 
    1e35:	ff d0                	call   *%rax
    1e37:	89 45 e8             	mov    %eax,-0x18(%rbp)
  seq = 0;
    1e3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  if(pid == 0){
    1e41:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    1e45:	0f 85 a6 00 00 00    	jne    1ef1 <pipe1+0xfe>
    close(fds[0]);
    1e4b:	8b 45 e0             	mov    -0x20(%rbp),%eax
    1e4e:	89 c7                	mov    %eax,%edi
    1e50:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    1e57:	00 00 00 
    1e5a:	ff d0                	call   *%rax
    for(n = 0; n < 5; n++){
    1e5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    1e63:	eb 7a                	jmp    1edf <pipe1+0xec>
      for(i = 0; i < 1033; i++)
    1e65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1e6c:	eb 21                	jmp    1e8f <pipe1+0x9c>
        buf[i] = seq++;
    1e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1e71:	8d 50 01             	lea    0x1(%rax),%edx
    1e74:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1e77:	89 c1                	mov    %eax,%ecx
    1e79:	48 ba 80 87 00 00 00 	movabs $0x8780,%rdx
    1e80:	00 00 00 
    1e83:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1e86:	48 98                	cltq
    1e88:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
      for(i = 0; i < 1033; i++)
    1e8b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1e8f:	81 7d f8 08 04 00 00 	cmpl   $0x408,-0x8(%rbp)
    1e96:	7e d6                	jle    1e6e <pipe1+0x7b>
      if(write(fds[1], buf, 1033) != 1033){
    1e98:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    1e9b:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    1ea2:	00 00 00 
    1ea5:	ba 09 04 00 00       	mov    $0x409,%edx
    1eaa:	48 89 ce             	mov    %rcx,%rsi
    1ead:	89 c7                	mov    %eax,%edi
    1eaf:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    1eb6:	00 00 00 
    1eb9:	ff d0                	call   *%rax
    1ebb:	3d 09 04 00 00       	cmp    $0x409,%eax
    1ec0:	74 19                	je     1edb <pipe1+0xe8>
        failexit("pipe1 oops 1");
    1ec2:	48 b8 12 75 00 00 00 	movabs $0x7512,%rax
    1ec9:	00 00 00 
    1ecc:	48 89 c7             	mov    %rax,%rdi
    1ecf:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1ed6:	00 00 00 
    1ed9:	ff d0                	call   *%rax
    for(n = 0; n < 5; n++){
    1edb:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    1edf:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
    1ee3:	7e 80                	jle    1e65 <pipe1+0x72>
      }
    }
    exit();
    1ee5:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1eec:	00 00 00 
    1eef:	ff d0                	call   *%rax
  } else if(pid > 0){
    1ef1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    1ef5:	0f 8e 20 01 00 00    	jle    201b <pipe1+0x228>
    close(fds[1]);
    1efb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    1efe:	89 c7                	mov    %eax,%edi
    1f00:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    1f07:	00 00 00 
    1f0a:	ff d0                	call   *%rax
    total = 0;
    1f0c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    cc = 1;
    1f13:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%rbp)
    while((n = read(fds[0], buf, cc)) > 0){
    1f1a:	eb 75                	jmp    1f91 <pipe1+0x19e>
      for(i = 0; i < n; i++){
    1f1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1f23:	eb 4a                	jmp    1f6f <pipe1+0x17c>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1f25:	48 ba 80 87 00 00 00 	movabs $0x8780,%rdx
    1f2c:	00 00 00 
    1f2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1f32:	48 98                	cltq
    1f34:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1f38:	0f be c8             	movsbl %al,%ecx
    1f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1f3e:	8d 50 01             	lea    0x1(%rax),%edx
    1f41:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1f44:	31 c8                	xor    %ecx,%eax
    1f46:	0f b6 c0             	movzbl %al,%eax
    1f49:	85 c0                	test   %eax,%eax
    1f4b:	74 1e                	je     1f6b <pipe1+0x178>
          failexit("pipe1 oops 2");
    1f4d:	48 b8 1f 75 00 00 00 	movabs $0x751f,%rax
    1f54:	00 00 00 
    1f57:	48 89 c7             	mov    %rax,%rdi
    1f5a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1f61:	00 00 00 
    1f64:	ff d0                	call   *%rax
    1f66:	e9 ec 00 00 00       	jmp    2057 <pipe1+0x264>
      for(i = 0; i < n; i++){
    1f6b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    1f6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1f72:	3b 45 f4             	cmp    -0xc(%rbp),%eax
    1f75:	7c ae                	jl     1f25 <pipe1+0x132>
          return;
        }
      }
      total += n;
    1f77:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1f7a:	01 45 ec             	add    %eax,-0x14(%rbp)
      cc = cc * 2;
    1f7d:	d1 65 f0             	shll   $1,-0x10(%rbp)
      if(cc > sizeof(buf))
    1f80:	8b 45 f0             	mov    -0x10(%rbp),%eax
    1f83:	3d 00 20 00 00       	cmp    $0x2000,%eax
    1f88:	76 07                	jbe    1f91 <pipe1+0x19e>
        cc = sizeof(buf);
    1f8a:	c7 45 f0 00 20 00 00 	movl   $0x2000,-0x10(%rbp)
    while((n = read(fds[0], buf, cc)) > 0){
    1f91:	8b 45 e0             	mov    -0x20(%rbp),%eax
    1f94:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1f97:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    1f9e:	00 00 00 
    1fa1:	48 89 ce             	mov    %rcx,%rsi
    1fa4:	89 c7                	mov    %eax,%edi
    1fa6:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    1fad:	00 00 00 
    1fb0:	ff d0                	call   *%rax
    1fb2:	89 45 f4             	mov    %eax,-0xc(%rbp)
    1fb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1fb9:	0f 8f 5d ff ff ff    	jg     1f1c <pipe1+0x129>
    }
    if(total != 5 * 1033){
    1fbf:	81 7d ec 2d 14 00 00 	cmpl   $0x142d,-0x14(%rbp)
    1fc6:	74 34                	je     1ffc <pipe1+0x209>
      printf(1, "pipe1 oops 3 total %d\n", total);
    1fc8:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1fcb:	48 b9 2c 75 00 00 00 	movabs $0x752c,%rcx
    1fd2:	00 00 00 
    1fd5:	89 c2                	mov    %eax,%edx
    1fd7:	48 89 ce             	mov    %rcx,%rsi
    1fda:	bf 01 00 00 00       	mov    $0x1,%edi
    1fdf:	b8 00 00 00 00       	mov    $0x0,%eax
    1fe4:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    1feb:	00 00 00 
    1fee:	ff d1                	call   *%rcx
      exit();
    1ff0:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    1ff7:	00 00 00 
    1ffa:	ff d0                	call   *%rax
    }
    close(fds[0]);
    1ffc:	8b 45 e0             	mov    -0x20(%rbp),%eax
    1fff:	89 c7                	mov    %eax,%edi
    2001:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2008:	00 00 00 
    200b:	ff d0                	call   *%rax
    wait();
    200d:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    2014:	00 00 00 
    2017:	ff d0                	call   *%rax
    2019:	eb 19                	jmp    2034 <pipe1+0x241>
  } else {
    failexit("fork()");
    201b:	48 b8 43 75 00 00 00 	movabs $0x7543,%rax
    2022:	00 00 00 
    2025:	48 89 c7             	mov    %rax,%rdi
    2028:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    202f:	00 00 00 
    2032:	ff d0                	call   *%rax
  }
  printf(1, "pipe1 ok\n");
    2034:	48 b8 4a 75 00 00 00 	movabs $0x754a,%rax
    203b:	00 00 00 
    203e:	48 89 c6             	mov    %rax,%rsi
    2041:	bf 01 00 00 00       	mov    $0x1,%edi
    2046:	b8 00 00 00 00       	mov    $0x0,%eax
    204b:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2052:	00 00 00 
    2055:	ff d2                	call   *%rdx
}
    2057:	c9                   	leave
    2058:	c3                   	ret

0000000000002059 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    2059:	55                   	push   %rbp
    205a:	48 89 e5             	mov    %rsp,%rbp
    205d:	48 83 ec 20          	sub    $0x20,%rsp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    2061:	48 b8 54 75 00 00 00 	movabs $0x7554,%rax
    2068:	00 00 00 
    206b:	48 89 c6             	mov    %rax,%rsi
    206e:	bf 01 00 00 00       	mov    $0x1,%edi
    2073:	b8 00 00 00 00       	mov    $0x0,%eax
    2078:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    207f:	00 00 00 
    2082:	ff d2                	call   *%rdx
  pid1 = fork();
    2084:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    208b:	00 00 00 
    208e:	ff d0                	call   *%rax
    2090:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(pid1 == 0)
    2093:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2097:	75 03                	jne    209c <preempt+0x43>
    for(;;)
    2099:	90                   	nop
    209a:	eb fd                	jmp    2099 <preempt+0x40>
      ;

  pid2 = fork();
    209c:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    20a3:	00 00 00 
    20a6:	ff d0                	call   *%rax
    20a8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(pid2 == 0)
    20ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    20af:	75 03                	jne    20b4 <preempt+0x5b>
    for(;;)
    20b1:	90                   	nop
    20b2:	eb fd                	jmp    20b1 <preempt+0x58>
      ;

  pipe(pfds);
    20b4:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
    20b8:	48 89 c7             	mov    %rax,%rdi
    20bb:	48 b8 ca 66 00 00 00 	movabs $0x66ca,%rax
    20c2:	00 00 00 
    20c5:	ff d0                	call   *%rax
  pid3 = fork();
    20c7:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    20ce:	00 00 00 
    20d1:	ff d0                	call   *%rax
    20d3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(pid3 == 0){
    20d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    20da:	75 70                	jne    214c <preempt+0xf3>
    close(pfds[0]);
    20dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
    20df:	89 c7                	mov    %eax,%edi
    20e1:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    20e8:	00 00 00 
    20eb:	ff d0                	call   *%rax
    if(write(pfds[1], "x", 1) != 1)
    20ed:	8b 45 f0             	mov    -0x10(%rbp),%eax
    20f0:	48 b9 5e 75 00 00 00 	movabs $0x755e,%rcx
    20f7:	00 00 00 
    20fa:	ba 01 00 00 00       	mov    $0x1,%edx
    20ff:	48 89 ce             	mov    %rcx,%rsi
    2102:	89 c7                	mov    %eax,%edi
    2104:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    210b:	00 00 00 
    210e:	ff d0                	call   *%rax
    2110:	83 f8 01             	cmp    $0x1,%eax
    2113:	74 23                	je     2138 <preempt+0xdf>
      printf(1, "preempt write error");
    2115:	48 b8 60 75 00 00 00 	movabs $0x7560,%rax
    211c:	00 00 00 
    211f:	48 89 c6             	mov    %rax,%rsi
    2122:	bf 01 00 00 00       	mov    $0x1,%edi
    2127:	b8 00 00 00 00       	mov    $0x0,%eax
    212c:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2133:	00 00 00 
    2136:	ff d2                	call   *%rdx
    close(pfds[1]);
    2138:	8b 45 f0             	mov    -0x10(%rbp),%eax
    213b:	89 c7                	mov    %eax,%edi
    213d:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2144:	00 00 00 
    2147:	ff d0                	call   *%rax
    for(;;)
    2149:	90                   	nop
    214a:	eb fd                	jmp    2149 <preempt+0xf0>
      ;
  }

  close(pfds[1]);
    214c:	8b 45 f0             	mov    -0x10(%rbp),%eax
    214f:	89 c7                	mov    %eax,%edi
    2151:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2158:	00 00 00 
    215b:	ff d0                	call   *%rax
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    215d:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2160:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    2167:	00 00 00 
    216a:	ba 00 20 00 00       	mov    $0x2000,%edx
    216f:	48 89 ce             	mov    %rcx,%rsi
    2172:	89 c7                	mov    %eax,%edi
    2174:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    217b:	00 00 00 
    217e:	ff d0                	call   *%rax
    2180:	83 f8 01             	cmp    $0x1,%eax
    2183:	74 28                	je     21ad <preempt+0x154>
    printf(1, "preempt read error");
    2185:	48 b8 74 75 00 00 00 	movabs $0x7574,%rax
    218c:	00 00 00 
    218f:	48 89 c6             	mov    %rax,%rsi
    2192:	bf 01 00 00 00       	mov    $0x1,%edi
    2197:	b8 00 00 00 00       	mov    $0x0,%eax
    219c:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    21a3:	00 00 00 
    21a6:	ff d2                	call   *%rdx
    21a8:	e9 e0 00 00 00       	jmp    228d <preempt+0x234>
    return;
  }
  close(pfds[0]);
    21ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
    21b0:	89 c7                	mov    %eax,%edi
    21b2:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    21b9:	00 00 00 
    21bc:	ff d0                	call   *%rax
  printf(1, "kill... ");
    21be:	48 b8 87 75 00 00 00 	movabs $0x7587,%rax
    21c5:	00 00 00 
    21c8:	48 89 c6             	mov    %rax,%rsi
    21cb:	bf 01 00 00 00       	mov    $0x1,%edi
    21d0:	b8 00 00 00 00       	mov    $0x0,%eax
    21d5:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    21dc:	00 00 00 
    21df:	ff d2                	call   *%rdx
  kill(pid1,9);
    21e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    21e4:	be 09 00 00 00       	mov    $0x9,%esi
    21e9:	89 c7                	mov    %eax,%edi
    21eb:	48 b8 fe 66 00 00 00 	movabs $0x66fe,%rax
    21f2:	00 00 00 
    21f5:	ff d0                	call   *%rax
  kill(pid2,9);
    21f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
    21fa:	be 09 00 00 00       	mov    $0x9,%esi
    21ff:	89 c7                	mov    %eax,%edi
    2201:	48 b8 fe 66 00 00 00 	movabs $0x66fe,%rax
    2208:	00 00 00 
    220b:	ff d0                	call   *%rax
  kill(pid3,9);
    220d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2210:	be 09 00 00 00       	mov    $0x9,%esi
    2215:	89 c7                	mov    %eax,%edi
    2217:	48 b8 fe 66 00 00 00 	movabs $0x66fe,%rax
    221e:	00 00 00 
    2221:	ff d0                	call   *%rax
  printf(1, "wait... ");
    2223:	48 b8 90 75 00 00 00 	movabs $0x7590,%rax
    222a:	00 00 00 
    222d:	48 89 c6             	mov    %rax,%rsi
    2230:	bf 01 00 00 00       	mov    $0x1,%edi
    2235:	b8 00 00 00 00       	mov    $0x0,%eax
    223a:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2241:	00 00 00 
    2244:	ff d2                	call   *%rdx
  wait();
    2246:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    224d:	00 00 00 
    2250:	ff d0                	call   *%rax
  wait();
    2252:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    2259:	00 00 00 
    225c:	ff d0                	call   *%rax
  wait();
    225e:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    2265:	00 00 00 
    2268:	ff d0                	call   *%rax
  printf(1, "preempt ok\n");
    226a:	48 b8 99 75 00 00 00 	movabs $0x7599,%rax
    2271:	00 00 00 
    2274:	48 89 c6             	mov    %rax,%rsi
    2277:	bf 01 00 00 00       	mov    $0x1,%edi
    227c:	b8 00 00 00 00       	mov    $0x0,%eax
    2281:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2288:	00 00 00 
    228b:	ff d2                	call   *%rdx
}
    228d:	c9                   	leave
    228e:	c3                   	ret

000000000000228f <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
    228f:	55                   	push   %rbp
    2290:	48 89 e5             	mov    %rsp,%rbp
    2293:	48 83 ec 10          	sub    $0x10,%rsp
  int i, pid;

  for(i = 0; i < 100; i++){
    2297:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    229e:	e9 86 00 00 00       	jmp    2329 <exitwait+0x9a>
    pid = fork();
    22a3:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    22aa:	00 00 00 
    22ad:	ff d0                	call   *%rax
    22af:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(pid < 0){
    22b2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    22b6:	79 25                	jns    22dd <exitwait+0x4e>
      printf(1, "fork");
    22b8:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    22bf:	00 00 00 
    22c2:	48 89 c6             	mov    %rax,%rsi
    22c5:	bf 01 00 00 00       	mov    $0x1,%edi
    22ca:	b8 00 00 00 00       	mov    $0x0,%eax
    22cf:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    22d6:	00 00 00 
    22d9:	ff d2                	call   *%rdx
      return;
    22db:	eb 79                	jmp    2356 <exitwait+0xc7>
    }
    if(pid){
    22dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    22e1:	74 36                	je     2319 <exitwait+0x8a>
      if(wait() != pid){
    22e3:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    22ea:	00 00 00 
    22ed:	ff d0                	call   *%rax
    22ef:	39 45 f8             	cmp    %eax,-0x8(%rbp)
    22f2:	74 31                	je     2325 <exitwait+0x96>
        printf(1, "wait wrong pid\n");
    22f4:	48 b8 a5 75 00 00 00 	movabs $0x75a5,%rax
    22fb:	00 00 00 
    22fe:	48 89 c6             	mov    %rax,%rsi
    2301:	bf 01 00 00 00       	mov    $0x1,%edi
    2306:	b8 00 00 00 00       	mov    $0x0,%eax
    230b:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2312:	00 00 00 
    2315:	ff d2                	call   *%rdx
        return;
    2317:	eb 3d                	jmp    2356 <exitwait+0xc7>
      }
    } else {
      exit();
    2319:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2320:	00 00 00 
    2323:	ff d0                	call   *%rax
  for(i = 0; i < 100; i++){
    2325:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2329:	83 7d fc 63          	cmpl   $0x63,-0x4(%rbp)
    232d:	0f 8e 70 ff ff ff    	jle    22a3 <exitwait+0x14>
    }
  }
  printf(1, "exitwait ok\n");
    2333:	48 b8 b5 75 00 00 00 	movabs $0x75b5,%rax
    233a:	00 00 00 
    233d:	48 89 c6             	mov    %rax,%rsi
    2340:	bf 01 00 00 00       	mov    $0x1,%edi
    2345:	b8 00 00 00 00       	mov    $0x0,%eax
    234a:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2351:	00 00 00 
    2354:	ff d2                	call   *%rdx
}
    2356:	c9                   	leave
    2357:	c3                   	ret

0000000000002358 <mem>:

void
mem(void)
{
    2358:	55                   	push   %rbp
    2359:	48 89 e5             	mov    %rsp,%rbp
    235c:	48 83 ec 20          	sub    $0x20,%rsp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
    2360:	48 b8 c2 75 00 00 00 	movabs $0x75c2,%rax
    2367:	00 00 00 
    236a:	48 89 c6             	mov    %rax,%rsi
    236d:	bf 01 00 00 00       	mov    $0x1,%edi
    2372:	b8 00 00 00 00       	mov    $0x0,%eax
    2377:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    237e:	00 00 00 
    2381:	ff d2                	call   *%rdx
  ppid = getpid();
    2383:	48 b8 80 67 00 00 00 	movabs $0x6780,%rax
    238a:	00 00 00 
    238d:	ff d0                	call   *%rax
    238f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((pid = fork()) == 0){
    2392:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    2399:	00 00 00 
    239c:	ff d0                	call   *%rax
    239e:	89 45 f0             	mov    %eax,-0x10(%rbp)
    23a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    23a5:	0f 85 2e 01 00 00    	jne    24d9 <mem+0x181>
    m1 = 0;
    23ab:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
    23b2:	00 
    while((m2 = malloc(100001)) != 0){
    23b3:	eb 13                	jmp    23c8 <mem+0x70>
      //printf(1, "m2 %p\n", m2);
      *(void**)m2 = m1;
    23b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    23b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    23bd:	48 89 10             	mov    %rdx,(%rax)
      m1 = m2;
    23c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    23c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    while((m2 = malloc(100001)) != 0){
    23c8:	bf a1 86 01 00       	mov    $0x186a1,%edi
    23cd:	48 b8 96 6f 00 00 00 	movabs $0x6f96,%rax
    23d4:	00 00 00 
    23d7:	ff d0                	call   *%rax
    23d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    23dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
    23e2:	75 d1                	jne    23b5 <mem+0x5d>
    }
    printf(1, "alloc ended\n");
    23e4:	48 b8 cc 75 00 00 00 	movabs $0x75cc,%rax
    23eb:	00 00 00 
    23ee:	48 89 c6             	mov    %rax,%rsi
    23f1:	bf 01 00 00 00       	mov    $0x1,%edi
    23f6:	b8 00 00 00 00       	mov    $0x0,%eax
    23fb:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2402:	00 00 00 
    2405:	ff d2                	call   *%rdx
    while(m1){
    2407:	eb 26                	jmp    242f <mem+0xd7>
      m2 = *(void**)m1;
    2409:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    240d:	48 8b 00             	mov    (%rax),%rax
    2410:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      free(m1);
    2414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2418:	48 89 c7             	mov    %rax,%rdi
    241b:	48 b8 e9 6d 00 00 00 	movabs $0x6de9,%rax
    2422:	00 00 00 
    2425:	ff d0                	call   *%rax
      m1 = m2;
    2427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    242b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    while(m1){
    242f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2434:	75 d3                	jne    2409 <mem+0xb1>
    }
    m1 = malloc(1024*20);
    2436:	bf 00 50 00 00       	mov    $0x5000,%edi
    243b:	48 b8 96 6f 00 00 00 	movabs $0x6f96,%rax
    2442:	00 00 00 
    2445:	ff d0                	call   *%rax
    2447:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(m1 == 0){
    244b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    2450:	75 45                	jne    2497 <mem+0x13f>
      printf(1, "couldn't allocate mem?!!\n");
    2452:	48 b8 d9 75 00 00 00 	movabs $0x75d9,%rax
    2459:	00 00 00 
    245c:	48 89 c6             	mov    %rax,%rsi
    245f:	bf 01 00 00 00       	mov    $0x1,%edi
    2464:	b8 00 00 00 00       	mov    $0x0,%eax
    2469:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2470:	00 00 00 
    2473:	ff d2                	call   *%rdx
      kill(ppid,9);
    2475:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2478:	be 09 00 00 00       	mov    $0x9,%esi
    247d:	89 c7                	mov    %eax,%edi
    247f:	48 b8 fe 66 00 00 00 	movabs $0x66fe,%rax
    2486:	00 00 00 
    2489:	ff d0                	call   *%rax
      exit();
    248b:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2492:	00 00 00 
    2495:	ff d0                	call   *%rax
    }
    free(m1);
    2497:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    249b:	48 89 c7             	mov    %rax,%rdi
    249e:	48 b8 e9 6d 00 00 00 	movabs $0x6de9,%rax
    24a5:	00 00 00 
    24a8:	ff d0                	call   *%rax
    printf(1, "mem ok\n");
    24aa:	48 b8 f3 75 00 00 00 	movabs $0x75f3,%rax
    24b1:	00 00 00 
    24b4:	48 89 c6             	mov    %rax,%rsi
    24b7:	bf 01 00 00 00       	mov    $0x1,%edi
    24bc:	b8 00 00 00 00       	mov    $0x0,%eax
    24c1:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    24c8:	00 00 00 
    24cb:	ff d2                	call   *%rdx
    exit();
    24cd:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    24d4:	00 00 00 
    24d7:	ff d0                	call   *%rax
  } else {
    wait();
    24d9:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    24e0:	00 00 00 
    24e3:	ff d0                	call   *%rax
  }
}
    24e5:	90                   	nop
    24e6:	c9                   	leave
    24e7:	c3                   	ret

00000000000024e8 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    24e8:	55                   	push   %rbp
    24e9:	48 89 e5             	mov    %rsp,%rbp
    24ec:	48 83 ec 30          	sub    $0x30,%rsp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
    24f0:	48 b8 fb 75 00 00 00 	movabs $0x75fb,%rax
    24f7:	00 00 00 
    24fa:	48 89 c6             	mov    %rax,%rsi
    24fd:	bf 01 00 00 00       	mov    $0x1,%edi
    2502:	b8 00 00 00 00       	mov    $0x0,%eax
    2507:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    250e:	00 00 00 
    2511:	ff d2                	call   *%rdx

  unlink("sharedfd");
    2513:	48 b8 0a 76 00 00 00 	movabs $0x760a,%rax
    251a:	00 00 00 
    251d:	48 89 c7             	mov    %rax,%rdi
    2520:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2527:	00 00 00 
    252a:	ff d0                	call   *%rax
  fd = open("sharedfd", O_CREATE|O_RDWR);
    252c:	48 b8 0a 76 00 00 00 	movabs $0x760a,%rax
    2533:	00 00 00 
    2536:	be 02 02 00 00       	mov    $0x202,%esi
    253b:	48 89 c7             	mov    %rax,%rdi
    253e:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    2545:	00 00 00 
    2548:	ff d0                	call   *%rax
    254a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if(fd < 0){
    254d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    2551:	79 28                	jns    257b <sharedfd+0x93>
    printf(1, "fstests: cannot open sharedfd for writing");
    2553:	48 b8 18 76 00 00 00 	movabs $0x7618,%rax
    255a:	00 00 00 
    255d:	48 89 c6             	mov    %rax,%rsi
    2560:	bf 01 00 00 00       	mov    $0x1,%edi
    2565:	b8 00 00 00 00       	mov    $0x0,%eax
    256a:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2571:	00 00 00 
    2574:	ff d2                	call   *%rdx
    return;
    2576:	e9 1c 02 00 00       	jmp    2797 <sharedfd+0x2af>
  }
  pid = fork();
    257b:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    2582:	00 00 00 
    2585:	ff d0                	call   *%rax
    2587:	89 45 ec             	mov    %eax,-0x14(%rbp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    258a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    258e:	75 07                	jne    2597 <sharedfd+0xaf>
    2590:	b9 63 00 00 00       	mov    $0x63,%ecx
    2595:	eb 05                	jmp    259c <sharedfd+0xb4>
    2597:	b9 70 00 00 00       	mov    $0x70,%ecx
    259c:	48 8d 45 de          	lea    -0x22(%rbp),%rax
    25a0:	ba 0a 00 00 00       	mov    $0xa,%edx
    25a5:	89 ce                	mov    %ecx,%esi
    25a7:	48 89 c7             	mov    %rax,%rdi
    25aa:	48 b8 93 64 00 00 00 	movabs $0x6493,%rax
    25b1:	00 00 00 
    25b4:	ff d0                	call   *%rax
  for(i = 0; i < 1000; i++){
    25b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    25bd:	eb 4b                	jmp    260a <sharedfd+0x122>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    25bf:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
    25c3:	8b 45 f0             	mov    -0x10(%rbp),%eax
    25c6:	ba 0a 00 00 00       	mov    $0xa,%edx
    25cb:	48 89 ce             	mov    %rcx,%rsi
    25ce:	89 c7                	mov    %eax,%edi
    25d0:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    25d7:	00 00 00 
    25da:	ff d0                	call   *%rax
    25dc:	83 f8 0a             	cmp    $0xa,%eax
    25df:	74 25                	je     2606 <sharedfd+0x11e>
      printf(1, "fstests: write sharedfd failed\n");
    25e1:	48 b8 48 76 00 00 00 	movabs $0x7648,%rax
    25e8:	00 00 00 
    25eb:	48 89 c6             	mov    %rax,%rsi
    25ee:	bf 01 00 00 00       	mov    $0x1,%edi
    25f3:	b8 00 00 00 00       	mov    $0x0,%eax
    25f8:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    25ff:	00 00 00 
    2602:	ff d2                	call   *%rdx
      break;
    2604:	eb 0d                	jmp    2613 <sharedfd+0x12b>
  for(i = 0; i < 1000; i++){
    2606:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    260a:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
    2611:	7e ac                	jle    25bf <sharedfd+0xd7>
    }
  }
  if(pid == 0)
    2613:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    2617:	75 0c                	jne    2625 <sharedfd+0x13d>
    exit();
    2619:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2620:	00 00 00 
    2623:	ff d0                	call   *%rax
  else
    wait();
    2625:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    262c:	00 00 00 
    262f:	ff d0                	call   *%rax
  close(fd);
    2631:	8b 45 f0             	mov    -0x10(%rbp),%eax
    2634:	89 c7                	mov    %eax,%edi
    2636:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    263d:	00 00 00 
    2640:	ff d0                	call   *%rax
  fd = open("sharedfd", 0);
    2642:	48 b8 0a 76 00 00 00 	movabs $0x760a,%rax
    2649:	00 00 00 
    264c:	be 00 00 00 00       	mov    $0x0,%esi
    2651:	48 89 c7             	mov    %rax,%rdi
    2654:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    265b:	00 00 00 
    265e:	ff d0                	call   *%rax
    2660:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if(fd < 0){
    2663:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    2667:	79 28                	jns    2691 <sharedfd+0x1a9>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    2669:	48 b8 68 76 00 00 00 	movabs $0x7668,%rax
    2670:	00 00 00 
    2673:	48 89 c6             	mov    %rax,%rsi
    2676:	bf 01 00 00 00       	mov    $0x1,%edi
    267b:	b8 00 00 00 00       	mov    $0x0,%eax
    2680:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2687:	00 00 00 
    268a:	ff d2                	call   *%rdx
    return;
    268c:	e9 06 01 00 00       	jmp    2797 <sharedfd+0x2af>
  }
  nc = np = 0;
    2691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    2698:	8b 45 f4             	mov    -0xc(%rbp),%eax
    269b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    269e:	eb 39                	jmp    26d9 <sharedfd+0x1f1>
    for(i = 0; i < sizeof(buf); i++){
    26a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    26a7:	eb 28                	jmp    26d1 <sharedfd+0x1e9>
      if(buf[i] == 'c')
    26a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    26ac:	48 98                	cltq
    26ae:	0f b6 44 05 de       	movzbl -0x22(%rbp,%rax,1),%eax
    26b3:	3c 63                	cmp    $0x63,%al
    26b5:	75 04                	jne    26bb <sharedfd+0x1d3>
        nc++;
    26b7:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
      if(buf[i] == 'p')
    26bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
    26be:	48 98                	cltq
    26c0:	0f b6 44 05 de       	movzbl -0x22(%rbp,%rax,1),%eax
    26c5:	3c 70                	cmp    $0x70,%al
    26c7:	75 04                	jne    26cd <sharedfd+0x1e5>
        np++;
    26c9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    for(i = 0; i < sizeof(buf); i++){
    26cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    26d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    26d4:	83 f8 09             	cmp    $0x9,%eax
    26d7:	76 d0                	jbe    26a9 <sharedfd+0x1c1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    26d9:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
    26dd:	8b 45 f0             	mov    -0x10(%rbp),%eax
    26e0:	ba 0a 00 00 00       	mov    $0xa,%edx
    26e5:	48 89 ce             	mov    %rcx,%rsi
    26e8:	89 c7                	mov    %eax,%edi
    26ea:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    26f1:	00 00 00 
    26f4:	ff d0                	call   *%rax
    26f6:	89 45 e8             	mov    %eax,-0x18(%rbp)
    26f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
    26fd:	7f a1                	jg     26a0 <sharedfd+0x1b8>
    }
  }
  close(fd);
    26ff:	8b 45 f0             	mov    -0x10(%rbp),%eax
    2702:	89 c7                	mov    %eax,%edi
    2704:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    270b:	00 00 00 
    270e:	ff d0                	call   *%rax
  unlink("sharedfd");
    2710:	48 b8 0a 76 00 00 00 	movabs $0x760a,%rax
    2717:	00 00 00 
    271a:	48 89 c7             	mov    %rax,%rdi
    271d:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2724:	00 00 00 
    2727:	ff d0                	call   *%rax
  if(nc == 10000 && np == 10000){
    2729:	81 7d f8 10 27 00 00 	cmpl   $0x2710,-0x8(%rbp)
    2730:	75 2e                	jne    2760 <sharedfd+0x278>
    2732:	81 7d f4 10 27 00 00 	cmpl   $0x2710,-0xc(%rbp)
    2739:	75 25                	jne    2760 <sharedfd+0x278>
    printf(1, "sharedfd ok\n");
    273b:	48 b8 93 76 00 00 00 	movabs $0x7693,%rax
    2742:	00 00 00 
    2745:	48 89 c6             	mov    %rax,%rsi
    2748:	bf 01 00 00 00       	mov    $0x1,%edi
    274d:	b8 00 00 00 00       	mov    $0x0,%eax
    2752:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2759:	00 00 00 
    275c:	ff d2                	call   *%rdx
    275e:	eb 37                	jmp    2797 <sharedfd+0x2af>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    2760:	8b 55 f4             	mov    -0xc(%rbp),%edx
    2763:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2766:	48 be a0 76 00 00 00 	movabs $0x76a0,%rsi
    276d:	00 00 00 
    2770:	89 d1                	mov    %edx,%ecx
    2772:	89 c2                	mov    %eax,%edx
    2774:	bf 01 00 00 00       	mov    $0x1,%edi
    2779:	b8 00 00 00 00       	mov    $0x0,%eax
    277e:	49 b8 be 69 00 00 00 	movabs $0x69be,%r8
    2785:	00 00 00 
    2788:	41 ff d0             	call   *%r8
    exit();
    278b:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2792:	00 00 00 
    2795:	ff d0                	call   *%rax
  }
}
    2797:	c9                   	leave
    2798:	c3                   	ret

0000000000002799 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    2799:	55                   	push   %rbp
    279a:	48 89 e5             	mov    %rsp,%rbp
    279d:	48 83 ec 50          	sub    $0x50,%rsp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    27a1:	48 b8 b5 76 00 00 00 	movabs $0x76b5,%rax
    27a8:	00 00 00 
    27ab:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    27af:	48 b8 b8 76 00 00 00 	movabs $0x76b8,%rax
    27b6:	00 00 00 
    27b9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    27bd:	48 b8 bb 76 00 00 00 	movabs $0x76bb,%rax
    27c4:	00 00 00 
    27c7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    27cb:	48 b8 be 76 00 00 00 	movabs $0x76be,%rax
    27d2:	00 00 00 
    27d5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  char *fname;

  printf(1, "fourfiles test\n");
    27d9:	48 b8 c1 76 00 00 00 	movabs $0x76c1,%rax
    27e0:	00 00 00 
    27e3:	48 89 c6             	mov    %rax,%rsi
    27e6:	bf 01 00 00 00       	mov    $0x1,%edi
    27eb:	b8 00 00 00 00       	mov    $0x0,%eax
    27f0:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    27f7:	00 00 00 
    27fa:	ff d2                	call   *%rdx

  for(pi = 0; pi < 4; pi++){
    27fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    2803:	e9 3f 01 00 00       	jmp    2947 <fourfiles+0x1ae>
    fname = names[pi];
    2808:	8b 45 f0             	mov    -0x10(%rbp),%eax
    280b:	48 98                	cltq
    280d:	48 8b 44 c5 b0       	mov    -0x50(%rbp,%rax,8),%rax
    2812:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    unlink(fname);
    2816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    281a:	48 89 c7             	mov    %rax,%rdi
    281d:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2824:	00 00 00 
    2827:	ff d0                	call   *%rax

    pid = fork();
    2829:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    2830:	00 00 00 
    2833:	ff d0                	call   *%rax
    2835:	89 45 dc             	mov    %eax,-0x24(%rbp)
    if(pid < 0){
    2838:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    283c:	79 19                	jns    2857 <fourfiles+0xbe>
      failexit("fork");
    283e:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    2845:	00 00 00 
    2848:	48 89 c7             	mov    %rax,%rdi
    284b:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2852:	00 00 00 
    2855:	ff d0                	call   *%rax
    }

    if(pid == 0){
    2857:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    285b:	0f 85 e2 00 00 00    	jne    2943 <fourfiles+0x1aa>
      fd = open(fname, O_CREATE | O_RDWR);
    2861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2865:	be 02 02 00 00       	mov    $0x202,%esi
    286a:	48 89 c7             	mov    %rax,%rdi
    286d:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    2874:	00 00 00 
    2877:	ff d0                	call   *%rax
    2879:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if(fd < 0){
    287c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    2880:	79 19                	jns    289b <fourfiles+0x102>
        failexit("create");
    2882:	48 b8 d1 76 00 00 00 	movabs $0x76d1,%rax
    2889:	00 00 00 
    288c:	48 89 c7             	mov    %rax,%rdi
    288f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2896:	00 00 00 
    2899:	ff d0                	call   *%rax
      }

      memset(buf, '0'+pi, 512);
    289b:	8b 45 f0             	mov    -0x10(%rbp),%eax
    289e:	8d 48 30             	lea    0x30(%rax),%ecx
    28a1:	48 b8 80 87 00 00 00 	movabs $0x8780,%rax
    28a8:	00 00 00 
    28ab:	ba 00 02 00 00       	mov    $0x200,%edx
    28b0:	89 ce                	mov    %ecx,%esi
    28b2:	48 89 c7             	mov    %rax,%rdi
    28b5:	48 b8 93 64 00 00 00 	movabs $0x6493,%rax
    28bc:	00 00 00 
    28bf:	ff d0                	call   *%rax
      for(i = 0; i < 12; i++){
    28c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    28c8:	eb 67                	jmp    2931 <fourfiles+0x198>
        if((n = write(fd, buf, 500)) != 500){
    28ca:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    28d1:	00 00 00 
    28d4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    28d7:	ba f4 01 00 00       	mov    $0x1f4,%edx
    28dc:	48 89 ce             	mov    %rcx,%rsi
    28df:	89 c7                	mov    %eax,%edi
    28e1:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    28e8:	00 00 00 
    28eb:	ff d0                	call   *%rax
    28ed:	89 45 e0             	mov    %eax,-0x20(%rbp)
    28f0:	81 7d e0 f4 01 00 00 	cmpl   $0x1f4,-0x20(%rbp)
    28f7:	74 34                	je     292d <fourfiles+0x194>
          printf(1, "write failed %d\n", n);
    28f9:	8b 45 e0             	mov    -0x20(%rbp),%eax
    28fc:	48 b9 d8 76 00 00 00 	movabs $0x76d8,%rcx
    2903:	00 00 00 
    2906:	89 c2                	mov    %eax,%edx
    2908:	48 89 ce             	mov    %rcx,%rsi
    290b:	bf 01 00 00 00       	mov    $0x1,%edi
    2910:	b8 00 00 00 00       	mov    $0x0,%eax
    2915:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    291c:	00 00 00 
    291f:	ff d1                	call   *%rcx
          exit();
    2921:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2928:	00 00 00 
    292b:	ff d0                	call   *%rax
      for(i = 0; i < 12; i++){
    292d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2931:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
    2935:	7e 93                	jle    28ca <fourfiles+0x131>
        }
      }
      exit();
    2937:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    293e:	00 00 00 
    2941:	ff d0                	call   *%rax
  for(pi = 0; pi < 4; pi++){
    2943:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
    2947:	83 7d f0 03          	cmpl   $0x3,-0x10(%rbp)
    294b:	0f 8e b7 fe ff ff    	jle    2808 <fourfiles+0x6f>
    }
  }

  for(pi = 0; pi < 4; pi++){
    2951:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
    2958:	eb 10                	jmp    296a <fourfiles+0x1d1>
    wait();
    295a:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    2961:	00 00 00 
    2964:	ff d0                	call   *%rax
  for(pi = 0; pi < 4; pi++){
    2966:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
    296a:	83 7d f0 03          	cmpl   $0x3,-0x10(%rbp)
    296e:	7e ea                	jle    295a <fourfiles+0x1c1>
  }

  for(i = 0; i < 2; i++){
    2970:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2977:	e9 17 01 00 00       	jmp    2a93 <fourfiles+0x2fa>
    fname = names[i];
    297c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    297f:	48 98                	cltq
    2981:	48 8b 44 c5 b0       	mov    -0x50(%rbp,%rax,8),%rax
    2986:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    fd = open(fname, 0);
    298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    298e:	be 00 00 00 00       	mov    $0x0,%esi
    2993:	48 89 c7             	mov    %rax,%rdi
    2996:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    299d:	00 00 00 
    29a0:	ff d0                	call   *%rax
    29a2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    total = 0;
    29a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    29ac:	eb 54                	jmp    2a02 <fourfiles+0x269>
      for(j = 0; j < n; j++){
    29ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    29b5:	eb 3d                	jmp    29f4 <fourfiles+0x25b>
        if(buf[j] != '0'+i){
    29b7:	48 ba 80 87 00 00 00 	movabs $0x8780,%rdx
    29be:	00 00 00 
    29c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
    29c4:	48 98                	cltq
    29c6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    29ca:	0f be d0             	movsbl %al,%edx
    29cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    29d0:	83 c0 30             	add    $0x30,%eax
    29d3:	39 c2                	cmp    %eax,%edx
    29d5:	74 19                	je     29f0 <fourfiles+0x257>
          failexit("wrong char");
    29d7:	48 b8 e9 76 00 00 00 	movabs $0x76e9,%rax
    29de:	00 00 00 
    29e1:	48 89 c7             	mov    %rax,%rdi
    29e4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    29eb:	00 00 00 
    29ee:	ff d0                	call   *%rax
      for(j = 0; j < n; j++){
    29f0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    29f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
    29f7:	3b 45 e0             	cmp    -0x20(%rbp),%eax
    29fa:	7c bb                	jl     29b7 <fourfiles+0x21e>
        }
      }
      total += n;
    29fc:	8b 45 e0             	mov    -0x20(%rbp),%eax
    29ff:	01 45 f4             	add    %eax,-0xc(%rbp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2a02:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    2a09:	00 00 00 
    2a0c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    2a0f:	ba 00 20 00 00       	mov    $0x2000,%edx
    2a14:	48 89 ce             	mov    %rcx,%rsi
    2a17:	89 c7                	mov    %eax,%edi
    2a19:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    2a20:	00 00 00 
    2a23:	ff d0                	call   *%rax
    2a25:	89 45 e0             	mov    %eax,-0x20(%rbp)
    2a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
    2a2c:	7f 80                	jg     29ae <fourfiles+0x215>
    }
    close(fd);
    2a2e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
    2a31:	89 c7                	mov    %eax,%edi
    2a33:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2a3a:	00 00 00 
    2a3d:	ff d0                	call   *%rax
    if(total != 12*500){
    2a3f:	81 7d f4 70 17 00 00 	cmpl   $0x1770,-0xc(%rbp)
    2a46:	74 34                	je     2a7c <fourfiles+0x2e3>
      printf(1, "wrong length %d\n", total);
    2a48:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2a4b:	48 b9 f4 76 00 00 00 	movabs $0x76f4,%rcx
    2a52:	00 00 00 
    2a55:	89 c2                	mov    %eax,%edx
    2a57:	48 89 ce             	mov    %rcx,%rsi
    2a5a:	bf 01 00 00 00       	mov    $0x1,%edi
    2a5f:	b8 00 00 00 00       	mov    $0x0,%eax
    2a64:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    2a6b:	00 00 00 
    2a6e:	ff d1                	call   *%rcx
      exit();
    2a70:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2a77:	00 00 00 
    2a7a:	ff d0                	call   *%rax
    }
    unlink(fname);
    2a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2a80:	48 89 c7             	mov    %rax,%rdi
    2a83:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2a8a:	00 00 00 
    2a8d:	ff d0                	call   *%rax
  for(i = 0; i < 2; i++){
    2a8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2a93:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
    2a97:	0f 8e df fe ff ff    	jle    297c <fourfiles+0x1e3>
  }

  printf(1, "fourfiles ok\n");
    2a9d:	48 b8 05 77 00 00 00 	movabs $0x7705,%rax
    2aa4:	00 00 00 
    2aa7:	48 89 c6             	mov    %rax,%rsi
    2aaa:	bf 01 00 00 00       	mov    $0x1,%edi
    2aaf:	b8 00 00 00 00       	mov    $0x0,%eax
    2ab4:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2abb:	00 00 00 
    2abe:	ff d2                	call   *%rdx
}
    2ac0:	90                   	nop
    2ac1:	c9                   	leave
    2ac2:	c3                   	ret

0000000000002ac3 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    2ac3:	55                   	push   %rbp
    2ac4:	48 89 e5             	mov    %rsp,%rbp
    2ac7:	48 83 ec 30          	sub    $0x30,%rsp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    2acb:	48 b8 13 77 00 00 00 	movabs $0x7713,%rax
    2ad2:	00 00 00 
    2ad5:	48 89 c6             	mov    %rax,%rsi
    2ad8:	bf 01 00 00 00       	mov    $0x1,%edi
    2add:	b8 00 00 00 00       	mov    $0x0,%eax
    2ae2:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2ae9:	00 00 00 
    2aec:	ff d2                	call   *%rdx

  for(pi = 0; pi < 4; pi++){
    2aee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2af5:	e9 15 01 00 00       	jmp    2c0f <createdelete+0x14c>
    pid = fork();
    2afa:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    2b01:	00 00 00 
    2b04:	ff d0                	call   *%rax
    2b06:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(pid < 0){
    2b09:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    2b0d:	79 19                	jns    2b28 <createdelete+0x65>
      failexit("fork");
    2b0f:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    2b16:	00 00 00 
    2b19:	48 89 c7             	mov    %rax,%rdi
    2b1c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2b23:	00 00 00 
    2b26:	ff d0                	call   *%rax
    }

    if(pid == 0){
    2b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    2b2c:	0f 85 d9 00 00 00    	jne    2c0b <createdelete+0x148>
      name[0] = 'p' + pi;
    2b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2b35:	83 c0 70             	add    $0x70,%eax
    2b38:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[2] = '\0';
    2b3b:	c6 45 d2 00          	movb   $0x0,-0x2e(%rbp)
      for(i = 0; i < N; i++){
    2b3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2b46:	e9 aa 00 00 00       	jmp    2bf5 <createdelete+0x132>
        name[1] = '0' + i;
    2b4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2b4e:	83 c0 30             	add    $0x30,%eax
    2b51:	88 45 d1             	mov    %al,-0x2f(%rbp)
        fd = open(name, O_CREATE | O_RDWR);
    2b54:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2b58:	be 02 02 00 00       	mov    $0x202,%esi
    2b5d:	48 89 c7             	mov    %rax,%rdi
    2b60:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    2b67:	00 00 00 
    2b6a:	ff d0                	call   *%rax
    2b6c:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if(fd < 0){
    2b6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2b73:	79 19                	jns    2b8e <createdelete+0xcb>
          failexit("create");
    2b75:	48 b8 d1 76 00 00 00 	movabs $0x76d1,%rax
    2b7c:	00 00 00 
    2b7f:	48 89 c7             	mov    %rax,%rdi
    2b82:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2b89:	00 00 00 
    2b8c:	ff d0                	call   *%rax
        }
        close(fd);
    2b8e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2b91:	89 c7                	mov    %eax,%edi
    2b93:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2b9a:	00 00 00 
    2b9d:	ff d0                	call   *%rax
        if(i > 0 && (i % 2 ) == 0){
    2b9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2ba3:	7e 4c                	jle    2bf1 <createdelete+0x12e>
    2ba5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2ba8:	83 e0 01             	and    $0x1,%eax
    2bab:	85 c0                	test   %eax,%eax
    2bad:	75 42                	jne    2bf1 <createdelete+0x12e>
          name[1] = '0' + (i / 2);
    2baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2bb2:	89 c2                	mov    %eax,%edx
    2bb4:	c1 ea 1f             	shr    $0x1f,%edx
    2bb7:	01 d0                	add    %edx,%eax
    2bb9:	d1 f8                	sar    $1,%eax
    2bbb:	83 c0 30             	add    $0x30,%eax
    2bbe:	88 45 d1             	mov    %al,-0x2f(%rbp)
          if(unlink(name) < 0){
    2bc1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2bc5:	48 89 c7             	mov    %rax,%rdi
    2bc8:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2bcf:	00 00 00 
    2bd2:	ff d0                	call   *%rax
    2bd4:	85 c0                	test   %eax,%eax
    2bd6:	79 19                	jns    2bf1 <createdelete+0x12e>
            failexit("unlink");
    2bd8:	48 b8 db 71 00 00 00 	movabs $0x71db,%rax
    2bdf:	00 00 00 
    2be2:	48 89 c7             	mov    %rax,%rdi
    2be5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2bec:	00 00 00 
    2bef:	ff d0                	call   *%rax
      for(i = 0; i < N; i++){
    2bf1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2bf5:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    2bf9:	0f 8e 4c ff ff ff    	jle    2b4b <createdelete+0x88>
          }
        }
      }
      exit();
    2bff:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2c06:	00 00 00 
    2c09:	ff d0                	call   *%rax
  for(pi = 0; pi < 4; pi++){
    2c0b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2c0f:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2c13:	0f 8e e1 fe ff ff    	jle    2afa <createdelete+0x37>
    }
  }

  for(pi = 0; pi < 4; pi++){
    2c19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2c20:	eb 10                	jmp    2c32 <createdelete+0x16f>
    wait();
    2c22:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    2c29:	00 00 00 
    2c2c:	ff d0                	call   *%rax
  for(pi = 0; pi < 4; pi++){
    2c2e:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2c32:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2c36:	7e ea                	jle    2c22 <createdelete+0x15f>
  }

  name[0] = name[1] = name[2] = 0;
    2c38:	c6 45 d2 00          	movb   $0x0,-0x2e(%rbp)
    2c3c:	0f b6 45 d2          	movzbl -0x2e(%rbp),%eax
    2c40:	88 45 d1             	mov    %al,-0x2f(%rbp)
    2c43:	0f b6 45 d1          	movzbl -0x2f(%rbp),%eax
    2c47:	88 45 d0             	mov    %al,-0x30(%rbp)
  for(i = 0; i < N; i++){
    2c4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2c51:	e9 f2 00 00 00       	jmp    2d48 <createdelete+0x285>
    for(pi = 0; pi < 4; pi++){
    2c56:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2c5d:	e9 d8 00 00 00       	jmp    2d3a <createdelete+0x277>
      name[0] = 'p' + pi;
    2c62:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2c65:	83 c0 70             	add    $0x70,%eax
    2c68:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[1] = '0' + i;
    2c6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2c6e:	83 c0 30             	add    $0x30,%eax
    2c71:	88 45 d1             	mov    %al,-0x2f(%rbp)
      fd = open(name, 0);
    2c74:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2c78:	be 00 00 00 00       	mov    $0x0,%esi
    2c7d:	48 89 c7             	mov    %rax,%rdi
    2c80:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    2c87:	00 00 00 
    2c8a:	ff d0                	call   *%rax
    2c8c:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if((i == 0 || i >= N/2) && fd < 0){
    2c8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2c93:	74 06                	je     2c9b <createdelete+0x1d8>
    2c95:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
    2c99:	7e 3c                	jle    2cd7 <createdelete+0x214>
    2c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2c9f:	79 36                	jns    2cd7 <createdelete+0x214>
        printf(1, "oops createdelete %s didn't exist\n", name);
    2ca1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2ca5:	48 b9 28 77 00 00 00 	movabs $0x7728,%rcx
    2cac:	00 00 00 
    2caf:	48 89 c2             	mov    %rax,%rdx
    2cb2:	48 89 ce             	mov    %rcx,%rsi
    2cb5:	bf 01 00 00 00       	mov    $0x1,%edi
    2cba:	b8 00 00 00 00       	mov    $0x0,%eax
    2cbf:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    2cc6:	00 00 00 
    2cc9:	ff d1                	call   *%rcx
        exit();
    2ccb:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2cd2:	00 00 00 
    2cd5:	ff d0                	call   *%rax
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2cd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2cdb:	7e 42                	jle    2d1f <createdelete+0x25c>
    2cdd:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
    2ce1:	7f 3c                	jg     2d1f <createdelete+0x25c>
    2ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2ce7:	78 36                	js     2d1f <createdelete+0x25c>
        printf(1, "oops createdelete %s did exist\n", name);
    2ce9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2ced:	48 b9 50 77 00 00 00 	movabs $0x7750,%rcx
    2cf4:	00 00 00 
    2cf7:	48 89 c2             	mov    %rax,%rdx
    2cfa:	48 89 ce             	mov    %rcx,%rsi
    2cfd:	bf 01 00 00 00       	mov    $0x1,%edi
    2d02:	b8 00 00 00 00       	mov    $0x0,%eax
    2d07:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    2d0e:	00 00 00 
    2d11:	ff d1                	call   *%rcx
        exit();
    2d13:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    2d1a:	00 00 00 
    2d1d:	ff d0                	call   *%rax
      }
      if(fd >= 0)
    2d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    2d23:	78 11                	js     2d36 <createdelete+0x273>
        close(fd);
    2d25:	8b 45 f4             	mov    -0xc(%rbp),%eax
    2d28:	89 c7                	mov    %eax,%edi
    2d2a:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2d31:	00 00 00 
    2d34:	ff d0                	call   *%rax
    for(pi = 0; pi < 4; pi++){
    2d36:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2d3a:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2d3e:	0f 8e 1e ff ff ff    	jle    2c62 <createdelete+0x19f>
  for(i = 0; i < N; i++){
    2d44:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2d48:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    2d4c:	0f 8e 04 ff ff ff    	jle    2c56 <createdelete+0x193>
    }
  }

  for(i = 0; i < N; i++){
    2d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    2d59:	eb 3c                	jmp    2d97 <createdelete+0x2d4>
    for(pi = 0; pi < 4; pi++){
    2d5b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    2d62:	eb 29                	jmp    2d8d <createdelete+0x2ca>
      name[0] = 'p' + i;
    2d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2d67:	83 c0 70             	add    $0x70,%eax
    2d6a:	88 45 d0             	mov    %al,-0x30(%rbp)
      name[1] = '0' + i;
    2d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2d70:	83 c0 30             	add    $0x30,%eax
    2d73:	88 45 d1             	mov    %al,-0x2f(%rbp)
      unlink(name);
    2d76:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    2d7a:	48 89 c7             	mov    %rax,%rdi
    2d7d:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2d84:	00 00 00 
    2d87:	ff d0                	call   *%rax
    for(pi = 0; pi < 4; pi++){
    2d89:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    2d8d:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
    2d91:	7e d1                	jle    2d64 <createdelete+0x2a1>
  for(i = 0; i < N; i++){
    2d93:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    2d97:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    2d9b:	7e be                	jle    2d5b <createdelete+0x298>
    }
  }

  printf(1, "createdelete ok\n");
    2d9d:	48 b8 70 77 00 00 00 	movabs $0x7770,%rax
    2da4:	00 00 00 
    2da7:	48 89 c6             	mov    %rax,%rsi
    2daa:	bf 01 00 00 00       	mov    $0x1,%edi
    2daf:	b8 00 00 00 00       	mov    $0x0,%eax
    2db4:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2dbb:	00 00 00 
    2dbe:	ff d2                	call   *%rdx
}
    2dc0:	90                   	nop
    2dc1:	c9                   	leave
    2dc2:	c3                   	ret

0000000000002dc3 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    2dc3:	55                   	push   %rbp
    2dc4:	48 89 e5             	mov    %rsp,%rbp
    2dc7:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    2dcb:	48 b8 81 77 00 00 00 	movabs $0x7781,%rax
    2dd2:	00 00 00 
    2dd5:	48 89 c6             	mov    %rax,%rsi
    2dd8:	bf 01 00 00 00       	mov    $0x1,%edi
    2ddd:	b8 00 00 00 00       	mov    $0x0,%eax
    2de2:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    2de9:	00 00 00 
    2dec:	ff d2                	call   *%rdx
  fd = open("unlinkread", O_CREATE | O_RDWR);
    2dee:	48 b8 92 77 00 00 00 	movabs $0x7792,%rax
    2df5:	00 00 00 
    2df8:	be 02 02 00 00       	mov    $0x202,%esi
    2dfd:	48 89 c7             	mov    %rax,%rdi
    2e00:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    2e07:	00 00 00 
    2e0a:	ff d0                	call   *%rax
    2e0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    2e0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2e13:	79 19                	jns    2e2e <unlinkread+0x6b>
    failexit("create unlinkread");
    2e15:	48 b8 9d 77 00 00 00 	movabs $0x779d,%rax
    2e1c:	00 00 00 
    2e1f:	48 89 c7             	mov    %rax,%rdi
    2e22:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2e29:	00 00 00 
    2e2c:	ff d0                	call   *%rax
  }
  write(fd, "hello", 5);
    2e2e:	48 b9 af 77 00 00 00 	movabs $0x77af,%rcx
    2e35:	00 00 00 
    2e38:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2e3b:	ba 05 00 00 00       	mov    $0x5,%edx
    2e40:	48 89 ce             	mov    %rcx,%rsi
    2e43:	89 c7                	mov    %eax,%edi
    2e45:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    2e4c:	00 00 00 
    2e4f:	ff d0                	call   *%rax
  close(fd);
    2e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2e54:	89 c7                	mov    %eax,%edi
    2e56:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2e5d:	00 00 00 
    2e60:	ff d0                	call   *%rax

  fd = open("unlinkread", O_RDWR);
    2e62:	48 b8 92 77 00 00 00 	movabs $0x7792,%rax
    2e69:	00 00 00 
    2e6c:	be 02 00 00 00       	mov    $0x2,%esi
    2e71:	48 89 c7             	mov    %rax,%rdi
    2e74:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    2e7b:	00 00 00 
    2e7e:	ff d0                	call   *%rax
    2e80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    2e83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    2e87:	79 19                	jns    2ea2 <unlinkread+0xdf>
    failexit("open unlinkread");
    2e89:	48 b8 b5 77 00 00 00 	movabs $0x77b5,%rax
    2e90:	00 00 00 
    2e93:	48 89 c7             	mov    %rax,%rdi
    2e96:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2e9d:	00 00 00 
    2ea0:	ff d0                	call   *%rax
  }
  if(unlink("unlinkread") != 0){
    2ea2:	48 b8 92 77 00 00 00 	movabs $0x7792,%rax
    2ea9:	00 00 00 
    2eac:	48 89 c7             	mov    %rax,%rdi
    2eaf:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2eb6:	00 00 00 
    2eb9:	ff d0                	call   *%rax
    2ebb:	85 c0                	test   %eax,%eax
    2ebd:	74 19                	je     2ed8 <unlinkread+0x115>
    failexit("unlink unlinkread");
    2ebf:	48 b8 c5 77 00 00 00 	movabs $0x77c5,%rax
    2ec6:	00 00 00 
    2ec9:	48 89 c7             	mov    %rax,%rdi
    2ecc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2ed3:	00 00 00 
    2ed6:	ff d0                	call   *%rax
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    2ed8:	48 b8 92 77 00 00 00 	movabs $0x7792,%rax
    2edf:	00 00 00 
    2ee2:	be 02 02 00 00       	mov    $0x202,%esi
    2ee7:	48 89 c7             	mov    %rax,%rdi
    2eea:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    2ef1:	00 00 00 
    2ef4:	ff d0                	call   *%rax
    2ef6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  write(fd1, "yyy", 3);
    2ef9:	48 b9 d7 77 00 00 00 	movabs $0x77d7,%rcx
    2f00:	00 00 00 
    2f03:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2f06:	ba 03 00 00 00       	mov    $0x3,%edx
    2f0b:	48 89 ce             	mov    %rcx,%rsi
    2f0e:	89 c7                	mov    %eax,%edi
    2f10:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    2f17:	00 00 00 
    2f1a:	ff d0                	call   *%rax
  close(fd1);
    2f1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    2f1f:	89 c7                	mov    %eax,%edi
    2f21:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2f28:	00 00 00 
    2f2b:	ff d0                	call   *%rax

  if(read(fd, buf, sizeof(buf)) != 5){
    2f2d:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    2f34:	00 00 00 
    2f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2f3a:	ba 00 20 00 00       	mov    $0x2000,%edx
    2f3f:	48 89 ce             	mov    %rcx,%rsi
    2f42:	89 c7                	mov    %eax,%edi
    2f44:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    2f4b:	00 00 00 
    2f4e:	ff d0                	call   *%rax
    2f50:	83 f8 05             	cmp    $0x5,%eax
    2f53:	74 19                	je     2f6e <unlinkread+0x1ab>
    failexit("unlinkread read failed");
    2f55:	48 b8 db 77 00 00 00 	movabs $0x77db,%rax
    2f5c:	00 00 00 
    2f5f:	48 89 c7             	mov    %rax,%rdi
    2f62:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2f69:	00 00 00 
    2f6c:	ff d0                	call   *%rax
  }
  if(buf[0] != 'h'){
    2f6e:	48 b8 80 87 00 00 00 	movabs $0x8780,%rax
    2f75:	00 00 00 
    2f78:	0f b6 00             	movzbl (%rax),%eax
    2f7b:	3c 68                	cmp    $0x68,%al
    2f7d:	74 19                	je     2f98 <unlinkread+0x1d5>
    failexit("unlinkread wrong data");
    2f7f:	48 b8 f2 77 00 00 00 	movabs $0x77f2,%rax
    2f86:	00 00 00 
    2f89:	48 89 c7             	mov    %rax,%rdi
    2f8c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2f93:	00 00 00 
    2f96:	ff d0                	call   *%rax
  }
  if(write(fd, buf, 10) != 10){
    2f98:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    2f9f:	00 00 00 
    2fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2fa5:	ba 0a 00 00 00       	mov    $0xa,%edx
    2faa:	48 89 ce             	mov    %rcx,%rsi
    2fad:	89 c7                	mov    %eax,%edi
    2faf:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    2fb6:	00 00 00 
    2fb9:	ff d0                	call   *%rax
    2fbb:	83 f8 0a             	cmp    $0xa,%eax
    2fbe:	74 19                	je     2fd9 <unlinkread+0x216>
    failexit("unlinkread write");
    2fc0:	48 b8 08 78 00 00 00 	movabs $0x7808,%rax
    2fc7:	00 00 00 
    2fca:	48 89 c7             	mov    %rax,%rdi
    2fcd:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    2fd4:	00 00 00 
    2fd7:	ff d0                	call   *%rax
  }
  close(fd);
    2fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    2fdc:	89 c7                	mov    %eax,%edi
    2fde:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    2fe5:	00 00 00 
    2fe8:	ff d0                	call   *%rax
  unlink("unlinkread");
    2fea:	48 b8 92 77 00 00 00 	movabs $0x7792,%rax
    2ff1:	00 00 00 
    2ff4:	48 89 c7             	mov    %rax,%rdi
    2ff7:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    2ffe:	00 00 00 
    3001:	ff d0                	call   *%rax
  printf(1, "unlinkread ok\n");
    3003:	48 b8 19 78 00 00 00 	movabs $0x7819,%rax
    300a:	00 00 00 
    300d:	48 89 c6             	mov    %rax,%rsi
    3010:	bf 01 00 00 00       	mov    $0x1,%edi
    3015:	b8 00 00 00 00       	mov    $0x0,%eax
    301a:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    3021:	00 00 00 
    3024:	ff d2                	call   *%rdx
}
    3026:	90                   	nop
    3027:	c9                   	leave
    3028:	c3                   	ret

0000000000003029 <linktest>:

void
linktest(void)
{
    3029:	55                   	push   %rbp
    302a:	48 89 e5             	mov    %rsp,%rbp
    302d:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  printf(1, "linktest\n");
    3031:	48 b8 28 78 00 00 00 	movabs $0x7828,%rax
    3038:	00 00 00 
    303b:	48 89 c6             	mov    %rax,%rsi
    303e:	bf 01 00 00 00       	mov    $0x1,%edi
    3043:	b8 00 00 00 00       	mov    $0x0,%eax
    3048:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    304f:	00 00 00 
    3052:	ff d2                	call   *%rdx

  unlink("lf1");
    3054:	48 b8 32 78 00 00 00 	movabs $0x7832,%rax
    305b:	00 00 00 
    305e:	48 89 c7             	mov    %rax,%rdi
    3061:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3068:	00 00 00 
    306b:	ff d0                	call   *%rax
  unlink("lf2");
    306d:	48 b8 36 78 00 00 00 	movabs $0x7836,%rax
    3074:	00 00 00 
    3077:	48 89 c7             	mov    %rax,%rdi
    307a:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3081:	00 00 00 
    3084:	ff d0                	call   *%rax

  fd = open("lf1", O_CREATE|O_RDWR);
    3086:	48 b8 32 78 00 00 00 	movabs $0x7832,%rax
    308d:	00 00 00 
    3090:	be 02 02 00 00       	mov    $0x202,%esi
    3095:	48 89 c7             	mov    %rax,%rdi
    3098:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    309f:	00 00 00 
    30a2:	ff d0                	call   *%rax
    30a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    30a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    30ab:	79 19                	jns    30c6 <linktest+0x9d>
    failexit("create lf1");
    30ad:	48 b8 3a 78 00 00 00 	movabs $0x783a,%rax
    30b4:	00 00 00 
    30b7:	48 89 c7             	mov    %rax,%rdi
    30ba:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    30c1:	00 00 00 
    30c4:	ff d0                	call   *%rax
  }
  if(write(fd, "hello", 5) != 5){
    30c6:	48 b9 af 77 00 00 00 	movabs $0x77af,%rcx
    30cd:	00 00 00 
    30d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    30d3:	ba 05 00 00 00       	mov    $0x5,%edx
    30d8:	48 89 ce             	mov    %rcx,%rsi
    30db:	89 c7                	mov    %eax,%edi
    30dd:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    30e4:	00 00 00 
    30e7:	ff d0                	call   *%rax
    30e9:	83 f8 05             	cmp    $0x5,%eax
    30ec:	74 19                	je     3107 <linktest+0xde>
    failexit("write lf1");
    30ee:	48 b8 45 78 00 00 00 	movabs $0x7845,%rax
    30f5:	00 00 00 
    30f8:	48 89 c7             	mov    %rax,%rdi
    30fb:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3102:	00 00 00 
    3105:	ff d0                	call   *%rax
  }
  close(fd);
    3107:	8b 45 fc             	mov    -0x4(%rbp),%eax
    310a:	89 c7                	mov    %eax,%edi
    310c:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3113:	00 00 00 
    3116:	ff d0                	call   *%rax

  if(link("lf1", "lf2") < 0){
    3118:	48 ba 36 78 00 00 00 	movabs $0x7836,%rdx
    311f:	00 00 00 
    3122:	48 b8 32 78 00 00 00 	movabs $0x7832,%rax
    3129:	00 00 00 
    312c:	48 89 d6             	mov    %rdx,%rsi
    312f:	48 89 c7             	mov    %rax,%rdi
    3132:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    3139:	00 00 00 
    313c:	ff d0                	call   *%rax
    313e:	85 c0                	test   %eax,%eax
    3140:	79 19                	jns    315b <linktest+0x132>
    failexit("link lf1 lf2");
    3142:	48 b8 4f 78 00 00 00 	movabs $0x784f,%rax
    3149:	00 00 00 
    314c:	48 89 c7             	mov    %rax,%rdi
    314f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3156:	00 00 00 
    3159:	ff d0                	call   *%rax
  }
  unlink("lf1");
    315b:	48 b8 32 78 00 00 00 	movabs $0x7832,%rax
    3162:	00 00 00 
    3165:	48 89 c7             	mov    %rax,%rdi
    3168:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    316f:	00 00 00 
    3172:	ff d0                	call   *%rax

  if(open("lf1", 0) >= 0){
    3174:	48 b8 32 78 00 00 00 	movabs $0x7832,%rax
    317b:	00 00 00 
    317e:	be 00 00 00 00       	mov    $0x0,%esi
    3183:	48 89 c7             	mov    %rax,%rdi
    3186:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    318d:	00 00 00 
    3190:	ff d0                	call   *%rax
    3192:	85 c0                	test   %eax,%eax
    3194:	78 19                	js     31af <linktest+0x186>
    failexit("unlinked lf1 but it is still there!");
    3196:	48 b8 60 78 00 00 00 	movabs $0x7860,%rax
    319d:	00 00 00 
    31a0:	48 89 c7             	mov    %rax,%rdi
    31a3:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    31aa:	00 00 00 
    31ad:	ff d0                	call   *%rax
  }

  fd = open("lf2", 0);
    31af:	48 b8 36 78 00 00 00 	movabs $0x7836,%rax
    31b6:	00 00 00 
    31b9:	be 00 00 00 00       	mov    $0x0,%esi
    31be:	48 89 c7             	mov    %rax,%rdi
    31c1:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    31c8:	00 00 00 
    31cb:	ff d0                	call   *%rax
    31cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    31d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    31d4:	79 19                	jns    31ef <linktest+0x1c6>
    failexit("open lf2");
    31d6:	48 b8 84 78 00 00 00 	movabs $0x7884,%rax
    31dd:	00 00 00 
    31e0:	48 89 c7             	mov    %rax,%rdi
    31e3:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    31ea:	00 00 00 
    31ed:	ff d0                	call   *%rax
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    31ef:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    31f6:	00 00 00 
    31f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    31fc:	ba 00 20 00 00       	mov    $0x2000,%edx
    3201:	48 89 ce             	mov    %rcx,%rsi
    3204:	89 c7                	mov    %eax,%edi
    3206:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    320d:	00 00 00 
    3210:	ff d0                	call   *%rax
    3212:	83 f8 05             	cmp    $0x5,%eax
    3215:	74 19                	je     3230 <linktest+0x207>
    failexit("read lf2");
    3217:	48 b8 8d 78 00 00 00 	movabs $0x788d,%rax
    321e:	00 00 00 
    3221:	48 89 c7             	mov    %rax,%rdi
    3224:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    322b:	00 00 00 
    322e:	ff d0                	call   *%rax
  }
  close(fd);
    3230:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3233:	89 c7                	mov    %eax,%edi
    3235:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    323c:	00 00 00 
    323f:	ff d0                	call   *%rax

  if(link("lf2", "lf2") >= 0){
    3241:	48 ba 36 78 00 00 00 	movabs $0x7836,%rdx
    3248:	00 00 00 
    324b:	48 b8 36 78 00 00 00 	movabs $0x7836,%rax
    3252:	00 00 00 
    3255:	48 89 d6             	mov    %rdx,%rsi
    3258:	48 89 c7             	mov    %rax,%rdi
    325b:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    3262:	00 00 00 
    3265:	ff d0                	call   *%rax
    3267:	85 c0                	test   %eax,%eax
    3269:	78 19                	js     3284 <linktest+0x25b>
    failexit("link lf2 lf2 succeeded! oops");
    326b:	48 b8 96 78 00 00 00 	movabs $0x7896,%rax
    3272:	00 00 00 
    3275:	48 89 c7             	mov    %rax,%rdi
    3278:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    327f:	00 00 00 
    3282:	ff d0                	call   *%rax
  }

  unlink("lf2");
    3284:	48 b8 36 78 00 00 00 	movabs $0x7836,%rax
    328b:	00 00 00 
    328e:	48 89 c7             	mov    %rax,%rdi
    3291:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3298:	00 00 00 
    329b:	ff d0                	call   *%rax
  if(link("lf2", "lf1") >= 0){
    329d:	48 ba 32 78 00 00 00 	movabs $0x7832,%rdx
    32a4:	00 00 00 
    32a7:	48 b8 36 78 00 00 00 	movabs $0x7836,%rax
    32ae:	00 00 00 
    32b1:	48 89 d6             	mov    %rdx,%rsi
    32b4:	48 89 c7             	mov    %rax,%rdi
    32b7:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    32be:	00 00 00 
    32c1:	ff d0                	call   *%rax
    32c3:	85 c0                	test   %eax,%eax
    32c5:	78 19                	js     32e0 <linktest+0x2b7>
    failexit("link non-existant succeeded! oops");
    32c7:	48 b8 b8 78 00 00 00 	movabs $0x78b8,%rax
    32ce:	00 00 00 
    32d1:	48 89 c7             	mov    %rax,%rdi
    32d4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    32db:	00 00 00 
    32de:	ff d0                	call   *%rax
  }

  if(link(".", "lf1") >= 0){
    32e0:	48 ba 32 78 00 00 00 	movabs $0x7832,%rdx
    32e7:	00 00 00 
    32ea:	48 b8 da 78 00 00 00 	movabs $0x78da,%rax
    32f1:	00 00 00 
    32f4:	48 89 d6             	mov    %rdx,%rsi
    32f7:	48 89 c7             	mov    %rax,%rdi
    32fa:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    3301:	00 00 00 
    3304:	ff d0                	call   *%rax
    3306:	85 c0                	test   %eax,%eax
    3308:	78 19                	js     3323 <linktest+0x2fa>
    failexit("link . lf1 succeeded! oops");
    330a:	48 b8 dc 78 00 00 00 	movabs $0x78dc,%rax
    3311:	00 00 00 
    3314:	48 89 c7             	mov    %rax,%rdi
    3317:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    331e:	00 00 00 
    3321:	ff d0                	call   *%rax
  }

  printf(1, "linktest ok\n");
    3323:	48 b8 f7 78 00 00 00 	movabs $0x78f7,%rax
    332a:	00 00 00 
    332d:	48 89 c6             	mov    %rax,%rsi
    3330:	bf 01 00 00 00       	mov    $0x1,%edi
    3335:	b8 00 00 00 00       	mov    $0x0,%eax
    333a:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    3341:	00 00 00 
    3344:	ff d2                	call   *%rdx
}
    3346:	90                   	nop
    3347:	c9                   	leave
    3348:	c3                   	ret

0000000000003349 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    3349:	55                   	push   %rbp
    334a:	48 89 e5             	mov    %rsp,%rbp
    334d:	48 83 ec 50          	sub    $0x50,%rsp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    3351:	48 b8 04 79 00 00 00 	movabs $0x7904,%rax
    3358:	00 00 00 
    335b:	48 89 c6             	mov    %rax,%rsi
    335e:	bf 01 00 00 00       	mov    $0x1,%edi
    3363:	b8 00 00 00 00       	mov    $0x0,%eax
    3368:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    336f:	00 00 00 
    3372:	ff d2                	call   *%rdx
  file[0] = 'C';
    3374:	c6 45 ed 43          	movb   $0x43,-0x13(%rbp)
  file[2] = '\0';
    3378:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  for(i = 0; i < 40; i++){
    337c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    3383:	e9 5e 01 00 00       	jmp    34e6 <concreate+0x19d>
    file[1] = '0' + i;
    3388:	8b 45 fc             	mov    -0x4(%rbp),%eax
    338b:	83 c0 30             	add    $0x30,%eax
    338e:	88 45 ee             	mov    %al,-0x12(%rbp)
    unlink(file);
    3391:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3395:	48 89 c7             	mov    %rax,%rdi
    3398:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    339f:	00 00 00 
    33a2:	ff d0                	call   *%rax
    pid = fork();
    33a4:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    33ab:	00 00 00 
    33ae:	ff d0                	call   *%rax
    33b0:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(pid && (i % 3) == 1){
    33b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    33b7:	74 4f                	je     3408 <concreate+0xbf>
    33b9:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    33bc:	48 63 c1             	movslq %ecx,%rax
    33bf:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    33c6:	48 c1 e8 20          	shr    $0x20,%rax
    33ca:	48 89 c2             	mov    %rax,%rdx
    33cd:	89 c8                	mov    %ecx,%eax
    33cf:	c1 f8 1f             	sar    $0x1f,%eax
    33d2:	29 c2                	sub    %eax,%edx
    33d4:	89 d0                	mov    %edx,%eax
    33d6:	01 c0                	add    %eax,%eax
    33d8:	01 d0                	add    %edx,%eax
    33da:	29 c1                	sub    %eax,%ecx
    33dc:	89 ca                	mov    %ecx,%edx
    33de:	83 fa 01             	cmp    $0x1,%edx
    33e1:	75 25                	jne    3408 <concreate+0xbf>
      link("C0", file);
    33e3:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    33e7:	48 ba 14 79 00 00 00 	movabs $0x7914,%rdx
    33ee:	00 00 00 
    33f1:	48 89 c6             	mov    %rax,%rsi
    33f4:	48 89 d7             	mov    %rdx,%rdi
    33f7:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    33fe:	00 00 00 
    3401:	ff d0                	call   *%rax
    3403:	e9 bc 00 00 00       	jmp    34c4 <concreate+0x17b>
    } else if(pid == 0 && (i % 5) == 1){
    3408:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    340c:	75 4e                	jne    345c <concreate+0x113>
    340e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    3411:	48 63 c1             	movslq %ecx,%rax
    3414:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    341b:	48 c1 e8 20          	shr    $0x20,%rax
    341f:	89 c2                	mov    %eax,%edx
    3421:	d1 fa                	sar    $1,%edx
    3423:	89 c8                	mov    %ecx,%eax
    3425:	c1 f8 1f             	sar    $0x1f,%eax
    3428:	29 c2                	sub    %eax,%edx
    342a:	89 d0                	mov    %edx,%eax
    342c:	c1 e0 02             	shl    $0x2,%eax
    342f:	01 d0                	add    %edx,%eax
    3431:	29 c1                	sub    %eax,%ecx
    3433:	89 ca                	mov    %ecx,%edx
    3435:	83 fa 01             	cmp    $0x1,%edx
    3438:	75 22                	jne    345c <concreate+0x113>
      link("C0", file);
    343a:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    343e:	48 ba 14 79 00 00 00 	movabs $0x7914,%rdx
    3445:	00 00 00 
    3448:	48 89 c6             	mov    %rax,%rsi
    344b:	48 89 d7             	mov    %rdx,%rdi
    344e:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    3455:	00 00 00 
    3458:	ff d0                	call   *%rax
    345a:	eb 68                	jmp    34c4 <concreate+0x17b>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    345c:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3460:	be 02 02 00 00       	mov    $0x202,%esi
    3465:	48 89 c7             	mov    %rax,%rdi
    3468:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    346f:	00 00 00 
    3472:	ff d0                	call   *%rax
    3474:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if(fd < 0){
    3477:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    347b:	79 36                	jns    34b3 <concreate+0x16a>
        printf(1, "concreate create %s failed\n", file);
    347d:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3481:	48 b9 17 79 00 00 00 	movabs $0x7917,%rcx
    3488:	00 00 00 
    348b:	48 89 c2             	mov    %rax,%rdx
    348e:	48 89 ce             	mov    %rcx,%rsi
    3491:	bf 01 00 00 00       	mov    $0x1,%edi
    3496:	b8 00 00 00 00       	mov    $0x0,%eax
    349b:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    34a2:	00 00 00 
    34a5:	ff d1                	call   *%rcx
        exit();
    34a7:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    34ae:	00 00 00 
    34b1:	ff d0                	call   *%rax
      }
      close(fd);
    34b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    34b6:	89 c7                	mov    %eax,%edi
    34b8:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    34bf:	00 00 00 
    34c2:	ff d0                	call   *%rax
    }
    if(pid == 0)
    34c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    34c8:	75 0c                	jne    34d6 <concreate+0x18d>
      exit();
    34ca:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    34d1:	00 00 00 
    34d4:	ff d0                	call   *%rax
    else
      wait();
    34d6:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    34dd:	00 00 00 
    34e0:	ff d0                	call   *%rax
  for(i = 0; i < 40; i++){
    34e2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    34e6:	83 7d fc 27          	cmpl   $0x27,-0x4(%rbp)
    34ea:	0f 8e 98 fe ff ff    	jle    3388 <concreate+0x3f>
  }

  memset(fa, 0, sizeof(fa));
    34f0:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
    34f4:	ba 28 00 00 00       	mov    $0x28,%edx
    34f9:	be 00 00 00 00       	mov    $0x0,%esi
    34fe:	48 89 c7             	mov    %rax,%rdi
    3501:	48 b8 93 64 00 00 00 	movabs $0x6493,%rax
    3508:	00 00 00 
    350b:	ff d0                	call   *%rax
  fd = open(".", 0);
    350d:	48 b8 da 78 00 00 00 	movabs $0x78da,%rax
    3514:	00 00 00 
    3517:	be 00 00 00 00       	mov    $0x0,%esi
    351c:	48 89 c7             	mov    %rax,%rdi
    351f:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3526:	00 00 00 
    3529:	ff d0                	call   *%rax
    352b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  n = 0;
    352e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  while(read(fd, &de, sizeof(de)) > 0){
    3535:	e9 cd 00 00 00       	jmp    3607 <concreate+0x2be>
    if(de.inum == 0)
    353a:	0f b7 45 b0          	movzwl -0x50(%rbp),%eax
    353e:	66 85 c0             	test   %ax,%ax
    3541:	0f 84 bf 00 00 00    	je     3606 <concreate+0x2bd>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3547:	0f b6 45 b2          	movzbl -0x4e(%rbp),%eax
    354b:	3c 43                	cmp    $0x43,%al
    354d:	0f 85 b4 00 00 00    	jne    3607 <concreate+0x2be>
    3553:	0f b6 45 b4          	movzbl -0x4c(%rbp),%eax
    3557:	84 c0                	test   %al,%al
    3559:	0f 85 a8 00 00 00    	jne    3607 <concreate+0x2be>
      i = de.name[1] - '0';
    355f:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
    3563:	0f be c0             	movsbl %al,%eax
    3566:	83 e8 30             	sub    $0x30,%eax
    3569:	89 45 fc             	mov    %eax,-0x4(%rbp)
      if(i < 0 || i >= sizeof(fa)){
    356c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3570:	78 08                	js     357a <concreate+0x231>
    3572:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3575:	83 f8 27             	cmp    $0x27,%eax
    3578:	76 37                	jbe    35b1 <concreate+0x268>
        printf(1, "concreate weird file %s\n", de.name);
    357a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
    357e:	48 8d 50 02          	lea    0x2(%rax),%rdx
    3582:	48 b8 33 79 00 00 00 	movabs $0x7933,%rax
    3589:	00 00 00 
    358c:	48 89 c6             	mov    %rax,%rsi
    358f:	bf 01 00 00 00       	mov    $0x1,%edi
    3594:	b8 00 00 00 00       	mov    $0x0,%eax
    3599:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    35a0:	00 00 00 
    35a3:	ff d1                	call   *%rcx
        exit();
    35a5:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    35ac:	00 00 00 
    35af:	ff d0                	call   *%rax
      }
      if(fa[i]){
    35b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    35b4:	48 98                	cltq
    35b6:	0f b6 44 05 c0       	movzbl -0x40(%rbp,%rax,1),%eax
    35bb:	84 c0                	test   %al,%al
    35bd:	74 37                	je     35f6 <concreate+0x2ad>
        printf(1, "concreate duplicate file %s\n", de.name);
    35bf:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
    35c3:	48 8d 50 02          	lea    0x2(%rax),%rdx
    35c7:	48 b8 4c 79 00 00 00 	movabs $0x794c,%rax
    35ce:	00 00 00 
    35d1:	48 89 c6             	mov    %rax,%rsi
    35d4:	bf 01 00 00 00       	mov    $0x1,%edi
    35d9:	b8 00 00 00 00       	mov    $0x0,%eax
    35de:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    35e5:	00 00 00 
    35e8:	ff d1                	call   *%rcx
        exit();
    35ea:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    35f1:	00 00 00 
    35f4:	ff d0                	call   *%rax
      }
      fa[i] = 1;
    35f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    35f9:	48 98                	cltq
    35fb:	c6 44 05 c0 01       	movb   $0x1,-0x40(%rbp,%rax,1)
      n++;
    3600:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    3604:	eb 01                	jmp    3607 <concreate+0x2be>
      continue;
    3606:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    3607:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
    360b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    360e:	ba 10 00 00 00       	mov    $0x10,%edx
    3613:	48 89 ce             	mov    %rcx,%rsi
    3616:	89 c7                	mov    %eax,%edi
    3618:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    361f:	00 00 00 
    3622:	ff d0                	call   *%rax
    3624:	85 c0                	test   %eax,%eax
    3626:	0f 8f 0e ff ff ff    	jg     353a <concreate+0x1f1>
    }
  }
  close(fd);
    362c:	8b 45 f4             	mov    -0xc(%rbp),%eax
    362f:	89 c7                	mov    %eax,%edi
    3631:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3638:	00 00 00 
    363b:	ff d0                	call   *%rax

  if(n != 40){
    363d:	83 7d f8 28          	cmpl   $0x28,-0x8(%rbp)
    3641:	74 19                	je     365c <concreate+0x313>
    failexit("concreate not enough files in directory listing");
    3643:	48 b8 70 79 00 00 00 	movabs $0x7970,%rax
    364a:	00 00 00 
    364d:	48 89 c7             	mov    %rax,%rdi
    3650:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3657:	00 00 00 
    365a:	ff d0                	call   *%rax
  }

  for(i = 0; i < 40; i++){
    365c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    3663:	e9 a6 01 00 00       	jmp    380e <concreate+0x4c5>
    file[1] = '0' + i;
    3668:	8b 45 fc             	mov    -0x4(%rbp),%eax
    366b:	83 c0 30             	add    $0x30,%eax
    366e:	88 45 ee             	mov    %al,-0x12(%rbp)
    pid = fork();
    3671:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    3678:	00 00 00 
    367b:	ff d0                	call   *%rax
    367d:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(pid < 0){
    3680:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    3684:	79 19                	jns    369f <concreate+0x356>
      failexit("fork");
    3686:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    368d:	00 00 00 
    3690:	48 89 c7             	mov    %rax,%rdi
    3693:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    369a:	00 00 00 
    369d:	ff d0                	call   *%rax
    }
    if(((i % 3) == 0 && pid == 0) ||
    369f:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    36a2:	48 63 c1             	movslq %ecx,%rax
    36a5:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    36ac:	48 c1 e8 20          	shr    $0x20,%rax
    36b0:	48 89 c2             	mov    %rax,%rdx
    36b3:	89 c8                	mov    %ecx,%eax
    36b5:	c1 f8 1f             	sar    $0x1f,%eax
    36b8:	29 c2                	sub    %eax,%edx
    36ba:	89 d0                	mov    %edx,%eax
    36bc:	01 c0                	add    %eax,%eax
    36be:	01 d0                	add    %edx,%eax
    36c0:	29 c1                	sub    %eax,%ecx
    36c2:	89 ca                	mov    %ecx,%edx
    36c4:	85 d2                	test   %edx,%edx
    36c6:	75 06                	jne    36ce <concreate+0x385>
    36c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    36cc:	74 38                	je     3706 <concreate+0x3bd>
       ((i % 3) == 1 && pid != 0)){
    36ce:	8b 4d fc             	mov    -0x4(%rbp),%ecx
    36d1:	48 63 c1             	movslq %ecx,%rax
    36d4:	48 69 c0 56 55 55 55 	imul   $0x55555556,%rax,%rax
    36db:	48 c1 e8 20          	shr    $0x20,%rax
    36df:	48 89 c2             	mov    %rax,%rdx
    36e2:	89 c8                	mov    %ecx,%eax
    36e4:	c1 f8 1f             	sar    $0x1f,%eax
    36e7:	29 c2                	sub    %eax,%edx
    36e9:	89 d0                	mov    %edx,%eax
    36eb:	01 c0                	add    %eax,%eax
    36ed:	01 d0                	add    %edx,%eax
    36ef:	29 c1                	sub    %eax,%ecx
    36f1:	89 ca                	mov    %ecx,%edx
    if(((i % 3) == 0 && pid == 0) ||
    36f3:	83 fa 01             	cmp    $0x1,%edx
    36f6:	0f 85 a4 00 00 00    	jne    37a0 <concreate+0x457>
       ((i % 3) == 1 && pid != 0)){
    36fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    3700:	0f 84 9a 00 00 00    	je     37a0 <concreate+0x457>
      close(open(file, 0));
    3706:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    370a:	be 00 00 00 00       	mov    $0x0,%esi
    370f:	48 89 c7             	mov    %rax,%rdi
    3712:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3719:	00 00 00 
    371c:	ff d0                	call   *%rax
    371e:	89 c7                	mov    %eax,%edi
    3720:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3727:	00 00 00 
    372a:	ff d0                	call   *%rax
      close(open(file, 0));
    372c:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3730:	be 00 00 00 00       	mov    $0x0,%esi
    3735:	48 89 c7             	mov    %rax,%rdi
    3738:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    373f:	00 00 00 
    3742:	ff d0                	call   *%rax
    3744:	89 c7                	mov    %eax,%edi
    3746:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    374d:	00 00 00 
    3750:	ff d0                	call   *%rax
      close(open(file, 0));
    3752:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    3756:	be 00 00 00 00       	mov    $0x0,%esi
    375b:	48 89 c7             	mov    %rax,%rdi
    375e:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3765:	00 00 00 
    3768:	ff d0                	call   *%rax
    376a:	89 c7                	mov    %eax,%edi
    376c:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3773:	00 00 00 
    3776:	ff d0                	call   *%rax
      close(open(file, 0));
    3778:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    377c:	be 00 00 00 00       	mov    $0x0,%esi
    3781:	48 89 c7             	mov    %rax,%rdi
    3784:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    378b:	00 00 00 
    378e:	ff d0                	call   *%rax
    3790:	89 c7                	mov    %eax,%edi
    3792:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3799:	00 00 00 
    379c:	ff d0                	call   *%rax
    379e:	eb 4c                	jmp    37ec <concreate+0x4a3>
    } else {
      unlink(file);
    37a0:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    37a4:	48 89 c7             	mov    %rax,%rdi
    37a7:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    37ae:	00 00 00 
    37b1:	ff d0                	call   *%rax
      unlink(file);
    37b3:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    37b7:	48 89 c7             	mov    %rax,%rdi
    37ba:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    37c1:	00 00 00 
    37c4:	ff d0                	call   *%rax
      unlink(file);
    37c6:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    37ca:	48 89 c7             	mov    %rax,%rdi
    37cd:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    37d4:	00 00 00 
    37d7:	ff d0                	call   *%rax
      unlink(file);
    37d9:	48 8d 45 ed          	lea    -0x13(%rbp),%rax
    37dd:	48 89 c7             	mov    %rax,%rdi
    37e0:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    37e7:	00 00 00 
    37ea:	ff d0                	call   *%rax
    }
    if(pid == 0)
    37ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    37f0:	75 0c                	jne    37fe <concreate+0x4b5>
      exit();
    37f2:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    37f9:	00 00 00 
    37fc:	ff d0                	call   *%rax
    else
      wait();
    37fe:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    3805:	00 00 00 
    3808:	ff d0                	call   *%rax
  for(i = 0; i < 40; i++){
    380a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    380e:	83 7d fc 27          	cmpl   $0x27,-0x4(%rbp)
    3812:	0f 8e 50 fe ff ff    	jle    3668 <concreate+0x31f>
  }

  printf(1, "concreate ok\n");
    3818:	48 b8 a0 79 00 00 00 	movabs $0x79a0,%rax
    381f:	00 00 00 
    3822:	48 89 c6             	mov    %rax,%rsi
    3825:	bf 01 00 00 00       	mov    $0x1,%edi
    382a:	b8 00 00 00 00       	mov    $0x0,%eax
    382f:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    3836:	00 00 00 
    3839:	ff d2                	call   *%rdx
}
    383b:	90                   	nop
    383c:	c9                   	leave
    383d:	c3                   	ret

000000000000383e <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    383e:	55                   	push   %rbp
    383f:	48 89 e5             	mov    %rsp,%rbp
    3842:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, i;

  printf(1, "linkunlink test\n");
    3846:	48 b8 ae 79 00 00 00 	movabs $0x79ae,%rax
    384d:	00 00 00 
    3850:	48 89 c6             	mov    %rax,%rsi
    3853:	bf 01 00 00 00       	mov    $0x1,%edi
    3858:	b8 00 00 00 00       	mov    $0x0,%eax
    385d:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    3864:	00 00 00 
    3867:	ff d2                	call   *%rdx

  unlink("x");
    3869:	48 b8 5e 75 00 00 00 	movabs $0x755e,%rax
    3870:	00 00 00 
    3873:	48 89 c7             	mov    %rax,%rdi
    3876:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    387d:	00 00 00 
    3880:	ff d0                	call   *%rax
  pid = fork();
    3882:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    3889:	00 00 00 
    388c:	ff d0                	call   *%rax
    388e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(pid < 0){
    3891:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    3895:	79 19                	jns    38b0 <linkunlink+0x72>
    failexit("fork");
    3897:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    389e:	00 00 00 
    38a1:	48 89 c7             	mov    %rax,%rdi
    38a4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    38ab:	00 00 00 
    38ae:	ff d0                	call   *%rax
  }

  unsigned int x = (pid ? 1 : 97);
    38b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    38b4:	74 09                	je     38bf <linkunlink+0x81>
    38b6:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
    38bd:	eb 07                	jmp    38c6 <linkunlink+0x88>
    38bf:	c7 45 f8 61 00 00 00 	movl   $0x61,-0x8(%rbp)
  for(i = 0; i < 100; i++){
    38c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    38cd:	e9 cd 00 00 00       	jmp    399f <linkunlink+0x161>
    x = x * 1103515245 + 12345;
    38d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
    38d5:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    38db:	05 39 30 00 00       	add    $0x3039,%eax
    38e0:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if((x % 3) == 0){
    38e3:	8b 4d f8             	mov    -0x8(%rbp),%ecx
    38e6:	89 ca                	mov    %ecx,%edx
    38e8:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    38ed:	48 0f af c2          	imul   %rdx,%rax
    38f1:	48 c1 e8 20          	shr    $0x20,%rax
    38f5:	89 c2                	mov    %eax,%edx
    38f7:	d1 ea                	shr    $1,%edx
    38f9:	89 d0                	mov    %edx,%eax
    38fb:	01 c0                	add    %eax,%eax
    38fd:	01 d0                	add    %edx,%eax
    38ff:	29 c1                	sub    %eax,%ecx
    3901:	89 ca                	mov    %ecx,%edx
    3903:	85 d2                	test   %edx,%edx
    3905:	75 2e                	jne    3935 <linkunlink+0xf7>
      close(open("x", O_RDWR | O_CREATE));
    3907:	48 b8 5e 75 00 00 00 	movabs $0x755e,%rax
    390e:	00 00 00 
    3911:	be 02 02 00 00       	mov    $0x202,%esi
    3916:	48 89 c7             	mov    %rax,%rdi
    3919:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3920:	00 00 00 
    3923:	ff d0                	call   *%rax
    3925:	89 c7                	mov    %eax,%edi
    3927:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    392e:	00 00 00 
    3931:	ff d0                	call   *%rax
    3933:	eb 66                	jmp    399b <linkunlink+0x15d>
    } else if((x % 3) == 1){
    3935:	8b 4d f8             	mov    -0x8(%rbp),%ecx
    3938:	89 ca                	mov    %ecx,%edx
    393a:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    393f:	48 0f af c2          	imul   %rdx,%rax
    3943:	48 c1 e8 20          	shr    $0x20,%rax
    3947:	89 c2                	mov    %eax,%edx
    3949:	d1 ea                	shr    $1,%edx
    394b:	89 d0                	mov    %edx,%eax
    394d:	01 c0                	add    %eax,%eax
    394f:	01 d0                	add    %edx,%eax
    3951:	29 c1                	sub    %eax,%ecx
    3953:	89 ca                	mov    %ecx,%edx
    3955:	83 fa 01             	cmp    $0x1,%edx
    3958:	75 28                	jne    3982 <linkunlink+0x144>
      link("cat", "x");
    395a:	48 ba 5e 75 00 00 00 	movabs $0x755e,%rdx
    3961:	00 00 00 
    3964:	48 b8 bf 79 00 00 00 	movabs $0x79bf,%rax
    396b:	00 00 00 
    396e:	48 89 d6             	mov    %rdx,%rsi
    3971:	48 89 c7             	mov    %rax,%rdi
    3974:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    397b:	00 00 00 
    397e:	ff d0                	call   *%rax
    3980:	eb 19                	jmp    399b <linkunlink+0x15d>
    } else {
      unlink("x");
    3982:	48 b8 5e 75 00 00 00 	movabs $0x755e,%rax
    3989:	00 00 00 
    398c:	48 89 c7             	mov    %rax,%rdi
    398f:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3996:	00 00 00 
    3999:	ff d0                	call   *%rax
  for(i = 0; i < 100; i++){
    399b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    399f:	83 7d fc 63          	cmpl   $0x63,-0x4(%rbp)
    39a3:	0f 8e 29 ff ff ff    	jle    38d2 <linkunlink+0x94>
    }
  }

  if(pid)
    39a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    39ad:	74 0e                	je     39bd <linkunlink+0x17f>
    wait();
    39af:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    39b6:	00 00 00 
    39b9:	ff d0                	call   *%rax
    39bb:	eb 0c                	jmp    39c9 <linkunlink+0x18b>
  else
    exit();
    39bd:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    39c4:	00 00 00 
    39c7:	ff d0                	call   *%rax

  printf(1, "linkunlink ok\n");
    39c9:	48 b8 c3 79 00 00 00 	movabs $0x79c3,%rax
    39d0:	00 00 00 
    39d3:	48 89 c6             	mov    %rax,%rsi
    39d6:	bf 01 00 00 00       	mov    $0x1,%edi
    39db:	b8 00 00 00 00       	mov    $0x0,%eax
    39e0:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    39e7:	00 00 00 
    39ea:	ff d2                	call   *%rdx
}
    39ec:	90                   	nop
    39ed:	c9                   	leave
    39ee:	c3                   	ret

00000000000039ef <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    39ef:	55                   	push   %rbp
    39f0:	48 89 e5             	mov    %rsp,%rbp
    39f3:	48 83 ec 20          	sub    $0x20,%rsp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    39f7:	48 b8 d2 79 00 00 00 	movabs $0x79d2,%rax
    39fe:	00 00 00 
    3a01:	48 89 c6             	mov    %rax,%rsi
    3a04:	bf 01 00 00 00       	mov    $0x1,%edi
    3a09:	b8 00 00 00 00       	mov    $0x0,%eax
    3a0e:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    3a15:	00 00 00 
    3a18:	ff d2                	call   *%rdx
  unlink("bd");
    3a1a:	48 b8 df 79 00 00 00 	movabs $0x79df,%rax
    3a21:	00 00 00 
    3a24:	48 89 c7             	mov    %rax,%rdi
    3a27:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3a2e:	00 00 00 
    3a31:	ff d0                	call   *%rax

  fd = open("bd", O_CREATE);
    3a33:	48 b8 df 79 00 00 00 	movabs $0x79df,%rax
    3a3a:	00 00 00 
    3a3d:	be 00 02 00 00       	mov    $0x200,%esi
    3a42:	48 89 c7             	mov    %rax,%rdi
    3a45:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3a4c:	00 00 00 
    3a4f:	ff d0                	call   *%rax
    3a51:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(fd < 0){
    3a54:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    3a58:	79 19                	jns    3a73 <bigdir+0x84>
    failexit("bigdir create");
    3a5a:	48 b8 e2 79 00 00 00 	movabs $0x79e2,%rax
    3a61:	00 00 00 
    3a64:	48 89 c7             	mov    %rax,%rdi
    3a67:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3a6e:	00 00 00 
    3a71:	ff d0                	call   *%rax
  }
  close(fd);
    3a73:	8b 45 f8             	mov    -0x8(%rbp),%eax
    3a76:	89 c7                	mov    %eax,%edi
    3a78:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3a7f:	00 00 00 
    3a82:	ff d0                	call   *%rax

  for(i = 0; i < 500; i++){
    3a84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    3a8b:	eb 77                	jmp    3b04 <bigdir+0x115>
    name[0] = 'x';
    3a8d:	c6 45 ee 78          	movb   $0x78,-0x12(%rbp)
    name[1] = '0' + (i / 64);
    3a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3a94:	8d 50 3f             	lea    0x3f(%rax),%edx
    3a97:	85 c0                	test   %eax,%eax
    3a99:	0f 48 c2             	cmovs  %edx,%eax
    3a9c:	c1 f8 06             	sar    $0x6,%eax
    3a9f:	83 c0 30             	add    $0x30,%eax
    3aa2:	88 45 ef             	mov    %al,-0x11(%rbp)
    name[2] = '0' + (i % 64);
    3aa5:	8b 55 fc             	mov    -0x4(%rbp),%edx
    3aa8:	89 d0                	mov    %edx,%eax
    3aaa:	c1 f8 1f             	sar    $0x1f,%eax
    3aad:	c1 e8 1a             	shr    $0x1a,%eax
    3ab0:	01 c2                	add    %eax,%edx
    3ab2:	83 e2 3f             	and    $0x3f,%edx
    3ab5:	29 c2                	sub    %eax,%edx
    3ab7:	89 d0                	mov    %edx,%eax
    3ab9:	83 c0 30             	add    $0x30,%eax
    3abc:	88 45 f0             	mov    %al,-0x10(%rbp)
    name[3] = '\0';
    3abf:	c6 45 f1 00          	movb   $0x0,-0xf(%rbp)
    if(link("bd", name) != 0){
    3ac3:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    3ac7:	48 ba df 79 00 00 00 	movabs $0x79df,%rdx
    3ace:	00 00 00 
    3ad1:	48 89 c6             	mov    %rax,%rsi
    3ad4:	48 89 d7             	mov    %rdx,%rdi
    3ad7:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    3ade:	00 00 00 
    3ae1:	ff d0                	call   *%rax
    3ae3:	85 c0                	test   %eax,%eax
    3ae5:	74 19                	je     3b00 <bigdir+0x111>
      failexit("bigdir link");
    3ae7:	48 b8 f0 79 00 00 00 	movabs $0x79f0,%rax
    3aee:	00 00 00 
    3af1:	48 89 c7             	mov    %rax,%rdi
    3af4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3afb:	00 00 00 
    3afe:	ff d0                	call   *%rax
  for(i = 0; i < 500; i++){
    3b00:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    3b04:	81 7d fc f3 01 00 00 	cmpl   $0x1f3,-0x4(%rbp)
    3b0b:	7e 80                	jle    3a8d <bigdir+0x9e>
    }
  }

  unlink("bd");
    3b0d:	48 b8 df 79 00 00 00 	movabs $0x79df,%rax
    3b14:	00 00 00 
    3b17:	48 89 c7             	mov    %rax,%rdi
    3b1a:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3b21:	00 00 00 
    3b24:	ff d0                	call   *%rax
  for(i = 0; i < 500; i++){
    3b26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    3b2d:	eb 6a                	jmp    3b99 <bigdir+0x1aa>
    name[0] = 'x';
    3b2f:	c6 45 ee 78          	movb   $0x78,-0x12(%rbp)
    name[1] = '0' + (i / 64);
    3b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3b36:	8d 50 3f             	lea    0x3f(%rax),%edx
    3b39:	85 c0                	test   %eax,%eax
    3b3b:	0f 48 c2             	cmovs  %edx,%eax
    3b3e:	c1 f8 06             	sar    $0x6,%eax
    3b41:	83 c0 30             	add    $0x30,%eax
    3b44:	88 45 ef             	mov    %al,-0x11(%rbp)
    name[2] = '0' + (i % 64);
    3b47:	8b 55 fc             	mov    -0x4(%rbp),%edx
    3b4a:	89 d0                	mov    %edx,%eax
    3b4c:	c1 f8 1f             	sar    $0x1f,%eax
    3b4f:	c1 e8 1a             	shr    $0x1a,%eax
    3b52:	01 c2                	add    %eax,%edx
    3b54:	83 e2 3f             	and    $0x3f,%edx
    3b57:	29 c2                	sub    %eax,%edx
    3b59:	89 d0                	mov    %edx,%eax
    3b5b:	83 c0 30             	add    $0x30,%eax
    3b5e:	88 45 f0             	mov    %al,-0x10(%rbp)
    name[3] = '\0';
    3b61:	c6 45 f1 00          	movb   $0x0,-0xf(%rbp)
    if(unlink(name) != 0){
    3b65:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    3b69:	48 89 c7             	mov    %rax,%rdi
    3b6c:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3b73:	00 00 00 
    3b76:	ff d0                	call   *%rax
    3b78:	85 c0                	test   %eax,%eax
    3b7a:	74 19                	je     3b95 <bigdir+0x1a6>
      failexit("bigdir unlink failed");
    3b7c:	48 b8 fc 79 00 00 00 	movabs $0x79fc,%rax
    3b83:	00 00 00 
    3b86:	48 89 c7             	mov    %rax,%rdi
    3b89:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3b90:	00 00 00 
    3b93:	ff d0                	call   *%rax
  for(i = 0; i < 500; i++){
    3b95:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    3b99:	81 7d fc f3 01 00 00 	cmpl   $0x1f3,-0x4(%rbp)
    3ba0:	7e 8d                	jle    3b2f <bigdir+0x140>
    }
  }

  printf(1, "bigdir ok\n");
    3ba2:	48 b8 11 7a 00 00 00 	movabs $0x7a11,%rax
    3ba9:	00 00 00 
    3bac:	48 89 c6             	mov    %rax,%rsi
    3baf:	bf 01 00 00 00       	mov    $0x1,%edi
    3bb4:	b8 00 00 00 00       	mov    $0x0,%eax
    3bb9:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    3bc0:	00 00 00 
    3bc3:	ff d2                	call   *%rdx
}
    3bc5:	90                   	nop
    3bc6:	c9                   	leave
    3bc7:	c3                   	ret

0000000000003bc8 <subdir>:

void
subdir(void)
{
    3bc8:	55                   	push   %rbp
    3bc9:	48 89 e5             	mov    %rsp,%rbp
    3bcc:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, cc;

  printf(1, "subdir test\n");
    3bd0:	48 b8 1c 7a 00 00 00 	movabs $0x7a1c,%rax
    3bd7:	00 00 00 
    3bda:	48 89 c6             	mov    %rax,%rsi
    3bdd:	bf 01 00 00 00       	mov    $0x1,%edi
    3be2:	b8 00 00 00 00       	mov    $0x0,%eax
    3be7:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    3bee:	00 00 00 
    3bf1:	ff d2                	call   *%rdx

  unlink("ff");
    3bf3:	48 b8 29 7a 00 00 00 	movabs $0x7a29,%rax
    3bfa:	00 00 00 
    3bfd:	48 89 c7             	mov    %rax,%rdi
    3c00:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3c07:	00 00 00 
    3c0a:	ff d0                	call   *%rax
  if(mkdir("dd") != 0){
    3c0c:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    3c13:	00 00 00 
    3c16:	48 89 c7             	mov    %rax,%rdi
    3c19:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    3c20:	00 00 00 
    3c23:	ff d0                	call   *%rax
    3c25:	85 c0                	test   %eax,%eax
    3c27:	74 19                	je     3c42 <subdir+0x7a>
    failexit("subdir mkdir dd");
    3c29:	48 b8 2f 7a 00 00 00 	movabs $0x7a2f,%rax
    3c30:	00 00 00 
    3c33:	48 89 c7             	mov    %rax,%rdi
    3c36:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3c3d:	00 00 00 
    3c40:	ff d0                	call   *%rax
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    3c42:	48 b8 3f 7a 00 00 00 	movabs $0x7a3f,%rax
    3c49:	00 00 00 
    3c4c:	be 02 02 00 00       	mov    $0x202,%esi
    3c51:	48 89 c7             	mov    %rax,%rdi
    3c54:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3c5b:	00 00 00 
    3c5e:	ff d0                	call   *%rax
    3c60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3c63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3c67:	79 19                	jns    3c82 <subdir+0xba>
    failexit("create dd/ff");
    3c69:	48 b8 45 7a 00 00 00 	movabs $0x7a45,%rax
    3c70:	00 00 00 
    3c73:	48 89 c7             	mov    %rax,%rdi
    3c76:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3c7d:	00 00 00 
    3c80:	ff d0                	call   *%rax
  }
  write(fd, "ff", 2);
    3c82:	48 b9 29 7a 00 00 00 	movabs $0x7a29,%rcx
    3c89:	00 00 00 
    3c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3c8f:	ba 02 00 00 00       	mov    $0x2,%edx
    3c94:	48 89 ce             	mov    %rcx,%rsi
    3c97:	89 c7                	mov    %eax,%edi
    3c99:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    3ca0:	00 00 00 
    3ca3:	ff d0                	call   *%rax
  close(fd);
    3ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3ca8:	89 c7                	mov    %eax,%edi
    3caa:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3cb1:	00 00 00 
    3cb4:	ff d0                	call   *%rax

  if(unlink("dd") >= 0){
    3cb6:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    3cbd:	00 00 00 
    3cc0:	48 89 c7             	mov    %rax,%rdi
    3cc3:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3cca:	00 00 00 
    3ccd:	ff d0                	call   *%rax
    3ccf:	85 c0                	test   %eax,%eax
    3cd1:	78 19                	js     3cec <subdir+0x124>
    failexit("unlink dd (non-empty dir) succeeded!");
    3cd3:	48 b8 58 7a 00 00 00 	movabs $0x7a58,%rax
    3cda:	00 00 00 
    3cdd:	48 89 c7             	mov    %rax,%rdi
    3ce0:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3ce7:	00 00 00 
    3cea:	ff d0                	call   *%rax
  }

  if(mkdir("/dd/dd") != 0){
    3cec:	48 b8 7d 7a 00 00 00 	movabs $0x7a7d,%rax
    3cf3:	00 00 00 
    3cf6:	48 89 c7             	mov    %rax,%rdi
    3cf9:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    3d00:	00 00 00 
    3d03:	ff d0                	call   *%rax
    3d05:	85 c0                	test   %eax,%eax
    3d07:	74 19                	je     3d22 <subdir+0x15a>
    failexit("subdir mkdir dd/dd");
    3d09:	48 b8 84 7a 00 00 00 	movabs $0x7a84,%rax
    3d10:	00 00 00 
    3d13:	48 89 c7             	mov    %rax,%rdi
    3d16:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3d1d:	00 00 00 
    3d20:	ff d0                	call   *%rax
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3d22:	48 b8 97 7a 00 00 00 	movabs $0x7a97,%rax
    3d29:	00 00 00 
    3d2c:	be 02 02 00 00       	mov    $0x202,%esi
    3d31:	48 89 c7             	mov    %rax,%rdi
    3d34:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3d3b:	00 00 00 
    3d3e:	ff d0                	call   *%rax
    3d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3d47:	79 19                	jns    3d62 <subdir+0x19a>
    failexit("create dd/dd/ff");
    3d49:	48 b8 a0 7a 00 00 00 	movabs $0x7aa0,%rax
    3d50:	00 00 00 
    3d53:	48 89 c7             	mov    %rax,%rdi
    3d56:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3d5d:	00 00 00 
    3d60:	ff d0                	call   *%rax
  }
  write(fd, "FF", 2);
    3d62:	48 b9 b0 7a 00 00 00 	movabs $0x7ab0,%rcx
    3d69:	00 00 00 
    3d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3d6f:	ba 02 00 00 00       	mov    $0x2,%edx
    3d74:	48 89 ce             	mov    %rcx,%rsi
    3d77:	89 c7                	mov    %eax,%edi
    3d79:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    3d80:	00 00 00 
    3d83:	ff d0                	call   *%rax
  close(fd);
    3d85:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3d88:	89 c7                	mov    %eax,%edi
    3d8a:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3d91:	00 00 00 
    3d94:	ff d0                	call   *%rax

  fd = open("dd/dd/../ff", 0);
    3d96:	48 b8 b3 7a 00 00 00 	movabs $0x7ab3,%rax
    3d9d:	00 00 00 
    3da0:	be 00 00 00 00       	mov    $0x0,%esi
    3da5:	48 89 c7             	mov    %rax,%rdi
    3da8:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3daf:	00 00 00 
    3db2:	ff d0                	call   *%rax
    3db4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3db7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3dbb:	79 19                	jns    3dd6 <subdir+0x20e>
    failexit("open dd/dd/../ff");
    3dbd:	48 b8 bf 7a 00 00 00 	movabs $0x7abf,%rax
    3dc4:	00 00 00 
    3dc7:	48 89 c7             	mov    %rax,%rdi
    3dca:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3dd1:	00 00 00 
    3dd4:	ff d0                	call   *%rax
  }
  cc = read(fd, buf, sizeof(buf));
    3dd6:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    3ddd:	00 00 00 
    3de0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3de3:	ba 00 20 00 00       	mov    $0x2000,%edx
    3de8:	48 89 ce             	mov    %rcx,%rsi
    3deb:	89 c7                	mov    %eax,%edi
    3ded:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    3df4:	00 00 00 
    3df7:	ff d0                	call   *%rax
    3df9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(cc != 2 || buf[0] != 'f'){
    3dfc:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
    3e00:	75 11                	jne    3e13 <subdir+0x24b>
    3e02:	48 b8 80 87 00 00 00 	movabs $0x8780,%rax
    3e09:	00 00 00 
    3e0c:	0f b6 00             	movzbl (%rax),%eax
    3e0f:	3c 66                	cmp    $0x66,%al
    3e11:	74 19                	je     3e2c <subdir+0x264>
    failexit("dd/dd/../ff wrong content");
    3e13:	48 b8 d0 7a 00 00 00 	movabs $0x7ad0,%rax
    3e1a:	00 00 00 
    3e1d:	48 89 c7             	mov    %rax,%rdi
    3e20:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3e27:	00 00 00 
    3e2a:	ff d0                	call   *%rax
  }
  close(fd);
    3e2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    3e2f:	89 c7                	mov    %eax,%edi
    3e31:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    3e38:	00 00 00 
    3e3b:	ff d0                	call   *%rax

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3e3d:	48 ba ea 7a 00 00 00 	movabs $0x7aea,%rdx
    3e44:	00 00 00 
    3e47:	48 b8 97 7a 00 00 00 	movabs $0x7a97,%rax
    3e4e:	00 00 00 
    3e51:	48 89 d6             	mov    %rdx,%rsi
    3e54:	48 89 c7             	mov    %rax,%rdi
    3e57:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    3e5e:	00 00 00 
    3e61:	ff d0                	call   *%rax
    3e63:	85 c0                	test   %eax,%eax
    3e65:	74 19                	je     3e80 <subdir+0x2b8>
    failexit("link dd/dd/ff dd/dd/ffff");
    3e67:	48 b8 f5 7a 00 00 00 	movabs $0x7af5,%rax
    3e6e:	00 00 00 
    3e71:	48 89 c7             	mov    %rax,%rdi
    3e74:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3e7b:	00 00 00 
    3e7e:	ff d0                	call   *%rax
  }

  if(unlink("dd/dd/ff") != 0){
    3e80:	48 b8 97 7a 00 00 00 	movabs $0x7a97,%rax
    3e87:	00 00 00 
    3e8a:	48 89 c7             	mov    %rax,%rdi
    3e8d:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    3e94:	00 00 00 
    3e97:	ff d0                	call   *%rax
    3e99:	85 c0                	test   %eax,%eax
    3e9b:	74 19                	je     3eb6 <subdir+0x2ee>
    failexit("unlink dd/dd/ff");
    3e9d:	48 b8 0e 7b 00 00 00 	movabs $0x7b0e,%rax
    3ea4:	00 00 00 
    3ea7:	48 89 c7             	mov    %rax,%rdi
    3eaa:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3eb1:	00 00 00 
    3eb4:	ff d0                	call   *%rax
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3eb6:	48 b8 97 7a 00 00 00 	movabs $0x7a97,%rax
    3ebd:	00 00 00 
    3ec0:	be 00 00 00 00       	mov    $0x0,%esi
    3ec5:	48 89 c7             	mov    %rax,%rdi
    3ec8:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3ecf:	00 00 00 
    3ed2:	ff d0                	call   *%rax
    3ed4:	85 c0                	test   %eax,%eax
    3ed6:	78 19                	js     3ef1 <subdir+0x329>
    failexit("open (unlinked) dd/dd/ff succeeded");
    3ed8:	48 b8 20 7b 00 00 00 	movabs $0x7b20,%rax
    3edf:	00 00 00 
    3ee2:	48 89 c7             	mov    %rax,%rdi
    3ee5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3eec:	00 00 00 
    3eef:	ff d0                	call   *%rax
  }

  if(chdir("dd") != 0){
    3ef1:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    3ef8:	00 00 00 
    3efb:	48 89 c7             	mov    %rax,%rdi
    3efe:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    3f05:	00 00 00 
    3f08:	ff d0                	call   *%rax
    3f0a:	85 c0                	test   %eax,%eax
    3f0c:	74 19                	je     3f27 <subdir+0x35f>
    failexit("chdir dd");
    3f0e:	48 b8 43 7b 00 00 00 	movabs $0x7b43,%rax
    3f15:	00 00 00 
    3f18:	48 89 c7             	mov    %rax,%rdi
    3f1b:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3f22:	00 00 00 
    3f25:	ff d0                	call   *%rax
  }
  if(chdir("dd/../../dd") != 0){
    3f27:	48 b8 4c 7b 00 00 00 	movabs $0x7b4c,%rax
    3f2e:	00 00 00 
    3f31:	48 89 c7             	mov    %rax,%rdi
    3f34:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    3f3b:	00 00 00 
    3f3e:	ff d0                	call   *%rax
    3f40:	85 c0                	test   %eax,%eax
    3f42:	74 19                	je     3f5d <subdir+0x395>
    failexit("chdir dd/../../dd");
    3f44:	48 b8 58 7b 00 00 00 	movabs $0x7b58,%rax
    3f4b:	00 00 00 
    3f4e:	48 89 c7             	mov    %rax,%rdi
    3f51:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3f58:	00 00 00 
    3f5b:	ff d0                	call   *%rax
  }
  if(chdir("dd/../../../dd") != 0){
    3f5d:	48 b8 6a 7b 00 00 00 	movabs $0x7b6a,%rax
    3f64:	00 00 00 
    3f67:	48 89 c7             	mov    %rax,%rdi
    3f6a:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    3f71:	00 00 00 
    3f74:	ff d0                	call   *%rax
    3f76:	85 c0                	test   %eax,%eax
    3f78:	74 19                	je     3f93 <subdir+0x3cb>
    failexit("chdir dd/../../dd");
    3f7a:	48 b8 58 7b 00 00 00 	movabs $0x7b58,%rax
    3f81:	00 00 00 
    3f84:	48 89 c7             	mov    %rax,%rdi
    3f87:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3f8e:	00 00 00 
    3f91:	ff d0                	call   *%rax
  }
  if(chdir("./..") != 0){
    3f93:	48 b8 79 7b 00 00 00 	movabs $0x7b79,%rax
    3f9a:	00 00 00 
    3f9d:	48 89 c7             	mov    %rax,%rdi
    3fa0:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    3fa7:	00 00 00 
    3faa:	ff d0                	call   *%rax
    3fac:	85 c0                	test   %eax,%eax
    3fae:	74 19                	je     3fc9 <subdir+0x401>
    failexit("chdir ./..");
    3fb0:	48 b8 7e 7b 00 00 00 	movabs $0x7b7e,%rax
    3fb7:	00 00 00 
    3fba:	48 89 c7             	mov    %rax,%rdi
    3fbd:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    3fc4:	00 00 00 
    3fc7:	ff d0                	call   *%rax
  }

  fd = open("dd/dd/ffff", 0);
    3fc9:	48 b8 ea 7a 00 00 00 	movabs $0x7aea,%rax
    3fd0:	00 00 00 
    3fd3:	be 00 00 00 00       	mov    $0x0,%esi
    3fd8:	48 89 c7             	mov    %rax,%rdi
    3fdb:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    3fe2:	00 00 00 
    3fe5:	ff d0                	call   *%rax
    3fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    3fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    3fee:	79 19                	jns    4009 <subdir+0x441>
    failexit("open dd/dd/ffff");
    3ff0:	48 b8 89 7b 00 00 00 	movabs $0x7b89,%rax
    3ff7:	00 00 00 
    3ffa:	48 89 c7             	mov    %rax,%rdi
    3ffd:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4004:	00 00 00 
    4007:	ff d0                	call   *%rax
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    4009:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    4010:	00 00 00 
    4013:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4016:	ba 00 20 00 00       	mov    $0x2000,%edx
    401b:	48 89 ce             	mov    %rcx,%rsi
    401e:	89 c7                	mov    %eax,%edi
    4020:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    4027:	00 00 00 
    402a:	ff d0                	call   *%rax
    402c:	83 f8 02             	cmp    $0x2,%eax
    402f:	74 19                	je     404a <subdir+0x482>
    failexit("read dd/dd/ffff wrong len");
    4031:	48 b8 99 7b 00 00 00 	movabs $0x7b99,%rax
    4038:	00 00 00 
    403b:	48 89 c7             	mov    %rax,%rdi
    403e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4045:	00 00 00 
    4048:	ff d0                	call   *%rax
  }
  close(fd);
    404a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    404d:	89 c7                	mov    %eax,%edi
    404f:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    4056:	00 00 00 
    4059:	ff d0                	call   *%rax

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    405b:	48 b8 97 7a 00 00 00 	movabs $0x7a97,%rax
    4062:	00 00 00 
    4065:	be 00 00 00 00       	mov    $0x0,%esi
    406a:	48 89 c7             	mov    %rax,%rdi
    406d:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4074:	00 00 00 
    4077:	ff d0                	call   *%rax
    4079:	85 c0                	test   %eax,%eax
    407b:	78 19                	js     4096 <subdir+0x4ce>
    failexit("open (unlinked) dd/dd/ff succeeded");
    407d:	48 b8 20 7b 00 00 00 	movabs $0x7b20,%rax
    4084:	00 00 00 
    4087:	48 89 c7             	mov    %rax,%rdi
    408a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4091:	00 00 00 
    4094:	ff d0                	call   *%rax
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    4096:	48 b8 b3 7b 00 00 00 	movabs $0x7bb3,%rax
    409d:	00 00 00 
    40a0:	be 02 02 00 00       	mov    $0x202,%esi
    40a5:	48 89 c7             	mov    %rax,%rdi
    40a8:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    40af:	00 00 00 
    40b2:	ff d0                	call   *%rax
    40b4:	85 c0                	test   %eax,%eax
    40b6:	78 19                	js     40d1 <subdir+0x509>
    failexit("create dd/ff/ff succeeded");
    40b8:	48 b8 bc 7b 00 00 00 	movabs $0x7bbc,%rax
    40bf:	00 00 00 
    40c2:	48 89 c7             	mov    %rax,%rdi
    40c5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    40cc:	00 00 00 
    40cf:	ff d0                	call   *%rax
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    40d1:	48 b8 d6 7b 00 00 00 	movabs $0x7bd6,%rax
    40d8:	00 00 00 
    40db:	be 02 02 00 00       	mov    $0x202,%esi
    40e0:	48 89 c7             	mov    %rax,%rdi
    40e3:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    40ea:	00 00 00 
    40ed:	ff d0                	call   *%rax
    40ef:	85 c0                	test   %eax,%eax
    40f1:	78 19                	js     410c <subdir+0x544>
    failexit("create dd/xx/ff succeeded");
    40f3:	48 b8 df 7b 00 00 00 	movabs $0x7bdf,%rax
    40fa:	00 00 00 
    40fd:	48 89 c7             	mov    %rax,%rdi
    4100:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4107:	00 00 00 
    410a:	ff d0                	call   *%rax
  }
  if(open("dd", O_CREATE) >= 0){
    410c:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    4113:	00 00 00 
    4116:	be 00 02 00 00       	mov    $0x200,%esi
    411b:	48 89 c7             	mov    %rax,%rdi
    411e:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4125:	00 00 00 
    4128:	ff d0                	call   *%rax
    412a:	85 c0                	test   %eax,%eax
    412c:	78 19                	js     4147 <subdir+0x57f>
    failexit("create dd succeeded");
    412e:	48 b8 f9 7b 00 00 00 	movabs $0x7bf9,%rax
    4135:	00 00 00 
    4138:	48 89 c7             	mov    %rax,%rdi
    413b:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4142:	00 00 00 
    4145:	ff d0                	call   *%rax
  }
  if(open("dd", O_RDWR) >= 0){
    4147:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    414e:	00 00 00 
    4151:	be 02 00 00 00       	mov    $0x2,%esi
    4156:	48 89 c7             	mov    %rax,%rdi
    4159:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4160:	00 00 00 
    4163:	ff d0                	call   *%rax
    4165:	85 c0                	test   %eax,%eax
    4167:	78 19                	js     4182 <subdir+0x5ba>
    failexit("open dd rdwr succeeded");
    4169:	48 b8 0d 7c 00 00 00 	movabs $0x7c0d,%rax
    4170:	00 00 00 
    4173:	48 89 c7             	mov    %rax,%rdi
    4176:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    417d:	00 00 00 
    4180:	ff d0                	call   *%rax
  }
  if(open("dd", O_WRONLY) >= 0){
    4182:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    4189:	00 00 00 
    418c:	be 01 00 00 00       	mov    $0x1,%esi
    4191:	48 89 c7             	mov    %rax,%rdi
    4194:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    419b:	00 00 00 
    419e:	ff d0                	call   *%rax
    41a0:	85 c0                	test   %eax,%eax
    41a2:	78 19                	js     41bd <subdir+0x5f5>
    failexit("open dd wronly succeeded");
    41a4:	48 b8 24 7c 00 00 00 	movabs $0x7c24,%rax
    41ab:	00 00 00 
    41ae:	48 89 c7             	mov    %rax,%rdi
    41b1:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    41b8:	00 00 00 
    41bb:	ff d0                	call   *%rax
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    41bd:	48 ba 3d 7c 00 00 00 	movabs $0x7c3d,%rdx
    41c4:	00 00 00 
    41c7:	48 b8 b3 7b 00 00 00 	movabs $0x7bb3,%rax
    41ce:	00 00 00 
    41d1:	48 89 d6             	mov    %rdx,%rsi
    41d4:	48 89 c7             	mov    %rax,%rdi
    41d7:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    41de:	00 00 00 
    41e1:	ff d0                	call   *%rax
    41e3:	85 c0                	test   %eax,%eax
    41e5:	75 19                	jne    4200 <subdir+0x638>
    failexit("link dd/ff/ff dd/dd/xx succeeded");
    41e7:	48 b8 48 7c 00 00 00 	movabs $0x7c48,%rax
    41ee:	00 00 00 
    41f1:	48 89 c7             	mov    %rax,%rdi
    41f4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    41fb:	00 00 00 
    41fe:	ff d0                	call   *%rax
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    4200:	48 ba 3d 7c 00 00 00 	movabs $0x7c3d,%rdx
    4207:	00 00 00 
    420a:	48 b8 d6 7b 00 00 00 	movabs $0x7bd6,%rax
    4211:	00 00 00 
    4214:	48 89 d6             	mov    %rdx,%rsi
    4217:	48 89 c7             	mov    %rax,%rdi
    421a:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    4221:	00 00 00 
    4224:	ff d0                	call   *%rax
    4226:	85 c0                	test   %eax,%eax
    4228:	75 19                	jne    4243 <subdir+0x67b>
    failexit("link dd/xx/ff dd/dd/xx succeededn");
    422a:	48 b8 70 7c 00 00 00 	movabs $0x7c70,%rax
    4231:	00 00 00 
    4234:	48 89 c7             	mov    %rax,%rdi
    4237:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    423e:	00 00 00 
    4241:	ff d0                	call   *%rax
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    4243:	48 ba ea 7a 00 00 00 	movabs $0x7aea,%rdx
    424a:	00 00 00 
    424d:	48 b8 3f 7a 00 00 00 	movabs $0x7a3f,%rax
    4254:	00 00 00 
    4257:	48 89 d6             	mov    %rdx,%rsi
    425a:	48 89 c7             	mov    %rax,%rdi
    425d:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    4264:	00 00 00 
    4267:	ff d0                	call   *%rax
    4269:	85 c0                	test   %eax,%eax
    426b:	75 19                	jne    4286 <subdir+0x6be>
    failexit("link dd/ff dd/dd/ffff succeeded");
    426d:	48 b8 98 7c 00 00 00 	movabs $0x7c98,%rax
    4274:	00 00 00 
    4277:	48 89 c7             	mov    %rax,%rdi
    427a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4281:	00 00 00 
    4284:	ff d0                	call   *%rax
  }
  if(mkdir("dd/ff/ff") == 0){
    4286:	48 b8 b3 7b 00 00 00 	movabs $0x7bb3,%rax
    428d:	00 00 00 
    4290:	48 89 c7             	mov    %rax,%rdi
    4293:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    429a:	00 00 00 
    429d:	ff d0                	call   *%rax
    429f:	85 c0                	test   %eax,%eax
    42a1:	75 19                	jne    42bc <subdir+0x6f4>
    failexit("mkdir dd/ff/ff succeeded");
    42a3:	48 b8 b8 7c 00 00 00 	movabs $0x7cb8,%rax
    42aa:	00 00 00 
    42ad:	48 89 c7             	mov    %rax,%rdi
    42b0:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    42b7:	00 00 00 
    42ba:	ff d0                	call   *%rax
  }
  if(mkdir("dd/xx/ff") == 0){
    42bc:	48 b8 d6 7b 00 00 00 	movabs $0x7bd6,%rax
    42c3:	00 00 00 
    42c6:	48 89 c7             	mov    %rax,%rdi
    42c9:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    42d0:	00 00 00 
    42d3:	ff d0                	call   *%rax
    42d5:	85 c0                	test   %eax,%eax
    42d7:	75 19                	jne    42f2 <subdir+0x72a>
    failexit("mkdir dd/xx/ff succeeded");
    42d9:	48 b8 d1 7c 00 00 00 	movabs $0x7cd1,%rax
    42e0:	00 00 00 
    42e3:	48 89 c7             	mov    %rax,%rdi
    42e6:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    42ed:	00 00 00 
    42f0:	ff d0                	call   *%rax
  }
  if(mkdir("dd/dd/ffff") == 0){
    42f2:	48 b8 ea 7a 00 00 00 	movabs $0x7aea,%rax
    42f9:	00 00 00 
    42fc:	48 89 c7             	mov    %rax,%rdi
    42ff:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    4306:	00 00 00 
    4309:	ff d0                	call   *%rax
    430b:	85 c0                	test   %eax,%eax
    430d:	75 19                	jne    4328 <subdir+0x760>
    failexit("mkdir dd/dd/ffff succeeded");
    430f:	48 b8 ea 7c 00 00 00 	movabs $0x7cea,%rax
    4316:	00 00 00 
    4319:	48 89 c7             	mov    %rax,%rdi
    431c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4323:	00 00 00 
    4326:	ff d0                	call   *%rax
  }
  if(unlink("dd/xx/ff") == 0){
    4328:	48 b8 d6 7b 00 00 00 	movabs $0x7bd6,%rax
    432f:	00 00 00 
    4332:	48 89 c7             	mov    %rax,%rdi
    4335:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    433c:	00 00 00 
    433f:	ff d0                	call   *%rax
    4341:	85 c0                	test   %eax,%eax
    4343:	75 19                	jne    435e <subdir+0x796>
    failexit("unlink dd/xx/ff succeeded");
    4345:	48 b8 05 7d 00 00 00 	movabs $0x7d05,%rax
    434c:	00 00 00 
    434f:	48 89 c7             	mov    %rax,%rdi
    4352:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4359:	00 00 00 
    435c:	ff d0                	call   *%rax
  }
  if(unlink("dd/ff/ff") == 0){
    435e:	48 b8 b3 7b 00 00 00 	movabs $0x7bb3,%rax
    4365:	00 00 00 
    4368:	48 89 c7             	mov    %rax,%rdi
    436b:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4372:	00 00 00 
    4375:	ff d0                	call   *%rax
    4377:	85 c0                	test   %eax,%eax
    4379:	75 19                	jne    4394 <subdir+0x7cc>
    failexit("unlink dd/ff/ff succeeded");
    437b:	48 b8 1f 7d 00 00 00 	movabs $0x7d1f,%rax
    4382:	00 00 00 
    4385:	48 89 c7             	mov    %rax,%rdi
    4388:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    438f:	00 00 00 
    4392:	ff d0                	call   *%rax
  }
  if(chdir("dd/ff") == 0){
    4394:	48 b8 3f 7a 00 00 00 	movabs $0x7a3f,%rax
    439b:	00 00 00 
    439e:	48 89 c7             	mov    %rax,%rdi
    43a1:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    43a8:	00 00 00 
    43ab:	ff d0                	call   *%rax
    43ad:	85 c0                	test   %eax,%eax
    43af:	75 19                	jne    43ca <subdir+0x802>
    failexit("chdir dd/ff succeeded");
    43b1:	48 b8 39 7d 00 00 00 	movabs $0x7d39,%rax
    43b8:	00 00 00 
    43bb:	48 89 c7             	mov    %rax,%rdi
    43be:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    43c5:	00 00 00 
    43c8:	ff d0                	call   *%rax
  }
  if(chdir("dd/xx") == 0){
    43ca:	48 b8 4f 7d 00 00 00 	movabs $0x7d4f,%rax
    43d1:	00 00 00 
    43d4:	48 89 c7             	mov    %rax,%rdi
    43d7:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    43de:	00 00 00 
    43e1:	ff d0                	call   *%rax
    43e3:	85 c0                	test   %eax,%eax
    43e5:	75 19                	jne    4400 <subdir+0x838>
    failexit("chdir dd/xx succeeded");
    43e7:	48 b8 55 7d 00 00 00 	movabs $0x7d55,%rax
    43ee:	00 00 00 
    43f1:	48 89 c7             	mov    %rax,%rdi
    43f4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    43fb:	00 00 00 
    43fe:	ff d0                	call   *%rax
  }

  if(unlink("dd/dd/ffff") != 0){
    4400:	48 b8 ea 7a 00 00 00 	movabs $0x7aea,%rax
    4407:	00 00 00 
    440a:	48 89 c7             	mov    %rax,%rdi
    440d:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4414:	00 00 00 
    4417:	ff d0                	call   *%rax
    4419:	85 c0                	test   %eax,%eax
    441b:	74 19                	je     4436 <subdir+0x86e>
    failexit("unlink dd/dd/ff");
    441d:	48 b8 0e 7b 00 00 00 	movabs $0x7b0e,%rax
    4424:	00 00 00 
    4427:	48 89 c7             	mov    %rax,%rdi
    442a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4431:	00 00 00 
    4434:	ff d0                	call   *%rax
  }
  if(unlink("dd/ff") != 0){
    4436:	48 b8 3f 7a 00 00 00 	movabs $0x7a3f,%rax
    443d:	00 00 00 
    4440:	48 89 c7             	mov    %rax,%rdi
    4443:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    444a:	00 00 00 
    444d:	ff d0                	call   *%rax
    444f:	85 c0                	test   %eax,%eax
    4451:	74 19                	je     446c <subdir+0x8a4>
    failexit("unlink dd/ff");
    4453:	48 b8 6b 7d 00 00 00 	movabs $0x7d6b,%rax
    445a:	00 00 00 
    445d:	48 89 c7             	mov    %rax,%rdi
    4460:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4467:	00 00 00 
    446a:	ff d0                	call   *%rax
  }
  if(unlink("dd") == 0){
    446c:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    4473:	00 00 00 
    4476:	48 89 c7             	mov    %rax,%rdi
    4479:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4480:	00 00 00 
    4483:	ff d0                	call   *%rax
    4485:	85 c0                	test   %eax,%eax
    4487:	75 19                	jne    44a2 <subdir+0x8da>
    failexit("unlink non-empty dd succeeded");
    4489:	48 b8 78 7d 00 00 00 	movabs $0x7d78,%rax
    4490:	00 00 00 
    4493:	48 89 c7             	mov    %rax,%rdi
    4496:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    449d:	00 00 00 
    44a0:	ff d0                	call   *%rax
  }
  if(unlink("dd/dd") < 0){
    44a2:	48 b8 96 7d 00 00 00 	movabs $0x7d96,%rax
    44a9:	00 00 00 
    44ac:	48 89 c7             	mov    %rax,%rdi
    44af:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    44b6:	00 00 00 
    44b9:	ff d0                	call   *%rax
    44bb:	85 c0                	test   %eax,%eax
    44bd:	79 19                	jns    44d8 <subdir+0x910>
    failexit("unlink dd/dd");
    44bf:	48 b8 9c 7d 00 00 00 	movabs $0x7d9c,%rax
    44c6:	00 00 00 
    44c9:	48 89 c7             	mov    %rax,%rdi
    44cc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    44d3:	00 00 00 
    44d6:	ff d0                	call   *%rax
  }
  if(unlink("dd") < 0){
    44d8:	48 b8 2c 7a 00 00 00 	movabs $0x7a2c,%rax
    44df:	00 00 00 
    44e2:	48 89 c7             	mov    %rax,%rdi
    44e5:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    44ec:	00 00 00 
    44ef:	ff d0                	call   *%rax
    44f1:	85 c0                	test   %eax,%eax
    44f3:	79 19                	jns    450e <subdir+0x946>
    failexit("unlink dd");
    44f5:	48 b8 a9 7d 00 00 00 	movabs $0x7da9,%rax
    44fc:	00 00 00 
    44ff:	48 89 c7             	mov    %rax,%rdi
    4502:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4509:	00 00 00 
    450c:	ff d0                	call   *%rax
  }

  printf(1, "subdir ok\n");
    450e:	48 b8 b3 7d 00 00 00 	movabs $0x7db3,%rax
    4515:	00 00 00 
    4518:	48 89 c6             	mov    %rax,%rsi
    451b:	bf 01 00 00 00       	mov    $0x1,%edi
    4520:	b8 00 00 00 00       	mov    $0x0,%eax
    4525:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    452c:	00 00 00 
    452f:	ff d2                	call   *%rdx
}
    4531:	90                   	nop
    4532:	c9                   	leave
    4533:	c3                   	ret

0000000000004534 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    4534:	55                   	push   %rbp
    4535:	48 89 e5             	mov    %rsp,%rbp
    4538:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, sz;

  printf(1, "bigwrite test\n");
    453c:	48 b8 be 7d 00 00 00 	movabs $0x7dbe,%rax
    4543:	00 00 00 
    4546:	48 89 c6             	mov    %rax,%rsi
    4549:	bf 01 00 00 00       	mov    $0x1,%edi
    454e:	b8 00 00 00 00       	mov    $0x0,%eax
    4553:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    455a:	00 00 00 
    455d:	ff d2                	call   *%rdx

  unlink("bigwrite");
    455f:	48 b8 cd 7d 00 00 00 	movabs $0x7dcd,%rax
    4566:	00 00 00 
    4569:	48 89 c7             	mov    %rax,%rdi
    456c:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4573:	00 00 00 
    4576:	ff d0                	call   *%rax
  for(sz = 499; sz < 12*512; sz += 471){
    4578:	c7 45 fc f3 01 00 00 	movl   $0x1f3,-0x4(%rbp)
    457f:	e9 e7 00 00 00       	jmp    466b <bigwrite+0x137>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    4584:	48 b8 cd 7d 00 00 00 	movabs $0x7dcd,%rax
    458b:	00 00 00 
    458e:	be 02 02 00 00       	mov    $0x202,%esi
    4593:	48 89 c7             	mov    %rax,%rdi
    4596:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    459d:	00 00 00 
    45a0:	ff d0                	call   *%rax
    45a2:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if(fd < 0){
    45a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    45a9:	79 19                	jns    45c4 <bigwrite+0x90>
      failexit("cannot create bigwrite");
    45ab:	48 b8 d6 7d 00 00 00 	movabs $0x7dd6,%rax
    45b2:	00 00 00 
    45b5:	48 89 c7             	mov    %rax,%rdi
    45b8:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    45bf:	00 00 00 
    45c2:	ff d0                	call   *%rax
    }
    int i;
    for(i = 0; i < 2; i++){
    45c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    45cb:	eb 67                	jmp    4634 <bigwrite+0x100>
      int cc = write(fd, buf, sz);
    45cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
    45d0:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    45d7:	00 00 00 
    45da:	8b 45 f4             	mov    -0xc(%rbp),%eax
    45dd:	48 89 ce             	mov    %rcx,%rsi
    45e0:	89 c7                	mov    %eax,%edi
    45e2:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    45e9:	00 00 00 
    45ec:	ff d0                	call   *%rax
    45ee:	89 45 f0             	mov    %eax,-0x10(%rbp)
      if(cc != sz){
    45f1:	8b 45 f0             	mov    -0x10(%rbp),%eax
    45f4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
    45f7:	74 37                	je     4630 <bigwrite+0xfc>
        printf(1, "write(%d) ret %d\n", sz, cc);
    45f9:	8b 55 f0             	mov    -0x10(%rbp),%edx
    45fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    45ff:	48 be ed 7d 00 00 00 	movabs $0x7ded,%rsi
    4606:	00 00 00 
    4609:	89 d1                	mov    %edx,%ecx
    460b:	89 c2                	mov    %eax,%edx
    460d:	bf 01 00 00 00       	mov    $0x1,%edi
    4612:	b8 00 00 00 00       	mov    $0x0,%eax
    4617:	49 b8 be 69 00 00 00 	movabs $0x69be,%r8
    461e:	00 00 00 
    4621:	41 ff d0             	call   *%r8
        exit();
    4624:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    462b:	00 00 00 
    462e:	ff d0                	call   *%rax
    for(i = 0; i < 2; i++){
    4630:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    4634:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
    4638:	7e 93                	jle    45cd <bigwrite+0x99>
      }
    }
    close(fd);
    463a:	8b 45 f4             	mov    -0xc(%rbp),%eax
    463d:	89 c7                	mov    %eax,%edi
    463f:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    4646:	00 00 00 
    4649:	ff d0                	call   *%rax
    unlink("bigwrite");
    464b:	48 b8 cd 7d 00 00 00 	movabs $0x7dcd,%rax
    4652:	00 00 00 
    4655:	48 89 c7             	mov    %rax,%rdi
    4658:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    465f:	00 00 00 
    4662:	ff d0                	call   *%rax
  for(sz = 499; sz < 12*512; sz += 471){
    4664:	81 45 fc d7 01 00 00 	addl   $0x1d7,-0x4(%rbp)
    466b:	81 7d fc ff 17 00 00 	cmpl   $0x17ff,-0x4(%rbp)
    4672:	0f 8e 0c ff ff ff    	jle    4584 <bigwrite+0x50>
  }

  printf(1, "bigwrite ok\n");
    4678:	48 b8 ff 7d 00 00 00 	movabs $0x7dff,%rax
    467f:	00 00 00 
    4682:	48 89 c6             	mov    %rax,%rsi
    4685:	bf 01 00 00 00       	mov    $0x1,%edi
    468a:	b8 00 00 00 00       	mov    $0x0,%eax
    468f:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4696:	00 00 00 
    4699:	ff d2                	call   *%rdx
}
    469b:	90                   	nop
    469c:	c9                   	leave
    469d:	c3                   	ret

000000000000469e <bigfile>:

void
bigfile(void)
{
    469e:	55                   	push   %rbp
    469f:	48 89 e5             	mov    %rsp,%rbp
    46a2:	48 83 ec 10          	sub    $0x10,%rsp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    46a6:	48 b8 0c 7e 00 00 00 	movabs $0x7e0c,%rax
    46ad:	00 00 00 
    46b0:	48 89 c6             	mov    %rax,%rsi
    46b3:	bf 01 00 00 00       	mov    $0x1,%edi
    46b8:	b8 00 00 00 00       	mov    $0x0,%eax
    46bd:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    46c4:	00 00 00 
    46c7:	ff d2                	call   *%rdx

  unlink("bigfile");
    46c9:	48 b8 1a 7e 00 00 00 	movabs $0x7e1a,%rax
    46d0:	00 00 00 
    46d3:	48 89 c7             	mov    %rax,%rdi
    46d6:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    46dd:	00 00 00 
    46e0:	ff d0                	call   *%rax
  fd = open("bigfile", O_CREATE | O_RDWR);
    46e2:	48 b8 1a 7e 00 00 00 	movabs $0x7e1a,%rax
    46e9:	00 00 00 
    46ec:	be 02 02 00 00       	mov    $0x202,%esi
    46f1:	48 89 c7             	mov    %rax,%rdi
    46f4:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    46fb:	00 00 00 
    46fe:	ff d0                	call   *%rax
    4700:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    4703:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    4707:	79 19                	jns    4722 <bigfile+0x84>
    failexit("cannot create bigfile");
    4709:	48 b8 22 7e 00 00 00 	movabs $0x7e22,%rax
    4710:	00 00 00 
    4713:	48 89 c7             	mov    %rax,%rdi
    4716:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    471d:	00 00 00 
    4720:	ff d0                	call   *%rax
  }
  for(i = 0; i < 20; i++){
    4722:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    4729:	eb 6a                	jmp    4795 <bigfile+0xf7>
    memset(buf, i, 600);
    472b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    472e:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    4735:	00 00 00 
    4738:	ba 58 02 00 00       	mov    $0x258,%edx
    473d:	89 c6                	mov    %eax,%esi
    473f:	48 89 cf             	mov    %rcx,%rdi
    4742:	48 b8 93 64 00 00 00 	movabs $0x6493,%rax
    4749:	00 00 00 
    474c:	ff d0                	call   *%rax
    if(write(fd, buf, 600) != 600){
    474e:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    4755:	00 00 00 
    4758:	8b 45 f4             	mov    -0xc(%rbp),%eax
    475b:	ba 58 02 00 00       	mov    $0x258,%edx
    4760:	48 89 ce             	mov    %rcx,%rsi
    4763:	89 c7                	mov    %eax,%edi
    4765:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    476c:	00 00 00 
    476f:	ff d0                	call   *%rax
    4771:	3d 58 02 00 00       	cmp    $0x258,%eax
    4776:	74 19                	je     4791 <bigfile+0xf3>
      failexit("write bigfile");
    4778:	48 b8 38 7e 00 00 00 	movabs $0x7e38,%rax
    477f:	00 00 00 
    4782:	48 89 c7             	mov    %rax,%rdi
    4785:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    478c:	00 00 00 
    478f:	ff d0                	call   *%rax
  for(i = 0; i < 20; i++){
    4791:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    4795:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    4799:	7e 90                	jle    472b <bigfile+0x8d>
    }
  }
  close(fd);
    479b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    479e:	89 c7                	mov    %eax,%edi
    47a0:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    47a7:	00 00 00 
    47aa:	ff d0                	call   *%rax

  fd = open("bigfile", 0);
    47ac:	48 b8 1a 7e 00 00 00 	movabs $0x7e1a,%rax
    47b3:	00 00 00 
    47b6:	be 00 00 00 00       	mov    $0x0,%esi
    47bb:	48 89 c7             	mov    %rax,%rdi
    47be:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    47c5:	00 00 00 
    47c8:	ff d0                	call   *%rax
    47ca:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    47cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    47d1:	79 19                	jns    47ec <bigfile+0x14e>
    failexit("cannot open bigfile");
    47d3:	48 b8 46 7e 00 00 00 	movabs $0x7e46,%rax
    47da:	00 00 00 
    47dd:	48 89 c7             	mov    %rax,%rdi
    47e0:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    47e7:	00 00 00 
    47ea:	ff d0                	call   *%rax
  }
  total = 0;
    47ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i = 0; ; i++){
    47f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    cc = read(fd, buf, 300);
    47fa:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    4801:	00 00 00 
    4804:	8b 45 f4             	mov    -0xc(%rbp),%eax
    4807:	ba 2c 01 00 00       	mov    $0x12c,%edx
    480c:	48 89 ce             	mov    %rcx,%rsi
    480f:	89 c7                	mov    %eax,%edi
    4811:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    4818:	00 00 00 
    481b:	ff d0                	call   *%rax
    481d:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(cc < 0){
    4820:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    4824:	79 19                	jns    483f <bigfile+0x1a1>
      failexit("read bigfile");
    4826:	48 b8 5a 7e 00 00 00 	movabs $0x7e5a,%rax
    482d:	00 00 00 
    4830:	48 89 c7             	mov    %rax,%rdi
    4833:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    483a:	00 00 00 
    483d:	ff d0                	call   *%rax
    }
    if(cc == 0)
    483f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    4843:	0f 84 8e 00 00 00    	je     48d7 <bigfile+0x239>
      break;
    if(cc != 300){
    4849:	81 7d f0 2c 01 00 00 	cmpl   $0x12c,-0x10(%rbp)
    4850:	74 19                	je     486b <bigfile+0x1cd>
      failexit("short read bigfile");
    4852:	48 b8 67 7e 00 00 00 	movabs $0x7e67,%rax
    4859:	00 00 00 
    485c:	48 89 c7             	mov    %rax,%rdi
    485f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4866:	00 00 00 
    4869:	ff d0                	call   *%rax
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    486b:	48 b8 80 87 00 00 00 	movabs $0x8780,%rax
    4872:	00 00 00 
    4875:	0f b6 00             	movzbl (%rax),%eax
    4878:	0f be d0             	movsbl %al,%edx
    487b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    487e:	89 c1                	mov    %eax,%ecx
    4880:	c1 e9 1f             	shr    $0x1f,%ecx
    4883:	01 c8                	add    %ecx,%eax
    4885:	d1 f8                	sar    $1,%eax
    4887:	39 c2                	cmp    %eax,%edx
    4889:	75 24                	jne    48af <bigfile+0x211>
    488b:	48 b8 80 87 00 00 00 	movabs $0x8780,%rax
    4892:	00 00 00 
    4895:	0f b6 80 2b 01 00 00 	movzbl 0x12b(%rax),%eax
    489c:	0f be d0             	movsbl %al,%edx
    489f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    48a2:	89 c1                	mov    %eax,%ecx
    48a4:	c1 e9 1f             	shr    $0x1f,%ecx
    48a7:	01 c8                	add    %ecx,%eax
    48a9:	d1 f8                	sar    $1,%eax
    48ab:	39 c2                	cmp    %eax,%edx
    48ad:	74 19                	je     48c8 <bigfile+0x22a>
      failexit("read bigfile wrong data");
    48af:	48 b8 7a 7e 00 00 00 	movabs $0x7e7a,%rax
    48b6:	00 00 00 
    48b9:	48 89 c7             	mov    %rax,%rdi
    48bc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    48c3:	00 00 00 
    48c6:	ff d0                	call   *%rax
    }
    total += cc;
    48c8:	8b 45 f0             	mov    -0x10(%rbp),%eax
    48cb:	01 45 f8             	add    %eax,-0x8(%rbp)
  for(i = 0; ; i++){
    48ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    cc = read(fd, buf, 300);
    48d2:	e9 23 ff ff ff       	jmp    47fa <bigfile+0x15c>
      break;
    48d7:	90                   	nop
  }
  close(fd);
    48d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
    48db:	89 c7                	mov    %eax,%edi
    48dd:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    48e4:	00 00 00 
    48e7:	ff d0                	call   *%rax
  if(total != 20*600){
    48e9:	81 7d f8 e0 2e 00 00 	cmpl   $0x2ee0,-0x8(%rbp)
    48f0:	74 19                	je     490b <bigfile+0x26d>
    failexit("read bigfile wrong total");
    48f2:	48 b8 92 7e 00 00 00 	movabs $0x7e92,%rax
    48f9:	00 00 00 
    48fc:	48 89 c7             	mov    %rax,%rdi
    48ff:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4906:	00 00 00 
    4909:	ff d0                	call   *%rax
  }
  unlink("bigfile");
    490b:	48 b8 1a 7e 00 00 00 	movabs $0x7e1a,%rax
    4912:	00 00 00 
    4915:	48 89 c7             	mov    %rax,%rdi
    4918:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    491f:	00 00 00 
    4922:	ff d0                	call   *%rax

  printf(1, "bigfile test ok\n");
    4924:	48 b8 ab 7e 00 00 00 	movabs $0x7eab,%rax
    492b:	00 00 00 
    492e:	48 89 c6             	mov    %rax,%rsi
    4931:	bf 01 00 00 00       	mov    $0x1,%edi
    4936:	b8 00 00 00 00       	mov    $0x0,%eax
    493b:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4942:	00 00 00 
    4945:	ff d2                	call   *%rdx
}
    4947:	90                   	nop
    4948:	c9                   	leave
    4949:	c3                   	ret

000000000000494a <fourteen>:

void
fourteen(void)
{
    494a:	55                   	push   %rbp
    494b:	48 89 e5             	mov    %rsp,%rbp
    494e:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    4952:	48 b8 bc 7e 00 00 00 	movabs $0x7ebc,%rax
    4959:	00 00 00 
    495c:	48 89 c6             	mov    %rax,%rsi
    495f:	bf 01 00 00 00       	mov    $0x1,%edi
    4964:	b8 00 00 00 00       	mov    $0x0,%eax
    4969:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4970:	00 00 00 
    4973:	ff d2                	call   *%rdx

  if(mkdir("12345678901234") != 0){
    4975:	48 b8 cb 7e 00 00 00 	movabs $0x7ecb,%rax
    497c:	00 00 00 
    497f:	48 89 c7             	mov    %rax,%rdi
    4982:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    4989:	00 00 00 
    498c:	ff d0                	call   *%rax
    498e:	85 c0                	test   %eax,%eax
    4990:	74 19                	je     49ab <fourteen+0x61>
    failexit("mkdir 12345678901234");
    4992:	48 b8 da 7e 00 00 00 	movabs $0x7eda,%rax
    4999:	00 00 00 
    499c:	48 89 c7             	mov    %rax,%rdi
    499f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    49a6:	00 00 00 
    49a9:	ff d0                	call   *%rax
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    49ab:	48 b8 f0 7e 00 00 00 	movabs $0x7ef0,%rax
    49b2:	00 00 00 
    49b5:	48 89 c7             	mov    %rax,%rdi
    49b8:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    49bf:	00 00 00 
    49c2:	ff d0                	call   *%rax
    49c4:	85 c0                	test   %eax,%eax
    49c6:	74 19                	je     49e1 <fourteen+0x97>
    failexit("mkdir 12345678901234/123456789012345");
    49c8:	48 b8 10 7f 00 00 00 	movabs $0x7f10,%rax
    49cf:	00 00 00 
    49d2:	48 89 c7             	mov    %rax,%rdi
    49d5:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    49dc:	00 00 00 
    49df:	ff d0                	call   *%rax
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    49e1:	48 b8 38 7f 00 00 00 	movabs $0x7f38,%rax
    49e8:	00 00 00 
    49eb:	be 00 02 00 00       	mov    $0x200,%esi
    49f0:	48 89 c7             	mov    %rax,%rdi
    49f3:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    49fa:	00 00 00 
    49fd:	ff d0                	call   *%rax
    49ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    4a02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4a06:	79 19                	jns    4a21 <fourteen+0xd7>
    failexit("create 123456789012345/123456789012345/123456789012345");
    4a08:	48 b8 68 7f 00 00 00 	movabs $0x7f68,%rax
    4a0f:	00 00 00 
    4a12:	48 89 c7             	mov    %rax,%rdi
    4a15:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4a1c:	00 00 00 
    4a1f:	ff d0                	call   *%rax
  }
  close(fd);
    4a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4a24:	89 c7                	mov    %eax,%edi
    4a26:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    4a2d:	00 00 00 
    4a30:	ff d0                	call   *%rax
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    4a32:	48 b8 a0 7f 00 00 00 	movabs $0x7fa0,%rax
    4a39:	00 00 00 
    4a3c:	be 00 00 00 00       	mov    $0x0,%esi
    4a41:	48 89 c7             	mov    %rax,%rdi
    4a44:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4a4b:	00 00 00 
    4a4e:	ff d0                	call   *%rax
    4a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    4a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4a57:	79 19                	jns    4a72 <fourteen+0x128>
    failexit("open 12345678901234/12345678901234/12345678901234");
    4a59:	48 b8 d0 7f 00 00 00 	movabs $0x7fd0,%rax
    4a60:	00 00 00 
    4a63:	48 89 c7             	mov    %rax,%rdi
    4a66:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4a6d:	00 00 00 
    4a70:	ff d0                	call   *%rax
  }
  close(fd);
    4a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4a75:	89 c7                	mov    %eax,%edi
    4a77:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    4a7e:	00 00 00 
    4a81:	ff d0                	call   *%rax

  if(mkdir("12345678901234/12345678901234") == 0){
    4a83:	48 b8 02 80 00 00 00 	movabs $0x8002,%rax
    4a8a:	00 00 00 
    4a8d:	48 89 c7             	mov    %rax,%rdi
    4a90:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    4a97:	00 00 00 
    4a9a:	ff d0                	call   *%rax
    4a9c:	85 c0                	test   %eax,%eax
    4a9e:	75 19                	jne    4ab9 <fourteen+0x16f>
    failexit("mkdir 12345678901234/12345678901234 succeeded");
    4aa0:	48 b8 20 80 00 00 00 	movabs $0x8020,%rax
    4aa7:	00 00 00 
    4aaa:	48 89 c7             	mov    %rax,%rdi
    4aad:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4ab4:	00 00 00 
    4ab7:	ff d0                	call   *%rax
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    4ab9:	48 b8 50 80 00 00 00 	movabs $0x8050,%rax
    4ac0:	00 00 00 
    4ac3:	48 89 c7             	mov    %rax,%rdi
    4ac6:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    4acd:	00 00 00 
    4ad0:	ff d0                	call   *%rax
    4ad2:	85 c0                	test   %eax,%eax
    4ad4:	75 19                	jne    4aef <fourteen+0x1a5>
    failexit("mkdir 12345678901234/123456789012345 succeeded");
    4ad6:	48 b8 70 80 00 00 00 	movabs $0x8070,%rax
    4add:	00 00 00 
    4ae0:	48 89 c7             	mov    %rax,%rdi
    4ae3:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4aea:	00 00 00 
    4aed:	ff d0                	call   *%rax
  }

  printf(1, "fourteen ok\n");
    4aef:	48 b8 9f 80 00 00 00 	movabs $0x809f,%rax
    4af6:	00 00 00 
    4af9:	48 89 c6             	mov    %rax,%rsi
    4afc:	bf 01 00 00 00       	mov    $0x1,%edi
    4b01:	b8 00 00 00 00       	mov    $0x0,%eax
    4b06:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4b0d:	00 00 00 
    4b10:	ff d2                	call   *%rdx
}
    4b12:	90                   	nop
    4b13:	c9                   	leave
    4b14:	c3                   	ret

0000000000004b15 <rmdot>:

void
rmdot(void)
{
    4b15:	55                   	push   %rbp
    4b16:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "rmdot test\n");
    4b19:	48 b8 ac 80 00 00 00 	movabs $0x80ac,%rax
    4b20:	00 00 00 
    4b23:	48 89 c6             	mov    %rax,%rsi
    4b26:	bf 01 00 00 00       	mov    $0x1,%edi
    4b2b:	b8 00 00 00 00       	mov    $0x0,%eax
    4b30:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4b37:	00 00 00 
    4b3a:	ff d2                	call   *%rdx
  if(mkdir("dots") != 0){
    4b3c:	48 b8 b8 80 00 00 00 	movabs $0x80b8,%rax
    4b43:	00 00 00 
    4b46:	48 89 c7             	mov    %rax,%rdi
    4b49:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    4b50:	00 00 00 
    4b53:	ff d0                	call   *%rax
    4b55:	85 c0                	test   %eax,%eax
    4b57:	74 19                	je     4b72 <rmdot+0x5d>
    failexit("mkdir dots");
    4b59:	48 b8 bd 80 00 00 00 	movabs $0x80bd,%rax
    4b60:	00 00 00 
    4b63:	48 89 c7             	mov    %rax,%rdi
    4b66:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4b6d:	00 00 00 
    4b70:	ff d0                	call   *%rax
  }
  if(chdir("dots") != 0){
    4b72:	48 b8 b8 80 00 00 00 	movabs $0x80b8,%rax
    4b79:	00 00 00 
    4b7c:	48 89 c7             	mov    %rax,%rdi
    4b7f:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    4b86:	00 00 00 
    4b89:	ff d0                	call   *%rax
    4b8b:	85 c0                	test   %eax,%eax
    4b8d:	74 19                	je     4ba8 <rmdot+0x93>
    failexit("chdir dots");
    4b8f:	48 b8 c8 80 00 00 00 	movabs $0x80c8,%rax
    4b96:	00 00 00 
    4b99:	48 89 c7             	mov    %rax,%rdi
    4b9c:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4ba3:	00 00 00 
    4ba6:	ff d0                	call   *%rax
  }
  if(unlink(".") == 0){
    4ba8:	48 b8 da 78 00 00 00 	movabs $0x78da,%rax
    4baf:	00 00 00 
    4bb2:	48 89 c7             	mov    %rax,%rdi
    4bb5:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4bbc:	00 00 00 
    4bbf:	ff d0                	call   *%rax
    4bc1:	85 c0                	test   %eax,%eax
    4bc3:	75 19                	jne    4bde <rmdot+0xc9>
    failexit("rm . worked");
    4bc5:	48 b8 d3 80 00 00 00 	movabs $0x80d3,%rax
    4bcc:	00 00 00 
    4bcf:	48 89 c7             	mov    %rax,%rdi
    4bd2:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4bd9:	00 00 00 
    4bdc:	ff d0                	call   *%rax
  }
  if(unlink("..") == 0){
    4bde:	48 b8 52 74 00 00 00 	movabs $0x7452,%rax
    4be5:	00 00 00 
    4be8:	48 89 c7             	mov    %rax,%rdi
    4beb:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4bf2:	00 00 00 
    4bf5:	ff d0                	call   *%rax
    4bf7:	85 c0                	test   %eax,%eax
    4bf9:	75 19                	jne    4c14 <rmdot+0xff>
    failexit("rm .. worked");
    4bfb:	48 b8 df 80 00 00 00 	movabs $0x80df,%rax
    4c02:	00 00 00 
    4c05:	48 89 c7             	mov    %rax,%rdi
    4c08:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4c0f:	00 00 00 
    4c12:	ff d0                	call   *%rax
  }
  if(chdir("/") != 0){
    4c14:	48 b8 48 71 00 00 00 	movabs $0x7148,%rax
    4c1b:	00 00 00 
    4c1e:	48 89 c7             	mov    %rax,%rdi
    4c21:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    4c28:	00 00 00 
    4c2b:	ff d0                	call   *%rax
    4c2d:	85 c0                	test   %eax,%eax
    4c2f:	74 19                	je     4c4a <rmdot+0x135>
    failexit("chdir /");
    4c31:	48 b8 4a 71 00 00 00 	movabs $0x714a,%rax
    4c38:	00 00 00 
    4c3b:	48 89 c7             	mov    %rax,%rdi
    4c3e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4c45:	00 00 00 
    4c48:	ff d0                	call   *%rax
  }
  if(unlink("dots/.") == 0){
    4c4a:	48 b8 ec 80 00 00 00 	movabs $0x80ec,%rax
    4c51:	00 00 00 
    4c54:	48 89 c7             	mov    %rax,%rdi
    4c57:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4c5e:	00 00 00 
    4c61:	ff d0                	call   *%rax
    4c63:	85 c0                	test   %eax,%eax
    4c65:	75 19                	jne    4c80 <rmdot+0x16b>
    failexit("unlink dots/. worked");
    4c67:	48 b8 f3 80 00 00 00 	movabs $0x80f3,%rax
    4c6e:	00 00 00 
    4c71:	48 89 c7             	mov    %rax,%rdi
    4c74:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4c7b:	00 00 00 
    4c7e:	ff d0                	call   *%rax
  }
  if(unlink("dots/..") == 0){
    4c80:	48 b8 08 81 00 00 00 	movabs $0x8108,%rax
    4c87:	00 00 00 
    4c8a:	48 89 c7             	mov    %rax,%rdi
    4c8d:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4c94:	00 00 00 
    4c97:	ff d0                	call   *%rax
    4c99:	85 c0                	test   %eax,%eax
    4c9b:	75 19                	jne    4cb6 <rmdot+0x1a1>
    failexit("unlink dots/.. worked");
    4c9d:	48 b8 10 81 00 00 00 	movabs $0x8110,%rax
    4ca4:	00 00 00 
    4ca7:	48 89 c7             	mov    %rax,%rdi
    4caa:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4cb1:	00 00 00 
    4cb4:	ff d0                	call   *%rax
  }
  if(unlink("dots") != 0){
    4cb6:	48 b8 b8 80 00 00 00 	movabs $0x80b8,%rax
    4cbd:	00 00 00 
    4cc0:	48 89 c7             	mov    %rax,%rdi
    4cc3:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4cca:	00 00 00 
    4ccd:	ff d0                	call   *%rax
    4ccf:	85 c0                	test   %eax,%eax
    4cd1:	74 19                	je     4cec <rmdot+0x1d7>
    failexit("unlink dots");
    4cd3:	48 b8 26 81 00 00 00 	movabs $0x8126,%rax
    4cda:	00 00 00 
    4cdd:	48 89 c7             	mov    %rax,%rdi
    4ce0:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4ce7:	00 00 00 
    4cea:	ff d0                	call   *%rax
  }
  printf(1, "rmdot ok\n");
    4cec:	48 b8 32 81 00 00 00 	movabs $0x8132,%rax
    4cf3:	00 00 00 
    4cf6:	48 89 c6             	mov    %rax,%rsi
    4cf9:	bf 01 00 00 00       	mov    $0x1,%edi
    4cfe:	b8 00 00 00 00       	mov    $0x0,%eax
    4d03:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4d0a:	00 00 00 
    4d0d:	ff d2                	call   *%rdx
}
    4d0f:	90                   	nop
    4d10:	5d                   	pop    %rbp
    4d11:	c3                   	ret

0000000000004d12 <dirfile>:

void
dirfile(void)
{
    4d12:	55                   	push   %rbp
    4d13:	48 89 e5             	mov    %rsp,%rbp
    4d16:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;

  printf(1, "dir vs file\n");
    4d1a:	48 b8 3c 81 00 00 00 	movabs $0x813c,%rax
    4d21:	00 00 00 
    4d24:	48 89 c6             	mov    %rax,%rsi
    4d27:	bf 01 00 00 00       	mov    $0x1,%edi
    4d2c:	b8 00 00 00 00       	mov    $0x0,%eax
    4d31:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4d38:	00 00 00 
    4d3b:	ff d2                	call   *%rdx

  fd = open("dirfile", O_CREATE);
    4d3d:	48 b8 49 81 00 00 00 	movabs $0x8149,%rax
    4d44:	00 00 00 
    4d47:	be 00 02 00 00       	mov    $0x200,%esi
    4d4c:	48 89 c7             	mov    %rax,%rdi
    4d4f:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4d56:	00 00 00 
    4d59:	ff d0                	call   *%rax
    4d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0){
    4d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4d62:	79 19                	jns    4d7d <dirfile+0x6b>
    failexit("create dirfile");
    4d64:	48 b8 51 81 00 00 00 	movabs $0x8151,%rax
    4d6b:	00 00 00 
    4d6e:	48 89 c7             	mov    %rax,%rdi
    4d71:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4d78:	00 00 00 
    4d7b:	ff d0                	call   *%rax
  }
  close(fd);
    4d7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4d80:	89 c7                	mov    %eax,%edi
    4d82:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    4d89:	00 00 00 
    4d8c:	ff d0                	call   *%rax
  if(chdir("dirfile") == 0){
    4d8e:	48 b8 49 81 00 00 00 	movabs $0x8149,%rax
    4d95:	00 00 00 
    4d98:	48 89 c7             	mov    %rax,%rdi
    4d9b:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    4da2:	00 00 00 
    4da5:	ff d0                	call   *%rax
    4da7:	85 c0                	test   %eax,%eax
    4da9:	75 19                	jne    4dc4 <dirfile+0xb2>
    failexit("chdir dirfile succeeded");
    4dab:	48 b8 60 81 00 00 00 	movabs $0x8160,%rax
    4db2:	00 00 00 
    4db5:	48 89 c7             	mov    %rax,%rdi
    4db8:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4dbf:	00 00 00 
    4dc2:	ff d0                	call   *%rax
  }
  fd = open("dirfile/xx", 0);
    4dc4:	48 b8 78 81 00 00 00 	movabs $0x8178,%rax
    4dcb:	00 00 00 
    4dce:	be 00 00 00 00       	mov    $0x0,%esi
    4dd3:	48 89 c7             	mov    %rax,%rdi
    4dd6:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4ddd:	00 00 00 
    4de0:	ff d0                	call   *%rax
    4de2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    4de5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4de9:	78 19                	js     4e04 <dirfile+0xf2>
    failexit("create dirfile/xx succeeded");
    4deb:	48 b8 83 81 00 00 00 	movabs $0x8183,%rax
    4df2:	00 00 00 
    4df5:	48 89 c7             	mov    %rax,%rdi
    4df8:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4dff:	00 00 00 
    4e02:	ff d0                	call   *%rax
  }
  fd = open("dirfile/xx", O_CREATE);
    4e04:	48 b8 78 81 00 00 00 	movabs $0x8178,%rax
    4e0b:	00 00 00 
    4e0e:	be 00 02 00 00       	mov    $0x200,%esi
    4e13:	48 89 c7             	mov    %rax,%rdi
    4e16:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4e1d:	00 00 00 
    4e20:	ff d0                	call   *%rax
    4e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    4e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4e29:	78 19                	js     4e44 <dirfile+0x132>
    failexit("create dirfile/xx succeeded");
    4e2b:	48 b8 83 81 00 00 00 	movabs $0x8183,%rax
    4e32:	00 00 00 
    4e35:	48 89 c7             	mov    %rax,%rdi
    4e38:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4e3f:	00 00 00 
    4e42:	ff d0                	call   *%rax
  }
  if(mkdir("dirfile/xx") == 0){
    4e44:	48 b8 78 81 00 00 00 	movabs $0x8178,%rax
    4e4b:	00 00 00 
    4e4e:	48 89 c7             	mov    %rax,%rdi
    4e51:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    4e58:	00 00 00 
    4e5b:	ff d0                	call   *%rax
    4e5d:	85 c0                	test   %eax,%eax
    4e5f:	75 19                	jne    4e7a <dirfile+0x168>
    failexit("mkdir dirfile/xx succeeded");
    4e61:	48 b8 9f 81 00 00 00 	movabs $0x819f,%rax
    4e68:	00 00 00 
    4e6b:	48 89 c7             	mov    %rax,%rdi
    4e6e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4e75:	00 00 00 
    4e78:	ff d0                	call   *%rax
  }
  if(unlink("dirfile/xx") == 0){
    4e7a:	48 b8 78 81 00 00 00 	movabs $0x8178,%rax
    4e81:	00 00 00 
    4e84:	48 89 c7             	mov    %rax,%rdi
    4e87:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4e8e:	00 00 00 
    4e91:	ff d0                	call   *%rax
    4e93:	85 c0                	test   %eax,%eax
    4e95:	75 19                	jne    4eb0 <dirfile+0x19e>
    failexit("unlink dirfile/xx succeeded");
    4e97:	48 b8 ba 81 00 00 00 	movabs $0x81ba,%rax
    4e9e:	00 00 00 
    4ea1:	48 89 c7             	mov    %rax,%rdi
    4ea4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4eab:	00 00 00 
    4eae:	ff d0                	call   *%rax
  }
  if(link("README", "dirfile/xx") == 0){
    4eb0:	48 ba 78 81 00 00 00 	movabs $0x8178,%rdx
    4eb7:	00 00 00 
    4eba:	48 b8 d6 81 00 00 00 	movabs $0x81d6,%rax
    4ec1:	00 00 00 
    4ec4:	48 89 d6             	mov    %rdx,%rsi
    4ec7:	48 89 c7             	mov    %rax,%rdi
    4eca:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    4ed1:	00 00 00 
    4ed4:	ff d0                	call   *%rax
    4ed6:	85 c0                	test   %eax,%eax
    4ed8:	75 19                	jne    4ef3 <dirfile+0x1e1>
    failexit("link to dirfile/xx succeeded");
    4eda:	48 b8 dd 81 00 00 00 	movabs $0x81dd,%rax
    4ee1:	00 00 00 
    4ee4:	48 89 c7             	mov    %rax,%rdi
    4ee7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4eee:	00 00 00 
    4ef1:	ff d0                	call   *%rax
  }
  if(unlink("dirfile") != 0){
    4ef3:	48 b8 49 81 00 00 00 	movabs $0x8149,%rax
    4efa:	00 00 00 
    4efd:	48 89 c7             	mov    %rax,%rdi
    4f00:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    4f07:	00 00 00 
    4f0a:	ff d0                	call   *%rax
    4f0c:	85 c0                	test   %eax,%eax
    4f0e:	74 19                	je     4f29 <dirfile+0x217>
    failexit("unlink dirfile");
    4f10:	48 b8 fa 81 00 00 00 	movabs $0x81fa,%rax
    4f17:	00 00 00 
    4f1a:	48 89 c7             	mov    %rax,%rdi
    4f1d:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4f24:	00 00 00 
    4f27:	ff d0                	call   *%rax
  }

  fd = open(".", O_RDWR);
    4f29:	48 b8 da 78 00 00 00 	movabs $0x78da,%rax
    4f30:	00 00 00 
    4f33:	be 02 00 00 00       	mov    $0x2,%esi
    4f38:	48 89 c7             	mov    %rax,%rdi
    4f3b:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4f42:	00 00 00 
    4f45:	ff d0                	call   *%rax
    4f47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd >= 0){
    4f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    4f4e:	78 19                	js     4f69 <dirfile+0x257>
    failexit("open . for writing succeeded");
    4f50:	48 b8 09 82 00 00 00 	movabs $0x8209,%rax
    4f57:	00 00 00 
    4f5a:	48 89 c7             	mov    %rax,%rdi
    4f5d:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4f64:	00 00 00 
    4f67:	ff d0                	call   *%rax
  }
  fd = open(".", 0);
    4f69:	48 b8 da 78 00 00 00 	movabs $0x78da,%rax
    4f70:	00 00 00 
    4f73:	be 00 00 00 00       	mov    $0x0,%esi
    4f78:	48 89 c7             	mov    %rax,%rdi
    4f7b:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    4f82:	00 00 00 
    4f85:	ff d0                	call   *%rax
    4f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(write(fd, "x", 1) > 0){
    4f8a:	48 b9 5e 75 00 00 00 	movabs $0x755e,%rcx
    4f91:	00 00 00 
    4f94:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4f97:	ba 01 00 00 00       	mov    $0x1,%edx
    4f9c:	48 89 ce             	mov    %rcx,%rsi
    4f9f:	89 c7                	mov    %eax,%edi
    4fa1:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    4fa8:	00 00 00 
    4fab:	ff d0                	call   *%rax
    4fad:	85 c0                	test   %eax,%eax
    4faf:	7e 19                	jle    4fca <dirfile+0x2b8>
    failexit("write . succeeded");
    4fb1:	48 b8 26 82 00 00 00 	movabs $0x8226,%rax
    4fb8:	00 00 00 
    4fbb:	48 89 c7             	mov    %rax,%rdi
    4fbe:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    4fc5:	00 00 00 
    4fc8:	ff d0                	call   *%rax
  }
  close(fd);
    4fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
    4fcd:	89 c7                	mov    %eax,%edi
    4fcf:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    4fd6:	00 00 00 
    4fd9:	ff d0                	call   *%rax

  printf(1, "dir vs file OK\n");
    4fdb:	48 b8 38 82 00 00 00 	movabs $0x8238,%rax
    4fe2:	00 00 00 
    4fe5:	48 89 c6             	mov    %rax,%rsi
    4fe8:	bf 01 00 00 00       	mov    $0x1,%edi
    4fed:	b8 00 00 00 00       	mov    $0x0,%eax
    4ff2:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    4ff9:	00 00 00 
    4ffc:	ff d2                	call   *%rdx
}
    4ffe:	90                   	nop
    4fff:	c9                   	leave
    5000:	c3                   	ret

0000000000005001 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    5001:	55                   	push   %rbp
    5002:	48 89 e5             	mov    %rsp,%rbp
    5005:	48 83 ec 10          	sub    $0x10,%rsp
  int i, fd;

  printf(1, "empty file name\n");
    5009:	48 b8 48 82 00 00 00 	movabs $0x8248,%rax
    5010:	00 00 00 
    5013:	48 89 c6             	mov    %rax,%rsi
    5016:	bf 01 00 00 00       	mov    $0x1,%edi
    501b:	b8 00 00 00 00       	mov    $0x0,%eax
    5020:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5027:	00 00 00 
    502a:	ff d2                	call   *%rdx

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    502c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    5033:	e9 38 01 00 00       	jmp    5170 <iref+0x16f>
    if(mkdir("irefd") != 0){
    5038:	48 b8 59 82 00 00 00 	movabs $0x8259,%rax
    503f:	00 00 00 
    5042:	48 89 c7             	mov    %rax,%rdi
    5045:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    504c:	00 00 00 
    504f:	ff d0                	call   *%rax
    5051:	85 c0                	test   %eax,%eax
    5053:	74 19                	je     506e <iref+0x6d>
      failexit("mkdir irefd");
    5055:	48 b8 5f 82 00 00 00 	movabs $0x825f,%rax
    505c:	00 00 00 
    505f:	48 89 c7             	mov    %rax,%rdi
    5062:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5069:	00 00 00 
    506c:	ff d0                	call   *%rax
    }
    if(chdir("irefd") != 0){
    506e:	48 b8 59 82 00 00 00 	movabs $0x8259,%rax
    5075:	00 00 00 
    5078:	48 89 c7             	mov    %rax,%rdi
    507b:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    5082:	00 00 00 
    5085:	ff d0                	call   *%rax
    5087:	85 c0                	test   %eax,%eax
    5089:	74 19                	je     50a4 <iref+0xa3>
      failexit("chdir irefd");
    508b:	48 b8 6b 82 00 00 00 	movabs $0x826b,%rax
    5092:	00 00 00 
    5095:	48 89 c7             	mov    %rax,%rdi
    5098:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    509f:	00 00 00 
    50a2:	ff d0                	call   *%rax
    }

    mkdir("");
    50a4:	48 b8 77 82 00 00 00 	movabs $0x8277,%rax
    50ab:	00 00 00 
    50ae:	48 89 c7             	mov    %rax,%rdi
    50b1:	48 b8 59 67 00 00 00 	movabs $0x6759,%rax
    50b8:	00 00 00 
    50bb:	ff d0                	call   *%rax
    link("README", "");
    50bd:	48 ba 77 82 00 00 00 	movabs $0x8277,%rdx
    50c4:	00 00 00 
    50c7:	48 b8 d6 81 00 00 00 	movabs $0x81d6,%rax
    50ce:	00 00 00 
    50d1:	48 89 d6             	mov    %rdx,%rsi
    50d4:	48 89 c7             	mov    %rax,%rdi
    50d7:	48 b8 4c 67 00 00 00 	movabs $0x674c,%rax
    50de:	00 00 00 
    50e1:	ff d0                	call   *%rax
    fd = open("", O_CREATE);
    50e3:	48 b8 77 82 00 00 00 	movabs $0x8277,%rax
    50ea:	00 00 00 
    50ed:	be 00 02 00 00       	mov    $0x200,%esi
    50f2:	48 89 c7             	mov    %rax,%rdi
    50f5:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    50fc:	00 00 00 
    50ff:	ff d0                	call   *%rax
    5101:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0)
    5104:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5108:	78 11                	js     511b <iref+0x11a>
      close(fd);
    510a:	8b 45 f8             	mov    -0x8(%rbp),%eax
    510d:	89 c7                	mov    %eax,%edi
    510f:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    5116:	00 00 00 
    5119:	ff d0                	call   *%rax
    fd = open("xx", O_CREATE);
    511b:	48 b8 78 82 00 00 00 	movabs $0x8278,%rax
    5122:	00 00 00 
    5125:	be 00 02 00 00       	mov    $0x200,%esi
    512a:	48 89 c7             	mov    %rax,%rdi
    512d:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    5134:	00 00 00 
    5137:	ff d0                	call   *%rax
    5139:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(fd >= 0)
    513c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5140:	78 11                	js     5153 <iref+0x152>
      close(fd);
    5142:	8b 45 f8             	mov    -0x8(%rbp),%eax
    5145:	89 c7                	mov    %eax,%edi
    5147:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    514e:	00 00 00 
    5151:	ff d0                	call   *%rax
    unlink("xx");
    5153:	48 b8 78 82 00 00 00 	movabs $0x8278,%rax
    515a:	00 00 00 
    515d:	48 89 c7             	mov    %rax,%rdi
    5160:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    5167:	00 00 00 
    516a:	ff d0                	call   *%rax
  for(i = 0; i < 50 + 1; i++){
    516c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5170:	83 7d fc 32          	cmpl   $0x32,-0x4(%rbp)
    5174:	0f 8e be fe ff ff    	jle    5038 <iref+0x37>
  }

  chdir("/");
    517a:	48 b8 48 71 00 00 00 	movabs $0x7148,%rax
    5181:	00 00 00 
    5184:	48 89 c7             	mov    %rax,%rdi
    5187:	48 b8 66 67 00 00 00 	movabs $0x6766,%rax
    518e:	00 00 00 
    5191:	ff d0                	call   *%rax
  printf(1, "empty file name OK\n");
    5193:	48 b8 7b 82 00 00 00 	movabs $0x827b,%rax
    519a:	00 00 00 
    519d:	48 89 c6             	mov    %rax,%rsi
    51a0:	bf 01 00 00 00       	mov    $0x1,%edi
    51a5:	b8 00 00 00 00       	mov    $0x0,%eax
    51aa:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    51b1:	00 00 00 
    51b4:	ff d2                	call   *%rdx
}
    51b6:	90                   	nop
    51b7:	c9                   	leave
    51b8:	c3                   	ret

00000000000051b9 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    51b9:	55                   	push   %rbp
    51ba:	48 89 e5             	mov    %rsp,%rbp
    51bd:	48 83 ec 10          	sub    $0x10,%rsp
  int n, pid;

  printf(1, "fork test\n");
    51c1:	48 b8 8f 82 00 00 00 	movabs $0x828f,%rax
    51c8:	00 00 00 
    51cb:	48 89 c6             	mov    %rax,%rsi
    51ce:	bf 01 00 00 00       	mov    $0x1,%edi
    51d3:	b8 00 00 00 00       	mov    $0x0,%eax
    51d8:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    51df:	00 00 00 
    51e2:	ff d2                	call   *%rdx

  for(n=0; n<1000; n++){
    51e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    51eb:	eb 2b                	jmp    5218 <forktest+0x5f>
    pid = fork();
    51ed:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    51f4:	00 00 00 
    51f7:	ff d0                	call   *%rax
    51f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(pid < 0)
    51fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5200:	78 21                	js     5223 <forktest+0x6a>
      break;
    if(pid == 0)
    5202:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5206:	75 0c                	jne    5214 <forktest+0x5b>
      exit();
    5208:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    520f:	00 00 00 
    5212:	ff d0                	call   *%rax
  for(n=0; n<1000; n++){
    5214:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5218:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
    521f:	7e cc                	jle    51ed <forktest+0x34>
    5221:	eb 01                	jmp    5224 <forktest+0x6b>
      break;
    5223:	90                   	nop
  }

  if(n == 1000){
    5224:	81 7d fc e8 03 00 00 	cmpl   $0x3e8,-0x4(%rbp)
    522b:	75 48                	jne    5275 <forktest+0xbc>
    failexit("fork claimed to work 1000 times");
    522d:	48 b8 a0 82 00 00 00 	movabs $0x82a0,%rax
    5234:	00 00 00 
    5237:	48 89 c7             	mov    %rax,%rdi
    523a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5241:	00 00 00 
    5244:	ff d0                	call   *%rax
  }

  for(; n > 0; n--){
    5246:	eb 2d                	jmp    5275 <forktest+0xbc>
    if(wait() < 0){
    5248:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    524f:	00 00 00 
    5252:	ff d0                	call   *%rax
    5254:	85 c0                	test   %eax,%eax
    5256:	79 19                	jns    5271 <forktest+0xb8>
      failexit("wait stopped early");
    5258:	48 b8 c0 82 00 00 00 	movabs $0x82c0,%rax
    525f:	00 00 00 
    5262:	48 89 c7             	mov    %rax,%rdi
    5265:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    526c:	00 00 00 
    526f:	ff d0                	call   *%rax
  for(; n > 0; n--){
    5271:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
    5275:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    5279:	7f cd                	jg     5248 <forktest+0x8f>
    }
  }

  if(wait() != -1){
    527b:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    5282:	00 00 00 
    5285:	ff d0                	call   *%rax
    5287:	83 f8 ff             	cmp    $0xffffffff,%eax
    528a:	74 19                	je     52a5 <forktest+0xec>
    failexit("wait got too many");
    528c:	48 b8 d3 82 00 00 00 	movabs $0x82d3,%rax
    5293:	00 00 00 
    5296:	48 89 c7             	mov    %rax,%rdi
    5299:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    52a0:	00 00 00 
    52a3:	ff d0                	call   *%rax
  }

  printf(1, "fork test OK\n");
    52a5:	48 b8 e5 82 00 00 00 	movabs $0x82e5,%rax
    52ac:	00 00 00 
    52af:	48 89 c6             	mov    %rax,%rsi
    52b2:	bf 01 00 00 00       	mov    $0x1,%edi
    52b7:	b8 00 00 00 00       	mov    $0x0,%eax
    52bc:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    52c3:	00 00 00 
    52c6:	ff d2                	call   *%rdx
}
    52c8:	90                   	nop
    52c9:	c9                   	leave
    52ca:	c3                   	ret

00000000000052cb <sbrktest>:

void
sbrktest(void)
{
    52cb:	55                   	push   %rbp
    52cc:	48 89 e5             	mov    %rsp,%rbp
    52cf:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(1, "sbrk test\n");
    52d6:	48 b8 f3 82 00 00 00 	movabs $0x82f3,%rax
    52dd:	00 00 00 
    52e0:	48 89 c6             	mov    %rax,%rsi
    52e3:	bf 01 00 00 00       	mov    $0x1,%edi
    52e8:	b8 00 00 00 00       	mov    $0x0,%eax
    52ed:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    52f4:	00 00 00 
    52f7:	ff d2                	call   *%rdx
  oldbrk = sbrk(0);
    52f9:	bf 00 00 00 00       	mov    $0x0,%edi
    52fe:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5305:	00 00 00 
    5308:	ff d0                	call   *%rax
    530a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    530e:	bf 00 00 00 00       	mov    $0x0,%edi
    5313:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    531a:	00 00 00 
    531d:	ff d0                	call   *%rax
    531f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  int i;
  for(i = 0; i < 5000; i++){
    5323:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    532a:	eb 76                	jmp    53a2 <sbrktest+0xd7>
    b = sbrk(1);
    532c:	bf 01 00 00 00       	mov    $0x1,%edi
    5331:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5338:	00 00 00 
    533b:	ff d0                	call   *%rax
    533d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    if(b != a){
    5341:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    5345:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    5349:	74 40                	je     538b <sbrktest+0xc0>
      printf(1, "sbrk test failed %d %p %p\n", i, a, b);
    534b:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
    534f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    5353:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5356:	48 be fe 82 00 00 00 	movabs $0x82fe,%rsi
    535d:	00 00 00 
    5360:	49 89 c8             	mov    %rcx,%r8
    5363:	48 89 d1             	mov    %rdx,%rcx
    5366:	89 c2                	mov    %eax,%edx
    5368:	bf 01 00 00 00       	mov    $0x1,%edi
    536d:	b8 00 00 00 00       	mov    $0x0,%eax
    5372:	49 b9 be 69 00 00 00 	movabs $0x69be,%r9
    5379:	00 00 00 
    537c:	41 ff d1             	call   *%r9
      exit();
    537f:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    5386:	00 00 00 
    5389:	ff d0                	call   *%rax
    }
    *b = 1;
    538b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    538f:	c6 00 01             	movb   $0x1,(%rax)
    a = b + 1;
    5392:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    5396:	48 83 c0 01          	add    $0x1,%rax
    539a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(i = 0; i < 5000; i++){
    539e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    53a2:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%rbp)
    53a9:	7e 81                	jle    532c <sbrktest+0x61>
  }
  pid = fork();
    53ab:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    53b2:	00 00 00 
    53b5:	ff d0                	call   *%rax
    53b7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  if(pid < 0){
    53ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    53be:	79 19                	jns    53d9 <sbrktest+0x10e>
    failexit("sbrk test fork");
    53c0:	48 b8 19 83 00 00 00 	movabs $0x8319,%rax
    53c7:	00 00 00 
    53ca:	48 89 c7             	mov    %rax,%rdi
    53cd:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    53d4:	00 00 00 
    53d7:	ff d0                	call   *%rax
  }
  c = sbrk(1);
    53d9:	bf 01 00 00 00       	mov    $0x1,%edi
    53de:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    53e5:	00 00 00 
    53e8:	ff d0                	call   *%rax
    53ea:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  c = sbrk(1);
    53ee:	bf 01 00 00 00       	mov    $0x1,%edi
    53f3:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    53fa:	00 00 00 
    53fd:	ff d0                	call   *%rax
    53ff:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a + 1){
    5403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    5407:	48 83 c0 01          	add    $0x1,%rax
    540b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    540f:	74 19                	je     542a <sbrktest+0x15f>
    failexit("sbrk test failed post-fork");
    5411:	48 b8 28 83 00 00 00 	movabs $0x8328,%rax
    5418:	00 00 00 
    541b:	48 89 c7             	mov    %rax,%rdi
    541e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5425:	00 00 00 
    5428:	ff d0                	call   *%rax
  }
  if(pid == 0)
    542a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    542e:	75 0c                	jne    543c <sbrktest+0x171>
    exit();
    5430:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    5437:	00 00 00 
    543a:	ff d0                	call   *%rax
  wait();
    543c:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    5443:	00 00 00 
    5446:	ff d0                	call   *%rax

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    5448:	bf 00 00 00 00       	mov    $0x0,%edi
    544d:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5454:	00 00 00 
    5457:	ff d0                	call   *%rax
    5459:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  amt = (BIG) - (addr_t)a;
    545d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    5461:	89 c2                	mov    %eax,%edx
    5463:	b8 00 00 40 06       	mov    $0x6400000,%eax
    5468:	29 d0                	sub    %edx,%eax
    546a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  p = sbrk(amt);
    546d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    5470:	48 89 c7             	mov    %rax,%rdi
    5473:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    547a:	00 00 00 
    547d:	ff d0                	call   *%rax
    547f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  if (p != a) {
    5483:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    5487:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    548b:	74 19                	je     54a6 <sbrktest+0x1db>
    failexit("sbrk test failed to grow big address space; enough phys mem?");
    548d:	48 b8 48 83 00 00 00 	movabs $0x8348,%rax
    5494:	00 00 00 
    5497:	48 89 c7             	mov    %rax,%rdi
    549a:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    54a1:	00 00 00 
    54a4:	ff d0                	call   *%rax
  }
  lastaddr = (char*) (BIG-1);
    54a6:	48 c7 45 c0 ff ff 3f 	movq   $0x63fffff,-0x40(%rbp)
    54ad:	06 
  *lastaddr = 99;
    54ae:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
    54b2:	c6 00 63             	movb   $0x63,(%rax)

  // can one de-allocate?
  a = sbrk(0);
    54b5:	bf 00 00 00 00       	mov    $0x0,%edi
    54ba:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    54c1:	00 00 00 
    54c4:	ff d0                	call   *%rax
    54c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  c = sbrk(-4096);
    54ca:	48 c7 c7 00 f0 ff ff 	mov    $0xfffffffffffff000,%rdi
    54d1:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    54d8:	00 00 00 
    54db:	ff d0                	call   *%rax
    54dd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c == (char*)0xffffffff){
    54e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    54e6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    54ea:	75 19                	jne    5505 <sbrktest+0x23a>
    failexit("sbrk could not deallocate");
    54ec:	48 b8 85 83 00 00 00 	movabs $0x8385,%rax
    54f3:	00 00 00 
    54f6:	48 89 c7             	mov    %rax,%rdi
    54f9:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5500:	00 00 00 
    5503:	ff d0                	call   *%rax
  }
  c = sbrk(0);
    5505:	bf 00 00 00 00       	mov    $0x0,%edi
    550a:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5511:	00 00 00 
    5514:	ff d0                	call   *%rax
    5516:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a - 4096){
    551a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    551e:	48 2d 00 10 00 00    	sub    $0x1000,%rax
    5524:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    5528:	74 3b                	je     5565 <sbrktest+0x29a>
    printf(1, "sbrk deallocation produced wrong address, a %p c %p\n", a, c);
    552a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    552e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    5532:	48 be a0 83 00 00 00 	movabs $0x83a0,%rsi
    5539:	00 00 00 
    553c:	48 89 d1             	mov    %rdx,%rcx
    553f:	48 89 c2             	mov    %rax,%rdx
    5542:	bf 01 00 00 00       	mov    $0x1,%edi
    5547:	b8 00 00 00 00       	mov    $0x0,%eax
    554c:	49 b8 be 69 00 00 00 	movabs $0x69be,%r8
    5553:	00 00 00 
    5556:	41 ff d0             	call   *%r8
    exit();
    5559:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    5560:	00 00 00 
    5563:	ff d0                	call   *%rax
  }

  // can one re-allocate that page?
  a = sbrk(0);
    5565:	bf 00 00 00 00       	mov    $0x0,%edi
    556a:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5571:	00 00 00 
    5574:	ff d0                	call   *%rax
    5576:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  c = sbrk(4096);
    557a:	bf 00 10 00 00       	mov    $0x1000,%edi
    557f:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5586:	00 00 00 
    5589:	ff d0                	call   *%rax
    558b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a || sbrk(0) != a + 4096){
    558f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    5593:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    5597:	75 21                	jne    55ba <sbrktest+0x2ef>
    5599:	bf 00 00 00 00       	mov    $0x0,%edi
    559e:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    55a5:	00 00 00 
    55a8:	ff d0                	call   *%rax
    55aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    55ae:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
    55b5:	48 39 d0             	cmp    %rdx,%rax
    55b8:	74 3b                	je     55f5 <sbrktest+0x32a>
    printf(1, "sbrk re-allocation failed, a %p c %p\n", a, c);
    55ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    55be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    55c2:	48 be d8 83 00 00 00 	movabs $0x83d8,%rsi
    55c9:	00 00 00 
    55cc:	48 89 d1             	mov    %rdx,%rcx
    55cf:	48 89 c2             	mov    %rax,%rdx
    55d2:	bf 01 00 00 00       	mov    $0x1,%edi
    55d7:	b8 00 00 00 00       	mov    $0x0,%eax
    55dc:	49 b8 be 69 00 00 00 	movabs $0x69be,%r8
    55e3:	00 00 00 
    55e6:	41 ff d0             	call   *%r8
    exit();
    55e9:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    55f0:	00 00 00 
    55f3:	ff d0                	call   *%rax
  }
  if(*lastaddr == 99){
    55f5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
    55f9:	0f b6 00             	movzbl (%rax),%eax
    55fc:	3c 63                	cmp    $0x63,%al
    55fe:	75 19                	jne    5619 <sbrktest+0x34e>
    // should be zero
    failexit("sbrk de-allocation didn't really deallocate");
    5600:	48 b8 00 84 00 00 00 	movabs $0x8400,%rax
    5607:	00 00 00 
    560a:	48 89 c7             	mov    %rax,%rdi
    560d:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5614:	00 00 00 
    5617:	ff d0                	call   *%rax
  }

  a = sbrk(0);
    5619:	bf 00 00 00 00       	mov    $0x0,%edi
    561e:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5625:	00 00 00 
    5628:	ff d0                	call   *%rax
    562a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  c = sbrk(-(sbrk(0) - oldbrk));
    562e:	bf 00 00 00 00       	mov    $0x0,%edi
    5633:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    563a:	00 00 00 
    563d:	ff d0                	call   *%rax
    563f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    5643:	48 29 c2             	sub    %rax,%rdx
    5646:	48 89 d0             	mov    %rdx,%rax
    5649:	48 89 c7             	mov    %rax,%rdi
    564c:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5653:	00 00 00 
    5656:	ff d0                	call   *%rax
    5658:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if(c != a){
    565c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    5660:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    5664:	74 3b                	je     56a1 <sbrktest+0x3d6>
    printf(1, "sbrk downsize failed, a %p c %p\n", a, c);
    5666:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
    566a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    566e:	48 be 30 84 00 00 00 	movabs $0x8430,%rsi
    5675:	00 00 00 
    5678:	48 89 d1             	mov    %rdx,%rcx
    567b:	48 89 c2             	mov    %rax,%rdx
    567e:	bf 01 00 00 00       	mov    $0x1,%edi
    5683:	b8 00 00 00 00       	mov    $0x0,%eax
    5688:	49 b8 be 69 00 00 00 	movabs $0x69be,%r8
    568f:	00 00 00 
    5692:	41 ff d0             	call   *%r8
    exit();
    5695:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    569c:	00 00 00 
    569f:	ff d0                	call   *%rax
  }

  printf(1, "expecting 10 killed processes:\n");
    56a1:	48 b8 58 84 00 00 00 	movabs $0x8458,%rax
    56a8:	00 00 00 
    56ab:	48 89 c6             	mov    %rax,%rsi
    56ae:	bf 01 00 00 00       	mov    $0x1,%edi
    56b3:	b8 00 00 00 00       	mov    $0x0,%eax
    56b8:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    56bf:	00 00 00 
    56c2:	ff d2                	call   *%rdx
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+1000000); a += 100000){
    56c4:	48 b8 00 00 00 00 00 	movabs $0xffff800000000000,%rax
    56cb:	80 ff ff 
    56ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    56d2:	e9 ad 00 00 00       	jmp    5784 <sbrktest+0x4b9>
    ppid = getpid();
    56d7:	48 b8 80 67 00 00 00 	movabs $0x6780,%rax
    56de:	00 00 00 
    56e1:	ff d0                	call   *%rax
    56e3:	89 45 b8             	mov    %eax,-0x48(%rbp)
    pid = fork();
    56e6:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    56ed:	00 00 00 
    56f0:	ff d0                	call   *%rax
    56f2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if(pid < 0){
    56f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    56f9:	79 19                	jns    5714 <sbrktest+0x449>
      failexit("fork");
    56fb:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    5702:	00 00 00 
    5705:	48 89 c7             	mov    %rax,%rdi
    5708:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    570f:	00 00 00 
    5712:	ff d0                	call   *%rax
    }
    if(pid == 0){
    5714:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
    5718:	75 56                	jne    5770 <sbrktest+0x4a5>
      printf(1, "oops could read %p = %c\n", a, *a);
    571a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    571e:	0f b6 00             	movzbl (%rax),%eax
    5721:	0f be d0             	movsbl %al,%edx
    5724:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    5728:	48 be 78 84 00 00 00 	movabs $0x8478,%rsi
    572f:	00 00 00 
    5732:	89 d1                	mov    %edx,%ecx
    5734:	48 89 c2             	mov    %rax,%rdx
    5737:	bf 01 00 00 00       	mov    $0x1,%edi
    573c:	b8 00 00 00 00       	mov    $0x0,%eax
    5741:	49 b8 be 69 00 00 00 	movabs $0x69be,%r8
    5748:	00 00 00 
    574b:	41 ff d0             	call   *%r8
      kill(ppid,9);
    574e:	8b 45 b8             	mov    -0x48(%rbp),%eax
    5751:	be 09 00 00 00       	mov    $0x9,%esi
    5756:	89 c7                	mov    %eax,%edi
    5758:	48 b8 fe 66 00 00 00 	movabs $0x66fe,%rax
    575f:	00 00 00 
    5762:	ff d0                	call   *%rax
      exit();
    5764:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    576b:	00 00 00 
    576e:	ff d0                	call   *%rax
    }
    wait();
    5770:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    5777:	00 00 00 
    577a:	ff d0                	call   *%rax
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+1000000); a += 100000){
    577c:	48 81 45 f8 a0 86 01 	addq   $0x186a0,-0x8(%rbp)
    5783:	00 
    5784:	48 b8 3f 42 0f 00 00 	movabs $0xffff8000000f423f,%rax
    578b:	80 ff ff 
    578e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    5792:	0f 83 3f ff ff ff    	jae    56d7 <sbrktest+0x40c>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    5798:	48 8d 45 a8          	lea    -0x58(%rbp),%rax
    579c:	48 89 c7             	mov    %rax,%rdi
    579f:	48 b8 ca 66 00 00 00 	movabs $0x66ca,%rax
    57a6:	00 00 00 
    57a9:	ff d0                	call   *%rax
    57ab:	85 c0                	test   %eax,%eax
    57ad:	74 19                	je     57c8 <sbrktest+0x4fd>
    failexit("pipe()");
    57af:	48 b8 0b 75 00 00 00 	movabs $0x750b,%rax
    57b6:	00 00 00 
    57b9:	48 89 c7             	mov    %rax,%rdi
    57bc:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    57c3:	00 00 00 
    57c6:	ff d0                	call   *%rax
  }
  printf(1, "expecting failed sbrk()s:\n");
    57c8:	48 b8 91 84 00 00 00 	movabs $0x8491,%rax
    57cf:	00 00 00 
    57d2:	48 89 c6             	mov    %rax,%rsi
    57d5:	bf 01 00 00 00       	mov    $0x1,%edi
    57da:	b8 00 00 00 00       	mov    $0x0,%eax
    57df:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    57e6:	00 00 00 
    57e9:	ff d2                	call   *%rdx
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    57eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    57f2:	e9 e6 00 00 00       	jmp    58dd <sbrktest+0x612>
    if((pids[i] = fork()) == 0){
    57f7:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    57fe:	00 00 00 
    5801:	ff d0                	call   *%rax
    5803:	8b 55 f4             	mov    -0xc(%rbp),%edx
    5806:	48 63 d2             	movslq %edx,%rdx
    5809:	89 44 95 80          	mov    %eax,-0x80(%rbp,%rdx,4)
    580d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5810:	48 98                	cltq
    5812:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    5816:	85 c0                	test   %eax,%eax
    5818:	0f 85 8d 00 00 00    	jne    58ab <sbrktest+0x5e0>
      // allocate a lot of memory
      int ret = (int)(addr_t)sbrk(BIG - (addr_t)sbrk(0));
    581e:	bf 00 00 00 00       	mov    $0x0,%edi
    5823:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    582a:	00 00 00 
    582d:	ff d0                	call   *%rax
    582f:	48 89 c2             	mov    %rax,%rdx
    5832:	b8 00 00 40 06       	mov    $0x6400000,%eax
    5837:	48 29 d0             	sub    %rdx,%rax
    583a:	48 89 c7             	mov    %rax,%rdi
    583d:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5844:	00 00 00 
    5847:	ff d0                	call   *%rax
    5849:	89 45 bc             	mov    %eax,-0x44(%rbp)
      if(ret < 0)
    584c:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
    5850:	79 23                	jns    5875 <sbrktest+0x5aa>
        printf(1, "sbrk returned -1 as expected\n");
    5852:	48 b8 ac 84 00 00 00 	movabs $0x84ac,%rax
    5859:	00 00 00 
    585c:	48 89 c6             	mov    %rax,%rsi
    585f:	bf 01 00 00 00       	mov    $0x1,%edi
    5864:	b8 00 00 00 00       	mov    $0x0,%eax
    5869:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5870:	00 00 00 
    5873:	ff d2                	call   *%rdx
      write(fds[1], "x", 1);
    5875:	8b 45 ac             	mov    -0x54(%rbp),%eax
    5878:	48 b9 5e 75 00 00 00 	movabs $0x755e,%rcx
    587f:	00 00 00 
    5882:	ba 01 00 00 00       	mov    $0x1,%edx
    5887:	48 89 ce             	mov    %rcx,%rsi
    588a:	89 c7                	mov    %eax,%edi
    588c:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    5893:	00 00 00 
    5896:	ff d0                	call   *%rax
      // sit around until killed
      for(;;)
        sleep(1000);
    5898:	bf e8 03 00 00       	mov    $0x3e8,%edi
    589d:	48 b8 9a 67 00 00 00 	movabs $0x679a,%rax
    58a4:	00 00 00 
    58a7:	ff d0                	call   *%rax
    58a9:	eb ed                	jmp    5898 <sbrktest+0x5cd>
    }
    if(pids[i] != -1)
    58ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
    58ae:	48 98                	cltq
    58b0:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    58b4:	83 f8 ff             	cmp    $0xffffffff,%eax
    58b7:	74 20                	je     58d9 <sbrktest+0x60e>
      read(fds[0], &scratch, 1); // wait
    58b9:	8b 45 a8             	mov    -0x58(%rbp),%eax
    58bc:	48 8d 8d 7f ff ff ff 	lea    -0x81(%rbp),%rcx
    58c3:	ba 01 00 00 00       	mov    $0x1,%edx
    58c8:	48 89 ce             	mov    %rcx,%rsi
    58cb:	89 c7                	mov    %eax,%edi
    58cd:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    58d4:	00 00 00 
    58d7:	ff d0                	call   *%rax
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    58d9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    58dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
    58e0:	83 f8 09             	cmp    $0x9,%eax
    58e3:	0f 86 0e ff ff ff    	jbe    57f7 <sbrktest+0x52c>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate one here
  c = sbrk(4096);
    58e9:	bf 00 10 00 00       	mov    $0x1000,%edi
    58ee:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    58f5:	00 00 00 
    58f8:	ff d0                	call   *%rax
    58fa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    58fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    5905:	eb 3d                	jmp    5944 <sbrktest+0x679>
    if(pids[i] == -1)
    5907:	8b 45 f4             	mov    -0xc(%rbp),%eax
    590a:	48 98                	cltq
    590c:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    5910:	83 f8 ff             	cmp    $0xffffffff,%eax
    5913:	74 2a                	je     593f <sbrktest+0x674>
      continue;
    kill(pids[i],9);
    5915:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5918:	48 98                	cltq
    591a:	8b 44 85 80          	mov    -0x80(%rbp,%rax,4),%eax
    591e:	be 09 00 00 00       	mov    $0x9,%esi
    5923:	89 c7                	mov    %eax,%edi
    5925:	48 b8 fe 66 00 00 00 	movabs $0x66fe,%rax
    592c:	00 00 00 
    592f:	ff d0                	call   *%rax
    wait();
    5931:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    5938:	00 00 00 
    593b:	ff d0                	call   *%rax
    593d:	eb 01                	jmp    5940 <sbrktest+0x675>
      continue;
    593f:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5940:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    5944:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5947:	83 f8 09             	cmp    $0x9,%eax
    594a:	76 bb                	jbe    5907 <sbrktest+0x63c>
  }
  if(c == (char*)0xffffffff){ // ?
    594c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    5951:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
    5955:	75 19                	jne    5970 <sbrktest+0x6a5>
    failexit("failed sbrk leaked memory");
    5957:	48 b8 ca 84 00 00 00 	movabs $0x84ca,%rax
    595e:	00 00 00 
    5961:	48 89 c7             	mov    %rax,%rdi
    5964:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    596b:	00 00 00 
    596e:	ff d0                	call   *%rax
  }

  if(sbrk(0) > oldbrk)
    5970:	bf 00 00 00 00       	mov    $0x0,%edi
    5975:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    597c:	00 00 00 
    597f:	ff d0                	call   *%rax
    5981:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
    5985:	73 2a                	jae    59b1 <sbrktest+0x6e6>
    sbrk(-(sbrk(0) - oldbrk));
    5987:	bf 00 00 00 00       	mov    $0x0,%edi
    598c:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    5993:	00 00 00 
    5996:	ff d0                	call   *%rax
    5998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
    599c:	48 29 c2             	sub    %rax,%rdx
    599f:	48 89 d0             	mov    %rdx,%rax
    59a2:	48 89 c7             	mov    %rax,%rdi
    59a5:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    59ac:	00 00 00 
    59af:	ff d0                	call   *%rax

  printf(1, "sbrk test OK\n");
    59b1:	48 b8 e4 84 00 00 00 	movabs $0x84e4,%rax
    59b8:	00 00 00 
    59bb:	48 89 c6             	mov    %rax,%rsi
    59be:	bf 01 00 00 00       	mov    $0x1,%edi
    59c3:	b8 00 00 00 00       	mov    $0x0,%eax
    59c8:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    59cf:	00 00 00 
    59d2:	ff d2                	call   *%rdx
}
    59d4:	90                   	nop
    59d5:	c9                   	leave
    59d6:	c3                   	ret

00000000000059d7 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    59d7:	55                   	push   %rbp
    59d8:	48 89 e5             	mov    %rsp,%rbp
    59db:	48 83 ec 10          	sub    $0x10,%rsp
  int i;

  printf(1, "bss test\n");
    59df:	48 b8 f2 84 00 00 00 	movabs $0x84f2,%rax
    59e6:	00 00 00 
    59e9:	48 89 c6             	mov    %rax,%rsi
    59ec:	bf 01 00 00 00       	mov    $0x1,%edi
    59f1:	b8 00 00 00 00       	mov    $0x0,%eax
    59f6:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    59fd:	00 00 00 
    5a00:	ff d2                	call   *%rdx
  for(i = 0; i < sizeof(uninit); i++){
    5a02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    5a09:	eb 34                	jmp    5a3f <bsstest+0x68>
    if(uninit[i] != '\0'){
    5a0b:	48 ba a0 a7 00 00 00 	movabs $0xa7a0,%rdx
    5a12:	00 00 00 
    5a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5a18:	48 98                	cltq
    5a1a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    5a1e:	84 c0                	test   %al,%al
    5a20:	74 19                	je     5a3b <bsstest+0x64>
      failexit("bss test");
    5a22:	48 b8 fc 84 00 00 00 	movabs $0x84fc,%rax
    5a29:	00 00 00 
    5a2c:	48 89 c7             	mov    %rax,%rdi
    5a2f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5a36:	00 00 00 
    5a39:	ff d0                	call   *%rax
  for(i = 0; i < sizeof(uninit); i++){
    5a3b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5a42:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    5a47:	76 c2                	jbe    5a0b <bsstest+0x34>
    }
  }
  printf(1, "bss test ok\n");
    5a49:	48 b8 05 85 00 00 00 	movabs $0x8505,%rax
    5a50:	00 00 00 
    5a53:	48 89 c6             	mov    %rax,%rsi
    5a56:	bf 01 00 00 00       	mov    $0x1,%edi
    5a5b:	b8 00 00 00 00       	mov    $0x0,%eax
    5a60:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5a67:	00 00 00 
    5a6a:	ff d2                	call   *%rdx
}
    5a6c:	90                   	nop
    5a6d:	c9                   	leave
    5a6e:	c3                   	ret

0000000000005a6f <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    5a6f:	55                   	push   %rbp
    5a70:	48 89 e5             	mov    %rsp,%rbp
    5a73:	48 83 ec 10          	sub    $0x10,%rsp
  int pid, fd;

  unlink("bigarg-ok");
    5a77:	48 b8 12 85 00 00 00 	movabs $0x8512,%rax
    5a7e:	00 00 00 
    5a81:	48 89 c7             	mov    %rax,%rdi
    5a84:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    5a8b:	00 00 00 
    5a8e:	ff d0                	call   *%rax
  pid = fork();
    5a90:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    5a97:	00 00 00 
    5a9a:	ff d0                	call   *%rax
    5a9c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(pid == 0){
    5a9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5aa3:	0f 85 ef 00 00 00    	jne    5b98 <bigargtest+0x129>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    5aa9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    5ab0:	eb 21                	jmp    5ad3 <bigargtest+0x64>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    5ab2:	48 ba c0 ce 00 00 00 	movabs $0xcec0,%rdx
    5ab9:	00 00 00 
    5abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5abf:	48 98                	cltq
    5ac1:	48 b9 20 85 00 00 00 	movabs $0x8520,%rcx
    5ac8:	00 00 00 
    5acb:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
    for(i = 0; i < MAXARG-1; i++)
    5acf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5ad3:	83 7d fc 1e          	cmpl   $0x1e,-0x4(%rbp)
    5ad7:	7e d9                	jle    5ab2 <bigargtest+0x43>
    args[MAXARG-1] = 0;
    5ad9:	48 b8 c0 ce 00 00 00 	movabs $0xcec0,%rax
    5ae0:	00 00 00 
    5ae3:	48 c7 80 f8 00 00 00 	movq   $0x0,0xf8(%rax)
    5aea:	00 00 00 00 
    printf(1, "bigarg test\n");
    5aee:	48 b8 fd 85 00 00 00 	movabs $0x85fd,%rax
    5af5:	00 00 00 
    5af8:	48 89 c6             	mov    %rax,%rsi
    5afb:	bf 01 00 00 00       	mov    $0x1,%edi
    5b00:	b8 00 00 00 00       	mov    $0x0,%eax
    5b05:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5b0c:	00 00 00 
    5b0f:	ff d2                	call   *%rdx
    exec("echo", args);
    5b11:	48 ba c0 ce 00 00 00 	movabs $0xcec0,%rdx
    5b18:	00 00 00 
    5b1b:	48 b8 e0 70 00 00 00 	movabs $0x70e0,%rax
    5b22:	00 00 00 
    5b25:	48 89 d6             	mov    %rdx,%rsi
    5b28:	48 89 c7             	mov    %rax,%rdi
    5b2b:	48 b8 0b 67 00 00 00 	movabs $0x670b,%rax
    5b32:	00 00 00 
    5b35:	ff d0                	call   *%rax
    printf(1, "bigarg test ok\n");
    5b37:	48 b8 0a 86 00 00 00 	movabs $0x860a,%rax
    5b3e:	00 00 00 
    5b41:	48 89 c6             	mov    %rax,%rsi
    5b44:	bf 01 00 00 00       	mov    $0x1,%edi
    5b49:	b8 00 00 00 00       	mov    $0x0,%eax
    5b4e:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5b55:	00 00 00 
    5b58:	ff d2                	call   *%rdx
    fd = open("bigarg-ok", O_CREATE);
    5b5a:	48 b8 12 85 00 00 00 	movabs $0x8512,%rax
    5b61:	00 00 00 
    5b64:	be 00 02 00 00       	mov    $0x200,%esi
    5b69:	48 89 c7             	mov    %rax,%rdi
    5b6c:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    5b73:	00 00 00 
    5b76:	ff d0                	call   *%rax
    5b78:	89 45 f4             	mov    %eax,-0xc(%rbp)
    close(fd);
    5b7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5b7e:	89 c7                	mov    %eax,%edi
    5b80:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    5b87:	00 00 00 
    5b8a:	ff d0                	call   *%rax
    exit();
    5b8c:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    5b93:	00 00 00 
    5b96:	ff d0                	call   *%rax
  } else if(pid < 0){
    5b98:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5b9c:	79 19                	jns    5bb7 <bigargtest+0x148>
    failexit("bigargtest: fork");
    5b9e:	48 b8 1a 86 00 00 00 	movabs $0x861a,%rax
    5ba5:	00 00 00 
    5ba8:	48 89 c7             	mov    %rax,%rdi
    5bab:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5bb2:	00 00 00 
    5bb5:	ff d0                	call   *%rax
  }
  wait();
    5bb7:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    5bbe:	00 00 00 
    5bc1:	ff d0                	call   *%rax
  fd = open("bigarg-ok", 0);
    5bc3:	48 b8 12 85 00 00 00 	movabs $0x8512,%rax
    5bca:	00 00 00 
    5bcd:	be 00 00 00 00       	mov    $0x0,%esi
    5bd2:	48 89 c7             	mov    %rax,%rdi
    5bd5:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    5bdc:	00 00 00 
    5bdf:	ff d0                	call   *%rax
    5be1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(fd < 0){
    5be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    5be8:	79 19                	jns    5c03 <bigargtest+0x194>
    failexit("bigarg test");
    5bea:	48 b8 2b 86 00 00 00 	movabs $0x862b,%rax
    5bf1:	00 00 00 
    5bf4:	48 89 c7             	mov    %rax,%rdi
    5bf7:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    5bfe:	00 00 00 
    5c01:	ff d0                	call   *%rax
  }
  close(fd);
    5c03:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5c06:	89 c7                	mov    %eax,%edi
    5c08:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    5c0f:	00 00 00 
    5c12:	ff d0                	call   *%rax
  unlink("bigarg-ok");
    5c14:	48 b8 12 85 00 00 00 	movabs $0x8512,%rax
    5c1b:	00 00 00 
    5c1e:	48 89 c7             	mov    %rax,%rdi
    5c21:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    5c28:	00 00 00 
    5c2b:	ff d0                	call   *%rax
}
    5c2d:	90                   	nop
    5c2e:	c9                   	leave
    5c2f:	c3                   	ret

0000000000005c30 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    5c30:	55                   	push   %rbp
    5c31:	48 89 e5             	mov    %rsp,%rbp
    5c34:	48 83 ec 60          	sub    $0x60,%rsp
  int nfiles;
  int fsblocks = 0;
    5c38:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

  printf(1, "fsfull test\n");
    5c3f:	48 b8 37 86 00 00 00 	movabs $0x8637,%rax
    5c46:	00 00 00 
    5c49:	48 89 c6             	mov    %rax,%rsi
    5c4c:	bf 01 00 00 00       	mov    $0x1,%edi
    5c51:	b8 00 00 00 00       	mov    $0x0,%eax
    5c56:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5c5d:	00 00 00 
    5c60:	ff d2                	call   *%rdx

  for(nfiles = 0; ; nfiles++){
    5c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    char name[64];
    name[0] = 'f';
    5c69:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    5c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5c70:	48 63 d0             	movslq %eax,%rdx
    5c73:	48 69 d2 d3 4d 62 10 	imul   $0x10624dd3,%rdx,%rdx
    5c7a:	48 c1 ea 20          	shr    $0x20,%rdx
    5c7e:	c1 fa 06             	sar    $0x6,%edx
    5c81:	c1 f8 1f             	sar    $0x1f,%eax
    5c84:	29 c2                	sub    %eax,%edx
    5c86:	89 d0                	mov    %edx,%eax
    5c88:	83 c0 30             	add    $0x30,%eax
    5c8b:	88 45 a1             	mov    %al,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    5c8e:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5c91:	48 63 c2             	movslq %edx,%rax
    5c94:	48 69 c0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rax
    5c9b:	48 c1 e8 20          	shr    $0x20,%rax
    5c9f:	c1 f8 06             	sar    $0x6,%eax
    5ca2:	89 d1                	mov    %edx,%ecx
    5ca4:	c1 f9 1f             	sar    $0x1f,%ecx
    5ca7:	29 c8                	sub    %ecx,%eax
    5ca9:	69 c8 e8 03 00 00    	imul   $0x3e8,%eax,%ecx
    5caf:	89 d0                	mov    %edx,%eax
    5cb1:	29 c8                	sub    %ecx,%eax
    5cb3:	48 63 d0             	movslq %eax,%rdx
    5cb6:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    5cbd:	48 c1 ea 20          	shr    $0x20,%rdx
    5cc1:	c1 fa 05             	sar    $0x5,%edx
    5cc4:	c1 f8 1f             	sar    $0x1f,%eax
    5cc7:	29 c2                	sub    %eax,%edx
    5cc9:	89 d0                	mov    %edx,%eax
    5ccb:	83 c0 30             	add    $0x30,%eax
    5cce:	88 45 a2             	mov    %al,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    5cd1:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5cd4:	48 63 c2             	movslq %edx,%rax
    5cd7:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
    5cde:	48 c1 e8 20          	shr    $0x20,%rax
    5ce2:	c1 f8 05             	sar    $0x5,%eax
    5ce5:	89 d1                	mov    %edx,%ecx
    5ce7:	c1 f9 1f             	sar    $0x1f,%ecx
    5cea:	29 c8                	sub    %ecx,%eax
    5cec:	6b c8 64             	imul   $0x64,%eax,%ecx
    5cef:	89 d0                	mov    %edx,%eax
    5cf1:	29 c8                	sub    %ecx,%eax
    5cf3:	48 63 d0             	movslq %eax,%rdx
    5cf6:	48 69 d2 67 66 66 66 	imul   $0x66666667,%rdx,%rdx
    5cfd:	48 c1 ea 20          	shr    $0x20,%rdx
    5d01:	c1 fa 02             	sar    $0x2,%edx
    5d04:	c1 f8 1f             	sar    $0x1f,%eax
    5d07:	29 c2                	sub    %eax,%edx
    5d09:	89 d0                	mov    %edx,%eax
    5d0b:	83 c0 30             	add    $0x30,%eax
    5d0e:	88 45 a3             	mov    %al,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    5d11:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5d14:	48 63 c2             	movslq %edx,%rax
    5d17:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    5d1e:	48 c1 e8 20          	shr    $0x20,%rax
    5d22:	89 c1                	mov    %eax,%ecx
    5d24:	c1 f9 02             	sar    $0x2,%ecx
    5d27:	89 d0                	mov    %edx,%eax
    5d29:	c1 f8 1f             	sar    $0x1f,%eax
    5d2c:	29 c1                	sub    %eax,%ecx
    5d2e:	89 c8                	mov    %ecx,%eax
    5d30:	c1 e0 02             	shl    $0x2,%eax
    5d33:	01 c8                	add    %ecx,%eax
    5d35:	01 c0                	add    %eax,%eax
    5d37:	89 d1                	mov    %edx,%ecx
    5d39:	29 c1                	sub    %eax,%ecx
    5d3b:	89 c8                	mov    %ecx,%eax
    5d3d:	83 c0 30             	add    $0x30,%eax
    5d40:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    5d43:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    printf(1, "writing %s\n", name);
    5d47:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    5d4b:	48 b9 44 86 00 00 00 	movabs $0x8644,%rcx
    5d52:	00 00 00 
    5d55:	48 89 c2             	mov    %rax,%rdx
    5d58:	48 89 ce             	mov    %rcx,%rsi
    5d5b:	bf 01 00 00 00       	mov    $0x1,%edi
    5d60:	b8 00 00 00 00       	mov    $0x0,%eax
    5d65:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    5d6c:	00 00 00 
    5d6f:	ff d1                	call   *%rcx
    int fd = open(name, O_CREATE|O_RDWR);
    5d71:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    5d75:	be 02 02 00 00       	mov    $0x202,%esi
    5d7a:	48 89 c7             	mov    %rax,%rdi
    5d7d:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    5d84:	00 00 00 
    5d87:	ff d0                	call   *%rax
    5d89:	89 45 f0             	mov    %eax,-0x10(%rbp)
    if(fd < 0){
    5d8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
    5d90:	79 2f                	jns    5dc1 <fsfull+0x191>
      printf(1, "open %s failed\n", name);
    5d92:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    5d96:	48 b9 50 86 00 00 00 	movabs $0x8650,%rcx
    5d9d:	00 00 00 
    5da0:	48 89 c2             	mov    %rax,%rdx
    5da3:	48 89 ce             	mov    %rcx,%rsi
    5da6:	bf 01 00 00 00       	mov    $0x1,%edi
    5dab:	b8 00 00 00 00       	mov    $0x0,%eax
    5db0:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    5db7:	00 00 00 
    5dba:	ff d1                	call   *%rcx
      break;
    5dbc:	e9 8c 00 00 00       	jmp    5e4d <fsfull+0x21d>
    }
    int total = 0;
    5dc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    while(1){
      int cc = write(fd, buf, 512);
    5dc8:	48 b9 80 87 00 00 00 	movabs $0x8780,%rcx
    5dcf:	00 00 00 
    5dd2:	8b 45 f0             	mov    -0x10(%rbp),%eax
    5dd5:	ba 00 02 00 00       	mov    $0x200,%edx
    5dda:	48 89 ce             	mov    %rcx,%rsi
    5ddd:	89 c7                	mov    %eax,%edi
    5ddf:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    5de6:	00 00 00 
    5de9:	ff d0                	call   *%rax
    5deb:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if(cc < 512)
    5dee:	81 7d ec ff 01 00 00 	cmpl   $0x1ff,-0x14(%rbp)
    5df5:	7e 0c                	jle    5e03 <fsfull+0x1d3>
        break;
      total += cc;
    5df7:	8b 45 ec             	mov    -0x14(%rbp),%eax
    5dfa:	01 45 f4             	add    %eax,-0xc(%rbp)
      fsblocks++;
    5dfd:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    while(1){
    5e01:	eb c5                	jmp    5dc8 <fsfull+0x198>
        break;
    5e03:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    5e04:	8b 45 f4             	mov    -0xc(%rbp),%eax
    5e07:	48 b9 60 86 00 00 00 	movabs $0x8660,%rcx
    5e0e:	00 00 00 
    5e11:	89 c2                	mov    %eax,%edx
    5e13:	48 89 ce             	mov    %rcx,%rsi
    5e16:	bf 01 00 00 00       	mov    $0x1,%edi
    5e1b:	b8 00 00 00 00       	mov    $0x0,%eax
    5e20:	48 b9 be 69 00 00 00 	movabs $0x69be,%rcx
    5e27:	00 00 00 
    5e2a:	ff d1                	call   *%rcx
    close(fd);
    5e2c:	8b 45 f0             	mov    -0x10(%rbp),%eax
    5e2f:	89 c7                	mov    %eax,%edi
    5e31:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    5e38:	00 00 00 
    5e3b:	ff d0                	call   *%rax
    if(total == 0)
    5e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    5e41:	74 09                	je     5e4c <fsfull+0x21c>
  for(nfiles = 0; ; nfiles++){
    5e43:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    5e47:	e9 1d fe ff ff       	jmp    5c69 <fsfull+0x39>
      break;
    5e4c:	90                   	nop
  }

  while(nfiles >= 0){
    5e4d:	e9 f5 00 00 00       	jmp    5f47 <fsfull+0x317>
    char name[64];
    name[0] = 'f';
    5e52:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    5e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
    5e59:	48 63 d0             	movslq %eax,%rdx
    5e5c:	48 69 d2 d3 4d 62 10 	imul   $0x10624dd3,%rdx,%rdx
    5e63:	48 c1 ea 20          	shr    $0x20,%rdx
    5e67:	c1 fa 06             	sar    $0x6,%edx
    5e6a:	c1 f8 1f             	sar    $0x1f,%eax
    5e6d:	29 c2                	sub    %eax,%edx
    5e6f:	89 d0                	mov    %edx,%eax
    5e71:	83 c0 30             	add    $0x30,%eax
    5e74:	88 45 a1             	mov    %al,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    5e77:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5e7a:	48 63 c2             	movslq %edx,%rax
    5e7d:	48 69 c0 d3 4d 62 10 	imul   $0x10624dd3,%rax,%rax
    5e84:	48 c1 e8 20          	shr    $0x20,%rax
    5e88:	c1 f8 06             	sar    $0x6,%eax
    5e8b:	89 d1                	mov    %edx,%ecx
    5e8d:	c1 f9 1f             	sar    $0x1f,%ecx
    5e90:	29 c8                	sub    %ecx,%eax
    5e92:	69 c8 e8 03 00 00    	imul   $0x3e8,%eax,%ecx
    5e98:	89 d0                	mov    %edx,%eax
    5e9a:	29 c8                	sub    %ecx,%eax
    5e9c:	48 63 d0             	movslq %eax,%rdx
    5e9f:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
    5ea6:	48 c1 ea 20          	shr    $0x20,%rdx
    5eaa:	c1 fa 05             	sar    $0x5,%edx
    5ead:	c1 f8 1f             	sar    $0x1f,%eax
    5eb0:	29 c2                	sub    %eax,%edx
    5eb2:	89 d0                	mov    %edx,%eax
    5eb4:	83 c0 30             	add    $0x30,%eax
    5eb7:	88 45 a2             	mov    %al,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    5eba:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5ebd:	48 63 c2             	movslq %edx,%rax
    5ec0:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
    5ec7:	48 c1 e8 20          	shr    $0x20,%rax
    5ecb:	c1 f8 05             	sar    $0x5,%eax
    5ece:	89 d1                	mov    %edx,%ecx
    5ed0:	c1 f9 1f             	sar    $0x1f,%ecx
    5ed3:	29 c8                	sub    %ecx,%eax
    5ed5:	6b c8 64             	imul   $0x64,%eax,%ecx
    5ed8:	89 d0                	mov    %edx,%eax
    5eda:	29 c8                	sub    %ecx,%eax
    5edc:	48 63 d0             	movslq %eax,%rdx
    5edf:	48 69 d2 67 66 66 66 	imul   $0x66666667,%rdx,%rdx
    5ee6:	48 c1 ea 20          	shr    $0x20,%rdx
    5eea:	c1 fa 02             	sar    $0x2,%edx
    5eed:	c1 f8 1f             	sar    $0x1f,%eax
    5ef0:	29 c2                	sub    %eax,%edx
    5ef2:	89 d0                	mov    %edx,%eax
    5ef4:	83 c0 30             	add    $0x30,%eax
    5ef7:	88 45 a3             	mov    %al,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    5efa:	8b 55 fc             	mov    -0x4(%rbp),%edx
    5efd:	48 63 c2             	movslq %edx,%rax
    5f00:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
    5f07:	48 c1 e8 20          	shr    $0x20,%rax
    5f0b:	89 c1                	mov    %eax,%ecx
    5f0d:	c1 f9 02             	sar    $0x2,%ecx
    5f10:	89 d0                	mov    %edx,%eax
    5f12:	c1 f8 1f             	sar    $0x1f,%eax
    5f15:	29 c1                	sub    %eax,%ecx
    5f17:	89 c8                	mov    %ecx,%eax
    5f19:	c1 e0 02             	shl    $0x2,%eax
    5f1c:	01 c8                	add    %ecx,%eax
    5f1e:	01 c0                	add    %eax,%eax
    5f20:	89 d1                	mov    %edx,%ecx
    5f22:	29 c1                	sub    %eax,%ecx
    5f24:	89 c8                	mov    %ecx,%eax
    5f26:	83 c0 30             	add    $0x30,%eax
    5f29:	88 45 a4             	mov    %al,-0x5c(%rbp)
    name[5] = '\0';
    5f2c:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
    unlink(name);
    5f30:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
    5f34:	48 89 c7             	mov    %rax,%rdi
    5f37:	48 b8 32 67 00 00 00 	movabs $0x6732,%rax
    5f3e:	00 00 00 
    5f41:	ff d0                	call   *%rax
    nfiles--;
    5f43:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  while(nfiles >= 0){
    5f47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    5f4b:	0f 89 01 ff ff ff    	jns    5e52 <fsfull+0x222>
  }

  printf(1, "fsfull test finished\n");
    5f51:	48 b8 70 86 00 00 00 	movabs $0x8670,%rax
    5f58:	00 00 00 
    5f5b:	48 89 c6             	mov    %rax,%rsi
    5f5e:	bf 01 00 00 00       	mov    $0x1,%edi
    5f63:	b8 00 00 00 00       	mov    $0x0,%eax
    5f68:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5f6f:	00 00 00 
    5f72:	ff d2                	call   *%rdx
}
    5f74:	90                   	nop
    5f75:	c9                   	leave
    5f76:	c3                   	ret

0000000000005f77 <uio>:

void
uio()
{
    5f77:	55                   	push   %rbp
    5f78:	48 89 e5             	mov    %rsp,%rbp
    5f7b:	48 83 ec 10          	sub    $0x10,%rsp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    5f7f:	66 c7 45 fe 00 00    	movw   $0x0,-0x2(%rbp)
  uchar val = 0;
    5f85:	c6 45 fd 00          	movb   $0x0,-0x3(%rbp)
  int pid;

  printf(1, "uio test\n");
    5f89:	48 b8 86 86 00 00 00 	movabs $0x8686,%rax
    5f90:	00 00 00 
    5f93:	48 89 c6             	mov    %rax,%rsi
    5f96:	bf 01 00 00 00       	mov    $0x1,%edi
    5f9b:	b8 00 00 00 00       	mov    $0x0,%eax
    5fa0:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    5fa7:	00 00 00 
    5faa:	ff d2                	call   *%rdx
  pid = fork();
    5fac:	48 b8 a3 66 00 00 00 	movabs $0x66a3,%rax
    5fb3:	00 00 00 
    5fb6:	ff d0                	call   *%rax
    5fb8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(pid == 0){
    5fbb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    5fbf:	75 52                	jne    6013 <uio+0x9c>
    port = RTC_ADDR;
    5fc1:	66 c7 45 fe 70 00    	movw   $0x70,-0x2(%rbp)
    val = 0x09;  /* year */
    5fc7:	c6 45 fd 09          	movb   $0x9,-0x3(%rbp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    5fcb:	0f b6 45 fd          	movzbl -0x3(%rbp),%eax
    5fcf:	0f b7 55 fe          	movzwl -0x2(%rbp),%edx
    5fd3:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    5fd4:	66 c7 45 fe 71 00    	movw   $0x71,-0x2(%rbp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    5fda:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
    5fde:	89 c2                	mov    %eax,%edx
    5fe0:	ec                   	in     (%dx),%al
    5fe1:	88 45 fd             	mov    %al,-0x3(%rbp)
    printf(1, "uio test succeeded\n");
    5fe4:	48 b8 90 86 00 00 00 	movabs $0x8690,%rax
    5feb:	00 00 00 
    5fee:	48 89 c6             	mov    %rax,%rsi
    5ff1:	bf 01 00 00 00       	mov    $0x1,%edi
    5ff6:	b8 00 00 00 00       	mov    $0x0,%eax
    5ffb:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    6002:	00 00 00 
    6005:	ff d2                	call   *%rdx
    exit();
    6007:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    600e:	00 00 00 
    6011:	ff d0                	call   *%rax
  } else if(pid < 0){
    6013:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    6017:	79 19                	jns    6032 <uio+0xbb>
    failexit("fork");
    6019:	48 b8 6f 71 00 00 00 	movabs $0x716f,%rax
    6020:	00 00 00 
    6023:	48 89 c7             	mov    %rax,%rdi
    6026:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    602d:	00 00 00 
    6030:	ff d0                	call   *%rax
  }
  wait();
    6032:	48 b8 bd 66 00 00 00 	movabs $0x66bd,%rax
    6039:	00 00 00 
    603c:	ff d0                	call   *%rax
  printf(1, "uio test done\n");
    603e:	48 b8 a4 86 00 00 00 	movabs $0x86a4,%rax
    6045:	00 00 00 
    6048:	48 89 c6             	mov    %rax,%rsi
    604b:	bf 01 00 00 00       	mov    $0x1,%edi
    6050:	b8 00 00 00 00       	mov    $0x0,%eax
    6055:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    605c:	00 00 00 
    605f:	ff d2                	call   *%rdx
}
    6061:	90                   	nop
    6062:	c9                   	leave
    6063:	c3                   	ret

0000000000006064 <argptest>:

void argptest()
{
    6064:	55                   	push   %rbp
    6065:	48 89 e5             	mov    %rsp,%rbp
    6068:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  fd = open("init", O_RDONLY);
    606c:	48 b8 b3 86 00 00 00 	movabs $0x86b3,%rax
    6073:	00 00 00 
    6076:	be 00 00 00 00       	mov    $0x0,%esi
    607b:	48 89 c7             	mov    %rax,%rdi
    607e:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    6085:	00 00 00 
    6088:	ff d0                	call   *%rax
    608a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if (fd < 0) {
    608d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    6091:	79 19                	jns    60ac <argptest+0x48>
    failexit("open");
    6093:	48 b8 b8 86 00 00 00 	movabs $0x86b8,%rax
    609a:	00 00 00 
    609d:	48 89 c7             	mov    %rax,%rdi
    60a0:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    60a7:	00 00 00 
    60aa:	ff d0                	call   *%rax
  }
  read(fd, sbrk(0) - 1, -1);
    60ac:	bf 00 00 00 00       	mov    $0x0,%edi
    60b1:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    60b8:	00 00 00 
    60bb:	ff d0                	call   *%rax
    60bd:	48 8d 48 ff          	lea    -0x1(%rax),%rcx
    60c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    60c4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    60c9:	48 89 ce             	mov    %rcx,%rsi
    60cc:	89 c7                	mov    %eax,%edi
    60ce:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    60d5:	00 00 00 
    60d8:	ff d0                	call   *%rax
  close(fd);
    60da:	8b 45 fc             	mov    -0x4(%rbp),%eax
    60dd:	89 c7                	mov    %eax,%edi
    60df:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    60e6:	00 00 00 
    60e9:	ff d0                	call   *%rax
  printf(1, "arg test passed\n");
    60eb:	48 b8 bd 86 00 00 00 	movabs $0x86bd,%rax
    60f2:	00 00 00 
    60f5:	48 89 c6             	mov    %rax,%rsi
    60f8:	bf 01 00 00 00       	mov    $0x1,%edi
    60fd:	b8 00 00 00 00       	mov    $0x0,%eax
    6102:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    6109:	00 00 00 
    610c:	ff d2                	call   *%rdx
}
    610e:	90                   	nop
    610f:	c9                   	leave
    6110:	c3                   	ret

0000000000006111 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    6111:	55                   	push   %rbp
    6112:	48 89 e5             	mov    %rsp,%rbp
  randstate = randstate * 1664525 + 1013904223;
    6115:	48 b8 48 87 00 00 00 	movabs $0x8748,%rax
    611c:	00 00 00 
    611f:	48 8b 00             	mov    (%rax),%rax
    6122:	48 69 c0 0d 66 19 00 	imul   $0x19660d,%rax,%rax
    6129:	48 8d 90 5f f3 6e 3c 	lea    0x3c6ef35f(%rax),%rdx
    6130:	48 b8 48 87 00 00 00 	movabs $0x8748,%rax
    6137:	00 00 00 
    613a:	48 89 10             	mov    %rdx,(%rax)
  return randstate;
    613d:	48 b8 48 87 00 00 00 	movabs $0x8748,%rax
    6144:	00 00 00 
    6147:	48 8b 00             	mov    (%rax),%rax
}
    614a:	5d                   	pop    %rbp
    614b:	c3                   	ret

000000000000614c <main>:

int
main(int argc, char *argv[])
{
    614c:	55                   	push   %rbp
    614d:	48 89 e5             	mov    %rsp,%rbp
    6150:	48 83 ec 10          	sub    $0x10,%rsp
    6154:	89 7d fc             	mov    %edi,-0x4(%rbp)
    6157:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  printf(1, "usertests starting\n");
    615b:	48 b8 ce 86 00 00 00 	movabs $0x86ce,%rax
    6162:	00 00 00 
    6165:	48 89 c6             	mov    %rax,%rsi
    6168:	bf 01 00 00 00       	mov    $0x1,%edi
    616d:	b8 00 00 00 00       	mov    $0x0,%eax
    6172:	48 ba be 69 00 00 00 	movabs $0x69be,%rdx
    6179:	00 00 00 
    617c:	ff d2                	call   *%rdx

  if(open("usertests.ran", 0) >= 0){
    617e:	48 b8 e2 86 00 00 00 	movabs $0x86e2,%rax
    6185:	00 00 00 
    6188:	be 00 00 00 00       	mov    $0x0,%esi
    618d:	48 89 c7             	mov    %rax,%rdi
    6190:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    6197:	00 00 00 
    619a:	ff d0                	call   *%rax
    619c:	85 c0                	test   %eax,%eax
    619e:	78 19                	js     61b9 <main+0x6d>
    failexit("already ran user tests -- rebuild fs.img");
    61a0:	48 b8 f0 86 00 00 00 	movabs $0x86f0,%rax
    61a7:	00 00 00 
    61aa:	48 89 c7             	mov    %rax,%rdi
    61ad:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    61b4:	00 00 00 
    61b7:	ff d0                	call   *%rax
  }
  close(open("usertests.ran", O_CREATE));
    61b9:	48 b8 e2 86 00 00 00 	movabs $0x86e2,%rax
    61c0:	00 00 00 
    61c3:	be 00 02 00 00       	mov    $0x200,%esi
    61c8:	48 89 c7             	mov    %rax,%rdi
    61cb:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    61d2:	00 00 00 
    61d5:	ff d0                	call   *%rax
    61d7:	89 c7                	mov    %eax,%edi
    61d9:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    61e0:	00 00 00 
    61e3:	ff d0                	call   *%rax

  argptest();
    61e5:	48 b8 64 60 00 00 00 	movabs $0x6064,%rax
    61ec:	00 00 00 
    61ef:	ff d0                	call   *%rax
  createdelete();
    61f1:	48 b8 c3 2a 00 00 00 	movabs $0x2ac3,%rax
    61f8:	00 00 00 
    61fb:	ff d0                	call   *%rax
  linkunlink();
    61fd:	48 b8 3e 38 00 00 00 	movabs $0x383e,%rax
    6204:	00 00 00 
    6207:	ff d0                	call   *%rax
  concreate();
    6209:	48 b8 49 33 00 00 00 	movabs $0x3349,%rax
    6210:	00 00 00 
    6213:	ff d0                	call   *%rax
  fourfiles();
    6215:	48 b8 99 27 00 00 00 	movabs $0x2799,%rax
    621c:	00 00 00 
    621f:	ff d0                	call   *%rax
  sharedfd();
    6221:	48 b8 e8 24 00 00 00 	movabs $0x24e8,%rax
    6228:	00 00 00 
    622b:	ff d0                	call   *%rax

  bigargtest();
    622d:	48 b8 6f 5a 00 00 00 	movabs $0x5a6f,%rax
    6234:	00 00 00 
    6237:	ff d0                	call   *%rax
  bigwrite();
    6239:	48 b8 34 45 00 00 00 	movabs $0x4534,%rax
    6240:	00 00 00 
    6243:	ff d0                	call   *%rax
  bigargtest();
    6245:	48 b8 6f 5a 00 00 00 	movabs $0x5a6f,%rax
    624c:	00 00 00 
    624f:	ff d0                	call   *%rax
  bsstest();
    6251:	48 b8 d7 59 00 00 00 	movabs $0x59d7,%rax
    6258:	00 00 00 
    625b:	ff d0                	call   *%rax
  sbrktest();
    625d:	48 b8 cb 52 00 00 00 	movabs $0x52cb,%rax
    6264:	00 00 00 
    6267:	ff d0                	call   *%rax

  opentest();
    6269:	48 b8 04 14 00 00 00 	movabs $0x1404,%rax
    6270:	00 00 00 
    6273:	ff d0                	call   *%rax
  writetest();
    6275:	48 b8 e6 14 00 00 00 	movabs $0x14e6,%rax
    627c:	00 00 00 
    627f:	ff d0                	call   *%rax
  writetest1();
    6281:	48 b8 35 17 00 00 00 	movabs $0x1735,%rax
    6288:	00 00 00 
    628b:	ff d0                	call   *%rax
  createtest();
    628d:	48 b8 df 19 00 00 00 	movabs $0x19df,%rax
    6294:	00 00 00 
    6297:	ff d0                	call   *%rax

  openiputtest();
    6299:	48 b8 aa 12 00 00 00 	movabs $0x12aa,%rax
    62a0:	00 00 00 
    62a3:	ff d0                	call   *%rax
  exitiputtest();
    62a5:	48 b8 67 11 00 00 00 	movabs $0x1167,%rax
    62ac:	00 00 00 
    62af:	ff d0                	call   *%rax
  iputtest();
    62b1:	48 b8 42 10 00 00 00 	movabs $0x1042,%rax
    62b8:	00 00 00 
    62bb:	ff d0                	call   *%rax

  mem();
    62bd:	48 b8 58 23 00 00 00 	movabs $0x2358,%rax
    62c4:	00 00 00 
    62c7:	ff d0                	call   *%rax
  pipe1();
    62c9:	48 b8 f3 1d 00 00 00 	movabs $0x1df3,%rax
    62d0:	00 00 00 
    62d3:	ff d0                	call   *%rax
  preempt();
    62d5:	48 b8 59 20 00 00 00 	movabs $0x2059,%rax
    62dc:	00 00 00 
    62df:	ff d0                	call   *%rax
  exitwait();
    62e1:	48 b8 8f 22 00 00 00 	movabs $0x228f,%rax
    62e8:	00 00 00 
    62eb:	ff d0                	call   *%rax
  nullptrtest();
    62ed:	48 b8 03 1d 00 00 00 	movabs $0x1d03,%rax
    62f4:	00 00 00 
    62f7:	ff d0                	call   *%rax

  rmdot();
    62f9:	48 b8 15 4b 00 00 00 	movabs $0x4b15,%rax
    6300:	00 00 00 
    6303:	ff d0                	call   *%rax
  fourteen();
    6305:	48 b8 4a 49 00 00 00 	movabs $0x494a,%rax
    630c:	00 00 00 
    630f:	ff d0                	call   *%rax
  bigfile();
    6311:	48 b8 9e 46 00 00 00 	movabs $0x469e,%rax
    6318:	00 00 00 
    631b:	ff d0                	call   *%rax
  subdir();
    631d:	48 b8 c8 3b 00 00 00 	movabs $0x3bc8,%rax
    6324:	00 00 00 
    6327:	ff d0                	call   *%rax
  linktest();
    6329:	48 b8 29 30 00 00 00 	movabs $0x3029,%rax
    6330:	00 00 00 
    6333:	ff d0                	call   *%rax
  unlinkread();
    6335:	48 b8 c3 2d 00 00 00 	movabs $0x2dc3,%rax
    633c:	00 00 00 
    633f:	ff d0                	call   *%rax
  dirfile();
    6341:	48 b8 12 4d 00 00 00 	movabs $0x4d12,%rax
    6348:	00 00 00 
    634b:	ff d0                	call   *%rax
  iref();
    634d:	48 b8 01 50 00 00 00 	movabs $0x5001,%rax
    6354:	00 00 00 
    6357:	ff d0                	call   *%rax
  forktest();
    6359:	48 b8 b9 51 00 00 00 	movabs $0x51b9,%rax
    6360:	00 00 00 
    6363:	ff d0                	call   *%rax
  bigdir(); // slow
    6365:	48 b8 ef 39 00 00 00 	movabs $0x39ef,%rax
    636c:	00 00 00 
    636f:	ff d0                	call   *%rax
  uio();
    6371:	48 b8 77 5f 00 00 00 	movabs $0x5f77,%rax
    6378:	00 00 00 
    637b:	ff d0                	call   *%rax

  exectest(); // will exit
    637d:	48 b8 73 1c 00 00 00 	movabs $0x1c73,%rax
    6384:	00 00 00 
    6387:	ff d0                	call   *%rax

  exit();
    6389:	48 b8 b0 66 00 00 00 	movabs $0x66b0,%rax
    6390:	00 00 00 
    6393:	ff d0                	call   *%rax

0000000000006395 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    6395:	55                   	push   %rbp
    6396:	48 89 e5             	mov    %rsp,%rbp
    6399:	48 83 ec 10          	sub    $0x10,%rsp
    639d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    63a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
    63a4:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    63a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    63ab:	8b 55 f0             	mov    -0x10(%rbp),%edx
    63ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
    63b1:	48 89 ce             	mov    %rcx,%rsi
    63b4:	48 89 f7             	mov    %rsi,%rdi
    63b7:	89 d1                	mov    %edx,%ecx
    63b9:	fc                   	cld
    63ba:	f3 aa                	rep stos %al,(%rdi)
    63bc:	89 ca                	mov    %ecx,%edx
    63be:	48 89 fe             	mov    %rdi,%rsi
    63c1:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    63c5:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    63c8:	90                   	nop
    63c9:	c9                   	leave
    63ca:	c3                   	ret

00000000000063cb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    63cb:	55                   	push   %rbp
    63cc:	48 89 e5             	mov    %rsp,%rbp
    63cf:	48 83 ec 20          	sub    $0x20,%rsp
    63d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    63d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    63db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    63df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    63e3:	90                   	nop
    63e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    63e8:	48 8d 42 01          	lea    0x1(%rdx),%rax
    63ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    63f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    63f4:	48 8d 48 01          	lea    0x1(%rax),%rcx
    63f8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    63fc:	0f b6 12             	movzbl (%rdx),%edx
    63ff:	88 10                	mov    %dl,(%rax)
    6401:	0f b6 00             	movzbl (%rax),%eax
    6404:	84 c0                	test   %al,%al
    6406:	75 dc                	jne    63e4 <strcpy+0x19>
    ;
  return os;
    6408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    640c:	c9                   	leave
    640d:	c3                   	ret

000000000000640e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    640e:	55                   	push   %rbp
    640f:	48 89 e5             	mov    %rsp,%rbp
    6412:	48 83 ec 10          	sub    $0x10,%rsp
    6416:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    641a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    641e:	eb 0a                	jmp    642a <strcmp+0x1c>
    p++, q++;
    6420:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    6425:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    642a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    642e:	0f b6 00             	movzbl (%rax),%eax
    6431:	84 c0                	test   %al,%al
    6433:	74 12                	je     6447 <strcmp+0x39>
    6435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6439:	0f b6 10             	movzbl (%rax),%edx
    643c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6440:	0f b6 00             	movzbl (%rax),%eax
    6443:	38 c2                	cmp    %al,%dl
    6445:	74 d9                	je     6420 <strcmp+0x12>
  return (uchar)*p - (uchar)*q;
    6447:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    644b:	0f b6 00             	movzbl (%rax),%eax
    644e:	0f b6 d0             	movzbl %al,%edx
    6451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6455:	0f b6 00             	movzbl (%rax),%eax
    6458:	0f b6 c0             	movzbl %al,%eax
    645b:	29 c2                	sub    %eax,%edx
    645d:	89 d0                	mov    %edx,%eax
}
    645f:	c9                   	leave
    6460:	c3                   	ret

0000000000006461 <strlen>:

uint
strlen(char *s)
{
    6461:	55                   	push   %rbp
    6462:	48 89 e5             	mov    %rsp,%rbp
    6465:	48 83 ec 18          	sub    $0x18,%rsp
    6469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    646d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    6474:	eb 04                	jmp    647a <strlen+0x19>
    6476:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    647a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    647d:	48 63 d0             	movslq %eax,%rdx
    6480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6484:	48 01 d0             	add    %rdx,%rax
    6487:	0f b6 00             	movzbl (%rax),%eax
    648a:	84 c0                	test   %al,%al
    648c:	75 e8                	jne    6476 <strlen+0x15>
    ;
  return n;
    648e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    6491:	c9                   	leave
    6492:	c3                   	ret

0000000000006493 <memset>:

void*
memset(void *dst, int c, uint n)
{
    6493:	55                   	push   %rbp
    6494:	48 89 e5             	mov    %rsp,%rbp
    6497:	48 83 ec 10          	sub    $0x10,%rsp
    649b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    649f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    64a2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    64a5:	8b 55 f0             	mov    -0x10(%rbp),%edx
    64a8:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    64ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    64af:	89 ce                	mov    %ecx,%esi
    64b1:	48 89 c7             	mov    %rax,%rdi
    64b4:	48 b8 95 63 00 00 00 	movabs $0x6395,%rax
    64bb:	00 00 00 
    64be:	ff d0                	call   *%rax
  return dst;
    64c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    64c4:	c9                   	leave
    64c5:	c3                   	ret

00000000000064c6 <strchr>:

char*
strchr(const char *s, char c)
{
    64c6:	55                   	push   %rbp
    64c7:	48 89 e5             	mov    %rsp,%rbp
    64ca:	48 83 ec 10          	sub    $0x10,%rsp
    64ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    64d2:	89 f0                	mov    %esi,%eax
    64d4:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    64d7:	eb 17                	jmp    64f0 <strchr+0x2a>
    if(*s == c)
    64d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    64dd:	0f b6 00             	movzbl (%rax),%eax
    64e0:	38 45 f4             	cmp    %al,-0xc(%rbp)
    64e3:	75 06                	jne    64eb <strchr+0x25>
      return (char*)s;
    64e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    64e9:	eb 15                	jmp    6500 <strchr+0x3a>
  for(; *s; s++)
    64eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    64f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    64f4:	0f b6 00             	movzbl (%rax),%eax
    64f7:	84 c0                	test   %al,%al
    64f9:	75 de                	jne    64d9 <strchr+0x13>
  return 0;
    64fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    6500:	c9                   	leave
    6501:	c3                   	ret

0000000000006502 <gets>:

char*
gets(char *buf, int max)
{
    6502:	55                   	push   %rbp
    6503:	48 89 e5             	mov    %rsp,%rbp
    6506:	48 83 ec 20          	sub    $0x20,%rsp
    650a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    650e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    6511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    6518:	eb 4f                	jmp    6569 <gets+0x67>
    cc = read(0, &c, 1);
    651a:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    651e:	ba 01 00 00 00       	mov    $0x1,%edx
    6523:	48 89 c6             	mov    %rax,%rsi
    6526:	bf 00 00 00 00       	mov    $0x0,%edi
    652b:	48 b8 d7 66 00 00 00 	movabs $0x66d7,%rax
    6532:	00 00 00 
    6535:	ff d0                	call   *%rax
    6537:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    653a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    653e:	7e 36                	jle    6576 <gets+0x74>
      break;
    buf[i++] = c;
    6540:	8b 45 fc             	mov    -0x4(%rbp),%eax
    6543:	8d 50 01             	lea    0x1(%rax),%edx
    6546:	89 55 fc             	mov    %edx,-0x4(%rbp)
    6549:	48 63 d0             	movslq %eax,%rdx
    654c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6550:	48 01 c2             	add    %rax,%rdx
    6553:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    6557:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    6559:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    655d:	3c 0a                	cmp    $0xa,%al
    655f:	74 16                	je     6577 <gets+0x75>
    6561:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    6565:	3c 0d                	cmp    $0xd,%al
    6567:	74 0e                	je     6577 <gets+0x75>
  for(i=0; i+1 < max; ){
    6569:	8b 45 fc             	mov    -0x4(%rbp),%eax
    656c:	83 c0 01             	add    $0x1,%eax
    656f:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    6572:	7f a6                	jg     651a <gets+0x18>
    6574:	eb 01                	jmp    6577 <gets+0x75>
      break;
    6576:	90                   	nop
      break;
  }
  buf[i] = '\0';
    6577:	8b 45 fc             	mov    -0x4(%rbp),%eax
    657a:	48 63 d0             	movslq %eax,%rdx
    657d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6581:	48 01 d0             	add    %rdx,%rax
    6584:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    6587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    658b:	c9                   	leave
    658c:	c3                   	ret

000000000000658d <stat>:

int
stat(char *n, struct stat *st)
{
    658d:	55                   	push   %rbp
    658e:	48 89 e5             	mov    %rsp,%rbp
    6591:	48 83 ec 20          	sub    $0x20,%rsp
    6595:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    6599:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    659d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    65a1:	be 00 00 00 00       	mov    $0x0,%esi
    65a6:	48 89 c7             	mov    %rax,%rdi
    65a9:	48 b8 18 67 00 00 00 	movabs $0x6718,%rax
    65b0:	00 00 00 
    65b3:	ff d0                	call   *%rax
    65b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    65b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    65bc:	79 07                	jns    65c5 <stat+0x38>
    return -1;
    65be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    65c3:	eb 2f                	jmp    65f4 <stat+0x67>
  r = fstat(fd, st);
    65c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    65c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    65cc:	48 89 d6             	mov    %rdx,%rsi
    65cf:	89 c7                	mov    %eax,%edi
    65d1:	48 b8 3f 67 00 00 00 	movabs $0x673f,%rax
    65d8:	00 00 00 
    65db:	ff d0                	call   *%rax
    65dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    65e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    65e3:	89 c7                	mov    %eax,%edi
    65e5:	48 b8 f1 66 00 00 00 	movabs $0x66f1,%rax
    65ec:	00 00 00 
    65ef:	ff d0                	call   *%rax
  return r;
    65f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    65f4:	c9                   	leave
    65f5:	c3                   	ret

00000000000065f6 <atoi>:

int
atoi(const char *s)
{
    65f6:	55                   	push   %rbp
    65f7:	48 89 e5             	mov    %rsp,%rbp
    65fa:	48 83 ec 18          	sub    $0x18,%rsp
    65fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    6602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    6609:	eb 28                	jmp    6633 <atoi+0x3d>
    n = n*10 + *s++ - '0';
    660b:	8b 55 fc             	mov    -0x4(%rbp),%edx
    660e:	89 d0                	mov    %edx,%eax
    6610:	c1 e0 02             	shl    $0x2,%eax
    6613:	01 d0                	add    %edx,%eax
    6615:	01 c0                	add    %eax,%eax
    6617:	89 c1                	mov    %eax,%ecx
    6619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    661d:	48 8d 50 01          	lea    0x1(%rax),%rdx
    6621:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    6625:	0f b6 00             	movzbl (%rax),%eax
    6628:	0f be c0             	movsbl %al,%eax
    662b:	01 c8                	add    %ecx,%eax
    662d:	83 e8 30             	sub    $0x30,%eax
    6630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    6633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6637:	0f b6 00             	movzbl (%rax),%eax
    663a:	3c 2f                	cmp    $0x2f,%al
    663c:	7e 0b                	jle    6649 <atoi+0x53>
    663e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6642:	0f b6 00             	movzbl (%rax),%eax
    6645:	3c 39                	cmp    $0x39,%al
    6647:	7e c2                	jle    660b <atoi+0x15>
  return n;
    6649:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    664c:	c9                   	leave
    664d:	c3                   	ret

000000000000664e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    664e:	55                   	push   %rbp
    664f:	48 89 e5             	mov    %rsp,%rbp
    6652:	48 83 ec 28          	sub    $0x28,%rsp
    6656:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    665a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    665e:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    6661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6665:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    6669:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    666d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    6671:	eb 1d                	jmp    6690 <memmove+0x42>
    *dst++ = *src++;
    6673:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    6677:	48 8d 42 01          	lea    0x1(%rdx),%rax
    667b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    667f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6683:	48 8d 48 01          	lea    0x1(%rax),%rcx
    6687:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    668b:	0f b6 12             	movzbl (%rdx),%edx
    668e:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    6690:	8b 45 dc             	mov    -0x24(%rbp),%eax
    6693:	8d 50 ff             	lea    -0x1(%rax),%edx
    6696:	89 55 dc             	mov    %edx,-0x24(%rbp)
    6699:	85 c0                	test   %eax,%eax
    669b:	7f d6                	jg     6673 <memmove+0x25>
  return vdst;
    669d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    66a1:	c9                   	leave
    66a2:	c3                   	ret

00000000000066a3 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    66a3:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    66aa:	49 89 ca             	mov    %rcx,%r10
    66ad:	0f 05                	syscall
    66af:	c3                   	ret

00000000000066b0 <exit>:
SYSCALL(exit)
    66b0:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    66b7:	49 89 ca             	mov    %rcx,%r10
    66ba:	0f 05                	syscall
    66bc:	c3                   	ret

00000000000066bd <wait>:
SYSCALL(wait)
    66bd:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    66c4:	49 89 ca             	mov    %rcx,%r10
    66c7:	0f 05                	syscall
    66c9:	c3                   	ret

00000000000066ca <pipe>:
SYSCALL(pipe)
    66ca:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    66d1:	49 89 ca             	mov    %rcx,%r10
    66d4:	0f 05                	syscall
    66d6:	c3                   	ret

00000000000066d7 <read>:
SYSCALL(read)
    66d7:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    66de:	49 89 ca             	mov    %rcx,%r10
    66e1:	0f 05                	syscall
    66e3:	c3                   	ret

00000000000066e4 <write>:
SYSCALL(write)
    66e4:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    66eb:	49 89 ca             	mov    %rcx,%r10
    66ee:	0f 05                	syscall
    66f0:	c3                   	ret

00000000000066f1 <close>:
SYSCALL(close)
    66f1:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    66f8:	49 89 ca             	mov    %rcx,%r10
    66fb:	0f 05                	syscall
    66fd:	c3                   	ret

00000000000066fe <kill>:
SYSCALL(kill)
    66fe:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    6705:	49 89 ca             	mov    %rcx,%r10
    6708:	0f 05                	syscall
    670a:	c3                   	ret

000000000000670b <exec>:
SYSCALL(exec)
    670b:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    6712:	49 89 ca             	mov    %rcx,%r10
    6715:	0f 05                	syscall
    6717:	c3                   	ret

0000000000006718 <open>:
SYSCALL(open)
    6718:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    671f:	49 89 ca             	mov    %rcx,%r10
    6722:	0f 05                	syscall
    6724:	c3                   	ret

0000000000006725 <mknod>:
SYSCALL(mknod)
    6725:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    672c:	49 89 ca             	mov    %rcx,%r10
    672f:	0f 05                	syscall
    6731:	c3                   	ret

0000000000006732 <unlink>:
SYSCALL(unlink)
    6732:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    6739:	49 89 ca             	mov    %rcx,%r10
    673c:	0f 05                	syscall
    673e:	c3                   	ret

000000000000673f <fstat>:
SYSCALL(fstat)
    673f:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    6746:	49 89 ca             	mov    %rcx,%r10
    6749:	0f 05                	syscall
    674b:	c3                   	ret

000000000000674c <link>:
SYSCALL(link)
    674c:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    6753:	49 89 ca             	mov    %rcx,%r10
    6756:	0f 05                	syscall
    6758:	c3                   	ret

0000000000006759 <mkdir>:
SYSCALL(mkdir)
    6759:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    6760:	49 89 ca             	mov    %rcx,%r10
    6763:	0f 05                	syscall
    6765:	c3                   	ret

0000000000006766 <chdir>:
SYSCALL(chdir)
    6766:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    676d:	49 89 ca             	mov    %rcx,%r10
    6770:	0f 05                	syscall
    6772:	c3                   	ret

0000000000006773 <dup>:
SYSCALL(dup)
    6773:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    677a:	49 89 ca             	mov    %rcx,%r10
    677d:	0f 05                	syscall
    677f:	c3                   	ret

0000000000006780 <getpid>:
SYSCALL(getpid)
    6780:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    6787:	49 89 ca             	mov    %rcx,%r10
    678a:	0f 05                	syscall
    678c:	c3                   	ret

000000000000678d <sbrk>:
SYSCALL(sbrk)
    678d:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    6794:	49 89 ca             	mov    %rcx,%r10
    6797:	0f 05                	syscall
    6799:	c3                   	ret

000000000000679a <sleep>:
SYSCALL(sleep)
    679a:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    67a1:	49 89 ca             	mov    %rcx,%r10
    67a4:	0f 05                	syscall
    67a6:	c3                   	ret

00000000000067a7 <uptime>:
SYSCALL(uptime)
    67a7:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    67ae:	49 89 ca             	mov    %rcx,%r10
    67b1:	0f 05                	syscall
    67b3:	c3                   	ret

00000000000067b4 <alarm>:

SYSCALL(alarm)
    67b4:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    67bb:	49 89 ca             	mov    %rcx,%r10
    67be:	0f 05                	syscall
    67c0:	c3                   	ret

00000000000067c1 <signal>:
SYSCALL(signal)
    67c1:	48 c7 c0 17 00 00 00 	mov    $0x17,%rax
    67c8:	49 89 ca             	mov    %rcx,%r10
    67cb:	0f 05                	syscall
    67cd:	c3                   	ret

00000000000067ce <sigret>:
SYSCALL(sigret)
    67ce:	48 c7 c0 18 00 00 00 	mov    $0x18,%rax
    67d5:	49 89 ca             	mov    %rcx,%r10
    67d8:	0f 05                	syscall
    67da:	c3                   	ret

00000000000067db <fgproc>:
SYSCALL(fgproc)
    67db:	48 c7 c0 19 00 00 00 	mov    $0x19,%rax
    67e2:	49 89 ca             	mov    %rcx,%r10
    67e5:	0f 05                	syscall
    67e7:	c3                   	ret

00000000000067e8 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    67e8:	55                   	push   %rbp
    67e9:	48 89 e5             	mov    %rsp,%rbp
    67ec:	48 83 ec 10          	sub    $0x10,%rsp
    67f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
    67f3:	89 f0                	mov    %esi,%eax
    67f5:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    67f8:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    67fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    67ff:	ba 01 00 00 00       	mov    $0x1,%edx
    6804:	48 89 ce             	mov    %rcx,%rsi
    6807:	89 c7                	mov    %eax,%edi
    6809:	48 b8 e4 66 00 00 00 	movabs $0x66e4,%rax
    6810:	00 00 00 
    6813:	ff d0                	call   *%rax
}
    6815:	90                   	nop
    6816:	c9                   	leave
    6817:	c3                   	ret

0000000000006818 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    6818:	55                   	push   %rbp
    6819:	48 89 e5             	mov    %rsp,%rbp
    681c:	48 83 ec 20          	sub    $0x20,%rsp
    6820:	89 7d ec             	mov    %edi,-0x14(%rbp)
    6823:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    6827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    682e:	eb 35                	jmp    6865 <print_x64+0x4d>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    6830:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    6834:	48 c1 e8 3c          	shr    $0x3c,%rax
    6838:	48 ba 50 87 00 00 00 	movabs $0x8750,%rdx
    683f:	00 00 00 
    6842:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    6846:	0f be d0             	movsbl %al,%edx
    6849:	8b 45 ec             	mov    -0x14(%rbp),%eax
    684c:	89 d6                	mov    %edx,%esi
    684e:	89 c7                	mov    %eax,%edi
    6850:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    6857:	00 00 00 
    685a:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    685c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    6860:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    6865:	8b 45 fc             	mov    -0x4(%rbp),%eax
    6868:	83 f8 0f             	cmp    $0xf,%eax
    686b:	76 c3                	jbe    6830 <print_x64+0x18>
}
    686d:	90                   	nop
    686e:	90                   	nop
    686f:	c9                   	leave
    6870:	c3                   	ret

0000000000006871 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    6871:	55                   	push   %rbp
    6872:	48 89 e5             	mov    %rsp,%rbp
    6875:	48 83 ec 20          	sub    $0x20,%rsp
    6879:	89 7d ec             	mov    %edi,-0x14(%rbp)
    687c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    687f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    6886:	eb 36                	jmp    68be <print_x32+0x4d>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    6888:	8b 45 e8             	mov    -0x18(%rbp),%eax
    688b:	c1 e8 1c             	shr    $0x1c,%eax
    688e:	89 c2                	mov    %eax,%edx
    6890:	48 b8 50 87 00 00 00 	movabs $0x8750,%rax
    6897:	00 00 00 
    689a:	89 d2                	mov    %edx,%edx
    689c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    68a0:	0f be d0             	movsbl %al,%edx
    68a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    68a6:	89 d6                	mov    %edx,%esi
    68a8:	89 c7                	mov    %eax,%edi
    68aa:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    68b1:	00 00 00 
    68b4:	ff d0                	call   *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    68b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    68ba:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    68be:	8b 45 fc             	mov    -0x4(%rbp),%eax
    68c1:	83 f8 07             	cmp    $0x7,%eax
    68c4:	76 c2                	jbe    6888 <print_x32+0x17>
}
    68c6:	90                   	nop
    68c7:	90                   	nop
    68c8:	c9                   	leave
    68c9:	c3                   	ret

00000000000068ca <print_d>:

  static void
print_d(int fd, int v)
{
    68ca:	55                   	push   %rbp
    68cb:	48 89 e5             	mov    %rsp,%rbp
    68ce:	48 83 ec 30          	sub    $0x30,%rsp
    68d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
    68d5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    68d8:	8b 45 d8             	mov    -0x28(%rbp),%eax
    68db:	48 98                	cltq
    68dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    68e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    68e5:	79 04                	jns    68eb <print_d+0x21>
    x = -x;
    68e7:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    68eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    68f2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    68f6:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    68fd:	66 66 66 
    6900:	48 89 c8             	mov    %rcx,%rax
    6903:	48 f7 ea             	imul   %rdx
    6906:	48 c1 fa 02          	sar    $0x2,%rdx
    690a:	48 89 c8             	mov    %rcx,%rax
    690d:	48 c1 f8 3f          	sar    $0x3f,%rax
    6911:	48 29 c2             	sub    %rax,%rdx
    6914:	48 89 d0             	mov    %rdx,%rax
    6917:	48 c1 e0 02          	shl    $0x2,%rax
    691b:	48 01 d0             	add    %rdx,%rax
    691e:	48 01 c0             	add    %rax,%rax
    6921:	48 29 c1             	sub    %rax,%rcx
    6924:	48 89 ca             	mov    %rcx,%rdx
    6927:	8b 45 f4             	mov    -0xc(%rbp),%eax
    692a:	8d 48 01             	lea    0x1(%rax),%ecx
    692d:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    6930:	48 b9 50 87 00 00 00 	movabs $0x8750,%rcx
    6937:	00 00 00 
    693a:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    693e:	48 98                	cltq
    6940:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    6944:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    6948:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    694f:	66 66 66 
    6952:	48 89 c8             	mov    %rcx,%rax
    6955:	48 f7 ea             	imul   %rdx
    6958:	48 89 d0             	mov    %rdx,%rax
    695b:	48 c1 f8 02          	sar    $0x2,%rax
    695f:	48 c1 f9 3f          	sar    $0x3f,%rcx
    6963:	48 89 ca             	mov    %rcx,%rdx
    6966:	48 29 d0             	sub    %rdx,%rax
    6969:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    696d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    6972:	0f 85 7a ff ff ff    	jne    68f2 <print_d+0x28>

  if (v < 0)
    6978:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    697c:	79 32                	jns    69b0 <print_d+0xe6>
    buf[i++] = '-';
    697e:	8b 45 f4             	mov    -0xc(%rbp),%eax
    6981:	8d 50 01             	lea    0x1(%rax),%edx
    6984:	89 55 f4             	mov    %edx,-0xc(%rbp)
    6987:	48 98                	cltq
    6989:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    698e:	eb 20                	jmp    69b0 <print_d+0xe6>
    putc(fd, buf[i]);
    6990:	8b 45 f4             	mov    -0xc(%rbp),%eax
    6993:	48 98                	cltq
    6995:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    699a:	0f be d0             	movsbl %al,%edx
    699d:	8b 45 dc             	mov    -0x24(%rbp),%eax
    69a0:	89 d6                	mov    %edx,%esi
    69a2:	89 c7                	mov    %eax,%edi
    69a4:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    69ab:	00 00 00 
    69ae:	ff d0                	call   *%rax
  while (--i >= 0)
    69b0:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    69b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    69b8:	79 d6                	jns    6990 <print_d+0xc6>
}
    69ba:	90                   	nop
    69bb:	90                   	nop
    69bc:	c9                   	leave
    69bd:	c3                   	ret

00000000000069be <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    69be:	55                   	push   %rbp
    69bf:	48 89 e5             	mov    %rsp,%rbp
    69c2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    69c9:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    69cf:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    69d6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    69dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    69e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    69eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    69f2:	84 c0                	test   %al,%al
    69f4:	74 20                	je     6a16 <printf+0x58>
    69f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    69fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    69fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    6a02:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    6a06:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    6a0a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    6a0e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    6a12:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    6a16:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    6a1d:	00 00 00 
    6a20:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    6a27:	00 00 00 
    6a2a:	48 8d 45 10          	lea    0x10(%rbp),%rax
    6a2e:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    6a35:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    6a3c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    6a43:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    6a4a:	00 00 00 
    6a4d:	e9 60 03 00 00       	jmp    6db2 <printf+0x3f4>
    if (c != '%') {
    6a52:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    6a59:	74 24                	je     6a7f <printf+0xc1>
      putc(fd, c);
    6a5b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    6a61:	0f be d0             	movsbl %al,%edx
    6a64:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6a6a:	89 d6                	mov    %edx,%esi
    6a6c:	89 c7                	mov    %eax,%edi
    6a6e:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    6a75:	00 00 00 
    6a78:	ff d0                	call   *%rax
      continue;
    6a7a:	e9 2c 03 00 00       	jmp    6dab <printf+0x3ed>
    }
    c = fmt[++i] & 0xff;
    6a7f:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    6a86:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    6a8c:	48 63 d0             	movslq %eax,%rdx
    6a8f:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    6a96:	48 01 d0             	add    %rdx,%rax
    6a99:	0f b6 00             	movzbl (%rax),%eax
    6a9c:	0f be c0             	movsbl %al,%eax
    6a9f:	25 ff 00 00 00       	and    $0xff,%eax
    6aa4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    6aaa:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    6ab1:	0f 84 2e 03 00 00    	je     6de5 <printf+0x427>
      break;
    switch(c) {
    6ab7:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    6abe:	0f 84 32 01 00 00    	je     6bf6 <printf+0x238>
    6ac4:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    6acb:	0f 8f a1 02 00 00    	jg     6d72 <printf+0x3b4>
    6ad1:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    6ad8:	0f 84 d4 01 00 00    	je     6cb2 <printf+0x2f4>
    6ade:	83 bd 3c ff ff ff 73 	cmpl   $0x73,-0xc4(%rbp)
    6ae5:	0f 8f 87 02 00 00    	jg     6d72 <printf+0x3b4>
    6aeb:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    6af2:	0f 84 5b 01 00 00    	je     6c53 <printf+0x295>
    6af8:	83 bd 3c ff ff ff 70 	cmpl   $0x70,-0xc4(%rbp)
    6aff:	0f 8f 6d 02 00 00    	jg     6d72 <printf+0x3b4>
    6b05:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    6b0c:	0f 84 87 00 00 00    	je     6b99 <printf+0x1db>
    6b12:	83 bd 3c ff ff ff 64 	cmpl   $0x64,-0xc4(%rbp)
    6b19:	0f 8f 53 02 00 00    	jg     6d72 <printf+0x3b4>
    6b1f:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    6b26:	0f 84 2b 02 00 00    	je     6d57 <printf+0x399>
    6b2c:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    6b33:	0f 85 39 02 00 00    	jne    6d72 <printf+0x3b4>
    case 'c':
      putc(fd, va_arg(ap, int));
    6b39:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6b3f:	83 f8 2f             	cmp    $0x2f,%eax
    6b42:	77 23                	ja     6b67 <printf+0x1a9>
    6b44:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    6b4b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6b51:	89 d2                	mov    %edx,%edx
    6b53:	48 01 d0             	add    %rdx,%rax
    6b56:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6b5c:	83 c2 08             	add    $0x8,%edx
    6b5f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    6b65:	eb 12                	jmp    6b79 <printf+0x1bb>
    6b67:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    6b6e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    6b72:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    6b79:	8b 00                	mov    (%rax),%eax
    6b7b:	0f be d0             	movsbl %al,%edx
    6b7e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6b84:	89 d6                	mov    %edx,%esi
    6b86:	89 c7                	mov    %eax,%edi
    6b88:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    6b8f:	00 00 00 
    6b92:	ff d0                	call   *%rax
      break;
    6b94:	e9 12 02 00 00       	jmp    6dab <printf+0x3ed>
    case 'd':
      print_d(fd, va_arg(ap, int));
    6b99:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6b9f:	83 f8 2f             	cmp    $0x2f,%eax
    6ba2:	77 23                	ja     6bc7 <printf+0x209>
    6ba4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    6bab:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6bb1:	89 d2                	mov    %edx,%edx
    6bb3:	48 01 d0             	add    %rdx,%rax
    6bb6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6bbc:	83 c2 08             	add    $0x8,%edx
    6bbf:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    6bc5:	eb 12                	jmp    6bd9 <printf+0x21b>
    6bc7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    6bce:	48 8d 50 08          	lea    0x8(%rax),%rdx
    6bd2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    6bd9:	8b 10                	mov    (%rax),%edx
    6bdb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6be1:	89 d6                	mov    %edx,%esi
    6be3:	89 c7                	mov    %eax,%edi
    6be5:	48 b8 ca 68 00 00 00 	movabs $0x68ca,%rax
    6bec:	00 00 00 
    6bef:	ff d0                	call   *%rax
      break;
    6bf1:	e9 b5 01 00 00       	jmp    6dab <printf+0x3ed>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    6bf6:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6bfc:	83 f8 2f             	cmp    $0x2f,%eax
    6bff:	77 23                	ja     6c24 <printf+0x266>
    6c01:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    6c08:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6c0e:	89 d2                	mov    %edx,%edx
    6c10:	48 01 d0             	add    %rdx,%rax
    6c13:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6c19:	83 c2 08             	add    $0x8,%edx
    6c1c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    6c22:	eb 12                	jmp    6c36 <printf+0x278>
    6c24:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    6c2b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    6c2f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    6c36:	8b 10                	mov    (%rax),%edx
    6c38:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6c3e:	89 d6                	mov    %edx,%esi
    6c40:	89 c7                	mov    %eax,%edi
    6c42:	48 b8 71 68 00 00 00 	movabs $0x6871,%rax
    6c49:	00 00 00 
    6c4c:	ff d0                	call   *%rax
      break;
    6c4e:	e9 58 01 00 00       	jmp    6dab <printf+0x3ed>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    6c53:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6c59:	83 f8 2f             	cmp    $0x2f,%eax
    6c5c:	77 23                	ja     6c81 <printf+0x2c3>
    6c5e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    6c65:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6c6b:	89 d2                	mov    %edx,%edx
    6c6d:	48 01 d0             	add    %rdx,%rax
    6c70:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6c76:	83 c2 08             	add    $0x8,%edx
    6c79:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    6c7f:	eb 12                	jmp    6c93 <printf+0x2d5>
    6c81:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    6c88:	48 8d 50 08          	lea    0x8(%rax),%rdx
    6c8c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    6c93:	48 8b 10             	mov    (%rax),%rdx
    6c96:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6c9c:	48 89 d6             	mov    %rdx,%rsi
    6c9f:	89 c7                	mov    %eax,%edi
    6ca1:	48 b8 18 68 00 00 00 	movabs $0x6818,%rax
    6ca8:	00 00 00 
    6cab:	ff d0                	call   *%rax
      break;
    6cad:	e9 f9 00 00 00       	jmp    6dab <printf+0x3ed>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    6cb2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    6cb8:	83 f8 2f             	cmp    $0x2f,%eax
    6cbb:	77 23                	ja     6ce0 <printf+0x322>
    6cbd:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    6cc4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6cca:	89 d2                	mov    %edx,%edx
    6ccc:	48 01 d0             	add    %rdx,%rax
    6ccf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    6cd5:	83 c2 08             	add    $0x8,%edx
    6cd8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    6cde:	eb 12                	jmp    6cf2 <printf+0x334>
    6ce0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    6ce7:	48 8d 50 08          	lea    0x8(%rax),%rdx
    6ceb:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    6cf2:	48 8b 00             	mov    (%rax),%rax
    6cf5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    6cfc:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    6d03:	00 
    6d04:	75 41                	jne    6d47 <printf+0x389>
        s = "(null)";
    6d06:	48 b8 19 87 00 00 00 	movabs $0x8719,%rax
    6d0d:	00 00 00 
    6d10:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    6d17:	eb 2e                	jmp    6d47 <printf+0x389>
        putc(fd, *(s++));
    6d19:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    6d20:	48 8d 50 01          	lea    0x1(%rax),%rdx
    6d24:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    6d2b:	0f b6 00             	movzbl (%rax),%eax
    6d2e:	0f be d0             	movsbl %al,%edx
    6d31:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6d37:	89 d6                	mov    %edx,%esi
    6d39:	89 c7                	mov    %eax,%edi
    6d3b:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    6d42:	00 00 00 
    6d45:	ff d0                	call   *%rax
      while (*s)
    6d47:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    6d4e:	0f b6 00             	movzbl (%rax),%eax
    6d51:	84 c0                	test   %al,%al
    6d53:	75 c4                	jne    6d19 <printf+0x35b>
      break;
    6d55:	eb 54                	jmp    6dab <printf+0x3ed>
    case '%':
      putc(fd, '%');
    6d57:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6d5d:	be 25 00 00 00       	mov    $0x25,%esi
    6d62:	89 c7                	mov    %eax,%edi
    6d64:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    6d6b:	00 00 00 
    6d6e:	ff d0                	call   *%rax
      break;
    6d70:	eb 39                	jmp    6dab <printf+0x3ed>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    6d72:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6d78:	be 25 00 00 00       	mov    $0x25,%esi
    6d7d:	89 c7                	mov    %eax,%edi
    6d7f:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    6d86:	00 00 00 
    6d89:	ff d0                	call   *%rax
      putc(fd, c);
    6d8b:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    6d91:	0f be d0             	movsbl %al,%edx
    6d94:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    6d9a:	89 d6                	mov    %edx,%esi
    6d9c:	89 c7                	mov    %eax,%edi
    6d9e:	48 b8 e8 67 00 00 00 	movabs $0x67e8,%rax
    6da5:	00 00 00 
    6da8:	ff d0                	call   *%rax
      break;
    6daa:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    6dab:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    6db2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    6db8:	48 63 d0             	movslq %eax,%rdx
    6dbb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    6dc2:	48 01 d0             	add    %rdx,%rax
    6dc5:	0f b6 00             	movzbl (%rax),%eax
    6dc8:	0f be c0             	movsbl %al,%eax
    6dcb:	25 ff 00 00 00       	and    $0xff,%eax
    6dd0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    6dd6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    6ddd:	0f 85 6f fc ff ff    	jne    6a52 <printf+0x94>
    }
  }
}
    6de3:	eb 01                	jmp    6de6 <printf+0x428>
      break;
    6de5:	90                   	nop
}
    6de6:	90                   	nop
    6de7:	c9                   	leave
    6de8:	c3                   	ret

0000000000006de9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6de9:	55                   	push   %rbp
    6dea:	48 89 e5             	mov    %rsp,%rbp
    6ded:	48 83 ec 18          	sub    $0x18,%rsp
    6df1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    6df9:	48 83 e8 10          	sub    $0x10,%rax
    6dfd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6e01:	48 b8 d0 cf 00 00 00 	movabs $0xcfd0,%rax
    6e08:	00 00 00 
    6e0b:	48 8b 00             	mov    (%rax),%rax
    6e0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    6e12:	eb 2f                	jmp    6e43 <free+0x5a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6e18:	48 8b 00             	mov    (%rax),%rax
    6e1b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    6e1f:	72 17                	jb     6e38 <free+0x4f>
    6e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6e25:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    6e29:	72 2f                	jb     6e5a <free+0x71>
    6e2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6e2f:	48 8b 00             	mov    (%rax),%rax
    6e32:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    6e36:	72 22                	jb     6e5a <free+0x71>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6e3c:	48 8b 00             	mov    (%rax),%rax
    6e3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    6e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6e47:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    6e4b:	73 c7                	jae    6e14 <free+0x2b>
    6e4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6e51:	48 8b 00             	mov    (%rax),%rax
    6e54:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    6e58:	73 ba                	jae    6e14 <free+0x2b>
      break;
  if(bp + bp->s.size == p->s.ptr){
    6e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6e5e:	8b 40 08             	mov    0x8(%rax),%eax
    6e61:	89 c0                	mov    %eax,%eax
    6e63:	48 c1 e0 04          	shl    $0x4,%rax
    6e67:	48 89 c2             	mov    %rax,%rdx
    6e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6e6e:	48 01 c2             	add    %rax,%rdx
    6e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6e75:	48 8b 00             	mov    (%rax),%rax
    6e78:	48 39 c2             	cmp    %rax,%rdx
    6e7b:	75 2d                	jne    6eaa <free+0xc1>
    bp->s.size += p->s.ptr->s.size;
    6e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6e81:	8b 50 08             	mov    0x8(%rax),%edx
    6e84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6e88:	48 8b 00             	mov    (%rax),%rax
    6e8b:	8b 40 08             	mov    0x8(%rax),%eax
    6e8e:	01 c2                	add    %eax,%edx
    6e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6e94:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    6e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6e9b:	48 8b 00             	mov    (%rax),%rax
    6e9e:	48 8b 10             	mov    (%rax),%rdx
    6ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6ea5:	48 89 10             	mov    %rdx,(%rax)
    6ea8:	eb 0e                	jmp    6eb8 <free+0xcf>
  } else
    bp->s.ptr = p->s.ptr;
    6eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6eae:	48 8b 10             	mov    (%rax),%rdx
    6eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6eb5:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    6eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ebc:	8b 40 08             	mov    0x8(%rax),%eax
    6ebf:	89 c0                	mov    %eax,%eax
    6ec1:	48 c1 e0 04          	shl    $0x4,%rax
    6ec5:	48 89 c2             	mov    %rax,%rdx
    6ec8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ecc:	48 01 d0             	add    %rdx,%rax
    6ecf:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    6ed3:	75 27                	jne    6efc <free+0x113>
    p->s.size += bp->s.size;
    6ed5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ed9:	8b 50 08             	mov    0x8(%rax),%edx
    6edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6ee0:	8b 40 08             	mov    0x8(%rax),%eax
    6ee3:	01 c2                	add    %eax,%edx
    6ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ee9:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    6eec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6ef0:	48 8b 10             	mov    (%rax),%rdx
    6ef3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6ef7:	48 89 10             	mov    %rdx,(%rax)
    6efa:	eb 0b                	jmp    6f07 <free+0x11e>
  } else
    p->s.ptr = bp;
    6efc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6f00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    6f04:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    6f07:	48 ba d0 cf 00 00 00 	movabs $0xcfd0,%rdx
    6f0e:	00 00 00 
    6f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6f15:	48 89 02             	mov    %rax,(%rdx)
}
    6f18:	90                   	nop
    6f19:	c9                   	leave
    6f1a:	c3                   	ret

0000000000006f1b <morecore>:

static Header*
morecore(uint nu)
{
    6f1b:	55                   	push   %rbp
    6f1c:	48 89 e5             	mov    %rsp,%rbp
    6f1f:	48 83 ec 20          	sub    $0x20,%rsp
    6f23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    6f26:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    6f2d:	77 07                	ja     6f36 <morecore+0x1b>
    nu = 4096;
    6f2f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    6f36:	8b 45 ec             	mov    -0x14(%rbp),%eax
    6f39:	48 c1 e0 04          	shl    $0x4,%rax
    6f3d:	48 89 c7             	mov    %rax,%rdi
    6f40:	48 b8 8d 67 00 00 00 	movabs $0x678d,%rax
    6f47:	00 00 00 
    6f4a:	ff d0                	call   *%rax
    6f4c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    6f50:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    6f55:	75 07                	jne    6f5e <morecore+0x43>
    return 0;
    6f57:	b8 00 00 00 00       	mov    $0x0,%eax
    6f5c:	eb 36                	jmp    6f94 <morecore+0x79>
  hp = (Header*)p;
    6f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    6f62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    6f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6f6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
    6f6d:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    6f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6f74:	48 83 c0 10          	add    $0x10,%rax
    6f78:	48 89 c7             	mov    %rax,%rdi
    6f7b:	48 b8 e9 6d 00 00 00 	movabs $0x6de9,%rax
    6f82:	00 00 00 
    6f85:	ff d0                	call   *%rax
  return freep;
    6f87:	48 b8 d0 cf 00 00 00 	movabs $0xcfd0,%rax
    6f8e:	00 00 00 
    6f91:	48 8b 00             	mov    (%rax),%rax
}
    6f94:	c9                   	leave
    6f95:	c3                   	ret

0000000000006f96 <malloc>:

void*
malloc(uint nbytes)
{
    6f96:	55                   	push   %rbp
    6f97:	48 89 e5             	mov    %rsp,%rbp
    6f9a:	48 83 ec 30          	sub    $0x30,%rsp
    6f9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6fa1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    6fa4:	48 83 c0 0f          	add    $0xf,%rax
    6fa8:	48 c1 e8 04          	shr    $0x4,%rax
    6fac:	83 c0 01             	add    $0x1,%eax
    6faf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    6fb2:	48 b8 d0 cf 00 00 00 	movabs $0xcfd0,%rax
    6fb9:	00 00 00 
    6fbc:	48 8b 00             	mov    (%rax),%rax
    6fbf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    6fc3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    6fc8:	75 4a                	jne    7014 <malloc+0x7e>
    base.s.ptr = freep = prevp = &base;
    6fca:	48 b8 c0 cf 00 00 00 	movabs $0xcfc0,%rax
    6fd1:	00 00 00 
    6fd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    6fd8:	48 ba d0 cf 00 00 00 	movabs $0xcfd0,%rdx
    6fdf:	00 00 00 
    6fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    6fe6:	48 89 02             	mov    %rax,(%rdx)
    6fe9:	48 b8 d0 cf 00 00 00 	movabs $0xcfd0,%rax
    6ff0:	00 00 00 
    6ff3:	48 8b 00             	mov    (%rax),%rax
    6ff6:	48 ba c0 cf 00 00 00 	movabs $0xcfc0,%rdx
    6ffd:	00 00 00 
    7000:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    7003:	48 b8 c0 cf 00 00 00 	movabs $0xcfc0,%rax
    700a:	00 00 00 
    700d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    7014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    7018:	48 8b 00             	mov    (%rax),%rax
    701b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    701f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    7023:	8b 40 08             	mov    0x8(%rax),%eax
    7026:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    7029:	72 65                	jb     7090 <malloc+0xfa>
      if(p->s.size == nunits)
    702b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    702f:	8b 40 08             	mov    0x8(%rax),%eax
    7032:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    7035:	75 10                	jne    7047 <malloc+0xb1>
        prevp->s.ptr = p->s.ptr;
    7037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    703b:	48 8b 10             	mov    (%rax),%rdx
    703e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    7042:	48 89 10             	mov    %rdx,(%rax)
    7045:	eb 2e                	jmp    7075 <malloc+0xdf>
      else {
        p->s.size -= nunits;
    7047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    704b:	8b 40 08             	mov    0x8(%rax),%eax
    704e:	2b 45 ec             	sub    -0x14(%rbp),%eax
    7051:	89 c2                	mov    %eax,%edx
    7053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    7057:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    705a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    705e:	8b 40 08             	mov    0x8(%rax),%eax
    7061:	89 c0                	mov    %eax,%eax
    7063:	48 c1 e0 04          	shl    $0x4,%rax
    7067:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    706b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    706f:	8b 55 ec             	mov    -0x14(%rbp),%edx
    7072:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    7075:	48 ba d0 cf 00 00 00 	movabs $0xcfd0,%rdx
    707c:	00 00 00 
    707f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    7083:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    7086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    708a:	48 83 c0 10          	add    $0x10,%rax
    708e:	eb 4e                	jmp    70de <malloc+0x148>
    }
    if(p == freep)
    7090:	48 b8 d0 cf 00 00 00 	movabs $0xcfd0,%rax
    7097:	00 00 00 
    709a:	48 8b 00             	mov    (%rax),%rax
    709d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    70a1:	75 23                	jne    70c6 <malloc+0x130>
      if((p = morecore(nunits)) == 0)
    70a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    70a6:	89 c7                	mov    %eax,%edi
    70a8:	48 b8 1b 6f 00 00 00 	movabs $0x6f1b,%rax
    70af:	00 00 00 
    70b2:	ff d0                	call   *%rax
    70b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    70b8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    70bd:	75 07                	jne    70c6 <malloc+0x130>
        return 0;
    70bf:	b8 00 00 00 00       	mov    $0x0,%eax
    70c4:	eb 18                	jmp    70de <malloc+0x148>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    70c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    70ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    70ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    70d2:	48 8b 00             	mov    (%rax),%rax
    70d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    70d9:	e9 41 ff ff ff       	jmp    701f <malloc+0x89>
  }
}
    70de:	c9                   	leave
    70df:	c3                   	ret
