---
layout: post
title: 用 Python 写游戏 第一篇 课后习题答案
date: 2020-03-07
comments: true
categories: 编程
published: true
tags:
- 编程
- pyzero
---

用 Python 写游戏 第一篇 课后习题答案

<!-- more -->

## 第一篇课后练习
这里我留下一个思考题, 我们平时操作游戏的时候, 不会一直不停的按键盘, 那样太累, 怎么样把上面的程序改成当我们按下方向键的时候, 圆一直移动呢?

这里给个提示, 你还需要实现 `on_key_up` 函数, 来获得我们松开键盘按键的信息.

## 答案

该答案由一名热心读者完成, 感谢该热心读者

```python
player_pos_x = 100
player_pos_y = 100

def draw():
    screen.clear()
    screen.draw.filled_circle((player_pos_x, player_pos_y), 3, (255, 255, 255))

up = False    
down = False
left = False
right = False

def on_key_down(key):
    global down,up,left,right
   
    if key == keys.S:
        down = True
    elif key == keys.W:
        up = True
    elif key == keys.A:
        left = True
    elif key == keys.D:
        right = True

def update():
    global down,up,left,right,player_pos_x,player_pos_y
    if down == True:
        player_pos_y = player_pos_y + 10 
    if right == True:
        player_pos_x = player_pos_x + 10
    if up == True:
        player_pos_y = player_pos_y - 10 
    if left == True:
        player_pos_x = player_pos_x - 10 
        
def on_key_up(key):
    global down,up,left,right
    if key == keys.A:
        left = False
    elif key == keys.S:
        down = False
    elif key == keys.D:
        right = False
    elif key == keys.W:
        up = False
```

该习题完成后, 我们就有了一个可以较自由操作的主角了, 期待接下来的课程吧.