{ pkgs, scls, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    ignores = [
      ".build/"
      "!.gitignore"
      "!.env*"
    ];
    extraPackages = with pkgs; [
      ### Language Servers

      ## Shell
      # bash-language-server
      fish-lsp
      zsh-completions
      zk

      ## Markup & Config
      tinymist # typst
      markdown-oxide
      mpls # markdown live preview
      # marksman               # Markdown LSP
      taplo # TOML
      # scls # snippets
      kdlfmt # kdl (config for zellij)

      ## Programming Languages
      beamMinimal27Packages.elixir-ls # Elixir

      glsl_analyzer

      gopls
      golangci-lint-langserver # Go linter
      gotools # for goimports (formatter)

      zig
      zls

      python312Packages.python-lsp-server
      pyright
      pylyzer # static code analyzer (rust)

      # nixd # Nix
      # nixfmt-rfc-style # nix official

      beamMinimal27Packages.elixir-ls # elixir-ls
      lua-language-server
      rust-analyzer
      sqls # SQL
      sqruff # SQL formatter
      python313Packages.sqlparse
      haskellPackages.fourmolu # haskell
      # stylish-haskell # haskell (alt)

      ## Web & Front‑end
      emmet-language-server
      astro-language-server
      svelte-language-server
      typescript-language-server
      tailwindcss-language-server
      stylelint-lsp
      vscode-langservers-extracted # HTML / CSS / JSON / ESLint
      # efm-langserver # Formatter (wraps Prettier)
      prettier
      biome # formatter
      dprint
      # uwu-colors # color swatches

      # grammar / spellcheck
      harper
      ltex-ls-plus # for md / tex
      typos-lsp

      # ai
      lsp-ai
    ];

    # [[language]]
    # name = "mylang"
    # scope = "source.mylang"
    # injection-regex = "mylang"
    # file-types = ["mylang", "myl"]
    # comment-tokens = "#"
    # indent = { tab-width = 2, unit = "  " }
    # formatter = { command = "mylang-formatter" , args = ["--stdin"] }
    # language-servers = [ "mylang-lsp" ]

    # extraConfig = builtins.readFile ./language.toml;
    languages = {
      language = [
        {
          name = "bash";
          auto-format = true;
          file-types = [
            "bash"
            "zsh"
            "sh"
          ];
        }
        {
          name = "kdl";
          auto-format = true;
        }
        {
          name = "typst";
          auto-format = true;
          formatter = {
            command = "typstyle";
          };
          language-servers = [
            "tinymist"
            "typstyle"
          ];
        }
        {
          name = "sql";
          auto-format = true;
          # formatter = {
          #   command = "sqlformat";
          #   args = [
          #     "--reindent"
          #     "--indent_width"
          #     "2"
          #     "--keywords"
          #     "upper"
          #     "--identifiers"
          #     "lower"
          #     "-"
          #   ];
          # };
          formatter = {
            command = "sqruff";
            args = [
              "fix"
              "-"
            ];
          };
          language-servers = [
            # "sql-language-server"
            "sqls"
            # "sqruff"
          ];
        }
        {
          name = "go";
          auto-format = true;
          formatter = {
            command = "goimports";
          };
          language-servers = [
            "gopls"
            "golangci-lint-langserver"
            "scls"
          ];
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = "taplo";
            args = [
              "format"
              "-"
            ];
          };
          language-servers = [
            "taplo"
          ];
        }
        {
          name = "yaml";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "yaml"
            ];
          };
        }
        {
          name = "python";
          auto-format = true;

          language-servers = [
            "pyright"
            "ruff"
            "pylsp"
            "lsp-ai"
            # "pylyzer"
          ];
          formatter = {
            command = "bash";
            args = [
              "-c"
              "ruff check --fix - | ruff format -"
            ];
          };
          scope = "source.python";
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
          # auto-format = true;
          language-servers = [
            "nixd"
          ];
        }
        {
          name = "haskell";
          auto-format = true;
          language-servers = [
            "haskell-language-server"
            "hlint"
            "scls"
          ];
        }
        {
          name = "c";
          auto-format = true;
          formatter = {
            command = "clang-format";
          };
          indent = {
            tab-width = 4;
            unit = "    ";
          };
          language-servers = [
            "scls"
          ];
        }
        {
          name = "rust";
          auto-format = true;
          # formatter = {
          #   command = "bash";
          #   args = [
          #     "-c"
          #     "rustfmt | dx fmt -f -"
          #   ];
          # };
          language-servers = [
            "rust-analyzer"
            "scls"
          ];
        }
        {
          name = "astro";
          auto-format = true;
          formatter = {
            command = "dprint";
            args = [
              "fmt"
              "--stdin"
              "astro"
            ];
          };
          language-servers = [
            "astro-ls"
            "scls"
          ];
        }
        {
          name = "markdown";
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "markdown"
            ];
          };
          roots = [ ".zk" ];
          language-servers = [
            # "typos"
            "markdown-oxide"
            "mpls"
            "zk-lsp"
            # "marksman"
            # "harper-ls"
            # "ltex-ls-plus"
            "scls"
          ];
        }
        {
          name = "svelte";
          auto-format = true;
          block-comment-tokens = {
            start = "<!--";
            end = "-->";
          };
          formatter = {
            command = "dprint";
            args = [
              "fmt"
              "svelte"
              "--stdin"
            ];
          };
          language-servers = [
            # "biome"
            "svelteserver"
            "tailwindcss-ls"

            "scls"

            # "emmet-lsp"
            "typescript-language-server"
          ];
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"

            # "scls"
            # "emmet-lsp"
          ];
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "tsx";
          auto-format = true;
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"

            "scls"
            "emmet-lsp"
          ];
        }
        {
          name = "jsx";
          auto-format = true;
          # formatter = {
          #   command = "biome";
          #   args = [
          #     "format"
          #     "--stdin-file-path"
          #     "buffer.jsx"
          #   ];
          # };
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"

            "scls"
            "emmet-lsp"
          ];
        }
        {
          name = "json";
          auto-format = true;
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "just";
          auto-format = true;
          formatter = {
            command = "just";
            args = [
              "--justfile"
              "/dev/stdin"
              "--dump"
            ];
          };
        }
        {
          name = "html";
          language-servers = [
            "biome"
            "vscode-html-language-server"
            "tailwindcss-ls"
            "scls"
          ];
        }
        {
          name = "css";
          file-types = [
            "css"
          ];
          auto-format = true;
          formatter = {
            command = "biome";
            args = [
              "format"
              "--stdin-file-path"
              "buffer.css"
            ];
          };
          language-servers = [
            "stylelint-ls"
            "vscode-css-language-server"
            "emmet-ls"
            "tailwindcss-ls"
            "scls"
            "biome"
          ];
        }
      ];

      language-server = {
        zk-lsp = {
          command = "zk";
          args = [ "lsp" ];
        };
        sqruff = {
          command = "sqruff";
          args = [ "lsp" ];
          config = {
            dialect = "postgres";
            exclude_rules = [
              "LT12"
              "L009"
            ]; # L009
          };
        };
        sqls = {
          command = "sqls";
        };
        sql-language-server = {
          command = "sql-language-server";
          args = [
            "up"
            "--method"
            "stdio"
          ];
        };
        mpls = {
          command = "mpls";
          args = [
            "--dark-mode"
            "--enable-emoji"
            "--no-auto"
          ];
        };
        stylelint-ls = {
          command = "stylelint-lsp";
          args = [ "--stdio" ];
          config = {
            stylelintplus = {
              autoFixOnSave = true;
              autoFixOnFormat = true;
              config = {
                extends = [
                  "stylelint-config-standard-scss"
                ];
                rules = {
                  function-no-unknown = [
                    true
                    { ignoreFunctions = [ "theme" ]; }
                  ];
                  at-rule-no-unknown = [
                    true
                    {
                      ignoreAtRules = [
                        "apply"
                        "screen"
                        "tailwind"
                        "config"
                        "layer"
                        "variants"
                        "responsive"
                      ];
                    }
                  ];
                };
              };
            };
          };
        };
        biome = {
          command = "biome";
          args = [ "lsp-proxy" ];
          display-messages = true;
        };
        lsp-ai = {
          command = "lsp-ai";
          config = {
            memory = {
              file_store = { };
            };
            models = {
              model1 = {
                type = "anthropic";
                chat_endpoint = "https://api.anthropic.com/v1/messages";
                model = "claude-3-5-haiku-latest";
                auth_token_env_var_name = "ANTHROPIC_API_KEY";
              };
            };
            chat = [
              {
                trigger = "!C";
                action_display_name = "Chat";
                model = "model1";
                parameters = {
                  max_context = 4096;
                  max_tokens = 1024;
                  system = "You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately";
                };
              }
            ];
          };
        };

        # Python
        pylsp = {
          config.pylsp.plugins = {
            flake8.enabled = false;
            autopep8.enabled = false;
            mccabe.enabled = false;
            pycodestyle.enabled = false;
            pyflakes.enabled = false;
            pylint.enabled = false;
            yapf.enabled = false;
            ruff.enabled = false;
          };
        };
        pyright.config.python.analysis = {
          typeCheckingMode = "basic";
        };
        ruff = {
          command = "ruff";
          args = [ "server" ];
        };
        pylyzer = {
          command = "pylyzer";
          args = [ "--server" ];
        };

        # Astro
        astro-ls = {
          command = "astro-ls";
          args = [ "--stdio" ];
          config = {
            typescript = {
              tsdk = "/Users/user/.bun/install/global/node_modules/typescript/lib";
            };
            environment = "node";
          };
        };

        harper-ls = {
          command = "harper-ls";
          args = [ "--stdio" ];
          config = {
            harper-ls.linters = {
              linters.spaces = false;
            };
          };
        };

        haskell-language-server = {
          config = {
            formattingProvider = "fourmolu";
            # formattingProvider = "stylish-haskell";
          };
        };

        rust-analyzer = {
          config = {
            check.command = "clippy";
            cargo.features = "all";
          };
        };

        scls = {
          command = "simple-completion-language-server";
          config = {
            max_completion_items = 10; # set max completion results len for each group: words, snippets, unicode-input
            feature_words = true; # enable completion by word
            feature_snippets = true; # enable snippets
            snippets_first = true; # completions will return before snippets by default
            snippets_inline_by_word_tail = false; # suggest snippets by WORD tail, for example text `xsq|` become `x^2|` when snippet `sq` has body `^2`
            feature_unicode_input = false; # enable "unicode input"
            feature_paths = false; # enable path completion
            feature_citations = false; # enable citation completion (only on `citation` feature enabled)
          };
          environment = {
            RUST_LOG = "info,simple-completion-language-server=info";
            LOG_FILE = "/tmp/completion.log";
          };
        };
        svelteserver = {
          command = "svelteserver";
          args = [ "--stdio" ];
          config = {
            validate = true;
            useWorkspaceDependencies = true;
            hover = true;
          };
        };
        emmet-lsp = {
          command = "emmet-language-server";
          args = [ "--stdio" ];
        };
        tailwind-ls = {
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };
        # unocss-ls = {
        #   command = "unocss-language-server";
        #   args = [ "--stdio" ];
        # };
        typos = {
          command = "typos-lsp";
          # Logging level of the language server. Defaults to error.
          # Run with helix -v to output LSP logs to the editor log (:log-open)
          environment = {
            "RUST_LOG" = "error";
          };
          # Custom config. Used together with a config file found in the workspace or its parents,
          # taking precedence for settings declared in both. Equivalent to the typos `--config` cli argument.
          config.config = "~/code/typos-lsp/crates/typos-lsp/tests/typos.toml";
          # How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
          # Defaults to Warning.
          config.diagnosticSeverity = "Warning";
        };
      };

    };
    settings = {
      theme = "nightfox";
      # theme = "horizon-dark";
      # theme = "kanagawa";
      # voxed, ao, horizon-dark, gruvbox_dark_hard, ayu_evolve, tokyonight, doom_acario_dark, kaolin_valley_dark, ayu_dark, material_deep_ocean, monokai_pro_octagon, poimandres, starlight, term16_dark, varua
      editor = {
        auto-save = {
          focus-lost = true;
          # after-delay.enable = true;
          # after-delay.timeout = 300;
        };
        auto-format = true;
        bufferline = "multiple";
        color-modes = true;
        completion-timeout = 5;
        # completion-trigger-len = 2;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        end-of-line-diagnostics = "hint";
        file-picker = {
          hidden = false;
          git-ignore = true;
        };
        idle-timeout = 50;
        indent-guides = {
          render = true;
          character = " ";
        };
        inline-diagnostics = {
          cursor-line = "info";
        };
        line-number = "relative";
        lsp = {
          display-inlay-hints = true;
        };
        scrolloff = 10;
        # shell = [
        #   "zsh"
        #   "-ic"
        # ];
        soft-wrap = {
          enable = true;
          # max-wrap = 25; # increase value to reduce forced mid-word wrapping
          # max-indent-retain = 0; max indent to carry over when soft wrapping a line.
          # wrap-indicator = "";
        };
        statusline = {
          # left = ["mode" "spacer"  "spinner"  "spacer"  "version-control"  "file-name"  "file-modification-indicator"];
          # right = ["diagnostics"  "version-control"  "selections"  "position"  "total-line-numbers"  "file-encoding"  "file-type"];
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-type"
            "total-line-numbers"
            "file-encoding"
          ];
          right = [
            "selections"
            "primary-selection-length"
            "position"
            "position-percentage"
            "spacer"
            "diagnostics"
            "workspace-diagnostics"
            "version-control"
          ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
      };
      # keys.picker = { # doesn't exist yet 😭
      #   "C-k" = "previous_entry";
      #   "C-j" = "next_entry";
      # };

      keys = {
        normal = {
          "C-r" = ":reset-diff-change";
          "C-w" = {
            "d" = "wclose";
          };
          space = {
            "S-w" = ":write-quit";

            B = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";

            C-h = [
              ":new"
              ":insert-output gh-dash"
              ":buffer-close!"
              ":redraw"
            ];

            C-s = [
              ":new"
              ":insert-output serpl"
              ":buffer-close!"
              ":redraw"
            ];

            z = ":sh zed-preview .";
          };
          "S-m" = "@mim"; # @ for macro
          "S-d" = [
            "select_mode"
            "search_selection"
            "search_next"
            "normal_mode"
          ];
          "Cmd-d" = [
            "keep_primary_selection"
            "move_prev_word_start"
            "move_next_word_end"
            "search_selection"
            "select_mode"
          ];

          "S-ret" = "goto_word";

          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          y = [
            "yank_main_selection_to_clipboard"
            "yank"
          ];
          p = [
            "paste_after"
          ];
          d = [
            "delete_selection"
            "yank_to_clipboard"
          ];
          "C-;" = "flip_selections";

          # C-y = ":sh zellij run -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh open";

          g = {
            j = [ "move_visual_line_down" ];
            k = [ "move_visual_line_up" ];
          };

          # j = [ "move_line_down" ];
          # k = [ "move_line_up" ];
          j = [
            "move_line_down"
            "align_view_center"
          ];
          k = [
            "move_line_up"
            "align_view_center"
          ];
          X = "extend_line_above";
          "}" = [
            "goto_next_paragraph"
            "collapse_selection"
          ];
          "{" = [
            "goto_prev_paragraph"
            "collapse_selection"
          ];
          C-g = [
            ":new"
            ":insert-output lazygit"
            ":buffer-close!"
            ":redraw"
          ];
          C-j = [
            "extend_to_line_bounds"
            "delete_selection"
            "paste_after"
          ];
          C-k = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
          ];
          C-n = [
            "scroll_down"
            "scroll_down"
            "scroll_down"
          ];
          C-p = [
            "scroll_up"
            "scroll_up"
            "scroll_up"
          ];
        };

        select = {
          "{" = [ "goto_prev_paragraph" ];
          "}" = [ "goto_next_paragraph" ];
          # a = [
          #   "yank_to_clipboard"
          #   ":sh helix-wezterm.sh ai"
          # ];
        };
      };
    };
  };
}

