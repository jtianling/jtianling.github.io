---
layout: post
title: "从C++到JAVA(1) 在CSDN博客中部署及运行JAVA Applet"
categories:
- "未分类"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '20'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

C++程序员学习Java Applet的入门教程，讲解代码编写与HTML部署方法，让程序在浏览器中直接运行。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

Technorati 标签: [JAVA](<http://technorati.com/tags/JAVA>),[JAVA Applet](<http://technorati.com/tags/JAVA+Applet>),[Applet Tag](<http://technorati.com/tags/Applet+Tag>),[Deploy Applet](<http://technorati.com/tags/Deploy+Applet>),[从C++到JAVA](<http://technorati.com/tags/%e4%bb%8eC%2b%2b%e5%88%b0JAVA>)

## 前言

曾经，我有一个梦想，那就是我的程序能让人不需要下载就能通过浏览器运行，可惜学习的C,C++等都不具备此能力，学习完Python后，发现其也仅仅是以服务器端的开发为主，JS这种语言是慕名已久，买了著名的犀牛书，但是却一直未得时间细看，但是，JAVA会给我这个机会的。事实上，JAVA在最开始的时候就是因为JAVA Applet而流行起来。(参考二前言所言）因为以上原因，我学习JAVA也决定从JAVA Applet开始。

因为以后的工作会使用到JAVA，我不得不开始真正耐心的学习JAVA了，以前因为对Android的兴趣，浏览了《Thinking In JAVA》一书，但是一直没有真正的掌握和使用，工作压过来了，我算是彻底对JAVA缴枪投降了（事实上，作为C++程序员，很长时间我对JAVA有抵触情绪-_-!），这里，我以一个C++程序员的身份，提供一份从我C++到JAVA的学习记录，尽量将其做成从C++到JAVA的指南。首先说明一点的是，本人从来没有打算放弃C++，也不推荐任何人如此，从C++到JAVA仅仅指的是学习的流程而已，《JAVA Programming Language》与《Thinking In JAVA》两本书都非常不错，但是由于其目的的大而全，所以事实上对于C++程序员来说（比如我），篇幅过于巨大，熟悉了C++和OO的话也会碰到太多重复的内容，本人尽量将不同抽出来，忽略重复，提高学习效率。。。。要看完那两部大部头，实在得花太过不必要的时间。切记，本人假设读者非常熟悉C++及OO相关概念，重复内容一律不提，编程的基本知识更加是一律不提。

## JAVA编程环境

毫无疑问，推荐先到<http://www.java.com>上去下载一个最新的JRE安装，而后，我出于方便，使用Eclipse作为IDE编辑和编译JAVA程序，运行嘛，由于我准备将左右的程序都做成JAVA Applet，所以，事实上，所有的程序都可以再浏览器中运行。JDK的话，可以使用Eclipse带的，也可以到JAVA的网页上去下载，这个随便，我是下载了一个。

## JAVA Applet程序入门

为了使概念的演示更为直观,也减少大家对源代码运行的负担，首先学习的是JAVA Applet的编写，这样，以后的例子全部通过浏览器就能运行，大家可以在博客中直接查看运行效果，呵呵，这样也算利用JAVA的一点优势。。。。。将来我要是准备学习HTML,JS的时候都可以使用此方式，但是学习C++的时候。。。。。呵呵，就没有办法了。呵呵，在此离开老是依赖截图的日子吧。。。。。。。

首先看一个最简单的JAVA Applet程序：

```java
import java.applet.Applet;  
import java.awt.*;  
      
public class AppletHelloWorld extends Applet   
{  
    public void paint(Graphics g)   
    {  
        g.drawString("Hello Wolrd",10,50);  
    }  
}
```

JAVA程序有个让C++程序员别扭的特点，完全以对象为基础，没有任何全局函数，在普通的JAVA程序中即使是使用Main函数都是弄成一个类的静态成员变量，扭曲的无以复加。。。。（个人观点）当然，习惯的人也许觉得没有什么，个人感觉有点太强制了。。。。也许用惯了C/C++的人都太习惯自由吧。。。。呵呵，也不仅仅是这样说，Python不也是一切皆对象吗？还是可以方便的定义全局函数和变量，不仅仅是C/C++程序员才拿自由说事儿。

当然，这种强制性的思想是想将大家都往面向对象的正路上拽（James Gosling认为这是正路吧），与C++这种兼容C存在的半吊子面向对象编程语言决裂，以防落入C++开发者常常使用的C思维，可惜的是，事实上需要全局函数和变量的时候大家还是变着法子的用，单件，资源类则如是。。。。

说多了题外话，看这个例子吧，因为目前主要是将JAVA Applet程序的编写和部署，为以后的演示提供方便，暂时不准备详细讲解JAVA，所以关于语法的东西一切从简了，但是基本上希望大家能理解此例子。

import类似于C++中的include，但是不仅仅是那样，因为import不是文件，而是包，应该来说，更像是Python中的import，当然，编程时这样做会更加的便捷一些，特别是当这些语言不再拘泥于C++形式的声明实现分离时。java.applet.Applet的引入是此JAVA applet例子必须的，因为后面的主要类就是继承自Applet。java.awt是java的界面库，以*的形式表示引入此分类下所有类。

唯一的类AppletHelloWorld继承自Applet，继承时以extends关键字表示继承。所有的applet程序都必须含有一个直接或者间接继承自Applet类的类。public class中的class不用我多解释了吧，呵呵，public用于修饰类，表示此为公用类，可被此文件外的类所引用，不然，仅仅能被此文件中的类使用，JAVA的这种以文件分割类的方式（还以目录分割包）本人比较欣赏，虽然又多了份限制，但是能强制性的更好的管理大型项目的目录结构。后一个public用于修饰paint函数，此处与C++中的作用类似。paint函数是Applet类从java.awt.[Container](<http://java.sun.com/javase/6/docs/api/java/awt/Container.html>)继承过来的，用于绘制图形（类似于MFC中的OnDraw和Qt中的paintEvent）。

paint函数的参数是个Graphics类的对象，java.awt.Graphics属于Java中显示的基本类，地位基本相当于Qt中的QPainater。此处用Graphic的drawString方法显示了"Hello World”字符串。

以上基本上就是这个简单的JAVA Applet程序的解释了。

## JAVA Applet程序部署及运行

关于JAVA Applet的部署其实JAVA的官方主页上有一大节讲这个的，关于用Applet Tag部署的内容见《[Deploying With the Applet Tag](<http://java.sun.com/docs/books/tutorial/deployment/applet/html.html>)》。

首先，假如使用命令行操作的话，将上述代码保存成一个名为AppletHelloWorld.java的文件，并用javac编译，生成AppletHelloWorld.class文件。假如使用Eclipse的话就简单了，生成一个工程，文件名不要错了，然后build projects就好了（或者是自动编译的），然后（默认情况下）可以在工程的bin目录下找到AppletHelloWorld.class。

生成的class文件就是我们需要运行的文件，部署JAVA Applet时，需要建立一个如下简单内容的HTML文件：

```html
<html>  
<head><title>我的第一个JavaApplet程序</title></head>  
</body>  
<p>  
<applet code=AppletHelloWorld.class  
width=300  
height=200>  
</applet>  
</body>  
</html>  
```

保存为html文件，并放在与class文件同一目录下，用浏览器打开此html文件即可看到运行效果，显示hello World字样，此文字并不是写死在HTML中的，而是由JAVA Applet动态运行生成并显示的。。。。。虽然在此例中还看不出区别-_-！但是，现在仅仅是个Hello World程序嘛，不用急。在官网上讲的所有applet tag部署内容都是假设jar或者class是在当前目录下的，这在自己做网站的时候或者本地实验没有什么，可以自己确定各个文件的位置，可是在CSDN博客上这一套就行不通了，还好我找到了HTML的[applet tag的specification](<http://www.w3.org/TR/1999/REC-html401-19991224/struct/objects.html#h-13.4>),其中有个官网没有讲到的确定文件位置的codebase tag。

此时，我将上述class文件上传到我在google code上托管的地方，（事实上，大家愿意上传到哪里都可以，只要提供了直接的链接地址就行）然后直接用codebase指定位置，然后直接将相关的html嵌入此博文，那么，大家就能直接看到运行效果了：）

代码如下：

```html
<p>  
<applet codebase="http://jtianling.googlecode.com/files/"  
        code="AppletHelloWorld.class"  
width=300  
height=200>  
```

下面是一个java applet程序的运行效果：

并且发现，文档中明确说明：

**“APPLET is[deprecated (with all its attributes)](<http://www.w3.org/TR/1999/REC-html401-19991224/conform.html#deprecated>) in favor of [OBJECT](<http://www.w3.org/TR/1999/REC-html401-19991224/struct/objects.html#edef-OBJECT>).”**

让我大为郁闷。。。。。。。deprecated的东西了。。。。但是本人目前不准备深入的去研究HTML，仅仅是学习JAVA，甚至JAVA Applet的学习都是为了JAVA的学习时演示方便，所以，怎么将上述applet tag的例子转化为用OBJECT tag，我就不研究了，应该不难。

说明：本人学习JAVA时间较短，虽然尽量保证所写下的是有依据的东西，但是并没有讲C++程序时那么有把握，所以碰到不对的地方还请各位JAVA高手指正。

## 参考资料

1.《Thinking In JAVA》，英文版，第4版，Bruce Eckel著，机械工业出版社

2.《JAVA Programming Language》，英文版，第4版，Ken Arnold,James Gosling,David Holmes著，人民邮电出版社

3.《[JDK 6 Documentation](<http://java.sun.com/javase/6/docs/>)》，JAVA在线文档集合

4.《[The Java Language Specification, Third Edition](<http://java.sun.com/docs/books/jls/third_edition/html/j3TOC.html>)》

5.《[Java™ Platform, Standard Edition 6 API Specification](<http://java.sun.com/javase/6/docs/api/index.html>)》

6.《[HTML 4.01 Specification](<http://www.w3.org/TR/1999/REC-html401-19991224/>)》

## 完整源代码获取说明

由于篇幅限制，本文一般仅贴出代码的主要关心的部分，代码带工程（或者makefile）完整版（如果有的话）都能用Mercurial在Google Code中下载。文章以博文发表的日期分目录存放，请直接使用Mercurial克隆下库：

<https://blog-sample-code.jtianling.googlecode.com/hg/>

Mercurial使用方法见《[分布式的，新一代版本控制系统Mercurial的介绍及简要入门](<http://www.jtianling.com/archive/2009/09/25/4593687.aspx>)》

要是仅仅想浏览全部代码也可以直接到google code上去看，在下面的地址：

<http://code.google.com/p/jtianling/source/browse?repo=blog-sample-code>

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
