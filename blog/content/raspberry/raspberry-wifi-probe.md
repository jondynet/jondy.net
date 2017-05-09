Title: 树莓派做wifi探针
Date: 2017-04-12 16:04
Category: Raspberry
Tags: wifi raspberry
Slug: raspberry-wifi-probe
Authors: zhangdi
Summary: 使用树莓派做wifi探针笔记

*wifi探针*只需设备开启无线网卡，并不需要连接wifi即可探测出设备的mac地址和信号强度。
最近公司要做一款*wifi探针*产品用于扩充无线覆盖的应用。

*wifi探针*本身并不复杂，之前我在树莓派2代的板子上插usb无线网卡实现过，
新入手的树莓派3代板子集成了wifi，同时也预留了焊盘可焊接天线底座。

在树莓派上做*wifi探针*是为了产品开发和演示方便，最终产品会移植到OpenWRT平台的板子上。

树莓派3代的板载无线网卡默认是不支持monitor模式的，首先得打补丁支持monitor模式。

开机自动挂载驱动

修改 /etc/rc.local

exit 0 前增加
```
insmod /root/brcmfmac.ko
```

*wifi探针*实现的功能：获取周边手机等设备的mac地址和信号强度上报到云端，
首先复制粘贴网上的N行实现wifi探针的python脚本看看效果，文章使用的是scapy来做的，
实际测试信号强度是不对的，时间关系没去研究具体原因，使用了pcap的版本可以获取到需要的数据。

修改带上报功能后python代码：

```python
#coding:utf-8
# by zhangdi <h4ck@163.com>
import os
import random
import pcapy
import time
import json
import zlib
import socket
import binascii
from multiprocessing import Process
from impacket import ImpactDecoder, dot11

MYMAC		 = open('/sys/class/net/eth0/address').read().strip().lower()
INTERFACE    = 'wlan0'
MAX_LEN      = 1514    # max size of packet to capture
PROMISCUOUS  = 1       # promiscuous mode?
READ_TIMEOUT = 300     # in milliseconds

RTD = ImpactDecoder.RadioTapDecoder()

UDP_IP = '192.168.88.234'
UDP_PORT = 12345
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP

clients = {'mac': MYMAC, 'clients':[]}
latest = time.time()

# Channel hopper
def channel_hopper():
    while True:
		channel = random.randrange(1,14)
		cmd = "iw dev wlan0 set channel %d" % channel
		#print cmd
		try:
			os.system(cmd)
			time.sleep(1)
		except KeyboardInterrupt:
			break

def getBssid(arr):
	#Get Binary array to MAC addr format
	out = []
	s = binascii.hexlify(arr)
	t = iter(s)
	st = ':'.join(a+b for a,b in zip(t,t))
	return st

def pcapy_packet(header, data):
	global clients, latest
	radio_packet = RTD.decode(data)
	_signal = radio_packet.get_dBm_ant_signal()
	channel = radio_packet.get_channel()[0]
	if _signal:
		signal = _signal and -(256-_signal) or -120
	pkt = radio_packet.child()
  
	if pkt.get_type() == dot11.Dot11Types.DOT11_TYPE_MANAGEMENT:
		base = pkt.child().child()
		if base.__class__ != dot11.Dot11ManagementProbeRequest: return
		bssid_base = pkt.child()
		#try: ssid = str(base.get_ssid())
		#except: ssid = ''
		bssid = getBssid(bssid_base.get_source_address())
		clients['clients'].append({'mac':bssid, 'channel': channel, 'signal':signal})
		if (time.time() - latest) > 3:
			latest = time.time()
			print clients
			sock.sendto(zlib.compress(json.dumps(clients)), (UDP_IP, UDP_PORT))
			clients['clients'] = []

#if __name__ == "__main__":
p = Process(target = channel_hopper)
p.start()

c = pcapy.open_live('wlan0', MAX_LEN, PROMISCUOUS, READ_TIMEOUT)
try:
	c.loop(-1, pcapy_packet)
except SystemError:
	print clients
```

测试期间发现偶尔无线网卡死掉，后换了2A的电源后解决，部署了3台在几个办公区用于计算区域人流。

补充：我在这里做了网卡自动切换信道，在后来形成产品的C语言版本时发现变信道不需要，本身就是广播啊。
