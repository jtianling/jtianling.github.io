---
layout: post
title: ASIO—下一代C++标准可能接纳的网络库（1）简单的应用
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
  views: '31'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# ASIO—下一代C++标准可能接纳的网络库（1）简单的应用

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

# 一、   综述

       第一次看boost::asio的文档，觉得非常详细，可是因为boost库的惯例，与其他boost库结合的比较紧密，而个人除了对一些很基础的boost库,比如智能指针，还有正则表达式boost::regex有所了解外，以前对boost库还是没有太多的了解的，为了很好的学习和了解boost::asio，我做了很多前期工作，到今天，总算可以正式的开始boost::asio的学习了，另外，今天，从使用开始，对asio的学习作为前段时间网络编程方面学习的一种延续，不是像其他boost库一样，仅仅会使用即可，我要的是深入其原理及精髓。。。。（其实已经知道boost::asio在windows下使用的是完成端口，在Linux下使用的是EPoll）

基本上，asio的文档很详尽也是有道理的（从Overview,到Tutorial到Examples到Reference一共870页），作为一个封装良好的网络(接口？)库，虽然对普通的网络接口进行了很详尽的封装，但是因为网络程序本身的复杂性，asio在使用方式上的复杂度还是比较大，这在B.S.的语言中是，绝对复杂的事情需要相对复杂的工具来解决。

 

# 二、   Tutorial

首先，从使用上对ASIO库进行一定的了解，因为文档如此的详尽，Tutorial解释如此的精细，我就不再干C-C,C-V的工作了，也就为E文不太好的兄弟们稍微解释一下各个例子，大家可以对照boost::asio的文档来看。

## 1.      Timer.1 - Using a timer synchronously（使用同步定时器）

就连asio库的使用也是从”Hello world”开始，可见K&R影响之深远。此例解释了展示了asio库的基本使用，包括包含boost/asio.hpp头文件，使用asio需要有boost::asio::io_service对象。还有asio::deadline_timer的使用（在此例中的使用和sleep区别不大）

 

## 2. Timer.2 - Using a timer asynchronously（使用异步定时器）

异步定时就是你写好函数等其调用的方式了，这里比同步多的复杂性在于你的函数/callable对象（称为handler）的编写，其他基本一样，不同的在于asio::deadline_timer的成员函数调用从wait换成了async_wait。

 

## 3.      Timer.3 - Binding arguments to a handler（绑定参数到handler）

已经是有点意思了的程序了，程序的复杂性上来了，在异步调用中继续异步调用，形成类似嵌套的结构，用expires_at来定位超时，用boost::bind来绑定参数。bind也算是比较有意思的boost库之一，也是几乎已经拍板进入下一代C++标准的东西了，值得大家去看看其文档：）

 

## 4.      Timer.4 - Using a member function as a handler

基本上也就是例3的一个类的翻版，展示的其实也就是boost::bind对于类成员函数的绑定功能，比起例三并没有太多新意（假如你熟悉boost::bind库的话，呵呵，还好我扎实过boost基本功），并且因为无端的使用了类结构，增加了很多程序的复杂性，当然，对于在一个类中组织类似的程序还是有一定的指导意义。

 

## 5.      Timer.5 - Synchronising handlers in multithreaded programs

加入了多线程的实现，展示了boost::asio::strand类在多线程程序中同步回调handler的用法。

这里我看到几个关键点，首先，asio保证，所有的回调函数只在调用了io_service::run()函数的线程中才可能被调用。其次，假如需要多个线程同时能调用回调函数(其实这里都不算太准，因为callable的东西都行，这里用callback object也许更好)，可以再多个线程中调用io_service::run()，这样，可以形成一种类似线程池的效果。

这里展示的同步方式是将多个callback object用一个strand包装起来实现的。其实，用其他的线程同步方式明显也是可行的。

