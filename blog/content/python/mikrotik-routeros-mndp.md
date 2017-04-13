Title: Mikrotik RouterOS MNDP 发现协议
Date: 2010-02-03 10:20
Modified: 2010-02-03 19:30
Category: Python
Tags: RouterOS
Slug: mikrotik-routeros-mndp
Authors: zhangdi
Summary: Mikrotik RouterOS MNDP 发现协议

最近一段时间接个RouterOS的外包，实现了Mikrotik RouterOS的MNDP发现协议和
mactelnet通讯协议。
也开始接触和了解RouterOS这么强大的东西，非常的喜欢。

```python
#coding:utf-8
# Last modified: 2010-01-10 02:02:41
# by zhangdi http://jondy.net/
import socket
import struct
import binascii

HOST = '0.0.0.0'
PORT = 5678
BROADCAST = ('192.168.88.255', 5678)

offset = 0

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

sock.bind((HOST,PORT))
sock.sendto("\x00\x00\x00\x00", BROADCAST)

def get(s):
  if len(s) > 4:
    tlv_type,tlv_len = struct.unpack('!HH', s[:4])
    value = s[4:tlv_len+4]
    if tlv_type==1:
      print 'mac:', binascii.b2a_hex(value),
    if tlv_type==5:
      print 'Indetity:', value,
    if tlv_type==7:
      print 'Version:', value,
    if tlv_type==8:
      print 'Platform:', value,
    if tlv_type==10:
      # 转 int 得反转
      uptime = struct.unpack('!L', value[::-1])
      print 'Uptime:', uptime[0],
    if tlv_type==11:
      print 'Software ID:', value,
    if tlv_type==12:
      print 'Board:', value,
    if tlv_type==14:
      #print 'Unpack:', value,
      pass
    if tlv_type==16:
      print 'Interface:', value,
    else:
      #print tlv_type, tlv_len, value,
      pass
    s = s[4+tlv_len:]
    get(s)

while True:
  #rs = sock.recv(1024)
  data, addr = sock.recvfrom(1024)
  # 前4字节喂狗，太短的喂狗
  if len(data) < 50:
    continue
  s = data[4:]
  print addr[0]
  get(s)
  print 
  #a = raw_input()
  #print a
```
