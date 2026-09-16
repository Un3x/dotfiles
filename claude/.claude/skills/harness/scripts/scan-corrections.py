#!/usr/bin/env python3
"""User messages from the last N days (default 7), across every Claude Code project on this machine,
that look like corrections of an assistant. Seeds the harness pass; most hits are false positives.

    scan-corrections.py [DAYS] [--project SUBSTRING]
"""
import datetime
import glob
import json
import os
import re
import sys

days = int(next((a for a in sys.argv[1:] if a.isdigit()), 7))
only = sys.argv[sys.argv.index("--project") + 1] if "--project" in sys.argv else ""
since = datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=days)
pat = re.compile(r"\b(no|non|don't|dont|never|stop|wrong|not what|pas ça|pas ca|jamais|arrête|arrete|faux|n'est pas|je t'ai dit|i told you|i said|again)\b", re.I)
rows = []
for d in glob.glob(os.path.expanduser("~/.claude/projects/*")):
    proj = os.path.basename(d).replace("-home-unex-", "").replace("Documents-mylife-in-a-vault", "vault").replace("Project-", "")
    if only and only not in proj:
        continue
    for f in glob.glob(d + "/*.jsonl"):
        if datetime.datetime.fromtimestamp(os.path.getmtime(f), datetime.timezone.utc) < since:
            continue
        for line in open(f, errors="ignore"):
            try:
                o = json.loads(line)
            except ValueError:
                continue
            if o.get("type") != "user" or o.get("origin", {}).get("kind") != "human":
                continue
            c = o.get("message", {}).get("content")
            if not isinstance(c, str) or len(c) < 8 or len(c) > 600:
                continue
            ts = o.get("timestamp", "")
            if ts[:10] < since.strftime("%Y-%m-%d"):
                continue
            if pat.search(c):
                rows.append((ts[:16].replace("T", " "), proj, os.path.basename(f)[:8], c.replace("\n", " ")[:180]))
for r in sorted(rows):
    print(f"{r[0]}  {r[1]:<34} {r[2]}  {r[3]}")
print(f"\n{len(rows)} candidate corrections in the last {days} days (manual triage: most are false positives).", file=sys.stderr)
