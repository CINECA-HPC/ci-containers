ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.3.2
FROM ubuntu:${UBUNTU_VERSION} AS builder

# Tunables
ARG INTEL_ONEAPI_VERSION=2025.1.1.9
ARG CMAKE_VERSION=3.29.6

RUN apt update && \
    apt upgrade -y && \
    # Installing what we need:
    # wget             is to download cmake and Intel OneAPI compiler installers
    # curl             is to download CodePlay NVIDIA add-on (the recommended way)
    # ca-certificates  is for HTTPS certificates
    apt install --no-install-recommends -y wget curl ca-certificates && \
    # Download and install Intel OneAPI standalone compiler
    wget --no-verbose -O /tmp/intel_dpcpp.sh https://registrationcenter-download.intel.com/akdlm/IRC_NAS/c4d2aef3-3123-475e-800c-7d66fd8da2a5/intel-dpcpp-cpp-compiler-${INTEL_ONEAPI_VERSION}_offline.sh && \
    echo "63ea61f54a5ea9d30059ea499697e04953915ef317c0e8fc457077b690c726df /tmp/intel_dpcpp.sh" > /tmp/checksum.txt && \
    sha256sum --check /tmp/checksum.txt && \
    sh /tmp/intel_dpcpp.sh -a --action install --components intel.oneapi.lin.dpcpp-cpp-compiler --silent --eula accept && \
    # Install Cmake
    wget -O /tmp/install-cmake -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x /tmp/install-cmake && \
    /tmp/install-cmake --skip-license --prefix=/usr/local && \
    # Install CodePlay NVIDIA add-on
    curl --fail-with-body -LJ "https://developer.codeplay.com/api/v1/products/download?product=oneapi&version=2025.1.1&variant=nvidia&filters[]=linux" -o /tmp/codeplay.sh && \
    echo "45e1d7c42c1915904daf9f3291b2f01622e897c7b661aebd28d6b293ce14fb9d /tmp/codeplay.sh" >> /tmp/codeplay_checksum.txt && \
    sha256sum --check /tmp/codeplay_checksum.txt && \
    chmod +x /tmp/codeplay.sh && \
    /tmp/codeplay.sh --yes

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
COPY --from=builder /opt/intel /opt/intel
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share /usr/local/share

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
