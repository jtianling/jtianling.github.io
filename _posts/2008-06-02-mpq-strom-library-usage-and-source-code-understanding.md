---
layout: post
title: MPQ Strom库使用及源代码理解文档
categories:
- "游戏开发"
tags:
- MPQ
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '41'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文深入解析MPQ Storm库源码，详解了打开和读取文件的流程，并剖析了其内部结构、加密与哈希寻址机制。

<!-- more -->

MPQ Strom库使用及源代码理解文档

九天雁翎

读取文件流程:

1. 用要打开文档的文件名调用SFileOpenArchive()函数打开文档,得到打开文档的句柄.
2. 用上步得到的文档句柄,和要打开的文件名调用SFileOpenFileEx()函数,得到打开的文件句柄.
3. 用上步得到的文件句柄,调用SFileReadFile()函数,读取数据.
4. 关闭文件,文档句柄.

各函数调用方式及参数意义参看[MPQ内幕(二).](<http://writeblog.csdn.net/Editor/FCKeditor/editor/MPQ内幕\(二\).mht>)

因为牵涉到太多原始的底层操作,和各样的加密解密,所以看的比较仔细,各函数的实现如下

SFileOpenArchive():

1. 首先调用PrepareStormBuffer(),确保以后调用各解密函数时此Buffer已经初始化.

2. 利用CreateFile()这个windows API打开需要打开的文档.

3. 动态创建一个TMPQArchive类型的变量,保存在名叫ha的指针当中,以后都直接用ha,代表这个变量.

TMPQArchive的原型如下:
```c
struct TMPQArchive
{
    //  TMPQArchive * pNext;               // Next archive (used by Storm.dll only)
    //  TMPQArchive * pPrev;               // Previous archive (used by Storm.dll only)
    char          szFileName[MAX_PATH]; // Opened archive file name
    HANDLE        hFile;                // File handle
    DWORD         dwPriority;           // Priority of the archive
    LARGE_INTEGER ShuntPos;             // MPQShunt offset (only valid if a shunt is present)
    LARGE_INTEGER MpqPos;               // File header offset (relative to the begin of the file)
    LARGE_INTEGER HashTablePos;         // Hash table offset (relative to the begin of the file)
    LARGE_INTEGER BlockTablePos;        // Block table offset (relative to the begin of the file)
    LARGE_INTEGER ExtBlockTablePos;     // Ext. block table offset (relative to the begin of the file)
    LARGE_INTEGER MpqSize;              // Size of MPQ archive

    TMPQFile    * pLastFile;            // Recently read file
    DWORD         dwBlockPos;           // Position of loaded block in the file
    DWORD         dwBlockSize;          // Size of file block
    BYTE        * pbBlockBuffer;        // Buffer (cache) for file block
    DWORD         dwBuffPos;            // Position in block buffer
    TMPQShunt   * pShunt;               // MPQ shunt (NULL if not present in the file)
    TMPQHeader2 * pHeader;              // MPQ file header
    TMPQHash    * pHashTable;           // Hash table
    TMPQBlock   * pBlockTable;          // Block table
    TMPQBlockEx * pExtBlockTable;       // Extended block table

    TMPQShunt     Shunt;                // MPQ shunt. Valid only when ID_MPQ_SHUNT has been found
    TMPQHeader2   Header;               // MPQ header

    TMPQAttr    * pAttributes;          // MPQ attributes from "(attributes)" file (NULL if none)
    TFileNode  ** pListFile;            // File name array
    DWORD         dwFlags;              // See MPQ_FLAG_XXXXX
};
```

4. 找到MPQ文档的开始,意义参看[MPQ文档布局分析](<http://writeblog.csdn.net/Editor/FCKeditor/editor/MPQ文档布局分析.doc>)中对文档头的描述部分.

此步稍微复杂:

首先看一个为TMPQHeader2结构.原型如下:
```cpp
struct TMPQHeader2 : public TMPQHeader
{
    // Offset to the beginning of the extended block table, relative to the beginning of the archive.
    LARGE_INTEGER ExtBlockTablePos;

    // High 16 bits of the hash table offset for large archives.
    USHORT wHashTablePosHigh;

    // High 16 bits of the block table offset for large archives.
    USHORT wBlockTablePosHigh;
};
```

```c
struct TMPQHeader
{
    // The ID_MPQ ('MPQ/x1A') signature
    DWORD dwID;                

    // Size of the archive header
    DWORD dwHeaderSize;           

    // Size of MPQ archive
    // This field is deprecated in the Burning Crusade MoPaQ format, and the size of the archive
    // is calculated as the size from the beginning of the archive to the end of the hash table,
    // block table, or extended block table (whichever is largest).
    DWORD dwArchiveSize;

    // 0 = Original format
    // 1 = Extended format (The Burning Crusade and newer)
    USHORT wFormatVersion;

    // Power of two exponent specifying the number of 512-byte disk sectors in each logical sector
    // in the archive. The size of each logical sector in the archive is 512 * 2^SectorSizeShift.
    // Bugs in the Storm library dictate that this should always be 3 (4096 byte sectors).
    USHORT wBlockSize;

    // Offset to the beginning of the hash table, relative to the beginning of the archive.
    DWORD dwHashTablePos;
   
    // Offset to the beginning of the block table, relative to the beginning of the archive.
    DWORD dwBlockTablePos;
   
    // Number of entries in the hash table. Must be a power of two, and must be less than 2^16 for
    // the original MoPaQ format, or less than 2^20 for the Burning Crusade format.
    DWORD dwHashTableSize;
   
    // Number of entries in the block table
    DWORD dwBlockTableSize;
};
```

实际意义也可以参看看[MPQ文档布局分析](<http://writeblog.csdn.net/Editor/FCKeditor/editor/MPQ文档布局分析.doc>),就是整个文档头的结构.而TMPQHeader, TMPQHeader2,就是wFormatVersion为0,和为1时的两个文档头版本.

这里通过循环来寻找MPQ文档的开头:

{
a.这里首先读取了一个TMPQHeader2的文档头.

b.然后经过恰当的大头小头机数据转换(因为intel是小头机并且是函数实现的默认方式,此步其实完全忽略了,以后不再提及,但实际都需要这一步).

c.在第一次循环的时候通过IsAviFile()函数判断了一下此MPQ文件是否是AVI文件,因为据源代码中注释说明,当MPQ文件实际就是AVI文件的时候,它仅仅是改变了扩展名的AVI文件.(IsAviFile()函数利用AVI文件开始的数据标志实现)

d.当实际读入的数据不等于TMPQHeader2的大小的时候,说明此文件中根本没有MPQ文档,断开循环,并报错ERROR_BAD_FORMAT.

e.判断读入的文档头数据是否指示此文档为一个MPQ shunt的文档.是的话保存相关数据在TMPQShunt结构中.并从 TMPQShunt的dwHeaderPos指示的位置开始继续搜寻MPQ文档.并且从最后Stromlib处理来看,此位置应该是紧接着就是文档头,而不用继续通过跳转512个字节循环搜寻.

```c
struct TMPQShunt
{
    // The ID_MPQ_SHUNT ('MPQ/x1B') signature
    DWORD dwID;

    DWORD dwUnknown;

    // Position of the MPQ header, relative to the begin of the shunt
    DWORD dwHeaderPos;
};
```

因为Shunt部分没有相关文档的说明,从源代码中处理Shunt的方式,命名,TMPQShunt的结构来看,可能这是暴雪为了隐藏真正的MPQ文档而使用的一种机制.首先,一般情况下MPQ文档都是在一个扇区的边界,即512个字节的整数倍处,所以搜寻MPQ文档开头时,都是一次搜寻512个字节.而Shunt结构中用三个字节dwHeaderPos来指定MPQ文档的开始部分,可以离开上述约束.并且Shunt结构的dwID与MPQ文档头的dwID都有"MPQ",无论一般用户是总是通过512字节的整数倍来搜寻MPQ文档头,或是直接碰到"MPQ"就直接开始MPQ文档的读取,还是不理解shunt结构的dwHeaderPos意义,都会导致读取MPQ文档的错误.dwHeaderPos的意义从注释上看还比较特殊,它指示的含义为从一个shunt结构开始的偏转值,而不是相对于整个文件的偏转值,就更加深了理解难度.当然,现在已经有人告诉我们了.....巨人的肩膀上.....

f.此时方才判断, 保存下来的TMPQHeader2结构的dwID成员是否MPQ文档的(即"MPQ"1AH),找到后,将地址结构保存在ha的MpqPos成员变量中.

g.然后再通过判断版本号和获得的文档头大小是否一致来验证获得的文档头是否有效.无效就断开循环,结束查找.注释说明在某些情况下(比如W3M Map Protectors中),暴雪可能会在文档头文件中加入一些无效的干扰数据,而strom.dll文件明显忽略了这些东西,也就是我们没有办法去理解这些数据.继续也是徒劳.这时返回错误信息ERROR_NOT_SUPPORTED.暴雪的加密和干扰手段一个接一个,还不止这些...........

h.在此次循环中,假如ha成员变量的pShunt指针指向不为空,即表示已经经过了一次shunt的跳转,而通过上面几步的判断,此处还是不为文档头,表示文档已经损坏.

i. 指针跳转512个字节,开始下一轮的搜寻.
}

5. 经过上一步,没有错误的话,应该得到了文档头,此步先判断文档头的版本号,是原始版本就清空扩展数据部分.

6. 通过文档头的数据判断,确定dwBlockSize,即一个块的大小,计算方法如MPQ文档布局中指出的512 * (2^扇区偏移大小).stromlib源代码中通过位移来完成,效果一样.

7. 通过RelocateMpqTablePositions()函数得到正确的哈希表和块表的位置.文档头指示的哈希表,块表位置其实都是相对于MPQ文档开始位置而言, 此步的含义在于将其全部转换为相对于整个文件的位置,并保存ha的变量中.同时还得到了整个MPQ文档的大小.

RelocateMpqTablePositions()函数的具体实现步骤如下:
{
a) 先通过GetFileSize()这个windows API函数得到整个文件的大小.

b) 通过将文档头中的哈希表,块表偏移量加上第4步中保存的文档头开始的位置,得到的就是哈希表,块表相对于整个文件开始的偏移量了.

c) 是扩展版本的话,还通过同样的方法,得出了扩展块表相对于整个文件的偏移量.此两步最后都通过和第1步得到的文件大小做比较,确定数据有效.

d) 通过得到块表,哈希表,扩展块表三个中表的最后位置的最大值,来确定整个MPQ文档的结尾(都是利用上几步得到的相对于整个文件开始位置的偏移量来计算的),用此值减去文档头的位置(也是相对于整个文件开始位置的偏移量)来得到整个MPQ文档的大小.

