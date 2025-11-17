---
layout: post
title: "数据/配置 的存储方式 Json篇 以Cocos2D For Iphone+TouchJson为例"
categories:
- iOS
- "游戏开发"
tags:
- Cocos2D
- Json
- TouchJson
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '24'
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

## 前言

配置的好处，JSon介绍,及为什么要使用Json都参看原来[JsonCpp篇](<http://www.jtianling.com/archive/2010/07/22/5754179.aspx> "JsonCpp篇")  
的内容。本文仅针对TouchJson稍微进行一些讲解。

 

## [Cocos2D For IPhone](<http://www.cocos2d-iphone.org/> "Cocos2D For IPhone")  
\+ [TouchJson](<http://code.google.com/p/touchcode/> "TouchJson")  

    Cocos2D For IPhone是我见过的开源2D引擎中特性最完备的一个，即使速度上不算最快的。因为其只支持IPhone平台，所以能够在这个平台上做的很出众，现在新版的Cocos2D For IPhone已经支持iOS4和IPhone4，其工程模板的安装使用也是非常方便。新版甚至将原来的LGPL协议改为现在的MIT协议了，使用更加灵活自由。。。。  
    TouchJson的使用属于不想在一个比较完全的Objective C环境中添加C++代码，(事实上使用Box2D的话还是避免不了）所以不使用JsonCpp来配合Cocos2D，何况Cocos2D的模板工程中本来就带有TouchJson了，将其删掉再插进JsonCpp也太不人道了。。。。呵呵。另外，因为TouchJson用Objective C完成，解析后也是个NSDictionary的对象所以与Objecitve C的对象组合使用会更加自然一些，使用苹果并为苹果开发，我是几乎已经习惯一整套都是用apple平台专有的东西了，唉。。。。对比当年简单的因为C#完全掌握在MS手中而不想学习，这也算是一种悲哀，因为Objective C比C#更加封闭，而且，起码C#还是这个世界上语法最漂亮，最先进语言的代表。

首先，利用Cocos2D的模板，创建一个新的工程，此时默认的效果是显示一个Hello World。如下：

![](http://docs.google.com/File?id=dhn3dw87_170gt76qjcf_b)

这里，我们就不用其他图了，看看怎么配置这个Hello World。

最最基础的流程：  
建立一个Json文件，仅仅有两行配置，一行表示显示的文字，一行表示文字的旋转  
**{**  
  
  
  "text"  
  : "Don't Hello World"  
,  
   "rotation"  
 : 20  
**}**  
  
  
  
然后将此Json文件放入工程的Resources目录，我这里命名为picture.json。

然后可以开始着手解析这个Json文件了。  
整个解析过程又分几步，首先，#import "CJSONDeserializer.h"  
然后，获取到编译打包后在Resources目录文件的位置：  
NSString *path  = [[NSBundle mainBundle]pathForResource:@"picture" ofType:@"json"];

获取文件路径后，从文件中读取数据：  
NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:path];

获取文件数据后，解析Json文件：  
// Parse JSON results with TouchJSON.  It converts it into a dictionary.  
CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];  
NSError *error = nil;  
NSDictionary *jsonDict = [jsonDeserializer deserializeAsDictionary:jsonData error:&error];  
if (error) {  
//handle Error, didn't have here.  
}  
  
  
此时jsonDict保存的就是解析后的Json数据了。  
（以上代码都添加在HelloWorldScene的init中）

下面来看使用：  
首先，text改变HelloWorld显示的文字：  
    NSString *text = [jsonDict valueForKey:@"text"];  
        // create and initialize a Label  
        CCLabel* label = [CCLabel labelWithString:text fontName:@"Marker Felt" fontSize:64];  
这里就已经是cocoa中NSDictionary  
怎么使用的问题了。

然后，rotation改变旋转：  
    NSNumber *rotation = [jsonDict valueForKey:@"rotation"];  
    NSAssert(rotation, @"Didn't have a key named rotation");  
    label.rotation = [rotation floatValue];

一切就绪，看效果：

![](http://docs.google.com/File?id=dhn3dw87_171fjxsccd5_b)

上面的流程已经基本完整了，作为补充，还是添加一个Json数组使用的例子。  
在TouchJson中，作者不推荐将根对象设定为数组([参见这里](<http://stackoverflow.com/questions/288412/deserializing-a-complex-json-result-array-of-dictionaries-with-touchjson> "参见这里")  
，TouchJson的作者自己说的），事实上也就不那么做就好了。我们随便用一个key来指定这个数组即可。  
所以，定义Json文件如下：  
  
**{**  
  
  
  "result"  
 :  
  **[**  
  
  
    **{**  
  
  
      "text"  
  : "Don't Hello World"  
,

      "rotation"  
 : 20

    **}**  
  
,  
    **{**  
  
  
      "text"  
  : "Just Hello World"  
,  
      "rotation"  
 : -20  
    **}**  
  
  
  **]**  
  
  
**}**  

然后，读取的时候还是先读取出一个NSDictionary对象，但是我们随后从中取出数组：  
NSArray *dictArray = [jsonDict valueForKey:@"result"];

然后再遍历数组，此时数组中的每个对象又是NSDictionary对象  
  
for (NSDictionary *dict in dictArray) {}

此时获取到NSDictionary的对象就与原来的字典对象很像了，直接通过valueForKey取对应的配置使用即可。较完整的循环代码如下：  
  
    for (NSDictionary *dict in dictArray) {  
      NSString *text = [dict valueForKey:@"text"];  
      // create and initialize a Label  
      CCLabel* label = [CCLabel labelWithString:text fontName:@"Marker Felt" fontSize:64];  
        
      NSNumber *rotation = [dict valueForKey:@"rotation"];  
      NSAssert(rotation, @"Didn't have a key named rotation");  
      label.rotation = [rotation floatValue];  
        
      // ask director the the window size  
      CGSize size = [[CCDirector sharedDirector] winSize];  
        
      // position the label on the center of the screen  
      label.position =  ccp( size.width /2 , size.height/2 );  
        
      // add the label as a child to this Layer  
      [self addChild: label];  
    }  
  
此时可以看到同时显示多个文字的效果：

![](http://docs.google.com/File?id=dhn3dw87_172xvbt8wwt_b)

小结：  
在使用了JsonCpp和TouchJson后，可以发现由于Json的数据结构主要就是一个Key:Value的映射加数组，所以无论在C++中还是在Objective C中，总是能用语言的原生结构很好的表示，（在C++中是map，在Objective C中是NSDictionary和NSArray）所以使用会非常方便，对比XML的强大并且复杂，简单的Json在保持概念非常简单的情况下完成了配置任务。

 

 

 

 

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**
