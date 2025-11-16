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
end

# initialize zoxide
zoxide init fish | source

if status is-interactive
    export ZELLIJ_AUTO_ATTACH=true

    eval (zellij setup --generate-auto-start fish | string collect)
end
