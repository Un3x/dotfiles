# Output format

File references are full repository paths, never a basename: Rails has many `show.html.erb`.

```
## Code Review: [branch or PR title]

### CRITICAL (must fix)

**1. [Category]: [Brief description]**
`file:line` — [explanation of the failure scenario]
Fix: [suggested fix]

**2. ...**

### ARCHITECTURE (layer violations)

**1. [Violation type]: [Brief description]**
`file:line` — [explanation + which layer boundary is crossed]
Fix: [suggested extraction or restructure]

### SIMPLICITY (over-engineering)

**1. [Category]: [Brief description]**
`file:line` — [what it costs, what deleting/inlining buys]

### CODEX SECOND OPINION
**Confirmed:** [findings Codex raised that you verified and did not have]
**Rejected:** [finding — why]
(or: "Codex: no additional findings" / "Codex: not run — <reason>")

### INFORMATIONAL (worth knowing)

**1. [Category]: [Brief description]**
`file:line` — [explanation]

### Data Flow
[ASCII diagram if applicable]

### Summary
- Critical: N issues
- Simplicity: N issues
- Informational: N issues
- Codex: N confirmed / N rejected
- Verdict: [ship it / fix criticals first / simplify first / needs rethink]
```
