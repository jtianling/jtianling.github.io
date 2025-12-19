---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（2） IntCell类"
categories:
- Lua
- Python
- "算法"
tags:
- Bash
- C++
- Lua
- Python
- "《数据结构与算法分析-C++描述》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文用C++、Lua和Python实现了简单的IntCell类，并分享了代码，同时指出Bash语言因缺乏类的概念而无法实现。

<!-- more -->

# 一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（2）  
IntCell类

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第8面，图1-5，一个最最简单的类

刚开始都是太简单没有技术含量的东西，这样也好，不至于把我吓到，毕竟lua学了已经4个月了，python学了已经2个月了都没有怎么用，而sh虽然最近才学，但是实践的也是这么少。。。。。唯一已经不用思考语法的就是C++了吧。。。呵呵C++和汉语一样都是我的"母语"，虽然全世界人都说他复杂，但是用了这么久也就习惯了。

python就像英语，本身语法比较简单，但是学的比较晚，（相对于汉语/C++），所以暂时不能完全体会它的好处，但是学的时间越久你就会越喜欢：）最最让人郁闷的是词汇（库）丰富的让你想哭，要掌握全太难了。呵呵平时虽然看的多，却说/写的少。

lua就像是日语吧，虽然学过，知道其基本的发音（语法），但是却从来不说（不写代码），最多丢几句（写几段）最最简单的东西。

bash就像是韩语，想去学，但是看着头晕，奇形怪状的字符（语法）让人不得其要领。

以下为实现部分: 

CPP:   
书上已有实现。

LUA: 

```lua
#!/usr/bin/env lua

IntCell = {  storedValue = 0 }

function IntCell:new(orig)
    if type(orig) == "number" then
        o = {}
        o.storedValue = orig
    else
        o = orig or {}
    end
    setmetatable(o, self)
    self.__index = self
    return o
end

function IntCell:read()
    return self.storedValue
end

function IntCell:write(x)
    self.storedValue = x
end

-- test code
-- new IntCell and read and write
a = IntCell:new()
print("a:" .. (a:read()))
a:write(10)
print("a:" .. (a:read()))

-- create IntCell from a
b = IntCell:new(a)
print("b:" .. (b:read()))

-- create IntCell from a number
c = IntCell:new(100)
print("c:" .. (c:read()))
```

PYTHON: 

```python
#!/usr/bin/env python

class IntCell(object):
    def __init__(self, orig = 0):
        self.storedValue = orig
    def read(self):
        return self.storedValue
    def write(self,x):
        self.storedValue = x

# Test Code
def Test():
    a = IntCell()
    print "a:" + str(a.read())
    a.write(10)
    print "a:" + str(a.read())

    b = IntCell(100)
    print "b:" + str(b.read())

if __name__ == '__main__':
    Test();
```

BASH: 

1 没有类的概念。。。也没有办法像lua一样模拟出来（就我所知）

**_write by_**** _九天雁翎(JTianLing)  
\-- www.jtianling.com_**
