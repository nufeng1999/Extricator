如果需要生成 windows mingw 下的arm交叉编译工具，那么Linux编译平台下
需要安装 
gcc-arm-linux-gnu 
gcc-c++-arm-linux-gnu
gcc
gcc-c++
mingw32-gcc
mingw32-gcc-c++
mingw64-gcc
mingw64-gcc-c++

此项目使用自编译的 Linux 版 arm交叉编译工具，所以要生成 windows mingw 
下的arm交叉编译工具需要先生成并安装 Linux 版 arm交叉编译工具。
----------------------------------------------------------------------
构建过程，碰见的一些问题，及解决方案：
---------------
Linux arm交叉编译工具
ln -s arm-linux-gnu-g++ arm-none-linux-gnueabi-g++
---------------
glibc/configure
change
test -n "$critic_missing" && as_fn_error $? "
*** These critical programs are missing or too old:$critic_missing
*** Check the INSTALL file for required versions." "$LINENO" 5
to 
#test -n "$critic_missing" && as_fn_error $? "
#*** These critical programs are missing or too old:$critic_missing
#*** Check the INSTALL file for required versions." "$LINENO" 5
---------------
Fixes error "In function _Unwind_Resume: undefined reference to libgcc_s_resume"
https://github.com/crosstool-ng/crosstool-ng/pull/178/commits/8442cd7e029c7a7d802195a77f74d3a5251f9d09
---------------

