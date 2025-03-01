# SwitchML Project
# @file rdma.dockerfile
# @brief Generates an image that can be used to run switchml's benchmarks with the rdma backend.
#
# IMPORTANT: For RDMA to work, you must pass `--cap-add=IPC_LOCK --device=/dev/infiniband/<NIC name>` arguments when starting.
# You also still need to manually disable ICRC checking on the host machine. Take a look at our disable_icrc.sh script in the scripts folder.
#
# A typical command to start the container is:
# docker run -it --gpus all --net=host --cap-add=IPC_LOCK --device=/dev/infiniband/uverbs0 --name switchml-rdma <name_of_the_image_created_from_this_file>
#

FROM crpi-iyh7vkeseh80me1w.cn-shenzhen.personal.cr.aliyuncs.com/yanhaolin/switchml:11.2.2-devel-ubuntu18.04

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

ARG TIMEOUTS=1
ARG VCL=0
ARG DEBUG=1

# General packages needed
RUN apt-get update && \
    apt install -y \
    git \
    wget \
    vim \
    nano \
    build-essential \
    net-tools \
  iputils-ping \
    sudo \
    gpg \ 
    lsb-release \
    software-properties-common

# Add kitware's APT repository for cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | \
    tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt update

# General and RDMA client library requirements
RUN apt install -y \
    gcc \
    make \
    libboost-program-options-dev \
    libgoogle-glog-dev \
    autoconf \
    libtool \
    pkg-config \
    libibverbs-dev \
    libhugetlbfs-dev \
    cmake \
    libssl-dev libpcap-dev perftest

RUN git clone https://github.com/the-tcpdump-group/tcpdump.git /usr/local/tcpdump && \
    git clone https://github.com/the-tcpdump-group/libpcap.git /usr/local/libpcap && \
    cd /usr/local/libpcap && git checkout libpcap-1.10.4 && \
    chmod +x configure && \
    ./configure --enable-rdma && \
    make install && \
    cd ../tcpdump && \
    sed -i 's/AC_PROG_CC_C99/AC_PROG_CC/g' configure.ac && \
    autoreconf -fiv || ./autogen.sh && \
    ./configure && \
    make
