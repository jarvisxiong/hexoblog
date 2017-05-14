title: "Asynchronous Javascript Introduction"
layout: post
date: 2016-08-08 20:10
comments: true
tags: [前端, Asynchronous, 前端基础]

---

## 

异步
所谓"异步"，简单说就是一个任务分成两段，先执行第一段，然后转而执行其他任务，等做好了准备，再回过头执行第二段。

比如，有一个任务是读取文件进行处理，任务的第一段是向操作系统发出请求，要求读取文件。然后，程序执行其他任务，等到操作系统返回文件，再接着执行任务的第二段（处理文件）。这种不连续的执行，就叫做异步。

相应地，连续的执行就叫做同步。由于是连续执行，不能插入其他任务，所以操作系统从硬盘读取文件的这段时间，程序只能干等着。

## Callbacks

### 回调地狱
http://www.alloyteam.com/2015/04/solve-callback-hell-with-generator/
http://callbackhell.com/

https://github.com/mattdesl/promise-cookbook/blob/master/README.zh.md
-> Example: load images
callback hell -> solution: async -> promise

### async module
https://www.npmjs.com/package/async

## 事件监听
http://www.barretlee.com/blog/2014/01/05/cb-javascript-asynchronous-programming/
http://www.jianshu.com/p/a0a7a451c536

http://jimliu.net/2012/05/28/javascript%E4%B8%AD%E7%9A%84%E5%BC%82%E6%AD%A5%E6%A2%B3%E7%90%86%EF%BC%881%EF%BC%89-%E4%BD%BF%E7%94%A8%E6%B6%88%E6%81%AF%E9%A9%B1%E5%8A%A8/

## 发布/订阅

http://www.ruanyifeng.com/blog/2012/12/asynchronous%EF%BC%BFjavascript.html

## Promises

https://github.com/mattdesl/promise-cookbook/blob/master/README.zh.md
ES2015, bluebird



https://blog.coding.net/blog/how-do-promises-work
Promises/A 规范
Promises/B 规范
Promises/D 规范
Promises/A+ 规范

https://github.com/kriskowal/q
https://github.com/cujojs/when
https://github.com/petkaantonov/bluebird
http://complexitymaze.com/2014/03/03/javascript-promises-a-comparison-of-libraries/

## Generators / yield

ES2015

http://jimliu.net/2015/01/18/more-about-es6-generator-function/
http://www.ruanyifeng.com/blog/2015/04/generator.html


### co
https://www.npmjs.com/package/co
http://www.ruanyifeng.com/blog/2015/05/co.html

## Async / await

ES7

https://cnodejs.org/topic/5640b80d3a6aa72c5e0030b6
https://ponyfoo.com/articles/understanding-javascript-async-await
http://www.ruanyifeng.com/blog/2015/05/async.html
https://www.twilio.com/blog/2015/10/asyncawait-the-hero-javascript-deserved.html

http://aisk.me/using-async-await-to-avoid-callback-hell/
->sleep function

## Reference

https://blog.risingstack.com/asynchronous-javascript/
http://huli.logdown.com/posts/292655-javascript-promise-generator-async-es6
http://es6.ruanyifeng.com/#docs/async
http://www.barretlee.com/blog/2014/01/05/cb-javascript-asynchronous-programming/
http://eng.localytics.com/better-asynchronous-javascript/
http://liubin.org/promises-book/
https://bitsofco.de/javascript-promises-101/
http://www.ruanyifeng.com/blog/2015/04/generator.html
https://medium.com/@rdsubhas/es6-from-callbacks-to-promises-to-generators-87f1c0cd8f2e#.qruudlybf



