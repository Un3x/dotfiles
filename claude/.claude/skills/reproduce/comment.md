# The verdict, where the report lives

Read at step 6 of `/reproduce`. Readers are the ones of a Linear issue (`commit/readers.md`): non-technical, in a thread.

```
Reproduction — <verdict>

<one line: what was done, in the reporter's terms: « connectée comme éducatrice, arrivée de Léa saisie à 8h15 puis supprimée »>
<one line: what was seen, matching or not the report>
[already fixed → « corrigé sur main depuis le <date> » or « corrigé par la PR #N, pas encore déployée »]
[could not verify → what was missing, in plain words]
```

Then the evidence as one attachment on the issue, title « Reproduction <date> »: `prepare_attachment_upload` → `curl -X PUT --data-binary` with the signed headers, within 60 seconds → `create_attachment_from_upload`. The attachment is a zip or a single markdown of `tmp/verify/reproduce-<slug>/`: screenshots, read-back, log excerpt, drive script.

No Linear issue: the same three lines go to the sub-assistant in the code pane's final message, plus the evidence path; the sub-assistant tells the user and opens a ticket only for `reproduced` and `flaky`.

The language is the project's (`commit/readers.md`).
