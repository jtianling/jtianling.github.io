---
layout: post
title: "真高兴啊。。。。实际的为开源事业做了点点贡献：），很久前指出的一个lua stdlib的bug得到确认"
categories:
- Lua
tags:
- Lua
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '16'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


呵呵，是关于lua stdlib 库的set模块的bug，其实作者好像确认很久了。。。。但是我这段时间一直没有上gmail，所以没有看到。。。作者说，在新版中已经修改此bug...今天下了最新版，发现真是这样：）呵呵，真高兴啊，吸收了开源社区的那么多营养。。。总算有点报答了。。。当然，这仅仅是起步：）

实际流程贴一下。。。满足一下虚荣心。。。其实仅仅是一个很小的很容易发现的bug。。。呵呵，我当时学lua才一两周。。也不可能发现多么难的bug....lol

<!-- more -->

原来的lua stdlib set中某段程序如下：

```lua
-- @func propersubset: Find whether one set is a proper subset of another
--   @param s, t: sets
-- @returns
--   @param r: true if s is a proper subset of t, false otherwise
function propersubset (s, t)
  return subset (s, t) and not subset (t, s)
end

-- @func equal: Find whether two sets are equal
--   @param s, t: sets
-- @returns
--   @param r: true if sets are equal, false otherwise
function equal (s, t)
  return subset (s, t) and subset (s, t)
end

-- @head Metamethods for sets
-- set + table = union
metatable.__add = union
-- set - table = set difference
metatable.__sub = difference
-- set / table = intersection
metatable.__div = intersection
-- set <= table = subset
metatable.__le = subset
```

于是我发邮件给作者

hi all,  
Thank you very much for your hard working with the LuaForWindows,I enjoy it so mush.  
there is a bug to report as my return.  
the set.lua file in the lualibs, 117th line.  
source as this code:"return subset (s, t) and subset (s, t)"  
it obviously should be "return subset (s,t) and subset(t, s)"  
which means they are equal when s is the subset t and t is the subset s.  
I hope I'm right and didn't disturb you.  
BTW,there is a surprising attribute.  
In the set's operations,div(/) mean intersection that is different from custom.  
In the custom mul(*) denotes it,just like the <<programming in Lua>> writes in the 13th captial named "metatable and meatmethod"  
Thank you for reading my poor Chinglish. lol,I'm Chinese.  
Best wishes.  
your honest  
JTianLing from [jtianling{at}gmail.com](<mailto:jtianling@gmail.com>)

luaforwindows的作者回信

Andrew Wilson to me, rrt, luaforwindows   
show details Sep 3 Reply

Thanks for the bug report JTianLing, this particular module comes from  
the stdlib library , I'll copy your report of this issue to the  
administrator of that project <http://luaforge.net/projects/stdlib/>  
.

Your English is great,  you wouldn't want to even hear my Mandarin.  
关心  
Andrew Wilson

呵呵，不知道他这里说关心是什么意思......，惊奇的是。。。。他竟然还真能打中文字。。。。E文系统应该是没有中文输入法的吧。。。。

最后lua stdlib的作者回信：

Reuben Thomas to Andrew, me, luaforwindows   
show details Sep 4 Reply

Thanks, this is quite correct. I've made a new release with this fix.

I see, I had actually forgotten that * is used in Modula-3 in the same way. I am happy to change this so that * is intersection and / is symmetric difference.

Thanks, I've made another release with these changes, and coincidentally fixed set.difference, which was also broken.

呵呵，最新版的set如下，可见已经修复，并且连那个我称为surprising attribute 的"/"符号表示交集也改了：）

```lua
-- @func intersection: Find the intersection of two sets
--   @param s, t: sets
-- @returns
--   @param r: set intersection of s and t
function intersection (s, t)
  local r = new {}
  for e in elements (s) do
    if member (t, e) then
      insert (r, e)
    end
  end
  return r
end

-- @func union: Find the union of two sets
--   @param s, t: sets
-- @returns
--   @param r: set union of s and t
function union (s, t)
  local r = new {}
  for e in elements (s) do
    insert (r, e)
  end
  for e in elements (t) do
    insert (r, e)
  end
  return r
end

-- @func subset: Find whether one set is a subset of another
--   @param s, t: sets
-- @returns
--   @param r: true if s is a subset of t, false otherwise
function subset (s, t)
  for e in elements (s) do
    if not member (t, e) then
      return false
    end
  end
  return true
end

-- @func propersubset: Find whether one set is a proper subset of another
--   @param s, t: sets
-- @returns
--   @param r: true if s is a proper subset of t, false otherwise
function propersubset (s, t)
  return subset (s, t) and not subset (t, s)
end

-- @func equal: Find whether two sets are equal
--   @param s, t: sets
-- @returns
--   @param r: true if sets are equal, false otherwise
function equal (s, t)
  return subset (s, t) and subset (t, s)
end

-- @head Metamethods for sets
-- set + table = union
metatable.__add = union
-- set - table = set difference
metatable.__sub = difference
-- set * table = intersection
metatable.__mul = intersection
-- set / table = symmetric difference
metatable.__div = symmetric_difference
-- set <= table = subset
metatable.__le = subset
-- set < table = proper subset
metatable.__lt = propersubset
```

这虽然是一件芝麻一样的小事，但却是我个人第一次真正的为开源社区做贡献。。。。虽然仅仅是以bug report的形式：）立此存照：）
