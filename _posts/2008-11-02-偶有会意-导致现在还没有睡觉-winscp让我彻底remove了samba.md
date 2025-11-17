---
layout: post
title: "偶有会意，导致现在还没有睡觉。。。。winscp让我彻底remove了samba"
categories:
- Linux
tags:
- Samba
- winscp
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

以前读大学的时候就捣鼓过samba，那时候寝室四台电脑，我一个人装个英文的fc4，没有办法和室友们共享文件，特别是想共享他们的电影的时候特别不方便（好像能共享的也就是电影了）。  
于是当时找到了samba,当时那个痛苦啊，折腾了起码两天才基本算搞明白怎么回事，基本实现了读取windows文件的功能和让室友访问我电脑的功能。

最近再次需要在台式机与笔记本（ubuntu)共享文件的时候，自然还是想到了samba，我弄ssh只用了一下子，弄samba又用了2个晚上，而且一直是痛苦着用着。。。。因为偶尔能够登上，偶尔又登不上。。。。。痛苦至极，当然这可能是我配置的问题。以前就想过实在不行就直接驾一个ftp就好了，今天晚上正准备好好的解决一下，给我发现了原来ssh协议中有个附带的sftp协议，可以实现类似ftp的功能。那还说什么，本来就像干脆驾个ftp了，看到这样更没有犹豫了。

并且给我找到了winscp这个软件。。。。在windows下实现了类total command的界面。。。这下台式机及笔记本之间的文件共享问题总算是解决了。。。。以后再也不会痛苦了。可惜的是RSA的密钥验证方式我一直还没有弄好，小郁闷。

用winscp传输文件，用putty远程登录，完美编程的解决方案：）另外。。。虽然对于我来说不是那么重要，但是值得一提的一点是，基于ssh2协议的传输还是加过密的。包括使用sftp在内。
