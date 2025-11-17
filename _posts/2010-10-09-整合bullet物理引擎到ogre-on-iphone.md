---
layout: post
title: "整合Bullet物理引擎到Ogre on iPhone"
categories:
- iOS
- "游戏开发"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '26'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)

## 为什么选择Bullet

    [Bullet](<http://bulletphysics.org/> "Bullet")  
算是一个比较流行的3D物理引擎了，大概的看了几眼以后，了解了一些基本用法，发现很多3D物理中的概念与2D（比如Box2d）中的概念是相同的，甚至，Bullet的一些用法都与Box2D类似。基本了解以后，对于我来说，那就是iPhone平台的问题了。  
    我选择Bullet而不是其它一大堆同样著名的物理引擎，主要源自乌龙([oolongengine](<http://code.google.com/p/oolongengine/> "oolongengine")  
)  
引擎，该引擎由wolfgang.engel最先创建，并且内嵌了bullet的支持，竟然如此大牛都青睐的引擎，我怎么能无视呢？何  
况，oolongengine的使用，也说明Bullet在iPhone中使用完全没有问题。另外，还有Blender这个非常著名的3D建模工具也是对  
Bullet有直接支持，可见Bullet的流行程度。事实上，还有些故事，比如oolongengine的项目负责人之一erwin.coumans，  
同时就也是Bullet的项目创建者兼现在的负责人。（到Google  
Code上去看看就知道了）并且,erwin提到，Bullet能够流畅的在iPhone上运行，wolfgang提供了很大的帮助，对浮点运算进行了特  
别优化。最有意思的是，迪斯尼公司，自己的一些项目用到了Bullet，（看主页上的介绍，起码玩具总动员3这个游戏用到了Bullet）所以开发了自己  
的MAYA  
Bullet插件，为了回报开源社区，已经将此插件开源了。。。。。感谢Bullet，也感谢迪斯尼，同时感叹国外这种开源社区之间的交互。。。。。呵  
呵，这才叫欣欣向荣的良性发展，你帮助我，我帮助你，公司受到帮助，也对社区进行回报。知道了这么多故事以后，更加是对Bullet多了很多好感。最值得  
一提的是，[erwin](<http://code.google.com/u/erwin.coumans/> "erwin")  
简直就是个开源狂人。。。。。他还发起过一个叫做[gamekit](<http://code.google.com/p/gamekit/>)  
的开源游戏引擎项目，希望整合Ogre/Irrlicht和Bullet，因为是erwin创建的项目，也非常值得期待。。。。。。。  
    闲话多说一向是我的毛病。。。。也就说到这里了，用以前的[OGRE on iPhone](<http://www.jtianling.com/archive/2010/09/18/5893288.aspx> "OGRE on iPhone")  
工程直接开工了。

## 

## 在XCode中编译Bullet和OgreBullet

     
初下载Bullet后，用CMake做工程，只能做Mac OS  
X的工程，没有iPhone的选项，于是参考一下乌龙引擎的做法，就是将整个Src目录都拷贝进自己的工程，好像是从iPhone开始，流行这种"暴力"  
使用源代码的方式了。。。。。只能说Apple的XCode开发的还不足够人性化，所以建库的工程没有VS那么方便，再加上iPhone天生的不支持动态  
库，更加助长了这种“暴力”使用源代码的方式，其实每次修改工程文件编译都会慢很多，无奈啊。。。。。在Bullet的论坛中，搜索到erwin的准[官方解决方案](<http://www.bulletphysics.org/Bullet/phpBB3/viewtopic.php?p=&f=9&t=2628> "官方解决方案")  
就是拷贝全部目录。。。。汗一个-_-!  
    既然如此，一切倒是简单了。。。。。下载[Bullet的源码](<http://code.google.com/p/bullet/downloads/list> "Bullet的源码")  
，目前最新的是2.77，拷贝Src目录，删掉无用文件，比如CMake的一些文件。（或者直接从oolong引擎中将整个Bullet目录拷贝过来最简单，只不过版本目前是2.73）然后配置Bullet的Include目录，编译，一切OK。  
   

现在开始尝试嵌入OgreBullet，方法还是直接包含源代码。比较特殊点的是OgreBullet需要用到Bullet的  
ConvexDecomposition，这个库在Bullet的Extra中，也将源代码都拖过来，然后弄好include目录，就没有问题了。

## 

## 测试

    现在进入测试阶段，就用OgreBullet的[Tutorial](<http://www.ogre3d.org/tikiwiki/Ogre+Bullet+Tutorial+1+-+Source+Code&structure=Libraries> "Tutorial")  
中  
的例子。源代码全部拷贝过来，唯一的问题是ExampleApplication在iPhone中有些小问题，修改一下函数，namespace后问题解  
决。运行时崩溃，查看问题，还是ExampleApplication这个类的问题，难怪在Ogre的iPhone  
template不用这个类，崩溃的地方很有意思，OIS获取键盘的时候：  
mKeyboard = static_cast<OIS::Keyboard*>(mInputManager->createInputObject( OIS::OISKeyboard, bufferedKeys ));  
注释更加有意思：  
//Create all devices (We only catch joystick exceptions here, as, most people have Key/Mouse)  
典型反映了代码永远赶不上时代变化，既然这个类已经不被人使用了，我也就不费劲去用了，将原来的例子代码全部嵌入到OgreFramework类中。  
运行，崩溃，发现忘了添加新增的资源，将BumpyMetal.jpg材质和cube.mesh模型添加进工程。再次运行，一些正常，有图有真相：

![](http://hi.csdn.net/attachment/201010/8/0_1286559023j642.gif)

当一切都OK以后，我发现我的目标竟然与GameKit是一样的。。。。。不就是Ogre+Bullet吗？[erwin](<http://code.google.com/u/erwin.coumans/> "erwin")  
估计以前就已经想过我所想了。。。。。也许，尝试下GameKit也不错。

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**