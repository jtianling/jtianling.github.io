---
layout: post
title: "数据结构与算法分析 C++描述（第3版） 习题2.8 详尽分析"
categories:
- "算法"
tags:
- "《数据结构与算法分析-C++描述》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

详析三种随机数组生成算法，用数学归纳法证明其正确性，并用性能测试做对比。

<!-- more -->

数据结构与算法分析 C++描述（第3版） 习题2.8 详尽分析

Data Structures and Algorithm Analysis In C++ Third Edition By Mark Allen Weiss 转载请注明出处及作者：九天雁翎

a:因为1，2很明显，所以不证明了。

至于算法3，可以用数学归纳法证明,x详细证明如下：

1.当n=1时，a[0]=1，都是100%，成立；

2.当n=2时，

```cpp
for(i = 1; i < n; ++i)
   swap (a[i],a[ randInt(0,i)]);
```

第一次循环，当i=1时，此时a[0]=1,a[i]=a[1]；

randInt(0,1)有50%机会为0，50%机会为1，所以，swap(a[1],a[0])的机会为50%，即，序列为0,1; 1,0几率都为50%。 成立

3.当 n=3时，第二次循环时，当i=2时，此时有两种可能，原序列为0,1; 1,0的几率各为50%。randInt(0,2)可能为0,1,2的几率各位1/3.此时,原序列为0,1时,randInt(0,2)为0,那么此序列经过swap(a[2],a[0]),最后序列为2,1,0,此序列的可能性为(1/2)*(1/3)=1/6; 同理易得,最后此序列为

210, 021, 012, 201, 120, 102的几率各位1/6,而此序列的所有排列可能为  = 3 * 2 = 6,所以 此时成立.

4.假设此命题在n = k时成立，那么就是说，ｋ前面序列共有序列 种，且所有序列的几率为1/ .

5.当n=k+1时,第k+1次循环时,前面序列正好为n=k时的情况,此时i = k. randInt(0,k)共可能为0~k,k+1种可能。所以以前的每个可能序列在置换后有k+1种可能，而以前共有k种等可能序列，那么最后可能的序列为k*(k+1)种可能，并且，因为原序列为等可能的，每个等可能序列产生的序列都是k+1种，所以最后的序列也是等可能的。而当n=k+1时，应该共有 =(k+1)*k种，所以，此命题得证。

即算法3产生的也是等置换序列。

这里最后要说明的是，证明时默认地利用了一个命题，

当原序列为互不相等的等可能序列时，新加入一个与原来序列任何数值都不相等的数值，无论这个数值放在原序列的哪个位置，都不可能使原不相等的序列相等，说的好复杂啊-_-!

基本就是这样，210, 021, 012, 201, 120, 102，这是你加入一个新的数值3，无论你把3插入序列的哪个位置，因为原来序列的排列不相等，所以，他们还是不会相等，这样，才保证了最后k个序列的k+1种可能都不相等，不会重复。

算法分析答案说的很详细，可以参考答案，即第一个算法为O( ),第二个算法为O（NlogN）,第三个为线性。

实际算法的实现如下：

```cpp
#include "jtianling/jtianling.h"
#include "boost/dynamic_bitset.hpp"
using namespace std;

//2.8题目中假设存在的随机数生成器
//根据其定义,此算法生成从i到j的随机数,而且包括边界i,j.即i=<n<=j
int randInt(int i, int j)
{
   //确保i<j,不然就交换
   if(i > j)
   {
      int temp = i;
      i = j;
      j = temp;
   }
   //确保范围正确
   return rand()%(j-i+1) + i;
}

//算法,算法描述如题目.8所示,根据习惯,不对arr[]的大小做任何检验
//调用此函数的人应该确保这一点,即arr的大小大于等于n
void RandArrayCreate1(int arr[], int n)
{
   int temp;
   for(int i=0; i<n; ++i)
   {
      while(true)
      {
         temp = randInt(1,n);
         int j = 0;
         while(j<i)
         {
            if(arr[j] == temp){   break;}
            ++j;
         }
         if(j == i)
         {
            arr[j] = temp;
            break;
         }
      }
   }
}

//算法,算法描述如题目.8所示,根据习惯,不对arr[]的大小做任何检验
//调用此函数的人应该确保这一点,即arr的大小大于等于n
void RandArrayCreate2(int arr[], int n)
{
   //为了正好与数值一一对应，浪费位算了,默认就都为flase
   bool *used = new bool[n+1];
   memset(used, 0, sizeof(bool) * (n+1));
   int temp;
   for(int i=0; i<n; ++i)
   {

      while(true)
      {
         temp = randInt(1,n);
         if(used[temp] == false)
         {
            arr[i] = temp;
            used[temp] = true;
            break;
         }
         else
         {
            continue;
         }
      }
   }
   delete []used;

}

//算法,算法描述如题目.8所示,根据习惯,不对arr[]的大小做任何检验
//调用此函数的人应该确保这一点,即arr的大小大于等于n
void RandArrayCreate3(int arr[], int n)
{
   for(int i=0; i<n; ++i)
   {
      arr[i] = i + 1;
   }
   for(int i=0; i<n; ++i)
   {
      swap(arr[i], arr[randInt(0, i)] );
   }
}

void RandArrayCreate2a(int arr[], int n)
{
   //为了正好与数值一一对应，浪费位算了,默认就都为flase
   boost::dynamic_bitset<> used(n+1);
   int temp;
   for(int i=0; i<n; ++i)
   {

      while(true)
      {
         temp = randInt(1,n);
         if(used[temp] == false)
         {
            arr[i] = temp;
            used.set(temp);
            break;
         }
         else
         {
            continue;
         }
      }
   }

}
void RandArrayCreate2b(int arr[], int n)
{
   //为了正好与数值一一对应，浪费位算了,默认就都为flase
   vector<bool> used(n+1);
   int temp;
   for(int i=0; i<n; ++i)
   {

      while(true)
      {
         temp = randInt(1,n);
         if(used[temp] == false)
         {
            arr[i] = temp;
            used[temp] = true;
            break;
         }
         else
         {
            continue;
         }
      }
   }
}
```

