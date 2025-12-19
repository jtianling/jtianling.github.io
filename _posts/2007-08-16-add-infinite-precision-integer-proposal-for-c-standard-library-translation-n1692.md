---
layout: post
title: "增加无限长精确整数（infinite precision integer）给C++标准库的提案 简单翻译稿 N1692"
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
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文是一份提案，建议为C++标准库添加无限精度整数类，以处理超出内置类型范围的超大整数。文章详细探讨了其设计动机、数据结构、性能优化及具体接口方案。

<!-- more -->

A Proposal to add the Infinite Precision Integer to the C++ Standard Library N1692 1 July 2004

原作者：M.J. Kronenburg

e-mail: M.Kronenburg@inter.nl.net

原文链接:http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2004/n1692.pdf

九天雁翎简单翻译稿：

**增加无限长精确整数（infinite precision integer）给C++标准库的提案**

1 动机：

对整数的需要不再适应于处理器数据长度的增加。比如，int类型的范围在一个32位电脑上是±2^31≌ ±10^9.对于超出这个范围的情况，程序员往往创建一个用unsigned int 和符号位组成的C++类，这个类的数据长度仅仅受可用内存的限制。并且重载了数学操作符。这个类的整数范围是±2^8m，m是以字节度量的最大可用内存。以现在的内存大小来说，这个范围实际上是无限的。这个类就是一个无限长精确整数，我提议这个类的名字为integer。

目前有很多无限长精确整数的实现存在，以下给出一些总的来说比较好的支持，实现和设计方案：

1. Gnu C++ library 中的 Integer 类 (C++, 限制在10^5 位以内 [7]).
2. The Gnu Multiple Precision Arithmetic Library (C with assembler, 无限[6]).
3. 我自己设计的Integer class (C++ with assembler, 无限)

在以后，我提到实现1，2，3就是分别指以上几种。

2 对标准的影响

作为一个有自己内存管理的独立类，没有对标准产生影响。

3 设计结果

有很多设计结果，但是选择通常就是在我在上面列出来的几种中进行。

3.1 类结构

这个被提议的C++类将是integer类。实现这个类，使用int的函数和操作符是需要被重载的，并且重载求最大公约数和最小公倍数的函数也是必须的，而且一些类似setbit,clearbit,getbit,highestbit,lowestbit等的位级操作也是需要重载的。在实现1里面的Integer类是用包含一个struct的方式表示的。这意味着，每个类函数或者操作符调用的函数都是作用在这个struct上面。实现2是一个在C上的实现。所以要在C++上面使用，需要一个C++的封装。在实现3里，这个Integer类是一个内部没有用struct表示的简单的C++类。这里有一个从string创建对象的构造函数，因此任何数字可以由一个任意长度的string指定。

3.2 数据结构

在所有以上我提到的实现中，数据都是一个连在一起的可变长二进制块。一个可以保存-1（小于0），0（零）,和1（大于0）值的符号被存储在一个分开的地方。一个可行的方法是把数据放在一个标准库容器vector中，但是像许多integer操作在位级上实现一样，对vector容器实现的依赖是不可接受的。因此，integer不会使用任何标准库容器或者函数。

3.3 数据粒度

为了操作integer数据，它的粒度必须被定义，即一次操作多宽的数据块。在32位处理器上，实现1用short 16位粒度，因为这意味着所有的移位和传送操作可以用32位的int实现，那么就不需要使用汇编。在32位处理器上，其他的实现用32位的粒度，这意味着汇编是不可避免的了。目前我还不清楚，是否64位处理器可以控制64位粒度的integer。

3.4 性能

所有的算术计算操作性能在使用32位粒度和汇编时都好很多。对于两个大数的乘法，很多算法存在（N 是数据的十进制或二进制位数:

| Algorithm | implementation | order | decimals | reference |
|---|---|---|---|---|
| Basecase | 1,2,3 | N^2 | 1 − 10^2 | |
| Karatsuba | 2,3 | N^1.585 | 10^2 − 10^3 | [1,4] |
| 3-way Toom-Cook | 2 | N^1.465 | > 10^3 | [1,4] |
| 16-way Toom-Cook | 3 | N^1.239 | > 10^3 | [1] |
| Sch¨onhage NTT | 2 | N logN log logN | > 10^3 | [2,3,4] |
| Strassen FFT | \- | \- N log^2 N | > 10^3 | [1,3,5] |

（NTT是数理论上的一种转换，FFT是快速傅利叶变换）。Starassen FFT算法因为是使用浮点计算法，所以对于非常大的参数它的准确性无法保证[4]，因此没有被我提到实现使用，但是他的是最好的。实现1只使用了basecase乘法，因此对于大参数来说它的性能很差。在实现3里面，我发现16-way Toom-Cook算法比Sch¨onhage NTT更快(直到一些我不知道的非常大的参数)。

对于除法和残余递归算法对于大参数有着更好的性能，而且在输入输出流来说也是一样的。意味着从二进制转换到十进制也是一样有着好的性能，而且反之亦然。

3.5 汇编的使用

在实现1里没有使用汇编，因此可以运行在任何平台上。实现2用了汇编，而且它是一个为了在类Unix平台运行的C语言编译器，它使用的汇编也是。实现3用了汇编，而且它是为了在Borland C++ Bulider 和 它的Turbo汇编编译器使用的。

