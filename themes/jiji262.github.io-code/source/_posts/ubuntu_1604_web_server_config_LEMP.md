title: "手把手教你从头搭建Web服务器及LEMP环境(使用Ubuntu16.04+Nginx+MySQL+PHP)"
layout: draft
date: 2016-08-18 20:10
comments: true
tags: [前端, 服务器配置, Ubuntu, Nginx, LEMP, 前端基础]

---

# 前言

拿到一台新装的Linux服务器,该如何配置成一台可以解析动态网页脚本的Web服务器呢? 相信这是很多人都会有的问题。本文将一步一步带你从头开始搭建给予LEMP技术栈的Web服务器,并使其可以正常运行PHP、Nodejs等语言。

所谓的LEMP技术栈,顾名思义其实就是Linux, Nginx, MySQL, PHP的组合。当然,如果喜欢,你也可以不用Nginx,而去选择Apache,这就是所谓的LAMP技术栈了。

本文使用Linux版本为Ubuntu 16.04 64位版本。

TL;DR.

# Ubuntu服务器基本设置

## 使用root登录服务器

首先我们需要使用root用户登录服务器,当然你可以选择很多工具,诸如SecureCRT或者putty等。这里通过ssh命令行登录:
```bash
local$ ssh root@SERVER_IP_ADDRESS
```

前面的`local$`表示是在本地机器操作,在服务器端,该提示符会类似`root@my-remote-server:~$`这种形式,后边会看到。

*Tips*: 如果使用的是腾讯云，其初始登录默认使用的是用户ubuntu，并不是root。因此，使用`ssh ubuntu@your_server_ip`登录之后可以修改下root的密码，然后就可以切换到用户root了。

修改密码命令如下：
```
ubuntu@VM-42-158-ubuntu:~$ sudo passwd root
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
```

有可能还需要编辑配置文件`/etc/ssh/sshd_config`中的`PermitRootLogin`的设置。

好了之后就可以使用`su`切换到root。
```
buntu@VM-42-158-ubuntu:~$ su
Password:
root@VM-42-158-ubuntu:/#
```

## 新增超级用户权限用户

root用户虽然强大,但是正是由于太强大了,所以显得不够安全,因此通常情况下我们需要创建一个新的用户,然后给他设置超级用户(superuser)权限,这样就可以安全的进行各种操作了。

使用root用户登录,做如下操作:
```bash
root@my-remote-server:~$ adduser dennis
root@my-remote-server:~$ usermod -aG sudo dennis
```

