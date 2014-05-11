---
layout: post
title: "Redis初次学习"
date: 2013-02-23
comments: true
categories: 编程
tags: Redis, nodejs, NoSQL
---

NoSQL热了很久了, 很惭愧直到今天我才初次学习NoSQL的东西.  从一开始做C++的后端用了MySQL和SQL Server后, 一直在做游戏客户端, 真是远离数据库相关的东西太久了, 有意思的是, 很久前, 对编程相关知识如饥似渴的时候, 工作中碰到任何相关的知识, 哪怕是一个新领域, 起码都要买一本大部头来学习的, 当时只有数据库是真的点到为止, 没有深入学习, 直到今天我也说不上具体为什么......
<!-- more -->

# Redis介绍
就不比较各个用NoSQL统称的大量非关系型数据库了, 相关的内容可以看看[*Cassandra vs MongoDB vs CouchDB vs Redis vs Riak vs HBase vs Couchbase vs Neo4j vs Hypertable vs ElasticSearch vs Accumulo vs VoltDB vs Scalaris comparison*](http://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis)这篇文章, 看看标题有多长, 就知道如今NoSQL的阵营其实有多庞大了.  
[Redis](http://redis.io/)只是其中的一个我感觉最简单的.  
就我的感觉, 用Redis的最大好处就是比SQL数据库要简单...... 也许还有类似处理超大规模数据的效率更高吧, 但是我目前还体会不到, 但是简单却是很重要, 很重要的, 起码你不用预先设计好一堆的表, 和处理好各个表之间的各种关系.  
Redis简单来说是以key-value方式来存储数据的数据库, 类似一个大的hash表.  想想hash表有多么好用, 那么Redis就有多么好用.  

# 安装
## MacOS

~~~ bash
$Brew install redis
~~~

用Brew安装很方便, 然后通过

~~~ bash
$redis-server /usr/local/etc/redis.conf
~~~
 
运行.  
目前我的MacOS安装的是版本2.6.7.  

## Ubuntu
我的Ubuntu 12.04中apt不自带redis, 不过没有关系, [lanchpad](https://launchpad.net/~rwky/+archive/redis)上已经有人做好了包.  

~~~ bash
$sudo add-apt-repository ppa:rwky/redis
$sudo apt-get update
$sudo apt-get install redis-server
~~~

我安装的是最新的2.6.10版本.  

# REPL
我就借用一下REPL的称呼吧, 实际就是Redis的Shell, 因为Redis的概念很简单, 所以Shell的使用会比MySQL要简单无数倍.  安装完Redis后, 可以通过以下命令开启Redis的REPL环境.  

~~~ bash
$redis-cli
~~~

同时, 你还能在<try.redis.io>上先试试.  

# 数据类型
Redis本身是基于Key-value的, 类似Hash表.  Hash表这个应该都知道吧, 而这个Hash表中可以存储的数据类型有如下几种:

* string
* list
* sets
* hashes
* sorted sets

其中字符串是基础类型, 并且在Redis中字符串是可以存储任意二进制序列的, 甚至可以直接存一个图片啥的.(文档中说明不能大于512MB-_-!)list, sets, sorted sets都是string的集合类型.  官方的文档在[这里](http://redis.io/topics/data-types-intro)


# 命令
所有的命令命名都很有规律.  比如, 对*hashes*的操作, 都用'H'开头, 而所有对*list*的操作都以'L'开头, 对*Sets*就是用'S'开头, 等等.  
首先, 我们需要对redis的基本数据类型有所了解, 然后, 查看Redis这个关于[命令](http://redis.io/commands)的文档就能做所有的事情了, 因为, 对应的类型我们想要进行的操作也就那些.  在这里再一个一个的去演示(仅仅能说是演示, 而不能说是教学)简直就是侮辱大家的智商了.  

# Redis With Nodejs
这个部分稍微有些介绍的必要, 因为相关的资料较少, 并且官方的文档还有限和不详细.  
Nodejs本身有一个Redis的npm包, 包的名字就叫redis, 并且开源放在github上: <https://github.com/mranney/node_redis>.  
假如你仅仅是自己做做实验和学习, 那么用npm的标准安装方式安装redis就可以了:  

~~~ bash
$npm install redis
~~~

假如是真实的环境, 那么推荐安装hiredis, 这是一个C语言写的redis库, 速度更快.  其实安装也挺简单的:  

~~~ bash
$npm install hiredis redis
~~~

使用上, 官方给的一个类似HelloWorld例子:  

~~~ js
var redis = require("redis"),
client = redis.createClient();

// if you'd like to select database 3, instead of 0 (default), call
// client.select(3, function() { /* ... */ });

client.on("error", function (err) {
	console.log("Error " + err);
});

client.set("string key", "string val", redis.print);
client.hset("hash key", "hashtest 1", "some value", redis.print);
client.hset(["hash key", "hashtest 2", "some other value"], redis.print);
client.hkeys("hash key", function (err, replies) {
	console.log(replies.length + " replies:");
	replies.forEach(function (reply, i) {
		console.log("    " + i + ": " + reply);
		});
	client.quit();
});
~~~

不过, 仅仅这个例子想要的信息都有了. 用createClient获得redis的client, 然后, 每个操作都对应一个相应的js函数, 命名都一样.  假如不熟悉nodejs(或者js)的话, 需要接受的就是, 所有的操作都是异步的, 需要设置回调函数来获得结果.  如上面hset, hkeys调用所示.  然后, 用client.quit退出.  

另外, 这里还有更多的[例子](https://github.com/mranney/node_redis/tree/master/examples).  

## 实际的例子
以前对汽车之家没有车型收藏功能很恼火, 所以自己写了个[Chrome的插件](https://chrome.google.com/webstore/detail/autohome-boost/deohljpidkeahefhmndoogigfehddimb)来搞定这个事情, 当时的服务器就是用nodejs with redis写的, 这里贴一下主要代码, 作为一个实际的例子:  

~~~ js

var redis = require('redis');

client = redis.createClient();
client.select(1, function() {});
client.on('error', function(err) {
	console.log('Error: ' + err);
});

function isArgumentEnough(request, query, queryNeeds) {

	for (var i = 0; i < queryNeeds.length; ++i) {
		if ( query[ queryNeeds[i] ] == undefined ) {
			console.log('argumentMissing: ' + queryNeeds[i]);
			request.writeHead(200, {"Content-Type" : "application/json"});
			request.write(' { "argumentMissing" : "' + queryNeeds[i] + '"}');
			request.end();
			return false;
		}
	}

	return true;
}

function addFav(request, query) {
	console.log("addFav : " + JSON.stringify(query));

	if ( !isArgumentEnough(request, query, ['name', 'type', 'code']) ) {
		return;
	}

	client.sadd(query.name + ':' + query.type, query.code, function(err, reply) {
		console.log("sadd reply: " + reply);

		var fav_key = query.name + ':' + query.type + ':' + query.code;
		console.log("fav_key: " + fav_key);
		client.exists(fav_key, function(err, reply) {
			console.log("client exists reply: " + reply);
			if (reply === 0) {
				client.hmset(fav_key, query, redis.print);
			}
		});

		request.writeHead(200, {"Content-Type" : "application/json"});
		request.end();
	});
}

function delFav(request, query) {
	console.log('delFav :' + JSON.stringify(query));

	if ( !isArgumentEnough(request, query, ['name', 'type', 'code']) ) {
		return;
	}

	client.srem(query.name + ':' + query.type, query.code, function(err, reply) {
		console.log("srem result: " + reply);

		request.writeHead(200, {"Content-Type" : "application/json"});
		request.end();
	});

}

function isFav(request, query) {
	console.log("isFav :" + JSON.stringify(query));

	if ( !isArgumentEnough(request, query, ['name', 'type', 'code']) ) {
		return;
	}

	client.sismember(query.name + ':' + query.type, query.code, function(err, reply) {
		console.log("sismember result: " + reply);

		request.writeHead(200, {"Content-Type" : "application/json"});

		if (reply === 1) {
			request.write(JSON.stringify({ "result" : true }));
		}
		else {
			request.write(JSON.stringify({ "result" : false }));
		}

	request.end();
	});
}

function getFavs(request, query) {
	console.log("getFav :" + JSON.stringify(query));

	if ( !isArgumentEnough(request, query, ['name', 'type']) ) {
		return;
	}

	client.smembers(query.name + ':' + query.type, function(err, replies) {
		console.log(replies.length + " replies:");
		var favs = [];

		if (replies.length === 0) {
			request.writeHead(200, {"Content-Type" : "application/json"});
			request.end();
		}

		replies.forEach(function (reply, i) {
			console.log(i + " reply: " + reply);

			var fav_key = query.name + ':' + query.type + ':' + reply;
			client.hgetall(fav_key, function(err, obj) {
				favs.push(obj);
				console.log(obj);

				if (i === replies.length - 1) {
					if (query.type === 'series') {
						favs.sort( function(a,b) { return a.desc > a.desc ? 1 : -1; );
					}

					request.writeHead(200, {"Content-Type" : "application/json"});
					request.write(JSON.stringify(favs));
					console.log(JSON.stringify(favs));
					request.end();
				}
			});
		});
	});
}

exports.addFav = addFav;
exports.delFav = delFav;
exports.isFav = isFav;
exports.getFavs = getFavs;
~~~

# 小结
这篇文章有些水了...... 因为很久前(2013-02-23日)刚学习Redis时起笔写的, 原计划是像本博客中很多文章一样, 一边学习一边写, 但是因为Redis太简单了, 随便看了看, 感觉就差不多可以用一用了, 就直接写了上面提到的插件的服务器, 等工作都完成了以后, 再回头来写这个文章的动力就小了, 所以一直拖到现在, 今天整理博客, 看了看, 简单的补充了一下, 还是把这个文章发了吧, 好歹有那么多有用的链接.  

<div style="text-align:right">
  writen&nbsp;by <a href="http://www.jtianling.com" target="_blank">九天雁翎(JTianLing) -- www.jtianling.com</a>
</div>
