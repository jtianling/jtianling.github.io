---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（3） 最大子序列和问题"
categories:
- Lua
- Python
- "算法"
tags:
- Bash
- C++
- Lua
- Python
- "《数据结构与算法分析-C++描述》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文是最大子序列和问题的学习笔记，作者用C++、Lua、Python实现了四种效率不同的算法，从暴力法到线性最优解，并提供了完整代码。

<!-- more -->

# 一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（3）
最大子序列和问题


<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第39-43面，图2-5，2-6,2-7,2-8最大子序列和问题的解

总算有点技术含量了，呵呵，虽然说重复实现一下代码不难（不就是相当于翻译嘛），但是算法4为什么是正确的需要好好理解一下。

以下为实现部分:

CPP:

```cpp
// Maximum contiguous subsequence sum algorithm 1 - 4, worst to best
// From <<Data Structures and Algorithm Analysis in C++>> by Mark Allen Weiss
#include <stdio.h>
#include <stdlib.h>
#include <vector>
**using**  **namespace**  std;

**int**  maxSubSum1(
**const**  vector<**int** > &a)
{
    **int**  maxSum = 0;

    **for**(**int**  i=0; i<(**int**)a.size(); ++i)
        **for**(**int**  j=i; j<(**int**)a.size(); ++j)
        {
            **int**  thisSum = 0;

            **for**(**int**  k=i; k<=j; ++k)
                thisSum += a[k];

            **if**(thisSum > maxSum)
                maxSum = thisSum;
        }
    **return**  maxSum;
}

**int**  maxSubSum2(
**const**  vector<**int** > &a)
{
    **int**  maxSum = 0;

    **for**(**int**  i=0; i<(**int**)a.size(); ++i)
    {
        **int**  thisSum = 0;
        **for**(**int**  j=i; j<(**int**)a.size(); ++j)
        {
            thisSum += a[j];

            **if**( thisSum > maxSum)
                maxSum = thisSum;
        }
    }
    **return**  maxSum;
}

**int**  max3(**int**  a, **int**  b, **int**  c)
{
    **return**  ((a < b)?((b < c)?c:b):((a < c)?c:a));
}

**int**  maxSumRec(
**const**  vector<**int** > &a, **int**  left, **int**  right)
{
    **if**(left == right)
        **if**( a[left] > 0)
            **return**  a[left];
        **else**
            **return**  0;

    **int**  center = (left + right) / 2;
    **int**  maxLeftSum = maxSumRec(a, left, center);
    **int**  maxRightSum = maxSumRec(a, center + 1, right);

    **int**  maxLeftBorderSum = 0;
    **int**  leftBorderSum = 0;

    **for**(**int**  i=center; i >=left; --i)
    {
        leftBorderSum += a[i];
        **if**(leftBorderSum > maxLeftBorderSum)
            maxLeftBorderSum = leftBorderSum;
    }

    **int**  maxRightBorderSum = 0,rightBorderSum = 0;
    **for**(**int**  j = center + 1; j <= right; ++j)
    {
        rightBorderSum += a[j];
        **if**(rightBorderSum > maxRightBorderSum)
            maxRightBorderSum = rightBorderSum;
    }

    **return**  max3(maxLeftSum, maxRightSum, maxLeftBorderSum + maxRightBorderSum);
}

**int**  maxSubSum3(**const**  vector<**int** > &a)
{
    **return**  maxSumRec(a, 0, a.size() - 1);
}

**int**  maxSubSum4(
**const**  vector<**int** > &a)
{
    **int**  maxSum = 0, thisSum = 0;

    **for**( **int**  j = 0; j< (**int**)a.size(); ++j)
    {
        thisSum += a[j];

        **if**(thisSum > maxSum)
            maxSum = thisSum;
        **else**  **if**(thisSum < 0)
            thisSum = 0;
    }

    **return**  maxSum;
}

**int**  main(**int**  argc, **char** * argv[])
{
    // for easy
    **int**  a[] = { -2, 11, -4, 13, -5, -2};
    vector<**int** > lvec(a, a + **sizeof**(a)/**sizeof**(**int**));

    printf("maxSubSum1(lvec)):%d/n",maxSubSum1(lvec));
    printf("maxSubSum2(lvec)):%d/n",maxSubSum2(lvec));
    printf("maxSubSum3(lvec)):%d/n",maxSubSum3(lvec));
    printf("maxSubSum4(lvec)):%d/n",maxSubSum4(lvec));

    exit(0);
}
```

LUA:

