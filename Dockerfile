ARG CUDA_VERSION=11.4.3

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

# Tunables
ARG INTEL_ONEAPI_VERSION=2024.2.0.495
ARG CMAKE_VERSION=3.29.6

WORKDIR /root
RUN apt-get update && \
    apt-get upgrade -y && \
    # wget is to download cmake and Intel OneAPI compiler installers
    apt-get install --no-install-recommends -y wget && \
    # add LLVM GPG key to download clang-format 17
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal main' >> /etc/apt/sources.list && \
    echo 'deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main' >> /etc/apt/sources.list && \
    echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-17 main' >> /etc/apt/sources.list && \
    echo 'deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-17 main' >> /etc/apt/sources.list && \
    apt-get update && \
    # Installing what we need:
    # curl             is to download CodePlay NVIDIA add-on (the recommended way)
    # ca-certificates  is for HTTPS certificates
    # intel-opencl-icd is for Intel LevelZero driver
    # g++              is for g++ and ld, needed by Intel OneAPI compiler
    # make             is for cmake's generation
    # libopenblas-dev  is for BLAS header and library
    # clang-format     is needed to check code formatting
    apt-get install --no-install-recommends -y curl ca-certificates g++ make libopenblas-dev intel-opencl-icd clang-format-17 && \
    # Download and install Intel OneAPI standalone compiler
    wget --no-verbose https://registrationcenter-download.intel.com/akdlm/IRC_NAS/6780ac84-6256-4b59-a647-330eb65f32b6/l_dpcpp-cpp-compiler_p_${INTEL_ONEAPI_VERSION}_offline.sh -O intel_dpcpp.sh && \
    sh ./intel_dpcpp.sh -a --action install --components intel.oneapi.lin.dpcpp-cpp-compiler --silent --eula accept && \
    rm -f ./intel_dpcpp.sh && \
    # Install Cmake
    wget --no-verbose https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    ./cmake-${CMAKE_VERSION}-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm -f ./cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    # Install CodePlay NVIDIA add-on
    curl -LOJ "https://developer.codeplay.com/api/v1/products/download?product=oneapi&variant=nvidia&version=2024.2.0&filters[]=12.0&filters[]=linux" && \
    sh ./oneapi-for-nvidia-gpus-2024.2.0-cuda-12.0-linux.sh && \
    rm -f ./oneapi-for-nvidia-gpus-2024.2.0-cuda-12.0-linux.sh && \
    # Remove unneeded stuff
    apt-get remove curl wget ca-certificates -y && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    # apt/apt-get will not work after this point
    rm -rf /var/lib/apt/lists/* && \
    # Setup environment variables automatically on startup
    echo ". /opt/intel/oneapi/setvars.sh" >> ~/.bashrc && \
    ln /usr/bin/clang-format-18 /usr/bin/clang-format
