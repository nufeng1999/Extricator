#! /bin/sh
export EXTRICATORDIR=$(cd $(dirname $0); pwd)
for line in `cat $EXTRICATORDIR/init.txt`
do
    echo $line
    export $line
done
export BUILDDIR=$WORKDIR/gcc-$GCCVER/xtools/build  
export SRCDIR=$WORKDIR/gcc-$GCCVER/xtools/src
export BINUTILS_SRC=$SRCDIR/binutils-$BINUTILS_VER
export KERNEL_SRC=$SRCDIR/linux-$KERNEL_VER
export GCC_SRC=$SRCDIR/gcc-$GCCVER  
export GLIBC_SRC=$SRCDIR/glibc-$GLIBC_VER
export INSTALLDIR=$WORKDIR/gcc-$GCCVER/arm-linux-gcc-${GCCVER}_mingw
export SYSROOTDIR=$INSTALLDIR/sysroot
export CROSS=$TARGETMACH
export BUILD_LOG=$WORKDIR/build.log

mkdir -pv $WORKDIR
mkdir -pv $BUILDDIR
mkdir -pv $SRCDIR
mkdir -pv $KERNEL_SRC
mkdir -pv $GCC_SRC
mkdir -pv $INSTALLDIR
mkdir -pv $SYSROOTDIR

echo -e "---------build gcc----------" >$BUILD_LOG;
my_echo(){  echo -e "$1" >>$BUILD_LOG;}
my_echo  "----------------test--------------------"
checkret(){ if [ "$?" -ne "0" ]; then   echo -e "$1 FAIL";   echo -e "$1  FAIL." >>$BUILD_LOG; exit 1; else   echo -e "$1 SUCC"; echo -e "$1 SUCC." >>$BUILD_LOG;  fi }
execcmd_checkret(){ $1 ; checkret "$1" ; }
unset_crossenv(){
    unset CC
    unset LD
    unset AS
}
