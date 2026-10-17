---
name: review-guide
description: "Publish a reading guide, as a Claude artifact, for a PR too large to review commit by commit; typed by the user only."
disable-model-invocation: true
---

# Review guide for a large PR

`/review-guide <PR or branch>`, typed by the user only: the user decides which PR needs one. Model: https://assets.delmai.re/apistration-pr-395/.

Run from the repo. A PR number resolves to its branch and commits with `gh pr view <n> --json headRefName,commits`. Read the commits in order (`git show`) before writing a line.

The guide is a Claude artifact, never a local `.md`: an HTML page in the session's scratchpad directory (`review-guide-<branch>.html`), published with the Artifact tool, whose rules apply (it loads its design skill first); first publish with icon `guide` and the title `Guide de lecture <PR>`. In the PR's language, these sections in this order, one anchored section each:

1. **Vue d'ensemble** — what changed in one sentence, then the deliverables per surface (routes, docs, SDKs, UI…).
2. **Exemple de bout en bout** — one concrete case followed through every stage the change touches, from declaration to what the caller or the user sees.
3. **Architecture** — the layers the change adds or moves, one paragraph each, and the notable refactorings.
4. **Gardes-fous** — the tests that keep the pieces from diverging, what they cover, what they do not.
5. **Commits & tests** — the commits in reading order, each with « ce qu'il faut lire » (the files and the idea, not the diff), and the commands to run locally. Split the essential hand-written lines from the skimmable generated ones, with the counts.

Rules:

- **Executive first.** The overview answers « what is this PR and what must I read »; the rest is one click away.
- **Say what can be skipped, with numbers.** Generated and mechanical files are most of a large diff: count them from `git diff --numstat` and name the check that guarantees them, so the reader trusts skipping them.
- **Each step of the example** says in its title what the reader is looking at, and in its first sentence how it differs from the previous one.
- **Only real artefacts.** Code excerpts, payloads, failure messages and screenshots come from the head commit or from running it, truncated visibly with `…`. Never an invented payload: a plausible fake misleads the reviewer the guide is for.
- **Link everything, pinned**: files to the method that matters (`blob/<sha>/path#L43`), commits to their page in the PR, never a branch name, since the guide outlives the branch.
- **Assumptions labelled as assumptions**: a decision resting on a belief (« nobody relies on these codes ») says why it is believed and who adapts if it is wrong, in a warning callout.
- **Behaviour changes in a Before / After / Why table**, so a reviewer checks each one against the code.
- **Show the safety nets' real failure messages**: they tell a future contributor what to do.
- **Numbers come from commands** run on the head commit, identical wherever they appear.

Done when the artifact is published: report its URL and stop. It is private; the user shares it and links it from the PR body's third line. A new round of commits republishes to the same URL: the same file path in this session, the artifact's `url` from another. Never post it on the PR, push it or edit the PR. It never replaces the commits: it tells the reviewer which one to open next.
