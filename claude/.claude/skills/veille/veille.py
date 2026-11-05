#!/usr/bin/env python3
# Fetch the veille sources since the last pass (72 h at most), print one merged line per story,
# the advisories that hit our lockfiles, and IT-Connect for « Pas si frais ».
# Usage: python3 veille.py [--dir VEILLE_DIR] [--hours N]

import argparse
import concurrent.futures
import datetime as dt
import email.utils
import json
import os
import re
import shutil
import subprocess
import sys
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

PROJECTS = [
    "~/Project/creche/bangun",
    "~/Project/api-entreprise/formulaire-qf",
    "~/Project/api-entreprise/simplifions",
    "~/Project/api-entreprise/relais",
    "~/Project/api-entreprise/voie_rapide",
    "~/Project/api-entreprise/very_ansible",
    "~/Project/lesensgiratoire",
    "~/Project/yspassequoi",
]
VEILLE_DIR = "~/Documents/mylife_in_a_vault/projects/audit/veille"
MAX_HOURS = 72

HN_QUERIES = [
    "claude", "anthropic", "cursor", "codex", "copilot", "openai", "llm", "agents", "mcp", "vibe coding",
    "cve", "vulnerability", "exploit", "supply chain", "malware", "npm", "rubygems",
    "rails", "ruby", "php", "laravel", "symfony",
]
BSKY_QUERIES = [
    "claude code", "cursor ai", "openai codex", "CVE rails", "CVE php", "CVE ruby", "rubygems",
    "ruby on rails", "php", "supply chain attack", "faille sécurité", "développeur IA",
]
BSKY_MIN_ENGAGEMENT = 5
BSKY_BOTS = ["betterhn50.e-work.xyz", "hn100.atproto.rocks"]
FEEDS = {
    "php.net": "https://www.php.net/feed.atom",
    "CERT-FR": "https://www.cert.ssi.gouv.fr/feed/",
    "Claude Code": "https://github.com/anthropics/claude-code/releases.atom",
    "Cursor": "https://cursor.com/changelog/rss.xml",
    "Rails": "https://github.com/rails/rails/releases.atom",
    "OpenAI": "https://openai.com/news/rss.xml",
    "lobste.rs": "https://lobste.rs/rss",
    "Martin Fowler": "https://martinfowler.com/feed.atom",
    "Simon Willison": "https://simonwillison.net/atom/everything/",
}
ITCONNECT = "https://www.it-connect.fr/feed/"
ANTHROPIC_SITEMAP = "https://www.anthropic.com/sitemap.xml"
KEV = "https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json"
GHSA_ECOSYSTEMS = {"Gemfile.lock": "rubygems", "composer.lock": "composer", "package-lock.json": "npm", "yarn.lock": "npm"}
UNREVIEWED_MARKERS = {"rubygems": r"\bgem\b|\bruby\b|\brails\b", "composer": r"\bphp\b|composer|packagist", "npm": r"\bnpm\b|node\.?js"}
ALIASES = {"ruby on rails": "rails", "node.js": "node"}

UA = {"User-Agent": "veille/1.0 (+stdlib urllib)"}
warnings = []
github = {"requests": 0, "gh": bool(shutil.which("gh"))}


def gh_api(url):
    path = url.removeprefix("https://api.github.com/")
    r = subprocess.run(["gh", "api", "--include", "-H", "Accept: application/vnd.github+json", path],
                       capture_output=True, timeout=60)
    if r.returncode != 0:
        raise RuntimeError(r.stderr.decode(errors="replace").strip()[:200])
    head, _, body = r.stdout.replace(b"\r\n", b"\n").partition(b"\n\n")
    link = re.search(rb"^link: (.*)$", head, re.I | re.M)
    return body, {"Link": link.group(1).decode() if link else ""}


def fetch(url, accept=None):
    if url.startswith("https://api.github.com/"):
        github["requests"] += 1
        if github["gh"]:
            try:
                return gh_api(url)
            except (OSError, RuntimeError, subprocess.TimeoutExpired) as e:
                github["gh"] = False
                warnings.append(f"gh api en échec ({e}), appels GitHub sans authentification (60 par heure)")
    headers = dict(UA)
    if accept:
        headers["Accept"] = accept
    with urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=25) as r:
        return r.read(), r.headers


def get(url):
    return fetch(url)[0]


def get_json(url):
    return json.loads(fetch(url, "application/json")[0])


