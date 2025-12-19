---
layout: post
title: Windows中多指针输入技术的实现与应用(4多鼠标输入的底层实现)
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
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

探讨Windows多鼠标输入的两种底层技术：功能强大但复杂的过滤式驱动，以及更实用的RawInput API。文章重点详解了RawInput的实现原理与多指针绘制方法。

<!-- more -->

Windows中多指针输入技术的实现与应用(4多鼠标输入的底层实现)

湖南大学 谢祁衡

2 多鼠标输入的底层实现

2.1 通过开发过滤式鼠标驱动的实现

此技术最先由M.Westergaard在[9]中提出，此技术主要思路为从驱动程序层面解决Windows本身不能识别多个指针设备的问题。通过设计单独的一套鼠标驱动程序和 API完成硬件与用户层应用程序的通信。主要的技术可以用图2.1来描述。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/翻译示意1.JPG)

****

注：图左边为过滤式鼠标驱动程序的工作方式，右边为通常程序的运行方式，它们可以共存。

图2.1 过滤式鼠标驱动实现原理图[9]

 

此驱动程序是通过过滤鼠标的输入，所有的鼠标输入信息都在通过此驱动程序的时候加入 ID信息，使得系统辨识不同鼠标，就像从各种不同的独立的驱动程序中接收数据一样。低层API主管在各驱动程序之间的通信和处理上一个层面的反馈。高层的API允许用户层的应用程序在一个有效的途径上接受鼠标的输入。

这个技术解决了支持多鼠标输入的原理问题，最主要的优点是开发人员拥有对鼠标输入最完全的控制，也可以进行最彻底的优化，不受他人开发程序效率的限制。并且当低层系统有改变，比如当Windows决定从低层开始支持多鼠标输入的时候，上层的软件可以几乎不改变就正常使用。但是缺点也很明显，进行核心编程和驱动程序的开发都太过于复杂且难以控制。另外，虽然对于鼠标有着较为通用的驱动程序，但是对于不同的指针设备还必须提供不同的驱动程序，所以对于新的指针设备的识别也将会成为难点，使得此技术仅仅只能被框架级程序的专业开发所利用，比如Octopus framework和CPNmouse，[9]而且仅仅对于鼠标等有限的设备有着很好的支持。

 

**2.2** 用户层利用RawInput的实现

微软在Windows XP中在RawInput API中加入了鼠标的ID信息数据，因此，使得在Windows XP中通过直接分辨RawInput API中的鼠标ID信息非常方便地来识别不同的鼠标输入。

虽然能够识别不同数据，但是对于不同鼠标指针的绘制完全要由编程人员控制。此技术有着对鼠标输入比较完全的控制，识别不同鼠标输入的数据较为容易，且仅仅通过微软的底层程序，因此效率很高。而且对于新加入的指针设备能有较快的反应，可以不考虑驱动程序就对新的指针设备提供直接支持。值得一提的是，微软对于RawInput提供了文档支持，且网上实现此技术的相关资料较为丰富，这点对于开发工作来说，必不可少。缺点是用户层上的开发工作并不是很容易，特别是很好的多鼠标输入数据处理方式和多鼠标指针的绘制技术比较难以掌握，而利用较为容易实现的时分方式会带来一些副作用，比如当多个虚拟指针同时拖动窗口的时候，将导致未定义的行为。[5] 而且，此技术只能在Windows 2000/XP中运用，Windows 9x 下已确认无法使用。但是因为此方法的优点明显，缺点却难以用其他方法弥补，使得很多各层次的程序都是利用此技术完成，比如SDG Toolkit**，** MAME:Analog+，以及Reflexive Entertainment, Inc的大部分符合Mouse-Party的游戏。

 

2.3 RawInput实现的原理

在此节，分各鼠标输入数据的识别和各鼠标独立指针的绘制两方面详细介绍了RawInput实现的原理。

2.3.1 RawInput各鼠标输入数据的识别原理

虽然Windows并不直接支持多指针输入设备，但是通过原始的输入数据识别还是可以分辨不同的鼠标输入，在Windows XP中提供原始输入数据处理的方法是通过注册使用RawInput设备以获得RAWINPUT结构类型数据的方式。具体流程图如下：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/RawInput各鼠标输入数据识别流程图.JPG)

开始
---
用
---
GetRawInputDeviceList
---
函数获取
---
RawInput
---
设备数量
---
用
---
RegisterRawInputDevices
---
函数注册
---
RawInput
---
设备
---
调用
---
GetRawInputData
---
函数
---
获得
---
_pData_
---
_大小_
---
调用
---
GetRawInputData
---
函数
---
获得
---
RAWINPUT
---
数据
---
header.dwType
---
== 
---
RIM_TYPEMOUSE
---
保存
---
RawInput
---
中的
---
data.mouse
---
数据
---
检查
---
data.mouse
---
数
---
据中的坐标边界
---
重新以新坐标
---
定位鼠标指针
---
结束
---
T
---
F
---
第一步
---
第二步
---
第三步
---
第四步
---
第五步
---

                                                                 图2.2 RawInput各鼠标输入数据识别流程图

 

第一步，用GetRawInputDeviceList函数获取RawInput设备数量。GetRawInputDeviceList的函数原型如下：

```
UINT GetRawInputDeviceList(
    PRAWINPUTDEVICELIST pRawInputDeviceList,
    PUINT puiNumDevices,
    UINT cbSize
);
```

