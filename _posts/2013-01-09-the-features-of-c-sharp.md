---
layout: post
title: "C#特性杂谈"
date: 2013-01-09
comments: true
categories: 编程
tags: C#
---
 
文中充满了各种C#与我会的语言的对比及吐槽, 希望介意者勿观... 当然, 鉴于太乱, 我怀疑有没有人能看完.  

<!-- more -->

**目录**:

* TOC
{:toc}


# 学习C#
C#也的确不是当年那种微软, Windows独占的语言了, [*mono*](http://www.mono-project.com/)项目已经将C#移植到了Mac和Linux上, 甚至还包括iOS和Android. 也就是说, 假如你愿意的话, 你可以使用C#通吃所有平台, 当然, 前提是你能接受巨贵的授权费用.   作为什么事情都喜欢自己搞一套的微软,(因为他都是垄断的) 在C#这件事情上一开始就很开放(因为有JAVA在前), 总算是做对了一件事情.  

# Hello World
Mono在创建一个名为test的console的工程后, 给了我一个Hello World的代码, 

~~~ csharp
using System;

namespace test
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.WriteLine ("Hello World!");
		}
	}
}
~~~

第一眼看去, 就知道C#中了JAVA的毒了, 用所谓完全面向对象的方式, 强迫你写一堆臃肿而无用的代码... 我至今也没有明白为什么Main函数最后会变成Main类, 也没有明白这有什么好处...  想起最近看的一篇文章[*Why Java Sucks and C# Rocks*](http://blog.zhaojie.me/2010/04/why-java-sucks-and-csharp-rocks-1-thoughts-and-goals.html), 说"自从C# 1.0诞生之日起，就只出现Java借鉴C#特性的情况", 以此来驳斥JAVA一派对C#抄袭的指责.  其实, 光是从Hello World都能看出来C#对JAVA的模仿, 他的言论也的确是避重就轻了, 因为, 连他也无法否认C#诞生前及诞生过程中发生的事情...  

值得一提的是, C#对传统的`printf`进行了改进, `{0}`形式的占位符不需要表明类型, 只按照数量和位置匹配.  

# 变量与表达式

1. C#没有像JAVA一样把无符号类型给去掉, 这点我觉得有些不可思议.  在C++新的使用倾向中都已经尽量的去使用有符号的类型了, 除非是进行位运算.  
2. 变量的声明方式和C/C++一致, 为`type name;`的形式.  
3. 有++自增操作符, 本来很正常的事情, 但是因为最近老是在用Python和Ruby, 看到这个竟然有些亲切.  
4. 枚举可以指定基本类型, 但是本身还是强类型的, 只能强制转换, 不能默认转换.  
5. 有类似C++ 11 `auto`的类型推理关键字`var`.  可以极大的简化我们的生活...  

## 动态类型
大家都知道类似C/C++, JAVA, C#这种对效率还稍微有些追求的语言都是静态类型语言, 并且靠编译期静态类型检查来排查错误, 而从C++以后, 各语言都以更加'真正的'强类型自豪.  而类似`auto`, `var`等自动类型推导的变量只不过是语法糖而已, 所以当我看到C#的确提供了动态类型`dynamic`, 我还是着实吃了一惊.  这也体现了C#的设计者们比C++, JAVA更加激进的一面.  很多年前, BS就说过(其实Mats也说过类似的), 语言不是一堆特性的堆积, 也不是说堆积的越多就越好.  因为, 很多时候JAVA, C#的拥护者们炫耀着JAVA, C#有着什么样的新特性的时候, 其实并不太感冒.  但是, 这一个, 够让人震撼的.  一个静态语言里面有动态类型会是什么效果? 不禁想让人尝试一番.   

~~~ csharp
public static dynamic Add(dynamic var1, dynamic var2)
{
	return var1 + var2;
}
~~~

类似上面的`Add`功能, 本来必须使用模版才能实现, `var`使用时, 因为是类型推导, 所以必须在初始化时才能使用, 不能用于函数参数, 而真正的动态类型`dynamic`就可以.  最近使用Python, Ruby比较多, 突然感觉C#有种Python, Ruby上身的感觉.  


