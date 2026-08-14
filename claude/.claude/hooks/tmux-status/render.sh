#!/bin/bash
# Renders the claude sessions status bar for tmux status-format[1].
# Grouped per tmux session: sess:●win|▲win — ● working, ▲ needs input,
# ◆ done/waiting, ○ idle, ? unknown.
set -uo pipefail

DIR="${XDG_RUNTIME_DIR:-/tmp}/claude-tmux-status"
[ -d "$DIR" ] || exit 0
shopt -s nullglob

now=$(date +%s)
panes=$(tmux list-panes -a -F '#{pane_id}' 2>/dev/null || true)

color() {
  case "$1" in
    working) printf '#[fg=colour114]' ;;
    needs)   printf '#[fg=colour214,bold]' ;;
    waiting) printf '#[fg=colour110]' ;;
    *)       printf '#[fg=colour242]' ;;
  esac
}
sym() {
  case "$1" in
    working) printf '●' ;;
    needs)   printf '▲' ;;
    waiting) printf '◆' ;;
    idle)    printf '○' ;;
    *)       printf '?' ;;
  esac
}
rank() {
  case "$1" in
    working) printf 0 ;;
    needs)   printf 1 ;;
    waiting) printf 2 ;;
    idle)    printf 4 ;;
    *)       printf 3 ;;
  esac
}

declare -A groups
for f in "$DIR"/*; do
  IFS='|' read -r state loc project pid pane <"$f" || true
  # prune: tmux pane gone, or owning claude process dead (comm check guards pid reuse)
  if [ -n "${pane:-}" ] && ! grep -qxF "$pane" <<<"$panes"; then rm -f "$f"; continue; fi
  if [ -n "${pid:-}" ] && [[ "$(cat "/proc/$pid/comm" 2>/dev/null)" != claude* ]]; then rm -f "$f"; continue; fi

  mtime=$(stat -c %Y "$f" 2>/dev/null || echo "$now")
  age=$((now - mtime))
  disp=$state
  # a finished turn left unattended for 5 min fades to idle
  [ "$disp" = waiting ] && [ "$age" -gt 300 ] && disp=idle

  if [ -n "${loc:-}" ]; then
    sess="${loc%%:*}"
    win="${loc#*:}"
  else
    sess="${project:-?}"
    win="?"
  fi
  groups[$sess]+="${win}"$'\t'"${disp}"$'\n'
done

if [ ${#groups[@]} -eq 0 ]; then
  printf '#[fg=colour242] no claude sessions#[default]'
  exit 0
fi

out=" "
while IFS= read -r sess; do
  nwins=$(printf '%s' "${groups[$sess]}" | grep -c .)
  if [ "$nwins" -eq 1 ]; then
    # single window: just the symbol prefixing the session name
    IFS=$'\t' read -r win disp < <(printf '%s' "${groups[$sess]}")
    out+="$(color "$disp")$(sym "$disp")#[fg=colour250,bold]${sess}#[default]   "
    continue
  fi
  segs=""
  while IFS=$'\t' read -r win disp; do
    [ -n "$win" ] || continue
    [ -n "$segs" ] && segs+="#[fg=colour240]|"
    segs+="$(color "$disp")$(sym "$disp")${win}#[default]"
  done < <(printf '%s' "${groups[$sess]}" | sort)
  out+="#[fg=colour250,bold]${sess}#[default]:${segs}   "
done < <(
  # sessions ordered by their most-active window: working, needs, waiting, unknown, idle
  for s in "${!groups[@]}"; do
    best=9
    while IFS=$'\t' read -r w d; do
      [ -n "$w" ] || continue
      r=$(rank "$d")
      [ "$r" -lt "$best" ] && best=$r
    done <<<"${groups[$s]}"
    printf '%d %s\n' "$best" "$s"
  done | sort -k1,1n -k2,2 | cut -d' ' -f2-
)
printf '%s' "$out"
