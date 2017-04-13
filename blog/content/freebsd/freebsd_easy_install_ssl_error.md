Title: Freebsd下Python easy_install 提示 [SSL: CERTIFICATE_VERIFY_FAILED] 错误修复
Date: 2016-06-12 13:37:05
Category: FreeBSD
Tags: FreeBSD
Slug: freebsd-easy_install-ssl-error
Authors: zhangdi
Summary: Freebsd下Python easy_install 提示 [SSL: CERTIFICATE_VERIFY_FAILED] 错误修复

### 错误提示

easy_install \[SSL: CERTIFICATE_VERIFY_FAILED\] certificate verify failed

\[SSL: CERTIFICATE_VERIFY_FAILED\] certificate verify failed

In FreeBSD 10.1 it can be quickly fixed doing:

<!-- more -->

### 修复方式

``` bash
pkg install ca_root_nss

cat /etc/ssl/cert.pem # 确认证书存在
```
