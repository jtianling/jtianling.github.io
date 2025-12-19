---
layout: post
title: SDL 简单入门学习
categories:
- "图形技术"
tags:
- SDL
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '25'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者为寻找跨平台图形库而尝试SDL，分享了创建窗口、加载BMP及PNG图片的代码，并称赞其API极其简单易用。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

## 概要

实际学习使用SDL创建窗口，并绘制图形。

## 前言

今天想要做一个简单的demo，因为一部分需要使用objective C，所以还需要跨平台，我才发现，我了解的东西还真没有一个适合做这样事情的，Cocos2D For IPhone仅仅能在IPhone下跑，HGE仅仅能在Windows下跑，Orx虽然能够跨平台，但是很显然，用于做简单的demo太麻烦了，因为我需要的仅仅是一个简单的DrawBmp函数而已，Orx那种一使用就使用一套的做法不太适合，还能想到的就是OpenGL了，但是用OpenGL做跨平台应用全靠自己那就挺麻烦了，还是找个框架吧。

其实我有3个选择，glut/free glut, SDL, GLFW。其中glut虽然在学习OpenGL的时候用过一些，但是因为该项目已经死了，我不想再为其投入更多的学习时间，了解到可以看懂其代码的水平（其实使用也很简单），已经够了。SDL是很多人推荐的选择，我以前找工作的时候，国内的一家公司竟然直接提到过，说明其在国内也算是有人用了。我在那以后也看过SDL的API，感觉还算简单，与HGE一样，图形显示上，都是用了类似DirectDraw的抽象。（应该也是最通吃的抽象方式了）我对GLFW的感兴趣是因为最近Orx的作者iarwain提到过,并且给予了很高的评价，他说对GLFW的轻量级印象非常深刻，在最新的Orx版本中，GLFW是Orx的默认插件，并且就iarwain的测试，比SDL快5%左右（虽然不算太多），最重要的是，GLFW的封装都很简单，以直接使用OpenGL为主，借这个契机，我也顺便复习一下OpenGL，最近老是用库，我都快忘了该怎么用了。

两相比较，我发现我不知道该用SDL还是GLFW，按我的习惯，两个一起用先，尝试一下再下结论。本文先看看SDL。

## 实际使用

其实我的需求很简单，创建窗口，在制定的地方绘图。简单的说也就是类似于CreateWindows和DrawBmp的两个函数而已。

SDL其实真的算挺出名的了，也有人提到过，即使不真的准备使用SDL，但是想想一个库，能够被移植到这么多平台，抽象封装的方式和源代码起码都值得研究研究。因为这个，我也稍微看一下，虽然真的不打算长期SDL。SDL的协议是LGPL的（也有商业协议），还算可以接受。

环境的搭建还算简单，Windows版本的SDL需要D3D SDK支持。

简单的参考了一下教程，显示BMP图片的过程还算简单：

```c
#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include "SDL.h"

int _tmain(int argc, _TCHAR* argv[])
{
    if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 )
    {
        printf("Unable to initialize SDL: %s\n", SDL_GetError());
        exit(1);
    }
    atexit(SDL_Quit);

    //Load image
    SDL_Surface* picture = SDL_LoadBMP("dragon.bmp");

    SDL_Surface *screen = SDL_SetVideoMode(640, 480, 16, SDL_DOUBLEBUF);
    if ( screen == NULL )
    {
        printf("Unable to set video mode: %s\n", SDL_GetError());
        exit(1);
    }

    //Apply image to screen
    SDL_BlitSurface(picture, NULL, screen, NULL);

    //Update Screen
    SDL_Flip(screen);

    //Pause
    SDL_Delay(2000);

    //Free the loaded image
    SDL_FreeSurface(picture);

    return 1;
}
```

这里，可以看到，SDL没有管理主循环，同时我没有使用自己的主循环，那得牵涉到SDL的事件系统，所以，这个演示里，用了SDL_Delay，才能看到图片的显示。这里的显示没有指定大小，没有指定alpha值，所以图片原大显示。SDL_BlitSurface函数的使用很像Windows API的对应函数。其他也没有什么好说的，看注释及函数名就知道在干什么了。

然后，通过下述方式来设置想要的透明色（在没有alpha通道的bmp中，也只能使用这样蹩脚的color key方式了）

```c
Uint32 colorKey = SDL_MapRGB(picture->format, 0xFF, 0xFF, 0xFF);
SDL_SetColorKey(picture, SDL_SRCCOLORKEY, colorKey);
```

其中0xFF,0xFF,0xFF分别是想要设定的颜色的R,G,B，这里都是0xFF,那就是白色了。

于是，原图：

