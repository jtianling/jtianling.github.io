---
layout: post
title: 用Github Pages写博客
date: 2014-05-19
comments: true
categories: 随笔
tags: 
- Github page
- Jekyll
- Octpress
- Wordpress
---

最近博客的确写的又少了很多, 也发生了很多事情, 生活的变化也挺大的, 一直忙的不可开交.  最近这段时间可能能逐渐的稍微舒缓一些, 趁这个机会也学习一下自己一直想学习的东西, 做一些自己一直想做的事情吧.  首先要做的, 是恢复博客的更新, 作为起点, 废除了原来架设于Linode上的Wordpress博客, 改为用Github Pages来写博客, 据说每个开始用Github Pages写博客的人都会写篇博客纪念, 我也不免俗吧, 也写一篇博客记录一下.

<!-- more -->

**目录**:

* TOC
{:toc}

# 为什么要用Github Pages
最重要的原因应该说是觉得每年花一千多租个Linode的服务器就为写博客有些浪费了, 虽然说也可以顺便用SSH做梯子, 但是还是浪费.
同时, 我建在Linode上的博客服务用的是Wordpress, 而Wordpress是用PHP写的, 我对PHP挺没有好感的, 所以一直没有怎么学习, 所以自己想改起来也挺不顺手的, 基于这个原因, 虽然我已经给Wordpress改了一个我自己觉得还可以的模版, 但是还是挺不爽的.
另外, Wordpress的博客速度真的挺慢的, 尽管我已经用了Linode这种相对来说比较昂贵的服务器了, 但是还是挺慢, 用了静态Cache也还是, 可能原来那个Wordpress的模版本身就是个慢东西.
综上所述, 换个博客其实挺有必要的, 同时又正好有Github Pages这个好东西, 我又早就换了Vimpress + Markdown写博客了, 又没有什么障碍, 为什么不用这种免费, 速度快, 操作又方便的服务呢?

