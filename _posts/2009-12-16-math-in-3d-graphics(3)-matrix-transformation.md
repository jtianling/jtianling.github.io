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

mathjax: true

---

这里开始，是真正的与3D图形编程相关的知识了，前两节只能算是纯数学。

### 平移矩阵

要想将向量\\(x, y, z, 1\\)沿 x 轴平移\\(p_x\\)个单位，沿 y 轴平移\\(p_y\\)个单位，沿 z 轴平移\\(p_z\\)个单位，我们只需要将该向量与如下矩阵相乘。

$$
N(p)=
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & 1 & 0 & 0 \\
0 & 0 & 1 & 0 \\
p_x & p_y & p_z & 1
\end{bmatrix}
$$

从中可以看出 4×4 矩阵 N 中的 \\(N_{41}, N_{42}, N_{43}\\) 分别控制其在 x 轴、y 轴、z 轴上的平移单位。

$$
I=
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & 1 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

是单位矩阵，我们已经知道，乘以单位矩阵相当于没有乘的家伙。这个矩阵就是从单位矩阵稍微变下型，多了第 4 行的几个值。我们先来看 \\(p_x\\) 为最后结果做出的贡献，向量 \\(M(x,y,z,1)\\) 与矩阵 \\(N(p)\\) 相乘后，最后 X 坐标的值（也就是结果向量的第一个分量）为
\\(x\cdot1 + y\cdot0 + z\cdot0 + 1\cdot p_x = x + p_x\\)。

y、z 的公式一样，就不多说了。这里可以看到，对于实施矩阵平移计算来说，需要将原向量（3 维）扩充的一维（一般用 w 表示）设为 1，不然的话，上述 x 坐标
\\(x\cdot1 + y\cdot0 + z\cdot0 + 0\cdot p_x = x\\)，
也就是说，完全不会改变原向量了。

GNU Octave(matlab) 验证一下：

```matlab
> p = [1,0,0,0;0,1,0,0;0,0,1,0;2,3,4,1]
p =

   1   0   0   0
   0   1   0   0
   0   0   1   0
   2   3   4   1

> x
x =

   1   2   3   1

> x * p
ans =

   3   5   7   1
```

---

x = 2 + 1 = 3，依次类推，结果正确。

### 缩放矩阵

我们将一个单位矩阵沿 X 轴缩放 X 倍，Y 轴缩放 Y 倍，Z 轴缩放 Z 倍，可令该向量与下列矩阵相乘。

$$
S=
\begin{bmatrix}
s_x & 0   & 0   & 0 \\
0   & s_y & 0   & 0 \\
0   & 0   & s_z & 0 \\
0   & 0   & 0   & 1
\end{bmatrix}
$$

按公式推导：
X 坐标值为
\\(x\cdot s_x + y\cdot0 + z\cdot0 + 0\cdot0 = x s_x\\)。

y、z 的推导类似。

GNU Octave(matlab):

```matlab
> x = [1,2,3,0]
x =

   1   2   3   0

> p
p =

   2   0   0   0
   0   3   0   0
   0   0   4   0
   0   0   0   1

> x * p
ans =

    2    6   12    0
```

---

结果正确。

### 旋转矩阵：

旋转矩阵是在乘以一个向量的时候改变向量方向但不改变其大小的矩阵。旋转矩阵不包括反演。需要注意的是，进行旋转变换时，扩充 3 维向量的办法是令 w = 0。

我们可用如下 3 个矩阵将一个向量分别绕着 x、y、z 轴顺时针旋转 \\(\theta\\) 弧度。

$$
X(\theta)=
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & \cos\theta & -\sin\theta & 0 \\
0 & \sin\theta &  \cos\theta & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

$$
Y(\theta)=
\begin{bmatrix}
\cos\theta & 0 & \sin\theta & 0 \\
0 & 1 & 0 & 0 \\
-\sin\theta & 0 & \cos\theta & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

$$
Z(\theta)=
\begin{bmatrix}
\cos\theta & \sin\theta & 0 & 0 \\
-\sin\theta & \cos\theta & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

还是先看第一个公式，向量 \\(M(x,y,z,0)\\) 与矩阵 \\(X(\theta)\\) 相乘后：

* X 坐标：\\(x\\)
* Y 坐标：\\(y\cos\theta - z\sin\theta\\)
* Z 坐标：\\(y\sin\theta + z\cos\theta\\)
* w 分量：\\(0\\)

这个就复杂了，不太好直观地看到验证结果，我们将其收到 2 维去看。

我们利用 GNU Octave(matlab) 的 compass 命令在 2 维空间中直观显示向量
\\(x=[1, \tan(\pi/3), 0, 0]\\)。

围绕 Z 轴顺时针旋转 30 度，相当于乘以 \\(Z(\pi/6)\\)。

```matlab
> a = pi / 6

> p = [cos(a),sin(a),0,0;-sin(a),cos(a),0,0;0,0,1,0;0,0,0,1]

> x = [1, tan(pi/3), 0, 0]

> x2 = x * p
x2 =

   0.00000   2.00000   0.00000   0.00000
```

---

精确的 30 度。

后续 irrlicht 与 D3D 的实现，本质上都是对上述旋转矩阵及其乘法结果的直接应用。
