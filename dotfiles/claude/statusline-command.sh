#!/usr/bin/env bash
# Claude Code status line: used context tokens, green < 100k, yellow >= 100k, red >= 150k.
# Prints nothing when the context figure is missing.

tok=$(jq -r '.context_window | if .used_percentage and .context_window_size then .used_percentage * .context_window_size / 100 else empty end' 2>/dev/null)
[ -z "$tok" ] && exit 0

LC_ALL=C awk -v n="$tok" 'BEGIN {
  c = n >= 150000 ? 31 : (n >= 100000 ? 33 : 32)
  printf "\033[%dm%dk\033[0m", c, n / 1000
}'
