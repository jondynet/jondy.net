Title: OS X中文语音text to speech安装设置
Date: 2017-08-18 08:08
Modified: 2017-08-18 09:09:56
Category: OSX
Tags: text-to-speech
Slug: osx-text-to-speech
Authors: zhangdi
Summary: OS X中文语音text to speech安装设置


OS X命令行say命令可以直接播报语音，默认是英文的。

之前写过一个本机的监控脚本当发现问题的时候记录log同时播报语音，
最近打算把它改成中文播报的，搜了下OS X的text to speech的文档，
只需在设置里安装相应的语音包即可使用了。

OS X版本 10.12.6

打开 System Preferences 选择Accessibilitiy， 选择Speech

![PNG]({static|osx-text-to-speech/settings1.png} "设置1")

下拉选择中文的语音，就一个，确定后自动开始下载。

![PNG]({static|osx-text-to-speech/settings2.png} "title1")

以监控arp表网关Mac地址为例

```bash
#!/bin/sh

MACADDR=`/usr/sbin/arp -n 192.168.31.1 | awk '/192.168.31.1/ {print $4}'`
NOW=`date "+%Y-%m-%d %H:%M:%S"`

if [ "$MACADDR" != "38:e3:c5:a8:57:4a" ];then
  echo $NOW $MACADDR >> /tmp/arp.log
  say 网关MAC地址改变
fi
```

脚本加入计划任务里，当网关mac地址发生变化的时候记录log并播放语音

