FROM debian:trixie-slim AS base

USER root

RUN apt-get update -qqy && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
        autoconf autoconf-archive automake bash bison build-essential \
        busybox-static bsdutils bzip2 coreutils curl diffutils file findutils \
        flex gawk git gperf grep gzip jq libtool make nano openssh-client perl \
        rsync sed unzip wget xz-utils zip && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
        cmake ninja-build python3 subversion && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
        help2man libdbus-1-dev libicu-dev libncurses-dev libpng-dev pigz \
        python3-pip tclsh texinfo zlib1g-dev libjpeg-dev gcc-multilib && \
    rm -rf /var/lib/apt/lists

FROM base AS build

ENV HOME=/root
WORKDIR /root

ENV TC=arm-kindle5-linux-gnueabi

SHELL ["/bin/bash", "-c"]

RUN git clone https://github.com/koreader/koxtoolchain/

RUN wget -nv https://github.com/koreader/koxtoolchain/releases/download/2025.05/kindle5.tar.gz && \
    tar xzf kindle5.tar.gz && \
    rm kindle5.tar.gz

COPY ./python3 /root/python3

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN source koxtoolchain/refs/x-compile.sh k4 env &&\
    source $HOME/.local/bin/env &&\
    uv venv --python 3.9 &&\
    uv pip install crossenv &&\
    source .venv/bin/activate &&\
    python -m crossenv ./python3/bin/python3.9 cross

RUN echo "source koxtoolchain/refs/x-compile.sh k4 env" >>.bashrc
RUN echo "source .venv/bin/activate" >>.bashrc
RUN echo "source ./cross/bin/activate" >>.bashrc

CMD ["/bin/bash"]
