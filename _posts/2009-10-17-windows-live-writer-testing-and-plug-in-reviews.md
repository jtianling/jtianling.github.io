---
layout: post
title: Windows Live Writer试用及众多插件试用评测
categories:
- "随笔"
tags:
- windows live writer
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者评测了Windows Live Writer的多款插件，重点测试代码高亮功能，并给出了最佳选择推荐。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)** __


一直比较被CSDN的博客系统所折磨，很多东西一直不太好用，在线编辑功能有多么不好用就不多数了，当年手一滑还可能在页面跳转时丢失全文，现在这点有所改善，在切换页面时有提醒，但是贴图片的操作还是如此的复杂，默认宽度还是无法调节,在我的1440*900的显示器上就像在800*600上编辑一样，让人崩溃。离线编辑明显还是更安全，更方便，也能在本地保存一份，所以使用上了Word2007，Word2007附带有博客发表功能，编辑功能足够的强大，贴图片更加方便了，但是可惜通过Word2007发表后的博文总是会格式不对，最气人的就是格式离谱到标题2比标题1要大，C++语言的#include <xxx>永远被解析，然后变成#include空气，也没有办法预览效果，直接编辑发布后的HTML。导致我非常郁闷，只能先通过，后来与CSDN负责人的工作人员联系了一下，他推荐我使用Windows Live Writer（以下简称WLW），我就试用了一下，感觉编辑功能太过简陋，首先复制粘贴会丢失格式，那么就没有办法直接粘贴代码附带颜色和格式了，并且不能自定义格式模板，即将段落，标题的格式改成自定义的，还不能通过模板新建文章，因为以上缺点，直接放弃了WLW。后来在网上看到有人说WLW是世界上最好的博客编写发布软件，甚至在Linux下他也是通过Wine去运行WLW写博客，我才准备回过头来确认一下，WLW真的有这么好吗？网上搜索了一下这几个缺陷，既然WLW支持插件系统，希望有插件可以解决问题吧，我将<http://gallery.live.com/>上感觉可能有用的插件全部下载回来，逐一尝试，顺便公布一下结果，免得大家做重复工作。以下是我下载回来的插件：

