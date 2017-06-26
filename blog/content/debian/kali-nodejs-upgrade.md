Title: Kali2017升级node.js v8.x
Date: 2017-06-26 17:34
Category: Kali
Tags: debian,Kali,nodejs
Slug: kali-nodejs-upgrade
Authors: zhangdi
Summary: Kali linux 2017升级nodejs的正确姿势


最近在Kali下作开发，发现自带的nodejs的版本是v4.8.2
开发环境需要升级到8.x的版本，整理了一下升级的方式。

```
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs

```

修改setup_后边的版本号即可升级到任意版本


附上Kali 2017升级nodejs到8.x的升级log 

```
root@kali:~# curl -sL https://deb.nodesource.com/setup_8.x | bash -

## Installing the NodeSource Node.js v8.x repo...


## Populating apt-get cache...

+ apt-get update
Get:1 http://mirrors.neusoft.edu.cn/kali kali-rolling InRelease [30.5 kB]
Get:2 http://mirrors.neusoft.edu.cn/kali kali-rolling/main amd64 Packages [15.5 MB]
Fetched 15.5 MB in 18s (820 kB/s)                                              
Reading package lists... Done

## You seem to be using Kali version kali-rolling.
## This maps to Debian "jessie"... Adjusting for you...

## Confirming "jessie" is supported...

+ curl -sLf -o /dev/null 'https://deb.nodesource.com/node_8.x/dists/jessie/Release'

## Adding the NodeSource signing key to your keyring...

+ curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
OK

## Creating apt sources list file for the NodeSource Node.js v8.x repo...

+ echo 'deb https://deb.nodesource.com/node_8.x jessie main' > /etc/apt/sources.list.d/nodesource.list
+ echo 'deb-src https://deb.nodesource.com/node_8.x jessie main' >> /etc/apt/sources.list.d/nodesource.list

## Running `apt-get update` for you...

+ apt-get update
Hit:1 http://mirrors.neusoft.edu.cn/kali kali-rolling InRelease
Get:2 https://deb.nodesource.com/node_8.x jessie InRelease [4,634 B]
Get:3 https://deb.nodesource.com/node_8.x jessie/main Sources [762 B]
Get:4 https://deb.nodesource.com/node_8.x jessie/main amd64 Packages [972 B]
Fetched 6,368 B in 2s (2,410 B/s)
Reading package lists... Done

## Run `apt-get install nodejs` (as root) to install Node.js v8.x and npm

root@kali:~# apt-get install nodejs
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following package was automatically installed and is no longer required:
  libuv1
Use 'apt autoremove' to remove it.
The following packages will be upgraded:
  nodejs
1 upgraded, 0 newly installed, 0 to remove and 17 not upgraded.
Need to get 12.7 MB of archives.
After this operation, 50.6 MB of additional disk space will be used.
Get:1 https://deb.nodesource.com/node_8.x jessie/main amd64 nodejs amd64 8.1.2-1nodesource1~jessie1 [12.7 MB]
Fetched 12.7 MB in 5s (2,466 kB/s) 
Reading changelogs... Done
(Reading database ... 314474 files and directories currently installed.)
Preparing to unpack .../nodejs_8.1.2-1nodesource1~jessie1_amd64.deb ...
Unpacking nodejs (8.1.2-1nodesource1~jessie1) over (4.8.2~dfsg-1) ...
Setting up nodejs (8.1.2-1nodesource1~jessie1) ...
Processing triggers for man-db (2.7.6.1-2) ...
root@kali:~# nodejs -v
v8.1.2
root@kali:~# 
```
