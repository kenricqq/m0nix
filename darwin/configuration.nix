{ pkgs, ... }:

let
  system-config = import ./system.nix;

in
{
  imports = [
    ./homebrew.nix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = "$HOME/Documents/wallpaper/code.jpg";
    # image = pkgs.fetchurl {
    #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    #   hash = "sha256-enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    # };
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      nodejs_24
      fish

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

  system = system-config;
}
