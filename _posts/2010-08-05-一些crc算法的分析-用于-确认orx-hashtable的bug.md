---
layout: post
title: "一些CRC算法的分析 用于 确认Orx HashTable的Bug"
categories:
- "游戏开发"
tags:
- CRC
- Orx
- "算法"
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

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)

[上文](<http://www.jtianling.com/archive/2010/08/04/5786973.aspx> "上文")  
我阅读了Orx自己实现的一套hashTable，经我过的初步分析，一个CRC算法作为key是有可能冲突的，但是并没有验证，作为bug提交的话，有些不够完整，所以，我写个测试程序真实的验证一下这个CRC算法，同时，也验证一下自己的分析是否正确。简而言之，就是验证此CRC算法在实际使用中，到底有无冲突的可能。

 

原理很简单，就是生成一堆字符串，然后传进此CRC算法，然后比较CRC后的值有无重复。此时我真希望可以使用Python，但是想想有写将接口使用Python API让Python使用的功夫，我都已经将测试代码写完了，于是作罢，还是老老实实的用C++吧。

 

先将整个Orx的Crc算法抽出来，如下：

  
#include   
  
  
typedef  
 unsigned  
  long  
          orxU32;  
typedef  
 char  
                    orxCHAR;  
#define orxCHAR_NULL                
'0'  
  
#define orxASSERT assert  
  
#define orxSTRING               orxCHAR *  
  
#define orxNULL               (  
0  
)  
  
