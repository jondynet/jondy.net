Title: 阿里云django channels 没有响应的问题
Date: 2016-10-31 14:04:03
Category: django
Tags: "django channels",redis
Slug: django-channels-redis-not-responsing
Authors: zhangdi
Summary: 阿里云django channels 没有响应的问题
#############################################

### 问题表现

项目部署以后访问页面挂起，超时后报错503

小应用没舍得买阿里云的redis服务，自己在ECS里apt-get安装的redis

线下测试没毛病，上线就sb了，
virtualenv的python环境，阿里云的pip安装有时候会报错啊，
但不要紧，所以开始以为依赖关系的事，仔细检查了以下并没有什么卵用啊。。。

于是开始怀疑是redis，这玩意我头一次在django里用，
先把设置改到内存试了下果然正常了

   "BACKEND": "asgiref.inmemory.ChannelLayer",

还好同时在cache里也用了redis，所以就拿django.core.cache测试，
果然这货只能get，不能set，google了一下有人说是python redis的版本的事，
于是降级，然而并没什么卵用。。。

于是考虑问题不在python这，看了一下测试环境redis是3.x的，阿里云debian里装的是2.x

我擦嘞，果然....

手动安装了redis后解决。
