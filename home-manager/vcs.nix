{ config, pkgs, ... }:
{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-decoration-style = "yellow box";
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
        delta = {
          navigate = "true";
        };
        diff.tool = "difftastic";
        difftool = {
          prompt = false;
          difftastic.cmd = "${config.programs.difftastic.package}/bin/difft \"$LOCAL\" \"$REMOTE\"";
        };
        pager.difftool = true;
        merge = {
          conflictStyle = "zdiff3";
        };
        url = {
          "ssh://git@host" = {
            insteadOf = "otherhost";
          };
        };
      };
    };
    difftastic = {
      enable = true;
      git = {
        enable = false;
        diffToolMode = true;
      };
      jujutsu.enable = true;
      options = {
        # sort-paths = true;
        # tab-width = 8;
      };
    };
    jjui = {
      enable = true;
      configDir = "${config.home.homeDirectory}/.jjui";
      settings = {
        revisions = {
          revset = "";
          template = "builtin_log_compact";
        };
      };
    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Kenric";
          email = "kenricqq@gmail.com";
        };
        aliases = {
          idiff = [
            "diff"
            "--exclude"
            "**/*.lock"
            "--exclude"
            "bindings.ts"
          ];
        };
        lazyjj = {
          # layout = "vertical";
          layout-percent = 30; # file section
          diff-tool = "difft";
        };
      };
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
        git = {
          pagers = [
            {
              externalDiffCommand = "difft --color=always";
            }
          ];
        };
      };
    };
  };
  home.packages = with pkgs; [
    lazyjj
    # glab # gitlab cli

    lefthook # git hooks manager (like husky)
    gitleaks # check for secrets
    act # run github actions locally
  ];
}
