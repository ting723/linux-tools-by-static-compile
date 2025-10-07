# 继承基础构建环境
FROM static-tool-base AS perf-builder

# 安装perf专属依赖（如果需要）
RUN apk add --no-cache \
    elfutils-dev \
    libunwind-dev \
    zlib-dev \
    openssl-dev

# 复制本地源码包并编译perf
COPY sources/linux-6.4.12.tar.xz /tmp/linux-6.4.12.tar.xz
RUN cd /tmp && \
    tar -xvf linux-6.4.12.tar.xz && \
    cd linux-6.4.12/tools/perf && \
    make LDFLAGS="-static" -j$(nproc) && \
    cp perf /usr/local/bin/

# 提取最终产物
FROM scratch
COPY --from=perf-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]