---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（6）高效率的幂运算"
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
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

文章分享了一个时间复杂度为O(log n)的高效幂运算算法，并提供了其在C++、Lua、Python和Bash四种语言下的完整代码实现。

<!-- more -->

# 一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记
用C++/lua/python/bash的四重实现（6）高效率的幂运算


<<Data Structures and Algorithm Analysis in C++>>

--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第46面，图2-11
一个高效率的幂运算，应该还算不上最高效率的,但是作为一个递归及O(logn)的例子还是很合适的，因为足够的简单。

bash的实现我发现老是用普通程序语言的思想是不行了，麻烦的要死，于是用命令替换实现了一个b版本，明显效果好的多：）用一个语言就是要用一个语言的特性。

来个截图，惯例。我好像喜欢上了这种一下排4，5个窗口然后照相的方式，呵呵，特有成就感。

从左自右依次是cpp,lua,python,bash,bash（b实现）。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081130/pow.jpg)

write by 九天雁翎(JTianLing)
-- www.jtianling.com

以下为实现部分:

CPP:

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

**bool**  IsEven(**int**  x)
{
    **return**  (x % 2 == 0);
}

**long**  MyPow(**long**  x, **int**  n)
{
    **if**( 0 == n)
        **return** 1;
    **if**  ( IsEven(n))
        **return**  MyPow( x * x, n / 2);
    **else**
        **return**  MyPow( x * x, n / 2 ) * x;
}

**int**  main(**int**  argc, **char** * argv[])
{
    printf("pow(2,2)=%ld/n",MyPow(2,2));
    printf("pow(2,3)=%ld/n",MyPow(2,3));
    printf("pow(2,4)=%ld/n",MyPow(2,4));
    printf("pow(2,5)=%ld/n",MyPow(2,5));
    printf("pow(2,6)=%ld/n",MyPow(2,6));

    exit(0);
}
```

LUA:

```lua
#!/usr/bin/env lua

function isEven(n)
    **return**  n % 2 == 0
end

function pow(m, n)
    **if**  n == 0 **then**
        **return**  1
    **end**

    **if**  isEven(n) **then**
        **return**  pow( m * m, n / 2)
    **else**
        **return**  pow( m * m, math.floor(n / 2) ) * m
    **end**
end

-- Test Code
print("pow(2,2)=" .. pow(2,2));
print("pow(2,3)=" .. pow(2,3));
print("pow(2,4)=" .. pow(2,4));
print("pow(2,5)=" .. pow(2,5));
print("pow(2,6)=" .. pow(2,6));
```

PYTHON:

```python
#!/usr/bin/env python

**def**  IsEven(n):
    **return**  n % 2 == 0

**def**  MyPow(m,n):
    **if**  n == 0:
        **return** 1

    **if**  IsEven(n):
        **return**  MyPow(m * m, n / 2)
    **else** :
        **return**  MyPow(m * m, n // 2) * m


**def**  test():
    **print**  "pow(2,2)=" + str(MyPow(2,2))
    **print**  "pow(2,3)=" + str(MyPow(2,3))
    **print**  "pow(2,4)=" + str(MyPow(2,4))
    **print**  "pow(2,5)=" + str(MyPow(2,5))
    **print**  "pow(2,6)=" + str(MyPow(2,6))

**if**  __name__ == '__main__':
    test()
```

BASH:

```bash
#!/usr/bin/env bash

isEven**()**
{
    **local**  m=$1
    **if**  (( m % 2 **==**  0))
    **then**
        **return**  1
    **else**
        **return**  0
    **fi**
}

pow**()**
{
    **local**  m=$1
    **local**  n=$2

    **if**  (( n **==**  0 ))
    **then**
        **return**  1
    **fi**

    **local**  m2
    **local**  n2
    **((**  m2 **=**  m * m **))**
    **((**  n2 **=**  n / 2 **))**

    isEven n
    **r=** $?
    **if**  (( r **==**  1 ))
    **then**
        pow $m2 $n2
        **return**  $?
    **else**
        pow $m2 $n2
        **local**  r2=$?
        (( r2 * **=**  m ))
        **return**  $r2
    **fi**
}

**echo**  -n  **"** pow(2,2)=**"**
pow 2 2
**echo**  $?
**echo**  -n  **"** pow(2,3)=**"**
pow 2 3
**echo**  $?
**echo**  -n  **"** pow(2,4)=**"**
pow 2 4
**echo**  $?
**echo**  -n  **"** pow(2,5)=**"**
pow 2 5
**echo**  $?
**echo**  -n  **"** pow(2,6)=**"**
pow 2 6
**echo**  $?
```

BASH(b实现):

```bash
#!/usr/bin/env bash

isEven**()**
{
    **local**  m=$1
    **if**  (( m % 2 **==**  0))
    **then**
        **echo**  1
    **else**
        **echo**  0
    **fi**
}

pow**()**
{
    **local**  m=$1
    **local**  n=$2

    **if**  (( n **==**  0 ))
    **then**
        **echo**  1
        **exit**  0
    **fi**

    **local**  m2
    **local**  n2
    **((**  m2 **=**  m * m **))**
    **((**  n2 **=**  n / 2 **))**

    **r=** `isEven $n`
    **if**  (( r **==**  1 ))
    **then**
        **local**  r1=`pow $m2 $n2`
        **echo**  $r1
    **else**
        **local**  r2=`pow $m2 $n2`
        (( r2 * **=**  m ))
        **echo**  $r2
    **fi**
}

**echo**  -n  **"** pow 2 2 = **"**
pow 2 2
**echo**  -n  **"** pow 2 3 = **"**
pow 2 3
**echo**  -n  **"** pow 2 4 = **"**
pow 2 4
**echo**  -n  **"** pow 2 5 = **"**
pow 2 5
**echo**  -n  **"** pow 2 6 = **"**
pow 2 6
```

