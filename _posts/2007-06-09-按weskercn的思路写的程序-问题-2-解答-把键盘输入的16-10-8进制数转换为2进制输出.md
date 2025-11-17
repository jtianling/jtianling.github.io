---
layout: post
title: "按weskercn的思路写的程序，问题(2)解答：把键盘输入的16，10，8进制数转换为2进制输出"
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
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

```cpp
//因为不能回复，老是提示校检码错误，所以单独发出来。

#include "stdafx.h"
#include <iostream>
#include <string>
#include <cstdlib>
#include <bitset>
#include <iomanip>
#include <cassert>
#include <limits>

using namespace std;

typedef enum _transmode
{
    HEX_MODE = 1,
    DEC_MODE,
    OCT_MODE
} transmode;

int main()
{
    string instr;           //这就是输入，string类型
    long outlong;           //转换成进制的长整数
    int n_Numformat;
    cout << "Please chose the input number format(1-Hex,2-Dec,3-Oct)" << endl;
    cin >> n_Numformat;
    cout << "Please input the number to be transformed:";
    cin >> instr;

    switch (n_Numformat)   //这里你的风格好于我
    {
    case HEX_MODE:
        n_Numformat = 16;
        break;
    case DEC_MODE:
        n_Numformat = 10;
        break;
    case OCT_MODE:
        n_Numformat = 8;
        break;
    default:
        cout << "Error input number,exit" << endl;
        exit(1);
    }

    outlong = strtol(instr.c_str(), NULL, n_Numformat);
    assert(outlong != 0);  //假如转换失败，断言错误,这是你的方法的最好的地方
    bitset<numeric_limits<long>::digits> abit(outlong);
    cout << "The binary number is" << abit << endl; //没有管格式了
    return 0;
}
```