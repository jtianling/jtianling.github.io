---
layout: post
title: Breakpad 使用方法理解文档
categories:
- C++
tags:
- Breakpad
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '36'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


Breakpad 使用方法理解文档.

<!-- more -->

只需要在任何异常前正常创建一个ExceptionHandler类的成员函数,就可以完成异常的捕捉及dump.

在创建ExceptionHandler时,第一参数为宽字符表示的dump存储路径,第二参数为dump前客户需要运行的程序,程序原型应该为

```cpp
bool (*FilterCallback)(void* context, 
                       EXCEPTION_POINTERS* exinfo,
                       MDRawAssertionInfo* assertion);
```

程序返回false将不产生dump,返回true才正常dump.

第三参数为客户Dump后需要运行的程序,程序原型为:

```cpp
bool (*MinidumpCallback)(const wchar_t* dump_path,
                         const wchar_t* minidump_id,
                         void* context,
                         EXCEPTION_POINTERS* exinfo,
                         MDRawAssertionInfo* assertion,
                         bool succeeded);
```

程序返回true表示异常全部被控制,程序正常运行,返回false,程序仍然保留异常,以方便交给其他程序处理,比如各平台的原生异常处理系统.

HandlerType:确定需要控制的异常类型,HANDLER_ALL时,控制所有类型的异常.

ExceptionHandler有两个版本的构造函数:

```cpp
ExceptionHandler(const wstring& dump_path,
                  FilterCallback filter,
                  MinidumpCallback callback,
                  void* callback_context,
                  int handler_types);

ExceptionHandler(const wstring& dump_path,
                  FilterCallback filter,
                  MinidumpCallback callback,
                  void* callback_context,
                  int handler_types,
                  MINIDUMP_TYPE dump_type,
                  const wchar_t* pipe_name,
                  const CustomClientInfo* custom_info);
```

dump_path()用来返回dump的路径.

Set_dump_path(const wstring &dump_path)用来设置路径.

WriteMinidump()

WriteMinidump(const wstring &dump_path,
                    MinidumpCallback callback, void* callback_context);立即写dump文件.

WriteMinidumpForException(EXCEPTION_POINTERS* exinfo)用用户提供的异常信息立即写dump文件.

get_requesting_thread_id()得到出现异常或者调用WriteMinidump()函数的线程ＩＤ．

```cpp
bool ExceptionHandler::WriteMinidumpWithException(
    DWORD requesting_thread_id,
    EXCEPTION_POINTERS* exinfo,
    MDRawAssertionInfo* assertion)
```

为最主要的函数,具体的写下Dump文件.

这个结构很明显是用来保存异常信息的

```c
typedef struct _EXCEPTION_RECORD {
    DWORD    ExceptionCode;
    DWORD ExceptionFlags;
    struct _EXCEPTION_RECORD *ExceptionRecord;
    PVOID ExceptionAddress;
    DWORD NumberParameters;
    ULONG_PTR ExceptionInformation[EXCEPTION_MAXIMUM_PARAMETERS];
    } EXCEPTION_RECORD;

typedef EXCEPTION_RECORD *PEXCEPTION_RECORD;
```

```c
typedef struct _CONTEXT {

    //
    // The flags values within this flag control the contents of
    // a CONTEXT record.
    //
    // If the context record is used as an input parameter, then
    // for each portion of the context record controlled by a flag
    // whose value is set, it is assumed that that portion of the
    // context record contains valid context. If the context record
    // is being used to modify a threads context, then only that
    // portion of the threads context will be modified.
    //
    // If the context record is used as an IN OUT parameter to capture
    // the context of a thread, then only those portions of the thread's
    // context corresponding to set flags will be returned.
    //
    // The context record is never used as an OUT only parameter.
    //

    DWORD ContextFlags;

    //
    // This section is specified/returned if CONTEXT_DEBUG_REGISTERS is
    // set in ContextFlags.  Note that CONTEXT_DEBUG_REGISTERS is NOT
    // included in CONTEXT_FULL.
    //

    DWORD   Dr0;
    DWORD   Dr1;
    DWORD   Dr2;
    DWORD   Dr3;
    DWORD   Dr6;
    DWORD   Dr7;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_FLOATING_POINT.
    //

    FLOATING_SAVE_AREA FloatSave;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_SEGMENTS.
    //

    DWORD   SegGs;
    DWORD   SegFs;
    DWORD   SegEs;
    DWORD   SegDs;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_INTEGER.
    //

    DWORD   Edi;
    DWORD   Esi;
    DWORD   Ebx;
    DWORD   Edx;
    DWORD   Ecx;
    DWORD   Eax;

    //
    // This section is specified/returned if the
    // ContextFlags word contians the flag CONTEXT_CONTROL.
    //

    DWORD   Ebp;
    DWORD   Eip;
    DWORD   SegCs;              // MUST BE SANITIZED
    DWORD   EFlags;             // MUST BE SANITIZED
    DWORD   Esp;
    DWORD   SegSs;

    //
    // This section is specified/returned if the ContextFlags word
    // contains the flag CONTEXT_EXTENDED_REGISTERS.
    // The format and contexts are processor specific
    //

    BYTE    ExtendedRegisters[MAXIMUM_SUPPORTED_EXTENSION];

} CONTEXT;

typedef CONTEXT *PCONTEXT;
```

