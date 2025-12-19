---
layout: post
title: Windows中多指针输入技术的实现与应用（5 利用多鼠标输入框架软件实现）
categories:
- "我的程序"
tags:
- Windows
- "多鼠标"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '62'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文对比分析了CPNmouse、MultiPoint SDK和SDG Toolkit三种多鼠标输入框架，详细阐述了各自的优缺点、实现原理及适用场景。

<!-- more -->

3 利用多鼠标输入框架软件实现

3.1 利用CPNmouse库的实现

CPNmouse是sourceforge上的一个开源项目，最先由过滤式鼠标驱动实现的作者 M.Westergaard发起，主要原理就是利用了文献[9]提到方法，并效率较高的实现一个高层的框架级程序，并提供一组API供开发者使用。

利用CPNmouse开发的优点很明显，因为CPNmouse提供了驱动及高层的API给开发者使用，开发人员可以不考虑很多底层复杂的事情，专注于软件更高层的实现，对于新开发软件想支持多鼠标输入技术的实现比较便利。目前CPNmouse已经支持在 Windows 9x至Windows XP下运行，并且利用了CPNmouse的开发人员可以在不改变或很少改变原有软件的情况下，获得将来CPNmouse改进升级后的好处。不得不提的就是CPNmouse作为开源软件，使得软件开发人员在需要的情况下可以对CPNmouse进行优化改良，自主掌握能力较为充分。缺点也是很致命的，因为CPNmouse仅仅提供了一组API，原有的软件要利用就得进行比较大的改变，而且此API的使用并不是太方便，往往可能需要对原有软件的结构进行彻底改变。而且CPNmouse利用的是时分系统来控制鼠标和绘制鼠标指针，这也会带来以前描述过的副作用。比如CPNmouse作者提供了一个示例程序。安装完CPNmouse提供的驱动，运行此程序后，当仅仅接入2个鼠标时，可以在屏幕上为新加入的鼠标绘制出独立的指针，但是当系统鼠标移动，新加入的鼠标将完全由第一次接入的鼠标控制。如附录C图C1，C2所示。接入第3个鼠标后，系统绘制出新加入的两个独立指针，并且用了左右镜像处理以示区别，但是，很显然的是利用了时分系统，导致当新加入的鼠标同时操作时，会导致混乱，而且，新加入的鼠标都会完全被第一次接入的鼠标所控制，以至于三个鼠标根本没有办法同时控制。如附录C图C3，C4，C5所示。通过以上演示，可以发现CPNmouse不仅是利用了时分系统来控制鼠标和鼠标指针，甚至连鼠标是否是系统鼠标都没有分辨，所以导致新接入的鼠标会被原有的第一个鼠标完全控制。另外，CPNmouse虽然作为开源软件，但是使用的人不是太多，以至于文档资料极少，能够利用的官方文档也是由软件自动生成，实用性一般。我们几乎仅能通过文献[9]来理解此其的原理及使用，这也会成为软件开发的极大阻碍。实际上只有少数软件是利用此技术完成，比如CPNmouse作者自己开发的CPN tools和少部分符合 Mouse-Party的游戏。

3.2 利用MultiPoint SDK的实现

微软的MultiPoint SDK来源于其印度实验室技术人员的一次经历，[8]见识到多鼠标输入在教育行业的巨大潜力以后，进行了文献[5]里描述的具体对比实验与研究，并最终决定研发。2007年6月25日开始提供1.0版程序下载。按微软官方描述，此软件开发包是帮助软件开发人员开发在一台电脑上用多个鼠标的程序。为的是让开发出来的程序可以让多个学生在一台电脑上进行共享性或竞争性的学习，工作或娱乐。帮助填补印度或其他发展中国家电脑短缺的现象。

