#!/usr/bin/env sh

LLVM_VERSION=8.0.0

SYSROOT=`pwd`/sysroot

# Download
rm -rf build cfe-${LLVM_VERSION}.src* llvm-${LLVM_VERSION}.src* || exit $?

wget http://releases.llvm.org/${LLVM_VERSION}/llvm-${LLVM_VERSION}.src.tar.xz || exit $?
tar xf llvm-${LLVM_VERSION}.src.tar.xz || exit $?

wget http://releases.llvm.org/${LLVM_VERSION}/cfe-${LLVM_VERSION}.src.tar.xz || exit $?
tar xf cfe-${LLVM_VERSION}.src.tar.xz || exit $?

mv cfe-${LLVM_VERSION}.src llvm-${LLVM_VERSION}.src/tools/clang


# Configure & Build
(
  mkdir -p build
  cd build || exit $?

  emmake cmake ../llvm-${LLVM_VERSION}.src \
    -DCMAKE_CROSSCOMPILING=True \
    -DCMAKE_INSTALL_PREFIX=${SYSROOT} \
    -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-wasi \
  || exit $?

  emmake cmake --build . -j || exit $?
) || exit $?


# Install

# Clean up
rm -rf build cfe-${LLVM_VERSION}.src* llvm-${LLVM_VERSION}.src* || exit $?
