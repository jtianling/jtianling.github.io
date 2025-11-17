---
layout: post
title: "忽视的复杂性，关于C++中大整数的思考"
categories:
- C++
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

原以为一个以前在C中轻易实现的猜数字游戏即便我加了一些奇怪的规则，还应该是非常简单就能实现的，但是，我忽略了C/C++ 中大整数带来的复杂性，的确，当整数范围超过long所能表示的范围以后，简单的四则运算或逻辑比较都是需要很复杂的代码才能实现。我在问题（3）就开始要解决一个这样的问题，似乎已经违背了我当初设想的从易到难写C++程序的目标了，但是，因为我对C++的了解程度，自然也很难真的说（或者对不同的人也不一样的）从易到难。但是因为太多方案在头脑中，所以先把问题提出来吧，假如有人来看，各取所需吧，我的解答自然不可能一下子出来，目前，我的想法是，实现一个稍微实用一点的大整数类库，以我的水平，自然不能多么完善，但希望这个类库能伴随我以后解决自己为自己提出的各种刁钻问题，目标自然很明确，让大整数的使用像内置类型一样！哪怕是多么大的天文数字！呵呵，目标而已，目标而已。