---
layout: post
title: "语言的界限就是一个人世界的界限"
date: 2012-12-17
comments: true
categories: 编程
tags: Ruby C++
---

>	语言的界限就是一个人世界的界限	
>	-- 维特根斯坦

# Ruby on Rails的世界
很多人会告诉你, 学习不同编程语言能够让你看到新的世界, 改变你思考的方式, 在*程序员修炼之道*中甚至会建议'每年至少学习一门新语言', 也有Peter Norvig在[*十年学会编程*](http://daiyuwen.freeshell.org/gb/misc/21-days-cn.html)中提出的那样, 学会至少半打语言.  我是比较赞同这种观点的.  
<!-- more -->
<!-- toc-begin -->
**目录**:

* [Ruby on Rails的世界](#ruby-on-rails的世界)
* [Ruby on Rails的世界以外](#ruby-on-rails的世界以外)
* [C++的世界?](#c-的世界)
* [最后的感叹](#最后的感叹)
* [列表](#列表)

<!-- toc-end -->

我是从C++开始学习编程的, 大部分工作时间也是在用C++, 但是常常会受到一些人的'蛊惑', 看到一些鼓吹某个语言好的文章后, 就会忍不住的学习这个语言, 然后理解一下为啥好.  再加上工作本身的需要, 已经学习了一堆的语言了.  但是, 没有哪一次像这次学Ruby on Rails感受更多.  一般提到学习新语言的时候都会说离现在的知识越远越好, 其实本质上就是需要你接触到一个完全不同的环境, 进入一个完全不同的领域.但是我以前没有太理解, 语言学了一大堆, 但是其实一直在做游戏, 学个新语言吧还都去找找这个语言写的游戏引擎(或者用这个脚本语言驱动的游戏引擎)弄来弄去也就那么几个概念, 甚至于用的工具变来变去都差不太多.  当然, 在以前出现这样的情况, 部分原因是我刻意的, 为了专注于游戏.  这一次静下心来, 好好的把Ruby on Rails学了过来, 虽然还并不是做纯粹的网页, 而是做一个客户端的后端, 但是感觉已经和写游戏完全不一样了.  其中最大的感受在于网页开发领域的自动化程度之高, 让游戏开发简直就像是还停留在上个世纪, 让我都有些怀疑自己是不是还没有接触过真正牛的游戏开发.  

特别是[Gem](http://rubygems.org/)和[Bundle](http://gembundler.com/). Gem这个Ruby的包管理系统真是太方便了, 发现一个新的库? 简单的`gem install xxx`就行了, 同时还会自动下载依赖的所有其他库. 要加到工程里面去, 在Gemfile里面添加一行`Gem 'xxx'`, `Bundle install`就行了. 联想一下C++里面怎么在VS里面加一个新的库删一个库或者库更新, 我都要哭了.  在C++里面, 配置和加载一个大点的库都可以单独写篇博客了, 比如Boost, Qt啥的, 我还真[写过](http://www.jtianling.com/articles/1002.html)...  同时, 真正把Ruby当作一个平台来管理的, 还有配套的[Gem网站](http://rubygems.org/)和[ruby-toolbox](http://www.ruby-toolbox.com), 当有多个类似的Gem不知道用哪一个的时候, 看看这个网站上的下载量, 你基本上就有得选择了. 在没有特殊要求的时候, 在开源的世界里面, 选择最热门的, 一定是够用的选择.  不会是最差的, 虽然也不一定是最好的.  我用过类似yum, apt, brew等包管理, 但是还没有真正在某一个开发语言里面见识过.(真是惭愧)  

# Ruby on Rails的世界以外
我的反应是, 其他的环境难道就没有类似Gem的包管理系统吗?  让我惭愧的是, 原来真的有, 只是我从来都不知道而已, Python的[pip](http://pypi.python.org/pypi/pip), Objective-C的[cocoapods](http://cocoapods.org/), 最让我惊喜的是, 还有类似Bundle思想的Vim的插件管理[Vim Bundle](https://github.com/benmills/vim-bundle), 从这个名字就知道这个哥们是从哪学来的这种自动化管理思想了.  值得思考的是, 为什么我一直不知道它们的存在, 仅仅是因为我孤陋寡闻吗?  我几乎是与学习Ruby同时就知道了Gem, 因为几乎每个第三方库都会告诉你用Gem来安装, 而其他语言不是...  这就是生态系统的差异.  BTW: Gem从Ruby1.9开始, 就已经内置在Ruby了.

# C++的世界?
ObjC都有了cocoapods, 那C++呢?  C++因为本身跨平台的负担, 各类库的编译方式各式各样, 再加上历史传承原因, 老旧并存, 从原始的makefile, 到autoconf, 到稍微新一点的CMake, 甚至还有用ant的, 编译器也有VS, g++, llvm等几家了, 要做一个让第三方库能通用的包管理, 就我的想法几乎是不可能的, 但是针对特定环境的, 比如针对Windows的VS, Linux/Unix的G++等, 还是有可能的.  有意思的是, 还真的有, 虽然好像都不成熟. 找到一个所谓windows-package-manager, [Npackd](http://code.google.com/p/windows-package-manager/)好像能下载一些库, 不可思议的是, 这些哥们竟然还特意开发了一个UI... 真是思维的差异啊... 难道大家都认为没有UI的东西在Windows上就不会有人用吗? 因为Windows那烂的不可用的shell吗?  支持VS的[NuGet](http://nuget.org/), 不过好像专门用于管理.Net, 悲哀.  在这个过程中, 我还发现了[Apache Maven](http://maven.apache.org/), 一个Apache发起的用于JAVA的包管理工具.

不用怀疑, 结果是很明显的, C++还没有一个稍微成熟点, 到可用地步的包管理工具, 不管是VS里面还是g++上, 也是因为这样原因, 我在学习Python的时候, 甚至都没有考虑到去找类似的工具... 其实easy\_install和pip的成熟度还是较高的, 但是从C++来的思维方式, 限制了我, 这是我现在的真实感受.  回忆起开发的过程, 在VS中配置一个工程真的是一个痛苦的过程, 以至于没有一点经验还真干不了, 并且还容易出错, 格式, 目录什么的要是乱了还影响后来的开发, 因为这个原因, 在我刚工作的时候, 即使是一个我自己从头开发的全新服务端程序,(我是从服务端开始开发的)都是我们主程配置好了工程, 解决了一些自己库和第三方库的依赖问题后, 然后我再开始编码的. 而这个服务端的程序配置, 是全手动的, 为了简化, 是从一个我们自己做的模板上clone出来, 然后再去做调整. 到我带团队的时候, 初期也都是自己配置工程, 直到比较后期了才敢让其他人来干这个活, 尽管我早就已经对他们的代码相当放心了. 回忆一下这个过程, 就能知道这个过程有多么痛苦了.  不管C++本身有多少负担, 实际的开发过程相对于ROR来说, 的确是太原始了.  从以上的体验来说, 尽管C++被大家公认来说是一个非常难学难写好的语言, 但其实正确配置第三方库和C++的工程甚至比写C++本身来说还要困难...-\_-! 可能正是这个原因, C++库的开发社区有种反向的潮流, 那就是以自己库尽量少的依赖第三方库为优点, 简单的来说, 你要依赖第三方库太多, 配置太麻烦, 根本就不会有人愿意用你的库... 而这个, 假如有个好的包管理, 根本就不应该是问题.  这在某种程度上其实也限制了社区的良性发展, 每个库都带一堆的基础库算什么回事啊.  这个问题在C语言中似乎更加严重, 因为连STL都没有...

# 最后的感叹
想起以前一个经典的C++程序员与Python程序员之间的争论, 当时还感叹中国人的吵架智慧, [见这里](http://www.jtianling.com/articles/1278.html), C++的使用者们(包括我)很多时候都把自己使用C++开发的效率低归结为C++语言本身为了效率所做的牺牲, 即其本身的复杂性. 就如BS说的*'绝对复杂的问题需要相对复杂的工具来解决'*. 事实上, 还有一部分在于我们的开发环境, 包括上面提到的典型的项目配置过程, 只是我们没有意识到而已.  

# 列表
这里是我整理的一些包管理软件列表:  

* Ruby: [Gem](http://rubygems.org/)和[Bundle](http://gembundler.com/) 
* Python: [pip](http://pypi.python.org/pypi/pip)
* Objective-C:  [cocoapods](http://cocoapods.org/)
* Vim插件: [Vim Bundle](https://github.com/benmills/vim-bundle)
* Lua: [LuaDist](http://luadist.org/)和[LuaRocks](http://luarocks.org/)
* javascript: [cpm](https://github.com/kriszyp/cpm)和[jam](https://github.com/caolan/jam)
* nodejs: [npm](https://npmjs.org/)
* JAVA: [Maven](http://maven.apache.org/)
* .Net: [NuGet](http://nuget.org/)
* PHP: [PEAR](), [composer](https://github.com/composer/composer), [Maven for PHP](http://www.php-maven.org/)
* Windows: [Npackd](http://code.google.com/p/windows-package-manager/)
