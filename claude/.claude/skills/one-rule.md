# The one rule

**The plan is the simplest design that fits what we are building: simple, readable, never over-engineered.**

## What are we building?

Answer first. The kind sets the level of abstraction, the pattern to follow and the expected size. It goes on the plan's `Kind:` line.

| Kind | Shape |
|------|-------|
| **Trivial**: a field, a label, a guard | Inline in the existing code. No new class. |
| **Fills an existing system**: a new endpoint in the catalogue, a new case of a mechanism that already exists | Follow the system's pattern. The new code writes only what is specific to it. If the system has no seam for this case, adding it is the work: preparatory refactoring, then the feature. Following the pattern means the same owner, not the same spot: when the new case does not fit where the existing one runs, ask what the code produces (a response, a record, a request) and who owns that, before widening the spot. The existing placement may be the thing to refactor. |
| **A new system**: a mechanism other features will plug into | Name its seam and its second adapter: the next feature of the same kind. The kind goes under Questions (`has-questions`) and the plan stops until the user confirms it. |
| **Isolated**: a one-off script, an importer, an experiment | Kept apart from the core, simple inside, no reuse expected. |

When the kind is unclear, it is a question, not a guess.

## Rules

- **A graft is not simple.** A graft is a second path for something the system already does (a second builder, a hook beside a chain step, a mock branch beside the real one), wrong even when it works. Widen the existing path. The plan removes a graft the design grid finds, new or old, or puts the preparatory refactoring that removes it under Questions.
- **Vanilla Rails first.** Reach for the Rails built-in (`validates`, `normalizes`, `enum`, scopes, `delegated_type`, `generates_token_for`, Turbo, …) before any custom construct, config flag or option hash.
- **Code goes to its information expert**, in its existing home when one fits. Read every user of that home first: behaviour of one entry point in an object two entry points share is a misplaced responsibility. An entry point that skips the behaviour through a guard or an early return is still a user: the guard is the sign of a wrong owner, never the reason to dismiss it.
- **Name a class like the other classes of its role in this app** (builder, interactor, serializer…): look at how they are named before naming a new or moved one. A `BuildX` interactor that becomes a plain object producing an artifact is `XBuilder`, not bare `X`.
- **A new class, layer or abstraction passes the deletion test**: deleted, its complexity reappears across callers. One adapter means a hypothetical seam; two adapters, a real one.
- **The user drives escalation.** If you believe the shape the kind calls for is insufficient, or the preparatory refactoring outweighs the feature, add **one flagged sentence** at the end of the plan (« Flag: I think X because Y »), mark the issue `has-questions`, and stop. Never design the alternative.
