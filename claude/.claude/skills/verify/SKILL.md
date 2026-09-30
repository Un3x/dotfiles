---
name: verify
description: "Drive the real app the way a user does and prove a behaviour: launch, log in as a role, reach a feature, capture evidence. Read before starting the app, logging in, or clicking through it; `/verify create` seeds a project's map, `/verify maintain` keeps it honest."
---

# verify

An agent that has to start the app, find the admin login and click to a screen rebuilds a throwaway script every session. The map ends that: one project-local skill, `.claude/skills/verify-<app>/`, holds the launch recipe and one file per feature saying how a user reaches it and what proves it works. Idea and contract from Lauren Tan's pstack (vault: `docs/pstack-feature-map/`).

## Use the map (every session that drives the app)

1. Read `.claude/skills/verify-<app>/SKILL.md` and the `features/README.md` index. No such directory → say so and offer `/verify create`; never improvise a launch or a login when a map exists.
2. Follow its Launch and Doctor sections literally, then the feature file's driving bullets. Done when the evidence named by the feature file exists at the path the skill names.
3. A step the map describes that the app no longer does is either drift (fix the map in the same PR, or note it if the map is local) or a regression (report it, do not paper over it).

## `/verify create` — seed a project's map

1. Interview the repo, not the user: surface, launch command, seed accounts per role, harness, evidence, isolation. Rails answers in [`rails.md`](rails.md). Ask the user only what the code cannot answer: which port is free, whether the map is committed or local.
2. Write `.claude/skills/verify-<app>/SKILL.md` with frontmatter (`name: verify-<app>`, a description that names the app, the surface and « launch »), and the sections Launch, Doctor, Enter (accounts and login path per role), Drive, Evidence, Cleanup, every one grounded in what step 1 found.
3. Write `features/README.md` and one file per feature for the top three to five, from routes, menus and system tests, in the shape of [`feature-file.md`](feature-file.md).
4. Placement: committed → plain files; local → real files in the vault project folder `projects/<name>/verify/`, symlink in the repo, `.claude/skills/verify-<app>` added to `.gitignore` (same pattern as `.notes`). Ask once, record nothing else.
5. Prove it once end to end: launch, doctor, log in, drive one feature, capture evidence, clean up, then check the evidence survived. A map never run is a draft.

## `/verify maintain` — keep the map honest

[`maintain.md`](maintain.md): one read-only pass per feature file against the source, one live pass driving every feature, outcome `clean`, `changed` (one PR or one vault commit) or `blocked`. Never edits product code.

## Rules

- Prefer stable handles: accessible names, labels, route paths, `data-*` attributes; never CSS position or generated classes.
- Drive only an instance this run started, on its own port; a shared dev server is not verified through.
- Evidence is the action and the resulting state, plus a read-back of any mutation; a final screenshot alone proves nothing.
- The map is the user's point of view; class names and code paths stay out of it, an agent discovers them at run time.
