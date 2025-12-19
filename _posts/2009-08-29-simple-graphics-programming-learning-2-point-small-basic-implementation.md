---
layout: post
title: "简单图形编程的学习（2）---

本文用Small Basic的SetPixel函数，展示了如何用简单的点创造出星空、雪花等惊艳的视觉效果。

<!-- more -->

点 (small basic实现)"
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

**简单图形编程的学习（ 2）---点 (small basic实现)**



# 一、 又一顿牢骚

虽然知道不应该老是说些与技术无关的话。。。。但是有的时候又总是想说。。。。难怪有同事说我最近已经有点像唐僧了-_-!总而言之，因为相对来说书看的太快，（现在租的房子离公司太远，老是坐地铁，导致有了非常固定的看书时间），而因为工作一直太忙，一直加班回家太晚的原因，所以实际的实践太慢（基本上现在就是以写博客的形式），所以Qt与Android的部分要是同步跟上我DirectX的书都要看好几本了，这样的方式好像不太好，所以目前暂时还是以Windows的为主了。。。。这也体现了一点理想与现实的差距-_-!虽然初期项目目标过大，项目中即时调整起码还能保证项目完成吧。。。。。（扯的远了）。

# 二、 画点

画点，在Small Basic中属于太基础的东西，当然，其实在Small Basic中什么都基础。。。呵呵

GraphicsWindow.SetPixel

函数用于画点，这里的点仅仅只有一个像素，所以叫SetPixel（设置像素），和Windows GDI的命名一致（其实Small Basic中的画图函数很多都与Windows GDI一致），参数的解释如下:

SetPixel
Draws the pixel specified by the x and y co-ordinates using the specified color.

GraphicsWindow.SetPixel(x, y, color)

x
The x co-ordinate of the pixel.
y
The y co-ordinate of the pixel.
color
The color of the pixel to set.
Returns
Nothing

## 1. 随机在屏幕上画随机颜色点（HHT897）

```smallbasic
GraphicsWindow.BackgroundColor = "White"

GraphicsWindow.PenColor = "LightBlue"

gw = GraphicsWindow.Width

gh = GraphicsWindow.Height


While ("True")

  GraphicsWindow.SetPixel(Math.GetRandomNumber(gw), Math.GetRandomNumber(gh), GraphicsWindow.GetRandomColor())

EndWhile
```

So简单。。。不是吗？效果如插图1

但是，不要小看点的作用，点可以用于模拟星空。。。。。。。。。这里展示几个效果，真的觉得small basic用于演示什么叫简单的技术惊艳的效果非常合适。。。。。。在图形领域，感觉技术固然重要，但是思维强大也能利用简单的技术实现惊艳的效果。

## 2. 老电视机雪花点的效果：(PXB396)

```smallbasic
GraphicsWindow.BackgroundColor = "DarkNight"

GraphicsWindow.PenColor = "LightBlue"

gw = GraphicsWindow.Width

gh = GraphicsWindow.Height


While ("True")
  For i = 1 To 1000
    GraphicsWindow.SetPixel(Math.GetRandomNumber(gw), Math.GetRandomNumber(gh), "White")
  EndFor

  Program.Delay(10)

  GraphicsWindow.Clear()

EndWhile
```

## 3. 闪烁的星空：(TPK996)

```smallbasic
GraphicsWindow.BackgroundColor = "DarkNight"

GraphicsWindow.PenColor = "LightBlue"

gw = GraphicsWindow.Width

gh = GraphicsWindow.Height

' 以数组记录下随机出来的点，这样才能保证星空是在闪烁而不是移动
For i = 1 To 500
  width[i] = Math.GetRandomNumber(gw)
  height[i] = Math.GetRandomNumber(gh)
EndFor

While ("True")
  For i = 1 To 500
    GraphicsWindow.SetPixel(width[i], height[i], "White")
  EndFor
  Program.Delay(1000)
  GraphicsWindow.Clear()
EndWhile
```

## 4. 屏幕刮花效果（RMP025）

```smallbasic
GraphicsWindow.BackgroundColor = "DarkNight"

GraphicsWindow.PenColor = "LightBlue"

gw = GraphicsWindow.Width

gh = GraphicsWindow.Height


For i = 1 To 500
  width[i] = Math.GetRandomNumber(gw)
  height[i] = Math.GetRandomNumber(gh)
EndFor

While ("True")
  For i = 1 To 500
    GraphicsWindow.SetPixel(width[i], height[i], "White")
    width[i] = width[i] + 1
  EndFor

  Program.Delay(10)
EndWhile
```

