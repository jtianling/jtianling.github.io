---
layout: post
title: UCS-2与UTF8之间的选择（3）--windows中各编码字符串的C/C++输出支持及方式比较
categories:
- "网络技术"
tags:
- C++
- UCS-2
- UTF-8
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

# UCS-2与UTF8之间的选择（3）\--windows与linux中各编码字符串的C/C++输出支持及方式比较

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

继续研究UTF8和UCS-2的选择，这里继续使用上一次提到的函数。

鉴于大家不一定能找到下载的地址，而源文件是允许自由散发的，我将代码打包，提供给大家下载，下载地址还是在[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>) 中，名字为unicodeorg.rar，

 

另外，在wiki上看到了一个对UTF8的评价：

## 优点及缺点

关于字符串长度的一个注解：

总体来说，在Unicode字符串中不可能由码点数量决定显示它所需要的长度，或者显示字符串之后在文本缓冲区中光标应该放置的位置；组合字符、变宽字体、不可打印字符和从右至左的文字都是其归因。

所以尽管在UTF-8字符串中字元数量与码点数量的关系比UTF-32更为复杂，在实际中很少会遇到有不同的情形。

  * **总体**
    * **优点**
      * UTF-8是ASCII的一个[超集](<http://zh.wikipedia.org/w/index.php?title=%E8%B6%85%E9%9B%86&variant=zh-hans> "超集")。因为一个纯ASCII字符串也是一个合法的UTF-8字符串，所以现存的ASCII文本不需要转换。为传统的扩展ASCII字符集设计的软件通常可以不经修改或很少修改就能与UTF-8一起使用。
      * 使用标准的面向字节的排序例程对UTF-8排序将产生与基于Unicode代码点排序相同的结果。（尽管这只有有限的有用性，因为在任何特定语言或文化下都不太可能有仍可接受的文字排列顺序。）
      * UTF-8和UTF-16都是[可扩展标记语言](<http://zh.wikipedia.org/w/index.php?title=%E5%8F%AF%E6%89%A9%E5%B1%95%E6%A0%87%E8%AE%B0%E8%AF%AD%E8%A8%80&variant=zh-hans> "可扩展标记语言")文档的标准编码。所有其它编码都必须通过显式或文本声明来指定。[[2]](<http://www.w3.org/TR/REC-xml/#charencoding> "http://www.w3.org/TR/REC-xml/#charencoding")
      * 任何[面向字节](<http://zh.wikipedia.org/w/index.php?title=%E9%9D%A2%E5%90%91%E5%AD%97%E8%8A%82&action=edit&redlink=1> "面向字节 \(页面未存在\)")的[字符串搜索算法](<http://zh.wikipedia.org/w/index.php?title=%E5%AD%97%E7%AC%A6%E4%B8%B2%E6%90%9C%E7%B4%A2%E7%AE%97%E6%B3%95&action=edit&redlink=1> "字符串搜索算法 \(页面未存在\)")都可以用于UTF-8的数据（只要输入仅由完整的UTF-8字符组成）。但是，对于包含字符记数的正则表达式或其它结构必须小心。
      * UTF-8字符串可以由一个简单的算法可靠地识别出来。就是，一个字符串在任何其它编码中表现为合法的UTF-8的可能性很低，并随字符串长度增 长而减小。举例说，字元值C0,C1,F5至FF从来没有出现。为了更好的可靠性，可以使用正则表达式来统计非法过长和替代值（可以查看[W3 FAQ: Multilingual Forms](<http://www.w3.org/International/questions/qa-forms-utf-8> "http://www.w3.org/International/questions/qa-forms-utf-8")上的验证UTF-8字符串的正则表达式）。
    * **缺点**
      * 一份写得很差（并且与当前标准的版本不兼容）的UTF-8[解析器](<http://zh.wikipedia.org/w/index.php?title=%E8%A7%A3%E6%9E%90%E5%99%A8&variant=zh-hans> "解析器")可能会接受一些不同的伪UTF-8表示并将它们转换到相同的Unicode输出上。这为设计用于处理八位表示的校验例程提供了一种遗漏信息的方式。

\--《[UTF-8](<http://zh.wikipedia.org/w/index.php?title=UTF-8&variant=zh-hans>)》

 

其中还有：

## UTF-8编码的缺点

### 不利于正则表达式检索

[正则表达式](<http://zh.wikipedia.org/w/index.php?title=%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F&variant=zh-hans> "正则表达式")可以进行很多英文高级的模糊检索。例如，[a-h]表示a到h间所有字母。

同样GBK编码的中文也可以这样利用[正则表达式](<http://zh.wikipedia.org/w/index.php?title=%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F&variant=zh-hans> "正则表达式")，比如在只知道一个字的读音而不知道怎么写的情况下，也可用[正则表达式](<http://zh.wikipedia.org/w/index.php?title=%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F&variant=zh-hans> "正则表达式")检索，因为GBK编码是按读音排序的。只是UTF-8不是按读音排序的，所以会对正则表达式检索造成不利影响。但是这种使用方式并未考虑中文中的破音字，因此影响不大。Unicode是按部首排序的，因此在只知道一个字的部首而不知道如何发音的情况下，UTF-8 可用[正则表达式](<http://zh.wikipedia.org/w/index.php?title=%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F&variant=zh-hans> "正则表达式")检索而GBK不行。

### 其他

与其他 Unicode 编码相比，特别是UTF-16，在 UTF-8 中 ASCII 字元占用的空间只有一半，可是在一些字元的 UTF-8 编码占用的空间就要多出，特别是中文、日文和韩文（[CJK](<http://zh.wikipedia.org/w/index.php?title=CJK&variant=zh-hans> "CJK")）这样的象形文字，所以具体因素因文档而异，但不论哪种情况，差别都不可能很明显。

 

呵呵，自从可以访问WiKi以后，基本成了一些名字解释等信息的重要来源了。。。。希望以后可以一直访问到。（个人想法）

 

另外，对于服务器来讲，调试信息的主要出口在两个地方，一个是记录日志文件，一个就是控制台输出了，按我们总监的话来说@#￥@#……￥#算了，不说了，反正总监的大意就是服务器就是看着一屏屏的文字，没有写客户端代码那样有成就感，能够即时的显示出来，但是，别小看这些文字，很多bug调试的时候不一定能出来，偶尔出现一次，基本得靠日志分析，而控制台的输出主要目的可能就是即时的对服务器运行状况有所了解（其实真正后期运行个人感觉并不是太主要），主要的还是以文件形式记录的日志，而且控制台的输出对于效率的影响过大。（其实所有的I/O操作都是相对来说很耗时间的）

       正在世界地图服务器，这里讲一个插曲，我们公司的服务器日志目前全部是英文................呵呵，原因是Linux下的中文输出有问题-_-!当然有问题，公司为了保证游戏客户端的效率，所有的字符处理全部是以UCS-2编码的两字节wchar_t来表示，不经过任何转换能显示出来才怪了-_-!。。。。。

 

首先是控制台的输出，Windows下：

一般来说，用VS2005中用wchar_t来表示UTF16中文就比较合适了，因为目前VS2005中wchar_t默认就是两字节的，下面是演示过程的源代码：

```cpp
// Unicode.cpp : 定义控制台应用程序的入口点。
//

#include <stdio.h>
#include <tchar.h>
#include <windows.h>
#include <locale.h>
#include "ConvertUTF.h"

int _tmain(int argc, _TCHAR* argv[])
{
    setlocale(LC_ALL, "");
    wprintf(L"windows控制台在C语言中输出UCS-2宽字节中文\-----begin-----/n");
    ConversionResult result = sourceIllegal;
    wchar_t lwcBuf[3] = L"中文";
    UTF16 utf16_buf[3] = {0};
    utf16_buf[0] = 0x4e2d;
    utf16_buf[1] = 0x6587;
    utf16_buf[2] = 0;
    UTF16 *utf16Start = utf16_buf;
    UTF8 utf8_buf[12] = {0};
    UTF8* utf8Start = utf8_buf;

    wprintf(L"%s/n", (wchar_t*)utf16_buf);
    wprintf(L"%s/n", lwcBuf);

    result = ConvertUTF16toUTF8((const UTF16 **) &utf16Start, &(utf16_buf[3]), &utf8Start, &(utf8_buf[12]), strictConversion);
    switch (result) {
       default: fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);
       case conversionOK: break;
       case sourceExhausted: printf("sourceExhausted/t"); exit(0);
       case targetExhausted: printf("targetExhausted/t"); exit(0);
       case sourceIllegal: printf("sourceIllegal/t"); exit(0);
    }

    printf("is leagal UTF8: %d/n", isLegalUTF8Sequence(utf8_buf, utf8Start));
    printf("%s/n", (char*)utf8_buf);

    // 清空缓存，以确定以后的值的确是转换得来
    ZeroMemory(utf16_buf, sizeof(utf16_buf));

    // 由于转换中利用了这两个start，所以需要重新为start定位,并且保存住End值
    UTF8* utf8End = utf8Start;
    utf8Start = utf8_buf;
    utf16Start = utf16_buf;

    result = ConvertUTF8toUTF16((const UTF8 **) &utf8Start, utf8End, &utf16Start, &(utf16_buf[3]), strictConversion);
    switch (result) {
       default: fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);
       case conversionOK: break;
       case sourceExhausted: printf("sourceExhausted/t"); exit(0);
       case targetExhausted: printf("targetExhausted/t"); exit(0);
       case sourceIllegal: printf("sourceIllegal/t"); exit(0);
    }

    wprintf(L"%s/n", (wchar_t*)utf16_buf);
    wprintf(L"windows控制台在C语言中输出UCS-2宽字节中文\-----end-----/n");

    return 0;
}
```

运行结果：

```text
windows控制台在C语言中输出UCS-2宽字节中文\-----begin-----
中文
中文
is leagal UTF8: 1
涓枃
中文
windows控制台在C语言中输出UCS-2宽字节中文\-----end-----
```

还是利用了上一篇提到的函数，需要注意的是在C语言中不使用setlocale函数是没有办法正确输出utf16中文的，（因为默认可能是使用了windows以前的codepage那一套系统）设置后一切非常正常。无论是用short标志的中文，或者是直接输入的中文，控制台都能正确输出，但是utf8显然没有得到MS的支持，一样的，在VS2005中，UTF8字符不能正常的通过鼠标停留显示出来。。。。

以上是C语言的方案，C++的输出方式如下：（从原来的代码改过来的，有点乱，但是仅仅作为测试，没有考虑那么多了）

```cpp
#include <stdio.h>
#include <tchar.h>
#include <windows.h>
#include <locale.h>
#include <iostream>
#include "ConvertUTF.h"
using namespace std;

void TestInCPP()
{
    // 未为wcout流设置locale前的效果,cout能够输出中文是因为Windows以前的多字节技术
    cout <<"未为wcout流设置locale前的效果: /"";
    wcout <<L"中文";
    cout <<"/"" <<endl;

    // 可以看到什么效果都没有，还会将wcout设置错误标志位，不清楚此标志位将什么输出都没有
    wcout.clear();

    wcout.imbue(locale(""));
    wcout <<L"windows控制台在C++语言中输出UCS-2宽字节中文\-----begin-----/n" <<endl;
    ConversionResult result = sourceIllegal;
    wchar_t lwcBuf[3] = L"中文";
    UTF16 utf16_buf[3] = {0};
    utf16_buf[0] = 0x4e2d;
    utf16_buf[1] = 0x6587;
    utf16_buf[2] = 0;
    UTF16 *utf16Start = utf16_buf;
    UTF8 utf8_buf[12] = {0};
    UTF8* utf8Start = utf8_buf;

    wcout<<L"utf16_buf:" <<(wchar_t*)utf16_buf <<L" lwcBuf:" <<lwcBuf <<endl;

    result = ConvertUTF16toUTF8((const UTF16 **) &utf16Start, &(utf16_buf[3]), &utf8Start, &(utf8_buf[12]), strictConversion);
    switch (result) {
       default: fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);
       case conversionOK: break;
       case sourceExhausted: printf("sourceExhausted/t"); exit(0);
       case targetExhausted: printf("targetExhausted/t"); exit(0);
       case sourceIllegal: printf("sourceIllegal/t"); exit(0);
    }

    wcout <<L"Is leagal UTF8:" <<isLegalUTF8Sequence(utf8_buf, utf8Start) <<endl;
    cout.imbue(locale(""));
    cout <<(char*)utf8_buf <<endl;

    // 清空缓存，以确定以后的值的确是转换得来
    ZeroMemory(utf16_buf, sizeof(utf16_buf));

    // 由于转换中利用了这两个start，所以需要重新为start定位,并且保存住End值
    UTF8* utf8End = utf8Start;
    utf8Start = utf8_buf;
    utf16Start = utf16_buf;

    result = ConvertUTF8toUTF16((const UTF8 **) &utf8Start, utf8End, &utf16Start, &(utf16_buf[3]), strictConversion);
    switch (result) {
       default: fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);
       case conversionOK: break;
       case sourceExhausted: printf("sourceExhausted/t"); exit(0);
       case targetExhausted: printf("targetExhausted/t"); exit(0);
       case sourceIllegal: printf("sourceIllegal/t"); exit(0);
    }

    wcout<<L"utf16_buf:" <<(wchar_t*)utf16_buf <<endl;

    wcout <<L"windows控制台在C++语言中输出UCS-2宽字节中文\-----end-----/n" <<endl;
}

int _tmain(int argc, _TCHAR* argv[])
{

    TestInCPP();

    return 0;
}
```

可以看到，C++的使用方法更加有效一些，因为仅仅影响到某个特定的输出流，而不是对所有的东西都一次性更改，这点与C++中面向对象的思想相符合，C语言那种方式太霸道了一点(符合C语言全局设定的风格)。但是作为操作系统的特性，C++也没有办法超越，去将UTF-8编码的字符串输出。

所以，最后的结论是，要在windows的控制台输出UTF-8编码的字符串似乎唯一的办法就是先转换成UCS-2然后再输出了。-_-!

这里要提及的就是同时使用两种机制会有冲突，记得当时看到有文章说，C与C++的这两种机制最好不要混用-_-!

  

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)