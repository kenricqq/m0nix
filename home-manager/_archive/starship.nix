{ lib, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableTransience = true;
    settings = {
      # add_newline = false;
      # format = lib.concatStrings [
      #   # "$line_break"
      #   "$package"
      #   # "$line_break"
      #   "$character"
      # ];
      # scan_timeout = 10;
      # character = {
      #   success_symbol = "➜";
      #   error_symbol = "➜";
      # };

      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$python"
        "$character"
      ];

      # Directory module
      directory = {
        style = "blue";
      };

      # Character module
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      # Git branch
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      # Git status
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      # Git state
      git_state = {
        format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
        style = "bright-black";
      };

      # Command duration
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      # Python
      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };
    };
  };
}
