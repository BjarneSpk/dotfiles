#!/usr/bin/env zsh

alias lg="lazygit"
alias vim="nvim"
alias py="python3"
alias c="clear"
alias ls="eza --color=always"
alias tree="eza --tree --icons --git"
alias la="ls --sort=time -AH"
alias l="ls --sort=time -lAH"
alias lt="eza --tree --level=2 --long --icons --git"
alias cat="bat"
alias top="btop"
alias pow="upower -i $(upower -e | grep BAT) | grep -oP '(percentage:\s*\K(\d*%)|state:\s*\K(.*))' | sort | tr '\n' ' ' && echo"
alias pac-browse="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias open="xdg-open"
alias infvpn="sudo openconnect --protocol=anyconnect vpn.informatik.uni-stuttgart.de --cafile ~/Downloads/infcacert.crt"
alias matrix="cmatrix -a -s -b"

mcd() {
    mkdir "${1}" && cd "${1}"
}

# Makes Yazi change into cwd when called with 'y' and exited with 'q'
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
alias md='mkdir -p'
alias rd=rmdir

# alias d='dirs -v'
alias d='cd ${~"$(dirs -v | fzf | awk "{print \$2}")"}'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
