---
layout: post
title: "一天一个C Run-Time Library 函数（8）  assert"
categories:
- C++
tags:
- assert
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

## 一天一个C Run-Time Library 函数（8）  assert

write by 九天雁翎(JTianLing) -- www.jtianling.com

 

## msdn:

Evaluates an expression and, when the result is **false** ,  
prints a diagnostic message and aborts the program.

   
---
```c
void
assert(   int _expression_ );
```

## 测试程序：

无

## 说明：

assert实在是所有C语言运行库中用的最多的函数之一，这么说可能有些让人惊讶，事实上却很容易让人接受，除了用于日志记录和控制台输出的函数printf+文件一族函数，还有哪个函数会被频繁的调用啊。

这里说明一下，其实虽然assert在debug的时候肯定不会调用，但是其实你可以定义一个宏，比如我们公司JTASSERT来替代assert,然后用另外一个宏作为开启开关，比如__JTASSERT__,这样，就算在debug版本下你也获得了是否使用断言的功能。另外，其实更进一步的用法是使用一个数字作为JTASSERT的参数，然后将__JTASSERT__的宏定为一个数值，然后只在参数的整数大于此宏定义数值的时候才真正调用assert，那么就实现了一个可控级别的断言函数。

再另外，一般的assert在release下就没有作用了，这时候还是想要断言的话，可以用abort函数自己来实现。

最后，用assert(false)；的形式可以断言你认为不会进入的分支，这在if-else if的多重语句中，最后一个语句，还有switch的default分支中使用，价值很大。

** **

## 实现：

MS:

基本上没有什么太多技术含量，就不贴了，说下流程，无非就是先判断是否是控制台的程序，然后用两条线来实现，控制台的从命令行输出错误信息，不是控制台的直接弹出对话框。（其实我自己都感觉这样的分析和事实有出入，因为以前写的服务器在控制台下也是弹出对话框的）到最后都是调用abort函数实现，其实最想不到的是微软竟然也会用abort函数。。。。。。。。呵呵

gcc:

比MS的简单的更多，因为没有需要判断是否用GUI来提示，最后也是用abort来实现，代码也不贴了。

 

 

 

## 效率测试：

无

 

## 相关函数：

abort

## 个人想法：

真正健壮的代码就是一直在干你想干的事情，出现异常或错误也能恢复。但是事实上，出现异常和错误能够让你知道，这也是很重要的，特别是与很多人一起调试的时候。这个时侯，assert就是很重要的了，比如参数的检验，自赋值的预防，等等都是可以给你省下很多调试的时间。其实，很多时候，设计的时间要远远大于编码的时间。而调试的时间又会大于设计的时间，这是我在刚学习编程的时候所不能想想的。。。。。但是工作中感受到了。

 2009.1.24后补：其实assert的实现还是有点意思的，当时只是随便看了下assert.c文件，所以那样说，今天再看《C陷阱与缺陷》的时候发现了这一点，我在这里补上：

#define assert(_Expression) (void)( (!!(_Expression)) || (_wassert(_CRT_WIDE(#_Expression), _CRT_WIDE(__FILE__), __LINE__), 0) )  

assert是个宏，大部分人可能都不会惊讶，不然也达不到debug时有效，release时无效的效果，但是最有意思的是判断是否需要弹出异常的方式，并没有使用if-的判断方式，仅仅是为了避免宏的副作用。假如是用if方式实现的话，当在外部通过

```c
if(someEx)
    assert(someEx);
else
    assert(someEx);
```

的形式使用时，会使得else与assert中的if配对，而发生问题。。。。所以通过&&,||的计算顺序特性来完成：）又是一个C语言的小技巧啊。。。。太多这样的奇技淫巧了-_-!

  

 

write by 九天雁翎(JTianLing) -- www.jtianling.com