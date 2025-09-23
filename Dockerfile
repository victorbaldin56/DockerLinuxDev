FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

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
        zsh \
        lldb \
        valgrind \
        pkg-config \
        mesa-utils libgl1-mesa-glx \
        gcc-riscv64-unknown-elf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv .venv && \
    sh .venv/bin/activate && \
    pip install --no-cache-dir conan

WORKDIR /app
COPY . .
CMD zsh
