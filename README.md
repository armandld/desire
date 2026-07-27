# desire

Software engineering prompts inspired by the asymmetric board game Root.

- **You merge, they don't.** Every rule that matters reduces to this: agents open pull requests,
  you merge them. Nothing else is consent.
- **Asynchronous feedback goes on the PR**, you don't need an interactive chat to get stuff done.
- **Synchronous feedback gets the bigger picture**, every interactive session starts with the plan
  in mind.
- **When the rules are wrong, they say so** — an issue here, or a pull request drafted at your
  ask, which is exactly how this file got written. You merge it: that is what keeps the prompts
  yours.

Three roles share this repo and take turns through the day, each with its own information and its
own move:

- 🐦 [Birdsong](BIRDSONG.md) plans, asynchronously, before the day starts
- 🌤️ [Daylight](DAYLIGHT.md) designs the work with you, in every interactive session you open
- 🌙 [Evening](EVENING.md) implements, overnight, what you approved

[AGENTS.md](AGENTS.md) is the operating base they all follow: config, the trust boundary, the two
layers of memory, what authorizes a change. It is deliberately short — under a hundred lines with
the phase files — because every line of it is loaded into every session.

## Set it up for yourself

### 1. A GitHub account for the agents

Make a second GitHub account and use it for the agents, rather than letting them act as you. It
costs nothing and buys three things: their commits and comments are visibly theirs, their
permissions are yours to bound, and *your* comments stay unforgeable — which is what the approval
rule rests on.

Give the agent account a token or SSH key of its own, and use that in whatever runs them.

### 2. Fork this repo — the prompts, public

Fork it, or copy the five markdown files into a repo of your own. Public is the point: these are
the rules the agents run on, so anyone can read them, and nothing secret ever lands here.

Then edit the `## Config` block in `AGENTS.md`:

```
- USER          = "<your GitHub login>"
- REPOS         = ["<owner>/<repo>", ...]   # where the work happens
- PROMPTS_REPO  = "<owner>/desire"          # this fork
- MEMORY_REPO   = "<owner>/memory"          # step 3
- APPROVE_EMOJI = "rocket"
```

### 3. A memory repo, private

Create an empty private repo — `memory` is a fine name. The agents keep three things there, one
lifetime each: a turn journal per cycle in `TURNS/<date>.md`, the live board in `README.md`, and
your standing orders in an append-only `DECREE.md`. Each turn lands as a pull request whose review
thread is how you answer them. Private matters: it quotes you verbatim and describes work in
progress.

### 4. Collaborator on both, and on the work repos

Add the agent account as a collaborator on this repo, the memory repo, and every repo in `REPOS`.
Write access is enough — nothing in these prompts needs admin, and the rules forbid the agents from
merging anything anyway: your merge is your consent.

Keep the default branch protected on all of them. The agents only ever push to their own branches.

### 5. Activate in Claude Code

`CLAUDE.md` here is four `@` includes — the operating base plus the three phase files — so a
session that has this repo loads all of them up front:

```shell
git clone https://github.com/<owner>/desire && cd desire && claude
```

For [Claude Code on the web](https://claude.ai/code) or a scheduled run, add this repo as a source
of the environment alongside your work repos; its `CLAUDE.md` is picked up the same way.

To check it actually loaded, `DAYLIGHT.md` sets a password: an interactive session includes it in
its first turn. No password means the prompt never reached the model — usually the environment is
not sourcing this repo at all. Change the password to whatever you like; it is a liveness check,
not a secret.

Schedule the other two roles as recurring jobs on the agent account — Birdsong before your day
starts, Evening overnight — each in a fresh non-interactive session that is told which role it is.

### 6. Activate in GPT Codex

Codex reads `AGENTS.md` from the repo root automatically (and `~/.codex/AGENTS.md` for a global
one), so the operating base needs no work. It has no `@` include mechanism, though: point the run
at the phase file for the role it plays, or concatenate `AGENTS.md` with one phase file into the
`AGENTS.md` of a Codex-specific fork.

The same goes for any other harness — the files are plain markdown with no tool-specific syntax
beyond `CLAUDE.md`'s includes.
