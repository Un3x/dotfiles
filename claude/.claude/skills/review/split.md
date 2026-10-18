# Split review

Read by `/review split <target>`, a trial against the single-agent review: one agent carrying every pass gives the last ones less attention, so each domain gets its own agent with only its part of the checklist. The report, the bar for a finding and the rounds stay those of [`SKILL.md`](SKILL.md), so the two can be compared on the same PRs.

## Steps

1. **Gather the diff** as in `SKILL.md` step 1. A PR is checked out here (`gh pr checkout`), before anything starts. Fix the range every specialist reviews: `main...HEAD`, the latest round's `Head:` onwards, or the files given. Done when the tree and the range are set.
2. **Launch in parallel, in the background**:
   - Codex, as in `SKILL.md` step 4, without its checkout.
   - One subagent per specialist below, on the model this session runs on. Prompt exactly `Read ~/.claude/skills/review/split.md § Specialists, then review <target> on <range> as the <name> specialist. Never edit code.` plus the earlier rounds when there are some.

   Done when all are launched.
3. **Merge**, the coordinator's job, as `SKILL.md` step 7 does for Codex. Wait for every report; a specialist that fails or times out is `not run — <reason>`. Each finding is verified against the code at the bar of its pass. That means a failure scenario for CRITICAL and ASKED, the who-holds-what for DESIGN, a cost for SIMPLICITY, and a reading cost for Readability. Several instances of one kind of bug become one finding with its `Class:` line. A bug in unchanged code goes under PRE-EXISTING. A rejected finding keeps its one-line rebuttal. Done when every finding is kept, merged or rebutted.
4. **Report** as `SKILL.md` steps 8 and 9. Design findings go under DESIGN, the layered-rails ones included; LAYERED RAILS is left out. The last line reads `Specialists: <name> <raised>/<kept>, …` (or `not run — <reason>`), so the trial can count who found what. Done when the report is written.

## Specialists

Each one reads `SKILL.md` § Rules for the bar of a finding, and the repo's `REVIEW.md` files: the root one, plus any in a folder the diff touches. Each writes its findings in the shape of [`output.md`](output.md), with their `Where:` line. With earlier rounds, each checks that the findings of its own domain are fixed and does not raise a triaged one again. Each reviews only its domain and leaves the rest to the specialist who owns it: a narrow brief is what the trial tests.

- **Asked**: [`asked.md`](asked.md), the whole pass, verdict included.
- **Critical**: [`checklist.md`](checklist.md) Pass 1, then the edge cases and performance of Pass 2.
- **Design**: `checklist.md` Pass 3, with [`design-grid.md`](design-grid.md). On a Rails app it then applies `~/.claude/skills/layered-rails/SKILL.md` and its `commands/review.md`. In this mode it replaces the separate layered-rails reviewer.
- **Simplicity**: `checklist.md` Pass 4, then the rest of Pass 2: conditional complexity, test gaps, dead code, naming, readability.
- **Rules**: `SKILL.md` step 5, the written rules and the lessons ledger, findings under RULES MISSED.
