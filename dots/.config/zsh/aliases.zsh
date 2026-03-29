#!/usr/bin/env zsh

alias lg="lazygit"
alias vim="nvim"
alias vi="nvim"
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

# condense help output, usage: h <cmd>
h() {
  { $@ --help 2>&1 || true; } | awk '/\S/;/gnu\.org/{exit}' | bat -Ppl help;
}

# opts() just the flags from --help
opts() {
  { $@ --help 2>&1 || true; } | rg '^\s*-' | bat -Ppl help | fzf
}

bigx() {
  du -xhd2 -t10M "${@:2}" | sort -h | tail -n "$1"
}

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
    local m r h w

    # insert colored marker and newline if previous output didn't print newline
    local saved col
    saved=$(stty -g)
    stty -echo
    printf '\e[6n'
    IFS=';' read -d 'R' -rs _ col < /dev/tty
    stty "$saved"
    col=$(( ${col:-0} ))
    (( col > 1 )) && m="%{\e[;45m%} %{%f%b%}\n"

    (( ret )) && r="%F{red}${(j:|:)pipes}%f "

    [[ -n $SSH_CONNECTION ]] && h="@%m"

    w=$(sed -E 's|(/\.?[^/])[^/]+/|\1/|g' <<< "${PWD/#$HOME/~}")

    PROMPT=" ${m}${r}%F{${THEME_USER:-blue}}%n${h}%f %F{${THEME_PATH:-cyan}}${w}%f %F{${THEME_SYMBOL:-white}}%#%f "
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

# alias d='dirs -v'
alias d='cd ${~"$(dirs -v | fzf | awk "{print \$2}")"}'
for index ({1..9}) alias "$index"="cd +${index}"
