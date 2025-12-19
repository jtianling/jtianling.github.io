---
layout: post
title: "【转载】ubuntu搭建ssh服务器"
categories:
- Linux
tags:
- SSH
- Ubuntu
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '11'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文是一份Ubuntu服务器SSH安装配置指南，详细介绍了从网络设置、安装openssh-server，到配置证书认证以实现安全便捷远程登录的全过程。

<!-- more -->

昨天的文章里，我记录了[搭建一个小型 Ubuntu 服务器的过程](<http://blog.istef.info/2008/10/02/build-a-linux-light-server/>)，相信如果各位按照我写的做了，您的 Ubuntu Server 已经可以跑起来了。不过，现在这个系统只是个基本的系统，算不上服务器，因为什么都没法做。如果需要让它行使服务器的职能，还需要给它装一些软件。

因为我需要的服务器最终会被“抛弃”在实验室的某个角落，无论是后期设置还是维护的需要，都必须安装一个远程管理的工具。在 Linux 系统中，不二的选择就是 openssh 了。在 Ubuntu 中安装 openssh 实在是再简单不过的一件事情了，下面的内容也只是纯记录，给我这个菜鸟备个份。如果是高手直接绕过就好。

### 安装前的准备

Ubuntu 之所以好用，就是因为它继承了 debian 的 apt 系统，这一点相信您在昨天装系统的教程中已经感受到了。但是 apt 需要依赖网络，昨天我们装好的系统是暂时上不了网的，我们需要先设置一下。

首先，激活服务器的网卡，命令如下：

> sudo nano /etc/network/interfaces

在 interfaces 中添加以下内容：

```conf
    auto eth0
    iface eth0 inet static
    address _202.113.235.181_
    netmask _255.255.255.0_
    gateway _202.113.235.1_
```

这其中，斜体部分标注的 IP 地址是我服务器的设置，您需要根据您的具体情况修改。当然，如果您的服务器使用的是 DHCP 来分配 IP 地址，只需要写上 iface eth0 inet dhcp 就可以了，无需设置 address/netmask/gateway。

然后，修改 resolv.conf 配置 DNS 服务器：

> sudo nano /etc/resolv.conf

添加您的 DNS 服务器地址：

```conf
    nameserver _202.113.16.10_
    nameserver _202.113.16.11_
```

完成后，重新启动 networking 服务：

> sudo /etc/init.d/networking restart

这样应该就可以连通网络了。如果您使用的是 ADSL，可能还需要装上 pppoe 之类的东西，考虑到服务器很少用这样的配置，这里就不讨论了，需要的话可以在网上查找。

### 安装和设置 OpenSSH Server

Ubuntu 下安装 OpenSSH Server 是无比轻松的一件事情，需要的命令只有一条：

> sudo apt-get install openssh-server

随后，Ubuntu 会自动下载并安装 openssh server，并一并解决所有的依赖关系。当您完成这一操作后，您可以找另一台计算机，然后使用一个 SSH 客户端软件（强烈推荐 PuTTy），输入您服务器的 IP 地址。如果一切正常的话，等一会儿就可以连接上了。并且使用现有的用户名和密码应该就可以登录了。

事实上如果没什么特别需求，到这里 OpenSSH Server 就算安装好了。但是进一步设置一下，可以让 OpenSSH 登录时间更短，并且更加安全。这一切都是通过修改 openssh 的配置文件 sshd_config 实现的。

首先，您刚才实验远程登录的时候可能会发现，在输入完用户名后需要等很长一段时间才会提示输入密码。其实这是由于 sshd 需要反查客户端的 dns 信息导致的。我们可以通过禁用这个特性来大幅提高登录的速度。首先，打开 sshd_config 文件：

> sudo nano /etc/ssh/sshd_config

找到 GSSAPI options 这一节，将下面两行注释掉：

```conf
    #GSSAPIAuthentication yes
    #GSSAPIDelegateCredentials no
```

然后重新启动 ssh 服务即可：

> sudo /etc/init.d/ssh restart

再登录试试，应该非常快了吧 ![:\)](http://blog.istef.info/wp-includes/images/smilies/icon_smile.gif)

### 利用 PuTTy 通过证书认证登录服务器

SSH 服务中，所有的内容都是加密传输的，安全性基本有保证。但是如果能使用证书认证的话，安全性将会更上一层楼，而且经过一定的设置，还能实现证书认证自动登录的效果。

首先修改 sshd_config 文件，开启证书认证选项：

```conf
    RSAAuthentication yes
    PubkeyAuthentication yes
    AuthorizedKeysFile %h/.ssh/authorized_keys
```

修改完成后重新启动 ssh 服务。

下一步我们需要为 SSH 用户建立私钥和公钥。首先要登录到需要建立密钥的账户下，这里注意退出 root 用户，需要的话用 su 命令切换到其它用户下。然后运行：

> ssh-keygen

这里，我们将生成的 key 存放在默认目录下即可。建立的过程中会提示输入 passphrase，这相当于给证书加个密码，也是提高安全性的措施，这样即使证书不小心被人拷走也不怕了。当然如果这个留空的话，后面即可实现 PuTTy 通过证书认证的自动登录。

ssh-keygen 命令会生成两个密钥，首先我们需要将公钥改名留在服务器上：

```bash
    cd ~/.ssh
    mv id_rsa.pub authorized_keys
```

然后将私钥 id_rsa 从服务器上复制出来，并删除掉服务器上的 id_rsa 文件。

服务器上的设置就做完了，下面的步骤需要在客户端电脑上来做。首先，我们需要将 id_rsa 文件转化为 PuTTy 支持的格式。这里我们需要利用 PuTTyGEN 这个工具：

点击 PuTTyGen 界面中的 Load 按钮，选择 id_rsa 文件，输入 passphrase（如果有的话），然后再点击 Save PrivateKey 按钮，这样 PuTTy 接受的私钥就做好了。

打开 PuTTy，在 Session 中输入服务器的 IP 地址，在 Connection->SSH->Auth 下点击 Browse 按钮，选择刚才生成好的私钥。然后回到 Connection 选项，在 Auto-login username 中输入证书所属的用户名。回到 Session 选项卡，输入个名字点 Save 保存下这个 Session。点击底部的 Open 应该就可以通过证书认证登录到服务器了。如果有 passphrase 的话，登录过程中会要求输入 passphrase，否则将会直接登录到服务器上，非常的方便。

好了，今天就写到这，以后逐步再写 AMP，Proftpd 和 Squid 的安装和设置。

**原文链接**：[花儿开了](<http://blog.istef.info/>) - [Ubuntu 服务器上 SSH Server 的安装和设置](<http://blog.istef.info/2008/10/02/setup-ssh-server-on-ubuntu-server/> "Permanent Link to Ubuntu 服务器上 SSH Server 的安装和设置")

** 本博客文章欢迎转载，但请务必保留原文链接！同时，本博文章不欢迎任何形式的派生及篡改，如需引用，请使用引用通告 - [http://blog.istef.info/2008/10/02/setup-ssh-se.../trackback/](<http://blog.istef.info/2008/10/02/setup-ssh-server-on-ubuntu-server/trackback/>)。商业网站使用请务必先取得作者授权！
