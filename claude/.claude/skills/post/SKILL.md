---
name: post
description: "Write or correct a LinkedIn post in three steps: pick the subject from the veille, fit what Thomas wants to say to a structure, write it in his voice or Dumas's. Typed by the user only: /post <subject | dictation | pasted draft>."
disable-model-invocation: true
---

# post

Thomas posts on LinkedIn for his audit practice. A post is made in three steps, each one closed by him: the subject, the structure, the text in a voice (his own, or Dumas's). It says only what is true and is ready to paste. If he has to rewrite it to sound like himself, it failed; if a commenter can prove a line false, it failed worse.

## Usage

- `/post` alone: start at step 2, the subject.
- `/post` + his dictation (Wispr, rambling allowed), pasted or saved in the Wispr folder « linkedin thoughts » (read it as a meeting: `list_folders`, `list_folder_meetings`, then `get_meeting` with `view_transcript`, not the summary, and its continuation until the end of a long dictation): the subject is set; start at step 3. The default input.
- `/post <subject or link>`: the subject is set; at step 4 he dictates, or says « brouillon » when he has no time to dictate.
- `/post` + his pasted text: correct it, steps 1, 3, 5, 6, 7 and 8. He wrote it; it stays his. « à la Dumas » with it: rewrite it in the Dumas voice, every fact kept.

## Steps

1. **Read the line and the record**: `~/Documents/mylife_in_a_vault/projects/audit/posts.md` (editorial line, what worked, what flopped, ideas, published). Done when you know whether the subject repeats a post of the last two weeks.
2. **Offer subjects**: read the newest file in `~/Documents/mylife_in_a_vault/projects/audit/veille/` and the « Idées » of `posts.md`. Offer 3 to 5 subjects, one line each: the title, its source, and the deeper theme it opens (ownership, the entropy of debt, a new cost), never a ready angle. You do not score and you do not choose: the choice to post is his. Done when he names one, or names his own.
3. **Read the source in full** when the post rests on one (study, article, CVE): follow `~/.claude/skills/sources.md`. Done when every number and claim you will write traces to a line of the source you read, not a summary of it.
4. **Fit the structure** with [`structure.md`](structure.md). He dictates what he wants to say (the default); in « brouillon », work from the facts of step 3. Pick the structure that carries his point, and hand the skeleton (its shape is in `structure.md`): audience, voice, hook, body beats, end, his key phrases quoted from the dictation, a `[à dicter : …]` slot for each gap. Dumas voice: two angles first, one line each, the recommended one first, preferring the angle that carries an image (a known meme). On a Sunday (« Dimanche à la Dumas »), offer the Dumas voice first. Done when he corrects the skeleton or says go.
5. **Write in the voice he picked**, from the skeleton he closed:
   - **His voice**: [`voice.md`](voice.md), reading `~/Documents/mylife_in_a_vault/projects/audit/paires.md` first: the published text of a « dictée » pair is his voice; the gap between handed and published is what he changes. Drafting: his words, his rhythm, his practice; an anecdote you do not have is a `[ton anecdote : …]` slot, never invented. Correcting: spelling, grammar, a missing verb, a line that is false or unclear; his slang, jokes and structure stay. Cutting a dictation: his words only; cut repetitions and detours, reorder, add a missing verb, never a sentence of yours. Done when every change can be named in one line.
   - **Dumas**: transpose with [`dumas-epoque.md`](dumas-epoque.md), then write with [`dumas-style.md`](dumas-style.md). His key phrases are transposed, never dropped. Done when every element of the fact list has its 1840s equivalent, every historical fact used is checked in a source like a news fact, and the text reads aloud as a chapter.
6. **Check** against the list at the end of `voice.md` or `dumas-style.md`, word by word for the Dumas anachronism test.
7. **Hand it over**: the post as plain text in the reply (no blockquote, no code block), which he copies from the terminal; then the changes (for a dictation, what was cut), one line each; for Dumas, the transposition, one line per pair (« vols annulés → voyages annulés »); then what he must confirm (a claim only he can vouch for, a line given to a real person, a figure's limit); then the link for the first comment, with the names of companies and tools for Dumas; then one meme that illustrates it, as a suggestion: a known template (its name and imgflip link) and the French text of each panel, in today's words and checked for truth. A Dumas text is a draft he reworks, not the day's post.
8. **Once he says it is posted**: ask for the text as published, unless he pasted it. Add the pair at the top of `~/Documents/mylife_in_a_vault/projects/audit/paires.md`: date, mode (dictée, correction or brouillon; Dumas titled « Dimanche à la Dumas n° N »), the text you handed over, the text published. Add it to « Publiés » in `posts.md` and `log_done` it in the audit category of yspassequoi.

## Rules

- A joke or an image that states a fact must be true.
- A claim about Thomas (« je le vois dans chaque équipe », « ce que je regarde en audit ») is his to confirm, every time.
- The source link goes in the first comment, never in the post.
- His version beats the draft: when he pastes his rewrite, correct it; do not bring the draft back.