这里对算法的测试用另外一个测试函数来进行：

```cpp
//因为这里主要是比较不同算法的实现,所以这里不区分算法及其实现,都称为算法
//比较算法的函数，其中算法函数的参数为数组（array)和整数(int)
//简写为AI，为了防止混乱，这里我没有使用函数的重载
//准备以后有新的不同参数的算法时再加入新的比较函数
//比较函数的参数解释如下：
//第一参数:各算法的用vector<>表示的函数指针数组
//第二参数:vector<int>表示的一系列算法函数第二参数,用以做算法增长比较
//主要注意的是，这里的第二参数实际也是算法函数第一参数数组的大小
void CompareAlgorithmAI(const std::vector<pfAI> &pfAIVec,const std::vector<int>& vec)
{
   double timeInAll = GetTime();  //这里保存所有比较花费的时间
   std::ofstream out("CompareAlogrithmAIResult.txt");//将结果保存在这里
   
   //在文件中输入第一行
   out <<"parameter" <<'/t';
   for(int i=0; i<pfAIVec.size(); ++i)
   {
      out <<"Algorithm " <<i+1 <<'/t';
   }
   out <<std::endl <<std::setprecision(4) <<std::scientific;
   
   double timeTaken;  //每个算法一次消耗的时间

   //以算法参数的数组个数为循环条件,每个数值让各个算法分别调用
   for(int i=0; i<vec.size(); ++i)
   {
      out <<vec[i] <<'/t';
      int *arr = new int[ vec[i] ];  //每次动态生成一个数组
      for(int j=0; j<pfAIVec.size(); ++j)
      {
       
         timeTaken = GetTime();
         pfAIVec[j](arr, vec[i]); //实际调用不同算法
         timeTaken = GetTime() - timeTaken;
         out <<timeTaken <<'/t';
      }
      delete []arr;   //删除arr,因为只考察算法的效率,所以根本不关心结果
                     //至于各算法是否正确由调用者保证
      out<<std::endl;
   }
   timeInAll = GetTime() - timeInAll;
   out <<"Compared time in all: " <<timeInAll <<std::endl;
}
```

最后得到的结果用excel打开，实在是更加赏心悦目而且更好的可以保存下来，可以只测试一个，也可以一次测试一组，以后的算法比较中还可以重复的利用，这里利用了vector来传递参数，有利于减少参数的数量。关于GetTime的含义，请参考置顶文章

| parameter |  RandArrayCreate1 |  parameter |  RandArrayCreate3  |
|---|---|---|---|
| 250 |  6.62E-04 |  100000 |  1.85E-02 |
| 500 |  4.61E-03 |  200000 |  3.78E-02 |
| 1000 |  1.59E-02 |  400000 |  5.83E-02 |
| 2000 |  6.70E-02 |  800000 |  1.17E-01 |
| Compared time in all: 8.9593e-002 |  1600000 |  2.30E-01 |
|   |   |  3200000 |  4.61E-01 |
|   |   |  6400000 |  9.22E-01 |
|   |   |  Compared time in all: 1.9196e+000 |
| parameter |  RandArrayCreate2 |  RandArrayCreate2a |  RandArrayCreate2b |
| 250 |  1.30E-04 |  7.51E-04 |  1.03E-02 |
| 500 |  2.72E-04 |  1.64E-03 |  1.88E-02 |
| 1000 |  6.78E-04 |  3.49E-03 |  5.65E-02 |
| 2000 |  1.41E-03 |  9.19E-03 |  1.11E-01 |
| 4000 |  2.70E-03 |  1.47E-02 |  2.63E-01 |
| 8000 |  5.97E-03 |  3.84E-02 |  4.66E-01 |
| 16000 |  1.31E-02 |  7.39E-02 |  1.33E+00 |
| 32000 |  3.60E-02 |  1.91E-01 |  2.39E+00 |
| Compared time in all: 5.0447e+000 |   |   |

很显然的结果，不多说了，不过书中给出要我运行的第2算法的参数实在是太大了，估计一天都运行不完，这里也可以看到，在动态bool位使用上，直接New最快，用Boost库的动态bit是其次，用标准库的vector<bool>只能用慢的出奇来形容了，当然，其实很多时候都是同样的结论，因为用new毕竟不是那么好管理，但是不需要建构析构，而用了类来管理，自然需要更多的时间资源，但是更好管理并且动态更改起来更加方便。这需要自己去权衡利弊了。

至于最E，最坏情况的分析，前两个在一直随机到重复数字的时候可以到无限大。。。汗！第三个算法是线性的，也无所谓最坏情况。
