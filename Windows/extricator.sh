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



#echo "source $EXTRICATORDIR/getsources.sh"
source $EXTRICATORDIR/Building_binutils.sh
export $EXTRICATORDIR/PATH=$INSTALLDIR/bin:$PATH
source $EXTRICATORDIR/kernel_headers.sh
source $EXTRICATORDIR/Bootstrap_gcc.sh
source $EXTRICATORDIR/glibc_headers.sh
source $EXTRICATORDIR/Building_glibc.sh
source $EXTRICATORDIR/Building_Next_gcc.sh
#source $EXTRICATORDIR/Building_binutils.sh
source $EXTRICATORDIR/Building_Final_gcc.sh