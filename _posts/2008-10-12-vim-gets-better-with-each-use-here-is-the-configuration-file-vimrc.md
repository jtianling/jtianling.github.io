---
layout: post
title: vim真是越用越好用，贴一下配置文件.vimrc
categories:
- "未分类"
tags:
- vim
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

一方面自己在别的地方可以看到：）

其实想想以前，vim的配置无非就是看看别人的很长的配置文件，自己照着copy一下，现在基本上形成了自己的习惯了，有什么需要的自己加入快捷键了，特别是以“,”（逗号）开始的leader使用起来非常的方便，虽然其实是牺牲了一个重复反向查找的功能。。。。但是实际中，我没有有过用到","这样奇怪的需求，所以覆盖了也不怎么可惜。

可惜的是发上来的文件没有语法高亮。。。。。。。。。。

``vim
let mapleader=","
set encoding=utf-8
set ambiwidth=double
set nocompatible
set hls
set nu
set ai
colors desert
syntax on
set sw=4
set ts=4
"set autocmd
set smarttab
set whichwrap+=h,l,~,b,s,<,>,[,]
set helplang=cn
set ruler
set showcmd
filetype plugin indent on
set nomagic
set mouse=a
set cmdheight=2
set backspace=eol,start,indent
set showmatch
set wildmenu

"-----------------------------------------------------------
" for snippetsEmu_key but it's snippet file is not created
"-----------------------------------------------------------
let g:snippetsEmu_key = "<S-Tab>"

"-----------------------------------------------------------
" folding
"-----------------------------------------------------------
"enable folding, i find it very useful
set nofen
set fdl=0
set lbr

set si
set wrap

"-----------------------------------------------------------
" some key I maped and liked
"-----------------------------------------------------------
" I like use <space> <bs> <cr> key in normal mode
nmap <space> i<space><esc>l
nmap <bs> i<bs><esc>l
nmap <cr> i<cr><esc>

" sometimes use this to p sth in new line
nmap <leader>o o<esc>p
nmap <leader>O O<esc>p

" one key to save even in insert mode
nmap <f2> :w<cr>
imap <f2> <esc>:w<cr>a

" select all :) like microsoft's CTRL-A
nmap <leader>a ggVG

"-----------------------------------------------------------
" for favarite c/c++
"-----------------------------------------------------------
" normal mode
autocmd filetype c map<silent><buffer> <f6> :w<cr>:make<cr>:cw<cr>
autocmd filetype cpp map<silent><buffer> <f6> :w<cr>:make<cr>:cw<cr>

"-----------------------------------------------------------
" For special script file type
" I only need to use python,lua,sh and surely only know these
"-----------------------------------------------------------
" normal mode
autocmd filetype python map<buffer> <f5> :!clear<cr>:w<cr>:!python %<cr>
autocmd filetype lua map<buffer> <f5> :!clear<cr>:w<cr>:!lua %<cr>
autocmd filetype sh map<buffer> <f5> :!clear<cr>:w<cr>:!./%<cr>
" insert mode
autocmd filetype python imap<buffer> <f5> <esc>:!clear<cr>:w<cr>:!python %<cr>
autocmd filetype lua imap<buffer> <f5> <esc>:!clear<cr>:w<cr>:!lua %<cr>
autocmd filetype sh imap<buffer> <f5> <esc>:!clear<cr>:w<cr>:!./%<cr>
"-----------------------------------------------------------

"-----------------------------------------------------------
" taglist
"-----------------------------------------------------------
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 1
map <leader>to :Tlist<cr>

"-----------------------------------------------------------
" for quickfix
"-----------------------------------------------------------
nmap <silent> <leader>n :cn<cr>
nmap <silent> <leader>p :cp<cr>

"-----------------------------------------------------------
" for vimgdb
"-----------------------------------------------------------
source ~/vimrc/gdb_mappings.vim

"-----------------------------------------------------------
" WinManager Setting
"-----------------------------------------------------------
let g:winManagerWindowLayout = "FileExplorer"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <silent> <leader>wm :WMToggle<CR>

"-----------------------------------------------------------
" for A.vim a useful plugin
"-----------------------------------------------------------
nmap <leader>aa :A<cr>
nmap <leader>as :AS<cr>
nmap <leader>av :AV<cr>

"-----------------------------------------------------------
" for MiniBufExplorer and buffer opearate
"-----------------------------------------------------------
nmap <leader>1 :b 1<CR>
nmap <leader>2 :b 2<CR>
nmap <leader>3 :b 3<CR>
nmap <leader>4 :b 4<CR>
nmap <leader>5 :b 5<CR>
nmap <leader>6 :b 6<CR>
nmap <leader>7 :b 7<CR>
nmap <leader>8 :b 8<CR>
nmap <leader>9 :b 9<CR>
nmap <leader>0 :b 10<CR>
```