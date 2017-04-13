Title: Twisted的http代理服务器劫持post数据
Date: 2015-01-30 23:07:15 +0800
Modified: 2015-01-30 23:07:15 +0800
Category: Python
Tags: Twisted
Slug: twisted-proxy
Authors: zhangdi
Summary: Twisted的http代理服务器劫持post数据

有人在我维护的网络里晒密！！！这还得了，我先看看他都晒啥了...

``` python
#coding:utf-8
# Last modified: 2015-01-30 01:01:33
# by zhangdi http://jondy.net/
from twisted.web import proxy, http
from twisted.internet import reactor
#from twisted.python import log
import sys
#log.startLogging(sys.stdout)
#log.startLogging(open("/home/www/twistedProxy.log",'w'))
sys.stdout = open('output.log', 'wb')

class bcolors:
  HEADER = '\033[95m'
  OKBLUE = '\033[94m'
  OKGREEN = '\033[92m'
  WARNING = '\033[93m'
  FAIL = '\033[91m'
  ENDC = '\033[0m'
  BOLD = '\033[1m'
  UNDERLINE = '\033[4m'

class SnifferProxy(proxy.Proxy):
  """
  Local proxy = bridge between browser and web application
  """

  def allContentReceived(self):
    if self._command == 'POST':
      ipaddr = self.transport.getPeer()
      print ipaddr.host, self._command, self._path
    return proxy.Proxy.allContentReceived(self)

  def rawDataReceived(self, data):
    print bcolors.WARNING + data[:100] + bcolors.ENDC
    return proxy.Proxy.rawDataReceived(self, data)

class ProxyFactory(http.HTTPFactory):
  protocol = SnifferProxy 
 
reactor.listenTCP(8080, ProxyFactory())
reactor.run()
```