## simulates CMD-D add next occurence of word
# [keys.normal]
# # make sure there is only one selection, select word under cursor, set search to selection, then switch to select mode
# "C-d" = ["keep_primary_selection", "move_prev_word_start", "move_next_word_end", "search_selection", "select_mode"]

# [keys.select]
# # if already in select mode, just add new selection at next occurrence
# "C-d" = ["search_selection", "extend_search_next"]

# "Ctrl-u" = ["page_cursor_half_up" "align_view_center"];
# "Ctrl-d" = ["page_cursor_half_down" "align_view_center" ];

# # Some nice Helix stuff
# C-h = "select_prev_sibling"
# C-j = "shrink_selection"
# C-k = "expand_selection"
# C-l = "select_next_sibling"

# # Muscle memory
# "{" = ["goto_prev_paragraph", "collapse_selection"]
# "}" = ["goto_next_paragraph", "collapse_selection"]
# 0 = "goto_line_start"
# "$" = "goto_line_end"
# "^" = "goto_first_nonwhitespace"
# G = "goto_file_end"
# "%" = "match_brackets"
# V = ["select_mode", "extend_to_line_bounds"]
# D = ["extend_to_line_end", "yank_main_selection_to_clipboard", "delete_selection"]
# S = "surround_add" # Would be nice to be able to do something after this but it isn't chainable

