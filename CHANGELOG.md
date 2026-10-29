# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Added
- `.github/workflows/release.yml` publishes the images to `ghcr.io` (a tag now pushes the core and agent images under that tag and `latest`, finally giving `bin/slopenv -u` something to pull. The images travel from the build job to a `publish` job through an artifact, and that job holds the only `packages: write` in the file and runs no repository code. The release waits for the push, so no release points at air. Packages still start private and must be made public by hand, because GitHub enjoys making you click things)

### Changed
- `AGENTS.md` (commits and pull requests now ship without AI attribution: no `Co-Authored-By` trailers and no "Generated with" footers. The author takes the blame, and the robot gets no credit, which is the first fair deal this repo has offered it)

## 0.1.3 - 2026-10-26

### Added
- `bin/slopenv -u` (pulls the agent image before starting it, because local images age in silence like milk. Successful pulls are stamped in `~/.slopenv/last-update`. Without `-u`, an image older than five days, or never pulled, gets a reminder: a yes/no prompt in a terminal, a warning otherwise. Declining or a failed pull never blocks the launch. The pull will fail until someone actually publishes the images, which is a separate and suspiciously avoided task)

## 0.1.2 - 2026-10-25

### Added
- `bin/slopenv -v` (prints the version, so you can finally tell which slopenv you are running instead of guessing from the timestamp. A release build reports its tag. A checkout reports its commit hash. A copy that wandered off into `~/.local/bin` reports `unknown`, which is honest, at least)
- `.github/workflows/release.yml` (runs only when a tag is pushed. It builds the images tagged with that tag name, and cuts a GitHub release with the versioned `slopenv` script attached. The images are built and then left to rot on the runner, because nothing pulls them yet. Only the write token goes to the job that creates the release, which is the only job that has earned one)
- `.gitignore` (ignores `dist/`, where the versioned script lives. Build output does not belong in git, no matter how proud it makes you)
- `bin/slopenv` (checks that the docker daemon is actually alive before trying to cage anything, and offers to start it through systemd or openrc with sudo/doas if you forgot. Again. It asks first, since silently borrowing root is exactly the kind of initiative nobody wants from a tool that babysits AI agents. No terminal, no prompt, just the command you should have run. A missing docker group gets you a pointed error instead of a root password prompt)
- `.github/workflows/ci.yml` (a GitHub Actions workflow that runs `./build.sh` on every push and pull request, so we can confirm the images still build before anyone trusts them with a shell. It builds. It does not test whether the agents do anything useful, which is a separate and far more depressing exercise)
- `.github/workflows/zizmor.yml` (runs zizmor, the workflow linter that judges our YAML so we don't have to, on changes to `.github/**` and every Monday. Pinned to zizmor 1.30.1 because the 1.31 release is less than two weeks old and we don't trust anything that new, even our own linter)
- `.github/AGENTS.md` (the rules for touching CI: least-privilege permissions, SHA-pinned actions, no untrusted event data in `run:`, no `pull_request_target`, and a checklist for anyone who thinks a workflow is "just a small YAML tweak". CI runs with write tokens and secrets, so it deserves more paranoia than your laptop)
- `base/Dockerfile` (adds `github-cli`, so agents can now poke GitHub with `gh` from inside the cage. It is not logged in, because the launcher does not forward tokens or mount `~/.config/gh` (yet). Run `gh auth login` yourself, with persistence on, and hope it sticks. Do not hand an AI agent a token with more scopes than you would give a stranger)

### Changed
- `build.sh` (tags images with `SLOPENV_VERSION` when it is set, and with the commit hash when it is not, so local builds behave exactly as before. It also writes `dist/slopenv` with the version baked in, and refuses version strings with characters that would make `sed` cry. The image names are the same, only the tag is more honest)
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
