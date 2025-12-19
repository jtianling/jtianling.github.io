---
layout: post
title: "以此纪念刚开始在linux上学习网络编程的失败-_-!"
categories:
- "网络技术"
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者在Ubuntu上学习网络编程，服务器能监听却不响应连接。相同代码在Windows下正常，他怀疑是系统配置问题所致。

<!-- more -->

# 以此纪念刚开始在linux上学习网络编程的失败-_-!



从一开始的学习到现在，我的Ubuntu 8.04服务器版本就从来没有正常的跑过一个服务器程序，亏它还是服务器版本的，郁闷的我要死。目前为止的正常的服务器端网络程序都是在Windows下运行成功的，比如第一次那个daytime服务器，都是靠着移植到windows下才能成功，不过不停的调试啊，调试啊，gdb倒是熟悉了不少，还顺便熟悉了一堆的网络调试工具，linux下的netstat,tcpdump，windows下的Wireshark（linux因为没有X window，所以用不了）倒是真熟悉了很多，我都真不知道这样的死Ubuntu对于学习是好是坏了，假如没有碰到这么多问题的话，我不会调试一个那样简单的程序那么多次，不会这样的进一步熟悉那些特别简单的套接口API,真是，郁闷了。

中间发帖求救，有人说是防火墙，我配置了半天也没有反应，直接将ufw,iptables什么的都卸载了，结果还是不行！

最新的调试结果就是netstat显示的确服务器端listen成功了， tcpdump可以看到客户端的发送的SYN包，但是就是服务器不回ACK包，郁闷的客户端所以总是不停的发送几次SYN包，然后connect failed了，奇怪的家伙，我今晚准备下个ubuntu的普通版本试一下，服务器版本可能为了安全做了太多的手脚，我配置linux的能力又那么弱-_-!光学些bash,makefile什么的，对于配置文件的修改实在是不行，不然我也不会为了samba的配置郁闷到死，然后干脆传输文件都直接改用WinSCP，通过SSH传输，而不是通过共享了。唉。。。。还是公司好，有管理员。

ubuntu普通版本还不行，我就只好换回FC了。。。。刚才看了一下已经到10了-_-!我上一次用的时候还是FC6呢，那时候4，5张盘，现在FC10只有1CD了，最近的操作系统瘦身工程进行的还挺彻底。要知道，连最最老的经典的RH9那时候都是4张盘。

呵呵，其实想起来，看的其实是UNIX的书，弄个真正的UNIX，比如FreeBSD什么的应该也挺不错的，可惜最近工作那个忙的啊。。。。都快吐血了，游戏快要上大规模的内测了，老总，总监催进度催的我一天头是大的，刚开始弄游戏的主逻辑服务器，第二天就要我设计并添加模块-_-!实在是@#%#$^@#$^$%@&$%基本上就那句话，不能上硬着头皮眯着眼睛也要上！唉。。。。所以嘛，还是暂时收收心吧。。。好好把网络编程学好都不错了，连Linux都没有弄转，呵呵，还是老实点好。

以下是我痛苦的调试经历：-_-!

```bash
@ubuntu:~$ netstat -a

Active Internet connections (servers and established)

Proto Recv-Q Send-Q Local Address           Foreign Address         State

tcp        0      0 *:13000                 *:*                     LISTEN
```

```bash
@ubuntu:~$ netstat -a

Active Internet connections (servers and established)

Proto Recv-Q Send-Q Local Address           Foreign Address         State

tcp        0      0 *:daytime                *:*                     LISTEN
```

```bash
@ubuntu:~$ netstat -a

Active Internet connections (servers and established)

Proto Recv-Q Send-Q Local Address           Foreign Address         State

tcp        0      0 *:9877                  *:*                     LISTEN
```

三个不同的程序，都是卡在listen上。。。。

```bash
@ubuntu:~/test/testclient$ ./test 127.0.0.1
connet failed.
@ubuntu:~/test/testclient$ ./test 127.0.0.1
connet failed.
```

可怜的客户端啊。。。一次一次的connet failed

其实它实在不停的尝试的。。。。

一次：

```bash
@ubuntu:~$ sudo tcpdump port 9877
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
22:04:03.173472 IP 192.168.0.158.46269 > localhost.9877: S 1088742785:1088742785(0) win 5840 <mss 1460,sackOK,timestamp 95154 0,nop,wscale 4>
22:04:06.171580 IP 192.168.0.158.46269 > localhost.9877: S 1088742785:1088742785(0) win 5840 <mss 1460,sackOK,timestamp 95904 0,nop,wscale 4>
```

两次：

