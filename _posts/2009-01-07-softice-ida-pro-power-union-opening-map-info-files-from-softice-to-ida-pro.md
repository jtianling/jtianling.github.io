---
layout: post
title: SoftIce,IDA pro强强联合！从SOFTICE中打开IDA Pro输出的map信息文件
categories:
- "未分类"
tags:
- IDA pro
- SoftIce
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '12'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# SoftIce,IDA pro强强联合！从SOFTICE中打开IDA Pro输出的map信息文件

 

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

很搞笑的事情，才知道原来没有关系（指两个公司没有关系）的softice,ida pro两个软件其实也是可以交互的，这点除了在Linux下有这样的思想，其他地方还真少看到，一般都要等某个公司独霸了市场，然后大家慢慢向他靠拢以形成标准。才有可能做到通用。

其实softice支持的信息文件格式为nym格式的（我也不知道是什么格式），IDA Pro作为反汇编工具可以输出的格式还真算比较多，其中有种是 borland公司的map格式，这点倒好，还是没有办法通用，kris kaspersky的黑客调试技术揭秘中提到有个工具可以转换，叫做idasym，但是我一通暴搜，一无所获。最后几近周折（从官网找到了几个业余爱好者 的blog）找到了一个插件，但是不能用。然后从ida pro的配置文件注释中发现了i2s插件，去下了一个，发现版本太老，不用用于最近的IDA，但是，就在绝望之中，发现了让人惊奇的事 实。。。。。。。。。。。。。。。。。。。。。。。。VS中有提供从map到nym转换的工具！！！至于为什么微软提供这样的工具我实在是不得而知。。。 但是。。。首次。。。由衷地感谢微软！

顺便说下工具的名字，MapSym.Exe  
在VS安装目录的Common7/Tools/Bin/下（VS2005），其他版本有没有我不缺确认，可以去找一找。

再顺便说下使用方法，格式如同mapsym -o outfile.nym infile.map

然后用softice的symload打开转换后的nym文件，载入成功后再载入需要调试的文件，这个时候就爽了！！！  
可以任意在你分析后命了名的代码下断，呵呵，从此后，没有加壳的代码。。。。。无论是看，还是调试。。。基本已经和一般的源码么有区别了。。。（当然指的是非宏汇编源码）

 

 

**_write by_**** _九天雁翎_**** _(JTianLing) --  
blog.csdn.net/vagrxie_**