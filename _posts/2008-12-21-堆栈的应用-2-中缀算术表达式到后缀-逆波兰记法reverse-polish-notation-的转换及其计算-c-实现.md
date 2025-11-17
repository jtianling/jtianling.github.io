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

  

#  堆栈的应用（2）  
中缀算术表达式到后缀（逆波兰记法reverse polish notation）的转换及其计算 C++实现  

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第73-77面，中缀算术表达式到后缀（逆波兰记法reverse polish notation）的转换及其计算

       目前仅仅实现文中说明的功能，目标并不是一个完整的四则运算程序，所以只支持加法，乘法和（）。另外，因为对于C++流的控制能力比较弱（我下一步就决定好好研究研究），所以对输入的格式要求非常严格。

必须是1 + 2 * 3 =

的格式，每个数字和符号之间都需要空格，一个比较复杂的例子是：

1 + 2 *  
3 + ( 1 + 2 * 3 ) =

转换后：

1 2 3 *  
\+ 1 2 3 * + + =

先看测试程序，就应该能知道，大概实现了什么效果了，这里唯一的便利在于，用了C++的输入输出流后，对于iostream,stringstream都比较一致了，但是还是感觉自己对流的控制能力太弱了。

test.cpp:

 1 #include <stdio.h>  
 2 #include  
<stdlib.h>  
 3 #include  
<stack>  
 4 #include  
<string>   
 5 #include  
<iostream>   
 6 #include  
<sstream>  
 7 #include  
"ExprComputer.h"  
 8 **using**  **namespace**  std;  
 9   
10 **int**  main(**int**  argc, **char** *  
argv[])  
11 {  
12     CExprComputer  
loExprComputer;  
13     // all these below can work right,comment is same as the  
content 'couted'.  
14     stringstream lss;  
15     lss << "1 + 2 * 3 =";  
16   
17     cout <<"test trans stringstream in and cout." <<endl;  
18     loExprComputer.TransInfix2Postfix(lss,  
cout);  
19   
20     cout <<"test trans cin and cout." <<endl;  
21     loExprComputer.TransInfix2Postfix(cin,  
cout);  
22   
23     stringstream  
lss2;  
24     cout <<"test trans cin and stringstream out." <<endl;  
25     loExprComputer.TransInfix2Postfix(cin,  
lss2);  
26     cout  
<<lss2.str() <<endl;  
27   
28     lss.seekg(0);  
29     cout <<"test stringstream in computeInfix." <<endl;  
30     cout  
<<lss.str();  
31     cout  
<<loExprComputer.ComputeInfix(lss) <<endl;  
32   
33     cout <<"test cin in computeInfix." <<endl;  
34     cout  
<<loExprComputer.ComputeInfix(cin) <<endl;  
35   
36     stringstream  
lssPostfix;  
37     lssPostfix  
<< "1 2 3 * + =";  
38     cout <<"test stringstream in ComputePostfix." <<endl;  
39     cout  
<<lssPostfix.str();  
40     cout  
<<loExprComputer.ComputePostfix(lssPostfix) <<endl;  
41   
42     cout <<"test cin in ComputePostfix." <<endl;  
43     cout  
<<loExprComputer.ComputePostfix(cin) <<endl;  
44    
45     cout <<"Test completed." <<endl;  
46     exit(0);  
47 }  
48

 

 

ExprComputer头文件：

1 #ifndef __EXPR_COMPUTE_H__  
 2 #define  
__EXPR_COMPUTE_H__  
 3 #include  
<iostream>   
 4 #include  
<sstream>  
 5 #include  
<stack>   
 6 **using**  **namespace**  std;   
 7   
 8 // argument  
to input  
 9 #define  
