# Global Claude Code Instructions

## Commit Conventions

- Commit messages focus on **why**, not what
- No `Co-Authored-By` trailer
- Do not add comments in code — code should be self-explanatory
- **NEVER** disable GPG signing (`--no-gpg-sign`) — always ask the user if GPG signing fails

## Coding Behavior

- Before writing code on an ambiguous task, state the interpretation you're committing to. If two reasonable interpretations exist, ask first.
- Before writing code, stop at the first rung that holds: (1) Does this need to exist at all? (YAGNI) (2) Does the standard library do it? (3) Does a native platform feature cover it? (4) Does an already-installed dependency solve it? (5) Can it be one line? (6) Only then: the minimum that works. The escalation past a rung is itself a complexity opt-in — surface it, don't take it silently.
- Deletion over addition. Boring over clever. Fewest files possible. No abstraction, dependency, or boilerplate that wasn't requested.
- When two implementations are the same size, prefer the one with better edge-case handling.
- Never lazy about: trust-boundary validation, error handling that prevents data loss, security, accessibility, anything explicitly requested. Minimal means less code, not less correct.
- When splitting work into issues/PRs, split into vertical slices that each deliver coherent, reviewable functionality — never into horizontal layers (model / controller / tests as separate PRs). If a sub-issue can only be described by its mechanics, not by what it lets a user or system do, it's too atomic. A PR should tell one story.

## Rails Architecture

- Apply layered architecture principles (layered-rails skill) by reflex on any Rails work: planning features, reviewing code/PRs, refactoring, or discussing design trade-offs
- Extraction requires the rule of three — don't create a layer, service, or abstraction for a single use. Layered architecture says where code goes when it exists, not that more layers are better.
