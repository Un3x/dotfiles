#!/bin/bash
WORDS='nicer|better|cleaner|clean up|improve|sucks|good|great|modern|beautiful|pretty|polish|optimi[sz]e|mieux|plus joli|propre|améliorer|amélioration|beau|sympa|moderne|nul'
HITS=$(jq -r '.prompt // empty' | grep -oiwE "$WORDS" | tr 'A-Z' 'a-z' | sort -u | paste -sd, | sed 's/,/, /g')
[ -n "$HITS" ] || exit 0
jq -n --arg h "$HITS" '{
  systemMessage: ("Generic words: " + $h),
  hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: ("The prompt uses generic words (" + $h + "). Where one carries the request, ask what it means in precise terms (which property, against what reference) before acting on it.")}
}'
