# slopenv

Personal sandboxed environment for domain-specific tasks

## Build

You can build all images with the provided script:

```bash
./build.sh
```

Or build them manually:

```bash
# Build core/base image
docker build -t ghcr.io/iomonad/slopenv/core:latest base

# Build OpenCode agent image
docker build -t ghcr.io/iomonad/slopenv/agent/opencode:latest agents/opencode
```
