{ inputs, nixpkgs, home-manager, nixvim, vars, ... }:
# This file contains programs and packages across all systems
let
  system = "x86_64-linux";
  inherit (nixpkgs) lib;

  mkHost = hostName:
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system vars;
        host = { inherit hostName; };
      };
      modules = [
        nixvim.nixosModules.nixvim
        (./. + "/${hostName}")
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # If a file/dir already exists where home-manager wants a symlink,
            # move it aside as *.hm-bak instead of failing the activation.
            backupFileExtension = "hm-bak";
          };
        }
      ];
    };
in
{
  ideapad = mkHost "ideapad";
  thinkpad = mkHost "thinkpad";

  # Adding a new machine is one line: myDesktop = mkHost "myDesktop";
  # (plus a hosts/myDesktop/ directory with default.nix + hardware-configuration.nix)
}
