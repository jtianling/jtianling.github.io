---
layout: post
title: "个人研究《数据结构与算法分析-C++描述》Vector实现的问题，new与初始化"
categories:
- Linux
- "算法"
tags:
- C++
- Vector
- "《数据结构与算法分析-C++描述》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '16'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

#  个人研究《数据结构与算法分析-C++描述》Vector实现的问题，new与初始化

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第61面， 图3-7,3-8，实现的一个列表Vector类。

原实现大概如下：（我可能修改了一些变量的命名以符合我的习惯）

```cpp
template<typename T>
class Vector
{
public:
    explicit Vector(unsigned auInitSize  
= 0)
       : muSize(auInitSize),muCapacity(auInitSize \+ SPARE_CAPACITY)
    {
       mpObjects = new T[muCapacity];
    }

    Vector(const Vector &aoObject):mpObjects(0)
    {
       *this = aoObject;
    }

    ~Vector()
    {
       delete[] mpObjects;
    }

    const Vector&  
operator= (const  
Vector &aoObject)
    {
       if(this  
== &aoObject)
       {
           return *this;
       }
      
       delete[] mpObjects;
       muSize = aoObject.size();
       muCapacity = aoObject.capacity();

       mpObjects = new T[ capacity() ];

       for(unsigned  
i=0; i!=muSize; ++i)
       {
           mpObjects[i] = aoObject[i];
       }

       return *this;
    }

    void resize(unsigned auNewSize)
    {
       if ( auNewSize  
> muCapacity )
       {
           reserve(auNewSize * 2 + 1);
       }
    }

    void reserve(unsigned auNewCapacity)
    {
       if(auNewCapacity  
< muSize)
       {
           return;
       }

       T *lpOldArray  
= mpObjects;

       mpObjects = new T[auNewCapacity];
       for(unsigned  
i=0; i!=muSize; ++i)
       {
           mpObjects[i] = lpOldArray[i];
       }
      
       muCapacity = auNewCapacity;

       delete[] lpOldArray;
    }

    T& operator[](unsigned auIndex)
    {
       return mpObjects[auIndex];
    }

    const T&  
operator[](unsigned  
auIndex) const
    {
       return mpObjects[auIndex];
    }

    bool empty()  
const
    {
       return (muSize == 0);
    }

    unsigned size()  
const
    {
       return muSize;
    }

    unsigned capacity()  
const
    {
       return muCapacity;
    }

    void push_back(const T& aoObject)
    {
       if(muSize  
== muCapacity)
       {
           reserve(2 * muCapacity \+ 1);
       }

       mpObjects[muSize++] = aoObject;
    }

    void pop_back()
    {
       muSize\--;
    }

    const T&  
back() const
    {
       return mpObjects[muSize-1];
    }

    typedef T*  
iterator;
    typedef const  
T* const_iterator;

    iterator begin()
    {
       return mpObjects;
    }

    const_iterator begin() const
    {
       return mpObjects;
    }

    iterator end()
    {
       return mpObjects \+ muSize;
    }

    const_iterator end() const
    {
       return mpObjects \+ muSize;
    }

    enum { SPARE_CAPACITY  
= 16 };

private:
    unsigned muSize;
    unsigned muCapacity;
    T *mpObjects;
};
```

 

首先的第一个感觉就是new了以后没有初始化，而且放任其未初始化的值的使用。（说的这么复杂，就是说使用了没有初始化的值贝）

但是实际我在Linux下测试的时候发现，g++是会自动将所有new出来的内存初始化的，事实就是如此，这和我在windows下的常识有冲突，所以特意做了一个测试程序来实验。

```cpp
int main( void )
{
    int *lpi  
= new int[100];

    for(int  
i=0; i<100;  
++i)
    {
       printf("%d",lpi[i]);
    }

    return 0;
}
```

 

在linux下总是会输出全0，哪怕我怀疑碰巧这段内存没有被使用过，将100变成1000也是全0.只能承认，new以后是自动初始化的了。

我甚至怀疑我的常识是否是错误的（虽然我以前为了保证初始化，认为每次new完以后，哪怕马上要全部的使用这些内存都会先用memset置空一下是个好的习惯）

 

事实上，在VS2005的测试中，结果我的常识一样，在debug版本下，windows会自动置为0xcdcdcdcd等值，release时为随机值。

我只能说，以前我一直没有注意到g++编译下自动初始化的事实。

然后我特意看了一下VS和libstdc++的vector实现，在resize(size)的时候都是T()作为第二参数调用重载的另一个函数resize(size,val)来实现的，也就是说，C++标准库的这两个实现还是确保reseize初始化了。

ok，也许Mark Allen Weiss的Vector在Linux下可以不出错。。。但是我还是认为这个程序写的有问题，加上初始化吧。。。。。。

自己Mark一下，原来g++编译的new带初始化的？希望有高人能够给我解答，假如不是g++编译的new带初始化那么是什么情况导致了这样的情况，还有，g++有关掉初始化的选项吗？

 **_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**