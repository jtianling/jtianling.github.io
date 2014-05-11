---
layout: post
title: "Cocosino项目漫谈"
date: 2013-07-30
comments: true
categories: 随笔
tags: Cocosino, 故事, JavaScript, 游戏开发
---
 

最近Cocco2d-x的主页上Post了一个项目, 名叫[Cocosino](http://www.cocos2d-x.org/news/129), 是一个Cocos2d-x Javascript Binding/cocos2d-html5的IDE. 很有兴趣, 所以下回来看了一下.
<!-- more -->
Cocosino定位为IDE, 但是因为目前的版本只是非常早期的版本, 所以功能相当的不足, 基本上仅相当于一个项目创建脚本 + 一个简单的文本编辑器.  假如我真的要做一个项目的画, 我甚至更愿意自己写个脚本干这个事情, 起码文本编辑器我还能用VIM.  
失望之余, 去Kickstarter看了下Cocosino的[项目介绍](http://www.kickstarter.com/projects/881121752/cocosino).  发现情况相当惨淡, 从七月12号到今天, 已经18天了, 只融到了$1447, 联想到了前段时间的[Spine](http://www.kickstarter.com/projects/esotericsoftware/spine), 两者同样定位为开发工具, Spine30天募集资金$67569, 我倒是想从项目的角度分析一下为啥Spine能成功而Cocosino不行.  
  
项目寻求资金的时间点:
Spine首先做了一个完整版本, 具有全部功能的工具, 募集资金仅仅是用于runtime和更高级功能的开发, 所以宣传视频可以做的很棒, 展示了众多让人眼前一亮的功能.  我尝试了一下具有完整功能的Spine, 立刻决定付费, 成为backer了.  
而Cocosino放出的是一个最早期的版本(作者称first version), 基本没有啥功能, 就如我说的, 大概也就相当于一个项目创建脚本和一个简单的文本编辑器, 所以宣传视频都没有啥可以说的, 展示了半天, 也就相当于证明了这个项目创建脚本创建项目的确是成功了.  吸引力实在实在有限.  
假如Cocosino稍微再缓一缓, 等IDE方面比较具有吸引力的功能做出来了, 到时候视频展示一下javascript的断点调试, 强大的代码补全功能, 再有个一键签名打包啥的, 然后再出来说"Why do we need your help?"的募集理由时, 可以是说工具已经完善并且稳定了, 但是考虑给Cocosino加上插件系统, 添加Vim, Emacs的植入plugin啥的,   估计一下就能让听闻者流泪, 观看者付费了.  现在这样, 吸引力实在有限.  

项目目标人群:  
以前我和一个老同事聊天, 就很感叹于原公司的2D动画工具的强大, 而开源社区这块的不足, 理由太简单了, 开发引擎是个多么有挑战和乐趣的事情啊, 而工具呢? 去考虑的是UI, 用户体验和细节, 太多繁琐的东西了.  这根本就不是那些大牛们感兴趣的领域, 以前[Orx](http://orx-project.org/)的作者就和我说过, 他Hate开发工具.  简而言之, 2D骨骼动画本身是个很有潜力的东西, 不局限于任何引擎, 任何平台, 除了少数大公司内部有类似的工具, 开源社区极端缺乏一个这样的工具, 所以Spine出来的时候, 我感觉是相见恨晚.  
相对而言, Cocosino针对的市场就是另外一回事了, Cocos2d-x Javascript binding本身就还不够成熟, 还没有太多成功的例子, 意味着连用Cocos2d-x javascript binding的开发者都还少, 那对相关开发的IDE的需求就更少了.  
对于这个问题, 我觉得是目前市场的原因, 等将来javascript binding成为cocos2d-x开发的主流的时候, cocosino的市场前景还是不错的(虽然还是要小于Spine).

小结:
整体而言, 要是Cocosino能达到他提出的目标:  

* Develop Cocos2d games on Windows, Mac OS and Linux
* Create a Cocos2d JavaScript game for both native and web
* Develop games with call tip hints and autocompletion of cocos2d JavaScript API
* Use advanced documentation, samples and tutorials
* Debug JavaScript codes easily
* Publish your game for smartphones, tablets, web and desktop with only one click

我觉得Cocosino还是一个非常不错的产品的, 但是现在Cocosino的开发者虽然是在干一件正确的事情,  但是很明显是在一个错误的时间.  
