#!/bin/bash
# Native tmux menu listing every Claude session with its state; Enter/hotkey
# jumps to that window. Same state files as render.sh (written by update.sh).
# Usage: menu.sh [client_name]   (bound to prefix+a in tmux.conf.local)
set -uo pipefail

DIR="${XDG_RUNTIME_DIR:-/tmp}/claude-tmux-status"
CLIENT="${1:-}"
shopt -s nullglob

sym()  { case "$1" in working) printf '●';; needs) printf '▲';; waiting) printf '◆';; idle) printf '○';; *) printf '?';; esac; }
rank() { case "$1" in working) printf 0;; needs) printf 1;; waiting) printf 2;; idle) printf 4;; *) printf 3;; esac; }
color(){ case "$1" in working) printf 'colour114';; needs) printf 'colour214';; waiting) printf 'colour110';; *) printf 'colour242';; esac; }
label(){ case "$1" in working) printf 'working';; needs) printf 'NEEDS YOU';; waiting) printf 'done, waiting';; idle) printf 'idle';; *) printf '?';; esac; }
age()  { local s=$1; if [ "$s" -lt 60 ]; then printf '%ds' "$s"; elif [ "$s" -lt 3600 ]; then printf '%dm' $((s/60)); else printf '%dh%02d' $((s/3600)) $(((s%3600)/60)); fi; }

now=$(date +%s)
rows=""
for f in "$DIR"/*; do
  IFS='|' read -r state loc project pid pane <"$f" || continue
  [ -n "${loc:-}" ] || continue
  [ -n "${pane:-}" ] && ! tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pane" && continue
  mtime=$(stat -c %Y "$f" 2>/dev/null || echo "$now")
  a=$((now - mtime))
  disp=$state
  [ "$disp" = waiting ] && [ "$a" -gt 300 ] && disp=idle
  rows+="$(rank "$disp") $loc $disp $a"$'\n'
done

args=(-T '#[align=centre] Claude agents ' -x C -y C)
[ -n "$CLIENT" ] && args=(-c "$CLIENT" "${args[@]}")

if [ -z "$rows" ]; then
  tmux display-menu "${args[@]}" '-#[fg=colour242]no claude sessions' '' ''
  exit 0
fi

i=0
while read -r r loc disp a; do
  [ -n "$loc" ] || continue
  i=$((i+1))
  key=""; [ "$i" -le 9 ] && key="$i"
  sess="${loc%%:*}"; win="${loc#*:}"
  text=$(printf '#[fg=%s]%s #[fg=colour250,bold]%-14s#[default,fg=%s]%-14s#[fg=colour242]%s' \
    "$(color "$disp")" "$(sym "$disp")" "$loc" "$(color "$disp")" "$(label "$disp")" "$(age "$a")")
  args+=("$text" "$key" "switch-client -t '$sess' ; select-window -t '$sess:$win'")
done < <(printf '%s' "$rows" | sort -k1,1n -k2,2)

tmux display-menu "${args[@]}"
