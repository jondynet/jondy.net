Title: Mac OSX 安装mactelnet客户端
Date: 2016-12-13 13:37:05
Category: RouterOS
Tags: RouterOS
Slug: mac-telnet-on-osx
Authors: zhangdi
Summary: Mac OSX下mactelnet的安装使用

```
git clone https://github.com/haakonnessjoen/MAC-Telnet.git
```

MAC-Telnet$ ./autogen.sh 
./autogen.sh: line 2: aclocal: command not found
./autogen.sh: line 5: autoconf: command not found

```
brew install autoconf
brew install automake
export PATH=/usr/local/opt/gettext/bin:$PATH

make all install
```

MAC-Telnet$ mndp 
Searching for MikroTik routers... Abort with CTRL+C.

IP              MAC-Address       Identity (platform version hardware) uptime
10.5.50.1       4c:5e:c:4c:51:40  yf (Doublecom 6.35.4 (stable) RB912UAG-2HPnD)
up 3 days 2 hours  5PVZ-MYY1 bridge1
^C

$ mactelnet 0:c:42:43:58:a5 -u admin
Password: 
Connecting to 0:c:42:43:58:a5...done

$ macping 0:c:42:43:58:a5
