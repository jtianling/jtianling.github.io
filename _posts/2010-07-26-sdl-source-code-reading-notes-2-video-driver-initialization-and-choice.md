---
layout: post
title: SDL源码阅读笔记（2） video dirver的初始化及选择
categories:
- "图形技术"
tags:
- SDL
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '86'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)

[前一篇文章](<http://www.jtianling.com/archive/2010/07/24/5761714.aspx> "前一篇文章")  
讲了SDL的除video以外的大部分模块。本文主要关注SDL的video模块部分。

SDL中的video模块包含了大部分与平台相关的代码，并且SDL处理的很有技巧性，这里利用C语言的函数指针来模拟了一种类似于面向对象的效果。

主要的关键点在

SDL_VideoDevice *current_video = NULL;

这一句定义的全局变量current_video上，我们先来看看这个变量类型SDL_VideoDevice。

主要在SDL_sysvideo.h这个文件中  

```c
struct SDL_VideoDevice {

    /*
     * *
     */

    /*
     The name of this video driver
     */

    const char *name;

    /*
     * *
     */

    /*
     Initialization/Query functions
    */

    /*
     Initialize the native video subsystem, filling 'vformat' with the
        "best" display pixel format, returning 0 or -1 if there's an error.

     */

    int (*VideoInit)(_THIS, SDL_PixelFormat *vformat);

    /*
     List the available video modes for the given pixel format, sorted
        from largest to smallest.

     */

    SDL_Rect **(*ListModes)(_THIS, SDL_PixelFormat *format, Uint32 flags);

    /*
     Set the requested video mode, returning a surface which will be
        set to the SDL_VideoSurface.  The width and height will already
        be verified by ListModes(), and the video subsystem is free to
        set the mode to a supported bit depth different from the one
        specified -- the desired bpp will be emulated with a shadow
        surface if necessary.  If a new mode is returned, this function
        should take care of cleaning up the current mode.

     */

    SDL_Surface *(*SetVideoMode)(_THIS, SDL_Surface *current,
                int width, int height, int bpp, Uint32 flags);

    /*
     Toggle the fullscreen mode
    */

    int (*ToggleFullScreen)(_THIS, int on);

    /*
     This is called after the video mode has been set, to get the
        initial mouse state.  It should queue events as necessary to
        properly represent the current mouse focus and position.

     */

    void (*UpdateMouse)(_THIS);

    /*
     Create a YUV video surface (possibly overlay) of the given
        format.  The hardware should be able to perform at least 2x
        scaling on display.

     */

    SDL_Overlay *(*CreateYUVOverlay)(_THIS, int width, int height,
                                     Uint32 format, SDL_Surface *display);

    /*
     Sets the color entries { firstcolor .. (firstcolor+ncolors-1) }
        of the physical palette to those in 'colors'. If the device is
        using a software palette (SDL_HWPALETTE not set), then the
        changes are reflected in the logical palette of the screen
        as well.
        The return value is 1 if all entries could be set properly
        or 0 otherwise.
    */

    int (*SetColors)(_THIS, int firstcolor, int ncolors,
             SDL_Color *colors);

    /*
     This pointer should exist in the native video subsystem and should
        point to an appropriate update function for the current video mode
     */

    void (*UpdateRects)(_THIS, int numrects, SDL_Rect *rects);

    /*
     Reverse the effects VideoInit() -- called if VideoInit() fails
        or if the application is shutting down the video subsystem.
    */

    void (*VideoQuit)(_THIS);

    /*
     * *
     */

    /*
     Hardware acceleration functions
    */

    /*
     Information about the video hardware
    */

    SDL_VideoInfo info;

    /*
     The pixel format used when SDL_CreateRGBSurface creates SDL_HWSURFACEs with alpha
    */

    SDL_PixelFormat* displayformatalphapixel;


    /*
     Allocates a surface in video memory
    */

    int (*AllocHWSurface)(_THIS, SDL_Surface *surface);

    /*
     Sets the hardware accelerated blit function, if any, based
        on the current flags of the surface (colorkey, alpha, etc.)

     */

    int (*CheckHWBlit)(_THIS, SDL_Surface *src, SDL_Surface *dst);

    /*
     Fills a surface rectangle with the given color
    */

    int (*FillHWRect)(_THIS, SDL_Surface *dst, SDL_Rect *rect, Uint32 color);

    /*
     Sets video mem colorkey and accelerated blit function
    */

    int (*SetHWColorKey)(_THIS, SDL_Surface *surface, Uint32 key);

    /*
     Sets per surface hardware alpha value
    */

    int (*SetHWAlpha)(_THIS, SDL_Surface *surface, Uint8 value);

    /*
     Returns a readable/writable surface
    */

    int (*LockHWSurface)(_THIS, SDL_Surface *surface);

    void (*UnlockHWSurface)(_THIS, SDL_Surface *surface);

    /*
     Performs hardware flipping
    */

    int (*FlipHWSurface)(_THIS, SDL_Surface *surface);

    /*
     Frees a previously allocated video surface
    */

    void (*FreeHWSurface)(_THIS, SDL_Surface *surface);

    /*
     * *
     */

    /*
     Gamma support
    */

    Uint16 *gamma;

    /*
     Set the gamma correction directly (emulated with gamma ramps)
    */

    int (*SetGamma)(_THIS, float red, float green, float blue);

    /*
     Get the gamma correction directly (emulated with gamma ramps)
    */

    int (*GetGamma)(_THIS, float *red, float *green, float *blue);

    /*
     Set the gamma ramp
    */

    int (*SetGammaRamp)(_THIS, Uint16 *ramp);

    /*
     Get the gamma ramp
    */

    int (*GetGammaRamp)(_THIS, Uint16 *ramp);

    /*
     * *
     */

    /*
     OpenGL support
    */

    /*
     Sets the dll to use for OpenGL and loads it
    */

    int (*GL_LoadLibrary)(_THIS, const char *path);

    /*
     Retrieves the address of a function in the gl library
    */

    void * (*GL_GetProcAddress)(_THIS, const char *proc);

    /*
     Get attribute information from the windowing system.
    */

    int (*GL_GetAttribute)(_THIS, SDL_GLattr attrib, int * value);

    /*
     Make the context associated with this driver current
    */

    int (*GL_MakeCurrent)(_THIS);

    /*
     Swap the current buffers in double buffer mode.
    */

    void (*GL_SwapBuffers)(_THIS);

    /*
     OpenGL functions for SDL_OPENGLBLIT
    */


#if SDL_VIDEO_OPENGL

#if !defined(__WIN32__)

#define WINAPI

#endif

#define SDL_PROC(ret,func,params) ret (WINAPI *func) params;

#include "SDL_glfuncs.h"

#undef SDL_PROC

    /*
     Texture id
    */

    GLuint texture;
#endif

    int is_32bit;


    /*
     * *
     */

    /*
     Window manager functions
    */

    /*
     Set the title and icon text
    */

    void (*SetCaption)(_THIS, const char *title, const char *icon);

    /*
     Set the window icon image
    */

    void (*SetIcon)(_THIS, SDL_Surface *icon, Uint8 *mask);

    /*
     Iconify the window.

        This function returns 1 if there is a window manager and the
        window was actually iconified, it returns 0 otherwise.

    */

    int (*IconifyWindow)(_THIS);

    /*
     Grab or ungrab keyboard and mouse input
    */

    SDL_GrabMode (*GrabInput)(_THIS, SDL_GrabMode mode);

    /*
     Get some platform dependent window information
    */

    int (*GetWMInfo)(_THIS, SDL_SysWMinfo *info);

    /*
     * *
     */

    /*
     Cursor manager functions
    */

    /*
     Free a window manager cursor

        This function can be NULL if CreateWMCursor is also NULL.

     */

    void (*FreeWMCursor)(_THIS, WMcursor *cursor);

    /*
     If not NULL, create a black/white window manager cursor
    */

    WMcursor *(*CreateWMCursor)(_THIS,
        Uint8 *data, Uint8 *mask, int w, int h, int hot_x, int hot_y);

    /*
     Show the specified cursor, or hide if cursor is NULL
    */

    int (*ShowWMCursor)(_THIS, WMcursor *cursor);

    /*
     Warp the window manager cursor to (x,y)

        If NULL, a mouse motion event is posted internally.

     */

    void (*WarpWMCursor)(_THIS, Uint16 x, Uint16 y);

    /*
     If not NULL, this is called when a mouse motion event occurs
    */

    void (*MoveWMCursor)(_THIS, int x, int y);

    /*
     Determine whether the mouse should be in relative mode or not.

        This function is called when the input grab state or cursor
        visibility state changes.

        If the cursor is not visible, and the input is grabbed, the
        driver can place the mouse in relative mode, which may result
        in higher accuracy sampling of the pointer motion.

    */

    void (*CheckMouseMode)(_THIS);

    /*
     * *
     */

    /*
     Event manager functions
    */

    /*
     Initialize keyboard mapping for this driver
    */

    void (*InitOSKeymap)(_THIS);

    /*
     Handle any queued OS events
    */

    void (*PumpEvents)(_THIS);

    /*
     * *
     */

    /*
     Data common to all drivers
    */

    SDL_Surface *screen;

    SDL_Surface *shadow;

    SDL_Surface *visible;

    SDL_Palette *physpal;   /* physical palette, if != logical palette */

    SDL_Color *gammacols;   /* gamma-corrected colours, or NULL */

    char *wm_title;

    char *wm_icon;

    int offset_x;

    int offset_y;

    SDL_GrabMode input_grab;

    /*
     Driver information flags
    */

    int handles_any_size;  /* Driver handles any size video mode */

    /*
     * *
     */

    /*
     Data used by the GL drivers
    */

    struct {
        int red_size;
        int green_size;
        int blue_size;
        int alpha_size;
        int depth_size;
        int buffer_size;
        int stencil_size;
        int double_buffer;
        int accum_red_size;
        int accum_green_size;
        int accum_blue_size;
        int accum_alpha_size;
        int stereo;
        int multisamplebuffers;
        int multisamplesamples;
        int accelerated;
        int swap_control;
        int driver_loaded;
        char driver_path[256];
        void * dll_handle;
    } gl_config;

    /*
     * *
     */

    /*
     Data private to this driver
    */

    struct SDL_PrivateVideoData *hidden;

    struct SDL_PrivateGLData *gl_data;

    /*
     * *
     */

    /*
     The function used to dispose of this structure
    */

    void (*free)(_THIS);

};
```

这个结构主要包含的是函数指针，每个函数指针表示了一个与平台相关的函数。在运行时，给这些函数指针赋值，指定成对应平台的函数实现，以此实现了使用此结构指针current_video的上层的代码的稳定与一致。

这里首先关心两个流程，其一，初始化给这些函数指针赋值的过程。

这个过程在SDL_VideoInit函数中实现：

SDL初始化基本流程：

SDL_Init(SDL_INIT_VIDEO)->SDL_InitSubSystem（SDL_INIT_VIDEO)->SDL_VideoInit()

