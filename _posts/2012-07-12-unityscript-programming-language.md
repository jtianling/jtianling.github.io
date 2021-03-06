---
layout: post
title: UnityScript程序设计语言
date: 2012-07-12
comments: true
categories: 编程
tags:
- Unity3D
- UnityScript
status: publish
published: true
---

UnityScript（即javaScript for Unity）的教程网上千千万, 中文的也不少, 但是讲Unity3D界面操作的多, 讲UnityScript这个语言的少, 同时对于UnityScript的描述部分, 也是入门的教程多, 对语言特性的描述少, 能够成系统的我就根本没有找到过.  连续的看了不少的Unity3D的文章, 书籍, 但是发现写代码的时候, 对UnityScript的细节掌握仍然不甚了了, 也就是对怎么写UnityScript效率更高, 更加符合语言设计的目的, 风格等事情并还没有清晰的认识.  这个对于习惯写脚本的人来说, 可能是常态, 对于习惯C++我来说, 简直难以忍受.

看到这样的名字, 学过编程的人都知道我是模仿了经典的C语言教材, 目的也是一样.  本文的目的不是再多写一个教程, 而是希望对UnityScript这个语言进行一个较为深入细节, 并且准确的描述.  也就是说, 相对于教程, 本文会更加像一个语言说明书.  同时, 更不用说的就是, 本文会甚少涉及Unity3D本身的界面操作, 仅仅关注于UnityScript这个语言, 不要希望通过本文学会Unity3D, 但是, 当你对Unity3D有了些基本的了解后, 希望写一个大型游戏时, 本文会对你该怎么写脚本, 怎么写对脚本, 怎么样写好脚本, 并且避免掉进语言的陷阱中有一些帮助.  
更进一步的说, 因为UnityScript完全是Unity3D控制的语言, 同时仅在Unity3D中可用, 所以对于UnityScript来说, 甚至于连哪些是属于语言本身的特性, 哪些属于库的扩展, 这些都分不清楚.  这比Objective C还混乱...  在Unity里面想要完全的区分开库和语言几乎不可能, 但是本文还是会尽量做这方面的尝试, 尽量将本文的主要关注点放在语言上, 而不是库上.  

<!-- more -->

**目录**:

* TOC
{:toc}


# 快速浏览
## 概述
一般的说法UnityScript是javascript for Unity, 事实上, 这个脚本语言更加接近JScript, 这个MS发挥了其一贯不尊重标准本性做的javascript方言.  甚至于, 对JScript的风格更加喜欢, 而抛弃了javascript本身的一些东西.  这些事情, MS因为兼容性问题都没有敢做.  当然, 考虑到Unity的开发者使用了Mono这个开源的.Net, 而不是诸如Java, Lua, Python等其他选择, 说明Unity开发者有很强烈的MS向, 这点也不让我感到意外.  

## Hello World
下面是经典Hello World程序的UnityScript代码

~~~ ts
#pragma strict

function Start () {
  print('Hello World\n');
}
~~~

在Unity的控制台上输出"Hello World”.  需要注意的是, 在Unity中创建该脚本后, 需要绑定到某个GameObject中成为一个Script的组建(compent)后才能运行.  
`function Start() { code here... }` 就是Unity里面用function关键字来定义新函数的方式.  这个没有太多好讲的.  
`#pragma strict` 可以更加严格的进行静态类型检查, 能够引导你更加好的写更加严谨和更好风格的代码, 这个在后面还会再次提到, 现在记得在开发的时候推荐都写上就行.  

## 类
比较需要说明的是, 一个UnityScript文件默认就是一个类, 并且继承自MonoBehavior, 类的名字就是文件名.  以上的代码（假设保存在名为HelloWorld.js文件中）与下面的代码意义一模一样：

~~~ ts
#pragma strict

class HelloWorld extends MonoBehaviour
{
  function Start () {
    print('Hello World\n');
  }
}
~~~

其中MonoBehaviour是Unity内置的一个类, 目前我们只需要知道其中Start函数和Update即可.  Start函数能保证在第一次Update被调用前调用, Update函数就是游戏每帧调用的刷新函数.  其中Update函数没有参数, 可以通过读取Time.deltaTime变量来获得两次Update之间流逝的时间.  
上面的代码同时展示了用class关键字定义新类, 用extends关键字继承的方式.  这个和C++,Java的语法很像, 都是class-based的, 这也是UnityScript不同于普通JavaScript, 而更像JScript的地方.  
这种类定义思维方式, 使得从C++,Java过来的人更加能够上手.  这可能是MS和Unity开发者都喜欢这种方式的原因.  

## 变量

在UnityScript中使用一个变量, 遵循先定义后使用的原则.  
如下代码首先定义了一个名为str的字符串, 然后输出str的值.  

~~~ ts
#pragma strict

function Start () {
  var hello : String = 'Hello';
  var world : String = 'World';
  print(hello + ' ' + world + '\n');
}
~~~

