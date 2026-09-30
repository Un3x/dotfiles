# Reading a report

Read at step 1 of `/reproduce`. Extract five things before touching the app; a missing one is written as an assumption in the comment.

| Report | Symptom | Role | Inputs | Where | Feature file |
| --- | --- | --- | --- | --- | --- |
| Email or message (Audrey, Dorine…) | their sentence, kept verbatim in the comment | who they are in the app | the names, dates, values they mention | the screen they describe | the feature whose « How to get to it » matches the screen |
| Screenshot | what is wrong on the image, in one line | the header, menu or URL bar on the image | visible values | the URL bar or the page title | same |
| Sentry event | the exception class and message | the user context (role, daycare, id) | request params, the transaction name | the route in the event | the feature whose entry route matches; a job or a mailer → the feature that enqueues it |
| Linear issue | the title | from the body | from the body | from the body | same; the issue body is the report, its comments are not |

A crash from Sentry reproduces when the same exception appears in `log/development.log` (or the test log) after replaying the route with the event's params and role; a different exception is `not reproduced` with the difference stated.

A report that names two symptoms is two runs of `/reproduce`, two verdicts.
