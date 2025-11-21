{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    global.brewfile = true;
    masApps = {
      # DaVinci = 571213070;
    };
    taps = [
      "FelixKratz/formulae" # sketchybar/borders
      "nikitabobko/tap" # aerospace
    ]; # ];
    brews = [
      "humanlog"

      # "podman"
      # "kanata"
      # "docker-compose"
      # {
      #   name = "uv";
      #   args = [ "HEAD" ];
      # }
      "uv"
      "tgpt"
      # "espeak-ng" # for kokoro stt
      "sevenzip"
      "fisher"

      "sketchybar"
      # "borders"
      "lua"

      # "cocoapods" # for building ios apps
      # "switchaudio-osx"
      # "nowplaying-cli"
      "choose-gui"
      "terminal-notifier"
      "ollama"
      # "llvm"
      {
        name = "yt-dlp";
        args = [ "HEAD" ];
      }
      # "localai" # run local llms

      # "surreal"
      # "aws-shell"

      # "ghc"
      # "ghcup"
      # "haskell-stack"
    ];
    casks = [
      ## dev
      # "ngrok"
      # "visual-studio-code"
      "ghostty@tip"
      "rio"
      "zed@preview"
      "orbstack" # lightweight docker containers
      # "legcord" # discord desktop client
      "yaak" # api client
      # "signal"
      # "tailscale-app"
      "linear-linear"
      # "amazon-q"
      "shottr" # screenshot tool
      # "celestia" # 3D Space Simulator

      ## objective-see (security tools)
      # "lulu" # firewall
      # "oversight" # mic / webcam monitor
      # "reikey" # key tap monitor

      ## TOOLS
      "aerospace"
      # "alt-tab" # app switcher w/ screenshot preview
      "raycast" # app launcher
      "activitywatch"
      # "zoom"
      # "loom"
      "numi"
      "secretive" # Store SSH keys in the Secure Enclave
      "karabiner-elements"
      "iina" # open-source media player
      # "obs" # screen recording
      # "background-music"
      # "keycastr"

      # "google-drive"
      # "syncthing" # secure file sync
      # "multipass"

      # NOTES
      "obsidian"
      # "excalidrawz"
      "todoist-app"

      # browsers
      # "tor-browser"
      "helium-browser"
      # "zen"

      # privacy
      "protonvpn"
      "proton-pass"

      # fonts
      # "font-space-mono-nerd-font"
      # "font-3270-nerd-font"

      # "font-commit-mono-nerd-font"
      # "font-iosevka-term-nerd-font"
      #
      # "font-0xproto-nerd-font"
      # "font-monaspace"
      # "font-jetbrains-mono-nerd-font"
      #
      # "font-source-code-pro"
      # "font-sf-mono"
      "font-sf-pro"

      # serif fonts
      # "font-eb-garamond" # text
      # "font-ibarra-real-nova" # text
      # "font-source-serif-4" # text
      # "font-dm-serif-display" # title / headings

      "font-sketchybar-app-font"
      "sf-symbols" # apple icons
    ];
  };
}
