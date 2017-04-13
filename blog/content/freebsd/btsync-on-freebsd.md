Title: Freebsd下使用btsync同步数据
Date: 2016-11-12 13:37:05
Category: FreeBSD
Tags: FreeBSD
Slug: btsync-in-freebsd
Authors: zhangdi
Summary: Freebsd下btsync的安装使用

### 安装

net-p2p/btsync includes an RC script:
/usr/local/etc/rc.d/btsync

TO START ON BOOT:
# echo 'btsync_enable="YES"' >> /etc/rc.conf

START MANUALLY:
# service btsync start

Once started, visit the following to configure:
http://localhost:8888/

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

===> SECURITY REPORT: 
      This port has installed the following files which may act as network
      servers and may therefore pose a remote security risk to the system.
/usr/local/bin/btsync

      This port has installed the following startup scripts which may cause
      these network services to be started at boot time.
/usr/local/etc/rc.d/btsync

      If there are vulnerabilities in these programs there may be a security
      risk to the system. FreeBSD makes no guarantee about the security of
      ports included in the Ports Collection. Please type 'make deinstall'
      to deinstall the port if this is a concern.

      For more information, and contact details about the security
      status of this software, see the following webpage: 
http://www.bittorrent.com/sync

