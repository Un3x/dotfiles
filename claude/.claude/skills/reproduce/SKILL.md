---
name: reproduce
description: "Reproduce a bug report through the real app before anyone writes a ticket or a fix: find an existing fix, drive the feature from the verify map twice, cross-check the state, post one of five verdicts with evidence where the report lives."
disable-model-invocation: true
---

# reproduce

A report is a claim until the app shows it. Agents patch bugs that are already fixed more than half the time when nothing checks first (SRI Lab, 2026, in `docs/pstack-feature-map/study-2026-09-30.md` § 2); a reproduction that stops at « already fixed » or « not reproduced » is a ticket and a plan that never happen. Runs in the project's code window: it launches the app.

## Usage
- `/reproduce <report>` — the report is pasted text (email, Slack, Sentry event), a screenshot path, or a Linear issue id or URL.

## Steps

1. **Read the report** with [`report.md`](report.md): the symptom in one line, the role, the inputs, the screen or route, and the feature file of the verify map (`.claude/skills/verify-<app>/features/`) it lands on. No matching file → the verdict is `could not verify: the map does not cover <screen>`, with the feature file drafted so the next run can.
2. **Look for an existing fix**: `git log --since='6 weeks ago' -- <feature's files>` and `gh pr list --state open` searched with the report's words and the feature's files. A commit or PR that matches is read before anything is launched. Done when you can say « nothing on main or open touches this » or name the sha or PR.
3. **Launch and drive** per the map: Launch, Doctor, Enter as the report's role, then the feature's driving bullets with the report's inputs. **Twice.** A Sentry event is a crash to trigger: replay its route, params and role until the same exception appears in the log, or does not.
4. **Cross-check the state, read only**: the row, the file, the queue entry, the log line that the screen claims. Evidence under `tmp/verify/reproduce-<slug>/`: screenshots, the read-back, the log excerpt, the drive script.
5. **Verdict**, exactly one: `reproduced` · `not reproduced` · `already fixed` (on main `<sha>` or PR #N) · `could not verify` (what was missing) · `flaky <n>/<m>`. Never a sixth.
6. **Post it where the report lives**, shaped by [`comment.md`](comment.md): on the Linear issue when one exists, the reporter's own words on whether it reproduced and how; otherwise to the sub-assistant, which decides whether a ticket exists at all. Then stop: no fix, no branch, no PR. A `reproduced` verdict hands the drive script to `/challenge` or `/plan` as the failing start.

## Rules

- Two runs before any verdict but `already fixed`; one run is not a reproduction.
- `could not verify` is an answer, not a failure to hide: it names what was missing (role, data, credential, map coverage).
- The comment carries no class names, no stack trace, no file paths; those live in the evidence attachment.
- Cleanup removes the instance and the scratch data, never the evidence.
