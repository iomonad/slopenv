# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Added
- `agents/claude-code/Dockerfile` (Claude Code agent image)
- Support for `claude-code` agent via `-a claude-code`
- `README.md` (added Available Agents table with opencode and claude-code details)

### Changed
- `bin/slopenv` (now documents `claude-code` as supported via usage)
- `build.sh` (builds `claude-code` agent, exits if docker is not installed)
- `README.md` (updated agent usage to reference Available Agents section, documents `claude-code` agent usage, build, and free tier information)
- `AGENTS.md` (clarified commit convention format and added guidance to specify scope when possible)

## 19433c3 - feat[bin]: added slopenv binary
### Added
- `bin/slopenv` (new executable/entrypoint script for the `slopenv` binary)

### Changed
- `README.md`

## a6e4abc - chore[license]: updated
### Changed
- `LICENSE`

## 002b52c - chore[core]: updated build env
### Changed
- `README.md`
- `agents/opencode/Dockerfile`
- `base/Dockerfile`
- `build.sh`

## 88051b1 - Initial commit
### Added
- `README.md`
