---
name: manual-review-pr
description: "Review a PR with the user at the design level, then publish the review as a Claude artifact and draft the comment the user posts; typed by the user only."
disable-model-invocation: true
---

# Manual PR review

`/manual-review-pr <PR> [first remarks]`, typed by the user only. A review done with the user, not for them: the agent brings facts and a second opinion, the user decides, and the page at the end records the target design and every decision with its justification. Where responsibilities live is the point, not line-level nitpicks. `/review` is the agent reviewing alone; here the user reviews a PR with the agent.

**Never post on the PR** (comment, review, suggestion, label), even when asked: the user posts.

## 1. Inputs

- The PR URL, or its number in the current repository.
- The user's first remarks, when given: they are the agenda, every one gets a verdict.
- An earlier review by the user (notes, a page): never modified, and read only after the agent's own pass. A second opinion primed by the first is worth half as much.

## 2. Collect

Run from the repo; `<n>` is the PR number, `<base>` its `baseRefName`.

```bash
SCRATCH=<the session's scratchpad directory>
gh pr view <PR> --json title,body,headRefName,baseRefName,files,commits
SHA=$(gh pr view <PR> --json headRefOid -q .headRefOid)
gh pr diff <PR> > "$SCRATCH/pr.diff"
git fetch -q origin "pull/<n>/head" <base>
git log --format='--- %s%n%n%b' "origin/<base>..${SHA}"
```

- Read files at the head commit with `git show "${SHA}:path"`, without checking the branch out. Under zsh, brace the variable: `$SHA:path` is a zsh modifier and mangles the path.
- The commit messages hold the author's why, and the why is what the review challenges.
- Split the diff into hand-written code and the rest (lockfiles, generated docs, vendored code, fixtures, mock payloads, changelogs).

## 3. Size the pass

The local pass alone when the hand-written diff stays under about 600 lines and touches no costly area. A Codex pass is added above it, on a costly area, or when the local pass cannot be independent (the user's conclusions are already in the conversation). Costly areas: money, access and authorization, personal data, outbound actions (mails, webhooks, third-party calls), documents with legal or evidentiary value, irreversible data changes, public contracts (API, SDK, file formats). The threshold is a starting point: when a review shows it wrong, change it here.

Codex runs on a detached worktree so the user's checkout never moves, the block launched with `run_in_background` (`SCRATCH` set again in it) and `$SCRATCH/codex-review.md` read after the local pass:

```bash
git worktree add --detach "$SCRATCH/wt" "${SHA}"
(cd "$SCRATCH/wt" && codex exec review -c model_reasoning_effort=<rung> --base "origin/<base>" > "$SCRATCH/codex-review.md" 2>&1)
git worktree remove --force "$SCRATCH/wt"
```

The rung, the failures and the sandbox rule are `/review` step 4's. Its findings are checked against the code and triaged into the same list.

## 4. The local pass, design first

Walk the design grid, `~/.claude/skills/review/design-grid.md`, on the diff and on what it plugs into, and measure the shape against what is being built (`~/.claude/skills/plan/one-rule.md`). Check every claim against the code before saying it. A user remark can rest on a wrong fact (« it runs once per request » when it runs once per item): say so, then answer the concern behind it.

## 5. Converse

- First message, in the user's language: the user's points one by one (agree / disagree, the fact, the alternative), then the agent's own findings ranked, short, with `file:line` references. No code dump.
- Then one topic per round, at the user's pace. Asked to explore: two or three approaches with honest costs, one recommended; the chosen one gets a sketch in the repository's idioms.
- Brutally honest: a cost or a hole in the user's direction is said once, clearly, then their decision is followed.
- A ledger in `.notes/pr-<n>/manual-review.md`, the page's source, so a later session picks the review up:
  - **axes**: in the PR / constraints / options with their costs / recommended one / consequences;
  - **decisions**: the decision and the user's justification, in their words;
  - **open questions**;
  - **minor notes**, kept even when waved off.

Offer the page when the axes have converged; build it when asked.

## 6. The page

When the user asks for it: build and publish it following [`page.md`](page.md). Done when published: give the URL.

## 7. The comment the user posts

With the URL, draft the comment the user will post with their review: the page link first, then a few short prose paragraphs on what does not suit them, conclusions only, by weight: design to rework, bugs, product points, the non-blocking flagged as such. It says what is wrong and why, not how to fix it: no option name or sketch from the page, which would anchor the author on one solution. No headings, bold, tables or checklists; the user's language; the same leak check as the page, since the comment is as public as the repository. Shown in the conversation; the user posts it.
