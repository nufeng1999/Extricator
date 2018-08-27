#! /bin/sh
SOURCE="$0"
if [ "X$0" != "X" ];then
SOURCE="$1"
fi
while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
EXTRICATORDIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
source $EXTRICATORDIR/set_env.sh
my_echo  "-------------------------------"
my_echo  "glibc Headers - If binutils is not compatible with glibc this is where it will fail "
my_echo  "-------------------------------"
rm -rf $BUILDDIR/libc
mkdir -pv $BUILDDIR/libc
cd $BUILDDIR/libc
export PATH=$INSTALLDIR/bin:$PATH  
echo "libc_cv_forced_unwind=yes" > config.cache
echo "libc_cv_c_cleanup=yes" >> config.cache
export PATH=$INSTALLDIR/bin:$PATH
export CROSS=arm-none-linux-gnueabi
export CC=${CROSS}-gcc
export LD=${CROSS}-ld
export AS=${CROSS}-as
echo CFLAGS=" -mabi=apcs-gnu -march=armv5te -mtune=arm926ej-s -marm -mfloat-abi=soft"   

$GLIBC_SRC/configure --build=$BUILDMACH --host=$TARGETMACH    --prefix=$SYSROOTDIR/usr --with-headers=$SYSROOTDIR/usr/include --config-cache --enable-kernel=$KERNEL_VER --enable-obsolete-rpc CFLAGS="$CFLAGS -fvisibility=default " LDFLAGS="$LDFLAGS -fvisibility=default"
checkret "glibc Headers configure "
make -k install-headers cross_compiling=yes install_root=$SYSROOTDIR  
checkret "glibc Headers make "

pushd $SYSROOTDIR/$INSTALLDIR/sysroot/usr/include
alias cp="cp"
cp -rfv * $SYSROOTDIR/usr/include/
alias cp="cp -i"
popd
ls -al $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc.a
ln -sf $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc.a $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc_eh.a
checkret "glibc Headers ln"
