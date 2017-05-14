
[Source](https://medium.com/javascript-scene/top-javascript-frameworks-topics-to-learn-in-2017-700a397b711 "Permalink to Top JavaScript Frameworks &amp; Topics to Learn in 2017")

# Top JavaScript Frameworks &amp; Topics to Learn in 2017

![][1]

The popularity of JavaScript has led to a very vibrant ecosystem of technologies, frameworks, and libraries. Along with all the amazing diversity and energy in the ecosystem comes a high degree of confusion for many. What technologies should you care about?

Where should you invest your time to get the most benefit? Which tech stacks are companies hiring for right now? Which ones have the most growth potential?

What are the most important technologies to know right now? This post is a high-level overview of stuff you need to know, packed with links where you can learn all about it.

Remember as you're learning to experiment with some actual code. You can play with code interactively on [Codepen.io][2]. If you're still learning ES6, you can see how it translates using the [Babel REPL][3].

This is going to be a long list, but don't get discouraged. You can do this! If you're looking at this list, worried about how you'll ever learn everything you need to know to build modern apps, read ["Why I'm Thankful for JavaScript Fatigue"][4]. Then buckle down and get to work.

#### A Note on Optional&nbsp;Learning

Some of this stuff is **strictly optional***, which means, I recommend them if you are interested in them, or you need to know them for a job, but you should not feel obligated to learn them. Anything marked with an asterisk (e.g., **example***) is optional.

Anything not marked with a * should be learned, but don't feel obligated to learn everything there is to know about everything. You need to be aware of the non-optional stuff, but you don't necessarily need to be a definitive subject matter expert on absolutely everything.

### JavaScript &amp; DOM Fundamentals

Before you try to land a job using JavaScript, you should have a good grasp of JavaScript fundamentals:

* **Builtin methods:** Learn methods for the standard data types (especially [arrays][5], [objects][6], [strings][7], and [numbers][8]).
* **Functions &amp; [****pure functions**][9]**:** You probably think you've got a great grasp of functions, but JavaScript has some tricks up its sleeves, and you'll need to learn about pure functions to get a handle on functional programming.
* [**Closures**][10]**:** Learn how JavaScript's function scopes behave.
* **Callbacks:** A callback is a function used by another function to signal when there is a result ready. You say, "do your job, call me when it's done."
* [**Promises**][11]**: **A promise is a way to deal with future values. When a function returns a promise, you can attach callbacks using the&nbsp;`.then()` method to run after the promise resolves. The resolved value is passed into your callback function, e.g., `doSomething().then(value =&gt; console.log(value));`
* [**Ajax &amp; server API calls**][12]**:** Most interesting apps eventually need to talk to the network. You should know how to communicate with APIs.
* [**ES6**][13]**: **The current version of JavaScript is ES2016 (aka ES7), but a lot of developers still haven't properly learned ES6. It's past time.
* [**Classes**][14] (note: [**Avoid class inheritance**][15]. See [How to Use Classes and Sleep at Night][16].)
* [**Functional programming basics**][17]**: **Functional programming produces programs by composing mathematical functions, avoiding shared state &amp; mutable data. It's been years since I've seen a production JavaScript app that didn't make heavy use of functional programming. It's time to master the fundamentals.
* [**Generators**][18]** &amp; [****async/await**][19]**:** In my opinion, the best way to write asynchronous code that looks synchronous. It has a learning curve, but once you've learned it, the code will be easier to read.
* **Performance: [****RAIL**][20]** — **Start with ["PageSpeed Insights"][21] &amp; ["WebPageTest.org"][22]
* **Progressive Web Applications (PWAs):** See ["Native Apps are Doomed"][23] &amp; ["Why Native Apps Really Are Doomed"][24]
* [**Node &amp; Express**][25]**: **Node lets you use JavaScript on the server, meaning your users can store data in the cloud and access it anywhere. Express is the most popular framework for Node by a landslide.
* [**Lodash**][26]**:** A great, modular utility belt for JavaScript, packed with functional programming goodies. Import the data-last functional modules from `lodash/fp`.

### Tooling

* [**Chrome Dev Tools**][27]**:** [DOM inspect][28] &amp; [JS debugger][29]: The best debugger, IMO, though Firefox has some really cool tools you might want to check out, too.
* [**npm**][30]**:** The standard open-source package repository for the JavaScript language.
* [**git**][31]** &amp; ****[GitHub**][32]**:** Distributed version manager — keeps track of your source code changes over time.
* **[Babel**][33]**:** Used to compile ES6 to work on older browsers.
* **[Webpack**][34]**:** The most popular bundler for standard JavaScript look for simple starter kit/boilerplate config examples to get things running fast)
* **[Atom**][35]**, ****[VSCode**][36]**, or ****[WebStorm**][37]** \+ ****[vim**][38]**:** You're gonna need an editor. Atom and VSCode are the most popular JS editors today. Webstorm is another solution with very robust support for quality tooling. I recommend learning vim, or at least bookmarking the cheat sheet because sooner or later, you're gonna need to edit a file on a server, and it's the easiest way — vim comes installed on just about every flavor of Unix compatible OS, and works great over SSH terminal connections.
* **[ESLint:**][39] Catch syntax errors and style issues early. After code review and TDD, the third best thing you can do to reduce bugs in your code.
* **[Tern.js:**][40] Type inference tools for standard JavaScript, and currently my favorite type related tool for JavaScript — no compile step or annotations required. I've kicked all the tires, and Tern.js delivers most of the benefits, and virtually none of the costs of using a static type system for JS.
* **[Yarn**][41] Similar to npm, but install behavior is deterministic, and Yarn aims to be faster than npm.
* **[TypeScript*:**][42] Static types for JavaScript. _Completely optional_ unless you're learning Angular 2. If you're not using Angular 2, you should evaluate carefully before choosing TypeScript. I like it a lot and I admire the TypeScript team's excellent work, but there are tradeoffs you need to know about. **Required reading:** ["The Shocking Secret About Static Types"][43] &amp; ["You Might Not Need TypeScript"][44].
* **[Flow*:**][45] Static type checker for JavaScript. See ["TypeScript vs Flow"][46] for an impressively informed and objective comparison of the two. Note that I've had some difficulty getting Flow to give me good IDE feedback, even using [Nuclide][47].

