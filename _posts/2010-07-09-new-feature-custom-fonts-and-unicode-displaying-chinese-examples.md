---
layout: post
title: Orx1.2新添功能 自定义字体及Unicode 以中文显示为例
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
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

    在Orx1.2版本中新增了对Unicode和自定义字体的支持，至此，Orx可以支持中文的显示了。在"[Uni-code to rule them all?](<http://orx-project.org/component/content/article/1-orx/63-uni-code-to-rule-them-all>)  
"一文中作者有所提及。这可是主要就是为了中国用户才添加的功能，我自然需要大力支持罗。

    首先，由于1.2版本还未发布，（本来代码已经完成了，但是据作者描述，其显卡正好坏了，买新的显卡还没有到，需要新显卡做Linux和Windows版本）所以我使用的[SVN上](<http://orx.sourceforge.net/> "SVN上")  
的版本。

    另外，对于此功能，作者已经添加了新的[教程内容](<http://orx-project.org/wiki/en/orx/tutorials/standalone> "教程内容")  
，并且此教程已经有[中文版本](<http://orx-project.org/wiki/cn/orx/tutorials/standalone> "中文版本")  
了，欢迎大家查看学习。同时也在此感谢参与Orx WIKI翻译工作的全体兄弟。

    因为此教程，还是讲一些拉丁字符的显示，这里我依据教程内容，真正的完成中文的显示教程。不过最最郁闷的是，目前没有找到很好的支持中文的字体生成工具。也就是将汉字从TTF等格式转成点阵图的工具，这样的英文字体工具很多，但是没有找到合适的支持中文的工具。

    另外，处于效率考虑，一般的游戏引擎都是按照图片方式显示文字，这样可以与普通的游戏图片内容一起刷新，速度最快，Orx也一样。所以其实不直接支持TTF的文件的字体，而是支持图片格式的文字。

首先，我们看作者的教程10,用的图片：(因为作者用的是白色图片，为了能够显示出来，这里我进行了反色）

 ![](http://hi.csdn.net/attachment/201007/9/0_1278671539r8CD.gif)

使用方式在原来文字显示的基础上学习其实很简单：（原教程内容）

在 text字段添加Font，表示需要使用自定义的字体，Font的内容为自定义字体的配置段，并且与locale相关，最后是选择的语言配置段中的字体。

```ini
[Legend1Text]

String = $Content

Font   = $LocalizedFont
```

自定义的配置段内容如下：

```ini
[CustomFont]

Texture = ../../data/object/penguinattack.png

CharacterList = " !""#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}~�€�‚ƒ„…†‡ˆ‰Š‹Œ�Ž��‘’“”•–—˜™š›œ�žŸ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ"

CharacterSize = (19, 24, 0)
```

在Texture添加字体的图片，CharacterList添加字体图片对应的字符，CharacterSize是个vector，表示图片中每个字符的大小。就是这些新内容。 

原来iarwain完成的显示效果如下：

![](http://hi.csdn.net/attachment/201007/9/0_1278671553eX6H.gif)  

现在来看看汉字的使用方式，如法炮制，这里其实还有个问题，因为汉字比较特殊，没有办法像作者添加的ISO字符一样，都放在一个字体文件中，但是现在的Font可以根据locale来修改。

   因为没有找到合适的工具，(这是个问题，有人找到好工具了记得告诉我)，所以我自己用photoshop拼出了一个汉字的图片（借助一个在线的字体生成网 站）。。。。痛苦啊。

如下：

![](http://hi.csdn.net/attachment/201007/9/0_12786715722giy.gif)

然后就是改配置罗，

修改教程10的部分配置如下：  
  
  

E:/MyProgram/ClipboardHighlighterVersion0.2/Untitled.html

  
```ini
 1   
  
 2   
[Locale]  
  
 3   
LanguageList =  
 English # French # Spanish # German # Finnish # Swedish # Norwegian # Chinese  
 4   
  
 5   
[Chinese]  
  
 6   
Content =  
  这是囧ㄏㄨ的标志  
 7   
Lang    =  
  (Chinese)  
 8   
LocalizedFont =  
 ChineseCustomFont  
 9   
  
10   
[ChineseCustomFont]  
  
11   
Texture =  
  ../../data/object/CustomChineseFont.png  
12   
CharacterList =  
  "这是囧ㄏㄨ的标志"  
13   
CharacterSize =  
  (72, 72, 0)
```

一如既往的，我也帮iarwain强调一句，不用改一句代码，直接运行原来的教程时的程序即可看到显示效果：（注意按空格切换，切换过N多语言以后，就会看到中文了)

![](http://hi.csdn.net/attachment/201007/9/0_1278671588IDDl.gif)  

对于此例子来讲，几乎看不到使用字体的任何好处，因为每个汉字只显示了一次，但是换换字符内容就能知道好处了。

比如：  
  
```ini
[Chinese]  
  
Content =  
 囧ㄏㄨ的标志这是  
Lang    =  
 (Chinese)

LocalizedFont =  
 ChineseCustomFont
```

![](http://hi.csdn.net/attachment/201007/9/0_1278671603tiii.gif)

 

而且，因为没有合适的工具，我在Photoshop中做出来的图其实还是有问题的。。。。。。。后面的空太长，字切的不准。。。。同时，这也反映了教程中作者提出来的问题，所有的自定义字体必须是等宽字体（不然怎么切啊？）

