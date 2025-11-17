---
layout: post
title: "浅谈C++类（1）--概念和构造函数"
categories:
- C++
tags:
- C++
- "构造函数"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '23'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

欢迎转载，但请标明作者 “九天雁翎”，当然，你给出这个帖子的链接更好。

类多么重要我就不多说了，只讲讲学习，因为个人认为类的学习无论从概念的理解还是实际代码的编写相对其他C兼容向的代码都是比较有难度的， 对于以前学C 的人来说这才是真正的新概念和内容，STL其实还比较好理解，不就是一个更大的函数库和代码可以使用嘛。虽然vector,string就是类，不过我们却不需要这样去理解他们，就可以很好的使用了。

先说明，1，这是非常初级的东西。2，你懂了就不需要看了。3，我写出来是帮助还不懂得人。4，我自己也还不太懂，所以才写下来，梳理一下，希望自己能更好的理解，因为我相信一句话，很好的理解一个东西的好方法是把这个东西教给别人。有什么不对的地方，欢迎指出，我非常感谢，还有很多时候，某种方法是不允许的，了解也很重要，但我不想给出错误的例子，那样很容易给出误导，只讲这样是错误的，希望你可以自己输入去尝试一下，看看得出的是什么错误。

一、概念：就Bjarne Stroustup自己说，来自于Simula的概念（The Design and Evolution of C++)，我不懂Simula，所以，还是对我没有什么帮助，基本上，都说类是具体对象（实例）的抽象，怎么抽象？就是把一个实例的特征拿出来，比如，水果是一个类，苹果就是一个实例，苹果有水果的特征。我们只要从苹果香蕉中把特征抽象出来“class Fruits{ }”；就好了。然后 “Fruits apple”，表示苹果是一个水果。就像人是一个类的话，我们就都是实例。一下也讲不清，不过也可以从另一个角度去理解，就是Bjarne Stroustup自己说的，一个Class其实就是一个用户定义的新Type，这点上和Struct没有什么本质上的区别，只是使用上的区别而已。之所以没有把它直接叫作Type是因为他的一个不定义新名字的原则。

二、使用：我一直觉得比较恼火，光看概念是没有用的，学习程序，自己编写代码是最快的。下面是几个步骤：

1：最简单的一个类。

C++中使用任何东西都要先定义吧，类也不例外。用水果举例，水果的特征最起码的名字先这1个吧。名字用string表示。

例1.0:

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
public:             //标号，表示这个类成员可以在外部访问
    string name;           
};
int main()
{
    Fruit apple = {"apple"};  //定义一个Fruit类对象apple
    cout<< apple.name<<endl;  //使用apple的成员name
    return 0;
}
```

在这里说明，以后其他细节我都省略说明了，比如#include,using,cout等等，先去学会吧。我只说类；你会发现其实在这里把class换成struct没有任何问题，的确，而且换成sturct后"public:" 标号都可以省略，记住，在C++里面，struct与class其实没有本质的区别，只是stuct默认成员为public而class默认为private。public顾名思义，就是公共的，谁都可以访问，private自然就是私人的，别人就不能访问了，你把例1.0的public：标号这行去掉试试。你会得到两个错误，1，不能通过 Fruit apple = {"apple"};形式定义，2，cout<<行不能访问私有成员。这里class几乎就和c里面的struct使用没有区别，包括apple.name点操作符表示使用对象apple里面的一个成员，还有Fruit apple = {"apple"};这样的定义初始化方法。很好理解吧，不多说了。说点不同的，C++里面class(struct)不仅可以有数据成员，也可以有函数成员。比如，我们希望类Fruit可以自己输出它的名字，而不是我们从外部访问成员。

例1.1：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
public:             //标号，表示这个类成员可以在外部访问
    string name;            //定义一个name成员           
    void print()              //定义一个输出名字的成员print()
    {
      cout<< name<<endl;
    }
};
int main()
{
    Fruit apple = {"apple"};  //定义一个Fruit类对象apple
    apple.print();  //使用apple的成员print
    return 0;
}
```

