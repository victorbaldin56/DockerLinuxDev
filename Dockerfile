FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH=/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    SHELL=/bin/bash

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        openssh-client \
        zsh \
        clang \
        clang-tools \
        make \
        cmake \
        git \
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
        graphviz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 && \
    update-alternatives --set cc /usr/bin/clang && \
    update-alternatives --set c++ /usr/bin/clang++

ENV CC=/usr/bin/clang \
    CXX=/usr/bin/clang++

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir conan

ARG USER=dev

RUN useradd -m -s /bin/zsh ${USER}

RUN mkdir -p /home/${USER} && \
    chown -R ${USER} /opt/venv /home/${USER}

RUN printf '\n# Auto-activate system venv if present\nif [ -f /opt/venv/bin/activate ]; then\n  source /opt/venv/bin/activate\nfi\n' >> /home/${USER}/.zshrc

USER ${USER}
ENV HOME=/home/${USER}

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

CMD ["zsh", "-l"]
