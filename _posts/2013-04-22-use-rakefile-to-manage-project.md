---
layout: post
title: "用Rakefile管理工程"
date: 2013-04-22
comments: true
categories: 编程
tags: Rakefile, makefile, project-manage 
---
  
游戏项目可能是所有软件项目中需要在编译时处理资源最多的项目, 一般的项目都有下面几种常见需求:  

1. 将文本格式的Json, XML等配置换成二进制
2. 将Json, XML等配置加密
3. 将tga, png的图压缩成压 缩比更高的pvr, webp等格式
4. 用texturepacker等工具打包小图
5. 将UI编辑器, 动画编辑器的编辑时格式(往往是文本格式)编译成二进制的发布格式.
  
特别是图片相关的的资源生成, 时间消耗较多, 需要尽量减少重复生成.  此时像makefile这种东西就很有价值了.  
<!-- more -->

# makefile的利弊
makefile最大的好处自然是依赖关系的作用, 在正确设置后, 能做到当原始文件(源文件, 原始的资源等)没有更改时, 不生成目标文件, 更改时才生成, 并且可以自定义生成的规则.  
缺点也很明显, makefile太难写了, 传统的makefile格式独特, 甚至tab敏感, 而功能相对单一(功能强大基本靠shell).  所以很多人都弄了一套别的东西, 比如传统的Unix/Linux开发环境的Automake和Autoconf, 可以跨平台生成工程的CMake, Qt的qmake, Java的ant等, 而Ruby则提供了[Rake](https://github.com/jimweirich/rake).  

# Rakefile使用
简单的说Rakefile就是使用Ruby语法的makefile, 对应make的工具就是rake.  在Ruby on Rails里面, 不管是数据库的初始化, 内容初始化, 删除, 还是测试, 都是用rake来完成的.  

## 优点
官方说明有如下优点:  

1. Ruby语法
2. 可以设定task的依赖
3. 支持patterns的规则
4. 灵活的FileList类, 行为像array, 但是可以方便的操作文件名和路径
5. 有一个预先包装好的库, 可以方便的实现类似build tarball和发布到ssh网站等功能.
6. 支持并行task.

其实想像一下, 在makefile文件中能使用完整的ruby功能, 不仅仅是ruby的语法, 还支持ruby现有的所有库, gems, 光听听就让人高兴.  
碰到复杂工程时, 不管逻辑需要多复杂, 你都有一个完整, 强大的语言可以使用, 不再需要借助其他的东西就能够完全hold住.  
假如有缺点的话, 那就是ruby逼近还是需要学习的....并且, 总体的内容比一般的makefile要复杂一些.  

## 使用说明
Rakefile分几个基本的build规则, 用"=>"来表示依赖关系.  

比如常见的helloworld工程, 我们可以输入完整的命令:  

~~~ bash
g++ helloworld.cc -o hello.o
~~~

也可以在源代码目录中新建Rakefile文件来管理, Rakefile文件如下:  

~~~ ruby
file "helloworld" => "helloworld.cc" do |t|
	sh "g++ #{t.prerequisites.join(' ')} -o #{t.name}"
end
~~~

然后运行rake helloworld, 来编译, 好处就是当helloworld.cc文件没有改变时, 实际根本不会编译.  
上面的例子中我们是用了一个file task, 当我们要想要直接运行rake, 省略helloworld的话, 可以利用rake的default task.  

~~~ ruby
task :default => "helloworld"

file "helloworld" => "helloworld.cc" do |t|
	sh "g++ #{t.prerequisites.join(' ')} -o #{t.name}"
end
~~~
    
这个default的task就是一个simple task, 会在直接运行rake的时候运行, 并且, 可以看到, task之间也是可以用"=>"表示依赖的.  
  
当文件比较多时, 一个一个的写file task可能会比较类, 于是rake加入了rule特性, 比如, 我们可以用下列的rule来编译所有的".cc"文件.  
比如, 我自建一个my_print函数, 现在就有my_print.cc, helloworld.cc两个源文件了, 可以通过下面这种方式来生成代码:  

~~~ ruby
task :default => "helloworld"

file "helloworld" => ["helloworld.o", "my_print.o"]  do |t|
	sh "g++ #{t.prerequisites.join(' ')} -o #{t.name}"
end

rule ".o" => [".cc", ".h"] do |t|
	sh "g++ -c #{t.source} -o #{t.name}"
end
~~~

当然, 虽然rake很强大, 但是还是没有强大到能够分析理解C++代码的地步, 所以, 这种规则和以前的makefile文件一样, 设定后, 仅仅是同名文件的头文件, 源文件能够产生依赖关系(更改后能够触发重编译), 但是此例中, helloworld.cc也include了my_print.h, 也是对my_print.h的实际依赖, 但是rake就理解不了了.  
而事实上, 我们几乎不可能都手动的将所有的这种include关系输入到rakefile中, 那简直就是自虐.  我们通常的做法是, 碰到有改头文件的时候, 直接clean项目, 然后再重新编译.  

~~~ ruby
task :clean do
	sh "rm *.o"
end
~~~
    
同样的, 我们也能实现makefile中常有的install任务, 这里就不再累述了.  

## 实例
这里用一个游戏项目的实例来说明:  
首先, 我们一般通过`base_dir = File.dirname(__FILE__)`的方式来获得当前目录, 以方便解决目录相关的问题, 手动的从相对目录转为绝对目录.  

然后, 为了从png格式压缩为webp格式, 建立以下规则:  

~~~ ruby
quality = 90 
rule '.webp' => '.png' do |t|
	puts "webp convert begin:" + t.source.to_s

	if !File.exist?(converted_dir)
		sh "mkdir #{converted_dir}"
	end

	sh "/usr/bin/env cwebp -q #{quality} -quiet #{t.source} -o #{t.name}"
	sh "cp #{t.name} " + converted_dir + "/"

	puts "webp convert end:" + t.source.to_s
end
~~~

其中converted_dir就是我们实际资源需要移动到的目录.  这里之所以用cp, 而不是用mv来移动, 是为了在源目录保留有转换后的副本, 当图片没有更改的时候, 就不需要重新压缩图片.  这里, 有个疑问, 最佳的方式是直接将converted_dir的资源和源文件形成依赖, 就可以省掉一次拷贝的过程, 但是, 不知道怎样使用跨目录的rule.  
  
再比如说, 使用TexturePacker对小图片进行打包, 这个依赖关系本来是一个大图片对需要打包的所有小图片, 特别适合rakefile/makefile, 不过TexturePacker自己就实现了这种机制, 我们也就没有必要重复实现了, 即使其实比较容易.  

~~~ ruby
desc "pack texture with texture packer."
task :pack_texture do
	puts "pack texture begin."
	tps_files = FileList["#{tps_dir}" + "/*.tps"]
	puts "tps files:" + tps_files.to_s
	tps_files.each { |file|
		sh "/usr/local/bin/TexturePacker --quiet #{file}"
	}
end
~~~

这里的desc是Rakefile专用的注释, 可以在运行`rake -T`时, 看到较为友好的命令说明:  

~~~ bash
$rake -T
rake clean         # clean the all generated resource
rake clean_packed  # clean the packed resource.
rake default       # generate all the resouce neeed.
rake pack_texture  # pack texture with texture packer.
rake png2webp      # convert all the png to webp format.
~~~

这里又有另外一个较为不好的地方, 我们首先用TexturePacker把小图都打包成大图了(见前面pack_texture task的例子), 我们可以完全用FileList动态生成需要打包的tps文件, 而只有打包后才能有我们想要转换为webp的png图文件, 但是, 当我想要动态的用FileList获取到生成的所有的png作为file task的任务时, 发现rakefile并不支持.  简单的说, 当file task依赖的文件是另一个task的结果时, 我们无法处理这种依赖关系, 如下例:  

~~~ ruby
generated_texs = nil
task :pack_texture do
	// generate the textures
	// the code
	
	generated_texs = FileList[...]
end

task :png2webp => [:pack_texture] + generated_texs do
	
end
~~~

这个例子中, 虽然我们可以肯定的说png2webp task运行时genereated_texs会获得正确的值, 无论我们是通过default task运行, 还是直接运行png2webp这个task(因为png2webp本身依赖pack_texutre task), 但是实际上, 无论你用那种方式运行png2webp, genereated_texs总是为nil, 就算你实际上在pack_texture task中改变了generated_texs的值.  这个挺让人郁闷的.  

# 总结
总的来说, Rakefile算是那种一劳永逸的工程管理解决方案, 因为ruby语言本身的强大和相关库的丰富, 基本上不会再需要用其他方式来管理你的工程了.  也许, 还要更好的话, 那就是自动的理解代码, 了解诸如include, import等依赖关系的工具了.  

# 参考
[Rakefile Readme](http://rake.rubyforge.org/README_rdoc.html)
[Rakefile Format](http://rake.rubyforge.org/doc/rakefile_rdoc.html)

