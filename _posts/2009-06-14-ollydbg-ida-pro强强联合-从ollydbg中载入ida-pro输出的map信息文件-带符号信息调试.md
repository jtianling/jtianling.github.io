---
layout: post
title: OllyDbg,IDA pro强强联合！从OllyDbg中载入IDA Pro输出的map信息文件，带符号信息调试!
categories:
- "未分类"
tags:
- IDA pro
- OllyDbg
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '21'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

# OllyDbg,IDA pro强强联合！从OllyDbg中载入IDA Pro输出的map信息文件，带符号信息调试!  

**write by 九天雁翎(JTianLing) -- www.jtianling.com**

再强大的工具有的时候也不能独立解决问题，毕竟各有所长，就算是最最强大的IDA Pro, OllyDbg, SoftIce都不例外，对于静态分析自然是IDA Pro最强大，而静态分析不了的时候就需要SI,OD出马了，以前我找了很久才研究出一种从SoftIce中载入IDA Pro输出的map信息文件的方法，  

《SoftIce,IDA pro强强联合！从SOFTICE中打开IDA Pro输出的map信息文件》

http://www.jtianling.com/archive/2009/01/07/3730240.aspx

这一次，我又在网上发现了从OllyDbg载入IDA Pro输出的map的信息的方法了：）  

这样实现了OllyDbg带符号信息的调试，更加方便了。。。。呵呵  

其实主要的问题在于OllyDbg的一个LoadMap的插件，因为看雪没有下载，我一直不知道，特意从国外download下来了：）  

放到老地方，有需要的去下载吧。  

[http://groups.google.com/group/jiutianfile/files](<http://groups.google.com/group/jiutianfile/files>)  

方法就不多说了，用IDA Pro的Product功能，生成map,再用此插件载入就好了，连这都不知道的话估计也不会用这些软件了。  

**write by 九天雁翎(JTianLing) -- www.jtianling.com**
