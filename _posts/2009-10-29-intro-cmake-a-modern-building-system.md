---
layout: post
title: CMake简介 - 一个现代软件构建系统
date: 2009-10-29
comments: true
categories: 编程
published: true
tags: 
- CMake
---

第一次见到CMake应该是在Eclipse中的编译工具链选项，但是一直没有太过在意，然后再次认识CMake与许多人一样，是通过KDE的源代码，当我上次查看KDE中右键菜单编辑时，接触了KDE的源代码时，很自然的需要KDE的构建系统，CMake，但是光是用用，也没有在意，直到我看到《通向KDE4之路》系列文章《通向KDE4之路（八）：CMake，新的KDE构建系统》时，（KDE使用者推荐阅读，写的实在是太精彩了！Linux伊甸园的转载版本是比较好的，但是不全，其他很多版本都不带图，少了很多阅读乐趣，KDECN的版本文章较全，就是没有图）对KDE4从autotools工具链转向CMake有了深刻印象，有了一探究竟的想法，毕竟，当年我学习autotools系列工具的时候，压根就没有用心，在公司也没有类似工具的使用氛围，一般都是通过一个简单的模板手工编写makefile，然后整个工程的先后顺序依赖等事情通过bash脚本来管理-_-!呵呵，虽然说实话，因为毕竟公司的工程的改动并不大，而且当时以移植Windows的服务器程序为主，所以还算够用。。。。。另外，要是不是现在没有工作比较清闲，还真没有闲工夫去学习这些东西。

<!-- more -->
<!-- toc-begin -->
**目录**:

