FROM ubuntu:20.04
MAINTAINER codercaizh <545347837@qq.com>
EXPOSE 22
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list && sed -i "s@http://.*security.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
# openwrt固件编译依赖
RUN apt-get update && apt-get install -y build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync && apt-get autoremove --purge && apt-get clean
# 镜像打包依赖
RUN apt-get install -y btrfs-progs parted uuid-runtime dosfstools 
ENV FORCE_UNSAFE_CONFIGURE=1
ENV WHOAMI=菜头君
ENV SW_FLOWOFFLOAD=0
ENV SFE_FLOW=0
ENV ENABLE_WIFI_K504=0
ENV ENABLE_WIFI_K510=0
COPY ./scripts /opt/scripts
ENTRYPOINT ["/bin/bash", "/opt/scripts/build_with_docker.sh"]
CMD ["vplus"]