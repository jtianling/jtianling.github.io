---
layout: post
title: Windows中多指针输入技术的实现与应用(10 双鼠标五子棋源代码 全系列完)
categories:
- "我的程序"
tags:
- Windows
- "多鼠标"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

分享双鼠标五子棋源码，演示多鼠标实现，并解释因工作繁忙而暂停相关研究。

<!-- more -->

这是突然看到才想起来发的，发到我常用的地址中：

http://groups.google.com/group/jiutianfile

那时候带着笔记本，台式机上的源码都发不了，直到现在才想起来：）

很多朋友发邮件或者在博客中问过我为什么没有继续对多鼠标这个东西研究下去，呵呵，在此一并答复了，本人实在是工作忙啊。。。。。。。再次说明一下什么叫 忙，每天工作12个小时以上，每周工作6天，再加上你看看我最近学的东西，lua,python,bash....实在没有时间了，呵呵

那个地方现在有两个五子棋的源码了，一个是单鼠标用左右键来玩的，一个是双鼠标都用左键来玩的。你可以对比一下，看看实现多鼠标需要添加些什么，呵呵，其实也不多，这个示例程序虽然简单，但是却实现了想要的基本功能。

图我也贴一个，不偷懒了。。。。呵呵，毕竟这也算是我以前研究比较久的成果。

展示一下：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081123/gobang1.jpg)

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081123/gobang2.jpg)

```cpp
class CMyApp : public CWinApp

{

public:

    virtual BOOL  
InitInstance();

};

 

class CMainWindow : public CMultiMouseWindow

{

protected:

    enum gridState  
{ Unputed, PutedWhite,  
PutedBlack};   //enum格子的个状态

    enum Turn  
{blackTurn,whiteTurn};   //enum轮到谁下的状态

    enum winnerLast  
{NoOne,WhiteWin,BlackWin};    //enum有没有胜利者的状态

    Turn m_nextTurn;  //下轮执棋者

    const static  
int nClientSize  
= 700;    //客户区大小，可改变

    const static  
int nGridNum  
= 20;    //格数，可改变

    int m_countStep;  //目前所下步数

    void DrawBoard(CDC &dc); //画棋盘

    CRect m_rcGrid[nGridNum][nGridNum];    //棋盘的每个格子的矩形范围

    gridState m_stateGrid[nGridNum][nGridNum];    //棋盘每个格子的状态

    void DrawWhite(CDC &dc,int i,int j);   //下White

    void DrawBlack(CDC &dc,int i,int j);   //下Black

    void ResetGame(); //重新开始游戏

    void CheckForGameOver(Turn thisTurn,int i,int j); //查找需不需要结束游戏

    BOOL IsWinner(Turn thisTurn,int i,int j); //是否有胜利者

    BOOL IsDraw();    //是否平局

 

public:

    CMainWindow();

protected:

    afx_msg void OnPaint();

    afx_msg void OnLButtonDown(UINT nFlags,CPoint point);

    afx_msg void OnNcLButtonDblClk(UINT nHitTest,CPoint point);

    DECLARE_MESSAGE_MAP()

};
```