* [CMake的主要优点](#cmake的主要优点)
* [CMake安装](#cmake安装)
* [没有用CMake之前](#没有用cmake之前)
* [CMake入门](#cmake入门)
 * [普通程序构建](#普通程序构建)
 * [库依赖处理](#库依赖处理)
 * [静态库构建](#静态库构建)
 * [程序+库的构建](#程序-库的构建)
* [小结](#小结)
* [参考资料：](#参考资料：)

<!-- toc-end -->

# CMake的主要优点

1.容易使用：KDE作为开源世界最大的项目之一那是常吃螃蟹，体验先进技术的先锋力量（因为项目管理需求嘛），svn的使用就是以其带头（《通向KDE4之路》文中有所描述），并且非常成功，然后其他开源项目才开始跟进的，目前svn基本就是开源世界的标准装备嘛。（虽然也有其他迁移趋势了，见我原来的文章《分布式的,新一代版本控制系统mercurial的介绍及简要入门》）。现在开源世界的标准构建系统是autotools，也是KDE3使用的构建系统，但是随着KDE项目的扩大，慢慢不敷使用，按 《通向KDE4之路》作者的说法就是“仅有极少数所谓“编译专家”才能通彻地熟悉整个KDE构建系统”，当然，使用CMake的目的就是改变这种现象，改变后的效果是“事实可以表明，各位KDE编译专家以后可以少死些脑细胞了，每个人都可以较轻松地构建他们的项目并让其运行起来”，这样的评价让我不得不心动。

2.效率高：以下是《通向KDE4之路（八）：CMake，新的KDE构建系统》原文“CMake搜索依赖对象的速度比“./configure”快了好几倍，用CMake构建kdelibs4比用autotools构建KDE 3.5.6的kdelibs所花的时间少了40%，大概是拜CMake不使用libtool组织工具链所致吧。在UNIX平台上，CMake使用的工具链是这样的：cmake+make，然后您再看看KDE 3.5.6的构建工具链：automake+autoconf+libtool+make+sh+perl+m4……伙计，对比一下吧。”

这里有

[*Why the KDE project switched to CMake -- and how (continued)*](https://lwn.net/Articles/188693/)给大家参考KDE4迁移到CMake的经验。优点提了一大片。

每一次学习新东西都是很有乐趣的，虽然刚开始会花费时间用来学习，但是实践证明，因为它们不同于老事物的优点，最后能为我省下的时间会更多，Python,bash,vim,mercurial,AutoHotkey等一大批工具的学习经验都是这样告诉我的。这也是我一次一次学习新东西的动力。


# CMake安装

CMake作为跨平台的开源构建系统，有Windows,Linux下的版本。
Windows下的版本一如既往的有自动安装包。见右边的链接http://www.cmake.org/cmake/resources/software.html
但是因为我使用的是Kubuntu 9.04，安装Linux版本也是如此的容易，apt-get install cmake嘛，不过，因为是kubuntu嘛，一般而言都已经装好了，不劳我们费神再次安装。

# 没有用CMake之前

比如说，以前我在Linux编写程序时，常常自己手工创建一个Makefile，（虽然我利用bash自动生成了原始的Makefile及cpp文件）如下例Test工程中所示：

```makefile
obj = test.o

test : $(obj) 
	g++ -g -o test $(obj) 
    
$(obj) : test.cpp test.h 
	g++ -g -c test.cpp

.PHONY : clean 
clean : 
	-rm test $(obj) 
```

通过这样的Makefile来使的 test.cpp,test.h可以正常被编译，编译时我只需要使用make命令即可。举个例子，比如test.cpp,test.h的内容如下：

```cpp
// test.cpp:
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
	printf("Hello World!/n");

	getchar();
	exit(0);
}

// test.h:(目前无意义，纯为演示）

#include <iostream>
using namespace std;
```

这样，我只需要make，然后就能生成test程序，然后就可以调试或看运行结果了，并且能够通过make clean清理环境，这基本就算一个和那简单的Makefile文件示例了。但是这样的过程有个问题，那就是我每添加一个文件总是需要手工再次编辑Makefile文件，比如，下例中我添加了一个类，然后Makefile文件需要做相应的更改。

添加一个类，2个文件：

```cpp
// Out.cpp
#include "Out.h"

void COut::print()
{
	printf("Hello World!");
}

// Out.h

#ifndef __OUT_H__
#define __OUT_H__
#include <stdio.h>

using namespace std;

class COut
{
	public:
		static void print();
};

#endif  

// test.cpp
#include <stdlib.h>
#include <stdio.h>
#include "Out.h"

int main(int argc, char* argv[] )
{
	COut::print();
	getchar();
	exit(0);
}
```

此时的Makefile就需要手动改变，变成如下形式：

```makefile
# makefile:

obj = test.o

objOut = Out.o

test : $(obj) $(objOut)
	g++ -g -o test $(obj) $(objOut)
    
$(obj) : test.cpp test.h
	g++ -g -c test.cpp

$(objOut) : Out.cpp Out.h
	g++ -g -c Out.cpp

.PHONY : clean

clean :
	-rm test $(obj) $(objOut)
```

并且，每次的文件变动都需要手工改动，事实上，手工改动还有更好点的办法，makefile提供了一些简便的通过%.,$<,$@自动通过后缀匹配的方法，（参看Makefile编写的相关教程）但是事实上，每次的文件变动手工对Makefile的改动还是少不了，更重要的是，文件间的依赖无法简单的人工判断，比如上面这个简单的例子，事实上，test.cpp对Out.o的依赖我就没有加上，这种情况下，重新链接或者编译时常常会出现问题，导致最简单的办法就是直接全部重新编译链接，在我以前的公司基本上也就靠这样的办法，事实上，这些弊端，通过CMake，甚至autotools都是可以解决的。另外，上述仅仅是最最简单的情况，事实上，现实规模的程序起码要包含一大堆的库，库的依赖等事情在手工编写makefile的时候也不得不自己考虑，常常会出现一大堆的函数未实现，有的还好说，自己编写的库的函数未实现大概还知道在哪，常常有系统函数的未实现连具体漏了哪个库都难发现，反复的链接，分析也是的确烦人，这种重复枯燥的工作自然不应该由程序员来做，浪费生命，再更进一步的讲，分发源代码的时候怎么保证别人的机器配置与你的一样啊？gcc所在的目录，各种库所在的目录，这些都没有办法强制指定-_-！这就不是简单复杂的问题了，而是实现上的问题。更甚者，一样的源代码也允许不一样的编辑工具啊，有人习惯vim,有人习惯emacs，有人喜欢eclipse，怎么协调统一啊？当然，同一公司可以统一规定，但是开源的世界还那么多规矩那就不现实了，下面我们对比一下CMake使用时的解决方案。


# CMake入门

CMake靠的是CMakeLists.txt文件来生成工程的，事实上、CMakeList.txt的编写就如使用make时编写Makefile，只不过，相对来说CMake站的高度更高一些，所以虽然还是要编写一个配置文件，但是CMakefile的编写比makefile轻松简单很多，而CMake最后其实还是通过生成makefile的方式来管理工程的（事实上，CMake可以生成多种工程文件，甚至支持eclipse和VC-_-!）

## 普通程序构建

比如，在上面那个简单的HelloWorld例子中，我们只需要编写一个如下面所示的CMakeLists.txt文件即可：

```cmake
project(test)
set(CMAKE_CXX_FLAGS "-g -Wall")
set(SRC_LIST test.cpp)
add_executable(test ${SRC_LIST})
```

保存文件，然后可以通过在原工程中添加子目录的（也可以是另外的目录）方式隔离CMakefile及以后编译生成的中间文件对源程序的干扰（这点非常出彩），深受VS自动创建文件导致源代码管理的时候老是要去处理的我那是尤为感叹。（当然，假如用VSS管理就好一点，我用mercurial就烦了）
原来我们常用的autotools构建编译软件的步骤就是众所周知的

`./configure && make && make install`

语句了，当年redhat9时代，不会用yum的时候，没有少使用过，我甚至将其直接设了ml的别名。
现在我们使用CMake的方式是

`cmake ../ && make && make install`

当然，这个命令差别都不算太大，另外这里我们还没有install-_-!
在子目录中（我将其命名为build）中，运行`cmake ../`，
然后出现一大堆的信息：

```bash
jtianling@jtianling-laptop:~/test/cmakeTest2/build$ cmake ../
-- The C compiler identification is GNU
-- The CXX compiler identification is GNU
-- Check for working C compiler: /usr/bin/gcc
-- Check for working C compiler: /usr/bin/gcc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Configuring done
-- Generating done
-- Build files have been written to: /home/jtianling/test/cmakeTest2/build
jtianling@jtianling-laptop:~/test/cmakeTest2/build$ 
```

此时，Makefile文件就生成完了，我们可以看看，一大堆的东西，看不懂也没有关系，直接make就好了，如下所示：

```bash
jtianling@jtianling-laptop:~/test/cmakeTest2/build$ make
Scanning dependencies of target test
[100%] Building CXX object CMakeFiles/test.dir/test.cpp.o
Linking CXX executable test
[100%] Built target test
jtianling@jtianling-laptop:~/test/cmakeTest2/build$ ls
CMakeCache.txt  CMakeFiles  cmake_install.cmake  Makefile  test
jtianling@jtianling-laptop:~/test/cmakeTest2/build$ 
```

假如不是通过putty远程的话，还能看到一些颜色信息。此时我们可以看到test程序已经生成出来了，运行看看，没有什么问题。

对比一下，在编写Makefile时，我们编写了8，9行，而CMakeLists.txt我们仅仅用了4行，呵呵，这里虽然少了一倍，但是我们增加了Makefile生成的过程，也不能仅仅说这样就说CMake多么好。下面慢慢看。这里先解释一下CMakeList.txt各句的含义：

`project(test)`

设定工程名
~~~
set(CMAKE_CXX_FLAGS "-g -Wall")
set(SRC_LIST test.cpp)
~~~

set用于指定变量，这里指定了CMAKE_CXX_FLAGS为”-g -Wall”，CMAKE_CXX_FLAGS为CMake内置的变量，我们通过修改此变量，达到生成的Makefile文件编译时添加调试和警告信息（这是g++编译选项的知识了），后一个set指定SRC_LIST变量的值为test.cpp，这是我们的用户变量

`add_executable(test ${SRC_LIST})`

指定添加生成一个名为test的程序，依赖于SRC_LIST变量，${SRC_LIST}的变量引用方式与makefile,bash中的类似。

以上4句，确认了test工程的生成规则。

当我们添加了文件后，我们还需要对CMakeLists.txt进行更进一步的更改，比如上例添加Out.cpp的情况。

我们在上述第3行添加Out.cpp文件，如下面的形式：

`set(SRC_LIST test.cpp Out.cpp)`

然后才能正确的生成Makefile，比上述Makefile的手工编写时节省的时间不是一点两点，但是，作为世界上最懒惰群体之一的程序员（不是说以懒惰为美德嘛，那估计是够懒的了），觉得这样也是教麻烦的，不然怎么大家都喜欢IDE呢-_-!事实上，CMake的编写者自然也就是程序员，自然也就是很懒，自然也提供了更简单的办法，只需要将上面的CMakeLists.txt改成目录依赖的形式，一切就简单了。将上述CMakeLists.txt的第3行改成下面这样：

`aux_source_directory(./ SRC_LIST)`

这样，CMake会自动搜寻./中的源文件，然后自动赋予SRC_LIST变量，这样，你添加成千上万个文件也没有关系，只需要重新运行CMake，就好了，呵呵，一切的简单程度是不是超乎想象啊？学习了以后，你会惊呼，这就是我想要的东西！（当然，假如你以前手工编写过makefile或者使用的是autotools的话，使用IDE的到目前为止当我没有说过此话）

使用此CMakeFiles.txt后，我们不再需要为源代码的添加额外改动任何东西，见下面的执行过程：（警告信息是告诉我们去指定最小需要的cmake版本，对于此演示来说管不管都无所谓，以后都不管了）

```bash
jtianling@jtianling-laptop:~/test/cmakeTest/build$ cmake ../
CMake Warning (dev) in CMakeLists.txt:
  No cmake_minimum_required command is present.  A line of code such as

    cmake_minimum_required(VERSION 2.6)

  should be added at the top of the file.  The version specified may be lower
  if you wish to support older CMake versions for this project.  For more
  information run "cmake --help-policy CMP0000".
This warning is for project developers.  Use -Wno-dev to suppress it.

-- Configuring done
-- Generating done
-- Build files have been written to: /home/jtianling/test/cmakeTest/build
jtianling@jtianling-laptop:~/test/cmakeTest/build$ make
Scanning dependencies of target test
[ 50%] Building CXX object CMakeFiles/test.dir/Out.o
[100%] Building CXX object CMakeFiles/test.dir/test.o
Linking CXX executable test
[100%] Built target test
jtianling@jtianling-laptop:~/test/cmakeTest/build$ 
```

自动的完成了编译，并且自动的添加了Out.cpp的依赖，呵呵，这种过程比起手工编写makefile就像是从手洗衣服到使用全自动洗衣机一样愉快。（当然，工程文件的目录管理那就得用心了，再乱七八糟估计是不能用这种方式来简化了）

## 库依赖处理

手工编写makefile时，你的知道gcc,g++的语法，添加一堆的-I,-l之类的东西，具体在哪个目录还的自己去找，这个也太不人性了（事实上还是推荐学会gcc,g++的语法，makefiley也推荐学会，毕竟不是每个地方都有CMake可用，毕竟还是有需要处理这种原始依赖和编译选项的时候），CMake对其进行了一定的简化。

此处以《Unix/Linux编程实践教程》中的一个curses例子为例，原代码如下：

```c
/* hello3.c
 *      purpose  using refresh and sleep for animated effects
 *      outline  initialize, draw stuff, wrap up
 */
#include        <stdio.h>
#include        <curses.h>

main()
{
	int     i;

	initscr();
	clear();
	for(i=0; i<LINES; i++ ){
		move( i, i+i );
		if ( i%2 == 1 ) 
			standout();
		addstr("Hello, world");
		if ( i%2 == 1 ) 
			standend();
		sleep(1);
		refresh();
	}
	endwin();
}
```

此例需要使用curses库，我们只需要在CMakeLists.txt中添加一句话就够了。如下：

`link_libraries(curses)`

剩下的就交给CMake了。

## 静态库构建

上面是说怎么链接系统的库的，CMake还为我们自己编译库提供了方便，了解了上述知识后，会发现编译一个库也是如此简单哪。

比如将上例中的out类给独立出一个库来，在原来的目录下面单独建立一个out目录，编写如下CMakeLists.txt文件:

```cmake
project(out)

set(CMAKE_CXX_FLAGS "-g -Wall")

aux_source_directory(./ SRC_LIST)

add_library(out ${SRC_LIST})
```

会发现，其实编写一个静态库需要的做的仅仅是最后一行从add_excuteable到add_library的区别-_-!简单到让人无语。编译后，一个名为libout.a的文件就生成了，名字也按Linux的惯例取好了。

## 程序+库的构建

用系统的库很简单，我们已经看到了，上面我们得到一个自己的库了，怎么和程序一起构建呢？也是很容易的。比如，保持上述目录结构，我们利用以下的CMakeLists.txt就可以自动生成自己的库，并完成test到库的依赖：

```cmake
project(test)

set(CMAKE_CXX_FLAGS "-g -Wall")

aux_source_directory(out/ LIB_SRC_LIST)

add_library(out ${LIB_SRC_LIST})

link_libraries(out)

aux_source_directory(./ SRC_LIST)

add_executable(test ${SRC_LIST})
```

呵呵，没有任何新内容，就是设定目录的时候注意一点，so easy？YES!

# 小结
事实上CMake比我上面讲述的功能要强大的多，甚至可以直接帮助生成安装文件及完成自动化测试，也有很多复杂的语法，这些功能就只能靠大家自己慢慢学习和挖掘了，无法尽述。上面仅仅是对CMake进行简单工程管理时有多么简单进行了一些描述。基本可以适应小规模的工程管理使用，相对来说比手工编写makefile要简单的多，更适于平时使用，并且到了源代码发布哪天，更加会轻松不少。其语法也比gcc/g++的命令行参数要直观易记的多。并且，随着KDE4的吃螃蟹，并且非常成功，不久的将来，开源世界的构建工具可能会如同当年从cvs到svn一样，从autotools改成CMake的世界^^事实上，从我学习的感受来说，CMake的学习难度也比autotools工具链要简单的多，期待着那一天的到来吧:)

# 参考资料：
[*通向KDE4之路（八）：CMake，新的KDE构建系统*](http://www.programgo.com/article/38663932106/) -- 我学习CMake的原因
[*CMake 实践*](http://sewm.pku.edu.cn/src/paradise/reference/CMake%20Practice.pdf) -- 非常好的教程
[*CMake How To*](http://www.cs.swarthmore.edu/~adanner/tips/cmake.php)-- 较好的CMake教程