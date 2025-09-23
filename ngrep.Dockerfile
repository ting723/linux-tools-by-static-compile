# 继承基础构建环境
FROM static-tool-base AS ngrep-builder

# 安装ngrep专属依赖（如果需要）
RUN apk add --no-cache \
    libpcap-dev

# 复制本地源码包并编译ngrep
COPY sources/ngrep-1.47.tar.gz /tmp/ngrep-1.47.tar.gz
RUN cd /tmp && \
    tar -zxvf ngrep-1.47.tar.gz && \
    cd ngrep-1.47 && \
    autoreconf -i && \
    ./configure --prefix=/usr/local --enable-static --disable-shared --with-pcap=/usr && \
    make LDFLAGS="-static" -j$(nproc) && \
    make install

# 提取最终产物
FROM scratch
COPY --from=ngrep-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]