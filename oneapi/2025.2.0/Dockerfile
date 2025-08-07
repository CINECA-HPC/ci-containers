ARG CUDA_VERSION=12.5.1

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu24.04

ARG DEBIAN_FRONTEND=noninteractive

# Tunables
ARG INTEL_ONEAPI_VERSION=2025.2.0.527
ARG CMAKE_VERSION=3.29.6

WORKDIR /root
RUN apt-get update && \
    apt-get upgrade -y && \
    # wget is to download cmake and Intel OneAPI compiler installers
    apt-get install --no-install-recommends -y wget && \
    # add LLVM GPG key to download clang-format 20
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo 'deb http://apt.llvm.org/noble/ llvm-toolchain-noble main' >> /etc/apt/sources.list && \
    echo 'deb-src http://apt.llvm.org/noble/ llvm-toolchain-noble main' >> /etc/apt/sources.list && \
    echo 'deb http://apt.llvm.org/noble/ llvm-toolchain-noble-20 main' >> /etc/apt/sources.list && \
    echo 'deb-src http://apt.llvm.org/noble/ llvm-toolchain-noble-20 main' >> /etc/apt/sources.list && \
    apt-get update && \
    # Installing what we need:
    # curl             is to download CodePlay NVIDIA add-on (the recommended way)
    # ca-certificates  is for HTTPS certificates
    # intel-opencl-icd is for Intel LevelZero driver
    # g++              is for g++ and ld, needed by Intel OneAPI compiler
    # make             is for cmake's generation
    # clang-format     is needed to check code formatting
    apt-get install --no-install-recommends -y curl ca-certificates g++ make intel-opencl-icd clang-format-20 && \
    # Download and install Intel OneAPI standalone compiler
    wget --no-verbose -O /tmp/intel_dpcpp.sh https://registrationcenter-download.intel.com/akdlm/IRC_NAS/39c79383-66bf-4f44-a6dd-14366e34e255/intel-dpcpp-cpp-compiler-${INTEL_ONEAPI_VERSION}_offline.sh && \
    echo "aea3c1ccb97728db138b4f11f771411264292ba7bbec313782229510c9b831bc /tmp/intel_dpcpp.sh" > /tmp/checksum.txt && \
    sha256sum --check /tmp/checksum.txt && \
    sh /tmp/intel_dpcpp.sh -a --action install --components intel.oneapi.lin.dpcpp-cpp-compiler --silent --eula accept && \
    # Install Cmake
    wget -O /tmp/install-cmake -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x /tmp/install-cmake && \
    /tmp/install-cmake --skip-license --prefix=/usr/local && \
    # Install CodePlay NVIDIA add-on
    curl -LJ "https://developer.codeplay.com/api/v1/products/download?product=oneapi&version=2025.2.0&variant=nvidia&filters[]=linux" -o /tmp/codeplay.sh && \
    echo "84c0225131da6d066144a56ab3bd6213314a894ef4346d400140185b2f97bdc7 /tmp/codeplay.sh" >> /tmp/codeplay_checksum.txt && \
    sha256sum --check /tmp/codeplay_checksum.txt && \
    chmod +x /tmp/codeplay.sh && \
    /tmp/codeplay.sh --yes && \
    # Remove unneeded stuff
    apt-get remove curl wget ca-certificates -y && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /tmp/* && \
    rm -rf /var/intel && \
    # apt/apt-get will not work after this point
    rm -rf /var/lib/apt/lists/* && \
    ln /usr/bin/clang-format-20 /usr/bin/clang-format

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
