# DEPRECATED
{ config, pkgs, ... }:

{
	programs.tmux = {
		plugins = with pkgs.tmuxPlugins; [
			tpm # A plugin manager
		];

		extraConfig = ''
			set-option -g status-position top
		'';
	};
}

