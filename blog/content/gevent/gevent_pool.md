Title: gevent pool 用法例子
Date: 2010-12-03 10:20
Modified: 2010-12-05 19:30
Category: Python
Tags: gevent
Slug: gevent-pool
Authors: zhangdi
Summary: gevent pool 用法演示

```python
#-*-coding:utf-8-*-  
#coding=utf-8
from gevent import monkey
monkey.patch_all()

from gevent.pool import Pool
import requests

sites = [u'目标列表']

def crawl_title(site):
    url = 'http://' + site
    content = requests.get(url).content
    #try:
    #    url = 'http://' + site
    #    content = requests.get(url).content
    #except:
    #    print site, 'get error'
    #    return
    #print site, len(content)

def crawl():
    pool = Pool(200)
    pool.map(crawl_title, sites)

if __name__ == '__main__':
    crawl()
```
