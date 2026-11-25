# RTK

A hook rewrites shell commands through `rtk` to cut their output (`git status` → `rtk git status`). Its wrappers do not take every flag: `grep -h`, `find -printf`, and `head` on some files come back wrong. Run the raw command with `rtk proxy <cmd>`, and always for a check whose output can come back empty (a `git log` range, a piped `grep`): a wrapper that drops lines reads as a pass. The hook rewrites a `command` prefix too (`command grep -h` becomes `command rtk grep -h`, and `-h` prints rtk's help).

`rtk gain` shows the savings.
