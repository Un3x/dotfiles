#!/bin/bash
jq -e '.tool_input | has("title") or has("description")' >/dev/null || exit 0

jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: "This writes an issue title or description: load the issue skill first (draft, review, shown to the user before it posts), unless this exact text already went through it in this session."}}'
