---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（7）习题2.8 随机数组的三种生成算法"
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
- "随机数组"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

用C++/Lua/Python/Bash四种语言实现生成随机数组的三种算法，并附代码对比不同语言的实现差异。

<!-- more -->

# 一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记
用C++/lua/python/bash的四重实现（7）习题2.8 随机数组的三种生成算法

**_write by_**** _九天雁翎(JTianLing) -- blog.csdn.net/vagrxie_**

<<Data Structures and Algorithm Analysis in C++>>

--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第49面， 一随机数组的三种生成算法

这一次没有截图，因为我受不了让bash运行100次的速度，怎么说来着，还是那句话，Bash根本就不适合也不是设计用来描述算法的语言，我根本就是自讨苦吃。用了最多的时间，得到的是最低的效率。。。。。。还有最扭曲的代码。但是因为工作中不用到bash，不常用用还真怕都忘了。。。现在用python的时候就常有这样的感觉，以前看的书就像白看了一样。

相对于bash来说，python的优雅一次一次的深入我心，每一次它都是代码最短的，最最优雅的，很多便捷的语法都是让人用的很痛快，虽然刚开始用的时候由于没有大括号。。。（我用c++习惯了）感觉代码就像悬在空中一样的不可靠。。。呵呵，习惯了以后，怎么看怎么爽。再加上丰富的库，绝了。

write by 九天雁翎(JTianLing)
-- www.jtianling.com

以下为实现部分:

CPP:

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <algorithm>
#include <iterator>
#include <iostream>
using namespace std;

int randInt(int i, int j)
{
    if(i > j)
    {
        int temp = i;
        i = j;
        j = temp;
    }

    return rand() % (j-i) + i;
}

void randArr1(int arr[], int n)
{
    for(int i=0; i<n; ++i)
    {
        while(true)
        {
            // some thing don't like py
            // because my randInt is create number
            // in [0,n) and py is [0,n]
            int temp = randInt(0, n);
            int j = 0;
            while(j < i)
            {
                if(arr[j] == temp)
                {
                    break ;
                }
                ++j;
            }
            if(j == i)
            {
                arr[j] = temp;
                break ;
            }
        }
    }
}

void randArr2(int a[], int n)
{
    bool *lpb = new bool[n];
    memset(lpb, 0, n);

    for(int i=0; i<n; ++i)
    {
        while(true)
        {
            int temp = randInt(0, n);
            if(!lpb[temp])
            {
                a[i] = temp;
                lpb[temp] = true;
                break ;
            }
        }

    }

    delete lpb;
    lpb = NULL;
}

void swap(int & a, int & b)
{
    int temp = a;
    a = b;
    b = temp;
}

// just for fun,but I like it.
// when py could have range and bash could have seq
// why cpp couldn't have a seq like this? lol
template <typename T>
class CFBSeq
{
public :
    CFBSeq(const T& aValue) : mValue(aValue) { }

    T operator()()
    {
        return mValue++;
    }

private :
    T mValue;
};

void randArr3(int a[], int n)
{
    generate(a, a+n, CFBSeq<int >(0));

    for(int i=1; i<n; ++i)
    {
        swap(a[i], a[randInt(0,i)]);
    }

}

int main(int argc, char * argv[])
{
    const int TIMES=100;
    srand(time(NULL));
    int a[TIMES],b[TIMES],c[TIMES];
    randArr1(a,TIMES);
    copy(a, a+TIMES, ostream_iterator<int >(cout," "));
    printf("/n");
    randArr2(b,TIMES);
    copy(b, b+TIMES, ostream_iterator<int >(cout," "));
    printf("/n");
    randArr3(c, TIMES);
    copy(c, c+TIMES, ostream_iterator<int >(cout," "));

    exit(0);
}
```

LUA:

```lua
#!/usr/bin/env lua

math.randomseed(os.time())

