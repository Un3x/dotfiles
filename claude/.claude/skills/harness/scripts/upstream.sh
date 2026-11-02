#!/bin/bash
while read -r repo path pin local; do
    body=$(curl -fsS "https://api.github.com/repos/$repo/commits?path=$path&per_page=1") || { echo "$local: upstream $repo unreachable"; continue; }
    last=$(jq -r '.[0].sha[0:7]' <<< "$body")
    [ "$last" = "$pin" ] || echo "$local: $repo/$path moved $pin → $last — https://github.com/$repo/compare/$pin...$last"
done <<'PINS'
mattpocock/skills skills/productivity/writing-for-agents 3216582 writing-for-agents
mattpocock/skills skills/engineering/codebase-design 7739eae codebase-design
mattpocock/skills skills/engineering/domain-modeling d80fa0f domain-modeling
PINS
