# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Added
- `bin/slopenv` (checks that the docker daemon is actually alive before trying to cage anything, and offers to start it through systemd or openrc with sudo/doas if you forgot. Again. It asks first, since silently borrowing root is exactly the kind of initiative nobody wants from a tool that babysits AI agents. No terminal, no prompt, just the command you should have run. A missing docker group gets you a pointed error instead of a root password prompt)
- `.github/workflows/ci.yml` (a GitHub Actions workflow that runs `./build.sh` on every push and pull request, so we can confirm the images still build before anyone trusts them with a shell. It builds. It does not test whether the agents do anything useful, which is a separate and far more depressing exercise)
- `.github/workflows/zizmor.yml` (runs zizmor, the workflow linter that judges our YAML so we don't have to, on changes to `.github/**` and every Monday. Pinned to zizmor 1.30.1 because the 1.31 release is less than two weeks old and we don't trust anything that new, even our own linter)
- `.github/AGENTS.md` (the rules for touching CI: least-privilege permissions, SHA-pinned actions, no untrusted event data in `run:`, no `pull_request_target`, and a checklist for anyone who thinks a workflow is "just a small YAML tweak". CI runs with write tokens and secrets, so it deserves more paranoia than your laptop)

### Changed
- `.github/workflows/ci.yml` (hardened to match `.github/AGENTS.md`: empty top-level permissions with `contents: read` per job, `actions/checkout` pinned to a full SHA and not persisting credentials, `ubuntu-24.04` instead of a moving target, a 30-minute timeout, and concurrency that cancels superseded pull request runs. Nobody asked for a 30-minute cap, but a hung CI job is just a very slow way to waste money)

### Fixed
- `bin/slopenv` (claude-code no longer asks whether you trust the folder every single time. It was started in `$HOME` with the project path as its *first prompt*, so it dutifully answered a path, refused to remember trust for a home directory, and threw every project into one shared history bucket. It now starts inside the project like a normal program)
- `agents/claude-code/Dockerfile` (dropped `CMD ["/workspace"]`, which was also being sent as a prompt. Rebuild the image)
- `AGENTS.md` (agents now must never commit on their own. Trust issues, but the healthy kind)

## 0.1.0 - 2026-10-25

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
