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

 

原来的lua stdlib set中某段程序如下：

  1. \-- @func propersubset: Find whether one set   
is  
 a proper subset of
  2. \-- another
  3. \--   @param s, t: sets
  4. \-- @returns
  5. \--   @param r: true   
if  
 s   
is  
 a proper subset of t, false otherwise
  6. function propersubset (s, t)
  7.     
return  
 subset (s, t)   
and  
   
not  
 subset (t, s)
  8. end
  9.   10. \-- @func equal: Find whether two sets are equal
  11. \--   @param s, t: sets
  12. \-- @returns
  13. \--   @param r: true   
if  
 sets are equal, false otherwise
  14. function equal (s, t)  

  15.     
return  
 subset (s, t)   
and  
 subset (s, t)  

  16. end
  17.   18. \-- @head Metamethods   
for  
 sets
  19. \-- set + table = union
  20. metatable.__add = union
  21. \-- set - table = set difference
  22. metatable.__sub = difference
  23. \-- set / table = intersection  

  24. metatable.__div = intersection  

  25. \-- set <= table = subset
  26. metatable.__le = subset
  27. 

 

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
Thank you for reading my poor Chinglish. lol,I'm Chinese.  
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

Your English is great,  you wouldn't want to even hear my Mandarin.  
关心  
Andrew Wilson

 

 

呵呵，不知道他这里说关心是什么意思......，惊奇的是。。。。他竟然还真能打中文字。。。。E文系统应该是没有中文输入法的吧。。。。

 

最后lua stdlib的作者回信：

Reuben Thomas to Andrew, me, luaforwindows   
show details Sep 4 Reply

Thanks, this is quite correct. I've made a new release with this fix.

 

I see, I had actually forgotten that * is used in Modula-3 in the same way. I am happy to change this so that * is intersection and / is symmetric difference.

Thanks, I've made another release with these changes, and coincidentally fixed set.difference, which was also broken.

 

 

呵呵，最新版的set如下，可见已经修复，并且连那个我称为surprising attribute 的“/”符号表示交集也改了：）

 

  1. \-- @func intersection: Find the intersection of two sets
  2. \--   @param s, t: sets
  3. \-- @returns
  4. \--   @param r: set intersection of s   
and  
 t
  5. function intersection (s, t)
  6.   local r = new {}
  7.     
for  
 e   
in  
 elements (s) do
  8.       
if  
 member (t, e) then
  9.       insert (r, e)
  10.     end
  11.   end
  12.     
return  
 r
  13. end
  14.   15. \-- @func union: Find the union of two sets
  16. \--   @param s, t: sets
  17. \-- @returns
  18. \--   @param r: set union of s   
and  
 t
  19. function union (s, t)
  20.   local r = new {}
  21.     
for  
 e   
in  
 elements (s) do
  22.     insert (r, e)
  23.   end
  24.     
for  
 e   
in  
 elements (t) do
  25.     insert (r, e)
  26.   end
  27.     
return  
 r
  28. end
  29.   30. \-- @func subset: Find whether one set   
is  
 a subset of another
  31. \--   @param s, t: sets
  32. \-- @returns
  33. \--   @param r: true   
if  
 s   
is  
 a subset of t, false otherwise
  34. function subset (s, t)
  35.     
for  
 e   
in  
 elements (s) do
  36.       
if  
   
not  
 member (t, e) then
  37.         
return  
 false
  38.     end
  39.   end
  40.     
return  
 true
  41. end
  42.   43. \-- @func propersubset: Find whether one set   
is  
 a proper subset of
  44. \-- another
  45. \--   @param s, t: sets
  46. \-- @returns
  47. \--   @param r: true   
if  
 s   
is  
 a proper subset of t, false otherwise
  48. function propersubset (s, t)
  49.     
return  
 subset (s, t)   
and  
   
not  
 subset (t, s)
  50. end
  51.   52. \-- @func equal: Find whether two sets are equal
  53. \--   @param s, t: sets
  54. \-- @returns
  55. \--   @param r: true   
if  
 sets are equal, false otherwise
  56. function equal (s, t)  

  57.     
  
  
return  
 subset (s, t)   
and  
 subset (t, s)  

  58. end
  59.   60. \-- @head Metamethods   
for  
 sets
  61. \-- set + table = union
  62. metatable.__add = union
  63. \-- set - table = set difference
  64. metatable.__sub = difference
  65. \-- set * table = intersection  

  66. metatable.__mul = intersection  

  67. \-- set / table = symmetric difference
  68. metatable.__div = symmetric_difference
  69. \-- set <= table = subset
  70. metatable.__le = subset
  71. \-- set < table = proper subset
  72. metatable.__lt = propersubset

 

这虽然是一件芝麻一样的小事，但却是我个人第一次真正的为开源社区做贡献。。。。虽然仅仅是以bug report的形式：）立此存照：）

 
