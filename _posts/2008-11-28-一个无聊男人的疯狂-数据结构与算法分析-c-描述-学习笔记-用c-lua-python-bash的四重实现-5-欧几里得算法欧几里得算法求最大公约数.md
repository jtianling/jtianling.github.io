---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（5）欧几里得算法欧几里得算法求最大公约数"
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
- "最大公约数"
- "欧几里德算法"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '47'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

#   一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记  
用C++/lua/python/bash的四重实现（5）欧几里得算法求最大公约数

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第45面，图2-10欧几里得算法

欧几里得算法求最大公约数好像也比较出名，起码各大算法书籍都喜欢用，可能因为说明简单，却能够说明问题。

这里突然想说一句，当bash老是用C语法部分来完成也就没有那么难的变态了，只是，可能多了一点投机的成分。

再来个截图，下次再截就成惯例了。

从左自右依次是cpp,lua,python,bash。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081128/gcd.jpg)![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081128/gcd.jpg)  

write by 九天雁翎(JTianLing)  
\-- www.jtianling.com

以下为实现部分: 

CPP: 

```cpp
#include <stdio.h>
#include <stdlib.h>

**long**  gcd(**long**  m, **long**  n)
{
    **if**(m < n)
    {
        **long**  temp = m;
        m = n;
        n = temp;
    }
    **while**( n != 0)
    {
        **long**  rem = m % n;
        m = n;
        n = rem;
    }

    **return**  m;
}

**int**  main(**int**  argc, **char** * argv[])
{
    printf("gcd(1989,1590)=%ld/n",gcd(1989,1590));
    printf("gcd(1590,1989)=%ld/n",gcd(1590,1989));
    exit(0);
}
```

LUA: 

```lua
#!/usr/bin/env lua

function gcd(m,n)
    **if**  m < n **then**
        m,n = n,m
    **end**

    **while**  n ~= 0 **do**
        rem = m % n
        m = n
        n = rem
    **end**

    **return**  m
end

-- Test code
print("gcd(1989,1590)=" .. gcd(1989,1590))
print("gcd(1590,1989)=" .. gcd(1590,1989))
```

PYTHON: 

```python
#!/usr/bin/env python

**def**  gcd(m,n):
    **if**  m < n:
        m,n = n,m

    **while**  n != 0:
        rem = m % n
        m = n
        n = rem

    **return**  m

**def**  test():
    **print**  "gcd(1989,1590)=" + str(gcd(1989,1590))
    **print**  "gcd(1590,1989)=" + str(gcd(1590,1989))

**if**  __name__ == '__main__':
    test()
```

BASH: 

```bash
#!/usr/bin/env bash

gcd()
{
    m=$1
    n=$2
    **if**  (( m < n ))
    then
        (( temp = m ))
        (( m = n ))
        (( n = temp ))
    fi

    **while  **(( n != 0 ))
    do
        (( rem = m % n ))
        (( m = n ))
        (( n = rem ))
    done

    **return**  $m
}

# test code
**echo**  -n  " gcd(1989,1590)="
gcd 1989 1590
**echo**  $?
**echo**  -n  " gcd(1590,1989)="
gcd 1590 1989
**echo**  $?
```

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**