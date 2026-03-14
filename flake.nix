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

    # jujutsu.url = "github:martinvonz/jj";
    zig.url = "github:mitchellh/zig-overlay";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # fenix = {
    #   url = "github:nix-community/fenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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

    helix.url = "github:helix-editor/helix";

    codex.url = "github:openai/codex";

    ## flake false: source only

    ck-src = {
      url = "github:BeaconBay/ck";
      flake = false;
    };

    zellij-src = {
      url = "github:zellij-org/zellij";
      flake = false;
    };

    zesh-src = {
      url = "github:roberte777/zesh";
      flake = false; # just a source tree
    };

    zjstatus-src = {
      url = "github:dj95/zjstatus";
    };
  };

  outputs =
    {
      self,
      nix-index-database,
      # lix-module,
      nix-darwin,
      sops-nix,
      home-manager,
      opencode,
      zen-browser,
      zesh-src,
      ck-src,
      ...
    }@inputs:
    let
      # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
      inherit (inputs.nixpkgs.lib) attrValues;

      overlays = import ./overlays.nix { inherit inputs; };

      system = "aarch64-darwin";
    in
    {
      darwinConfigurations."Kenrics-MacBook-Air" = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          (
            { ... }:
            {
              nixpkgs.overlays = overlays;
            }
          )

          ./darwin/configuration.nix

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
                  "db-tools.nix"
                  "dev-tools.nix"
                  "knowledge-tools.nix"
                  "media-tools.nix"
                  "performance-tools.nix"
                  "visual-tools.nix"
                  "vcs.nix"

                  "aerospace.nix"
                  "helix.nix"
                  "lsp.nix"
                  # "opencode.nix"
                  "yazi.nix"
                  # "yazelix.nix"
                  # "tmux.nix"
                  # "rust.nix"
                  "zellij.nix"
                  "zen.nix"

                  "bash.nix"
                  "nushell.nix"
                  "zsh.nix"

                  "home.nix"
                ])
                ++ [
                  zen-browser.homeModules.beta
                  sops-nix.homeManagerModules.sops
                ];
              extraSpecialArgs = {
                inherit opencode zesh-src ck-src;
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
