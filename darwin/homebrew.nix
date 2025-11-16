{
  ###
  # Caution: homebrew packages have side effects in that dependencies can clash with packages/dependencies installed through nixpkgs
  ###
  enable = true;
  onActivation = {
    autoUpdate = true;
    cleanup = "zap";
    upgrade = true;
  };
  global.brewfile = true;
  # whalebrews = [
  #   "whalebrew/whalesay"
  masApps = {
    # Xcode = 497799835;
    # Drafts = 1236254471;
  };
  taps = [
    # "koekeishiya/formulae" # yabai/skhd
    "FelixKratz/formulae" # bars/borders
    # "supabase/tap"
    "nikitabobko/tap" # aerospace
    # "surrealdb/tap"
    "twilio/brew"
  ]; # ];
  brews = [
    # "typescript"
    # "whalebrew"
    # "podman"
    "asdf" # multiple runtime manager
    "kanata"
    # "pnpm"
    # "docker"
    # "docker-compose"
    {
      name = "uv";
      args = [ "HEAD" ];
    }
    "tgpt"
    "espeak-ng"
    "sevenzip"

    "sketchybar"
    # "borders"
    "lua"

    "cocoapods" # for building ios apps
    "switchaudio-osx"
    "nowplaying-cli"
    "cava"
    "choose-gui"
    "terminal-notifier"
    # "cocoapods"
    "ollama"
    # "llvm"
    {
      name = "yt-dlp";
      args = [ "HEAD" ];
    }
    # "localai" # run local llms

    # "surreal"
    # "supabase"
    # "aws-shell"

    # "ghc"
    # "ghcup"
    # "haskell-stack"

    # "fish"
    "fisher"
    # "twilio"
  ];
  casks = [
    # dev
    # "ngrok"
    "visual-studio-code"
    # "chatgpt-atlas"
    # "kitty"
    "wezterm"
    "ghostty@tip"
    "rio"
    "zed@preview"
    "orbstack" # lightweight docker containers
    # "legcord" # discord desktop client
    "yaak" # api client
    "signal"
    "tailscale-app"
    "linear-linear"
    # "amazon-q"
    "shottr" # screenshot tool
    "celestia" # 3D Space Simulator
    # "superwhisper" # local speech to text

    # objective-see (security tools)
    "lulu" # firewall
    "oversight" # mic / webcam monitor
    "reikey" # key tap monitor

    ## TOOLS
    "aerospace"
    # "alt-tab" # app switcher w/ screenshot preview
    "raycast" # app launcher
    "activitywatch"
    "zoom"
    "loom"
    "numi"
    "secretive" # Store SSH keys in the Secure Enclave
    "chatgpt"
    "claude"
    "karabiner-elements"
    "iina" # open-source media player
    # "obs" # screen recording
    # "background-music"
    "keycastr"
    # "cold-turkey-blocker"

    # "figma"
    # "adobe-creative-cloud"
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
    "thebrowsercompany-dia"
    # "brave-browser"
    "zen"

    # privacy
    "protonvpn"
    "proton-pass"

    # fonts
    "font-space-mono-nerd-font"
    # "font-3270-nerd-font"
    "font-0xproto-nerd-font"

    # "font-commit-mono-nerd-font"
    "font-iosevka-term-nerd-font"
    "font-monaspace"
    "font-jetbrains-mono-nerd-font"
    # "font-source-code-pro"
    "font-sf-mono"
    "font-sf-pro"

    # serif fonts
    "font-eb-garamond" # text
    # "font-ibarra-real-nova" # text
    # "font-source-serif-4" # text
    "font-dm-serif-display" # title / headings

    "font-sketchybar-app-font"
    "sf-symbols" # apple icons
  ];
}
