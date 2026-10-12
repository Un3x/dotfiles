#!/bin/bash
# SessionStart hook, user level: a repo whose .claude/project-lead names a vault project folder is run by
# that project's project lead. Injects the shared protocol and the project's vault CLAUDE.md, so the session
# and its subagents carry both the repo's rules and the project's role. Imports cannot do this: an @ import
# outside the repo needs an interactive approval and stays raw in headless runs (tested 2026-09-30).
M="$PWD/.claude/project-lead"
VAULT="$HOME/Documents/mylife_in_a_vault"
case "$HERDR_PANE_ID" in
    *:p1)
        if [ -f "$M" ]; then L="project manager"
        elif [ "$PWD" = "$VAULT" ]; then L="Kyna"
        else case "$PWD" in "$VAULT"/projects/*) L="assistant" ;; esac
        fi
        if [ -n "$L" ]; then
            "${HERDR_BIN_PATH:-herdr}" pane rename "$HERDR_PANE_ID" "$L" >/dev/null 2>&1
            "${HERDR_BIN_PATH:-herdr}" tab rename "$HERDR_TAB_ID" "$L" >/dev/null 2>&1
        fi
        ;;
esac
[ -f "$M" ] || exit 0
P=$(head -1 "$M"); P="${P/#\~/$HOME}"
[ -d "$P" ] || { echo "project-lead: vault project folder not found: $P" >&2; exit 0; }
V=$(cd "$P/../.." && pwd)
echo "# Project lead session — vault project folder: $P (STATUS.md, LOG.md, memory/ live there; the repo is this directory)"
cat "$V/systems/sub-assistant-protocol.md"
echo
cat "$P/CLAUDE.md"
S="$(git rev-parse --absolute-git-dir 2>/dev/null)/worktree-sweep"
[ -f "$S" ] && { echo; cat "$S"; }
setsid "$(dirname "$(readlink -f "$0")")/worktree-sweep.sh" "$PWD" </dev/null >/dev/null 2>&1 &
