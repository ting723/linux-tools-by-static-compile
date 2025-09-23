# 继承基础构建环境
FROM static-tool-base AS lsof-builder

# 复制本地源码包并编译lsof
COPY sources/lsof-4.98.0.tar.gz /tmp/lsof-4.98.0.tar.gz
RUN cd /tmp && \
    tar -zxvf lsof-4.98.0.tar.gz && \
    cd lsof-4.98.0 && \
    ./Configure -n linux && \
    make LDFLAGS="-static" -j$(nproc) && \
    cp lsof /usr/local/bin/

# 提取最终产物
FROM scratch
COPY --from=lsof-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]