> [![2009-10-17 15-33-31 wlwplugins](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2015-33-31%20wlwplugins_thumb_1.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2015-33-31%20wlwplugins_4.png>) [![2009-10-17 16-04-22 wlwpluginsinsert](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2016-04-22%20wlwpluginsinsert_thumb_1.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2016-04-22%20wlwpluginsinsert_4.png>)

作为程序员的技术博客，插入代码没有高亮的问题首先是肯定要解决的，以下以一段OpenGL相关的C++程序片段为例，其中包含了#include，宏定义，函数定义，中文注释等，展示全部效果给大家看，

相关插件很多：

### [CodeSnippet](<http://gallery.live.com/liveItemDetail.aspx?li=d4409446-af7f-42ec-aa20-78aa5bac4748>)：

界面，配置选项非常多，感觉不错。还可选择silent模式，以后直接从剪贴板中按照原来的配置添上代码，简洁明快，很好，就是目前没有发现怎么关闭silent模式-_-!

最后在Documents and Settings/<用户名>/Application Data/Leo Vildosola/Code Snippet plugin for Windows Live Writer下找到了其配置文件CodeSnippet.dll.config，编辑RunSilent为false如下后修复。

<RunSilent>false</RunSilent>

[![2009-10-17 16-05-42 code Snippet](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2016-05-42%20code%20Snippet_thumb.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2016-05-42%20code%20Snippet_2.png>)

实际代码出现效果，可配置，可用容器显示滚动条效果以限制源代码所占篇幅（可惜高度不可以通过GUI方便的调节），格式正常，颜色漂亮，支持中文。感觉不错。有个缺点就是不是用容器的时候无法一次选择然后配置。

```cpp
      1: 
    
    
       2: // OpenGL需要的头文件
    
    
       3: #include <GL/glew.h>
    
    
       4: #include <GL/glut.h>
    
    
       5: 
    
    
       6: //定义程序链接时所需要调用的OpenGL程序库,简化工程配置
    
    
       7: #pragma comment( lib, "glu32.lib" )  
    
    
       8: #pragma comment( lib, "glut32.lib" )  
    
    
       9: 
    
    
      10: // DEFINES ////////////////////////////////////////////////
    
    
      11: 
    
    
      12: // MACROS /////////////////////////////////////////////////
    
    
      13: 
    
    
      14: #define KEYDOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
    
    
      15: #define KEYUP(vk_code)   ((GetAsyncKeyState(vk_code) & 0x8000) ? 0 : 1)
    
    
      16: 
    
    
      17: // GLOBALS ////////////////////////////////////////////////
    
    
      18: HWND      ghWnd; // 窗口句柄
    
    
      19: HINSTANCE ghInstance; // 程序实例句柄
    
    
      20: 
    
    
      21: #define FRAME_PER_SECOND (30)
    
    
      22: #define TIME_IN_FRAME (1000/FRAME_PER_SECOND)
    
    
      23: #define CIRCLE_POINTS (100)
    
    
      24: #define PI (3.1415926535898)
    
    
      25: 
    
    
      26: // 取消 OpenGL ，在程序结束前调用，释放渲染环境，设备环境以及最终窗口句柄。
    
    
      27: void DisableOpenGL()
    
    
      28: {
    
    
      29:     wglMakeCurrent( NULL, NULL );
    
    
      30:     wglDeleteContext( ghRC );
    
    
      31:     ReleaseDC( ghWnd, ghDC );
    
    
      32: }
    
    
      33: 
    
    
       1: // OpenGL需要的头文件
    
    
       2: #include <GL/glew.h>
    
    
       3: #include <GL/glut.h>
    
    
       4: 
    
    
       5: //定义程序链接时所需要调用的OpenGL程序库,简化工程配置
    
    
       6: #pragma comment( lib, "glu32.lib" )  
    
    
       7: #pragma comment( lib, "glut32.lib" )  
    
    
       8: 
    
    
       9: // DEFINES ////////////////////////////////////////////////
    
    
      10: 
    
    
      11: // MACROS /////////////////////////////////////////////////
    
    
      12: 
    
    
      13: #define KEYDOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
    
    
      14: #define KEYUP(vk_code)   ((GetAsyncKeyState(vk_code) & 0x8000) ? 0 : 1)
    
    
      15: 
    
    
      16: // GLOBALS ////////////////////////////////////////////////
    
    
      17: HWND      ghWnd; // 窗口句柄
    
    
      18: HINSTANCE ghInstance; // 程序实例句柄
    
    
      19: 
    
    
      20: #define FRAME_PER_SECOND (30)
    
    
      21: #define TIME_IN_FRAME (1000/FRAME_PER_SECOND)
    
    
      22: #define CIRCLE_POINTS (100)
    
    
      23: #define PI (3.1415926535898)
    
    
      24: 
    
    
      25: // 取消 OpenGL ，在程序结束前调用，释放渲染环境，设备环境以及最终窗口句柄。
    
    
      26: void DisableOpenGL()
    
    
      27: {
    
    
      28:     wglMakeCurrent( NULL, NULL );
    
    
      29:     wglDeleteContext( ghRC );
    
    
      30:     ReleaseDC( ghWnd, ghDC );
    
    
      31: }
```

## 

### [Paste As VS Code](<http://gallery.live.com/liveItemDetail.aspx?li=d8835a5e-28da-4242-82eb-e1a006b083b9>)

界面如下，选项还算比较丰富，但是明显没有[CodeSnippet](<http://gallery.live.com/liveItemDetail.aspx?li=d4409446-af7f-42ec-aa20-78aa5bac4748>)好

[![2009-10-17 16-21-38pasteasVScode](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2016-21-38pasteasVScode_thumb_1.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2016-21-38pasteasVScode_4.png>)

代码效果还行，并且可以一次选中然后进一步配置，就是对中文支持有些问题，可惜了。还有标题栏可以选择显示，就是不能编辑，奇怪的设置。

```cpp
  1.   2. // OpenGL??的头文件
  3. #include <GL/glew.h>
  4. #include <GL/glut.h>
  5.   6. //定义程序?接时所???用的OpenGL程序库,简化工程?置
  7. #pragma comment( lib, "glu32.lib" )
  8. #pragma comment( lib, "glut32.lib" )
  9.   10. // DEFINES ////////////////////////////////////////////////
  11.   12. // MACROS /////////////////////////////////////////////////
  13.   14. #define KEYDOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0) 
  15. #define KEYUP(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 0 : 1) 
  16.   17. // GLOBALS ////////////////////////////////////////////////
  18. HWND ghWnd; // 窗口句柄
  19. HINSTANCE ghInstance; // 程序实例句柄
  20.   21. #define FRAME_PER_SECOND (30) 
  22. #define TIME_IN_FRAME (1000/FRAME_PER_SECOND) 
  23. #define CIRCLE_POINTS (100) 
  24. #define PI (3.1415926535898) 
  25.   26. // 取消 OpenGL ?在程序结束前?用??放渲染环境??备环境以及最终窗口句柄。
  27. void DisableOpenGL() 
  28: { 
  29. wglMakeCurrent( NULL, NULL ); 
  30. wglDeleteContext( ghRC ); 
  31. ReleaseDC( ghWnd, ghDC ); 
  32. } 
```

[Source Code Formater](<http://www.amergerzic.com/post/WLWSourceCodePlugin.aspx>):

界面,很大,感觉不错,虽然配置选项其实不多,也可选择box格式，不过效果一般。

[![2009-10-17 17-01-34sourcecodeformatter](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-01-34sourcecodeformatter_thumb.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-01-34sourcecodeformatter_2.png>)

全文格式效果一般，颜色明显没有Code Snippet丰富,而且代码行间距实在太大,还无法配置.

```cpp
      1: 
    
    
    
      2: // OpenGL需要的头文件
    
    
    
      3: #include <GL/glew.h>
    
    
    
      4: #include <GL/glut.h>
    
    
    
      5: 
    
    
    
      6: //定义程序链接时所需要调用的OpenGL程序库,简化工程配置
    
    
    
      7: #pragma comment( lib, "glu32.lib" )  
    
    
    
      8: #pragma comment( lib, "glut32.lib" )  
    
    
    
      9: 
    
    
    
     10: // DEFINES ////////////////////////////////////////////////
    
    
    
     11: 
    
    
    
     12: // MACROS /////////////////////////////////////////////////
    
    
    
     13: 
    
    
    
     14: #define KEYDOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
    
    
    
     15: #define KEYUP(vk_code)   ((GetAsyncKeyState(vk_code) & 0x8000) ? 0 : 1)
    
    
    
     16: 
    
    
    
     17: // GLOBALS ////////////////////////////////////////////////
    
    
    
     18: HWND      ghWnd; // 窗口句柄
    
    
    
     19: HINSTANCE ghInstance; // 程序实例句柄
    
    
    
     20: 
    
    
    
     21: #define FRAME_PER_SECOND (30)
    
    
    
     22: #define TIME_IN_FRAME (1000/FRAME_PER_SECOND)
    
    
    
     23: #define CIRCLE_POINTS (100)
    
    
    
     24: #define PI (3.1415926535898)
    
    
    
     25: 
    
    
    
     26: // 取消 OpenGL ，在程序结束前调用，释放渲染环境，设备环境以及最终窗口句柄。
    
    
    
     27: void DisableOpenGL()
    
    
    
     28: {
    
    
    
     29:     wglMakeCurrent( NULL, NULL );
    
    
    
     30:     wglDeleteContext( ghRC );
    
    
    
     31:     ReleaseDC( ghWnd, ghDC );
    
    
    
     32: }
    
    
    
     33: 
    
    
    
     34: 
```

一个[syntaxhighlighter](<http://code.google.com/p/syntaxhighlighter/>)

似乎要和Windows的博客空间相匹配，而且配置界面感觉很简陋，在我的机器上以insert就崩溃

[![2009-10-17 17-10-19 Syntax Highlighter](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-10-19%20Syntax%20Highlighter_thumb.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-10-19%20Syntax%20Highlighter_2.png>)

另一个[Syntax Highlighter](<http://www.buayacorp.com/>)

界面简陋

[![2009-10-17 17-18-36 syntax highlighted](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-18-36%20syntax%20highlighted_thumb.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-18-36%20syntax%20highlighted_2.png>)

颜色还不错,但是不支持中文,一票否决.

```cpp
// OpenGLÐèÒªµÄÍ·ÎÄ¼þ
#include <GL/glew.h>
#include <GL/glut.h>

//¶¨Òå³ÌÐòÁ´½ÓÊ±ËùÐèÒªµ÷ÓÃµÄOpenGL³ÌÐò¿â,¼ò»¯¹¤³ÌÅäÖÃ
#pragma comment( lib, "glu32.lib" )  
#pragma comment( lib, "glut32.lib" )  

// DEFINES ////////////////////////////////////////////////

// MACROS /////////////////////////////////////////////////

#define KEYDOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
#define KEYUP(vk_code)   ((GetAsyncKeyState(vk_code) & 0x8000) ? 0 : 1)

// GLOBALS ////////////////////////////////////////////////
HWND      ghWnd; // ´°¿Ú¾ä±ú
HINSTANCE ghInstance; // ³ÌÐòÊµÀý¾ä±ú

#define FRAME_PER_SECOND (30)
#define TIME_IN_FRAME (1000/FRAME_PER_SECOND)
#define CIRCLE_POINTS (100)
#define PI (3.1415926535898)

// È¡Ïû OpenGL £¬ÔÚ³ÌÐò½áÊøÇ°µ÷ÓÃ£¬ÊÍ·ÅäÖÈ¾»·¾³£¬Éè±¸»·¾³ÒÔ¼°×îÖÕ´°¿Ú¾ä±ú¡£
void DisableOpenGL()
{
	wglMakeCurrent( NULL, NULL );
	wglDeleteContext( ghRC );
	ReleaseDC( ghWnd, ghDC );
}
```

还有一个[syntax highter](<http://blog.prabir.me/>),需求真是大啊,软件如此多。可

[![2009-10-17 17-27-22 syntax highlighted edit](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-27-22%20syntax%20highlighted%20edit_thumb.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-27-22%20syntax%20highlighted%20edit_2.png>)

名不符实，根本没有高亮，仅仅只有缩进。但是可以一次选中然后配置，这点比较好。支持中文。

```cpp
// OpenGL需要的头文件
#include <GL/glew.h>
#include <GL/glut.h>

//定义程序链接时所需要调用的OpenGL程序库,简化工程配置
#pragma comment( lib, "glu32.lib" )  
#pragma comment( lib, "glut32.lib" )  

// DEFINES ////////////////////////////////////////////////

// MACROS /////////////////////////////////////////////////

#define KEYDOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
#define KEYUP(vk_code)   ((GetAsyncKeyState(vk_code) & 0x8000) ? 0 : 1)

// GLOBALS ////////////////////////////////////////////////
HWND      ghWnd; // 窗口句柄
HINSTANCE ghInstance; // 程序实例句柄

#define FRAME_PER_SECOND (30)
#define TIME_IN_FRAME (1000/FRAME_PER_SECOND)
#define CIRCLE_POINTS (100)
#define PI (3.1415926535898)

// 取消 OpenGL ，在程序结束前调用，释放渲染环境，设备环境以及最终窗口句柄。
void DisableOpenGL()
{
	wglMakeCurrent( NULL, NULL );
	wglDeleteContext( ghRC );
	ReleaseDC( ghWnd, ghDC );
}
```

[Paste from Visual Studio](<http://gallery.live.com/liveItemDetail.aspx?li=d8835a5e-28da-4242-82eb-e1a006b083b9>)

完美复制visual studio的代码，从其他地方拷贝过来的无效，无界面配置。用途单一。

```cpp
// OpenGL需要的头文件
#include <GL/glew.h>
#include <GL/glut.h>

//定义程序链接时所需要调用的OpenGL程序库,简化工程配置
#pragma comment( lib, "glu32.lib" )  
#pragma comment( lib, "glut32.lib" )  

// DEFINES ////////////////////////////////////////////////

// MACROS /////////////////////////////////////////////////

#define KEYDOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
#define KEYUP(vk_code)   ((GetAsyncKeyState(vk_code) & 0x8000) ? 0 : 1)

// GLOBALS ////////////////////////////////////////////////
HWND      ghWnd; // 窗口句柄
HINSTANCE ghInstance; // 程序实例句柄

#define FRAME_PER_SECOND (30)
#define TIME_IN_FRAME (1000/FRAME_PER_SECOND)
#define CIRCLE_POINTS (100)
#define PI (3.1415926535898)

// 取消 OpenGL ，在程序结束前调用，释放渲染环境，设备环境以及最终窗口句柄。
void DisableOpenGL()
{
    wglMakeCurrent( NULL, NULL );
    wglDeleteContext( ghRC );
    ReleaseDC( ghWnd, ghDC );
}
```

## 代码及语法高亮插件小结

没有感觉完美的插件，相对来说不支持中文的我们不考虑了，不支持C++的我不考虑了，最后结论是仅仅使用VS的人可以考虑[Paste from Visual Studio](<http://gallery.live.com/liveItemDetail.aspx?li=d8835a5e-28da-4242-82eb-e1a006b083b9>)，够用就行，不然[CodeSnippet](<http://gallery.live.com/liveItemDetail.aspx?li=d4409446-af7f-42ec-aa20-78aa5bac4748>)是最佳选择，比那么多的syntax highlighter都要好用，[Source Code Formater](<http://www.amergerzic.com/post/WLWSourceCodePlugin.aspx>)可以作为第二选择，相对来说显示效果没有[CodeSnippet](<http://gallery.live.com/liveItemDetail.aspx?li=d4409446-af7f-42ec-aa20-78aa5bac4748>)好，配置选项没有那么丰富。

其他插件：

[MSDN Link](<http://gallery.live.com/liveItemDetail.aspx?li=8c4fdb4d-96ad-47cb-a005-83837e2e347e&bt=9&pl=8>)：

感觉不错，作用也很好，说是能很方便的查找添加MSDN的关键字链接，可是我连查wglMakeCurrent，wglDeleteContext，ReleaseDC都不存在，然后查了个简单的abs都查不到，有可能是网络问题，但是现在我网络状况很好，可惜了。

[![2009-10-17 17-45-08locateurlatmsdn](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-45-08locateurlatmsdn_thumb.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_2009-10-17%2017-45-08locateurlatmsdn_2.png>)

[from console](<http://gallery.live.com/liveItemDetail.aspx?li=91093902-65b8-4237-9bff-524aec1369a3&bt=9&pl=8>)：

将控制台中复制的东西插入，因为我常用putty登录linux，然后展示命令行的东西，所以对我个人也很实用，也许一般人没有什么用吧。Windows的命令行甚至可以显示命令高亮-_-!功能强大，好用，虽然没有任何配置的办法。

Windows:

```bash
**C:/ >**_dir/w_
 驱动器 C 中的卷没有标签。
 卷的序列号是 6854-7E94

 C:/ 的目录

AnalysisLog.sr0          AUTOEXEC.BAT             CONFIG.SYS
[Documents and Settings] [Download]               [Downloads]
[ppt]                    [Program Files]          [TDDOWNLOAD]
[Temp]                   [WINDOWS]
               3 个文件        419,464 字节
               8 个目录  1,806,254,080 可用字节

**C:/ >**__  
```

---  

Linux:

```bash
jtianling@jtianling-laptop:~$ ls -l | head -n 5
总用量 20772
-rwxrw-r--  1 jtianling jtianling     1570 2008-10-26 16:59 1
-rwxrw-r--  1 jtianling jtianling       11 2009-08-21 17:25 1.bat
-rwxrw-r--  1 jtianling jtianling       80 2008-11-12 23:45 allhead
-rw-r--r--  1 jtianling jtianling        0 2009-08-29 12:37 a.out
jtianling@jtianling-laptop:~$   
```

---  

Rich Editor

有点像代码高亮的插件，但是仅支持C#和VB.net,还不支持中文，图都不想贴。

[SnagIt Screen Capture](<http://wlwplugins.com/snagit-screen-capture-plugin-for-windows-live-writer.php>)

能将抓的图直接粘贴到WLW中，甚至不保存，节省大量时间，强烈推荐使用，首先要安装SnagIt。有一点问题就是配置太少无法抓WLW本身的图,医者不自医?-_-!

[![image](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_image_thumb.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_image_2.png>)

[WikiPedia Link](<http://gallery.live.com/liveItemDetail.aspx?li=5232c390-e919-40ab-b44c-77dcf49892b3&bt=9&pl=8>)

直接插入关键字在Wiki的链接，相对来说，由于Wiki的目录设置，其直接通过字符串生成了Wiki的链接，甚至没有查看一下链接是否存在，这点比较郁闷，但是总的来说还是值得一用。比如右边，[C++](<http://en.wikipedia.org/wiki/C++>)，就是用此插件插入的，当肯定链接存在时不妨一用。

Word Count

原以为WLW中没有统计字数的功能，后来我发现本来就有，那还要这个干啥？还要求先选中全文-_-!无语了。

[Text Template](<http://www.codeplex.com/wikipage?ProjectName=wlwTextTemplate>)

有点类似VA的Snippets功能，保存文本的模板，可惜的是不能将全部格式保留下来，所以将范围限制在了最最简单的文字，有点可惜。

## 总结

以上就是我使用过的插件，感觉Windows Live Writer本身可能不是太好用，但是没有关系，有了这些插件后，就好用多了，对于我来说，特别重要的是语法高亮的插件，这也算是开放的一个好处吧，希望微软多多开放，就像VS及WLW走的路一样。

本文因为操作Windows live Writer失误，被新的文章覆盖，通过Google cache奇迹般地找回，感谢Google-_-!


