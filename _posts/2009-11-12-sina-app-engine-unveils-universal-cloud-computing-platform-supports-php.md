---
layout: post
title: "新浪惊现通用云计算平台 Sina App Engine横空出世 支持PHP"
categories:
- "随笔"
tags:
- PHP
- SAE
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

Technorati 标签: [SAE](<http://technorati.com/tags/SAE>),[Sina App Engine](<http://technorati.com/tags/Sina+App+Engine>),[新浪云计算](<http://technorati.com/tags/%e6%96%b0%e6%b5%aa%e4%ba%91%e8%ae%a1%e7%ae%97>),[云计算平台](<http://technorati.com/tags/%e4%ba%91%e8%ae%a1%e7%ae%97%e5%b9%b3%e5%8f%b0>),[云计算](<http://technorati.com/tags/%e4%ba%91%e8%ae%a1%e7%ae%97>)

当做电子商务的亚马逊在全球率先推出通用云计算平台时，让大家震惊了很久，随后Google也推出了App Engine，原来仅仅支持Python，现在已经支持了JAVA。2009年9月，阿里巴巴集团在十周年庆典上宣布成立子公司“ _阿里云_ ”，叫嚣要提供比亚马逊更多服务的时候，我才开始看到国内游企业开始进军云计算平台的领域，但是，事实上，此事上新浪已经先行一步了，今天很惊讶的发现Sina App Engine已经开始内测了。。。。。

见<http://sae.sina.com.cn/>，虽然sina还没有大肆的宣传，但是，从其命名上sae(Sina App Engine），加上其简单的定位“Sina App Engine - 简单高效的分布式Web应用开发与运行平台”，很明显能看出这是与Google App Engine类似的通用云计算平台，有意思的是，Sina不知道是有意的避免与Google进行直接的竞争，还是考虑到国内的网络开发国情，提供的是PHP+MySQL的服务：）

其服务列表上说明的是：

### 支持的服务:

  * PHP 5.3.0 
  * Mysql 5.0.86 
  * Memcache 
  * Fetch URL 

相当的类似本地开发，呵呵，广大的PHP开发者有福了。。。。。。想当年我为了尝试Google的App Engine还特意去学习了Python。。。狂汗-_-!当然，我还是没有福，因为我不实用PHP。

假如没有意外的话，Sina将是国内第一家推出通用云计算平台的企业，Sina作为国内三大门户，很不幸的没有像163，Sohu一样在新兴的网络游戏市场上分到大馅饼，（现在163，Sohu从营收来看更像是一家网络游戏公司，特别是163,Sohu的网络游戏分拆上市还好点）但是Sina估计痛定思痛，反而能沉下心来研究一些传统互联网公司应该研究的东西，这一次，Sina的赌注绝对没有下错地方，当然，首先还得SAE的确好用才行，我看了演示，应该还好，并且就我了解，国内的网页开发PHP也的确是主流，预祝SAE成功：）

另外，由于目前还在内测阶段，好像需要邀请码，并且现在已经不让注册了，导致我没有办法实际的去尝试一下了。。。虽然其实我不懂PHP。但是这里有个[演示视频](<http://sae.sina.com.cn/static/flash/video/SaeQuickStart.htm>)，大家可以先体验一下。再不过瘾，看看[文档](<http://wiki.sae.sina.com.cn/doku.php>)先？

以下是Sina在文档中对SAE的简介：

### SAE简介

Sina App Engine(SAE)，是由新浪公司开发和运营的开放云计算平台的核心组成部分。 

SAE的目标是实现互联网应用在开发运维上的无缝整合，为App开发者提供稳定、快捷、透明、可控的服务化的平台，并且减少开发者的开发和维护成本。 

同时通过对消耗资源的量化，反向作用于开发过程，促进新浪公司互联网应用服务的质量提升。 

**SAE具有以下特点：**

  * 自动负载均衡 - - - - 根据应用压力自动调整服务规模，自动负载均衡

  * 自动分布式代码部署 - - - - 原子的将开发者代码部署到所有web前端

  * 自动健康检查 - - - - 所有设备自动健康检查

  * 故障系统自恢复 - - - - 发现故障服务自动内部无缝切换，故障报警和有限度自行恢复

  * 多平台简单SDK操作 - - - - 主流OS平台SDK支持，任何一台PC即可享受SDK

  * 快速分布式web应用开发 - - - - 提供多种分布式服务，接口友好封装，减少开发者学习使用成本

  * 团队开发协作 - - - - 开发者可以进行项目团队管理，代码管理、在线沟通方便有效

  * 资源自动分配 - - - - 符合云计算理念，所有资源在配额内，自动分配

  * 所付即所用 - - - - 符合云计算理念，最大粒度量化开发者成本，所付即所用，所付仅所用

  * 服务高可靠SLA保证 - - - - 全架构高冗余实现高可靠性

**SAE为开发者提供以下服务：**

  * PHP5 Runtime运行环境 - - - - 基于PHP 5.3.0内核

  * 支持读写分离的分布式数据库服务 - - - - 基于Mysql数据库

  * 分布式文件存储服务 - - - - 基于分布式文件系统

  * 基于Memcache协议的分布式缓存服务 - - - - 基于集群memcache系统

  * URLFetch远程数据抓取服务 - - - - 基于分布式proxy服务

  * Cronjob定时任务 - - - - 基于分布式定时器服务

  * SPP图片处理服务 - - - - 基于分布式高CPU计算服务

值得期待啊。。。。。。。。。。。

## 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**