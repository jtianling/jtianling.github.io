---
layout: post
title: "简单图形编程的学习（1）---文字 (Windows GDI实现)"
categories:
- "游戏开发"
tags:
- Windows GDI
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '21'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**简单图形编程的学习（1）---文字 (Windows GDI实现)**

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

 

# 一、   全部简单图形编程的学习说在前面的话

      此系列文章均假设读者已经具备一定的对应的程序编写知识，无论是最简单的small basic,还是因为常用而被人熟知的Windows GDI，或者是Linux下用的更多的Qt(一般我用PyQt),甚至是现在国内知道的人并不多的Android，我都不准备讲太多基础的语法，或者与平台相关的太多背景知识，这些靠读者先行学习，我仅仅准备在自己学习的过程中找点乐子：）看看我用一些简单的接口都能想出干什么事情，然后展示给大家看看，图形程序实在是最好展示的一类程序了，不像其他程序一样，哪怕我讲了一堆的boost，真正见识到boost强大的又有几个呢？-_-!要知道，今天起，所有程序都是窗口程序，不再是命令行!!!!人类用了多久才走到这一步我不知道。。。。我用了25年.......（从我出生算起）或者1年（从工作开始）

       另外，想要看怎么编写窗口应用程序的就不要走错地方了，这里不是想怎么描述怎么使用一个又一个的控件，这里都是讲绘图的-_-!

 

# 二、   谈谈Windows GDI

由于今天是第一篇，所以谈谈Windows GDI

虽然因为兴趣和工作需要，对Linux也有所了解，但是Windows到目前为止绝对是本人最熟悉的平台。。。也许也是绝大部分程序员最熟悉的平台吧，但是GDI用的实在是并不多。。。。也许又要说了。。我本质上是个服务器端的程序员-_-!呵呵，服务器端程序员每天面对的只能是控制台，与图形化界面无关，更加与GDI无关。。。。呵呵，但是假如要做客户端的话，是有图形界面了，但是其实游戏还是不需要用到GDI的。。。Windows下不都是用DirectX嘛。但是我对GDI还是比较有兴趣，主要来源于一个资深同事描述用Windows GDI去描述IM软件界面的往事（公司以前是做IM软件的），呵呵，我听着都觉得出神入化。自己好歹也了解一下，虽然说其实用到的机会不多。

文字好像都不像是图形编程中应该学习的东西，但是别忘了，文字可都是由象形文字发展过来的。。。中文至今还是象形文字呢，文字在远古的时代可本来就是图形啊，为啥学习图形编程的时候不要学习怎么显示文字啊？呵呵，前面的都是废话，其实你编点啥程序都会碰到需要在图形中显示文字的情况，所以我们先来看看文字的显示。另外，其实在显示文字的时候，假如需要对文字的显示进行设置，也能学到很多普通图形的设置方式，这点以后就能看到。

 

# 三、   Windows GDI的文字显示

事实上因为一个完整的Windows程序已经较为复杂，所以以后的程序得有个模板可以套才行，不然老是纠缠在窗口注册，创建和消息循环上了，那样效率太低。这里就用VS2005创建Win32程序本身的那一套了，不用MFC是不想拦住不了解也不像熟悉MFC的兄弟，也许另外弄个MFC+GDI+ （注：切分格式是(MFC+(GDI+))-_-!）篇吧。

基本程序如下：

// Win32GraphicEx1.cpp : 定义应用程序的入口点。

//

 

#include "stdafx.h"

#include "Win32GraphicEx1.h"

 

#define MAX_LOADSTRING 100

 

// 全局变量:

HINSTANCE hInst;                    // 当前实例

TCHAR szTitle[MAX_LOADSTRING];            // 标题栏文本

TCHAR szWindowClass[MAX_LOADSTRING];      // 主窗口类名

 

// 此代码模块中包含的函数的前向声明:

ATOM          MyRegisterClass(HINSTANCE hInstance);

BOOL          InitInstance(HINSTANCE, int);

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

INT_PTR CALLBACK About(HWND, UINT, WPARAM, LPARAM);

 

int APIENTRY _tWinMain(HINSTANCE hInstance,

                     HINSTANCE hPrevInstance,

                     LPTSTR    lpCmdLine,

                     int       nCmdShow)

{

   UNREFERENCED_PARAMETER(hPrevInstance);

   UNREFERENCED_PARAMETER(lpCmdLine);

 

   // TODO: 在此放置代码。

   MSG msg;

   HACCEL hAccelTable;

 

   // 初始化全局字符串

   LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);

   LoadString(hInstance, IDC_WIN32GRAPHICEX1, szWindowClass, MAX_LOADSTRING);

   MyRegisterClass(hInstance);

 

   // 执行应用程序初始化:

   if (!InitInstance (hInstance, nCmdShow))

   {

      return FALSE;

   }

 

   hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_WIN32GRAPHICEX1));

 

   // 主消息循环:

   while (GetMessage(&msg, NULL, 0, 0))

   {

      if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))

      {

         TranslateMessage(&msg);

        DispatchMessage(&msg);

      }

   }

 

   return (int) msg.wParam;

}

 

 

 

//

//  函数: MyRegisterClass()

//

//  目的: 注册窗口类。

//

//  注释:

//

//    仅当希望

//    此代码与添加到Windows 95 中的“RegisterClassEx”

