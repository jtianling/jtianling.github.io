---
layout: post
title: "一天一个C Run-Time Library 函数  (11)  bsearch"
categories:
- C++
tags:
- bsearch
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

    

## 一天一个C Run-Time Library 函数  (11)  bsearch

write by 九天雁翎(JTianLing) -- www.jtianling.com

 

## msdn:

Performs a binary search of a sorted array. A  
more secure version is available; see [bsearch_s](<ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_vccrt/html/d5690d5e-6be3-4f1d-aa0b-5ca6dbded276.htm>).  
  
---  
void  
*bsearch(     const void *_key_ ,    const void *_base_ ,    size_t _num_ ,    size_t _width_ ,    int ( __cdecl *_compare_ ) ( const void *, const  
void *)  );  
  
 

 

## 测试程序：(来自MSDN)

#include <search.h>

#include <string.h>

#include <stdio.h>

 

int compare( char **arg1, char **arg2 )

{

    /* Compare all of both strings: */

    return _strcmpi(  
*arg1, *arg2  
);

}

 

int main( void )

{

    char *arr[]  
= {"dog", "pig",  
"horse", "cat",  
"human", "rat",  
"cow", "goat"};

    char **result;

    char *key  
= "cat";

    int i;

 

    /* Sort using Quicksort algorithm: */

    qsort( (void *)arr, sizeof(arr)/sizeof(arr[0]), sizeof( char * ), (int (*)(const

       void*, const void*))compare );

 

    for( i  
= 0; i < sizeof(arr)/sizeof(arr[0]); ++i  
)    /* Output  
sorted list */

       printf( "%s ", arr[i] );

 

    /* Find the word "cat" using  
a binary search algorithm: */

    result = (char **)bsearch( (char *) &key,  
(char *)arr,  
sizeof(arr)/sizeof(arr[0]),

       sizeof( char * ), (int (*)(const void*, const void*))compare );

    if( result  
)

       printf( "/n%s found at %Fp/n", *result, result  
);

    else

       printf( "/nCat not found!/n" );

}

## 说明：

bsearch又是一个看起来相当有用，但是其实我却一次都没有在实际工作中碰到需要用的函数。。。。二分查找是算法教学的经典内容，呵呵

实际中我还真没有碰到这样的需要，因为碰到需要快速查找的时候一般都用map搞定了。。。人哪。。。才发现用C++也是会越来越懒的。。。。。因为有STL吗，所以map用的不亦乐乎，早完了C语言中该怎么来实现类似效果了。其实就算是想要实现我也很可能是用C++算法库的binary_search吧。

 

** **

## 实现：

MS:

gcc:

对于这样经典的算法好像gcc和MS终于没有办法不一致了，事实上也是如此，两者几乎没有任何区别，其实现可以在任何关于算法的书籍上找到。

 

## 效率测试：

见以前有人说过C++的二分查找会比C语言的快，这是很多用C++的人证明C++不比C语言慢的一个例证。但是实际上，我也一直认为，不用其他非C语言特性的东西，为啥C++会比C语言慢呢？除非硬是碰到喜欢用类来描述这样算法的人吧。

 

## 相关函数：

qsort，不先排序，二分查找可是没有办法进行的

 

## 个人想法：

非常标准的C语言函数，通用性非常好。最后，我越来越懒了，并且发现这样写下去已经比较脱离我当时的想法了。。。。。现在每天工作回来还真的是很辛苦，脑袋都一直比较痛的感觉。。。。呵呵，郁闷啊。另外，再一次证明了我的恒心和毅力都是很有问题的。于是我找到了又一个来拖延此专题的借口，那就是我发现我现在去学习关于数据结构和算法还有Unix环境高级编程等书的话，实际意义更大。。。。。。。另外，对于多弄弄lua,python也是很有益处，没有想到C语言函数库的函数这么多，这么杂，这么多我完全就没有用过。。。。。用C++的人（比如我），常常将自己使用的语言称为C/C++，似乎表示自己用C++,就一直象在用C一样,自己懂C++也就懂C了,不过,其实两者的区别,比我想的要大的多.因为C++有了太多特性,所以很多C语言的相关特性难免都被丢在了被遗忘的角落了.

 

 

write by 九天雁翎(JTianLing) -- www.jtianling.com

 
