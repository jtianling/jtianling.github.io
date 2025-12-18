---
layout: post
title: "寻找最佳的数据存储方式"
categories:
- "游戏开发"
tags:
- "数据存储"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '15'
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

游戏中总是有很多相关的数据需要存储,比如编辑器产生的关卡数据,人物,物品属性的配置等等,并且现在已经不是每人都设计一种自己数据格式的时代了.程序员们是越来越懒,大家都想着一套文件格式,一套解析,处理代码能够通吃所有的程序.以下讨论,包括优缺点,都仅仅是对于游戏数据(还仅指编辑的数据)存储而言,以下都省略此前提背景,其他领域的使用本文仅供参考,游戏领域的使用本文也仅是一家之言,当然也仅供参考.  
首先,看看传统的数据存储解决方案.

## 传统数据存储解决方案

### EXCEL方案

最大的优点是几乎人人都会更改并且可以更改而不用进一步的学习.干这行的,别说策划,即使是文秘应该起码也会EXCEL吧?  
缺点,需要自己写一大堆的Excel解析代码,这点是无奈的.  
并且,假如不想每个Excel文件都写一套解析代码的话,你就要想好一种通用,并且扩展性良好的Excel编写格式,这也不是太容易的.  
即使设计的Excel格式扩展性足够好,当数据慢慢复杂的时候,你会发现,事情越来越复杂.....几乎就开始将Excel做关联数据库使用了.有的时候,通过改动一些关联性很强的Excel数据来完成某个功能,甚至比你通过代码改变来实现还要复杂.....到那个时候,你才会发现,Excel已经不敷使用.  
最最重要的是,Excel(起码03版的是这样)是二进制数据,SVN,mercurial等版本控制工具(偏偏这就是大家项目中所用的吧)不支持merge,这样,每次多人更改,必然导致冲突,然后,手工再去痛苦的重写吧.  
但是,假如你碰到像我们公司说的这种,翻译组只懂使用Excel,那么你再痛苦,也就无奈去吧.这也是Excel的优点吧........当然,从程序的角度来看,那是最大的缺点.

### 数据库方案

数据库方案最大的优点是扩展性异常强大,数据库方案的扩展性几乎是无限的,无论多么庞大的数据量,放在数据库中总是不会显得很多,关联表格也总是能将冗余数据降到最低,并且,如此的清晰.由于现代数据库前端做的越来越好,修改数据库中的数据也不总是需要SQL语句了.最最重要的是,当你需要的时候,你还是能用SQL语句来实现你需要的最最复杂的查询,或者批量修改某些相关的数据.  
当然了,没有方案是完美的,用数据库方案,的确强大,但是也有强大的代价,首先,项目中得有数据库专家,能够设计足够好的表格,及写出复杂的多重嵌套SELECT语句,项目中得有人懂得使用各自语言自己的数据库接口API,并且比较郁闷的是,各种数据库的API设计还不太一样......通用的API设计往往是以低效率为代价的....当然,这些都扯远了,扯上了原来做服务器的经验了........假如仅仅将数据库作为普通游戏数据存储的方式,缺点还没有那么夸张,并且,我们总是可以使用mySQL,SQLLite这样的开源解决方案.在各类语言中也总是有可用的相应的API可用.  
除了上面那些,还有个问题,即使仅仅将数据库作为普通游戏数据存储的方式,为每个需求设计一套表,写一堆的从数据库中获取数据的代码,并且,最要要是以二进制数据发布的话,你还得写一套从数据库中读数据,然后序列化成二进制数据的代码,然后,额外的,解析二进制的代码也不可少.强大的数据库解决是以庞大的人工代码量堆积起来的.

## 现代数据存储解决方案 