需要注意一下的是var hello : String这种语法, 表示静态的指定hello这个变量名(上例中还有个变量world也是一样)的类型为String（UnityScript内建的字符串）, 这种使用方式效率最高, 虽然在javascript中原来直接使用var hello = “Hello”;的方式也还可以使用, 但是不建议使用.  这个问题以后也还会提到.  
下面看一个较为完整的例子, 打印一个从华氏温度（Fahrenheit)到摄氏温度(Celsius)的转换表（来自于K&R page 19）

~~~ ts
#pragma strict

function Start () {
  /* defines */
  var lower : float = 0;
  var upper : float = 300;
  var step : float = 20;

  var fahr : float = lower; // define and assign
  var celsius : float;

  while (fahr <= upper) { // while loop
    celsius = (5.0f / 9.0f) * (fahr - 32.0f);
    print(fahr + " " + celsius + "\n");
    fahr = fahr + step;
  }
}
~~~

没有什么太多让人兴奋的内容, 展示了新的UnityScript类型float, 表示浮点数, 还有while循环.  还有, UnityScript支持C++所有的两种注释形式, 意义和使用方式完全一样, 这个就不多说了.  
本节是属于为了完整性加的引导, 下面开始上干货了～～～

# 数据类型
UnityScript中包含的数值数据类型（指int,float等数值）和普通的javascript差异巨大, 因为从效率和内存占用的双重考虑（游戏开发必须的）, 都比网页开发要严格的多, 所以UnityScript事实是沿用了.Net的数值类型定义方式, 并且这些基本类型（貌似）其实是使用了.Net的System库中的类型, 所以实际类型是System.XXX, UnityScript提供的仅仅是一个缩写别名而已.  
这种方式对数值的大小和范围进行了严格限定,并提供了丰富的数值数据类型（普通的javascript和很多脚本语言, 为了方便理解, 都将所有的数字归为统一的Number类型）, 具体的如下：

|类型名(type name)|类型(type)|位数(width)|范围（range)
|:---:|:---:|:---:|:---:|
|byte|Unsigned integer|8|0 ~ 255|
|sbyte|Signed integer|8|-128 ~ 127|
|short|Signed integer|16|-32,768 ~ 32,767|
|ushort|Unsigned integer|16|0 ~ 65535|
|int|Signed integer|32|-2,147,483,648 ~ 2,147,483,647|
|uint|Unsigned integer|32|0 ~ 4294967295|
|long|Signed integer|64|-922337203685477508 ~ 922337203685477507|
|ulong|Unsigned integer|64|0 ~ 18446744073709551615|
|float|Single-precision floating point type|32|-3.402823e38 ~ 3.402823e38|
|double|Double-precision floating point type|64|-1.79769313486232e308 ~ 1.79769313486232e308|
|char|A single Unicode character|16|Unicode Symbols|

以上数值的定义完全是因为机器的表示实现导致的, 所以虽然是.Net中的一套东西, 但是和C++的数值体系几乎完全一致, 只是把long作为单独的64位整数而已（JAVA早就这么做了）.  
特别需要注意的是, UnityScript的char类型默认就是16位的, 用于Unicode表示.  
知道数值类型是这样的体系后, 可以预想的是, 其行为和C++里面完全一样, 该有的溢出坑一个也不会少, 运算时, 各种类型转换复杂规则和各种转换带来的坑也少不了.  好处当然就是速度及你能选择最合适大小的数值类型, 在大规模数据保存的时候, 可以省很多内容和磁盘.  
需要顺便提到的一点是, 所有的数值类型, 其实自带一对内置的成员变量, MinValue和MaxValue, 用于表示此类型可以表达的最小, 最大值.  

先看数值溢出的坑:

~~~ ts
#pragma strict

function Start () {
  var bytenumber : byte = 255;

  var result : byte = bytenumber + 1;
  print("result=" + result);
}
~~~

上面的代码会输出0, 从C++过来的人就不用惊讶了, 也许仅了解Python, lua等脚本语言的人很难接受吧.  具体的原因在于数值位表示的局限, 当1111 1111（上例中255的机器码）再加一的时候, 已经没法再表达, 变成了0000 0000,即0.更多细节参考WIKI Integer_overflow.类似的问题在符号类型的时候会更加让人惊讶, 比如sbyte的值127再加1会等于-128.  

再看类型转换的问题, 一般而言, 像C++这样的语言, 很大程度上靠静态类型（编译期验错）来减少程序的bug, 这在用户自定义的类上面, 能起到很大的作用.  但是对于数值运算来说, 要是还是严格遵循类型定义, 那么就会相当麻烦, 想象一下一个两个整数想加, 或者1个整数加1个浮点数时还必须用强制转换才能进行的情况, 那样的表达式表达一个长的数学表达式简直就会是噩梦, （何况在UnityScript没有提供强制转换的方式）系统一般会提供一套各个数值类型之间运算时隐式转换(Implicit conversion)的规则, 常见的规则是表达更大范围的数值类型进行转换, 称为类型提升（type promotion), int + long, 转成long, 以减少数值溢出的情况.  
见下面的例子:

