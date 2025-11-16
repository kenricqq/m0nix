# Paths
# HM="$HOME/.config/home-manager"
# DOT="$HM/dotfiles"

# Alias Generator
ag() {
  alias "$1"="$EDITOR $HM/$2.nix"
}

# Core Config
ag flake flake # alias flake='hx $HM/flake.nix'
ag darwin configuration
ag home home

# System Config
ag sysco system
ag seco security
ag bco homebrew

# Shell / CLI Tools
ag zco zsh
ag alco alias
ag fco fish
ag yzco yazi
ag atco atuin
ag shco ssh
ag pco python
alias snip="$EDITOR $HM/snippets"

# Apps Config
ag kco kitty
ag wco wezterm
ag hco helix
ag vco vscode
ag cco chromium

# Alias Dotfiles Generator
ad() {
  alias "$1"="$EDITOR $DOT/$2"
}

# MacOS Dotfiles
ad sbco sketchybar
ad aco aerospace/aerospace.toml
ad ghco ghostty/config
ad ghco ghostty/config
ad sco starship

# alias skco='hx $DOT/skhd/skhdrc'
# alias yco='hx $DOT/yabai/yabairc'

# keystrokes logger
alias log='hx /var/log/keystroke.log'
