# Feature file contract

Read at `/verify create` step 3 and at `/verify maintain` step 1. One file per user-facing feature under `features/`, an H1 and one paragraph on the user-visible behaviour, then exactly four H2 sections in this order.

1. `Sub-features` — short ids, one line each.
2. `How to get to it (user POV)` — every entry point: menu path, URL, keyboard shortcut, who can see it.
3. `Driving it with Capybara` — starts with `Preconditions:`; then labelled bullets, each pairing a user action with the exact step and the observable result.
4. `Gotchas` — what wastes or invalidates a run.

`features/README.md` is the index: baseline preconditions (port, seed accounts, data reset), driving conventions, proof rules, then one line per feature file.

## Example (Bangun, staff side)

```md
# Record an arrival by voice

Staff dictate a child's arrival on the shared tablet; the app transcribes, extracts the event and queues it for confirmation.

## Sub-features

- `voice-record` opens the recorder and captures audio.
- `voice-queue` shows the extracted event awaiting confirmation.
- `voice-confirm` writes the event on the child's daily record.

## How to get to it (user POV)

- Daily handling screen → `Dicter` button (top right). Staff role only.
- URL `/structure/daily_handling`.
- No keyboard shortcut.

## Driving it with Capybara

Preconditions:

- App answers on `http://localhost:3099/up`.
- Logged in as the seed staff account (see `SKILL.md` § Enter).
- Child `Léa` is scheduled today and has no arrival yet.

- **Open recorder.** Click `Dicter`. `click_on "Dicter"`. A dialog labelled `Dictée` appears with a `Démarrer` button.
- **Submit audio.** Attach `test/fixtures/files/arrival_lea.webm` through the hidden field and submit. The queue badge in the header increments.
- **Confirm.** Visit `/structure/voice_queue`, click `Confirmer` on the first card. The card disappears and `/structure/children/<lea>` lists an `Arrivée` at the dictated time.
- **Proof.** `page.save_screenshot("tmp/verify/voice-arrival/queue.png")` before confirming, and read back the event through `bin/rails runner`.

## Gotchas

- The recorder needs a microphone permission in a real browser; the fixture upload bypasses it.
- The queue is per daycare: log in on the right one.
```
