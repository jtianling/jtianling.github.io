---
layout: post
title: wordpress安装及配置
categories:
- "随笔"
tags:
- Wordpress
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '26'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

用一个周末总算在ubuntu下把www.jtianling.com博客搭建好了，这里分享一些不成熟的经验。

## 准备工作

安装wordpress前需要安装的软件如下：

1.apache2，这个不用说了，没有apache就没有http服务器啊。

apt-get install apache2

2.php5，wordpress是用php写的

apt-get install libapache2-mod-php5 php5

3.mysql，wordpress以mysql为标准的数据库

apt-get install mysql-server-5.0 mysql-common mysql-admin php5-mysql

4.额外的东西，比如phpmyadmin，用于方便管理mysql，比如unzip,用于解压zip包。

大部分情况下，以上软件的安装只需要用apt-get install就能简单的安装。

用

/etc/init.d/apache2 restart

来重启apache服务器，基本上以上服务就可用了。

#### apache mod加载

可以通过

ls /etc/apache2/mods-enabled

来查看已经加载的apache mod，

通过

ls /etc/apache2/mods-available/

来查看安装了但是没有加载的模块。

假如没有加载好的话，可以通过a2enmod 加载。比如加载php模块。

a2enmod php5

加载后，需要重新启动apache。

#### phpmyadmin与mysql的配置

需要注意一点，在mysql刚刚安装好的时候，密码为空，而phpmyadmin偏偏不允许空密码，于是矛盾就产生了，也就是你第一次时没法直接就用phpmyadmin管理mysql服务器。

解决办法：

在phpmyadmin的配置

/etc/phpmyadmin/config.inc.php

中找到并取消调AllowNoPassword=TRUE一行前面的注释。

登录后，再修改密码，为了安全，最好记得回来再次注释调这一行。

在phpmyadmin为wordpress建立一个数据库，可以任意取名，默认的wordpress以wordpress命名数据库，数据库中以wp_开头建立表格。

## 安装wordpress

安装wordpress再简单不过了，你可以直接apt-get install一个，然后通过ln链接/share/wordpress到/var/www目录即可。不过这个一般是英文版，而且版本较老。

这里我用<http://cn.wordpress.org/>这里的中文版本，最新版本的[下载地址](<http://cn.wordpress.org/wordpress-3.2.1-zh_CN.zip>)，可以先下载在本地，然后通过ssh或者ftp传到服务器，也可以通过wget直接在服务器端下载，这个自己选择。

#### ssh传文件：

参考：http://bingu.net/653/howto-use-ssh-upload-and-download-files/

apt-get install lrzsz

安装rz,sz命令。

使用SecureCRT工具，登录后，使用rz传文件到服务器，sz从服务器传文件到本地。（默认存在我的文档）

#### wget下载：

这个就更加简单了，

apt-get install wget

然后直接wget file_link，就能直接下载地址指定的文件到服务器。

ftp需要配置ftp服务器，这个先不谈了。不管用什么办法，把http://cn.wordpress.org/wordpress-3.2.1-zh_CN.zip这个文件弄到服务器后，用unzip命令解压一份，然后直接mv到/var/www下，假如你愿意将整个apache都作为wordpress 博客（即apache的主目录），那么就直接将所有内容都放到www目录下，不然的话，可以放到/var/www/blog下。

然后通过

chmod -R 777 /var/www/

修改权限（上面操作不够安全）

也可以尝试通过

chown -R www-data:www-data /var/www

来修改文件本身所属的组和用户（我没有实验该操作）

解压后，wordpress目录还没有`wp-config.php配置文件，一种方法是直接用wp-config-sample.php修改成wp-config.php，[见此文档](<http://codex.wordpress.org/zh-cn:%E5%AE%89%E8%A3%85WordPress>)。`

事实上在此时直接用浏览器访问wordpress所在的地址，就能有自动安装的配置页面引导安装，如下图：

