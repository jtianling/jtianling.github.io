---
layout: post
title: "在Jeff Prosise井字棋的基础上做的一个五子棋"
categories:
- "我的程序"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

在Jeff Prosise井字棋的基础上做的一个五子棋，全手工代码输入，利用MFC实现，因为尚不知如何手工添加按钮，

所以暂时重新开始游戏的方式为双击标题栏。可以到<http://groups.google.com/group/jiutianfile>下载编译好的文件和Visual Studio.net 2005工程源代码。

源代码[gobangSrc.rar](<http://jiutianfile.googlegroups.com/web/gobangSrc.rar>)，编译好的文件[gobangRel.rar](<http://jiutianfile.googlegroups.com/web/gobangRel.rar>)

头文件gobang.h

class CMyApp : public CWinApp

{

public:

      virtual BOOL InitInstance();

};

 

class CMainWindow : public CFrameWnd

{

protected:

      enum gridState { Unputed, PutedO, PutedX};     //enum格子的个状态

      enum Turn {OTurn,XTurn};  //enum轮到谁下的状态

      enum winnerLast {NoOne,OWin,XWin};      //enum有没有胜利者的状态

      Turn m_nextTurn; //下轮执棋者

      const static int nClientSize = 700; //客户区大小，可改变

      const static int nGridNum = 20;         //格数，可改变

      int m_countStep;  //目前所下步数

      void DrawBoard(CDC &dc); //画棋盘

      CRect m_rcGrid[nGridNum][nGridNum];     //棋盘的每个格子的矩形范围

      gridState m_stateGrid[nGridNum][nGridNum];   //棋盘每个格子的状态

      void DrawO(CDC &dc,int i,int j);      //下O

      void DrawX(CDC &dc,int i,int j); //下X

      void ResetGame();     //重新开始游戏

      void CheckForGameOver(Turn thisTurn,int i,int j); //查找需不需要结束游戏

      BOOL IsWinner(Turn thisTurn,int i,int j);      //是否有胜利者

      BOOL IsDraw();   //是否平局

 

public:

      CMainWindow();

protected:

      afx_msg void OnPaint();

      afx_msg void OnLButtonDown(UINT nFlags,CPoint point);

      afx_msg void OnNcLButtonDblClk(UINT nHitTest,CPoint point);

      afx_msg void OnRButtonDown(UINT nFlags,CPoint point);

      afx_msg BOOL OnSetCursor(CWnd *pWnd,UINT nHitTest, UINT message);

      DECLARE_MESSAGE_MAP()

};

 

 

主体文件gobang.cpp

#include <afxwin.h>

#include <cmath>

#include <memory>

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

      ON_WM_RBUTTONDOWN()

      ON_WM_SETCURSOR()

END_MESSAGE_MAP()

 

 

CMainWindow::CMainWindow()

{

      //执圆形的先下棋，光标为圆型，并定下窗口固定宽度

      CString wndClassStr = ::AfxRegisterWndClass(CS_DBLCLKS,

           ::AfxGetApp()->LoadCursor(IDC_round));

      Create(wndClassStr,_T("五子棋by九天雁翎       (双击标题栏重新开始游戏）"),

           WS_OVERLAPPED | WS_SYSMENU | WS_CAPTION | WS_MINIMIZEBOX);

      CRect rect(0,0,nClientSize+2,nClientSize+2);

      CalcWindowRect(&rect);

      SetWindowPos(NULL,0,0,rect.Width(),rect.Height(),

           SWP_NOZORDER | SWP_NOMOVE | SWP_NOREDRAW);

     

      //初始化自定义的成员变量

      m_nextTurn = OTurn;

      m_countStep = 0;

     

      ::ZeroMemory(m_rcGrid,nGridNum * nGridNum * sizeof(CRect));

      ::ZeroMemory(m_stateGrid,nGridNum * nGridNum * sizeof(gridState));

     

 

 

 

}

 

void CMainWindow::OnPaint()

{

      CPaintDC dc(this);

      DrawBoard(dc);

}

 

void CMainWindow::DrawBoard(CDC &dc)

{

      CRect rect;

      GetClientRect(&rect);

 

      //画背景

      CBrush brush(RGB(128,128,128));

      dc.FillRect(rect,&brush);

 

//开始画纵横线，利用rect大小来画线，一是代码重用度高，二是以前做好了

//效率稍微低点，不过将来要是改变客户区大小或用可缩放窗口就可以不改了

     

      //定义画线的画笔并选中

      CPen pen(PS_SOLID,2,RGB(0,0,0));

      CPen *pOldPen = dc.SelectObject(&pen);

 

      //求方格宽高

      int nGridWidth = nClientSize / nGridNum  ; 

      int nGridHeight = nClientSize / nGridNum ;

     

 

      //计算每个方格矩形范围

      for(int i = 0; i < nGridNum; ++i)

           for(int j = 0; j < nGridNum; ++j)

           {

                 m_rcGrid[i][j] = CRect(rect.left + (nGridWidth * j),

                                                rect.top + (nGridHeight * i),

                                                rect.left + nGridWidth +(nGridWidth * j),

                                                rect.top + nGridHeight + (nGridHeight * i));

           }

 

 

      for(int i = 0; i <= nGridNum; ++i)   //画横线

      {

           int y = (nGridHeight * i) + rect.top;

           dc.MoveTo(rect.left,y);

           dc.LineTo(rect.right,y);

      }

 

      for(int i = 0; i <= nGridNum; ++i)   //画竖线

      {

           int x = (nGridWidth * i) + rect.left;

           dc.MoveTo(x,rect.top);

           dc.LineTo(x,rect.bottom);

      }

 

      //画下已经下好的棋

 

      for(int i=0; i<nGridNum; ++i)

           for(int j=0; j<nGridNum; ++j)

           {

                 if(m_stateGrid[i][j] == Unputed)

                 {

                      continue;

                 }

                 else if(m_stateGrid[i][j] == PutedO)

                 {

                      DrawO(dc,i,j);

                 }

                 else if(m_stateGrid[i][j] == PutedX)

                 {

                      DrawX(dc,i,j);

                 }

           }

 

}

 

//左键下O

void CMainWindow::OnLButtonDown(UINT nFlags, CPoint point)

{

      //若本轮不属O，即不响应

      if(m_nextTurn != OTurn)

           return;

      for(int i = 0; i<nGridNum; ++i)

           for(int j = 0; j<nGridNum; ++j)

           {

                 if(m_rcGrid[i][j].PtInRect(point) && m_stateGrid[i][j] == Unputed)

                 {

                      CClientDC dc(this);

                      m_nextTurn = XTurn;

                      m_stateGrid[i][j] = PutedO;

                      DrawO(dc,i,j);

                      ++m_countStep;

                      CheckForGameOver(OTurn,i,j);

                 }

           }

}

 

//右键下X

void CMainWindow::OnRButtonDown(UINT nFlags,CPoint point)

{

      //若本轮不属X，即不响应

      if(m_nextTurn != XTurn)

           return;

      for(int i = 0; i<nGridNum; ++i)

           for(int j = 0; j<nGridNum; ++j)

           {

                 if(m_rcGrid[i][j].PtInRect(point) && m_stateGrid[i][j] == Unputed)

                 {

                      CClientDC dc(this);

                      m_nextTurn = OTurn;

                      m_stateGrid[i][j] = PutedX;

                      DrawX(dc,i,j);

                      CheckForGameOver(XTurn,i,j);

                 }

           }

}

 

 

void CMainWindow::DrawO(CDC &dc, int i, int j)

{

      CRect rect(m_rcGrid[i][j]);

      rect.DeflateRect(5,5);

      dc.SelectStockObject(NULL_BRUSH);

      CPen pen(PS_SOLID,4,RGB(128,64,64));

      CPen *pOldPen = dc.SelectObject(&pen);

      dc.Ellipse(rect);

      dc.SelectObject(pOldPen);

}

 

void CMainWindow::DrawX(CDC &dc, int i, int j)

{

      CRect rect(m_rcGrid[i][j]);

      rect.DeflateRect(5,5);

      CPen pen(PS_SOLID,4,RGB(128,64,64));

      CPen *pOldPen = dc.SelectObject(&pen);

      dc.MoveTo(rect.left,rect.top);

      dc.LineTo(rect.right,rect.bottom);

      dc.MoveTo(rect.right,rect.top);

      dc.LineTo(rect.left,rect.bottom);

      dc.SelectObject(pOldPen);

 

}

 

void CMainWindow::CheckForGameOver(Turn thisTurn,int i,int j)

{

      if(IsWinner(thisTurn,i,j))

      {

           if(thisTurn == OTurn)

           {

                 CString string;

                 string.Format(_T("GOOD! O Wins in %d steps."),m_countStep);

                 MessageBox(string,_T("Game Over!"));

                 ResetGame();

           }

           else if(thisTurn == XTurn)

           {

                 CString string;

                 string.Format(_T("GOOD! X Wins in %d steps."),m_countStep);

                 MessageBox(string,_T("Game Over!"));

                 ResetGame();

           }

          

      }

      else if(IsDraw())

      {

           MessageBox(_T("OK,It's draw."),_T("Draw Game!"));

           ResetGame();

      }

 

}

 

//此为本软件最主要的部分，即检测是否有五个棋连在一起

//以横纵和两条对角线的方向分别检测，感觉比较笨

//暂时不知道有没有更好的办法，望来信赐教

BOOL CMainWindow::IsWinner(Turn thisTurn,int i,int j)

{

      int count = 1;

      gridState checkFor; //状态对比值

      if(thisTurn == OTurn)

           checkFor = PutedO;

      else if(thisTurn == XTurn)

           checkFor = PutedX;

 

      //横方向检测

      for(int m=1; m<5; ++m)

      {

           if(j - m > 0 && m_stateGrid[i][j-m] == checkFor)

                 ++count;

           else

                 break;

      }

      for(int m=1; m<5; ++m)

      {

           if(j + m < nGridNum && m_stateGrid[i][j+m] == checkFor)

                 ++count;

           else

                 break;

      }

      if(count >=5)

           return TRUE;

      count = 1;

 

      //竖方向检测

      for(int m=1; m<5; ++m)

      {

           if(i-m>0 && m_stateGrid[i-m][j] == checkFor)

                 ++count;

           else

                 break;

      }

      for(int m=1; m<5; ++m)

      {

           if(i+m<nGridNum && m_stateGrid[i+m][j] == checkFor)

                 ++count;

           else

                 break;

      }

      if(count >=5)

           return TRUE;

      count = 1;

 

      //左上至右下方向检测

      for(int m=1; m<5; ++m)

      {

           if(i-m>0 && j-m>0 && m_stateGrid[i-m][j-m] == checkFor)

                 ++count;

           else

                 break;

      }

      for(int m=1; m<5; ++m)

      {

           if(i+m<nGridNum && j+m<nGridNum && m_stateGrid[i+m][j+m] == checkFor)

                 ++count;

           else

                 break;

      }

      if(count >=5)

           return TRUE;

      count = 1;

 

      //右上至左下方向检测

      for(int m=1; m<5; ++m)

      {

           if(i-m>0 && j+m<nGridNum && m_stateGrid[i-m][j+m] == checkFor)

                 ++count;

           else

                 break;

      }

      for(int m=1; m<5; ++m)

      {

           if(i+m<nGridNum && j-m>0 && m_stateGrid[i+m][j-m] == checkFor)

                 ++count;

           else

                 break;

      }

      if(count >=5)

           return TRUE;

      return FALSE;

}

 

BOOL CMainWindow::OnSetCursor(CWnd *pWnd, UINT nHitTest, UINT message)

{

      if(nHitTest == HTCLIENT)

      {

           if(m_nextTurn == OTurn)

           {

                 ::SetCursor(::AfxGetApp()->LoadCursor(IDC_round));

                 return TRUE;

           }

           else if(m_nextTurn == XTurn)

           {

                 ::SetCursor(::AfxGetApp()->LoadCursor(IDC_cross));

                 return TRUE;

           }

      }

      return CFrameWnd::OnSetCursor(pWnd,nHitTest,message);

}

 

//当都下满了，即为平局

BOOL CMainWindow::IsDraw()

{

      int i,j;

      for(i=0; i<nGridNum; ++i)

           for(j=0; j<nGridNum; ++j)

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

      m_nextTurn = OTurn;

      m_countStep = 0;

      ::ZeroMemory(m_stateGrid,nGridNum * nGridNum * sizeof(gridState));

      Invalidate();

}

 

void CMainWindow::OnNcLButtonDblClk(UINT nHitTest, CPoint point)

{

      if(nHitTest == HTCAPTION)

      {

           ResetGame();

      }

 

      return CFrameWnd::OnNcLButtonDblClk(nHitTest,point);

}

 
