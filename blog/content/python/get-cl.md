Title: 下载草榴的种子填充网盘
Date: 2016-08-28 17:05
Modified: 2016-08-28 18:06:54
Category: Python
Tags: requests
Slug: get-cl
Authors: zhangdi
Summary: 整理一下这些年我是如何下载草榴社区的种子填充网盘的

### 下载草榴社区的种子填充网盘

整理一下这些年我是如何下载草榴社区的种子填充网盘的

哥们在一起就那么点事，偶尔谈到大毛，向来主张程序解放劳动力我难免要装逼一下，所以有了这一些列的脚本。

并没有把这个做的多么的智能，没做成一整套全自动的功能，分了几个步骤:

* 脚本去访问草榴论坛某一分类前20页的所有页面url取回来存在一个urls.txt中
* 用wget 或curl 把页面html全部下载到tmpl目录里
* 分析页面，找到下载链接，去下载链接下载种子
* 把种子转成ed2k链接或磁力链接输出
* 百度盘cookie登录自动添加到离线任务
* 115盘复制前面生成的磁力链接，批量添加

功能拆得这么零散是想有空的时候深入的分析一下页面挖掘一下，但显然到今天整理代码写这篇博客的时候也没去做这事。
偶尔用到的时候也没觉得麻烦，打三个命令就可以了。
所以以后也不一定继续更新这个，整理一下过程留个纪念。

### 获取前20页帖子的地址

有时候我会在国外的vps上执行，有时候用国内可访问草榴的域名来执行，
所以把域名作为一个参数传入。fid是对应的板块，最后page分页，所以很好组合url，
不用过多的去访问页面。

```python
url = 'http://%s/thread0806.php?fid=4&search=&page=' % domain

def getcl(url):
  r = requests.get(url)
  try:
    res = r.content.decode('gbk')
  except:
    res = r.content
  fp = open('urls.txt', 'wb')
  for r in re.findall(r'htm_data(.*)\.html', res):
    fp.write('http://%s/htm_data%s.html\n' % (domain, r))
  fp.close()

for i in range(1,20):
  newurl = url+str(i)
  try:
    getcl(newurl)
  except:
    try:
      getcl(newurl)
    except:
      try:
        getcl(newurl)
      except:
        getcl(newurl)
```

### 用curl 下载页面到tmp目录

用curl的好处是可以很方便的指定代理服务器或者其他http参数

```bash
for i in $(cat ../urls.txt) ; do curl -O $i ; done
```

### 解析页面下载种子转成ed2k或者磁力链接

所以下载地址里最规整的就是来自rmdown的了，使用频率也是最高，这背后一定有故事，
哈哈哈，不过这么好的华人社区我还是不要去研究它了。

去下载种子，根据需要转成ed2k或者磁力链接。

```python
import requests
import bencode
import hashlib
import base64
import urllib
import re
import sys
import os
import re

def getmagnet(torrent):
  try:
    metadata = bencode.bdecode(torrent)
  except:
    return
  hashcontents = bencode.bencode(metadata['info'])
  digest = hashlib.sha1(hashcontents).digest()
  b32hash = base64.b32encode(digest)
  b32hash = hashlib.sha1(hashcontents).hexdigest()
  params = {'xt': 'urn:btih:%s' % b32hash,
             'dn': metadata['info']['name'],
             'tr': metadata['announce'],
             'xl': metadata['info']['piece length']}
  paramstr = urllib.urlencode(params)
  magneturi = 'magnet:?%s' % paramstr
  magneturi = 'magnet:?xt=urn:btih:%s&dn=%s&tr=%s' % (b32hash, metadata['info']['name'], metadata['announce'])
  print magneturi

def geted2k(_hash):
  #print sys.argv[1]
  #sys.exit(0)
  s = requests.session()
  r= s.get('http://www.rmdown.com/link.php?hash=%s' % _hash)
  txt = r.text
  ref = re.findall(r'name="ref" value="(\w+)"', txt)[0]
  reff= re.findall(r'NAME="reff" value="(.*?)"', txt)[0]
  #print ref, reff
  playload = (
    ('ref', ref),
    ('reff', reff),
    ('submit', 'download')
  )
  r = s.post('http://www.rmdown.com/download.php', data=playload)
  torrent = r.content
  # get ed2k
  #try:
  #  metadata = bencode.bdecode(torrent)
  #except:
  #  #print torrent
  #  #sys.exit(0)
  #  return
  #for f in metadata['info']['files']:
  #  if f.has_key('ed2k'):
  #    # ed2k://|file|<文件名称>|<文件大小>|<文件哈希值>|/
  #    if f['length'] > 1024*1024*500:
  #      print 'ed2k://|file|%s|%s|%s|/' % (''.join(f['path']), f['length'], f['ed2k'].encode('hex_codec'))
  getmagnet(torrent)

for root,dirs,files in os.walk('cl/tmp'):
  for fn in files:
    #print fn
    c = open('cl/tmp/%s' % fn).read()
    #print '<div>%s</div>' % fn
    cs = re.findall(r"<img src='(.*?)'", c)
    cs = re.findall(r"http://www.rmdown.com/link.php\?hash=(\w+)", c)
    for u in cs:
      #print 'http://www.rmdown.com/link.php?hash=%s' % u
      geted2k(u)
```

