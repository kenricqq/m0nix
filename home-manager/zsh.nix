{
  config,
  lib,
  pkgs,
  path,
  ...
}:

let
  inherit (path)
    cache
    ;

  brewEnv = "${cache}/zsh/brew-shellenv.zsh";

  secretsFile = ../secrets/secrets.yaml;
  secretList = ../secrets/secrets.list; # generated outside with yq
  secretNames = lib.remove "" (lib.splitString "\n" (builtins.readFile secretList));

  # Create decrypted file at activation with strict permissions; contains only raw token.
  secretsAttrset = lib.genAttrs secretNames (name: {
    path = "${path.home}/.config/zsh/secrets/${name}";
    mode = "0400";
  });
in
{
  sops = {
    defaultSopsFile = secretsFile;
    age.keyFile = "${path.nix}/secrets/keys.txt";
    secrets = secretsAttrset;
  };
  home.activation = {
    renderSecretsEnv = lib.hm.dag.entryAfter [ "writeBoundary" "sops" ] ''
      out="${cache}/zsh/secrets.env"
      umask 077
      {
        ${lib.concatStringsSep "\n" (
          map (name: ''printf 'export %s=%q\n' ${name} "$(<'${secretsAttrset.${name}.path}')" '') secretNames
        )}
      } > "$out.tmp"
      mv "$out.tmp" "$out"
    '';
    cacheBrewEnv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ -x /opt/homebrew/bin/brew ]]; then
      mkdir -p "${cache}/zsh"
      /opt/homebrew/bin/brew shellenv >| "${cache}/zsh/brew-shellenv.zsh"
      fi
    '';
  };
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "viins";
    autosuggestion = {
      enable = true;
      # highlight = "fg=#ff00ff,bg=#00ff00,bold,underline";
      strategy = [
        "completion"
        "history"
        "match_prev_cmd"
      ];
    };

    # We’ll do our own compinit so we can pass -C and custom dump
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      dump="${cache}/zsh/zcompdump-$ZSH_VERSION"
      mkdir -p "''${dump:h}"
      # -C: skip security checks; -d: versioned dump path
      compinit -C -d "$dump"
    '';

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      # {
      #   name = "you-should-use";
      #   src = pkgs.zsh-you-should-use;
      #   file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      # }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    envExtra = ''
      # export STARSHIP_CACHE="${cache}/starship"
    '';

    initContent = lib.mkMerge [
      (lib.mkOrder 50 ''
        typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (lib.mkOrder 500 ''
        # typeset -g POWERLEVEL9K_GITSTATUS_DIR="${cache}/p10k-gitstatus"
        # mkdir -p "$POWERLEVEL9K_GITSTATUS_DIR"
      '')
      (lib.mkOrder 550 ''
        source $HM/dotfiles/p10k/.p10k.zsh
      '')
      # source sops secrets file
      (lib.mkOrder 900 ''
        if [[ -r "${cache}/zsh/secrets.env" ]]; then
          source "${cache}/zsh/secrets.env"
        fi
      '')
      (lib.mkOrder 1000 ''
        # No terminal bell
        unsetopt BEEP

        if [[ -n "$SCRIPTS" ]]; then
          fpath=("$SCRIPTS" $fpath)
        fi

        # Accept autosuggestion with Ctrl+F (like →)
        bindkey '^F' autosuggest-accept

        # Optional: cache Homebrew shellenv once; source thereafter
        if [[ -x /opt/homebrew/bin/brew ]]; then
          _brew_env="${brewEnv}"
          if [[ -r "$_brew_env" ]]; then
            source "$_brew_env"
          else
            mkdir -p "''${_brew_env:h}"
            /opt/homebrew/bin/brew shellenv >| "$_brew_env"
            source "$_brew_env"
          fi
        fi

        # --- Fix A: compile NEXT TO the source and source the TEXT file ---
        # Clean out any cache-based .zwc from earlier experiments
        rm -f -- "${cache}/zwc/utils.zsh.zwc" 2>/dev/null || true

        if [[ -n "$SCRIPTS" && -r "$SCRIPTS/utils.zsh" ]]; then
          # Build or refresh $SCRIPTS/utils.zsh.zwc alongside the source
          if [[ ! -r "$SCRIPTS/utils.zsh.zwc" || "$SCRIPTS/utils.zsh" -nt "$SCRIPTS/utils.zsh.zwc" ]]; then
            zcompile -U -- "$SCRIPTS/utils.zsh"
          fi
          # Source the *text* file; zsh will prefer the adjacent .zwc automatically
          source "$SCRIPTS/utils.zsh"
        fi

        # Enable pay-respects only when nix-index DB exists
        # if command -v pay-respects >/dev/null; then
        #   if [[ -r "${cache}/nix-index/files" ]]; then
        #     eval "$(pay-respects zsh --alias)"
        #   fi
        # fi

        # for secretive
        export SSH_AUTH_SOCK=$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

        # for mkdocs
        # After sourcing the cached brew env earlier, prefer its variables.
        if [[ -n "$HOMEBREW_PREFIX" ]]; then
          export DYLD_FALLBACK_LIBRARY_PATH="$HOMEBREW_PREFIX/lib''${DYLD_FALLBACK_LIBRARY_PATH:+:$DYLD_FALLBACK_LIBRARY_PATH}"
        fi
      '')
    ];
  };
}
