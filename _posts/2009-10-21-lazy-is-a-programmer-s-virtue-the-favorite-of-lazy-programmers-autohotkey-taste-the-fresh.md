---
layout: post
title: "懒惰是程序员的美德! 懒惰程序员的最爱AutoHotkey 尝鲜"
categories:
- "未分类"
tags:
- AutoHotkey
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '38'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

### 懒惰是程序员的美德! 懒惰程序员的最爱AutoHotkey 尝鲜

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)******** __**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

Don’t Repeat yourself在编程领域成为DRY原则，是知道我们编写强壮代码的重要指导原则之一，但是，事实上在其他领域也是一样的（我也不知道此原则是否最先出现在编程领域）。Larry Wall的懒惰是程序员的美德的话我是记忆深刻。作为一个对计算机着迷，对程序无比投入的人，深知学海无涯，但是，正是因为学无止尽，更迫切的需要我们做追求效率的程序员，将重复的工作交给最擅长做重复工作的电脑去做，只有这样，我们才能将更多的时间节省下来，去干我们自己想干的事情。（虽然工作时不太可能-_-!但是起码能赢得一句手快的评价，再次-_-!）学习VIM，Bash，Python，Lua，Qt，SQL都是如此，在这条路上已经走了这么远的我们，又何惧为了更加提高效率，再多学AutoHotkey这样一个小工具呢？既然选择了远方，就只顾风雨兼程，既然选择了编程，就只能忘了远方。-_-!敲自己的键盘，让别人走路去吧。

