# Maintain the map

Read at `/verify maintain`. The unit is the feature file, not every sentence. Outcome is one of `clean`, `changed`, `blocked`, said in the report.

1. **Locate.** `.claude/skills/verify-*/`; several → ask which; none → stop and point at `/verify create`.
2. **Index hygiene.** `features/README.md` lists exactly the sibling files; fix missing, dead or duplicate entries.
3. **Source pass.** One read-only subagent per feature file, in parallel: how does this feature work from the source, where does the file drift, one recipe to prove it live. They never drive the app and never edit.
4. **Churn sweep.** Routes, views and shortcuts changed since the map's last commit (`git log` on `config/routes.rb`, `app/views`, `app/javascript`) with no feature file → candidate rows, each with a concrete source path.
5. **Live pass.** Required even when the source looks clean. Launch, doctor, then every feature once, on this run's instance only; doctor again after any failed drive; evidence checked at its path before any cleanup. A feature that cannot be reached is `verified-unreachable` only with the concrete prerequisite named; a missing prerequisite in the map is drift.
6. **Triage.** Wrong user-POV description → fix the file. Behaviour the harness cannot drive → fix the harness. App actually broken → report it to the user, keep it out of this change.
7. **Ship.** Committed map: one PR of proven corrections, files under `.claude/skills/verify-<app>/` only. Local map: one commit in the vault project folder. `clean` and `blocked` ship nothing.
