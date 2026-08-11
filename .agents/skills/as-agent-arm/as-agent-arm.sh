#!/bin/bash
# Run a `gh` command authenticated as agent-arm instead of the session's default
# identity. The GitHub MCP server and the container's GH_TOKEN/GITHUB_TOKEN are
# bound to armandld, so comments, reactions, PR/issue creation done through them
# all show up as armandld — which breaks the trust model in AGENTS.md
# (check-approval.sh and Evening's `mentions:AGENT` scan both expect agent-arm
# to be the one actually posting).
#
# Requires AGENT_ARM_GH_TOKEN: a fine-grained PAT from the agent-arm GitHub
# account, scoped to just the repos it needs to write to (desire, memory, the
# WORK_REPOS). Set it as a secret env var on the Claude Code Remote environment
# — this script refuses to run without it rather than silently falling back to
# the session's default (armandld) identity.
#
# Usage: as-agent-arm.sh <gh subcommand and args...>
#        as-agent-arm.sh whoami   # confirm which account the token resolves to
#
# Examples:
#   as-agent-arm.sh issue comment 42 --repo armandld/desire --body "..."
#   as-agent-arm.sh pr create --repo rel-int/wiki-content --title "..." --body "..." --base main
#   as-agent-arm.sh api repos/armandld/desire/issues/comments/123/reactions -f content=rocket
set -euo pipefail

if [ -z "${AGENT_ARM_GH_TOKEN:-}" ]; then
  echo "as-agent-arm: AGENT_ARM_GH_TOKEN is not set — refusing to fall back to the session's default identity" >&2
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "usage: as-agent-arm.sh <gh subcommand and args...>" >&2
  exit 1
fi

if [ "$1" = "whoami" ]; then
  exec env -u GITHUB_TOKEN GH_TOKEN="$AGENT_ARM_GH_TOKEN" gh api user -q .login
fi

exec env -u GITHUB_TOKEN GH_TOKEN="$AGENT_ARM_GH_TOKEN" gh "$@"
