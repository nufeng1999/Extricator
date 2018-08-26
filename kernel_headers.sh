export PATH=$INSTALLDIR/bin:$PATH

my_echo  "-------------------------------"
my_echo  " Kernel Headers  非 HOST,所以不用设置 HOST "
my_echo  "-------------------------------"
cd $KERNEL_SRC
echo cp arch/arm/configs/sbc6000x_defconfig .config
#需要生成version文件则执行下面的
echo make ARCH=arm omap2plus_defconfig

mkdir -pv $INSTALLDIR/sysroot/usr
make ARCH=arm headers_check
make ARCH=arm INSTALL_HDR_PATH=$INSTALLDIR/sysroot/usr headers_install
cd $SRCDIR