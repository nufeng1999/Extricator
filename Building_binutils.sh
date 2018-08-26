#! /bin/sh
export EXTRICATORDIR=$(cd $(dirname $0); pwd)
source $EXTRICATORDIR/set_env.sh

cd $BUILDDIR

my_echo  "-------------------------------"
my_echo  " Build binutils "
my_echo  "-------------------------------"
unset CC
unset LD
unset AS
mkdir $BUILDDIR
mkdir $BUILDDIR/binutils
cd $BUILDDIR/binutils 
rm -rf *
if [ "$1" ];then
CFLAGS="-O2" $BINUTILS_SRC/configure --disable-werror --build=$BUILDMACH --target=$TARGETMACH --prefix=$INSTALLDIR --with-sysroot=$SYSROOTDIR
else
CFLAGS="-O2" $BINUTILS_SRC/configure --disable-werror --build=$BUILDMACH --target=$TARGETMACH --prefix=$INSTALLDIR --with-sysroot=$SYSROOTDIR
fi


checkret "Build binutils configure "
make
checkret "Build binutils make "
make install
checkret "Build binutils make install "