没有展示太多asio的新东西（假如你熟悉boost::thread的话，关于boost::thread可以参考《**[boost::thread 库，奇怪的文档没有Tutorial的库，但是却仍然相当强大](<http://www.jtianling.com/archive/2009/06/06/4246470.aspx>)**》，呵呵，关于boost的学习不是白学的：），懂的了一些相关库，看asio的例子起码是没有难度的。。。。。想当年我第一次看的时候那个一头雾水啊。。。。。

其实按文档中的例子还可能让初学者有点不清楚，

将原文中的两句改为（不会还要问我是哪两句吧？-_-!以下是在Windows中的例子）

           std::cout <<"ThreadID:" <<GetCurrentThreadId() <<" Timer 1: " << count_ << "/n";

           std::cout <<"ThreadID:" <<GetCurrentThreadId() <<" Timer 2: " << count_ << "/n";

这样的形式，那么就能很显著的看到多个线程了。

boost::thread t(boost::bind(&boost::asio::io_service::run, &io));

这样的形式其实是利用boost::thread库创建了一个新的线程，创建新线程的回调又是利用了boost::bind库绑定类成员函数的用法，传递&io作为成员函数的第一参数this，调用io_service::run（），紧接着主线程又调用了io.run()，这样就形成了同时两个线程的情况。

 

## 6.      MyExample1：Synchronising handlers in multithreaded programs in normal way

这里展示不用boost::asio::strand而是利用常规线程同步的手段来完成线程的同步。

 

```cpp
#include <iostream>
#include <boost/asio.hpp>
#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <boost/bind.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>

class printer
{
public:
    printer(boost::asio::io_service& io):
       timer1_(io, boost::posix_time::seconds(1)),
       timer2_(io, boost::posix_time::seconds(1)),
       count_(0)
    {
      timer1_.async_wait(boost::bind(&printer::print1, this));
      timer2_.async_wait(boost::bind(&printer::print2, this));
    }
    ~printer()
    {
      std::cout << "Final count is " << count_ << "/n";
    }
    void print1()
    {
      mutex_.lock();
      if (count_ < 10)
      {
          std::cout <<"ThreadID:" <<GetCurrentThreadId() <<" Timer 1: " << count_ << "/n";
          ++count_;
          timer1_.expires_at(timer1_.expires_at() + boost::posix_time::seconds(1));
          timer1_.async_wait(boost::bind(&printer::print1, this));
      }
      mutex_.unlock();
    }
    void print2()
    {
      mutex_.lock();
      if (count_ < 10)
      {
          std::cout <<"ThreadID:" <<GetCurrentThreadId() <<" Timer 2: " << count_ << "/n";
          ++count_;
          timer2_.expires_at(timer2_.expires_at() + boost::posix_time::seconds(1));
          timer2_.async_wait(boost::bind(&printer::print2, this));
      }
      mutex_.unlock();
    }

private:
    boost::asio::deadline_timer timer1_;
    boost::asio::deadline_timer timer2_;
    int count_;
    boost::mutex mutex_;
};

int main()
{
    boost::asio::io_service io;
    printer p(io);
    boost::thread t(boost::bind(&boost::asio::io_service::run, &io));
    io.run();
    t.join();
    return 0;
}
```

 

这样的效果和原boost::asio的例5是差不多的，boost::asio除了支持原生的线程同步方式外还加入了新的asio::strand是有意义的，因为这两种方式还是有区别的。

1.     用mutex的方式阻塞的位置是已经进入printe函数以后，而strand是阻塞在函数调用之前的。

2.     相对来说，当大量的同样回调函数需要同步时，asio::strand的使用更为简单一些。

3.     用mutex的方式明显能够更加灵活，因为不仅可以让线程阻塞在函数的开始，也可以阻塞在中间，结尾。

4.     对于同步的对象来说，asio::strand就是对其支持的回调对象，mutex是对本身线程的一种同步。

 

基本上，两者是相辅相成的，各有用处，但是实际上，假如从通用性出发，从额外学习知识触发，个人感觉strand似乎是可有可无的，不知道有没有必须使用strand的情况。。。。

 

到此，asio文档中tutorial中的timer系列例子是结束了。其实这里展示的以asio基本原理为主，甚至都还没有接触到任何与网络相关的东西，但是，这些却是进一步学习的基础。。。。。。

 

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)