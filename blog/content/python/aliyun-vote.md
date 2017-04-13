title: xx云开发者大赛刷票
Date: 2013-12-12 23:07:15 +0800
Modified: 2010-12-05 19:30
Category: Python
Tags: vote
Slug: aliyun-vote
Authors: zhangdi
Summary: xx云开发者大赛刷票

咳，只讲刷票过程，非常有趣的。

首先是注册账号，要求邮箱和手机，一个邮箱一个账号，一个手机号可注册10个账号。
研究僧也是学生狗嘛，手机号有的是。至于大量的邮箱，写脚本去注册都是浪费资源，
我这里用免费的企业邮箱，咔嚓一下200个账号，咔嚓几下就够了。。。。

投票是单纯的post，要求账号登录，一个账号24小时内10票，没啥能绕过去的，
最终是个拼资源的状态。去猪八戒看了眼有人在收账号，我这都企邮的账号就不得瑟卖他了，
我这没成本没压力，哈哈。

拼资源嘛，就要厚积薄发，前几天我始终保持在5-7名的位置，不久群里有人贴出前五名的票数曲线，
谴责刷票的，进而曝光到前十，我就暴露了，其实控制点节奏这种看曲线的就木有用了，哈哈哈。。。
大家都搞技术的，难道还真拉票去投啊， 玩乐嘛，于是我变换各种姿势的开始刷。。。

如何处理大量cookie，大量的账号登录还是需要验证码，如何登录大量的账号保存cookie才是关键呢，
谁来添验证码？哼哼哼，我有几个小网站有点流量，改成看内容得添验证码，这验证码正是登录阿里需要的验证码。
是不是很机智，哈哈哈...部署到线上就无人值守的投票了，来我网站的访客添个验证码就等于给我投一票，数据非常的真实。


