#!/bin/bash
cd "$1" 2>/dev/null || exit 0
D=.claude/worktrees
[ -d "$D" ] || exit 0
git fetch -q origin 2>/dev/null
B=$(git symbolic-ref -q --short refs/remotes/origin/HEAD) || B=origin/main
locked=$(git worktree list --porcelain | awk '/^worktree /{w=$2} /^locked/{print w}')
left=()
for w in "$D"/*/; do
    w=$PWD/${w%/}
    git -C "$w" rev-parse -q --verify HEAD >/dev/null 2>&1 || continue
    if grep -qxF "$w" <<<"$locked"; then left+=("$(basename "$w") (locked)"); continue; fi
    if [ -z "$(git -C "$w" status --porcelain)" ] && git merge-base --is-ancestor "$(git -C "$w" rev-parse HEAD)" "$B"; then
        git worktree remove --force "$w" && continue
    fi
    left+=("$(basename "$w")")
done
git worktree prune
R="$(git rev-parse --absolute-git-dir)/worktree-sweep"
if [ ${#left[@]} -gt 0 ]; then
    echo "worktree-sweep: ${#left[@]} left in $D (not in $B, uncommitted changes, or locked), worth a look: ${left[*]}" > "$R"
else
    rm -f "$R"
fi
