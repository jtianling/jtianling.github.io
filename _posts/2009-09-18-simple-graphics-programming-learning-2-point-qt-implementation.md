---
layout: post
title: "简单图形编程的学习（2）---点 (Qt实现)"
categories:
- "游戏开发"
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**简单图形编程的学习（ 2）\---点 (Qt实现)**

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

# 一、   画点

在Qt中画点的函数是QPainter的drawPoint函数，还是放在QPainter体现了Qt决心将所有的绘图指令放在一个对象中。（除了OpenGL）既然如此，使用方法上和drawText也就差不太多了。

开篇来个最简单的示例吧，画点世界的HelloWorld，随机的点。

这个工程的全部文件都贴出来，也作为Qt中实现动画的一种示例：

Main.cpp:

```cpp
#include <QtGui/QApplication>
#include <QTest>
#include <QTime>
#include "pointwidget.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    PointWidget w;
    w.show();
    QTime timer;
    // 这是能随机绘点的关键，没有设置此属性，默认相当于每次Qt都会完整的将上一次的屏幕擦除，
    // 新版的Qt中已经没有了repaint(bool)接口了。
    w.setAttribute(Qt::WA_OpaquePaintEvent);
    while(true)
    {
        timer.start();
        // 调用此函数即相当于Windows中的GetMessage,系列函数，包括了tranlate，分发函数等的所有操作
        a.processEvents();
        w.repaint();

        // 此处是控制帧数的关键点
        while(timer.elapsed() < 33)
        {
            QTest::qSleep(1);
        }
    }
}
```

Pointwidget.h

```cpp
#ifndef POINTWIDGET_H
#define POINTWIDGET_H

#include <QtGui/QWidget>
#include <QPainter>
#include <QObject>
namespace Ui
{
    class PointWidget;
}

class PointWidget : public QWidget
{
    Q_OBJECT

public:
    PointWidget(QWidget *parent = 0);
    ~PointWidget();

protected:
    void paintEvent(QPaintEvent *event);
    //void keyPressEvent(QKeyEvent *event);
    //void closeEvent(QCloseEvent *event);
private:
    Ui::PointWidget *ui;
};

#endif // POINTWIDGET_H
```

Pointwidget.cpp

```cpp
#include "pointwidget.h"
#include "ui_pointwidget.h"

PointWidget::PointWidget(QWidget *parent)
: QWidget(parent), ui(new Ui::PointWidget)
{
    ui->setupUi(this);
    qsrand(time(NULL));
}

PointWidget::~PointWidget()
{
    delete ui;
}

void PointWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter(this);

    for(int i = 0; i < 1000; ++i)
    {
        int r = qrand() % 255;
        int g = qrand() % 255;
        int b = qrand() % 255;
        QPen pen(qRgb(r,g,b));
        painter.setPen(pen);

        int x = qrand() % 800;
        int y = qrand() % 800;

        // 其实核心内容就是调用这一个函数而已
        painter.drawPoint(x,y);
    }
}
```

同样还是比较简单，当然，得首先熟悉Qt的基本机制，其中控制循环的方式特别重要，虽然这里可以使用与Win32 Timer类似的定时器技术来实现这样简单的绘制，但是对于帧数的稳定控制还是这样的代码比较可靠，另外，w.setAttribute(Qt::WA_OpaquePaintEvent);一句够初学者找够久的了。。。（我就找了很久）

知道这些以后，剩下的也就是一个qrand函数+ drawPoint函数的理解量了。这里不放截图了，这么简单的东西放个截图我都觉得没有意思。

## 1.      老电视机雪花点的效果：

Main.cpp中用

```cpp
PointWidget w;
QPalette palette;
palette.setColor(QPalette::Window, QColor(0,0,0));
w.setPalette(palette);
```

几行代码改变Widget的背景，这里说明一下，其实这样改变背景个人感觉属于Qt中面向对象过头的一个问题，事实上远远复杂于一个简单的SetBkColor函数，但是Qt将所有与界面颜色相关的东西封在QPalette中，以后同时改变多个属性的时候会稍微简单一点（其实也没有简单到哪去，多次调用SetTextColor,SetBkColor等语句也不见的复杂到哪去）

老电视机雪花效果中每次都需要擦除重绘避免点的叠加所以一下语句注释掉

//    w.setAttribute(Qt::WA_OpaquePaintEvent);

paintEvent实现：

```cpp
void PointWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter(this);

    for(int i = 0; i < 1000; ++i)
    {
        // 老电视机都是白色雪花点
        QPen pen(qRgb(255,255,255));
        painter.setPen(pen);

        int x = qrand() % 800;
        int y = qrand() % 800;

        painter.drawPoint(x,y);
    }
}
```

完整代码就不贴了。

## 2.      移动的星空：

主要实现代码：

```cpp
PointWidget::PointWidget(QWidget *parent)
: QWidget(parent), ui(new Ui::PointWidget)
{
    ui->setupUi(this);
    qsrand(time(NULL));

    // 初始化星空中的点
    for(int i = 0; i < POINT_NUMBER; ++i)
    {
        marPoint[i].rx() = qrand() % 800;
        marPoint[i].ry() = qrand() % 800;
    }
}

PointWidget::~PointWidget()
{
    delete ui;
}

void PointWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter(this);

    QPen pen(qRgb(255,255,255));
    painter.setPen(pen);
    for(int i = 0; i < POINT_NUMBER; ++i)
    {
        marPoint[i].rx()++;
        if(marPoint[i].x() > 800)
        {
            marPoint[i].rx() = 0;
        }

        painter.drawPoint(marPoint[i]);
    }
}
```

思路还是与以前的一样，无非是西安初始化一些点，然后改变其x坐标，但是要说明的是，Qt为我们简化了很多操作，首先，默认情况下，会擦出每一帧，这样就不用我们手动通过覆盖上一个点的方式去完成，另外，默认使用了双缓冲方式显示图片（与上个特性其实是统一的。。。。）完全不闪。。。。

# 二、   小结

一个个简单的点就能够构成的效果比本文展示的要多的多，参考以前的文章，因为笔者对Qt的熟悉程度有限，重新实现程序费时费力，并且也不太适应目前所用的QtCreator工具（主要是vi功能弱的吐血，Eclipse的vi模拟就够差的了，QtCreator虽然原生就带，但是几乎还不如不用，还是VS中的ViEmu强大），程序的其他效果及截图也请参考此系列相关其他文章了：

《[简单图形编程的学习（2）\---点 (Windows GDI实现)](<http://www.jtianling.com/archive/2009/08/30/4498503.aspx>)》

《[简单图形编程的学习（2）\---点 (small basic实现)](<http://www.jtianling.com/archive/2009/08/29/4495105.aspx>)》


[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)