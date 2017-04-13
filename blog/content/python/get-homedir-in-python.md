Title: Python获取用户home目录
Date: 2016-08-11 19:07:27
Category: Python
Tags: django, PyQt4
Slug: get-homedir-in-python
Authors: zhangdi
Summary: Python获取用户home目录

很常用的功能，我在软件启动的时候讲一些数据放到home目录下按版本区分，
这样以后软件升级啊什么的就可以很方便的处理数据了。

#下面是不同系统的获取方法

* windows 平台获取AppData
* nixin 平台获取用户home

```python
import os
try:
  from win32com.shell import shellcon, shell            
  homedir = shell.SHGetFolderPath(0, shellcon.CSIDL_APPDATA, 0, 0)

except ImportError: # quick semi-nasty fallback for non-windows/win32com case
  homedir = os.path.expanduser("~")

print homedir
```
