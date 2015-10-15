---
layout: post
title: UnityScript风格指南(UnityScript Style Guide)
date: 2012-05-09
comments: true
categories: 编程
tags:
- Unity3D
- UnityScript
---

公司最近要开新的Unity3d项目了，Google虽然有JavaScript Style Guide,但是UnityScript和JavaScript的区别实在大到了几乎不是同一种语言的地步，这个只能自己动手了。好在起码还能参考一下Google的style guide。

<!-- more -->
<!-- toc-begin -->
**目录**:

* [任何脚本都必须以下列方式开始](#任何脚本都必须以下列方式开始)
* [强类型定义变量](#强类型定义变量)
* [分号结尾](#分号结尾)
* [枚举类型](#枚举类型)
* [for-in 循环](#for-in-循环)
* [多行字符串常量](#多行字符串常量)
* [Array和Hashtable的常量](#array和hashtable的常量)
* [命名](#命名)
 * [变量和函数(Properties and methods)](#变量和函数-properties-and-methods)
 * [可选的函数参数](#可选的函数参数)
 * [存取器函数（Accessor functions)](#存取器函数（accessor-functions)
 * [局部变量](#局部变量)
* [字符串](#字符串)
* [缩进](#缩进)
* [参考文档：](#参考文档：)

<!-- toc-end -->

# 任何脚本都必须以下列方式开始

~~~
#pragma strict
~~~

### 理由

`pragma strict`将强制进行更加严格的类型检查，并且还能因此在编译期产生更加有用的错误信息，鼓励更好的编程风格。

# 强类型定义变量

总是以 var value : type的形式定义变量，即在定义变量时指定变量的类型。

### 理由

以强类型方式定义变量比让Unity去自动识别变量类型效率要高的多，同时能够在编译期发现一些对变量的错误使用，虽然让语言的灵活性受到了一些影响。

# 分号结尾

语句总是以分号结尾，这在JavaScript中是语法风格，在UnityScript中是必须，没有分号会导致编译错误。

# 枚举类型

在需要使用表示不同类型的时候，尽量使用枚举类型。

### 理由

枚举类型是一个效率更高，并且因为强类型检查，比起字符串来说，更加难以出错。

示例

~~~ ts
enum WeaponType { pistol, rifle, launcher };
var type : WeaponType = WeaponType.pistol;
function Start () {
  Debug.Log(type);
}
~~~

# for-in 循环

只用在遍历object，map，hash的key。不要用于遍历Array。

### 理由

for-in循环在被用于遍历Array的元素时，常常会被错误的使用，因为for-in循环不是从0到length - 1，而是遍历所有目前已经存在的所有元素。
以下是一些错误的使用的情况：

~~~ ts
function printArray(arr) {
  for (var key in arr) {
    print(arr[key]);
  }
}

printArray([0,1,2,3]); // This works.

var a = new Array(10);
printArray(a); // This is wrong.

a = document.getElementsByTagName('*');
printArray(a); // This is wrong.

a = [0,1,2,3];
a.buhu = 'wine';
printArray(a); // This is wrong again.

a = new Array;
a[3] = 3;
printArray(a); // This is wrong again.
~~~

以下是正确的使用方式：

~~~ ts
function printArray(arr) {
  var l = arr.length;
  for (var i = 0; i < l; i++) {
    print(arr[i]);
  }
}
~~~

# 多行字符串常量

不要使用

~~~ ts
var myString = 'A rather long string of English text, an error message \
                actually that just keeps going and going -- an error \
                message to make the Energizer bunny blush (right through \
                those Schwarzenegger shades)! Where was I? Oh yes, \
                you
~~~


这种形式，而是使用以下形式：

~~~ ts
var myString = 'A rather long string of English text, an error message ' +
               'actually that just keeps going and going -- an error ' +
               'message to make the Energizer bunny blush (right through ' +
               'those Schwarzenegger shades)! Where was I? Oh yes, ' +
               'you
~~~

### 理由

前一种形式每一行开始的空白字符不能在编译时安全的删除，可能导致很诡异的结果。

# Array和Hashtable的常量

使用Array和Hashtable的常量来初始化，而不是它们的构造函数。

不要使用以下形式：

~~~ ts
// Length is 3.
var a1 = new Array(x1, x2, x3);

// Length is 2.
var a2 = new Array(x1, x2);

// If x1 is a number and it is a natural number the length will be x1.
// If x1 is a number but not a natural number this will throw an exception.
// Otherwise the array will have one element with x1 as its value.
var a3 = new Array(x1);

// Length is 0.
var a4 = new Array();
~~~

而是使用：

~~~ ts
var a = [x1, x2, x3];
var a2 = [x1, x2];
var a3 = [x1];
var a4 = [];
~~~

不要使用：

~~~ ts
var person : Hashtable = new Hashtable();
person['name'] = 'JTianLing';
person['age'] = '28';
~~~

而是使用：

~~~ ts
var person2 : Hashtable = { 'name' : 'JTianLing',
                            'age' : 28
                          };
~~~

# 命名

通常情况下，用functionNamesLikeThis, variableNamesLikeThis, ClassNamesLikeThis, EnumNamesLikeThis, methodNamesLikeThis, SYMBOLIC_CONSTANTS_LIKE_THIS. 文件名 因为在UnityScript中，文件名就是定义的类的名字，所以要求文件名完全按照类的名字来命名。

## 变量和函数(Properties and methods)

私有的属性，变量和方法应该用一个下划线结尾(trailing underscore）。

## 可选的函数参数

可选的函数参数应该以 opt_ 开头。

## 存取器函数（Accessor functions)

Getter和Setter函数一般情况下是不需要的，假如使用的话，应该命名为getFoo()，setFoo(value),对于boolean变量来说，isFoo()也是可以接受的，并且经常更加自然。

## 局部变量

在UnityScript中，没有块局部变量，也就是说{}中的变量实际不是局部变量，所以即使在for循环中，也不要使用i,j,k,m,n等简单的变量名来做循环索引，而是使用有意义的名字。 具体如下：

~~~ ts
for (var i : int = 0; i < 10; ++i) {
  Debug.Log('inter i=' + i);
}
Debug.Log('outer i=' + i);
~~~

上面的代码会正常运行，并且输出outer i=10。除了将上面代码中的i命名成更有意义，更加不容易重复的变量外，还可以理由UnityScript函数内部真实存在局部变量的情况来获得局部变量，语法形式为 (function(){ code....}(); 如下：

~~~ ts
(function(){
  for (var j : int = 0; j < 10; ++j) {
    Debug.Log('inter j=' + j);
  }
})();
Debug.Log('outer j=' + j);
~~~

在上面的例子中，outer j输出的那一行会发生编译错误，因为在函数外面，j已经不可访问。

# 字符串

尽量使用单引号' ，而不是双引号"

# 缩进

按照原来Google C++ Style Guide的风格。

如有改变，会直接更新此文, 不另行通知。

# 参考文档：
1. [*Google JavaScript Style Guide*](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml)-- 最主要的参考文档，本文中的很多条款直接就是从此文档翻译过来。
2. [*Head First into Unity with UnityScript*](http://wiki.unity3d.com/index.php?title=Head_First_into_Unity_with_UnityScript)
3. [*UnityScript versus JavaScript*](http://wiki.unity3d.com/index.php?title=UnityScript_versus_JavaScript)
[*UnityScript versus JavaScript*](http://wiki.unity3d.com/index.php?title=UnityScript_versus_JavaScript)
