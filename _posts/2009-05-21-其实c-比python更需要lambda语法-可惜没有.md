---
layout: post
title: "其实C++比Python更需要lambda语法，可惜没有。。。。"
categories:
- Python
tags:
- C++
- lambda
- Python
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '16'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**其实C++比Python更需要lambda语法，可惜没有。。。。**

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

思路有点混乱，想到哪就写到哪了。

起点是Python，Python的语法大都简单，有人说接近自然语言，但是其实我还是发现了一些不那么通俗易懂的东西，也许是因为还没有形成深刻的Python思维，也许是受C++的熏陶太深吧，其中，Python的函数式编程方式上就有很多地方感觉语法比较不那么容易一眼就看出来。其实想到函数式编程，倒是首先想到了lambda，自此思路混乱。对于将函数作为第一类(first class)值的语言，比如Python,lua中，感觉lambda的作用就不是那么明显,比如Python中，调用lambda的实际需求似乎感觉不算太大，再加上其函数定义的语法本身就足够的简洁，定义一个完整的函数实在也不算什么。作为语法糖的lambda，实在就显得有点甜味不足，虽然也不是说完全没有用。

这里举几个例子：

**def**  add1(a,b):  **return**  a + b

add2 = **lambda**  a,b : a + b

**print**  add1(1,2)  
**print**  add2(1,2)

fun = **lambda**  f,a,b : f(a,b)

**print**  fun(**lambda**  a,b : a * b, 3, 4)

**print**  fun(add1, 3, 4)

 

可以看出，对于lambda这样的语句，假如在Python中还有作用的话，那么就是在需要函数作为参数传递的时候了，但是个人还是保持这样的观点，因为python这样的动态类型语言+足够简洁的函数定义语法+函数第一类型值的特点导致实际上lambda不够甜，虽然其可以进一步的简化一些语法。

但是，假如C++中有lambda那就是完全不同的概念了，看看同样的事情吧：

int add(int a, int b)

{

    return a \+ b;

}

 

template<typename T>

T add1(T lhs, T rhs)

{

    return lhs \+ rhs;

}

 

template<typename T>

class add2

{

public:

    T operator()(T lhs, T rhs)

    {

       return lhs \+ rhs;

    }

};

 

template<typename FUN, typename T>

T fun(FUN function, T lhs, T rhs)

{

    return function(lhs, rhs);

}

 

 

int main() 

{

    int a = 1;

    int b = 2;

 

    cout << add1(a,b) <<endl;

    cout << fun( ptr_fun(add), 1, 2) <<endl;

    cout << fun( add, 1, 2) <<endl;

    cout << fun( add1<int>, 1, 2) <<endl;

    cout << fun( ptr_fun(add1<int>), 1, 2) <<endl;

    cout << fun(add2<int>(), 1, 2) <<endl;

 

    system("PAUSE");

}

 

可以看到，相对而言C++的函数定义语法，包括使用方式上都会比Python要复杂一些，最主要的复杂性来之于C++赖以生存的根本，强类型，为了达到类型安全又类型无关，引入的模板机制，进一步的复杂化了函数的定义。

最有意思的是，

    cout << fun( add1<int>, 1, 2) <<endl;

    cout << fun( ptr_fun(add1<int>), 1, 2) <<endl;

 

