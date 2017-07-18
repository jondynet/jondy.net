Title: PL-2303 usb to serial 驱动安装
Date: 2017-07-11 03:21
Modified: 2017-07-17 11:11:49
Category: OSX
Tags: PL-2303
Slug: pl-2303-usb-to-serial-install
Authors: zhangdi
Summary: PL-2303 usb to serial 驱动安装

驱动下载
--------

链接: https://pan.baidu.com/s/1gfejJY7 密码: m8cf


## 默认安装后使用

```
$ ls /dev/tty.*
$ screen /dev/tty.usbserial 115200
```

内容太少了再写点

树莓派开启ssh

tf卡boot分区touch个ssh文件

或登陆系统后rasp-config 里开启

树莓派连Wi-Fi

# 编辑wifi文件

sudo vi /etc/wpa_supplicant/wpa_supplicant.conf

# 在该文件最后添加下面的话

```
network={
  ssid="WIFINAME"
  psk="password"
}
```

引号部分分别为wifi的名字和密码
保存文件后几秒钟应该就会自动连接到该wifi
查看是否连接成功

```
ifconfig wlan0
```


