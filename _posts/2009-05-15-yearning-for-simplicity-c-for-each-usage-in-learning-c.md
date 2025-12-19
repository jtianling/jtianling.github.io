---
layout: post
title: "多想追求简洁的极致，但是无奈的学习C++中for_each的应用"
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
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

文章对比了C++与其他语言的循环语法，指出C++缺少原生for each，使用for_each算法和函数对象等方法实现循环，过程繁琐复杂，牺牲了代码的简洁性。

<!-- more -->

# 多想追求简洁的极致，但是无奈的学习C++中for_each的应用

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****


for each语法是方便的，也是很自然的，这也是为什么很多语言都有这样的语法，就我所知，包括java(jdk5.0以上),python,php,asp.net等语言都有类似的语法，甚至微软为C++/CLI中也添加了这样的语法。但是很遗憾的是，C++98标准中没有，于是，我们只能通过可悲的for_each算法去模拟。。。。。。。。。。先看看原生的语法是多么方便和自然的吧，虽然有人将其视为语法糖，但是，就算是糖，这也是很甜的那种。

先看看Python中的循环，虽然不是for each，但是类似于。

```python
l = [1,2,3,4,5]

for i in l:
    print i
```

简洁，干净，

假如你有幸使用微软的托管C++，你可以使用类似的语法：

```cpp
using namespace System;

#include <list>
#include <iostream>

using namespace std;

int main() 
{
    int a[5] = {1,2,3,4,5};
    list<int> l(a, a+5);

    for each ( int i in l)
       Console::Write(i);

    system("PAUSE");
}
```

虽然作为强类型语言，在声明方面稍微复杂点，循环的处理还是那么简洁，干净。

再来看看现有的C++中的：

```cpp
#include <list>
#include <iostream>

using namespace std;

int main() 
{
    int a[5] = {1,2,3,4,5};
    list<int> l(a, a+5);

    // 同样是需要输出
    for(list<int>::const_iterator lit = l.begin(); lit != l.end(); ++lit)
    {
       cout <<*lit <<endl;
    }

    system("PAUSE");
}
```

繁复到我都不想说了，list<int>::const_iterator似的迭代器声明语法不符合一处定义的原则，冗余信息太多。（C++09添加的auto用法就是解决此问题的），即便是解决了此问题，还是会发现，在C++中写个循环比在python（仅仅是一个例子，其他有类似for each特性的语言都比C++简单）中复杂太多了。而循环实在是太过于常见的语法了，所以一次又一次使用这种本可以简单，但是受限于语法而搞得这么复杂的C++可怜语法的时候，我总是忍不住想要吐血。对于这么简单的例子，我们是可以找到一些方法来稍微简化一点的。没有for each语法，我们起码还有for_each算法-_-!

于是可以这样：

```cpp
#include <list>
#include <iostream>
#include <algorithm>

using namespace std;

void printInt(int i)
{
    cout <<i <<endl;
}

int main() 
{
    int a[5] = {1,2,3,4,5};
    list<int> l(a, a+5);

    // 同样是需要输出
    for_each(l.begin(), l.end(), ptr_fun(printInt));

    system("PAUSE");
}
```

在加大了理解难度后（本来for each语法多简单啊，现在还要理解ptr_fun这样的函数对象生成的辅助函数），我们的循环是稍微简单一点了，虽然在这个例子中我们甚至要额外写函数-_-!虽然说函数可以只写一次，循环可是常常用的啊。

对于这样简单的例子，已经可以看出没有for_each语法的痛苦了，再复杂一点的例子

对于类成员函数的调用，看看有for_each的情况

python中：

```python
**class**  Add():  
    **def**  __init__(self, i):  
        self._i = i  
    **def**  add(self):  
        self._i += 1  
    **def**  __str__(self):  
        **return**  str(self._i)  
      
s = [Add(1), Add(2), Add(3)]

**for**  a **in**  s:  
    a.add()

**for**  a **in**  s:  
    **print**  a
```

这里拆分成两个函数，可以看出我的无奈，想要在一个for_each语法中连续调用两个函数的方法。。。。目前只有再写一个函数，而这个函数的作用就是仅仅调用这两个函数提供给for_each使用。不说这些丧气+无奈的话了，光是调用一个类的成员函数的可能还是有的。

