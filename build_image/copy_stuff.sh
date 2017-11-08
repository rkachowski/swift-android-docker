#!/usr/bin/env bash

docker build . -t rkachowski/swift-android:latest

mkdir artifacts && docker run -it -v $(pwd)/artifacts:/artifacts rkachowski/swift-android bash -c "
    cp -r android-ndk-r15c/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a /artifacts/
    cp -r android-ndk-r15c/platforms/android-21/arch-arm /artifacts
    cp -r build/Ninja-ReleaseAssert/swift-linux-x86_64 /artifacts/
    cp -r android-ndk-r15c/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64 /artifacts/
"
