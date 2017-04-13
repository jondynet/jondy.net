Title: 在某论坛刷铜板
Date: 2015-01-11 13:01:50
Category: Python
Tags: requests, gevent
Slug: python-gevent-requests-cheating
Authors: zhangdi
Summary: 用python脚本通过代理服务器在某discuz论坛刷铜板

主持帐号以后发现有个邀请朋友给铜板的功能，虽然不知道铜板有什么卵用，
正巧这段时间我做了个代理服务的网站[31f.cn](http://31f.cn/)，
手上有无数的代理服务器资源，本着娱乐的精神写一段刷刷玩。

先用curl测测看看果然能刷，这是个根据IP来增加计数的功能。

```bash
curl -x 119.97.137.178:80 -L -vv <url>
curl --socks5 119.97.137.178:80 -L -vv <url>
```

###Python 开始并发

目标地址和我的用户IDxxx了，需要的自己替换吧。

```python
#coding:utf-8
# Last modified: 2015-01-11 13:01:50
# by zhangdi http://jondy.net/
import requests
import gevent

url = 'http://www.xxxxx.com/?fromuid=xxxxx'

proxys = open('proxy.txt').readlines()

def get(proxy):
  s = requests.session()
  s.proxies = {'http': 'http://%s' % proxy.strip()}
  try:
    s.get(url)
    print u'1铜板'
  except:
    print u'失败了！'

worklist = []
for proxy in proxys:
  worklist.append(gevent.spawn(get, proxy))

gevent.joinall(worklist) 
```

给自己的代理服务网站打个广告，请记住 [31f.cn](http://31f.cn/) 。
永久免费，开放数据。
