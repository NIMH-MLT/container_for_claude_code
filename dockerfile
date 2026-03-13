FROM ubuntu:24.04

# install everything that needs to be installed by root

## general dependencies

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates curl git openssh-client \
  && rm -rf /var/lib/apt/lists/*

## python

# Update the package list and install Python 3 and pip
# Combine commands to reduce image size and improve caching
RUN apt-get update && \
    apt-get install -y python3 python3-pip python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

## miniconda

### Install necessary system dependencies (curl, bzip2, etc.)
RUN apt-get update && apt-get install -y \
    curl \
    bzip2 \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

### Download and install Miniconda in one RUN command to keep image size small
RUN curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /opt/miniconda \
    && rm /tmp/miniconda.sh

### Add the conda binary folder to the PATH environment variable
ENV PATH=/opt/miniconda/bin:$PATH

### (Optional) Update conda itself after installation
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
RUN conda update -n base -c defaults conda --yes


# switch to using an unprivileged user

## create an unprivileged user
RUN useradd -m -u 10001 -s /bin/bash claude
USER claude

## install claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

## prevent Claude Code from clearing the KV cache 
RUN echo "{\"env\": {\"CLAUDE_CODE_ATTRIBUTION_HEADER\": \"0\"}}" >> /home/claude/.claude/settings.json
# and also in an environment variable for good measure
ENV CLAUDE_CODE_ATTRIBUTION_HEADER=0

## set other environment variables
ENV PATH="$PATH:/home/claude/.local/bin"
ENV HOME="/home/claude"


WORKDIR /workspace
