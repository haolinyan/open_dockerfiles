FROM crpi-iyh7vkeseh80me1w.cn-shenzhen.personal.cr.aliyuncs.com/yanhaolin/flashredcue:v0.0.3
SHELL ["/bin/bash", "-cu"]

RUN apt update && apt install librdmacm-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
