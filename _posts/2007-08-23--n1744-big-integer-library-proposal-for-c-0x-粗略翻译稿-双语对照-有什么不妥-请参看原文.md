---
layout: post
title: "(N1744)Big Integer Library Proposal for C++0x 粗略翻译稿 双语对照（有什么不妥，请参看原文）"
categories:
- "翻译"
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
  views: '35'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

N1744=05­0004

 

Big Integer Library Proposal for C++0x

给C++ 0x标准的大整数库提案

 

九天雁翎粗略翻译稿

原文链接：

http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2005/n1744.pdf

 

 

 

 

 

 

 

_I ntroduction_

_引言_ _：_

This proposal aims to provide the standardese for N1692.

这个提案目标是给 N1692提案提供一个标准的行话。

It is meant to be self­contained, but implementers may still benefit from the background provided in N1692.

本提案原意是独立成文的，但是一些实现可能仍然得益于提案N1692提供的背景。

If included in TR1, this would fit best in chapter 5, Numerical facilities.

假如本提案能加入TR1,它最适合加入第5章，数值工具。

It is an extension from the second category (“New library components (types and functions) that are declared in entirely new headers”).

它是一个属于第二大类（“在完全新的头文件中声明的新的库组件（类型和函数）”）的扩展。

However, in that context the type long long cannot be assumed and must be replaced by long .

然而，在那个环境里，long long类型不能被假设已经包含，所以必须用long来替代。

 

  

Proposed changes:

已经提交的改变：

A. Add <integer> to 17.4.1.2/2 Table 11

A.增加<integer>给 17.4.1/2 表 11

 

 

B. Change 26/2 as follows:

B.如下改变 26/2: 

The following subclauses describe components for complex number types, numeric ( _n_ __ at a time) arrays, generalized numeric algorithms**,********unl imited********r****an ge********integers****** and facilities included from the ISO C library, as summarized in Table 79:

下面这些条款描述了包含在ISO C 库里面的复数类型，数值数组，无限长整数和相关函数工具。它们被总结在 表 79中：

Table 79—Numerics library summary

表 79 –数值库总结

Subclauses 条款 |  Headers 头文件  
---|---  
26.1 Requirements 需求 |     
26.2 Complex numbers 复数 |  <complex >  
26.3 Numeric arrays 数值数组 |  <valarra y>  
26.4 Generalized numeric operations  通用数值操作 |  <numeric >  
26.5 Unlimited range integer 无限长整数 |    **<****i****n****t****e****g****er****>**  
26.~~5~~ 6 C library C的库 |  <cmath> <cstdlib >  
  
 

 

C. Add the following paragraph after 26.4 Generalized numeric operations:

C．增加如下段落到 26.4 通用数值操作后面：

 

 

26.5 Unlimited range integer

26.5 无限长整数

1. The header <integer > defines a single class and numerous functions for representing and manipulating integral numbers whose range is limited by available memory.

头文件<integer>定义了一个和很多函数，用来表示和操作长度仅仅受限于可用内存的整数。

2.    Notes:all integer operations which return an (temporary) integer and many member operators may fail due to insufficient memory.

要点： 所有返回一个（临时）integer整数的操作和很多成员操作符可能因为没有足够的内存而失败。

Such errors are reported as overflow _e r r o r exceptions(as available memory defines the range of the integer class).

这样的错误会作为一个overflow_error异常被报告。（作为以可用内存来定义边界的整数类）。

 

以下主要是源代码，所以没有翻译，间杂的英文翻译起来工作量太大：

。。。。。。。。。。。。。。。。。。。

请参考原文。

 

 

1.   The class integer represents an integer number.

这个整数类表示一个整数。

_[__Not e:this_ ___is_ ___n ot_ ___a_ ___f_ _u ndamental_ ___typ e,____a_ _n_ _d_ ___t herefore_ ___n_ _o_ _t_ ___a_ ___si gned_ ___i nteger_ ___t_ _y_ _p_ _e_ ___i_ _n_ ___t he_ ___s ense_ ___o_ _f_ ___3_ _. 9.1_ ___– end_ ___N ote]_