```lua
#!/usr/bin/env lua

function maxSubSum1(a)
    assert(type(a) == "table", "Argument a must be a number array.")

    **local**  maxSum = 0

    **for**  i=1,#a do
        **for**  j=i,#a    do
            **local**  thisSum = 0
            **for**  k=i,j do
                thisSum = thisSum + a[k]
            end

            **if**  thisSum > maxSum **then**
                maxSum = thisSum
            end
        end
    end

    **return**  maxSum
end

function maxSubSum2(a)
    assert(type(a) == "table", "Argument a must be a number array.")

    **local**  maxSum = 0

    **for**  i=1,#a do
        **local**  thisSum = 0

        **for**  j=i,#a do
            thisSum = thisSum + a[j]

            **if**(thisSum > maxSum) **then**
                maxSum = thisSum
            end
        end
    end
    **return**  maxSum
end

function max3(n1, n2, n3)
    **return**  (n1 > n2 **and**  ((n1 > n3) **and**  n1 **or**  n3) **or**  ((n2 > n3) **and**  n2 **or**  n3))
end

-- require math

function maxSumRec(a, left, right)
    assert(type(a) == "table", "Argument a must be a number array.")
    assert(type(left) == "number" **and**  type(right) == "number",
            "Argument left&right  must be number arrays.")

    **if**  left == right **then**
        **if**  a[left] > 0 **then**
            **return**  a[left]
        **else**
            **return**  0
        **end**
    **end**

    **local**  center = math.floor((left + right) / 2)
    **local**  maxLeftSum = maxSumRec(a, left, center)
    **local**  maxRightSum = maxSumRec(a, center+1, right)

    **local**  maxLeftBorderSum = 0
    **local**  leftBorderSum = 0
    **for**  i=center,left,-1 do
        leftBorderSum = leftBorderSum + a[i]
        **if**  leftBorderSum > maxLeftBorderSum **then**
            maxLeftBorderSum = leftBorderSum
        **end**
        i = i - 1
    **end**

    **local**  maxRightBorderSum = 0
    **local**  rightBorderSum = 0
    **for**  j=center+1,right do
        rightBorderSum = rightBorderSum + a[j]
        **if**  rightBorderSum > maxRightBorderSum **then**
            maxRightBorderSum = rightBorderSum
        **end**
    **end**

    **return**  max3(maxLeftSum, maxRightSum, maxLeftBorderSum + maxRightBorderSum)
end

function maxSubSum3(a)
    assert(type(a) == "table", "Argument a must be a number array.")

    **return**  maxSumRec(a, 1, 6)

end

function maxSubSum4(a)
    assert(type(a) == "table", "Argument a must be a number array.")

    **local**  maxSum = 0
    **local**  thisSum = 0

    **for**  i=1,#a do
        thisSum = thisSum + a[i]

        **if**  thisSum > maxSum **then**
            maxSum = thisSum
        **elseif**  thisSum < 0 **then**
            thisSum = 0
        **end**

    **end**

    **return**  maxSum

end

-- Test Code

t = { -2, 11, -4, 13, -5, -2 }

print("maxSubSum1(t):" .. maxSubSum1(t))
print("maxSubSum2(t):" .. maxSubSum2(t))
print("maxSubSum3(t):" .. maxSubSum3(t))
print("maxSubSum4(t):" .. maxSubSum4(t))
```

PYTHON:

```python
#!/usr/bin/env python

# How Short and Clean it is I shocked as a CPP Programmer
**def**  maxSubSum1(a):
    maxSum = 0

    **for**  i **in**  a:
        **for**  j **in**  a[i:]:
            thisSum = 0

            **for**  k **in**  a[i:j]:
                thisSum += k

            **if**  thisSum > maxSum:
                maxSum = thisSum
     
    **return**  maxSum

**def**  maxSubSum2(a):
    maxSum = 0

    **for**  i **in**  a:
        thisSum = 0
        **for**  j **in**  a[i:]:
            thisSum += j

            **if**  thisSum > maxSum:
                maxSum = thisSum

    **return**  maxSum


**def**  max3(n1, n2, n3):
    **return**  ((n1 **if**  n1 > n3 **else**  n3) **if**  n1 > n2 **else**  (n2 **if**  n2 > n3 **else**  n3))

**def**  maxSumRec(a, left, right):
    **if**  left == right:
        **if**   a[left] > 0:
            **return**  a[left]
        **else** :
            **return**  0

    center = (left + right)//2
    maxLeftSum = maxSumRec(a, left, center)
    maxRightSum = maxSumRec(a, center+1, right)

    maxLeftBorderSum = 0
    leftBorderSum = 0
    **for**  i **in**  a[center:left:-1]:
        leftBorderSum += i
        **if**  leftBorderSum > maxLeftBorderSum:
            maxLeftBorderSum = leftBorderSum

    maxRightBorderSum = 0
    rightBorderSum = 0
    **for**  i **in**  a[center+1:right]:
        rightBorderSum += i
        **if**  rightBorderSum > maxRightBorderSum:
            maxRightBorderSum = rightBorderSum
      
    **return**  max3(maxLeftSum, maxRightBorderSum, maxLeftBorderSum + maxRightBorderSum)

**def**  maxSubSum3(a):
    **return**  maxSumRec(a, 0, len(a)-1    )

**def**  maxSubSum4(a):
    maxSum = 0
    thisSum = 0

    **for**  i **in**  a:
        thisSum += i

        **if**  thisSum > maxSum:
            maxSum = thisSum
        **elif**  thisSum < 0:
            thisSum = 0

    **return**  maxSum            
  
**def**  test():
    t = (-2, 11, -4, 13, -5, -2)   

    **print**  "maxSubSum1:%d" % maxSubSum1(t)
    **print**  "maxSubSum2:%d" % maxSubSum2(t)
    **print**  "maxSubSum3:%d" % maxSubSum3(t)
    **print**  "maxSubSum4:%d" % maxSubSum4(t)

**if**  __name__ == '__main__':
    test()
```

BASH:

```bash
#!/usr/bin/env bash
绕了我吧。。。。。特别是算法二。。复杂的递归用bash来写就是自虐。Bash似乎本来就不是用来描述算法用的，呵呵，以后没有什么事一般就不把bash搬出来了。
```

