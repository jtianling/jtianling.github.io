---
layout: post
title: "对Linker.Lin的 《[备忘]Lua的local是定义不是声明!》的研究"
categories:
- Lua
tags:
- Lua
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '11'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

# 对Linker.Lin的 《[备忘]Lua的local是定义不是声明!》的研究

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

因为这样的特性实在是太奇怪了，所以不得不好好研究一下。

原文见<http://blog.csdn.net/linkerlin/archive/2008/12/25/3603897.aspx>

由于很短，我贴过来，顺便给他的代码上个色

test1:

1 g='hi~'  
2 **local**  g='hello!'  
3 **for**  i=1,2 **do**  
4     **local**  g=g..'1'  
5 print(g)  
6 **end**

输出:

hello!1

hello!1

 

他的结论很明显了，题目就是了。先推断一下他的理解(假如不对请告诉我啊：)）

因为上述程序输出

hello!1

hello!1

而下面这种仅仅去掉了local的程序

test2:

1 g='hi~'  
2 **local**  g='hello!'  
3 **for**  i=1,2 **do**  
4     g=g..'1'  
5 print(g)  
6 **end******

 

输出的是

hello!1

hello!11

 

注意区别，没有local的时候，g相当于直接在原有的基础上加了1，而加了local的时候是两次重新的定义，都是hello!1。自此，Linker.Lin得出了结论，“Lua的local是定义不是声明!”。呵呵，好像一切都比较符合逻辑，不知道Linker.Lin是不是这样理解的。

 

其实，我的理解是，虽然这一次local的声明导致g变成定义，但是说local就是定义。。。。好像很奇怪。。。。。

test3:

1 g='hi~'  
2 **local**  g='hello!'  
3 **for**  i=1,2 **do**  
4     x=g..'1'  
5 print(x)  
6 **end**

 

一样是可以得出

hello!1

hello!1

的和test1一致的输出的，这里x没有local，也是定义

test2：得出的那样的结果原因在于，由于for外部已经有个变量g了，所以在用

g=g..'1'

的语句时，相当于使用了外部的g,即将for前的local g的g改变了，第二次循环的时候，还是用外部的g,此时的g已经被改变了，所以相当于在hello1后再加了个1.

而test1:中用了local，其实是声明此处的g变量为局部变量，而局部没有g变量，按照lua的规则是自动定义出g变量来进行操作的，此时for循环内局部的g赋值为hello1，当此次循环结束时，局部的变量g自动销毁（作用域结束了），第二次循环开始的时候，重新定义了新的局部变量g，所以两次都是hello1。

这里多给出几个例子：

test4:

1 g='hi~'  
2 **local**  g='hello!'  
3 **for**  i=1,2 **do**  
4     g = g .. '1'  
5     print(g)  
6 **end**  
7 print(g)

输出：

hello!1

hello!11

hello!11

证明内部变量g的使用，实际是用了外部的变量g

最后来个复杂点的例子：

test5:

 1 g='hi~'  
 2 **local**  g='hello!'  
 3 **for**  i=1,2 **do**  
 4     print(x)  
 5     x = x **and**  x .. '1' **or**  g .. '1'  
 6     print(x)  
 7     **local**  x = x .. '1'  
 8     print(x)  
 9     **local**  x = x .. '1'  
10     print(x)  
11 **end**  
12 print(x)

输出

nil                               \-- 第一次进入循环输出时，x为nil

hello!1                               \-- 因为x为nil,所以第5行第一次运行后，x为g..’1’，此处x明显也是定义

hello!11                      \-- local x = hello!1 .. ‘1’  
还没有什么好奇怪的

hello!1                        \-- 第二次进入循环，此时x已经有值了，并且是hello!1，那么表示此值是前一个没有加local定义的x，因为local x应该起码是hello!11  吧

hello!11                      \-- 第二次第五行后此时非local的x也变成了hello!11

hello!111                    \-- 此时local x又重新定义一次，所以等于hello!11 .. ‘1’

hello!11                      \-- 非local的x有超出for的作用域

 

其实，这仅仅是个作用域的问题，lua中有起码有两个作用域，全局的，局部的，for构成一个Block(块)，构成一个局部的概念，local的变量，作用域就在此局部内直到此局部范围结束。一个循环结束后，也算是一次局部范围的结束。于是local的变量销毁了。

