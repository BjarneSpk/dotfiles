alias vim="nvim"
alias py="python3"
alias mv="mv -i"
alias cp="cp -i"
alias rm="trash"
alias ls="eza"
alias tree="eza --tree"
alias la="ls -AH"
alias ll="ls -lAH"

mcd() {
    mkdir "${1}" && cd "${1}"
}
