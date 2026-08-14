#!/bin/bash
# Claude Code hook: track per-session state for the tmux claude status bar.
# Reads the hook JSON on stdin, writes one state file per session, then
# forces a tmux status refresh so the bar updates instantly.
set -uo pipefail

DIR="${XDG_RUNTIME_DIR:-/tmp}/claude-tmux-status"
mkdir -p "$DIR"

refresh() {
  command -v tmux >/dev/null 2>&1 || return 0
  tmux list-clients -F '#{client_name}' 2>/dev/null | while read -r c; do
    tmux refresh-client -S -t "$c" 2>/dev/null
  done
}

input=$(cat)
sid=$(jq -r '.session_id // empty' <<<"$input")
event=$(jq -r '.hook_event_name // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
[ -n "$sid" ] || exit 0

file="$DIR/$sid"

if [ "$event" = "SessionEnd" ]; then
  rm -f "$file"
  refresh
  exit 0
fi

case "$event" in
  UserPromptSubmit|PostToolUse) state=working ;;
  PermissionRequest)            state=needs ;;
  Notification)
    # only "blocked on you" notifications go orange; the post-turn
    # "waiting for your input" nudge is just blue-waiting
    msg=$(jq -r '.message // empty' <<<"$input")
    case "$msg" in
      *ermission*|*uestion*) state=needs ;;
      *)                     state=waiting ;;
    esac ;;
  Stop)                         state=waiting ;;
  SessionStart)                 state=idle ;;
  *) exit 0 ;;
esac

pane="${TMUX_PANE:-}"
loc=""
if [ -n "$pane" ]; then
  loc=$(tmux display-message -p -t "$pane" '#S:#W' 2>/dev/null || true)
fi
project=$(basename "${cwd:-unknown}")

# hooks run under a transient wrapper shell; walk up to the real claude process
cpid=""
p=$PPID
for _ in 1 2 3 4 5 6 7 8; do
  [ -r "/proc/$p/comm" ] || break
  if [[ "$(</proc/$p/comm)" == claude* ]]; then cpid=$p; break; fi
  p=$(awk '{print $4}' "/proc/$p/stat" 2>/dev/null) || break
  [ "${p:-1}" -gt 1 ] || break
done

old=""
[ -f "$file" ] && old=$(<"$file")

# an idle nudge must not clear a still-open permission/question dialog
if [ "$event" = Notification ] && [ "$state" = waiting ] && [[ "$old" == needs\|* ]]; then
  state=needs
fi

new="$state|$loc|$project|$cpid|$pane"

if [ "$new" != "$old" ]; then
  printf '%s\n' "$new" >"$file"
  [ -n "$pane" ] && rm -f "$DIR/seed$pane"
  refresh
else
  touch "$file"
fi
exit 0