def parse_time(s):
    s = (s or "").strip()
    if not s:
        return None
    try:
        t = dt.datetime.fromisoformat(s.replace("Z", "+00:00"))
    except ValueError:
        try:
            t = email.utils.parsedate_to_datetime(s)
        except (TypeError, ValueError):
            return None
    return t if t.tzinfo else t.replace(tzinfo=dt.timezone.utc)


def item(source, title, links, when):
    return {"source": source, "title": " ".join((title or "").split())[:220], "links": [l for l in links if l], "time": when}


def local(tag):
    return tag.rsplit("}", 1)[-1]


def parse_feed(data):
    root = ET.fromstring(data)
    out = []
    for el in root.iter():
        if local(el.tag) not in ("item", "entry"):
            continue
        fields = {}
        link = None
        for c in el:
            name = local(c.tag)
            if name == "link":
                link = link or c.get("href") or (c.text or "").strip()
            elif name not in fields:
                fields[name] = (c.text or "").strip()
        when = parse_time(fields.get("published") or fields.get("pubDate") or fields.get("updated") or fields.get("date"))
        out.append((fields.get("title", ""), link, when))
    return out


def feed_source(name, url, since):
    return [item(name, t if len(t) > 25 or name.lower() in t.lower() else f"{name} {t}", [l], w)
            for t, l, w in parse_feed(get(url)) if w and w >= since]


def hn_query(q, since):
    u = "https://hn.algolia.com/api/v1/search_by_date?" + urllib.parse.urlencode(
        {"tags": "story", "query": q, "restrictSearchableAttributes": "title",
         "numericFilters": f"created_at_i>{int(since.timestamp())}", "hitsPerPage": 200})
    return [item("HN", h.get("title"), [h.get("url"), f"https://news.ycombinator.com/item?id={h['objectID']}"],
                 dt.datetime.fromtimestamp(h["created_at_i"], dt.timezone.utc)) for h in get_json(u)["hits"]]


def hn(since):
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as pool:
        return [i for hits in pool.map(lambda q: hn_query(q, since), HN_QUERIES) for i in hits]


def bsky_links(post):
    rec = post["record"]
    links = []
    ext = (rec.get("embed") or {}).get("external") or {}
    links.append(ext.get("uri"))
    for f in rec.get("facets") or []:
        for feat in f.get("features") or []:
            links.append(feat.get("uri"))
    return ext.get("title"), links


def bsky_url(post):
    return "https://bsky.app/profile/%s/post/%s" % (post["author"]["handle"], post["uri"].rsplit("/", 1)[-1])


def bsky_bots(since):
    out = []
    for actor in BSKY_BOTS:
        cursor = None
        for _ in range(10):
            params = {"actor": actor, "limit": 100, "filter": "posts_no_replies", **({"cursor": cursor} if cursor else {})}
            d = get_json("https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?" + urllib.parse.urlencode(params))
            old = False
            for f in d.get("feed", []):
                p = f["post"]
                when = parse_time(p["record"].get("createdAt"))
                if not when or when < since:
                    old = True
                    continue
                title, links = bsky_links(p)
                text = p["record"].get("text", "").split("\n")[0]
                out.append(item("Bluesky " + actor.split(".")[0], title or text, links + [bsky_url(p)], when))
            cursor = d.get("cursor")
            if old or not cursor:
                break
    return out


def bsky_search(since):
    out = []
    for q in BSKY_QUERIES:
        params = {"q": q, "sort": "top", "limit": 100, "since": since.strftime("%Y-%m-%dT%H:%M:%SZ")}
        d = get_json("https://api.bsky.app/xrpc/app.bsky.feed.searchPosts?" + urllib.parse.urlencode(params))
        for p in d.get("posts", []):
            if (p.get("likeCount") or 0) + (p.get("repostCount") or 0) < BSKY_MIN_ENGAGEMENT:
                continue
            title, links = bsky_links(p)
            text = p["record"].get("text", "")
            out.append(item("Bluesky search", title or text, [l for l in links if l] + [bsky_url(p)], parse_time(p["record"].get("createdAt"))))
    return out


def anthropic(since):
    root = ET.fromstring(get(ANTHROPIC_SITEMAP))
    out = []
    for u in root:
        f = {local(c.tag): (c.text or "").strip() for c in u}
        when = parse_time(f.get("lastmod"))
        if when and when >= since:
            slug = f["loc"].rstrip("/").rsplit("/", 1)[-1].replace("-", " ")
            out.append(item("Anthropic", f"{slug} (titre tiré de l'URL, page modifiée)", [f["loc"]], when))
    return out


