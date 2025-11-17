---
layout: post
title: Google C++ Style中允许使用的Boost库(1)
categories:
- C++
tags:
- Boost
- C++
- Google
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '97'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

[_**write by 九天雁翎(JTianLing) -- blog.jtianling.com**_](<http://blog.jtianling.com/>)[](<http://www.jtianling.com>)

[_**新浪微博**_](<http://t.sina.com.cn/jtianling>)**  \-- **[_**讨论新闻组**_](<http://groups.google.com/group/jiutianfile>)  \-- [_代码库_](<http://code.google.com/p/jtianling/>)  \-- [_豆瓣_](<http://www.douban.com/people/JTianLing/>)

  
  

## **前言**

作为系列的第一篇，如同往常一样唠叨几句吧，好久不写这种单纯语言相关的（特别是C++）文章了，因为慢慢觉得这些东西自己学学就OK，实际写出来的价值有限，因为思想少，技巧/知识多。因为前段时间做了半年多的Object C和JAVA了，并且C++ 0x标准就要出来了，语言改变还挺大，趁这个节骨眼，顺便再回头学习/总结一些我感兴趣的C++知识吧，不过应该持续时间不会太长，这个系列也不会太长，因为语言已经不是我关注的重点~~~~  
[_Google的C++ Style Guide_](<http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml>) 是我自己写东西的时候遵循的C++代码风格规范，前段时间看到李开复说他才发现Google的C++规范已经公开了，说这是世界上最好的C++规范，我感到很惊讶，因为N年前这个规范已经就公开了-_-!事实上，Google的 C++ Style Guide远不仅是一个传统意义上的代码书写风格指导，对于C++的方方面面做出了Google的解释和使用建议，包括每个规则给出时，较为详细的讲了这个规则好的一面和不好的一面，最最激进的规则甚至有禁用C++的异常，以及除了Google规范的Interface作为基类外，禁用多重继承，在绝大部分情况下禁用默认参数等内容。在很大程度上，Google是想把C++打造成效率高的JAVA来使用~~~~  
[_Google的C++ Style Guide_](<http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml>) 有关于[ _Boost的一节_](<http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml#Boost>) ，允许使用的Boost库如下：  
  
[ _Call Traits_](<http://www.boost.org/libs/utility/call_traits.htm>)  from boost/call_traits.hpp  
[ _Compressed Pair_](<http://www.boost.org/libs/utility/compressed_pair.htm>)  from boost/compressed_pair.hpp  
[ _Pointer Container_](<http://www.boost.org/libs/ptr_container/>)  from boost/ptr_container except serialization and wrappers for containers not in the C++03 standard (ptr_circular_buffer.hpp and ptr_unordered*)  
[_Array_](<http://www.boost.org/libs/array/>)  from boost/array.hpp  
[ _The Boost Graph Library (BGL)_](<http://www.boost.org/libs/graph/>)  from boost/graph, except serialization (adj_list_serialize.hpp) and parallel/distributed algorithms and data structures (boost/graph/parallel/* andboost/graph/distributed/*).  
[_Property Map_](<http://www.boost.org/libs/property_map/>)  from boost/property_map, except parallel/distributed property maps (boost/property_map/parallel/*).  
The part of [_Iterator_](<http://www.boost.org/libs/iterator/>)  that deals with defining iterators: boost/iterator/iterator_adaptor.hpp, boost/iterator/iterator_facade.hpp, and boost/function_output_iterator.hpp  
  
对此我感到比较惊讶，除了Array没啥好疑问的以外，我发现一些的确很好用的Boost库Google并不允许使用，比如[ _boost::bind_](<http://www.jtianling.com/archive/2010/04/21/5509451.aspx>) , [_boost::function_](<http://www.jtianling.com/archive/2009/05/28/4219043.aspx>) , [_boost::lambda  _](<http://www.jtianling.com/archive/2009/05/22/4205134.aspx>)等，这个我不理解~~~~而Google提及的几个Boost库，除了Array很简单实用，BGL是一个数据结构和算法的扩充库，以前没有接触不奇怪外，其他的东西我发现自己竟然没有太接触过，作为自认为C++学习已经接近语言律师的我情何以堪-_-!~~~~~  
  
因为很多时候，一个Boost库就代表着一个C++的缺陷的补救，因为即使最后不用Boost库，了解一下对于怎么正确的使用C++还是有很大帮助的。特作此系列。  
1.[_Call Traits_](<http://www.boost.org/libs/utility/call_traits.htm>)  from boost/call_traits.hpp  
  
先谈谈什么是Traits，BS的解释如下：

_Think of a trait as a small object whose main purpose is to carry information used by another object or algorithm to determine "policy" or "implementation details". - Bjarne Stroustrup_  

可以参考[这里](<http://accu.org/index.php/journals/442> "这里")。所谓Call Traits就是调用时需要的Traits。 [Call Traits中文文档](<http://boost.ez2learn.com/libs/utility/call_traits.htm> "Call Traits中文文档")看下基本就明白啥意思了。我感觉最大的作用是在写模版类/模版函数传递参数时，保证没有“引用的引用”的情况发生，并且总以最高效的形式传递参数。所谓的最高效形式的规则类似JAVA，（仅仅是类似）即原生的类型就使用传值方式，对象就采用传引用方式。这里有个[中文的例子](<http://blog.csdn.net/whererush/article/details/1331031> "中文的例子")。

正常情况下，一个函数在C++中要么以传值方式传递参数，要么以传引用的方式传递，没法两者兼得：

template <class T>

class TestClass {

public:  

  TestClass(T value) {

  

  }

  

  TestClass(const T& value) {

  

  }

  

  T value_;

};

在使用时会报错：

error C2668: 'TestClass<T>::TestClass' : ambiguous call to overloaded function  

因为C++的函数重载规则并没有规定在这种情况下会调用哪一个函数，导致二义性。

使用Call_Traits的param_type作为参数类型时，以下例子：

int g_i = 0;

class PrintClass {

public:

  PrintClass() {

    printf("PrintClass created");

    ++g_i;

  }

};

  

template <class T>

class TestClass {

public:

  

  TestClass(typename boost::call_traits<T>::param_type value) : value_(value){

  

  }

  T value_;

};

  

  TestClass<int> test(10);

  

  PrintClass printClass;

  TestClass<PrintClass> testPrintClass(printClass);

  

g_i会等于1，实际因为传递的typename boost::call_traits<T>::param_type value在参数类型是PrintClass（一个对象）时，传递的是引用。同时，我没有想到更好的办法去验证在传递的参数是int类型时，的确是通过时传值。这样说来就很有意思了，因为即使我们在使用模版时函数全部通过传值方式来设计，会在T是对象时导致很大的额外开销，我们全部通过const T&的方式来传递参数就好了，就算是原生类型，这种额外开销还是小到足够忽略不计的，只是，boost库的制作者觉得这样还是不够完美？

同时，Call Traits还解决一个问题，那就是"引用的引用"，比如上例中T为T&时的情况..........函数参数假如是通过传递引用的方式的话，const T&的参数，T又等于T&，那么就是const T&&了，C++中没有引用的引用这种东西的存在（只有指针的指针），事实上，Call Traits给函数的调用和参数的类型有完整的一套解决方案，如boost文档中的[example 1](<http://boost.ez2learn.com/libs/utility/call_traits.htm> "example 1"):

template <class T>

struct contained

{

  // define our typedefs first, arrays are stored by value

  // so value_type is not the same as result_type:

  typedef typename boost::call_traits<T>::param_type       param_type;

  typedef typename boost::call_traits<T>::reference        reference;

  typedef typename boost::call_traits<T>::const_reference  const_reference;

  typedef T                                                value_type;

  typedef typename boost::call_traits<T>::value_type       result_type;

  

  // stored value:

  value_type v_;

  

  // constructors:

  contained() {}

  contained(param_type p) : v_(p){}

  // return byval:

  result_type value() { return v_; }

  // return by_ref:

  reference get() { return v_; }

  const_reference const_get()const { return v_; }

  // pass value:

  void call(param_type p){}

  

};

  

  

_2.[Compressed Pair](<http://www.boost.org/libs/utility/compressed_pair.htm>)_ from boost/compressed_pair.hpp  

这里正好找到一个很[perfect的文章](<http://hi.baidu.com/_%E2d_%B7%B3_%DE%B2%C2%D2/blog/item/2d8f76f57f0b0829bd3109cc.html> "perfect的文章")，简单的说就是当pair中某个类是空类时，compressed Pair比std中的pair会更省一些空间（1个字节...........），我几乎没有想到我实际工作中有什么对空间要求非常高并且还会使用pair的情况.................这也就是compressed_pair的尴尬之处了。可以稍微提及的是，看看compressed pair的定义，就能看到call traits的使用：

template <class T1, class T2>

class compressed_pair

{

public:

  typedef T1                                                 first_type;

  typedef T2                                                 second_type;

  typedef typename call_traits<first_type>::param_type       first_param_type;

  typedef typename call_traits<second_type>::param_type      second_param_type;

  typedef typename call_traits<first_type>::reference        first_reference;

  typedef typename call_traits<second_type>::reference       second_reference;

  typedef typename call_traits<first_type>::const_reference  first_const_reference;

  typedef typename call_traits<second_type>::const_reference second_const_reference;

  

  compressed_pair() : base() {}

  compressed_pair(first_param_type x, second_param_type y);

  explicit compressed_pair(first_param_type x);

  explicit compressed_pair(second_param_type y);

  

  compressed_pair& operator=(const compressed_pair&);

  

  first_reference       first();

  first_const_reference first() const;

  

  second_reference       second();

  second_const_reference second() const;

  

  void swap(compressed_pair& y);

};

  

说实话，虽然逻辑上感觉完美了，但是代码上还真是累赘...........typedef简直就是C++强类型+类型定义复杂最大的补丁工具.............但是总的来说compress pair是很简单的东西，不多讲。

  

3.[_Array_](<http://www.boost.org/libs/array/>)  from boost/array.hpp

Array也是最简单的boost库使用类之一了，用于以最小性能损失替代原生C语言数组，并且像vector一样，提供使用的函数和合理的封装（STL提供的vector因为是变长数组，还是有一定的性能损失）感觉不是非常非常效率要求的工程，可以将所有的C语言数组都用Array来代替，意义更加明确，迭代器使用也会更加方便，容器的使用语法也更加统一。另外，C++0X已经确定添加array库，array将来就是未来的标准库，可以较为放心的使用，并且即使使用了，也是可维护的代码（即使将来使用C++0X时也是一样）。

操作示例：

  boost::array<int, 100> intArray;

  

  intArray.fill(10);

  

  for (boost::array<int, 100>::iterator it = intArray.begin();

    it != intArray.end(); ++it) {

  

      *it = 20;

  }

  

  

小结：

基本上,

1.call traits是看需求了，假如你实现模板库有需要才使用，不要因为真的仅仅为了一个函数的参数调用能够以最优化的方式进行而去使用call traits。

2.comress pair是我不太推荐使用（为了一点点空间，而增加理解的难度不值，推荐的方式是将来STL的pair实现就是compress pair）

3.array是推荐使用  

  

原则是，有利于抽象和源代码易读性的用，否则不用.............

  

原创文章作者保留版权 转载请注明原作者 并给出链接

[_**write by 九天雁翎(JTianLing) -- blog.jtianling.com**_](<http://blog.jtianling.com/>)[](<http://www.jtianling.com>)

[](<http://www.jtianling.com>)  
[](<http://www.jtianling.com>)  

