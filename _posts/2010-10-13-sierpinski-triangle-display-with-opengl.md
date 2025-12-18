---
layout: post
title: "谢尔宾斯基三角(Sierpinski triangle)的显示 (with OpenGL)"
categories:
- "图形技术"
tags:
- OpenGL
- Sierpinski triangle
- "谢尔宾斯基三角"
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

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)

    [Sierpinski triangle](<http://en.wikipedia.org/wiki/Sierpinski_triangle> "Sierpinski triangle")  
的图形我早就见过了，是很漂亮的分形图形，只是今天才知道它叫这么个复杂的名字，很显然是以某个人命名的，因为我不研究分形，所以也不管他了。  
     
只是最近看《Interactive Computer Graphics》(5nd Edward  
Angel著）一书的时候，作者在讲解OpenGL  
API的时候就引入了这个有意思的图形，本书作为讲图形学的技术书籍（还是作为美国标准教材类型写作的），算是别具趣味性了。里面有几个绘制  
Sierpinski triangle的例子（书中称此图形为Sierpinski  
gasket，是一样的)，算是符合我以前学习的精神，用学到的最少的几个知识点，鼓捣出最大的乐趣。^^原文中的例子都是仅带源代码文件，（不带工程）  
源代码还是仅仅只能一个一个下载，而且显示的时候是一次性显示的，这个我感觉不太爽，不能显示出这种分形图形生成时那种渐变的感觉，特别是用点随机生成的  
那种类似粒子系统的乱中有序的效果，于是乎，一方面，给我感兴趣的原始版本配上XCode工程，（需要VS工程的就只能自己鼓捣了)另外一方面，提供动态  
生成图形的例子，也算是加深理解。。。。。。

第一个例子,通过限定随机的点来获取图形：
```c
#include <stdlib.h>
#include <GLUT/GLUT.h>

void init() {
  glClearColor(0.0, 0.0, 0.0, 0.0);
  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f(1.0, 0.0, 0.0);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0.0, 50.0, 0.0, 50.0, -1.0, 1.0);
}

void display() {   
  GLfloat vertices[3][3] = { {0.0,0.0,0.0}, {25.0, 50.0, 0.0}, {50.0, 0.0, 0.0}};
  GLfloat p[3] = {7.5,5.0,0.0};
   
  glBegin(GL_POINTS);
  for (int i=0; i<5000; ++i) {
    int x = rand()%3;
    
    p[0] = (p[0] + vertices[x][0])/2;
    p[1] = (p[1] + vertices[x][1])/2;
    
    glVertex3fv(p);
  }
  glEnd();
  glFlush();
}

int main (int argc, char *argv[]) {

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(640, 480);
  glutInitWindowPosition(200, 200);
  glutCreateWindow("sierpinski gasket");
  init();
  glutDisplayFunc(display);
  glutMainLoop();
   
  return 0;
}
```

这个例子是看到比较前面一部分就自己写完了，所以可能与作者源代码有些出入，display是一样的。显示效果：

