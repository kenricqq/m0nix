{ pkgs, ... }:
{
  programs = {

    mpv = {
      enable = true;
      package = pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.override { vapoursynthSupport = true; };
        youtubeSupport = true;
      };
      bindings = {
        WHEEL_UP = "seek 10";
        WHEEL_DOWN = "seek -10";
        "Alt+0" = "set window-scale 0.5";
      };
      config = {
        # profile = "gpu-hq";
        ytdl-format = "bestvideo+bestaudio";
      };
      extraInput = ''
        esc         quit                        #! Quit
        #           script-binding uosc/video   #! Video tracks
        # additional comments
      '';
      #   scripts = with pkgs.mpvScripts; [
      #     mpris
      #     uosc # UI for video player
      #     sponsorblock-minimal # for yt videos
      #     mpv-playlistmanager

      #     eisa01.undoredo
      #     eisa01.smartskip
      #     eisa01.smart-copy-paste-2
      #     eisa01.simplehistory
      #     eisa01.simplebookmark
      #   ];
    };

    # cli for downloading image collections
    gallery-dl = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    portaudio # realtime audio i/o
    switchaudio-osx # macOS cli audio source
    mpc
    # cli interface for mpd
    mediainfo # tag info of audio/video
    # mpd # music player daemon

    ascii-image-converter
    ffmpeg # cli edit/convert/stream multimedia content
    imagemagick
  ];
}