# 静态网站生成的选择
要用Github Pages没有什么障碍了, Github Pages目前用的是[Jekyll](http://jekyllrb.com/)(Jekyll是用ruby写的, 这个就更加应该要用了..)生成静态网页, 在一开始, 查找了一些资料以后, 我原以为[Octpress](octopress.org/)会方便一些, 所以先试用了一段时间的Octpress, 但是因为Octpress比较长时间没有更新了, 用的还是非常老版本的[Jekyll](http://jekyllrb.com/)及其他依赖库, 感觉很不爽, 同时要改模版的时候, 为了找到对应的include文件需要找好几层, 这个也觉得有些繁琐, 虽然Octpress整体设计的我觉得还是OK的, 但是最后我还是放弃了. 所以决定直接用Jekyll, 并且准备自己从头写Jekyll的模版, 在为Jekyll加入Bootstrap的时候发现了Jekyll Bootstrap这个项目, 于是也试用了一下, 因为和Octpress类似的原因, 也放弃了.  
经过一番折腾以后, 感觉用任何第三方的东西都是挺浪费时间的, 再也没找过其他的程序了, 坚定的直接用Jekyll了.

# 博客风格
重头写一个博客对我这种对网页开发不熟悉的人来说实在太费劲, 还是找找模版来的快, 在[Jekyll themes网站](http://jekyllthemes.org/)上看了一遍所有的模版, 包括Octpress的模版, 我感觉符合我审美的有下面这些: 
* [Octpress whitespace](http://lucaslew.com/)
* [hpstr](http://mmistakes.github.io/hpstr-jekyll-theme/)
* [mmistakes](http://mmistakes.github.io/minimal-mistakes/)
* [lanyon](http://lanyon.getpoole.com/)
* [Adrian Artiles's Blog](http://adrianartiles.com/)

其中我最喜欢的是whitespace和lanyon这两个模版, 在正犹豫不觉用哪个模版的时候, 阴差阳错的走进了[brume模版](http://dzerviniks.com/brume/)制作者[Aigars Dzerviniks自己的博客](http://dzerviniks.com/), 瞬间被其博客的文艺气息所吸引, 然后就决定改成用他博客的模版了, 但是他博客的模版其实并没有公布出来, 走运的是通过github找到了他本人的帐号, 并且他的博客也正好使用Github page制作的, 所以就给我扒回来了.  当然也没法直接用, 最终的改动挺多, 但是整体的风格还是Aigars Dzerviniks的博客. 

# 模版的改动
## 增加了搜索功能
代码如下:
~~~ html
<form action="http://google.com/search" method="get">
	<fieldset role="search">
		<input type="hidden" name="q" value="site:www.jtianling.com" />
		<input class="search" type="text" name="q" results="0" placeholder="搜索本站"/>
	</fieldset>
</form>
~~~

要实现博客中的效果, 还需要在css中去掉默认的边框.  设置border为0:
~~~ css
#social form fieldset {
	border: 0;
}
~~~

## 增加了代码的高亮显示
_config.yml 设置为:
~~~ yaml
highlighter: pygments
pygments: true
markdown:      redcarpet
markdown_ext:  md
~~~

通过利用Foundation的响应功能合适的实现高亮代码的正确显示, 有兴趣的读者可以在iPad, iPhone, Android看看我的博客, 我自己感觉效果还不错.

## 首页改为部分输出
用[liquid](http://docs.shopify.com/themes/liquid-basics)的如下功能实现:
\{\{ post.excerpt \}\}

然后用配置实现原来用的多的more标志来确定部分输出的位置:
_config.xml:
~~~ yaml
excerpt_separator: "<!-- more -->"
~~~

## 修改了博客的title style为直接用title做url.
_config.xml:
~~~ yaml
permalink:     /:title.html
~~~

## 增加了feed
feed.xml:
{% raw %} 
~~~ xml
---
layout: none
---
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
<title type="text">{{ site.title }}</title>
<generator uri="https://github.com/mojombo/jekyll">Jekyll</generator>
<link rel="self" type="application/atom+xml" href="{{ site.url }}/feed.xml" />
<link rel="alternate" type="text/html" href="{{ site.url }}" />
<updated>{{ site.time | date_to_xmlschema }}</updated>
<id>{{ site.url }}/</id>
<author>
  <name>{{ site.owner.name }}</name>
  <uri>{{ site.url }}/</uri>
  <email>{{ site.owner.email }}</email>
</author>
{% for post in site.posts limit:20 %}

<entry>
  <title type="html"><![CDATA[{{ post.title | cdata_escape }}]]></title>
 <link rel="alternate" type="text/html" href="{% if post.link %}{{ post.link }}{% else %}{{ site.url }}{{ post.url }}{% endif %}" />
  <id>{{ site.url }}{{ post.id }}</id>
  {% if post.modified %}<updated>{{ post.modified | to_xmlschema }}T00:00:00-00:00</updated>
  <published>{{ post.date | date_to_xmlschema }}</published>
  {% else %}<published>{{ post.date | date_to_xmlschema }}</published>
  <updated>{{ post.date | date_to_xmlschema }}</updated>{% endif %}
  <author>
    <name>{{ site.owner.name }}</name>
    <uri>{{ site.url }}</uri>
    <email>{{ site.owner.email }}</email>
  </author>
  <content type="html">{{ post.content | xml_escape }}
  &lt;p&gt;&lt;a href=&quot;{{ site.url }}{{ post.url }}&quot;&gt;{{ post.title }}&lt;/a&gt; was originally published by {{ site.owner.name }} at &lt;a href=&quot;{{ site.url }}&quot;&gt;{{ site.title }}&lt;/a&gt; on {{ post.date | date: "%B %d, %Y" }}.&lt;/p&gt;</content>
</entry>
{% endfor %}
</feed>
~~~
{% endraw %} 

## 增加了首页的翻页
除了上下页以外, 增加了直接跳转的页码, 并且为了格式美观, 把页码限定在31页.
{% raw %} 
~~~ xml
<div class="center">
{% if paginator.previous_page %}
<a href="{{ paginator.previous_page_path | prepend: site.baseurl | replace: '//', '/' }}"  class="nav_previous">上一页</a>
{% endif %}
{% for page in (1..paginator.total_pages) %}
    {% if page < 31 %}
			{% if page == paginator.page %}
				<span class="active">{{ page }}</span>
			{% elsif page == 1 %}
				<a href="{{ '/index.html' | prepend: site.baseurl | replace: '//', '/' }}">{{ page }}</a>
			{% else %}
				<a href="{{ site.paginate_path | prepend: site.baseurl | replace: '//', '/' | replace: ':num', page }}">{{ page }}</a>
			{% endif %}
		{% endif %}
{% endfor %}

{% if paginator.next_page %}
    <a href="{{ paginator.next_page_path | prepend: site.baseurl | replace: '//', '/' }}" class="nav_next">下一页</a>
{% endif %}
</div>
~~~
{% endraw %} 


## 文章的结尾列出了标签和分类
{% raw %} 
~~~ xml
<p> 
分类:&nbsp;
{% for cate in page.categories %}
<a href="/categories.html#{{ cate }}" class="category">{{ cate }}&nbsp;</a>
{% endfor %}
<br />
标签:&nbsp;
{% for tag in page.tags %}
<a href="/tags.html#{{ tag }}" class="tag">{{ tag }}&nbsp;</a>
{% endfor %}
</p>
~~~
{% endraw %} 

## 增加了sitemap.xml
sitemap.xml:
{% raw %} 
~~~ xml
---
layout: none
---
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  {% for post in site.posts %}
    <url>
			<loc>{{ site.url }}{{ post.url }}</loc>
      {% if post.lastmod == null %}
        <lastmod>{{ post.date | date_to_xmlschema }}</lastmod>
      {% else %}
        <lastmod>{{ post.lastmod | date_to_xmlschema }}</lastmod>
      {% endif %}
      <changefreq>weekly</changefreq>
      <priority>1.0</priority>
    </url>
  {% endfor %}
  {% for page in site.pages %}
    {% if page.sitemap != null and page.sitemap != empty %}
      <url>
				<loc>{{ site.url }}{{ page.url }}</loc>
        <lastmod>{{ page.sitemap.lastmod | date_to_xmlschema }}</lastmod>
        <changefreq>{{ page.sitemap.changefreq }}</changefreq>
        <priority>{{ page.sitemap.priority }}</priority>
       </url>
    {% endif %}
  {% endfor %}
</urlset>
~~~
{% endraw %} 

## 导入文章
修改完博客的风格后, 自己感觉还是比较满意的, 原来用markdown写的文章稍微改改就能用了, 但是原来还有很多老的文章, 最开始其实是在[CSDN](http://blog.csdn.net/vagrxie)上写的, 并且导入了原来的wordpress博客了, 这里通过Jekyll官方提供的[导入程序](http://import.jekyllrb.com/docs/wordpress/)导入. 

## 评论
原来的博客就接入了[友言](http://uyan.cc), 并且同步了老的评论, 但是因为新的博客所有的地址都变了, 而友言以文章地址为唯一的标识, 所以评论虽然都还在, 但是实际一个都匹配不上了, 感觉丢了2400多条评论也挺可惜的, 所以特别写了个ruby程序导入了原来的评论, 这个单开了一篇文章[**从Wordpress中导入友言的评论**](/import-comment-from-wordpress-in-uyan.html)来说明.  