## 值类型和引用类型
当我看到[*Why Java Sucks and C# Rocks（2）：基础类型与面向对象*](http://blog.zhaojie.me/2010/04/why-java-sucks-and-csharp-rocks-2-primitive-types-and-object-orientation.html)一文时, 我还以为C#真的已经是所谓的"完全面向对象"了.  所以当我看到[*C#入门经典*][]书中写到变量的类型还是分为引用类型和值类型时, 我相当意外.(我先看的那一系列文章, 再看的[*C#入门经典*][])  等我看到书中写到封箱和拆箱的时候, 就更加惊讶了... 都是一个对象, 为啥还要封箱和拆箱呢? 当然, 鉴于Objective-C连自动的封箱和拆箱都还没有, 我也不能说这就有多么落后.   
不过, 我用C++的时候就完全没听说过封箱和拆箱的概念, 容器的设计完全可以容纳基础数值, 为啥到了Objective-C, JAVA和C#里反而不行了呢? 因为C++没有统一的基类? 容器设计的时候就压根不是光考虑存储啥Object对象的.  这个倒是让我想起一句话, 你以为你解决了一个问题, 因为你比以前更加优美了, 但是同时带来了另外一个问题, 后来, 你们比较的是后一个问题谁更优美的解决了.  而这个问题本来并不存在...  
另外, 当你其实还分值类型和引用类型的时候, 你就已经输给Python, Ruby了, 何必还讨论谁的箱子更好看呢... 要把这个问题上升到理念层次, 我更加就没法认同了.  

## checked支持的受限强制转换
增加了checked, unchecked(默认)关键字来应付类型转换时的溢出问题.  比如下面的代码:  

~~~ csharp
short source = 257;
byte dest = (byte)source;
~~~

上面的代码在转换时会发生溢出, 这往往不是我们要的结果, 也往往因此出现莫名而难以调试的bug.  而类似下面的代码会在运行时会抛出`System.OverflowException: Number overflow.`异常.  这个方案很值得欣赏.  简单有效.  

# 流程控制

1. 保留了goto.
2. 有foreach循环, 这个是在C++时代我羡慕的语法糖, 不过现在也不稀奇了.  


# 数组

1. 从0开始计数.  越界访问抛异常`System.IndexOutOfRangeException`, 这似乎是C++以后语言的标配了.  
2. 本身带Length表示长度, 标配, 这个在意料之中了.  

# 函数

1. 看到了引用参数关键字`ref`, 也算结束了JAVA中痛苦的经历.  在JAVA中都是*pass by value*, 连一个简单的swap函数都不能直接实现.  还得通过一个构建一个数组来实现, 都不知道怎么想的.   
2. 新增输出参数关键字`out`, 与`ref`类似, 有以下区别:  
  1. 把为赋值的变量用作ref参数是非法的, 但是可以把未赋值的变量用作out参数.  
  2. out参数在函数中使用时, 必须看作时未赋值的.  

## 可选参数
实际上就等于C++里面的参数默认值, 在有默认值时, 在函数最后的参数为可选.  看书中说C#是在C#4后才支持, 为啥呢?

## 命名参数
命名参数在动态语言里面是很常见的, 并且是个容易理解又很使用的功能.  但是C++并没有支持, 看BS在[*C++语言的设计与演化*][]中讲到其实当时有过讨论, 只是因为在C++中有所谓的接口与实现分离, 而看以前的代码, 很多接口(头文件)使用的参数名和实现中用的参数名并不一样, 所以这个有用的特性并没有加入C++.  这也是为什么我前面说接口与实现分离实在是太不DRY的一个原因.  
当时BS给的例子是用Win32 API创建windows的代码(因为书在同事那里, 记忆不准确请指出), 因为需要的参数实在是太多了.  非常的不方便, 见MSDN:

~~~ cpp
HWND WINAPI CreateWindow(
		_In_opt_  LPCTSTR lpClassName,
		_In_opt_  LPCTSTR lpWindowName,
		_In_      DWORD dwStyle,
		_In_      int x,
		_In_      int y,
		_In_      int nWidth,
		_In_      int nHeight,
		_In_opt_  HWND hWndParent,
		_In_opt_  HMENU hMenu,
		_In_opt_  HINSTANCE hInstance,
		_In_opt_  LPVOID lpParam
		);
~~~

事实上, 在Win32 API里面, 你要完整的创建一个窗口, 还有类似注册窗口类等巨多参数的接口, 而其实在这个API里面, 每次调用时真正需要使用的又并不是所有的参数, 不用说有多不方便了.  可选参数(参数默认值), 只能在参数列表的最后使用, 让这种简化有的时候变成了一个排序游戏, 到底哪个参数才是最不常用的呢?  
BS给了在C++里面我们的一种解决方案, 这种方案也是我们在实际中使用的方案, 那就是用`struct`, 当`struct`成员变量都有默认值的时候, 我们就只需要给我们真正需要的那个变量赋值即可.  具体的情况就不多说了, 书上都有, 但是在有命名参数后这些都是浮云.  你只需要给你的确需要的参数赋值即可, 也不需要额外的创建类或结构.  比如上例, 有了命名参数后, 我假如只对窗口的宽度感兴趣, 那么如下调用即可:

~~~ csharp
public static int CreateWindow (
		int lpClassName = 0,
		int lpWindowName = 0,
		int dwStyle = 0,
		int x = 0,
		int y = 0,
		int nWidth = 0,
		int nHeight = 0,
		int hWndParent = 0,
		int hMenu = 0,
		int hInstance = 0,
		int lpParam = 0
		)
{
	return 0;
}


public static void Main (string[] args)
{
	CreateWindow(nWidth: 640, nHeight: 960);
}
~~~

还有比这更方便的事情吗? 顺面吐槽一句, Objective-C里面函数调用的方式简直就是为命名参数准备的, 当然竟然完全不支持命名参数, 甚至不支持参数默认值, 崩溃啊...  

## 委托(delegate)
这算是接触到的第一个较新的概念, 多写一点.  
delegate是Objective-C里面用的非常多的概念, 有很方便的一面, 但是是在类这个层次上的概念.  
C#的委托更加想是Objective-C的SEL/@selector和C++ 11的function, 也就是为了方便函数调用(特别是回调函数)和构建高阶函数而存在的.  这个也是函数不是第一类值(first class)的语言里面需要解决的问题.  函数指针有人说很方便, 但是那个语法实在太逆天了.  当然, 因为这个原因, 其实C#的委托也无法实现直接对`<, >, +, -`等操作符的控制, 而是需要用类似C++的方法提供辅助函数的方法来完成.  

C#的委托:

~~~ csharp
using System;

namespace test
{
	class MainClass
	{
		delegate int Actor (int leftParam, int rightParam);

		static int Call (Actor fun, int leftParam, int rightParam)
		{
			return fun(leftParam, rightParam);
		}

		static int Multiply (int leftParam, int rightParam)
		{
			return leftParam * rightParam;
		}

		static int Divide (int leftParam, int rightParam)
		{
			return leftParam / rightParam;
		}
		public static void Main (string[] args)
		{
			Console.WriteLine ("{0}", Call(new Actor(Multiply), 10, 10));
			Console.WriteLine ("{0}", Call(new Actor(Divide), 10, 10));
			Console.ReadKey();
		}
	}
}
~~~

## 匿名函数(Lambda)
有匿名函数的语言才算是现代语言啊... 我说这句话, C++, JAVA, Objective-C, C#无一中枪, 不管是加入的早晚(其实都是较晚), 上述语言都已经有了使用匿名函数的办法.  对于Python, Ruby来说, 匿名函数就更不是什么新鲜事物了.  比较有意思的是, 作为静态语言的新事物, 上述语言都独立的发展了一套自己的Lambda语法, 而且各有特色, 并且最终的目的似乎都是让你搞不明白.  C#的Lambda使用了`=>`来标记.  因为可以使用类型推导, 所以语法的简洁性上可以做到极致.  
参考上面委托的例子, 假如Multiply和Divide我们只是使用一次的话, 还按上面的形式定义就太麻烦了, 匿名函数可以简化代码.  

~~~ csharp
class MainClass
{
	delegate int Actor (int leftParam, int rightParam);

	static int Call (Actor fun, int leftParam, int rightParam)
	{
		return fun(leftParam, rightParam);
	}

	public static void Main (string[] args)
	{
		Console.WriteLine ("{0}", Call((leftParam, rightParam) => {
					return leftParam * rightParam;
					},
					10, 10));
		Console.WriteLine ("{0}", Call((leftParam, rightParam) => {
					return leftParam / rightParam;
					},
					10, 10));
		Console.ReadKey();
	}
}
~~~

可以看到代码显著的简化, 当然, 其实这里的例子还是太过简单和生造了, 匿名函数最大的应用在于利用闭包特性来作为回调函数.  此时简化的往往不仅仅是一个函数, 甚至是一套完整的类.  而且, 在多个类似回调同时在一个类中使用的时候, 每个匿名函数各自独立, 不会出现需要在类的回调函数中用switch/if-else区分的丑陋代码.  这个回忆回忆以前你用过的任何GUI系统的Button回调, 大概就能理解.  而最佳的例子, 我也常常提起我很感叹的是, 在最近的Objective-C中加入的匿名函数(在Objective-C中被称为Block)对Objective-C接口的巨大影响, 几乎是整体性的对原有`delegate`的替换.  这个替换过程不仅仅发生在社区, 连Apple官方也是如此.    

# 异常
传统的try, catch, finally模式.

# 面向对象部分
主要有价值的特性都在这一部分.  我觉得最大的改进就在于C#和JAVA都没有使用C++(还有Objective-C)里面看似优美的接口与实现分离的策略.  很多时候我们都在说DRY(Don't Repeat Yourself)是编程中排在第一的原则, 但是接口与实现分离, 即一个头文件用于声明, 一个实现文件用于实现的方式是彻头彻尾的*Repeat*.  这种方式就我了解是来自于C语言.  C++和Objective-C都在一定程度上有向C语言兼容的负担, 于是都这样做了.   稍微追求点人性化的语言其实都不是类似C/C++和Objective-C那种方式.  这个序列可以从JAVA, C#一直写到lua, python, ruby, lisp.  
这里有个值得探讨的话题, 因为我的确对编译原理什么的不是太了解, 不过大概知道, 实际的我们称的编译过程包括编译(生成.o文件)及链接(生成真正的可执行文件)两个过程, 而接口与实现分离的好处在于, 编译期可以不要求找到实现, 方便单独对每个文件的编译和将实现放在别的文件里面, 直到链接期才真正的匹配.  这也许是早期类C语言(需要直接最后生成机器码)这么设计的根源.  但是, 我还是得说, 那种设计并不好, 并且其实是有办法避免的.  只是可能需要离C远一点, 所以C++和Objective-C都没有用.  更有意思的是, 尽管似乎早就已经有`export`关键字了, C++还是只能将模版的声明和实现都放在头文件里面, 而我当年, 甚至还觉得模版这么做实在是太不规范了.  当然, 还有`inline`, 这也是个必须放在头文件里面的家伙.  

## 类

1. 默认每个类都继承于基类`System.Object`.  
2. 每个类分为`internal`(默认)和`public`, 需要一个类被外部访问的话, 需要定义为`public`.  
3. 用`abstract`关键字支持抽象类的概念, 比C++中奇怪的`=0`的语法要好的多.  抽象类本身不能生成实例, 需要被继承后使用.  
4. 新增了一个`sealed`关键字, 直接支持禁止继承的概念.  类似JAVA中的final类.  同时也可以对成员函数使用, 表示禁止在子类中被override.  
5. 除了传统的`public`, `protected`, `private`, 多了个`internal`的访问限制层级, 用于对成员的访问控制.  表示限制为程序集内的代码可以访问(即不是对外开放, 但是对内部的类开放)  
6. 成员内部变量用`readonly`替代了`const`.  表示常量.  
7. 继承后对基类方法的override必须用`override`关键字显式声明.  
8. 类成员也可以通过`extern`关键字表示由项目外部提供方法的实现代码.  书中说这是高级论题, 没有做详细的描述.  
9. 可通过`new`关键字显式的隐藏基类成员函数, 此时类似C++中覆盖非虚函数.  只不过, 在C#中, 甚至连基类的虚函数都可以通过`new`隐藏.  所谓的隐藏与覆盖(override)的区别在于, 隐藏在调用时没有多态性.  
10. 用`base`调用基类的变量或者函数, 用`this`调用本身的变量或者函数.   
11. 用`partial`关键字实现部分类定义, 即可将一个类拆散到多个文件中, 这件事情因为C++的接口与实现分离本来可以很自然的实现, 但是鬼才知道为啥我当年在一个项目中强烈建议把一个超过6k行的Player.cpp文件按逻辑拆开, 会遭到强烈的反对, 认为那样反而会更加麻烦, 虽然我原本的意思仅仅是几乎一行代码不动的拆到几个.cpp文件而已.  其实当一个类写到不得不需要拆开的时候, 这个类本身似乎也已经有些太臃肿了.  
12. `is`关键字用于判断一个对象的类是否是继承于一个类, 或者就等于这个类.
13. 虽然很多人批评过C++的运算符重载(比如JAVA中就没有), 但是C#似乎原封不动的照搬了.  这个各执一词, 我也不好说什么, 可以滥用, 也的确更方便.  当然, 我是喜欢有的.  
14. `as`关键字用于实现引用的类型转换, 在转换失败后, 不抛出异常(普通的强制转换就会), 而是返回null.  

### 构造函数初始化器
支持类似C++初始化列表的构造函数初始化器.  语法也类似.  
在新的C#中还支持直接类似C++ 11的统一初始化格式的对象初始化器.  语法如下:  

~~~ csharp
namespace test
{
	public class Point
	{
		public int x {get; set;}
		public int y {get; set;}
	}

	class MainClass
	{
		public static void Main (string[] args)
		{
			Point p = new Point { x = 1, y = 2 };
			Console.WriteLine("Point: x={0}, y={1}", p.x, p.y);
		}
	}
}
~~~

其中`Point p`就是通过上述对象初始化器完成的初始化.  这种方法没有提供一个带完善参数的构造函数使用起来方便, 但是在没有提供类似构造函数的时候.  可以不需要一行一行直接使用定义后的变量来初始化了.  另外, 对于集合来说, 也有类似的语法.  

### 访问器
通过get, set关键字来定义属性的访问器, 并且通过忽略其中一个来实现只读和只写.  并且提供了一种自动生成属性的功能, 代码类似`public int MyIntProp { get; set;}`, 在一行内定义一个属性, 并且不用再定义一个变量, 这个变量由编译器自动生成, 我们不知道它叫什么, 但是能通过访问器提供的方法来访问.    

### 可访问性传递原则
可访问性只能越来越严格, 不能越来越放松.  比如`internal`类可以继承`public`类, 反过来不行.  访问器的`get`, `set`单独设置的访问限制也类似, 只能比统一外部声明的要更加严格.

### 匿名类
大家都知道匿名函数好用, 匿名类呢? 有了总比没有好吧.  
配合`var`使用, 语法如下:

~~~ csharp
var p = new { x = 1, y = 2};
Console.WriteLine("Point: x={0}, y={1}", p.x, p.y);
~~~

注意, 我其实并没有定义一个Point类.  包含`x,y`成员变量的类由编译器自动生成.

### 扩展方法
在Python, Ruby里面都能很方便的给已存在的类添加方法, 实现打*猴子补丁*的功能, 类也被称为*开放类*.  当时静态语言一般不行, C#通过扩展方法实现类似的功能, 只不过语法非常之不优美, 同为静态语言, 建议anders去学习一下Objective-C里面的*类别*(category), 这种使用在Objective-C中非常的普遍, 因为的确非常的方便.  
首先看C#的语法:

~~~ csharp
public static class ExtensionString
{
	public static List<char> GetArray (
			this string str)
	{
		List<char> result = new List<char>();
		foreach (char c in str) {
			result.Add(c);
		}

		return result;
	}
}

class MainClass
{
	public static void Main (string[] args)
	{
		string s = "abcdefg";
		List<char> chars = s.GetArray ();

		foreach (char c in chars) {
			Console.Write(c);
		}
	}
}
~~~

上例中, 我给标准的`string`类增加了一个`GetArray`的接口, 返回一个`List<char>`类型的对象.  语法大概的描述如下:

1. 静态类
2. 静态函数
3. 函数的第一个参数为this修饰的, 你要增加方法的类型.

不知道大家怎么看, 我是觉得有些不太直观和自然.

## 接口
支持类似JAVA的接口.  关键字`interface`.  访问限定永远是public(不然还做接口干啥), 无实现代码, 不定义成员变量.  但是可以定义属性.  并且语法类似自动属性.  
继承时没有使用`extends`, `implement`等关键字, 要求实现继承的基类放在第一个位置(没有则可以忽略), 接口都放在后面即可.  类似下面的语法:

~~~ csharp
public class MyClass : MyBase, IMyInterface1, IMyInterface2
{
	// class members
}
~~~

也就是说, C#的继承体系基本上和JAVA一样, 只允许面向接口(规格)的多重继承, 不允许面向实现的多重继承.  这样好不好就见仁见智了(可参考[*多重继承不好的观点是错误的*](/articles/1998.html)一文), 不过基本可以肯定的是, 的确要比C++不受限制的多重继承要难以滥用.  

### 显示实现接口成员
又一个新东西, 在实现类明确的制定一个函数是实现接口的某个函数式, 只能通过接口的多态性来调用该函数, 不允许使用类本身的对象来调用.  这相当于强制接口调用.  


## 可删除对象
虽然C#有垃圾回收机制, 但是大家都知道, 自动的垃圾回收机制使得程序员对内存及资源的掌握变弱了, C#使用*可删除对象*来解决这个问题, 提供了一个IDisposable接口, 限定必须实现`Dispose()`接口(相当于手动调用的析构函数, 而不是垃圾回收机制自动调用的析构函数), 很有意思, 这个时候的用法就很类似C++了.

~~~ csharp
using System;

namespace test
{
	class MainClass
	{
		class NeedDispose : IDisposable {

			public NeedDispose() {
				Console.WriteLine("Constructing");
			}

			public void Dispose ()
			{
				Console.WriteLine("I'm Disposed");
			}
		}
		public static void Main (string[] args)
		{
			NeedDispose dispose = new NeedDispose();

			dispose.Dispose();
		}
	}
}
~~~
    
到这儿不算完, 都要手动调用的话, 那还不如C++那样出了对象存活范围就自动析构的对象, 于是多了个using的用法, 基本实现了C++使用对象的方式对资源的管理.  

~~~ csharp
// 语法一:
using (NeedDispose dispose = new NeedDispose())
{
}

// 语法二:
NeedDispose dispose = new NeedDispose();
using (dispose) 
{
}
~~~

不过有点比较奇怪的是, 两种语法形式上有区别, 但是本质上竟然一样, 语法一的定义在出了using的scope以后竟然还有效, 也就是说, 上面那两种语句同时在一个scope中出现时, 会出现dispose的重定义冲突, 这个设计很奇怪.  
    

# 结构
1. C#把结构设定为值类型, 即赋值时会直接产生值复制(类似整数等基本类型), 而不是产生新的引用.  这让结构有了新的用途.  
2. 结构内的成员函数默认是private的, 这点不像C++.  
3. `struct`不允许被继承.  

# 泛型
C#在2.0后才加入了泛型, 作为一门新语言, 不知道这是为啥.  这也是为啥前面提到不知道从哪冒出来的封箱拆箱问题的原因?  
泛型容器的好处就是它是强类型的, 对于强类型语言来说, 不提供强类型的容器, 那还叫强类型吗?(行吧, Objective-C躺着中枪了, 它至今还没有泛型)  

## 约束类型
这个类似C++中的曾经想要(但是没有)加入C++ 11的特性[*concept*](http://zh.wikipedia.org/wiki/%E6%A6%82%E5%BF%B5_(C%2B%2B))的更通用版本.  相当于给泛型类型一个约束限定, 只允许符合约束条件的模版类型.  这个特性的加入也体现了委员会和公司决定的语言之间的区别.  委员会保守, 公司激进, 而个人? 随意! 参考Python3...  

~~~ csharp
interface IMyInterface
{
	void DoSomeThing();
}

class MyClass : IMyInterface
{
	public void DoSomeThing() {

	}
}

class MyGenericClass<T> where T : IMyInterface
{

}

class MainClass
{
	public static void Main (string[] args)
	{
		// MyGenericClass<int> x = new MyGenericClass<int>();  // compile error
		MyGenericClass<IMyInterface> y = new MyGenericClass<IMyInterface>();
		MyGenericClass<MyClass> z = new MyGenericClass<MyClass>();
	}
}
~~~

语法上见上面的代码, 其中被注释掉的那一行会出现编译错误, 因为模版类型T被约束了.  只有`IMyInterface`及其子类才可以使用`MyGenericClass<T>`模板类.  


## 可空变量
即可以等于null的变.  用类似`int?`的形式来定义一个可空类型, 实际是`System.Nullable<int>`类型的缩写. 用`??`操作符来为可空类型提供默认值.  

# 事件
C#的事件本质上就是一种Gof的observer设计模式, 虽然语法上没有用subscribe这些传统概念.  并且因为C#委托的存在, 事件写起来还算是比较方便.  独创的用操作符`+=`用于表示事件的订阅, 绝对是属于操作符能自定义后被滥用的绝佳例子.  

# 最后
结论是, 假如不知道C#的那些高级特性, 那么把C#当作C++来用几乎没有任何问题, 而那些高级特性, 完全可以逐步的尝试.  而且JAVA和C#等语言的的确是进步了, 进步的方式就是把C++好的习惯用法, 编程规范和最佳实践, 直接变成语言特性(除了那所谓的完全面向对象).  一些改动虽然看起来很小, 甚至是语法糖, 但是的确是强制的(或者语言层面鼓励)写更好的代码.  
当然, 加入新特性时, 要比那个该死的委员会(虽然BS强调过C++不是委员会设计)效率要高太多了.  这也是我较为欣赏的一点, 也许有人可以说稳定正是C++的好处, 但是在快速变化的互联网时代, '不进则退'啊... 这个话也就只能安慰安慰C++程序员罢了, 市场的丢失是实实在在的.  作为一个从C++入门的程序员, 对此我常常倍感痛心.  
本文纯粹是[*C#入门经典*][]关于C#语言部分的阅读记录, 其中牵扯到的各种语言大部分都是凭借我的记忆, 语言过多了总难免记忆混乱, 其中如有错误的之处希望大家能不吝赐教.    

[*C程序设计语言*]: http://www.amazon.cn/gp/product/B0011425T8/ref=as_li_ss_tl?ie=UTF8&tag=jtianlinsblog-23&linkCode=as2&camp=536&creative=3132&creativeASIN=B0011425T8
[*C#入门经典*]: http://www.amazon.cn/gp/product/B004EPZ43A/ref=as_li_ss_tl?ie=UTF8&camp=536&creative=3132&creativeASIN=B004EPZ43A&linkCode=as2&tag=jtianlinsblog-23
[*JAVA编程思想*]: http://www.amazon.cn/gp/product/B0011F7WU4/ref=as_li_ss_tl?ie=UTF8&camp=536&creative=3132&creativeASIN=B0011F7WU4&linkCode=as2&tag=jtianlinsblog-23
[*C#程序设计语言*]: http://www.amazon.cn/gp/product/B005FOV7IK/ref=as_li_ss_tl?ie=UTF8&tag=jtianlinsblog-23&linkCode=as2&camp=536&creative=3132&creativeASIN=B005FOV7IK 
[*C++语言的设计与演化*]: http://www.amazon.cn/gp/product/B007JFSCPY/ref=as_li_ss_tl?ie=UTF8&camp=536&creative=3132&creativeASIN=B007JFSCPY&linkCode=as2&tag=jtianlinsblog-23