```bash
@ubuntu:~$ sudo tcpdump port 9877 -vv
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
22:05:09.022315 IP (tos 0x0, ttl 64, id 16507, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.46270 > localhost.9877: S, cksum 0xef4b (correct), 2110715003:2110715003(0) win 5840 <mss 1460,sackOK,timestamp 111616 0,nop,wscale 4>
22:05:12.019572 IP (tos 0x0, ttl 64, id 16508, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.46270 > localhost.9877: S, cksum 0xec5d (correct), 2110715003:2110715003(0) win 5840 <mss 1460,sackOK,timestamp 112366 0,nop,wscale 4>
22:05:18.019572 IP (tos 0x0, ttl 64, id 16509, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.46270 > localhost.9877: S, cksum 0xe681 (correct), 2110715003:2110715003(0) win 5840 <mss 1460,sackOK,timestamp 113866 0,nop,wscale 4>
22:05:30.019593 IP (tos 0x0, ttl 64, id 16510, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.46270 > localhost.9877: S, cksum 0xdac9 (correct), 2110715003:2110715003(0) win 5840 <mss 1460,sackOK,timestamp 116866 0,nop,wscale 4>
22:05:54.019575 IP (tos 0x0, ttl 64, id 16511, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.46270 > localhost.9877: S, cksum 0xc359 (correct), 2110715003:2110715003(0) win 5840 <mss 1460,sackOK,timestamp 122866 0,nop,wscale 4>
22:06:42.019581 IP (tos 0x0, ttl 64, id 16512, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.46270 > localhost.9877: S, cksum 0x9479 (correct), 2110715003:2110715003(0) win 5840 <mss 1460,sackOK,timestamp 134866 0,nop,wscale 4>
6 packets captured
6 packets received by filter
0 packets dropped by kernel
```

三次：

```bash
@ubuntu:~$ sudo tcpdump port 13000 -vv
[sudo] password for xqh:
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
22:44:49.480945 IP (tos 0x0, ttl 64, id 10118, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.60205 > localhost.13000: S, cksum 0xebc4 (correct), 793636653:793636653(0) win 5840 <mss 1460,sackOK,timestamp 706731 0,nop,wscale 4>
22:44:52.479579 IP (tos 0x0, ttl 64, id 10119, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.60205 > localhost.13000: S, cksum 0xe8d6 (correct), 793636653:793636653(0) win 5840 <mss 1460,sackOK,timestamp 707481 0,nop,wscale 4>
22:44:58.479574 IP (tos 0x0, ttl 64, id 10120, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.60205 > localhost.13000: S, cksum 0xe2fa (correct), 793636653:793636653(0) win 5840 <mss 1460,sackOK,timestamp 708981 0,nop,wscale 4>
22:45:10.479576 IP (tos 0x0, ttl 64, id 10121, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.60205 > localhost.13000: S, cksum 0xd742 (correct), 793636653:793636653(0) win 5840 <mss 1460,sackOK,timestamp 711981 0,nop,wscale 4>
22:45:34.479596 IP (tos 0x0, ttl 64, id 10122, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.60205 > localhost.13000: S, cksum 0xbfd2 (correct), 793636653:793636653(0) win 5840 <mss 1460,sackOK,timestamp 717981 0,nop,wscale 4>
22:46:22.479584 IP (tos 0x0, ttl 64, id 10123, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.60205 > localhost.13000: S, cksum 0x90f2 (correct), 793636653:793636653(0) win 5840 <mss 1460,sackOK,timestamp 729981 0,nop,wscale 4>
22:49:22.209124 IP (tos 0x0, ttl 64, id 2573, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.49879 > localhost.13000: S, cksum 0x20c8 (correct), 778754316:778754316(0) win 5840 <mss 1460,sackOK,timestamp 774913 0,nop,wscale 4>
22:49:25.207577 IP (tos 0x0, ttl 64, id 2574, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.49879 > localhost.13000: S, cksum 0x1dda (correct), 778754316:778754316(0) win 5840 <mss 1460,sackOK,timestamp 775663 0,nop,wscale 4>
22:49:31.207570 IP (tos 0x0, ttl 64, id 2575, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.49879 > localhost.13000: S, cksum 0x17fe (correct), 778754316:778754316(0) win 5840 <mss 1460,sackOK,timestamp 777163 0,nop,wscale 4>
22:49:43.207579 IP (tos 0x0, ttl 64, id 2576, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.49879 > localhost.13000: S, cksum 0x0c46 (correct), 778754316:778754316(0) win 5840 <mss 1460,sackOK,timestamp 780163 0,nop,wscale 4>
22:50:07.207588 IP (tos 0x0, ttl 64, id 2577, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.49879 > localhost.13000: S, cksum 0xf4d5 (correct), 778754316:778754316(0) win 5840 <mss 1460,sackOK,timestamp 786163 0,nop,wscale 4>
22:50:55.207580 IP (tos 0x0, ttl 64, id 2578, offset 0, flags [DF], proto TCP (6), length 60) 192.168.0.158.49879 > localhost.13000: S, cksum 0xc5f5 (correct), 778754316:778754316(0) win 5840 <mss 1460,sackOK,timestamp 798163 0,nop,wscale 4>
```

