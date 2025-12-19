---
layout: post
title: UCS-2与UTF8之间的选择（4）--linux中各编码字符串的C/C++输出支持及方式比较
categories:
- "网络技术"
tags:
- C++
- Linux
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文通过代码示例说明，在Linux下C/C++可直接输出UTF-8字符串，无需特殊设置，使用非常方便。

<!-- more -->

# UCS-2与UTF8之间的选择（4）--linux中各编码字符串的C/C++输出支持及方式比较

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****


继续研究UTF8和UCS-2的选择，这里继续使用上一次提到的函数。

鉴于大家不一定能找到下载的地址，而源文件是允许自由散发的，我将代码打包，提供给大家下载，下载地址还是在[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>) 中，名字为unicodeorg.rar，

昨天看了下Windows下的方法，这次研究Linux下的：

```c
 1 #include <stdio.h>  
 2 #include <locale.h>  
 3 #include <stdlib.h>  
 4 #include "ConvertUTF.h"  
 5   
 6 **int**  main(**int**  argc, **char** * argv[])  
 7 {  
 8   
 9     ConversionResult result = sourceIllegal;  
10     UTF16 utf16_buf[3] = {0};  
11     utf16_buf[0] = 0x4e2d;  
12     utf16_buf[1] = 0x6587;  
13     utf16_buf[2] = 0;  
14     UTF16 *utf16Start = utf16_buf;  
15     UTF8 utf8_buf[12] = {0};  
16     UTF8* utf8Start = utf8_buf;  
17   
18     // If you want to test next line, you can't get anything but ???  
19     // wprintf("%s/n", utf16_buf);  
20   
21     result = ConvertUTF16toUTF8((**const**  UTF16 **) &utf16Start, &(utf16_buf[3]), &utf8Start, &(utf8_buf[12]), strictConversion);  
22     **switch**  (result) {  
23         **default** : fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);  
24         **case**  conversionOK: **break** ;  
25         **case**  sourceExhausted: printf("sourceExhausted/t"); exit(0);  
26         **case**  targetExhausted: printf("targetExhausted/t"); exit(0);  
27         **case**  sourceIllegal: printf("sourceIllegal/t"); exit(0);  
28     }  
29   
30     **int**  i = 0;  
31     **for**(; i < 12; ++i)  
32     {  
33         printf("%x ", utf8_buf[i]);  
34     }  
35      
36     printf("/n");  
37   
38     printf("%s/n", (**char** *)utf8_buf);  
39     bzero(utf16_buf, **sizeof**(utf16_buf));  
40   
41     UTF8* utf8End = utf8Start;  
42     utf8Start = utf8_buf;  
43     utf16Start = utf16_buf;  
44   
45     result = ConvertUTF8toUTF16((**const**  UTF8 **) &utf8Start, utf8End, &utf16Start, &(utf16_buf[3]), strictConversion);  
46     **switch**  (result) {  
47         **default** : fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);  
48         **case**  conversionOK: **break** ;  
49         **case**  sourceExhausted: printf("sourceExhausted/t"); exit(0);  
50         **case**  targetExhausted: printf("targetExhausted/t"); exit(0);  
51         **case**  sourceIllegal: printf("sourceIllegal/t"); exit(0);  
52     }  
53   
54     // If you want to test next line, you can't get anything  
55     wprintf("%s/n", utf16_buf);  
56   
57     **return**  0;  
58 }  
59
```

运行结果：

e4 b8 ad e6 96 87 0 0 0 0 0 0

中文

这里和Windows中不同的就是输出UTF-8的字符串在Linux下甚至不需要通过setlocale设置环境变量，这样对于C++的输出估计还是有好处的：），起码不会去影响到C++的正常输出。但是，对于宽字节的输出没有办法成功，就算你像在Windows中设置locale也没有用，道理也很简单，因为Linux下的locale我就是设置成UTF-8的-_-!

```cpp
 1 #include <stdio.h>  
 2 #include <locale.h>  
 3 #include <stdlib.h>  
 4 #include <iostream>  
 5 #include "ConvertUTF.h"  
 6 **using**  **namespace**  std;  
 7   
 8 **int**  main(**int**  argc, **char** * argv[])  
 9 {  
10     ConversionResult result = sourceIllegal;  
11     UTF16 utf16_buf[3] = {0};  
12     utf16_buf[0] = 0x4e2d;  
13     utf16_buf[1] = 0x6587;  
14     utf16_buf[2] = 0;  
15     UTF16 *utf16Start = utf16_buf;  
16     UTF8 utf8_buf[12] = {0};  
17     UTF8* utf8Start = utf8_buf;  
18   
19     result = ConvertUTF16toUTF8((**const**  UTF16 **) &utf16Start, &(utf16_buf[3]), &utf8Start, &(utf8_buf[12]), strictConversion);  
20     **switch**  (result) {  
21         **default** : fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);  
22         **case**  conversionOK: **break** ;  
23         **case**  sourceExhausted: printf("sourceExhausted/t"); exit(0);  
24         **case**  targetExhausted: printf("targetExhausted/t"); exit(0);  
25         **case**  sourceIllegal: printf("sourceIllegal/t"); exit(0);  
26     }  
27   
28     **int**  i = 0;  
29     **for**(; i < 12; ++i)  
30     {  
31         printf("%x ", utf8_buf[i]);  
32     }  
33      
34     printf("/n");  
35   
36     cout << (**char** *)utf8_buf <<endl;  
37     bzero(utf16_buf, **sizeof**(utf16_buf));  
38   
39     UTF8* utf8End = utf8Start;  
40     utf8Start = utf8_buf;  
41     utf16Start = utf16_buf;  
42   
43     result = ConvertUTF8toUTF16((**const**  UTF8 **) &utf8Start, utf8End, &utf16Start, &(utf16_buf[3]), strictConversion);  
44     **switch**  (result) {  
45         **default** : fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);  
46         **case**  conversionOK: **break** ;  
47         **case**  sourceExhausted: printf("sourceExhausted/t"); exit(0);  
48         **case**  targetExhausted: printf("targetExhausted/t"); exit(0);  
49         **case**  sourceIllegal: printf("sourceIllegal/t"); exit(0);  
50     }  
51   
52     **return**  0;  
53 }  
54
```

直接可以获得

e4 b8 ad e6 96 87 0 0 0 0 0 0

中文

的输出，也不需要调用C++的locale(imbue)函数去改变流的状态，甚至可以说，使用了UTF-8不仅仅是对ASCII完全的兼容了，对于新添加的字符也是可以不改变任何代码就做到兼容的，这点给我印象深刻。难怪UTF-8虽然是变长的编码方式，但是还是获得了这么广范围的应用。

这样的情况下，在Linux下同时在C 和 C++中使用UTF-8输出中文也不会有任何冲突，这个优势比在Windows下大多了。

另外，有个很重要的问题需要提及的就是，目前我使用的Ubuntu8.04桌面版，不支持全Unicode的编码，似乎中文是没有什么问题，但是以前那几个太玄经的字符是输出不了的，可能其Unicode的支持只到到BMP这一层，这点比Windows稍逊色。以前测试过，的确是输出不了，但是源代码已经被覆盖了，大家可以自己去确定一下：）