### React

**[React**][48] is a JavaScript library for building user interfaces, created by Facebook. It's based on the idea of uni-directional data flow, meaning that for each update cycle:

1. React takes inputs to components as props and conditionally renders DOM updates if data has changed for specific parts of the DOM. Data updates during this phase can't retrigger the render until the next drawing phase.
2. Event handling phase — after the DOM has rendered, React listens for and events, delegating events to a single event listener at the root of its DOM tree (for better performance). You can listen to those events and update data in response.
3. Using any changes to the data, the process repeats at 1.

This is in contrast to 2-way data binding, where changes to the DOM may directly update data (e.g., as is the case with Angular 1 and Knockout). With 2-way binding, changes to the DOM during the DOM render process (called the digest cycle in Angular 1) can potentially retrigger the drawing phase before the drawing is finished, causing reflows and repaints — slowing performance.

React does not prescribe a data management system, but a Flux-based approach is recommended. React's 1-way data flow approach borrowing ideas from functional programming and immutable data structures transformed the way we think about front-end framework architecture.

For more on React &amp; Flux architecture, read ["The Best Way to Learn to Code is to Code: Learn App Architecture by Building Apps"][49].

* **[create-react-app*:**][50] The quickest way to get started with React.
* **[react-router*:**][51] Dead simple routing for React.
* **[Next.js*:**][52] Dead simple Universal render &amp; Routing for Node &amp; React.
* **[velocity-react*:**][53] Animations for React — allows you to use the VMD bookmarklet for interactive visual motion design on your pages.

### Redux

**[Redux**][54] provides transactional, deterministic state management for your apps. In Redux, we iterate over a stream of action objects to reduce to the current application state. To learn why that's important, read ["10 Tips for Better Redux Architecture."][55] To get started with Redux, check out the excellent courses by the creator of Redux, [Dan Abramov][56]:

* **["Getting Started with Redux"**][57]
* **["Building React Applications with Idiomatic Redux"**][58]

**Redux is mandatory learning, even if you never use Redux** for a production project.

Why? Because it will give you lots of practice and teach you the value of using **pure functions** and teach you new ways to think about **reducers**, which are **general-purpose functions** for iterating over collections of data and extracting some value from them. Reducers are so generally useful that `Array.prototype.reduce` was added to the JS specification.

Reducers are important for more than just arrays, and learning new ways of working with Reducers is valuable all by itself.

* **[redux-saga*:**][59] A synchronous-style side-effect library for Redux. Use this to manage I/O (such as handling network requests).

### Angular 2*

