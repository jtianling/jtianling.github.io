---
layout: post
title: Lisp的给力特性(V.S. Python3） -- 第一篇
categories:
- Lisp
- Python
tags:
- Lisp
- Python
status: publish
type: post
published: true
meta:
  ks_metadata: a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:0:"";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:0:"";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:48:"Lisp的给力特性(V.S.
    Python3） -- 第一篇";s:6:"robots";s:12:"index,follow";}
  _edit_last: '1'
  _wp_old_slug: "%0d%0a%20%20%20%20%20%20%20%20lisp%e7%9a%84%e7%bb%99%e5%8a%9b%e7%89%b9%e6%80%a7%28v-s-%20python3%ef%bc%89%20-%20%e7%ac%ac%e4%b8%80%e7%af%87%0d%0a%20%20%20%20%20%20%20%20"
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '50'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

## BS，Gosling，Anders,Guido都要被打屁股？

以前就听说过Lisp被很多人认为是世界上最好的语言，但是它是那么的古老，这种言论很可能来自于不能进化到学习Ruby,Python的老古董，所以其实也没有太在意。

Lisp(这里特指Common lisp,下同）1978年被设计完成，是个多么古老的语言啊。。。。却总是不停的听到太多的Lisp的好话，总是感觉有些难以相信，BS说，"一个新设计的语言不比老的好，那新语言的设计者是要被打屁股的"，假如Lisp还是世界上最好的语言，那么从BS自己，到James Gosling到Anders到Guido van Rossum 不都要被打屁股啊?

你说我能轻易相信吗？

“如果我们把流行的编程语言，以这样的顺序排列：Java、Perl、Python、Ruby。你会发现，排在越后面的语言，越像Lisp。”[这个话](<http://www.ruanyifeng.com/blog/2010/10/why_lisp_is_superior.html> "这个话")真的可信吗？

正好碰到一篇妄图说服我的文章《Features of Common Lisp》，眼见为实，是骡子是马，跑起来看看^^本文以Features一文为线索，（标题翻译的不好，请童鞋们见谅）与Python作为对比，C++啥的就都不太好意思拿出来比了，因为总是可以以效率为理由搪塞过去，但是，有可能我还是顺带提及一下。但是，总的来说，这是在Lisp的领地上战斗，,C++,Python是很吃亏的，但是作为已经足够强大的语言，还能够自我革新，Python的最新版本（3.1.1,以下没有特指，均指此版本）能够怎么应付，我拭目以待。特别提及，相比Lisp实现，CPython的运行速度慢得惊人，甚至差5-10倍，对于一个牺牲速度来换取表达性的语言，要是比不过速度比自己快那么多的语言，实在有些说不过去，即使是在别人的地盘..........迎战的Lisp是lispbox-0.7版本中集成的common lisp。

 

## Lisp特性列表

### 强大抽象的数学计算(Rich, exact arithmetic):

**大数( Bignums**)：

不用当心溢出。

Lisp:  
CL-USER>  
  
(expt (expt (expt (expt 10 10) 10) 10) 10)  
  
  
100000000000000000000000000000000000...  

这个貌似还行，C++虽然是需要通过外部库来处理，（在新标准中有过关于大数的提案，我以前还翻译过一篇《[(N1744)Big Integer Library Proposal for C++0x](<http://www.jtianling.com/archive/2007/08/23/1755273.aspx>)

》）

但是Python对大数的支持还是非常不错的，特别提及，在Python2.1时代，虽然有大数支持，但是你得自己指定，假如都是用普通整数，还是会溢出。在2.2以后版本中已默认会进行类型提升。（参考[PEP237](<http://www.python.org/dev/peps/pep-0237/> "PEP237")

）呵呵，这点挺符合越新的语言（在Python来看，也就是越新的版本越接近）也就是越接近Lisp的理论。

Python:  
>>> ((((10 ** 10) ** 10) ** 10) ** 10)  
1000000000000000000000000000000000000000000

.....

**分数( Rational numbers**)：

保留成比例的形式。

Lisp:  
CL-USER>  
(+ 5/9 3/4)  
47/36

这个很牛很牛。。。。我目前懂的语言，(C/C++,Lua,Python,Objc以后提及均表示此意）还没有哪个是这样计算分数的，给你的都是浮点数。

特别提及一点，在Python2.x时代，上面的整数运算会像C++中那样，直接变成整数（5/9也就是0），但是新版本中已经不那么扭曲了。  
Python 2.6.4:  
>>> 5 / 9

0

Python3:  
>>> 5 / 9

0.5555555555555556  

我很遗憾的表示，同样的，python3比2.X版本更加像lisp,但是还不是足够像。

### 复数(Complex numbers)：

内建支持

Lisp:  
CL-USER>  
(* 2 (+ #c(10 5) 4))

#C(28 10)  
  
这个也还算方便，虽然我平时好像也用不上，C++中得通过库处理。Python也内建支持。  
Python:  
>>> (((10 + 5j) + 4) * 2)

(28+10j)

相对来说，以近似伪码著称的Python表达还是更加清晰一些。

 

### 统一的引用(Generalized references)：

Lisp：

CL-USER> (defvar *colours* (list 'red 'green 'blue))

*COLOURS*

CL-USER> (setf (first *colours*) 'yellow)

YELLOW

CL-USER> *colours*

(YELLOW GREEN BLUE)

CL-USER> (push 'red (rest *colours*))

(RED GREEN BLUE)

CL-USER> *colours*

(YELLOW RED GREEN BLUE)

Lisp的操作都是使用引用对列表进行操作，你可以改变这个列表，实际操作的是同一个列表，就像你使用了rest操作，并对其进行push，但是实际也还是会改变原来的colours，因为rest返回的也还是引用而不是临时变量，这个特性看起来很有意思，有些特殊，具体的使用范围我还不是太清除（因为毕竟没有lisp编写大型的程序）

比如：

Python:

>>> l

['red', 'yellow', 'green', 'blue']

>>> l ;

['red', 'yellow', 'green', 'blue']

>>> l = ["red", "green", "blue"]

>>> l[0] = "yellow"

>>> l

['yellow', 'green', 'blue']

>>> l[1:]

['green', 'blue']

>>> l2 = l[1:].insert(0, "red")

>>> l2

>>> l

['yellow', 'green', 'blue']

需要注意的是，l[1:].insert(0, "red")操作是不会返回['red','green','blue']的，这样你临时的变量都获取不到，同样的，用切片操作来模拟的话，不仅没有返回值，原列表更不会改变，因为切片后的是临时变量，而不是引用。

### 多重值(Multiple values)：

Lisp:

CL-USER> (floor pi)

3

0.14159265358979312D0

有简单的内建语法支持多个值,因此能方便的让函数返回多个值。此点C++就靠其他手段吧，比如异常ugly的用传指针/引用，然后再通过指针/引用传出去，虽然用了这么多年的C++了,这种方式也习惯了，但是一比较，就知道那不过是个因为语言的抽象能力太弱，使用的walk round的办法而已。 Python还是可以的。

虽然，Python的floor不返回两个值。  
Python：

>>> import math

>>> math.floor(math.pi)

3

但是，你的确是可以返回多个值。  
Python：

>>> def myFloor(x):

return math.floor(x), x - math.floor(x)

>>> myFloor(math.pi)

(3, 0.14159265358979312)

但是，需要特别注意的是，这只是个假象......因为实际上是相当于将返回值作为一个tuple返回了。  
Lisp:

CL-USER> (+ (floor pi) 2)

5

在计算时，让第一个多重值的第一个变量作为计算的变量，所以非常方便。

因为Python的返回值如上面所言，其实是用tuple模拟多个返回值的，不要奢望了。

  

Python:

>>> myFloor(math.pi) + 1

Traceback (most recent call last):

File "<pyshell#58>", line 1, in <module>

myFloor(math.pi) + 1

TypeError: can only concatenate tuple (not "int") to tuple

  

不过，lua倒是可以，可能lua还是从lisp那吸收了很多东西吧：

  

Lua(5.1.2以下同）：

> math.floor(math.pi)

> print(math.floor(math.pi))

3

> function myFloor(x)

>> return math.floor(x), x - math.floor(x)

>> end

> print(myFloor(math.pi)+ 1)

4

而且在Lisp中可以很方便的使用多重值的第二个值。(通过multiple-value-bind)

  

Lisp:

CL-USER> (multiple-value-bind (integral fractional)

(floor pi)

(+ integral fractional))

3.141592653589793D0

  

Python因为返回的是tuple，指定使用其他值倒是很方便，包括第一个（虽然不是默认使用第一个）

  

Python：

>>> myFloor(math.pi)

(3, 0.14159265358979312)

>>> myFloor(math.pi)[0] + myFloor(math.pi)[1]

3.141592653589793

  

最后，即使这样Lisp在表达方面还是有优势的，因为在lisp中floor只计算了一次，而python的表达方式得多次计算，除非起用临时变量。

### 宏（Macros）：

lisp的宏有点像其他语言中的函数，但是却是在编译期展开（这就有点想inline的函数了），但是在Lisp的fans那里，这被称作非常非常牛的 _syntactic abstraction_  

（语法抽象），同时用于支持元编程，并且认为可以很方便的创造自己的领域语言。目前我不知道到底与C++的宏（其实也是一样的编译期展开），还有比普通函数的优势在哪。（原谅我才学Lisp没有几天）

LOOP宏（The LOOP macro）：  
  
Lisp:CL-USER> (defvar *list*

(loop :for x := (random 1000)

:repeat 5

:collect x))

*LIST*

CL-USER> *list*

(441 860 581 120 675)

这个我有些不明白，难道在Lisp的那个年代，语言都是循环这个概念的。。。。导致，循环都是一个很牛的特性？

继续往下看就牛了

Lisp:

CL-USER> (loop :for elt :in *list*

:when (oddp elt)

:maximizing elt)

675

when,max的类SQL寻找语法

Lisp:

CL-USER> (loop :for elt :in *list*

:collect (log elt) :into logs

:finally

(return (loop :for l :in logs

:if (> l 5.0) :collect l :into ms

:else :collect l :into ns

:finally (return (values ms ns)))))

(6.089045 6.7569323 6.364751 6.514713)

(4.787492)

遍历并且进行分类。

我突然想到最近Anders在一次关于语言演化的演讲中，讲到关于[声明式编程与DSL](<http://blog.zhaojie.me/2010/04/trends-and-future-directions-in-programming-languages-by-anders-2-declarative-programming-and-dsl.html>)

例子，用的是最新加入.Net平台的LINQ：

他表示，语言是从：

Dictionary<string, Grouping> groups = new Dictionary<string, Grouping>();

foreach(Product p in products)

{  
if 

(p.UnitPrice >= 20)

{  
if 

(!groups.ContainsKey(p.CategoryName))

{  
Grouping r = new Grouping();

r.CategoryName = p.CategoryName;

r.ProductCount = 0;

groups[p.CategoryName] = r;

}

groups[p.CategoryName].ProductCount++;

}

}

List<Grouping> result = new List<Grouping>(groups.Values);

result.Sort(delegate(Grouping x, Grouping y)

{  
return

x.ProductCount > y.ProductCount ? -1 :

x.ProductCount < y.ProductCount ? 1 : 0;

}

);  

  

这种形式到：

LINQ：

var 

result = products

.Where(p => p.UnitPrice >= 20)

.GroupBy(p => p.CategoryName)

.OrderByDescending(g => g.Count())

.Select(g => new 

{ CategoryName = g.Key, ProductCount = g.Count() });

  

看看与Lisp有多像吧（连名字都像^^)。。。。。（具体例子参见《[编程语言的发展趋势及未来方向（2）：声明式编程与DSL](<http://blog.zhaojie.me/2010/04/trends-and-future-directions-in-programming-languages-by-anders-2-declarative-programming-and-dsl.html> "编程语言的发展趋势及未来方向（2）：声明式编程与DSL")》）

而，Anders提到这个是在2010年。。。。。Lisp是1958年的语言。。。这个恐怖了。。。

突然，《[为什么Lisp语言如此先进？](<http://www.ruanyifeng.com/blog/2010/10/why_lisp_is_superior.html> "为什么Lisp语言如此先进？")》里面的话，“编程语言现在的发展，不过刚刚赶上1958年Lisp语言的水平。当前最新潮的编程语言，只是实现了他在1958年的设想而已。

”在耳边响起。。。。。。因为Anders的例子更有意思，Python那简单的while，for循环，我就不列举了。

### Format函数（The FORMAT function）：

Lisp:

CL-USER> (defun format-names (list)

(format nil "~{~:(~a~)~#[.~; and ~:;, ~]~}" list))

FORMAT-NAMES

CL-USER> (format-names '(doc grumpy happy sleepy bashful sneezy dopey))

"Doc, Grumpy, Happy, Sleepy, Bashful, Sneezy and Dopey."

CL-USER> (format-names '(fry laurie))

"Fry and Laurie."

CL-USER> (format-names '(bluebeard))

"Bluebeard."

  

Format函数现在的语言基本都有，连C/C++语言都有，为啥值得一提？因为lisp的format更加强大。。。。。强大到可以自动遍历list（而lisp的最主要结构就是list)。上面的format可能感觉有些不好理解，其实主要是因为lisp中不用%而是用~，总体来说，不比C系语言的format更难理解，但是更加强大。最强大的地方就是~{~}组合带来的遍历功能。当然，最后一个单词带来的“and”，也是很震撼。。。这些都不是用一系列的循环加判断实现的，用的是一个format，强大到有点正则表达式的味道。

看python同样的例子，就能够理解了，要实现同样的功能，必须得加上外部的循环。

Python:

>>>import sys

>>>def format_name(list):

if len(list) > 0:

sys.stdout.write(list[0])

if len(list) > 1:

for index in range(1, len(list) - 1):

sys.stdout.write(", %s" % list[index])

sys.stdout.write(" and %s" % list[-1])

>>> format_name(l)

a, b and c

>>> format_name(l[0])

a

>>> format_name(l[0:2])

a and b

哪个更加简单，一目了然，lisp的format函数的确强大，即使在python3上也无法有可以媲美的东西。（新的format模版也好不到哪里去）

### Functional functions：（不知道怎么翻译）

函数是第一类值，可以被动态创建，作为参数传入，可以被return，这些特性相当强大。这也算是函数类语言最强大的特点之一了。（也许不需要之一吧）记得

Lisp:  
  
  
CL-USER> (sort (list 4 2 3 1) #'<)

(1 2 3 4)

  

回顾一下C/C++中的函数指针,C++中的函数对象有多么麻烦，看到这里差不多要吐血了。（PS：在新的标准中可能会添加进原Boost中的Function库，还是不错的，以前写过[一篇关于这个](<http://www.jtianling.com/archive/2009/05/28/4219043.aspx> "一篇关于这个")

的,这同样也印证越现代的语言是向越来越像Lisp的方向进化,只是在C++中，表现为通过库来弥补语言本身的不足

）

Python,lua的函数都是第一类值，（这里有个[讲Python的FP编程的文章](<http://blog.csdn.net/naive1010/archive/2004/11/23/192378.aspx> "讲Python的FP编程的文章")，非常不错）所以用起来一样的方便，只是python原生的sorted倒是不支持类似的操作：

sorted

(_iterable_  
[

, _key_  
]  
[

, _reverse_  
]

)

不过我们可以自己实现。

  

Python:（改自[这里的实现](<http://leejingui.com/blog/2010/11/quick_sort_py/> "这里")）

>>> def sort(L, f):

if not L:

return []

return sort([x for x in L[1:] if f(x , L[0])], f) + L[0:1] + /

sort([x for x in L[1:] if not f(x, L[0])], f)

>>> def less(a, b):

if a < b:

return True

else:

return False

>>> def greater(a, b):

if a > b:

return True

else:

return False

>>> l = [4, 2, 3, 1]

>>> sort(l, less)

[1, 2, 3, 4]

>>> sort(l, greater)

[4, 3, 2, 1]

  

总的来说，在这个函数编程的核心领域，Python还是不错的，看看上面的文章就知道，用Python也完全可以写出类似FP的代码，只是因为Python的OOP特性的存在，大部分人完全忽略了其FP特性而已。

《[为什么Lisp语言如此先进？](<http://www.ruanyifeng.com/blog/2010/10/why_lisp_is_superior.html> "为什么Lisp语言如此先进？")》里面举了个例子：

我们需要写一个函数，它能够生成累加器，即这个函数接受一个参数n，然后返回另一个函数，后者接受参数i，然后返回n增加（increment）了i后的值。  

此时

Lisp:

CL-USER> (defun foo(n)

(lambda(i)(incf n i)))

FOO

Lisp的实现很简单，但是Python的如下实现：

  

Python：

def foo (n):

return lambda i: n + i

文中说这样的语法是不合法的。。。。。。。于是乎，作者猜想“Python总有一天是会支持这样的语法的”，而事实上，经我测试，现在的Python已经完全支持此语法。。。。。（修正以前文章中的错误，原来的测试有误，  
这点也印证了程序语言进化的方向。）

但是，我还是感叹，即使学习了Python这样现代的语言，我的脑袋中也很少有关于函数的抽象，比如上面的例子中的那种，语言决定着你的思维的方式，决不是假话，我受了太多OO的教育，以至于失去了以其他方式思考程序的能力。

Joel Spolsky属于更为激进的一派，他认为，不良好支持函数抽象的语言根本不值的学习。（这里的函数抽象不是指有函数，而是指类似上面的形式。）现在的语言，从Ruby,Javascript，甚至Perl 5，都已经支持类似的函数编程语法，同时也感叹，能够进化的语言，你的学习总是不会白费的^^比如总是给我惊喜的Python。

未完,待续......................

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

 
