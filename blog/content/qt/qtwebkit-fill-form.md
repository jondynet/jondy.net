Title: PyQtWebKit 中使用js填写表单
Date: 2013-10-12 13:37:05
Modified: 2013-10-12 13:37:05
Category: Python
Tags: PyQt4
Slug: qtwebkit-fill-form
Authors: zhangdi
Summary: PyQtWebKit 中使用js填写表单

pyqtwebkit中使用js填写表单

``` python
import sys
from PyQt4.QtCore import QUrl
from PyQt4.QtGui import QApplication
from PyQt4.QtWebKit import QWebView
from PyQt4.QtNetwork import QNetworkAccessManager
from PyQt4 import QtCore

def fillForm(web, username, password):
    print "Filling in the form"
    doc = web.page().mainFrame().documentElement()

    print "Finding username tag"
    user = doc.findFirst("input[id=Email]")
    print "Finding passwd tag"
    passwd = doc.findFirst("input[id=Passwd]")    

    print "Setting information"
    user.evaluateJavaScript("this.value = '%s'" % username)
    passwd.evaluateJavaScript("this.value = '%s'" % password)    
    button = doc.findFirst("input[id=signIn]")
    button.evaluateJavaScript("this.click()")

def doLogin(web, url, username, password):        
    web.loadFinished.connect(lambda: fillForm(web, username, password))
    web.load(url)
    web.show()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    nam = QNetworkAccessManager()
    web = QWebView()
    web.page().setNetworkAccessManager(nam)
    url = QUrl(r"https://accounts.google.com/Login")
    username = "name"
    password = "pass"
    doLogin(web, url, username, password)
    app.exec_()

```
