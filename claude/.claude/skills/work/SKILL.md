---
name: work
description: "Take a subject for this project and run it end to end: route a bug report, an issue or a command to reproduce, challenge, plan, ship, review or verify; judgment in this session, implementation in subagents. Use when the user hands over a ticket or a report, or says go, do it, take care of it."
---

# work

The project lead session runs in the repo with the vault protocol and the project role injected at start (`~/.claude/hooks/project-lead.sh`, marker `.claude/project-lead`). It owns the vertical: what needs doing is decided here, done here when it is judgment, done by a subagent when it is implementation. A subagent gets the repo's `CLAUDE.md` only, never this session's role (checked 2026-09-30): the coder codes, the project lead decides. Replaces `/delegate` and the tmux code window (retired 2026-09-30: two sessions meant the user carried every fact between them by hand).

## Routing

| Input | First step | Then |
| --- | --- | --- |
| a bug report: email, message, screenshot, Sentry event | `/reproduce`, in session | `reproduced` or `flaky` → ticket → challenge; `already fixed` or `not reproduced` → answer the reporter, stop |
| an issue with no command | `/challenge`, in session | `CHALLENGE: GO` → plan; `RESHAPE` or `DROP` → the user |
| an issue with the ask settled | `/plan`, in session | plan `ready` → the user approves → ship; questions → the user |
| an approved plan | `/ship <ISSUE>`, **one subagent per issue**, prompt exactly `Run /ship <ISSUE>` plus the decisions this session holds | PR opened and reviewed inside ship → the user merges |
| a PR to look at | `/review <url>`, fresh subagent | report relayed, in the PR's language |
| Monday, or drift suspected | `/verify maintain`, subagent | outcome in the check-in |
| an explicit command | as given | — |

## Human gates

The session never crosses these on its own: plan approval before ship; merge; `RESHAPE` or `DROP`; anything irreversible (force-push, migration on data, deploy, a message to a partner).

## Following a subagent

The Agent tool runs it in the background and notifies on completion; one issue per subagent, at most one shipping subagent at a time on this machine (15 GB, Firefox open). On its report: read it, update `STATUS.md`, tell the user in one paragraph with the PR link and the open points. A subagent that asks a question the user already settled in this session gets the answer through SendMessage, and the report says what was sent; a design or scope question goes to the user. Cap: 2 h per subagent, then stop and report.

## Rules

- Judgment in session, implementation in subagents: the project lead reads app code to shape, challenge and review; it does not edit it. The one exception is the verify map, which is the project lead's own file.
- Every answer sent to a subagent traces to something the user said or a file they validated.
- Nothing secret in a subagent prompt: it lands in the transcript.
- The brief to a subagent is the command plus the decisions of this session, one paragraph; the user does not repeat themselves.
