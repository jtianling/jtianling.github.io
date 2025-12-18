---
layout: post
title: "浅谈C++类（6）--复制构造函数"
categories:
- C++
tags:
- C++
- "复制构造函数"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


还记得（1）中讲到的构造函数吗？复习一下，这次我们重载一个新的默认构造函数--即当你不给出初始值时调用的构造函数，我记得我讲过这个概念吧，有吗？看下面的例子。

例6.0

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  
  string name;     //定义一个name成员           
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
   cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst,const string &cst = "green"):name(nst),colour(cst)  //构造函数
  {
  name +="s";
  }
  Fruit(istream &is = cin)   //新的构造函数
  {
   is>>colour>>name;
  }
};
int main()
{
 Fruit apple("apple");  //定义一个Fruit类对象apple
 Fruit apple2;
 apple.print();
 apple2.print();
   
 return 0;
}
```

发现我重载的默认构造函数没有？这次利用的是默认形参(istream &is =cin)，学过io的就应该知道，他的意思表示，默认就是从标准设备输入（如键盘）。你运行下，就知道怎么回事了。现在我们讲一个新内容，复制构造函数，什么意思？先看下面的例子。

例6.1：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  
  string name;     //定义一个name成员           
  string colour;   //定义一个colour成员
public:
  void print()              //定义一个输出名字的成员print()
  {
   cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst,const string &cst = "green"):name(nst),colour(cst)  //构造函数
  {
  name +="s";
  }
  Fruit(){}
};
int main()
{
 Fruit apple("apple");  //定义一个Fruit类对象apple
 Fruit apple2(apple);//发现这里有什么问题没有？
 apple.print();
 apple2.print();
   return 0;
}
```

你会发现apple2也输出了green apples，为什么啊？（apple)和("apple")一样？你这这样理解可就错了，肯定不一样嘛。但是当我们使用Fruit apple2(apple);的时候调用了哪个构造函数呢？我们没有定义一个类似的构造函数啊？按道理应该编译失败，不是吗？恩，这里调用的构造函数就叫做复制构造函数，即用一个同样类型的对象构造另一个对象的构造函数,不过在这里，我们没有定义，所以由系统帮我们自动定义的，叫做默认复制构造函数。效果自然就是复制一下。你把第一个对象改成apple3你就会发现，apple2没有办法定义了，因为它调用的是复制Fruit对象apple的构造函数，而不是用字符串"apple"那个构造函数。C++ Primer这样定义复制构造函数，我引用一下“只有单个形参，而且该形参是对本类类型对象的引用（常用const修饰）”。我们来看看系统合成的默认复制构造函数的一个有趣应用：

例6.2：

```cpp
#include <iostream>
using namespace std;
class Aint
{
public:
 int aival[3];
};
int main()
{
 Aint as={1,2,3};
 cout<<as.aival[0]<<as.aival[1]<<as.aival[2]<<endl;
 Aint bs(as);
 cout<<bs.aival[0]<<bs.aival[1]<<bs.aival[2]<<endl;
 return 0;
}
```

很简单的例子吧，不过也很有趣，我们都知道，数组是没有办法通过等于来复制的，要复制只能利用循环遍历，我们自己定义了一个只包含整形数组的类，而当我们利用系统合成的默认复制构造函数的时候实现了数组的复制，注意，是一次性等于复制。呵呵。这也说明了一个问题，就是系统的默认复制构造函数在对付数组时，帮我们遍历复制了。现在我们自己定义一个复制构造函数。要说明的是，一般情况下系统定义的复制构造函数已经够用了，当你自己要定义的时候是想实现不同的功能，比如更好的处理指针的复制等，下面的例子只是看看用法，我也只讲用法而不讲究有没有实际意义。

例6.3：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
 string name;     //定义一个name成员           
 string colour;   //定义一个colour成员
public:
 void print()              //定义一个输出名字的成员print()
 {
  cout<<colour<<" "<<name<<endl;
 }
 Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst){}  //构造函数
 Fruit(Fruit &aF):name(aF.name),colour(aF.colour)            //这是我们自己定义的复制构造函数
 {
  name +="s";                //让他和默认的不同
 }
};

int main()
{
 Fruit apple;  //定义一个Fruit类对象apple
 Fruit apple2(apple);//调用的是我们自己定义的复制构造函数

 apple.print();
 apple2.print();          //你会发现输出多了个's'
 return 0;

}
```

这里你会看到我们自己定义的复制构造函数的作用，直观的看到apple只输出green apple,而apple2输出green aples，要说明的是，这也是复制构造函数也是构造函数，也可以用初始化列表，而且在C++ Primer中还推荐你使用初始化列表。下面我们看看，假如你向让你的类禁止复制怎么办啊？很简单，让你的复制构造函数跑到private里面去，这时候友元和成员还可以使用复制，那你就光声明一个复制构造函数，但是，你不定义它，在C++里面，光声明不定义一个成员函数是合法的，但是，使用的话就会导致编译失败了，（普通函数也是这样）通过这种手段，你就能禁止一切复制的发生了（其实是发现一切本需要复制构造函数的地方了）。见下例。

例6.4：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
 string name;     //定义一个name成员           
 string colour;   //定义一个colour成员
public:
 void print()              //定义一个输出名字的成员print()
 {
  cout<<colour<<" "<<name<<endl;
 }
 Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
 {}  //构造函数
private:
 Fruit(Fruit &aF);        //把它定义在private下
};
int main()
{
 Fruit apple("apple");  //定义一个Fruit类对象apple
// Fruit apple2(apple);   //你这样的尝试会导致编译失败的，cannot access private 错误   
 apple.print();
 return 0;
}
```

在犯了一个我半天也没有发现的错误的后，我发现了，当利用形如Fruit apple2 = apple方式来定义并初始化一个对象的时候，调用的也是复制构造函数，详情请见那个帖子《[警惕！C++里面“=”不一定就是等于（赋值）。 ](<http://www.jtianling.com/archive/2007/04/28/1588984.aspx>)》