//    函数之前的Win32 系统兼容时，才需要此函数及其用法。调用此函数十分重要，

//    这样应用程序就可以获得关联的

//    “格式正确的”小图标。

//

ATOM MyRegisterClass(HINSTANCE hInstance)

{

   WNDCLASSEX wcex;

 

   wcex.cbSize = sizeof(WNDCLASSEX);

 

   wcex.style       = CS_HREDRAW | CS_VREDRAW;

   wcex.lpfnWndProc = WndProc;

   wcex.cbClsExtra     = 0;

   wcex.cbWndExtra     = 0;

   wcex.hInstance      = hInstance;

   wcex.hIcon       = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_WIN32GRAPHICEX1));

   wcex.hCursor     = LoadCursor(NULL, IDC_ARROW);

   wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);

   wcex.lpszMenuName   = MAKEINTRESOURCE(IDC_WIN32GRAPHICEX1);

   wcex.lpszClassName  = szWindowClass;

   wcex.hIconSm     = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

 

   return RegisterClassEx(&wcex);

}

 

//

//   函数: InitInstance(HINSTANCE, int)

//

//   目的: 保存实例句柄并创建主窗口

//

//   注释:

//

//        在此函数中，我们在全局变量中保存实例句柄并

//        创建和显示主程序窗口。

//

BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)

{

   HWND hWnd;

 

   hInst = hInstance; // 将实例句柄存储在全局变量中

 

   hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,

      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

 

   if (!hWnd)

   {

      return FALSE;

   }

 

   ShowWindow(hWnd, nCmdShow);

   UpdateWindow(hWnd);

 

   return TRUE;

}

 

//

//  函数: WndProc(HWND, UINT, WPARAM, LPARAM)

//

//  目的: 处理主窗口的消息。

//

//  WM_COMMAND   \- 处理应用程序菜单

//  WM_PAINT  \- 绘制主窗口

//  WM_DESTROY   \- 发送退出消息并返回

//

//

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)

{

   int wmId, wmEvent;

   PAINTSTRUCT ps;

   HDC hdc;

 

   switch (message)

   {

   case WM_COMMAND:

      wmId    = LOWORD(wParam);

      wmEvent = HIWORD(wParam);

      // 分析菜单选择:

      switch (wmId)

      {

      case IDM_ABOUT:

        DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);

        break;

      case IDM_EXIT:

        DestroyWindow(hWnd);

        break;

      default:

        return DefWindowProc(hWnd, message, wParam, lParam);

      }

      break;

   case WM_PAINT:

      hdc = BeginPaint(hWnd, &ps);

      // TODO: 在此添加任意绘图代码...

      EndPaint(hWnd, &ps);

      break;

   case WM_DESTROY:

      PostQuitMessage(0);

      break;

   default:

      return DefWindowProc(hWnd, message, wParam, lParam);

   }

   return 0;

}

 

// “关于”框的消息处理程序。

INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)

{

   UNREFERENCED_PARAMETER(lParam);

   switch (message)

   {

   case WM_INITDIALOG:

      return (INT_PTR)TRUE;

 

   case WM_COMMAND:

      if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)

      {

        EndDialog(hDlg, LOWORD(wParam));

        return (INT_PTR)TRUE;

      }

      break;

   }

   return (INT_PTR)FALSE;

}

 

以后讲解的时候可能就不列出完整的源代码了，因为用C++编写Win32程序，可能动辄几页的代码，完整列出影响阅读，为了完整，就如前面所言，我已经假定读者都具有相关领域一定的编程经验，将描述的代码放进恰当的位置应该不成问题。

文字的显示是个复杂的问题，（自有历史以来就复杂）不仅仅是调用几个类似于TextOut，DrawText ，DrawTextEx API那么简单，看过《Windows 图形编程》（参考1）的人应该会有同感，此书是我见过关于Windows下字体，文字显示最深入的一本书，（其实是其他的专著太深看不懂也没有看）。

至于Windows下普通的文字显示API，《Programming Windows》一书按照惯例还是最好的一本。

 

       Windows下最常用的文字输出API就是前面提到的3个，见下面的例子：

   case WM_PAINT:

      {

        hdc = BeginPaint(hWnd, &ps);

        // TextOut

        TextOut(hdc, 0, 0, szHelloWorld, (int)_tcslen(szHelloWorld));

 

        // DrawText

        RECT rtText = {0, 50, 100, 100};

        DrawText(hdc, szHelloWorld, -1, &rtText, DT_LEFT);

 

        // DrawTextEx

        rtText.top += 50;

        rtText.bottom += 50;

        DrawTextEx(hdc, szHelloWorld, -1, &rtText, DT_LEFT, NULL);

        EndPaint(hWnd, &ps);

      }

 

显示效果如插图1。

 其实还有几个使用复杂度稍微高一点，但是控制力更强一些的文本输出函数，比如TabbedTextOut,ExtTextOut。（八卦一下：ExtTextOut是少有的将Ext放在函数名前表示扩展而不是按照微软惯例将Ex表示扩展放在函数名后的函数，估计是设计此函数的人刚到微软工作-_-!）

 

# 四、   字体

其实字体是个更加复杂的问题。。。。有多少人知道在字体的现实问题上MS,Apple,Adobe的研究人员投入了多少精力啊。。。。今天的TrueType可不是一开始就存在的。。。。

