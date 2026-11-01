#!/bin/bash
# SessionStart hook, user level: the one place a session gets its role. The vault root gets the EA role
# (systems/ea-role.md); a vault project folder gets the shared protocol; a repo whose .claude/project-lead
# names a vault project folder gets the protocol and that project's vault CLAUDE.md. Subagents never get
# this output, only the repo's CLAUDE.md (tested 2026-11-01). Imports cannot do this: an @ import outside
# the repo needs an interactive approval and stays raw in headless runs (tested 2026-09-30).
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
if [ ! -f "$M" ]; then
    case "$PWD" in
        "$VAULT") cat "$VAULT/systems/ea-role.md" ;;
        "$VAULT"/projects/personal|"$VAULT"/projects/personal/*) ;;
        "$VAULT"/projects/*) cat "$VAULT/systems/sub-assistant-protocol.md" ;;
    esac
    exit 0
fi
P=$(head -1 "$M"); P="${P/#\~/$HOME}"
[ -d "$P" ] || { echo "project-lead: vault project folder not found: $P" >&2; exit 0; }
V=$(cd "$P/../.." && pwd)
echo "# Project lead session — vault project folder: $P (STATUS.md, LOG.md and memory/MEMORY.md live there, read MEMORY.md if it did not load; the repo is this directory)"
cat "$V/systems/sub-assistant-protocol.md"
echo
cat "$P/CLAUDE.md"
S="$(git rev-parse --absolute-git-dir 2>/dev/null)/worktree-sweep"
[ -f "$S" ] && { echo; cat "$S"; }
setsid "$(dirname "$(readlink -f "$0")")/worktree-sweep.sh" "$PWD" </dev/null >/dev/null 2>&1 &
