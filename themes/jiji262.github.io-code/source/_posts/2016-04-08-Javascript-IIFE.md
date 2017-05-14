title: "Javascript知识点：IIFE - 立即调用函数"
layout: post
date: 2016-04-25 20:10
comments: true
tags: [前端, IIFE, 前端基础]

---

Immediately-invoked Function Expression（IIFE，立即调用函数），简单的理解就是定义完成函数之后立即执行。因此有时候也会被称为“自执行的匿名函数”（self-executing anonymous function）。

IIFE的叫法最早见于Ben Alman的文章。文章中Ben Alman 已经解释得很清楚了，希望定义自执行函数式常见的语法错误有两种：

1) `function (){ }()`

期望是立即调用一个匿名函数表达式，结果是进行了函数声明，函数声明必须要有标识符做为函数名称。

2) `function g(){ }()`

期望是立即调用一个具名函数表达式，结果是声明了函数 g。末尾的括号作为分组运算符，必须要提供表达式做为参数。
所以那些匿名函数附近使用括号或一些一元运算符的惯用法，就是来引导解析器，指明运算符附近是一个表达式。

按照这个理解，可以举出五类，超过十几种的让匿名函数表达式立即调用的写法：

**1）使用括号**

    ( function() {}() );
    ( function() {} )();
    [ function() {}() ];

**2）使用一元操作符**

    ~ function() {}();
    ! function() {}();
    + function() {}();
    - function() {}();

**3）使用void等操作符**

    delete function() {}();
    typeof function() {}();
    void function() {}();

**4）使用表达式**

    var i = function(){ return 10; }();
    true && function(){ /* code */ }();
    0, function(){ /* code */ }();
    1 ^ function() {}();
    1 > function() {}();

**5）使用new关键字**

    new function(){ /* code */ }
    
    new function(){ /* code */ }() //如果没有参数，最后的()就不需要了

<!-- more -->

但是总体来说，比较常见的是如下三种写法：


    // Crockford's preference - parens on the inside
    (function() {
      console.log('Welcome to the Internet. Please follow me.');
    }()); 

    (function() {
      console.log('Welcome to the Internet. Please follow me.'); 
    
    })(); 

    !function() {
    
      console.log('Welcome to the Internet. Please follow me.'); 
    
    }(); 

其实讨论IIFE的多少种写法多少和研究茴香豆的“茴”字有几种写法一样无聊，但其实不无用处，至少在阅读别人的代码时见到这样的写法不至于不知所云，抑或可以拿出去和小伙伴们装装，顿时觉得逼格提升不少。

*参考资料：*

http://benalman.com/news/2010/11/immediately-invoked-function-expression/
（[中文译文](http://www.cnblogs.com/TomXu/archive/2011/12/31/2289423.html)）

http://www.elijahmanor.com/angry-birds-of-javascript-red-bird-iife/
（[中文译文](http://nuysoft.com/2013/04/15/angry-birds-of-javascript-red-bird-iife/Immediately-invoked%20Function%20Expression)）

http://www.zhihu.com/question/20249179
