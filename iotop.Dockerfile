# 继承基础构建环境
FROM static-tool-base AS iotop-builder

# 复制本地源码包并编译iotop
COPY sources/iotop-1.30.tar.xz /tmp/iotop-1.30.tar.xz
RUN cd /tmp && \
    tar -xvf iotop-1.30.tar.xz && \
    cd iotop-1.30 && \
    make LDFLAGS="-static" && \
    cd .. && \
    mkdir -p /tools && \
    cp iotop-1.30/iotop /tools/ && \
    strip /tools/iotop

# 提取最终产物
FROM scratch
COPY --from=iotop-builder /tools /tools
WORKDIR /tools
CMD ["/tools/iotop"]