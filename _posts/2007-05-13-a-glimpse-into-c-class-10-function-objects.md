---
layout: post
title: "浅谈C++类（10）--函数对象"
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
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

好久好久没有时间学C++了，郁闷，主要是因为最近有考试逼近，不得不看一些其他的书。看那些不能说没有用处，但是实在是不怎么感兴趣的书，也是一种痛苦。今天很晚了，抽出点时间，学了个很有用的东--函数对象，的确很有用。关于操作符重载其实并没有讲完，比如前++，后++，*，[]等等但是都差不多，感觉没有什么好讲的，我个人对这个浅谈系列的定位感觉应该是一些自己的笔记和心得，并不像让它成为百科，因为以前太过于求全，浪费了太多时间，以后碰到想讲的就讲，不想讲的就不为了全而凑数了。回到主题，先看一个我没有讲过的操作符重载（），在一个家伙后面加括号，那不就是函数吗？恩，就让类可以像函数一样调用！呵呵，搞了这么久，类才有点新意。看个没有函数对象的例子先，还是我们的水果，当然为了简单，我把以前那些复杂的东西都删了，就是个简单的水果。

<!-- more -->

例10.0：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
...{
    string colour;   //定义一个colour成员表示颜色
    string name;     //定义一个name成员表示名字  
    double weight;   //定义一个weight成员表示重量
public:
    Fruit(const string &cst = "green",const string &nst = "apple",const double &dw = 0.0):colour(cst),name(nst),weight(dw)//构造函数
    ...{
    }
    ~Fruit()   //析构函数不需要定义，用系统的就好了
    ...{
    }  
    bool equalName(const Fruit &orign)
    ...{
        return name == orign.name;
    }
    bool equalColour(const Fruit &origc)
    ...{
        return colour == origc.colour;
    }
    bool equalWeight(const Fruit &origw)
    ...{
        return weight == origw.weight;
    }
};

int main()
...{
    Fruit greenApple;
    Fruit redApple("red");
    Fruit blueApple("blue","apple",1.0);
    cout<<greenApple.equalName(redApple)<<endl;
    cout<<greenApple.equalName(blueApple)<<endl;
    cout<<redApple.equalWeight(blueApple)<<endl;
    
    return 0;
}
```

不要抱怨我以前的程序怎么没有缩进，其实我缩进了，不过复制过来就没有了，现在才知道可以插入代码的方式插入，然后看起来好像是好一些了。这个程序无非就是定义了3个成员函数，然后测试了下是否正常工作。现在我们从一个奇怪的出发点来考虑一下，假如现在需要调用equalName很多次，每次都要这样调用嫌麻烦了一点，怎么办？呵呵，把equalName()改名为e(),自然 不错，你还要一个小点和e呢，假如用成员函数的话，都省略了，当然，在这种情况下，意义有点含糊了。不过简便还是简便了。看例10.1：

例１０．１:

```cpp
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
...{
    string colour;   //定义一个colour成员表示颜色
    string name;     //定义一个name成员表示名字  
    double weight;   //定义一个weight成员表示重量
public:
    Fruit(const string &cst = "green",const string &nst = "apple",const double &dw = 0.0):colour(cst),name(nst),weight(dw)//构造函数
    ...{
    }
    ~Fruit()   //析构函数不需要定义，用系统的就好了
    ...{
    }  
    bool equalName(const Fruit &orign)
    ...{
        return name == orign.name;
    }
    bool equalColour(const Fruit &origc)
    ...{
        return colour == origc.colour;
    }
    bool equalWeight(const Fruit &origw)
    ...{
        return weight == origw.weight;
    }
    bool operator()(const Fruit &orig)    //重载了（）操作符
    ...{
        return equalName(orig);
    }
};

