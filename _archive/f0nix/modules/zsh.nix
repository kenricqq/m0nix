{
  path,
  lib,
  pkgs,
  ...
}:

let
  inherit (path)
    cache
    ;
in
{
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
      # {
      #   name = "fzf-tab";
      #   src = pkgs.zsh-fzf-tab;
      #   file = "share/fzf-tab/fzf-tab.plugin.zsh";
      # }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    envExtra = ''

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
        source $HOME/.p10k.zsh
      '')
      (lib.mkOrder 1000 ''
        # No terminal bell
        unsetopt BEEP

        if [[ -n "$SCRIPTS" ]]; then
          fpath=("$SCRIPTS" $fpath)
        fi

        # Accept autosuggestion with Ctrl+F (like →)
        bindkey '^F' autosuggest-accept

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
      '')
    ];
  };
}
