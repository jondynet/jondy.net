Title: tzsp
Date: 2016-08-01 10:20
Modified: 2016-08-21 19:07:42
Category: Python
Tags: tzsp
Slug: tzsp
Authors: zhangdi
Summary: TaZmen Sniffer Protocol (TZSP) is an encapsulation protocol used to wrap other protocols. It is commonly used to wrap 802.11 wireless packets to support Intrusion Detection Systems (IDS), wireless tracking, or other wireless applications.

下半年要研究的东西

TaZmen Sniffer Protocol (TZSP) is an encapsulation protocol used to wrap other protocols. It is commonly used to wrap 802.11 wireless packets to support Intrusion Detection Systems (IDS), wireless tracking, or other wireless applications.

```python
import socket
import sys
from struct import *

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Bind the socket to the port
server_address = ('0', 37008)
print >>sys.stderr, 'starting up on %s port %s' % server_address
sock.bind(server_address)
 
# receive a packet
while True:
    packet = sock.recvfrom(65565)
     
    #packet string from tuple
    packet = packet[0]
     
    #ip_header = packet[0:4]
    #iph = unpack('!I' , ip_header)
    #print iph
    #continue
    #take first 20 characters for the ip header
    ip_header = packet[0:20]
     
    #now unpack them :)
    iph = unpack('!BBHHHBBH4s4s' , ip_header)
     
    version_ihl = iph[0]
    version = version_ihl >> 4
    ihl = version_ihl & 0xF
     
    iph_length = ihl * 4
     
    ttl = iph[5]
    protocol = iph[6]
    s_addr = socket.inet_ntoa(iph[8]);
    d_addr = socket.inet_ntoa(iph[9]);
     
    print 'Version : ' + str(version) + ' IP Header Length : ' + str(ihl) + ' TTL : ' + str(ttl) + ' Protocol : ' + str(protocol) + ' Source Address : ' + str(s_addr) + ' Destination Address : ' + str(d_addr)
     
    tcp_header = packet[iph_length:iph_length+20]
     
    #now unpack them :)
    tcph = unpack('!HHLLBBHHH' , tcp_header)
     
    source_port = tcph[0]
    dest_port = tcph[1]
    sequence = tcph[2]
    acknowledgement = tcph[3]
    doff_reserved = tcph[4]
    tcph_length = doff_reserved >> 4
     
    print 'Source Port : ' + str(source_port) + ' Dest Port : ' + str(dest_port) + ' Sequence Number : ' + str(sequence) + ' Acknowledgement : ' + str(acknowledgement) + ' TCP header length : ' + str(tcph_length)
     
    h_size = iph_length + tcph_length * 4
    data_size = len(packet) - h_size
     
    #get data from the packet
    data = packet[h_size:]
     
    print 'Data : ' + data
    print

```

### 再收藏一段twisted的

```python
from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor
from twisted.internet.task import LoopingCall
from struct import *
import sys, time
import socket

class HeartbeatReciever(DatagramProtocol):
  def __init__(self):
    pass

  def startProtocol(self):
    "Called when transport is connected"
    pass

  def stopProtocol(self):
    "Called after all transport is teared down"


  def datagramReceived(self, data, (host, port)):
    #now = time.localtime(time.time())  
    #timeStr = str(time.strftime("%y/%m/%d %H:%M:%S",now)) 
    #print "received %r from %s:%d at %s" % (data, host, port, timeStr)
    data = data[72:]
    ip_header = data[0:20]
     
    #now unpack them :)
    iph = unpack('!BBHHHBBH4s4s',ip_header)

    version = iph[0] >> 4 #Version
    ihl = iph[0] * 0xF    #IHL
    iph_length = ihl * 4  #Total Length
    ttl = iph[5]
    protocol = iph[6]
    s_addr = socket.inet_ntoa(iph[8])
    d_addr = socket.inet_ntoa(iph[9])

    print 'Version : ' + str(version) + ' IHL : ' + str(ihl) + ' TTL : ' + str(ttl) + ' Protocol : ' + str(protocol) + ' Source Address : ' + str(s_addr) + ' Destination Address : ' + str(d_addr)

reactor.listenMulticast(37008, HeartbeatReciever(), listenMultiple=True)
reactor.run()
```
