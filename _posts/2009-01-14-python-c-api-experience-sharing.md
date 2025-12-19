---
layout: post
title: Python C API 使用心得
categories:
- Python
tags:
- C++
- Python
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '18'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

分享Python C API使用心得，详述了用C编写Python扩展模块和在C中嵌入并调用Python代码的两种方法，包含关键步骤与技巧。

<!-- more -->

**Python C API 使用心得**


工作的变化简直和人生变化一样不可预知.就在反外挂刚开始的时候，天天看的都是汇编和一大堆只有cracker(或想称为cracker)的人才会看的破解相关书籍，但是才过了几天，准备做被动的反外挂系统后，工作基本上就转到了用Python C API来写扩展模块和用Python来写Check程序了，真是突然。

想8月份看完《Programming in LUA》以后，对脚本语言重拾兴趣，后来断断续续也算把《Python核心编程》，这本来是非常纯粹的Just for fun的事情，最后确还是免不了染上工作的性质，呵呵，这样说好像很奇怪，应该是说，凭借着一点兴趣，花了很多业余时间去学习的Python， 想不到竟然能这么快就在工作中有所应用与发挥，实话说，做老板的，肯定希望有这样的员工。。。。。何况，在老板心中我还算是新员工呢。我要是老板，我也希望做一个新东西前，本来说要调研调研的。。。。结果已经有员工用业余时间已经做过了，然后可以直接开工，唉。。。。我不知道碰到这样的情况我为什么会叹 气。。。。。。。

其实以前学的主要是Python语言的语法，用Python C API来写扩展模块还真没有写过，要是用LUA的话，虽然特别复杂，但是可能好歹还有个底。最后几乎是纯粹靠文档来解决了一切，（还有老总提供的一些没头没尾的例子）不要问我为什么不上网查，资料太少，而且在公司上网并不方便。

这里总结一下，以防忘记（我并不准备详细记录下每个步骤，仅仅记要点，假如需要详细步骤的，请参看Python document中的例子）

一：用C API为Python写C语言函数，以方便Python中调用，这种方法还是很简单的，和LUA C API的方法基本一样。（参看文档的Extending Python with C or C++部分）

1. 首先实现一个特定原型的函数，用Python C API来实现的话，所有函数必须是这种原型。必须是类似这样的

PyObject *Fun(PyObject *self, PyObject *args)

self应该是在用类的时候才会用到（我没有用到），args就是函数的参数。因为args是一个PyObject*类型（可以代表Python语言中的任何类型）

2. 将参数转换成C 语言表示的内容，用PyArg_ParseTuple函数。

3. 执行完需要的操作后，也必须返回一个PyObject*类型的值。通过Py_BuildValue函数来构建。

这里要说的是，假如希望返回一个Tuple类型的值，可以先用

PyObject *tuple = Py_BuildValue("(iis)", 1, 2, "three");

形式来构建，假如很多的话，可以用下面的方式来构建

```c
PyObject *t;

t = PyTuple_New(3);
PyTuple_SetItem(t, 0, PyLong_FromLong(1L));
PyTuple_SetItem(t, 1, PyLong_FromLong(2L));
PyTuple_SetItem(t, 2, PyString_FromString("three"));
```

这一点在刚开始开工的时候迷惑了很久。

4. 将要输出的所有函数放入一个数组中，数组的结构是：

```c
struct PyMethodDef {
    const char    *ml_name;  /* The name of the built-in function/method */
    PyCFunction  ml_meth;   /* The C function that implements it */
    int       ml_flags; /* Combination of METH_xxx flags, which mostly
                 describe the args expected by the C func */
    const char    *ml_doc;   /* The __doc__ attribute, or NULL */
};
```

数组以{NULL, NULL}结束

5. 构造一个Python import时初始化的函数

类似

```c
PyMODINIT_FUNC
initexample(void)
{
    Py_InitModule("example", example_methods);
}
```

这里有个特别需要注意的是，初始化函数名字有严格要求，init后面必须跟模块名，否则Python找不到确定的函数会报没有初始化函数的错误

总结一下，记得第一次学习LUA C API接口的时候，碰到类似的扩展模块写法，还是感觉很奇怪，"怎么搞这么复杂啊"。。。。。当时为了实现一个简单的扩展都是折腾了很久，到了再一次碰到类似的问题，（Python C API写扩展的时候几乎就是和LUA C API一样），基本已经轻车熟路了。这里突然也想说一句，就算不是真的写非常底层的接口，但是用的接口多了，都是能有些感觉的。

扩展模块写完后，编译成动态库（Python要求此动态库名字为pyd,实际就是改个后缀而已）。就可以直接在Python脚本中用import的方式加载了，对于使用来说，根本不需要知道此库是用C API扩展写的还是直接用Python语句写的（这点Lua做的也是一样好）

最后，python的源代码中附带了一个叫做example_nt的例子，可以参考一样，完整的扩展代码如下：

```c
#include "Python.h"

static PyObject *
ex_foo(PyObject *self, PyObject *args)
{
    printf("Hello, world/n");
    Py_INCREF(Py_None);
    return Py_None;
}

static PyMethodDef example_methods[] = {
    {"foo", ex_foo, METH_VARARGS, "foo() doc string"},
    {NULL, NULL}
};

PyMODINIT_FUNC
initexample(void)
{
    Py_InitModule("example", example_methods);
}
```

二．C语言中调用Python语句

首先，void Py_Initialize()用来初始化，void Py_Finalize()用来结束Python的调用，这是必须要的。

燃火分两种情况，假如仅仅是几条语句的话，那么以PyRun_为前缀的一些函数都很好用，比如

int PyRun_SimpleString(const char _*command_)

函数就可以直接执行一条char*的Python语句。

需要获得返回值得话

