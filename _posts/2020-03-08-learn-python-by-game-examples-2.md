---
layout: post
title: 用 Python 写游戏 第二篇
date: 2020-03-08
comments: true
categories: 编程
published: true
tags:
- 编程
- pyzero
---

学编程后, 过了初期的语法熟悉阶段, 新手往往会比较迷茫, 因为也不知道编程能干嘛, 对于这种情况, 我的建议当然是实际的做一些项目, 这里用一些游戏和 Python 的例子, 来真正的了解和熟悉编程吧.   

本文为该系列的第二篇

<!-- more -->

# 主角就绪
参考[教程的第一篇](/learn-python-by-game-examples-1.html)及[第一篇课后的答案](/learn-python-by-game-examples-1-answer.html), 我们已经获得了一个操作上较为靠谱的主角, 暂时用一个小圆点来表示.
再次回顾一下代码:

```python
player_pos_x = 100
player_pos_y = 100

def draw():
    screen.clear()
    screen.draw.filled_circle((player_pos_x, player_pos_y), 
                                3, 
                                (255, 255, 255))

up = False    
down = False
left = False
right = False

def on_key_down(key):
    global up,down, left,right
   
    if key == keys.UP:
        up = True
    elif key == keys.DOWN:
        down = True
    elif key == keys.LEFT:
        left = True
    elif key == keys.RIGHT:
        right = True        

def update():
    global up, down, left, right, player_pos_x, player_pos_y
    if up:
        player_pos_y = player_pos_y - 1
    if down:
        player_pos_y = player_pos_y + 1
    if left:
        player_pos_x = player_pos_x - 1
    if right:
        player_pos_x = player_pos_x + 1
        
def on_key_up(key):
    global down,up,left,right
    if key == keys.UP:
        up = False
    elif key == keys.DOWN:
        down = False
    elif key == keys.LEFT:
        left = False
    elif key == keys.RIGHT:
        right = False

```

# 添加敌人
只有主角, 没有敌人, 那叫什么游戏啊, 我们用小方块来表示敌人吧, 还记得怎么绘制方块吗?

```python

player_pos_x = 100
player_pos_y = 100

enemy_pos_x = 200
enemy_pos_y = 200

def draw():
    screen.clear()
    screen.draw.filled_circle((player_pos_x, player_pos_y), 
                                3, 
                                (255, 255, 255))
                                
    screen.draw.filled_rect(Rect((enemy_pos_x, enemy_pos_y), (5, 5)), (255, 0, 0))

```

以上的代码只有 `draw` 部分, 不过也能看到, 屏幕上多了一个红色, 看起来很危险的敌人.

# 让敌人动起来
敌人是静止的, 也没有什么意思, 我们先做一个能追踪主角的敌人吧. 这个时候, 几何知识不够丰富也没有关系, 我们想一想, 怎么样才能让敌人追上主角呢?
最朴素的思想是, 让敌人的 x 坐标和 y 坐标, 都尽量的向主角靠拢, 这个想法够朴素了吧, 代码如下:

