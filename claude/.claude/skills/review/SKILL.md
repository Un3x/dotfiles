---
name: review
description: "Paranoid code review of a branch, PR, or files. Use whenever the user asks to review a PR, a pull request URL, a branch, or files (\"can you review…\", \"est-ce qu'on peut review…\")."
---

Paranoid code review. It checks what was built against what was asked, checks the diff against the written rules, runs four passes (critical, informational, design, simplicity), and merges second opinions from Codex and the layered-rails reviewer, every finding proven and ranked by severity. It is designed to catch bugs that pass CI but blow up in production.

## Usage
- `/review` - Review current branch changes against main
- `/review <PR-number>` or `/review <PR URL>` - Review a specific PR (also triggered by a plain request such as "peux-tu review https://github.com/org/repo/pull/504")
- `/review <file1> <file2> ...` - Review specific files

Each runs one agent per domain, merged here: [`split.md`](split.md). `/review solo <target>` runs every step below in one agent.

## Steps (solo; `split.md` reuses steps 1, 4, 7, 8 and 9)

1. **Gather the diff**
   - No args: `git diff main...HEAD` (all changes on current branch)
   - PR number or URL: fetch PR diff via `gh pr diff <number-or-url>`, then the PR body and every commit message (`gh pr view <number-or-url> --json body,commits`): they hold the author's why. Past a handful of commits read them in order (`git show` each) and follow the review guide when the body links one, since the commits are the author's reading path; and the author via `gh pr view <number-or-url> --json author -q .author.login` — the report prints it, so whoever relays the findings knows whether the fix is ours to delegate or the author's
   - Specific files: `git diff main -- <files>`
   - **Earlier rounds** given in the prompt (a review loop past round 1): read them, then review only what changed since the `Head:` of the latest one (`git diff <Head>..HEAD`; after a force-push, `git range-diff`). A finding already triaged `rebutted` or `deferred` is not raised again; a fixed one is checked as fixed.
2. **Asked versus built**: [`asked.md`](asked.md) — the ask as a checklist from the issue, then the diff marked against it. Done when every line carries delivered / missing / deviates and the extras are listed.
3. **Read the checklist**: [`../review-checklist.md`](../review-checklist.md), then the repo's `REVIEW.md` files: the root one and any in a folder the diff touches. They add the repo's review rules (what counts as important here, paths to skip, extra checks) on top of the checklist, the same files Claude's managed Code Review reads.
4. **Launch the Codex second opinion** in the background, before your own passes, per [`codex.md`](codex.md): the command per target, the effort rung, what to do when it fails. Collect its file after Pass 4.
   **Rails app** (`rails` in the `Gemfile`): also spawn the layered-rails reviewer, a background subagent whose prompt is exactly `Read ~/.claude/skills/layered-rails/SKILL.md § Quick Start, § Core Principles and § Extraction Signals, then review <the same target> per its workflows/review.md, skipping § Process step 4, § Anemic Job Detection, § Resolving Violations, § Output Format, § Severity Levels and § Example Review; its § Review Checklist alone judges a non-AR class under app/models/, and its links to analyze-services.md stay unopened. Read-only. Each finding as a behaviour, its steps and its result, then a Where: line with its paths.` It reviews the same range as Codex, from round 2 the latest round's `Head:` onwards. Collect its report after Pass 4. If it fails or times out, write `not run — <reason>` on the report's Layered rails line and continue.
5. **Rules check**: list the written rules that govern this diff: the repo's `CLAUDE.md` files nearest each changed path, its `.claude/skills`, and the rows of the lessons ledger (`~/Documents/mylife_in_a_vault/systems/lessons.md`) whose Home column names one of those files, a skill (`plan/`, `ship/`, `review/`, `commit/`) or a shared file at the skills root (`one-rule.md`, `design-grid.md`, `review-checklist.md`, `red-green-commit.md`, `slices.md`); no ledger on this machine: skip it and say so. Check the diff against each rule whose area it touches. A broken rule is a `rule` row, the rule quoted, its file in the row's details; a rule that does not apply is not listed. Done when every rule touching the diff was checked.
6. **Run the four passes** of the checklist in order: CRITICAL, INFORMATIONAL, DESIGN, SIMPLICITY. A pass is done when every category has been checked against the whole diff.
7. **Merge the Codex and layered-rails opinions**. Read `codex-review.md` and the layered-rails report. A finding already triaged in an earlier round is dropped. For each of the others: verify it against the code at the bar of § Rules, or drop it. A confirmed finding becomes a row like your own, merged into yours when it is the same; a rejected one gets a one-line rebuttal in § Second opinions, so the user sees the disagreement, not silence.
8. **Diagram the data flow** (if the diff touches a data pipeline, request handler, or multi-step process): ASCII diagram, mark where validation happens (or doesn't), mark where errors can occur and how they're handled.
9. **Write the report** in the format of [`output.md`](output.md): every finding ranked by severity and placed as a summary or a line finding. Done when every finding has its details. Asked for by the user: show the report, and post it as `output.md` § Posted on the PR once they say go. Under an auto-review brief: post it at once, the brief is the go. Run inside `/ship`'s loop: never posted, the report is the round file.

## Rules

- No style nits a linter catches. Pass 2 Readability is not a nit.
- Every `critical` or `important` `bug`, `test` and `ask` row includes a concrete failure scenario ("when X happens, Y breaks because Z"); a `design` row states who holds what, and an `unclear` ask line what would settle it.
- No finding without a trace: the entry point that reaches it, the values that get there, the line that misbehaves. A doubt is something to investigate, not to report: prove it or cut it, never « potential », « may », « risky ». A maybe handed to the reader bills them for the work skipped, and six maybes cost the trust in the one proven finding. An Unproven premise and an ask line marked `unclear` state a missing proof, which is itself the fact: they keep their place.
- A choice the PR body or a commit message explains is raised only when the explanation does not hold, and the row says why, quoting it.
- Read the tests before raising a `bug` or `test` row: a behaviour a test already pins is not a finding.
- If the diff is clean, say "no issues found, ship it" — don't invent problems. Clean code that misses a line of the ask is not clean: the verdict is `partial`.
- Every claim is grounded in code you read, and its paths go on the row's `Where:` in § Details.
- When the diff holds several instances of one kind of bug, one row names that class on its `Class:` and lists every instance, so one round fixes them all.
- A bug in code the diff did not change is a `pre-existing` row: it does not count against the PR.
