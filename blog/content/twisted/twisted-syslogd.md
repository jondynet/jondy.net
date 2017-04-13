Title: Twisted syslog 服务端
Date: 2011-08-21 21:09
Category: Python
Tags: twisted, syslog
Slug: twisted-syslogd
Authors: zhangdi
Summary: Twisted syslog 服务端

Twisted 官网上找的例子，临时起个syslog接收一些网络设备的日志，日常网络设备调试时很方便的脚本。

```python
#!/usr/bin/env python

# Copyright (c) Twisted Matrix Laboratories.
# See LICENSE for details.

from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor

# Here's a UDP version of the simplest possible protocol
class EchoUDP(DatagramProtocol):
    def datagramReceived(self, datagram, address):
        # self.transport.write(datagram, address)
        if 'GET' in datagram:
            print address, datagram

def main():
    reactor.listenUDP(5140, EchoUDP())
    reactor.run()

if __name__ == '__main__':
    main()
```
