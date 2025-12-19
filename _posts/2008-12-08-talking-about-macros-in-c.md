---
layout: post
title: "漫谈C++中的宏"
categories:
- C++
tags:
- C++
- "宏"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '298'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

C++宏是把双刃剑：它因无类型检查而危险，但在条件编译、调试和代码生成等高级场景下，又是不可或缺的强大工具。

<!-- more -->

# 漫谈C++中的宏

--接近你的朋友，更接近你的敌人

**write by九天雁翎(JTianLing) -- blog.csdn.net/vagrxie**

# 为什么宏是敌人：

原谅我将C++中的宏称作敌人，自从看到D&E中Bjarne说Cpp（这里指C语言预处理）必须被摧毁后，我就一直尽量避免使用宏，为什么我要去使用一个必须被摧毁的东西？（原谅我脑袋中对名词处理不清，不过"预处理"的主要部分可能就是"宏"）

即便我自己尽量不使用宏了，但是宏依旧给我带来了很多的问题。随便举几个例子，最典型的就是windef.h（包含windows.h也会包含这个文件）中的max,min宏，这两个宏会直接导致C++标准库中的numberlimit使用出现问题，这点我以前已经讲过几次了。上次看到X264的代码前几行就是

```cpp
#undef  
max

#undef  
min
```

的时候我是特别感叹。。。真是害人的东西啊。

还有一个例子，MFC自动生成的文件为了调试方便，所有的new在debug版本下都被宏替换成DEBUG_NEW，实际上被替换成了类似new(void *p,const char* filename, int line)这样的形式，为的是跟踪每次的内存分配。这也是为什么MFC程序在出现内存泄露的时候你能在VS output中看到一大堆的memory leak。问题是，因为用了宏。。。带了了很大的副作用。我个人new的时候，有的时候喜欢用new(nothrow)的形式，为的是用老的new，然后判断返回的指针是否为空，这样可以避免使用异常处理,不是我不喜欢catch。。。。公司总监说一般不要用，老是容易出问题。另外，就<<inside C++ object>>中说，就算一个程序从来不抛出异常，加上一个catch语句都会有3%~5%的效率损失。。。。这也不算是小损失了。。。

最近我同事做游戏音效管理的时候也碰到了一个很难以理解的问题。那就是明明正确PlaySound函数，总是报没有实现的编译错误。。。。。最后的问题竟然还是宏的问题。windows下经典的用来实现ansi/unicode通用的方式就是用宏大家都知道吧，因为windowsAPI中也有PlaySound函数，所以我同事程序中因为一边包含了windows的东西，一边没有包含，结果就是一边的PlaySound被替换成PlaySoundW了，而调用的PlaySound就不存在了。。。。这样的问题，真的让人吐血。。。。。。。

宏的无类型检测和随意性导致任何一个本来正确的程序都可以变成错误的。这也就是为什么Bjarne认为它必须被毁灭。这也是为什么我要将宏视为敌人。。。。

# 接近你的朋友：

宏在C中的这么几个作用在C++中有相应的替代品，并且推荐使用。

1. 用#define来定义常量

可以用全局的const变量来代替，永远要知道#define是不带类型检查的，而const变量带。虽然宏的使用可能更节省了一个全局变量，但是除非特殊需求，不值得为这样一个全局变量去牺牲安全性。

2. 用#define来定义函数并且使函数扩展，减少运行时消耗

可以用inline函数替换，inline函数带参数类型检查，并且不会无端的将你正常的程序变得不正常（参考上面的例子）

3. 用#define来实现类型无关的容器

在没有template之前，这是标准的方法，在有template之后。。。这是废弃的方法。

推荐的方法是你的朋友，宏是你的敌人。

# 更接近你的敌人

首先顺便说说其他的预处理：

1.#include用来包含文件，这点的作用至今无法替代，大家用的也都没有什么问题。在Bjarne引入include关键字之前，我们只能用它。

2.#ifdef 

#define

#endif 

组合用来防止头文件的重复包含，这个使用C++也没有提供替代方案。也是无法替代。（VS中好像#progra once可以）虽然Bjarne说这是很拙劣很低效的方法，但是在我们没有找到更合理的方式前，也就只能这样使用了。