_IN_  
10   
11 // argument to  
output  
12 #define _OUT_  
13   
14 **class**  CExprComputer  
15 {  
16 **public** :  
17     **int**  ComputeInfix(_IN_ istream&  
aisExpr);  
18     **int**  ComputePostfix(_IN_ istream&  
aisExpr);  
19   
20     // Transform a infix expression to Postfix expression  
21     **int**  TransInfix2Postfix(_IN_ istream&  
aisInfix,  
22             _OUT_  
ostream& aosPostfix);  
23   
24 **private** :  
25     // Stack should be empty,Dump the information still in Stack  
and exit  
26     **void**  DumpStack();  
27   
28     // Output all information still in Stack  
29     **void**  OutputStack();  
30   
31     // Make sure Stack is not empty when it should not.  
32     **void**  CheckStack();  
33   
34     // I don't know why Stack operator is so few.And why I need  
to  
35     // clear the Stack in this example? GOD knows.  
36     **void**  ClearStack();  
37   
38     // Read a int or a operator from a stream  
39     **bool**  ReadStream(_IN_ istream&  
aisExpr, _OUT_ **int** &  
aiReaded,  _OUT_ **bool** &  
abIsChar);  
40   
41     // Process a Operator  
42     **void**  ProcessOperator(**char**  ac, _OUT_ ostream& aosPostfix);  
43   
44     **void**  ComputeOperator(**char**  ac);  
45   
46     stack<**int** > miSta;  
47 };  
48   
49   
50   
51   
52   
53 #endif  
54

 

