---
layout: post
title: Boost::Signals2 学习
categories:
- C++
tags:
- Boost
- Signals2
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '63'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文探讨使用Boost.Signals2库实现信号槽机制，以解耦游戏引擎。文章分析了其降低耦合的优点，以及在游戏开发中需注意的性能开销等问题。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

信号和插槽系统是我想用来在游戏引擎中让各模块解耦的关键部分，虽然自己以前也写过简单的实现，但是今天竟然找不到原来的代码了，而且我现在越来越懒了。。。。。于是乎，还是学习Boost中的signal2库吧。。。。。。。。。。汗颜中。在我发现公司一个比较成功的项目中竟然用了loki库后，使用外部库是越来越大胆了。。。。。更何况，这仅仅是我自己业余作品，按需配置使用使用boost并不过分吧。。。。呵呵，一点都不过分。

为什么我们需要信号和插槽？想想Qt几乎建立在这个基础之上，并且如此好用就能够理解了。降低耦合性，这应该是其核心目的吧。  
信号和插槽可以让各对象只管处理自己的事情,比如按钮只管通知自己已经被按下而不是直接处理按下后应该做什么.  
需要响应按键消息的对象应该只是注册自己需要在按钮按下后干什么,而不是每次去查询按钮是否被按下.毕竟轮询式的查询远不及通知来的有效。  
UI用信号-槽设计的好处是巨大的，这让给对象的职责更加明确，减少了代码耦合，某一天，你想换套响应代码，OK，没有问题，直接换吧，UI层完全还是原来一样，不用关心外部的更改，反过来亦然，这在你将操作直接放在按钮按下的地方处理，肯定是没有办法做到了。

不过，个人感觉在游戏中比较特殊,因为各对象有固定的Update活动周期,各对象的处理应该都在自己的Update周期中处理,不然可能会破坏各自的Update顺序，导致问题.而且，在普通应用程序中存在的循环查询问题在游戏中也几乎可以忽略，因为游戏本身就是一个循环，无论什么时候，游戏都是每帧在render，每帧在Update,除非，你愿意给玩家看到一个往往全全的静态游戏。 另外，特别需要注意的是，无论如何，这样的灵活性不是没有代价的，就像动态语言比静态语言往往要好用的代价一样，牺牲的是性能，信号和插槽在最好的情况下也多了一个间接层。

下面的例子（来自boost文档）是我个人认为最有价值，最能说明问题的，解决的也就是我提到的问题。

```cpp
//[ passing_slots_defs_code_snippet
// a pretend GUI button
class Button
{
    typedef boost::signals2::signal<void (int x, int y)> OnClick;
public:
    typedef OnClick::slot_type OnClickSlotType;
    // forward slots through Button interface to its private signal
    boost::signals2::connection doOnClick(const OnClickSlotType & slot);

    // simulate user clicking on GUI button at coordinates 52, 38
    void simulateClick();
private:
    OnClick onClick;
};

boost::signals2::connection Button::doOnClick(const OnClickSlotType & slot)
{
    return onClick.connect(slot);
}

void Button::simulateClick()
{
    onClick(52, 38);
}

void printCoordinates(long x, long y)
{
    std::cout << "(" << x << ", " << y << ")n";
}
//]
```

```cpp
int main()
{
    //[ passing_slots_usage_code_snippet
    Button button;
    button.doOnClick(&printCoordinates;);
    button.simulateClick();
    //]
    return 0;
}
```

参考：  
《[boost 手册,signal2](<http://www.boost.org/doc/libs/1_42_0/doc/html/signals2.html> "boost 手册,signal2")》，特别感谢[金庆](<http://blog.csdn.net/jq0123>) 将其翻译成中文了，并且翻译的非常好。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
