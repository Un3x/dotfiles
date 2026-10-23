#!/bin/bash
cd "$1" 2>/dev/null || exit 0
git rev-parse -q --git-dir >/dev/null 2>&1 || exit 0
git fetch -q --prune origin 2>/dev/null
left=()

pushed() { [ -n "$(git -C "$1" branch -r --contains HEAD 2>/dev/null)" ]; }
clean() { [ -z "$(git -C "$1" status --porcelain)" ]; }
busy() {
    local p c
    for p in /proc/[0-9]*; do
        c=$(readlink "$p/cwd" 2>/dev/null) || continue
        [ "$c" = "$1" ] || [[ "$c" == "$1/"* ]] && return 0
    done
    return 1
}

D=.claude/worktrees
if [ -d "$D" ]; then
    while read -r w pid; do
        kill -0 "$pid" 2>/dev/null || git worktree unlock "$w"
    done < <(git worktree list --porcelain | awk '/^worktree /{w=$2} /^locked .*\(pid [0-9]+/{match($0,/pid [0-9]+/); print w, substr($0,RSTART+4,RLENGTH-4)}')
    locked=$(git worktree list --porcelain | awk '/^worktree /{w=$2} /^locked/{print w}')
    for w in "$D"/*/; do
        w=$PWD/${w%/}
        git -C "$w" rev-parse -q --verify HEAD >/dev/null 2>&1 || continue
        if grep -qxF "$w" <<<"$locked"; then left+=("$(basename "$w") (locked)"); continue; fi
        [ -n "$(find "$w" -maxdepth 0 -mmin -30)" ] && continue
        if clean "$w" && pushed "$w" && ! busy "$w"; then
            b=$(git -C "$w" symbolic-ref -q --short HEAD)
            if git worktree remove "$w"; then
                [ "$b" = "worktree-$(basename "$w")" ] && git branch -q -D "$b"
                continue
            fi
        fi
        left+=("$(basename "$w")")
    done
fi

if [ -x bin/remove_worktree.sh ] && [ -d worktrees ] && command -v gh >/dev/null; then
    for w in worktrees/*/; do
        w=$PWD/${w%/}
        n=$(basename "$w")
        b=$(git -C "$w" symbolic-ref -q --short HEAD) || continue
        read -r s oid < <(gh pr list --head "$b" --state all --json state,headRefOid -q '.[0] | "\(.state) \(.headRefOid)"' 2>/dev/null)
        [ "$s" = MERGED ] || [ "$s" = CLOSED ] || continue
        { pushed "$w" || [ "$(git -C "$w" rev-parse HEAD)" = "$oid" ]; } || { left+=("worktrees/$n (PR $s, unpushed)"); continue; }
        if clean "$w" && ! busy "$w" && bin/remove_worktree.sh "$n" >/dev/null 2>&1; then
            continue
        fi
        left+=("worktrees/$n (PR $s)")
    done
fi

git worktree prune
R="$(git rev-parse --absolute-git-dir)/worktree-sweep"
if [ ${#left[@]} -gt 0 ]; then
    echo "worktree-sweep: ${#left[@]} left (unpushed, uncommitted, in use, or locked), worth a look: ${left[*]}" > "$R"
else
    rm -f "$R"
fi
