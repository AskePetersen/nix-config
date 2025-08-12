# DEPRECATED
{ config, pkgs, ... }:

{
	programs.tmux = {
		enable = true;
		# baseIndex = 1;
		# shortcut = "a";
		# plugins = with pkgs.tmuxPlugins; [
		# ];

		/* extraConfig = ''
			set-option -g status-position top

# some set options
			set -g prefix c-a
			set -sg escape-time 1 # delay before sending commands
			set -g base-index 1 # start index at 1 instead of 0
			setw -g pane-base-index 1 # pane index start at 1
			set-option -g status-position top # status bar is going top
			setw -g mode-keys vi

# style for windows
			set-window-option -g window-status-format "#[fg=black]#[bg=default] #I:#W "
			set-window-option -g window-status-current-format "#[fg=black,bold]#[bg=blue] #I:#W "
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
			bind h select-pane -L # select another pane
			bind j select-pane -D # select another pane
			bind k select-pane -U # select another pane
			bind l select-pane -R # select another pane
			bind -r ( switch-client -p # select prev window
			bind -r ) switch-client -n # select next window
			bind -r c-h select-window -T :- # select next window
			bind -r c-l select-window -T :+ # select next window
# resizing panes
			bind -r H resize-pane -L 5
			bind -r J resize-pane -D 5
			bind -r K resize-pane -U 5
			bind -r L resize-pane -R 5
			bind escape copy-mode # press escape if we want to move through terminal
			bind-key -T copy-mode-vi y send -X copy-selection # copy
			bind-key -T copy-mode-vi v send -X begin-selection # 'visual mode'
			bind r source-file ~/.tmux.conf \; display "reloaded!" # reload current config
			bind down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp
			bind up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp

# plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-resurrect
			set -g status-right ""
		''; */
	};
}

