---
title: 用ffmpeg命令行将图片转为JPEG XL
author: zzidun
date: 2024-03-22
tags: 软件技巧
---

多的就不说了, 直接上命令:

```
ffmpeg -i input.jpg output.jxl
```

还可以设置转换的质量(下面那个`90`就是保留百分之多少画质的意思)

```
ffmpeg -i input.jpg -q:v 90 output.jxl
```

# jpeg xl介绍

JPEG XL 是一种自由的图像文件格式, 支持有损和无损压缩(下面简称jxl).

他在保留高画质的情况下, 能够把文件压缩得比jpeg还小.

他的对手是webp2(注意是2哦)和avif.

jxl, webp2, avif被认为是下一代的压缩文件格式.

这三者中:

avif技术源自H.165, 他是有专利的(你懂的).

webp2, 我反正不知道什么时候能诞生.

我们似乎没有不选jxl的理由.

[详细对比见此](https://moonvy.com/blog/post/2022/next-generation-Image-format-2022/)

## 转折

然而, google粉墨登场.

google见自己想要推广的avif和webp2好像无法压过jxl,

便声称"jxl不是生态环境想要的", 并移除了chrome对于jxl的支持.

打不过就封锁, 这就是google.

但是, 将军勿虑, 请看此文[在Firefox和Safari使用jxl](/posts/如何启用网页上的JPEG-XL图片.html)

## 但是, 我支持jxl

所以, 本博客的所有无需无损显示的图片都会使用jxl格式.
