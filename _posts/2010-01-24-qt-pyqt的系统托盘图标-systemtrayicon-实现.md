---
layout: post
title: Qt/PyQt的系统托盘图标（SystemTrayIcon）实现
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
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)

估计这种小的知识会有几篇文章，除了全局快捷键部分外，其他的都比较简单，都是我实现[“onekeycodehighlighter"](<http://code.google.com/p/onekeycodehighlighter/>)  
  
中碰到的一些小问题，这里顺便整理一下。事实上，稍微懂一点的人，去看看one key code highlighter的源代码都能明白了。这里相当于将其详细的剖析一下。。。。。。。另外，实现上用Python+PyQt，事实上，主要的部分是对Qt的一些类的使用，所以其实看懂了C++的Qt中使用上是一样的。啥？你看不懂Python？好的，这就是我为什么靠C++吃饭，却学习JAVA,JavaScript,Lua,Python,Bash的一个原因，不然你看不懂别人在写啥-_-!（当然，我基本上也就学到能看懂）  
对于pyQt完全不懂的，这里也不用看了，《[pyqt  
的学习(1) 入门](<http://www.jtianling.com/archive/2009/06/17/4272009.aspx>)  
  
》，《[pyqt  
(2) 对话框...](<http://www.jtianling.com/archive/2009/06/20/4281633.aspx>)  
  
》可以看看，但是写的有点乱，因为那时候我懂得也少（不代表现在就懂的多了）

SystemTrayIcon在官方的Demo中有一个示例，（那些示例有些可真酷啊！）位置在Desktop->System Tray中。该示例展示了大部分需要用到的内容。包括实现TrayIcon，显示气泡信息，TrayIcon的菜单等等。

## 创建系统系统托盘图标（TrayIcon)

主要用到的类是QtGui.QSystemTrayIcon。  
图标用QtGui.QIcon类来表示，可以以文件名字符串为构造函数的参数。如：  
  
icon = QtGui.QIcon('jt.png  
')  
  
然后用QtGui.QSystemTrayIcon的

  
setIcon(icon) 去完成系统TrayIcon的创建。OK，已经完成80%了，图标已经出来了。

## 气泡信息  

再然后呢？希望有特定的气泡信息？  
  
QtGui.QSystemTrayIcon的showMessage  
可以完成。

## 菜单

再然后呢？希望有菜单？这个稍微复杂点，在Qt中，菜单是一个一个的Action，如下建立Action:  
  
  
        self.quitAction = QtGui.QAction("&Quit  
", self,  
                                        triggered=QtGui.qApp.quit)  
          
        self.aboutAction = QtGui.QAction("&About  
", self,  
                                        triggered=self.about)  
注意上述Action的triggerd参数，实际上是一个Callable的回调函数，意思是点击此菜单时进行的操作。  
然后将Action添加进某个Menu  
  
  
self.trayIconMenu = QtGui.QMenu(self)  
  
self.trayIconMenu.addAction(self.aboutAction)  
self.trayIconMenu.addAction(self.quitAction)  
然后将Menu  
关联上TrayIcon  
self.trayIcon.setContextMenu(self.trayIconMenu)

完成了。

 

## CheckBox菜单

 

我的需求更加复杂一点，希望有可以Check的菜单，当然，这个需求已经超出SystemTrayIcon相关的需求了，与Qt中的菜单有关。

将需要实现成Check菜单的所有命令添加到一个Action组中，在Qt中称为QActionGroup。

  
  
        self.synGroup = QtGui.QActionGroup(self)  
          
        **for**  
  
 syn **in**  
  
 config.syntaxSupport:  
            action = QtGui.QAction(syn, self, checkable=True,  
                triggered=self.setSyn)  
            self.synGroup.addAction(action)

 

需要注意的是，每个Action的checkable参数设为True,表示是CheckBox类型的菜单。  
通过某个Action的setChecked来选中，比如：

        actions = self.synGroup.actions()  
  
  
        **if**  
  
 len(actions) != 0:  
            actions[0].setChecked(True)

主要注意的是，在Qt中QActionGroup返回的是一个QList的列表，但是在PyQt已经将其转换为Python中原生的list了，这样更加符合Python的使用习惯，当然，调用方法的时候也需要注意一下了，接口可是不同的，感谢RiverBank(PyQt的创造维护公司）伟大的工作，对于可怜的RiverBank我其实还有话要说，以后再详述吧。  
具体哪个菜单选项被Check了，通过  
  
  
checkedAction = self.synGroup.checkedAction()  
来查询，返回的是被Check的Action，此时假如你是通过Action的字符串来查询的话，（比如我）那么调用Action的text  
函数获取。

一切都结束了。。。。。。。需要注意几个特别的地方：  
1。官方的教程中，有  
QtGui.QApplication.setQuitOnLastWindowClosed(False)  
这样一句，大概的意思是在应用程序所有窗口都关闭的时候不关闭应用程序，事实上，就我试验，无论是设为True,还是False，都不管关。。。。。。原因不明。  
2。在应用程序利用QtGui.qApp.quit关闭后，TrayIcon其实还不会自动消失，直到你的鼠标移动到上面去后，才会消失，这是个问题，（如同你terminate一些带TrayIcon的应用程序时出现的状况），这种问题的解决我是通过在程序退出前将其setVisible(False)来完成的。

##  

 

##  

##  

## 完整源代码获取说明

由于篇幅限制，本文一般仅贴出代码的主要关心的部分，代码带工程（或者makefile）完整版（如果有的话）都能用Mercurial在Google Code中下载。文章以博文发表的日期分目录存放，请直接使用Mercurial克隆下库：

[https://onekeycodehighlighter.googlecode.com/hg/](<https://blog-sample-code.jtianling.googlecode.com/hg/>)

Mercurial使用方法见《[分布式的，新一代版本控制系统Mercurial的介绍及简要入门](<http://www.jtianling.com/archive/2009/09/25/4593687.aspx>)  
》

要是仅仅想浏览全部代码也可以直接到google code上去看，在下面的地址：

[http://code.google.com/p/onekeycodehighlighter/source/browse/](<http://code.google.com/p/jtianling/source/browse?repo=blog-sample-code>)

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

 
