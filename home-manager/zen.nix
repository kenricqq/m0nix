{
  config,
  pkgs,
  ...
}:
{
  xdg.mimeApps =
    let
      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value =
              let
                zen-browser = config.programs.zen-browser.package;
              in
              zen-browser.meta.desktopFileName;
          })
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]
      );
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };

  programs.zen-browser = {
    enable = true;

    darwinDefaultsId = "app.zen-browser.zen";

    policies =
      let
        mkLockedAttrs = builtins.mapAttrs (
          _: value: {
            Value = value;
            Status = "locked";
          }
        );

        mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

        mkExtensionEntry =
          {
            id,
            pinned ? false,
          }:
          let
            base = {
              install_url = mkPluginUrl id;
              installation_mode = "force_installed";
            };
          in
          if pinned then base // { default_area = "navbar"; } else base;

        mkExtensionSettings = builtins.mapAttrs (
          _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
        );
      in
      {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true; # save webs for later reading
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        Homepage = {
          URL = "http://localhost:8080";
          Locked = true;
        };
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        SanitizeOnShutdown = {
          FormData = true;
          Cache = true;
        };
        ExtensionSettings = mkExtensionSettings {
          ## check about:support for pluginId
          # "wappalyzer@crunchlabz.com" = mkExtensionEntry {
          #   id = "wappalyzer";
          #   pinned = true;
          # };
          "wappalyzer@crunchlabz.com" = "wappalyzer";
          "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
          "addon@darkreader.org" = "darkreader";
          "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack" = "raindropio";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
          "deArrow@ajay.app" = "dearrow";
          "jid1-q4sG8pYhq8KGHs@jetpack" = "adblock-for-youtube";
          "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = "videospeed";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "control-panel-for-youtube@jbscript.dev" = "control-panel-for-youtube";
          "{5cce4ab5-3d47-41b9-af5e-8203eea05245}" = "control-panel-for-twitter";
          "@searchengineadremover" = "searchengineadremover";
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = "proton-pass";
          "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";

          "{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}" = "chameleon-ext";
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";

          # "github-no-more@ihatereality.space" = "github-no-more";
          # "github-repository-size@pranavmangal" = "gh-repo-size";
          # "trackmenot@mrl.nyu.edu" = "trackmenot";
          # "{861a3982-bb3b-49c6-bc17-4f50de104da1}" = "custom-user-agent-revived";
        };
        Preferences = mkLockedAttrs {
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
          # "browser.gesture.swipe.left" = "";
          # "browser.gesture.swipe.right" = "";
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.topsites.contile.enabled" = false;

          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "privacy.spoof_english" = 1;

          "privacy.firstparty.isolate" = true;
          "network.cookie.cookieBehavior" = 5;
          "dom.battery.enabled" = false;

          "gfx.webrender.all" = true;
          "network.http.http3.enabled" = true;
          "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0
        };
      };

    profiles.default = rec {
      # extensions = {
      #   packages = with pkgs.nur.repos.rycee.firefox-addons; [
      #     ublock-origin
      #   ];
      #   settings = {
      #     "uBlock0@raymondhill.net".settings = {
      #       selectedFilterLists = [
      #         "ublock-filters"
      #         "ublock-badware"
      #         "ublock-privacy"
      #         "ublock-unbreak"
      #         "ublock-quick-fixes"
      #       ];
      #     };
      #   };
      # };

      isDefault = true;

      settings = {
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.natural-scroll" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.animate-sidebar" = true;
        "zen.welcome-screen.seen" = true;
        "zen.urlbar.behavior" = "float";
      };

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                name = "wiki";
                tags = [
                  "wiki"
                  "nix"
                ];
                url = "https://wiki.nixos.org/";
              }
            ];
          }
        ];
      };

      pinsForce = true;
      pins = {
        "GitHub" = {
          id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
          workspace = spaces."Kosmos".id;
          url = "https://github.com";
          position = 101;
          isEssential = false;
        };
        "ChatGPT" = {
          id = "51e8a119-5a14-4826-9545-91c8e8dd3bf6";
          workspace = spaces."Kosmos".id;
          url = "https://chatgpt.com";
          position = 102;
          isEssential = false;
        };
      };

      containersForce = true;
      containers = {
        KTQQ = {
          color = "purple";
          icon = "tree";
          id = 1;
        };
        Canvas = {
          color = "blue";
          icon = "briefcase";
          id = 2;
        };
      };

      spacesForce = true;
      spaces = {
        "Kosmos" = {
          id = "572910e1-4468-4832-a869-0b3a93e2f165";
          icon = "🍁";
          container = containers."KTQQ".id;
          position = 1000;
          theme = {
            type = "gradient";
            colors = [
              {
                red = 26;
                green = 24;
                blue = 25;
                algorithm = "floating";
                type = "explicit-lightness";
              }
            ];
            opacity = 0.8;
            texture = 0.5;
          };
        };
        "Lyceum" = {
          id = "ec287d7f-d910-4860-b400-513f269dee77";
          icon = "📚";
          position = 1001;
          container = containers."Canvas".id;
          theme = {
            type = "gradient";
            colors = [
              {
                red = 11;
                green = 29;
                blue = 27;
                algorithm = "floating";
                type = "explicit-lightness";
              }
            ];
            opacity = 0.2;
            texture = 0.5;
          };
        };
      };

      search = {
        force = true;
        default = "google";
        engines =
          let
            nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          in
          {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "np" ];
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "nop" ];
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master"; # unstable
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "hmop" ];
            };
            bing.metaData.hidden = "true";
          };
      };
    };
  };
}