作为微软的SDK开发包，MultiPoint有着较为优秀的运行性能，软件结构设计非常合理，并且继承着微软的传统，那就是官方的文档非常丰富，足以应付一般开发的需求。另外，就微软描述，MultiPoint之所以不叫MultiMouse，是因为将来还会加入其他输入设备的支持，更为难得的是，作为微软的一款产品，微软为了更快的推广它，目前仍然免费提供给软件开发人员使用。但是，MultiPoint SDK毕竟是1.0版本，技术上还有很多不成熟的地方，比如只支持USB指针输入设备，意味之大部分人使用的PS/2接口鼠标不能使用，其次是使用MultiPoint SDK设计出来的软件，比如最大化，最小化，关闭，卷动条等系统功能都不能通过指针设备来成功控制，另外当多个使用了MultiPoint的软件同时运行，它们分享同一个事件管理，意味着同时运行两个使用MultiPoint的软件会极度的混乱。还有因为MultiPoint技术是出自微软之手，这自然是个商业软件，所以软件开发人员难以知道此软件开发包的具体实现原理，也不可能对该软件开发包本身进行进一步的优化，只能是微软提供什么就用什么。而且软件开发人员的开发工具也不得不被绑在微软的专署工具Visual Studio .Net系列上面，最严重的是，甚至开发人员只能使用微软设计的C#语言进行开发工作。另外，虽然MultiPoint免费，但是却还是需要购买微软的产品，况且还不能知道微软什么停止MultiPoint的免费，开发人员在MultiPoint开发的产品自己也不能拥有全部的权利。最后，因为MultiPoint SDK是个非常新的SDK，所以除了官方的文档以外，还没有太多额外可参考的文档资料，成熟的利用此技术开发的产品也还没有。这些都是MultiPoint作为微软产品的普及障碍，也会成为其使用的难以避免的烦恼之处。

3.3 利用Single Display Groupware Toolkit的实现

Single Display Groupware Toolkit 由加拿大calgary大学GroupLab的E.Tse, S.Greenberg 开发，[10][11][12]是在前面介绍过的RawInput技术上建立的一个设计良好的框架程序，专门为开发SDG程序而设计。

SDG Toolkit特别设计了一个.Net兼容的事件管理器，使得在Visual Studio .Net下设计使用非常简便，在设计普通程序的时候，就可以利用带有鼠标ID标志的事件，很简便的融入以前设计或新设计的程序当中。如图3.1所示。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/SDG Toolkit 在VS .Net 2005 中增加的事件.JPG)

图3.1 SDG Toolkit 在VS .Net 2005 中增加的事件

此工具因为和.Net技术兼容，可以利用的开发语言也比一般的软件开发库（包）要更为丰富，Visual Basic, Visual C++, Visual C#，都可利用此技术。而且SDG Toolkit不仅支持串口，PS/2，USB各种接口的鼠标，目前也已经加入了对于多个键盘的支持，因为SDG Toolkit作者考虑到在多人使用触摸屏时使用者往往站在不同方向，甚至加入了指针的方向特性。[11]也可以通过颜色，或者指针右下的文字在屏幕上来标识和识别不同的指针。如下图3.2所示。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/SDG 绘画板示意图.JPG)

图3.2 SDG 绘画板示意图[11]

SDG Toolkit还特意为多指针操作的需要，独立制作了一组交互控件，供开发者使用，还提供了一组自定义控件的模板以方便用户自定义控件的开发。另外，很重要的一点是SDG Toolkit还是开源软件，意味着开发人员在需要的情况下可以对SDG Toolkit进行特别的优化，也可以通过源代码了解到SDG Toolkit的工作原理，以便更好的优化自己设计的软件，并且SDG Toolkit相对于CPNmouse来说官方的文档支持非常丰富，包括了大量的资料及实例代码，足够日常的程序设计需要。但是此工具不是没有缺点，因为建立在带ID的RawInput系统下，所以有着RawInput固有的缺点：只能在Windows XP/NT中运用。而且因为软件为了和.Net兼容，导致了此软件虽然开源，却有着和微软固有软件的一些缺点，比如要利用此技术，只能在Visual Studio .Net环境下进行开发，导致开发人员要利用此技术就必须得购买Visual Studio .Net。另外，因为程序设计上的缺陷，在运行利用SDG Toolkit设计的软件时，在拔下新加入的鼠标时，鼠标指针并不会消失。

3.4 Single Display Groupware Toolkit的实现原理

在此节，详细介绍了SDG Toolkit的实现原理。我还是主要从不同鼠标输入数据的识别和各鼠标独立指针的绘制两方面来分析SDG Toolkit的实现。首先，SDG Toolkit的主要框架结构如下页图3.3所示：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/SDG Toolkit主要框架结构图.JPG)

图3.3 SDG Toolkit主要框架结构图[12]

要分析SDG Toolkit的原理不能不先解释它封装数据的两个主要类。因为我这里主要是讲多指针输入的问题，所以没有提到SDG Toolkit的键盘输入部分。

