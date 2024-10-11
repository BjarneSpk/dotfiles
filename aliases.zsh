alias vim="nvim"
alias py="python3"
alias vimf='nvim $(fzf --algo=v1 --preview="bat --theme=ansi --color=always --style=numbers --line-range=:500 {}")'
alias openf='open $(fzf --algo=v1 --preview="bat --theme=ansi --color=always --style=numbers --line-range=:500 {}")'
alias mv="mv -i"
alias cp="cp -i"
alias rm="trash"

mcd() {
    mkdir "${1}" && cd "${1}"
}
