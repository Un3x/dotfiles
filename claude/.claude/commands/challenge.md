Challenge command. Forces a "are we building the right thing?" pass before engineering work.

## Usage
- `/challenge <issue1> <issue2> ...` - Challenge listed issues (IDs or URLs)
- `/challenge` (no args) - Challenge the current conversation topic

## Purpose

This is the **founder brain** — not engineering, not planning, not review. The goal is to pressure-test whether we're solving the right problem before writing any code.

Run this BEFORE `/plan`. Planning locks in HOW to build. This questions WHETHER and WHAT to build.

## Behavior

### With issue arguments:
1. Fetch issue details from Linear MCP
2. For each issue, run the challenge framework below
3. Output findings per issue

### Without arguments:
1. Ask the user what they're about to build
2. Run the challenge framework on their description

## Challenge Framework

For each feature/issue, think through these in order:

### 1. Job-to-be-Done
- What is the user actually trying to accomplish?
- Is the issue description the real problem, or a symptom?
- Restate the problem in terms of user outcome, not implementation

### 2. 10x Check
- What would a 10x better version of this look like?
- Are we thinking too small? Too incremental?
- What would make users genuinely delighted, not just unblocked?

### 3. Scope Interrogation
- Is this the minimum that delivers the outcome?
- What can we cut without losing the core value?
- What are we including "just in case" that we should drop?
- Conversely: is there something small we're missing that would 3x the value?

### 4. Risk & Reversibility
- Is this a one-way door or two-way door?
- What's the blast radius if this is wrong?
- Can we ship a smaller version first to validate?

### 5. Opportunity Cost
- What are we NOT doing by spending time on this?
- Is this the highest-leverage thing right now?
- Does this compound (builds future value) or is it a one-off?

## Output Format

```
## Challenge: [Issue title or topic]

**The real job**: [reframed problem statement]

**10x version**: [what great looks like]

**Scope verdict**: [too big / right-sized / too small / wrong shape]
[specific cuts or additions if any]

**Risk**: [one-way/two-way door, blast radius]

**Opportunity cost**: [what we're trading off]

**Recommendation**: [proceed as-is / rethink scope / split into phases / kill it]
[brief rationale]
```

## Persist the Verdict

After presenting findings, ask the user whether they agree with the recommendation. Then update Linear so downstream commands (`/plan`, `/ship`) read the post-challenge truth instead of the original issue:

- **Agreed (proceed / rethink with changes)**: update the issue description — reframed problem, scope cuts, spike flag if applicable. The description should reflect what we actually decided to build.
- **Disagreed or killed**: leave a comment with the verdict and the user's decision, so the reasoning survives the next time the issue surfaces.
- **No Linear issue** (conversation-mode challenge): offer to create one capturing the agreed scope.

Never update Linear before the user has weighed in.

## Rules

- Be direct. If the idea is bad, say so.
- If the issue is clearly well-scoped and straightforward, say "looks good, proceed to /plan" — don't force artificial depth.
- Don't over-engineer the challenge for small tasks. A 1-line bug fix doesn't need a 10x vision.
- The goal is to catch scope mistakes and wrong problems BEFORE we invest in planning.
