#
# ~/.bashrc
#

set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string " [I] "'
bind 'set vi-cmd-mode-string " [N] "'

# bash-preexec (installed via configuration.nix) gives reliable
# preexec/precmd hooks. A hand-rolled DEBUG trap also fires for
# PROMPT_COMMAND itself, which resets the timer and clobbers $?.
[ -f /run/current-system/sw/share/bash/bash-preexec.sh ] &&
    . /run/current-system/sw/share/bash/bash-preexec.sh

# Notify when a command that ran >= 5s finishes while the terminal is unfocused
__notify_min_seconds=5

__notify_preexec() {
    __cmd_start_time=$SECONDS
    __cmd_string=$1
}

__notify_precmd() {
    local last_exit=$? # bash-preexec restores the command's exit code for us
    [ -z "$__cmd_start_time" ] && return
    local elapsed=$((SECONDS - __cmd_start_time))
    unset __cmd_start_time
    [ "$elapsed" -lt "$__notify_min_seconds" ] && return

    # Only notify if the terminal is not the focused window
    if ! hyprctl activewindow -j 2>/dev/null | grep -q '"class": "kitty"'; then
        if [ "$last_exit" -eq 0 ]; then
            notify-send -t 5000 "Command Completed ✓" "$__cmd_string"
        else
            # No -u critical: swaync never expires those, whatever -t says
            notify-send -t 3000 "Command Failed ✗" "$__cmd_string (exit code: $last_exit)"
        fi
    fi
}

preexec_functions+=(__notify_preexec)
precmd_functions+=(__notify_precmd)

eval "$(starship init bash)"
