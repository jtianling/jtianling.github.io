---
layout: post
title: PyQt的学习（1） 入门
categories:
- Python
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
  views: '26'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文是PyQt入门教程，通过Hello World、信号槽和布局等示例，展示了其简洁强大，帮助Python初学者快速上手GUI开发。

<!-- more -->




# 动机：

刚学习完Python,借鉴以前学习C++时的经验，当时用MFC巩固了C++的学习，并且可以做出实际的程序，给了我继续学习的动力，学习Qt也是出于类似的目的。

为什么我要写，为了学习。不仅仅为了将来有个可以用的，好用的跨平台GUI库，也为了用Python快速开发时也能有个GUI库，但是又不喜欢TK，那么，综合考虑，Qt也就是不错的考虑了。

# 综述

这些文章基本遵循《C++ GUI Qt 4编程》第2版（C++ GUI Programming with Qt4, Second Edition）的流程，文字可能会很少，除非自己想出的例子，不然例子就是书中C++例子的Python版本，**基本上，可以以此书为蓝本对照这些文章中的例子来看。**

虽然用途不算太大，但是考虑到PyQt的好教材是如此的稀少，这样也不算完全没有价值吧，毕竟还有只明白Python不懂C++的人。

这里有一本PyQt的书《[GUI Programming with Python: Qt Edition](<http://www.commandprompt.com/community/pyqt/>)》，但是老到基本上是属于Qt2时代的东西了。

至于PyQt 嘛，你不会不知道到google上搜索一下，取得其下载地址吧？安装方式如此简单，点击下一步以后，就可以在Python中通过import PyQt4来使用这个库了。

# HelloWorld

自从K&R;后，好像所有的程序语言讲解都是以HelloWorld开始，我们也不免俗吧,我们从HelloQT开始。并且，这个例子也可以作为一个测试程序，测试一下看看安装PyQt是否成功。

HelloQt.pyw

```python
1 import sys  
2 from PyQt4 import QtGui  
3   
4   
5 app = QtGui.QApplication(sys.argv)  
6 label = QtGui.QLabel("Hello Qt!")  
7 label.show()  
8   
9 sys.exit(app.exec_())  
```

这样，就是一个现实"Hello Qt"的窗口，利用了QLabel部件。--说明一下，Qt中将MFC中常常称作控件（control）的东西称作部件（Widget），其实一回事。

这里也可以看出Qt的足够简洁，我很欣赏，而其对象使用的风格和方式也是比较好的，不然，尝试用VS生成一个类似的MFC程序试试？^^

其实这里还不足以见证Qt的强大,看下面的例子，QLabel竟然至此HTML样式。。。。。-_-!

MoreHelloQt.pyw

```python
1 import sys  
2 from PyQt4 import QtGui  
3   
4   
5 app = QtGui.QApplication(sys.argv)  
6 label = QtGui.QLabel("  
 
## _Hello_ QT!

") #这里我没有办法让CSDN不将其解释为HTML。。。所以，参考界面的源代码看看是什么吧  
7 label.show()  
8   
9 sys.exit(app.exec_())  
```

强大吧：）

# Qt(C++) VS PyQt

这里，顺便比较一下PyQt与普通Qt（C++）生成程序的区别。一般而言，两者速度没有可比性，但是，速度在这里不是主要问题，原因在于PyQt的核心也就是Qt库，那是用C++写的，这样，一般而言不会占用太多时间的逻辑代码速度慢点，不会成为瓶颈，使得PyQt的程序可以跑得足够的快。但是，使用方式上，却没有失去Python的优雅语法，快速开发的能力，也结合了Qt的强大，呵呵，广告用语。。。。。。。。。。。来点实在的。

左边的是用C++开发出来的Qt程序，右边是PyQt开发出来的程序，由于都是使用了同一个库，看不出两者的区别。基本上，多懂了一种语言，就多了一种选择。。。比如说这个时候的Python。

# 建立连接

quit.pyw

```python
1 import sys  
2 from PyQt4 import QtCore, QtGui  
3   
4 app = QtGui.QApplication(sys.argv)  
5   
6 quit = QtGui.QPushButton("Quit")  
7   
8 QtCore.QObject.connect(quit, QtCore.SIGNAL("clicked()"),  
9  app, QtCore.SLOT("quit()"))  
10   
11 quit.show()  
12 sys.exit(app.exec_())  
```

这里展示了Qt的信槽模式，有点怪异的是，在Python中，信号，槽，都是用字符串来表示-_-!这点似乎有点奇怪。

我还不懂Qt的原理，也没有看过Qt的源代码，但是总是感觉这里奇怪，于是我翻看了一下Qt的SIGNAL，SLOT宏，于是一切也就没有那么奇怪了。

```c
# define SLOT(a) qFlagLocation("1"#a QLOCATION)

# define SIGNAL(a) qFlagLocation("2"#a QLOCATION)
```

本来，他们就是以字符串来表示的。。。。。。。。我原本还以为在Qt中这些都是通过回调函数的形式出现的呢。。。。。。。汗-_-!真那样，与一般的WxWidget原理有啥不同啊。。。呵呵，看来，Qt的原理还得好好理解理解。其实就现在的信息看，无非也就是Observer模式的一种扩展，再难也难不到哪儿去。

在PyQt的安装包中，有个tutorial，展示了更复杂一点的button使用方法，可以参考参考

morequit.pyw

```python
1 import sys  
2 from PyQt4 import QtCore, QtGui  
3   
4   
5 app = QtGui.QApplication(sys.argv)  
6   
7 quit = QtGui.QPushButton("Quit")  
8 quit.resize(75, 30)  
9 quit.setFont(QtGui.QFont("Times", 18, QtGui.QFont.Bold))  
10   
11 QtCore.QObject.connect(quit, QtCore.SIGNAL("clicked()"),  
12 app, QtCore.SLOT("quit()"))  
13   
14 quit.show()  
15 sys.exit(app.exec_())  
```

分别是设置Button的大小和按钮文字的字体和样式，这个阶段就不深抠细节了，了解概念和Qt大概的风格就好。

# 窗口部件的布局

用过MFC的人都知道在MFC中创建一个随窗口动态改变控件大小的程序的困难。。。。。。需要每次OnMove,OnSize的时候去重新计算控件的大小，为了保持布局合理，最好还得将所有控件的位置用百分比来计算，痛苦不言而喻，可以参考我写的正则表达式测试程序0.3版（要么就是更老的版本）。但是在Qt中好像就要简单的比较多。看看示例：

layout.pyw

```python
1 import sys  
2 from PyQt4 import QtCore, QtGui  
3   
4 app = QtGui.QApplication(sys.argv)  
5   
6 window = QtGui.QWidget()  
7   
8 spinBox = QtGui.QSpinBox()  
9 slider = QtGui.QSlider(QtCore.Qt.Horizontal)  
10 spinBox.setRange(0, 130)  
11 slider.setRange(0, 130)  
12   
13 QtCore.QObject.connect(spinBox, QtCore.SIGNAL("valueChanged(int)"),  
14 slider, QtCore.SLOT("setValue(int)"))  
15 QtCore.QObject.connect(slider, QtCore.SIGNAL("valueChanged(int)"),  
16 spinBox, QtCore.SLOT("setValue(int)"))  
17 spinBox.setValue(35)  
18   
19 layout = QtGui.QHBoxLayout()  
20 layout.addWidget(spinBox)  
21 layout.addWidget(slider)  
22 window.setLayout(layout)  
23   
24 window.show()  
25 sys.exit(app.exec_())  
```

行了，基本上PyQt的程序是怎么样子的，大概有个了解了：），下面就开始慢慢来了。我也需要睡觉去了。