{   
从此步中可以看出的结论是,在MPQ文档结构中,各个表的实际位置不一定会像 <MPQ文档布局分析>中提到的那样,是哈希表,块表,扩展块表的顺序,因为各个表的位置都由文档头精确定位,的确也可以不按此顺序.所以stromlib源代码中通过这种比较复杂的方法来得到整个文档的大小.并且从stromlib的计算方式来看,起码表数据都是放在文档的最后.

可是个人认为太过于复杂,就算三个表的先后顺序是不确定的,但是三个表的所有入口都是一个接一个的,意思就是,不可能三个表混在一起,那么,要得到整个文档的大小,只需要先判断三个表的偏移量哪个最大(在未计算前,文档头中指示的数据都是相对于MPQ文档开始的偏移量),再将最大偏移量的那个值加上其相对应的表大小,得出的偏移量,就是整个MPQ文档的大小,因为此偏移量也是相对与MPQ文档开始的位置而言,并且是文档的结尾.
}
}

8. stormlib源代码中此时为哈希表,块表,扩展块表,块分别分配了空间,并将ha的成员变量中pHashTable, pBlockTable, pExtBlockTable, pbBlockBuffer指向相应地址.假如分配失败,返回ERROR_NOT_ENOUGH_MEMORY.这里stromlib还指出,为了以后文件的添加,块表应该和哈希表一样大.通过这样的方式来避免最后缓存的溢出.

