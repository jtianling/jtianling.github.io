---
layout: post
title: "学习网络编程ubuntu桌面版比服务器版更好？"
categories:
- "网络技术"
tags:
- Linux
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '12'
  ks_metadata: a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:0:"";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:0:"";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:0:"";s:6:"robots";s:12:"index,follow";}
  _edit_last: '1'
  _wp_old_slug: "%0d%0a%20%20%20%20%20%20%20%20%e5%ad%a6%e4%b9%a0%e7%bd%91%e7%bb%9c%e7%bc%96%e7%a8%8bubuntu%e6%a1%8c%e9%9d%a2%e7%89%88%e6%af%94%e6%9c%8d%e5%8a%a1%e5%99%a8%e7%89%88%e6%9b%b4%e5%a5%bd%ef%bc%9f%0d%0a%20%2"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

程序在Ubuntu服务器版跑不起来，重装桌面版后却一次成功。尽管后续配置很折腾，但总算解决了大问题，不再郁闷。

<!-- more -->

郁闷坏了，在一再确定程序没有问题的前提下，我放弃了原有Ubuntu服务器版的稳定配置（配置了很久啊，当然也许就是那个时候鼓捣的配置，弄得程序跑不成功），昨天重新安了个Ubuntu的桌面版，第一件事就是测以前的程序，一次成功-_-!再次郁闷一下，然后一次手误，将ssh_config配置文件删了，半天找不回来，网上教学的多，真有完整配置文件的少，将ssh,openssh-server卸载了重新安装，还是没有新的配置文件，。。。。。总算找到配置文件后，又要想办法将原有的X11删掉，呵呵，真是麻烦啊。。。。。不过，好歹，网络程序可以跑了，不要再郁闷的Unix网络编程的书，然后在Windows下跑程序了-_-!
