{
  # config,
  # lib,
  dir,
  ...
}:

{
  programs.fish = {
    enable = true;
    binds = {
      "alt-shift-b".command = "fish_commandline_append bat";
      "alt-s".erase = true;
      "alt-s".operate = "preset";
    };

    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };

      gitignore = ''
        set -l templates (string join , -- $argv)
        curl -sL "https://www.gitignore.io/api/$templates"
      '';

      fzf_alias_widget = ''
        set -l selected (awk "/^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=/ { gsub(/^[[:space:]]+/, ""); gsub(/[[:space:]]*;$/, ""); print }" $HM/alias.nix | sort | fzf --prompt="Alias> ")
        test -n "$selected"; or return
        set -l alias_name (string split -m1 "=" -- $selected)[1]
        set alias_name (string replace -a " " "" -- $alias_name)
        if test -n "$alias_name"
            commandline -r -- $alias_name
            commandline -f execute
        end
      '';

      uf = ''
        set -l file "$SCRIPTS/utils.fish"
        if not test -r "$file"
            echo "Can't read $file"
            return 1
        end

        set -l fn (sed -nE 's/^[[:space:]]*function[[:space:]]+([A-Za-z_][A-Za-z0-9_-]*)[[:space:]]*.*$/\1/p' "$file" \
            | sort -u \
            | fzf --prompt='utils(function)> ' --height=40% --reverse)
        test -n "$fn"; or return

        if not functions -q $fn
            echo "$fn not in session — sourcing $file"
            source "$file"
        end

        if functions -q $fn
            $fn
        else
            echo "Function '$fn' not found after sourcing $file"
            return 1
        end
      '';

      golc = ''
        set -l f "$SCRIPTS/golinks.yaml"
        set -l key (yq -r '.links|keys[]' "$f" | choose)
        test -n "$key"; or return
        set -l url (env KEY="$key" yq -er '.links[env(KEY)]' "$f")
        test -n "$url"; or return
        open "$url"
      '';

      gol = ''
        set -l f "$SCRIPTS/golinks.yaml"
        yq -r '.links | to_entries[] | [.key, .value] | @tsv' "$f" \
        | fzf --prompt='link> ' --with-nth=1 --delimiter=\t \
              --preview 'printf %s {2}' --preview-window=right:50% \
              --bind 'enter:execute(open {2})+abort'
      '';

      # ripgrep all | pipe into fzf
      rf = ''
        set -l RG_PREFIX 'rga --files-with-matches'
        set -l query $argv[1]

        set -l file (env FZF_DEFAULT_COMMAND="$RG_PREFIX '$query'" \
            fzf --sort \
                --preview='[ -n "{}" ] && rga --pretty --context 5 {q} {}'
                --phony -q "$query" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap")

        test -n "$file"; or return
        echo "opening $file"
        hx "$file"
      '';

      # utils
      colors = ''
        for i in (seq 0 255)
            printf '\e[48;5;%sm \e[0m\e[38;5;%sm%3d\e[0m ' $i $i $i
            if test (math "$i % 6") -eq 3
                echo
            end
        end
        echo
      '';

      ff = ''
        aerospace list-windows --all | \
            fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
      '';

      cdf = ''
        set -l target (fd --type f --hidden \
            | fzf --preview=' if file --mime-type {} | rg -qF image/; then kitty icat --clear --transfer-mode=memory --stdin=no --place=30x30@0x0 {}; else bat --color always --style numbers --theme TwoDark --line-range :200 {}; fi' )
        test -n "$target"; or return

        if test -d "$target"
            cd "$target"
        else
            cd (path dirname -- "$target")
        end
      '';

      # google and youtube search shortcut
      gg = ''
        set -l q (string join ' ' $argv | string replace -a ' ' '+')
        open "https://www.google.com/search?q=$q"
      '';
      yt = ''
        set -l q (string join ' ' $argv | string replace -a ' ' '+')
        open "https://www.youtube.com/results?search_query=$q"
      '';

      urls = ''
        set -l q (string join ' ' $argv | string replace -a ' ' '+')
        open "$q"
      '';

      # download music and videos from YT
      yt_music = ''
        set -l url $argv[1]
        set -l output_dir "$HOME/Music/podcasts"
        if test (count $argv) -ge 2
            set output_dir $argv[2]
        end

        if test -z "$url"
            echo "Usage: yt_music <YouTube_URL> [output_directory]"
            return 1
        end
        if not type -q yt-dlp
            echo "yt-dlp is not installed."
            return 1
        end

        yt-dlp -f bestvideo+bestaudio/best -o "$output_dir/%(title)s.%(ext)s" -- "$url"
      '';
      yt_vid = ''
        argparse 's' -- $argv; or return

        set -l url $argv[1]
        set -l output_dir "$HOME/Music/videos"
        if test (count $argv) -ge 2
            set output_dir $argv[2]
        end

        if test -z "$url"
            echo "Usage: yt_vid [-s] <YouTube_URL> [output_directory]"
            return 1
        end
        if not type -q yt-dlp
            echo "yt-dlp is not installed."
            return 1
        end

        mkdir -p "$output_dir"; or return 1

        set -l args -f bestvideo+bestaudio/best -o "$output_dir/%(title)s.%(ext)s"
        if set -q _flag_s
            set args $args --write-subs --write-auto-subs --sub-langs en --convert-subs srt
        end

        yt-dlp $args -- "$url"
      '';

      rst_md = ''
        for f in *.rst
            test -e "$f"; or continue
            set -l filename (string replace -r '\.rst$' "" -- "$f")
            echo "Converting $f to $filename.md"
            pandoc "$f" -f rst -t markdown -o "$filename.md"
        end
      '';
    };

    # interactiveShellInit = builtins.readFile ./dotfiles/fish/config.fish;
    interactiveShellInit = ''
      set -gx EDITOR hx
      set -g fish_greeting ""

      # Only source if $SCRIPTS is set and file exists
      # if test -n "$SCRIPTS"; and test -f "$SCRIPTS/utils.fish"
      #   source "$SCRIPTS/utils.fish"
      # end

      # !! -> last command
      function bind_bang
        switch (commandline -t)[-1]
          case "!"
            commandline -t -- $history[1]
            commandline -f repaint
          case "*"
            commandline -i !
        end
      end

      # !$  -> last arg of last command
      function bind_dollar
        switch (commandline -t)[-1]
          case "!"
            commandline -f backward-delete-char history-token-search-backward
          case "*"
            commandline -i '$'
        end
      end

      function fish_user_key_bindings
        fish_vi_key_bindings insert

        bind ! bind_bang
        bind '$' bind_dollar

        bind -M insert \cf accept-autosuggestion
        bind \cf accept-autosuggestion
      end

      # initialize zoxide
      zoxide init fish | source
    '';

    loginShellInit = ''
      # any login-specific env, if needed
    '';

    preferAbbrs = true;

    shellAbbrs = {
      l = "less";

      gco = "git checkout";
      "-C" = {
        position = "anywhere";
        expansion = "--color";
      };
      gs = "git status";
      lg = "lazygit";
      y = "yazi";

      dev = "cd $DEV";
      proj = "cd $PROJ_DIR";

      update = "nix flake update && home-manager switch";
    };

    # shellAliases = {
    #   cat = "bat";
    #   cd = "z";
    # };

    shellInit = '''';

    shellInitLast = '''';
  };
}
