{ pkgs, ... }:

{
  zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "xy-zed"
    ];
    extraPackages = with pkgs; [
      nixd
    ];
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          ctrl-shift-t = "workspace::NewTerminal";
        };
      }
    ];
    userSettings = {
      autosave = "on_focus_change";
      buffer_font_family = "Monaspace Radon";
      buffer_font_size = 16;
      cursor_blink = false;
      git = {
        inline_blame = {
          enabled = false;
        };
      };
      hard_tabs = true;
      inlay_hints = {
        enabled = true;
      };
      relative_line_numbers = true;
      scrollbar = {
        show = "auto";
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      theme = "Zedokai Darker (Filter Spectrum)";
      ui_font_family = "Monaspace Neon";
      ui_font_size = 16;
      vertical_scroll_margin = 10;
      vim_mode = true;
      vim = {
        use_multiline_find = true;
        use_smartcase_find = true;
        use_system_clipboard = "always";
      };
    };
    # tasks can be run from command palette
    userTasks = [
      {
        label = "Format Code";
        command = "nix";
        args = [
          "fmt"
          "$ZED_WORKTREE_ROOT"
        ];
      }
    ];
  };
}
