---
layout: post
title: "从源码编译新版OGRE 1.7.2 [Cthugha] for iphone/ipad"
categories:
- iOS
- "图形技术"
- "游戏开发"
tags:
- Ogre
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '24'
  ks_metadata: a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:0:"";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:0:"";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:0:"";s:6:"robots";s:12:"index,follow";}
  _edit_last: '1'
  _wp_old_slug: "%0d%0a%20%20%20%20%20%20%20%20%e4%bb%8e%e6%ba%90%e7%a0%81%e7%bc%96%e8%af%91%e6%96%b0%e7%89%88ogre%201-7-2%20%5bcthugha%5d%20for%20iphoneipad%0d%0a%20%20%20%20%20%20%20%20"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

新版本的Ogre(1.7.2)彻底解决了前面版本关于iOS4的一些问题，但是用SDK编译release版本可以做到WOB，但是假如需要debug版本的Ogre的话，还是得自己编译，用CMake 2.8-3版本，添加OGRE_BUILD_PLATFORM_IPHONE的bool变量，然后勾选ogles，去掉ogl，配置一下freetype库（这最隐蔽，不然会得到一些链接错误），生成后在生成的工程目录运行> ../SDK/iPhone/fix_linker_paths.sh，还特别注意一下需要使用SDK4.1版本编译就行了（老版本似乎会缺少一些新的OGLES扩展）基本上还是比较简单。只是我尝试在ipad上运行时，速度还勉强，但是触摸响应极慢。。。。。。。。难道这就是传说中的display link的触摸响应延迟问题？（Ogre 1.7.2的what't news中提到了一点）

ipad下的截图：

![](http://hi.csdn.net/attachment/201011/9/0_1289290167z1LT.gif)

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**