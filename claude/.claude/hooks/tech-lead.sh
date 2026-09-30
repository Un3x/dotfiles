#!/bin/bash
# SessionStart hook, user level: a repo whose .claude/tech-lead names a vault project folder is run by
# that project's tech lead. Injects the shared protocol and the project's vault CLAUDE.md, so the session
# and its subagents carry both the repo's rules and the project's role. Imports cannot do this: an @ import
# outside the repo needs an interactive approval and stays raw in headless runs (tested 2026-09-30).
M="$PWD/.claude/tech-lead"
[ -f "$M" ] || exit 0
P=$(head -1 "$M"); P="${P/#\~/$HOME}"
[ -d "$P" ] || { echo "tech-lead: vault project folder not found: $P" >&2; exit 0; }
V=$(cd "$P/../.." && pwd)
echo "# Tech lead session — vault project folder: $P (STATUS.md, LOG.md, memory/ live there; the repo is this directory)"
cat "$V/systems/sub-assistant-protocol.md"
echo
cat "$P/CLAUDE.md"
