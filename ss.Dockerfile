# 继承基础构建环境
FROM static-tool-base AS ss-builder

# 复制本地源码包并编译iproute2 (ss)
COPY sources/iproute2-6.4.0.tar.xz /tmp/iproute2-6.4.0.tar.xz
RUN cd /tmp && \
    tar -xvf iproute2-6.4.0.tar.xz && \
    cd iproute2-6.4.0 && \
    ./configure --prefix=/usr/local && \
    make LDFLAGS="-static" -j$(nproc) && \
    make install

# 提取最终产物
FROM scratch
COPY --from=ss-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]