当然，其实今天我们已经没有必要再去重复研究了，Windows下用MS提供的API就好了，一般有两个接口：

 

HFONT CreateFont(

  int nHeight,               // height of font

  int nWidth,                // average character width

  int nEscapement,           // angle of escapement

  int nOrientation,          // base-line orientation angle

  int fnWeight,              // font weight

  DWORD fdwItalic,           // italic attribute option

  DWORD fdwUnderline,        // underline attribute option

  DWORD fdwStrikeOut,        // strikeout attribute option

  DWORD fdwCharSet,          // character set identifier

  DWORD fdwOutputPrecision,  // output precision

  DWORD fdwClipPrecision,    // clipping precision

  DWORD fdwQuality,          // output quality

  DWORD fdwPitchAndFamily,   // pitch and family

  LPCTSTR lpszFace           // typeface name

);

这个接口直接通过超多的参数创建字体，看看参数的数量。。。就知道我说过的字体显示是个复杂问题没有错了。。。。

另外有个更加人性化的接口，那就是利用结构，本质上没有太大区别，只是从软件接口设计上来说，当参数超过6，7个的时候提供结构传递参数会更加人性化一点，CreateWindow之类的也就是遵循了这样的方式。这也是BS说C++中不提供关键词参数，关键词参数没有那么重要的主要理由之一。（不明白我说的是什么那就忽略此句。。。见D&E6.5）

所谓的用结构创建字体的接口如下：

HFONT CreateFontIndirect(

  CONST LOGFONT* lplf   // characteristics

);

LOGFONT结构就是前面一个直接创建的接口的参数的堆叠：

typedef struct tagLOGFONTW

{

    LONG      lfHeight;

    LONG      lfWidth;

    LONG      lfEscapement;

    LONG      lfOrientation;

    LONG      lfWeight;

    BYTE      lfItalic;

    BYTE      lfUnderline;

    BYTE      lfStrikeOut;

    BYTE      lfCharSet;

    BYTE      lfOutPrecision;

    BYTE      lfClipPrecision;

    BYTE      lfQuality;

    BYTE      lfPitchAndFamily;

    WCHAR     lfFaceName[LF_FACESIZE];

} LOGFONTW, *PLOGFONTW, NEAR *NPLOGFONTW, FAR *LPLOGFONTW;

 

这里列出来的是宽字节版本。参数如此之多，一方面体现了复杂度，一方面也是自由度，其实个人认为有点点设计的累赘了。。。。其实完全没有必要用一个一个整数来表示一个bool值的内容，MS习惯的位标志竟然在此处看不到痕迹。。。估计。。。写字体模块的哥们光研究怎么更好的显示字体了，没有关注接口的设计。。。。。或者，和写TabbedTextOut,ExtTextOut就是同一个人。。。。这个人很显然刚刚来微软。。。。

参数的含义不一个一个解释了，看MSDN或者《Programming Windows》，见下面一个例子，来自于《Programming Windows》。

 

/*---------------------------------------

   EZFONT.C -- Easy Font Creation

               (c) Charles Petzold, 1998

  \---------------------------------------*/

 

#include <windows.h>

#include <math.h>

#include "ezfont.h"

 

HFONT EzCreateFont (HDC hdc, TCHAR * szFaceName, int iDeciPtHeight,

                    int iDeciPtWidth, int iAttributes, BOOL fLogRes)

{

     FLOAT      cxDpi, cyDpi ;

     HFONT      hFont ;

     LOGFONT    lf ;

     POINT      pt ;

     TEXTMETRIC tm ;

    

     SaveDC (hdc) ;

    

     SetGraphicsMode (hdc, GM_ADVANCED) ;

     ModifyWorldTransform (hdc, NULL, MWT_IDENTITY) ;

     SetViewportOrgEx (hdc, 0, 0, NULL) ;

     SetWindowOrgEx   (hdc, 0, 0, NULL) ;

    

     if (fLogRes)

     {

          cxDpi = (FLOAT) GetDeviceCaps (hdc, LOGPIXELSX) ;

          cyDpi = (FLOAT) GetDeviceCaps (hdc, LOGPIXELSY) ;

     }

     else

     {

          cxDpi = (FLOAT) (25.4 * GetDeviceCaps (hdc, HORZRES) /

                                        GetDeviceCaps (hdc, HORZSIZE)) ;

         

          cyDpi = (FLOAT) (25.4 * GetDeviceCaps (hdc, VERTRES) /

                                        GetDeviceCaps (hdc, VERTSIZE)) ;

     }

    

     pt.x = (int) (iDeciPtWidth  * cxDpi / 72) ;

     pt.y = (int) (iDeciPtHeight * cyDpi / 72) ;

    

     DPtoLP (hdc, &pt, 1) ;

    

     lf.lfHeight         = - (int) (fabs (pt.y) / 10.0 + 0.5) ;

     lf.lfWidth          = 0 ;

     lf.lfEscapement     = 0 ;

     lf.lfOrientation    = 0 ;

     lf.lfWeight         = iAttributes & EZ_ATTR_BOLD      ? 700 : 0 ;

     lf.lfItalic         = iAttributes & EZ_ATTR_ITALIC    ?   1 : 0 ;

     lf.lfUnderline      = iAttributes & EZ_ATTR_UNDERLINE ?   1 : 0 ;

     lf.lfStrikeOut      = iAttributes & EZ_ATTR_STRIKEOUT ?   1 : 0 ;

     lf.lfCharSet        = DEFAULT_CHARSET ;

     lf.lfOutPrecision   = 0 ;

     lf.lfClipPrecision  = 0 ;

     lf.lfQuality        = 0 ;

     lf.lfPitchAndFamily = 0 ;

    

     lstrcpy (lf.lfFaceName, szFaceName) ;

    

     hFont = CreateFontIndirect (&lf) ;

    

     if (iDeciPtWidth != 0)

     {

          hFont = (HFONT) SelectObject (hdc, hFont) ;

         

          GetTextMetrics (hdc, &tm) ;

         

          DeleteObject (SelectObject (hdc, hFont)) ;

         

          lf.lfWidth = (int) (tm.tmAveCharWidth *

                                        fabs (pt.x) / fabs (pt.y) + 0.5) ;

         

          hFont = CreateFontIndirect (&lf) ;

     }

    

     RestoreDC (hdc, -1) ;

     return hFont ;

}

 

