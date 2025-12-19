---
layout: post
title: "《数据结构与算法分析C++描述》 搜索二叉树的C++实现"
categories:
- "算法"
tags:
- C++
- "《数据结构与算法分析C++描述》"
- "二叉树"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文分享了C++搜索二叉树的完整实现代码。该树未做平衡，主要用递归实现，包含增删查等核心操作。

<!-- more -->

**《数据结构与算法分析C++描述》**  
**搜索二叉树的C++实现**

**write by 九天雁翎(JTianLing) -- www.jtianling.com**

《数据结构与算法分析c++描述》 Mark Allen Weiss著  
人民邮电大学出版  
中文版第93-100面，搜索二叉树  

需要说明一点的是，此搜索二叉树并没有平衡算法，所以可能会导致有可能出现O(M logN)的最坏情况。  

并且几乎所有代码都用递归实现，所以效率并不是太高，并且当N足够大的时候，很多操作都可能导致栈溢出。但是因为对于树的操作用递归描述起来理解上还是比循环好的多，并且以后可以用平衡算法，所以这里都用递归了。  

搜索二叉树的实现：

```cpp
1   
2 #ifndef __BINARY_SEARCH_TREE_H__
3 #define __BINARY_SEARCH_TREE_H__
4   
5 **template** <**typename** T>
6 **class** CBinarySearchTree
7 {
8 **public** :
9  CBinarySearchTree():mpRoot(NULL) { }
10  CBinarySearchTree(**const** CBinarySearchTree& aOrig)
11  {
12  mpRoot = Clone(aOrig.mpRoot);
13  }
14  ~CBinarySearchTree()
15  {
16  MakeEmpty();
17  }
18   
19  ////////////////////////////////////////////
20  // const member function
21  ////////////////////////////////////////////
22  **const** T* FindMin() **const** ;
23  **const** T* FindMax() **const** ;
24   
25  **bool** Contains( **const** T& aElement) **const** ;
26  **bool** IsEmpty() **const**
27  {
28  **return** (mpRoot != NULL) ? true : false;
29  }
30   
31  // I don't know how to print it in a good format
32  //void PrintTree() const;
33   
34  ////////////////////////////////////////////
35  // non-const member function
36  ////////////////////////////////////////////
37  **void** MakeEmpty();
38  **void** Insert( **const** T& aElement);
39  **void** Remove( **const** T& aElement);
40   
41  **const** CBinarySearchTree& **operator** =(**const** CBinarySearchTree& aOrig);
42   
43 **private** :
44  **struct** CBinaryNode
45  {
46  CBinaryNode(**const** T& aElement, CBinaryNode* apLeft, CBinaryNode* apRight)
47  : mElement(aElement),mpLeft(apLeft),mpRight(apRight) { }
48   
49  T mElement;
50  CBinaryNode *mpLeft;
51  CBinaryNode *mpRight;
52  };
53   
54  // Root Node
55  CBinaryNode *mpRoot;
56   
57  ////////////////////////////////////////////
58  // private member function to call recursively
59  ////////////////////////////////////////////
60   
61  // I don't like to use reference to pointer
62  // so I used pointer to pointer instead
63  **void** Insert(**const** T& aElement, CBinaryNode** appNode) **const** ;
64  **void** Remove(**const** T& aElement, CBinaryNode** appNode) **const** ;
65   
66  CBinaryNode* FindMin(CBinaryNode* apNode) **const** ;
67  CBinaryNode* FindMax(CBinaryNode* apNode) **const** ;
68  **bool** Contains(**const** T& aElement, CBinaryNode * apNode) **const** ;
69  **void** MakeEmpty(CBinaryNode** apNode);
70  //void PrintTree(CBinaryNode* apNode) const;
71  CBinaryNode* Clone(CBinaryNode* apNode) **const** ;
72   
73 };
74   
75   
76 **template** <**typename** T>
77 **bool** CBinarySearchTree::Contains(**const** T& aElement) **const**
78 {
79  **return** Contains(aElement, mpRoot);
80 }
81   
82 **template** <**typename** T>
83 **bool** CBinarySearchTree::Contains(**const** T &aElement;, CBinaryNode *apNode) **const**
84 {
85  **if**( NULL == apNode )
86  {
87  **return** false;
88  }
89  **else** **if** ( aElement < apNode->mElement )
90  {
91  **return** Contains(aElement, apNode->mpLeft);
92  }
93  **else** **if** ( aElement > apNode->mElement )
94  {
95  **return** Contains(aElement, apNode->mpRight);
96  }
97  **else**
98  {
99  **return** true; // Find it
100  }
101 }
102   
103 **template** <**typename** T>
104 **void** CBinarySearchTree::Insert(**const** T &aElement;)
105 {
106  Insert(aElement, &mpRoot;);
107 }
108   
109 **template** <**typename** T>
110 **void** CBinarySearchTree::Insert(**const** T& aElement, CBinaryNode** appNode) **const**
111 {
112  CBinaryNode *lpNode = *appNode;
113  **if**(NULL == lpNode)
114  {
115  *appNode = **new** CBinaryNode(aElement, NULL, NULL);
116  }
117  **else** **if**( aElement < lpNode->mElement )
118  {
119  Insert(aElement, &(lpNode->mpLeft) );
120  }
121  **else** **if**( aElement > lpNode->mElement)
122  {
123  Insert(aElement, &(lpNode->mpRight) );
124  }
125   
126  // had not deal with duplicate
127 }
128   
129 **template** <**typename** T>
130 **void** CBinarySearchTree::Remove(**const** T &aElement;)
131 {
132  Remove(aElement, &mpRoot;);
133 }
134   
135 **template** <**typename** T>
136 **void** CBinarySearchTree::Remove(**const** T &aElement;, CBinaryNode** appNode) **const**
137 {
138  CBinaryNode* lpNode = *appNode;
139  **if**(NULL == lpNode)
140  {
141  **return** ; // Item removing is not exist
142  }
143   
144  **if**( aElement < lpNode->mElement )
145  {
146  Remove(aElement, &(lpNode->mpLeft) );
147  }
148  **else** **if**( aElement > lpNode->mElement )
149  {
150  Remove(aElement, &(lpNode->mpRight) );
151  }
152  **else** **if**( NULL != lpNode->mpLeft && NULL != lpNode->mpRight) // Two children
153  {
154  lpNode->mElement = FindMin(lpNode->mpRight)->mElement;
155  Remove( lpNode->mElement, &(lpNode->mpRight) );
156  }
157  **else**
158  {
159  CBinaryNode *lpOldNode = lpNode;
160  // Even if lpNode equal NULL, this is still the right behavior we need
161  // Yeah,When lpNode have no children,we make lpNode equal NULL
162  *appNode = (lpNode->mpLeft != NULL) ? lpNode->mpLeft : lpNode->mpRight;
163  **delete** lpOldNode;
164  }
165 }
166   
167   
168 **template** <**typename** T>
169 **const** T* CBinarySearchTree::FindMin() **const**
170 {
171  CBinaryNode* lpNode = FindMin(mpRoot);
172  **return** (lpNode != NULL) ? &(lpNode->mElement) : NULL;
173 }
174   
175   
176 // damn it! So redundant words to fit to C++ syntax
177 // the only way to fix this problom is compositing defines and declares
178 // I even doubt that are there programmers could write it right
179 **template** <**typename** T>
180 **typename** CBinarySearchTree::CBinaryNode * CBinarySearchTree::FindMin(CBinaryNode* apNode) **const**
181 {
182  **if**( NULL == apNode)
183  {
184  **return** NULL;
185  }
186  **else** **if**( NULL == apNode->mpLeft)
187  {
188  // Find it
189  **return** apNode;
190  }
191  **else**   
192  {
193  **return** FindMin(apNode->mpLeft);
194  }
195 }
196   
197 **template** <**typename** T>
198 **const** T* CBinarySearchTree::FindMax() **const**
199 {
200  CBinaryNode* lpNode = FindMax(mpRoot);
201  **return** (lpNode != NULL) ? &(lpNode->mElement) : NULL;
202 }
203   
204 **template** <**typename** T>
205 **typename** CBinarySearchTree::CBinaryNode * CBinarySearchTree::FindMax(CBinaryNode* apNode) **const**
206 {
207  **if**( NULL == apNode)
208  {
209  **return** NULL;
210  }
211  **else** **if**( NULL == apNode->mpRight)
212  {
213  // Find it
214  **return** apNode;
215  }
216  **else**   
217  {
218  **return** FindMax(apNode->mpRight);
219  }
220 }
221   
222 **template** <**typename** T>
223 **void** CBinarySearchTree::MakeEmpty()
224 {
225  MakeEmpty(&mpRoot;);
226 }
227   
228   
229 **template** <**typename** T>
230 **void** CBinarySearchTree::MakeEmpty(CBinaryNode** appNode)
231 {
232  CBinaryNode* lpNode = *appNode;
233  **if**( lpNode != NULL)
234  {
235  MakeEmpty( &(lpNode->mpLeft) );
236  MakeEmpty( &(lpNode->mpRight) );
237  **delete** lpNode;
238  }
239   
240  *appNode = NULL;
241 }
242   
243 // how long the syntax is...............
244 **template** <**typename** T>
245 **const** CBinarySearchTree& CBinarySearchTree::**operator** =(**const** CBinarySearchTree &aOrig;)
246 {
247  **if**(&aOrig; == **this**)
248  {
249  **return** * **this** ;
250  }
251   
252  MakeEmpty();
253  mpRoot = Clone(aOrig.mpRoot);
254   
255  **return** * **this** ;
256   
257 }
258   
259 // when you use nest class and template both,you will find out how long the C++ syntax is.....
260 // I use it once,I ask why couldn't we have a short once again.
261 **template** <**typename** T>
262 **typename** CBinarySearchTree::CBinaryNode* CBinarySearchTree::Clone(CBinaryNode *apNode) **const**
263 {
264  **if**(NULL == apNode)
265  {
266  **return** NULL;
267  }
268   
269  // abuse recursion
270  **return** **new** CBinaryNode(apNode->mElement, Clone(apNode->mpLeft), Clone(apNode->mpRight));
271 }
272   
273   
274   
275   
276 #endif // __BINARY_SEARCH_TREE_H__
```

