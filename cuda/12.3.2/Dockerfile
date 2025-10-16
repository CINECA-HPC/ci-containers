ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.3.2
FROM ubuntu:${UBUNTU_VERSION} AS builder

# Tunables
ARG CMAKE_VERSION=3.29.6

RUN apt-get update && \
    apt-get upgrade -y && \
    # Installing what we need:
    # wget             is to download cmake
    apt-get install --no-install-recommends -y wget ca-certificates && \
    # Install Cmake
    wget -O /tmp/install-cmake -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x /tmp/install-cmake && \
    /tmp/install-cmake --skip-license --prefix=/usr/local

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share /usr/local/share
