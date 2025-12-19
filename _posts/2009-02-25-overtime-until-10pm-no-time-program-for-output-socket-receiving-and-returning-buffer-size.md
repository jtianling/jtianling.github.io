---
layout: post
title: "加班到十点，没有时间，弄个输出套接字接收和返回的Buffer大小的程序"
categories:
- "网络技术"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

文章通过C程序测试了套接字的默认缓冲区大小，并对比了Ubuntu与FreeBSD系统下的不同结果。

<!-- more -->

# 加班到十点，没有时间，弄个输出套接字接收和返回的Buffer大小的程序



在Ubuntu8.04桌面版下，测试的结果为

Socket default Receive Buffer is 87380

Socket default Send Buffer is 16384

与作者在freebsd4.8中的稍有不同，接收缓冲区略大，发送缓冲区略小。

作者得出的结果分别是57344,32768

在我的系统中，接收的缓存实在是够大

源代码：

```c
 1 #include    "unp.h"  
 2   
 3 **int**  main(**int**  argc, **char**  **argv)  
 4 {  
 5     **int**     sockfd, n;  
 6     /*   struct sockaddr_in    servaddr; */  
 7     **int**  liRcvSize = 0;  
 8     socklen_t liRcvLen = **sizeof**(liRcvSize);  
 9     **int**  liSndSize = 0;  
10     socklen_t liSndLen = **sizeof**(liSndSize);  
11   
12     **if**  ((sockfd = Socket(AF_INET, SOCK_STREAM, 0)) < 0)  
13     {  
14         err_sys("Socket Create failed/n");  
15     }  
16   
17     **if**  ( ( n = getsockopt(sockfd, SOL_SOCKET, SO_RCVBUF, &liRcvSize, &liRcvLen) ) < 0)  
18     {  
19         err_sys("getsocketopt recv buffer run failed/n");  
20     }  
21   
22     **if**  ( ( n = getsockopt(sockfd, SOL_SOCKET, SO_SNDBUF, &liSndSize, &liSndLen) ) < 0)  
23     {  
24         err_sys("getsocketopt send buffer run failed/n");  
25     }  
26   
27     close(sockfd);  
28   
29     printf("Socket default Receive Buffer is %d/n", liRcvSize);  
30     printf("Socket default Send Buffer is %d/n", liSndSize);  
31   
32     
33     exit(0);  
34 }
```

Thread model: posix

gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu4)

纯ANSI C程序

