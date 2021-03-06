---
layout: post
title: "[译]GYP vs. CMake -- 一个开发者对自己项目客观的说明"
date: 2013-01-18
comments: true
categories: 编程
tags: CMake Gyp 
---

[*Gyp*](http://code.google.com/p/gyp/)是一个类似CMake的项目生成工具, 用于管理你的源代码, 在google code主页上唯一的一句slogan是"GYP can Generate Your Projects.".  
目前Gyp的应用没有CMake那么广泛, 但是已经被诸如chromium, Node.js等著名项目使用, 而Gyp本身就是chromium团队觉得CMake不满意, 而自己开发用于替代CMake的.  
作为后来者, 自然有更好的地方, 并且具有较大的改进, 才值得开发, 那Gyp比CMake好在什么地方呢?

<!-- more -->

**目录**:

* TOC
{:toc}


下面就是Gyp的开发者对此的解释, 让我比较有感触的是, 虽然是作为Gyp的开发者, 作者没有一味的拔高Gyp, 而是实事求是的陈述自己的看法, 甚至连缺点描述的都不比优点要少, 这种谦虚和实事求是的态度, 让我十分敬佩.  反例什么的我就不举了, 相信大家看到的也不少.  
需要说明的是, 对于翻译什么的我比较讨厌, 所以以下仅是部分概要, 不是完整翻译, 原文在<http://code.google.com/p/gyp/wiki/GypVsCMake>

# GYP vs. CMake
我研究过把Chromium用CMake管理, 而且我想我走的够远了(已经搞定了包括net, base, sandbox等模块和webkit的一部分), 但是我们仍然决定开发了Gyp, 用于解决一些问题, 虽然这些问题不一定全适用于其他项目.  而且Gyp的开发和一些设计, 来源于在Google公司对大型项目的构建经验, 有些CMake没有的特性开发, 甚至不是严格的来自于Chromium.(译者注: 也就是会更加通用)  

## Gyp的优点

1. 允许逐渐的过渡.  也就是允许逐步的, 一部分一部分的将现有项目迁移到用Gyp管理.  使得这成为一个无痛的过程.(即不会耽误当前项目的开发)     
2. 能生成一个更*'普通'*('normal')的vcproj工程文件.  在Windows平台上, 没有生成任何makefile类型的工程.  更方便VS等IDE的使用.  
3. 在项目设置的层次上进行抽象, 而不是命令行flag.  所以在gyp的语法允许你设置几乎任何一个将来生成xcdoe/vcproj工程的选项.  
4. 很强的模块public/private接口.  Gyp允许设置对模块更精细的设置, 使得可以在项目中设置模块的依赖, 使得一个模块依赖自动化进行.  
5. 跨平台生成.  这个意味着你可以在Windows上生成XCode工程, 这样对发布跨平台的应用会更加方便.  
6. Gyp有基本的交叉编译支持.  目前支持x86 -> arm的交叉编译.  

## Gyp的缺点
1. 因为上述的优点3, 导致可能针对不同平台的同样的配置可能在不同的配置文件中重复出现.  
2. CMake可能更加成熟, 因为已经被更加广泛的应用.  
3. 因为chromium的独特的cygwin版本, Gyp目前有一些很不好的约定.  
4. CMake包含一个更加可读的交互语言.  
5. 因为Gyp的语法是深层次的嵌套的. 所以拥有类似Lisp的所有优点和缺点.  