```cpp
#include <afxwin.h>

#include <cmath>

#include <memory>

#include "MultiMouseWindow.h"

#include "resource.h"

#include "gobang.h"

 

CMyApp myApp;

//

//CMyApp的成员函数

//

BOOL CMyApp::InitInstance()

{

    m_pMainWnd = new CMainWindow;

    m_pMainWnd->ShowWindow(m_nCmdShow);

    m_pMainWnd->UpdateWindow();

    return TRUE;

}

//

//CMainWindow的消息映射和成员函数定义

//

BEGIN_MESSAGE_MAP(CMainWindow,CFrameWnd)

    ON_WM_PAINT()

    ON_WM_LBUTTONDOWN()

    ON_WM_NCLBUTTONDBLCLK()

END_MESSAGE_MAP()

 

 

CMainWindow::CMainWindow()

{

    //执黑的先下棋，并定下窗口固定宽度

    CString wndClassStr = ::AfxRegisterWndClass(CS_DBLCLKS);

    Create(wndClassStr,_T("两鼠标五子棋by九天雁翎       (双击标题栏重新开始游戏）"),

       WS_OVERLAPPED | WS_SYSMENU | WS_CAPTION  
| WS_MINIMIZEBOX);

    CRect rect(0,0,nClientSize+2,nClientSize+2);

    CalcWindowRect(&rect);

    SetWindowPos(NULL,0,0,rect.Width(),rect.Height(),

       SWP_NOZORDER | SWP_NOMOVE | SWP_NOREDRAW);

    m_hiconCursor[1] = LoadIcon(AfxGetInstanceHandle(),MAKEINTRESOURCE(IDI_CURSOR));

    m_hiconCursor[2] = LoadIcon(AfxGetInstanceHandle(),MAKEINTRESOURCE(IDI_CURSOR2));

    //初始化自定义的成员变量

    m_nextTurn = whiteTurn;

    m_countStep = 0;

   

    if(m_nMouseNumber  
!= 3)

    {

       MessageBox(_T("请插入个鼠标"));

       PostQuitMessage (0);

 

    }

    ::ZeroMemory(m_rcGrid,nGridNum  
* nGridNum * sizeof(CRect));

    ::ZeroMemory(m_stateGrid,nGridNum  
* nGridNum * sizeof(gridState));

   

 

 

 

}

 

void CMainWindow::OnPaint()

{

    CPaintDC dc(this);

    DrawBoard(dc);

    DrawMultiCursor();

}

 

void CMainWindow::DrawBoard(CDC  
&dc)

{

    CRect rect;

    GetClientRect(&rect);

 

    //画背景

    CBrush brush(RGB(198,130,66));

    dc.FillRect(rect,&brush);

 

//开始画纵横线，利用rect大小来画线，一是代码重用度高，二是以前做好了

//效率稍微低点，不过将来要是改变客户区大小或用可缩放窗口就可以不改了

   

    //定义画线的画笔并选中

    CPen pen(PS_SOLID,2,RGB(0,0,0));

    CPen *pOldPen  
= dc.SelectObject(&pen);

 

    //求方格宽高

    int nGridWidth  
= nClientSize / nGridNum  ; 

    int nGridHeight  
= nClientSize / nGridNum  
;

   

 

    //计算每个方格矩形范围

    for(int  
i = 0; i  
< nGridNum; ++i)

       for(int  
j = 0; j  
< nGridNum; ++j)

       {

           m_rcGrid[i][j] = CRect(rect.left \+ (nGridWidth  
* j),

                               rect.top \+ (nGridHeight * i),

                               rect.left \+ nGridWidth +(nGridWidth  
* j),

                               rect.top \+ nGridHeight \+ (nGridHeight  
* i));

       }

 

 

    for(int  
i = 0; i  
<= nGridNum; ++i)   //画横线

    {

       int y  
= (nGridHeight * i)  
\+ rect.top;

       dc.MoveTo(rect.left,y);

       dc.LineTo(rect.right,y);

    }

 

    for(int  
i = 0; i  
<= nGridNum; ++i)   //画竖线

    {

       int x  
= (nGridWidth * i)  
\+ rect.left;

       dc.MoveTo(x,rect.top);

       dc.LineTo(x,rect.bottom);

    }

 

    //画下已经下好的棋

 

    for(int  
i=0; i<nGridNum; ++i)

       for(int  
j=0; j<nGridNum; ++j)

       {

           if(m_stateGrid[i][j] == Unputed)

           {

              continue;

           }

           else if(m_stateGrid[i][j] == PutedWhite)

           {

              DrawWhite(dc,i,j);

           }

           else if(m_stateGrid[i][j] == PutedBlack)

           {

              DrawBlack(dc,i,j);

           }

       }

 

}

 

//左键下黑

void CMainWindow::OnLButtonDown(UINT  
nFlags, CPoint  
point)

{

    if(m_pSiRawMouse[1].usButtonFlags & RI_MOUSE_LEFT_BUTTON_DOWN)

    {

           //若本轮不属黑，即不响应

       if(m_nextTurn  
!= blackTurn)

           return;

       for(int  
i = 0; i<nGridNum; ++i)

           for(int j = 0; j<nGridNum;  
++j)

           {

              CPoint pt(m_pSiRawMouse[1].X,m_pSiRawMouse[1].Y);

              ScreenToClient(&pt);

              if(m_rcGrid[i][j].PtInRect(pt) && m_stateGrid[i][j] == Unputed)

              {

                  CClientDC dc(this);

                  m_nextTurn = whiteTurn;

                  m_stateGrid[i][j] = PutedBlack;

                  DrawBlack(dc,i,j);

                  CheckForGameOver(blackTurn,i,j);

              }

           }

      

       m_pSiRawMouse[1].usButtonFlags &= ~RI_MOUSE_LEFT_BUTTON_DOWN;

 

    }

    if(m_pSiRawMouse[2].usButtonFlags & RI_MOUSE_LEFT_BUTTON_DOWN)

    {

           //若本轮不属白，即不响应

       if(m_nextTurn  
!= whiteTurn)

           return;

       for(int  
i = 0; i<nGridNum; ++i)

           for(int j = 0; j<nGridNum;  
++j)

           {

              CPoint pt(m_pSiRawMouse[2].X,m_pSiRawMouse[2].Y);

              ScreenToClient(&pt);

              if(m_rcGrid[i][j].PtInRect(pt) && m_stateGrid[i][j] == Unputed)

              {

                  CClientDC dc(this);

                  m_nextTurn = blackTurn;

                  m_stateGrid[i][j] = PutedWhite;

                  DrawWhite(dc,i,j);

                  ++m_countStep;

                  CheckForGameOver(whiteTurn,i,j);

              }

           }

      

       m_pSiRawMouse[2].usButtonFlags &= ~RI_MOUSE_LEFT_BUTTON_DOWN;

    }

 

}

 

void CMainWindow::DrawBlack(CDC  
&dc, int  
i, int j)

{

    CRect rect(m_rcGrid[i][j]);

    rect.DeflateRect(1,1);

    dc.SelectStockObject(BLACK_BRUSH);

    dc.Ellipse(rect);

}

 

void CMainWindow::DrawWhite(CDC  
&dc, int  
i, int j)

{

    CRect rect(m_rcGrid[i][j]);

    rect.DeflateRect(1,1);

    dc.SelectStockObject(WHITE_BRUSH);

    dc.Ellipse(rect);

 

}

 

void CMainWindow::CheckForGameOver(Turn  
thisTurn,int  
i,int j)

{

    if(IsWinner(thisTurn,i,j))

    {

       if(thisTurn  
== blackTurn)

       {

           CString string;

           string.Format(_T("GOOD! Black Wins in %d steps."),m_countStep);

           MessageBox(string,_T("Game Over!"));

           ResetGame();

       }

       else if(thisTurn == whiteTurn)

       {

           CString string;

           string.Format(_T("GOOD! White Wins in %d steps."),m_countStep);

           MessageBox(string,_T("Game Over!"));

           ResetGame();

       }

      

    }

    else if(IsDraw())

    {

       MessageBox(_T("OK,It's  
draw."),_T("Draw Game!"));

       ResetGame();

    }

 

}

 

//此为本软件最主要的部分，即检测是否有五个棋连在一起

//以横纵和两条对角线的方向分别检测，感觉比较笨

//暂时不知道有没有更好的办法，望来信赐教

BOOL CMainWindow::IsWinner(Turn thisTurn,int i,int j)

{

    int count  
= 1;

    gridState checkFor; //状态对比值

    if(thisTurn  
== blackTurn)

       checkFor = PutedBlack;

    else if(thisTurn == whiteTurn)

       checkFor = PutedWhite;

 

    //横方向检测

    for(int  
m=1; m<5;  
++m)

    {

       if(j  
\- m > 0 && m_stateGrid[i][j-m] == checkFor)

           ++count;

       else

           break;

    }

    for(int  
m=1; m<5;  
++m)

    {

       if(j  
\+ m < nGridNum  
&& m_stateGrid[i][j+m] == checkFor)

           ++count;

       else

           break;

    }

    if(count  
>=5)

       return TRUE;

    count = 1;

 

    //竖方向检测

    for(int  
m=1; m<5;  
++m)

    {

       if(i-m>0 && m_stateGrid[i-m][j] == checkFor)

           ++count;

       else

           break;

    }

    for(int  
m=1; m<5;  
++m)

    {

       if(i+m<nGridNum  
&& m_stateGrid[i+m][j] == checkFor)

           ++count;

       else

           break;

    }

    if(count  
>=5)

       return TRUE;

    count = 1;

 

    //左上至右下方向检测

    for(int  
m=1; m<5;  
++m)

    {

       if(i-m>0 && j-m>0 && m_stateGrid[i-m][j-m] == checkFor)

           ++count;

       else

           break;

    }

    for(int  
m=1; m<5;  
++m)

    {

       if(i+m<nGridNum  
&& j+m<nGridNum && m_stateGrid[i+m][j+j] == checkFor)

           ++count;

       else

           break;

    }

    if(count  
>=5)

       return TRUE;

    count = 1;

 

    //右上至左下方向检测

    for(int  
m=1; m<5;  
++m)

    {

       if(i-m>0 && j+m<nGridNum  
&& m_stateGrid[i-m][j+m] == checkFor)

           ++count;

       else

           break;

    }

    for(int  
m=1; m<5;  
++m)

    {

       if(i+m<nGridNum  
&& j-m>0  
&& m_stateGrid[i+m][j-m] == checkFor)

           ++count;

       else

           break;

    }

    if(count  
>=5)

       return TRUE;

    return FALSE;

}

 

//BOOL  
CMainWindow::OnSetCursor(CWnd *pWnd, UINT nHitTest, UINT message)

//{

//  if(nHitTest == HTCLIENT)

//  {

//     if(m_nextTurn == blackTurn)

//     {

//         ::SetCursor(::AfxGetApp()->LoadCursor(IDC_black));

//         return TRUE;

//     }

//     else if(m_nextTurn == whiteTurn)

//     {

//         ::SetCursor(::AfxGetApp()->LoadCursor(IDC_white));

//         return TRUE;

//     }

//  }

//  return  
CFrameWnd::OnSetCursor(pWnd,nHitTest,message);

//}

 

//当都下满了，即为平局

BOOL CMainWindow::IsDraw()

{

    int i,j;

    for(i=0;  
i<nGridNum;  
++i)

       for(j=0;  
j<nGridNum;  
++j)

       {

           if(m_stateGrid[i][j]==Unputed)

              break;

       }

    if(i==nGridNum && j==nGridNum)

       return TRUE;

    else

       return FALSE;

}

 

void CMainWindow::ResetGame()

{

    m_nextTurn = whiteTurn;

    m_countStep = 0;

    ::ZeroMemory(m_stateGrid,nGridNum  
* nGridNum * sizeof(gridState));

    Invalidate();

}

 

void CMainWindow::OnNcLButtonDblClk(UINT  
nHitTest, CPoint  
point)

{

    if(nHitTest  
== HTCAPTION)

    {

       ResetGame();

    }

 

    return CFrameWnd::OnNcLButtonDblClk(nHitTest,point);

}  
```

