---
layout: post
title: OPhone SDK初体验
categories:
- Android
tags:
- Android
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '13'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**OPhone SDK初体验**

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)****

[讨论新闻组及文件](<http://groups.google.com/group/jiutianfile/>)

# 背景说明 

中国伟大的垄断龙头，世界上也是顶尖的中移动终于出手了，出手不凡，成为了世界上第一个开发自由操作系统的移动运行商。操作系统的名字叫做OPhone，从CSDN上知道此重大消息后，我放下了手头的一切，全身心地开始追随中国移动领域的领头羊。 

OPhone:官方的描述如下； 

> 什么是OPhone： 

> OPhone是基于Linux、面向移动互联网的终端基础软件及系统解决方案。 

> OPhone SDK是专为OPhone平台设计的软件开发套件，它包括OPhone API，OPhone模拟器，开发工具，示例代码和帮助文档。 

 

恩，不是Windows的东西，这点我比较满意，Linux是较为自由的，再加上众所周知的，OPhone是基于Google的Android系统的二次开发（因为如此的总所周知，所以中移动甚至都不需要提醒大家这一点，并且，这种决心不依赖Android这颗相对成熟的大树乘凉，不依靠Google名声去光耀自己招牌的作风更加让我佩服---PS:在中国中移动似乎也没有必要去依赖Google这种国外公司的名声，中国谁不知道中移动？除了搞IT的知道Google的又有多少？） 

作为搞IT的，我个人是比较喜欢Google公司的，而且也对Android早有耳闻，所以虽然作为一个网络游戏服务器端程序员，我也为此专门的熟悉了一下Eclipse和JAVA，但是一直没有决心和毅力投身此行业，仅仅作为业余的爱好玩玩而已，毕竟国内甚至连一款Android的手机都没有！但是移动一出手，就知道有没有，随着联想的OPhone手机即将推出，OPhone在中国的开发应用环境已经远胜Android，于是，再加上中移动在中国雄踞南北的霸气，将来OPhone在中国的市场将远大于Android。今日，我决心追随中移动的脚步。。。。再加上OPhone的开发实际是建立在Android之上的，（下面马上就能看到）这样，我学习OPhone的经验永远不会白费，走在世界上任何一个角落，在国外也是有生存余地的，因为上面那么多的原因，我决心投身OPhone领域，谁也拦不住我了。今日是个起点，阿门。 

 

#     安装OPhone SDK 

安装前自然要下载，但是下载前首先要在中移动那里注册，网址是"<http://www.ophonesdn.com/>"，就我的理解，是OPhone-software-develepment-net。首先注册，然后通过验证，然后登录,闲话少说了，直接进入正题，下载，Windows版本下载地址为： 

"<http://dl.oms-sdn.com/sdk/ophone-sdk_windows-1.0-setup.jar>" 

Linux下载版本为： 

"http://dl.oms-sdn.com/sdk/ophone-sdk_linux-1.0-setup.jar" 

jar格式的问题，属于标准的JAVA包的格式，不用说，OPhone下的开发为了方便广大已经熟悉了Android和世界上最流行的语言JAVA的用户，用的是JAVA语言，知道这一点，我窃喜，前段时间为Android看了2，3天的《JAVA编程思想》没有白费。 

 

文件不大，就100多M，接着自然就是安装了，OPhone的安装虽然极为简单及人性化，但是中移动还是更为人性化的提供了详细的安装步骤，力求做到傻瓜似教学。 

首先，前提条件，需要下载如下东西： 

  * Eclipse IDE 

    * [Eclipse](<http://www.eclipse.org/downloads/>) 3.4.2 (Ganymede) 

      * Eclipse [](<http://www.eclipse.org/jdt>)JDT 插件 (大部分的Eclipse IDE包已经包含JDT插件) 

      * [WST](<http://www.eclipse.org/webtools>) 3.0.4 

      * [EMF](<http://www.eclipse.org/modeling/emf/downloads/>) 2.4.2 

      * [GEF](<http://www.eclipse.org/gef/downloads/>) 3.4.2 

    * [JDK 5](<http://java.sun.com/javase/downloads/index.jsp>) or [](<http://java.sun.com/javase/downloads/index.jsp>)JDK 6 (包括JRE) 

    * [ADT开发工具](<http://www.ophonesdn.com/documentation/ophone/gettingstarted/installing_adt.html>)

    * [WDT开发工具](<http://www.ophonesdn.com/documentation/ophone/gettingstarted/installing_wdt.html>)

    * ADT与GNU Java编译器(gcj)不兼容。

 

先全部下来并安装再说吧。 

然后再在安装目录下输入如下命令（以Windows版本为例）： 

java -jar ophone-sdk_windows-1.0-setup.jar 

然后按管理狂按下一步就好 

安装后的属性如下： 

大小：200 MB (210,116,917 字节) 

占用空间：205 MB (215,261,184 字节) 

 

比Android最新版1.5 r3的占用大小： 

大小：446 MB (468,160,733 字节) 

占用空间：461 MB (484,167,680 字节) 

 

要小的多，这也体现了中移动对于Android的优化，（从体积上都能看出来），体现了二次开发的成果。最后我通过比较，两者唯一相似的仅仅是Tools的名字及一些库了，相同的库如下： 

/tools/lib/jcommon-1.0.12.jar 

/tools/lib/jfreechart-1.0.9-swt.jar 

/tools/lib/jfreechart-1.0.9.jar 

/tools/lib/org.eclipse.core.commands_3.2.0.I20060605-1400.jar 

/tools/lib/org.eclipse.equinox.common_3.2.0.v20060603.jar 

/tools/lib/org.eclipse.jface_3.2.0.I20060605-1400.jar 

/tools/lib/swing-worker-1.1.jar 

/tools/lib/swt-awt-win32-3236.dll 

/tools/lib/swt-gdip-win32-3236.dll 

/tools/lib/swt-wgl-win32-3236.dll 

/tools/lib/swt-win32-3236.dll 

/tools/lib/swt.jar 

可以看到，为了方便大家，也为了更好的体现开源共享的精神，中移动原封不移动的使用了google的jcommon,core等核心库，使用了swing,swt等界面库，实在是广大开发者的福音。更近一步的坚定了我追随中移动的步伐。 

接着，按照文档，一步一步的添加用户库，文档啥的，都不在话下，因为以前装过ADT了，所以对我来说还算省事，最后，当我使用了中移动提供的模拟器后，感觉真是惊艳啊。。。。呵呵，这里和原有的Android的模拟器做一个对比。 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080309_1638_OPhoneSDK1.jpg)

左边的是OPhone,右边的是Android，从Android稀稀拉拉几个图标与OPhone满布屏幕的图标对比，可以看出OPhone更多内置的功能。OPhone模拟器有着熟悉绚烂的开启铃声，叮叮叮叮叮叮~~~，中文化的界面中可以看到飞信，Monternet，China Mobile的图标，OPhone不愧为移动深度定制的产品。。。以至于我。。。决定从这个月省吃兼用，等联想一出OPhone，一定第一时间购买！ 

 

# Hello World 

按照教程，一步一步走来，总算可以真正的尝试开发一下Android程序了，真是兴奋啊。。。呵呵，不是，是开发OPhone程序。。真是兴奋啊。。。啊？为啥开发OPhone程序要新建一个Android工程啊？这点颇为郁闷，整个Android SDK的名字都改成OPhone SDK了，一个小小的Eclipse ADT插件都不能改？在这点上，我稍微的质疑一下中移动同志们垄断3G 及智能手机市场的决心。。。。当然，仅仅是稍微质疑一下，也许ODT正在紧张的开发之中吧。 

一开始我的创建新Android工程的画面与官方的有点不一样。。。难道是因为我的ADT太新？。。。。。汗-_-! 

对比如下： 

官方的： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080309_1638_OPhoneSDK2.jpg)

我的： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080309_1638_OPhoneSDK3.jpg)

在build Target和Min SDK Version两栏我实在是不知道该选什么。。。。真是郁闷啊。回过头来看看原来中移动主页上的说明： 

> ADT是为在Eclipse IDE下进行OPhone应用开发而提供的Eclipse插件。如果要使用Eclipse作为调试和编译的集成开发环境，则需要首先安装ADT。 

> 下载[ADT 0.8.0 zip file](<http://developer.android.com>) (不必解压该文件)。你也可以在SDK目录中找到ADT安装包：sdk_folder/tools/ophone/ADT-0.8.0.zip 

晕，果然是版本太新，官方的是Eclipse3.4,ADT 0.8.0 

我是EClipse3.5.0,ADT0.9.1了。。。总不能降级吧。。。。我怀着忐忑不安的心，期盼着中移动以高超的技术实现对Android新版插件的兼容。。。 

先按上面那样选择再说吧。 

通过上面步骤生成出来的程序还比较大，包括一个src,一个packet,一个Res,Res又包括XML格式的layout和values，甚至还有一个drawable的icon.png图标。这样的程序不需要按官方网站上的说明去改造，本身就是一个可以执行的Hello World程序，当尝试运行的时候，我发现。。。。。没有办法Run As OPhone Application.....晕，看了主页上的说明。。。原来官网的做法也是Run As Android Application。。。不去修改ADT的余毒至深矣。。。。。问题是，中移动一般人开发一个OPhone的模拟器容易吗？做来好看的？谁做的官方网页教程啊？竟然这样教人，这不是误人子弟吗？虽然我们知道OPhone的程序实际可以在Android中运行，但是我们尽然是开发OPhone程序，自然要看着它在OPhone中运行啊。。。。。。。 

唉。。。。竟然如此，将string资源的hello变量值改为Android吧，运行效果如下： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080309_1638_OPhoneSDK4.jpg)

 

算了，这些姑且不论，仅仅算是OPhone中的一个小瑕疵吧，先来看看中移动的OPhone对Android进行了哪些深度定制，进行了哪些改进，进行了哪些优化或者升级吧。。。。。。 

参考一下文档，就能知道个大概了： 

**OPhone API Reference**

### Contents 

  * [本地搜索（Local Search）](<http://www.ophonesdn.com/documentation/ophone/reference/ophoneapi/localsearch/oms/servo/search/SearchProvider.html>)

  * [主屏（Home）](<http://www.ophonesdn.com/documentation/ophone/reference/ophoneapi/homescreen/oms/home/HomeIntents.html>)

  * [邮件（Mail） ](<http://www.ophonesdn.com/documentation/ophone/reference/ophoneapi/mail/oms/mail/package-summary.html>)

 

恩，不错，看来，OPhone对Android进行了3大块的改造。分别是Home Screen,Local Search,Mail，听起来都是挺重要的模块嘛，一个一个来： 

> OPhone Home Screen is the home screen application in OPhone platform. The class defines some constants used by Home Screen API. If you want to add/change an item on home screen, you can send some Intent to the home screen application. Then the home screen application will process this action. 

不错，OPhone的Home Screen给Android的改进是增加了一种对OPhone手机Home Screen的一种通信机制，看起来还不错。 

Local Search这样重要的功能也有了，了不起，Mail这样的功能自然更加是需要啦，不错，果然是OPhone，就是名不虚传。 

 

后来，我在OPhone SDK文档中看到了非常振奋人心的消息： 

> OPhone是基于Linux面向移动互联网的终端基础软件及系统解决方案。OPhone SDK是专为OPhone平台设计的软件开发套件，它包括OPhone API，OPhone模拟器，开发工具，示例代码和SDK帮助文档。OPhone SDK兼容Android SDK，因此开发者在开发OPhone应用的时候可以同时使用OPhone API和Android API。 

 

# 展望 

太强大了！！！！OPhone是兼容Android API的，伟大的设计啊。。。大家都知道，Android手机是有一些优点的，OPhone又是与之兼容的，那么我们买了一个OPhone手机，就相当于同时又买了一个Android手机，简直就是买一个顶两个，开发难度却相当于一个，这简直#@%#@%#@%太强大了，无论对于普通用户还是对于程序开发者都是天大的好消息，从此后，开发OPhone应用程序，不回头。 

  
  

