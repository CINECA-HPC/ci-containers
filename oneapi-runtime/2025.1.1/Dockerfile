ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.3.2

FROM ubuntu:${UBUNTU_VERSION} AS builder1

RUN apt update && \
    apt upgrade -y && \
    # Installing what we need:
    # wget             is to download Intel OneAPI runtime
    # ca-certificates  is for HTTPS certificates
    # gnupg2           is to add the Intel APT repository
    apt install --no-install-recommends -y wget ca-certificates gnupg2 && \
    wget -qO- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | apt-key add - && \
    echo "deb https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list && \
    apt update && \
    apt install -y --no-install-recommends intel-oneapi-compiler-dpcpp-cpp-2025.1

FROM ubuntu:${UBUNTU_VERSION} AS builder2

RUN apt update && \
    apt upgrade -y && \
    # Installing what we need:
    # wget             is to download Intel OneAPI runtime
    # ca-certificates  is for HTTPS certificates
    # gnupg2           is to add the Intel APT repository
    apt install --no-install-recommends -y wget ca-certificates gnupg2 && \
    wget -qO- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | apt-key add - && \
    echo "deb https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list && \
    apt update && \
    apt install -y --no-install-recommends \
        intel-oneapi-compiler-dpcpp-cpp-runtime \
        intel-oneapi-runtime-dpcpp-sycl-rt \
        intel-oneapi-runtime-dpcpp-sycl-gpu-rt

FROM nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}
COPY --from=builder2 /opt/intel /opt/intel
COPY --from=builder1 /opt/intel/oneapi/compiler/latest/bin/sycl-ls /opt/intel/oneapi/compiler/latest/bin/sycl-ls

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
