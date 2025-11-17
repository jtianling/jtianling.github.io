---
layout: post
title: Google为啥没有Java的style guide（编码风格指导）
categories:
- "随笔"
tags:
- Google
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '52'
  _edit_last: '1'
  ks_metadata: a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:0:"";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:0:"";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:0:"";s:6:"robots";s:12:"index,follow";}
  _wp_old_slug: "%0d%0a%20%20%20%20%20%20%20%20google%e4%b8%ba%e5%95%a5%e6%b2%a1%e6%9c%89java%e7%9a%84style%20guide%ef%bc%88%e7%bc%96%e7%a0%81%e9%a3%8e%e6%a0%bc%e6%8c%87%e5%af%bc%ef%bc%89%0d%0a%20%20%20%20%20%20%20%20"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

印象中，听说过Google内部使用最多的三种语言是C++,Java,Python，但是很奇怪的是，[Google style guide](<http://code.google.com/p/google-styleguide/>)，有C++，Python的，还有Javascript和objc的，估计内部用的也不会少，但是就是没有Java的，这个很让人纳闷，为什么呢？

在stackoverflow上，还真有人问起此问题：[Why no Google java style guide?](<http://stackoverflow.com/questions/4074748/why-no-google-java-style-guide-closed>)

怎么就没有呢？怎么就没有呢？Google怎么在Android中都选择了Java作为开发语言，就是偏偏Style guide没有Java呢？  
有人的回答很二：You have to ask Google.   
也有很多有意义的回答：  
1.Google's Java style is pretty much the same as [the standard Java style](<http://www.oracle.com/technetwork/java/codeconvtoc-136057.html>)。  
Google的java style与Java标准的style（Sun的）非常像。所以不需要了，也许吧，不过Apple也有objc style guide啊，为啥Google有objc的呢？因为Google看Sun更顺眼还是看Apple不顺眼？这个我就不知道了。  
2.Joshua Bloch - Effective Java 2nd Edition is Googles style guide  
Effective Java就是Google的编码风格指导......这个太牛了。提供一个第一版的[pdf版本](<https://docs.google.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwM1qelJlRTTNzc4MWE1OGUtYWZkMC00ZTc5LTk5ZTItYzdlYzhhNzczOTVj&hl=en&authkey=CKS5x88K>)给大家看看吧，有钱请买正版的第二版。

还有几个真正出自Google的JAVA相关编码风格指导可以作为参考：  
[Google在Android开发中推荐的编码风格](<https://sites.google.com/a/android.com/opensource/submit-patches/code-style-guide>)，因为该网页在google sites上面，因为众所周知的原因，比较难以访问，我拷贝了个[evernote版本](<http://www.evernote.com/shard/s16/sh/b920e93c-2b4f-4e5e-a6ed-c820528f47ea/315dfaf6a40a1d8aec3ea0e063159f74>)。  
[GWT的Code style文档](<http://code.google.com/webtoolkit/makinggwtbetter.html#codestyle>)

 

原创文章作者保留版权 转载请注明原作者 并给出链接

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)

 
