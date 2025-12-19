---
layout: post
title: "序列化支持(3)—Boost的序列化库的使用"
categories:
- "网络技术"
tags:
- Boost
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍了Boost序列化库的基本用法，通过示例演示了如何序列化对象及其成员和继承关系。

<!-- more -->

# 序列化支持(3)—Boost的序列化库的使用



本来来说，Boost的文档属于开源库中最最详细的一列了，基本上跟着文档走就都能学会了，但是对于初学者来说可能有的地方太过简略，当然，对于熟悉boost的人来说那叫主题吐出，一针见血。我这里主要摘文档中的例子来讲讲，偶尔发表一下自己的见解，有的地方也跟进实现去看看。毕竟原有的例子仅仅是很简单的。这里自然还是推荐任何学习者都像我一样，调试其中的每一个例子，而不仅仅是看看而已。

关于Boost的编译和配置假如觉的麻烦，可以下一个自动下载安装的程序来完成，在windows下，从1.35开始我就一直使用此自动安装程序，安装和卸载非常方便，接下来需要做的就仅仅是简单的添加好工作路径就行了。

以下例子如无特别说明都来自于boost的文档。

例一：

```cpp
// BoostLearn.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

#include <fstream>

// 包含以简单文本格式实现存档的头文件
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>

/////////////////////////////////////////////////////////////
// gps 座标
//
// 举例说明简单类型的序列化
//
class gps_position
{
private:
    friend class boost::serialization::access;
    // 如果类Archive 是一个输出存档，则操作符& 被定义为<<.  同样，如果类Archive
    // 是一个输入存档，则操作符& 被定义为>>.
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
       ar & degrees;
       ar & minutes;
       ar & seconds;
    }
    int degrees;
    int minutes;
    float seconds;
public:
    gps_position(){};
    gps_position(int d, int m, float s) :
    degrees(d), minutes(m), seconds(s)
    {}
};

int main() {
    // 创建并打开一个输出用的字符存档
    std::ofstream ofs("filename");

    // 创建类实例
    const gps_position g(35, 59, 24.567f);

    // 保存数据到存档
    {
       boost::archive::text_oarchive oa(ofs);
       // 将类实例写出到存档
       oa << g;
       // 在调用析构函数时将关闭存档和流
    }

    // ... 晚些时候，将类实例恢复到原来的状态
    gps_position newg;
    {
       // 创建并打开一个输入用的存档
       std::ifstream ifs("filename", std::ios::binary);
       boost::archive::text_iarchive ia(ifs);
       // 从存档中读取类的状态
       ia >> newg;
       // 在调用析构函数时将关闭存档和流
    }
    return 0;
}
```

首先，对于两个archive类我并不是很熟悉，这里摘其代码：

```cpp
template<class Archive>
class interface_oarchive
{
protected:
    interface_oarchive(){};
public:
    /////////////////////////////////////////////////////////
    // archive public interface
    typedef mpl::bool_<false> is_loading;
    typedef mpl::bool_<true> is_saving;

    // return a pointer to the most derived class
    Archive * This(){
        return static_cast<Archive *>(this);
    }

    template<class T>
    const basic_pointer_oserializer * 
    register_type(const T * = NULL){
        const basic_pointer_oserializer & bpos =
            boost::serialization::singleton<
                pointer_oserializer<Archive, T>
            >::get_const_instance();
        this->This()->register_basic_serializer(bpos.get_basic_serializer());
        return & bpos;
    }

    template<class T>
    Archive & operator<<(T & t){
        this->This()->save_override(t, 0);
        return * this->This();
    }
   
    // the & operator 
    template<class T>
    Archive & operator&(T & t){
        #ifndef BOOST_NO_FUNCTION_TEMPLATE_ORDERING
            return * this->This() << const_cast<const T &>(t);
        #else
            return * this->This() << t;
        #endif
    }
};
```

