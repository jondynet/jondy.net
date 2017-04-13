Title: Mikrotik Routeros Mactelnet 通讯协议测试
Date: 2015-01-29 19:07:59
Category: Python
Tags: RouterOS
Slug: python-mikrotik-routeros-mactelnet
Authors: zhangdi
Summary: Mikrotik RouterOS mac-telnet 通讯协议测试

```
#coding:utf-8
# Last modified: 2015-01-29 19:07:59
# by zhangdi http://jondy.net/
import socket
import sys
import struct
import random
import binascii
import hashlib
import os
socket.setdefaulttimeout(1800)
addr = ('255.255.255.255', 20561)
BUFSIZE = 10240
# terminal
rows, columns = os.popen('stty size', 'r').read().split()

pkgstruct = '!ss6s6sHHI'
cpkgstruct= 'IcI'
pkgfmt = ('version', 'type', 'src', 'dst', 'session_id', 'client_type', 'data_bytes')

pkg = {
    'version' : "\x01",
    'type' : "\x00", #start session
    'srcmac' : "\x10\x40\xf3\xab\x4e\xc8",
    #'dstmac' : '\x00\x1C\x42\xB6\x96\xAD',
    'dstmac' : '\xd4\xca\x6d\x31\x45\x3d',
    'client_type' : 0x0015,
    'session_id' : random.randint(1,65535),
    'session_data_bytes': 0,
    'magic_num': 0x563412ff,
    'data_type': "\x00",
    'data_len': 0,
  }
recv_data_bytes = 0
send_data_bytes = 0

cs = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
cs.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
cs.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
#cs.connect(addr)

# start session
s = struct.pack(pkgstruct, pkg['version'],pkg['type'],pkg['srcmac'], \
        pkg['dstmac'],pkg['session_id'],pkg['client_type'],pkg['session_data_bytes'])
cs.sendto(s, addr)
#cs.send(s)

rs = struct.unpack(pkgstruct, cs.recv(1024))
r = dict(zip(pkgfmt, rs))
if r['type'] == "\x02":
  print "acknowage start session"

# begin auth send 9
pkg['type'] = "\x01"
p = struct.pack(pkgstruct+cpkgstruct, pkg['version'],pkg['type'],pkg['srcmac'], \
        pkg['dstmac'],pkg['session_id'],pkg['client_type'],pkg['session_data_bytes'], \
        pkg['magic_num'], pkg['data_type'], pkg['data_len'])
cs.sendto(p, addr)
send_data_bytes = 9
#cs.send(p)

# ack 9
rs = struct.unpack(pkgstruct, cs.recv(1024))
r = dict(zip(pkgfmt, rs))
if r['type'] == "\x02":
  print "acknowage begin auth"

rec = cs.recv(1024)
#if len(rec) == 47:
# tell him i got key
pkg['type'] = "\x02"
recv_data_bytes = 47-22 #收到的data
p = struct.pack(pkgstruct, pkg['version'],pkg['type'],pkg['srcmac'], \
        pkg['dstmac'],pkg['session_id'],pkg['client_type'],recv_data_bytes)
cs.sendto(p, addr) #ack
rs = struct.unpack(pkgstruct+'IcI16s', rec)
key = rs[len(rs)-1]
print len(key)
print binascii.b2a_hex(key)

# built auth pkg
pkg['type'] = "\x01"
data = struct.pack(pkgstruct, pkg['version'],pkg['type'],pkg['srcmac'], \
        pkg['dstmac'],pkg['session_id'],pkg['client_type'],send_data_bytes) # 接着9发
# password
data_type= "\x02"
data_len = 17
passwd = binascii.unhexlify(hashlib.md5('\0doublecom2009%s'%key).hexdigest())
data += struct.pack('!IcI%ss' % data_len, 0x563412ff, data_type, data_len, "\0"+passwd)
# username
data_type= "\x03"
username = "doublecom+ct9000w"
data_len = len(username)
data += struct.pack('!IcI%ss' % data_len, 0x563412ff, data_type, data_len, username)
# terminal type
data_type= "\x04"
data_len = 5
data += struct.pack('!IcI%ss' % data_len, 0x563412ff, data_type, data_len, "linux")
# terminal width
data_type= "\x05"
data_len = 2
width = socket.htons(152)
data += struct.pack('!IcIH', 0x563412ff, data_type, data_len, width)
# terminal height
data_type= "\x06"
data_len = 2
height = socket.htons(44)
data += struct.pack('!IcIH', 0x563412ff, data_type, data_len, height)

cs.sendto(data, addr)
send_data_bytes = send_data_bytes + len(data) - 22

rec = cs.recv(1024)
rs = struct.unpack(pkgstruct, rec[:22]) #ack

rec = cs.recv(1024)
rs = struct.unpack(pkgstruct, rec[:22]) #ack
pkg['type'] = "\x02"
recv_data_bytes = recv_data_bytes + len(rec) - 22
print pkg['session_data_bytes']
p = struct.pack(pkgstruct, pkg['version'],pkg['type'],pkg['srcmac'], \
        pkg['dstmac'],pkg['session_id'],pkg['client_type'],recv_data_bytes)
cs.sendto(p, addr) #ack
print 'end auth'
print len(rec) # 31 end auth

rec = cs.recv(BUFSIZE)
recv_data_bytes = recv_data_bytes + len(rec) - 22
p = struct.pack(pkgstruct, pkg['version'],"\x02",pkg['srcmac'], \
        pkg['dstmac'],pkg['session_id'],pkg['client_type'],recv_data_bytes)
cs.sendto(p, addr) #ack
#print len(rec) # 626 ack
#print rec[12:]

cmd = '/system reboot; quit\r\n'
pkg['type'] = "\x01"
data = struct.pack(pkgstruct, pkg['version'],pkg['type'],pkg['srcmac'], \
      pkg['dstmac'],pkg['session_id'],pkg['client_type'],send_data_bytes) # 接着9发
data = data + cmd
print 'send'
cs.sendto(data, addr)

i = 0
while i < 10:
  rec = cs.recv(BUFSIZE)
  if len(rec) > 22:
    print '-'*152
    recv_data_bytes = recv_data_bytes + len(rec) - 22
    p = struct.pack(pkgstruct, pkg['version'],"\x02",pkg['srcmac'], \
          pkg['dstmac'],pkg['session_id'],pkg['client_type'],recv_data_bytes)
    cs.sendto(p, addr) #ack
    #print 'data', len(rec) # data ack
    #print repr(rec[22:])
    print rec[22:]
  else:
    pass
    #print 'ack'
  i+=1


sys.exit(0)
```
