# # REMAP SHORTCUTS
# alias cd="z"
# # cy () {
# #   z $1 && yazi .
# # }
# alias cdi="zi"
# alias ls="eza"
# alias l="ls -lah"
# alias ll="ls -l"
# alias lt="ls -T -L=2 -l --icons --git"
# alias mp="multipass"

# # NAV SHORTCUTS
# alias kt='cd ~/Documents/KTQQ'
# alias hm='cd $HM'
# alias sand='cd ~/Sandbox'
# alias proj='cd ~/Projects'
# alias po='p && hx .'
# alias notes='cd ~/notes'
# alias sc='cd ~/school'

# # APP SHORTCUTS
# # alias obs = open "obsidian://open?vault=tree&file=+dashboard"

# # Nix SHORTCUTS
# # nix run nix-darwin/master#darwin-rebuild -- switch
# alias dhm='cd $HM && darwin-rebuild switch --flake .'
# alias dhmp='cd $HM && darwin-rebuild switch --flake . --impure'
# alias darling='cd $HM && darwin-rebuild switch --flake . && sudo zsh ~/Documents/KTQQ/m1_backup/backup.zsh && nix-collect-garbage'
# alias sg='sudo nix-collect-garbage -d'


# UTILS FUNCTIONS

# aerospace functions
function ff() {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# yazi w/ dir nav
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# fuzzy dir search
cdf() {
  local target

  target=$(fd --type f --hidden | fzf --preview='
    if file --mime-type {} | rg -qF image/; then
      kitty icat --clear --transfer-mode=memory --stdin=no --place=30x30@0x0 {}
    else
      bat --color always --style numbers --theme TwoDark --line-range :200 {}
    fi'
  )

  if [[ -n "$target" ]]; then
      if [[ -d "$target" ]]; then
          cd "$target"
      else
          cd "$(dirname "$target")"
      fi
  fi
}

# Navigate dev/project folders
dev() {
  project=$(ls $DEV | sk --prompt "Switch to project: ")
  [ -n "$project" ] && cd $DEV/$project && onefetch && y
}

sv() {
  sv_proj=$(ls $PROJ_DIR/SvelteKit | sk --prompt "cd into project: ")
  [ -n "$sv_proj" ] && cd $PROJ_DIR/SvelteKit/$sv_proj && y
}

py() {
  py_proj=$(ls $PROJ_DIR/Python | sk --prompt "cd into project: ")
  [ -n "$py_proj" ] && cd $PROJ_DIR/Python/$py_proj && y
}

rs() {
  rs_proj=$(ls $PROJ_DIR/Rust | sk --prompt "cd into project: ")
  [ -n "$rs_proj" ] && cd $PROJ_DIR/Rust/$rs_proj && y
}


# Google / Youtube
gg() { open "https://www.google.com/search?q=$(echo "$*" | sed 's/ /+/g')" }
yt() { open "https://www.youtube.com/results?search_query=$(echo "$*" | sed 's/ /+/g')" }

# md live preview
lv() {
  ls "$@" | entr -c glow "$@"
}

