---
layout: post
title: Windows 下利用MFC实现的中国象棋棋盘绘制程序
categories:
- "我的程序"
tags:
- MFC
- Windows
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


最近在啃 Jeff Prosise《MFC Windows 程序设计》这本书，以前虽然也学过MFC，当时用的是孙鑫的视频教程和书，学完后，似乎感觉有收获，也的确可以编点小的MFC程序，不过总感觉没有吃透，所以下决心，还是学这本书好，当时急于学习，偏偏网上这本书缺货，所以买了大家评价都不错的孙鑫那本，结果感觉还是不太好。突然想起某人说过，凡是教Windows编程的，书中图片过多，基本不要看，说的虽然很过，不过的确感觉用IDE引导出来的程序自己还是不能完全吃透，《MFC Windows 程序设计》就真的是主要靠手工代码，最近也学完一部分了，突发奇想画个象棋棋盘，巩固一下知识。完全手工代码输入，仅以抛砖引玉，因为没有考虑太多的缩放和分辨率问题，所以程序在不同的机子上可能会有效果不好的情况，假如有时间再改改。不要奇怪我怎么会在.NET横行的时代还在学大家都认为已经不行的MFC，我在网上晃了很久，发现懂MFC是很多公司的基本要求，无奈。。。。。。。。。。

<!-- more -->

## ChineseChessBoard.h

```cpp
class CMyApp : public CWinApp
{
public:
      virtual BOOL InitInstance();
};

class CMainWindow : public CFrameWnd
{
public:
      CMainWindow();

protected:
      afx_msg void  OnPaint();
      DECLARE_MESSAGE_MAP()
};
```

## ChineseChessBoard.cpp

```cpp
#include <afxwin.h>
#include <cmath>
#include "Hello.h"

CMyApp myApp;

//CMyApp member functions

BOOL CMyApp::InitInstance()
{
      m_pMainWnd = new CMainWindow;
      m_pMainWnd->ShowWindow(SW_SHOWMAXIMIZED);
      m_pMainWnd->UpdateWindow();
      return TRUE;
}



BEGIN_MESSAGE_MAP(CMainWindow,CFrameWnd)
      ON_WM_PAINT()
END_MESSAGE_MAP()

CMainWindow::CMainWindow()
{
      Create(NULL,_T("象棋棋盘"),WS_OVERLAPPEDWINDOW);
}

//CMainWindow mesage map and member functions
void CMainWindow::OnPaint()
{
      CPaintDC dc(this);

      CRect rect;
      GetClientRect(&rect);

      //画背景
      CBrush bkBrush(RGB(192,192,192));
      dc.FillRect(rect,&bkBrush);
     
      //确定画象棋棋盘的范围
      rect.DeflateRect(200,30);
      rect.OffsetRect(0,15);

      //画下象棋棋盘的背景
      CBrush brush(RGB(128,128,128));
      dc.FillRect(rect,&brush);

      //无聊，给点立体感
      rect.InflateRect(2,2);
      dc.Draw3dRect(rect,RGB(255,255,255),RGB(255,255,255));
      rect.DeflateRect(2,2);

      //开始画纵横线
      CPen pen(PS_SOLID,2,RGB(0,0,0));
      CPen *pOldPen = dc.SelectObject(&pen);
      int nGridWidth = rect.Width()/8;  //横向宽度，共格
      int nGridHeight = rect.Height()/9;  //纵向宽度，共格

      for(int i = 0; i < 10; ++i)   //画横线,10笔
      {
           int y = (nGridHeight * i) + rect.top;
           dc.MoveTo(rect.left,y);
           dc.LineTo(rect.right,y);
      }

      for(int i = 0; i < 8; ++i)   //画竖线，画笔，空下最右的竖线
      {
           int x = (nGridWidth * i) + rect.left;
      
           //中间为界限，无竖线
           dc.MoveTo(x,rect.top);
           dc.LineTo(x,rect.top + nGridHeight * 4);
           dc.MoveTo(x,rect.top + nGridHeight * 5);
           dc.LineTo(x,rect.bottom);
      }
     
      //补上左界限的竖笔及最右的竖线，此以rect.right画最右竖线，最重合
      dc.MoveTo(rect.left,rect.top + nGridHeight * 4);
      dc.LineTo(rect.left,rect.top + nGridHeight * 5);
      dc.MoveTo(rect.right,rect.top);
      dc.LineTo(rect.right,rect.bottom);
     
      //输出文字“楚河汉界”
      dc.SelectObject(pOldPen);
      CRect textRect(rect.left,rect.top + nGridHeight * 4,
                     rect.right,rect.top + nGridHeight * 5);
      CFont font;
      font.CreatePointFont(520,_T("宋体"));
      CFont *pOldFont = dc.SelectObject(&font);
     
      dc.SetBkMode(TRANSPARENT);
      dc.DrawText(_T("楚河    汉界"),-1,textRect,
           DT_SINGLELINE | DT_CENTER | DT_VCENTER);
      dc.SelectObject(pOldFont);

}
```
