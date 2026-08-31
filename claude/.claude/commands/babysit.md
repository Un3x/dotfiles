Keep a PR merge-ready without the user polling it. Watches CI, conflicts, and review comments; fixes what's mechanical; escalates what needs judgment.

## Usage
- `/babysit <PR number or URL>` — watch and fix, never merge
- `/babysit <PR> --merge` — additionally merge when clean (explicit grant per invocation; meant for dependency PRs under the standing "merge what's green" rule)

## Loop

Run as a self-paced /loop. Each tick:

1. `gh pr view <PR> --json state,mergeStateStatus,statusCheckRollup,reviews,comments`
2. Merged or closed → stop, report.
3. `mergeStateStatus == DIRTY` → rebase on main, push (our branches and dependency branches only).
4. Failing check → `gh run view --log-failed`, root-cause it. Suspected flake → rerun once, note it. Real failure → fix with the red-green-commit cycle, push.
5. New review comments → apply unambiguous mechanical ones (rename, typo, format) as commits; anything needing design judgment goes in the report, never guessed at.
6. All green, no conflicts, no open comments → with `--merge`: merge, report. Without: report "merge-ready", stop.

Pacing: CI running → `gh pr checks <PR> --watch`; awaiting reviewers → 20–30 min; idle → hourly.

## Stop and report (don't push through)
- 3 failed fix attempts on the same check
- the next fix would force a design choice or exceed the plan's size cap
- ambiguous or high-severity review feedback
- GPG signing fails — never disable it, ask

## Boundaries
- Never merge without `--merge` in this invocation; prod promote stays manual regardless.
- Force-push only after autosquash on our own branch, never on a colleague's.
- Report: one line per action taken, one block for what's left to the user.
