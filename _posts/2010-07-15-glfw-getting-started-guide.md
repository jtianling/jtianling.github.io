---
layout: post
title: GLFW 简单入门学习
categories:
- "图形技术"
tags:
- GLFW
status: publish
type: post
published: true
meta:
  _oembed_6d3681304e52914c98fe7c3d3227cfd8: "{{unknown}}"
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '143'
  _oembed_92e86eabfd2bb73ed44a71745cc5e8ec: "{{unknown}}"
  _oembed_6863a381e468ed6b3f32dcb304cb221a: "{{unknown}}"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

文章分享了使用GLFW创建窗口、绘制图形的实践。GLFW是轻量级跨平台OpenGL框架，简化了环境搭建，适合3D开发，但文档和社区支持不如SDL。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**

[**讨论新闻组及文件**](http://groups.google.com/group/jiutianfile/)

## 概要

实际学习使用GLFW创建窗口，并绘制图形。作为比较，可以参考一篇关于[SDL的类似文章](http://www.jtianling.com/archive/2010/07/15/5735979.aspx "SDL的类似文章")。

## 前言

使用SDL时，对其使用的简单印象非常深刻，假如没有效率上的原因，（SDL据说效率也不差）我想，即使是做一般的游戏引擎都可以考虑用SDL来实现。现在尝试使用一下[GLFW](http://www.glfw.org/ "GLFW")，GLFW在国内并不是很出名，第一次听说也是从Orx的作者iarwain那里，SDL那篇文章已经说过了，因为SDL给我的感觉非常好，我很难想象GLFW会超过它，但是，平时想真的自己使用OpenGL的时候，有个框架可以使用也挺不错的，而且可以不使用glut，使得真的需要进一步做成产品时，不至于像使用glut那样受到限制。另外，GLFW使用的是zlib的协议，比SDL更加自由。

## 实际的使用

现在的最新版GLFW是2.6，我下载的是源码包，下载后，support目录有VS的工程，有两个projects，一个是编译成lib,（因为GLFW使用的是zlib协议，所以这也是允许的）一个是编译成dll。我为了减少编译和链接的时间，使用dll。编译成库以后，使用时，只用包含一个头文件即可，只需要一个头文件。。。。。  
其实，假如你原因，GLFW的文件并不是很多，全部包含进自己的工程也可以。（这也不违反协议）而且，我注意到support目录下有很多有意思的东西，包括通过lua,basic,汇编语言来使用GLFW和OpenGL的例子，也算是很有意思了。因为GLFW的接口比较少，所以，事实上，做一个语言的绑定工作的工作量不是太大，而且提供的都是C接口，这让语言的绑定更加简单，只要该语言支持C语言接口，而且有了OpenGL的绑定。虽然GLFW没有提供Python绑定，不过我感觉也不难做。呵呵，这些都是题外话了。  
编译后创建工程，这些都没有什么好说的了，不过第一次编译一个使用了glfwInit函数的小工程，竟然报链接错误，我很奇怪，网上查了后，发现需要自己定义一个GLFW_DLL的宏，这点倒是比较奇怪。见[此贴](http://www.gamedev.net/community/forums/topic.asp?topic_id=316102 "此贴")。心理有点不快，这点在官方的user guide中也没有提及。

## 创建窗口

一直记得在Windows下使用OpenGL有多么的麻烦，见《[Win32 OpenGL 编程（1）Win32下的OpenGL编程必须步骤](http://www.jtianling.com/archive/2009/09/28/4602961.aspx)》,那甚至值得用一篇论文来专门描述。使用GLFW呢？  
也还算简单，主要是调用glfwOpenWindow这个函数，参数比较多，但是还算容易理解。当我按照网上[少有的教程](http://gpwiki.org/index.php/GLFW:Tutorials:Basics "少有的教程")，（这点也体现了越流行的东西越好用的道理，SDL的教程太丰富了，其中很好的也很多，我很容易就上手了。GLFW就没有那么好了，我联想到自己用Orx的经历，更加发现如此。）开始尝试运行起一个程序时，我发现一个问题，我建立自己的主循环时，（GLFW也没有内部为你控制）尽管加入了对键盘的响应，但是还是没有用，窗口仍然死在那里。  
类似这样：
```cpp
//错误示范，切勿模仿
int
 _tmain(int
 argc, _TCHAR* argv[])
{
  if (!glfwInit()) {
    printf("GLFW init error.");
  }

  if (!glfwOpenWindow(800, 600, 6, 6, 6, 0, 32, 0, GLFW_WINDOW) ) {
    glfwTerminate();
    exit(1);
  }
  glfwSetWindowTitle("The GLFW Window");

  // this just loops as long as the program runs

  while (true) {
    if (glfwGetKey(GLFW_KEY_ESC) == GLFW_PRESS) {
      break;
    }

    glfwSleep(0.05);
  }

  glfwTerminate();

  return 0;
}
```

我不得其解，后来感觉主循环可能需要加入事件的轮询吧，而且还发现了GLFW中有类似的机制，pollevent的函数也在那里，但是这个教程为什么没有用却可以呢？后来在GLFW的文档中找到这么一句：

If it is not desirable that glfwPollEvents is called implicitly from glfwSwapBuffers, call glfwDisable  
with the argument GLFW_AUTO_POLL_EVENTS.

我就晕了，glfwSwapBuffers竟然隐含着调用了poolEvents。。....我无语。因为我暂时没有绘制图形，所以从网上的教程中去掉了此句，这正是问题所在，在glfwSleep(0.05);前添加glfwSwapBuffers后，问题解决。再次感叹，好的接口容易让人用对，坏的接口反之。。....不要去说是用某个东西前需要将文档全看了话，那是狡辩，好的语言，API设计，应该让人仅仅看了一部分，也能正常的工作和使用，即使是想当然的撞大运编程方式，也应该让人撞对才对，这才符合最小惊讶原则。。。。。。

用到这里，我得感叹一句，GLFW的user guide写的真的不咋地，和reference没有区别，狂列举API，却缺少实际的例子，这和reference有啥区别，user guide应该就是写来让人快速掌握的。

## OpenGL使用

有了上述的东西，基本上OpenGL的环境已经搭好了，可以尝试用OpenGL干点什么了。

这里将原来学OpenGL中的教程的例子《[Win32 OpenGL 编程（1）Win32下的OpenGL编程必须步骤](http://www.jtianling.com/archive/2009/09/28/4602961.aspx)》拉过来改改，先尝试一下。

```cpp
#include "stdafx.h"
#include "stdlib.h"
#include "gl/glfw.h"

#define WINDOW_WIDTH (800)
#define WINDOW_HEIGHT (600)

//OpenGL初始化开始
void SceneInit(int w,int h)
{
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);      // 黑色背景

  glColor3f(1.0f, 1.0f, 1.0f);

  glShadeModel(GL_FLAT);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(-50.0f, 50.0f, -50.0f, 50.0f, -1.0f, 1.0f);
}

//这里进行所有的绘图工作
void SceneShow(GLvoid) {
  // 旋转角度

  static float fSpin = 0.0f;

  fSpin += 2.0f;

  if (fSpin > 360.0f) {
    fSpin -= 360.0f;
  }

  glClear(GL_COLOR_BUFFER_BIT);
  glPushMatrix();

  // 旋转矩形的主要函数
  glRotatef(fSpin, 0.0f, 0.0f, 1.0f);
  glRectf(-25.0, -25.0, 25.0, 25.0);
  glPopMatrix();

  // 交换缓冲区
  glfwSwapBuffers();
}

int _tmain(int argc, _TCHAR* argv[])
{
  if (!glfwInit()) {
    printf("GLFW init error.");
  }

  if (!glfwOpenWindow(WINDOW_WIDTH, WINDOW_HEIGHT, 6, 6, 6, 0, 32, 0, GLFW_WINDOW) ) {
    glfwTerminate();
    exit(1);
  }
  glfwSetWindowTitle("The GLFW Window");

  SceneInit(WINDOW_WIDTH, WINDOW_HEIGHT);

  // this just loops as long as the program runs
  while (true) {
    if (glfwGetKey(GLFW_KEY_ESC) == GLFW_PRESS) {
      break;
    }

    SceneShow();
    glfwSleep(0.05);
  }

  glfwTerminate();

  return 0;
}
```

运行正常，总的来说在GLFW中搭建一个OpenGL的环境还是很简单的吧，起码比Windows下使用Win32 API来使用OpenGL要简单的多，并且，这还是跨平台的。（知道和很多人说跨平台就是废话）

![](http://docs.google.com/File?id=dhn3dw87_152c4d68gdx_b)

真的用GLFW使用过OpenGL后，发现其实还算是比较简单，我的那些话也有些苛责了。虽然我一向很喜欢真的了解底层，比如Win32 API,比如cocoa，但是，能够有个跨平台的库，为我将这些东西都管理起来，就算我要写什么，那也会简单很多。另外，虽然SDL也能做到这些，但是相对于GLFW对于OpenGL的直接支持，(SDL中其实也可以）我感觉用起来还是更加亲切一些。

## 图形的显示

这才是最终的目的。  
真正的位图的显示，在OpenGL中都不是那么容易的，需要掌握一堆的东西。见《[Win32 OpenGL编程(15) 位图显示](http://www.jtianling.com/archive/2009/12/29/5094735.aspx)》《[Win32 OpenGL编程(16) 纹理贴图](http://www.jtianling.com/archive/2010/03/27/5422477.aspx)》，那是因为OpenGL中实际完全对图形的显示没有直接的支持。听起来有些奇怪。。。实际的意思就是，OpenGL的API完全不理解位图，png图的含义。（虽然在上述15中提到一些bmp的操作接口，但是很遗憾的，实际的使用中都是使用纹理贴图，即16中提到的东西） 在GLFW中呢？我看到GLFW有对图形操作的接口。可是遗憾的是仅支持TGA，连BMP都不支持，不知道这种取舍是为啥，一般而言，我感觉，支持bmp的话，是最基础的。  
这里还是用《[SDL 简单入门学习](http://www.jtianling.com/archive/2010/07/15/5735979.aspx)》中的那个龙图。  
其中，图形文件操作的接口分两种，这里只看OpenGL常用的使用纹理贴图的方式。用到的API名字叫glfwLoadTexture2D。先显示个tga试一下。  
代码的主要部分还是OpenGL，所以可以参考《[Win32 OpenGL编程(16) 纹理贴图](http://www.jtianling.com/archive/2010/03/27/5422477.aspx)》中的代码，仅仅借用了glfw的glfwLoadTexture2D函数而已。主要代码如下：

```cpp
#include "stdafx.h"
#include "stdlib.h"
#include "gl/glfw.h"

#define WINDOW_WIDTH (800)
#define WINDOW_HEIGHT (600)

GLuint gTexName;
//OpenGL初始化开始
void SceneInit(int w,int h) {
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);      // 黑色背景

  glColor3f(1.0f, 1.0f, 1.0f);

  glShadeModel(GL_FLAT);

  glGenTextures(1, &gTexName);
  glBindTexture(GL_TEXTURE_2D, gTexName);

  if ( !glfwLoadTexture2D("dragon.tga", GLFW_BUILD_MIPMAPS_BIT) ) {
    printf("glfw load the file failed.");
  }

  // Use trilinear interpolation for minification
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
  // Use bilinear interpolation for magnification
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  // Enable texturing
  glEnable( GL_TEXTURE_2D );
}

//这里进行所有的绘图工作
void SceneShow(GLvoid) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glBindTexture(GL_TEXTURE_2D, gTexName);

  glBegin(GL_QUADS);
  glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 0.0); glVertex3f(1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 1.0); glVertex3f(1.0, 1.0, 0.0);
  glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, 1.0, 0.0);

  glEnd();

  // 交换缓冲区
  glfwSwapBuffers();
}

int _tmain(int argc, _TCHAR* argv[])
{
  if (!glfwInit()) {
    printf("GLFW init error.");
  }

  if (!glfwOpenWindow(WINDOW_WIDTH, WINDOW_HEIGHT, 6, 6, 6, 0, 32, 0, GLFW_WINDOW) ) {
    glfwTerminate();
    exit(1);
  }
  glfwSetWindowTitle("The GLFW Window");

  SceneInit(WINDOW_WIDTH, WINDOW_HEIGHT);

  // this just loops as long as the program runs
  while (true) {
    if (glfwGetKey(GLFW_KEY_ESC) == GLFW_PRESS) {
      break;
    }

    SceneShow();
    glfwSleep(0.05);
  }

  glfwTerminate();

  return 0;
}
```

感觉相对于图像显示来说，glfw并没有如SDL那般省事，因为毕竟还是全程使用OpenGL，对比原来OpenGL中显示位图的代码来说，仅仅是没有调用Windows API了而已，仅仅是多了跨平台的特性而已，并没有简化工作，而且，glfw同样的，也没有内置png图形的支持。虽然说tga在3D中用的非常多，主要是因为无损压缩，但是2D中，我还是喜欢使用png,因为小的多。当然，一旦使用png，无可避免的会需要使用libpng/zlib，所以GLFW为了保持自身的简单，没有做这样的工作吧，相对来说tga的解压就要简单太多了。  
另外，GLFW还有glfwReadImage函数可以将tga图直接读入内存，然后获取到图形的相关信息的办法（上面就没有办法获取到图形的宽高）。但是使用上都已经差不多了。

![](http://docs.google.com/File?id=dhn3dw87_153fk5758c6_b)

都到了这个地步了，不显示一下GLFW对OpenGL的强力支持，所以做3D比较方便都不像话了。这里套用原来的代码。见《[Win32 OpenGL编程(16) 纹理贴图](http://www.jtianling.com/archive/2010/03/27/5422477.aspx)》。  
  
```cpp
//OpenGL初始化开始
void SceneInit(int w,int h) {
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);      // 黑色背景

  glColor3f(1.0f, 1.0f, 1.0f);

  glViewport(0,0,WINDOW_WIDTH,WINDOW_HEIGHT);                      // Reset The Current Viewport

  glMatrixMode(GL_PROJECTION);                                    // Select The Projection Matrix
  glLoadIdentity();                                                // Reset The Projection Matrix

  // Calculate The Aspect Ratio Of The Window
  gluPerspective(45.0f,(GLfloat)WINDOW_WIDTH/(GLfloat)WINDOW_HEIGHT,0.1f,100.0f);

  glMatrixMode(GL_MODELVIEW);                                     // Select The Modelview Matrix
  glLoadIdentity();                                                // Reset The Modelview Matrix

  glGenTextures(1, &gTexName);
  glBindTexture(GL_TEXTURE_2D, gTexName);

  if ( !glfwLoadTexture2D("dragon.tga", GLFW_BUILD_MIPMAPS_BIT) ) {
    printf("glfw load the file failed.");
  }

  // Use trilinear interpolation for minification
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
  // Use bilinear interpolation for magnification
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  glEnable(GL_DEPTH_TEST);
  // Enable texturing
  glEnable( GL_TEXTURE_2D );
}

//这里进行所有的绘图工作
void SceneShow(GLvoid) {
  static float xrot = 0.0f, yrot = 0.0f, zrot = 0.0f;
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glLoadIdentity();                                           // Reset The View

  glTranslatef(0.0f,0.0f,-5.0f);

  glRotatef(xrot,1.0f,0.0f,0.0f);
  glRotatef(yrot,0.0f,1.0f,0.0f);
  glRotatef(zrot,0.0f,0.0f,1.0f);

  glBindTexture(GL_TEXTURE_2D, gTexName);

  glBegin(GL_QUADS);
  // Front Face
  glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);
  glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);
  glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f,  1.0f);
  glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f,  1.0f);
  // Back Face
  glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f, -1.0f);
  glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);
  glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);
  glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f, -1.0f);
  // Top Face
  glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);
  glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f,  1.0f,  1.0f);
  glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f,  1.0f,  1.0f);
  glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);
  // Bottom Face
  glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f, -1.0f, -1.0f);
  glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f, -1.0f, -1.0f);
  glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);
  glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);
  // Right face
  glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f, -1.0f, -1.0f);
  glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);
  glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f,  1.0f,  1.0f);
  glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);
  // Left Face
  glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f, -1.0f, -1.0f);
  glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);
  glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f,  1.0f,  1.0f);
  glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);
  glEnd();

  xrot+=0.3f;
  yrot+=0.2f;
  zrot+=0.4f;

  // 交换缓冲区
  glfwSwapBuffers();
}
```

效果：

![](http://docs.google.com/File?id=dhn3dw87_154gns98tfm_b)

其实最后一个例子已经与介绍GLFW没有关系了，新添加的部分纯粹属于OpenGL的内容，这里参看原来的文章，这里不多加解释了。仅仅用于演示，当使用了OpenGL后，3D图形的使用的方便。

## 小结

GLFW无愧于其号称的lightweight的OpenGL框架，的确是除了跨平台必要做的事情都没有做，所以一个头文件，很少量的API，就完成了任务。GLFW的开发目的是用于替代glut的，从代码和功能上来看，我想它已经完全的完成了任务，（虽然从历史原因上考虑还没有，毕竟红宝书都还是用glut。。。）并且glfw还在持续的开发当中，虽然作者总说他很忙。  
作为与SDL（参考[《SDL 简单入门学习》](http://www.jtianling.com/archive/2010/07/15/5735979.aspx)）比较而写的两篇文章。这里也做个小结。相对来说，SDL真的将API做的很简单，而且因为使用的人比较多，所以第3方扩展也做的很好，并且，碰到问题，你比较容易找到答案。假如是做2D应用，SDL真的已经非常不错了。GLFW作为一个跨平台的OpenGL框架，也出色的完成了任务，不过因为定位不同，封装较少，所以在做一些基本任务的时候，因为OpenGL本身的复杂性，会复杂一些。同时，资料也少的多，所以我写本文花费的时间比SDL那篇就要长了很多，说明学习周期也会长一些。。。。(但是个人感觉类似GLFW,SDL这样的库，学习周期基本为0。。。。比起编写图形或者游戏的其他方面来说可以忽略不计）但是，同时的，GLFW封装的少，也带来更大的灵活性，我们可以还是自由的用OpenGL完成工作，也可以完成自己的进一步封装，相当于GLFW将跨平台的一些脏活累活都干了，我们就剩最核心的渲染去自由发挥了。碰到一个任务，该怎么在两者之间选择呢？出于简单考虑，2D方面的东西用SDL做实在再合适和简单不过了，但是假如想要学习OpenGL或者是做3D应用，GLFW的确是不错的选择。绝对比在glut上的投入要值，当然，其实因为glut实在太过简单，其实出于教学/学习目的去看一下也实在没有什么投入，实际用OpenGL开发东西的时候，还是选择用GLFW做吧。  
也许，下一步，我可以看看怎么在SDL中使用OpenGL。在Windows下，SDL的默认渲染API使用的是D3D，不知道是否可以更改，并且完全使用OpenGL来工作呢？

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**