![](http://hi.csdn.net/attachment/201010/12/0_1286905100hnV4.gif)  

感觉还不错，通过双缓冲，修改成动态生成版本。
```c
#include <time.h>
#include <stdlib.h>
#include <GLUT/GLUT.h>
#include <unistd.h>

int gCount = 1;
time_t gRandSeed;
void init() {
  glClearColor(0.0, 0.0, 0.0, 0.0);

  glColor3f(1.0, 0.0, 0.0);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0.0, 50.0, 0.0, 50.0, -1.0, 1.0);
}

void increaseDisplay() {
  gCount++;
  usleep(10000);
  glutPostRedisplay();
}

void display() {
  // just a rand seed hack for stably display
  srand(gRandSeed);
   
  glClear(GL_COLOR_BUFFER_BIT);
  GLfloat vertices[3][3] = { {0.0,0.0,0.0}, {25.0, 50.0, 0.0}, {50.0, 0.0, 0.0}};
  GLfloat p[3] = {7.5,5.0,0.0};
   
  glBegin(GL_POINTS);
  for (int i=0; i<gCount; ++i) {
    int x = rand()%3;
    
    p[0] = (p[0] + vertices[x][0])/2;
    p[1] = (p[1] + vertices[x][1])/2;
    
    glVertex3fv(p);
  }
  glEnd();
  glutSwapBuffers();
}

int main (int argc, char *argv[]) {
  gRandSeed = time(NULL);
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DOUBLE);
  glutInitWindowSize(640, 480);
  glutInitWindowPosition(200, 200);
  glutCreateWindow("sierpinski gasket");
  init();
  glutDisplayFunc(display);
  glutIdleFunc(increaseDisplay);
  glutMainLoop();
   
  return 0;
}
```

最终实现的时候发现并没有开始想的那么简单，因为随机出来的数值每次都不一样，相当于每次display都生成了完全新的图形，导致图形变换不定，达不到我  
想要的效果，于是乎，通过保存原始的随机种子，并且在每次随机的时候重新设定种子，(gRandSeed)以此来得到稳定的图形，效果非常好^^

第二个例子，通过三角形的递归分割来获取图形：  
作者原例子，可能因为原例子是C语言程序，当我将其当作C++编译时会有编译错误，所以我进行了少许的修改以正常编译运行。（添加stdlib.h的include，并且直接将n赋值为15）
```c
/* recursive subdivision of triangle to form Sierpinski gasket */
/* number of recursive steps given on command line */

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include <stdlib.h>

/* initial triangle */
GLfloat v[3][2]={ {-1.0, -0.58}, {1.0, -0.58}, {0.0, 1.15} };

int n = 15;

void triangle( GLfloat *a, GLfloat *b, GLfloat *c)

/* specify one triangle */
{
  glVertex2fv(a);
  glVertex2fv(b);
  glVertex2fv(c);
}

void divide_triangle(GLfloat *a, GLfloat *b, GLfloat *c, int m)
{
  
  /* triangle subdivision using vertex numbers */
  
  GLfloat v0[2], v1[2], v2[2];
  int j;
  if(m>0)
  {
    for(j=0; j<2; j++) v0[j]=(a[j]+b[j])/2;
    for(j=0; j<2; j++) v1[j]=(a[j]+c[j])/2;
    for(j=0; j<2; j++) v2[j]=(b[j]+c[j])/2;
    divide_triangle(a, v0, v1, m-1);
    divide_triangle(c, v1, v2, m-1);
    divide_triangle(b, v2, v0, m-1);
  }
  else triangle(a,b,c); /* draw triangle at end of recursion */
}

void display()
{
  glClear(GL_COLOR_BUFFER_BIT);
  glBegin(GL_TRIANGLES);
  divide_triangle(v[0], v[1], v[2], n);
  glEnd();
  glFlush();
}

void myinit()
{
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(-2.0, 2.0, -2.0, 2.0);
  glMatrixMode(GL_MODELVIEW);
  glClearColor (1.0, 1.0, 1.0, 1.0);
  glColor3f(0.0,0.0,0.0);
}

int main(int argc, char **argv)
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(500, 500);
  glutCreateWindow("Sierpinski Gasket");
  glutDisplayFunc(display);
  myinit();
  glutMainLoop();
}
```

因  
为使用了递归，在我的机器上n最多也就到10多，超过后程序会长时间无响应（顾及时堆栈溢出了），但是这个程序的渐变过程就更加好看了，相对于前面点随机  
的图形逐渐变厚实，这个例子中可以清晰的看到图形一步一步分割生成的过程，很有趣味。为了慢慢显示，所以这里直接sleep了一秒。
```c
#include <time.h>
#include <stdlib.h>
#include <GLUT/GLUT.h>
#include <unistd.h>

/* initial triangle */
GLfloat v[3][2]={ {-1.0, -0.58}, {1.0, -0.58}, {0.0, 1.15} };

int gCount = 1;

/* specify one triangle */
void triangle( GLfloat *a, GLfloat *b, GLfloat *c) {
  glVertex2fv(a);
  glVertex2fv(b);
  glVertex2fv(c);
}

/* triangle subdivision using vertex numbers */
void divide_triangle(GLfloat *a, GLfloat *b, GLfloat *c, int m) {

  GLfloat v0[2], v1[2], v2[2];
  int j;
  
  if( m > 0 )
  {
    for(j=0; j<2; j++) {
      v0[j]=(a[j]+b[j])/2;
    }
    
    for(j=0; j<2; j++) {
      v1[j]=(a[j]+c[j])/2;
    }
    
    for(j=0; j<2; j++) {
      v2[j]=(b[j]+c[j])/2;
    }
    
    divide_triangle(a, v0, v1, m-1);
    divide_triangle(c, v1, v2, m-1);
    divide_triangle(b, v2, v0, m-1);
  }
  else {
    triangle(a,b,c); /* draw triangle at end of recursion */
  }
}

void init() {
  /* attributes */
  glClearColor(1.0, 1.0, 1.0, 1.0); /* white background */
  glColor3f(1.0, 0.0, 0.0); /* draw in red */
   
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(-2.0, 2.0, -2.0, 2.0);
  glMatrixMode(GL_MODELVIEW);
}

void increaseDisplay() {
  if (gCount <= 15) {
    gCount++;
  }

  sleep(1);
  glutPostRedisplay();
}

void display() {

  glClear(GL_COLOR_BUFFER_BIT);
  glBegin(GL_TRIANGLES);
  divide_triangle(v[0], v[1], v[2], gCount);
  glEnd();
   
  glutSwapBuffers();
}

int main (int argc, char *argv[]) {
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DOUBLE);
  glutInitWindowSize(640, 480);
  glutInitWindowPosition(200, 200);
  glutCreateWindow("sierpinski gasket");
  init();
  glutDisplayFunc(display);
  glutIdleFunc(increaseDisplay);
  glutMainLoop();
   
  return 0;
}
```

这是某个中间过程的截图：

![](http://hi.csdn.net/attachment/201010/12/0_1286905116uEUE.gif)  

其  
实后面还有更加有趣的3维Sierpinski  
triangle的例子，但是因为没有任何新的东西，本文也就不展示了。以上所有源代码在https://blog-sample-  
code.jtianling.googlecode.com/hg/2010-10-12目录下可以找到。

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**