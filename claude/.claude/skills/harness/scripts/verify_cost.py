import glob, json, os, re, statistics as st, sys

MAPS = {
    'simplifions': ('-home-unex-Project-api-entreprise-simplifions', 'simplifions-verify'),
    'bangun': ('-home-unex-Project-creche-bangun', 'verify-bangun'),
    'sensgiratoire': ('-home-unex-Project-lesensgiratoire', 'verify-lesensgiratoire'),
    'relais': ('-home-unex-Project-api-entreprise-relais', 'verify-relais'),
    'passemarche': ('-home-unex-Project-api-entreprise-voie-rapide', 'verify-voie_rapide'),
    'yspassequoi': ('-home-unex-Project-yspassequoi', 'verify-yspassequoi'),
}
PRICE = {'input_tokens': 1, 'cache_creation_input_tokens': 1.25, 'cache_read_input_tokens': 0.1, 'output_tokens': 5}
since = sys.argv[1] if len(sys.argv) > 1 else '0000'


def tokens(u):
    return sum(u.get(k, 0) for k in PRICE)


def priced(u):
    return sum(u.get(k, 0) * w for k, w in PRICE.items())


def ship(path, skill):
    calls, verify_ids, verify_tools, results, first, started = {}, set(), set(), [], None, ''
    keys = (skill, 'tmp/verify', 'skills/verify/')
    for line in open(path):
        try:
            o = json.loads(line)
        except ValueError:
            continue
        m = o.get('message') or {}
        if o.get('type') == 'user':
            content = m.get('content')
            if first is None:
                first, started = json.dumps(content)[:400], o.get('timestamp', '')
            for c in content if isinstance(content, list) else []:
                if isinstance(c, dict) and c.get('type') == 'tool_result' and c.get('tool_use_id') in verify_tools:
                    results.append(len(json.dumps(c.get('content'))) / 4)
        elif o.get('type') == 'assistant':
            if m.get('usage'):
                calls[m.get('id')] = m['usage']
            for c in m.get('content') or []:
                if isinstance(c, dict) and c.get('type') == 'tool_use' and any(k in json.dumps(c.get('input')) for k in keys):
                    verify_ids.add(m.get('id'))
                    verify_tools.add(c.get('id'))
    if not first or started < since:
        return None
    if 'Prove:' in first[:80]:
        return 'prove', sum(map(tokens, calls.values()))
    if not re.search(r'/([a-z]+-)?ship\b', first):
        return None
    v = [calls[i] for i in verify_ids if i in calls]
    context = 0 if not v else st.mean(u.get('input_tokens', 0) + u.get('cache_creation_input_tokens', 0) + u.get('cache_read_input_tokens', 0) for u in v)
    return len(v), sum(map(tokens, v)), context, sum(results), sum(map(priced, v)), sum(map(priced, calls.values())), sum(map(tokens, calls.values()))


print(f"/ship subagents since {since}: median per ship, share of all ships' priced tokens")
for name, (folder, skill) in MAPS.items():
    found = [r for f in glob.glob(os.path.expanduser(f'~/.claude/projects/{folder}/**/subagents/*.jsonl'), recursive=True) if (r := ship(f, skill))]
    rows = [r for r in found if r[0] != 'prove' and r[5]]
    proofs = [r[1] for r in found if r[0] == 'prove']
    if not rows:
        print(f"{name:14} no ship drove the map")
        continue
    med = lambda i: st.median(r[i] for r in rows)
    print(f"{name:14} ships {len(rows):3}  verify calls {med(0):3.0f}  verify tokens {med(1) / 1e6:4.2f}M  context/call {med(2) / 1e3:4.0f}k  "
          f"results {med(3) / 1e3:4.0f}k  share {100 * sum(r[4] for r in rows) / sum(r[5] for r in rows):3.0f}%  ship {med(6) / 1e6:4.1f}M  "
          f"proof subagents {len(proofs)}" + (f" median {st.median(proofs) / 1e6:4.2f}M" if proofs else ''))
