Title: 波克城市帐号批量注册脚本
Date: 2015-12-03 19:20
Modified: 2015-12-05 19:30
Category: Python
Tags: requests
Slug: python-requests-reg-pookcity
Authors: zhangdi
Summary: 波克城市帐号批量注册脚本

```python
#coding:utf-8
import requests
import json

url = 'http://www.pook.com/register/quickReg.do'

def register(username):
  data = {
      'rUser.validCode':'webLobby',
      'rUser.clientAreaId':'undefined',
      'rUser.agentId':10028,
      'rUser.userName':username,
      'rUser.password':'031a3e3f3b385bf694daf1042b79e11a',
      'rUser.rePassword':'031a3e3f3b385bf694daf1042b79e11a'
    }

  req = requests.post(url, data)
  j = req.json()
  return j.has_key(u'userId') and j[u'userId'] or j

offset = 197
for i in range(offset, offset+10):
  username = 'user%.4dh' % i
  print username, register(username)
```
