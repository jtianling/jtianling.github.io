---
layout: post
title: Qt/PyQt中使用系统全局的快捷键
categories:
- "未分类"
tags:
- PyQt
- Qt
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '22'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文讲解了在Qt和PyQt中实现全局快捷键的方法。因Qt本身不支持，需分别调用Windows API，并重写事件过滤器来捕获和响应热键消息。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

估计这种小的知识会有几篇文章，除了全局快捷键部分外，其他的都比较简单，都是我实现 _[“ onekeycodehighlighter"](<http://code.google.com/p/onekeycodehighlighter/>)_中碰到的一些小问题，这里顺便整理一下。事实上，稍微懂一点的人，去看看one key code highlighter的源代码都能明白了。这里相当于将其详细的剖析一下。。。。。。。另外，实现上用Python+PyQt，事实上，主要的部分是对Qt的一些类的使用，所以其实看懂了C++的Qt中使用上是一样的。啥？你看不懂Python？好的，这就是我为什么靠C++吃饭，却学习JAVA,JavaScript,Lua,Python,Bash的一个原因，不然你看不懂别人在写啥-_-!（当然，我基本上也就学到能看懂）
对于pyQt完全不懂的，这里也不用看了，《[pyqt的学习(1) 入门](<http://www.jtianling.com/archive/2009/06/17/4272009.aspx>)》，《[pyqt(2) 对话框...](<http://www.jtianling.com/archive/2009/06/20/4281633.aspx>)》可以看看，但是写的有点乱，因为那时候我懂得也少（不代表现在就懂的多了）

## 概述

使用系统全局的快捷键总是键很酷的事情，在你的程序已经失去焦点的时候，还能响应用户的按键，完成任务，多酷啊。特别的，我的one key code highlighter只有一个SystemTrayIcon（托盘图标）和一些菜单，不使用系统全局的快捷键而用菜单去实现命令的话，我还不如用快捷方式去使用[chc2c](<http://code.google.com/p/code-highlight-clipboard2clipboard/> "chc2c")呢（就如我以前做的那样）。所以，对于这个我自己需要而实现的软件，怎么说，也需要有这个功能，无奈的是，偏偏Qt中其实原生不支持此功能，那么，只好放弃移植性去使用win32 API了。

## Qt中的实现

主要的API为：（来自MSDN)

```cpp
BOOL RegisterHotKey( HWND hWnd,
int id,
UINT fsModifiers,
UINT vk
);
```

在Qt中实现并不算什么大问题，《[Qt中使用全局热键](<http://yanboo.ycool.com/post.3224143.html#>)》中有一些说明，此文说明了一件事情，技术文章的价值不以篇幅来衡量，而是以技术含量衡量，此文没有太多的文字，但是详细解释了所有过程。
主要步骤为用RegisterHotKey向系统注册全局的快捷键，然后重载QApplication的winEventFilter函数，并响应msg为WM_HOTKEY时的消息，整个过程类似于在Windows下的OnMessage进行消息响应，只是这次是在Qt中。原文给出的示例代码如下：（原文排版有点乱，但是不损其技术价值）

```cpp
bool winEventFilter(MSG *msg, long *result)
{
**if**(WM_HOTKEY==msg->message)
{
qDebug()<<"winmsg return true";
emit hotKey(int(msg->wParam),LOWORD(msg->lParam),HIWORD(msg->lParam));
**return** TRUE;
}
**return** FALSE;
}
```

这种实现很简单，我就不多说了，Qt嘛，毕竟还是C++，只不过这里放弃移植性调用Win32 API，并且响应消息而已，没有什么太多新的东西。

## PyQt中的实现

相对于Qt中的实现来说，对于Qt中没有的东西，很显然PyQt中也很难有了，那么，我们还是只能通过调用Win32 API了，而在Python中调用Win32 API就没有那么太简单了。。。。。。。
介绍的是用ctypes来调用，当然，因为感觉此部分会与本主题太偏，所以额外写了一篇文章讲述。《[Python与C之间的相互调用（Python C API及Python ctypes库）](<http://www.jtianling.com/archive/2010/01/24/5251306.aspx>)》，看了前文就会知道，其实用Python C API包装以下RegisterHotKey也可以实现一样的效果，知识用ctypes更简单一些。
这里就直接讲RegisterHotKey的调用了。以下是一些代码片段。。。。。

```python
from ctypes import c_bool, c_int, WINFUNCTYPE, windll
from ctypes.wintypes import UINT


prototype = WINFUNCTYPE(c_bool, c_int, c_int, UINT, UINT)
paramflags = (1, 'hWnd', 0), (1, 'id', 0), (1, 'fsModifiers', 0), (1, 'vk', 0)
self.RegisterHotKey = prototype(('RegisterHotKey', windll.user32), paramflags)


r = self.RegisterHotKey(c_int(self.mainWindow.winId()), HOT_KEY_ID, config.modifier, ord( config.hotkey.upper() ))
**if** **not** r:
QtGui.QMessageBox.critical(None, 'Hot key', 'Can't Register Hotkey Win + Z')
sys.exit(1)
```

这里用了比直接调用RegisterHotKey更复杂的方法来使用ctypes，（在《[Python与C之间的相互调用（Python C API及Python ctypes库）](<http://www.jtianling.com/archive/2010/01/24/5251306.aspx>)》中描述了最简单的办法），好处是实现了“命名参数”及参数默认值，这里虽然实际没有使用-_-!另外，利用config中的配置的大写字母的ord，来表示Windows中的虚拟键值真是很方便，为什么这样能省去那一大堆的VK_*定义？因为WinUser.h中就是这样定义这些VK_*的。。。。。。。
还有，mainWindow实际是一个QMainWindow的对象，其winId函数可以获取到Windows窗口的句柄，这里将其转化为c_int而不是HWND，因为在Python中不允许从int到HWND的转换（这有点扭曲），知道原因的请告诉我。完成了这些后，QApplication的winEventFilter函数的重载还是少不了的。

以下是我的一段实现代码：

```python
# these code don't have compatibility with other OS
**def** winEventFilter(self, msg):
    debug_out("Message: " \+ str(hex(msg.message)) )
    **if** msg.message == WM_HOTKEY:
        **if** isClipboardEmpty():
            self.mainWindow.trayIcon.showMessage("failed", "Clipboard is Empty.")
            **return** True, 0
        debug_out("Got the Hotkey!")
        debug_out(config.filename)

        import imp
        imp.reload(config)
        chc2c(self.mainWindow.syn, config.color, config.isLineNumber, config.filename)
        self.mainWindow.trayIcon.showMessage("success", "transformed the data in clipboard to html.")
        **return** True, 0

    **return** False, 0
```

基本思路与C++中并无差异，查找到WM_HOTKEY，然后响应之。我这里利用了reload来达到每次都动态查询配置的效果^^chc2c就是我的主要函数。
以上就是PyQt中实现全局快捷键的全部过程了。

另外，我本来以为假如愿意使用[PyWin32](<http://sourceforge.net/projects/pywin32/ "PyWin32">)的话，直接可以调用其中的RegisterHotKey，后来竟然在里面没有找到，奇了怪了。

## 参考文章

《[Qt中使用全局热键](<http://yanboo.ycool.com/post.3224143.html#>)》

## 完整源代码获取说明

由于篇幅限制，本文一般仅贴出代码的主要关心的部分，代码带工程（或者makefile）完整版（如果有的话）都能用Mercurial在Google Code中下载。文章以博文发表的日期分目录存放，请直接使用Mercurial克隆下库：

[https://onekeycodehighlighter.googlecode.com/hg/](<https://blog-sample-code.jtianling.googlecode.com/hg/>)

Mercurial使用方法见《[分布式的，新一代版本控制系统Mercurial的介绍及简要入门](<http://www.jtianling.com/archive/2009/09/25/4593687.aspx>)》

要是仅仅想浏览全部代码也可以直接到google code上去看，在下面的地址：

[http://code.google.com/p/onekeycodehighlighter/source/browse/](<http://code.google.com/p/jtianling/source/browse?repo=blog-sample-code>)

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
