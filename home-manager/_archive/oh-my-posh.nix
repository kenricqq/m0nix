{
  config,
  lib,
  pkgs,
  path,
  ...
}:

let
  inherit (path)
    cache
    ;
in
{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = false;
    configFile = "${path.dot}/oh-my-posh/config.yaml";

  };
  # setup jj integration
}
