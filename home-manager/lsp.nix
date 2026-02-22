{ pkgs, ... }:
{
  programs = {
    # python linter + code formatter
    ruff = {
      enable = true;
      settings = {
        line-length = 100;
        lint = {
          per-file-ignores = {
            "__init__.py" = [ "F401" ];
          };
          select = [
            "E4"
            "E7"
            "E9"
            "F"
          ];
          ignore = [ ];
        };
      };
    };
  };

  home.packages = with pkgs; [
    ### Language Servers

    ## Shell
    # bash-language-server
    fish-lsp
    zsh-completions
    zk

    ## Markup & Config
    tinymist # typst
    typstyle
    markdown-oxide
    mpls # markdown live preview
    # marksman               # Markdown LSP
    taplo # TOML
    simple-completion-language-server # snippets
    kdlfmt # kdl (config for zellij)
    # starpls # starlark
    yaml-language-server

    ## Programming Languages
    # beamMinimal27Packages.elixir-ls # Elixir

    glsl_analyzer

    gopls
    golangci-lint-langserver # Go linter
    gotools # for goimports (formatter)

    # zls

    ty # python (by astral)

    nixd # Nix
    nixfmt # nix official

    lua-language-server
    # rust-analyzer # managed by rustup
    sqls # SQL
    sqruff # SQL formatter
    python313Packages.sqlparse
    # haskellPackages.fourmolu # haskell
    # stylish-haskell # haskell (alt)

    ## Web & Front‑end
    emmet-language-server
    astro-language-server
    svelte-language-server
    # typescript-language-server
    typescript-go
    tailwindcss-language-server
    vscode-langservers-extracted # HTML / CSS / JSON / ESLint
    # efm-langserver # Formatter (wraps Prettier)
    prettier
    # biome # formatter
    dprint
    # uwu-colors # color swatches

    # grammar / spellcheck
    harper
    ltex-ls-plus # for md / tex
    typos-lsp

    # ai
    lsp-ai
  ];
}