[AutoHotkey](<http://www.autohotkey.com/>)的名字大家说不上如雷贯耳，久仰大名，起码也是早有耳闻了吧。让我们不惧艰险（又是一种脚本语言-_-!）将AutoHotkey作为饭后甜点好好品尝一下吧吧^^

## AutoHotkey是什么

AutoHotkey简单来说是一个附带键盘宏录制的脚本工具，但是因为功能太过强大了，叫做自动化工具也许较为合适。从自动化工作这一点来看，AutoHotkey类似Linux下的Bash，都不以脚本语言的逻辑表达能力取胜，专门针对自动化工作设计，只不过Bash是命令行下的，对窗口一无所知，而AutoHotkey可以说是专门针对Windows的窗口平台的，有对快捷键和窗口环境的强大支持。（我见人将其称作GUI-Scripting，实在贴切）也许可以说AutoHotkey就是GUI环境下的Bash。既然Linux下Bash是必学的（的确应该学），那么AutoHotkey也就顺便学了吧。

## 安装配置

下载安装我就不多说了，真的不知道这里有个地址可以去[看看](<http://xbeta.info/autohotkey-guide.htm>)。善用佳软的AutoHotkey 0级教程，顺便推荐下[善用佳软](<http://xbeta.info/>)，推崇并介绍了很多好用的免费软件，个人很喜欢。

AutoHotkey的脚本是以ahk为后缀的文本文件，用你自己最喜欢的编辑器编辑吧，对于vim来说，已经内置了对ahk的语法高亮，我习惯将AutoHotkey的安装目录添加进环境的PATH中，这样用vim编辑脚本的时候可以直接简单的通过!Autohotkey %来运行脚本。（事实上我将其map到了F5上）但是愿意的话，其实.ahk文件在AutoHotkey安装后是与其关联的，直接双击也可以运行此脚本。

## 初步

首先编个最简单的脚本，看看效果先。

Run <http://www.jtianling.com>

将上一行的代码保存成文本，双击运行，或者用autohotkey运行之，会自动开启你机器上的默认浏览器登录我的博客，建议大家每天运行100次以上^^这个功能有点像Python的os模块的startfile函数，通过解析后面的字符串来判断应该使用什么与其关联的程序运行。当年工作的时候我有个开机脚本就是用Python此函数做的，功能就是开启工作需要的一大堆程序，VS,MSDN,TotalCommand自动一个一个开启并打开合适的工程或目录。现在这个功能也可以交由autohotkey来完成了。就是一条Run命名。

相对来说，对于特定用途的工具（比如Bash，autohotkey）来完成其擅长的事情是会比通用工具（比如Python）来的简洁的，此即一例，Python中虽然也能完成这样的工作（在没有学习Bash前，在linux下它都是我的脚本工具），但是，需要进行import模块，函数调用等一堆难看的东西，autohotkey只需要一个Run。这里之所以讲的多点，是想说明一个特定工具哪怕并不是完成了什么不可能完成的任务，也许仅仅是将任务完成的更加简洁高效和优雅，也是一个工具的用途体现。至于值不值得为了这份优雅付出学习的代价，那就见仁见智了。

再看个例子：

Run c:/DirTest.txt

此脚本会自动的用你机器配置的文本编辑器开启此文件。（文件必须存在）

但是以下脚本

Run notepad.exe c:/DirTest.txt

无论文件存在不存在都会开始记事本，其中的区别，大家自己体会一下。事实上解析的强度比一般人能够想象的还要厉害，帮助文件中有这个示例：

Run [mailto:someone@somedomain.com](<mailto:someone@somedomain.com>)

呵呵，什么意思大家都知道，牛吧。可惜我一般不用客户端写邮件-_-!

## 快捷键

AutoHotkey自然对Hotkey又特别支持啦，脚本中用符号表示快捷键，一次排列，几个常见的修饰键对应符号是**#Win, !** Alt，**^** Control，**+** Shift。那么什么叫依次排列呢？看下面的例子。

#space::Run <http://www.jtianling.com>

以上的例子即将Win + space 键设定为访问我的博客，运行后发现没有直接的反应，不像上述例子，此时AutoHotkey以trayicon小图标的形式运行于右下角，当你输入Win + space的时候会触发其运行默认的浏览器开启网站，并且一直有效，直到你将其关闭。（此例也推荐大家每日运行100遍^^与前面第一个例子结合交叉运行效果更佳）同理，要ctrl+space就是^space，要ctrl+alt+space就是^!space。

事实上，一个快捷键可以对应多个命令，也可以多个快捷键对应一个命令，格式有点不多，见下例。

```ahk
#space::
Run http://www.jtianling.com
Run http://hi.csdn.net/vagrxie
return
```

```ahk
#^a::
#^b::
Run http://www.jtianling.com
return
```

此例即是在按下Win + space时打开我的CSDN博客和空间两个网页，并且CTRL + WIN + A与CTRL + WIN + B都是打开我的博客。举这两个例子主要是告诉大家AutoHotkey的格式相对比较灵活，比如这里的一对多和多对一。当不是一对一并且写在一行时，需要以return来表示脚本的结束。

## 信息窗口

这也许是最先应该说的，MsgBox

MsgBox Text

即可以通过MessageBox弹出Text的信息，比较方便

可以通过MsgBox弹出Yes Or No等选项，并获取，以判断分支执行程序。

```ahk
MsgBox, 4,?,Yes or No?
ifMsgBox Yes
MsgBox You Said Yes!
else
MsgBox You Said No?
```

分支执行的语法比较奇怪，通过if结合MsgBox构成一个IfMsgBox特别应对MsgBox的选择。

## 对窗口的控制

个人感觉，对窗口的控制是AutoHotkey的精髓所在，这也是为什么我将其比作GUI下的bash。这里我还是通过从简单到复杂的例子来描述。比如，我现在在编辑文档的时候常常会需要打开AutoHotkey的帮助文档查看，一般我的操作是用鼠标点击其最小化的窗口以激活，或者我也会需要开启gvim以编辑示例程序，也是需要用鼠标去激活，因为用atl+Tab的方式还不如用鼠标快，有了AutoHotkey，我们就有更方便的Hotkey去完成这样的任务了。

```ahk
SetTitleMatchMode 2
#tab::
ifWinNotExist, GVIM
{
    MsgBox GVIM is not running
    return
}
IfWinNotActive,GVIM
    WinActivate,GVIM
else
    WinActivate,Windows Live Writer
return
```

如上脚本，先判断是否有标题包含GVIM的窗口存在，不存在则报告GVIM没有运行，不然WIN+TAB键的效果就是在GVim与Windows Live Writer之间切换，非常方便。ifWinNotExist如其名，用于判断一个窗口是否存在，ifWinNotActive也如其名用于判断一个窗口是否激活，第一个参数都是表示窗口标题文字的匹配，匹配模式由SetTitleMatchMode决定。

**1** : A window's title must start with the specified _WinTitle_ to be a match.   
**2** : A window's title can contain _WinTitle_ anywhere inside it to be a match.   
**3** : A window's title must exactly match _WinTitle_ to be a match.

我们使用的是2，表示任意位置都匹配，默认是1，速度最快，必须是开始位置匹配。if一组的函数都还支持其他参数，具体的请查看帮助文档了，我这里主要是展示一下用途。

实际上AutoHotkey对窗口的控制还有很多强大的功能，一篇小文无法一一尽数，这里再举个例子：

```ahk
SetTitleMatchMode 2
Loop, 10
{
    Random, x, 0, 50
    Random, y, 0, 50
    WinMove,GVIM,, %x%, %y%
    WinHide,GVIM
    Sleep, 100
    WinShow,GVIM
}
```

上述程序运行后，GVIM窗口会变的疯狂。。。WinMove,WinHide,WinShow的意思都很明显，分别是移动，隐藏，显示窗口，这里有两个有新意的地方，一个是Random和x,y，有点编程知识的人都看出来了，AutoHotkey是允许设定变量的，此处的x,y就是，引用变量的方式是前后各1个百分号，与windows批处理程序的一样。另外就是Loop,10表示的循环结构了。

## 操作记录器

这个功能有点像国内一个也比较强大的软件键盘精灵的功能（当年玩那种泡菜网络游戏没有少用过它，单纯的键盘鼠标模拟功能不比AutoHotkey差），就是将键盘鼠标操作记录下来，自动生成AutoHotkey的脚本。省去了重复工作的脚本编写之苦。带GUI界面，截图如下：

[![image](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_image_thumb_633917609499527500.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_image_2_633917609392965000.png>) 点击左上角的Record按钮就开始记录键盘鼠标的操作了。然后通过点击录制时屏幕左上角的Stop停止录制。上面的脚本是我录制的一段激活Windows live Writer和最小化Windows live Writer的过程。

```ahk
WinWait, ,
IfWinNotActive, , , WinActivate, ,
WinWaitActive, ,
MouseClick, left, 1159, 889
Sleep, 100
WinWait, xfsdlaf.ahk (E:/work) - GVIM
IfWinNotActive, xfsdlaf.ahk (E:/work) - GVIM, , WinActivate, xfsdlaf.ahk (E:/work) - GVIM
WinWaitActive, xfsdlaf.ahk (E:/work) - GVIM
MouseClick, left, 908, 17
Sleep, 100
WinWait, ,
IfWinNotActive, , , WinActivate, ,
WinWaitActive, ,
MouseClick, left, 33216, 32891
Sleep, 100
WinWait, Don’t Repeat yourself 懒惰是程序员的美德 AutoHotkey 尝鲜 - Windows Live Writer
IfWinNotActive, Don’t Repeat yourself 懒惰是程序员的美德 AutoHotkey 尝鲜 - Windows Live Writer, , WinActivate, Don’t Repeat yourself 懒惰是程序员的美德 AutoHotkey 尝鲜 - Windows Live Writer
WinWaitActive, Don’t Repeat yourself 懒惰是程序员的美德 AutoHotkey 尝鲜 - Windows Live Writer
MouseClick, left, 1362, 10
Sleep, 100
MouseClick, left, 1387, 10
Sleep, 100
```

会发现自动生成的代码较人工的代码还是乱了很多-_-!机器嘛，不是那么聪明。上面代码很重要的一个就是通过MouseClick来模拟鼠标的点击，有了这个功能，想干什么都可以了………………顺便提及一下，也可以通过

Send Keys   
SendRaw Keys   
SendInput Keys   
SendPlay Keys   
SendEvent Keys

来模拟键盘的输入。下面是一个当你暂时离开机器却有不想锁屏时可以提出警告的脚本。：）

```ahk
SetTitleMatchMode 2
SetKeyDelay 50
Words = WARNING{!} DO NOT OPERATE MY COMPUTER{!}

KeyWait, LButton, D
run,gvim YouAreUnderMonitored,,Max
WinWait,YouAreUnderMonitored
Send i%Words%{Esc}
```

此脚本等待鼠标左键单击，然后自动开启gvim并最大化，然后一个字一个字输入警告信息^^不明就里的人一看估计碰鬼了。

## 小结

对于AutoHotkey这样强大的东西，一篇3000来字的小文实在是无法详细尽数其功能，而本人的目的也就是提供给觉得AutoHotKey复杂而不去学习的人尝个鲜，知道了AutoHotkey没有那么难以后，伴随着使用，参考着帮助文档，慢慢的会发现AutoHotkey也是一个离不开的工具了。我就在网上看到很多人狂喊，Linux下什么都好，就是没有AutoHotkey-_-!（其实类似的言论非常多，比如也没有Windows Live Writer equivalent）

原创文章作者保留版权 转载请注明原作者 并给出链接****

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

****