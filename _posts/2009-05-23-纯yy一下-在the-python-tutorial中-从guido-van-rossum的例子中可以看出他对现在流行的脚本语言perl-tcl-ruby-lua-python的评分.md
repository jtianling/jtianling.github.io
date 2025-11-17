---
layout: post
title: "纯YY一下，在The Python Tutorial中，从Guido van Rossum的例子中可以看出他对现在流行的脚本语言perl,tcl,ruby,lua,python的评分"
categories:
- "纯娱乐"
tags:
- Lua
- perl
- Python
- tcl
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '15'
  _edit_last: '1'
  ks_metadata: 'a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:21:"bisect,scores,library";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:173:"bisect
    module with functions for manipulating sorted lists: import bisect scores = bisect.insort(scores,
    (300, ''ruby'')) scores 摘自：Python 2.6.1的文档，Brief Tour of";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:151:"纯YY一下，在The
    Python Tutorial中，从Guido van Rossum的例子中可以看出他对现在流行的脚本语言perl,tcl,ruby,lua,python的评分";s:6:"robots";s:12:"index,follow";}'
  _wp_old_slug: "%0d%0a%20%20%20%20%20%20%20%20%e7%ba%afyy%e4%b8%80%e4%b8%8b%ef%bc%8c%e5%9c%a8the%20python%20tutorial%e4%b8%ad%ef%bc%8c%e4%bb%8eguido%20van%20rossum%e7%9a%84%e4%be%8b%e5%ad%90%e4%b8%ad%e5%8f%af%e4%bb%a"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

In addition to alternative list implementations, the library also offers other tools such as the [`bisect`](<library/bisect.html> "Array bisection algorithms for binary searching.") module with functions for manipulating sorted lists:

```python
>>> import bisect
>>> scores = [(100, 'perl'), (200, 'tcl'), (400, 'lua'), (500, 'python')]
>>> bisect.insort(scores, (300, 'ruby'))
>>> scores

[(100, 'perl'), (200, 'tcl'), (300, 'ruby'), (400, 'lua'), (500, 'python')]
```

摘自：Python 2.6.1的文档，Brief Tour of the Standard Library – Part II章，Tools for Working with Lists节  
呵呵，很明显可以看出Guido van Rossum的意图，以scores来表示含义，然后分别给了perl 100分，tcl 200分， ruby 300分， lua 400分，然后给了其创造的语言python 最高的500分：）  
其他的都还能理解。。。。。不过ruby在其心中排在lua之后，实在有点让ruby阵营的人抓狂-_-!呵呵，虽然个人没有学过ruby,仅学过lua。。。。。。  
呵呵，纯YY一下，这是偶然从文档中查资料的时候翻出来的：）