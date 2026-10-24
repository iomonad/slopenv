FROM ghcr.io/iomonad/slopenv/core:latest

RUN curl -fsSL https://opencode.ai/v2/install | bash
ENV PATH="$PATH:/workspace/.opencode/bin"

ENTRYPOINT ["/sbin/tini", "--", "opencode"]
CMD ["/workspace"]
