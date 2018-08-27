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
export PATH=$PATH:$INSTALLDIR/bin
my_echo  "-------------------------------"
my_echo  "Building The Next gcc 非 HOST,所以不用设置 HOST " 
my_echo  "-------------------------------"
echo "*** unset CC, LD, and AS. We do not want to xcompile the xcompiler :-) *** oprofile "
unset CC
unset LD
unset AS
   
echo *** delete gcc-x.x.x and re-install it ***  
cd $SRCDIR
echo rm -rf gcc-$GCCVER
echo tar -pxzf $TARDIR/gcc-$GCCVER.tar.gz
echo cd gcc-$GCCVER/

echo tar -pxjf $TARDIR/gmp-$GMPVER.tar.bz2
echo tar -pxjf $TARDIR/mpfr-$MPFRVER.tar.bz2
echo tar -pxzf $TARDIR/mpc-$MPCVER.tar.gz
echo tar -pxjf $TARDIR/isl-$ISLVER.tar.bz2

echo ln -sf $SRCDIR/mpfr-$MPFRVER mpfr
echo ln -sf $SRCDIR/gmp-$GMPVER gmp
echo ln -sf $SRCDIR/isl-$ISLVER isl
echo ln -sf $SRCDIR/mpc-$MPCVER mpc

mkdir -pv $BUILDDIR/final-gcc
cd $BUILDDIR/final-gcc
rm -rf *
#libcpp/system.h:370
#unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE

echo "libc_cv_forced_unwind=yes" > config.cache
echo "libc_cv_c_cleanup=yes" >> config.cache

echo $GCC_SRC/configure --build=$BUILDMACH --host=$HOST --target=$TARGETMACH --prefix=$INSTALLDIR --with-sysroot=$SYSROOTDIR --enable-languages="c" --with-gnu-as --with-gnu-ld --disable-multilib --with-float=soft --disable-sjlj-exceptions --disable-nls --enable-threads=posix --enable-long-longx  --with-tune=arm926ej-s --with-arch=armv5te --with-float=soft  CFLAGS=" -fvisibility=default" LDFLAGS=" -fvisibility=default"

CC_FOR_BUILD=$BUILDMACH-gcc  \
CXX_FOR_BUILD=$BUILDMACH-g++  \
GCC_FOR_BUILD=$BUILDMACH-gcc  \
GCJ_FOR_BUILD=$BUILDMACH-gcj  \
GFORTRAN_FOR_BUILD=$BUILDMACH-gfortran  \
GOC_FOR_BUILD=$BUILDMACH-gccgo  \
GDC_FOR_BUILD=$BUILDMACH-gdc  \
AR_FOR_BUILD=ar \
AS_FOR_BUILD=as \
DLLTOOL_FOR_BUILD=$BUILDMACH-dlltool \
LD_FOR_BUILD=ld \
LIPO_FOR_BUILD=$BUILDMACH-lipo \
NM_FOR_BUILD=nm \
OBJCOPY_FOR_BUILD=objcopy \
OBJDUMP_FOR_BUILD=objdump \
RANLIB_FOR_BUILD=ranlib \
READELF_FOR_BUILD=readelf \
STRIP_FOR_BUILD=strip \
WINDRES_FOR_BUILD=$BUILDMACH-windres \
WINDMC_FOR_BUILD=$BUILDMACH-windmc \
CC=$HOST-gcc  \
CXX=$HOST-g++  \
GCC=$HOST-gcc  \
GCJ=$HOST-gcj  \
GFORTRAN=$HOST-gfortran  \
GOC=$HOST-gccgo  \
GDC=$HOST-gdc  \
AR=$HOST-ar \
AS=$HOST-as \
DLLTOOL=$HOST-dlltool \
LD=$HOST-ld \
LIPO=$HOST-lipo \
NM=$HOST-nm \
OBJCOPY=$HOST-objcopy \
OBJDUMP=$HOST-objdump \
RANLIB=$HOST-ranlib \
READELF=$HOST-readelf \
STRIP=$HOST-strip \
WINDRES=$HOST-windres \
WINDMC=$HOST-windmc \
CC_FOR_TARGET=$TARGETMACH-gcc  \
CXX_FOR_TARGET=$TARGETMACH-g++  \
GCC_FOR_TARGET=$TARGETMACH-gcc  \
GCJ_FOR_TARGET=$TARGETMACH-gcj  \
GFORTRAN_FOR_TARGET=$TARGETMACH-gfortran  \
GOC_FOR_TARGET=$TARGETMACH-gccgo  \
GDC_FOR_TARGET=$TARGETMACH-gdc  \
AR_FOR_TARGET=$TARGETMACH-ar \
AS_FOR_TARGET=$TARGETMACH-as \
DLLTOOL_FOR_TARGET=$TARGETMACH-dlltool \
LD_FOR_TARGET=$TARGETMACH-ld \
LIPO_FOR_TARGET=$TARGETMACH-lipo \
NM_FOR_TARGET=$TARGETMACH-nm \
OBJCOPY_FOR_TARGET=$TARGETMACH-objcopy \
OBJDUMP_FOR_TARGET=$TARGETMACH-objdump \
RANLIB_FOR_TARGET=$TARGETMACH-ranlib \
READELF_FOR_TARGET=$TARGETMACH-readelf \
STRIP_FOR_TARGET=$TARGETMACH-strip \
WINDRES_FOR_TARGET=$TARGETMACH-windres \
WINDMC_FOR_TARGET=$TARGETMACH-windmc \
$GCC_SRC/configure \
--build=$BUILDMACH \
--host=$HOST \
--target=$TARGETMACH \
--prefix=$INSTALLDIR \
--enable-lib32 --enable-lib64 --enable-experimental \
--with-sysroot=$SYSROOTDIR \
--enable-languages="c" \
--with-native-system-header-dir=/usr/include \
--with-cloog --without-isl --disable-nls \
--enable-checking=release \
--enable-__cxa_atexit \
--disable-bootstrap \
--with-gnu-as \
--with-gnu-ld \
--disable-multilib \
--with-float=soft \
--disable-sjlj-exceptions \
--disable-nls \
--enable-threads=posix \
--with-long-longx  \
--with-tune=arm926ej-s \
--with-arch=armv5te \
--with-float=soft  
#CFLAGS=" -fvisibility=default" LDFLAGS=" -fvisibility=default"

checkret "Building The Next gcc  configure "
make all-gcc
checkret "Building The Next gcc  make all-gcc "
make install-gcc
checkret "Building The Next gcc  make install-gcc "

