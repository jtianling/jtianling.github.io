---
layout: post
title: "继续boost的相关学习， boost::string_algo让std::string这样的废柴类有用一点"
categories:
- C++
tags:
- Boost
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '20'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**继续 boost的相关学习， boost::string_algo让std::string这样的废柴类有用一点**

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

# 一、   对string态度的慢慢转变

作为一个初学者，本来没有批评大牛们创造的语言及其标准库的资本，初期看的一些教学书籍总是推荐你在绝大多数时候不要使用char*，使用string,比如C++ Primer,C++ Effective等，但是再接着看深点，就开始有书批评C++中的某些库了，比如C++ STL Library，（批评string的书比较多，我倒是一下子举不出例子-_-!）但是，甚至在看过很多书批评std::string后，我还是感觉尽量去使用std::string比较好，知道越用感觉越多的不方面，除了与标准库算法搭配较为方便外，std::string甚至比不过CString好用，性能上的问题也是比我想象的要严重的多，以前在做代码优化的时候发现，按照常用的for循环记法，绝大多数标准库容器都会将begin(),end()这样的迭代器函数调用内联，但是唯独std::string不会，傻傻的每次都调用（在VS2005上测试,全优化结果一致）。

假如这方面你还可以说是MS在string实现上的缺陷的话（事实上现有STL几乎统一是来源于HP的库），那么作为一个string，在std中甚至连一个大小写转换的函数都没有，甚至连大小写不敏感的比较都没有，那就实在说不过去了，想想python,lua等语言中一个string是何其的强大！难道是因为C ++的设计者们都做操作系统，一般不处理字符串？-_-!没有正则表达式的历史原因我就不多说了。。。。

# 二、   轮子没有总会有人造的

于是乎，在需要相关功能的时候，需要用replace，stricmp加上一大串参数来完成，从理解的角度来说其实并不那么直观，对于普通功能的实现我能理解，但是对于常用功能老是这样用，感觉总是不爽，于是问题又来了，自己做个自己的库吧，下次重复利用就完了，才发现，当一种语言需要人造一个本应该存在的轮子的时候，这个语言本身就有问题。

再于是乎，造轮子的人boost::string_algo诞生了，可见std::string的恶劣。。。。自然，像这种库要进标准肯定是没有戏了，自己偷着用吧。

# 三、   boost::string_algo个人概述

string_algo我粗略的看了一下，相对而言还是比较强大，实现了很多功能。个人觉得必要的功能，比如大小写转换：`to_upper``，to_lower有了。`在python中用的很愉快的字符串处理函数，很有用的功能,比如trim, trim_left , trim_right (Python中对应的函数名字是strip，lstrip,rstrip)，Python中经常用到的starts_with也有了，相关的很多find函数也出来了，最最让我高兴的是，splice函数也有了。。。。这个函数在处理CSV数据的时候相当有用，一个函数往往可以节省很多的工作量。另外，其实从函数的参数来看就能看出两种语言的文化，C++的很多算法喜欢以_if的形式提供，要求用户提供判断函数，甚至是trim_left这样的函数也不提供一个以字符形式提供出来的参数以指定到底削除啥，而是提供了trim_left_if的函数来由你判断。。。。个人感觉，虽然_if的用法有的时候能极大的提高算法的适用范围，但是对于简单应用来说，实在离make simple things easy原则，何况，在没有lambda语法，没有好用的bind,却有强类型的复杂函数定义形式，复杂的函数指针语法，超复杂的成员函数指针语法的C++中，要好好的用对，用好一个类似的情况，实在并不见得那么简单。。。。。。。。。。。

