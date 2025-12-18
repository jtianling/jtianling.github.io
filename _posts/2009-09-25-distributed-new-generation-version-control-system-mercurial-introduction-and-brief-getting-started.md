---
layout: post
title: "分布式的，新一代版本控制系统Mercurial的介绍及简要入门"
categories:
- "未分类"
tags:
- Mercurial
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '16'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

分布式的，新一代版本控制系统Mercurial的介绍及简要入门

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)

[讨论新闻组及文件](<http://groups.google.com/group/jiutianfile/>)

在经历了《[**版本控制系统（ RCS）的选择与比较**](<http://www.jtianling.com/archive/2009/09/23/4582457.aspx>)》后，选择了Mercurial下面给大家介绍一下Mercurial。

# 一、   提要

本文以假设你已经了解基本的版本控制系统知识，知道诸如库，历史，提交等常见的概念，本文简要的说明了在Windows/Linux下的可用安装版本，在Google Code上建库，管理，修改，提交，取回的过程，基本上仅是平时开发需要的最基础的一些功能。（连merge都没有说）因为要掌握任何可用的版本管理系统的全部功能都是一个复杂的系统过程，本文并不期望能包含全部内容，仅仅希望作为一个对Mercurial的介绍及入门引导，并不对基本的版本控制概念进行过多的描述。想要进一步学习Mercurial的可以参考最后的参考资料，个人比较推荐用《[Mercurial 使用教程](<http://mercurial.selenic.com/wiki/ChineseTutorial>)》入门，然后需要的时候可以查看《[Mercurial: The Definitive Guide](<http://hgbook.red-bean.com/>)》。

 

# 二、   介绍

Mercurial与一般传统的版本控制系统的最大区别在于分布式的概念。所谓分布式，就是指没有一个所谓的集中的中心（central）库，这个库一般由svn server(svn)，vss administrator(vss)控制，而Mercurial就没有这样的一个库，所以使用版本控制的时候甚至都不需要一个administrator和server，本地直接建库，直接就使用，任何一个库都可以作为中心库，每个库在Mercurial看来都是平等的。当然，实际使用的时候，可以人为的去指定一个中心库以作为发布，但是，这里强调的是Mercurial本身不关心这个，对它来说都是一样的。Linus他在演讲的时候多次说集中式的版本控制系统没有前途，因此，Subversion的开发者想要开发一个更好的CVS其实是脑子出了毛病-_-!呵呵，实际上，他虽然说得比较过，但是分布式的版本控制的确是比集中式有很多优点。

首先，分布式最大的好处就是离线工作，不仅意味着可以不联网就享受版本控制的好处，并且也意味着普通的提交速度也要快的多，而且，以此带来的巨大灵活性甚至能改变你的工作方式，因为以前集中式的版本控制系统，每次提交都会影响到他人，以至于不能提交未经测试的版本，而使用分布式的版本控制系统时，你可以随时随地的本地提交，安全的保护自己的工作成果，以防意外，也能随时随地的本地clone，本地分支，本地就是一套完整的版本控制系统！直到修改到最终版本，然后才push（相当于集中式版本控制的commit）到真正的一个公用库上去。想到那当年作为一个新员工，每次提交代码都需要请示总监的日子。。。。那是多么痛苦的啊。。。。

其次，对于个人开发者来说，使用集中式版本控制系统的时候有没有想过，仅仅是一个人工作，为啥偏要建立一个中心库，然后每次将自己的代码提交到那上面去啊？自己本地一个副本，库还得有一个副本，也不环保嘛。呵呵，甚至，我以前还为此专门架设了自己的VSS服务和SVN服务器-_-!而用分布式的版本控制系统就没有那么麻烦了，本地建库，直接使用就好了^^只有用过后才知道原来一切都那么简单。。。。。。。。。。。。。并且，当你哪天想要将工作成果share出去的时候，也不麻烦，还是一条普通的push命令，就像远方的服务器一直搭建好了一样。

但是，其实目前来说，分布式的版本控制系统还是有一定缺陷的，比如权限控制的问题，这点可能因为Mercurial的用户群主要在于开源世界，所以没有太过重视，实际上对企业开发可能会比较重要，相对来说SVN,特别是VSS就要好的多。但是，事实上通过外部的手段进行权限的控制还是可行的（比如ssh的登录），只不过相对来说会复杂一点，这也算是个小缺陷了（可大可小）。然后Mercurial相比Git还有个缺点，那就是分支的时候不能对单独的子目录进行，一次clone就是一个工程，这样希望在一个大工程中对一个小项目进行分支，会比较麻烦，这点也算是比较大的缺点了，但是，上述缺点都不是分布式版本控制固有的，仅仅是目前Mercurial的实现的问题，相对来说，分布式和集中式这样工作方式上的区别才是最主要的，毕竟Mercurial还年轻，希望Mercurial将来的实现会更好^^

 

# 三、   安装

## 1.      Windows

Windows可使用的版本有3种，首先是官方的版本：[http://mercurial.berkwood.com/](<http://mercurial.berkwood.com/>) ，最新版是1.3.1：

2009-08-08: [Mercurial 1.3.1](<http://mercurial.berkwood.com/binaries/Mercurial-1.3.1.exe>) \- **_Release version_**

其次是可爱的乌龟，不过不叫TortoiseMercurial，而是Tortoisehg(因为Mercurial在命令行的命令是HG，不会有人喜欢Mercurial这样长的命令吧-_-！)，在[http://bitbucket.org/tortoisehg/stable/wiki/download](<http://bitbucket.org/tortoisehg/stable/wiki/download>)，找到下载地址，最新版是[0.8.2](<http://bitbucket.org/tortoisehg/stable/downloads/TortoiseHg-0.8.2-hg-1.3.1-1444a42f6052.exe>) ，此外，此网址还有个中文的注册表文件[zh_CN](<http://bitbucket.org/tortoisehg/stable/raw/stable/win32/thg-cmenu-zh_CN.reg>)可以下，下载后直接打开，可以使的右键菜单的语言编程中文（但是设置中的语言还是E文，为了统一，建议还是用E文的比较好） (BTW:乌龟真是版本控制之王啊。。。。。。。。。从CVS到SVN到Mercurial到Git是无所不包啊。。。。。。)

最后，假如仅仅是使用VS工作的话，也有VS的集成版本，叫[Mercurial SCC Package](<http://www.newsupaplex.pp.ru/hgscc_news_eng.html>)，在[http://www.newsupaplex.pp.ru/hgscc_news_eng.html](<http://www.newsupaplex.pp.ru/hgscc_news_eng.html>)有最新的版本下载。

要说明的是，Mercurial遵循的是典型的Unix风格，即自己只做命令行功能，图形界面留给了别人做，所以官方版本仅仅只有命令行功能，TortoiseHg是在Windows下较好的一种，这里向大家推荐一下。实际上安装完TortoiseHg后，已经包含了完整的官方版本，毕竟，TortoiseHg仅仅是Mercurial的一个GUI前端而已。下载后，安装的流程就不多说了，无非就是下一步。。。。不会的话也不会想要使用这个软件了。（安装后，想使用中文的就再打开上面的中文菜单注册表文件。）      再然后，就可以在右键中看到菜单。

 

## 2.      Linux

对于官方版本来说，Ubuntu下利用

apt-get install mercurial

就行

Redhat就用yum吧，都有可用版本。不过在我的kubuntu9.04上安装的是1.01版本，实在太老了。

而TortoiseHg在Linux也可用（事实上，仔细观察一下Windows版本的TortoiseHg就知道，其实它本质上是个GTK程序-_-!）

在[http://bitbucket.org/tortoisehg/stable/wiki/download](<http://bitbucket.org/tortoisehg/stable/wiki/download>)还是能找到下载的地方：

**Linux**

Debian packages are coming soon.

Ubuntu packages can be found at: <https://launchpad.net/~maxb/+archive/ppa> or <https://launchpad.net/~tortoisehg-ppa>

Fedora RPM packages:

  * [0.8.2 - x86](<http://bitbucket.org/tortoisehg/stable/downloads/tortoisehg-0.8.2-1.i686.rpm>)
  * [nautilus 0.8.2 - x86](<http://bitbucket.org/tortoisehg/stable/downloads/tortoisehg-nautilus-0.8.2-1.i686.rpm>)
  * [0.8.2 - x64](<http://bitbucket.org/tortoisehg/stable/downloads/tortoisehg-0.8.2-1.x86_64.rpm>)
  * [nautilus 0.8.2 - x64](<http://bitbucket.org/tortoisehg/stable/downloads/tortoisehg-nautilus-0.8.2-1.x86_64.rpm>)

If no package yet exists for your platform, then use the source install method described on the **[hgtk](<http://bitbucket.org/tortoisehg/stable/wiki/hgtk>)** page. Note that we do not suggest that you run from a tarball, even though we make one available for download. We prefer you use a local clone of TortoiseHg instead. If you do decide to use a tarball, you'll want to delete thgutil/config.py* to remove the hard-coded paths.

To use the settings tool on Linux, you must have <http://code.google.com/p/iniparse/> installed.

不翻译了，这里说明一下。。。。。launchpad是出品ubuntu的公司建立的一个源代码host，上述链接上有介绍使用方法，基本上如同普通的程序一样，通过apt-get获取key,然后修改apt-get在/etc/apt/下的source.list,添加进新的ppa的源（有3个），然后通过apt-get update更新一下源的信息，就可以直接通过apt-get install tortoisehg来下载了，这时下载的mercurial会是最新的1.3版本，而不是原来的1.01老版了。

我用的是kubuntu，没有用tortoisehg，因为那样要安装一整套的gtk库，用gnome的人就幸福了^^唉。。。这也是当年选择了Qt的后遗症啊。。。。。。。。。。

 

## 3.      Eclipse

Eclipse由于是Windows,Linux通用的，所谓单独放在这里了，呵呵，JAVA程序的这个优点还是挺吸引人的，说到这里感叹一下，JAVA程序员哪能理解学习了CreateProcess然后重新学习fork,execxxx，学习了CreateThread，然后学习pthread_create的痛苦啊。。。。。呵呵，这些都是题外话。另外，eclipse插件的管理，你得首先安装对应的原始官方版本。。。

Eclipse插件：[http://www.vectrace.com/mercurialeclipse/](<http://www.vectrace.com/mercurialeclipse/>)

 

## 4.      检验安装

首先检验已经安装成功，可以查看一下官方的版本

Windows下：

```bash
E:/work>hg version

Mercurial Distributed SCM (version 1.3.1+1444a42f6052)

Copyright (C) 2005-2009 Matt Mackall <mpm@selenic.com> and others

This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

Linux下：

```bash
jtianling@jtianling-laptop:~$ hg version

分布式软件配置管理工具 \- 水银 (版本 1.3.1)

版权所有 (C) 2005-2009 Matt Mackall <mpm@selenic.com> 和其他人。

这是自由软件，具体参见版权条款。这里没有任何担保，甚至没有适合
特定目的的隐含的担保。
```

呵呵,在通过ppa那个链接安装了新版后，竟然版权信息是中文的。。。。并且,Mercurial翻译成了水银，这点比较让人吐血。事实上Mercurial表示墨丘利。。。。。也就是希腊神话中的赫尔墨斯（Hermes）。。。。。。

见WIKI的说明：

**墨丘利**(**Mercurius**)是[罗马神话](<http://zh.wikipedia.org/zh-cn/%E7%BD%97%E9%A9%AC%E7%A5%9E%E8%AF%9D> "罗马神话")中为众神传递信息的使者，相对应于希腊神话的[赫耳墨斯](<http://zh.wikipedia.org/zh-cn/%E8%B5%AB%E8%80%B3%E5%A2%A8%E6%96%AF> "赫耳墨斯")（Hermes）。他的形象一般是头戴一顶插有双翅的帽子，脚穿飞行鞋，手握魔杖，行走如飞。墨丘利是[裘比特](<http://zh.wikipedia.org/zh-cn/%E8%A3%98%E6%AF%94%E7%89%B9> "裘比特")和[玛亚](<http://zh.wikipedia.org/zh-cn/%E7%8E%9B%E4%BA%9A> "玛亚")的儿子，是医药、旅行者、商人和小偷的保护神，西方药店经常用他的缠绕两条蛇的手杖作为标志。

此外，由于[水星](<http://zh.wikipedia.org/zh-cn/%E6%B0%B4%E6%98%9F> "水星")在天上运行的速度很快，所以亦用了他的名字而命名。

怎么说。。。。。。。。。。。我都觉得Matt Mackall原意是指墨丘利吧-_-!又扯远了。。。。。

 

说明安装成功。。。。。。。。。。。。。

 

# 四、   简要使用说明

因为在Windows下和在Linux下使用Mercurial是类似的（命令行嘛，能差别大到哪去），这里以Windows下的使用为例，之所以使用Windows为例而不是用Linux因为我用的是Word2007编辑所以复制结果比较方便，之所以用Word2007是因为拷贝到IE中的CSDN blog编辑框中比较方便，之所以用IE是因为CSDN blog对Firefox的支持不好。。。。。。。。这里抱怨一下-_*!。。。。。

下面的小标题括号中的英文即是对应的Mercurial命令。

## 1.      帮助(help)

从上面的检验安装方法可以看出来，Mercurial的命令是Hg。

首先，因为我不能将所有的命令都讲完，所以先告诉大家怎么用帮助^^，我果然很取巧-_-!

Mercurial有内建的帮助系统，参数是help，help后还可以以需要查询的命令为参数。

比如：

```bash
E:/work>hg help init

hg init [-e CMD] [--remotecmd CMD] [DEST]

create a new repository in the given directory

    Initialize a new repository in the given directory. If the given
    directory does not exist, it will be created.

    If no directory is given, the current directory is used.

    It is possible to specify an ssh:// URL as the destination.
    See 'hg help urls' for more information.

options:

 -e --ssh        specify ssh command to use
    --remotecmd  specify hg command to run on the remote side

use "hg -v help init" to show global options
```

## 2.      建库(init)

上面的帮助内容，懂E文的的就看懂了，init就是Mercurial的建库命令，使用方法如此简单。比如我希望在E:/Work/Hello下建立一个我自己的库，只需要在e:/Work/Hello目录输入hg init如下：

```bash
E:/work/hello>hg init

E:/work/hello>
```

事实上，你看不到任何输出，但是通过dir查看的时候会发现多出的.hg目录(在Linux因为是“.”开头，默认是隐藏的)，而Windows下没有这个规矩，所以还是会显示出来。想起一个笑话，以前有个牛人说，为啥.Net叫.Net？因为在Linux下甚至都不会显示出来^^

这个时候一个你自己的Mercurial库就建好了：）

 

## 3.      克隆(clone)

事实上，我机器上还是保留了svn，因为我可以很方便的在sourceforge和Google code上下载别人的代码-_-！用的是svn co命令，事实上，大部分人用的最多的也就是这个命令了^^，在mercurial上将svn和VSS的checkout代码命令叫做克隆（clone），事实上也体现了不同的版本控制系统的管理哲学。集中库吗，需要的是检出(checkout)然后迁入(commit)，而分布式呢，因为就没有集中库的概念，你需要做的是在一个人为指定的集中库上克隆一份，你自己的库也就是与服务器上的库一样的库（克隆的概念^^）

首先看下帮助，（这里只贴上了第一行）：

```bash
E:/work>hg help clone

hg clone [OPTION]... SOURCE [DEST]
```

即hg clone 源 目标

       比如，以后我准备将代码都放在Google Code上共享，而Google Code对Mercurial原生支持（哈雷路亚），所以，大家可以直接通过clone命令去随意克隆我的代码，我的博客sample代码存放的Mercurial的地址是

`[https://blog-sample-code.jtianling.googlecode.com/hg/](<https://blog-sample-code.jtianling.googlecode.com/hg/>)```

那么大家只需要通过如下命令就能下载回去我所有的Sample代码：（当然，Mercurial要是已经安装好的，并且在你想要下载的位置执行下列命令（`[google推荐的用法](<http://code.google.com/p/jtianling/source/checkout?repo=blog-sample-code>)``）`

hg clone https://blog-sample-code.jtianling.googlecode.com/hg/ jtianling-blog-sample-code

这样，就将我所有的blog sample代码全部clone到当前目录的jtianling-blog-sample-code目录下了。

如下所示：

```bash
E:/work/jtianling-blog-sample-code>dir/w

 驱动器 E 中的卷是 文档
 卷的序列号是 940C-1FF8
 E:/work/jtianling-blog-sample-code 的目录
 [.]         [..]        [.hg]       [2009-9-25]

               0 个文件              0 字节
               4 个目录  3,043,004,416 可用字节

E:/work/jtianling-blog-sample-code>
```

目前仅仅有在E:/work/jtianling-blog-sample-code/2009-9-25/helloMercurial下添加进去的一个文本，helloMercurial.txt。

好了，仅仅想学会怎么用Mercurial去享用别人代码的人可以放心的走了，一切很简单吧：）

 

## 4.      本地提交（commit）

Mercurial也有commit，不过这里的commit与VSS,SVN中的不同，这里的commit仅仅提交到本地，所以题目特意强调了一下，是本地的提交，这再一次的体现了命令反应哲学的问题^^。在Mercuria里面，你可以放心的commit，因为不会影响到别人。

比如，刚才我clone回来的文本helloMercurial.txt内容是：

```text
Hello World
To Test Mercruail and Google Code

Create By JTianLing
```

我将其修改一下

```text
Hello World
To Test Mercruail and Google Code
And Test Commit

Create By JTianLing
```

然后提交，命令如下：

```bash
E:/work/jtianling-blog-sample-code>hg commit
```

这个时候，在Windows下，直接弹出的是默认的文本编辑工具，我这里是记事本，有如下提示信息：

```bash
HG: Enter commit message.  Lines beginning with 'HG:' are removed.
HG: Leave message empty to abort commit.
HG: --
HG: user: JTianLing
HG: branch 'default'
HG: changed 2009-9-25/helloMercurial/helloMercurial.txt
```

告诉你输入提交的message，没有的话是会终止提交的，这也体现了一种好的软件版本管理哲学，每次提交都强制性的要求有说明的，VSS中由于可以忽略说明，所以事实上，我们公司是没有任何人提交带说明的，然后呢？碰到问题的时候就靠喊贝，反正在一个公司-_-!这里，我加入一行：

Add a Line to Test commit command

然后保存退出。这时候提交就已经完成了。

 

## 5.      记录(log)

怎么确认提交完成没有，怎么查看版本历史，用log命令，执行效果如下：

```bash
E:/work/jtianling-blog-sample-code>hg log

changeset:   1:88252aa4d260
tag:         tip
user:        JTianLing
date:        Fri Sep 25 12:27:01 2009 +0800
summary:     Add a Line to Test commit command

changeset:   0:baf69ca9684e
user:        JTianLing
date:        Fri Sep 25 12:00:01 2009 +0800
summary:     Create Project Blog


E:/work/jtianling-blog-sample-code>
```

 

可以看到我说明的Add a Line to Test commit command版本已经commit了。但是这个时候其实是不影响google上的任何东西的啊：）google上该是啥还是啥。

 

## 6.      版本同步（push,pull）

当我真的需要将修改提交到服务器上怎么做呢？用push（推）出去自己的版本：）事实上，这还是牵涉到版本管理哲学的问题，因为google code上host的那个库在Mercurial看来也就是一个普通的库，没有什么特殊的，你仅仅是将自己的库强行推给它，将它的库修改而已。同理，当你想要放弃修改，需要做的就是将google code上的库pull（拉）回来。比如，我想同步修改google code上我的那个文本。

命令及输出如下：

```bash
E:/work/jtianling-blog-sample-code>hg push https://blog-sample-code.jtianling.googlecode.com/hg/

pushing to https://blog-sample-code.jtianling.googlecode.com/hg/
searching for changes
http authorization required
realm: Google Code Mercurial Repository
user: JTianLing
password:
Success.
```

当然，在google code上push是需要用户名和密码的，完成后显示Success，然后你再去clone的时候会发现内容已经变了。

这里我们确认一下，通过下面的命令，我们再clone一份放到jtianling-blog-sample-code2目录中去。

```bash
E:/work>hg clone https://blog-sample-code.jtianling.googlecode.com/hg/ jtianling-blog-sample-code2

requesting all changes
adding changesets
adding manifests
adding file changes
added 2 changesets with 2 changes to 1 files
updating working directory
1 files updated, 0 files merged, 0 files removed, 0 files unresolved

E:/work>
```

这里，会发现输出的信息也与第一次看到的不同了，这里已经有两个changesets了，需要说明的是Mercurial是基于changesets管理的版本控制系统与git基于内容管理（snapshot）管理的方式不同。在Mercurial中，一个系统就是通过一个一个changesets累加起来的。

这里，可以看到新的内容了（按照本文的说明，你下的时候就已经是新的内容了）

 

# 五、   小结

事实上Mercurial的命令远不止这一些，详细的内容还是那句话，希望大家可以查看教程《[Mercurial 使用教程](<http://mercurial.selenic.com/wiki/ChineseTutorial>)》与《[Mercurial: The Definitive Guide](<http://hgbook.red-bean.com/>)》，一篇小文，难以承载那么多东西，呵呵，何况，也没有必要做太多前人已经做好的工作。《[Mercurial 使用教程](<http://mercurial.selenic.com/wiki/ChineseTutorial>)》作为入门非常不错，并且还是中文的，推荐给大家。而且，我说的都是命令行下面的操作，但是，事实上命令行都懂了，图形操作就更不用说了，主要的是理解这些命令对应的分布式版本控制管理概念就好。

我写此文的目的其实主要是因为以后会将blog中的sample代码都放在上述示例的那个工程中，而我会使用Mercurial，为了不需要每次都向大家解释怎么样才能用Mercurial clone回代码，特别写此文简单的介绍一下。

 

# 六、   参考资料：

需要详细了解Mercurial的话，这里有几篇非常好的教程

1.  《[Mercurial: The Definitive Guide](<http://hgbook.red-bean.com/>)》，By Bryan O'Sullivan。最好的Mercurial教程，就是篇幅巨大

2.  《[A tutorial on using Mercurial](<http://mercurial.selenic.com/wiki/Tutorial>)》，官方推荐的一个教程E文版

3.  《[Mercurial 使用教程](<http://mercurial.selenic.com/wiki/ChineseTutorial>)》，上面那个教程的中文版，！推荐！

4.  《[Mercurial快速入门](<http://mercurial.selenic.com/wiki/ChineseQuickStart>)》,一个中文的快速入门教程，事实上仅仅翻译了标题-_-!

5.  《[Mercurial manual](<http://www.selenic.com/mercurial/hg.1.html>) 》，作者就是Mercurial的作者。

 

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**