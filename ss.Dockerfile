# 继承基础构建环境（基于 Alpine 3.22）
FROM static-tool-base AS ss-builder

# 安装所需依赖包，包括 libmnl-dev 及编译工具
RUN apk add --no-cache \
    gcc \
    make \
    musl-dev \
    libmnl-dev \
    elfutils-dev \
    bison \
    flex \
    tar \
    binutils \
    wget \
    build-base \
    libbpf-dev

# 手动下载并编译 libmnl 静态库
RUN wget https://netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2 && \
    tar -xvf libmnl-1.0.4.tar.bz2 && \
    cd libmnl-1.0.4 && \
    ./configure && \
    make && \
    make install

# 复制源码并编译 iproute2
COPY sources/iproute2-6.4.0.tar.xz /tmp/iproute2-6.4.0.tar.xz
RUN cd /tmp && \
    tar -xvf iproute2-6.4.0.tar.xz && \
    cd iproute2-6.4.0 && \
    \
    # 修复 basename 函数未声明
    sed -i '1i #include <libgen.h>' lib/bpf_legacy.c && \
    \
    # 修复宏重定义警告
    for file in lib/ll_proto.c lib/ll_addr.c lib/ll_types.c lib/cg_map.c lib/rose_ntop.c; do \
        sed -i '/#include \"..\/include\/uapi\/linux\/sockios.h\"/i #undef SIOCGSTAMP\n#undef SIOCGSTAMPNS' "$file"; \
        if [ "$file" = "lib/cg_map.c" ]; then \
            sed -i '/#include \"..\/include\/uapi\/linux\/limits.h\"/i #undef NGROUPS_MAX' "$file"; \
        fi; \
    done && \
    \
    # 配置编译路径（统一前缀）
    ./configure --prefix=/tmp/iproute2-install \
                --with-mnl=/usr \
                --with-elf=/usr \
                --disable-shared \
                --no-git \
                --libbpf_dir=/usr \
                --libdir=/usr/lib \
                --include_dir=/usr/include \
                --libbpf_force=on \
                --verbose LDFLAGS="-static -L/usr/lib -lmnl -lz -lzstd -static-libgcc -static-libstdc++" && \
    \
    # 静态编译
    make LDFLAGS="-static" -j$(nproc) GIT_COMMIT=unknown && \
    make install && \
    \
    # 复制所有工具（增加工具名列表）
    mkdir -p /tmp/iproute2-core-tools && \
    for tool in ip ss tc rtmon bridge arp arping ip6tnl mtr; do \
        src="/tmp/iproute2-install/bin/$tool"; \
        [ -f "$src" ] && cp -v "$src" /tmp/iproute2-core-tools/; \
    done && \
    \
    # 使用 strip 压缩二进制文件以减小体积
    for tool in /tmp/iproute2-core-tools/*; do \
        strip --strip-all "$tool"; \
    done && \
    \
    # 清理临时文件
    rm -rf /tmp/iproute2-6.4.0* /tmp/iproute2-install

# 提取最终产物
FROM scratch
COPY --from=ss-builder /tmp/iproute2-core-tools /tools/iproute2
WORKDIR /tools/iproute2
CMD ["sh", "-c", "echo '已安装工具：'; ls -l"]