_[__要点_ _：_ ___这个不是一个基础类型_ _，_ _因此一个带符号整数类在_ _3.9.1_ _最后的要点中是没有意义的_ _]_

D. Renumber 26.5 C library to become 26.6:

D．重编号 26.5 C 库到26.6:

26.6 C Library

26.6 C语言库                                                                                                                      

1.    Tables 80 and 81 describe headers <cmath> and <cstdlib > …

表 80 和 81 描述了头文件 <cmath>和<cstdlib> …

_R_ _a_ _ti onale_:

基本原理:

The class would fit better after <comple x> 26.2, but this would involve renumbering 26.3 <valarra y> and 26.4 <numeric > .

这个类将更适合在<complex> 26.2,但是这将使26.3<valarray>和26.4<numberic>重编号。 However, 26.5 (C library) is different enough that it should be last.

然而，26.5（C语言库）是一个太不同的部分，应该一直保持不变。

Therefore, this proposal inserts the paragraph after 26.4 <numeri c> .

因此，这个提案插到26.5<numberic>段落后面。

 

Just like std::str i n g introduces a variable­length string to complement char[N], this class introduces an integer class without a fixed size.

就像std::string 引入了一个可变长字符串到char[N]一样，这个类引入了一个没有确定大小的integer类。

Like std::str in g , no new literals are created.

就像 std::string,没有新的概念被创造出来。

This class too can use string literals in initializations, e.g.

这个类也可以用string字符串常量来初始化，例如：

std::integer foo  =  “12345 67 89 0 12 3 4 5 6 7 8 9 0 ” ;

 

Like std::str in g , such initializations can be optimized at compile time.

像 std::string,这样的初始化可以在编译时优化。

The benefits are larger here,

这个优点在这里更大，

as this involves a base conversion (decimal/binary), but it still is a QoI issue.

作为一个调用了基础转换，但是它仍然是一个 Qol 问题。（恕我不知道Qol是什么意思）

 

The extra complexity of an unsige d_ i nt e g e r class is considered too much for the savings of a single sign bit.

这个unsiged_integer额外的复杂性在于为节省一个符号位考虑了太多。

 

 

The postfix operato r+ + (i n t ) must create a temporary, which is a rather expensive O(n) operation.

这个后置操作 operator++(int) 必须创建一个临时变量，这个操作是一个开销O(n)的操作。 Therefore it is not included, nor is operator - - (int) .

因此它没有被包含，operator--（int）也是这样。

 

Many functions have overloads taking long long int .

许多函数有重载long long int的版本。

These have better complexity bounds, typically by a factor of N. Adding long int , plain int and/or short int overloads would provide only marginally more efficient overloads.

这些函数有更好的复杂边界，典型的以N为因子。加入对 long int,plain int 与/或 short int 的重载将只是提供了更多有效率却不那么重要的重载。

Adding double overloads would increase the ranges, but there are no convincing cases known for integer ::i nt e g e r ( d o u b l e )or operator+=(double).

加入 double 的重载将增加这个范围，但是这里没有一个令人确信的理由增加integer::integer(double) 或者 operator+=(double). However,operator*=(double)and operator/=(do u b l e )are provided.

然而，还是提供了operator*=(double) 和 operator /= (double)。

Closely related to this, it is unclear what the type of （double（ 0.5)+integer  )) should be.

与这个有很密切联系的是，它让 (double(0.5) + integer))到底应该是什么类型变得不清楚。

The exact implementation of operator * = is left to the implementation, but it is required to be better than straightforward multiplication (which would be O(N2), and the complexity bound specified is < O(N2) ).

这个对于 operator*= 的额外实现方法是留给编译器去实现的，但是它需要比直接相乘更好(复杂度将是O(N2),这个复杂度界限制定是 <O(N2) ).

N1692 offers a number of alternatives.N1692 offers no guidance on division.

提案N1692 对于乘法提供了很多选择。但是 却没有提供对于除法的引导。  

