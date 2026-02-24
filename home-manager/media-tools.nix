{
  config,
  path,
  pkgs,
  ...
}:

let
  inherit (path)
    home
    ;
in
{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      dataDir = "${home}/.mpd"; # Default: "$XDG_DATA_HOME/mpd"
      extraArgs = [
        "--verbose"
      ];
      extraConfig = ''
        log_file "${home}/.mpd/mpd.log"

        db_file "${home}/.mpd/database"
        state_file "${home}/.mpd/state"
        sticker_file "${home}/.mpd/sticker.sql"

        auto_update             "yes"
        auto_update_depth       "2"
        follow_outside_symlinks "yes"
        follow_inside_symlinks  "yes"

        decoder {
          plugin                "mp4ff"
          enabled               "no"
        }


        audio_output {
          type "osx"
          name "CoreAudio"
          mixer_type "software"   # lets mpc set volume
          # device "Built-in Output"
        }

        bind_to_address "127.0.0.1"
        port            "6600"
      '';
      # network = {
      #   listenAddress = "any"; # Default: "127.0.0.1"
      #   port = 6600; # Default: 6600
      # };
      # playlistDirectory = ""; # Default: "\${dataDir}/playlists"
    };
  };

  programs = {
    mpv = {
      # enable = true;
      # bindings = {
      #   WHEEL_UP = "seek 10";
      #   WHEEL_DOWN = "seek -10";
      #   "Alt+0" = "set window-scale 0.5";
      # };
      # config = {
      #   # profile = "gpu-hq";
      #   ytdl-format = "bestvideo+bestaudio";
      # };
      # extraInput = ''
      #   esc         quit                        #! Quit
      #   #           script-binding uosc/video   #! Video tracks
      #   # additional comments
      # '';
      # scripts = with pkgs.mpvScripts; [
      #   mpris
      #   uosc # UI for video player
      #   sponsorblock-minimal # for yt videos
      #   mpv-playlistmanager

      #   eisa01.undoredo
      #   eisa01.smartskip
      #   eisa01.smart-copy-paste-2
      #   eisa01.simplehistory
      #   eisa01.simplebookmark
      # ];
    };

    # cli for downloading image collections
    # gallery-dl = {
    #   enable = true;
    # };

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
      #       # browser_song_sort: [Disc, Track, Artist, Title],
      #   )
      # '';
    };
    # download yt vid/aud
    # yt-dlp = {
    #   enable = true;
    #   extraConfig = ''
    #     --update
    #     -F
    #   '';
    #   settings = {
    #     embed-thumbnail = true;
    #     embed-subs = true;
    #     sub-langs = "all";
    #     downloader = "aria2c";
    #     downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
    #   };
    # };
  };

  home.packages = with pkgs; [
    # chafa # terminal graphics viewer
    # portaudio # realtime audio i/o
    # switchaudio-osx # macOS cli audio source
    # mpc
    # cli interface for mpd
    # mediainfo # tag info of audio/video
    # mpd # music player daemon
    mpc

    # ascii-image-converter
    ffmpeg # cli edit/convert/stream multimedia content
    mediainfo
    imagemagick

    # charm-freeze # generate images of code/terminal out
    termshot
  ];
}
