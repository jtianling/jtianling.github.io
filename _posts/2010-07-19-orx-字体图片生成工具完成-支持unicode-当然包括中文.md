---
layout: post
title: Orx 字体图片生成工具完成 支持unicode，当然包括中文
categories:
- "游戏开发"
tags:
- Orx
- Unicode
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
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

## 工具产生的历史

    很正常又让非英语/拉丁语国家恼怒的事情就是，绝大多数的美国/欧洲人编写的软件从来没有考虑到世界上还有用其他语言的人，在以前，可以说是编码上考虑多语言难度比较大，为了简单才这样，但是在使用Unicode编码已经如此简单的时候，还是有很多软件的作者从来没有考虑过这个世界上还有用其他语言的人。作为非英语国家，甚至连拉丁语系都不是的国家，而且还拥有者世界上最复杂最多字符语言(之一)的中国受害最深，但是，情况正在改善。

    当iarwain因为Orx的中国使用者越来越多，开始为Orx加入了custom font和unicode支持的时候，他碰到了很大的问题，现在能够找到的字体图片生成工具就没有一个很好的支持Unicode的。（或者工具本身就不够好）我也尝试了几款，有很多很酷的字体工具，但是，很遗憾的，最多的支持也就是拉丁语系。于是iarwain决定自己写一个这样的工具。

    勤奋的iarwain让我印象深刻，整个周末都在忙着完成这个字体生成工具。从蒙特利尔时间晚上两点，iarwain完成第一版，因为stb_truetype的一些问题，导致一些字体的中文标点显示不正常，一直到蒙特利尔时间第二天早上7点半，iarwain将工具完整的迁移到更加稳定强大的freetype2上，我测试过新的工具，完整，可用，不知道还有谁会在工作之余如此的拼命，也许只有code for fun才能这样吧，我只能说I服了you了。

    事实上，虽然iarwain是为了Orx写了这样一个工具，但是，如我所言，现在网络上很难找到一个类似的支持unicode的字体图片生成工具，所以这样的工具其实填补了很大的空白，因为其开源，所以应该可以被其他任何游戏引擎所借鉴和使用。因为，显示一个自定义字体的原理都是一样的，事实上，为了高效的完成字体的显示，原理也只能是这样。当然，对于需要完整字库（比如需要聊天功能的网游）的游戏，这样的原理可能并不适用。假如还有什么不足的话，那就是这个工具目前仅仅是完成了文字到字体图片的转换功能，还不能添加更多很炫很酷的效果。

## 工具介绍

    这里，介绍一下新的工具。[下载地址](<http://sourceforge.net/projects/orx/files/orx/orx%20-%201.2%20%281984%29/orx-tools-1.2.zip/download>)  
。

    也能从Orx的SVN中获取。SVN地址：`https://orx.svn.sourceforge.net/svnroot/orx。`

    工具是个命令行工具。

    使用方法：

    orxFontGen.exe -s "字体大小" -f "字体文件名" -o “生成对象名" -t "输入的所有文字"

比如，我希望使用微软雅黑，来完成上面一段工具的历史的输出。我首先将上述文字保存成一个文件，这里命名为toolHistroy.txt，（需要特别注意的是，保存的文字一定要用utf-8进行编码，这点可以用notepad++或者ultraEditor之类的工具进行。并将其拷贝到工具所在的目录。然后将微软雅黑的字体文件msyh.ttf(从windows/fonts目录）拷贝到工具所在的目录。我希望将生成的对象命名为msyhFont，于是，我用下列命令执行工具：

orxFontGen.exe -s 32 -f msyh.ttf -o msyhFont -t toolHistory.txt

然后，我们得到两个东西，其一，4通道的tag文件。

![](http://hi.csdn.net/attachment/201007/18/0_1279469328zsv1.gif)

 

其实这个图片可以被任何支持类似文字显示的引擎使用。

其二，一段Orx的配置。

[msyhFont]

CharacterList = " ()/27IOU_abcdefimnoprstuwxy。一丁上不且世两个中为么义之也了事二于些产人什仅从他以件任会似但体何余作使候借假入其具写决况几利到刻前功加勤半单印历原又受只可史吧周命和善因国图在填复多够大天奋好如始字完定实害家导将尔尝就工己已常应度开引强当很忙怒恼情憾戏成我或所才找拉拥拼持换擎支改效数整文新早时是显晚更最有服末本杂来果标样欧款正此比没洲测深添游源炫点然片版特现理甚生用界白的目直着知码碰示移稳空符第简类系经络绝编网美考者而能自至致英蒙虑虽补被言让许试话该语说谁象越足身转软较迁过还这连道遗那都酷鉴问间难非题高（），"

CharacterSize = (32, 32, 0)

Texture = msyhFont.tga

如此，显示这段文字，那就是很简单的事情了。（因为窗口大小问题，只显示了上面文字中的一段）  
![](http://hi.csdn.net/attachment/201007/18/0_1279469483OzMo.gif)  

另外，很明显可以看到一点，虽然文字本身生成的时候是白色的，但是，可以由Orx的定点色进行颜色的改变。

对于还不知道怎么使用Orx显示文字的，可以参考Orx的[教程](<http://orx-project.org/wiki/cn/orx/tutorials/standalone> "教程")  
，或者我[以前的文章](<http://www.jtianling.com/archive/2010/07/09/5724112.aspx> "以前的文章")  
。 

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**
