---
layout: post
title: SelfExtractor自解压模块理解文档
categories:
- C++
tags:
- C++
- SelfExtractor
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


# SelfExtractor理解文档

## ReadToc(CString Filename)

首先从文件尾反向Seek一个strlen(文件标志)的距离,然后读取文件标志,判断此文件标志.错误即返回INVALID_SIG.

然后再从文件尾反向Seek一个strlen(文件标志)+sizeof(int)的距离,读取一个整数,此整数代表文件数量.当其为0,即返回NOTHING_TO_DO,

然后根据文件数量,循环依次反向的Seek,读取文件名长度,文件名,文件长度,文件在文档中的偏移值.将各文件的信息保存在m_InfoArray数组中,将最后得到的偏移值,保存在m_nTOCSize中,此偏移值即整个文档头的大小.

<!-- more -->

## int CSelfExtractor::ExtractOne(CFile* file, int index, CString Dir);

通过m_InfoArray中的数据,读入,并写入创建的新文件;写入时一次写1000字节,没有1000字节即写入剩下大小.

## int CSelfExtractor::ExtractAll(CString Dir, funcPtr pFn /*= NULL*/, void * userData /*= NULL*/)

首先读取文档头,得到保存有文件信息的m_InfoArray数组,然后依据此数组,分别调用ExtractOne解压到磁盘上,解压后还可以调用funcPtr类型的用户定义函数.

## int CSelfExtractor::CreateArchive(CFile* pFile, funcPtr pFn, void* userData)

先分别从m_InfoArray数组中读入文件的信息,并从外部读入,写入到文档中,

然后写文档头

## int CSelfExtractor::Create(UINT resource, CString Filename, funcPtr pFn /* = NULL */, void* userData /*=NULL*/)

分别用FindResource,LoadResource,LockResource函数读入执行文件资源.

将整个执行文件全部写入新创建的文件.调用CreateArchive完成接下来的文件的写入.

## int CSelfExtractor::Create(CString ExtractorPath, CString Filename, funcPtr pFn /* = NULL */, void* userData /*=NULL*/)

不是以资源形式给出可执行文件时:

先利用
```cpp
CShellFileOp shOp;

       shOp.SetFlags(FOF_FILESONLY | FOF_NOCONFIRMATION | FOF_SILENT);

       shOp.AddFile(SH_SRC_FILE, ExtractorPath);

       shOp.AddFile(SH_DEST_FILE, Filename);

       if(shOp.CopyFiles() != 0)

             return COPY_FAILED;
```

来完成从一个用户指定可执行文件到新建立文档的复制,接着还是利用调用CreateArchive完成接下来的文件的写入.