/*----------------------------------------

   FONTROT.C -- Rotated Fonts

                (c) Charles Petzold, 1998

  \----------------------------------------*/

 

#include <windows.h>

#include "ezfont.h"

 

TCHAR szAppName [] = TEXT ("FontRot") ;

TCHAR szTitle   [] = TEXT ("FontRot: Rotated Fonts") ;

 

void PaintRoutine (HWND hwnd, HDC hdc, int cxArea, int cyArea)

{

     static TCHAR szString [] = TEXT ("   Rotation") ;

     HFONT        hFont ;

     int          i ;

     LOGFONT      lf ;

 

     hFont = EzCreateFont (hdc, TEXT ("Times New Roman"), 540, 0, 0, TRUE) ;

     GetObject (hFont, sizeof (LOGFONT), &lf) ;

     DeleteObject (hFont) ;

 

     SetBkMode (hdc, TRANSPARENT) ;

     SetTextAlign (hdc, TA_BASELINE) ;

     SetViewportOrgEx (hdc, cxArea / 2, cyArea / 2, NULL) ;

 

     for (i = 0 ; i < 12 ; i ++)

     {

          lf.lfEscapement = lf.lfOrientation = i * 300 ;

          SelectObject (hdc, CreateFontIndirect (&lf)) ;

 

          TextOut (hdc, 0, 0, szString, lstrlen (szString)) ;

 

          DeleteObject (SelectObject (hdc, GetStockObject (SYSTEM_FONT))) ;

     }

}

 

/*------------------------------------------------

   FONTDEMO.C -- Font Demonstration Shell Program

                 (c) Charles Petzold, 1998

  \------------------------------------------------*/

 

#include <windows.h>

#include "EzFont.h"

#include "resource.h"

 

extern  void     PaintRoutine (HWND, HDC, int, int) ;

LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM) ;

 

HINSTANCE hInst ;

 

extern TCHAR szAppName [] ;

extern TCHAR szTitle [] ;

 

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,

                    PSTR szCmdLine, int iCmdShow)

{

     TCHAR    szResource [] = TEXT ("FontDemo") ;

     HWND     hwnd ;

     MSG      msg ;

     WNDCLASS wndclass ;

    

     hInst = hInstance ;

    

     wndclass.style         = CS_HREDRAW | CS_VREDRAW ;

     wndclass.lpfnWndProc   = WndProc ;

     wndclass.cbClsExtra    = 0 ;

     wndclass.cbWndExtra    = 0 ;

     wndclass.hInstance     = hInstance ;

     wndclass.hIcon         = LoadIcon (NULL, IDI_APPLICATION) ;

     wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW) ;

     wndclass.hbrBackground = (HBRUSH) GetStockObject (WHITE_BRUSH) ;

     wndclass.lpszMenuName  = szResource ;

     wndclass.lpszClassName = szAppName ;

    

     if (!RegisterClass (&wndclass))

     {

          MessageBox (NULL, TEXT ("This program requires Windows NT!"),

                      szAppName, MB_ICONERROR) ;

          return 0 ;

     }

    

     hwnd = CreateWindow (szAppName, szTitle,

                          WS_OVERLAPPEDWINDOW,

                          CW_USEDEFAULT, CW_USEDEFAULT,

                          CW_USEDEFAULT, CW_USEDEFAULT,

                          NULL, NULL, hInstance, NULL) ;

    

     ShowWindow (hwnd, iCmdShow) ;

     UpdateWindow (hwnd) ;

    

     while (GetMessage (&msg, NULL, 0, 0))

     {

          TranslateMessage (&msg) ;

          DispatchMessage (&msg) ;

     }

     return msg.wParam ;

}

 

LRESULT CALLBACK WndProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)

