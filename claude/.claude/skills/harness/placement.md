# Where each fact goes

Read at step 4 of the pass, for every memory, correction and new rule. **A fact has one home**, the file that is loaded at the moment it serves; every other place only points to it.

| The fact says… | It goes in | Examples |
| --- | --- | --- |
| how one thing is done, at one step | the skill that does that step — `SKILL.md` if every run reads it, a sibling file if one step reads it | "PR body is ≤6 lines" → `commit/pull-request.md`; "poll the code pane" → `delegate/follow-loop.md` |
| a gesture two skills perform | one skill both call with the Skill tool | `/simplify` from `/ship`; `/review` from `/ship`'s review loop |
| a fact two skills read | a sibling in the skill that owns it; the others link its relative path, one level deep | the one rule → `plan/one-rule.md`, linked by `ship` and `review` |
| a convention valid for any work, any repo | `~/.claude/CLAUDE.md` — and remove as much as you add | prose diet, the coding rungs |
| a convention valid for one repo | that repo's `CLAUDE.md`, or `.claude/rules/*.md` scoped by path | Firefox + Chromium checks for Bangun UI |
| a behaviour a coworker's Claude must follow (a non-coder on the repo) | the repo's `CLAUDE.md`, a project skill under `.claude/skills/`, a PR template, a CI gate — never a copy of a dotfiles skill (user, 2026-09-30: copies help nobody if he is the only user) | Simplifions: commit and PR shape in CLAUDE.md, `new-article`-style contribution skill |
| how a project assistant behaves in the vault | `systems/sub-assistant-protocol.md`, imported by every `projects/*/CLAUDE.md` | scope, STATUS.md updates, check-in line |
| what a control could enforce instead of a sentence | `hooks/guardrails.sh` + `settings.json`, or a `permissions.deny` — **proposed in the report**, applied by the user | `--no-gpg-sign`, PR thread replies, force-push |
| how the user wants to be worked with, across projects | EA memory (`feedback_*`) | "no recurring meetings", "programme = user's voice" |
| a project fact: decision, baseline, partner context | the project's STATUS / LOG / `memory/INDEX.md` in the vault | prod version, partner's constraints |
| a machine quirk | `~/.claude/CLAUDE.md` § machine, or a `reference_*` memory | SSH agent socket, RAM pressure |
| a measured number | the audit that measured it, dated; a skill points to it | lines per SKILL.md, corrections per week |
| a rule about writing the harness itself | `harness/writing.md` — `/harness` is the only role that edits these files | thresholds, "one anecdote per rule" |

Two tie-breakers:

- **Could an agent that never had this session need it?** If yes, a memory is not enough: a subagent reads no memory and a fresh session reads only the index. Almost everything that starts with "when shipping", "when delegating", "when reviewing" is in this case.
- **Is it true on another machine?** If not, it goes in no versioned file: absolute paths, socket names and VM names stay in a memory or a local settings file.