![](http://docs.google.com/File?id=dhn3dw87_149cstb38g3_b)

在黑色背景下，周围的白色都透明了，显示出下列的效果：

![](http://docs.google.com/File?id=dhn3dw87_150fkthk5fq_b)

说实话，用SDL的API还算比较简单，使用的时候有点感觉时空穿越，有点回到当年学习使用Win32 API来做类似事情的时候。接口的概念都差不多，也许SDL的优势比起当年的Win32 API仅在于速度和跨平台了。

显示两个图只需要再blit一次即可：

```c
//Apply image to screen
SDL_BlitSurface(picture, NULL, screen, NULL);

SDL_Rect dest;
dest.x = picture->w;
dest.y = 0;

//Apply image to screen again and move it to right
SDL_BlitSurface(picture, NULL, screen, &dest);
```

然后，加入SDL对主循环的控制。

```c
// main loop
bool running = true;
while (running) {
    //Update Screen
    SDL_Flip(screen);

    // delay, 50 for simple
    SDL_Delay(50);

    //While there's an event to handle
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT) {
            running = false;
        }
    }
}
```

SDL_PollEvent用于轮询SDL的事件。

于是，现在SDL创建的窗口可以被拖动，也可以点击关闭了。

想说的是，SDL真的很简单，我看教程的时候基本上只需要看源代码即可，就能了解大部分的意思。

下面到关键的部分了，PNG的显示，我看到，虽然SDL本身仅仅支持BMP，但是已经有人做了一个名叫SDL_Image的库，可以支持其他格式。（考验一个开源库好不好，有没有良好的第3方支持是很重要的方面，SDL这方面明显很不错）于是，我们就不用直接使用libpng了，个人不是很喜欢libpng的接口。。。。。。

不知道是不是秉承了SDL简单的优良传统，SDL_Image的使用也非常简单，编译好后，将里面的动态库（因为需要支持PNG,所以有libpng和zlib的动态库）都拷贝到运行目录里面，然后包含"SDL_image.h"就可以了。从bmp到png的距离只有几行代码。。。。。从我发现SDL_Image到真的加载显示PNG图片，也就过了不到10分钟。。。。。

全部源代码：

```c
#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include "SDL.h"
#include "SDL_image.h"

int _tmain(int argc, _TCHAR* argv[])
{
    if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 )
    {
        printf("Unable to initialize SDL: %s\n", SDL_GetError());
        exit(1);
    }
    if (IMG_Init(IMG_INIT_PNG) == 0) {
        printf("Unable to initialize SDL_image");
        exit(1);
    }
    atexit(SDL_Quit);

    //Load image
    //SDL_Surface* picture = SDL_LoadBMP( "dragon.bmp" );
    SDL_Surface* picture = IMG_Load("dragon.png");

    SDL_Surface *screen = SDL_SetVideoMode(640, 480, 16, SDL_DOUBLEBUF);
    if ( screen == NULL )
    {
        printf("Unable to set video mode: %s\n", SDL_GetError());
        exit(1);
    }

    // because we use png with alpha now
    //Uint32 colorKey = SDL_MapRGB(picture->format, 0xFF, 0xFF, 0xFF);
    //SDL_SetColorKey(picture, SDL_SRCCOLORKEY, colorKey);

    //Apply image to screen
    SDL_BlitSurface(picture, NULL, screen, NULL);

    SDL_Rect dest;
    dest.x = picture->w;
    dest.y = 0;

    //Apply image to screen again and move it to right
    SDL_BlitSurface(picture, NULL, screen, &dest);

    // main loop
    bool running = true;
    while (running) {
        //Update Screen
        SDL_Flip(screen);

        // delay, 50 for simple
        SDL_Delay(50);

        //While there's an event to handle
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                running = false;
            }
        }
    }

    //Free the loaded image
    SDL_FreeSurface(picture);

    return 1;
}
```

仅仅只有几行修改，在代码中看的很清楚。

## 小结

简单，还是简单，这是我学习SDL的最大感受，API设计的简单，相关概念也简单，SDL无愧于Simple DirectMedia Layer中的Simple一次。要想真的从OpenGL学习起，然后调用libpng来加载PNG图像并显示，你得看到红宝书的第十几章，直到纹理贴图的学习后你才能做到，但是，在SDL中做这些事情实在是太简单了。即使与当年的Win32 API相比，也少了很多Windows特定的消息循环原理等东西的学习，创建窗口的API比较起来，就会感觉MS那一帮人都是废物，设计的窗口创建API，竟然需要用几十行的代码去创建一个窗口，还需要注册窗口类。。。。。。。。。。。事实上，只需要一行代码。。。。。。

一般来说，一个比较流行的开源库都是比较好的，因为好，才流行，因为流行而变的更好，其中，最最重要的关键在于，使用要简单，太复杂难用的库，无论设计的多么精巧，都很难吸引到使用者，也就难以进入这个良性的循环，不得不说，SDL在这方面，做的是非常好了。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
