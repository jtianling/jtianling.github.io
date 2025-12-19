---
layout: post
title: "堆栈的应用（2） 中缀算术表达式到后缀（逆波兰记法reverse polish notation）的转换及其计算 C++实现"
categories:
- "算法"
tags:
- C++
- reverse polish notation
- "堆栈"
- "逆波兰记法"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '1'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文用C++实现了基于堆栈的中缀表达式转后缀表达式算法，并展示了如何计算结果。程序支持加、乘和括号，但输入格式要求严格。

<!-- more -->

# 堆栈的应用（2）
中缀算术表达式到后缀（逆波兰记法reverse polish notation）的转换及其计算 C++实现


<<Data Structures and Algorithm Analysis in C++>>

--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第73-77面，中缀算术表达式到后缀（逆波兰记法reverse polish notation）的转换及其计算

目前仅仅实现文中说明的功能，目标并不是一个完整的四则运算程序，所以只支持加法，乘法和（）。另外，因为对于C++流的控制能力比较弱（我下一步就决定好好研究研究），所以对输入的格式要求非常严格。

必须是1 + 2 * 3 =

的格式，每个数字和符号之间都需要空格，一个比较复杂的例子是：

```
1 + 2 *
3 + ( 1 + 2 * 3 ) =
```

转换后：

```
1 2 3 *
+ 1 2 3 * + + =
```

先看测试程序，就应该能知道，大概实现了什么效果了，这里唯一的便利在于，用了C++的输入输出流后，对于iostream,stringstream都比较一致了，但是还是感觉自己对流的控制能力太弱了。

test.cpp:

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <stack>
#include <string>
#include <iostream>
#include <sstream>
#include "ExprComputer.h"

using namespace std;

int main(int argc, char * argv[])
{
    CExprComputer loExprComputer;
    // all these below can work right,comment is same as the content 'couted'.
    stringstream lss;
    lss << "1 + 2 * 3 =";

    cout <<"test trans stringstream in and cout." <<endl;
    loExprComputer.TransInfix2Postfix(lss, cout);

    cout <<"test trans cin and cout." <<endl;
    loExprComputer.TransInfix2Postfix(cin, cout);

    stringstream lss2;
    cout <<"test trans cin and stringstream out." <<endl;
    loExprComputer.TransInfix2Postfix(cin, lss2);
    cout << lss2.str() <<endl;

    lss.seekg(0);
    cout <<"test stringstream in computeInfix." <<endl;
    cout << lss.str();
    cout << loExprComputer.ComputeInfix(lss) <<endl;

    cout <<"test cin in computeInfix." <<endl;
    cout << loExprComputer.ComputeInfix(cin) <<endl;

    stringstream lssPostfix;
    lssPostfix << "1 2 3 * + =";
    cout <<"test stringstream in ComputePostfix." <<endl;
    cout << lssPostfix.str();
    cout << loExprComputer.ComputePostfix(lssPostfix) <<endl;

    cout <<"test cin in ComputePostfix." <<endl;
    cout << loExprComputer.ComputePostfix(cin) <<endl;

    cout <<"Test completed." <<endl;
    exit(0);
}
```

ExprComputer头文件：

```cpp
#ifndef __EXPR_COMPUTE_H__
#define __EXPR_COMPUTE_H__

#include <iostream>
#include <sstream>
#include <stack>
using namespace std;

// argument to input
#define _IN_ 

// argument to output
#define _OUT_ 

class CExprComputer
{
public :
    int ComputeInfix(_IN_ istream& aisExpr);
    int ComputePostfix(_IN_ istream& aisExpr);

    // Transform a infix expression to Postfix expression
    int TransInfix2Postfix(_IN_ istream& aisInfix,
            _OUT_ ostream& aosPostfix);

private :
    // Stack should be empty,Dump the information still in Stack and exit
    void DumpStack();

    // Output all information still in Stack
    void OutputStack();

    // Make sure Stack is not empty when it should not.
    void CheckStack();

    // I don't know why Stack operator is so few.And why I need to
    // clear the Stack in this example? GOD knows.
    void ClearStack();

    // Read a int or a operator from a stream
    bool ReadStream(_IN_ istream& aisExpr, _OUT_ int & aiReaded,  _OUT_ bool & abIsChar);

    // Process a Operator
    void ProcessOperator(char ac, _OUT_ ostream& aosPostfix);

    void ComputeOperator(char ac);

    stack<int> miSta;
};

#endif
```

cpp 文件：

```cpp
#include "ExprComputer.h"

