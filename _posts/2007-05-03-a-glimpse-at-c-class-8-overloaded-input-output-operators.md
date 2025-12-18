---
layout: post
title: "浅谈C++类（8）--重载输入输出操作符"
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
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


其实我们已经用过操作符重载，还记得<<和>>吗？本来不是移位操作符吗？在C++里面我们已经把他们当作输入输出操作符用过了，我们今天来研究一下重载他们用来输入输出类，先还是用水果来举一个例子。

例8.0：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
    string name;     //定义一个name成员
    string colour;   //定义一个colour成员
public:
    friend istream& operator>>(istream&,Fruit&);        //必须要声明为友元啊，不然怎么输入啊
    friend ostream& operator<<(ostream&,const Fruit&);       //同理
    void print()              //定义一个输出名字的成员print()
    {
        cout<<colour<<" "<<name<<endl;
    }
    Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
    {
    }  //构造函数
    ~Fruit()
    {
    }
};
ostream& operator<<(ostream &out,const Fruit &s)           //我是输出操作符的重载
{
    out<<s.colour<<" "<<s.name;
    return out;
}
istream& operator>>(istream& in,Fruit &s)           //我是输入操作符的重载
{
    in>>s.colour>>s.name;
    if(!in)
        cerr<<"Wrong input!"<<endl;
    return in;
}
int main()
{
    Fruit apple;
    cin >>apple;
    cout<<apple;

    return 0;
}
```

对照着例子开始说明一下，重载这个词以前是用在函数上面的，而实际上C++中好像也把操作符看作一种特殊的函数，特殊的方面仅仅是在函数名是操作符而已，其他和函数没有什么区别，当作函数来对待就好了，函数无非就是 返回值 函数名（参数）的形式，重载操作符的时候也是这样，为了方便说明是操作数作函数名，这里用的是operator后接操作符的形式，如本例中说明的是输入输出操作符,就是operator<<,operator>>，这样，这个例子也许你还看不出用重载输入输出有什么好，我很久前就定义了一个print() 成员函数，以前不是都很好的完成了输出任务吗？而用构造函数也可以很好的完成输入了。当然说是这样说，但是操作符的特点是简单明了，而C/C++追求的就是简洁，当年C程序为了简洁甚至让一切东西默认int呢，要得就是简洁。比如，当大量的输出需要处理的时候，我们用函数就要这样，apple1.print();apple2.print();apple3.print()......................但是用操作符的话就可以这样，cout<<apple1<<apple2<<apple3；哪个简洁自然非常明了。所以虽然我们不用操作符好像也可以完成任务，不过我们还是偏向于使用重载操作符的方式，比如plus(a,b)我们自然愿意用a+b，我们还用"!"来取代empty（）用"=="来取代equal（），用"+="取代a=plus(a,b)，等等等等。
