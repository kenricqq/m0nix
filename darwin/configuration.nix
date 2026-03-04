{ lib, pkgs, ... }:

let
  system-config = import ./system.nix;

in
{
  imports = [
    ./homebrew.nix
    ./fonts.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      nodejs_24
      fish
      bun

      # backup
      # duplicati
      p7zip
    ];
  };

  # Host basics
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    hostPlatform = {
      system = "aarch64-darwin";
    };
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  # services.nix-daemon.enable = true;
  users.users.kenrictee = {
    home = "/Users/kenrictee";
    uid = 501;
  };

  nix = {
    enable = false;
    # optimise.automatic = false;
    # nix store optimise (manually instead)

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "kenrictee"
        "@admin"
      ];
      trusted-substituters = [ "https://devenv.cachix.org" ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };
  };

  services = {
    postgresql = {
      enableTCPIP = true;
      package = pkgs.postgresql_18;
      ensureDatabases = [ "miniflux" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensurePermissions = {
            "DATABASE nextcloud" = "ALL PRIVILEGES";
          };
        }
        {
          name = "superuser";
          ensurePermissions = {
            "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
          };
        }
      ];
      extraPlugins = with pkgs.postgresql18Packages; [
        vectorchord
        pg_cron
      ];
      settings = {
        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
        log_destination = lib.mkForce "syslog";
      };
    };
  };

  # launchd.envVariables = {
  #   PATH = [
  #     "/run/current-system/sw/bin"
  #     "/etc/profiles/per-user/$USER/bin"
  #     "/nix/var/nix/profiles/default/bin"
  #     "$HOME/.nix-profile/bin"
  #     "$HOME/.bun/bin"
  #     "/opt/homebrew/bin"
  #     "/usr/bin"
  #     "/bin"
  #     "/usr/sbin"
  #     "/sbin"
  #   ];
  # };

  system = system-config;
}
