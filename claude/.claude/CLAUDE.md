# Global Claude Code Instructions

## Showing a file

- To show the user a file, run `~/Documents/mylife_in_a_vault/systems/show-file.sh <path>` rather than pasting a path: a new tab of this session's herdr space, in glow for a file to read, in nvim with `--edit` for a file to edit. A page to look at rather than edit (captures, a mockup, a report) is published as an Artifact instead: a terminal shows no image.

## Servers and secrets

- Never connect to a server (`ssh`, `scp`, remote exec) and never read, decrypt or print a secret (Rails credentials, ansible-vault, `.env` values). Hand the user the command and let them paste back what they choose. Public HTTP checks are fine.

## Commit Conventions

- Commit messages and PR title/body: the `commit` skill, read before every `git commit` and `gh pr create`.
- **NEVER** disable GPG signing (`--no-gpg-sign`). If signing fails, the key is locked: leave the change staged with its message ready, end your message with this line on its own — `GPG locked — run: ! echo | gpg --clearsign >/dev/null, then say go` — and carry on with whatever needs no commit. A subagent hands that line up to the session that spawned it.

## Messages to Thomas

Every message that ends a turn, from any session that talks to Thomas. A subagent reports to its session, which rewrites the report into this shape.

- **A need** is what Thomas must do: decide (❓), run a command (▶️), read or check something (👀), or know that someone else blocks something (⏳). One icon per need, at the end of its line.
- **A topic with no need** (work done, a report that only informs): about one line, the outcome. The rest goes to the subject's line in the cockpit, or to its file.
- **A topic with a need**: the need first, on one line: the question, the command, what to read, or who blocks what. A decision carries the recommended answer on the next line. Then the why, in about five lines. More only when he asks for it.
- **Several topics**: each one written as above under its cockpit subject tag (`[N · name]`, `[new · name]` until it has one), the topics with a need first. One topic: no heading. Topics that did not move stay in the cockpit, their subject lines current.
- **An open need** (a ❓ or a ▶️ Thomas has not answered) is a topic of every message until he answers it or says the command ran: its need line and its recommended answer, without the why. A ❓ that has a recommended answer is filed once as a card on its subject (`file_decision`: today, question, recommended answer, why), and its need line carries the card's number. The session goes on with what does not depend on the answer, then ends its turn. When Thomas answers in the session's own tab, that session files his answer (`answer_decisions`). A question of taste, architecture or strategy is asked in the message, with no card. So is a question from a skill's own template, and a question the session cannot write so that it stands alone.
- **Names**: in prose, a to-do or a subject is named by its words and its project. An app id stays in tool calls, briefs and subject tags.
- **A background result** (a subagent) is a topic of the next message, written for a reader who did not see that work. A brief's result stays with its lead: the lead reports in its own tab, and the subject's line in the cockpit shows where it stands.
- **A skill's own template** (grilling's questions, ship's report) sits inside its topic unchanged; the GPG line stays the very last line.
- **Style**: **wait-what** (`~/.claude/skills/wait-what/SKILL.md`): a little context, ASD-STE100 Simplified Technical English, the words of the project's glossary. Thomas reads it once, with no question back.
- **Language**: English, unless the project's own rule says otherwise. Reviews and PR or ticket comments are written in the **project language** from the start: the `Language:` line of `CLAUDE.local.md` in the repo or of the project's vault `CLAUDE.md`, English when there is none. Commits and issues follow the repo's own language (`commit`, `issue`). A relayed text is quoted in its own language.

## Prose Diet

- Issue comments, handoff notes: a pointer plus the minimum that orients the reader. If it needs a paragraph, question whether it needs to exist.
- Prefer a 5-line diagram over 5 paragraphs when explaining a flow.
- Anything handed to someone (a review, a PR, an issue, a message) is ready to pass on as is. If Thomas has to rewrite it, it failed.
- A number in a rule or a message is a goal, not a cap: comprehension wins (`~/.claude/skills/writing-for-agents/house-rules.md` § Three kinds of number).
- A PR, issue or ticket (GitHub, Linear…) named in a message to the user or in a subagent report comes as a Markdown link, its short tag as the text and its full URL as the target (`[SIM-257](https://linear.app/pole-api/issue/SIM-257)`, `[formulaire-qf#426](https://github.com/etalab/formulaire-qf/pull/426)`), never a bare tag nor a raw URL: herdr makes only the visible part of a wrapped URL clickable.

## Coding Behavior

- Before writing code on an ambiguous task, state the interpretation you're committing to. If two reasonable interpretations exist, ask first.
- If a go-ahead carries no acceptance criterion, state the one you'll verify against in one line before starting.
- Before writing code, stop at the first rung that holds: (1) Does this need to exist at all? (YAGNI) (2) Does the standard library do it? (3) Does a native platform feature cover it? (4) Does an already-installed dependency solve it? (5) Can it be one line? (6) Only then: the minimum that works. The escalation past a rung is itself a complexity opt-in — surface it, don't take it silently.
- Code carries no comments: its names and structure say what it does. Two exceptions: a non-obvious **why** that no name can carry (a constraint from outside the code, a trap it avoids), and a script's header (what it does and how to call it, nothing else).
- Deletion over addition. Boring over clever. Fewest files possible. No abstraction, dependency, or boilerplate that wasn't requested.
- When two implementations are the same size, prefer the one with better edge-case handling.
- Never lazy about: trust-boundary validation, error handling that prevents data loss, security, accessibility, anything explicitly requested. Minimal means less code, not less correct or less readable.
- Any push landing on the default branch without a PR review gets a fresh-eyes review subagent before the done report.
- Splitting work into issues/PRs: vertical slices, one story per PR — the grain is in `~/.claude/skills/slices.md`.

## Contradictions

- When two things acted on disagree (a rule, the plan, a review finding, the ticket, the code, what the user said), that is never normal and never the agent's to settle: stop, quote both sides, ask the user. Never pick a side because it is newer, already approved or easier: rebutting a review finding by citing the plan is picking a side. A claim a test or the code can check is not a contradiction: check it.
- A new rule contradicts no rule in a `CLAUDE.md` or under `~/.claude/skills/`; if it does, the user reconciles both into one wording before anything is committed.
- A subagent does not ask: it leaves that point undone, finishes the rest, and opens its report with `Contradictions:`, both sides quoted.

## Rails

- **Vanilla Rails first.** Before writing or planning Rails code, read `~/.claude/skills/one-rule.md`.

@RTK.md
