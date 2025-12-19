---
layout: post
title: "浅谈C++类（7）--析构函数"
categories:
- C++
tags:
- C++
- "析构函数"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

不知不觉我都写了6讲了，的确这样讲出来的学习才能迫使我真的去调试每个书上出现的代码，去想些自己能讲出什么新的书上没有的东西，这才是真的学习吧，以前看完书，做道题式的就以为自己基本都掌握了，在类这里好像行不通，因为我的C基础不适合这里。。。。呵呵不说题外话了。这次讲析构函数，相对于构造函数。析构函数就是在类的声明周期结束的时候运行的函数，一般用来把一个类的资源释放出来的家伙。就我了解，JAVA好像不需要这样的工作，他们有垃圾回收器，我看一个比较理性的程序员评价这种情况是有利有弊，类似的简化让JAVA成为了最佳商业模式开发软件，但是让JAVA程序员太脱离底层，让他们的知识匮乏，因为编JAVA不需要那么多知识，而且让JAVA失去了很多底层应用。另外这样的垃圾回收是耗资源的，当时Bjarne Strooustrup就考虑过也给C++加一个这样的特性，但他又说，作为一个系统开发级及常用来开发驱动程序的语言，他无法接受那样的效率损失。所以最后C++没有加上这个特性。又讲多了，看析构函数吧。

<!-- more -->

例7.0：

```cpp
#include <string>
#include <iostream>
using namespace std;
bool being = true;                 //定义一个全局bool变量
class Fruit                       //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
  {
    being = true;                          //表示这个东西存在
  } //构造函数
  ~Fruit()                        //这就是传说中的析构函数
  {
    being = false;                       //表示他不存在了
  }
};
int main()
{
  {
    Fruit apple("apple");  //定义一个Fruit类对象apple
    cout <<"apple being?: "<<being<<endl;
  }
  cout <<"apple being?: "<<being<<endl;
  return 0;
}
```

首先看到不要惊讶 ：），我们的构造函数和析构函数都作了些什么啊。我说过构造函数就是构造一个类对象会运行的函数，析构函数就是类生命周期结束时运行时运行的函数，不仅仅是我们的一般理解啊，从逻辑上来讲，他们可以DO Everything，你首先要知道他们能干什么啊：）而且还要知道他们什么时候起作用，因为我们用一个大括号把apple的定义括起来了，在大括号消失的时候，apple就需要消失了，于是这时候调用了析构函数。下面我们先看看可以做什么的例子。

例7.1：

```cpp
#include <string>
#include <iostream>
using namespace std;
bool being = true;
class Fruit                       //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
  {
    being = true;
    cout <<"Aha,I'm "<<name<<". I have created!"<<endl;
  } //构造函数
  ~Fruit()
  {
    being = false;
    cout <<"Dame it!"<<"I'm "<<name<<". And who killed me?"<<endl;
  }
};
int main()
{
  {
    Fruit apple("apple");  //定义一个Fruit类对象apple
    cout <<"apple being?: "<<being<<endl;
  }
  cout <<"apple being?: "<<being<<endl;
  return 0;
}
```

你运行看看，就知道了：）在一个对象定义的时候他会高呼自己被创造了，当他消失的时候他会宣布自己的死亡：）好的，Fruit的对象看起来已经知道自己什么时候有生命了，让我们来看看到底什么时候吧。

例7.2：

```cpp
#include <string>
#include <iostream>
using namespace std;
bool being = true;
class Fruit                       //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
  {
    being = true;
    cout <<"Aha,I'm "<<name<<". I have created!"<<endl;
  } //构造函数
  ~Fruit()
  {
    being = false;
    cout <<"Dame it!"<<"I'm "<<name<<". And who killed me?"<<endl;
  }
};
Fruit banana("banana");
void Fb()
{
  cout<<"我是一个函数的开始"<<endl;
  Fruit pear("pear");
  cout<<"我是一个函数的结束"<<endl;
}

int main()
{
  cout<<"我是程序的开始"<<endl;
  Fb();
  cout<<"我是for循环的开始"<<endl;
  for(bool bi = true;bi;bi=false)
  {
    Fruit orange("orange");
    cout<<"我是for循环的结束"<<endl;
  }
  {
    cout<<"我是语句块的开始"<<endl;
    Fruit apple;  //第一种情况，语句块中创建。
    cout<<"我是语句块的结束"<<endl;
  }
  cout<<"我是程序的结束"<<endl;
  return 0;
}
```