**[Angular 2**][60] is the successor to the wildly popular Angular framework from Google. Because of it's crazy popularity, it's going to look great on your resume — but I recommend learning React first.

I have a preference for [React over Angular 2][61] because:

1. It's simpler, and
2. It's extremely popular and used in lots of jobs (so is Angular 2)

For this reason, I recommend learning React, but I consider Angular 2 **strictly optional***. If you have a strong preference for Angular 2, feel free to swap them. Learn Angular 2 first, and consider React optional. Either will benefit you and look great on your resume.

Whichever you choose, try to focus on it for at least 6 months — 1 year before running off to learn the other one. It takes time to really sink into strong proficiency.

### RxJS*

**[RxJS**][62] is a collection of reactive programming utilities for JavaScript. Think of it as Lodash for streams. Reactive programming has officially arrived on the JavaScript scene. The ECMAScript Observables proposal is a stage-1 draft, and RxJS 5+ is the canonical standard implementation.

As much as I love RxJS, if you just import the whole thing all at once, **it can really bloat your bundle sizes** (there are lots of operators). To combat bundle bloat, don't import the whole thing. Use the patch imports, instead:

Using patch imports can reduce the size of your rxjs dependencies in your bundle by ~200k. That's a really big deal. It will make your app **much faster**.

### EDIT: Why Didn't You List <your favorite thing="">?

Several people have asked why I didn't list their favorite framework. One of the important criteria I considered was "will this be useful on a real job?".

Yes, this is a popularity contest, but the opportunities that knowing a framework will open up is an important consideration when you're deciding where to focus your learning investment.

To answer that question, I looked at some key indicators. First, Google Trends. If you want to reproduce this Google Trends graph, remember to select by topic, not keyword, since several of these words will deliver lots of false negatives. In other words, these are topic-focused trends, **not keyword searches:**

![][63]

JS Topics on Google&nbsp;Trends

What this tells us is relative interest in various projects. If people are searching for them, chances are they're exploring their options, or searching for help or documentation. This is a pretty decent indicator of relative usage levels.

Another good source of data is Indeed.com, which aggregates job listing data from a large variety of sources. Job posting popularity has declined sharply in recent years, but they still collect enough data to make good relative comparisons that tell you frameworks that people are actually using in production projects, on the job:

![][64]

To reproduce those findings, search for <framework name=""> javascript and leave the location blank. As you can clearly see:

