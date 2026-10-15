---
name: review-guide
description: "Write a reading guide for a PR too large to review commit by commit; typed by the user only."
disable-model-invocation: true
---

# Review guide for a large PR

`/review-guide <PR or branch>`, typed by the user only: the user decides which PR needs one. Model: Loïc's guide for Apistration #395 (545 files, 46 000 lines, 2026-09), https://assets.delmai.re/apistration-pr-395/.

Run from the repo. A PR number resolves to its branch and commits with `gh pr view <n> --json headRefName,commits`. Read the commits in order (`git show`) before writing a line.

Write `.notes/<branch>/review-guide.md` (create the folder) in the PR's language, these sections in this order:

1. **Vue d'ensemble** — what changed in one sentence, then the deliverables per surface (routes, docs, SDKs, UI…).
2. **Exemple de bout en bout** — one concrete case followed through every stage the change touches, from declaration to what the caller or the user sees.
3. **Architecture** — the layers the change adds or moves, one paragraph each, and the notable refactorings.
4. **Gardes-fous** — the tests that keep the pieces from diverging, what they cover, what they do not.
5. **Commits & tests** — the commits in reading order, each with « ce qu'il faut lire » (the files and the idea, not the diff), and the commands to run locally. Split the essential hand-written lines from the skimmable generated ones, with the counts.

Done when the file exists: report its path and stop. The user publishes it and links it from the PR body's third line; never post it, push it or edit the PR. It never replaces the commits: it tells the reviewer which one to open next.
