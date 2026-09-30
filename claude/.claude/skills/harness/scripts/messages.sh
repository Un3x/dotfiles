#!/bin/bash
# Commit and PR message shape over the last N days (default 60), author Thomas, the repos below.
# Columns: commits, subjects over 72 chars, type-prefixed subjects, trailers, mean body lines.
DAYS=${1:-60}
for r in ~/Project/creche/bangun ~/Project/api-entreprise/simplifions ~/Project/api-entreprise/apistration; do
  git -C "$r" log --all --no-merges --author=Thomas --since="$DAYS.days" --format='%H' | while read -r h; do
    subj=$(git -C "$r" log -1 --format=%s "$h"); body=$(git -C "$r" log -1 --format=%b "$h")
    over=$(( ${#subj} > 72 )); pre=0; tr=0
    printf '%s' "$subj" | grep -qE '^(feat|fix|chore|refactor|style|docs|build|test|perf|ci)(\([^)]*\))?!?:' && pre=1
    printf '%s' "$body" | grep -qE '^(Co-Authored-By|Claude-Session)' && tr=1
    echo "$(basename "$r") $over $pre $tr $(printf '%s' "$body" | grep -cvE '^\s*$')"
  done
done | awk '{c[$1]++; o[$1]+=$2; p[$1]+=$3; t[$1]+=$4; b[$1]+=$5}
END{printf "%-12s %8s %6s %7s %8s %9s\n","repo","commits",">72ch","prefix","trailer","body/avg"; for(k in c)printf "%-12s %8d %6d %7d %8d %9.1f\n",k,c[k],o[k],p[k],t[k],b[k]/c[k]}'
echo
echo "PR bodies (author Un3x, merged in the window): lines / with headers / with Closes"
for R in Un3x/bangun datagouv/simplifions datagouv/apistration; do
  gh pr list -R "$R" --author Un3x --state merged --limit 60 --json body,mergedAt 2>/dev/null | python3 -c "
import sys,json,re,datetime
since=(datetime.date.today()-datetime.timedelta(days=$DAYS)).isoformat()
d=[p['body'] or '' for p in json.load(sys.stdin) if p['mergedAt']>since]
L=[len([l for l in b.split('\n') if l.strip()]) for b in d]
print('$R: PRs %d, lines median %s max %s, >6 lines %d, headers %d, Closes %d'%(len(d),sorted(L)[len(L)//2] if L else 0,max(L or [0]),sum(1 for x in L if x>6),sum(1 for b in d if re.search(r'^#+ ',b,re.M)),sum(1 for b in d if 'Closes' in b)))"
done
