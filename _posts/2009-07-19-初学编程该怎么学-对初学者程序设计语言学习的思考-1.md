---
layout: post
title: "初学编程该怎么学？——对初学者程序设计语言学习的思考（1）"
categories:
- "随笔"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '21'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# 

# 初学编程该怎么学？——对初学者程序设计语言学习的思考

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)

[讨论新闻组及文件](<http://groups.google.com/group/jiutianfile/>)

作为一个靠C++吃饭的服务器端程序员，同时也可以算是个计算机程序语言的爱好者，与干一行厌一行的人不同，我是先因为自己喜欢编程，然后才放弃自己的专业通过自学走上了靠编程吃饭的道路，并且虽然现实和理想有点偏差-_-!（估计大家都知道我说的是啥）但是，无论工作多么忙，加班多么晚，我没有放弃自己的爱好，还是愉快的学习着。同时，也尝试着传播自己的想法。

对于普通人，逻辑方面不是非常强的普通人，对于Python这个号称接近自然语言，号称是可以执行的伪码的语言，一般也不会感觉到多么有趣，总是觉得一堆字符太过枯燥。的确是，一般而言，图形的编程即使在Python中也是比较复杂的（更不用说C++,JAVA了），没有语言的教学一开始就教图形编程的，（拖拖控件的那种我认为不算语言的教学，最多算工具的教学）这也是程序语言教程枯燥的地方。

即便很多人说过Python适合作为程序语言学习的第一种语言，但是Python语言本身对于初学者来说并没有多大实际的趣味性，虽然很多高人号称交互式的命令行方式很适于学习，但是对于真正的初学者还是一样的枯燥。而更多更加高等级抽象的内容，比如列表，元组，字典，字符串的格式化等概念对于初学者来说就不是太好理解，更不用说列表解析语法，对象，异常等东西了，甚至，函数的概念，对于有些人来说都不好理解。那么，既然，Python这样号称非常简单的语言对于初学者来说都不是那么好理解并且枯燥的，那么，还有更简单的语言吗？

以前我一直以为很难找到了。后来偶然看到了MS的SB语言，名字很奇怪吧。。。[Small Basic](<http://msdn.microsoft.com/en-us/devlabs/cc950524.aspx>)语言，设计给小孩子学习的语言，因为设计给小孩子用，所以足够的简单，并且，MS的一贯作风，设计的足够花哨，足够好看，足够有意思。其中的turtle，即便是我初次使用都感觉很有意思，看到一个乌龟走来走去，有意思。。。。的确，假如仅仅是学习程序的逻辑和语法的话，一个乌龟就够了。。。。这是我当时的想法。。。当然，这仅仅是针对于不是准备将程序设计作为职业的人来说（其实即便你想以程序设计为职业也不是不可以从一个有趣的地方开始）。

    通过简单的程序语法，就可以实现画出较为复杂的图形，这在普通的Python中要实现，好歹也得学会TK，WxPython,PyGTK,PyQt等东西中其中的一种吧，这些可没有那么简单。图形对于初学者来说和字符就是完全两种感受，他们不会感觉到对于数字的计算，字符串的拼接是在编程，但是对于实际能看到的一个乌龟的一段爬行，那就是编程了。

    看看turtle的例子。（初级的例子Introducing Small Basic中有介绍，此文是安装Small Basic后附带的文档）。

以

Turtle.Show()

表示显示，

Turtle.Move(100)

表示移动，

Turn，TurnLeft,TurnRight

表示转向

如此简单，但是却可以完成一些较为复杂的东西。

文中典型的例子是画一个矩形：

```basic
Turtle.Move(100)
Turtle.TurnRight()
Turtle.Move(100)
Turtle.TurnRight()
Turtle.Move(100)
Turtle.TurnRight()
Turtle.Move(100)
Turtle.TurnRight()
```

画出的效果如图：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_1.jpg)

  

例一：

首先我提出的是画一个三角形，呵呵，有点意思。

```basic
Turtle.TurnLeft()
Turtle.Move(100)
Turtle.Turn(120)
Turtle.Move(100)
Turtle.Turn(120)
Turtle.Move(100)
```

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_2.png)

 

第二例，接着我希望有个圆形，这个题目一下子复杂到能难住很多人了。对于从《怎么解题》中获得的教益，我可以提出几个更容易解决的问题，等边3角形，正方形我们已经会了，等边6边形呢？等边12边形呢？当边越来越多，会发现越来越接近圆。。。

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_3.png)

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_4.png)

  

当我画出一个50边形的时候。。。你还能认出来吗？

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_5.png)

  

你看着就像是一个圆了。。。。。思路似乎来自于原来学校中讲圆时数学老师讲的圆某个公式的推导。本来画一个圆的常规想法应该是，以一点与圆心保持一个半径的距离，并且环绕一周。。。。

当画的边越来越多，自然会发现，原来一步一步的代码输入方式不行了，会很强烈的感觉到“循环”引入的需要，于是，循环的语法出来了。上述作图的源码如下：

```basic
TIMES = 50
For j = 1 To TIMES
  Turtle.Turn(360/TIMES)
  Turtle.Move(600/TIMES)
EndFor
```

（写此文时才发现Introducing Small Basic中已经有类似的例子了,并且源代码如下：）

```basic
sides = 12
length = 400 / sides
angle = 360 / sides
For i = 1 To sides
  Turtle.Move(length)
  Turtle.Turn(angle)
EndFor
```

我接着看到了Introducing Small Basic中一个很漂亮的图形，

于是提出解决此问题，竟然很容易从图形中看出思路，无非就是乌龟在原地没转一个方向就画一个圆嘛。

```basic
OUT_TIMES = 20
TIMES = 50
Turtle.Speed = 10
For i = 1 To OUT_TIMES
  For j = 1 To TIMES
    Turtle.Turn(360/TIMES)
    Turtle.Move(600/TIMES)
  EndFor
  Turtle.Turn(360/OUT_TIMES)
EndFor
```

 

（文中也有类似实现）

 

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_6.png)

 

接着文中用直接画椭圆的方式画出了如下图形：

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_7.png)

  

我决定用乌龟走出来，思路也来的很简单，首先乌龟在中间那个圆上走，然后每走一步，就向外再走一个圆，就成了这样的管道形状了。。。。。。。效果如下：

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_071809_2022_8.png)

 

源代码：

```basic
IN_TIMES = 40
TIMES = 20
Turtle.Speed = 10
For i = 1 To TIMES
  Turtle.Turn(360/TIMES)
  Turtle.Move(200/TIMES)
  For j = 1 To IN_TIMES
    Turtle.Turn(360/IN_TIMES)
    Turtle.Move(400/IN_TIMES)
  EndFor
EndFor
```

作为学习编程几年的并且现在还靠着号称世界上特别复杂的一种语言C++活着的人来说，我也能在这些简单的图形中绘制中找到编程的乐趣，这就是turtle的乐趣了，我想初学者能找到的乐趣会比我更加多吧。

 

 

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)