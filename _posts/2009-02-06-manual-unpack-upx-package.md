---
layout: post
title: "手动脱UPX壳"
categories:
- "未分类"
tags:
- UPX
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

本文是一篇手动脱UPX壳的入门教程，演示了如何用OllyDbg等工具寻找OEP、定位并修复IAT的完整过程，旨在学习逆向分析。

<!-- more -->

# 手动脱UPX壳


个人手动脱壳定义，不是完全不用工具，仅仅是指不用脱壳机，并且手动寻找OEP，恢复IAT的时候使用ImportREC，但是手动找到IAT的位置，不用自动搜寻功能，其实找到了位置后，ImportREC还是做了新添加一个段，拷贝2进制数据，修改PE头中的IAT偏移地址这种工作，因为重复性太高，不手动进行了。

这些自然不是最佳，最快脱壳的方式，仅仅是学习。。。。。

需要用到的工具有OllyDbg（用于调试），LordPE（用于Dump，LordPE的Dump似乎比OllyDbg的Dump插件更稳定，因为好像OlldyDbg的Dump插件还尝试做了一些其他工作），ImportREC(恢复IAT)

其实对于UPX这样著名的壳，网上教程实在是多，所以我没有必要再教大家一次，我不过是利用这个机会，练习练习而已，毕竟UPX定位于压缩壳，脱起来实在是比较容易。

先尝试：

upx203w版本

选择的对象就是发布的upx本身，因为其本身就是用此版本加的壳-_-!

1.找OEP

方法其实有很多种，但是对于UPX壳。。。我发现最简单的方法就是直接向下翻页，找到最后一个00前的内容。。。。。。因为UPX将其他内容全部换成00了，这样的标志太明显了。

我这里最后几条语句是：

```asm
0048149D   .  61            POPAD
0048149E   .  8D4424 80     LEA     EAX, DWORD PTR [ESP-80]
004814A2   >  6A 00         PUSH    0
004814A4   .  39C4          CMP     ESP, EAX
004814A6   .^ 75 FA         JNZ     SHORT upx.004814A2
004814A8   .  83EC 80       SUB     ESP, -80
004814AB   .- E9 60FDF7FF   JMP     upx.00401210
```

最后一行的地址其实就是OEP了。。。。。。。。。。设个断，跟过去，直接用LordPE Dump all。。。。。工作已经完成一半，我在学习之前也没有想过会这么简单。

接下来找IAT,找到第一个系统函数调用，

00401218    FF15 E4E24700   CALL    NEAR DWORD PTR [47E2E4]          ; msvcrt.__set_app_type

__set_app_type,地址就在47E2E4这个地方了，数据窗口跟随地址，看到一堆函数,向前放到0000，在这里

```asm
0047E20C  00000000
0047E210  00000000
0047E214  7C835505  kernel32.AddAtomA
0047E218  7C812EAD  kernel32.CreateSemaphoreA
```

向后翻到0000，在这里

```asm
0047E3C0  77BED711  msvcrt.strtol
0047E3C4  77C1AECF  msvcrt.time
0047E3C8  77BEC9C9  msvcrt.tolower
0047E3CC  00000000
0047E3D0  00000000
```

然后开启ImortRec，选择正挂起的进程，将左下角的OEP填上刚找到的地址1210，（这里去掉了基址，仅需要RVA就可以了）

在IAT的RVA一栏填上开始地址7E214，长度用7E3C8-7E214得到1B4（这一步仅仅是为了学习的目的，其实按IAT AutoSearch一般也可以得到正确的结果）。

然后点击Get Imports按钮，上面的列表框就有结果了，我这里显示一起都正常。即valid:YES。

此时一切工作接近尾声，点击Fix Dump按钮，选择刚才Dump出来的文件，完成修复。脱壳完成。

这种脱壳的目的仅仅是为了更好的去调试和分析代码，其实并不完善，因为UPX加壳后保留的UPX0，UPX1段名没有改，壳其实还是保留在文件中，这里仅仅是将入口改到了实际入口(OEP)，并将数据恢复到了正确的地方。

其实从功能上来讲用原有upx工具的-d 选项来脱壳要好的多：）

目前UPX官方最新版的是upx303w

我还以为其有一定的改进，就实际效果而言，完全没有变化，可能毕竟定位于压缩壳的UPX稳定才是最重要的，所以脱壳基本上没有什么难度，其也没有想做成有什么难度，不然也不会提供自动脱壳功能。。。。。

要说明的一点是新版的壳用Ollydbg的Dump插件，勾上FixIAT选项Dump会出现错误，ImportREC自动搜索IAT的时候大小和位置也会找错，我这里的效果是总是从第一调用的函数开始向后找，手动输入正确的IAT地址和长度就没有任何问题。

最后，UPX是有源码的，很适合作为第一款来脱的壳和第一款用来学习做壳的壳：）但是也给了我们一个提示，不要将无用的代码位置置为00，那样只能是给破解者最好的定位方式。

