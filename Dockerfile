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
        graphviz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN if ! grep -qxF '/bin/zsh' /etc/shells 2>/dev/null; then echo '/bin/zsh' >> /etc/shells; fi

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 && \
    update-alternatives --set cc /usr/bin/clang && \
    update-alternatives --set c++ /usr/bin/clang++

RUN useradd -m -s /bin/zsh ${USER}

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir conan

RUN git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /home/${USER}/.oh-my-zsh && \
    cp /home/${USER}/.oh-my-zsh/templates/zshrc.zsh-template /home/${USER}/.zshrc && \
    printf '\n# Auto-activate system venv if present\nif [ -f /opt/venv/bin/activate ]; then\n  source /opt/venv/bin/activate\nfi\n' >> /home/${USER}/.zshrc && \
    chown -R ${USER}:${USER} /home/${USER} /opt/venv

USER ${USER}
ENV HOME=/home/${USER} SHELL=/bin/zsh

CMD ["zsh", "-l"]
