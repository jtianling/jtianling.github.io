---
layout: post
title: "潜心开始学习网络编程的第一步 ，UNP(Unix Network Programming)第一章，时间服务器到windows的移植"
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
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者学习网络编程时，将UNP时间服务器从Linux移植到Windows，解决了阻塞问题，并分享了Windows下需WSAStartup初始化等关键区别。

<!-- more -->

# 潜心开始学习网络编程的第一步，UNP(Unix Network Programming)第一章，时间服务器到windows的移植

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](http://www.jtianling.com)

[**讨论新闻组及文件**](ttp://groups.google.com/group/jiutianfile/)

学的如此之杂，绝不是我的初衷，但是事实已经形成了，还是按照刚工作时的计划，好好的学习网络技术吧。虽说我已远不是以前服务器组的成员了。。。虽说我其实开发了好几个服务器了，但是那是在公司的框架之上的，连套接字使用的机会都及其之少。。。实在谈不上什么网络编程的经验，那种开发基本上做好的包的映射和MFC的消息机制区别都不大了。

今天是调整心态并转换方向的第一天，本来以为没有什么好说的-_-!但是却给我碰到意外了。

UNPv1中最前面的时间客户端/服务器程序在我的Ubuntu中跑的没有效果-_-!

而且调试的时候都是直接分别在connect和accept上阻塞了，估计是网络可能没有调好，郁闷死了。

于是我将其中的时间服务器程序移植到Windows下了-_-!基本上相当于搬....

更改后源代码如下：

```c
#include <time.h>

#include "Winsock2.h"

#define MAXLINE 1000

int
main(int argc, char **argv)
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
    servaddr.sin_family      = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port        = htons(13);  /* daytime server */

    bind(listenfd, (struct sockaddr*)&servaddr, sizeof(servaddr));

    listen(listenfd, SOMAXCONN);

    for ( ; ; ) {
       connfd = accept(listenfd, (struct sockaddr*)NULL, NULL);

       ticks = time(NULL);
       _snprintf(buff, sizeof(buff), "%.24s/r", ctime(&ticks));

       // 相当诡异的write换成了send
       send(connfd, buff, strlen(buff),MSG_OOB);

       closesocket(connfd);
    }
}
```

然后通过Ubuntu上跑的客户端来连接这台windows上的服务器就好了-_-!莫名其妙。。。。。。可能还是属于我Linux下的配置和管理不太熟悉吧。。。但是运行服务器后，netstat却的确也没有看到服务器有监听端口啊。。。程序又没有问题....无奈了。

对于windows下的套接口使用源程序，有几点想说一下，因为我进入公司当时分配在服务器组，学的第一课是序列化，第二课就是网络基础啦，当时看的也是这本Stevens的经典著作。。。呵呵，都是将Unix环境的，所以当时在公司调试自己的Windows程序，光是因为没有使用WSAStartup初始化就卡了我大半天-_-!

的确是很诡异的用法，MS自己突发奇想加上的东西，我当时看的是UNP。。怎么会知道呢。。。。。那时候光是htonl, htons这种函数需要调用都不知道。。。。也不知道为什么要调用。。。。光是蒙着头乱蒙-_-!还好，现在还懂点皮毛了。呵呵

另外，原有的包装函数我都是直接用原始的函数替换了，也没有加错误判断，不是什么好习惯。仅作学习使用。

[**write by 九天雁翎 (JTianLing) -- www.jtianling.com**](http://www.jtianling.com)
