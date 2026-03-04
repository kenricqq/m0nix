{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    disableConfirmationPrompt = true;
  };

  programs.sesh = {
    enable = true;
  };
}