{

     static DOCINFO  di = { sizeof (DOCINFO), TEXT ("Font Demo: Printing") } ;

     static int      cxClient, cyClient ;

     static PRINTDLG pd = { sizeof (PRINTDLG) } ;

     BOOL            fSuccess ;

     HDC             hdc, hdcPrn ;

     int             cxPage, cyPage ;

     PAINTSTRUCT     ps ;

    

     switch (message)

     {

     case WM_COMMAND:

          switch (wParam)

          {

          case IDM_PRINT:

 

                    // Get printer DC

 

               pd.hwndOwner = hwnd ;

          pd.Flags     = PD_RETURNDC | PD_NOPAGENUMS | PD_NOSELECTION ;

 

             if (!PrintDlg (&pd))

                    return 0 ;

 

               if (NULL == (hdcPrn = pd.hDC))

               {

                    MessageBox (hwnd, TEXT ("Cannot obtain Printer DC"),

                                szAppName, MB_ICONEXCLAMATION | MB_OK) ;

                    return 0 ;

               }

                    // Get size of printable area of page

 

               cxPage = GetDeviceCaps (hdcPrn, HORZRES) ;

               cyPage = GetDeviceCaps (hdcPrn, VERTRES) ;

 

               fSuccess = FALSE ;

 

                    // Do the printer page

 

               SetCursor (LoadCursor (NULL, IDC_WAIT)) ;

               ShowCursor (TRUE) ;

 

               if ((StartDoc (hdcPrn, &di) > 0) && (StartPage (hdcPrn) > 0))

               {

                    PaintRoutine (hwnd, hdcPrn, cxPage, cyPage) ;

                   

                    if (EndPage (hdcPrn) > 0)

                    {

                         fSuccess = TRUE ;

                         EndDoc (hdcPrn) ;

                    }

               }

               DeleteDC (hdcPrn) ;

 

               ShowCursor (FALSE) ;

               SetCursor (LoadCursor (NULL, IDC_ARROW)) ;

 

               if (!fSuccess)

                    MessageBox (hwnd, 

                                TEXT ("Error encountered during printing"),

                                szAppName, MB_ICONEXCLAMATION | MB_OK) ;

               return 0 ;

 

          case IDM_ABOUT:

               MessageBox (hwnd, TEXT ("Font Demonstration Program/n")

                                 TEXT ("(c) Charles Petzold, 1998"),

                           szAppName, MB_ICONINFORMATION | MB_OK);

               return 0 ;

          }

          break ;

         

     case WM_SIZE:

          cxClient = LOWORD (lParam) ;

          cyClient = HIWORD (lParam) ;

          return 0 ;

         

     case WM_PAINT:

          hdc = BeginPaint (hwnd, &ps) ;

         

          PaintRoutine (hwnd, hdc, cxClient, cyClient) ;

         

          EndPaint (hwnd, &ps) ;

          return 0 ;

          

     case WM_DESTROY :

          PostQuitMessage (0) ;

          return 0 ;

     }

     return DefWindowProc (hwnd, message, wParam, lParam) ;

}

 

显示效果如插图2，一个显示成一圈的Rotation，用最最简单的手段实现绚烂的效果，以Small Basic中的一个星空显示文字的程序为最，这也算是比较突出的例子了。。。。

这里也不能老是抄袭Petzold。。。。。。。我将其转起来。实现旋转的动画：）

 

/*------------------------------------------------

   FONTDEMO.C -- Font Demonstration Shell Program

                 (c) 改自Charles Petzold, 1998，因为不知道其原来是啥版权，这里也不声明自己的版权了

  \------------------------------------------------*/

 

#include <windows.h>

#include "EzFont.h"

#include "resource.h"

 

extern void PaintRoutine (HWND, HDC, int, int) ;

extern void PaintAnimateOrientation(HWND hwnd, HDC hdc, int cxArea, int cyArea);

LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM) ;

 

HINSTANCE hInst ;

 

 

extern TCHAR szAppName [] ;

extern TCHAR szTitle [] ;

 

#define WND_WIDTH (800)

#define WND_HEIGHT (800)

 

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,

                    PSTR szCmdLine, int iCmdShow)

{

   TCHAR    szResource [] = TEXT ("FontDemo") ;

   HWND     hwnd ;

   MSG      msg ;

   WNDCLASS wndclass ;

   HDC hdc ;

 

   hInst = hInstance ;

 

   wndclass.style         = CS_HREDRAW | CS_VREDRAW ;

   wndclass.lpfnWndProc   = WndProc ;

   wndclass.cbClsExtra    = 0 ;

   wndclass.cbWndExtra    = 0 ;

   wndclass.hInstance     = hInstance ;

   wndclass.hIcon         = LoadIcon (NULL, IDI_APPLICATION) ;

   wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW) ;

   wndclass.hbrBackground = (HBRUSH) GetStockObject (WHITE_BRUSH) ;

   wndclass.lpszMenuName  = szResource ;

   wndclass.lpszClassName = szAppName ;

 

   if (!RegisterClass (&wndclass))

   {

      MessageBox (NULL, TEXT ("This program requires Windows NT!"),

        szAppName, MB_ICONERROR) ;

      return 0 ;

   }

 

   hwnd = CreateWindow (szAppName, szTitle,

      WS_OVERLAPPEDWINDOW,

      CW_USEDEFAULT, CW_USEDEFAULT,

      WND_WIDTH, WND_HEIGHT,

      NULL, NULL, hInstance, NULL) ;

 

   ShowWindow (hwnd, iCmdShow) ;

   UpdateWindow (hwnd) ;

 

 

 

 

   while (TRUE)

   {

      // 就像游戏中一贯的做法

      if(PeekMessage (&msg, NULL, 0, 0, PM_REMOVE))

      {

        if(msg.message == WM_QUIT)

        {

           break;

        }

 

        TranslateMessage (&msg);

        DispatchMessage (&msg);

      }

 

      hdc = GetDC(hwnd);

 

      PaintAnimateOrientation(hwnd, hdc, WND_WIDTH, WND_HEIGHT);

 

      ReleaseDC(hwnd, hdc);

   }

   return msg.wParam ;

}

 

