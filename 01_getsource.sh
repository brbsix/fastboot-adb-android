#!/bin/sh

clone() {
  repo=$1
  git clone -b android-8.1.0_r41 https://android.googlesource.com/platform/$repo src/$repo
}

download() {
  wget --continue --no-verbose --prefer-family=IPv4 --read-timeout=20 --show-progress --trust-server-names -- "$@"
}

mkdir src

mkdir src/system
clone system/core
clone system/extras

mkdir src/external
clone external/selinux
clone external/pcre
clone external/f2fs-tools
clone external/e2fsprogs
clone external/mdnsresponder
clone external/libusb

git clone https://boringssl.googlesource.com/boringssl src/boringssl

cd src/system/core
patch -p1 < ../../../99_patch_core
cd ../../..

mkdir ndk
cd ndk
download https://dl.google.com/android/repository/android-ndk-r15c-linux-x86_64.zip
unzip android-ndk-r15c-linux-x86_64.zip
cd ..

mkdir cmake
cd cmake
download https://cmake.org/files/v3.11/cmake-3.11.4-Linux-x86_64.tar.gz
tar xzf cmake-3.11.4-Linux-x86_64.tar.gz
cd ..