如果用115到这步就可以了。批量添加->确定->确定....

百度网盘从净网开始，对内容作了过滤，之前我测试如果把种子里的其他标题明显的东东删掉，
是可以食用百度网盘离线下载的，不过用ed2k更简单, 很多种子里有提供ed2k链接的。

百度网盘也没有批量添加，新一点的资源开始还能看，不久大部分用都被净网了。。。
这就很讨厌，不过在开始没怎么净网的时候我还是弄了个导入的功能，前几个可以自动导入，
后边的要填验证码，这种还是用qtwebkit来做，手动打码嘛，准备好程序让想看片人打码嘛，哈哈哈。

```python
cookiesfile = '' 
posturl = ''

cookies={}
for line in cookiesfile.split(';'):
  #其设置为1就会把字符串拆分成2份
  name,value=line.strip().split('=',1)
  cookies[name]=value

def post(e2dk, code, vcode):
  data = {
      'method':'add_task',
      'app_id':xxxx,
      'source_url': e2dk,
      'save_path':'/',
      'type': 3,
    }
  if code and vcode:
    data['input'] = code
    data['vcode'] = vcode

  r = requests.post(posturl, data, cookies=cookies)
  rs = json.loads(r.text)
  return rs

class Form(QDialog):
  def __init__(self, parent=None):
    super(Form, self).__init__(parent)

    self.ed2ks = open('cl/ed2k').readlines()
    self.ed2k = self.ed2ks.pop()
    self.lbl = QLabel()
    self.lbl.setGeometry(10,10,200,80)
    self.txt = QTextBrowser()
    self.edt = QLineEdit()
    self.edt.setFocus()
    btn = QPushButton(u'ok')
    layout = QVBoxLayout()
    layout.addWidget(self.txt)
    layout.addWidget(self.lbl)
    layout.addWidget(self.edt)
    layout.addWidget(btn)
    self.setLayout(layout)
    self.connect(btn, SIGNAL('clicked()'), self.push)
    self.code = None
    self.vcode = None

  def push(self):
    self.code = self.edt.text()
    #ed2k = 'ed2k://|file|dioguitar23.net_SKYHD-120.iso|18813091840|7c724afefc52153daf68114a6238a59b|/'
    rs = post(self.ed2k, self.code, self.vcode)
    print rs
    #print rs
    if rs.has_key('img'):
      pic = QPixmap()
      pic.loadFromData(requests.get(rs['img']).content)
      self.lbl.setPixmap(pic)
      self.vcode = rs['vcode']
    else:
      self.code = None
      self.vcode = None
    if rs.has_key('rapid_download'):
      self.txt.append(self.ed2k.split('|')[2].decode('utf-8'))
      cursor = self.txt.textCursor()
      cursor.movePosition(QTextCursor.End)
      self.txt.setTextCursor(cursor)
      self.code = None
      self.vcode = None
      self.lbl.clear()
      self.edt.clear()
      try:
        self.ed2k = self.ed2ks.pop()
      except IndexError:
        QMessageBox.information(self, "info", u"队列空！" )

app = QApplication(sys.argv)
form = Form()
form.show()
form.raise_()
app.exec_()
```

cookie和posturl在浏览器调试里看

另外网上的各种种子搜索神器和网站的数据用起来更容易，只是片子质量远远不如大草榴呀。

娱乐一下, enjoy it!

