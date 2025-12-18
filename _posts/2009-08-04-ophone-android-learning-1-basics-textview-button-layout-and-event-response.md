---
layout: post
title: OPhone/Android的学习(1)—初步知识，TextView,Button,Layout及事件响应
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
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**OPhone/Android的学习(1) —初步知识，TextView,Button,Layout及事件响应 **

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)****

[讨论新闻组及文件](<http://groups.google.com/group/jiutianfile/>)

中移动强大的号召力让我暂时停止了前段时间兴趣浓厚的图形编程学习，说起来，无论是图形编程还是Android编程都算是编程领域比较充满趣味的部分，《C语言专家编程》作者就说过，用软件控制硬件总是编程最有乐趣的部分：）图形编程这样容易出成果，让自己看到自己的程序展示的方式，也是同样充满趣味的，何况，这也算是用软件控制硬件（显卡）的一种方式。 

今天继续Android的学习，因为OPhone与Android兼容，那么就是说，我也是在学习OPhone。。。。。。呵呵 

昨天用ADT自动生成的Hello World程序用了很多东西，资源啊，什么的一大堆，弄得比较复杂，源代码如下： 

```java
**package** oms.hello;

**import** android.app.Activity;

**import** android.os.Bundle;

**public** **class** HelloOPhone **extends** Activity {
/** Called when the activity is first created. */
@Override
**public** **void** onCreate(Bundle savedInstanceState) {
**super**.onCreate(savedInstanceState);
setContentView(R.layout._main_);
}
}
```

另外说一句，Eclipse是Windows下我用过的除了VS以外能够直接带程序着色复制的IDE程序，一般的开源的都不好用，Eclipse还算是比较强大。这个代码是简单了。。。。。。但是R.layout.main的出现将问题复杂了，我当时就没有弄清楚Hello Android是怎么来的，后来才发现实在资源里面。这点和一般我们写的程序有点不一样（可能主要是为了大型程序的设计成这样的），作为一个Hello World都这样拐弯抹角就让人受不了了，Google的Andorid教程中就交给我们了另一个较为直观的HelloWorld程序，源代码如下： 

```java
**package** oms.hello;

**import** android.app.Activity;

**import** android.os.Bundle;

**import** android.widget.TextView;

**public** **class** HelloOPhone **extends** Activity {
/** Called when the activity is first created. */
@Override
**public** **void** onCreate(Bundle savedInstanceState) {
**super**.onCreate(savedInstanceState);
TextView tv = **new** TextView(**this**);
tv.setText("Hello, Android");
setContentView(tv);
}
}
```

这样的程序相对来说就直观多了，也符合一般的HelloWorld的简洁，这个程序即使是不了解JAVA的人应该也能一眼看明白。 

    Android中的窗口都叫View，TextView自然是Android的文字显示窗口。创建TextView的时候将整个HelloOPhone这个Activity的指针传进了TextView，指定了View的范围，setText指定了View的文字内容，setContentView将此View设为Activity的内容。。。。其实程序简洁，描述反而复杂了。 

既然HelloWorld用到了TextView，我们来挖掘一下有用的信息，从Android的Reference中可以看到如下内容： 

Known Direct Subclasses 

[Button](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/Button.html>), [CheckedTextView](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/CheckedTextView.html>), [Chronometer](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/Chronometer.html>), [DigitalClock](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/DigitalClock.html>), [EditText](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/EditText.html>)

Known Indirect Subclasses 

[AutoCompleteTextView](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/AutoCompleteTextView.html>), [CheckBox](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/CheckBox.html>), [CompoundButton](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/CompoundButton.html>), [ExtractEditText](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/inputmethodservice/ExtractEditText.html>), [MultiAutoCompleteTextView](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/MultiAutoCompleteTextView.html>), [RadioButton](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/RadioButton.html>), [ToggleButton](<file:///D:/android-sdk-windows-1.5_r3/docs/reference/android/widget/ToggleButton.html>)

这个一看就牛了，Button,EditText等都是从TextView继承过来的直接子类，既然用到了TextView了，我们也尝试用下这两个看到名字我们就能知道作用的Widget,至于更进一步的CheckBox,RadioButton,ToggleButton也是非常熟悉了，这里就不看了。 

先看看Button，到底能不能有效： 

```java
**package** oms.hello;

**import** android.app.Activity;

**import** android.os.Bundle;

**import** android.widget.Button;

**import** android.widget.TextView;

**public** **class** HelloOPhone **extends** Activity {
/** Called when the activity is first created. */
@Override
**public** **void** onCreate(Bundle savedInstanceState) {
**super**.onCreate(savedInstanceState);
TextView tv = **new** Button(**this**);
tv.setText("Hello, Android");
setContentView(tv);
}
}
```

上面的程序显示出来的效果如下： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080409_1446_Android11.jpg)

 

左边的是普通显示画面，右边的是按下后的样子，很明显按钮的特性显示出来了。。。。呵呵，注意，我仅仅改变了new出来的对象，没有改变原TextView类型的tv值，因为Button从TextView继承而来，所以我们可以这样做。 

这个按钮实在太大了，几乎已经看不出是个按钮了。。。。给他瘦瘦身吧。直觉反应的程序应该是下面这样的： 

```java
**package** oms.hello;

**import** android.app.Activity;

**import** android.os.Bundle;

**import** android.widget.Button;

**public** **class** HelloOPhone **extends** Activity {
/** Called when the activity is first created. */
@Override
**public** **void** onCreate(Bundle savedInstanceState) {
**super**.onCreate(savedInstanceState);
Button btn = **new** Button(**this**);
btn.setText("Hello, Android");
btn.setWidth(100);
btn.setHeight(100);
setContentView(btn);
}
}
```

事实上这个程序与上例中一模一样，还是整个按钮充满了整个Activity。思考了一下，可能问题出在setContentView一句上，因为此举设定了整个内容，这样相当于拉伸效果，否定了整个按钮的设定长宽的效果。既然是这样的思路，那么自然就需要将Button放入某个容器中，让Android显示此容器，用此容器撑满整个屏幕，然后让Button属于此容器的一个子Widget，以调整大小，有了此思路，在文档中一搜索，就出现了目标，有两个layout类，layout是多么的熟悉啊，QT中让人解脱的类，MFC中缺乏导致的对话框程序进行缩放编程就是噩梦的类。有了目标，尝试看看，是否如直觉所示。 

如下程序，达到了我们的目的： 

```java
**package** oms.hello;

**import** android.app.Activity;

**import** android.os.Bundle;

**import** android.widget.Button;

**import** android.widget.LinearLayout;

**public** **class** HelloOPhone **extends** Activity {
/** Called when the activity is first created. */
@Override
**public** **void** onCreate(Bundle savedInstanceState) {
**super**.onCreate(savedInstanceState);
LinearLayout layout = **new** LinearLayout(**this**);
Button btn = **new** Button(**this**);
btn.setText("Hello, Android");
layout.addView(btn, 100, 50);
setContentView(layout);
}
}
```

效果如下： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080409_1446_Android12.jpg)

 

 

