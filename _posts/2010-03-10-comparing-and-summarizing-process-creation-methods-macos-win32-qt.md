---
layout: post
title: "各种进程创建方式比较总结(MacOS, Win32, Qt)"
categories:
- Python
tags:
- Python
- Qt
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '34'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文对比了Shell、C、Win32、Cocoa等多种平台的进程创建方式。通过执行重定向和管道等任务，指出Shell最简洁高效，而复杂的面向对象封装常导致代码冗长，设计应适度。

<!-- more -->



由于进程创建是非常基础，很重要的工作，由此导致的恶果就是每个系统自己都喜欢封装一套，以显示自己对其有原生的，较好的支持，但是，说实话，有的时候，那方式，实在是相当别扭，这里，我讲我了解的平台/系统下的进程创建方式统一的梳理总结一下，也顺便可以比较一下各个系统的API封装情况，窥一斑而见全豹嘛。这里很容易加入主观因素，也没有太多客观事实可以作为唯一的评定标准，那么，完成同样的工作，代码量少点总不是太坏的事情，仅以代码量为参考之一吧，参考之二就是大家自己的感觉了。毕竟其中一些地方无法做到公平,因为所有代码并不是以精简代码为首要目的,首要目的是适应对应接口的风格.

## 方式说明

1, 最简单的创建一个带参数的进程,以显示当前目录下的文件a,文件b的内容为例。

2，展示进程的输出重定向使用，以将当前目录下的文件a,文件b定向到文件c中为例。

3，展示进程间的管道通信技术，以将当前目录下的文件a,文件b通过管道传递给另外一个输出的进程，并且显示。

