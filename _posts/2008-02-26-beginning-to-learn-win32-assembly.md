---
layout: post
title: "开始学习win32汇编"
categories:
- "汇编和反汇编"
tags:
- "汇编和反汇编"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '20'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

分享作者为学习汇编配置的Vim环境，包括vim配置文件及解决16位链接器问题的方法。

<!-- more -->

前段时间对于csdn的博客系统彻底失望，在我现在写的东西都还不知道能不能正常发出去，郁闷，加上过年有这么久没有来了。这段时间开始学习汇编，说到汇编，大学开过两门相关课程，微机原理和单片机都是学这方面的，不过那都是8086，51级别的汇编，感觉根本跟不上时代，那时候学的还不错：）现在想学习学习win32的汇编，首先用王爽的书复习一下8086的汇编，因为masm32的ide的编辑功能实在太弱，还是用vim做比较好，做了几个文件，鉴于很久什么也没有发，就发上来吧，以下是我加的vim配置文件

```vim
set helplang=cn  
set expandtab  
set autoindent  
colorscheme desert  
set fileencodings=ucs-bom,utf-8,cp936  
set guifont=新宋体:h13  
set encoding=cp936 "set encoding=utf-8  
map <F6> :!debug %:r.exe<CR>  
map <F5> :!cmd /K %:r.exe<CR>  
map <F9> :!ml /Zm /Bl link16 % <CR>  
set statusline=%F%m%r%h%w/ [FORMAT=%{&ff}]/ [TYPE=%Y]/ [ASCII=/%03.3b]/ [HEX=/%02.2B]/ [POS=%04l,%04v][%p%%]/ [LEN=%L]  
set laststatus=2 " always show the status line  
set acd
```

这里碰到的最大问题是现在masmv9的连接器只支持32位，所以特意下了个16位的连接器，命名为link16,对了，罗云斌说的做一个.bat文件来设置path，我都在控制面板里面设了，感觉更方便一些。
