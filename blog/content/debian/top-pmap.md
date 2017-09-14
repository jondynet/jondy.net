Title: linux下top命令查看进程详细参数及pmap命令的使用
Date: 2017-09-14 11:32
Category: Debian
Tags: linux
Slug: linux-top-pmap
Authors: zhangdi
Summary:  linux下top命令查看进程详细参数及pmap命令的使用

# top命令

## top 进程详细参数的显示

top命令默认是不显示进程的参数的，在top界面按字母 `c` 可以显示完整的进程信息。

## top 查看指定用户的进程

通常我们的服务都由 `www-data` 用户去启动，top 命令通过 -u 参数可以查看这个用户下的进程信息

`# top -u www-data`

## top 各字段内容的解释

内容解释：

　　PID：进程的ID
　　USER：进程所有者
　　PR：进程的优先级别，越小越优先被执行
　　NInice：值
　　VIRT：进程占用的虚拟内存
　　RES：进程占用的物理内存
　　SHR：进程使用的共享内存
　　S：进程的状态。S表示休眠，R表示正在运行，Z表示僵死状态，N表示该进程优先值为负数
　　%CPU：进程占用CPU的使用率
　　%MEM：进程使用的物理内存和总内存的百分比
　　TIME+：该进程启动后占用的总的CPU时间，即占用CPU使用时间的累加值。
　　COMMAND：进程启动命令名称

　　常用的命令：

　　P：按%CPU使用率排行
　　T：按MITE+排行
　　M：按%MEM排行

# pmap 命令

可以根据进程查看进程相关信息占用的内存情况，(进程号可以通过ps查看)如下所示：

`$ pmap -d 14596`

