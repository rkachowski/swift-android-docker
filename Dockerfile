FROM ubuntu:16.04
MAINTAINER Donald Hutchison <contact@donaldhutchison.info>

RUN apt-get -q update && \
    apt-get -q install -y \
    curl\
    autoconf\
    automake\
    libtool\
    git\
    cmake\
    ninja-build\
    clang\
    python\
    uuid-dev\
    libicu-dev\
    icu-devtools\
    libbsd-dev\
    libedit-dev\
    libxml2-dev\
    libsqlite3-dev\
    swig\
    libpython-dev\
    libncurses5-dev\
    pkg-config\
    libblocksruntime-dev\
    libcurl4-openssl-dev\
    systemtap-sdt-dev\
    tzdata


ENV INSTALL_PATH /swift
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

RUN git clone https://github.com/SwiftAndroid/libiconv-libicu-android.git
RUN git clone https://github.com/apple/swift.git

RUN cd libiconv-libicu-android && mkdir armeabi-v7a && cd armeabi-v7a && tar xvf ../icu4c-55_1-src.tgz 

COPY configure /swift/libiconv-libicu-android/armeabi-v7a/icu/source/configure
COPY build.sh /swift/libiconv-libicu-android/build.sh
COPY android-ndk-r15c /swift/android-ndk

ENV PATH="/swift/android-ndk:${PATH}"

RUN cd /swift/libiconv-libicu-android/ && ./build.sh

RUN cd /swift/swift/ && utils/build-script \
    -R \
    --android \
    --android-ndk /swift/android-ndk \
    --android-api-level 21 \
    --android-icu-uc /swift/libiconv-libicu-android/armeabi-v7a \
    --android-icu-uc-include /swift/libiconv-libicu-android/armeabi-v7a/icu/source/common \
    --android-icu-i18n /swift/libiconv-libicu-android/armeabi-v7a \
    --android-icu-i18n-include /swift/libiconv-libicu-android/armeabi-v7a/icu/source/i18n


