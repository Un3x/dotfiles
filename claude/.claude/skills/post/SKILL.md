---
name: post
description: "Write or correct a LinkedIn post in Thomas's voice: pick the angle, check every fact, draft or correct, hand it ready to paste. Typed by the user only: /post <subject | pasted draft>."
disable-model-invocation: true
---

# post

Thomas posts on LinkedIn for his audit practice. The post sounds like him, says only what is true, and is ready to paste. If he has to rewrite it to sound like himself, it failed; if a commenter can prove a line false, it failed worse.

## Usage

- `/post <subject or link>`: draft a post.
- `/post` + his pasted text: correct it. He wrote it; it stays his.

## Steps

1. **Read the line and the record**: `~/Documents/mylife_in_a_vault/projects/audit/posts.md` (editorial line, what worked, what flopped, drafts, published). Done when you know whether the subject repeats a recent post.
2. **Read the source in full** when the post rests on one (study, article, CVE): follow [`sources.md`](sources.md). Done when every number and claim you will write traces to a line of the source you read, not a summary of it.
3. **Pick the angle** and say it in one line before drafting: who it is for (devs: tutoiement, reach; dirigeants: vouvoiement, buyers), the one opinion it defends, the closing line or question.
4. **Write or correct** with [`voice.md`](voice.md), reading [`corpus.md`](corpus.md) first. Drafting: his words, his rhythm, his practice; an anecdote you do not have is a `[ton anecdote : …]` slot, never invented. Correcting: spelling, grammar, a missing verb, a line that is false or unclear; his slang, jokes and structure stay. Done when every change can be named in one line.
5. **Check** against the list at the end of [`voice.md`](voice.md).
6. **Hand it over**: the post as plain text (no blockquote, no code block), also on the clipboard (`wl-copy` or `xclip -selection clipboard`); then the changes, one line each; then what he must confirm (a claim only he can vouch for, a figure's limit); then the link for the first comment.
7. **Once he says it is posted**: add it to « Publiés » in `posts.md` and `log_done` it in the audit category of yspassequoi.

## Rules

- A joke or an image that states a fact must be true (« 17 + 10 = 40 » was cut: the study counts 13.3 h of other tasks).
- A claim about Thomas (« je le vois dans chaque équipe », « ce que je regarde en audit ») is his to confirm, every time.
- The source link goes in the first comment, never in the post.
- His version beats the draft: when he pastes his rewrite, correct it; do not bring the draft back.
