---
layout: post
title: VMWare虚拟机安装，SoftIce在虚拟机中的安装
categories:
- "未分类"
tags:
- SoftIce
- VMWare
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

# VMWare虚拟机安装，SoftIce在虚拟机中的安装  
  
  
  

**_write by_**** _九天雁翎(JTianLing) -- www.jtianling.com_**

先来个开胃菜，为了安全起见（太多的破解工具都感觉不一定可靠，主要是来源。。。。）  
还是用虚拟机比较安全，假如不想重复的开机关机及重装系统的话。  
    

VMWare算是比较好的虚拟机了，虚拟机的领军人物。  
我 安装的是“虚拟先锋”的绿色版，解压，点击绿化批处理文件就可以完成安装。然后新建一个虚拟机，配置一下内存，硬盘空间，像普通电脑一样安装系统就完了，  
安装完不要忘了克隆一个来备份。安装系统的时候，VMWare有个好用的设置是从镜像（ISO等）来安装，这个只要在光驱的设置中选择就好了，非常的方 便。

要想SoftIce在VMWare中正常使用，花费的功夫就需要多一点了。  
1.首先的安装VMWare Tools，这在客户端虚拟机启动的时候，选择VMWare的虚拟机菜单，选择安装VMWare Tools就可以安装了。（碰到过点击没有反应的情况，这个时候你可以选择在Host载入VMWare安装盘下的windows.iso镜像，那么也就可  
以在客户端虚拟机安装了，这是windows版的VMWare Tools，不过要说明的是，不要在你虚拟出来的机器上装DaeMon,就我实验，那样会和SoftIce冲突，据说3.9以下版本不会，你可以去试 试）。  
2.安装SoftIce或者Driver Studio，反正都包含有SoftIce,选择显卡的时候，配置不需要改动，只是点击Test试试，只要第一步没有问题，这时候test应该也可以成功，没有第一步的话必然失败。  
3.关闭虚拟机，打开虚拟机的配置文件（你新建的虚拟机所在的目录），VMX后缀的文件，在最后添加  
vmmouse.present = "FALSE"  
svga.maxFullscreenRefreshTick = "5"  
两行，再重新启动，选择开始菜单中SoftIce的Start  
SoftIce，然后就可以按CTRL-D看看是否能够正常运行了，应该没有问题。

 

**_write by_**** _九天雁翎_**** _(JTianLing) --  
blog.csdn.net/vagrxie_**
