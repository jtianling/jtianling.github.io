---
layout: post
title: "从易到难编写C++程序，（2）个人解答：把键盘输入的16，10，8进制数转换为2进制输出。"
categories:
- C++
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

一个C++程序示例，利用iostream读取不同进制的输入，再通过bitset将其转换为二进制并格式化输出。

<!-- more -->

```cpp
/*Copyright (c) 2007,九天雁翎

* All rights reserved.

* 从易到难编写C++程序，（2）问题：把键盘输入的16，10，8进制数转换为2进制输出。

* 完成日期：2007年6月9日*/

#include "stdafx.h"

#include <iostream>
#include <string>
#include <cstdlib>
#include <bitset>
#include <iomanip>
#include <cassert>
#include <limits>

using namespace std;

const size_t MAXLENGTH = numeric_limits<long>::digits; //定义MAXLENGTH为可保存long的二进制位数

int main()
{
    long inlong;            //输入
    int format;
    cout<<"Please choose the number type you want to input(1-Oct,2-Dec,3-Hex):";   //这里顺序由小到大，不知道合理不
    cin>>format;
    assert( format == 1 || format == 2 || format == 3 );      //假如有不听话的用户，断言错误，呵呵
    cout<<"Please input the number to be transformed:";
    if(format == 1)
    {
       cin>>oct>>inlong;         //利用iostream转换成进制避免了用c的库函数
    }
    else if(format == 2)
    {
       cin>>dec>>inlong;
    }
    else if(format == 3)
    {
       cin>>hex>>inlong;        //利用iostream转换进制避免了用c的库函数
    }
    //这种方法我发现一个很明显的缺点，那就是没有办法判断输入是否正确
    //也许是我的知识匮乏，希望有高手指点，怎么在这种情况判断输入时是否合乎逻辑
    //比如进制就不能出现，等的情况
    bitset<MAXLENGTH> abit(inlong); //利用bitset的构造函数完成进制到进制的转换
    cout<<"The binary number is:"<<endl;
    for(size_t i = MAXLENGTH; i != 0; --i)      //因为是bitset类型，所以输出是反的，有点奇怪
    {
       if( (i % 8 == 0) && i != MAXLENGTH)
       {
           cout<<" ";
       }
       cout<<abit[i-1];       //会发现只有位，因为第一位是符号位啊
    }
    return 0;
}
```
