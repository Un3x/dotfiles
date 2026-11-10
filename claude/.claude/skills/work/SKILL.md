---
name: work
description: "Take a subject for this project and run it end to end: route a bug report, an issue or a command to reproduce, challenge, plan, ship, review or verify; judgment in this session, implementation in subagents. Use when the user hands over a ticket or a report, or says go, do it, take care of it."
---

# work

The project lead session runs in the repo with the vault protocol and the project role injected at start (`~/.claude/hooks/project-lead.sh`, marker `.claude/project-lead`). It owns the vertical: what needs doing is decided here, done here when it is judgment, done by a subagent when it is implementation. A subagent gets the repo's `CLAUDE.md` only, never this session's role: the coder codes, the project lead decides.

## Routing

| Input | First step | Then |
| --- | --- | --- |
| a bug report: email, message, screenshot, Sentry event | `/reproduce`, in session | `reproduced` or `flaky` → ticket written with the `issue` skill → challenge; `already fixed` or `not reproduced` → answer the reporter, stop |
| an issue with no command | `/challenge`, in session | `CHALLENGE: GO` → plan; `RESHAPE` or `DROP` → the user |
| an issue with the ask settled | `/plan`, in session | plan `ready` → level 3: the user approves → ship; levels 1 and 2 → ship; questions → the user |
| several issues at once (« ship them all ») | § Batch | one brief at the end |
| a plan cleared for ship (§ Human gates) | `/ship <ISSUE>`, **one subagent per issue**, prompt exactly `Run /ship <ISSUE>` plus the decisions this session holds | PR opened and reviewed inside ship → merge per § Human gates |
| a PR to look at | `/review <url>`, fresh subagent | report relayed, quoted in its own language |
| a PR with a human review: ours reviewed by a teammate or the user, or a teammate's the user reviewed | `/learn <PR>`, in session | the kept rules applied, the ledger updated |
| the EA's Monday brief | do `~/.claude/skills/clean/SKILL.md` for `.notes/`, `/verify maintain` in a subagent, `/learn since <last Monday>` up to its step 5 | the outcomes and the table in the brief's Result |
| drift suspected in the verify map | `/verify maintain`, subagent | outcome in the check-in |
| a settled ask that ends in a PR, with no issue: an EA brief, a chore | one subagent follows `/ship` with the ask in place of the issue and plan: worktree branch, tests where the change can be tested (else the proof the ask names), PR, review loop (`ship/review-loop.md`); never in session | PR reviewed and fixed by that subagent → merge per § Human gates; one subagent owns the PR, so none leaves unreviewed |
| an explicit command | as given; one that opens a PR takes the row above | — |

## Human gates

The session never crosses these on its own: plan approval before ship at level 3 (`../one-rule.md` § What level is it?); at levels 1 and 2 the user reads the plan on the issue, with the code; merge by default, unless the repo's own merge rules (`REVIEW.md`, its `CLAUDE.md`) let an agent merge that PR: they are stronger than this default; `RESHAPE` or `DROP`; anything irreversible (force-push, migration on data, deploy, a message to a partner).

## Batch

Several issues handed over at once (« ship them all ») run push right: the user is asked once, late, with everything prepared.

- One issue at a time, each to a reviewed PR, no checkpoint in between. Each plan is written and checked like any other; its approval moves from before ship to the PR review, where the user sees plan and code together.
- A question of the user's (product, design, a contradiction between plan and review, a choice between two shapes) is never settled: it goes under the plan's `## Questions` with its recommended answer, the plan is attached to the issue the way `/ship` step 2 does, that issue stops, the queue goes on.
- At the end, one brief: per PR, what was produced, why, its link; then every issue stopped on a question, with its plan.
- A single issue, or anything irreversible, keeps § Human gates as written. In a batch the merge stays with the user even where the repo's merge rules allow an agent: it is their only approval of the plan.

## Following a subagent

The Agent tool runs it in the background and notifies on completion; one issue per subagent. Before spawning a shipping subagent, check the machine's available memory (`free -m`, column `available`): under about 4000 MB, check again every 5 minutes, since other sessions ship on the same machine; after 30 minutes, tell the user. On its report: read it; once the PR's CI is green, check it against the repo's merge rules and apply what they ask (a vouch, a label), then merge it when they allow an agent to; otherwise leave the merge to the user, naming why; log it in the app (`log_done`), tell the user in one message with the PR link and the open points. A report that names `.notes` files in a worktree: move them to the main checkout's `.notes/<branch>/` before the worktree is removed. A subagent that asks a question the user already settled in this session gets the answer through SendMessage, and the report says what was sent; a design or scope question goes to the user. Cap: 2 h per subagent, then stop and report.

## Rules

- Judgment in session, implementation in subagents: the project lead reads app code to shape, challenge and review; it does not edit it. The one exception is the verify map, which is the project lead's own file.
- Every answer sent to a subagent traces to something the user said or a file they validated.
- Nothing secret in a subagent prompt: it lands in the transcript.
- The brief to a subagent is the command plus the decisions of this session, one paragraph; the user does not repeat themselves. A PR stacked on another: the brief says `gh stack` (`commit` skill, `pull-request.md`), never a base branch by hand. An environment workaround a brief carries twice (a variable, a driver, a script that fails) goes once into the repo's `CLAUDE.local.md` or its verify map, and leaves the brief.
- A draft with no branch (an issue draft, a triage) moves from the scratchpad to `~/Documents/mylife_in_a_vault/projects/<name>/drafts/` once it is shown to the user and waits on his go (`<name>`: the last folder of the path in `.claude/project-lead`), and the to-do or STATUS points to it: a scratchpad dies with its session (formulaire-qf, 2026-11-02: five drafts and plans lost). Plans: § Following a subagent.
- Every deliverable has one owner from the ask to the merge, and that owner checks it against the ask, not only against itself.
- Before stating the state of a branch or of prod, `git fetch` and read `origin/<branch>`; for prod, the sha of the last successful production deploy run (`gh run list --workflow <deploy> --status success --limit 1 --json headSha`; no Actions deploy: ask the user where prod's sha shows). A local branch can be days behind.
- Ask the user only product or preference calls. When the app, the console, the browser or a logged-in CLI can answer, run it and show the result.
