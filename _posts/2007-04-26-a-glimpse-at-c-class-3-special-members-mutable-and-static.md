---
layout: post
title: "浅谈C++类（3）--两个特殊成员mutable与static成员"
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

这一次讲我一直没有怎么搞明白的两个特殊类成员，mutable,static。

接着第（1）次的内容，从水果讲起。我们希望有一个成员总是可以被修改，即mutable。哪怕他是const成员函数都可以修改，这种需要感觉还是比较少有。不过我们可以看看例子。

例3.0：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员           
  string colour;   //定义一个colour成员
  mutable double price;   //这是一个新成员，mutable的成员
public:
  void chaPri(const double &newpri)const     //这是一个const成员函数
  {
    price = newpri;
  }
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<" is priced at "<<price<<endl;
  }
  Fruit(const string &nst,const string &cst = "green",const double &newpri = 0.0):name(nst),colour(cst),price(newpri)  //构造函数
  {}
  Fruit(){}
};
int main()
{
  Fruit apple("apple");  //定义一个Fruit类对象apple
  apple.chaPri(10.0);       //看到没有？这里用const成员函数改变了price
  apple.print();         //为什么可以这样？因为price是mutable的
    return 0;
}
```

当然这里的例子没有什么实际意义，因为不把chaPri（）函数定为const就可以不用mutable了，在C++ Primer中提到实际的使用是在一个const成员函数需要统计自己调用的次数时，可以使用这个计数。假如你还没有明白mutable的作用的话，你把mutable去掉试试，看看编译错误的提示，我用vc++2005得出的是error C2166: l-value specifies const object，不太懂什么意思，大概就是说const成员函数不能利用左值修改成员。也不知道到底是什么意思。

现在讲讲static，static在C里面就有，在讲静态局部变量的时候讲了，大概就是生命周期是全局的这么一个概念，在类里面用static定义的成员，叫类静态成员。我们看看他到了类里面是怎么样的。首先有个心理准备，这是我目前见过的最扭曲不合情理思维方式的东西。

例3.1 ：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员           
  string colour;   //定义一个colour成员
  static string beFrom;    //定义一个static数据成员
public:
  static string whFrom()          //定义一个static成员函数
  {
    return beFrom;
  }  

  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst,const string &cst = "green"):name(nst),colour(cst)  //构造函数
  {}
  Fruit(){}
};
string Fruit::beFrom = "Hunan";      
//必须在类外部定义一次（也只能一次），而且此时初始化
int main()
{
  Fruit apple("apple");  //定义一个Fruit类对象apple
  apple.print();
  cout<<apple.whFrom()<<endl;

    return 0;
}
```

首先，扭曲之一，你不能直接使用，还需要在类外面定义一次。扭曲之二，你不能在main()函数里面定义，那样是重复定义错误，必须在main()函数外面定义。扭曲之三，初始化不能在构造函数中进行，必须在第2次定义时进行。（其实这里看来，类里面那次定义应该看作声明)。这几点扭曲的地方让我百思不得其解，理解了n久也没有太明白到底怎么使用才能减少错误。你有什么高见，请一定告诉我。这里还有个为static准备的特例，也就是可以当他为整形，并且声明为const的时候，他可以在类定义时就初始化，这点非static成员和非整形成员是无论如何也不可以的。见例子。

例3.2：  

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员           
  string colour;   //定义一个colour成员
  static const int size = 10;    //定义一个const 整形 static数据成员
public:
  static int reSize()          //定义一个static成员函数
  {
    return size;
  }  

  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst,const string &cst = "green"):name(nst),colour(cst)  //构造函数
  {}
  Fruit(){}
};
int main()
{
  Fruit apple("apple");  //定义一个Fruit类对象apple
  apple.print();
  cout<<apple.reSize()<<endl;

  
    return 0;
}
```

这里扭曲的地方又多了，扭曲一：const static成员在类的定义体中初始化够特殊了吧？更特殊的是，只能是整形才能这样特殊，你试试，string什么的都不可以，int,long 等整形才可以。扭曲二 ：在C++ Primer 第4版原版第470面，中文版第401面，明确提示，就算是这样初始化了，在类的定义体外使用前，必须还要定义一次，而实际上根本不需要了就可以使用，假如你认为我这个例子是用了成员函数间接调用的不可靠的话，你直接把他改为public直接调用看看，也可以的。我还为了预防最经常使用的C++.net2005不合标准，我用dev-c++4.990得出一样的结论。我一直把C++Primer看作经典，我有时宁愿怀疑是microsoft的编译器不合标准，也不怀疑书的错误，可是我又一次错了（我的书已经在网上下过最新的勘误表并改正过），前一次的错误是在第11章，泛型算法，原书第421面，中文版361面的list容器特有的操作表。lst.splice(iter,beg,end)根本就是错误，这里必须要指出第2个容器，即实际使用方法为lst.splice(iter,lst2,beg,end)，大家可以去验证一下，在C++程序设计语言（Bjarne Stroustrup)里面我得到了正确答案，以前调试不成功我也怀疑过VC，不过VC还是对的。

下面我们来看几个static的使用，虽然我一直不太喜欢使用这种特殊化，扭曲化的东西，不过了解一下还是好的。

例3.3：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员           
  string colour;   //定义一个colour成员
  
public:
  static string beFrom;    //定义一个static数据成员
  static string whFrom()          //定义一个static成员函数
  {
    return beFrom;
  }  

  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst,const string &cst = "green"):name(nst),colour(cst)  //构造函数
  {}
  Fruit(){}
};
string Fruit::beFrom("Hunan");        //注意初始化的是Fruit类的beFrom
int main()
{
  Fruit apple("apple");  //定义一个Fruit类对象apple
  Fruit banana("banana","yellow");
  apple.print();
  cout<<"come from " <<Fruit::whFrom()<<endl;//这里没有什么问题；
  banana.print();
  cout<<"come from " <<apple.whFrom()<<endl;
  //apple对象的成员beFrom也一样，因为static成员是属于大家的
  apple.beFrom = "Hubei";   //改变apple对象的beFrom
  banana.print();
  cout<<"come from " <<banana.whFrom()<<endl;//你会发现其实改变了大家的beFrom

    
    return 0;
}
```

大概就这样了，你理解了一点没有？我还是没有理解。。。。。。。

今天在Trackback: <http://tb.blog.csdn.net/TrackBack.aspx?PostId=1586006> 看到作者提出effective C++中提出了这个static，“今天看effective c++,发现一个有趣的东东，就是关于一个static的用法，以前没有怎么在实际工作中用到。使用static定义成员函数的含义，整个类只有这个成员的一份拷贝，并且这个成员可以不通过类的具体对象来访问。也就是说用static定义的成员函数可以当成全局函数使用，太好用了，太伟大了，c++,我爱你！！！！！”可以看出作者的高兴之情，问题是，我也知道这个复杂扭曲的东西是设计来干什么的，不过我却觉得不需要这样设计，使用起来太复杂了。当然，这只是一个初学者的看法。
