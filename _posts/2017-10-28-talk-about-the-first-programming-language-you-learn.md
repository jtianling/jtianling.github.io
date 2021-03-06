---
layout: post
title: 小议入门语言对初学者的影响
date: 2017-10-28
comments: true
categories: 编程
published: true
tags:
- 编程语言
---

很多初学编程的人都喜欢问一个问题, 那就是刚开始学编程, 首先学什么语言好啊, 在不同的阶段, 我自己关于这个问题的思考也不一样, 这里聊聊我现在的思考.  

<!-- more -->

**目录**:

* TOC
{:toc}

# 常见的回答
## 不屑的态度
常常能看到很多*牛人*对这种问题都是很不屑的, 包括我在以前某个阶段, 也是这种态度, 总体上的意思就是, 假如你真成为了程序员, 那么你总归会学会一大堆编程语言, 所以, 你刚开始学什么并不重要, 学就好了, 重要的是你快点开始学.  
现在我认为这种态度是有问题的, 因为最后你能吃饱, 所以吃什么, 怎么吃, 吃东西的顺序就不重要? 当然不是.  
 
## 从简单的入门
稍微靠谱点的人, 会推荐你从某个简单的语言入门, 比如Python, JavaScript, 理由也是类似语言不重要, 重要的是先学会编程思考的逻辑和通过入门语言学会常见编程语言的特性, 然后就可以触类旁通, 用任何你实际需要的语言工作就好了.  
那么问题来了, 入门语言只要是相对简单, 并且没有什么大的毛病就好了吗?  其实没有那么简单.  

# 我的思考
我觉得一般常见的回答都把入门的语言选择这个事情考虑的太简单了, 也把这个决定的影响看的太小.  
刚开始学编程时选择的入门语言对初学者的影响其实非常大, 起码有以下几点:

1. 语言决定了工作的领域
2. 语言的选择, 也是语言环境的选择
3. 语言决定了你的思维方式
4. 语言决定了你的学习方向

## 语言决定了工作的领域
初学的编程语言, 很可能就是初学者找的第一份工作用的语言, 而因为不同的语言都有自己擅长的领域, 所以这个语言的选择几乎就决定了你第一份工作的领域.  
要求初学者先从某个语言入门(比如Python), 然后再考虑自己想找什么工作, 再学会这个工作会用的语言, 这个弯路走的就有点远了.  

进一步的说, 就算同样是编程, 在不同的细分领域之间的切换其实是有比较大的成本的, 也没那么简单, 对于一些人来说(特别是没有那么愿意不停折腾的人) 这可能就是你一辈子工作的领域.  

这个, 当然需要慎之又慎.  

## 语言的选择, 也是语言环境的选择
说只需要学会语言特性, 就能简单的在多种语言中切换的人, 十有八九的确是用新的语言在做一些简单的初级工作而已, 并且还是低效的在工作.  实际的工作并没有那么简单.  
对一门语言的学习, 最后真正决定效率的是不仅仅是语法的熟悉, 还有对新语言的惯例的熟悉, 编程风格的熟悉, 运行环境的了解, 社区的了解, 常见库的 API 的熟悉(包括标准库).  
这就像你也许以为从 Python 切换到 Ruby 很简单, 因为这两个语言基本上就是一个语言(Guido van Rossum自己说的), 互相的特性也差不太多, 但是要达到一个非常熟悉 Ruby 的程序员一样的工作效率, 这中间还有很多路要走, 哪怕是最接近的切换, 比如从Python Django开发到 Ruby on Rails开发, 你还是需要先熟悉 Rails 的 API, 不同的HTML模板语言,  Ruby 不一样的对集合的惯用处理方式, Ruby 的Block, Proc, Ruby 的 Gem, Bundle 的用法, 可能还需要有 Rakefile 工具的使用, Ruby 自己的版本控制, 这些哪是简单的看看语法, 说切换就能切换的.  
更何况, 现实中的工作内容切换, 可比从Python Django 到 Ruby on Rails 要复杂的多.  慎重的选择一个入门语言, 并且熟悉相关的环境, 能少浪费很多不必要浪费的时间.  

## 一开始熟悉的语言, 决定了你的思维方式
> 语言的界限就是一个人世界的界限	
> -- 维特根斯坦

一个人的母语, 是会很大的影响一个人的思维模式的, 一个民族的语言里面没有可以用词来描述的东西, 这个民族的人很难了解. 据说中国人数学比欧美国家好, 有个很大的原因是, 中国的的数字发音都是单音节, 比英语中很多数字的多音节发音效率要高, 这个会影响计算时的速度.    
 
一开始学习的编程语言, 就相当于你编程时的母语, 影响效果也是一样的深远, 你也没法去思考你用的语言中不存在的特性, 也没法去想用其他语言的特性来更简单的实现某个功能.  就像你要是一开始学习的是 C++, 可能就没有函数式编程的思路, 习惯用迭代而不是递归,  习惯于用for迭代, 而不是用reduce和map.   

