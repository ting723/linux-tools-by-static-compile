docker build -t tcpdump-musl-builder .
docker run --rm -v $(pwd):/output tcpdump-musl-builder cp /usr/local/bin/tcpdump /output/
