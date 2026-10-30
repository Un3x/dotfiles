# The page

Read at step 6 of `manual-review-pr`, once the user asks for the page.

A Claude artifact: an HTML page in the session's scratchpad (`review-<repo>-pr-<n>.html`), published with the Artifact tool, whose rules apply (it loads its design skill first); first publish with icon `review` and the title `Revue PR <n>`. In the user's language, one anchored section per tab, in this order:

1. **Vue d'ensemble**: a one-sentence verdict, what the PR does today (links pinned to the head commit), the axes table (in the PR / constraint / link to its solution), the proposed refactor order, what is kept as is.
2. **Cible finale**: a callout saying it assembles the recommended options and is illustrative; all the constraints in one list; the whole target at once to show it holds together: who does what (table), the request flow as a text diagram, a sketch of each piece, what the next feature of the same kind has to write, what disappears from the PR.
3. **Solutions**: one sub-section per axis: today (real excerpt, pinned link), the problem, the decision in a callout with the user's justification, the **constraints**, the **options** (table: option / for / against, the user's own idea among them when they had one) and the recommended one, its sketch, the consequences.
4. **Décisions produit**: one callout per decision with the user's justification; open questions last.
5. **Notes**: minor findings, for the record.

Rules:

- **Constraints bind, sketches illustrate.** Whoever takes the page next, the author or an agent briefed with it, copies a lone code excerpt as the spec. So each axis states first what any solution must guarantee (who must not know what, which paths must agree, what the contract must not gain), then two or three options. A callout at the top says diverging from the sketches is expected as long as the constraints hold. An axis with a single sensible fix (a bug) states its constraint and a « Piste », no sketch.
- **Real excerpts come from the head commit, linked to it, never to a branch name; sketches say they are sketches**, follow the repository's idioms and agree from one tab to the other.
- **The user's justifications are quoted as decisions**, not turned into the agent's arguments.
- **Design level**: a line-level detail goes to Notes.
- Anchors stable: `/learn <page URL>` links each finding by its anchor.

Look at every section, and one reached by its `#anchor`, at desktop and phone width before giving the link.

Done when published: give the URL. It is private; the user shares it, and links it from the PR only if they choose. When the repository is public (`gh repo view --json visibility`), check before the user shares it that the page says nothing the repository does not already make public: nothing from Linear, Slack, meetings, Sentry, metrics or production data, no internal URL, no real personal data (a fixture's name is fine, a log's is not). When a decision rests on internal context, keep the decision and drop the context. A new round of commits republishes to the same URL.
