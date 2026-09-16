# The one rule

Read by `/plan` before writing a plan, by `/ship` when re-planning after a review round, and by `/review` Pass 4 (simplicity). The global `CLAUDE.md` points here for Rails architecture.

**The plan IS the simplest Rails-conventional design. Nothing else.**

Convention over configuration. Rails built-in before custom construct. No new class, table, gem, job, route, state value, or config flag unless the issue demands it or the user asked for it. If you believe the simple design is genuinely insufficient, you do not design the alternative — you add **one flagged sentence** at the end of the plan ("Flag: I think X is insufficient because Y"), mark the issue `has-questions`, and stop. The user drives complexity escalation, never the planner.

## Rails architecture

- **Vanilla Rails first.** Convention over configuration is the doctrine: reach for the Rails built-in (`validates`, `normalizes`, `enum`, scopes, `delegated_type`, `generates_token_for`, Turbo, …) before any custom construct, config flag, or option hash. If Rails has an opinion, follow it.
- Responsibility placement is not negotiable: domain logic doesn't live in controllers, one job per class. But correct placement means putting code in the right *existing* home (usually the model), not creating a new one.
- Extraction requires the rule of three — no layer, service, or abstraction for a single use. A fat-ish model beats a thin model orbited by single-caller objects.
- The layered-rails skill is a **review instrument only** (`/review` Pass 3, violations check). Never invoke it during planning or implementation; never let it prescribe adding a construct.
