Title: python pefile修改exe文件资源
Date: 2014-11-23 21:09:49
Modified: 2014-11-23 21:09:49
Category: Python
Tags: pefile
Slug: python-pefile-custom-exe
Authors: zhangdi
Summary: 定制exe文件嘛，换个图标换个标题

### 定制exe文件嘛，换个图标换个标题

<!-- more -->

``` python
#coding:utf-8
# Last modified: 2014-11-23 21:09:49
# by zhangdi http://jondy.net/
import pefile
import StringIO
import sys

icoheader = '\x00\x00\x01\x00\x01\x00\x30\x30\x00\x00\x01\x00\x08\x00\xA8\x0E\x00\x00\x16\x00\x00\x00'
im = open('wifi.ico').read()
if im[:22] != icoheader:
  print u'无效的图标，请使用48x48的ico图标文件！'
  sys.exit()

pe = pefile.PE('winbox.exe') 
rva = pe.get_rva_from_offset(0x16bc0)
pe.set_bytes_at_rva(rva, im[22:])
f = pe.write()

f1 = f[:83184]
f2 = f[83209:]
title = u'wifi管理工具'.encode('gbk').ljust(25)
open('new.exe', 'wb').write(f1+title+f2)
```
