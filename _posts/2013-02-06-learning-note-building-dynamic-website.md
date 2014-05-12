---
layout: post
title: "学习笔记: 哈佛大学公开课--构建动态网站"
date: 2013-01-11
comments: true
categories: 编程
tags: JavaScript PHP 网页开发 HTML 学习笔记
---

以前都是自己看书自学, 以前倒是也看过一些视频, 总觉得节奏太慢, 进度太慢, 看了一个多小时, 感觉还不如自己看书一个多小时, 所以也没有坚持看过, 这次决定尝试一下, 一方面因为最近一直在学习, 决定用公开课的视频学习来缓一下自己的节奏, 也当作休息.  
另外一方面就是最近在家时间挺充裕的, 还考虑到过年的时候, 可能不一定能快节奏, 高效率的学习.  
BTW: 因为是课程笔记, 所以其实有些无聊, 个人感觉有用的部分就是老师推荐的那些库和工具.  
<!-- more -->

# 课程介绍
首先看的是最近有些兴趣的课题, 网页开发, 选择的是[*哈佛大学公开课：构建动态网站*](http://v.163.com/special/opencourse/buildingdynamicwebsites.html)这个课程,  顺面赞一下网易开发[网易公开课](http://open.163.com/)的诚意, 特别是提供了下载服务.  另外又需要吐槽一下网易提供的下载服务体验让人崩溃, 所有的视频都是毫无意义的随机字符串, 让批量下载就是噩梦, 为啥不能提供好的打包下载服务?  就算没有, 我通过下载软件的批量下载实现, 你的文件名也实在是没法用啊.  
本课程由哈佛大学David J. Malan主讲, 项目主页是<http://cs75.tv/2010/fall>. 主题前面提过, 是构建动态网站.  
看完后会很奇怪, 大学怎么会教这么项目型的课程呢? 起码我大学是从来没有学过.   

# 第0课
主要是关于一些网站的搭建的基础知识, 泛泛而谈, 包括DNS解析啥的, 提供了几个服务, 推荐了一些开发需要库等.  

## 网页开发需要的服务
课程推荐的是比如域名注册的Godaddy(我正在用), 网页托管的dreamhost, 虚拟服务器的linode(用过)等.  
域名注册使用Godaddy没有问题, 只是Godaddy的DNS在中国不太好用, 需要借助Dnspod等服务. 
关于主机, 我个人倒是推荐使用云主机, 比如国内的[阿里云](http://www.aliyun.com/cps/rebate?from_uid=SFlGFGgnGCUPZAw/x5S1OJFP+2CQ7Z3w)和国外的amazon ec2, 不过, linode也算是不错的选择了.  

## 网页开发相关的工具
课程提到了Firefox的FireBug, 这是网页开发的神器.  

## 网页开发推荐的库
Yahoo! UI Library (YUI)  

* YUI Reset CSS http://developer.yahoo.com/yui/reset/  
* YUI Fonts CSS http://developer.yahoo.com/yui/fonts/  

## HTML验证
<http://validator.w3.org>
顺面说一句, 用这个来验证我的博客主页, 竟然得到了28个错误, 1个警告...

# 第1课 PHP
开始的时候老师提问关于HTTP Header中Host作用问题, 一帮哈佛的学生竟然没有一个人回答上, 竟然还有人回答CNAME的事情, 上节课还讲了, 这是解决同一主机托管多个域名的情况好不...

## 建议的开发工具
课程提供了一些有用的Firefox插件.  有些不合主题啊, 不是讲PHP吗?  

* Firebug
* JavaScript Debugger
* Live HTTP Header
* ShowIP
* Web Developer
* YSlow

## Apache服务器配置
因为鼓捣过很多次了, 所以没有觉得学到啥.  这也是看类似公开课这种视频(包括上课本身)的一个坏处, 老师不能知道你真的知道什么, 不知道什么, 不过, 还好, 我不是真的上课, 我看的是视频, 所以能通过拖动进度条来实现忽略...  
提高到了XAMPP则个类LAMP/WAMP的套件, 简单的说就是一下子安装好Apache, MySQL, PHP环境的软件包, 不过我个人还是喜欢重头装, 这样将来自己增加新的内容, 比如Ruby on Rails时更加方便一些.  这就要看是否能折腾了.  
  
提到了[suphp](http://www.suphp.org/Home.html), 当多人共享服务器的时候, 可以用自己的用户来执行PHP, 使得你可以讲你的PHP代码权限设置的更加严格, 因为我用的阿里云或者amazon ec2这种云服务, 没有这种需求.  

## PHP
而课程的这一课虽然叫做PHP, 但是实际上仅仅讲了PHP怎么内嵌在HTML中, 除此以外, 没有讲任何东西.  

1. 我当时看的是[*PHP和MySQL Web开发*][]这本书, 一般都是用`if() { }`的语法, 也知道`if xxx: endif`的语法, 看了视频才发现, 后一种语法在嵌入大量HTML的时候, 的确要更加舒服.  
2. 课程中老师犯了一个很大的错误, 那就是button的type用的是`"button"`, 搞了半天, 才发现应该用的是`"submit"`.  
3. post的好处是不会计入日志, 并且不更改网址, 比get稍微更加保密一些, 同时, 长度没有限制.  
4. 通过`isset()`来判断一个值是否存在.  
5. 一段有用的代码:

    :::html+php
    <?php
       error_reporting(E_ALL);
       ini_set("display_errors", TRUE);
    ?>

# 第2课 PHP续
都3,4周了, 一上来还在谈project 0的事情, 搞个域名搞这么久, 哈佛的那帮哥们似乎也有拖延症啊, 都忙着创业去了?  

## XML
有意思的是, 课上似乎有人问该怎么选择XML和PHP, 逼得老师要重新说明, 这两个根本就不是一回事... 可以当作笑话来听.  

## SSL
SSL的作用本身是用来加密的, 问题是双方要加密需要通过第三方的认可, 也就是那些发SSL证书的机构认可, 我有些不明白是怎么回事, 为什么需要呢?  我没有明白为什么HTTP的世界发展成现在这个样子了, 一方面域名被人掌握, 需要交钱, 而这本身是公共资源啊? 要想在服务器与前端用户之间加密数据, 还得付钱...  
课程在SSL的问题上面讲了很久, 但是我还是觉得有些奇怪, SSL的本意是想让发证机构作为证书拥有方的一种身份认证, 假如有问题的话就可以注销证书.  但是假如我不需要身份认证, 仅仅是想实现加密的通信呢? 似乎没有这种办法.  
突然想到一个问题, 作为外行, 很想有人能解释一下, 为什么12306需要额外下载证书? 舍不得购买SSL证书吗? 就我的感觉, 12306的证书也仅仅只具有加密的作用而已.  

## PHP
又是很奇怪的一节课, 虽然名为PHP, 但是讲到PHP的内容其实还是很少, 主要就是用登录的例子作为实例来讲解了一些相关的概念, 这节课主要的内容估计就以下这么一些:  

1. `$_SERVER`是个有很多信息的系统全局变量.  比如host信息.  
2. PHP可以在header标签前面使用`<?php session_start(); ?>`以初始化系统的全局变量`$_SESSION`, 这是一个关联数组, 用于存放用户的内容, 并且, 通过`session_start()`的调用, 保证针对每个用户都能取回正确的`$_SESSION`.  
3. 通过`header()`可以实现重定向.  

全部的内容可以归结为以下三个文件:

登录输入页面: login.php

    :::html+php
    <?php session_start(); ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
       <meta charset="UTF-8">
       <title></title>
    </head>
    <body>
       <div align="center">
          <form action="logined.php" method="post">
          name:
          <input name="username" type="text" />
          <br />
          passworld:
          <input name="password" type="password" />
          <br />
          <input name="submit" type="submit" value="login" />
       </form>
       </div>
    </body>
    </html>

登录验证页面: logined.php

    :::html+php
    <?php
       session_start();

       define("USERNAME", "user");
       define("PASSWORD", "pass");

       if (isset($_POST["username"]) && isset($_POST["password"])) {
          $host = $_SERVER["HTTP_HOST"];
          header("Location: http://$host/index.php");
          if ($_POST["username"] == USERNAME && $_POST["password"] == PASSWORD) {
             $_SESSION["authenticated"] = TRUE;
             exit;
          }
          else {
             exit;
          }
       }
    ?>

登录结果通知页面: index.php

    :::html+php
    <?php session_start(); ?>
    <!DOCTYPE html>
    <html>
       <head>
          <title>Home Page</title>
       </head>
       <body>
          <div align="center">
             <?php if (isset($_SESSION["authenticated"])): ?>
             OK, You are logged in!
             <?php else: ?>   
             NO, You are not logged in!
             <?php endif; ?>
          </div>
    </body>
    </html>

# 第3课 XML
课程中讲到XML可以作为普通的配置和简单情况下数据库的替代, 不过具体的XML语法讲的很少, 只有几点:  

1. PCDATA用于保存可能包含有特殊字符的文本字段, 比如一段javascript代码.  
2. CDATA用于保存不想被XML解析器解析的文本字段, 比如在XML保存一段HTML.  
3. PHP将来将不允许使用`<? >`的短记号格式, 要求使用`<?php ?>`的完整记号.  其中的一个原因是(?! 真是吗?)XML的首行声明就是用`<?`开始的.  有
4. 把一个DTD东西当作XML的东西来讲了, `<!ENTITY nbsp "$#160;">`可以作为类似编程中的宏替换.  
5. 提到了一个有趣的话题, 那就是XML中一个配置, 到底是用Attribute还是Element.  老师的解释是推荐使用配置, 因为配置在解析后更加容易获取.   顺面吐槽下, 正是因为XML有这么多乱七八糟的概念, 才使得XML没有Json好用, 并且也难以直接对应到一个语言的原生类型中.  很久前看过一些大部头的文章来描述这个问题, 比如这里就有一篇: [*何时使用元素，何时使用属性*](http://www.ibm.com/developerworks/cn/xml/x-eleatt/)
6. 提到XML, 就不得不提SAX和DOM两种解析方式, 一种是回调式, 一种是解析完后通过tree访问, 一般而言, SAX速度更快, DOM使用更加方便.  顺面一提, 我认为C++的XML解析库[RapidXML](http://rapidxml.sourceforge.net/)兼具两者之长.  
7. 提到数据类型的时候, 老师也对XML进行了吐槽: "XML是出了名的啰嗦."(XML is known for its verbose.)~_~  
8. 老师第N次对PHP函数名太长吐槽, "很不幸, PHP的函数命名很拖泥带水, 说真的, 没有哪个语言像它这样的, PHP总有这些冗长的带 下划线的函数名.".  

## XML in PHP
然后是, 全部的课最后价值的也就是最后一部分, 实际也就是稍微讲解了一下怎么用PHP来解析XML.  
比较具有实际应用思维的是,(也是课程的亮点) 最后演示了用PHP解析RSS, 而RSS本身就是一个XML.  有意思的是老师说RSS的规范文档就保存在教室对面的哈佛法学院...  
不管怎么说, PHP对XML的处理我突然想到一个以前没有想到的事情, 在讲PHP的第一课, 老师说用一个函数就能把XML转换为Tree或者Hash结构, 然后当作原生的类型使用, 这个我当时很好奇, 因为之所以Json现在能在很大程度上替代XML, 就是因为Json的格式能够方便的被转换为Hash, 数组等原生类型, 而XML不行, XML的结构过于复杂, 诸如兄弟节点, Element, Atrribute字段等信息, 很难通过原生的类型实现, 所以XML的库解析一般都是提供一套的函数来实现, 这决定了Json使用方便, XML使用麻烦.  
但是, 不得不说, XML的SimpleXML库为这个问题做了一个很不错的设计, 那就是用操作符重载来解决, 使得问题变得稍微不那么难堪.  
比如, 在稍微古老一点的语言中(比如RapidXML in C++), XML的解析一般是通过使用first_node, next_node方式的迭代,  first_node(name)的方式查找, 对于属性使用的是first_attribute, next_attribute方式的迭代, 使用first_attribute(name)的方式查找属性,  而在PHP的SimpleXML中, 是通过`[]`这种类似关联数组的方式来获取Attribute, 使用`->`符号这种类似获取对象属性的方式来获得子节点, 不得不说, 要比一般的XML库要来的简单, 清晰并且符合直觉.  
当然, 这仅仅是在简单的情况下, 稍微复杂点的情况, 你还是不得不回到老路上, 这也是XML本身过于复杂(对于简单情况来说)的问题.  

# 第4课 SQL

## XPATH
首先讲了一些XPATH的东西, XPATH是一个XML的标准查询语法, 用来抓网页的时候用过很多, 因为相对熟悉, 我直接跳过了.  

## CSV
比XML, Json还要简单的一种数据交换格式, 用`,`分隔, 用的也比较多, 因为熟悉, 也直接跳过了.  

## PhpMyAdmin
MySQL管理的神器, 基本上安装服务器后, 必装的东西, 用的也太多了, 跳过了.  

## SQL
1. Varchar和Char类型的选择, Varchar为变长, 需要包含长度信息, Char为固定长度.  
2. Varchar的上线为65535, TEXT就没有限制, 虽然课程中没有讲, 就我的印象TEXT有个坏处在于没法索引, 不过老师讲到一个好处是可以全文索引.(还真没有用过, 做游戏的人好悲哀啊)
3. MySQL的引擎有很多种, 分别是MyISAM(高效, 不支持事务), InnoDB(支持事务), MEMORY(放在内存中, 搜索速度快)
4. mysql_real_escape_string函数, 用于防止SQL注入攻击.  又一次, 老师提到了PHP超长的函数名.

# 第5课 SQL续
嘿, 换了首席助教来讲课, 原来的老师呢?  

1. Mysql的[PASSWORD](http://dev.mysql.com/doc/refman/5.6/en/password-hashing.html)函数可以讲密码简单的HASH化.  
2. 用`SELECT 1 ...`的形式可以实现当有数据存在时返回1, 即单行单列, 并且值为1, 没有匹配时, 返回空.  挺有用.  
3. 除了PASSWORD可以进行简单的加密外, 还能使用[AES_ENCRYPT](https://dev.mysql.com/doc/refman/5.6/en/encryption-functions.html#function_aes-encrypt)和AES_DECRYPT实现AES加密.  老师讲到一个除使用固定密钥外的一个更强的加密手段, 那就是直接用密码作为密钥, 这样, 密码是对的时候, 总是能正确, 密码不对的时候, 也无法通过获得一个固定密钥来解密.   
4. 对于自增id做主键的表, 一般不要删除行, 使用字段标记.   
5. 讲了一些SQL语法, 没有太大兴趣.  
6. Transaction(事务)可以方便的实现原子操作, 这个在一些时候很重要, 老师举的账户交易的例子非常好, 这在游戏中就很常见.  我记得我刚工作那会儿MySQL都不支持这个, 只有在诸如MS SQL Server中才能使用这个特性.  

# 第6课 JavaScript
oh, JavaScript, 应该能稍微有点意思了吧.  

1. javascript需要操作DOM的时候, 可以通过放在网页的最后实现, 还能通过`window.onload`函数回调实现.  
2. 提取javascript到文件中的利弊, 可以缓存, 加快以后的加载缓解, 缓存后, 假如文件有更新, 这就是个问题, 另外还增加了HTTP的REQUEST次数.  使得第一次访问会更加慢.  
3. `focus`是个大家都忽略的有用方式, 以减少用户多点击鼠标.   
4. 表单属性的name, 最方便被JavaScript调用.  
5. disable可以很方便的禁用元素, 用于验证输入虽然很方便,  但是需要谨慎使用, 因为用户可能以为有问题.  
6. 页面的`visibility`属性和`display`属性的区别在于, 切换`visibility`属性仅仅是不显示, 切换`display`的话, 占位都没有了.  
7. `window.setInterval`可以很方便的实现定时器.  
8. [*YUI Event Utility*](http://yuilibrary.com/yui/docs/event/). 

## javascript库
有用的javascript库:  后面是老师的一些评论.    

*  [Dojo](http://dojotoolkit.org/)  -- 文档不好  
*  [ExtJS](http://extjs.com/)  -- 文档非常好, 甚至有些完整过头, 导致一开始不好学.  
*  [jQuery](http://jquery.com/) -- 最流行的库, 提供了很多有用的工具, 但是没有ExtJS和YUI丰富.  
*  [MooTools](http://mootools.net/) -- 也很流行, 只是没有那么丰富.  
*  [Prototype](http://www.prototypejs.org/) -- 流行一时, 还提供了[script.aculo.us](http://script.aculo.us/)这个演示网站.  
*  [YUI](http://developer.yahoo.com/yui/) -- 太啰嗦(老师用的版本可能很老了, 新版本好多了, 同时也体现了老师说的正确)  

最后, 依次推荐了jQuery, ExtJS, YUI.  

## 有用的工具

* [Quirks](http://www.quirksmode.org/js/contents.html) 用于寻找一些极端罕见的例子.  
* [jslint](http://www.jslint.com) 用于代码的静态检验.  


## 压缩工具

* [JSMin](http://javascript.crockford.com/jsmin.html)
* [packer](http://dean.edwards.name/packer)
* [ShrinkSafe](http://dojotoolkit.org/docs/shrinksafe)
* [YUI Compressor](http://developer.yahoo.com/yui/compressor)

# 第7课 Ajax
又是首席助教-_-!
这节课可以说是前面所有课的综合, 用到了前面提到的几乎所有技术.  今天我才知道, 原来Ajax还是微软发明, IE最先实现的.  

## Dom参考

* [HTML DOM Reference](http://www.w3schools.com/htmldom/dom_reference.asp)
* [DOM Reference](http://www.javascriptkit.com/domref/)
* [DOM objects and methods](http://www.howtocreate.co.uk/tutorials/javascript/domstructure/)

## XMLHttpRequest Object参考

* [XMLHttpRequest Object (from MSDN)](http://msdn2.microsoft.com/en-us/library/ms535874\(VS.85\).aspx)
* [XMLHttpRequest Object (MozDev Center)](http://developer.mozilla.org/en/docs/XMLHttpRequest)
* [XMLHttpRequest Object (World Wide Web Consortium)](http://www.w3.org/TR/XMLHttpRequest/)

## Ajax演示
苹果的股价当时才200美元, 老师竟然觉得太高, 现在降得不像话了都还有450多.  看来老师是没买了.  
不过老师的演示好滥竽充数啊, 一段代码演示了好几遍, alert一遍, 输入框一遍, 文本还一遍...-_-!

## Ajax实例
比我想象的倒是要简单一些.  有一点需要注意, 在本机测试时, 一定要是通过http协议访问文件, 触发apache的功能才能正常的运行php, 想偷懒通过浏览器直接打开本地文件的话, 实际上apache是没有发挥作用的, 自然php module也就不会运行了.  
整个Ajax最核心的部分就是XMLHttpRequest对象(在IE中是ActiveXObject), 使用时, 大概的方法如下:  

    :::html
    <!DOCTYPE html>
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>Ajax Test</title>
        <script type="text/javascript">
          var xhr = null;

          function submit_info() {
            try {
              xhr = new XMLHttpRequest();
            }
            catch (e) {
              xhr = new ActiveXObject("Microsoft.XMLHTTP");
            }

            if (xhr == null) {
              alert("Ajax not supported by your browser!");
              return;
            }

            var url = "ajax.php?symbol=" + document.getElementById("symbol");

            xhr.onreadystatechange = handler;
            xhr.open("GET", url, true);
            xhr.send(null);
          }

          function handler() {
            if (xhr.readyState === 4) {
              if (xhr.status === 200) {
                alert(xhr.responseText);
                stock = eval("(" + xhr.responseText + ")");
                alert(stock);
                alert(stock.price);
                alert(stock.high);
                alert(stock.low);
              }
              else {
                alert("Error with Ajax Call!");
              }
            }
          }

        </script>
      </head>
      <body>
        <div>
          <form action="ajax.php" onsubmit="submit_info(); return false;">
            <input type="text" name="symbol" id="symbol" value="" />
            <br />
            <input type="submit" value="Get Quote" />
          </form>
        </div>
      </body>
    </html>

要点, XMLHttpRequest对象的onreadystatechange回调函数设置指定了由handler函数来处理回调.  handler通过对readyState的判断, 来了解目前ajax处理到了第几步.  它的[可能值如下](http://msdn.microsoft.com/en-us/library/ms534361\(v=vs.85\).aspx):

* READYSTATE_UNINITIALIZED (0): The object has been created, but not initialized (the open method has not been called).
* READYSTATE_LOADING (1): A request has been opened, but the send method has not been called.
* READYSTATE_LOADED (2): The send method has been called. No data is available yet.
* READYSTATE_INTERACTIVE (3): Some data has been received; however, neither responseText nor responseBody is available.
* READYSTATE_COMPLETE (4): All the data has been received.

然后, 通过status获得HTTP的状态值, 这个值就是HTTP协议的事情了, 并且有很多种可能, 这里不列举了, 在[这里查看](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes).  

然后, 需要注意的是, form的onsubmit直接返回了false, 表示不会跳转网页, 实际的处理是通过在submit_info()中通过ajax代码处理的.  
  
上述代码创建XMLHttpRequest的方式是为了兼容IE7以下浏览器(其实就是IE6了).  

最后, 虽然ajax这个缩写原来的'x'指的是xml, 但是上述代码用了json, 比xml清晰简单了不止1万倍.  

后台处理的代码我我简化了多余代码, 如下:(其实不一定要是php) 

    :::html+php
    <?php
       class Stock {
          public $price;
          public $high;
          public $low;
       }

       header("Content-type: application/json");
       $stock->price = 10;
       $stock->high = 20.0;
       $stock->low = 30.2;

       print(json_encode($stock));
    ?>

上述代码用了json_encode, 然后header用于指定返回的meta类型.  

## JavaScript对DOM的动态操作
比如上例中, 不用alert而用JavaScript动态操作DOM, 如下:  

    :::js
    var text = document.createTextNode(symbol + ": " + xhr.responseText);
    document.getElementById("stock_price").appendChild(text);

## 一些Ajax Activity Indicators图片

* [Ajax Loading GIF Generator](http://www.ajaxload.info)
* [AjaxActivityIndicators](http://mentalized.net/activity-indicators)
* <http://ajaxpatterns.org/Progress_Indicator>

# 第8课 安全
## 常见的不安全的服务:

* HTTP
* FTP
* Telnet
* MySQL(指远程登录的默认状态, 协议是明文的)

## 常见的安全的服务:  

* SSL(HTTPS)
* SFTP
* SSH

## Wifi下非常不安全
因为目前大部分网站都是通过SSL登录, 登录后使用HTTP加cookie, 所以非常容易发生Session劫持.  目前真正安全的网站必须全部使用SSL, 比如GMail.  
课程中提到了一个曾经很著名的Session劫持Firefox插件, [FireSheep](http://codebutler.com/firesheep/), 不过目前已经无法适用于新版的Firefox了.  
WEP不安全, WPA2安全.  当路由使用WPA2加密时, 就无法通过无线的方式监听别的用户的通信, 因为这些通信也是加密的, 但是直接接入路由器的有线连接还是没有加密的.  WPA2加密仅针对无线通信.  
老师讲到目前公共的Wifi接入一般都不提供加密, 甚至连WEP都没有, 因为配置太麻烦.  这个在美国都那样, 在中国估计更加不乐观, 不过需要去试试才知道.  

## VPN
最强力的加密方式就是VPN, 不管公共Wifi是否加密, 不管对方网站是否支持SSL, 都可以加密连接, 虽然到了VPN服务器那一端以后, 还是没有加密的, 但是强度已经足够预防绝大部分的攻击.  

## Diffie-Hellman key exchange
[Diffie-Hellman key exchange](http://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)是个在双方事前没有任何协商的情况下产生密钥的方法.  感觉很有意思, 但是不知道啥时候能应用上.  

## JSONP
通常情况下, 根据同源策略(same origin policy), 所有的Ajax只能对同域名的服务器发起连接, 但是[JSONP](http://en.wikipedia.org/wiki/JSONP)可以绕过这个规定.  

## 不要点击E-mail中的链接
因为可能中跨站脚本(XSS)的攻击

# 第9课 可规模性
## 推荐读物

* Building Scalable Websites by Henderson
* High Performance MySQL by Zawodny and Balling
* MySQL Clustering by Davis and Fisk
* Scalable Internet Architectures by Schlossnagle

## 竖直规模化
就是升级硬件, 简单有效, 但是有极限.  

## 水平规模化
就是常说的集群, 可以用最便宜的东西组合起来获得无限的扩充性.  

## PHP的缓存加速
通过缓存PHP编译后的结果实现的速度提升.  

* [Alternative PHP Cache (APC)](http://pecl.php.net/package/APC)
* [eAccelerator](http://eaccelerator.net/)
* [XCache](http://xcache.lighttpd.net/)
* [Zend Platform](http://www.zend.com/en/products/platform/)

## 负载均衡(load balancer)
[HAProxy](http://haproxy.1wt.eu/)
  
单向轮询负载均衡无法处理极端情况, 在服务器与负载均衡服务器之间建立双向连接后, 负载服务器就能了解各服务器的负载情况, 就能更合理的分配服务器资源.  分配方式除轮询式外, 还有基于cookie的分配和基于源IP的分配的方式.  
可用的软硬件列表:  

* Software 
  * HAProxy
  * LVS
  * Perlbal
  * Pirhana
  * Pound
  * UltraMonkey

* Hardware 
  * Barracuda
  * Cisco 
  * Citrix 
  * F5

## MySQL Query Cache
query_cache_type = 1

## memcached
缓存服务器, 使用简单, 效果显著.  老师的原话是说, 你有很多的数据库服务器当然没错, 但是你有更多的缓存服务器可能会更好.  

## 数据库主从服务器
因为绝大部分的服务都是读的人多, 写的人少, 所以可以使用在主服务器(master server)写, 在从服务器(slave server)读的方式实现负载均衡.  

# 总结
这应该是我考上大学后听的最认真的课程了-_-! 不过总的来说, 学的东西还是有限, 我也无法衡量这段时间要是自己看书的话, 是否能够学的东西更多.  感觉听完整个课程可能最多算是开拓了一下视野而已.  
现在我的感觉是, 其实公开课虽然都是很牛的学校很牛的老师开的课, 但是并不一定是学习知识的最佳方式.  
我感觉适合看的公开课如下:  

1. 不太好自学的知识.  
2. 学习资料稀少的知识.  
3. 入门门槛非常高, 难以自学的知识.  

比如, 对于我来说, 如下课程可能值得看公开课学习:   

1. 图形学 -- 自己看不容易懂
2. 编译原理 -- 平时没有勇气看
3. 算法 -- 平时用的少, 有些也不好懂
4. 对于我来说全新的领域, 比如这次看的网页相关知识.  

但是对于通常的项目型知识, 比如语言学习啥的, 真的不如自己看书.  其他的课可能只能当作开拓视野和调剂了.  

[*PHP和MySQL Web开发*]: http://www.amazon.cn/gp/product/B001TDLD80/ref=as_li_ss_tl?ie=UTF8&camp=536&creative=3132&creativeASIN=B001TDLD80&linkCode=as2&tag=jtianlinsblog-23

<div style="text-align:right">
  writen&nbsp;by <a href="http://www.jtianling.com" target="_blank">九天雁翎(JTianLing) -- www.jtianling.com</a>
</div>

