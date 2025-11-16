{ pkgs, ... }:

{
  programs.streamlink = {
    enable = true;
    plugins = {
      # yt, bloomberg, bilibili
    };
    settings = {
      player = "${pkgs.mpv}/bin/mpv";
      player-args = "--cache 2048";
      player-no-close = true;
    };
  };
}
