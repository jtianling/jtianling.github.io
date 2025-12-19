---
layout: post
title: "游戏中的动画简介"
categories:
- "游戏开发"
tags:
- "动画"
- "游戏开发"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

讲解计算机动画基本原理：通过循环连续绘制帧产生运动。文章以C++和Java Applet为例，展示了构建动画循环和控制帧率的核心方法。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

## **前言**

本文仅仅介绍简单的动画技术而已，主要还是为以后发布关于更丰富的动画表现做基础，所以不要对本文期待太高。全文的技术含量也就比hello world高那么一点点。在简单的介绍了一些动画的概念之后，然后用C++，java applet分别实现了一个简单的动画。至于怎么在网页中运行java applet的问题，可以参考以前的文章《[在CSDN博客中部署及运行JAVA Applet](<http://www.jtianling.com/archive/2009/11/12/4799441.aspx> "在CSDN博客中部署及运行JAVA Applet")》。需要注意的是，要看到java applet自然需要先安装过java，还需要在浏览器中允许才行。

## 什么是动画

事实上，最简单的解释就是运动的图画-_-!我们研究的是计算机中的动画。

“**计算机动画** ：动画与运动是分不开的，可以说运动是动画 的本质，动画是运动的艺术。从传统意义上说，动画是一门通过在连续多格的胶片上拍摄一系列单个画面，从而产生动态视觉的技术和艺术，这种视觉是通过将胶片 以一定的速率放映的形式体现出来的。一般说来，动画是一种动态生成一系列相关画面的处理方法，其中的每一幅与前一幅略有不同。   
计算机动画是采用连续播放静止图像的方法产生景物运动的效果，也即使用计算机产生图形、图像运动的技术。计算机动画的原理与传统动画基本相同，只是在传统动画的基础上把计算机技术用于动画的处理和应用，并可以达到传统动画所达不到的效果。由于采用数字处理方式，动画的运动效果、画面色调、纹理、光影效果等 可以不断改变，输出方式也多种多样。” -- 来自参考一

“**计算机动画的基本原理**

根据运动的控制方式可将计算机动画分为实时（real-time）动画和逐帧动画（frame-by-frame）两种。实时动画是用算法来实现物体的运动。逐帧动画也称为帧动画或关键帧动画，也即通过一帧一帧显示动画的图像序列而实现运动的效果。根据视觉空间的不同，计算机动画又有二维动画与三维动画之分。”-- 还是来自参考一

我们研究的主要是实时动画，其实说简单点就是实时计算出来的动画，而不是原来做好的，现在拿来放，但是，效果上，我们还是一帧一帧的播放，只不过每一帧都是实时计算出来的。每一秒播放的帧数就是常提起的FPS（Frames Per Second），一般对于电脑游戏来说，每秒30帧是底线，60帧是最理想的境界，手机游戏的话20帧也有。要是FPS太低，容易产生跳跃停顿现象，即我常说的“像放幻灯片”（不知道别人常说不）。事实上，在硬件条件的限制内尽可能实现更好的游戏画面，并且保持较高的FPS，这是游戏程序员奋斗不息的永恒主题。

## 动画在程序中的表现（首先以C++为例）

事实上，因为动画的原理，用于描绘动画的程序（游戏也算，以下略）与普通程序非常不一样，普通程序往往等待用户输入后才有反应，平时可以空闲，但是动画不行，每一帧都得实实在在的计算，绘制。

所以，程序的结构也就与普通的程序不太一样，首先用从《Windows游戏编程大师技巧》中的游戏框架中抽出的伪码看看一个动画程序大概要的东西。

```cpp
// initialize game here   
Game_Init(); 

// enter main event loop   
**while**(TRUE)   
{   
    // test if there is a message in queue, if so get it   
    **if** (PeekMessage(&msg;,NULL,0,0,PM_REMOVE))   
    {   
        // test if this is a quit   
        **if** (msg.message == WM_QUIT)   
            **break** ; 

        // translate any accelerator keys   
        TranslateMessage(&msg;); 

        // send the message to the window proc   
        DispatchMessage(&msg;);   
    } // end if

    // main game processing goes here   
    Game_Main(); 

} // end while

// closedown game here   
Game_Shutdown(); 

// return to Windows like this   
**return**(msg.wParam); 

**int** Game_Main(**void** *parms = NULL, **int** num_parms = 0)   
{   
    DWORD dwStartTime; 

    dwStartTime = GetTickCount();   
    // this is the main loop of the game, do all processing here

    // for now test if user is hitting ESC and send WM_CLOSE   
    **if** (KEYDOWN(VK_ESCAPE))   
        SendMessage(ghWnd,WM_CLOSE,0,0); 

    // another key down is test here

    SceneShow(); 

    // control the frame rate   
    **while**(GetTickCount() - dwStartTime < TIME_IN_FRAME)   
    {   
        Sleep(1);   
    } 

    // return success or failure or your own return code here   
    **return**(1); 

} // end Game_Main
```

以上就是一个动画程序(其实是个游戏程序）需要的核心要素，主要部分就是运算，显示的循环，并且，需要控制住循环的频率（实际也就控制了显示的FPS），在游戏程序中还需要接受用户的输入。最最主要的是，即使没有任何输入，程序还是在不停的循环，这点与Windows程序的消息驱动有很大的区别，一般来说，将动画的播放与帧相关，也就是绘制时以帧为单位来决定如何绘制，被称为基于帧，同样的还有基于时间的动画，这点用在游戏中也是一样的，其实说起来，游戏本质上就是接受玩家输入的可交互式动画。两种方式在FPS稳定时效果一致，在FPS不稳定时有差别，一般来说，基于帧的更加容易实现，基于时间的游戏可以针对不同的平台使用不同的帧率。

上述框架广泛的被我博客中学习OpenGL部分的代码使用，要看到实际的例子随便下点源代码都可以看到。很多OpenGL的例子都是用了上述框架，并且绘制了动画。这里就不再多举例子了。《 [Win32 OpenGL系列专题](<http://www.jtianling.com/archive/2009/11/06/4776410.aspx>)》中很多例子都是。

## java applet动画

```java
import java.applet.Applet;   
import java.awt.Color;   
import java.awt.Dimension;   
import java.awt.Graphics;   
import java.awt.Image;   
import java.util.Date; 

import javax.xml.crypto.Data; 

public   
class appletAnimation extends java.applet.Applet implements Runnable {   
    int frame;   
    int delay;   
    Thread animator; 

    /**   
    * Initialize the applet and compute the delay between frames.   
    */   
    public void init() {   
        int fps = 30;   
        delay = (fps > 0) ? (1000 / fps) : 100;   
    } 

    /**   
    * This method is called when the applet becomes visible on   
    * the screen. Create a thread and start it.   
    */   
    public void start() {   
        animator = **new** Thread(this);   
        animator.start();   
    } 

    /**   
    * This method is called by the thread that was created in   
    * the start method. It does the main animation.   
    */   
    public void run() {   
        // Remember the starting time   
        long tm = System.currentTimeMillis();   
        **while** (Thread.currentThread() == animator) {   
            // Display the next frame of animation.   
            repaint(); 

            // Delay depending on how far we are behind.   
            **try** {   
                tm += delay;   
                Thread.sleep(Math.max(0, tm - System.currentTimeMillis()));   
            } **catch** (InterruptedException e) {   
                **break** ;   
            } 

            // Advance the frame   
            frame++;   
        }   
    }   
      
    public void paint(Graphics g) {   
        g.setColor(Color.black);   
        g.drawString("Frame " \+ frame, 0, 30);   
    } 

    /**   
    * This method is called when the applet is no longer   
    * visible. Set the animator variable to null so that the   
    * thread will exit before displaying the next frame.   
    */   
    public void stop() {   
        animator = null;   
    }   
} 
```

遵照上面的思路，为java applet程序建立循环，FPS控制，显示的更新，OK，也就完成了动画的显示了。唯一与C++中不同的是，驱动的不再是一个死循环，而是一个新的线程，其他的元素完全没有改变。参考二《[Animation in Java Applets](<http://www.javaworld.com/javaworld/jw-03-1996/jw-03-animation.html?page=1> "Animation in Java Applets")》是很完整的动画的例子。

其他语言的例子:事实上,在我的博客中还有关于OpenGL, Qt, Windows GDI, Small Basic动画的例子,这里我就不列出来了,自己去搜索一下吧,其实理解了动画形成的思想,大同小异.

最后:其实本文本来想讲的更多的,最后拖得太久,所以草草结束了,远没有完成原本想要完成的内容. 并且此时Google Document无法发布，还是转到WLW中发布的，为啥WLW可用，Google Doc突然不可用了？自从CSDN在春节后开放Meta API就是如此，无奈。

参考：

一、《计算机动画基础》http://www.telecarto.com/content/maincontent/multimediadesign/Animation/cha_713.htm -- 关于动画概念讲的很多

二、《[Animation in Java Applets](<http://www.javaworld.com/javaworld/jw-03-1996/jw-03-animation.html?page=1> "Animation in Java Applets")》，很详细的java applet教程，从简单的文字动画到稍微复杂点的动画，由浅入深，通俗易懂，例子丰富。

## 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
