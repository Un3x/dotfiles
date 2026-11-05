---
name: veille
description: "Make the dated veille file of the audit practice: run the sources script, keep what is on-topic, list every kept title by freshness, CVE of our stacks on top. Typed by the user only: /veille."
disable-model-invocation: true
---

# veille

Thomas wants to know what happens in his field before the press does: AI dev tools, the CVE of our stacks, Rails/Ruby/PHP. The pass gives him a list of titles; he picks 2-3 subjects, the rest is dropped. It is a tool to know, not a tool to post: the angle and the choice to post stay his. One file per pass, kept to learn from: `~/Documents/mylife_in_a_vault/projects/audit/veille/<YYYY-MM-DD>-veille.md` (a second pass on the same day: `<YYYY-MM-DD>-2-veille.md`).

## Steps

1. **Fetch**: `python3 -I ~/.claude/skills/veille/veille.py > <scratchpad>/veille-raw.txt`, then read the whole output, in parts. The script takes the window from the newest file in `veille/` (72 h at most) and prints its sections: `sources`, `projets`, `à savoir`, `histoires` (one merged line per story, freshest first: age of the oldest mention, number of sources, title, links), `pas si frais (IT-Connect)`. Done when you have read every line of `histoires`.
2. **Sort**: remove only what is surely off-topic for the five themes below. In doubt, keep it. Lines that tell the same story through different links become one line: sources added up, all links, the age of the oldest. Done when every story is kept or removed.
3. **Write the file**, in French except the quoted titles. First line: `Passe : <the « généré » time of the script header> UTC`; the next pass starts its window there. Then these three sections, in this order:
   - `## À savoir`: every line of the script's `à savoir`, unfiltered, each with the repos and versions it hits and its link; « aucune » when it is empty; an `EN ÉCHEC` line stays as is, since the section is then incomplete. The fix stays with the project's own session.
   - `## Liste`: every story kept, in the script's order, no cap. One line each: `- __ [tag] titre · N sources · âge · liens`.
   - `## Pas si frais`: the IT-Connect lines that pass the same sort, same line shape.
   - Last line of the file: `Temps passé : ` (Thomas fills it in).
4. **Report** to Thomas: the file's path, the number of stories read, kept and listed, and each source the script marks `ÉCHEC` or `AVERTISSEMENT`.

## Themes and tags

- `[IA]` AI dev tools: Claude Code, Cursor, Codex, Copilot, agents, MCP, the labs' releases.
- `[Sécu]` security of our stacks: Ruby, Rails, PHP, npm, supply chain, the infra a web app runs on.
- `[Rails/PHP]` Rails, Ruby, PHP and their ecosystems, beyond security.
- `[Chaud]` the hot subject of the moment, found by speed only (most sources, a threshold bot): one per day at most, whatever its topic.
- `[Process]` processes and paradigms off the beaten path that question how we build software.

## Rules

- A title stays in its language when it is French or English. Any other language: translate it into French, add `[trad]`, keep the original link.
- The `__` slot at line start stays empty: Thomas scores each title himself (0-10, his interest in the subject, unrelated to posting). Claude scores only once Thomas says so; from then on Claude fills the slot and Thomas corrects it.
- The sort removes; it never ranks. The order is the script's freshness order.
- GitHub calls go through `gh api`, so they use the gh login and the token never enters the script. Without gh, or when it fails, the script calls GitHub without authentication (60 calls an hour) and says so in `sources`.
- The script reads lockfiles in read-only mode and skips a missing project path with a note: the project list is the `PROJECTS` constant at the top of `veille.py`.
