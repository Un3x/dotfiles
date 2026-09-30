# Where evidence comes from

Read at step 3. **Nothing without evidence.** A recommendation that cites no session, PR, review file or ticket is an opinion, and you keep it to yourself.

## The window

Since the last audit (`ls ~/Documents/mylife_in_a_vault/reviews/harness/*.md | tail -1`), else seven days, else what you are given. A session opened before the window but still active inside it counts.

```sh
find ~/.claude/projects -maxdepth 2 -name '*.jsonl' -newermt "$(date -d '7 days ago' +%F)" -printf '%TY-%Tm-%Td %8s %h/%f\n' | sort
```

## Transcripts

A session transcript is `~/.claude/projects/<slug>/<session>.jsonl`; its subagents are in `<session>/subagents/agent-<id>.jsonl`. Extract with `jq`; your context carries only the evidence.

```sh
F=~/.claude/projects/<slug>/<session>.jsonl

# What the user typed: corrections live here and nowhere else
jq -r 'select(.type=="user" and (.message.content|type)=="string")
       | "\(.timestamp[0:16]) \(.message.content|gsub("\n";" ")|.[0:120])"' "$F"

# Guardrail blocks and other tool errors, and how many times in a row
jq -r 'select(.type=="user") | .message.content
       | if type=="array" then .[] | select(.type=="tool_result" and .is_error==true)
         | (.content|tostring|.[0:100]) else empty end' "$F"
```

`scripts/scan-corrections.py [DAYS] [--project SUBSTRING]` runs the first query over every project and keeps the lines that look like a correction. Triage by hand: most hits are false positives.

Model routing data (decided 2026-09-30): the `Model:` line of review reports and the model of the fresh-eyes subagent in `.notes/*/plan.md`, against the round count and the asked verdict, say whether the smaller model held.

What you look for, by yield:

1. **A user correction** — "no", "never", "I told you", an instruction reformulated twice. The strongest evidence: someone paid to say what the harness should have said. Read the two turns before it to know what the agent had in front of it.
2. **A question asked whose answer was written** — in CLAUDE.md, in STATUS.md, in the ticket. The reading is not at the right point of the sequence.
3. **A tool error replayed identically** three times: the quirk is known, and its workaround was not where the agent would have read it.
4. **A guardrail block** — the hook fired, so the prose had already failed once more; count them per rule.

## The vault

- `reviews/weekly/*.md` § Part 4b: the corrections already triaged on Mondays and where their rule went.
- `projects/*/STATUS.md` and `LOG.md`: an episode that cost a PR or a redo.
- `~/.claude/projects/-home-unex-Documents-mylife-in-a-vault/memory/`: a `feedback_*` memory is a rule that may belong in a versioned file (placement.md); a memory citing a path checks that the path still exists.
