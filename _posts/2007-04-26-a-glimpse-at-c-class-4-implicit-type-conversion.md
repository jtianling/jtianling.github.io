---
layout: post
title: "浅谈C++类（4）--隐式类类型转换"
categories:
- C++
tags:
- C++
- "隐式类型转换"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '21'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

老规矩，看个例子，知道我要说的是什么。

例4.0：

```cpp
#include <string>  
#include <iostream>  
using namespace std;  
class Fruit               //定义一个类，名字叫Fruit  
{  
 string name;     //定义一个name成员           
 string colour;   //定义一个colour成员  
   
public:  
 bool isSame(const Fruit &otherFruit)   //期待的形参是另一个Fruit类对象，测试是否同名  
 {  
  return name == otherFruit.name;  
 }  
 void print()              //定义一个输出名字的成员print()  
 {  
  cout<<colour<<" "<<name<<endl;  
 }  
 Fruit(const string &nst,const string &cst = "green"):name(nst),colour(cst){}  //构造函数  
   
 Fruit(){}  
};

int main()  
{  
 Fruit apple("apple");  
 Fruit orange("orange");  
 cout<<"apple = orange ?: "<<apple.isSame(orange)<<endl;  //没有问题，肯定不同  
 cout<<"apple = /"apple/" ?:"<<apple.isSame(string("apple")); //用一个string做形参？  
   
     return 0;  
}
```

你会发现最后的使用上，我们用一个string类型作一个期待Fruit类形参的函数的参数，结果竟然得出了是true（1），不要感到奇怪，这就是我现在要讲的东西，隐式类类型转换：“可以用单个实参来调用的构造函数定义了从形参类型到该类型的一个隐式转换。”（C++ Primer)首先要单个实参，你可以把构造函数colour的默认实参去掉，也就是定义一个对象必须要两个参数的时候，文件编译不能通过。然后满足这个条件后，系统就知道怎么转换了，不过这里比较严格：）以前我们构造对象的时候Fruit apple("apple")其实也已经有了一个转换,从const char *的C字符串格式，转为string，在这里，你再apple.isSame("apple")的话，蠢系统不懂得帮你转换两次，所以你必须要用string（）来先强制转换，然后系统才知道帮你从string隐式转换为Fruit，当然其实你自己也可以帮他完成。cout<<"apple = /"apple/" ?:"<<apple.isSame(Fruit("apple"));这样。参考例子1.2 ：Fruit apple = Fruit("apple");  //定义一个Fruit类对象apple。也就是这样转换的。不过这就叫显式转换了，我们不标出来，系统帮我们完成的，叫隐式的贝。这里要说的是，假如你显示转换就可以不管有多少参数了，比如在前面提到的必须需要两个参数的构造函数时的例子。

例4.1：

```cpp
#include <string>  
#include <iostream>  
using namespace std;  
class Fruit               //定义一个类，名字叫Fruit  
{  
 string name;     //定义一个name成员           
 string colour;   //定义一个colour成员  
   
public:  
 bool isSame(const Fruit &otherFruit)   //期待的形参是另一个Fruit类对象，测试是否同名  
 {  
  return name == otherFruit.name;  
 }  
 void print()              //定义一个输出名字的成员print()  
 {  
  cout<<colour<<" "<<name<<endl;  
 }  
 Fruit(const string &nst,const string &cst):name(nst),colour(cst){}  //构造函数  
   
 Fruit(){}  
};

int main()  
{  
 Fruit apple("apple","green");  
 Fruit orange("orange","yellow");  
 cout<<"apple = orange ?: "<<apple.isSame(orange)<<endl;  //没有问题，肯定不同  
 cout<<"apple = /"apple/" ?:"<<apple.isSame(Fruit("apple","green")); //显式转换  
    return 0;  
}
```

在你不想隐式转换，以防用户误操作怎么办？C++提供了一种抑制构造函数隐式转换的办法，就是在构造函数前面加explicit关键字，你试试就知道，那时你再希望隐式转换就会导致编译失败，但是，要说明的是，显式转换还是可以进行，出于不提供错误源代码例子的原则，错误的情况就不提供了，自己试试吧：）在说这个东西之前，我还不懂，现在我懂了：）我现在好像都习惯边学边讲了，有什么错误，你可要指出来啊。
