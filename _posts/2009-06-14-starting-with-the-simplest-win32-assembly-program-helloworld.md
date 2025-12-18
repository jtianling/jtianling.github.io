---
layout: post
title: "从最简单的Win32汇编程序，HelloWorld说起"
categories:
- "汇编和反汇编"
tags:
- Hello World
- "汇编和反汇编"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# 从最简单的Win32汇编程序，HelloWorld说起  

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**  
**

[讨论新闻组及文件](<ttp://groups.google.com/group/jiutianfile/>)

自从开始弄反外挂以来，我的个人目标很明确，就是借此机会，好好的重新学习Win32汇编，当年买了书，开始学了一下因为C++学习的紧迫性，就放弃了。。。这和Python当年学习的过程几乎是一样的。。。。。呵呵，人生真是戏剧性，当工作后，我因为工作需要学习了lua后，重拾对脚本语言的兴趣，对C++的学习紧迫性也没有那么强了（毕竟完全可以应付工作了，真是完全，我还没有因为C++语法的问题在工作中卡过，剩下需要学习的就是思想了），所以又开始扛着《Python核心编程》啃，最近反外挂的工作竟然也在工作中用了python一把，真是戏剧性啊。。。。。现在要反汇编嘛，乘机好好学好汇编吧。。。。我发现我对于越底层的东西好像兴趣越大。。。。不知道为什么，也许是因为毕竟是学硬件出身吧。。。。。。底层的东西离硬件近点。。。。但是怎么解释我去学习LUA,Python呢？所以结果还是没有办法解释。。。。。。。。。

书中的例子很简单，源代码如下：

```asm
**.486** ; create 32 bit code  
**.model** flat, **stdcall** ; 32 bit memory model  
**option** casemap :none ; case sensitive

**include** windows.inc  
**include** masm32.inc  
**include** user32.inc  
**include** kernel32.inc

**includelib** masm32.lib  
**includelib** user32.lib  
**includelib** kernel32.lib

**.data**  
szCaption **db** "A MessageBox !",0  
szText **db** "Hello,World !",0

**.code**

start:  
    **invoke** MessageBox,NULL,**offset** szText,/  
    **offset** szCaption,MB_OK  
    **invoke** ExitProcess,NULL

**end** start
```

然后编个makefile:  

对了，书中是建议去下载微软的nmake，VS中都有的，但是我不知道是否和GNU make完全兼容，我只学过GNU make，并且好像也不太像去学微软的nmake语法（咋一看好像差不多），所以我下了个windows 版的GNU make来用，幸好还真有这个东西：）  

makefile:  

```make
1 basename = helloWorld  
2 exe = helloWorld.exe  
3 obj = helloWorld.obj  
4 files = helloWorld.asm  
5 $(exe) : $(obj)  
6  link /subsystem:windows /map:$(**basename**).map /out:$(exe) $(obj)  
7 $(obj) : $(files)  
8  ml /c /coff /Zi $(files)  
```

这个makefile写的有点复杂了-_-!呵呵，还好例子简单。。。。。  

然后用make命令编译就好了。。。。。这里因为我用了vim。。。所以一切都简单了很多，呵呵，其实大家假如用UE,EditPlus也不会坏到哪去，反正越是接触的语言越多，你也会越希望有个万能的编辑器的。。。。当然，万能的IDE最好。

编译，运行，都没有问题，但是，有的人脑袋就是进水了，因为我没有自己push去传递参数，也因为习惯了C++程序中微软做一大堆手脚，总感觉不踏实，我想看看这个程序中微软是不是也在我背后干了什么。。。。。。（C语言程序员不喜欢C++，其中一个很大的理由就是他们觉得编译器背着他们干了太多，他们不踏实，其实去看看然后多反汇编几次C++程序，要达到基本理解C++编译器干了些什么好像也不是太难。。。。。。但是起码比C语言干的多。。。又说了一大堆没有用的话，我发现我的文中有用的信息越来越少了，都是我东扯西扯。。。）  

回到主题，于是我先看了一下生成的exe文件，发现无缘无故多了.rdata区段,虽然我并没有用，所以程序达到了4k(好像是普通不修改PE文件时最小的一个可执行程序的大小)，反汇编一下生成的exe文件（还能叫反汇编吗-_-!）

```asm
00401000 >/$ 6A 00 push 0 ; /Style = MB_OK|MB_APPLMODAL

00401002 |. 68 00304000 push 00403000 ; |Title = "A MessageBox !"

00401007 |. 68 0F304000 push 0040300F ; |Text = "Hello,World !"

0040100C |. 6A 00 push 0 ; |hOwner = NULL

0040100E |. E8 07000000 call <_MessageBoxA@16 0040101a f user32:user32.dll> ; /MessageBoxA

00401013 |. 6A 00 push 0 ; /ExitCode = 0

00401015 /. E8 06000000 call <_ExitProcess@4 00401020 f kernel32:kernel32.dll> ; /ExitProcess

0040101A > $- FF25 08204000 jmp dword ptr [<&user32.MessageBoxA;>] ; _MessageBoxA@16 0040101a f user32:user32.dll

00401020 > .- FF25 00204000 jmp dword ptr [<&kernel32.ExitProcess;>] ; _ExitProcess@4 00401020 f kernel32:kernel32.dll
```

我只能说，总算在我们程序背后没有什么在偷偷摸摸进行了，一切就像我们的源代码一样，这正是我们需要的境界。。。。。用汇编这点还是好（其他高级语言使用者基本可以忽视此句）

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)