这里你会发现与C的不同，而这看起来一点点地不同，即可以在class（struct）中添加函数成员，让C++有了面向对象特征，而C只能是结构化编程（这在C刚出来的时候也是先进的代表，不过却不代表现在的先进编程方法）。还有，你发现定义函数成员和定义普通函数语法是一样的，使用上和普通成员使用也一样。再进一步，在C++中有构造函数的概念,先看例子

例1.2:

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
public:             //标号，表示这个类成员可以在外部访问
    string name;            //定义一个name成员           
    void print()              //定义一个输出名字的成员print()
    {
      cout<< name<<endl;
    }
    Fruit(const string &st)      //定义一个函数名等于类名的函数成员
    {
      name = st;
    }

};
int main()
{
    Fruit apple = Fruit("apple");  //定义一个Fruit类对象apple
    Fruit orange("orange");
    apple.print();  //使用apple的成员print
    orange.print();     
    return 0;
}
```

例子1.2里面的函数名等于类名的函数成员就叫作构造函数，在每次你定义一个新对象的时候，程序自动调用，这里，定义了2个对象，一个apple, 一个orange，分别用了2种不同的方法，你会发现构造函数的作用，这里，要说的是，假如你还按以前的方法Fruit apple = {"apple"}定义apple你会编译失败，因为有了构造函数了，Fruit apple就定义成功了一个对象，让apple对象等于{"apple"}的使用是不允许的。对象只能等于对象，所以你可以先用Fruit("apple")构造一个临时的对象，然后让apple等于它。orange对象的定义就更好理解了，直接调用构造函数嘛。这里要说的是，你不可以直接Fruit banana了，因为没有可以用的构造函数，而没有用构造函数前，你是可以这样做的。直接Fruit apple，再使apple.name = "apple"，是完全可以的。

例1.3：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
public:             //标号，表示这个类成员可以在外部访问
    string name;            //定义一个name成员           
    void print()              //定义一个输出名字的成员print()
    {
      cout<< name<<endl;
    }

};
int main()
{
    Fruit apple;  //定义一个Fruit类对象apple
    apple.name ="apple"; //这时候才初始化apple的成员name
    apple.print();  //使用apple的成员print
     
    return 0;
}
```

而有了构造函数以后就不能这样了，怎么样不失去这种灵活性呢？你有两种办法。其一是重载一个空的构造函数，记得，构造函数也是一个函数，自然也可以重载罗。你还不知道什么是重载？那先去学这个简单的东西吧，类比那家伙复杂太多了。

例1.4:

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
public:             //标号，表示这个类成员可以在外部访问
    string name;            //定义一个name成员           
    void print()              //定义一个输出名字的成员print()
    {
      cout<< name<<endl;
    }
    Fruit(const string &st)
    {
      name = st;
    }
    Fruit(){}    //重载一个空构造函数
};
int main()
{
    Fruit apple;  //定义一个Fruit类对象apple,这时是允许的了，自动调用第2个构造函数
    apple.name ="apple"; //这时候才初始化apple的成员name
    apple.print();  //使用apple的成员print
     
    return 0;
}
```

第二种办法，就是使用构造函数默认实参；

例1.5

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
public:             //标号，表示这个类成员可以在外部访问
    string name;            //定义一个name成员           
    void print()              //定义一个输出名字的成员print()
    {
      cout<< name<<endl;
    }
    Fruit(const string &st = "banana")
    {
      name = st;
    }
};
int main()
{
    Fruit apple;  //定义一个Fruit类对象apple
    apple.print();
    apple.name ="apple";  //这时候才初始化apple的成员name
    apple.print();  //使用apple的成员print
     
    return 0;
}
```

