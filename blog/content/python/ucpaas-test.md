Title: 云之讯短信和语音验证测试脚本
Date: 2015-08-26 16:04:00
Category: Python
Tags: ucpaas, requests
Slug: ucpaas-test
Authors: zhangdi
Summary: 云之讯短信和语音验证吗测试脚本

给[wlan-china.com](http://www.wlan-china.com/)做portal认证的时候需要下发验证码，
选了几家短信服务商之后觉得云之讯比一些老牌的短信服务商要靠谱的多。

短信送达速度和服务稳定性都不错，接口比老牌的要复杂一点，但也不难。

我这么夸赞云之讯的人看到会不会送些短信条目给我，哈哈哈....

###云之讯接口测试脚本

```python
#coding:utf-8
# Last modified: 2015-08-26 16:04:00
# by zhangdi http://jondy.net/
import urllib
import requests
import hashlib
import datetime
import json

SID = 'xxxx'
APPID = 'xxxx'
APPID = 'xxxx'
TOKEN = 'xxxx'
url = 'http://www.ucpaas.com/maap/sms/code'

# 3位毫秒
#microsecond = int(datetime.datetime.now().microsecond*1e-3)
TIME = datetime.datetime.now().strftime('%Y%m%d%H%M%S000')

params = {
    'sid': SID,
    'appId': APPID,
    # 验证信息，使用MD5加密（账户id+时间戳+账户授权令牌），共32位（小写）
    'sign': hashlib.md5(SID+TIME+TOKEN).hexdigest(),
    'time': TIME,
    'templateId': xxxx,
    'to': 'xxxxx',
    'param': '重庆路万达广场,223456,30'
  }
#print urllib.urlencode(params)
#req = requests.get(url, params=params)
#print req.content

# 语音restapi
TIME = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
url = 'https://api.ucpaas.com/2014-06-30/Accounts/%s/Calls/voiceCode' % SID
# sig= MD5（账户Id + 账户授权令牌 + 时间戳），共32位(注:转成大写)
params = {
    'sig': hashlib.md5(SID+TOKEN+TIME).hexdigest().upper(),
  }


params = {
    'sid': SID,
    'appId': APPID,
    # 验证信息，使用MD5加密（账户id+时间戳+账户授权令牌），共32位（小写）
    'sign': hashlib.md5(SID+TIME+TOKEN).hexdigest(),
    'time': TIME,
    'templateId': xxxx,
    'to': 'xxxx',
    'param': '重庆路万达广场,223456,30'
  }
#print urllib.urlencode(params)
#req = requests.get(url, params=params)
#print req.content

# 语音restapi
url = 'https://api.ucpaas.com/2014-06-30/Accounts/%s/Calls/voiceCode' % SID
# sig= MD5（账户Id + 账户授权令牌 + 时间戳），共32位(注:转成大写)
params = {
    'sig': hashlib.md5(SID+TOKEN+TIME).hexdigest().upper(),
  }

data = {
 "voiceCode"  : {
    "appId"      : APPID,
    "to"         : "xxxx",
    "verifyCode" : "xxxx",
    "displayNum" : "xxxx",
  }
}

s = requests.session()
s.headers = {
  "Content-type":"application/json;charset=utf-8;",
  "Accept": "application/json",
  "Authorization": ("%s:%s" % (SID, TIME)).encode('base64'),
}
req = s.post(url, params=params, data=json.dumps(data)+'  ')
print req.headers
print s.headers
print req.content
```