这里就将新创建的用户加入了sudo用户组,就具有了超级用户的权限。更详细的信息可以参考[这个教程](https://www.digitalocean.com/community/tutorials/how-to-edit-the-sudoers-file-on-ubuntu-and-centos)。

然后我们就可以以新创建的用户登录了:
```bash
root@my-remote-server:~# su - dennis
dennis@my-remote-server:~$
```

<!--more-->

## 设置SSH Key认证

每次我们通过ssh登录到服务器都需要输入密码,这就是密码认证的方式。为方便起见,我们可以通过ssh key认证来登录。设置之后,我们就不需要在输入密码,就可以直接ssh到服务器。

举例来说,本地机器local需要连接到服务器remote server,我们首先需要在local上生成ssh key:
```bash
ssh-keygen
```
执行之后就会看到,在`/Users/localuser/.ssh/`目录下会生成两个文件:`id_rsa`和`id_rsa.pub`,分别是私钥和公钥。

然后需要将公钥配置到服务器remote server上。一种比较简单的方式是使用ssh-copy-id工具。如果是在Mac上,可以安装[ssh-copy-id-for-OSX](https://github.com/beautifulcode/ssh-copy-id-for-OSX). 安装完成后执行
```bash
ssh-copy-id dennis@SERVER_IP_ADDRESS
```
就配置完成了。另一种方式是手动配置,可以参考[这里的教程](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)进行操作。文章中还详细介绍了SSH Key的更多内容,可供参考。

### 禁用密码认证登录方式

安全起见,我们还可以禁用密码登录的方式。修改配置文件
```bash
sudo vim /etc/ssh/sshd_config
```
修改如下属性:
```bash
PasswordAuthentication no
```
然后需要更新下sshd的配置:
```bash
sudo systemctl reload sshd
```
好了,目前就不能使用密码的方式登录了,只能通过上述ssh key认证的方式登录server了。

# LEMP环境搭建及配置

## 安装Nginx

在ubuntu上安装软件很简单,使用`apt-get`即可。注意由于权限问题,需要在前面加`sudo`。
```bash
sudo apt-get update
sudo apt-get install nginx
```

### 踩坑提醒

#### 安装Nginx时出现错误

```bash
dennis@my-remote-server:~$ sudo apt-get install nginx
Reading package lists... Done
Building dependency tree
Reading state information... Done
nginx is already the newest version (1.10.0-0ubuntu0.16.04.2).
0 upgraded, 0 newly installed, 0 to remove and 42 not upgraded.
2 not fully installed or removed.
After this operation, 0 B of additional disk space will be used.
Do you want to continue? [Y/n]
Setting up nginx-core (1.10.0-0ubuntu0.16.04.2) ...
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
invoke-rc.d: initscript nginx, action "start" failed.
dpkg: error processing package nginx-core (--configure):
 subprocess installed post-installation script returned error exit status 1
dpkg: dependency problems prevent configuration of nginx:
 nginx depends on nginx-core (>= 1.10.0-0ubuntu0.16.04.2) | nginx-full (>= 1.10.0-0ubuntu0.16.04.2) | nginx-light (>= 1.10.0-0ubuntu0.16.04.2) | nginx-extras (>= 1.10.0-0ubuntu0.16.04.2); however:
  Package nginx-core is not configured yet.
  Package nginx-full is not installed.
  Package nginx-light is not installed.
  Package nginx-extras is not installed.
 nginx depends on nginx-core (<< 1.10.0-0ubuntu0.16.04.2.1~) | nginx-full (<< 1.10.0-0ubuntu0.16.04.2.1~) | nginx-light (<< 1.10.0-0ubuntu0.16.04.2.1~) | nginx-extras (<< 1.10.0-0ubuntu0.16.04.2.1~); however:
  Package nginx-core is not configured yet.
  Package nginx-full is not installed.
  Package nginx-light is not installed.
  Package nginx-extras is not installed.

dpkg: error processing package nginx (--configure):
 dependency problems - leaving unconfigured
Errors were encountered while processing:
 nginx-core
 nginx
E: Sub-process /usr/bin/dpkg returned an error code (1)
```

##### 原因分析
Google了一下,发现出现这种错误,一般应该是由于其他应用占用了80端口。可以这样来看下:

```bash
dennis@myserver:~$ sudo netstat -nlp
sudo: unable to resolve host myserver
[sudo] password for dennis:
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      132/rpcbind
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      332/apache2
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      269/sshd
tcp        0      0 0.0.0.0:25              0.0.0.0:*               LISTEN      454/master
tcp6       0      0 :::111                  :::*                    LISTEN      132/rpcbind
tcp6       0      0 :::22                   :::*                    LISTEN      269/sshd

```
果然80端口被默认安装的apache给占掉了,所以需要干掉占用80端口的apache2：
```bash
sudo kill -9 332
```

#### 运行apt-get命令更新或安装软件出现Setting locale failed错误
     
```bash
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LC_CTYPE = "en_US.UTF-8",
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory
```
     
##### 解决办法：
     
```bash
sudo ap-get update
apt-get install language-pack-en
```

### Nginx 常用目录

#### 内容

**/var/www/html**: 保存web网页内容的默认目录

#### 服务器配置

**/etc/nginx**: nginx 配置目录。所有Nginx相关的配置文件都在这里。
**/etc/nginx/nginx.conf**: Nginx主配置文件,进行全局默认设置。
**/etc/nginx/sites-available**: 针对每个"server blocks"独立的配置文件。这里的配置文件并不被直接使用,只有软连接到`site-enabled`的配置才会真正生效。
**/etc/nginx/sites-enabled/**: 针对每个"server blocks"独立的配置文件。由`sites-available`链接过来。
**/etc/nginx/snippets**: 一些配置脚本片段。

#### 服务器日志

**/var/log/nginx/access.log**: 默认保存所有与web服务交互的请求。
**/var/log/nginx/error.log**: Nginx的错误日志


### Tips

#### 1. 检测Nginx的配置文件是否有问题：

```bash
dennis@my-remote-server:~$ sudo nginx -t -c /etc/nginx/nginx.conf
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

```

#### 2. 停止apache服务

停掉apache服务的方法有多种，具体参考[ubuntu-linux-start-restart-stop-apache-web-server](http://www.cyberciti.biz/faq/ubuntu-linux-start-restart-stop-apache-web-server/). 较为常用的有：
```bash
sudo /etc/init.d/apache2 stop
```
或者
```bash
$ sudo apache2ctl stop
```

#### 3. 取消apache自启动

在ubuntu中apache可能默认会设置为自启动，也就是说kill了之后又会自己起来。可以通过下面的命令取消自启动：
```bash
sudo update-rc.d -f apache2 remove
```
回复自启动则需要：

```bash
sudo update-rc.d apache2 defaults
```

#### 4. Nginx启动与停止


和apache的启动和停止一样，Nginx的启动和停止服务[也有多种方式](http://www.cyberciti.biz/faq/nginx-restart-ubuntu-linux-command/)，常用的有：
```bash
//To stop your web server, you can type:
sudo systemctl stop nginx

//To start the web server when it is stopped, type:
sudo systemctl start nginx

//To stop and then start the service again, type:
sudo systemctl restart nginx

//If you are simply making configuration changes, Nginx can often reload without dropping connections. To do this, this command can be used:
sudo systemctl reload nginx

//By default, Nginx is configured to start automatically when the server boots. If this is not what you want, you can disable this behavior by typing:
sudo systemctl disable nginx

//To re-enable the service to start up at boot, you can type:
sudo systemctl enable nginx
```
或者
```bash
sudo /etc/init.d/nginx restart
sudo service nginx restart

```

#### 5. 查看本机ip地址

```
ip addr show venet0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```
其中venet0可能为eth0，可以通过`ip addr` 或者`ifconfig`看下。

或者可以这样：
```bash
dennis@my-remote-server:/$ curl http://icanhazip.com
xxx.xxx.xxx.xxx
```

#### 6. 检查Nginx的状态:
        ```bash
        dennis@my-remote-server:/var/www$ sudo systemctl status nginx
        ● nginx.service - A high performance web server and a reverse proxy server
           Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
           Active: active (running) since Wed 2016-08-17 14:39:33 CST; 2h 43min ago
         Main PID: 5221 (nginx)
           CGroup: /system.slice/nginx.service
                   ├─ 5221 nginx: master process /usr/sbin/nginx -g daemon on; master_process on
                   ├─15622 nginx: worker process
                   └─15623 nginx: worker process
        
        Aug 17 14:39:33 my-remote-server systemd[1]: Stopped A high performance web server and a reverse proxy server.
        Aug 17 14:39:33 my-remote-server systemd[1]: Starting A high performance web server and a reverse proxy server...
        Aug 17 14:39:33 my-remote-server systemd[1]: nginx.service: Failed to read PID from file /run/nginx.pid: Invalid argument
        Aug 17 14:39:33 my-remote-server systemd[1]: Started A high performance web server and a reverse proxy server.
        Aug 17 15:52:19 my-remote-server systemd[1]: Reloading A high performance web server and a reverse proxy server.
        Aug 17 15:52:19 my-remote-server systemd[1]: Reloaded A high performance web server and a reverse proxy server.
        Aug 17 16:34:05 my-remote-server systemd[1]: Reloading A high performance web server and a reverse proxy server.
        Aug 17 16:34:05 my-remote-server systemd[1]: Reloaded A high performance web server and a reverse proxy server.
        ```


## 安装MySQL

### 安装
```bash
sudo apt-get update
sudo apt-get install mysql-server
```

### 配置
```bash
sudo mysql_secure_installation
```

查看MySQL的版本：
```bash
mysql --version
```

### 初始化

在5.7.6以前的版本：
```bash
sudo mysql_install_db
```
5.7.6及之后的版本：
```bash
sudo mysqld --initialize
```
如果是如上面那样通过apt-get安装的，这一步通常已经被做了。因此会有如下错误提示：
```bash
 [ERROR] --initialize specified but the data directory has files in it. Aborting.
```

### MySQL的启动和停止

```bash
sudo /etc/init.d/mysql start
sudo /etc/init.d/mysql stop
sudo /etc/init.d/mysql restart
```
或者：
```bash
sudo start mysql
sudo stop mysql
sudo restart mysql
```
这种方式使用了“upstart” (其实就是/etc/init.d/mysql的软连接)。

### 测试连接

可以通过`mysqladmin -p -u root version`命令来测试一下mysql连接是否正常。

```bash
dennis@my-remote-server:/var/www/html$ mysqladmin -p -u root version
Enter password:
mysqladmin  Ver 8.42 Distrib 5.7.13, for Linux on x86_64
Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Server version		5.7.13-0ubuntu0.16.04.2
Protocol version	10
Connection		Localhost via UNIX socket
UNIX socket		/var/run/mysqld/mysqld.sock
Uptime:			19 min 14 sec

Threads: 1  Questions: 8  Slow queries: 0  Opens: 115  Flush tables: 1  Open tables: 34  Queries per second avg: 0.006
```

## 安装PHP

```bash
sudo apt-get -y install php7.0-fpm php7.0-mysql
```

### 配置PHP设置

```bash
sudo vim /etc/php/7.0/fpm/php.ini
```
打开配置文件，找到`cgi.fix_pathinfo`，修改为：
```
cgi.fix_pathinfo=0
```
然后重启php环境：
```bash
sudo systemctl restart php7.0-fpm
```

### Nginx中配置支持PHP

打开Nginx服务块配置文件：
```bash
sudo vim /etc/nginx/sites-available/default
```
修改文件为(具体修改可以参考[这里的说明](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04))：
```bash
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name server_domain_or_IP;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```
修改完保存之后可以使用`sudo nginx -t`命令确认一下配置文件的正确性。
然后使用命令`sudo systemctl reload nginx`重启Nginx。

### 测试一下

新建文件`/var/www/html/info.php`，内容如下：
```php
<?php
phpinfo();
```

然后访问 `http://server_domain_or_IP/info.php`查看结果。

# 安装Wordpress应用程序 (可选)

至此LEMP环境已经搭建完毕,下面我们简单介绍下在该环境上安装最为流行的博客程序wordpress的过程。本节仅供参考,如果不需要,可以不安装。

## 数据库及环境配置

### 创建数据库及新的数据库用户

```bash
mysql -u root -p
```
用密码登录成功之后执行下面的sql语句创建一个数据库，名叫wordpress
```sql
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
```

安全起见，我们为这个数据库创建一个单独的用户：
```sql
GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
```

#### 在外网通过IP直接访问操作数据库

默认情况下,我们只能在服务器上通过`localhost`访问MySQL,如果需要通过IP从外网访问,需要进行相应的设置。

1) 修改授权

```sql
GRANT ALL ON wordpress.* TO 'wordpressuser'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
```

如果需要,还可以指定特定的IP地址(替换上面的%即可)。

或者可以直接修改表:
```
mysql -u root -p

mysql> use mysql;

mysql> update user set host = '%' where user = 'root';

mysql> select user, host from user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| mysql.sys        | localhost |
| root             | localhost |
| wordpressuser    | %         |
+------------------+-----------+
3 rows in set (0.00 sec)
```

2) 修改配置文件

配置文件位置为`/etc/mysql/mysql.conf.d/mysqld.cnf`,注释掉其中一行:
```
# bind-address  =127.0.0.1
```

重启MySQL即可:
```
sudo service mysql restart
```

### 配置Nginx

打开配置文件：
```bash
sudo vim /etc/nginx/sites-available/default
```
作如下修改（具体可以参考[这里的说明](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-on-ubuntu-16-04)）
```bash
server {
    . . .

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt { log_not_found off; access_log off; allow all; }
    location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
        expires max;
        log_not_found off;
    }
    . . .
}
```

对try_files做如下修改：
```bash
server {
    . . .
    location / {
        #try_files $uri $uri/ =404;
        try_files $uri $uri/ /index.php$is_args$args;
    }
    . . .
}
```

然后检查配置文件的正确性，并重启Nginx：
```bash
sudo nginx -t
//If no errors were reported, reload Nginx by typing:
sudo systemctl reload nginx
```

### 安装额外的PHP扩展

```bash
sudo apt-get update
sudo apt-get install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
```
安装完之后需要重启PHP-FPM,来使新的设置生效。
```
sudo systemctl restart php7.0-fpm
```

## 安装Wordpress

### 获取并安装wordpress源码
```bash
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. /var/www/html
```
### 调整文件权限和所有权
```bash
sudo chown -R dennis:www-data /var/www/html
```
我们还需要设置setgid来使目录下新创建的文件,和父级目录具有相同的权限:
```bash
sudo find /var/www/html -type d -exec chmod g+s {} \;
```
另外还需要对一些特殊的目录做处理:
```bash
cd /var/www/html
sudo chmod g+w ./wp-content
sudo chmod -R g+w ./wp-content/themes
sudo chmod -R g+w ./wp-content/plugins
```
### 设置secure key

我们可以用wordpress官方提供的工具生成secure key:
```bash
curl -s https://api.wordpress.org/secret-key/1.1/salt/
```
运行后得到如下结果:
```php
define('AUTH_KEY',         'b?=x1eCLLa9c6f]%=8A$D^P=,y$+#)|XV2ffFo-sq8xY8M-a|6IE0_T-|!O.*Esa');
define('SECURE_AUTH_KEY',  'mF5CQ|m{(tWQQhK+_>d4UbJ5VU|], c)5^!wYbQ1WU+tBk8tFh]_<p#yZ|x;T{L%');
define('LOGGED_IN_KEY',    '(J<=P5mY3?>bqMqwk!]O=R+|]=8q^Hj/_+Dro=`-8XA[lBUQnt+Wk2MJnlC?$k&L');
define('NONCE_KEY',        'y,D2p24;-_g7-(Tu<X0HEPU:_({?JA4giAH@#<WPiVc=P%XwzB1.e|x#,l]1n2CO');
define('AUTH_SALT',        ')+fC8PF&FwD[*ux[ |YXxF-*!ds$uuy3TCzp|+-v_vt*-ox-6|A+A!]A*tJo^De=');
define('SECURE_AUTH_SALT', '4Ms!kC>.Y2*6fE+?;fE=>0BR~cB5J;C/6Sn177c(p%Q(Q6a-{I&[N,2Tn!ly.GgW');
define('LOGGED_IN_SALT',   '0nu||~mIX-++A;uS3bWde2-=A2+8=`c_(6JD_hJPf@9DiTiAu--W[wFb}+:P|[[+');
define('NONCE_SALT',       ' F=UmQao!jv(|#Di=A$Z6(l^_|z=wTnI2/P8<l7BO/IfiqX03!+hMqDa*6|hxog3');
```

拷贝到`wp-config.php`文件中替换相应的内容。

### 设置数据库信息及文件操作权限
`wp-config.php`文件中修改数据库信息,并添加`FS_METHOD`以便于Wordpress可以访问文件系统进行文件的读写操作,这在安装插件的时候会很有用。
```php
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', 'password');

define('FS_METHOD', 'direct');
```
然后我们就可以访问http://server_domain_or_IP进行wordpress的安装了。

# LEMP环境上配置多个站点

通常情况下我们需要在Web服务器上部署多个站点,使用多个不同的域名。下面将详细介绍在我们的LEMP环境上如何配置。

## 设置新的文档目录

默认情况下,在Ubuntu上的Nginx已经默认创建了一个server block,其文档目录为/var/www/html(我们在上面安装wordpress的时候使用的就是这个默认的server block)。

如果我们需要部署多个站点,那么就需要创建多个不同的server block。假如我们需要部署两个网站:
```
example.com
test.com
```
这样我们就需要设置两个新的文档目录。为统一起见,我们使用`xxx.com/html`这种目录结构形式:
```bash
sudo mkdir -p /var/www/example.com/html
sudo mkdir -p /var/www/test.com/html
```

修改一下这两个文档目录的权限:
```bash
sudo chown -R $USER:$USER /var/www/example.com/html
sudo chown -R $USER:$USER /var/www/test.com/html
```
这里用到了环境变量`$USER`,请确保没有使用root账号进行操作。
```
dennis@my-remote-server:~$ echo $USER
dennis
```
至此文档目录应该配置好了。如果需要,我们可以通过下面的命令设置一下上层目录的权限:
```bash
sudo chmod -R 755 /var/www
```

需要提醒的是,暂时不需要担心这两个测试域名是否可以访问的问题,后边我们会介绍在本地浏览器如何访问这两个测试域名。

## 为每个站点创建测试文件

创建文件`/var/www/example.com/html/index.html`,内容为:
```html
<html>
    <head>
        <title>Welcome to Example.com!</title>
    </head>
    <body>
        <h1>Success!  The example.com server block is working!</h1>
    </body>
</html>
```

同样,创建文件`/var/www/test.com/html/index.html`,内容为:
   ```html
<html>
    <head>
        <title>Welcome to Test.com!</title>
    </head>
    <body>
        <h1>Success!  The test.com server block is working!</h1>
    </body>
</html>
   ```

## 为每个站点创建server block文件

如前所述,默认情况下Nginx已经配置了一个默认的server block,因此我们可以将默认的server block配置文件拷贝过来稍作修改:
```bash
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/example.com
```
打开文件:
```bash
sudo vim /etc/nginx/sites-available/example.com
```
其内容如下:
```bash
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }
}
```

对其内容稍作修改,修改之后内容如下:
```bash
server {
        listen 80;
        listen [::]:80;

        root /var/www/example.com/html;
        index index.html index.htm index.nginx-debian.html;

        server_name example.com www.example.com;

        location / {
                try_files $uri $uri/ =404;
        }
}
```

主要修改了几个地方:
- 去掉了default_server字眼。一台服务器上只能有一个default_server的配置,因此我们保留系统最初的设置为默认设置。
- 修改root目录.
- 修改server_name.

针对第二个站点`test.com`也做类似修改。
```bash
sudo cp /etc/nginx/sites-available/example.com /etc/nginx/sites-available/test.com
sudo vim /etc/nginx/sites-available/test.com
```

## 激活两个站点的server block

使用如下命令:
```bash
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/
```

这样这些文件(链接)就位于激活的目录内了。到目前为止我们有3个激活了的server block了。服务器根据listen指令和server_name来确定该访问那个目录。

- example.com: 响应来自`example.com`以及`www.example.com`的请求
- test.com: 响应来自`test.com`以及`www.test.com`的请求
- default: 响应没有匹配到上面两个规则的80端口的请求。

另外,还需要在nginx配置文件`/etc/nginx/nginx.conf`中设置下`server_names_hash_bucket_size`:
```bash
http {
    . . .

    server_names_hash_bucket_size 64;

    . . .
}
```

然后检查下nginx配置文件的正确性:
```bash
sudo nginx -t
```
重启一下nginx使修改生效:
```bash
sudo systemctl restart nginx
```

关于Nginx更多的指令介绍可以[参考这个教程](https://www.digitalocean.com/community/tutorials/understanding-nginx-server-and-location-block-selection-algorithms)。

## 本地测试

由于`example.com`和`test.com`这两个域名并非我们真实拥有的域名,因此需要在本地机器修改下hosts来测试访问。
以Mac为例,修改`/etc/hosts`文件:
```bash
127.0.0.1   localhost
. . .

XXX.XXX.XXX.XXX example.com www.example.com
XXX.XXX.XXX.XXX test.com www.test.com
```
前面的`XXX.XXX.XXX.XXX`即为服务器的外网IP。
现在我们就可以直接访问`example.com`和`test.com`来查看这两个站点了。

Tips: 关于真实域名相关的设置,有需要可以[参考这篇文章](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-host-name-with-digitalocean).

## 配置二级子域名及代理访问

举例来说，比如我们在我的服务器上有两个web程序，一个是之前的 `example.com`，另一个程序是nodejs应用，使用端口5555，需要映射到二级域名 `demo.example.com`。我们应该如何设置呢？

### 1）添加域名解析

这个步骤不多说了，在域名服务提供商网站添加一条A记录，设置域名demo.example.com。

### 2）修改Nginx配置文件

就是我们上面提到的文件`/etc/nginx/sites-available/example.com`,添加如下内容：

```
server {  
    listen 80;
    server_name demo.example.com;

    location / {
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   Host      $http_host;
        proxy_pass         http://127.0.0.1:5555;
    }
}
```

然后重启Nginx即可。


# Ubuntu上安装和部署Node.js应用

## 安装Node.js

### 通过apt-get的方式安装

在ubuntu上可以使用apt-get安装Node.js:
```bash
sudo apt-get update
sudo apt-get install nodejs
sudo apt-get install npm
```

不过通过这种方式安装的Node.js会存在两个问题:
- nodejs的版本比较老,目前我看到的是v4.2.6。
- 在ubuntu上由于node这个名字被其他程序占用,因此要使用Node.js需要使用nodejs。
如:
```bash
dennis@my-remote-server:~$ nodejs --version
v4.2.6
```

### 通过NVM安装

NVM顾名思义就是Node.js版本管理器("Node.js version manager"),它可以让我们安装多个Node.js版本并且可以方便的随意切换。

安装NVM,首先需要安装一些依赖包:
```bash
sudo apt-get update
sudo apt-get install build-essential libssl-dev
```

然后从[NVM的Github repo](https://github.com/creationix/nvm)里拿到安装脚本。
```bash
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh -o install_nvm.sh
```
目前我看到的最新版本是0.31.4. 你可以修改为当前的最新版本。

然后执行脚本:
```bash
bash install_nvm.sh
```
该脚本会将NVM安装在`~/.nvm`目录,并且会对`~/.profile`文件做一些必要的修改,我们需要使其修改立即生效:
```bash
source ~/.profile
```

然后可以通过下面的命令查看当前可用的Node.js版本:
```bash
dennis@my-remote-server:~$ nvm ls-remote
        v5.10.0
        v5.10.1
        v5.11.0
        v5.11.1
        v5.12.0
         v6.0.0
         v6.1.0
         v6.2.0
         v6.2.1
         v6.2.2
         v6.3.0
         v6.3.1
         v6.4.0
```
最新版本为v6.4.0.
然后通过下面的命令安装最新版本:
```bash
nvm install 6.4.0
```

通常情况下,NVM会选择最近安装的版本来使用。当然我们也可以使用`nvm use 6.4.0`命令来切换版本。
可以使用命令`nvm ls`来查看当前环境已经安装的版本:
```bash
dennis@my-remote-server:~$ nvm ls
->       v6.4.0
default -> 6.4.0 (-> v6.4.0)
node -> stable (-> v6.4.0) (default)
stable -> 6.4 (-> v6.4.0) (default)
iojs -> N/A (default)
```

### 通过添加PPA的方式安装

这种方式暂时不做介绍,有兴趣可以参考[这里的教程](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04)。

## 创建一个简单的Node.js应用

我们创建一个简单的Node.js应用用于测试。新建一个文件`hello.js`:
```javascript
#!/usr/bin/env nodejs
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(8080, 'localhost');
console.log('Server running at http://localhost:8080/');
```
修改其可执行权限,并执行:
```bash
chmod +x ./hello.js
./hello.js
```
可以看到下面的提示:
```bash
Server running at http://localhost:8080/
```
说明服务启动正常,这时候可以通过http://:8080/IP_address:8080 来访问该应用。

## 使用PM2管理Node.js应用

PM2是优秀的Node.js应用管理工具,使用它可以轻松的管理服务器上的Node.js应用,并使其保持后台运行状态。

### 安装PM2

```bash
sudo npm install -g pm2
```

### 使用PM2

#### 启动Node.js应用

可以使用`pm2 start`命令启动我们刚才创建的示例应用。

```bash
dennis@my-remote-server:~$ pm2 start hello.js
[PM2] Spawning PM2 daemon
[PM2] PM2 Successfully daemonized
[PM2] Starting hello.js in fork_mode (1 instance)
[PM2] Done.
┌──────────┬────┬──────┬──────┬────────┬─────────┬────────┬─────────────┬──────────┐
│ App name │ id │ mode │ pid  │ status │ restart │ uptime │ memory      │ watching │
├──────────┼────┼──────┼──────┼────────┼─────────┼────────┼─────────────┼──────────┤
│ hello    │ 0  │ fork │ 8689 │ online │ 0       │ 0s     │ 14.566 MB   │ disabled │
└──────────┴────┴──────┴──────┴────────┴─────────┴────────┴─────────────┴──────────┘
 Use `pm2 show <id|name>` to get more details about an app
dennis@my-remote-server:~$
```

#### 设置服务器重启自动启动应用

比较值得一提的是,通过PM2启动的应用如果发生crash或者被其他程序杀掉了,会自动重新启动。但是需要注意的是,还需要做一点额外的工作,以便在系统重启之后也可以正常的将你的应用程序启动起来。这就是`startup`命令的作用了:

```bash
dennis@my-remote-server:~$ pm2 startup systemd
[PM2] You have to run this command as root. Execute the following command:
      sudo su -c "env PATH=$PATH:/home/dennis/.nvm/versions/node/v6.4.0/bin pm2 startup systemd -u dennis --hp /home/dennis"
```

执行之后会看到最后一行,是一条命令:
```bash
sudo su -c "env PATH=$PATH:/home/dennis/.nvm/versions/node/v6.4.0/bin pm2 startup systemd -u dennis --hp /home/dennis"
```
运行一下。成功之后我们可以通过命令`sudo systemctl status pm2`查看一下状态:
```bash
dennis@my-remote-server:~$ sudo systemctl status pm2
● pm2.service - PM2 next gen process manager for Node.js
   Loaded: loaded (/etc/systemd/system/pm2.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2016-08-19 12:02:46 CST; 3min 9s ago
  Process: 10726 ExecStart=/usr/local/lib/node_modules/pm2/bin/pm2 resurrect (code=exited, status=0/SUCCESS)
 Main PID: 10732 (PM2 v1.1.3: God)
   CGroup: /system.slice/pm2.service
           ├─10732 PM2 v1.1.3: God Daemon
           └─10742 node /home/dennis/hello.js

Aug 19 12:02:46 my-remote-server pm2[10726]: [PM2] Resurrecting
Aug 19 12:02:46 my-remote-server pm2[10726]: [PM2] Restoring processes located in /home/dennis/.pm2/dump.pm2
Aug 19 12:02:46 my-remote-server pm2[10726]: [PM2] Process /home/dennis/hello.js restored
Aug 19 12:02:46 my-remote-server pm2[10726]: ┌──────────┬────┬──────┬───────┬────────┬─────────┬────────┬─────────────┬──────────┐
Aug 19 12:02:46 my-remote-server pm2[10726]: │ App name │ id │ mode │ pid   │ status │ restart │ uptime │ memory      │ watching │
Aug 19 12:02:46 my-remote-server pm2[10726]: ├──────────┼────┼──────┼───────┼────────┼─────────┼────────┼─────────────┼──────────┤
Aug 19 12:02:46 my-remote-server pm2[10726]: │ hello    │ 0  │ fork │ 10742 │ online │ 0       │ 0s     │ 14.566 MB   │ disabled │
Aug 19 12:02:46 my-remote-server pm2[10726]: └──────────┴────┴──────┴───────┴────────┴─────────┴────────┴─────────────┴──────────┘
Aug 19 12:02:46 my-remote-server pm2[10726]:  Use `pm2 show <id|name>` to get more details about an app
Aug 19 12:02:46 my-remote-server systemd[1]: Started PM2 next gen process manager for Node.js.
dennis@my-remote-server:~$
```

关于`systemctl`命令,强烈建议[看下这个教程](https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal)。

#### 踩坑提醒

如果出现下面的错误:
```bash
dennis@my-remote-server:~$ sudo su -c "env PATH=$PATH:/home/dennis/.nvm/versions/node/v6.4.0/bin pm2 startup systemd -u dennis --hp /home/dennis"
[PM2] Generating system init script in /etc/systemd/system/pm2.service
[PM2] Making script booting at startup...
[PM2] -systemd- Using the command:
      su dennis -c "pm2 dump && pm2 kill" && su root -c "systemctl daemon-reload && systemctl enable pm2 && systemctl start pm2"
Command failed: su dennis -c "pm2 dump && pm2 kill" && su root -c "systemctl daemon-reload && systemctl enable pm2 && systemctl start pm2"
/usr/bin/env: 'node': No such file or directory

----- Are you sure you use the right platform command line option ? centos / redhat, amazon, ubuntu, gentoo, systemd or darwin?
```
则可能是因为我们的node是使用nvm安装的原因。为/usr/bin/node添加一个软连接即可。
```
sudo ln -s  /home/dennis/.nvm/versions/node/v6.4.0/bin/node /usr/bin/node
```

#### PM2常用命令

##### 停止应用
```bash
pm2 stop app_name_or_id
```
##### 重启应用
```bash
pm2 restart app_name_or_id
```
##### 列举应用
```bash
pm2 list
```
##### 查看应用详情
```bash
pm2 info example
```
##### 监控应用
```bash
pm2 monit
```

## 使用Nginx作Node.js应用程序的反向代理

### 创建Node.js应用程序

我们已经有了一个`hello.js`应用,于此类似,再创建一个`foo.js`的应用。创建文件`foo.js`,代码如下:
```javascript
#!/usr/bin/env nodejs
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Foo Bar\n');
}).listen(8081, 'localhost');
console.log('Server running at http://localhost:8081/');
```
监听端口8081. 启动该应用程序:
```bash
pm2 start foo.js
```
这个时候我们看到已经有两个Node.js应用在运行了:
```bash
dennis@my-remote-server:~$ pm2 list
┌──────────┬────┬──────┬───────┬────────┬─────────┬────────┬─────────────┬──────────┐
│ App name │ id │ mode │ pid   │ status │ restart │ uptime │ memory      │ watching │
├──────────┼────┼──────┼───────┼────────┼─────────┼────────┼─────────────┼──────────┤
│ hello    │ 0  │ fork │ 10742 │ online │ 0       │ 46m    │ 21.570 MB   │ disabled │
│ foo      │ 1  │ fork │ 10897 │ online │ 0       │ 8s     │ 20.051 MB   │ disabled │
└──────────┴────┴──────┴───────┴────────┴─────────┴────────┴─────────────┴──────────┘
 Use `pm2 show <id|name>` to get more details about an app
