---
layout: post
title: Ubuntu 9.10升级完毕，两个我关注的功能（软件中心，Ubuntu One）体验
categories:
- "未分类"
tags:
- Linux
- Ubuntu
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者升级Ubuntu 9.10后，体验了新软件中心和Ubuntu One云同步。软件中心对新手更友好，但老用户或觉不便；而Ubuntu One云同步功能则非常实用，令人惊喜。

<!-- more -->



无论哪一个新版本的操作系统发布，都会是"空前的，划时代的"产品，别的不说，我感觉广告倒是每次都是"空前的，划时代的"。我不知道每次的操作系统升级到底有多少创新的东西，也不知道Ubuntu9.10与Ubuntu9.04与Ubuntu8.10之间到底差别有多大，也不清楚Windows 7到Windows Vista到Windows XP之间的跨度有多么大，我只在想，要是老是划时代，我们现在已经在哪个时代了？唉，也要理解理解，做个操作系统不容易啊。。。。。最近Windows 7出来了，我没有升级，等它普及，软件跟上再做吧，Ubuntu9.10恰好也出来了，我升级了，毕竟，点几下鼠标就升级了，因为很显然不会普及，所以，我也没有必要等它普及了-_-!

我用的其实是KDE，这里说的也应该是Kubuntu的才对。图形界面那就很简单多了，有自动弹出的提示，傻瓜式操作，我家还有台台式机只有命令行怎么办？网上也搜到了办法，安装update-manager-core包，

```
sudo apt-get install update-manager-core
```

然后运行之：

```
sudo do-release-upgrade -d
```

。

Ubuntu9.10与Ubuntu9.04的变化：

