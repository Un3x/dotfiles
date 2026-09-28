#!/usr/bin/env python3
"""Measures the shape of harness files, and checks that a split kept every paragraph.

    forme.py [--root DIR]... [--since DATE]   one row per skill, agent or CLAUDE.md, thresholds marked with !
    forme.py --dups [--root DIR]...            paragraphs found in two files
    forme.py --register OLD [--tree DIR]...    paragraphs of OLD (a path, or rev:path, run from that repo) missing from the trees

Default roots: ~/.claude (skills, agents, CLAUDE.md) and the vault (CLAUDE.md, projects/*/CLAUDE.md, systems, templates).
Adapted from numerique-gouv/oots-france .claude/skills/harness-engineer/scripts/forme.py.
"""
import argparse
import glob
import os
import re
import subprocess
import sys
import unicodedata

HOME = os.path.expanduser("~")
DEFAULT_ROOTS = [f"{HOME}/.claude", f"{HOME}/Documents/mylife_in_a_vault"]
THRESHOLDS = {"lines": 100, "description": 400, "guardrails": 5}
DATE = re.compile(r"\b20\d\d-[01]\d-[0-3]\d\b")
PATTERNS = ["skills/*/SKILL.md", "agents/*.md", "CLAUDE.md", "projects/*/CLAUDE.md", "systems/*.md", "templates/*.md"]


def main_files(roots):
    out = []
    for r in roots:
        for pat in PATTERNS:
            out += sorted(glob.glob(os.path.join(r, pat)))
    return [f for f in out if not os.path.islink(f) or os.path.exists(f)]


def siblings(f):
    if not f.endswith("/SKILL.md"):
        return []
    d = f[: -len("/SKILL.md")]
    return sorted(p for p in glob.glob(f"{d}/**/*.md", recursive=True) if p != f)


def read(source):
    if ":" in source and not os.path.exists(source):
        rev, path = source.split(":", 1)
        return subprocess.run(["git", "show", f"{rev}:{path}"], capture_output=True, text=True, check=True).stdout
    with open(source, encoding="utf-8") as h:
        return h.read()


def split_frontmatter(text):
    if not text.startswith("---\n"):
        return "", text
    end = text.index("\n---", 4)
    return text[4:end], text[end + 4 :]


def description(fm):
    m = re.search(r"^description:\s*(.*?)(?=^\w[\w-]*:|\Z)", fm, re.S | re.M)
    return re.sub(r"\s+", " ", m.group(1)).strip().strip('"') if m else ""


def paragraphs(text):
    """Prose paragraphs of at least 60 characters; code blocks and tables are left out."""
    out, block, code = [], [], False
    for line in text.splitlines():
        if line.startswith("```"):
            code = not code
            continue
        if code or line.startswith("|"):
            continue
        if line.strip():
            block.append(line.strip())
        elif block:
            out.append(" ".join(block))
            block = []
    if block:
        out.append(" ".join(block))
    return [p for p in out if len(p) >= 60 and not p.startswith("#")]


def key(p):
    p = unicodedata.normalize("NFKD", p).encode("ascii", "ignore").decode()
    p = re.sub(r"^[-*>\d.\s]+", "", p)
    p = re.sub(r"[^a-z0-9]+", " ", p.lower()).strip()
    return p[:40]


def commits(f, since):
    r = subprocess.run(["git", "-C", os.path.dirname(os.path.realpath(f)), "log", "--oneline", f"--since={since}", "--", os.path.realpath(f)], capture_output=True, text=True)
    return len(r.stdout.splitlines())


def guardrails(body):
    m = re.search(r"^## (Guardrails|Garde-fous|Boundaries|Rules)\s*$(.*?)(?=^## |\Z)", body, re.S | re.M)
    return len(re.findall(r"^\s*[-*] ", m.group(1), re.M)) if m else 0


def table(roots, since):
    print(f"{'file':60} {'lines':>6} {'descr':>6} {'rules':>6} {'dates':>5} {'commits':>7}  siblings (lines, toc missing if > 100)")
    total_desc = 0
    for f in main_files(roots):
        text = read(f)
        fm, body = split_frontmatter(text)
        n = text.count("\n")
        d = 0 if re.search(r"^disable-model-invocation:\s*true", fm, re.M) else len(description(fm))
        total_desc += d
        g = guardrails(body)
        dates = len(DATE.findall(body))
        mark = lambda v, s: f"{v}!" if v > s else f"{v} "
        sib = []
        for p in siblings(f):
            t = read(p)
            nl = t.count("\n")
            toc = nl <= 100 or bool(re.search(r"^## (Contents|Contenu|Sommaire)", t, re.M))
            sib.append(f"{os.path.basename(p)} ({nl}{'' if toc else ', no toc!'})")
        short = f.replace(HOME, "~")
        print(f"{short:60} {mark(n, THRESHOLDS['lines']):>6} {mark(d, THRESHOLDS['description']):>6} {mark(g, THRESHOLDS['guardrails']):>6} {dates:>5} {commits(f, since):>7}  {', '.join(sib)}")
    print(f"\ndescriptions loaded every turn: {total_desc} characters")


def dups(roots):
    seen = {}
    files = main_files(roots)
    files += [p for f in files for p in siblings(f)]
    for f in files:
        for p in paragraphs(split_frontmatter(read(f))[1]):
            seen.setdefault(key(p), []).append((f, p))
    n = copies = 0
    for k, occ in seen.items():
        fs = {f for f, _ in occ}
        if len(fs) > 1:
            n += 1
            copies += len(occ)
            print(f"« {occ[0][1][:90]}… »")
            for f in sorted(fs):
                print(f"    {f.replace(HOME, '~')}")
    print(f"\n{n} paragraphs present in two files ({copies} copies)", file=sys.stderr)


def register(old, trees):
    keys = {}
    for tree in trees:
        for f in glob.glob(f"{tree}/**/*.md", recursive=True):
            for p in paragraphs(split_frontmatter(read(f))[1]):
                keys.setdefault(key(p), []).append(f)
    missing = 0
    for p in paragraphs(split_frontmatter(read(old))[1]):
        if key(p) not in keys:
            missing += 1
            print(f"- {p[:120]}")
    print(f"\n{missing} paragraphs of {old} without an equivalent in {', '.join(trees)} — each one must be justified in the commit", file=sys.stderr)
    return missing


if __name__ == "__main__":
    a = argparse.ArgumentParser()
    a.add_argument("--root", action="append")
    a.add_argument("--since", default="30 days ago")
    a.add_argument("--dups", action="store_true")
    a.add_argument("--register")
    a.add_argument("--tree", action="append")
    args = a.parse_args()
    roots = args.root or DEFAULT_ROOTS
    if args.dups:
        dups(roots)
    elif args.register:
        sys.exit(1 if register(args.register, args.tree or roots) else 0)
    else:
        table(roots, args.since)
