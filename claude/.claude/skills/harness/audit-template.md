# Audit template

Read at step 5. The audit goes in the vault, `reviews/harness/YYYY-MM-DD.md` (`YYYY-MM-DD-<topic>.md` for a pass on a request). An applied finding without its `Expected impact` line is not finished.

```md
# Harness — pass of YYYY-MM-DD

Window: from … to …, <n> sessions across <n> projects.
Previous: <link to the previous audit, or "first">.

## Impact of previous passes
| Finding | Measure | Baseline | Result | Held / not held / not measurable |
| --- | --- | --- | --- | --- |

## Measures
| | This window | Previous |
| --- | --- | --- |
| user corrections (scan-corrections, after triage) | | |
| corrections hitting a rule already written | | |
| guardrail blocks (hook stderr in transcripts) | | |
| harness files touched | | |
| shape (`forme.py`): files above a threshold, description chars loaded, duplicated paragraphs | | |

## Findings
### <n>. <one line: the defect>
**Pillar**: context | constraints | entropy
**Evidence**: <session file, timestamp, or file:line, or the measure — collected in this pass>
**Remedy**: <write | move | shorten | mechanize | fix | merge | remove | repatriate | measure> — <where, one sentence>
**Expected impact**: <measure> — baseline <value, date> — expected <direction or threshold> — remeasure on <date> — if not: <fallback>
**Applied**: yes, commit "…" | proposed, awaiting the user

## Memories repatriated
| Memory | To | Delete after merge |

## What I could not verify
<sources out of reach, transcripts too big to read in full, and why>
```

The report in the thread: the branch or PR, the number of findings applied and proposed, the two or three that change the most, one expected-impact line per applied finding, the memories to delete after merge. The detail is in the audit.
