{ config, pkgs }:

{
  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    policies =
      let
        mkLockedAttrs = builtins.mapAttrs (
          _: value: {
            Value = value;
            Status = "locked";
          }
        );
        mkExtensionSettings = builtins.mapAttrs (
          _: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          }
        );
      in
      {
        Preferences = mkLockedAttrs {
          "browser.tabs.warnOnClose" = false;
        };
        ExtensionSettings = mkExtensionSettings {
          "wappalyzer@crunchlabz.com" = "wappalyzer";
          "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium";
          "addon@darkreader.org" = "dark-reader";
          "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack" = "raindropio";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "deArrow@ajay.app" = "dearrow";
          "jid1-q4sG8pYhq8KGHs@jetpack" = "adblock-for-youtube";
          "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = "videospeed";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = "proton-pass";
        };
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
    profiles."default" = {
      containersForce = true;
      containers = {
        Personal = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "blue";
          icon = "briefcase";
          id = 2;
        };
        Shopping = {
          color = "yellow";
          icon = "dollarsign";
          id = 3;
        };
      };
      spacesForce = true;
      spaces =
        let
          containers = config.programs.zen-browser.profiles."default".containers;
        in
        {
          "Space" = {
            id = "c6de089c-410d-4206-961d-ab11f988d40a";
            position = 1000;
          };
          "Work" = {
            id = "cdd10fab-4fc5-494b-9041-325e5759195b";
            icon = "chrome://browser/skin/zen-icons/selectable/star-2.svg";
            container = containers."Work".id;
            position = 2000;
          };
          "Shopping" = {
            id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
            icon = "💸";
            container = containers."Shopping".id;
            position = 3000;
          };
        };
    };
  };
}
