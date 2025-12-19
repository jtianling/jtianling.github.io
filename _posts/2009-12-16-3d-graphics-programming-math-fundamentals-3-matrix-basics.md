---
layout: post
title: 3D 图形编程的数学基础(3) 矩阵基本变换
categories:
- "图形技术"
tags:
- "数学"
- "矩阵变换"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '18'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**

[**讨论新闻组及文件**](http://groups.google.com/group/jiutianfile/)

这里开始，是真正的与3D图形编程相关的知识了，前两节只能算是纯数学。

### 平移矩阵

要想将向量(x, y, z, 1)沿x轴平移[![yyyy_html_1d45df16](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_1d45df16_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_1d45df16_2.gif)个单位，沿y轴平移[![yyyy_html_m6cec65e6](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m6cec65e6_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m6cec65e6_2.gif)，沿z轴平移[![yyyy_html_m63b4a2d4](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m63b4a2d4_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m63b4a2d4_2.gif)个单位，我们只需要将该向量与如下矩阵相乘。

N(p) = [![yyyy_html_m1964a5f8\[4\]](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m1964a5f8%5B4%5D_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m1964a5f8%5B4%5D.gif)

从中可以看出4*4矩阵N中的N41,N42,N43分别控制其在x轴y轴z轴上的平移单位.

[![yyyy_html_m75c5e44f](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m75c5e44f_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m75c5e44f_2.gif)是单位矩阵，我们已经知道，乘以其他矩阵相当于没有乘的家伙。这个矩阵就是从单位矩阵稍微变下型，多了第4行的几个值。我们先来看[![yyyy_html_1d45df16](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_1d45df16_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_1d45df16_2.gif)为最后结果做出的贡献，向量M(x,y,z,1)与矩阵N(p)相乘后，最后X坐标的值（也就是矩阵M11的值）为x*1 + y*0 + z*0 + 1*px = x + px。（套一下矩形相乘的公式）

y,z的公式一样，就不多说了。这里可以看到，对于实施矩阵平移计算来说，需要将原向量（3维）扩充的一维（一般用w表示)设为1，不然的话，上述x坐标=x*1 + y*0 + z*0 + 0*px=x，也就是说，完全不会改变原矩阵了。

GNU Octave(matlab) 验证一下：

```matlab
> p = [1,0,0,0;0,1,0,0;0,0,1,0;2,3,4,1]
p =

   1   0   0   0
   0   1   0   0
   0   0   1   0
   2   3   4   1

octave-3.2.3.exe:6:d:/Octave/3.2.3_gcc-
> x
x =

   1   2   3   1

octave-3.2.3.exe:7:d:/Octave/3.2.3_gcc-
> x * p
ans =

   3   5   7   1

octave-3.2.3.exe:8:d:/Octave/3.2.3_gcc-
```

---

x = 2 + 1 = 3,依次类推，结果正确。

在irrlicht中，平移矩阵的代码直接偷懒。。。。。利用了上述公式的推导结果，转换后的x值为x+px。。。。汗-_-!，理论和实际果然还是有差距的。不过想想，说来也是，一个加法就可以完成的平移，为啥非要整个矩阵乘法去完成？此公式的存在就让人郁闷。。。难道仅仅是因为需要的是用矩阵进行的计算。。。。。。

```cpp
template <class T>
inline void CMatrix4<T>::translateVect( vector3df& vect ) const
{
    vect.X = vect.X+M[12];
    vect.Y = vect.Y+M[13];
    vect.Z = vect.Z+M[14];
}
```

[](http://11011.net/software/vspaste)

D3D中利用函数：

```cpp
// Build a matrix which translates by (x, y, z)
D3DXMATRIX* WINAPI D3DXMatrixTranslation
    ( D3DXMATRIX *pOut, FLOAT x, FLOAT y, FLOAT z );
```

[](http://11011.net/software/vspaste)实现矩阵的平移，具体方式不明。

### 缩放矩阵

我们将一单位矩阵沿X轴缩放X倍,Y轴缩放Y倍,Z轴缩放Z倍,可令该向量与下列矩阵相乘。

![html_html_m2794d7de](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_html_html_m2794d7de_thumb.gif)

按公式推导：X(M11)坐标值为X*x+y*0+z*0+0*0=X*x

y,z的推导类似。

GNU Octave(matlab):

```matlab
> x = [1,2,3,0]
x =

   1   2   3   0

octave-3.2.3.exe:6:f:
> p
p =

   2   0   0   0
   0   3   0   0
   0   0   4   0
   0   0   0   1

octave-3.2.3.exe:7:f:
> x * p
ans =

    2    6   12    0
```

---

结果正确。其实看了实现的源代码后也会发现这种公式还是没事找事，事实上直接乘多省事啊。

irrlicht中利用下面的实现来构造一个缩放矩阵：

```cpp
    template <class T>
    inline CMatrix4<T>& CMatrix4<T>::setScale( const vector3d<T>& scale )
    {
        M[0] = scale.X;
        M[5] = scale.Y;
        M[10] = scale.Z;
#if defined ( USE_MATRIX_TEST )
        definitelyIdentityMatrix=false;
#endif
        return *this;
    }
```

[](http://11011.net/software/vspaste)

D3D中利用下面的实现完成缩放运算，直接乘就好了。。。。。。

```cpp
D3DXINLINE D3DXVECTOR3* D3DXVec3Scale
    ( D3DXVECTOR3 *pOut, CONST D3DXVECTOR3 *pV, FLOAT s)
{
#ifdef D3DX_DEBUG
    if(!pOut || !pV)
        return NULL;
#endif

    pOut->x = pV->x * s;
    pOut->y = pV->y * s;
    pOut->z = pV->z * s;
    return pOut;
}
```

[](http://11011.net/software/vspaste)

### 旋转矩阵：

旋转矩阵是在乘以一个向量的时候有改变向量的方向但不改变大小的效果的矩阵。旋转矩阵不包括反演，它可以把右手坐标系改变成左手坐标系或反之。所有旋转加上反演形成了正交矩阵的集合。需要注意的是，进行旋转变换时，扩充3维向量的办法是令w=0；

我们可用如下3个矩阵将一个分量分别绕着x,y,z轴顺时针旋转θ弧度。

X(θ) = [![yyyy_html_m5a3e8644](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m5a3e8644_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_m5a3e8644_2.gif)

Y(θ) = [![yyyy_html_6d8ae198](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_6d8ae198_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_yyyy_html_6d8ae198_3.gif)

Z(θ) = [![html_html_3de18d4c](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_html_html_3de18d4c_thumb.gif)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_html_html_3de18d4c_2.gif)

还是先看第一个公式，向量M(x,y,z,0)与矩阵X(θ)相乘后，最后X(M11)坐标值为x*1+y*0+z*0+0*0=x,Y(M12)坐标值为x*0+y*cosθ+z*(-sinθ)+0*0 = y*cosθ + z * (-sinθ),Z(M13)坐标值为x*0+y*sinθ+z*cosθ+0*0 = y*sinθ + z*cosθ，w(m14)坐标为x*0+y*0+z*0+0*1 = 0。

这个就复杂了。。。。。不太好直观的看到验证的结果，我们将其收到2维去看结果。

我们利用GNU Octave(matlab) 的compass命令在2维空间中直观的显示出向量x = [ 1, tan(pi/3), 0, 0](实际显示在x,y平面中）

我们用其围绕Z轴顺时针旋转30度时，方式是乘以θ为30的如上矩阵，结果如下：

[![image](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_image_thumb_2_633965303466482500.png)](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_image_6_633965303463826250.png)

```matlab
> a = pi / 6


> p = [cos(a),sin(a),0,0;-sin(a),cos(a),0,0;0,0,1,0;0,0,0,1]
p =

   0.86603   0.50000   0.00000   0.00000
  -0.50000   0.86603   0.00000   0.00000
   0.00000   0.00000   1.00000   0.00000
   0.00000   0.00000   0.00000   1.00000

octave-3.2.3.exe:26:f:/Octave/3.2.3_gcc-4.4.0/bin
> x = [1, tan(pi/3), 0, 0]
x =

   1.00000   1.73205   0.00000   0.00000

octave-3.2.3.exe:27:f:/Octave/3.2.3_gcc-4.4.0/bin
> x2 = x * p
x2 =

   0.00000   2.00000   0.00000   0.00000

octave-3.2.3.exe:28:f:/Octave/3.2.3_gcc-4.4.0/bin
> 
```

---

精确的30度。

irrlicht中设置旋转矩阵就有学问了：

```cpp
    template <class T>
    inline CMatrix4<T>& CMatrix4<T>::setRotationRadians( const vector3d<T>& rotation )
    {
        const f64 cr = cos( rotation.X );
        const f64 sr = sin( rotation.X );
        const f64 cp = cos( rotation.Y );
        const f64 sp = sin( rotation.Y );
        const f64 cy = cos( rotation.Z );
        const f64 sy = sin( rotation.Z );

        M[0] = (T)( cp*cy );
        M[1] = (T)( cp*sy );
        M[2] = (T)( -sp );

        const f64 srsp = sr*sp;
        const f64 crsp = cr*sp;

        M[4] = (T)( srsp*cy-cr*sy );
        M[5] = (T)( srsp*sy+cr*cy );
        M[6] = (T)( sr*cp );

        M[8] = (T)( crsp*cy+sr*sy );
        M[9] = (T)( crsp*sy-sr*cy );
        M[10] = (T)( cr*cp );
#if defined ( USE_MATRIX_TEST )
        definitelyIdentityMatrix=false;
#endif
        return *this;
    }
```

为了解释这个函数的作用，看看下列程序：

```cpp
#include "irrlicht.h"
#include <math.h>

#pragma comment(lib, "Irrlicht.lib")

using namespace irr;
using namespace irr::core;

int _tmain(int argc, _TCHAR* argv[])
{

    f32 a = 30;
    f32 M[16] = { 1, 0, 0, 0, 
                  0, 1, 0, 0,
                  0, 0, 1, 0,
                  0, 0, 0, 1};
    matrix4 mt;
    mt.setM(M);

    vector3df vec(0.0, 0.0, PI / 6);

    mt.setRotationRadians(vec);

    for(int i = 0; i < 4; ++i)
    {
        for(int j = 0; j < 4; ++j)
        {
            printf("%.6f/t", mt(i, j));
        }
        printf("/n");
    }


    return 0;
}
```

[](http://11011.net/software/vspaste)运行结果为：

```text
0.866025        0.500000        -0.000000       0.000000
-0.500000       0.866025        0.000000        0.000000
0.000000        0.000000        1.000000        0.000000
0.000000        0.000000        0.000000        1.000000
```

---

看到是啥了吗？没错，就是GNU Octave(matlab) 那个例子中的矩阵：

p = [cos(a),sin(a),0,0;-sin(a),cos(a),0,0;0,0,1,0;0,0,0,1]

事实上，上面程序中的vec表示不绕x,y轴旋转，绕Z轴旋转PI/6，实际的作用就是构造了上述的矩阵P。

上述矩阵通过以下成员函数应用以使用生成的矩阵，其实就是乘法-_-!

```cpp
template <class T>
inline void CMatrix4<T>::rotateVect( vector3df& vect ) const
{
    vector3df tmp = vect;
    vect.X = tmp.X*M[0] + tmp.Y*M[4] + tmp.Z*M[8];
    vect.Y = tmp.X*M[1] + tmp.Y*M[5] + tmp.Z*M[9];
    vect.Z = tmp.X*M[2] + tmp.Y*M[6] + tmp.Z*M[10];
}

//! An alternate transform vector method, writing into a second vector
template <class T>
inline void CMatrix4<T>::rotateVect(core::vector3df& out, const core::vector3df& in) const
{
    out.X = in.X*M[0] + in.Y*M[4] + in.Z*M[8];
    out.Y = in.X*M[1] + in.Y*M[5] + in.Z*M[9];
    out.Z = in.X*M[2] + in.Y*M[6] + in.Z*M[10];
}

//! An alternate transform vector method, writing into an array of 3 floats
template <class T>
inline void CMatrix4<T>::rotateVect(T *out, const core::vector3df& in) const
{
    out[0] = in.X*M[0] + in.Y*M[4] + in.Z*M[8];
    out[1] = in.X*M[1] + in.Y*M[5] + in.Z*M[9];
    out[2] = in.X*M[2] + in.Y*M[6] + in.Z*M[10];
}
```

上面程序后加上如下几句，使用上面刚生成的矩阵：

```cpp
vector3df x(1.0, tan(PI/3), 0.0);
mt.rotateVect(x);

printf("x = [%f, %f, %f]/n", x.X, x.Y, x.Z);
```

[](http://11011.net/software/vspaste)

输出结果:

```text
x = [-0.000000, 2.000000, 0.000000]
```

---

与通过GNU Octave(matlab) 的一样,精确的30度旋转。

与旋转有关的还有vector的几个函数：

```cpp
//! Rotates the vector by a specified number of degrees around the Y axis and the specified center.
/** /param degrees Number of degrees to rotate around the Y axis.
/param center The center of the rotation. */
void rotateXZBy(f64 degrees, const vector3d<T>& center=vector3d<T>())
{
    degrees *= DEGTORAD64;
    f64 cs = cos(degrees);
    f64 sn = sin(degrees);
    X -= center.X;
    Z -= center.Z;
    set((T)(X*cs - Z*sn), Y, (T)(X*sn + Z*cs));
    X += center.X;
    Z += center.Z;
}

//! Rotates the vector by a specified number of degrees around the Z axis and the specified center.
/** /param degrees: Number of degrees to rotate around the Z axis.
/param center: The center of the rotation. */
void rotateXYBy(f64 degrees, const vector3d<T>& center=vector3d<T>())
{
    degrees *= DEGTORAD64;
    f64 cs = cos(degrees);
    f64 sn = sin(degrees);
    X -= center.X;
    Y -= center.Y;
    set((T)(X*cs - Y*sn), (T)(X*sn + Y*cs), Z);
    X += center.X;
    Y += center.Y;
}

//! Rotates the vector by a specified number of degrees around the X axis and the specified center.
/** /param degrees: Number of degrees to rotate around the X axis.
/param center: The center of the rotation. */
void rotateYZBy(f64 degrees, const vector3d<T>& center=vector3d<T>())
{
    degrees *= DEGTORAD64;
    f64 cs = cos(degrees);
    f64 sn = sin(degrees);
    Z -= center.Z;
    Y -= center.Y;
    set(X, (T)(Y*cs - Z*sn), (T)(Y*sn + Z*cs));
    Z += center.Z;
    Y += center.Y;
}
```

事实上这些函数就是前面两步的一步实现，实际就是利用了上述公式推导最后的结果，可以去对比一下。

比如下列代码：

```cpp
vector3df x(1.0, tan(PI/3), 0.0);
x.rotateXYBy(30);

printf("x = [%f, %f, %f]/n", x.X, x.Y, x.Z);
```

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

输出：

```text
x = [-0.000000, 2.000000, 0.000000]
```

---

就是前面通过两步得出的结果。上面irrlicht代码需要注意的是，参数是degree是表示单位是度数，其他时候都默认为弧度。

D3D中使用下列函数实现旋转，没有实现源代码，没有太多好说的。

```cpp
// Build a matrix which rotates around the X axis
D3DXMATRIX* WINAPI D3DXMatrixRotationX
    ( D3DXMATRIX *pOut, FLOAT Angle );

// Build a matrix which rotates around the Y axis
D3DXMATRIX* WINAPI D3DXMatrixRotationY
    ( D3DXMATRIX *pOut, FLOAT Angle );

// Build a matrix which rotates around the Z axis
D3DXMATRIX* WINAPI D3DXMatrixRotationZ
    ( D3DXMATRIX *pOut, FLOAT Angle );
```

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**
