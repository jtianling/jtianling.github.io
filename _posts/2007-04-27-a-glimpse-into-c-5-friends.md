---
layout: post
title: "浅谈C++类（5）--友元"
categories:
- C++
tags:
- C++
- "友元"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '15'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍了C++的友元(friend)，它能让外部函数或类访问私有成员。文章通过示例讲解了其用法，并讨论了这种打破封装机制的利弊。

<!-- more -->

呵呵，又来了，自从我开始尝试描述类以来，我发现我自己是开始真的了解类了，虽然还不到就明白什么叫oo的高深境界，起码对于类的使用方法了解的更多了，希望你看了以后也能有所进步啊：）

现在开始讲一个有利有弊的东西，友元(friend),我以前讲过了private的数据和函数别人是不能直接调用的，这一点对于封装起到了很重要的作用。但是有的时候总是有调用一个类private成员这样需要的，那怎么办呢？C++给了我们友元这个家伙，按我的习惯，首先看个例子。当然，还是我们的水果类：）

例5.1：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
 string name;     //定义一个name成员
 string colour;   //定义一个colour成员
 friend bool isSame(Fruit &,Fruit &);   //在这里声明friend友元函数
public:
 void print()              //定义一个输出名字的成员print()
 {
  cout<<colour<<" "<<name<<endl;
 }
 Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst){}  //构造函数
  
 Fruit(){}
};
bool isSame(Fruit &aF,Fruit &bF)
{
 return aF.name == bF.name;        //注意，这个函数调用了Fruit的private数据，本来可是不允许的．
}
int main()
{
 Fruit apple;
 Fruit apple2(apple);
 Fruit orange("orange","yellow");
 cout<<"apple = orange ?: "<<isSame(apple,orange)<<endl;

 cout<<"apple = apple2 ?: "<<isSame(apple,apple2)<<endl;
  
    return 0;
}
```

这里，我们声明了一个isSame（）检测是否同名的函数，而且这不是Fruit类的一个函数，虽然他在类里面声明了，怎么看出来？假如是类的成员函数，在外部定义必须要Fruit::这样定义，不是吗？isSame()没有这样，他是个独立的函数，但是他可以调用Fruit类的私有成员，因为在类里声明了他是Friend的，这就像你告诉保安（编译器）某某（isSame)是你的朋友（friend)，然后让他可以进入你的家（调用私有成员）一样，别人就不允许（非友元函数不允许），这样说，够明白吗？你可以尝试去掉friend声明看看编译错误。证明friend的作用：）我这里的得出的编译错误是这样（error C2248: 'Fruit::name' : cannot access private member declared in class 'Fruit'），也就是name是私有成员，不能调用。不仅可以声明友元函数，还可以声明友元类。效果类似。看下面的例子。

例5.2：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
 string name;     //定义一个name成员
 string colour;   //定义一个colour成员
 friend class Person;        //声明一个友元类Person
public:
 void print()              //定义一个输出名字的成员print()
 {
  cout<<colour<<" "<<name;
 }
 Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst){}  //构造函数
  
};
class Person             //定义类Person
{
string likedFruit;
public:
 string name;
 bool isLike(Fruit &aF)
 {
  return likedFruit == aF.name;                //注意，他调用了Fruit类的私有成员，这本来是不允许的
 }
 Person(const string &npe = "jim",const string &lF = "apple"):name(npe),likedFruit(lF){}
};
int main()
{
 Fruit apple;
 Fruit orange("orange","yellow");
 Person jim;
 cout<<"Is "<<jim.name<<"like ";
 apple.print();
 cout<<"? : "<< jim.isLike(apple)<<endl;     //看看这个函数的调用

   
    return 0;
}
```

```cpp
bool isSame(Fruit &aF,Fruit &bF,Fruit &cF)
{
 return (aF.name == bF.name)&&(bF.name == cF.name);
}
```

具体Person类和程序到底是什么意思，我想只要你看了我以前写得东西，应该很明白了，就不多注释和讲了，我现在主要是讲友元(friend)的用途。另外一点重载函数的话，你想让几个成为友元就让几个，其他的将不是友元函数，这里提醒一下，重载函数其实可是各自独立的函数，只不过在C++中为了调用方便，让他们叫同一个名字而已。你不相信，可以自己试试。比如说在例5.1中，假如你重载一个但是却不声明为友元，编译是通不过的。你必须这样各自声明。见下例。

例5.3：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
 string name;     //定义一个name成员
 string colour;   //定义一个colour成员
 friend bool isSame(Fruit &aF,Fruit &bF);                          //声明为友元
 friend bool isSame(Fruit &aF,Fruit &bF,Fruit &cF);         //再次声明为友元

public:
 void print()              //定义一个输出名字的成员print()
 {
  cout<<colour<<" "<<name;
 }
 Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst){}  //构造函数
  
};
bool isSame(Fruit &aF,Fruit &bF)
{
 return aF.name == bF.name;
}
bool isSame(Fruit &aF,Fruit &bF,Fruit &cF)
{
 return (aF.name == bF.name)&&(bF.name == cF.name);
}

int main()
{
 Fruit apple;
 Fruit apple2;
 Fruit apple3;
 Fruit orange("orange","yellow");
 cout<<isSame(apple,apple2)<<isSame(apple,apple2,orange)<<endl;

 return 0;
}
```

现在再回过来看例4.0。

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

除了隐式类类型转换外你还发现什么没有？恩，就是isSame（）函数他直接调用了另一个引用的Fruit对象的私有成员name，这个按道理是不允许的啊，不过，注意的是，他本身就是Fruit类，所以，我个人看法（纯粹个人看法），这里可以认为一个类，自动声明为自己类的友元。呵呵，不知道对不对。假如你想这样定义，

```cpp
bool Fruit::isSame(const string &otherName)
{
  return name == otherName;
}
```

然后这样调用， cout<<apple.isSame(apple2.name)<<endl;结果是通不过编译的，道理还是不能调用一个类的私有成员。最后要说的是，我以前以为友元虽然为我们带来了一定的方便，但是友元的破坏性也是巨大的，他破坏了类的封装，不小心使用的话，会打击你对C++类安全使用的信心，就像强制类型转换一样，能不用就不用。但是当我看了Bjarne Stroustrup 的书后，才理解了一些东西，他的意思就是友元是没有人们说的那样的破坏性的，因为友元的声明权完全在类设计者手里，他能很好控制，而不会让友元的特性泛滥，而且在我学的更多一些后，发现友元在一些应用中必须得用到，比如一些操作符的重载，不用友元就不行，虽然个人感觉，类中成员函数省略的This形参假如没有友元作补充支撑，根本就不敢用，因为会限制很多功能，当然有了友元就没有关系了，可以在外面定义嘛。友元就讲了这么多，不知道是不是复杂化了。
