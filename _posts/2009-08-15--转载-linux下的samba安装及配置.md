---
layout: post
title: "【转载】linux下的samba安装及配置"
categories:
- Linux
tags:
- Linux
- Samba
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

以前配置samba一直是我的噩梦，甚至一度放弃samba，直接使用ssh+winscp来管理文件，今天找到一篇好文，顺利配置成功，感谢原作者。

在Ubuntu中设置samba共享可读写文件夹 收藏   
首先当然是要安装samba了，呵呵： 代码:   
sudo apt-get install samba sudo apt-get install smbfs   
下面我们来共享群组可读写文件夹，假设你要共享的文件夹为： /home/ray/share 首先创建这个文件夹 代码:   
mkdir /home/ray/share chmod 777 /home/ray/share   
备份并编辑smb.conf允许网络用户访问 代码:   
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf_backup sudo gedit /etc/samba/smb.conf   
搜寻这一行文字 代码:   
; security = user   
用下面这几行取代 代码:   
security = user username map = /etc/samba/smbusers   
将下列几行新增到文件的最后面，假设允许访问的用户为：newsfan。而文件夹的共享名为 Share 代码:   
[Share] comment = Shared Folder with username and password path = /home/ray/share public = yes writable = yes valid users = newsfan create mask = 0700 directory mask = 0700 force user = nobody force group = nogroup available = yes browseable = yes   
然后顺便把这里改一下，找到［global］把 workgroup = MSHOME 改成 代码:   
workgroup = WORKGROUP display charset = UTF-8 unix charset = UTF-8 dos charset = cp936   
后面的三行是为了防止出现中文目录乱码的情况。其中根据你的local，UTF-8 有可能需要改成 cp936。自己看着办吧。 现在要添加newsfan这个网络访问帐户。如果系统中当前没有这个帐户，那么 代码:   
sudo useradd newsfan   
要注意，上面只是增加了newsfan这个用户，却没有给用户赋予本机登录密码。所以这个用户将只能从远程访问，不能从本机登录。而且samba的登录密码可以和本机登录密码不一样。 现在要新增网络使用者的帐号： 代码:   
sudo smbpasswd -a newsfan sudo gedit /etc/samba/smbusers   
在新建立的文件内加入下面这一行并保存 代码:   
newsfan = "network username"   
如果将来需要更改newsfan的网络访问密码，也用这个命令更改 代码:   
sudo smbpasswd -a newsfan   
删除网络使用者的帐号的命令把上面的 -a 改成 -x 代码:   
sudo testparm sudo /etc/init.d/samba restart   
最后退出重新登录或者重新启动一下机器。

本文来自CSDN博客，转载请标明出处：<http://blog.csdn.net/joliny/archive/2008/07/13/2646420.aspx>

 

另外还有两篇备用的：

第一篇：

以root根用户进行操作，如果您不是，请在每条命令前加上sudo

步骤1:安装samba   
#apt-get install samba   
#apt-get install smbfs 

步骤2:添加linux用户   
#useradd user1 //添加用户名user1   
#passwd user1 //给用户名user1添加密码   
#mkdir /home/user1 //建立user1的home目录，如果不用这个用户名来登陆linux，此步骤不是必需   
#chown -R user1:user1 /home/user1 //给user1的home目录设置好权限

步骤3：给samba服务器添加用户   
说明：登陆samba的用户必须已经是linux中的用户   
#smbpasswd -a user1 //添加并给user1设置samba密码

步骤4：smb.conf设置   
#cd /etc/samb //进入设置目录   
#mv smb.conf smb.conf.bak //做好备份，直接将系统默认配置文件改名   
#vim smb.conf //建立和配置smb.conf文件

[global]   
workgroup=x1 //X1为你局域网中的工作组名   
server string=x2 //x2为你linux主机描述性文字，比如：samba server。   
security=user //samba的安全等级，user代表需要输入用户名和密码，改成share则不需要输入用户名和密码

[x3] //方框号中的x3这个名字可以随便取，只是在win的网上邻居中显示的共享文件夹名   
path=/home/x4 //x4为你要共享的文件夹名，在共享前还要建立这个文件夹，并设好权限以便访问，下面会说明。   
valid users=user1 //这个x4共享目录只允许user1这个用户进入   
public=no //no表示除了user1这个用户，其它用户在进入samba服务器后看不见x4这个目录，如果为yes，虽然能看见x4这个目录，但除了user1这个用户能进入这个目录，其它人进不了。   
writable=yes //允许user1在x4目录中进行读和写操作，反之no 

