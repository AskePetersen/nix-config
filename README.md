# NixOS-config
This is my NixOS configuration

# HOW TO RUN
`sudo nixos-rebuild switch --flake ./#YOUR_VERSION`

# how to extract content of all files
find . -type f -name "*.nix" -print -exec cat {} \; -exec echo -e "\n---\n" \; > all-nix-files.txt

# tpm and tmux
run 
`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
`git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/.tmux/plugins/tmux-resurrect` 
and then run 
`tmux source-file ~/.tmux.conf`


# Missing packages
		openssl
		postman
		sshfs # Litteraly best tool ever for remote editing
		google-chrome
		dbeaver-bin
		glow # Used for reading markdown files
		mysql84 # used for dbeaver 
		pylint
		nixpkgs-fmt
		black
		isort
		eslint
		nest-cli
		nodejs_20
		nodePackages.localtunnel
		nodePackages.intelephense
		nodePackages.prettier
		nodePackages.typescript
		nodePackages.typescript-language-server
