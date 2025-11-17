---
layout: post
title: "从Unix的echo与Dos的type之间的区别，看操作系统之间的软件设计哲学的不同"
categories:
- "随笔"
tags:
- echo
- Unix
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '20'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie](<http://www.jtianling.com>)  
**  

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)  

本文其实仅仅是写  
《各种进程创建方式比较总结(MacOS, Win32, Linux, Qt,  
Python…………)》一文时的过度发挥，发现插入大段无关文字有点问题，就给剥离出来了，也算一次文章的重构。。。。。  
从Unix的echo  
命令与Dos的type命令，从基本使用上来说，都是用于显示文件内容的，但是大致的使用一致，却有一些细微的差别，这些细微的差别，让我挺有感触，于是  
借题发挥了，也算无聊一把。但是，毫不夸张的说，两个小命令，展示了两个不同的世界。

## 比较手段  

    1,  
最简单的创建一个带参数的进程,以显示当前目录下的文件a,文件b的内容为例。  
     
2，展示进程的输出重定向使用，以将当前目录下的文件a,文件b定向到文件c中为例。  
     
3，展示进程间的管道通信技术，以将当前目录下的文件a,文件b通过管道传递给另外一个输出的进程，并且显示。  
    
 （以下简称Test1，2，3）。  
以上述三个操作，显示echo及type的不同。

## Test1:  

1.  
从最简单的开始吧，先以Unix下的Bash为例了。

jtianling$ echo "I'm File A."  
> a  
jtianling$ echo "I'm File B." > b  
jtianling$ ls  
a    
 b  
jtianling$ cat a  
I'm File A.  
jtianling$ cat b  
I'm File B.  
jtianling$  
cat a b  
I'm File A.  
I'm File B.  
jtianling$   
好了，cat a  
b，这样简单的调用，进程创建完成，参数输入完成，显示正常。

  

## Test2:  

2.输出重定向，对于  
Shell来说实在是小case，那简直可以说是其原生的。

TianLings-MacBook:test jtianling$ cat  
a b > c  
jtianling$ cat c  
I'm File A.  
I'm File B.  
jtianling$  
  
cat a b > c一句而已。

  

## Test3:  

3.管道，还是Shell饭碗里  
面的内容。

jtianling$ cat a b | cat  
I'm File A.  
I'm File B.  
cat  
a b | cat还是一句代码而已。  

  

## DOS中type的对比：  

## Test1:  

  

DOS  
下，type命令也可以完全按照上述方式尝试一次:

Test1,基本可用，也就是输出嘛，但其实,仔细看看DOS下的  
type命令,会发现其实输出有些许不同:

F:/MySrc/TestProcess>type a b

a

I'm  
File A.

b

I'm File B.  

  
直观来看,type a  
b时自动的将a,b文件按文件名给你排下版,多人性化啊?呵呵,但是,很明显的可以看出DOS开发者的文化(MS特有?)与UNIX社群的文化差  
异.UNIX中提倡命令行程序不要输出废话(比如上面的a,b及排版),这样才能够通过管道或者重定向更多的重复被其他程序使用,DOS似乎提倡给人直接  
看.......

  

## Test2:  

实践发现，虽然直接的输出会有额外输出，但是type命令的对于重  
定向时进行了处理:

F:/MySrc/TestProcess>type a b > c

a

b

F:/MySrc/TestProcess>type  
c  
I'm File A.  
I'm File B.  

会发现重定向后的结果与cat a b >  
c完全一样.但是a,b的格式还是输出了，说明a,b格式的输出根本走的不是标准输出通道。那剩下什么？标准错误通道。。。我们测试一下。

>type  
a b 2>d  
I'm File A  
I'm File B

>type d

a

b

>  

  

果  
然如此，当把错误通道重定位到文件d中时，可以看到输出了精简的输出，并且可以看到d中的内容就是附加的输出。用较为复杂的hack手段，（利用错误输出  
来输出正常的信息，总之不是什么好手段）实现其实不算太必要的但是有点用的任务，是好是坏，就看个人意见了。

  

## Test3:  

会  
发现,type其实是无法接受标准输入的,也就是,无法形成 | type的链式调用,就像cat a b | cat一样.

这样会导致  
Test3无法使用type完成。这也算文化差异吧......因为Unix的Shell使用的习惯，管道及重定位几乎是命令行必备的协作工  
具，DOS/Windows程序没有此传统，所以没有实现，也就可以理解了。更进一步的说，Win32  
API甚至没有对管道及输入输出重定向有任何直接的支持，因为似乎根本就不在意，而POSIX的pipe,popen对于相关使用的支持却能做到非常方便  
快捷。（当然，其实Windows中也有POSIX的函数的一些实现，就包括pipe,popen，但是命名前加下滑线）

  

## 小  
结：  

所以,对于type命名来说,描述为:TYPE Displays the contents of a text file. 

对  
于cat命令,man中描述为:Concatenate FILE(s), or standard input, to standard  
output.

而且,查查cat的参数就会发现,cat其实还有很多定制功能,但是type呢?估计只有/?参数  
吧............

因为Unix以前相当依赖于Shell，（以前只有Shell)，加上其文化的影响，加上工作需要，每个  
Shell命令都是比较强大，并且协作性非常好（因为那古老的规则），其中最最典型的就是find,grep有意者去尝试一下就知道了。另外，其实说命令  
的话。。。。那perl,python算不算一个命令呢？。。。。。。呵呵，扯远了。

  

  

  

 

原创文章作者保留版  
权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie](<http://www.jtianling.com>)  
**  