9. 将整个哈希表都读入ha的pHashTalbe指向的空间中.因为已可以计算出哈希表大小,假如读入的数据不对,表示此文档已损坏,返回ERROR_FILE_CORRUPT错误.此时还是加密数据.以"(hash table"为key,调用DecryptHashTable()函数,解密数据.此时stromlib注释中提到, MPQ protectors甚至可能通过重写一部分哈希表来干扰别人的读取,而整个哈希表只要一开始有一个位不对,后面的所有数据都是无效的........暂时不知道怎么检查....

10.将整个块表都读入ha的pBlockTalbe指向的空间中,因为当文件删除时,似乎会出现文档头声明的块表入口数量多于实际块表入口数量的情况,读入的数据少于文档头声明数量时,要以实际读入的数据为准.在解密的时候,为了防止出现原块表头没有加密而重复解密导致错误的情况.stromlib中首先判断了一下原块表是否被加密.( 通过块的位掩码标志位低8位总为零的情况来判断,详见<MPQ文档布局分析>,不为0即加密过的数据)加密的话,以"(block table)"为key调用DecryptBlockTable()函数解密.

11.将整个扩展块表都读入ha的pExtBlockTalbe指向的空间中,原始版本中即将此块清零,燃烧远征版本就读入此数据.stromlib中没有解密过程.就我猜测可能此扩展部分为未加密的原始数据.就暴雪的作风好像很难得,要么就是还没有人分析出扩展块表的解密算法............

