# slopenv

Personal sandboxed environment for domain-specific tasks

## Rationale

Most existing sandboxing solutions for AI agents are either bloated, overly complex, or closed-source.

`slopenv` takes a minimal, suckless, and non-intrusive approach to safely experimenting with AI agents. By combining a simple shell script with Docker, it provides a lightweight, reproducible workflow that just works out of the box.

## Usage

Run an agent in a sandboxed environment:

```bash
./bin/slopenv [-a agent] [directory]
```

- `-a agent` - Agent type to use (default: `opencode`)
- `[directory]` - Working directory to mount (default: current directory)

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
