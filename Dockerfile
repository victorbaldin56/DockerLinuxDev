FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    apt-get install -y zsh \
        clang \
        cmake \
        git \
        python3 \
        python3-venv \
        python3-pip \
        lldb \
        valgrind \
        pkg-config \
        gcc-riscv64-unknown-elf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv .venv && \
    source .venv/bin/activate && \
    pip install --no-cache-dir conan

WORKDIR /app
COPY . .
CMD zsh && source .venv/bin/activate