中途会调用以"SDL_VIDEODRIVER"为参数调用SDL_getenv函数来获取全局配置中指定的对应的video driver。

代码如下：  

```c
if ( SDL_VideoInit(SDL_getenv("SDL_VIDEODRIVER"),
                   (flags&SDL_INIT_EVENTTHREAD)) < 0 ) {
    return (-1);
}
```

我没有设定，所以会以name = NULL为第一参数来调用SDL_VideoInit，也就是让SDL自己选择一个video driver。

SDL会从一个  

```c
typedef struct VideoBootStrap {
    const char *name;
    const char *desc;
    int (*available)(void);
    SDL_VideoDevice *(*create)(int devindex);
} VideoBootStrap;
```

结构的全局变量bootstrap数组中选取一个可以使用的video driver。

一共有这么多可能的video driver:  

```c
/* Available video drivers */

static VideoBootStrap *bootstrap[] = {
#if SDL_VIDEO_DRIVER_QUARTZ
    &QZ_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_X11
    &X11_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_DGA
    &DGA_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_NANOX
    &NX_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_IPOD
    &iPod_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_QTOPIA
    &Qtopia_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_WSCONS
    &WSCONS_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_FBCON
    &FBCON_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_DIRECTFB
    &DirectFB_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_PS2GS
    &PS2GS_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_PS3
    &PS3_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_GGI
    &GGI_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_VGL
    &VGL_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_SVGALIB
    &SVGALIB_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_GAPI
    &GAPI_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_WINDIB
    &_WINDIB_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_DDRAW
    &_DIRECTX_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_BWINDOW
    &BWINDOW_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_TOOLBOX
    &TOOLBOX_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_DRAWSPROCKET
    &DSp_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_PHOTON
    &ph_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_EPOC
    &EPOC_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_XBIOS
    &XBIOS_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_GEM
    &GEM_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_PICOGUI
    &PG_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_DC
    &DC_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_NDS
    &NDS_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_RISCOS
    &RISCOS_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_OS2FS
    &OS2FSLib_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_AALIB
    &AALIB_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_CACA
    &CACA_bootstrap,
#endif

#if SDL_VIDEO_DRIVER_DUMMY
    &DUMMY_bootstrap,
#endif

    NULL

};
```

