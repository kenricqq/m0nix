{ pkgs, ... }:

let
  homebrew-config = import ./homebrew.nix;
  system-config = import ./system.nix;

in
{
  # imports = [
  #   ./services
  # ];

  environment = {
    systemPackages = with pkgs; [
      pnpm
      nodejs_24
      yarn
      deno

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
  };

  nix = {
    enable = false;
    # optimise.automatic = false;
    # nix store optimise (manually instead)

    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  homebrew = homebrew-config;

  system = system-config;
}
