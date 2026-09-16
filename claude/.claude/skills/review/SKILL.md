---
name: review
description: "Paranoid two-pass code review of a branch, PR, or files. Use whenever the user asks to review a PR, a pull request URL, a branch, or files (\"can you review…\", \"est-ce qu'on peut review…\")."
---

Paranoid code review. Two-pass structural audit of changes, designed to catch bugs that pass CI but blow up in production.

## Usage
- `/review` - Review current branch changes against main
- `/review <PR-number>` or `/review <PR URL>` - Review a specific PR (also triggered by a plain request such as "peux-tu review https://github.com/org/repo/pull/504")
- `/review <file1> <file2> ...` - Review specific files

## Purpose

This is the **paranoid staff engineer brain**. Not a style review, not a linting pass. This catches structural bugs: race conditions, N+1 queries, trust boundary violations, silent failures, and logic errors.

## Steps

1. **Gather the diff**
   - No args: `git diff main...HEAD` (all changes on current branch)
   - PR number or URL: fetch PR diff via `gh pr diff <number-or-url>`
   - Specific files: `git diff main -- <files>`
2. **Read the checklist**: `.claude/review-checklist.md` if the project has one (project-specific overrides), else [`checklist.md`](checklist.md).
3. **Launch the Codex second opinion (background)**. Start it before your own passes so it runs in parallel (review mode is read-only by design):
   - Branch: `codex exec review --base main > .notes/<branch>/codex-review.md 2>&1`
   - PR number or URL: `gh pr checkout <number-or-url>` first, then the same command
   - Specific files: `codex exec review --base main "Only review: <files>"`
   Run it with `run_in_background`; collect the file after Pass 4. If `codex` is missing or fails (quota, login, "Review blocked … sandbox could not start"), say so in the Summary and continue — the second opinion is additive, never blocking. Never pass `--dangerously-bypass-approvals-and-sandbox` to get past a sandbox error: review mode then runs commands unsandboxed (it will happily run the test suite).
4. **Run the four passes** of the checklist in order: CRITICAL, INFORMATIONAL, ARCHITECTURE (Rails only), SIMPLICITY. A pass is done when every category has been checked against the whole diff.
5. **Merge the Codex opinion**. Read `codex-review.md`. For each Codex finding: verify it against the code (same bar as your own — concrete failure scenario or drop it). Agreements get a "(also Codex)" tag on your finding; new confirmed findings go under CODEX SECOND OPINION; findings you reject get a one-line rebuttal there so the user sees the disagreement, not silence.
6. **Diagram the data flow** (if the diff touches a data pipeline, request handler, or multi-step process): ASCII diagram, mark where validation happens (or doesn't), mark where errors can occur and how they're handled.
7. **Write the report** in the format of [`output.md`](output.md).

## Rules

- No style nits. RuboCop and linters handle that.
- Every critical finding must include a concrete failure scenario ("when X happens, Y breaks because Z").
- Don't flag things that are already covered by existing tests (read the test files).
- If the diff is clean, say "no issues found, ship it" — don't invent problems.
- Be specific. "This could be a problem" is useless. "This N+1 fires on the index page with 50+ records and will timeout" is useful.
- Read surrounding code for context before flagging — the "bug" might be handled elsewhere.
