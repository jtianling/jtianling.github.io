---
layout: post
title: PyQt(2) 对话框
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
  views: '11'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍PyQt对话框编程，对比了面向过程与面向对象方法，并演示了如何用信号槽和布局管理器构建复杂交互界面。

<!-- more -->




# 综述

对话框是比较简单的一种GUI形式，说其简单，不仅仅是处于开发的角度，从用户使用的角度来说也是如此，对话框可以说是一般图形界面程序的基本元素，即便是复杂的应用程序，往往也需要对话框来完成一些与用户交互的工程，并且，往往来说，创建基于对话框的程序也是比较简单的。也因为这样，在公司开发的众多工具当中，除了数据校验工具使用了MFC的文档视图（属于密集信息输出型），其他工具清一色的都是对话框，只不过，加了比较多的tab页，同样的强大。

最最简单的Win32汇编程序是一个MessageBox，这是对话框的一种简单形式，Windows中很多好用的公用对话框，也是极大的简化了开发。RAD工具的出现也几乎是为了对话框而设置的，当拖放控件的潮流出现后，很多人就开始设想下一步不用敲代码完成程序的编写了：）

基本上，开发对话框程序的难易，在一定程度上决定着一个GUI库的使用难易程度。下面介绍手动创建一个简单的对话框PyQt程序。

# 最简单形式的对话框：

这里就像是PyQt(1)中的例子quit.pyw一样，那个例子是一个单纯的按钮。。。。。。。。实际上又没有办法突然显示个按钮，所以Qt自动为其加上了一个边框，真正的程序应该是这样的：

simplestdialog.pyw

```python
import sys
from PyQt4 import QtCore, QtGui


app = QtGui.QApplication(sys.argv)

dialog = QtGui.QDialog()
quit = QtGui.QPushButton("Quit",dialog)
QtCore.QObject.connect(quit, QtCore.SIGNAL("clicked()"),
    app, QtCore.SLOT("quit()"))

dialog.show()
sys.exit(app.exec_())
```

这样两个程序其实差不多，但是仔细看还是有一定区别的。如图：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_061809_1649_PyQt21.jpg)

默认的Qt对话框没有最大化和最小化按钮，而自动为button生成的有，然后button那里button占据了整个用户区域，而对话框这里由其自动生成的大小并没有。

# 从面向过程到面向对象

到目前为止，PyQt(1)中所有的程序都还是用面向过程的方式。大概如PyQt（1）layout.pyw例子中的形式。

在面向过程到面向对象的比较上原来奇趣的一个教程有很有示范性的对比。（reference 3）

比如，面向过程是这样的形式：

```python
#!/usr/bin/env python

# PyQt tutorial 3


import sys
from PyQt4 import QtCore, QtGui


app = QtGui.QApplication(sys.argv)

window = QtGui.QWidget()
window.resize(200, 120)

quit = QtGui.QPushButton("Quit", window)
quit.setFont(QtGui.QFont("Times", 18, QtGui.QFont.Bold))
quit.setGeometry(10, 40, 180, 40)
QtCore.QObject.connect(quit, QtCore.SIGNAL("clicked()"),
 app, QtCore.SLOT("quit()"))

window.show()
sys.exit(app.exec_())
```

这是同样程序的面向对象版本：

```python
#!/usr/bin/env python

# PyQt tutorial 4


import sys
from PyQt4 import QtCore, QtGui


**class** MyWidget(QtGui.QWidget):
**def** __init__(self, parent=None):
    QtGui.QWidget.__init__(self, parent)

    self.setFixedSize(200, 120)

    self.quit = QtGui.QPushButton("Quit", self)
    self.quit.setGeometry(62, 40, 75, 30)
    self.quit.setFont(QtGui.QFont("Times", 18, QtGui.QFont.Bold))

    self.connect(self.quit, QtCore.SIGNAL("clicked()"),
        QtGui.qApp, QtCore.SLOT("quit()"))


app = QtGui.QApplication(sys.argv)
widget = MyWidget()
widget.show()
sys.exit(app.exec_())
```

以上是两个几乎完全一样的程序，除了实现方式上的不同。

在实现上：

面向过程的方式大概的思路就像是生成一个默认的widget，然后通过函数调用，通过子widget按钮的创建去修饰这个widget，然后显示。

面向对象的方式大概思路就像是先描述我们想要的widget是有一个子widget按钮的，大小是多少。。。。。然后直接创建一个我们描述过的想要的widget，将其显示。

有人说，编程的方式取决于你看世界的方式-_-!其实这点用于对于面向过程和面向对象是比较合适的。

至于面向过程和面向对象的好处就不在这里费太多口舌了，也超出了本文的讨论范围。但是，即使是在这样简单的一个GUI程序中，不去讨论什么封装，数据隐藏等东西，也可以得出面向对象版本会更加容易复用一点。虽然N多书籍强调了使用面向对象技术最主要的原因不在于提高代码复用率，但是这一点确实是很有用并且最容易通过对比讲解的。比如，假如我们需要两个一样的这样的对话框显示不同标题，同时显示在不同位置的情况。

