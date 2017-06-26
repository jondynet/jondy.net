Title: linux screen 会话名字的使用
Date: 2017-05-10 11:11
Modified: 2017-05-10 14:02:03
Category: Debian
Tags: screen
Slug: linux-screen-sessionname
Authors: zhangdi
Summary: linux screen 会话名字的创建、修改和召回

多人同时在测试服务器上使用screen会有多个session基本上记不住哪个是自己的。

![PNG]({static|linux-screen-sessionname/image1.png} "Image title")

ctrl+a :sessionname my_screen_name
即可。

当然，最好是在启动screen的时候用screen -S
my_screen_name来直接指定名字。
