---
layout: post
title: 用Markdown + VimPress写博客
date: 2012-12-12
comments: true
categories: 随笔
tags: Markdown VimPress Vim LaTeX Wordpress
---

这次把CSDN的文章移过来的时候, 发生了格式混乱的不愉快体验.  虽然以前的那些文章有些很稚嫩, 早期的文章现在看来甚至很可笑, 但是, 这种记录还是很值得保留, 毕竟是成长的过程.  
整理一些文章格式的时候, 还发现一个有趣的故事, 原来我现在这么喜欢Vim, 来自于当时刚到北京, 用一个巨老无比的笔记本, 图形界面几乎没法用, 所以才无奈之下真正的耐下心来学习Vim, 见[**买了个新显示器**](http://www.jtianling.com/%E4%B9%B0%E4%BA%86%E4%B8%AA%E6%96%B0%E6%98%BE%E7%A4%BA%E5%99%A8.html).  而这已经是我第3次开始尝试使用Vim了, 从那以后, 我几乎没有Vim就没法工作了.  
闲话少说, 综上所述, 我决定好好的管理一下自己的博客, 虽然现在已经用上了自己可以控制的Wordpress, 但是谁知道将来会不会再发生忘记缴费, 数据被删的事情呢, 即使我用上了Wordpress的备份, 我还是需要给自己写的文章做一个自己的备份, 并且可以用Git来管理, 这个才叫真的备份, 连历史记录都备份了.  同时, 因为格式上的原因, 我决定用某种文本格式来保存我的文章, 当然, 我可不准备手写HTML, 这样才不会出现用Windows Live Write写博客那样的悲剧, 并且, 作为离线写博客的方式, 用Vim来处理文本就方便了, 不用再去找各个平台的啥离线工具.  

<!-- more -->

**目录**:

* TOC
{:toc}


说了一堆, 总结一下要求如下:

1.  文本格式, 并且较为方便直接写
2.  能转换到HTML并在Wordpress上发表, 格式不乱, 并且较为美观
3.  能用Vim来完成上述功能

另外, 特别推荐大家用文本格式写博客, 即使你可能不会像我一样用Vim, 因为文本格式代表你永远不会因为某个私有格式导致你无法再处理你的文章, 别像我过去一样沉迷于那些编辑工具的格式化方便等优点, (比如Windows Live Writer啥的)你绝对不值得用你可能在某一天不能编辑你的文章这个代价来获得.  这里正好看到一个MacWorld的文章[**Why plain text is best**](http://www.macworld.com/article/1161549/forget_fancy_formatting_why_plain_text_is_best.html)也讲了这个, 深合我意.  用一句话来表示文本格式的好处, 那就是

>It’s timeless.

事实上, 网上一搜, 已经有很多好的解决方案了, 其中最好的就是[Markdown](http://daringfireball.net/projects/markdown/) + vimpress插件的方案了. 

# 最佳方案: Markdown + VimPress
主要参考了[白莲居的一篇文章](http://blog.pkufranky.com/2011/11/%E4%BD%BF%E7%94%A8vim%E5%92%8Cmarkdown%E6%92%B0%E5%86%99blog%E5%B9%B6%E5%8F%91%E5%B8%83%E5%88%B0wordpress/),但是白莲居修改版本的Vimpress实在太老了,并且在新的Python-Markdown中,一些他添加的扩展已经直接内置了,不需要用扩展来写了,所以我自己fork了一个最新版本的插件,然后添加了新的toc mark和codehilite,其实,在新的Python-Markdown中,fence方式的代码标记都已经内置了,但是我总觉的不如codehilite方便和美观.需要的去[Github](https://github.com/jtianling/VimRepress)下新的吧.再就是我没有用白莲居的代码高亮, 黑色背景的代码高亮感觉在我的博客主题里面不够和谐.  自己通过pygmentize生成css的方法见[pygments的quickstart](http://pygments.org/docs/quickstart/)

~~~ bash
$ pygmentize -S default -f html > style.css
~~~

其中的default就是你想要生成css的pygmentize style.  可以用的style直接用

~~~ bash
$ pygmentize -L
~~~

可以到[这里](http://pygments.org/demo/27323/?style=default)看各个style的效果.

关于Markdown, 提供一些参考资料:

* [官网](http://daringfireball.net/projects/markdown/)
* [WIKI](http://zh.wikipedia.org/zh/Markdown)
* [中文说明](http://wowubuntu.com/markdown/)

本文就是用这个方法完成, 在转换成HTML后, 效果还算满意, 最为重要的是, Markdown格式容易书写, 就算是原文, 与格式有关的东西较少, 以内容为主, 这是与写HTML和Latex等格式的最大优点.  值得一提的是, 现在Github和Stackoverflow的文本输入格式就是支持的Markdown格式.  这么说的话, 作为程序员, 学会Markdown几乎是必要的了.  
另外, 在实际的使用过程中, 发现VimPress插件还是有些问题,有的时候`:BlogOpen`会把原来的博客当作HTML取回来, 推荐大家还是自己备份原始格式最保险.  

# 适合将来转PDF的方案: Latex
其实我最开始想用LaTeX来写博客, 虽然的确有些麻烦, 但是的确可以更加精确的控制格式, 然后效果会更加好, 特别是将来能更好的转化为PDF.  那个效果, 就像是印刷出来的一样.  还可以使用了一个同样使用pygments实现代码高亮的LaTeX package, [Minted](http://code.google.com/p/minted/).
用[MacLex](http://www.tug.org/mactex/), 然后再将pdf转换为HTML[pdf2htmlEX](http://coolwanglu.github.com/pdf2htmlEX/), 我也查过一些直接从Latex转换为HTML的软件, 最好的是[HyperLaTeX](http://hyperlatex.sourceforge.net/)和[tth](http://hutchinson.belmont.ma.us/tth/).  但是都不能支持Latex的全部功能, 特别是其他的package, 用起来和Markdown也就没啥区别了.  优点用不上, 又那么麻烦, 所以还是用Markdown是最佳方案吧.
