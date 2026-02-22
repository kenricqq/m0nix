{
  lib,
  pkgs,
  path,
  ...
}:

let
  inherit (path)
    dot
    home
    hm
    nix
    ;

  # shellAliases = import ./alias.nix;
  # python-packages = import ./python.nix;
in
# user packages, not available in sudo mode
{
  xdg.enable = true;
  home = {
    # homeDirectory = home;
    stateVersion = "26.05";

    shell.enableNushellIntegration = false;

    packages = with pkgs; [
      zigpkgs.master

      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })

      # helix lsps
      nixd # Nix
      nixfmt # nix official

      typst

      # db
      duckdb # embeddable analytics db
      tigerbeetle # high performance transactional db

      # Zig Dev
      zig

      # Rust Dev
      rustup
      cargo-watch
      cargo-make
      dioxus-cli
      cargo-binstall

      # cli tools
      ripgrep
      serpl # global search and replace
      dust # faster du
      duf # better df
      dysk # disk usage
      curlie # curl
      procs # ps
      sd # sed
      toolong # log files
      kondo # clean deps and build artifacts from proj
      nix-converter

      # RS tools
      hyperfine # cli benchmarking tool
      tokei # count lines of code

      # Encryption
      age # encryption tool
      sops # manage secrets

      # MEDIA (audio / video)
      ffmpeg # cli edit/convert/stream multimedia content

      # Jujutsu
      jjui
      lazyjj

      # dev tools
      dprint
      just # project-level command runner
      lefthook # git hooks manager (like husky)
    ];

    sessionPath =
      (map (f: "$HOME/${f}") [
        ".cargo/bin"
        ".local/bin"
        ".bun/bin"
        ".nix-profile/bin"
        "go/bin"
        # ".rustup/toolchains/esp/xtensa-esp-elf/esp-15.2.0_20250920/xtensa-esp-elf/bin"
      ])
      ++ [
        # "/opt/homebrew/bin"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        "/etc/profiles/per-user/$USER/bin"
      ];

    sessionVariables = {
      NX = nix;
      HM = hm;
      DW = path.darwin;
      # DOT = dot;
      # SCRIPTS = path.scripts;
      # SNIPPETS_PATH = path.snippets; # for scls
      # SHARE = path.share;

      EDITOR = "hx";
      CODEX_HOME = "${dot}/codex";
    };

    # shellAliases = shellAliases;

    file =
      let
        dotfiles = builtins.listToAttrs (
          (lib.mapAttrsToList (k: v: lib.nameValuePair ".config/${k}" v) {
            "zellij" = "zellij";
            # "nushell".source = ~/dotfiles/nushell;
          })
          ++ (lib.mapAttrsToList lib.nameValuePair {
          })
        );
      in
      (lib.mapAttrs (_: path.mkDotFile) dotfiles);
  };
}
