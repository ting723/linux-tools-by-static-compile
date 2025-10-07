# 继承基础构建环境
FROM static-tool-base AS htop-builder

# 安装htop专属依赖
RUN apk add --no-cache \
    ncurses-dev \
    ncurses-static

# 复制本地源码包并编译htop
COPY sources/htop-3.3.0.tar.xz /tmp/htop-3.3.0.tar.xz
RUN cd /tmp && \
    tar -xvf htop-3.3.0.tar.xz && \
    cd htop-3.3.0 && \
    ./configure --prefix=/usr/local \
                --enable-static \
                --disable-shared \
                --disable-unicode && \
    make LDFLAGS="-static -lncurses" -j$(nproc) && \
    mkdir -p /tools && \
    cp htop /tools/ && \
    strip /tools/htop

# 提取最终产物
FROM scratch
COPY --from=htop-builder /tools /tools
WORKDIR /tools
CMD ["/tools/htop"]