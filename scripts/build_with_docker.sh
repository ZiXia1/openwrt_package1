#!/bin/bash
#使用docker编译时使用脚本
SCRIPT_DIR=/opt/scripts
OPENWRT_DIR=/opt/openwrt
PACKIT_DIR=/opt/openwrt_packit
ARTIFACT_DIR=/opt/artifact
#从外部传入的参数
DEVICE=$1
if [ ! -d "$OPENWRT_DIR/.git" ]; then
    echo '未找到openwrt源码，正在检出源码'
    git clone https://github.com/coolsnowwolf/lede.git /opt/openwrt_tmp
    mv /opt/openwrt_tmp/* $OPENWRT_DIR/
    mv /opt/openwrt_tmp/.git $OPENWRT_DIR/
fi
cd $OPENWRT_DIR
git reset --hard && git pull
echo 'openwrt源码更新完毕'
chmod +x $SCRIPT_DIR/*.sh
cp $SCRIPT_DIR/*.sh ./
./before_update_feeds.sh
./scripts/feeds update -a
./scripts/feeds install -a
./after_update_feeds.sh
echo 'feed更新完毕'
if test -z "$DEVICE";then
    make menuconfig
    exit 0
fi
make defconfig
echo '开始下载依赖'
make download -j1 || make download -j1 || make download -j1
echo '编译依赖下载完毕'
echo '开始编译底包'
make V=s -j1 || make V=s -j1 || make V=s -j1
echo '底包编译完毕'
####打包部分####
if [ ! -d "$PACKIT_DIR/.git" ]; then
    echo '未找到打包源码，正在检出源码'
    git clone https://github.com/unifreq/openwrt_packit $PACKIT_DIR
fi
rm -rf $PACKIT_DIR/*rootfs.tar.gz
cd $PACKIT_DIR && git reset --hard && git pull
cp $OPENWRT_DIR/bin/targets/armvirt/64/*rootfs.tar.gz $PACKIT_DIR/
echo '打包源码与底包准备完毕'
# 拉取内核
KERNEL_DIR=/opt/kernel
rm -rf $KERNEL_DIR && mkdir -p $KERNEL_DIR
git clone https://github.com/breakings/OpenWrt --depth=1 $KERNEL_DIR 
echo '内核下载完毕'
LATEST_KERNEL_VERSION=`ls -l $KERNEL_DIR/opt/kernel | awk '{print $9}' | sort -k1.1r | head -1`
echo '当前仓库最新内核版本：'$LATEST_KERNEL_VERSION
cp -r $KERNEL_DIR/opt/kernel/$LATEST_KERNEL_VERSION/* $KERNEL_DIR/
echo '开始进行打包'
cd $PACKIT_DIR
# Set the default packaging script
SCRIPT_VPLUS_FILE="mk_h6_vplus.sh"
SCRIPT_BEIKEYUN_FILE="mk_rk3328_beikeyun.sh"
SCRIPT_L1PRO_FILE="mk_rk3328_l1pro.sh"
SCRIPT_R66S_FILE="mk_rk3568_r66s.sh"
SCRIPT_R68S_FILE="mk_rk3568_r68s.sh"
SCRIPT_H66K_FILE="mk_rk3568_h66k.sh"
SCRIPT_H68K_FILE="mk_rk3568_h68k.sh"
SCRIPT_E25_FILE="mk_rk3568_e25.sh"
SCRIPT_ROCK5B_FILE="mk_rk3588_rock5b.sh"
SCRIPT_H88K_FILE="mk_rk3588_h88k.sh"
SCRIPT_S905_FILE="mk_s905_mxqpro+.sh"
SCRIPT_S905D_FILE="mk_s905d_n1.sh"
SCRIPT_S905X2_FILE="mk_s905x2_x96max.sh"
SCRIPT_S905X3_FILE="mk_s905x3_multi.sh"
SCRIPT_S912_FILE="mk_s912_zyxq.sh"
SCRIPT_S922X_FILE="mk_s922x_gtking.sh"
SCRIPT_S922X_N2_FILE="mk_s922x_odroid-n2.sh"
SCRIPT_QEMU_FILE="mk_qemu-aarch64_img.sh"
SCRIPT_DIY_FILE="mk_diy.sh"
[[ -n "${SCRIPT_VPLUS}" ]] || SCRIPT_VPLUS="${SCRIPT_VPLUS_FILE}"
[[ -n "${SCRIPT_BEIKEYUN}" ]] || SCRIPT_BEIKEYUN="${SCRIPT_BEIKEYUN_FILE}"
[[ -n "${SCRIPT_L1PRO}" ]] || SCRIPT_L1PRO="${SCRIPT_L1PRO_FILE}"
[[ -n "${SCRIPT_R66S}" ]] || SCRIPT_R66S="${SCRIPT_R66S_FILE}"
[[ -n "${SCRIPT_R68S}" ]] || SCRIPT_R68S="${SCRIPT_R68S_FILE}"
[[ -n "${SCRIPT_H66K}" ]] || SCRIPT_H66K="${SCRIPT_H66K_FILE}"
[[ -n "${SCRIPT_H68K}" ]] || SCRIPT_H68K="${SCRIPT_H68K_FILE}"
[[ -n "${SCRIPT_E25}" ]] || SCRIPT_E25="${SCRIPT_E25_FILE}"
[[ -n "${SCRIPT_ROCK5B}" ]] || SCRIPT_ROCK5B="${SCRIPT_ROCK5B_FILE}"
[[ -n "${SCRIPT_H88K}" ]] || SCRIPT_H88K="${SCRIPT_H88K_FILE}"
[[ -n "${SCRIPT_S905}" ]] || SCRIPT_S905="${SCRIPT_S905_FILE}"
[[ -n "${SCRIPT_S905D}" ]] || SCRIPT_S905D="${SCRIPT_S905D_FILE}"
[[ -n "${SCRIPT_S905X2}" ]] || SCRIPT_S905X2="${SCRIPT_S905X2_FILE}"
[[ -n "${SCRIPT_S905X3}" ]] || SCRIPT_S905X3="${SCRIPT_S905X3_FILE}"
[[ -n "${SCRIPT_S912}" ]] || SCRIPT_S912="${SCRIPT_S912_FILE}"
[[ -n "${SCRIPT_S922X}" ]] || SCRIPT_S922X="${SCRIPT_S922X_FILE}"
[[ -n "${SCRIPT_S922X_N2}" ]] || SCRIPT_S922X_N2="${SCRIPT_S922X_N2_FILE}"
[[ -n "${SCRIPT_QEMU}" ]] || SCRIPT_QEMU="${SCRIPT_QEMU_FILE}"
[[ -n "${SCRIPT_DIY}" ]] || SCRIPT_DIY="${SCRIPT_DIY_FILE}"
case $DEVICE in
    vplus)    [[ -f "${SCRIPT_VPLUS}" ]] && ./${SCRIPT_VPLUS} ;;
    beikeyun) [[ -f "${SCRIPT_BEIKEYUN}" ]] && ./${SCRIPT_BEIKEYUN} ;;
    l1pro)    [[ -f "${SCRIPT_L1PRO}" ]] && ./${SCRIPT_L1PRO} ;;
    r66s)     [[ -f "${SCRIPT_R66S}" ]] && ./${SCRIPT_R66S} ;;
    r68s)     [[ -f "${SCRIPT_R68S}" ]] && ./${SCRIPT_R68S} ;;
    h66k)     [[ -f "${SCRIPT_H66K}" ]] && ./${SCRIPT_H66K} ;;
    h68k)     [[ -f "${SCRIPT_H68K}" ]] && ./${SCRIPT_H68K} ;;
    rock5b)   [[ -f "${SCRIPT_ROCK5B}" ]] && ./${SCRIPT_ROCK5B} ;;
    h88k)     [[ -f "${SCRIPT_H88K}" ]] && ./${SCRIPT_H88K} ;;
    e25)      [[ -f "${SCRIPT_E25}" ]] && ./${SCRIPT_E25} ;;
    s905)     [[ -f "${SCRIPT_S905}" ]] && ./${SCRIPT_S905} ;;
    s905d)    [[ -f "${SCRIPT_S905D}" ]] && ./${SCRIPT_S905D} ;;
    s905x2)   [[ -f "${SCRIPT_S905X2}" ]] && ./${SCRIPT_S905X2} ;;
    s905x3)   [[ -f "${SCRIPT_S905X3}" ]] && ./${SCRIPT_S905X3} ;;
    s912)     [[ -f "${SCRIPT_S912}" ]] && ./${SCRIPT_S912} ;;
    s922x)    [[ -f "${SCRIPT_S922X}" ]] && ./${SCRIPT_S922X} ;;
    s922x-n2) [[ -f "${SCRIPT_S922X_N2}" ]] && ./${SCRIPT_S922X_N2} ;;
    qemu)     [[ -f "${SCRIPT_QEMU}" ]] && ./${SCRIPT_QEMU} ;;
    diy)      [[ -f "${SCRIPT_DIY}" ]] && ./${SCRIPT_DIY} ;;
    *)        echo -e "找不到合适的打包脚本" && continue ;;
esac
mkdir $ARTIFACT_DIR/ipks
mv $PACKIT_DIR/output/* $ARTIFACT_DIR/
mv $OPENWRT_DIR/bin/targets/armvirt/64/packages/* $ARTIFACT_DIR/ipks
echo '打包完毕，固件已输出到：./openwrt_build_tmp/artifact/'`ls -l $ARTIFACT_DIR | awk '{print $9}' | head -1`