```python
player_pos_x = 100
player_pos_y = 100

enemy_pos_x = 200
enemy_pos_y = 200

def draw():
    screen.clear()
    screen.draw.filled_circle((player_pos_x, player_pos_y), 
                                3, 
                                (255, 255, 255))
                                
    screen.draw.filled_rect(Rect((enemy_pos_x, enemy_pos_y), (5, 5)), (255, 0, 0))


up = False    
down = False
left = False
right = False

def on_key_down(key):
    global up,down, left,right
   
    if key == keys.UP:
        up = True
    elif key == keys.DOWN:
        down = True
    elif key == keys.LEFT:
        left = True
    elif key == keys.RIGHT:
        right = True        

def update():
    global up, down, left, right, player_pos_x, player_pos_y, enemy_pos_x, enemy_pos_y
    if up:
        player_pos_y = player_pos_y - 1
    if down:
        player_pos_y = player_pos_y + 1
    if left:
        player_pos_x = player_pos_x - 1
    if right:
        player_pos_x = player_pos_x + 1
        
    if enemy_pos_x < player_pos_x:
        enemy_pos_x = enemy_pos_x + 1
    elif enemy_pos_x > player_pos_x:
        enemy_pos_x = enemy_pos_x - 1
        
    if enemy_pos_y < player_pos_y:
        enemy_pos_y = enemy_pos_y + 1
    elif enemy_pos_y > player_pos_y:
        enemy_pos_y = enemy_pos_y - 1
        
def on_key_up(key):
    global down,up,left,right
    if key == keys.UP:
        up = False
    elif key == keys.DOWN:
        down = False
    elif key == keys.LEFT:
        left = False
    elif key == keys.RIGHT:
        right = False

```

需要注意的时候, 注意什么样的代码, 写在什么地方, 让敌人向主角靠拢的代码, 记得写在 `update` 函数里面, 运行以后, 你会发现, 敌人现在直奔主角而去, 几乎难逃他的魔掌. 作为游戏玩法, 因为敌人的速度和主角一样, 主角几乎难逃魔掌, 并且, 我们能发现, 随着全局变量的增加, 我们的代码有太多的 `global` 变量需要声明, 是时候简化一下代码了. 

# 引入类型
我们用 `class` 来优化一下代码, 首先用一个 `Global` 的类型, 来简化全局变量的声明和使用, 另外引入 `Role`, `Player` 和 `Enmey`, 我们先从简化 `Draw`函数的实现开始:

```python

class Game:
    pass

class Role:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def draw(self):
        pass

class Player(Role):
    def draw(self):
        screen.draw.filled_circle((self.x, self.y), 
                                3, 
                                (255, 255, 255))
                                

class Enemy(Role):
    def draw(self):
        screen.draw.filled_circle((self.x, self.y), 
                                3, 
                                (255, 0, 0))

g = Game()
g.player = Player(100, 100)
g.enemy = Enemy(200, 200)

g.up = False
g.down = False
g.left = False
g.right = False

def draw():
    screen.clear()
    g.player.draw()
    g.enemy.draw()

def on_key_down(key):
    if key == keys.UP:
        g.up = True
    elif key == keys.DOWN:
        g.down = True
    elif key == keys.LEFT:
        g.left = True
    elif key == keys.RIGHT:
        g.right = True        

def on_key_up(key):
    if key == keys.UP:
        g.up = False
    elif key == keys.DOWN:
        g.down = False
    elif key == keys.LEFT:
        g.left = False
    elif key == keys.RIGHT:
        g.right = False

def update():
    if g.up:
        g.player.y -= 2
    if g.down:
        g.player.y += 2
    if g.left:
        g.player.x -= 2
    if g.right:
        g.player.x += 2
        
    if g.enemy.x < g.player.x:
        g.enemy.x += 1
    elif g.enemy.x > g.player.x:
        g.enemy.x -= 1
        
    if g.enemy.y < g.player.y:
        g.enemy.y = g.enemy.y + 1
    elif g.enemy.y > g.player.y:
        g.enemy.y -= 1
    
```

代码比原来多了一些内容, 要是还不明白 `Role`, `Player`, `Enemy` 几个类, 还有定义在 `Game` 类型的变量 `g` 中的 `player`, `enemy` 变量的含义, 建议赶紧回去复习一下 Python 的相关内容, 所谓面向对象编程, 不知道怎么定义类型和对象, 那可不行.
上面的代码, 我们的 `player`, `enemy` 对象, 自己处理了自己的 `draw` 而不是由外部来处理, 这种代码设计的方向, 我们称其为自己对自己负责, 这是一个能导向良好代码设计的方向, 因为只有所有对象都为自己负责, 才不需要把自己的更多内容, 告诉外部, 让外部控制自己. 做人也是这样, 不是吗?

