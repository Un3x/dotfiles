---
description: "Send /plan, /ship, or any prompt to the project's coding agent in the tmux \"code\" window. Use when the user asks to delegate, hand off, or send work to the coding agent."
---

Delegate a command to the project's coding agent via the tmux "code" window. For sub-assistant sessions running inside a project tmux session (window "assistant" = you, window "code" = shell at the actual repo).

## Usage
- `/delegate /plan API-123` — send /plan to the coding agent
- `/delegate /ship API-123 API-124` — send /ship
- `/delegate <any prompt>` — send an arbitrary instruction

## Why this exists

The coding agent must run with the *repo's* CLAUDE.md and config, which a subagent of this session would not load. Launching `claude` in the code window (already at the repo) gets the right context, keeps interactivity (permission prompts, GPG, /plan questions), and runs on the user's subscription.

## Behavior

1. **Resolve the session**: `SESSION=$(command tmux display-message -p '#S')`. If not inside tmux, stop: tell the user to start the project session first (`systems/start-project-session.sh`).
2. **Compose the prompt**: the command plus the context that emerged this session — corrections, decisions, constraints the user already told you. This is the whole point: the user should not have to repeat themselves to the coding agent. Keep it tight; reference ticket IDs and files, don't paste walls of text. **One slash command per brief, never "then run /ship"**: the coding agent cannot invoke /plan, /ship or /review on itself (disable-model-invocation) and will fail trying. Chaining is the follow loop's job (step 5): when the first command is done and the done-condition allows it, you send the next one as a fresh user command. **Every brief ends with a done-condition and a stop trigger**: the observable state that means finished (PR green, tests pass, plan posted) and when to halt and report instead of continuing ("stop after the plan", "stop if the fix spreads beyond <scope>").
3. **Check what the code window is running**:
   `command tmux display-message -p -t "$SESSION:code" '#{pane_current_command}'`
   - A shell (`zsh`/`bash`): send a fresh launch — `command tmux send-keys -t "$SESSION:code" -l 'claude "<prompt>"'` then `command tmux send-keys -t "$SESSION:code" Enter`
   - Anything else: an interactive claude is likely already running — send the prompt text alone (`send-keys -l`), then Enter.
   Use `-l` (literal) and single-quote wrapping so the prompt survives; escape embedded quotes.
4. **Confirm to the user**: what was sent and where. Remind them /plan may stop with questions in the code window.
5. **Follow the run** (default, unless the user says "fire and forget"): start a self-paced `/loop` with the prompt `follow the delegated <command> in the code window` so the user never has to ask "how is it going". Each tick:
   1. Read the code pane's state: `grep -l "|$SESSION:code|" "${XDG_RUNTIME_DIR:-/tmp}"/claude-tmux-status/*` → first field of that file is `working` / `needs` / `waiting` / `idle` (written by the tmux status hook). No file → the agent exited; capture the pane and report.
   2. `working` → wake again in 3–5 min (`/plan` ≈ 5 min, `/ship` ≈ 5–10 min per issue).
   3. `needs` (question or permission) → `capture-pane | tail -40`. If the answer is something this session already settled (a decision, a constraint, the brief's scope) → send it (`send-keys -l` + Enter) and log "answered: …". If it needs the user's judgment (design choice, scope change, GPG, destructive action) → stop the loop and put the question in front of the user with your recommendation.
   4. `waiting` (turn finished) → `capture-pane | tail -60`, compare with the brief's done-condition. Done → stop the loop, report the outcome (PR link, plan location, open points). Not done and the next step follows from the brief (e.g. plan posted → `/ship`, "continue with step N") → send it, log it. Otherwise report and stop.
   5. Update the project STATUS.md when the outcome changes it (PR shipped, plan waiting on a question).
   Caps: at most 3 instructions sent without the user, 2 h of follow per delegation, then stop and report. A tick that only found `working` is a `noop`.
6. **Peek on request** still works between ticks: `command tmux capture-pane -p -t "$SESSION:code" | tail -30` — report, don't interfere. Outside the loop's answer rule above, never send keys to a busy agent.

## Boundaries

- You compose and relay; the coding agent codes. Do not start editing repo files yourself because the relay feels slow.
- Answers you send on the user's behalf must be traceable to something the user said or a file they validated; when in doubt, escalate. Say what you sent in the report.
- Nothing secret in the prompt — it lands in shell history and the pane.
