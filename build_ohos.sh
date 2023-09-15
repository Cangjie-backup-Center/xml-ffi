#! /bin/bash
lib_path=$(cd `dirname $0`; pwd)
#lib_path=$(pwd)


# check libmyxml2.so
if [ ! -d "${lib_path}/lib/" ];then
    mkdir ${lib_path}/lib
    echo "Please copy libxml2.so to the folder ${lib_path}/lib."
    exit 1
fi

if [ ! -f "${lib_path}/lib/libxml2.so" ];then
    echo "Please copy libxml2.so to the folder ${lib_path}/lib."
    exit 1
fi

# libmyxml2.so
cd ${lib_path}/libxml_c
if [ -f "Makefile" ];then
    make clean
fi

# "/usr1/ohos/llvm/bin/"为ohos编译路径，
# "/usr1/ohos/llvm/include/aarch64-linux-ohos"为ohos头文件路径，请自行修改
./configure --cc="/usr1/ohos/llvm/bin/clang" --cross-prefix="/usr1/ohos/llvm/bin/llvm-" \
--target=aarch64-linux-ohos --cflags="-I/usr1/ohos/llvm/include/aarch64-linux-ohos"
make

# xml4cj
cd  ${lib_path}/
echo start build xml4cj
cjpm build -V
cp ${lib_path}/lib/*.so ${lib_path}/build/xml4cj/
echo end build xml4cj