面向对象版本可以这样实现：

```python
#!/usr/bin/env python
# PyQt tutorial 4 ext objWindow

import sys
from PyQt4 import QtCore, QtGui


**class** MyWidget(QtGui.QWidget):
 **def** __init__(self, parent=None):
  QtGui.QWidget.__init__(self, parent)

  self.setFixedSize(200, 120)

  self.quit = QtGui.QPushButton("Quit", self)
  self.quit.setGeometry(62, 40, 75, 30)
  self.quit.setFont(QtGui.QFont("Times", 18, QtGui.QFont.Bold))

  self.connect(self.quit, QtCore.SIGNAL("clicked()"),
  QtGui.qApp, QtCore.SLOT("quit()"))


app = QtGui.QApplication(sys.argv)
widget = MyWidget()
widget.move(350,50)
widget.setWindowTitle("A Widget")
widget.show()
anotherWidget = MyWidget()
anotherWidget.move(50,50)
anotherWidget.setWindowTitle("Another Widget")
anotherWidget.show()
sys.exit(app.exec_())
```

尝试想象，面向过程的版本会怎么样？只能将所有的代码全部再复制一次，这面机械的操作我甚至都不想给出例子了。程序员的天性应该讨厌复制！

其实，这个面向对象版本的程序还有点问题，因为原来的程序中将对话框与应用程序混在一起了，所以连接按钮到qApp的退出槽上了，这样当你点击其中一个对话框的时候，两个对话框都关闭了。更加面向对象的做法是将其与对话框连接在一起。将那行代码改为：

self.connect(self.quit, QtCore.SIGNAL("clicked()"),  

self, QtCore.SLOT("close()"))  

这样就让两个对话框可以分开控制了，呵呵，关于类的职责问题一直是面向对象书籍讨论的重点，在这个简单的演示例子里面奇趣的教程也就没有考虑这么多了，所以才会出现这样的情况。

# 面向对象的对话框

前面的例子中，我们的widget是由QWidget继承而来，那么就是一个普通的widget,假如从dialog继承而来，那么就是一个dialog了，这样两者还是有一定区别的。

比如将上述的例子改成对话框。

```python
import sys
from PyQt4 import QtCore, QtGui


**class** MyDialog(QtGui.QDialog):
**def** __init__(self, parent=None):
    QtGui.QDialog.__init__(self, parent)

    self.setFixedSize(200, 120)

    self.quit = QtGui.QPushButton("Quit", self)
    self.quit.setGeometry(62, 40, 75, 30)
    self.quit.setFont(QtGui.QFont("Times", 18, QtGui.QFont.Bold))

    self.connect(self.quit, QtCore.SIGNAL("clicked()"),
    self, QtCore.SLOT("close()"))


app = QtGui.QApplication(sys.argv)
dialog = MyDialog()
dialog.show()
sys.exit(app.exec_())
```

显示的效果对比与前面的对比很相似：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_061809_1649_PyQt22.jpg)

这里我没有说明哪个是对话框，那个是widget,不过看过前面的对比也很明显了吧。这里有点要说明的是，在Qt中对话框与普通widget的区别与MFC中对话框与文档视图的区别要小多了，在上面的例子中我们也基本可以确定，当我们仅仅是想要显示一个button的时候，实际上Qt是为我们默认生成的是一个widget。

# 更复杂的对话框

《C++ GUI Qt4编程（第二版）》中第2章实现了一个比较复杂的对话框程序，我用Qt Creater尝试了其C++版本，好多代码要敲啊，所以反而丧失了再次敲代码去实现PyQt版本的意思。。。。。。。呵呵，不过，其实知道了大概流程和含义，看到C++版本的Qt程序，再实现一个PyQt版本的程序是非常省事的事情，都差不多。

不过，作为学习，我还是实现一个简化版本的PyQt对话框程序吧，不然private slots，Q_OBJECT，tr在PyQt中对应的东西我还真不知道。

complicateDialog.pyw

