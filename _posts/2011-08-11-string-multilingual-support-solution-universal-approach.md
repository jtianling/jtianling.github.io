---
layout: post
title: "字符串的多国语言支持解决方案 通用解决方案篇"
categories:
- "游戏开发"
tags:
- "多国语言"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '179'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

在用Qt的时候，自然是使用Qt的解决方案，简单易用

在不需要跨平台开发iPhone的应用时，自然使用iOS提供的多国语言支持解决方案  

但是，不能用Qt，也不是开发纯iOS应用的时候呢？那就只能自己想个办法解决这个问题了。  


<!-- more -->


  

根据实际情况，该解决方案需要符合下面的条件：

1.代码中使用时，不应该有太多额外的负担，不降低代码的可读性

2.不用单独的工具也能使用

  

第一条很好解释，假如为了多国语言而浪费太多的精力实在不值得，所以这里放弃更加高效的int编码索引字符串的方式，那种方式的确更加高效，但是代码中需要使用宏/常量来索引字符串。

第二条就完全处于开发简单的考虑，不要神马分析，生成等乱七八糟的东西，所以也不会如很多解决方案一样使用啥excel，然后通过工具解析成二进制的格式，然后程序中去解析二进制数据，那不是自虐吗？

那么方案其实就慢慢出来了，以文本配置来存储多国语言的文字，一种语言一个文件。在文本配置的格式选择上，使用json。用字符串Key来索引字符串，索引失败时，就直接显示Key字符串。

  

首先，json的格式就是最简单的以key为索引的字符串组合，比如，我现在建立一个en.json表示英文，一个cn.json表示中文。

![](http://hi.csdn.net/attachment/201108/11/0_1313028940D3zO.gif)

  

然后实现如下StringManager,该类为Singleton：（用[jsoncpp](<http://www.jtianling.com/article/details/5754179> "jsoncpp")为json的解析库）

头文件：

```cpp
class StringManager : public Singleton<StringManager>
{
public:
    bool Init(const char* filename);

    std::string GetLocalizedString(const char* key);

private:
    Json::Value string_map_;
};
```

部分实现：

```cpp
bool StringManager::Init( const char* filename ) {
    if ( !ReadJsonFromFile(filename, string_map_) ) {
        return false;
    }

    return true;
}
```

```cpp
std::string StringManager::GetLocalizedString( const char* key ) {
    if (string_map_.isMember(key)) {
        return string_map_[key].asString();
    }
    else {
        return std::string(key); // 当查找不到key时，直接显示key
    }
}
```

一般情况下，直接通过StringManager的GetLocalizedString函数来获取字符串即可，为了更加简单，定义如下的宏：

#define LS(key) StringManager::Instance()->GetLocalizedString(key)  

使用时，先需要以字符串的配置文件名初始化StringManager,读取字符串信息。以后，使用起来就和Qt中很类似了。即以LS()方式包含你需要显示的文字。

比如下面这样，为了减少其他无关信息，就没有添加显示部分的代码了：

在以上的例子中，我是使用utf8来保存多国语言，假如你是使用UTF16的话，请将相应的字符串表示改为宽字节即可。

小结：

因为没有额外的工具支持，这样的方式也许没有qt,iOS里面那么便捷，但是实现简单，容易理解，同时使用起来也足够的方便，最最重要的是，除了C++编译器，这套方案不依赖于平台或者其他神马东西，你随时随地都可以使用。（本例中用jsoncpp解析json，jsoncpp也仅依赖C++编译器存在）

  


