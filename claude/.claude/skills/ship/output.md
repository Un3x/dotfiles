# Output templates

### When resuming:
```
Resuming FAS-124 (started YYYY-MM-DD), phase implement, step 3/5.
```

### When shipped:
```
Shipped FAS-124 -> PR: https://github.com/org/repo/pull/124 (review clean after 2 rounds)
```

### When the review cap is hit:
```
FAS-124 -> PR: https://github.com/org/repo/pull/124 — 3 review rounds done, findings still open:
  - [finding]
Suspect: design | scope — [why]
Session saved. Fix manually or answer here to continue.
```

### When skipped:
```
FAS-124 not shipped: the plan has open questions. Run /plan FAS-124 to resolve them.
```

### On error:
```
Error shipping FAS-124: [error details]
Session saved. Run /ship to retry.
```
