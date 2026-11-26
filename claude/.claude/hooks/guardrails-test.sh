#!/bin/bash
# Proves guardrails.sh blocks what it should and lets the rest pass: one line per case, a FAIL exits 1.
# Usage: claude/.claude/hooks/guardrails-test.sh   (run after each change to guardrails.sh)
HOOK="$(dirname "$0")/guardrails.sh"
FAILED=0

check() {
  local expected=$1 tool=$2 field=$3 value=$4
  jq -n --arg t "$tool" --arg f "$field" --arg v "$value" '{tool_name: $t, tool_input: {($f): $v}}' | "$HOOK" >/dev/null 2>&1
  local code=$?
  local got=pass
  [ "$code" -eq 2 ] && got=block
  [ "$code" -ne 0 ] && [ "$code" -ne 2 ] && got="error"
  if [ "$got" = "$expected" ]; then
    echo "PASS $expected: $value"
  else
    echo "FAIL expected $expected, got $got (exit $code): $value"
    FAILED=1
  fi
}

bash_block() { check block Bash command "$1"; }
bash_pass() { check pass Bash command "$1"; }

bash_block 'git commit --no-gpg-sign -m x'
bash_block 'git -c commit.gpgsign=false commit -m x'
bash_block 'cd repo && git commit --no-gpg-sign -m x'
bash_pass 'git commit -m "explain --no-gpg-sign"'
bash_pass "git commit -m 'drop commit.gpgsign=false from the docs'"
bash_pass 'git commit --message="say --no-gpg-sign is refused"'
bash_block 'git -c "commit.gpgsign=false" commit -m x'
bash_block 'git commit -m "x" --no-gpg-sign'
bash_block 'git commit -m "a$(git commit --no-gpg-sign -m z)"'
bash_block 'git commit -m "`git commit --no-gpg-sign -m z`"'
bash_pass "git commit -m 'a \$(--no-gpg-sign) in single quotes runs nothing'"

bash_block 'git push --force origin main'
bash_block 'git push -f'
bash_block 'git push origin +main'
bash_pass 'git push --force-with-lease origin feature'
bash_pass 'git push origin feature'

bash_block 'heroku config -a app'
bash_block 'scalingo --app app env'
bash_block 'heroku run env -a app'
bash_pass 'heroku logs -a app'

bash_block 'pgrep -f "codex exec"'
bash_block 'while pgrep -f codex; do sleep 5; done'
bash_block 'pkill -f node'
bash_pass 'pgrep -f "[c]odex exec"'
bash_pass 'pgrep codex'

bash_block 'herdr agent prompt lead "/plan X then /ship-issue X"'
bash_pass 'herdr agent prompt lead "/ship-issue X"'

bash_pass $'cat <<EOF\ngit push --force\nEOF'

check block Edit file_path "$HOME/.claude/hooks/guardrails.sh"
check block Write file_path "$HOME/.claude/settings.json"
check block Edit file_path "$HOME/Project/dotfiles/claude/.claude/settings.json"
check pass Edit file_path "$HOME/.claude/CLAUDE.md"

exit $FAILED
