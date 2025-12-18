---
layout: post
title: "怎样在Unity3D中使用Json"
categories:
- "游戏开发"
tags:
- Json
- LitJson
- Unity3D
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  ratings_users: '2'
  ratings_score: '10'
  ratings_average: '5'
  views: '5009'
  ks_metadata: 'a:7:{s:4:"lang";s:2:"en";s:8:"keywords";s:48:"array,var,data,json,litjson,jtianling,mono,print";s:19:"keywords_autoupdate";s:1:"1";s:11:"description";s:157:"array
    : Array = Array(); array.Add(''haha''); array.Add(''haha2''); data = array; var
    data_string : String = LitJson.JsonMapper.ToJson(data); print(data_string);";s:22:"description_autoupdate";s:1:"1";s:5:"title";s:0:"";s:6:"robots";s:12:"index,follow";}'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

Unity3D中的javascript有些特异，和普通的javascript差异很大，其中eval就没法在iOS下使用（其实我在桌面版本也没有使用成功过）使得Json解析这种在javascript中非常原生态的事情变得不那么直接了。

直接使用eval后Unity3D给的错误信息很高端，我是没有看懂，应该是没有找到eval这个通用的函数：

Mono: AssemblyAssets/Scripts/Example/JTianLingExample.js(1,1): BCE0172: `UnityScript.Scripting.IEvaluationDomainProvider' interface member implementation must be public or explicit.

在网上找到了litjson库，通过这个支持.Net的库来曲线救国，折腾了一下，基本搞定。看网上讲litjson的资料很少，并且以C#居多，我这里就记录一下。

## LitJson配置步骤

1.讲litjson的源代码中所有.cs文件放到Unity3d的assets中的plugins目录下，当然，在plugins下再建一个目录最好。Unity3D文档描述中plugins目录中的脚本会先运行，这样保证在我们写其他脚本的时候，litjson已经加载并运行好了。不然的话，等着报这种错误吧：  
Mono: Image addref Mono.Cecil 0x1757740 -> /Applications/Unity/Unity.app/Contents/FramAssets/Scripts/Example/JTianLingExample.js(5,20): BCE0018: The name 'LitJson.JsonData' does not denote a valid type ('not found').

2.讲源代码放到plugins目录下后，会发现在Unity3d的editor中运行已经正常了，但是monodevelop中写javascript来调用litjson还是会报错误，也就是说monodevelop还是没有先运行litjson。因为C#的代码和javascript的代码在Unity3d生成的 项目中实际在几个不同的Project中，我们需要再配置一下：  
在MonoDevelop中的Project->Edit Reference->Projects中，选择一下引用项（就像VS中添加项目依赖一样）  
这里我们也会看到，放在plugins目录下的会放在Assembly-CSharp-firstpass中，而一般的脚本会放在Assembly-CSharp目录中。选上Assembly-CSharp-firstpass。

此时再在MonoDevelop中编译代码，顺利编译成功。

## LitJson使用方式

1.解析json：
    
    
    var s : String = '{"name":"jtianling", "phone" : ["135xxx", "186xxx"]}';
    var json : LitJson.JsonData = LitJson.JsonMapper.ToObject(s);
    print(json['name']);
    
    if (json['phone'].IsArray) {
      for (var json_data : LitJson.JsonData in json['phone']) {
        print(json_data);
      }
    }

输出名字和两个电话号码，如上所示，其实直接把JsonData当一个Map使用就好了，同时，还有一堆用于判断类型的IsXXX变量。比如，上例中，判断是否是数组的变量就是IsArray。

2.生成json字符串：
    
    
    var data : Hashtable = Hashtable();
    data['name'] = 'aaa';
    var array : Array = Array();
    array.Add('haha');
    array.Add('haha2');
    data['good'] = array;
    var data_string : String = LitJson.JsonMapper.ToJson(data);
    print(data_string);

输出：{"good":["haha","haha2"],"name":"aaa"}

也就是把使用map的过程反过来而已，不详细描述了。

另外，我们读取配置文件的时候常常是从文件中读取，我发现用Unity3D读取文件也值得单独写写，这个下次再讲。

原创文章作者保留版权 转载请注明原作者 并给出链接  
[九天雁翎(JTianLing) -- www.jtianling.com](<www.jtianling.com>)

 