static  
 const  
 orxU32 sau32CRCTable[256  
] =  
{  
  0x00000000  
, 0x04C11DB7  
, 0x09823B6E  
, 0x0D4326D9  
, 0x130476DC  
, 0x17C56B6B  
, 0x1A864DB2  
, 0x1E475005  
,  
  0x2608EDB8  
, 0x22C9F00F  
, 0x2F8AD6D6  
, 0x2B4BCB61  
, 0x350C9B64  
, 0x31CD86D3  
, 0x3C8EA00A  
, 0x384FBDBD  
,  
  0x4C11DB70  
, 0x48D0C6C7  
, 0x4593E01E  
, 0x4152FDA9  
, 0x5F15ADAC  
, 0x5BD4B01B  
, 0x569796C2  
, 0x52568B75  
,  
  0x6A1936C8  
, 0x6ED82B7F  
, 0x639B0DA6  
, 0x675A1011  
, 0x791D4014  
, 0x7DDC5DA3  
, 0x709F7B7A  
, 0x745E66CD  
,  
  0x9823B6E0  
, 0x9CE2AB57  
, 0x91A18D8E  
, 0x95609039  
, 0x8B27C03C  
, 0x8FE6DD8B  
, 0x82A5FB52  
, 0x8664E6E5  
,  
  0xBE2B5B58  
, 0xBAEA46EF  
, 0xB7A96036  
, 0xB3687D81  
, 0xAD2F2D84  
, 0xA9EE3033  
, 0xA4AD16EA  
, 0xA06C0B5D  
,  
  0xD4326D90  
, 0xD0F37027  
, 0xDDB056FE  
, 0xD9714B49  
, 0xC7361B4C  
, 0xC3F706FB  
, 0xCEB42022  
, 0xCA753D95  
,  
  0xF23A8028  
, 0xF6FB9D9F  
, 0xFBB8BB46  
, 0xFF79A6F1  
, 0xE13EF6F4  
, 0xE5FFEB43  
, 0xE8BCCD9A  
, 0xEC7DD02D  
,  
  0x34867077  
, 0x30476DC0  
, 0x3D044B19  
, 0x39C556AE  
, 0x278206AB  
, 0x23431B1C  
, 0x2E003DC5  
, 0x2AC12072  
,  
  0x128E9DCF  
, 0x164F8078  
, 0x1B0CA6A1  
, 0x1FCDBB16  
, 0x018AEB13  
, 0x054BF6A4  
, 0x0808D07D  
, 0x0CC9CDCA  
,  
  0x7897AB07  
, 0x7C56B6B0  
, 0x71159069  
, 0x75D48DDE  
, 0x6B93DDDB  
, 0x6F52C06C  
, 0x6211E6B5  
, 0x66D0FB02  
,  
  0x5E9F46BF  
, 0x5A5E5B08  
, 0x571D7DD1  
, 0x53DC6066  
, 0x4D9B3063  
, 0x495A2DD4  
, 0x44190B0D  
, 0x40D816BA  
,  
  0xACA5C697  
, 0xA864DB20  
, 0xA527FDF9  
, 0xA1E6E04E  
, 0xBFA1B04B  
, 0xBB60ADFC  
, 0xB6238B25  
, 0xB2E29692  
,  
  0x8AAD2B2F  
, 0x8E6C3698  
, 0x832F1041  
, 0x87EE0DF6  
, 0x99A95DF3  
, 0x9D684044  
, 0x902B669D  
, 0x94EA7B2A  
,  
  0xE0B41DE7  
, 0xE4750050  
, 0xE9362689  
, 0xEDF73B3E  
, 0xF3B06B3B  
, 0xF771768C  
, 0xFA325055  
, 0xFEF34DE2  
,  
  0xC6BCF05F  
, 0xC27DEDE8  
, 0xCF3ECB31  
, 0xCBFFD686  
, 0xD5B88683  
, 0xD1799B34  
, 0xDC3ABDED  
, 0xD8FBA05A  
,  
  0x690CE0EE  
, 0x6DCDFD59  
, 0x608EDB80  
, 0x644FC637  
, 0x7A089632  
, 0x7EC98B85  
, 0x738AAD5C  
, 0x774BB0EB  
,  
  0x4F040D56  
, 0x4BC510E1  
, 0x46863638  
, 0x42472B8F  
, 0x5C007B8A  
, 0x58C1663D  
, 0x558240E4  
, 0x51435D53  
,  
  0x251D3B9E  
, 0x21DC2629  
, 0x2C9F00F0  
, 0x285E1D47  
, 0x36194D42  
, 0x32D850F5  
, 0x3F9B762C  
, 0x3B5A6B9B  
,  
  0x0315D626  
, 0x07D4CB91  
, 0x0A97ED48  
, 0x0E56F0FF  
, 0x1011A0FA  
, 0x14D0BD4D  
, 0x19939B94  
, 0x1D528623  
,  
  0xF12F560E  
, 0xF5EE4BB9  
, 0xF8AD6D60  
, 0xFC6C70D7  
, 0xE22B20D2  
, 0xE6EA3D65  
, 0xEBA91BBC  
, 0xEF68060B  
,  
  0xD727BBB6  
, 0xD3E6A601  
, 0xDEA580D8  
, 0xDA649D6F  
, 0xC423CD6A  
, 0xC0E2D0DD  
, 0xCDA1F604  
, 0xC960EBB3  
,  
  0xBD3E8D7E  
, 0xB9FF90C9  
, 0xB4BCB610  
, 0xB07DABA7  
, 0xAE3AFBA2  
, 0xAAFBE615  
, 0xA7B8C0CC  
, 0xA379DD7B  
,  
  0x9B3660C6  
, 0x9FF77D71  
, 0x92B45BA8  
, 0x9675461F  
, 0x8832161A  
, 0x8CF30BAD  
, 0x81B02D74  
, 0x857130C3  
,  
  0x5D8A9099  
, 0x594B8D2E  
, 0x5408ABF7  
, 0x50C9B640  
, 0x4E8EE645  
, 0x4A4FFBF2  
, 0x470CDD2B  
, 0x43CDC09C  
,  
  0x7B827D21  
, 0x7F436096  
, 0x7200464F  
, 0x76C15BF8  
, 0x68860BFD  
, 0x6C47164A  
, 0x61043093  
, 0x65C52D24  
,  
  0x119B4BE9  
, 0x155A565E  
, 0x18197087  
, 0x1CD86D30  
, 0x029F3D35  
, 0x065E2082  
, 0x0B1D065B  
, 0x0FDC1BEC  
,  
  0x3793A651  
, 0x3352BBE6  
, 0x3E119D3F  
, 0x3AD08088  
, 0x2497D08D  
, 0x2056CD3A  
, 0x2D15EBE3  
, 0x29D4F654  
,  
  0xC5A92679  
, 0xC1683BCE  
, 0xCC2B1D17  
, 0xC8EA00A0  
, 0xD6AD50A5  
, 0xD26C4D12  
, 0xDF2F6BCB  
, 0xDBEE767C  
,  
  0xE3A1CBC1  
, 0xE760D676  
, 0xEA23F0AF  
, 0xEEE2ED18  
, 0xF0A5BD1D  
, 0xF464A0AA  
, 0xF9278673  
, 0xFDE69BC4  
,  
  0x89B8FD09  
, 0x8D79E0BE  
, 0x803AC667  
, 0x84FBDBD0  
, 0x9ABC8BD5  
, 0x9E7D9662  
, 0x933EB0BB  
, 0x97FFAD0C  
,  
  0xAFB010B1  
, 0xAB710D06  
, 0xA6322BDF  
, 0xA2F33668  
, 0xBCB4666D  
, 0xB8757BDA  
, 0xB5365D03  
, 0xB1F740B4  
  
};

orxU32 orxString_ContinueCRC(const  
 orxSTRING _zString, orxU32 _u32CRC)  
{  
  register  
 orxU32          u32CRC;  
  register  
 const  
 orxCHAR  *pc;

  /*  
 Checks   
*/  
  
  orxASSERT(_zString != orxNULL);

  /*  
 Inits CRC   
*/  
  
  u32CRC = _u32CRC ^ 0xFFFFFFFFL  
;

  /*  
 For the whole string   
*/  
  
  for  
(pc = _zString; *pc != orxCHAR_NULL; pc++)  
  {  
    /*  
 Computes the CRC   
*/  
  
    u32CRC = sau32CRCTable[(u32CRC ^ *pc) & 0xFF  
] ^ (u32CRC >> 8  
);  
  }

  /*  
 Done!   
*/  
  
  return  
(u32CRC ^ 0xFFFFFFFFL  
);  
}  

 

