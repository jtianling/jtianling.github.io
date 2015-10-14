---
layout: post
title: iOS中自定义View
date: 2015-10-14
comments: true
categories: 编程
published: false
tags: 
- UIView
- Swift
- iOS
---

在实际iOS app编写过程中我们一般不需要自定义view(也就是写继承UIView的代码), 一般我们都是直接使用各类view加其controller, delegate就可以完成任务, 苹果本身设计UI框架的时候, 也主要是通过delegate是实现各类view的自定义和特性, 典型的比如tableview的UITableViewDelegate和UITableViewDataSource, 加上自定义的cell, 可以实现非常丰富多样的效果.  本身苹果的控件设计的也足够灵活, 所以通常也够用了, 但是在app足够复杂, 又有很多长的类似的自定义控件时, 再一个一个的通过IB(Interface Builder)单独的编辑, 就有些繁琐了, 最好的办法是直接自定义自己的view(叫控件也好, 叫组件也好, 在iOS中反正都会通过view来表示), 而苹果实际也提供了这样的办法, 甚至提供了能在IB中直接显示效果的办法. 
PS: 已经很少发这种具体技术相关的文章了, 因为感觉营养太少, 不过最近的工作又从游戏方面转到iOS app开发, 自己也在学习和摸索中, 也许将来有机会还会分享一些.

<!-- more -->

