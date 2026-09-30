# Examples

Read from step 1 of `commit` when the shape is in doubt. Loïc's messages (API Entreprise, 2025) first, then rewrites of our own.

## Loïc, verbatim

```
Editor: paginate authorization requests
```
```
Admin: track tokens bans
```
```
CI: 90% code coverage is enough
```
```
APIM: Displays all tokens within authorization request

Replace "inactive tokens" with "other tokens", which is more actionnable
and allows to have multiple active tokens within the UI
```
```
FIX issue with connection_pool

Related 363fdf6462c707f0a7d42fbd70227828a0a9dae3
```
PR body, data_pass #1280 (2025-12-22):
```
No longer validates data integrity on admin operations (on terminal validated states or reopenings).

On reopening, we no longer checks data, which can be a regression, but backed with instruction/changelogs.

Closes https://linear.app/pole-api/issue/DP-1289
```
His review to a teammate, data_pass #1276 (2025-12): « la prochaine ça serait mieux que tu fasses un `merge & squash` pour n'avoir qu'un commit, c'est plus simple après pour nous de creuser les historiques, on comprend mieux de quoi ça parle. »

## Ours, before → after

Bangun PR #392 (2026-09-28), six commits for one resolver, three of them restating « aujourd'hui »:
```
fix(voice): resolve « aujourd'hui » and « ce jour » to the current day
fix(voice): « hier soir » and « hier matin » count as yesterday
fix(voice): accept a weekday in front of a dictated date
fix(voice): « aujourd'hui, le 19 juin » resolves to the dictated date
refactor(voice): build the weekday alternation once
fix(voice): « aujourd'hui le 19 juin » resolves without the comma
```
→ one commit after autosquash:
```
Voice: absences dictated for today, yesterday or a weekday resolve

The LLM emits the phrase as heard, so 22 of 57 dictated absences landed
in « À vérifier » and were rejected.
```

Apistration PR #439 body (2026-09-24), 21 lines with a `git grep` proof:
```
Drop the unread detail on an unavailable INSEE OAuth exchange

Both callers raise on `:unavailable` with a constant message before reading the detail; it now exists only when INSEE actually refused. Two client specs pin it.

Suite de #430
```

Bangun subject of 91 characters:
```
docs(events): Events::Rules reads the event_types table, say so in its header
```
→
```
Events: say in Events::Rules that it reads event_types
```
