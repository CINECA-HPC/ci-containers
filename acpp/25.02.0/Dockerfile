FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    cmake \
    gcc \
    g++ \
    make \
    libboost-all-dev \
    wget \
    lsb-release \
    software-properties-common \
    gnupg \
    curl \
    && \
    # Download and install LLVM 20
    wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 20 all && \
    # Download and install AdaptiveCpp 25.02.0
    git clone https://github.com/AdaptiveCpp/AdaptiveCpp.git && \
    cd AdaptiveCpp && \
    git checkout v25.02.0 && \
    cd /AdaptiveCpp && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j "$(nproc)" && \
    make install

# Set environment variables (if needed)
ENV PATH="/usr/local/bin:${PATH}" \
    LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
