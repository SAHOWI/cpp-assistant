# Make use ob Ubuntu as stable base
FROM ubuntu:22.04

# make it non-interactive during installation
ENV DEBIAN_FRONTEND=noninteractive

# Installation der notwendigen Build-Tools
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    python3 \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# create workdir app
WORKDIR /app

# Clone BitNet-Repo form Microsoft (this includes submodules for  llama.cpp)
RUN git clone --recursive git@github.com:microsoft/BitNet.git .

# install requirements
RUN pip3 install -r requirements.txt

# Build th eproject
# Standard build for CPU only, no further optimizations
RUN python3 setup.py build

# Default port for API server
EXPOSE 8080

# Initial starup command
# Will be overwritten/replaced later in podman-compose or via CMD
CMD ["/bin/bash"]