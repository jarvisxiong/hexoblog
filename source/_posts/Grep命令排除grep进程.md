title: Linux Grep命令
author: Jarvis Xiong
tags:
  - linux
categories:
  - linux
date: 2017-05-03 08:57:00
---
#### grep命令排除grep本身进程

在进程表中查找特定进程的命令通常如下：
```
ps -ef | grep some_string  
```
输出时，不仅会输出将要查找的进程数据，清空包括grep进程本身的数据，因为查找串包含在grep调用中。过滤grep本身方法有：
```
ps -ef | grep some_string |grep -v grep
```
-v:表示忽略grep本身。

>grep结合xargs使用，kill指定的进程。
