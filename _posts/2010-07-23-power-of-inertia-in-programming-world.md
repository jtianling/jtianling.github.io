---
layout: post
title: "编程世界中惯性的力量"
categories:
- Lua
- "随笔"
tags:
- Lua
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '24'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

Lua发布包中的lua51.dll是个代理，源于一个历史命名错误。为了兼容性，这个“不幸的决定”只能延续。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

今天下载lua的Windows二进制发布[luabinaries](<http://luabinaries.sourceforge.net/> "luabinaries")的时候，发现luabinaries的发布包含两个dll,lua5.1.dll,lua51.dll，其中lua5.1.dll大小合适，lua51.dll只有11K，感觉不像是个有用的lua dll，对此比较不解，查看了luabinaries的文档，

文档中如此解释：

The LuaBinaries DLL packages have a dll proxy called "lua51.dll". It can be used to replace other "lua51.dll" released by other distributions. It will simply forward calls to the "lua5.1.dll". There is no compiled source code involved in the forwarding.

也就是说，lua51.dll完全是一个lua5.1.dll的代理类，没有任何实际的代码，仅仅是做一个到lua5.1.dll的forwarding。

不过文档解释了lua51.dll是什么，却没有解释为啥会需要一个这样的东西呢？我还从来没有见过类似的情况。要说有一点点类似的情况的话，也是以前做反外挂的时候，知道可以通过替换现有的dll，并且完全模拟原来dll的接口，并将不需要hack的函数全部forwarding到原来的dll中。对于lua怎么会需要这样的功能呢？

于是我google了一下，发现了原因：
The standard DLL name "lua51.dll" has been selected more than

three years ago. Around twice every year someone comes along and

thinks "Oh, we absolutely need a dot in the DLL version number".

Alas, Windows does not like an extra dot in there. Many things

break when you have an extra dot in DLL names. Depends on the

version of the OS, on the specific system call, on the library or

tool used ... it's hopeless. So please let's forget about it.

--Mike

来自lua-users.org的[一个帖子](<http://lua-users.org/lists/lua-l/2008-06/msg00084.html> "一个帖子")。

原来是3年前有人确定了一个lua51.dll名字的动态库，并且，有人觉得我们非常需要在5和1之间加一个点，不然lua的5.1版岂不是看成lua的51版了？

对此，有人进一步提出了[疑问](<http://lua-users.org/lists/lua-l/2008-06/msg00087.html> "疑问")，认为这个问题怎么这么久了竟然没有人修复？

接着有人回答了：
But who's duty is to resolve the issue?

It's clearly not an issue of Lua as a language. It's just a consequence of (a very popular) LuaBinaries once releasing lua5.1.dll that became a de facto binary standard, then authors of many third-party Lua libraries were releasing binary packages compatible with LuaBinaries.

Note: I'm not blaming LuaBinaries; that was just one unfortunate decision that is difficult to be undone. --
Shmuel

我们知道了：

LuaBinaries做出了一个错误的决定，但是已经发布了，很多第3方的库也发布了，并且依赖于LuaBinaries的这个lua51.dll，于是：
that was just one unfortunate decision that is difficult to be undone.

那仅仅是一个过去做下，现在难以撤销的不幸决定。。。。。。。。。。。。

有的东西存在了，即使是不合理的存在，因为它存在了一段时间了，因为惯性，它还会存在在那里。编程中，这种情况经常出现。突然让我想起上个项目中，大家经常对项目中蹩脚代码存在原因的解释："历史原因"。

对于代码来说，即使大家都知道可以重构，但是重构是有代价的，很多时候大家就妥协在历史原因当中。

对于语言来说，C++就是对历史进行最大妥协而产生的语言，大家都承认，假如当年C++不兼容C的话，C++根本就得不到现在这样的流行程度，也都承认，因为C++兼容C，（常常被称为历史的包袱）C++在语言的优美程度上损失了太多。

想起国内某个大牛有过类似的感慨，"现在每做一个设计决定的时候都非常小心，因为那可能会被使用非常非常长的时间，当它还能正常工作的时候，甚至不会有人想要去重写它"

呵呵，仅仅将这个有趣的事件作为编程中的一个轶事来看吧。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
