---
layout: post
title: "【转载】ubuntu搭建subversion(svn)服务器"
categories:
- "未分类"
tags:
- Svn
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

Ubuntu服务开机自启方法：将启动脚本放/etc/init.d/，在/etc/rc2.d/创建软链接即可。也可用sysvconfig工具设置。

<!-- more -->

关于普通的配置<http://wiki.ubuntu.org.cn/SubVersion>中讲解的很详细

但是因为是做服务器，我希望开机即启动，这样排除手工干预，才能将服务器的显示器，鼠标，键盘省下来-_-!。。。

这里从别的网站转来的文章：（因为原来那个网站不厚道，没有出处，我也没有办法了，不是我不注明）

Ubuntu Add commentsubuntu预设是跑runleve2，也就是/etc/rc2.d内的软连结档，真正的服务设定档都在/etc/init.d当中。

我在/etc/rc2.d执行ls可以看得到firestarter，代表在开机时他的确有执行，事实上/etc/rc2.d到/etc/rc5.c应该都是一样的。

你也可以自行设定开机要跑哪一个runlevel。

可以试试这个套件：

```bash
$ sudo apt-get install sysvconfig
$ sudo sysvconfig
```

就可以设定开机服务。

其实上面的说法很简单，有点看不懂，基本思路是将服务器启动的脚本卸载/etc/init.d中，然后建立软连接（用ln -s）到/etc/rc2.d中去，这样就能那里面的启动脚本会在开机时自动运行，也就达到了我们要的开机运行效果。
