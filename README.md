# slopenv

Personal sandboxed environment for domain-specific tasks

## Rationale

Most existing sandboxing solutions for AI agents are either bloated, overly complex, or closed-source.

`slopenv` takes a minimal, suckless, and non-intrusive approach to safely experimenting with AI agents. By combining a simple shell script with Docker, it provides a lightweight, reproducible workflow that just works out of the box.

## Installation

Install `slopenv` to your user bin path (defaults to `~/.local/bin`):

```bash
./install.sh
# or: ./install.sh ~/.local/bin
```

If the install directory isn't in your `PATH`, add it to your shell rc as suggested.

## Usage

Run an agent in a sandboxed environment:

```bash
slopenv [-a agent] [-x] [-l] [-L] [-v] [directory]
# or from repo: ./bin/slopenv [-a agent] [-x] [-l] [-L] [-v] [directory]
```

- `-a agent` - Agent type to use (default: `opencode`). See [Available Agents](#available-agents).
- `-x` - Disable persistence (by default, agent configuration is persisted)
- `-l` - List available agents
- `-L` - List active sessions with their uptime
- `-v` - Show the version: the release tag for a built script, the commit hash when run from the repo, `unknown` otherwise
- `[directory]` - Working directory to mount (default: current directory)

If the docker daemon is not running, `slopenv` asks whether to start it through `systemctl` (systemd) or `rc-service` (openrc), using `sudo` or `doas` when not root. Answering anything but yes aborts, and so does running without a terminal. Because apparently remembering to start a daemon is now also a task worth automating, but not one worth automating *without asking*.

### Persistence

By default, slopenv persists agent configuration in the current user's home directory under `~/.slopenv/agents/<agent-name>/`. This directory is mounted into the container and symlinked to the agent's expected configuration locations, so authentication and settings persist across runs. Use `-x` to run without persistence.

## Agents & Free Tier

- `opencode` (default): Provider-agnostic. You can use local models (e.g., [Ollama](https://ollama.com/)) or free models from providers like [OpenRouter](https://www.openrouter.ai/) without a paid Anthropic subscription. Some providers may require API keys or have rate limits. Authentication and provider configuration are handled inside OpenCode within the container.
- `claude-code`: Requires authentication with Anthropic (Pro, Max, Enterprise, or API credits). There is currently no widely available free tier for Claude Code usage.

## Build

You can build all images with the provided script:

```bash
./build.sh
```

Images are tagged with the commit hash, plus `latest`. Set `SLOPENV_VERSION` to tag them with a release name instead, which also writes `dist/slopenv` with that version baked in:

```bash
SLOPENV_VERSION=0.1.0 ./build.sh
```

Pushing a tag runs `.github/workflows/release.yml`, which does exactly that and attaches `dist/slopenv` to a GitHub release. The images are built on the runner and not pushed anywhere, because nothing pulls them yet.

Or build them manually:

```bash
# Build core/base image
docker build -t ghcr.io/iomonad/slopenv/core:latest base

# Build OpenCode agent image
docker build -t ghcr.io/iomonad/slopenv/agent/opencode:latest agents/opencode

# Build Claude Code agent image
docker build -t ghcr.io/iomonad/slopenv/agent/claude-code:latest agents/claude-code
```

## License

This project is licensed under the [WTFPL](LICENSE).
