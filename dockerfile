FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates curl git openssh-client \
  && rm -rf /var/lib/apt/lists/*

# create an unprivileged user
RUN useradd -m -u 10001 -s /bin/bash claude
USER claude

# install claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH="$PATH:/home/claude/.local/bin"
ENV HOME="/home/claude"

WORKDIR /workspace