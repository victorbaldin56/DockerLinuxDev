FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y zsh

SHELL ["/bin/zsh", "-c"]
RUN apt-get update && \
    apt-get install -y \
        pocl-opencl-icd \
        ocl-icd-opencl-dev \
        clinfo \
        clang \
        python3 \
        python3-pip \
        python3-venv \
        cmake \
        git \
        python3-full \
        lldb \
        valgrind \
        pkg-config \
        mesa-utils \
        gcc-riscv64-unknown-elf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv .venv && \
    source .venv/bin/activate && \
    pip install --no-cache-dir conan

WORKDIR /app
COPY . .
CMD zsh
