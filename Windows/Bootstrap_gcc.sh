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
my_echo  " Bootstrap gcc  "
my_echo  "-------------------------------"
mkdir $BUILDDIR/bootstrap-gcc  
cd $BUILDDIR/bootstrap-gcc  
unset CC
unset LD
unset AS
rm -rf *
$GCC_SRC/configure --build=$BUILDMACH --host=$BUILDMACH --target=$TARGETMACH --prefix=$INSTALLDIR --without-headers --enable-boostrap --enable-languages="c" --disable-threads --enable-__cxa_atexit --disable-libmudflap --with-gnu-ld --with-gnu-as --disable-libssp --disable-libgomp --disable-nls --disable-shared  --with-tune=arm926ej-s --with-arch=armv5te --with-float=soft --with-included-gettext CFLAGS="$CFLAGS -fvisibility=default" LDFLAGS="$LDFLAGS -fvisibility=default"
checkret "Bootstrap gcc configure "

make all-gcc install-gcc
checkret "Bootstrap gcc make all-gcc install-gcc "
make  all-target-libgcc install-target-libgcc
checkret "Bootstrap gcc make  all-target-libgcc install-target-libgcc "
ls -al $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc.a
checkret "Bootstrap gcc ls -al "
ln -sf $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc.a $INSTALLDIR/lib/gcc/$TARGETMACH/${GCC_SRC:0-5}/libgcc_sh.a
checkret "Bootstrap gcc ln -sf "