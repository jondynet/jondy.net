Title: python tcp socket 一些参数
Date: 2016-09-12 10:10
Modified: 2016-09-12 10:10:50
Category: Python
Tags: socket
Slug: python-tcp-socket
Authors: zhangdi
Summary: python tcp socket 一些参数

### server端 长连接，短连接，心跳

```python
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((host, port))
server.listen(1) # 接收的连接数
client, address = server.accept() # 因为设置了接收连接数为1，所以不需要放在循环中接收
while True: # 循环收发数据包，长连接
    data = client.recv(BUF_SIZE)
    print(data.decode()) # python3 要使用decode
    # client.close() #连接不断开，长连接

```

### client 端

```python
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 在客户端开启心跳维护
client.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
try:
  client.connect((host, port))
except:
  client.close()
  time.sleep(1)
  conn()
while True:
  try:
    client.send('hello world\r\n'.encode())
  except:
    client.close()
    time.sleep(1)
  print('send data')
  # 如果想验证长时间没发数据，SOCKET连接会不会断开，则可以设置时间长一点
  time.sleep(1)
```
