{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    # theme = "Ayu Dark";
    themeFile = "GruvboxMaterialDarkHard";
    # Tokyo Night, Ayu
    font = {
      package = pkgs.fira-code;
      # package = pkgs.dejavu_fonts;
      # package = pkgs.cascadia-code;
      ## fonts don't seem to apply...
      name = "Fira Code";
      # name = "Dejavu Fonts";
      # name = "Cascadia Code PL";
      size = 15;
    };
    keybindings = {
      "cmd+c" = "copy_or_interrupt";
      "cmd+shift+enter" = "new_window_with_cwd";
      "cmd+t" = "new_tab_with_cwd";
      "cmd+n" = "new_os_window_with_cwd";

      "cmd+0"= "launch --location before --cwd current --title tree $HOME/.config/open_file_tree.bash";

      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";
    };
    settings = {
      font_family = "Fira Code";
      # font_family = "Fira Code";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      background_opacity = "0.9";

      cursor = "none";
      # cursor = "#ff5900";
      cursor_blink_interval = "0";
      cursor_text_color = "background";

      mouse_hide_wait = "0.1";
      # mouse_hide_wait = "-1"; # hides when start typing

      hide_window_decorations = "titlebar-only";
      # window_border_width = "1";
      # window_margin_width = "1";
      inactive_text_alpha = "0.5";

      window_padding_width = "30";
      macos_quit_when_last_window_closed = "yes";

      single_window_margin_width = "16";


      background_image = "~/Documents/KTQQ/Resources/Images/clock.jpg";
      # background_image = "~/Documents/KTQQ/Triage/Images/kitty.png";
      # background_image = "~/Documents/KTQQ/Resources/Images/flower-kitty.png";
      # background_image_layout = "mirror-tiled";
      background_image_layout = "cscaled";
      background_tint = "0.9";

      allow_remote_control = "yes";
      enabled_layouts = "splits:split_axis=horizontal";

      update_check_interval = "0";

      # remember_window_size = "no";
      # initial_window_width = "700";
      # initial_window_height = "500";

      resize_debounce_time = "0.001";

      active_tab_background = "#2a2f38";
      active_tab_foreground = "#e1e1e4";
      inactive_tab_background = "#2a2f38";
      inactive_tab_foreground = "#e1e3e4";

      selection_background = "#3d4455";
      selection_foreground = "#e1e3e4";
      # selection_background = "#3c5233";
      # selection_foreground = "#ffffff";
    };
  };
}
