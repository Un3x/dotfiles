# Follow the run

Read at step 5 of `/delegate`. A self-paced `/loop` with the prompt `follow the delegated <command> in the code window`, so the user never has to ask "how is it going". Each tick:

0. Read the user's messages that arrived since the previous tick and act on them before anything else — a decision they gave ("go le merge") is not asked again in the report (Simplifions 2026-09-15: three messages between ticks, the tick re-asked two of them).
1. Read the code pane's state: `grep -l "|$SESSION:code|" "${XDG_RUNTIME_DIR:-/tmp}"/claude-tmux-status/*` → first field of that file is `working` / `needs` / `waiting` / `idle` (written by the tmux status hook). No file → the agent exited; capture the pane and report.
2. `working` → wake again in 3–5 min (`/plan` ≈ 5 min, `/ship` ≈ 5–10 min per issue).
3. `needs` (question or permission) → `capture-pane | tail -40`. If the answer is something this session already settled (a decision, a constraint, the brief's scope) → send it (`send-keys -l` + Enter) and log "answered: …". If it needs the user's judgment (design choice, scope change, GPG, destructive action) → stop the loop and put the question in front of the user with your recommendation.
4. `waiting` (turn finished) → `capture-pane | tail -60`, compare with the brief's done-condition. Done → stop the loop, report the outcome (PR link, plan location, open points). A finished `/challenge` is never chained: read its last line (`CHALLENGE: GO | RESHAPE | DROP`), put the findings and the recommendation in front of the user, and send `/plan` only on their answer; no such line after the turn ends is `blocked`, not a pass. Not done and the next step follows from the brief (e.g. plan posted → `/ship`, "continue with step N") → send it, log it. Otherwise report and stop.
5. Update the project STATUS.md when the outcome changes it (PR shipped, plan waiting on a question).

Caps: at most 3 instructions sent without the user, 2 h of follow per delegation, then stop and report. A tick that only found `working` is a `noop`.

**Peek on request** still works between ticks: `command tmux capture-pane -p -t "$SESSION:code" | tail -30` — report, don't interfere. Outside the loop's answer rule above, never send keys to a busy agent.
