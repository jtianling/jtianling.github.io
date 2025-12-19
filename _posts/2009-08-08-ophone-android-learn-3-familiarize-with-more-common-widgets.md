---
layout: post
title: OPhone/Android的学习(3)—再熟悉几个常用的Widget
categories:
- Android
tags:
- Android
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

本文通过讲解Android消息弹窗的实现，帮助读者熟悉UI框架。重点介绍了用于简单提示的Toast和功能更复杂的AlertDialog两种方法。

<!-- more -->

[**OPhone/Android的学习(3) —**](<http://www.jtianling.com/archive/2009/08/04/4409464.aspx>)**再熟悉几个常用的Widget**



# 一、综述

其实相对来说，学习一个UI库（其实Android的API最重要的就是这一部分，其他的可以用原有的JAVA标准库）最最主要的是了解其大致框架，并不一定要了解了每一个控件/Widget的用法，因为所有的控件/Widget都是在同样的框架下展开的，了解了一种两种，其他的需要用到的时候看看文档，基本也就知道怎么用了，可以等到实际开发的时候再去学习。整体的框架大概需要了解哪些呢？包括整体程序的执行流程，控件/Widget的创建，销毁流程，消息/事件 的响应及处理方式等，知道了这些，其他的都可以算是枝叶末节。

前面几节Android的学习虽然非常基础，但是都是围绕着整体框架的，其实一般来说一个Hello Wolrd就已经说明了一个程序的一半，这里，再通过几个Widget来熟悉一下上述流程。解释就不多说了，具体的东西参考文档。

# 二、Message:

刚开始我一直在找Android弹出类似Windows MessageBox的对话框的办法，后来找到两种：

example1：

```java
**package** com.JTianLing;

**import** android.app.Activity;

**import** android.content.Context;

**import** android.os.Bundle;

**import** android.view.View;

**import** android.view.View.OnClickListener;

**import** android.widget.Button;

**import** android.widget.LinearLayout;

**import** android.widget.Toast;

**public** **class** DevXMLUI **extends** Activity {

    /** Called when the activity is first created. */

    @Override

    **public** **void** onCreate(Bundle savedInstanceState) {

        **super**.onCreate(savedInstanceState);

        LinearLayout layout = **new** LinearLayout(**this**);

       

        Button button = **new** Button(**this**);

        button.setText("I'm So great Button");

        button.setOnClickListener(**new** OnClickListener(){

       	  @Override

       	  **public** **void** onClick(View v) {

   	        Context context = getApplicationContext();

   	        CharSequence text = "Hello toast!";

   	        **int** duration = Toast._LENGTH_SHORT_ ;



   	        Toast toast = Toast._makeText_(context, text, duration);

   	        toast.show();

       	  }

        });

        layout.addView(button);

        setContentView(layout);

    }

}
```

运行效果见插图1，点击按钮的时候弹出一个Toast,为啥叫这个，我也不明白。类似于一个Notice的效果，可以自动消隐。

另外一种比较正规，也就是通过对话框，只不过Android里面没有类似MessageBox一样使用简单的对话框，相对来说复杂一点。

Example2:

```java
**package** com.JTianLing;

**import** android.app.Activity;

**import** android.app.AlertDialog;

**import** android.app.Dialog;

**import** android.content.DialogInterface;

**import** android.os.Bundle;

**import** android.view.View;

**import** android.view.View.OnClickListener;

**import** android.widget.Button;

**import** android.widget.LinearLayout;

**public** **class** DevXMLUI **extends** Activity {

    **static** **final** **int** _DIALOG_PAUSED_ID_ = 0;

    @Override **protected**

    Dialog onCreateDialog (**int** id)

    {

       AlertDialog.Builder builder = **new** AlertDialog.Builder(**this**);

       builder.setMessage("Are you sure you want to exit?")

      	      .setCancelable(**false**)

      	      .setPositiveButton("Yes", **new** DialogInterface.OnClickListener() {

      	          **public** **void** onClick(DialogInterface dialog, **int** id) {

      	       	    DevXMLUI.**this**.finish();

      	          }

      	      })

      	      .setNegativeButton("No", **new** DialogInterface.OnClickListener() {

      	          **public** **void** onClick(DialogInterface dialog, **int** id) {

      	               dialog.cancel();

      	          }

      	      });

       AlertDialog alert = builder.create();

       **return** alert;

    }

    /** Called when the activity is first created. */

    @Override

    **public** **void** onCreate(Bundle savedInstanceState) {

        **super**.onCreate(savedInstanceState);

        LinearLayout layout = **new** LinearLayout(**this**);

   	   

        Button button = **new** Button(**this**);

        button.setText("I'm So great Button");

        button.setOnClickListener(**new** OnClickListener(){

       	  @Override

       	  **public** **void** onClick(View v) {

       	     showDialog(_DIALOG_PAUSED_ID_);

      	   }

        });

        layout.addView(button);

        setContentView(layout);

    }

}
```

还是单击那个伟大的按钮，才能弹出对话框，效果如插图2。

至于这个复杂程序，我是比较有意见的。。上面那一大堆程序，其实在Windows这种已经是宇宙中最复杂的操作系统中实现都只需要1，2句话。。。。唉。。。。曾经多么常用的MessageBox啊。。。我甚至看到最极端的使用情况\----一次我们游戏在一个玩家的机器上就是跑补起来，甚至连日志都打不出来，总监于是在每隔几行弹出一个MessageBox在玩家的机器上跟踪程序运行情况-_-!

暂告一段落

至此，对于一般的Android的Widget不再进一步的深入学习，原理上基本上差不多，碰到需要的时候再去翻文档学习就好了。。。。毕竟我是来尝鲜的-_-!用了我4，5天的下班时间熟悉了一下Android，本质上。。。我还是个靠C++开发网络游戏服务器端程序的程序员，虽然由于工作需要，又碰巧刚开始工作的时候开发过客户端，所以经常到客户端客串编写一些与服务器交互性比较强的模块。

以后，考虑学习自己感兴趣的东西，对于我来说基本也就两部分，作为服务器端程序员，我关心网络，作为开发游戏的程序员我关心图形接口，这些以后就不放入这个系列，另开一个系列。

插图1： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080809_1235_OPhoneAndro1.jpg)

插图2： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080809_1235_OPhoneAndro2.jpg)

