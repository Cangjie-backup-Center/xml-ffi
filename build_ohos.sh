#! /bin/bash

mkdir -p libxml_c/build
mkdir -p lib
cd libxml_c/build

# -DCMAKE_CXX_COMPILER 和 -DCMAKE_CXX_FLAGS 路径自行设置
cmake .. -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="E:/532_xml/native/llvm/bin/clang.exe" -DCMAKE_C_FLAGS="--sysroot=E:/532_xml/native/sysroot --target=aarch64-linux-ohos" -DCMAKE_SYSTEM_NAME=linux -DCMAKE_SYSTEM_PROCESSOR=aarch64  -G "MinGW Makefiles" -DCMAKE_STRIP="E:/532_xml/native/llvm/bin/llvm-strip.exe" -DCMAKE_MAKE_PROGRAM="D:/msys64/mingw64/bin/make.exe"
make

cp libmyxml2.so ../../lib/
cd ../../
cjpm build --target aarch64-linux-ohos