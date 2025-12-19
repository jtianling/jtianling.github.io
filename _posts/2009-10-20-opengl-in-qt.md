---
layout: post
title: OpenGL in Qt
categories:
- "图形技术"
tags:
- OpenGL
- Qt
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

本文介绍了在Qt框架下进行OpenGL开发的方法。通过QGLWidget类，可将标准OpenGL代码与Qt GUI结合，在三个核心函数中实现跨平台图形渲染。

<!-- more -->




Qt还是本人可移植GUI程序开发的首选，不过Qt开发普通的应用程序是行，但是据说效率太低，以至于像某些人说的那种刷新看得到一条条横线？这点我比较纳闷，就我使用的感觉，虽然Qt不以效率著称，但是事实上有足够的优化，最最典型的就是默认的图形双缓冲，按照Windows下的编程惯例是需要手动开启，并通过额外的接口调用才能使用的，这一点在以前简单图形编程学习时比较过Qt，Win32 GDI时感受特别深刻，在没有额外处理的时候，Win32动画程序那个闪阿，而Qt程序非常稳定。事实上，我想，Qt的其他问题比效率严重多了，比如个人感觉Qt程序在Windows下刷新的感知明显没有Windows原生程序快，这点倒是值得改进。

学习OpenGL很久了，也是时候在Qt的框架下感受一下OpenGL了，这也是学习OpenGL的好处，学习D3D的话就没有这么Happy了，事实上这也导致我老实东学西学-_-!真不知是好是坏。。。只是作为程序员的感觉，要是世界只剩下Windows，那么实在失去了太多的色彩。

以下的代码全部在Kubuntu9.04环境下运行，在Eclipse IDE \+ CDT 6.0 + gcc 4.3.3 + qt4Eclipse插件 下编译运行。

