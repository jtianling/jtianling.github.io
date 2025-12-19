---
layout: post
title: "手动脱ASPack壳"
categories:
- "未分类"
tags:
- ASPack
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

分享手动脱ASPack壳的经验，演示如何用OllyDbg通过堆栈平衡法找到OEP，再用ImportREC恢复IAT。

<!-- more -->


个人手动脱壳定义，不是完全不用工具，仅仅是指不用脱壳机，并且手动寻找OEP，恢复IAT的时候使用ImportREC，但是手动找到IAT的位置，不用自动搜寻功能，其实找到了位置后，ImportREC还是做了新添加一个段，拷贝2进制数据，修改PE头中的IAT偏移地址这种工作，因为重复性太高，不手动进行了。

这些自然不是最佳，最快脱壳的方式，仅仅是学习。。。。。

需要用到的工具有OllyDbg（用于调试），LordPE（用于Dump，LordPE的Dump似乎比OllyDbg的Dump插件更稳定，因为好像OlldyDbg的Dump插件还尝试做了一些其他工作），ImportREC(恢复IAT)

压缩壳总是容易脱的，作为脱壳练手，再来一个著名的壳，ASPack

我用的版本是212,测试对象是用其将windows的计算器程序打包。

## 获取OEP

ASPack获取OEP就没有UPX那么简单了，当然，其实也还是不难，毕竟是压缩壳嘛。而且我尝试过压缩简单的程序（比如以前用汇编写的那个HelloWorld,几乎不会改变代码段，仅仅加密了IAT），因为calc.exe还算是一个正规的程序，所以体积不算很小，然后可以达到50%以上的压缩率，代码段自然也破坏了。

我首先用的是一种很笨的办法，直接通过段之间的跳转来定位，但是因为ASPack相当的狡猾。。。。它不是一个一个段的解压而是交替进行解压，导致的结果就是我没有办法通过在一段内存上面设一次断点，也没有办法通过先在数据段设断，然后再在代码段设断的方式获取OEP，最后只能用蛮办法，用OllyDbg的RUN跟踪，设置跟踪中断条件为EIP执行到代码段，然后跟踪步进。。。。。。即便这样，中途ASPack竟然还特意到代码段Ret了2次，呵呵，无耻啊。当然，最后通过这种办法，耗时超久，才找到了OEP.OllyDbg跟踪的指令条数在500W以上。。

```plaintext
01012475   .  6A 70         PUSH    70

01012477   .  68 E0150001   PUSH    复件_cal.010015E0

0101247C   .  E8 47030000   CALL    复件_cal.010127C8

01012481   .  33DB          XOR     EBX, EBX

01012483   .  53            PUSH    EBX                              ; /pModule => NULL

01012484   .  8B3D 20100001 MOV     EDI, DWORD PTR [1001020]         ; |kernel32.GetModuleHandleA

0101248A   .  FFD7          CALL    NEAR EDI                         ; /GetModuleHandleA
```

第一句就是入口

然后再通过堆栈平衡的方法来找OEP，结果不需要一秒钟就能找到，简直崩溃。

方法是在外壳通过PUSHAD保护现场后（很多外壳第一句都这样）

查看堆栈

```text
0006FFA4   7C930208  ntdll.7C930208

0006FFA8   FFFFFFFF

0006FFAC   0006FFF0

0006FFB0   0006FFC4     \-- 原有ESP

0006FFB4   7FFDB000

0006FFB8   7C92E4F4  ntdll.KiFastSystemCallRet

0006FFBC   0006FFB0

0006FFC0   00000000
```

然后根据堆栈平衡条件，在6FFA4下访问中断（一般的情况是在这里调用了POPAD了），或者在在6FFC4（原来的ESP）-4=6FFC0处（其实也可以通过PUSHAD压入8个寄存器算到，6FFA4+(8-1)*4=6FFC0）下写中断（一般的情况是POPAD后，通过PUSH 地址，然后RET返回原有代码段），这样只要壳没有特意的隐藏OEP，一般一次下断就能获取OEP。

## 恢复IAT

根据

010124E3   .  FF15 0C120001 CALL    NEAR DWORD PTR [100120C]         ;  msvcrt.__set_app_type

一句，可以找到100120C属于IAT的一部分。然后用ImportRec恢复就好了，不多说了。

非加密壳，还是比较容易脱的，当然，写就没有那么容易了。。。。。

