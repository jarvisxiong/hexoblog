---
title: 手把手教你为React Boilerplate添加测试代码覆盖率报告
layout: post
date: 2016-7-26 20:10
comments: true
tags: [前端, webpack, react, karma, coverage]
---

## 前言

在[上一篇文章](http://jiji262.github.io/2016/04/29/create-your-own-react-boilerplate/)中，葱哥从零开始创建了一个react的boilerplate，并使用webpack进行build，使其支持ES6，同时使用karma＋mocha等进行单元测试。虽然单元测试有了，但是代码中哪些写了测试，哪些没写呢？本文就将在[上一篇文章](http://jiji262.github.io/2016/04/29/create-your-own-react-boilerplate/)的基础上为其增加生成代码覆盖率的功能。

### 代码

本文的最终代码可以在[react_boilerplate_v8](https://github.com/jiji262/react_boilerplate/tree/master/_tutorial_/react_boilerplate_v8)中查看。

## 准备工作

### react boilerplate代码

首先拿到[上一篇文章](http://jiji262.github.io/2016/04/29/create-your-own-react-boilerplate/)的代码：

```
# git clone https://github.com/jiji262/react_boilerplate.git

# cd _tutorial_/react_boilerplate_v6

```

在正式开始之前，我们将对之前的代码做一些简单的修改，`app`目录用于存放源代码，`test`目录用于存放测试文件，文件结构如下：

```
|____app
| |____components
| | |____FooBar.js
| | |____HelloWorld.js
| |____index.js
|____test
| |____components
| | |____HelloWorld-spec.js
| |____index.spec.js

```

其中`components`目录用于存放React组件，其中有两个小的示例。具体代码可以参考[Github](https://github.com/jiji262/react_boilerplate/tree/master/_tutorial_/react_boilerplate_v7).

### build和test

现在在我们的项目目录下可以通过如下命令来运行和测试代码了。

```bash
# npm run dev # 开发环境，运行后使用http://localhost:3000/看到效果

# npm build  # 生产环境编译

# npm run test # 使用karma+mocha进行测试
```
<!-- more -->

## 测试代码覆盖率

### 安装插件

除了我们已经安装好的`karma-webpack`、`karma-sourcemap-loader`等插件外，我们要实现测试代码的覆盖率检测，还需要安装如下插件：
```
npm install karma-coverage --save-dev
```

要支持React的测试代码覆盖率，还需要：
```
npm install babel-istanbul-loader --save-dev
```

### 修改karma配置文件

在`karma.config.js`文件中，添加对coverage插件的支持，修改后代码如下：
```javascript
var path = require('path');
var webpackConfig = require('./webpack.config');
webpackConfig.devtool = 'inline-source-map';
webpackConfig.module.preLoaders = [
    //transpile and instrument only testing sources with babel-istanbul
    {
      test: /\.js$/,
      include: path.resolve('app/'),
      loader: 'babel-istanbul',
      query: {
        cacheDirectory: true
          // see below for possible options
      }
    }
  ];

module.exports = function(config) {
  config.set({
    browsers: ['Chrome'],
    singleRun: true,
    frameworks: ['mocha', 'chai', 'sinon', 'sinon-chai'],
    files: [
      'test.webpack.js'
    ],
    plugins: [
      ......
      'karma-coverage'
    ],
    preprocessors: {
      //'app/**/*.js': ['coverage'],
      'test.webpack.js': ['webpack', 'sourcemap']
    },
    reporters: ['mocha', 'coverage'],

    // optionally, configure the reporter
    coverageReporter: {
      type: 'html',
      dir: 'coverage/'
    },
    webpack: webpackConfig,
......
  });
};
```

此处复用了webpack的配置文件`webpack.config.js`。当然也可以直接将webpack的配置文件写在`karma.config.js`中。

### 修改test.webpack.js文件

在`test.webpack.js`文件中引入所要测试的源代码和测试用例文件，如下：
```javascript
var context = require.context('./test', true, /spec\.js$/);
context.keys().forEach(context);

var context = require.context('./app', true, /\.jsx?$/);
context.keys().forEach(context);


```

注意，这里如果没有添加`./app`，则没有写测试用例的文件（本例中的`FooBar.js`）就不会出现在coverage的report中。

### 运行测试

运行命令`npm run test` 运行karma测试，命令行中显示结果：
```bash
> react_boilerplate@1.0.0 test /Users/i301792/Work/react_boilerplate
> karma start


START:
26 07 2016 14:28:20.866:INFO [karma]: Karma v0.13.22 server started at http://localhost:9876/
26 07 2016 14:28:20.872:INFO [launcher]: Starting browser Chrome
26 07 2016 14:28:21.896:INFO [Chrome 51.0.2704 (Mac OS X 10.11.6)]: Connected on socket /#prlpeNiUX9kDUlWtAAAA with id 1527217
  root
    ✔ renders without problems
  app
    ✔ loads without problems

Finished in 0.045 secs / 0.024 secs

SUMMARY:
✔ 2 tests completed
```

同时，在我们的项目目录下生成了一个新的文件夹：coverage：

```bash
User:react_boilerplate i301792$ cd coverage/
User:coverage i301792$ tree
.
|____Chrome 51.0.2704 (Mac OS X 10.11.6)
| |____app
| | |____components
| | | |____FooBar.js.html
| | | |____HelloWorld.js.html
| | | |____index.html
| | |____index.html
| | |____index.js.html
| |____base.css
| |____index.html
| |____prettify.css
| |____prettify.js
| |____sort-arrow-sprite.png
| |____sorter.js
```

打开其中的html文件`index.html`，即可查看生成的测试覆盖率报告。


![image1](http://7xsxyo.com1.z0.glb.clouddn.com/coverage1.png)

![image2](http://7xsxyo.com1.z0.glb.clouddn.com/coverage2.png)


本文的所有代码可以在[react_boilerplate_v8](https://github.com/jiji262/react_boilerplate/tree/master/_tutorial_/react_boilerplate_v8)中查看。


## 参考链接

http://krasimirtsonev.com/blog/article/a-modern-react-starter-pack-based-on-webpack

http://nicolasgallagher.com/how-to-test-react-components-karma-webpack/

https://www.codementor.io/reactjs/tutorial/test-reactjs-components-karma-webpack

https://medium.com/@gunnarlium/es6-code-coverage-with-babel-jspm-karma-jasmine-and-istanbul-2c1918c5bb23#.59hdlbd7w

https://github.com/zyml/es6-karma-jasmine-webpack-boilerplate

https://github.com/isaacs/node-glob

https://github.com/deepsweet/babel-istanbul-loader

https://medium.com/@scbarrus/how-to-get-test-coverage-on-react-with-karma-babel-and-webpack-c9273d805063#.v8xtgvpdi
 