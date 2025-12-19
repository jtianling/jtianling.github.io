---
layout: post
title: ASIO—下一代C++标准可能接纳的网络库（2）TCP网络应用
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
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

通过对比传统Socket API，本文讲解Boost.Asio的TCP应用开发。Asio代码更简洁且跨平台，但学习曲线陡峭，作者期待其成为C++标准。

<!-- more -->

# ASIO—下一代C++标准可能接纳的网络库（2）TCP网络应用



# 一、 综述

本文仅仅是附着在boost::asio文档的一个简单说明和讲解，没有boost::asio文档可能你甚至都不知道我在讲什么，boost::asio的文档自然是需要从[www.boost.org](<http://www.boost.org/>)上去下。

基本上，网络编程领域的”Hello World”程序就是类似Echo，daytime等服务器应用了。大牛Stevens经典的《Unix Network Programming》一书更是在这两个服务器上折腾了半本书，Comer的《Internetworking With TCP/IP vol III》也不例外。boost::asio的文档也就更不例外了，全部的网络方面的例子都是以daytime服务为蓝本来讲解的。呵呵，大家这样做是有道理的，毕竟从讲解网络编程的原理来看，echo,daytime等足够的简单：）

# 二、 Tutorial

首先，因为客户端程序相对服务器程序更为简单，所以一般都从客户端开始，boost::asio也是如此，第一节，给出了一个TCP 的Daytime的实现所谓示例，这里，我不拷贝其源码了，只是列出一个用windows 下用套接字接口实现的同样程序作为对比。

## 1. A synchronous TCP daytime client（一个同步的TCP daytime客户端程序）

原始的套接字实现：

```c
#include <stdio.h>
#include <string.h>
#include "Winsock2.h"
#include "errno.h"
#include "stdlib.h"

#define MAXLINE 1000

void str_cli(SOCKET sockfd)
{
    char recvline[MAXLINE] = {0};
    while ( (recv(sockfd, recvline, MAXLINE, 0)) != NULL) 
    {
       printf("%s", recvline);
    }
    closesocket(sockfd);
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

    str_cli(sockfd);     /* do it all */

    system("pause");
    exit(0);
}
```

共六十一行，并且需要处理socket创建，初始化等繁琐细节，做任何决定时基本上是通过typecode，其实相对来说也不算太难，因为除了socket的API接口属于需要额外学习的东西，没有太多除了C语言以外的东西需要学习，并且因为BSD socket是如此的出名，以至于几乎等同与事实的标准，所以这样的程序能被大部分学习过一定网络编程知识的人了解。

为了方便对比，我还是贴一下boost::asio示例中的代码：

```cpp
#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>
using boost::asio::ip::tcp;

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
       tcp::resolver resolver(io_service);
       tcp::resolver::query query(argv[1], "daytime");
       tcp::resolver::iterator endpoint_iterator = resolver.resolve(query);
       tcp::resolver::iterator end;
       tcp::socket socket(io_service);
       boost::system::error_code error = boost::asio::error::host_not_found;
       while (error && endpoint_iterator != end)
       {
           socket.close();
           socket.connect(*endpoint_iterator++, error);
       }
       if (error)
           throw boost::system::system_error(error);
       for (;;)
       {
           boost::array<char, 128> buf;
           boost::system::error_code error;
           size_t len = socket.read_some(boost::asio::buffer(buf), error);
           if (error == boost::asio::error::eof)
              break; // Connection closed cleanly by peer.
           else if (error)
              throw boost::system::system_error(error); // Some other error.
           std::cout.write(buf.data(), len);
       }
    }
    catch (std::exception& e)
    {
       std::cerr << e.what() << std::endl;
    }
    return 0;
}
```

boost::asio的文档中的实现也有47行，用了多个try,catch来处理异常，因为其实现的原因，引入了较多的额外复杂度，除了boost::asio以外，即便你很熟悉C++,你也得进一步的了解诸如boost::array, boost:system等知识，（虽然其实很简单）并且，从使用上来说，感觉并没有比普通的socket API简单，虽然如此，boost::asio此例子还是有其优势的，比如ipv4,ipv6的自适应（原socket API仅仅支持ipv4），出错时更人性化的提示(此点由C++异常特性支持，相对比C语言中常常只能有个error code)。

当然，此例子过于简单，而asio是为了较大规模程序的实现而设计的，假如这么小规模的程序用原始的套接字就足够了。这点是需要说明的。

## 2. Daytime.2 - A synchronous TCP daytime server（同步的TCP daytime服务器）

有了客户端没有服务器，那客户端有什么用呢？^^所以，接下来boost::asio适时的给出了一个daytime的服务器实现，这里还是先给出使用一个原始套接字的例子：

```c
#include <time.h>
#include "Winsock2.h"
#include "errno.h"
#include "stdlib.h"

#define MAXLINE 1000
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

    SOCKET               listenfd, connfd;
    struct sockaddr_in   servaddr;
    char              buff[MAXLINE];
    time_t            ticks;

    listenfd = socket(AF_INET, SOCK_STREAM, 0);

    ZeroMemory(&servaddr, sizeof(servaddr));
    servaddr.sin_family      = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port        = htons(13);  /* daytime server */

    if( bind(listenfd, (struct sockaddr *) &servaddr, sizeof(servaddr))
        == SOCKET_ERROR) 
    {
           printf("bind failed: %d/n", WSAGetLastError());
           closesocket(listenfd);
           WSACleanup();
           return 1;
    }

    if (listen( listenfd, SOMAXCONN ) == SOCKET_ERROR)
    {
       printf("Error listening on socket./n");
       WSACleanup();
       return 1;
    }

    for ( ; ; ) 
    {
       connfd = accept(listenfd, (struct sockaddr*) NULL, NULL);
       if (connfd == INVALID_SOCKET) 
       {
           printf("accept failed: %d/n", WSAGetLastError());
           closesocket(listenfd);
           WSACleanup();
           return 1;
       } 

       ticks = time(NULL);
       _snprintf(buff, sizeof(buff), "%.24s/r/n", ctime(&ticks));
       if( SOCKET_ERROR == send(connfd, buff, strlen(buff), 0))
       {
           printf("send failed: %d/n", WSAGetLastError());
           closesocket(connfd);
           WSACleanup();
           return 1;
       }
       closesocket(connfd);
    }

    WSACleanup();
    return 0;
}
```

全程序75行，大部分用于socket的初始化，及其状态的转换，直到真正的进入监听状态并开始接受连接，每个socket API的调用都需要判断返回值，这也算是C语言程序共同的特点。

另外，看看boost::asio的实现。

```cpp
#include <ctime>
#include <iostream>
#include <string>
#include <boost/asio.hpp>
using boost::asio::ip::tcp;

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
       tcp::acceptor acceptor(io_service, tcp::endpoint(tcp::v4(), 13));
       for (;;)
       {
           tcp::socket socket(io_service);
           acceptor.accept(socket);
           std::string message = make_daytime_string();
           boost::system::error_code ignored_error;
           boost::asio::write(socket, boost::asio::buffer(message),
              boost::asio::transfer_all(), ignored_error);
       }
    }
    catch (std::exception& e)
    {
       std::cerr << e.what() << std::endl;
    }
    return 0;
}
```

全程序35行，比使用原始套接字的版本省略了一半，并且还是保持着可移植性（我的例子只能在windows下运行）。

从其文档和实现来看，实现上将很多函数转化为类了，使用上也没有简化一些。。。做出这样的结论还是当我处于对socket API的熟悉程度要远大于boost::asio的情况。也许对于纯粹的初学者，要学习asio会比socket API简单更多一些。毕竟相当多的细节，比如各种情况下的错误返回，各类接口需要传入的适当的参数，甚至套接字初始化，状态的转换等等在boost::asio中都简化了太多。此例中的例子就是accept函数在boost::asio中实现为了acceptor类。

另外，这里值得说明一下，虽然BSD socket套接字属于事实上的标准，但是其实同一套程序不经过一定的更改要放在Linux,Windows上同时运行是不可能的，因为其中总有些细微的差别，总记得刚开始工作的时候，拿着《Unix Network Programming》在Windows下去学习，结果一个小程序都用不了。。。结果是完全不知道Windows下特有的WSAStartup初始化-_-!但是boost::asio就彻底的消除了这样的差别。这也应该算是boost::asio的一个优势吧。

## 3. An asynchronous TCP daytime server（异步TCP daytime服务器）

与原有asio的简单应用一样，从第三个例子开始就已经是有点意思了的程序了，程序的复杂性上来了，异步相对同步来说效率更高是不争的事实，并且其不会阻塞的特性使得应用范围更广，并且异步也是大部分高性能服务器实际上使用的方式，比如Windows下的完成端口，Linux下的Epoll等，asio的底层就是用这些方式实现的，只不过将其封装起来，使得使用更加简单了。这里提供异步的例子就不是那么简单了-_-!呵呵，偷懒的我暂时就不提供了。其实用select也是可以模拟出异步的特性的，asio在操作系统没有很好的支持异步特性的API时，就是利用select模拟出异步的。但是作为select的例子，可以参考我以前学习时写的《**[服务器 Select模型的实现](<http://www.jtianling.com/archive/2009/03/02/3948204.aspx>)**》**。******

例子中用tcp_server类处理accept事件，用tcp_connection类来处理连接后的写入事件，并且用shared_ptr来保存tcp_connection类的对象。

总结：

boost::asio的确在某种程度上简化了网络客户端/服务器程序的编写，并且易于编写出效率较高的网络应用，（效率能高到什么程度没有实测）但是，作为与C程序员一脉相承的C++程序员，在完全不了解诸如asio:: async_write，asio:: async_accept等函数的实现时有多大的胆量去放心使用，这是个问题。说要去真的理解其实现吧。。。那么就将陷入真正的boost精密C++技巧使用的泥潭，因为boost::asio与其他boost库结合的是如此的紧密，特别是boost::bind,而boost::bind现在的实现实在不是那么优美，并且在下一版的C++标准中variadic templates的加入，是会使其实现简化很多的，这样说来，用boost::asio还是不用。。。是个问题。也许真正能让人下定决心在项目中使用boost::asio的时候，就是在下一代C++标准中其变成了std::asio的时候吧^^

