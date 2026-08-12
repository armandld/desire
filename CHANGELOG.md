# Changelog

What landed on `main`, newest first — when each rule started binding, and what it replaced.

## 2026-08-12

**VIGIL.md is rewritten from what actually worked**
([#23](https://github.com/armandld/desire/pull/23), closes
[#22](https://github.com/armandld/desire/issues/22)) — USER's own method, written from the V1
audit rather than from first principles. It replaces yesterday's version entirely, and is better
in the way that matters: it carries the numbers. Twelve of twenty-three defects came from one
question, so that question is marked as the place to start; the majority of the code was right,
so an agent reporting a defect per function is told it is wrong. Eight defect shapes each pair a
real example with the test that separates it.

The one thing yesterday's version had and this one lacked was where the output goes — which is
what blocked the first run. `## Protocole de sortie` now says it: Vigil branches off the live
branch and targets it, never the stale default, never a branch it did not open, and never merges
its own proposal.

`## Périmètre` gains its mirror: read `docs/DEFAUTS.md` and the audited repo's open PR thread
before each pass. The register says what is corrected, frozen, or open; the thread says where
USER wants to go. Without either, a pass re-finds corrected defects and walks into frozen paths.

Three rules arrive from runs that went wrong, and each names what it cost. A `pytest -k` whose
pattern matches nothing exits green — it happened in the very file meant to catch empty sweeps,
three commands out of twenty-two. A failing test can itself be wrong: one demanded a
finite-difference divergence of zero from a spectrally projected field, and would have failed a
perfect implementation. And a fix valid for one caller can be undefined for another — an
integrator correction, measured and right on the global path, broke AMR on non-periodic patches,
eight tests failing, six of them pre-existing. Hence: run the whole suite before announcing a
fix.

Defects and measurements now land in `docs/DEFAUTS.md` and `docs/RESULTS.md`, the repo having
split them; writing either into `PLAN_PREPRINT.md` is refused. This also repairs a link that had
already died — the earlier version pointed at `docs/RESULTS_V4.md`, which no longer exists.

## 2026-08-11

**🦉 Vigil joins, to audit the object of study**
([#20](https://github.com/armandld/desire/pull/20)) — USER's ruling: a fourth role that spends
the night auditing `BA_Proj:src/` by contract and proposes each finding as a PR. Its method is
not written here — `PLAN_PREPRINT.md` §7 already defines it, and VIGIL.md points at it rather
than forking a second version that would drift.

Two guardrails come from the audited repo's own rules, which the brief did not mention:
`src/` is the object of study, so changing it is a scientific claim and Vigil never merges its
own; and Appendix A constrains the order of the campaign, so a finding reached by skipping a
step is worth nothing. Both are stated in VIGIL.md because an agent told only to *resolve
defects* would break them by 4am.

Vigil shares the night with Evening and takes priority in WORK_REPOS — where it has an open PR,
Evening adds to it instead of opening its own, so the two never race on the same files. Its
standard is written as the model doing what its documentation says, not as a green suite: a
test that cannot fail is itself the finding.

**The session-start hook goes** ([#19](https://github.com/armandld/desire/pull/19)) — it existed
to install `gh` and `jq`, and nothing commited uses either: `check-approval.sh` is curl plus
python3, the bridge is an MCP dispatch plus urllib on the runner. `gh` had already lost its last
job when the bridge stopped being dispatched through it. `.claude/settings.json` goes with it,
holding nothing else. AGENTS.md keeps the *not `gh workflow run`* line — an agent can still reach
for it.

**Prune what the night left behind** ([#18](https://github.com/armandld/desire/pull/18)) —
`as-agent-arm.sh` deleted: a first attempt at AGENT identity, referenced by nothing, and its own
header prescribes the fine-grained PAT that [#10](https://github.com/armandld/desire/pull/10)
established cannot work. `## Posting as AGENT` loses a third of its lines to redundancy, the
forensics staying here where they belong. Two claims corrected rather than trimmed: *a routine's
`allowed_tools` leaves nothing that can dispatch* is falsified — both routines dispatched with
that exact list; and *no GitHub MCP tool returns reaction data* was imprecise — MCP returns
counts, never who reacted, which is why the script stays the sanctioned path.

**Commit attribution moves to `--author`, and out of `git config`**
([#17](https://github.com/armandld/desire/pull/17), closes
[#14](https://github.com/armandld/desire/issues/14)) — the session-start hook set
`user.name`/`user.email` globally and lost: the platform's own SessionStart hook re-asserts
`Claude <noreply@anthropic.com>` and runs last, so three routine runs each started as `Claude`
and had to run the hook by hand. Winning was the wrong goal anyway — measured on this repo's
commits, an AGENT committer verifies as `unknown_key`, because the signing key belongs to
`noreply@anthropic.com`. Passing `--author` per commit takes attribution from the author and
leaves the signature to the committer, so both hold. Replaces the hook's identity block, and
the *already set to AGENT by the session-start hook* claim that was never true.

Birdsong and Evening had diagnosed this as a persistent session whose SessionStart fires once,
citing the routine prompt's own wording. That wording is a leftover of the API-created routines;
an ordinary fresh session reproduced the same symptom, which rules the explanation out.

**Reviews start from the newest branch, not the default one**
([#13](https://github.com/armandld/desire/pull/13)) — USER's ruling, minutes before the first
Birdsong run. Routines clone each repo at its default branch, and nothing here said to look
further, so a review would have read `armandld/BA_Proj@main` — last touched 11 June except for
the bridge — while the actual work sat on `claude/kind-babbage-927g10`, pushed that morning and
carrying a falsified published result. `## Reviewing WORK_REPOS` now opens with the fetch-and-
sort-by-recency step. Sharpens *latest pushes first*, which said recency without saying it meant
branches.

**WORK_REPOS narrows to BA_Proj alone** ([#12](https://github.com/armandld/desire/pull/12)) —
USER's ruling before the first Birdsong run. `rel-int/wiki-content` and `rel-int/optyx` leave
WORK_REPOS and FOCUS; the optyx paragraph goes with them, since it only existed to explain a
no-FOCUS entry that no longer exists. The routines still clone six repos, so a sentence now says
what cloning does and doesn't make a repo: only the Config list is WORK_REPOS, the rest of the
checkout is readable but never reviewed. Replaces the three-repo list from 2026-07-29 and the
FOCUS pair from the same day.

**The bridge is dispatched by MCP tool, not `gh`** ([#11](https://github.com/armandld/desire/pull/11)) —
`gh workflow run` 403s from inside a session: it authenticates through the proxy's injected
credential, which carries no Actions write permission. `mcp__github__actions_run_trigger` does
work. Caught by testing the exact command the rule below told the agents to run, before the
routines ran it themselves — both were configured with an `allowed_tools` list that omitted the
MCP tools, so neither could have dispatched at all. Replaces the `gh workflow run` invocation
that landed with the bridge earlier the same night.

**The bridge's token must be a classic PAT** ([#10](https://github.com/armandld/desire/pull/10)) —
the bridge landed working on DESIRE_REPO the same night, after four failed dispatches. The last
one was the informative one: a fine-grained PAT cannot act on a repo where its owner is only a
collaborator, which is every repo AGENT works in. Noted in `## Posting as AGENT` with its
symptom, since the token's own settings page reports no repository access even when "All
repositories" is selected. Doesn't replace a rule — it closes a hole in the one below.

**AGENT posts through a GitHub Actions bridge, not directly**
([#7](https://github.com/armandld/desire/pull/7)) — USER's live request, after testing showed
Claude Code Remote's GitHub proxy substitutes USER's own credentials on every outbound GitHub
API call from inside a session, regardless of what token a script supplies. The same AGENT PAT
resolved to AGENT from a local terminal but to USER from three separate cloud environments.
`## Posting as AGENT` now directs any GitHub write that must appear as AGENT through
`agent-arm-github.yml`, which runs outside the sandbox with a repo-scoped secret. Doesn't
replace anything — first rule on this. Git commit authorship was already fixed separately (the
session-start hook), since it's local metadata, not an API call, and isn't touched by the proxy.

## 2026-08-06

**One memory PR open at a time, not a stack** ([#43](https://github.com/toumix/desire/pull/43)) —
USER's ruling on six memory PRs ([memory#42](https://github.com/toumix/memory/pull/42),
[#43](https://github.com/toumix/memory/pull/43), [#47](https://github.com/toumix/memory/pull/47),
[#48](https://github.com/toumix/memory/pull/48), [#49](https://github.com/toumix/memory/pull/49),
[#50](https://github.com/toumix/memory/pull/50)) piling up faster than one human reviews them.
*Stacked on the previous open PR* required every turn to correctly find and target that one PR; four
of five turns didn't, branching off `main` instead, and even a correct stack is still N PRs to open,
review in order and merge. Replaces the stacking clause from the 2026-08-04 entry below: now, if a
memory PR is open, push to it; only open a new one when none is open.

## 2026-08-04

**Memory is reserved for cross-workstream changes** ([#39](https://github.com/toumix/desire/pull/39)) — USER's ruling closing
[memory#45](https://github.com/toumix/memory/pull/45), *only open memory PRs when the changes
affect other PRs*, corrected in-session the same day: *single-workstream turns just record their
memory in their dedicated PRs, no need for memory*. A turn that stays within one workstream
writes nothing to MEMORY_REPO — its work PR is its record; only changes affecting other PRs land
in memory, by the stacked `<Routine> <date>` PR, whose review remains the feedback channel. The
board is rewritten by the turns that do land there. Replaces the unconditional stacked-PR rule;
supersedes the stacking half of [#30](https://github.com/toumix/desire/issues/30)'s question — a
chain of single-workstream turns no longer produces PRs, or memory, at all.

## 2026-07-29

**bob binds to issues, not only to reviews** ([#27](https://github.com/toumix/desire/pull/27)) —
`## Reviewing` becomes `## Issues and reviews`, and *write every comment like bob* becomes *write
like bob everywhere*. The rule is unchanged since [#3](https://github.com/toumix/desire/pull/3);
what changed is that a section called Reviewing is not one an agent filing a Turmoil issue thinks
it is in, so [#21](https://github.com/toumix/desire/issues/21) is three hundred words under the
rule and outside it. Two lines proposed here did not survive USER's review — a `## Writing` section
of its own, and a sentence defining what an issue is.

**`rel-int/wiki` joins WORK_REPOS** — the routines now scan two repos, not one. Nothing else
changes: `WORK_REPOS` was already plural everywhere it is read, and the wiki carries its own
`CLAUDE.md`, which `## Prompts public, memory private` already binds the agents to.

**Evening scans mentions instead of reading an inbox** ([#22](https://github.com/toumix/desire/pull/22),
closes [#20](https://github.com/toumix/desire/issues/20)). Notifications are a *user* scope and an
app installation has none, so every call 403s while `mentions:AGENT` reaches even repos outside the
session's scope. 👀 marks only a mention queued as a `TODO.md` box — an answer is its own mark, and
🚀 stays USER's.

## 2026-07-28

**Branch names carry nothing** ([#19](https://github.com/toumix/desire/pull/19)) — *use the branch
you were assigned or open a new one*, on its own line, with the pull-request paragraph restored
byte-for-byte. Rules [#13](https://github.com/toumix/desire/issues/13) the opposite way to
[#15](https://github.com/toumix/desire/pull/15)'s `<routine>/<YY-MM-DD>`, so the harness injecting
`claude/` is no longer a contradiction every scheduled run has to notice. Reverts
[#17](https://github.com/toumix/desire/pull/17), which merged and was undone the same night; its
`EVENING.md` bullet survived, the `AGENTS.md` reword did not.

**Birdsong scans WORK_REPOS** ([#14](https://github.com/toumix/desire/pull/14)) — `REPOS` and
`PROMPTS_REPO` renamed to `WORK_REPOS` / `DESIRE_REPO`, and the scan comes home
([#6](https://github.com/toumix/desire/issues/6)): a delegate may widen the search, never narrow the
truth. Evening keeps its coding sub-agents, whose diffs CI checks.

**`AGENTS.md` cut back, and `DECREE.md` retired** (`eade164`, `b622cd4`) — USER's hand rewrite, 80
lines to 55. `## Approval`, `## Hard rules` and `## Rulings` are gone: the emoji rule now sits in
`## Trusted instructions, untrusted data`, one-proposal-per-comment in `## Reviewing`. That section
also gains the emoji react as a source of trust, and the rule against replying to other users. A
private append-only decree file was a queue only the routines could read; standing orders are open
issues here now.

**Readiness counts threads** ([#9](https://github.com/toumix/desire/pull/9),
[#5](https://github.com/toumix/desire/issues/5)) — `TODO.md` `[x]` plus CI green is how a PR sat in
the ready column carrying an unanswered review of USER's. Made a four-way conjunction: **a thread
waiting on USER is the sign-off, only one waiting on an agent blocks.** Did not survive the rewrite
above, which landed hours later — which is why #5 is open.

## 2026-07-27

**Reviewing, and Turmoil** ([#3](https://github.com/toumix/desire/pull/3)) — `## Meta-rule` becomes
`## Turmoil`, the Eyrie's, applied to the rules themselves. Reviewing is proposing; one comment
carries one proposal, since a reaction lands on a whole comment; answer the thread, then resolve it;
write like [bob](.agents/skills/bob/SKILL.md). Same PR: `DAYLIGHT.md` opens with the password
instead of closing on it, because sessions were reproducing it on request and skipping it otherwise
— the exact failure the check exists to catch.

**The prompts get their own repo** ([#1](https://github.com/toumix/desire/pull/1)) — out of
`toumix.github.io`, where `.agents/` only existed to keep them out of a Jekyll build. Five files
flat at the top level, plus the bob skill and the session-start hook.
