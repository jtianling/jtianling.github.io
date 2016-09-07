---
layout: post
title: 从Wordpress中导入友言的评论
date: 2014-05-21
comments: true
categories: 编程
tags: 
- Github Page
- Jekyll
- Octpress
- Wordpress
- 友言
- Ruby
---

Github Page是静态网页, 本身是没有评论系统的, 国外的好像比较流行[Disqus][], 国外的模版一般都是接的[Disqus][], 我以前一直用的是友言, 正好也是类似的系统, 也能用, 但是碰到一个问题, [友言][]的评论是以URL为标识的, 而新改了Github Page以后所有博客文章的地址都变了, 所以虽然评论都还保留在[友言][]的服务器上, 但是其实所有的评论都匹配不了新的文章, 等于都丢失了咨询了[友言][]的客服, 没有解决办法, 但是好在[友言][]还算是国内比较开放的企业, 有数据导入和导出功能, 所以感觉可以把评论数据都导出, 然后经过修改, 改成新博客需要的形式, 然后再导入, 实际检验, 这条路还是走通了, 所以如你所见, 原来的评论都还在, 只是貌似[友言][]的数据导入导出有Bug, 把评论的登录信息都丢了.  本文记录的就是这个过程, 和相关的代码, 希望能对其他碰到类似情况的人有帮助.  

<!-- more -->

**目录**:

* TOC
{:toc}

# 导出
在[友言][]的后台管理里面, 选择安装备份->导出数据, 友言就开始生成导出的数据了, 隔一段时间后, 回来下载即可.  
友言导出的数据格式是个Json文件, 格式如下:(来自官网的说明)
~~~ json
[
{
	"su": "",
		"url": "http://d.com/a.html",
		"title": "测试一下，你就知道",
		"content": "c",
		"time": "2012-10-09 10:40:29",
		"uname": "test",
		"email": "zhangsan@sina.com",
		"ulink": "http://blog.jiathis.com",
		"status": "0",
		"child": [
		{
			"content": "@test: e",
			"time": "2012-10-09 10:40:51",
			"uname": "test",
			"email": "zhangsan@sina.com",
			"ulink": "http://blog.jiathis.com",
			"status": "0"
		},
		{
			"content": "@test: d",
			"time": "2012-10-09 10:40:37",
			"uname": "test",
			"email": "zhangsan@sina.com",
			"ulink": "http://blog.jiathis.com",
			"status": "0"
		}
	]
}
]
~~~

## 字段解释：
* su: 自定义页面标识 (如果定义了页面标识则填写，未定义则留空)
* url: 页面地址 (su或者url必选一个)
* title: 页面标题 (非必选)
* content: 评论内容 (必选)
* time: 评论时间 (如果没有时间可以不用填写，但是强烈建议填写，以便评论排序)
* uname: 昵称 (必选)
* email: 邮箱地址 (非必选)
* ulink: 个人主页链接地址 (非必选)
* status: 评论状态： 0：正常, 1：待验证, 2：垃圾，3：已被删除 (非必选，默认是正常评论)
* child: 子评论，格式和父级评论大致相同，但是子集评论无更下一级的评论 (包括content，time，uname，email，ulink，status) 

可以看到导出信息里面的确没有登录信息, 所以再次导入后, 只能看到正确的用户名, 但是已经看不出来用户是从哪登录并且评论的了.  

# 问题
看了导出的格式以后, 目的就很明确了, 只需要把原来的url改成新的url就可以了, 但是问题来了, 博客改版的比较扭曲, 没有从原来url到新url的映射规则.  
于是首先需要找出这个映射规则, 我想到的办法比较直接, 就是用文章的名字来做映射, 因为url再变, 文章名字其实没变.  
这里有几个办法, 可以直接扒[所有文章](/archive.html)页面, 然后从里面抓出相关的信息, 但是感觉这样太麻烦了, 我直接在博客中加了一个for_comment.json的json文件, 利用Jekyll的静态网页生成功能, 通过Jekyll生成了一个需要的Json格式的文件.  原文件如下:

{% raw %} 
~~~
---
layout: none
---
[
 {% for post in site.posts %}{
	"date" : "{{ post.date | date: "%Y-%m-%d" }}",
	"url" : "{{site.url }}{{ post.url }}",
	"title" : "{{ post.title }}"
},{% endfor %}
]
~~~
{% endraw %} 

通过`jekyll build`生成网页后, 得到了如下包含日期, url, title等关键信息的json文件, 这样方便处理.

~~~ json
[
    {
        "date": "2013-12-05",
        "url": "http://www.jtianling.com/procrastination-is-not-a-big-deal.html",
        "title": "拖拉一点也无妨"
    },
    {
        "date": "2013-08-21",
        "url": "http://www.jtianling.com/a-childhood-dream-come-true-building-spine.html",
        "title": "[译]儿时梦想成真: Spine背后的故事"
    }
~~~

# 处理
接下来的事情就简单了, 一个Ruby程序的事情:

~~~ ruby
#!/usr/bin/env ruby
require 'json'
require 'set'

# read the jekyll built file
$list_file = File.read('list.json')
$list_obj = JSON.parse($list_file)

# read the uyan exported file
$export_file = File.read('export.json')
$export_obj = JSON.parse($export_file)
$export_set = Set.new

# build the map
$export_obj.each do |obj|
	$export_set.add obj['title']
end
puts "comment count: #{$export_obj.count}"
puts "all file count: #{$list_obj.count}"
puts "Export set count #{$export_set.count}"

$match_count = 0
$changed_count = 0
$list_obj.each do |obj|
	if $export_set.include? obj['title'] then
		$match_count += 1
		$export_set.delete obj['title']
	end

	$export_obj.each do |comment|
		if comment['title'] == obj['title'] then
			$changed_count += 1
			comment['url'] = obj['url']
		end
	end
end

# summarize the result and output the Not matched article title.
$export_set.each do |title|
	puts "Not matched title #{title}"
end

puts "Matched count #{$match_count}"
puts "Changed comment count #{$changed_count}"

# write changed export file
File.open('changed.json', 'w') do |f|
	f.write(JSON.pretty_generate($export_obj))
end
~~~

# 总结
最终的结果还是让人满意的, 这个过程中特别不让人满意的是友言的支持, 由于我的博客评论有2000多条, 190多页, 友言又没有提供一次删除的操作, 最多一次只能删一页, 我要通过导出再导入的办法恢复评论的话, 原来的评论其实是已经没有用了, 但是要删190多页, 这个太折磨人了, 找友言的客服帮下忙, 要他清空一下我友言的数据库, 我再导入其实就好了, 但是就是这么简单的需求, 友言的客服一再的推脱, 找各种理由, 提出各种不能忍的解决方案:

* 新建一个帐号 -- 我之所以用友言, 就是因为他和[jiathis](http://jiathis.com/), [友荐](http://www.ujian.cc/)一个帐号, 比较方便, 可以统一管理, 要是新建一个友言帐号, 我的jiathis, 友荐帐号就都得变, 不能接受
* 手工删除 -- 等于没有提供任何解决方案

最不能接受的是, 不提供解决方案就算了, 还一味的跟我说友言就是要尽最大可能保存用户的数据, 不知道这跟我需要的操作有什么关系, 难道其他网站都不要保存用户数据了? 连github都有彻底删除仓库的方法啊.  总之就是不给我弄, 最后我真只能一页一页的都删了(190多页), 真的非常无奈.  假如不是因为jiathis和友荐, 我一定投向多说了.

[Disqus]: http://disqus.com/
[友言]: http://www.uyan.cc