~~~ ts
#pragma strict

function Start () {
  var bytenumber : byte = 255;

  var result = bytenumber + 1;
  print("result=" + result);
}
~~~

我仅仅把result的类型由Unity自动识别, 程序就能正常输出256.  也许有些人会奇怪, 为什么不是0了？
通过加上
print("result type=" + result.GetType());
语句, 我们能看到最后result的类型：
result type=System.Int32
result实际是int类型（在.net中的System.Int32）, 理由呢？就是类型自动提升, 因为在bytenumber + 1的表达式中的整数常量1实际上就是int类型的, 在byte类型的变量bytenumber与其相加时, bytenumber自动提升到int型, 然后再进行运算, 所以没有溢出.  
到目前为止规则还好理解？看个不好理解的：

~~~ ts
#pragma strict

function Start () {
  var number : int = int.MaxValue;
  var unsignedNumber : uint = 1;

  var result = number + unsignedNumber;
  print("result=" + result);
  print("result type=" + result.GetType());
}
~~~

在无符号和有符号运算时会发生什么？
结果输出：

~~~
result=2147483648
result type=System.Int64
~~~

结果没有溢出, 也没有把result改为uint(其实也不会溢出）, 而是直接换成了long（在.Net中用System.Int64表示）快晕了吗？这就是想要随心所欲的使用自己数值类型的代价.  

我总结的转换倾向如下：

1.优先转为浮点类型
2.优先转为可表示数值范围大的类型

还有很多更值得琢磨的东西, 浮点和整数一起运算的情况, 仿照K&R, 我这里给出一个详细规则：（自己研究的, 目前不保证完全正确, 假如有问题请提出来）

1.在比int更小（sbyte,byte,short,ushort)的整数类型之间进行运算时, 都换成int类型进行运算.  （此时肯定不会发生溢出）
2.int类型与比int小的整数类型间发生的运算, 会将另外一个提升到int进行运算.  （此时有可能发生溢出, 从C语言继承过来的老规则, 原因可能还是因为32位效率最高）
3.有符号和无符号的int类型发生计算提升到long.  （此时肯定不会发生溢出）
4.在int和long,ulong之间发生的计算, 提升int到long.  （此时有可能发生溢出）
5.在long和ulong之间发生的计算, 将ulong转为long.  （此时有可能发生溢出）
6.在double参与的计算中,  将另一个数转为double.  
7.在float参与的计算（另一个数不是double）中, 将另一个数转为float.  即时另一个数是比float宽度更大的long也是如此.  

这里仅列出规则1的例子：

~~~ ts
#pragma strict

function Start () {

  var num1 : sbyte = 1;
  var num2 : byte = 1;
  var result = num1 + num2;

  print("result=" + result);
  print("result type=" + result.GetType());
}
~~~

该例输出

~~~
result=2
result type = System.Int32
~~~

两点说明：

1. 即使sbyte,byte相加时, short肯定能表示, 但是还是会提升到int（类似越级）, 原因可能是因为int类型的运算在原来的32位机器上效率是最高的.  
2. 类型提升更会不会实际发生溢出没有关系, 即使是1+1=2这样简单的运算, 还是会进行类型提升, 因为在运算前, 编译器没法判断是否会发生溢出.  

另外, 除了这些基本的数值类型, 还有以下类型：

|类型名(type name)|类型(type)|位数(width)|范围（range)|
|:---:|:---:|:---:|:---:|
|boolean|Logical Boolean type|8|true or false|
|String|A sequence of characters|Object|Base type of all other types|

其中, boolean是布尔型, 只能是是true和false,需要特别注意的是, 布尔类型比C++的要严格, 不能当作整形来计算.  
然后, UnityScript虽然用的是.Net的数值类型, 但是直接支持decimal这个精确浮点数类型, 但是允许通过System.Decimal的形式使用.  
Object类型是所有类型的基类, 类似JAVA中的情况, 这里不多说了, 在类的部分会再次提到.  
除此以外, UnityScript还提供了内置的数组及Array类型.  这些以后会详细讲到.  

## 字面常量（Literals）