void CExprComputer::DumpStack()
{
    if(!miSta.empty())
    {
        cout <<"stack: ";
        OutputStack();
        cout <<endl;
        exit(1);
    }

}

void CExprComputer::OutputStack()
{
    while(!miSta.empty())
    {
        cout <<miSta.top() <<" ";
        miSta.pop();
    }
}

void CExprComputer::ClearStack()
{
    while(!miSta.empty())
    {
        miSta.pop();
    }
}

void CExprComputer::CheckStack()
{
    if(    miSta.empty() )
    {
        cout <<"Invalid expression input." <<endl;
        exit(1);
    }
}

bool CExprComputer::ReadStream(_IN_ istream& aisExpr, _OUT_ int & aiReaded,  _OUT_ bool & abIsChar)
{
    if(aisExpr.eof())
    {
        return false;
    }

    // try to read stream as a int
    abIsChar = false;
    int li;
    aisExpr >> li;

    // if next thing in stream is not a int, back a char and read it
    if(aisExpr.fail())
    {
        aisExpr.clear();
        aisExpr.unget();
        char c;
        aisExpr >> c;
        if(c != '=')
        {
            aiReaded = c;
            abIsChar = true;
            return true;
        }
        else
        {
            return false;
        }
    }

    aiReaded = li;
    return true;
}

void CExprComputer::ProcessOperator(char ac, _OUT_ ostream& aosPostfix)
{
    switch(ac)
    {
        case '(':
        {
            // save the '('
            miSta.push(ac);
            break ;
        }
        case ')':
        {
            char lc;
            CheckStack();

            // output all operator until find a '('
            while( (lc = miSta.top()) != '(' )
            {
                aosPostfix << lc <<" ";
                miSta.pop();
                CheckStack();
            }

            // the first '(' in stack,We just need pop it
            miSta.pop();
            break ;
        }
        case '*':
        {
            char lc;

            // output all operator until find a lower level operator
            while( !miSta.empty() &&
                    ((lc = miSta.top()) != '(') &&
                    ( lc != '+') )
            {
                aosPostfix <<lc <<" ";
                miSta.pop();
            }

            miSta.push(ac);
            break ;
        }
        case '+':
        {

            char lc;

            // output all operator until find a lower level operator
            while( !miSta.empty() &&
                    ((lc = miSta.top()) != '(') )
            {
                aosPostfix <<lc <<" ";
                miSta.pop();
            }

            miSta.push(ac);
            break ;
        }
        default :
        {
            cout <<"Don't support this operator." <<endl;
            exit(1);
        }
    }

}

int CExprComputer::TransInfix2Postfix(_IN_ istream& aisInfix,
        _OUT_ ostream& aosPostfix)
{
    int li = 0;
    bool lbIsChar = false;
    while( ReadStream(aisInfix, li, lbIsChar) )
    {
        // number need immediately output
        if(!lbIsChar)
        {
            aosPostfix <<li <<" ";
        }
        else
        {
            char lc = static_cast<char>(li);
            ProcessOperator(lc, aosPostfix);
        }
    }

    while(!miSta.empty())
    {
        aosPostfix <<(char)miSta.top() <<" ";
        miSta.pop();
    }
    aosPostfix <<'=' <<endl;

    return 1;
}

int CExprComputer::ComputePostfix(_IN_ istream& aisExpr)
{
    ClearStack();

    int li = 0;
    bool lbIsChar = false;
    while( ReadStream(aisExpr, li, lbIsChar) )
    {
        // number need immediately output
        if(!lbIsChar)
        {
            miSta.push(li);
        }
        else
        {
            char lc = static_cast<char>(li);
            ComputeOperator(lc);
        }
    }

    CheckStack();
    int liResult = miSta.top();
    miSta.pop();

    DumpStack();

    return liResult;
}

void CExprComputer::ComputeOperator(char ac)
{
    // get lhs and rhs
    CheckStack();
    int lilhs = miSta.top();
    miSta.pop();
    CheckStack();
    int lirhs = miSta.top();
    miSta.pop();

    switch(ac)
    {
        case '*':
        {
            int liResult = lilhs * lirhs;
            miSta.push(liResult);
            break ;
        }
        case '+':
        {
            int liResult = lilhs + lirhs;
            miSta.push(liResult);
            break ;
        }
        default :
        {
            cout <<"Don't support this operator." <<endl;
            exit(1);
        }
    }
}

int CExprComputer::ComputeInfix(_IN_ istream& aisExpr)
{
    stringstream lss;
    TransInfix2Postfix(aisExpr, lss);
    return ComputePostfix(lss);
}
```

