Title: Python命令行彩色输出
Date: 2015-01-29 18:06:19
Modified: 2016-08-21 19:07:56
Category: Python
Slug: python-console-color-output
Authors: zhangdi
Summary: Python命令行彩色输出


```python
#coding:utf-8
# Last modified: 2015-01-29 18:06:19
# by zhangdi http://jondy.net/
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

print bcolors.WARNING + "Warning: No active frommets remain. Continue?" + bcolors.ENDC
```
