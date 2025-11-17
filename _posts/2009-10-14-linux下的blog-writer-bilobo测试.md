---
layout: post
title: Linux下的blog writer -- bilobo测试
categories:
- "未分类"
tags:
- bilobo
- Linux
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '6'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# bilbo 测试成功，Linux总算有办法可以发点东西了！！！

原来在Linux下是通过FireFox发的，但是CSDN对Firefox的支持有问题，在线编辑会丢失格式，更严重的是FireFox提交的文章只能用FireFox才能看到，害得当时我一批文章全部重新发表了一次，不知道现在好了没有，总之我是没有再敢用FireFox发表文章了。

最近总算在KDE下找到了blog writer了！

bilbo虽然不算太好用，分类取不会来，最近文章取不回来，不能设置文章发表的分类，还有如下代码不好贴的问题。。。。。。但是起码，当我想突然看到某个东西想转载的时候，不用再切换到Windows下了。

bilbo是KDE下的离线博客写作工具，主页是：http://bilbo.gnufolks.org/

ubuntu可以在这里下载：https://launchpad.net/~neversfelde/+archive/ppa/+packages

贴代码测试：

```c
#include <GL/glut.h>
#include <stdlib.h>

void display(void)
{
/* clear all pixels */
 glClear (GL_COLOR_BUFFER_BIT);
/* draw white polygon (rectangle) with corners at
 * (0.25, 0.25, 0.0) and (0.75, 0.75, 0.0) 
 */
 glColor3f (1.0, 1.0, 1.0);
 glBegin(GL_POLYGON);
 glVertex3f (0.25, 0.25, 0.0);
 glVertex3f (0.75, 0.25, 0.0);
 glVertex3f (0.75, 0.75, 0.0);
 glVertex3f (0.25, 0.75, 0.0);
 glEnd();
/* don't wait! 
 * start processing buffered OpenGL routines 
 */
 glFlush ();
}

void init (void) 
{
/* select clearing color */
 glClearColor (0.0, 0.0, 0.0, 0.0);
/* initialize viewing values */
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 glOrtho(0.0, 1.0, 0.0, 1.0, -1.0, 1.0);
}
```

测试结果：格式丢失，颜色丢失，使用bilobo的代码标记工程无效。

  

## 试着贴个图

## 

格式测试成功，大小正常，不会像Word2007一样乱掉。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_killbill-2.jpg)

测试结果：完全成功。