最近老是将C++与Python做比较，感觉自己似乎更像是一个初学C++的Python程序员在不停的抱怨。。。其实本人还是完全靠C++吃饭的，仅仅是业余时间学习一下Python(工作中也用，但是比较少)，本人的观点一向是，虽然将不关心效率，奇慢的动态类型语言Python和以效率为根本的强类型C++做语法比较对C++非常不公平，但是，来自另一个语言的经验其实对于反思一个语言需要什么和怎么样更好的使用现有语言还是很有帮助的，就是因为这种相互的促进，我才会从需求的角度去学习了很多boost的库，比如《[多想追求简洁的极致，但是无奈的学习C++中for_each的应用](<http://www.jtianling.com/archive/2009/05/15/4187209.aspx>)》，《[其实C++比Python更需要lambda语法，可惜没有。。。。](<http://www.jtianling.com/archive/2009/05/21/4205134.aspx>)》，《[boost::function，让C++的函数也能当第一类值使用](<http://www.jtianling.com/archive/2009/05/27/4219043.aspx>)》不然，都是纯粹的跟着文档走的学习，那个效果要差的太多。

# 四、   例子：

这里将我试用我感兴趣函数的例子列出来，其实，知道个大概以后，留份参考文档，以后有需要的时候，会发现工具箱中实在是又多了很重要的一项工具。

 

## 1.      大小写转换

```cpp
void CaseChange()
{
    string lstr("abcDEF");
    string lstr2(lstr);

    // 标准形式
    transform(lstr.begin(), lstr.end(), lstr.begin(), tolower);
    cout <<lstr <<endl;

    // string_algo
    to_lower(lstr2);

    cout <<lstr2 <<endl;
}
```

比较奇怪的就是，为啥to_lower这样的函数不返回转换后的字符串，这样可以支持很方便的操作，难道也是出于不为可能不需要的操作付出代价的原则考虑？。。。。。。很有可能，想想标准的map.erase函数吧，看看《C++ STL Library》中相关的评价及说明。这是C++程序员的一贯作风。

## 2.      大小写不敏感的比较

```cpp
void CaseIComp()
{
    string lstrToComp("ABCdef");
    string lstr("abcDEF");
    string lstr2(lstr);

    string lstrTemp;
    string lstrTemp2;
    // 标准形式worst ways
    transform(lstr.begin(), lstr.end(), back_inserter(lstrTemp), tolower);
    transform(lstrToComp.begin(), lstrToComp.end(), back_inserter(lstrTemp2), tolower);
    cout <<(lstrTemp == lstrTemp2) <<endl;

    // 标准形式
    cout << !stricmp(lstr.c_str(), lstrToComp.c_str()) <<endl;

    // string_algo 1
    cout << (to_lower_copy(lstr2) == to_lower_copy(lstrToComp)) <<endl;

    // no changed to original values
    cout << lstr2 <<" " <<lstrToComp <<endl;

    // string_algo 2 best ways
    cout << iequals(lstr2, lstrToComp) <<endl;
}
```

 

好了，我们有比调用stricmp更好的办法了，如例子中表示的。

 

## 3.      修剪

```cpp
void TrimUsage()
{
    // 仅以trim左边来示例了，trim两边和右边类似
    string strToTrim="     hello world!";

    cout <<"Orig string:[" <<strToTrim <<"]" <<endl;

    // 标准形式:
    string str1;
    for(int i = 0; i < strToTrim.size(); ++i)
    {
       if(strToTrim[i] != ' ')
       {
           // str1 = &(strToTrim[i]);  at most time is right,but not be assured in std
           str1 = strToTrim.c_str() + i; 
           break;
       }
    }
    cout <<"Std trim string:[" <<str1 <<"]" <<endl;
   
    // string_algo 1
    string str2 = trim_left_copy(strToTrim); 
    cout <<"string_algo string:[" <<str2 <<"]" <<endl;

    // string_algo 2
    string str3 = trim_left_copy_if(strToTrim, is_any_of(" "));
    cout <<"string_algo string2:[" <<str3 <<"]" <<endl;
}
```

 

可见一个常用操作在std中多么复杂，甚至直接用char*实现这样的操作都要更简单，效率也要更高，string版本不仅失去了效率，也失去了优雅。但是在有了合适的库后多么简单，另外，假如std可以有更简化的办法的话，欢迎大家提出，因为毕竟我在实际工作中也没有boost库可用。

 

 

## 4.      切割

不是经常处理大量数据的人不知道字符串切割的重要性和常用长度，在比较通用的数据传递方式中，CSV（**Comma separated values** ）是比较常用的一种，不仅仅在各种数据库之间传递很方便，在各种语言之间传递数据，甚至是用excel打开用来分析都是非常方便，Python中string有内置的split函数，非常好用，我也用的很频繁，C++中就没有那么好用了，你只能自己实现一个切割函数，麻烦。

示例：

```cpp
void SplitUsage()
{
    // 这是一个典型的CSV类型数据
    string strToSplit("hello,world,goodbye,goodbye,");

    typedef vector< string > SplitVec_t;
    SplitVec_t splitVec1;
    // std algo 无论在任何时候string原生的搜寻算法都是通过index返回而不是通过iterator返回，总是觉得突兀
    // 还不如使用标准库的算法呢，总怀疑因为string和STL的分别设计，是不是string刚开始设计的时候,还没有加入迭代器？
    string::size_type liWordBegin = 0;
    string::size_type liFind = strToSplit.find(',');
    string lstrTemp;
    while(liFind != string::npos)
    {
       lstrTemp.assign(strToSplit, liWordBegin, liFind \- liWordBegin);
       splitVec1.push_back(lstrTemp);
       liWordBegin = liFind+1;
       liFind = strToSplit.find(',', liWordBegin);
    }
    lstrTemp.assign(strToSplit, liWordBegin, liFind \- liWordBegin);
    splitVec1.push_back(lstrTemp);

    BOOST_FOREACH(string str, splitVec1)
    {
       cout <<" split string:" <<str <<endl;
    }

    // string_algo
    SplitVec_t splitVec2; 
    split( splitVec2, strToSplit, is_any_of(",") ); 

    BOOST_FOREACH(string str, splitVec2)
    {
       cout <<" split string:" <<str <<endl;
    }
}
```

 

## 5.      其他：

至于其他的搜寻，替换，由于标准库中的已经比较强大了，string_algo也就算锦上添花吧，我的对搜寻和替换的需求不是那么强烈。大家参考boost本身的文档吧。在搜寻中提供搜寻迭代器的方式倒是还是使易用性有一定提高的。至于正则表达式这个字符串处理的重头戏嘛，因为tr1中都有了regex库了，平时使用的时候还是以此为主吧，相对string_algo这个宿命就是存在于boost的库来说，tr1的regex库在将来肯定可移植性及通用性更强。

 

# 五、   稀泥终究糊不上墙

虽然string_algo可以弥补std::string的功能缺陷，但是string的性能问题又怎么解决啊？。。。。因为string如此的弱，导致stringstream的使用都有很大的问题（在内存上），有兴趣的可以再网上搜搜，当年工作的时候就是因为太相信标准库，结果用了stringstream来实现整数到string的转换，结果经历除了痛苦就是痛苦，公司服务器因为此问题全服停止了2次。stringstream在作为局部变量存在的时候都会无止尽的消耗内存，这点我以前怎么也无法想象。

实际中的使用也是反应了std::string的悲哀，看看有多少实际的项目中没有实现自己的一套string?

其实寄希望于regex库出来后，std::string就能涅槃也不是太可能，std::string的string可能在平时的使用中是个简化编程的好办法，但是在对性能和内存占用稍微有点追求的程序，估计，std::string的使用还是会少之又少。。。。。。。。。。。

 

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)