Title: nodejs和python接口aes加密的方式
Date: 2017-07-28 10:10
Modified: 2017-07-28 14:02:46
Category: Python, nodejs
Tags: AES
Slug: nodejs-python-aes
Authors: zhangdi
Summary: nodejs和python接口aes加密的代码记录

记录一些代码片段

## python 部分

```python
#coding:utf-8
# Last modified: 2017-05-27 15:03:52
# by zhangdi <http://jondy.net/>
import json
import requests
from Crypto.Cipher import AES

key   = '<you key>'
iv    = '<you iv>'
url   = 'http://www.wlan-china.com/api/huaxi/'

data = {
    'ipaddr': '172.16.11.1',
    'expired': 86400,
}

# 补位
pad = lambda s: s + (AES.block_size - len(s) % AES.block_size) \
    * chr(AES.block_size - len(s) % AES.block_size) 

text = pad(json.dumps(data))
#text = pad('hello')
cryptor = AES.new(key,AES.MODE_CBC,iv)
ciphertext = cryptor.encrypt(text)
#把加密后的字符串转化为base64字符串
data = ciphertext.encode('base64')
data = 'aTlYN09LTGRIMEI5ZHMxVXl3a3ZKZ0ZtNVgrM2R4NlFZSGZCQkIvUm9OS21TaFpKcjJCcW9FRTdMZGRBMjY2bw=='.decode('base64')
print data

req = requests.post(url, data=data)
print req.content
```

## nodejs 部分, 数据加密后模拟客户端调用

```javascript
var crypto = require('crypto');
var http = require('http');  

var encrypt = function (key, iv, data) {
    var cipher = crypto.createCipheriv('aes-128-cbc', key, iv);
    var crypted = cipher.update(data, 'utf8', 'binary');
    crypted += cipher.final('binary');
    crypted = new Buffer(crypted, 'binary').toString('base64');
    return crypted;
};

var key = '<your key>';
var iv = '<your iv>';
var data = '{"ipaddr":"192.168.88.36", "expired": 123456789.0123}';
var crypted = encrypt(key, iv, data);

console.log("data:", data);
console.log("crypted:", crypted);

var options = {  
    hostname: 'www.wlan-china.com',  
    port: 80,  
    path: '/api/huaxi/',
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Length': crypted.length
    }
};

var req = http.request(options, function (res) {  
    console.log('STATUS: ' + res.statusCode);  
    res.setEncoding('utf8');  
    res.on('data', function (chunk) {  
        console.log('BODY: ' + chunk);  
    });  
});  
req.write(crypted);
req.end();
```

## crypto-js 的加密方式

客户那边的开发人员用这货加密，也一并看看

```javascript
var CryptoJS = require("crypto-js");

var key = CryptoJS.enc.Utf8.parse('<your key>');
var iv = CryptoJS.enc.Utf8.parse('<your iv>');
var data = '{"ipaddr":"192.168.88.36", "expired": 1234567890123}';
var crypted = CryptoJS.AES.encrypt(data, key, {iv: iv,mode:CryptoJS.mode.CBC}).toString()

console.log(crypted);
```

