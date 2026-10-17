---
name: review
description: "Paranoid code review of a branch, PR, or files. Use whenever the user asks to review a PR, a pull request URL, a branch, or files (\"can you review…\", \"est-ce qu'on peut review…\")."
---

Paranoid code review. It checks what was built against what was asked, checks the diff against the written rules, runs four passes (critical, informational, design, simplicity), and merges second opinions from Codex and the layered-rails reviewer. It is designed to catch bugs that pass CI but blow up in production.

## Usage
- `/review` - Review current branch changes against main
- `/review <PR-number>` or `/review <PR URL>` - Review a specific PR (also triggered by a plain request such as "peux-tu review https://github.com/org/repo/pull/504")
- `/review <file1> <file2> ...` - Review specific files

## Purpose

This is the **paranoid staff engineer brain**. Not a style review, not a linting pass. This catches structural bugs: race conditions, N+1 queries, trust boundary violations, silent failures, and logic errors.

## Steps

1. **Gather the diff**
   - No args: `git diff main...HEAD` (all changes on current branch)
   - PR number or URL: fetch PR diff via `gh pr diff <number-or-url>`; past a handful of commits read them in order (`gh pr view --json commits`, then `git show` each) and follow the review guide when the body links one, since the commits are the author's reading path; and the author via `gh pr view <number-or-url> --json author -q .author.login` — the report prints it, so whoever relays the findings knows whether the fix is ours to delegate or the author's
   - Specific files: `git diff main -- <files>`
2. **Asked versus built**: [`asked.md`](asked.md) — the ask as a checklist from the issue, then the diff marked against it. Done when every line carries delivered / missing / deviates and the extras are listed.
3. **Read the checklist**: `.claude/review-checklist.md` if the project has one (project-specific overrides), else [`checklist.md`](checklist.md).
4. **Launch the Codex second opinion (background)**. Start it before your own passes so it runs in parallel (review mode is read-only by design):
   - Branch: `codex exec review -c model_reasoning_effort=<rung> --base main > .notes/<branch>/codex-review.md 2>&1`
   - PR number or URL: `gh pr checkout <number-or-url>` first, then the same command
   - Specific files: `codex exec review -c model_reasoning_effort=<rung> --base main "Only review: <files>"`
   The rung: start at `medium`, one rung up per signal, capped at `xhigh`; anything irreversible is `xhigh` whatever the count. Signals: hand-written SQL or aggregates; an invariant several layers must agree on; concurrency, retries, idempotency; auth, permissions, money, personal data, proofs and attestations; migrations; a public contract (API, webhook, email); caches or derived state; a changed method with many callers. A single file, a rename or a config bump with no signal is `low`; a purely mechanical change skips Codex (`not run — mechanical`).
   Run it with `run_in_background`; collect the file after Pass 4. If `codex` is missing or fails (quota, login, "Review blocked … sandbox could not start"), say so under CODEX SECOND OPINION and continue — the second opinion is additive, never blocking. Never pass `--dangerously-bypass-approvals-and-sandbox` to get past a sandbox error: review mode then runs commands unsandboxed (it will happily run the test suite).
   **Rails app** (`rails` in the `Gemfile`): also spawn the layered-rails reviewer, a background subagent whose prompt is exactly `Read ~/.claude/skills/layered-rails/SKILL.md, then review <the same target> per its commands/review.md. Read-only. Each finding as a behaviour, its steps and its result.` Collect its report after Pass 4. If it fails or times out, write `not run — <reason>` under LAYERED RAILS and continue.
5. **Rules check**: list the written rules that govern this diff: the repo's `CLAUDE.md` files nearest each changed path, its `.claude/skills`, and the rows of the lessons ledger (`~/Documents/mylife_in_a_vault/systems/lessons.md`) whose Home column names one of those files or a skill (`plan/`, `ship/`, `review/`, `commit/`); no ledger on this machine: skip it and say so. Check the diff against each rule whose area it touches. A broken rule is a finding under RULES MISSED, the rule quoted with the file it lives in; a rule that does not apply is not listed. Done when every rule touching the diff was checked.
6. **Run the four passes** of the checklist in order: CRITICAL, INFORMATIONAL, DESIGN, SIMPLICITY. A pass is done when every category has been checked against the whole diff.
7. **Merge the Codex and layered-rails opinions**. Read `codex-review.md` and the layered-rails report. For each of their findings: verify it against the code (same bar as your own — concrete failure scenario or drop it). Agreements get an "(also Codex)" or "(also layered-rails)" tag on your finding; new confirmed findings go under CODEX SECOND OPINION or LAYERED RAILS; findings you reject get a one-line rebuttal there so the user sees the disagreement, not silence.
8. **Diagram the data flow** (if the diff touches a data pipeline, request handler, or multi-step process): ASCII diagram, mark where validation happens (or doesn't), mark where errors can occur and how they're handled.
9. **Write the report** in the format of [`output.md`](output.md).

## Rules

- No style nits a linter catches. Pass 2 Readability is not a nit.
- Every critical finding must include a concrete failure scenario ("when X happens, Y breaks because Z").
- Don't flag things that are already covered by existing tests (read the test files).
- If the diff is clean, say "no issues found, ship it" — don't invent problems. Clean code that misses a line of the ask is not clean: the verdict is `partial`.
- Be specific. "This could be a problem" is useless. "This N+1 fires on the index page with 50+ records and will timeout" is useful.
- Read surrounding code for context before flagging — the "bug" might be handled elsewhere.