从图3.3中可以看到，SDG Toolkit最主要的部分就是SDG Manager类，在这个类中管理着各个事件的触发以及鼠标指针的绘制。这个类中包含一个类型为MouseCollection的Mice成员变量，储存着现在系统中所有鼠标的信息，MouseCollection实际上是一个Mouse类的集合，而Mouse类中主要封装各鼠标的输入信息并实际完成鼠标的绘制工作，对于鼠标输入来讲，这是非常重要的一个类，它的成员变量，Xabs,Yabs就是各鼠标所在位置的X,Y坐标，X,Y表示的是由RelativeTo指定的目前各鼠标坐标是相对于窗口的坐标,Button指示了哪个键被按下或松开。SDG Toolkit是.Net兼容且是利用事件触发的传统Windows方式来识别输入的,事件的信息主要被封装在SdgMouseEventArgs类中。每个事件触发时，事件处理函数的参数都是一个SdgMouseEventArgs类变量。其中SdgMouseAttached事件在有新鼠标接入时触发，SdgMouseMove事件在有鼠标移动时触发，SdgMouseDown事件在有鼠标按键按下时触发，SdgMouseUp事件在有鼠标键松开时触发，SdgMouseWheel事件在鼠标中间滚轮移动时触发。SdgMouseEventArgs类中的ID属性用来识别不同的鼠标，Button属性用来识别鼠标按下的是哪个键，Delta属性用来识别鼠标中间滚轮移动的距离，X,Y属性表示的是事件触发时鼠标所在的坐标。

3.4.1 Single Display Groupware Toolkit各鼠标输入数据的识别原理

SDG Toolkit中具体的各鼠标输入识别是通过在程序回调函数中响应WM_INPUT消息，并利用GetRawInputData函数实现。在回调函数中，首先，SDG Toolkit响应了WM_CREATE消息，初始化了两个RAWINPUTDEVICE结构，并且调用了RegisterRawInputDevices函数对RawInput设备进行注册，为后来调用GetRawInputData函数做准备。在最新版本2.0.1.0中，源代码如下：

```csharp
switch((Win32.WindowMessage) m.Msg)
{
       case Win32.WindowMessage.WM_CREATE:
       {
              Win32.RAWINPUTDEVICE[] rid = new Win32.RAWINPUTDEVICE[2];
              rid[0].usUsagePage = 1;
              rid[0].usUsage = 2;
              rid[0].dwFlags = 0;
              rid[0].hwndTarget = m.HWnd;
              rid[1].usUsagePage = 1;
              rid[1].usUsage = 6;
              rid[1].dwFlags = 0;
              rid[1].hwndTarget = m.HWnd;
              bool fResult = Win32.RegisterRawInputDevices(rid,2,Marshal.SizeOf(rid[0]));
              Debug.Assert(fResult == true, "Failed to Register Raw Input Devices");
       }     
       break;
}
```

在WM_CREATE的响应程序中，为GetRawInputData调用所做的准备工作与在介绍利用RawInput实现多鼠标输入时所讲的一样，即先注册RawInput设备。只不过SDG Toolkit将初始化放在了响应WM_CREATE时进行，另外，SDG Toolkit在文件Win32.cs中对各Windows API函数进行了包装，将其都放在了Win32名字空间下，意义和流程与原来的完全一样。

注册RawInput设备后，再响应WM_INPUT消息，调用GetRawInputData函数，实现不同鼠标输入数据的识别。首先看各鼠标坐标的识别，源代码如下：

```csharp
switch((Win32.WindowMessage) m.Msg)
{
       case Win32.WindowMessage.WM_INPUT:
       {
              Win32.RAWINPUT ri = new Win32.RAWINPUT();
              int cbri = Marshal.SizeOf(ri);
              Win32.GetRawInputData((Win32.RAWINPUT*) ((void*) m.LParam), (int) Win32.GetRawInputDataCommand.RID_INPUT, ref ri, ref cbri, Marshal.SizeOf(ri.header));
              if (ri.header.dwType == (int) Win32.RawInputDeviceType.RIM_TYPEMOUSE)
              {
                     bool foundMouse = false;
                     for (int i = 0; i < mice.Count; ++i)
                     {
                            if (new IntPtr(ri.header.hDevice) == mice[i].impl.m_hDevice) 
                            {
                                   ArrayList a = (ArrayList) m_RawInputList[i];
                                   if (a.Count < m_RawInputListSize && 0 == ri.mouse.mouseUnion.usButtonData && 0 == ri.mouse.mouseUnion.usButtonFlags)
                                   {
                                          a.Add(ri);
                                   }
                                   else
                                   {
                                          m_MoveEventCount++;
                                          for (int j=0; j< a.Count; j++)
                                          {
                                                 Win32.RAWINPUT ri2 = (Win32.RAWINPUT) a[j];
                                                 ri.mouse.lLastX += ri2.mouse.lLastX;
                                                 ri.mouse.lLastY += ri2.mouse.lLastY;
                                          }
                                   }
                            }
                     }
              }
       }
}
```