(以下简称Test1，2，3）。

## 1.Shell/DOS

1.从最简单的开始吧，Shell/DOS，这种简单的情况，Windows的DOS与Unix/Linux的Bash Shell下都差不多，以Bash为例了。（其实Windows下仅仅将cat换成type命令即可。。。。其实还是有些细微差别的，参看《从Unix的 echo与Dos的type之间的区别，看操作系统之间的软件设计哲学的不同》一文）以下因为type,dos命令的限制导致Windows下某些时候Test3无法完成，忽略之）

```bash
jtianling$ echo "I'm File A." > a
jtianling$ 
echo "I'm File B." > b
jtianling$ ls
a    b
jtianling$ cat a
I'm
File A.
jtianling$ cat b
I'm File B.
jtianling$ cat a b
I'm
File A.
I'm File B.
jtianling$ 
```

好了，cat a b，这样简单的调用，进程创建完成，参数输入完成，显示正常。

2.输出重定向，对于Shell来说实在是小case，那简直可以说是其原生的。

```bash
TianLings-MacBook:test jtianling$ cat a b > c
jtianling$ 
cat c
I'm File A.
I'm File B.
jtianling$ 
```

cat a b > c一句而已。

3，管道，还是Shell饭碗里面的内容。

```bash
jtianling$ cat a b | 
cat
I'm File A.
I'm File B.
```

cat a b | cat还是一句代码而已。

自此，Shell完成了全部任务，可以看到Shell这玩意儿不愧是为管理，调用进程而生的家伙，完成类似任务，那是信手拈来，毫不费劲，即便是最复杂的Test3，也没有超过一行，字符数（以下都不计空格）甚至没有达到两位数。当然，到了这里，离谱的简单，有人可能会说这种比较根本不应该加入Shell,甚至会觉得Shell参与此分类比较简直就是作弊。。。。。bash/bat也算是一种编程语言，而且为了进程调用的方便，牺牲了那么多，为啥不算呢？^^

## 2.C Runtime Library

这里运行环境是MacOS，Windows下还是得用type....利用了C Runtime Library的system函数。

Test1:

```c
#include <stdlib.h>

int
 main()
{
        system("cat a b");

        **return**



 0


;
}
```

结果：
Running…
I'm File A.
I'm File B.

Debugger stopped.
Program exited with status value:0.

OK，依次类推，接下来的也就就是按照Shell的调用方式换system的参数而已了，不重复描述了，简单计算，起码都是5行内解决问题。（自然分行，没有特别去缩减，也没有特别去增加，空行不算）有人又会说，这样使用完全是依靠了SHELL的强大，system函数不过是个简单的Shell调用而已。。。。根本不算数，C语言本身压根就不带进程创建功能-_-!但是。。。。任务完成了吧。。。Shell本身都算，依赖于Shell完成任务，只要任务能够很好的完成，为啥不算呢？

## 3.Python中的System

Python的OS模块中也有System这个C Runtime Library的函数，于是，第2种方法的好处其可以占尽，并且，因为Python作为脚本语言，少了很多负担，所以其实从完成任务的角度来说，要比C语言更加简单一些。当然，我不知道这不属于Python社区接受的方式，也即，不知道这算不算Pythonic。

```python
>>> 
import os
>>> os.system("cat a b")
I'm File A.
I'm
File B.
0
```

当然，能够如此简单，还是少不了Shell的功劳。

## 4.Win32 API WinExec/ShellExcute

这两个接口都好像不怎么推荐使用了,但是使用的简单性上还算是一个量级的.放在一起了.
Test1:

```c
#include <windows.h>

int
 _tmain(int
 argc, _TCHAR* argv[])
{
    WinExec("cmd /c type a b", SW_SHOW);

    getchar();
    **return**



 0


;
}
```

Test2与Test1类似,不累述了,Test3因为type不支持管道输入,所以无法完成.

## 5.Win32 API CreateProcess

CreateProcess其实是平时我在Windows下创建新进程使用最多的函数,因为可以获得新进程的句柄,可以进行很多额外的操作,比如让新进程先停止,甚至可以hack新进程,通过API直接对新进程的内存进行write操作.....呵呵,当时研究反外挂时的一些操作,平时用的其实也少.当时Wait相关API,只有获得CreateProcess返回的进程Handle才能进行.其实对与此API我以前特别有一文讲述了一些经验(其实是做一个笔记,防止忘记)< [Windows下的进程创建API--CreateProcess使用经验漫谈](<http://www.jtianling.com/archive/2009/08/02/4400500.aspx> "Windows下的进程创建API--CreateProcess使用经验漫谈")>

```c
#include <windows.h>
#include <stdio.h>
#include <tchar.h>

int
 _tmain( VOID ) {
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    LPTSTR szCmdline=_tcsdup(TEXT("cmd /c type a b"));

    ZeroMemory(&si, **sizeof**(si) );
    si.cb = **sizeof**(si);

    ZeroMemory( &pi, **sizeof**(pi) );

    // Start the child process.

    **if** ( !CreateProcess( NULL,  szCmdline, NULL, NULL, FALSE, 0,  NULL, NULL,  &si, &pi )) {
       printf( "CreateProcess  failed (  %d  ).  /n  " , GetLastError() );
       **return**


 0

;
    }
    // Wait until child process exits.

    WaitForSingleObject( pi.hProcess, INFINITE );

    // Close process and thread handles.

    CloseHandle( pi.hProcess );
    CloseHandle( pi.hThread );

    **return**


 0

;
}
```

纯C语言的接口,第一次看到此接口的时候简直懵了,后来用ShellExecute替代了,用到再后来,CreateProcess用多了,每次copy示例代码,竟然也慢慢觉得看的顺眼了,习惯的力量是强大的..........

## 6.MacOS Cocoa

下面看重头戏…………
Test1:

```objective-c
#import <Foundation/Foundation.h>

int
 main (int
 argc,
const
 char  * argv[]) {
     NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/cat"];
        
        NSMutableArray *args = [NSMutableArray array];
        [args addObject:@"a"];
        [args addObject:@"b"];
        // can be replace by －－ NSArray *args = [NSArray arrayWithObjects:@"a", @"b", nil];
        [task setArguments:args];       
        [task launch];
        [task waitUntilExit];
        
        [task release];

        [pool drain];
    return 0;
}
```

一共15行，Cocoa中对进程进行了封装，用NSTask来表示，并且将参数分割成一个一个字符串对象，组合起来成为一个Array后才能设定为参数，再然后，通过launch启动进程，通过waitUntilExit等待进程推出，再释放自己分配的NSTask对象，对了，Objective C程序中，为了适应没有垃圾收集的情况，还得好好的设定自动释放内存池。

Test2:
想投机取巧一下吧，利用Shell，如下：

```objective-c
NSMutableArray *args = [NSMutableArray array];
[args addObject:@"a"];
[args addObject:@"b"];
[args addObject:@">"];
[args addObject:@"c"];
```

你会得到如下错误信息：
I'm File A.
I'm File B.
cat: >: No such file or directory
cat: c: No such file or directory

Debugger stopped.
Program exited with status value:0.
这是行不通的。。。。Apple给了你封装，你就得用，抵抗只有死路一条。。。。。正确用法：(不知道还有没有更简单的，这个方法还是自己想到的。。。。试了试还真可以用。。。。）

```objective-c
#import <Foundation/Foundation.h>

int
 main (int
 argc,
const
 char  * argv[]) {
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/cat"];
        
        NSMutableArray *args = [NSMutableArray array];
        [args addObject:@"a"];
        [args addObject:@"b"];

        [task setArguments:args];

        NSFileManager *fm = [NSFileManager defaultManager];
        if  ([fm  createFileAtPath:@"c"  contents:nil  attributes:nil ] == FALSE) {
                NSLog(@"Can't  Create the file named c.");
                return  1;

        }
        
        NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:@"c"];

        [task setStandardOutput:fh];
        
        [task launch];
        [task waitUntilExit];
        [task release];
        
        [fh closeFile];
        
        [pool drain];
         return 0;
}
```

于是乎，你可以知道了，apple是崇尚学习的。。。。。因此，你又学会了好几个类，明白了好几个概念，NSFileManager不能直接创建文件然后返回NSFileHandle进行操作的设定难道是为了更好的实行类的分工？

Test3:
经历过Test1,Test2的洗礼后，应该会明白了，为啥苹果的笔记本起码都要7千多，苹果的一个外接完整键盘都要500多,一根破转接线都要200（见《[看到苹果的把视频转接线当金条卖，我彻底怒了。。。。。。。](<http://www.jtianling.com/archive/2010/03/10/5363244.aspx>)》生产效率太低估计是原因之一(可是苹果很多东西不都是中国组装的吗?)。。。。-_-!为啥与苹果粉丝的宣传的好像不大一样啊。。。。原因我也不知道，用苹果最大的感受是Mac Book的Fx键都被笔记本的特性完全占用，苹果自己默认设定的一些快捷键都会形成冲突，XCode的调试常用键你都得用3个以上的键组合才能按出。。。。人性化的设计极大的培养了用户手指的灵活度。（别说可以改，VS,Eclipse,Qt Creator的调试常用快捷键为啥都只用Fx键一键调用是有原因的，这个道理Ollydbg都懂，为啥苹果这么注重用户体验及GUI设计的人为啥懂我是不太明白。。。。。。。难道苹果的GUI设计光是指使用鼠标或者触摸屏？唉。。。。也许我还没有适应苹果的文化吧。。。。。。当大家都被苹果的文化熏陶后，也许苹果的东西就是好吧。。。。。。（估计说这些话会被很多人骂，所以不开新文章特别说明了，省的骂声一片，仅插播在这个枯燥的技术文章当中吧。某年某月某日我改变主意了，再回来改掉这些文字吧。）对了，主题是，Cocoa中的管道：

```objective-c
#import <Foundation/Foundation.h>

int
 main (int
 argc,
const
 char  * argv[]) {
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/cat"];
        
        NSMutableArray *args = [NSMutableArray array];
        [args addObject:@"a"];
        [args addObject:@"b"];

        [task setArguments:args];

        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput: pipe];

        NSTask *newTask = [[NSTask alloc] init];
        [newTask setLaunchPath:@"/bin/cat"];

        [newTask setStandardInput: pipe];

        [task launch];
        [newTask launch];
        [task waitUntilExit];

        [newTask waitUntilExit];
        [task release];

        [newTask release];
        
        [pool drain];

        return 0;
}
```

Pipe的封装还算简单，使用也还算方便吧，但是因为Task的使用，代码量实在也够多了。

## 7.Qt QProcess

作为几乎对C++进行语言级别改变的框架Qt，进行了与Cocoa类似的封装，对了，其实感觉Qt对C++从语言特性的改变上来说类似于Cocoa对于Objective C的改变，不同的是Qt没能统治C++世界。
Test1:

```cpp
#include <QtCore/QCoreApplication>
#include <QtCore/QProcess>
#include <QtCore/QStringList>

int
 main(int
 argc, char
 *argv[])
{
    QString program = "cat";
    QStringList arguments;

    arguments <<"a"  <<"b";

    QProcess *myProcess = **new**  QProcess();
    myProcess->start(program, arguments);

    myProcess->waitForFinished();
    QByteArray output = myProcess->readAllStandardOutput();
    printf(" %s  ", (const  char*)output);

    **return**


 0

;
}
```

QProcess就是Qt封装的进程类，需要特别说明的此类使用上在Qt4与Qt3是不同的。并且，有个问题是因为Qt现在几乎已经是纯面向GUI的界面库了，所以QProcess默认是进行命令行不输出的，这里转了个弯，先读出了输出，然后用printf输出了。

Test2:

```cpp
#include <QtCore/QCoreApplication>
#include <QtCore/QProcess>
#include <QtCore/QStringList>

int
 main(int
 argc, char
 *argv[])
{
    QString program = "cat";
    QStringList arguments;

    arguments <<"a"  <<"b";

    QProcess *myProcess = **new**  QProcess();
    myProcess->setStandardOutputFile("c");
    myProcess->start(program, arguments);

    myProcess->waitForFinished();

    **return**


 0

;
}
```

但是看了示例，什么感觉？个人感觉Qt不愧是专门做API的，靠API吃饭的与靠卖硬件为生的公司就是不一样，API的设计实在是恰到好处，简介简练，并且，最重要的是，够用！

Test3:

```cpp
#include <QtCore/QCoreApplication>
#include <QtCore/QProcess>
#include <QtCore/QStringList>

int
 main(int
 argc, char
 *argv[])
{
    QString program = "/bin/cat";
    QStringList arguments;

    arguments <<"a"  <<"b";

    QProcess *myProcess = **new**  QProcess();
    QProcess *outProcess = **new**  QProcess();
    myProcess->setStandardOutputProcess(outProcess);

    myProcess->start(program, arguments);

    outProcess->start(program);

    myProcess->waitForFinished();

    outProcess->waitForFinished();

    QByteArray output = outProcess->readAllStandardOutput();
    printf(" %s  ", (const  char*)output);
    **return**


 0

;
}
```

总体上而言，Qt没有设计pipe对应的类，但是，对于一个函数可以解决的任务来说，很明显使用起来是更加简单的，像Cocoa那样，对这么简单的概念都进行相应的封装，其实有过度设计之嫌。。。。其实NSPipe也就2，3个函数，而且，如此例所示，其实，除了一个有用外，NSPipe多出的那么几个都是因为多了NSPipe才出现的函数。。。。。悲哀中。。。。。

## 总表

使用方式/代码量 | Test1 | Test2 | Test3
---|---|---|---
SHELL | 单行5字符 | 单行7字符 | 单行9字符
C Runtime Library's system | 5行 | 5行 | 5行
Python's os.system | 2行 | 2行 | 2行
Win32 API WinExec/ShellExecute | 6行 | 6行 | type限制
Win32 API CreateProcess | 16行 | 16行 | type限制
Objective C With Cocoa | 15行 | 23行 | 23行
Qt QProcess | 16行 | 15行 | 20行

别的不说了，起码有一点可以肯定。。。。。有的时候面向/基于对象的设计，不仅实现起来不能省代码量，就连使用起来都需要更多的代码。。。。而且封装这技术，使用一定要适度，太细太过并没有太大好处。有的时候一个简单的C语言函数，已经可以做的事情，为啥我们要用3，4各类来完成?


