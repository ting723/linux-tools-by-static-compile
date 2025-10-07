#!/bin/bash

# This script downloads source packages and builds all static Linux tools Dockerfiles and extracts the binaries

# Download source packages if not already present
echo "Checking for source packages..."
if [ ! -d "../sources" ] || [ -z "$(ls -A ../sources)" ]; then
  echo "Source packages not found. Downloading..."
  ../scripts/download-sources.sh
else
  echo "Source packages already exist. Skipping download."
fi

# Build the base image first
echo "Building base image..."
if ! docker build -f Dockerfiles/base.Dockerfile -t static-tool-base ..; then
  echo "Error: Failed to build base image. Exiting."
  exit 1
fi

# Create release directory if it doesn't exist
mkdir -p ../release

# List of tools to build
TOOLS=(
  "atop"
  "dstat" 
  "htop"
  "iftop"
  "iotop"
  "lsof"
  "mtr"
  "nethogs"
  "ngrep"
  "nmap"
  "perf"
  "smartctl"
  "ss"
  "sysstat"
  "tcpdump"
)

echo "Starting build process for all tools..."

for tool in "${TOOLS[@]}"; do
  echo "Building $tool..."
  
  # Check if Dockerfile exists
  if [ ! -f "Dockerfiles/${tool}.Dockerfile" ] && [ ! -f "Dockerfiles/${tool}"*.Dockerfile ]; then
    echo "Warning: Dockerfile for $tool not found, skipping..."
    continue
  fi
  
  # Build the Docker image
  if ! docker build -f Dockerfiles/${tool}.Dockerfile -t ${tool}-static ..; then
    echo "Error: Failed to build $tool. Skipping..."
    continue
  fi
  
  # Extract binaries from the image directly to release directory using docker cp
  case $tool in
    "atop")
      # Extract atop binary from /tools directory
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/atop ../release/atop
      docker rm -v $id > /dev/null
      chmod +x ../release/atop
      ;;
    "sysstat")
      # Extract sysstat binaries individually
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/iostat ../release/iostat
      docker cp $id:/tools/sar ../release/sar
      docker cp $id:/tools/mpstat ../release/mpstat
      docker cp $id:/tools/pidstat ../release/pidstat
      docker cp $id:/tools/iotop ../release/iotop-sysstat  # Avoid conflict with iotop tool
      docker rm -v $id > /dev/null
      chmod +x ../release/iostat ../release/sar ../release/mpstat ../release/pidstat ../release/iotop-sysstat
      ;;
    "dstat")
      # Extract dstat binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/dstat ../release/dstat
      docker rm -v $id > /dev/null
      chmod +x ../release/dstat
      ;;
    "htop")
      # Extract htop binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/htop ../release/htop
      docker rm -v $id > /dev/null
      chmod +x ../release/htop
      ;;
    "iftop")
      # Extract iftop binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/iftop ../release/iftop
      docker rm -v $id > /dev/null
      chmod +x ../release/iftop
      ;;
    "iotop")
      # Extract iotop binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/iotop ../release/iotop
      docker rm -v $id > /dev/null
      chmod +x ../release/iotop
      ;;
    "lsof")
      # Extract lsof binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/lsof ../release/lsof
      docker rm -v $id > /dev/null
      chmod +x ../release/lsof
      ;;
    "mtr")
      # Extract mtr binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/mtr ../release/mtr
      docker rm -v $id > /dev/null
      chmod +x ../release/mtr
      ;;
    "nethogs")
      # Extract nethogs binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/nethogs ../release/nethogs
      docker rm -v $id > /dev/null
      chmod +x ../release/nethogs
      ;;
    "ngrep")
      # Extract ngrep binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/ngrep ../release/ngrep
      docker rm -v $id > /dev/null
      chmod +x ../release/ngrep
      ;;
    "nmap")
      # Extract nmap binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/nmap ../release/nmap
      docker rm -v $id > /dev/null
      chmod +x ../release/nmap
      ;;
    "perf")
      # Extract perf binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/perf ../release/perf
      docker rm -v $id > /dev/null
      chmod +x ../release/perf
      ;;
    "smartctl")
      # Extract smartctl binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/smartctl ../release/smartctl
      docker rm -v $id > /dev/null
      chmod +x ../release/smartctl
      ;;
    "ss")
      # Extract ss binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/ss ../release/ss
      docker rm -v $id > /dev/null
      chmod +x ../release/ss
      ;;
    "tcpdump")
      # Extract tcpdump binary
      id=$(docker create ${tool}-static)
      docker cp $id:/tools/tcpdump ../release/tcpdump
      docker rm -v $id > /dev/null
      chmod +x ../release/tcpdump
      ;;
  esac
  
  echo "Finished building $tool"
  echo "------------------------------"
done

echo "All tools built successfully!"
echo "Binaries are located in the release/ directory"