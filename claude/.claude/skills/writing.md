# How we write for agents

Read at `/harness` step 2 for its thresholds, and at step 6 before writing a line in a skill, a hook or a `CLAUDE.md`. These files are read by agents that have none of the context in which they were written. The method is the `writing-for-agents` skill ([`writing-for-agents/SKILL.md`](writing-for-agents/SKILL.md), mattpocock's, kept verbatim but for the line pointing here, its upstream checked by `harness/scripts/upstream.sh`) and Anthropic's [skill best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices); this file holds only our house rules on top.

## Shape of a skill

- **`SKILL.md`**: the role in three lines, the steps in order, around five rules; the rest is disclosed as `writing-for-agents` says. **Siblings one level deep**: a sibling never links another sibling; the model reads a second-level link as `head -100`. A sibling above 100 lines opens with `## Contents`.
- **Shared behaviour is factored, at the level it is shared.** A gesture two skills perform is a skill both call, through the Skill tool (a `/name` in prose gets no call). Reference two skills read is a plain file at the root of `~/.claude/skills/` (as `tracker.md`), never one skill's sibling. Our process is shared in our configuration; what the skills of one code repository share stays in that repository's `.claude/`.
- **Invocation** follows `writing-for-agents`' `SKILL-MECHANICS.md`: model-invoked when the agent must reach the skill on its own or another skill must, typed-only otherwise.
- **A rule states its why in general words.** No date, no PR, no ticket, no project name. A story that only explains one case is dropped, or turned into a general rule that covers it. A rule whose defect no longer occurs is removed.
- **A rule is strict, and tested.** No hedge word (« reasonably », « where appropriate », « if needed »): a number, a named case or the target behaviour. « Never » and « always » are for a restriction, beside its positive target. A line in doubt is run with and without it; the one that changes nothing is cut.
- **Three kinds of number.** A **goal**, most of them, is written as one ("about 60 characters"): it holds for about 95% of usual cases, and comprehension wins when they clash. A **restriction** is written as a cap: a hard limit a project or a best-practice skill sets on purpose (a design system's sizes, timings, contrast), or a stop that signals a deeper problem (ship's three review rounds). A **measured** number (a count, a size, a rate observed) lives in the audit that measured it, dated; a rule that needs it points there, because a copied measurement goes stale.
- **Move sections, don't rewrite sentences.** A file refined by twenty sessions is cut by moving its paragraphs; the register (`forme.py --register`) proves each one has a fate.

## Thresholds, and what they protect

The "about" rows are goals; the zero duplicates and the two corrections are restrictions. `harness/scripts/forme.py` marks a file past one with `!`: read it, and it is a finding only when the extra is not needed.

| Threshold | Value | Protects |
| --- | --- | --- |
| lines of a `SKILL.md` or a `CLAUDE.md` | about 100 | that a rule at § 5.3 weighs as much as at § 1 |
| characters of a model-invoked description | about 400 | every turn of every session, where all are loaded |
| rules / boundaries | about 5 | that they stay read |
| toc on a sibling | from 100 lines | that a partial read sees everything it holds |
| duplicated paragraphs (`--dups`) | 0 | that a fact has one home |
| user corrections on the same rule | 2 → mechanize | that prose broken twice becomes a control ([Fowler](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html)) |

## `CLAUDE.md`

Read in full at every turn. Anthropic: under 200 lines, and for each line ask "would removing it make Claude err?" — if not, cut. Adding a line means removing one, or pointing to a skill loaded only on invocation.
