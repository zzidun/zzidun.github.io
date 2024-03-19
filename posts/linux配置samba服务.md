---
title: linux配置samba服务
author: zzidun
date: 2022-01-27
tags: 软件技巧
---

# 安装samba

```shell
sudo apt install samba
```

# 添加samba用户

我反正是懒得创建新用户了, 直接把自己在用的用户设置成了samba用户.

直接输入`smbpasswd`命令, 即将当前用户设置为samba用户,, 并且设置samba密码.

你也可以使用`sudo smbpasswd -a <用户名>`来指定一个用户, 并且为其设置samba密码.

(只能指定已经存在的用户, 你可以先用`useradd`创建一个).

# 最简配置文件

配置文件格式形如

```
[段落名]
  内容
  ...

[段落名]
  内容
  ...
...
```

## 全局设置

`[global]`段是全局设置.

你可以直接拷贝以下内容(是的我也看不懂)

```
[global]
    dns proxy = No
    map to guest = Bad User
    netbios name = ARCH LINUX
    security = USER
    server role = standalone server
```

## 文件夹设置

每个`[共享项目名称]`描述了一个共享文件夹的设置.

也就是你每需要设置一个共享文件夹, 就在这里加一段描述.

例如
```
# 别人访问samba将会看到这个文件夹名<home>
[home]
    # 文件夹的路径
    path = /home/zzidun/
    # 是否只读
    read only = No
    # 具有写入权限的用户()
    write list = @zzidun
```


## 我的完整配置文件

```shell
[global]
    dns proxy = No
    map to guest = Bad User
    netbios name = ARCH LINUX
    security = USER
    server role = standalone server

[home]
    path = /home/zzidun/
    read only = No
    write list = @zzidun
```

# 启动服务

对于`archlinux`, 使用以下命令:

```shell
sudo systemctl enable samba
sudo systemctl enable smb.service

```

之后就可以在局域网内的各个设备通过`ip`访问这个文件夹.