**Angular and React dominate: Nothing else even comes close.** (Except jQuery, which is used on a huge share of all websites — non-apps included — because it's used by almost all legacy systems, including popular CMS systems like WordPress).

You might see that Angular has a significant advantage over React in these listings. Why do I recommend learning React first? Because:

1. [More people are interested in learning React than Angular][65]
2. [React significantly leads Angular in user satisfaction][65]

In other words, **React is winning the mindshare and customer satisfaction battles,** and if the trends over the past year and a half continue to unfold, React has a very real chance of unseating Angular as the dominant front-end framework.

Angular 2 has a chance to turn that around, so Angular could make a comeback, but so far, React is putting up a really good fight.

#### Frameworks to&nbsp;Watch

* **[Vue.js**][66]***** has a ton of GitHub stars and downloads. If things continue the way they are going, it will do very well in 2017, but I don't think it will unseat either React or Angular (both of which are also growing fast) in the next year or so. Learn this **after** you have learned React or Angular.
* **[MobX**][67]***** is a great data management library which has become a popular alternative to Redux. It is also growing fast, and I expect it will also do well in 2017. I prefer Redux for most apps, but there are definitely cases where MobX is a better choice. For example, if you have hundreds of thousands of dynamic DOM objects on a page, it will probably perform better. Also, if your app workflows are all simple and you don't need transactional, deterministic state, you probably don't need Redux. MobX is definitely a simpler solution. Learn this **after** you have learned Redux.

### Next Steps

Now that you've studied up on all this hot tech, read ["How to Land Your First Development Job in 5 Simple Steps"][68].

[Level up your JavaScript game.][69] If you're not a member, you're missing out.

![][70]

[1]: https://cdn-images-1.medium.com/max/800/1*U57FQqHw9eCVlS26M2fxmw.jpeg
[2]: http://codepen.io/
[3]: https://babeljs.io/repl/
[4]: https://medium.com/javascript-scene/why-im-thankful-for-js-fatigue-i-know-you-re-sick-of-those-words-but-this-is-different-296fae0c888f
[5]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array
[6]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object
[7]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String
[8]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number
[9]: https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976
[10]: https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-closure-b2f0d2152b36
[11]: https://developers.google.com/web/fundamentals/getting-started/primers/promises
[12]: https://github.com/mzabriskie/axios
[13]: https://medium.com/javascript-scene/how-to-learn-es6-47d9a1ac2620
[14]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes
[15]: https://medium.com/javascript-scene/the-two-pillars-of-javascript-ee6f3281e7f3
[16]: https://medium.com/@dan_abramov/how-to-use-classes-and-sleep-at-night-9af8de78ccb4
[17]: https://ericelliottjs.com/premium-content/webcast-the-two-pillars-of-js-introduction-to-functional-programming/
[18]: https://medium.com/javascript-scene/7-surprising-things-i-learned-writing-a-fibonacci-generator-4886a5c87710
[19]: https://medium.com/javascript-scene/the-hidden-power-of-es6-generators-observable-async-flow-control-cfa4c7f31435
[20]: https://developers.google.com/web/fundamentals/performance/rail
[21]: https://developers.google.com/speed/pagespeed/insights/
[22]: https://www.webpagetest.org/
[23]: https://medium.com/javascript-scene/native-apps-are-doomed-ac397148a2c0
[24]: https://medium.com/javascript-scene/why-native-apps-really-are-doomed-native-apps-are-doomed-pt-2-e035b43170e9
[25]: https://medium.com/javascript-scene/introduction-to-node-express-90c431f9e6fd#.gl2r6gcnn
[26]: https://lodash.com/
[27]: https://developer.chrome.com/devtools
[28]: https://developer.chrome.com/devtools#dom-and-styles
[29]: https://developer.chrome.com/devtools#debugging-javascript
[30]: https://www.npmjs.com/
[31]: https://try.github.io/levels/1/challenges/1
[32]: http://github.com/
[33]: https://babeljs.io/
[34]: https://webpack.github.io/
[35]: https://atom.io/
[36]: https://code.visualstudio.com/d?utm_expid=101350005-35.Eg8306GUR6SersZwpBjURQ.3&amp;utm_referrer=https%3A%2F%2Fwww.google.com%2F
[37]: https://www.jetbrains.com/webstorm/
[38]: http://vim.rtorr.com/
[39]: http://eslint.org/
[40]: https://ternjs.net/
[41]: https://yarnpkg.com/
[42]: https://www.typescriptlang.org/
[43]: https://medium.com/javascript-scene/the-shocking-secret-about-static-types-514d39bf30a3
[44]: https://medium.com/javascript-scene/you-might-not-need-typescript-or-static-types-aa7cb670a77b
[45]: https://flowtype.org/
[46]: http://djcordhose.github.io/flow-vs-typescript/flow-typescript-2.html#/
[47]: https://nuclide.io/
[48]: https://facebook.github.io/react/
[49]: https://medium.com/javascript-scene/the-best-way-to-learn-to-code-is-to-code-learn-app-architecture-by-building-apps-7ec029db6e00
[50]: https://github.com/facebookincubator/create-react-app
[51]: https://github.com/ReactTraining/react-router
[52]: https://zeit.co/blog/next
[53]: https://github.com/twitter-fabric/velocity-react
[54]: https://github.com/reactjs/redux
[55]: https://medium.com/javascript-scene/10-tips-for-better-redux-architecture-69250425af44
[56]: https://medium.com/u/a3a8af6addc1
[57]: https://egghead.io/courses/getting-started-with-redux
[58]: https://egghead.io/courses/building-react-applications-with-idiomatic-redux
[59]: https://github.com/yelouafi/redux-saga
[60]: https://angular.io/
[61]: https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c
[62]: https://github.com/Reactive-Extensions/RxJS
[63]: https://cdn-images-1.medium.com/max/800/1*gmYPusm1EjWu713tmVCd8A.png
[64]: https://cdn-images-1.medium.com/max/800/1*aGINRwIAXUW6dUEKzvbFDw.png
[65]: https://medium.com/@sachagreif/the-state-of-javascript-front-end-frameworks-1a2d8a61510
[66]: https://vuejs.org/
[67]: https://github.com/mobxjs/mobx
[68]: https://medium.com/javascript-scene/how-to-land-your-first-development-job-in-5-simple-steps-4e9fb73314c
[69]: https://ericelliottjs.com/product/lifetime-access-pass/
[70]: https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg

  </framework></your>
