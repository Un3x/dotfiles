# Who reads what

Read from `commit` step 1, from `/ship` phase 2 and 4, and from any session that writes on an issue. Each artefact has one reader, and its length is what that reader has time for.

| Artefact | Reader | When | They need | Cap | Links to |
| --- | --- | --- | --- | --- | --- |
| Commit | the developer in a production incident, from `git blame` / `git log -S`; the PR reviewer second | 2 am, no ticket open | what changed, in a word they can grep; the why when the subject cannot carry it | [`SKILL.md`](SKILL.md) steps 1 and 2 | nothing: GitHub resolves the sha to its PR |
| Pull request | the reviewer; the same developer six months later, when the issue is archived | opening the diff, then the commits in order | one functionality ([`../challenge/slices.md`](../challenge/slices.md)); the high-level why and the one constraint; how to test only when it is not obvious from the diff | 1 to 3 lines + `Closes`; a review guide the user may publish (`/review-guide`) when the commits alone cannot carry the read | the issue, for the whole story; the guide for a large PR |
| Issue body | the PO first, then the dev, the tester and the agent that ships it ([`../issue/template.md`](../issue/template.md)) | deciding, prioritising, briefing, then building | above the line: why, what to decide, the criteria, what it will not do — in plain words a twelve-year-old follows; below it: the links, constraints and code pointers the dev needs | one screen above the line | the PR once it exists |
| Issue comment | the same readers, in a thread | a scope question needs an answer | one question, open or closed, whose answer splits, merges or bounds the issue; or the answer | a few lines | — |
| Plan | Thomas, the coding agent | before and during `/ship` | the steps, the diagram, the size estimate | as long as it needs | attached to the issue as a file, never as a comment |

What does not go on the tracker: plans, shipping logs, review rounds, rebase notes, file counts, and class names above the line. The issue's readers asked for none of it. The technical how lives in the code, which is meant to read at a glance; the plan is a file on the issue for whoever wants the detail.