``` python
# -*- coding: utf-8 -*-
from PyQt4 import QtCore, QtGui
from PyQt4.QtNetwork import QNetworkCookie, QNetworkCookieJar
from urllib import urlencode
from cookielib import LWPCookieJar, Cookie
import sys
import urllib2
import re
import json
from mails import mails

from main_ui import Ui_MainWindow

url_login = 'https://passport.alipay.com/login/login.htm?fromSite=6&params=%7B%22site%22%3A%226%22%2C%22ru%22%3A%22http%3A%2F%2Fdasai.aliyun.com%2Fsignup%2Fworks2013%2F%3Fspm%3D0.0.0.0.0BEnd1%22%7D'
url_vote = 'http://dasai.aliyun.com/signup/works2013/'

def toPyCookie(QtCookie):
  port = None
  port_specified = False
  secure = QtCookie.isSecure()
  name = str(QtCookie.name())
  value = str(QtCookie.value())
  v = str(QtCookie.path())
  path_specified = bool(v != "")
  path = v if path_specified else None
  v = str(QtCookie.domain())
  domain_specified = bool(v != "")
  domain = v
  if domain_specified:
    domain_initial_dot = v.startswith('.')
  else:
    domain_initial_dot = None
  v = long(QtCookie.expirationDate().toTime_t())
  # Long type boundary on 32bit platfroms; avoid ValueError
  expires = 2147483647 if v > 2147483647 else v
  rest = {}
  discard = False
  return Cookie(0, name, value, port, port_specified, domain,
          domain_specified, domain_initial_dot, path, path_specified,
          secure, expires, discard, None, None, rest)

class MainWindow(QtGui.QMainWindow):
  def __init__(self, parent=None):
    QtGui.QWidget.__init__(self, parent)
    self.ui = Ui_MainWindow()
    self.ui.setupUi(self)
    self.ConnectSignal()
    #self.ui.webView.load(QtCore.QUrl(r'http://dasai.aliyun.com/signup/works2013/'))
    self.ui.webView.load(QtCore.QUrl(url_vote))

    # listview
    self.listmodel = QtGui.QStandardItemModel()
    self.ui.listView.setModel(self.listmodel)
    self.loadList()
    # logview
    self.logmodel = QtGui.QStandardItemModel()
    self.ui.logView.setModel(self.logmodel)

  def ConnectSignal(self):
    QtCore.QObject.connect(self.ui.webView, 
        QtCore.SIGNAL("loadFinished(bool)"), self.rockit) 
    QtCore.QObject.connect(self.ui.listView, 
        QtCore.SIGNAL("clicked(QModelIndex)"), self.listviewClicked)
    QtCore.QObject.connect(self.ui.actionRefresh, 
        QtCore.SIGNAL("triggered()"), self.Refresh) 

  def Refresh(self):
    #QtGui.QMessageBox.information(self, u"刷新", 
    #    u"页面即将刷新 <b>importent!</b>" "<a href=\"http://jondy.net\">links</a>")
    #self.ui.webView.load(QtCore.QUrl(r'http://dasai.aliyun.com/signup/works2013/'))
    self.ui.webView.load(QtCore.QUrl(url_vote))

  def rockit(self):
    cookies = []  
    for citem in self.ui.webView.page().networkAccessManager().cookieJar() \
                .cookiesForUrl(QtCore.QUrl('http://dasai.aliyun.com/')):  
      cookies.append('%s=%s' % (citem.name(), citem.value()))  
    cookies = '; '.join(cookies)

    if 'login_aliyunid_ticket' in cookies and cookies.startswith('aydotcom_userinfo_portal'):
      # save cookies  
      uid = re.findall(r'login_aliyunid="(\S+)";', cookies)[0]
      if uid:
        try:
          open('/Users/zhangdi/Sites/alivote/cookies/%s' % uid, 'wb').write(cookies)
        except:
          pass
        # save lwpcookie
        filename = 'lwpcookies/%s' % uid
        lwp_cookiejar = LWPCookieJar()
        for citem in self.ui.webView.page().networkAccessManager().cookieJar() \
                    .cookiesForUrl(QtCore.QUrl('http://dasai.aliyun.com/')):  
          lwp_cookiejar.set_cookie(toPyCookie(citem))
        lwp_cookiejar.save(filename, ignore_discard=True)

      url = 'http://dasai.aliyun.com/signup/works2013/vote'
      purl = 'http://dasai.aliyun.com/signup/works2013/?search=241'
      req = urllib2.Request(purl)
      req.add_header( "Cookie" , cookies )
      res = urllib2.urlopen(req).read()
      token = re.findall(r'<input id="id_sec_token" name="sec_token" type="hidden" value="(\w+)" />', res)[0]

      data = (
          ('id', '241'),
          ('sec_token', token),
        )

      req = urllib2.Request(url, urlencode(data))
      req.add_header( "Cookie" , cookies )
      user_agent = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'
      req.add_header( "User-Agent", user_agent )

      for i in range(10):
        res = urllib2.urlopen(req).read()
        if res:
          try:
            msg = json.loads(res)
            item = QtGui.QStandardItem(msg['msg'])
            self.logmodel.appendRow(item)
          except:
            print res
      # 清除cookies
      cj = QNetworkCookieJar()
      self.ui.webView.page().networkAccessManager().setCookieJar(cj)
      self.ui.webView.load(QtCore.QUrl(url_vote))

  def loadList(self):
    for i in range(1,99+1):
      item = QtGui.QStandardItem(QtCore.QString(u'user%.2d@zhack.com' % i))
      self.listmodel.appendRow(item)
    for i in mails:
      item = QtGui.QStandardItem(QtCore.QString(i))
      self.listmodel.appendRow(item)

  def listviewClicked(self, qmodelindex):
    self.logmodel.clear() # 在这清除log
    self.item = qmodelindex.data(QtCore.Qt.DisplayRole).toString()
    print self.item
    current_frame = self.ui.webView.page().currentFrame()
    current_frame.evaluateJavaScript(
        r"""
          document.getElementById('fm-login-id').value = "%s";
          document.getElementById('fm-login-password').value = "xxxx";
          document.getElementById('fm-keep-login').checked = true;
        """ % self.item
    )

if __name__ == "__main__":
  try:
    import psyco
    psyco.full()
  except ImportError:
    pass
  
  app = QtGui.QApplication(sys.argv)
  form = MainWindow()
  form.resize(1280, 700)
  form.setWindowTitle('Icon')  #窗体标题
  form.setWindowIcon(QtGui.QIcon('main.png')) #窗体icon
  form.setToolTip('This is a <b>QWidget</b> widget') #提示，richedit格式文本
  #form.setFont(QtGui.QFont('OldEnglish', 10)) 

  # 居中
  sG = QtGui.QApplication.desktop().screenGeometry()
  x = (sG.width()-form.width()) / 2
  y = (sG.height()-form.height()) / 2
  form.move(x,y)

  form.show()
  form.raise_() # 窗体启动后在前边

  sys.exit(app.exec_())

```

