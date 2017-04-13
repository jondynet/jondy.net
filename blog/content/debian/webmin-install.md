Title: Debian 服务器安装webmin管理
Date: 2016-11-08 14:04
Category: Debian
Tags: debian
Slug: debian-webmin
Authors: zhangdi
Summary: 使用webmin通过网页管理debian服务器

最近写了个RouterOS设备的管理工具，通过web来实时显示
ROS无线设备的运行状态，离线报警和生成拓扑图。

项目最终安装在一台x86的工控机里，在客户那安装就比较麻烦，
安装的技术人员需要懂linux系统的人来进行工控机的基本网络配置。

我也尝试在项目里集成基本的linux网络配置，但是还是很麻烦的，
网卡除了配置dhcp客户端或静态地址之外，还有可能需要配置为dhcp服务端或者支持
PPPoE或者pptp和l2tp的客户端。除此之外，还有几个网卡需要提供VPN的服务端。

于是我打算找一款现成的工具来干这个事，一番搜索之后发现了webmin，
看起来是能满足我的这些需求呢，动手安装起来。

编辑 /etc/apt/sources.list 文件，在最末尾添加以下内容：

vi /etc/apt/sources.list
```
deb http://download.webmin.com/download/repository sarge contrib
deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib
```
安装 GPG key

```
cd /root
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
```
再执行安装
```
apt-get update
apt-get install webmin
```

默认端口10000，关了对外的开放，拿nginx反向代理了，在项目里加个链接过去就可以了。

