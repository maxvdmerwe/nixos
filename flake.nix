{
  description = "NixOS configuration for ion";

  # Select package channels
  inputs = {

    # Stable 23.05
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";

    # Stable 23.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";

    # Stable 24.05
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # home-manager.url = "github:nix-community/home-manager/release-24.05";

    # Unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager/master";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix User Repository (NUR)
    nur.url = github:nix-community/NUR;

    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = inputs@{ nixpkgs, home-manager, nur, spicetify-nix, ... } : {
    nixosConfigurations = {
      ion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit spicetify-nix;};
        modules = [
          ./configuration.nix
          ./nvidia-config.nix
          ./spicetify.nix # file where you configure spicetify
          ./hardware-configuration.nix
          nur.nixosModules.nur
          # This adds a nur configuration option.
          # Use `config.nur` for packages like this:
            # ({ config, ... }: {
            #   environment.systemPackages = [ config.nur.repos.c0deaddict.cameractrls ];
            # })

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # allow home-manager to follow allow unfree
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # import the home.nix config file
            home-manager.users.max.imports = [
              ./home.nix
              inputs.nur.hmModules.nur
            ];

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}