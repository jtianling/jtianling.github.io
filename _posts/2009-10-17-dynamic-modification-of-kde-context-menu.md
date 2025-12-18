---
layout: post
title: KDE上下文菜单的动态修改
categories:
- Linux
tags:
- KDE
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

**KDE 上下文菜单的动态修改**

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

# 一、   提要

事实上静态改变KDE上下文菜单网上还有些资料（以E文为主），但是动态改变的我连E文的资料都没有看到，纯靠自己看代码摸索了。行文会比较乱，但是需要的人应该能找到自己所要的东西。文中复杂的行解释时会与KDE源代码相对应，以做备查。本文操作环境是kubuntu9.04

 

# 二、   静态修改

KDE中的上下文菜单是以.desktop形式的配置文件方式来管理的。此配置文件强大到甚至支持多语言-_-!牛吧

首先查看系统中此配置文件所在的位置。通过 _kde4-config –path services_命令来查看，下面是我机器中运行的例子：

```bash
jtianling@jtianling-laptop:~$ kde4-config --path services

/home/jtianling/.kde/share/kde4/services/:/usr/share/kde4/services/
```

即有kde4 services配置的地方分别在/home/jtianling/.kde/share/kde4/services/这个个人的目录和/usr/share/kde4/services/这个改变全局配置的目录。这点符合Linux的习惯，在没有root权限或者仅仅想改变自己的操作习惯时，在自己的home目录下就能改变自己的配置，有root权限并且想改变所有用户的配置时，去/usr下面改。此处如是，这里全部以修改全局的为例。想尝试的推荐首先备份。

首先进入services目录下的ServiceMenus这个与上下文菜单相关的配置目录中去。

我们从一个简单的例子开始，下面是Kubuntu 9.04中自带的一个简单菜单项，类似于windows下常用的command prompt Here和cygwin的bash prompt here，作用是在当前文件夹位置打开一个konsole。对应的文件是konsolehere.desktop：

```ini
[Desktop Entry]  
**Type** =Service  
**X-KDE-ServiceTypes** =KonqPopupMenu/Plugin,inode/directory  
**Actions** =openTerminalHere;  
**X-KDE-AuthorizeAction** =shell_access

[Desktop Action openTerminalHere]  
**Name** =Open Terminal Here  
………  
**Name**[zh_CN]=在此打开终端  
**Name**[zh_TW]=在這裡開啟終端機  
**Icon** =utilities-terminal  
**Exec** =konsole --workdir %f  
**X-Ubuntu-Gettext-Domain** =desktop_kdebase
```

 

一个一个解释一下：

配置的方式就与普通的ini文件类似，[]用于分段，xxx=yyy用于配置。这里解释一下配置选项。

 

**Type** =Service

官网说是类型默认为application，还解释application是有Exec行的东西（原话为：i.e. something with Exec line）需要指定Service表示类似于插件的东西，事实上我在我的机器上，将services目录所有的desktop文件全部统计了一下：

```bash
grep –R –e ‘Type=S’ * wc –l

一共有822个Service，但是

grep –R –e ‘Type=^S’
```

一个也没有，所以，直接将此行默认存在就完了。

 

**X-KDE-ServiceTypes** =KonqPopupMenu/Plugin,inode/directory

还是参考一有说明，KonqPopupMenu/Plugin表示是Konqueror的插件，inode/directory表示在指定目录或目录中的时候也有效。

还可以用all/all，all/allfiles表示所有文件，以逗号分隔。

 

**Actions** =openTerminalHere;

标明动作，由接下来的[Desktop Action openTerminalHere]分段具体说明

 

**X-KDE-AuthorizeAction** =shell_access

很明显，所要的权限，此处为shell_access

 

[Desktop Action openTerminalHere]

新的分节，后面的openTerminalHere与前面定义的动作一致，整个分节是对此动作的一个详细说明。

 

**Name** =Open Terminal Here

说明显示的菜单的名字，通过**Name**[zh_CN]这样的形式支持多语言版本

 

**Icon** =utilities-terminal

指定图标

 

**Exec** =konsole --workdir %f

指定菜单命令

上述的东西都不是关键，也不算什么难点，下面真的好戏登场了。

 

# 三、   动态修改

