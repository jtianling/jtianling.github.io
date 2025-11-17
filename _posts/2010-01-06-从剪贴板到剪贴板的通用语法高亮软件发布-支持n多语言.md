---
layout: post
title: "从剪贴板到剪贴板的通用语法高亮软件发布（支持N多语言）"
categories:
- "我的程序"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '11'
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

##  需求来源

    不太喜欢太限制于Windows下的Windows live  
writer（以下简称WLW），虽然很多人认为它是博客写作工具的number  
one，甚至看到有外国的朋友曾经高呼，Linux下唯一缺少替代品的软件就是WLW了，经过长久的使用，本身功能并不算太强大，但是开放的插件系统，让  
其强大到无以复加，我在以前《[windows  
live  
writer  
试用及众多插件试用评测...](<http://www.jtianling.com/archive/2009/10/18/4689516.aspx>)  
  
》  
文中有很详细的描述，过程中也解决过很多WLW本身的问题，比如没有模板的问题，(通过autohotkey解决），比如说本地保存目录不能改变的问题，  
（通过junction来改变）比如在公司及家中文档不能同步的问题，（通过dropbox)，但是越依赖WLW，我就感觉越不舒服，因为我在Linux  
下越来越感觉没有好用的博客写作工具了，而且WLW专有的格式，使得我无法太好的使用已有的文档，这些都是无法忽视的大问题，于是，最终，我决定彻底的迁  
移到Google Document上来，无论是普通的文档，还是Blog的写作。

    首先有个先天性的问题，Google  
Document是没有开发插件系统的，这样，碰到问题我们都没有办法通过扩展来解决，特别突出的问题就是代码高亮问题，对于程序员的博客。。。。。。贴  
代码实在是太经常的事情了，不能解决此问题也是我以前甚至愿意用Word2007来写博客都不用Google  
Document。既然今天决定了使用Google  
Document，那么找个办法来解决此问题吧，方法目前想到一个，HTML的直接插入，（还好Google  
Document支持），那么我只需要将代码在剪贴板中保存为高亮的HTML，然后直接嵌入Google Document就行了，So  
Easy................解决此问题吧，于是就有了我的新工程“[code-highlight-clipboard2clipboard](<http://code.google.com/p/code-highlight-clipboard2clipboard/>)  
”，因为自己写语法分析及高亮的代码实在太麻烦了，只好选择站在巨人的肩膀上：）我利用GVim来解决此问题。（目前使用时需要自己先安装Gvim，并且将其目录加进PATH中，即在任何目录下都能通过gvim命令调用到gvim）

 

## 先看看效果  

 

此文在Google Document下完成，以下是主体源代码的实际转换效果。还算是比较漂亮吧：）

 

```python
from optparse import OptionParser
from distutils.file_util import *
import os
import tempfile

def main():
    usage = 'usage: %prog [options]\n'
    version = '''%prog 0.1 Created By JTianLing

Any Question could be sent to JTianLing{at}Gmail.com,

and any advice or any bug report is appreciated too.
'''
    parser = OptionParser(usage, version = version)
    parser.add_option('-f', '--filename', metavar = 'FILE', dest = 'filename',
                      help = 'Write output to FILE and save it.')
    parser.add_option('-t', '--syntax', action = 'store',
                      type = 'string', dest = 'syntax',
                      default = '',
                      help = 'Set the code syntax type')
    parser.add_option('-c', '--color', action = 'store',
                      type = 'string', dest = 'color',
                      default = 'default',
                      help = 'Set the code highlight color template')
    parser.add_option('-n', action= 'store_true', dest = 'isNumber',
                      default = False,
                      help = 'Is output with line number.')
    (options, args) = parser.parse_args()

    filename = tempfile.mktemp() + '.tmp'

    cboutStr = 'cbout > ' + filename
    os.system(cboutStr)

    syn = options.syntax
    color = options.color

    # ugly but useful vim's format code
    vimCmd = 'gvim -c ":syntax on|:color ' + color + '|:set syn=' + syn + '|:set nu ' + ('' if options.isNumber else '!') + '|TOhtml" -c ":w|:qa" ' + filename
    os.system(vimCmd)
    #print(vimCmd)

    newFilename = filename + '.html'
    cbinStr = 'more ' + newFilename + ' | cbin '
    os.system(cbinStr)

    # Del the temp file when that's needed
    if options.filename:
        move_file(newFilename, './' + options.filename)
    else:
        os.remove(newFilename)

    os.remove(filename)

if __name__ == '__main__':
    main()
```

 

## 使用  

 

除了以上的源代码，我还实现了两个类似于stdin及stdout的与剪贴板相关的cbin,cbout命令(clipboard in or out)。实际使用方法类似stdin及stdout，分别是写入剪贴版中及从剪贴板中读出数据，（只支持文本格式）

其实下一版预计还可以抽出整个转换的过程，那样使用起来可能更加灵活。目前此代码仅在Windows下测试，但是为了兼容，我使用了PyQt的库（所以狂大，其实才几行代码），将来会在Linux下测试及发布Linux的

二进制版本。

 

使用方法是在Google Document中通过（Edit->Edit Html->粘贴->Update），你也可以保存为任何你想要的文件/粘贴到你想要去的任何位置。

命令的使用方法如下：

```bash
chc2c --help
Usage: chc2c [options]

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -f FILE, --filename=FILE
                        Write output to FILE and save it.
  -t SYNTAX, --syntax=SYNTAX
                        Set the code syntax type
  -c COLOR, --color=COLOR
                        Set the code highlight color template
  -n                    Is output with line number.
```

 

## 支持的语言  

 

支持的语言种类/语法格式几乎囊括了常见的所有语言，（仅限制于Vim支持的种类，站在巨人的肩膀上就是好），以下是一个列表：

 

  
2html          a2ps  
a65            aap            abap           abaqus  
abc            abel           acedb          ada  
aflex          ahdl           alsaconf       amiga  
aml            ampl           ant            antlr  
apache         apachestyle    arch           art  
asm            asm68k         asmh8300       asn  
aspperl        aspvbs         asterisk       asteriskvm  
atlas          autohotkey     autoit         automake  
ave            awk            ayacc          b  
baan           basic          bc             bdf  
bib            bindzone       blank          bst  
btm            bzr            c              calendar  
catalog        cdl            cdrdaoconf     cdrtoc  
cf             cfg            ch             change  
changelog      chaskell       cheetah        chill  
chordpro       cl             clean          clipper  
cmake          cmusrc         cobol          coco  
colortest      conaryrecipe   conf           config  
context        cpp            crm            crontab  
cs             csc            csh            csp  
css            cterm          ctrlh          cuda  
cupl           cuplsim        cvs            cvsrc  
cweb           cynlib         cynpp          d  
dcd            dcl            debchangelog   debcontrol  
debsources     def            denyhosts      desc  
desktop        dictconf       dictdconf      diff  
dircolors      diva           django         dns  
docbk          docbksgml      docbkxml       dosbatch  
dosini         dot            doxygen        dracula  
dsl            dtd            dtml           dtrace  
dylan          dylanintr      dylanlid       ecd  
edif           eiffel         elf            elinks  
elmfilt        erlang         eruby          esmtprc  
esqlc          esterel        eterm          eviews  
exim           expect         exports        fasm  
fdcc           fetchmail      fgl            flexwiki  
focexec        form           forth          fortran  
foxpro         framescript    freebasic      fstab  
fvwm           fvwm2m4        gdb            gdmo  
gedcom         git            gitcommit      gitconfig  
gitrebase      gitsendemail   gkrellmrc      gnuplot  
gp             gpg            grads          gretl  
groff          groovy         group          grub  
gsp            gtkrc          haml           hamster  
haskell        haste          hastepreproc   hb  
help           hercules       hex            hitest  
hog            hostconf       html           htmlcheetah  
htmldjango     htmlm4         htmlos         ia64  
ibasic         icemenu        icon           idl  
idlang         indent         inform         initex  
initng         inittab        ipfilter       ishd  
iss            ist            jal            jam  
jargon         java           javacc         javascript  
jess           jgraph         jproperties    jsp  
kconfig        kix            kscript        kwt  
lace           latte          ld             ldapconf  
ldif           lex            lftp           lhaskell  
libao          lifelines      lilo           limits  
lisp           lite           litestep       loginaccess  
logindefs      logtalk        lotos          lout  
lpc            lprolog        lscript        lsl  
lss            lua            lynx           m4  
mail           mailaliases    mailcap        make  
man            manconf        manual         maple  
masm           mason          master         matlab  
maxima         mel            messages       mf  
mgl            mgp            mib            mma  
mmix           mmp            modconf        model  
modsim3        modula2        modula3        monk  
moo            mp             mplayerconf    mrxvtrc  
msidl          msmessages     msql           mupad  
mush           muttrc         mysql          named  
nanorc         nasm           nastran        natural  
ncf            netrc          netrw          nosyntax  
nqc            nroff          nsis           objc  
objcpp         ocaml          occam          omnimark  
openroad       opl            ora            pamconf  
papp           pascal         passwd         pcap  
pccts          pdf            perl           pf  
pfmain         php            phtml          pic  
pike           pilrc          pine           pinfo  
plaintex       plm            plp            plsql  
po             pod            postscr        pov  
povini         ppd            ppwiz          prescribe  
privoxy        procmail       progress       prolog  
promela        protocols      psf            ptcap  
purifylog      pyrex          python         qf  
quake          r              racc           radiance  
ratpoison      rc             rcs            rcslog  
readline       README.txt         rebol          registry  
remind         resolv         reva           rexx  
rhelp          rib            rnc            rnoweb  
robots         rpcgen         rpl            rst  
rtf            ruby           samba          sas  
sass           sather         scheme         scilab  
screen         sd             sdl            sed  
sendpr         sensors        services       setserial  
sgml           sgmldecl       sgmllnx        sh  
sicad          sieve          simula         sinda  
sindacmp       sindaout       sisu           skill  
sl             slang          slice          slpconf  
slpreg         slpspi         slrnrc         slrnsc  
sm             smarty         smcl           smil  
smith          sml            snnsnet        snnspat  
snnsres        snobol4        spec           specman  
spice          splint         spup           spyce  
sql            sqlanywhere    sqlforms       sqlinformix  
sqlj           sqloracle      sqr            squid  
sshconfig      sshdconfig     st             stata  
stp            strace         sudoers        svn  
syncolor       synload        syntax         sysctl  
tads           tags           tak            takcmp  
takout         tar            tasm           tcl  
tcsh           terminfo       tex            texinfo  
texmf          tf             tidy           tilde  
tli            tpp            trasys         trustees  
tsalt          tsscl          tssgm          tssop  
uc             udevconf       udevperm       udevrules  
uil            updatedb       valgrind       vb  
vera           verilog        verilogams     vgrindefs  
vhdl           vim            viminfo        virata  
vmasm          voscm          vrml           vsejcl  
wdiff          web            webmacro       wget  
whitespace     winbatch       wml            wsh  
wsml           wvdial         xbl            xdefaults  
xf86conf       xhtml          xinetd         xkb  
xmath          xml            xmodmap        xpm  
xpm2           xquery         xs             xsd  
xslt           xxd            yacc           yaml  
z8a            zsh              

 

 

是不是比目前存在的所有语法高亮工具支持的语言种类还要多？你要是说你懂的上面没有的语言，我一定认为你是神仙。。。。。。。。。。。。

 

好了，别的不多说了，自己下载试用吧，目前还是0.1版，以后会慢慢增加一些功能的，最主要的是找到一个精简版的vim(目前需要首先自己安装Vim才能使用，并将Vim的目录加入PATH中才能使用）

##  

##  

## 完整源代码获取说明

工程保管在Google上：http://code.google.com/p/code-highlight-clipboard2clipboard/

也可以直接使用Mercurial克隆下库：

[https://code-highlight-clipboard2clipboard.googlecode.com/hg/](<https://blog-sample-code.jtianling.googlecode.com/hg/>)

Mercurial使用方法见《[分布式的，新一代版本控制系统Mercurial的介绍及简要入门](<http://www.jtianling.com/archive/2009/09/25/4593687.aspx>)  
》

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**