当第一参数为NULL的时候，第二参数为输出，输出的是RawInput设备数量。第三参数一般为RAWINPUTDEVICELIST的大小。所以可以以下方式调用以获得RawInput设备数量。

```
UINT nDevices;
GetRawInputDeviceList(NULL, &nDevices, sizeof(RAWINPUTDEVICELIST)) 
```

调用以后，nDevices就是RawInput设备的数量。但是假如需要确定的鼠标RawInput设备数量，就还需要再一次以第一参数为输出调用GetRawInputDeviceList函数，这里首先需要了解RAWINPUTDEVICELIST结构。RAWINPUTDEVICELIST结构定义如下：

```
typedef struct tagRAWINPUTDEVICELIST {
    HANDLE hDevice;
    DWORD dwType;
} RAWINPUTDEVICELIST, *PRAWINPUTDEVICELIST;
```

当在第二参数中给定RawInput设备的数量为输入时，第一参数就可以输出RAWINPUTDEVICELIST结构类型的输出。调用方式如下：

```
PRAWINPUTDEVICELIST pRawInputDeviceList;
pRawInputDeviceList = (RAWINPUTDEVICELIST *) calloc( nDevices,                           sizeof(RAWINPUTDEVICELIST));
GetRawInputDeviceList(pRawInputDeviceList,&nDevices,               sizeof(RAWINPUTDEVICELIST));
```

这里的nDevices必须已经经过上一步的GetRawInputDeviceList调用，值已经是RawInput设备的数量。这时可以通过判断pRawInputDeviceList各成员的dwType值是否等于 RIM_TYPEMOUSE来判断此RawInput设备是否为鼠标的输入。

第二步：用RegisterRawInputDevices函数注册RawInput设备。这一步最需要注意，在Windows中一般情况下并不会让用户获取原始输入数据RawInput，所以使用GetRawInputData函数前必须先注册RawInput设备。注册RawInput的步骤就是通过调用RegisterRawInputDevices函数完成的。RegisterRawInputDevices函数原型如下：

```
BOOL RegisterRawInputDevices(
       PCRAWINPUTDEVICE pRawInputDevices,
       UINT uiNumDevices,
       UINT cbSize
);
```

第一参数为一个RAWINPUTDEVICE结构的指针，第二参数给定需要注册RawInput设备的数量，第三参数为第一参数的大小。在这里要知道怎么注册又需要先了解RAWINPUTDEVICE结构，其结构定义如下：

```
typedef struct tagRAWINPUTDEVICE {
    USHORT usUsagePage;
    USHORT usUsage;
    DWORD dwFlags;
    HWND hwndTarget;
} RAWINPUTDEVICE, *PRAWINPUTDEVICE, *LPRAWINPUTDEVICE;
```

当dwFlags设为NULL时，Windows追随输入焦点接受RawInput数据。而第四参数就是指定的输入焦点，假如第四参数为NULL，那么Windows接受RawInput数据的窗口就是目前的键盘焦点窗口。这两个参数设定就是一般时所需要的，比如以下的方式就注册了一个RawInput设备,并且当注册失败时弹出对话框提示：

```
RAWINPUTDEVICE Raw[1];
Rid[0].usUsagePage = 0x01; 
Rid[0].usUsage = 0x02; 
Rid[0].dwFlags = 0;
Rid[0].hwndTarget = NULL;
if (RegisterRawInputDevices(Rid, 1, sizeof (Rid [0])) == FALSE) {
       MessageBox(hWnd,"RawInput Register Error.","RawInput init failed!",MB_OK);
}
```

这里需要注意的是并不是有多少个鼠标输入就需要注册多少个RawInput设备，一般来说，注册一个RawInput设备处理目前焦点的原始输入数据就足够了，同样可以获得所有的鼠标原始输入数据。除非想对不同焦点的原始输入数据进行处理，才需要注册多个usUsagePage 与usUsage 不同的RawInput设备。

第三步：调用GetRawInputData函数获得pData大小。这里要说明的是GetRawInputData一般要在响应WM_INPUT消息时调用，不能随时调用。GetRawInputData函数原型如下：

```
UINT GetRawInputData(
    HRAWINPUT hRawInput,
    UINT uiCommand,
    LPVOID pData,
    PUINT pcbSize,
    UINT cbSizeHeader
);
```

GetRawInputData第一参数为一个RAWINPUT结构的句柄，来自WM_INPUT消息的lParam 参数。要说明的是GetRawInputData并不是一个随时调用以检测有无RawInput设备输入的函数，实际上是一个对WM_INPUT消息的lParam 参数的解析函数，主要用途是从WM_INPUT消息的lParam 参数中提取出有用的信息，并加以组织成一个RAWINPUT结构输出，当然，由于WM_INPUT消息的lParam 参数传进来的是个句柄，实际上解析的是其代表的RAWINPUT结构数据。这也是GetRawInputData一般在响应WM_INPUT消息时调用的原因。第二参数为RID_INPUT时，GetRawInputData才输出RawInput信息。第三参数用以输出最后的RAWINPUT结构数据，当为NULL时在第四参数输出本参数大小。第四参数用以制定第三参数大小，第五个参数在只需要调用RAWINPUT结构输出的时候一般可以设为sizeof(RAWINPUTHEADER)。因为我们一开始不知道GetRawInputData第三参数的大小，必须以NULL为第三参数先调用一次GetRawInputData以从第四参数获得第三参数pData大小。调用方式如下：

```
UINT dwSize;
case WM_INPUT: 
{
       GetRawInputData((HRAWINPUT)lParam, RID_INPUT, NULL, &dwSize, 
                                                 sizeof(RAWINPUTHEADER));
...
```

