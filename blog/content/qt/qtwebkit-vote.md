Title: QtWebKit修改cookie来刷投票
Date: 2015-12-05 23:25:19
Modified: 2015-12-05 23:25:19
Category: Python
Tags: PyQt4
Slug: qtwebkit-vote
Authors: zhangdi
Summary: QtWebKit修改cookie来刷投票

`刷投票`已经是我闲暇时间的一个乐趣，所以在新博客系统里我开始了一个`vote`的分类来记录一些代码和技巧。

这是一个微信投票，通过微信网页接口验证身份后，在投票的表单是个单独的页面，
post上去的信息最终仅判断了客户端在网站的cookie中的数据。
代码中的url是经过微信网页接口判断之后跳转的页面，数据验证不严密的结果就是可以随意伪造。。。

<!-- more --> 

页面中还有一些其他的内容判断我并不关心，我只需要不断的更新sqopenid这个cookie值。
这里使用qtwebkit来打开页面，每次页面load都更新一次cookie，这样就可以无限的刷呀刷呀。。。

``` python
#coding:utf-8
# Last modified: 2015-12-04 03:03:06
# by zhangdi http://jondy.net/
from PySide import *
from random import Random
import sys

url = 'http://xxxx.com/index.php?ac=voteimg&tid=2522&auth=1&openid=oyV8_t8xizlKk6Rs5QHmS9TemUh8&sign=BEC51C6CC68E7D7CF777FFD17B4D8218&time=1449159278'

def random_str(randomlength=8):
  str = ''
  chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789'
  length = len(chars) - 1
  random = Random()
  for i in range(randomlength):
    str+=chars[random.randint(0, length)]
  return str

def onload():
  openid = 'o6_bmasdasdsad6_7sgVt%s' % random_str()
  webView.page().mainFrame().evaluateJavaScript('document.cookie="sqopenid=%s"' % openid);
app = QtGui.QApplication(sys.argv) 
webView = QtWebKit.QWebView() 
webView.load(QtCore.QUrl(url)) 
webView.show() 
webView.raise_()
QtCore.QObject.connect(webView,QtCore.SIGNAL("loadFinished(bool)"),onload) 
sys.exit(app.exec_())
```

当然仅仅刷投票还不够乐趣，我还要看看别人的投票规律，于是另外一个定时任务脚本去获取所有用户的票数。
随时down回来导入excel看看曲线图，就知道哪些人也是在刷票，和单位时间刷票的能力。

``` python
#coding:utf-8
# Last modified: 2015-12-05 00:12:24
# by zhangdi http://jondy.net/
import requests
import lxml.html
import datetime
import re

url = 'http://xxxx.com/index.php?ac=voteimg&tid=2522&auth=1&openid=oyV8_t8xizlKk6Rs5QHmS9TemUh8&sign=BEC51C6CC68E7D7CF777FFD17B4D8218&time=1449159278'

r = requests.get(url)
doc = lxml.html.document_fromstring(r.content)

li = doc.xpath('//ul[@id="list"]/li')
print datetime.datetime.now()
names = []
votes = []
for p in li:
  name = p.xpath('label/span/text()')[0].encode('utf-8')
  vote = p.xpath('div/span/span/text()')[0]
  vote = re.findall(r'(\d+)', vote)[0]
  #print name, vote
  names.append(name)
  votes.append(vote)

print ','.join(names)
print ','.join(votes)
```
