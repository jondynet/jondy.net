Title: 开始OpenWRT-从定制profile开始
Date: 2016-11-21 16:04
Category: Debian
Tags: openwrt
Slug: openwrt-profile
Authors: zhangdi
Summary: 一些OpenWRT的工作记录

#添加新的profile

```
# cp 000-Generic.mk 001-myprofile.mk
# vim 001-myprofile.mk 
```

修改myprofile.mk的内容。

特别提醒：

1. profile文件的格式一定要书写正确。特别是 “\”反斜杠后面，千万不能有空格，否则会导致mt7620a整个subtarget都消失不见。
2. 注意package之间的依赖关系，如kmod-ac97 kmod-sound-soc-core kmod-sound-mt7620都依赖于kmod-sound-core，那么就应该按照先后顺序依次写出，同样的道理：kmod-ac97 kmod-sound-soc-core应该出现在kmod-sound-mt7620前面。（有没有更简便的方法自动实现这种依赖关系，还希望知道的童鞋告诉我）
3. 必须删除tmp目录，才能让添加的profile生效。
最后，就可以在make menuconfig中看到你想要的东西啦。

参考： http://blog.csdn.net/manfeel/article/details/38302077

![Markdown example image]({static|test.png} "Image title")
