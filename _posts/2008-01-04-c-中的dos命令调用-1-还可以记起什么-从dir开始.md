---
layout: post
title: C++ 中的DOS命令调用（1）——还可以记起什么？从DIR开始
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

不要搞错了，我是讲怎么在C++中利用DOS命令，不是准备讲DOS编程。以下都以Windows XP中的MS-DOS为例，程序一般也以MFC程序为实例，在VS 2005下编译通过。

很久以前用电脑的时候还属于蛮荒时代，那时候都是黑屏白字的DOS，怎么说都是一种回忆了，现在谁还用那东西啊？呵呵，似乎以前用电脑的经验都是等于废了，记得我前两年考的C二级是最后一届需要考DOS的，虽然那时DOS也只在里面占了几分而已。

难道现在DOS真的没有一点用了吗？其实也不全是，对于个人操作来说，高手会告诉你命令行操作虽然复杂的多，但是永远比GUI操作来的快。在C++中调用DOS命令虽然感觉上可移植性能不是太好，但是有的时候的便利实在是无法言喻，避开了一大堆的API学习，让以前学习的DOS知识发挥余热，何乐而不为呢？

下面本人列举一些在C++中DOS命令的调用，让以前也熟悉DOS的同辈中人一起回到DOS时代，看看DOS时代的命令其实也是有很大学问的啊：）--至于以前没有学过DOS的人，就没有太大必要再来学习了，因为个人感觉重新学DOS和重新学Windows API区别不是很大，一般来说windows API还有更大的通用性和安全性，用DOS命令可以说很大程度上都没有办法调试源程序，因为大量的命令都是const char*形式调用的，编译器没有办法来帮你查错误，这些可以说是DOS命令在C++中调用的缺点，但是，假如有时间，DOS命令很多时候的便利也是值得学习的，另外，因为dos以前可是一个操作系统，所以从理论上来说，光用dos命令可以完成的任务都是数不清的。。。。。。

废话说多了，下面让我们重新回到DOS时代，看看我们能怎么用DOS命令简化我们的编程。

基础：在C++中调用DOS命令的基本方法，就是system(const char*);形式；比如，DEVC++中最常用的system("PAUSE")，其实就是DOS中的一个命令，用来暂停程序，并输出"按任意键继续"，那可就是一个DOS命令的调用啊，呵呵，以前还不知道吧。

下面一边回顾DOS的命令，一边让我们来看看他们都能干什么吧。

首先，最常用的DOS命令自然是DIR了，呵呵，虽然现在有的时候习惯LS了，不过DIR也很好用啊。

这里要讲的是，光system("dir")在程序中仅仅是输出在屏幕上而已，对于编程的实际帮助不是很大，该怎么调用呢？这里有个小的技巧，用">"操作，使用dir >xxx.txt的时候，dir的屏幕输出就被输出到xxx.txt文件中了，然后可以在程序中分析调用。当你需要看某个目录的时候其实一条命令也够用，用dir x:/xxx/xxx >xxx.txt的形式就可以了，这些其实都属于DOS知识。以下都以MFC程序为例，看看怎么使用DOS命令。呵呵，再次申明，用DOS命令仅仅是一条路而已，不要抱怨其他问题。我不是说没有别的办法啊，但是起码要另外学习，在没有学习之前用DOS命令作为替代也是不错的。谁说的来着，"There are more then one way"。剩下的就是对于输出文件的字符分析了，这个比一般的方法难点，不过，我们有正则表达式嘛，一切能够难道哪里去？对了，忘了说，假如是Unicode程序的话，是要用_wsystem的。

比如现在有个需要，在对话框的一个编辑栏中输入某个目录，我们用一个列表框输出该目录下的所有目录或者文件，由一个单选按钮控制。似乎好像有点复杂。。。。，让我们完成他。

先建立一个MFC对话框程序，然后建立一个编辑框，一个列表框，三个Radio按钮和一个普通的按键，最后程序界面大概如下：

