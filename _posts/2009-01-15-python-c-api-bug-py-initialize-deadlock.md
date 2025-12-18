---
layout: post
title: "偏偏给我碰到Python C API的Bug?Py_Initialze()直接死循环"
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
  views: '15'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

今天在一个程序中，在不同的两个函数，先用Py_Initialize()初始化，然后用Py_Finalize()结束，在本机都调试没有问题，然后将DLL发给同事后，老是在Py_Initialize()进入死循环，莫名其妙！怎么调试都没有用，奇怪了，然后将前一次的Py_Finalize()和后一次的Py_Initialize()的取消，也就是仅仅经过一次的Py_Initialize()，Py_Finalize()就完全没有问题。

这点也很奇怪，毕竟本机调试是没有任何问题的，在同事那里虽然换成了多线程环境，但是也没有道理总是必在Py_Initialize()死掉吧？看了Python的文档，才发现Py_Finalize()函数后有这么一段



```text
**Bugs and caveats:** The destruction of modules and objects in  
modules is done in random order; this may cause destructors (`__del__()` methods) to fail when they depend on other objects  
(even functions) or modules. Dynamically loaded extension modules loaded by  
Python are not unloaded. Small amounts of memory allocated by the Python  
interpreter may not be freed (if you find a leak, please report it). Memory tied  
up in circular references between objects is not freed. Some memory allocated by  
extension modules may not be freed. Some extensions may not work properly if  
their initialization routine is called more than once; this can happen if an  
application calls Py_Initialize() and Py_Finalize() more than once. 
```

 

难道是这个问题？我这里也不是extensions不工作的问题啊。。。。。。。或者还是多线程的问题？莫名奇妙啊。。。。。。

 

这里顺便记个关于Python在对线程环境下工作的文章，明天去好好研究一下是什么问题。

# C++调用PythonAPI线程状态和全局解释器锁

http://blog.csdn.net/marising/archive/2008/10/08/3032278.aspx

#