所以说，其实学的东西多了，杂了，其实还有一定作用的，毕竟很多东西是相通的，比如这次的layout,呵呵。 

有按钮了，点了总要有点反应吧，响应个消息吧。 

见下例： 

```java
**package** oms.hello;

**import** android.app.Activity;

**import** android.os.Bundle;

**import** android.view.View;

**import** android.view.View.OnClickListener;

**import** android.widget.Button;

**import** android.widget.LinearLayout;

**public** **class** HelloOPhone **extends** Activity **implements** OnClickListener{ 
/** Called when the activity is first created. */
    **boolean** isClicked = **false** ;
    @Override **public** **void** onClick(View v) {
        **if**( v **instanceof** Button) {
            **if**(!isClicked) {
                ((Button)v).setText("Hello, New Button.");
                isClicked = **true** ;
            }
            **else**
            {
                ((Button)v).setText("Hello, Old Button.");
                isClicked = **false** ;
            }
        }
    }

@Override
**public** **void** onCreate(Bundle savedInstanceState) {
**super**.onCreate(savedInstanceState);
LinearLayout layout = **new** LinearLayout(**this**);
Button btn = **new** Button(**this**);
btn.setText("Hello, Android");

// 添加一个OnClick事件响应的监听对象
btn.setOnClickListener(**this**);
layout.addView(btn, 100, 50);
setContentView(layout);
}
}
```

这个程序一下子复杂了很多，几点说明：要响应事件(Event)，需要有监听事件的对象，这个对象在Android中属于Listener一族的接口类，实现这个类的接口，然后通过setOnxxxxListener指定Listener后，一旦有监听(Listening)的事件，则相应的函数（即实现接口的那个函数）就会被调用，并且，发生事件的对象也会通过参数传入此函数。上例中有点特殊的是HelloOPhone本身实现了OnClickListener，这样的话，直接在类中用this表示Listener比较方便（这也是Android文档中提到过的方法），上例实现了一个动态改变的按钮。效果如下： 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_080409_1446_Android13.jpg)

首先显示的是第一个按钮，点击一下后，显示的是第二个按钮，再点击则显示第三个按钮，以后的点击，按钮在第二个按钮与第三个按钮间来回切换。 

 

[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)