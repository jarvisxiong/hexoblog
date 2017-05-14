title: "使用Chrome DevTools单步调试node程序"
layout: post
date: 2017-02-19 20:10
comments: true
tags: [工具, 前端开发, node, 调试]

---

node程序的调试向来是比较令人头疼的问题，不过Chrome DevTools在去年已经可以支持node程序的调试，虽然不像使用Eclipse调试Java程序那么方便功能那么强大，但是也算是提供了一个便捷的途径来帮助我们快速的定位node程序的问题。

这个功能是在Google I/O 2016上正式发布的，可以通过[这里的视频](https://youtu.be/x8u0n4dT-WI?t=2571)(youtube，需翻墙)了解更多信息。

![](https://cdn-images-1.medium.com/max/1600/1*iHurZ1VUsM54zGjZJHqexQ.png)

使用步骤记录如下：

# 安装最新的Node

要支持这项功能，需要node.js的版本在6.3.0以上。如果版本较低，将会提示不支持该功能。在Mac上你可以使用nvm来切换node的版本，具体请自行google之。

```
➜  wx node --inspect --debug-brk index.js
node: bad option: --inspect
➜  wx node -v
v6.2.0
➜  wx nvm list
->       v6.2.0
         v7.3.0
default -> 6.2 (-> v6.2.0)
node -> stable (-> v7.3.0) (default)
stable -> 7.3 (-> v7.3.0) (default)
iojs -> N/A (default)
➜  wx nvm use 7.3.0
Now using node v7.3.0 (npm v3.10.10)
```

# 运行node程序

运行node程序时需要带上`--inspect`标记。比如可以这样运行：
```
 node --inspect index.js
```
如果需要在node程序的第一行就自动加断点，可以这样来执行：
```
 node --inspect --debug-brk index.js
```

# 打开调试连接

执行之后就会看到一个`chrome-devtools://...`开头的链接，然后复制到Chrome浏览器中，就可以进行node程序的调试了。

```
➜  wx node --inspect --debug-brk index.js
Debugger listening on port 9229.
Warning: This is an experimental feature and could change at any time.
To start debugging, open the following URL in Chrome:
    chrome-devtools://devtools/bundled/inspector.html?experiments=true&v8only=true&ws=127.0.0.1:9229/d9c8660e-ce96-44bb-9742-515bf49ee26b
```