---
layout: post
title: "入门有余, 经典不足 -- 小评《C#入门经典》"
date: 2013-01-11
comments: true
categories: 编程
tags: C# C#入门经典
---
 
鉴于[*C#程序设计语言*][]这本Anders写的书就像是语言规格说明, 我推荐大家阅读[*C#入门经典*][](Beginning Visual C# 2010)入门.  说实话, 看到这本书的时候, 我稍微叹了口气, 起码比那本厚如砖头的[*JAVA编程思想*][]要薄啊.  另外, 其实只需要阅读第一部分, 一共才390面.  就能大概的了解C#的全貌.  相对比[*C程序设计语言*]的200来面似乎要多, 但的确可以接受. 

关于书本身, 因为我以前也只阅读了关于C#的那一部分, 所以仅对这一部分进行评价.  
<!-- more -->

# 书的名字
我得说书的名字绝对是国内编辑最混蛋的地方, 书原名*Beginning Visual C# 2010*, 从这个角度来说

1. 本书不是一本纯粹关于C#的书, 而是包含了C#的各种应用情景, .Net库, 甚至还有VS2010的一些使用方法.
2. 原名没有任何概念提到*经典*二字, 这纯粹是国内编辑为了宣传加的title.

所以说, 假如你真的仅仅按*C#入门*这个词来期待本书的话, 会相当有问题.  因为本书关于C#的部分相当简略, 决定了本书只适于以前有编程经验的人, 假如你从来没有接触过编程, 决定把C#作为你的第一门语言, 我很怀疑怎么看的懂.  因为本书很多地方一个概念一个示例一笔带过, 就算是以我的角度来看, 本书的采编都过于简略了.  
而对于有经验的程序员来说, 这种较为简略的方式是合适的, 因为只需阅读不到400面就能了解C#, 相对于你去啃[*JAVA编程思想*][]要好的多.(我深有体会)但是本书又讲了一堆是个程序员就知道的概念(特别是面向部分), 最不可以接受的是弄了一堆的VS的截图来教你怎么用VS... 以前我有个经验, 一本讲程序的书, 截图越多越垃圾, 这个经验几乎还没有错过.  更何况, 本书是讲C#语言的, 和VS有什么关系? 我用的是mono呢?  但是, 看看书的原名, 我就知道, 其实这不是作者的问题, 因为本书就是讲Visual C# 2010的啊.  

# 对代码的示例方式不佳
一个语法格式通过实例来说明是最好的, 本书在这部分有些不太统一, 有些是通过一两句针对当前讲述的语法的实例,  有些又是通过`<>`形式的代指来说明语法, 这种格式有些正式有余, 易读性太差, 我看过后基本还是需要到例子中去才能明白格式到底是怎么样的.  而此时的例子(往往是唯一的)又经常太长, 找不到我要看的重点.  我认为这是本书最大的硬伤.  
比如说在可选参数这一节(原书370面)

> 如上一节所述, 方法定义了一个可选参数, 其语法如下所示:
> `<parameterType> <parameterName> = <defaultValue>`

就这么简单的一行, 不着边际, 理解就算了, 可选参数你怎么也放到函数的上下文中去吧.

# 理论讲解和代码有些脱离
书中可能是为了针对入门这个概念, 讲了一些理论, 特别是讲解面向对象那一部分.  可是讲理论的时候文字较为详细, 一行C#代码都不给, 然后再另起章节, 重新讲解理论, 此时再加代码, 感觉有些重复和没有必要.  类似的脱节还体现在*C#语言的改进*一节, 既然是入门, 我何必关心哪些是C#最新的改进, 管他是C#2还是C#3加的特性, 统一在前面分类的地方讲解会好的多.

# 小结
在我提及的定位下(即你已经有编程经验), 想要大概的学习C#, 本书还是基本OK的.  但是实话实说, 还算不上经典.  [C程序设计语言*][]那才能称为经典, 当然, 我买书的时候仅仅是因为在[亚马逊搜索C#](http://www.amazon.cn/s/?_encoding=UTF8&camp=536&creative=3132&field-keywords=C%23&linkCode=ur2&tag=jtianlinsblog-23&url=search-alias%3Daps), 本书排名第一.  

我阅读的版本:  
[![C#入门经典](/public/images/2013/Beginning.Visual.C%23.2010.jpg)](http://www.amazon.cn/gp/product/B004EPZ43A/ref=as_li_ss_tl?ie=UTF8&camp=536&creative=3132&creativeASIN=B004EPZ43A&linkCode=as2&tag=jtianlinsblog-23)


[*C程序设计语言*]: http://www.amazon.cn/gp/product/B0011425T8/ref=as_li_ss_tl?ie=UTF8&tag=jtianlinsblog-23&linkCode=as2&camp=536&creative=3132&creativeASIN=B0011425T8
[*C#入门经典*]: http://www.amazon.cn/gp/product/B004EPZ43A/ref=as_li_ss_tl?ie=UTF8&camp=536&creative=3132&creativeASIN=B004EPZ43A&linkCode=as2&tag=jtianlinsblog-23
[*C#程序设计语言*]: http://www.amazon.cn/gp/product/B005FOV7IK/ref=as_li_ss_tl?ie=UTF8&tag=jtianlinsblog-23&linkCode=as2&camp=536&creative=3132&creativeASIN=B005FOV7IK 
[*JAVA编程思想*]: http://www.amazon.cn/gp/product/B0011F7WU4/ref=as_li_ss_tl?ie=UTF8&camp=536&creative=3132&creativeASIN=B0011F7WU4&linkCode=as2&tag=jtianlinsblog-23
