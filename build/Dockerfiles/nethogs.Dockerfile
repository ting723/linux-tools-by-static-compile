FROM static-tool-base AS nethogs-builder

# 安装nethogs专属依赖（如果需要）
RUN apk add --no-cache \
    libpcap-dev \
    ncurses-dev

# 复制本地源码包并编译nethogs
COPY sources/nethogs.tar.gz /tmp/nethogs.tar.gz
RUN cd /tmp && \
    tar -zxvf nethogs.tar.gz && \
    cd nethogs-tmp && \
    make CFLAGS="-static" LDFLAGS="-static" -j$(nproc) && \
    cp src/nethogs /usr/local/bin/

# 提取最终产物
FROM scratch
COPY --from=nethogs-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]