```python
import sys
from PyQt4 import QtCore, QtGui

**class** MyDialog(QtGui.QDialog):
**def** __init__(self, parent=None):
    QtGui.QDialog.__init__(self, parent)

    self.quit = QtGui.QPushButton("Quit")

    self.change = QtGui.QPushButton("Change")
    self.change.setEnabled(False)

    # funny widget
    self.lcd = QtGui.QLCDNumber(2)

    self.slider = QtGui.QSlider(QtCore.Qt.Horizontal)
    self.slider.setRange(0, 99)
    self.slider.setValue(0)

    self.lineEdit = QtGui.QLineEdit()

    self.connect(self.quit, QtCore.SIGNAL("clicked()"),
    QtGui.qApp, QtCore.SLOT("quit()"))
    self.connect(self.lineEdit, QtCore.SIGNAL("textChanged(const QString&)"),
    self.enableChangeButton)
    self.connect(self.slider, QtCore.SIGNAL("valueChanged(int)"),
    self.SliderChange)
    self.connect(self.change, QtCore.SIGNAL("clicked()"),
    self.Change)

    self.rightLayout = QtGui.QVBoxLayout()
    self.rightLayout.addWidget(self.lineEdit)
    self.rightLayout.addWidget(self.change)

    self.leftLayout = QtGui.QVBoxLayout()
    self.leftLayout.addWidget(self.lcd)
    self.leftLayout.addWidget(self.slider)

    self.layout = QtGui.QHBoxLayout()
    self.layout.addWidget(self.quit)
    self.layout.addLayout(self.leftLayout)
    self.layout.addLayout(self.rightLayout)

    self.setLayout(self.layout);

**def** enableChangeButton(self, text):
    self.change.setEnabled(text.isEmpty() == False)

**def** Change(self):
    value = int(self.lineEdit.text())
    self.lcd.display(value)
    self.slider.setValue(value)

**def** SliderChange(self):
    value = self.slider.value()
    self.lcd.display(value)
    self.lineEdit.setText(str(value))

app = QtGui.QApplication(sys.argv)
dialog = MyDialog()
dialog.show()
sys.exit(app.exec_())
```

我曾经怎么说来着？来个简化版？-_-!最后写着写着，为了试验新特性，结果说是复杂版也不为过了。

效果如图：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_061809_1649_PyQt23.jpg)

这个程序演示了几个Qt的特性:

1. 很有意思的lcd效果的数字，这种效果竟然原生在Qt的Widget中，很有意思。
2. 其中演示了4个widget的交互，分别是lcd,slider,change,lineEdit其中三个是可以控制的，lcd被动显示，每改动一个，都能在其他三个（两个）中反映出来。控制的方式是通过connect某个singal到对话框类的某个方法上。其中我发现PyQt的connect消息方式很搞笑，为什么这样说呢？因为在Python中，竟然出现了"textChanged(const QString&)"这样的字符串-_-!再强大的东西，毕竟是通过C++来实现的。。。呵呵，估计非C++背景的PyQt使用者会感到这样的语法比较困惑吧。。。。。。我也比较奇怪，PyQt为啥不干脆一次性将这样的Singal的字符串也改成Python的语法呢？呵呵，也许工作量会更大吧。当然，slot响应的方式倒是简化了一些，当时我还在想，以什么形式将slot的参数用字符串表示出来呢。。。。结果发现，完全不用表示。。。。如源代码所示。这方面有个文章讲的比较详细：[Connecting with signals and slots](http://www.commandprompt.com/community/pyqt/x1408)

3. layout的嵌套，实现了比较复杂的dialog,并且，在代码中我没有实际的通过任何坐标来控制它们，它们是自动放在了我希望它们在的地方，在这一点上，Qt对手工编写代码的友好性胜过MFC又何止百倍啊。

但是，其实上述代码的问题还是有的，比如，lineEdit widget可以输入任何形式的字符，而不仅仅是数字，这在我们这个例子中应该是不允许的，在Qt中也提供了一种远胜MFC的限制方式，不用继承并实现一个自己的lineEdit widget就能实现非常 复杂的限制功能，这和STL中泛型的算法思维有点类似。这就是Qt 中的Validator，功能强大到你甚至可以很简单的就使用正则表达式去限制lineEdit。。。。呵呵，强大。。。这里我根据需要，使用QIntValidator就足够了。

在上例中加入如下代码：

```python
intValidator = QtGui.QIntValidator(0,99, self)

self.lineEdit = QtGui.QLineEdit()

self.lineEdit.setValidator(intValidator)
```

加在那个位置就不用我教了吧，就是定义self.lineEdit的上下位置。再试试效果，除了0,99的整数，什么都输不进入了。

# 题外话：

在进入使用designer之前，我决定先看看一些关于PyQt的资料,(以前就是看 reference1那本书。单纯这样从C++转换到Python，光靠自己的理解还是难免会有些问题，虽然摸索着上面那样的程序也能写出来：)。但是，就我的经验来说，在使用图形化的设计工具前不将手工代码的原理都弄清楚，以后可能会不再想回过头来彻底弄清楚了，（因为图形化设计会简单的多），但是，碰到稍微有点例外的情况，却会手足无措（使用MFC的经验）。

# reference

1. C++ GUI Qt4编程（第二版） C++ GUI Programming with Qt4, Second Edition。Jasmin Blanchette【加拿大】,Mark Summerfield【英】著，闫锋欣，曾泉人，张志强译，电子工业出版社。
2. [GUI Programming with Python: Qt Edition](http://www.commandprompt.com/community/pyqt/)
3. [Qt tutorial](http://doc.trolltech.com/4.0/tutorial.html)
4. PyQt GPL v4.4.4 for Python v2.6 examples from [riverbankcomputing](http://www.riverbankcomputing.co.uk/)

