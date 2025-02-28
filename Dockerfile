FROM crpi-iyh7vkeseh80me1w.cn-shenzhen.personal.cr.aliyuncs.com/yanhaolin/flashredcue:11.8.0-devel-ubuntu22.04
SHELL ["/bin/bash", "-cu"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    # 基础系统工具和包管理依赖
    apt-utils \
    lsb-release \
    software-properties-common \
    sudo \
    \
    # 核心开发工具链
    build-essential \
    gcc \
    make \
    cmake \
    autoconf \
    libtool \
    pkg-config \
    \
    # 网络/调试工具
    net-tools \
    iputils-ping \
    wget \
    openssh-server \
    libpcap-dev \
    \
    # 基础开发库
    libssl-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libboost-program-options-dev \
    nlohmann-json3-dev \
    \
    # 高性能计算相关
    libibverbs-dev \
    libhugetlbfs-dev \
    openmpi-common \
    openmpi-bin \
    libopenmpi-dev \
    perftest \
    \
    # 系统工具和编辑器
    vim \
    nano \
    git \
    gdb \
    gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Add kitware's APT repository for cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
    gpg --dearmor - | \
    tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt update
RUN apt-get update && apt-get install -y --no-install-recommends cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