```cpp
#ifndef ___MULTI_MOUSE_WINDOW_H__

#define ___MULTI_MOUSE_WINDOW_H__

 

class CMultiMouseWindow :  
public CFrameWnd

{

typedef struct SiRawMouse

{

    long X;

    long Y;

    USHORT usButtonFlags;

    HANDLE hDevice;

}SiRawMouse,*pSiRawMouse;       //输入设备鼠标的自定义类型数组

 

//判定是否为系统鼠标的函数

private:

    void InitRawInput();

    bool IsRootMouse(TCHAR cDeviceString[]);

    void CheckBound(long &x,long &y);

protected:

    pSiRawMouse m_pSiRawMouse;

    TCHAR m_mousePostion[256];  // 鼠标位置缓存

    HICON  m_hiconCursor[10];  
//绘制的鼠标

    int m_nMouseNumber;  
//鼠标数量

    void DrawMultiCursor();

public:

    CMultiMouseWindow();

protected:

    DECLARE_MESSAGE_MAP()

public:

 

protected:

    virtual LRESULT  
WindowProc(UINT  
message, WPARAM  
wParam, LPARAM  
lParam);

public:

    afx_msg void OnDestroy();

};

 

 

#endif // ___MULTI_MOUSE_WINDOW_H__
```

```cpp
#include <afxwin.h>

#include <cmath>

#include "MultiMouseWindow.h"

#include "resource.h"

#include <Windows.h>

 

 

BEGIN_MESSAGE_MAP(CMultiMouseWindow,CFrameWnd)

    ON_WM_DESTROY()

END_MESSAGE_MAP()

 

 

CMultiMouseWindow::CMultiMouseWindow():m_nMouseNumber(0)

{

    Create(NULL,_T("Hello"),WS_OVERLAPPEDWINDOW);

    for(int  
i=0; i  
< 10; ++i)

    {

       m_hiconCursor[i]  = LoadIcon(AfxGetInstanceHandle(),MAKEINTRESOURCE(IDI_CURSOR));

    }

    ShowCursor(false);

    InitRawInput();  

}

 

void CMultiMouseWindow::InitRawInput()

{

    UINT nDevices;       //输入设备的数量

 

    //第一次调用GetRawInputDeviceList获得输入设备的数量

    GetRawInputDeviceList(NULL, &nDevices,  
sizeof(RAWINPUTDEVICELIST));

    //第二次调用GetRawInputDeviceList获得RawInputDeviceList数组

    PRAWINPUTDEVICELIST pRawInputDeviceList;// =  
new RAWINPUTDEVICELIST[nDevices];

    pRawInputDeviceList = (RAWINPUTDEVICELIST *)calloc(nDevices,sizeof(RAWINPUTDEVICELIST));

    GetRawInputDeviceList(pRawInputDeviceList, &nDevices,  
sizeof(RAWINPUTDEVICELIST));

 

    //获得输入设备中鼠标的数量

    for(int  
i=0; i  
< static_cast<int>(nDevices); ++i)

    {

       if(pRawInputDeviceList[i].dwType == RIM_TYPEMOUSE)

       {

           ++m_nMouseNumber;

       }

    }

   

    //获得输入设备鼠标的自定义类型数组，其中索引为的为系统鼠标

    m_pSiRawMouse = (SiRawMouse *)calloc(m_nMouseNumber,sizeof(SiRawMouse));

    LPVOID lpb;

    UINT dwSize;

 

    for(int  
i=0,j=1; i < static_cast<int>(nDevices)  
&& j < m_nMouseNumber;  
++i)

    {

       if(pRawInputDeviceList[i].dwType == RIM_TYPEMOUSE)

       {

           //连续两次调用GetRawInputDeviceInfo以读取RIDI_DEVICENAME

           //并通过此值判断是否为系统鼠标

           GetRawInputDeviceInfo(pRawInputDeviceList[i].hDevice,RIDI_DEVICENAME,NULL,&dwSize);

           lpb = malloc(sizeof(LPVOID) * dwSize);

           GetRawInputDeviceInfo(pRawInputDeviceList[i].hDevice,RIDI_DEVICENAME,lpb,&dwSize);

           TCHAR *deviceName = (TCHAR*)lpb;

          

           //将系统鼠标的保存在索引中，其他依次列在后面

           if(IsRootMouse(deviceName))

           {

              m_pSiRawMouse[0].hDevice = pRawInputDeviceList[i].hDevice;

              m_pSiRawMouse[0].X = 0;

              m_pSiRawMouse[0].Y = 0;

              m_pSiRawMouse[0].usButtonFlags = 0;

           }

           else

           {

              m_pSiRawMouse[j].hDevice = pRawInputDeviceList[i].hDevice;

              m_pSiRawMouse[j].X = 0;

              m_pSiRawMouse[j].Y = 0;

              m_pSiRawMouse[j].usButtonFlags  
= 0;

              ++j;

           }

           free(lpb);

       }

    }

 

    free(pRawInputDeviceList);

    pRawInputDeviceList = NULL;

 

    //初始化个RawInput设备

    RAWINPUTDEVICE Rid[1]; //分配RawInput设备的空间

    Rid[0].usUsagePage = 0x01; 

    Rid[0].usUsage = 0x02; 

    Rid[0].dwFlags = 0;

    Rid[0].hwndTarget = NULL;

   

    //注册RawInput设备

    if (RegisterRawInputDevices(Rid, 1, sizeof (Rid [0])) == FALSE)  
{

       MessageBox(_T("RawInput  
Register Error."));

    }

 

    return ;

}

bool CMultiMouseWindow::IsRootMouse(TCHAR  
cDeviceString[])

{

    //一般系统鼠标DeviceName的前字节

    TCHAR cRootString[]  
= _T("//??//Root#RDP_MOU#0000#");

   

    //通过比较前个字节判断是否为系统鼠标

    if (wcslen(cDeviceString) < 22) 

    {

       return false;

    }

    for (int  
i = 0; i  
< 22; i++) 

    {

       if (cRootString[i] != cDeviceString[i]) 

       {

       return false;

       }

    }

    return true;

}

 

void CMultiMouseWindow::CheckBound(long  
&x,long  
&y)

{

    CClientDC dc(this);

    if(x<0)

       x = 0;

    if(y<0)

       y = 0;

 

    //最大值由GetDeviceCaps函数获取以适应不同系统设置

    if(x>(long)dc.GetDeviceCaps(HORZRES))

       x = (long)dc.GetDeviceCaps(HORZRES);

    if(y>(long)dc.GetDeviceCaps(VERTRES))

       y = (long)dc.GetDeviceCaps(VERTRES);

}

 

//CMainWindow  
mesage map and member functions

 

void CMultiMouseWindow::DrawMultiCursor()

{

    CClientDC dc(this);

    for(int  
i=1; i<m_nMouseNumber; ++i)

    {

       POINT pt = { m_pSiRawMouse[i].X, m_pSiRawMouse[i].Y };

       ScreenToClient(&pt);

       dc.DrawIcon(pt, m_hiconCursor[i]);

    }

 

}

 

LRESULT CMultiMouseWindow::WindowProc(UINT  
message, WPARAM  
wParam, LPARAM  
lParam)

{

    // TODO: 在此添加专用代码和/或调用基类

    LPVOID lpb;

    UINT dwSize;

    RAWINPUT *raw;

 

    switch (message)

    {

       //响应WM_INPUT消息为本程序的主要部分

       case WM_INPUT:  

       {

           ::GetRawInputData((HRAWINPUT)lParam,  
RID_INPUT, NULL,  
&dwSize, 

                         sizeof(RAWINPUTHEADER));

 

           lpb = malloc(sizeof(LPVOID) * dwSize);

           if (lpb == NULL) 

           {

              return 0;

           } 

 

           ::GetRawInputData((HRAWINPUT)lParam,  
RID_INPUT, lpb,  
&dwSize, 

               sizeof(RAWINPUTHEADER));

 

           raw = (RAWINPUT*)lpb;

 

           if (raw->header.dwType == RIM_TYPEMOUSE)  
//判断是否为鼠标信息

           {

              raw->data.mouse.usFlags = MOUSE_MOVE_ABSOLUTE;

              for(int i=1; i<m_nMouseNumber;  
++i)

              {

                  if(m_pSiRawMouse[i].hDevice == raw->header.hDevice)

                  {

 

                     POINT pt = {m_pSiRawMouse[i].X,m_pSiRawMouse[i].Y};

                     ScreenToClient(&pt);

                     CRect rect;

                     rect.left = pt.x \- 30;

                     rect.right = pt.x \+ 30;

                     rect.top = pt.y \- 30;

                     rect.bottom = pt.y \+ 30;

 

                     m_pSiRawMouse[i].X += raw->data.mouse.lLastX;

                     m_pSiRawMouse[i].Y += raw->data.mouse.lLastY;

 

                     InvalidateRect(&rect,TRUE);

                     CheckBound(m_pSiRawMouse[i].X,m_pSiRawMouse[i].Y);

                     m_pSiRawMouse[0].X = m_pSiRawMouse[i].X;

                     m_pSiRawMouse[0].Y = m_pSiRawMouse[i].Y;

                     if(raw->data.mouse.usButtonFlags  
!= 0)

                     {

                         m_pSiRawMouse[i].usButtonFlags  
= raw->data.mouse.usButtonFlags;

                     }

                    

                  }

                  ::SetCursorPos(m_pSiRawMouse[0].X,  
m_pSiRawMouse[0].Y);

 

 

              }

           }

 

           free(lpb);  

           return 0;

       }

    }

    return CFrameWnd::WindowProc(message,  
wParam, lParam);

}

 

void CMultiMouseWindow::OnDestroy()

{

    CFrameWnd::OnDestroy();

    // TODO: 在此处添加消息处理程序代码

    if(m_pSiRawMouse  
!= NULL)

    {

       free(m_pSiRawMouse);

    }

 

    for(int  
i=0; i  
< 10; ++i)

    {

       DestroyIcon(m_hiconCursor[i]);

    }

    PostQuitMessage (0);
}
```