这两种方式，在开启/clr,即开启微软的公共运行时库时会出现异常，我还是在反汇编时发现汇编代码异常才发现原来我在上次调试for_each的时候，为了展示/clr的新添的for each语法而开启了/clr选项，详情可以见《[多想追求简洁的极致，但是无奈的学习C++中for_each的应用](<http://www.jtianling.com/archive/2009/05/15/4187209.aspx>)》一文。

/clr选项应该就是将C++加入微软的.net体系，因为没有深入学习过，所以对出现的异常现象无法解释，希望有学过.net的人可以解释一下。

 

另外，这里想说的是，因为C++没有原生的for each语法，所以实际上很多循环不想写的话只能通过for_each算法来模拟，再加上很大一族的算法函数对于函数对象的需求，导致了语法的极大复杂化，使得C++对于lambda语法的需求远远大于Python这样的语言，但是，遗憾的是，C++并没有这样的语法，实际上09标准中好像有人提议过这样的特性，不过不知道通过没有-_-!就我目前所知，否决的可能性要大得多，但是因为没有仔细去查阅资料了，所以不敢肯定，但是很明显TR1中是没的，新出来的g++中新添了很多09标准要出来的特性中也没有包含lambda，似乎我们可能在短时间内（起码下一版标准。。。又要起码十年）是没有机会了。

《[多想追求简洁的极致，但是无奈的学习C++中for_each的应用](<http://www.jtianling.com/archive/2009/05/15/4187209.aspx>)》一文，为了能够简单的让c++模拟出for each语法的调用，我甚至都不得不将很多循环进行两次。。。。。。详细情况见前文，就知道假如能有lambda，那么我们就能够省下多少函数的定义了。这里我就不在重复原文中的例子了。

事实上，还是如同boost::foreach库一样，虽然没有这样的语法，但是C++界的牛人们绝不允许这样的情况发生，他们想要什么，就会有什么，如同当年上帝。。。。要有光，于是就这么有了。。。。。看看boost的lambda库能给我们带来什么。

#include <list>

#include <iostream>

#include <boost/foreach.hpp>

#include <boost/lambda/lambda.hpp>

using namespace std;

using namespace boost::lambda;

 

template<typename T>

void printInt(T i)

{

    cout <<i <<endl;

}

 

int main()

{

    int a[5] = {1,2,3,4,5};

    list<int> l(a, a+5);

 

    for(list<int>::const_iterator lit = l.begin(); lit != l.end(); ++lit)

    {

       cout <<*lit <<endl;

    }

 

    // 同样是需要输出

    for_each(l.begin(), l.end(), ptr_fun(printInt<int>));

 

    BOOST_FOREACH( int i, l)

    {

       cout <<i <<endl;

    }

 

    // 因为Andrew koenig发明的操纵器的特性，boost::lambda无法支持

    for_each(l.begin(), l.end(), cout <<_1 <<'/n');

 

    system("PAUSE");

}

 

一条语句，省下了很多工作，只当有这样简洁的实现方式时，我们才能够大规模的利用for_each去代替无聊的循环，非常高频率出现的循环,并且，虽然说Boost实现的lambda语法和一般而言有点区别，但是还算是比较容易理解，在没有for each语法前，我最希望有的可能就是lambda语法了，我希望利用算法来代替循环，但是没有lambda前，那样做可能比不费脑子的写个循环更加费力不讨好，甚至流于语言特性的滥用。还是在《[多想追求简洁的极致，但是无奈的学习C++中for_each的应用](<http://www.jtianling.com/archive/2009/05/15/4187209.aspx>)》一文中，后面的例子就可以看出在没有这些语法特性时，我希望实现一个那么简单的功能所付出的代价。

 

这里为了方便，还是拷贝一次原文中的例子：

Python中：

**def**  add(a,b):  
    **return**  a + b

l = [1,2,3,4,5]  
**for**  i **in**  l:  
    **print**  add(i,1)

 

无非就是在每个输出的函数中调用一个函数，没有任何值的一提的地方，是个人就能看懂。

在C++需要实现成下面这个样子：

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

 

这是在没有lambda和for each语法时无奈的实现。

假如有lambda语法的话，那么感觉就不同了。

#include <list>

#include <iostream>

#include <boost/foreach.hpp>

#include <boost/lambda/lambda.hpp>

using namespace std;

using namespace boost::lambda;

 

int main()

{

    int a[5] = {1,2,3,4,5};

    list<int> l(a, a+5);

 

    for(list<int>::const_iterator lit = l.begin(); lit != l.end(); ++lit)

    {

       cout <<*lit \+ 1 <<endl;

    }

 

    for_each(l.begin(), l.end(), cout <<_1+1 <<'/n');

 

    system("PAUSE");

}

 

还是几乎与原有的不+1输出实现同样的简洁，这就是lambda带来的特性，在没有这些特性的时候，我们就只能老老实实的按iterator的方式写了，在C++苦海中挣扎的兄弟们啊。。。。（特别是像我这样，工作中甚至连boost都不能用的人啊。。。。）继续等待吧。。。。等09标准出来。。。等VS202X版本的VS出来后，估计差不多才可能实现新的C++ 09标准，然后我们也许能够稍微减轻点工作量，以后能够写成大概是

    for(auto lit = l.begin(); lit != l.end(); ++lit)

    {

       cout <<*lit \+ 1 <<endl;

    }

这个样子。。。。。。。。。。。。。。阿门。

 

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)

 