这样调用GetRawInputData函数后，dwSize就指示了其第三参数pData的大小。为下一次调用以输出RAWINPUT数据做准备。

第四步：调用GetRawInputData函数获得RAWINPUT数据。在获得GetRawInputData第三参数pData大小后就可以直接调用GetRawInputData获得RAWINPUT数据了。这里要说明的是第三参数为一个空指针，调用前先用刚才得到的dwSize参数分配足够的空间，并且调用完后必须强制转换才能得到想要的结果。实际调用源代码如下：

```
LPVOID lpb;
RAWINPUT *raw;
case WM_INPUT: 
{
...
lpb = malloc(sizeof(LPVOID) * dwSize);
if (lpb == NULL) 
{
       return 0;
} 
GetRawInputData((HRAWINPUT)lParam, RID_INPUT, lpb, &dwSize, 
                             sizeof(RAWINPUTHEADER));
raw = (RAWINPUT*)lpb;
}
```

第五步：这里我们已经可以通过调用以上四步得到的RAWINPUT数据来获得想要的数据了，这里以指针raw表示，首先看RAWINPUT结构的定义：

```
typedef struct tagRAWINPUT { 
    RAWINPUTHEADER    header; 
    union {
             RAWMOUSE    mouse; 
             RAWKEYBOARD keyboard; 
             RAWHID      hid; 
            } data;
} RAWINPUT, *PRAWINPUT; *LPRAWINPUT;
```

首先我们可以通过检测header是否等于RIM_TYPEMOUSE，了解是否这次RAWINPUT输入得到的是否是鼠标输入数据，只有等于时想要读取的是RAWINPUT结构才是鼠标的输入数据。这时我们才可以通过读取RAWMOUSE结构数据获得鼠标的具体输入信息,RAWMOUSE结构又很复杂，其本身又是RAWINPUT结构中定义的一个名为data的联合。首先看RAWMOUSE结构的定义：

```
typedef struct tagRAWMOUSE { 
  USHORT    usFlags; 
  union {
         ULONG    ulButtons;
             struct {
                       USHORT usButtonFlags;
                       USHORT usButtonData;
                       };
  };
  ULONG ulRawButtons;
  LONG  lLastX;
  LONG  lLastY;
  ULONG ulExtraInformation;
} RAWMOUSE, *PRAWMOUSE, *LPRAWMOUSE;
```

其中主要用到的是以下几个数据，usFlags是用来指定鼠标状态的，usButtonFlags指示了按键状况，只需要通过与以下值的对比就可以知道有哪些按键按下与松开：

- RI_MOUSE_LEFT_BUTTON_DOWN  左键按下
- RI_MOUSE_LEFT_BUTTON_UP 左键松开
- RI_MOUSE_MIDDLE_BUTTON_DOWN 中键按下
- RI_MOUSE_MIDDLE_BUTTON_UP 中键松开
- RI_MOUSE_RIGHT_BUTTON_DOWN 右键按下
- RI_MOUSE_RIGHT_BUTTON_UP 右键松开

lLastX，lLastY指示了鼠标的移动，其值的含义由usFlags决定，当usFlags等于MOUSE_MOVE_RELATIVE时，lLastX，lLastY值表示鼠标相对于上一点的移动，当usFlags等于MOUSE_MOVE_ABSOLUTE时，lLastX，lLast的值表示鼠标的绝对移动，大概含义等于相对于某固定点的移动。要注意的是，无论是那种方式，lLastX，lLast都指示的是一个相对移动的数据，以屏幕坐标轴来看，当向上移动lLastX为负，向下移动lLastX为正，向左移动lLastY为负，向右移动lLastY为正，其值大小表示的是偏差。实际要获得鼠标的绝对坐标还需要经过一定处理，代码如下：

```
long X;
long Y;
if (raw->header.dwType == RIM_TYPEMOUSE)
{
       raw->data.mouse.usFlags = MOUSE_MOVE_ABSOLUTE;
    X += raw->data.mouse.lLastX;
    Y += raw->data.mouse.lLastY;
}
```

通过这样的调用，X,Y才是想要的鼠标坐标。另外，得到坐标后应该做边界检查，以鼠标指针在屏幕边界后X,Y超出有意义的坐标值或为负值。而且，在大部分情况下，当高速移动鼠标时，系统的消息处理会跟不上鼠标的移动，在处理完坐标后应该以此坐标重定位鼠标指针，以防消息丢失导致的实际坐标与指针的不一致。

在以下的程序中，详细演示了利用RawInput获得各鼠标输入数据并加以处理显示在屏幕上的过程。

