# AGENTS.md

This document provides context for coding agents working in this repository.

## Project
slopenv is a minimal, suckless sandbox for running AI agents. It uses a small shell script + Docker to mount a working directory and run an agent in a containerized, reproducible environment.

## Architecture
- Entry: `bin/slopenv [-a agent] [directory]` (defaults: agent=`opencode`, directory=`$PWD`). Resolves absolute path, validates directory, runs `docker run` mounting to `/workspace/$workdir`, sets user/uid:gid, env vars (`HOME=/workspace`, `TERM`, `LANG`), and executes the agent image with the target path.
- Images:
  - Base: `base/Dockerfile` builds `ghcr.io/iomonad/slopenv/core:latest` (Alpine 3.24.3, packages: tini, libstdc++ libgcc, ripgrep, bash, curl, jq, git; creates user `marvin`, workdir `/workspace`).
  - Agents: `agents/<agent>/Dockerfile` FROM core, install/setup agent, set ENTRYPOINT/CMD. Current: `opencode` installs via `https://opencode.ai/v2/install`, adds `/workspace/.opencode/bin` to PATH, entrypoint `["/sbin/tini","--","opencode"]`, cmd `["/workspace"]`.
- Build: `build.sh` builds core then opencode agent.

## Key files
- `bin/slopenv` - runtime launcher
- `base/Dockerfile`, `build.sh` - base image/build
- `agents/opencode/Dockerfile` - OpenCode agent
- `README.md`, `CHANGELOG.md`, `LICENSE` (WTFPL v2)

## Conventions
- Keep minimal/suckless; avoid heavy orchestration.
- Preserve image tagging: `ghcr.io/iomonad/slopenv/core:latest` and `ghcr.io/iomonad/slopenv/agent/<name>:latest`.
- When adding agents: create `agents/<name>/Dockerfile` following opencode pattern, update `build.sh` if desired, and ensure `bin/slopenv` can select it via `-a <name>`.
- Keep README and CHANGELOG in sync with changes.
- License is WTFPL v2.

## Development notes
- The launcher passes `-w /workspace` and mounts as `-v "$workdir:/workspace/$workdir"`, then runs with `/workspace/$workdir` as positional arg to the container (agent sees the project dir). User is mapped to host uid/gid.
- Base sets `HOME=/workspace` for the non-root user.
- Opencode install is pulled from the official installer (curl | bash).
- The agent should never commit and push code.