我在[原来有篇博文](http://www.jtianling.com/The-limits-of-my-language-means-the-limits-of-my-world.html)中就感叹过类似的意思, 当时从 C++ 的语言环境切换 Ruby 的工作环境, 真的是有些开眼界了的感觉.  

而且, 因为前面提到的原因, 你可能在第一个语言上工作很长时间, 可能会适应这个语言的缺点, 就算你将来再去学习其他语言, 要扭转这种思维模式, 会花更大得多的代价.  

## 语言决定了你的学习方向
你的工作领域很大程度上决定了你工作后继续学习的方向, 这个自然不用说, 但是, 就算你是一个很热爱编程, 业余时间的学习也很难逃脱一开始的选择.  
虽然不排除特例, 但是你要是从底层的语言入门的(比如C, C++), 就是可能会更关注代码的效率优化(因为你的工作语言是C, C++, 很可能对代码的运行效率要求更高), 因为优化的原因, 你去了解了操作系统相关的知识, 了解操作系统的任务调度, 内存管理.  
要是你一开始学习的是Java, 那么你更可能看的是怎么管理更大规模的代码, 比如设计模式, API 设计, 企业架构等, 更牛一点的, 也就是看到JVM字节码, 很少有人会去看汇编.  

还是假设你是个爱学习的人, 那么你业余时间肯定也是会学习, 也是会去了解工作相关行业的信息, 那么, 你学的是C++, 你就会关心C++ 1X的进展, 你学习的是Java, 你会关注Java的新版, 你学习的是Python 你会关心PyCon, PEP, 你学习的是Objective-C, 你会看WWDC, 你会开始学习 Swift, 你学的是 JavaScript, 你会看ES7, Babel, TypeScript等, 简单的说, 你会在你选择的语言相关的信息上花很多很多的时间, 事实上, 说语言之间能简单切换的同学, 你们真的能了解所有这些语言新的特性, 新的成熟的库, 用每个语言最新的特性, 以社区最新的推荐惯例用法来写代码吗? 没有人能做到.  

## 你还觉得入门语言的选择不重要吗 
上述表达都用了"决定"二字, 可能太过绝对, 但是用"很大程度上决定", 真是一点也不过分.  要是你认为自己天赋异禀, 能轻松掌握各种语言, 或者你一开始就是把编程作为智力游戏, 没打算作为职业, 或者你准备好了一开始随便学个语言, 然后用更多的精力去学习其他语言, 然后再工作, 你都当我没说过, 你开心就好.   

# 怎么选择入门语言
既然入门语言这么重要, 就不要那么轻松的做决定了, 不是仅仅简单的说没有大毛病就可以了.  

其实我感觉, 回答怎么选择入门语言这个问题之前, 应该想一想自己将来想在哪个领域工作, 然后选择这个领域最热门的语言就好了, 这个可能是最最重要的, 至于这个语言本身什么情况, 哪怕是类似C++这样的语言, 该学也学, 这也比你真的"入错行", 或者随便学个大家都推荐的Python然后想去开发游戏, 或者App, 发现找不到工作要好.  

基于同样的原因, 一些人推荐的Scheme, 我是不太推荐入门就学习的, 除非你的领域真的就需要Scheme.  

而思维方式的弥补,  就参考Peter Norvig的[Teach Yourself Programming in Ten Years](http://www.norvig.com/21-days.html)吧.  

# 我是怎么选择的
> Two roads diverged in a wood, and I took the one less traveled by, And that has made all the difference. 
> -- Robert Frost

懂了那么多道理, 其实还是过不好这一生...  
C++是我入门编程学习的第一门语言, 我博客里面关于 C++的内容也是最多的, 当年刚毕业, 很无知, 对于未来干什么, 学习什么语言完全没有概念, 当时的语言选择也没有现在这么多, 无非也就是C++, Java, C#这几个相对热门,  但是我最后比较神奇的选择了 C++, 理由也很简单, 我听说 C++ 很复杂, 所以就选择了 C++ 而不是 JAVA, C#, 这个选择影响深远.  
因为学的是 C++, 所以在长沙不好找工作(因为那边原来都是做软件外包, 用的都是 Java), 所以来了北京, 因为 C++ 的应用领域也有限, 最后找的工作是做游戏(这完全是学习 C++然后找工作的被动选择), 然后, 很长很长时间, 都是在做游戏......
我可以这么说, 这个决定就是影响了我的一生的, 假如当时选择了 Java, 我一定是有不一样的人生轨迹, 至于比现在好, 还是差, 这个就只有天知道了.  

# 最后
最近总算完成了多年的一个心愿, 为了方便在多个编程语言中切换, 做了一个简单的辅助大脑切换的工具.  
为 C++ 部分写简介的时候, 莫名其妙就写多了, 有感而发, 又很久没有写博客了, 单独写了这一篇.  
