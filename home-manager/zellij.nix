{
  pkgs,
  zesh-src,
  ...
}:

let
  zesh = pkgs.rustPlatform.buildRustPackage rec {
    pname = "zesh";

    # Version is up to you; you can derive from the git rev if you want
    version = "git-${zesh-src.rev or "dev"}";

    # Use the source from the flake input
    src = zesh-src;

    # Re-use the lockfile from the repo
    cargoLock.lockFile = "${zesh-src}/Cargo.lock";

    meta = with pkgs.lib; {
      description = "zellij session manager with zoxide integration";
      homepage = "https://github.com/roberte777/zesh";
      license = licenses.mit;
      platforms = platforms.darwin;
    };
  };
in
{
  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;
    attachExistingSession = true;
    exitShellOnExit = true;
  };

  home.packages = [
    zesh
  ];
}
