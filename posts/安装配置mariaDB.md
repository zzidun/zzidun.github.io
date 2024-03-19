---
title: 安装配置mariaDB
author: zzidun
date: 2021-12-25
category: 软件技巧
---

# 安装

输入以下命令安装mariadb

```shell
sudo apt-get install mariadb-server mariadb-client
```

输入以下命令启动mariadb

```shell
sudo systemctl start mariadb
```

# 配置

## 设置系统的root帐号的密码

一开始登录mysql需要用root用户登录

deepin默认root密码为空,需要先输入以下命令设置root用户密码

```shell
sudo passwd
```

## 登录mysql

切换到root用户

```shell
su root
```

首先设置mysql密码,在root下输入这个命令,会让输入新密码并确认.

```shell
mysql_secure_installation
```

登录使用命令`mysql -u<用户名> -p<密码>`,这里是mysql的用户,不是linux系统的用户.

现在只有root用户,所以登录root.注意`-u`和用户名之间没有空格,`-p`和密码之间没有空格.

```shell
mysql -uroot -p<密码>
```

## 添加新用户并授权

首先打开`mysql`数据库.

```sql
use mysql;
```

查询目前的用户表.

可以发现只有root用户,密码显示的是一串经过加密的代码,host是允许用户从哪个ip登录.

```sql
select host,user,password from user;
```

我们假设已经创建了想要的数据库,比如这样

```sql
CREATE DATABASE vforum;
```

可以设置允许哪个用户从哪些ip登录,使用什么密码,有什么权限,访问哪些数据库数据表.

```sql
GRANT <权限> ON <数据库>.<数据表> to '<用户>'@'<登录ip>' IDENTIFIED BY '<密码>' WITH GRANT OPTION;
```

比如,如果我们创建一个用户`asd`,

密码为`asdasd0`,

允许从任意ip登录,也就是ip填上通配符`%`,

允许说有权限,也就是`ALL`,

允许访问数据库`vforum`中的所有表,也就是`vforum.*`

那么命令如下:

```sql
GRANT ALL ON vforum.* to 'asd'@'%' IDENTIFIED BY 'asdasd0' WITH GRANT OPTION;
```

最后刷新权限

```shell
FLUSH privileges;
```