我现在是在用笔记本工作，并且笔记本没有支持3D加速的显卡。。。但是，还好，Linux可以使用[Mesa](<http://www.mesa3d.org/> "Mesa")，在显卡不支持的时候可以自动启用软件模拟，支持的时候自动启用硬件加速。

## Qt中的OpenGL框架

Qt可以说是对OpenGL有直接支持的，提供了QGLWidget类来绘制OpenGL，并且一如Qt既往的面向对象封装方式。下面是一个最简单的程序，一如《[Win32 OpenGL编程(3) 基本图元（点，直线，多边形）的绘制](<http://www.jtianling.com/archive/2009/10/13/4663465.aspx>)》中的Hello World例子。

#### OpenGL.h

```cpp
#ifndef OPENGL_H
#define OPENGL_H

#include   
#include   
#include "ui_opengl.h"

class OpenGL : public QGLWidget
{
    Q_OBJECT

public:
    OpenGL(QGLWidget *parent = 0);
    ~OpenGL();

    void initializeGL();
    void resizeGL(int width, int height);
    void paintGL();

private:
    void draw();

private:
    Ui::OpenGLClass ui;
};

#endif // OPENGL_H
```

#### OpenGL.cpp

```cpp
#include "opengl.h"

OpenGL::OpenGL(QGLWidget *parent)
    : QGLWidget(parent)
{
    ui.setupUi(this);
}

OpenGL::~OpenGL()
{

}

void OpenGL::initializeGL()
{

}

void OpenGL::resizeGL(int, int)
{

}

void OpenGL::paintGL()
{
    glClear(GL_COLOR_BUFFER_BIT);
    draw();
}

void OpenGL::draw()
{
    glColor3f (1.0, 1.0, 1.0);
    glBegin(GL_POLYGON);
    glVertex3f (-0.5, -0.5, 0.0);
    glVertex3f ( 0.5, -0.5, 0.0);
    glVertex3f ( 0.5,  0.5, 0.0);
    glVertex3f (-0.5,  0.5, 0.0);
    glEnd();
}
```

这样就完成了一个利用OpenGL绘制矩形的任务，paintGL中调用的完全是普通的OpenGL函数，一如我们学过的普通OpenGL函数，没有区别。其中最主要的代码就在OpenGL::paintGL()中，这一点需要额外注意，那就是此处与普通的Qt程序是不同的，普通的Qt程序将重绘的工作放在paintEvent中进行，但是，可以想像的是，其实paintGL不过是QGLWidget中paintEvent中调用的一个虚接口，Qt可以在外面做好足够的OpenGL准备工作。initializeGL，resizeGL，paintGL 3个额外的虚接口就构成了一个简单但是强大的OpenGL框架，一如GLUT抽象出的框架及我在Win32 OpenGL学习时建立的框架一样，知道这些以后，可以将OpenGL在Qt中的编程分成两个部分，一个部分就是由initializeGL，resizeGL，paintGL三个虚接口构成的OpenGL的领域，我们可以在其中进行我们习惯的OpenGL操作，而程序的输入等其他GUI相关的处理则还是交由Qt原来的框架去完成。

## OpenGL从Win32到Qt

为了说明Qt中对于OpenGL处理的抽象，我将原来在《[Win32 OpenGL编程(5) 顶点数组](<http://www.jtianling.com/archive/2009/10/17/4689516.aspx>)》一文中实现的一个较复杂的例子移植到Qt中。

其实基本上做做copy和paste的操作就OK了。

```cpp
void OpenGL::initializeGL()
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    // 启用顶点数组
    glEnableClientState(GL_VERTEX_ARRAY);

    // 颜色数组也需要启用
    glEnableClientState(GL_COLOR_ARRAY);

    // 默认就是此参数，可忽略，为了明确说明特意指定
    glShadeModel(GL_SHADE_MODEL);

    // 顶点数组数据
    static GLfloat fVertices[] = {    -0.5, -0.5,
                                      0.5, -0.5,
                                      0.5,  0.5,
                                     -0.5,  0.5,
                                      0.0,  0.0};    // 添加的原点

    // 颜色数组
    static GLfloat fColor[] = { 1.0, 0.0, 0.0,
                                0.0, 1.0, 0.0,
                                0.0, 0.0, 1.0,
                                0.0, 0.0, 0.0,
                                1.0, 1.0, 1.0};     // 原点颜色为白色

    // 指定顶点数组数据
    glVertexPointer(2, GL_FLOAT, 0, fVertices);

    // 制定颜色数组
    glColorPointer(3, GL_FLOAT, 0, fColor);

}
```

```cpp
void OpenGL::resizeGL(int, int)
{

}

void OpenGL::paintGL()
{
    draw();
}

void OpenGL::draw()
{
    glClear(GL_COLOR_BUFFER_BIT);    // 清空颜色缓冲区

    static GLubyte byTopIndices[] = { 2, 3, 4};
    static GLubyte byLeftIndices[] = { 3, 0, 4};
    static GLubyte byBottomIndices[] = { 0, 1, 4};
    static GLubyte byRightIndices[] = { 1, 2, 4};

    // 上述函数调用与下面的效果一样
    glPushMatrix();
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, byTopIndices);
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, byLeftIndices);
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, byBottomIndices);
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, byRightIndices);
    glPopMatrix();

}
```

效果如下图：

![](http://docs.google.com/File?id=dhn3dw87_3fp74xccq_b)

这也可以看做是抽象的强大之处，经过同样的抽象，OpenGL代码放在Qt中与放在Win32中，放在GLUT中其实都没有什么两样。但是，最重要的是，上面这段代码可以在Windows下面编译运行，而反过来却不行-_-!  
完整的源代码放在博客源代码的2009-10-20/OpenGL中，但是这个源代码可不是VS2008的了，是Eclipse的工程管理的，当然不用Eclipse直接使用makefile编译也行。全文用在Kubuntu中用Google Docs编辑发布，希望格式不会乱。

## 完整源代码获取说明

由于篇幅限制，本文一般仅贴出代码的主要关心的部分，代码带工程（或者makefile）完整版（如果有的话）都能用Mercurial在Google Code中下载。文章以博文发表的日期分目录存放，请直接使用Mercurial克隆下库：

<https://blog-sample-code.jtianling.googlecode.com/hg/>

Mercurial使用方法见《[分布式的，新一代版本控制系统Mercurial的介绍及简要入门](<http://www.jtianling.com/archive/2009/09/25/4593687.aspx>)》

要是仅仅想浏览全部代码也可以直接到google code上去看，在下面的地址：

<http://code.google.com/p/jtianling/source/browse?repo=blog-sample-code>


