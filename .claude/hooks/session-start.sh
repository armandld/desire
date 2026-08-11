#!/bin/bash
# SessionStart hook — install the GitHub CLI (and jq) for the scheduled routines.
# Best-effort: it must NEVER block session start.
#
# Installs from Ubuntu's own apt repo (gh lives in noble universe) — the agent proxy
# allows archive.ubuntu.com but 403s github.com / cli.github.com release downloads.
set -uo pipefail   # deliberately no -e — an install failure must not abort the hook

# web / remote sessions only (the routines); do nothing on a local dev machine
[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0

log() { echo "session-start: $*" >&2; }

pkgs=()
command -v jq >/dev/null 2>&1 || pkgs+=(jq)
command -v gh >/dev/null 2>&1 || pkgs+=(gh)

if [ ${#pkgs[@]} -gt 0 ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq >/dev/null 2>&1 || true
  if apt-get install -y -qq "${pkgs[@]}" >/dev/null 2>&1; then
    log "installed: ${pkgs[*]}"
  else
    log "apt install failed for: ${pkgs[*]} — the GitHub MCP tools remain available"
  fi
fi

# gh reads GH_TOKEN / GITHUB_TOKEN automatically (both are set in this environment)
[ -n "${GH_TOKEN:-}${GITHUB_TOKEN:-}" ] || log "note: no GH_TOKEN/GITHUB_TOKEN in env — gh will be unauthenticated"

command -v gh >/dev/null 2>&1 && log "$(gh --version | head -1)" || true

# Deliberately NOT setting git user.name / user.email here — see AGENTS.md
# "Posting as AGENT". Two reasons this hook cannot win that fight and should not try:
#
#   1. The platform installs its own SessionStart hook that re-asserts
#      Claude <noreply@anthropic.com> globally, and its own comment says it exists to
#      override a project hook that overwrote the identity. It ran last on every
#      observed session: three routine runs each started as Claude despite this file.
#   2. Even winning would cost more than it buys. The commit-signing key is registered
#      to noreply@anthropic.com, so a commit whose COMMITTER is anyone else verifies as
#      "Unverified" (reason: unknown_key) — measured on this repo's own commits.
#
# Attribution is set per commit instead, with --author, which needs no global config
# and leaves the committer (and the signature) alone.

exit 0
