#!/bin/bash

# This script downloads all source packages to the local sources directory

set -e  # Exit on any error

# Create sources directory if it doesn't exist
mkdir -p ../sources

echo "Downloading all source packages..."

# Function to download file only if it doesn't exist
download_if_not_exists() {
    local file_path=$1
    local url=$2
    local description=$3
    
    if [ -f "$file_path" ]; then
        echo "Skipping $description (already exists)"
    else
        echo "Downloading $description..."
        wget -O "$file_path" "$url"
    fi
}

# Download atop
download_if_not_exists "../sources/atop-2.10.0.tar.gz" "https://www.atoptool.nl/download/atop-2.10.0.tar.gz" "atop"

# Download sysstat
download_if_not_exists "../sources/sysstat-12.7.5.tar.gz" "https://cors.isteed.cc/https://github.com/sysstat/sysstat/archive/refs/tags/v12.7.5.tar.gz" "sysstat"

# Download dstat
download_if_not_exists "../sources/dstat-0.7.4.tar.gz" "https://cors.isteed.cc/https://github.com/dstat-real/dstat/archive/refs/tags/v0.7.4.tar.gz" "dstat"

# Download iftop
download_if_not_exists "../sources/iftop-1.0pre4.tar.gz" "http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre4.tar.gz" "iftop"

# Download iotop
download_if_not_exists "../sources/iotop-1.30.tar.xz" "https://cors.isteed.cc/https://github.com/Tomas-M/iotop/archive/refs/tags/v1.30.tar.xz" "iotop"

# Download nethogs
if [ -f "../sources/nethogs.tar.gz" ]; then
    echo "Skipping nethogs (already exists)"
else
    echo "Downloading nethogs..."
    git clone https://cors.isteed.cc/https://github.com/raboof/nethogs.git ../sources/nethogs-tmp
    cd ../sources/nethogs-tmp && git checkout v0.8.7 && cd ../..
    tar -czf ../sources/nethogs.tar.gz -C ../sources nethogs-tmp
    rm -rf ../sources/nethogs-tmp
fi

# Download iproute2 (ss)
download_if_not_exists "../sources/iproute2-6.4.0.tar.xz" "https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.4.0.tar.xz" "iproute2"

# Download lsof
download_if_not_exists "../sources/lsof-4.98.0.tar.gz" "https://cors.isteed.cc/https://github.com/lsof-org/lsof/archive/refs/tags/4.98.0.tar.gz" "lsof"

# Download mtr
download_if_not_exists "../sources/mtr-0.95.tar.gz" "https://cors.isteed.cc/https://github.com/traviscross/mtr/archive/refs/tags/v0.95.tar.gz" "mtr"

# Download nmap
download_if_not_exists "../sources/nmap-7.94.tar.bz2" "https://nmap.org/dist/nmap-7.94.tar.bz2" "nmap"

# Download ngrep
# Fixed URL for ngrep v1.47
download_if_not_exists "../sources/ngrep-1.47.tar.gz" "https://github.com/jpr5/ngrep/archive/refs/tags/V1_47.tar.gz" "ngrep"

# Download smartmontools
download_if_not_exists "../sources/smartmontools-7.3.tar.gz" "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.3/smartmontools-7.3.tar.gz" "smartmontools"

# Download htop
download_if_not_exists "../sources/htop-3.3.0.tar.xz" "https://cors.isteed.cc/https://github.com/htop-dev/htop/releases/download/3.3.0/htop-3.3.0.tar.xz" "htop"

echo "All source packages downloaded successfully!"