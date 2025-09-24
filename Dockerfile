FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y zsh \
        clang \
        cmake \
        git \
        python3-full \
        lldb \
        valgrind \
        pkg-config \
        gcc-riscv64-unknown-elf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv .venv && \
    chmod +x ./venv/bin/activate && ./venv/bin/activate && \
    pip install --no-cache-dir conan

WORKDIR /app
COPY . .
CMD zsh