3.用#ifdef #elif #else #endif来实现条件编译，这是防止头文件重复包含的泛化版本，这在C++中也没有办法替代。为什么MS只能用这种方式来实现一套源码ANSI/Unicode通用？因为没有其他办法。实际上，用一套源码来维护的可移植性代码通篇的#ifdef #elif #else #endif那是太正常的事情了。哪怕像因为哦我们公司将debug版本的程序加上_dbg的后缀这样的工程管理方式，都会导致所有希望以CreateProcess方式调用此程序的程序都加上条件编译。常用的用来实现条件编译的宏有_DEBUG,_RELEASE,_WIN32,_WINVER，_LINUX等。。。。。。。。。

4. __LINE__,__FILE__其实好像一般人都用不着，但是这简直就是调试者的福音，因为你可以简单的将malloc,new等宏扩展成new(size,__LINE__,__FILE__)这样的调用形式，再自己实现之，呵呵，其实这也就是MFC内存管理的原理。另外，我做内存管理模块的时候才知道，原来malloc其实就是一个宏定义,-_-!就我所知，可能是因为在C语言时代，没有重载这一说，但是考虑到总会有人想来自己管理内存，所以才出此一招。。。。

## 下面是重头戏，宏，#define 

除了定义常量，函数等基础功能能够被C++中的某些特性替代以外，更多的特性无法替代。#define就是一把达摩克利斯之剑。除了程序代码我不知道该怎么形容#define可以带来的东西：）几乎可以做到do anything you want? 当和条件编译结合使用的时候，你会发现你几乎就是上帝：）

## 1.）最简单的情况，节省你敲代码的时间：）

很多时候一个深层的调用是这样子的mpObject->moMap.first->SomeFun()，

你一个#define mpObject->moMap.first->SomeFun CallSomeFun

以后所有这样的复杂调用就简单多了：）

## 2.)次最简单的情况，替代函数

很多时候人们说不要让重复的代码出现多次，都是告诉你可以将重复的代码做成函数。但是有的时候几个平行的代码，做成函数不方便的时候，宏就更加适合。举个例子:

```cpp
++SomeLocalA;

++ SomeLocalB;

++ SomeLocalC;

++ SomeLocalD;

++ SomeLocalE;
```

当类似这样代码重复出现的时候，确定要用函数吗？后果是，函数要定义成

Increment(int &a,int &b,int &c, int&d, int&e)

形式，调用起来还得

Increment(SomeLocalA, SomeLocalB, SomeLocalC, SomeLocalD, SomeLocalE);

你认为任务轻松了？。。。。。。。

用#define吧。。。。。。

```cpp
#define INCREMENT  
++SomeLocalA;/

++ SomeLocalB;/

++ SomeLocalC;/

++ SomeLocalD;/

++ SomeLocalE;
```

后，在次使用只需要输入INCREMENT就行了，这才叫简化。

## 3.)次次最简单的应用，版本控制和平台无关性控制。

这也算是一种标准的用法了，特别是库用的特别多，一般和条件编译结合使用，很多常见的宏比如_WINVER就是属于版本控制，_WIN32,_LINUX就是属于平台控制。参考预定义介绍3.

## 4.)简单的应用，方便的调试。。。。。

某时也可以和#ifdef综合应用，参看预定义介绍4.

还是举例说明吧，比如断言这样最经典的东西大家都知道吧，assert啊。。。程序中往往插入了成百上千的assert，有一天你不想要了怎么办？编译成release版本？晕，调试呢？简单的解决办法是这样

```cpp
#define  
ASSERT assert
```

然后你平时使用断言的时候全部用ASSERT，某一天你不想使用了，很简单的一句

```cpp
#define  
ASSERT
```

然后断言全部取消了。

这一点的应用是很广泛的，比如日志系统在程序版本还不是很稳定的时候是很需要的，当程序已经比较稳定的时候还频繁的输出日志，那就会影响程序的效率，那怎么办？你一条一条将原来的日志删除？OK，你很聪明，我用全局替换成空的。。。。。。呵呵，假设你会用正则表达式是可以做到的：）随便说一句，我很喜欢用：）那么有一天程序出问题，又希望加日志呢？又一条一条加？假如会正则表达式的话还是有解决方案，呵呵，将原有的所有日志前面全部加上//，需要的时候再去掉//就行了。方法倒是可行（说实话可行），就是当工程大的时候，消耗的时间啊。。。。。

其实还是用#define最简单

```cpp
#define  
LOG_OUT(xxxxxxx)
```