12.此时stromlib作者为了确定块表解密正确,进行了一些判断.具体方法就是判断各块表入口指向的地址和指向块的大小是否都在MPQ文档大小以内.不是,自然解密出现了问题,返回错误代码ERROR_BAD_FORMAT.另外,不知道是否是我没有找到,stromlib源代码中定义了 DWORD dwMaxBlockIndex = 0;后就再也没有对其赋过其他值,而直接通过这种方式TMPQBlock * pBlockEnd = ha->pBlockTable + dwMaxBlockIndex + 1;得到块的结尾....似乎有点问题.个人觉得此处的dwMaxBlockIndex应该等于第10步中得到的实际块表入口数量.不然源代码中相当于只验证了第一个块表入口.

13.假如调用时没有在SFileOpenArchive()函数的第三参数指定不打开listfile,那么就将listfile文件读入ha,listfile的具体含义和结构,参看[MPQ文档布局分析](<http://writeblog.csdn.net/Editor/FCKeditor/editor/MPQ文档布局分析.doc>)相关部分.

{
a. 此步首先利用SListFileCreateListFile()函数在ha中为listfile的相关成员变量分配空间.
b. 然后调用SFileAddListFile()函数实际的添加数据.此一步函数相当于整个一个从MPQ文档中读取文件的过程,只不过文件名为"(listfile)".然后通过GetLine()函数每次读取一行并添加到相关链表中而已.
}

14.假如调用时没有在SFileOpenArchive()函数的第三参数指定不读入属性,就调用SAttrFileLoad()函数读入属性数据.此步的实际过程与上面读入listfile很类似,也是一个完整的一个从MPQ文档中读取文件的过程,只不过文件名为" (attributes)".

15.最后,假如中途出现错误,先利用FreeMPQArchive()函数释放ha的空间,再关闭文件句柄,设定错误代码为上述步骤中设定的错误代码值.

16.一切正确的时候, 且全局变量pFirstOpen为空,即将打开文件的句柄赋值给pFileOpen,再赋值给SFileOpenArchive()函数的第四参数,作为一个输出,同时返回ERROR_SUCCESS表示此函数调用成功.

至此, SFileOpenArchive()函数的全过程理解完毕.因为此步的意义在于将一个纯粹二进制的文件的文档头,哈希表,块表,扩展块表,尽量正确的分别读出,解释,保存在一个指向TMPQArchive结构的指针变量ha中.每一步都需要非常正确,容不得一点错误,所以stromlib作者每一步都加入了足够多的错误验证.每一步也都要预防暴雪对文件的加密,所以代码相当的琐碎.理解起来也的确花了过多的时间.

SFileOpenFileEx()

1. 首先验证参数是否都有意义.

2. 当SFileOpenFileEx()函数第三个参数为SFILE_OPEN_BY_INDEX时,即通过文件索引来定位文件,此索引实际就是块表入口的索引,这里需要特别注意的是,此处是索引,就像数组的索引一样,而不是偏移量.就如在<MPQ文档布局分析>中根据哈希表数据猜测的一样,哈希表最后一个值实际也是记录对应块表的索引,而不是偏移量.所以,此步就是遍历整个哈希表,判断此哈希表入口的最后一个值(即对应块表的索引)是否等于此索引,等于即表示找到对应的哈希表入口.但是在测试程序中,我用索引调用此函数一直没有成功,原因不明.

3. 当SFileOpenFileEx()函数第三个参数为SFILE_OPEN_LOCAL_FILE时,调用OpenLocalFile()函数打开本地磁盘的文件.

4. 当SFileOpenFileEx()函数第三个参数为0或者说是SFILE_OPEN_FROM_MPQ时,才是最常用的调用方式,即以完整路径的文件名为第二参数,确定要打开的文件. 此步较为重要,最主要的步骤即调用GetHashEntryEx()函数得到相应的语言版本的此文件名对应的哈希表入口.

{
GetHashEntryEx()函数的具体实现又调用了GetHashEntry()函数来得到此任何语言的此文件名确定的哈希表入口.

首先看GetHashEntry()函数的实现:

{
a) 首先stromlib在此函数中也判断了一下第二参数的文件名是否是作为一个索引给出的.这里作者通过判断此值是否小于块表的数量来判断,当的确小于块表的数量时,作者认为此数值为一个索引,得到哈希表的入口的方法与SFileOpenFileEx()函数第2步一样.

b) 当经过判断不是以索引来搜索哈希表入口的时候,即表示第二参数的确是以完整路径文件名给出的.stromlib作者首先将此参数用DecryptHashIndex()得到home入口,此入口是一个DWORD值的索引值.用DecryptName1(),DecryptName2()进行了2次哈希运算得到两个用来验证的值.大概理论方法在<MPQ文档布局分析>哈希表一节有所描述.

c) 此时循环查找两个验证值都符合且此哈希表入口的文件块索引(BlockIndex)不为HASH_ENTRY_DELETED(FF FF FF FEH表示此文件已被删除)的哈希表入口,此时此入口即为正确入口,返回.不然循环查找,直到某哈希表入口的文件块索引(BlockIndex)为HASH_ENTRY_FREE(FF FF FF FFH)或已经遍历整个哈希表时,循环结束.这里要说的是,当查找到此哈希表的结尾还没有找到结果时,将从此哈希表的开始继续查找,直到碰上前述的返回或结束条件.
}

