Title: ionic Mac OS X 下Android 编译环境
Date: 2016-10-26 13:21
Modified: 2017-04-08 13:01:08
Category: OSX
Tags: ionic
Slug: ionic-env-on-osx
Authors: zhangdi
Summary: ionic Mac OS X 下Android 编译问题及解决

编译问题
--------

* Where:
  Script '/Users/zhangdi/Sites/mriabc.com/app/platforms/android/CordovaLib/cordova.gradle' line: 64

* What went wrong:
  A problem occurred evaluating root project 'android'.
  > No installed build tools found. Install the Android build tools version 19.1.0 or higher.

* Try:
  Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output.


BUILD FAILED

解决方式
--------

1) You have to go to the android sdk tools folder, for example (in my case) I just wrote the command in my console: $ cd android-sdk-linux/tools

2) Inside this folder you have to write the command

$ ./android list sdk --all and after  $ ./android update sdk -u -a -t 20

安装android ap23
