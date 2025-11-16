{ pkgs, ... }:
{
  programs = {
    # awscli = {
    #   enable = true;
    # };
    broot = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        modal = true;
        verbs = [
          {
            invocation = "p";
            execution = ":parent";
          }
          {
            invocation = "edit";
            shortcut = "e";
            execution = "$EDITOR {file}";
          }
          {
            invocation = "create {subpath}";
            execution = "$EDITOR {directory}/{subpath}";
          }
          {
            invocation = "view";
            execution = "less {file}";
          }
          {
            invocation = "blop {name}\\.{type}";
            execution = "mkdir {parent}/{type} && ${pkgs.neovim}/bin/nvim {parent}/{type}/{name}.{type}";
            from_shell = true;
          }
        ];
      };
    };
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
    docker-cli = {
      enable = true;
      # settings = {
      #   "proxies" = {
      #     "default" = {
      #       "httpProxy" = "http://proxy.example.org:3128";
      #       "httpsProxy" = "http://proxy.example.org:3128";
      #       "noProxy" = "localhost";
      #     };
      #   };
      # };
    };
    lazydocker = {
      enable = true;
      settings = {
        gui.theme = {
          activeBorderColor = [
            "red"
            "bold"
          ];
          inactiveBorderColor = [ "blue" ];
        };
        commandTemplates.dockerCompose = "docker compose compose -f docker-compose.yml";
      };
    };
    # github cli
    gh = {
      enable = true;
      extensions = [
        pkgs.gh-eco
        pkgs.gh-f
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
    # cli dashboard for github
    gh-dash = {
      enable = true;
      # settings = {
      #   prSections = [
      #     {
      #       title = "My Pull Requests";
      #       filters = "is:open author:@me";
      #     }
      #   ];
      # };
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
    k9s = {
      enable = true;
      aliases = {
        # Use pp as an alias for Pod
        pp = "v1/pods";
      };
      hotKeys = {
        shift-0 = {
          shortCut = "Shift-0";
          description = "Viewing pods";
          command = "pods";
        };
      };
      plugins = {
        # Defines a plugin to provide a `ctrl-l` shortcut to
        # tail the logs while in pod view.
        fred = {
          shortCut = "Ctrl-L";
          description = "Pod logs";
          scopes = [ "po" ];
          command = "kubectl";
          background = false;
          args = [
            "logs"
            "-f"
            "$NAME"
            "-n"
            "$NAMESPACE"
            "--context"
            "$CLUSTER"
          ];
        };
      };
      settings = {
        k9s = {
          refreshRate = 2;
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
