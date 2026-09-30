# Global Claude Code Instructions

## Obsidian

- To show the user a note from an Obsidian vault, open it directly instead of pasting a path: `xdg-open 'obsidian://open?vault=<vault-dir-name>&file=<vault-relative-path-URL-encoded-no-.md>'`
- A folder symlinked into the vault after Obsidian started is "not found" until the user reloads it (Ctrl+P → "Reload app without saving"). Ask for the reload; don't replace the link with a copy.

## Commit Conventions

- Commit messages and PR title/body: the `commit` skill, read before every `git commit` and `gh pr create`.
- Do not add comments in code — code should be self-explanatory
- **NEVER** disable GPG signing (`--no-gpg-sign`) — always ask the user if GPG signing fails

## Prose Diet

- Never create documentation files (README sections, docs/, guides) unless explicitly requested.
- Issue comments, handoff notes: a pointer plus the minimum that orients the reader. If it needs a paragraph, question whether it needs to exist.
- Prefer a 5-line diagram over 5 paragraphs when explaining a flow.

## Coding Behavior

- Before writing code on an ambiguous task, state the interpretation you're committing to. If two reasonable interpretations exist, ask first.
- If a go-ahead carries no acceptance criterion, state the one you'll verify against in one line before starting.
- Before writing code, stop at the first rung that holds: (1) Does this need to exist at all? (YAGNI) (2) Does the standard library do it? (3) Does a native platform feature cover it? (4) Does an already-installed dependency solve it? (5) Can it be one line? (6) Only then: the minimum that works. The escalation past a rung is itself a complexity opt-in — surface it, don't take it silently.
- Deletion over addition. Boring over clever. Fewest files possible. No abstraction, dependency, or boilerplate that wasn't requested.
- When two implementations are the same size, prefer the one with better edge-case handling.
- Never lazy about: trust-boundary validation, error handling that prevents data loss, security, accessibility, anything explicitly requested. Minimal means less code, not less correct.
- Any push landing on the default branch without a PR review gets a fresh-eyes review subagent before the done report.
- Splitting work into issues/PRs: vertical slices, one story per PR — the grain is in `~/.claude/skills/challenge/slices.md`.

## Rails

- **Vanilla Rails first.** Before writing or planning Rails code, read `~/.claude/skills/plan/one-rule.md`: the simplest Rails-conventional design, placement in existing homes, rule of three, layered-rails as a review instrument only.

@RTK.md
