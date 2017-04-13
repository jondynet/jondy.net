title: 搞一搞智慧上网的Chrome插件
Date: 2015-03-03 10:20
Category: Python
Tags: tornado, MITM
Slug: MITM-https-proxy
Authors: zhangdi

最近很流行智慧上网嘛，我也试用了2个，速度那叫一个快呀，流口水ing...
这么好的东西怎么做的能，分析了一下用的是https的代理服务器，插件的js来做账号管理和计费。

这就有意思了，去chrome目录里把插件copy出来修改了用户管理部分的地址，重新打包安装，
模拟服务端返回的数据嘛，不过https代理这也需要身份验证，但不计费，结果就是每次新登录都得用个新的试用账号，
登录后可以无限时间和流量使用，没能完全的绕过计费机制。。。

发现websocket好适合做计费这事.

``` python
#coding:utf-8
# Last modified: 2015-02-08 10:10:03
# by zhangdi http://jondy.net/
import os
import ssl
from tornado.httpserver import HTTPServer
from tornado.web import Application, RequestHandler
from tornado.websocket import WebSocketHandler
from tornado.ioloop import IOLoop
from tornado.log import enable_pretty_logging
import tornado.escape
enable_pretty_logging()

class NameHandler(RequestHandler):
    def get(self):
      self.write('{"exists":true}')

class TestHandler(RequestHandler):
    def get(self):
        self.write('{"no_password":false,"until":2426952316,"level":"VIP","name":"xxxx@foxmail.com","sid":"DDD1C351-20150205-065321-8a6c76-90dafc","inviter":"xxxx@foxmail.com","anonymous":null}')

class Test2Handler(RequestHandler):
    def get(self):
        self.write('{"invitation_list":[{"_id":"54d31361ceaf0f1276b04c60","receiver":"xxxx@foxmail.com","can_fetch_reward":true,"status":"VIP","sender":"xudu***@foxmail.com"}]}')

class SocketHandler(WebSocketHandler):
    def check_origin(self, origin):
        return True

    def open(self):
        print 'new connection'
      
    def on_message(self, message):
        #print 'message received %s' % message
        #parsed = tornado.escape.json_decode(message)
        #print parsed
        self.write_message('[3,2,"profile",{"name":"xxxx@foxmail.com","inviter":"seexxxx@163.com","until":99426952316.0,"sid":"8CCE72BE-20141215-073500-d25f7d-d9506d","no_password":false,"level":"VIP","anonymous":null}]')
        #self.write_message('[3,4,"proxies",[{"scheme":"HTTPS","host":"xxxxxxx.xxxx","port":443,"group":"t.0119","name":"hz.ali.0205.9"}]]')
        #self.write_message('[4,2,"","checkin ok"]')
 
    def on_close(self):
      print 'connection closed'

settings = {
    "static_path" : os.path.join(os.path.dirname(__file__), "static"),
}

application = Application([
    (r"/user/login", TestHandler),
    (r"/user/name", NameHandler),
    (r"/user/invitation_list", Test2Handler),
    (r"/red/extension", SocketHandler),
], debug=True, **settings)

if __name__ == "__main__":
    server = HTTPServer(application,
        #ssl_options={
        #   "certfile": os.path.join(os.path.abspath("."), "server.crt"),
        #   "keyfile": os.path.join(os.path.abspath("."), "server.key"),
        # }
        )
    server.listen(8080)
    IOLoop.instance().start()
```