3.6 总结

当的确需要从上述3个存在的实现中选一个的话，以下的情况可能要被考虑。因为实现1仅仅受限于大概10^5位（我不清楚为什么有这样的限制存在），这个实现作为无限制精确整数可能不是那么有用。而且对于很大的整数它的性能不好。实现2可能更多的在类Unix平台被选择，所有它需要的看起来是一个C++的封装。实现3可能更多地在Wintel平台被选择。另一个选项是与商业的代数运算程序开发商合作。

4 提案正文

4.1 需求

integer类的需求由包含在提案头文件的界面提供。这些断言和之前之后的情况都是很明显的，对于平均复杂度的需要也提供了，N 是数据的十进制或二进制位数：

```cpp
class integer
{
private:
    unsigned int *data, *maxdata;
    signed char thesign;
public: // Complexity:
    integer(); // 1
    integer( int ); // 1
    integer( double ); // 1
    integer( const char * ); // < N^2 (see 3.4)
    integer( const string & ); // < N^2 (see 3.4)
    integer( const integer & ); // N
    virtual ~integer(); // 1
    const unsigned int size() const; // 1
    integer &operator=( const integer & ); // N
    integer &negate(); // 1
    integer &abs(); // 1
    integer &operator++(); // 1
    integer &operator\--(); // 1
    const integer operator++( int ); // N
    const integer operator\--( int ); // N
    integer &operator|=( const integer & ); // N
    integer &operator&=( const integer & ); // N
    integer &operator^=( const integer & ); // N
    integer &operator<<=( unsigned int ); // N
    integer &operator>>=( unsigned int ); // N
    integer &operator+=( const integer & ); // N
    integer &operator-=( const integer & ); // N
    integer &operator*=( const integer & ); // < N^2 (see 3.4)
    integer &operator/=( const integer & ); // < N^2 (see 3.4)
    integer &operator%=( const integer & ); // < N^2 (see 3.4)
    const integer operator-() const; // N
    const integer operator<<( unsigned int ) const; // N
    const integer operator>>( unsigned int ) const; // N
};

const bool operator==( const integer &, const integer & ); // N
const bool operator!=( const integer &, const integer & ); // N
const bool operator>( const integer &, const integer & ); // N
const bool operator>=( const integer &, const integer & ); // N
const bool operator<( const integer &, const integer & ); // N
const bool operator<=( const integer &, const integer & ); // N
const integer operator|( const integer &, const integer & ); // N
const integer operator&( const integer &, const integer & ); // N
const integer operator^( const integer &, const integer & ); // N
const integer operator+( const integer &, const integer & ); // N
const integer operator-( const integer &, const integer & ); // N
const integer operator*( const integer &, const integer & ); // < N^2 see 3.4)
const integer operator/( const integer &, const integer & ); // < N^2 see 3.4)
const integer operator%( const integer &, const integer & ); // < N^2 see 3.4)

const integer gcd( const integer &, const integer & ); // ?
const integer lcm( const integer &, const integer & ); // ?
ostream & operator<<( ostream &, const integer & ); // < N^2 (see 3.4)
istream & operator>>( istream &, integer & ); // < N^2 (see 3.4)
const int sign( const integer & ); // 1
const bool even( const integer & ); // 1
const bool odd( const integer & ); // 1
const bool getbit( const integer &, unsigned int ); // 1
void setbit( integer &, unsigned int ); // 1
void clearbit( integer &, unsigned int ); // 1
const unsigned int lowestbit( const integer & ); // 1
const unsigned int highestbit( const integer & ); // 1
const integer abs( const integer & ); // N
const integer sqr( const integer & ); // < N^2 (see 3.4)
const integer pow( const integer &, const integer & ); // ?
const integer factorial( const integer & ); // ?
    // floor of the square root, like int sqrt( int )
const integer sqrt( const integer & ); // ?
    // random integer >= first and < second argument
const integer random( const integer &, const integer & ); // ?
const int toint( const integer & ); // 1
const double todouble( const integer & ); // 1
```

为了错误控制，可能需要创建一个独立的exception类:

```cpp
class integer_exception : public exception
{ public:
    enum type_of_error {
        error_unknown, error_overflow,
        error_divbyzero, error_memalloc, ...
    };
    integer_exception( type_of_error = error_unknown, ... );
    virtual const char * what () const;
private:
    type_of_error error_type;
    string error_description;
};
```

5 没有解决的问题

5.1 需要的gcd,lcm,sqrt,pow,factorial复杂度还不清楚。
5.2 全部的无限长精确整数性能应该与著名的商业数学软件进行比较。
5.3 在无限长精确整数上，真实的精度应该可以被定义。

6 引用

1\. D.E. Knuth, The Art of Computer Programming, Volume 2 (1998).
2\. P. Zimmermann, An implementation of Sch¨onhage’s multiplication algorithm (1992).
3\. A. Sch¨onhage and V. Strassen, Computing 7 (1971) 281.
4\. Free Software Foundation, Gnu MP manual ed. 4.1.2 (2002).
5\. http://numbers.computation.free.fr/Constants/Algorithms/fft.html
6\. http://www.swox.com/gmp
7\. http://www.math.utah.edu/docs/info/libg++ 20.html