在表达式中出现的整形常量, 默认为int.  
在表达式中出现的浮点型常量, 默认为float.  (这个需要特别注意）
但是可以像C++中那样, 直接通过后缀指定常量的类型, 但是可用的后缀比C++少很多, 能用的后缀见下例：（还有其他的可以告诉我）

~~~ ts
#pragma strict

function Start () {

  // integer
  var a = 10; // default is int
  var b = 10l; // long
  var c = 10e5; // float

  print("a's type=" + a.GetType());
  print("b's type=" + b.GetType());
  print("c's type=" + c.GetType());

  // float
  var x = 10.0; // default is float
  var y = 10.0f; // float
  var z = 10.0d; // double

  print("x's type=" + x.GetType());
  print("y's type=" + y.GetType());
  print("z's type=" + z.GetType());
}
~~~

注释就是其实际类型, 有些不一样的是浮点数默认为单精度浮点类型, 不是C++中的double, 好处是, 将来可以少些很多f后缀......

## 赋值时的隐式类型转换
除了数值计算时会发生隐式转换外, 赋值时, 左右类型不一样的情况, 也会发生隐式的类型转换, 比如下例中：

~~~ ts
#pragma strict

function Start () {
  var x : char = 97;
  var y : byte = 256;

  print('x=' + x);
  print('y=' + y);
}
~~~

97,256默认是int型, 但是将其赋值给char,byte型时, 进行了类型转换.  在超出左边类型表达上限的情况时, 会对右边的数值进行截断(truncation)操作.  比如上例中, y会等于0.
与计算时的隐形转换有尽量提升类型, 减少溢出的可能性相比, 不管右边的数值是什么类型, 是比等号左边的类型大, 还是小, 只要能进行有意义的转换, 都会进行转换, 即使是从大到小（此时发生截断）.  
转换的规则和C++很类似

1. 小数到整数直接去掉小数部分
2. 从大的整数到小的整数发生截断, 相当于直接忽略大整数中高位（小整数类型无法表示的部分）

讲到这里, 顺便说条好的编程实践规则：
一般的计算仅使用有符号类型, 仅在进行位运算时才使用无符号类型.  
衍生出两条规则：

1. 即使当1个变量从逻辑上来讲完全不可能是负, 也使用有符号类型
2. 即使当你发现有符号类型的上限快到了, 希望扩充其上限, 也不要使用将有符号类型改为无符号的方式, 这种方式仅将上限扩充了一倍而已, 要使用直接扩充到上1级类型的方式, 即从short=>int,int=>long.  

通过上面的类型转换规则可以看到, 这样的使用方式可以避免出现同类型有符号和无符号计算的情况, 可以避免很多类型的转换和提升, 对数值的溢出判断也更加直接一些.  

## 常数变量

UnityScript中使用了final关键字用于表示常量, 同时, 我们可以以全大写的惯例来表示常量.  有意思的是, 我以前从来没在文档中看到过Unity3D开发组对final的描述.  

其中总的来说, UnityScript对数据类型的处理和C++很相似, 有的地方甚至更加严格, 并且完全不支持任何C/C++,C#里面那种类型加括号方式的强制类型转换, 所以还算比较好理解.  就是表达方法上为了接近JavaScript（实际上和JScript一样）, 总是以var开头, 导致每个变量的定义都会多敲6次键盘, （为了好看, 我一般还需要加一些空格, 例子中都是）这个算是挺烦人的事情.  

# 表达式和操作符
 
JavaScript是面向表达式(Statement)的语言, 这个就像我们熟悉的绝大部分语言一样, 每个表达式用分号(;)结尾, 并且这个分号不能忽略.  （和JavaScript不一样）

## 去掉了undefined和Nah

UnityScript去掉了javascript中的和undefined, NaN, 只有null, 用于表示空对象.  见下例：

~~~ ts
#pragma strict

function Start () {
  var x;
  print(x);
}
~~~

这个例子, 在C++中根本就无法编译通过, 但是UnityScript可以, 同时, 不会像JavaScript一样输出undefined, 而是输出null.  

UnityScript也没有Nah类型, 直接在代码中存在的除0表达式会出现编译错误, 运行时出现除0操作, 会出现运行错误, 不会有Nah值出现的情况.  

## 数值转换

UnityScript拥有parseInt()和parseFloat()这两种javascript的数值转换函数, Number()实际等于double类型, 不再做此用途.  
而且parseInt函数实际是System.Int32.Parse (System.String s)函数, 不像javascript中那样’灵活’的容错, 不识别任何格式, 需要完全是整数才能识别, 意味着类似”1234blue”, ”0x10”这种格式会出现运行错误.  并且不带第二参数（javascript中用第二参数来表示进制）.  
parseFloat也换成了System.Single.Parse (System.String s)函数, 也没有javascript中那样的灵活性.  不支持任何格式.  

~~~ ts
#pragma strict

function Start () {
  var b = byte.Parse('256');
  print(b);
}
~~~

## 数值运算操作符
支持+, -, *, /, %, ++, --
数值运算操作符, 完全和C++及大多数语言里面的意义一模一样, 不介绍了.  

## 赋值操作符

除了=外, C++中有的两元赋值操作符(＊=等）, 都存在, 不介绍了.  

## 位操作符

`&, |, ~, ^,<<,>>`和C++里面一模一样, 不介绍了.  只要知道不支持JavaScript里面的无符号位移<<<,>>>就好了.  因此, 编程实践方面, 最好也是和C++一样, 进行位移操作的最好是无符号整数.  

## 比较操作符
`>,<,>=,<=,==,!=`
需要注意的是没有JavaScript的严格比较===, 因为类型本来就是相对确定的, 同时在==比较时, 不会进行JavaScript中那么多的类型转换.  
比如下例：

~~~ ts
#pragma strict

function Start () {

  if ( 42 == '42' ) {
    print("42 == '42'");
  }
  else {
    print("42 != '42'");
  }
}
~~~

输出`42 != '42'`

这样结果会让习惯javascript的人感到意外, 同时也会让习惯C++的感到意外, 42和’42’竟然能够比较....-_-!我前面说UnityScript的类型有时候比C++要严格, 注意, 也就是有时候.  不过, 好在UnityScript中数值和字符串发生比较时, 不会将字符串转换为整数后再比较, 而是判断类型不一样, 导致结果为假.  这比javascript已经和好多了.  
在不同类型发生比较时, 也会发生类型转换.  和计算是发生的事情类似, 但是因为类似的转换放到逻辑操作中较少会出现意外, 这里不详细描述了.  

## 原生类型及引用类型

一般的语言中都会分原生类型和引用类型, 比如在JAVA中, 你比较两个字符串类型的变量, 要是直接使用==操作符, 其实比较的是两个变量指向的是否是同一个字符串, 而不是判断两个字符串是否相等, 需要使用单独的Equal函数, 这个问题在C++比较char[]时也存在（因为C++的操作符重载的存在, 将std::string的==比较操作符重载了）
UnityScript使用的方式还是类似的, 前面提到的那些数值类型, 一如既往的是原生类型, 只是, 特别注意的是, String被认为是原生类型, 也就是说, 在两个String进行比较时, 比较的就是String的内容, 而不是引用地址.  见下面的代码：

~~~ ts
var str1 : String = 'abc';
var str2 : String = 'abc';

if (str1 == str2) {
	print('str1 == str2');
}
~~~

上面代码会输出`str1==str2`
而在比较其它的对象类型的时候, 比较就是引用地址了.  比如下例中：

~~~ ts
  var str1 : Array = ['a', 'b', 'c'];
  var str2 : Array = ['a', 'b', 'c'];

  if (str1 == str2) {
    print('str1 == str2');
  }
~~~

str1是不等于str2的....比较有意思的是, Array类型还提供了一个Equals函数, 其实比较的也是引用地址, 这个简直就是天坑.  
在查找那么到底两个Array应该怎么比较的时候, 发现了JScript里面推荐的方法, 那就是比较两个对象ToString以后的结果.  我只能说, 想出用这种办法来比较Array的人简直就是神.  

~~~ ts
#pragma strict

class C {

  var i : int;

  function ToString() {
    return i.ToString();
  }
}

function Start () {

  var obj : C = new C();
  obj.i = 1;
  var str1 : Array = [obj, 'b', 'c'];

  var obj2 : C = new C();
  obj2.i = 2;
  var str2 : Array = [obj2, 'b', 'c'];

  print(obj.ToString());
  if (str1.ToString() == str2.ToString()) {
    print('str1 == str2');
  }
  else {
    print('str1 != str2');
  }
}
~~~

这种比较在数组元素是简单类型时, 一定正确, 但是存储对象时, 要对对象也有正确的ToString实现, 不然结果可能会不正确.  

这里还有个有意思的地方, 在javascript的习惯里面, 对象会有个ToString函数, 而在C#的习惯里面, 对象会有个toString函数, 注意, 两个函数的首字母大小写不一样, 作为UnityScript, 在mono这个开源.Net平台上自创的javascript语言, 在使用.Net类的时候（比如上面的Array）两者都有！并且功能完全一样！这个实在是太丑陋了.  

这里总结一下, 上面提到的所有数值类型都是原生类型, 再加上String, 它们的比较都是通过比较值的方式, 同时, 在函数传参的时候, 也是传值（意味着有复制的发生）, 其他的, 包括原生数组, 其他的对象, 都是比较引用地址, 在传参数的时候也是传引用地址, 也就是说, 没有内容复制的发生, 同时, 对引用地址变量的任何更改都是更改了原对象, 见下例, 用一个原生数组作为示例：

~~~ ts
#pragma strict

function Start () {

  var array : int[] = [1, 1, 2];
  var array2 : int[] = new int[3];
  array2[0] = 0;
  array2[1] = 1;
  array2[2] = 2;

  if (ArrayUtility.ArrayEquals(array, array2)) {
    print('array == array2');
  }
  else {
    print('array != array2');
  }
}

#pragma strict

function changeStr( str : char[] ) : char[] {
  str[0] = 'b'[0];
  return str;
}

function Start () {

  var str : char[] = [ 'a'[0], 'b'[0], 'c'[0] ];
  changeStr(str);

  print( Array(str) );

}
~~~

最后输出的是b,b,c, 因为在changeStr里面对参数str的更改, 实际更改了外部的str, 这个C++及其他语言中见得多了, 不再过多描述.  

## 逻辑操作符

`&&, ||, !`
像C++一样, 也有逻辑截断效果, 当前面的操作可以确认结果时, 后面的操作不再进行.  
这里需要注意的是在UnityScript中, 什么样的值会是true,什么样的值会是false：
false: 空字符串, 0, null
true: 任何对象, 非空字符串, 非0数字

## 条件判断操作符

?:三目操作符UnityScript也支持, 和C++一样

## 操作符优先级

操作符计算顺序和C++也完全一样, 也没有理由不一样, 不介绍了.  

# 语句和控制结构
这是最没有什么好讲的一节.  需要理解的是在UnityScript中变量的scope和C++不一样.  
比如下面的代码:

~~~ ts
#pragma strict

function Start () {

  for (var i : int; i < 10; ++i) {
    print(i);
  }

  for(var m : int; m < 10; ++m) {
    print(i);   // still could read i
  }
}
~~~

你会发现在第二个循环里面还能够读取到第一个循环里面的变量i, 这种方式对于习惯了C++的人来说是个大坑, 也就是说UnityScript中的局部变量不像C++中习惯的那个样子, UnityScript没有块级作用域（这个奇怪的特性来自于标准的javascript, 不明白UnityScript为什么不改了）

其他的诸如if,else等条件控制, while,do-while,for等循环的代码和C/C++一样, 不介绍了.  
首先介绍一下for-in, for-in就是通常意义的foreach循环, 直接遍历整个容器.  

~~~ ts
#pragma strict

function Start () {

  var charArray : char[] = new char[10];
  for (var i : int; i < 10; ++i) {
    charArray[i] = 97 + i;
  }

  for(var value in charArray) {
    print(value);
  }
}
~~~

直接遍历整个容器算是语法糖, 但是从抽象上来说的确比通常的for层次更高, 也更难用错.  

## switch多条件控制

UnityScript的switch本质上和C/C++中的一样, 但是有些加强, 那就是case不再是仅可使用数值, 甚至可以是变量, 这个的确很强大, 很多复杂情况的if-else都可以被替代了.  

~~~ ts
#pragma strict

function Start () {

  var num : float = 10.0;
  var numEqual : int = 10;

  switch (num) {
    case (num < 10.0):
      print('num < 10.0');
      break;
    case (num > 10.0):
      print('num > 10.0');
      break;
    case numEqual:
      print('num == numEqual');
      break;
    default:
      break;
  }
}
~~~
上例中会输出`num == numEqual`, 这么复杂的条件判断, 在C/C++中是不允许的.  

# 函数,Lambda和闭包
函数里面值得研究的东西就多了, 也是UnityScript中最有意思的部分, 没有之一.  这也是UnityScript作为从javascript过来的最大特点之一, javascript可是号称函数式编程的语言.  
作为最大的特点, 函数本身就是一个Function类型的对象, 不是什么特殊的种类, 也称函数为第一类值.  此时函数可以像普通变量一样的操作, 甚至从外部看不知道这是函数, 并且还能随时调用.  
首先看函数的定义, 前面讲过一下, 下面这个函数定义带参数和返回值：

~~~ ts
function sum(num1 : float, num2 : float) : float {
	return num1 + num2;
}
~~~

并且, 和下面的定义方式没有区别：
~~~ ts
var sumFun : Function = function(num1 : float, num2 : float) : float {
	return num1 + num2;
};
~~~

也看赋值和传递：
`var sumFun2 : Function = sumFun;`
调用sumFun2和调用sum,sumFun是一样的效果.  

## 函数作为参数

函数是第一类值, 也就是说可以想变量一样使用, 那么, 参数也可以是函数, 见下面的例子：

~~~ ts
#pragma strict

function Start () {

  var sum = function(num1 : float, num2 : float) : float {
    return num1 + num2;
  };

  var call : Function = function( fun : Function, num1 : float, num2 : float, num3 : float ) : float {
    return fun(fun(num1, num2), num3);
  };

  print(call(sum, 1.0, 2.0, 3.0));
}
~~~

在C++11中, Function, Bind库是最让我高兴的扩展, 这在UnityScript中是语言本身的特性.  

函数作为返回值

当函数作为第一类值的时候, 函数甚至可以作为返回值返回, 也就是说, 可以实现一个返回值是函数的函数.  见下例：

~~~ ts
#pragma strict

function Start () {

  var multipleFun : Function = function() {
    return function(num1 : float, num2 : float) : float {
      return num1 * num2;
    };
  };

  var call : Function = function( fun : Function, num1 : float, num2 : float, num3 : float ) : float {
    return fun(fun(num1, num2), num3);
  };

  print(call(multipleFun(), 1.0, 2.0, 3.0));
}
~~~

multipleFun返回一个函数, 再作为call函数的参数传进call函数.  
另外, 虽然这些特点和javascript的函数特点一样, 但是在UnityScript中函数不再有默认的内部属性, 很大原因是因为UnityScript不再依靠函数来完成对象的设计, 所以更改了这部分的设计, 让函数更加的纯粹, 没有了arguments属性, 稍微有些遗憾.  

## 函数的重载

javascript没有函数的重载, 这个很好理解, 因为函数的参数都是var, 没有重载的太大必要, 但是UnityScript中可以直接指定参数的类型, 那么重载就有一定必要了, 事实上, UnityScript实现了函数的重载：

~~~ ts
#pragma strict

function sum( num1 : int, num2 : int) : int {
  return num1 + num2 + 1;
}

function sum( num1 : float, num2 : float) : float {
  return num1 + num2 + 2;
}

function Start () {
  print(sum(1, 1)); // call sum( num1 : int, num2 : int) : int
  print(sum(1.0, 1.0)); // call sum( num1 : float, num2 : float) : float
  print(sum(1.0, 1)); // call sum( num1 : float, num2 : float) : float/
}
~~~

如上代码, 会输出3, 4, 4, 正确的匹配了合适的函数, 并且在出现二义性的时候, 进行了类型提升, 第三个sum的调用也调用了浮点数的那个.  这种类型提升多恰当其实也说不上, 在C++中这是会出现二义性编译错误的 , 但是总得来说还是较为符合预期, 毕竟和计算时的提升方式类似.  稍微提及一点, 在UnityScript中, 函数的参数个数要求是严格的（编译期检查）, 不像javascript中那种参数个数不够也能调用.  

## Lamda

UnityScript支持匿名函数, 即我们常说的Lamda函数, 简单的说就是没有名字的函数, 说来简单, 其实作用挺强大的.  
在本节前面的例子中

~~~ ts
function sum(num1 : float, num2 : float) : float {
    return num1 + num2;
}

var sumFun : Function = function(num1 : float, num2 : float) : float {
  return num1 + num2;
};
~~~

两种定义函数的方式其实是有些区别的, 前一种是在当前作用域中定义了一个名为sum的函数, 这在程序编译时就确定了, 在代码执行之前就已经加载到作用域了, 无论你在这个作用域的哪个地方都能直接调用, 而后一种定义方式, 实际上是先定义了一个匿名的函数, 然后将匿名的函数赋给变量sumFun, 只在这一行代码在运行时被执行后才有效.  
在前面例子里面的call函数, 也可以用Lambda函数调用:

~~~ ts
function Start () {

  var call : Function = function( fun : Function, num1 : float, num2 : float, num3 : float ) : float {
    return fun(fun(num1, num2), num3);
  };

  print(call(function(num1 : float, num2 : float) { return num1 + num2; }, 1.0, 2.0, 3.0));
}
~~~

对于只使用一次的函数来说, 这样做更加便捷, 并且还少费一个变量～～也许对于这个例子, 这么调用没有太大必要, 但是在大规模的使用函数作为参数的情况下, 这样的简化就会带来很大的意义, 当然, 那就看你的编码思维是函数式的还是JAVA, C++那样面向对象的方式了, 要是一直习惯使用C++, 可能都不会有把函数作为参数的抽象思维, 那样, 这样的代码你写几W行代码都不会碰到.  相对来说, 因为UnityScript中去掉了很多与函数编程相关的便捷方法（类似map,filter等）, 使得用函数编程的方式成本偏高, 所以按照C++的思维来写UnityScript, 完全是靠谱的.  

这里有个UnityScript很大的特点需要注意, 那就是不支持函数内的函数定义, 但是支持函数定义表达式.  也就是说

~~~ ts
function fun1() {

  //function fun2() {
  //}  // not support

  var fun2 : Function = function() {
  }; // OK

  return fun2;
}
~~~

上例中, 被注释掉的第一个fun2的定义方式不被UnityScript支持, 而第二种方式是支持的, 虽然我们现在已经知道了, 这两种方式其实没有啥区别, 但是, UnityScript就是有这么诡异的情况......

## 闭包

虽然在Python和Lua中都接触过闭包, 大概明白什么回事, 但是要从概念到细节的描述, 我感觉自己还是不太明白, 于是查了下网络, 发现我最喜欢的两个博客, 阮一峰和酷壳上正好有两篇文章, 阮一峰的文章作为入门, 概念讲解的清楚, 酷壳上那篇, 细节描述的到位准确, 关于闭包的概念, 我发现我只需要发两个链接就够了.  

# 类
UnityScript中类的使用方式没有用javascript中较为别扭的prototype方式, (说prototype别扭会有人来喷我吗？-_-!）而是选择了JScript中MS加入的class-base方式, 这种方式前面讲过一些, 事实上和C++的比较像.  下面看稍微复杂些, 带继承的情况.  

~~~ ts
#pragma strict

class Base
{
  public var x : int;
  protected var y : int;
  private var z : int;

  function Base() {
    x = 1;
    y = 2;
    z = 3;
  }

  function PrintToOverride() {
    Debug.Log('x=' + x + ',y=' + y + ',z=' + z);
  }

  final function PrintCantOverride() {
    Debug.Log('x=' + x + ',y=' + y + ',z=' + z);
  }
}

class Derived extends Base
{
  //public var x : int;
  //protected var y : int;
  private var z : int;

  function Derived() {
    x = 4;
    y = 5;
    z = 6;
  }

  function PrintToOverride() {
    super.PrintToOverride();
    Debug.Log('x=' + this.x + ',y=' + this.y + ',z=' + this.z);
  }
}

function Start () {
  var base : Base = new Derived();
  base.PrintToOverride();
  base.PrintCantOverride();
}
~~~

能想到的情况上面的例子中都展示了, 包括和C++一样的构造函数, 丰富的访问控制（public,protected,private), 和Java一样的默认全虚函数, final定义不可override的非虚函数, 用super关键字调用父类的对象.  其中PrintToOverride函数就是在Derived类中重载了Base类中的同名函数, 并且调用了基类的同名函数.  
有个小细节需要注意, z这个变量在Base中是private的变量, 因为在Derived中完全不可见, 在Derived类中还可以重复定义, 但是public的x和protected的y是不能在Derived中重新定义的, 这个比C++要严格, 在C++中是可以通过this指针来进行区别的, 当然, 就算真的可以, 比如z, 也完全不推荐大家去定义重名变量.  可以看看上例中输出的结果有没有超过你的预期, 要是超过了的话, 更加应该把不定义重名变量作为规则来遵守.  

这部分UnityScript的设计基本来自于JScript的class-base object创建方式.  类似面向对象的一般思维.  在第一节就讲过一些基本的东西了, 这里不做重复的叙述.  

# 数组和字符串
## 原生数组

Unity中有两种数组, 一种是原生数组(Buildin array）, 类似C/C++中原生数组的使用方式.  
见下例：

~~~ ts
function Start () {

  var str : char[] = new char[10];

  for (var index = 0; index < str.length; ++index) {
    str[index] = 97 + index;
  }

  for (var printIndex = 0; printIndex < str.length; ++printIndex) {
    print(str[printIndex]);
  }
}
~~~

会依次输出a,b,c....
需要注意的是, 即使是内置数值, 其实也还带名为length的成员变量, 表示数组的长度.  （这是C/C++ coder多年的梦想）
因为原生数组是类型安全的, 并且效率很高, 内存占用很少, 在需要不是频繁增删的容器时, 优先考虑的应该是UnityScript的原生数组, 比如游戏的配置读取后的结构.  

## 多维数组

这个是一个奇怪的特性, 用逗号来分割维度, 没有使用C/C++中[ ][ ][ ]的方式.  

~~~ ts
function Start () {
  var multidim : double[,,] = new double[5,4,3]; // three dimension
  multidim[0, 0, 0] = 1;
}
~~~

## Array类

在UnityScript可以直接使用.Net中的所有容器, 还有Array这个javascript的数组.  
Array算是UnityScript中最乱的类了, 一方面为了照顾javascript的习惯, 函数需要以小写开头, 一方面还要照顾自己的习惯, 函数又要用大写开头, 于是乎, UnityScript两者都保留了, 因为我对javascript没有什么感情, 推荐碰到类似的情况一律使用大写开头的函数.  
因为Array来自于javascript, 不是一个类型安全的容器, 不推荐使用.  推荐使用.Net的ArrayList等容器替代.  当你确定需要一个类型不确定的容器时, 才使用Array.  Unity的Script Reference对Array有足够的描述, 这里就不多介绍了.  

# 字符串

在UnityScript中, 用char（见上表）来表示字符, 并且默认支持Unicode.  
在C/C++中, 常用char[]来表示字符串.  并且字面常量无论是用双引号”, 还是用单引号’, 表示的都是字符串, 而不像C++中用”表示字符串, 用’表示字符.  实在在需要字符的时候, 这里有个hack,那就是使用’a’[0]的形式.......这么扭曲的方法, 来自Unity的WIKI, 见下面的代码：
var str : char[] = [ 'a'[0], 'b'[0], 'c'[0] ];

上面讲到做, char默认保存的就是Unicode的值, 可以完美支持中文.  见下例：

~~~ ts
#pragma strict

function Start () {

  var str : char[] = [ '中'[0], '国'[0] ];
  var value0 : int = str[0];
  var value1 : int = str[1];

  print( Array(str) );

  print( str[0] + " " + str[1] );
  print( value0 + " " + value1 );
}
~~~

倒是MonoDevelop对中文支持的不是很好, 不能输入中文, 上面的代码在其他地方编辑后, 在Unity中运行正常.  

# 参考：
1. Unity Script Reference
2. Unity Game Development Essentials
3. Head First into Unity with UnityScript
4. UnityScript versus JavaScript
5. The C Programming Language
