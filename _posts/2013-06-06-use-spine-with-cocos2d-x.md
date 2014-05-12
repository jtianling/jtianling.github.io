---
layout: post
title: "Spine的使用(With Cocos2d-x)"
date: 2013-06-06
comments: true
categories: 编程
tags: Cocos2d-x Spine
---

Spine是一个2D的骨骼动画编辑器, 因为其良好的UI设计及完整的功能, 在kickstarter上发布以后立即收到追捧, 作为一个几乎只有游戏开发者才会使用的小众工具, 募集了远超目标5倍的资金, 共计6.7W多美元.  我在其项目发布后, 成为了Spine在kickstarter的早一批backer, 这是我在kickstarter上第一个, 也是目前唯一一个支持的项目. 随后, 通过不断收到的邮件见证了Spine逐步完善的过程, 直到其发出target完成的邮件.  又过了这么长时间了, 因为手头的项目一直不需要太复杂的2D骨骼动画, 拖着没有研究, 现在也是时候看看Spine了, 可惜的是, Spine的使用还有一系列的[视频教学](http://esotericsoftware.com/spine-videos/)可以参考, 而Spine的Runtime使用完全没有文档, 只有一两个简单的例子. Spine团队的主要精力目前还是放在一些新功能的开发和Runtime的继续支持上, 写文档还排在[Next up](https://trello.com/board/spine-runtimes/5131f92a7d6864661c002455)上.
<!-- more -->

## Runtime使用
### 简单的循环动画
编辑上看视频教程吧, 只是打包文件需要使用[TexturePacker](http://www.codeandweb.com/texturepacker)的libgdx的Data Format来导出, 后缀改为atlas.  
然后, 从例子中能学到的东西:

1. 用`new CCSkeletonAnimation("test.json", "test.atlas");`来创建想要的Spine动画对象.  
2. 用`CCSkeletonAnimation`的`setAnimation("anim_name", true);`来设定想要的动画.  
3. 需要将CCSkeletonAnimation对象按node一样处理, 用addChild接口添加到parent node上.  并且对象可以当作普通的Node一样来操作, 因为它实际就继承自CCNodeRGBA.  

比如在一个node中, 按如下代码可以创建一个spineboy行走的动画, 并且循环播放.   

~~~ cpp
skeletonNode = new CCSkeletonAnimation("spineboy.json", "spineboy.atlas");
skeletonNode->setAnimation("walk", true);

CCSize windowSize = CCDirector::sharedDirector()->getWinSize();
skeletonNode->setPosition(ccp(windowSize.width / 2, 20));
addChild(skeletonNode);
skeletonNode->release();
~~~

### 播放一次动画
简单的情况, 播放一次动画后就不管了, 那么直接使用`CCSkeletonAnimation::setAnimation`, 并且以false为第二个参数就好了.  
更复杂的情况, 需要知道什么时候这个动画播放完了, 因为Spine的Runtime中没有动画结束的回调(这是另外一种良好的设计), 只能通过在update中判断.  更进一步的悲剧是, 在cocos2d-x的Runtime中中没有简单的判断方法, example中给了一个方法:

~~~ cpp
if (skeletonNode->states[0]->loop) {
	if (skeletonNode->states[0]->time > 2) skeletonNode->setAnimation("jump", false);
} else {
	if (skeletonNode->states[0]->time > 1) skeletonNode->setAnimation("walk", true);
}
~~~

这里使用的方法是判断播放时间, 我对此方法表示强烈的反感, 也**绝对的建议大家不要使用**, 因为你不仅需要预先知道每个动画播放的时长, 而且任何时候你改动了动画的播放时间, 这个代码都得回来改, 这样做根本就违反我们使用编辑器的初衷, 甚至我觉得在Runtime的example中给出这种代码是非常不负责任的行为.  这个方法只在一种情况下使用, 那就是你的确是想要在某个动画播放的确定时间干某个事情, 不过这种情况应该非常少见.  
在的确需要知道播放完一次动画时, 我建议用以下方式来完成, 因为没有现成的C++接口, 这里借用了一个C代码中的函数来完成工作:  

~~~ cpp
if(AnimationState_isComplete(skeletonNode->states[0])) {
	if ( 0 == strcmp(skeletonNode->states[0]->animation->name, "walk") ) {
		skeletonNode->setAnimation("jump", false);
	}
	else {
		skeletonNode->setAnimation("walk", false);
	}
}
~~~

### 连续播放动画
上面那个例子中的动画连续动画播放可以直接通过`CCSkeletonAnimation::addAnimation`接口来完成, 这样更加简单.  

~~~ cpp
skeletonNode = new CCSkeletonAnimation("spineboy.json", "spineboy.atlas");

skeletonNode->addAnimation("walk", false);
skeletonNode->addAnimation("jump", false);
skeletonNode->addAnimation("walk", true);
~~~

但是失去了一些灵活性, 并且, Spine还不支持将多个动画接起来作为一个完整的动画使用, 这个挺弱的, 再加上Spine工具本身就没有连接多个动画的功能, 就更加弱了.  

### 程序控制的骨骼动画
所谓程序控制的骨骼动画, 就是类似Spine宣传动画中那样, Globin的目光跟随着鼠标的移动.  这个功能的实现, 应该算是骨骼动画中最酷的一部分了.  传统的序列帧动画完全无法实现, 要实现的话还是得在序列帧外拆分肢体, 然后单独实现.  
在骨骼动画中, 可以直接取到骨骼, 然后调整骨骼, 实现这样的效果, 要方便很多.  在Spine中取得骨骼的函数是`CCSkeletonAnimation::findBone`, 其他的就是设置rotation就行了.  

{% highlight cpp %}
void ExampleLayer::ccTouchesMoved(CCSet *touches, CCEvent *event) {
	CCTouch* touch = (CCTouch*)touches->anyObject();
	CCPoint pos = touch->getLocation();
	Bone* head = skeletonNode->findBone("head");
	CC_ASSERT(head != nullptr);
	float tanValue = (pos.y - head->worldY) / (pos.x - head->worldX);
	float rotation = atan(tanValue) * 180 / 3.1415;
	head->rotation = rotation;
}
{% endhighlight %}

需要注意的是, 动画本身要是在播放的话, 不能动这个骨骼(被parent牵引是OK的), 不然的话会被动画本身强制改变, 看不到touch带来的效果.  

### 其他功能

#### 慢动作和快动作
设置CCSkeletonAnimation的timeScale值.

#### 动画混合
对于一般情况下, 动画的切换要求两个动画完全能衔接上, 不然会出现跳跃感, 这个对于美术来说要求很高, 而Spine加了个动画混合的功能来解决这个问题.  使得不要求两个动画能完全的衔接上.  
比如上面的walk和jump动画, 就是衔接不上的, 直接按上面的办法切换, 会出现跳跃, 但是加了混合后, 看起来就很自然了.  哪怕放慢10倍速度观察, 也完美无缺.  这个功能在序列帧动画时是无法实现的, 也是最体现Spine价值的一个功能.  代码如下:  

```cpp
skeletonNode->setMix("walk", "jump", 0.3f);
skeletonNode->setMix("jump", "walk", 0.3f);
```

## 问题
Spine的出现, 对于2D骨骼动画编辑工具来说, 绝对是翻天覆地的变化, 划时代的.  这也再次说明了自己的问题, 因为和以前的同事说了很久了, 其实我们需要一个这样的编辑器, 但是自己却从来没有写过一个-_-! 当然, 我们当时讨论的是做一个开源的.  但是, Spine毕竟刚刚出现, 其实还是有不少的问题.  如下:  

### 工具使用上

1. 体验上, 因为Spine用了JAVA来实现偷懒的跨平台, 很多地方都弱爆了, 奇怪的menu就不说了,  那文件对话框难用的要死, 在Mac下, 会觉得那文件对话框简直就是折磨人, 不管是选对一个文件夹, 还是保存文件到一个地方, 都能让人很郁闷.  还能出现原界面被阻塞, 而文件对话框被挡住的情况.  假如要一套代码的跨平台通用, 那就没有用户体验可言.  当然, 其实Spine本身对动画编辑方面的体验还是非常棒的.  
2. 功能上, Spine不支持像cocos builder一样直接读取pack后的材质, 只能读原始的材质, 这个有些弱, 导致需要在原始资源上进行编辑.  这个在工程管理上没有直接读取打包后的材质方便.  假如打包出了什么问题, 这里也看不见.  
3. 还是功能上, Spine在编辑器中无法直接连接多个动画, 这个功能连cocos builder中都有.  
4. 虽然Spine有个用example做UI的演示, 但是实际上因为Spine没有任何地方可以设置点击响应和设置变量绑定, 这个基本上也就是只能做做UI上面的动画.  
5. 这个和Runtime也有关, Spine的扩展性几乎没有, 连想自定义一个参数都没有办法, 比如我想用Spine来设置一个Bone的旋转的上限和下限, 也无法做到.    

### Runtime的问题
Spine的Runtime有些太马虎了, 问题相当多.  

1. 没有详细的文档就算了, 甚至连代码的注释生成文档都没有.  同时代码的注释也少的可怜, 根本就不像一个严谨的开源项目.  更进一步, 连example都只有1个, 要是不知道该怎么用, 哭去吧.  这个只能说Spine还不够成熟, 一般来说, 像这种程度的东西, **最好别用**.  
2. 为了让一套代码能够尽量支持多的引擎, 有些地方太偷懒了.  对此吐槽的也不止我一个, 比如这里的[*A call for coders to build a better Spine runtime for Cocos2D*](http://www.cocos2d-iphone.org/forums/topic/a-call-for-coders-to-build-a-better-spine-runtime-for-cocos2d/), 就算是C++使用者, 用这简单从C wrap过来的runtime我都感觉非常难受, 更加别说objc的使用者了.  
3. 最大的问题是Spine用了一套后缀为atlas的资源文件,   但是这根本不是cocos2d/cocos2d-x的使用方式, 我们要的是plist!  所以Spine用到的资源会和Cocos2d-x中用到的资源格格不入, 无法统一管理和cache.  这种问题使得Spine几乎不可用, 因为一个稍微想点样子的游戏, 也不能容忍每个动画都是在需要播放的时候再加载资源.  
这个问题有个解决方案, 就是不用example中使用的`CCSkeletonAnimation`创建接口`CCSkeletonAnimation::CCSkeletonAnimation (const char* skeletonDataFile, const char* atlasFile, float scale)`, 而是使用`CCSkeletonAnimation::CCSkeletonAnimation (const char* skeletonDataFile, Atlas* atlas, float scale)`这个接口, 并且自己首先缓存Atlas文件.  或者, 直接缓存所有可能出现的skeletonNode对象.  只是, 这些解决方法都太麻烦并且不够优美.  并且, 还是没有办法和cocos2d-x原有的资源统一管理.  