### 有码版

``` python
#coding:utf-8# 
from PyQt4 import QtGui, QtCore, QtWebKit
from PyQt4.QtNetwork import *
from PyQt4.QtSql import * 
from datetime import datetime
import sys
import re
import os

PORT = 9999
SIZEOF_UINT32 = 4

url_login = 'https://passport.alipay.com/login/login.htm?fromSite=6&params=%7B%22site%22%3A%226%22%2C%22ru%22%3A%22http%3A%2F%2Fdasai.aliyun.com%2F%22%7D'
url_login = 'https://passport.alipay.com/login/login.htm?fromSite=6'
class Alivote(QtWebKit.QWebView):
  def Main(self):
    self.webView = QtWebKit.QWebView()
    self.webView.load(QtCore.QUrl(url_login))
    self.webView.show()
    self.webView.raise_()
    self.manager = self.webView.page().networkAccessManager()

    QtCore.QObject.connect(self.webView,QtCore.SIGNAL("loadFinished(bool)"),self.Load)
    #QtCore.QObject.connect(self.manager, QtCore.SIGNAL("finished(QNetworkReply *)"),self.proccess_finished)
    #self.manager.finished.connect(self.proccess_finished)

    self.url_checkCode = ''
    # timer
    self.timerCount = 0
    self.timer=QtCore.QTimer(self)
    self.connect(self.timer,QtCore.SIGNAL("timeout()"),self.timeOut)

    # server
    self.tcpServer = QTcpServer(self)               
    self.tcpServer.listen(QHostAddress("0.0.0.0"), PORT)
    self.connect(self.tcpServer, QtCore.SIGNAL("newConnection()"), 
                self.addConnection)
    self.connections = []

    # sqlite3
    self.query=QSqlQuery()
    #for f in os.listdir('../cookies'):
    #  self.query.exec_('insert into vote (username, password) values("%s", "xxxx");' % f)
    #self.query.exec_("commit")  
    self.data = self.rolldata()

  def timeOut(self):
    print self.url_checkCode
    print self.timerCount
    if self.timerCount > 3:
      self.timer.stop()
      print 'checkCode error'
    self.timerCount += 1

  def proccess_finished(self, reply):
    #print reply.header(QNetworkRequest.ContentTypeHeader).toString()
    url = reply.url().toString()
    #print url
    if 'https://passport.alipay.com/newlogin/login.do' in url:
      print dir(reply)
      print reply.readAll()
    reply.deleteLater()

  def imageDownloaded(self):
    reply = self.sender()
    print reply.readAll()

  def rolldata(self):
    query_str = 'SELECT * FROM %s WHERE vd=0;' % 'vote'
    self.query.prepare(query_str)
    self.query.exec_()
    self.query.first()
    data = {'pk':self.query.value(0).toString(),'username':self.query.value(1).toString(),'password':self.query.value(2).toString()}
    return data
    #  print self.query.value(0).toString(), self.query.value(1).toString().toUtf8()
    #  self.query.next()

  def loadcheckCode(self):
    js = '''
      $('#fm-login-id').val("%s");
      $('#fm-login-checkcode-update').click();
      //$("#fm-login-submit").click();
    ''' % self.data['username']
    self.webView.page().mainFrame().childFrames()[0].evaluateJavaScript(js)

  def Load(self):
    frame = self.webView.page().mainFrame()
    children = frame.childFrames()
    for citem in self.webView.page().networkAccessManager().cookieJar() \
                .cookiesForUrl(QtCore.QUrl('http://dasai.aliyun.com/')):  
      if citem.name() == 'login_aliyunid_ticket':
        print 'success', citem.value()
        self.timer.stop()
        print 'login success'
        self.query.exec_('update vote set vd=1, cookie="%s", latest="%s" where id=%s' % (citem.value(), 
                        datetime.now().strftime('%Y-%m-%d %H:%M:%S'), self.data['pk']))
        self.query.exec_("commit")  
        self.data = self.rolldata()
        cj = QNetworkCookieJar()
        self.webView.page().networkAccessManager().setCookieJar(cj)
        self.webView.load(QtCore.QUrl(url_login))
    #print len(children)
    #print '#\n'*3
    #print frame.url().toString()
    if 'passport.alipay.com/login/login.htm' in frame.url().toString():
      self.loadcheckCode()
    #print ''.join(frame.toHtml().toUtf8())
    html = []
    for x in children:
      html.append(str(x.toHtml().toUtf8()))
    checkCode = re.findall(r"sessionID=(\S+)'", ''.join(html))
    if checkCode:
      url_checkCode = 'https://pin.aliyun.com/get_img?identity=passport.alipay.com&sessionID=%s'
      self.url_checkCode = url_checkCode % checkCode[0]
    #print ''.join(html)

  def addConnection(self):
    clientConnection = self.tcpServer.nextPendingConnection()
    clientConnection.nextBlockSize = 0
    self.connections.append(clientConnection)

    self.connect(clientConnection, QtCore.SIGNAL("readyRead()"), self.receiveMessage)
    self.connect(clientConnection, QtCore.SIGNAL("disconnected()"), self.removeConnection)
    self.connect(clientConnection, QtCore.SIGNAL("error()"), self.socketError)

  def receiveMessage(self):
    for s in self.connections:
      if s.bytesAvailable() > 0:
        stream = QtCore.QDataStream(s)
        stream.setVersion(QtCore.QDataStream.Qt_4_2)

        if s.nextBlockSize == 0:
          if s.bytesAvailable() < SIZEOF_UINT32:
            return
          s.nextBlockSize = stream.readUInt32()
        if s.bytesAvailable() < s.nextBlockSize:
          return

        textFromClient = stream.readQString()
        text = textFromClient.toUtf8()
        text = str(text)
        if 'r' == text:
          #js = '''
          #  $('#fm-login-checkcode-update').click();
          #'''
          #self.webView.page().mainFrame().childFrames()[0].evaluateJavaScript(js)
          self.loadcheckCode()
        if 'c' == text:
          self.sendMessage(self.url_checkCode, s.socketDescriptor())
          js = '''
            $('#fm-login-id').val("%s");
            $("#fm-login-submit").click();
          ''' % self.data['username']
          self.webView.page().mainFrame().childFrames()[0].evaluateJavaScript(js)

        if len(text) == 4:
          # js:abcd
          checkCode = text.split(':').pop().strip()
          print checkCode
          js = '''
            $('#fm-login-id').val("%s");
            $('#fm-login-password').val("%s");
            $('#fm-login-checkcode').val("%s");
            $('#fm-keep-login').attr("checked","true");
            $("#fm-login-submit").click();
          ''' % (self.data['username'], self.data['password'], checkCode)
          self.webView.page().mainFrame().childFrames()[0].evaluateJavaScript(js)
          # sleep 3 如果验证码地址变了则登陆成功
          self.timerCount = 0
          self.timer.start(1000)
        ########################
        s.nextBlockSize = 0
        self.sendMessage(textFromClient, s.socketDescriptor())
        s.nextBlockSize = 0

  def sendMessage(self, text, socketId):
    for s in self.connections:
      if s.socketDescriptor() == socketId:
          message = "You> {}".format(text)
      else:
          message = "{}> {}".format(socketId, text)
      reply = QtCore.QByteArray()
      stream = QtCore.QDataStream(reply, QtCore.QIODevice.WriteOnly)
      stream.setVersion(QtCore.QDataStream.Qt_4_2)
      stream.writeUInt32(0)
      stream.writeQString(message)
      stream.device().seek(0)
      stream.writeUInt32(reply.size() - SIZEOF_UINT32)
      s.write(reply)

  def removeConnection(self):
    pass

  def socketError(self):
    pass

def createConnection(): 
  #选择数据库类型，这里为sqlite3数据库
  db=QSqlDatabase.addDatabase("QSQLITE") 
  #创建数据库test0.db,如果存在则打开，否则创建该数据库
  db.setDatabaseName("test0.db") 
  #打开数据库
  db.open() 
app = QtGui.QApplication(sys.argv)
createConnection()
web = Alivote()
web.Main()
app.exec_()

```

### 验证码显示和验证

``` python
def check_checkCode(code):
  client = socket.socket(socket.AF_INET,socket.SOCK_STREAM)  
  client.connect(('127.0.0.1', 9999)) 
  client.settimeout(3)
  client.send(code+'\r\n')
  try:
    res = int(client.recv(2))
  except:
    res = -1
  return res

def checkCode(request):
  url_checkCode = open(os.path.join(settings.PROJECT_DIR, 'bin/urlCheckCode.log')).read()
  data = urllib2.urlopen(url_checkCode).read()
  return HttpResponse(data, mimetype="image/jpeg")

```
