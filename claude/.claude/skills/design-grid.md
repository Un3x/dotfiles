# Design grid

Before walking the grid, read what the change plugs into: base classes, callers, every other user of the classes it touches, how the same problem is solved elsewhere in the repository. An object shared by two entry points changes where a responsibility can live.

Report only what the code shows. An empty family is a fine outcome.

## Responsibilities

- **Misplaced rule** (tell, don't ask): a caller decides something the object could state itself. A `case` or a table on error types to know which deserve a proof, instead of each error saying so.
- **Re-derived knowledge**: a layer rebuilds from an output (a message, a title, a serialized payload, a raw header) what another layer knew as a typed fact. Stringly typed, it breaks silently when the wording changes.
- **Ad-hoc list**: ask what justifies « this case yes, that one no ». No business rule behind it: the list is the smell. A rule behind it: the rule goes in the code, not the list. Before tagging cases one by one, ask whether an existing type already states the rule: then the rule follows the type, and a case that disagrees has the wrong type. An HTTP status is not such a type: one 404 can mean « not referenced » or « found, not eligible ». A rule keyed on it is a **Misplaced rule**.
- **Wrong owner for the entry point**: behaviour of one route, caller or response in an object several routes share.
- **Reaching through objects**: reading another object's internals or options instead of asking it.
- **Stretched inheritance**: refused bequest, a base built for another case, constants borrowed from a sibling.
- **Layer direction** (Rails): a model reading `Current` or the request, a service taking `params`, a controller computing a business rule, a view querying the database, a mailer sent from a model callback.
- **Two classes in one**: most methods of a class open on the same branch (`if not_found?`). It holds two objects: split them and pick one where it is built.
- **Wrong level of abstraction**: speculative generality, or a copy of an existing variant where the system already has a seam for it. Check with the deletion test, and ask what the next feature of the same kind would have to write.

## Rails health

The in-review subset of layered-rails' checks. Its layer checks are « Layer direction » above. The dedicated layered-rails reviewer ([`review/SKILL.md`](review/SKILL.md) step 4) goes deeper.

- **Callbacks**: a callback doing work outside the record (charging, syncing another system) instead of keeping the record consistent; a flag to skip a callback (`skip_*`, `unless: :flag`).
- **Concerns**: a concern that groups code by kind (all the validations, all the scopes) instead of carrying one behaviour testable on its own; a concern grown past one screen.
- **Services**: an anemic domain model, its logic moved into a service.
- **God object**: a class the diff grows that already changes often and holds several unrelated jobs (unlike « Two classes in one », where one job splits on a branch).

## Control flow

- **Fighting the framework**: a hook wrapping a chain, rescue and re-raise, `send` on a private method, because the natural seam does not fit. The code sits in the wrong place.
- **Graft** ([`one-rule.md`](one-rule.md)): a second path beside the one that already does the job: a second builder, a hook beside a chain step, a mock, sandbox, test or feature-flag path re-implementing the real path's decision.
- **Exceptions as control flow**, and broad rescues that turn a bug into a log line.
- **Partial writes**: an object or context mutated step by step, so a failure midway needs cleanup. Compute first, write once.

## State and data

- **Shared mutable context**: values set then reset to hide them, defensive copies, temporal coupling.
- **Inputs mutated in place** (normalization, defaults), so the original is lost to whoever needs it later. Parse at the boundary into a new value.
- **Time**: several « now » in one operation, time zones, expiry windows.
- **Cache**: does the new behaviour bypass, poison or leak through a cache, and on which key. A cached value whose content, shape or lifetime changes gets a new key in the same commit, not a purge left to the deploy.

## Paths and environments

- **Environment branches** in production code.

## Contracts

- **Public contract**: response shape, error format, SDKs, generated docs, compatibility for existing clients. A change in a shared parent class reaches every subclass's output: document and mock it for each, or move it down to the subclass.
- **Overspecified tests and docs**: they encode a sorting rule, not a need, and flip the day the rule changes.

## Product and security

- **What the feature lets a user prove, forge, skip or learn**: a document obtained with chosen inputs, a response revealing whether a record exists.
- **Personal data**: minimization, who sees what.
- **Invented value**: a missing value replaced by a default the code cannot know is right, in a param or in a rendered document (the most common provider printed as the data source when the real one is unknown). Unknown is written as unknown, or the call fails fast.