这个程序里面，当你直接定义一个无初始化值的apple对象时，你发现，他直接把name表示为banana。也许现在你会问，为什么需要构造函数呢？这里解释以前留下来的问题。即不推介使用Fruit apple = {"apple"}的原因。因为这样初始化，你必须要保证成员可以访问，当name为私有的时候，这样可就不奏效了，为什么需要私有呢？这就牵涉到类的数据封装问题，类有不希望别人访问的成员，以防破坏内部的完整性，也以防误操作。这点上要讲就很复杂了，不多讲了。只讲操作吧。

例1.6

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
               //没有标号了，表示这个类成员不可以在外部访问，class默认为private哦
    string name;            //定义一个name私有成员           
public:  
    void print()              //定义一个输出名字的成员print()
    {
      cout<< name<<endl;
    }
    Fruit(const string &st = "banana")
    {
      name = st;
    }
};
int main()
{
    Fruit banana;  //定义一个Fruit类对象

    banana.print();
    // banana.name ="apple";  //这时候才改变banana的成员name已经是不允许的了
    // 你要定义一个name等于apple的成员必须这样：
    Fruit apple("apple");
    apple.print();
     
    return 0;
}
```

要说明的是，构造函数你必须定义成公用的啊，因为你必须要在外部调用啊。现在讲讲构造函数特有的形式，初始化列表，这点和一般的函数不一样。

例1.7：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  string name;            //定义一个name成员           
public:  
  void print()              //定义一个输出名字的成员print()
  {
    cout<< name<<endl;
  }
  Fruit(const string &st = "banana"):name(st){}  //看到不同了吗？
};
int main()
{
  Fruit banana;  //定义一个Fruit类对象

  banana.print();
   
  return 0;
}
```

在参数表后，函数实体前，以“：”开头，列出的一个列表，叫初始化列表，这里初始化列表的作用和以前的例子完全一样，就是用st初始化name，问题是，为什么要特别定义这个东西呢？C++ Primer的作者Lippman在书里面声称这时许多相当有经验的C++程序员都没有掌握的一个特性，因为很多时候根本就不需要，用我们以前的形式就够了但有种情况是例外。在说明前我们为我们的Fruit加个固定新成员，而且定义后不希望再改变了，比如颜色。

例1.8：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员           
  const string colour;
public:  
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst){}  
};
int main()
{
  Fruit apple;  //定义一个Fruit类对象apple
  apple.print();
   
  return 0;
}
```

在这里你把colour的初始化放到{}里面，用以前的那种方法，你会发现编译错误，因为它是const的，而实际上放在{}里面是个计算阶段，而放在初始化列表里面就可以，因为初始化列表的使用是在数据定义的时候就自动调用了，因为这个原因，数据的调用顺序和初始化列表里面的顺序无关，只和数据定义的顺序有关，给两个例子，比如你在上面的例子中把初始化列表改为":colour(name),name(nst)"没有任何问题，因为在定义colour前面，name 就已经定义了，但是":name(colour),colour(cst)"却不行，因为在name定义的时候colour还没有被定义，而且问题的严重性在于我可以通过编译.........太严重了，所以在C++ Primer不推荐你使用数据成员初始化另外一个数据，有需要的话，可以":name(cst),colour(cst)"，一样的效果。另外，初始化列表在定义时就自动调用了，所以在构造函数{}之前使用，你可以看看这个例子：

例1.9 ：

```cpp
#include <string>
#include <iostream>
using namespace std;
class Fruit               //定义一个类，名字叫Fruit
{
  string name;     //定义一个name成员           
  const string colour;
public:  
  void print()              //定义一个输出名字的成员print()
  {
    cout<<colour<<" "<<name<<endl;
  }
  Fruit(const string &nst = "apple",const string &cst = "green"):name(nst),colour(cst)
  {
    name +="s";    //这时name已经等于"apple“了
  }   
};
int main()
{
  Fruit apple("apple","red");  //定义一个Fruit类对象apple
  apple.print();
   
  return 0;
}
```

最后输出red apples。先讲到这里吧，你明白一点什么是类没有？像我一样学了老半天还不明白的，坚持住，多练习，总能明白的。我现在似乎明白的多一点了：）