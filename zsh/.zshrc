#!/usr/bin/env zsh

setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

PROMPT=' %F{#f6c177}%n%f %F{#ebbcba}%1~%f %F{#908caa}%#%f '

export LS_COLORS="di=38;2;235;188;186:fi=38;2;49;116;143:ln=38;2;235;111;146:*.=38;2;156;207;216"

source "${DOTFILES}/zsh/fzf.zsh"

# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

HIST_STAMPS="yyyy/mm/dd"

setopt HIST_IGNORE_SPACE

source "${DOTFILES}/zsh/aliases.zsh"

# Destroys the fzf **<tab> feature
bindkey -v
export KEYTIMEOUT=1
source "${DOTFILES}/zsh/cursor_mode.zsh"

# Emacs bindings
# bindkey -e

# completions
source "${DOTFILES}/zsh/completions.zsh"

source <(fzf --zsh)

eval "$(zoxide init zsh)"

fastfetch