# # Clipboards over registers ye ye
# x = "delete_selection"
# p = ["paste_clipboard_after", "collapse_selection"]
# P = ["paste_clipboard_before", "collapse_selection"]
# # Would be nice to add ya and yi, but the surround commands can't be chained
# Y = ["extend_to_line_end", "yank_main_selection_to_clipboard", "collapse_selection"]

# # Uncanny valley stuff, this makes w and b behave as they do Vim
# w = ["move_next_word_start", "move_char_right", "collapse_selection"]
# W = ["move_next_long_word_start", "move_char_right", "collapse_selection"]
# e = ["move_next_word_end", "collapse_selection"]
# E = ["move_next_long_word_end", "collapse_selection"]
# b = ["move_prev_word_start", "collapse_selection"]
# B = ["move_prev_long_word_start", "collapse_selection"]

# # If you want to keep the selection-while-moving behaviour of Helix, this two lines will help a lot,
# # especially if you find having text remain selected while you have switched to insert or append mode
# #
# # There is no real difference if you have overridden the commands bound to 'w', 'e' and 'b' like above
# # But if you really want to get familiar with the Helix way of selecting-while-moving, comment the
# # bindings for 'w', 'e', and 'b' out and leave the bindings for 'i' and 'a' active below. A world of difference!
# i = ["insert_mode", "collapse_selection"]
# a = ["append_mode", "collapse_selection"]

