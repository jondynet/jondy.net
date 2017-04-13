Title: QtWebKit使用代理服务器
Date: 2016-02-05 06:07:15 +0800
Modified: 2016-02-05 06:07:15 +0800
Category: Python
Tags: PyQt4
Slug: qtwebkit-qnetwork-proxy
Authors: zhangdi
Summary: QtWebKit使用代理服务器

Qt项目中使用代理服务器。
没啥子好说的直接上代码:

``` python
#!/usr/bin/env python

import sys
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtWebKit import *
from PySide.QtNetwork import *

QNetworkProxy.setApplicationProxy(QNetworkProxy(QNetworkProxy.HttpProxy, "49.1.245.242", 3128))
app = QApplication(sys.argv)

web = QWebView()
web.load(QUrl("http://jondy.net/ip/"))
web.show()

sys.exit(app.exec_())

```

### 另一个

``` python
import sys 
import PySide.QtGui as QtGui 
import PySide.QtCore as QtCore 
import PySide.QtWebKit as QtWebKit 
import PySide.QtNetwork as QtNetwork
from PySide.QtNetwork import QNetworkAccessManager,QNetworkProxy

class MyNetworkAccessManager(QNetworkAccessManager): 
  def __init__(self, old_manager): 
    QNetworkAccessManager.__init__(self) 
    self.setCache(old_manager.cache()) 
    self.setCookieJar(old_manager.cookieJar()) 
    self.setProxy(old_manager.proxy()) 
    self.setProxyFactory(old_manager.proxyFactory()) 

  def createRequest(self, operation, request, data): 
    print "mymanager handles ", request.url() 
    return QNetworkAccessManager.createRequest( 
        self, operation, request, data) 



if __name__ == '__main__':
  QNetworkProxy.setApplicationProxy(QNetworkProxy(QNetworkProxy.HttpProxy, "49.1.245.242", 3128))
  app = QtGui.QApplication(sys.argv) 
  web = QtWebKit.QWebView() 
  old_manager = web.page().networkAccessManager() 
  new_manager = MyNetworkAccessManager(old_manager) 
  web.page().setNetworkAccessManager(new_manager) 
  web.setUrl( QtCore.QUrl("http://www.ip138.com") ) 
  web.show() 

  sys.exit(app.exec_()) 

```
