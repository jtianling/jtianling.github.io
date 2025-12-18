---
layout: post
title: "一键在剪贴板中进行语法高亮的工具发布"
categories:
- "未分类"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

我一直希望有个工具能够便捷的进行语法高亮，因为很多地方都可以用到。特别是，假如我在Google Document或者Office中编辑文件的时候，或者是在Windows Live Writer中编写博客文章的时候（WLW中有插件支持，但还是没有此工具这么方便，并且现在写博客的时候我已经改用Google Document了），我都希望能便捷的进行语法高亮，但是并不是都那么容易实现。特别是像Google Document这样不支持插件的工具，因为Google Document不支持插件，不能进行语法高亮，所以长时间以来我都不将其作为博客的编写工具，直到，你知道的，我决定写个工具来解决这个问题。于是，就有了今天这个工具。

其实本程序实际是原来的chc2c工具的一个UI版本， _[code-highlight-clipboard2clipboard](<http://code.google.com/p/code-highlight-clipboard2clipboard/>)_ chc2c是一个命令行工具，可能很多人会比较排斥，虽然我建一些快捷方式也能实现比较便捷的效果。当然，怎么说还是UI工具来的方便，此功能托管在Google Code上： _[onekeycodehighlighter](<http://code.google.com/p/onekeycodehighlighter/>) _已经有下载了：[ClipboardHighlighter0.1.rar](<http://onekeycodehighlighter.googlecode.com/files/ClipboardHighlighter0.1.rar>)

因为还是使用Gvim来完成实际工作，所以，[gvim](<http://www.vim.org/> "gvim")的安装还是不可少，假如有人发现绿色版简易版支持语法高亮和ToHtml的vim请推荐给我，我直接放在下载包中，这样大家就可以不用安装gvim了。对了，安装后，将gvim添加到PATH中，这样我才能找到并执行它。

可以通过config.py文件来配置，配置文件中的注释说明的很详细了，简单的修改应该没有问题，config文件本身就是一个python脚本，只要你满足我原来的变量名不变，你可以做很多事情。  
默认情况下，我仅添加了c,cpp,python,java,javascript的语法高亮支持，其他的语法在config中配置吧。config中除了syntaxSupport 以外，都支持动态改变。比如保存的文件名，是否有行号，颜色主题等。

使用中软件为一个任务栏中的图标，右键点击会出现菜单：

![](http://docs.google.com/File?id=dhn3dw87_41cj3xncg2_b)

选中的一栏表示使用的语法高亮语言。使用中将需要进行语法高亮的文字用CTRL-C复制到剪贴板中，然后按Win+Z完成转换，然后就可以直接粘贴到任何支持HTML的地方了。可以是网站的编辑器，可以是Windows live writer，office word，Google Document。。。。。。。。。。你也可以在config.py中配置你想要保存的文件名，直接保存成一个HTML文件。

实际编写的主要工具为PyQt。因为此工具有一些特殊的功能要求，比如全局快捷键，比如用ctypes来调用了Win32的API，比如我要使用System Tray Icon,比如对剪贴板的操作等等等等，我觉得可以将这些例子分为单独的文章来讲解，目前仅贴出一些此工具转换的效果给大家看看。  
下面是一些示例：  
配置文件（Python):

```python
MOD_ALT = 0x0001
MOD_NONE = 0x000
MOD_CONTROL = 0x0002
MOD_SHIFT = 0x0004
MOD_WIN = 0x0008

# the syntax support you want in the trayicon menu
syntaxSupport = ["c", "cpp", "python", "java", "javascript"]

# the global hotkey define,the modifier can be used is listed above.
modifier = MOD_WIN
hotkey = 'Z'

# do you need display line number before every line?
isLineNumber = False

#------------------------------------------------------------------------------------
# you need not change these below at most time if you don't know what it is.
# the color theme you want use. (corresponding to gvim)
color = 'default'

# if you want to save the transformed in a file.   
filename = ''
```

C++:

```cpp
//激活创建OpenGL窗口
**void** EnableOpenGL()
{
PIXELFORMATDESCRIPTOR pfd;
**int** iFormat;

ghDC = GetDC( ghWnd );

ZeroMemory( &pfd;, **sizeof**( pfd ) );
pfd.nSize = **sizeof**( pfd );   
pfd.nVersion = 1; //版本，一般设为1
pfd.dwFlags = PFD_DRAW_TO_WINDOW | //一组表明象素缓冲特性的标志位
PFD_SUPPORT_OPENGL;
pfd.iPixelType = PFD_TYPE_RGBA; //明象素数据类型是RGBA还是颜色索引;
pfd.cColorBits = 32; //每个颜色缓冲区中颜色位平面的数目，对颜色索引方式是缓冲区大小
pfd.cDepthBits = 16;
pfd.iLayerType = PFD_MAIN_PLANE; //被忽略，为了一致性而包含的

iFormat = ChoosePixelFormat( ghDC, &pfd; );//选择一个像素格式

SetPixelFormat( ghDC, iFormat, &pfd; ); //设置到DC中

ghRC = wglCreateContext( ghDC ); //创建绘图描述表
wglMakeCurrent( ghDC, ghRC ); //使之成为当前绘图描述表
}
```

java:

```java
//: holding/AddingGroups.java
package holding; /* Added by Eclipse.py */
// Adding groups of elements to Collection objects.
import java.util.*;

**public** **class** AddingGroups {
**public** **static** **void** main(String[] args) {
Collection collection =
**new** ArrayList(Arrays.asList(1, 2, 3, 4, 5));
Integer[] moreInts = { 6, 7, 8, 9, 10 };
collection.addAll(Arrays.asList(moreInts));
// Runs significantly faster, but you can't
// construct a Collection this way:
Collections.addAll(collection, 11, 12, 13, 14, 15);
Collections.addAll(collection, moreInts);
// Produces a list "backed by" an array:
List list = Arrays.asList(16, 17, 18, 19, 20);
list.set(1, 99); // OK -- modify an element
// list.add(21); // Runtime error because the
// underlying array cannot be resized.
}
} ///:~
```

javascript:

```javascript
// This function recursively looks at Node n and its descendants,   
// converting all Text node data to uppercase
function upcase(n) {
**if** (n.nodeType == 3 /*Node.TEXT_NODE*/) {
// If the node is a Text node, create a new Text node that
// holds the uppercase version of the node's text, and use the
// replaceChild() method of the parent node to replace the
// original node with the new uppercase node.
n.data = n.data.toUpperCase();
}
**else** {
// If the node is not a Text node, loop through its children
// and recursively call this function on each child.
var kids = n.childNodes;
**for**(var i = 0; i < kids.length; i++) upcase(kids[i]);
}
}
```

再来个不一样的，delek主题+行号的Python效果：

```python
1
2 MOD_ALT = 0x0001
3 MOD_NONE = 0x000
4 MOD_CONTROL = 0x0002
5 MOD_SHIFT = 0x0004
6 MOD_WIN = 0x0008
7
8 # the syntax support you want in the trayicon menu
9 syntaxSupport = ["c", "cpp", "python", "java", "javascript"]
10
11 # the global hotkey define,the modifier can be used is listed above.
12 modifier = MOD_WIN
13 hotkey = 'Z'
14
15 # do you need display line number before every line?
16 isLineNumber = True
17
18 #------------------------------------------------------------------------------------
19 # you need not change these below at most time if you don't know what it is.
20 # the color theme you want use. (corresponding to gvim)
21 color = 'delek'
22
23 # if you want to save the transformed in a file.   
24 filename = ''
```

## 

呵呵，效果不错吧？唯一的问题是因为使用了vim，所以总是会弹出一个gvim的窗口，有点影响视觉效果，但是好在不影响使用，对于支持的语法我重新贴一下：

2html a2ps  
a65 aap abap abaqus  
abc abel acedb ada  
aflex ahdl alsaconf amiga  
aml ampl ant antlr  
apache apachestyle arch art  
asm asm68k asmh8300 asn  
aspperl aspvbs asterisk asteriskvm  
atlas autohotkey autoit automake  
ave awk ayacc b  
baan basic bc bdf  
bib bindzone blank bst  
btm bzr c calendar  
catalog cdl cdrdaoconf cdrtoc  
cf cfg ch change  
changelog chaskell cheetah chill  
chordpro cl clean clipper  
cmake cmusrc cobol coco  
colortest conaryrecipe conf config  
context cpp crm crontab  
cs csc csh csp  
css cterm ctrlh cuda  
cupl cuplsim cvs cvsrc  
cweb cynlib cynpp d  
dcd dcl debchangelog debcontrol  
debsources def denyhosts desc  
desktop dictconf dictdconf diff  
dircolors diva django dns  
docbk docbksgml docbkxml dosbatch  
dosini dot doxygen dracula  
dsl dtd dtml dtrace  
dylan dylanintr dylanlid ecd  
edif eiffel elf elinks  
elmfilt erlang eruby esmtprc  
esqlc esterel eterm eviews  
exim expect exports fasm  
fdcc fetchmail fgl flexwiki  
focexec form forth fortran  
foxpro framescript freebasic fstab  
fvwm fvwm2m4 gdb gdmo  
gedcom git gitcommit gitconfig  
gitrebase gitsendemail gkrellmrc gnuplot  
gp gpg grads gretl  
groff groovy group grub  
gsp gtkrc haml hamster  
haskell haste hastepreproc hb  
help hercules hex hitest  
hog hostconf html htmlcheetah  
htmldjango htmlm4 htmlos ia64  
ibasic icemenu icon idl  
idlang indent inform initex  
initng inittab ipfilter ishd  
iss ist jal jam  
jargon java javacc javascript  
jess jgraph jproperties jsp  
kconfig kix kscript kwt  
lace latte ld ldapconf  
ldif lex lftp lhaskell  
libao lifelines lilo limits  
lisp lite litestep loginaccess  
logindefs logtalk lotos lout  
lpc lprolog lscript lsl  
lss lua lynx m4  
mail mailaliases mailcap make  
man manconf manual maple  
masm mason master matlab  
maxima mel messages mf  
mgl mgp mib mma  
mmix mmp modconf model  
modsim3 modula2 modula3 monk  
moo mp mplayerconf mrxvtrc  
msidl msmessages msql mupad  
mush muttrc mysql named  
nanorc nasm nastran natural  
ncf netrc netrw nosyntax  
nqc nroff nsis objc  
objcpp ocaml occam omnimark  
openroad opl ora pamconf  
papp pascal passwd pcap  
pccts pdf perl pf  
pfmain php phtml pic  
pike pilrc pine pinfo  
plaintex plm plp plsql  
po pod postscr pov  
povini ppd ppwiz prescribe  
privoxy procmail progress prolog  
promela protocols psf ptcap  
purifylog pyrex python qf  
quake r racc radiance  
ratpoison rc rcs rcslog  
readline rebol registry  
remind resolv reva rexx  
rhelp rib rnc rnoweb  
robots rpcgen rpl rst  
rtf ruby samba sas  
sass sather scheme scilab  
screen sd sdl sed  
sendpr sensors services setserial  
sgml sgmldecl sgmllnx sh  
sicad sieve simula sinda  
sindacmp sindaout sisu skill  
sl slang slice slpconf  
slpreg slpspi slrnrc slrnsc  
sm smarty smcl smil  
smith sml snnsnet snnspat  
snnsres snobol4 spec specman  
spice splint spup spyce  
sql sqlanywhere sqlforms sqlinformix  
sqlj sqloracle sqr squid  
sshconfig sshdconfig st stata  
stp strace sudoers svn  
syncolor synload syntax sysctl  
tads tags tak takcmp  
takout tar tasm tcl  
tcsh terminfo tex texinfo  
texmf tf tidy tilde  
tli tpp trasys trustees  
tsalt tsscl tssgm tssop  
uc udevconf udevperm udevrules  
uil updatedb valgrind vb  
vera verilog verilogams vgrindefs  
vhdl vim viminfo virata  
vmasm voscm vrml vsejcl  
wdiff web webmacro wget  
whitespace winbatch wml wsh  
wsml wvdial xbl xdefaults  
xf86conf xhtml xinetd xkb  
xmath xml xmodmap xpm  
xpm2 xquery xs xsd  
xslt xxd yacc yaml  
z8a zsh 

支持的颜色主题有：  
blue   
color  
darkblue   
default   
delek   
desert   
elflord   
evening   
koehler   
morning   
murphy   
pablo   
peachpuff   
ron   
shine   
slate   
torte   
zellner 

支持的颜色主题，语言语法都是通过config来配置，其实操作就是选择好语言，copy,Win+Z,paste。。。。。。。。。。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**