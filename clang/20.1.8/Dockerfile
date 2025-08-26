ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION} AS builder

# Tunables
ARG CMAKE_VERSION=3.29.6

RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends wget ca-certificates gnupg2 make && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "\
deb http://apt.llvm.org/noble/ llvm-toolchain-noble-20 main \n\
deb-src http://apt.llvm.org/noble/ llvm-toolchain-noble-20 main\n" >> /etc/apt/sources.list && \
    apt update -y && \
    apt install -y --no-install-recommends \
       clang-20 \
       libclang-rt-20-dev \
       libc++-20-dev \
       libc++abi-20-dev \
       lld-20 \
       clang-format-20 \
       clang-tidy-20 && \
    ln -s /usr/bin/clang-20 /usr/bin/clang && \
    ln -s /usr/bin/clang++-20 /usr/bin/clang++ && \
    ln -s /usr/bin/lld-20 /usr/bin/lld && \
    ln -s /usr/bin/clang-format-20 /usr/bin/clang-format && \
    ln -s /usr/bin/clang-tidy-20 /usr/bin/clang-tidy && \
    # Install Cmake
    wget -O /tmp/install-cmake -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x /tmp/install-cmake && \
    /tmp/install-cmake --skip-license --prefix=/usr/local

FROM ubuntu:${UBUNTU_VERSION}
COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/lib/llvm-20 /usr/lib/llvm-20
COPY --from=builder /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
COPY --from=builder /usr/lib/gcc /usr/lib/gcc
COPY --from=builder /usr/include /usr/include
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share /usr/local/share
