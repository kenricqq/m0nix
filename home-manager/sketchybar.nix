# { pkgs, ... }:

# {
#   programs.sketchybar = {
#     enable = true;
#     config = {
#       source = ./dotfiles/sketchybar;
#       recursive = true;
#     };
#     configType = "lua";
#     extraLuaPackages = luaPkgs: with luaPkgs; [ luautf8 ];
#     extraPackages = with pkgs; [ jq ];
#   };
# }
