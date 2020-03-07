---
layout: post
title: 用 Python 写游戏 第一篇
date: 2020-03-07
comments: true
categories: 编程
published: true
tags:
- 编程
- pyzero
---

学编程后, 过了初期的语法熟悉阶段, 新手往往会比较迷茫, 因为也不知道编程能干嘛, 对于这种情况, 我的建议当然是实际的做一些项目, 这里用一些游戏和 Python 的例子, 来真正的了解和熟悉编程吧.   

<!-- more -->

# 前提
以下的教程基于 Python3.7, 并且假设你已经会 Python 的基本语法和概念了.  
要是还没有学会, Python 的各种教程太多了, 先找来学习一下吧.  

[官方文档](https://docs.python.org/zh-cn/3.7/tutorial/index.html)  
[廖雪峰的 Python教程](https://www.liaoxuefeng.com/wiki/1016959663602400)

# 用什么写游戏
写游戏一般都会用到一个叫**游戏引擎**的库, 游戏引擎的概念来自汽车引擎, 汽车引擎驱动汽车, 提供动力, 游戏引擎驱动游戏, 简化我们写游戏的步骤.  

这里, 为了最友好的面向初学者, 我们首先用的是一个叫 pyzero 的游戏引擎, 这个引擎本身就是设计给初学者使用的, 所以接口和使用方式非常简单.

# 准备环境

准备一个专业的环境, 一共分 3 步:
1. 安装 Python
2. 安装 pyzero 库
3. 找个编辑器, 比如 VSCode

想长久享受编程乐趣的话, 可以自己学习一下怎么弄, 环境都没弄好, 估计 Python 也还没学会. 不过对于初学者, 还是有个简化的选项, 那就是 [**Mu**](https://codewith.mu/), 下载, 安装, bong! 以上 3 步的工具, 就都有了.

不得不感叹, 现在的编程世界, 对初学者的大门是完全敞开的, 学不学得会, 只取决于想不想学, 其实没有什么门槛.  

下面的教程, 都基于 Mu 来说明.  

# Mu 的操作
Mu 上面一排大大的按钮, 选择 Mode, 在列表里面选择 Pygame Zero, 就表示我们准备用 pyzero 来写游戏了.
写完游戏, 按 Save 保存, 方便下次用 Load 选择文件(也可以直接把文件拖到编辑区域) 继续编写.
编写完后, 按 Play 运行游戏.


# 第一个可运行的程序
在编程里, 我们一般把一个方向, 最小规模的一个程序, 叫做 **Hello World** 程序, 这个惯例来自于一本上世纪特别流行的 C 语言教材, 有兴趣的朋友可以去了解一下.

下面看我们的程序: 
``` python
def draw():
    screen.fill((128, 0, 0))
```

就这么夸张, 就两行代码, 一个函数...
简单说明一下, 定义一个叫 **draw** 的函数, 然后用 **screen** 对象里面的 **fill** 函数表示背景的填充.  
运行上面的代码, 你会得到一个夸张的红背景.  

其中 `draw` 函数, 我们并没有像普通程序一样, 由我们自己调用, 而是由 pyzero 游戏引擎在恰当的时候调用, 我们一般把这种函数, 叫做 **回调函数**, 表示我们不直接调用, 也不关心具体什么时候这个函数被调用, 只提供实现, 而是由类似 pyzero 这样的游戏引擎或者框架调用.
当然, `draw` 函数, 就像它的英文意思一样, 表示需要在屏幕上画东西的时候被调用, 我们的 `screen.fill((128, 0, 0))` 表示我们具体想画的是什么东西.  
而 `screen` 对象, 属于 pyzero 游戏引擎帮我们实现的对象, 用来简化我们的绘制步骤, 下面我们会用到很多.  


# 简单解释一下颜色
为什么上面 `(128, 0, 0)` 表示红色? 首先, 颜色的表示, 我们一般用所谓的光学三原色来表示, 也就是熟称的 红(Red), 绿(Green), 蓝(Blue), 我们往往用三个单词的第一个字母缩写, 即 RGB 来表示颜色的值, RGB 每个数值的范围一般是 0 到 255.  
上面的 `(128, 0, 0)` 是 Python 里面的 [元组](https://docs.python.org/zh-cn/3.7/tutorial/datastructures.html#tuples-and-sequences), 三个整数分别表示我们需要的颜色的 `(R, G, B)` 值. 
我们可以尝试调整这个元组数值, 看看打开窗口颜色的变化. 比如 `(0, 255, 0)` 表示纯绿色.  

# 画一些其他的东西
比如, 我们先画一个白色的圆, 来表示主角.  

``` python
def draw():
    screen.draw.circle((160, 120), 3, (255, 255, 255))
```

运行程序, 能看到在漆黑像夜空一样的背景中, 有一个想星星一样的圆点.

这个圆点还是用 `screen` 对象来实现绘制, 现在我们用的是 `screen` 对象里面的 `draw` 对象的 `circle` 函数(中文表示填满的圆的意思).
函数的具体参数的含义, 可以参考[pyzero官网](https://pygame-zero.readthedocs.io/en/stable/builtins.html#screen)

```python
# Draw the outline of a circle.
screen.draw.circle(pos, radius, (r, g, b))
```

参数解释:
1. 第一个参数, `(160, 120)` 也是一个元组, 表示我们想画的这个圆点的位置.
2. `3` 表示我们想画的圆的半径, 也就是用来表示圆有多大
3. `(255, 255, 255)`, 要是前面的内容看的认真, 看到这里就知道了, 这个表示圆的颜色

知道了参数类型以后, 我们尝试改改这几个参数, 看看画出来的圆的效果变化情况吧.

# 坐标的含义

位置坐标的含义, pyzero 里面用的位置, 使用的是所谓的屏幕坐标系, 以左上角为原点(即 0,0 点), X 向右增加, Y 向下增加.
![坐标示意图](/public/images/2020/axis.png)

# 更多形状

参考前面的[pyzero官网](https://pygame-zero.readthedocs.io/en/stable/builtins.html#screen), 只要你看明白了参数的类型, 试试更多的形状吧. 

我推荐试试下面几个常用的, 下面是参数说明

```python
# Draw a line from start to end. 画线
screen.draw.line(start, end, (r, g, b))

# Draw the outline of a circle.
screen.draw.circle(pos, radius, (r, g, b))

# Draw a filled circle. 实心圆
screen.draw.filled_circle(pos, radius, (r, g, b))

# Draw the outline of a rectangle. 矩形
screen.draw.rect(rect, (r, g, b))

# Draw a filled rectangle. 实心矩形
screen.draw.filled_rect(rect, (r, g, b))

# Draw text. 文字
draw.text(text, [pos, ]**kwargs)
```

试试运行下面这个程序, 看看各种形状

```python
def draw():
    screen.draw.text("Hello World", (100, 100))

    # Draw a line from start to end.
    screen.draw.line((100, 100), (300, 100), (255, 0, 0))

    # Draw the outline of a circle.
    screen.draw.circle((300, 100), 10, (0, 255, 0))

    # Draw a filled circle. 
    screen.draw.filled_circle((400, 100), 15, (0, 0, 255))

    # Draw the outline of a rectangle.
    screen.draw.rect(Rect((100, 200), (50, 50)), (255, 255, 255))

    # Draw a filled rectangle. 
    screen.draw.filled_rect(Rect((200, 200), (100, 100)), (128, 128, 128))
```

# 动画
我们都知道, 游戏不是静态的图片, 那么我们光靠静态的绘制, 也没有什么意思, 现在我们尝试让前面绘制的圆动起来.

看看下面这个程序:

```python
player_pos_x = 100
player_pos_y = 100

def draw():
    screen.clear()
    screen.draw.circle((player_pos_x, player_pos_y), 3, (255, 255, 255))
    
def update():
    global player_pos_x, player_pos_y
    player_pos_x = player_pos_x + 1 
```

先运行一下上面的程序, 能看到一个圆, 一直在向右移动.

## 位置变量的定义
我们在新的程序里面, 不再直接用位置坐标来绘制圆了, 我们用了 `player_pos_x`, `player_pos_y` 两个变量, 分别表示圆的 x 坐标位置和 y 坐标位置.

## update 回调函数
这个程序已经比前面复杂很多了, 特别是我们多了一个 `update` 函数, 就像 `draw` 函数一样, 这个函数也是一个回调函数, 一般我们将我们想做的游戏逻辑, 写在这个 `update` 函数里面.  
在这个例子里面, 我们是修改了 x 坐标的位置.
你自己尝试一下, 让圆从现在的从左往右移动, 改成从右往左试试. 
还有, 可以尝试让圆在 y 轴上移动试试.

需要稍微注意的一点是, 在 `update` 函数里面, 因为需要修改函数外部的全局变量, 需要用 `global` 关键字说明, 不然 Python 里面默认是找局部变量的.  

## 清理屏幕
上面还有一个小的地方需要注意, 和原来的直接绘制圆不同, `draw` 函数里面在画圆之前, 多了一句 `screen.clear`. 表示在每次绘制的时候, 先把屏幕清理干净.
为了加深对清理屏幕作用的理解, 你可以尝试把这一行删掉, 看看会发生什么.


# 操作
游戏, 也不光光是动画, 我们还要能操作才行.  说到这里, 我已经能给出游戏的完整表述的:

> 游戏, 就是可以即时交互的动画

试试下面的程序, 并在程序运行时, 尝试按按键盘或者任何可以操作键.
```python
player_pos_x = 100
player_pos_y = 100

def draw():
    screen.clear()
    screen.draw.circle((player_pos_x, player_pos_y), 3, (255, 255, 255))
    
def update():
    global player_pos_x, player_pos_y
    player_pos_x = player_pos_x + 1 
    
def on_key_down():
    global player_pos_x, player_pos_y
    player_pos_y = player_pos_y + 10 
```

我们能看到, 除了圆持续的还是往右移动以外, 每次按下任意一个按键, 圆都会往下移动 10 个像素.

`on_key_down` 这个回调函数, 会在我们按下按键的时候产生被调用. 不过目前我们并没有判断按下的是什么按键.

# 真实的操作

前面的例子里面, 我们没有判断按下的按键是什么, 这个比较无聊, 我们来看看真正的简单操作应该是什么样的.

```python
player_pos_x = 100
player_pos_y = 100

def draw():
    screen.clear()
    screen.draw.circle((player_pos_x, player_pos_y), 3, (255, 255, 255))
      
def on_key_down(key):
    global player_pos_x, player_pos_y
    if key == keys.LEFT:
        player_pos_x = player_pos_x - 10
    elif key == keys.RIGHT:
        player_pos_x = player_pos_x + 10
    elif key == keys.UP:
        player_pos_y = player_pos_y - 10
    elif key == keys.DOWN:
        player_pos_y = player_pos_y + 10
```

我们去掉了 `update` 函数, 并且判断了 `on_key_down` 被回调时, 传进来的 `key` 参数的值, 然后再按我们设定的规则去操作了这个圆, 试试吧.
具体的按键枚举, 还是可以在[pyzero官网](https://pygame-zero.readthedocs.io/en/stable/hooks.html#buttons-and-keys)看到

# 课后练习
这里我留下一个思考题, 我们平时操作游戏的时候, 不会一直不停的按键盘, 那样太累, 怎么样把上面的程序改成当我们按下方向键的时候, 圆一直移动呢?

这里给个提示, 你还需要实现 `on_key_up` 函数, 来获得我们松开键盘按键的信息.

# 第一篇的结束
我们现在已经了解了一个游戏需要的基础知识, 游戏开发的大门, 已经向我们打开了, 有想好要做什么游戏了吗?
