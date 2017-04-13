#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import os.path

dirname = lambda x: os.path.dirname(x)
BASE_DIR = dirname(dirname(dirname(os.path.abspath(__file__))))
CONTENT_DIR = os.path.join(BASE_DIR, 'blog', 'content')

PLUGINS = ['autostatic', ]

AUTHOR = u'jondynet &lt;jondynet@gmail.com&gt;'
SITENAME = u'迪哥的技术博客'
SITEURL = ''

# 输出
#ARTICLE_SAVE_AS = '{date:%Y}/{category}/{slug}/index.html'
#ARTICLE_URL = '{date:%Y}/{category}/{slug}/'
ARTICLE_SAVE_AS = '{category}/{slug}/index.html'
ARTICLE_URL = '{category}/{slug}/'

# 路径都加进来
ARTICLE_PATHS = []
for parent,dirnames,filenames in os.walk(CONTENT_DIR):
  for dirname in  dirnames:
    ARTICLE_PATHS.append(os.path.join(parent, dirname))

TIMEZONE = 'Asia/Shanghai'

DEFAULT_LANG = u'cn'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

LINKS = (
        ('分类查看', '/categories.html'),
        ('Tags', '/tags.html'),
        ('Archives', '/archives.html'),
        ('Github', 'https://github.com/jondynet'),
        ('返回首页', '/'),
      )

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