PyObject* PyRun_String(const char *str, int start, PyObject *globals, PyObject *locals)

也很好用，以上两个函数用来处理Python源代码已经读入内存的情况，在文件中的时候

int PyRun_SimpleFile(FILE _*fp_ , const char _*filename_)

PyObject* PyRun_File(FILE *fp, const char *filename, int start, PyObject *globals, PyObject *locals)

使用类似。不多讲了。

假如是个模块的话（比如一个函数），希望在C语言中调用的话那么使用起来就稍微复杂了一点。这种情况的需要在于你可以从C语言中向Python函数中传入参数并且执行，然后获取结果。

此处又分为几种情况：

在文件中，在内存中，编译过的，源代码。

在文件中都很好解决，和上面一样。这里主要讲在内存中的情况。（事实上我工作中需要并且耗费了很长时间才找到解决方法的就是这种情况）

未编译时：（也就是源代码）

1.通过

PyObject* Py_CompileString(const char *str, const char *filename, int start)

API首先编译一次。此API的参数我说明一下，str就是内存中的源代码，filename主要是出错时报错误用的，事实测试证明，你随意给个字符串也没有关系，但给NULL参数在运行时必然报错。start我一般用的是Py_file_input，因为的确是从文件中读取过来的，相对的还有Py_single_input用来表示一条语句，Py_eval_input的用法我也不是太清楚。

源代码通过此函数调用后，获得编译后的PyObject*,（其实假如跟进源代码中去看，是一个PyCodeObject结构）假设命名为lpCode。

2.此时再调用API

PyObject* PyImport_ExecCodeModule(char *name, PyObject *co)

导入模块。参数也说明一下，name为导入的模块名，co就是前面编译过的代码对象（lpCode）。返回的就是模块对象了，假设命名为lpMod。

3.再调用API

PyObject* PyObject_GetAttrString(PyObject *o, const char *attr_name)

获得函数对象。o就是模块对象（lpMod）,attr_name就是你想要调用的函数名了，假设叫main的函数，就是"main"，然后返回的就是函数对象，假设命名为lpFun。

4.此时可以用API

int PyCallable_Check(PyObject *o)

去检查一下是不是获得了一个函数。假如确定的话，就可以直接用

PyObject_Call开头的一族函数调用lpFun了。这些函数包括很多，一般就是输入参数的不同，但是效果都是一样的，就是调用函数而已。参数一般可以通过前面说过的build函数来获得，返回值也是获得一个PyObject*,可以通过PyArg_那个函数来获取，但是好像不太好，那是分析参数用的。推荐用确定类型（假设为type）的类似Py[type]_As的函数来获取。

比如：

long PyLong_AsLong([PyObject](<http://mk:@MSITStoreD:%5CPython30%5CDoc%5Cpython30.chm::> "PyObject") *pylong)获取long

double PyLong_AsDouble([PyObject](<http://mk:@MSITStoreD:%5CPython30%5CDoc%5Cpython30.chm::> "PyObject") *pylong)获取double

这里想说的是，应该有直接从源代码中获取函数调用对象的方式，但是我本人没有试出来，有人知道请一定赐教！

编译过的代码：

对于编译过的代码和上面就是获得编译后的PyCodeObject对象,当然在源代码中表示还是PyObject*的方法不同（上例中的lpCode）。

当然要想以后获得一个编译后的lpCode,自然要先编译一下啦。但是纯粹编译成pyc结尾的文件后，直接读入内存，我没有找到将其转化为PyCodeObject对象的方法（也希望有人知道能告诉我！）

我找到的方法是先用

PyObject* PyMarshal_WriteObjectToString(PyObject *value, int version)

void PyMarshal_WriteLongToFile(long _value_ , FILE _*file_ , int _version_)

两个函数先把PyCodeObject对象(lpCode)序列化到文件或者内存中。

再在需要的时候用函数

PyObject* PyMarshal_ReadObjectFromFile(FILE *file)

PyObject* PyMarshal_ReadObjectFromString(char *string, Py_ssize_t len)

读出来，读出来的PyObject*其实就是想要的PyCodeObject对象了(lpCode)。接下来的步骤与未编译时的步骤一样。

光是这个扭曲的方法我还是参考老总给的半边资料反复研究出来的。而真正直接有效的方法我还是没有找到。

我希望能解决的问题我总结一下，有2个

1. 直接从源代码中读入，转成模块对象（lpMod），而不需要先通过Py_CompileString的调用。

2. 直接从pyc文件（内存）中读入，转成代码对象(lpCode)或者模块对象（lpMod），扭曲的通过序列化PyCodeObject对象再序列化出来的方式。

希望我从文档中摸索出来的东西对于有些同样需要的人有价值。这一些方法我在网上也找到，但是没有找到，最后还是靠自己摸索才找出了一些扭曲的方式来解决问题。

这里想对那些动不动就说你想把文档都看看的，你先把什么都看仔细了的兄弟们说一下，并不是每个老板都允许员工干一件事情前去把一种新的语言全学精了，哪怕他明知道这就是一种你不知道的语言。有的时候，just for work而 已。当然，在有时间的时候，自然我也是想把该学的都好好学了，只是，工作的时候，身不由己啊，何况，该学的东西是很多的，个人也可能有个人的学习计划，并不是工作中碰到一种问题，我的业余时间也得全部搭上去，把这件事情学通，所以请多给一些谅解，碰到有人问对你来说很初级的问题时，你好心的就给个回答，我 很感谢，不想回答的起码也不要说风凉话，我也很感谢了。其实我倒是也没有真发帖去问，因为等到有人回答估计一天的工作时间都耽误了，只是看到有类似的情况，所以随便说说，希望不要见怪。

**write by****九天雁翎(JTianLing) -- www.jtianling.com**