LRESULT CALLBACK WndProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)

{

     static DOCINFO  di = { sizeof (DOCINFO), TEXT ("Font Demo: Printing") } ;

     static int      cxClient, cyClient ;

     static PRINTDLG pd = { sizeof (PRINTDLG) } ;

     BOOL            fSuccess ;

     HDC             hdc, hdcPrn ;

     int             cxPage, cyPage ;

     PAINTSTRUCT     ps ;

    

     switch (message)

     {

     case WM_COMMAND:

          switch (wParam)

          {

          case IDM_PRINT:

 

                    // Get printer DC

 

               pd.hwndOwner = hwnd ;

          pd.Flags     = PD_RETURNDC | PD_NOPAGENUMS | PD_NOSELECTION ;

 

             if (!PrintDlg (&pd))

                    return 0 ;

 

               if (NULL == (hdcPrn = pd.hDC))

               {

                    MessageBox (hwnd, TEXT ("Cannot obtain Printer DC"),

                                szAppName, MB_ICONEXCLAMATION | MB_OK) ;

                    return 0 ;

               }

                    // Get size of printable area of page

 

               cxPage = GetDeviceCaps (hdcPrn, HORZRES) ;

               cyPage = GetDeviceCaps (hdcPrn, VERTRES) ;

 

               fSuccess = FALSE ;

 

                    // Do the printer page

 

               SetCursor (LoadCursor (NULL, IDC_WAIT)) ;

               ShowCursor (TRUE) ;

 

               if ((StartDoc (hdcPrn, &di) > 0) && (StartPage (hdcPrn) > 0))

               {

                    PaintRoutine (hwnd, hdcPrn, cxPage, cyPage) ;

                   

                    if (EndPage (hdcPrn) > 0)

                    {

                         fSuccess = TRUE ;

                         EndDoc (hdcPrn) ;

                    }

               }

               DeleteDC (hdcPrn) ;

 

               ShowCursor (FALSE) ;

               SetCursor (LoadCursor (NULL, IDC_ARROW)) ;

 

               if (!fSuccess)

                    MessageBox (hwnd, 

                                TEXT ("Error encountered during printing"),

                                szAppName, MB_ICONEXCLAMATION | MB_OK) ;

               return 0 ;

 

          case IDM_ABOUT:

               MessageBox (hwnd, TEXT ("Font Demonstration Program/n")

                                 TEXT ("(c) Charles Petzold, 1998"),

                           szAppName, MB_ICONINFORMATION | MB_OK);

               return 0 ;

          }

          break ;

         

     case WM_SIZE:

          cxClient = LOWORD (lParam) ;

          cyClient = HIWORD (lParam) ;

          return 0 ;

          

     case WM_PAINT:

          hdc = BeginPaint (hwnd, &ps) ;

         

         

          EndPaint (hwnd, &ps) ;

          return 0 ;

     case WM_DESTROY :

          PostQuitMessage (0) ;

          return 0 ;

     }

     return DefWindowProc (hwnd, message, wParam, lParam) ;

}

 

/*----------------------------------------

   FONTROT.C -- Rotated Fonts

                (c) 改自Charles Petzold, 1998

  \----------------------------------------*/

 

#include <windows.h>

#include <tchar.h>

#include "ezfont.h"

 

TCHAR szAppName [] = TEXT ("FontRot") ;

TCHAR szTitle   [] = TEXT ("FontRot: Rotated Fonts") ;

#define FRAME_PER_SECOND (20)

#define TIME_IN_FRAME (1000/FRAME_PER_SECOND)

 

#define WHITE_COLOR (RGB(255,255,255))

#define BLACK_COLOR (RGB(0,0,0))

void PaintRoutine (HWND hwnd, HDC hdc, int cxArea, int cyArea, int iAnimateOrientation)

{

   static TCHAR szString [] = TEXT ("   Rotation") ;

   HFONT        hFont ;

   int          i ;

   LOGFONT      lf ;

 

 

   hFont = EzCreateFont (hdc, TEXT ("Times New Roman"), 540, 0, 0, TRUE) ;

   GetObject (hFont, sizeof (LOGFONT), &lf) ;

   DeleteObject (hFont) ;

 

   SetBkMode (hdc, TRANSPARENT) ;

   SetTextAlign (hdc, TA_BASELINE) ;

   SetViewportOrgEx (hdc, cxArea / 2, cyArea / 2, NULL) ;

 

  

 

   SetTextColor(hdc, WHITE_COLOR);

   for (i = 0 ; i < 12 ; i++)

   {

      lf.lfEscapement = lf.lfOrientation = i * 300 + iAnimateOrientation-1;

      SelectObject (hdc, CreateFontIndirect (&lf)) ;

 

      TextOut (hdc, 0, 0, szString, lstrlen (szString)) ;

 

      DeleteObject (SelectObject (hdc, GetStockObject (SYSTEM_FONT))) ;

   }

 

 

   SetTextColor(hdc, BLACK_COLOR);

   for (i = 0 ; i < 12 ; i++)

   {

      lf.lfEscapement = lf.lfOrientation = i * 300 + iAnimateOrientation;

      SelectObject (hdc, CreateFontIndirect (&lf)) ;

 

      TextOut (hdc, 0, 0, szString, lstrlen (szString)) ;

 

      DeleteObject (SelectObject (hdc, GetStockObject (SYSTEM_FONT))) ;

   }

 

 

}

 