def norm(url):
    p = urllib.parse.urlsplit(url.strip())
    host = p.netloc.lower().removeprefix("www.")
    query = "&".join(kv for kv in p.query.split("&") if kv and not kv.startswith("utm_"))
    return f"{host}{p.path.rstrip('/')}" + (f"?{query}" if query else "")


def merge(items):
    stories, index = [], {}
    for it in items:
        if not it["time"] or not it["title"]:
            continue
        keys = {norm(l) for l in it["links"]} | {"t:" + re.sub(r"\W+", "", it["title"].lower())}
        hit = next((index[k] for k in keys if k in index), None)
        if hit is None:
            hit = {"title": it["title"], "sources": set(), "links": [], "first": it["time"], "last": it["time"]}
            stories.append(hit)
        hit["sources"].add(it["source"])
        hit["first"], hit["last"] = min(hit["first"], it["time"]), max(hit["last"], it["time"])
        for l in it["links"]:
            if norm(l) not in {norm(x) for x in hit["links"]}:
                hit["links"].append(l)
        for k in keys:
            index[k] = hit
    return sorted(stories, key=lambda s: s["first"], reverse=True)


def age(t, now):
    h = (now - t).total_seconds() / 3600
    return f"{h:.0f}h" if h >= 1 else f"{h * 60:.0f}min"


def read_lockfile(path):
    name = os.path.basename(path)
    with open(path, encoding="utf-8", errors="replace") as f:
        text = f.read()
    pkgs = {}
    if name == "Gemfile.lock":
        for n, v in re.findall(r"^    ([A-Za-z0-9_.-]+) \(([^)]+)\)$", text, re.M):
            pkgs[n.lower()] = v.split("-")[0]
        m = re.search(r"^RUBY VERSION\s+ruby (\S+)", text, re.M)
        if m:
            pkgs["ruby"] = m.group(1).split("p")[0]
    elif name == "composer.lock":
        for p in json.loads(text).get("packages", []) + json.loads(text).get("packages-dev", []):
            pkgs[p["name"].lower()] = p["version"].lstrip("v")
    elif name == "package-lock.json":
        for k, v in json.loads(text).get("packages", {}).items():
            if k and "version" in v:
                pkgs[k.rsplit("node_modules/", 1)[-1].lower()] = v["version"]
    elif name == "yarn.lock":
        for spec, v in re.findall(r'^"?((?:@[^@\s"]+/)?[^@\s"]+)@[^\n]*:\n  version "?([^"\n]+)"?', text, re.M):
            pkgs[spec.lower()] = v
    return pkgs


def scan_projects():
    found, notes = [], []
    for p in PROJECTS:
        root = os.path.expanduser(p)
        if not os.path.isdir(root):
            notes.append(f"absent, ignoré : {p}")
            continue
        repo = os.path.basename(root)
        for d, dirs, files in os.walk(root):
            dirs[:] = [x for x in dirs if not x.startswith(".") and x not in ("node_modules", "vendor", "tmp", "log")]
            if os.path.relpath(d, root).count(os.sep) >= 1:
                dirs[:] = []
            for f in files:
                if f in GHSA_ECOSYSTEMS:
                    lf = os.path.join(d, f)
                    try:
                        found.append((repo, os.path.relpath(lf, root), GHSA_ECOSYSTEMS[f], read_lockfile(lf)))
                    except (OSError, ValueError) as e:
                        notes.append(f"lockfile illisible {lf} : {e}")
    return found, notes


def vkey(v):
    return [(0, int(x)) if x.isdigit() else (-1, x) for x in re.split(r"[.+-]", v.strip().lstrip("v")) if x]


def in_range(version, rng):
    ops = {"<": lambda a, b: a < b, "<=": lambda a, b: a <= b, ">": lambda a, b: a > b, ">=": lambda a, b: a >= b, "=": lambda a, b: a == b}
    for cond in (rng or "").split(","):
        m = re.match(r"\s*(<=|>=|<|>|=)?\s*(\S+)", cond)
        if not m:
            return False
        if not ops[m.group(1) or "="](vkey(version), vkey(m.group(2))):
            return False
    return True


def ghsa(since, params):
    url = "https://api.github.com/advisories?" + urllib.parse.urlencode(
        {**params, "published": f">={since.strftime('%Y-%m-%d')}", "per_page": 100})
    out = []
    for _ in range(10):
        body, headers = fetch(url, "application/vnd.github+json")
        out += json.loads(body)
        nxt = re.search(r'<([^>]+)>;\s*rel="next"', headers.get("Link") or "")
        if not nxt:
            break
        url = nxt.group(1)
    return out