形成了上述的看似奇怪的输出结果，其实本质上是作用域的特点，仅仅是三个语言特点的叠加效果。

1.       
lua作为动态脚本语言有的自动定义变量特性。

2.       
几乎所有的语言的（起码我知道的那么几种是）都有局部掩盖全局的概念，这是为了更好的局部化，不因为全局的东西影响局部。

3.       
lua比较少见的默认全局特性，这点的确少见（bash也是），因为这是和前一点的好处相违背的，可能属于老的脚本语言的遗留特性。

特性1自动定义特性的结果就是在一个作用域中发现使用一个没有定义的变量（上述例子中为x或g）就自动定义一个来使用，而不需要像静态语言（如C/C++）中一样先确定的定义，再使用。特性2局部掩盖导致在用local声明使用某个局部变量时，lua发现局部没有此变量，就自动定义了一个。并且此local变量的作用域内，再次使用此变量名，优先使用局部的，比如test5第8，10行输出的就是local变量的值，而不是前一个全局的x.

默认全局不影响Linker.Lin的测试，但是影响了最后一个测试的结果。

总而言之，Linker.Lin能够得出的结论都是变量的作用域问题，就算是其他语言也是类似的：

为了对比，看一个C++程序（不调试了啊）

string  
str = “Hello!”;

for (int  
i = 0; i  < 2; ++i)

{

       string str = str + “1”;

       cout <<string;

}

cout  
<<string;

 

只是，在C++中，局部的概念是默认的，没有local，一样定义。

 

但是，呵呵，好东西都是留到最后嘛，（不要怪我前面废话那么多，认清楚问题嘛，靠C++吃饭的我。。。有个特点就是喜欢知其然，并知其所以然，所以解释起来都是一大堆的。。。。）

当

for  
i=1,2 do

local g  
= ‘1’

local g  
= ‘2’

end

时，第二个g是复用了第一个g呢？还是重新定义了一个新的变量g?这才是问题的关键。最简单的办法自然是看两个g的地址是否一样。。。。不过好像没有把办法（还是我不知道？？）在lua中获取一个普通变量的地址啊。

我尝试这样做

 1 g  
= **{}**  
 2 **for**  i=1,2 **do**  
 3     io.write("global  
g:")  
 4     print(g)  
 5     **local**  g = **{}**  
 6     io.write("first  
local g:")  
 7     print(g)  
 8     **local**  g = **{}**    
 9     io.write("second  
local g:")  
10     print(g)  
11 **end**  
12 print(g)

毕竟table是可以看到地址的。。。。结果输出的地址是不一样的。我可以确定结论了吗？真是这样也许还草率了一点。这点也许还不一定能够说明问题，因为每次lua都会创建{}，两次的{}可以都是创建出来的，g不过就是对于{}的一个引用，两次输出不同的地址也许仅仅代表了两个不同的{}的地址而已，还是不能说明g的地址。

从普通代码没有办法获得结果，那么借助于其他办法罗，我首先想到的就是调试，没有问题，试试：

 1 #!/usr/bin/env lua  
 2   
 3 g = '1'  
 4 **for**  i=1,2 **do**  
 5     g = g .. '2'   
 6     **local**  g = '3'  
 7     **local**  g = g .. '4'  
 8     g = g .. '5'  
 9     **local**  i = 1  
10     **while**  true **do**  
11         **local**  name,value = debug.getlocal(1,i)  
12         **if**  **not**  name  
**then**    
13             **break**    
14         **end**  
15   
16         print(name, value)  
17         i  
= i + 1  
18     **end**  
19 **end******

输出的结果：

(for  
index)     1

(for  
limit)     2

(for  
step)      1

i       1

g       3

g       345

i       7

(for  
index)     2

(for  
limit)     2

(for  
step)      1

i       2

g       3

g       345

i       7

 

第5行对g的使用，但是没有输出证明debug.getlocal并不是对每个在局部使用的变量都获取，仅仅获取在局部分配的变量，那么一次g 3，一次g 345的出现就很能说明问题了，g 34的定义也没有出现，说明getlocal仅仅获取的是分配变量的最后保留值，作为变量g，最后的值有2个，一个3，一个345，说明的确是一个local定义了一个变量。。。。。。只有到这个时候，我才能得出Linker.Lin的结论。

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 
