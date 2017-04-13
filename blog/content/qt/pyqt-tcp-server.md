Title: PyQt TCP Server
Date: 2013-10-13 20:00:00 +0800
Modified: 2013-10-13 20:00:00 +0800
Category: Python
Tags: PyQt4
Slug: pyqt-tcp-server
Authors: zhangdi
Summary: pyqt4 tcp server

### PyQt TCP Server

<!-- more -->

``` python
from PyQt4.QtGui import *
from PyQt4.QtCore import *
import sys
from PyQt4.QtNetwork import *

SIZEOF_UINT32 = 4

class Tcp_server(QWidget):
  def __init__(self,parent = None):
    super(Tcp_server,self).__init__(parent)
    self.label = QLabel('waiting for connecting')
    layout = QGridLayout()
    layout.addWidget(self.label,0,0)
    self.setLayout(layout)
    self.setWindowTitle("Server")

    self.tcpServer = QTcpServer()
    if not self.tcpServer.listen(QHostAddress.LocalHost,6666):
      print self.tcpServer.errorString()
      self.close()
    self.connect(self.tcpServer, SIGNAL("newConnection()"), self.addConnection)
    self.connections = []

  def addConnection(self):
    clientConnection = self.tcpServer.nextPendingConnection()
    clientConnection.nextBlockSize = 0
    self.connections.append(clientConnection)
    self.connect(clientConnection, SIGNAL("readyRead()"), self.receiveMessage)
    self.connect(clientConnection, SIGNAL("disconnected()"), self.removeConnection)
    self.connect(clientConnection, SIGNAL("error()"), self.socketError)

  def receiveMessage(self):
    for s in self.connections:
      print s.read(4)
      self.sendMessage()
      s.disconnectFromHost()
      self.connections.remove(s)

  def sendMessage(self):
    for s in self.connections:
      s.write('hello\n')
      s.disconnectFromHost()
    self.label.setText("send message successful")
  def removeConnection(self):
    pass

  def socketError(self):
    pass
                
app = QApplication(sys.argv)
form = Tcp_server()
form.show()
app.exec_()

```
