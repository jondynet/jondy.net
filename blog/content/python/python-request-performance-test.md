Title: python脚本测试阿里云API性能
Date: 2017-07-28 14:02
Modified: 2017-07-28 14:02:42
Category: Python
Tags: python, requests, gevent
Slug: python-request-performance-test
Authors: zhangdi
Summary: 阿里云API 大赛期间测试API性能的脚本

整理一下前端时间参加阿里云API大赛时的一个脚本。

参赛期间对作品有个要求是在单位时间模拟一定量API调用，
对API的响应速度和故障率进行统计。

直接上代码

```python
#coding:utf-8
# Last modified: 2017-05-25 11:11:16
# by zhangdi http://jondy.net/
from gevent import monkey
monkey.patch_all()
from gevent.pool import Pool
import requests
import random
import json
import httplib as http_client
http_client.HTTPConnection.debuglevel = 1

APPCODE = '<your code>'

url = '<your apiurl>'

headers = {
        "Accept": "application/json",
        "User-Agent": "python-requests",
        "headerName": "consoleClientHeaderName",
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
        "Authorization": "APPCODE %s" % APPCODE
}

data = {
    "params": "youparams"
}

def hello(pk=None):
    req = requests.post(url, data=data, headers=headers)
    print req
    print req.content

def crawl():
    pool = Pool(20)
    pool.map(hello, range(1000))

if __name__ == '__main__':
    crawl()
```

简单粗暴直接gevent搞起
之后对log进行了一些处理，自己先感觉一下自己的状态,
从代码里取出响应时间，看看最大最小和平均时间消耗。

```python
import re

f = open('output.log').read()

rt = re.findall(r'([\d\.]+)ms', f)

rt = map(float, rt)

rt.sort()

print rt[0], rt[-1], sum(rt)/len(rt)
```

最后附上测试我的Wi-Fi探针接口的完整代码

```python
#coding:utf-8
# Last modified: 2017-05-25 06:06:35
# by zhangdi http://jondy.net/
from gevent import monkey
#monkey.patch_all()
from gevent.pool import Pool
import sys
import json
import time
import urllib
import random
import requests

APPCODE = '<your appcode>'
MAX_REQUEST = 10
CONSOLE = sys.stdout

urls = ['http://wifitz.market.alicloudapi.com/api/tz/status',
        'http://wifitz.market.alicloudapi.com/api/tz/clients']

mac_list = ['C4:4B:D1:01:0A:45', 'C4:4B:D1:01:0F:72', 'C4:4B:D1:01:0B:23']

HEADERS = {
        "Accept": "application/json",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4)"
                      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Content-Type": "application/octet-stream; charset=utf-8",
        "Authorization": "APPCODE %s" % APPCODE
}

def worker(pk=None):
    start = time.clock()
    data = {
        "mac": mac_list[random.randint(0,2)],
    }
    url = urls[random.randint(0,1)]
    req = requests.get(url, params=data, headers=HEADERS)
    print '%d,%f,%s' % (req.status_code, time.clock() - start, data['mac'])

def report(th):
    run_time = []
    status_list = {}
    mac_list = {}
    for i in open('%s.log' % th).readlines():
        sc, rt, mac = i.split(',')
        mac = mac.strip()

        status_list.setdefault(sc, 0)
        status_list[sc] += 1

        run_time.append(float(rt))

        mac_list.setdefault(mac, 0)
        mac_list[mac] += 1

    run_time.sort()

    print status_list
    # print u'接口状态码计数：', status_list
    # print u'最快响应时间：%f 最慢相应时间：%f 平均相应时间：%f' % \
    #         (run_time[0], run_time[-1], sum(run_time)/len(run_time))
    # print u'参数分布：', mac_list

def crawl(mq, th):
    start = time.clock()
    sys.stdout = open('%s.log' % th, 'wb')
    pool = Pool(th)
    pool.map(worker, range(mq))
    sys.stdout = CONSOLE
    #print u'并发数：%d 访问数：%d 执行时间：%f' % (th, mq, time.clock() - start)
    report(th)
    print time.time(), '-'*80

if __name__ == '__main__':
    crawl(random.randint(2,10), 3)
```