# # Undoing the 'd' + motion commands restores the selection which is annoying
# u = ["undo", "collapse_selection"]

# # Search for word under cursor
# "*" = ["move_char_right", "move_prev_word_start", "move_next_word_end", "search_selection", "search_next"]
# "#" = ["move_char_right", "move_prev_word_start", "move_next_word_end", "search_selection", "search_prev"]

# # Make j and k behave as they do Vim when soft-wrap is enabled
# j = "move_line_down"
# k = "move_line_up"

# # Extend and select commands that expect a manual input can't be chained
# # I've kept d[X] commands here because it's better to at least have the stuff you want to delete
# # selected so that it's just a keystroke away to delete
# [keys.normal.d]
# d = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection"]
# t = ["extend_till_char"]
# s = ["surround_delete"]
# i = ["select_textobject_inner"]
# a = ["select_textobject_around"]
# j = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
# down = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
# k = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
# up = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
# G = ["select_mode", "extend_to_line_bounds", "goto_last_line", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
# w = ["move_next_word_start", "yank_main_selection_to_clipboard", "delete_selection"]
# W = ["move_next_long_word_start", "yank_main_selection_to_clipboard", "delete_selection"]
# g = { g = ["select_mode", "extend_to_line_bounds", "goto_file_start", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"] }

# [keys.normal.y]
# y = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "normal_mode", "collapse_selection"]
# j = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
# down = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
# k = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
# up = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
# G = ["select_mode", "extend_to_line_bounds", "goto_last_line", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
# w = ["move_next_word_start", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
# W = ["move_next_long_word_start", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
# g = { g = ["select_mode", "extend_to_line_bounds", "goto_file_start", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"] }

# [keys.insert]
# # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
# esc = ["collapse_selection", "normal_mode"]

# [keys.select]
# # Muscle memory
# "{" = ["extend_to_line_bounds", "goto_prev_paragraph"]
# "}" = ["extend_to_line_bounds", "goto_next_paragraph"]
# 0 = "goto_line_start"
# "$" = "goto_line_end"
# "^" = "goto_first_nonwhitespace"
# G = "goto_file_end"
# D = ["extend_to_line_bounds", "delete_selection", "normal_mode"]
# C = ["goto_line_start", "extend_to_line_bounds", "change_selection"]
# "%" = "match_brackets"
# S = "surround_add" # Basically 99% of what I use vim-surround for
# u = ["switch_to_lowercase", "collapse_selection", "normal_mode"]
# U = ["switch_to_uppercase", "collapse_selection", "normal_mode"]