这个函数的实现很有意思，利用了模板参数，然后强转，最后通过子类一层一层的传递，导致这里强转实际得到的是最深层次子类的指针。技巧性非常强：）虽然我实际中从来没有用到过-_-!这里相当于父类在实现某些函数的时候，直接使用子类的函数实现。

Archive * This(){
    return static_cast<Archive *>(this);
}

就例子中

oa << g;

一句，其中函数来回调用，从子类到父类再到子类再到父类....#@$#@%#@相当的扭曲，利用的就是上面的This指针函数形式，为什么用这么多的语句来实现本来一句简单的memcpy就能完成的功能，值得思考，也许要进一步对其整体的框架构造有所了解才行。但是这一点在文档中肯定是没有论述的，我们寻找答案的唯一方法就是源代码了。

先将其类互相之间的关系锊一下。

text_oarchive继承自参数化类text_oarchive_impl，主要功能全由其提供。

text_oarchive_impl参数化类继承自basic_text_oprimitive<std::ostream>与参数化类basic_text_oarchive。text_oarchive_impl自身实现的代码主要是对各个字符串（包括char*,wchar*,string,wstring）的序列化。

text_oarchive_impl又是从参数化类basic_text_oprimitive和basic_text_oarchive继承过来。这里最好是画个UML图那就清晰了。但是由于我是如此的懒，所以我没有画-_-!

其中basic_text_oprimitive的实现，告诉了我们，为什么需要This函数来调用子类的函数。

通过跟踪源代码的boost::archive::text_oarchive oa(ofs);
此句，会发现，最终ofs这个ofstream最终是传入到了这个参数化basic_text_oprimitive，并作为其引用成员变量os保存的，然后basic_text_oprimitive C++的basic类型的save函数重载，而save函数实际的实现又都是通过os的 <<操作符来实现的。

这里最引人注目的就是&操作符的重载，使得使用起来非常方便，兼有使用Serialize函数和<<,>>操作符的两种方案的好处。

我刚开始工作的时候以为序列化最大的好处就是对类的类成员变量与普通变量都使用了统一的处理接口，这自然也是序列化所需要的基本功能之一。

## 可序列化的成员

一下例子从文档衍生而来，经过添加必要代码使其可以执行

```cpp
// BoostLearn.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

#include <fstream>

// 包含以简单文本格式实现存档的头文件
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>

/////////////////////////////////////////////////////////////
// gps 座标
//
// 举例说明简单类型的序列化
//
class gps_position
{
private:
    friend class boost::serialization::access;
    // 如果类Archive 是一个输出存档，则操作符& 被定义为<<.  同样，如果类Archive
    // 是一个输入存档，则操作符& 被定义为>>.
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
       ar & degrees;
       ar & minutes;
       ar & seconds;
    }
    int degrees;
    int minutes;
    float seconds;
public:
    gps_position()
    {
       degrees = 0;
       minutes = 0;
       seconds = 0.0;
    };
    gps_position(int d, int m, float s) :
    degrees(d), minutes(m), seconds(s)
    {}
};

class bus_stop
{
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    { 
       ar & latitude;
       ar & longitude;
    }

    gps_position latitude;
    gps_position longitude;
public: 
    bus_stop(){ }
    bus_stop(const gps_position & lat_, const gps_position & long_) :
         latitude(lat_), longitude(long_){ }
          
    virtual ~bus_stop(){ }
};


int main() {
    // 创建并打开一个输出用的字符存档
    std::ofstream ofs("busfile");

    // 创建类实例
    const gps_position latitude(1, 2, 3.3f);
    const gps_position longitude(4, 5, 6.6f);

    bus_stop stop(latitude, longitude);

    // 保存数据到存档
    {
       boost::archive::text_oarchive oa(ofs);
       // 将类实例写出到存档
       oa << stop;
        // 在调用析构函数时将关闭存档和流
    }

    // ... 晚些时候，将类实例恢复到原来的状态
    bus_stop newstop;
    {
       // 创建并打开一个输入用的存档
       std::ifstream ifs("busfile", std::ios::binary);
       boost::archive::text_iarchive ia(ifs);
       // 从存档中读取类的状态
       ia >> newstop;
       // 在调用析构函数时将关闭存档和流
    }
    return 0;
}
```

