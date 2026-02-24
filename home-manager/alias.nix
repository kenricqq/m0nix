let
  baseAliases = {
    # Show All Aliases
    all = "awk '/^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=/ { gsub(/^[[:space:]]+/, \"\"); gsub(/[[:space:]]*;$/, \"\"); print }' $HM/alias.nix | sort | fzf | cut -d ' ' -f1";

    # Git Tools
    root = "z \"$(git rev-parse --show-toplevel 2>/dev/null)\"";

    # Core tools
    snip = "$EDITOR $HM/snippets";
    log = "$EDITOR /var/log/keystroke.log";

    # scripts functions
    zu = "$EDITOR $SCRIPTS/utils.zsh";
    rb = "$EDITOR $SCRIPTS/rofi-beats";
    be = "$EDITOR $HOME/.config/btca/btca.json";
    links = "$EDITOR $SCRIPTS/golinks.yaml";

    # utils
    venv = "source $(fd -HI -td .venv \"$(git rev-parse --show-toplevel)\" | head -n 1)/bin/activate";
    mdo = "mdbook serve -o";
    whtr = "curl wttr.in/Santa+Cruz";
    wsh = "which $SHELL";
    rustbook = "zellij --layout rustbook";
    airport = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport";
    mergepdf = "gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf";
    # Lock the screen (when going AFK)
    afk = "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend";
    # path = "echo -e \${PATH//:/\\n}";
    path = "echo \"$PATH\" | tr ':' '\\n'";
    localip = "ipconfig getifaddr en0";
    ip4 = "dig -4 +short TXT o-o.myaddr.l.google.com @ns1.google.com";
    ip6 = "dig -6 +short TXT o-o.myaddr.l.google.com @ns1.google.com";
    du1 = "du -d 1 .";
    zoa = "zoxide add"; # boost a directory ranking; run multiple times to get it high
    ze = "zesh cn $(zesh l | fzf)";
    zc = "zesh cn";
    restart = "pids=$(lsof -t -nP -iTCP:6600 -sTCP:LISTEN -a -c mpd | sort -u); [[ -n \"$pids\" ]] && kill $pids && mpd";

    et = "sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"; # empty trash
    cleanup = "fd . -type f -name '*.DS_Store' -ls -delete";
    docs = "hx $NX/docs_db"; # upgrade -> keybind open floating pane in zellij

    ## ----- ##
    # alias magic='kt && sudo zsh m1_backup/backup.zsh'
    # alias backup='hx ~/Documents/KTQQ/m1_backup/backup.zsh'
    # alias setup='hx ~/Documents/KTQQ/m1_backup/mac-setup.zsh'
    # alias quote='hx ~/.config/misc/quote.py'
    # alias obs = open "obsidian://open?vault=tree&file=+dashboard"
  };

  remapAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    a = "asciinema";
    c = "codex";
    cd = "z";
    ci = "zi";
    cl = "clear";
    clip = "pbcopy";
    curl = "curlie";
    df = "duf";
    du = "dust";
    e = "exit";
    ei = "eilmeldung";
    ff = "fastfetch";
    j = "just";
    jh = "just --help";
    jq = "gojq";
    # lg = "lazygit";
    lj = "lazyjj";
    oc = "opencode";
    ps = "procs";
    python = "python3";
    py = "python3";
    r = "rust";
    rg = "rga";
    sd = "sed";
    yy = "y";
    zed = "zed-preview";
    zel = "zellij";
    zell = "zellij --layout";

    # ls
    l = "ls -lah";
    ll = "ls -l";
    ls = "eza";
    lt = "ls -T -L=2 -l --icons --git";

    # utils
    mp = "multipass";
  };

  navAliases = {
    # general
    desk = "cd ~/Desktop";
    hm = "cd $HM";
    kt = "cd ~/Documents/KTQQ";
    nx = "cd $NX";
    sand = "cd ~/Sandbox";
    sc = "cd ~/Documents/school";

    # projects / notes

    wsco = "cd $DOT/nushell/zellij-workspaces.toml";
    notes = "cd ~/Documents/notes";
    dev = "cd ~/dev/$(ls ~/dev | fzf) && hx .";
  };

  nixAliases = {
    # dhm = "cd $NX && yq eval 'keys | .[] | select(. != \"sops\")' secrets/secrets.yaml > secrets.list && sudo darwin-rebuild switch --flake . && rm secrets.list && fish -c 'fisher update' && cd -";
    dhm = "cd $NX && sudo darwin-rebuild switch --flake . && cd -";

    # dhmp = "cd $NX && sudo darwin-rebuild switch --flake . --impure";
    nfu = "cd $NX && sudo nix flake update && sudo darwin-rebuild switch --flake . && cd -";
    nso = "nix store optimise";
    nsh = "sh -c 'if [ \"$#\" -eq 0 ]; then exec nix shell; else exec nix shell \"nixpkgs#$1\"; fi' sh";
    nca = "nh clean all";
    ndr = "cd $NX && nh darwin switch . && terminal-notifier -message 'darwin-rebuild done!' -sound default";
    search = "nh search --limit 3";
    repair = "sudo nix-store --verify --repair";
    update = "cd $NX && nix flake update";
    sec = "cd $NX/secrets && sops secrets.yaml";
  };

  # Nix Config
  nxFiles = {
    flake = "flake.nix";
  };

  dwFiles = {
    # System
    bco = "homebrew.nix";
    darwin = "configuration.nix";
    foco = "fonts.nix";
    sysco = "system.nix";
  };

  hmFiles = {
    # Core
    home = "home.nix";

    # Shell / CLI Tools
    alco = "alias.nix";
    # cco = "codex.nix";
    fco = "fish.nix";
    hco = "helix.nix";
    lsco = "lsp.nix";
    lgco = "lazygit.nix";
    nuco = "nushell.nix";
    ohco = "oh-my-posh.nix";
    oco = "opencode.nix";
    pco = "python.nix";
    paco = "paths.nix";
    sco = "starship.nix";
    shco = "ssh.nix";
    stco = "streamlink.nix";
    vco = "vcs.nix";
    yzco = "yazi.nix";
    zeco = "zellij.nix";
    zenco = "zen.nix";
    zco = "zsh.nix";

    clico = "cli-tools.nix";
    dbco = "db-tools.nix";
    devco = "dev-tools.nix";
    knco = "knowledge-tools.nix";
    meco = "media-tools.nix";
    pfco = "performance-tools.nix";
    vsco = "visual-tools.nix";

  };

  dotFiles = {
    # Dotfiles
    aico = "ai";
    cco = "codex";
    ghco = "ghostty/config";
    rco = "rio/config.toml";
    zelco = "zellij";
    # fhco = "fish";
    glco = "glance/glance.yml";
    yzxco = "yazelix/yazelix.toml";
    zkco = "zk/config.toml";
  };

  toolCommandAliases = {
    # Dev Tools
    bun = {
      bd = "-b run dev";
      bb = "run build";
      bp = "run preview";
      bf = "run format";
      bu = "update";
      ba = "add";
      bi = "install";
      br = "run";
      bl = "pm list";
    };
    pnpm = {
      pd = "run dev";
      pb = "run build";
      pp = "run preview";
      pf = "run format";
      pu = "update";
      pa = "add";
      pi = "install";
      pr = "run";
      prm = "remove";
      px = "dlx";
    };
    cargo = {
      ca = "add";
      cb = "build";
      cbi = "binstall";
      cc = "check";
      ci = "init";
      cn = "new";
      cr = "run";
      ct = "test";
      cu = "update";
    };
    rustup = {
      rt = "toolchain";
      ru = "update";
      rd = "default";
    };
    git = {
      ga = "add";
      gc = "commit -m";
      gl = "pull";
      gp = "push";

      ig = "status --ignored";
      grhh = "reset --hard HEAD";
      stat = "status";
      gdiff = "diff HEAD";
      vdiff = "difftool HEAD";
      glog = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      cfg = "--git-dir=$HOME/dotfiles/ --work-tree=$HOME";
    };
    go = {
      gt = "test";
      gta = "test ./.../";
      gtb = "test -bench=.";
      gb = "build";
      gr = "run";
    };
    jj = {
      # Daily flow
      ja = "abandon";
      jc = "commit -m"; # short for `jj describe; jj new`
      jd = "describe -m";
      jdf = "diff";
      je = "edit";
      jf = "file";
      jl = "log";
      jla = "log -r ::";
      jn = "new";
      jrb = "rebase";
      jrs = "resolve";
      jst = "status";
      jsp = "split";
      jsq = "squash";
      ju = "undo"; # undo last command

      # Operation
      jop = "op";
      jopr = "op restore";

      # Bookmarks
      jb = "bookmark";
      jbs = "bookmark set"; # create or move bookmark
      jbl = "bookmark list";
      jbr = "bookmark rename";
      jbt = "bookmark track";

      # Git bridge
      jgf = "git fetch";
      jgi = "git init";
      jgp = "git push";

      # Config/maintenance
      jeu = "config edit --user";
      jbo = "backout"; # similar to git revert
    };
    uv = {
      ue = "venv";
      ui = "init";
      ua = "add";
      ur = "run";
      ux = "tool run"; # run tool; `ux ruff`
      us = "sync"; # sync dep with venv
      ut = "tree"; # tree view for dep
      uu = "sync --upgrade";
    };
    zig = {
      zb = "build";
      zf = "format";
      zi = "init";
      zr = "run";
      zt = "test";
    };
  };

  # Aliases pointing to editable config files
  mkEditorAliases =
    basePath: files: builtins.mapAttrs (name: file: "$EDITOR ${basePath}/${file}") files;

  # Tool command aliases like: bd = "bun run dev"
  mkToolAliases =
    toolGroups:
    builtins.foldl' (
      acc: tool: acc // builtins.mapAttrs (name: cmd: "${tool} ${cmd}") toolGroups.${tool}
    ) { } (builtins.attrNames toolGroups);

in
baseAliases
// remapAliases
// navAliases
// nixAliases
// mkEditorAliases "$NX" nxFiles
// mkEditorAliases "$DW" dwFiles
// mkEditorAliases "$HM" hmFiles
// mkEditorAliases "$DOT" dotFiles
// mkToolAliases toolCommandAliases

## Extras ##

# kco = "kitty.nix";
# wco = "wezterm.nix";
# vsco = "vscode.nix";
# chco = "chromium.nix";
# sbco = "sketchybar";
# aco = "aerospace/aerospace.toml";
