---
layout: post
title: vector成员转换为char输出的六种方法,STL的学习过程乱想
categories:
- C++
tags:
- C++
- STL
- Vector
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

容器输出函数printCon测试过程中，想到的，那就是把vector<int>容器换成char形式输出，一下子想到很多方法，都列出来，主要目的当然还是测试printCon函数，另外想到Linus提到的C++复杂到让人有心智障碍了，说是用C++选择太多，功能太多，导致不知道用什么好的一种耽误编程效率的东西，看到实现一个如此简单的东西，方法都如此之多，实在是可以想象，为什么有人，而且是如同Linus这样的牛人会提出这样的观点了。唉，选择多也是罪过啊。。。。。比如我好东西不学习，把时间浪费在想这个简单的东西到底还有别的方法实现没有上去了。。。。如此推知，可知为什么有人批评C++太过学院派，社团以钻研奇怪的看似尖端的技术为乐，实际应用程序编写的简化却一直没有太多进展。。。。。既然方法那么多，我不如不选。。想到怎么实现就怎么实现啊。。。。。作为C++程序员是那么注重效率，一定会研究哪个效率最高的。。。。于是时间又流失了。。。。。。啊门………….下面的printCon函数来自于myself.h这个我自己平时使用的库，可以参考置顶文件。

 

 

  

#include "stdafx.h"

#include <iostream>

#include <memory>

#include <vector>

#include "myself.h"

using namespace std;

 

int main()

{

      vector<int> ivec;

      for(int i = '1'; i <= 'z'; ++i)

           ivec.push_back( i );

      myself::printCon(ivec,"ASCII value: ");

 

      //利用char类型的流迭代器输出

      cout<<"ASCII type one: ";

      copy( ivec.begin(),ivec.end(),ostream_iterator<char>(cout," ") );

      cout<<endl;

 

      //不知道说利用了什么，其实本质就是利用operator<<的不同重载版本

      vector<char> cvec( ivec.size() );  //通过ivec的大小构建cvec再复制的方法

      copy( ivec.begin(),ivec.end(),cvec.begin() );//复制到cvec后输出就自然变成char了

      myself::printCon(cvec.begin(),cvec.end(),"ASCII type two: ");

 

      //考虑到上面提及的情况，应该可以直接调用operator<<的char版本

      //原理诈唬，其实不过一个强制转换

      cout<<"ASCII type three: ";

      vector<int>::iterator iIter;

      for(iIter = ivec.begin(); iIter != ivec.end(); ++iIter)

      {

           cout<< static_cast<char>(*iIter)<<" ";

      }

      cout<<endl;

//另外，发现没有强制容器转换的操作符，没有办法，实现一个函数。

//因为不能在main里面实现,所以在最后实现，并在这里声明。

      extern vector<char> ivtocv(const vector<int> &int_vec);

      myself::printCon(ivtocv(ivec),"ASCII type four: ");

 

//当然，其实，直接利用构造函数创建也不是不可以

      myself::printCon(vector<char>(ivec.begin(),ivec.end()),"ASCII type five: ");

 

 

//其实再考虑一下，不知道C++除了强制转换对象外，还有没有强制调用某重载函数的方法

//无聊之极，重载<<输出操作符试试,因为不能在main里面实现，并且不希望干扰前面的操作

//所以在最后实现，并在这里声明。

      extern ostream& operator<<(ostream &os, const vector<int> &int_vec);

//如此，则可以直接输出vector<int>为char

      cout<<"ASCII type five: ";

      cout<<ivec;

      return 0;

}

 

vector<char> ivtocv(const vector<int> &int_vec)

{

      vector<char> char_vec;  //另一种通过复制创建char_vec的方法

      copy( int_vec.begin(),int_vec.end(),back_inserter(char_vec));

      return char_vec;

}

 

 

ostream& operator<<(ostream &os, const vector<int> &int_vec)

{

      copy( int_vec.begin(),int_vec.end(),ostream_iterator<char>(os," ") );

      cout<<endl;

      return os;

}

     

 
