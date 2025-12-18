---
layout: post
title: "女朋友用Python实现的猜数字游戏：）"
categories:
- Python
tags:
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

```python
from random import randint

**def**  ran():
    **return**  randint(1,100)

c=ran()

# Guess
Number
# Writen By
小乖乖
count=0

**while**(count<5):

    a=input()

    **if**  a>c:
        **print**  "too large ,try again"

    **elif**  a<c:
        **print**  "too small, again"

    **else** :    
        **print**  "good
,right"
        **print**  "count number
times=",count+1
        **break**

    count=count+1
**else** :
    **print**  "answer=",c
```