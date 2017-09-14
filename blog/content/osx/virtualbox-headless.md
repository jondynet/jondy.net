Title: VirtualBox 无界面启动虚拟机
Date: 2017-09-14 11:32
Category: Debian
Tags: linux
Slug: linux-top-pmap
Authors: zhangdi
Summary: linux下top及pmap命令的操作

在项目开发过程中我经常用一些虚拟机去模拟一些云端环境，VirtualBox可以实现无界面的启动虚拟机。

OS X 环境下的命令：
```
$ VBoxManage startvm Debian9
```

windows环境下的命令：

```
"c:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "Debian9" --type headless
```

