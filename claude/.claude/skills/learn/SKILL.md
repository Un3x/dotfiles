---
name: learn
description: "Turn a human review into rules the agent will read again: sort one-off fixes from lessons, check each lesson against the ledger, draft the rule where the decision is made, and log it. Use after a PR of ours gets a teammate's or the user's review, after the user reviews a teammate's PR, or when the user says « learn from this review », « tire les leçons », « /learn <PR> » or « /learn since <date> »."
---

# learn

Review → lesson → written rule → never again. A lesson is worth only where the agent reads it at the moment of the decision: a rule stored elsewhere is not memory. The ledger proves the « never again »: a lesson that comes back means its rule sits in the wrong place or says too little.

Ledger: `~/Documents/mylife_in_a_vault/systems/lessons.md`, one row per lesson.

## Input

- `/learn <PR>`: one PR, ours or a teammate's. A URL from another repo: pass `-R <owner>/<repo>` to every `gh` call.
- `/learn since <date>`, on the user's ask: every PR merged since then that carries a human comment. `gh pr list --state merged --search "merged:>=<date>" --limit 200 --json number,author,reviews,comments`, then the inline comments of each. One subagent per ten PRs, read-only, returning the step 5 table; this session merges them.

**Human** means a comment whose author is not a bot (`user.type == "Bot"`, a login ending in `[bot]`) and not an agent review posted by our `/review`. The user's own comments count.

## Steps

1. **Gather the human comments**: `gh pr view <PR> --json author,title,url,reviews,comments` and the inline threads (`gh api --paginate repos/{owner}/{repo}/pulls/<n>/comments`, placeholders resolved inside a checkout, else spelled out). Each inline comment carries `original_commit_id` (the code it points at); the commit that answered it is the next one on that path (`git log --format='%h %s' <original_commit_id>..<head> -- <path>`).
2. **Sort each comment**:
   - **Fix**: true of this diff only; the commit that answered it says everything. Counted, nothing written.
   - **Lesson**: it would have caught a mistake in another PR. Test: rewrite it without this PR's names; if it still says something, it is a lesson.
   - **Taste**: a preference stated once. The user says whether it is a rule.
3. **Check the ledger and the homes** for a rule that already covers the lesson (`grep` the ledger, the repo's `CLAUDE.md` files and `.claude/skills`, `~/.claude/skills`). Covered: it is a **repeat**. Add the PR to that row's Repeats and say why the rule was not applied: not read at the decision, too vague, or contradicted by code the agent copied. The fix moves or sharpens that rule, never adds a second one.
4. **Draft the rule** for a new lesson: one or two sentences, the why with it, a short example from the PR stripped of its names. Its home is where the agent reads it when it makes that decision:

   | The lesson is about | Home |
   | --- | --- |
   | this repo's code: ownership, naming, a pattern not to copy | the repo's `CLAUDE.md` nearest the code (`siade/CLAUDE.md` before the root) |
   | how we work, in any repo: challenge, plan, ship, review, commits | the skill file whose step makes that decision (`~/.claude/skills/…`, dotfiles) |
   | a fact about a project, not a rule | the vault project files (`projects/<name>/`) |

   A lesson about this repo's code goes to the repo even when a skill could hold it: the team's agents read the repo, not our skills. Never the per-repo auto-memory: it is recalled by description, not at the decision.
5. **Show the user** a table: comment (link), reviewer, fix count, lesson / taste / repeat, draft rule, home. The user keeps, rewords or cuts. Nothing is written before.
6. **Apply what was kept**:
   - dotfiles skills: edited and committed (`commit` skill), pushed after a fresh-eyes review subagent (global `CLAUDE.md`);
   - repo rules: one PR per repo and session, opened by that project's session; a repo where the user is the sole reviewer still goes through a PR the user merges;
   - ledger: one row per new lesson, the PR added to the Repeats cell of a repeat, committed in the vault.

## Ledger row

```
| <date> | <repo>#<n> (<reviewer>) | <the lesson, one line> | <home file> | <repo>#<n>, <repo>#<n> |
```

The Repeats cell lists the PRs where the same miss came back. Two PRs in it: the next `/learn` flags the rule, to move or rewrite.

## Rules

- The comment is the reviewer's; the lesson is ours to word. Never put a rule in the reviewer's mouth on a team PR or in a reply.
- One lesson, one home; another file points to it only if it must.
- A comment the user wrote on a teammate's PR is a lesson source too: it feeds the repo's rules, the ones every agent of the team reads.
