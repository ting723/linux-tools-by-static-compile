# 继承基础构建环境
FROM static-tool-base AS mtr-builder

# 安装mtr构建依赖
RUN apk add --no-cache \
    autoconf \
    automake \
    libtool

# 复制本地源码包并编译mtr
COPY sources/mtr-0.95.tar.gz /tmp/mtr-0.95.tar.gz
RUN cd /tmp && \
    tar -zxvf mtr-0.95.tar.gz && \
    cd mtr-0.95 && \
    autoreconf -i && \
    ./configure --prefix=/usr/local --enable-static --disable-shared && \
    make LDFLAGS="-static" -j$(nproc) && \
    cd .. && \
    mkdir -p /tools && \
    cp mtr-0.95/mtr /tools/ && \
    cp mtr-0.95/mtr-packet /tools/ && \
    strip /tools/mtr && \
    strip /tools/mtr-packet

# 提取最终产物
FROM scratch
COPY --from=mtr-builder /tools /tools
WORKDIR /tools
CMD ["/tools/mtr"]