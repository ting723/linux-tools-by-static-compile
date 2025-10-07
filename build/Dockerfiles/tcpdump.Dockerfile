# 基于Alpine Linux（musl环境）
FROM alpine:latest

# 替换Alpine默认源为阿里云镜像（加速apk包下载）
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装编译依赖（包含内核头文件）
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    make \
    flex \
    bison \
    wget \
    tar \
    gzip \
    linux-headers

# 创建工作目录
WORKDIR /build

# 下载并编译libpcap（静态库）
RUN wget https://www.tcpdump.org/release/libpcap-1.10.4.tar.gz && \
    tar -zxvf libpcap-1.10.4.tar.gz && \
    cd libpcap-1.10.4 && \
    ./configure \
        --prefix=/usr/local \
        --enable-static \
        --disable-shared \
        --with-pcap=linux && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf libpcap-1.10.4*

# 下载并编译tcpdump（静态链接）
RUN wget https://www.tcpdump.org/release/tcpdump-4.99.4.tar.gz && \
    tar -zxvf tcpdump-4.99.4.tar.gz && \
    cd tcpdump-4.99.4 && \
    ./configure \
        --prefix=/usr/local \
        --with-pcap=/usr/local \
        CFLAGS="-static -Os" \
        LDFLAGS="-static" && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf tcpdump-4.99.4*

# 最终产物：/usr/local/bin/tcpdump

