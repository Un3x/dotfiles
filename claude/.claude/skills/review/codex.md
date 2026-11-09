# Codex second opinion

Review mode is read-only by design. Run it with `run_in_background`, before your own passes, so it runs in parallel. In a subagent, run it in the foreground instead (Bash `timeout` 600000): a subagent that waits on a background run ends its turn and the review never finishes. Past the timeout, the Codex line says `not run — timeout`.

## Command per target

- Branch: `codex exec review -c model_reasoning_effort=<rung> --base main > "$(git rev-parse --git-common-dir)/../.notes/<branch>/codex-review.md" 2>&1` (the main checkout's `.notes/`, which a worktree does not have). From round 2, `--base <the latest round's Head>`.
- PR number or URL: `gh pr checkout <number-or-url>` first, then the same command.
- Specific files: `codex exec review -c model_reasoning_effort=<rung> --base main "Only review: <files>"`.

## The rung

Start at `medium`, one rung up per signal, capped at `xhigh`; anything irreversible is `xhigh` whatever the count. Signals: hand-written SQL or aggregates; an invariant several layers must agree on; concurrency, retries, idempotency; auth, permissions, money, personal data, proofs and attestations; migrations; a public contract (API, webhook, email); caches or derived state; a changed method with many callers. A single file, a rename or a config bump with no signal is `low`; a purely mechanical change skips Codex (`not run — mechanical`).

## When it fails

If `codex` is missing or fails (quota, login, "Review blocked … sandbox could not start"), say so on the report's Codex line and continue: the second opinion is additive, never blocking. Never pass `--dangerously-bypass-approvals-and-sandbox` to get past a sandbox error: review mode then runs commands unsandboxed (it will happily run the test suite).
