Title: qtwebkit使用代理服务器
Date: 2015-02-26 23:20
Modified: 2010-12-05 19:30
Category: Python
Tags: PySide
Slug: qtwebkit-proxy
Authors: zhangdi
Summary: qtwebkit使用代理服务器

### 代码片段

```python
#coding:utf-8
# Last modified: 2015-02-26 20:18:19
# by zhangdi QQ:222411
import sys
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtWebKit import *
from PySide.QtNetwork import *

url = 'http://v.youku.com/v_show/id_XMTQ2ODM1NDEyMA.html'

proxy = '223.100.98.44:8000'
proxy_ipaddr = proxy.split(':').pop(0)
proxy_port = int(proxy.split(':').pop())

#QNetworkProxy.setApplicationProxy(QNetworkProxy(QNetworkProxy.HttpProxy, proxy_ipaddr, proxy_port))
app = QApplication(sys.argv)

web = QWebView()
#web.settings().setAttribute(QWebSettings.PluginsEnabled,True)
QWebSettings.globalSettings().setAttribute(QWebSettings.PluginsEnabled, True)
web.load(QUrl(url))
#web.show()

sys.exit(app.exec_())

```

### 再来一段

```python
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

### 再来一段

```python
#coding:utf-8
# Last modified: 2015-02-26 23:11:59
# by zhangdi http://jondy.net/
import os
import sys

from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtWebKit import *
from PySide.QtNetwork import *

__version__ = "0.1 20091002"
__appname__ = "minibrowser"

TITLE = "%s %s" % (__appname__, __version__)
HOMEPAGE = "http://example.com/"
HISTORY = os.path.join(os.path.dirname(sys.argv[0]), "%s.log" % (__appname__))

class BrowserWidget(QWidget):
    def __init__(self, datpath, parent=None):
        super(self.__class__, self).__init__(parent)
        self.browser = QWebView()
        self.lineedit = QLineEdit()
        
        layout = QVBoxLayout()
        layout.setSpacing(0)
        #layout.setMargin(0)
        layout.addWidget(self.lineedit)
        layout.addWidget(self.browser)
        self.setLayout(layout)
        self.lineedit.setFocus()
        self.connect(self.lineedit, SIGNAL("returnPressed()"), self.entrytext)

        self.browser.load(QUrl(HOMEPAGE))
        self.browser.show()
        
    def entrytext(self):
        self.browser.load(QUrl(self.lineedit.text()))

class Window(QMainWindow):
    def __init__(self, histlogpath, parent=None):
        super(self.__class__, self).__init__(parent)
        self.browserWindow = BrowserWidget(histlogpath)
        self.setCentralWidget(self.browserWindow)
        self.setWindowTitle(TITLE)

        status = self.statusBar()
        status.setSizeGripEnabled(True)

        self.label = QLabel("")
        status.addWidget(self.label, 1)

        self.connect(self.browserWindow.browser, SIGNAL("loadFinished(bool)"), self.loadFinished)
        self.connect(self.browserWindow.browser, SIGNAL("loadProgress(int)"), self.loading)
        self.histlogpath = histlogpath

    def loadFinished(self, flag):
        """SLOT of load finished.
        """
        self.label.setText("Done")
        open(self.histlogpath, 'a').write(self.browserWindow.browser.url().toString() + "\n")

    def loading(self, percent):
        """SLOT of loading progress.
        """
        self.label.setText("Loading %d%%" % percent)
        self.browserWindow.lineedit.setText(self.browserWindow.browser.url().toString())

if __name__ == '__main__':
    QNetworkProxy.setApplicationProxy(QNetworkProxy(QNetworkProxy.HttpProxy, "49.1.245.242", 3128))
    app = QApplication(sys.argv)
    window = Window(HISTORY)
    window.show()
    app.exec_()
```
