Delegate a command to the project's coding agent via the tmux "code" window. For sub-assistant sessions running inside a project tmux session (window "assistant" = you, window "code" = shell at the actual repo).

## Usage
- `/delegate /plan API-123` — send /plan to the coding agent
- `/delegate /ship API-123 API-124` — send /ship
- `/delegate <any prompt>` — send an arbitrary instruction

## Why this exists

The coding agent must run with the *repo's* CLAUDE.md and config, which a subagent of this session would not load. Launching `claude` in the code window (already at the repo) gets the right context, keeps interactivity (permission prompts, GPG, /plan questions), and runs on the user's subscription.

## Behavior

1. **Resolve the session**: `SESSION=$(command tmux display-message -p '#S')`. If not inside tmux, stop: tell the user to start the project session first (`systems/start-project-session.sh`).
2. **Compose the prompt**: the command plus the context that emerged this session — corrections, decisions, constraints the user already told you. This is the whole point: the user should not have to repeat themselves to the coding agent. Keep it tight; reference ticket IDs and files, don't paste walls of text.
3. **Check what the code window is running**:
   `command tmux display-message -p -t "$SESSION:code" '#{pane_current_command}'`
   - A shell (`zsh`/`bash`): send a fresh launch — `command tmux send-keys -t "$SESSION:code" -l 'claude "<prompt>"'` then `command tmux send-keys -t "$SESSION:code" Enter`
   - Anything else: an interactive claude is likely already running — send the prompt text alone (`send-keys -l`), then Enter.
   Use `-l` (literal) and single-quote wrapping so the prompt survives; escape embedded quotes.
4. **Confirm to the user**: what was sent and where. Remind them /plan may stop with questions in the code window.
5. **Peek on request**: if the user later asks how it's going, `command tmux capture-pane -p -t "$SESSION:code" | tail -30` — report, don't interfere. Never send keys to a busy agent except a deliberate user-approved answer to its question.

## Boundaries

- You compose and relay; the coding agent codes. Do not start editing repo files yourself because the relay feels slow.
- Nothing secret in the prompt — it lands in shell history and the pane.
