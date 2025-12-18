---
layout: post
title: C++函数调用原理理解
categories:
- C++
tags:
- C++
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

空程序:

```asm
int main()
{
00411360  push        ebp       ;压入ebp
00411361  mov         ebp,esp     ;ebp = esp,保留esp,待函数调用完再恢复,因为函数调用中肯定会用到esp.
00411363  sub         esp,0C0h ;esp-=0C0h(192);为该函数留出临时存储区
;将其他指针或寄存器中的值入栈，以便在函数中使用这些寄存器。
00411369  push        ebx       ;压入ebx
0041136A  push        esi       ;压入esi
0041136B  push        edi       ;压入edi
0041136C  lea         edi,[ebp-0C0h] ;读入[ebp-0C0h]有效地址,即原esp-0C0h,正好是为该函数留出的临时存储区的最低位
00411372  mov         ecx,30h   ;ecx = 30h(48),30h*4 = 0C0h
00411377  mov         eax,0CCCCCCCCh ;eax = 0CCCCCCCCh;
0041137C  rep stos    dword ptr es:[edi] ;重复在es:[edi]存入30个;0CCCCCCCCh? Debug模式下把Stack上的变量初始化为0xcc，检查未初始化的问题****
return 0;
0041137E  xor         eax,eax   ;将eax清零,作为返回值
}
;各指针出栈
00411380  pop         edi          ;弹出edi
00411381  pop         esi          ;弹出esi
00411382  pop         ebx          ;弹出ebx
00411383  mov         esp,ebp      ;esp复原
00411385  pop         ebp          ;弹出ebp,也复原
00411386  ret                      ;返回
```

函数调用:

```asm
int _tmain(int argc, _TCHAR* argv[])
{
同上理解, 保存现场
004113D0  push        ebp 
004113D1  mov         ebp,esp 
004113D3  sub         esp,0F0h ;一共留了0F0h(240)空间
004113D9  push        ebx 
004113DA  push        esi 
004113DB  push        edi 
004113DC  lea         edi,[ebp-0F0h] 
004113E2  mov         ecx,3Ch ; ecx = 3C(60),3C*4 = 0F0h,
004113E7  mov         eax,0CCCCCCCCh 
004113EC  rep stos    dword ptr es:[edi] 
同上理解.
    int a = 1, b = 2, c = 3;
定义a,b,c并存储在为函数留出的临时存储空间中.
004113EE  mov         dword ptr [a],1 
004113F5  mov         dword ptr [b],2 
004113FC  mov         dword ptr [c],3 
    int d = Fun1(a, b, c);
参数反向入栈
00411403  mov         eax,dword ptr [c] 
00411406  push        eax 
00411407  mov         ecx,dword ptr [b] 
0041140A  push        ecx 
0041140B  mov         edx,dword ptr [a] 
0041140E  push        edx 
```