RawInput各鼠标输入数据识别测试程序具体代码（以下代码在Visual studio .NET 2005 上编译通过）
```cpp
#include "stdafx.h"
#include <stdlib.h>
#include <string.h>

#define _WIN32_WINNT 0x0501   //定义此程序为Windows XP程序
#include <windows.h>

char mousemessage[256];          // 第一个字符串缓存主要储存原始设备输入信息
char mousemessage2[256]; // 第二个字符串缓存储存经过分析处理的输入信息
char rawinputdevices[256]; // 输入设备数量的字符串缓存
long X;   //鼠标的X坐标值
long Y;   //鼠标的Y坐标值

char mousemessage[256];          // 第一个字符串缓存主要储存原始设备输入信息
char mousemessage2[256]; // 第二个字符串缓存储存经过分析处理的输入信息
char rawinputdevices[256]; // 输入设备数量的字符串缓存
long X;   //鼠标的X坐标值
long Y;   //鼠标的Y坐标值

//RawInput初始化函数
void InitRawInput(HWND hwnd) 
{
       RAWINPUTDEVICE Rid[1]; //分配RawInput设备的空间

       UINT nDevices;          //输入设备的数量
       //获得输入设备的数量
       GetRawInputDeviceList(NULL, &nDevices, sizeof(RAWINPUTDEVICELIST)); 
       PRAWINPUTDEVICELIST pRawInputDeviceList;// = new RAWINPUTDEVICELIST[nDevices];
       pRawInputDeviceList=(RAWINPUTDEVICELIST *)calloc(nDevices, sizeof(RAWINPUTDEVICELIST));
       GetRawInputDeviceList(pRawInputDeviceList, &nDevices, sizeof(RAWINPUTDEVICELIST));
       int nMouseNumber = 0;
       for(int i=0; i < nDevices; ++i)
       {
              if(pRawInputDeviceList[i].dwType == RIM_TYPEMOUSE)
              {
                     ++nMouseNumber;    
              }
       }

       //将输入设备数量写入rawinputdevices缓存
       wsprintf(rawinputdevices,"Number of raw input devices: %i/n"
              "Number of raw input mouse: %i/n", nDevices,nMouseNumber);
       free(pRawInputDeviceList);
       //初始化第1个RawInput设备
       Rid[0].usUsagePage = 0x01; 
       Rid[0].usUsage = 0x02; 
       Rid[0].dwFlags = 0;
       Rid[0].hwndTarget = NULL;

       //注册RawInput设备
       if (RegisterRawInputDevices(Rid, 1, sizeof (Rid [0])) == FALSE) {
              MessageBox(hwnd,"RawInput Register Error.","RawInput init failed!",MB_OK);
       }
       //初始化X,Y坐标信息
       POINT pt;
       GetCursorPos(&pt);
       X = pt.x;
       Y = pt.y;
       return ;
}

//检查边界的函数
void CheckBound(HDC hdc,long &x,long &y)
{
       if(x<0)
              x = 0;
       if(y<0)
              y = 0;
       //最大值由GetDeviceCaps函数获取以适应不同系统设置
       if(x>(long)GetDeviceCaps(hdc,HORZRES))
              x = (long)GetDeviceCaps(hdc,HORZRES);
       if(y>(long)GetDeviceCaps(hdc,VERTRES))
              y = (long)GetDeviceCaps(hdc,VERTRES);
}

//定义回调函数
LRESULT CALLBACK
MainWndProc (HWND hwnd, UINT nMsg, WPARAM wParam, LPARAM lParam)
{
       static HWND   hwndButton = 0;
    HDC           hdc;            
    PAINTSTRUCT   ps;
    RECT          rc;            
       LPVOID lpb;
       UINT dwSize;
       RAWINPUT *raw;

    switch (nMsg)
    {
              case WM_DESTROY:
                     PostQuitMessage (0);
                     return 0;
                     break;
             
              //响应WM_PAINT消息以绘制窗口，输出信息
              case WM_PAINT:
                     hdc = BeginPaint(hwnd, &ps);

                     //输出信息
                     GetClientRect(hwnd, &rc);
                     DrawText(hdc, mousemessage, strlen(mousemessage), &rc, DT_CENTER);
                     OffsetRect(&rc,0,150); 
                     DrawText(hdc, rawinputdevices, strlen(rawinputdevices), &rc, DT_CENTER);
                     OffsetRect(&rc,0,40);
                     DrawText(hdc, mousemessage2, strlen(mousemessage2), &rc, DT_CENTER);
                     EndPaint(hwnd, &ps);
           return 0;
           break;

              //响应WM_INPUT消息为本程序的主要部分
              case WM_INPUT: 
              {
                     GetRawInputData((HRAWINPUT)lParam, RID_INPUT, NULL, &dwSize, 
                                                 sizeof(RAWINPUTHEADER));
                     lpb = malloc(sizeof(LPVOID) * dwSize);
                     if (lpb == NULL) 
                     {
                            return 0;
                     } 
                     GetRawInputData((HRAWINPUT)lParam, RID_INPUT, lpb, &dwSize, 
                             sizeof(RAWINPUTHEADER));
                     raw = (RAWINPUT*)lpb;
                     if (raw->header.dwType == RIM_TYPEMOUSE) //判断是否为鼠标信息
                     {
                            //将鼠标的输入信息写入缓存mousemessage
                            wsprintf(mousemessage,"Mouse:hDevice %d /n usFlags=%04x /nulButtons=%04x /nusButtonFlags=%04x /nusButtonData=%04x /nulRawButtons=%04x /nlLastX=%ld /nlLastY=%ld /nulExtraInformation=%04x/n",                             
                                   raw->header.hDevice,
                                   raw->data.mouse.usFlags, 
                                   raw->data.mouse.ulButtons, 
                                   raw->data.mouse.usButtonFlags, 
                                   raw->data.mouse.usButtonData, 
                                   raw->data.mouse.ulRawButtons, 
                                   raw->data.mouse.lLastX, 
                                   raw->data.mouse.lLastY, 
                                   raw->data.mouse.ulExtraInformation);
                           
                            //解析RAWMOUSE数据
                            raw->data.mouse.usFlags = MOUSE_MOVE_ABSOLUTE;
                         X += raw->data.mouse.lLastX;
                         Y += raw->data.mouse.lLastY;
                           
                            //检查边界，以防坐标为负或超过屏幕容许最大值
                            hdc = BeginPaint(hwnd, &ps);
                            CheckBound(hdc,X,Y);
                            EndPaint(hwnd, &ps);
                            //重新以坐标定位鼠标指针，以防系统忙导致的消息丢失
                            ::SetCursorPos(X,Y);
                           
                            wsprintf(mousemessage2,"X: %ld,Y: %ld/n",X,Y);

                            switch(raw->data.mouse.usButtonFlags)
                            {
                            case RI_MOUSE_LEFT_BUTTON_DOWN:
                                   strcat(mousemessage2,"Left button down/n");
                                   break;
                            case RI_MOUSE_LEFT_BUTTON_UP:
                                   strcat(mousemessage2,"Left button up/n");
                                   break;
                            case RI_MOUSE_MIDDLE_BUTTON_DOWN:
                                   strcat(mousemessage2,"Middle button down/n");
                                   break;
                            case RI_MOUSE_MIDDLE_BUTTON_UP:
                                   strcat(mousemessage2,"Middle button up/n");
                                   break;
                            case RI_MOUSE_RIGHT_BUTTON_DOWN:
                                   strcat(mousemessage2,"Right button down/n");
                                   break;
                            case RI_MOUSE_RIGHT_BUTTON_UP:
                                   strcat(mousemessage2,"Right button up/n");
                                   break;
                            }
                     } 
                     //重绘窗口以输入数据
                     InvalidateRect(hwnd,0,TRUE);
                     SendMessage(hwnd,WM_PAINT,0,0);
                     free(lpb);  
                     return 0;
              } 
    }
        return DefWindowProc (hwnd, nMsg, wParam, lParam);
}

int APIENTRY 
WinMain (HINSTANCE hInst, HINSTANCE hPrev, LPSTR lpCmd, int nShow)
{
        HWND         hwndMain;       
        MSG          msg;            
        WNDCLASSEX   wndclass;      
        char*        szMainWndClass = "szRawInputTest";
                                    
        memset (&wndclass, 0, sizeof(WNDCLASSEX));
        wndclass.lpszClassName = szMainWndClass;
        wndclass.cbSize = sizeof(WNDCLASSEX);
        wndclass.style = CS_HREDRAW | CS_VREDRAW;
        wndclass.lpfnWndProc = MainWndProc;
        wndclass.hInstance = hInst;
        wndclass.hIcon = LoadIcon (NULL, IDI_APPLICATION);
        wndclass.hIconSm = LoadIcon (NULL, IDI_APPLICATION);
        wndclass.hCursor = LoadCursor (NULL, IDC_ARROW);
       wndclass.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
        RegisterClassEx (&wndclass);
        hwndMain = CreateWindow (
                szMainWndClass,           
                "RawInputTest",           
                WS_OVERLAPPEDWINDOW,      
                CW_USEDEFAULT,            
                CW_USEDEFAULT,            
                CW_USEDEFAULT,            
                CW_USEDEFAULT,             
                NULL,                      
                NULL,                      
                hInst,                     
                NULL                       
                );
       
        ShowWindow (hwndMain, nShow);
        UpdateWindow (hwndMain);

               InitRawInput(hwndMain);

              //进入消息循环
        while (GetMessage (&msg, NULL, 0, 0))
        {
                TranslateMessage (&msg);
                DispatchMessage (&msg);
        }
        return msg.wParam;
}
```

