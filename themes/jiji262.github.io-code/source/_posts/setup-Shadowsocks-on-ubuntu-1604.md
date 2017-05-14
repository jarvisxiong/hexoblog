title: " 科学上网:ubuntu 16.04服务器上搭建Shadowsocks服务"
layout: post
date: 2016-04-20 20:10
comments: true
tags: [工具, Shadowsocks, 翻墙]

---

## 前言

科学上网应该是必备技能了，但是一些免费的方案如goagent等实在是太不稳定。购买自己的服务器，然后自己搭建梯子不失为一种较好的解决方案。本文就来在ubuntu 16.04服务器上使用Shadowsocks搭建自己的科学上网工具。

Shadowsocks由于政策原因，在百度里是搜不到的，因此本文也随时可能被河蟹，关注公众号(linghucong_wx)以防万一吧！

![](http://7xsxyo.com1.z0.glb.clouddn.com/qrcode_for_gh_bf8431032a79_860.jpg)

## shadowsocks 服务器安装

更新软件源
```shell
sudo apt-get update
```
然后安装 PIP 环境
```shell
sudo apt-get install python-pip
```
直接安装 shadowsocks
```
sudo pip install shadowsocks
```
## 运行 shadowsocks 服务器

启动命令如下：如果要停止运行，将命令中的start改成stop。
```
sudo ssserver -p 8388 -k password -m rc4-md5 -d start
```
也可以使用配置文件进行配置，方法创建`/etc/shadowsocks.json`文件，填入如下内容：
```
{
    "server":"my_server_ip",
    "server_port":8388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"mypassword",
    "timeout":300,
    "method":"rc4-md5"
}
```
各字段的含义：

| 字段           |      含义     |
|---------------|:-------------|
| server        | 服务器 IP (IPv4/IPv6)，注意这也将是服务端监听的 IP 地址|
| server_port   | 服务器端口                                                     |
| local_port    | 本地端端口                                                      |
| password      | 用来加密的密码                                                   |
| timeout       | 超时时间（秒）                                                   |
| method        | 加密方法，可选择 “bf-cfb”, “aes-256-cfb”, “des-cfb”, “rc4″, 等等。 |

**Tips**: 加密方式推荐使用rc4-md5，因为 RC4 比 AES 速度快好几倍，如果用在路由器上会带来显著性能提升。旧的 RC4 加密之所以不安全是因为 Shadowsocks 在每个连接上重复使用 key，没有使用 IV。现在已经重新正确实现，可以放心使用。更多可以看 issue。

**Tips**: 如果需要配置多个用户,可以这样来设置:
```
{
    "server":"my_server_ip",
    "port_password": {
        "端口1": "密码1",
        "端口2": "密码2"
    },
    "timeout":300,
    "method":"rc4-md5",
    "fast_open": false
}
```

创建完毕后，赋予文件权限：
```
sudo chmod 755 /etc/shadowsocks.json
```
为了支持这些加密方式，你要需要安装
```
sudo apt–get install python–m2crypto
```
然后使用配置文件在后台运行：
```
sudo ssserver -c /etc/shadowsocks.json -d start
```
## 配置开机自启动

编辑 /etc/rc.local 文件
```
sudo vi /etc/rc.local
```
在 exit 0 这一行的上边加入如下
```
/usr/local/bin/ssserver –c /etc/shadowsocks.json
```
或者 不用配置文件 直接加入命令启动如下：
```
/usr/local/bin/ssserver -p 8388 -k password -m aes-256-cfb -d start
```
到此重启服务器后，会自动启动。

## 安装和配置shadowsocks客户端

最新版本的shadowsocks客户端可以从[其Github上下载](https://github.com/shadowsocks/shadowsocks/wiki/Shadowsocks-%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E).
客户端配置及使用方法可以[参考这里的教程](http://www.ishadowsocks.org/)。
iPhone及安卓手机上的配置,可以[参考这个教程](http://www.jianshu.com/p/08ba65d1f91a)。

需要特别注意的是,在Chrome上需要设置代理为SOCKS v5模式,127.0.0.1:1080,建议安装SwitchySharp扩展. 具体示例可以[参考这里](http://shadowkong.com/archives/1802)。

## Reference
[shadowsocks](https://github.com/shadowsocks/shadowsocks)
[shadowsocks.org](https://shadowsocks.org/)
[教你一步一步自己搭梯子](https://www.douban.com/note/534175318/)
[shadowsocks-install-and-optimize](http://wuchong.me/blog/2015/02/02/shadowsocks-install-and-optimize/)

## 写在最后

最后的自然是福利。如果没有自己的服务器又想科学上网，可以私信我，我可以共享几个账号供测试使用。

另外，由于微信限制，文中所有链接均无法显示，请直接点击阅读原文查看。