```c
typedef struct _EXCEPTION_POINTERS {
    PEXCEPTION_RECORD ExceptionRecord;
    PCONTEXT ContextRecord;
} EXCEPTION_POINTERS, *PEXCEPTION_POINTERS;
```

```c
typedef struct {
 /* expression, function, and file are 0-terminated UTF-16 strings.  They
  * may be truncated if necessary, but should always be 0-terminated when
  * written to a file.
  * Fixed-length strings are used because MiniDumpWriteDump doesn't offer
  * a way for user streams to point to arbitrary RVAs for strings. */
 u_int16_t expression[128];  /* Assertion that failed... */
 u_int16_t function[128];    /* ...within this function... */
 u_int16_t file[128];        /* ...in this file... */
 u_int32_t line;             /* ...at this line. */
 u_int32_t type;
} MDRawAssertionInfo;
```

实现上:当FilterCallback(即ExceptionHandler构造函数的第二参数)不为空的时候,首先用WriteMinidumpWithException函数的原参数直接调用FilterCallback,(参数类型一致),完成用户在调用Dump先需要做的工作.

然后通过IsOutOfProcess（）成员函数判断是否此时是Exception_handler自身来进行dump,详细内容,参看 <Breakpad在进程中完成dump的流程文字描述>

当IsOutOfProcess()返回真的时候,应该表示此时处理是在进程外发生的,也就是利用crash_generation的client,server的机制完成,不影响原进程的运行.

此时调用CrashGenerationClient类型的成员变量的RequestDump函数完成dump.

当返回假的时候,此时先判断是否从dbghelp.dll中正确的import了MiniDumpWriteDump函数,然后创建了一个新的可写的文件.

当创建成功后,ExceptionHander加入异常信息到user_streams,然后调用minidump_write_dump_(实际就是dbghelp.dll中的MiniDumpWriteDump函数)完成dump.

主要的信息都在WriteMinidumpWithException函数的第二参数及第三参数里面.从注释上看,这些信息属于breakpad自己新增加的附加信息,但是增加这些信息对以前的dump文件正常使用没有影响,这些信息来自出现纯虚函数调用和无效参数调用时,breakpad自定义的用户函数中添加的信息.

```cpp
_set_invalid_parameter_handler(ExceptionHandler::HandleInvalidParameter);
#endif  // _MSC_VER >= 1400

_set_purecall_handler(ExceptionHandler::HandlePureVirtualCall);
```

即, HandleInvalidParameter, HandlePureVirtualCall中添加的信息.

此信息类型为MDRawAssertionInfo,在HandlePureVirtualCall函数调用时,仅仅是设定异常类型为HandlePureVirtualCall,当出现无效参数调用时,增加的内容较多:

```cpp
_snwprintf_s(reinterpret_cast<wchar_t*>(assertion.expression),
             sizeof(assertion.expression) /, sizeof(assertion.expression[0]),
             _TRUNCATE, L"%s", expression);

_snwprintf_s(reinterpret_cast<wchar_t*>(assertion.function),
             sizeof(assertion.function) / sizeof(assertion.function[0]),
             _TRUNCATE, L"%s", function);

_snwprintf_s(reinterpret_cast<wchar_t*>(assertion.file),
             sizeof(assertion.file) / sizeof(assertion.file[0]),
             _TRUNCATE, L"%s", file);

assertion.line = line;
assertion.type = MD_ASSERTION_INFO_TYPE_INVALID_PARAMETER;
```

分别为调用无效参数的表达式,函数名,文件名,行号,最后设定异常类型为

MD_ASSERTION_INFO_TYPE_INVALID_PARAMETE.

最后关闭文件,再调用callback_函数,也就是ExceptionHandler构造函数的第三参数.

其他主要内容在 <Breakpad在进程中完成dump的流程文字描述>描述.
