# Output templates

### When resuming:
```
Resuming ship session (started YYYY-MM-DD).
Progress: 3/10 issues shipped, 1 in-progress.
Current: FAS-124 (phase: implement, step 3/5)

Continuing implementation...
```

### After each issue ships:
```
Shipped FAS-124 -> PR: https://github.com/org/repo/pull/124 (review clean after 2 rounds)
Continuing with FAS-125...
```

### When the review cap is hit:
```
FAS-124 -> PR: https://github.com/org/repo/pull/124 — 3 review rounds done, findings still open:
  - [finding]
Session saved. Fix manually or answer here to continue.
```

### When batch complete:
```
Shipping complete.

Shipped:
  FAS-123 - title -> PR: https://github.com/org/repo/pull/123
  FAS-124 - title -> PR: https://github.com/org/repo/pull/124

Skipped (has questions):
  FAS-125 - title (run /plan FAS-125 to resolve)

Failed:
  FAS-126 - title (error: reason)
```

### On error:
```
Error shipping FAS-126: [error details]

Session saved. Run `/ship` to retry this issue or continue with remaining.
To skip this issue: manually mark as skipped in .notes/_ship-session.md
```
