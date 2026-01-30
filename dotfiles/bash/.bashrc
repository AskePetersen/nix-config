#
# ~/.bashrc
#

set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string " [I] "'
bind 'set vi-cmd-mode-string " [N] "'

# Command completion notifications for unfocused terminals
__notify_command_complete() {
    local last_exit=$?
    local last_cmd=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//')
    
    # Only notify if terminal is not focused (check if kitty is not the active window)
    if ! hyprctl activewindow -j | grep -q '"class": "kitty"'; then
        if [ $last_exit -eq 0 ]; then
            notify-send -t 5000 "Command Completed ✓" "$last_cmd"
        else
            notify-send -t 5000 -u critical "Command Failed ✗" "$last_cmd (exit code: $last_exit)"
        fi
    fi
}

# Set up preexec and precmd hooks
__bash_preexec() {
    # Save command start time
    __cmd_start_time=$SECONDS
}

__bash_precmd() {
    local last_exit=$?
    # Only notify for commands that took more than 5 seconds
    if [ ! -z "$__cmd_start_time" ]; then
        local elapsed=$(($SECONDS - $__cmd_start_time))
        if [ $elapsed -ge 5 ]; then
            __notify_command_complete
        fi
        unset __cmd_start_time
    fi
    return $last_exit
}

# Set up the prompt command
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__bash_precmd"

# Trap DEBUG to capture command before execution
trap '__bash_preexec' DEBUG
eval "$(starship init bash)"