cpp 文件：

  1 #include "ExprComputer.h"  
  2   
  3 **void**  CExprComputer::DumpStack()  
  4 {  
  5     **if**(!miSta.empty())  
  6     {  
  7         cout  
<<"stack: ";  
  8         OutputStack();  
  9         cout  
<<endl;  
 10         exit(1);  
 11     }  
 12   
 13 }  
 14   
 15 **void**  CExprComputer::OutputStack()  
 16 {  
 17     **while**(!miSta.empty())  
 18     {  
 19         cout  
<<miSta.top() <<" ";  
 20         miSta.pop();  
 21     }  
 22 }  
 23   
 24 **void**  CExprComputer::ClearStack()  
 25 {  
 26     **while**(!miSta.empty())  
 27     {  
 28         miSta.pop();  
 29     }  
 30 }  
 31   
 32 **void**  CExprComputer::CheckStack()  
 33 {  
 34     **if**(    miSta.empty() )  
 35     {  
 36         cout  
<<"Invalid expression input." <<endl;  
 37         exit(1);  
 38     }  
 39 }  
 40   
 41 **bool**  CExprComputer::ReadStream(_IN_  
istream& aisExpr, _OUT_ **int** &  
aiReaded,  _OUT_ **bool** &  
abIsChar)  
 42 {  
 43     **if**(aisExpr.eof())  
 44     {  
 45         **return**  false;  
 46     }  
 47   
 48     // try to read stream as a int  
 49     abIsChar = false;  
 50     **int**  li;  
 51     aisExpr  
>> li;  
 52   
 53     // if next thing in stream is not a int, back a char and  
read it  
 54     **if**(aisExpr.fail())  
 55     {  
 56         aisExpr.clear();  
 57         aisExpr.unget();  
 58         **char**  c;  
 59         aisExpr  
>> c;  
 60         **if**(c != '=')  
 61         {  
 62             aiReaded  
= c;  
 63             abIsChar  
= true;  
 64             **return**  true;  
 65         }  
 66         **else**  
 67         {  
 68             **return**  false;  
 69         }  
 70     }  
 71   
 72     aiReaded =  
li;  
 73     **return**  true;  
 74 }  
 75   
 76   
 77 **void**  CExprComputer::ProcessOperator(**char**  ac, _OUT_ ostream& aosPostfix)  
 78 {  
 79     **switch**(ac)  
 80     {  
 81         **case**  '(':  
 82         {  
 83             // save the '('  
 84             miSta.push(ac);  
 85             **break** ;  
 86         }  
 87         **case**  ')':  
 88         {  
 89             **char**  lc;  
 90             CheckStack();  
 91   
 92             // output all operator until find a '('  
 93             **while**( (lc = miSta.top()) != '(' )  
 94             {  
 95                 aosPostfix  
<< lc <<" ";  
 96                 miSta.pop();  
 97                 CheckStack();  
 98             }  
 99   
100             // the first '(' in stack,We just need pop it  
101             miSta.pop();  
102             **break** ;  
103         }  
104         **case**  '*':  
105         {  
106             **char**  lc;  
107   
108             // output all operator until find a lower level operator  
109             **while**( !miSta.empty() &&   
110                     ((lc  
= miSta.top()) != '(') &&  
111                     (  
lc != '+') )  
112             {  
113                 aosPostfix  
<<lc <<" ";  
114                 miSta.pop();  
115             }  
116   
117             miSta.push(ac);  
118             **break** ;  
119         }  
120         **case**  '+':  
121         {  
122   
123             **char**  lc;  
124   
125             // output all operator until find a lower level operator  
126             **while**( !miSta.empty() &&   
127                     ((lc  
= miSta.top()) != '(') )  
128             {  
129                 aosPostfix  
<<lc <<" ";  
130                 miSta.pop();  
131             }  
132   
133             miSta.push(ac);  
134             **break** ;  
135         }  
136         **default** :  
137         {  
138             cout  
<<"Don't support this operator." <<endl;  
139             exit(1);  
140         }  
141     }  
142   
143 }  
144   
145 **int**  CExprComputer::TransInfix2Postfix(_IN_  
istream& aisInfix,  
146         _OUT_  
ostream& aosPostfix)  
147 {  
148     **int**  li = 0;  
149     **bool**  lbIsChar = false;  
150     **while**( ReadStream(aisInfix, li, lbIsChar) )  
151     {  
152         // number need immediately output  
153         **if**(!lbIsChar)  
154         {  
155             aosPostfix  
<<li <<" ";  
156         }  
157         **else**  
158         {  
159             **char**  lc = **static_cast** <**char** >(li);  
160             ProcessOperator(lc,  
aosPostfix);  
161         }  
162     }  
163   
164     **while**(!miSta.empty())  
165     {  
166         aosPostfix  
<<(**char**)miSta.top() <<" ";  
167         miSta.pop();  
168     }  
169     aosPostfix  
<<'=' <<endl;  
170   
171     **return**  1;  
172 }  
173   
174 **int**  CExprComputer::ComputePostfix(_IN_  
istream& aisExpr)  
175 {  
176     ClearStack();  
177   
178     **int**  li = 0;  
179     **bool**  lbIsChar = false;  
180     **while**( ReadStream(aisExpr, li, lbIsChar) )  
181     {  
182         // number need immediately output  
183         **if**(!lbIsChar)  
184         {  
185             miSta.push(li);  
186         }  
187         **else**  
188         {  
189             **char**  lc = **static_cast** <**char** >(li);  
190             ComputeOperator(lc);  
191         }  
192     }  
193   
194     CheckStack();  
195     **int**  liResult = miSta.top();  
196     miSta.pop();  
197   
198     DumpStack();  
199   
200     **return**  liResult;  
201 }  
202   
203 **void**  CExprComputer::ComputeOperator(**char**  ac)  
204 {  
205     // get lhs and rhs  
206     CheckStack();  
207     **int**  lilhs = miSta.top();  
208     miSta.pop();  
209     CheckStack();  
210     **int**  lirhs = miSta.top();  
211     miSta.pop();  
212   
213     **switch**(ac)  
214     {  
215         **case**  '*':  
216         {  
217             **int**  liResult = lilhs * lirhs;  
218             miSta.push(liResult);  
219             **break** ;  
220         }  
221         **case**  '+':  
222         {  
223             **int**  liResult = lilhs + lirhs;  
224             miSta.push(liResult);  
225             **break** ;  
226         }  
227         **default** :  
228         {  
229             cout  
<<"Don't support this operator." <<endl;  
230             exit(1);  
231         }  
232     }  
233 }  
234   
235 **int**  CExprComputer::ComputeInfix(_IN_  
istream& aisExpr)  
236 {  
237     stringstream  
lss;  
238     TransInfix2Postfix(aisExpr,  
lss);  
239     **return**  ComputePostfix(lss);  
240 }

**_write by_**** _九天雁翎_**** _(JTianLing) --  
blog.csdn.net/vagrxie_**

 
