---
layout: post
title: Python与C之间的相互调用（Python C API及Python ctypes库）
categories:
- Python
tags:
- C++
- ctypes
- Python
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '37'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍Python调用C代码的两种方法：一是使用Python C API进行复杂扩展，二是用ctypes库纯Python方式简单调用。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**

[**讨论新闻组及文件**](http://groups.google.com/group/jiutianfile/)

我实现["onekeycodehighlighter"](http://code.google.com/p/onekeycodehighlighter/)中碰到的一些小问题，需要实现全局快捷键，但是是事实上Qt并没有对全局快捷键提供支持，那么用Qt的话就只能通过Win32Api来完成了，而我，用的是PyQt，还需要用Python来调用win32 API，事实上，都没有什么难的。

因为Python如此的流行，导致，开源社区按照自己的爱好，对于Python与C之间互相调用上，各自开发了自己想要的调用方式，其中包括用Python C API来完成，包括ctypes这个Python标准库，还有那一大堆的各式各样的绑定方案如SIP,Boost::Python等，要知道，Python流行到什么程序，Boost库号称C++准标准库，唯一对C++以外的一种语言提供了支持，那就是Python，Python还是Symbian除C++,JAVA外支持的第3种语言，当年在原来的公司，我还一直以为Python是个新鲜的小玩意儿，要我鼓捣Python C API的时候很新鲜，（事实上原公司的确没有用Python的人）到了新公司一看，啊~~~公司只允许使用3中语言，C++,JAVA，还有Python，而大家对Python那都是驾轻就熟，信手拈来，常用来开发一些工具及脚本，呵呵，世界原来与我想象的并不同。这里将以前工作中用到的Python C API知识，及最近用到的ctypes库的知识梳理一下。

## Python C API

此部分可以参考我原来的文章《[python c api 使用心得...](http://www.jtianling.com/archive/2009/01/15/3779247.aspx)》，这里只是会有一些实际的例子，原来那是一个大概流程的描述。某年某月，在我开始学习Python古老的岁月中（我不是倚老卖老啊）。。。。ctypes还不存在，那时候我们都是老实的用C语言，调用Python C API来完成从Python中调用C语言函数的任务，我学习Python的时候还在想，哈哈哈哈哈，我以前学过C/C++，我可以很熟练的调用 Python C API来完成Python调用Win32 API这样的任务，我多了不起啊：）这个时候的感觉就像，嘿，Python你不是了不起吗。。。。还不是没有办法逃离C语言的魔掌。。。。此时，画面中出现的是K&R嘿嘿嘿嘿的冷笑。。。。Guido van Rossum在他们脚下抱着头哭了。。。。。。。那时候，情况大概是这样的：

![](http://docs.google.com/File?id=dhn3dw87_45fgqfb7dm_b)

### 准备工作：

闲话少说，看看Python C API。事实上，Python C API比起Lua的API了来说，清晰了很多，这也符合Pythonic的风格，就算这时Python C API是设计给C语言使用者使用的，还是这样的风格，比起Lua API那种汇编式的接口，（据说为了效率，可以直接操作每个数据）强了太多了。要使用Python C API，用普通的二进制包是不行的，得下源码包。这里我用3.1.1的源码包为例：[Source Distribution](http://www.python.org/ftp/python/3.1.1/Python-3.1.1.tar.bz2 "Grab the Source for the Python 3.1 Release")

Python的源码在Windows的版本中已经完全换到VS2008了，直接用VS2008打开在PCbuild目录下的工程即可，对于VS2005及以前的用户打开PC目录下的其他版本工程。我们编译debug版本的pythoncore会得到python31_d.lib,python31_d.dll两个文件，需要的头文件在Include目录下，还需要将pyconfig.h文件从PCBuild目录下拷贝到Include中，（硬要直接指定也可以）这样准备工作就已经齐了。

Python C API有两个方向的使用方式，从C中调用Python脚本及利用C扩展Python。先讲简单的从C中调用Python，也就是常说的在C中内嵌Python。

### C中内嵌Python

新建立一个工程，首先需要将工作目录设置到Python-3.1.1PCbuild中，以获取到动态库，至于静态库的包含，Include目录的指定，那自然也是少不了的。文件中需要包含Python.h文件，这也是必须的。接口中 Py_Initialize(); Py_Finalize(); 一对的调用是必须的，一个用于初始化Python的动态库，一个用于释放。释放时会输出[31818 refs]，意义不明。

PyRun_SimpleString可用于执行简单的Python语句。如下：

```c
#include "Python.h"

int main(int argc, char *argv[])
{
    Py_Initialize();

    PyRun_SimpleString("print(\n"
                       "Hello World\n"
                       ")"
    );
    Py_Finalize();

    system("PAUSE");
    return 0;
}
```

此时，输出为：

Hello World
[31829 refs]
请按任意键继续. . .

此时可以执行一些Python语句了，并且，特别需要注意的是，在一个Py_Initialize();与Py_Finalize();之间，Python语句执行是在同一个执行环境中，不懂什么意思？看个示例就知道了。

```c
int main(int argc, char *argv[])
{
    Py_Initialize();

    PyRun_SimpleString("str = \n"
                       "Hello World\n"
                       ""
    );
    PyRun_SimpleString("print(str)");

    Py_Finalize();

    system("PAUSE");
    return 0;
}
```

此例与上例输出是一样的，懂我的意思了吧？意思就是以前执行的语句对后面的语句是有效的，相当于在同一个交互式命令行中顺序执行语句。

### 获取返回值

PyRun_SimpleString有的缺点，文档中的描述是：

Returns 0 on success or -1 if an exception was raised.

那么你就无法在Python及C语言中传递任何信息。我们需要高级点的函数才行。

PyObject* PyRun_String(const char *str, int start, PyObject *globals, PyObject *locals)就是干这个的。但是需要注意的是此函数的一些参数的获取，按照想当然的给他们置空可是不行的，如下例所示：

```c
#include "Python.h"

int main(int argc, char *argv[])
{
    Py_Initialize();

    PyRun_SimpleString("x = 10");
    PyRun_SimpleString("y = 20");
    PyObject* mainModule = PyImport_ImportModule("__main__");
    PyObject* dict = PyModule_GetDict(mainModule);
    PyObject* resultObject = PyRun_String("x + y", Py_eval_input, dict, dict);

    if (resultObject)
    {
        long result = PyLong_AsLong(resultObject);
        printf("%d", result);
        Py_DECREF(resultObject);
    }

    Py_Finalize();

    system("PAUSE");
    return 0;
}
```

这里我利用了一个知识，那就是PyRun_SimpleString实际是将所有的代码都放在__main__模块中运行，注意啊，没有导入正确的模块及其dict，你会运行失败，失败的很惨。至此，C语言已经于Python来了个交互了。呵呵，突然觉得深入下去就没有尽头了。。。。。。。还是点到为止吧。稍微深入点的可以去看《Programming Python》一书。在[啄木鸟](http://wiki.woodpecker.org.cn/moin/PP3eD#Chapter_23._Embedding_Python_.2UYVdTA-Python "啄木鸟")上有此书及一些译文。Part VI: Integration 部分Chapter 23. Embedding Python，有相关的知识。

### 利用C扩展Python

此部分在《Programming Python》的Chapter 22. Extending Python 部分有介绍。这里也只能开个头了，最多告诉你，其实，这些都没有什么难的。稍微复杂点的情况《[python c api 使用心得...](http://www.jtianling.com/archive/2009/01/15/3779247.aspx)》一文中有介绍。配置上与前面讲的类似，一般来说，利用C扩展Python最后会生成一个动态库，不过这个动态库的后缀会设为.pyd，只有这样，import的时候才会自动的查询到。另外，为Python写扩展要遵循Python的那套规则，固定的几个命名。首先看自带的例子：

```c
#include "Python.h"

static PyObject *
ex_foo(PyObject *self, PyObject *args)
{
    printf("Hello, world\n");
    Py_INCREF(Py_None);
    return Py_None;
}

static PyMethodDef example_methods[] = {
    {"foo", ex_foo, METH_VARARGS, "foo() doc string"},
    {NULL, NULL}
};

static struct PyModuleDef examplemodule = {
    PyModuleDef_HEAD_INIT,
    "example",
    "example module doc string",
    -1,
    example_methods,
    NULL,
    NULL,
    NULL,
    NULL
};

PyMODINIT_FUNC
PyInit_example(void)
{
    return PyModule_Create(&examplemodule);
}
```

这个例子包含了全部C语言为Python写扩展时的基本信息：1.PyInit_example是最后的出口，其中需要注意的是example不仅仅代表example的意思，还代表了最后生成的库会用example命名，也就是你调用此库会需要使用import example的形式。2.static struct PyModuleDef examplemodule的存在也是必须的，指定了整个模块的信息，比如上面的"example module doc string"， 模块的说明文字。每个参数的含义上面已经有些演示了。全部内容可以参考文档中关于PyModuleDef的说明 3.example_methods是一个函数列表，事实上表示此模块中含有的函数。此例中仅含有foo一个函数。

```c
static PyObject * ex_foo(PyObject *self, PyObject *args)
{
    printf("Hello, world\n");
    Py_INCREF(Py_None);
    return Py_None;
}
```

就是整个函数的具体实现了，此函数表示输出"Hello, world"，还是hello world。。。。。。。。这个world还真忙啊。。。。天天有人say hello。

这个Python本身附带的例子有点太简单了，我给出一个稍微复杂点的例子，还是我最喜欢的MessageBox,最后的效果自然还是Hello world。。。。。。。。。。。

```c
#include "Python.h"

static PyObject *
MessageBox(PyObject *self, PyObject *args)
{
    LPCSTR lpText;
    LPCSTR lpCaption;
    UINT uType;

    PyArg_ParseTuple(args, "ssi", &lpText, &lpCaption, &uType);

    int result = MessageBoxA(0, lpText, lpCaption, uType);

    PyObject* resultObject = Py_BuildValue("%i", result);

    return resultObject;
}

static PyMethodDef c_methods[] = {
    {"MessageBox", MessageBox, METH_VARARGS, "MessageBox() "},
    {NULL, NULL}
};

static struct PyModuleDef win32module = {
    PyModuleDef_HEAD_INIT,
    "Win32API",
    "Win32 API MessageBox",
    -1,
    c_methods,
    NULL,
    NULL,
    NULL,
    NULL
};

PyMODINIT_FUNC
PyInit_Win32API(void)
{
    return PyModule_Create(&win32module);
}
```

需要注意的还是需要注意，唯一有点区别的是这里我有从Python中传进来的参数及从C中传出去的返回值了。PyArg_ParseTuple用于解析参数 Py_BuildValue 用于构建一个Python的值返回 他们的构建和解析形式有点类似于sprintf等C常见的形式，可是每个字符代表的东西不一定一样，需要注意，文档中比较详细，此例中展示的是String及int的转换。

以生成动态库的方式编译此文件后，并指定为Win32API.pyd文件，然后将其拷贝到Python_d所在的目录（用Python3.1.1源代码生成的调试版本Python），此时import会首先查找*_d.pyd形式的动态库，不然只会搜索release版。首先看看库的信息：

```python
>>> import Win32API
[44692 refs]
>>> dir(Win32API)
['MessageBox', '__doc__', '__file__', '__name__', '__package__']
[44705 refs]
>>> help(Win32API)
Help on module Win32API:

NAME
    Win32API - Win32 API MessageBox

FILE
    d:python-3.1.1pcbuildwin32api_d.pyd

FUNCTIONS
    MessageBox(...)
        MessageBox()

[68311 refs]
```

注意到文档的作用了吧？还注意到dir的强大。。。。。。。。。。。。。此时MessageBox已经在Win32API中了，直接调用吧。我这里忽略了窗口的句柄，需要注意。

![](http://docs.google.com/File?id=dhn3dw87_46f7s3j4x8_b)

多么繁忙的World啊。。。。。。。。此时你会想，太强大了，我要将整个的Win32 API到处，于是Python就能像C/C++语言一样完全操作整个操作系统了，并且，这还是动态的！！！！没错，不过多大的工作量啊。。。。。。不过，Python这么流行，总是有人做这样的事情的，于是PyWindows出世了。去安装一个，于是你什么都有了。

```python
>>> import win32api
>>> win32api.MessageBox(0, "Great", "Hello World", 0)
1
```

这样，就能达到上面全部的效果。。。。。。。。。。。

![](http://docs.google.com/File?id=dhn3dw87_47fdxnq7dm_b)

## Python ctypes

如此这般，原来Python还是离不开C啊（虽然Python本身使用C写的）。。。，直到。。。。某年某月ctypes横空出世了，于是，完全不懂C语言的人，也可以直接用Python来完成这样的工作了。毫无疑问，Python越来越自成体系了，他们的目标是，没有其他语言！-_-!在Python v3.1.1的文档中如此描述，ctypes — A foreign function library for Python 然后：It can be used to wrap these libraries in pure Python.注意，他们要的是Pure Python！（我不是想要挑起语言战争。。。。。）Guido van Rossum开始说，wrap these,in pure Python。。。。不要再用foreign语言，血统不pure的家伙了。

闲话少说，看看ctypes，因为是pure Python嘛，所以看起来很简单，事实上文档也比较详细（当然，还是遗漏了一些细节），下面都以Windows中的Python3.1.1的操作为例：

```python
>>> import ctypes
>>> from ctypes import *
>>> dir(ctypes)
['ARRAY', 'ArgumentError', 'Array', 'BigEndianStructure', 'CDLL', 'CFUNCTYPE', 'DEFAULT_MODE', 'DllCanUnloadNow', 'DllGetClassObject', 'FormatError', 'GetLastError', 'HRESULT', 'LibraryLoader', 'LittleEndianStructure', 'OleDLL', 'POINTER', 'PYFUNCTYPE', 'PyDLL', 'RTLD_GLOBAL', 'RTLD_LOCAL', 'SetPointerType', 'Structure', 'Union', 'WINFUNCTYPE', 'WinDLL', 'WinError', '_CFuncPtr', '_FUNCFLAG_CDECL', '_FUNCFLAG_PYTHONAPI', '_FUNCFLAG_STDCALL', '_FUNCFLAG_USE_ERRNO', '_FUNCFLAG_USE_LASTERROR', '_Pointer', '_SimpleCData', '__builtins__', '__doc__', '__file__', '__name__', '__package__', '__path__', '__version__', '_c_functype_cache', '_calcsize', '_cast', '_cast_addr', '_check_HRESULT', '_check_size', '_ctypes_version', '_dlopen', '_endian', '_memmove_addr', '_memset_addr', '_os', '_pointer_type_cache', '_string_at', '_string_at_addr', '_sys', '_win_functype_cache', '_wstring_at', '_wstring_at_addr', 'addressof', 'alignment', 'byref', 'c_bool', 'c_buffer', 'c_byte', 'c_char', 'c_char_p', 'c_double', 'c_float', 'c_int', 'c_int16', 'c_int32', 'c_int64', 'c_int8', 'c_long', 'c_longdouble', 'c_longlong', 'c_short', 'c_size_t', 'c_ubyte', 'c_uint', 'c_uint16', 'c_uint32', 'c_uint64', 'c_uint8', 'c_ulong', 'c_ulonglong', 'c_ushort', 'c_void_p', 'c_voidp', 'c_wchar', 'c_wchar_p', 'cast', 'cdll', 'create_string_buffer', 'create_unicode_buffer', 'get_errno', 'get_last_error', 'memmove', 'memset', 'oledll', 'pointer', 'py_object', 'pydll', 'pythonapi', 'resize', 'set_conversion_mode', 'set_errno', 'set_last_error', 'sizeof', 'string_at', 'windll', 'wstring_at']
```

一个这样的小玩意儿包含的东西还真不少啊，可以看到主要包括一些C语言的类型定义。当你import ctypes的时候，一些动态库已经载入了：

```python
>>> print(windll.kernel32)

>>> print(windll.user32)

>>> print(windll.msvcrt)
```

直接来使用试试吧，我们最喜欢的自然是Hello World。这里直接调用MessageBox。查查MSDN，MessageBox在User32中，我们调用它。
```python
>>> MessageBox = windll.user32.MessageBoxW
>>> MessageBox(0,"Great","Hello World", 0)
```
然后，就调用了MessageBox了。。。。。。。。。

![](http://docs.google.com/File?id=dhn3dw87_44cmn6c2db_b)

怎么？晕了？比较一下ctypes库及Python C API吧。。。。于是，K&R哭了。。。。。。。。。。。。故事以下图开始

![](http://docs.google.com/File?id=dhn3dw87_48d28vfdhk_b)

以下图结束：

![](http://docs.google.com/File?id=dhn3dw87_49hf4wzzht_b)


**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**
