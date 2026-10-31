# nix-config

One flake shared by several machines (`hosts/thinkpad`, `hosts/ideapad`, `hosts/nitro`).

Never commit or push in this repo unless the user explicitly says to.

Before editing `hosts/nitro`, read `hosts/nitro/nitro.md`: driver pinned for a Pascal GPU.

## Never configure the machine locally

Every setting must live in this repo. That covers user config, dotfiles, app defaults and tool settings. Do not change files in `~` or `~/.config` directly. Do not write setup steps for a human to run by hand (`git clone ...`, `starship preset ... -o ...`). Anything set locally exists on one machine only and silently goes missing on the others.

- Shared settings go in `programs/` or `hosts/configuration.nix`. Settings for one machine only go in `hosts/<name>/default.nix`.
- Raw dotfiles go in `dotfiles/<app>/` and get linked in `programs/home.nix` (`home.file` + `link`). Use a home-manager module (`programs.<x>.settings`) where one exists.
- Plugins and tools come from nixpkgs, not from runtime installers like tpm, npm -g or curl scripts.
- Secrets and private keys stay out of the repo. Declare where they go, not what they contain.
- If you find a setting that exists only locally, say so and propose moving it into the repo. Do not work around it.
