# 继承基础构建环境
FROM static-tool-base AS dstat-builder

# 复制本地源码包并安装dstat
COPY sources/dstat-0.7.4.tar.gz /tmp/dstat-0.7.4.tar.gz
RUN cd /tmp && \
    tar -zxvf dstat-0.7.4.tar.gz && \
    cd dstat-0.7.4 && \
    make install DESTDIR=/tmp/dstat-install prefix=/usr

# 提取最终产物
FROM scratch
COPY --from=dstat-builder /tmp/dstat-install/usr/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]