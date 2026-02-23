#!/usr/bin/env zsh

alias lg="lazygit"
alias vim="nvim"
alias c="clear"
alias ls="eza --color"
alias tree="eza --tree --color --icons --git"
alias la="ls --sort=time --color -a"
alias l="ls --sort=time --color --icons -la"
alias lt="eza --tree --level=2 --long --color --icons --git -A"
alias cat="bat"
alias top="btop"
# alias pow="upower -i $(upower -e | grep BAT) | grep -oP '(percentage:\s*\K(\d*%)|state:\s*\K(.*))' | sort | tr '\n' ' ' && echo"
alias pac-browse="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias open="xdg-open"
alias infvpn="sudo openconnect --protocol=anyconnect vpn.informatik.uni-stuttgart.de --cafile ~/Downloads/infcacert.crt"

mcd() {
    mkdir "${1}" && cd "${1}"
}

# used to reload colors with matugen
TRAPUSR1() {
  source "$DOTFILES/dots/.config/zsh/colors.zsh"
}

# Makes Yazi change into cwd when called with 'ex' and exited with 'q'
function ex() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias egrep='grep -E'
alias fgrep='grep -F'

rfv() {
  # Two-phase filtering with Ripgrep and fzf
  #
  # 1. Search for text in files using Ripgrep
  # 2. Interactively restart Ripgrep with reload action
  #   * Switch between Ripgrep mode and fzf filtering mode (CTRL-T)
  # 3. Open the file in Neovim
  rm -f /tmp/rg-fzf-{r,f}
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="${*:-}"
  fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
        echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
        echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --prompt '1. ripgrep> ' \
      --delimiter : \
      --header 'CTRL-T: Switch between ripgrep/fzf' \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become(vim {1} +{2})'
}

rfi() {
  export TEMP=$(mktemp -u)
  trap 'rm -f "$TEMP"' EXIT

  INITIAL_QUERY="${*:-}"
  TRANSFORMER='
    rg_pat={q:1}      # The first word is passed to ripgrep
    fzf_pat={q:2..}   # The rest are passed to fzf

    if ! [[ -r "$TEMP" ]] || [[ $rg_pat != $(cat "$TEMP") ]]; then
      echo "$rg_pat" > "$TEMP"
      printf "reload:sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case %q || true" "$rg_pat"
    fi
    echo "+search:$fzf_pat"
  '
  fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --with-shell 'bash -c' \
      --bind "start,change:transform:$TRANSFORMER" \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-line,+{2}+3/3,~3' \
      --bind 'enter:become(vim {1} +{2})'
}

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# alias d='dirs -v'
alias d='cd ${~"$(dirs -v | fzf | awk "{print \$2}")"}'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

function uniprint() {
# Set the print location based on the second argument
  if [ "$2" = "oben" ]; then
    standort="duesentrieb"
  else
    standort="zarquon"
  fi

  # Check if the first argument is a directory
  if [ -d "$1" ]; then
    # Loop through all PDF files in the directory
    for elem in "$1"/*.pdf; do
      # Check if any PDF files exist
      if [ -f "$elem" ]; then
        # Copy the file to the remote server and print it
        scp "$elem" "uni:~/Documents/$(basename "$elem")"
        ssh uni "lpr -P $standort ~/Documents/$(basename "$elem")"
      fi
    done
  else
    # If it's a file, copy and print it
    scp "$1" "uni:~/Documents/$(basename "$1")"
    ssh uni "lpr -P $standort ~/Documents/$(basename "$1")"
  fi
}
