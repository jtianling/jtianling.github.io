---
layout: post
title: "(N1744)给C++ 0x标准的大整数库提案 粗略翻译稿"
categories:
- C++
tags:
- C++
- C++ 11
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

N1744=05­0004

 

给C++ 0x标准的大整数库提案

 

 

九天雁翎粗略翻译稿

 

原文链接：

http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2005/n1744.pdf

 

 

 

_引言_ _：_

这个提案目标是给 N1692提案提供一个标准的行话。本提案原意是独立成文的，但是一些实现可能仍然得益于提案N1692提供的背景。

假如本提案能加入TR1,它最适合加入第5章，数值工具。它是一个属于第二大类（“在完全新的头文件中声明的新的库组件（类型和函数）”）的扩展。然而，在那个环境里，long long类型不能被假设已经包含，所以必须用long来替代。已经提交的改变：

A.增加<integer>给 17.4.1/2 表 11

B.如下改变 26/2: 

下面这些条款描述了包含在ISO C 库里面的复数类型，数值数组，无限长整数和相关函数工具。它们被总结在 表 79中：

表 79 –数值库总结

Subclauses 条款 |  Headers 头文件  
---|---  
26.1 Requirements 需求 |     
26.2 Complex numbers 复数 |  <complex >  
26.3 Numeric arrays 数值数组 |  <valarra y>  
26.4 Generalized numeric operations 通用数值操作 |  <numeric >  
26.5 Unlimited range integer 无限长整数 |    **<****i****n****t****e****g****er****>**  
26.~~5~~ 6 C library C的库 |  <cmath> <cstdlib >  
  
 

 

C．增加如下段落到 26.4 通用数值操作后面：

26.5 无限长整数

1.    头文件<integer>定义了一个和很多函数，用来表示和操作长度仅仅受限于可用内存的整数。

2.    要点：所有返回一个（临时）integer整数的操作和很多成员操作符可能因为没有足够的内存而失败。这样的错误会作为一个overflow_error异常被报告。

（作为以可用内存来定义边界的整数类）。

 

 

 

 

 

 

以下主要是源代码，所以没有翻译，间杂的英文翻译起来工作量太大：

。。。。。。。。。。。。。。。。。。。

请参考原文。

 

 

1.         这个整数类表示一个整数。 _[__要点_ _：_ _这个不是一个基础类型_ _，_ _因此一个带符号整数类在_ _3.9.1_ _最后的要点中是没有意义的_ _]_

 

 

D．重编号 26.5 C 库到26.6:

26.6 C语言库                                                                                                                      

1.    表 80 和 81 描述了头文件 <cmath>和<cstdlib> …

 

 

基本原理:

这个类将更适合在<complex> 26.2,但是这将使26.3<valarray>和26.4<numberic>重编号。然而，26.5（C语言库）是一个太不同的部分，应该一直保持不变。因此，这个提案插到26.5<numberic>段落后面。

 

就像std::string 引入了一个可变长字符串到char[N]一样，这个类引入了一个没有确定大小的integer类。就像 std::string,没有新的概念被创造出来。这个类也可以用string字符串常量来初始化，例如：std::integer foo  =  “12345 67 89 0 12 3 4 5 6 7 8 9 0 ” ;

像 std::string,这样的初始化可以在编译时优化。这个优点在这里更大，作为一个调用了基础转换，但是它仍然是一个 Qol 问题。（Qol我不知道究竟是什么）

这个unsiged_integer额外的复杂性在于为节省一个符号位考虑了太多。这个后置操作 operator++(int) 必须创建一个临时变量，这个操作是一个开销O(n)的操作。因此它没有被包含，operator--（int）也是这样。

   许多函数有重载long long int的版本。这些函数有更好的复杂边界，典型的以N为因子。加入对 long int,plain int 与/或 short int 的重载将只是提供了更多有效率却不那么重要的重载。加入 double 的重载将增加这个范围，但是这里没有一个令人确信的理由增加integer::integer(double) 或者 operator+=(double).然而，还是提供了operator*=(double) 和 operator /= (double)。与这个有很密切联系的是，它让 (double(0.5) + integer))到底应该是什么类型变得不清楚。

   这个对于 operator*= 的额外实现方法是留给编译器去实现的，但是它需要比直接相乘更好(复杂度将是O(N2),这个复杂度界限制定是 <O(N2) ).提案N1692 对于乘法提供了很多选择。但是 却没有提供对于除法的引导。 GNU GMP 文档（GMP5.0,H2 2005） 建议除法复杂度 <O(N2) 是不合理的,这是为什么 operator/=(integer const&) 提议在这里有一个二次的复杂度边界。当然，一个高质量的实现可以用更好的算法。

   &=,|= 和 ^=操作符的操作是让最短的操作数加入前导的0来匹配其他操作数的长度。这点确保了像（integer(“1234567891234567890”) | 1）这样的表达式不会截断左操作数。这里没有提供operator<< 和有符号的整数 operator<<(long long lhs,size_t rhs)的重载;这将会允许表达式1<<size_t(65)，但是需要核心的改变。

      Sqr函数被加了进来，因为这个操作时很普遍的，但是显然 实现 V*V用通用的乘法算法。这个提案的语法允许这些，但是也允许优化的算法。比如，用传统的O(N2)算法，123*123 是100*100 + 100*20 + 20*100 + 100*3 + 3* 100 \+ 20*20 + 20*3 + 3*20 + 3*3 (9 个乘法, 8 个加法)

     像矩阵一样，这些数字可能变得相当大，意味着临时变量可能有相当明显的开销。因此，类似的技术可以对它们应用。特别的，普通的a*b+c形式可能以从operator*返回一个中间值的形式优化，而加重operator+的负担。这个提案不允许这样，但是因为没有内在的表示法被要求，一个运行时相同的技术可以被使用。

             作为与普通的小字符串相同的优化方案，实现可以选择不去使用动态分配内存，假如这个值足够的小（例如，不大于LONGLONG_MAX）。这些可以被强制执行，通过integer::integer(long long)的方式。这个提案不是想要强制执行这个决定，虽然它默默地假设这个行为被operator long long()所描述。

     这个类不是特化一个std::allocator 模板参数。这不是一个准确的决定，然而LWG可以考虑增加它。

 

      

  原文      Copyright Michiel Salters / Nederlands Normalisatie Institute.