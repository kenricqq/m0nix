{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      piper = piper;
      diff = diff;
      smart-filter = smart-filter;
      smart-enter = smart-enter;
      lazygit = lazygit;
      chmod = chmod;
      full-border = full-border;
      no-status = no-status;
      toggle-pane = toggle-pane;
      mediainfo = mediainfo;
      jjui = jjui;
      vcs-files = vcs-files;
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
        sort_by = "mtime";
        # sort_by = "alphabetical";
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
        # image_bound = [
        #   6000
        #   6000
        # ];
      };
      plugin = {
        prepend_previewers = [
          {
            url = "*.tar*";
            run = "faster-piper --rely-on-preloader --format=url";
          }
          {
            url = "*.txt.gz";
            run = "faster-piper --rely-on-preloader";
          }
          {
            url = "*.csv";
            run = "faster-piper --rely-on-preloader";
          }
          {
            url = "*.md";
            run = "faster-piper --rely-on-preloader";
          }
          {
            url = "*/";
            run = "faster-piper --rely-on-preloader";
          }
          {
            mime = "application/sqlite3";
            run = "faster-piper --rely-on-preloader";
          }
          {
            url = "*/.hex";
            run = "faster-piper --rely-on-preloader";
          }
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
        ];
        prepend_preloaders = [
          {
            url = "*.tar*";
            # run = "piper --format=url -- tar tf \"$1\"";
            run = "faster-piper --format=url -- tar tf \"$1\"";
          }
          {
            url = "*.txt.gz";
            run = "faster-piper -- gzip -dc \"$1\"";
          }
          {
            url = "*.csv";
            run = "faster-piper -- bat -p --color=always \"$1\"";
          }
          {
            url = "*.md";
            run = "faster-piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dracula -- \"$1\"";
          }
          {
            url = "*/";
            run = "faster-piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
          }
          {
            mime = "application/sqlite3";
            run = "faster-piper -- sqlite3 \"$1\" \".schema --indent\"";
          }
          # hexyl as fallback previewer instead of file
          {
            url = "*/.hex";
            run = "faster-piper -- hexyl --border=none --terminal-width=$w \"$1\"";
          }
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
