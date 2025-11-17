---
layout: post
title: SDL与OpenGL配合使用时，OpenGL的纹理的UV坐标是上下颠倒的
categories:
- "图形技术"
tags:
- OpenGL
- SDL
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '29'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

同样的一段程序，在SDL with OpenGL时是颠倒的，而在GLFW和完全使用Windows API加OpenGL时又是正确的。  
如下：  
glBegin(GL_QUADS);  
glTexCoord2f(0.0 , 0.0 ); glVertex3f(-1.0 , -1.0 , 0.0 );  
glTexCoord2f(1.0 , 0.0 ); glVertex3f(1.0 , -1.0 , 0.0 );  
glTexCoord2f(1.0 , 1.0 ); glVertex3f(1.0 , 1.0 , 0.0 );  
glTexCoord2f(0.0 , 1.0 ); glVertex3f(-1.0 , 1.0 , 0.0 );  
glEnd();

在默认情况下， 纹理的UV坐标的原点是是左下角，在SDL中默认定在了左上角，所以需要将上面的纹理的坐标Y轴倒过来，这样显示就没有问题了。就像下面这样：  
glBegin(GL_QUADS);  
glTexCoord2f(0.0 , 1.0 ); glVertex3f(-1.0 , -1.0 , 0.0 );  
glTexCoord2f(1.0 , 1.0 ); glVertex3f(1.0 , -1.0 , 0.0 );  
glTexCoord2f(1.0 , 0.0 ); glVertex3f(1.0 , 1.0 , 0.0 );  
glTexCoord2f(0.0 , 0.0 ); glVertex3f(-1.0 , 1.0 , 0.0 );  
glEnd();

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
