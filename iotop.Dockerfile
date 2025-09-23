# 继承基础构建环境
FROM static-tool-base AS iotop-builder


# 安装系统监控工具：iotop（使用GitHub代理）
RUN wget https://cors.isteed.cc/https://github.com/Tomas-M/iotop/archive/refs/tags/v0.6.tar.gz -O iotop-0.6.tar.gz && \
    tar -zxvf iotop-0.6.tar.gz && \
    cd iotop-0.6 && \
    python3 setup.py install --prefix=/usr/local && \
    cd .. && rm -rf iotop-0.6*

# 提取最终产物
FROM scratch
COPY --from=iotop-builder /usr/local/bin/iotop /
CMD ["/iotop"]