def label(a):
    return f"{a['ghsa_id']} {a.get('cve_id') or ''} [{a.get('severity')}]"


def advisories(since, locks):
    hits, listed = [], []
    for eco in sorted(set(GHSA_ECOSYSTEMS.values())):
        for a in ghsa(since, {"ecosystem": eco}):
            listed.append(item("GHSA", f"{label(a)} {a.get('summary')}", [a.get("html_url")], parse_time(a.get("published_at"))))
            for v in a.get("vulnerabilities") or []:
                pkg = (v.get("package") or {}).get("name", "").lower()
                rng = v.get("vulnerable_version_range")
                repos = [f"{r}/{lf} ({p[pkg]})" for r, lf, e, p in locks if e == eco and pkg in p and in_range(p[pkg], rng)]
                if repos:
                    hits.append(f"{label(a)} {pkg} {rng} (corrigé : {v.get('first_patched_version') or 'aucun'}) → {', '.join(repos)} | {a.get('html_url')}")
    for a in ghsa(since, {"type": "unreviewed"}):
        raw = f"{a.get('summary') or ''} {a.get('description') or ''}".lower()
        text = re.sub(r"\b(action|active) (\w+)", r"\1\2", raw.replace("ruby on rails", "rails").replace("action dispatch", "actionpack"))
        found = []
        for eco, marker in UNREVIEWED_MARKERS.items():
            if not re.search(marker, raw):
                continue
            for pkg in sorted({n for _, _, e, p in locks if e == eco for n in p if len(n) >= 4}):
                if not re.search(rf"(?<![\w/-]){re.escape(pkg)}(?![\w/-])", text):
                    continue
                fixed = re.search(rf"{re.escape(pkg)}[^.]*?\b(?:before|prior to) v?(\d[\w.]*\d)", text)
                repos = [f"{r}/{lf} ({p[pkg]})" for r, lf, e, p in locks if e == eco and pkg in p
                         and (not fixed or in_range(p[pkg], "< " + fixed.group(1)))]
                if repos:
                    found.append((bool(fixed), f"{pkg} {'< ' + fixed.group(1) if fixed else 'version à vérifier'} → {', '.join(repos)}"))
        precise = [f for ok, f in found if ok] or [f for _, f in found]
        for f in precise:
            hits.append(f"{label(a)} non revue par GitHub : {f} « {(a.get('summary') or '')[:140]} » | {a.get('html_url')}")
    return hits, listed


def kev(since, locks):
    hits, listed = [], []
    names = {n for _, _, _, p in locks for n in p}
    for v in get_json(KEV).get("vulnerabilities", []):
        when = parse_time(v.get("dateAdded"))
        if not when or when < since.replace(hour=0, minute=0, second=0, microsecond=0):
            continue
        link = f"https://nvd.nist.gov/vuln/detail/{v['cveID']}"
        listed.append(item("CISA KEV", f"{v['cveID']} {v.get('vendorProject')} {v.get('product')}: {v.get('vulnerabilityName')}", [link], when))
        prod = v.get("product", "").lower()
        prod = ALIASES.get(prod, prod)
        if prod in names or prod.replace(" ", "-") in names:
            repos = sorted({f"{r} ({p.get(prod) or p.get(prod.replace(' ', '-'))})" for r, _, _, p in locks if prod in p or prod.replace(' ', '-') in p})
            hits.append(f"{v['cveID']} KEV {v.get('vendorProject')} {v.get('product')} (version à vérifier) → {', '.join(repos)} | {link}")
    return hits, listed


def certfr_hits(certfr_items, locks):
    direct = {"ruby", "rails", "php"} | {n for _, _, _, p in locks for n in p if len(n) >= 5 and n.isalpha()}
    hits = []
    for it in certfr_items:
        low = it["title"].lower()
        for a, b in ALIASES.items():
            low = low.replace(a, b)
        for n in sorted(direct):
            if re.search(rf"(?<![\w-]){re.escape(n)}(?![\w-])", low):
                repos = sorted({f"{r} ({p[n]})" for r, _, _, p in locks if n in p})
                if repos:
                    hits.append(f"CERT-FR « {it['title']} » cite {n} (version à vérifier) → {', '.join(repos)} | {it['links'][0]}")
    return hits


