{
  description = "I've seen your kind, time and time again. Every fleeting skill must be learnt. Every secret must be archived. Such is the conceit of the self-proclaimed bearer of intellect.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

  };

  # @inputs passes all inputs through
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        # Capitalism baby
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        CinderedNix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; }; # You do need this. "Makes inputs and system variables avaliable to configuration modules"

          modules = [
            ./nixos/configuration.nix
            ./modules
          ];
        };
      };
    };

}
