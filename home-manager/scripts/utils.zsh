# Wrapper Utils

# zellij helpers 
function zr () { zellij run --name "$*" -- zsh -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
function zri () { zellij run --name "$*" --in-place -- zsh -ic "$*";}
function ze () { zellij edit "$*";}
function zef () { zellij edit --floating "$*";}
function zei () { zellij edit --in-place "$*";}
function zpipe () { 
  if [ -z "$1" ]; then
    zellij pipe;
  else 
    zellij pipe -p $1;
  fi
}

ah() {
  local q="$*"
  alias | sed -E 's/^alias[[:space:]]+([^[:space:]]+)[[:space:]]+/\1|/' \
    | column -t -s '|' \
    | fzf --query "$q"
}

# alias selector, trigger with Ctrl-A
fzf_alias_widget() {
  local selected alias_name
  selected=$(
    awk '/^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=/ {
      gsub(/^[[:space:]]+/, "");
      gsub(/[[:space:]]*;$/, "");
      print
    }' $HM/alias.nix | sort | fzf --prompt="Alias> "
  )
  alias_name=${selected%%=*}
  alias_name=${alias_name// /}
  if [[ -n $alias_name ]]; then
    LBUFFER="$alias_name"
    zle accept-line
  fi
}
zle -N fzf_alias_widget
bindkey '^A' fzf_alias_widget  # Ctrl-A to trigger

uf() {
  local file="$SCRIPTS/utils.zsh" fn
  [[ -r "$file" ]] || { echo "Can't read $file"; return 1; }

  fn=$(
    sed -nE 's/^[[:space:]]*function[[:space:]]+([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*\(\)[[:space:]]*\{.*$/\1/p' "$file" \
      | sort -u \
      | fzf --prompt='utils(function)> ' --height=40% --reverse
  ) || return

  typeset -f -- "$fn" >/dev/null || { echo "$fn not in session — source $file?"; return 1; }
  "$fn"
}

# UTILS FUNCTIONS + Keyboard Shortcuts

# go links with choose-gui
golc() {
  local f="$SCRIPTS/golinks.yaml" key url
  key=$(yq -r '.links|keys[]' "$f" | choose) || return
  url=$(KEY="$key" yq -er '.links[env(KEY)]' "$f") || return
  open "$url"
}

# go links
function gol() {
  local f="$SCRIPTS/golinks.yaml"
  yq -r '.links | to_entries[] | [.key, .value] | @tsv' "$f" |
  fzf --prompt='link> ' --with-nth=1 --delimiter=$'\t' \
      --preview 'printf %s {2}' --preview-window=right:50% \
      --bind 'enter:execute(open {2})+abort'
}

function rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	hx "$file"
}

function colors() {
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f "
    if (( i % 6 == 3 )); then
      print
    fi
  done
}

# aerospace functions
function ff() {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

alias uuu="$EDITOR $SCRIPTS/use-utils"

# fuzzy dir search
function cdf() {
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
function dev() {
  project=$(ls $DEV | sk --prompt "Switch to project: ")
  [ -n "$project" ] && cd $DEV/$project && onefetch && y
}

function sv() {
  sv_proj=$(ls $PROJ_DIR/SvelteKit | sk --prompt "cd into project: ")
  [ -n "$sv_proj" ] && cd $PROJ_DIR/SvelteKit/$sv_proj && y
}

function py() {
  py_proj=$(ls $PROJ_DIR/Python | sk --prompt "cd into project: ")
  [ -n "$py_proj" ] && cd $PROJ_DIR/Python/$py_proj && y
}

function rs() {
  rs_proj=$(ls $PROJ_DIR/Rust | sk --prompt "cd into project: ")
  [ -n "$rs_proj" ] && cd $PROJ_DIR/Rust/$rs_proj && y
}


# Google / Youtube
gg() { open "https://www.google.com/search?q=$(echo "$*" | sed 's/ /+/g')" }
yt() { open "https://www.youtube.com/results?search_query=$(echo "$*" | sed 's/ /+/g')" }

urls() {
  open "$(echo "$*" | sed 's/ /+/g')"
}

# md live preview
lv() {
  ls "$@" | entr -c glow "$@"
}

# yt music download
yt_music() {
  local url="$1"
  local output_dir="${2:-$HOME/Music/podcasts}"

  if [[ -z "$url" ]]; then
    echo "Usage: youtube_download <YouTube_URL> [output_directory]"
    return 1
  fi

  if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp is not installed."
    return 1
  fi

  yt-dlp -f "bestvideo+bestaudio/best" -o "$output_dir/%(title)s.%(ext)s" "$url"
}

yt_vid() {
  # one simple flag: -s => download subtitles (en), prefer human, fallback to auto
  local want_subs=false
  local cleaned=()
  for a in "$@"; do [[ "$a" == "-s" ]] && want_subs=true || cleaned+=("$a"); done
  set -- "${cleaned[@]}"

  local url="$1"
  local output_dir="${2:-$HOME/Music/videos}"

  if [[ -z "$url" ]]; then
    echo "Usage: yt_download [-s] <YouTube_URL> [output_directory]"
    return 1
  fi

  if ! command -v yt-dlp &>/dev/null; then
    echo "yt-dlp is not installed."
    return 1
  fi

  mkdir -p "$output_dir" || return 1

  # base yt-dlp command
  local args=(-f "bestvideo+bestaudio/best" -o "$output_dir/%(title)s.%(ext)s")

  # add subs if -s was used
  if $want_subs; then
    args+=(--write-subs --write-auto-subs --sub-langs "en" --convert-subs srt)
  fi

  yt-dlp "${args[@]}" "$url"
}

function rst_md() {
  FILES=*.rst
  for f in $FILES
  do
    filename="${f%.*}"
    echo "Converting $f to $filename.md"
    `pandoc $f -f rst -t markdown -o $filename.md`
  done
}
