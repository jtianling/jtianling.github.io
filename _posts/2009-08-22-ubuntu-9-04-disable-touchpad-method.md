---
layout: post
title: Ubuntu 9.04禁用触摸板的办法
categories:
- Linux
tags:
- Ubuntu
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

现在将笔记本带到公司去了（好寒酸啊。。。。带着女朋友的HP520本本），装了Ubuntu9.04，这个本子很多地方设计不合理，其中USB的位置有问题，触摸板在打字的时候很容易误碰（对于敲程序来说太致命了），所以找了半天禁用的办法，流传最广的8.04下可用的例子已经不能用了，真的可用办法如下：

 

用 

sudo rmmod psmouse

禁用

要恢复也简单：  
sudo modprobe psmouse 

 

 

 

来自

[http://blog.3gcomet.com/trackback.asp?tbID=343&action=addtb&tbKey=627fe24937da2cebf94fe2f5a0b2022ebb428cbc](<http://blog.3gcomet.com/trackback.asp?tbID=343&action=addtb&tbKey=627fe24937da2cebf94fe2f5a0b2022ebb428cbc>)

 

 

一切好了，哈雷路亚。。。。。。在Linux下没有不能做到的事情，只是看你知不知道怎么做。。。。。其实这个事情我折腾了很久。