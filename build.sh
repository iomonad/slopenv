#!/bin/bash

set -eu

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not installed or not in PATH" >&2
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: not a git repository" >&2
  exit 1
fi

COMMIT="$(git rev-parse --short HEAD 2>/dev/null)"
if [ -z "${COMMIT}" ]; then
  echo "Error: unable to determine commit" >&2
  exit 1
fi

# A release tag in CI (SLOPENV_VERSION=<tag>), the commit hash otherwise
VERSION="${SLOPENV_VERSION:-${COMMIT}}"
case "${VERSION}" in
  ""|*[!A-Za-z0-9._-]*)
    echo "Error: invalid version '${VERSION}' (letters, digits, dot, underscore and dash only)" >&2
    exit 1
    ;;
esac

CORE_VERSION="ghcr.io/iomonad/slopenv/core:${VERSION}"
CORE_LATEST="ghcr.io/iomonad/slopenv/core:latest"

AGENT_OPENCODE_VERSION="ghcr.io/iomonad/slopenv/agent/opencode:${VERSION}"
AGENT_OPENCODE_LATEST="ghcr.io/iomonad/slopenv/agent/opencode:latest"

AGENT_CLAUDE_CODE_VERSION="ghcr.io/iomonad/slopenv/agent/claude-code:${VERSION}"
AGENT_CLAUDE_CODE_LATEST="ghcr.io/iomonad/slopenv/agent/claude-code:latest"

# Build Core
echo "Building core: ${CORE_VERSION} and tagging as ${CORE_LATEST}"
docker build -t "${CORE_VERSION}" base
docker tag "${CORE_VERSION}" "${CORE_LATEST}"

# Build Opencode Agent
echo "Building agent/opencode: ${AGENT_OPENCODE_VERSION} and tagging as ${AGENT_OPENCODE_LATEST}"
docker build --build-arg CORE_IMAGE="${CORE_VERSION}" -t "${AGENT_OPENCODE_VERSION}" agents/opencode
docker tag "${AGENT_OPENCODE_VERSION}" "${AGENT_OPENCODE_LATEST}"

# Build Claude Code Agent
echo "Building agent/claude-code: ${AGENT_CLAUDE_CODE_VERSION} and tagging as ${AGENT_CLAUDE_CODE_LATEST}"
docker build --build-arg CORE_IMAGE="${CORE_VERSION}" -t "${AGENT_CLAUDE_CODE_VERSION}" agents/claude-code
docker tag "${AGENT_CLAUDE_CODE_VERSION}" "${AGENT_CLAUDE_CODE_LATEST}"

# Launcher with the version baked in, the file a release ships
mkdir -p dist
sed "s/^SLOPENV_VERSION=\"\"\$/SLOPENV_VERSION=\"${VERSION}\"/" bin/slopenv > dist/slopenv
if ! grep -q "^SLOPENV_VERSION=\"${VERSION}\"\$" dist/slopenv; then
  echo "Error: version placeholder not found in bin/slopenv" >&2
  exit 1
fi
chmod +x dist/slopenv
echo "Built script: dist/slopenv (slopenv ${VERSION})"

echo "Built versions:"
echo "  core: ${CORE_VERSION} (latest -> ${CORE_LATEST})"
echo "  agent/opencode: ${AGENT_OPENCODE_VERSION} (latest -> ${AGENT_OPENCODE_LATEST})"
echo "  agent/claude-code: ${AGENT_CLAUDE_CODE_VERSION} (latest -> ${AGENT_CLAUDE_CODE_LATEST})"
