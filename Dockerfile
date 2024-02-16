FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Tunables
ARG INTEL_BASEKIT_VERSION=2024.0.1.46
ARG INTEL_HPCKIT_VERSION=2024.0.1.38
ARG CMAKE_VERSION=3.28.2

WORKDIR /root

RUN apt-get update && \
    apt-get upgrade -y && \
    # Installing what we need:
    # wget            is to download cmake and Intel's compiler
    # g++             is for gcc and ld
    # make            is for cmake's generation
    # libopenblas-dev is for BLAS header and library
    # git             is for cloning googletest and google-benchmark
    apt-get install -y wget g++ make libopenblas-dev git && \
    # Download Intel BaseKit (without --list-components it installs everything)
    wget --no-verbose https://registrationcenter-download.intel.com/akdlm/IRC_NAS/163da6e4-56eb-4948-aba3-debcec61c064/l_BaseKit_p_${INTEL_BASEKIT_VERSION}_offline.sh -O intel_basekit.sh && \
    echo "Before BaseKit installation" && \
    sh ./intel_basekit.sh -a --list-components && \
    sh ./intel_basekit.sh -a --action install --silent --eula accept && \
    echo "After BaseKit installation" && \
    sh ./intel_basekit.sh -a --list-components && \
    rm -f ./intel_basekit.sh && \
    # Download Intel HPCKit (without --list-components it installs everything)
    wget --no-verbose https://registrationcenter-download.intel.com/akdlm/IRC_NAS/67c08c98-f311-4068-8b85-15d79c4f277a/l_HPCKit_p_${INTEL_HPCKIT_VERSION}_offline.sh -O intel_hpckit.sh && \
    echo "Before HPCKit installation" && \
    sh ./intel_hpckit.sh -a --list-components && \
    sh ./intel_hpckit.sh -a --action install --silent --eula accept && \
    echo "After HPCKit installation" && \
    rm -f ./intel_hpckit.sh && \
    # Install Cmake
    wget --no-verbose https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    chmod +x cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    ./cmake-${CMAKE_VERSION}-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm -f ./cmake-${CMAKE_VERSION}-linux-x86_64.sh && \
    # Remove unneeded stuff
    apt-get remove wget -y && \
    apt-get autoremove -y && \
    # Setup environment variables automatically on startup
    echo ". /opt/intel/oneapi/setvars.sh" >> ~/.bashrc