程序实际运行效果如图2.3所示：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/RawInput各鼠标输入数据识别测试程序截图.JPG)

图2.3 RawInput各鼠标输入数据识别测试程序截图

其中不同鼠标的输入通过鼠标的hDevice不同来分辨，上面一部分是RAWINPUT结构的原始输入数据，下面一部分是解析过的数据。

 

2.3.2 RawInput多鼠标指针绘制原理

虽然在此节介绍的多鼠标指针绘制原理中，绘制多鼠标指针的输入数据来源于上节所讲的RawInput技术，但是实际上无论用那种方法获得数据，本节所讲的多鼠标绘制技术都有实际意义，本节所讲的实际是一种非常典型的分时多鼠标指针绘制技术。

首先，要绘制多个鼠标，首先要做到的就是保存下目前各鼠标的坐标状况。这里，可以用一个动态数组来完成，另外，要能识别此坐标到底是哪个鼠标的坐标，即应该给各鼠标加上一个ID号，并且这里可以用上节所讲的RAWINPUT结构中的header.hDevice来识别，因为代表各鼠标设备的句柄是唯一的。可以定义一个简单的struct来将两者组合在一起以方便调用。这里将其命名为SiRawMouse并声明一个它的指针，用来实际保存数据。实际代码如下：

```
struct SiRawMouse
{
       long X;
       long Y;
       HANDLE hDevice;
}*pSiRawMouse;
```

另外，在上一节中已经通过第一步获得系统中RawInput鼠标的数量了。可以根据这个数量决定动态数组的大小。各鼠标的hDevice在得到的各RAWINPUTDEVICELIST结构中就有保存。

这里需要注意的是，Windows中实际上接入的鼠标要将以上数量减1，因为它内置了一个虚拟的系统鼠标。在普通程序中，多个鼠标的操作都是移动同一个指针的效果就是通过这个虚拟的系统鼠标做到的。在这里，最重要的是分析出到底哪个鼠标是系统鼠标,这里提供的一种思路是通过鼠标的DeviceName来分辨，设备的DeviceName可以通过GetRawInputDeviceInfo函数得到。其函数原型如下：

