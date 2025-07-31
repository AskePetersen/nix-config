# DEPRECATED
{ config, pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		baseIndex = 1;
		shortcut = "a";
		# plugins = with pkgs.tmuxPlugins; [
		# ];

		extraConfig = ''
			set-option -g status-position top
			pls?

# some set options
			set -g prefix c-a
			set -sg escape-time 1 # delay before sending commands
			set -g base-index 1 # start index at 1 instead of 0
			setw -g pane-base-index 1 # pane index start at 1
			set-option -g status-position top # status bar is going top
			setw -g mode-keys vi

# style for windows
			set-window-option -g window-status-format "#[fg=black]#[bg=default] #i:#w "
			set-window-option -g window-status-current-format "#[fg=black,bold]#[bg=blue] #i:#w "
			set-option -g window-status-separator ""

# unbinds
			unbind c-b
			unbind r
			unbind n
			unbind c
			unbind [
			unbind p
			unbind up
			unbind down

# binds
			bind p paste-buffer # paste
			bind c-a send-prefix # new leaderkey
			bind | split-window -h # split window
			bind - split-window -v # split window
			bind n new-window # create a new window
			bind h select-pane -l # select another pane
			bind j select-pane -d # select another pane
			bind k select-pane -u # select another pane
			bind l select-pane -r # select another pane
			bind -r ( switch-client -p # select prev window
			bind -r ) switch-client -n # select next window
			# bind -r c-h select-window -t :- # select next window
			# bind -r c-l select-window -t :+ # select next window
# resizing panes
			bind -r h resize-pane -l 5
			bind -r j resize-pane -d 5
			bind -r k resize-pane -u 5
			bind -r l resize-pane -r 5
			bind escape copy-mode # press escape if we want to move through terminal
			# bind-key -t copy-mode-vi y send -x copy-selection # copy
			# bind-key -t copy-mode-vi v send -x begin-selection # 'visual mode'
			bind r source-file ~/.tmux.conf \; display "reloaded!" # reload current config
			# bind down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp
			# bind up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp

# plugins
# set -g @plugin 'tmux-plugins/tpm'
			set -g status-right ""
		'';
	};
}

