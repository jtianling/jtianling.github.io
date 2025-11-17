---
layout: post
title: "从源码编译CEGUI for OGRE 的配置"
categories:
- "游戏开发"
tags:
- CEGUI
- Ogre
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
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

   

    现在在国内做游戏，似乎怎么都绕不开OGRE和CEGUI的学习，因为他们实在是太流行了。。。。。OGRE在Google中搜索game engine长期排在第一，而CEGUI又几乎是OGRE的官方UI。。。毕竟不是盖的。我第一份工作的时候就做过一些CEGUI相关的工作，（但是那时候引擎不是OGRE）但是一直没有太深入的学习，然后在游戏开发的路上绕了很大一圈，接触了OpenGL(ES),以及各色2D，3D引擎，最后似乎还是回到了OGRE和CEGUI，所以还是有些感慨。。。。。。

    当自己需要从头开始做某些基础工作的时候，与拿着成熟的框架和工程感觉还是有些不一样的。比如CEGUI和OGRE的配置。。。。。。。

    主要参考资料来自于《[Building CEGUI for Ogre / OgreRenderer](<http://www.cegui.org.uk/wiki/index.php/Building_CEGUI_for_Ogre_/_OgreRenderer> "Building CEGUI for Ogre / OgreRenderer")  
》。

    现在(2010.9.13)CEGUI的最新版是0.72，到这里[下载](<http://www.cegui.org.uk/wiki/index.php/Downloads> "下载")  
。（源码版本）

    然后，将CEGUI解压到某个地方。我这里选择的是OGRE的目录下。

此时，CEGUI-0.7.2/projects/premake中可以看到批处理build_vs2008.bat，运行一下就可以得到想要的VS2008工程，第一次我尝试的时候编译此工程，然后拷贝相关的lib,dll到OGRE的相关目录，会发现还是少一个文件,debug版本是CEGUIOgreRenderer_d.lib，然后我发现还需要配置。这里感觉就没有那么直观了。。。。。。。。。不属于work out of box，这也是本文写作的唯一有效目的。。。。。

## 配置：

1。在批处理的目录下的config.lua文件中，修改如下两行内容：

OGRE_PATHS = { "..", "include/OGRE", "lib" }

OIS_PATHS = { "..", "include/OIS", "lib" }

这里第一个字符串的路径根据你将CEGUI解压的地方来配置，我这里由于CEGUI已经解压到OGRE的目录下，所以仅仅使用父目录就可以了。

2。在config.lua中，将OGRE_RENDERER那一行设为true,如下：

OGRE_RENDERER = true

3。在新版的OGRE中增加了对boost的依赖，所以还需要配置一下boost。（修改CEGUI_EXTRA_PATHS的内容）

我这里是：

CEGUI_EXTRA_PATHS = {

     { "../boost_1_42", "", "lib", "CEGUIOgreRenderer" },

}

此时会发现CEGUI的solution中会多出一个CEGUIOgreRenderer的工程。并且，经过前面的配置，路径都已经配置好了。

这里有些惊喜的是，发现了irrlicht相关的东西，呵呵，将来也可以尝试，个人对irrlicht的简单易用也印象深刻，不知道在学了OGRE后，下次还有没有机会再次使用。

然后，编译就好了，会报一堆的警告。。。。。。。。。。。。。感觉这些代码写的都有问题。。。。。在公司的代码里面，经常是一句warning都不能有的，而且这些waring都是类型转换警告。。。。估计在某些时候肯定会有问题。。。暂时不管了。

事实上，最后还会有个错误，

LINK : fatal error LNK1104: cannot open file 'OgreMain_d.lib'

因为配置的时候好像不能分debug/release来配置，（前面的文档没有讲这一点，我也没有深究了。。。。也许有办法吧）而OGRE的lib目录事实上又分debug/release子目录的。。。。。所以，其实看起来蛮自动化的配置，最后还是少不了手动干预一下。

手动修改lib目录后，问题解决。

此时将编译出来的lib,dll都拷贝到OGRE的相关目录，（因为我不准备修改CEGUI，所以简单的就拷贝了，需要修改CEGUI的，可以直接修改CEGUI工程配置，设置为编译后拷贝到相应目录）就可以直接在OGRE中使用CEGUI了，只需要再配置工程的CEGUI include目录就好。

然后，当遇到过这么多坑以后，满以为总该顺利了。。。。。。事实上，还有一个大坑在前面等着你，在最新的CEGUI版本中，你会遇到“应用程序正常初始化（0xc0150002)失败”错误，而且不会给你任何头绪。。。。。其实我费了这么多劲，非要从源码编译CEGUI和OGRE，而不是使用各自的SDK，就是因为使用SDK的时候碰到这个问题了，从经验判断应该是库的编译版本不匹配的问题，结果我自己将所有的源码都编译了一次了，还是有问题。。。。。。。。。无奈之余，在网上搜索了一下，碰到这个问题的人还不是少数。

这个哥们描述的[背后的故事](<http://blog.csdn.net/yacper/archive/2010/05/19/5607450.aspx> "背后的故事")  
。。。。。还提供了hack解决方案，牛，可惜我是用VS2008的，VS2005那个补丁不适合我，运行安装不了，我也还是希望通过正常的补丁途径解决。而这个哥们提供了完善的[解决方案](<http://hi.baidu.com/hy469680890/blog/item/b1de7e24187d946c34a80f1f.html> "解决方案")  
。基本上，简单的说，VS2008的解决方案就是下载[正确的依赖文件VC90](<http://prdownloads.sourceforge.net/crayzedsgui/CEGUI-DEPS-0.7.x-r2-vc9.zip?download> "正确的依赖文件VC90")  
那个，或者直接下CEGUI SDK [VS2008的SDK](<http://prdownloads.sourceforge.net/crayzedsgui/CEGUI-SDK-0.7.2-vc9.zip?download> "VS2008的SDK")  
，只是千万不要下VC80任何相关的东西。。。。（我很郁闷MS竟然不让VS2008在这种程度上支持VS2005，起码也能够让任何VS2005编译的东西在VS2008得到直接的支持啊）然后为自己的VS2008打上SP1补丁，就好了。这个问题真的折腾了我挺久，希望大家不要再继续被折腾了。。。。。。。。。。。。。

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**