就这个程序运行的情况来看，一个类的生命周期和一个普通变量的生命周期类似，全局变量最先创建，程序结束时结束，函数体内的变量调用时创建，函数结束时结束，for循环内的变量在for循环结束时结束，语句块内的变量在语句块结束时结束。本来Bjarne stroustrup就宣称他希望让类就像内置类型一样使用，看来他不是说着好玩的：）这里要说明的是，即使你没有定义析构函数，系统也会像定义默认构造函数一样帮你定义一个。让我们看看什么时候需要析构函数呢？

例7.3：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit                       //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
  {
    cout <<"Aha,I'm "<<name<<". I have created!"<<endl;
  } //构造函数
  Fruit(Fruit &aF)           //还记得我吗?我是复制构造函数
  {
    name = "another " +aF.name;
  }
  ~Fruit()
  {
    cout <<"Dame it!"<<"I'm "<<name<<". And who killed me?"<<endl;
  }
};

int main()
{
  cout<<"main begin"<<endl;
  cout<<"created *P"<<endl;
  {
    Fruit *p = new Fruit;
    cout<<"created another apple"<<endl;
    Fruit apple(*p);
  }

  cout<<"main end"<<endl;
  return 0;
}
```

运行这个程序你发现什么了？对，首先，运行复制构造函数就不运行构造函数了，因为another apple没有宣布自己的诞生，其次，当语句块消失的时候another apple自动调用了析构函数，他宣布他“死”了，但是动态创建的由*p指向的对象虽然宣布自己诞生了，但是却重来没有宣布自己死过，哪怕程序结束了也是这样！！不知道vc有没有回收内存的措施，不然我甚至怀疑你要是重复调试这个程序，可以使你的机子崩溃，当然，假如可以的话将不知道需要多少次，但是理论上确实可以的。这就是内存泄露！作为一个C++程序员，需要了解的东西比一个JAVA程序员要多的多，回报是你能做的事情也多地多！这就是你需要记住的一个，动态创建的对象，记得手动把它撤销。就像下面的例子一样。

例7.4：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit                       //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
  {
    cout <<"Aha,I'm "<<name<<". I have created!"<<endl;
  } //构造函数
  Fruit(Fruit &aF)           //还记得我吗?我是复制构造函数
  {
    name = "another " +aF.name;
  }
  ~Fruit()
  {
    cout <<"Dame it!"<<"I'm "<<name<<". And who killed me?"<<endl;
  }
};

int main()
{
  cout<<"main begin"<<endl;
  cout<<"created *P"<<endl;
  {
    Fruit *p = new Fruit;
    cout<<"created another apple"<<endl;
    Fruit apple(*p);
    cout<<"delete p"<<endl;
    delete p;
  }

  cout<<"main end"<<endl;
  return 0;
}
```

这样才能保证你的机子不会崩溃。当你删除指针的时候系统帮你自动调用了对象的析构函数，假如上面的例子还不能摧毁你对自己自己内存足够大的信心的话，看下面的例子；

例7.5：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit                       //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
  {
    cout <<"Aha,I'm "<<name<<". I have created!"<<endl;
  } //构造函数
  Fruit(Fruit &aF)           //还记得我吗?我是复制构造函数
  {
    name = "another " +aF.name;
  }
  ~Fruit()
  {
    cout <<"Dame it!"<<"I'm "<<name<<". And who killed me?"<<endl;
  }
};

int main()
{
  cout<<"main begin"<<endl;
  cout<<"created *P"<<endl;
  {
    Fruit *p = new Fruit[10];
    cout<<"created another apple"<<endl;
    Fruit apple(*p);
    cout<<"delete p"<<endl;
    delete []p;
  }

  cout<<"main end"<<endl;
  return 0;
}
```

你会发现创建一个对象的数组时，分别为每一个调用了构造函数，删除一个动态数组对象的时候系统帮你自动为每一个调用了析构函数，还不了赖嘛，但是别忘了p前面的[]表示这是个数组，更别忘了删除它，你可以把10改成更大的数并不删除它来尝试一下，呵呵。析构函数就讲到这里罗。
