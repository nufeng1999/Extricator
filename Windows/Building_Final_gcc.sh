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
export PATH=$ARMLINUXGCC/bin:$PATH
my_echo  "-------------------------------"
my_echo  "Building The Final gcc "
my_echo  "-------------------------------"
echo *** make sure these are still unset ***  
echo $CC  
echo $LD  
echo $AS  

mkdir -pv $TARDIR/builds
mkdir -pv $TARDIR/zlib
cd $TARDIR/builds
CROSS_COMPILE=$HOST  \
$GCC_SRC/zlib/configure \
--build=$BUILDMACH \
--host=$HOST \
--prefix=$TARDIR/zlib
checkret "Build zlib configure "
make
checkret "Build zlib make "
make install
checkret "Build zlib make install"

echo *** delete gcc-x.x.x and re-install it ***  
cd $SRCDIR
echo rm -rf gcc-$GCCVER  
echo tar -pxzf $TARDIR/gcc-$GCCVER.tar.gz
cd gcc-$GCCVER/gcc
ln -sf ../zlib/zlib.h zlib.h
ln -sf ../zlib/zconf.h zconf.h
echo tar -pxjf $TARDIR/gmp-$GMPVER.tar.bz2
echo tar -pxjf $TARDIR/mpfr-$MPFRVER.tar.bz2
echo tar -pxzf $TARDIR/mpc-$MPCVER.tar.gz
echo tar -pxjf $TARDIR/isl-$ISLVER.tar.bz2
echo ln -sf $SRCDIR/mpfr-$MPFRVER mpfr
echo ln -sf $SRCDIR/gmp-$GMPVER gmp
echo ln -sf $SRCDIR/isl-$ISLVER isl
echo ln -sf $SRCDIR/mpc-$MPCVER mpc

mkdir -pv $BUILDDIR/final-gcc-2  
cd $BUILDDIR/final-gcc-2  
#rm -rf *
echo "libc_cv_forced_unwind=yes" > config.cache  
echo "libc_cv_c_cleanup=yes" >> config.cache

mkdir -pv $BUILDDIR/final-gcc-2/mpfr/src/.libs
cd $BUILDDIR/final-gcc-2/mpfr/src/.libs
ln -sf $TARDIR/zlib/lib/libz.a libz.a 

cd $BUILDDIR/final-gcc-2  
export GDC=$GDCDIR/arm-unknown-linux-gnueabihf/bin/arm-unknown-linux-gnueabihf-gdc
export GDC_FOR_BUILD=$GDCDIR/x86_64-unknown-linux-gnu/bin/gdc

echo 支持C,C++的配置
CC_FOR_BUILD=$BUILDMACH-gcc  \
CXX_FOR_BUILD=$BUILDMACH-g++  \
GCC_FOR_BUILD=$BUILDMACH-gcc  \
GCJ_FOR_BUILD=$BUILDMACH-gcj  \
GFORTRAN_FOR_BUILD=$BUILDMACH-gfortran  \
GOC_FOR_BUILD=$BUILDMACH-gccgo  \
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
--with-sysroot=$SYSROOTDIR \
--enable-languages=c,c++,d \
--with-gnu-as --with-gnu-ld \
--disable-multilib  \
--disable-sjlj-exceptions \
--disable-nls \
--enable-threads=posix \
--disable-libmudflap \
--disable-libssp \
--enable-long-longx --with-shared \
--enable-__cxa_atexit \
--enable-checking=release \
--disable-libunwind-exceptions \
--enable-gnu-unique-object \
--enable-initfini-array \
--enable-linker-build-id \
--enable-lto \
--enable-nls \
--enable-obsolete \
--enable-plugin \
--enable-targets=all \
--enable-gnu-indirect-function \
--with-linker-hash-style=gnu \
--program-prefix=arm-linux-gnu- \
--with-isl \
--with-system-zlib \
--with-tune=$TUNE \
--with-arch=$ARCH \
--with-float=$FLOAT \
CFLAGS="-fvisibility=default" 
checkret "Building The Final gcc  configure "