//存盘退出   
#testparm //检查一下语法错误，比如拼错

步骤5：建立共享目录   
#mkdir /home/x4   
#chown -R user1:user1 /home/x4 //因为是root建立的目录，其它用户只有读的权限，所还得把权限改一下。当然也可以简单的用#chmod 777 /home/x4。还有个问题就是共享里目录的文件如果有些能访问有些不能访问，那肯定也是权限的问题,进入/home/x4,直接#chmod 777 *来解决。

步骤6：重启samba服务   
#/etc/init.d/samba restart 

设置samba服务要注意以下两点（即两个两次）：   
1.添加两次用户：一次添加系统用户#useradd user1；再一次是添加samba用户#smbpasswd -a user1;   
2.设置两次权限：一次是在smb.conf中设置共享文件夹的权限：再一次是在系统中设置共享文件夹的权限#chmod 777 文件夹名。

 

按照楼主的做法设置, 用WINDOWS登陆到samba的时候报错, 显示如//10.x.x.x 无法访问, 你可能没有权限使用网络资源.... 这样的错误. 请问这是怎么回师? 

如果设置passdb backend = tdbsam 则可以访问

 

passdb backend = tdbsam   
用tdbsam的时候，密码文件是放在 /var/lib/samba/passdb.tdb 

而没有这句，当然也就找不到SMB用户和密码，即提示没用权限了。

 

第二篇：

#rpm -q samba     //查看SAMBA是否安装，如未安装，则执行下列安装

#rpm -ivh  samba-3.0.25b-0.4E.6.i386.rpm 

#vi /etc/services    //查看以netbios开头的是否可用，必须要全部可用

 

 

//linux防火墙要关闭

#ls /etc/samba //无smbpasswd文件

#smbpasswd -a tom //创建tom用户

#ls /var/log/samba //smb服务器的日志文件

#vi /etc/samba/smb.conf //编辑smb服务器的主配置文件

 

Workgroup = WORKGROUP //windows工作组名

server string = samba server //samba服务器简要说明

hosts allow = 192.168.1. 192.168.0. 127. //设置允许访问的子网，默认都允许，可不设置

hosts allwo = client1,alarm.com,192.168.16. EXCEPT 192.168.16.4 //举例说明

security = user //设置安全级，默认为user。五个级别分别为"share,user,server,domain,ads"

interfaces = eth0 //多网卡SAMBA服务器设置监听的网卡

interfaces = 192.168.16.177/24 //举例说明

wins support = yes //设置将samba服务器作为wins服务器，默认不使用

 

//wins服务器由微软开发，功能是将NetBIOS名称转换为对应的ip地址

username map = /etc/samba/smbusers //去掉前面的;号，用于用户映射

然后编辑文件/etc/samba/smbusers，将需要映射的用户添加进去，格式为

单独的linux用户 = 要映射的windows用户列表

例： test = alarm back //test用户对应windows下的alarm和back两个用户

encrypt password = yes 或 no //yes表示采用加密方式发送密码，no为不采用

若此项为no,则windows系统必须响应的修改注册表项，注册表文件存放在/usr/share/doc/samba-2.2.7a/docs/Registry下

 

[homes] //设置共享目录

comment = Home Directories //简要说明

browseable = no //是否允许用户浏览所有人的主目录

writable = yes //是否允许用户写入自己的主目录

 

[share] //设置一个共享目录

comment = Samba's share Directory //简要说明

read list = test //只读用户或组

write list = @share //可写用户或组

path = /home/share //共享文件夹目录路径

 

//设置共享目录后需要做以下操作

1.root登录，使用命令groupadd share 建立share组，并用usermod -g share abc命令将abc用户添加到share组

2.mkdir /home/share在/home下建立目录share

3.chown :share /home/share设置share目录所属组为share组，chmod 777 /home/share 设置share组对该目录有最大权限

:wq //保存退出

 

 

#testparm //测试smb.conf文件是否有语法错误

#su - //切换root用户

#service smb start restart stop //启动 重启 停止samba服务器

#ntsysv //设置samba服务器开机启动
