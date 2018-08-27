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