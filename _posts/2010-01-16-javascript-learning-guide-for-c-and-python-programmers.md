---
layout: post
title: C和Python程序员的JavaScript学习指南（译）
categories:
- "翻译"
tags:
- C++
- JavaScript
- Python
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '25'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文从C和Python程序员视角，剖析了JavaScript中诸多反直觉的“陷阱”，如类型强制转换、全局变量等，旨在帮助学习者避开这些令人困惑的坑。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

**[讨论新闻组及文件](<http://groups.google.com/group/jiutianfile/>)**

原文来自：《[JavaScript for C & Python programmers](<http://www.wooji-juice.com/blog/javascript-article.html> "JavaScript for C & Python programmers")》，经过作者Canis允许后翻译，即使转载请附带此链接。

前言：很少干翻译的事情，累，辛苦，不能发挥，典型的费力不讨好，最近无聊，想在网页上显示动画（因为CSDN贴图不是不让贴了嘛），Java applet虽然已经搞定了，但是总感觉这不是Java的世界，所以想大概学习一下JavaScript后再做决定，(-_-!从命名上看其实像是换成了 Java的脚本-_-!）网上类似JAVA for C++ programmers的文章很多，但是js类似的文章却很少，一方面可能的确java更加流行，另一方面可能一般的C/C++程序员与js的领域差的太远，没有此需求，本文也不是为C++程序员写的，是为c和python程序员写的。

翻译完后，就个人感觉，本文甚至不能算是一个较好的指南，大概可以看做一个C,Python程序员学习 JavaScript时的抱怨，全文有太多作者的抱怨，针对JavaScript不寻常的语法提出了很多看法，用本文来全面的了解Javascript是不太可能的，但是了解一下作为一个C,Python程序员，学习JavaScript应该注意哪些奇特的地方，也不是没有好处。

（以下我的注释都添加**开头，没有添加的为作者原注释）

以下是译文：

## C和Python程序员的JavaScript学习指南

作者：Canis

* 第一次发表： 2006年三月
* 更新: 2008年七月 (添加了到 JSLint的链接)
* 最后一次更新: 2009四月 (更好的删除Array items的方式)

本文是对JavaScript的简单介绍。网上有很多类似的资料，但是大部分都是针对非程序员读者的，教导一些javascript的简单代码。那样也没有什么，因为很多从来不编程的人发现他们的网页需要一些js脚本的时候会需要这些。

这篇文章提供了一些有关JavaScript的更深层次的信息。我假设你完全不懂javascript但是也假设你已经是一个称职的程序员，是"C-like"语言的程序员更好，并且懂一点python将很有帮助（**说的不就是我吗？-_-!）

我将谈到任何我认为javascript不好的地方。（**原文用到object model 指的的是对象模型吗？作者是想说面向对象吗？我都没有在文章中看到）

### JS不是JAVA

首先，一个常见的误解需要澄清，javascript从来与JAVA没有任何关系。JS以前甚至不叫js（另外，java以前也不叫java，但是那就是[另外一个故事了](<http://www.engin.umd.umich.edu/CIS/course.des/cis400/java/java.html> "另外一个故事了")）。（** 链接中关于JAVA历史的第一句话就是：Java programming Language evolved from a language named Oak）这个Java的前缀完全是出于市场的因素，可能是因为（**这句没有看懂）这对他们互相的支持有意义，就像将他们的腿绑在一起，共同在市场上进退。警告：本文包含JS特性这样的主题，假如你发现这对你来说太难了，你最好早点走吧。

JS是一个动态语言，有着C语言一族的基本语法，但是却有很先进，看起来很像Python的数据类型。（**原文用Pythonesque，表示非常符 合Python设计思想和Python好的使用习惯，更通常我们用Pythonic一词)，事实上，从很多方面来讲，它的很多行为也是这样的。

事实上，JS是有令人惊讶的强大的，表达能力强的语言，似乎应该能非常优雅的完成很多工作。

然而，事实并非如此。

它带来的是一个无尽的痛苦。陷阱潜伏在黑暗之中，等待时机，像野兽一样潜伏着，他们会吃掉你。（**作者此处提供了一个我无法打开的网页链接：http://www.scarygoround.com/shop-tshirts.php#bears）

JS是一个彻头彻尾的混账语言，但是你却无法摆脱，同样的，浏览器的API也是同样的让人困惑。

通常来说，JS似乎遵循的是最大惊讶原则。（**-_-！）

**网页的嵌入**

JS 可以单独运行(比如 [Rhino](<http://www.mozilla.org/rhino/>) )，(**Rhino是 JavaScript for Java，一个将js编译为java字节码运行的开源项目，我常认为犀牛书《JavaScript The Definitive Guilde》封面画了个雄壮的犀牛就是这个原因)或者嵌入到特定的hosts中，（比如[Mac OS X Widgets](<http://www.apple.com/macosx/features/dashboard/>) ），但是，最通常的做法是将其嵌入到网页中，通过如下的形式：

#### html:

```html
<script language='javascript'> // source code goes here </script>
```

或者：

#### html:

```html
<script language='javascript' src='/path/to/source.js' />
```

**在 <script>的tag的scope内，普通的HTML语法不再有效。--<就是<，不是tag开始符，并且&就是&，不是指示一个字符的开始。（全文需要的HTML知识仅限于此）**

### **基础语法**

大部分的基本语法直接来自于C，所有下面的语法行为就像在C/C++/等语言(**等等中包括java,python-_-!）一样。

注释： /* C */ 风格 和 // C++ 风格

条件： if /then /else

选择： switch /case /break default

while循环： while /do /break /continue

for循环： for /break /continue

函数看起来与C类似，但是又一些不同。我们马上就会讲到。for的循环有一些我们需要关心的额外语法。类在js中是与其他大部分语言完全不同的。

在语句结尾的分号： 你可以使用它们，但是他们是普遍是可选的，根据晦涩难解的的ECMAScript标准（呵呵--"标准化"版本的JS）的规则，js会自动的插入分号。它大概意思是，在缩进是比较清楚，没有二意性时，你不需要分号。

### 变量和声明

在JS中，你从来不声明某个变量的类型。变量本身，事实上，没有类型 -- 一个变量不是像C一样对应着某个内存地址，而是一个对象命名的引用，就像Python一样。也就像在Python中一样，所引用的对象有一个类型，它会决定它本身可以做什么及你可以用它做什么。

但是，不像Python，你确实需要声明一个局部变量的存在，只是不声明它是什么类型。这不是显而易见的，因为如果你没有声明一个变量，JS将自动声明它。

#### 全局声明

是的，JS采用了Python相反的决定（Python中除非明确的声明一个变量是一个全局变量，那么就是局部变量），JS中除非你明确的声明，不然都假设变量是全局的。

这样会有一些非常令人惊讶和恼火的影响，特别是，如果你忘了声明一个变量，你的代码可能会很好地工作，直到它彻底的与其他代码搅在一起，因为其他代码使用了同样名字的全局变量。

或者你写了一些递归代码，接着可怕的嵌入一个意外的无限循环中 -- 可能会没有反应，甚至崩溃。你的浏览器不是足够智能化去跳出无限循环，唉。。。。。。

是的，JS设计的时候就是要让某些事情花掉你95%的时间（还不是全部），当你忘记这些事情的时候，它可能静静的失败，也有可能崩溃，还有可能让整个执行环境没有反应，使得你除了反复试验外没有办法去调试。感谢你，JS语言的设计者们！ 感谢你，浏览器的实现者们！

无论如何，你使用var关键字声明变量，比如：var msg = "hello" -- 如果你不指定值，变量默认是未定义的。我建议你总是通过var声明你的变量，不管是不是真的需要，这样会更加安全。假如任何人知道一个JS的Lint工具（**lint是一个很著名的C语言错误分析程序），让我知道并且我会在此添加一个链接。

Update: Martin Clausen指出存在 [JSLint](<http://jslint.com/>) 。你需要仔细的调整你的options，另一方面，JSLint在其首页有一个强大的警告信息系统。

### 函数

JS的函数与C有些不同。他有两种形式，命名的及匿名的。命名函数与C中很像，但是，当然，没有任何参数或返回值的类型声明。在C语言中放置返回值的地方，使用function关键字。

```javascript
function treeWalk(branch, visitor){
    visitor(branch)
    var i // not going to let you forget! you'll thank me later! 
    for (i in branch.children) {
        treeWalk(branch.children[i], visitor)
    }
}
```

在这里，visitor是一个传递进来的函数，我们将在以后展示怎么样做到。branch是一个用户定义的对象，我们假设它有一个名叫children的array。

此外，我相信你已经注意到这个不寻常的for结构。这是一个迭代器版本。(**事实上是典型的for each语法规则)

迭代器语法：

for (<variable> in <variable of container type>) <statements>

迭代器遍历容器中的每一项，然而，这是另一个经典的JS令人烦恼的情况，它仅返回每个成员的索引。假如容器是一个有10个元素的array，它可能返回整数0到9（看看下面关于arrays的内容）。假如容器是一个hash-map，它将返回每个key。

这就需要一个额外的，多余的哈希查找过程，因为似乎没有（就我目前所找到的）对应Python的for(key,value) in container: statements循环的语法。

匿名函数是非常明显的，你仅仅忽略名字。

function(param1, param2 ...) {

statements

}

就其本身而言，这是毫无价值的，上面的就是表达一下语法。你可以将整个定义放在任何地方，包括变量赋值（**其实意味着JS中函数是第一类值(first class))，下面的例子是相同的定义一个名为mul的函数。

var mul = function(a,b) { return a*b }

一个不同的例子，用了前面定义的的treeWalk函数：(**即将匿名函数直接作为函数参数传递）

treeWalk(rootNode, function(item) { logDebug(item) } )

## 类型，转换，比较

显然，你有数字类型（double float -- JS事实上没有整数） ，字符串类型，并且他们就像你预期的那样使用。然而，JS有一个偶然（或者说令人惊讶的）的在各种类型中间转换的倾向。例如，

rhino 示例:

```javascript
js> 2 + 2
4

js> "2" + 2
22

js> "2" * 2
4
```

"+" 被用于数学的加法和字符串连接。

当至少有一个字符串参数时，它将其他类型全部转换为字符串然后连接，但是其他数学操作却是转换字符串到数字。哈哈！结合操作符的优先级将带来更多的额外奖励的乐趣和混乱。

rhino 示例:

```javascript
js> "2" + 2 + 2
222

js> 2 + "2" + 2
222

js> 2 + 2 + "2"
42

js> "2" + 2 * 2
24

js> "2" * 2 + 2
6

js> ("2" + 2) * 2
44
```

## 深深的，慢慢的呼吸...  
这一切总会过去的。。。。。。。（**真不愧是最大惊讶。。。。）

Oh yeah，并且JS的比较操作符也是诡异的，==转换类型，===不会

rhino 示例:

```javascript
js> 2 == 2
true

js> 2 == "2"
true

js> 2 === 2
true

js> 2 === "2"
false
```

并且，注意字符串比较中给你的意外，然而，这还不算太坏，假如每个操作数都是数字，转换将会向着数字的方向。

rhino 示例:

```javascript
js> 4 > 2
true

js> 4 > 22
false

js> 4 > "22"
false

js> "4" > "22"
true
```

噢!并且JS将会很高兴的无声无息的将无效的数字转换为NaN，并且会将这种行为贯穿在整个代码中。。。。

rhino 示例:

```javascript
js> "2" * 2
4

js> "two" * 2
NaN

js> x = "two" * 2
NaN

js> 4 * x
NaN
```

记住，深深的，慢慢的呼吸......

## Arrays 和 Hashmaps

JS内建Arrays and hashmaps 。假如你仅仅需要声明一个含有一些初始化数据的array和hashmap，JS有一个可以直接从Python中拷贝数据过来的语法 -- 中括号用于list，大括号用于hashmap。

rhino 示例:

```javascript
js> myArray = [1, 2, 3, 17, 23, 42, 69]
1,2,3,17,23,42,69

js> myHash = {"key": "value", "key2": "value2"}
[object Object]
```

两者都是用方括号索引：

rhino 示例:（接上面）

```javascript
js> myArray[3]
17

js> myHash["key2"]
value2
```

你可以混合和配对使用任何集合数据类型，比如每个值都是一个array或者hashmap。对于key来说，似乎转换所有的数据类型到字符串形式并且这样使用--所以JS中的语句myHash[fred] = value似乎像python中的myDict[repr(fred)] = value一样。

你可以用同一种语法删除两种类型的元素，delete语句：

rhino 示例:（接上面）

```javascript
js> myHash["key2"]
value2

js> delete myArray[3]
true

js> delete myHash["key2"]
true
```

(delete似乎总是返回true，是的，甚至你的索引超出范围，是的，甚至这里没有一个对应的key。我不知道为什么)

(**rhino 示例:（接上面）

```javascript
js> myHash["key2"]
js> delete myHash["key2"]
true
```

)

然而，你应该注意，如果你从一个array中移出了一个元素，它会留下一个空白(undefined)，并且所有的其他元素仍然有同样的索引。

rhino 示例:

```javascript
js> myArray
1,2,3,,23,42,69

js> print(myArray)
1,2,3,,23,42,69

js> print(myArray[3])
undefined

js> print(myArray[4])
23
```

（那个两个连续的逗号不是一个印刷错误，undefined的值转换到字符串类型时没有任何输出，但是这里仍然有一个在array为其保留的'槽'）

现在，当您在一个数组迭代， 它会自动跳过这样的空插槽：

rhino 示例:

```javascript
js> for (i in myArray) print(i)
 1
 2
 3
 23
 42
 69
```

(**在我这里的 rhino 运行效果与原作者的有所区别，就像作者前面说的那样，返回的是key

```javascript
js> for( i in  myArray) print(i)
0
1
2
4
5
6
js> for( i in  myArray) print(myArray[i])
1
2
3
23
42
69
```

真正神奇的是此时跳过undefined值的方式是直接忽略了，连个空行都没有

）

虽然如此，对于许多人物来说，有一个undefined的值在array中可能是非常痛苦的事情，所以你会发现，写一个函数用于"压缩"一个array，或者返回一个指定索引忽略的副本是有用的，给你一个删除+压缩的函数。（代价是一次不必要的复制操作）

```javascript
function deleteArrayItem(source, index){
    var result = new Array()
    for (i in source) 
        if (i != index) 
            result.push(source[i])
    return result
}
```

**Update: Reddit 用户 [davidsickmiller](<http://www.reddit.com/r/programming/comments/8c6hj/introduction_to_javascript_for_c_python/c08uf1p>) 提到一个我忽略的array方法，当我在2006年写下这个的时候。Array::splice(**切片函数）从数组中移出一个范围，返回移出的元素，并且，将原来的array打包。（**此处原作者用packing，其实就是去除undefined的元素）**

rhino 示例：

```javascript
js> myArray = [1, 2, 3, 17, 23, 42, 69]
1,2,3,17,23,42,69

js> myArray.splice(3,1)
17

js> myArray
1,2,3,23,42,69
```

(**这样的形式可以看到，事实上不想要undefined的数据时根本就不应该使用delete操作，事实上，对于已经有了undefined数据时，splice也是很有用的，可以直接移出undefined的数据)

Arrays会自动的扩展，当你插入一个超出索引范围的值的时候。并且，假如这个范围不是连续的，那么所有中间的"槽"都是undefined的。

Array有一个length成员变量，比如myArray.length，但是它不告诉你到底有多少元素存在，它告诉你有多少的"槽"，用另外的话说，它总是返回你插入元素的最高的索引+1,假如你想要知道实际的元素数量，好的，你就不得不遍历array并且自己计数。

好了，我要走了，留下你自生自灭。。。。。。。。。。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
