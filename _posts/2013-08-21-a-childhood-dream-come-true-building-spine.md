---
layout: post
title: "[译]儿时梦想成真: Spine背后的故事"
date: 2013-08-21
comments: true
categories: 随笔
tags: Spine 故事 翻译
---

Spine是一个2D的骨骼动画编辑器, 因为其良好的UI设计及完整的功能, 在kickstarter上发布以后立即收到追捧, 作为一个几乎只有游戏开发者才会使用的小众工具, 募集了远超目标5倍的资金, 共计6.7W多美元.  以前我写过博客介绍了一些[Spine的基本用法](/use-spine-with-cocos2d-x.html).  [官方的网站](http://esotericsoftware.com/)上有更详细的介绍, 还有一段特性介绍的视频.
Spine的作者最近(2013-08-13)在自己的博客上写了一些关于[Spine背后的故事](http://esotericsoftware.com/spine/building-spine/), 我感觉很有意思, 在这里跟大家分享一下, 因为精力有限, 也不做全文的翻译, 主要翻译故事部分, 关于技术部分就不详细翻译, 只是写个概要了.

<!-- more -->

**目录**:

* TOC
{:toc}


# 一段小小的历史, 改变我的人生
我(Nate)从很久很久以前就想要制作Spine这样一个骨骼动画编辑器了.  我11岁刚开始学习用QBasic编程时, 我的杰作是一个3D格斗游戏.  这个游戏花费了我几年时间, 但其实也不是那么好玩, 但是它已经有骨骼动画和一个非常简单的编辑器了.  在我19岁离开学校进入公司后, 我又做了12年的软件开发.  在那个时候, 我刚刚离婚, 并且还有房贷尚未还清, 那时候我的生活就是工作, 吃饭和睡觉. 枯燥的生活让我决定要改变这一切, 我放弃了房子, 辞掉了在Mickey Mouse公司的稳定工作, 变成了一个无业游民.  在此后超过一年半的时间里, 我就在我世界各地的朋友们那儿鬼混. 我爱编程, 所以我花了很多时间在开源项目(还有街霸)上.  
[![3D格斗游戏截图](/public/images/2013/spine-qbasic.png)](http://www.youtube.com/watch?v=d7wntjD8YR8)

# 需求出现, 制作开始
最后, 我的难兄难弟Soren和我决定做一个游戏.  但序列帧动画限制太大, 并且总是需要花费很多时间在美术制作上. Soren是一个美术, 并且精通Softimgae, 所以我写了一个导出脚本和一个简单的骨骼动画库. 它能够正常工作, 但是工作的流程非常的不好.  因为它很难配置, 并且容易碰到不支持的Softimage的特性.  我们找遍了其他所有工具, 但是都没有合适的, 而我们有清晰的目标, 我们知道我们需要制作一个什么样的工具, 所以我们开始自己动手制作这个工具.  在我做那个QBasic格斗游戏足足20年后, 我很高兴的把全部的时间都投入到Spine上!  
我们一直推迟着Spine的发布, 直到完成了所有基础的工作以后.  我们有太多关于Spine的想法, 以致很难完成所有功能, 我们只能实现最基本的特性, 所以我们毙掉了很多想法, 我们总是告诉我们自己, "我们总是可以在以后再增加", 任何复杂并且又不是核心功能的特性要被去掉, 而另外一些复杂但是很重要的特性又必须要实现.  困难就在于知道这两者的不同.  还好Soren有很多实际的工程经验, 并且知道这样一个工具应该怎么工作.  同时Soren也想在Spine中加入成千上万的特性, 此时我就反过来拒绝那些特性, 除非它明显很必要(或者很容易实现).  
![Spine Dragon 截图](/public/images/2013/spine-screen.png)

# 人总是要吃饭的: Kickstarter
我们在Spine的编辑器部分花了9个月, 并且只有libgdx一个运行时库. 我们和投资人没有任何联系, 并且肯定我们正在花光我们的积蓄.  所以我们决定到Kickstarter上来试试, 一方面我们的确需要钱, 另一方面也是向大家宣传一下Spine.  为了让我们合作更方便, 我到了Denmark, 并且住在Soren的家里.  我把我的手机粘在椅子的后面, 录制了那段视频.(译者注: 指Kickstarter上用于宣传的[那段视频](http://www.kickstarter.com/projects/esotericsoftware/spine)) 这对我来说不是个容易的事情, 因为我必须尝试很多遍才能达到想要的效果.  我现在做梦(可能还有你)都还能总是会梦到我在说"Hi, my name is Nate!".  Soren录制了Spine的操作视频, 并且做了写视频的后期工作.  我们的目标是在前20秒内吸引住观众, 使他们愿意继续看完剩下的内容.  
我们担心不能达到kickstarter的goal, 所以我们设置了一个我们感觉可以完成一些runtime的底限, 1.2万美元.  而实际上我们只用了3天就达到了这个目标, 这是完全在我们意料之外的.  于是我们决定使用一个更好的方法来制作runtime, 那就是做一个通用的runtimes, 用这些runtime可以更加容易的制作目标游戏套件的runtime.  我们在Kickstarter上写了更多以前没有写的特性, 并且把他们都作为stretch goals.(译者注: Kickstarter上达到基础goal后, 通过募集更多资金去完成的更进一步的goal)  
  
![Spine Kickstater项目截图](/public/images/2013/spine-minichart.png)
  
要想对Kickstarter上的用户维持一个高水平的用户支持是一个艰巨的任务.  好几天, 我们把全部的时间都用在回复Kickstarter上的问题, 评论, 邮件和论坛帖子上.  这个事情非常的耗费精力, **但是我们的确确保了每一个有问题的人都得到了回答.**  (译者注: 就我最近使用Spine的经验来看, 作者对提问的回答的确相当即时)
Kickstarter最终募集了67569美元, 是我们初始目标的563%.  我们完成了除最后一个goal外的所有goals.  非常, 非常多的stretch goals.  现在回想起来, 实在是太多goals了.  大部分Kickstarter stretch goals在我们全职工作了6个月后还没有完成, 但是我们将会完成.  **我们决定对每一个曾经支持过我们的人兑现我们的承诺**.  

# 市场推广? 什么是市场推广?
我们从来没有为Spine做过任何市场推广, 主要可能是我们不知道该怎么做.  我认为Kickstater可能算是一种市场推广的形式吧.  我们的Twitter账户很活跃, 这可能也对Spine的推广有较大的帮助.  我认为肯定还有很多开发者会很喜欢使用Spine, 但是还没有发现它.  我们不得不寄希望于他们能通过Google或者从朋友口中得知Spine.  我知道这很天真, 但是市场推广在我看来是个不可思议的事情, 为市场推广花钱看起来非常的愚蠢, 因为你不会真的知道这个钱花的值不值.  

# Kickstater以后的生活: 客户支持和Stretch Goals
本段为译者写的概要:  
在Kickstater以后, 作者花费了相当多的时间回答用户的问题, 并且Nate如期的完成了一些Kickstater中许诺的Stretch Goals.  
Ghosting, 在Spine中绘制动画的过去和将来.
![Spine Ghosting功能截图](/public/images/2013/spine-ghosting.png),
  
支持在一个project中同时操作多个骨骼动画, 这样可以让Spine支持制作一些过场动画(以前我们叫cinematic).  但是目前还需要完成多个骨骼动画之间的绘制顺序问题才能进入实用阶段.  
  
内嵌了一个图片打包的工具, 这样就可以在不需要类似Texture Packer等工具的情况下, 单独导出需要的动画.
![Spine Texture Packer功能截图](/public/images/2013/spine-packer.png),
  
增加了event timeline功能, 这样可以在特定的时间点放声音, 粒子效果等.  这个功能很有用, 但是目前大部分runtime都不支持.  

# Spine用到的技术
本段为译者写的概要:  
Spine使用的技术很特别, 语言使用Java, 但是UI使用的是[libgdx](http://libgdx.badlogicgames.com/), 因为作者本身就是libgdx的联合作者.  作者还在这里给libgdx做了下广告, 告诉大家libdgx这个游戏框架有多么好用, 并且可以跨Windows, Mac, Linux, iOS, Android等平台, 甚至可以通过WebGL运行在浏览器中, 而Spine因为是用libgdx开发的, 所以Spine也可以在上述所有平台上使用.  另外, 这倒是解释了为啥Spine一开始就跨那么多平台, 并且主按钮是那么奇怪的放在左上角.  
以下是Spine用到的一些开源库列表:

* [scene2d.ui](https://code.google.com/p/libgdx/wiki/scene2dui), libgdx的一部分, 配合libgdx的2D UI库.  
* [TableLayout](http://code.google.com/p/table-layout/), 作者自己写的Java开源库, 配合ligdbx使用的UI layout库, 类似HTML的tables, 实际可以支持libgdx, Swing, Android, TWL等其他UI框架.  
* [Scar](http://code.google.com/p/scar/), 作者自己写的开源库, java一些utilities功能的集合.  
* [Wildcar](http://code.google.com/p/wildcard/), 作者自己写的Java开源库, 用于使用'*'匹配文件和目录.
* [Kryo](http://code.google.com/p/kryo/), 作者自己写的开源库, 用于高效的序列化对象.
* [JsonBeans](http://code.google.com/p/jsonbeans/), 作者自己写的开源库, 用于从json中序列化和反序列化Java对象.
* [TexturePacker](http://code.google.com/p/libgdx/wiki/TexturePacker), libgdx的一部分, 用户处理图片打包.  

很不可思议的是, 上面的那些开源库里面都是Nate自己写的(libgdx部分起码是参与了), Nate为了写游戏积累的东西不是一般的多, 很让我感叹.  
另外, 作者还提到它使用了[green threads](http://www.java-gaming.org/topics/java-continuations-and-greenthreads/28337/view.html), 这个在一个线程中模拟出多个线程效果的库, 用户级别的多线程实现.  
Spine有一个很好的构建系统, 并且在软件中内置了一个自动升级系统, 作者可以一键自动部署到各个平台的所有用户那里.  这个也很牛掰~~(也许是从一个C++开发者眼里看来吧)  
Spine的所有官方runtimes都在[github](https://github.com/EsotericSoftware/spine-runtimes)上开源发布, 所以它自己虽然只官方支持了13个开发套件, 但是因为为C, C++, Objective-C, C#, Java, ActionScript 3, Lua和JavaScript提供了通用的runtime, 该runtime仅仅是提供了一套[API](http://esotericsoftware.com/spine/files/runtime-diagram.png)来操作骨骼和动画, 但是不针对特定开发套件, 忽略了渲染部分, 使得更加容易完成, 因为这个作者认为正确的决策, 第三方的runtime已经超过20个了, 你几乎可以在任何你想要的平台和引擎上使用Spine.

# 生活是美好的
以下为译者写的概要:
Spine卖的不错, 作者得到了税后6万1千美元的收益, 作者说他还有很多增强Spine的想法, 比如增加包围盒等, 作者甚至提到Spine的编辑器中已经有了一个IK(反向动力学)系统(还没有加到runtime中).

以下为作者全文最后一段的翻译:
回顾以往, 会感叹事情的发展太疯狂了, 从一个糟糕的QBasic格斗游戏最后能发展成为自己热爱的事业.  我在今年6月刚刚结婚, 并且住在我老婆的故乡--克罗地亚, 我们住在一个8公里(译者注: 不知道原文这是表示宽还是周长)的小岛上, 这里没有公路, 也没有汽车. 虽然用的是很慢的3G网络, 但是生活成本非常的低, 而且克罗地亚的海滩很amazing. 我每天就是写代码, 游泳, 并且养了一个小狗.  生活很美好~~  

# 译后感
最近看到吴军写的一篇[关于乔布斯的文章](http://www.forbeschina.com/review/201307/0026734.shtml), 对其中一句话印象深刻, 我觉得也很适合用于总结本文: **大多数产品经理之所以做不出改变世界的发明, 是因为他们只看见了成功者最后的临门一脚, 而忽视了别人的长期思考.**  
