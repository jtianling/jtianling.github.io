---
layout: post
title: "从易到难编写C++程序，（1）个人解答：把键盘输入的字符串逆序输出。"
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
  views: '34'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

```cpp
/*Copyright (c) 2007,九天雁翎  
 * All rights reserved.  
 * 从易到难编写C++程序，（1）问题：把键盘输入的字符串逆序输出。    
 * 完成日期：2007年5月31日  
 */  
#include "stdafx.h"  
#include <iostream>  
#include <string>  
#include <vector>  
#include <algorithm>  
#include <iomanip>  
using namespace std;  
typedef vector<string>::const_iterator c_iter;  
int main()  
{  
    vector<string> svec;    //因为要识别空格，还要换行，光一个string是不行的  
    string str;  
    cout<<"Please input the string you want to reverse:"<<endl;  
       
    //开始想以eof为结束，后来后悔了，以'!'为结束,  
    //开始我用cin作输入，后来后悔了，还是getline好  
    while(true)  
    {  
        getline(cin, str);  
        if(str.empty())               //假如输入空格也不应该算错误  
        {  
            svec.push_back(str);  
            continue;  
        }
    
    
        if(*(str.end() - 1) == '!')    //判断什么时候结束  
        {  
            str.erase(str.end() - 1);            //去掉结束符号  
            reverse(str.begin(), str.end());    //利用标准库的算法逆序str  
            svec.push_back(str);  
            break;  
        }
    
    
        reverse(str.begin(), str.end());    //利用标准库的算法逆序str  
        svec.push_back(str);  
    }//end of while  
    reverse(svec.begin(), svec.end());               //这一步可以在下一步用反向迭代器替换  
    for(c_iter it = svec.begin();            //输出svec  
        it != svec.end();++it)  
    {  
        cout<<*it<<endl;  
    }
    
    
    return 0;  
}
    
    
//这是我个人见过最笨的方法，仅仅作为一种个人学习的历史保留，勿学，好的解答参考同题解答（2）
```