官方的介绍《[Ubunt9.10新特性](http://www.ubuntu.com/products/whatisubuntu/910features)》

中文参考此文：

《[Ubuntu9.10将会成为游戏规则改变者的十大原因](http://www.yeeyan.com/articles/view/109691/66079?orgin=top)》

比较吸引我的有几点：

1：软件中心

新立得我感觉是真正属于划时代的产品了，只要不是想要最新的版本尝鲜，不然Ubuntu下的软件安装将比Windows下的还要简单，Windows下是 找地方下载-》下载-》安装,Ubuntu是选择-》应用。因为开源/免费的性质，使得Ubuntu能够有所突破，Windows下的迅雷，360想学，但是都学不来（别说还没有解决需要手动下一步安装的问题），这点我以前提过，也是我感觉Ubuntu最人性化的一点，在命令行下，我只能用apt，但是仅仅是使用apt，软件的安装也是无比的惬意，加上Ubuntu的公司建立的ppa（[ _Personal Package Archives_ : Ubuntu](http://www.google.com/url?sa=t&source=web&ct=res&cd=8&ved=0CC0QFjAH&url=https%3A%2F%2Flaunchpad.net%2Fubuntu%2F%2Bppas&ei=lUbuSp25D6jW6gPQ6KAs&usg=AFQjCNGnIv9IyYJB0I33nLfqmm-zm1tOBw&sig2=ptDRbNrbetaWiLf4ABsb1g)），更加是让Ubuntu下的deb包源更加丰富，基本上想要的我还没有碰到过没有的。既然软件中心要替代原有的添加/删除软件工具，那么新立得和KPackageKit（远没有新立得好用）都要统一了吗？真好，那样会解决我不喜欢安装GTK+导致的新立得没有办法用的问题。(事实上，不用新立得的唯一好处就是我不会常常因为其软件太过丰富而导致头晕，花很多时间下载一大堆看上去很有意思但是实际我根本不会用到的软件），据说软件中心中还会添加进商业软件-_-!那更加是让人兴奋罗，赶快看看。作为KDE使用者接受的代价是装上一堆Gnome的东西-_-!我没有为新立得屈服，为软件中心屈服了……………

[![kubuntu9.11SoftWareCenter](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.11SoftWareCenter_thumb.png)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.11SoftWareCenter_2.png) 下面是我选择安装KDBG是的情形。

[![kubuntu9.12SoftWareCenterKDBG](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.12SoftWareCenterKDBG_thumb.png)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.12SoftWareCenterKDBG_2.png) 使用感觉是，软件界面重新设计了，软件的分类更加面向普通的用户（非程序员），现在是安装软件的应用来分类，见上面的截图就能看出来，基本与菜单启动分类一致，而以前是按照软件的实现来分类，比如Gnome,KDE,Python什么的。这样普通用户的使用应该是更加上手了，但是，我要是找一些东西还真不知道实在哪个分类里面的。。。。呵呵，我估计有的时候还是得用新立得才行。另外，因为两个软件都是以apt为基础的，所以不能同时运行。

另外，在other分类中，我也没有看到真正的商业软件，仅仅看到一些如flash pugin,ATI驱动等东西（也许就是上文所谓的商业软件），当然，他们不开源，但是免费，我还以为会提供oracle的Linux版本提供下载了-_-！（想远了）或者商业软件是指MP3解码器等东西？（的确不为真正的GNU开源卫士所接受）

[![kubuntu9.13SoftWareCenterrestricted](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.13SoftWareCenterrestricted_thumb.png)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.13SoftWareCenterrestricted_2.png) 基本上，软件中心没有让我特别惊喜的地方，可能对普通用户更加方便吧，对于我来说反而感觉包难查到，并且批量安装，删除没有原来那样方便了。

2.**Ubuntu One**

同步文件，2G空间，天哪，真不错，虽然我已经有网易的网络U盘了，但是使用上别提多麻烦了，那是引导顾客多上其网页操作的设计，也没有提供其他访问方式，而且空间总是不嫌少嘛，何况是内置在操作系统内部的工具，带同步功能。这个很吸引我，现在不要再和我讨论东西放在网上和放在自己电脑上哪个更好的问题了，可以的话，我希望将操作系统都放到网上去（好像以前有个类似的东西）。

[![kubuntu9.14one](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.14one_thumb.png)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.14one_2.png)

[![kubuntu9.15oneplan](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.15oneplan_thumb.png)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.15oneplan_2.png)

很显然，要注册了，并且提供了两个版本，这也算是Canonical的创收之路之一吧^^我以前已经在launchpad.net注册过了，现在可以直接使用其账户，而且不仅仅有文件共享的功能，还有note,联系人等功能，最郁闷的是。。。。。继TortoiseHG以后，这个功能又是与Nautilus绑定的，我再次吐血和感叹我这样使用KDE被抛弃的孩子-_-!但是，使用Ubuntu One后，会在主文件夹下增加一个名为Ubuntu One的目录，此时只需要将文件复制进去，就会自动进行同步：），呵呵，还算是比较好用，这样的话，我将来就将此文件夹作为工作目录了，无论在哪，都不怕文件丢失，呵呵，就像有个备份硬盘一样，2G的空间也能使用够久了，还可以方便的在我的服务器上同步，（还需要研究命令行下的使用方法）

网页使用页面：[![kubuntu9.15one2](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.15one2_thumb.png)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_kubuntu9.15one2_2.png)

最遗憾的功能是Quickly,本来多好的一个功能啊，（听起来）结果是针对gtk的-_-!我是无福消受了。被抛弃的孩子。。唉。。。。还有rhythmbox……我们不是不能用，要用的话代价是在KDE中再装个Gnome-_-!（虽然为了软件中心我已经装了。。。。）呵呵，但是Qt的很多工具已经够用了，我也不想太多了。

新浪也有新闻《[Ubuntu 9.10正式发布](http://tech.sina.com.cn/s/2009-10-30/13193552243.shtml)》，竟然还提供了[下载](http://down.tech.sina.com.cn/page/28382.html)，才发现，原来新浪已经提供一些流行Linux发行版的下载了，呵呵，加上以前网易提供了一些Linux发行版的源（我没有用过，仅仅听说），现在Linux发展还不错嘛。

本来想写点完整的东西，最后光是找软件下载体验去了。。。。。。。遗憾，遗憾


