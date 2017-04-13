#coding:utf-8
# Last modified: 2016-07-14 19:07:37
# by zhangdi http://jondy.net/
import requests
import logging
import httplib

httplib.HTTPConnection.debuglevel = 1

logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)
requests_log = logging.getLogger("requests.packages.urllib3")
requests_log.setLevel(logging.DEBUG)
requests_log.propagate = True


data = {'id':'1042'}
#r = s.post(url2, data)
#print r.json().get('msg')


url = 'http://houtai.sdetv.com.cn/front/app/frontmostbeautifulteacher/open?code=011G9JTj0Cycuh1gLyVj0S7QTj0G9JTl&state=123'
s = requests.session()
s.headers['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
s.headers['User-Agent'] = 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13F69 MicroMessenger/6.3.22 NetType/WIFI Language/zh_CN'
s.headers['Accept-Language'] = 'zh-cn'
s.headers['Accept-Encoding'] = 'gzip, deflate'
s.headers['Connection'] = 'keep-alive'
s.headers['Cookie'] = 'laravel_session=eyJpdiI6IlZhYjIxK2ZtUldwMnNTSDBvZEI1K2c9PSIsInZhbHVlIjoidk1pY21aa3dVcnhONmNHQTJNdnB4NTFHb3hLWGNWV3VTaWVDTnprRk9SMmtMa1lEdnNMcFZYTUlBVWhlNlkrYzBEa0J2dEtSWTA1dlNRWjVJRlNMcEE9PSIsIm1hYyI6ImVhODUxNGI2ZjY4ZjI1NzVmYjg4YmE2NTc4OTAzZWEyZmM1YTNmMzU1NmE1YjNlMmJlOTQ4ZDE2ZjAxNWUzM2YifQ%3D%3D'

print s.get(url).content

