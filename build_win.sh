#! /bin/bash
lib_path=$(cd `dirname $0`; pwd)
#lib_path=$(pwd)


# check libxml2.dll
if [ ! -d "${lib_path}/lib/" ];then
    mkdir ${lib_path}/lib
    echo "Please copy libxml2.dll to the folder ${lib_path}/lib."
    exit 1
fi

if [ ! -f "${lib_path}/lib/libxml2.dll" ];then
    echo "Please copy libxml2.dll to the folder ${lib_path}/lib."
    exit 1
fi

# libmyxml2.dll
cd ${lib_path}/libxml_c
if [ -f "Makefile" ];then
    make clean
fi

./configure
make

# xml4cj
cd  ${lib_path}/
echo start build xml4cj
cjpm build -V
cp ${lib_path}/lib/*.dll ${lib_path}/build/xml4cj/
echo end build xml4cj
