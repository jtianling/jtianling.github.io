---
layout: post
title: "cocoslicer(cocos2d/cocos2d-x 打包后的资源分割器)"
date: 2013-05-21
comments: true
categories: 我的项目
tags: cocoslicer Cocos2d-x TexturePacker
---

工具很简单, 就是将TexturePacker等工具打包好的图片给分解开, 相当于Texture Pack后资源的解包过程.  
主要用于找回自己丢失原图片文件, 但是有打包后资源的情况, 请勿用于其他用途.  

工具用Ruby完成, 利用了[*Imagemagick*](http://www.imagemagick.org/script/index.php)命令行工具而不是对应的Imagemagick Ruby库, 这个有些特殊, 也就是需要先安装Imagemagick后才能使用. 工具自己的安装非常方便, 因为已经作为Gem提交,  安装Ruby后, 按照普通的gem安装方式安装即可:  

~~~ bash
$ gem install cocoslicer
~~~

使用时:

~~~ bash
$ cocoslicer packed.plist
~~~

目前工具不支持zwoptex打包的图片.  

源代码地址: https://github.com/jtianling/cocoslicer