int main()
...{
    Fruit greenApple;
    Fruit redApple("red");
    Fruit blueApple("blue","apple",1.0);
    Fruit redOrange("red","orange");
    Fruit yellowOrange("yellow","orange");
    cout<<greenApple(redApple)<<endl;   //假设这个要调用很多次：）还是很方便的
    return 0;
}
```

用处可不只这一点啊，在一些标准库中的应用更是方便，见下例：

例10.2：

```cpp
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
...{
    string colour;   //定义一个colour成员表示颜色
    string name;     //定义一个name成员表示名字  
    double weight;   //定义一个weight成员表示重量
public:
    Fruit(const string &cst = "green",const string &nst = "apple",const double &dw = 0.0):colour(cst),name(nst),weight(dw)//构造函数
    ...{
    }
    ~Fruit()   //析构函数不需要定义，用系统的就好了
    ...{
    }  
    bool equalName(const Fruit &orign)
    ...{
        return name == orign.name;
    }
    bool equalColour(const Fruit &origc)
    ...{
        return colour == origc.colour;
    }
    bool equalWeight(const Fruit &origw)
    ...{
        return weight == origw.weight;
    }
    bool operator()(const Fruit &orig)
    ...{
        return equalName(orig);
    }
};

int main()
...{
    Fruit greenApple;
    Fruit redApple("red");
    Fruit blueApple("blue","apple",1.0);
    Fruit redOrange("red","orange");
    Fruit yellowOrange("yellow","orange");
    vector<Fruit> aveF;
    aveF.push_back(greenApple);
    aveF.push_back(redApple);
    aveF.push_back(blueApple);
    aveF.push_back(redOrange);
    aveF.push_back(yellowOrange);
    cout<<count_if(aveF.begin(),aveF.end(),greenApple)<<endl;//第一种调用方式
    cout<<count_if(aveF.begin(),aveF.end(),Fruit("green","orange"))<<endl;//第二种方式，创建一个临时对象
    return 0;
}
```

是不是同意我的观点了？很有用吧。因为太有用了，标准库也定义了一批函数对象模板给我们用，详细的我一下肯定也说不完，也超出本文范围了，查查资料吧。还有个函数对象适配器，也很有意思。看个例子。

例10.3：

```cpp
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
#include <functional>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
...{
    string colour;   //定义一个colour成员表示颜色
    string name;     //定义一个name成员表示名字  
    double weight;   //定义一个weight成员表示重量
public:
    Fruit(const string &cst = "green",const string &nst = "apple",const double &dw = 0.0):colour(cst),name(nst),weight(dw)//构造函数
    ...{
    }
    ~Fruit()   //析构函数不需要定义，用系统的就好了
    ...{
    }  
    friend bool operator==(const Fruit&,const Fruit&);
};
bool operator==(const Fruit &lf,const Fruit &rf)  //重载一个==操作符表示名字相等
...{
    return lf.name == rf.name;
}

int main()
...{
    Fruit greenApple;
    Fruit redApple("red");
    Fruit blueApple("blue","apple",1.0);
    Fruit redOrange("red","orange");
    Fruit yellowOrange("yellow","orange");
    vector<Fruit> aveF;
    aveF.push_back(greenApple);
    aveF.push_back(redApple);
    aveF.push_back(blueApple);
    aveF.push_back(redOrange);
    aveF.push_back(yellowOrange);
    cout<<count_if(aveF.begin(),aveF.end(), bind2nd ( equal_to<Fruit>() , Fruit("green","apple")))<<endl;
    cout<<count_if(aveF.begin(),aveF.end(), bind2nd ( equal_to<Fruit>() , Fruit("green","orange")))<<endl;
    cout<<count_if(aveF.begin(),aveF.end(),not1 ( bind2nd ( equal_to<Fruit>() , Fruit("green","apple"))))<<endl;
    cout<<count_if(aveF.begin(),aveF.end(),not1 ( bind2nd ( equal_to<Fruit>() , Fruit("green","orange"))))<<endl;
    return 0;
}
```

这个程序其他部分都很简单，主要就是最后那几行比较难理解，好像也很复杂，恩，是很复杂，但是当你了解他实现的更复杂的功能的时候，你会发现，那其实是多么的简单。我只讲最后一行，其他自己理解：）Fruit("green","orange")表示建立一个名为orange的临时Fruit对象，equal_to<Fruit>()就是我说的标准库里面的一个函数对象模板，它对（）内的2个操作数调用==操作符并返回bool值，这里似乎他没有参数，呵呵，因为bind2nd表示绑定一个值给2元函数的第2个实参，相应的bind1st表示绑定给第一个，他们自己都是接受两个2个参数，第一个为一个函数对象，第二个为你要绑定的值，not1表示对一个1元操作取反。count_if我就不说了，也就是说，最后一句输出表示输出aveF中名字不为orange的对象的数目。呵呵，功能强大：）想想没有这些功能你需要怎么去实现吧，然后把数目扩大。。。。。