同样的，这里除了SDK Toolkit对Windows API进行了一些包装外，与在介绍利用RawInput实现多鼠标输入时所讲的调用方法也基本一样，也是首先调用GetRawInputData获得输入数据，并通过dwType == RIM_TYPEMOUSE的比较识别是否为鼠标输入。最大的不同就是因为SDK Toolkit是利用事件触发来让用户使用数据，所以每次各鼠标坐标改变以后，SDK Toolkit都触发了一次SdgMouseMove事件，以让用户处理刚刚得到的数据。事件触发方式如下：

```csharp
SdgMouseEventArgs smeaAllButtons;
object mySender = this;
OnSdgMouseMove(mySender, smeaAllButtons);
mice[i].OnMouseMove(smeaAllButtons);
```

即首先定义了一个事件参数变量来表示鼠标按键，在SdgMouseMove事件中，都默认为无按键，然后调用SDG Toolkit内部的OnSdgMouseMove，函数首先处理事件的参数，然后完成实际的事件触发，然后利用Mice各成员函数改变储存的各鼠标状态的数据，以保存下刚获取的数据。这一点在鼠标按键的事件触发上也类似。

对于鼠标按键的识别，SDG Toolkit处理的非常简单，源代码如下：

```csharp
switch (ri.mouse.mouseUnion.usButtonData)
{
       case (int) Win32.RI_MOUSE.RI_MOUSE_LEFT_BUTTON_UP:
       case (int) Win32.RI_MOUSE.RI_MOUSE_MIDDLE_BUTTON_UP:
       case (int) Win32.RI_MOUSE.RI_MOUSE_RIGHT_BUTTON_UP:
       case (int) Win32.RI_MOUSE.RI_MOUSE_BUTTON_4_UP:
       case (int) Win32.RI_MOUSE.RI_MOUSE_BUTTON_5_UP:  
              OnSdgMouseUp(mySender, smea);
              fMouseUp = true;
              mice[i].OnMouseUp(smea);
              mice[i].setButtonState(SmeaToState(ri.mouse.mouseUnion.usButtonData), false);
              break;
       case (int) Win32.RI_MOUSE.RI_MOUSE_LEFT_BUTTON_DOWN:
       case (int) Win32.RI_MOUSE.RI_MOUSE_MIDDLE_BUTTON_DOWN:
       case (int) Win32.RI_MOUSE.RI_MOUSE_RIGHT_BUTTON_DOWN:
       case (int) Win32.RI_MOUSE.RI_MOUSE_BUTTON_4_DOWN:
       case (int) Win32.RI_MOUSE.RI_MOUSE_BUTTON_5_DOWN: 
              OnSdgMouseDown(mySender, smea);
              mice[i].OnMouseDown(smea);
              mice[i].setButtonState(SmeaToState(ri.mouse.mouseUnion.usButtonData), true);
              fMouseDown = true;
              break;
}
```

在SDG Toolkit中，调用GetRawInputData函数，并处理完鼠标的移动事件后，直接检测RawInput结构mouse.usButtonData的内容，发现有按键按下或松开，直接用相应的事件触发程序触发事件，然后用Mouse类的setButtonState函数来改变储存的各鼠标目前的数据，以保存目前的状态。这里有两个bool类型的成员变量fMouseUp 和fMouseDown ，原来它们都初始化为false，当鼠标有键按下后将fMouseDown 设为true，以表示有鼠标键按下，当鼠标键松开时将fMouseUp 设为true，以表示有鼠标键松开。 综上所述，SDG Toolkit各鼠标输入数据的识别原理利用的就是第2章所介绍的RawInput技术，仅仅是经过了一层包装，并将其带入了C#中，但是SDG Toolkit对数据的处理很有技术性，它自创了一套的带ID的事件系统，彻底解决了时分控制系统鼠标指针所带来的副作用，使得各鼠标的操作完全的不冲突，这也是这个技术最大的优点所在。

3.4.2 Single Display Groupware Toolkit多鼠标指针绘制原理

