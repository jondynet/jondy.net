Title: 树莓派raspbian编译nginx-rtmp-module
Date: 2017-07-11 16:04
Category: Debian
Tags: debian
Slug: raspbian-nginx-rtmp-module
Authors: zhangdi
Summary: 一些debian环境的问题汇总

### 通过 apt-get 安装

网上的教程大多是直接下载源码编译的，我更喜欢通过apt安装，记录一下过程

E: You must put some 'source' URIs in your sources.list

修改/etc/apt/sources.list 允许deb-src

```
apt update
apt-get source nginx
apt-get build-dep nginx
git clone https://github.com/arut/nginx-rtmp-module.git
```

## 为nginx增加rtmp支持,打包deb后安装

```
vim nginx-1.6.2/debian/rules
# 增加rtmp-module
--with-http_auth_request_module \
--add-module=/home/pi/nginx-rtmp-module

# cd nginx-1.6.2
# dpkg-buildpackage -b

cd ..
dpkg -i nginx-common_1.6.2-5+deb8u4_all.deb nginx-full_1.6.2-5+deb8u4_armhf.deb
```

推内容

```
ffmpeg -re -i shutao.mov -vcodec copy -acodec copy -f flv rtmp://192.168.31.6/hls/mystream
```

在osx系统下通过ffmpeg查看设备,通过摄像头直播, 从网上找到下边这段命令

```
ffmpeg -f avfoundation -list_devices true -i ""

显示结果如下：

SingerdeMacBook-Pro:~ Singer$ ffmpeg -f avfoundation -list_devices true -i ""
ffmpeg version 3.0 Copyright (c) 2000-2016 the FFmpeg developers
  built with Apple LLVM version 7.0.2 (clang-700.1.81)
  configuration: --prefix=/usr/local/Cellar/ffmpeg/3.0 --enable-shared --enable-pthreads --enable-gpl --enable-version3 --enable-hardcoded-tables --enable-avresample --cc=clang --host-cflags= --host-ldflags= --enable-opencl --enable-libx264 --enable-libmp3lame --enable-libxvid --enable-vda
  libavutil      55. 17.103 / 55. 17.103
  libavcodec     57. 24.102 / 57. 24.102
  libavformat    57. 25.100 / 57. 25.100
  libavdevice    57.  0.101 / 57.  0.101
  libavfilter     6. 31.100 /  6. 31.100
  libavresample   3.  0.  0 /  3.  0.  0
  libswscale      4.  0.100 /  4.  0.100
  libswresample   2.  0.101 /  2.  0.101
  libpostproc    54.  0.100 / 54.  0.100
[AVFoundation input device @ 0x7f9a2bc1b6e0] AVFoundation video devices:
[AVFoundation input device @ 0x7f9a2bc1b6e0] [0] FaceTime HD Camera
[AVFoundation input device @ 0x7f9a2bc1b6e0] [1] Capture screen 0
[AVFoundation input device @ 0x7f9a2bc1b6e0] AVFoundation audio devices:
[AVFoundation input device @ 0x7f9a2bc1b6e0] [0] Built-in Microphone
: Input/output error

 从上面我们可以看到设备如下：

AVFoundation video devices:
[0] FaceTime HD Camera
[1] Capture screen 0
AVFoundation audio devices:
[0] Built-in Microphone
如果希望将桌面录制或者分享，可以使用命令行如下：

ffmpeg -f avfoundation -i "1" -vcodec libx264 -preset ultrafast -acodec libfaac -f flv rtmp://192.168.1.105:1935/live1/room1
 如果需要桌面+麦克风，比如一般做远程教育分享ppt或者桌面，有音频讲解 命令行如下：

ffmpeg -f avfoundation -i "1:0" -vcodec libx264 -preset ultrafast -acodec libmp3lame -ar 44100 -ac 1 -f flv rtmp://192.168.1.105:1935/live1/room1
如果需要桌面+麦克风，并且还要摄像头拍摄到自己，比如一般用于互动主播，游戏主播，命令行如下

ffmpeg -f avfoundation -framerate 30 -i "1:0" -f avfoundation -framerate 30 -video_size 640x480 -i "0" -c:v libx264 -preset ultrafast -filter_complex ‘overlay=main_w-overlay_w-10:main_h-overlay_h-10‘ -acodec libmp3lame -ar 44100 -ac 1  -f flv rtmp://192.168.1.105:1935/live1/room1
 然后你就可以用过支持rtmp协议的播放软件（例如VCL播放器）测试观看了
```

## 最后附上一段串口如何调整终端大小

```
stty size
stty cols 130
stty rows 40
```
