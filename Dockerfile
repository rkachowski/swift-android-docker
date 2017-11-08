FROM ubuntu:16.04
MAINTAINER Donald Hutchison <contact@donaldhutchison.info>

RUN apt-get -q update && \
    apt-get -q install -y \
    autoconf\
    automake\
    clang\
    cmake\
    cmake ninja-build\
    curl\
    git\
    icu-devtools\
    libblocksruntime-dev\
    libbsd-dev\
    libcurl4-openssl-dev\
    libedit-dev\
    libicu-dev\
    libncurses5-dev\
    libpython-dev\
    libsqlite3-dev\
    libtool\
    libxml2-dev\
    ninja-build\
    pkg-config\
    python\
    swig\
    systemtap-sdt-dev\
    tzdata\
    unzip\
    uuid-dev


ENV INSTALL_PATH /swift
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

RUN git clone https://github.com/SwiftAndroid/libiconv-libicu-android.git && \
    git clone https://github.com/apple/swift.git &&\
    cd /swift/swift/ && utils/update-checkout --clone &&\
    cd ../libiconv-libicu-android &&\
    mkdir armeabi-v7a &&\
    cd armeabi-v7a &&\
    tar xvf ../icu4c-55_1-src.tgz

RUN cd /swift && curl -O https://dl.google.com/android/repository/android-ndk-r15c-linux-x86_64.zip  && unzip android-ndk-r15c-linux-x86_64.zip && rm android-ndk-r15c-linux-x86_64.zip 

ENV PATH="/swift/android-ndk-r15c:${PATH}"

COPY configure /swift/libiconv-libicu-android/armeabi-v7a/icu/source/configure
COPY build.sh /swift/libiconv-libicu-android/build.sh

RUN cd /swift/libiconv-libicu-android/ && ./build.sh

RUN cd /swift/swift/ && utils/build-script \
    -R \
    --android \
    --android-ndk /swift/android-ndk-r15c \
    --android-api-level 21 \
    --android-icu-uc /swift/libiconv-libicu-android/armeabi-v7a \
    --android-icu-uc-include /swift/libiconv-libicu-android/armeabi-v7a/icu/source/common \
    --android-icu-i18n /swift/libiconv-libicu-android/armeabi-v7a \
    --android-icu-i18n-include /swift/libiconv-libicu-android/armeabi-v7a/icu/source/i18n


