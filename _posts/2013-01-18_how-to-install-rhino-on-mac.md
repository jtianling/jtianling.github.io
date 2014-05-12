---
layout: post
title: "怎么在Mac上安装Rhino(JavaScript的JAVA实现)"
date: 2013-01-18
comments: true
categories: 编程
tags: Rhino JavaScript
---

[Rhino](https://github.com/mozilla/rhino)是JavaScript的一个Java实现, 可以直接使用REPL的方式来使用JavaScript, 光是研究语言特性的话, 会比在浏览器里面方便很多.  当然, 现在还有一个新的选择, 那就是[node.js](http://nodejs.org/).  Rhino是Mozilla的实现, node.js用的V8引擎是Google的实现.  
<!-- more -->

# 下载
目前最新版本是[1.7R4版本](https://developer.mozilla.org/en-US/docs/Rhino/Download_Rhino?redirectlocale=en-US&redirectslug=RhinoDownload).

    :::Bash
    $ curl ftp://ftp.mozilla.org/pub/mozilla.org/js/rhino1_7R1.zip > /tmp/rhino.zip
    $ cd /tmp
    $ unzip rhino.zip

# 移动到Java能找到的位置

    :::Bash
    $ mv /tmp/rhino1_7R1/js.jar ~/Library/Java/Extensions/

假如上面的目录不存在的话, 需要你自己建一个  

# 简化运行
此时已经可以直接通过下面代码运行Rhino了.  

    :::Bash
    $ java org.mozilla.javascript.tools.shell.Main

因为太过复杂, 可以考虑修改`.bash_profile`加个别名.  

    :::Bash
    $ echo 'alias js="java org.mozilla.javascript.tools.shell.Main"' >> ~/.bash_profile
    $ source ~/.bash_profile

这样直接用`js`就能使用Rhino了.  

# 参考
[Installing Rhino on Mac](http://www.phpied.com/installing-rhino-on-mac/)

