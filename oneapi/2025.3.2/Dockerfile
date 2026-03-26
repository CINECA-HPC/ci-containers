ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION} AS builder

# Tunables
ARG INTEL_ONEAPI_VERSION=2025.3.2.26
ARG CMAKE_VERSION=3.29.6

RUN apt update && \
    apt upgrade -y && \
    # Installing what we need:
    # wget             is to download cmake and Intel OneAPI compiler installers
    # curl             is to download CodePlay NVIDIA add-on (the recommended way)
    # ca-certificates  is for HTTPS certificates
    apt install --no-install-recommends -y wget curl ca-certificates && \
    # Download and install Intel OneAPI standalone compiler
    wget --no-verbose -O /tmp/intel_dpcpp.sh https://registrationcenter-download.intel.com/akdlm/IRC_NAS/0d61d48a-4fe8-4cb2-bd9d-94d2c19c6227/intel-dpcpp-cpp-compiler-${INTEL_ONEAPI_VERSION}_offline.sh && \
    echo "37d6c9c22f90fbb4d2072fd45d0284f2b6b1ffd030d699e1e7a669087d093396 /tmp/intel_dpcpp.sh" > /tmp/checksum.txt && \
    sha256sum --check /tmp/checksum.txt && \
    sh /tmp/intel_dpcpp.sh -a --action install --components intel.oneapi.lin.dpcpp-cpp-compiler --silent --eula accept && \
    # Install Cmake
    wget -O /tmp/install-cmake -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x /tmp/install-cmake && \
    /tmp/install-cmake --skip-license --prefix=/usr/local && \
    # Install CUDA
    wget -O /tmp/cuda-keyring.deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i /tmp/cuda-keyring.deb && \
    apt update && \
    apt install -y --no-install-recommends cuda-minimal-build-12-3 && \
    # University of Salerno NVIDIA Plugin
    curl --fail-with-body -L "https://github.com/unisa-hpc/oneapi-plugins/releases/download/v2025.3/oneapi-ur-cuda-linux-x86_64-2025.3.sh" -o /tmp/oneapi-ur-cuda-linux-x86_64-2025.3.sh && \
    echo "8cbf18ab93bb1f2b2145aa591814778f1434e46603641f9b13f6fc70f2f531dc  /tmp/oneapi-ur-cuda-linux-x86_64-2025.3.sh" | sha256sum -c - && \
    chmod +x /tmp/oneapi-ur-cuda-linux-x86_64-2025.3.sh && \
    /tmp/oneapi-ur-cuda-linux-x86_64-2025.3.sh --oneapi-root /opt/intel/oneapi

FROM ubuntu:${UBUNTU_VERSION}
COPY --from=builder /opt/intel /opt/intel
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share /usr/local/share
COPY --from=builder /usr/local/cuda-12.3 /usr/local/cuda-12.3

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