在SDG Toolkit中，所有鼠标的信息都保存在Mouse类集合变量Mice中，Mices中每个成员都代表着一个鼠标对象，虽然Mices内每个数据状态的改变都由SdgManager控制，但由图3.3可以看到实际指针的绘制都由各Mice变量自己独立控制，也就是说，Mouse类内部在每次鼠标状态改变时，都进行了相应的内部处理。其中，最主要的就是在鼠标坐标改变时完成鼠标指针的绘制。

要很好的绘制多个鼠标指针并且不损失程序的效率很难做到，前面介绍过一种绘制方法，每次鼠标的绘制都需要刷新程序，实际上大大的降低了程序的效率。在这里SDG Toolkit很有技巧性的完成了鼠标绘制工作，它为每个鼠标创建一个合适大小的顶层的透明窗口，并在此窗口中绘制出鼠标指针，每次移动鼠标的时候，SDG Toolkit实际移动的是这个透明的窗口，这样，每次鼠标移动的时候刷新的也就是这个很小的透明窗口而已，将对原有程序的影响降到可以接受的范围。具体做法是在每个Mouse类中定义了一个从Form继承过来的internal 类MouseImpl ，将其初始化为没有菜单，没有工具栏，没有边框，透明背景的窗口，并且此窗口的大小仅仅是正好可以绘制出一个鼠标指针。源代码如下：

```csharp
public class Mouse
{
       internal class MouseImpl : Form
       {
              public void InitializeMouse()
              {
                     BackColor = Color.AliceBlue;
                     TransparencyKey = Color.AliceBlue;
                     ForeColor = Color.Black;
                     Cursor = null;
                     TopMost = true;
                     Capture = false;
                     FormBorderStyle = FormBorderStyle.None;
                     ShowInTaskbar = false;
                     m_Cursor = Cursors.Arrow;
                     Size = m_Cursor.Size;
                     Show();
                     Location = m_Location;
                     ResizeWindow();
                     Refresh();
                     Enabled = false;
                     m_BoundsTimer = new System.Threading.Timer (new System.Threading.TimerCallback (BoundsTimer_Tick), null, 0, 500);
              }
       }
}
```

在以上源代码中，Location为窗口最后绘制的绘制位置，这个位置由Mouse类的成员变量m_Location决定，其实，这个M_Location就是鼠标指针应该在的点，通过这种定位窗口的方式来达到定位鼠标指针的效果。因此，利用此方法，每次鼠标指针的移动，只需要将窗口的Location属性值等于鼠标实际所在的位置m_Location值，然后刷新此窗口就可以完成了。在上面的代码中，ResizeWindow()函数是用来调整窗口大小，以适应鼠标指针大小或形状的改变，当鼠标指针属性发生改变时，也只需要调用此ResizeWindow()函数并刷新窗口就可以完成鼠标指针的改变过程。总之，每次此窗口的刷新，就完成了一次鼠标指针的绘制。而最后，SDK Toolkit利用一个500毫秒的定时器让程序每500毫秒检验窗口坐标是否超出边界，这样的安排纯粹是为了安全起见，因为每次鼠标坐标的更改其实都已经检查了边界，详细情况如下。

如下源代码演示了当鼠标指针坐标改变时，绘制鼠标指针的过程。

```csharp
public int X
{
       get
       {
              return m_Location.X;                            
       }
       set
       {
              if (CheckBounds(value, m_Location.Y)) 
              {
                     m_Location.X = value;
                     if (m_fVisible)
                     {
                            Location = m_Location;
                            Refresh();
                     }
              }
       }
}

public int Y
{
       get
       {
              return m_Location.Y;
       }
       set
       {
              if (CheckBounds(m_Location.X, value)) 
              {
                     m_Location.Y = value;
                     if (m_fVisible)
                     {
                            Location = m_Location;
                            Refresh();
                     }
              }
       }
}
```

在这里，除了定位并刷新绘制鼠标的窗口外，还做了两件事，就是用CheckBounds函数检查此窗口有没有超出边界，另外就是检查此鼠标指针是否允许显示。

综上所述，SDG Toolkit的多鼠标指针绘制原理非常有技巧性，利用子窗口绘制代替鼠标指针绘制的想法非常巧妙，利用这种技术，节省了每次鼠标指针移动时全屏幕刷新的需要，让鼠标指针的绘制更加有效率。因为我对C#代码的理解有限，假如有什么错误请指正，谢谢。
