---
layout: post
title: "简单图形编程的学习（1）---

本文使用Small Basic语言，作为图形编程入门的示例。文章重点讲解了如何在窗口中绘制和美化文字，包括设置颜色、字体和大小，并展示了制作动态文字效果的简单方法。

<!-- more -->

文字 (small basic实现)"
categories:
- "未分类"
tags:
- Small Basic
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**简单图形编程的学习（1）---文字 (small basic实现)**



# 一、全部简单图形编程的学习说在前面的话

此系列文章均假设读者已经具备一定的对应的程序编写知识，无论是最简单的small basic,还是因为常用而被人熟知的Windows GDI，或者是Linux下用的更多的Qt(一般我用PyQt),甚至是现在国内知道的人并不多的Android，我都不准备讲太多基础的语法，或者与平台相关的太多背景知识，这些靠读者先行学习，我仅仅准备在自己学习的过程中找点乐子：）看看我用一些简单的接口都能想出干什么事情，然后展示给大家看看，图形程序实在是最好展示的一类程序了，不像其他程序一样，哪怕我讲了一堆的boost，真正见识到boost强大的又有几个呢？-_-!要知道，今天起，所有程序都是窗口程序，不再是命令行!!!!人类用了多久才走到这一步我不知道。。。。我用了25年.......（从我出生算起）或者1年（从工作开始）

另外，想要看怎么编写窗口应用程序的就不要走错地方了，这里不是想怎么描述怎么使用一个又一个的控件，这里都是讲绘图的-_-!

# 二、谈谈Small Basic

由于今天是第一篇，所以谈谈Small Basic

本人所用small basic是最新的0.5（到2009-8-8今天为止），谈到small basic我又想多说几句，作为一个如此简单的语言，small basic的强大让人印象深刻，不仅仅体现在其对语法，图形接口的简化上，并且这也是唯一一个目前我推荐给女朋友而她能主动学习的一种语言（Python都太复杂）。。。。。。。。。呵呵，题外话了，个人感觉，不作为专业程序员，（即便是真的准备做专业程序员）以此入门，感受一下程序应该是什么样子，也是很好的事情，要知道，今天多少的大师级人物，其实当年还不是在APPLE或者PC上鼓捣着Basic啊，不要因为其名叫basic，（甚至是small basic）就鄙视它：）编程的思维都是一样的。最最不要认为的就是basic学了没有用，最近Google都推出了用于Android平台使用的basic语言，名为Simple：）Small Basic语言可以从我以前的文章《[初学编程该怎么学？——对初学者程序设计语言学习的思考（1）](<http://www.jtianling.com/archive/2009/07/19/4360719.aspx>)》《[初学编程该怎么学？——对初学者程序设计语言学习的思考(2)](<http://www.jtianling.com/archive/2009/07/19/4360720.aspx>)》中了解一下，MS的Introduce文档也真是初学者的福音。（因为习惯于专业术语，我实在没有办法将程序语言讲的如此通俗）。最后，我一直被MS一句简单描述Small Basic的语言所打动。。。"Microsoft Small Basic is a project that's aimed at bringing "fun" back to programming."相信当过一年程序员的兄弟姐妹们都会有和我同样的感动。。。。bringing "fun" back to programming，that's our aim.

另外，微软还未Small Basic提供了一种新的publish方式，虽然这样做就会导致所有的程序完全开源了（呵呵），那就是直接上传到MS的网站上，然后给你一个唯一的标识，任何人都可以再Small Basic的IDE中通过Import此code取出你的代码来看。[网页上](<http://smallbasic.com/program/>)也提供了查看方式，所以，以后复杂点的值得展示的Small Basic的代码，我都会pubish并提供code编号。那样，你就可以通过多种方式获取到我的代码。

# 三、进入今天的正题，首先是文字

文字好像都不像是图形编程中应该学习的东西，但是别忘了，文字可都是由象形文字发展过来的。。。中文至今还是象形文字呢，文字在远古的时代可本来就是图形啊，为啥学习图形编程的时候不要学习怎么显示文字啊？呵呵，前面的都是废话，其实你编点啥程序都会碰到需要在图形中显示文字的情况，所以我们先来看看文字的显示。另外，其实在显示文字的时候，假如需要对文字的显示进行设置，也能学到很多普通图形的设置方式，这点以后就能看到

# 四、Small Basic的文字显示

其实MS的《Introducing Small Basic》都没有描述到图形窗口下的文字显示的接口。。。。。我还是自己通过intellisense自己找到的。。。。有两个函数，DrawText和DrawBoundText呵呵，从简单的开始，一个最最简单的文字显示程序：

small basic graphic ex1:

```smallbasic
GraphicsWindow.Show()
GraphicsWindow.DrawText(0,0,"Hello World In Graphic Window")
GraphicsWindow.DrawBoundText(0, 100, 100, "Hello World In Graphic Window")
```

显示效果如插图1。

DrawBoundText的效果很有意思，多只指定了文字的宽度，并且为文字自动换行，换行的时候还按照单词分割，这在一般的程序中就是直接截断了。。。。（如Window自己普通的GDI），参数没有什么好说的，就是指定文字显示的左上角坐标和内容。

对于文字总还是要有点控制能力的，Small Basic也有。见下例：

small basic graphic ex2：(Code: [KXK447](<http://smallbasic.com/program/?KXK447>))

```smallbasic
GraphicsWindow.show()
GraphicsWindow.BackgroundColor = "midnight"
GraphicsWindow.DrawText(0,0,"Hello World In Graphic Window")
GraphicsWindow.BrushColor = "Red"
GraphicsWindow.DrawText(0,50,"Hello World In Graphic Window")
GraphicsWindow.FontSize = 30
GraphicsWindow.DrawText(0,100,"Hello World In Graphic Window")
GraphicsWindow.FontBold = 1
GraphicsWindow.DrawText(0,150,"Hello World In Graphic Window")
GraphicsWindow.FontItalic = 1
GraphicsWindow.DrawText(0,200,"Hello World In Graphic Window")
GraphicsWindow.FontName = "新宋体"
GraphicsWindow.DrawText(0,250,"Hello World In Graphic Window")
```

由于这些API都没有在文档中说明，我都是自己试出来的，这些大概就是我能找到的Small Basic中能改变文字显示的接口了。分别是几个FontX属性和Brush的颜色。显示效果如插图2.

最后，关于文字，来个复杂点的示例。。。呵呵，即便仅仅只有文字，也可以让程序比较炫。

small basic graphic ex3：(Code:[GDS718](<http://smallbasic.com/program/?GDS718>))

```smallbasic
GraphicsWindow.show()
GraphicsWindow.BackgroundColor = "midnight"
gw = GraphicsWindow.Width
gh = GraphicsWindow.Height
While ("True")
  Program.Delay(100)
  GraphicsWindow.BrushColor = GraphicsWindow.GetRandomColor()
  GraphicsWindow.FontSize = Math.GetRandomNumber(100)
  GraphicsWindow.FontBold = Math.GetRandomNumber(2) - 1
  GraphicsWindow.FontItalic = Math.GetRandomNumber(2) - 1
  GraphicsWindow.DrawText(Math.GetRandomNumber(gw),Math.GetRandomNumber(gh),"Hello World")
EndWHile
```

考虑到我们只能用文字接口，并且仅仅用了那么几行代码，效果已经比较炫了。见插图3.

插图1： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080809_1640_11.jpg)

插图2： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080809_1640_12.jpg)

插图3： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080809_1640_13.jpg)

