#!/bin/bash

set -eu

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: not a git repository" >&2
  exit 1
fi

COMMIT="$(git rev-parse --short HEAD 2>/dev/null)"
if [ -z "${COMMIT}" ]; then
  echo "Error: unable to determine commit" >&2
  exit 1
fi

CORE_COMMIT="ghcr.io/iomonad/slopenv/core:${COMMIT}"
CORE_LATEST="ghcr.io/iomonad/slopenv/core:latest"

AGENT_OPENCODE_COMMIT="ghcr.io/iomonad/slopenv/agent/opencode:${COMMIT}"
AGENT_OPENCODE_LATEST="ghcr.io/iomonad/slopenv/agent/opencode:latest"

AGENT_CLAUDE_CODE_COMMIT="ghcr.io/iomonad/slopenv/agent/claude-code:${COMMIT}"
AGENT_CLAUDE_CODE_LATEST="ghcr.io/iomonad/slopenv/agent/claude-code:latest"

# Build Core
echo "Building core: ${CORE_COMMIT} and tagging as ${CORE_LATEST}"
docker build -t "${CORE_COMMIT}" base
docker tag "${CORE_COMMIT}" "${CORE_LATEST}"

# Build Opencode Agent
echo "Building agent/opencode: ${AGENT_OPENCODE_COMMIT} and tagging as ${AGENT_OPENCODE_LATEST}"
docker build --build-arg CORE_IMAGE="${CORE_COMMIT}" -t "${AGENT_OPENCODE_COMMIT}" agents/opencode
docker tag "${AGENT_OPENCODE_COMMIT}" "${AGENT_OPENCODE_LATEST}"

# Build Claude Code Agent
echo "Building agent/claude-code: ${AGENT_CLAUDE_CODE_COMMIT} and tagging as ${AGENT_CLAUDE_CODE_LATEST}"
docker build --build-arg CORE_IMAGE="${CORE_COMMIT}" -t "${AGENT_CLAUDE_CODE_COMMIT}" agents/claude-code
docker tag "${AGENT_CLAUDE_CODE_COMMIT}" "${AGENT_CLAUDE_CODE_LATEST}"

echo "Built versions:"
echo "  core: ${CORE_COMMIT} (latest -> ${CORE_LATEST})"
echo "  agent/opencode: ${AGENT_OPENCODE_COMMIT} (latest -> ${AGENT_OPENCODE_LATEST})"
echo "  agent/claude-code: ${AGENT_CLAUDE_CODE_COMMIT} (latest -> ${AGENT_CLAUDE_CODE_LATEST})"
