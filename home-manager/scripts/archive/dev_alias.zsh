# PATHS
SCRIPTS="$HOME/.config/home-manager/scripts"

# Bun
ab() {
  alias $1="bun $2"
}

ab bd 'run dev'
ab bb 'run build'
ab bp 'run preview'
ab bf 'run format'
ab bu 'update'
ab ba 'add'
ab bi 'install'
ab br 'run'

# PNPM
ap() {
  alias $1="pnpm $2"
}

ap pd 'run dev'
ap pb 'run build'
ap pb 'run build'
ap pp 'run preview'
ap pf 'run format'
ap pu 'update'
ap pa 'add'
ap pi 'install'
ap pr 'run'

unset -f ap

# Deno
alias dd='deno run dev'
alias dr='deno run -A'

di() {
  if [ "$#" -eq 0 ]; then
    deno install
  else
    deno install $(printf "npm:%s " "$@")
  fi
}

alias dt='deno task'
alias df='deno task format'
alias da='deno add'
alias dup='deno outdated --update --latest'

# uv
alias ua='uv add'
alias ui='uv init'

# Git
# alias ga="git add"
# alias gc="git commit -m"
# alias gl="git pull"
# alias gp="git push"
# alias gs="git status"
# alias glg="git log"
# alias grhh="git reset --hard HEAD"

alias stat="git status"
alias gdiff="git diff HEAD"
alias vdiff="git difftool HEAD"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias cfg="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias lg="lazygit"

# Make
alias m="make"
alias mf="make format"
alias mc="make clean"

# Scripts
alias t="zsh $SCRIPTS/tgpt.zsh"
alias or="zsh $SCRIPTS/ollama.zsh"
