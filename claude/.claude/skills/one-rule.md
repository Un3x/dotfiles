# The one rule

**The plan is the simplest design that fits what we are building: simple, readable, never over-engineered.**

## What are we building?

Answer first. The kind sets the level of abstraction, the pattern to follow and the expected size. It goes on the plan's `Kind:` line.

| Kind | Shape |
|------|-------|
| **Fills an existing system**: a field, a label, a guard, a new endpoint in the catalogue, a new case of a mechanism that already exists | Follow the system's pattern. The new code writes only what is specific to it; a field, a label or a guard stays in the existing code, no new class. If the system has no seam for this case, widening it is the work: preparatory refactoring, then the feature. Following the pattern means the same owner, not the same spot: when the new case does not fit where the existing one runs, ask what the code produces (a response, a record, a request) and who owns that, before widening the spot. The existing placement may be the thing to refactor. |
| **A new system**: a mechanism other features will plug into | Name its seam and check it against the next feature of the same kind. The kind goes under Questions (`has-questions`) and the plan stops until the user confirms it. |
| **Isolated**: a one-off script, an importer, an experiment | Kept apart from the core, simple inside, no reuse expected. |

When the kind is unclear, it is a question, not a guess.

## What level is it?

The level sets which checks the plan runs and when the user sees it. It goes on the plan's `Level:` line, with the trigger that set it. The level is read off the plan, never judged: one trigger is enough to move up, and a doubt between two levels takes the higher one, and a plan with no `Level:` line is level 3. An agent labels its own work low, and every plan sent back by review was labelled small.

| Level | Triggers | Checks | The user |
|---|---|---|---|
| **1** | fills an existing system, or isolated: no new query, scope, migration, job or route; one entry point; no screen | design grid | reads the plan on the issue, with the code |
| **2** | a new query, scope, job or route; a migration that leaves the data model as it is (an index); two entry points or more; a screen with a mockup | design grid, fresh-eyes | reads the plan on the issue, with the code; its Questions stop it as always |
| **3** | a new system; a change to the data model, its migration included; a migration that changes existing data; a Flag; money; data leaving the app | design grid, fresh-eyes, split review | approves the plan before ship |

## Rules

- **A graft is not simple.** A graft is a second path for something the system already does (a second builder, a hook beside a chain step, a mock branch beside the real one), wrong even when it works. Widen the existing path. The plan removes a graft the design grid finds, new or old, or puts the preparatory refactoring that removes it under Questions.
- **Vanilla Rails first.** Reach for the Rails built-in (`validates`, `normalizes`, `enum`, scopes, `delegated_type`, `generates_token_for`, Turbo, …) before any custom construct, config flag or option hash.
- **Code goes with the object that owns the decision**, in its existing home when one fits. Read every user of that home first: an object shared by two entry points cannot own behaviour that belongs to one of them. An entry point that skips the behaviour through a guard or an early return is still a user: the guard is the sign of a wrong owner, never the reason to dismiss it.
- **Name a class like the other classes of its role in this app** (builder, interactor, serializer…): look at how they are named before naming a new or moved one. A `BuildX` interactor that becomes a plain object producing an artifact is `XBuilder`, not bare `X`.
- **A new class, layer or abstraction needs a reason**: a seam of the system, the rule of three, or a mechanism it removes (name it). Generic machinery with a single user is speculative generality.
- **The user drives escalation.** If you believe the shape the kind calls for is insufficient, or the preparatory refactoring outweighs the feature, add **one flagged sentence** at the end of the plan (« Flag: I think X because Y »), mark the issue `has-questions`, and stop. Never design the alternative.
