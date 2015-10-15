---
layout: post
title: "Cocos2d-x 的内存管理漫谈"
date: 2013-04-07
comments: true
categories: 编程
tags: 
- Cocos2d-x 
- Spine 
- C++ 
- memory manage
- 内存管理
---
 
既然选择了C++作为游戏开发的语言, 手动的管理内存是难以避免的, 而Cocos2d-x的仿Objctive-C的内存管理方式, 事实上让问题变得更加复杂(仅仅是移植更加方便了), 因为你需要很好的掌握两种语言的内存管理方式, 并且在使用时头脑清晰, 不能混用, 不然等待你的就是无穷的噩梦, 因为引用计数的原因, 问题比起纯粹的C++内存泄漏还要难以定位的多.
这里统一的整理一下目前在Cocos2d-x中的内存管理相关的方法和问题.  为了让思路更加清晰, 我提及的不仅仅是具体在Cocos2d-x中怎么用, 也包含一些为啥在Cocos2d-x中应该这么用.
并且, 因为以下讲到的每个点要讲的详细了, 其实都可以写一整篇文章了, 没法在短时间内详述, 这篇文章也就仅仅作为一个引子而已.

<!-- more -->
<!-- toc-begin -->
**目录**:

* [C++的内存管理](#c-的内存管理)
 * [C语言的malloc, free](#c语言的malloc-free)
 * [C++的new, delete, new[], delete[]](#c-的new-delete-new-delete)
 * [C/C++内存管理的实际使用](#c-c-内存管理的实际使用)
* [Objective-C的内存管理](#objective-c的内存管理)
 * [引用计数](#引用计数)
 * [容器对引用计数的影响](#容器对引用计数的影响)
 * [内存池](#内存池)
 * [ARC(Automatic Reference Counting)](#arc-automatic-reference-counting)
* [Cocos2d-x的内存管理](#cocos2d-x的内存管理)
 * [简单情况](#简单情况)
 * [容器对引用计数的影响](#容器对引用计数的影响)
 * [内存池](#内存池)
* [小结](#小结)

<!-- toc-end -->

# C++的内存管理
## C语言的malloc, free
因为C++基本兼容C, 所以C语言的malloc和free也是支持的.  简单的说用法就是malloc后记得free即可. 

~~~ cpp
#include <stdio.h>
#include <stdlib.h>

const size_t kBufferSize = 16;
void test() {
	char *buffer = (char*)malloc(kBufferSize);
	memset(buffer, 0, sizeof(char) * kBufferSize);

	sprintf(buffer, "%s", "Hello World\n");
	printf(buffer);

	free(buffer);
}


int main(int, char**) {
	test();
	return 0;
}
~~~

当然, 还有realloc和calloc这两个平时较少用的内存分配函数, 这里不提了, 在C语言时代, 我们就是用malloc和free解决了我们的内存问题.  重复的对同一段内存进行free是不安全的, 同时, 为了防止free后, 还拿着指针使用(即野指针), 我们一般使用将free后的内存置空.  
因为这种操作特别的多, 我们常常会弄一个宏, 比如Cocos2d-x中的

~~~ cpp
#define CC_SAFE_FREE(p)			if(p) { free(p); p = 0; }
~~~

## C++的new, delete, new[], delete[]
为什么malloc和free在C++时代还不够呢?  malloc,free在C++中使用有如下的缺点:

1. malloc和free并不知道class的存在, 所以不会调用对象的构造函数和析构函数.  
2. malloc返回的是void*, 不符合C++向强类型发展的趋势.  

于是, BS在C++中增加了new-delete组合以替代malloc, free.  其实new, delete基本上都是用malloc, free实现的更高层函数, 只是增加了构造和析构的调用而已.  所以在平时使用的时候并无区别, 但是因为malloc其实是记录了分配的长度的, 长度以字节为单位, 所以一句malloc对应即可, 不管你是malloc出一个char, 一个int,  还是char的数组或者int的数组, 单位其实都是字节.  而长度一般记录在这个内存块的前几个字节, 在Windows中, 甚至可以使用[_msize](http://msdn.microsoft.com/en-us/library/z2s077bc.aspx)函数从指针中取出malloc出的内存长度.  
而new的时候有两种情况, 可以是一个对象, 也可以是对象的数组, 并且, 没有统一的记录长度.  使得我们需要通过自己记住什么时候new出了一个对象, 什么时候new出了多个对象.  这个问题最近云风还[吐槽过](http://blog.codingnow.com/2013/01/memory_bug.html).  并且增加了delete[]用于删除new出多个对象的情况.  让问题更加容易隐藏不被发现的是, 当你讲delete用于new[]分配的内存时, 实际相当于删除了第一个对象, 是完全正确的语法, 不会报任何错误, 你只能在运行出现诡异问题的时候再去排查.  
这个问题实际是语言设计的决策问题.  在BS这个完美主义者这里, C++语言的设计原则之一就是零负荷规则 -- 你不会为你所不使用的部分付出代价.  并且在这里这个规则执行的显然是要比C语言还要严格.  当你只分配一个对象的时候, 为啥要像分配多个对象时一样, 记录一个肯定为1的计数呢?  估计BS是这么想的.  于是我们只好用人工来区分delete和delete[].  某年某月, 我看到某人说C++是实用主义, 我笑了, 然后我看到C++的一条设计原则是"不一味的追求完美", 我哭了......  

~~~ cpp
#include <stdio.h>

class Test {
	public:
		Test() {
			test_ = __LINE__;
			printf("Test(): Run Code in %d\n", __LINE__);
		}

		~Test() {
			test_ = __LINE__;
			printf("~Test(): Run Code in %d\n", __LINE__);
		}

		void print() {
			printf("%d\n", test_);
		}

	private:
		int test_;
};

void test() {
	Test *temp = new Test;
	delete temp;


	Test *temps = new Test[2];
	delete []temps;

	Test *error_delete_temps = new Test[2];
	delete error_delete_temps;
}

int main(int, char **) {

	test();

	return 0;
}
~~~

上面的代码最后用delete删除了使用new[]分配的内存, 但是编译时即使开启-wall选项, 你也不会看到任何的警告, 运行时也不会报错, 你只会发现析构函数少运行了一次.  实际上就是发生了内存泄漏.  

## C/C++内存管理的实际使用
上面虚构的例子也就是看看语法, 真实的使用情景就要复杂了很多.  最重要的原则之一就是谁分配谁释放原则.  这个原则即使是用malloc, free也一样需要遵循.  
在C语言上的表现形态大概如下:  
### 只管用, 不管分配
典型的例子就是C语言的文件读取API: 

~~~ cpp
size_t fread ( void * ptr, size_t size, size_t count, FILE * stream );
~~~

这里的ptr buffer并不由fread内部分配, 而是由外部传进来, fread只管使用这段buffer, 并且假设这段buffer的size 大于等于传进来的size.  通过这样的方式, fread本身逃避了malloc, free的责任, 也就不用关心内存该怎么管理的问题.  好处是fread的实现得到简化, 坏处是外部使用的负担增加了~~~  
类似的API还有sprintf, fgets等, 而strcat这种API也算是这种类型的变化.  
  
这种类型的API的一个最大问题在于很多时候不好确定buffer到底该多大, 于是在一些时候, 还有一个复杂的用法, 那就是在第一次传特定参数调用函数时, 函数仅传出需要buffer的大小, 分配了buffer后, 第二次调用才真正实现函数的功能.  
  
这种API虽然外部的使用麻烦, 但是在绝大部分时候, 已经是C语言的最佳API设计方法.  

### 管分配, 也管删除
只管用, 不管分配的API设计方式在仅仅需要一个buffer, 或者简单的结构缓存的时候基本已经够用, 但也不是万能的, 在想要隐藏内部实现时, 往往就没法使用这样的API设计, 比如Windows API中一系列与核心对象创建相关的方法, 如CreateThread, CreateProcess等函数返回的都是一个核心对象的handle, 然后必须要使用CloseHandle来释放, handle具体的对应什么结构, 分配了多少内存, 此时并不由我们关心, 我们只需要保证一个CreateXXX, 就一定要CloseHandle即可.  
这种API的设计方式, 还常见于我们熟知的工厂模式, 工厂模式提供Create和Delete的接口, 就要比只提供Create接口, 让外部自己去Delete要好的多, 此时外部不用关心对象的删除方式, 将来需要在创建对象时进行更多操作(比如对对象进行引用计数管理), 外部代码也不需要更改.  我在网上随便一搜, 发现绝大部分关于工厂模式的代码中都没有考虑这个问题, 需要特别注意.  
这里看一个我们常见的开源游戏引擎Ogre中的例子:  (Ogre1.8.1 OgreFileSystem.h)

~~~ cpp
/** Specialisation of ArchiveFactory for FileSystem files. */
//class _OgrePrivate FileSystemArchiveFactory : public ArchiveFactory
class _OgreExport FileSystemArchiveFactory : public ArchiveFactory
{
	public:
		virtual ~FileSystemArchiveFactory() {}
		/// @copydoc FactoryObj::getType
		const String& getType(void) const;
		/// @copydoc FactoryObj::createInstance
		Archive *createInstance( const String& name ) 
		{
			return OGRE_NEW FileSystemArchive(name, "FileSystem");
		}
		/// @copydoc FactoryObj::destroyInstance
		void destroyInstance( Archive* arch) { delete arch; }
};
~~~

这里这个FileSystemArchiveFactory就是典型的例子.  虽然这里的destroyInstance仅仅是一个delete, 但是还是这么设计了接口.  

### 单独的缓存
一般而言, 所有与内存管理相关的C语言API设计都应该使用上面提到的两种方案, 其他的方案基本都是错的(或者有问题的),  但是因为各种考虑, 还是有些很少见的设计, 这里把一些可能出现的设计也列出来.  
所谓的单独缓存的设计, 指的是一段代码内部的确需要缓存, 但是不由外部传入, 而是自己直接分配, 只是每次的调用都使用这一份缓存, 不再释放.  
比如C语言中对错误字符串的处理:  

~~~ cpp
char * strerror ( int errnum );
~~~

strerror这个API的设计咋一看就有蹊跷, 什么样的设计能传入一个整数, 然后返回一个字符串呢? 字符串的存储空间哪里来的?  一个简单的例子就能看出这样设计的问题:  

~~~ cpp
#include <stdio.h>
#include <string.h>
#include <errno.h>

int main ()
{
	char *error1 = strerror(EPERM);
	printf ("%s\n", error1);

	char *error2 = strerror(ENOENT);
	printf ("%s\n", error1);
	printf ("%s\n", error2);

	return 0;
}
~~~

此时会输出: 
Operation not permitted 
No such file or directory 
No such file or directory 

意思就是说, 当第二次调用strerror的时候, 连error1的内容都变了, 对于不明情况的使用者来说, 这绝对是个很意外的情况.  虽然说, 这个例子比较极端, 在错误处理的时候不太可能出现, 但是这种设计带来的问题都是类似的.  至于为什么获得错误字符串的API要做这样的设计, 我就无从得知了, 可能是从易用性出发更多一些吧.  
在另外一些基于效率的考虑时, 也可能会使用这样的设计,  我只在一个对效率有极端要求的情况下, 在真实项目环境中见过这样的设计.  那是在做服务器的时候, 一些辅助函数(对收发数据包的处理)需要大的缓存, 同时操作较为频繁并且效率敏感, 才使用了这样的设计.  
一般来说, 这种设计常常导致更多的问题,  让你觉得获得的效率提升付出了不值得的代价.  所以除非万一, 并不推荐使用. 

### 我分配, 你负责释放
这种API的唯一好处就是看起来使用较为简单, 但是在任何情况下, 都不仅仅是容易导致更多问题, 这种设计就是问题本身, 几乎只有错误的代码才会使用这样的设计, 起码有以下几个简单的原因:  

1. 返回一段buffer的接口, 内部可以使用new, 也可能使用malloc分配, 外部如何决定该使用delete还是free释放, 只能额外说明, 或者看源代码.
2. 当API跨内存空间调用时, 就等于错误, 比如当API在动态库中时.  这是100%的错误, 无论是delete还是free, 也不能释放一个在动态库中分配的内存.

正是因为这两个原因, 你几乎不能在任何成熟的代码中看到这样的设计.  但是, 总有人经受不了使用看起来简单的这个诱惑, 比如Cocos2d-x中CCFileUtils类的两个接口:  

~~~ cpp
/**
	@brief Get resource file data
	@param[in]  pszFileName The resource file name which contains the path.
	@param[in]  pszMode The read mode of the file.
	@param[out] pSize If the file read operation succeeds, it will be the data size, otherwise 0.
	@return Upon success, a pointer to the data is returned, otherwise NULL.
	@warning Recall: you are responsible for calling delete[] on any Non-NULL pointer returned.
 */
unsigned char* getFileData(const char* pszFileName, const char* pszMode, unsigned long * pSize);

/**
	@brief Get resource file data from a zip file.
	@param[in]  pszFileName The resource file name which contains the relative path of the zip file.
	@param[out] pSize If the file read operation succeeds, it will be the data size, otherwise 0.
	@return Upon success, a pointer to the data is returned, otherwise NULL.
	@warning Recall: you are responsible for calling delete[] on any Non-NULL pointer returned.
 */
unsigned char* getFileDataFromZip(const char* pszZipFilePath, const char* pszFileName, unsigned long * pSize);
~~~

这种直接返回数据的接口自然比fread这样的接口看起来容易使用很多, 同时还通过一个warning的注释表明了, 应该使用delete[]来释放返回的缓存, 以避免前面提到的第一个问题, 但是, 不管再怎么做, 当你将Cocos2d-x编译成动态库, 然后尝试使用上述两个API, 等待你的就是错误.  有兴趣的可以尝试.  
这种API还是偶尔能见到, 有的时候可能还不如上面这个例子这么明显, 比如当一个函数要求传入Class** obj参数, 并且返回对象的时候, 其实也已经是一样的效果了.   
再次声明, 个人认为这种API本身就是错误, 不推荐在任何时候使用, 看到这么设计的API, 也最好不要在任何时候调用.  

### C++对内存管理的改进
上述提到的几种涉及内存分配的API设计虽然是C语言时代的, 但是基本也适用于C++.  只是在C++中, 在Class层面, 对内存管理进行了一些新的改进.  
有new就delete, 有malloc就free, 听起来很简单, 但是在一些复杂情况下, 还是会成为负担, 让代码变得很难看.  更不要提, 程序员其实也是会犯错误的.  C++对此的解决之道之一就是通过构造函数和析构函数.  
看下面的例子:  
在极其简单的情况下, 我们这样就能保证内存不泄漏:  

~~~ cpp
const int32_t kBufferSize = 32;
void Test1() {
	char *buffer = new char[kBufferSize];

	// code here

	delete[] buffer;
}
~~~

但是, 这仅限于最简单的情况, 当有可能的错误发生时, 情况就复杂了:  

~~~ cpp
const int32_t kBufferSize = 32;
bool Init() {
	char *buffer = new char[kBufferSize];

	bool result = true;

	// code here

	if (!result) {
		delete[] buffer;
		return false;
	}

	char *buffer2 = new buffer[kBufferSize];

	// code here

	if (!result) {
		delete[] buffer;
		delete[] buffer2;
		return false;
	}

	delete[] buffer;
	delete[] buffer2;
	return true;
}
~~~
    
仅仅是两次错误处理, 分配两段内存, 你不小心的写代码, 就很有可能出现错误了.  这不是什么好事情, 更进一步的说, 其实, 我上面这段话还是基于不考虑异常的情况, 当考虑异常发生时, 上述代码就已经是可能发生内存泄漏的代码了.  考虑到异常, 当尝试分配buffer2的内存时, 假如分配失败, 此时会抛出异常(对, 在C++中普通的new分配失败是抛出异常, 而不是返回NULL), 那么实际上此时buffer指向的内存就没有代码负责释放了.  在C++中, 讲buffer放入对象中, 通过析构函数来保证内存的时候, 就不会有这样的问题, 因为C++的设计保证了, 无论以何种方式退出作用域(不管是正常退出还是异常), 临时对象的析构函数都会被调用.  
代码大概就会如下面这样:  

~~~ cpp
const int32_t kBufferSize = 32;

class Test {
	public:
		Test() {
			buffer_ = new char[kBufferSize];
		}

		~Test() {
			delete[] buffer_;
		}

		bool process() {
			// code here

			return true;
		}


	private:
		char *buffer_;
};

bool Init2() {
	Test test;

	bool result = test.process();

	if (!result) {
		return false;
	}

	Test test2;
	result = test2.process();

	if (!result) {
		return false;
	}

	return true;
}
~~~

在最简单的情况下, 我们也没有必要构造一个类似上面这种纯粹为了存储Buffer的类, C++ 11中提供了智能指针来完成上述工作:  

~~~ cpp
#include <stdio.h>
#include <stdint.h>
#include <memory>

using namespace std;
const int32_t kBufferSize = 32;

bool Init2() {
	unique_ptr<char[]> buffer{new char[kBufferSize]};

	bool result = true;
	// code here

	if (!result) {
		return false;
	}

	unique_ptr<char[]> buffer2{new char[kBufferSize]};

	// code here

	if (!result) {
		return false;
	}

	return true;
}
~~~

C++ 11还提供了支持引用计数的智能指针shared_ptr, 但是鉴于智能指针病毒般的传播特性, 建议仅在自己可控制的局部使用, 不在API中出现.  

基本上, C++的内存管理虽然是纯手动管理+智能指针结合的较为原始方式, 但是思路还是比较清晰的, 即使牵涉到容器等更加复杂的情况, 其实还是遵循最基本的原则.  当然, 不要跟自动垃圾回收去比使用的方便.  
在C++ 11放弃了可选的垃圾回收后, 短期就不要期望C++有垃圾回收机制了, C++这么强烈的期望手动管理内存, 很大程度上是效率的考虑, 即使是现在我看到一些文章说, 好的垃圾回收器效率已经超过一般的手动内存管理了.  然而, 我没有看到任何文章敢说, 好的垃圾回收器, 效率上可以超过好的手动内存管理......

# Objective-C的内存管理

Objective-C(以下简称objc)其实已经有可选的垃圾回收功能了, 只不过在iOS上暂时还无法使用(应该是效率上的考虑), 不知道哪天iOS的SDK版本可以使用垃圾回收, 开发app就更简单了.
objc的内存管理自成一派, 将引用技术和内存池直接加入了语言特性.(这么说其实有待商榷, 因为引用计数等是NextStep库的特性, 但是鉴于使用objc就几乎肯定使用NextStep库, 所以这么说也可以接受) 

## 引用计数
### 简单情况
引用计数策略本身的思路很简单, 每有一个使用到内存块/资源的对象, 就对该内存块/资源的计数加一(retain), 每减少一个就减一(release), 当减到零的时候, 说明没有任何对象用到该内存块/资源, 就释放该内存块/资源.  
在实际的使用过程中, 还是有些很dirty的事情, 那就是需要特别注意使用但是不想增加引用计数(assign/weak)的情况.  当两种情况混合的时候, 有的时候会很烦人, 特别的, 当引用计数使用的越多, 出现内存泄漏后, 要查明是哪儿不适当的retain, 或者哪儿有漏掉release就越难.  
objc的简单情况下, 可以看成需要retain, release的配对.(类似new, delete的配对)  

~~~ objc
#import <Foundation/Foundation.h>

	@interface Obj : NSObject {
	}
- (id) init;
@end

@implementation Obj

- (id) init {
	self = [super init];
	if (self) {
		NSLog(@"%d", __LINE__);
		return self;
	}

	return nil;
}

- (void)dealloc {
	NSLog(@"%d", __LINE__);

	[super dealloc];
}

@end

void Test() {
	id test = [[Obj alloc] init];

	[test retain];
	[test release];

	[test release];
}

int main(int argc, const char * argv[])
{

	@autoreleasepool {

		Test();

	}
	return 0;
}
~~~

上面的这种代码其实并没有什么意义, 因为情况太简单了, 需要记住alloc出来的对象引用计数为1即可, retain的调用也太明显了. 但是当有objc容器的时候, 就需要留心了.  

## 容器对引用计数的影响
需要牢记的是objc的容器会隐式的retain对象, 并且接口都是类似AddXXX的形式.  此时光是去统计retain和release已经不管用了, 可以用所有权的思路去分析代码, 也就是把retain看成是宣示所有权, release看成是放弃所有权, 而容器一般都需要对对象拥有所有权.  
以常见的NSArray容器为例, 在addObject后, 马上release, 可以看成是对象在当前作用域放弃所有权, 将其移交到容器中, 此时唯一拥有对象的就是容器, 当容器本身释放时, 该所有权也会跟着释放.  见下例:  

~~~ objc
#import <Foundation/Foundation.h>

@interface Obj : NSObject {
}
- (id) init;
@end

@implementation Obj

- (id) init {
	self = [super init];
	if (self) {
		NSLog(@"%d: %s", __LINE__, __FUNCTION__);
		return self;
	}

	return nil;
}

- (void)dealloc {
	NSLog(@"%d: %s", __LINE__, __FUNCTION__);

	[super dealloc];
}

@end

void Test() {
	id test = [[Obj alloc] init]; // 1
	NSLog(@"%d: %s, retain_count:%d", __LINE__, __FUNCTION__, [test retainCount]);

	id array = [[NSMutableArray alloc] init];
	[array addObject:test];  // 2
	NSLog(@"%d: %s, retain_count:%d", __LINE__, __FUNCTION__, [test retainCount]);
	[test release]; // 1

	NSLog(@"%d: %s, retain_count:%d", __LINE__, __FUNCTION__, [test retainCount]);
	[array release];
}
~~~

输出:  
2013-04-08 01:40:27.580 test_objc_mem[4734:303] 21: -[Obj init]  
2013-04-08 01:40:27.582 test_objc_mem[4734:303] 38: Test, retain_count:1  
2013-04-08 01:40:27.583 test_objc_mem[4734:303] 42: Test, retain_count:2  
2013-04-08 01:40:27.583 test_objc_mem[4734:303] 45: Test, retain_count:1  
2013-04-08 01:40:27.583 test_objc_mem[4734:303] 29: -[Obj dealloc]  

42行代码输出的retain_count等于2, 就是因为array宣示了一次所有权.  


## 内存池
在objc中, 还常用autoreleasepool来解决前面提到的C/C++语言内存管理的问题.  大部分情况下, objc都不是用C语言那种外部分配内存, 内部使用的方式, 而是用autorelease统一的管理.  见下例:  

~~~ objc
#import <Foundation/Foundation.h>

@interface Obj : NSObject {
}
- (id) init;
@end

@implementation Obj

- (id) init {
	self = [super init];
	if (self) {
		NSLog(@"%d: %s", __LINE__, __FUNCTION__);
		return self;
	}

	return nil;
}

+ (id) create {
	NSLog(@"%d: %s", __LINE__, __FUNCTION__);

	return [[[Obj alloc] init] autorelease];
}

- (void)dealloc {
	NSLog(@"%d: %s", __LINE__, __FUNCTION__);

	[super dealloc];
}

@end


void Test() {
	@autoreleasepool {
		id test = [Obj create];
		NSLog(@"%d: %s, retain_count:%d", __LINE__, __FUNCTION__, [test retainCount]);

		id array = [[NSMutableArray alloc] init];
		[array addObject:test];
		NSLog(@"%d: %s, retain_count:%d", __LINE__, __FUNCTION__, [test retainCount]);

		[array release];
	}

	NSLog(@"%d: %s", __LINE__, __FUNCTION__);
}
~~~

注意与上例纯引用计数的区别, 这里的Obj由自己提供的类方法create提供, 创建后直接调用autorelease, 然后外部就没有如上例一样的release了, 虽然create出来的retain count还是等于1.  
这里可以把autorelease pool看成一个能宣示所有权的容器, 而autorelease函数就是一个简化的操作, 本质上就是将对象Add到这个容器中.  并且Objc提供了一些语法糖来简单的初始化和释放该容器.  仅此而已.  

## ARC(Automatic Reference Counting)
在新版的Objc语言中支持了一种叫做ARC的新特性, 可以在编译时期为程序员自动的匹配retain和release, 有类似自动内存管理的方便, 同时不影响内存使用的效率, 程序员本身也不会因为少些了release而导致内存泄漏, 相当强大.  
具体关于ARC的内容可以单独成文, 并且本文主要是想讲Cocos2d-x的, 而这暂时还和ARC无关, 这里就不多讲了, 可以参考这篇文章: http://longweekendmobile.com/2011/09/07/objc-automatic-reference-counting-in-xcode-explained/

# Cocos2d-x的内存管理
要是完全没有接触过Objc, 只是了解C++, 看到Cocos2d-x的内存管理设计, 会想说脏话的.  了解objc的话, 起码还能理解Cocos2d-x的开发者是尝试在C++中模拟Objc的内存管理方式.  不仅仅是说加引用计数而已, 因为真要在C++中加引用计数的方法有很多种, Cocos2d-x用的这种方法, 实在太不原生态了.  

## 简单情况
因为Cocos2d-x中牵涉到显示的情况最多, 我也就不拿CCArray这种东西做例子了, 看个CCSprite的例子吧, 用Cocos2d-x的XCode template生成的HelloWorld工程中, 删除原来的显示代码, 创建一个Sprite并显示的代码如下:  

~~~ cpp
// part code of applicationDidFinishLaunching in AppDelegate.cpp
// create a scene. it's an autorelease object
CCScene *scene = HelloWorld::scene();

CCSprite *helloworld = new CCSprite;
if (helloworld->initWithFile("HelloWorld.png")) {
	CCSize size = CCDirector::sharedDirector()->getWinSize();
	// position the sprite on the center of the screen
	helloworld->setPosition( ccp(size.width/2, size.height/2) );

	// add the sprite as a child to this layer
	scene->addChild(helloworld, 0);
	helloworld->release();
}
~~~

这里暂时不管HelloWorld::scene, 先关注CCSprite的创建和使用, 这里使用new创建了CCSprite, 然后使用scene的addChild函数, 添加的到了scene中, 并显示.  一段这样简单的代码, 但是背后的东西却很多, 比如, 为啥我在scene的addChild后, 调用了sprite的release函数呢?  
还是可以从引用计数的所有权上说起(这样比较好理解, 虽然你也可以死记哪些时候具体引用计数的次数是几).  当我们用new创建了一个Sprite时, 此时Sprite的引用计数为1, 并且所有权属于helloworld这个指针, 我们在把helloworld用scene的addChild函数添加到scene中后, helloworld的引用计数此时为2, 由helloworld指针和scene共享所有权, 此时, helloworld指针的作用其实已经完了, 我们接下来也不准备使用这个指针, 所有权留着就再也释放不了了, 所以我们用release方法特别释放掉helloworld指针此时的所有权, 这么调用以后, 最后helloworld这个Sprite所有权完全的属于scene.  
但是我们这么做有什么好处呢? 好处就是当scene不想要显示helloworld时, 直接removeChild helloworld就可以了, 此时没有对象再拥有helloworld这个sprite, 引用技术为零, 这个sprite会如期的释放掉, 不会导致内存泄漏.  
比如说下列代码:

~~~ cpp
// create a scene. it's an autorelease object
CCScene *scene = HelloWorld::scene();

//  CCSprite* sprite = CCSprite::create("HelloWorld.png");
CCSprite *helloworld = new CCSprite;
if (helloworld->initWithFile("HelloWorld.png")) {
	CCSize size = CCDirector::sharedDirector()->getWinSize();
	// position the sprite on the center of the screen
	helloworld->setPosition( ccp(size.width/2, size.height/2) );

	// add the sprite as a child to this layer
	scene->addChild(helloworld, 0);
	helloworld->release();

	scene->removeChild(helloworld);
}
~~~

上面的代码helloworld sprite能正常的析构和释放内存, 假如少了那句release的代码就不行.  

## 容器对引用计数的影响
这个部分是引用计数方法都会碰到的问题, 也就是引用计数到底在什么时候增加, 什么时候减少.  
在Cocos2d-x中, 我倒是较少会像在objc中手动的retain对象了, 主要的对象主要由CCNode和CCArray等容器管理.  在Cocos2d-x中, 以CC开头的, 模拟Objc接口的容器, 都是对引用计数有影响的, 而原生的C++容器, 对Cocos2d-x的对象的引用计数都没有影响, 这导致了人们使用方式上的割裂.  大部分用惯了C++的人, 估计都还是偏向使用C++的原生容器, 毕竟C++的原生容器及其配套算法算是C++目前为数不多的亮点了, 比objc原生的容器都要好用, 更别说Cocos2d-x在C++中模拟的那些objc容器了.  但是, 一旦走上这条路就需要非常小心, 要非常明确此时每个对象的所有权是谁.  
看下面的代码:  

~~~ cpp
vector<CCSprite*> sprites;
for (int i = 0; i < 3; ++i) {
	CCSprite *helloworld = new CCSprite;
	if (helloworld->initWithFile("HelloWorld.png")) {
		CCSize size = CCDirector::sharedDirector()->getWinSize();
		// position the sprite on the center of the screen
		helloworld->setPosition( ccp(size.width/2, size.height/2) );

		// add the sprite as a child to this layer
		scene->addChild(helloworld, 0);
		sprites.push_back(helloworld);
		helloworld->release();

		scene->removeChild(helloworld);
	}
}
~~~

因为C++的容器是对Cocos2d-x的引用计数没有影响的, 所以在上述代码运行后, 虽然vector中保存者sprite的指针, 但是其实都已经是野指针了, 所有的sprite实际已经析构调了.  这种情况相当危险.  把上述代码中的vector改成Cocos2d-x中的CCArray就可以解决上面的问题, 因为CCArray是对引用计数有影响的.  
见下面的代码:  

~~~ cpp
CCArray *sprites = CCArray::create();
for (int i = 0; i < 3; ++i) {
	CCSprite *helloworld = new CCSprite;
	if (helloworld->initWithFile("HelloWorld.png")) {
		CCSize size = CCDirector::sharedDirector()->getWinSize();
		// position the sprite on the center of the screen
		helloworld->setPosition( ccp(size.width/2, size.height/2) );

		// add the sprite as a child to this layer
		scene->addChild(helloworld, 0);
		sprites->addObject(helloworld);
		helloworld->release();

		scene->removeChild(helloworld);
	}
}
~~~

改动非常小, 仅仅是容器类型从C++原生容器换成了Cocos2d-x从Objc模拟过来的array, 但是这段代码执行后, sprites中的sprite都可以正常的使用, 并且没有问题.  可参考Cocos2d-x的源代码ccArray.cpp:  

~~~ cpp
/** Appends an object. Behavior undefined if array doesn't have enough capacity. */
void ccArrayAppendObject(ccArray *arr, CCObject* object)
{
	CCAssert(object != NULL, "Invalid parameter!");
	object->retain();
	arr->arr[arr->num] = object;
	arr->num++;
}
~~~

但是, 假如我就是想用C++原生容器, 不想用CCArray怎么办呢?  需要承担的风险就来了, 有的时候还行, 比如上例, 我只需要去掉`helloworld->release`那一行, 并且明白此时所有权已经是属于vector了, 在vector处理完毕后, 再release即可.  
而有的时候这就没有那么简单了.  特别是Cocos2d-x因为依赖引用计数, 不仅仅是addChild等容器添加会增加引用计数,  回调的设计(模拟objc中的delegate)也会对引用计数有影响的.  曾经有人在初学Cocos2d-x的时候, 问我Cocos2d-x有没有什么设计问题, 有没有啥坑, 我觉得这就是最大的一个.  
举个简单的例子, 我真心不喜欢引用计数, 所以全用C++的容器, 写了下面这样的代码:  (未编译测试, 纯示例使用)

~~~ cpp
class Enemy 
{
	public:
		Enemy() {}
		~Enemy() {}

};


class EnemyManager 
{
	public:
		EnemyManager() {}
		~EnemyManager() {}

		void RemoveEnemies() {
			for (auto it : enemies_) {
				delete *it;
			}
		}

	private:
		vector<Enemy*> enemies_;
};
~~~


刚开始的时候, 这只是一段和Cocos2d-x完全没有关系的代码, 并且运行良好, 有一天, 我感觉的Enmey其实是个Sprite就方便操作了. 将Enemy改为继承自Sprite, 那么这段代码就没有那么安全了, 因为EnemyManager在完全不知道enemy的引用计数的情况下, 使用delete删除了enmey, 假如此时还有其他地方对该enemy有引用, 就会crash.  虽然表面上看来是想添加一些CCSprite的显示功能, 但是实际上, 一入此门(从CCObject继承过来), 引用计数就已经无处不在, 此时需要把直接的delete改为调用release函数.  

## 内存池
Cocos2d-x起始也模拟了objc中的内存池, 但是因为不可能改变语言本身的特性, 那种简单的语法糖语法就没有, 需要的时候, 老实的操作CCPoolManager和CCAutoreleasePool吧.  在通常情况下, Cocos2d-x增加的机制使得我们不太需要像在objc中那样使用内存池.  我来解释一下:  
在Cocos2d-x中, 几乎所有有意义的类都有create函数, 比如Sprite的create函数:  

~~~ cpp
CCSprite* CCSprite::create()
{
	CCSprite *pSprite = new CCSprite();
	if (pSprite && pSprite->init())
	{
		pSprite->autorelease();
		return pSprite;
	}
	CC_SAFE_DELETE(pSprite);
	return NULL;
}
~~~

基本只干两个事情, 一个是new和init, 一个就是调用autorelease函数讲sprite本身加入内存池了.  此时讲sprite加入内存池后, sprite的所有权已经属于内存池了, 我们返回的指针其实是没有所有权的.  在create出一个类似对象后, 我们接下来的操作往往是吧这个对象再添加到parent node中(比如上层的scene或layer), 此时由内存池和这个parent node共同拥有这个sprite, 当sprite不需要再显示的时候, 直接通过removeChild将sprite从父节点中移除后, 就回到仅属于内存池的情况了.  
在objc中, 要是都是上面的情况, 我们又不手动的清理内存池, 这其实就已经有内存泄漏了, 但是Cocos2d-x实际是每帧都帮我们清理内存池的. 也就是说, 每一帧仅仅属于内存池的对象都会被释放.  见下面的代码:  

~~~ cpp
void CCDisplayLinkDirector::mainLoop(void)
{
	if (m_bPurgeDirecotorInNextLoop)
	{
		m_bPurgeDirecotorInNextLoop = false;
		purgeDirector();
	}
	else if (! m_bInvalid)
	{
		drawScene();

		// release the objects
		CCPoolManager::sharedPoolManager()->pop();        
	}
}
~~~

上面的代码是CCDirector的游戏主循环代码, 主循环干了件非常重要的事情, 那就是pop最上层的autorelease pool, 此时是在release全部仅仅由此内存池所有的对象.  就是依靠这样的原理, 我们可以放心的将对象放在autorelease pool中, 知道在需要的时候, 这个对象就能正确的释放, 同时只要有上层的父节点通过addChild对游戏对象有了所有权以后, 又能正确的保证该对象不会被删除.  

# 小结
本文原来是来自于给公司做的内部培训材料, 因为一开始写的很初略和简单, 一直就没想发布, 最近我在整理老的资料, 所以今天整理了一下, 添加了一些例子, 发布出来了, 可以明显的看到后面的内容虽然更加重要, 但是写的比前面要仓促, 有错误的话, 请各位不吝赐教.  
