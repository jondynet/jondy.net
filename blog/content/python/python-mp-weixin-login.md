Title: Python 登录微信公众号后台并保持会话
Date: 2015-01-07 20:08:41
Category: Python
Tags: requests
Slug: python-mp-weixin-login
Authors: zhangdi
Summary: Python 登录微信公众号后台并保持会话

首先是登录啊，需要验证码，图片存到本地手动打码登录了以后就用session会话了。

登录过程发现很有趣的是微信公众号对密码验证的最大位数是16位，
我的客户设置了个超长的密码，实际上16位以后的填什么都无所谓了，
取前16位做的md5传给服务器。囧囧

### 登录部分
```python
#coding:utf-8
# Last modified: 2015-01-07 20:08:41
# by zhangdi http://jondy.net/
import sys
import requests
import hashlib
import pickle
import json
import time

username = 'xxxxx@qq.com'
password = 'xxxxxxxxxxxxxxxxxxxxxxxxxx'[:16]

url_login = 'https://mp.weixin.qq.com/cgi-bin/login'
url_verifycode = 'https://mp.weixin.qq.com/cgi-bin/verifycode?username=%s&r=%s'

s = requests.session()
s.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) \
    AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'


data = {
    'username': username,
    'pwd': hashlib.md5(password).hexdigest(),
    'imgcode': '',
    'f': 'json',
  }

headers = {
    'Referer': 'https://mp.weixin.qq.com/',
  }
r = s.post(url_login, data=data, headers=headers)
j = json.loads(r.content)

if j['base_resp']['ret'] == -8:
  open('vcode.jpg', 'wb').write(s.get(url_verifycode % (username, str(time.time()))).content)
  print 'verifycode:'
  vcode = raw_input()
  data['imgcode'] = vcode.strip()
  r = s.post(url_login, data=data, headers=headers)
  j = json.loads(r.content)
if j['base_resp']['ret'] != 0:
  sys.exit(j)
print 'logined'
print j
with open('session', 'w') as f:
  pickle.dump(requests.utils.dict_from_cookiejar(s.cookies), f)
#url = 'https://mp.weixin.qq.com%s' % j['redirect_url']
#r = s.get(url)
#print r.content
```

### 登录以后用session继续会话就行了，不断的刷新列表，看谁关注公众号了

```python
#coding:utf-8
# Last modified: 2015-01-07 22:10:40
# by zhangdi http://jondy.net/
import requests
import pickle
import re
import json
import time
regx_friends = re.compile(r'friendsList : \((.*)\)\.contacts')

token = 'xxxx'
url = 'https://mp.weixin.qq.com/cgi-bin/contactmanage?t=user/index&pagesize=10&pageidx=0&type=0&token=%s&lang=zh_CN'
url_headimg = 'https://mp.weixin.qq.com/misc/getheadimg?fakeid=%s&token=%s&lang=zh_CN'

s = requests.session()
s.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) \
    AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'

while 1:
  with open('session') as f:
    cookies = requests.utils.cookiejar_from_dict(pickle.load(f))
    s.cookies = cookies
  r = s.get(url % token)
  print r.headers
  friends = regx_friends.findall(r.content)
  if friends:
    j = json.loads(friends[0])
    for u in j['contacts']:
      print u[u'id'], u[u'nick_name']
      print url_headimg % (u[u'id'], token)

  with open('session', 'w') as f:
    pickle.dump(requests.utils.dict_from_cookiejar(s.cookies), f)
  time.sleep(2)
```
