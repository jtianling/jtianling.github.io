---
layout: post
title: 在Unity3D中使用iPhone原生UI(Use iPhone Native UI in Unity3D)
date: 2013-01-11
comments: true
categories: 编程
tags: Cocoa Objective-C Unity3D iOS
---
 
众所周知, Unity中没有提供UI解决方案, 只能靠第三方的插件来完成.  比较著名的有NGUI等, 但是这种方案不仅需要额外付费(虽然不多), 并且类似NGUI的插件还不那么易用, 使用起来过于复杂.  
这里我尝试使用iPhone的原生UI(Cocoa Touch)来作为Unity的UI.  这个听起来似乎很容易的事情, 其实却比我想象的要难的多的多.  主要原因就在于Unity根本就不是想让你这么用的, 3D引擎为了效率, 一般都需要比较专横的占用系统资源, 在本来速度有限的移动平台就更加需要这样了, 这样才能发挥出硬件的极限水平, 制作出更精良的游戏.  鉴于这个原因, 这种方法并不适于性能要求高的游戏.  

<!-- more -->
<!-- toc-begin -->
**目录**:

* [用原生UI的优点](#用原生ui的优点)
* [用原生UI的缺点](#用原生ui的缺点)
* [开发环境](#开发环境)
* [基础: Unity 插件编写(managed-to-unmanaged)](#基础-unity-插件编写-managed-to-unmanaged)
* [原生代码调用Unity的Script代码(native-to-managed)](#原生代码调用unity的script代码-native-to-managed)
* [UnitySendMessage的一个研究](#unitysendmessage的一个研究)
* [显示原生UI的尝试(Try to use Native UI in Unity)](#显示原生ui的尝试-try-to-use-native-ui-in-unity)
 * [UI显示](#ui显示)
 * [UI + Unity](#ui-unity)
* [总结](#总结)
* [参考](#参考)

<!-- toc-end -->

# 用原生UI的优点

* 易用: 原生UI的使用简单, 可用的第三方界面库也很丰富, 特别是对于已经有很多iOS app开发经验的人来说.
* App风格: 风格上可以很贴近原生app, 假如真有这样的需求, 那么这个优势是无限大的, 要在Unity去模拟iOS Native UI是个能让开发者自杀的需求.  要是模拟的不到位, 更加会不伦不类.  
* 免费: 因为NGUI等第三方的UI插件比起Unity本身来说并不贵, 所以这也不算多大的好处.  

# 用原生UI的缺点

* 自定义功能弱: 要是需要一个很牛, 很炫的UI, 特别是想要3D效果的UI, 自定义起来, 还是类似NGUI的UI插件要更加强大和方便.  
* 效率更低: 比起在Unity中直接绘制UI, 用原生UI效率要更低, 这个很好理解, 因为在Unity中绘制UI时, Unity可以尽可能的优化, 用尽量少的draw call去绘制UI, 而Native UI并不受控制.  
* 不跨平台: 假如你用了iOS的原生UI, 那么你就无法简单的把游戏移植到其他平台了, 起码UI部分你得完全重做.  
* 开发麻烦: 作为不能跨平台的衍生问题, 本来Unity的游戏你可以完全在PC/Mac上开发和运行, 然后最后在iPhone/Android上发布, 而一旦用了原生的UI, 几乎是必然的, 你运行时一定需要在设备上才能运行.  这不仅是原生UI的限制, Unity的对iOS的插件机制也有这样的要求.  另外, 大家都知道, 一旦牵涉到跨语言的开发, 调试起来就会很麻烦, 用原生UI也不例外, 这算是另外一个增加了开发难度的事情.  
* 最后一个问题, 而且是最重要的问题是, 从Unity生成一个XCode工程, 然后到XCode编译完成, 再到载入真机的过程是相当~相当~相当~相当~相当的漫长, 真的很长, Unity的技术团队简直是担心C#的开发着享受不到C++开发者的福利啊~~~~呵呵, C++开发者, 你懂的.   
![代码正在编译](/public/images/2013/code_is_compiling.png)  
但是, 在这种情况下, 开发效率会受到相当~相当~相当~相当~相当大的影响, 相信我, 买个好机器吧... 或者, 哭去吧...  

# 开发环境
以下所有代码仅在Mac OS X 10.8.2, Unity 4.0.0f7, XCode 4.5.2(4G2008a) 环境下测试, 其他环境不保证可用.  

# 基础: Unity 插件编写(managed-to-unmanaged)
这是在Unity中使用Objective-C的唯一方法.  所以这是使用原生UI的基础, 首先简述一下.  
主要参考Unity的文档[*Plugins (Pro/Mobile-Only Feature)*](http://docs.unity3d.com/Documentation/Manual/Plugins.html)和[*Building Plugins for iOS*](http://docs.unity3d.com/Documentation/Manual/PluginsForIOS.html)

步骤:
1.在Unity的脚本中使用 `[DllImport ("__Internal")]` 特性(attribute)来标识用Objective-C/C++实现的函数. 如下:

~~~ csharp
[DllImport ("__Internal")]
private static extern float FooPluginFunction ();
~~~

2.其次, 在Objective-C/C++中用`extern "C"`标识接口:  

~~~ objc
// .mm
extern "C" {
	float FooPluginFunction () {
		return 10.1f;
	}
}
~~~

3.全部的C#文件实现为一个组件(即继承于`MonoBehavior`如下:  

~~~ csharp
using UnityEngine;
using System.Runtime.InteropServices;

public class NativeBinding : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	[DllImport ("__Internal")]
	private static extern float FooPluginFunction();
	
	void Awake() {
		print (FooPluginFunction());
	}
}
~~~

注意`using System.Runtime.InteropServices;`必不可少.  
然后, 当然将这个组件绑定到某个对象上也是必不可少, 不然`Awake`永远不会运行.  

4.在最新版的Unity中, 多了个很方便的特性.  当把原生代码放在Assets/Plugins/iOS中时(不允许再有子目录了), 在生成XCode工程的后, 代码都会放在`Libraries`中, 解决了以前生成工程后还需要自己添加代码的问题.  

编译运行后可以看到会输出`10.1`(一定能够要真机运行).

# 原生代码调用Unity的Script代码(native-to-managed)
通过`UnitySendMessage`函数, 有个问题是似乎没法获得返回值.  还是接上个例子, 通过反过来调用的方式, 输出10.1后再输出一个10.2.  

~~~ objc
// .mm
extern "C" {
	float FooPluginFunction () {
		UnitySendMessage("Main Camera", "Print", "10.2");
		return 10.1f;
	}
}
~~~

上述代码就能直接调用`Main Camera`的`Print`函数.  

~~~ csharp
void Print(string message) {
	print (message);
}
~~~

需要注意的是, 上述调用并不是同步的,, 所以能看到, 虽然上述代码是先调用的`UnitySendMessage`函数, 但是实际上, `10.2`字符串输出的会晚于`10.1`, 官方文档说`UnitySendMessage`会在下一帧被调用.  
可以看到这个接口带来的问题不仅不能返回值, 同时传递的参数还只能是字符串.  

# UnitySendMessage的一个研究
我看的这个接口的第一反应是, 这个`UnitySendMessage`在Unity中用的是`SendMessage`实现的, 因为一个Unity对象绑定的组件可能有多个, 也可能有多个同样命名的函数, 此时会同时调用所有符合条件的函数, 这体现了Unity整体设计的动态性.  事实检验, 果真如此.  

# 显示原生UI的尝试(Try to use Native UI in Unity)
这是本文真正想做的事情. 在互联网上搜了一圈, 问这个问题的多, 但是知道回答的太少.  我想可能需要我写完本文后给他们一一回答... 是不是有些托大啊-_-!  

## UI显示
首先, 讲前面的知识用上, 并且取个厚道的名字:

~~~ objc
// .h
#import <Foundation/Foundation.h>

// .mm
#import "NativeBinding.h"
extern "C" {
	void _ActivateUI() {
	}

	void _DeactivateUI() {
	}
}
~~~

然后, 添加一个我们用于显示UI的类.  我这里直接用XCode生成了.  其他代码都不变, 增加一个单件的接口和实现. 代码就很简单了.   

~~~ objc
// .h
#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

+ (id) sharedManager;

@end

// .mm
#import "RootViewController.h"

static RootViewController *sharedRootViewController = nil;

@interface RootViewController ()

@end

@implementation RootViewController

+ (id) sharedManager {
	if (!sharedRootViewController) {
		sharedRootViewController = [[self alloc] initWithNibName:nil bundle:nil];
	}
	
	return sharedRootViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
		self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
		if (self) {
				// Custom initialization
		}
		return self;
}

- (void)viewDidLoad
{
		[super viewDidLoad];
		// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
		[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}

@end
~~~

然后把`RootViewController`的显示代码加入到Script调用中去, 怎么加呢? 最关键的代码是在:  

~~~ objc
UIWindow *window = [[UIApplication sharedApplication] keyWindow];
~~~

不需要琢磨OpenGL的那个View怎么改了, 取得`keyWindow`就行了.  然后就是`addSubView`的事情而已了.  
完整的代码如下:  

~~~ objc
// .mm
#import "NativeBinding.h"
#import "RootViewController.h"

extern "C" {

	void _ActivateUI() {

		//Get the applications UIWindow
		UIWindow *window = [[UIApplication sharedApplication] keyWindow];

		NSLog(@"window = %@", window);

		//Create the RootViewController from a XIB file.
		RootViewController *rootViewController = [RootViewController sharedManager];

		//Add the RootViewController view to the main window.
		[window addSubview: rootViewController.view];
	}

	void _DeactivateUI() {
		if ([RootViewController sharedManager] != nil) {
			// Code ~~
		}
	}

}
~~~

此时只要在Unity中直接调用_ActiveUI就OK了.  

~~~ csharp
using UnityEngine;
using System.Runtime.InteropServices;

public class NativeBinding : MonoBehaviour {

	void Start () {
		ActivateUI();
	}

	[DllImport ("__Internal")]
	private static extern void _ActivateUI();
	
	public static void ActivateUI() {
		print ("ActivateUI");
	
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			_ActivateUI();
		}
	}
	
	[DllImport ("__Internal")]
	private static extern void _DeactivateUI();
	
	public static void DeactivateUI() {
		print ("ActivateUI");
		
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			_DeactivateUI();
		}
	}
}
~~~

这里比前面的代码稍微正式一点, 判断了一下平台, 其他的内容其实已经讲过了.  此时运行程序(还是在真机啊~~~), 然后就能看到一个白屏了.  为了稍微有些内容, 在Interface builder中随意添加控件吧.  一顿乱摆之后:  

![Unity中显示原生UI](/public/images/2013/native_ui_in_unity.png)  

## UI + Unity
这个是第二个难点了, 目前的实现方式有个很大很大的问题, Unity的View全都挡住了, Development编译时右下角那行字都没有了.  这个根本没法用嘛.  
刚开始我还考虑是不是通过分离控件, 即通过将控件的尺寸调整到合适大小, 合适位置, 直接加到keyWindow上去, 后来发现其实没有这个必要, 直接把View的background调整为透明即可... 这个真是比我想象的要简单太多...  
另外, 假如还想更像app呢, 可以在工程配置里面把status bar弄出来.(在Unity生成的工程中, status bar默认隐藏了.)  
下面是显示效果, 为了展示Unity的场景, 我按照惯例显示了一个3D的Hello World, 并且给了一个打了动态光源的球. enjoy it!  
![Unity中混合显示原生UI和Unity场景](/public/images/2013/native_ui_with_unity_screen.png)

# 总结
其实到此为止, 想要实现的功能基本都能实现了, 剩下的也就是一些细节了.  但是, Unity的开发团队都不太推荐这种方式, 同样的, 我也不推荐大家使用... 使用后才能知道到底有多痛苦, 特别是非常非常非常非常漫长的编译过程...

# 参考
Gregg的*An Experiment with iPhone Native UI and Unity 3 Pro*给了我很大的启发.  不知道为什么, Gregg自己把他博客上的文章删掉了-_#