# # Visual-mode specific muscle memory
# i = "select_textobject_inner"
# a = "select_textobject_around"

# # Some extra binds to allow us to insert/append in select mode because it's nice with multiple cursors
# tab = ["insert_mode", "collapse_selection"] # tab is read by most terminal editors as "C-i"
# C-a = ["append_mode", "collapse_selection"]

# # Make selecting lines in visual mode behave sensibly
# k = ["extend_line_up", "extend_to_line_bounds"]
# j = ["extend_line_down", "extend_to_line_bounds"]

# # Clipboards over registers ye ye
# d = ["yank_main_selection_to_clipboard", "delete_selection"]
# x = ["yank_main_selection_to_clipboard", "delete_selection"]
# y = ["yank_main_selection_to_clipboard", "normal_mode", "flip_selections", "collapse_selection"]
# Y = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "goto_line_start", "collapse_selection", "normal_mode"]
# p = "replace_selections_with_clipboard" # No life without this
# P = "paste_clipboard_before"

# # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
# esc = ["collapse_selection", "keep_primary_selection", "normal_mode"]

### DOTFILES CONFIG
# [editor]
# auto-save=true
# bufferline = "multiple"

# [editor.cursor-shape]
# normal = "block"
# insert = "bar"
# select = "underline"

# [editor.file-picker]
# hidden = false

# [editor.indent-guides]
# render = true
# character = "|" # Some characters that work well: "▏", "┆", "┊", "⸽"
# skip-levels = 1

# [editor.statusline]
# left = ["mode", "spinner"]
# center = ["file-name"]
# right = ["diagnostics", "selections", "position", "file-encoding", "file-line-ending", "file-type"]
# separator = "│"
# mode.normal = "NORMAL"
# mode.insert = "INSERT"
# mode.select = "SELECT"

# [keys.normal]
# "{" = ["goto_prev_paragraph", "collapse_selection"]
# "}" = ["goto_next_paragraph", "collapse_selection"]
# 0 = "goto_line_start"
# "$" = "goto_line_end"
# G = "goto_file_end"
# V = ["select_mode", "extend_to_line_bounds"]
# Z = { Z = ":x" }

# x = "delete_selection"

# #C-f = [":new", ":insert-output lf-pick", ":theme default", "select_all", "split_selection_on_newline", "goto_file", "goto_last_modified_file", ":buffer-close!", ":theme darcula"]

# [keys.normal.d]
# d = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection"]

# [keys.normal.y]
# y = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "normal_mode", "collapse_selection"]

# [keys.normal.";"]
# r = ":sh run.sh %val{filename} > /tmp/run.log 2>&1"
# g = ":sh lazygit.sh"

# [keys.select]
# "{" = ["extend_to_line_bounds", "goto_prev_paragraph"]
# "}" = ["extend_to_line_bounds", "goto_next_paragraph"]
# G = "goto_file_end"

# k = ["extend_line_up", "extend_to_line_bounds"]
# j = ["extend_line_down", "extend_to_line_bounds"]

# x = ["yank_main_selection_to_clipboard", "delete_selection"]

# [keys.insert]
# "C-t" = "indent"
# "C-d" = "unindent"
# themes = {
#   base16 = let
#     transparent = "none";
#     gray = "#665c54";
#     dark-gray = "#3c3836";
#     white = "#fbf1c7";
#     black = "#282828";
#     red = "#fb4934";
#     green = "#b8bb26";
#     yellow = "#fabd2f";
#     orange = "#fe8019";
#     blue = "#83a598";
#     magenta = "#d3869b";
#     cyan = "#8ec07c";
#   in {
#     "ui.menu" = transparent;
#     "ui.menu.selected" = { modifiers = [ "reversed" ]; };
#     "ui.linenr" = { fg = gray; bg = dark-gray; };
#     "ui.popup" = { modifiers = [ "reversed" ]; };
#     "ui.linenr.selected" = { fg = white; bg = black; modifiers = [ "bold" ]; };
#     "ui.selection" = { fg = black; bg = blue; };
#     "ui.selection.primary" = { modifiers = [ "reversed" ]; };
#     "comment" = { fg = gray; };
#     "ui.statusline" = { fg = white; bg = dark-gray; };
#     "ui.statusline.inactive" = { fg = dark-gray; bg = white; };
#     "ui.help" = { fg = dark-gray; bg = white; };
#     "ui.cursor" = { modifiers = [ "reversed" ]; };
#     "variable" = red;
#     "variable.builtin" = orange;
#     "constant.numeric" = orange;
#     "constant" = orange;
#     "attributes" = yellow;
#     "type" = yellow;
#     "ui.cursor.match" = { fg = yellow; modifiers = [ "underlined" ]; };
#     "string" = green;
#     "variable.other.member" = red;
#     "constant.character.escape" = cyan;
#     "function" = blue;
#     "constructor" = blue;
#     "special" = blue;
#     "keyword" = magenta;
#     "label" = magenta;
#     "namespace" = blue;
#     "diff.plus" = green;
#     "diff.delta" = yellow;
#     "diff.minus" = red;
#     "diagnostic" = { modifiers = [ "underlined" ]; };
#     "ui.gutter" = { bg = black; };
#     "info" = blue;
#     "hint" = dark-gray;
#     "debug" = dark-gray;
#     "warning" = yellow;
#     "error" = red;
#   };
# };