echo 为编译做配置准备 包括支持 D 语言 ，还需要调试
echo \
CC_FOR_BUILD='x86_64-linux-gnu-gcc '  \
CXX_FOR_BUILD='x86_64-linux-gnu-g++ '  \
GCC_FOR_BUILD='x86_64-linux-gnu-gcc '  \
GCJ_FOR_BUILD='x86_64-linux-gnu-gcj '  \
GFORTRAN_FOR_BUILD='x86_64-linux-gnu-gfortran '  \
GOC_FOR_BUILD='x86_64-linux-gnu-gccgo '  \
GDC_FOR_BUILD='x86_64-linux-gnu-gdc ' \
AR_FOR_BUILD=x86_64-linux-gnu-ar \
AS_FOR_BUILD=x86_64-linux-gnu-as \
DLLTOOL_FOR_BUILD=x86_64-linux-gnu-dlltool \
LD_FOR_BUILD=x86_64-linux-gnu-ld \
LIPO_FOR_BUILD=x86_64-linux-gnu-lipo \
NM_FOR_BUILD=x86_64-linux-gnu-nm \
OBJCOPY_FOR_BUILD=x86_64-linux-gnu-objcopy \
OBJDUMP_FOR_BUILD=x86_64-linux-gnu-objdump \
RANLIB_FOR_BUILD=x86_64-linux-gnu-ranlib \
READELF_FOR_BUILD=x86_64-linux-gnu-readelf \
STRIP_FOR_BUILD=x86_64-linux-gnu-strip \
WINDRES_FOR_BUILD=x86_64-linux-gnu-windres \
WINDMC_FOR_BUILD=x86_64-linux-gnu-windmc \
CC='x86_64-unknown-linux-gnu-gcc ' \
CXX='x86_64-unknown-linux-gnu-g++ ' \
GCC='x86_64-unknown-linux-gnu-gcc ' \
GCJ='x86_64-unknown-linux-gnu-gcj ' \
GFORTRAN='x86_64-unknown-linux-gnu-gfortran ' \
GOC='x86_64-unknown-linux-gnu-gccgo ' \
GDC='x86_64-unknown-linux-gnu-gdc ' \
AR=x86_64-unknown-linux-gnu-ar \
AS=x86_64-unknown-linux-gnu-as \
DLLTOOL=x86_64-unknown-linux-gnu-dlltool \
LD=x86_64-unknown-linux-gnu-ld \
LIPO=x86_64-unknown-linux-gnu-lipo \
NM=x86_64-unknown-linux-gnu-nm \
OBJCOPY=x86_64-unknown-linux-gnu-objcopy \
OBJDUMP=x86_64-unknown-linux-gnu-objdump \
RANLIB=x86_64-unknown-linux-gnu-ranlib \
READELF=x86_64-unknown-linux-gnu-readelf \
STRIP=x86_64-unknown-linux-gnu-strip \
WINDRES=x86_64-unknown-linux-gnu-windres \
WINDMC=x86_64-unknown-linux-gnu-windmc \
$GCC_SRC/configure \
--build=$BUILDMACH \
--target=$TARGETMACH \
--prefix=$INSTALLDIR \
--with-sysroot=$SYSROOTDIR \
--with-native-system-header-dir=/usr/include \
--with-pkgversion='gdcproject.org 20180822-v2.081.2_gcc8' \
--without-cloog \
--without-isl \
--disable-nls \
--enable-languages=c,c++ \
--enable-checking=release \
--enable-__cxa_atexit \
--enable-threads=posix \
--with-bugurl=https://bugzilla.gdcproject.org \
--disable-bootstrap \
--enable-multilib \
--with-float=hard \
--enable-lto


make
checkret "Building The Final gcc  make "
make install
checkret "Building The Final gcc  make install "
my_echo  "-------------------------------"
my_echo  "             link "
my_echo  "-------------------------------"

ln -sf arm-none-linux-gnueabi-addr2line.exe         arm-linux-addr2line  
ln -sf arm-none-linux-gnueabi-ar.exe                arm-linux-ar         
ln -sf arm-none-linux-gnueabi-as.exe                arm-linux-as         
ln -sf arm-none-linux-gnueabi-c++filt.exe           arm-linux-c++filt    
ln -sf arm-none-linux-gnueabi-cpp.exe               arm-linux-cpp        
ln -sf arm-none-linux-gnueabi-elfedit.exe           arm-linux-elfedit    
ln -sf arm-none-linux-gnueabi-gcc.exe               arm-linux-gcc        
ln -sf arm-none-linux-gnueabi-gcc-$GCCVER.exe       arm-linux-gcc-$GCCVER  
ln -sf arm-none-linux-gnueabi-gcc-ar.exe            arm-linux-gcc-ar     
ln -sf arm-none-linux-gnueabi-gcc-nm.exe            arm-linux-gcc-nm     
ln -sf arm-none-linux-gnueabi-gcc-ranlib.exe        arm-linux-gcc-ranlib 
ln -sf arm-none-linux-gnueabi-gcov.exe              arm-linux-gcov       
ln -sf arm-none-linux-gnueabi-gcov-dump.exe         arm-linux-gcov-dump  
ln -sf arm-none-linux-gnueabi-gcov-tool.exe         arm-linux-gcov-tool  
ln -sf arm-none-linux-gnueabi-gprof.exe             arm-linux-gprof      
ln -sf arm-none-linux-gnueabi-ld.exe                arm-linux-ld         
ln -sf arm-none-linux-gnueabi-ld.bfd                arm-linux-ld.bfd     
ln -sf arm-none-linux-gnueabi-nm.exe                arm-linux-nm         
ln -sf arm-none-linux-gnueabi-objcopy.exe           arm-linux-objcopy    
ln -sf arm-none-linux-gnueabi-objdump.exe           arm-linux-objdump    
ln -sf arm-none-linux-gnueabi-ranlib.exe            arm-linux-ranlib     
ln -sf arm-none-linux-gnueabi-readelf.exe           arm-linux-readelf    
ln -sf arm-none-linux-gnueabi-size.exe              arm-linux-size       
ln -sf arm-none-linux-gnueabi-strings.exe           arm-linux-strings    
ln -sf arm-none-linux-gnueabi-strip.exe             arm-linux-strip      
ln -sf arm-none-linux-gnueabi-c++.exe               arm-linux-c++
ln -sf arm-none-linux-gnueabi-g++.exe               arm-linux-g++
ln -sf arm-linux-gnu-gcc-ar.exe                     arm-linux-ar         
ln -sf arm-linux-gnu-gcc-nm.exe                     arm-linux-nm         
ln -sf arm-linux-gnu-gcc-ranlib.exe                 arm-linux-ranlib     
ln -sf arm-linux-gnu-c++.exe                        arm-linux-c++
ln -sf arm-linux-gnu-g++.exe                        arm-linux-g++
ln -sf arm-linux-gnu-cpp.exe                        arm-linux-cpp        
ln -sf arm-linux-gnu-gcc.exe                        arm-linux-gcc        
ln -sf arm-linux-gnu-gcov.exe                       arm-linux-gcov
ln -sf arm-linux-gcov-dump.exe                      arm-linux-dump     

my_echo  "------------------------------------"
my_echo  "                OK"
my_echo  "------------------------------------"
