# 继承基础构建环境
FROM static-tool-base AS iftop-builder

# 安装iftop专属依赖（如果需要）
RUN apk add --no-cache \
    libpcap-dev

# 复制本地源码包和补丁文件并编译iftop
COPY sources/iftop-1.0pre4.tar.gz /tmp/iftop-1.0pre4.tar.gz
RUN cd /tmp && \
    tar -zxvf iftop-1.0pre4.tar.gz && \
    cd iftop-1.0pre4 && \
    ./configure --prefix=/usr/local --enable-static --disable-shared && \
    make LDFLAGS="-static -lpthread" -j$(nproc) && \
    make install

# 提取最终产物
FROM scratch
COPY --from=iftop-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]