# { config, lib, pkgs, inputs, ... } @ args:
# with lib; let
#   cfg = config.ncfg.cli.helix;

#   base = home: {
#     # imports = [ ];
#     programs.git.extraConfig.core.editor = lib.mkOverride 100 "hx";
#     programs.helix = {
#       enable = true;
#       # package = inputs.helix.packages.${pkgs.system}.default;
#       package = inputs.helix.packages.${pkgs.system}.default.overrideAttrs (self: {
#         makeWrapperArgs = with pkgs;
#           self.makeWrapperArgs or [ ] ++ [
#             "--suffix"
#             "PATH"
#             ":"
#             (lib.makeBinPath [
#               # Debugging stuff
#               lldb

#               # clang-tools # C-Style
#               cmake-language-server
#               jsonnet-language-server
#               # dart
#               xsel
#               # haskell-language-server # Haskell
#               julia-bin # Julia
#               luaformatter
#               elixir_ls # Elixir
#               marksman # Markdown
#               ltex-ls
#               # solargraph # Ruby
#               # go # Go
#               # gopls # Go
#               texlab # LaTeX
#               taplo # Toml
#               # (rustPlatform.buildRustPackage {
#               #   pname = "taplo";
#               #   version = "0.8.2-git";
#               #   src = inputs.taplo;
#               #   # cargoSha256 = ""; # when updating the flake input, necessary for new hash...
#               #   cargoSha256 = "sha256-UFj8oqLJdX0AWnW2a4qJCZ7EyvkZ5yUhheooiDO3V6w=";
#               #   buildFeatures = [ "lsp" ];
#               # }) # Toml
#               pgformatter
#               # kotlin-language-server # Kotlin
#               # nickel.packages.${pkgs.system}.default
#               (python3.withPackages (ps: with ps; [ python-lsp-server ] ++ python-lsp-server.optional-dependencies.all))
#               nixd # Nix
#               nodePackages.bash-language-server # Bash
#               nodePackages.dockerfile-language-server-nodejs
#               nodePackages.pyright # Python
#               nodePackages.stylelint
#               # nodePackages.svelte-language-server # Svelte
#               nodePackages.vls
#               nodePackages.vim-language-server
#               nodePackages.vscode-langservers-extracted
#               nodePackages.yaml-language-server # YAML / JSON
#               # ocamlPackages.ocaml-lsp # Ocaml
#               # ocamlPackages.dune_3 # Ocaml
#               # opam # Ocaml
#               # ocamlPackages.reason # Ocaml
#               pkgs.dotnet-sdk
#               pkgs.omnisharp-roslyn # .NET
#               pkgs.msbuild
#               ripgrep
#               rnix-lsp
#               # java-language-server
#               sumneko-lua-language-server # Lua
#               yapf
#               zathura
#               # zls # Zig
#             ])
#             "--set-default"
#             "RUST_SRC_PATH"
#             "${rustPlatform.rustcSrc}/library"
#           ];
#       });

#       languages = with pkgs;
#         {
#           language-server = {
#             efm-lsp-prettier = {
#               command = "${efm-langserver}/bin/efm-langserver";
#               config = {
#                 documentFormatting = true;
#                 languages = lib.genAttrs [ "typescript" "javascript" "typescriptreact" "javascriptreact" "vue" "json" "markdown" ] (_: [{
#                   formatCommand = "${nodePackages.prettier}/bin/prettier --stdin-filepath \${INPUT}";
#                   formatStdin = true;
#                 }]);
#               };
#             };
#             eslint = {
#               command = "vscode-eslint-language-server";
#               args = [ "--stdio" ];
#               config = {
#                 validate = "on";
#                 packageManager = "yarn";
#                 useESLintClass = false;
#                 codeActionOnSave.mode = "all";
#                 # codeActionsOnSave = { mode = "all"; };
#                 format = true;
#                 quiet = false;
#                 onIgnoredFiles = "off";
#                 rulesCustomizations = [ ];
#                 run = "onType";
#                 # nodePath configures the directory in which the eslint server should start its node_modules resolution.
#                 # This path is relative to the workspace folder (root dir) of the server instance.
#                 nodePath = "";
#                 # use the workspace folder location or the file location (if no workspace folder is open) as the working directory

#                 workingDirectory.mode = "auto";
#                 experimental = { };
#                 problems.shortenToSingleLine = false;
#                 codeAction = {
#                   disableRuleComment = {
#                     enable = true;
#                     location = "separateLine";
#                   };
#                   showDocumentation.enable = true;
#                 };
#               };
#             };

#             typescript-language-server = {
#               command = "${nodePackages.typescript-language-server}/bin/typescript-language-server";
#               args = [ "--stdio" "--tsserver-path=${nodePackages.typescript}/lib/node_modules/typescript/lib" ];
#               config.documentFormatting = false;
#             };

