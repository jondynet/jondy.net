Title: Python BaseHTTPServer 响应POST请求
Date: 2014-12-05 16:04:46
Category: Python
Slug: python-BaseHTTPServer-response-post
Authors: zhangdi
Summary: Python BaseHTTPServer 响应POST请求

### Python BaseHTTPServer 响应POST请求

```python
#coding:utf-8
# Last modified: 2014-12-05 16:04:46
# by zhangdi http://jondy.net/
import BaseHTTPServer
import urlparse
rs = '''<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><CDKDSAOIUOCXZResponse xmlns="http://www.hongtu66.com/"><CDKDSAOIUOCXZResult>0</CDKDSAOIUOCXZResult></CDKDSAOIUOCXZResponse></soap:Body></soap:Envelope>
'''
class WebRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_POST(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(rs)

server = BaseHTTPServer.HTTPServer(('0.0.0.0',2014), WebRequestHandler)
server.serve_forever()
```