// By 九天雁翎：

// 主要的新添函数

void PaintAnimateOrientation(HWND hwnd, HDC hdc, int cxArea, int cyArea)

{

   DWORD dwStartTime;

   DWORD dwEndTime;

   DWORD dwInTime;

   int iIntervalTimeNeed ;

   static int iAnimateOrientation = 0;

 

   dwStartTime = GetTickCount();

 

 

   iAnimateOrientation += 1;

 

   PaintRoutine(hwnd, hdc, cxArea, cyArea, iAnimateOrientation);

// 帧数控制

   while(GetTickCount() - dwStartTime < TIME_IN_FRAME)

   {

      Sleep(1);

   }

 

}

 

其实目前的源代码中有个瑕疵，因为是用透明文字背景画图，用白色的文字覆盖原有文字的时候会出现一些覆盖不了的情况，这个情况导致文字转动后会留有一些背景的尾巴。。。。效果如插图3了，另外。。。之所以使用此种循环画图方式纯粹因为最近看了《Window游戏编程大师级技巧》一书，其实用纯timer的方式实现如此简单的动画应该也是可行的，并且因为可以依赖消息机制的背景刷新，就不会有此问题。见下面的改良版旋转文字动画：

将SetBkMode (hdc, TRANSPARENT) ;一句改为SetBkMode (hdc, OPAQUE) ;倒是可以解决这个问题，但是因为背景的不透明，中间R重合的部分会导致互相的遮掩，这点没有深入研究了，希望有人能给出更好的解决方案。另外，因为是使用GDI，所以在每秒20帧重画的时候都会有闪烁。。。。。

 

改良版旋转文字动画：

/*------------------------------------------------

   FONTDEMO.C -- Font Demonstration Shell Program

                 (c) 改自Charles Petzold, 1998

  \------------------------------------------------*/

 

#include <windows.h>

#include "EzFont.h"

#include "resource.h"

 

void PaintRoutine (HWND hwnd, HDC hdc, int cxArea, int cyArea, int iAnimateOrientation);

LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM) ;

 

HINSTANCE hInst ;

 

 

extern TCHAR szAppName [] ;

extern TCHAR szTitle [] ;

 

#define WND_WIDTH (800)

#define WND_HEIGHT (800)

 

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,

                    PSTR szCmdLine, int iCmdShow)

{

   TCHAR    szResource [] = TEXT ("FontDemo") ;

   HWND     hwnd ;

   MSG      msg ;

   WNDCLASS wndclass ;

   HDC hdc ;

 

   hInst = hInstance ;

 

   wndclass.style         = CS_HREDRAW | CS_VREDRAW ;

   wndclass.lpfnWndProc   = WndProc ;

   wndclass.cbClsExtra    = 0 ;

   wndclass.cbWndExtra    = 0 ;

   wndclass.hInstance     = hInstance ;

   wndclass.hIcon         = LoadIcon (NULL, IDI_APPLICATION) ;

   wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW) ;

   wndclass.hbrBackground = (HBRUSH) GetStockObject (WHITE_BRUSH) ;

   wndclass.lpszMenuName  = szResource ;

   wndclass.lpszClassName = szAppName ;

 

   if (!RegisterClass (&wndclass))

   {

      MessageBox (NULL, TEXT ("This program requires Windows NT!"),

        szAppName, MB_ICONERROR) ;

      return 0 ;

   }

 

   hwnd = CreateWindow (szAppName, szTitle,

      WS_OVERLAPPEDWINDOW,

      CW_USEDEFAULT, CW_USEDEFAULT,

      WND_WIDTH, WND_HEIGHT,

      NULL, NULL, hInstance, NULL) ;

 

   ShowWindow (hwnd, iCmdShow) ;

   UpdateWindow (hwnd) ;

 

   SetTimer(hwnd, 1, 50, NULL);

   // 主消息循环:

   while (GetMessage(&msg, NULL, 0, 0))

   {

      TranslateMessage(&msg);

      DispatchMessage(&msg);

   }

 

   return msg.wParam ;

}

 

LRESULT CALLBACK WndProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)

