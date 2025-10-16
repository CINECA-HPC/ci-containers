ARG UBUNTU_VERSION=20.04
ARG CUDA_VERSION=11.4.3
FROM ubuntu:${UBUNTU_VERSION} AS builder

# Tunables
ARG INTEL_ONEAPI_VERSION=2024.2.0.495
ARG CMAKE_VERSION=3.29.6

RUN apt update && \
    apt upgrade -y && \
    # Installing what we need:
    # wget             is to download cmake and Intel OneAPI compiler installers
    # curl             is to download CodePlay NVIDIA add-on (the recommended way)
    # ca-certificates  is for HTTPS certificates
    apt install --no-install-recommends -y wget curl ca-certificates && \
    # Download and install Intel OneAPI standalone compiler
    wget --no-verbose -O /tmp/intel_dpcpp.sh https://registrationcenter-download.intel.com/akdlm/IRC_NAS/6780ac84-6256-4b59-a647-330eb65f32b6/l_dpcpp-cpp-compiler_p_${INTEL_ONEAPI_VERSION}_offline.sh && \
    echo "9463aa979314d2acc51472d414ffcee032e9869ca85ac6ff4c71d39500e5173d /tmp/intel_dpcpp.sh" > /tmp/checksum.txt && \
    sha256sum --check /tmp/checksum.txt && \
    sh /tmp/intel_dpcpp.sh -a --action install --components intel.oneapi.lin.dpcpp-cpp-compiler --silent --eula accept && \
    # Install Cmake
    wget -O /tmp/install-cmake -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x /tmp/install-cmake && \
    /tmp/install-cmake --skip-license --prefix=/usr/local && \
    # Install CodePlay NVIDIA add-on
    curl --fail -LJ "https://gitlab.hpc.cineca.it/aguarnie/mirror-codeplay/-/raw/master/oneapi-for-nvidia-gpus-2024.2.1-cuda-12.0-linux.sh?ref_type=heads&inline=false" -o /tmp/codeplay.sh && \
    echo "0622df0054364b01e91e7ed72a33cb3281e281db5b0e86579f516b1cc5336b0f /tmp/codeplay.sh" >> /tmp/codeplay_checksum.txt && \
    sha256sum --check /tmp/codeplay_checksum.txt && \
    sh /tmp/codeplay.sh --yes
    
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
COPY --from=builder /opt/intel /opt/intel
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share /usr/local/share

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
