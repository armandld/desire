#!/bin/bash
# Check whether USER reacted to a comment with APPROVE_EMOJI.
#
# A proposal is one comment on the PR (or issue) conversation, which the REST
# API calls an ISSUE comment — /issues/comments/<id>/reactions. An inline
# review comment is a different resource — /pulls/comments/<id>/reactions.
# The two id spaces are disjoint, and nothing in the id says which one it is,
# so this asks both and answers from whichever one exists.
#
# Fails CLOSED but never silently: if neither endpoint returns a list (403,
# 404, rate limit), it prints the reason on stderr and exits 2 — "unknown" is
# not "not approved".
#
# Usage: check-approval.sh <owner/repo> <comment-id> [user] [emoji]
set -euo pipefail

repo="$1" id="$2" user="${3:-armandld}" emoji="${4:-rocket}"

fetch() {
  curl -sS -H "User-Agent: curl" -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/$repo/$1/comments/$id/reactions" || echo '"curl failed"'
}

ISSUES_JSON="$(fetch issues)" PULLS_JSON="$(fetch pulls)" \
APPROVER="$user" EMOJI="$emoji" python3 -c '
import json, os, sys

found, why = [], []
for name in ("ISSUES_JSON", "PULLS_JSON"):
    try:
        data = json.loads(os.environ[name])
    except ValueError:
        why.append(name + ": not JSON")
        continue
    if isinstance(data, list):
        found.append(data)
    elif isinstance(data, dict):
        why.append(name + ": " + str(data.get("message", data)))
    else:
        why.append(name + ": " + str(data))

if not found:
    print("unknown: " + "; ".join(why), file=sys.stderr)
    sys.exit(2)

approved = any(r["user"]["login"] == os.environ["APPROVER"]
               and r["content"] == os.environ["EMOJI"]
               for reactions in found for r in reactions)
print("approved" if approved else "not approved")
sys.exit(0 if approved else 1)
'
