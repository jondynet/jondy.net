Title: athores9344板子openwrt开发笔记
Date: 2016-11-21 16:04
Category: Debian
Tags: openwrt
Slug: openwrt-athores9344
Authors: zhangdi
Summary: 一些OpenWRT的工作记录

#编译环境

kali linux 2016

基本依赖
```
apt-get install build-essential libncurses5-dev gawk git subversion libssl-dev gettext unzip zlib1g-dev file python
```

更新软件包，编译一发

```
cd openwrt
./scripts/feeds update -a

make menuconfig (most likely you would like to use this)
make defconfig
make prereq
```

有些软件包的安装如 netfd 需要翻墙，先安装 proxychains

安装自定义软件包
```
./scripts/feeds update custom
./scripts/feeds install -p custom -a
```

增加profile
修改image

# 解决编译问题

Makefile:1: *** missing separator.  Stop.

我的vim设置了空格替换TAB，修改makefile经常报错啊，先改了vim

在.vimrc中添加以下代码后，重启vim即可实现按TAB产生4个空格：
set ts=4  (注：ts是tabstop的缩写，设TAB宽4个空格)
set expandtab

对于已保存的文件，可以使用下面的方法进行空格和TAB的替换：
TAB替换为空格：
:set ts=4
:set expandtab
:%retab!

空格替换为TAB：
:set ts=4
:set noexpandtab
:%retab!

加!是用于处理非空白字符之后的TAB，即所有的TAB，若不加!，则只处理行首的TAB。

#解决libc和libpcap找不到的问题。

/root/openwrt_05/build_dir/target-mips_34kc_uClibc-0.9.33.2/dbtz-v6


staging_dir/target-386_i486_uClibc-0.9.33.2/pkginfo/*

libc.provides 增加相应的文件

libpcap.so.0.8
libc.so.6