# 更负责的对象
既然要做一个负责任的对象, 当然不能仅仅为 `draw` 这一件事情负责, 自己的移动这么重要的事情, 当然也不能交给别人来做. 接下来, 我们让 `player`, `enmey` 对象自己也接管自己的移动吧.

```python

class Game:
    pass

class Role:
    def __init__(self, x, y, max_speed):
        self.x = x
        self.y = y
        self.max_speed = max_speed
    
    def get_pos_x(self):
        return self.x
        
    def get_pos_y(self):
        return self.y
        
    def draw(self):
        pass

class Player(Role):
    def __init__(self, x, y, max_speed):
        super().__init__(x, y, max_speed)
        self._cur_speed_x = 0
        self._cur_speed_y = 0
        
    def draw(self):
        screen.draw.filled_circle((self.x, self.y), 
                                3, 
                                (255, 255, 255))
    
    def on_key_down(self, key):
        if key == keys.UP:
            self._cur_speed_y += -self.max_speed
        elif key == keys.DOWN:
            self._cur_speed_y += self.max_speed
        elif key == keys.LEFT:
            self._cur_speed_x += -self.max_speed
        elif key == keys.RIGHT:
            self._cur_speed_x += self.max_speed

    def on_key_up(self, key):
        if key == keys.UP:
            self._cur_speed_y -= -self.max_speed
        elif key == keys.DOWN:
            self._cur_speed_y -= self.max_speed
        elif key == keys.LEFT:
            self._cur_speed_x -= -self.max_speed
        elif key == keys.RIGHT:
            self._cur_speed_x -= self.max_speed
    
    def move(self):
        self.x += self._cur_speed_x
        self.y += self._cur_speed_y
                                

class Enemy(Role):
    def draw(self):
        screen.draw.filled_circle((self.x, self.y), 
                                3, 
                                (255, 0, 0))
                                
    def chase(self, player):
        if self.x < g.player.get_pos_x():
            self.x += self.max_speed
        elif self.x > g.player.get_pos_x():
            self.x -= self.max_speed
        
        if g.enemy.y < g.player.y:
            self.y += self.max_speed
        elif g.enemy.y > g.player.y:
            self.y -= self.max_speed

g = Game()
g.player = Player(100, 100, 2)
g.enemy = Enemy(200, 200, 1)

def draw():
    screen.clear()
    g.player.draw()
    g.enemy.draw()

def on_key_down(key):
    g.player.on_key_down(key)
      

def on_key_up(key):
    g.player.on_key_up(key)

def update():
    g.player.move()
    g.enemy.chase(g.player)

```

这种自己为自己负责, 把内部的变量(也叫属性)不让外部使用, 而是仅仅自己知道和使用的方式, 我们称之为 **封装**, 按其字面意思的理解就很贴切了, 意思就是把自己封闭起来,装的很牛的样子...
上面的代码, 已经比原来的玩具代码, 更像正常该有的样子了, 类似 `draw`, `on_key_down` 函数里面的内容很少, 仅仅只有对某个对象的函数的调用, 而真正的逻辑, 都写在**类**里面.
上面的代码, 其实和前面刚添加完敌人时候的作用一模一样, 但是样子却变化很大, 首先可以自己感受一下, 两者的区别.  

# 课后练习
今天我们添加了敌人, 并且尝试用类封装了主角和敌人, 可能经过这么多修改, 了解了很多新的概念, 但是你还对这些复杂的操作将信将疑, 为什么我们需要这么麻烦呢? 前面的代码看起来也挺直观的, 不是也挺好的吗?
通过一个练习, 我们来感受一下这么封装的好处吧, 那就是, 我们随机的, 在屏幕上生成更多的敌人, 比如每 5 秒,添加 1 个, 上限 100 个.

简单的提示, 用一个列表来存储所有的敌人吧.