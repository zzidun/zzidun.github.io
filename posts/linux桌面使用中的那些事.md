---
title: linux桌面使用中那些事
author: zzidun
date: 2021-12-28
tags: 软件技巧
---

# 使用光驱刻录光盘

```
wodim -sao -v -speed=1 dev=/dev/<光盘设备> <iso文件>
```

# 一些系统的分区方式备忘

不要分配swap分区, 要调整大小太特么麻烦了.

我们可以在主分区创建一个交换文件作为交换分区, 大小还可以随时调整, 效果完全一样的.

## archlinux

| 挂载目录 | 文件系统 | 大小 |
| --- | --- | --- |
| ` /boot` | FAT32 | 500M |
| `/` | EXT4 | 剩余全部 |

## deepin

| 挂载目录 | 文件系统 | 大小 |
| --- | --- | --- |
| ` /boot/efi` | FAT32 | 100M |
| `/` | EXT4 | 剩余全部 |

# 制作快捷方式

当我们有一个可执行文件,希望能够在开始菜单直接打开他.

首先可以编写一个文件`<文件名>.desktop`,来制作快捷方式.

```shell
[Desktop Entry]
Exec=<可执行文件地址>
Name=<快捷方式显示的名称>
Icon=<网上找的图标.svg>
Type=Application
```

以上都是绝对路径,比如

```shell
[Desktop Entry]
Name=Uengine
Exec=/home/zzidun/app/uengine/uengine.sh
Icon=/home/zzidun/app/uengine/anbox.svg
Type=Application
```

复制到`/usr/share/applications`目录即可.

```shell
sudo cp <xxx.desktop> /usr/share/application/
```

# apt install XXX- 导致秦麻爆炸

千万谨慎,不要在安装命令后面多写一个横杆`-`,这代表卸载.

某一次我想要看看软件源提供了哪些版本的`gcc`,于是输入了`sudo apt install gcc-`,然后按`tab`查看列出的软件包.

这时候列出的软件包列表是用回车翻页的,我一直按回车,没想到多按了几个.

然后就变成执行了`sudo apt install gcc-`,一堆软件被卸载了,我人也裂开了.

# git设置

```shell
git config --global user.email "<邮箱>"
git config --global user.name "<用户名>"
git config --global http.postBuffer 10000M
```

# go

```shell
wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
```

然后修改文件`~/.bashrc`

加上这一句
```shell
export PATH=$PATH:/usr/local/go/bin
```

然后
```shell
source ~/.bashrc
```

检查是否安装完成

```shell
go version
```

# qbittorent增强版

可以防止迅雷吸血.

迅雷得到网上其他bt软件的用户分享的资源,却不给别人分享.

这样自私自利的软件需要我们一起抵制.

下面命令安装的版本,可以禁止向迅雷,qq等吸血软件分享.

```cpp
sudo add-apt-repository ppa:poplite/qbittorrent-enhanced
sudo apt-get update
sudo apt install qbittorrent-enhanced
```

`工具->首选项->高级->上传连接策略->反吸血`
