#! /bin/sh
export EXTRICATORDIR=$(cd $(dirname $0); pwd)
source $EXTRICATORDIR/set_env.sh
export PATH=$INSTALLDIR/bin:$PATH  
my_echo  "-------------------------------"
my_echo  " Building glibc  "
echo 		Fixes error "In function _Unwind_Resume: undefined reference to libgcc_s_resume"
echo 		https://github.com/crosstool-ng/crosstool-ng/pull/178/commits/8442cd7e029c7a7d802195a77f74d3a5251f9d09
my_echo  "-------------------------------"
cd $BUILDDIR
rm -rf $BUILDDIR/libc
mkdir -pv $BUILDDIR/libc  
cd $BUILDDIR/libc  
echo "libc_cv_forced_unwind=yes" > config.cache  
echo "libc_cv_c_cleanup=yes" >> config.cache  

echo *** check to make sure these are still set, they should be ***  
echo $PATH
echo $CROSS
echo $CC

$GLIBC_SRC/configure --build=$BUILDMACH --host=$TARGETMACH --prefix=/usr --with-headers=$SYSROOTDIR/usr/include --config-cache --enable-kernel=$KERNEL_VER --enable-obsolete-rpc
checkret "Building glibc   configure "
make -k install-headers cross_compiling=yes install_root=$SYSROOTDIR

checkret "Building glibc   make -k install-headers cross_compiling=yes install_root=$SYSROOTDIR "
ls $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc.a 
ln -sf $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc.a $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc_s.a
checkret "Building glibc   ln"

make
checkret "Building glibc   make "
make install_root=$SYSROOTDIR install
checkret "Building glibc   make install_root=$SYSROOTDIR install "