记住，就算我不改一个字，原《UNIX Network Programming》第一卷第三版一书的源程序（我试过4，5个前面几章的例子了），都是可以编译，可以运行，但是状况都是同样的。。。那就是connect不会成功。-_-!

处于对于原程序的一丝不信任，我自己重写了一些程序，但是几乎同样的程序，在Windows下相当的正常，但是在Ubuntu 8.04服务器版本上，还是同样的状况！！有没有人可以给我个解释啊。。。。。朝闻道夕死可矣。。。。。

举个例子，比如，linux下的两个程序：

服务器端：

```c
 1 #include <stdio.h>  
 2 #include <stdlib.h>  
 3 #include <sys/socket.h>  
 4 #include <sys/time.h>  
 5 #include <time.h>  
 6 #include <netinet/in.h>  
 7 #include <errno.h>  
 8 #include <string.h>  
 9 #include <unistd.h>  
10   
11   
12 #define MAXLINE 1000  
13 **int**  main(int  argc, char * argv[])  
14 {  
15     int     listenfd, connfd;  
16     struct  sockaddr_in servaddr;  
17     //char buff[MAXLINE] = {0};  
18     //time_t   ticks;  
19   
20     listenfd = socket(AF_INET, SOCK_STREAM, 0);  
21     if(0 == listenfd)  
22     {  
23         printf("socket Error./n");  
24         return  -1;  
25     }  
26   
27     memset(&servaddr, 0, sizeof(servaddr));  
28     servaddr.sin_family      = AF_INET;  
29     servaddr.sin_addr.s_addr = htonl(INADDR_ANY);  
30     servaddr.sin_port        = htons(13000);   /* daytime server */  
31   
32     if( 0 != bind(listenfd, (struct  sockaddr*)&servaddr, sizeof(servaddr)))  
33     {  
34         printf("bind error./n");  
35         close(listenfd);  
36         return  -1;  
37     }  
38   
39     if( 0 != listen(listenfd, 10))  
40     {  
41         printf("listen error./n");  
42         close(listenfd);  
43         return  -1;  
44     }  
45   
46     printf("listen right./n");  
47   
48     char  buffRecv[MAXLINE] = {0};  
49     connfd = accept(listenfd, (struct  sockaddr*)NULL, NULL);  
50          
51     printf("have accept./n");  
52   
53     while(true)  
54     {  
55         int  n = 0;  
56         if( 0 == (n = read(connfd, buffRecv, MAXLINE)) )  
57         {  
58             printf("recv failed/n");  
59             break ;  
60         }  
61         buffRecv[n] = 0;  
62         if( 0 == (n = write(connfd, buffRecv, strlen(buffRecv))) )  
63         {  
64             printf("send failed./n");  
65             break ;  
66         }  
67         fputs(buffRecv, stdout);  
68     }  
69     close(connfd);  
70     exit(0);  
71 }  
72
```

客户端：

```c
 1 #include <stdio.h>  
 2 #include <stdlib.h>  
 3 #include <sys/socket.h>  
 4 #include <sys/time.h>  
 5 #include <time.h>  
 6 #include <netinet/in.h>  
 7 #include <errno.h>  
 8 #include <string.h>  
 9 #include <unistd.h>  
10 #include <arpa/inet.h>  
11   
12 #define MAXLINE 1000  
13   
14 **void**  str_cli(FILE  *fp, int  sockfd)  
15 {  
16     char  sendline[MAXLINE] = {0};  
17     char  recvline[MAXLINE] = {0};  
18     while  ( (fgets(sendline, MAXLINE, fp)) != NULL)   
19     {  
20   
21         if(0 == send(sockfd, sendline, strlen(sendline), 0))  
22         {  
23             printf("send failed./n");  
24             break  ;  
25         }  
26     }  
27     close(sockfd);  
28 }  
29   
30 **int**  main(int  argc, char * argv[])  
31 {  
32     if  (argc != 2)  
33     {  
34         printf("usage: tcpcli <IPaddress>");  
35         exit(1);  
36     }  
37   
38     int     sockfd = 0;  
39     sockfd = socket(AF_INET, SOCK_STREAM, 0);  
40   
41     struct  sockaddr_in servaddr;  
42     memset(&servaddr, 0, sizeof(servaddr));  
43     servaddr.sin_family      = AF_INET;  
44     servaddr.sin_addr.s_addr = inet_addr(argv[1]);  
45     servaddr.sin_port        = htons(13000);   /* daytime server */  
46   
47     if( 0 != connect(sockfd, (struct  sockaddr *)&servaddr, sizeof(servaddr)))  
48     {  
49         printf("connet failed./n");  
50         close(sockfd);  
51         return  -1;  
52     }  
53   
54     str_cli(stdin, sockfd);        /* do it all */  
55     exit(0);  
56 }  
57
```