这样，对于gps_positon这样的类成员变量，由于为其写过序列化函数了，就可以直接将其序列化

在这里是用：

ar & latitude;

ar & longitude;

的形式，这就是我刚开始唯一知道的序列化的好处。

当然，对于派生的类，应该也能调用基类的序列化函数，这在C++中也应该属于序列化的基本功能。

见下例：

```cpp
// BoostLearn.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

#include <fstream>

// 包含以简单文本格式实现存档的头文件
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>

/////////////////////////////////////////////////////////////
// gps 座标
//
// 举例说明简单类型的序列化
//
class gps_position
{
private:
    friend class boost::serialization::access;
    // 如果类Archive 是一个输出存档，则操作符& 被定义为<<.  同样，如果类Archive
    // 是一个输入存档，则操作符& 被定义为>>.
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
       ar & degrees;
       ar & minutes;
       ar & seconds;
    }
    int degrees;
    int minutes;
    float seconds;
public:
    gps_position()
    {
       degrees = 0;
       minutes = 0;
       seconds = 0.0;
    };
    gps_position(int d, int m, float s) :
    degrees(d), minutes(m), seconds(s)
    {}
};

class bus_stop
{
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    { 
       ar & latitude;
       ar & longitude;
    }

    gps_position latitude;
    gps_position longitude;
public: 
    bus_stop(){ }
    bus_stop(const gps_position & lat_, const gps_position & long_) :
         latitude(lat_), longitude(long_){ }
          
    virtual ~bus_stop(){ }
};

class bus_stop_corner : public bus_stop
{
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
       // 序列化基类信息
       ar & boost::serialization::base_object<bus_stop>(*this);
       ar & street1;
       ar & street2;
    }
    std::string street1;
    std::string street2;

public:
    bus_stop_corner(){}
    bus_stop_corner(const gps_position & lat_, const gps_position & long_,
       const std::string & s1_, const std::string & s2_
       ) :
    bus_stop(lat_, long_), street1(s1_), street2(s2_)
    {}

    virtual std::string description() const
    {
       return street1 \+ " and " \+ street2;
    }
};



int main() {
    // 创建并打开一个输出用的字符存档
    std::ofstream ofs("bus_corner");

    // 创建类实例
    const gps_position latitude(1, 2, 3.3f);
    const gps_position longitude(4, 5, 6.6f);

    bus_stop_corner stop_corner(latitude, longitude, "corn1", "corn2");

    // 保存数据到存档
    {
       boost::archive::text_oarchive oa(ofs);
       // 将类实例写出到存档
       oa << stop_corner;
       // 在调用析构函数时将关闭存档和流
    }

    // ... 晚些时候，将类实例恢复到原来的状态
    bus_stop_corner new_stop_corner;
    {
       // 创建并打开一个输入用的存档
       std::ifstream ifs("bus_corner", std::ios::binary);
       boost::archive::text_iarchive ia(ifs);
       // 从存档中读取类的状态
       ia >> new_stop_corner;
       // 在调用析构函数时将关闭存档和流
    }
    return 0;
}
```

可以尝试调试程序，这里为了简化代码，我没有将信息输出了。

至此，我们已经有了序列化需要的基本功能了，至于其他更多复杂的结构不过就是此种方式的组合而已。另外，此种使用方式已经超过了我公司的序列化类-_-!那个类实现是非常简单的，但是功能似乎也是如此的弱，但是这里的超过不过是通过&符号的重载来简化Serialize函数的调用而已，还算不上什么质的飞跃。下面看质的飞跃所在。

