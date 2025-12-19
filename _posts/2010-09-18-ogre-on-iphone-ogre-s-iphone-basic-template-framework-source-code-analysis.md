---
layout: post
title: OGRE On iPhone ---

本文分析了Ogre 3D引擎的iPhone基础模版框架，讲解了其初始化、触摸输入处理等核心功能，并对比了iPhone与桌面版在程序驱动方式上的差异。

<!-- more -->

-Ogre的iPhone基础模版框架源代码分析
categories:
- iOS
- "图形技术"
tags: []
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

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

当想要在iPhone上使用某个3D引擎的时候，感觉我这水平，自己写好像还不现实，学到自己能写都不知道要到何年何月了，于是折腾过没有官方支持但是比较简单而且我比较熟悉的Irrlicht。虽然的确成功了（见我[原来的文章](<http://www.jtianling.com/archive/2010/06/04/5646331.aspx> "原来的文章")），但是弄2D游戏的时候，（用其他引擎）经历过一些痛苦的事情后，我发现强大，成熟的引擎，以及官方的支持是多么重要。。。。。于是，虽然Ogre的效率在iPhone上还有些难以承受，但是，我还是希望学习学习，并将Ogre作为优先使用的3D引擎。谁叫Ogre那么流行呢？将来要是弄老本行，去做网络游戏，估计也不错^^

## 本文写作目的：

1.Ogre的[基础模版程序](<http://www.ogre3d.org/tikiwiki/tiki-index.php?page=Basic%20Ogre%20Framework> "基础模版程序")是Ogre在iPhone平台的模版程序的基础，但是此模版程序没有太多的说明和注释，作者仅仅是说程序具有自解释性。。。。。我这里代为简单解释一下。。。。

2.Ogre虽然是跨平台引擎，但是既然跨平台，在各平台就会有些差异存在，而从桌面程序到iPhone这样的移动平台，差异就更大了，我这里不从源码的角度，仅仅从示例程序对Ogre的使用角度指出这些差异。

而怎么在iPhone上编译运行Ogre,怎么样安装Ogre为iPhone做的项目模版，因为有官方支持嘛，[下个SDK](<http://www.ogre3d.org/download/sdk> "下个SDK")，非常容易，不像Irrlicht那样需要调整很多东西，所以，这些都不是本文的重点，大家自己摸索一下吧。本文也不是Ogre的入门教程，这个请去看Ogre的[WIKI](<http://www.ogre3d.org/tikiwiki/Tutorials> "WIKI")，也有[中文版](<http://wiki.ogrecn.com/wiki/> "中文版")。（但是WIKI的中级教程有些老，代码一般不能直接在新版本的Ogre和CEGU中工作，但是理解后，稍微进行点改动就行了，中文版可能更老，我没有看，推荐还是去看原版的好，毕竟都是很简单的东西）

## 基础框架了解

在弄清楚一切之前，利用Ogre的iPhone的基础框架，可以得到以下的运行效果：

![](https://docs.google.com/File?id=dhn3dw87_190cdxhjjdm_b)

一个癞蛤蟆一样的Ogre标识模型。。。。。我见过最难看的一个。。。。。。

先在机器上运行一下，了解这个基础框架实现了哪些功能，主要有下列三个：

1.3D场景中显示了天空盒和一个癞蛤蟆皮Ogre头。。。。

2.2D UI中显示了一系列的Debug信息以及OGRE的标识

3.支持触摸进行Camara的旋转。

然后，下面对此框架的了解除了大致框架外，了解3个功能是在哪里实现的。

## 基础框架代码分析

主要部分是OgreFramework.h和OgreFramework.cpp两个文件包含的OgreFramework类，这个类虽然内容简单，但是基本功能齐全，并且，在此简单的框架的基础上，尽量简单的实现了跨平台，这样的话，可以尝试开发Mac,Win32程序，然后移植到iPhone中，以加快开发速度，缩短开发周期。

如下所示

```cpp
#if OGRE_PLATFORM == OGRE_PLATFORM_IPHONE

class OgreFramework : public Ogre::Singleton<OgreFramework>, OIS::KeyListener, OIS::MultiTouchListener

#else

class OgreFramework : public Ogre::Singleton<OgreFramework>, OIS::KeyListener, OIS::MouseListener

#endif
```

OgreFramework是一个C++类，并通过Ogre::Singleton做成单件，并且，这里可以看出来，通过OIS的MultiTouchListener来支持多点触摸。

所有的接口如下：

```cpp
public:

    OgreFramework();

    ~OgreFramework();

#if OGRE_PLATFORM == OGRE_PLATFORM_IPHONE

    bool initOgre(Ogre::String wndTitle, OIS::KeyListener *pKeyListener = 0, OIS::MultiTouchListener *pMouseListener = 0);

#else

    bool initOgre(Ogre::String wndTitle, OIS::KeyListener *pKeyListener = 0, OIS::MouseListener *pMouseListener = 0);

#endif

    void updateOgre(double timeSinceLastFrame);

    void updateStats();

    void moveCamera();

    void getInput();

    bool isOgreToBeShutDown()const{return m_bShutDownOgre;}  

    bool keyPressed(const OIS::KeyEvent &keyEventRef);

    bool keyReleased(const OIS::KeyEvent &keyEventRef);

#if OGRE_PLATFORM == OGRE_PLATFORM_IPHONE

    bool touchMoved(const OIS::MultiTouchEvent &evt);

    bool touchPressed(const OIS::MultiTouchEvent &evt); 

    bool touchReleased(const OIS::MultiTouchEvent &evt);

    bool touchCancelled(const OIS::MultiTouchEvent &evt);

#else

    bool mouseMoved(const OIS::MouseEvent &evt);

    bool mousePressed(const OIS::MouseEvent &evt, OIS::MouseButtonID id); 

    bool mouseReleased(const OIS::MouseEvent &evt, OIS::MouseButtonID id);

#endif
```

可以从接口看出，此框架设计的使用方式是直接作为变量/成员变量使用，不是希望使用者继承此类。下面分别看各个部分。

### 初始化

其他部分都属于进一步的操作和更新了，主要部分是Ogre的初始化部分，在initOgre，先看看这个函数：(感觉必要的地方我添加了注释）

/|||||||||||||||||||||||||||||||||||||||||||||||

```cpp
#if OGRE_PLATFORM == OGRE_PLATFORM_IPHONE
bool OgreFramework::initOgre(Ogre::String wndTitle, OIS::KeyListener *pKeyListener, OIS::MultiTouchListener *pMouseListener)
#else
bool OgreFramework::initOgre(Ogre::String wndTitle, OIS::KeyListener *pKeyListener, OIS::MouseListener *pMouseListener)
#endif
{
    // 日志管理的初始化  

    new Ogre::LogManager();
    
    m_pLog = Ogre::LogManager::getSingleton().createLog("OgreLogfile.log", true, true, false);
    m_pLog->setDebugOutputEnabled(true);
    
    // 不是静态链接的时候使用plugins.cfg配置文件，因为iPhone只能使用静态链接方式，没戏了  

    String pluginsPath;
    // only use plugins.cfg if not static

#ifndef OGRE_STATIC_LIB
    pluginsPath = m_ResourcePath + "plugins.cfg";
#endif
    
    // Root的创建（Ogre::Root* m_pRoot;）  

    m_pRoot = new Ogre::Root(pluginsPath, Ogre::macBundlePath() + "/ogre.cfg");
    
#ifdef OGRE_STATIC_LIB
    m_StaticPluginLoader.load();
#endif
    
    // 代码虽然是显示配置对话框的代码，但是示例中不会显示配置对话框，而是直接restore了原来的配置  

    if(!m_pRoot->showConfigDialog())
        return false;
    
    // 渲染窗口的创建及初始化(Ogre::RenderWindow* m_pRenderWnd;)  

    m_pRenderWnd = m_pRoot->initialise(true, wndTitle);
    
    // iPhone平台特定操作，设定屏幕位置及大小（这些都是随着设备就固定了的），这里的(0,0)还是2维坐标，即屏幕的左上角  
    // 有意思的是一开始的时候，Ogre就认为iPhone设备是横的。。。。即RenderWnd height: 320    width: 480  
    // 即状态OR_LANDSCAPELEFT  = OR_DEGREE_270  

#if OGRE_PLATFORM == OGRE_PLATFORM_IPHONE
  m_pRenderWnd->reposition(0, 0);
  m_pRenderWnd->resize(m_pRenderWnd->getHeight(), m_pRenderWnd->getWidth());
#endif
    
    // 以下是SceneMgr，Camera，Viewport的创建及初始化，与一般的过程一样  

    m_pSceneMgr = m_pRoot->createSceneManager(ST_GENERIC, "SceneManager");
    m_pSceneMgr->setAmbientLight(Ogre::ColourValue(0.7, 0.7, 0.7));
    
    m_pCamera = m_pSceneMgr->createCamera("Camera");
    m_pCamera->setPosition(Vector3(0, 60, 60));
    m_pCamera->lookAt(Vector3(0,0,0));
    m_pCamera->setNearClipDistance(1);
    
    m_pViewport = m_pRenderWnd->addViewport(m_pCamera);
    m_pViewport->setBackgroundColour(ColourValue(0.8, 0.7, 0.6, 1.0));
    
    m_pCamera->setAspectRatio(Real(m_pViewport->getActualWidth()) / Real(m_pViewport->getActualHeight()));
    
    m_pViewport->setCamera(m_pCamera);
    
    // OIS的部分，构造的方式为了跨平台，所以有些独特^^通过字符串的方式来索引参数创建，  
    // 传递的参数是窗口的句柄，但是也转换成string了  

    unsigned long hWnd = 0;
    OIS::ParamList paramList;
    m_pRenderWnd->getCustomAttribute("WINDOW", &hWnd);
    
    paramList.insert(OIS::ParamList::value_type("WINDOW", Ogre::StringConverter::toString(hWnd)));
    
    m_pInputMgr = OIS::InputManager::createInputSystem(paramList);
    
    // OIS有MultiTouch的支持，但是在这个框架中还是直接赋值给m_pMouse(这个变量已经根据宏分别创建了)  

#if OGRE_PLATFORM != OGRE_PLATFORM_IPHONE
    m_pKeyboard = static_cast<OIS::Keyboard*>(m_pInputMgr->createInputObject(OIS::OISKeyboard, true));
    m_pMouse = static_cast<OIS::Mouse*>(m_pInputMgr->createInputObject(OIS::OISMouse, true));
    
    m_pMouse->getMouseState().height = m_pRenderWnd->getHeight();
    m_pMouse->getMouseState().width    = m_pRenderWnd->getWidth();
#else
    m_pMouse = static_cast<OIS::MultiTouch*>(m_pInputMgr->createInputObject(OIS::OISMultiTouch, true));
#endif
    
    // 这里可以参考此类的构造函数，即允许构造此类的时候，传递外来的输入响应对象。  

#if OGRE_PLATFORM != OGRE_PLATFORM_IPHONE
    if(pKeyListener == 0)
        m_pKeyboard->setEventCallback(this);
    else
        m_pKeyboard->setEventCallback(pKeyListener);
#endif

    if(pMouseListener == 0)
        m_pMouse->setEventCallback(this);
    else
        m_pMouse->setEventCallback(pMouseListener);
    
    // 读取配置，与一般的情况一样，只是多了个m_ResourcePath作为基础目录，为Mac和iPhone准备的。  
    // 这两个平台因为用了Bundle，所以与PC有些不一样

    Ogre::String secName, typeName, archName;
    Ogre::ConfigFile cf;
    cf.load(m_ResourcePath + "resources.cfg");
    
    Ogre::ConfigFile::SectionIterator seci = cf.getSectionIterator();
    while (seci.hasMoreElements())
    {
        secName = seci.peekNextKey();
        Ogre::ConfigFile::SettingsMultiMap *settings = seci.getNext();
        Ogre::ConfigFile::SettingsMultiMap::iterator i;
        for (i = settings->begin(); i != settings->end(); ++i)
        {
            typeName = i->first;
            archName = i->second;
            // 还是为Mac和iPhone进行了一些特殊处理，英文注释很详细了  

#if OGRE_PLATFORM == OGRE_PLATFORM_APPLE || OGRE_PLATFORM == OGRE_PLATFORM_IPHONE
            // OS X does not set the working directory relative to the app,
            // In order to make things portable on OS X we need to provide
            // the loading with it's own bundle path location
            if (!Ogre::StringUtil::startsWith(archName, "/", false)) // only adjust relative dirs
                archName = Ogre::String(Ogre::macBundlePath() + "/" \+ archName);
#endif
            Ogre::ResourceGroupManager::getSingleton().addResourceLocation(archName, typeName, secName);
        }
    }
    Ogre::TextureManager::getSingleton().setDefaultNumMipmaps(5);
    Ogre::ResourceGroupManager::getSingleton().initialiseAllResourceGroups();
    
    // 创建计时器  

    m_pTimer = OGRE_NEW Ogre::Timer();
    m_pTimer->reset();
    // 获取Debug的Overlay层，用于输出一些调试信息  

    m_pDebugOverlay = OverlayManager::getSingleton().getByName("Core/DebugOverlay");
    m_pDebugOverlay->show();
    
    m_pRenderWnd->setActive(true);
    
    return true;
}
```

这个函数的目的是很单纯的，作为框架性代码，没有像Ogre的基础教程createScene函数一样，添加场景创建的代码，仅仅是初始化了一些相关的对象。而这个函数已经完成了此基础框架希望完成的大部分功能了。

### 输入

keyPressed，mouseMoved在iPhone中是完全没有什么用了，touch的系列接口虽然与iOS SDK基本一致，但是参数上OIS进行了进一步的分装，估计是为了将来方便移植到其他触摸移动平台（比如Android)。

此参数定义如下：

```cpp
//! Touch Event type
enum MultiTypeEventTypeID
{
    MT_None = 0, MT_Pressed, MT_Released, MT_Moved, MT_Cancelled
};
class _OISExport MultiTouchState
{
public:
    MultiTouchState() : width(50), height(50), touchType(MT_None) {};
    /** Represents the height/width of your display area.. used if touch clipping
    or touch grabbed in case of X11 - defaults to 50.. Make sure to set this
    and change when your size changes.. */
    mutable int width, height;
    //! X Axis component
    Axis X;
    //! Y Axis Component
    Axis Y;
    //! Z Axis Component
    Axis Z;
    int touchType;
    inline bool touchIsType( MultiTypeEventTypeID touch ) const
    {
        return ((touchType & ( 1L << touch )) == 0) ? false : true;
    }
    
    //! Clear all the values
    void clear()
    {
        X.clear();
        Y.clear();
        Z.clear();
        touchType = MT_None;
    }
};
/** Specialised for multi-touch events */
class _OISExport MultiTouchEvent : public EventArg
{
public:
    MultiTouchEvent( Object *obj, const MultiTouchState &ms ) : EventArg(obj), state(ms) {}
    virtual ~MultiTouchEvent() {}
    //! The state of the touch - including axes
    const MultiTouchState &state;
};
```

基本上还是很容易理解的，就是有些奇怪的添加了Z坐标，难道将来会有立体触摸？-_-!OIS的作者想的还真远啊。。。。。。。

此外，这种参数封装还是有些弱的，iOS的SDK要强大一些，直接内置了多次触摸的查询等的支持，OIS为了通用，看来是不行了。

然后，在touchMoved函数中，实现了camera的旋转。

```cpp
#if OGRE_PLATFORM == OGRE_PLATFORM_IPHONE
bool OgreFramework::touchMoved(const OIS::MultiTouchEvent &evt)
{
    OIS::MultiTouchState state = evt.state;
    int origTransX = 0, origTransY = 0;
    switch(m_pCamera->getViewport()->getOrientationMode())
    {
        case Ogre::OR_LANDSCAPELEFT:
            origTransX = state.X.rel;
            origTransY = state.Y.rel;
            state.X.rel = -origTransY;
            state.Y.rel = origTransX;
            break;
            
        case Ogre::OR_LANDSCAPERIGHT:
            origTransX = state.X.rel;
            origTransY = state.Y.rel;
            state.X.rel = origTransY;
            state.Y.rel = origTransX;
            break;
            
            // Portrait doesn't need any change
        case Ogre::OR_PORTRAIT:
        default:
            break;
    }
    m_pCamera->yaw(Degree(state.X.rel * -0.1));
    m_pCamera->pitch(Degree(state.Y.rel * -0.1));
    
    return true;
}
#endif
```

大部分代码是为了不同的设备方向而进行的参数调整，其实主要也就是Camera的yaw,pitch旋转而已，有意思的是，touch参数里面的相对值的存在，使得旋转速度的设定非常简洁。

### 调试信息输出

框架类中剩下的还有点用的东西就是调试信息的输出了，代码如下：

```cpp
//|||||||||||||||||||||||||||||||||||||||||||||||
void OgreFramework::updateStats() 
{ 
    static String currFps = "Current FPS: "; 
    static String avgFps = "Average FPS: "; 
    static String bestFps = "Best FPS: "; 
    static String worstFps = "Worst FPS: "; 
    static String tris = "Triangle Count: "; 
    static String batches = "Batch Count: "; 
    
    OverlayElement* guiAvg = OverlayManager::getSingleton().getOverlayElement("Core/AverageFps"); 
    OverlayElement* guiCurr = OverlayManager::getSingleton().getOverlayElement("Core/CurrFps"); 
    OverlayElement* guiBest = OverlayManager::getSingleton().getOverlayElement("Core/BestFps"); 
    OverlayElement* guiWorst = OverlayManager::getSingleton().getOverlayElement("Core/WorstFps"); 
    
    const RenderTarget::FrameStats& stats = m_pRenderWnd->getStatistics(); 
    guiAvg->setCaption(avgFps + StringConverter::toString(stats.avgFPS)); 
    guiCurr->setCaption(currFps + StringConverter::toString(stats.lastFPS)); 
    guiBest->setCaption(bestFps + StringConverter::toString(stats.bestFPS) 
                        +" "+StringConverter::toString(stats.bestFrameTime)+" ms"); 
    guiWorst->setCaption(worstFps + StringConverter::toString(stats.worstFPS) 
                         +" "+StringConverter::toString(stats.worstFrameTime)+" ms"); 
    
    OverlayElement* guiTris = OverlayManager::getSingleton().getOverlayElement("Core/NumTris"); 
    guiTris->setCaption(tris + StringConverter::toString(stats.triangleCount)); 
    
    OverlayElement* guiBatches = OverlayManager::getSingleton().getOverlayElement("Core/NumBatches"); 
    guiBatches->setCaption(batches + StringConverter::toString(stats.batchCount)); 
    
    OverlayElement* guiDbg = OverlayManager::getSingleton().getOverlayElement("Core/DebugText"); 
    guiDbg->setCaption("");
} 
```

都是获取到响应的UI元素，然后进行输出，没有太多好讲的。

## 框架驱动代码

上述的框架还不足以构成一个完成的程序，仅仅是跨平台实现中干了一些脏活，可以跨平台的部分，我们还需要实际的驱动代码来使用这个框架。

这些代码又分两个部分,DemoApp类和AppDelegate类。

### DemoApp:

```cpp
class DemoApp : public OIS::KeyListener
{
public:
    DemoApp();
    ~DemoApp();
    void startDemo();
    void setupDemoScene();
    void setShutdown(bool flag) { m_bShutdown = flag; }
    
    bool keyPressed(const OIS::KeyEvent &keyEventRef);
    bool keyReleased(const OIS::KeyEvent &keyEventRef);
private:
    void runDemo();
    Ogre::SceneNode*            m_pCubeNode;
    Ogre::Entity*               m_pCubeEntity;
    bool                        m_bShutdown;
};
```

很简洁也很直接的定义，没有去继承使用Ogre的ExampleApplication等类。仅仅继承了KeyListener，响应keyPressed和keyReleased，而在iPhone中我们又不用管。

那么，需要看到就是真实创建天空盒和那个癞蛤蟆头的部分了。

```cpp
void DemoApp::startDemo()
{
    new OgreFramework();
    if(!OgreFramework::getSingletonPtr()->initOgre("DemoApp v1.0", this, 0))
        return;
    
    m_bShutdown = false;
    OgreFramework::getSingletonPtr()->m_pLog->logMessage("Demo initialized!");
    setupDemoScene();
    runDemo();
}
```

此函数完成了前面讲到的OgreFramework的创建及初始化，于是，此时，我们Ogre程序需要的root,scene manager, viewport,camera,等东西都已经有了。

下面直接调用setupDemoScene来创建了场景，然后通过runDemo来运行程序(即进入主循环）。

```cpp
void DemoApp::setupDemoScene()
{
    OgreFramework::getSingletonPtr()->m_pSceneMgr->setSkyBox(true, "Examples/SpaceSkyBox");
    OgreFramework::getSingletonPtr()->m_pSceneMgr->createLight("Light")->setPosition(75,75,75);
    m_pCubeEntity = OgreFramework::getSingletonPtr()->m_pSceneMgr->createEntity("Cube", "ogrehead.mesh");
    m_pCubeNode = OgreFramework::getSingletonPtr()->m_pSceneMgr->getRootSceneNode()->createChildSceneNode("CubeNode");
    m_pCubeNode->attachObject(m_pCubeEntity);
}
```

因为初始化完了，那么创建场景的部分就简单了，如上所示，也就几句代码。属于Ogre常规操作，也就不多说了。

```cpp
//|||||||||||||||||||||||||||||||||||||||||||||||
void DemoApp::runDemo()
{
    OgreFramework::getSingletonPtr()->m_pLog->logMessage("Start main loop...");
    
    double timeSinceLastFrame = 0;
    double startTime = 0;
    OgreFramework::getSingletonPtr()->m_pRenderWnd->resetStatistics();
    
    while(!m_bShutdown && !OgreFramework::getSingletonPtr()->isOgreToBeShutDown()) 
    {
        if(OgreFramework::getSingletonPtr()->m_pRenderWnd->isClosed())m_bShutdown = true;
#if OGRE_PLATFORM != OGRE_PLATFORM_IPHONE
        Ogre::WindowEventUtilities::messagePump();
#endif        
        
        if(OgreFramework::getSingletonPtr()->m_pRenderWnd->isActive())
        {
            startTime = OgreFramework::getSingletonPtr()->m_pTimer->getMillisecondsCPU();
            
            
#if OGRE_PLATFORM != OGRE_PLATFORM_IPHONE
            OgreFramework::getSingletonPtr()->m_pKeyboard->capture();
#endif
            OgreFramework::getSingletonPtr()->m_pMouse->capture();
            OgreFramework::getSingletonPtr()->updateOgre(timeSinceLastFrame);
            OgreFramework::getSingletonPtr()->m_pRoot->renderOneFrame();
        
            timeSinceLastFrame = OgreFramework::getSingletonPtr()->m_pTimer->getMillisecondsCPU() - startTime;
        }
        else
        {
#if OGRE_PLATFORM == OGRE_PLATFORM_WIN32
           Sleep(1000);
#elif OGRE_PLATFORM == OGRE_PLATFORM_APPLE
           sleep(1000);
#endif
        }
    }
    OgreFramework::getSingletonPtr()->m_pLog->logMessage("Main loop quit");
    OgreFramework::getSingletonPtr()->m_pLog->logMessage("Shutdown OGRE...");
}
```

看完这里，代码上是没有什么疑问了，主循环嘛。。。。。。。。不过，对于代码实现的问题上，还是有些问题的，从前面的代码来看，主循环通过while(!m_bShutdown && !OgreFramework::getSingletonPtr()->isOgreToBeShutDown())控制，而且里面完全没有帧率控制代码。。。。也没有使用Ogre在教程中提倡的使用FrameListeners的frameRenderingQueued回调函数来完成update，这个感觉比较奇怪。

而假如是通过if(OgreFramework::getSingletonPtr()->m_pRenderWnd->isActive())即，是否Actice来控制帧率也不正常，这个应该是窗口在后台不需要处理输入的时候使用的，而且一次sleep了1秒钟，也不可能胜任这个工作。

带着疑问调试此函数的代码，发现根本没有调用此函数。。。。。。-_-!

这里搞这么多#if OGRE_PLATFORM != OGRE_PLATFORM_IPHONE，结果iPhone中根本不调用，还是比较具有迷惑性的。。。。。。

真实的版本，当然就看AppDelegate了，AppDelegate是ObjC类。。。。。。看到这里，突然感觉，我虽然仅仅是最近用了几个月的ObjC，但是因为最近一直在用Objc，竟然感觉比用了好几年的C++更加亲切了。。。。。-_-!

### AppDelegate

在main函数中，首先看到AppDelegate的使用：

```objc
int main(int argc, char **argv)

#endif

{
#if OGRE_PLATFORM == OGRE_PLATFORM_IPHONE

  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  int retVal = UIApplicationMain(argc, argv, @"UIApplication", @"AppDelegate");

  [pool release];

  return retVal;

#else

}
```

所以，我原本以为AppDelegate就是一个从ObjC到DemoApp的一个小外壳而已，处理一些简单的delegate回调，结果发现根本不是这样，在iPhone版本的示例程序中，AppDelegate才是实际的DemoApp，而原来DemoApp，其实AppDelegate只是使用了其setup场景的部分而已。原来我也是只猜到了开始，但是猜不到这个结果。。。。。。。

在applicationDidFinishLaunching中经过了一些在iPhone中必须进行的一些window,view操作后，直接进入了主题，go函数，看看go函数：

```objc
- (void)go {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  try {
    new OgreFramework();
    if(!OgreFramework::getSingletonPtr()->initOgre("DemoApp v1.0", &demo, 0))
      return;
    
    demo.setShutdown(false);
    
    OgreFramework::getSingletonPtr()->m_pLog->logMessage("Demo initialized!");
    
    demo.setupDemoScene();
    OgreFramework::getSingletonPtr()->m_pRenderWnd->resetStatistics();
    
    if (mDisplayLinkSupported)
    {
      
// CADisplayLink is API new to iPhone SDK 3.1. Compiling against  
earlier versions will result in a warning, but can be dismissed

      
// if the system version runtime check for CADisplayLink exists in  
-initWithCoder:. The runtime check ensures this code will

      // not be called in system versions earlier than 3.1.

      mDate = [[NSDate alloc] init];

      mLastFrameTime = -[mDate timeIntervalSinceNow];
      
      mDisplayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(renderOneFrame:)];
      [mDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    else
    {
      mTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0f / 60.0f) * mLastFrameTime
                                                target:self
                                              selector:@selector(renderOneFrame:)
                                              userInfo:nil
                                               repeats:YES];
    }
  } catch( Ogre::Exception& e ) {
    std::cerr << "An exception has occurred: " <<
    e.getFullDescription().c_str() << std::endl;
  }

  [pool release];
}
```

原来这才是真正驱动OgreFramework的地方啊。。。。。。前面那都是迷惑人的。。。。

```cpp
    new OgreFramework();
    if(!OgreFramework::getSingletonPtr()->initOgre("DemoApp v1.0", &demo, 0))
      return;
    
    demo.setShutdown(false);
    
    OgreFramework::getSingletonPtr()->m_pLog->logMessage("Demo initialized!");
    
    demo.setupDemoScene();
```

在iPhone版本中，在go函数中进行了OgreFramework的创建及初始化，然后调用demo的setupDemoScene进行场景的创建（前面分析的也就这一部分是对的了。。。。。。其他demo部分分析仅适用于其它版本）。

```objc
    if (mDisplayLinkSupported)
    {
      
// CADisplayLink is API new to iPhone SDK 3.1. Compiling against  
earlier versions will result in a warning, but can be dismissed

      
// if the system version runtime check for CADisplayLink exists in  
-initWithCoder:. The runtime check ensures this code will

      // not be called in system versions earlier than 3.1.

      mDate = [[NSDate alloc] init];

      mLastFrameTime = -[mDate timeIntervalSinceNow];

      [mDisplayLink setFrameInterval:mLastFrameTime];

      [mDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
```

可以看到此处是通过iPhone的CADisplayLink类来完成刷新及帧率控制的，（前面还特意检查了版本，以判断当前iPhone版本是否支持此特性，3.1以后才有的东西）而renderOneFrame里面的内容很简单，这里就不讲了。

看看CADisplayLink吧，在apple的文档中，有如下描述：

A CADisplayLink object is a timer object that allows your application to synchronize its drawing to the refresh rate of the display.

很明显，这个iPhone平台特定的东西估计要比Ogre跨平台的FrameListener要好用一些，所以此基础框架程序中使用了这个iPhone原生的东西。

不过这个代码有个问题：

```objc
      mDate = [[NSDate alloc] init];
      mLastFrameTime = -[mDate timeIntervalSinceNow];
      [mDisplayLink setFrameInterval:mLastFrameTime];
```

此时mLastFrameTime一般是个远小于1的变量，而在apple的文档中有如下描述：

frameInterval

The number of frames that must pass before the display link notifies the target again.

@property(nonatomic) NSInteger frameInterval

Discussion

The default value is 1, which results in your application being notified at the refresh rate of the display. If the value is set to a value larger than 1, the display link notifies your application at a fraction of the native refresh rate. For example, setting the interval to 2 causes the display link to fire every other frame, providing half the frame rate.

Setting this value to less than 1 results in undefined behavior and is a programmer error.

注意最后一句。。。。。。设置成小于1的值会导致未定义行为，并且是一个错误。。。。。既然默认是1，那么其实后面的frameInterval根本不用设置。（原程序能够正常的运行，估计apple还是进行了一定的错误处理，当小于1时还是设置成1了）为了安全起见，这一句还是删掉吧。事实上，删掉后，运行还是正常，此时使用默认值1，也就是每次显示刷新调用一次此函数。

相对的，看Cocos2D for iPhone的代码，现在默认的director类CCDisplayLinkDirector，对DisplayLink的使用实现代码如下：

```objc
    int frameInterval = (int) floor(animationInterval_ * 60.0f);
    
    CCLOG(@"cocos2d: Frame interval: %d", frameInterval);
    displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(preMainLoop:)];
    [displayLink setFrameInterval:frameInterval];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
```

注意，这里的animationInterval是秒为单位的表示时间间隔的变量，但是这里没有直接使用此变量来设定frameInterval，而是乘以了60，（Cocos认为iPhone设备的刷新率近似为60）应该来说，这才是正确用法。。。。。。。我看来可以向Ogre的开发组提交个bug了。。。。。。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
