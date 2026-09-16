---
name: harness
description: "Improve the harness (CLAUDE.md files, skills, hooks, vault protocol, memories) from what the last runs showed. Writes an audit, applies on a dotfiles branch, never merges."
disable-model-invocation: true
---

# harness

The harness is everything around the model: the files an agent reads before acting, the limits set on it, the controls that correct it afterwards. The model does not change between sessions; **the harness does, and it is the only lever we hold**. When an agent errs twice the same way, the harness has a defect, not the agent.

You reread the harness in the light of what happened. You do not guess what would be better: you start from what the runs produced, name the defect, fix it where it will be read, and measure so the next pass knows whether it helped.

## Usage
- `/harness` — retrospective pass on the window since the last audit (Monday weekly review, Part 4b)
- `/harness <request>` — a capability or circuit the harness lacks; the request is the evidence, the pass looks for what it contradicts and what would make it go wrong

## The three questions

Ask each defect the three questions; it almost always has one answer, and the answer names the remedy.

1. **Context** — did the agent have the right thing in front of it when it needed it? The remedy is to *move* or *shorten*, rarely to write more: the rule was in a file the agent had not loaded, or drowned in a file too long, or written three times of which one false.
2. **Constraints** — what does the prose forbid that nothing enforces? A rule broken twice despite its prose asks for a control (`hooks/guardrails.sh`, `permissions.deny`, a script that fails), not one more sentence.
3. **Entropy** — what stopped being true? A path that no longer exists, a file named two ways, a rule whose anecdote is fixed, two tables that diverge.

## The pass

1. **Impact of the previous pass.** Open the last audit in `reviews/harness/`; remeasure each applied finding with its command. *Held*, *not held*, *not measurable* opens the audit's table. A *not held* is a finding of this pass, remedy = the fallback written in the audit, or mechanize.
2. **Shape.** `python3 ~/.claude/skills/harness/scripts/forme.py` and `--dups`. A `!` is a finding (pillar context, remedy shorten / move / merge). Thresholds and what they protect: [`writing.md`](writing.md).
3. **Evidence** over the window, with [`evidence.md`](evidence.md): corrections scan, transcripts, weekly reviews, memories. Note each fact with its source before interpreting it.
4. **Diagnosis.** For each piece of evidence, the three questions, then **one** remedy: write, move, shorten, mechanize, fix, merge, remove, repatriate, measure. Where a fact goes: [`placement.md`](placement.md). **A new rule needs two occurrences**, or one that cost a PR or a redo.
5. **Write the audit** in the vault, `reviews/harness/YYYY-MM-DD.md`, **before touching a file**, in the format of [`audit-template.md`](audit-template.md). Every applied finding carries its expected impact: measure, dated baseline, threshold, remeasure date, fallback.
6. **Apply**, on a `harness` branch of `~/Project/dotfiles` (vault edits go on the vault's main), one commit per finding, following [`writing.md`](writing.md). Applies without asking: entropy fixes, moves, shortenings, repatriations. Proposed in the audit, applied by the user: removing a rule, `settings.json`, `hooks/guardrails.sh`.
7. **Verify** — replay the failure: at the turn where the defect happened, would the edited file have been loaded, and is the rule high enough in it to be read? Then `forme.py` under thresholds, `--register <rev>:<path>` at zero for every file cut, and no dead path (`grep -o '~/.claude/[^ )\`]*'` over the harness, each path tested with `test -e`).
8. **Report** in the thread as [`audit-template.md`](audit-template.md) says; the merge of the dotfiles branch waits for the user.

## Rules

- **No finding without evidence collected in the pass.** What you could not open goes in "what I could not verify".
- **You write only under `~/.claude` (via `~/Project/dotfiles`), the vault's `systems/`, `templates/`, `reviews/harness/`, root `CLAUDE.md` and `projects/*/CLAUDE.md`, and the EA memory.** Project code, STATUS/LOG and tickets are the sub-assistants' files.
- **Move sections, cut — do not rewrite sentences.** The register proves each paragraph has a fate.
- **A memory is repatriated in two steps**: the fact enters the versioned file and the memory keeps its content with a `> Canonical version: <path>` first line; it is deleted only after the merge, listed in the report.
