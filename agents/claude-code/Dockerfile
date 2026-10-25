ARG CORE_IMAGE=ghcr.io/iomonad/slopenv/core:latest
FROM ${CORE_IMAGE}

RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="$PATH:/workspace/.local/bin"

ENTRYPOINT ["/sbin/tini", "--", "claude"]