function randArr1(a, n)
    for i=1,n do
        while true do
            local temp = math.random(1, n)

            local j = 1
            while j < i do
                if a[j] == temp then  
                    break
                end
                -- Again damed that There is no ++
                -- and even no composite operator += !
                -- No one knows that is more concision
                -- and more effective?
                j = j + 1
            end

            if j == i then
                a[i] = temp
                break
            end

        end
    end
end

function randArr2(a, n)
    -- use nil as false as a lua's special hack
    local bt = {}
    for i=1,n do
        while true do
            local temp = math.random(1,n)
            if not bt[temp] then
                a[i] = temp
                bt[temp] = true
                break
            end
        end
    end
end

function randArr3(a, n)
    for i=1,n do
        a[i] = i
    end
    
    for i=1,n do
        local temp = math.random(1,n)
        -- one of the most things i like in lua&py
        a[i],a[temp] = a[temp],a[i]
    end
end


-- Test Code

times = 100
t = {}
randArr1(t, times)
for i,v in ipairs(t) do
    io.write(v .. " ")
end

t2 = {}
randArr2(t2, times)
for i,v in ipairs(t2) do
    io.write(v .. " ")
end

t3 = {}
randArr3(t3, times)
for i,v in ipairs(t3) do
    io.write(v .. " ")
end
```

PYTHON:

```python
#!/usr/bin/env python
from random import randint

def randArr1(a,n):
    for i in range(n):
        while True:
            temp = randint(0, n-1)

            for j in range(i):
                if a[j] == temp:
                    break ;
            # another one of the things I like in py(for else)
            else :
                a.append(temp)
                break ;

def randArr2(a,n):
#surely it is not need be a dict but dict is faster then list
    bd = {}
    for i in range(n):
        while True:
            temp = randint(0, n-1)
            if temp not in tl:
                a.append(temp)
                tl[temp] = True
                break

def randArr3(a,n):
    a = range(n)
    for i in range(n):
        
        temp = randint(0, n-1)
        
        # like in lua
        a[i],a[temp] = a[temp],a[i]

def test():
    times = 100
    l = []
    randArr1(l, times)

    print l
    l2 = []
    randArr1(l2, times)
    print l2

    l2 = []
    randArr1(l2, times)
    print l2


if __name__ == '__main__':
    test()
```

BASH:

```bash
#!/usr/bin/env bash

# just for a range rand....let me die....
# what I had said? bash is not a good
# language for describing algorithms
randInt()
{
    local a=$1
    local b=$2

    if (( a > b ))
    then
        local temp
        (( temp = a ))
        (( a = b ))
        (( b = temp ))
    fi

    local mi
    (( mi = b - a + 1 ))
    local r=$((RANDOM%${mi}+${a}))
    echo -n $r
}

randArr1()
{
# only one argument because I hate the
# bash's indirect reference
# you can reference the (4) binarySearch to
# see what I said
    local n=$1
    declare -a a
    for (( i=1; i<=n; ++i ))
    do
        while true
        do
            temp=`randInt 1 $n`
            j=1
            while (( j < i ))
            do
                if (( a[j] == temp ))
                then
                    break
                fi
                (( ++j ))
            done
            if (( j == i ))
            then
                (( a[ j ] = temp ))
                break
            fi
        done
    done

    echo ${a[*]}
}

randArr2()
{
    local n=$1
    declare -a a
    # used for bool array
    declare -a b
    for (( i=1; i<=n; ++i ))
    do
        while true
        do
            local temp=`randInt 1 $n`
            if [ -z ${b[temp]} ]
            then
                (( a[ i ] = temp ))
                (( b[ temp ] = true ))
                break
            fi
        done
    done

    echo ${a[*]}
}

randArr3()
{
    local n=$1
    for (( i=1; i<=n; ++i ))
    do
        (( a[ i ] = i ))
    done
    for (( i=1; i<=n; ++i ))
    do
        local temp=`randInt 1 $n`
        (( t = a[ i ] ))
        (( a[ i ] = a[ temp ] ))
        (( a[ temp ] = t ))
    done

    echo ${a[*]}
}

# so slow that I can't bear it run 100 times
randArr1 10
randArr2 10
randArr3 10
```

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**
