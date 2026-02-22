{ pkgs, ... }:
{
  programs = {
    bun = {
      enable = true;
      settings = {
        smol = true;
        telemetry = false;
        test = {
          coverage = true;
          coverageThreshold = 0.9;
        };
        install.lockfile = {
          print = "yarn";
        };
      };
    };
    # github cli
    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-eco
        gh-f
      ];
      hosts = {
        "github.com" = {
          user = "<your_username>";
        };
      };
      settings = {
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };

        git_protocol = "ssh";

        prompt = "enabled";
      };
    };
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
    git = {
      enable = true;
      attributes = [
        "*.pdf diff=pdf"
      ];
      settings = {
        aliases = {
          co = "checkout";
          rao = "remote add origin";
        };
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        url = {
          "ssh://git@host" = {
            insteadOf = "otherhost";
          };
        };
      };
      # difftastic = {
      #   enable = true;
      #   enableAsDifftool = true;
      #   background = "dark";
      # };
    };
    go = {
      enable = true;
      packages = {
        # "golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
        # "golang.org/x/time" = builtins.fetchGit "https://go.googlesource.com/time";
      };
      telemetry.mode = "off";
    };
    jujutsu = {
      enable = true;
    };
    lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          activeBorderColor = [
            "blue"
            "bold"
          ];
          inactiveBorderColor = [ "cyan" ];
          selectedLineBgColor = [ "default" ];
        };
      };
    };
    lazysql = {
      enable = true;
    };

    # python linter + code formatter
    ruff = {
      enable = true;
      settings = {
        line-length = 100;
        per-file-ignores = {
          "__init__.py" = [ "F401" ];
        };
        lint = {
          select = [
            "E4"
            "E7"
            "E9"
            "F"
          ];
          ignore = [ ];
        };
      };
    };
  };
}
