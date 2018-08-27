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

echo -------------------------------
echo Gather the Sources
echo -------------------------------
cd $TARDIR
#wget http://ftp.gnu.org/gnu/gcc/gcc-$GCCVER/gcc-$GCCVER.tar.gz -q -o gcc-$GCCVER.tar.gz
execcmd_checkret "wget http://ftp.gnu.org/gnu/gcc/gcc-$GCCVER/gcc-$GCCVER.tar.gz -q -o gcc-$GCCVER.tar.gz"
#wget http://ftp.gnu.org/gnu/gmp/gmp-$GMPVER.tar.bz2  -q -o gmp-$GMPVER.tar.bz2
execcmd_checkret "wget http://ftp.gnu.org/gnu/gmp/gmp-$GMPVER.tar.bz2  -q -o gmp-$GMPVER.tar.bz2"
#wget http://ftp.gnu.org/gnu/mpfr/mpfr-$MPFRVER.tar.bz2 -q -o mpfr-$MPFRVER.tar.bz2 
execcmd_checkret "wget http://ftp.gnu.org/gnu/mpfr/mpfr-$MPFRVER.tar.bz2 -q -o mpfr-$MPFRVER.tar.bz2 "
#wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-$MPCVER.tar.gz  -q -o mpc-$MPCVER.tar.gz
execcmd_checkret "wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-$MPCVER.tar.gz  -q -o mpc-$MPCVER.tar.gz"
#wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.bz2  -q -o binutils-2.23.2.tar.bz2
execcmd_checkret "wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.bz2  -q -o binutils-2.23.2.tar.bz2"
#wget http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz  -q -o glibc-2.18.tar.gz
execcmd_checkret "wget http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz  -q -o glibc-2.18.tar.gz"
#wget glibc-2.18.tar.gzhttp://www.kernel.org/pub/linux/kernel/v2.6/linux-$KERNEL_VER.tar.bz2  -q -o linux-$KERNEL_VER.tar.bz2
execcmd_checkret "wget glibc-2.18.tar.gzhttp://www.kernel.org/pub/linux/kernel/v2.6/linux-$KERNEL_VER.tar.bz2  -q -o linux-$KERNEL_VER.tar.bz2"

cd $SRCDIR
execcmd_checkret "tar -pxzf $TARDIR/binutils-$BINUTILS_VER.tar.gz"
execcmd_checkret "tar -pxzf $TARDIR/gcc-$GCCVER.tar.gz"
execcmd_checkret "tar -pxzf $TARDIR/glibc-$GLIBC_VER.tar.gz"
execcmd_checkret "tar -pxjf $TARDIR/linux-$KERNEL_VER.tar.bz2"

execcmd_checkret "tar -pxjf $TARDIR/gmp-$GMPVER.tar.bz2"
execcmd_checkret "tar -pxjf $TARDIR/mpfr-$MPFRVER.tar.bz2"
execcmd_checkret "tar -pxzf $TARDIR/mpc-$MPCVER.tar.gz"
execcmd_checkret "tar -pxjf $TARDIR/isl-$ISLVER.tar.bz2"

cd $GCC_SRC
echo ./contrib/download_prerequisites
ln -sf $SRCDIR/mpfr-$MPFRVER mpfr
ln -sf $SRCDIR/gmp-$GMPVER gmp
ln -sf $SRCDIR/isl-$ISLVER isl
ln -sf $SRCDIR/mpc-$MPCVER mpc
