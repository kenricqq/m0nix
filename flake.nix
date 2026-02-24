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

    codex.url = "github:openai/codex";

    # jujutsu.url = "github:martinvonz/jj";
    zig.url = "github:mitchellh/zig-overlay";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs-bun";
    };

    helix = {
      url = "github:helix-editor/helix";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
      nixpkgs,
      nix-index-database,
      # lix-module,
      nix-darwin,
      sops-nix,
      home-manager,
      opencode,
      zen-browser,
      zesh-src,
      helix,
      zig,
      ...
    }@inputs:
    let
      # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
      inherit (inputs.nixpkgs.lib) attrValues;

      overlays = [
        # inputs.jujutsu.overlays.default
        zig.overlays.default
        helix.overlays.default

        (final: prev: rec {
          #   # gh CLI on stable has bugs.
          #   gh = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.gh;

          #   # Want the latest version of these
          #   claude-code = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.claude-code;
          # nushell = inputs.nixpkgs.legacyPackages.${prev.stdenv.hostPlatform.system}.nushell;

          # zellij = prev.zellij.overrideAttrs (
          #   _old:
          #   let
          #     src = inputs.zellij-src;
          #   in
          #   {
          #     inherit src;
          #     version = "main-${src.shortRev or "dirty"}";

          #     cargoDeps = prev.rustPlatform.fetchCargoVendor {
          #       inherit src;
          #       hash = "sha256-4aKcQX4+9zoT4bFJzV6rqqw+aaj0ZUJ65xwVnIcrx18=";
          #     };

          #     doInstallCheck = false;
          #     nativeInstallCheckInputs = [ ];
          #   }
          # );
          # helix-master = helix.overlays.default;

          svelte-language-server = prev.svelte-language-server.overrideAttrs (old: rec {
            version = "0.17.28";

            src = prev.fetchFromGitHub {
              owner = "sveltejs";
              repo = "language-tools";
              tag = "svelte-language-server@${version}";
              hash = "sha256-szxBTiwNpDEM/3WuGl5RtPCGbTVAjNoJtTGutE/F2eg=";
            };

            pnpmDeps = prev.fetchPnpmDeps {
              inherit (old) pname pnpmWorkspaces;
              inherit version src;
              fetcherVersion = 2;
              hash = "sha256-v2X2WOEdrDwGO2q9IEjONpHeDFqVp3jGFYYjZ5uFLSE=";
            };
          });

          codex = inputs.codex.packages.${prev.stdenv.hostPlatform.system}.default;

          zjstatus = inputs.zjstatus-src.packages.${prev.stdenv.hostPlatform.system}.default;
        })
      ];

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

                  "helix.nix"
                  "lsp.nix"
                  "opencode.nix"
                  "yazi.nix"
                  # "yazelix.nix"
                  "zellij.nix"
                  "zen.nix"

                  "nushell.nix"
                  "zsh.nix"

                  "home.nix"
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
