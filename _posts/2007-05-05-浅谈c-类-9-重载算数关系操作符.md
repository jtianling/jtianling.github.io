---
layout: post
title: "浅谈C++类（9）--重载算数关系操作符"
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
  views: '1'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

欢迎转载，但请标明作者 “九天雁翎”，当然，你给出这个帖子的链接更好。 

本来 是可以一讲就把重载全部讲完的，因为昨天太晚了，很困，所以就只讲了重载输入输出操作符，今天概念性的东西就不说了，直接看上一讲的《浅谈C++类（8）--重载输入输出操作符 》吧，今天就补充一下其他的操作符的重载，其实都差不多，不过我感觉自己实际输入调试过后和没有调试只懂概念有个印象是完全不一样的。我一次把除了下标和成员访问操作符以外的操作符都写在下面这个例子里面，你自己分析和调试吧，我在主程序里面只调试了一部分。

例9.0:

```cpp
#include <string>  
#include <iostream>  
using namespace std;  
class Fruit               //定义一个类，名字叫Fruit  
{  
  double price;    //定义一个price成员表示价格  
  double weight;   //定义一个weight成员表示重量  
  string colour;   //定义一个colour成员表示颜色  
  string name;     //定义一个name成员表示名字    
  double conValue;  //定义一个conValue成员表示总价值  
public:  
  friend istream& operator>>(istream&,Fruit&);     //重载输入操作符  
  friend ostream& operator<<(ostream&,const Fruit&);  //重载输出操作符  
  Fruit& operator+=(const Fruit &orig)   //重载复合加法操作符，行为不知道怎么定义好，所以比较奇怪  
  {  
    if(name != orig.name)  
    {  
      name = name + " mix " \+ orig.name;  
    }  
    if(colour != orig.colour)  
    {  
      colour = colour + " mix " \+ orig.colour;  
    }  
    weight += orig.weight;  
    conValue += orig.conValue;   
    price = conValue / weight;  
    return *this;  
  }  
  friend Fruit operator+(const Fruit &lf,const Fruit &rf);  //重载加法操作符，必须要用友元，因为有两个操作数  
  Fruit& operator=(Fruit &orig)   //重载赋值操作符  
  {  
    name = orig.name;  
    colour = orig.colour;  
    price = orig.price;  
    weight = orig.weight;  
    conValue = orig.conValue;  
    return *this;  
  }  
  bool operator==(const Fruit &orig)//重载相等操作符  
  {  
    return conValue == orig.conValue;  
  }  
  bool operator!=(const Fruit &orig)//重载不等操作符  
  {  
    return !(*this == orig);  
  }  
  bool operator<(const Fruit &orig)  //重载小于操作符  
  {  
    return conValue < orig.conValue;  
  }  
  bool operator>(const Fruit &orig)   //重载大于操作符  
  {  
    return conValue > orig.conValue;  
  }  
  bool operator<=(const Fruit &orig)  //重载小于等于操作符  
  {  
    return *this<orig || *this==orig;  
  }  
  bool operator>=(const Fruit &orig)  //重载大于等于操作符  
  {  
    return *this>orig || *this==orig;  
  }  
  void print()              //定义一个输出的成员print()  
  {  
    cout<<weight<<" kilogram "<<colour<<" "<<name  
      <<" worth "<<conValue<<" yuan."<<endl;  
  }  
  Fruit(const double &dp,const double &dw,const string &cst = "green",/  
     const string &nst = "apple"):price(dp),weight(dw),colour(cst),name(nst)//构造函数  
  {  
    conValue = price * weight;  
  }  
  Fruit(const Fruit &orig)   //定义一个复制构造函数  
  {  
    name = orig.name;  
    colour = orig.colour;  
    price = orig.price;  
    weight = orig.weight;  
    conValue = orig.conValue;  
  }  
  ~Fruit()   //析构函数不需要定义，用系统的就好了  
  {  
  }   
};  
ostream& operator<<(ostream &out,const Fruit &s)  
{  
  cout<<s.weight<<" kilogram "<<s.colour<<" "<<s.name  
    <<" worth "<<s.conValue<<" yuan.";  
  return out;  
}  
istream& operator>>(istream& in,Fruit &s)   
{  
  cout<<"price:";  
  in>>s.price;  
  cout<<"weight:";  
  in>>s.weight;  
  cout<<"what:";  
  in>>s.colour>>s.name;  
  s.conValue=s.price*s.weight;  
  if(!in)  
    cerr<<"Wrong input!"<<endl;  
  return in;  
}  
Fruit operator+(const Fruit &lf,const Fruit &rf)   
{  
  Fruit ret(lf);  
  ret += rf;  
  return ret;  
}

int main()  
{  
  Fruit greenApple(3.0,10.0);  
  Fruit redApple(4.5,10.0,"red");  
  Fruit mixApple = greenApple + redApple;  
  if(greenApple == redApple)  
  {  
    cout<<"They are the same: ";  
  }  
  if(greenApple != redApple)       
  {  
    if(greenApple > redApple)  
      cout<<"biger: "<<greenApple<<endl;  
    if(greenApple < redApple)  
      cout<<"biger: "<<redApple<<endl;  
  }  
  cout<<greenApple<<endl;  
  cout<<redApple<<endl;  
  cout<<"mix: "<<mixApple<<endl;  
  
  return 0;  
}
```

程序很简单，注释也够多了，不多解释了，有些建议是要说的，两个形参的操作符就用友元函数吧，因为成员函数是有个隐藏形参this的，操作符之间可以互相调用以简化，比如operator+就用了operator+=,operator>=就用了operator>等，赋值操作记得返回对*this的引用，以方便连续使用比如a=b=c或者d+=e+=f。

假如你觉得a=b=c的形式还比较好理解，但是对d+=e+=f的形式很陌生，不知道怎么回事的话，我给出个例子。

例9.1：

```cpp
#include <iostream>  
using namespace std;  
int main()  
{  
  int a=1;  
  int b=3;  
  int c=4;  
  int d=6;  
  d+=a+=b+=c;  
  cout<<"a: "<<a<<endl  
    <<"b: "<<b<<endl  
    <<"c: "<<c<<endl  
    <<"d: "<<d<<endl;  
  return 0;  
}
```

你看到结果就会明白，+=操作符是从右读过来的，我们为什么要返回*this就很好理解了，我们实际就是返回左操作数。