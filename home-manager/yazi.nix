{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    plugins = {
      piper = pkgs.yaziPlugins.piper;
      diff = pkgs.yaziPlugins.diff;
      smart-filter = pkgs.yaziPlugins.smart-filter;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      lazygit = pkgs.yaziPlugins.lazygit;
      chmod = pkgs.yaziPlugins.chmod;
      full-border = pkgs.yaziPlugins.full-border;
      no-status = pkgs.yaziPlugins.no-status;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
      mediainfo = pkgs.yaziPlugins.mediainfo;
      # utils = ./yazi_plugins/utils.yazi;
    };
    # initLua = "./dotfiles/yazi_init.lua";
    initLua = ''
      require("full-border"):setup()
      require("no-status"):setup()
    '';
    # shellWrapperName = "y"; # default yy, nav to dir on quit
    keymap = {
      input.prepend_keymap = [
        {
          run = "close";
          on = [ "<C-q>" ];
        }
        {
          run = "close --submit";
          on = [ "<Enter>" ];
        }
        {
          run = "escape";
          on = [ "<Esc>" ];
        }
        {
          run = "backspace";
          on = [ "<Backspace>" ];
        }
      ];
      mgr = {
        prepend_keymap = [
          {
            on = "T";
            run = "plugin toggle-pane min-preview";
            desc = "Show or hide the preview pane";
          }
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = "<C-p>";
            run = "shell -- qlmanage -p \"$@\"";
            desc = "macOS preview files with system quick look";
          }
          {
            on = "<C-d>";
            run = "plugin diff";
            desc = "Diff the selected with the hovered file";
          }
          {
            on = [ "F" ];
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = [
              "g"
              "r"
            ];
            run = "shell -- ya emit cd \"$(git rev-parse --show-toplevel)\"";
            desc = "Go to git root";
          }
          {
            on = "<C-g>";
            run = "plugin lazygit";
            desc = "run lazygit";
          }
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }

          # custom
          {
            run = "escape";
            on = [ "<Esc>" ];
          }
          {
            run = "quit";
            on = [ "q" ];
          }
          {
            run = "close";
            on = [ "<C-q>" ];
          }
          # { run = "plugin utils"; on = [ "u" ]; desc = "ls folder"; }
          # { run  = "shell '$SHELL' --block"; on = "!"; desc = "Open shell here"; }
        ];
      };
    };
    settings = {
      log = {
        enabled = false;
      };
      mgr = {
        show_hidden = false;
        # sort_by = "mtime";
        sort_by = "alphabetical";
        sort_dir_first = true;
        sort_reverse = true;
        ratio = [
          1
          3
          2
        ];
      };
      opener = {
        bulk-rename = [
          {
            run = "hx \"$@\"";
            block = true;
          }
        ];
        # edit = [
        #   {
        #     run = "hx \"$@\"";
        #     block = true;
        #   }
        # ];
        set-wallpaper = [
          {
            run = ''
              	osascript -e 'on run {img}' -e 'tell application "System Events" to set picture of every desktop to img' -e 'end run' "$0"
            '';
            for = "macos";
            desc = "Set as wallpaper";
          }
        ];
      };
      open = {
        prepend_rules = [
          {
            mime = "image/*";
            use = [
              "open"
              "set-wallpaper"
            ];
          }
        ];
      };
      preview = {
        image_delay = 0;
        # max_width = 1000;
        # max_height = 1000;
      };
      tasks = {
        image_bound = [
          6000
          6000
        ];
      };
      plugin = {
        prepend_previewers = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            name = "*.md";
            run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
          }
          {
            name = "*.csv";
            run = "piper -- bat -p --color=always \"$1\"";
          }
          {
            name = "*/";
            run = "piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
          }
          {
            name = "*.tar*";
            run = "piper --format=url -- tar tf \"$1\"";
          }
          # hex
          {
            name = "*.hex";
            run = "piper -- hexyl --border=none --terminal-width=$w \"$1\"";
          }
        ];
        prepend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
        ];
      };
    };
    theme = {
      # flavor = {
      #   # kanagawa, rose-pine-moon
      #   dark = "dracula";
      # };
    };
  };
}