用来输出日志，然后某天你不用了

```cpp
#define  
LOG_OUT
```

就没有了。。。。。

这点还有个特别的好处：）比如你想在所有的日志前面加上个前缀：）

这时你改变你的LOG_OUT宏就可以了，不用全局去改。

加上__FILE__,__LINE__后对于debug和详细日志输出的帮助是无限大的。当同一个函数在不同的情况下被调用的时候，你希望知道是谁调用了这条函数，你能怎么做？直接的办法是，你改变原有的函数，添加进一个行参数两个新的字符串参数，并且定义你扩展的函数。其实可以直接将原有函数用宏替换走：）这也就是上面提到的new的替换方式，可能带来副作用，但是好用至极。这里不举其他例子了，可以参考MFC 的DEBUG_NEW的宏。

4b)这点有个延生用法，那就是当某个新功能你需要添加进原有的程序，但是你需要先测试和保证不影响原有的程序，你将此功能的代码做成一条宏语句是最简单的方法，不仅节省了你copy大量代码的时间，还能在你不需要的时候直接取消此功能。这种用法也是很广泛的，而且特别实用。

这一点的例子可以参看MFC中定义的FIX_SIZE宏，我将它们贴出来，呵呵，想到侯捷可以将所有的源代码都拿出来剖析，我随便贴一点应该不违法吧-_-!

```cpp
//  
DECLARE_FIXED_ALLOC -- used in class definition

#define DECLARE_FIXED_ALLOC(class_name) /

public: /

    void* operator  
new(size_t size) /

    { /

       ASSERT(size == s_alloc.GetAllocSize()); /

       UNUSED(size); /

       return s_alloc.Alloc(); /

    } /

    void* operator  
new(size_t, void* p) /

       { return p; } /

    void operator  
delete(void* p) { s_alloc.Free(p); } /

    void* operator  
new(size_t size, LPCSTR, int) /

    { /

       ASSERT(size == s_alloc.GetAllocSize()); /

       UNUSED(size); /

       return s_alloc.Alloc(); /

    } /

protected: /

    static CFixedAlloc  
s_alloc /
```

```cpp
//  
IMPLEMENT_FIXED_ALLOC -- used in class implementation file

#define IMPLEMENT_FIXED_ALLOC(class_name, block_size)  
/

CFixedAlloc class_name::s_alloc(sizeof(class_name), block_size)  
/
```

```cpp
//  
DECLARE_FIXED_ALLOC -- used in class definition

#define DECLARE_FIXED_ALLOC_NOSYNC(class_name) /

public: /

    void* operator  
new(size_t size) /

    { /

       ASSERT(size == s_alloc.GetAllocSize()); /

       UNUSED(size); /

       return s_alloc.Alloc(); /

    } /

    void* operator  
new(size_t, void* p) /

       { return p; } /

    void operator  
delete(void* p) { s_alloc.Free(p); } /

    void* operator  
new(size_t size, LPCSTR, int) /

    { /

       ASSERT(size == s_alloc.GetAllocSize()); /

       UNUSED(size); /

       return s_alloc.Alloc(); /

    } /

protected: /

    static CFixedAllocNoSync  
s_alloc /
```

```cpp
//  
IMPLEMENT_FIXED_ALLOC_NOSYNC -- used in class implementation file

#define IMPLEMENT_FIXED_ALLOC_NOSYNC(class_nbame, block_size)  
/

CFixedAllocNoSync class_name::s_alloc(sizeof(class_name), block_size)  
/
```

```cpp
#else //!_DEBUG

#define DECLARE_FIXED_ALLOC(class_name) // nothing  
in debug

#define IMPLEMENT_FIXED_ALLOC(class_name, block_size)  
// nothing in debug

#define DECLARE_FIXED_ALLOC_NOSYNC(class_name) // nothing  
in debug

#define IMPLEMENT_FIXED_ALLOC_NOSYNC(class_name, block_size)  
// nothing in debug

#endif //!_DEBUG
```

上边的宏定义出自fixalloc.h文件，详细的意义可以到MFC的源代码中去查，这样的话只要在需要FIXALLOC的地方使用DECLARE_FIXED_ALLOC和IMPLEMENT_FIXED_ALLOC宏就可以实现功能了，并且可以很方便的控制，比如上边的代码就让宏在relase版本下才有用，在debug版本下放空了。

