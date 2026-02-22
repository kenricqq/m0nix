{
  lib,
  pkgs,
  path,
  ...
}:

let
  inherit (path)
    home
    ;

  # This should be the nix file you pasted (the one that returns the merged attrset)
  aliases = import ./alias.nix;

  # Create a Nu raw string r#'... '#, increasing # count if needed
  mkNuRaw =
    s:
    let
      mk =
        n:
        let
          hashes = lib.concatStringsSep "" (builtins.genList (_: "#") n);
          endMarker = "'${hashes}";
        in
        if lib.strings.hasInfix endMarker s then mk (n + 1) else "r${hashes}'${s}'${hashes}";
    in
    mk 1;

  isComplex =
    cmd:
    lib.any (needle: lib.strings.hasInfix needle cmd) [
      "$("
      "&&"
      "||"
      "|"
      ";"
      ">"
      "<"
      "2>"
      "`"
      "\\ "
    ];

  rewriteEnv =
    cmd:
    lib.replaceStrings
      [
        "$HOME"
        "$EDITOR"
        "$SHELL"
        "$PATH"
        "$NX"
        "$DW"
        "$HM"
        "$DOT"
        "$SCRIPTS"
      ]
      [
        "$env.HOME"
        "$env.EDITOR"
        "$env.SHELL"
        "$env.PATH"
        "$env.NX"
        "$env.DW"
        "$env.HM"
        "$env.DOT"
        "$env.SCRIPTS"
      ]
      cmd;

  quoteNu = s: "\"${lib.replaceStrings [ "\\" "\"" ] [ "\\\\" "\\\"" ] s}\"";

  # turns `$env.DOT/ghostty/config` into `([$env.DOT, "ghostty", "config"] | path join)`
  mkNuPathExpr =
    s:
    let
      m = builtins.match "^\\$env\\.([A-Za-z_][A-Za-z0-9_]*)/(.+)$" s;
    in
    if m == null then
      null
    else
      let
        var = builtins.elemAt m 0;
        rest = builtins.elemAt m 1;
        segs = lib.splitString "/" rest;
        segsQuoted = map quoteNu segs;
      in
      "([$env.${var}, ${lib.concatStringsSep ", " segsQuoted}] | path join)";

  mkNuArg =
    s:
    let
      pathExpr = mkNuPathExpr s;
    in
    if pathExpr != null then
      pathExpr
    else if lib.strings.hasInfix " " s then
      quoteNu s
    else
      s;

  render =
    name: cmd:
    let
      nuCmd = rewriteEnv cmd;
    in
    if isComplex cmd then
      # Keep exact semantics for shell-y aliases
      "alias ${name} = ^zsh -lc ${mkNuRaw cmd}"
    else if lib.strings.hasPrefix "$env.EDITOR " nuCmd then
      let
        target = lib.removePrefix "$env.EDITOR " nuCmd;
      in
      # Use a nu function because alias can't start with $env.EDITOR and paths need join
      "def ${name} [] { run-external $env.EDITOR ${mkNuArg target} }"
    else
      "alias ${name} = ${nuCmd}";

  nuAliasesText = lib.concatStringsSep "\n" (lib.mapAttrsToList render aliases) + "\n";

in
{
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = false;
    # multiverse-neon
    useTheme = "M365Princess";

    # configFile = "${path.dot}/oh-my-posh/p10k-lean-jj.omp.json";
    # configFile = "${path.dot}/oh-my-posh/jj-v3.json";
    # settings = {
    #   "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
  };

  home.file = {
    ".config/nushell/autoload/99-aliases.nu".text = nuAliasesText;
    ".config/nushell/modules/ws.nu".source = ./dotfiles/nushell/modules/ws.nu;
    ".config/zesh/zellij-workspaces.toml".source = ./dotfiles/nushell/zellij-workspaces.toml;
  };

  programs.nushell = {
    enable = true;
    shellAliases = { };
    configDir = "${home}/.config/nushell";
    plugins = with pkgs.nushellPlugins; [
      formats
      gstat
      # highlight
      polars
      query
    ];
    extraConfig = ''
      # -- SETTINGS -- #       
      $env.config.show_banner = false
      $env.config.edit_mode = 'vi'

      let sep = (char esep)

      let add = [
        $"($env.HOME)/.cargo/bin"
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.bun/bin"
        $"($env.HOME)/.cache/.bun/bin"
        $"($env.HOME)/.nix-profile/bin"
        $"($env.HOME)/go/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/opt"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        $"/etc/profiles/per-user/($env.USER)/bin"
      ]

      $env.PATH = (
        $env.PATH
        | split row $sep
        | prepend $add
        | uniq
        | str join $sep
      )

      $env.config.keybindings ++= [
        {
          name: accept_hint_or_move_right
          modifier: control
          keycode: char_f
          mode: [vi_insert vi_normal]  # add/remove modes as you like
          event: {
            until: [
              { send: historyhintcomplete }  # accept autosuggestion (history hint)
              { send: right }               # otherwise behave like normal Ctrl-F (forward char)
            ]
          }
        }
      ]

      def --env y [...args] {
      	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
      	^yazi ...$args --cwd-file $tmp
      	let cwd = (open $tmp)
      	if $cwd != $env.PWD and ($cwd | path exists) {
      		cd $cwd
      	}
      	rm -fp $tmp
      }

      # custom zellij workspaces script
      use ~/.config/nushell/modules/ws.nu * 
    '';

    # extraEnv = "";

    # extraLogin = ''
    # '';

    # configFile = {
    #   text = ''
    #     $env.config.filesize_metric = false
    #     $env.config.table_mode = 'rounded'
    #     $env.config.use_ls_colors = true
    #   '';
    # };
  };
}
