#!/bin/bash
# PreToolUse guardrails. Each pattern below is a rule the prose failed to hold at least once;
# see ~/.claude/skills/harness/SKILL.md for how a rule earns its place here.
# Patterns match a command at the start of a shell statement, so prose that mentions a command
# (a note, a grep) passes, and heredoc bodies are not matched at all.
INPUT=$(cat)
TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name')

block() {
  printf 'BLOCKED by ~/.claude/hooks/guardrails.sh: %s\n' "$1" >&2
  exit 2
}

START='(^|[;&|(`]|\$\() *'

case "$TOOL" in
  Bash)
    CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""' | awk '
      tag != "" { if ($0 == tag) tag = ""; next }
      match($0, /<<-?["'"'"']?[A-Za-z_][A-Za-z0-9_]*/) { tag = substr($0, RSTART, RLENGTH); sub(/^<<-?["'"'"']?/, "", tag) }
      { print }')
    if printf '%s' "$CMD" | grep -qE -- "${START}git\b[^;&|]*(--no-gpg-sign|commit\.gpgsign=false)"; then
      block "commits stay GPG-signed. If signing fails, stop and ask the user."
    fi
    if printf '%s' "$CMD" | grep -qE -- "${START}git +push\b[^;&|]*( --force\b| -f\b| \+[A-Za-z0-9_./-]+)" && ! printf '%s' "$CMD" | grep -q -- '--force-with-lease'; then
      block "force-push only with --force-with-lease, and only on your own branch after autosquash."
    fi
    if printf '%s' "$CMD" | grep -qE -- "${START}gh +pr +(comment|review)\b|${START}gh +api\b[^;&|]*pulls/[^ ]*/(comments|reviews)"; then
      block "assistants never post on PR threads. Put it on the Linear issue or hand the words to the user."
    fi
    if printf '%s' "$CMD" | grep -qE -- "${START}(command +)?tmux +send-keys" && [ "$(printf '%s' "$CMD" | grep -oE '/(plan|ship|review|challenge)\b' | wc -l)" -ge 2 ]; then
      block "one slash command per delegated brief. Chaining is the follow loop's job."
    fi
    ;;
  Edit|Write|MultiEdit)
    FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
    case "$FILE" in
      "$HOME"/.claude/hooks/guardrails.sh|"$HOME"/.claude/settings.json|*/dotfiles/claude/.claude/hooks/guardrails.sh|*/dotfiles/claude/.claude/settings.json)
        block "the guardrails and the global settings.json are edited by the user. Propose the change in your report."
        ;;
    esac
    ;;
esac
exit 0