[调用Fun1](<http://writeblog.csdn.net/posteditplain.aspx#fun1>)

```asm
0041140F  call        Fun1 (4111DBh) ;Call调用时将下一行命令的ＥＩＰ压入堆栈
恢复因为Fun1参数入栈改变的栈指针,因为Fun1有3个参数,一个整数4个字节,共0Ch(12)个字节
00411414  add         esp,0Ch 
00411417  mov         dword ptr [d],eax 
将返回值保存在d中.
    return 0;
返回值为0,让eax清零
0041141A  xor         eax,eax 
}
```

恢复现场

```asm
0041141C  pop         edi 
0041141D  pop         esi 
0041141E  pop         ebx 
以下全为运行时ESP检查:
先恢复因为main预留空间而改变的栈指针
0041141F  add         esp,0F0h 
00411425  cmp         ebp,esp 
00411427  call        @ILT+320(__RTC_CheckEsp) (411145h) 
正常时只需要以下两句就可以正常恢复esp,再出栈,又可以恢复ebp.
0041142C  mov         esp,ebp 
0041142E  pop         ebp 
0041142F  ret     ;main返回             
```

```asm
int Fun1(int a, int b, int c)
{
同上理解, 保存现场
00411A70  push        ebp 
00411A71  mov         ebp,esp 
00411A73  sub         esp,0E4h ;留了0E4H(228)空间,
00411A79  push        ebx 
00411A7A  push        esi 
00411A7B  push        edi 
00411A7C  lea         edi,[ebp-0E4h] 
00411A82  mov         ecx,39h ; 39H(57)*4 = 0E4H(228)
00411A87  mov         eax,0CCCCCCCCh 
00411A8C  rep stos    dword ptr es:[edi] 
    int d = 4, e = 5;
定义变量
00411A8E  mov         dword ptr [d],4 
00411A95  mov         dword ptr [e],5 
 
    int f = Fun2(a, b, c, d, e);
再次参数反向入栈
00411A9C  mov         eax,dword ptr [e] 
00411A9F  push        eax 
00411AA0  mov         ecx,dword ptr [d] 
00411AA3  push        ecx 
00411AA4  mov         edx,dword ptr [c] 
00411AA7  push        edx 
00411AA8  mov         eax,dword ptr [b] 
00411AAB  push        eax 
00411AAC  mov         ecx,dword ptr [a] 
00411AAF  push        ecx 
```

[调用Fun2](<http://writeblog.csdn.net/posteditplain.aspx#fun2>)

```asm
00411AB0  call        Fun2 (4111D6h) ;Call调用时将下一行命令的ＥＩＰ压入堆栈
00411AB5  add         esp,14h ;恢复因为参数入栈改变的栈指针,因为Fun2有5个参数,一个整数4个字节,共14h(20)个字节
将Fun2函数的返回值(保存在eax中),赋值给f;
00411AB8  mov         dword ptr [f],eax 
 
    return f;
将保留在f中的Fun1的返回值保存在eax中返回
00411ABB  mov         eax,dword ptr [f] 
}
恢复现场
00411ABE  pop         edi 
00411ABF  pop         esi 
00411AC0  pop         ebx 
 
以下全为运行时ESP检查:
先恢复因为预留函数存储控件而改变的栈指针,
00411AC1  add         esp,0E4h
再比较ebp,esp,假如程序运行正确,两个值应该相等. 
00411AC7  cmp         ebp,esp 
00411AC9  call        @ILT+320(__RTC_CheckEsp) (411145h) 
正常时只需要以下两句就可以正常恢复esp,再出栈,又可以恢复ebp.
00411ACE  mov         esp,ebp 
00411AD0  pop         ebp 
[返回main](<http://writeblog.csdn.net/posteditplain.aspx#ret00411414>)从pop堆栈中的EIP开始执行
00411AD1  ret   
```

```asm
int Fun2(int a, int b, int c, int d, int e)
{
同上理解, 保存现场
00412050  push        ebp 
00412051  mov         ebp,esp 
00412053  sub         esp,0E4h ;保留0E4H(228)
00412059  push        ebx 
0041205A  push        esi 
0041205B  push        edi 
0041205C  lea         edi,[ebp-0E4h] 
00412062  mov         ecx,39h ; 39H(57)*4 = 0E4H(228)
00412067  mov         eax,0CCCCCCCCh 
0041206C  rep stos    dword ptr es:[edi] 
 
    int f  = 6, g = 7;
定义变量
0041206E  mov         dword ptr [f],6 
00412075  mov         dword ptr [g],7 
 
    int h = a + b + c + d + e + f + g;
相加,存入a,再保存在h
0041207C  mov         eax,dword ptr [a] 
0041207F  add         eax,dword ptr [b] 
00412082  add         eax,dword ptr [c] 
00412085  add         eax,dword ptr [d] 
00412088  add         eax,dword ptr [e] 
0041208B  add         eax,dword ptr [f] 
0041208E  add         eax,dword ptr [g] 
00412091  mov         dword ptr [h],eax 
 
    return  h;
将返回值h的值保存在eax中
00412094  mov         eax,dword ptr [h] 
 
}
恢复现场
00412097  pop         edi 
00412098  pop         esi 
00412099  pop         ebx 
0041209A  mov         esp,ebp 
0041209C  pop         ebp 
0041209D  ret ;[返回fun1 ](<http://writeblog.csdn.net/posteditplain.aspx#ret00411ab5>),从pop堆栈中的EIP开始执行
```