```
UINT GetRawInputDeviceInfo( 
    HANDLE hDevice,
    UINT uiCommand,
    LPVOID pData,
    PUINT pcbSize
);
```

在这里又要通过两次调用才能得到想要的结果，第一次以第三参数为NULL获得第四参数的大小，然后以空指针获得想要的结构。并且要获得DeviceName第二参数要设为RIDI_DEVICENAME。得到DeviceName以后可以通过比较前22个字符来分辨此设备是否是系统鼠标，因为系统鼠标前22位一般是固定为"//??//Root#RDP_MOU#0000#",具体比较方式可以用以下函数完成:

```
bool isRootMouse(char cDeviceString[])
{
       char cRootString[] = "//??//Root#RDP_MOU#0000#";
       if (strlen(cDeviceString) < 22) 
       {
              return false;
       }
       for (int i = 0; i < 22; i++) 
       {
              if (cRootString[i] != cDeviceString[i]) 
              {
              return false;
              }
       }
       return true;
}
```

按以上所讲方式，完整的各鼠标坐标数据初始化代码如下：

```
       for(int i=0,j=1; i < nDevices && j < nMouseNumber; ++i)
       {
              if(pRawInputDeviceList[i].dwType == RIM_TYPEMOUSE)
              {
                     GetRawInputDeviceInfo(pRawInputDeviceList[i].hDevice,                                                                               RIDI_DEVICENAME, NULL, &dwSize);
                     lpb = malloc(sizeof(LPVOID) * dwSize);
                     GetRawInputDeviceInfo(pRawInputDeviceList[i].hDevice,                                                                               RIDI_DEVICENAME, lpb, &dwSize);
                     char *deviceName = (char*)lpb;
                     if(isRootMouse(deviceName))
                     {
                            pSiRawMouse[0].hDevice = pRawInputDeviceList[i].hDevice;
                            pSiRawMouse[0].X = 0;
                            pSiRawMouse[0].Y = 0;
                     }
                     else
                     {
                            pSiRawMouse[j].hDevice = pRawInputDeviceList[i].hDevice;
                            pSiRawMouse[j].X = 0;
                            pSiRawMouse[j].Y = 0;
                            ++j;
                     }
                     free(lpb);
              }
       }
```

通过以上方式初始化了保存鼠标坐标信息的动态数组以后，分别储存和处理不同hDevice的鼠标RawInput信息，具体方式如下：

```
if (raw->header.dwType == RIM_TYPEMOUSE) //判断是否为鼠标信息
{
       raw->data.mouse.usFlags = MOUSE_MOVE_ABSOLUTE;
       for(int i=1; i<nMouseNumber; ++i)
       {
              if(pSiRawMouse[i].hDevice == raw->header.hDevice)
              {
                     pSiRawMouse[i].X += raw->data.mouse.lLastX;
                     pSiRawMouse[i].Y += raw->data.mouse.lLastY;
                     hdc = GetDC(hwnd);
                     CheckBound(hdc,pSiRawMouse[i].X,pSiRawMouse[i].Y);
                     ReleaseDC(hwnd,hdc);
                     pSiRawMouse[0].X = pSiRawMouse[i].X;
                     pSiRawMouse[0].Y = pSiRawMouse[i].Y;
              }
              SetCursorPos(pSiRawMouse[0].X, pSiRawMouse[0].Y);
       }
} 
```

此处的raw为上节中所提到已经获取到鼠标原始输入信息的RAWINPUT结构数据。在这里，处理方式与上节中的不同是判断了鼠标输入信息的hDevice属性来分辨不同鼠标，并保存在各自的SiRawMouse结构中，在检查边界后再将其赋给系统鼠标，并利用此坐标定位系统鼠标指针。这样，就获得了各鼠标独立的，不同的坐标信息，为鼠标指针的绘制做了必要的工作。

下一步就是利用各鼠标的坐标分别绘制鼠标指针，这里用图标代替鼠标指针的方式简化了一些处理。首先要设置一个自定义的图标资源，此资源储存着要绘制鼠标的样式。然后利用DrawIcon函数调用各鼠标的坐标，达到绘制鼠标指针的类似效果。要注意的是，DrawIcon函数调用的坐标信息是程序窗口的相对坐标，而以上方式获得的坐标信息为屏幕坐标，需要经过ScreenToClient函数进行坐标的转换。并且为了每次坐标的改变都要能够看到，而且以前绘制的图标应该消失，此过程应放置在响应WM_PAINT消息的响应过程中，具体方式如下：

```
case WM_PAINT:
       hdc = BeginPaint(hwnd, &ps);
       for(int i=1; i<nMouseNumber; ++i)
       {
              POINT pt = { pSiRawMouse[i].X, pSiRawMouse[i].Y };
              ScreenToClient(hwnd,&pt);
              DrawIcon(hdc,pt.x,pt.y,hicon);
       }
       EndPaint(hwnd, &ps);
       return 0;
       break;
```
这样，每次响应WM_INPUT更改目前各鼠标的坐标状态后，都刷新一次程序，以调用WM_PAINT的响应过程，就可以完成各鼠标指针的绘制。全程序完整原代码如下所示：

