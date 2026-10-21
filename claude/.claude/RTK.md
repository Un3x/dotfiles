# RTK

A hook rewrites shell commands through `rtk` to cut their output (`git status` → `rtk git status`). Its wrappers do not take every flag: `grep -h`, `find -printf`, and `head` on some files come back wrong. Prefix `command` (`command grep -h …`) or use `rtk proxy <cmd>` to run the raw command.

`rtk gain` shows the savings.
