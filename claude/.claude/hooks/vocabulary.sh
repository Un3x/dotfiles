#!/bin/bash
WORDS='nicer|better|cleaner|clean up|improve|sucks|modern|beautiful|polish|optimi[sz]e|mieux|plus joli|plus propre|améliorer|amélioration|sympa|moderne'
HITS=$(jq -r '.prompt // empty' | LC_ALL=C.UTF-8 grep -oiwE "$WORDS" | LC_ALL=C.UTF-8 sed 's/.*/\L&/' | sort -u | paste -sd, | sed 's/,/, /g')
[ -n "$HITS" ] || exit 0
jq -n --arg h "$HITS" '{
  systemMessage: ("Generic words: " + $h),
  hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: ("Reminder: the prompt holds words that are often too generic (" + $h + "). Judge each: when one carries the request and its meaning is not clear from context, ask for the precise term (which property, against what reference); otherwise carry on.")}
}'
