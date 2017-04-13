Title: 总数切分若干随机数的方法－类似微信红包
Date: 2016-02-25 16:07:15 +0800
Modified: 2016-02-25 16:07:15 +0800
Category: Python
Tags: django, random
Slug: python-random-sum-splite
Authors: zhangdi
Summary: 总数切分若干随机数的方法－类似微信红包

最近做了一个类似“摇一摇红包“的功能，html5实现。好处是不依赖微信，大部分智能机都能用。
方便现场做活动，扫二维码直接参与。

这个功能的需要的一个算法：总额100的红包分成若干个随机大小的红包,下边是python实现。

``` python
#coding:utf-8
import random

PARTS       = 10
TOTAL       = 100
PLACES      = 3

def random_sum_split(parts, total, places):

    a = []
    for n in range(parts):
        a.append(random.random())
    b = sum(a)
    c = [round(x/b, 4) for x in a]    
    d = sum(c)
    e = c
    if places != None:
        e = [round(x*total, places) for x in c]
    f = e[-(parts-1):]
    g = total - sum(f)
    if places != None:
        g = round(g, places)
    f.insert(0, g)

    return f   

if __name__ == '__main__':
  alpha = random_sum_split(PARTS, TOTAL, PLACES)

  print 'alpha: %s' % alpha
  print 'total: %.2f' % sum(alpha)
  print 'parts: %s' % PARTS
  print 'places: %s' % PLACES

```

### 2016年8月15日更新

今天有位童鞋说这个有可能产生0.0的数据，这是因为random.random()产生的是0到1的随机数，
小数点后边位数多的数不清啊，囧。所以把这句换成random.uniform(0.01,1.0)就好了，
uniform是可以指定范围的。
