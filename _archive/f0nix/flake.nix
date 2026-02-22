{
  description = "Nix Home Manager on Fedora Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-index-database,
      home-manager,
      zen-browser,
      ghostty,
      ...
    }@inputs:
    let
      # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
      inherit (inputs.nixpkgs.lib) attrValues;

      system = "aarch64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      homeConfigurations."davinci" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit ghostty;
        };

        modules = [
          zen-browser.homeModules.beta
        ]
        ++ (map (f: ./modules/${f}) [
          "paths.nix"

          "home.nix"

          "cli-tools.nix"
          "dev-tools.nix"

          "helix.nix"
          "yazi.nix"
          "zen.nix"
          "zsh.nix"

          # "home.nix"

          # "chromium.nix"
          # "ghostty.nix"
          # "kitty.nix"
          # "wezterm.nix"
        ]);
        # ++ lib.optionals stdenv.isDarwin [
        #   m-cli # useful macOS CLI commands
        # ];
      };
    };
}
