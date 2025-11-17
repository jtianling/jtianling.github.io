---
layout: post
title: MacOS中的剪贴板操作 With Objective C
categories:
- "未分类"
tags:
- MacOS
- Objective C
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '22'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

# **MacOS中的剪贴板操作 With Objective C**

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

## 每日废话

从《[Macos中的Mercurial GUI工具Murky试用](<http://www.jtianling.com/archive/2010/02/28/5334380.aspx>)》一文的访问量基本可以看出，国内使用MacOS 的程序员毕竟还是少数…………就如当年关于Linux的文章没啥人看一样。。。。。   
呵呵，但是读者再少，工作还得继续，学习还得继续，我写我的，没人看就当自言自语了。（其实有人看的时候也常常自言自语-_-!） 

## 前言

对于常发博客的我，以前很明智的放弃了Windows Live Writer来写博客，而是转向了Google Document，所以现在即使在MacOS平台，对写博客都没有太大影响，唯一有个问题，对于技术博客，难免会发一些代码，WLW有很多代码高亮插件可用，Google Docs却没有，因此，转向Google Docs写博客后，深度依赖自己写的代码高亮工具（见《[一键在剪贴板中进行语法高亮的工具发布](<http://www.jtianling.com/archive/2010/01/23/5249656.aspx>)》，此工具竟然还有人提Win7总是会出行号的Bug，因为我家的 Win7删了，所以没法试了，起码说明除了我还真有人用^^，其实，说实话，实在太好用了，最新的源码连弹出窗口的问题都解决了）当时为了方便，使用了一些平台相关特性，并且是用PyQt完成的，所以现在在MacOS中没得用了。。。。。郁闷啊，首先解决这个问题吧。   
本来还是可以使用Qt的，会省很多事，一些东西也不用学了，在Windows，Linux平台我就这样做了，但是我刚接触MacOS,出于学习的目的，我还是使用Objective C With Cocoa来完成，鉴于国内MacOS玩家本来就不多，Objective C玩家就更少了，对本文不做太高期待了…………   
因为上述原因，本文自然还无法实现语法高亮了，见谅，还好发现XCode中的代码复制过来使用RTF格式的，虽然无法实现高亮（Google Docs不知道以RTF格式读取）缩进格式还在，不幸中的万幸了。 

## 真的开始

参考2指出，MacOS中粘贴板服务是一个独立的进程，名为/usr/bin/pboard，验证一下：   
$ ps -A | grep pboard   
81 ?? 0:00.00 /usr/sbin/pboard   
408 ttys000 0:00.00 grep pboard 

看来没有错。   
先看看基本的使用：   
因为没有发现命令行下编程使用MacOS剪贴板的办法，所以再简单的测试也使用窗口程序了，先用XCode建立一个Cocoa程序，我这里命名为MacPasteboardTest，   
然后用 Interface Builder拖入一个多行的Text Filed用于显示剪贴板的内容。（Windows下叫clipboard，MacOS下叫Pasteboard。）嫌麻烦，按钮都省了，直接通过菜单绑定action，这样还能使用快捷键：）   
另外，为了简化程序，我直接使用自动生成的程序的委托类了，不建立自己的类了 

### MacPasteboardTestAppDelegate.h：

#import Cocoa.h> <br >   
@interface MacPasteboardTestAppDelegate : NSObject  {   
NSWindow *window;   
NSTextField *textField;   
} 

@property (assign) IBOutlet NSWindow *window;   
@property (nonatomic, retain) IBOutlet NSTextField *textField; 

\- (IBAction) cut:(id)sender;   
\- (IBAction) copy:(id)sender;   
\- (IBAction) paste:(id)sender; 

@end 

### MacPasteboardTestAppDelegate.m

#import "MacPasteboardTestAppDelegate.h" 

@implementation MacPasteboardTestAppDelegate 

@synthesize window;   
@synthesize textField; 

\- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {   
// Insert code here to initialize your application   
} 

\- (void)writeToPasteboard:(NSPasteboard *)pb withString:string{   
[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType]   
owner:self];   
[pb setString:string forType:NSStringPboardType];   
} 

\- (BOOL)readFromPasteboard:(NSPasteboard *)pb {   
NSArray *types = [pb types];   
if ([types containsObject:NSStringPboardType]) {   
NSString *value = [pb stringForType:NSStringPboardType];   
  
[[self textField] setStringValue:value];   
return YES;   
}   
  
return NO;   
} 

\- (IBAction)cut:(id)sender {   
[self copy:sender];   
[[self textField] setStringValue:@""];   
} 

\- (IBAction)copy:(id)sender {   
NSPasteboard *pb = [NSPasteboard generalPasteboard];   
[self writeToPasteboard:pb withString:[textField stringValue]];   
} 

\- (IBAction)paste:(id)sender {   
NSPasteboard *pb = [NSPasteboard generalPasteboard];   
if( ![self readFromPasteboard:pb] ) {   
NSBeep();   
}   
} 

@end 

然后，将菜单对应的cut,copy,paste的action都与此委托类的相应action绑定就好了。（类似的话都是对知道的人太多了，对于不知道的人这样说估计还是不懂，推荐不懂的可以去看看某个Hello World教程，那样都会了。）   
这里，最最主要的就是使用NSPasteboard这个系统类了，所有的剪贴板操作都依赖于它。这样实现后，基本与参考2中21章的程序差不多了，此例中因为觉得考虑Selected字符串等情况较为麻烦，所有的操作都是直接针对控件的整个字符串，所以有点不符合操作习惯，需要注意一下，因为现在的主题是剪贴板，这些就算了。 

## 剪贴板内容的类型

可惜的是原书也仅仅这样点到为止了。我的需要更多，所以我需要进一步的挖掘剪贴板的功能，我的目标是直接复制HTML内容到Google Docs中，并且可以正常识别，因为以前的学习经验，知道这牵涉到剪贴板的内容类型，比如上例中都是NSStringPboardType类型。参考2一共列出了17种各种各样的类型，可惜没有HTML类型，我很惊讶，查了查文档，参考2太老了，MacOS 10.5就有HTML类型了，但是剪贴板的类型字符串在MacOS 10.6有了较大的改变，应该仅仅是从非常量改成常量了，使用应该差不多，为了兼容性，我还是使用MacOS 10.5那种非常量的吧。   
文档：   
Types for Standard Data (Mac OS X 10.5 and earlier)   
The NSPasteboard class uses the following common pasteboard data types. 

NSString *NSStringPboardType;   
NSString *NSFilenamesPboardType;   
NSString *NSPostScriptPboardType;   
NSString *NSTIFFPboardType;   
NSString *NSRTFPboardType;   
NSString *NSTabularTextPboardType;   
NSString *NSFontPboardType;   
NSString *NSRulerPboardType;   
NSString *NSFileContentsPboardType;   
NSString *NSColorPboardType;   
NSString *NSRTFDPboardType;   
NSString *NSHTMLPboardType;   
NSString *NSPICTPboardType;   
NSString *NSURLPboardType;   
NSString *NSPDFPboardType;   
NSString *NSVCardPboardType;   
NSString *NSFilesPromisePboardType;   
NSString *NSMultipleTextSelectionPboardType; 

Types for Standard Data (Mac OS X 10.6 and later)   
The NSPasteboard class uses the following constants to define UTIs for common pasteboard data types. 

NSString *const NSPasteboardTypeString;   
NSString *const NSPasteboardTypePDF;   
NSString *const NSPasteboardTypeTIFF;   
NSString *const NSPasteboardTypePNG;   
NSString *const NSPasteboardTypeRTF;   
NSString *const NSPasteboardTypeRTFD;   
NSString *const NSPasteboardTypeHTML;   
NSString *const NSPasteboardTypeTabularText;   
NSString *const NSPasteboardTypeFont;   
NSString *const NSPasteboardTypeRuler;   
NSString *const NSPasteboardTypeColor;   
NSString *const NSPasteboardTypeSound;   
NSString *const NSPasteboardTypeMultipleTextSelection;   
NSString *const NSPasteboardTypeFindPanelSearchOptions; 

需要注意的是，NSSring本身就是常量，这里所谓从非常量到常量其实是对该指针值而言的，从NSString *到NSString *const的区别在于，NSString *值的指针可以改变指向（虽然不能改变内容，但是对于系统常量来说还是非常危险啊，这应该算是设计缺陷了，所以MacOS 10.6修改过来了），NSString *const的就是无论内容，指向都不能改了。类似于C++中const *及 const * const的区别。这里展示一下这个危险性（勿学），同时使用HTML类型试试，看能不能达到我想要的与Google Docs兼容的效果。   
\- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {   
// Insert code here to initialize your application   
  
// notice!It's ugly but legality.   
NSStringPboardType = NSHTMLPboardType;   
} 

这样的代码竟然是合法的，你说苹果不改能行吗？   

![](http://docs.google.com/File?id=dhn3dw87_67ds9tvjdg_b)

如上图所示，NSStringPboardType类型的值已经变了。。。。。。当然，我就需要这个类型，所以我诡异的这样使用了。（勿效仿）可以看出，就算是苹果公司的框架设计者也会犯一些非常低级的错误的。 

## 看看HTML剪贴板的效果

![](http://docs.google.com/File?id=dhn3dw87_68dbz4f7cg_b)

输入上述内容，注意，上面可是带HTML的了啊：）复制，然后在Google Docs中粘贴，如下：   
  

### 我是从MacPasteboardTest复制过来的 

看到了吗？Google Docs识别出来了，就如同我以前在Windows中用Qt实现的一样，HTML内容的剪贴板复制到Google Docs是直接识别的，而不是作为文字常量给输出，那么，事实上，我可以给大家看看将来我的MacOS的语法高亮软件实现的效果了：）   
_//_   
_// MacPasteboardTestAppDelegate.m_   
_// MacPasteboardTest_   
_//_   
_// Created by JTianLing on 3/3/10._   
_// Copyright 2010 JTianLing. All rights reserved._   
_//_

#import "MacPasteboardTestAppDelegate.h"

**@implementation** MacPasteboardTestAppDelegate 

@synthesize window;   
@synthesize textField; 

\- (**void**)applicationDidFinishLaunching:(NSNotification *)aNotification {   
_// Insert code here to initialize your application_   
  
_// notice!It's ugly but legality._   
NSStringPboardType = NSHTMLPboardType;   
} 

\- (**void**)writeToPasteboard:(NSPasteboard *)pb withString:string{   
[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType]   
owner:**self**];   
[pb setString:string forType:NSStringPboardType];   
} 

\- (**BOOL**)readFromPasteboard:(NSPasteboard *)pb {   
NSArray *types = [pb types];   
**if** ([types containsObject:NSStringPboardType]) {   
NSString *value = [pb stringForType:NSStringPboardType];   
  
[[**self** textField] setStringValue:value];   
**return** YES;   
}   
  
**return** NO;   
} 

\- (IBAction)cut:(**id**)sender {   
[**self** copy:sender];   
[[**self** textField] setStringValue:@""];   
} 

\- (IBAction)copy:(**id**)sender {   
NSPasteboard *pb = [NSPasteboard generalPasteboard];   
[**self** writeToPasteboard:pb withString:[textField stringValue]];   
} 

\- (IBAction)paste:(**id**)sender {   
NSPasteboard *pb = [NSPasteboard generalPasteboard];   
**if**( ![**self** readFromPasteboard:pb] ) {   
NSBeep();   
}   
} 

**@end**

效果不错吧：）MacOS版本的Code Highlighter已经不远了。。。。。。。呵呵，别流口水啊。   
  

## 

## 不足之处

做了3个版本的语法高亮软件了，也试用了不少别的Code Highlighter，甚至还有在线版的，其实还是我自己以前做的那个最符合我自己的需求，毕竟，我就是针对Google Docs，我也就只需要HTML格式的剪贴板就可以了。但是，一直以来其实有个地方很不完美，我的语法高亮完全依赖Vim，（当然，依赖也没有什么不好），这是其一，另外，Vim的语法高亮的确是漂亮，但是已经无法复原VS/XCode/Eclipse本身的效果了，但是其实无论从上述哪个IDE中拷贝代码，其实原来的高亮信息其实是在的，只是Google Docs比较蠢(Google Docs is silliness）,仅能识别HTML格式的剪贴板内容不能识别其他内容（比如RTF)。   
举个例子，看看XCode本身的语法高亮内容在剪贴板中的显示：（利用了MacOS 10.6中Finder的Show Clipboard功能，啊？怎么到了这里变成clipboard啊？类的命名全叫pasteboard。。。。唉，估计MacOS与XCode的开发者不是同一批。。。。）   

![](http://docs.google.com/File?id=dhn3dw87_69htdf2pd4_b)

其实语法识别内容是比VIM要多的多的。。。。。注意 cilpboard窗口下面的文字，Clipboard contents: rich text(RTF)，多么笨的Google Docs啊，连RTF都识别不了。。。。。。。。。。其实，最最好的解决方案应该是为Google Docs开发插件，以直接识别RTF格式，再次一点的，就是制作一个RTF->HTML的软件然后再到Google Docs中了。。。。。有时间我尝试一下吧。 

## 最后

第一次在Mac Book上写技术博客，这么点的东西花了我一个晚上。。。。。。。。悲哀。。。。。。毕竟对XCode和Objective C还是不太熟悉啊，当然，MacOS下的输入也不算太好，苹果的笔记本键盘嘛。。。。其实我感觉有点硬，达不到运指如飞的境界。。。。呵呵，扯远了。 

## 参考

1.《Objective-C 2.0 程序设计》Stephen G. Kochan著   
2.《苹果开发之Cocoa编程》第三版 Aaron Hillegass著   
3\. 苹果在线文档   

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
