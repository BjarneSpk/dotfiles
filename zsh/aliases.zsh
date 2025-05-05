#!/usr/bin/env zsh

alias vim="nvim"
alias py="python3"
alias mv="mv -i"
alias cp="cp -i"
alias c="clear"
alias rm="trash"
alias ls="eza --color=always"
alias tree="eza --tree --icons --git"
alias la="ls -AH"
alias l="ls -lAH"
alias lt="eza --tree --level=2 --long --icons --git"
alias as="aerospace"
alias cat="bat"

mcd() {
    mkdir "${1}" && cd "${1}"
}

ff() {
    aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}


# Makes Yazi change into cwd when called with 'y' and exited with 'q'
function ex() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
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

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
