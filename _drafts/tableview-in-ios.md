---
layout: post
title: iOS中的TableView使用详解
date: 2015-09-28
comments: true
categories: 编程
published: false
tags: 
- Swift
- TableView
- UITableView
- iOS
---

TableView可能是一般iOS开发中使用到的最多, 功能最丰富的控件, 使用频率甚至不会低于Button, Label这种简单的控件, 一方面使用的多, 一方面功能又很强大, 使用起来比Button, Label要复杂很多, Autolayout的加入使得问题更加复杂化, 学习好TableView, 基本决定了iOS的开发效率.  
我这里敢使用详解, 就是希望把TableView各方面的东西都详细的讲清楚了, 而不是个什么简单的入门turtorial. 另外, 全文基于Swift, 不会有Objective-C的东西, 见谅, 虽然我知道大部分人都还在用OC, 但是看看我博客的副标题, 就知道, 当Swift能用的时候, 我是不会再用OC了~~

PS: 已经很少发这种具体技术相关的文章了, 因为感觉营养太少, 不过最近的工作又从游戏方面转到iOS app开发, 自己也在学习和摸索中, 也许将来有机会还会分享一些.

<!-- more -->

# 简单的使用

不知道要不要先介绍一下TableView, 基本上可以理解成一个列表, 你能看到的大部分在iOS上, 以集合形式出现的控件, 不管最后的形式怎么不同, 其实本质上都是TableView, 简单到普通的设置列表, 复杂到聊天对话框.

TableView在iOS中的功能使用, 主要掌握UITableViewDelegate, UITableViewDataSource两个Protocol即可, 如类名所展示的那样, UITableViewDelegate主要是负责显示出来的样子和cell的行为, UITableViewDataSource是提供数据信息的, 两个类都是一个Protocol, 提供了一系列的回调函数, 我们通过实现回调函数, 用不同的返回值来表达数据, 就如同很多以前Cocoa的接口一样. 相对这两个Protocol, UITableView和UITableViewController反而在实际中使用的不那么频繁.

就不在简单的使用上面浪费太多篇幅了, 类似的例子在网上一搜一大堆, 我这个就给个简单的列表的例子, 作为后面的基础.
比如, 我们做个软件, 需要用户输入自己的职业, 那么实现以后大概会像下面这样子:

~~~swift
import UIKit

class ViewController: UIViewController {

  let items = ["程序员", "程序员鼓励师", "产品经理", "产品助理", "项目经理", "主策划",
    "执行策划", "设计师", "美术", "测试", "销售", "人事", "行政", "前台", "扫地僧"]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let tableView = UITableView(frame: self.view.bounds)
    tableView.delegate = self
    tableView.dataSource = self

    self.view.addSubview(tableView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
  private static var tableIdentifier = "simpleTableIdentifier"

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = items[indexPath.row]

    let tableViewCell = UITableViewCell(style: UITableViewCellStyle.Default,
      reuseIdentifier: ViewController.tableIdentifier)
    tableViewCell.textLabel!.text = item
    return tableViewCell
  }
}
~~~

这也差不多算是最简单的通过程序(programmatically)直接创建一个TableView的方式了. ViewController就是哪个XCode默认生成的单View工程中默认生成的ViewController, 特别说明一下的是, 为了让items可以超过屏幕范围, 我特别添加了足够多的items, 实际运行时, 可自动实现拖动滚屏, 并且屏幕自动适应屏幕大小, 不管在iPhone4, iPhone5, iPhone6, iPhone6+上都现实正常, 多年前iPhone统一设备分辨率的时代早过去了.....这还不包括iPad....
