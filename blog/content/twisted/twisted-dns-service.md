Title: Python DNS服务端
Date: 2014-08-21 19:07
Modified: 2016-08-21 19:07:21
Category: Python
Tags: Twisted, h4ck
Slug: twisted-dns-service
Authors: zhangdi
Summary: Python fake DNS

Python实现的DNS服务端

做DNS欺骗的神器啊，哈哈

```python
#! /usr/bin/env python
import socket

#IP = ""
#if IP == "":
#    IP = socket.gethostbyname(socket.gethostname())
#print "IP: ", IP

class DNSQuery:
  def __init__(self, data):
    self.data=data
    self.domain=''
    tipo = (ord(data[2]) >> 3) & 15
    if tipo == 0:
      ini=12
      lon=ord(data[ini])
      while lon != 0:
        self.domain+=data[ini+1:ini+lon+1]+'.'
        ini+=lon+1
        lon=ord(data[ini])

  def respuesta(self, ip):
    packet=''
    if self.domain:
      packet+=self.data[:2] + "\x81\x80"
      packet+=self.data[4:6] + self.data[4:6] + '\x00\x00\x00\x00'
      packet+=self.data[12:]
      packet+='\xc0\x0c'
      packet+='\x00\x01\x00\x01\x00\x00\x00\x3c\x00\x04'
      packet+=str.join('',map(lambda x: chr(int(x)), ip.split('.')))
    return packet

if __name__ == '__main__':
  udps = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  udps.bind(('0.0.0.0',53))

  while 1:
    try:
      data, addr = udps.recvfrom(1024)
      p = DNSQuery(data)
      #ip = "10.10.10.10"
      ip = "192.168.0.10"
      udps.sendto(p.respuesta(ip), addr)
      print p.domain + "=>" + ip
    except KeyboardInterrupt:
      udps.close()
      break
    except:
      udps.close()
      udps = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
      udps.bind(('',53))  
```

### Twisted 版本

```python
#!/usr/bin/env python
# -*- test-case-name: twisted.names.test.test_examples -*-

# Copyright (c) Twisted Matrix Laboratories.
# See LICENSE for details.

"""
Print the SRV records for a given DOMAINNAME eg

 python dns-service.py xmpp-client tcp gmail.com

SERVICE: the symbolic name of the desired service.

PROTO: the transport protocol of the desired service; this is usually
       either TCP or UDP.

DOMAINNAME: the domain name for which this record is valid.
"""

import sys

from twisted.names import client, error
from twisted.internet.task import react
from twisted.python import usage



class Options(usage.Options):
    synopsis = 'Usage: dns-service.py SERVICE PROTO DOMAINNAME'

    def parseArgs(self, service, proto, domainname):
        self['service'] = service
        self['proto'] = proto
        self['domainname'] = domainname



def printResult(records, domainname):
    """
    Print the SRV records for the domainname or an error message if no
    SRV records were found.
    """
    answers, authority, additional = records
    if answers:
        sys.stdout.write(
            domainname + ' IN \n ' +
            '\n '.join(str(x.payload) for x in answers) +
            '\n')
    else:
        sys.stderr.write(
            'ERROR: No SRV records found for name %r\n' % (domainname,))



def printError(failure, domainname):
    """
    Print a friendly error message if the domainname could not be
    resolved.
    """
    failure.trap(error.DNSNameError)
    sys.stderr.write('ERROR: domain name not found %r\n' % (domainname,))



def main(reactor, *argv):
    options = Options()
    try:
        options.parseOptions(argv)
    except usage.UsageError as errortext:
        sys.stderr.write(str(options) + '\n')
        sys.stderr.write('ERROR: %s\n' % (errortext,))
        raise SystemExit(1)

    resolver = client.Resolver('/etc/resolv.conf')
    domainname = '_%(service)s._%(proto)s.%(domainname)s' % options
    d = resolver.lookupService(domainname)
    d.addCallback(printResult, domainname)
    d.addErrback(printError, domainname)
    return d



if __name__ == '__main__':
    react(main, sys.argv[1:])
```
