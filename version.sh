# 此文件用于配置编译时使用的openwrt源码版本以及插件版本，若文件或配置不存在，则默认使用最新的代码编译
# 问：为什么要有这个版本号机制而不是默认就使用最新版本编译
# 答：由于OP和插件源码更新非常频繁，部分更新可能会导致编译失败，所以需要有一个Release版本机制，记录百分百能够编出来的版本
# 目前本文件由Workflow定时自动更新
OPENWRT_VER=R23.07.31
OPENWRT_COMMIT_ID=e7e8eb963ffcca4795cf0d3f7dd556473d38a539
OPENWRT_PACKAGES_COMMIT_ID=9285e4af13474b5b0bb8e5a08dd17444c5ed482d
PASSWALL_PACKAGE_COMMIT_ID=f4eb43bf488e1e26f3c4a41ffbc5e642931a2204
SMALL_PACKAGE_COMMIT_ID=01b6907b5d5ccfdab0764755de4b0c49edc99ac1
