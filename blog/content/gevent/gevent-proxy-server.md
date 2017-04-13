Title: 代码片段：gevent的代理服务器
Date: 2015-01-30 00:20
Modified: 2015-01-30 00:30
Category: Python
Tags: gevent
Slug: gevent-proxy-server
Authors: zhangdi
Summary: 代码片段

```python
#coding:utf-8
# Last modified: 2015-01-30 00:12:22
# by zhangdi http://jondy.net/
import sys
import signal
import urlparse
import gevent
from gevent.server import StreamServer
from gevent.socket import create_connection, gethostbyname


class ProxyServer(StreamServer):
    def __init__(self, listener, **kwargs):
        StreamServer.__init__(self, listener, **kwargs)

    def handle(self, client, address):
        log('%s:%s accepted', *address[:2])
        try:
            line1 = ''
            while True:
                _data = client.recv(1)
                line1 += _data
                if not _data or _data == '\n':
                    break
            if line1:
                print (line1)
                remote_path = parse_address(line1.split()[1])
                remote = create_connection(remote_path)
                remote.sendall(line1)
                source_address = '%s:%s' % client.getpeername()[:2]
                dest_address = '%s:%s' % remote.getpeername()[:2]
                log("Starting port forwarder %s -> %s",source_address,dest_address)                 
                gevent.spawn(forward, client, remote)
                gevent.spawn(forward, remote, client) 
            
            else:
                client.close()
                return  

            
        except IOError, ex:
            log('failed : %s', ex)
            import traceback
            traceback.print_exc()
            return


    def close(self):
        if self.closed:
            sys.exit('Multiple exit signals received - aborting.')
        else:
            log('Closing listener socket')
            StreamServer.close(self)


def forward(source, dest):
    source_address = '%s:%s' % source.getpeername()[:2]
    dest_address = '%s:%s' % dest.getpeername()[:2]
    try:
        while True:
            data = source.recv(1024)
            if not data:
                break
            log('%s->%s: %r bytes', source_address, dest_address, len(data))
            dest.sendall(data)
    finally:
        source.close()
        dest.close()


def parse_address(address):
    try:
        urls = urlparse.urlparse(address)
        address = urls.netloc or urls.path
        _addr = address.split(':')
        hostname, port = len(_addr) == 2 and  _addr or (_addr[0],80)
        port = int(port)
    except ValueError:
        sys.exit('Expected HOST:PORT: %r' % address)
    return gethostbyname(hostname), port

def main():
    server = ProxyServer(('0.0.0.0',8087))
    log('Starting proxy server %s:%s', *(server.address[:2]))
    gevent.signal(signal.SIGTERM, server.close)
    gevent.signal(signal.SIGINT, server.close)
    server.start()
    gevent.run()


def log(message, *args):
    message = message % args
    sys.stderr.write(message + '\n')


if __name__ == '__main__':
    main()

```
