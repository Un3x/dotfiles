# How the harness is written

Read at step 2 for its thresholds, and at step 6 before writing a line in a skill, a hook or a `CLAUDE.md`. These files are read by agents that have none of the context in which they were written. The method comes from mattpocock's [`writing-for-agents`](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-for-agents/SKILL.md) and Anthropic's [skill best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices); reopen them rather than remember them.

## Shape of a skill

- **`SKILL.md` carries what every run reads, and nothing else**: the role in three lines, the steps in order, each ending with what says it is done, at most five rules.
- **Reference is a sibling file, read at the step that needs it**, named at that step by its relative path. **One level deep**: a sibling never links another sibling; the model reads a second-level link as `head -100`. A sibling above 100 lines opens with `## Contents`.
- **A gesture two skills perform is a skill both call**; naming the Skill tool gets the call, a `/name` in prose does not. A fact two skills read stays a sibling at its owner. A new skill costs its description on every turn: create one only with two callers observed.
- **The description is a pointer, not a summary**: what the skill does in one sentence, then the triggers, one per branch. A skill no other skill calls carries `disable-model-invocation: true`: its description then costs nothing per turn and only `/name` typed by the user invokes it.
- **One anecdote per rule, the most probative, dated, with what it cost.** "seen 2026-09-11 on Simplifions and Bangun" beats an adverb. An anecdote whose defect is fixed is removed.
- **A number lives in the audit that measured it**, dated. A skill that needs an order of magnitude points there; a copied number becomes a false instruction.
- **No no-op** — an instruction the model already follows by default pays its line for nothing. **No negation of a positive already written** — "don't do X" makes X more present. A rule earns its place by parrying a gesture the model makes willingly and no positive covers.
- **Move sections, don't rewrite sentences.** A file refined by twenty sessions is cut by moving its paragraphs; the register (`forme.py --register`) proves each one has a fate.

## Thresholds, and what they protect

`scripts/forme.py` applies them; a `!` is a finding.

| Threshold | Value | Protects |
| --- | --- | --- |
| lines of a `SKILL.md` or a `CLAUDE.md` | 100 (never above 150) | that a rule at § 5.3 weighs as much as at § 1 |
| characters of a model-invoked description | 400 | every turn of every session, where all are loaded |
| rules / boundaries | 5 | that they stay read |
| toc on a sibling | from 100 lines | that a partial read sees everything it holds |
| duplicated paragraphs (`--dups`) | 0 | that a fact has one home |
| user corrections on the same rule | 2 → mechanize | that prose broken twice becomes a control ([Fowler](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html)) |

## `CLAUDE.md`

Read in full at every turn. Anthropic: under 200 lines, and for each line ask "would removing it make Claude err?" — if not, cut. Adding a line means removing one, or pointing to a skill loaded only on invocation.
