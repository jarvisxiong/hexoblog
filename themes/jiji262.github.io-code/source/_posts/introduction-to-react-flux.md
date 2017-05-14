title: "手把手教你玩转 React Flux"
layout: post
date: 2016-11-28 20:10
comments: true
tags: [前端, React, flux]

---

本文所有代码可以在Github上查看。
[react-flux-demo](https://github.com/jiji262/react-flux-demo)


# 新建React项目

既然有兴趣打开本文，说明你对React的基本开发应该有所了解。我们教程的第一步就是创建一个新的React项目。我们可以使用一些React Boilerplate项目方便的创建一个新的React项目，比如我之前创建的React Boilerplate：

[react_boilerplate](https://github.com/jiji262/react_boilerplate)

该React Boilerplate的实现过程，可以参考我之前的文章[手把手教你基于ES6架构自己的React Boilerplate项目](http://jiji262.github.io/2016/04/29/create-your-own-react-boilerplate/)。

或者，也可以使用facebook最新推出的一个类似项目：

[create-react-app](https://github.com/facebookincubator/create-react-app)

我们这里使用`facebookincubator/create-react-app`:

```shell

npm install -g create-react-app

create-react-app todoApp
cd todoApp/
npm start
```

然后我们就可以通过访问`http://localhost:3000/`来查看结果了。

# 使用React实现简单的Todo程序（不带flux）

我们要实现一个简单的todo程序，可以添加、删除todo条目。

## ListContainer 组件

首先我们需要一个container用于放置todo列表，命名为`ListContainer.js`，其内容如下：
```javascript
export default class ListContainer extends Component {
  state = {
    list: []
  }

  handleAddItem = (newItem) => {
    var list = this.state.list;
    list.push(newItem);
    this.setState({
      list: list
    });
  }

  handleRemoveItem = (index) => {
   this.state.list.splice(index, 1);
    this.setState({
      list: this.state.list
    });
  }

  render = () => {
    return (
      <div className="col-sm-6 col-md-offset-3">
        <div className="col-sm-12">
          <h3 className="text-center"> Todo List </h3>
          <AddItem add={this.handleAddItem}/>
          <List items={this.state.list} remove={this.handleRemoveItem}/>
        </div>
      </div>
    )
  }
}
```

`render`函数中来组建dom元素显示todo列表，其中`AddItem`组件是用来新建todo的，`List`组件用于显示todo列表项。

在两个响应函数`handleAddItem`及`handleRemoveItem`中，通过`setState`函数来管理state。

## List 组件

todo列表项显示组件内容如下：
```javascript
export default class List extends Component {
  static defaultProps = {
          items: [],
          remove: () => {}
  }

  static propTypes = {
      items: React.PropTypes.array.isRequired,
      remove: React.PropTypes.func.isRequired
  }

  render = () => {
    var styles = {
      uList: {
        paddingLeft: 0,
        listStyleType: "none"
      },
      listGroup: {
        margin: '5px 0',
        borderRadius: 5
      },
      removeItem: {
        fontSize: 20,
        float: "left",
        position: "absolute",
        top: 12,
        left: 6,
        cursor: "pointer",
        color: "rgb(222, 79, 79)"
      },
      todoItem: {
        paddingLeft: 20,
        fontSize: 17
      }
    };
    var listItems = this.props.items.map(function(item, index){
      return (
        <li key={index} className="list-group-item" style={styles.listGroup}>
          <span
            className="glyphicon glyphicon-remove"
            style={styles.removeItem}
            onClick={this.props.remove.bind(null, index)}>
          </span>
          <span style={styles.todoItem}>
            {item}
          </span>
        </li>
      )
    }.bind(this));
    return (
      <ul style={styles.uList}>
        {listItems}
      </ul>
    )
  }
};
```
其中用于删除的图标上的`onClick`事件会调用父级组件响应的方法，完成删除操作

## AddItem 组件

添加新的todo项的组件`AddItem.js`内容如下：
```javascript
export default class AddItem extends Component {
  static defaultProps = {
          add: () => {}
  }

  static propTypes = {
      add: React.PropTypes.func.isRequired
  }

  handleSubmit = (e) => {
    if(e.keyCode === 13){
      var newItem = this.myTextInput.value;
      this.myTextInput.value = '';
      this.props.add(newItem);
    }
  }

  render = () => {
    return (
      <div>
        <input type="text" ref={(ref) => this.myTextInput = ref} className="form-control" placeholder="New Item" onKeyDown={this.handleSubmit}  />
      </div>
    )
  }
};
```

`onKeyDown`函数处理添加事件的提交，会调用父级组件设置的add方法。

## App.js

入口文件`App.js`中引入`ListContainer`即可：
```javascript
class App extends Component {
  render() {
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome</h2>
        </div>
        <div className="App-intro">
          <div className="row">
            <ListContainer />
          </div>
        </div>
      </div>
    );
  }
}
```

至此，我们可以通过`npm start`启动应用程序，然后在浏览器中可以通过访问`http://localhost:3000/`来查看结果了。

具体代码请移步Github：
[react-flux-demo/todoApp](https://github.com/jiji262/react-flux-demo/tree/master/todoApp)

# Flux

Flux并不是一个库或者框架，可以将其简单的理解为一种软件架构方式。在其官方网站上，其原理图如下：

![](https://github.com/facebook/flux/raw/master/docs/img/flux-diagram-white-background.png)

一下子看上去比较晦涩，特别是在其官方文档中，涉及多个新的名词，如Views, Stores, Dispatcher Actions, Action Types, Action Creators如此等等，一下子使其更加难以理解。

但是，真正熟悉之后，你会发现，其实其涉及的核心概念也就下面这么几个：

**Actions**：帮助向Dispatcher传递数据的辅助方法；
**Dispatcher**：接收action，并且向注册的回调函数广播payloads；
**Stores**：应用程序状态的容器&并且含有注册到Dispatcher的回调函数；
**Views**：React组件，从Store获取状态，并将其逐级向下传递给子组件。

一个重要的特征是，其实现了一个单向的数据流，用于高效的管理state。这就有效的避免了MVC框架中view和model多对多容易出现的各种问题。关于原理的详细介绍，可以参考文后的链接。

## flux架构的实现

如前所述，Flux是一种架构方式，一种设计思想。因此，Facebook并没有规定其必须如何实现，这也导致其实现版本层出不穷，具体可以参考：

https://github.com/kriasoft/react-starter-kit/issues/22

其中最为流行的当属Redux，以后再专文详述。
本文使用[Facebook提供的flux版本](https://github.com/facebook/flux)。

# 使用flux架构重构Todo程序

我们将上面实现的React应用简单做些修改，以便理解flux架构的基本概念及设计思想。

## 目录结构

我们将创建独立的目录来保存`stores`,`actions`,`dispatcher`等。目录结构如下：
```
src
-- actions
-- constants
-- dispatcher
-- stores
-- components
```

其中`constants`用于保存一些常量，`components`就是我们的React组件，对应flux架构中的`views`。

## Constants

`constants/appConstants.js`内容很简单，创建了两个我们需要在action中用到的常量。代码如下：

```javascript
var appConstants = {
  ADD_ITEM: "ADD_ITEM",
  REMOVE_ITEM: "REMOVE_ITEM"
}

export default appConstants
```

## Stores

`Stores`用于集中管理state的变化。`stores/todoStore.js`文件内容如下：

```javascript
import AppDispatcher from '../dispatcher/AppDispatcher';
import appConstants from '../constants/appConstants';
import {EventEmitter} from 'events';

var CHANGE_EVENT = 'change';

var _store = {
  list: []
};

var addItem = function(item){
  _store.list.push(item);
};

var removeItem = function(index){
  _store.list.splice(index, 1);
}

var todoStore = Object.assign({}, EventEmitter.prototype, {
  addChangeListener: function(cb){
    this.on(CHANGE_EVENT, cb);
  },
  removeChangeListener: function(cb){
    this.removeListener(CHANGE_EVENT, cb);
  },
  getList: function(){
    return _store.list;
  },
});
```

其中引入`events`事件机制用于处理`store`和`view`之间的事件响应。

## Dispatcher

`Dispatcher`用于创建一种事件注册分发的机制，可以简单理解为pub/sub模式（严格意义上并不完全是）。`dispatcher/AppDispatcher.js`代码如下：

```javascript
import { Dispatcher } from 'flux';

const AppDispatcher = new Dispatcher();

AppDispatcher.handleAction = function(action){
  this.dispatch({
    source: 'VIEW_ACTION',
    action: action
  });
};

export default AppDispatcher;
```

注册`dispatchers`的操作一般放在`stores`里。在`stores/todoStore.js`文件中:
```javascript
AppDispatcher.register(function(payload){
  var action = payload.action;
  switch(action.actionType){
    case appConstants.ADD_ITEM:
      addItem(action.data);
      todoStore.emit(CHANGE_EVENT);
      break;
    case appConstants.REMOVE_ITEM:
      removeItem(action.data);
      todoStore.emit(CHANGE_EVENT);
      break;
    default:
      return true;
  }
});
```

## actions

action就是我们所要做的动作，在我们的示例中就是添加todo项目和删除todo项目。下发事件（dispatcher）的操作就定义在`actions/todoActions.js`里：

```javascript
import AppDispatcher from '../dispatcher/AppDispatcher';
import appConstants from '../constants/appConstants';

var todoActions = {
  addItem: function(item){
    AppDispatcher.handleAction({
      actionType: appConstants.ADD_ITEM,
      data: item
    });
  },
  removeItem: function(index){
    AppDispatcher.handleAction({
      actionType: appConstants.REMOVE_ITEM,
      data: index
    })
  }
}

export default todoActions
```

## components

在`components`中就是我们之前创建的React组件了，需要做的修改就是将states的管理部分代码移到了stores里。因此，对`components/ListContainer.js`文件作如下修改：

```javascript
import React, { Component } from 'react';
import AddItem from './AddItem'; 
import List from './List'; 
import todoStore from '../stores/todoStore';
import todoActions from '../actions/todoActions';

export default class ListContainer extends Component {
  state = {
    list: todoStore.getList()
  }

  componentDidMount = () => {
    todoStore.addChangeListener(this._onChange);
  }

  componentWillUnmount = () => {
    todoStore.removeChangeListener(this._onChange);
  }

  handleAddItem = (newItem) => {
    todoActions.addItem(newItem);
  }

  handleRemoveItem = (index) => {
    todoActions.removeItem(index);
  }

  _onChange = () => {
    this.setState({
      list: todoStore.getList()
    })
  }

  render = () => {
    return (
      <div className="col-sm-6 col-md-offset-3">
        <div className="col-sm-12">
          <h3 className="text-center"> Todo List </h3>
          <AddItem add={this.handleAddItem}/>
          <List items={this.state.list} remove={this.handleRemoveItem}/>
        </div>
      </div>
    )
  }
}
```
其中所有state的状态变化均通过stores来处理。可以看到，在这里`handleAddItem`和`handleRemoveItem`分别会触发action里定义的动作，然后就会触发在store里注册好的dispatcher的操作，进而完成对state的更改。`_onChange`事件通过`events`事件机制处理store和view间数据的同步。

至此，所有的代码修改完毕，我们可以通过`npm start`启动应用程序，然后在浏览器中可以通过访问`http://localhost:3000/`来查看结果了。

具体代码请移步Github：
[react-flux-demo/todoApp-flux](https://github.com/jiji262/react-flux-demo/tree/master/todoApp-flux)

# 参考链接

[flux offical site](https://github.com/facebook/flux)
[flux documentation](http://facebook.github.io/flux/docs/overview.html)
[Flux: An Application Architecture for React](https://facebook.github.io/react/blog/2014/05/06/flux.html)
[The Flux Quick Start Guide](http://www.jackcallister.com/2015/02/26/the-flux-quick-start-guide.html)
[A cartoon guide to Flux](https://code-cartoons.com/a-cartoon-guide-to-flux-6157355ab207)
[Flux For Stupid People](http://blog.andrewray.me/flux-for-stupid-people/)
[Which Flux implementation should I use?](https://github.com/kriasoft/react-starter-kit/issues/22)
[Creating A Simple Shopping Cart with React.js and Flux](https://scotch.io/tutorials/creating-a-simple-shopping-cart-with-react-js-and-flux)
[ruanyf/extremely-simple-flux-demo](https://github.com/ruanyf/extremely-simple-flux-demo)
[Flux: Getting Past the Learning Curve](https://medium.com/@tribou/react-and-flux-for-the-rest-of-us-61f90869d51f#.lpiy12h23)
[Getting To Know Flux, the React.js Architecture](https://scotch.io/tutorials/getting-to-know-flux-the-react-js-architecture)
[React.js Tutorial Pt 3: Architecting React.js Apps with Flux.](https://tylermcginnis.com/react-js-tutorial-pt-3-architecting-react-js-apps-with-flux-4657ef831895#.17vrxm44o)


