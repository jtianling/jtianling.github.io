---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（4）二分搜索算法"
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
- "二分搜索"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文用C++、Lua、Python和Bash四种语言实现了二分搜索算法，并附上完整代码供参考学习。

<!-- more -->



<<Data Structures and Algorithm Analysis in C++>>

--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第44面，图2-9二分搜索算法

二分搜索是很著名也很实用的算法，在排序中查找的速度从算法分析角度来说已经是最快的了。O(logN)

这里费了点心，将bash都实现了，扭曲啊，扭曲，光是传递一个数组参数都折腾了半天，最后还是通过所谓的间接引用然后用for重新赋值才实现我想要的数组，再次认为bash的算法描述语法混乱不堪。。。。其实bash只有命令调用的语法好用而已（个人见解），但是碰到我这样无聊的人，偏偏要用bash去实现算法。。。那就只能稍微偷点懒了，用了bash的C语言语法部分。

以下4个算法都是一样的，测试时为了统一结果，消除因为cpp,python数组从0开始，lua,bash数组从1开始的问题，测试时，cpp,python从-1开始测试。最后测试完成的结果完全一致，来个有意思的截图：

我编码的时候平铺4个putty窗口，正好占满我的19寸屏：）

从左自右依次是cpp,lua,python,bash。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081127/binarySearch.jpg)

以下是源代码：

CPP:

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <iostream>
using  namespace  std;
template <typename  T>
int  binarySearch(const  vector<T> &a, const  T &x, int & aiTimes)
{
    int  low = 0;
    int  high = a.size() - 1;

    while(low <= high)
    {
        ++aiTimes;
        int mid = (low + high) / 2;
        
        if(a[mid] < x)
        {
            low = mid + 1;
        }
        else  if(a[mid] > x)
        {
            high = mid - 1;
        }
        else
        {
            return  mid;
        }
    }

    return  -1;
}

int  main(int  argc, char * argv[])
{
    vector<int > lveci;
    lveci.resize(100);
    for(int  i = 0; i < 100; ++i)
    {
        lveci[i] = i;
    }

    int  liTimes = 0;
    cout << binarySearch(lveci, -1, liTimes);
    cout <<"/tcost:" <<liTimes <<endl;
    liTimes = 0;
    cout << binarySearch(lveci, 0, liTimes);
    cout <<"/tcost:" <<liTimes <<endl;
    liTimes = 0;
    cout << binarySearch(lveci, 1, liTimes);
    cout <<"/tcost:" <<liTimes <<endl;
    liTimes = 0;
    cout << binarySearch(lveci, 2, liTimes);
    cout <<"/tcost:" <<liTimes <<endl;
    liTimes = 0;
    cout << binarySearch(lveci, 100, liTimes);
    cout <<"/tcost:"<<liTimes <<endl;



    exit(0);
}
```

LUA:

```lua
#!/usr/bin/env lua
function binarySearch(a, v)
    low = 1
    high = #a

    times = 0
    while(low <= high) do
        times = times + 1
        mid = math.floor(( low + high) / 2)
        if  a[mid] < v  then
            low = mid + 1
        elseif  a[mid] > v then
            high = mid - 1
        else
            return  mid,times
        end
    end

    return  -1,times
end

-- test code
array = {}
for  i=1,100 do
    array[i] = i
end

print(binarySearch(array, 0))
print(binarySearch(array, 1))
print(binarySearch(array, 2))
print(binarySearch(array, 3))
print(binarySearch(array, 101))
```

PYTHON:

```python
#!/usr/bin/env python

def  binarySearch(a, v):
    low = 0
    high = len(a) - 1
    times = 0

    while  low <= high:
        times += 1
        mid = (low + high) // 2

        if  v > a[mid]:
            low = mid + 1
        elif  v < a[mid]:
            high = mid - 1
        else :
            return  mid,times
    
    return  -1,times

array = range(100)
print  binarySearch(array, -1)
print  binarySearch(array, 0)
print  binarySearch(array, 1)
print  binarySearch(array, 2)
print  binarySearch(array, 100)
```

BASH:

```bash
#!/usr/bin/env bash


binarySearch()
{
    v=$2
    an="$1[@]"
    a=${!an}
    for  i in  $a
    do
        ar[ i]= $i
    done
    low=1
    high=${#ar[*]}
    ((  times= 0 ))

    while  (( low <= high ))
    do
        ((  ++times  ))
        ((  mid=( low+high ) /2 ))
        #echo -n " mid="$mid
        #echo -n " ar[mid]="${ar[mid]}
        if  ((  v > ar[ mid ]  ))
        then
            ((  low =  mid \+ 1 ))
        elif  ((  v < ar[ mid ]  ))
        then
            ((  high =  mid \- 1 ))
        else
            #echo -e "/nTimes="$times
            return  $mid
        fi
    done

    #echo -e "/nTimes="$times
    return  -1
}

for  ((i= 1;  i<= 100;  ++i))
do
    ((  array[ i]  =  i  ))
done

binarySearch array 0
echo  -e  "$?/t$times"
binarySearch array 1
echo  -e  "$?/t$times"
binarySearch array 2
echo  -e  "$?/t$times"
binarySearch array 3
echo  -e  "$?/t$times"
binarySearch array 101
echo  -e  "$?/t$times"

exit  0
```

