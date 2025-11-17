---
layout: post
title: "几种典型算法的快速比较函数"
categories:
- "算法"
tags: []
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

几种典型算法的快速比较函数

 

声明：

```cpp
//因为这里主要是比较不同算法的实现,所以这里不区分算法及其实现,都称为算法
//比较算法的函数，其中算法函数的参数为数组（array)和整数(int)
//简写为AI，为了防止混乱，这里我没有使用函数的重载
//准备以后有新的不同参数的算法时再加入新的比较函数
//方便最后查看对比我没有使用常规的屏幕输出而是输出到文件
//输出文件名为CompareAlogorithmAIResult.txt
//而且此文件可以用Excel打开,比较清晰,方便保存
//比较函数的参数解释如下：
//第一参数:各算法的用vector<>表示的函数指针数组
//第二参数:vector<int>表示的一系列算法函数第二参数,用以做算法增长比较
//主要注意的是，这里的第二参数实际也是算法函数第一参数数组的大小
typedef void (*pfAI)(int [], int);
void CompareAlgorithmAI(const std::vector<pfAI> &pfAIVec,const std::vector<int>& vec);

//比较算法的函数，其中算法函数的参数为整数(int)
//简写为I，方便最后查看对比我没有使用常规的屏幕输出而是输出到文件
//输出文件名为CompareAlogrithmIResult.txt
//而且此文件可以用Excel打开,比较清晰,方便保存
//比较函数的参数解释如下：
//第一参数:各算法的用vector<>表示的函数指针数组，
//第二参数:vector<int>表示的一系列算法函数第二参数,用以做算法增长比较
typedef void (*pfI)(int);
void CompareAlgorithmI(const std::vector<pfI> &pfIVec,const std::vector<int>& vec);
```

 

实现：

```cpp
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

void CompareAlgorithmI(const std::vector<pfI> &pfIVec,const std::vector<int>& vec)
{
   double timeInAll = GetTime();  //这里保存所有比较花费的时间
   std::ofstream out("CompareAlogrithmIResult.txt");//将结果保存在这里
   
   //在文件中输入第一行
   out <<"parameter" <<'/t';
   for(int i=0; i<pfIVec.size(); ++i)
   {
      out <<"Algorithm " <<i+1 <<'/t';
   }
   out <<std::endl <<std::setprecision(4) <<std::scientific;
   
   double timeTaken;  //每个算法一次消耗的时间

   //以算法参数的数组个数为循环条件,每个数值让各个算法分别调用
   for(int i=0; i<vec.size(); ++i)
   {
      out <<vec[i] <<'/t';
      for(int j=0; j<pfIVec.size(); ++j)
      {
         timeTaken = GetTime();
         pfIVec[j](vec[i]); //实际调用不同算法
         timeTaken = GetTime() - timeTaken;
         out <<timeTaken <<'/t';
      }
      out<<std::endl;
   }
   timeInAll = GetTime() - timeInAll;
   out <<"Compared time in all: " <<timeInAll <<std::endl;
}
```

 

实际用法示例如下：

```cpp
int main()
{
   srand( long(jtianling::GetTime()) );
   typedef void (*pfAI)(int [], int);
   vector<pfAI> pfAIVec;
   //插入算法
   pfAIVec.push_back(RandArrayCreate2);
   pfAIVec.push_back(RandArrayCreate2a);
   pfAIVec.push_back(RandArrayCreate2b);
   //插入参数
   vector<int> vec;
   vec.push_back(250);
   for(int i=0; i<7; ++i)
   {
      vec.push_back(vec[i] * 2);
   }
   //直接调用，然后就可以通过文件查看了，建议用excel打开
   jtianling::CompareAlgorithmAI(pfAIVec, vec);
}
```

 

类似的算法比较函数都可以很容易设计出来，这样在比较几个算法的优劣时就方便多了。