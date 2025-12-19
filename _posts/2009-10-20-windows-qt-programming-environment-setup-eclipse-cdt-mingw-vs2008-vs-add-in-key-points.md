---
layout: post
title: Windows下的Qt编程环境配置(Eclipse+CDT+MinGW与VS2008+VS Add in)要点
categories:
- "未分类"
tags:
- CDT
- Eclipse
- MinGW
- Qt
- VS Add in
- VS2008
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '32'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

介绍Windows下Qt环境配置要点。Eclipse需注意make文件，VS2008配置繁琐，推荐使用专用安装器避免手动编译。

<!-- more -->

# Windows下的Qt编程环境配置(Eclipse+CDT+MinGW与VS2008+VS Add in) 要点



本文不准备详细的讲解每一步，那是侮辱准备开始进行Qt学习的人的智商，仅仅将容易碰到的问题和关键步骤。

## Eclipse+CDT+MinGW：

没有话说，首先下载安装带[CDT的Eclipse](<Eclipse IDE for C/C++ Developers \(79 MB\)>)，[Qt的Windows安装包](<http://qt.nokia.com/downloads>)。Qt的安装包中是附带了MinGW的，虽然版本相对会老一点，所以不求新的完全可以不自己安装MinGW。（[MinGW](<http://sourceforge.net/projects/mingw/files/>)的安装，推荐下载自动安装包安装)

然后就是Qt的Eclipse integration，也有安装包，配置正确，安装完成后，安装部分完成的差不多了。

配置过程，首先Eclipse中将C/C++->New CDT project wizard中的toolchains改成MinGW GCC，并设为默认，然后将MinGW目录中（假如没有单独安装Qt的目录下有）的mingw32-make.exe改为make.exe，这一步很关键，切记，当年我缺少make.exe很郁闷直接下了个GNU版本的make程序，自以为应该错不了，结果GNU的make在解析Windows版本程序的时候会出现问题，我很久都没有发现是GNU make程序的问题（主要问题在于程序路径的解析），剩下的就简单了，建立工程时选other,会看到Qt的工程向导，建好，编译，运行。

## VS2008+VS Add in

VS2008安装就不多说了，[Qt VS add in](<http://qt.nokia.com/downloads>)的安装也不多说了，都是普通的安装包，很简单，但是配置，让人吐血，这一步没有看文档能够完成的，那是天才。当时都安装完以后，新建工程会出现Qt的向导，但是使用后，会发现创建不了，提示你配置Qt，然后会发现VS2008中已经出现Qt的菜单项，选择Qt Option后，可以看到需要配置Qt SDK的路径，选择后，你无论确认多少次你选择是正确的，但是OK按钮永远还是不可用，一直灰显的，你会纳闷了，程序出问题了？明明选择正确了啊？这就是Nokia出的高级软件-_-!

事实上，是配置不对，目录对了，但是目录里面的东西不对，你选择是是MinGW版本的Qt SDK-_-!事实上，Nokia就没有配置好的VS Qt版本提供下载，需要搭配VS使用时，需要自行配置。在Qt SDK安装目录下，将整个以时间命名的目录拷贝一份（保留MinGW版本以配合Eclipse），在此目录的下一层目录的Qt/bin中会发现configure.exe程序，我们需要运行此程序对Qt进行配置。我推荐配置命令是

D:/Qt/vs2008ver/qt>configure -opensource -debug-and-release -platform win32-msvc2008 -no-sql-sqlite -no-qt3support -no-dbus -no-phonon -no-phonon-backend -no-webkit -no-libtiff -no-dsp

剩下来进行傻瓜式选择，开始等待Qt的配置。配置完成后，用nmake编译，留下至少7G的空间用于存放中间文件，然后等N个小时吧（鬼知道Qt到底多么庞大）祈祷你成功吧，然后再次进入VS的Qt Option选项，选择目录，总算看到OK按钮活过来了，不容易啊，在Windows中要求进行Linux般的配置，会难住更多的人，因为在Linux下我进行再复杂的配置都习以为常，但是在Windows下我只习惯下一步。。。。。。。。。。。。

这一段讲这么多，是希望大家亲自来感受一下被折磨的感觉-_-!还有以防进行到一半需要帮助的难兄难弟，其实，正因为这个步骤实在是繁琐加费时，所以，现在有个专门的开源项目来解决此事，那就是[qt-msvc-installer](<http://code.google.com/p/qt-msvc-installer/>)，经我试用，感觉比上述过程实在是一个天一个地，我庆幸我用的是VS2008，因为上述项目只支持VS2008，同用VS2008的人庆贺吧，说开源不好的人（比如Qt在这点上做的）的确有道理，但是没有开源（比如说[qt-msvc-installer](<http://code.google.com/p/qt-msvc-installer/>)），那我们就还是在做着那些重复的，无意义的，让人郁闷及崩溃的事情。

### 感想（可忽略，纯粹废话）

一般而言，在Windows下安装软件，配置软件比Linux下容易的多，随着yum,apt等工具的发展，事情慢慢开始发展变化了，最近发现Qt的变成环境可以作为极端的例子来看，在Linux下配置一个Qt的编程环境那是相当简单的事情，因为其他的一切都已经有了，g++,make,有了，qt4可以通过apt-get安装，已经存在一个qt的C++的编译环境了，我们需要做的就是下载Eclipse并安装（事实上kubuntu9.04中也可以apt-get安装的，但是版本太老），再搭配一个qt的eclipse插件，就一切OK了，全过程不要1个小时，但是要在Windows下搭建一个类似的环境谈何容易啊，没有勇气，信心，毅力的同志根本不可能在不参考教程的情况下解决。。。。参考教程也需要毅力。。。。（最近Linux软件的配置安装都很少看类似的东西了，Windows下更加是很久很久没有听说过安装软件要看教程的了）

其实，VS版本的Qt难以配置使用应该来说有一部分是Nokia的因素，他们是故意设计难用的，因为他们有好用的Windows下的商业版本用来卖钱，其实这是奇怪的继承了奇趣的传统，奇趣需要这种手段赚钱，但是Nokia根本不会需要这点零头，Nokia需要是的极大的推广Qt，以获取开发人员对其移动平台的支持(支持塞班的Qt就要发布了）。。。。现在Gnome与GTK+声势已经盖过KDE+Qt了，但是Nokia却仍然不肯放弃那古老的传统，这是我不能理解的。


