{
  description = "Nix-Darwin w/ Homebrew OSX system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scls.url = "github:estin/simple-completion-language-server";

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
      scls,
      zen-browser,
      zesh-src,
      ...
    }@inputs:
    let
      # inherit (inputs.nixpkgs.lib) attrValues makeOverridable optionalAttrs singleton;
      inherit (inputs.nixpkgs.lib) attrValues;

      system = "aarch64-darwin";
      scls-dev = scls.defaultPackage.${system};
    in
    {
      darwinConfigurations."DaVinci-Notebook" = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          # lix-module.nixosModules.default

          nix-index-database.darwinModules.nix-index

          ./darwin/configuration.nix

          sops-nix.darwinModules.sops

          home-manager.darwinModules.home-manager

          {
            # home-manager.extraSpecialArgs = specialArgs // {
            #   homeManagerConfig = buildHomeManagerConfig hostname;
            # };

            home-manager = {
              backupFileExtension = "backup"; # ie a->a.backup
              useGlobalPkgs = true;
              useUserPackages = true;
              users.davinci.imports =
                (map (f: ./home-manager/${f}) [
                  "paths.nix"

                  "cli-tools.nix"
                  "dev-tools.nix"
                  "fish.nix"
                  "helix.nix"
                  "home.nix"
                  # "sketchybar.nix"
                  "streamlink.nix"
                  "wezterm.nix"
                  "yazi.nix"
                  # "zed.nix"
                  "zellij.nix"
                  "zen.nix"
                  "zsh.nix"

                  # "chromium.nix"
                  # "ghostty.nix"
                  # "kitty.nix"
                  # "vscode.nix"
                  # "starship.nix"
                  # "ssh.nix"
                ])
                ++ [
                  zen-browser.homeModules.beta
                  sops-nix.homeManagerModules.sops
                ];
              extraSpecialArgs = {
                scls = scls-dev;
                zesh-src = zesh-src;
              };
            };

            # fingerprint auth
            security.pam.services.sudo_local.touchIdAuth = true;

            system = {
              primaryUser = "davinci";
              stateVersion = 6;
            };
          }
        ];
      };
    };
}
