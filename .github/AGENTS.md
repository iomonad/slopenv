# AGENTS.md (GitHub Actions)

Read this before touching anything under `.github/`. CI runs with write tokens, secrets and a shell, so it is the one place where a careless edit can hurt more than a broken build. Assume every input that is not ours is hostile, and every `uses:` line is a dependency you did not review.

## Scope

- `.github/workflows/*`, composite actions, and any script a workflow runs (today: `build.sh`).
- The single build entry point is `build.sh`. CI calls it; humans call it. Do not fork the build logic into YAML.

## Permissions

- Top-level `permissions: {}`. Grant per job, and only what the job needs.
- `contents: read` is the default. Anything broader needs a reason written in the workflow next to it.
- Never `write-all`, never omit `permissions` and hope for the best (the repo default may be permissive).

## Action pinning

- Pin every `uses:` to a full 40-character commit SHA, with the release in a trailing comment: `uses: actions/checkout@<sha> # v7.0.1`.
- Never pin to `@main`, `@master`, or a bare tag you did not verify. Tags move; SHAs don't.
- Resolve SHAs from the upstream repo (`git/ref/tags/<tag>` or the release page), never from memory.
- Bumps go through Dependabot or Renovate, not hand edits at 2 a.m.

## Untrusted input

- Never interpolate `${{ github.event.* }}` into `run:`. Titles, bodies, branch names and fork PR heads are attacker-controlled. Pass them through `env:` and quote the shell variable.
- Never use `pull_request_target` with a checkout of PR head code. It runs with base-repo secrets against code you have not read. If you think you need it, you need a second workflow and a human.
- `workflow_run` chains are guilty until proven innocent. Keep them rare and never feed them artifacts you have not validated.

## Secrets and credentials

- Secrets are not available to fork PRs. Do not work around that; that is the point.
- Prefer OIDC over long-lived tokens for any cloud access.
- `persist-credentials: false` on `actions/checkout`, unless a later step must `git push`. Then scope the token and say why.
- Never echo secrets, never put them in a job `env:` when a single step will do, never print `env` in a debugging step and forget to remove it.

## Runners, time and concurrency

- `timeout-minutes` on every job. A hung job is a leak with a timer.
- `runs-on:` a specific image (`ubuntu-24.04`), not `ubuntu-latest`, when reproducibility matters. Bump it on purpose.
- `concurrency` with `cancel-in-progress` on pull requests, so superseded runs stop burning minutes.

## Supply chain

- Pin base images and tools by digest where the build allows it. The core image already is (`alpine@sha256:...`); keep it that way.
- Known tradeoff, not an endorsement: the agent Dockerfiles run `curl | bash` against vendor installers. Prefer checksum-verified downloads whenever a vendor publishes checksums. Note any new `curl | bash` in the PR description.
- `actions/dependency-review-action` on pull requests once the repo has dependencies worth reviewing.

## Triggers

- Keep `push` and `pull_request` as the default triggers. Add others only with a reason in the file.
- Do not trigger on `pull_request_target` to make a status check appear. See above.

## Verification

- Run `actionlint` on every workflow change, locally or in CI, before merge.
- Re-read your diff for: `${{ github.event.* }}` inside `run:`, `pull_request_target`, `write` permissions, unpinned `uses:`, missing `timeout-minutes`.
- A workflow change is not verified until it has run green on GitHub. Local `./build.sh` is a sanity check, not CI.

## Review checklist

- [ ] `permissions` set at top level, minimal per job
- [ ] Every `uses:` pinned to a SHA with a version comment
- [ ] No untrusted event data in `run:`
- [ ] No `pull_request_target`
- [ ] `persist-credentials: false` on checkout (or a written reason)
- [ ] `timeout-minutes` and `concurrency` present
- [ ] `actionlint` clean
- [ ] Ran green on GitHub, not just on a laptop

## Follow-ups (not done yet)

- Dependabot config for `github-actions` ecosystem, so SHA pins do not rot.
- Dependency review action once the project has real dependencies.
