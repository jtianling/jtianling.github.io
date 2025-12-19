---
layout: post
title: C++ 中的DOS命令调用（2）——瞒天过海，隐藏DOS调用的命令行窗口
categories:
- C++
tags:
- C++
- DOS
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

上一节我演示了一下在MFC程序中怎么应用DOS的dir的命令，可是我们遇到了需要解决的问题，首先就是文件dir.txt的残留问题，其实这个问题很简单，我们也可以用dos的del命令在操作后将dir.txt文件删除，这样的结果就是程序会两次弹出窗口，这样更加让人无法接受了，现在我们的问题是，有没有办法隐藏弹出窗口？答案是有的，这点我在网上找了很久，都没有找到解答，最后自己摸索出了一些方法，不知道还有没有更好的方法，因为这些方法都有些缺点，比较恼火。

<!-- more -->

首先，我们可以用第二参数为SW_HIDE调用WinExec()这个windows的API，这时候又有个问题了，WinExec()是调用程序的，而DIR程序文件在哪里？呵呵，其实这点在有很多DOS使用经验的人都知道，DOS命令在以前就分两种，一种叫内部命令，一种叫外部命令。其中比较常用的比如dir,del都属于内部命令，特点是直接加载进内存。而外部命令是可以在目录中找到具体的文件的，当时就会常常遇到PATH设定不对导致的外部命令调用错误，而需要找到目录去调用的情况。既然加载在内存里面，我们到哪里去找命令文件？答案我不知道，不过有个变通的方法。因为在windows中，DOS的实际调用都是用cmd程序，那么我们就用它来调用，具体方法是以/C为参数调用。比如我们要调用dir命令，那么具体方法如下：

WinExec("cmd /C dir");

理由可以参考help cmd。当然我们还是有以前那样的问题，那就是dir后面跟具体目录做参数的时候需要加引号，那么我们调用目录的时候一般可以用下面的形式：

WinExec("cmd /c dir /"xxxxx/");

这种方法在直接调用的时候很好用，比如删除文件的时候，直接一个WinExec("cmd /c del dir.txt");就可以了，但是也是有个问题，这是个太老的API了，所以根本没有Unicode的版本，苦闷的Unicode版本程序因此无法较好的使用，在以CString为字符串调用的时候似乎只有两种方法，一种是以ANSI方式编译，一种就是通过Unicode到ANSI的转换了，这样的转换很可能还会丢失中文信息。因此，个人推荐只在直接调用DOS命令的时候使用WinExec，而且也推荐直接调用的时候使用，因为WinExec只需要两个参数，很容易调用。但是要在Unicode程序中以CString为参数调用怎么办？当然，用MSDN中推荐的**CreateProcess** 不会有任何问题，问题是，太复杂了。。。。。个人推荐另一个方案，ShellExecute。虽然比WinExec复杂一点，但是还可以接受。函数原型如下：

```c
HINSTANCE ShellExecute(
    HWND hwnd,
    LPCTSTR lpOperation,
    LPCTSTR lpFile,
    LPCTSTR lpParameters,
    LPCTSTR lpDirectory,
    INT nShowCmd
);
```

这里，hwnd直接用窗口的句柄就可以了，lpOperation可以省略，默认为open,lpFile我们调用cmd，lpParameters我们加入参数，注意的是cmd要多个/C参数，目录可以为空，nShowCmd为SW_HIDE以达到我们的目的，同上面的情况，调用ShellExecute的时候为以下形式：

ShellExecute(m_hWnd, NULL, _T(cmd), _T("/C dir /"xxxxxx/"");

比如在上一节的例子中，我们调用ShellExecute的方法就是下面这样：

```cpp
CString dir = _T("/C dir /"") + m_directory + _T("/" >dir.txt");
ShellExecute(m_hWnd, NULL, _T("cmd"), dir, NULL, SW_HIDE);
```

然后，改变后你会发现程序在第一次调用的时候不会有任何反应，一定要第二次点击按钮才能生效，原因可能会令人很困惑，有多线程编程经验的人可能会反应过来，因为ShellExecute的调用实际上是新开了一个线程，那么所有关于多线程编程让人郁闷苦恼烦躁的问题都完全适用。这里，问题在于，ShellExecute新开线程后直接返回了，不等dir调用完成，那么下面接着的打开文件根本就找不到文件，我给出一种解决方案，在打开文件的时候检测一下，然后用Sleep休息200毫秒，再检测，如此可以达到需要的要求：

```cpp
while(!infile.is_open())
{
    static int i = 0;
    ::Sleep(200);
    infile.open("dir.txt");
    ++i;
    if(i > 50)
    {
        MessageBox(_T("Error to create and open the file"));
        exit(EXIT_FAILURE);
    }
}
```

经过完善，上节中ReadFromDir函数完整结果如下：

```cpp
std::string CTestDialogDlg::ReadFromDir()
{
    UpdateData();
    CString dir = _T("/C dir /"") + m_directory + _T("/" >dir.txt");
    // _wsystem(dir);
    std::string strFile,strTemp;
    ShellExecute(m_hWnd, NULL, _T("cmd"), dir, NULL, SW_HIDE);
    // WinExec(dir, SW_HIDE);
    std::ifstream infile;
    while(!infile.is_open())
    {
        static int i = 0;
        ::Sleep(200);
        infile.open("dir.txt");
        ++i;
        if(i > 50)
        {
            MessageBox(_T("Error to create and open the file"));
            exit(EXIT_FAILURE);
        }
    }
    while(std::getline(infile, strTemp))
    {
        strFile += strTemp + "/n";
    }
    infile.close();
    WinExec("del dir.txt", SW_HIDE);
    // _wsystem("del dir.txt");
    return strFile;
}
```

经过如上改变，再使用程序，没有看到源代码的人，谁还知道你是用了DOS的DIR命令实现的呢？

这一节的主要内容是给广大因为使用了DOS命令而导致程序运行效果不佳老弹出窗口的同志们信心，大胆的调用DOS命令吧，没有人知道的，只要能简单的完成任务，我们不择手段，呵呵。
