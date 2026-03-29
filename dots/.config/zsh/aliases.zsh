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
alias pacbrowse="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias open="xdg-open"
alias infvpn="sudo openconnect --protocol=anyconnect vpn.informatik.uni-stuttgart.de --cafile ~/Downloads/infcacert.crt"

mcd() {
    mkdir "${1}" && cd "${1}"
}

# used to reload colors with matugen
TRAPUSR1() {
  source "$DOTFILES/dots/.config/zsh/colors.zsh"
}

_ps1_setup() {
  setopt PROMPT_SUBST
  autoload -Uz add-zsh-hook
  _ps1() {
    local ret=$? pipes=("${pipestatus[@]}")
    local esc=$'\e' z='%{%f%b%}'
    local m r h w
    local saved=$(stty -g)
    stty -echo
    printf '\e[6n'
    local raw col
    IFS=';' read -d 'R' -rs raw col < /dev/tty
    stty "$saved"
    col=$(( ${col:-0} + 0 ))
    (( col > 1 )) && m="%{${esc}[;45m%} ${z}"$'\n'
    (( ret )) && r="%F{red}${(j:|:)pipes}%f "
    [[ -n $SSH_CONNECTION ]] && h="@%m"
    local cur="%1~"
    local w="${PWD/#$HOME/~}"
    if [[ $w != "~" && $w != "/" ]]; then
      w=$(abbr "$w")
      [[ $w == "/" ]] && w=""
    else
      cur=""
    fi
    PROMPT=" ${m}${r}%F{${THEME_USER:-blue}}%n${h}%f %F{${THEME_PATH:-cyan}}${w}${cur}%f %F{${THEME_SYMBOL:-white}}%#%f "
  }
  add-zsh-hook precmd _ps1
}
_ps1_setup

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
