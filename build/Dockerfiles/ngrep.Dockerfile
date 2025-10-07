# 继承基础构建环境
FROM static-tool-base AS ngrep-builder

# 安装ngrep专属依赖（如果需要）
RUN apk add --no-cache \
    libpcap-dev \
    pcre-dev \
    gcc \
    musl-dev \
    libc-dev \
    make

# 复制本地源码包并编译ngrep
COPY sources/ngrep-1.47.tar.gz /tmp/ngrep-1.47.tar.gz
RUN cd /tmp && \
    tar -zxvf ngrep-1.47.tar.gz && \
    cd ngrep-1_47 && \
    # 修改为正确的路径来添加缺失的头文件
    sed -i 's/#include <ctype.h>/#include <ctype.h>\n#include <stdlib.h>\n#include <string.h>/' regex-0.12/regex.c && \
    sed -i 's/#include <unistd.h>/#include <unistd.h>\n#include <stdlib.h>/' regex.c && \
    # Patch ngrep.c to include missing headers
    sed -i '100i#include <ctype.h>\n#include <unistd.h>\n#include <stdlib.h>\n#include <string.h>\n#include <time.h>' ngrep.c && \
    # Patch ngrep.h to define missing constants
    sed -i '28i#define USE_VLAN_HACK 1' ngrep.h && \
    # 完全移除 regex 库的引用
    rm -rf regex-0.12 && \
    # 让 Makefile 强制不使用 regex-0.12
    sed -i '/regex-0.12/d' Makefile && \
    # 禁用 alloca 并确保不使用内置库
    sed -i 's/#define FREE_VARIABLES() alloca (0)/#define FREE_VARIABLES()/' ngrep.c && \
    # 确保只使用系统的 PCRE 库
    autoreconf -i && \
    ./configure --prefix=/usr/local --enable-pcre && \
    # 修正 Makefile 以避免 -C 标志的问题
    sed -i 's/\$(MAKE) \$(MAKEFLAGS) -C/\$(MAKE) -C/' Makefile && \
    make LDFLAGS="-static -lpcre" CPPFLAGS="-static -DUSE_PCRE=1" -j$(nproc) && \
    cp ngrep /usr/local/bin/

# 提取最终产物
FROM scratch
COPY --from=ngrep-builder /usr/local/bin /tools
WORKDIR /tools
CMD ["sh", "-c", "ls -l /tools"]
