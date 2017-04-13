Title: 我遇到的Debian服务器常见问题汇总
Date: 2015-08-28 16:04
Category: Debian
Tags: debian
Slug: debian-faq
Authors: zhangdi
Summary: 一些debian环境的问题汇总

### apt-get

apt-get update 更新时提示There is no public key available for the following key IDs
```
Reading package lists... Done
W: There is no public key available for the following key IDs:
9D6D8F6BC857C906
W: There is no public key available for the following key IDs:
7638D0442B90D010
```

修复
```bash
$ sudo apt-get install debian-archive-keyring
$ sudo apt-key update
```

### locales 问题

表现，登录提示warning
```
Last login: Wed Nov  2 16:27:13 2016 from 192.168.88.252
-bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
-bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
-bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
```

修复
```bash
apt-get install locales
dpkg-reconfigure locales
```

### pip 软件包安装超时，需要使用国内镜像

* http://pypi.douban.com/  豆瓣
* http://pypi.hustunique.com/  华中理工大学
* http://pypi.sdutlinux.org/  山东理工大学
* http://pypi.mirrors.ustc.edu.cn/  中国科学技术大学

解决
```bash
cat > ~/.pip/pip.conf
[global]
index-url = http://pypi.douban.com/simple
^D
```

### 让ipv4优先于ipv6

W: Failed to fetch http://ftp.cn.debian.org/debian/dists/jessie-updates/Release.gpg  Cannot initiate the connection to ftp.cn.debian.org:80 (2001:da8:d800:95::110). - connect (101: Network is unreachable) [IP: 2001:da8:d800:95::110 80]

解决
```bash
echo "precedence ::ffff:0:0/96 100">>/etc/gai.conf
```

### ssd允许root远程登录及加速ssh登录

```bash
vim /etc/ssh/sshd_config
PermitRootLogin yes
UseDNS no
```