The Gnu GMP documentation suggests that <O(N2) is unreasonably expensive (scheduled for GMP5.0,H2 2005),which is why the operator/=(integer const&) proposed here has a quadratic complexity bound.

GNU GMP 文档（GMP5.0,H2 2005） 建议除法复杂度 <O(N2) 是不合理的,这是为什么 operator/=(integer const&) 提议在这里有一个二次的复杂度边界。

Of course, a high­quality implementation may use the better algorithms.

当然，一个高质量的实现可以用更好的算法。

The &= , |= and ^= operators operate as if the shortest of their operands has leading zeroes added to match the length of the other operand.

&=,|= 和 ^=操作符的操作是让最短的操作数加入前导的0来匹配其他操作数的长度。 This ensures that expressions like(integer(“1234567891234567890”)|1)don’t truncate their left hand side.There is no overload of operator<< with signature integer operator<< (long long lhs,size_t rhs);This would allow the expression 1<<size_t(65) but would require core changes.

这点确保了像（integer(“1234567891234567890”) | 1）这样的表达式不会截断左操作数。这里没有提供operator<< 和有符号的整数 operator<<(long long lhs,size_t rhs)的重载;这将会允许表达式1<<size_t(65)，但是需要核心的改变。

     The sqr function is added because the operation is common, but the obvious implementation v*v uses the generic multiplication algorithm.

 Sqr函数被加了进来，因为这个操作时很普遍的，但是显然 实现 V*V用通用的乘法算法。 The proposed wording allows this, but also allows optimized algorithms. E.g. using the conventional O(N2)  algorithm, 123*123 is 100*100 + 100*20 + 20*100 + 100*3 + 3* 100 \+ 20*20 + 20*3 + 3*20 + 3*3 (9 multiplies, 8 additions) whereas sqr(123) can also be calculated as 100*100 \+ 2*100*20+ 2*100*3 + 20*20 + 2*20*3 + 3*3 (6 multiplies, 3 bitshifts, 5 additions).(Of course, this implementation is not allowed for either operator* or sqr because they both should have better complexities.)

这个提案的语法允许这些，但是也允许优化的算法。比如，用传统的O(N2)算法，123*123 是100*100 + 100*20 + 20*100 + 100*3 + 3* 100 \+ 20*20 + 20*3 + 3*20 + 3*3 (9 个乘法, 8 个加法)(当然，这个实现不允许operator*或者sqr使用，因为他们都应该有更好的复杂性)

     Like matrices, these numbers can become quite large, which means that temporaries may have significant overhead.

像矩阵一样，这些数字可能变得相当大，意味着临时变量可能有相当明显的开销。 Therefore, similar techniques could be applied to them.

因此，类似的技术可以对它们应用。

In particular, the common form a*b+c could be optimized by returning an intermediate type from operator* and adding overloads for that type to operator+.This proposal does not allow this,but since no internal representation is mandated a run­time equivalent technique can be used.

特别的，普通的a*b+c形式可能以从operator*返回一个中间值的形式优化，而加重operator+的负担。这个提案不允许这样，但是因为没有内在的表示法被要求，一个运行时相同的技术可以被使用。

 

             Equivalent to the common small string optimalization,implementers could choose not to use dynamically allocated memory if the value held is small enough(e.g. no larger then LONGLONG_MAX).

作为与普通的小字符串相同的优化方案，实现可以选择不去使用动态分配内存，假如这个值足够的小（例如，不大于LONGLONG_MAX）。

 This can be enforced by requiring integer::integer(long long) to succeed.

这些可以被强制执行，通过integer::integer(long long)的方式。

 This proposal does not want to enforce that decision, although it silently assumes that behavior in the description of operator long long().

这个提案不是想要强制执行这个决定，虽然它默默地假设这个行为被operator long long()所描述。

     This class does not specify an std::allocator template argument.

这个类不是特化一个std::allocator 模板参数。

This is not an explicit decision, and the LWG might consider adding it.

这不是一个准确的决定，然而LWG可以考虑增加它。

               

原文 Copyright Michiel Salters / Nederlands Normalisatie Institute.

 
