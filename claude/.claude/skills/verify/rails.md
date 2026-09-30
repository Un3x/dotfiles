# Rails answers for the interview

Read at `/verify create` step 1. Where to find each answer in a Rails repo, and the default when the repo is silent.

| Question | Look at | Default |
| --- | --- | --- |
| Launch | `Procfile.dev`, `bin/dev`, `README` quickstart | `PORT=3099 bin/dev` in the background, ready when `curl -s localhost:3099/up` answers 200 |
| Doctor | `config/routes.rb` health route, `bin/rails runner` | `/up` answers, `bin/rails runner 'puts User.count'` above zero, the port is owned by this run |
| Enter | `db/seeds.rb`, `test/fixtures/*.yml`, Devise config, `config/routes.rb` `devise_for` | one seed account per role with its dev password, the sign-in path, what the landing screen shows once in, and the test helper that logs that role in (`login_as`, `sign_in`, or the app's own) so a drive never retypes credentials |
| Drive | `test/system/`, `test/application_system_test_case.rb`, `app/views` labels, `app/javascript/controllers` `data-action` keydown | Capybara steps in a scratch system test under `tmp/verify/`, run with `bin/rails test tmp/verify/<file>`; Playwright only for what Capybara cannot reach |
| Evidence | existing `page.save_screenshot` calls, `tmp/screenshots` | `tmp/verify/<feature>/` : screenshot + the read-back command and its output |
| Isolation | `config/database.yml`, `Procfile.dev` | own port; the dev database is shared, so restore seeded data after a mutation and never `db:reset` |
| Browsers | `application_system_test_case.rb` `driven_by` | Chromium and Firefox both, the user browses with Firefox (2026-09) |

Keyboard shortcuts: grep `keydown` in `app/javascript` and `data-action="keydown` in views; a shortcut that fires only outside inputs is a Gotcha.

Seed passwords are dev-only and already in the repo; write them in the map. Credentials, `.env` secrets and production accounts never appear (user rule, FORBIDDEN).