RawInput多鼠标指针绘制演示程序具体代码（以下代码在Visual studio .NET 2005 上编译通过）
```cpp
#include "stdafx.h"
#include "rawinput2.h"
#include <stdlib.h>
#include <string.h>

#define _WIN32_WINNT 0x0501   //定义此程序为Windows XP程序
#include <windows.h>

char mousePostion[256];    //储存经过分析处理的各鼠标坐标信息
HICON  hicon; //绘制的鼠标
int nMouseNumber = 0; //鼠标数量

//定义一个自定义的类型，保存坐标和设备的句柄
struct SiRawMouse
{
       long X;
       long Y;
       HANDLE hDevice;
}*pSiRawMouse;        //输入设备鼠标的自定义类型数组

//判定是否为系统鼠标的函数
bool isRootMouse(char cDeviceString[])
{
       //一般系统鼠标DeviceName的前22字节
       char cRootString[] = "//??//Root#RDP_MOU#0000#";
      
       //通过比较前22个字节判断是否为系统鼠标
       if (strlen(cDeviceString) < 22) 
       {
              return false;
       }
       for (int i = 0; i < 22; i++) 
       {
              if (cRootString[i] != cDeviceString[i]) 
              {
              return false;
              }
       }
       return true;
}

//RawInput初始化函数
void InitRawInput(HWND hwnd) 
{

       UINT nDevices;          //输入设备的数量

       //第一次调用GetRawInputDeviceList获得输入设备的数量
       GetRawInputDeviceList(NULL, &nDevices, sizeof(RAWINPUTDEVICELIST));

       //第二次调用GetRawInputDeviceList获得RawInputDeviceList数组
       PRAWINPUTDEVICELIST pRawInputDeviceList;
       pRawInputDeviceList = (RAWINPUTDEVICELIST *)calloc(nDevices,sizeof(RAWINPUTDEVICELIST));
       GetRawInputDeviceList(pRawInputDeviceList, &nDevices, sizeof(RAWINPUTDEVICELIST));

       //获得输入设备中鼠标的数量
       for(int i=0; i < nDevices; ++i)
       {
              if(pRawInputDeviceList[i].dwType == RIM_TYPEMOUSE)
              {
                     ++nMouseNumber;    
              }
       }
      
       //获得输入设备鼠标的自定义类型数组，其中索引为0的为系统鼠标
       pSiRawMouse = (SiRawMouse *)calloc(nMouseNumber,sizeof(SiRawMouse));
       LPVOID lpb;
       UINT dwSize;

       for(int i=0,j=1; i < nDevices && j < nMouseNumber; ++i)
       {
              if(pRawInputDeviceList[i].dwType == RIM_TYPEMOUSE)
              {
                     //连续两次调用GetRawInputDeviceInfo以读取RIDI_DEVICENAME
                     //并通过此值判断是否为系统鼠标
                     GetRawInputDeviceInfo(pRawInputDeviceList[i].hDevice,RIDI_DEVICENAME,NULL,&dwSize);
                     lpb = malloc(sizeof(LPVOID) * dwSize);
                     GetRawInputDeviceInfo(pRawInputDeviceList[i].hDevice,RIDI_DEVICENAME,lpb,&dwSize);
                     char *deviceName = (char*)lpb;
                    
                     //将系统鼠标的保存在索引0中，其他依次列在后面
                     if(isRootMouse(deviceName))
                     {
                            pSiRawMouse[0].hDevice = pRawInputDeviceList[i].hDevice;
                            pSiRawMouse[0].X = 0;
                            pSiRawMouse[0].Y = 0;
                     }
                     else
                     {
                            pSiRawMouse[j].hDevice = pRawInputDeviceList[i].hDevice;
                            pSiRawMouse[j].X = 0;
                            pSiRawMouse[j].Y = 0;
                            ++j;
                     }
                     free(lpb);
              }
       }

       free(pRawInputDeviceList);
       pRawInputDeviceList = NULL;

       //初始化1个RawInput设备
       RAWINPUTDEVICE Rid[1]; //分配RawInput设备的空间
       Rid[0].usUsagePage = 0x01; 
       Rid[0].usUsage = 0x02; 
       Rid[0].dwFlags = 0;
       Rid[0].hwndTarget = NULL;

       //注册RawInput设备
       if (RegisterRawInputDevices(Rid, 1, sizeof (Rid [0])) == FALSE) {
              MessageBox(hwnd,"RawInput Register Error.","RawInput init failed!",MB_OK);
       }

       return ;
}

//检查边界的函数
void CheckBound(HDC hdc,long &x,long &y)
{
       if(x<0)
              x = 0;
       if(y<0)
              y = 0;
      
       //最大值由GetDeviceCaps函数获取以适应不同系统设置
       if(x>(long)GetDeviceCaps(hdc,HORZRES))
              x = (long)GetDeviceCaps(hdc,HORZRES);
       if(y>(long)GetDeviceCaps(hdc,VERTRES))
              y = (long)GetDeviceCaps(hdc,VERTRES);
}

//定义回调函数
LRESULT CALLBACK
MainWndProc (HWND hwnd, UINT nMsg, WPARAM wParam, LPARAM lParam)
{
       static HWND   hwndButton = 0;
    HDC           hdc;            
    PAINTSTRUCT   ps;
    RECT          rc;             
       LPVOID lpb;
       UINT dwSize;
       RAWINPUT *raw;

    switch (nMsg)
    {
              case WM_DESTROY:
                     free(pSiRawMouse);
                     DestroyIcon(hicon);
                     PostQuitMessage (0);
                     return 0;
                     break;
             
              //响应WM_PAINT消息以绘制窗口，输出信息
              case WM_PAINT:

                     hdc = BeginPaint(hwnd, &ps);

                     //输出信息
                     GetClientRect(hwnd, &rc);
                     OffsetRect(&rc,0,100);
                     DrawText(hdc, mousePostion, strlen(mousePostion), &rc, DT_CENTER);

                     for(int i=1; i<nMouseNumber; ++i)
                     {
                            POINT pt = { pSiRawMouse[i].X, pSiRawMouse[i].Y };
                            ScreenToClient(hwnd,&pt);
                            DrawIcon(hdc,pt.x,pt.y,hicon);
                     }
                    
                     EndPaint(hwnd, &ps);
            return 0;
            break;

              //响应WM_INPUT消息为本程序的主要部分
              case WM_INPUT: 
              {
                     GetRawInputData((HRAWINPUT)lParam, RID_INPUT, NULL, &dwSize, 
                                                 sizeof(RAWINPUTHEADER));

                     lpb = malloc(sizeof(LPVOID) * dwSize);
                     if (lpb == NULL) 
                     {
                            return 0;
                     } 

                     GetRawInputData((HRAWINPUT)lParam, RID_INPUT, lpb, &dwSize, 
                             sizeof(RAWINPUTHEADER));

                     raw = (RAWINPUT*)lpb;

                     if (raw->header.dwType == RIM_TYPEMOUSE) //判断是否为鼠标信息
                     {
                            raw->data.mouse.usFlags = MOUSE_MOVE_ABSOLUTE;
                            for(int i=1; i<nMouseNumber; ++i)
                            {
                                   if(pSiRawMouse[i].hDevice == raw->header.hDevice)
                                   {
                                          pSiRawMouse[i].X += raw->data.mouse.lLastX;
                                          pSiRawMouse[i].Y += raw->data.mouse.lLastY;
                                          hdc = GetDC(hwnd);
                                  CheckBound(hdc,pSiRawMouse[i].X,pSiRawMouse[i].Y);
                                          ReleaseDC(hwnd,hdc);
                                          pSiRawMouse[0].X = pSiRawMouse[i].X;
                                          pSiRawMouse[0].Y = pSiRawMouse[i].Y;

                                   }

                            SetCursorPos(pSiRawMouse[0].X, pSiRawMouse[0].Y);

                            }
                            wsprintf(mousePostion,"Mouse %d-> X: %ld,Y: %ld/n", 0, pSiRawMouse[0].X, pSiRawMouse[0].Y);
                            for(int i=1; i<nMouseNumber; ++i)
                            {
                                   char cTemp[100];
                                   wsprintf(cTemp,"Mouse %d-> X: %ld,Y: %ld/n", i, pSiRawMouse[i].X, pSiRawMouse[i].Y);
                                   strcat(mousePostion,cTemp);
                            }

                     } 
                    
                     //重绘窗口以显示输入数据及重绘指针
                     InvalidateRect(hwnd,0,TRUE);
                     SendMessage(hwnd,WM_PAINT,0,0);
                                         
                     free(lpb);  
                     return 0;
              } 
        }
        return DefWindowProc (hwnd, nMsg, wParam, lParam);
}

int APIENTRY 
WinMain (HINSTANCE hInst, HINSTANCE hPrev, LPSTR lpCmd, int nShow)
{
             hicon = LoadIcon(hInst,MAKEINTRESOURCE(IDI_CURSOR));
      
              HWND         hwndMain;       
        MSG          msg;            
        WNDCLASSEX   wndclass;      
        char*        szMainWndClass = "szRawInputTest";
                                    
      
        memset (&wndclass, 0, sizeof(WNDCLASSEX));
        wndclass.lpszClassName = szMainWndClass;
        wndclass.cbSize = sizeof(WNDCLASSEX);
        wndclass.style = CS_HREDRAW | CS_VREDRAW;
        wndclass.lpfnWndProc = MainWndProc;
        wndclass.hInstance = hInst;
        wndclass.hIcon = LoadIcon (NULL, IDI_APPLICATION);
        wndclass.hIconSm = LoadIcon (NULL, IDI_APPLICATION);
        wndclass.hCursor = LoadCursor (NULL, IDC_ARROW);
       wndclass.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
        RegisterClassEx (&wndclass);
        hwndMain = CreateWindow (
                szMainWndClass,           
                "RawInput pointer draw",           
                WS_OVERLAPPEDWINDOW,      
                CW_USEDEFAULT,            
                CW_USEDEFAULT,            
                CW_USEDEFAULT,            
                CW_USEDEFAULT,             
                NULL,                      
                NULL,                      
                hInst,                     
                NULL                        
                );
              ShowCursor(FALSE);
              InitRawInput(hwndMain);
        ShowWindow (hwndMain, nShow);
        UpdateWindow (hwndMain);

              //进入消息循环
        while (GetMessage (&msg, NULL, 0, 0))
        {
                TranslateMessage (&msg);
                DispatchMessage (&msg);
        }
        return msg.wParam;
}
```

程序运行效果如图2.4所示：

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/RawInput各鼠标指针绘制演示程序截图.JPG)

图2.4 RawInput各鼠标指针绘制演示程序截图

中间显示的鼠标0即为系统鼠标，鼠标1，2，3分别为接入的实际鼠标，在这里为了更好的集中在鼠标指针的绘制问题上，忽略了所有关于鼠标按键的问题。程序源代码中IDI_CURSOR为一个自定义的图标资源。需要注意的是，因为各鼠标实际的操作是利用系统鼠标完成，所以同时操作的时候会有些混乱，这是分时控制系统鼠标的弊病所在，在介绍RawInput技术的时候已经讲过，另外，在接下来的第3章中，讲CPNMouse库部分时候会详细演示这种技术的弊端。
