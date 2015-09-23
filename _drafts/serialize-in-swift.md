---
layout: post
title: Swift中的序列化(到二进制数据)
date: 2015-09-12
comments: true
categories: 编程
published: false
tags: 
- Swift
- 序列化
- Serialize
---

可能最近真的很少有人再像当年那么折腾自己的私有协议了, 在原来用C++写服务器的时候, 序列化基本上就是基础功能, 现在protobuf, MessagePack, bjson, thirft都够好用的了, 随便用哪个在性能上, 空间上都不是问题, 并且开发起来会更加简单, 所以当我需要在Swift找一个序列化库的时候(别问我为什么需要, 说出来都是泪), 竟然搜遍了网络也没有找到.  而苹果自带的那个NSArchive系列又的确不满足要求(需要Key是什么鬼?), 那只好自己写一个了.

<!-- more -->

# 二进制数据类型选择
虽然大多数应用场景都是使用NSData, 但是我最终选择了Array<Int8>来作为二进制数据保存的格式.  

1. Array<Int8>可以方便的和NSData互相转换
2. Array<Int8>处理起来就是Array, 比折腾NSData那些通过Range取数据, 通过NSMutableData类型添加数据要更加方便一些.

