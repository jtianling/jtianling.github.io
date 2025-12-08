---
layout: post
title: "JavaScript特性杂谈"
date: 2013-01-19
comments: true
categories: 编程
tags: JavaScript
---

最近语言学习有些疯狂, 从Ruby到Lisp, 然后是C#, 既然已经疯狂了, 就顺便学习一下JavaScript吧.  对JavaScript的印象一直不佳, 从骂脏话最多的使用者, 到使用者平反的世界上[最被误解的语言](http://javascript.crockford.com/javascript.html), 从所谓的让人抓狂的特性, 到世界上任何可以用JavaScript实现的东西, 最终都会被JavaScript实现, 并且, 这是最后一个实现.  出处太多, 不一一列举, 知者已知, 不知者也没有必要为了这些无聊的言论特意找出处了.  
其实也不是完全没有用过JavaScript, 以前在开发一个Unity项目的时候用过一下Unity里面的JavaScript, 只不过那个JavaScript我甚至都只能称之为UnityScript.  太多太多自己实现的特性, 而又有些不够完整.  现在, 认识一下真正的JavaScript吧.  

<!-- more -->

**目录**:

* TOC
{:toc}


# 环境
Mac OS X 10.8.2, node v0.8.16
需要解释一下, node跟浏览器里嵌入的JavaScript不一样, 不具有类似`confirm`和`prompt`等接口, 我用`console.log`来输出.  

