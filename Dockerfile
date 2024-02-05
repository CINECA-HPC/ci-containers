FROM ubuntu:22.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget g++ && \
    # Download Intel BaseKit 2024
    wget --no-verbose https://registrationcenter-download.intel.com/akdlm/IRC_NAS/163da6e4-56eb-4948-aba3-debcec61c064/l_BaseKit_p_2024.0.1.46_offline.sh && \
    sh ./l_BaseKit_p_2024.0.1.46_offline.sh -a --action install --components intel.oneapi.lin.dpl:intel.oneapi.lin.dpcpp-cpp-compiler:intel.oneapi.lin.mkl.devel --silent --eula accept && \
    rm -f ./l_BaseKit_p_2024.0.1.46_offline.sh && \
    # Download Intel HPCKit 2024
    wget --no-verbose https://registrationcenter-download.intel.com/akdlm/IRC_NAS/67c08c98-f311-4068-8b85-15d79c4f277a/l_HPCKit_p_2024.0.1.38_offline.sh && \
    sh ./l_HPCKit_p_2024.0.1.38_offline.sh -a --action install --components intel.oneapi.lin.dpcpp-cpp-compiler --silent --eula accept && \
    rm -f ./l_HPCKit_p_2024.0.1.38_offline.sh && \
    # Setup environment variables
    . /opt/intel/oneapi/setvars.sh && \
    # Remove unneeded stuff
    apt-get remove wget -y && \
    apt-get autoremove -y
