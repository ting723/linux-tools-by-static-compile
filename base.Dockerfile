FROM alpine:latest AS builder

# 替换为阿里云源加速下载
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装基础编译工具
RUN apk update && apk add --no-cache \
    build-base \
    musl-dev \
    linux-headers \
    git \
    autoconf \
    automake \
    libtool \
    pkgconfig \
    ncurses-dev \
    ncurses-static \
    libpcap-dev \
    libnl3-dev \
    elfutils-dev \
    zlib-dev \
    zlib-static \
    flex \
    bison \
    wget \
    tar \
    gzip \
    xz \
    cmake \
    python3 \
    python3-dev
