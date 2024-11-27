alias vim="nvim"
alias py="python3"
alias mv="mv -i"
alias cp="cp -i"
alias rm="trash"
alias ls="eza"
alias tree="eza --tree --icons --git"
alias la="ls -AH"
alias ll="ls -lAH"
alias lt="eza --tree --level=2 --long --icons --git"
alias as="aerospace"

mcd() {
    mkdir "${1}" && cd "${1}"
}

ff() {
    aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}
