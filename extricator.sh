#! /bin/sh
export EXTRICATORDIR=$(cd $(dirname $0); pwd)
source $EXTRICATORDIR/set_env.sh



source $EXTRICATORDIR/getsources.sh
source $EXTRICATORDIR/Building_binutils.sh
export $EXTRICATORDIR/PATH=$INSTALLDIR/bin:$PATH
source $EXTRICATORDIR/kernel_headers.sh
source $EXTRICATORDIR/Bootstrap_gcc.sh
source $EXTRICATORDIR/glibc_headers.sh
source $EXTRICATORDIR/Building_glibc.sh
source $EXTRICATORDIR/Building_Next_gcc.sh
#source $EXTRICATORDIR/Building_binutils.sh
source $EXTRICATORDIR/Building_Final_gcc.sh