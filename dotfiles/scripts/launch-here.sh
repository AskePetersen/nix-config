#!/usr/bin/env bash
# Launch an app pinned to the workspace that is focused RIGHT NOW.
# Without this, slow-starting apps open on whatever workspace you have
# switched to by the time their window finally appears.
# "silent" = don't yank focus back if you've moved on to another workspace.

ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Strip .desktop field codes (%U, %f, ...) in case we're fed a raw Exec= line
# (wofi). Bash pattern substitution, so no printf|sed subshell per launch.
cmd=${*//%[UufFdDnNickvm]/}

# Unknown or special workspace: launch without pinning.
prefix=""
[ -n "$ws" ] && [ "$ws" -ge 1 ] 2>/dev/null && prefix="[workspace $ws silent] "

exec hyprctl dispatch exec "$prefix$cmd"