```

### 设置Nginx

前面我们讲过,Nginx的默认配置文件为/etc/nginx/sites-available/default。我们新建了两个站点,分别对应下面的配置文件:
```bash
/etc/nginx/sites-available/example.com
/etc/nginx/sites-available/test.com
```

这里我们可以修改默认的配置,也可以选择修改任意一个域名的配置。我们就以`example.com`为例。
将`/etc/nginx/sites-available/example.com`文件的内容全部删除,并修改内容为:

```bash
server {
    listen 80;

    server_name example.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
重新加载一下Nginx的配置使其生效:
```bash
sudo systemctl restart nginx
```
简单解释一下,这个配置的作用就是,监听服务器的80端口,并反向代理到8080端口去,也就是我们的`hello`应用。也就是说当用户通过浏览器访问`http://example.com/`的时候,将会将用户请求发给我们的`hello.js`应用,就会在页面上显示"Hello World"字样。

### 多应用设置

如果需要设置对多个Node.js应用的访问,我们可以在Nginx中增加响应的配置即可。以上面创建的`foo.js`应用为例:
```bash
location /app2 {
        proxy_pass http://localhost:8081;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
```
使用命令`sudo systemctl restart nginx`重启nginx之后,就可以通过访问`http://example.com/app2`来查看`foo.js`应用的结果"Foo Bar"了。


# 写在最后

本文只是简单的带着大家配置一台可用的Web服务器,但是必然会有很多知识点没有涉及到。这就需要我们在碰到问题的时候多去Google了。比如下面的Topic,有兴趣的可以自行研究下。

1. Linux/Ubuntu上的一键安装包,有些比较好用,比如[lemp-wordpress-stack](https://github.com/mirzazeyrek/lemp-wordpress-stack).
2. Ubuntu上Docker的安装与使用
3. 使用Let's Encrypt进行全站HTTPS(可以[参考这篇文章](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-16-04))
4. 科学上网:ubuntu 16.04服务器上搭建Shadowsocks服务(如果大家感兴趣,后边再讲)
5. 同时使用apache和nginx,可以[参考这篇文章](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-as-a-web-server-and-reverse-proxy-for-apache-on-one-ubuntu-16-04-server)。

## Reference:

[how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04)
[how-to-edit-the-sudoers-file-on-ubuntu-and-centos](https://www.digitalocean.com/community/tutorials/how-to-edit-the-sudoers-file-on-ubuntu-and-centos)
[how-to-set-up-a-host-name-with-digitalocean](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-host-name-with-digitalocean)
[how-to-host-multiple-websites-securely-with-nginx-and-php-fpm-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-host-multiple-websites-securely-with-nginx-and-php-fpm-on-ubuntu-14-04)
[how-to-configure-nginx-as-a-web-server-and-reverse-proxy-for-apache-on-one-ubuntu-16-04-server](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-as-a-web-server-and-reverse-proxy-for-apache-on-one-ubuntu-16-04-server)
[how-to-install-nginx-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04)
[how-to-install-node-js-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04)
[systemd-essentials-working-with-services-units-and-the-journal](https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal)
[how-to-install-and-secure-phpmyadmin-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-16-04)
[how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04)
[lemp-stack-monitoring-with-monit-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/lemp-stack-monitoring-with-monit-on-ubuntu-14-04)
[how-to-install-laravel-with-an-nginx-web-server-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-install-laravel-with-an-nginx-web-server-on-ubuntu-14-04)
[how-to-secure-nginx-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-on-ubuntu-14-04)












