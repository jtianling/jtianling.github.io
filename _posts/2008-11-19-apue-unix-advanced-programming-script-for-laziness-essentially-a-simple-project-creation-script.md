---
layout: post
title: "为学习APUE(Unix环境高级编程）偷懒，而写的脚本，基本上相当于一个简单的工程创建脚本了"
categories:
- "未分类"
tags:
- APUE
- "《Unix环境高级编程》"
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

分享一个bash脚本，可一键生成C++练习所需的目录、源文件和Makefile，简化环境搭建。

<!-- more -->

首先我单独建了一个目录用来保存学习时需要的目录，将此脚本拷贝到这个目录下面，以后每次以一个参数运行脚本，就会自动创建目录，cpp文件，makefile文件，需要做的就是进入此目录，然后修改cpp文件，然后make，enjoy it!呵呵，说实话，自从学习了bash以后，才越来越觉得linux并不是一个复杂难用的系统。

```bash
D:/ubuntu/apue/ctapue.sh.html 1 #!/usr/bin/env bash
 2 dir=apue$1
 3 file=${dir}/apue${1}.cpp
 4
makefile=${dir}/Makefile
 5
 6 **if**  **[**  **-d**  ${dir} **]**
 7 **then**
 8     **echo**  **"** the path ${dir} is exist.**"**
 9     **exit**  1
10 **else**
11     **mkdir**  ${dir}
12 **fi**
13
14 # Create the src
file
15 cat **>** ${file} **< <end-of-file**
 
#include <stdio.h>
16 #include "../apue.h"
17
18
19 int main(int argc, char*
argv[])
20 {
21
22
23     exit(0);
24 }
25
26 **end-of-file**
27
28 #
Create the makefile
29 cat **>** ${makefile} **< <end-of-makefile**
30
src=apue${1}.cpp
31 ob=test
32 /${ob} : /${src}
33     g++ -Wall -g -o /${ob} /${src}
34
35 **end-of-makefile**
```
