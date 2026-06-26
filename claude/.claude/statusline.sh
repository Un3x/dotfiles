#!/usr/bin/env bash
# Claude Code statusline script
# Outputs: model | context% | cost | git-branch

export LC_ALL=C

input=$(cat)

# Prefer jq, fall back to python3
if command -v jq >/dev/null 2>&1; then
  model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')
  cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
  used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
  cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
else
  model=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
m = d.get('model', {})
print(m.get('display_name') or m.get('id') or 'unknown')
")
  cwd=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('workspace', {}).get('current_dir') or d.get('cwd') or '')
")
  used_pct=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
v = d.get('context_window', {}).get('used_percentage')
if v is not None: print(v)
" 2>/dev/null)
  cost=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
v = d.get('cost', {}).get('total_cost_usd')
if v is not None: print(v)
" 2>/dev/null)
fi

parts=()

# Model
[ -n "$model" ] && parts+=("$model")

# Context usage
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  parts+=("ctx:${used_int}%")
fi

# Cost
if [ -n "$cost" ]; then
  cost_fmt=$(printf "\$%.3f" "$cost")
  parts+=("$cost_fmt")
fi

# Git branch — run from the session's cwd
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && parts+=("$branch")
fi

# Join with separator
out=""
for part in "${parts[@]}"; do
  [ -z "$out" ] && out="$part" || out="$out  |  $part"
done

echo "$out"
