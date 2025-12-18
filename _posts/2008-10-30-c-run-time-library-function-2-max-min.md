---
layout: post
title: "一天一个C Run-Time Library 函数(2) __max & __min"
categories:
- C++
tags:
- C++
- max
- min
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '6'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**一天一个****C Run-Time Library****函数****(2)****__max & __min**

**_write by 九天雁翎(JTianLing) -- www.jtianling.com_**

头文件 <stdlib.h>

## msdn:

Returns the larger of two values.  
  
---  
type __max(       _type_ _a_ ,       _type_ _b_ );  
  
Returns the smaller of two values.  
  
---  
type __min(       _type_ _a,_       _type_ _b_ );  
  
## 测试程序：

```c
#include <stdlib.h>

#include <stdio.h>

int main( void )
{
   int a = 10;
   int b = 21;

   printf( "The larger of %d and %d is %d/n",  a, b, __max( a, b ) );
   printf( "The smaller of %d and %d is %d/n", a, b, __min( a, b ) );
}
```

## 说明：

这次的测试程序因为MSDN中有sample，就使用了他们原来的程序，起码能够说明问题吧，其实作为一个本意是用来说明移植性的文章系列中，没有samlple也无所谓的。

又是两个双前置下划线的函数，事实上C语言参考和TCPL中也都没有说明，估计还是属于MS自己加的。

gcc无此函数，鉴于此函数的实用性，自然也需要实现一份。

对于这么简单的函数也就不多说明了，不然又太过了。

** **

## 实现：

MS:

```c
#define __max(a,b)  (((a) > (b)) ? (a) : (b))
#define __min(a,b)  (((a) < (b)) ? (a) : (b))
```

还是简单的宏，对于一个C++程序员来说，我不是太习惯，可能我属于原教义派，看多了Bjarne Stroustrup的书，心中总是对于宏有所排斥，我以前就因为被windows一个简单的宏折磨的够呛。那个宏也是关于最大，最小的,我在[ _http://www.jtianling.com/archive/2007/07/06/1680398.aspx_](<http://www.jtianling.com/archive/2007/07/06/1680398.aspx>)

一文中有所描述。

简而言之，就是windows.h中（实际定义在windef.h中，但是windows.h包含了windef.h，而windows.h才是经常包含的文件）

不知道新的C语言中有没有inline，实话说，那样要好的多。

```c
#ifndef NOMINMAX

#ifndef max
#define max(a,b)            (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif

#endif  /* NOMINMAX */
```

这样的效果是，所有的min,max都会被宏替换，甚至是

std::numeric_limits<T>::min()

或者

```cpp
#include "windows.h"

class max
{

};

int main( void )
{
    max* lpmax = new max();

    return 0;
}
```

这样的形式都会导致编译通不过，而第一种情况那可是C++标准库使用numeric_limits特性必须的。因为MS也给出了解决的方式。预先定义一个NOMINMAX的宏就能解决问题。

不知道新的C语言中有没有inline，实话说，那样要好的多。C语言运行库中再次实现了最大最小的函数，不过以双前置下划线的方式可以极大的防止宏替换的意外情况。

用C语言就得习惯宏，用C++我常常迫使自己忘记宏，有的时候感觉C与C++的区别还是挺大的，特别是C99以后。。。。。。。

对了，对于所有还不习惯C语言大面积用宏的兄弟说一句，这样的宏引进了这么多麻烦，其实还是有一个好处的，那就是省略了一次函数的调用。函数的调用在C /C++中开销不算太大，但是在高效率的要求下也不算小，可以看看以前我分析c++函数调用的文章。

http://www.jtianling.com/archive/2008/06/01/2501238.aspx

作为C语言来说，很多时候自然都是效率之上了。

 

## 效率测试：

略。

 

## 相关函数：

无。

 

## 个人想法：

虽然感觉这两个函数是会很常用到的，但是实际工作中还真没有用过一次。。。说实话，并不是没有这两个函数适用的场合，而是这样的场合自己用?:实现也很简单，所以常常根本想不到还有这样的两个函数可以实现，我更加是没有准备使用windows.h中max,min宏的想法，很简单就可以做到的事情，为什么要使用以导致移植性的降低了，没有理由。

 

**_write by 九天雁翎(JTianLing) -- www.jtianling.com_**