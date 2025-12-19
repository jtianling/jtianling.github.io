---
layout: post
title: "浅谈C++类（2）--一个简单的多文件具体例子"
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
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

通过C++ Person类实例，讲解类的封装、声明与实现分离，以及const成员函数等面向对象基础。

<!-- more -->

上一次讲了一些基本的概念，这次分析一个稍微复杂但其实还是很简单的例子。现看定义：

Person.h

```cpp
#include <map>
#include <string>

class Person
{
public:
    Person(const std::string &,const std::string &);
    Person(){};

    void print(const std::string &) const;    //声明一个const成员函数输出
    void print();
    void input(const std::string &,const std::string &);
private:
    std::map<std::string,std::string> aperson;
};
```

Person.cpp

```cpp
#include "Person.h"
#include <iostream>
#include <iterator>
#include <algorithm>

Person::Person(const std::string &name,const std::string &adress)  //一个构造函数
{
    aperson[name] = adress;
}

void Person::print(const std::string &name) const      //定义了一个const成员函数，输出
{
    std::map<std::string,std::string>::const_iterator it = aperson.find(name);

    //在aperson中查找key name
    if(it != aperson.end())                            //假如有就输出
    {
        std::cout<<it->first<<"'s adress is "<<it->second<<std::endl;
    }
    else
    {
        std::cout<<"there is no this person called"<<name<<std::endl;
    }
}
void Person::print()                               //重载一个输出，没有参数就输出所有的值
{
    for(std::map<std::string,std::string>::iterator it =aperson.begin(); //遍历aperson
        it != aperson.end();++it)
    {
        std::cout<<it->first<<" in "<<it->second<<std::endl;
    }
}

void Person::input(const std::string &name, const std::string &adress)

         //用input管理输入
{
    aperson[name] = adress;          //有就改名，没有就增加一个，利用map下标的特点
}
```

这个类使用的方法具体可以参考下面，你也可以自己试试：

```cpp
#include "Person.h"
#include <string>

int main()
{
    Person abook("jack","Guanzhou");
    abook.input("jim","Beijing");
    abook.input("tom","Hunan");
    abook.print("jack");

    return 0;
}
```

在这里注意，和以前说的不同的是，类的被分开放在两个文件中，而且，类中的函数都在类定义外面定义，这里这样做是因为既然要封装，那么类的使用者就没有必要知道第2个文件，知道第一个文件就够了，只要你详细说明了每个函数的实际用途，类的使用者可以不关系他的具体实现，节省时间和精力。这是雷同于C中编写不同的函数的程序员之间也不需要实际了解那个函数具体怎么实现的一样，C就是这样实现结构化编程的，而C++就是通过这样写类，来实现面向对象编程的。在类外定义类的成员函数，你必须指明，这个函数是某个类的函数，通过符号“：：”，在上面的例子中很明显。另外，所谓的const成员函数，表示这个函数不能更改类中的数据，在声明及定义中都必须加上const.public下的东西可以公共访问，所以被叫做一个类的接口，什么叫接口？就是和外部产生联系所需要的东西。private下的别人就不需要了解了，叫封装，也是一种黑盒原理。可以看到，这里有2个接口函数，print(),input()；其中print()有一个重载版本。还有1个重载的构造函数。看名字都很好理解。数据中就定义了 一个由2个string组成的map。这里把类的定义放在一个单独的头文件里面，所以都用了std::而没有用using namespace std，因为头文件中最好不要用这个。其实在小程序中倒也无所谓。
