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

- `-a agent` - Agent type to use (default: `opencode`). Supported: `opencode`, `claude-code`
- `[directory]` - Working directory to mount (default: current directory)

## Agents & Free Tier

- `opencode` (default): Provider-agnostic. You can use local models (e.g., [Ollama](https://ollama.com/)) or free models from providers like [OpenRouter](https://www.openrouter.ai/) without a paid Anthropic subscription. Some providers may require API keys or have rate limits. Authentication and provider configuration are handled inside OpenCode within the container.
- `claude-code`: Requires authentication with Anthropic (Pro, Max, Enterprise, or API credits). There is currently no widely available free tier for Claude Code usage.

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

# Build Claude Code agent image
docker build -t ghcr.io/iomonad/slopenv/agent/claude-code:latest agents/claude-code
```

## License

This project is licensed under the [WTFPL](LICENSE).