GetHashEntryEx()函数的实现

{
a) 首先调用GetHashEntry()函数,返回了一个此文件的任意语言版本的哈希表的入口.

b) 此时再开始一个类似于GetHashEntry()函数实现第C步似的遍历循环查找过程,此时的返回条件为此哈希表入口的语言为要查找的语言.并且,在碰到语言为LANG_NEUTRAL的文件时进行保存,当没有查找到确定需要语言版本的哈希表入口,就返回这个语言版本的哈希表入口偏移值.
}
}

5. 通过比较获得的块索引和块表大小,验证一下获得的块索引值.

6. 通过获得的块索引得到块的偏移地址,验证此块表入口指向的文件地址(此时为相对于MPQ文档的偏移值)是否正确(通过比较文件地址和MPQ文档的大小,还比较了此块表入口指向的块的大小值和文件的大小.验证此块表入口的文件标志位.(是否有MPQ_FILE_EXISTS(0x80 00 00 00H)位,是否有除了已知有效标志以外的位)

7.以上验证全部通过后,动态分配一个TMPQFile格式空间,由一个名叫hf指针指向这个空间.

8.利用已经得到的哈希表入口和块表入口等初始化hf指向的新创建的空间.

9. hf->nBlocks  = (hf->pBlock->dwFSize + ha->dwBlockSize - 1) / ha->dwBlockSize;(?)块的数量 = (块中未压缩的文件数据 + 文档的块大小 – 1) / 文档的块大小;(?)

10.假如块入口显示此块为压缩的话,分配空间用来解压,stormlib源码注释提到因为每个文件开始位置都存储了一个DWORD来保存文档中每个块相对文件开始位置的偏移值.在我写<MPQ文档布局分析>时,此处好像是一个表,这一部分在写<MPQ文档布局分析>时就没有太明白.即文件数据的具体结构这一块还不是太清除.最后分配了(nBlocks + 2)个DWORD空间.

11.假如文件由索引来打开调用SFileGetFileName()函数(以后再看此函数)暂时先看以文件名为索引的情况.
{
首先得到不带路径的文件名,如在<MPQ文档布局文件>数据这一部分分析的那样,这就是加密的文件的key.利用此key调用DecryptFileSeed()函数解密.

假如在块入口的标志中有MPQ_FILE_FIXSEED(00 02 00 00H),表示文件的密钥经过块偏移和文件大小调整.此时将得到的 (解密数据 + 此块的相对文档头的偏移量)^文件数据解压后的大小,即:

hf->dwSeed1 = (hf->dwSeed1 + hf->pBlock->dwFilePos) ^ hf->pBlock->dwFSize;

在<MPQ文档布局分析>中的描述为:

基本的文件key(base key)是不带路径的文件名,假如这个key是修改过的(就像在文件标志中指示的那样),最后的key通过((base key + 块偏移值 – 文档偏移值)XOR 文件大小)计算得到.每个扇区都是使用这个key + 在文件中以零为基础的扇区为索引.

目前此函数中还看不到此值的作用,但是返回的时候保存了下来,估计以后调用SFileRead的时候要作为索引值用到.
}

12.通过块的索引,读入每个文件相应的CRC32,FILETIME,MD5值,之所以可以通过块的索引来索引attribute,因为attribute和块是一一对应的.

13.假如前面有错误,就释放hf的空间,并设置相应的错误代码.将hf作为文件句柄赋给第四参数作为输出,并返回ERROR_SUCCESS表示成功.
}

