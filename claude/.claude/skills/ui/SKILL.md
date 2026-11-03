---
name: ui
description: "Produce a screen for one of our projects: a mockup, a redesign, an alternative page, a canvas. Use before drawing any screen, whether `/challenge` step 7 asks for it, a ticket needs one, or the user wants to explore, critique or redraw a design."
---

# UI production

Adapted from Anthropic's `frontend-design` skill (Apache 2.0). The craft lives in Emil's design-engineering skills, `~/Documents/mylife_in_a_vault/docs/aiforui-skills/emil-<name>/SKILL.md`, read by path: their rules about components translate to the project's stack, their numbers apply as written.

The mockup is the spec for the screen (`../issue-template.md`): `/plan` builds from it, `/review` checks against it. Without one, the dev fills the gaps with default components, and the PO discovers the screen in the PR.

## Which case

| The issue or the request | The project | What we do |
|---|---|---|
| shows the screen in every state it changes (a mockup, a capture, a drawing) | any | nothing: it is the spec. A difference from it goes to the user, never into a new mockup |
| asks for options, directions or alternatives | any | `emil-prototype` on a temporary branch, never the issue's: its Phase 7 writes the decision and integrates nothing. Step 4 runs on the picked variant; its decision and captures, saved in step 3's `maquette/` folder, are the mockup at step 5; then the temporary branch is deleted |
| changes a screen, shows none | has a design system: a stylesheet or component library its screens already use (the DSFR on a State site, its own components, a `DESIGN.md`) | the mockup, straight from that system and the screens next to it |
| changes a screen, shows none | has none | a wireframe first, approved by the user, then the mockup |
| changes nothing on screen | any | `Screen: n/a` |

An issue that changes a screen among other things takes the screen rows.

## Two rules before anything

- **The design system is looked for in the repo first**: its stylesheet, its components, its fonts, the screens already live. A design system attached to a tool (a canvas, Claude Design) comes second; never a look redrawn from memory when the real one is in the repo.
- **No screen delivered unseen.** Every screen shown to the user was captured and looked at first. A tool that cannot capture its own render (a canvas) gets a page built and captured locally first, then moved in. A tool instruction that says otherwise is a contradiction to raise, not a rule to follow.

## Steps

1. **The content first**: the real data and labels, then the content that breaks the screen (a full list, an empty one, an error, a long name).
2. **No design system: the wireframe.** In ASCII, one per state that differs (filled, empty, error), with the layout and what each zone holds. The user approves it before any HTML: a layout fixed in ASCII costs a line, in HTML a round. The look (palette, type) is picked with the user at the same time, never invented alone.
3. **The mockup**, one static HTML page in the repo's `.notes/<branch>/maquette/`, the branch named by the issue (no issue: `.notes/maquettes/<subject>/`). With a design system: its real stylesheet and components, nothing hand-made where a component exists, and the screens next to the one that changes as the model, so the new one looks like it already belonged. Without one: the approved wireframe and look, built with `emil-design-foundations`. No app code, no logic: a page the PO opens in a browser.
4. **Review it.** Capture it at desktop and phone width (`/verify`'s browser or Playwright), then apply `emil-ui-review` and `emil-touch-and-accessibility` to the page. Measure every size, contrast, text size and spacing the design system sets (its tokens, `DESIGN.md`) on the rendered page, not the capture: a value the system does not have is a finding. The floor holds without announcing it: readable on a phone, visible keyboard focus, a label on every field. Cut one thing, fix, capture again.
5. **Approve**: the captures go to the user. With an issue: approved, they are attached to it as its mockup when it is written (the `issue` skill), and the screen criteria say « comme la maquette »; not yet approved, no `CHALLENGE: GO`. Without an issue, the approval ends it: the captures stay beside the mockup.

## Words on the screen

`emil-design-foundations` § Copywriting, plus two of ours:

- Named by what the user does, in the product's words, never by how the system is built: « Gérer les notifications », not « Configuration des webhooks ».
- An action keeps its name through the flow: « Publier » gives « Publiée ».
