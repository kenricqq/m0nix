{
  pkgs,
  path,
  ...
}:
{
  # services = {
  #   mpd = {
  #     enable = true;
  #     dataDir = "${config.home.homeDirectory}/.mpd"; # Default: "$XDG_DATA_HOME/mpd"
  #     extraArgs = [
  #       "--verbose"
  #     ];
  #     extraConfig = ''
  #       bind_to_address "127.0.0.1"
  #       port            "6600"

  #       audio_output {
  #         type "osx"
  #         name "CoreAudio"
  #         # Optional: pin to a specific device (see step 6)
  #         device "Built-in Output"
  #         mixer_type "software"   # lets mpc set volume
  #       }
  #     '';
  #     musicDirectory = "${config.home.homeDirectory}/Music";
  #     # network = {
  #     #   listenAddress = "any"; # Default: "127.0.0.1"
  #     #   port = 6600; # Default: 6600
  #     # };
  #     # playlistDirectory = ""; # Default: "\${dataDir}/playlists"
  #   };
  # };
  programs = {
    # shell history
    atuin = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        ctrl_n_shortcuts = true;
        enter_accept = true;
        filter_mode = "directory";
        inline_height = 20;
        invert = false;
        keymap_mode = "vim-insert"; # auto
        style = "auto";
      };
    };
    # resource monitor / process manager
    btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
        # default "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        vim_keys = true;
      };
    };
    # display file contents
    bat = {
      enable = true;
      config = {
        map-syntax = [
          "*.jenkinsfile:Groovy"
          "*.props:Java Properties"
        ];
        pager = "less -FR";
        theme = "TwoDark";
      };
      syntaxes = {
        gleam = {
          src = pkgs.fetchFromGitHub {
            owner = "molnarmark";
            repo = "sublime-gleam";
            rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
            hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
          };
          file = "syntax/gleam.sublime-syntax";
        };
      };
      themes = {
        dracula = {
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
            sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
          };
          file = "Dracula.tmTheme";
        };
      };
    };
    # environment switcher
    direnv = {
      enable = true;
      mise = {
        enable = true;
      };
      nix-direnv.enable = true;
      silent = true;
    };
    # better ls
    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = "auto";
    };
    # system visuals
    fastfetch = {
      enable = true;
      # settings = {
      #   logo = {
      #     source = "nixos_small";
      #     padding = {
      #       right = 1;
      #     };
      #   };
      #   display = {
      #     size = {
      #       binaryPrefix = "si";
      #     };
      #     color = "blue";
      #     separator = "  ";
      #   };
      #   modules = [
      #     {
      #       type = "datetime";
      #       key = "Date";
      #       format = "{1}-{3}-{11}";
      #     }
      #     {
      #       type = "datetime";
      #       key = "Time";
      #       format = "{14}:{17}:{20}";
      #     }
      #     "break"
      #     "player"
      #     "media"
      #   ];
      # };
    };
    # find files by fuzzy filename
    fd = {
      enable = true;
      extraOptions = [
        "--no-ignore"
        "--absolute-path"
      ];
      hidden = true;
      ignores = [
        ".git/"
        "*.bak"
      ];
    };
    # fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = false;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'tree -C {} | head -200'"
      ];
      colors = {
        bg = "#1e1e1e";
        "bg+" = "#1e1e1e";
        fg = "#d4d4d4";
        "fg+" = "#d4d4d4";
      };
      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 50%"
        "--border"
      ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [
        "--preview 'head {}'"
      ];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
    };
    # json processor
    jq = {
      enable = true;
      colors = {
        null = "1;30";
        false = "0;31";
        true = "0;32";
        numbers = "0;36";
        strings = "0;33";
        arrays = "1;35";
        objects = "1;37";
        objectKeys = "1;34";
      };
    };
    # jq playground
    jqp = {
      enable = true;
      settings = {
        theme = {
          chromaStyleOverrides = {
            kc = "#009900 underline";
          };
          name = "monokai";
        };
      };
    };
    # fzf cheatsheet for cli, can wrap tldr
    navi = {
      enable = true;
      enableZshIntegration = true;
    };
    newsboat = {
      enable = true;
      autoFetchArticles = {
        enable = true;
        onCalendar = "daily";
      };
      autoReload = true;
      autoVacuum = {
        enable = true;
        onCalendar = "weekly";
      };
      extraConfig = ''

      '';
      maxItems = 10;
      queries = {
        foo = "rssurl =~ \"example.com\"";
      };
      urls = [
        {
          tags = [
            "foo"
            "bar"
          ];
          title = "Example";
          url = "http://example.com";
        }
      ];
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 2";
      };
      flake = "${path.nix}/flake.nix";
    };
    pandoc = {
      enable = true;
    };
    # command suggestion/autofix
    # pay-respects = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   options = [
    #     "--alias"
    #     "f"
    #   ];
    # };
    # rTorrent BitTorrent client
    # rtorrent = {
    #   enable = true;
    # };
    # text search through files
    # ripgrep = {
    #   enable = true;
    #   arguments = [
    #     "--max-columns-preview"
    #     "--colors=line:style:bold"
    #   ];
    # };
    # extend rg to PDFs, EBooks, zip, tar, etc
    ripgrep-all = {
      enable = true;
    };
    # terminal music player
    rmpc = {
      enable = true;
      # config = ''
      #   (
      #       address: "127.0.0.1:6600",
      #       password: None,
      #       theme: None,
      #       cache_dir: None,
      #       on_song_change: None,
      #       volume_step: 5,
      #       max_fps: 30,
      #       scrolloff: 0,
      #       wrap_navigation: false,
      #       enable_mouse: true,
      #       enable_config_hot_reload: true,
      #       select_current_song_on_change: false,
      #       browser_song_sort: [Disc, Track, Artist, Title],
      #   )
      # '';
    };
    # cli todo manager
    # taskwarrior = {
    #   enable = true;
    #   package = pkgs.taskwarrior3;
    #   colorTheme = "dark-blue-256";
    #   config = {
    #     confirmation = false;
    #     report.minimal.filter = "status:pending";
    #     report.active.columns = [
    #       "id"
    #       "start"
    #       "entry.age"
    #       "priority"
    #       "project"
    #       "due"
    #       "description"
    #     ];
    #     report.active.labels = [
    #       "ID"
    #       "Started"
    #       "Age"
    #       "Priority"
    #       "Project"
    #       "Due"
    #       "Description"
    #     ];
    #     # taskd = {
    #     #   certificate = "/path/to/cert";
    #     #   key = "/path/to/key";
    #     #   ca = "/path/to/ca";
    #     #   server = "host.domain:53589";
    #     #   credentials = "Org/First Last/cf31f287-ee9e-43a8-843e-e8bbd5de4294";
    #     # };
    #   };
    # };
    # faster tldr, man pages
    # tealdeer = {
    #   enable = true;
    #   settings = {
    #     # display = {
    #     #   compact = true;
    #     #   use_pager = true;
    #     # };
    #     # updates.auto_update = true;
    #   };
    # };
    # general purpose fuzzy finder
    television = {
      enable = true;
      enableZshIntegration = true;
      channels = {
        git-diff = {
          metadata = {
            description = "A channel to select files from git diff commands";
            name = "git-diff";
            requirements = [
              "git"
            ];
          };
          preview = {
            command = "git diff HEAD --color=always -- '{}'";
          };
          source = {
            command = "git diff --name-only HEAD";
          };
        };
        git-log = {
          metadata = {
            description = "A channel to select from git log entries";
            name = "git-log";
            requirements = [
              "git"
            ];
          };
          preview = {
            command = "git show -p --stat --pretty=fuller --color=always '{0}'";
          };
          source = {
            command = "git log --oneline --date=short --pretty=\"format:%h %s %an %cd\" \"$@\"";
            output = "{split: :0}";
          };
        };
      };
      settings = {
        tick_rate = 50;
      };
    };
    # download yt vid/aud
    yt-dlp = {
      enable = true;
      # extraConfig = ''
      #   --update
      #   -F
      # '';
      # settings = {
      #   embed-thumbnail = true;
      #   embed-subs = true;
      #   sub-langs = "all";
      #   downloader = "aria2c";
      #   downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
      # };
    };
    zoxide = {
      enable = true;
      # enableZshIntegration = true;
    };

    # borg # Deduplicating archiver with compression and authenticated encryption.
    # The main goal of Borg is to provide an efficient and secure way to back up data. The data deduplication technique used makes Borg suitable for daily backups since only changes are stored. The authenticated encryption technique makes it suitable for backups to targets not fully trusted.

    # rlone # cloud storage sync files
  };
}
