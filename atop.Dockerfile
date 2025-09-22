# 继承基础构建环境
FROM static-tool-base AS atop-builder

# 复制本地源码包并编译atop


# 安装atop专属依赖
RUN apk add --no-cache \
    build-base \
    wget tar \
    glib-dev glib-static \
    pcre2-dev pcre2-static \
    gettext-dev gettext-static \
    ncurses-dev ncurses-static \
    zlib-dev zlib-static \
    pkgconf

COPY sources/atop-2.10.0.tar.gz /tmp/atop-2.10.0.tar.gz

RUN cd /tmp && \
    tar -zxvf atop-2.10.0.tar.gz && \
    cd atop-2.10.0 && \
    sed -i 's/^LDFLAGS.*/LDFLAGS = -static $(shell pkg-config --static --libs glib-2.0) -lncurses -lz -lm -lrt/' Makefile && \
    make -j$(nproc) && \
    strip atop && \
    file atop | grep "statically linked" && \
    mkdir -p /tools && \
    cp atop /usr/local/bin/ && \
    cp atop /tools/ && \
    strip /tools/atop

# 提取最终产物
FROM scratch
COPY --from=atop-builder /tools /tools
WORKDIR /tools
CMD ["/tools/atop", "-V"]
