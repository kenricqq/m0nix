{ config, ... }:

let
  path = rec {
    home = "/Users/kenrictee";
    # home = config.home.homeDirectory;
    nix = "${home}/.config/m0nix";
    hm = "${nix}/home-manager";
    cache = config.xdg.cacheHome;

    dot = "${hm}/dotfiles";
    darwin = "${nix}/darwin";
    scripts = "${hm}/scripts";
    snippets = "${hm}/snippets";

    share = "${home}/.local/state/nix/profiles/home-manager/home-path/share";
    secretsEnv = "${cache}/zsh/secrets.env";

    mkDotFile = subpath: {
      source = config.lib.file.mkOutOfStoreSymlink "${dot}/${subpath}";
    };
  };
in
{
  _module.args = {
    path = path;
  };
}
