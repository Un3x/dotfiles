# Output format

File references are full repository paths, never a basename: Rails has many `show.html.erb`.

The report is written in the language of the PR (title, commits, description), whatever language the session runs in: it is relayed to the team as is (2026-09-18 Passemarche, 2026-09-21 Apistration: two reports rewritten in French on request).

```
## Code Review: [branch or PR title]

### ASKED vs BUILT
Ask: [ISSUE-ID and title, or "no source found"]
- [line of the ask] — delivered (`file`, `test`) | missing | deviates: [how] | unclear: [what would settle it] | unproven
- ...
Extra: [what the diff does that no line asked for, with size, and the limit it crosses if any] (or none)
Verdict: delivered | partial | off-target

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
- Author: [PR author login, or the branch owner]
- Model: [the model this review ran on]
- Asked: delivered | partial (N missing, N unproven) | off-target | no source found
- Critical: N issues
- Simplicity: N issues
- Informational: N issues
- Codex: N confirmed / N rejected
- Verdict: [ship it / fix criticals first / simplify first / needs rethink]
```
