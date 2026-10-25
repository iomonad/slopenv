FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

RUN apk add --no-cache \
    tini \
    libstdc++ libgcc \
    ripgrep \
    bash \
    curl \
    jq \
    git \
    github-cli

RUN adduser -D -h /workspace -s /bin/bash marvin
USER marvin
WORKDIR /workspace

ENV LANG=C.UTF-8 \
    TERM=xterm-256color \
    HOME=/workspace
