---
layout: post
title: "跨平台(iOS, Android)开发方案"
date: 2013-01-14
comments: true
categories: 编程
tags: iOS, Android, PhoneGap, Titanium, RubyMotion, Ruboto, Mono 
---

很久以前的移动平台开发者很幸运, 因为他们只用关注一个平台(iOS)就够了, 现在随着Android越来越受到关注, 以前统一的平台又开始了分裂.  
到目前为止, 我知道可能的, 能够使用一套代码跨平台开发app的方法有:  
<!-- more -->

# Html: PhoneGap
[*PhoneGap*](http://phonegap.com/)是基于Web技术的(HTML, CSS, Javascript), 虽然出来的时间不短了, 但是真正是属于未来的解决方案.  因为真正开发出来的就是WebApp.    在移动平台上简单的应用几乎是不需要PhoneGap就能基于HTML开发的, 因为移动平台都提供了类似WebView的控件,  但是PhoneGap提供了能调用本地API的功能, 可以极大的扩展应用的适用范围.  
也正是因为是WebApp, 事实上支持的平台相当丰富, 这还不考虑到PC/MAc浏览器的简单支持.  目前PhoneGap已支持:  
iOS, Android, BlackBerry, Symbian, WebOS, Windows Phone 7/8, Bada, Tizen.  
需要注意的是, PhoneGap本身只带原生API调用, 没有UI, 需要的话得搭配其他的Web UI库使用.  
目前PhoneGap已被Adobe收购, 这也是Flash彻底退出移动平台后Adobe的逆袭.  
好消息是, PhoneGap是完全免费并且[开源](https://github.com/phonegap/phonegap)的.  
而坏消息是Web技术在目前的移动平台上效率还有些低.  

# JavaScript: Titanium SDK
[*Titanium SDK*](http://www.appcelerator.com/platform/titanium-sdk/)是个很另类的解决方案.  提供了一套使用JavaScript的SDK.  但是本身并不是使用HTML技术, 而是相当于把JavaScript当作脚本语言用来开发原生的App.  
也是因为这个原因, 支持新平台就比PhoneGap难多了, 目前仅支持iOS和Android.  
Titanium SDK的使用本身是免费的, 通过附属的Appcelerator Analytics, Appcelerator Cloud Services服务收费.  并且价格还不公布, 需要Contact Sales...

# Ruby: RubyMotion(iOS), Ruboto(android)
本来来说, Ruby似乎和移动开发有点远, 但是[*RubyMotion*](http://www.rubymotion.com/)
和[*Ruboto*](http://ruboto.org/), 让这一切变为可能.  
其中RubyMotion一次性收费$199.99(￥1318.15), 永不过期.  Ruboto通过JRuby实现, 属于免费开源项目.  

# C# with Mono
Mono(http://www.mono-project.com/Main_Page)最近宣布了对iOS的支持, Xamarin还为此说他们比微软更喜欢C#, 自此已经完整的支持了Android和iOS了.  
可惜的是, 价格有些贵.  最便宜的能发布软件的(iOS, Android)版本是Professional, 分别售价$399, 要是想跨平台开发的话就得买两套, 并且, 这还是一年升级支持的版本-_-!
