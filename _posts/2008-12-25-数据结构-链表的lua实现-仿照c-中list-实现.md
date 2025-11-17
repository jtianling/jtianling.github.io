---
layout: post
title: "数据结构 链表的lua实现 仿照C++中list 实现"
categories:
- Lua
- "算法"
tags:
- Lua
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

# 数据结构 链表的lua实现 仿照C++中list 实现

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

vector我就没有用lua实现了，实现个list就很别扭了。事实上太仿照C++标准库的list了，所以可能没有很好的发挥lua的特点，有点要说的就是，lua中table的赋值都是引用赋值的浅拷贝，这点在实现list的时候发挥了关键作用，不然没有指针的lua要实现一个列表都成为不可能了：）

程序最后还附加了一个符合lua迭代器特点的迭代器，不然老是用CListIterator的话，可能都会怀疑自己用的还是不是lua了，呵呵

 这里想提出的一点就是lua中实在是没有一个可用的debug工具，注意我的措辞，是连一个可用的都没有，更别提好用的了。相对而言C++有VS+gdb,python用pydb，bash有bashdb,而lua什么都没有！lua for windows的那个scite别提多不好用了，clidebug,xdblua, RemDebug等等我都用过，甚至官网提到的几个IDE我都试用了一下，通通的不能用，可能是因为lua升级了的原因（记得scite在原来是可用的），郁闷死我了。作为一个两百多行的list代码，没有一个可用的调试工具，简直就是噩梦（也许没有那么夸张，但是的确浪费了我很多本来简单调试就可以发下你的问题），唉。。。。。在没有好用的lua调试工具之前，我甚至都有点不想给自己找罪受了。再也不写太多的lua代码了。最多在小程序中用print和assert勉强写写吧。其实感觉lua本身对于调试的支持是很到位的了，为什么却没有好用的工具呢？唉。。。。。。。。。。这就是普及的好处了。。。。。真有时间，哥们自己DIY一个用用算了。

\-----在对lua的调试工具不再抱希望的时候，调整了一下lua的PATH设置，随便折腾了一下scite,结果又可以正常调试了，faint.............有的时候就是这么莫名奇妙，我折腾了3天（准确的是3天的晚上），试了n种工具，结果都有问题，结果今天莫名奇妙就好了，谁说的来着，你编的认为已经没有bug的软件总会在某一天莫名崩溃。。。。这一点在工作以来我是深有体会了，问题是，某个有bug，已经不能正常运行的软件怎么在某一天莫名的好了呢？。。。。呵呵。

总之，还是对lua的调试工具不满，起码，没有能够让我能用putty挂在linux下好好调试的工具：）总不能每次在那边写完都考回来在windows下调试吧？。。。（现在好像也只能这样了）  

 

