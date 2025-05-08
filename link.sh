#!/usr/bin/env zsh

link() {
  local target=$1
  local link=$2

  local parent_dir=$(dirname $link)
  if [[ ! -d $parent_dir ]]; then
    mkdir -p $parent_dir
  fi

  if [[ -e $link || -L $link ]]; then
    print -P "%F{yellow}Warning:%f Link target already exists: ${link}"
    print -P "Choose an option:"
    print -P "1) Replace (backup old file to ${link}.bak)"
    print -P "2) Skip this link"
    print -P "3) Abort operation"
    while true; do
      read -k "choice?Your choice [1/2/3]: "
      case $choice in
        1)
          print "\nBacking up existing file and creating new link"
          mv "$link" "${link}.bak"
          ln -sf "$target" "$link"
          return 0
          ;;
        2)
          print "\nSkipping this link"
          return 0
          ;;
        3)
          print "\nAborting operation"
          return 1
          ;;
        *)
          print "\nInvalid choice, please try again"
          ;;
      esac
    done
  else
    ln -s "$target" "$link"
  fi
}

source ./zsh/zshenv

link "${DOTFILES}/zsh/zshrc" "${XDG_CONFIG_HOME}/zsh/.zshrc"
link "${DOTFILES}/zsh/zprofile" "${XDG_CONFIG_HOME}/zsh/.zprofile"
link "${DOTFILES}/zsh/zshenv" "${HOME}/.zshenv"
link "${DOTFILES}/git/config" "${XDG_CONFIG_HOME}/git/config"
link "${DOTFILES}/nvim" "${XDG_CONFIG_HOME}/nvim"
link "${DOTFILES}/tmux.conf" "${XDG_CONFIG_HOME}/tmux/tmux.conf"
link "${DOTFILES}/yazi" "${XDG_CONFIG_HOME}/yazi"
link "${DOTFILES}/kitty" "${XDG_CONFIG_HOME}/kitty"
link "${DOTFILES}/bat" "${XDG_CONFIG_HOME}/bat"
link "${DOTFILES}/aerospace" "${XDG_CONFIG_HOME}/aerospace"
link "${DOTFILES}/hypr" "${XDG_CONFIG_HOME}/hypr"
link "${DOTFILES}/uwsm" "${XDG_CONFIG_HOME}/uwsm"