因为传统解决方案有着其天生的缺点,Excel对于越来越大的游戏,越来越多的游戏数据有些吃力,而是用数据库方案对于光是保存游戏数据(仅指编辑数据,不包括网游的运行时数据)又显得太过臃肿.那我们有没有更好的方法呢?先看看我们想要什么样的方案:  
1.有着文本存储的方式,便于开发期调试和修改,也能直观的查看到改变和开发期的版本控制merge.  
2.有二进制存储方式,在发布后可以使用这样的方式,减少parse时间,并且,从文本方式切换到二进制方式是有很简单解决方案的.  
3.parse,序列化的代码编写要足够的简单,起码不会随着数据量的扩大而扩大到难以掌握的地步.  
4.多语言支持,你总能在你喜欢的语言中使用  
5.在数据之间建立关联,嵌套关系要足够的简单,这样才能简单的表示丰富的内容,而不是通过另外再建一套数据来表示关联(就像在Excel中需要做的那样)

有方案能满足上面所有的需求吗?可以寻找一下.  
因为我能力有限,这里仅举较为常用的XML,JSON,Google Protobuf为例,作为比较,也作为自己选择最佳方式的参考.(在查找资料的过程过还发现了一个名叫Thrift的解决方案,[有文章](<http://blog.mirthlab.com/2009/06/01/thrift-vs-protocol-bufffers-vs-json/> "有文章")  
的比较指出其比Google Protobuf要强大较多,因为使用较少,我不准备尝试,在此提供此信息,仅供参考)

### XML方案

现在游戏数据中XML方案应用的应该算是非常广泛了,几乎算是事实上的工业标准?起码我的感受是这样,甚至于,Office 2007以后的通用格式都是XML化的了.是因为网页开发的太过流行,导致大家都喜欢上了尖括号横生的标记语言了吗?我不知道.但是,XML的确有其优点.在WIKI百科上,有这么一段描述:  
As of 2009[[update]](<http://en.wikipedia.org/w/index.php?title=XML&action=edit>)  
  
, hundreds of XML-based languages have been developed,[[5]](<http://en.wikipedia.org/wiki/XML#cite_note-Cover_pages_list-4>)  
  
including [RSS](<http://en.wikipedia.org/wiki/RSS> "RSS")  
, [Atom](<http://en.wikipedia.org/wiki/Atom_%28standard%29> "Atom<br />
\(standard\)")  
, [SOAP](<http://en.wikipedia.org/wiki/SOAP> "SOAP")  
, and [XHTML](<http://en.wikipedia.org/wiki/XHTML> "XHTML")  
. XML-based formats have become the default for most office-productivity tools, including [Microsoft Office](<http://en.wikipedia.org/wiki/Microsoft_Office> "Microsoft<br />
Office")  
([Office Open XML](<http://en.wikipedia.org/wiki/Office_Open_XML> "Office Open<br />
XML")  
), [OpenOffice.org](<http://en.wikipedia.org/wiki/OpenOffice.org> "OpenOffice.org")  
([OpenDocument](<http://en.wikipedia.org/wiki/OpenDocument> "OpenDocument")  
), and [Apple](<http://en.wikipedia.org/wiki/Apple_Computer> "Apple<br />
Computer")  
's [iWork](<http://en.wikipedia.org/wiki/IWork> "IWork")  
.[[6]](<http://en.wikipedia.org/wiki/XML#cite_note-5>)  
  
  
看看吧,应用的还真不少.  
首先,上述5点需求的需求1,3,4,5是较为完美的满足的.XML是写给人看的数据存储格式,虽然喜欢尖括号的人(比如我)会反感,并且因为其流行,解析XML的库也是非常丰富,各类语言对XML的支持肯定少不了,XML对于嵌套,关联的支持也是非常好的,其自描述性,能让你看到XML就能知道,它在描述什么.XML的处理都是字符串,支持unicode, wikipedia上还提供了一个有意思的例子:

```xml
version
="1.0"
encoding
="UTF-8"
?>


<烏語>

Китайська мова>

中国人写的?-_-!
```

另外,有一点也很重要,XML是可扩展的,添加新的XML属性完全不影响原有的解析及代码的运行,直到你真的需要这个属性,然后再添加处理代码即可.  
但是,XML有个致命的缺点,一堆类似HTML的标记,根本就不是设计给人来写的,(当然,好用的工具另外),在阅读的时候,很显然,废数据也过多,那么,存储,传输的时候,(假如传输的真是文本的话)同样的,信噪比太低,这点我不是太喜欢.当然,最主要的是直接写XML比较麻烦.也许有强大的工具能解决此问题,但是鉴于我们公司的制度,那可能是可望而不可及的事情.  

### [JSON](<http://www.json.org/> "JSON")  
方案

上述5点需求的需求1,3,4,5可以得到比XML更完美的满足.得益于简单的格式,所以解析及创建都可以做的很简单的,特别是JSONCPP这个库,在使用的时候简直就像获取到JS中的Object一样,直接通过[]操作完成索引及建立操作,使用起来感觉非常爽,并且,也有XML有的可扩展性,相对来说,比起以前使用LUA做配置而言,JSON会更加简单,当然,功能也稍微弱一些,不用逻辑处理(到脚本层次)的时候,我个人认为JSON就是最合适的数据存储格式.当然,从数据处理的速度来说,可能还需要一个从JSON到二进制的转换工具,(XML也有类似问题),然后在发布期完全使用二进制.  
目前有点问题的就是,JSON的格式没有XML那么规范,所以常常会容易写错,然后自己还没有感觉,JSONCPP使用了MAP的特性,也就是说,使用方便,但是当[]查找不到的时候,是默认建立了空的索引,这会带来一些混乱.....  
在我们的项目中,使用JSON来配置界面,为UI的灵活性提供了很大的方便,并因此节省了无数代码及编译时间,此时我想起一句LUA之父说的话,只有当配置足够灵活,人们才会使用它,的确如此,当JSON的使用如此方便的时候,使用配置,而不是代码,那是享受,而不是痛苦.

另外,XML与JSON方案还有个好处,因为他们的通用性,各个项目之间的沟通也会更加简单,与人解释XML,JSON在干什么,比与人解释自己的二进制文 件在干什么要简单的多.也因为沟通更加简单,使得在通用格式上面的那一层代码也能得到更多的复用机会.甚至,我们考虑过使用其他项目中创造的用JSON实现的关键帧动画.........

### [Google Protobuf](<http://code.google.com/p/protobuf/> "Google Protobuf")  
方案

用的不多,试用了一下,谈下感想,Google在说明文档中说Google内部使用时,所有的进程间他通行,一律要求使用Google Protobuf,也可见其自有其强大之处.使用方式上与上述两个方案有比较大的不同,XML与JSON仅仅是描述数据,单纯的数据,解析的代码还是需要自己去写(尽管JSON的解析已经非常简单了)但是Google Protobuf不同,其要我们编写的是结构描述文档,并且通过其附带的工具,直接生成C++,JAVA,Python的代码(也就是Google内部使用的3语言,与我们公司完全一致),至此,不仅解析简单了,甚至结构都有了,我们需要做的是直接调用结构的接口去完成输入输出,所有的数据的getter都通过Google规定的方式进行了命名.甚至,直接将结构打包成2进制数据然后发送了.(也就是Google在文档中所描述的进程间通信).比起XML,JSon而言,此方案最大的优势在于速度,它有很好的文本格式以及二进制格式,可以很方便的切换(原生就支持),这也是3个方案中唯一满足了需求2的方案.(事实上,完全满足上述所有需求)但是,很明显的,有个缺点,(实在是没有实际使用,仅仅是通过试用感觉的),假如结构变换的话,可能得重新使用Google提供的工具,重新生成结构,这就需要重新编译代码,这是个较大的问题.................其他的,个人感觉,Google Protobuf是非常不错的解决方案,特别是用在需要进程间通信时(比如需要进行网络通信,连打包的代码都省了).

最后的总结是,未来的趋势应该是[JSON](<http://www.json.org/> "JSON")  
方案吧,[Google Protobuf](<http://code.google.com/p/protobuf/> "Google<br />
 Protobuf")  
方案更适合需要网络通信的情况,毕竟还需要通过工具生成代码,使用的方便性来说不如JSON.

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**