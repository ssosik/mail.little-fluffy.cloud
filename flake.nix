{
  description = "system configuration flake";

  inputs = {
    # Replace this with any nixpkgs revision you want to use.
    # See a list of potential revisions at
    # https://github.com/NixOS/nixpkgs/branches/active
    nixpkgs.url = "nixpkgs/release-21.11";
  };

  outputs = inputs@{ self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      nixConf = pkgs: {
        environment.systemPackages = [ pkgs.git ];
        nix = {
          package = pkgs.nixFlakes;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
          autoOptimiseStore = true;
          gc = {
            automatic = true;
            dates = "weekly";
          };
        };
      };
    in
    {
      # Replace machineName with your desired hostname.
      nixosConfigurations.mail = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        modules = [
          (nixConf nixpkgs.legacyPackages.x86_64-linux)
          ./configuration.nix
        ];
      };
    };
}
