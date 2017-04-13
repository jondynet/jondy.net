Title: ARP 攻击检测脚本
Date: 2016-09-09 01:01
Modified: 2016-09-12 10:10:22
Category: RouterOS
Tags: RouterOS, h4ck, ARP
Slug: arp-attack-defense
Authors: zhangdi
Summary: ARP 攻击检测脚本

ARP攻击历史悠久，危害大，并且至今流行着。

前几天同事下载了个kali在内网搞arp攻击，我们的内网很开放，没有限速也没有任何的防御措施。
同事是新手，所以并没有完全掌握arp攻击的正确姿势，使得我们的网络变得很慢很不稳定，
因此很容易就被发现了吊打。

领导们并不想对内网作任何的限制和保护，这样就只能自己保护自己了。
平时我在OS X下敲代码，OS X自带一个很好的东东`say`，TTS的东西，可以让电脑说话。
所以很方便作语音提醒，于是我先写了个脚本当受到ARP攻击的时候提示我。

```bash
#!/bin/sh                                                                                                               

MACADDR=`/usr/sbin/arp -n 192.168.31.1 | awk '/192.168.31.1/ {print $4}'`
NOW=`date "+%Y-%m-%d %H:%M:%S"`

if [ "$MACADDR" != "38:e3:c5:a8:57:4a" ];then
  echo $NOW $MACADDR >> /tmp/arp.log
  say arp attack
fi
```

当受到ARP攻击的时候语音提示我，但如果我不在公司有人作arp攻击我就不知道了，
于是注释掉`say arp attack`这段OS X独有的东东，将这段代码放24小时开机的测试服务器上。
起个定时任务，每分钟检测一下告诉我是否受到攻击。

这之后我想有没有更容易实现的方式，最好能做到Mikrotik RouterOS里。

在RouterOS中创建定时脚本来监控自己的MAC地址变化。

### 静态的处理

```
:global oldmac 00:00:00:AA:BB:CC
:global newmac [/ip arp get [/ip arp find address=192.168.0.1] mac-address]
:if ($newmac != $oldmac) do={:log info "mac change"}
```

### 动态的处理
```
:global oldmac
:global newmac [/ip arp get [/ip arp find address=192.168.0.1] mac-address]
:if ($newmac != $oldmac) do={:log info "mac change";:set oldmac $newmac}
```
