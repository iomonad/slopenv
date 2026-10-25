# AGENTS.md

This document provides context for coding agents working in this repository.

## Project
slopenv is a minimal, suckless sandbox for running AI agents. It uses a small shell script + Docker to mount a working directory and run an agent in a containerized, reproducible environment.

## Architecture
- Entry: `bin/slopenv [-a agent] [-x] [-l] [directory]` (defaults: agent=`opencode`, directory=`$PWD`; agents: `opencode`, `claude-code`). Resolves absolute path, validates directory and agent. Runs `docker run --rm -it --name slopenv-<agent>-<project>-<pid>` with `-v "$workdir:/workspace/<basename>"`, `-w /workspace`, `--user "$(id -u):$(id -g)"`, env `HOME=/workspace`, `TERM` (default `xterm-256color`), `LANG` (default `C.UTF-8`). Executes image `ghcr.io/iomonad/slopenv/agent/${agent}:latest` with arg `/workspace/<basename>`.
- Images:
  - Base: `base/Dockerfile` builds `ghcr.io/iomonad/slopenv/core:latest` (FROM `alpine:3.24.3` pinned by digest). Installs `tini`, `libstdc++`, `libgcc`, `ripgrep`, `bash`, `curl`, `jq`, `git`. Creates user `marvin` (`adduser -D -h /workspace -s /bin/bash marvin`), sets `USER marvin`, `WORKDIR /workspace`. Sets `ENV LANG=C.UTF-8 TERM=xterm-256color` and `HOME=/workspace` (on separate line).
  - Agents: `agents/<agent>/Dockerfile` FROM core. Current `opencode`: installs via `curl -fsSL https://opencode.ai/v2/install | bash`, sets `ENV PATH="$PATH:/workspace/.opencode/bin"`, `ENTRYPOINT ["/sbin/tini", "--", "opencode"]`, `CMD ["/workspace"]`.
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
- The launcher passes `-w /workspace` and mounts as `-v "$workdir:/workspace/<basename>"`, then runs with `/workspace/<basename>` as positional arg to the container (agent sees the project dir). User is mapped to host uid/gid.
- Persistence (default, `-x` disables): `~/.slopenv/agents/<agent>` is bind-mounted read-write at `/workspace/.agent-persist` and symlinked into the agent's config paths at startup. Beware: if the image already ships that path as a real directory (claude-code's `~/.claude`), `ln -snf` silently nests the link inside it; replace the directory first. Never replace `~/.opencode`, it holds the binary.
- Base sets `HOME=/workspace` for the non-root user.
- Opencode install is pulled from the official installer (curl | bash).

### VCS
- The agent should never push code but can commit under the email iomonad@riseup.net and the username iomonad
- For each non planning commit and update CHANGELOG.md
- Commit format used: Conventional Commits 1.0.0
  - Format: <type>[optional scope]: <description>
  - Notes: you should try to specify scope when you can
  
  
## Bit of context

Unix enthusiast, permanently skeptical of "AI." 
This project has a single objective: **don't die stupid** and keep track of how agentic coding evolves.

I won't be part of the AI botnet system. I condemn the AI bots that trample content licenses, congest the internet, and pile onto the environmental toll of this whole thing.

The repo is used deliberately, for personal education, to measure the progression of agentic coding.

If possible, abuse sarcasm at all the levels (commit messages, changelog & readme)
