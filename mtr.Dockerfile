# 继承基础构建环境
FROM static-tool-base AS mtr-builder

# 复制本地源码包并编译mtr
COPY sources/mtr-0.95.tar.gz /tmp/mtr-0.95.tar.gz
RUN cd /tmp && \
    tar -zxvf mtr-0.95.tar.gz && \
    cd mtr-0.95 && \
    autoreconf -i && \
    ./configure --prefix=/usr/local --enable-static --disable-shared && \
    make LDFLAGS="-static" -j$(nproc) && \
    make install

# 提取最终产物
FROM scratch
COPY --from=mtr-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]