[![](http://184.82.230.158/wp-content/uploads/2011/08/wordpress_install-300x206.png)](<http://184.82.230.158/wp-content/uploads/2011/08/wordpress_install.png>)

这个非常简单，配置好mysql的数据库名，用户名，密码等信息，wordpress的用户名，密码即可。

然后，登录后即可见到wordpress的管理页面。

[![](http://184.82.230.158/wp-content/uploads/2011/08/20110822235801-102x300.png)](<http://www.jtianling.com/wp-content/uploads/2011/08/20110822235801.png>)

此时说明安装已经成功了，直接到你配置的地址去看看效果吧，wordpress默认给你建立了一个博客文章，一个页面。

## 配置及美化

wordpress的安装别提有多简单了，根本不费时间，但是实际上，为了让日志www.jtianling.com正常工作，用了我几乎整整一个周末，原因就在于wordpress虽然强大，但是强大在可配置性强，所以我用了很多时间找合适的主题，插件等来合理的搭配，并取得较好的效果。（目前我也实在不想再在blog的效果上再花太多时间了~~~其实我最喜欢的是[可能吧](<http://www.kenengba.com/>)的主题，但是好像没地儿找去...)

#### 主题：

我很喜欢coolshell.cn，于是找到了[酷壳](<http://coolshell.cn/>)的主题，主题的名字叫做[inove](<http://wordpress.org/extend/themes/download/inove.1.4.6.zip>)。

并且inove主题的主题选项中，附带Feed配置，页面上也有个较为符合中国人习惯的RSS按钮。

还附带Google analytics的代码输入地址，非常方便。

#### 插件：

酷壳无私的介绍了其[博客使用的插件](<http://coolshell.cn/plugins>)，因为博客的类型类似，也为了节省时间，就尝试了几个他列出的插件：

其中**[Akismet](<http://akismet.com/>)** ，因为用户不够多，还没有用上 。

**[All in One SEO Pack](<http://semperfiwebdesign.com/>) **不知道用了有什么用，看不到明显的效果。

**[Google XML Sitemaps](<http://www.arnebrachhold.de/redir/sitemap-home/>)** 没有兴趣使用。

**************[WP Super Cache](<http://ocaoimh.ie/wp-super-cache/>)** ，也没有感觉到用途。

******************[SyntaxHighlighter Evolved](<http://www.viper007bond.com/wordpress-plugins/syntaxhighlighter/>)** ，安装了，也还没有使用......

倒是发现了其他几个插件的好用之处：

**********************[Faster Image Insert](<http://blog.ticktag.org/2009/02/19/2765/>) **\- 批量图片插入插件，非常好用。

**********************[WP-PostRatings](<http://lesterchan.net/portfolio/programming/php/>) **- [下载地址](<http://downloads.wordpress.org/plugin/wp-postratings.zip>)。评分插件，我才不管IE浏览器是否能看呢，我的读者里面有用IE浏览器的吗？

插件开启使用后，需要进行一定的配置。

在single的页面，插入

<?php if(function_exists('the_ratings')) { the_ratings(); } ?>

到

<?php include('templates/comments.php'); ?>

之前，也就是放在评论之前。

在index的页面配置文件，插入到

<div id="pagenavi">

之前，也就是页面浏览之前。

这个也可以自己把握。

[日志自动截断 ](<http://www.liaozuhui.com/wp-content/uploads/2010/03/wp_plugin_limit-posts-automatically-cn.zip>)- 自动截断日志文字的插件的中文版，使用此插件后，撰写日志时无需再加入more标签进行文字截断操作。采用UTF-8模式截取，中文无乱码。这个插件是为了达到coolshell那种首页只显示文章一部分内容而需要的，实际使用效果不错。

#### feeds:

参考：<http://codex.wordpress.org/WordPress_Feeds>

最后我用了

http://www.jtianling.com/feed=rss2

这个，然后用域名

http://feed.jtianling.com转向支持，作为永久的feed地址。

#### 字体：

参考：http://www.qiyecao.org/wordpress/wordpress-fontstyle-setting.html

简单的说是，

font-family:宋体,微软雅黑,Arial,Verdana,arial,serif;

font-size自己进行合适的修改，一般来说，普通的12px改为14px，其他的酌情放大处理。原因在于主题是英文的，而英文一般用12px,中文用12px偏小，用14px较为合适。

## 备份

好不容易搞了这么多东西，不备份一下心里不踏实啊：  
tar czvf www.tar /var/www

然后用sz传回到本地保存起来

最后的样子，也就是本博客的样子了~~~~
