---
layout: post
title: "《Inside C++ Object 》 阅读笔记(1)， NRV（Named Return Value）"
categories:
- C++
tags:
- C++
- NRV
- "《Inside C++ Object 》"
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

  

  
  

# 《Inside C++ Object 》 阅读笔记(1)， NRV（Named Return  
Value）

 

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

书其实看完了，因为实在公司抽中午吃饭剩余时间看的，所以其实一直没有好好的试验一下，现在将书带到家里好好的一个一个将感兴趣的测试一下了。

 NRV（Named Return Value）是我阅读《Inside C++ Object》碰到的第一个感兴趣的东西，书上面有Lippman的测试数据和侯捷的测试数据。当然，对于VS的效率一直没有报太大希望，但是不至于这个Lippman所说的编译器的义不容辞的优化都不做吧。可能因为侯捷用的VC5.0实在太老了，于是我自己决定测试一下。

 

首先在Linux下,我测试了一下。测试代码书上有，我还是贴一下：

#include <stdio.h>

#include <stdlib.h>

#include <memory>

#ifdef _WIN32

#include “jtianling.h”

#endif

using namespace std;

 

 

class CTest

{

    friend CTest  
foo(double);

public:

    CTest()

    {

       memset(array, 0, 100*sizeof(double));

    }

// 以下面的语句决定是否进行NRV

    CTest(const  
CTest&t)

    {

       memcpy(this, &t, sizeof(CTest));

    }

 

private:

    double array[100];

};

 

CTest foo(double val)

{

    CTest local;

 

    local.array[0]  
= val;

    local.array[99]  
= val;

 

    return local;

}

 

 

int main(int argc, char* argv[])

{

#ifdef _WIN32

    double timenow  
= jtianling::GetTime();

#endif

    for(int  
i=0; i<10000000;  
++i)

    {

       CTest t = foo(double(i));

    }

 

 

#ifdef _WIN32

    timenow = jtianling::GetTime()  
\- timenow;

 

    cout <<timenow;

#endif

    system("pause");

    exit(0);

}

 

因为在linux下我有sheel下的time可以用，所以不需要自己在程序中计时（实际上这还导致linux下的时间会长一些，因为记上了循环外的部分，包括了main的调用等），windows下用我自己的带有gettime的一个库。

效果是很有意思的，在linux下测试得出不进行NRV优化，进行NRV优化（g++ -O1）和进行NRV优化(g++ -O3)时，在我的P3 800的可怜机器上得出的结果是8.61,5.08,4.67。

在我的windows下用VS 2005 SP1编译，跑在E2160的机子上，debug时，没有拷贝构造，即理论上不进行NRV优化时的时间是5.07，加上拷贝构造函数，即理论上进行NRV时的时间的确和侯捷一致，时间增加到了5.55.可见起码在关闭优化的时候，VS2005没有进行优化。

开启优化呢？更绝得事情来了，VS2005将整个循环优化掉了-_-!作弊！时间虽然短到-7e，但是我也不承认：）

罪证拷贝如下：

00401038  call         
edi 

0040103A  fild         
qword ptr [esp+30h] 

0040103E  fild         
qword ptr  
[___@@_PchSym_@00@UnbLwlxfnvmgUerhfzoLhgfwrlLCAAFUkilqvxghUgvhgxifmgrnvUgvhgkrhzhxrrUivovzhvUhgwzucOlyq@+8  
(403390h)] 

00401044  fdivp        
st(1),st 

     for(int i=0;  
i<10000000; ++i)

     {

         CTest t =  
foo(double(i));

     }

 

     timenow =  
jtianling::GetTime() - timenow;

00401046  mov          
edx,dword ptr  
[___@@_PchSym_@00@UnbLwlxfnvmgUerhfzoLhgfwrlLCAAFUkilqvxghUgvhgxifmgrnvUgvhgkrhzhxrrUivovzhvUhgwzucOlyq@+8  
(403390h)] 

0040104C  fstp         
qword ptr [esp+30h] 

00401050  or          edx,dword ptr  
[___@@_PchSym_@00@UnbLwlxfnvmgUerhfzoLhgfwrlLCAAFUkilqvxghUgvhgxifmgrnvUgvhgkrhzhxrrUivovzhvUhgwzucOlyq@+0Ch  
(403394h)] 