这在KDE中算是新鲜课题，一则少有人知，甚至没有找到E文资料，二则我看到在KDE的changelog中竟然提到kdesvn的作者发现了其中有一些问题。（见[http://www.kde.org/announcements/changelogs/3_5_6/kdelibs.txt](<http://www.kde.org/announcements/changelogs/3_5_6/kdelibs.txt>)）说明平时用的人估计也少。要不是有kdesvn作者走在前面，我连看源代码的头绪都没有，向Rajko Albrecht致敬。

下面是kdesvn的配置片段：

```ini
[Desktop Entry]

Type=Service

ServiceTypes=KonqPopupMenu/Plugin,inode/directory,all/all,all/allfiles

X-KDE-Submenu=Subversion (kdesvn)

X-KDE-GetActionMenu=org.kde.kded /modules/kdesvnd org.kde.kdesvnd getActionMenu

Actions=Log;Info;Add;Addnew;Delete;Revert;Rename;Import;Checkout;Switch;Merge;Blame;CreatePatch;Export;Diff;Update;Commit;Checkoutto;Exportto;Tree;
```

      

其他的都好说了，主要的问题在X-KDE-GetActionMenu=org.kde.kded /modules/kdesvnd org.kde.kdesvnd getActionMenu一句，kdesvn也就是靠此句实现了动态的上下文菜单。

从应用上看，对于非svn工程的目录，在平时显示的是Checkout from a repository和Export from a subversion repository，而Actions里面也有，而Actions里面还有当目标的确是一个svn工程的目录时的一大堆选项。说明事实上选项是通过某个函数进行筛选然后显示的。看上面的配置，很显然是X-KDE-GetActionMenu配置的getActionMenu函数（从命名上猜的），通过关键字，我定位到了关键的KDE源代码：

kdelibs/kio/kio/kdesktopfileactions.cpp:219开始

```cpp
QList<KServiceAction> KDesktopFileActions::userDefinedServices( **const**  KService& service, **bool**  bLocalFiles, **const**  KUrl::List & file_list )  
{  
    QList<KServiceAction> result;

    **if**  (!service.isValid()) // e.g. TryExec failed  
        **return**  result;

    QStringList keys;  
    **const**  QString actionMenu = service.property("X-KDE-GetActionMenu", QVariant::String).toString();  
    **if**  (!actionMenu.isEmpty()) {  
        **const**  QStringList dbuscall = actionMenu.split(QChar(' '));  
        **if**  (dbuscall.count() >= 4) {  
            **const**  QString& app       = dbuscall.at( 0 );  
            **const**  QString& object    = dbuscall.at( 1 );  
            **const**  QString& interface = dbuscall.at( 2 );  
            **const**  QString& function  = dbuscall.at( 3 );

            QDBusInterface remote( app, object, interface );  
            // Do NOT use QDBus::BlockWithGui here. It runs a nested event loop,  
            // in which timers can fire, leading to crashes like #149736.  
            QDBusReply<QStringList> reply = remote.call(function, file_list.toStringList());  
            keys = reply;               // ensures that the reply was a QStringList  
            **if**  (keys.isEmpty())  
                **return**  result;  
        } **else**  {  
            kWarning(7000) << "The desktop file" << service.entryPath()  
                           << "has an invalid X-KDE-GetActionMenu entry."  
                           << "Syntax is: app object interface function";  
        }  
    }

    // Now, either keys is empty (all actions) or it's set to the actions we want

    foreach(**const**  KServiceAction& action, service.actions()) {  
        **if**  (keys.isEmpty() || keys.contains(action.name())) {  
            **const**  QString exec = action.exec();  
            **if**  (bLocalFiles || exec.contains("%U") || exec.contains("%u")) {  
                result.append( action );  
            }  
        }  
    }

    **return**  result;  
}
```

 

源码可以看出，其一，我们分析配置文件没有错误，此行的确是关键，其二，获取具体字符串的方式利用了D-bus这个进程间通信手段远程调用了getActionMenu这个函数，然后获取到了一个字符串list，此list就是我们最后看到的菜单项。至此，一切问题已经得到解决，动态菜单的关键就是以X-KDE-GetActionMenu配置然后通过D-bus调用函数。D-bus作为Linux下非常流行的进程间通信手段就远没有KDE动态菜单这么神秘了，资料丰富的多，需要的就自己去查阅吧。

 

# 四、   参考资料

1.KDE tech base，Konqueror Service Menu相关章节：

http://techbase.kde.org/Development/Tutorials/Creating_Konqueror_Service_Menus

[](<http://code.google.com/p/jtianling/source/browse?repo=blog-sample-code>)

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)