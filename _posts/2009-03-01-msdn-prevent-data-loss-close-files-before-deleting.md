---
layout: post
title: MSDN:为了防止数据丢失,请关闭文件后再删除它们
categories:
- "纯娱乐"
tags:
- MSDN
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

旧版MSDN文档曾建议，为防止数据丢失，删除文件前应先关闭。这条显而易见的建议让人觉得十分有趣。

<!-- more -->




今天看ext lib的作者网页上写的，觉得挺有意思，大家也可以去看看：
http://mx-3.cz/tringi/www/langen.php?id=msdn&submenu=3

最绝的一条是：

### DeleteFile

...
To prevent loss of data, close files before attempting to delete them.
...

为了防止数据丢失......请关闭文件后再删除它们-_-!

不过我的VS2005版本的MSDN已经没有这个了，不知道作者的版本是多少。

