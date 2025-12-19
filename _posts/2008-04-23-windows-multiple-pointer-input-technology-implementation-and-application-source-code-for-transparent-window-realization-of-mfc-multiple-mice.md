---
layout: post
title: Windows中多指针输入技术的实现与应用(9 我设想用来实现MFC多鼠标的透明窗口源代码。。。）
categories:
- "我的程序"
tags:
- MFC
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

分享用MFC创建透明窗口模拟鼠标指针的代码，是多鼠标系统开发的基础。

<!-- more -->

/ 一下基本就是实现了一个透明的窗口，以此窗口来表示鼠标指针，我用了CImage,你可以到网上查查它的用法。
// 作者 : 九天雁翎(JTianLing)
// 软件 : 透明窗口示例程序
// 版本 : 0.1
// 文件 : MouseWnd.h
// 描述 :
// 实现在Visual Studio .NET 2005 SP1下编译测试通过。
// 创建时间：23:11:2008
// #################################################################
#pragma once
// CMouseWnd
class CMouseWnd : public CWnd
{
    DECLARE_DYNAMIC(CMouseWnd)
public:
    CMouseWnd();
    virtual ~CMouseWnd();
    CImage m_image;
protected:
    // CImage m_imBackGround;
    CRect m_rtImage;
    CDC* m_pImDC;
    DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnPaint();
    afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
    afx_msg void OnDestroy();
    afx_msg BOOL OnEraseBkgnd(CDC* pDC);
protected:
    virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
};
//---------------------------------------------------------------------------------------------------
// 文件 : MouseWnd.cpp
// 描述 :
// 实现在Visual Studio .NET 2005 SP1下编译测试通过。
// Webs : groups/google.com/group/jiutianfile
// Blog : /
// E-mail : JTianLing@GMail.com
// 欢迎大家在上述网页发帖或来信探讨，或说明该软件的BUG和可以改进之处
// 创建时间：23:11:2008
// #################################################################
```cpp
#include "stdafx.h"
#include "TestWnd.h"
#include "MouseWnd.h"


//  
CMouseWnd


IMPLEMENT_DYNAMIC(CMouseWnd,  
CWnd)


CMouseWnd::CMouseWnd()
{
    m_image.Load(_T("res/Mouseh.png"));
}

CMouseWnd::~CMouseWnd()
{
}


BEGIN_MESSAGE_MAP(CMouseWnd,  
CWnd)
    ON_WM_PAINT()
    ON_WM_CREATE()
    ON_WM_DESTROY()
    ON_WM_ERASEBKGND()
END_MESSAGE_MAP()



//  
CMouseWnd 消息处理程序



void CMouseWnd::OnPaint()
{
    CPaintDC dc(this); // device context for painting
    // TODO: 在此处添加消息处理程序代码
    // 不为绘图消息调用CWnd::OnPaint()
    //dc.TransparentBlt(m_rtImage.left,  
m_rtImage.top, m_rtImage.Width(), m_rtImage.Height(),
    //  m_pImDC,  
0, 0, m_image.GetWidth(), m_image.GetHeight(), RGB(255,255,255))


    //BLENDFUNCTION blend;
    //blend.BlendOp = AC_SRC_OVER;
    //blend.BlendFlags = 0;
    //blend.SourceConstantAlpha = 0;
    //blend.AlphaFormat = AC_SRC_ALPHA;
    //UpdateLayeredWindow(CPaintDC::FromHandle(dc.GetSafeHdc()),  
&CPoint(0,0), &CSize(m_image.GetWidth(), m_image.GetHeight()),
    //  m_pImDC,  
&CPoint(0,0), RGB(255,255,255), &blend, ULW_ALPHA | ULW_COLORKEY);

    //m_image.TransparentBlt(dc.GetSafeHdc(),m_rtImage,RGB(255,255,255));
}

int CMouseWnd::OnCreate(LPCREATESTRUCT  
lpCreateStruct)
{
    if (CWnd::OnCreate(lpCreateStruct)  
== -1)
       return -1;

    // TODO:  在此添加您专用的创建代码
    GetClientRect(&m_rtImage);
    m_rtImage.right = m_image.GetWidth();
    m_rtImage.bottom = m_image.GetHeight();
    m_pImDC = CDC::FromHandle(m_image.GetDC());

    ::SetWindowLong(m_hWnd, GWL_EXSTYLE,  
       ::GetWindowLong(m_hWnd, GWL_EXSTYLE)  
| WS_EX_LAYERED);
    SetLayeredWindowAttributes(RGB(255,255,255), 0, LWA_COLORKEY);
    SetWindowPos(&wndTopMost,0,0,0,0,SWP_NOMOVE  
| SWP_NOSIZE);
    return 0;
}

void CMouseWnd::OnDestroy()
{
    CWnd::OnDestroy();

    // TODO: 在此处添加消息处理程序代码
    m_image.ReleaseDC();
}

BOOL CMouseWnd::OnEraseBkgnd(CDC*  
pDC)
{
    // TODO: 在此添加消息处理程序代码和/或调用默认值
//  CWnd::OnEraseBkgnd(pDC);

    //pDC->TransparentBlt(m_rtImage.left,  
m_rtImage.top, m_rtImage.Width(), m_rtImage.Height(),
    //  m_pImDC,  
0, 0, m_image.GetWidth(), m_image.GetHeight(), RGB(255,255,255));
//  m_image.TransparentBlt(pDC->GetSafeHdc(),m_rtImage,RGB(255,255,255));
    m_image.Draw(pDC->GetSafeHdc(),m_rtImage);
//  m_image.BitBlt(pDC->GetSafeHdc(),m_rtImage.left,m_rtImage.right,SRCCOPY);
    return true;
}

BOOL CMouseWnd::PreCreateWindow(CREATESTRUCT&  
cs)
{
    // TODO: 在此添加专用代码和/或调用基类
    //cs.lpszClass =  
AfxRegisterWndClass(CS_HREDRAW|CS_VREDRAW|CS_DBLCLKS, 
    //  ::LoadCursor(NULL,  
IDC_ARROW), reinterpret_cast<HBRUSH>(GetStockObject(NULL_BRUSH)), NULL);
    return CWnd::PreCreateWindow(cs);
}
```
// ChildView.h : CChildView 类的接口
#pragma once
#include "MouseWnd.h"
// CChildView 窗口
class CChildView : public CWnd
{
// 构造
public:
    CChildView();
// 属性
public:
// 操作
public:
// 重写
    protected:
    virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
// 实现
public:
    virtual ~CChildView();
protected:
    CImage m_image;
    CImage m_imBackGround;
    CRect m_rtImage;
    CRect m_rtMouseWnd;
    CDC* m_pImDC;
    CMouseWnd m_mouseWnd;
    // 生成的消息映射函数
    //void SetTransparent(HWND, alpha);
protected:
    afx_msg void OnPaint();
    DECLARE_MESSAGE_MAP()
public:
    afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
    afx_msg void OnTimer(UINT_PTR nIDEvent);
    afx_msg BOOL OnEraseBkgnd(CDC* pDC);
    afx_msg void OnDestroy();
};
//------------------------------------------------------------------------------
// ChildView.cpp : CChildView 类的实现
```cpp
#include "stdafx.h"
#include "TestWnd.h"
#include "ChildView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


//  
CChildView

CChildView::CChildView()
{
    m_image.Load(_T("res/Mouseh.png"));
    m_imBackGround.Load(_T("res/BackGround001.jpg"));
}

CChildView::~CChildView()
{
}


BEGIN_MESSAGE_MAP(CChildView,  
CWnd)
    ON_WM_PAINT()
    ON_WM_CREATE()
    ON_WM_TIMER()
    ON_WM_ERASEBKGND()
    ON_WM_DESTROY()
END_MESSAGE_MAP()



//  
CChildView 消息处理程序

BOOL CChildView::PreCreateWindow(CREATESTRUCT&  
cs) 
{
    if (!CWnd::PreCreateWindow(cs))
       return FALSE;

    cs.dwExStyle  
|= WS_EX_CLIENTEDGE;
    cs.style  
&= ~WS_BORDER;
    cs.lpszClass  
= AfxRegisterWndClass(CS_HREDRAW|CS_VREDRAW|CS_DBLCLKS, 
       ::LoadCursor(NULL, IDC_ARROW),  
reinterpret_cast<HBRUSH>(COLOR_WINDOW+1), NULL);

    return TRUE;
}

void CChildView::OnPaint() 
{
    CPaintDC dc(this); // 用于绘制的设备上下文
   
    // TODO: 在此处添加消息处理程序代码
   
    // 不要为绘制消息而调用CWnd::OnPaint()


// Use pDC  
here
    //dc.TransparentBlt(m_rtImage.left,  
m_rtImage.top, m_rtImage.Width(), m_rtImage.Height(),
       //m_pImDC, 0, 0, m_image.GetWidth(),  
m_image.GetHeight(), RGB(255,255,255));
    //dc.BitBlt(m_rtImage.left,  
m_rtImage.top, m_rtImage.Width(), m_rtImage.Height(),
    //  m_pImDC,  
0, 0, SRCCOPY);

    m_image.TransparentBlt(dc.GetSafeHdc(),m_rtImage,RGB(255,255,255));
// m_image.TransparentBlt(dc.GetSafeHdc(),0,0,m_image.GetWidth(),m_image.GetHeight(),RGB(255,255,255));
    //m_image.Draw(dc.GetSafeHdc(),0,0);
}


int CChildView::OnCreate(LPCREATESTRUCT  
lpCreateStruct)
{
    if (CWnd::OnCreate(lpCreateStruct)  
== -1)
       return -1;

    // TODO:  在此添加您专用的创建代码
    GetClientRect(&m_rtImage);
    m_rtImage.right = m_image.GetWidth();
    m_rtImage.bottom = m_image.GetHeight();
    m_pImDC = CDC::FromHandle(m_image.GetDC());
    SetTimer(NULL,100,NULL);

    GetClientRect(&m_rtMouseWnd);
    m_rtMouseWnd.right = m_mouseWnd.m_image.GetWidth();
    m_rtMouseWnd.bottom = m_mouseWnd.m_image.GetHeight();
    m_rtMouseWnd.OffsetRect(0, 100);
    m_mouseWnd.CreateEx(NULL, AfxRegisterWndClass(0), _T(""), WS_POPUP  
| WS_VISIBLE,
                     m_rtMouseWnd,  
NULL,  NULL, NULL );
    //m_mouseWnd.Create(NULL, NULL,  
WS_CHILD | WS_VISIBLE, m_rtMouseWnd, this,
    //  1001);
    /*SetTransparent(m_mouseWnd.m_hWnd,0);*/
    return 0;
}

void CChildView::OnTimer(UINT_PTR  
nIDEvent)
{
    // TODO: 在此添加消息处理程序代码和/或调用默认值
    CClientDC dc(this);

    m_rtImage.OffsetRect(1,0);
    CRect rect(m_rtImage.left-1,m_rtImage.top,m_rtImage.right,m_rtImage.bottom);
    //InvalidateRect(rect);
//  Invalidate();
    m_rtMouseWnd.OffsetRect(1, 0);
    m_mouseWnd.MoveWindow(m_rtMouseWnd);
//  m_mouseWnd.Invalidate();
//  m_mouseWnd.AnimateWindow(200,AW_SLIDE |  
AW_HOR_POSITIVE );
    CWnd::OnTimer(nIDEvent);
}

BOOL CChildView::OnEraseBkgnd(CDC*  
pDC)
{
    // TODO: 在此添加消息处理程序代码和/或调用默认值
//  CWnd::OnEraseBkgnd(pDC);
    CRect rect;
    GetClientRect(&rect);
    m_imBackGround.StretchBlt(pDC->GetSafeHdc(),rect);
    return true;
}

void CChildView::OnDestroy()
{
    CWnd::OnDestroy();

    m_image.ReleaseDC();
    // TODO: 在此处添加消息处理程序代码
}

//void  
CChildView::SetTransparent(HWND   
alpha)  

//{
//  typedef BOOL (*LAYERFUNC)(HWND hwnd,COLORREF  
crKey,BYTE bAlpha,DWORD dwFlags);
//  LAYERFUNC   
SetLayer;   
//  HMODULE   
hmod=LoadLibrary(_T("user32.dll"));   
//  SetWindowLong(hwnd,GWL_EXSTYLE,GetWindowLong(hwnd,GWL_EXSTYLE)|0x80000L);   
//  SetLayer=(LAYERFUNC)GetProcAddress(hmod,"SetLayeredWindowAttributes");   
//  SetLayer(hwnd,0,(255*alpha)/100,0x2);   
//
//  FreeLibrary(hmod);   
//}
```
看到那么多注释就知道这是个没有完成的东西了，不过用这个透明的窗口加上我那些多鼠标的底层实现，用MFC来实现一个比较好的通用多鼠标系统应该是没有技术问题了，来实现一般的多鼠标MFC程序更是没有问题。这是我在参加工作前的最后一个作品。。。。呵呵，已经是7个月前的事情了，（现在是2008年11月23日），我今天晚上看到以前的这个东西，想起来那时候刚参加工作，家里连个可用的VS都没有，所以代码乱的很，今天整理一下，重新发一下，另外源代码也打包发到我常用的地址中：

http://groups.google.com/group/jiutianfile

另外，将当时没有发布的双鼠标五子棋源代码一起发了吧，那时候带着笔记本，台式机上的源码都发不了，直到现在才想起来：）

很多朋友发邮件或者在博客中问过我为什么没有继续对多鼠标这个东西研究下去，呵呵，在此一并答复了，本人实在是工作忙啊。。。。。。。再次说明一下什么叫忙，每天工作12个小时以上，每周工作6天，再加上你看看我最近学的东西，lua,python,bash....实在没有时间了，呵呵，既然我把什么都公布了，大家有什么想法就都自己去实现吧。。。。有不懂的我能解答的我尽量回答....
