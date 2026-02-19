#!/usr/bin/env zsh

setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

HIST_STAMPS="yyyy/mm/dd"

setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

source "$DOTFILES/dots/.config/zsh/colors.zsh"

source "${DOTFILES}/dots/.config/zsh/aliases.zsh"

bindkey -v
export KEYTIMEOUT=1

source "${DOTFILES}/dots/.config/zsh/cursor_mode.zsh"

# completions
source "${DOTFILES}/dots/.config/zsh/completions.zsh"
source "${DOTFILES}/dots/.config/zsh/netbird_completions.zsh"

source <(fzf --zsh)
source "${DOTFILES}/dots/.config/zsh/fzf.zsh"

export _ZO_ECHO=1
eval "$(zoxide init zsh)"