由于在Orx中使用的时候，第2参数一直为0，所以函数实际可以改成下面这样  
  
orxU32 orxString_ContinueCRC(const  
 orxSTRING _zString)  
{  
  register  
 orxU32          u32CRC;  
  register  
 const  
 orxCHAR  *pc;

  /*  
 Checks   
*/  
  
  orxASSERT(_zString != orxNULL);

  /*  
 Inits CRC   
*/  
  
  u32CRC = 0  
 ^ 0xFFFFFFFFL  
;

  /*  
 For the whole string   
*/  
  
  for  
(pc = _zString; *pc != orxCHAR_NULL; pc++)  
  {  
    /*  
 Computes the CRC   
*/  
  
    u32CRC = sau32CRCTable[(u32CRC ^ *pc) & 0xFF  
] ^ (u32CRC >> 8  
);  
  }

  /*  
 Done!   
*/  
  
  return  
(u32CRC ^ 0xFFFFFFFFL  
);  
}  

 

作为测试结果，我希望检验是否会在string较短时就发生冲突，并且，真的冲突的话，输出冲突的字符串。这里暂时仅测试ASCII的字符，按照Orx的实际使用，UTF8字符的冲突的可能性只会比这个高，不会比这个低。

突然觉得想出一个这样的测试算法也挺有意思的。

作为较短的函数，暂时将字符串长度定在20以下。

第一步：生成测试字符串：

这里为了简化，就全生成同样长度的小写字符串了，其实本来想遍历生成的，后来觉得太麻烦，想了想，其实没有必要，只要能找到冲突就行，不一定要遍历。

  
char  
 *rand_str(char  
 *str,const  
 int  
 len)  
{  
  char  
 *c = str;  
  for  
(int  
 i=0  
; i  
    *c='a'  
+rand()%26  
;  
  }

  *c='0'  
;  
  return  
 str;  
}  
  
用这个函数来生成随机指定长度的字符串。

 

我然后用下列函数来检验：

  
typedef  
 hash_map<unsigned  
 long  
, list > resultType;  
resultType result;  
void  
 testIt(char  
* testString) {  
  unsigned  
 long  
 crcValue = orxString_ContinueCRC(testString);

  resultType::iterator clashIt = result.find(crcValue);  
  if  
(clashIt != result.end()) {  
    // have a clash  
  
    list &clashList = (clashIt->second);  
    clashList.push_back(testString);

    printf("Clash strings: "  
);  
    for  
 (list::iterator it = clashList.begin();  
      it != clashList.end();  
      ++it) {  
        printf("  
%s  
t  
"  
, it->c_str());  
    }  
    printf("  
n  
"  
);  
    return  
;  
  }

  list newVaule;  
  newVaule.push_back(testString);  
  result.insert(make_pair(crcValue, newVaule));  
}  

原理上也没有什么好说的了，就是一个hash_map<unsigned  
 long  
, list >  
的变量，用于来保存目前测试过的所有字符串，key是CRC计算后的值，list用于存储字符串。这种用法消耗内存非常多。。。。。。。

 

驱动代码如下，需要增加测试数量的，改NumOftest是改测试字符串的长度，i的最大值是测试的次数。

  
int  
 _tmain(int  
 argc, _TCHAR* argv[])  
{  
  srand(time(NULL  
));  
  const  
 int  
 NumOftest = 11  
;  
  char  
 test[NumOftest + 1  
];  
  for  
(int  
 i = 0  
; i < 200000  
; ++i) {  
    rand_str(test, NumOftest);  
    testIt(test);  
  }

  system("PAUSE"  
);

    return  
 0  
;  
}  

事实上， 经过测试，在上面这个级别我就测试出了4组冲突：

Clash strings: rdvohjmmqco      dzfmlbvurvy  
Clash strings: ezmchjdxzvc      heugmqpnwhr  
Clash strings: xuosifsuqnz      hdnklsfofvo  
Clash strings: cxezqfgwkdy      hjccdfyaamc

 

20W的级别，长度为十的字符串。。。。。。。。。。。。这不是现实中可能出现的组合，出现这样的情况，Orx中的hashTable必然就会出现问题。。。。。

另外，这也说明了出现问题的概率不是小到宇宙毁灭的几率那样，谁也不能保证在Orx使用一个256长度的hashTable的时候会不会出现问题。。。。。。。。。。。。。。。。事实上，即使为了效率，也还是参考参考MPQ中暴雪对CRC的使用，或者是如一般std扩展中hashmap的使用吧。

 

 

 

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**
