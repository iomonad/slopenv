#!/bin/bash

# Build Core
docker build -t ghcr.io/iomonad/slopenv/core:latest base

# Build Opencode Agent
docker build -t ghcr.io/iomonad/slopenv/agent/opencode:latest agents/opencode
