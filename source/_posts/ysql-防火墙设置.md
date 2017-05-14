title: mysql 防火墙设置
author: Jarvis Xiong
tags: []
categories: []
date: 2017-05-14 09:54:00
---
#### mysql防火墙设置
>mysql限制公网访问
```
iptables -A INPUT -p tcp -s 104.194.68.242 --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp -s 127.0.0.1 --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j DROP
```