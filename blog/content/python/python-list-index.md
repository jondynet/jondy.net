Title: python list index 重复数据位置的问题
Date: 2015-07-13 20:00:00 +0800
Modified: 2016-07-13 20:00:00 +0800
Category: Python
Slug: python-list-index
Authors: zhangdi
Summary: python list index 重复数据位置的问题

群里一个小伙伴的问题，怎么在一个list里找到一个元素的位置，
我告诉他用index，然后问题来了

这index 不靠谱好吧 

```python
lists=[1,2,1,2]
lists.index(1) 这都不知道 是第一个1还是第二个1
```

呵呵，Python 一切都是对象

{% highlight python %}
import random
import ctypes

lists=["1","2","a1","1"]
item=random.choice(lists)
print lists.index(item)
item=random.choice(map(id,lists))
print ctypes.cast(item, ctypes.py_object).value
{% endhighlight %}


