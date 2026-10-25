# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Fixed
- `bin/slopenv` (claude-code persistence actually persists now: the image ships a real `~/.claude`, so `ln -snf` politely nested a dangling link inside it and credentials, sessions and history evaporated with `--rm`. Only `.claude.json` survived, like a cockroach)
- `bin/slopenv` (dropped the opencode `~/.opencode` symlink, which did nothing, and would have deleted the binary if it ever worked)
- `bin/slopenv` (generic agents no longer nest links inside directories baked into their image)
- `AGENTS.md` (mount path, flags and persistence description caught up with reality)

### Removed
- `README.md` (dropped the jwz link and the Dogfooding section)

### Added
- `-L` option in `bin/slopenv` to list active sessions (container name and uptime)
- Agent configuration persistence in `~/.slopenv/agents/<agent-name>/` mounted by default for all agents
- `-x` option to disable persistence in `bin/slopenv`
- `agents/claude-code/Dockerfile` (Claude Code agent image)
- Support for `claude-code` agent via `-a claude-code`
- `README.md` (added Available Agents table with opencode and claude-code details)
- `install.sh` to install `slopenv` to user bin path with PATH hint

### Changed
- `bin/slopenv` (containers are now named `slopenv-<agent>-<project>-<pid>`, added `--name`)
- `bin/slopenv` (added persistence support with `-x` to disable, updated usage; now documents `claude-code` as supported via usage)
- `bin/slopenv` (opencode now resumes last session via `-c` to avoid creating a new session)
- `bin/slopenv` (exit with list of available agents on unknown `-a` value)
- `bin/slopenv` (mount only project basename under /workspace for privacy)
- `build.sh` (builds `claude-code` agent, exits if docker is not installed)
- `README.md` (updated agent usage to reference Available Agents section, documents `claude-code` agent usage, build, and free tier information, added persistence section)
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
