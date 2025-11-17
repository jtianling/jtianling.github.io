---
layout: post
title: "服务器Select模型的实现"
categories:
- "网络技术"
tags:
- Select模型
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '21'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# 服务器Select模型的实现

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

select模型属于网络的I/O复用模型，比纯粹的阻塞I/O模型更具有实用性，因为可以同时等待多个描述字的就绪。

当年学习C/C++的时候，很少碰到底层以数字标示的描述字，只在写文件系统的去尝试各种情况，以获得最佳效率的时候实际尝试使用过一次，一直觉得那种open,write,read的文件操作方式，实在是比fopen一族函数还要低级的方式-_-!平时没有必要使用。但是等到网络编程的时候，才发现。。。。原来这么底层的东西，竟然也有一定的通用性，文件的描述字和网络的描述字竟然是一致的-_-!不管是谁设计的，还是挺佩服的。。。。。。

       这里仅仅是为了学习Select模型而写的学习例子，作用是在服务器端输出连接上的客户端的IP(仅以数字形式)，然后将客户端的IP以字符串的形式返回，客户端连接服务器，并接受由服务器端返回的IP地址，然后输出转换为字符串形式的IP地址和数字形式的IP地址，为了区别select到正确的不同listen套接字，这里用了不同的端口，并且不同的两个套接字响应时以echo 1,echo 2区别。功能是很简单的，仅仅用于学习，所以其中很多地方本来可以抽出来称为函数的，都贪简单，直接复制了(-_-!这里本来习惯想说Ctrl-C Ctrl-V的。。。但是发现自己实在Ubuntu下用vim复制的，好像和实际情况不符。。。。)

       另外。。。。由于用的是《Unix Network Programming》一书，所以编程风格都变得有点像书中了。。。。服务器端全是自己写的，客户端代码由书中的daytime客户端改过来的，并且发现书中客户端代码都不关闭套接字，都交由退出进程的时候由系统关闭，不知道这种风格好不好。由于学习。。。写的是ANSI C程序，用gcc编译-_-!

unp.h是《Unix Network Programming》源代码中的公用头文件，makefile可能也得注意一下，为了图省事，我用了其源代码中的Make.defines，因为这样比自己写简单多了：），makefile就不贴了，没有什么学习意义。

 

运行效果如下：

客户端运行：

```bash
./TestSelectCli 127.0.0.1 1000

Conncet OK

127.0.0.1:16777343 Echo 1.

laptop:~/unpv1/unpv13e/MyTest$ ./TestSelectCli 127.0.0.1 1001

Conncet OK

127.0.0.1:16777343 Echo 2.

laptop:~/unpv1/unpv13e/MyTest$ ./TestSelectCli 192.168.0.138 1000

Conncet OK

192.168.0.138:2315299008 Echo 1.

laptop:~/unpv1/unpv13e/MyTest$ ./TestSelectCli 192.168.0.138 1001

Conncet OK

192.168.0.138:2315299008 Echo 2.
```

服务器端输出：

```bash
2315299008 Echo 1.

16777343 Echo 1.

16777343 Echo 2.

2315299008 Echo 1.

2315299008 Echo 2.
```

 

服务器端源代码：