## 5.次次复杂应用，自动扩展甚于模板的函数。

这时候需要一个很重要的特性"##" ：）使用宏定义以后的连接功能。比如我做数据校验器的时候用到n个Init。。。和n个CxxxCheck类，但是名字都是不一样的，做成模板似乎很适合，其实做不到。因为你甚至没有办法来确定哪个类用哪个mbxxxInit来表示已经初始化的问题。但是宏可以。模板往往也不能详细的分辨出每次调用的具体类型并输出日志，宏也可以。

比如，

```cpp
#define Init(_CHECK) if(mp##_CHECK->Init())/

                  {/

                     mb##_CHECK = true;/

                  }

                  else

                  {/

                     LOG_OUT("Init" <<#_CHECK  
<<"failed" <<endl);/

               }
```

当然，这有个局限，就是你得将命名规范化，还好这不是什么难事。

6．次复杂应用，大家都知道的，消息映射。

其实消息映射可以理解为5b的衍生，但是实际上用途更加强大，MFC的消息映射大家都知道吧：）其实消息映射可以应用到很多方面，除了MFC的例子我多说了，在网络包的分派上应用也是很经常的，起码我就常常用，虽然这个时候使用的方法可能应该不能叫消息映射了，叫包分派更加合适。其实更深一步说，在牵涉到一个一个固定入口值，然后分派到不同的函数的过程，假如数量多的话，都可以使用消息映射的模式，这样最节省代码，也可以省下很多虚接口。唯一的一点是，定好命名规则。。。不要打错字。。。

## 7．复杂应用，工厂模式。

虽然C++中可以不用宏实现工厂模式。但是使用的时候用到宏会方便太多。。。。好像举例子比较复杂。。。。可以参考"四人帮"的书Gof23

比如一个CreateClass（classname）的函数，创建并返回一个你指定的类。你会怎么做？

```cpp
if (classname == "classa")  
return new CClassA else if (classname == "classb") return new CClassB else  
if........................
```

别的不说，在我们公司的游戏界面库中的类都有40多个。。。。也就是说，你要创建一个Class40..需要比较40多次。。。。。。效率自然低了。这其实是我在公司解决的一个问题。。。。呵呵，做了很久了，当然我不能将公司的源码贴出来给大家看：）不过CEGUI的例子倒是可以：）

基本原理就是先将所有的可能创建的类的都定义一个对应的工厂类，此类中包含一个成员函数new并返回这个类的一个对象。要生成这个类的时候就找到对应的工厂并调用这个生成函数，实际使用的时候利用##的连接特性，自己拼出需要生成类，然后调用。另外类工厂通常做成单件。以下是代码，呵呵，别的就不多说了，源码能说明问题。想详细看的，可以参考CEGUI源代码的CEGUIWindowFactory.h文件，这个用法其实也和6一样，需要命名规范。说了半天，其实做到的效果就是通过一个字符串来动态创建一个对应的类。在CEGUI中，控件几乎都是通过这种方式来创建的，这样再和XML解析配合，可以达到极大的自由度。这里所谓的自由是指可以达到不修改程序，光修改XML的配置文件，就可以实际修改程序（游戏）的效果。呵呵，扯远了。

```cpp
#define CEGUI_DECLARE_WINDOW_FACTORY(  
T )/

class T ## Factory : public WindowFactory/

{/

public:/

    T ##  
Factory() : WindowFactory(  
T::WidgetTypeName  
) {}/

    Window* createWindow(const  
String& name)/

    {/

        return new T (d_type, name);/

    }/

    void destroyWindow(Window*  
window)/

    {/

        delete window;/

    }/

};/

T ##  
Factory& get  
## T ## Factory();
```

```cpp
/*!

/brief

    Generates code for the constructor for the  
instance of the window factory generated

    from the class name /a T

*/

// 

#define CEGUI_DEFINE_WINDOW_FACTORY(  
T )/

T ##  
Factory& get  
## T ## Factory()/

{/

    static T  
## Factory s_factory;/

    return s_factory;/

}
```

```cpp
/*!

/brief

    Helper macro that return the real factory  
class name from a given class name /a T

*/

#define CEGUI_WINDOW_FACTORY(  
T ) (get ## T ## Factory())
```

**write by九天雁翎(JTianLing) -- blog.csdn.net/vagrxie**
