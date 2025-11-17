---
layout: post
title: Lisp的给力特性(V.S. Python3） 第二篇
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
  _edit_last: '1'
  ks_metadata: a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:0:"";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:0:"";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:0:"";s:6:"robots";s:12:"index,follow";}
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '34'
  _wp_old_slug: "%0d%0a%20%20%20%20%20%20%20%20lisp%e7%9a%84%e7%bb%99%e5%8a%9b%e7%89%b9%e6%80%a7%28v-s-%20python3%ef%bc%89%20%e7%ac%ac%e4%ba%8c%e7%af%87%0d%0a%20%20%20%20%20%20%20%20"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

[前一篇](<http://www.jtianling.com/articles/1172.html> "前一篇")在这里。

## Lisp特性列表

### 表处理(List Processing):

Lisp:

CL-USER> (defvar *nums* (list 0 1 2 3 4 5 6 7 8 9 10))

*NUMS*

CL-USER> (list (fourth *nums*) (nth 8 *nums*) (butlast *nums*))

(3 8 (0 1 2 3 4 5 6 7 8 9))

CL-USER> (remove-if-not #'evenp *nums*)

(0 2 4 6 8 10)

在Lisp中几乎什么都是list。。。。比在lua中什么都是table还要过分，因为不仅是数据，任何表达式，函数调用啥的也是表。。。。。不过用惯了[n]形式的我，还是对first,last,rest,butlast,nth n这种获取表中特定索引值的方式有些不适应。但是很明显有一点，Lisp对list的操作是不用循环就支持遍历的，看起来也许你会说不过就是语法糖而已，其实代表了更高层次的抽象，这就象C++中STL的for_each，transform一样,只是，他们的使用有多么不方便，我想每个用C++的人都能体会。

Python中虽然不是什么都是列表，但是Python对于list的处理还算是比较强大。

Python:

>>> l = list(range(11))

>>> l

[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

>>> lo = [l[3], l[7], [l[0:len(l)-1 ]]]

>>> lo

[3, 7, [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]]]

>>> [x for x in l if not x % 2]

[0, 2, 4, 6, 8, 10]

lisp comprehensions（列表解析）这个强大的特性的存在，可以使得Python做类似Lisp的这种不使用外部循环的遍历与Lisp一样的方便。（特别提及，列表解析是用从与Lisp同族的函数语言Haskell学过来的）

其实，这里我想多说几句，能够直接（即不使用循环）来对一个序列进行操作是非常方便的，也是更高级的抽象，这样才符合我们应该表达Do what，而不是去表达How to do，而用循环就是表达How to do的低层次了。事实上，即使在C++中，我们也是更喜欢高级抽象的，这也完全不会有性能损失，比如前面提到的for_each，transform，其实还有min_element,max_element，都是典型的例子，但是，对比Lisp和Python，还是显得功能比较弱小。

Lisp:

CL-USER> (defvar *capital-cities* '((NZ . Wellington)

(AU . Canberra)

(CA . Ottawa)))

*CAPITAL-CITIES*

CL-USER> (cdr (assoc 'CA *capital-cities*))

OTTAWA

CL-USER> (mapcar #'car *capital-cities*)

(NZ AU CA)

关联列表，类似C++中的map,Python中的字典,我并没有感觉有多么强大。。。。。

Python:

>>> capital_cities = { "NZ" : "Wellington", "AU" : "Canberra", "CA" : "Ottawa"}

>>> capital_cities["CA"]

'Ottawa'

>>> [ x for x in capital_cities]

['NZ', 'AU', 'CA']

在Python中，遍历一个dict默认是遍历key，所以用列表解析可以很简单的处理。虽然，Python在这些方面完全不输于Lisp,但是得提到，Python之所以不输给Lisp...是因为它从Haskell学到了列表解析.......

 

 

### 匿名列表（Lambda lists）:

CL-USER> (defun explode (string &optional (delimiter #/Space))

(let ((pos (position delimiter string)))

(if (null pos)

(list string)

(cons (subseq string 0 pos)

(explode (subseq string (1+ pos))

delimiter)))))

CL-USER> (explode "foo, bar, baz" #/,)

("foo" " bar" " baz")

CL-USER> (explode "foo, bar, baz")

("foo," "bar," "baz")

Lambda一般童鞋都不会太陌生，说的通俗点叫匿名函数，稍微现代点的语言都有，我以前还尝试过C++的[Boost::Lambda](<http://www.jtianling.com/archive/2009/05/22/4205134.aspx> "Boost::Lambda")

，但是这个特性不是指lambda，因为太普通了，看清楚了，是lambda list, 不过说的虽然玄乎，其实还是比较普通，相当于参数传递的时候是利用了list的特性，可以实现可选参数以及关键字参数而已（也叫Named arguments)，默认参数也许对于C还算神奇，可选参数对于C++都很普通了，关键字参数是BS主动放弃的C++特性之一，(见《C++设计与演化》在Python中完全支持。有点意思的是，上面的例子用了递归来实现string的遍历。。。。实在是太花哨了。。。。。而这个例子对于Python来说实在太普通了,Python甚至自带此函数实现的功能,我都懒得实现了。。。。。。

Python:

>>> import string

>>> "foo, bar, baz".split(",")

['foo', ' bar', ' baz']

>>> "foo, bar, baz".split()

['foo,', 'bar,', 'baz']

 

 

### 第一类值符号：（First-class symbols)

Lisp:

CL-USER> (defvar *foo* 5)

*FOO*

CL-USER> (symbol-value '*foo*)

5

听多了第一类值函数，倒是很少听说第一类值符号，在Lisp中，符号可以作为变量的名字，也可以就是作为一个占位符，说白了就有点像不当字符串处理的字符串。Python中应该没有类似概念。。。。。上文说多了Python没有类似的东西的话，惹得一些Python粉丝怒了，这里对我浅薄的Python知识表示抱歉，谨以此娱乐，作为了解Lisp特性的一种消遣，不要太当真，语言真的算不上啥信仰，平台也不是啥信仰，神马都是浮云，用着开心就好。

### 第一类值包：（First-class packages)

CL-USER> (in-package :foo)

#<Package "FOO">

FOO> (package-name *package*)

"FOO"

FOO> (intern "ARBITRARY"

(make-package :foo2 :use '(:cl)))

FOO2::ARBITRARY

NIL

没有看懂有什么太强的作用，注意上面的代码在使用:foo包后的反应....命令行提示符都变了,同时也明白了，以前的CL-USER其实就是代表CL-USER包，在Lisp中包也就是类似命名空间的作用，虽然说C++的命名空间真的也就是个空间，但是JAVA,Python，Lua中的包已经非常好用了，不仅带命名空间，而且带独立分割的实体。此条不懂，不知道是Lisp的古老特性在现在太流行了，所以变得已经没有什么好奇怪的了，还是说，我太火星了？高手请指教。

### 特别的变量:(Special variables)

Lisp:

FOO> (with-open-file (file-stream #p "somefile"

:direction :output)

(let ((*standard-output* file-stream))

(print "This prints to the file, not stdout."))

(print "And this prints to stdout, not the file."))

"And this prints to stdout, not the file."

"And this prints to stdout, not the file."

话说Lisp的变量是动态语法范围的，也就是说你可以将变量的范围动态的从全局变为局部，反之亦然，这个有点反常规。但是就例子中的代码看，就像是重定向功能，是将标准输出定向到某个文件上，这个功能Python也有。

Python:

>>> import sys

>>> stdoutTemp = sys.stdout

>>> sys.stdout = open("somefile", "w+")

>>> print("This prints to the file from Python, not stdout.")

>>> sys.stdout.close()

### 控制转移：（Control transfer)

翻译过来有些不好懂，大概的意思就是执行语句从一个地方跳到另一个地方，类似从汇编时代就有的goto语句。

Lisp:

CL-USER> (block early

(loop :for x :from 1 :to 5 :collect x :into xs

:finally (return-from early xs)))

(1 2 3 4 5)

CL-USER> (block early

(loop :repeat 5 :do

(loop :for x :from 1 :to 5 :collect x :into xs

:finally (return-from early xs))))

(1 2 3 4 5)

可能有些不好懂，其实此时的return-from就类似于goto,而block就像是C++的以：开头的标识。

Lisp:

CL-USER> (defun throw-range (a b)

(loop :for x :from a :to b :collect x :into xs

:finally (throw :early xs)))

THROW-RANGE

CL-USER> (catch :early

(loop :repeat 5 :do

(throw-range 1 10)))

(1 2 3 4 5 6 7 8 9 10)

Catch/throw语法的跳转，有点像现代语言的异常了，事实也是如此，看看例子中的cath吧，对:early throw出一个xs值，然后后来每次都能catch住，这个有点意思，虽然有点诡异。。。。。。

也许是因为现代的语言已经足够的强大了，即使是从命令式语言繁衍过来，（命令式语言的本质是模拟和简化机器语言）也慢慢的具有了越来越高级的抽象，并且也学习了很多函数语言的东西，所以，其实，语言的选择并没有那么重要，（[参考这里](<http://www.mengyaoren.com/tag/Lisp/> "参考这里")）根据具体的情况进行选择，什么熟悉，什么用的高兴就行。（当然，不是一个人高兴，是整个开发团队）

另外，这里还看到一本特别有意思的书《[Python for Lisp Programmers](<http://www.norvig.com/python-lisp.html> "Python for Lisp Programmers")》，其中较为详细的列举了Python和Lisp的相同及不同，可以看到Python其实与Lisp还是比较像的，其中也有一些关于现在语言的效率信息，可以作为参考，也算给看了上一篇文章并且对Lisp比Python快有疑义的人的一种回答。其实这个世界的人都很怪，用C/C++的人可以强调效率，因为我们高效嘛，用Python的人可以强调我们类伪码，开发效率高嘛，现在程序员的时间比机器的时间要贵重的多，于是C/C++的人又回答了，你用Python给我开发个操作系统试试，Python本身都是C语言编写的，类似的争吵不在少数。呵呵，但是，当效率和抽象都要更加强大的时候，那就更加有话语权了，就如Lisp的使用者宣称Lisp是世界上最好的语言一样.........其实~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

![](http://hi.csdn.net/attachment/201012/24/0_1293169272zZZX.gif)

最后，感觉后来的Lisp特性就没有前面的那么特异和突出了，有些平淡，再加上晚餐喝了几两二锅头，所以现在也不多写了，待续吧。。。。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>) **

 