#             nixd = {
#               command = "${inputs.nixd.packages.${pkgs.system}.default}/bin/nixd";
#               # command = "nixd";
#               config.nixd = {
#                 formatting.command = [ "${nixpkgs-fmt}/bin/nixpkgs-fmt" ];
#                 # formatting.command = [ "alejandra" "-q" ];
#                 nix.flake.autoEvalInputs = true;
#               };
#             };
#             # lexical = {
#             #   command = "${inputs.lexical.packages.${pkgs.system}.default}/bin/lexical";
#             #   config.lexical = {
#             #     # formatting.command = [ "${nixpkgs-fmt}/bin/nixpkgs-fmt" ];
#             #   };
#             # };
#             ltex-ls.command = "ltex-ls";
#             rust-analyzer = {
#               config.rust-analyzer = {
#                 cargo.loadOutDirsFromCheck = true;
#                 checkOnSave.command = "clippy";
#                 procMacro.enable = true;
#                 lens = { references = true; methodReferences = true; };
#                 completion.autoimport.enable = true;
#                 experimental.procAttrMacros = true;
#               };
#             };
#             omnisharp = { command = "omnisharp"; args = [ "-l" "Error" "--languageserver" "-z" ]; };
#           };
#           language =
#             let
#               jsTsWebLanguageServers =
#                 [
#                   { name = "typescript-language-server"; except-features = [ "format" ]; }
#                   "eslint"
#                   { name = "efm-lsp-prettier"; only-features = [ "format" ]; }
#                 ];
#             in
#             [
#               {
#                 name = "bash";
#                 auto-format = true;
#                 file-types = [ "sh" "bash" ];
#                 formatter = {
#                   command = "${pkgs.shfmt}/bin/shfmt";
#                   # Indent with 2 spaces, simplify the code, indent switch cases, add space after redirection
#                   args = [ "-i" "4" "-s" "-ci" "-sr" ];
#                 };
#               }
#               # { name = "ruby"; file-types = [ "rb" "rake" "rakefile" "irb" "gemfile" "gemspec" "Rakefile" "Gemfile" "Fastfile" "Matchfile" "Pluginfile" "Appfile" ]; }
#               { name = "rust"; auto-format = false; file-types = [ "lalrpop" "rs" ]; language-servers = [ "rust-analyzer" ]; }

#               # {
#               #   name = "rust";
#               #   language-server = { command = "${pkgs.rust-analyzer}/bin/rust-analyzer"; };
#               #   config.checkOnSave = {
#               #     command = "clippy";
#               #   };
#               # }

#               { name = "c-sharp"; language-servers = [ "omnisharp" ]; }
#               { name = "typescript"; language-servers = jsTsWebLanguageServers; }
#               { name = "javascript"; language-servers = jsTsWebLanguageServers; }
#               { name = "jsx"; language-servers = jsTsWebLanguageServers; }
#               { name = "tsx"; language-servers = jsTsWebLanguageServers; }
#               { name = "vue"; language-servers = [{ name = "vuels"; except-features = [ "format" ]; } { name = "efm-lsp-prettier"; } "eslint"]; }
#               { name = "sql"; formatter.command = "pg_format"; }
#               { name = "nix"; language-servers = [ "nixd" ]; }
#               {
#                 name = "elixir";
#                 formatter.command = "${pkgs.elixir}/bin/mix format";
#               }
#               # { name = "elixir"; language-servers = [ "lexical" ]; }
#               # { name = "heex"; language-servers = [ "lexical" ]; }
#               { name = "json"; language-servers = [{ name = "vscode-json-language-server"; except-features = [ "format" ]; } "efm-lsp-prettier"]; }
#               { name = "markdown"; language-servers = [{ name = "marksman"; except-features = [ "format" ]; } "ltex-ls" "efm-lsp-prettier"]; }

#               {
#                 name = "xml";
#                 # auto-format = true;
#                 file-types = [ "xml" ];
#                 formatter = {
#                   command = "${pkgs.yq-go}/bin/yq";
#                   args = [ "--input-format" "xml" "--output-format" "xml" "--indent" "2" ];
#                 };
#               }
#               # {
#               #   name = "markdown";
#               #   language-server = {
#               #     command = "${pkgs.ltex-ls}/bin/ltex-ls";
#               #   };
#               #   file-types = [ "md" "txt" ];
#               #   scope = "source.markdown";
#               #   roots = [ ];
#               # }
#             ];
#         };

#       settings = {
#         theme = "doom_acario_dark";
#         editor = {
#           scrolloff = 8;
#           mouse = false;
#           middle-click-paste = false;
#           # shell = ["bash"];
#           shell = [ "zsh" "-c" ];
#           line-number = "relative";
#           cursorline = true;
#           gutters = [ "diagnostics" "line-numbers" "spacer" "diff" ];
#           auto-format = true;
#           # auto-save = true;
#           completion-replace = true;
#           completion-trigger-len = 1;
#           idle-timeout = 200;
#           true-color = true;
#           # rulers = [ 80];
#           # bufferline = "multiple";
#           bufferline = "always";
#           color-modes = true;
#           statusline = {
#             # mode-separator = "";
#             # mode-separator = "";
#             # mode-separator = "";
#             separator = "";
#             # separator = "";
#             left = [ "mode" "selections" "spinner" "file-name" "total-line-numbers" ];
#             center = [ ];
#             right = [ "diagnostics" "file-encoding" "file-line-ending" "file-type" "position-percentage" "position" ];
#             mode = {
#               normal = "N     ";
#               insert = "   INS";
#               select = "SELECT";
#             };
#           };
#           lsp.display-messages = true;
#           cursor-shape = {
#             normal = "block";
#             insert = "bar";
#             select = "underline";
#           };
#           # file-picker.hidden = false;
#           whitespace.render = "all";
#           whitespace.characters = {
#             # space = "·";
#             nbsp = "⍽";
#             tab = "→";
#             newline = "⤶";
#           };
#           # indent-guides = {
#           #   render = true;
#           #   rainbow = "normal";
#           #   # rainbow = "dim";
#           # };