# 概要
JavaScript本身就是设计为一个前端语言, 据说设计只用了10天, 有些缺陷, 但是的确足够简单.  虽然[*JavaScript The Definitive Guide*][]和大多数的语言书籍一样厚如砖头, 但是其实语言本身的介绍只有前面近200页, 这个厚度其实也就和[*R&D*](http://www.amazon.cn/C%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E8%AF%AD%E8%A8%80-%E5%85%8B%E5%B0%BC%E6%B1%89/dp/B0011425T8/ref=sr_1_1?ie=UTF8&qid=1358534290&sr=8-1)中描述的C语言差不多.  
也就是因为设计比较简单, JavaScript也被一些人认为不算是现代语言, 不具有现代语言的一些特性.  

# 语法细节
1. 可选的语句结束符`;`, 这个很少见.  不过一般的规范都推荐不要真的省.  
2. 支持自增`++`,自减符号`--`, 相对Ruby, Python来说, 这个要更习惯.  
3. switch和传统的C语言语法类似, 但是可以支持字符串的case.  
4. 支持NaN, null, undefined这三种表示类似无意义的量的方式, 有的时候这是混乱的根源.  也许还要再加上Infinity.  
5. 与大部分语言一样, JavaScript也分为原生类型和引用类型, 其中原生类型在拷贝, 参数传递和比较时时通过值的方式, 而引用类型都是通过引用的方式.  
6. 字符串为不可变类型, 任何的改变处理都是生成新字符串.  比较时为值比较.  字符串的值比较我个人认为时更加自然的做法, 比Java那种变态的方式要自然的多.  你几乎要反复的告诉每一个新来的程序员, 字符串的值比较在java中要使用`equals`函数.  
7. 动态类型语言, 变量通过`var`定义.  
8. 支持用label方式的break和continue, 用于在多层循环中直接对外层循环进行break和continue.  
9. 完整并且传统的try, catch, finally异常机制.  除了C++没有finally不够完整以外, 几乎所有现在语言的异常都是这么设计的了.  

# 字符串
JavaScript虽然说语法是类C的, 但是起点是Java, 所以尽管设计的面向对象系统虽然不是传统的模版式的, 但是JavaScript中的字符串都是对象.  

~~~ js
"hello, world".length
// out: 12
~~~

上述的代码在现在已经不稀奇了, 但是相对C++来说还是更先进的.(可见C++多落后了)

~~~ js
var str = "hello" + "," + "world!";
console.log(str);
// out: hello,world!
~~~

字符串支持`+`操作符作为字符串连接.  

JavaScript有个奇怪的地方是字符串和数字同时使用时:

~~~ js
console.log("3" + 4 + 5);
// out: 345
console.log(4 + 5 + "3");
// out: 93
~~~

也就是说, 相对一些语言(比如php)会自动的将字符串转为数字来说, JavaScript是倾向于将数字转为字符串的.  其实因为这种用法过于灵活, 即使是Ruby和Python这样以灵活著称的语言都是不允许这样的自动类型转换的.  
更诡异的还不只这些, 对于加法来说是如此, 对于乘法来说又是另外一回事:  

~~~ js
console.log("3" * 4);
// out: 12

console.log("3" * "4");
// out: 12
~~~

在乘法运算中, 因为JavaScript的字符串并没有像Ruby, Python一样对乘法的运算做出特殊解释(字符串的乘法表示重复), 所以默认会将字符串转为整数进行运算, 更诡异的是, 就算是两个字符串, 同样也会不报错的进行整数转换并且运算.  


# 函数
函数在JavaScript中是第一类值, 同时还支持闭包.  这是JavaScript构成对象的基础.  

~~~ js
function add(x, y) {
	return x + y;
}

var sub = function(x, y) {
	return x - y;
}

add(2, 3);
sub(5, 3);
// out: 5
// out: 2
~~~

有上述两种函数构造形式, 在调用时没有区别.  其中第一种方法和传统的函数定义方式一样, 而第二种实际上就是匿名函数的定义方式了.  只不过因为JavaScript中函数是第一类值, 所以可以很方便的赋值.  

## 匿名函数
匿名函数也被称为lambda, 是个很方便和有用的特性, 加上对闭包的支持, 以此衍生了很多特性.  也因此成就了JavaScript类函数语言的特性.  

~~~ js
var caller = function(fun, leftParam, rightParam) {
	fun(leftParam, rightParam);
}

caller(function(a, b) { console.log(a+b); }, 10, 20);
// out: 30
~~~

如上例所示, 匿名函数很重要的一个应用就是用于很方便的构建高阶函数.  也许上例有些太生造, 最常用的一个特性可能就是排序了, 因为排序的规则可能很多, 一般排序函数都允许再传入一个函数作为参数, 来指定排序的规则.  比如再JavaScript中, 普通的排序函数有些奇怪, 默认是按照字符串排序的.  见下例:  

~~~ js
a = [1, 3, 2, 10, 20];
console.log(a.sort());
// out: [ 1, 10, 2, 20, 3 ]
~~~

这在大部分时候估计都不是我们要的做法, 默认这样子我是第一次看见, 这就像字符串和整数想加最后变成字符串一样诡异, 也许JavaScript本身设计的时候是作为前端检验表单啥为主的语言, 所以对字符串这么偏爱吧.  幸运的是, `sort`函数还是可以传入一个函数作为排序规则的.  见下例:  

~~~ js
a = [1, 3, 2, 10, 20];
console.log( a.sort( function(a, b) { return a - b; } ) );
// out: [ 1, 2, 3, 10, 20 ]
~~~

因为匿名函数和递归在JavaScript中使用的都比一般语言要多, 所以提供了`arguments.callee`用于表示当前调用的函数, 以方便匿名函数的递归调用, 事实上, 相对一般用函数名的递归调用方式, 这种方式要更加符合DRY(Dont Repeat Yourself)原则, 因为当函数名更改的时候, 不用再更改递归调用的函数名了.  

~~~ js
var factorial = function(n) {
	if (n <= 1) {
		return 1;
	}
	else {
		return n * arguments.callee(n - 1);
	}
}

factorial(4);
// out: 24
~~~

更有意思的是, `arguments.callee`在JavaScript的[严格模式](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Functions_and_function_scope/Strict_mode)中是禁止的, 简单的说就是这种调用方法是官方不推荐使用的错误用法, 在将来甚至有可能废除, mozilla的解释是这种更DRY的用例本身很"weak", 但是却阻止了inline优化的进行, 因为这种方式是通过引用un-inlined函数实现的, 也只有函数un-inlined时, `arguments.callee`才可以引用到.  
事实上, 我觉得这简直是因噎废食的做法, 因为现在虽然是这样实现的, 但是完全可以通过更好的语法分析, 然后进行编译器的优化, 而不是因此废弃这样有用的语法.  这种用法绝对不像是官方说的那么"weak", 要知道, DRY几乎是软件设计领域头等重要的原则.  


## 闭包
一个闭包就是一个函数和被创建的函数中的范围对象的组合.  因为闭包的强大特性和带来的方便, 很多传统的语言都逐渐了加入了对其的支持, 很多时候, 甚至被视为一个语言是否还算是跟上时代的标志.  

~~~ js
function makeIncrementor(base) {
	var count = base;
	return function(num) {
		count += num;
		return count;
	}
}

obj1 = makeIncrementor(10);
obj2 = makeIncrementor(20);

obj1(1);
// out: 11
obj1(1);
// out: 12

obj2(2);
// out: 22
obj2(2);
// out: 24
~~~

上面的例子较好的展示了闭包的特性, 可以获得上层函数的参数和变量, 并且各自互相独立, 因为闭包对局部状态的保存, 很多时候能当作一个对象来使用.  

## 灵活的参数调用

~~~ js
function add(x, y) {
	return x + y;
}

add(2, 3, 4);
add();
add(2);

// out: 5
// out: NaN
// out: NaN
~~~

上述代码在调用时不会发生错误, 而是直接把后面的参数抛弃掉.  
甚至于, 后面的两个参数不够的函数调用, 会返回`NaN`, 也不会发生错误.  
本质上是因为一旦函数调用参数不够时, 后面的参数都会被置为`undefined`.  所以虽然JavaScript不支持默认参数, 但是可以模拟出来.  

~~~ js
function mul(x, y) {
	if (y === undefined) {
		return x * 10;
	}

	return x * y;
}

mul(10);
// out:  100
~~~

更灵活的语法是可以通过`arguments`变量来获取参数, 这样可以支持任意数量的函数参数.  

~~~ js
function add() {
		var sum = 0;
		for (var i = 0, j = arguments.length; i < j; i++) {
				sum += arguments[i];
		}
		return sum;
}
 
add(2, 3, 4, 5);
// out: 14
~~~

## 函数级作用域 
JavaScript只有函数级别的作用域, 函数外都是全局作用域, 没有块级作用域.  意味着类似for, while, if等块中定义的实际是全局变量.  这个设定在现代语言中是逆天的.  于是, 借助匿名函数, 人们想出了更加诡异的解决方案来模拟块级作用域.  

~~~ js
for (var i = 0; i < 10; ++i) {
	console.log(i);
}

console.log(i);   // 此时i仍然可用.  

(function() {
	for (var j = 0; j < 10; ++j) {
		console.log(j);
	}

 })();

console.log(j); // ReferenceError: j is not defined.
~~~

# 数组
JavaScript的数组比想象的要灵活, 支持用超出索引的引用来添加元素, 这个我只在ruby和php中见过, 连python都不支持.  当然, 这种设计虽然灵活, 但是容易出现很隐晦的错误, 最终是好是坏也难以评价.  

~~~ js
a = [0, 1, 2];
a[a.length] = 3;
a.push(4);

console.log(a);
// [ 0, 1, 2, 3, 4 ]
~~~

上述两种在数组后面添加元素的方法是等效的, 假如添加的元素不是数组的下一个元素(即跳跃式添加的话), 中间会用`undefined`填充.  

# 对象
JavaScript的对象本质上就是一个hash表的集合.  

~~~ js
var obj = new Object();
var obj2 = {};
~~~

有上述两种语法用于创建空对象, 其中第二种被称为'literal'语法, 也是常用的数据格式Json的基础.  

因为是hash表, 所以动态添加内容不在话下.  

~~~ js
var obj = new Object();
obj.name = "Simon";
obj.hello = function() {
	console.log("hello," + this.name);
}

obj.hello();
// out: hello,Simon.
~~~

有些不一样的是, 因为JavaScript中函数是第一类值, 所以可以很自然的在这个对象中添加函数, 完成完整的数据封装.  用`{}`来初始化上述对象的话, 会更加简单:

~~~ js
var obj = {
	name : "Simon",
	hello : function() {
		console.log("hello," + this.name);
	}
}
~~~

正因为其实对象就是一个关联数组, 所以同样可以用`for in`来遍历, 作用就像是python中的`dir`一样.  类似这种自审视的功能, 在传统静态语言是较为稀缺的, 在那种语言里这种功能叫做反射.  相配套的还有`typeof`操作符, `hasOwnProperty`, `propertyIsEnumerable`, `isPrototypeof`函数.  

~~~ js
for (var name in obj) {
	console.log(name);
}

// out: name
// out: hello
~~~

更进一步, 你甚至可以通过`obj["hello"]()`这种调用关联数组的方式来调用对象中的函数.  

# 面向对象
JavaScript算是第一个让大家知道这个世界上除了从C++一派来的class-based(模版式)的类定义方式, 还有类似self语言的prototype(原型)方式的流行语言.  虽然lua也是prototype方式, 但是毕竟只在游戏圈子里面流行.  

自定义对象:

~~~ js
function Rectangle(w, h) {
	this.width = w;
	this.height = h;
	this.area = function() { return this.width * this.height; }
}

var rect1 = new Rectangle(2, 4);
var rect2 = new Rectangle(8.5, 11);

console.log(rect1.are());
// out: 8
~~~

以上代码用类似构造函数的方式处创建了两个类型为`Rectangle`的对象.  注意和以前创建对象的区别, 以前我们都是从`Object`直接开始构建, 那样在构建多个对象时远不如这种构造函数方式方便.  用这种方法, 我们就能得到简单的类似class-based对象创建的方法.  只是创建的是构造函数, 不是一个class而已.  

不过, 上面代码并不完美, 最大的问题在于每个创建的对象都有一个自己的area函数, 而实际上, 所有的对象只需要指向一个共同的area函数即可, 这也是C++等class-based语言的做法.  为每个对象都创建一个函数, 无论是运行效率还是内存占用效率都不恰当.  JavaScript提供的解决方案就是prototype, 在函数对象中默认都会初始化一个`prototype`的变量, 这个变量中有的所有函数最终都会被这个函数新创建的对象拥有, 并且拥有的还都是引用, 见代码:

~~~ js
function Rectangle(w, h) {
	this.width = w;
	this.height = h;
}

Rectangle.prototype.area = function() {  return this.width * this.height; };

var rect1 = new Rectangle(2, 4);
console.log(rect1.are());
// out: 8
~~~

## 类属性(Class Properties)
在class-based语言中, 有的属性可以直接通过类名使用, 并且一个类的所有对象共享同一个对象.  在JavaScript因为所有的函数本身就是对象, 构造函数也不例外, 所以可以通过在构造函数上直接添加属性来实现这样的特性.  

~~~ js
Rectangle.UNIT = new Rectangle(1, 1);
~~~

其实, 类似的用法JavaScript本身就有, 比如`Number.MAX_VALUE`就是这样的类属性.  

## 类方法(Class Methods)
和类属性一样, 在构造函数上创建对象, 就能模拟出class-based语言中类方法.  这里不累述了.  

## 私有成员(Private Members)
在class-based语言中(Python例外), 一般都有对不同的成员设置不同访问权限的方法.  比如C++的prvate, public, protected, 在JavaScript, 通过上述方式创建的对象, 你可以看成都是默认为public的, 但是也的确有办法让外部访问不了内部的变量.  

### 简单的方法
此方法来自[*JavaScript The Definitive Guide*][], 代码如下:

~~~ js
function Rectangle(w, h) {
	this.getWidth = function() { return w; }
	this.getHeight = function() { return h; }
}

Rectangle.prototype.area = function() {
	return this.getWidth() * this.getHeight();
}

var rect = new Rectangle(2, 3);
console.log( rect.area() );
// out: 6
~~~

此时, 无论是在对象外还是在对象内部, 都只能通过访问函数(`getWidth`和`getHeight`)获得成员变量.  

### Crockford的办法
事实上, 上面的简单办法没有在根本上解决问题, 只是限定需要通过访问函数了而已, 外部还是能访问对象的内部变量.  Crckford据说是第一个发现了JavaScript创建真正私有变量的技术.  该技术主要在[*Private Members in JavaScript*](http://JavaScript.crockford.com/private.html)有描述.  

~~~ js
function Rectangle(w, h) {
	var width = w;
	var height = h;

	this.area = function() {
		return width * height;
	}
}

var rect = new Rectangle(2, 3);
console.log(rect.area());
~~~
  
该方法利用了JavaScript的闭包特性, 此时`width`和`height`在外部彻底无法访问.  只有函数内部才能访问.  同样的, 私有的函数也可以通过一样的方法实现, 但是, 这个方法我感觉还是不够完美, 因为很显然的原因, 此时需要访问私有变量的函数都只能在构造函数中直接定义, 不能再使用`prototype`变量了, 也就是会有前面提到的每个对象都会有个新函数的问题.    

## 模拟class-based的继承
相关内容见Douglas Crockford的[*Classical Inheritance in JavaScript*](http://JavaScript.crockford.com/inheritance.html).  我个人因为对这种奇怪的方式比较反感, 所以不太想去使用, 这里就不进行描述了.  需要提及的是, 假如真的需要class-based的继承的话, 在最新版的JavaScript 2.0规范(ECMAScript 5)中你能找到你想要的真正的类.  虽然相关标准还在进行当中, 可能还需要几年才能实际使用.  
语言的发展道路基本上是趋同的, 程序社区有较为公认的标准,  所以PHP也在新的版本中加入了完整的面向对象支持, 而C++在11标准里面加入了闭包.  而Java和C#在新版本中不仅加入了闭包, 还增加了模版.  
当JavaScript 2.0加入了class以后, 可能将来使用JavaScript就和C++等语言区别不大了.  可能会更像[UnityScript](/unityscript-programming-language.html).

## 基于原型的继承
这种继承方式和class-based的继承不一样, 直接使用了JavaScript的prototype特性, 在真正的class没有出来之前, 我个人对这样的方式好感更多.  主要可以参考的还是Douglas Crockford的文章, 见[*Prototypal Inheritance in JavaScript*](http://JavaScript.crockford.com/prototypal.html)  
简单的说就是子类讲自己的`prototype`变量设为想要继承的父类对象, 根据JavaScript的特性, 当一个函数找不到时, 会在`prototype`中寻找, 也就相当于子类没有重载时直接使用父类的函数.  当一个函数可以找到时, 会直接使用子类的函数, 这相当于子类重载了父类的相关函数.  
因为我还是不准备使用这个方法, 所以这里还是不加描述了.  

## 极简主义法
该方法我第一次是在[*阮一峰的网络日志*](http://www.ruanyifeng.com/blog)上看到的, 见[*Javascript定义类（class）的三种方法*](http://www.ruanyifeng.com/blog/2012/07/three_ways_to_define_a_JavaScript_class.html).  
就阮一峰描述, 该方法最先由荷兰人Gabor de Mooij在[*Object oriented programming in Javascript*](http://www.gabordemooij.com/articles/jsoop.html)中提出.  
该方法不使用`Object.create`和prototype特性, 本质上是新增一个自己约定的构造函数, 自己模拟了一个类似prototype的原型机制, 代码相对来说比较简单容易理解.  但是其实已经颠覆了本节前面提到的所有内容, 比如没有使用prototype和new.  

### 类的创建
上面的Rectange类, 可以改为下面的方式实现.  

~~~ js
var Rectangle = {
	 createNew: function(w, h) {
								var rect = {};
								rect.width = w;
								rect.height = h;
								rect.area = function() { return this.width * this.height; };
								return rect;
							}
 }
 
 var rect = Rectangle.createNew(2, 3);
 console.log(rect.area());
 ~~~

### 继承
需要注意的是, 此时的Rectangle是一个单纯的对象, 而不再如传统方式一样是一个函数(当然, 其实也是对象).  这也是一个更容易理解的优点.  然后, 我们可以简单的在子类的`createNew`函数中先创建出要继承的对象, 然后继续修改该对象直到达到我们的要求.  如下:  

~~~ js
var SubRectangle = {
	createNew: function(w, h) {
							 var rect = Rectangle.createNew(w, h);
							 rect.perimeter = function() { return this.width * 2 + this.height * 2; };
							 return rect;
						 }
}

var rect = SubRectangle.createNew(2, 3);
console.log(rect.area());
console.log(rect.perimeter());
~~~

### 私有成员及类的属性
我在新的SubRectangle子类中新增了perimeter函数, 用于计算周长, 可以看到使用的方法和传统的继承非常的像.  
根据这个思路和前面提到的传统方法, 私有变量和类的属性, 方法都是很简单的事情.  

~~~ js
var Rectangle = {
	 createNew: function(w, h) {
								var rect = {};
								var width = w;    // private
								var height = h;   // private
								rect.area = function() { return width * height; };
								return rect;
							}
 }
 Rectangle.UNIT = Rectangle.createNew(1, 1); // class propertie
 
 var rect = Rectangle.createNew(2, 3);
 console.log(rect.area());
 console.log(Rectangle.UNIT.area());
 ~~~

### 共用函数
这个方法总的来说非常简单直观和直接, 没有必要像Douglas Crockford的方法一样需要创建较多的辅助函数来实现.  但是, 其实还是像前面没有用到prototype的解决方法一样, 每个对象的成员函数都是独立的, 假如对效率和内存比较在意的话, 可以使用引用外部函数的方法来优化.  如下:  

~~~ js
var Rectangle = { 
	_area: function() { 
		return this.width * this.height; 
 }, 
	createNew: function(w, h) { 
							 var rect = {}; 
							 rect.width = w; 
							 rect.height = h; 
							 rect.area = Rectangle._area; 
							 return rect; 
						 } 
} 
~~~

这个方法能解决函数有多份的问题, 但是同时带来的问题就是无法访问私有成员, 同时会给外部的Rectangle增加一些接口, 虽然可以通过命名来告诉调用者, 这些接口是私有的.  具体用哪种方法, 就看是注重效率还是注重代码本身的设计了.  


# 小结
JavaScript本身设计的时候是一门简单的语言, 所以没有加入类似C++的对象系统, 而是选择了self的原型方式, 这样能极大的简化语言本身的设计.  但是, 随着JavaScript的应用原来越广泛, JavaScript本身的简单性及对模块性编写缺乏支持的问题愈显严重, 于是智慧的程序员们想出了很多办法, 上面关于面向对象一节就是各地的大牛们想出的办法, 其实这样各式各样的解决方案本身就反应了JavaScript语言特性的缺乏问题.  直到上面最后一种方案, 算是基本能用, 可是还是不够完美.  
很多JavaScript的使用者大力的鼓吹说JavaScript其实也能适应大规模编程的需求, 是一门优秀的语言, 我并不认同.  当钻入语法的细节之中, 尝试模拟语言本身不支持的东西成为常态以后, 这其实就说明了语言本身有问题.  就像boost库不停的在探索C++的极限一样, 那就是因为C++进化的太慢了.  起码, 我在学习C#的时候, 光是学习语法就好了, 不需要用C#去模拟什么.  
从社区上看, 一个良性的语言社区应该像Ruby和Python社区一样, 大部分人最关注的东西都是用语言去实现的东西(业务本身), 一小部分人关注的是库的编写, 几乎没有人去关系语法本身的东西.  而JavaScript和C++社区在这点上都有问题, 这也是因为语言本身的问题.  

# 参考
[*JavaScript The Definitive Guide*][] 5th Edition,(我看的是[影印版](http://www.amazon.cn/JavaScript%E6%9D%83%E5%A8%81%E6%8C%87%E5%8D%97-David-Flanagan/dp/B006RRAZGE/ref=sr_1_14?ie=UTF8&qid=1358533289&sr=8-14_), 上面链接是最新的第6版. David Flanagan著, OREILLY
[*JavaScript高级程序设计*(第2版)](http://www.amazon.cn/JavaScript%E9%AB%98%E7%BA%A7%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1-%E6%B3%BD%E5%8D%A1%E6%96%AF/dp/B007OQQVMY/ref=sr_1_1?ie=UTF8&qid=1358533289&sr=8-1),(上面链接的是最新的第3版) Nicholas C.Zakas著, 人民邮电出版社  
[*A re-introduction to JavaScript (JS Tutorial)*](https://developer.mozilla.org/cn/docs/A_re-introduction_to_JavaScript?redirect=no)
[*JavaScript The Definitive Guide*](https://item.jd.com/10974436.html)
