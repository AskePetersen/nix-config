# NixOS-config
This is my NixOS configuration

# HOW TO RUN
`sudo nixos-rebuild switch --flake ./#YOUR_VERSION`

# how to extract content of all files
find . -type f -name "*.nix" -print -exec cat {} \; -exec echo -e "\n---\n" \; > all-nix-files.txt

