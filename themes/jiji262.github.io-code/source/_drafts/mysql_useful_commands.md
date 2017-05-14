#MySQL 常用操作

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

或者：
```bash
sudo service mysql start
sudo service mysql stop
sudo service mysql restart
```

### 测试连接

可以通过`mysqladmin -p -u root version`命令来测试一下mysql连接是否正常。

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
GRANT ALL ON wordpress.* TO 'XXXXUSER'@'localhost' IDENTIFIED BY 'XXXXPASSWORD';
FLUSH PRIVILEGES;
EXIT;
```

需要替换上面的XXXXUSER和XXXXPASSWORD。

### 在外网通过IP直接访问操作数据库

默认情况下,我们只能在服务器上通过`localhost`访问MySQL,如果需要通过IP从外网访问,需要进行相应的设置。

1) 修改授权

```sql
GRANT ALL ON wordpress.* TO 'XXXXUSER'@'%' IDENTIFIED BY 'XXXXPASSWORD';
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