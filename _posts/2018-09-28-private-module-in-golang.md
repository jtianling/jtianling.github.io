---
layout: post
title: 写一个自己的Golang Module(Golang1.11以后版本支持)
date: 2018-09-28
comments: true
categories: 编程
published: true
tags:
- Golang
- Module
---

在新的Golang 1.11版本中, 官方实验性添加了一种标准的 Module 写法, 用于替代原来非常不方便的 vendor, GOPATH 那一套东西, 经过了这么长时间, 那批老顽固总算是搞清楚了一些什么. Golang 原来的包管理, 可以说是新一代的语言里面最垃圾的.  

<!-- more -->

# 一个 Module 的诞生, go module 的 hello world

首先, 在 GOPATH 目录以外, 建一个 Module 想放的目录, 是的, 不要放在原来的 GOPATH 里面.  
通过 `go mod init MODULE_NAME` 来初始化一个想要建立的 Module, 比如下面这样:
```bash
$ go mod init github.com/jtianling/goModule

go: creating new go.mod: module github.com/jtianling/goModule
```

此时会在当前目录下面新建一个叫 go.mod 的文件, 你可以理解成类似 package.json 的文件(事实上格式也挺像的)

```bash
$cat go.mod

module github.com/jtianling/goModule
```

然后开始创建自己 Module 的内容吧
```go
package goModule

import (
    "fmt"
)

func Print() {
    fmt.Println("hello, world")
}
```

提交项目文件到 github 以后, 我们找个工程来应用这个新写的 Module.

新建一个 goModuleTest 目录, 用 `go mod init goModuleTest` 再初始化这个测试工程.  
创建一个调用前面 module 的 main.go 文件:

```go
package main

import (
  "github.com/jtianling/goModule"
)

func main() {
  goModule.Print()
}
```

用 `go build` 尝试编译运行
```bash
$ go build

go: finding github.com/jtianling/goModule latest
go: downloading github.com/jtianling/goModule v0.0.0-20180928104915-d4c10f8ba563

$./goModuleTest

hello, world
```

运行没有毛病, 而且自动化的下载了我们引用了的库.  

# 版本控制
go module 使用了[语义化的版本号](https://semver.org/), 简单的说就是v(major).(minor).(patch), 实践中, 只要 API 不兼容的时候, 就应该提 major 版本, 增加 API 或者优化, 可以自增加 minor 版本号.  
在 goModule 目录下,  
```bash
$ git tag v0.0.1
$ git push --tags

Total 0 (delta 0), reused 0 (delta 0)
To github.com:jtianling/goModule.git
 * [new tag]         v0.0.1 -> v0.0.1
```

然后删掉 goMoudleTest 工程, 再来一次, 结果会有些不一样:

```bash
$ go build

go build
go: finding github.com/jtianling/goModule v0.0.1
go: downloading github.com/jtianling/goModule v0.0.1

$ cat go.mod

module goModuleTest

require github.com/jtianling/goModule v0.0.1
```

没错, 增加了版本号, 我们试试升级自己的 module, 并 `git tag v0.0.2` 试试, 
然后在 goModuleTest 工程中, 可以通过传统的 `go get` 加指定的版本号升级:   
```
$ go get github.com/jtianling/goModule@v0.0.2

go: finding github.com/jtianling/goModule v0.0.2
go: downloading github.com/jtianling/goModule v0.0.2

$ cat go.mod
module goModuleTest

require github.com/jtianling/goModule v0.0.2
```

可以看到 go.mod 里面的内容也自动变了. 此时再 build 然后运行, 会发现 module 正常更新了.  
假如不想指定版本, 仅仅想更新到最新版本, 可以通过  
`go get github.com/jtianling/goModule@latest` 的形式更新到最新版  
`go get -u` 的形式升级所有的依赖库  

# 多 package 的 module
一个 package 的 module 好说, 假如你的 module 包含多个 package, 那么所有的 package 指定的时候, 直接用 package 明就好, 但是 import 的时候应该有共同的前缀.
如下:  

```go
// content.go in goModule/content
package content

import (
    "fmt"
)

func Print() {
    fmt.Println("hello, world v0.0.3")
}

// module.go
package goModule

import (
    "github.com/jtianling/goModule/content"
)

func Print() {
    content.Print()
}
```

# module 测试
module 文件同样支持 golang 自带的 unit test 方法, 可以方便的在发布前进行单元测试:

```go
// goModule_test.go
package goModule_test

import (
  "testing"
  "github.com/jtianling/goModule"
)

func TestPrint(t *testing.T) {
  goModule.Print()
}
```

测试方法也一样
```bash
$ go test

hello, world v0.0.3
PASS
ok  	github.com/jtianling/goModule	0.005s
```

# 私有的 module
对于公开的 module, 按上面的做法已经够用了, 私有的 module 需要对 module 的引用做一些处理, 因为 `go get` 实际是利用了git, 所以我们通过 `git config` 改改 url 就能做到.  下面以 github 为例.  

```bash
$ git config --global url."git@github.com:".insteadOf "https://github.com/"
```

对于自己的是有仓库, 可能还需要用 http:

```bash
$ git config --global url."git@github.com:".insteadOf "http://github.com/"
```

# 参考

1.[golang wiki](https://github.com/golang/go/wiki/Modules)