```lua
  1 #!/usr/bin/env lua  
  2   
  3 \--  
require "std"  
  4   
  5 \--  
Node prototype  
  6 CNode = **{}**  
  7 function CNode:New(data,  
prev, next)  
  8     **local**  o = **{}**  
  9     o.data  
= data  
 10     o.prev =  
prev  
 11     o.next = next  
 12     o.type = "CNode"  
 13     setmetatable(o, self)  
 14     self.__index  
= self  
 15     **return**  o  
 16 end  
 17   
 18 \--  
iterator of list prototype like in C++  
 19 CListIterator = **{}**  
 20 function CListIterator:New(a)  
 21     assert(a ~= nil **and**    
 22     type(a) == "table" **and**    
 23     a.type ~= nil **and**  
 24     ((a.type == "CList")  
**or**  (a.type ==  
"CNode")),  
 25     "Argument to new a CListIterator must be a CList  
object or a CNode object")  
 26       
 27     **local**  o = **{}**  
 28     \-- give it a type name  
 29     o.type = "CListIterator"  
 30   
 31     \-- if a is a CList object then create a begin iterator for  
the object  
 32     \-- if a is a CNode object then return a iterator point to  
the node  
 33     **if**  a.type ==  
"CList" **then**  
 34         o.pos  
= a.head.next  
 35     **elseif**  a.type ==  
"CNode" **then**  
 36         o.pos  
= a  
 37     **end**  
 38   
 39     setmetatable(o, self)  
 40     self.__index  
= self  
 41     **return**  o  
 42 end  
 43   
 44 function CListIterator:IsEnd()  
 45     **return**  **not**  self.pos.data  
 46 end  
 47   
 48 function CListIterator:Cur()  
 49     **return**  self.pos  
 50 end  
 51   
 52 function CListIterator:MoveNext()  
 53     self.pos =  
self.pos.next  
 54     **return**  self  
 55 end  
 56   
 57 function CListIterator:MovePrev()  
 58     self.pos =  
self.pos.prev  
 59     **return**  self  
 60 end  
 61   
 62 \-- List  
prototype  
 63 CList = **{}**  
 64 function CList:CreateIterator()  
 65     **return**  CListIterator:New(self)  
 66 end  
 67   
 68 function CList:New()  
 69     **local**  o = **{}**  
 70     o.head =  
CNode:New()  
 71     o.head.prev  
= o.head  
 72     o.head.next = o.head  
 73   
 74     \-- give it a type def  
 75     o.type = "CList"  
 76     setmetatable(o, self)  
 77     self.__index  
= self  
 78     **return**  o  
 79 end  
 80   
 81 function CList:Insert(it,  
data)  
 82     assert(it ~= nil, "Must pointer where to Insert")  
 83     assert(type(it) == "table", "Fisrt  
Argument must be a CListIterator(now it even not a table)")  
 84     assert(type ~= nil, "Fisrt  
Argument must be a CListIterator(now it.type == nil)")  
 85     assert(it.type ==  
"CListIterator", "Fisrt Argument must be a CListIterator")  
 86   
 87     **local**  iter = CListIterator:New(self)  
 88     **local**  node = CNode:New(data, it.pos.prev,  
it.pos)  
 89     it.pos.prev.next = node  
 90     it.pos.prev  
= node  
 91     **return**  CListIterator:New(node)  
 92 end  
 93   
 94 function CList:Begin()  
 95     **return**  self:CreateIterator()  
 96 end  
 97   
 98 function CList:End()  
 99     **return**  CListIterator:New(self.head)  
100 end  
101   
102   
103 function CList:PushFront(data)  
104     self:Insert(self:Begin(),  
data)  
105 end  
106   
107 function CList:PushBack(data)  
108     self:Insert(self:End(),  
data)  
109 end  
110   
111 function CList:IsEmpty()  
112     **return**  self:Begin().pos == self:End().pos  
113 end  
114   
115 function CList:Erase(it)  
116     assert(**not**  it.data,  
"you can't erase the head")  
117     it.pos.prev.next = it.pos.next  
118     it.pos.next.prev = it.pos.prev  
119     it = nil  
120 end  
121   
122 function CList:PopFront()  
123     assert(**not**  self:IsEmpty(),  
"Can't PopFront to a Empty list")  
124     self:Erase(self:Begin())  
125 end  
126   
127 function CList:PopBack()  
128     assert(**not**  self:IsEmpty(),  
"Can't PopBack to a Empty list")  
129     self:Erase(self:End():MovePrev())  
130 end  
131   
132 function CList:Clear()  
133     **while**  **not**  self:IsEmpty()  
**do**  
134         self:Erase(self:Begin())  
135     **end**  
136 end  
137   
138 \-- redefine  
global print to support the CList  
139 p = _G.print  
140 function print(o)  
141     **if**  o ~= nil **and**  type(o)  
== "table" **and**    
142         o.type ~= nil **and**  o.type ==  
"CList" **then**  
143         \-- iterate like in C++ using CList and CListIterator feature  
144         **local**  it = o:CreateIterator()  
145         **while**  **not**  it:IsEnd()  
**do**  
146             io.write(it:Cur().data)  
147             io.write(" ")  
148             it:MoveNext()  
149         **end**  
150         io.write("/n")  
151     **else**  
152         p(o)  
153     **end**  
154 end  
155   
156 \-- test  
PushFront  
157 print("/ntest: test PushFront and PopFront")  
158 newlist = CList:New()  
159 newlist:PushFront(10)  
160 print(newlist)  
161 newlist:PushFront(20)  
162 print(newlist)  
163 newlist:PushFront(30)  
164 print(newlist)  
165 newlist:PopFront()  
166 print(newlist)  
167 it = newlist:CreateIterator()  
168 newlist:Erase(it)  
169 print(newlist)  
170 newlist:Clear()  
171 print(newlist)  
172   
173   
174 \-- test  
PushBack  
175 print("/ntest: test PushBack and popBack")  
176 newlist = CList:New()  
177 newlist:PushBack(10)  
178 print(newlist)  
179 newlist:PushBack(20)  
180 print(newlist)  
181 newlist:PushBack(30)  
182 print(newlist)  
183 newlist:PopBack()  
184 print(newlist)  
185 newlist:PopFront()  
186 print(newlist)  
187   
188   
189 \-- test: insert  
at begin  
190 print("/ntest: insert at begin ")  
191 newlist = CList:New()  
192 it = newlist:CreateIterator()  
193 iter = newlist:Insert(it, 10);  
194 io.write("cur iterator:" ..  tostring(it.pos.data) .. "  
return iterator:" .. tostring(iter.pos.data)  
.. "/n")  
195 print(newlist)  
196 iter = newlist:Insert(it, 20);  
197 io.write("cur iterator:" ..  tostring(it.pos.data) .. "  
return iterator:" .. tostring(iter.pos.data)  
.. "/n")  
198 print(newlist)  
199 iter = newlist:Insert(it, 30);  
200 io.write("cur iterator:" ..  tostring(it.pos.data) .. "  
return iterator:" .. tostring(iter.pos.data)  
.. "/n")  
201 print(newlist)  
202   
203 \-- test: insert  
at back  
204 print("/ntest: insert at back")  
205 newlist = CList:New()  
206 it = newlist:CreateIterator()  
207 it = newlist:Insert(it, 10);  
208 io.write("cur iterator:" ..  tostring(it.pos.data).."/n")  
209 it = newlist:Insert(it, 20);  
210 io.write("cur iterator:" ..  tostring(it.pos.data).."/n")  
211 it = newlist:Insert(it, 30);  
212 io.write("cur iterator:" ..  tostring(it.pos.data).."/n")  
213 print(newlist)  
214   
215 \-- iterate like  
in C++  
216 print("/niterate like in C++")  
217 it = newlist:CreateIterator()  
218 **while**  **not**  it:IsEnd() **do**  
219     io.write(it:Cur().data .. "  
")  
220     it:MoveNext()  
221 **end**  
222 print("/n")  
223   
224 \-- closure list  
iterator to iterate   
225 print("/nclosure list iterator to iterate")  
226 function list_iter(list)  
227     **local**  cur = list.head  
228     **return**  function()  
229         **if**  cur.next.data  
~= nil **then**    
230             cur  
= cur.next  
231             **return**  cur.data  
232             **end**  
233         end  
234 end  
235   
236 **for**  v **in**  list_iter(newlist) **do**    
237     io.write(v .. "  
")  
238 **end**  
239   
240
```

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**