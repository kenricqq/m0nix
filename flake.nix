{
  description = "Nix-Darwin w/ Homebrew OSX system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-bun.url = "github:NixOS/nixpkgs/f665af0cdb70ed27e1bd8f9fdfecaf451260fc55";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs-bun";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    zesh-src = {
      url = "github:roberte777/zesh";
      flake = false; # just a source tree
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-index-database,
      # lix-module,
      nix-darwin,
      sops-nix,
      home-manager,
      opencode,
      stylix,
      zen-browser,
      zesh-src,
      ...
    }@inputs:
    let
      # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
      inherit (inputs.nixpkgs.lib) attrValues;

      system = "aarch64-darwin";
    in
    {
      darwinConfigurations."Kenrics-MacBook-Air" = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          ./darwin/configuration.nix

          stylix.darwinModules.stylix
          nix-index-database.darwinModules.nix-index
          sops-nix.darwinModules.sops
          home-manager.darwinModules.home-manager

          {
            home-manager = {
              backupFileExtension = "backup"; # ie a->a.backup
              useGlobalPkgs = true;
              useUserPackages = true;
              users.kenrictee.imports =
                (map (f: ./home-manager/${f}) [
                  "paths.nix"

                  "cli-tools.nix"
                  "dev-tools.nix"
                  "media-tools.nix"

                  "fish.nix"
                  "helix.nix"
                  "opencode.nix"
                  "yazi.nix"
                  # "zed.nix"
                  "zellij.nix"
                  "zen.nix"
                  "zsh.nix"

                  "home.nix"

                  # "chromium.nix"
                  # "ghostty.nix"
                  # "kitty.nix"
                  # "sketchybar.nix"
                  # "ssh.nix"
                  # "starship.nix"
                  # "streamlink.nix"
                  # "vscode.nix"
                  # "wezterm.nix"
                ])
                ++ [
                  zen-browser.homeModules.beta
                  sops-nix.homeManagerModules.sops
                ];
              extraSpecialArgs = {
                inherit opencode zesh-src;
              };
            };

            # fingerprint auth
            security.pam.services.sudo_local.touchIdAuth = true;

            system = {
              primaryUser = "kenrictee";
              stateVersion = 6;
            };
          }
        ];
      };
    };
}
