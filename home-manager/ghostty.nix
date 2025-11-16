{ ... }:

{
  programs.ghostty = {
    enable = true;
    # installBatSyntax = true;
    # installVimSyntax = true;
    settings = {
      theme = "Kanagawa Dragon";

      # background = 282c34;
      # foreground = ffffff

      background-image = "~/Documents/Images/deer.png";
      background-opacity = 0.9;
      # background-opacity = 0.9;
      unfocused-split-opacity = 0.8;

      macos-titlebar-style = "hidden";
      # macos-titlebar-style = "tabs";
      macos-titlebar-proxy-icon = "hidden";

      window-padding-x = 20;
      window-padding-y = 15;
      # window-padding-color = extend

      # Empty values reset the configuration to the default value
      font-family = "MonaspiceNe NFM";
      # font-family = "IosevkaTerm NFM";
      # font-family = "Source Code Pro"
      # font-family = "JetBrainsMono NFM Bold"
      font-size = 15;

      confirm-close-surface = false;
      # disable to have dropdown term
      quit-after-last-window-closed = false;

      keybind = [
        "global:cmd+shift+grave_accent=toggle_quick_terminal"
        "cmd+shift+enter=new_split:right"

        "cmd+shift+\=new_split:down"

        # keyboard scroll
        "ctrl+shift+k=scroll_page_lines:-25"
        "ctrl+shift+j=scroll_page_lines:25"

        # goto split
        "cmd+shift+h=goto_split:left"
        "cmd+shift+l=goto_split:right"
        "cmd+shift+j=goto_split:bottom"
        "cmd+shift+k=goto_split:top"

        # resize split
        "cmd+ctrl+h=resize_split:left,30"
        "cmd+ctrl+l=resize_split:right,30"
        "cmd+ctrl+k=resize_split:up,30"
        "cmd+ctrl+j=resize_split:down,30"

        "cmd+f=toggle_split_zoom"

        "ctrl+l=clear_screen"
      ];
    };
  };
}
