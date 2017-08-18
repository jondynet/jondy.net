Title: openwrt 备忘笔记
Date: 2017-08-17 11:11
Modified: 2017-08-17 11:11:28
Category: reference
Tags: openwrt
Slug: openwrt-reference
Authors: zhangdi
Summary: openwrt 备忘笔记

set FORCE_UNSAFE_CONFIGURE=1
checking whether mknod can create fifo without rootprivileges... configure:
error: in `/home/openwrt/build_dir/host/tar-1.28':

configure: error: you should not run configure as root(set
FORCE_UNSAFE_CONFIGURE=1 in environment to bypass this check)

See `config.log' for more details

解决1：

ExportFORCE_UNSAFE_CONFIGURE=1

Export FORCE=1

解决2：

修改 include/prereq-build.mk。最新的版本已去掉这个限制。

 

  http://netfilter.org/projects/libmnl/

   这是一个重要的组织，配置openwrt时，经常找不到的lib，就在这个网站上面下载。


### 缺文件

http://downloads.openwrt.org/sources/pkg-config-0.29.tar.gz
Resolving downloads.openwrt.org (downloads.openwrt.org)... 78.24.191.177
Connecting to downloads.openwrt.org
(downloads.openwrt.org)|78.24.191.177|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
2015-12-09 15:41:37 ERROR 404: Not Found.

去http://pkgconfig.freedesktop.org/releases/
下载对应版本的源码，放入openwrt/dl/

#mtd-utils 下载太慢

用proxychains翻墙了搞

