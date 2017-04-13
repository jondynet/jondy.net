Title: Python 与微信API 交互的例子
Date: 2014-12-22 17:05:01
Category: Python
Tags: wechat
Slug: python-weixin-api
Authors: zhangdi
Summary: Python 与微信API 交互的例子

### 自定义菜单接口

```python
#coding:utf-8
# Last modified: 2014-12-22 17:05:01
# by zhangdi http://jondy.net/
import requests
import json

appid = 'xxxx'
appsecret = 'xxxx'

url_token = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s'
url_iplist = 'https://api.weixin.qq.com/cgi-bin/getcallbackip?access_token=%s'
url_sendmsg = 'https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=%s'

req = requests.get(url_token % (appid, appsecret)).content
token = json.loads(req).get('access_token')
#req = requests.get(url_iplist % token).content
#print req

#url_userlist = 'https://api.weixin.qq.com/cgi-bin/user/get?access_token=%s&next_openid='
#req = requests.get(url_userlist % (token,)).content
#print req

url_getmenu = 'https://api.weixin.qq.com/cgi-bin/menu/get?access_token=%s'
req = requests.get(url_getmenu % (token,)).content
print req

url_postmenu = 'https://api.weixin.qq.com/cgi-bin/menu/create?access_token=%s'
data = '''
{
     "button":[
         {  
              "type":"view",
              "name":"我要上网",
              "url":"http://www.wlan-china.com/open4M/"
          },
          {
           "name":"菜单",
             "sub_button":[
               {  
                   "type":"view",
                   "name":"搜索",
                   "url":"http://m.baidu.com/"
                },
                {
                   "type":"view",
                   "name":"视频",
                   "url":"http://v.qq.com/"
                },
                {
                   "type":"click",
                   "name":"赞一下我们",
                   "key":"V1001_GOOD"
            }]
       }]
 }
'''
#req = requests.post(url_postmenu % (token,), data).content
#print req

url_userlist = 'https://api.weixin.qq.com/cgi-bin/user/get?access_token=%s&next_openid='
req = requests.get(url_userlist % (token,))
print '*' * 30
print 'userlist'
print req.content

openid = 'oiMi2uKBYtZwDgJNxtfcLGyqoo71'
url_userinfo = 'https://api.weixin.qq.com/cgi-bin/user/info?access_token=%s&openid=%s&lang=zh_CN'
req = requests.get(url_userinfo % (token, openid))
print '*' * 30
print 'openID', openid, 
print req.content

#data = {
#    "touser":"ok7tHt29VxY7xLdopP7MvX1-eGCE",
#    "msgtype":"text",
#    "content":"Hello World",
#  }
#req = requests.post(url_sendmsg % token, data=data)
#print token
#print req.content
```
