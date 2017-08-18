Title: iptables 备忘笔记
Date: 2017-08-17 11:33:10
Category: Reference
Tags: iptables
Slug: iptables-reference
Authors: zhangdi
Summary: iptables的一些技巧笔记备忘

1、iptables -L

查看filter表的iptables规则，包括所有的链。filter表包含INPUT、OUTPUT、FORWARD三个规则链。

说明：-L是--list的简写，作用是列出规则。

2、iptables -L [-t 表名]

只查看某个表的中的规则。

说明：表名一个有三个：filter,nat,mangle，如果没有指定表名，则默认查看filter表的规则列表（就相当于第一条命令）。

举例：iptables -L -t filter

3、iptables -L [-t 表名] [链名]

这里多了个链名，就是规则链的名称。

说明：iptables一共有INPUT、OUTPUT、FORWARD、PREROUTING、POSTROUTING五个规则链。

举例：iptables -L INPUT

注意：链名必须大写。在Linux系统上，命令的大小写很敏感。

4、iptables -n -L

说明：以数字形式显示规则。如果没有-n，规则中可能会出现anywhere，有了-n，它会变成0.0.0.0/0

5、iptables -nv -L

说明：你也可以使用“iptables -L

-nv”来查看，这个列表看起来更详细，对技术人员更友好，呵呵。
如果想删除iptables规则我们可以如下操作
删除用-D参数
删除之前添加的规则（iptables -A INPUT -s 192.168.1.5 -j DROP）：

[root@test ~]# iptables -D INPUT -s 192.168.1.5 -j

DROP有时候要删除的规则太长，删除时要写一大串，既浪费时间又容易写错，这时我们可以先使用–line-number找出该条规则的行号，再通过行号删除规则。

```
[root@test ~]# iptables -nv --line-number

iptables v1.4.7: no command specified
Try `iptables -h' or 'iptables --help' for more information.
[root@test ~]# iptables -nL --line-number
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination
1    DROP       all  --  192.168.1.1          0.0.0.0/0
2    DROP       all  --  192.168.1.2          0.0.0.0/0
3    DROP       all  --  192.168.1.3          0.0.0.0/0
删除第二行规则
[root@test ~]# iptables -D INPUT 2

iptables -A INPUT -s 116.237.145.17 -j ACCEPT 
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -j DROP
```

设置只允许指定ip地址访问指定端口 

```
iptables -A INPUT  -s xxx.xxx.xxx.xxx -p tcp --dport 3306 -j ACCEPT 
iptables -A OUTPUT -d xxx.xxx.xxx.xxx -p tcp --sport 3306 -j ACCEPT 
```

上面这两条，请注意--dport为目标端口，当数据从外部进入服务器为目标端口；反之，数据从服务器出去则为数据源端口，使用
--sport 

同理，-s是指定源地址，-d是指定目标地址。 

然后，关闭所有的端口 

```
iptables -P INPUT DROP 
iptables -P OUTPUT DROP 
iptables -P FORWARD DROP 
```

最后，保存当前规则 

```
/etc/rc.d/init.d/iptables save 
service iptables restart 
```

linux iptables设置仅22、80端口可访问
 
通过命令 netstat -tnl 可以查看当前服务器打开了哪些端口 

```
netstat -tnl  
```

查看防火墙设置 

```
iptables -L -n   
```

开放22、80端口 

```
iptables -A INPUT -p tcp --dport 22 -j ACCEPT  
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT  
iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT  
iptables -A OUTPUT -p tcp --sport 80 -m state --state NEW,ESTABLISHED -j ACCEPT  
```

取消其他端口的访问规则 

```
iptables -P INPUT DROP  
iptables -P FORWARD DROP  
iptables -P OUTPUT DROP  
```

允许本地回环接口(即允许本机访问本机) 

```
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT  
```

允许已建立的或相关连的通行（如数据库链接） 

```
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
```

允许所有本机向外的访问 

```
iptables -A OUTPUT -j ACCEPT  
```

保存配置： 

```
service iptables save
```