{

   static DOCINFO  di = { sizeof (DOCINFO), TEXT ("Font Demo: Printing") } ;

   static int      cxClient, cyClient ;

   static PRINTDLG pd = { sizeof (PRINTDLG) } ;

   BOOL            fSuccess ;

   HDC             hdc, hdcPrn ;

   int             cxPage, cyPage ;

   PAINTSTRUCT     ps ;

   static int iAnimateOrientation = 0;

 

   switch (message)

   {

   case WM_COMMAND:

      switch (wParam)

      {

      case IDM_PRINT:

 

        // Get printer DC

 

        pd.hwndOwner = hwnd ;

        pd.Flags     = PD_RETURNDC | PD_NOPAGENUMS | PD_NOSELECTION ;

 

        if (!PrintDlg (&pd))

           return 0 ;

 

        if (NULL == (hdcPrn = pd.hDC))

        {

           MessageBox (hwnd, TEXT ("Cannot obtain Printer DC"),

              szAppName, MB_ICONEXCLAMATION | MB_OK) ;

           return 0 ;

        }

        // Get size of printable area of page

 

        cxPage = GetDeviceCaps (hdcPrn, HORZRES) ;

        cyPage = GetDeviceCaps (hdcPrn, VERTRES) ;

 

         fSuccess = FALSE ;

 

        // Do the printer page

 

        SetCursor (LoadCursor (NULL, IDC_WAIT)) ;

        ShowCursor (TRUE) ;

 

        if ((StartDoc (hdcPrn, &di) > 0) && (StartPage (hdcPrn) > 0))

        {

           PaintRoutine (hwnd, hdcPrn, cxPage, cyPage, iAnimateOrientation) ;

 

           if (EndPage (hdcPrn) > 0)

           {

              fSuccess = TRUE ;

              EndDoc (hdcPrn) ;

           }

        }

        DeleteDC (hdcPrn) ;

 

        ShowCursor (FALSE) ;

        SetCursor (LoadCursor (NULL, IDC_ARROW)) ;

 

        if (!fSuccess)

           MessageBox (hwnd, 

           TEXT ("Error encountered during printing"),

           szAppName, MB_ICONEXCLAMATION | MB_OK) ;

        return 0 ;

 

      case IDM_ABOUT:

        MessageBox (hwnd, TEXT ("Font Demonstration Program/n")

           TEXT ("(c) Charles Petzold, 1998"),

           szAppName, MB_ICONINFORMATION | MB_OK);

        return 0 ;

      }

      break ;

 

   case WM_SIZE:

      cxClient = LOWORD (lParam) ;

      cyClient = HIWORD (lParam) ;

      return 0 ;

 

   case WM_PAINT:

      hdc = BeginPaint (hwnd, &ps) ;

 

      PaintRoutine(hwnd, hdc, WND_WIDTH, WND_HEIGHT, iAnimateOrientation);

 

      EndPaint (hwnd, &ps) ;

      return 0 ;

   case WM_TIMER:

      {

        iAnimateOrientation += 1;

        InvalidateRect(hwnd, NULL, TRUE);

        return 0;

      }

 

   case WM_DESTROY :

      PostQuitMessage (0) ;

      return 0 ;

   }

   return DefWindowProc (hwnd, message, wParam, lParam) ;

}

 

#define BLACK_COLOR (RGB(0,0,0))

TCHAR szAppName [] = TEXT ("FontRot") ;

TCHAR szTitle   [] = TEXT ("FontRot: Rotated Fonts") ;

void PaintRoutine (HWND hwnd, HDC hdc, int cxArea, int cyArea, int iAnimateOrientation)

{

   static TCHAR szString [] = TEXT ("   Rotation") ;

   HFONT        hFont ;

   int          i ;

   LOGFONT      lf ;

 

 

   hFont = EzCreateFont (hdc, TEXT ("Times New Roman"), 540, 0, 0, TRUE) ;

   GetObject (hFont, sizeof (LOGFONT), &lf) ;

   DeleteObject (hFont) ;

 

   SetBkMode (hdc, TRANSPARENT) ;

   SetTextAlign (hdc, TA_BASELINE) ;

   SetViewportOrgEx (hdc, cxArea / 2, cyArea / 2, NULL) ;

 

   SetTextColor(hdc, BLACK_COLOR);

   for (i = 0 ; i < 12 ; i++)

   {

      lf.lfEscapement = lf.lfOrientation = i * 300 + iAnimateOrientation;

      SelectObject (hdc, CreateFontIndirect (&lf)) ;

 

      TextOut (hdc, 0, 0, szString, lstrlen (szString)) ;

 

      DeleteObject (SelectObject (hdc, GetStockObject (SYSTEM_FONT))) ;

   }

 

 

}

注意几个改动的地方，其实这个版本应该是最先的思路。。。。。。及利用Timer及Windows消息机制来完成动画绘制，这样可以利用背景擦除消息来擦除背景，不需要重新自己用白色文字覆盖上一帧的文字，也不会有拖尾现象，但是，因为总是重复擦除然后重绘，所以会有闪烁。

 

另外，从理论上来说，直接将绘制放在擦除背景消息中，如下：

   case WM_PAINT:

      hdc = BeginPaint (hwnd, &ps) ;

 

      EndPaint (hwnd, &ps) ;

      return 0 ;

   case WM_ERASEBKGND:

      hdc = GetDC(hwnd);

      Rectangle(hdc, 0, 0, WND_WIDTH, WND_HEIGHT);

      PaintRoutine(hwnd, hdc, WND_WIDTH, WND_HEIGHT, iAnimateOrientation);

      ReleaseDC(hwnd, hdc);

      return 0;

闪烁会小一点，因为擦除背景到重新绘制的间隔更短了（放在WM_PAINT中还有个重新分配消息的过程），但是事实上看不怎么出来。

随机文字的那个例子比较简单，这里不再实现了。

 

# 五、   参考：

1\. 《Windows 图形编程》第14，15章（原版名《Windows Graphics Programming Win32 GDI and DirectDraw》，Feng Yuan著，机械工业出版社

2.《Programming Windows》 Fifth Edition，Chapter4,17 Charles Petzold著，Microsoft Press

 

 

 

插图1： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082609_1556_11.jpg)

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082609_1556_12.jpg)

 

插图3： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_082609_1556_13.jpg)

 

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)
