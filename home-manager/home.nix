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
in
# user packages, not available in sudo mode
{
  xdg.enable = true;
  home = {
    homeDirectory = home;
    stateVersion = "26.05";

    sessionPath =
      (map (f: "$HOME/${f}") [
        ".cargo/bin"
        ".local/bin"
        ".bun/bin"
        ".pnpm"
        ".cache/.bun/bin"
        ".nix-profile/bin"
        "go/bin"
        # ".rustup/toolchains/esp/xtensa-esp-elf/esp-15.2.0_20250920/xtensa-esp-elf/bin"
      ])
      ++ [
        "/opt/homebrew/bin"
        "/opt/homebrew/opt"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        "/etc/profiles/per-user/$USER/bin"
      ];

    sessionVariables = {
      NX = nix;
      HM = hm;
      DW = path.darwin;
      DOT = dot;
      SCRIPTS = path.scripts;
      SNIPPETS_PATH = path.snippets; # for scls
      SHARE = path.share;

      PNPM_HOME = "${home}/.pnpm";

      EDITOR = "hx";
      CODEX_HOME = "${dot}/codex";
      SOPS_AGE_KEY_FILE = "${nix}/secrets/keys.txt"; # sops key location
      # LIBCLANG_PATH = "${home}/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-20.1.1_20250829/esp-clang/lib";
    };

    # shellAliases = shellAliases;

    file =
      let
        dotfiles = builtins.listToAttrs (
          (lib.mapAttrsToList (k: v: lib.nameValuePair ".config/${k}" v) {
            "zellij" = "zellij";
            "yazelix/yazelix.toml" = "yazelix/yazelix.toml";
            "rio/config.toml" = "rio/config.toml";
          })
          ++ (lib.mapAttrsToList lib.nameValuePair {
            "Library/Application Support/com.mitchellh.ghostty" = "ghostty";
            "Library/Application Support/biome" = "biome";
            ".mpd/mpd.conf" = "mpd/mpd.conf";
            ".local/bin/ra-wrapper" = "Bin/ra-wrapper";
          })
        );
      in
      (lib.mapAttrs (_: path.mkDotFile) dotfiles)
      // {
        # ensure launchd log directory exists so glance can start at login
        "Library/Logs/glance/.keep".text = "";
      };

    packages =
      with pkgs;
      [
        zigpkgs.master

        (pkgs.writeShellApplication {
          name = "ns";
          runtimeInputs = with pkgs; [
            fzf
            nix-search-tv
          ];
          text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
        })
        # signal-cli
        # telegram-bot-api

        ghostscript # pdf utility (ex. merge)
        clipboard-jh

        # esp
        espflash

        typst

        coreutils-full # gnu core utils

        rsync # backup & two-way sync
        restic # efficient & secure backup
        # rustic # restic in rs

        age # encryption tool
        sops # manage secrets

        curlie # curl
        procs # ps
        sd # sed
        mprocs # run multiple commands in parallel
        nix-converter # yaml <-> nix <-> toml
        toolong # log files
        ripgrep
        glow # preview md
        gum # shell script ui
        entr # run command on file change
        serpl # global search and replace
        dust # faster du
        # dua # disk usage manager tui
        dysk # better df (rs)
        # duf # better df (go)
        kondo # clean deps and build artifacts from proj

        # configurable status bar for zelliij
        zjstatus

        tldr # community man
        cht-sh # cli for cheat.sh (comprehensive cheatsheets)
        # tlrc # tldr client in rs

        # gping # ping with a graph
        dnscrypt-proxy
        # openapi-tui
        # sshs

        pocket-tts

        ## data manipulation
        jnv # interactive JSON viewer + jq filter (rs)
        fx # JSON viewer with vim bindings
        jql # query json from cli
        yq-go # YAML, TOML, JSON and XML processor
        dasel # select/put/delete data from files
        hexyl # hex viewer
        sttr # text transformation

        # Rust Dev
        rustup
        cargo-watch
        cargo-make
        cargo-update
        cargo-binstall
        # dioxus-cli

        # other
        mdbook # create book from md files
        mdbook-linkcheck # check links
        # ttyper # terminal typing test
        # lychee # broken links checker
        # puffin # personal finance dashboard
        # bagels # tui expense tracker
        # calcure # tui calendar + task manager
        # ticker # cli stock ticker
        # sc-im # spreadsheet calculator
        # presenterm # md cli slideshow
      ]
      ++ lib.optionals stdenv.isDarwin [
        # for mac-specific packages
        m-cli # useful macOS CLI commands
      ];
  };
}

## Extras (with pkgs;) ##
# go
# go-swag # API docs
# delve # go debugger
# envsubst # env var substitution
# air # live reload for go
# pkgsite # generate docs for go
# errcheck # checks unchecked erros in go
# sqlc # generate type-safe code from SQL
# goose # db migration tool

# ghc
# ghcid
# stack # stack has own version of ghc?
# haskell-language-server
# hlint
# haskellPackages.cabal-install

# elixir_1_18
