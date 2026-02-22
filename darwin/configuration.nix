{ pkgs, ... }:

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
        "@admin"
      ];
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
