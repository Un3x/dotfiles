# Global Claude Code Instructions

## Commit Conventions

- Commit messages focus on **why**, not what
- No `Co-Authored-By` trailer
- Do not add comments in code — code should be self-explanatory
- **NEVER** disable GPG signing (`--no-gpg-sign`) — always ask the user if GPG signing fails

## Coding Behavior

- Before writing code on an ambiguous task, state the interpretation you're committing to. If two reasonable interpretations exist, ask first.

## Rails Architecture

- Apply layered architecture principles (layered-rails skill) by reflex on any Rails work: planning features, reviewing code/PRs, refactoring, or discussing design trade-offs
- Extraction requires the rule of three — don't create a layer, service, or abstraction for a single use. Layered architecture says where code goes when it exists, not that more layers are better.
