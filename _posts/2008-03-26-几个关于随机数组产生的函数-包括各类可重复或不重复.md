---
layout: post
title: "几个关于随机数组产生的函数 包括各类可重复或不重复"
categories:
- "我的程序"
tags:
- "随机数组"
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

几个关于随机数组产生的函数 包括各类可重复或不重复  

  
  
使用方法都比较简单，也不多说了，无非就是用一个数组和一个表示数组大小的整数来调用，这里要说明的是，你必须保证数组的大小要足够，其他的函数的作用可以参考具体文件的注释，我个人觉得够详细了

  
rand.h

```cpp
//-------Created By 九天雁翎(jtianling) Email:jtianling@gmail.com
//-------最后修改时间：.3.26


#ifndef RAND_H
#define RAND_H

namespace jtianling
{
    //此算法只保证范围，还是需要自己设定种子
    //此算法生成从lowBorder到highBorder的随机数,而且包括边界lowBorder,highBorder.
    //即lowBorder=<n<=highBorder
    int RandIntInRange(int lowBorder, int highBorder);

    //算法描述如<<Data Structures and Algorithm Analysis in C++>>
    //By Mark Allen Weiss 题目.8算法所示,根据习惯,不对outArray[]的大小做任何检验,
    //调用此函数的人应该确保这一点,即outArray的大小大于等于numOfArray
    //此算法的用途是高效地产生一个不重复的随机序列
    //且此序列正好包括(1,numOfArray)中所有自然数
    void RandArrayNoRepeatInN(int outArray[], int numOfArray);

    //此算法产生随机的不重复的数组,数组大小为N
    //利用set容器的特性来保证没有重复,因为set容器的查找远快于一个一个查找
    //所以此方法比<<Data Structures and Algorithm Analysis in C++>>
    //By Mark Allen Weiss 题目.8算法所示算法快，而且增长慢很多
    void RandArrayNoRepeat(int outArray[], int numOfArray);

    //产生一个的随机序列且此序列的数值只在(1,numOfArray)中
    void RandArrayInN(int outArray[], int numOfArray);

    //产生一个随机的序列,且序列的值为完全随机,序列的大小由numOfArray指定
    void RandArray(int outArray[], int numOfArray);

} //end of namespace jtianling


#endif
```

rand.cpp

```cpp
//-------Created By 九天雁翎(jtianling) Email:jtianling@gmail.com
//-------最后修改时间：.3.28
#include "rand.h"
#include <cstdlib>
#include <ctime>
#include <algorithm>
#include <set>

namespace jtianling
{
    //此算法生成从i到j的随机数,而且包括边界i,j.即i=<n<=j
    int RandIntInRange(int i, int j)
    {
        //确保i<j,不然就交换
        if(i > j)
        {
            int temp = i;
            i = j;
            j = temp;
        }
        //确保范围正确
        return rand()%(j-i+1) + i;
    }

    //算法描述如<<Data Structures and Algorithm Analysis in C++>>
    //By Mark Allen Weiss 题目.8算法所示,根据习惯,不对arr[]的大小做任何检验,
    //调用此函数的人应该确保这一点,即arr的大小大于等于n
    //此算法的用途是高效地产生一个不重复的随机序列
    //且此序列正好包括(1,n)中所有自然数
    void RandArrayNoRepeatInN(int arr[], int n)
    {
        srand( time(NULL) );
        for(int i=0; i<n; ++i)
        {
            arr[i] = i + 1;
        }
        for(int i=0; i<n; ++i)
        {
            std::swap(arr[i], arr[RandIntInRange(0, i)] );
        }
    }

    //此算法产生随机的不重复的数组,数组大小为N
    //利用set容器的特性来保证没有重复,因为set容器的查找远快于一个一个查找
    //所以此方法比<<Data Structures and Algorithm Analysis in C++>>
    //By Mark Allen Weiss 题目.8算法所示算法快，而且增长慢很多
    void RandArrayNoRepeat(int arr[], int n)
    {
        srand( time(NULL) );
        std::set<int> intSet;
        int temp;
        for(int i=0; i<n; ++i)
        {

            while(true)
            {
                temp = rand();
                if(!intSet.count(temp))
                {
                    arr[i] = temp;
                    intSet.insert(temp);
                    break;
                }
            }
        }
    }

    //产生一个的随机序列且此序列的数值只在(1,n)中,序列的大小由n指定
    void RandArrayInN(int arr[], int n)
    {
        srand( time(NULL) );
        for(int i=0; i<n; ++i)
        {
            arr[i] = RandIntInRange(0, n);
        }
    }

    //产生一个随机的序列,且序列的值为完全随机,序列的大小由n指定
    void RandArray(int arr[], int n)
    {
        srand( time(NULL) );
        for(int i=0; i<n; ++i)
        {
            arr[i] = rand();
        }
    }

} //end of namespace jtianling
```