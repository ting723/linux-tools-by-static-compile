# Linux Tools - Static Compile

This project provides a set of Linux system tools compiled statically to solve compatibility issues caused by dynamic library dependencies across different environments.

## Directory Structure

```
.
├── build/                 # Build related files
│   ├── Dockerfiles/       # Docker build files for each tool
│   ├── patches/           # Patches for fixing build issues
│   ├── build-all.sh       # Script to build all tools
│   └── extract-binaries.sh # Script to extract binaries from Docker images
├── sources/               # Source code packages for all tools
├── release/               # Statically compiled binaries
├── scripts/               # Utility scripts
│   └── download-sources.sh # Script to download all source packages
└── README.md
```

## Tools Included

1. [atop](https://www.atoptool.nl/) - System and process monitor
2. [sysstat](https://github.com/sysstat/sysstat) - A collection of performance monitoring tools for Linux (iostat, mpstat, pidstat, sar)
3. [dstat](https://github.com/dstat-real/dstat) - Versatile resource statistics tool
4. [htop](https://github.com/htop-dev/htop) - Interactive process viewer
5. [iftop](http://www.ex-parrot.com/pdw/iftop/) - Display bandwidth usage on an interface
6. [iotop](https://github.com/Tomas-M/iotop) - Top like utility for I/O
7. [nethogs](https://github.com/raboof/nethogs) - Net top tool grouping bandwidth per process
8. [iproute2](https://wiki.linuxfoundation.org/networking/iproute2) - Collection of utilities for controlling TCP/IP networking (ss)
9. [lsof](https://github.com/lsof-org/lsof) - List open files
10. [mtr](https://github.com/traviscross/mtr) - Network diagnostic tool
11. [nmap](https://nmap.org/) - Network discovery and security auditing
12. [ngrep](https://github.com/jpr5/ngrep) - Network grep
13. [smartmontools](https://www.smartmontools.org/) - SMART monitoring tools (smartctl)
14. [perf](https://perf.wiki.kernel.org/) - Linux profiling and tracing tool
15. [tcpdump](https://www.tcpdump.org/) - Command-line packet analyzer

## Prerequisites

- Docker
- Unix-like system (Linux, macOS, WSL)
- wget, git, tar

## Usage

### Download source packages

```bash
cd scripts
chmod +x download-sources.sh
./download-sources.sh
```

### Build all tools

```bash
cd build
chmod +x build-all.sh
./build-all.sh
```

### Build a specific tool

```bash
cd build
docker build -f Dockerfiles/<tool>.Dockerfile -t <tool>-static ..
```

For example:
```bash
cd build
docker build -f Dockerfiles/htop.Dockerfile -t htop-static ..
```

### Extract binaries

```bash
cd build
chmod +x extract-binaries.sh
./extract-binaries.sh
```

The binaries will be extracted to the [release/](file:///home/zhanglw/github/linux-tools-by-static-compile/release) directory.

### Extract a specific binary

```bash
# Create a temporary container
id=$(docker create <tool>-static)

# Copy the binary
docker cp $id:/tools/<tool> ../release/<tool>

# Remove the temporary container
docker rm -v $id
```

## How It Works

1. [download-sources.sh](file:///home/zhanglw/github/linux-tools-by-static-compile/scripts/download-sources.sh) downloads source packages to the [sources/](file:///home/zhanglw/github/linux-tools-by-static-compile/sources) directory
2. Each `<tool>.Dockerfile` references the source code in [sources/](file:///home/zhanglw/github/linux-tools-by-static-compile/sources) and performs static compilation
3. `docker build` generates an image containing the static binary
4. [extract-binaries.sh](file:///home/zhanglw/github/linux-tools-by-static-compile/build/extract-binaries.sh) or `docker run cat` extracts the binary from the image to [release/](file:///home/zhanglw/github/linux-tools-by-static-compile/release)

## Building Process

All tools are built using Alpine Linux with musl libc for static compilation. Each Dockerfile follows a multi-stage build pattern:

1. First stage: Install build dependencies and compile the tool statically
2. Second stage: Copy the static binary to a scratch image

This ensures that the final binaries have no external dependencies and can run on any x86_64 Linux system.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.