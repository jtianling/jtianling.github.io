---
layout: post
title: Qt/PyQt中操作系统剪贴板(clipboard)
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
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍在PyQt中用QMimeData操作剪贴板，通过同时设置文本和HTML，实现代码高亮效果的直接粘贴。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

估计这种小的知识会有几篇文章，除了全局快捷键部分外，其他的都比较简单，都是我实现 _[“ onekeycodehighlighter"](<http://code.google.com/p/onekeycodehighlighter/>)_中碰到的一些小问题，这里顺便整理一下。事实上，稍微懂一点的人，去看看one key code highlighter的源代码都能明白了。这里相当于将其详细的剖析一下。。。。。。。另外，实现上用Python+PyQt，事实上，主要的部分是对Qt的一些类的使用，所以其实看懂了C++的Qt中使用上是一样的。啥？你看不懂Python？好的，这就是我为什么靠C++吃饭，却学习JAVA,JavaScript,Lua,Python,Bash的一个原因，不然你看不懂别人在写啥-_-!（当然，我基本上也就学到能看懂）  
对于pyQt完全不懂的，这里也不用看了，《[pyqt的学习(1) 入门](<http://www.jtianling.com/archive/2009/06/17/4272009.aspx>)》，《[pyqt(2) 对话框...](<http://www.jtianling.com/archive/2009/06/20/4281633.aspx>)》可以看看，但是写的有点乱，因为那时候我懂得也少（不代表现在就懂的多了）

## 概述

系统剪贴板的操作在Qt中有原生的支持，这点很强大，操作起来比Windows本身附带的要简单的多，更重要的是，这是跨平台的。  
Windows中的剪贴板其实很简单，只有一种，就是你选择然后CTRL-C的那一个。在Vim中用寄存器"+"存储，（不懂就算了）。Linux中剪贴板有两种，一种是鼠标选中后立刻就生效的，在Vim中用寄存器"+"存储，称作select剪贴板，另外一种就是类似Windows下的那种剪贴板，vim中用寄存器"*"存储。  
剪贴板作为应用程序中较为通用的一种共享数据的方式，应用较为广泛，就我所知，这好像是唯一一种用户可以很方便操作的应用程序共享数据的途径，其他的如Socket等，编程的时候是很容易实现，用户要操作就难了。

## 操作

简单的剪贴板操作，很简单，Qt中用QClipboard类来表示  
在Qt中用  
clipboard = QtGui.QApplication.clipboard()  
获取到剪贴版的对象，然后用text表示获取到文本数据，（类似CTRL-P)，用setText来设置文本数据。（类似CTRL-C)

## 更深入的操作

对于普通的文本操作，这两个函数就足够了。以前我也是这样做的。但是，我发现一个现象，那就是复制网页上的数据后，在Google Document上paste的时候，是直接可以复原原来的网页内容的（虽然常常有些偏差），但是我转换后的HTML源码是用setText设置到剪贴板中的话，paste出来的就是源码，说明肯定里面还有蹊跷，要是我的转换工具，直接粘贴就可以在Google Document中出现语法高亮过的文字多好啊，于是我查看了一下QClipboard类，及MSDN。果然，在剪贴板中保存的不仅仅是文字，还可以是一些有格式的内容，在windows中可以保存OLE的东西。。。。Qt中将其统一划分为MimeData。  
看看QMimedata这个类就会很惊喜，包括了HTML，Image等很多的东西，当然我要的就是HTML。  
于是乎，我通过

```python
mimeData = QtCore.QMimeData()
mimeData.setHtml(clipboard.text())
clipboard.setMimeData(mimeData)
```

来设置一个转换过的HTML源码，此时就能直接在Google Document上通过粘贴来得到高亮过的代码了：）  
但是，在语法文本源代码的地方此时的粘贴就无效了，因为已经没有文本了，经过试验，Qt中不同的数据时相互不影响的，于是再改了一下：

```python
def setClipboardMimeToHTML():
    clipboard = QtGui.QApplication.clipboard()
    mimeData = QtCore.QMimeData()
    mimeData.setText(clipboard.text())
    mimeData.setHtml(clipboard.text())
    clipboard.setMimeData(mimeData)
```

哈哈，能够粘贴HTML的地方，显示的就是HTML，只能显示文本的地方，粘贴的即是HTML的源码。好不强大，这也就是最后，你们在 _[\" onekeycodehighlighter\"](<http://code.google.com/p/onekeycodehighlighter/>)_ 中实际使用的效果。  
总之，我是对自己做的这个工具很满意了：）

## 完整源代码获取说明

由于篇幅限制，本文一般仅贴出代码的主要关心的部分，代码带工程（或者makefile）完整版（如果有的话）都能用Mercurial在Google Code中下载。文章以博文发表的日期分目录存放，请直接使用Mercurial克隆下库：

[https://onekeycodehighlighter.googlecode.com/hg/](<https://blog-sample-code.jtianling.googlecode.com/hg/>)

Mercurial使用方法见《[分布式的，新一代版本控制系统Mercurial的介绍及简要入门](<http://www.jtianling.com/archive/2009/09/25/4593687.aspx>)》

要是仅仅想浏览全部代码也可以直接到google code上去看，在下面的地址：

[http://code.google.com/p/onekeycodehighlighter/source/browse/](<http://code.google.com/p/jtianling/source/browse?repo=blog-sample-code>)

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
