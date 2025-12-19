---
layout: post
title: ASIO—下一代C++标准可能接纳的网络库（3）UDP网络应用
categories:
- "网络技术"
tags:
- ASIO
- Boost
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '16'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文通过UDP示例对比了ASIO与传统Socket API。作者指出，ASIO在同步编程中优势不大，但在异步服务器端能显著简化开发，体现其价值。

<!-- more -->

# ASIO—下一代C++标准可能接纳的网络库（3）UDP网络应用

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****


# 一、 综述

接着前面

《[ASIO—下一代C++标准可能接纳的网络库（1）简单的应用](<http://www.jtianling.com/archive/2009/06/07/4248655.aspx>)》

《[ASIO—下一代C++标准可能接纳的网络库（2）TCP网络应用](<http://www.jtianling.com/archive/2009/06/07/4249975.aspx>)》

继续，讲了简单应用，讲了TCP,自然而然是UDP了。其实个人感觉UDP与TCP的接口假如经过封装是可以做到接口比较一致的，但是遗憾的是asio没有遵循这样的接口设计方案。

# 二、 Tutorial

## 1. Daytime.4 - A synchronous UDP daytime client（同步UDP daytime客户端）

还是先看看普通的socket API的情况：

```c
#include <stdio.h>
#include <string.h>
#include "Winsock2.h"
#include "errno.h"
#include "stdlib.h"

#define MAXLINE 1000

void str_cli(SOCKET sockfd, const struct sockaddr* pservaddr, int servlen)
{
    int n;
    char recvline[MAXLINE] = {0};
    char sendline[2] = {0};
    sendto(sockfd, sendline, 2, 0, pservaddr, servlen);

    n = recvfrom(sockfd, recvline, MAXLINE, 0, NULL, NULL);
    recvline[n] = 0;
    printf("%s", recvline);
}


int main(int argc, char **argv)
{
    WORD wVersionRequested = 0;
    WSADATA wsaData;
    int err;

    wVersionRequested = MAKEWORD( 2, 2 );

    // windows下此初始化为必须，实际是初始化WinsockDLL的过程
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

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    ZeroMemory(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(13);
    servaddr.sin_addr.s_addr = inet_addr(argv[1]);

    str_cli(sockfd, (const struct sockaddr*)&servaddr, sizeof(servaddr));

    system("pause");
    WSACleanup();
    exit(0);
}
```

相对来说，假如用了socket API，会发现UDP的程序编写逻辑是比TCP要简单的，起码省略了connect的过程，但是难就难在当网络情况不好时UDP程序的处理。这么简单的程序不再加更多说明了。

看看asio的例子:

```cpp
#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>
using boost::asio::ip::udp;

int main(int argc, char* argv[])
{
    try
    {
       if (argc != 2)
       {
           std::cerr << "Usage: client <host>" << std::endl;
           return 1;
       }
       boost::asio::io_service io_service;
       udp::resolver resolver(io_service);
       udp::resolver::query query(udp::v4(), argv[1], "daytime");
       udp::endpoint receiver_endpoint = *resolver.resolve(query);
       udp::socket socket(io_service);
       socket.open(udp::v4());
       boost::array<char, 1> send_buf = { 0 };
       socket.send_to(boost::asio::buffer(send_buf), receiver_endpoint);
       boost::array<char, 128> recv_buf;
       udp::endpoint sender_endpoint;
       size_t len = socket.receive_from(
           boost::asio::buffer(recv_buf), sender_endpoint);
       std::cout.write(recv_buf.data(), len);
    }
    catch (std::exception& e)
    {
       std::cerr << e.what() << std::endl;
    }
    return 0;
}
```

甚至没有感觉到有任何简化。一大堆的resolver(为了适应ipv6)，一大堆的array,其实并不优雅，在很简单的程序中，会发现，似乎asio就是简单的为socket进行了非常浅的封装一样，你还得了解一大堆本来可以不了解的东西，asio内在的高效率，异步啊，用的那些模式啊，都看不到。。。。。。。。。。呵呵， 也许socket API本来就是Make the simple things simple吧，而asio就是为了应付绝对复杂的情况而做出相对复杂设计的吧。这样的例子没有任何说服力能让人放弃socket API而使用asio。。。。。。。不知道asio的文档中加入这些干啥。。。仅仅为了说明？-_-!

## 2. A synchronous UDP daytime server（同步的UDP daytime服务器）

还是先来个原始的socket API写的版本：

```c
#include <time.h>
#include "Winsock2.h"
#include "errno.h"
#include "stdlib.h"

#define MAXLINE 1000

void str_svr(SOCKET sockfd, struct sockaddr* pcliaddr, int clilen)
{
    int n = 0;
    time_t ticks = 0;
    int len;
    char recvline[2] = {0};
    char sendline[MAXLINE] = {0};
    for(;;)
    {
       len = clilen;
       if( (n = recvfrom(sockfd, recvline, 2, 0, pcliaddr, &len)) == INVALID_SOCKET)
       {
            printf("recvfrom failed: %d/n", WSAGetLastError());
            return;
       }

       ticks = time(NULL);
       _snprintf(sendline, sizeof(sendline), "%.24s/r/n", ctime(&ticks));

       sendto(sockfd, sendline, strlen(sendline), 0, pcliaddr, len);
    }
}


int main(int argc, char **argv)
{
    WORD wVersionRequested = 0;
    WSADATA wsaData;
    int err;

    wVersionRequested = MAKEWORD( 2, 2 );

    // windows下此初始化为必须，实际是初始化WinsockDLL的过程
    err = WSAStartup( wVersionRequested, &wsaData );
    if ( err != 0 ) {
       return -1;
    }

    SOCKET               sockfd;
    struct sockaddr_in   servaddr,cliaddr;
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    ZeroMemory(&servaddr, sizeof(servaddr));
    servaddr.sin_family      = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port        = htons(13);  /* daytime server */

    if( bind(sockfd, (struct sockaddr *) &servaddr, sizeof(servaddr))
       == SOCKET_ERROR) 
    {
       printf("bind failed: %d/n", WSAGetLastError());
       closesocket(sockfd);
       WSACleanup();
       return 1;
    }

    str_svr(sockfd, (struct sockaddr*)&cliaddr, sizeof(cliaddr));

    closesocket(sockfd);
    WSACleanup();
    return 1;
}
```

与上篇文章中tcp服务器的例子很像，基本上来说，用socket写客户端还是相对简单一些，但是写个服务器就相对要复杂很多，这个例子还没有精细的判断每个返回值（比如send函数），但是已经比较复杂了。

接着是asio版本：

```cpp
#include <ctime>
#include <iostream>
#include <string>
#include <boost/array.hpp>
#include <boost/asio.hpp>
using boost::asio::ip::udp;

std::string make_daytime_string()
{
    using namespace std; // For time_t, time and ctime;
    time_t now = time(0);
    return ctime(&now);
}

int main()
{
    try
    {
       boost::asio::io_service io_service;
       udp::socket socket(io_service, udp::endpoint(udp::v4(), 13));
       for (;;)
       {
           boost::array<char, 1> recv_buf;
           udp::endpoint remote_endpoint;
           boost::system::error_code error;
           socket.receive_from(boost::asio::buffer(recv_buf),
              remote_endpoint, 0, error);
           if (error && error != boost::asio::error::message_size)
              throw boost::system::system_error(error);
           std::string message = make_daytime_string();
           boost::system::error_code ignored_error;
           socket.send_to(boost::asio::buffer(message),
              remote_endpoint, 0, ignored_error);
       }
    }
    catch (std::exception& e)
    {
       std::cerr << e.what() << std::endl;
    }
    return 0;
}
```

我甚至觉得在asio中写服务器比写客户端更加简单-_-!也许一开始asio就是为了写高性能服务器而设计的，所以导致写客户端相对那么麻烦，但是写服务器却又简单很多吧。不过，熟悉socket API对于使用asio也是有意义的，比如这里的receive_from,send_to不过是对应的socket API函数换汤不换药的版本而已，使用起来除了参数传递方式上的变化，最后效果一致。

## 3. An asynchronous UDP daytime server(异步 UDP daytime 服务器)

又是有点意思了的程序了，asio的命名就是表示异步的io，所以展现异步的程序才能体现asio的实力及其简化了底层操作的本事。TCP的应用是这样，这里也不例外。

不过出于UDP应用相对于TCP应用本身的简单性，所以这个示例程序比对应的TCP版本就要简化很多，只是，不知道asio的UDP实现了更丰富的UDP特性没有，比如超时重发等机制。。。。 

