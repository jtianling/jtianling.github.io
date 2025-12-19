---
layout: post
title: "数据/配置 的存储方式 Json篇 以JsonCpp库使用为例"
categories:
- "游戏开发"
tags:
- Json
- JsonCpp
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

本文介绍了游戏开发中使用JSON配置的优势，并通过JsonCPP实例，展示了如何实现灵活的数据驱动。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**

[**讨论新闻组及文件**](http://groups.google.com/group/jiutianfile/)

## 配置的好处

我不知道我需不需要用一节内容来向大家讲解这个公认的事实。现在公认的事实实际上比单纯所谓的配置还要走的远，一般的看法，游戏中最好的用法是数据驱动而不是代码驱动。那样才能满足游戏需要灵活改变的特点，并且易于编辑。在开发期可以使用文本配置，以易于调试，XML是大多时候的选择。发布时通过资源处理，将文本配置转换为二进制配置以加快读取速度，减少解析时间。（假如效率可以接受的话，这一步甚至可以省略）配置对于C++这样编译时间超长的语言更加是非常必要（偏偏游戏编程大部分是用C++），当某个属性需要修改的时候只需要改动配置而不是文件，可以极大的减少开发期在编译中消耗的时间，特别是原来的宏定义的方式，假如很多地方需要而被放在了头文件中，每次的更改对于大型工程来说简直就是程序员休息上网的好时间。。。。。。。。。

## **JSon介绍**

**JSON**(JavaScript Object Notation) 是一种轻量级的数据交换格式。 易于人阅读和编写。同时也易于机器解析和生成。 它基于[JavaScript Programming Language](http://www.crockford.com/javascript), [Standard ECMA-262 3rd Edition - December 1999](http://www.ecma-international.org/publications/files/ecma-st/ECMA-262.pdf)的一个子集。 JSON采用完全独立于语言的文本格式，但是也使用了类似于C语言家族的习惯（包括C, C++, C#, Java, JavaScript, Perl, Python等）。 这些特性使JSON成为理想的数据交换语言。

JSON建构于两种结构：

* "名称/值"对的集合（A collection of name/value pairs）。不同的语言中，它被理解为 _对象 （object）_，纪录（record），结构（struct），字典（dictionary），哈希表（hash table），有键列表（keyed list），或者关联数组 （associative array）。
* 值的有序列表（An ordered list of values）。在大部分语言中，它被理解为数组（array）。

这些都是常见的数据结构。事实上大部分现代计算机语言都以某种形式支持它们。这使得一种数据格式在同样基于这些结构的编程语言之间交换成为可能。

JSON具有以下这些形式：

对象是一个无序的"'名称/值'对"集合。一个对象以"{"（左括号）开始，"}"（右括号）结束。每个"名称"后跟一个":"（冒号）；"'名称 /值' 对"之间使用"，"（逗号）分隔。

![](http://www.json.org/object.gif)

数组是值（value）的有序集合。一个数组以"["（左中括号）开始，"]"（右中括号）结束。值之间使用"，"（逗号）分隔。

![](http://www.json.org/array.gif)

值（ _value_）可以是双引号括起来的字符串（ _string_）、数值(number)、true、false、 null、对象（object）或者数组（array）。这些结构可以嵌套。

![](http://www.json.org/value.gif)

字符串（ _string_）是由双引号包围的任意数量Unicode字符的集合，使用反斜线转义。一个字符（character）即 一个单独的字符串（character string）。

字符串（ _string_）与C或者Java的字符串非常相似。

![](http://www.json.org/string.gif)

数值（ _number_）也与C或者Java的数值非常相似。除去未曾使用的八进制与十六进制格式。除去一些编码细节。

![](http://www.json.org/number.gif)

空白可以加入到任何符号之间。 以下描述了完整的语言。

介绍部分完全完全copy自Json的中文网页(http://www.json.org/json-zh.html)。

下面才是我自己的内容：

### 为什么要使用Json

Json的格式更加简单，同样的内容，用Json来表示比用XML表示时字符少的多，没有一大堆的标记及尖括号，决定了Json更加容易手写。同样的，字符少，信息量大，所以我认为也更加易读。而且，不常进行网页开发的我，非常讨厌尖括号！我不想去写那些重复的尖括号标记。。。。。。。。。。让人手写太多重复的东西简直就是犯罪。

在使用Json以前其实我都不是太喜欢配置，因为使用太麻烦，写起来浪费时间，虽然说配置可以节省编译时间，但是有那功夫写读写配置的代码，都编译N次了。特别是以前用Excel或者SQL的时候，读写数据/配置，都是非常非常麻烦的事情。此时我想起一句LUA之父说的话,只有当配置的使用足够简单灵活,人们才会使用它。

Json的格式到底有多简单，其实上面的介绍很多其实归根于两句话：

* "名称/值"对的集合（A collection of name/value pairs）。
* 值的有序列表（An ordered list of values）。

仅此而已。

一种就是

{x : y}

形式的名称/值对，说成key-value对可能更多人更好理解。

一种就是

{x : [1,2,3,4] }

或者 [1,2,3,4]

形式的有序列表。也就是数组。第二个例子说明数组也可以作为根对象。

另加上明白一个{}构成一个json对象，然后，因为上面的3种形式，可以任意嵌套，也就可以满足任意复杂的需求了。

缺点：

简单有简单的优势，但是也有简单带来的缺点，那就是缺乏高级特性，比如继承，引用这些很好用的特性在Json中就都没有，相对应的，XML中有类似的概念。另外，作为手工编写的配置，常常会需要用到运算，特别是引用+运算，当然，这些XML都很难做到，那得指望Lua了。事实上，我的确准备在以后尝试使用Lua做配置，因为以一个完整的语言来做配置的吸引力实在是太大了。。。。。。。。。。。另外，Json最后不支持可有可无的逗号（如C++ enum的语法格式那样），有的就必须有，没有的地方坚决不能没有，这个导致很容易出现问题，（主要是手写Json的时候），需要特别注意，一般可以通过工具验证一下自己的Json文件。比如[Jslint](http://www.jslint.com "Jslint"),[jsonlint](http://www.jsonlint.com "jsonlint").我个人常用jslint，报错非常详细，甚至有对不良语法的警告

## Json有多流行？

看看有多少语言的[解析库](http://www.json.org "解析库")，有多少语言有多个解析库就能一窥一二。对于JS来说，使用多方便就不用说了，像php,python事实上都已经原生支持Json的解析了。（通过函数或者标准库）

## 实例说明

得益于简单的格式,所以解析及创建都可以做的很简单的,特别是JSONCPP这个库,在使用的时候简直就像获取到JS中的Object一样,直接通过 [] 操作完成索引及建立操作,使用起来非常简单。这里以JsonCPP + SDL + OpenGL 为例，来记录一下Json的使用。之所以选用SDL ，仅仅是因为我了解并知道怎么它们，作为了解Json来说，下面的例子中，假如对SDL不熟悉的话，知道那些大量冗余的部分都是用来实际绘图和控制程序流程的，只关心与Json相关的部分即可。本例实现的功能与图像有关，需要用图形想关的东西属于迫不得已。至于为啥举与图像有关的例子，仅仅因为那样更酷^^难道我以读取配置然后正常printf读取的配置为例子吗？

### JsonCPP + SDL + OpenGL

[JsonCPP](http://jsoncpp.sourceforge.net "JsonCPP")介绍

JsonCpp是我本人非常喜欢的一个Json解析库，有读写模块，实现具有很强的移植性，当时在公司项目中嵌入JsonCpp时，仅仅通过修改了一个读文件的接口就完美的集成了进去，无论是在Windows平台还是在IPhone平台上都运行良好，当时我还当心在IPhone上会碰到什么问题，但是结果是没有碰到任何问题。。。。。。。。。对此，我印象非常深刻。JsonCpp中带有完整的测试套件，对于这样一个底层库，有测试套件存在，让人使用的时候心里放心很多。另外，JsonCpp使用C++的Map特性，（得益于Json语法的简单）可以非常方便的查找需要的任何Json数据，并且效率不低，当然，因为JsonCpp使用了一种DOM方式解析Json文档（参考XML的描述），一次将全部文档都解析了以后，然后再查询使用，使用虽然方便，但是效率上还是逊于SAX方式，但是，对于小规模应用，这应该不是问题。jsoncpp的文件比较少，其实全部拷贝进自己的工程都完全没有问题。jsoncpp的协议是公有领域，也就是说作者完全放弃了版权，你可以随便使用，连版权协议都不用带。需要include的头文件就是json.h，但是需要将include/json下的头文件都拷贝到需要的地方。例子中我为了方便还是用了静态库，将json附带的VS工程的Runtime library改成Multi-threaded Debug DLL (/MDd)，（个人习惯使用dll方式进行开发，这个需要和正在进行的工程一致）编译后，生成静态库。

这里我以某些参数显示某个图片为例，介绍json/jsoncpp的用法。

首先，原来的例子：

```cpp
#include <stdlib.h>
#include <stdio.h>
#include <tchar.h>
#include "SDL.h"
#include "SDL_opengl.h"
#include "SDL_image.h"

#define WINDOW_WIDTH 300
#define WINDOW_HEIGHT 300

GLuint gTexName;
//OpenGL初始化开始
void SceneInit(int w,int h)
{
  gluOrtho2D(-1.0, 1.0, -1.0, 1.0);
  glShadeModel(GL_FLAT);
  SDL_Surface *surface = IMG_Load("dragon.png");
  if (!surface)
  {
    printf("Load the picture failed.");
    exit(1);
  }
  GLenum texture_format;
  // get the number of channels in the SDL surface  
  GLint nOfColors = surface->format->BytesPerPixel;
  if (nOfColors == 4)     // contains an alpha channel
  {
    if (surface->format->Rmask == 0x000000ff)
      texture_format = GL_RGBA;
    else
      texture_format = GL_BGRA;
  } else if (nOfColors == 3)     // no alpha channel
  {
    if (surface->format->Rmask == 0x000000ff)
      texture_format = GL_RGB;
    else
      texture_format = GL_BGR;
  } else {
    printf("warning: the image is not truecolor..  this will probably break /n ");
    exit(1);
  }
  glGenTextures(1, &gTexName);
  glBindTexture(GL_TEXTURE_2D, gTexName);
  // Specify filtering and edge actions  
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexImage2D( GL_TEXTURE_2D, 0, nOfColors, surface->w, surface->h, 0,
    texture_format, GL_UNSIGNED_BYTE, surface->pixels );
  glEnable(GL_DEPTH_TEST);
  glEnable( GL_TEXTURE_2D );
  //Free the loaded image  
  SDL_FreeSurface( surface ); 
}
// display  
void SceneShow(GLvoid) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glBindTexture(GL_TEXTURE_2D, gTexName);
  glBegin(GL_QUADS);
  glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 1.0); glVertex3f(1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 0.0); glVertex3f(1.0, 1.0, 0.0);
  glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, 1.0, 0.0);
  glEnd();
}  
int _tmain(int argc, _TCHAR* argv[])
{
  if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) 
  {
    printf("Unable to initialize SDL: %s /n ", SDL_GetError());
    exit(1);
  }
  atexit(SDL_Quit);
  if (IMG_Init(IMG_INIT_PNG) == 0) {
    printf("Unable to initialize SDL_image");
    exit(1);
  }
  // use these two lines instead of the commented one  
  SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 ); // *new*  
  SDL_Surface* screen = SDL_SetVideoMode( WINDOW_WIDTH, WINDOW_HEIGHT, 16, SDL_OPENGL); // *changed* 
  SceneInit(WINDOW_WIDTH, WINDOW_HEIGHT);
  // main loop  
  bool running = true;
  while (running) {
    //While there's an event to handle   
    SDL_Event event; 
    while ( SDL_PollEvent( &event ) ) { 
      if (event.type == SDL_QUIT) {
        running = false;
      }
    }
    SceneShow();
    //Update Screen   
    SDL_GL_SwapBuffers();
    // delay, 50 for simple  
    SDL_Delay( 50 ); 
  }
    return 1;
}
```

代码主要就是SDL+OpenGL，很浅显易懂，可以参考原来的文章。《[GLFW 简单入门学习](http://www.jtianling.com/archive/2010/07/15/5738421.aspx)》，《[SDL 简单入门学习](http://www.jtianling.com/archive/2010/07/15/5735979.aspx)》，《[在SDL 中使用OpenGL](http://www.jtianling.com/archive/2010/07/17/5740993.aspx)》。

显示如下的图片：（为了减少截图提及，上面我特意将窗口创建成300*300这样比较小的体积了）

![](http://hi.csdn.net/attachment/201007/21/0_1279740306T213.gif)

这是原图，现在我希望将其显示加入一定的属性配置，以达到我的显示要求， 这里将配置放到Json中完成。

构建一段最简单的Json文件：

```json
{
    "name" : "dragon.png",
    "rotation" : 180
}
```

里面只有图片名字和旋转度数。顺便以此例解释下Json的语法，前面提到过Json的格式总的来说就是Key : value.如上所示，所有的key都是字符串，value可以是各种值，包括整数，boolean，字符串，数组，甚至是一个{ }表示的object。上例中，name表示图片的名字，rotation表示图片旋转的度数，这里的度数按照OpenGL的规范，以逆时针为正。

JsonCpp的使用就非常简单了。比如我用下列代码来解析上述Json文件：

```cpp
struct PictureInfo {
  string name;
  float rotation;
}gPictureInfo;

void PictureInit()
{
  Json::Reader reader;
  ifstream file("picture.json");
  assert(file.is_open());
  Json::Value root;
  if (!reader.parse(file, root, false)) {
    printf("Parse error");
    exit(1);
  }
  gPictureInfo.name = root["name"].asString();
  gPictureInfo.rotation = root["rotation"].asDouble();
}
```

虽然已经如此简单，但还是解释一下：

reader是用于parse Json文件的jsoncpp类，传入打开的ifstream文件对象即可完成parse。Json::Value是一个包罗万象的类，可以存储一个Json 对象，如上所示，整个Json文件就是一个Json对象,（以{}表示）在JsonCpp中表示为root，在parse函数中传入，打开的文件，根Value，parse后，root就包含了解析后的Json文件信息。对value的检索都是使用类似于C++中map的方式，直接以字符串为key索引，索引返回的还是一个Json::Value的对象，同样也可以有包罗万象的内容。（与Json文件格式本身对应）从Json::Value到C++的静态类型的转换在JsonCpp中通过Json::Value对象的asXXX函数来完成。上例中，asStrint表示返回一个C++的String对象，asDouble表示返回一个浮点数，以此类推。

通过上述方式，获得了图片名字，图片的rotation。以此来完成新的图片的显示。

将SceneShow部分改成如下代码：

```cpp
// display
void SceneShow(GLvoid) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glBindTexture(GL_TEXTURE_2D, gTexName);
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glRotatef(gPictureInfo.rotation, 0.0, 0.0, 1.0);
  glBegin(GL_QUADS);
  glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 1.0); glVertex3f(1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 0.0); glVertex3f(1.0, 1.0, 0.0);
  glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, 1.0, 0.0);
  glEnd();
  glPopMatrix();
}
```

添加了

```cpp
glPushMatrix();
glRotatef(gPictureInfo.rotation, 0.0, 0.0, 1.0);
glPopMatrix();
```

3句来进行模型矩阵变换，来完成旋转。

因为上面是180度，所以显示效果如下：

![](http://hi.csdn.net/attachment/201007/21/0_1279740334KTTF.gif)

在游戏编程古老的岁月中，大家都全靠图片来堆积游戏，仅仅是一个这样的旋转，都不会使用。下图是某游戏同一个武器不同方向的图片。事实上，完全没有必要。

![](http://hi.csdn.net/attachment/201007/21/0_1279740355iGiP.gif)

即使在今天，人物的4向行走用4组图片也不是什么稀罕事。。。。虽然其实是那么的没有必要。

这里再添加一些其他的要素，比如scale,position。（这里没有使用一般2D引擎中用的屏幕坐标，还是用OpenGL坐标）

Json配置：

```json
{
    "name" : "dragon.png",
    "rotation" : 0,
    "positionX" : -0.5,
    "positionY" : 0.0,
    "scaleX" : 0.3,
    "scaleY" : 1.0
}
```

代码改动部分：

```cpp
struct PictureInfo {
  string name;
  float rotation;
  float positionX;
  float positionY;
  float scaleX;
  float scaleY;
  // can't read from config,read from surface
  int width;
  int height;
}gPictureInfo;

void ReadPictureInfo() {
  Json::Reader reader;
  ifstream file("picture.json");
  assert(file.is_open());
  Json::Value root;
  if (!reader.parse(file, root, false)) {
    printf("Parse error");
    exit(1);
  }
  gPictureInfo.name = root["name"].asString();
  gPictureInfo.rotation = (float)root["rotation"].asDouble();
  gPictureInfo.positionX = (float)root["positionX"].asDouble();
  gPictureInfo.positionY = (float)root["positionY"].asDouble();
  gPictureInfo.scaleX = (float)root["scaleX"].asDouble();
  gPictureInfo.scaleY = (float)root["scaleY"].asDouble();
}

void PictureInit() {
  ReadPictureInfo();
}
```

```cpp
// display
void SceneShow(GLvoid) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glBindTexture(GL_TEXTURE_2D, gTexName);
  glPushMatrix();
  glMatrixMode(GL_MODELVIEW);
  glTranslatef(gPictureInfo.positionX, gPictureInfo.positionY, 0);
  glScalef(gPictureInfo.scaleX, gPictureInfo.scaleY, 0.0);
  glRotatef(gPictureInfo.rotation, 0, 0, 1.0);
  glBegin(GL_QUADS);
  glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 1.0); glVertex3f(1.0, -1.0, 0.0);
  glTexCoord2f(1.0, 0.0); glVertex3f(1.0, 1.0, 0.0);
  glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, 1.0, 0.0);
  glEnd();
  glPopMatrix();
}
```

添加了相应的读取代码而已，并在模型矩阵变换的时候添加了scale和rotate相关的代码，其实都没有什么新鲜的。

![](http://hi.csdn.net/attachment/201007/21/0_1279740380maVy.gif)

这里的乐趣在于，你可以不改变任何代码，通过配置实现很多改变了，虽然仅仅是这么一幅图。比如：

```json
{
    "name" : "dragon.png",
    "rotation" : 0,
    "positionX" : 0.5,
    "positionY" : 0.0,
    "scaleX" : -0.3,
    "scaleY" : 1.0
}
```

会得到如下的图：

![](http://hi.csdn.net/attachment/201007/21/0_1279740455gRLr.gif)

### Json数组

其实讲了上面的两个例子，我是想说明怎么样同时显示上述两幅图，都通过配置。这需要用到Json中的数组的概念，当然，懂一点编程的人对此都不会太陌生。配置如下：

```json
[
  {
    "name" : "dragon.png",
    "rotation" : 0,
    "positionX" : -0.5,
    "positionY" : 0.0,
    "scaleX" : 0.3,
    "scaleY" : 1.0
  },
  {
    "name" : "dragon.png",
    "rotation" : 0,
    "positionX" : 0.5,
    "positionY" : 0.0,
    "scaleX" : -0.3,
    "scaleY" : 1.0
  }
]
```

同时，代码的改动可能有些大，因为需要在任意地方都将原来的全局对象改为全局vector.实际的新内容除了解析Json那一部分，倒是几乎完全没有。解析Json数组时，与用普通的字符串key来索引value的差别仅仅在于此时只需要用整数来索引即可。

如下：

```cpp
using namespace std;
struct PictureInfo {
  string name;
  float rotation;
  float positionX;
  float positionY;
  float scaleX;
  float scaleY;
  // can't read from config,read from surface
  int width;
  int height;
  GLuint texName;
};

// didn't care about efficiency too much as a demo
vector<PictureInfo> gPictureInfoVec;

void ReadPictureInfo() {
  Json::Reader reader;
  ifstream file("picture.json");
  assert(file.is_open());
  Json::Value root;
  if (!reader.parse(file, root, false)) {
    printf("Parse error");
    exit(1);
  }
  assert(root.isArray());
  PictureInfo info;
  int size = root.size();
  for (int i = 0; i < size; ++i) {
    Json::Value &current = root[i];
    info.name = current["name"].asString();
    info.rotation = (float)current["rotation"].asDouble();
    info.positionX = (float)current["positionX"].asDouble();
    info.positionY = (float)current["positionY"].asDouble();
    info.scaleX = (float)current["scaleX"].asDouble();
    info.scaleY = (float)current["scaleY"].asDouble();
    gPictureInfoVec.push_back(info);
  }
}
```

上面这段for循环中的内容，root[i]的使用方式就是JsonCpp中索引Json数组的方式，很简单是吧？

于是，添加相应的显示代码后（其实也没有新内容，就是原来的东西变成数组）

```cpp
//OpenGL初始化开始
void SceneInit(int w,int h)
{
  glClearColor (1.0f, 1.0f, 1.0f, 0.0);
  glViewport(0, 0, w, h);
  glShadeModel(GL_FLAT);
  for (vector<PictureInfo>::iterator it = gPictureInfoVec.begin();
    it != gPictureInfoVec.end();
    ++it) {
      PictureInfo& info = *it;
      SDL_Surface *surface = IMG_Load(info.name.c_str());
      if (!surface)
      {
        printf("Load the picture failed: %s ",info.name.c_str());
        exit(1);
      }
      info.width = surface->w;
      info.height = surface->h;
      GLenum texture_format;
      // get the number of channels in the SDL surface  
      GLint nOfColors = surface->format->BytesPerPixel;
      if (nOfColors == 4)     // contains an alpha channel
      {
        if (surface->format->Rmask == 0x000000ff)
          texture_format = GL_RGBA;
        else
          texture_format = GL_BGRA;
      } else if (nOfColors == 3)     // no alpha channel
      {
        if (surface->format->Rmask == 0x000000ff)
          texture_format = GL_RGB;
        else
          texture_format = GL_BGR;
      } else {
        printf("warning: the image is not truecolor..  this will probably break /n ");
        exit(1);
      }
      glGenTextures(1, &info.texName);
      glBindTexture(GL_TEXTURE_2D, info.texName);
      glTexImage2D( GL_TEXTURE_2D, 0, nOfColors, surface->w, surface->h, 0,
        texture_format, GL_UNSIGNED_BYTE, surface->pixels );
      // Specify filtering and edge actions  
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
      //Free the loaded image  
      SDL_FreeSurface( surface ); 
  }
  glEnable(GL_DEPTH_TEST);
  glEnable( GL_TEXTURE_2D );
}
```

```cpp
// display
void SceneShow(GLvoid) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  for (vector<PictureInfo>::const_iterator it = gPictureInfoVec.begin();
    it != gPictureInfoVec.end();
    ++it) {
      const PictureInfo& info = *it;
      glBindTexture(GL_TEXTURE_2D, info.texName);
      glPushMatrix();
      glMatrixMode(GL_MODELVIEW);
      glTranslatef(info.positionX, info.positionY, 0);
      glScalef(info.scaleX, info.scaleY, 0.0);
      glRotatef(info.rotation, 0, 0, 1.0);
      glBegin(GL_QUADS);
      glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, -1.0, 0.0);
      glTexCoord2f(1.0, 1.0); glVertex3f(1.0, -1.0, 0.0);
      glTexCoord2f(1.0, 0.0); glVertex3f(1.0, 1.0, 0.0);
      glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, 1.0, 0.0);
      glEnd();
      glPopMatrix();
  }
}
```

可以看到一个很有意思的图^^当然，中间要是再加个球那就更好了。

![](http://hi.csdn.net/attachment/201007/21/0_1279740473hy3n.gif)

因为此时已经有点数据驱动的意思了，需要添加新龙的时候改改配置就好了。

其实这个例子还可以进一步发挥，在每个数组值之间进行插值，实现类似flash的关键帧动画^^让上图中左边的龙渐变成右边的龙，其实本例已经与此相差不远了。。。。。。限于精力有限，暂时就不进一步发挥了。


**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**