都是通过宏来筛选的。

-    bootstrap    0x100a2b1c bootstrap    VideoBootStrap * [4]

```bash
+    [0x0]    0x100a1160 _WINDIB_bootstrap {name=0x10099428 "windib" desc=0x1009940c "Win95/98/NT/2000/CE GDI" available=0x1005eaf0 ...}    VideoBootStrap *
+    [0x1]    0x100a25e8 _DIRECTX_bootstrap {name=0x10099ab4 "directx" desc=0x10099a98 "Win95/98/2000 DirectX" available=0x100651d0 ...}    VideoBootStrap *
+    [0x2]    0x100a2aec _DUMMY_bootstrap {name=0x100995a4 "dummy" desc=0x1009b3e4 "SDL dummy video driver" available=0x10072090 ...}    VideoBootStrap *
+    [0x3]    0x00000000 {name=??? desc=??? available=??? ...}    VideoBootStrap *
```

在我的电脑上(Win32），一共有上面3种可能，windib（即GDI）,directX,dummy。事实上OpenGL在Win32的环境中都没有列出来，当然，但是在以前的例子中，我还是使用了SDL+OpenGL来渲染，原因在于video毕竟不是如同其名字所示，仅仅包含渲染或者视频方面的东西，它其实代表了大部分SDL与平台相关的东西，渲染在SDL中也仅仅是占比较小的一部分。

选取video driver的时候，先调用VideoBootStrap   
结构中的available  
函数来判断此video driver有效则通过此结构的create函数来创建一个video driver.

如下：  

```c
for ( i=0; bootstrap[i]; ++i ) {
    if ( bootstrap[i]->available() ) {
        video = bootstrap[i]->create(index);
        if ( video != NULL ) {
            break;
        }
    }
}
```

创建的时候附带index,并且一旦创建成功，就停止了创建过程，在我的例子中，由于GDI方式排在第一，所以事实上，SDL在Win32环境下默认是选择了使用GDI的video driver。

此GDI video driver的create函数如下：  

```c
static SDL_VideoDevice *DIB_CreateDevice(int devindex)
{
    SDL_VideoDevice *device;

    /*
     Initialize all variables that we clean on shutdown
    */

    device = (SDL_VideoDevice *)SDL_malloc(sizeof (SDL_VideoDevice));

    if ( device ) {
        SDL_memset(device, 0, (sizeof *device));
        device->hidden = (struct SDL_PrivateVideoData *)
                SDL_malloc((sizeof *device->hidden));
        if (device->hidden){
            SDL_memset(device->hidden, 0, (sizeof *device->hidden));
            device->hidden->dibInfo = (DibInfo *)SDL_malloc((sizeof (DibInfo)));
            if (device->hidden->dibInfo == NULL)
            {
                SDL_free(device->hidden);
                device->hidden = NULL;
            }
        }

        device->gl_data = (struct SDL_PrivateGLData *)
                SDL_malloc((sizeof *device->gl_data));
    }

    if ( (device == NULL) || (device->hidden == NULL) ||
                 (device->gl_data == NULL) ) {
        SDL_OutOfMemory();
        DIB_DeleteDevice(device);
        return (NULL);
    }

    SDL_memset(device->hidden->dibInfo, 0, (sizeof *device->hidden->dibInfo));
    SDL_memset(device->gl_data, 0, (sizeof *device->gl_data));

    /*
     Set the function pointers
    */

    device->VideoInit = DIB_VideoInit;
    device->ListModes = DIB_ListModes;
    device->SetVideoMode = DIB_SetVideoMode;
    device->UpdateMouse = WIN_UpdateMouse;
    device->SetColors = DIB_SetColors;
    device->UpdateRects = NULL;
    device->VideoQuit = DIB_VideoQuit;
    device->AllocHWSurface = DIB_AllocHWSurface;
    device->CheckHWBlit = NULL;
    device->FillHWRect = NULL;
    device->SetHWColorKey = NULL;
    device->SetHWAlpha = NULL;
    device->LockHWSurface = DIB_LockHWSurface;
    device->UnlockHWSurface = DIB_UnlockHWSurface;
    device->FlipHWSurface = NULL;
    device->FreeHWSurface = DIB_FreeHWSurface;
    device->SetGammaRamp = DIB_SetGammaRamp;
    device->GetGammaRamp = DIB_GetGammaRamp;
#if SDL_VIDEO_OPENGL
    device->GL_LoadLibrary = WIN_GL_LoadLibrary;
    device->GL_GetProcAddress = WIN_GL_GetProcAddress;
    device->GL_GetAttribute = WIN_GL_GetAttribute;
    device->GL_MakeCurrent = WIN_GL_MakeCurrent;
    device->GL_SwapBuffers = WIN_GL_SwapBuffers;
#endif

    device->SetCaption = WIN_SetWMCaption;
    device->SetIcon = WIN_SetWMIcon;
    device->IconifyWindow = WIN_IconifyWindow;
    device->GrabInput = WIN_GrabInput;
    device->GetWMInfo = WIN_GetWMInfo;
    device->FreeWMCursor = WIN_FreeWMCursor;
    device->CreateWMCursor = WIN_CreateWMCursor;
    device->ShowWMCursor = WIN_ShowWMCursor;
    device->WarpWMCursor = WIN_WarpWMCursor;
    device->CheckMouseMode = WIN_CheckMouseMode;
    device->InitOSKeymap = DIB_InitOSKeymap;
    device->PumpEvents = DIB_PumpEvents;

    /*
     Set up the windows message handling functions
    */

    WIN_Activate = DIB_Activate;
    WIN_RealizePalette = DIB_RealizePalette;
    WIN_PaletteChanged = DIB_PaletteChanged;
    WIN_WinPAINT = DIB_WinPAINT;
    HandleMessage = DIB_HandleMessage;

    device->free = DIB_DeleteDevice;

    /*
     We're finally ready
    */

    return device;
}
```

开始时为video driver分配内存，然后为相应的参数赋值，最最重要的就是为video driver的函数指针赋值，赋值成当前video driver的函数，以此实现我开始说的，以C语言实现类似面向对象的效果。

video driver的那一堆函数指针就像是抽象的接口，这里的函数就像是子类的实现。上层逻辑只需要使用video driver的指针并调用其中的函数即可，完全统一，并且不用关心指针具体是调用了哪个"子类“的函数。因为习惯了C++，我很少使用C语言来编写大规模的代码，所以对这些特性并不是非常熟悉，但是在C语言实现面向对象特性方面，我见过几派，我感觉这种方式算是比较好的，比完全使用宏来模拟C++的效果看上去要更加容易理解和自然。当然，因为C语言的确没有"标准"的面向对象实现方式，所以到底那个更好，也只能是见仁见智的问题了，估计也会像"大括号战争”一样没有休止。

此处还值得一提的是，SDL_VIDEO_OPENGL宏是默认开启的，也就是说，在Win32下使用GDI这个默认的video driver时，

SDL进行了  
    device->GL_LoadLibrary = WIN_GL_LoadLibrary;

    device->GL_GetProcAddress = WIN_GL_GetProcAddress;

    device->GL_GetAttribute = WIN_GL_GetAttribute;

    device->GL_MakeCurrent = WIN_GL_MakeCurrent;

    device->GL_SwapBuffers = WIN_GL_SwapBuffers;  

这些函数的赋值。形成了对OpenGL的支持。这里与我以前了解的有些差异，因为我以前以为SDL在Win32下是默认使用DirectX加速的，现在看来并不是，就如侯捷所言，"源码面前了无秘密"，这些点点滴滴的东西，也算是看源码的一种收获。

然后，我查看了文档：  
《[SDL支持哪些系统平台？](<http://www.libsdl.org/intro.cn/whatplatforms.html> "SDL支持哪些系统平台？")  
  
》

有如下描述：

 

  * 有两个版本，一个是适合所有基于Win32的系统的安全版本，另一个是基于DirectX的高性能版本。 
  * 安全版本的视频显示采用GDI。高性能版本采用DirectDraw，并支持硬件加速。 
  * 安全版本的音频回放采用waveOut API。高性能版本采用DirectSound。 

这里可以看出，默认的时候SDL使用了Win32系统的安全版本。

 

此步初始化后，再利用video driver自己的VideoInit函数再次进行针对特殊的video driver的初始化。然后再开始SDL的事件线程（详细内容见上节）

然后，此时已经回到SDL_InitSubSystem函数了，此函数还需要进行一些其他模块的初始化，比如时间模块，摇杆等，这里就不多讲了。

看到这里，对于初始化部分的流程应该就比较清楚了，现在有个问题：

怎么改变SDL使用的video driver的默认值？比如，改成DirectX版本的。

从上面来看，有两种办法，

其一，改变bootstrap  
数组中各driver的顺序，将directX的driver提到第一，那样默认就初始化directX版本了。

其二，让SDL_getenv("SDL_VIDEODRIVER") 返回directX版本driver的名字。

个人感觉方法二明显更加自然一些，感觉也是SDL作者提供的选择方案。那么，尝试一下，这里我通过SDL提供的接口SDL_putenv来设置环境变量，看看效果。

根据SDL_getenv的调用及前面查看的bootstrap的值，知道SDL查看的环境变量名为SDL_VIDEODRIVER，directX表示的driver名字为directx，所以在初始化前添加如下代码：

SDL_putenv("SDL_VIDEODRIVER=directx");

可以看到效果是以"directx"为第一参数调用SDL_VideoInit，并且进入了一下代码：  

```c
for ( i=0; bootstrap[i]; ++i ) {
    if ( SDL_strcasecmp(bootstrap[i]->name, driver_name) == 0 ) {
        if ( bootstrap[i]->available() ) {
            video = bootstrap[i]->create(index);
            break;
        }
    }
}
```

此时，通过SDL_strcasecmp的调用，略过了GDI的video driver，然后使用了directX的driver。首先进入的available函数是：DX5_Available，晕了，DX5。。。。。什么年代的东西啊。。。。。。无语中。

在DX5_Available的调用中，仅仅通过以下语句判断了DINPUT.DLL和DDRAW.DLL动态库及DirectDrawCreate函数的存在，来判断DX5 driver是否可用。

```c
DInputDLL = LoadLibrary(TEXT("DINPUT.DLL"));
DDrawDLL = LoadLibrary(TEXT("DDRAW.DLL"));
DDrawCreate = (void *)GetProcAddress(DDrawDLL, TEXT("DirectDrawCreate"));
```

同时，上述语句也说明，SDL使用的DirectX加速使用的是DX5.....并且使用的是DirectDraw，在那古老的年代，我不知道有没有D3D，不过对DDraw的使用倒是印证了我初看SDL渲染接口时的印象，抽象的接口与DDraw太像了。。。。。。。下面函数赋值的时候应该还能看到。

DX5_CreateDevice为SDL DirectX driver的创建函数，如同GDI版本一样对函数进行赋值。  

```c
/* Set the function pointers */
device->VideoInit = DX5_VideoInit;
device->ListModes = DX5_ListModes;
device->SetVideoMode = DX5_SetVideoMode;
device->UpdateMouse = WIN_UpdateMouse;
device->CreateYUVOverlay = DX5_CreateYUVOverlay;
device->SetColors = DX5_SetColors;
device->UpdateRects = NULL;
device->VideoQuit = DX5_VideoQuit;
device->AllocHWSurface = DX5_AllocHWSurface;
device->CheckHWBlit = DX5_CheckHWBlit;
device->FillHWRect = DX5_FillHWRect;
device->SetHWColorKey = DX5_SetHWColorKey;
device->SetHWAlpha = DX5_SetHWAlpha;
device->LockHWSurface = DX5_LockHWSurface;
device->UnlockHWSurface = DX5_UnlockHWSurface;
device->FlipHWSurface = DX5_FlipHWSurface;
device->FreeHWSurface = DX5_FreeHWSurface;
device->SetGammaRamp = DX5_SetGammaRamp;
device->GetGammaRamp = DX5_GetGammaRamp;
#if SDL_VIDEO_OPENGL
device->GL_LoadLibrary = WIN_GL_LoadLibrary;
device->GL_GetProcAddress = WIN_GL_GetProcAddress;
device->GL_GetAttribute = WIN_GL_GetAttribute;
device->GL_MakeCurrent = WIN_GL_MakeCurrent;
device->GL_SwapBuffers = WIN_GL_SwapBuffers;
#endif

device->SetCaption = WIN_SetWMCaption;
device->SetIcon = WIN_SetWMIcon;
device->IconifyWindow = WIN_IconifyWindow;
device->GrabInput = WIN_GrabInput;
device->GetWMInfo = WIN_GetWMInfo;
device->FreeWMCursor = WIN_FreeWMCursor;
device->CreateWMCursor = WIN_CreateWMCursor;
device->ShowWMCursor = WIN_ShowWMCursor;
device->WarpWMCursor = WIN_WarpWMCursor;
device->CheckMouseMode = WIN_CheckMouseMode;
device->InitOSKeymap = DX5_InitOSKeymap;
device->PumpEvents = DX5_PumpEvents;

/* Set up the windows message handling functions */
WIN_Activate = DX5_Activate;
WIN_RealizePalette = DX5_RealizePalette;
WIN_PaletteChanged = DX5_PaletteChanged;
WIN_WinPAINT = DX5_WinPAINT;
HandleMessage = DX5_HandleMessage;
```

这里我们可以看到，相对GDI版本而言，除了速度之外，DirectX版本明显支持的特性更多，上面的函数指针赋值就没有GDI版本那么多NULL了，全部都有对应的函数。

最让人惊讶的时候，还是有OpenGL的函数。最后经过我测试，的确也是能够使用OpenGL。。。。。。

很显然，关键在于

SDL_Surface* screen = SDL_SetVideoMode( WINDOW_WIDTH, WINDOW_HEIGHT, 16, SDL_OPENGL); 

一句的调用。

因为本文太长，在Google Document上输入都已经很卡了，所以留待下篇文章再看。

  

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**