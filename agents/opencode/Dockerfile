ARG CORE_IMAGE=ghcr.io/iomonad/slopenv/core:latest
FROM ${CORE_IMAGE}

RUN curl -fsSL https://opencode.ai/v2/install | bash
ENV PATH="$PATH:/workspace/.opencode/bin"

ENTRYPOINT ["/sbin/tini", "--", "opencode"]
CMD ["/workspace"]
