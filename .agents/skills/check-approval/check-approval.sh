#!/bin/bash
# Check whether USER reacted to a PR review comment with APPROVE_EMOJI.
#
# No GitHub MCP tool returns reaction data, and a plain WebFetch against the
# REST API 403s (GitHub rejects requests with no User-Agent). This shells out
# to curl instead: reactions on public repos are unauthenticated GETs.
#
# Usage: check-approval.sh <owner/repo> <comment-id> [user] [emoji]
set -euo pipefail

repo="$1" id="$2" user="${3:-armandld}" emoji="${4:-rocket}"

curl -sS -H "User-Agent: curl" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$repo/pulls/comments/$id/reactions" \
  | python3 -c "
import json, sys
reactions = json.load(sys.stdin)
approved = any(r['user']['login'] == '$user' and r['content'] == '$emoji' for r in reactions)
print('approved' if approved else 'not approved')
sys.exit(0 if approved else 1)
"
