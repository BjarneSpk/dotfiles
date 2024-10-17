alias vim="nvim"
alias py="python3"
alias mv="mv -i"
alias cp="cp -i"
alias rm="trash"
alias server="ssh bjarne@188.245.73.235"

vimf() {
    local file=$(fzf --algo=v1 --preview="bat --theme=ansi --color=always --style=numbers --line-range=:500 {}")
    if [[ -n "$file" ]]; then
        nvim "$file"
    fi
}

openf() {
    local file=$(fzf --algo=v1 --preview="bat --theme=ansi --color=always --style=numbers --line-range=:500 {}")
    if [[ -n "$file" ]]; then
        open "$file"
    fi
}

mcd() {
    mkdir "${1}" && cd "${1}"
}
