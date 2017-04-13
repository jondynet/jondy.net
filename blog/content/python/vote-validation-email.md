Title: 一次有意思的刷票－注册账号－邮箱激活
Date: 2015-10-19 23:07:15 +0800
Modified: 2015-10-19 23:07:15 +0800
Category: Python
Tags: gevent, vote
Slug: vote-validation-email
Authors: zhangdi
Summary: 一次有意思的刷票－注册账号－邮箱激活

师姐的一个投票，最初只是注册账号即可投票，非常的简单。
可能刷的人太多了，开始限制了IP，然而这并没有什么卵用，
于是很快网站又修改为要求邮箱验证注册的账号，不过很不幸并没有限制邮箱和账号的对应，
所以一个邮箱可以注册N多账号，当然即使限制了也没什么卵用。

于是流程就是去注册账号，然后邮箱激活账号，然后投票。。。

``` python
#coding:utf-8
# Last modified: 2015-10-20 06:06:01
# by zhangdi http://jondy.net/
from gevent import monkey                                                                                               
monkey.patch_all()
import requests
import random
import gevent
import imaplib
import email
import sys
import re
from gevent.queue import Queue
from store import Store

db = Store()

tasks = Queue()

def extract_body(payload):
  if isinstance(payload, str):
    return payload
  else:
    return '\n'.join([extract_body(part.get_payload(decode=True)) for part in payload])

def getmail():
  url = None
  M = imaplib.IMAP4_SSL('imap.163.com')
  M.login('xxxx@163.com','xxxx')
  M.list()
  M.select('inbox')
  typ, data = M.search(None, 'UNSEEN')
  for num in data[0].split():
      #typ,data=connect.fetch(msgList[len(msgList)-1],'(RFC822)')
      #typ, data = M.fetch(num, '(BODY.PEEK[])')
      typ, data = M.fetch(num, '(RFC822)')
      msg=email.message_from_string(data[0][1])
      payload = msg.get_payload(decode=True)
      body = extract_body(payload)
      rs = re.findall(r'data=(\w+)', body)
      if rs:
        url = 'http://xxxx.com/email.aspx?data=%s' % rs[0]
      M.store(num,'+FLAGS','\Seen')
      #print 'Message %s\n%s\n' % (num,repr(data))    
  M.close()
  M.logout()
  return url

def main(addr=None):
  proxies = {
      "http": "http://%s" % addr,
      "https": "http://%s" % addr,
    }
  url = 'http://xxxx.com/api/json.aspx'

  s = requests.session()
  s.proxies = proxies

  s.headers.update({
      'Accept':'application/json, text/javascript, */*; q=0.01',
      'Accept-Encoding':'gzip, deflate',
      'Accept-Language':'en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4,zh-TW;q=0.2',
      'Cache-Control':'no-cache',
      'Connection':'keep-alive',
      'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8',
      'Origin':'http://xxxx.com.cn',
      'Pragma':'no-cache',
      'Referer':'http://xxxx.com.cn/reg_user.aspx',
      'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36',
      'X-Requested-With':'XMLHttpRequest',
    })

  fake = random.randint(10000, 99999)
  data = (
      ('method', 'reg_user'),
      ('phone', '189130%d' % fake),
      ('password', 'abc%d' % fake),
      ('city', '天津'),
      ('nickname',u'刘%s' % unichr(random.randint(0x4E00, 0x9FBF))),
      #('email', '189130%d@189.cn' % fake),
      ('email', 'xxxx@163.com'),
      ('hospital', '天津人民医院'),
      ('job', '副主任医师'),
    )
  try:
    req = s.post(url, data, timeout=10.0)
  except:
    return
  j = req.json
  if j['message'] == 'success':
    gevent.sleep(20)
    mail_url = getmail()
    if mail_url:
      requests.get(mail_url)
    s.headers.update({
        'Referer':'http://xxxx.com/list_product2.aspx',
      })
    data = (
        ('method', 'toupiao'),
        ('id', '5179085497876317028'), # 师姐
        #('id', '5355849601129616780'), # 弱鸡一
      )
    try:
      req = s.post(url, data, timeout=10.0)
      j = req.json
    except:
      return
    #print req.content
    if j['message'] == 'success':
      print u'投票成功'
    else:
      print j
  else:
    print j

def worker(n):
  while not tasks.empty():
    task = tasks.get()
    with gevent.Timeout(60, False) as timeout:
      main(task)
    #print('Worker %s got task %s' % (n, task))
    gevent.sleep(0)
  print('Quitting time!')

for pk, ipaddr, port, proto, area, active, latest in db.fetchall():
  addr = '%s:%s' % (ipaddr, port)
  if proto in ('transparent', 'anonymous', 'high'):
    tasks.put_nowait(addr)

gevent.joinall([
  gevent.spawn(worker, '1'),
  #gevent.spawn(worker, '2'),
  #gevent.spawn(worker, '4'),
  #gevent.spawn(worker, '5'),
  #gevent.spawn(worker, '6'),
  #gevent.spawn(worker, '7'),
  #gevent.spawn(worker, '8'),
  #gevent.spawn(worker, '9'),
  #gevent.spawn(worker, '10'),
])
```