## 5. 移动的星空：（ZGB224）

```smallbasic
GraphicsWindow.BackgroundColor = "DarkNight"

GraphicsWindow.PenColor = "LightBlue"

gw = GraphicsWindow.Width

gh = GraphicsWindow.Height


For i = 1 To 50
  width[i] = Math.GetRandomNumber(gw)
  height[i] = Math.GetRandomNumber(gh)
EndFor

While ("True")
  Program.Delay(1)
  For i = 1 To 50
    GraphicsWindow.SetPixel(width[i], height[i], "White")
    width[i] = width[i] + 1
    
    ' 保证星空不是直接消失了-_-!
    If(width[i] > gw) Then
      width[i] = 0
    EndIf
  EndFor

  GraphicsWindow.Clear()
EndWhile
```

Have Fun，aha?呵呵，的确是，很久没有这样爽的写程序了，有了思维，很简单的就能体现在Small Basic上，让人愉快。后面的字母都是可以直接在Small Basic中import的，现在Small Basic 0.6出来了，我用的都是Small Basic 0.6。另外，发现没有，不像在讲其他语言/程序的时候一样，对各个参数一通饱讲，10分钟还没有看到一个函数的参数，对于Small Basic的程序我感觉仅仅需要展示效果和源代码就好了，展示的直接就是编程的思想，而不是语言，因为语言本身如此的简单。完成上面所有的示例都没有花掉我一个小时。。。。。很难想象用GDI或者DX我要用多久。。。。。。。呵呵，虽然我用C/C++出身的（现在也靠这个吃饭），也稍微学习过一下汇编，但是我怎么感觉我对越简单的语言越有好感啊？LUA, Python, Bash ,JAVA都稍微学过一点，但是实在是没有如Small Basic这样让人愉快的语言了^^，也许最最重要的一点在于，现有的大部分语言（上面提及的都是），逻辑表达能力虽然很强，库很丰富，但是为了适应足够广阔的领域并达到工业强度，GUI编程方面都是复杂的让人吐血，MFC就不说了，TK号称简单，其实我感觉也好不到哪去，我没有尝试过用Bash没写GUI，Qt已经算是非常好的GUI库了，但是上百个类足够让你头晕目眩。Small Basic这样的语言虽然是玩具，也就因为其是玩具才敢这么简单。。。。。。。。。呵呵，欣赏它，起码作为一种简单的演示也不错。

上面的例子都是自己随便想的，下面看一个偷师来的例子，以前在讲small Basic的时候其实已经展示过了，但是因为这个例子给了我太多惊喜，我决定反复提起，告诉你们什么叫编程思维利用简单的技术，你别说看了没有感觉惊艳，要知道其实仅仅是利用了画点和文字输出两个如此平常而简单的特性。

## 6. 星空中的文字（HQG707）

```smallbasic
GraphicsWindow.BackgroundColor = "midnight"
gw = GraphicsWindow.Width
gh = GraphicsWindow.Height
GraphicsWindow.FontSize = 100
Turtle.Move (100)
Turtle.Turn (1*1)
While ("True")

  For i = 1 To 50
   GraphicsWindow.SetPixel(Math.GetRandomNumber(gw),Math.GetRandomNumber(gh),GraphicsWindow.GetRandomColor())
  EndFor

  Turtle.Move(1)
  GraphicsWindow.BrushColor = "Black"
  GraphicsWindow.DrawBoundText(30,110,gw-20,"Small Basic")

EndWhile
```

第一次看到这个例子的时候我真的感叹作者是个天才-_-!也许是自己太笨了所以想不到用这样的方式去显示文字吧。这次来个系列效果，如星空中的文字-插图1-4。怎么样？效果惊艳吧？呵呵，直接运行一下程序吧，将文字改成你想要的，你会有更好的感觉。

# 三、 小结

一个个简单的点就能够构成如此繁多的效果，简直有点不可思议，但是其实，能够绘制一个点，就能够绘制整个世界，要知道，整个屏幕不过也就是一个一个像素构成的，呵呵。其实，从另外的角度来说，一连串连续的点就能构成一条直线，一排排直线就能构成一个面，有了点，线，面，还有什么不够构成的？你可以表达整个世界。

插图1：
![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082809_1607_21.png)

插图2：
![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082809_1607_22.png)

星空中的文字-插图1：
![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082809_1607_23.png)

星空中的文字-插图2：
![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082809_1607_24.png)

星空中的文字-插图3：
![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082809_1607_25.png)

星空中的文字-插图4：
![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082809_1607_26.png)

