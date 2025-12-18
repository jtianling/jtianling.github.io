---
layout: post
title: boost::bind 学习
categories:
- C++
tags:
- Bind
- Boost
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '29'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)

    最近学习了太多与MacOS与Iphone相关的东西，因为不会有太多人有兴趣，学习的平台又是MacOS，不太喜欢MacOS下的输入法，所以写下来的东西少了很多。

    等我学习的东西慢慢的与平台无关的时候，可能可以写下来的东西又会慢慢多起来吧。。。。。不过我想早一批订阅我博客的人应该已经不会再看了，因为已经很少会有程序语言或者C++之类的信息，相关的东西应该都是关于计算机图形，游戏的。或者，早一批订阅我博客的人现在也已经毕业，工作了呢？

    对了，这次的主题是boost:bind。在历经了  
[boost::asio(1)](<http://www.jtianling.com/archive/2009/06/08/4248655.aspx>)  
  
[boost::asio(2)](<http://www.jtianling.com/archive/2009/06/07/4249975.aspx>)  
  
[boost::asio(3)](<http://www.jtianling.com/archive/2009/06/09/4253270.aspx>)  
  
[boost::foreach](<http://www.jtianling.com/archive/2009/05/15/4187209.aspx>)  
  
[boost::function](<http://www.jtianling.com/archive/2009/05/28/4219043.aspx>)  
  
[boost::lambda](<http://www.jtianling.com/archive/2009/05/22/4205134.aspx>)  
  
[boost::serialization(1)](<http://www.jtianling.com/archive/2009/04/03/4025162.aspx>)  
  
[boost::serialization(2)](<http://www.jtianling.com/archive/2009/04/21/4096147.aspx>)  
  
[boost::string_algo](<http://www.jtianling.com/archive/2009/05/31/4225133.aspx>)  
  
[boost::thread](<http://www.jtianling.com/archive/2009/06/07/4246470.aspx>)

之后，boost常用的很多都学会了，现在自己写点小东西，那是大胆的用大。。。。。。。呵呵，反正自己的东西，就当用来锻炼技术了。在学习boost::signal2的过程中发现自己其实对boost::bind这个将来要进C++标准的库了解还不够多，（在boost::functon中有所提及，也同时学了一点），所以抽了点时间，好好的学习了一下。

###   
Purpose（目的）

原来文档中的purpose完全就是教程了，事实上，bind主要用于改造函数，比如，一个地方需要一个无参的函数，你只有一个以int为参数的函数，并且你知道此时int一直为1就可以了，你怎么办？传统方法，直接实现一个函数，然后以1调用以前的那个int为参数的函数。如下：  
  
```cpp
void  
 Fun1(int  
 i) {

    printf("  
%d  
/n  
"  
, i);

}

void  
 FunWeNeed() {

    Fun1(1  
);

}

int  
 main()

{

    FunWeNeed();

    

    return  
 0  
;

};
```

当然，这个例子太扯了，我们只需要直接用Fun1(1)调用就可以了，但是bind的目的就是如此，只不过现实中因为各种各样的原因，你的确需要改造函数。再比如下面的情况，你有一个原来写好的函数，接受一个以无参函数为参数，那么，你的Fun1就没有办法派上用场了，那么，传统上，怎么办？如下：  
  
```cpp
typedef  
  void  
 FunWeNeed_t(void  
);

void  
 CallFun( FunWeNeed_t f) {

    f();

}

void  
 Fun1(int  
 i) {

    printf("  
%d  
/n  
"  
, i);

}

void  
 FunWeNeed() {

    Fun1(1  
);

}

int  
 main()

{

//  CallFun(Fun1);          // this line can't compile  

    CallFun(FunWeNeed);

    return  
 0  
;

};  
```
  
Ok，你不得不写新的函数以满足需求，因为你没有简单的办法改变一个函数的参数。事实上，假如你是STL流派的话，那么随着你使用标准库的算法的次数的增加，你会遇到越来越多上面描述的情况，到底很简单，C++是如此的类型安全的语言，它不会加上诸如参数过多就忽略后面参数的胡扯特性。那么，一个算法需要你传进来的是什么形式的函数（或者函数对象），那么你就的怎么做。

去看看，标准库中提供了一大堆多么扯的函数对象吧，less, more,,greater_equal,not1,not2,。。。。。。然后还给了你一堆compose1，compose2........最后附带最恶心的bind1st，bind2nd，事实上，这些东西如此之多，以至于我甚至懒的列举出来，但是事实上我们在项目中用到了多少？简而言之，None!一次也没有，甚至因为很多算法与此相关，我们连那些算法也不用！

为啥C++当年出现了那么多奇怪臃肿无用的设计？可能是，C++标准出现的那个年代，编程技术的发展也就到那个地步吧。。。。。。。。。在C/C++语言中，关于函数的抽象特别的少，原因很简单，因为函数指针太不好用了！（函数抽象也用，但是好像用的最多的是在C语言中无物可用时，不得已的而为之）

记得在哪看过一句话，技术再花哨也没有用，最重要的是足够简单，因为不够简单的技术就很难给人讲解，别人很难理解那么就很难应用。这些C++特性应该算是其中的一例了。

boost中的bind，[function](<http://www.jtianling.com/archive/2009/05/28/4219043.aspx> "function")  
,[lambda](<http://www.jtianling.com/archive/2009/05/22/4205134.aspx> "lamba")  
就是为此而生的。注意，在tr1中，你就已经可以使用bind和function特性了，这也很可能是将来的C++标准之一。现在boost中的lambda还不够成熟，语法很怪，限制很多，因为，毕竟，boost再强大，仅仅是库啊。。。。。。。。。匿名函数的功能完全值得用语言特性来实现！

上面那个很扯的例子，总的给个bind的解决方案吧。  
  
```cpp
#include   
<boost/bind.hpp>  
  
#include   
<boost/function.hpp>

void  
 CallFun( boost::function<void  
(void  
)> f) {

    f();

}

void  
 Fun1(int  
 i) {

    printf("  
%d  
/n  
"  
, i);

}

void  
 FunWeNeed() {

    Fun1(1  
);

}

int  
 main()

{

    CallFun(boost::bind(Fun1, 1  
));         // this line can't compile  

    CallFun(FunWeNeed);

    return  
 0  
;

};
```

需要注意的是，此时不能再使用函数指针了，bind的天生合作伙伴是function,而function是支持函数指针的（如上例所示）  
  
。目的将的很多了，下面看看用法吧（不是什么问题）。

  

### 普通函数  

最有意思的是，你甚至能用bind来扩充原有函数的参数，见下例：

  
```cpp
#include   
<iostream>  
  
#include   
<boost/bind.hpp>  
  
#include   
<boost/function.hpp>  
  
using  
 namespace  
 std;  
using  
 namespace  
 boost;

void  
 f(int  
 a, int  
 b)

{

    cout <<"Argument 1 is "  
 <<a <<endl;

}

void  
 g(int  
 a, int  
 b, int  
 c)

{

    cout <<"sum is "  
 <<a+b+c <<endl;

    cout <<"arg 1: "  
 <<a <<endl;

    cout <<"arg 2: "  
 <<b <<endl;

    cout <<"arg 3: "  
 <<c <<endl;

    cout <<"\---------------------------"  
 <<endl;

}

int  
 main()

{

    function<void  
(int  
,int  
)>  f1= bind(f, _2, _1);                 // 调整参数1，2的位置  

    f1(1  
, 2  
);

    function<void  
(int  
)> sum1 = bind(g, _1, _1, _1);        // 3个参数变1个  

    sum1(10  
);

    function<void  
(int  
, int  
)> sum2 = bind(g, _2, _2, _2);       // 3个参数变2个，仅用一个  

    sum2(10  
, 20  
);

    function<void  
(int  
, int  
, int  
)> sum3 = bind(g, _3, _3, _3);      // 3个参数还是3个，但是仅用1个  

    sum3(10  
, 20  
, 30  
);

    function<void  
(int  
, int  
, int  
, int  
)> sum4 = bind(g, _4, _4, _4);     // 3个参数变4个，但是仅用1个  

    sum4(10  
, 20  
, 30  
, 40  
);

    return  
 0  
;

};
```

  
输出结果：

```text
Argument 1 is 2

sum is 30

arg 1: 10

arg 2: 10

arg 3: 10

\---------------------------

sum is 60

arg 1: 20

arg 2: 20

arg 3: 20

\---------------------------

sum is 90

arg 1: 30

arg 2: 30

arg 3: 30

\---------------------------

sum is 120

arg 1: 40

arg 2: 40

arg 3: 40

\---------------------------
```

### 函数对象

注意用法中很重要的一条：通常情况下，生成的函数对象的   
**operator()**  
的返回类型必须显式指定（没有   
**typeof**  
操作符，返回类型无法推导）。（来自Boost文档）  
  
```cpp
#include   
<boost/bind.hpp>  
  
#include   
<boost/function.hpp>  
  
using  
 namespace  
 std;  
using  
 namespace  
 boost;

struct  
 F

{

    int  
 operator  
()(int  
 a, int  
 b) { return  
 a - b; }

    bool  
 operator  
()(long  
 a, long  
 b) { return  
 a == b; }

};

int  
 main()

{

    F f;

    int  
 x = 104  
;

    function< int  
(int  
) > fun1 = bind<int  
>(f, _1, _1);      // f(x, x), i.e. zero

    cout <<fun1(1  
);

    function< bool  
(long  
) > fun2 = bind<bool  
>(f, _1, _1);       // f(x, x), i.e. zero

    cout <<fun2(1  
);

    return  
 0  
;

};  
```
  

其他的也就很简单了。

  

### 成员指针  

例子来源于boost文档。  
```cpp
#include   
<iostream>  
  
#include   
<boost/bind.hpp>  
  
#include   
<boost/function.hpp>  
  
#include   
<boost/smart_ptr.hpp>  
  
using  
 namespace  
 std;  
using  
 namespace  
 boost;

struct  
 X

{

    void  
 f(int  
 a) {

        cout <<a <<endl;

    }

};

int  
 main()

{

    X x;

    shared_ptr<X> p(new  
 X);

    int  
 i = 1  
;

    bind(&X::f, ref(x), _1)(i);     // x.f(i)  

    bind(&X::f, &x, _1)(i);         //(&x)->f(i)  

    bind(&X::f, x, _1)(i);          // (internal copy of x).f(i)  

    bind(&X::f, p, _1)(i);          // (internal copy of p)->f(i)

    return  
 0  
;  
  
}
```

可见bind的强大，支持自己拷贝需要的对象，支持引用，甚至，支持智能指针。

最后一个例子，结合标准库容器及算法的例子，这才是展示bind的强大的地方。  

还是来自于boost文档。  
```cpp
class  
 image;  
class  
 animation

{  
public  
:

    void  
 advance(int  
 ms);

    bool  
 inactive() const  
;

    void  
 render(image & target) const  
;

};

std::vector<animation> anims;

template  
<class  
 C, class  
 P> void  
 erase_if(C & c, P pred)

{

    c.erase(std::remove_if(c.begin(), c.end(), pred), c.end());

}

void  
 update(int  
 ms)

{

    std::for_each(anims.begin(), anims.end(), boost::bind(&animation::advance, _1, ms));

    erase_if(anims, boost::mem_fn(&animation::inactive));

}

void  
 render(image & target)

{

    std::for_each(anims.begin(), anims.end(), boost::bind(&animation::render, _1, boost::ref(target)));

}  
```

例子展示了erase_if,for_each算法中使用bind的方法，当然，实际中，假如是你的游戏引擎中的update，render函数，碰到上述需求或者类似代码实现是很正常的，但是，你会放心的仅仅为了简化一些代码，然后将如此性能相关的位置，直接交给bind吗？

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**