FindFreeHashEntry()函数实现:

1. 先得到完整文件名的3个哈希值.
2. 如开始所知,第一个为home入口,寻找即从home入口开始顺序查找,直到找到一个空闲/删除的哈希表入口为止,没有找到即返回NULL,表示没有找到.
3. 假如找到了空闲哈希表入口即将其值置为相关值.
4. 然后开始寻找空闲的块表入口,方法是从索引为零开始,顺序检查每个块表的文件标志位是否为有文件,标志为没有时,表示找到空闲块表入口.
5. 当没有找到空闲块表入口时,在块表的最后添加一个块表入口,并赋给该哈希表入口的第四个DWROD值(即其对应的块表索引).
6. 一切成功以后,返回此哈希表入口的指针.

AddFileToArchive()函数实现:

1. 得到需要加入的文件的大小,当其小于0x04H时,不进行加密和文件key的修正,当其小于0x20H时不进行压缩.当文件大于4GB时,报错,据stormlib注释说明,在MPQ中的当个文件大小不能大于4GB.
2. 为此文件的入口动态分配一个TMPQFile结构的空间,由指针hf指向.初始化此结构.
3. 利用GetHashEntryEx()函数,检测是否已经有完全一样的文件(包括文件名,语言和平台,此函数实现在前面已经说明).当已经存在时,检测添加文件的标志位是否有MPQ_FILE_REPLACEEXISTING,没有此标志位即报错ERROR_ALREADY_EXISTS,有的话设定标志位表示已经覆盖,正确设置块的位置,但是不做任何实际覆盖工作?要写入一个修改过的新的同名的文件怎么办? (?)

```c
hf->pBlockEx = ha->pExtBlockTable + hf->pHash->dwBlockIndex;
hf->pBlock = ha->pBlockTable + hf->pHash->dwBlockIndex;
bReplaced = TRUE;
```

