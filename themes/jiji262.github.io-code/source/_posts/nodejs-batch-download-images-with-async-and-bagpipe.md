---
title: Nodejs大批量下载图片入坑指南(使用async和bagpipe处理大并发量请求)
layout: post
date: 2016-8-6 20:10
comments: true
tags: [前端, nodejs, 网页爬虫, async, bagpipe]
---

## 前言

故事还得从头说起。[乌云网](http://business.sohu.com/20160722/n460493827.shtml)挂掉之后,[乌云知识库](http://drops.wooyun.org/)也无法访问了。曾经,在上面看到那么多优秀的安全类文章,一下子看不到了,颇觉得有点不适应。还好网上流传着民间的各种版本,于是我收集了一下,放在了[Github](https://github.com/jiji262/wooyun_articles)上。这些文章只是一些html文件,并不包含页面上的图片。幸运的是,图片的域名static.wooyun.com还可以继续访问,因此有必要把这些图片也抓取下来。

#### Wooyun Drops 文章在线浏览
[Wooyun Drops 文章在线浏览](https://jiji262.github.io/wooyun_articles/)
[Github: wooyun_articles](https://github.com/jiji262/wooyun_articles)

## 使用Nodejs下载图片

抓取图片链接的过程在此不再详述,无非就是打开每个html页面,找到其中img标签的src属性。我们拿到了这些html页面的图片链接,是这个样子的:

```javascript
var imageLinks = [
    'http://static.wooyun.org//drops/20160315/2016031513484536696130.png',
    'http://static.wooyun.org//drops/20160315/2016031513484767273224.png',
    'http://static.wooyun.org//drops/20160315/2016031513485057874324.png',
    'http://static.wooyun.org//drops/20160315/2016031513485211060411.png',
    'http://static.wooyun.org//drops/20160315/201603151348542560759.png',
    'http://static.wooyun.org//drops/20160315/201603151348563741969.png',
    'http://static.wooyun.org//drops/20160315/201603151348582588879.png',
    'http://static.wooyun.org//drops/20160315/201603151349001461288.png',
    'http://static.wooyun.org//drops/20160315/201603151349032455899.png',
    ......
    'http://static.wooyun.org//drops/20150714/2015071404144944570.png',
    'http://static.wooyun.org//drops/20150714/2015071404144966345.png',
    'http://static.wooyun.org//drops/20150714/2015071404144915704.png',
    'http://static.wooyun.org//drops/20150714/2015071404144980399.png',
    'http://static.wooyun.org//drops/20150714/2015071404144927633.png'
];
```

我们将其定义为一个模块备用(总共大约有13000个图片链接)。

在Nodejs中下载图片有很多解决方案,比如可以使用npm包[download](https://github.com/kevva/download)。本文中使用比较简单的版本,具体实现如下:
```javascript
var fs = require("fs");
var path = require('path');
var request = require('request');

var downloadImage = function(src, dest, callback) {
    request.head(src, function(err, res, body) {
        // console.log('content-type:', res.headers['content-type']);
        // console.log('content-length:', res.headers['content-length']);
        if (src) {
            request(src).pipe(fs.createWriteStream(dest)).on('close', function() {
                callback(null, dest);
            });
        }
    });
};
```
代码来源: [stackoverflow](http://stackoverflow.com/questions/12740659/downloading-images-with-node-js)。

<!-- more -->

比如想要下载一个图片,可以这样子来做:
```javascript
downloadImage("http://static.wooyun.org/20140918/2014091811544377515.png", "./1.png", function(err, data){
    if (err) {
        console.log(err)
    }
    if (data) {
        console.log("done: " + data);
    }
})
```

对于我们想要的批量下载图片,最直观的做法就是写一个循环,然后去调用downloadImage方法。但是由于图片链接比较多,总是在下载到一部分图片后出现一些错误:
```bash
events.js:160
      throw er; // Unhandled 'error' event
      ^

Error: Invalid URI "undefined"
    at Request.init (/Users//dirread/node_modules/request/request.js:275:31)
    at new Request (/Users/dirread/node_modules/request/request.js:129:8)
    at request (/Users/dirread/node_modules/request/index.js:55:10)
    at Request._callback (/Users//down.js:21:11)
    at self.callback (/Users//dirread/node_modules/request/request.js:187:22)
    at emitOne (events.js:96:13)
    at Request.emit (events.js:188:7)
```

因此只有考虑使用异步方式来处理。

## 解决方案一: 使用async异步批量下载图片

[Async](https://github.com/caolan/async)是一个流程控制工具包，提供了直接而强大的异步功能。其提供了大约20个函数，包括常用的 map, reduce, filter, forEach 等，异步流程控制模式包括，串行(series)，并行(parallel)，瀑布(waterfall)等。

#### 安装async

```bash
npm install async --save
```

其使用方式也比较简单,比如下面的示例:

```javascript
async.map(['file1','file2','file3'], fs.stat, function(err, results){
    // results is now an array of stats for each file
});

async.filter(['file1','file2','file3'], function(filePath, callback) {
  fs.access(filePath, function(err) {
    callback(null, !err)
  });
}, function(err, results){
    // results now equals an array of the existing files
});

async.parallel([
    function(callback){ ... },
    function(callback){ ... }
], function(err, results) {
    // optional callback
};

async.series([
    function(callback){ ... },
    function(callback){ ... }
]);
```

关于async的示例在此不再展开,具体可以参考[alsotang的demo和教程](https://github.com/alsotang/async_demo)。

#### 使用async下载图片
回到我们的程序,我们可以使用来实现。具体代码如下:

```javascript
async.mapSeries(imageLinks, function(item, callback) {
    //console.log(item);
    setTimeout(function() {
        if (item.indexOf("http://static.wooyun.org") === 0) {
            var destImage = path.resolve("./images/", item.split("/")[item.split("/").length -1]);
            downloadImage(item, destImage, function(err, data){
                console.log("["+ index++ +"]: " + data);
            });
            
        }
        callback(null, item);
    }, 100);


}, function(err, results) {});
```

完整代码可以参看[github上](https://github.com/jiji262/wooyun_articles/blob/master/image_download/async_version/down.js)。

#### 运行

```bash
node down.js
```
即可看到结果。

##### 踩坑提醒
在Mac上使用的时候,偶尔会出现这样的错误:
```
Error: EMFILE, too many open files
```
有可能是因为Mac对并发打开的文件数限制的比较小,一般为256.所以需要修改一下。
在命令行执行:
```bash
echo kern.maxfiles=65536 | sudo tee -a /etc/sysctl.conf
echo kern.maxfilesperproc=65536 | sudo tee -a /etc/sysctl.conf
sudo sysctl -w kern.maxfiles=65536
sudo sysctl -w kern.maxfilesperproc=65536
ulimit -n 65536 65536
```
然后可以在你的.bashrc文件中加入一行:
```
ulimit -n 65536 65536
```
解决方案来自[stackoverflow](http://stackoverflow.com/questions/19981065/nodejs-error-emfile-too-many-open-files-on-mac-os).

## 解决方案二: 使用bagpipe批量下载图片

[bagpile](https://github.com/JacksonTian/bagpipe/)是朴灵大大做的一个在nodejs中控制并发执行的模块。

#### 安装bagpipe

其安装和使用也比较简单:
```bash
npm install bagpipe --save
```

使用示例:
```javascript
var bagpipe = new Bagpipe(10);

var files = ['这里有很多很多文件'];
for (var i = 0; i < files.length; i++) {
  // fs.readFile(files[i], 'utf-8', function (err, data) {
  bagpipe.push(fs.readFile, files[i], 'utf-8', function (err, data) {
    // 不会因为文件描述符过多出错
    // 妥妥的
  });
}
```

#### 使用bagpipe批量下载图片

将我们的代码稍做修改,就可以使用bagpipe了。具体代码如下:
```javascript
for (var i = 0; i < imageLinks.length; i++) {
    if (imageLinks[i].indexOf("http://static.wooyun.org") === 0) {
        var destImage = path.resolve("./images/", imageLinks[i].split("/")[imageLinks[i].split("/").length -1]);
        bagpipe.push(downloadImage, imageLinks[i], destImage, function(err, data) {
            console.log("["+ index++ +"]: " + data);
        });
    }
}
```
完整代码可以参考[github上](https://github.com/jiji262/wooyun_articles/blob/master/image_download/bagpipe_version/down.js)。

#### 运行

```
node down.js
```
即可看到结果。

## 结语

async和bagpipe都是很优秀的nodejs包,本身async功能十分强大,bagpipe使用起来简单方便,对原有的异步代码几乎不必做太多改动。因此可以根据自己喜好选择使用。