```c
  1 #include    "unp.h"  
  2   
  3   
  4 **void**  str_echo1(**int**  connfd);  
  5 **void**  str_echo2(**int**  connfd);  
  6   
  7 **int**  main(**int**  argc, **char**  **argv)  
  8 {  
  9     **struct**  sockaddr_in cliaddr;  
 10     pid_t childpid;  
 11   
 12     /*  Bind 1000 port to listen socket 1 */  
 13     **int**  listenfd1 = Socket(AF_INET, SOCK_STREAM, 0);  
 14   
 15     **struct**  sockaddr_in servaddr;  
 16     bzero(&servaddr, **sizeof**(servaddr));  
 17     servaddr.sin_family = AF_INET;  
 18     servaddr.sin_addr.s_addr = htonl(INADDR_ANY);  
 19     servaddr.sin_port = htons(1000);  
 20   
 21     Bind(listenfd1, (SA *)&servaddr, **sizeof**(servaddr));  
 22   
 23     Listen(listenfd1, LISTENQ);  
 24   
 25     /*  Bind 1001 port to listen socket 2*/  
 26     **int**  listenfd2 = Socket(AF_INET, SOCK_STREAM, 0);  
 27   
 28     **struct**  sockaddr_in servaddr2;  
 29     bzero(&servaddr2, **sizeof**(servaddr2));  
 30     servaddr2.sin_family = AF_INET;  
 31     servaddr2.sin_addr.s_addr = htonl(INADDR_ANY);  
 32     servaddr2.sin_port = htons(1001);  
 33   
 34     Bind(listenfd2, (SA *)&servaddr2, **sizeof**(servaddr2));  
 35   
 36     Listen(listenfd2, LISTENQ);  
 37   
 38     /* Initialize fd_set struct */  
 39     **int**  maxfdp1 = max(listenfd1, listenfd2) + 1;  
 40     fd_set rset;  
 41     FD_ZERO(&rset);  
 42   
 43     /*  Select from this two listen socket */  
 44     **for**( ; ; )  
 45     {  
 46         FD_SET(listenfd1, &rset);  
 47         FD_SET(listenfd2, &rset);  
 48   
 49         **int**  nready = -1;  
 50         **if**( (nready = select(maxfdp1, &rset, NULL, NULL, NULL)) < 0)  
 51         {  
 52             **if**(EINTR == errno)  
 53             {  
 54                 **continue** ;  
 55             }  
 56             **else**  
 57             {  
 58                 err_sys("Select error.");  
 59             }  
 60         }  
 61   
 62         /*  some one listening socket is readable.*/  
 63         **if**(FD_ISSET(listenfd1, &rset))  
 64         {  
 65             socklen_t len = **sizeof**(cliaddr);  
 66             **int**  connfd = Accept(listenfd1, (SA *)&cliaddr, &len);  
 67   
 68             **if**( 0 == (childpid = Fork()) )  
 69             {  
 70                 /* child process */  
 71                 Close(listenfd1);  
 72   
 73                 str_echo1(connfd);  
 74                 exit(0);  
 75             }  
 76   
 77             /* parent process  */  
 78             Close(connfd);  
 79   
 80         }  
 81   
 82   
 83         **if**(FD_ISSET(listenfd2, &rset))  
 84         {  
 85             socklen_t len = **sizeof**(cliaddr);  
 86             **int**  connfd = Accept(listenfd2, (SA *)&cliaddr, &len);  
 87   
 88             **if**( 0 == (childpid = Fork()) )  
 89             {  
 90                 /* child process */  
 91                 Close(listenfd2);  
 92   
 93                 str_echo2(connfd);  
 94                 exit(0);  
 95             }  
 96   
 97             /* parent process  */  
 98             Close(connfd);  
 99   
100         }  
101   
102     }  
103   
104     exit(0);  
105 }  
106   
107 **void**  str_echo1(**int**  connfd)  
108 {  
109     **struct**  sockaddr_in clientAddr;  
110     socklen_t len = **sizeof**(clientAddr);  
111   
112     **if**(getpeername(connfd, (SA*) &clientAddr, &len) < 0)  
113     {  
114         **return** ;  
115     }  
116   
117     **char**  lcBuffer[MAXLINE] = {0};  
118     sprintf(lcBuffer, "%u Echo 1.", clientAddr.sin_addr.s_addr);  
119   
120     printf("%s/n", lcBuffer);  
121   
122     Write(connfd, lcBuffer, MAXLINE);  
123 }  
124   
125   
126 **void**  str_echo2(**int**  connfd)  
127 {  
128     **struct**  sockaddr_in clientAddr;  
129     socklen_t len = **sizeof**(clientAddr);  
130   
131     **if**(getpeername(connfd, (SA*) &clientAddr, &len) < 0)  
132     {  
133         **return** ;  
134     }  
135   
136   
137     **char**  lcBuffer[MAXLINE] = {0};  
138     sprintf(lcBuffer, "%u Echo 2.", clientAddr.sin_addr.s_addr);  
139   
140     printf("%s/n", lcBuffer);  
141   
142     Write(connfd, lcBuffer, MAXLINE);  
143 }  
144   
145
```

 

客户端源代码：

```c
 1 #include    "unp.h"  
 2   
 3 **int**  main(**int**  argc, **char**  **argv)  
 4 {  
 5     **int**                     sockfd, n;  
 6     **char**                recvline[MAXLINE + 1];  
 7     **struct**  sockaddr_in servaddr;  
 8   
 9     **if**  (argc != 3)  
10         err_quit("usage: a.out <IPaddress> <IPPort>");  
11   
12     **int**  port = atoi(argv[2]);  
13   
14     **if**  ( (sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)  
15         err_sys("socket error");  
16   
17     bzero(&servaddr, **sizeof**(servaddr));  
18     servaddr.sin_family = AF_INET;  
19     servaddr.sin_port   = htons(port);  
20     **if**  (inet_pton(AF_INET, argv[1], &servaddr.sin_addr) <= 0)  
21         err_quit("inet_pton error for %s", argv[1]);  
22   
23     **if**  (connect(sockfd, (SA *) &servaddr, **sizeof**(servaddr)) < 0)  
24         err_sys("connect error");  
25   
26     printf("Conncet OK/n");  
27   
28     **while**  ( (n = read(sockfd, recvline, MAXLINE)) > 0) {  
29         recvline[n] = 0;  /* null terminate */  
30   
31         /*  change number string to number and to ip string */  
32         **struct**  in_addr svraddr;  
33         svraddr.s_addr = strtoul(recvline, NULL, 10);  
34         **char**  *pszsvraddr = inet_ntoa(svraddr);  
35   
36         printf("%s:%s/n", pszsvraddr, recvline);  
37     }  
38     **if**  (n < 0)  
39         err_sys("read error");  
40   
41     exit(0);  
42 }
```

 

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)