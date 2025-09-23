# 继承基础构建环境
FROM static-tool-base AS nmap-builder

# 安装nmap专属依赖（如果需要）
RUN apk add --no-cache \
    bzip2-dev \
    libpcap-dev

# 复制本地源码包并编译nmap
COPY sources/nmap-7.94.tar.bz2 /tmp/nmap-7.94.tar.bz2
RUN cd /tmp && \
    tar -jxvf nmap-7.94.tar.bz2 && \
    cd nmap-7.94 && \
    ./configure --prefix=/usr/local \
                --enable-static \
                --disable-shared \
                --without-zenmap \
                --without-nmap-update && \
    make LDFLAGS="-static" -j$(nproc) && \
    make install

# 提取最终产物
FROM scratch
COPY --from=nmap-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]