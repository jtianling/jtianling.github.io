---
layout: post
title: "字符串的多国语言支持解决方案 Qt篇"
categories:
- "通用编程技术"
tags:
- Qt
- "多国语言"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '142'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

最近比较懒，公司的事情忙完后，在家也就是看看《Game Engine Architecture》，好久没有写博客了，总算遭到报应了，昨晚腹泻，发烧，冷汗，今天一天班都没上，于是，闲话少说，还是写篇博客吧.......

    在不久以前，软件还是由一帮根本不知道世界上存在其他语言的美国人制作的，那时候他们只用ASCII编码去写软件。然后当他们发现世界上还有其他语种的人也需要使用软件，并且也有很大市场以后，出现了多字节的解决方案来解决字符串的国际化问题，但是那是段相当恐怖的日子。再然后，我们有了Unicode，一切就简单了很多。


<!-- more -->


    假如一个软件只支持中文，那么简单的使用unicode的中文去表示UI中的所有字符串就好了，但是要支持多国语言呢？具体说来怎么样才能方便的在不同语言中进行切换呢？

  

    Qt的强大程度在很多方面都远超一个framework应该呆的范围，基本上是一个强大的跨平台解决方案，其中，对于多国语言，Qt的解决方案也是我见过的最好的。

  

对于Qt的字符串来说，分成两种情况：

1.在Qt Designer中拖放控件时，控件上的字符串。比如，我摆一个label上去，叫做hello world。注意的是需要在translatable属性上打勾（默认就是打勾的），表示可以翻译。

 ![](http://hi.csdn.net/attachment/201108/11/0_1313029010lNCK.gif)

  

2.在代码里面直接指定的字符串，需要用tr()包含该字符串。比如手动创建一个label，显示Hello World Again!

```cpp
QLabel *label = new QLabel(this);
label->setText(tr("Hello World Again!"));
label->setGeometry(100, 100, 200, 25);
```

  

此时整体程序的显示内容如下：

![](http://hi.csdn.net/attachment/201108/11/0_13130290430duI.gif)

  

  

此时，通过Qt菜单中的（用了qt的Qt Visual Studio Add-in)的Create New Tranlation File，

![](http://hi.csdn.net/attachment/201108/11/0_13130290822mZ7.gif)

  

比如，这里我建了一个中文的文件，叫做qt_linguist_test_zh.ts，在VS中双击此程序，会用Qt Linguist打开此文件，接下来的就简单了：

![](http://hi.csdn.net/attachment/201108/11/0_1313029119P8a3.gif)

分别在左边选择字符串所在的context，然后在Strings里面会列出所有可以进行翻译的字符串，在Sources and Forms中甚至还能显示出上下文，帮助你进行翻译。

在下面的translation中写上你想翻译的内容，保存好。

  

在VS中，用lrelease解析（编译？）此文件  

![](http://hi.csdn.net/attachment/201108/11/0_1313029143Z6b3.gif)

  

此时，可以在工程目录下看到一个叫做qt_linguist_test_zh.qm的文件，就是刚刚生成的文件。在代码中使用该多国语言的文件实在是简单了，只需要下面几行代码：  

```cpp
QApplication app(argc, argv);
QTranslator translator;
translator.load("qt_linguist_test_zh.qm");
app.installTranslator(&translator);
```

从此以后，所有的字符串都会按照你翻译过的来显示：

![](http://hi.csdn.net/attachment/201108/11/0_1313029165jLlL.gif)

  

小结：

Qt的多国语言支持主要来源于Qt Linguist这个翻译程序，按照Qt本身的设计，这个程序甚至是交由翻译人员去使用的，和程序员无关，程序方面只需要记得在代码里面的字符串加tr()就行，然后通过lupdate（在上面的例子中用Qt Visual Studio Add-in来完成了）去提取代码中所有可以翻译的字符串，生成ts文件，然后把ts文件交给翻译人员使用即可。其方便性在于不仅是程序员使用方便，还从软件开发流程上让各个环节都有合适易用的工具去高效的完成各自工作......作为程序员，开发一个Qt的多国语言支持的软件几乎没有任何额外的负担..............

  
  



[](<http://www.jtianling.com>)  
[](<http://www.jtianling.com>)