#           # auto-pairs = {
#           #   "(" = ")";
#           #   "{" = "}";
#           #   "[" = "]";
#           #   "\"" = "\"";
#           #   "'" = "'";
#           #   "<" = ">";
#           # };
#           rainbow-brackets = true;
#           # sticky-context = {
#           #   enable = true;
#           #   indicator = true;
#           # };
#           # popup-border = "all";
#           # explorer = {
#           #   position = "embed";
#           # };
#         };

#         keys =
#           let
#             spaceMode = {
#               w = {
#                 "C-k" = "jump_view_down";
#                 "k" = "jump_view_down";
#                 "C-h" = "jump_view_up";
#                 "h" = "jump_view_up";
#                 "C-j" = "jump_view_left";
#                 "j" = "jump_view_left";
#                 "K" = "swap_view_down";
#                 "H" = "swap_view_up";
#                 "J" = "swap_view_left";
#               };
#               # space = "file_picker";
#               # n = "global_search";
#               # f = ":format"; # format using LSP formatter
#               space = ":format"; # format using LSP formatter
#               c = "toggle_comments"; # Or 'C-c'
#               t = {
#                 t = "goto_definition";
#                 i = "goto_implementation";
#                 r = "goto_reference";
#                 d = "goto_type_definition";
#               };
#               x = ":buffer-close";
#               # w = ":w";
#               # q = ":q";
#               # u = {
#               #   w = ":set whitespace.render all";
#               #   W = ":set whitespace.render none";
#               # };
#             };
#             commonMovementMappings = {
#               "'" = "repeat_last_motion";
#               g.j = "goto_line_start";
#               z.k = "scroll_down";
#               z.h = "scroll_up";
#               Z.k = "scroll_down";
#               Z.h = "scroll_up";
#               "C-w" = {
#                 "C-k" = "jump_view_down";
#                 "k" = "jump_view_down";
#                 "C-h" = "jump_view_up";
#                 "h" = "jump_view_up";
#                 "C-j" = "jump_view_left";
#                 "j" = "jump_view_left";
#                 "K" = "swap_view_down";
#                 "H" = "swap_view_up";
#                 "J" = "swap_view_left";
#               };
#               # move line-up
#               "C-k" = [ "extend_to_line_bounds" "delete_selection" "paste_after" ];
#               # move line-down
#               "C-h" = [ "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before" ];
#             };
#           in
#           {
#             normal = {
#               D = [ "delete_selection_noyank" ];
#               n = [ "search_next" "align_view_center" ];
#               N = [ "search_prev" "align_view_center" ];
#               j = "move_char_left";
#               h = [ "move_line_up" "align_view_center" ];
#               k = [ "move_line_down" "align_view_center" ];
#               "X" = "extend_line_above";
#               "{" = "goto_prev_paragraph";
#               "}" = "goto_next_paragraph";
#               "C-q" = ":bc";
#               "C-u" = [ "half_page_up" "goto_window_center" ];
#               "C-d" = [ "half_page_down" "goto_window_center" ];
#               "C-p" = [ "move_line_up" "scroll_up" ];
#               "C-n" = [ "move_line_down" "scroll_down" ];
#               backspace = [ "collapse_selection" "keep_primary_selection" ];
#               esc = [ "collapse_selection" "keep_primary_selection" ];
#               space = spaceMode;
#             } // commonMovementMappings;
#             insert."C-space" = "completion";
#             select = {
#               D = [ "delete_selection_noyank" ];
#               j = "extend_char_left";
#               h = "extend_line_up";
#               k = "extend_line_down";
#               space = spaceMode;
#             } // commonMovementMappings;
#             # changes = {
#             #   "p" = "replace";
#             #   "P" = "replace_with_yanked";
#             #   "~" = "switch_case";
#             #   "`" = "switch_to_lowercase";
#             #   "Alt-`" = "switch_to_uppercase";
#             #   "u" = "insert_mode";
#             #   "U" = "prepend_to_line";
#             #   "d" = "delete_selection";
#             #   "Alt-d" = "delection_selection_noyank";
#             # };
#           };
#       };
#     };

#     home.sessionVariables.EDITOR = lib.mkOverride 100 "hx";
#   };
# in
# {
#   options.ncfg.cli.helix = {
#     enable = lib.mkOption {
#       default = config.ncfg.cli.advanced;
#     };
#   };

#   config = lib.mkIf cfg.enable {
#     environment.sessionVariables.EDITOR = lib.mkOverride 100 "hx";
#     environment.sessionVariables.VISUAL = lib.mkOverride 100 "hx";

#     home-manager.users.${config.ncfg.primaryUserName} = { ... }: (base "/home/${config.ncfg.primaryUserName}");
#     # home-manager.users."root" = { ... }: (base "/root");
#   };
# }
