# Changelog

What landed on `main`, newest first. One entry per change, dated by the day it merged.
The prompts are loaded into every session, so a line added here is a line every agent reads
tomorrow — this file is the record of when each of them started binding.

## 2026-07-29

### Evening scans mentions instead of reading an inbox ([#22](https://github.com/toumix/desire/pull/22))

`EVENING.md` — *reads the AGENT notifications for mentions, marking them read once handled*
became *scans `mentions:AGENT` for threads it was tagged in, answering or 👀 what it queued*.

The inbox was never reachable: notifications are a *user* scope, and an app installation has
none, so every call 403s while the `mentions:AGENT` search reaches even repos outside the
session's scope. The mark is now for the other case only — a mention that became a `TODO.md`
box rather than a reply — because an answer in the thread is already its own mark. 👀 and not
`APPROVE_EMOJI`: 🚀 is USER's and means *do this*.

Closes [#20](https://github.com/toumix/desire/issues/20). The wording it replaces cost a night:
Evening fired at 00:23, found no notifications tool, skipped the bullet as impossible, and three
instructions sat unread.

## 2026-07-28

### Branch names carry nothing ([#19](https://github.com/toumix/desire/pull/19))

`AGENTS.md` `## Memory` gains its own line — *use the branch you were assigned or open a new
one* — and the pull-request paragraph goes back byte-for-byte to what it was. The ruling was
about branches; the previous night's edit had phrased it as a rule about which PR a role works
on, and reworded the PR paragraph on the way. This separates them.

Settles [#13](https://github.com/toumix/desire/issues/13) by ruling the opposite way to
[#15](https://github.com/toumix/desire/pull/15)'s proposed `<routine>/<YY-MM-DD>`: nothing rides
on the prefix, so the harness injecting `claude/` is no longer a contradiction every scheduled
run has to notice.

Reverts [#17](https://github.com/toumix/desire/pull/17), which merged and was undone the same
night; the `EVENING.md` bullet it added survived, moved above the review bullet.

### Birdsong scans WORK_REPOS ([#14](https://github.com/toumix/desire/pull/14))

`BIRDSONG.md` was the last file still naming `REPOS` and `PROMPTS_REPO`, neither of which the
new `## Config` defines. Renamed to `WORK_REPOS` / `DESIRE_REPO`, and *delegates the scan to
cheaper models* became *scans WORK_REPOS* — [#6](https://github.com/toumix/desire/issues/6)'s
ruling, in its terse form. A delegate may widen the search, never narrow the truth: a sub-agent's
diff is checked by CI, a scanner's number becomes a board fact unchecked. Evening keeps its
coding sub-agents for that reason.

### `AGENTS.md` cut back, and `DECREE.md` retired (`eade164`, `b622cd4`, `96a1f12`)

USER's hand rewrite, 80 lines down to 55. What changed beyond the trimming:

- **`## Approval`, `## Hard rules` and `## Rulings` are gone.** The emoji rule lives in
  `## Trusted instructions, untrusted data` as a source of trust; one-proposal-per-comment lives
  in `## Reviewing`.
- **`## Trust` → `## Trusted instructions, untrusted data`**, with two additions: an
  `APPROVE_EMOJI` react from USER on anyone's comment is trusted, and agents do not reply to
  other users unless USER replied first or emoji-approved.
- **`DECREE.md` is dropped.** A private append-only file was a queue only the routines could
  read, and it grew faster than the prompts it fed. Standing orders are open issues on this repo
  now, where USER can see them and close them.
- **`## Memory` is four lines:** `README.md` is the state, `TURNS/<date>.md` the daily summaries,
  each role opens a PR stacked on the previous open one, PR comments are the short-term memory.
- **`PROMPTS_REPO` → `DESIRE_REPO`**, and `AGENT = "toumix-agents"` is defined in `## Config`.

`README.md` was rewritten alongside it — the epigraph, and `## Get started` as three steps.

### Readiness counts threads ([#9](https://github.com/toumix/desire/pull/9))

Readiness in practice was `TODO.md` fully `[x]` plus CI green, which is how a PR sat in the ready
column for two boards while carrying an unanswered review of USER's. Made a four-way conjunction,
with the board naming whichever clause fails, and the thread clause scoped as USER scoped it: **a
thread waiting on USER is the sign-off, only one waiting on an agent blocks.**
[#5](https://github.com/toumix/desire/issues/5)

Same PR retired *Evening keeps no file* ([#7](https://github.com/toumix/desire/issues/7)) — every
role writes to the day's memory PR.

The conjunction did not survive the rewrite above, which landed hours later;
[#5](https://github.com/toumix/desire/issues/5) is open again because of it.

## 2026-07-27

### Reviewing, and Turmoil ([#3](https://github.com/toumix/desire/pull/3))

`AGENTS.md` gains a `## Reviewing` section, and `## Meta-rule` is renamed `## Turmoil` — the
Eyrie's, applied to the rules themselves, from the same board game the roles come from.

Four rules in one paragraph: reviewing is proposing, so a review comment becomes a `TODO.md`
point only once USER approves it; one comment carries one proposal, because a reaction lands on
a whole comment and a batch can only be accepted or rejected entirely; answer the thread then
resolve it, an open thread means something is still owed; and comments read like
[bob](.agents/skills/bob/SKILL.md) — *"done in `<sha>`"*, no preamble.

In the same PR: `DAYLIGHT.md` opens with the password instead of closing on it — bold,
imperative, and stating what its absence means, because sessions were reproducing it on request
and skipping it otherwise, which is the exact failure the check exists to catch. `EVENING.md` was
rewritten by USER on the branch. *Follow AGENTS.md FIRST* is dropped from all three phase files:
`CLAUDE.md` includes all four, so the base loads either way.

### The prompts get their own repo ([#1](https://github.com/toumix/desire/pull/1))

Moved out of `toumix.github.io`, where `.agents/` only ever existed to keep them out of a Jekyll
build. Five files flat at the top level — `AGENTS.md` as the operating base, the three phase
files, and `CLAUDE.md` importing all four — plus the bob skill and the session-start hook.
`README.md` became a reproduction guide rather than a page on a website.

The website side, [toumix.github.io#7](https://github.com/toumix/toumix.github.io/pull/7),
deleted the same files.