4. 当没有找到完全一致的入口时,用FindFreeHashEntry()函数找到一个空闲的哈希表入口.此函数实现在前面已经解释.并计算出此哈希表入口的索引值.
5. 此时先得到第一个文件块的偏移量(相对于文档开始处,得到方法即是跳过文档头.从第一个块表入口开始,同时不断验证此块表入口是否空闲.不空闲,就同时将文件块偏移量跳过这个入口指定的块大小,顺序查找方式与FindFreeHashEntry()函数一致,当其找到一个空闲的块表入口时,此块表入口即通过FindFreeHashEntry()函数找到的块表入口,且文件块偏移量正好跳过了前面所有块表入口指定块大小的总和.此时,认为找到了一个空闲的块空间.当找到块表入口末尾也没有找到空闲空间时,此时文件块偏移量也正好跳过了全部占用的文件块,到达文件数据块的末尾,此时认为这里即空闲空间.stormlib源代码中,个人认为.此两种情况实际可以合为一处,即少一个比较赋值操作.但是疑问在于,此处没有判断在文件块中找到的空闲块是否大于需要写入的文件,留待看以后有没有判断.(?)
6. 当此文档是原始版本时,确定添加此文件后的大小也不能大于4GB．方法是，首先将得到的文件偏移量（相对于整个文件而言）加上要加上的文件大小，再加上哈希表大小，块表入口，当此偏移量超过32位可以表示的时候,即表示添加文件后超过4GB．返回错误ERROR_DISK_FULL.这种方法实际是检测当添加文件处于文件数据块的尾部时的情况.当时我本以为,当新添加的文件处于文件块中时,这种方法不能保证文件大小不超过4GB,因为此时添加的文件和哈希表中还可能有数据.但是实际效果是,只要保证此空闲空间大于新添加的文件,那么只要原文件保证了小于4GB,那么此文件实际没有增加体积,自然也小于4GB.
7. 当块偏移值大于哈希表入口时,返回错误ERROR_HANDLE_DISK_FULL.

当文件是加密的时候得到seed(即附加的偏移值),当文件的加密key是修正过的,进一步计算修正过的seed,方法和读取的时候一致.见上面的SFileOpenFileEx()函数11步.

8. 假如MPQ文档的属性中指定了需要CRC32,FILETIME,MD5时,将hf的相关值指针指向ha的相关位置.即将文档中相关位置和目前文件中的相关指针关联在一起,以后改变hf的指针值就直接修改了文档中的相关值,为以后的修改提供方便.
9. 为压缩的数据分配buffer,首先计算了一个文件需要的块数量(文件的总大小 / 文档的块大小 + 1),假如文件大小正好是文档的块大小的整数倍,就将此数量再加一,目的是确保块数量充裕(需要在最后一个块尾保存额外数据).实际分配缓存大小仅仅一次分配了一个块的大小.
10.为此文件的扇区偏移表分配空间,为压缩的文件数据分配块大小*2大小的控件.
11.设定文件指针到新添加文件需要写入的地方,并将此文件的哈希表和块表赋相关值.这里很奇怪,没有写入前就将块表的标志位修改成MPQ_FILE_EXISTS,了,按道理应该先写入后再修改...不然写入的时候失败了怎么办?
12.假如文件是压缩的,计算出块偏移值表的大小.并用此值来初始化先前分配的块偏移表,并将此块偏移表的第一个值设为此值.
13.接下来将块偏移表先写入文件.此时标志此MPQ文件已被改变.并将块表的第二个表示文件大小的值修正,即加上块表大小.
14.最关键的一部分来了,实际写入文件数据的部分:
{
    a)首先初始化CRC32和MD5(没有判断需不需要?不需要的话,每次计算简直是极大的浪费(?))
    b)从文件开始读取数据,一次一个块的大小.
    c)计算CRC32,MD5.
    d)判断是否需要压缩,需要就压缩读入缓存的文件数据,假如压缩后文件数据没有变小,就保存原始数据.
e)将块偏移值表修改成正确的值, 理解上...因为上一个值表示目前写入数据的开始位置,那么将下一个值赋值成上个值+写入的大小.
f)假如需要加密,加密数据.加密的时候利用了前面计算的seed,目前可以确定的是,以前的理解有问题,seed是利用来加密数据的一个key,而不仅仅是附加的偏移值.
g)将数据写入MPQ文档.假如写入的大小不一致,又报ERROR_DISK_FULL错误.
h)将压缩后的大小继续加上此块的大小.
i)当所有的文件块都写入后,将计算得到的CRC,MD5写入hf.
}
15.通过以上的循环,一次一次写入了一个文件的所有块并完成了此文件的块偏移值表.
16.当文件标志位有MPQ_FILE_HAS_EXTRA时,将最后一个块偏移值表的值赋值为前一个值.本来此值应该是此文件的结尾,但是此值现在变成了此文件最后一个块的开始位置.(?)因为对MPQ_FILE_HAS_EXTRA标志不理解,所以不明白此步的作用.
17.假如文件是加密的,此时将此文件的块偏移值表也加密.重新将指针调到此文件的应该在MPQ文档中写入的开始位置,写入文件.无语了.
18.假如整个写入过程都成功,就升级哈希表和块表及文档头,失败就清空哈希表,从前面来看,假如写入失败的话,块表没有被清空(?)

升级哈希表和块表过程如下:

{ 
   a)假如此文件是在块表最后添加的(即此块表的索引大于文档头的块表大小时),块表的大小加1.
   b)哈希表,块表的整体位置向后移动此文件实际写入的大小.并将相对于文档开始位置的偏移量写入文档头.
   c)假如在文件添加后,文档大于4G,将相关高16位的值修改成正确偏移地址.通过判断以前文档头的块表偏移值高16位是否存在来辨别是否是新版本的文档.因为前面已经判断过了,不是新版本此时文档不会超过4G,所以此时的判断是安全的.
  
}
19.释放写入文件时为文件分配的缓存.
