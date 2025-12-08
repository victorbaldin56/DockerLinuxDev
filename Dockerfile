FROM ubuntu:24.04

ARG USER=dev
ENV DEBIAN_FRONTEND=noninteractive \
    PATH=/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    HOME=/home/${USER} \
    SHELL=/bin/bash \
    CC=/usr/bin/clang \
    CXX=/usr/bin/clang++

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        git \
        zsh \
        openssh-client \
        clang \
        clang-tools \
        make \
        cmake \
        python3 \
        python3-venv \
        python3-pip \
        lldb \
        valgrind \
        pkg-config \
        gcc-riscv64-unknown-elf \
        clangd \
        clang-format \
        build-essential \
        libasan8 \
        libclang-rt-18-dev \
        graphviz \
        libgraphviz-dev \
        linux-tools-generic \
        linux-tools-6.10.14-linuxkit \
        linux-cloud-tools-6.10.14-linuxkit && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 && \
    update-alternatives --set cc /usr/bin/clang && \
    update-alternatives --set c++ /usr/bin/clang++

RUN useradd -m -s /bin/zsh ${USER}

USER ${USER}
ENV HOME=/home/${USER} SHELL=/bin/zsh

CMD ["zsh", "-l"]