测试代码：

```cpp
1 #include   
2 #include "BinarySearchTree.h"
3 **using** **namespace** std;
4   
5 **int** _tmain(**int** argc, _TCHAR* argv[])
6 {
7  CBinarySearchTree<**int** > loTree;
8   
9  loTree.Insert(10);
10  loTree.Insert(20);
11  loTree.Insert(30);
12  loTree.Insert(40);
13  cout <<"Min: " <<*loTree.FindMin() <<" Max: " <<*loTree.FindMax() <<" IsContains(20) "<20) <
14  loTree.Remove(40);
15  cout <<"Min: " <<*loTree.FindMin() <<" Max: " <<*loTree.FindMax() <<" IsContains(20) " <20) <
16  loTree.Remove(30);
17  loTree.Remove(20);
18  loTree.Remove(10);
19   
20   
21  loTree.Insert(40);
22  cout <<"Min: " <<*loTree.FindMin() <<" Max: " <<*loTree.FindMax() <<" IsContains(20) " <20) <
23  loTree.Insert(30);
24  loTree.Insert(20);
25  loTree.Insert(10);
26  cout <<"Min: " <<*loTree.FindMin() <<" Max: " <<*loTree.FindMax() <<" IsContains(20) " <20) <
27  loTree.Remove(40);
28  loTree.Remove(30);
29  loTree.Remove(20);
30  loTree.Remove(10);
31   
32  loTree.Insert(30);
33  loTree.Insert(40);
34  cout <<"Min: " <<*loTree.FindMin() <<" Max: " <<*loTree.FindMax() <<" IsContains(20) " <20) <
35  loTree.Insert(10);
36  loTree.Insert(20);
37  cout <<"Min: " <<*loTree.FindMin() <<" Max: " <<*loTree.FindMax() <<" IsContains(20) " <20) <
38  CBinarySearchTree<**int** > loTree2 = loTree;
39  cout <<"Min: " <<*loTree2.FindMin() <<" Max: " <<*loTree2.FindMax() <<" IsContains(20) " <20) <
40   
41  loTree.MakeEmpty();
42   
43   
44   
45  system("pause");
46  **return** 0;
47 }
48  
```

**write by 九天雁翎(JTianLing) -- www.jtianling.com**