def last_pass(directory):
    files = sorted(f for f in os.listdir(directory) if f.endswith("-veille.md")) if os.path.isdir(directory) else []
    times = []
    for f in files:
        path = os.path.join(directory, f)
        with open(path, encoding="utf-8", errors="replace") as fh:
            m = re.search(r"^Passe : (\d{4}-\d\d-\d\d \d\d:\d\d) UTC", fh.read(), re.M)
        times.append(dt.datetime.strptime(m.group(1), "%Y-%m-%d %H:%M").replace(tzinfo=dt.timezone.utc) if m
                     else dt.datetime.fromtimestamp(os.path.getmtime(path), dt.timezone.utc))
    return max(times, default=None)


def run(fn, *args):
    t = time.monotonic()
    try:
        return fn(*args), time.monotonic() - t
    except Exception as e:
        warnings.append(f"{getattr(fn, '__name__', fn)} {args[0] if args and isinstance(args[0], str) else ''} : {type(e).__name__} {e}")
        return None, time.monotonic() - t


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", default=VEILLE_DIR)
    ap.add_argument("--hours", type=float)
    args = ap.parse_args()
    start = time.monotonic()
    now = dt.datetime.now(dt.timezone.utc)
    floor = now - dt.timedelta(hours=min(args.hours or MAX_HOURS, MAX_HOURS))
    prev = last_pass(os.path.expanduser(args.dir))
    since = max(floor, prev) if prev and not args.hours else floor

    locks, notes = scan_projects()
    if not github["gh"]:
        warnings.append("gh absent, appels GitHub sans authentification (60 par heure)")
    with concurrent.futures.ThreadPoolExecutor(max_workers=16) as pool:
        jobs = {name: pool.submit(run, feed_source, name, url, since) for name, url in FEEDS.items()}
        jobs["HN"] = pool.submit(run, hn, since)
        jobs["Bluesky bots"] = pool.submit(run, bsky_bots, since)
        jobs["Bluesky search"] = pool.submit(run, bsky_search, since)
        jobs["Anthropic"] = pool.submit(run, anthropic, since)
        jobs["IT-Connect"] = pool.submit(run, feed_source, "IT-Connect", ITCONNECT, since)
        jobs["GHSA"] = pool.submit(run, advisories, since, locks)
        jobs["CISA KEV"] = pool.submit(run, kev, since, locks)
        results = {k: j.result() for k, j in jobs.items()}

    items, alerts = [], []
    for name, (res, _) in results.items():
        if res is None or name == "IT-Connect":
            continue
        if name in ("GHSA", "CISA KEV"):
            alerts += res[0]
            items += res[1]
        else:
            items += res
    alerts += certfr_hits(results["CERT-FR"][0] or [], locks)
    alerts += [f"{name} EN ÉCHEC : à savoir incomplet, relancer plus tard" for name in ("GHSA", "CISA KEV", "CERT-FR") if results[name][0] is None]
    stories = merge(items)

    print(f"# veille : depuis {since:%Y-%m-%d %H:%M} UTC ({(now - since).total_seconds() / 3600:.0f} h), généré {now:%Y-%m-%d %H:%M} UTC")
    print("\n## sources")
    for name, (res, secs) in results.items():
        n = "ÉCHEC" if res is None else (len(res[1]) if isinstance(res, tuple) else len(res))
        print(f"- {name} : {n} ({secs:.1f} s)")
    for w in warnings:
        print(f"- AVERTISSEMENT {w}")
    print("\n## projets")
    for repo, lf, eco, pkgs in locks:
        print(f"- {repo}/{lf} : {len(pkgs)} paquets {eco}")
    for n in notes:
        print(f"- {n}")
    print(f"\n## à savoir ({len(alerts)})")
    for a in alerts or ["aucune"]:
        print(f"- {a}")
    print(f"\n## histoires ({len(stories)})")
    for s in stories:
        print(f"- {age(s['first'], now)} | {len(s['sources'])} src ({', '.join(sorted(s['sources']))}) | {s['title']} | {' '.join(s['links'][:4])}")
    print("\n## pas si frais (IT-Connect)")
    for it in sorted(results["IT-Connect"][0] or [], key=lambda i: i["time"], reverse=True):
        print(f"- {age(it['time'], now)} | {it['title']} | {it['links'][0]}")
    print(f"\n## requêtes GitHub : {github['requests']} ({'gh api' if github['gh'] else 'sans authentification'})")
    print(f"\n## temps du script : {time.monotonic() - start:.1f} s")


if __name__ == "__main__":
    sys.exit(main())
