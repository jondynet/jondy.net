Title: 代码片段：twisted 代理服务器
Date: 2015-03-03 22:10:24
Modified: 2015-03-03 22:10:24
Category: Python
Tags: twisted
Slug: twisted-proxy-server
Authors: zhangdi
Summary: 代码片段：twisted 代理服务器

```python
#coding:utf-8
# Last modified: 2015-03-03 22:10:24
# by zhangdi http://jondy.net/
from twisted.python import log
from twisted.internet import reactor
from twisted.web import http, proxy
import sys
log.startLogging(sys.stdout)

class ProxyClient(proxy.ProxyClient):
    """Mange returned header, content here.

    Use `self.father` methods to modify request directly.
    """
    def handleHeader(self, key, value):
        # change response header here
        log.msg("Header: %s: %s" % (key, value))
        proxy.ProxyClient.handleHeader(self, key, value)

    def handleResponsePart(self, buffer):
        # change response part here
        log.msg("Content: %s" % (buffer[:50],))
        # make all content upper case
        try:
          proxy.ProxyClient.handleResponsePart(self, buffer.upper())
        except:
          pass

class ProxyClientFactory(proxy.ProxyClientFactory):
    protocol = ProxyClient

class ProxyRequest(proxy.ProxyRequest):
    protocols = dict(http=ProxyClientFactory)

class Proxy(proxy.Proxy):
    requestFactory = ProxyRequest

class ProxyFactory(http.HTTPFactory):
    protocol = Proxy


if __name__ == '__main__':
    reactor.listenTCP(8089, ProxyFactory())
    reactor.run()

```
