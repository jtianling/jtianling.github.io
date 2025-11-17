---
layout: post
title: Irrlicht On IPhone
categories:
- iOS
- "图形技术"
- "游戏开发"
tags:
- Irrlicht
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '22'
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

主要参考来自于：http://www.ccloveaa.com/blog/article.asp?id=476  
<http://www.irrlicht3d.org/wiki/index.php?n=Main.IrrlichtEngineWiki>

<http://www.irrlicht3d.org/>

<http://irrlicht.sourceforge.net/>

1: Download irrlicht engine from: <http://irrlicht.svn.sourceforge.net/viewvc/irrlicht/branches/ogl-es/>  
  
2: Create a new window base iphone app, add include and source folder into the project. add include in the include search path in xcode.  
3: Add Foundation CoreGraphic OpenGLES QuartzCore UIKit framework in to the project.  
3.1: delete all the error file from project when you build the project  
4: Pass the UIWindow or UIView pointer to windowID, then Create a irrlicht device.  
5: Use irrlicht engine render scene. 

全文很简练，但是完全有效且使用，没有任何废话，按照步骤做就得了。  
只是没有想到会这么容易，毕竟，Irrlicht是没有官方支持IPhone的，当然，上面得地址是官方的IPhone branch，从某种角度来说，比起官方支持的OGRE来说，要编译一个可用的irrlicht还是复杂了很多，并且，很多基础组件都没有，这点，所有尝试的人都需要注意。  
假如你对Irrlicht很感兴趣，并且也对IPhone很感兴趣，那么就放心的尝试吧，比起你尝试装黑苹果的经历肯定要愉快的多。

首先，下载代码，解压，这些都不多说了，注意的是，需要自己新建工程，原工程太老太老，还是PPC的玩意儿，根本没有用，新建一个OpenGL ES的工程你会轻松很多，然后编译，肯定一堆错误，如上面所言，将所有报错的文件全部删了，另外，推荐通过irrcompile的config文件，关闭所有的d3d，并且完全删除libjpeg，我们不会用到，（事实上，主要是编译不过），然后去掉一堆irrlicht包含的第三方库的垃圾文件，比如readme,configure啦。。。。。。。

然后，链接，这个也不是太难，最主要的是，你需要注意，很多冲突的产生，原因都是因为很多第三方库（以bzip2最多）包含自己的Test程序，这些Test程序都包含有自己的main函数，这会与你自己的main函数冲突，全部删之，然后，恭喜你，你已经成功了！哈哈，没有想到这么简单是吗？

Irrlicht论坛中也有很多有用的资源：  
最有用的[thread](<http://irrlicht.sourceforge.net/phpBB2/viewtopic.php?t=34035&postdays=0&postorder=asc&highlight=iphone&start=15> "thread")  
:[Compiling irrlicht ogl-es branch for iphone (progress)](<http://irrlicht.sourceforge.net/phpBB2/viewtopic.php?t=34035&start=0&postdays=0&postorder=asc&highlight=iphone&sid=f64d658ce5b10fa638e7b63030184754>)  
  （事实上，按照thread中的说明一步一步来肯定能编过，并且成功，亲身实验）  
IPhone上的触摸响应:<http://www.rockfishnw.com/media/files/TouchEvents.zip>  
  
有用的Irrlicht在IPhone下的模版：http://www.mediafire.com/file/i1juyzy3mzz/iPhoneTemplateApp.zip   
  
  
有图有真相，下面贴个上面templateApp运行时的截图：

![](http://docs.google.com/File?id=dhn3dw87_101qnbfmpwh_b)

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**
