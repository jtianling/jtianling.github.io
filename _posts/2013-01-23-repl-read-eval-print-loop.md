---
layout: post
title: "常见语言的REPL(Read-eval-print-loop)"
date: 2013-01-23
comments: true
categories: 编程
tags: REPL
---
 
在一般的新脚本语言中, 有REPL是常态, 因为REPL非常的方便, 谁用谁知道.  最近学的语言已经多到几乎超过我的脑容量了, 所以我更加经常的用REPL来验证一些语法, 所以找到了一些传统不存在REPL语言的REPL环境, 在这里记录和分享一下:

<!-- more -->

**目录**:

* TOC
{:toc}


# 原生就有REPL的语言
## Common Lisp
一般的Common Lisp实现都有REPL, 比如我在Mac下用的[*Clozure CL*](http://clozure.com/index.html), 该实现甚至还有Mac App Store的[版本](https://itunes.apple.com/us/app/clozure-cl/id489900618?mt=12).  

## Ruby
官方实现就带REPL, 只是命令是irb, 意思是Interactive Ruby Shell, 而不是ruby.  `exit()`, `quit()`命令都可以退出.  
同时, 也有个网页版[*tryruby*](http://tryruby.org/)(同时也是个ruby的在线教学), 不过似乎被墙.  

## Python
官方实现带REPL, 直接用`python`命令, 不带参数时即进入REPL环境.  用`exit()`退出.

## Lua
官方实现带REPL, 直接用`lua`命令即可. 

# 原生不带REPL的语言
## JavaScript
类似JavaScript这种量级的脚本语言本来应该都是有REPL的, 可是JavaScript是个一般在浏览器中运行的语言, 所以有些特殊了.  不过有一些实现.  比如Mozilla的[*Rhino*](https://developer.mozilla.org/en-US/docs/Rhino), 以前我写过一个*Rhnio*在[Mac下安装的教程](http://www.jtianling.com/articles/2057.html), 这里不再重复了.  
另外, 我推荐使用最近流行的[node.js](http://nodejs.org/)来做REPL, 虽然node.js一般都被认为是一个服务端的脚本环境, 但是本身就是个很不错的REPL环境, 还自带一些common JavaScript的库环境, 同时支持npm, 比Rhnio要更加强大一些.    在Mac下简单的使用node.js方法是用*brew*, 虽然版本可能有些老.  

## PHP
PHP作为服务端的一个常用脚本语言, 本身设计就是作为一个apache的mod语言, 所以本身也不带REPL, 虽然以它的语言类型来说应该是带的, 不过Facebook为我们实现了一个PHP的REPL [*phpsh*](http://www.phpsh.org/).  有意思的是该实现竟然是通过Python来安装的...  

## Java
Java作为传统的静态类型语言, 本身是不带REPL环境的, 但是有[*BeanShell*](http://www.beanshell.org/).  
BeanShell下载后, 将.jar文件放在Java可以找的到的库目录中, 比如Mac下的`~/Library/Java/Extension`目录, 然后通过命令`java bsh.Interpreter`来运行.  使用`exit();`命令退出.  
我一般在.bash_profile中用`alias ijava='java bsh.Interpreter'`简化为`ijava`命令.  
同时也有一些人推荐使用类似[*Closure*](http://clojure.org/), [*Groovy*](http://groovy.codehaus.org/), [*Scala*](http://www.scala-lang.org/)等jvm上带REPL的语言环境(一般兼容Java)来做REPL的, 没有试用过, 不评价.  

## C Sharp
[据说](http://stackoverflow.com/questions/1187423/anders-hejlsbergs-c-sharp-4-0-repl)以后将会有官方实现的REPL, 目前有一些第三方的实现.  比如[*Mono*](http://www.mono-project.com/CsharpRepl)就[自带REPL](http://www.mono-project.com/CsharpRepl).  安装完Mono后, 执行`csharp`命令就可以进入C#的REPL了.  

## C++
[*cling*](http://root.cern.ch/drupal/content/cling), 有Mac版本直接下载, 不过运行的方式有些诡异, 那就是在解压后的目录中运行`./bin/root`(在bin目录中运行反而不行), 需要先安装[*XQuartz*](http://xquartz.macosforge.org/landing/)这个Mac下的X环境.  用`exit();`退出.  
发现C++能有REPL真是惊喜, 虽然本质上C++并不是一个适合REPL的语言.  而cling这个REPL甚至都没法方便的定义一个函数.  

## Haxe
[ihx](https://github.com/ianxm/ihx),  可以直接通过`haxelib install ihx`安装, 然后通过`haxelib run ihx`运行.  
也有一个网页运行版本<http://try.haxe.org/>.  
我在`~/.bash_profile`中添加`alias ihx='haxelib run ihx'`, 执行`ihx`即可进入Haxe的REPL.  

# 其他
## repl.it
这个不知道怎么归类, [*repl.it*](http://repl.it/languages)本身支持多种语言, 运行在网页上.  虽然感觉有些版本比较老(比如Ruby还是1.8.x的版本), 但是作为网页服务, 并且支持那么多语言, 省事的时候可以尝试一用.  支持的语言如下:  

* 经典的语言(Classic)
    * QBasic:  Structured programming for beginners.  
    * Forth:  An interactive stack-oriented language.  
* 实用的语言(Practical)
    * Ruby (beta):  A natural dynamic object-oriented language.  
    * Python:  A dynamic language emphasizing readability.  
    * Lua:  A lightweight multi-paradigm scripting language.  
    * Scheme:  An elegant dynamic dialect of Lisp.  
* 诡异的语言(Esoteric)
    * Emoticon:  Programming with an extra dose of smile.  
    * Brainfuck:  A pure Turing machine controller.  
    * LOLCODE:  The basic language of lolcats.  
    * Unlambda:  Functional purity given form.  
    * Bloop:  Nothing but bounded loops.  
* 网页语言(Web)
    * JavaScript:  The de facto language of the Web.  
    * JavaScript.next:  The JavaScript of tomorrow.  
    * Move:  The easy way to program the web.  
    * Kaffeine:  Extended JavaScript for pros.  
    * CoffeeScript:  Unfancy JavaScript.  
    * Roy:  Small functional language that compiles to JavaScript.  

## codepad
[*codepad*](http://codepad.org/)这个算不上REPL, 但是允许你不安装任何编译器就可以在网页上运行很多语言, 所以有时候也算很方便.  特别是你想简单的给出一些代码片段, 让别人可以迅速的得出结果时.  codepad会自动的生成一个地址, 你直接分享这个地址即可, 比如这个[Python的片段](http://codepad.org/rryidzqt).  任何人点击`submit`都能很快的看到结果.  这种分享代码片段的方式比[*snipplr*](http://snipplr.com/)和[*github gist*](https://gist.github.com/)这种单纯贴代码的方式要更为先进一些.  
支持的语言如下:  

* C
* C++
* D
* Haskell
* Lua
* OCaml
* PHP
* Perl
* Plain Text
* Python
* Ruby
* Scheme
* Tcl

# WIKI的列表
发现这里的列表也挺详细的:<http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop>
p>
