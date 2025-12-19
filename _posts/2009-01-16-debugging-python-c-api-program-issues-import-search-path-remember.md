---
layout: post
title: "调试用Python C API 写的程序问题还真多，关于import搜索路径的，复制过来，以防忘记"
categories:
- Python
tags:
- C++
- Python
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

Python程序网络传输后报错找不到模块，是路径问题所致。可通过修改PYTHONPATH环境变量或在代码中动态添加sys.path来解决。

<!-- more -->

其实本地的import调试倒是感觉没有什么问题，但是一旦通过网络的序列化，然后再反序列化出来，PyImpor模块的时候，再报模块不存在，就很让人郁闷了，刚开始根本就不知道是什么问题，本地测好的程序，怎么一到了网络环境就出问题了呢？郁闷啊。找了半天，才发现是自己写的扩展库在本地的路径没有找到，而实际上Python API报的错误根本就不靠谱，唉。。。。。。。。。。。吃一堑长一智啊。。。。

原帖位置：

http://groups.google.com/group/python-cn/browse_thread/thread/f4e2b245147182ad

1、可以修改python的环境变量PYTHONPATH
2、可以在程序里动态的修改sys.path

```python
import sys
# 获得当前文件的路径并添加到sys.path
sys.path.append(os.getcwd())
import other_python
```
