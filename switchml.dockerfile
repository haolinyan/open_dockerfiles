FROM crpi-iyh7vkeseh80me1w.cn-shenzhen.personal.cr.aliyuncs.com/yanhaolin/switchml:v0.0.0
SHELL ["/bin/bash", "-cu"]
RUN sudo apt-get update && sudo apt-get install bison byacc autoconf automake libtool -y && sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*
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