[![dos1.jpg](http://www.jtianling.com/dos1_tn.jpg)](<http://www.jtianling.com/dos1.jpg> "dos1.jpg")

首先我们完成DIR的调用。为编辑框添加一个CString类型的控件变量取名为m_directory，最后只需要下面三行就可以了。

```cpp
UpdateData();
CString dir = _T("dir /"") + m_directory + _T("/" >dir.txt");
_wsystem(dir);
```

需要解释的就是dir的构成了，因为在dos下调用命令，dir后面的目录参数假如有空格是不行的，比如最常见的program files目录就不行，所以为目录参数加上引号，这样就算有空格也没有任何问题，在C++中引号用转义字符后加引号表示，另外，后面用管道把内容传给dir.txt文件。

这里完成一个MFC的函数封装，最后将文件内容保存为string。以下面函数完成任务：

```cpp
std::string CTestDialogDlg::ReadFromDir()
{
    UpdateData();
    CString dir = L"dir /"" \+ m_directory + L"/" >dir.txt";
    _wsystem(dir);
    std::string strFile,strTemp;
    std::ifstream infile("dir.txt");
    while(std::getline(infile, strTemp))
    {
        strFile += strTemp + "/n";
    }
    infile.close();
    return strFile;
}
```

现在最麻烦的就是处理dir.txt文件了。恩，的确比较麻烦，假如没有正则表达式的话。当然有了正则表达式就没有那么麻烦了。这里我以我最习惯的boost库正则表达式为例，假如你还不会的话可能看不懂，可以到[www.boost.org](<http://www.boost.org/>)去看看在线文档。我建立以下函数来分析目录：

```cpp
std::string CTestDialogDlg::MatchDirectory(const std::string &strFile)
{
    boost::regex re("<DIR>//s+([_//w][^//r//n]+)");
    boost::smatch result;
    std::string::const_iterator start = strFile.begin();
    std::string::const_iterator end = strFile.end();
    boost::match_flag_type flags = boost::match_default;
    std::string strDir;
    while(boost::regex_search(start, end, result, re, flags))
    {
        strDir += "<DIR>" \+ result[1] + "/n";
        start = result[0].second;
        flags |= boost::match_prev_avail;
        flags |= boost::match_not_bob;
    }
    return strDir;
}
```

其他的不多说了，不然不知道多浪费时间，至于正则表达式re的构成主要看到dir命令出来的文件格式中，目录都由<DIR>后面跟具体目录名，这里就匹配这一点，然后取<DIR>后面空白字符的第一个字符到最后一个字符即匹配后的result[1]为一个目录名，这里为了方便区分，也和dir一样，为目录加上<DIR>前缀。

文件名的匹配也基本类似。

```cpp
std::string CTestDialogDlg::MatchFile(const std::string &strFile)
{
    boost::regex re("//d{4}-//d{2}-//d{2}//s+//d{0,2}://d{0,2}//s+[//d,]+//s([^//r//n]+)");
    boost::smatch result;
    std::string::const_iterator start = strFile.begin();
    std::string::const_iterator end = strFile.end();
    boost::match_flag_type flags = boost::match_default;
    std::string strDir;
    while(boost::regex_search(start, end, result, re, flags))
    {
        strDir += result[1] + "/n";
        start = result[0].second;
        flags |= boost::match_prev_avail;
        flags |= boost::match_not_bob;
    }
    return strDir;
}
```

匹配文件名的正则表达式之所以这么复杂，主要是为了避免在dir.txt文件的前面有类似的文字，所以才完全的匹配了一行，当然，最后留下需要的文件名就可以了。

然后在搞个函数将字符串内容写入列表框就可以了。首先为列表框建立一个相关的控件变量，取名m_list。

```cpp
void CTestDialogDlg::WriteToList(const std::string &strList)
{
    m_list.ResetContent();
    std::stringstream strStream(strList);
    std::string strTemp;
    while(std::getline(strStream, strTemp))
    {
        CString str(strTemp.c_str());
        m_list.AddString(str);
    }
    UpdateData(false);
}
```

这里利用了stringstream的特性来完成每行的读取。

最后为按键添加一个按键处理程序，就可以完成任务了。这里为radio控件添加一个相关变量m_radio，以此用switch决定完成什么功能。

```cpp
void CTestDialogDlg::OnBnClickedButton1()
{
    std::string strFile = ReadFromDir();
    if(strFile.empty())
    {
        return;
    }
    std::string strList;
    switch(m_radio)
    {
    case 0: //目录
        strList = MatchDirectory(strFile);
        break;
    case 1: //文件
        strList = MatchFile(strFile);
        break;
    case 2: //全部
        strList = MatchDirectory(strFile);
        strList += MatchFile(strFile);
        break;
    }
    WriteToList(strList);
    UpdateData(false);
}
```

好了，这样一个程序就完成了全部想要的功能,看看运行效果： [![dos2.jpg](http://www.jtianling.com/dos2_tn.jpg)](<http://www.jtianling.com/dos2.jpg> "dos2.jpg")

其实程序的最主要部分就是DOS命令dir的调用了，所有的程序都是围绕此命令完成。当然，这时候完美主义者可能会发现两个问题。首先就是程序运行后留下了dir.txt文件，调用dir命令的痕迹太明显，另外就是DIR调用的时候会在MFC程序运行的时候弹出一个黑色命令行窗口，虽然此窗口由于DIR的调用速度很快所以一下就关闭了，还是有点影响程序的效果，起码别人知道你是调用了命令行了，其实也不是没有解决办法，请看下节，[瞒天过海--隐藏DOS调用的命令行窗口](<http://www.jtianling.com/archive/2008/01/04/2025132.aspx>)