就这么简单的程序，硬是成功不了，何解？

几乎同样的程序，比如：

服务器端：

```c
#include "Winsock2.h"

//#include "python.h"

//void CallPython(const char* apszPy)
//{
//  Py_Initialize();
//  PyRun_SimpleString(apszPy);
//  Py_Finalize();
//}

#define MAXLINE 1000

int main(int argc, char **argv)
{
    WORD wVersionRequested;
    WSADATA wsaData;
    int err;

    wVersionRequested = MAKEWORD( 2, 2 );

    // windows下此初始化为必须
    err = WSAStartup( wVersionRequested, &wsaData );
    if ( err != 0 ) {
       return -1;
    }

    SOCKET listenfd, connfd;
    struct sockaddr_in   servaddr;
    char   buff[MAXLINE];
    time_t ticks;

    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    if(INVALID_SOCKET == listenfd)
    {
       printf("socket Error: %d",WSAGetLastError());
       return -1;
    }

    ZeroMemory(&servaddr, sizeof(servaddr));
    servaddr.sin_family     = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port        = htons(13);  /* daytime server */

    bind(listenfd, (struct sockaddr*)&servaddr, sizeof(servaddr));

    listen(listenfd, SOMAXCONN);

    char   buffRecv[MAXLINE] = {0};
        
    connfd = accept(listenfd, (struct sockaddr*)NULL, NULL);
        
    while(true)
    {
       int n = 0;
       if( 0 == (n = recv(connfd, buffRecv, MAXLINE,0)) )
       {
           printf("recv failed, Error Code: %d", WSAGetLastError());
           break;
       }
       buffRecv[n] = 0;
//     CallPython(buffRecv);
       if( 0 == (n = send(connfd, buffRecv, strlen(buffRecv),0)) )
       {
           printf("send failed, Error Code: %d", WSAGetLastError());
           break;

       }

       fputs(buffRecv, stdout);
    }

    closesocket(connfd);
}
```

客户端：

```c
#include "Winsock2.h"
#include "errno.h"
#include "stdlib.h"

#define MAXLINE 1000

void str_cli(FILE *fp, SOCKET sockfd)
{
    char sendline[MAXLINE] = {0};
    char recvline[MAXLINE] = {0};
    while ( (fgets(sendline, MAXLINE, fp)) != NULL) 
    {

       if(SOCKET_ERROR == send(sockfd, sendline, strlen(sendline), 0))
       {
           printf("send failed, Error Code: %d", WSAGetLastError());
           break ;
       }
    }
    closesocket(sockfd);
}
int main(int argc, char **argv)
{
    WORD wVersionRequested = 0;
    WSADATA wsaData;
    int err;

    wVersionRequested = MAKEWORD( 2, 2 );

    // windows下此初始化为必须，实际包含加载WinsockDLL的过程
    err = WSAStartup( wVersionRequested, &wsaData );
    if ( err != 0 ) {
       return -1;
    }
    SOCKET               sockfd;
    struct sockaddr_in   servaddr;

    if (argc != 2)
    {
       printf("usage: tcpcli <IPaddress>");
       exit(1);
    }

    sockfd = socket(AF_INET, SOCK_STREAM, 0);

    ZeroMemory(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(13);
    servaddr.sin_addr.s_addr = inet_addr(argv[1]);

    if( SOCKET_ERROR == connect(sockfd, (struct sockaddr *) &servaddr, sizeof(servaddr)))
    {
       printf("connet failed, Error Code: %d", WSAGetLastError());
       closesocket(sockfd);
       return -1;
    }

    str_cli(stdin, sockfd);     /* do it all */

    system("pause");
    exit(0);
}
```

就是运行的那么正常-_-!给我个解释？。。。。。另外，虽然做了写了好几个服务器了，我最近才知道。。原来。。。recv,send本来就是标准的套接口API。。。。我一直以为这些都是windows扩展的-_-!《Unix Network Programming》书以前只看了前面一点，因为前面用的都是read,write接口来写套接字，所以嘛。。。呵呵，误解了，以前还常喊windows下用的recv,send很奇怪呢-_-!太无知了，所以嘛，还是要好好学习底层知识才行。。。不能太依赖于公司的网络框架了，虽然那个框架写的真是不赖。。。好用的很。。。

有在Ubuntu 8.04版本上成功accept的兄弟，请告知怎么样配置的。。。。。

## 以此纪念刚开始在linux上学习网络编程的失败-_-!

[**write by 九天雁翎 (JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)
