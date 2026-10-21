# Global Claude Code Instructions

## Obsidian

- To show the user a note from an Obsidian vault, open it directly instead of pasting a path: `xdg-open 'obsidian://open?vault=<vault-dir-name>&file=<vault-relative-path-URL-encoded-no-.md>'`
- A folder symlinked into the vault after Obsidian started is "not found" until the user reloads it (Ctrl+P → "Reload app without saving"). Ask for the reload; don't replace the link with a copy.
- Inside herdr (`$HERDR_ENV` set), open the note as an nvim tab of the current workspace instead: `P=$(herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd <vault> --label "<short name>" --focus | jq -r '.result.root_pane.pane_id')`, then `herdr pane run "$P" "nvim <vault-relative path>"`.

## Servers and secrets

- Never connect to a server (`ssh`, `scp`, remote exec) and never read, decrypt or print a secret (Rails credentials, ansible-vault, `.env` values). Hand the user the command and let them paste back what they choose. Public HTTP checks are fine.

## Commit Conventions

- Commit messages and PR title/body: the `commit` skill, read before every `git commit` and `gh pr create`.
- Do not add comments in code — code should be self-explanatory
- **NEVER** disable GPG signing (`--no-gpg-sign`). If signing fails, the key is locked: leave the change staged with its message ready, end your message with this line on its own — `GPG locked — run: ! echo | gpg --clearsign >/dev/null, then say go` — and carry on with whatever needs no commit. A subagent hands that line up to the session that spawned it.

## Prose Diet

- Never create documentation files (README sections, docs/, guides) unless explicitly requested.
- Issue comments, handoff notes: a pointer plus the minimum that orients the reader. If it needs a paragraph, question whether it needs to exist.
- Prefer a 5-line diagram over 5 paragraphs when explaining a flow.
- Anything handed to someone (a review, a PR, an issue, a message) is ready to pass on as is. If Thomas has to rewrite it, it failed.
- A number in a rule is a goal that holds for about 95% of usual cases, never a limit to enforce: say what is necessary and sufficient, then stop. Reality checks the goal: when a scan shows it missed often, challenge the goal or the way we write. The exception is a stop that signals a deeper problem, like ship's three review rounds.
- A PR, issue or ticket (GitHub, Linear…) named in a message to the user or in a subagent report comes with its full URL, never a bare `#133` or `SIM-257`.

## Coding Behavior

- Before writing code on an ambiguous task, state the interpretation you're committing to. If two reasonable interpretations exist, ask first.
- If a go-ahead carries no acceptance criterion, state the one you'll verify against in one line before starting.
- Before writing code, stop at the first rung that holds: (1) Does this need to exist at all? (YAGNI) (2) Does the standard library do it? (3) Does a native platform feature cover it? (4) Does an already-installed dependency solve it? (5) Can it be one line? (6) Only then: the minimum that works. The escalation past a rung is itself a complexity opt-in — surface it, don't take it silently.
- Deletion over addition. Boring over clever. Fewest files possible. No abstraction, dependency, or boilerplate that wasn't requested.
- When two implementations are the same size, prefer the one with better edge-case handling.
- Never lazy about: trust-boundary validation, error handling that prevents data loss, security, accessibility, anything explicitly requested. Minimal means less code, not less correct or less readable.
- Any push landing on the default branch without a PR review gets a fresh-eyes review subagent before the done report.
- Splitting work into issues/PRs: vertical slices, one story per PR — the grain is in `~/.claude/skills/challenge/slices.md`.

## Contradictions

- When two things acted on disagree (a rule, the plan, a review finding, the ticket, the code, what the user said), that is never normal and never the agent's to settle: stop, quote both sides, ask the user. Never pick a side because it is newer, already approved or easier: rebutting a review finding by citing the plan is picking a side. A claim a test or the code can check is not a contradiction: check it.
- A new rule contradicts no rule in a `CLAUDE.md` or under `~/.claude/skills/`; if it does, the user reconciles both into one wording before anything is committed.
- A subagent does not ask: it leaves that point undone, finishes the rest, and opens its report with `Contradictions:`, both sides quoted.

## Rails

- **Vanilla Rails first.** Before writing or planning Rails code, read `~/.claude/skills/plan/one-rule.md`: what we are building sets the shape (trivial, fills a system, new system, isolated); simple and readable, no graft, code with the object that owns the decision.

@RTK.md
