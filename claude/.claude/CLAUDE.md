# Global Claude Code Instructions

## Obsidian

- To show the user a note from an Obsidian vault, open it directly instead of pasting a path: `xdg-open 'obsidian://open?vault=<vault-dir-name>&file=<vault-relative-path-URL-encoded-no-.md>'`

## Commit Conventions

- Commit messages focus on **why**, not what
- Commit message = subject line + at most 1-2 lines of why. Never narrate the diff.
- **Standalone-reviewer test**: the message must make sense to someone reading the log commit-by-commit with no access to the issue, the PR, or the plan. "Obvious" is judged from that reader's seat, not the author's — the author always has too much context.
- Subject states the behavior or capability change in domain terms, not the artifact ("Add FooService" is diff narration; "Let controllers verify attestations offline" is a subject).
- No `Co-Authored-By` trailer
- Do not add comments in code — code should be self-explanatory
- **NEVER** disable GPG signing (`--no-gpg-sign`) — always ask the user if GPG signing fails

## Prose Diet

- Never create documentation files (README sections, docs/, guides) unless explicitly requested.
- PR bodies, issue comments, handoff notes: a pointer plus the minimum that orients the reader. If it needs a paragraph, question whether it needs to exist.
- Prefer a 5-line diagram over 5 paragraphs when explaining a flow.

## Coding Behavior

- Before writing code on an ambiguous task, state the interpretation you're committing to. If two reasonable interpretations exist, ask first.
- If a go-ahead carries no acceptance criterion, state the one you'll verify against in one line before starting.
- Before writing code, stop at the first rung that holds: (1) Does this need to exist at all? (YAGNI) (2) Does the standard library do it? (3) Does a native platform feature cover it? (4) Does an already-installed dependency solve it? (5) Can it be one line? (6) Only then: the minimum that works. The escalation past a rung is itself a complexity opt-in — surface it, don't take it silently.
- Deletion over addition. Boring over clever. Fewest files possible. No abstraction, dependency, or boilerplate that wasn't requested.
- When two implementations are the same size, prefer the one with better edge-case handling.
- Never lazy about: trust-boundary validation, error handling that prevents data loss, security, accessibility, anything explicitly requested. Minimal means less code, not less correct.
- Any push landing on the default branch without a PR review gets a fresh-eyes review subagent before the done report.
- When splitting work into issues/PRs, split into vertical slices that each deliver coherent, reviewable functionality — never into horizontal layers (model / controller / tests as separate PRs). If a sub-issue can only be described by its mechanics, not by what it lets a user or system do, it's too atomic. A PR should tell one story.

## Rails Architecture

- **Vanilla Rails first.** Convention over configuration is the doctrine: reach for the Rails built-in (`validates`, `normalizes`, `enum`, scopes, `delegated_type`, `generates_token_for`, Turbo, …) before any custom construct, config flag, or option hash. If Rails has an opinion, follow it.
- Responsibility placement is not negotiable: domain logic doesn't live in controllers, one job per class. But correct placement means putting code in the right *existing* home (usually the model), not creating a new one.
- Extraction requires the rule of three — no layer, service, or abstraction for a single use. A fat-ish model beats a thin model orbited by single-caller objects.
- The layered-rails skill is a **review instrument only** (`/review` Pass 3, violations check). Never invoke it during planning or implementation; never let it prescribe adding a construct.

@RTK.md
