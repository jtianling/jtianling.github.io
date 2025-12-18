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
---

印象中，听说过Google内部使用最多的三种语言是C++,Java,Python，但是很奇怪的是，[Google style guide](<http://code.google.com/p/google-styleguide/>)，有C++，Python的，还有Javascript和objc的，估计内部用的也不会少，但是就是没有Java的，这个很让人纳闷，为什么呢？

在stackoverflow上，还真有人问起此问题：[Why no Google java style guide?](<http://stackoverflow.com/questions/4074748/why-no-google-java-style-guide-closed>)


<!-- more -->


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

