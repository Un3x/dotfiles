#!/bin/bash
F=$(jq -r '.tool_input.file_path // empty')
case "$F" in
    */.claude/skills/*|*/CLAUDE.md|*/CLAUDE.local.md|*/mylife_in_a_vault/systems/*.md) ;;
    *) exit 0 ;;
esac

jq -n --arg f "$F" '{hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: ("\($f) is read by agents: load the writing-for-agents skill (and ~/.claude/skills/writing.md) before this edit, unless it is already loaded in this session.")}}'
