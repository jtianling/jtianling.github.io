---
layout: post
title: "在iPhone游戏中Ogre的UI选择和Ogre的内置UI学习"
categories:
- iOS
- "图形技术"
- "游戏开发"
tags:
- Ogre
- UI
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '76'
  ks_metadata: a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:0:"";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:0:"";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:0:"";s:6:"robots";s:12:"index,follow";}
  _edit_last: '1'
  _wp_old_slug: "%0d%0a%20%20%20%20%20%20%20%20%e5%9c%a8iphone%e6%b8%b8%e6%88%8f%e4%b8%adogre%e7%9a%84ui%e9%80%89%e6%8b%a9%e5%92%8cogre%e7%9a%84%e5%86%85%e7%bd%aeui%e5%ad%a6%e4%b9%a0%0d%0a%20%20%20%20%20%20%20%20"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

关于UI的选择，看过一篇比较有意思并且[全面的文章](<http://www.mobilegamebase.com/blog/article.asp?id=33> "全面的文章")，但是里面谈论到的是只做网游时，而对于iPhone这种硬件限制远远多于PC的环境来说（特别是内存紧张），使用Ogre本身就是一种很奢侈的事情了，在UI部分消耗有很多内存，那就几乎没有办法去创建稍微复杂点的场景了，（我尝试过Ogre+Bullet+OgreBullet，在载入一个不复杂的场景，仅包含几十个Box的时候,我的touch 3代就会报内存警告，并且强制程序退出了）所以，在选择UI时，有更多不同的考虑，当然，那些在PC下都有效率问题的UI更加是不用考虑了。

首先说需求，很明显做iPhone游戏，特别是比较简单的iPhone游戏，对UI的需求比做网游要求还是少的，对于我来说，按钮与文字的显示就已经能够包含90%以上的需求了，要是按钮还能够多点定制的灵活性，文字还能够显示中文，然后还有个进度条（用于loading）就完美了，没有其他更多的需求。唯一

知道需求后，就会发现，**[CEGUI](<http://www.cegui.org.uk/wiki/index.php/Main_Page>)  
**  
这个成熟并且有足够灵活性的UI是很多公司开发网游的最爱，但是还是太庞大，太复杂了一些。再加上这里有个人总结过[iphone下UI的选择](<http://www.ogre3d.org/forums/viewtopic.php?f=1&t=58492> "iphone下UI的选择")  
，谈到了CEGUI在iPhone下的问题，所以不予考虑。（虽然这个我以前用过，可能上手会快一些）我认为在前面提及文章中作者最后选择的MyGUI可能都复杂了，加上在网上找了找相关的信息，发现iPhone下也会有[一些问题](<http://www.ogre3d.org/addonforums/viewtopic.php?f=17&t=12180> "一些问题")  
。并且，我发现[官方版本的MyGUI](<http://mygui.info/> "官方版本的MyGUI")  
甚至没有MacOS版本。这个问题太严重了，我还是不想再做吃螃蟹的人了，我需要的东西是那么简单。。。。于是，我决定尝试Ogre的内置UI，（可惜文档太少）假如内置UI不能解决问题，再去考虑其他的UI。

### Ogre内置的UI

说实话，Ogre其实没有内置的UI。。。。。。事实上，demo中那些控件的实现其实都是直接建立在demo工程中的，也就是说，这些UI根本就不是Ogre SDK的一部分，随时有可能被抛弃或者更改，也没有人保证这些代码的稳定性，（所以类的命名上，有Sdk这样特殊的前缀）但是，如上所述，实在是没有太多更好的选择，好在这些代码还是比较简洁（因为Ogre就没有想做一个庞大的UI系统，仅仅是想在demo中有个UI可以使用），就算直接拷贝使用，然后自己维护，都还是可以接受的方案。这些代码都在demo的SDKTrays.h文件中，都在OgreBites命名空间下。

另外，因为这些代码都不是Ogre本身SDK的一部分，(只是demo的一部分）所以，甚至连[API文档](<http://www.ogre3d.org/docs/api/html/modules.html> "API文档")  
都没有，（只有overlay这一层的文档）更别说详细的说明文档了，没有文档，那么源代码就是最好的文档。。。。。。。。

### 使用

这里的使用以Ogre的1.7.2的SDK为起点，不涉及在Windows中的编译等问题。

Sdk相关的文件有两个，（在SDK的包中）分别在目录

OgreSDK_vc9_v1-7-2/Samples/Common/include

OgreSDK_vc9_v1-7-2/include/OGRE

中，但是因为考虑到此文件可能需要自己修改，建议复制一份，改个名字，然后自己包含到工程中使用。

首先，创建你自己的SdkTrayManager类型的对象，我推荐弄成单件。在[Ogre VC9 AppWizard](<http://code.google.com/p/ogreappwizards/> "Ogre VC9 AppWizard")  
中的BaseApplication中已经有成员变量mTrayManager了，（standard application模板）并且恰当的初始化了，拿来直接用就可以。

具体控件的使用实在不能再简单了。。。。。

比如label:

mTrayMgr->createLabel(TL_TOPLEFT, "HelloWorldLabel", "HelloWorld");

第一个参数是位置，第二个参数是label对象的名字，第三个参数是label显示的文字。

比如按钮：

创建：

mTrayMgr->createButton(TL_TOPLEFT, "Quit", "Quit");

第一个参数是位置，第二个参数是按钮对象的名字，第三个参数是按钮上显示的文字。

查询状态：（在你的循环逻辑中调用啊，比如frameRenderingQueued）

Button* bt = (Button*)mTrayMgr->getWidget("Quit");

if (bt->getState() == BS_DOWN) {

// put your codes here

}

比如进度条：

创建：

mTrayMgr->createProgressBar(TL_TOPLEFT, "LoadingControl", "Loading", 200.0, 250.0);

最后两个参数一个表示进度条的长度，一个表示注释文字的长度，会在caption的后面建立一个让文字显示非常浅的框。。。。。但是，又没有一个comment文字参数的直接传入，所以你只能靠caption文字自己来设想了。。。。这个设计倒是可以理解，比如初始化读取文件的时候，前面显示标题，后面显示正在读取的文件，但是就是为啥没有一个comment文字参数呢？不理解。而且还去不掉。。。。。

设置进度：（半分比，以0到1的浮点数来表示）

ProgressBar* pb = mTrayMgr->createProgressBar(TL_TOPLEFT, "LoadingControl", "Loading", 200.0, 250.0);

pb->setProgress(.5); // 50%

控件的使用是比较简单的，但是有几个需要注意的地方：

1.假如需要鼠标指针的话（iphone自然不需要了）：

mTrayMgr->showCursor();

2.通过上面的方式控件创建后，会发现caption显示不出来，因为字体还没有载入，需要下列代码：

Ogre::FontManager::getSingleton().getByName("SdkTrays/Caption")->load();

依次创建上述三个控件的效果：

![](http://hi.csdn.net/attachment/201011/9/0_1289316102p87R.gif)

点击I Will Quit按钮，可以正常退出。

有些意思的是同一个位置的控件会自动排列，这点就像qt等UI中的layout，这个非常方便，因为不需要手动指定绝对坐标位置。（比起古老的MFC而言）但是，好像这个layout（先这么称呼吧）只能垂直排列，不能设定为水平排列。

待解决问题：

1.label在文字较长的时候是不会自动扩展大小的（按钮会）。

2.这些UI还是太简单了，起码的自定义图片按钮都不能做到，别说啥主题切换（换肤）功能了，要是真用这些原始UI做一个游戏，会被别人当作Ogre的demo处理的。。。。-_-！即使通过直接替换这些控件的图片，游戏中一个控件也只能有一个样子了，可能会稍微单调一点。。。。。

3.ProgressBar不知道怎么才能方便的使用，现在的设计实在有问题的太离谱了。

还好，有了个简单的基础了，这些功能就慢慢自己加吧，说不定哪天提供给有同样需求的兄弟下载。

另外，loading进度条我看到sdkManager里面有个showLoadingBar函数，还没有试用，好用的话，也许可以直接用。

### 实现

Ogre对UI的支持在Overlay这一层（有个OverlayManager），demo的UI就是从这里开始的。  
事件的响应全部通过下列listener的回调，你也能看出大概此套UI关注哪些事件。

/*  
=============================================================================

| Listener class for responding to tray events.

=============================================================================  
*/

class  
SdkTrayListener

{

public  
:

virtual  
~SdkTrayListener() {}

virtual  
void  
buttonHit(Button* button) {}

virtual  
void  
itemSelected(SelectMenu* menu) {}

virtual  
void  
labelHit(Label* label) {}

virtual  
void  
sliderMoved(Slider* slider) {}

virtual  
void  
checkBoxToggled(CheckBox* box) {}

virtual  
void  
okDialogClosed(const  
Ogre::DisplayString& message) {}

virtual  
void  
yesNoDialogClosed(const  
Ogre::DisplayString& question, bool  
yesHit) {}

};

SdkTrayManager  
是从此listener继承来的：

/*  
=============================================================================

| Main class to manage a cursor, backdrop, trays and widgets.

=============================================================================  
*/

class  
SdkTrayManager : public  
SdkTrayListener, public  
Ogre::ResourceGroupListener

虽然SdkTrayManager的主要功能可能与OverlayManager类似，但是因为OverlayManager是个单件，（所以实际也就决定了不方便继承使用）所以，实际每次用到的时候直接获取此类的对象然后使用即可。

事件的响应部分，和CEGUI等UI类似，利用了一个injectXX接口，这里就不多说了。

然后，所有的控件有个基类：Widget

此类中有3个成员变量：

Ogre::OverlayElement* mElement;

TrayLocation mTrayLoc;

SdkTrayListener* mListener;

OverlayElement自然是与OverlayManager配合使用的，TrayLocation用于表示位置，Listener就是前面那个，这里也看出一些问题，即使是个按钮，也会有个这样庞大的listener。。。。这个可能与C++的没有方便的回调或者协议使用方式有关，假如Ogre愿意为此使用信号或者消息模式，就不需要这样，不然的话，为每个类型的控件建立单独的listener类是最好的办法，Ogre的这个UI又仅仅是设计给demo用的，不想弄那么复杂，所以就用了这种非常丑陋的用法。于是，你甚至可以在一个按钮控件中等待按钮根本不会响应的事件。

具体的控件，以按钮为例：

class Button : public Widget

按钮继承自Widget，有下列成员变量：

ButtonState mState;

Ogre::BorderPanelOverlayElement* mBP;

Ogre::TextAreaOverlayElement* mTextArea;

bool mFitToContents;

mState自然表示按钮的状态：

enum ButtonState // enumerator values for button states

{

BS_UP,

BS_OVER,

BS_DOWN

};

BorderPanelOverlayElement提供了一个有边框的Overlay元素。（因为Widget已经包含了一个OverlayElement，可以看出此UI的设计上还是有些问题，可能毕竟是仅仅设计给Demo用的东西吧）

TextAreaOverlayElement提供一个文字Overlay元素。

按钮就是一个有边框的，可选显示文字，能够反映点击状态的控件，上述成员变量可以完全的诠释按钮。。。。。。

mFitToContents变量就是使得按钮可以自动扩展适应文字宽度的值，当手动设定按钮宽度时为false，不然就是true。label中就是没有这样的配置，然后就不能自适应。

实现上，在setCaption中会有

if (mFitToContents) mElement->setWidth(getCaptionWidth(caption, mTextArea) + mElement->getHeight() - 12);

这个操作。label没有。

稍微浏览了一下源码，基本上没有太多内容。。。。。。。

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

 
