---
layout: post
title: "恐怖的boost库，难道还有什么是没有的吗？改变了对原有跨平台支持库开发想法。假如我以后不能使用boost库那怎么办啊？！"
categories:
- "网络技术"
tags:
- Boost
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '27'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者惊叹于Boost库的强大与全面，发现其已覆盖自己跨平台开发的所有构想，因此放弃了自研计划。

<!-- more -->

# 恐怖的boost库，难道还有什么是没有的吗？改变了对原有跨平台支持库开发想法。假如我以后不能使用boost库那怎么办啊？！

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](http://www.jtianling.com)

[**讨论新闻组及文件**](http://groups.google.com/group/jiutianfile/)

最近这段时间以理解asio为契机，开始学习了一些以前并不用到的boost库，慢慢的发现boost库的强大远超过我的想象，以前我也就用用boost库中的智能指针，后来TR1出来后，在学习正则表达式的时候，尝试用过其boost::regex这个以后肯定会进C++09标准的东西，其他东西用的还真是不多，毕竟工作中学习的时间还是少了些，公司的开发又完全不准用boost的，加上又有太多东西要学，直到最近说要学习网络编程的相关知识，然后找到了asio，才开始又一次的慢慢接触boost库了，再加上学习python的过程中，不断的对C++现有体系进行了反思（其实主要还是语法上的，毕竟我层次还没有那么高），常常回过头来看看C++中的对应用法，虽然这里将一个超级慢的动态语言的语法优点来和以效率为生命的C++来对比不是太公平，但是起码我加深了对很多东西的理解，在连续的三篇文章中可以得到体现：

分别是《[多想追求简洁的极致，但是无奈的学习C++中for_each的应用](http://www.jtianling.com/archive/2009/05/15/4187209.aspx)》，《[其实C++比Python更需要lambda语法，可惜没有。。。。](http://www.jtianling.com/archive/2009/05/21/4205134.aspx)》，《[boost::function，让C++的函数也能当第一类值使用](http://www.jtianling.com/archive/2009/05/27/4219043.aspx)》，其实，也许还可以为boost::bind专门写一篇，但是后来觉得自己对嵌套反复的bind语法还是比较反感，就作罢了，虽然boost::bind比现在标准库中的bind1st,bind2nd加一大堆的mem_funXXX的东西优美一些，但是即便新的标准加上bind,加上mem_fn，其实感觉还是在语言上打补丁一样，还不是那么的优美，唉。。。具体要多优美，这个我也就不好说了。。。。。。。弱弱的说一句，看看python的列表解析。。。。

但是，对boost库的进一步了解，倒是让我对自己写一个可移植网络框架的心少了很多，一方面的确也是精力不太够，另一方面我发现自己没有办法写的比boost中现有的更好（也许能更加精简）。这里将原有的计划列出来，对比一下boost中已经有的东西。详细计划见原来的文章《**[工作之外的学习 /开发计划(1) -- windows/linux服务器程序支持库的开发](http://www.jtianling.com/archive/2008/09/29/2998733.aspx)**》

**[工作之外的学习 /开发计划(1) -- windows/linux服务器程序支持库的开发](http://www.jtianling.com/archive/2008/09/29/2998733.aspx)**

简化服务器程序的开发，设计合理的服务器框架程序。 \--- 主要目的

实现工程文件（对我来说一般就是服务器程序）以同一套源码在windows和linux下的编译运行。 \-- 次要目的，但是必完成-_-!

其实对于支持库来说，很重要的一点来说，就是尽量对外实现操作系统无关的同一套接口。。。。

需求列表：（仅仅是知识还非常欠缺的我目前能想到的，以后需要再添加吧）

网络框架支持：

windows服务器TCP用IOCP模型

linux服务器TCP用epoll模型

UDP都用同一套

另外，为简单的网络应用程序（其实在我们公司中是客户端跑的）使用select模型。（就目前我浅显的网络知识了解，我不明白为什么要这样，select其实也是属于I/O复用的模型了，但是实际客户端方面用的都是单套接字，单连接，单处理线程，难道仅仅是为了防止输入阻塞和套接字API阻塞的冲突？）

服务器其他支持库

1. 序列化支持。
2. 日志系统支持。
3. 脚本语言配置文件支持。（可考虑上脚本系统）
4. 运行时异常dump支持。
5. 多线程支持。（其实看很多书说Linux下弄单进程更好，但是那样和windows下共用一套源码估计就更难了。）
6. windows下也能跑的posix库。
7. ODBC库/mySQL API 支持库(任选)
8. 多进程支持（待选）。

这里给出一个boost中已有实现的对比。。。

首先，我的目标。。。。可移植的网络框架，以简化开发服务器为目的。。

boost作为准标准库可移植性实在是做的够好了。。。。看看其文档中支持的编译器/环境列表就知道了，远超我以前的目标Windows/Linux可移植。。。。

其次，核心模块，网络框架，boost::asio的实现就是和我原有设想的实现一模一样。。。。。windows用IOCP模型，linux用epoll，并且作为一个已经获得较广泛使用的轻量级网络支持库，见《[Who is using Asio?](http://think-async.com/Asio/WhoIsUsingAsio) 》并且甚至可能进入下一版的C++标准（虽然个人认为可能性还是比较小），还是远超我以前的目标。。。。。当然，我从来没有目标去达到想ACE一样，asio就很不错了。

然后，其他支持库：

1.序列化支持。==》boost::serialize库，强大，强大，还是强大，我有一系列文章，介绍了其强大和使用方法。《[序列化支持(1)](http://www.jtianling.com/archive/2009/03/12/3985785.aspx)》，《[序列化支持(2)—Boost的序列化库](http://www.jtianling.com/archive/2009/03/19/4006122.aspx)》，《[序列化支持(3)—Boost的序列化库的使用](http://www.jtianling.com/archive/2009/03/25/4025162.aspx)》，《[序列化支持(4)—Boost的序列化库的强大之处](http://www.jtianling.com/archive/2009/04/21/4096147.aspx)》。但是比较遗憾的是，虽然据说BS以前很遗憾的说，现在C++中最大的遗憾就是没有数据持久化和垃圾回收机制的话，但是，boost::serialize似乎还是没有希望进入下一版C++标准，也就是说，我们以后的C++只能还是没有一个标准的序列化方式可以使用。。。。

2.日志系统支持。==》这个boost种据说以前有过，但是后来停止开发了，最近也在某个地方看到过一个使用标准iostream的日志库，一下子没有找到，但是其实实在没有，用[log4cxx](http://erera.net/blog/tag/logging)也不错。再没有自己写一个也不难（在公司我就完成过用额外的线程写日志的工作，包括测试也就用了一天时间）

3. 脚本语言配置文件支持。（可考虑上脚本系统）==》这点更好了，boost::[Program Options](http://www.boost.org/doc/libs/1_39_0/doc/html/program_options.html)就是完全对应的选择，并且，假如我想用Python，我还可以不仅仅是使用Python的C API，个人感觉要完全用Python C API去映射C++的类相对来说还是比较难，但是有了boost::Python库又不一样了。。。。生活可以更美的。

4.运行时异常dump支持。==》这个嘛。。。。除了我以前研究过的google的breakpad似乎不知道还有其他更好的选择没有，实在不行也就只能自己做了。注意啊，这个dump不仅仅是出错/异常的时候，我应该能在我需要的任何时候进行core dump，而不影响程序的运行。

5.多线程支持。==》天哪。。。boost::thread库就是为这个准备的，并且其实现的确不错，虽然假如自己要实现一套也不算太难。

6. windows下也能跑的posix库。==》虽然说boost::System库设计的就像是错误代码集合库，但是在大量的使用boost库后，posix的很多功能有没有必要使用还难说。。。。。比如说boost::[Filesystem](http://www.boost.org/doc/libs/1_39_0/libs/filesystem/doc/index.htm),boost:: [Date Time](http://www.boost.org/doc/libs/1_39_0/doc/html/date_time.html)的支持作用还是很强的

7. 多进程支持==》创建进程的方式在Windows(CreateProcess)和Linux（Fork）下的差异还是有的，但是也不是完全不能统一，麻烦点的就是Windows没有僵尸进程的概念导致进程ID不能真正区别出一个进程，比如说一个ID100的进程关闭了，然后一个新的进程启动后ID为100，并且父子进程之间的联系比Linux下要弱的多。，比如没有getppid系统调用，其实CreateProcess后，父进程将子进程的句柄都close后，两者就几乎没有关系了，可能仅有的联系就是子进程继承了父进程的核心对象列表,而Linux下子进程可是必须等待父进程来'收割的啊：）但是最最核心的问题还是IPC（进程通信）的问题，还好，boost:: [Interprocess](http://www.boost.org/doc/libs/1_39_0/doc/html/interprocess.html)又是完美的满足了需求

如上所述。。。一个可移植的网络服务器开发支持库，基本上也就是boost库的一个子集。。。。我们能使用的还有如boost::[Signals](http://www.boost.org/doc/libs/1_39_0/doc/html/signals.html)这样的库来实现网络包的分发及映射，有如智能指针，[boost::funtion](http://www.jtianling.com/archive/2009/05/27/4219043.aspx), [boost::lambda](http://www.jtianling.com/archive/2009/05/21/4205134.aspx), boost::bind，[boost::foreach](http://www.jtianling.com/archive/2009/05/15/4187209.aspx)来简化我们的程序，这个C++的世界还能更加美好吗？。。。。。。。呵呵，除非等下一代C++的标准出来了。。。。。

也许，使用boost库唯一的问题是。。。。让我使用了这么好用的库，假如我以后不能使用boost库那怎么办啊？！

呵呵，当然，总是要在自己的程序中带上很多的boost库的dll，其实也算是个问题。

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](http://www.jtianling.com)
