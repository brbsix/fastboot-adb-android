#!/bin/sh

CMAKE_BIN=`pwd`/cmake/cmake-3.11.4-Linux-x86_64/bin/cmake
ROOT_DIR=`pwd`/src/boringssl
DIST_DIR=$ROOT_DIR/dist
BUILD_DIR=$ROOT_DIR/build

ABIS=arm64-v8a

# NOTES: won't build on later version
export ANDROID_NDK=`pwd`/ndk/android-ndk-r15c

build() {
  arch=$1
  rm -rf $BUILD_DIR
  mkdir $BUILD_DIR
  cd $BUILD_DIR

  $CMAKE_BIN \
    -DANDROID_ABI=$arch \
    -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -DANDROID_NATIVE_API_LEVEL=23 \
    -GNinja $ROOT_DIR
  ninja
  if [ ! -d $DIST_DIR/$arch ]; then
    mkdir -p $DIST_DIR/$arch
  fi
  mv $BUILD_DIR/crypto/libcrypto.a $DIST_DIR/$arch
  mv $BUILD_DIR/decrepit/libdecrepit.a $DIST_DIR/$arch
}

cd $ROOT_DIR
for arch in $ABIS
do
  build $arch
done
