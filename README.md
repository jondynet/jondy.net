# README #

包含我的博客和我的开发环境

用Pelican来搭建静态博客。

我想要的博客程序是什么样的

一篇一个目录，正文、图片或其它静态资源都在同一个目录下

我的开发环境和配置文件
=====================

vim
===

    git clone https://github.com/jondynet/myfiles.git

vim带有submodule, 当使用git clone下来的工程中带有submodule时，初始的时候，submodule的内容并不会自动下载下来的，此时，只需执行如下命令：

    git submodule update --init --recursive


修改vim配置使用git submodule和pathogen

    ln -s `pwd`/vim $HOME/.vim
    ln -s `pwd`/vimrc $HOME/.vimrc

git
===

    ln -s `pwd`/gitconfig $HOME/.gitconfig

bash profile
============

    编辑 $HOME/.bash_profile 引用
    #!/bin/bash
    source ~/Sites/lib/myfiles/bash_profile

