# 继承基础构建环境
FROM static-tool-base AS smartctl-builder

# 复制本地源码包并编译smartmontools (smartctl)
COPY sources/smartmontools-7.3.tar.gz /tmp/smartmontools-7.3.tar.gz
RUN cd /tmp && \
    tar -zxvf smartmontools-7.3.tar.gz && \
    cd smartmontools-7.3 && \
    ./configure --prefix=/usr/local --enable-static --disable-shared && \
    make LDFLAGS="-static" -j$(nproc) && \
    make install

# 提取最终产物
FROM scratch
COPY --from=smartctl-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]