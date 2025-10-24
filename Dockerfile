FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH=/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    SHELL=/bin/bash

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        zsh \
        clang \
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
        clang-format && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir conan

ARG USER=dev
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${USER} || true && \
    useradd -m -u ${UID} -g ${GID} -s /bin/zsh ${USER} || true

RUN mkdir -p /home/${USER} && \
    chown -R ${UID}:${GID} /opt/venv /home/${USER}

RUN printf '\n# Auto-activate system venv if present\nif [ -f /opt/venv/bin/activate ]; then\n  source /opt/venv/bin/activate\nfi\n' >> /home/${USER}/.zshrc && \
    chown ${UID}:${GID} /home/${USER}/.zshrc

USER ${USER}
ENV HOME=/home/${USER}

CMD ["zsh", "-l"]