C++中：

```cpp
#include <list>
#include <iostream>
#include <algorithm>
#include <cstdio>

using namespace std;

void printInt(int i)
{
    cout <<i <<endl;
}

class CAdd
{
public:
    CAdd(int ai):mi(ai) { }

    void add() { ++mi; }

    operator int() { return mi;}
    int mi;
};

int main() 
{
    CAdd a[3] = { CAdd(1), CAdd(2), CAdd(3)};
    list<CAdd> l(a, a+3);

    // 同样是需要输出
    for_each(l.begin(), l.end(), mem_fun_ref(&CAdd::add));
    for_each(l.begin(), l.end(), ptr_fun(printInt));

    system("PAUSE");
}
```

为了实现循环的简洁，重新引入了新的复杂度，mem_fun_ref，希望一般的C++程序员见过这样的函数对象辅助函数。。。。还多了类似&CAdd::add这样的成员函数指针的语法，希望一般的程序员也能理解。。。。（不提有for each语法的语言中除了for each这样自然的语法外，做多复杂的运算都没有引入任何新的复杂度），最主要的是，你想要在一条for_each中实现两个函数的调用，你除了老老实实的实现一个新的函数外，就是像我这样了，调用for_each两次，两种方法都是不那么容易让人接受。。。。。。。。但是，在现有的C++中，我们也就只能做到这样了。既然用C++，就接受现实吧。其实，显示远比一般人想象的要复杂。

以上情况还是函数没有参数的时候，当函数有参数的时候，新的问题又来了。

看看python中这样一个简单的功能：

```python
**def**  add(a,b):  
    **return**  a + b

l = [1,2,3,4,5]  
**for**  i **in**  l:  
    **print**  add(i,1)
```

无非就是在每个输出的函数中调用一个函数，没有任何值的一提的地方，是个人就能看懂。

在C++需要实现成下面这个样子：

```cpp
#include <list>
#include <iostream>
#include <algorithm>
#include <functional>

using namespace std;

template <typename T>
class Add : public binary_function<T, T, void>
{
public:
    void operator()(const T& ai, const T& aj) const
    {
       cout <<(ai \+ aj) <<endl;
    }

};

int main() 
{
    int a[5] = {1,2,3,4,5};
    list<int> l(a, a+5);

    for_each(l.begin(), l.end(), bind2nd(Add<int>(), 1));

    system("PAUSE");
}
```

到这一步，我希望大部分的C++程序员还能看懂什么意思及其实现的机制。。。。但是仅仅是我的希望吧，甚至我怀疑，这样的实现放在工作中，总监和老总是不是会将我批的体无完肤，的确，为了省略一个循环值得这样做吗？实在不值得，但是C++提供给你的机制就是这样。Add这样的函数对象构造复杂，还得利用trail机制（从binary_function类继承过来），然后再利用函数适配器bind2nd/bind1st，这样的东西似乎需要语言专家来解释，我是解释不清楚了，再加上更加复杂的函数连标准库中的bind都肯定不够用，还只能用boost::bind库，去试试吧，然后会发现一般的函数指来指去（特别是类成员）用的太复杂了，还是用boost::funciton吧。。。。。似乎永无止境。但是有了for each语法，那么什么复杂度都没有。。。。。还想自虐吗？算了吧，我基本上已经放弃了。不给糖吃，也放不着自己开工厂制作。。。。

另外，对于能够用boost的兄弟们，糖是有的吃的。boost:: foreach库即是如此。

下面是boost:: foreach的例子

```cpp
#include <list>
#include <iostream>
#include <boost/foreach.hpp>

using namespace std;

int main() 
{
    int a[5] = {1,2,3,4,5};
    list<int> l(a, a+5);

    BOOST_FOREACH( int i, l)
    {
       cout <<i <<endl;
    }

    BOOST_FOREACH( int i, l)
    {
       cout <<i+1 <<endl;
    }

    system("PAUSE");
}
```

就算仅仅这一个例子。。。。永远不要怪库开发者（比如boost,ace,loki）将C++语言弄得多么扭曲，他们也是出于无奈。。。。别去看实现，先只管用吧。

对于不能用boost的我。。。。只能看有没有办法偷偷的将/cli编译选项打开了。。。^^

