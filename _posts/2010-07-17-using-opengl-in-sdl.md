---
layout: post
title: "在SDL中使用OpenGL"
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
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

以前使用过SDL和GLFW，发现SDL的API设计，第3方库，以及社区支持都好过GLFW，但是SDL是对显示做过封装的，所以使用2D是方便，但是GLFW没有对显示进行封装，完全使用OpenGL，所以使用OpenGL非常方便，这里，我不禁想到，要是SDL也能很好的使用OpenGL那么就完美了，在网上也的确查到了相关的资料。在试用以后发现比我想的还要简单，因为SDL在Windows中默认使用D3D渲染，我还以为会需要加宏重新编译SDL或者啥的，但是，一切比我想象的要简单，并且，找到的[教程](<http://gpwiki.org/index.php/SDL:Tutorials:Using_SDL_with_OpenGL> "教程")质量非常高，该讲的都讲了，该注意的都提到了，通俗易懂，明白无误，这是一个开源产品的最大优势，SDL就是这样一个产品！本来我以为需要大书特书的东西，在这样的教程下，显得非常多余。。。。呵呵，还是贴一些自己的代码吧。  
  
```cpp
#include   
#include   
#include   
#include "SDL.h"  
#include "SDL_opengl.h"

#define WINDOW_WIDTH 640  
#define WINDOW_HEIGHT 480  
//OpenGL初始化开始  
void SceneInit(int w,int h)  
{  
glClearColor(0.0f , 0.0f , 0.0f , 0.0f ); // 黑色背景  
glColor3f(1.0f , 1.0f , 1.0f );

glShadeModel(GL_FLAT);  
glMatrixMode(GL_PROJECTION);  
glLoadIdentity();  
glOrtho(-50.0f , 50.0f , -50.0f , 50.0f , -1.0f , 1.0f );  
}

//这里进行所有的绘图工作  
void SceneShow(GLvoid) {  
// 旋转角度

static float fSpin = 0.0f ;

fSpin += 2.0f ;

if (fSpin > 360.0f ) {  
fSpin -= 360.0f ;  
}

glClear(GL_COLOR_BUFFER_BIT);  
glPushMatrix();

// 旋转矩形的主要函数  
glRotatef(fSpin, 0.0f , 0.0f , 1.0f );  
glRectf(-25.0 , -25.0 , 25.0 , 25.0 );  
glPopMatrix();  
} 

int _tmain(int argc, _TCHAR* argv[])  
{  
if ( SDL_Init(SDL_INIT_VIDEO) < 0 )   
{  
printf("Unable to initialize SDL: %sn", SDL_GetError());

exit(1);  
}  
atexit(SDL_Quit);

// use these two lines instead of the commented one  
SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 ); // *new*  
SDL_Surface* screen = SDL_SetVideoMode( WINDOW_WIDTH, WINDOW_HEIGHT, 16, SDL_OPENGL); // *changed*   
//SDL_Surface *screen = SDL_SetVideoMode(WINDOW_WIDTH, WINDOW_HEIGHT, 16, SDL_DOUBLEBUF);

SceneInit(WINDOW_WIDTH, WINDOW_HEIGHT);

// main loop  
bool running = true;  
while (running) {  
//While there's an event to handle   
SDL_Event event;   
while( SDL_PollEvent( &event; ) ) {   
if (event.type == SDL_QUIT) {  
running = false;  
}  
}

SceneShow();  
//Update Screen   
// use this line instead of the commented one  
SDL_GL_SwapBuffers();  
//SDL_Flip( screen ); 

// delay, 50 for simple  
SDL_Delay( 50 ); 

}

return 1;  
}
```

与[以前写的](<http://www.jtianling.com/archive/2010/07/15/5735979.aspx> "以前写的")使用SDL本身封装的渲染方式使用的方法比较一下，发现仅仅改变了几行代码，注释中都有说明。  
一是创建窗口和使用双缓冲的代码：  
```cpp
// use these two lines instead of the commented one  
SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 ); // *new*  
SDL_Surface* screen = SDL_SetVideoMode( WINDOW_WIDTH, WINDOW_HEIGHT, 16, SDL_OPENGL); // *changed*   
//SDL_Surface *screen = SDL_SetVideoMode(WINDOW_WIDTH, WINDOW_HEIGHT, 16, SDL_DOUBLEBUF);
```
  
一是flip缓冲的代码：  
```cpp
SDL_GL_SwapBuffers();  
//SDL_Flip( screen ); 
```

仅此两处而已，其他地方，就可以完全使用openGL了，如上面代码所示，与[GLFW的文章](<http://www.jtianling.com/archive/2010/07/15/5738421.aspx> "GLFW的文章")比较一下，发现SDL假如能够如此容易的支持OpenGL的话，即使是3D的东西，用SDL来管理一些跨平台的东西，然后使用OpenGL来渲染，其实也是非常不错的选择。  
效果：

![](http://docs.google.com/File?id=dhn3dw87_156g27946cz_b)

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**