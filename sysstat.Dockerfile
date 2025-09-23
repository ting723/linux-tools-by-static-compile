# 继承基础构建环境
FROM static-tool-base AS sysstat-builder

# 复制本地源码包并编译sysstat (iostat, pidstat, sar)
COPY sources/sysstat-12.7.5.tar.gz /tmp/sysstat-12.7.5.tar.gz
RUN cd /tmp && \
    tar -zxvf sysstat-12.7.5.tar.gz && \
    cd sysstat-12.7.5 && \
    ./configure --prefix=/usr/local --enable-static --disable-shared && \
    make LDFLAGS="-static" -j$(nproc) && \
    make install

# 提取最终产物
FROM scratch
COPY --from=sysstat-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]