---
layout: post
title: MacOS中的全局快捷键设定 With Objective C
categories:
- "未分类"
tags:
- MacOS
- Objective C
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '25'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

全局快捷键属于比较有用的功能了，在Windows下使用RegisterHotkey可以很方便的设定，（指的是通过程序设定啊）Qt中没有封装此功能，所以稍微麻烦一点，可以参看我原来的文章《[Qt/PyQt中使用系统全局的快捷键](<http://www.jtianling.com/archive/2010/01/25/5252302.aspx>)》，换到了MacOS中后，又得重新学习了，真是悲哀。。。。。。。  
搜遍互联网，才总算发现有用的文章，《[Program Global Hotkeys in Cocoa Easily](<http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/> "Program Global Hotkeys in Cocoa Easily")》一文真是精华中的精华。不仅说明了怎么在MacOS中设定全局快捷键，而且超额的指点了怎么让用户在程序中自定义。。。。强就一个字，作者绝对是介于牛A及牛C之间的人物。  
唯一还有点遗憾的是，作者虽然是说用Cocoa，但是其实使用了carbon框架，而carbon框架使用的还是C语言的接口，并且有回调函数的设置，导致接口使用上不能用纯Objective C。。。。。。  
本文仅记录大致使用流程，作为备档，详细的接口意义及各类，结构的意义未作详细说明（文档中我都没有查到较为详细的说明）。

## 准备工作

如上所述，用了Carbon框架，所以首先得为工程添加框架得链接依赖，然后使用上包含Carbon/Carbon.h文件。

## 注册全局快捷键回调函数

回调函数的原型如下：  
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,  
void *userData) {  
}

注册的方式  
  
EventTypeSpec eventType;  
eventType.eventClass=kEventClassKeyboard;  
eventType.eventKind=kEventHotKeyPressed;  
InstallApplicationEventHandler(MyHotKeyHandler, 1, &eventType;,NULL, NULL);  
主要的函数是InstallApplicationEventHandler，表示注册相应的回调函数，作为C语言接口，回调的函数原型必须一致。

## 注册快捷键

  
EventHotKeyRef gMyHotKeyRef;  
EventHotKeyID gMyHotKeyID;  
gMyHotKeyID.signature='rt2h';  
gMyHotKeyID.id=1;  
  
RegisterEventHotKey(6, controlKey, gMyHotKeyID,  
GetApplicationEventTarget(), 0, &gMyHotKeyRef;);  
  
gMyHotKeyID.signature='te2h';  
gMyHotKeyID.id=2;  
  
RegisterEventHotKey(7, controlKey, gMyHotKeyID,  
GetApplicationEventTarget(), 0, &gMyHotKeyRef;);  
注册快捷键，RegisterEventHotKey是整个过程中最重要的接口，第一个参数的数字，代表了最终响应的键值，这里有点奇怪，不是像Windows中那样使用表示虚拟键值的宏，而是直接用按键代表的数字来表示，而且此数字甚为奇怪，我也很为纳闷。比如上面的6，7分别表示Z键和X键。这些数字我只有在《[Program Global Hotkeys in Cocoa Easily](<http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/> "Program Global Hotkeys in Cocoa Easily")》一文中提到的[AsyncKeys](<http://www.dbachrach.com/blog/downloads/async.zip> "AsyncKeys")软件中我才能正确的知道。此软件运行时，如下图：

![](http://docs.google.com/File?id=dhn3dw87_72fzc48cqv_b)

上面就是我按Z键时，显示的样子，其中我们需要设置的值为AsyncKey Number那一栏的值，即6.。。。。。。。。原因不明，没有深入了解。  
RegisterEventHotKey第二参数是控制键的设置参数，分别可以为cmdKey, shiftKey, optionKey,controlKey，各自的意思我想就不用我讲了，不过需要注意的是，同时设置时不是用一般的|符号来组合，而是用＋。。。。。。这点还真是比较奇怪，难道Mac下的接口都是这样设置的吗？-_-!对了，不需要设置这样的常量感到奇怪，Mac下的代码风格有所不同，以前Windows下（其实我在其他平台也是这样），常量习惯性的全大写，这样大家就能知道这是不能改变的宏或者常量，但是Mac下的接口不是这样。。。。但是，知道它们都是系统常量就好了。

## 实现回调函数

  
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,  
void *userData) {  
EventHotKeyID hkCom;  
GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,  
sizeof(hkCom),NULL,&hkCom;);  
int l = hkCom.id;  
  
switch (l) {  
case 1: //do something  
convertRtfToHtml();  
break;  
case 2: //do something  
convertTextToHtml();  
break;  
}  
return noErr;  
}  
  
这里通过GetEventParameter来获取需要的信息，然后通过事件的ID来分辨是哪个快捷键按下。整个过程基本就是这样了。

## 小结

接触Cocoa的时间较短，发现接口设置的一些惯例都不太一样，虽然在GUI世界，消息（或者说事件）驱动是肯定的，但是在Windows的Win32 API及MFC那个层面编写代码的时候（.net不了解，就不知道了），消息的流向是知道的，可控制的，消息响应的时候也常常在OnMessage函数中自己去设置，但是Cocoa中感觉封装的层次更加高一些，我不知道消息从那儿来，又到哪儿去，只能通过回调或者控件的binding，action的链接，类的委托来设置我希望被调用的函数，具体啥时候调用，入口在哪，我都无法控制，这点，可能属于从较为底层跑到较为高层有点不适应。作为C/C++程序员，可能难免带上了一定的刨根问底的性格，甚至一定要回溯到系统加载进程的汇编代码才肯善罢甘休，不然总是觉得没有底，在不能彻底了解一个库的源代码前，甚至都不敢大量的使用，不然效率怎么样，内存怎么控制的，健壮不健壮总是没底，到了Objective C with Cocoa的世界后，还有点不适应。。。。。。。。。。 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
