# Linux Tools by Static Compile

This project provides statically compiled Linux tools that can run in different environments without dynamic library dependencies.

## Tools Included

1. **atop** - System and process monitor
2. **dstat** - Versatile resource statistics tool
3. **htop** - Interactive process viewer
4. **iftop** - Network interface bandwidth monitoring
5. **iotop** - I/O usage monitoring
6. **lsof** - List open files
7. **mtr** - Network diagnostic tool
8. **nethogs** - Network bandwidth usage by process
9. **ngrep** - Network grep tool
10. **nmap** - Network discovery and security auditing
11. **perf** - Linux performance monitoring tool
12. **smartctl** - SMART hard drive monitoring
13. **ss** - Socket statistics tool
14. **sysstat** - System performance tools (iostat, sar, pidstat)
15. **tcpdump** - Network packet analyzer

## How to Build

### Download Source Packages

Before building, you need to download the source packages:

```bash
chmod +x download-sources.sh
./download-sources.sh
```

This will download all source packages to the `sources/` directory. The build process will use these local copies instead of downloading them each time.

### Build Individual Tool

To build a specific tool, use the corresponding Dockerfile:

```bash
docker build -f <tool>.Dockerfile -t <tool>-static .
```

For example, to build htop:

```bash
docker build -f htop.Dockerfile -t htop-static .
```

### Extract Static Binary

After building, extract the binary from the Docker image:

```bash
docker run --rm <tool>-static cat /tools/<tool> > <tool> && chmod +x <tool>
```

For example, to extract htop:

```bash
docker run --rm htop-static cat /tools/htop > htop && chmod +x htop
```

### Build All Tools

Run the build script to build all tools at once:

```bash
chmod +x build-all.sh
./build-all.sh
```

The binaries will be placed directly in the `release/` directory.

### Extract Binaries Script

You can also use the extraction script to pull binaries from existing Docker images:

```bash
chmod +x extract-binaries.sh
./extract-binaries.sh
```

This will extract all available tools from their respective Docker images directly to the `release/` directory.

## Requirements

- Docker
- Unix-like system (Linux, macOS, WSL)
- wget, git, tar (for downloading source packages)

## Benefits

- **Static linking**: No dependency on shared libraries
- **Portable**: Binaries can be copied and run on any compatible system
- **Lightweight**: Minimal footprint
- **Universal**: Works across different Linux distributions
- **Efficient**: Source packages downloaded once and reused