00401056  jne          
main+67h (401067h) 

00401058  push        offset ___@@_PchSym_@00@UnbLwlx

 

会发现循环完全被抛弃掉了，不过虽然影响了测试，但是这个时候我还得承认这是条还算合理的优化，因为在release时，这个循环不能给我们带来任何我们想要的东西。实际上以前就经常碰到这样的问题，MS老是喜欢将它认为无意义的东西直接优化没有，。。。。常常影响测试。。。。。呵呵，今天我是的确想知道，它到底有没有NRV优化，于是，让这个循环有意义吧。

将程序改成如下状态

#include "jtianling.h"

#include <stdio.h>

#include <stdlib.h>

#include <memory>

using namespace std;

 

int gi = 1;

int gj = 1;

 

class CTest

{

    friend CTest  
foo(double);

public:

    CTest()

    {

       gj++;

       memset(array, 0, 100*sizeof(double));

    }

 

    //CTest(const CTest&t)

    //{

    //  gj++;

    //  memcpy(this,  
&t, sizeof(CTest));

    //}

 

    double array[100];

};

 

CTest foo(double val)

{

    CTest local;

 

    local.array[0]  
= val;

    local.array[99]  
= val;

 

    return local;

}

 

 

int main(int argc, char* argv[])

{

    double timenow  
= jtianling::GetTime();

    for(int  
i=0; i<10000000;  
++i)

    {

       CTest t = foo(double(i));

       gi = t.array[99];

    }

 

    timenow = jtianling::GetTime()  
\- timenow;

 

    cout <<timenow <<"/t"  
<<gi <<"/t"  
<<gj <<endl;

 

    system("pause");

    exit(0);

}

 

分别测试有copy constructor和没有的情况，结果仍然和以前一致，虽然速度很快，但是，有copy constructor的时候速度还是要慢一些，这点很让人不解，更让人不解的是，既然没有开启NRV，那么应该会有1次default constructor的调用用来构建临时变量，然后再有一次copy constructor来返回值，但是实际上gj显示default constructor和copy constructor中只有一个被调用了。说明起码是进行了某种优化了。

难道MS用的是另外一个不同于NRV的优化方案？

于是我还是从汇编来看，再怎么优化它逃不过我的眼睛：）

     for(int i=0;  
i<10000000; ++i)

00401337  xor          
esi,esi 

00401339  fstp         
qword ptr [esp+38h] 

0040133D  add          
dword ptr [gj (403024h)],989680h 

00401347  mov          
dword ptr [esp+30h],esi 

0040134B  jmp          
main+60h (401350h) 

0040134D  lea          
ecx,[ecx] 

     {

          CTest t = foo(double(i));

00401350  fild         
dword ptr [esp+30h] 

         gi =  
t.array[99];

00401354  call         
_ftol2_sse (401BE0h) 

00401359  add          
esi,1 

0040135C  cmp          
esi,989680h 

00401362  mov          
dword ptr [gi (403020h)],eax 

00401367  mov          
dword ptr [esp+30h],esi 

0040136B  jl           
main+60h (401350h) 

     }

Have you seen it?红色部分，当我第一次看到989680h的时候，它的值已经是一千万了，说白了就是MS将原来的废循环中的唯一一条不废的语句抽出来，然后在编译期就算好了这条不废语句应该有的值，然后运行时仅仅进行了一条赋值操作。而且绝的是，编译期的这个值的计算是按NRV优化后的流程进行的，即gj为1千万。。。。。。优化成这样，我不知道该怎么说了。。。。。根本就不会有任何的构造函数和拷贝构造函数的调用。

然后我将copy constructor注释掉，再次编译运行，最最让人惊讶的事情发生了，汇编代码完全一样。。。。。不是我眼睛不好使，我用BC对比后结果也是一样的。天哪，这还算优化吗？。。。。简直是恶意篡改代码........呵呵，说严重了。问题是。。。最大的问题是，无论我测多少次，一样的汇编代码，在有copy constructor的版本总会慢一些，数量级在0.0001上，我也曾怀疑可能是偶尔的机器性能波动，但是实际多次测试，有copy constructor的版本就是会慢一些，希望有人能给我解答这个问题。

 

 

**_write by_**** _九天雁翎_**** _(JTianLing) --  
blog.csdn.net/vagrxie_**

 
